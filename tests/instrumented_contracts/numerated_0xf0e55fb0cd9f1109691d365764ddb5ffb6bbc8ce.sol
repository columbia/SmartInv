1 // File: contracts\ErrorReporter.sol
2 
3 pragma solidity ^0.5.16;
4 
5 contract ErrorReporter {
6     enum Error {
7         NO_ERROR,
8         UNAUTHORIZED,
9         BAD_INPUT,
10         REJECTION,
11         MATH_ERROR,
12         NOT_FRESH,
13         TOKEN_INSUFFICIENT_CASH,
14         TOKEN_TRANSFER_IN_FAILED,
15         TOKEN_TRANSFER_OUT_FAILED,
16         INSUFFICIENT_COLLATERAL
17     }
18 
19     /*
20      * Note: FailureInfo (but not Error) is kept in alphabetical order
21      *       This is because FailureInfo grows significantly faster, and
22      *       the order of Error has some meaning, while the order of FailureInfo
23      *       is entirely arbitrary.
24      */
25     enum FailureInfo {
26         ADMIN_CHECK,
27         PARTICIPANT_CHECK,
28         ACCRUE_INTEREST_FAILED,
29         ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED,
30         ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED,
31         ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED,
32         ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED,
33         ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED,
34         BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
35         BORROW_CASH_NOT_AVAILABLE,
36         BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
37         BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED,
38         BORROW_REJECTION,
39         BORROW_INSUFFICIENT_COLLATERAL,
40         MINT_REJECTION,
41         MINT_EXCHANGE_CALCULATION_FAILED,
42         MINT_EXCHANGE_RATE_READ_FAILED,
43         MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED,
44         MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
45         REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED,
46         REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED,
47         REDEEM_EXCHANGE_RATE_READ_FAILED,
48         REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED,
49         REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
50         REDEEM_TRANSFER_OUT_NOT_POSSIBLE,
51         REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
52         REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED,
53         REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
54         COLLATERALIZE_REJECTION,
55         REDEEM_COLLATERAL_ACCUMULATED_BORROW_CALCULATION_FAILED,
56         REDEEM_COLLATERAL_NEW_ACCOUNT_COLLATERAL_CALCULATION_FAILED,
57         REDEEM_COLLATERAL_INSUFFICIENT_COLLATERAL,
58         LIQUIDATE_BORROW_REJECTION,
59         LIQUIDATE_BORROW_COLLATERAL_RATE_CALCULATION_FAILED,
60         LIQUIDATE_BORROW_NOT_SATISFIED,
61         SET_RESERVE_FACTOR_BOUNDS_CHECK,
62         SET_LIQUIDATE_FACTOR_BOUNDS_CHECK,
63         TRANSFER_NOT_ALLOWED,
64         TRANSFER_NOT_ENOUGH,
65         TRANSFER_TOO_MUCH
66     }
67 
68     /**
69       * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
70       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
71       **/
72     event Failure(uint error, uint info, uint detail);
73 
74     /**
75       * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
76       */
77     function fail(Error err, FailureInfo info) internal returns (uint) {
78         emit Failure(uint(err), uint(info), 0);
79 
80         return uint(err);
81     }
82 
83     /**
84       * @dev use this when reporting an opaque error from an upgradeable collaborator contract
85       */
86     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
87         emit Failure(uint(err), uint(info), opaqueError);
88 
89         return uint(err);
90     }
91 }
92 
93 // File: contracts\EIP20Interface.sol
94 
95 pragma solidity ^0.5.8;
96 
97 /**
98  * @title ERC 20 Token Standard Interface
99  *  https://eips.ethereum.org/EIPS/eip-20
100  */
101 interface EIP20Interface {
102 
103     /**
104       * @notice Get the total number of tokens in circulation
105       * @return The supply of tokens
106       */
107     function totalSupply() external view returns (uint256);
108 
109     /**
110      * @notice Gets the balance of the specified address
111      * @param owner The address from which the balance will be retrieved
112      * @return The balance
113      */
114     function balanceOf(address owner) external view returns (uint256 balance);
115 
116     /**
117       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
118       * @param dst The address of the destination account
119       * @param amount The number of tokens to transfer
120       * @return Whether or not the transfer succeeded
121       */
122     function transfer(address dst, uint256 amount) external returns (bool success);
123 
124     /**
125       * @notice Transfer `amount` tokens from `src` to `dst`
126       * @param src The address of the source account
127       * @param dst The address of the destination account
128       * @param amount The number of tokens to transfer
129       * @return Whether or not the transfer succeeded
130       */
131     function transferFrom(address src, address dst, uint256 amount) external returns (bool success);
132 
133     /**
134       * @notice Approve `spender` to transfer up to `amount` from `src`
135       * @dev This will overwrite the approval amount for `spender`
136       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
137       * @param spender The address of the account which may transfer tokens
138       * @param amount The number of tokens that are approved (-1 means infinite)
139       * @return Whether or not the approval succeeded
140       */
141     function approve(address spender, uint256 amount) external returns (bool success);
142 
143     /**
144       * @notice Get the current allowance from `owner` for `spender`
145       * @param owner The address of the account which owns the tokens to be spent
146       * @param spender The address of the account which may transfer tokens
147       * @return The number of tokens allowed to be spent (-1 means infinite)
148       */
149     function allowance(address owner, address spender) external view returns (uint256 remaining);
150 
151     event Transfer(address indexed from, address indexed to, uint256 amount);
152     event Approval(address indexed owner, address indexed spender, uint256 amount);
153 }
154 
155 // File: contracts\EIP20NonStandardInterface.sol
156 
157 pragma solidity ^0.5.8;
158 
159 /**
160  * @title EIP20NonStandardInterface
161  * @dev Version of ERC20 with no return values for `transfer` and `transferFrom`
162  *  See https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
163  */
164 interface EIP20NonStandardInterface {
165 
166     /**
167      * @notice Get the total number of tokens in circulation
168      * @return The supply of tokens
169      */
170     function totalSupply() external view returns (uint256);
171 
172     /**
173      * @notice Gets the balance of the specified address
174      * @param owner The address from which the balance will be retrieved
175      * @return The balance
176      */
177     function balanceOf(address owner) external view returns (uint256 balance);
178 
179     ///
180     /// !!!!!!!!!!!!!!
181     /// !!! NOTICE !!! `transfer` does not return a value, in violation of the ERC-20 specification
182     /// !!!!!!!!!!!!!!
183     ///
184 
185     /**
186       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
187       * @param dst The address of the destination account
188       * @param amount The number of tokens to transfer
189       */
190     function transfer(address dst, uint256 amount) external;
191 
192     ///
193     /// !!!!!!!!!!!!!!
194     /// !!! NOTICE !!! `transferFrom` does not return a value, in violation of the ERC-20 specification
195     /// !!!!!!!!!!!!!!
196     ///
197 
198     /**
199       * @notice Transfer `amount` tokens from `src` to `dst`
200       * @param src The address of the source account
201       * @param dst The address of the destination account
202       * @param amount The number of tokens to transfer
203       */
204     function transferFrom(address src, address dst, uint256 amount) external;
205 
206     /**
207       * @notice Approve `spender` to transfer up to `amount` from `src`
208       * @dev This will overwrite the approval amount for `spender`
209       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
210       * @param spender The address of the account which may transfer tokens
211       * @param amount The number of tokens that are approved
212       * @return Whether or not the approval succeeded
213       */
214     function approve(address spender, uint256 amount) external returns (bool success);
215 
216     /**
217       * @notice Get the current allowance from `owner` for `spender`
218       * @param owner The address of the account which owns the tokens to be spent
219       * @param spender The address of the account which may transfer tokens
220       * @return The number of tokens allowed to be spent
221       */
222     function allowance(address owner, address spender) external view returns (uint256 remaining);
223 
224     event Transfer(address indexed from, address indexed to, uint256 amount);
225     event Approval(address indexed owner, address indexed spender, uint256 amount);
226 }
227 
228 // File: contracts\CarefulMath.sol
229 
230 // File: contracts/CarefulMath.sol
231 
232 pragma solidity ^0.5.8;
233 
234 /**
235   * @title Careful Math
236   * @author Compound
237   * @notice Derived from OpenZeppelin's SafeMath library
238   *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
239   */
240 contract CarefulMath {
241 
242     /**
243      * @dev Possible error codes that we can return
244      */
245     enum MathError {
246         NO_ERROR,
247         DIVISION_BY_ZERO,
248         INTEGER_OVERFLOW,
249         INTEGER_UNDERFLOW
250     }
251 
252     /**
253     * @dev Multiplies two numbers, returns an error on overflow.
254     */
255     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
256         if (a == 0) {
257             return (MathError.NO_ERROR, 0);
258         }
259 
260         uint c = a * b;
261 
262         if (c / a != b) {
263             return (MathError.INTEGER_OVERFLOW, 0);
264         } else {
265             return (MathError.NO_ERROR, c);
266         }
267     }
268 
269     /**
270     * @dev Integer division of two numbers, truncating the quotient.
271     */
272     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
273         if (b == 0) {
274             return (MathError.DIVISION_BY_ZERO, 0);
275         }
276 
277         return (MathError.NO_ERROR, a / b);
278     }
279 
280     /**
281     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
282     */
283     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
284         if (b <= a) {
285             return (MathError.NO_ERROR, a - b);
286         } else {
287             return (MathError.INTEGER_UNDERFLOW, 0);
288         }
289     }
290 
291     /**
292     * @dev Adds two numbers, returns an error on overflow.
293     */
294     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
295         uint c = a + b;
296 
297         if (c >= a) {
298             return (MathError.NO_ERROR, c);
299         } else {
300             return (MathError.INTEGER_OVERFLOW, 0);
301         }
302     }
303 
304     /**
305     * @dev add a and b and then subtract c
306     */
307     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
308         (MathError err0, uint sum) = addUInt(a, b);
309 
310         if (err0 != MathError.NO_ERROR) {
311             return (err0, 0);
312         }
313 
314         return subUInt(sum, c);
315     }
316 }
317 
318 // File: contracts\Exponential.sol
319 
320 pragma solidity ^0.5.16;
321 
322 
323 /**
324  * @title Exponential module for storing fixed-precision decimals
325  * @author Compound
326  * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
327  *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
328  *         `Exp({mantissa: 5100000000000000000})`.
329  */
330 contract Exponential is CarefulMath {
331     uint constant expScale = 1e18;
332     uint constant doubleScale = 1e36;
333     uint constant halfExpScale = expScale/2;
334     uint constant mantissaOne = expScale;
335 
336     struct Exp {
337         uint mantissa;
338     }
339 
340     struct Double {
341         uint mantissa;
342     }
343 
344     /**
345      * @dev Creates an exponential from numerator and denominator values.
346      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
347      *            or if `denom` is zero.
348      */
349     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
350         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
351         if (err0 != MathError.NO_ERROR) {
352             return (err0, Exp({mantissa: 0}));
353         }
354 
355         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
356         if (err1 != MathError.NO_ERROR) {
357             return (err1, Exp({mantissa: 0}));
358         }
359 
360         return (MathError.NO_ERROR, Exp({mantissa: rational}));
361     }
362 
363     /**
364      * @dev Adds two exponentials, returning a new exponential.
365      */
366     function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
367         (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);
368 
369         return (error, Exp({mantissa: result}));
370     }
371 
372     /**
373      * @dev Subtracts two exponentials, returning a new exponential.
374      */
375     function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
376         (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);
377 
378         return (error, Exp({mantissa: result}));
379     }
380 
381     /**
382      * @dev Multiply an Exp by a scalar, returning a new Exp.
383      */
384     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
385         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
386         if (err0 != MathError.NO_ERROR) {
387             return (err0, Exp({mantissa: 0}));
388         }
389 
390         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
391     }
392 
393     /**
394      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
395      */
396     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
397         (MathError err, Exp memory product) = mulScalar(a, scalar);
398         if (err != MathError.NO_ERROR) {
399             return (err, 0);
400         }
401 
402         return (MathError.NO_ERROR, truncate(product));
403     }
404 
405     /**
406      * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
407      */
408     function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
409         (MathError err, Exp memory product) = mulScalar(a, scalar);
410         if (err != MathError.NO_ERROR) {
411             return (err, 0);
412         }
413 
414         return addUInt(truncate(product), addend);
415     }
416 
417     /**
418      * @dev Divide an Exp by a scalar, returning a new Exp.
419      */
420     function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
421         (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
422         if (err0 != MathError.NO_ERROR) {
423             return (err0, Exp({mantissa: 0}));
424         }
425 
426         return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
427     }
428 
429     /**
430      * @dev Divide a scalar by an Exp, returning a new Exp.
431      */
432     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
433         /*
434           We are doing this as:
435           getExp(mulUInt(expScale, scalar), divisor.mantissa)
436 
437           How it works:
438           Exp = a / b;
439           Scalar = s;
440           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
441         */
442         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
443         if (err0 != MathError.NO_ERROR) {
444             return (err0, Exp({mantissa: 0}));
445         }
446         return getExp(numerator, divisor.mantissa);
447     }
448 
449     /**
450      * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
451      */
452     function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
453         (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
454         if (err != MathError.NO_ERROR) {
455             return (err, 0);
456         }
457 
458         return (MathError.NO_ERROR, truncate(fraction));
459     }
460 
461     /**
462      * @dev Multiplies two exponentials, returning a new exponential.
463      */
464     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
465 
466         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
467         if (err0 != MathError.NO_ERROR) {
468             return (err0, Exp({mantissa: 0}));
469         }
470 
471         // We add half the scale before dividing so that we get rounding instead of truncation.
472         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
473         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
474         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
475         if (err1 != MathError.NO_ERROR) {
476             return (err1, Exp({mantissa: 0}));
477         }
478 
479         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
480         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
481         assert(err2 == MathError.NO_ERROR);
482 
483         return (MathError.NO_ERROR, Exp({mantissa: product}));
484     }
485 
486     /**
487      * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
488      */
489     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
490         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
491     }
492 
493     /**
494      * @dev Multiplies three exponentials, returning a new exponential.
495      */
496     function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
497         (MathError err, Exp memory ab) = mulExp(a, b);
498         if (err != MathError.NO_ERROR) {
499             return (err, ab);
500         }
501         return mulExp(ab, c);
502     }
503 
504     /**
505      * @dev Divides two exponentials, returning a new exponential.
506      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
507      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
508      */
509     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
510         return getExp(a.mantissa, b.mantissa);
511     }
512 
513     /**
514      * @dev Truncates the given exp to a whole number value.
515      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
516      */
517     function truncate(Exp memory exp) pure internal returns (uint) {
518         // Note: We are not using careful math here as we're performing a division that cannot fail
519         return exp.mantissa / expScale;
520     }
521 
522     /**
523      * @dev Checks if first Exp is less than second Exp.
524      */
525     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
526         return left.mantissa < right.mantissa;
527     }
528 
529     /**
530      * @dev Checks if left Exp <= right Exp.
531      */
532     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
533         return left.mantissa <= right.mantissa;
534     }
535 
536     /**
537      * @dev Checks if left Exp > right Exp.
538      */
539     function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
540         return left.mantissa > right.mantissa;
541     }
542 
543     /**
544      * @dev returns true if Exp is exactly zero
545      */
546     function isZeroExp(Exp memory value) pure internal returns (bool) {
547         return value.mantissa == 0;
548     }
549 
550     function safe224(uint n, string memory errorMessage) pure internal returns (uint224) {
551         require(n < 2**224, errorMessage);
552         return uint224(n);
553     }
554 
555     function safe32(uint n, string memory errorMessage) pure internal returns (uint32) {
556         require(n < 2**32, errorMessage);
557         return uint32(n);
558     }
559 
560     function add_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
561         return Exp({mantissa: add_(a.mantissa, b.mantissa)});
562     }
563 
564     function add_(Double memory a, Double memory b) pure internal returns (Double memory) {
565         return Double({mantissa: add_(a.mantissa, b.mantissa)});
566     }
567 
568     function add_(uint a, uint b) pure internal returns (uint) {
569         return add_(a, b, "addition overflow");
570     }
571 
572     function add_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
573         uint c = a + b;
574         require(c >= a, errorMessage);
575         return c;
576     }
577 
578     function sub_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
579         return Exp({mantissa: sub_(a.mantissa, b.mantissa)});
580     }
581 
582     function sub_(Double memory a, Double memory b) pure internal returns (Double memory) {
583         return Double({mantissa: sub_(a.mantissa, b.mantissa)});
584     }
585 
586     function sub_(uint a, uint b) pure internal returns (uint) {
587         return sub_(a, b, "subtraction underflow");
588     }
589 
590     function sub_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
591         require(b <= a, errorMessage);
592         return a - b;
593     }
594 
595     function mul_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
596         return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});
597     }
598 
599     function mul_(Exp memory a, uint b) pure internal returns (Exp memory) {
600         return Exp({mantissa: mul_(a.mantissa, b)});
601     }
602 
603     function mul_(uint a, Exp memory b) pure internal returns (uint) {
604         return mul_(a, b.mantissa) / expScale;
605     }
606 
607     function mul_(Double memory a, Double memory b) pure internal returns (Double memory) {
608         return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});
609     }
610 
611     function mul_(Double memory a, uint b) pure internal returns (Double memory) {
612         return Double({mantissa: mul_(a.mantissa, b)});
613     }
614 
615     function mul_(uint a, Double memory b) pure internal returns (uint) {
616         return mul_(a, b.mantissa) / doubleScale;
617     }
618 
619     function mul_(uint a, uint b) pure internal returns (uint) {
620         return mul_(a, b, "multiplication overflow");
621     }
622 
623     function mul_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
624         if (a == 0 || b == 0) {
625             return 0;
626         }
627         uint c = a * b;
628         require(c / a == b, errorMessage);
629         return c;
630     }
631 
632     function div_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
633         return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});
634     }
635 
636     function div_(Exp memory a, uint b) pure internal returns (Exp memory) {
637         return Exp({mantissa: div_(a.mantissa, b)});
638     }
639 
640     function div_(uint a, Exp memory b) pure internal returns (uint) {
641         return div_(mul_(a, expScale), b.mantissa);
642     }
643 
644     function div_(Double memory a, Double memory b) pure internal returns (Double memory) {
645         return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});
646     }
647 
648     function div_(Double memory a, uint b) pure internal returns (Double memory) {
649         return Double({mantissa: div_(a.mantissa, b)});
650     }
651 
652     function div_(uint a, Double memory b) pure internal returns (uint) {
653         return div_(mul_(a, doubleScale), b.mantissa);
654     }
655 
656     function div_(uint a, uint b) pure internal returns (uint) {
657         return div_(a, b, "divide by zero");
658     }
659 
660     function div_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
661         require(b > 0, errorMessage);
662         return a / b;
663     }
664 
665     function fraction(uint a, uint b) pure internal returns (Double memory) {
666         return Double({mantissa: div_(mul_(a, doubleScale), b)});
667     }
668 }
669 
670 // File: contracts\InterestRateModel.sol
671 
672 pragma solidity ^0.5.16;
673 
674 /**
675   * @title Compound's InterestRateModel Interface
676   * @author Compound
677   */
678 contract InterestRateModel {
679     /// @notice Indicator that this is an InterestRateModel contract (for inspection)
680     bool public constant isInterestRateModel = true;
681 
682     /**
683       * @notice Calculates the current borrow interest rate per block
684       * @param cash The total amount of cash the market has
685       * @param borrows The total amount of borrows the market has outstanding
686       * @param reserves The total amnount of reserves the market has
687       * @return The borrow rate per block (as a percentage, and scaled by 1e18)
688       */
689     function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint);
690 
691     /**
692       * @notice Calculates the current supply interest rate per block
693       * @param cash The total amount of cash the market has
694       * @param borrows The total amount of borrows the market has outstanding
695       * @param reserves The total amnount of reserves the market has
696       * @param reserveFactorMantissa The current reserve factor the market has
697       * @return The supply rate per block (as a percentage, and scaled by 1e18)
698       */
699     function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);
700 
701 }
702 
703 // File: contracts\DFL.sol
704 
705 pragma solidity ^0.5.16;
706 pragma experimental ABIEncoderV2;
707 
708 
709 // forked from Compound/COMP
710 
711 /**
712  * @dev Contract module which provides a basic access control mechanism, where
713  * there is an account (an owner) that can be granted exclusive access to
714  * specific functions.
715  *
716  * By default, the owner account will be the one that deploys the contract. This
717  * can later be changed with {transferOwnership}.
718  *
719  * This module is used through inheritance. It will make available the modifier
720  * `onlyOwner`, which can be applied to your functions to restrict their use to
721  * the owner.
722  */
723 contract Ownable {
724     address private _owner;
725 
726     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
727 
728     /**
729      * @dev Initializes the contract setting the deployer as the initial owner.
730      */
731     constructor () internal {
732         _owner = msg.sender;
733         emit OwnershipTransferred(address(0), msg.sender);
734     }
735 
736     /**
737      * @dev Returns the address of the current owner.
738      */
739     function owner() public view returns (address) {
740         return _owner;
741     }
742 
743     /**
744      * @dev Throws if called by any account other than the owner.
745      */
746     modifier onlyOwner() {
747         require(_owner == msg.sender, "Ownable: caller is not the owner");
748         _;
749     }
750 
751     /**
752      * @dev Leaves the contract without owner. It will not be possible to call
753      * `onlyOwner` functions anymore. Can only be called by the current owner.
754      *
755      * NOTE: Renouncing ownership will leave the contract without an owner,
756      * thereby removing any functionality that is only available to the owner.
757      */
758     function renounceOwnership() public onlyOwner {
759         emit OwnershipTransferred(_owner, address(0));
760         _owner = address(0);
761     }
762 
763     /**
764      * @dev Transfers ownership of the contract to a new account (`newOwner`).
765      * Can only be called by the current owner.
766      */
767     function transferOwnership(address newOwner) public onlyOwner {
768         require(newOwner != address(0), "Ownable: new owner is the zero address");
769         emit OwnershipTransferred(_owner, newOwner);
770         _owner = newOwner;
771     }
772 }
773 
774 contract DFL is EIP20Interface, Ownable {
775     /// @notice EIP-20 token name for this token
776     string public constant name = "DeFIL";
777 
778     /// @notice EIP-20 token symbol for this token
779     string public constant symbol = "DFL";
780 
781     /// @notice EIP-20 token decimals for this token
782     uint8 public constant decimals = 18;
783 
784     /// @notice Total number of tokens in circulation
785     uint96 internal _totalSupply;
786 
787     /// @notice Allowance amounts on behalf of others
788     mapping (address => mapping (address => uint96)) internal allowances;
789 
790     /// @notice Official record of token balances for each account
791     mapping (address => uint96) internal balances;
792 
793     /// @notice A record of each accounts delegate
794     mapping (address => address) public delegates;
795 
796     /// @notice A checkpoint for marking number of votes from a given block
797     struct Checkpoint {
798         uint32 fromBlock;
799         uint96 votes;
800     }
801 
802     /// @notice A record of votes checkpoints for each account, by index
803     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
804 
805     /// @notice The number of checkpoints for each account
806     mapping (address => uint32) public numCheckpoints;
807 
808     /// @notice The EIP-712 typehash for the contract's domain
809     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
810 
811     /// @notice The EIP-712 typehash for the delegation struct used by the contract
812     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
813 
814     /// @notice A record of states for signing / validating signatures
815     mapping (address => uint) public nonces;
816 
817     /// @notice An event thats emitted when an account changes its delegate
818     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
819 
820     /// @notice An event thats emitted when a delegate account's vote balance changes
821     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
822 
823     /// @notice The standard EIP-20 transfer event
824     event Transfer(address indexed from, address indexed to, uint256 amount);
825 
826     /// @notice The standard EIP-20 approval event
827     event Approval(address indexed owner, address indexed spender, uint256 amount);
828 
829     /**
830      * @notice Construct a new DFL token
831      */
832     constructor() public {
833         emit Transfer(address(0), address(this), 0);
834     }
835 
836     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
837      * the total supply.
838      * Emits a {Transfer} event with `from` set to the zero address.
839      * @param account The address of the account holding the new funds
840      * @param rawAmount The number of tokens that are minted
841      */
842     function mint(address account, uint rawAmount) public onlyOwner {
843         require(account != address(0), "DFL:: mint: cannot mint to the zero address");
844         uint96 amount = safe96(rawAmount, "DFL::mint: amount exceeds 96 bits");
845         _totalSupply = add96(_totalSupply, amount, "DFL::mint: total supply exceeds");
846         balances[account] = add96(balances[account], amount, "DFL::mint: mint amount exceeds balance");
847 
848         _moveDelegates(address(0), delegates[account], amount);
849         emit Transfer(address(0), account, amount);
850     }
851 
852     /**
853      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
854      * @param account The address of the account holding the funds
855      * @param spender The address of the account spending the funds
856      * @return The number of tokens approved
857      */
858     function allowance(address account, address spender) external view returns (uint) {
859         return allowances[account][spender];
860     }
861 
862     /**
863      * @notice Approve `spender` to transfer up to `amount` from `src`
864      * @dev This will overwrite the approval amount for `spender`
865      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
866      * @param spender The address of the account which may transfer tokens
867      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
868      * @return Whether or not the approval succeeded
869      */
870     function approve(address spender, uint rawAmount) external returns (bool) {
871         uint96 amount;
872         if (rawAmount == uint(-1)) {
873             amount = uint96(-1);
874         } else {
875             amount = safe96(rawAmount, "DFL::approve: amount exceeds 96 bits");
876         }
877 
878         allowances[msg.sender][spender] = amount;
879 
880         emit Approval(msg.sender, spender, amount);
881         return true;
882     }
883 
884     /**
885      * @notice Get the total supply of tokens
886      * @return The total supply of tokens
887      */
888     function totalSupply() external view returns (uint) {
889         return _totalSupply;
890     }
891 
892     /**
893      * @notice Get the number of tokens held by the `account`
894      * @param account The address of the account to get the balance of
895      * @return The number of tokens held
896      */
897     function balanceOf(address account) external view returns (uint) {
898         return balances[account];
899     }
900 
901     /**
902      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
903      * @param dst The address of the destination account
904      * @param rawAmount The number of tokens to transfer
905      * @return Whether or not the transfer succeeded
906      */
907     function transfer(address dst, uint rawAmount) external returns (bool) {
908         uint96 amount = safe96(rawAmount, "DFL::transfer: amount exceeds 96 bits");
909         _transferTokens(msg.sender, dst, amount);
910         return true;
911     }
912 
913     /**
914      * @notice Transfer `amount` tokens from `src` to `dst`
915      * @param src The address of the source account
916      * @param dst The address of the destination account
917      * @param rawAmount The number of tokens to transfer
918      * @return Whether or not the transfer succeeded
919      */
920     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
921         address spender = msg.sender;
922         uint96 spenderAllowance = allowances[src][spender];
923         uint96 amount = safe96(rawAmount, "DFL::approve: amount exceeds 96 bits");
924 
925         if (spender != src && spenderAllowance != uint96(-1)) {
926             uint96 newAllowance = sub96(spenderAllowance, amount, "DFL::transferFrom: transfer amount exceeds spender allowance");
927             allowances[src][spender] = newAllowance;
928 
929             emit Approval(src, spender, newAllowance);
930         }
931 
932         _transferTokens(src, dst, amount);
933         return true;
934     }
935 
936     /**
937      * @notice Delegate votes from `msg.sender` to `delegatee`
938      * @param delegatee The address to delegate votes to
939      */
940     function delegate(address delegatee) public {
941         return _delegate(msg.sender, delegatee);
942     }
943 
944     /**
945      * @notice Delegates votes from signatory to `delegatee`
946      * @param delegatee The address to delegate votes to
947      * @param nonce The contract state required to match the signature
948      * @param expiry The time at which to expire the signature
949      * @param v The recovery byte of the signature
950      * @param r Half of the ECDSA signature pair
951      * @param s Half of the ECDSA signature pair
952      */
953     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
954         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
955         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
956         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
957         address signatory = ecrecover(digest, v, r, s);
958         require(signatory != address(0), "DFL::delegateBySig: invalid signature");
959         require(nonce == nonces[signatory]++, "DFL::delegateBySig: invalid nonce");
960         require(block.timestamp <= expiry, "DFL::delegateBySig: signature expired");
961         return _delegate(signatory, delegatee);
962     }
963 
964     /**
965      * @notice Gets the current votes balance for `account`
966      * @param account The address to get votes balance
967      * @return The number of current votes for `account`
968      */
969     function getCurrentVotes(address account) external view returns (uint96) {
970         uint32 nCheckpoints = numCheckpoints[account];
971         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
972     }
973 
974     /**
975      * @notice Determine the prior number of votes for an account as of a block number
976      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
977      * @param account The address of the account to check
978      * @param blockNumber The block number to get the vote balance at
979      * @return The number of votes the account had as of the given block
980      */
981     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
982         require(blockNumber < block.number, "DFL::getPriorVotes: not yet determined");
983 
984         uint32 nCheckpoints = numCheckpoints[account];
985         if (nCheckpoints == 0) {
986             return 0;
987         }
988 
989         // First check most recent balance
990         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
991             return checkpoints[account][nCheckpoints - 1].votes;
992         }
993 
994         // Next check implicit zero balance
995         if (checkpoints[account][0].fromBlock > blockNumber) {
996             return 0;
997         }
998 
999         uint32 lower = 0;
1000         uint32 upper = nCheckpoints - 1;
1001         while (upper > lower) {
1002             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1003             Checkpoint memory cp = checkpoints[account][center];
1004             if (cp.fromBlock == blockNumber) {
1005                 return cp.votes;
1006             } else if (cp.fromBlock < blockNumber) {
1007                 lower = center;
1008             } else {
1009                 upper = center - 1;
1010             }
1011         }
1012         return checkpoints[account][lower].votes;
1013     }
1014 
1015     function _delegate(address delegator, address delegatee) internal {
1016         address currentDelegate = delegates[delegator];
1017         uint96 delegatorBalance = balances[delegator];
1018         delegates[delegator] = delegatee;
1019 
1020         emit DelegateChanged(delegator, currentDelegate, delegatee);
1021 
1022         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1023     }
1024 
1025     function _transferTokens(address src, address dst, uint96 amount) internal {
1026         require(src != address(0), "DFL::_transferTokens: cannot transfer from the zero address");
1027         require(dst != address(0), "DFL::_transferTokens: cannot transfer to the zero address");
1028 
1029         balances[src] = sub96(balances[src], amount, "DFL::_transferTokens: transfer amount exceeds balance");
1030         balances[dst] = add96(balances[dst], amount, "DFL::_transferTokens: transfer amount overflows");
1031         emit Transfer(src, dst, amount);
1032 
1033         _moveDelegates(delegates[src], delegates[dst], amount);
1034     }
1035 
1036     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
1037         if (srcRep != dstRep && amount > 0) {
1038             if (srcRep != address(0)) {
1039                 uint32 srcRepNum = numCheckpoints[srcRep];
1040                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1041                 uint96 srcRepNew = sub96(srcRepOld, amount, "DFL::_moveVotes: vote amount underflows");
1042                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1043             }
1044 
1045             if (dstRep != address(0)) {
1046                 uint32 dstRepNum = numCheckpoints[dstRep];
1047                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1048                 uint96 dstRepNew = add96(dstRepOld, amount, "DFL::_moveVotes: vote amount overflows");
1049                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1050             }
1051         }
1052     }
1053 
1054     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
1055       uint32 blockNumber = safe32(block.number, "DFL::_writeCheckpoint: block number exceeds 32 bits");
1056 
1057       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1058           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1059       } else {
1060           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1061           numCheckpoints[delegatee] = nCheckpoints + 1;
1062       }
1063 
1064       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1065     }
1066 
1067     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1068         require(n < 2**32, errorMessage);
1069         return uint32(n);
1070     }
1071 
1072     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
1073         require(n < 2**96, errorMessage);
1074         return uint96(n);
1075     }
1076 
1077     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
1078         uint96 c = a + b;
1079         require(c >= a, errorMessage);
1080         return c;
1081     }
1082 
1083     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
1084         require(b <= a, errorMessage);
1085         return a - b;
1086     }
1087 
1088     function getChainId() internal pure returns (uint) {
1089         uint256 chainId;
1090         assembly { chainId := chainid() }
1091         return chainId;
1092     }
1093 }
1094 
1095 // File: contracts\ReentrancyGuard.sol
1096 
1097 pragma solidity ^0.5.16;
1098 
1099 /**
1100  * @dev Contract module that helps prevent reentrant calls to a function.
1101  *
1102  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1103  * available, which can be applied to functions to make sure there are no nested
1104  * (reentrant) calls to them.
1105  *
1106  * Note that because there is a single `nonReentrant` guard, functions marked as
1107  * `nonReentrant` may not call one another. This can be worked around by making
1108  * those functions `private`, and then adding `external` `nonReentrant` entry
1109  * points to them.
1110  *
1111  * TIP: If you would like to learn more about reentrancy and alternative ways
1112  * to protect against it, check out our blog post
1113  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1114  */
1115 contract ReentrancyGuard {
1116     // Booleans are more expensive than uint256 or any type that takes up a full
1117     // word because each write operation emits an extra SLOAD to first read the
1118     // slot's contents, replace the bits taken up by the boolean, and then write
1119     // back. This is the compiler's defense against contract upgrades and
1120     // pointer aliasing, and it cannot be disabled.
1121 
1122     // The values being non-zero value makes deployment a bit more expensive,
1123     // but in exchange the refund on every call to nonReentrant will be lower in
1124     // amount. Since refunds are capped to a percentage of the total
1125     // transaction's gas, it is best to keep them low in cases like this one, to
1126     // increase the likelihood of the full refund coming into effect.
1127     uint256 private constant _NOT_ENTERED = 1;
1128     uint256 private constant _ENTERED = 2;
1129 
1130     uint256 private _status;
1131 
1132     constructor () internal {
1133         _status = _NOT_ENTERED;
1134     }
1135 
1136     /**
1137      * @dev Prevents a contract from calling itself, directly or indirectly.
1138      * Calling a `nonReentrant` function from another `nonReentrant`
1139      * function is not supported. It is possible to prevent this from happening
1140      * by making the `nonReentrant` function external, and make it call a
1141      * `private` function that does the actual work.
1142      */
1143     modifier nonReentrant() {
1144         // On the first call to nonReentrant, _notEntered will be true
1145         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1146 
1147         // Any calls to nonReentrant after this point will fail
1148         _status = _ENTERED;
1149 
1150         _;
1151 
1152         // By storing the original value once again, a refund is triggered (see
1153         // https://eips.ethereum.org/EIPS/eip-2200)
1154         _status = _NOT_ENTERED;
1155     }
1156 }
1157 
1158 // File: contracts\DeFIL.sol
1159 
1160 pragma solidity ^0.5.16;
1161 
1162 // Forked from Compound/CToken
1163 
1164 
1165 
1166 
1167 
1168 
1169 
1170 
1171 contract DeFIL is ReentrancyGuard, EIP20Interface, Exponential, ErrorReporter {
1172     /**
1173      * @notice EIP-20 token name for this token
1174      */
1175     string public constant name = "Certificate of eFIL";
1176     /**
1177      * @notice EIP-20 token symbol for this token
1178      */
1179     string public constant symbol = "ceFIL";
1180     /**
1181      * @notice EIP-20 token decimals for this token
1182      */
1183     uint8 public constant decimals = 18;
1184     /**
1185      * @notice Maximum fraction of interest that can be set aside for reserves
1186      */
1187     uint internal constant reserveFactorMaxMantissa = 1e18;
1188     /**
1189      * @notice Address of eFIL token
1190      */
1191     address public eFILAddress;
1192     /**
1193      * @notice Address of mFIL token
1194      */
1195     address public mFILAddress;
1196     /**
1197      * @notice The address who owns the reserves
1198      */
1199     address public reservesOwner;
1200     /**
1201      * @notice Administrator for this contract
1202      */
1203     address public admin;
1204     /**
1205      * @notice Pending administrator for this contract
1206      */
1207     address public pendingAdmin;
1208     /**
1209      * @notice Model which tells what the current interest rate should be
1210      */
1211     InterestRateModel public interestRateModel;
1212     /**
1213      * @notice Initial exchange rate used when minting the first CTokens (used when totalSupply = 0)
1214      */
1215     uint internal constant initialExchangeRateMantissa = 0.002e18; // 1 eFIL = 500 ceFIL
1216     /**
1217      * @notice Fraction of interest currently set aside for reserves
1218      */
1219     uint public reserveFactorMantissa;
1220     /**
1221      * @notice Block number that interest was last accrued at
1222      */
1223     uint public accrualBlockNumber;
1224     /**
1225      * @notice Accumulator of the total earned interest rate since the opening
1226      */
1227     uint public borrowIndex;
1228     /**
1229      * @notice Total amount of outstanding borrows of the underlying
1230      */
1231     uint public totalBorrows;
1232     /**
1233      * @notice Total amount of reserves of the underlying held
1234      */
1235     uint public totalReserves;
1236     /**
1237      * @notice Total number of tokens in circulation
1238      */
1239     uint public totalSupply;
1240 
1241     // Is mint allowed.
1242     bool public mintAllowed;
1243     // Is borrow allowed.
1244     bool public borrowAllowed;
1245     /**
1246      * @notice Official record of token balances for each account
1247      */
1248     mapping (address => uint) internal accountTokens;
1249     /**
1250      * @notice Approved token transfer amounts on behalf of others
1251      */
1252     mapping (address => mapping (address => uint)) internal transferAllowances;
1253 
1254     /**
1255      * @notice Container for borrow balance information
1256      * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action
1257      * @member interestIndex Global borrowIndex as of the most recent balance-changing action
1258      */
1259     struct BorrowSnapshot {
1260         uint principal;
1261         uint interestIndex;
1262     }
1263     /**
1264      * @notice Mapping of account addresses to outstanding borrow balances
1265      */
1266     mapping(address => BorrowSnapshot) internal accountBorrows;
1267 
1268     // Total collaterals
1269     uint public totalCollaterals;
1270     // Mapping of account to outstanding collateral balances
1271     mapping (address => uint) internal accountCollaterals;
1272     // Multiplier used to decide when liquidate borrow is allowed
1273     uint public liquidateFactorMantissa;
1274     // No liquidateFactorMantissa may bellows this value
1275     uint internal constant liquidateFactorMinMantissa = 1e18; // 100%
1276 
1277     /*** For DFL ***/
1278     /**
1279      * @notice Address of DFL token
1280      */
1281     DFL public dflToken;
1282     // By using the special 'min speed=0.00017e18' and 'start speed=86.805721e18'
1283     // We will got 99999999.8568 DFLs in the end.
1284     // The havle period in block number
1285     uint internal constant halvePeriod = 576000; // 100 days
1286     // Minimum speed
1287     uint internal constant minSpeed = 0.00017e18; // 1e18 / 5760
1288     // Current speed (per block)
1289     uint public currentSpeed = 86.805721e18; // 500000e18 / 5760; // start with 500,000 per day
1290     // The block number when next havle will happens
1291     uint public nextHalveBlockNumber;
1292 
1293     // The address of uniswap incentive contract for receiving DFL
1294     address public uniswapAddress;
1295     // The address of miner league for receiving DFL
1296     address public minerLeagueAddress;
1297     // The address of operator for receiving DFL
1298     address public operatorAddress;
1299     // The address of technical support for receiving DFL
1300     address public technicalAddress;
1301     // The address for undistributed DFL
1302     address public undistributedAddress;
1303 
1304     // The percentage of DFL distributes to uniswap incentive
1305     uint public uniswapPercentage;
1306     // The percentage of DFL distributes to miner league
1307     uint public minerLeaguePercentage;
1308     // The percentage of DFL distributes to operator
1309     uint public operatorPercentage;
1310     // The percentage of DFL distributes to technical support, unupdatable
1311     uint internal constant technicalPercentage = 0.02e18; // 2%
1312 
1313     // The threshold above which the flywheel transfers DFL
1314     uint internal constant dflClaimThreshold = 0.1e18; // 0.1 DFL
1315     // Block number that DFL was last accrued at
1316     uint public dflAccrualBlockNumber;
1317     // The last updated index of DFL for suppliers
1318     uint public dflSupplyIndex;
1319     // The initial dfl supply index
1320     uint internal constant dflInitialSupplyIndex = 1e36;
1321     // The index for each supplier as of the last time they accrued DFL
1322     mapping(address => uint) public dflSupplierIndex;
1323     // The DFL accrued but not yet transferred to each user
1324     mapping(address => uint) public dflAccrued;
1325 
1326     /*** Events ***/
1327     /**
1328      * @notice Event emitted when interest is accrued
1329      */
1330     event AccrueInterest(uint cashPrior, uint interestAccumulated, uint borrowIndex, uint totalBorrows);
1331     /**
1332      * @notice Event emitted when tokens are minted
1333      */
1334     event Mint(address minter, uint mintAmount, uint mintTokens);
1335     /**
1336      * @notice Event emitted when mFIL are collateralized
1337      */
1338     event Collateralize(address collateralizer, uint collateralizeAmount);
1339     /**
1340      * @notice Event emitted when tokens are redeemed
1341      */
1342     event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);
1343     /**
1344      * @notice Event emitted when underlying is borrowed
1345      */
1346     event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);
1347     /**
1348      * @notice Event emitted when a borrow is repaid
1349      */
1350     event RepayBorrow(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);
1351     /**
1352      * @notice Event emitted when collaterals are redeemed
1353      */
1354     event RedeemCollateral(address redeemer, uint redeemAmount);
1355     /**
1356      * @notice Event emitted when a liquidate borrow is repaid
1357      */
1358     event LiquidateBorrow(address liquidator, address borrower, uint accountBorrows, uint accountCollaterals);
1359 
1360     /*** Admin Events ***/
1361     /**
1362      * @notice Event emitted when pendingAdmin is changed
1363      */
1364     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
1365     /**
1366      * @notice Event emitted when pendingAdmin is accepted, which means admin is updated
1367      */
1368     event NewAdmin(address oldAdmin, address newAdmin);
1369     /**
1370      * @notice Event emitted when mintAllowed is changed
1371      */
1372     event MintAllowed(bool mintAllowed);
1373     /**
1374      * @notice Event emitted when borrowAllowed is changed
1375      */
1376     event BorrowAllowed(bool borrowAllowed);
1377     /**
1378      * @notice Event emitted when interestRateModel is changed
1379      */
1380     event NewInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);
1381     /**
1382      * @notice Event emitted when the reserve factor is changed
1383      */
1384     event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);
1385     /**
1386      * @notice Event emitted when the liquidate factor is changed
1387      */
1388     event NewLiquidateFactor(uint oldLiquidateFactorMantissa, uint newLiquidateFactorMantissa);
1389     /**
1390      * @notice EIP20 Transfer event
1391      */
1392     event Transfer(address indexed from, address indexed to, uint amount);
1393     /**
1394      * @notice EIP20 Approval event
1395      */
1396     event Approval(address indexed owner, address indexed spender, uint amount);
1397     /**
1398      * @notice Failure event
1399      */
1400     event Failure(uint error, uint info, uint detail);
1401 
1402     // Event emitted when reserves owner is changed
1403     event ReservesOwnerChanged(address oldAddress, address newAddress);
1404     // Event emitted when uniswap address is changed
1405     event UniswapAddressChanged(address oldAddress, address newAddress);
1406     // Event emitted when miner leagure address is changed
1407     event MinerLeagueAddressChanged(address oldAddress, address newAddress);
1408     // Event emitted when operator address is changed
1409     event OperatorAddressChanged(address oldAddress, address newAddress);
1410     // Event emitted when technical address is changed
1411     event TechnicalAddressChanged(address oldAddress, address newAddress);
1412     // Event emitted when undistributed address is changed
1413     event UndistributedAddressChanged(address oldAddress, address newAddress);
1414     // Event emitted when reserved is reduced
1415     event ReservesReduced(address toTho, uint amount);
1416     // Event emitted when DFL is accrued
1417     event AccrueDFL(uint uniswapPart, uint minerLeaguePart, uint operatorPart, uint technicalPart, uint supplyPart, uint dflSupplyIndex);
1418     // Emitted when DFL is distributed to a supplier
1419     event DistributedDFL(address supplier, uint supplierDelta);
1420     // Event emitted when DFL percentage is changed
1421     event PercentagesChanged(uint uniswapPercentage, uint minerLeaguePercentage, uint operatorPercentage);
1422 
1423     /**
1424      * @notice constructor
1425      */
1426     constructor(address interestRateModelAddress,
1427                 address eFILAddress_,
1428                 address mFILAddress_,
1429                 address dflAddress_,
1430                 address reservesOwner_,
1431                 address uniswapAddress_,
1432                 address minerLeagueAddress_,
1433                 address operatorAddress_,
1434                 address technicalAddress_,
1435                 address undistributedAddress_) public {
1436         // set admin
1437         admin = msg.sender;
1438 
1439         // Initialize block number and borrow index
1440         accrualBlockNumber = getBlockNumber();
1441         borrowIndex = mantissaOne;
1442 
1443         // reserve 50%
1444         uint err = _setReserveFactorFresh(0.5e18);
1445         require(err == uint(Error.NO_ERROR), "setting reserve factor failed");
1446 
1447         // set liquidate factor to 200%
1448         err = _setLiquidateFactorFresh(2e18);
1449         require(err == uint(Error.NO_ERROR), "setting liquidate factor failed");
1450 
1451         // Set the interest rate model (depends on block number / borrow index)
1452         err = _setInterestRateModelFresh(InterestRateModel(interestRateModelAddress));
1453         require(err == uint(Error.NO_ERROR), "setting interest rate model failed");
1454 
1455         // uniswapPercentage = 0.25e18; // 25%
1456         // minerLeaguePercentage = 0.1e18; // 10%
1457         // operatorPercentage = 0.03e18; // 3%
1458         err = _setDFLPercentagesFresh(0.25e18, 0.1e18, 0.03e18);
1459         require(err == uint(Error.NO_ERROR), "setting DFL percentages failed");
1460 
1461         // allow mint/borrow
1462         mintAllowed = true;
1463         borrowAllowed = true;
1464 
1465         // token addresses & tokens
1466         eFILAddress = eFILAddress_;
1467         mFILAddress = mFILAddress_;
1468         dflToken = DFL(dflAddress_);
1469         // set owner of reserves
1470         reservesOwner = reservesOwner_;
1471 
1472         // DFL
1473         dflAccrualBlockNumber = getBlockNumber();
1474         dflSupplyIndex = dflInitialSupplyIndex;
1475         nextHalveBlockNumber = dflAccrualBlockNumber + halvePeriod;
1476 
1477         // DFL addresses
1478         uniswapAddress = uniswapAddress_;
1479         minerLeagueAddress = minerLeagueAddress_;
1480         operatorAddress = operatorAddress_;
1481         technicalAddress = technicalAddress_;
1482         undistributedAddress = undistributedAddress_;
1483 
1484         emit Transfer(address(0), address(this), 0);
1485     }
1486 
1487     /**
1488      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
1489      * @dev Called by both `transfer` and `transferFrom` internally
1490      * @param spender The address of the account performing the transfer
1491      * @param src The address of the source account
1492      * @param dst The address of the destination account
1493      * @param tokens The number of tokens to transfer
1494      * @return Whether or not the transfer succeeded
1495      */
1496     function transferTokens(address spender, address src, address dst, uint tokens) internal returns (uint) {
1497         /* Do not allow self-transfers */
1498         if (src == dst || dst == address(0)) {
1499             return fail(Error.BAD_INPUT, FailureInfo.TRANSFER_NOT_ALLOWED);
1500         }
1501 
1502         // Keep the flywheel moving
1503         accrueDFL();
1504         distributeSupplierDFL(src, false);
1505         distributeSupplierDFL(dst, false);
1506 
1507         /* Get the allowance, infinite for the account owner */
1508         uint startingAllowance = 0;
1509         if (spender == src) {
1510             startingAllowance = uint(-1);
1511         } else {
1512             startingAllowance = transferAllowances[src][spender];
1513         }
1514 
1515         /* Do the calculations, checking for {under,over}flow */
1516         MathError mathErr;
1517         uint allowanceNew;
1518         uint srcTokensNew;
1519         uint dstTokensNew;
1520 
1521         (mathErr, allowanceNew) = subUInt(startingAllowance, tokens);
1522         if (mathErr != MathError.NO_ERROR) {
1523             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ALLOWED);
1524         }
1525 
1526         (mathErr, srcTokensNew) = subUInt(accountTokens[src], tokens);
1527         if (mathErr != MathError.NO_ERROR) {
1528             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ENOUGH);
1529         }
1530 
1531         (mathErr, dstTokensNew) = addUInt(accountTokens[dst], tokens);
1532         if (mathErr != MathError.NO_ERROR) {
1533             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_TOO_MUCH);
1534         }
1535 
1536         /////////////////////////
1537         // EFFECTS & INTERACTIONS
1538         // (No safe failures beyond this point)
1539 
1540         accountTokens[src] = srcTokensNew;
1541         accountTokens[dst] = dstTokensNew;
1542 
1543         /* Eat some of the allowance (if necessary) */
1544         if (startingAllowance != uint(-1)) {
1545             transferAllowances[src][spender] = allowanceNew;
1546         }
1547 
1548         /* We emit a Transfer event */
1549         emit Transfer(src, dst, tokens);
1550         return uint(Error.NO_ERROR);
1551     }
1552 
1553     /**
1554      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1555      * @param dst The address of the destination account
1556      * @param amount The number of tokens to transfer
1557      * @return Whether or not the transfer succeeded
1558      */
1559     function transfer(address dst, uint256 amount) external nonReentrant returns (bool) {
1560         return transferTokens(msg.sender, msg.sender, dst, amount) == uint(Error.NO_ERROR);
1561     }
1562 
1563     /**
1564      * @notice Transfer `amount` tokens from `src` to `dst`
1565      * @param src The address of the source account
1566      * @param dst The address of the destination account
1567      * @param amount The number of tokens to transfer
1568      * @return Whether or not the transfer succeeded
1569      */
1570     function transferFrom(address src, address dst, uint256 amount) external nonReentrant returns (bool) {
1571         return transferTokens(msg.sender, src, dst, amount) == uint(Error.NO_ERROR);
1572     }
1573 
1574     /**
1575      * @notice Approve `spender` to transfer up to `amount` from `src`
1576      * @dev This will overwrite the approval amount for `spender`
1577      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1578      * @param spender The address of the account which may transfer tokens
1579      * @param amount The number of tokens that are approved (-1 means infinite)
1580      * @return Whether or not the approval succeeded
1581      */
1582     function approve(address spender, uint256 amount) external returns (bool) {
1583         require(spender != address(0), "cannot approve to the zero address");
1584         address src = msg.sender;
1585         transferAllowances[src][spender] = amount;
1586         emit Approval(src, spender, amount);
1587         return true;
1588     }
1589 
1590     /**
1591      * @notice Get the current allowance from `owner` for `spender`
1592      * @param owner The address of the account which owns the tokens to be spent
1593      * @param spender The address of the account which may transfer tokens
1594      * @return The number of tokens allowed to be spent (-1 means infinite)
1595      */
1596     function allowance(address owner, address spender) external view returns (uint256) {
1597         return transferAllowances[owner][spender];
1598     }
1599 
1600     /**
1601      * @notice Get the token balance of the `owner`
1602      * @param owner The address of the account to query
1603      * @return The number of tokens owned by `owner`
1604      */
1605     function balanceOf(address owner) external view returns (uint256) {
1606         return accountTokens[owner];
1607     }
1608 
1609     /**
1610      * @notice Get the underlying balance of the `owner`
1611      * @dev This also accrues interest in a transaction
1612      * @param owner The address of the account to query
1613      * @return The amount of underlying owned by `owner`
1614      */
1615     function balanceOfUnderlying(address owner) external returns (uint) {
1616         Exp memory exchangeRate = Exp({mantissa: exchangeRateCurrent()});
1617         (MathError mErr, uint balance) = mulScalarTruncate(exchangeRate, accountTokens[owner]);
1618         require(mErr == MathError.NO_ERROR, "balance could not be calculated");
1619         return balance;
1620     }
1621 
1622     /**
1623      * @notice Get the collateral of the `account`
1624      * @param account The address of the account to query
1625      * @return The number of collaterals owned by `account`
1626      */
1627     function getCollateral(address account) external view returns (uint256) {
1628         return accountCollaterals[account];
1629     }
1630 
1631     /**
1632      * @dev Function to simply retrieve block number
1633      *  This exists mainly for inheriting test contracts to stub this result.
1634      */
1635     function getBlockNumber() internal view returns (uint) {
1636         return block.number;
1637     }
1638 
1639     /**
1640      * @notice Returns the current per-block borrow interest rate
1641      * @return The borrow interest rate per block, scaled by 1e18
1642      */
1643     function borrowRatePerBlock() external view returns (uint) {
1644         return interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1645     }
1646 
1647     /**
1648      * @notice Returns the current per-block supply interest rate
1649      * @return The supply interest rate per block, scaled by 1e18
1650      */
1651     function supplyRatePerBlock() external view returns (uint) {
1652         return interestRateModel.getSupplyRate(getCashPrior(), totalBorrows, totalReserves, reserveFactorMantissa);
1653     }
1654 
1655     /**
1656      * @notice Returns the current total borrows plus accrued interest
1657      * @return The total borrows with interest
1658      */
1659     function totalBorrowsCurrent() external nonReentrant returns (uint) {
1660         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1661         return totalBorrows;
1662     }
1663 
1664     /**
1665      * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
1666      * @param account The address whose balance should be calculated after updating borrowIndex
1667      * @return The calculated balance
1668      */
1669     function borrowBalanceCurrent(address account) external nonReentrant returns (uint) {
1670         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1671         return borrowBalanceStored(account);
1672     }
1673 
1674     /**
1675      * @notice Return the borrow balance of account based on stored data
1676      * @param account The address whose balance should be calculated
1677      * @return The calculated balance
1678      */
1679     function borrowBalanceStored(address account) public view returns (uint) {
1680         (MathError err, uint result) = borrowBalanceStoredInternal(account);
1681         require(err == MathError.NO_ERROR, "borrowBalanceStored: borrowBalanceStoredInternal failed");
1682         return result;
1683     }
1684 
1685     /**
1686      * @notice Return the borrow balance of account based on stored data
1687      * @param account The address whose balance should be calculated
1688      * @return (error code, the calculated balance or 0 if error code is non-zero)
1689      */
1690     function borrowBalanceStoredInternal(address account) internal view returns (MathError, uint) {
1691         /* Note: we do not assert that is up to date */
1692         MathError mathErr;
1693         uint principalTimesIndex;
1694         uint result;
1695 
1696         /* Get borrowBalance and borrowIndex */
1697         BorrowSnapshot storage borrowSnapshot = accountBorrows[account];
1698 
1699         /* If borrowBalance = 0 then borrowIndex is likely also 0.
1700          * Rather than failing the calculation with a division by 0, we immediately return 0 in this case.
1701          */
1702         if (borrowSnapshot.principal == 0) {
1703             return (MathError.NO_ERROR, 0);
1704         }
1705 
1706         /* Calculate new borrow balance using the interest index:
1707          *  recentBorrowBalance = borrower.borrowBalance * global.borrowIndex / borrower.borrowIndex
1708          */
1709         (mathErr, principalTimesIndex) = mulUInt(borrowSnapshot.principal, borrowIndex);
1710         if (mathErr != MathError.NO_ERROR) {
1711             return (mathErr, 0);
1712         }
1713 
1714         (mathErr, result) = divUInt(principalTimesIndex, borrowSnapshot.interestIndex);
1715         if (mathErr != MathError.NO_ERROR) {
1716             return (mathErr, 0);
1717         }
1718 
1719         return (MathError.NO_ERROR, result);
1720     }
1721 
1722     /**
1723      * @notice Accrue interest then return the up-to-date exchange rate
1724      * @return Calculated exchange rate scaled by 1e18
1725      */
1726     function exchangeRateCurrent() public returns (uint) {
1727         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1728         return exchangeRateStored();
1729     }
1730 
1731     /**
1732      * @notice Calculates the exchange rate from the underlying to the ceFIL
1733      * @dev This function does not accrue interest before calculating the exchange rate
1734      * @return Calculated exchange rate scaled by 1e18
1735      */
1736     function exchangeRateStored() public view returns (uint) {
1737         (MathError err, uint result) = exchangeRateStoredInternal();
1738         require(err == MathError.NO_ERROR, "exchangeRateStored: exchangeRateStoredInternal failed");
1739         return result;
1740     }
1741 
1742     /**
1743      * @notice Calculates the exchange rate from the underlying to the ceFIL
1744      * @dev This function does not accrue interest before calculating the exchange rate
1745      * @return (error code, calculated exchange rate scaled by 1e18)
1746      */
1747     function exchangeRateStoredInternal() internal view returns (MathError, uint) {
1748         uint _totalSupply = totalSupply;
1749         if (_totalSupply == 0) {
1750             /*
1751              * If there are no tokens minted:
1752              *  exchangeRate = initialExchangeRate
1753              */
1754             return (MathError.NO_ERROR, initialExchangeRateMantissa);
1755         } else {
1756             /*
1757              * Otherwise:
1758              *  exchangeRate = (totalCash + totalBorrows - totalReserves) / totalSupply
1759              */
1760             uint totalCash = getCashPrior();
1761             uint cashPlusBorrowsMinusReserves;
1762             Exp memory exchangeRate;
1763             MathError mathErr;
1764 
1765             (mathErr, cashPlusBorrowsMinusReserves) = addThenSubUInt(totalCash, totalBorrows, totalReserves);
1766             if (mathErr != MathError.NO_ERROR) {
1767                 return (mathErr, 0);
1768             }
1769 
1770             (mathErr, exchangeRate) = getExp(cashPlusBorrowsMinusReserves, _totalSupply);
1771             if (mathErr != MathError.NO_ERROR) {
1772                 return (mathErr, 0);
1773             }
1774 
1775             return (MathError.NO_ERROR, exchangeRate.mantissa);
1776         }
1777     }
1778 
1779     /**
1780      * @notice Accrue interest then return the up-to-date collateral rate
1781      * @return Calculated collateral rate scaled by 1e18
1782      */
1783     function collateralRateCurrent(address borrower) external returns (uint) {
1784         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1785         return collateralRateStored(borrower);
1786     }
1787 
1788     /**
1789      * @notice Calculates the collateral rate of borrower from stored states
1790      * @dev This function does not accrue interest before calculating the collateral rate
1791      * @return Calculated exchange rate scaled by 1e18
1792      */
1793     function collateralRateStored(address borrower) public view returns (uint) {
1794         (MathError err, uint rate, ,) = collateralRateInternal(borrower);
1795         require(err == MathError.NO_ERROR, "collateralRateStored: collateralRateInternal failed");
1796         return rate;
1797     }
1798 
1799     function collateralRateInternal(address borrower) internal view returns (MathError, uint, uint, uint) {
1800         MathError mathErr;
1801         uint _accountBorrows;
1802         uint _accountCollaterals;
1803         Exp memory collateralRate;
1804 
1805         (mathErr, _accountBorrows) = borrowBalanceStoredInternal(borrower);
1806         if (mathErr != MathError.NO_ERROR) {
1807             return (mathErr, 0, 0, 0);
1808         }
1809 
1810         _accountCollaterals = accountCollaterals[borrower];
1811         (mathErr, collateralRate) = getExp(_accountBorrows, _accountCollaterals);
1812         if (mathErr != MathError.NO_ERROR) {
1813             return (mathErr, 0, 0, 0);
1814         }
1815 
1816         return (MathError.NO_ERROR, collateralRate.mantissa, _accountBorrows, _accountCollaterals);
1817     }
1818 
1819     // Accrue DFL then return the up-to-date accrued amount
1820     function accruedDFLCurrent(address supplier) external nonReentrant returns (uint) {
1821         accrueDFL();
1822         return accruedDFLStoredInternal(supplier);
1823     }
1824 
1825     // Accrue DFL then return the up-to-date accrued amount
1826     function accruedDFLStored(address supplier) public view returns (uint) {
1827         return accruedDFLStoredInternal(supplier);
1828     }
1829 
1830     // Return the accrued DFL of account based on stored data
1831     function accruedDFLStoredInternal(address supplier) internal view returns(uint) {
1832         Double memory supplyIndex = Double({mantissa: dflSupplyIndex});
1833         Double memory supplierIndex = Double({mantissa: dflSupplierIndex[supplier]});
1834         if (supplierIndex.mantissa == 0 && supplyIndex.mantissa > 0) {
1835             supplierIndex.mantissa = dflInitialSupplyIndex;
1836         }
1837 
1838         Double memory deltaIndex = sub_(supplyIndex, supplierIndex);
1839         uint supplierDelta = mul_(accountTokens[supplier], deltaIndex);
1840         uint supplierAccrued = add_(dflAccrued[supplier], supplierDelta);
1841         return supplierAccrued;
1842     }
1843 
1844     /**
1845      * @notice Get cash balance of this in the underlying asset
1846      * @return The quantity of underlying asset owned by this contract
1847      */
1848     function getCash() external view returns (uint) {
1849         return getCashPrior();
1850     }
1851 
1852     /**
1853      * @notice Applies accrued interest to total borrows and reserves
1854      * @dev This calculates interest accrued from the last checkpointed block
1855      *   up to the current block and writes new checkpoint to storage.
1856      */
1857     function accrueInterest() public returns (uint) {
1858         /* Remember the initial block number */
1859         uint currentBlockNumber = getBlockNumber();
1860         uint accrualBlockNumberPrior = accrualBlockNumber;
1861 
1862         /* Short-circuit accumulating 0 interest */
1863         if (accrualBlockNumberPrior == currentBlockNumber) {
1864             return uint(Error.NO_ERROR);
1865         }
1866 
1867         /* Read the previous values out of storage */
1868         uint cashPrior = getCashPrior();
1869         uint borrowsPrior = totalBorrows;
1870         uint reservesPrior = totalReserves;
1871         uint borrowIndexPrior = borrowIndex;
1872 
1873         /* Calculate the current borrow interest rate */
1874         uint borrowRateMantissa = interestRateModel.getBorrowRate(cashPrior, borrowsPrior, reservesPrior);
1875 
1876         /* Calculate the number of blocks elapsed since the last accrual */
1877         (MathError mathErr, uint blockDelta) = subUInt(currentBlockNumber, accrualBlockNumberPrior);
1878         require(mathErr == MathError.NO_ERROR, "could not calculate block delta");
1879 
1880         /*
1881          * Calculate the interest accumulated into borrows and reserves and the new index:
1882          *  simpleInterestFactor = borrowRate * blockDelta
1883          *  interestAccumulated = simpleInterestFactor * totalBorrows
1884          *  totalBorrowsNew = interestAccumulated + totalBorrows
1885          *  totalReservesNew = interestAccumulated * reserveFactor + totalReserves
1886          *  borrowIndexNew = simpleInterestFactor * borrowIndex + borrowIndex
1887          */
1888 
1889         Exp memory simpleInterestFactor;
1890         uint interestAccumulated;
1891         uint totalBorrowsNew;
1892         uint totalReservesNew;
1893         uint borrowIndexNew;
1894 
1895         (mathErr, simpleInterestFactor) = mulScalar(Exp({mantissa: borrowRateMantissa}), blockDelta);
1896         if (mathErr != MathError.NO_ERROR) {
1897             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED, uint(mathErr));
1898         }
1899 
1900         (mathErr, interestAccumulated) = mulScalarTruncate(simpleInterestFactor, borrowsPrior);
1901         if (mathErr != MathError.NO_ERROR) {
1902             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED, uint(mathErr));
1903         }
1904 
1905         (mathErr, totalBorrowsNew) = addUInt(interestAccumulated, borrowsPrior);
1906         if (mathErr != MathError.NO_ERROR) {
1907             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED, uint(mathErr));
1908         }
1909 
1910         (mathErr, totalReservesNew) = mulScalarTruncateAddUInt(Exp({mantissa: reserveFactorMantissa}), interestAccumulated, reservesPrior);
1911         if (mathErr != MathError.NO_ERROR) {
1912             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED, uint(mathErr));
1913         }
1914 
1915         (mathErr, borrowIndexNew) = mulScalarTruncateAddUInt(simpleInterestFactor, borrowIndexPrior, borrowIndexPrior);
1916         if (mathErr != MathError.NO_ERROR) {
1917             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED, uint(mathErr));
1918         }
1919 
1920         /////////////////////////
1921         // EFFECTS & INTERACTIONS
1922         // (No safe failures beyond this point)
1923 
1924         /* We write the previously calculated values into storage */
1925         accrualBlockNumber = currentBlockNumber;
1926         borrowIndex = borrowIndexNew;
1927         totalBorrows = totalBorrowsNew;
1928         totalReserves = totalReservesNew;
1929 
1930         /* We emit an AccrueInterest event */
1931         emit AccrueInterest(cashPrior, interestAccumulated, borrowIndexNew, totalBorrowsNew);
1932 
1933         return uint(Error.NO_ERROR);
1934     }
1935 
1936     /**
1937      * @notice Sender supplies assets into and receives cTokens in exchange
1938      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1939      * @param mintAmount The amount of the underlying asset to supply
1940      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1941      */
1942     function mint(uint mintAmount) external nonReentrant returns (uint) {
1943         uint err = accrueInterest();
1944         if (err != uint(Error.NO_ERROR)) {
1945             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1946             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
1947         }
1948 
1949         // Keep the flywheel moving
1950         accrueDFL();
1951         distributeSupplierDFL(msg.sender, false);
1952 
1953         // mintFresh emits the actual Mint event if successful and logs on errors, so we don't need to
1954         (err,) = mintFresh(msg.sender, mintAmount);
1955         return err;
1956     }
1957 
1958     struct MintLocalVars {
1959         Error err;
1960         MathError mathErr;
1961         uint exchangeRateMantissa;
1962         uint mintTokens;
1963         uint totalSupplyNew;
1964         uint accountTokensNew;
1965         uint actualMintAmount;
1966     }
1967 
1968     /**
1969      * @notice User supplies assets into and receives cTokens in exchange
1970      * @dev Assumes interest has already been accrued up to the current block
1971      * @param minter The address of the account which is supplying the assets
1972      * @param mintAmount The amount of the underlying asset to supply
1973      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual mint amount.
1974      */
1975     function mintFresh(address minter, uint mintAmount) internal returns (uint, uint) {
1976         if (!mintAllowed || accountCollaterals[minter] != 0) {
1977             return (fail(Error.REJECTION, FailureInfo.MINT_REJECTION), 0);
1978         }
1979 
1980         MintLocalVars memory vars;
1981 
1982         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
1983         if (vars.mathErr != MathError.NO_ERROR) {
1984             return (failOpaque(Error.MATH_ERROR, FailureInfo.MINT_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr)), 0);
1985         }
1986 
1987         /////////////////////////
1988         // EFFECTS & INTERACTIONS
1989         // (No safe failures beyond this point)
1990         vars.actualMintAmount = doTransferIn(eFILAddress, minter, mintAmount);
1991 
1992         /*
1993          * We get the current exchange rate and calculate the number of cTokens to be minted:
1994          *  mintTokens = actualMintAmount / exchangeRate
1995          */
1996 
1997         (vars.mathErr, vars.mintTokens) = divScalarByExpTruncate(vars.actualMintAmount, Exp({mantissa: vars.exchangeRateMantissa}));
1998         require(vars.mathErr == MathError.NO_ERROR, "MINT_EXCHANGE_CALCULATION_FAILED");
1999 
2000         /*
2001          * We calculate the new total supply of cTokens and minter token balance, checking for overflow:
2002          *  totalSupplyNew = totalSupply + mintTokens
2003          *  accountTokensNew = accountTokens[minter] + mintTokens
2004          */
2005         (vars.mathErr, vars.totalSupplyNew) = addUInt(totalSupply, vars.mintTokens);
2006         require(vars.mathErr == MathError.NO_ERROR, "MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED");
2007 
2008         (vars.mathErr, vars.accountTokensNew) = addUInt(accountTokens[minter], vars.mintTokens);
2009         require(vars.mathErr == MathError.NO_ERROR, "MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED");
2010 
2011         /* We write previously calculated values into storage */
2012         totalSupply = vars.totalSupplyNew;
2013         accountTokens[minter] = vars.accountTokensNew;
2014 
2015         /* We emit a Mint event, and a Transfer event */
2016         emit Mint(minter, vars.actualMintAmount, vars.mintTokens);
2017         emit Transfer(address(this), minter, vars.mintTokens);
2018 
2019         return (uint(Error.NO_ERROR), vars.actualMintAmount);
2020     }
2021 
2022     /**
2023      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2024      * @param collateralizeAmount The amount of the underlying asset to collateralize
2025      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2026      */
2027     function collateralize(uint collateralizeAmount) external nonReentrant returns (uint) {
2028         uint err = accrueInterest();
2029         if (err != uint(Error.NO_ERROR)) {
2030             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
2031             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
2032         }
2033 
2034         // Keep the flywheel moving
2035         accrueDFL();
2036 
2037         (err,) = collateralizeFresh(msg.sender, collateralizeAmount);
2038         return err;
2039     }
2040 
2041     struct CollateralizeLocalVars {
2042         Error err;
2043         MathError mathErr;
2044         uint totalCollateralsNew;
2045         uint accountCollateralsNew;
2046         uint actualCollateralizeAmount;
2047     }
2048 
2049     /**
2050      * @param collateralizer The address of the account which is supplying the assets
2051      * @param collateralizeAmount The amount of the underlying asset to supply
2052      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual collateralize amount.
2053      */
2054     function collateralizeFresh(address collateralizer, uint collateralizeAmount) internal returns (uint, uint) {
2055         if (accountTokens[collateralizer] != 0) {
2056             return (fail(Error.REJECTION, FailureInfo.COLLATERALIZE_REJECTION), 0);
2057         }
2058 
2059         CollateralizeLocalVars memory vars;
2060 
2061         /////////////////////////
2062         // EFFECTS & INTERACTIONS
2063         // (No safe failures beyond this point)
2064         vars.actualCollateralizeAmount = doTransferIn(mFILAddress, collateralizer, collateralizeAmount);
2065 
2066         (vars.mathErr, vars.totalCollateralsNew) = addUInt(totalCollaterals, vars.actualCollateralizeAmount);
2067         require(vars.mathErr == MathError.NO_ERROR, "COLLATERALIZE_NEW_TOTAL_COLLATERALS_CALCULATION_FAILED");
2068 
2069         (vars.mathErr, vars.accountCollateralsNew) = addUInt(accountCollaterals[collateralizer], vars.actualCollateralizeAmount);
2070         require(vars.mathErr == MathError.NO_ERROR, "COLLATERALIZE_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED");
2071 
2072         /* We write previously calculated values into storage */
2073         totalCollaterals = vars.totalCollateralsNew;
2074         accountCollaterals[collateralizer] = vars.accountCollateralsNew;
2075 
2076         /* We emit a Collateralize event, and a Transfer event */
2077         emit Collateralize(collateralizer, vars.actualCollateralizeAmount);
2078         return (uint(Error.NO_ERROR), vars.actualCollateralizeAmount);
2079     }
2080 
2081     /**
2082      * @notice Sender redeems cTokens in exchange for the underlying asset
2083      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2084      * @param redeemTokens The number of cTokens to redeem into underlying
2085      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2086      */
2087     function redeem(uint redeemTokens) external nonReentrant returns (uint) {
2088         uint err = accrueInterest();
2089         if (err != uint(Error.NO_ERROR)) {
2090             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
2091             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
2092         }
2093 
2094         // Keep the flywheel moving
2095         accrueDFL();
2096         distributeSupplierDFL(msg.sender, false);
2097 
2098         // redeemFresh emits redeem-specific logs on errors, so we don't need to
2099         return redeemFresh(msg.sender, redeemTokens, 0);
2100     }
2101 
2102     /**
2103      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
2104      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2105      * @param redeemAmount The amount of underlying to redeem
2106      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2107      */
2108     function redeemUnderlying(uint redeemAmount) external nonReentrant returns (uint) {
2109         uint err = accrueInterest();
2110         if (err != uint(Error.NO_ERROR)) {
2111             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
2112             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
2113         }
2114         // Keep the flywheel moving
2115         accrueDFL();
2116         distributeSupplierDFL(msg.sender, false);
2117 
2118         // redeemFresh emits redeem-specific logs on errors, so we don't need to
2119         return redeemFresh(msg.sender, 0, redeemAmount);
2120     }
2121 
2122     struct RedeemLocalVars {
2123         Error err;
2124         MathError mathErr;
2125         uint exchangeRateMantissa;
2126         uint redeemTokens;
2127         uint redeemAmount;
2128         uint totalSupplyNew;
2129         uint accountTokensNew;
2130     }
2131 
2132     /**
2133      * @notice User redeems cTokens in exchange for the underlying asset
2134      * @dev Assumes interest has already been accrued up to the current block
2135      * @param redeemer The address of the account which is redeeming the tokens
2136      * @param redeemTokensIn The number of cTokens to redeem into underlying (only one of redeemTokensIn or redeemAmountIn may be non-zero)
2137      * @param redeemAmountIn The number of underlying tokens to receive from redeeming cTokens (only one of redeemTokensIn or redeemAmountIn may be non-zero)
2138      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2139      */
2140     function redeemFresh(address redeemer, uint redeemTokensIn, uint redeemAmountIn) internal returns (uint) {
2141         require(redeemTokensIn == 0 || redeemAmountIn == 0, "one of redeemTokensIn or redeemAmountIn must be zero");
2142 
2143         RedeemLocalVars memory vars;
2144 
2145         /* exchangeRate = invoke Exchange Rate Stored() */
2146         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
2147         if (vars.mathErr != MathError.NO_ERROR) {
2148             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr));
2149         }
2150 
2151         /* If redeemTokensIn > 0: */
2152         if (redeemTokensIn > 0) {
2153             /*
2154              * We calculate the exchange rate and the amount of underlying to be redeemed:
2155              *  redeemTokens = redeemTokensIn
2156              *  redeemAmount = redeemTokensIn x exchangeRateCurrent
2157              */
2158             vars.redeemTokens = redeemTokensIn;
2159 
2160             (vars.mathErr, vars.redeemAmount) = mulScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), redeemTokensIn);
2161             if (vars.mathErr != MathError.NO_ERROR) {
2162                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED, uint(vars.mathErr));
2163             }
2164         } else {
2165             /*
2166              * We get the current exchange rate and calculate the amount to be redeemed:
2167              *  redeemTokens = redeemAmountIn / exchangeRate
2168              *  redeemAmount = redeemAmountIn
2169              */
2170 
2171             (vars.mathErr, vars.redeemTokens) = divScalarByExpTruncate(redeemAmountIn, Exp({mantissa: vars.exchangeRateMantissa}));
2172             if (vars.mathErr != MathError.NO_ERROR) {
2173                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED, uint(vars.mathErr));
2174             }
2175 
2176             vars.redeemAmount = redeemAmountIn;
2177         }
2178 
2179         /*
2180          * We calculate the new total supply and redeemer balance, checking for underflow:
2181          *  totalSupplyNew = totalSupply - redeemTokens
2182          *  accountTokensNew = accountTokens[redeemer] - redeemTokens
2183          */
2184         (vars.mathErr, vars.totalSupplyNew) = subUInt(totalSupply, vars.redeemTokens);
2185         if (vars.mathErr != MathError.NO_ERROR) {
2186             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, uint(vars.mathErr));
2187         }
2188 
2189         (vars.mathErr, vars.accountTokensNew) = subUInt(accountTokens[redeemer], vars.redeemTokens);
2190         if (vars.mathErr != MathError.NO_ERROR) {
2191             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
2192         }
2193 
2194         /* Fail gracefully if protocol has insufficient cash */
2195         if (getCashPrior() < vars.redeemAmount) {
2196             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDEEM_TRANSFER_OUT_NOT_POSSIBLE);
2197         }
2198 
2199         /////////////////////////
2200         // EFFECTS & INTERACTIONS
2201         // (No safe failures beyond this point)
2202         doTransferOut(eFILAddress, redeemer, vars.redeemAmount);
2203 
2204         /* We write previously calculated values into storage */
2205         totalSupply = vars.totalSupplyNew;
2206         accountTokens[redeemer] = vars.accountTokensNew;
2207 
2208         /* We emit a Transfer event, and a Redeem event */
2209         emit Transfer(redeemer, address(this), vars.redeemTokens);
2210         emit Redeem(redeemer, vars.redeemAmount, vars.redeemTokens);
2211         return uint(Error.NO_ERROR);
2212     }
2213 
2214     /**
2215       * @notice Sender borrows assets from the protocol to their own address
2216       * @param borrowAmount The amount of the underlying asset to borrow
2217       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2218       */
2219     function borrow(uint borrowAmount) external nonReentrant returns (uint) {
2220         uint err = accrueInterest();
2221         if (err != uint(Error.NO_ERROR)) {
2222             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
2223             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
2224         }
2225         // Keep the flywheel moving
2226         accrueDFL();
2227 
2228         // borrowFresh emits borrow-specific logs on errors, so we don't need to
2229         return borrowFresh(msg.sender, borrowAmount);
2230     }
2231 
2232     struct BorrowLocalVars {
2233         MathError mathErr;
2234         uint actualBorrowAmount;
2235         uint accountBorrows;
2236         uint accountBorrowsNew;
2237         uint totalBorrowsNew;
2238     }
2239 
2240     /**
2241       * @notice Users borrow assets from the protocol to their own address
2242       * @param borrowAmount The amount of the underlying asset to borrow
2243       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2244       */
2245     function borrowFresh(address borrower, uint borrowAmount) internal returns (uint) {
2246         if (!borrowAllowed) {
2247             return fail(Error.REJECTION, FailureInfo.BORROW_REJECTION);
2248         }
2249 
2250         BorrowLocalVars memory vars;
2251 
2252         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
2253         if (vars.mathErr != MathError.NO_ERROR) {
2254             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
2255         }
2256 
2257         if (borrowAmount == uint(-1)) {
2258             vars.actualBorrowAmount = accountCollaterals[borrower] > vars.accountBorrows ? accountCollaterals[borrower] - vars.accountBorrows : 0;
2259         } else {
2260             vars.actualBorrowAmount = borrowAmount;
2261         }
2262 
2263         /* Fail gracefully if protocol has insufficient underlying cash */
2264         if (getCashPrior() < vars.actualBorrowAmount) {
2265             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.BORROW_CASH_NOT_AVAILABLE);
2266         }
2267 
2268         /*
2269          * We calculate the new borrower and total borrow balances, failing on overflow:
2270          *  accountBorrowsNew = accountBorrows + actualBorrowAmount
2271          *  totalBorrowsNew = totalBorrows + actualBorrowAmount
2272          */
2273         (vars.mathErr, vars.accountBorrowsNew) = addUInt(vars.accountBorrows, vars.actualBorrowAmount);
2274         if (vars.mathErr != MathError.NO_ERROR) {
2275             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
2276         }
2277 
2278         // Check collaterals
2279         if (accountCollaterals[borrower] < vars.accountBorrowsNew) {
2280             return fail(Error.INSUFFICIENT_COLLATERAL, FailureInfo.BORROW_INSUFFICIENT_COLLATERAL);
2281         }
2282 
2283         (vars.mathErr, vars.totalBorrowsNew) = addUInt(totalBorrows, vars.actualBorrowAmount);
2284         if (vars.mathErr != MathError.NO_ERROR) {
2285             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
2286         }
2287 
2288         /////////////////////////
2289         // EFFECTS & INTERACTIONS
2290         // (No safe failures beyond this point)
2291         doTransferOut(eFILAddress, borrower, vars.actualBorrowAmount);
2292 
2293         /* We write the previously calculated values into storage */
2294         accountBorrows[borrower].principal = vars.accountBorrowsNew;
2295         accountBorrows[borrower].interestIndex = borrowIndex;
2296         totalBorrows = vars.totalBorrowsNew;
2297 
2298         /* We emit a Borrow event */
2299         emit Borrow(borrower, vars.actualBorrowAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
2300         return uint(Error.NO_ERROR);
2301     }
2302 
2303     /**
2304      * @notice Sender repays their own borrow
2305      * @param repayAmount The amount to repay
2306      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2307      */
2308     function repayBorrow(uint repayAmount) external nonReentrant returns (uint) {
2309         uint err = accrueInterest();
2310         if (err != uint(Error.NO_ERROR)) {
2311             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
2312             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
2313         }
2314         // Keep the flywheel moving
2315         accrueDFL();
2316 
2317         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
2318         (err,) = repayBorrowFresh(msg.sender, msg.sender, repayAmount);
2319         return err;
2320     }
2321 
2322     /**
2323      * @notice Sender repays a borrow belonging to borrower
2324      * @param borrower the account with the debt being payed off
2325      * @param repayAmount The amount to repay
2326      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2327      */
2328     function repayBorrowBehalf(address borrower, uint repayAmount) external nonReentrant returns (uint) {
2329         uint err = accrueInterest();
2330         if (err != uint(Error.NO_ERROR)) {
2331             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
2332             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
2333         }
2334         // Keep the flywheel moving
2335         accrueDFL();
2336 
2337         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
2338         (err,) = repayBorrowFresh(msg.sender, borrower, repayAmount);
2339         return err;
2340     }
2341 
2342     struct RepayBorrowLocalVars {
2343         Error err;
2344         MathError mathErr;
2345         uint repayAmount;
2346         uint borrowerIndex;
2347         uint accountBorrows;
2348         uint accountBorrowsNew;
2349         uint totalBorrowsNew;
2350         uint actualRepayAmount;
2351     }
2352 
2353     /**
2354      * @notice Borrows are repaid by another user (possibly the borrower).
2355      * @param payer the account paying off the borrow
2356      * @param borrower the account with the debt being payed off
2357      * @param repayAmount the amount of undelrying tokens being returned
2358      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
2359      */
2360     function repayBorrowFresh(address payer, address borrower, uint repayAmount) internal returns (uint, uint) {
2361         RepayBorrowLocalVars memory vars;
2362 
2363         /* We remember the original borrowerIndex for verification purposes */
2364         vars.borrowerIndex = accountBorrows[borrower].interestIndex;
2365 
2366         /* We fetch the amount the borrower owes, with accumulated interest */
2367         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
2368         if (vars.mathErr != MathError.NO_ERROR) {
2369             return (failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr)), 0);
2370         }
2371 
2372         /* If repayAmount == -1, repayAmount = accountBorrows */
2373         if (repayAmount == uint(-1)) {
2374             vars.repayAmount = vars.accountBorrows;
2375         } else {
2376             vars.repayAmount = repayAmount;
2377         }
2378 
2379         /////////////////////////
2380         // EFFECTS & INTERACTIONS
2381         // (No safe failures beyond this point)
2382         vars.actualRepayAmount = doTransferIn(eFILAddress, payer, vars.repayAmount);
2383 
2384         /*
2385          * We calculate the new borrower and total borrow balances, failing on underflow:
2386          *  accountBorrowsNew = accountBorrows - actualRepayAmount
2387          *  totalBorrowsNew = totalBorrows - actualRepayAmount
2388          */
2389         (vars.mathErr, vars.accountBorrowsNew) = subUInt(vars.accountBorrows, vars.actualRepayAmount);
2390         require(vars.mathErr == MathError.NO_ERROR, "REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED");
2391 
2392         (vars.mathErr, vars.totalBorrowsNew) = subUInt(totalBorrows, vars.actualRepayAmount);
2393         require(vars.mathErr == MathError.NO_ERROR, "REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED");
2394 
2395         /* We write the previously calculated values into storage */
2396         accountBorrows[borrower].principal = vars.accountBorrowsNew;
2397         accountBorrows[borrower].interestIndex = borrowIndex;
2398         totalBorrows = vars.totalBorrowsNew;
2399 
2400         /* We emit a RepayBorrow event */
2401         emit RepayBorrow(payer, borrower, vars.actualRepayAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
2402         return (uint(Error.NO_ERROR), vars.actualRepayAmount);
2403     }
2404 
2405     /**
2406      * redeem collaterals
2407      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2408      * @param redeemAmount The number of collateral to redeem into underlying
2409      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2410      */
2411     function redeemCollateral(uint redeemAmount) external nonReentrant returns (uint) {
2412         uint err = accrueInterest();
2413         if (err != uint(Error.NO_ERROR)) {
2414             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
2415             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
2416         }
2417         // Keep the flywheel moving
2418         accrueDFL();
2419 
2420         // redeemCollateralFresh emits redeem-collaterals-specific logs on errors, so we don't need to
2421         return redeemCollateralFresh(msg.sender, redeemAmount);
2422     }
2423 
2424     struct RedeemCollateralLocalVars {
2425         Error err;
2426         MathError mathErr;
2427         uint redeemAmount;
2428         uint accountBorrows;
2429         uint accountCollateralsOld;
2430         uint accountCollateralsNew;
2431         uint totalCollateralsNew;
2432     }
2433 
2434     /**
2435      * redeem collaterals
2436      * @dev Assumes interest has already been accrued up to the current block
2437      * @param redeemer The address of the account which is redeeming
2438      * @param redeemAmount The number of collaterals to redeem into underlying
2439      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2440      */
2441     function redeemCollateralFresh(address redeemer, uint redeemAmount) internal returns (uint) {
2442         RedeemCollateralLocalVars memory vars;
2443 
2444         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(redeemer);
2445         if (vars.mathErr != MathError.NO_ERROR) {
2446             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_COLLATERAL_ACCUMULATED_BORROW_CALCULATION_FAILED, uint(vars.mathErr));
2447         }
2448 
2449         vars.accountCollateralsOld = accountCollaterals[redeemer];
2450         if (redeemAmount == uint(-1)) {
2451             vars.redeemAmount = vars.accountCollateralsOld >= vars.accountBorrows ? vars.accountCollateralsOld - vars.accountBorrows : 0;
2452         } else {
2453             vars.redeemAmount = redeemAmount;
2454         }
2455 
2456         (vars.mathErr, vars.accountCollateralsNew) = subUInt(accountCollaterals[redeemer], vars.redeemAmount);
2457         if (vars.mathErr != MathError.NO_ERROR) {
2458             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_COLLATERAL_NEW_ACCOUNT_COLLATERAL_CALCULATION_FAILED, uint(vars.mathErr));
2459         }
2460 
2461         // Check collateral
2462         if (vars.accountCollateralsNew < vars.accountBorrows) {
2463             return fail(Error.INSUFFICIENT_COLLATERAL, FailureInfo.REDEEM_COLLATERAL_INSUFFICIENT_COLLATERAL);
2464         }
2465 
2466         (vars.mathErr, vars.totalCollateralsNew) = subUInt(totalCollaterals, vars.redeemAmount);
2467         require(vars.mathErr == MathError.NO_ERROR, "REDEEM_COLLATERALS_NEW_TOTAL_COLLATERALS_CALCULATION_FAILED");
2468 
2469         /////////////////////////
2470         // EFFECTS & INTERACTIONS
2471         // (No safe failures beyond this point)
2472         doTransferOut(mFILAddress, redeemer, vars.redeemAmount);
2473 
2474         /* We write previously calculated values into storage */
2475         totalCollaterals = vars.totalCollateralsNew;
2476         accountCollaterals[redeemer] = vars.accountCollateralsNew;
2477 
2478         /* We emit a RedeemCollateral event */
2479         emit RedeemCollateral(redeemer, vars.redeemAmount);
2480         return uint(Error.NO_ERROR);
2481     }
2482 
2483     /**
2484      * liquidate borrow
2485      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2486      * @param borrower The borrower's address
2487      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2488      */
2489     function liquidateBorrow(address borrower) external nonReentrant returns (uint) {
2490         uint err = accrueInterest();
2491         if (err != uint(Error.NO_ERROR)) {
2492             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
2493         }
2494         // Keep the flywheel moving
2495         accrueDFL();
2496 
2497         return liquidateBorrowFresh(msg.sender, borrower);
2498     }
2499 
2500     struct LiquidateBorrowLocalVars {
2501         Error err;
2502         MathError mathErr;
2503         uint accountBorrows;
2504         uint accountCollaterals;
2505         uint collateralRate;
2506         uint totalBorrowsNew;
2507     }
2508 
2509     /**
2510      * liquidate borrow
2511      * @dev Assumes interest has already been accrued up to the current block
2512      * @param liquidator The liquidator's address
2513      * @param borrower The borrower's address
2514      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2515      */
2516     function liquidateBorrowFresh(address liquidator, address borrower) internal returns (uint) {
2517         // make things simple
2518         if (accountCollaterals[liquidator] != 0 || accountTokens[liquidator] != 0) {
2519             return fail(Error.REJECTION, FailureInfo.LIQUIDATE_BORROW_REJECTION);
2520         }
2521 
2522         LiquidateBorrowLocalVars memory vars;
2523 
2524         (vars.mathErr, vars.collateralRate, vars.accountBorrows, vars.accountCollaterals) = collateralRateInternal(borrower);
2525         if (vars.mathErr != MathError.NO_ERROR) {
2526             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_BORROW_COLLATERAL_RATE_CALCULATION_FAILED, uint(vars.mathErr));
2527         }
2528 
2529         if (vars.collateralRate < liquidateFactorMantissa) {
2530             return fail(Error.REJECTION, FailureInfo.LIQUIDATE_BORROW_NOT_SATISFIED);
2531         }
2532 
2533         /////////////////////////
2534         // EFFECTS & INTERACTIONS
2535         // (No safe failures beyond this point)
2536         require(doTransferIn(eFILAddress, liquidator, vars.accountBorrows) == vars.accountBorrows, "LIQUIDATE_BORROW_TRANSFER_IN_FAILED");
2537 
2538         (vars.mathErr, vars.totalBorrowsNew) = subUInt(totalBorrows, vars.accountBorrows);
2539         require(vars.mathErr == MathError.NO_ERROR, "LIQUIDATE_BORROW_NEW_TOTAL_BORROWS_CALCULATION_FAILED");
2540 
2541         /* We write the previously calculated values into storage */
2542         accountBorrows[borrower].principal = 0;
2543         accountBorrows[borrower].interestIndex = borrowIndex;
2544         totalBorrows = vars.totalBorrowsNew;
2545 
2546         accountCollaterals[borrower] = 0;
2547         accountCollaterals[liquidator] = vars.accountCollaterals;
2548 
2549         /* We emit a RepayBorrow event */
2550         emit LiquidateBorrow(liquidator, borrower, vars.accountBorrows, vars.accountCollaterals);
2551         return uint(Error.NO_ERROR);
2552     }
2553 
2554     /*** DFL ***/
2555 
2556     // accrue DFL
2557     function accrueDFL() internal {
2558         uint startBlockNumber = dflAccrualBlockNumber;
2559         uint endBlockNumber = startBlockNumber;
2560         uint currentBlockNumber = getBlockNumber();
2561         while (endBlockNumber < currentBlockNumber) {
2562             if (currentSpeed < minSpeed) {
2563                 break;
2564             }
2565 
2566             startBlockNumber = endBlockNumber;
2567             if (currentBlockNumber < nextHalveBlockNumber) {
2568                 endBlockNumber = currentBlockNumber;
2569             } else {
2570                 endBlockNumber = nextHalveBlockNumber;
2571             }
2572 
2573             distributeAndUpdateSupplyIndex(startBlockNumber, endBlockNumber);
2574 
2575             if (endBlockNumber == nextHalveBlockNumber) {
2576                 nextHalveBlockNumber = nextHalveBlockNumber + halvePeriod;
2577                 currentSpeed = currentSpeed / 2;
2578             }
2579         }
2580         // update dflAccrualBlockNumber
2581         dflAccrualBlockNumber = currentBlockNumber;
2582     }
2583 
2584     // Accrue DFL for suppliers by updating the supply index
2585     function distributeAndUpdateSupplyIndex(uint startBlockNumber, uint endBlockNumber) internal {
2586         uint deltaBlocks = sub_(endBlockNumber, startBlockNumber);
2587         if (deltaBlocks > 0) {
2588             uint deltaDFLs = mul_(deltaBlocks, currentSpeed);
2589             dflToken.mint(address(this), deltaDFLs);
2590 
2591             uint uniswapPart = div_(mul_(uniswapPercentage, deltaDFLs), mantissaOne);
2592             uint minerLeaguePart = div_(mul_(minerLeaguePercentage, deltaDFLs), mantissaOne);
2593             uint operatorPart = div_(mul_(operatorPercentage, deltaDFLs), mantissaOne);
2594             uint technicalPart = div_(mul_(technicalPercentage, deltaDFLs), mantissaOne);
2595             uint supplyPart = sub_(sub_(sub_(sub_(deltaDFLs, uniswapPart), minerLeaguePart), operatorPart), technicalPart);
2596 
2597             // accrue, not transfer directly
2598             dflAccrued[uniswapAddress] = add_(dflAccrued[uniswapAddress], uniswapPart);
2599             dflAccrued[minerLeagueAddress] = add_(dflAccrued[minerLeagueAddress], minerLeaguePart);
2600             dflAccrued[operatorAddress] = add_(dflAccrued[operatorAddress], operatorPart);
2601             dflAccrued[technicalAddress] = add_(dflAccrued[technicalAddress], technicalPart);
2602 
2603             if (totalSupply > 0) {
2604                 Double memory ratio = fraction(supplyPart, totalSupply);
2605                 Double memory index = add_(Double({mantissa: dflSupplyIndex}), ratio);
2606                 dflSupplyIndex = index.mantissa;
2607             } else {
2608                 dflAccrued[undistributedAddress] = add_(dflAccrued[undistributedAddress], supplyPart);
2609             }
2610 
2611             emit AccrueDFL(uniswapPart, minerLeaguePart, operatorPart, technicalPart, supplyPart, dflSupplyIndex);
2612         }
2613     }
2614 
2615     // Calculate DFL accrued by a supplier and possibly transfer it to them
2616     function distributeSupplierDFL(address supplier, bool distributeAll) internal {
2617         /* Verify accrued block number equals current block number */
2618         require(dflAccrualBlockNumber == getBlockNumber(), "FRESHNESS_CHECK");
2619         uint supplierAccrued = accruedDFLStoredInternal(supplier);
2620 
2621         dflAccrued[supplier] = transferDFL(supplier, supplierAccrued, distributeAll ? 0 : dflClaimThreshold);
2622         dflSupplierIndex[supplier] = dflSupplyIndex;
2623         emit DistributedDFL(supplier, supplierAccrued - dflAccrued[supplier]);
2624     }
2625 
2626     // Transfer DFL to the user, if they are above the threshold
2627     function transferDFL(address user, uint userAccrued, uint threshold) internal returns (uint) {
2628         if (userAccrued >= threshold && userAccrued > 0) {
2629             uint dflRemaining = dflToken.balanceOf(address(this));
2630             if (userAccrued <= dflRemaining) {
2631                 dflToken.transfer(user, userAccrued);
2632                 return 0;
2633             }
2634         }
2635         return userAccrued;
2636     }
2637 
2638     function claimDFL() public nonReentrant {
2639         accrueDFL();
2640         distributeSupplierDFL(msg.sender, true);
2641     }
2642 
2643     // Claim all DFL accrued by the suppliers
2644     function claimDFL(address[] memory holders) public nonReentrant {
2645         accrueDFL();
2646         for (uint i = 0; i < holders.length; i++) {
2647             distributeSupplierDFL(holders[i], true);
2648         }
2649     }
2650 
2651     // Reduce reserves, only by staking contract
2652     function claimReserves() public nonReentrant {
2653         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
2654 
2655         uint cash = getCashPrior();
2656         uint actualAmount = cash > totalReserves ? totalReserves : cash;
2657 
2658         doTransferOut(eFILAddress, reservesOwner, actualAmount);
2659         totalReserves = sub_(totalReserves, actualAmount);
2660 
2661         emit ReservesReduced(reservesOwner, actualAmount);
2662     }
2663 
2664     /*** Admin Functions ***/
2665 
2666     /**
2667       * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
2668       * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
2669       * @param newPendingAdmin New pending admin.
2670       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2671       */
2672     function _setPendingAdmin(address newPendingAdmin) external returns (uint) {
2673         // Check caller = admin
2674         if (msg.sender != admin) {
2675             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
2676         }
2677 
2678         // Save current value, if any, for inclusion in log
2679         address oldPendingAdmin = pendingAdmin;
2680 
2681         // Store pendingAdmin with value newPendingAdmin
2682         pendingAdmin = newPendingAdmin;
2683 
2684         // Emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin)
2685         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
2686 
2687         return uint(Error.NO_ERROR);
2688     }
2689 
2690     /**
2691       * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
2692       * @dev Admin function for pending admin to accept role and update admin
2693       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2694       */
2695     function _acceptAdmin() external returns (uint) {
2696         // Check caller is pendingAdmin and pendingAdmin ≠ address(0)
2697         if (msg.sender != pendingAdmin || msg.sender == address(0)) {
2698             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
2699         }
2700 
2701         // Save current values for inclusion in log
2702         address oldAdmin = admin;
2703         address oldPendingAdmin = pendingAdmin;
2704 
2705         // Store admin with value pendingAdmin
2706         admin = pendingAdmin;
2707 
2708         // Clear the pending value
2709         pendingAdmin = address(0);
2710 
2711         emit NewAdmin(oldAdmin, admin);
2712         emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
2713 
2714         return uint(Error.NO_ERROR);
2715     }
2716 
2717     /**
2718       * @dev Change mintAllowed
2719       * @param mintAllowed_ New value.
2720       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2721       */
2722     function _setMintAllowed(bool mintAllowed_) external returns (uint) {
2723         // Check caller = admin
2724         if (msg.sender != admin) {
2725             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
2726         }
2727 
2728         if (mintAllowed != mintAllowed_) {
2729             mintAllowed = mintAllowed_;
2730             emit MintAllowed(mintAllowed_);
2731         }
2732 
2733         return uint(Error.NO_ERROR);
2734     }
2735 
2736     /**
2737       * @dev Change borrowAllowed
2738       * @param borrowAllowed_ New value.
2739       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2740       */
2741     function _setBorrowAllowed(bool borrowAllowed_) external returns (uint) {
2742         // Check caller = admin
2743         if (msg.sender != admin) {
2744             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
2745         }
2746 
2747         if (borrowAllowed != borrowAllowed_) {
2748             borrowAllowed = borrowAllowed_;
2749             emit BorrowAllowed(borrowAllowed_);
2750         }
2751 
2752         return uint(Error.NO_ERROR);
2753     }
2754 
2755     /**
2756       * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
2757       * @dev Admin function to accrue interest and set a new reserve factor
2758       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2759       */
2760     function _setReserveFactor(uint newReserveFactorMantissa) external nonReentrant returns (uint) {
2761         uint error = accrueInterest();
2762         if (error != uint(Error.NO_ERROR)) {
2763             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reserve factor change failed.
2764             return fail(Error(error), FailureInfo.ACCRUE_INTEREST_FAILED);
2765         }
2766         // _setReserveFactorFresh emits reserve-factor-specific logs on errors, so we don't need to.
2767         return _setReserveFactorFresh(newReserveFactorMantissa);
2768     }
2769 
2770     /**
2771       * @notice Sets a new reserve factor for the protocol (*requires fresh interest accrual)
2772       * @dev Admin function to set a new reserve factor
2773       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2774       */
2775     function _setReserveFactorFresh(uint newReserveFactorMantissa) internal returns (uint) {
2776         // Check caller is admin
2777         if (msg.sender != admin) {
2778             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
2779         }
2780 
2781         // Check newReserveFactor ≤ maxReserveFactor
2782         if (newReserveFactorMantissa > reserveFactorMaxMantissa) {
2783             return fail(Error.BAD_INPUT, FailureInfo.SET_RESERVE_FACTOR_BOUNDS_CHECK);
2784         }
2785 
2786         uint oldReserveFactorMantissa = reserveFactorMantissa;
2787         reserveFactorMantissa = newReserveFactorMantissa;
2788 
2789         emit NewReserveFactor(oldReserveFactorMantissa, newReserveFactorMantissa);
2790 
2791         return uint(Error.NO_ERROR);
2792     }
2793 
2794     /**
2795       * @notice accrues interest and sets a new liquidate factor for the protocol using _setLiquidateFactorFresh
2796       * @dev Admin function to accrue interest and set a new liquidate factor
2797       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2798       */
2799     function _setLiquidateFactor(uint newLiquidateFactorMantissa) external nonReentrant returns (uint) {
2800         uint error = accrueInterest();
2801         if (error != uint(Error.NO_ERROR)) {
2802             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted liquidate factor change failed.
2803             return fail(Error(error), FailureInfo.ACCRUE_INTEREST_FAILED);
2804         }
2805         return _setLiquidateFactorFresh(newLiquidateFactorMantissa);
2806     }
2807 
2808     function _setLiquidateFactorFresh(uint newLiquidateFactorMantissa) internal returns (uint) {
2809         // Check caller is admin
2810         if (msg.sender != admin) {
2811             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
2812         }
2813 
2814         if (newLiquidateFactorMantissa < liquidateFactorMinMantissa) {
2815             return fail(Error.BAD_INPUT, FailureInfo.SET_LIQUIDATE_FACTOR_BOUNDS_CHECK);
2816         }
2817 
2818         uint oldLiquidateFactorMantissa = liquidateFactorMantissa;
2819         liquidateFactorMantissa = newLiquidateFactorMantissa;
2820 
2821         emit NewLiquidateFactor(oldLiquidateFactorMantissa, newLiquidateFactorMantissa);
2822 
2823         return uint(Error.NO_ERROR);
2824     }
2825 
2826     /**
2827      * @notice accrues interest and updates the interest rate model using _setInterestRateModelFresh
2828      * @dev Admin function to accrue interest and update the interest rate model
2829      * @param newInterestRateModel the new interest rate model to use
2830      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2831      */
2832     function _setInterestRateModel(InterestRateModel newInterestRateModel) public nonReentrant returns (uint) {
2833         uint error = accrueInterest();
2834         if (error != uint(Error.NO_ERROR)) {
2835             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted change of interest rate model failed
2836             return fail(Error(error), FailureInfo.ACCRUE_INTEREST_FAILED);
2837         }
2838         // _setInterestRateModelFresh emits interest-rate-model-update-specific logs on errors, so we don't need to.
2839         return _setInterestRateModelFresh(newInterestRateModel);
2840     }
2841 
2842     /**
2843      * @notice updates the interest rate model (*requires fresh interest accrual)
2844      * @dev Admin function to update the interest rate model
2845      * @param newInterestRateModel the new interest rate model to use
2846      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2847      */
2848     function _setInterestRateModelFresh(InterestRateModel newInterestRateModel) internal returns (uint) {
2849         // Used to store old model for use in the event that is emitted on success
2850         InterestRateModel oldInterestRateModel;
2851 
2852         // Check caller is admin
2853         if (msg.sender != admin) {
2854             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
2855         }
2856 
2857         // Track the current interest rate model
2858         oldInterestRateModel = interestRateModel;
2859 
2860         // Ensure invoke newInterestRateModel.isInterestRateModel() returns true
2861         require(newInterestRateModel.isInterestRateModel(), "marker method returned false");
2862 
2863         // Set the interest rate model to newInterestRateModel
2864         interestRateModel = newInterestRateModel;
2865 
2866         // Emit NewInterestRateModel(oldInterestRateModel, newInterestRateModel)
2867         emit NewInterestRateModel(oldInterestRateModel, newInterestRateModel);
2868 
2869         return uint(Error.NO_ERROR);
2870     }
2871 
2872     /**
2873       * @dev Change reservesOwner
2874       * @param newReservesOwner New value.
2875       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2876       */
2877     function _setReservesOwner(address newReservesOwner) public returns (uint) {
2878         claimReserves();
2879         return _setReservesOwnerFresh(newReservesOwner);
2880     }
2881 
2882     function _setReservesOwnerFresh(address newReservesOwner) internal returns (uint) {
2883         // Check caller = admin
2884         if (msg.sender != admin) {
2885             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
2886         }
2887 
2888         address oldReservesOwner = reservesOwner;
2889         reservesOwner = newReservesOwner;
2890 
2891         emit ReservesOwnerChanged(oldReservesOwner, newReservesOwner);
2892         return uint(Error.NO_ERROR);
2893     }
2894 
2895     /**
2896       * @dev Change minerLeagueAddress
2897       * @param newMinerLeagueAddress New value.
2898       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2899       */
2900     function _setMinerLeagueAddress(address newMinerLeagueAddress) external nonReentrant returns (uint) {
2901         // accrue
2902         accrueDFL();
2903         return _setMinerLeagueAddressFresh(newMinerLeagueAddress);
2904     }
2905 
2906     function _setMinerLeagueAddressFresh(address newMinerLeagueAddress) internal returns (uint) {
2907         if (msg.sender != minerLeagueAddress) {
2908             return fail(Error.UNAUTHORIZED, FailureInfo.PARTICIPANT_CHECK);
2909         }
2910 
2911         // transfers accrued
2912         if (dflAccrued[minerLeagueAddress] != 0) {
2913             doTransferOut(address(dflToken), minerLeagueAddress, dflAccrued[minerLeagueAddress]);
2914             delete dflAccrued[minerLeagueAddress];
2915         }
2916 
2917         address oldMinerLeagueAddress = minerLeagueAddress;
2918         minerLeagueAddress = newMinerLeagueAddress;
2919 
2920         emit MinerLeagueAddressChanged(oldMinerLeagueAddress, newMinerLeagueAddress);
2921         return uint(Error.NO_ERROR);
2922     }
2923 
2924     /**
2925       * @dev Change operatorAddress
2926       * @param newOperatorAddress New value.
2927       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2928       */
2929     function _setOperatorAddress(address newOperatorAddress) external nonReentrant returns (uint) {
2930         // accrue
2931         accrueDFL();
2932         return _setOperatorAddressFresh(newOperatorAddress);
2933     }
2934 
2935     function _setOperatorAddressFresh(address newOperatorAddress) internal returns (uint) {
2936         if (msg.sender != operatorAddress) {
2937             return fail(Error.UNAUTHORIZED, FailureInfo.PARTICIPANT_CHECK);
2938         }
2939 
2940         // transfers accrued
2941         if (dflAccrued[operatorAddress] != 0) {
2942             doTransferOut(address(dflToken), operatorAddress, dflAccrued[operatorAddress]);
2943             delete dflAccrued[operatorAddress];
2944         }
2945 
2946         address oldOperatorAddress = operatorAddress;
2947         operatorAddress = newOperatorAddress;
2948 
2949         emit OperatorAddressChanged(oldOperatorAddress, newOperatorAddress);
2950         return uint(Error.NO_ERROR);
2951     }
2952 
2953     /**
2954       * @dev Change technicalAddress
2955       * @param newTechnicalAddress New value.
2956       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2957       */
2958     function _setTechnicalAddress(address newTechnicalAddress) external nonReentrant returns (uint) {
2959         // accrue
2960         accrueDFL();
2961         return _setTechnicalAddressFresh(newTechnicalAddress);
2962     }
2963 
2964     function _setTechnicalAddressFresh(address newTechnicalAddress) internal returns (uint) {
2965         if (msg.sender != technicalAddress) {
2966             return fail(Error.UNAUTHORIZED, FailureInfo.PARTICIPANT_CHECK);
2967         }
2968 
2969         // transfers accrued
2970         if (dflAccrued[technicalAddress] != 0) {
2971             doTransferOut(address(dflToken), technicalAddress, dflAccrued[technicalAddress]);
2972             delete dflAccrued[technicalAddress];
2973         }
2974 
2975         address oldTechnicalAddress = technicalAddress;
2976         technicalAddress = newTechnicalAddress;
2977 
2978         emit TechnicalAddressChanged(oldTechnicalAddress, newTechnicalAddress);
2979         return uint(Error.NO_ERROR);
2980     }
2981 
2982     /**
2983       * @dev Change uniswapAddress
2984       * @param newUniswapAddress New value.
2985       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2986       */
2987     function _setUniswapAddress(address newUniswapAddress) external nonReentrant returns (uint) {
2988         // accrue
2989         accrueDFL();
2990         return _setUniswapAddressFresh(newUniswapAddress);
2991     }
2992 
2993     function _setUniswapAddressFresh(address newUniswapAddress) internal returns (uint) {
2994         // Check caller = admin
2995         if (msg.sender != admin) {
2996             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
2997         }
2998 
2999         // transfers accrued
3000         if (dflAccrued[uniswapAddress] != 0) {
3001             doTransferOut(address(dflToken), uniswapAddress, dflAccrued[uniswapAddress]);
3002             delete dflAccrued[uniswapAddress];
3003         }
3004 
3005         address oldUniswapAddress = uniswapAddress;
3006         uniswapAddress = newUniswapAddress;
3007 
3008         emit UniswapAddressChanged(oldUniswapAddress, newUniswapAddress);
3009         return uint(Error.NO_ERROR);
3010     }
3011 
3012     /**
3013       * @dev Change undistributedAddress
3014       * @param newUndistributedAddress New value.
3015       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
3016       */
3017     function _setUndistributedAddress(address newUndistributedAddress) external nonReentrant returns (uint) {
3018         // accrue
3019         accrueDFL();
3020         return _setUndistributedAddressFresh(newUndistributedAddress);
3021     }
3022 
3023     function _setUndistributedAddressFresh(address newUndistributedAddress) internal returns (uint) {
3024         // Check caller = admin
3025         if (msg.sender != admin) {
3026             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
3027         }
3028 
3029         // transfers accrued to old address
3030         if (dflAccrued[undistributedAddress] != 0) {
3031             doTransferOut(address(dflToken), undistributedAddress, dflAccrued[undistributedAddress]);
3032             delete dflAccrued[undistributedAddress];
3033         }
3034 
3035         address oldUndistributedAddress = undistributedAddress;
3036         undistributedAddress = newUndistributedAddress;
3037 
3038         emit UndistributedAddressChanged(oldUndistributedAddress, newUndistributedAddress);
3039         return uint(Error.NO_ERROR);
3040     }
3041 
3042     /**
3043       * @dev Change DFL percentages
3044       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
3045       */
3046     function _setDFLPercentages(uint uniswapPercentage_,
3047                                 uint minerLeaguePercentage_,
3048                                 uint operatorPercentage_) external nonReentrant returns (uint) {
3049         accrueDFL();
3050         return _setDFLPercentagesFresh(uniswapPercentage_, minerLeaguePercentage_, operatorPercentage_);
3051     }
3052 
3053     function _setDFLPercentagesFresh(uint uniswapPercentage_,
3054                                      uint minerLeaguePercentage_,
3055                                      uint operatorPercentage_) internal returns (uint) {
3056         // Check caller = admin
3057         if (msg.sender != admin) {
3058             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
3059         }
3060 
3061         uint sumPercentage = add_(add_(add_(uniswapPercentage_, minerLeaguePercentage_), operatorPercentage_), technicalPercentage);
3062         require(sumPercentage <= mantissaOne, "PERCENTAGE_EXCEEDS");
3063 
3064         uniswapPercentage = uniswapPercentage_;
3065         minerLeaguePercentage = minerLeaguePercentage_;
3066         operatorPercentage = operatorPercentage_;
3067 
3068         emit PercentagesChanged(uniswapPercentage_, minerLeaguePercentage_, operatorPercentage_);
3069         return uint(Error.NO_ERROR);
3070     }
3071 
3072     /*** Safe Token ***/
3073 
3074     /**
3075      * @notice Gets balance of this contract in terms of the underlying
3076      * @dev This excludes the value of the current message, if any
3077      * @return The quantity of underlying tokens owned by this contract
3078      */
3079     function getCashPrior() internal view returns (uint) {
3080         EIP20Interface token = EIP20Interface(eFILAddress);
3081         return token.balanceOf(address(this));
3082     }
3083 
3084     /**
3085      * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and reverts in that case.
3086      *      This will revert due to insufficient balance or insufficient allowance.
3087      *      This function returns the actual amount received,
3088      *      which may be less than `amount` if there is a fee attached to the transfer.
3089      *
3090      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
3091      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
3092      */
3093     function doTransferIn(address underlying, address from, uint amount) internal returns (uint) {
3094         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
3095         uint balanceBefore = EIP20Interface(underlying).balanceOf(address(this));
3096         token.transferFrom(from, address(this), amount);
3097 
3098         bool success;
3099         assembly {
3100             switch returndatasize()
3101                 case 0 {                       // This is a non-standard ERC-20
3102                     success := not(0)          // set success to true
3103                 }
3104                 case 32 {                      // This is a compliant ERC-20
3105                     returndatacopy(0, 0, 32)
3106                     success := mload(0)        // Set `success = returndata` of external call
3107                 }
3108                 default {                      // This is an excessively non-compliant ERC-20, revert.
3109                     revert(0, 0)
3110                 }
3111         }
3112         require(success, "TOKEN_TRANSFER_IN_FAILED");
3113 
3114         // Calculate the amount that was *actually* transferred
3115         uint balanceAfter = EIP20Interface(underlying).balanceOf(address(this));
3116         require(balanceAfter >= balanceBefore, "TOKEN_TRANSFER_IN_OVERFLOW");
3117         return balanceAfter - balanceBefore;   // underflow already checked above, just subtract
3118     }
3119 
3120     /**
3121      * @dev Similar to EIP20 transfer, except it handles a False success from `transfer` and returns an explanatory
3122      *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
3123      *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
3124      *      it is >= amount, this should not revert in normal conditions.
3125      *
3126      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
3127      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
3128      */
3129     function doTransferOut(address underlying, address to, uint amount) internal {
3130         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
3131         token.transfer(to, amount);
3132 
3133         bool success;
3134         assembly {
3135             switch returndatasize()
3136                 case 0 {                      // This is a non-standard ERC-20
3137                     success := not(0)          // set success to true
3138                 }
3139                 case 32 {                     // This is a complaint ERC-20
3140                     returndatacopy(0, 0, 32)
3141                     success := mload(0)        // Set `success = returndata` of external call
3142                 }
3143                 default {                     // This is an excessively non-compliant ERC-20, revert.
3144                     revert(0, 0)
3145                 }
3146         }
3147         require(success, "TOKEN_TRANSFER_OUT_FAILED");
3148     }
3149 }