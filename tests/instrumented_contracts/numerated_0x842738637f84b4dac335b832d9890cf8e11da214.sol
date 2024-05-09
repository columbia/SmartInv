1 // File: contracts\EIP20Interface.sol
2 
3 pragma solidity ^0.5.8;
4 
5 /**
6  * @title ERC 20 Token Standard Interface
7  *  https://eips.ethereum.org/EIPS/eip-20
8  */
9 interface EIP20Interface {
10 
11     /**
12       * @notice Get the total number of tokens in circulation
13       * @return The supply of tokens
14       */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @notice Gets the balance of the specified address
19      * @param owner The address from which the balance will be retrieved
20      * @return The balance
21      */
22     function balanceOf(address owner) external view returns (uint256 balance);
23 
24     /**
25       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
26       * @param dst The address of the destination account
27       * @param amount The number of tokens to transfer
28       * @return Whether or not the transfer succeeded
29       */
30     function transfer(address dst, uint256 amount) external returns (bool success);
31 
32     /**
33       * @notice Transfer `amount` tokens from `src` to `dst`
34       * @param src The address of the source account
35       * @param dst The address of the destination account
36       * @param amount The number of tokens to transfer
37       * @return Whether or not the transfer succeeded
38       */
39     function transferFrom(address src, address dst, uint256 amount) external returns (bool success);
40 
41     /**
42       * @notice Approve `spender` to transfer up to `amount` from `src`
43       * @dev This will overwrite the approval amount for `spender`
44       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
45       * @param spender The address of the account which may transfer tokens
46       * @param amount The number of tokens that are approved (-1 means infinite)
47       * @return Whether or not the approval succeeded
48       */
49     function approve(address spender, uint256 amount) external returns (bool success);
50 
51     /**
52       * @notice Get the current allowance from `owner` for `spender`
53       * @param owner The address of the account which owns the tokens to be spent
54       * @param spender The address of the account which may transfer tokens
55       * @return The number of tokens allowed to be spent (-1 means infinite)
56       */
57     function allowance(address owner, address spender) external view returns (uint256 remaining);
58 
59     event Transfer(address indexed from, address indexed to, uint256 amount);
60     event Approval(address indexed owner, address indexed spender, uint256 amount);
61 }
62 
63 // File: contracts\EIP20NonStandardInterface.sol
64 
65 pragma solidity ^0.5.8;
66 
67 /**
68  * @title EIP20NonStandardInterface
69  * @dev Version of ERC20 with no return values for `transfer` and `transferFrom`
70  *  See https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
71  */
72 interface EIP20NonStandardInterface {
73 
74     /**
75      * @notice Get the total number of tokens in circulation
76      * @return The supply of tokens
77      */
78     function totalSupply() external view returns (uint256);
79 
80     /**
81      * @notice Gets the balance of the specified address
82      * @param owner The address from which the balance will be retrieved
83      * @return The balance
84      */
85     function balanceOf(address owner) external view returns (uint256 balance);
86 
87     ///
88     /// !!!!!!!!!!!!!!
89     /// !!! NOTICE !!! `transfer` does not return a value, in violation of the ERC-20 specification
90     /// !!!!!!!!!!!!!!
91     ///
92 
93     /**
94       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
95       * @param dst The address of the destination account
96       * @param amount The number of tokens to transfer
97       */
98     function transfer(address dst, uint256 amount) external;
99 
100     ///
101     /// !!!!!!!!!!!!!!
102     /// !!! NOTICE !!! `transferFrom` does not return a value, in violation of the ERC-20 specification
103     /// !!!!!!!!!!!!!!
104     ///
105 
106     /**
107       * @notice Transfer `amount` tokens from `src` to `dst`
108       * @param src The address of the source account
109       * @param dst The address of the destination account
110       * @param amount The number of tokens to transfer
111       */
112     function transferFrom(address src, address dst, uint256 amount) external;
113 
114     /**
115       * @notice Approve `spender` to transfer up to `amount` from `src`
116       * @dev This will overwrite the approval amount for `spender`
117       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
118       * @param spender The address of the account which may transfer tokens
119       * @param amount The number of tokens that are approved
120       * @return Whether or not the approval succeeded
121       */
122     function approve(address spender, uint256 amount) external returns (bool success);
123 
124     /**
125       * @notice Get the current allowance from `owner` for `spender`
126       * @param owner The address of the account which owns the tokens to be spent
127       * @param spender The address of the account which may transfer tokens
128       * @return The number of tokens allowed to be spent
129       */
130     function allowance(address owner, address spender) external view returns (uint256 remaining);
131 
132     event Transfer(address indexed from, address indexed to, uint256 amount);
133     event Approval(address indexed owner, address indexed spender, uint256 amount);
134 }
135 
136 // File: contracts\CarefulMath.sol
137 
138 // File: contracts/CarefulMath.sol
139 
140 pragma solidity ^0.5.8;
141 
142 /**
143   * @title Careful Math
144   * @author Compound
145   * @notice Derived from OpenZeppelin's SafeMath library
146   *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
147   */
148 contract CarefulMath {
149 
150     /**
151      * @dev Possible error codes that we can return
152      */
153     enum MathError {
154         NO_ERROR,
155         DIVISION_BY_ZERO,
156         INTEGER_OVERFLOW,
157         INTEGER_UNDERFLOW
158     }
159 
160     /**
161     * @dev Multiplies two numbers, returns an error on overflow.
162     */
163     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
164         if (a == 0) {
165             return (MathError.NO_ERROR, 0);
166         }
167 
168         uint c = a * b;
169 
170         if (c / a != b) {
171             return (MathError.INTEGER_OVERFLOW, 0);
172         } else {
173             return (MathError.NO_ERROR, c);
174         }
175     }
176 
177     /**
178     * @dev Integer division of two numbers, truncating the quotient.
179     */
180     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
181         if (b == 0) {
182             return (MathError.DIVISION_BY_ZERO, 0);
183         }
184 
185         return (MathError.NO_ERROR, a / b);
186     }
187 
188     /**
189     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
190     */
191     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
192         if (b <= a) {
193             return (MathError.NO_ERROR, a - b);
194         } else {
195             return (MathError.INTEGER_UNDERFLOW, 0);
196         }
197     }
198 
199     /**
200     * @dev Adds two numbers, returns an error on overflow.
201     */
202     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
203         uint c = a + b;
204 
205         if (c >= a) {
206             return (MathError.NO_ERROR, c);
207         } else {
208             return (MathError.INTEGER_OVERFLOW, 0);
209         }
210     }
211 
212     /**
213     * @dev add a and b and then subtract c
214     */
215     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
216         (MathError err0, uint sum) = addUInt(a, b);
217 
218         if (err0 != MathError.NO_ERROR) {
219             return (err0, 0);
220         }
221 
222         return subUInt(sum, c);
223     }
224 }
225 
226 // File: contracts\Exponential.sol
227 
228 pragma solidity ^0.5.16;
229 
230 
231 /**
232  * @title Exponential module for storing fixed-precision decimals
233  * @author Compound
234  * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
235  *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
236  *         `Exp({mantissa: 5100000000000000000})`.
237  */
238 contract Exponential is CarefulMath {
239     uint constant expScale = 1e18;
240     uint constant doubleScale = 1e36;
241     uint constant halfExpScale = expScale/2;
242     uint constant mantissaOne = expScale;
243 
244     struct Exp {
245         uint mantissa;
246     }
247 
248     struct Double {
249         uint mantissa;
250     }
251 
252     /**
253      * @dev Creates an exponential from numerator and denominator values.
254      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
255      *            or if `denom` is zero.
256      */
257     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
258         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
259         if (err0 != MathError.NO_ERROR) {
260             return (err0, Exp({mantissa: 0}));
261         }
262 
263         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
264         if (err1 != MathError.NO_ERROR) {
265             return (err1, Exp({mantissa: 0}));
266         }
267 
268         return (MathError.NO_ERROR, Exp({mantissa: rational}));
269     }
270 
271     /**
272      * @dev Adds two exponentials, returning a new exponential.
273      */
274     function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
275         (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);
276 
277         return (error, Exp({mantissa: result}));
278     }
279 
280     /**
281      * @dev Subtracts two exponentials, returning a new exponential.
282      */
283     function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
284         (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);
285 
286         return (error, Exp({mantissa: result}));
287     }
288 
289     /**
290      * @dev Multiply an Exp by a scalar, returning a new Exp.
291      */
292     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
293         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
294         if (err0 != MathError.NO_ERROR) {
295             return (err0, Exp({mantissa: 0}));
296         }
297 
298         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
299     }
300 
301     /**
302      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
303      */
304     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
305         (MathError err, Exp memory product) = mulScalar(a, scalar);
306         if (err != MathError.NO_ERROR) {
307             return (err, 0);
308         }
309 
310         return (MathError.NO_ERROR, truncate(product));
311     }
312 
313     /**
314      * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
315      */
316     function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
317         (MathError err, Exp memory product) = mulScalar(a, scalar);
318         if (err != MathError.NO_ERROR) {
319             return (err, 0);
320         }
321 
322         return addUInt(truncate(product), addend);
323     }
324 
325     /**
326      * @dev Divide an Exp by a scalar, returning a new Exp.
327      */
328     function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
329         (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
330         if (err0 != MathError.NO_ERROR) {
331             return (err0, Exp({mantissa: 0}));
332         }
333 
334         return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
335     }
336 
337     /**
338      * @dev Divide a scalar by an Exp, returning a new Exp.
339      */
340     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
341         /*
342           We are doing this as:
343           getExp(mulUInt(expScale, scalar), divisor.mantissa)
344 
345           How it works:
346           Exp = a / b;
347           Scalar = s;
348           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
349         */
350         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
351         if (err0 != MathError.NO_ERROR) {
352             return (err0, Exp({mantissa: 0}));
353         }
354         return getExp(numerator, divisor.mantissa);
355     }
356 
357     /**
358      * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
359      */
360     function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
361         (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
362         if (err != MathError.NO_ERROR) {
363             return (err, 0);
364         }
365 
366         return (MathError.NO_ERROR, truncate(fraction));
367     }
368 
369     /**
370      * @dev Multiplies two exponentials, returning a new exponential.
371      */
372     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
373 
374         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
375         if (err0 != MathError.NO_ERROR) {
376             return (err0, Exp({mantissa: 0}));
377         }
378 
379         // We add half the scale before dividing so that we get rounding instead of truncation.
380         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
381         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
382         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
383         if (err1 != MathError.NO_ERROR) {
384             return (err1, Exp({mantissa: 0}));
385         }
386 
387         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
388         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
389         assert(err2 == MathError.NO_ERROR);
390 
391         return (MathError.NO_ERROR, Exp({mantissa: product}));
392     }
393 
394     /**
395      * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
396      */
397     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
398         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
399     }
400 
401     /**
402      * @dev Multiplies three exponentials, returning a new exponential.
403      */
404     function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
405         (MathError err, Exp memory ab) = mulExp(a, b);
406         if (err != MathError.NO_ERROR) {
407             return (err, ab);
408         }
409         return mulExp(ab, c);
410     }
411 
412     /**
413      * @dev Divides two exponentials, returning a new exponential.
414      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
415      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
416      */
417     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
418         return getExp(a.mantissa, b.mantissa);
419     }
420 
421     /**
422      * @dev Truncates the given exp to a whole number value.
423      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
424      */
425     function truncate(Exp memory exp) pure internal returns (uint) {
426         // Note: We are not using careful math here as we're performing a division that cannot fail
427         return exp.mantissa / expScale;
428     }
429 
430     /**
431      * @dev Checks if first Exp is less than second Exp.
432      */
433     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
434         return left.mantissa < right.mantissa;
435     }
436 
437     /**
438      * @dev Checks if left Exp <= right Exp.
439      */
440     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
441         return left.mantissa <= right.mantissa;
442     }
443 
444     /**
445      * @dev Checks if left Exp > right Exp.
446      */
447     function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
448         return left.mantissa > right.mantissa;
449     }
450 
451     /**
452      * @dev returns true if Exp is exactly zero
453      */
454     function isZeroExp(Exp memory value) pure internal returns (bool) {
455         return value.mantissa == 0;
456     }
457 
458     function safe224(uint n, string memory errorMessage) pure internal returns (uint224) {
459         require(n < 2**224, errorMessage);
460         return uint224(n);
461     }
462 
463     function safe32(uint n, string memory errorMessage) pure internal returns (uint32) {
464         require(n < 2**32, errorMessage);
465         return uint32(n);
466     }
467 
468     function add_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
469         return Exp({mantissa: add_(a.mantissa, b.mantissa)});
470     }
471 
472     function add_(Double memory a, Double memory b) pure internal returns (Double memory) {
473         return Double({mantissa: add_(a.mantissa, b.mantissa)});
474     }
475 
476     function add_(uint a, uint b) pure internal returns (uint) {
477         return add_(a, b, "addition overflow");
478     }
479 
480     function add_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
481         uint c = a + b;
482         require(c >= a, errorMessage);
483         return c;
484     }
485 
486     function sub_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
487         return Exp({mantissa: sub_(a.mantissa, b.mantissa)});
488     }
489 
490     function sub_(Double memory a, Double memory b) pure internal returns (Double memory) {
491         return Double({mantissa: sub_(a.mantissa, b.mantissa)});
492     }
493 
494     function sub_(uint a, uint b) pure internal returns (uint) {
495         return sub_(a, b, "subtraction underflow");
496     }
497 
498     function sub_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
499         require(b <= a, errorMessage);
500         return a - b;
501     }
502 
503     function mul_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
504         return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});
505     }
506 
507     function mul_(Exp memory a, uint b) pure internal returns (Exp memory) {
508         return Exp({mantissa: mul_(a.mantissa, b)});
509     }
510 
511     function mul_(uint a, Exp memory b) pure internal returns (uint) {
512         return mul_(a, b.mantissa) / expScale;
513     }
514 
515     function mul_(Double memory a, Double memory b) pure internal returns (Double memory) {
516         return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});
517     }
518 
519     function mul_(Double memory a, uint b) pure internal returns (Double memory) {
520         return Double({mantissa: mul_(a.mantissa, b)});
521     }
522 
523     function mul_(uint a, Double memory b) pure internal returns (uint) {
524         return mul_(a, b.mantissa) / doubleScale;
525     }
526 
527     function mul_(uint a, uint b) pure internal returns (uint) {
528         return mul_(a, b, "multiplication overflow");
529     }
530 
531     function mul_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
532         if (a == 0 || b == 0) {
533             return 0;
534         }
535         uint c = a * b;
536         require(c / a == b, errorMessage);
537         return c;
538     }
539 
540     function div_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
541         return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});
542     }
543 
544     function div_(Exp memory a, uint b) pure internal returns (Exp memory) {
545         return Exp({mantissa: div_(a.mantissa, b)});
546     }
547 
548     function div_(uint a, Exp memory b) pure internal returns (uint) {
549         return div_(mul_(a, expScale), b.mantissa);
550     }
551 
552     function div_(Double memory a, Double memory b) pure internal returns (Double memory) {
553         return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});
554     }
555 
556     function div_(Double memory a, uint b) pure internal returns (Double memory) {
557         return Double({mantissa: div_(a.mantissa, b)});
558     }
559 
560     function div_(uint a, Double memory b) pure internal returns (uint) {
561         return div_(mul_(a, doubleScale), b.mantissa);
562     }
563 
564     function div_(uint a, uint b) pure internal returns (uint) {
565         return div_(a, b, "divide by zero");
566     }
567 
568     function div_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
569         require(b > 0, errorMessage);
570         return a / b;
571     }
572 
573     function fraction(uint a, uint b) pure internal returns (Double memory) {
574         return Double({mantissa: div_(mul_(a, doubleScale), b)});
575     }
576 }
577 
578 // File: contracts\SafeMath.sol
579 
580 pragma solidity ^0.5.16;
581 
582 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
583 // Subject to the MIT license.
584 
585 /**
586  * @dev Wrappers over Solidity's arithmetic operations with added overflow
587  * checks.
588  *
589  * Arithmetic operations in Solidity wrap on overflow. This can easily result
590  * in bugs, because programmers usually assume that an overflow raises an
591  * error, which is the standard behavior in high level programming languages.
592  * `SafeMath` restores this intuition by reverting the transaction when an
593  * operation overflows.
594  *
595  * Using this library instead of the unchecked operations eliminates an entire
596  * class of bugs, so it's recommended to use it always.
597  */
598 library SafeMath {
599     /**
600      * @dev Returns the addition of two unsigned integers, reverting on overflow.
601      *
602      * Counterpart to Solidity's `+` operator.
603      *
604      * Requirements:
605      * - Addition cannot overflow.
606      */
607     function add(uint256 a, uint256 b) internal pure returns (uint256) {
608         uint256 c = a + b;
609         require(c >= a, "SafeMath: addition overflow");
610 
611         return c;
612     }
613 
614     /**
615      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
616      *
617      * Counterpart to Solidity's `+` operator.
618      *
619      * Requirements:
620      * - Addition cannot overflow.
621      */
622     function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
623         uint256 c = a + b;
624         require(c >= a, errorMessage);
625 
626         return c;
627     }
628 
629     /**
630      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
631      *
632      * Counterpart to Solidity's `-` operator.
633      *
634      * Requirements:
635      * - Subtraction cannot underflow.
636      */
637     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
638         return sub(a, b, "SafeMath: subtraction underflow");
639     }
640 
641     /**
642      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
643      *
644      * Counterpart to Solidity's `-` operator.
645      *
646      * Requirements:
647      * - Subtraction cannot underflow.
648      */
649     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
650         require(b <= a, errorMessage);
651         uint256 c = a - b;
652 
653         return c;
654     }
655 
656     /**
657      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
658      *
659      * Counterpart to Solidity's `*` operator.
660      *
661      * Requirements:
662      * - Multiplication cannot overflow.
663      */
664     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
665         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
666         // benefit is lost if 'b' is also tested.
667         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
668         if (a == 0) {
669             return 0;
670         }
671 
672         uint256 c = a * b;
673         require(c / a == b, "SafeMath: multiplication overflow");
674 
675         return c;
676     }
677 
678     /**
679      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
680      *
681      * Counterpart to Solidity's `*` operator.
682      *
683      * Requirements:
684      * - Multiplication cannot overflow.
685      */
686     function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
687         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
688         // benefit is lost if 'b' is also tested.
689         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
690         if (a == 0) {
691             return 0;
692         }
693 
694         uint256 c = a * b;
695         require(c / a == b, errorMessage);
696 
697         return c;
698     }
699 
700     /**
701      * @dev Returns the integer division of two unsigned integers.
702      * Reverts on division by zero. The result is rounded towards zero.
703      *
704      * Counterpart to Solidity's `/` operator. Note: this function uses a
705      * `revert` opcode (which leaves remaining gas untouched) while Solidity
706      * uses an invalid opcode to revert (consuming all remaining gas).
707      *
708      * Requirements:
709      * - The divisor cannot be zero.
710      */
711     function div(uint256 a, uint256 b) internal pure returns (uint256) {
712         return div(a, b, "SafeMath: division by zero");
713     }
714 
715     /**
716      * @dev Returns the integer division of two unsigned integers.
717      * Reverts with custom message on division by zero. The result is rounded towards zero.
718      *
719      * Counterpart to Solidity's `/` operator. Note: this function uses a
720      * `revert` opcode (which leaves remaining gas untouched) while Solidity
721      * uses an invalid opcode to revert (consuming all remaining gas).
722      *
723      * Requirements:
724      * - The divisor cannot be zero.
725      */
726     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
727         // Solidity only automatically asserts when dividing by 0
728         require(b > 0, errorMessage);
729         uint256 c = a / b;
730         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
731 
732         return c;
733     }
734 
735     /**
736      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
737      * Reverts when dividing by zero.
738      *
739      * Counterpart to Solidity's `%` operator. This function uses a `revert`
740      * opcode (which leaves remaining gas untouched) while Solidity uses an
741      * invalid opcode to revert (consuming all remaining gas).
742      *
743      * Requirements:
744      * - The divisor cannot be zero.
745      */
746     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
747         return mod(a, b, "SafeMath: modulo by zero");
748     }
749 
750     /**
751      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
752      * Reverts with custom message when dividing by zero.
753      *
754      * Counterpart to Solidity's `%` operator. This function uses a `revert`
755      * opcode (which leaves remaining gas untouched) while Solidity uses an
756      * invalid opcode to revert (consuming all remaining gas).
757      *
758      * Requirements:
759      * - The divisor cannot be zero.
760      */
761     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
762         require(b != 0, errorMessage);
763         return a % b;
764     }
765 }
766 
767 // File: contracts\ReentrancyGuard.sol
768 
769 pragma solidity ^0.5.16;
770 
771 /**
772  * @dev Contract module that helps prevent reentrant calls to a function.
773  *
774  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
775  * available, which can be applied to functions to make sure there are no nested
776  * (reentrant) calls to them.
777  *
778  * Note that because there is a single `nonReentrant` guard, functions marked as
779  * `nonReentrant` may not call one another. This can be worked around by making
780  * those functions `private`, and then adding `external` `nonReentrant` entry
781  * points to them.
782  *
783  * TIP: If you would like to learn more about reentrancy and alternative ways
784  * to protect against it, check out our blog post
785  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
786  */
787 contract ReentrancyGuard {
788     // Booleans are more expensive than uint256 or any type that takes up a full
789     // word because each write operation emits an extra SLOAD to first read the
790     // slot's contents, replace the bits taken up by the boolean, and then write
791     // back. This is the compiler's defense against contract upgrades and
792     // pointer aliasing, and it cannot be disabled.
793 
794     // The values being non-zero value makes deployment a bit more expensive,
795     // but in exchange the refund on every call to nonReentrant will be lower in
796     // amount. Since refunds are capped to a percentage of the total
797     // transaction's gas, it is best to keep them low in cases like this one, to
798     // increase the likelihood of the full refund coming into effect.
799     uint256 private constant _NOT_ENTERED = 1;
800     uint256 private constant _ENTERED = 2;
801 
802     uint256 private _status;
803 
804     constructor () internal {
805         _status = _NOT_ENTERED;
806     }
807 
808     /**
809      * @dev Prevents a contract from calling itself, directly or indirectly.
810      * Calling a `nonReentrant` function from another `nonReentrant`
811      * function is not supported. It is possible to prevent this from happening
812      * by making the `nonReentrant` function external, and make it call a
813      * `private` function that does the actual work.
814      */
815     modifier nonReentrant() {
816         // On the first call to nonReentrant, _notEntered will be true
817         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
818 
819         // Any calls to nonReentrant after this point will fail
820         _status = _ENTERED;
821 
822         _;
823 
824         // By storing the original value once again, a refund is triggered (see
825         // https://eips.ethereum.org/EIPS/eip-2200)
826         _status = _NOT_ENTERED;
827     }
828 }
829 
830 // File: contracts\ErrorReporter.sol
831 
832 pragma solidity ^0.5.16;
833 
834 contract ErrorReporter {
835     enum Error {
836         NO_ERROR,
837         UNAUTHORIZED,
838         BAD_INPUT,
839         REJECTION,
840         MATH_ERROR,
841         NOT_FRESH,
842         TOKEN_INSUFFICIENT_CASH,
843         TOKEN_TRANSFER_IN_FAILED,
844         TOKEN_TRANSFER_OUT_FAILED,
845         INSUFFICIENT_COLLATERAL
846     }
847 
848     /*
849      * Note: FailureInfo (but not Error) is kept in alphabetical order
850      *       This is because FailureInfo grows significantly faster, and
851      *       the order of Error has some meaning, while the order of FailureInfo
852      *       is entirely arbitrary.
853      */
854     enum FailureInfo {
855         ADMIN_CHECK,
856         PARTICIPANT_CHECK,
857         ACCRUE_INTEREST_FAILED,
858         ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED,
859         ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED,
860         ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED,
861         ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED,
862         ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED,
863         BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
864         BORROW_CASH_NOT_AVAILABLE,
865         BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
866         BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED,
867         BORROW_REJECTION,
868         BORROW_INSUFFICIENT_COLLATERAL,
869         MINT_REJECTION,
870         MINT_EXCHANGE_CALCULATION_FAILED,
871         MINT_EXCHANGE_RATE_READ_FAILED,
872         MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED,
873         MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
874         REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED,
875         REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED,
876         REDEEM_EXCHANGE_RATE_READ_FAILED,
877         REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED,
878         REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
879         REDEEM_TRANSFER_OUT_NOT_POSSIBLE,
880         REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
881         REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED,
882         REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
883         COLLATERALIZE_REJECTION,
884         REDEEM_COLLATERAL_ACCUMULATED_BORROW_CALCULATION_FAILED,
885         REDEEM_COLLATERAL_NEW_ACCOUNT_COLLATERAL_CALCULATION_FAILED,
886         REDEEM_COLLATERAL_INSUFFICIENT_COLLATERAL,
887         LIQUIDATE_BORROW_REJECTION,
888         LIQUIDATE_BORROW_COLLATERAL_RATE_CALCULATION_FAILED,
889         LIQUIDATE_BORROW_NOT_SATISFIED,
890         SET_RESERVE_FACTOR_BOUNDS_CHECK,
891         SET_LIQUIDATE_FACTOR_BOUNDS_CHECK,
892         TRANSFER_NOT_ALLOWED,
893         TRANSFER_NOT_ENOUGH,
894         TRANSFER_TOO_MUCH
895     }
896 
897     /**
898       * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
899       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
900       **/
901     event Failure(uint error, uint info, uint detail);
902 
903     /**
904       * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
905       */
906     function fail(Error err, FailureInfo info) internal returns (uint) {
907         emit Failure(uint(err), uint(info), 0);
908 
909         return uint(err);
910     }
911 
912     /**
913       * @dev use this when reporting an opaque error from an upgradeable collaborator contract
914       */
915     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
916         emit Failure(uint(err), uint(info), opaqueError);
917 
918         return uint(err);
919     }
920 }
921 
922 // File: contracts\InterestRateModel.sol
923 
924 pragma solidity ^0.5.16;
925 
926 /**
927   * @title Compound's InterestRateModel Interface
928   * @author Compound
929   */
930 contract InterestRateModel {
931     /// @notice Indicator that this is an InterestRateModel contract (for inspection)
932     bool public constant isInterestRateModel = true;
933 
934     /**
935       * @notice Calculates the current borrow interest rate per block
936       * @param cash The total amount of cash the market has
937       * @param borrows The total amount of borrows the market has outstanding
938       * @param reserves The total amnount of reserves the market has
939       * @return The borrow rate per block (as a percentage, and scaled by 1e18)
940       */
941     function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint);
942 
943     /**
944       * @notice Calculates the current supply interest rate per block
945       * @param cash The total amount of cash the market has
946       * @param borrows The total amount of borrows the market has outstanding
947       * @param reserves The total amnount of reserves the market has
948       * @param reserveFactorMantissa The current reserve factor the market has
949       * @return The supply rate per block (as a percentage, and scaled by 1e18)
950       */
951     function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);
952 
953 }
954 
955 // File: contracts\DFL.sol
956 
957 pragma solidity ^0.5.16;
958 pragma experimental ABIEncoderV2;
959 
960 
961 // forked from Compound/COMP
962 
963 /**
964  * @dev Contract module which provides a basic access control mechanism, where
965  * there is an account (an owner) that can be granted exclusive access to
966  * specific functions.
967  *
968  * By default, the owner account will be the one that deploys the contract. This
969  * can later be changed with {transferOwnership}.
970  *
971  * This module is used through inheritance. It will make available the modifier
972  * `onlyOwner`, which can be applied to your functions to restrict their use to
973  * the owner.
974  */
975 contract Ownable {
976     address private _owner;
977 
978     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
979 
980     /**
981      * @dev Initializes the contract setting the deployer as the initial owner.
982      */
983     constructor () internal {
984         _owner = msg.sender;
985         emit OwnershipTransferred(address(0), msg.sender);
986     }
987 
988     /**
989      * @dev Returns the address of the current owner.
990      */
991     function owner() public view returns (address) {
992         return _owner;
993     }
994 
995     /**
996      * @dev Throws if called by any account other than the owner.
997      */
998     modifier onlyOwner() {
999         require(_owner == msg.sender, "Ownable: caller is not the owner");
1000         _;
1001     }
1002 
1003     /**
1004      * @dev Leaves the contract without owner. It will not be possible to call
1005      * `onlyOwner` functions anymore. Can only be called by the current owner.
1006      *
1007      * NOTE: Renouncing ownership will leave the contract without an owner,
1008      * thereby removing any functionality that is only available to the owner.
1009      */
1010     function renounceOwnership() public onlyOwner {
1011         emit OwnershipTransferred(_owner, address(0));
1012         _owner = address(0);
1013     }
1014 
1015     /**
1016      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1017      * Can only be called by the current owner.
1018      */
1019     function transferOwnership(address newOwner) public onlyOwner {
1020         require(newOwner != address(0), "Ownable: new owner is the zero address");
1021         emit OwnershipTransferred(_owner, newOwner);
1022         _owner = newOwner;
1023     }
1024 }
1025 
1026 contract DFL is EIP20Interface, Ownable {
1027     /// @notice EIP-20 token name for this token
1028     string public constant name = "DeFIL";
1029 
1030     /// @notice EIP-20 token symbol for this token
1031     string public constant symbol = "DFL";
1032 
1033     /// @notice EIP-20 token decimals for this token
1034     uint8 public constant decimals = 18;
1035 
1036     /// @notice Total number of tokens in circulation
1037     uint96 internal _totalSupply;
1038 
1039     /// @notice Allowance amounts on behalf of others
1040     mapping (address => mapping (address => uint96)) internal allowances;
1041 
1042     /// @notice Official record of token balances for each account
1043     mapping (address => uint96) internal balances;
1044 
1045     /// @notice A record of each accounts delegate
1046     mapping (address => address) public delegates;
1047 
1048     /// @notice A checkpoint for marking number of votes from a given block
1049     struct Checkpoint {
1050         uint32 fromBlock;
1051         uint96 votes;
1052     }
1053 
1054     /// @notice A record of votes checkpoints for each account, by index
1055     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1056 
1057     /// @notice The number of checkpoints for each account
1058     mapping (address => uint32) public numCheckpoints;
1059 
1060     /// @notice The EIP-712 typehash for the contract's domain
1061     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1062 
1063     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1064     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1065 
1066     /// @notice A record of states for signing / validating signatures
1067     mapping (address => uint) public nonces;
1068 
1069     /// @notice An event thats emitted when an account changes its delegate
1070     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1071 
1072     /// @notice An event thats emitted when a delegate account's vote balance changes
1073     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1074 
1075     /// @notice The standard EIP-20 transfer event
1076     event Transfer(address indexed from, address indexed to, uint256 amount);
1077 
1078     /// @notice The standard EIP-20 approval event
1079     event Approval(address indexed owner, address indexed spender, uint256 amount);
1080 
1081     /**
1082      * @notice Construct a new DFL token
1083      */
1084     constructor() public {
1085         emit Transfer(address(0), address(this), 0);
1086     }
1087 
1088     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1089      * the total supply.
1090      * Emits a {Transfer} event with `from` set to the zero address.
1091      * @param account The address of the account holding the new funds
1092      * @param rawAmount The number of tokens that are minted
1093      */
1094     function mint(address account, uint rawAmount) public onlyOwner {
1095         require(account != address(0), "DFL:: mint: cannot mint to the zero address");
1096         uint96 amount = safe96(rawAmount, "DFL::mint: amount exceeds 96 bits");
1097         _totalSupply = add96(_totalSupply, amount, "DFL::mint: total supply exceeds");
1098         balances[account] = add96(balances[account], amount, "DFL::mint: mint amount exceeds balance");
1099 
1100         _moveDelegates(address(0), delegates[account], amount);
1101         emit Transfer(address(0), account, amount);
1102     }
1103 
1104     /**
1105      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
1106      * @param account The address of the account holding the funds
1107      * @param spender The address of the account spending the funds
1108      * @return The number of tokens approved
1109      */
1110     function allowance(address account, address spender) external view returns (uint) {
1111         return allowances[account][spender];
1112     }
1113 
1114     /**
1115      * @notice Approve `spender` to transfer up to `amount` from `src`
1116      * @dev This will overwrite the approval amount for `spender`
1117      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1118      * @param spender The address of the account which may transfer tokens
1119      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
1120      * @return Whether or not the approval succeeded
1121      */
1122     function approve(address spender, uint rawAmount) external returns (bool) {
1123         uint96 amount;
1124         if (rawAmount == uint(-1)) {
1125             amount = uint96(-1);
1126         } else {
1127             amount = safe96(rawAmount, "DFL::approve: amount exceeds 96 bits");
1128         }
1129 
1130         allowances[msg.sender][spender] = amount;
1131 
1132         emit Approval(msg.sender, spender, amount);
1133         return true;
1134     }
1135 
1136     /**
1137      * @notice Get the total supply of tokens
1138      * @return The total supply of tokens
1139      */
1140     function totalSupply() external view returns (uint) {
1141         return _totalSupply;
1142     }
1143 
1144     /**
1145      * @notice Get the number of tokens held by the `account`
1146      * @param account The address of the account to get the balance of
1147      * @return The number of tokens held
1148      */
1149     function balanceOf(address account) external view returns (uint) {
1150         return balances[account];
1151     }
1152 
1153     /**
1154      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1155      * @param dst The address of the destination account
1156      * @param rawAmount The number of tokens to transfer
1157      * @return Whether or not the transfer succeeded
1158      */
1159     function transfer(address dst, uint rawAmount) external returns (bool) {
1160         uint96 amount = safe96(rawAmount, "DFL::transfer: amount exceeds 96 bits");
1161         _transferTokens(msg.sender, dst, amount);
1162         return true;
1163     }
1164 
1165     /**
1166      * @notice Transfer `amount` tokens from `src` to `dst`
1167      * @param src The address of the source account
1168      * @param dst The address of the destination account
1169      * @param rawAmount The number of tokens to transfer
1170      * @return Whether or not the transfer succeeded
1171      */
1172     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
1173         address spender = msg.sender;
1174         uint96 spenderAllowance = allowances[src][spender];
1175         uint96 amount = safe96(rawAmount, "DFL::approve: amount exceeds 96 bits");
1176 
1177         if (spender != src && spenderAllowance != uint96(-1)) {
1178             uint96 newAllowance = sub96(spenderAllowance, amount, "DFL::transferFrom: transfer amount exceeds spender allowance");
1179             allowances[src][spender] = newAllowance;
1180 
1181             emit Approval(src, spender, newAllowance);
1182         }
1183 
1184         _transferTokens(src, dst, amount);
1185         return true;
1186     }
1187 
1188     /**
1189      * @notice Delegate votes from `msg.sender` to `delegatee`
1190      * @param delegatee The address to delegate votes to
1191      */
1192     function delegate(address delegatee) public {
1193         return _delegate(msg.sender, delegatee);
1194     }
1195 
1196     /**
1197      * @notice Delegates votes from signatory to `delegatee`
1198      * @param delegatee The address to delegate votes to
1199      * @param nonce The contract state required to match the signature
1200      * @param expiry The time at which to expire the signature
1201      * @param v The recovery byte of the signature
1202      * @param r Half of the ECDSA signature pair
1203      * @param s Half of the ECDSA signature pair
1204      */
1205     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
1206         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
1207         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
1208         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1209         address signatory = ecrecover(digest, v, r, s);
1210         require(signatory != address(0), "DFL::delegateBySig: invalid signature");
1211         require(nonce == nonces[signatory]++, "DFL::delegateBySig: invalid nonce");
1212         require(block.timestamp <= expiry, "DFL::delegateBySig: signature expired");
1213         return _delegate(signatory, delegatee);
1214     }
1215 
1216     /**
1217      * @notice Gets the current votes balance for `account`
1218      * @param account The address to get votes balance
1219      * @return The number of current votes for `account`
1220      */
1221     function getCurrentVotes(address account) external view returns (uint96) {
1222         uint32 nCheckpoints = numCheckpoints[account];
1223         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1224     }
1225 
1226     /**
1227      * @notice Determine the prior number of votes for an account as of a block number
1228      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1229      * @param account The address of the account to check
1230      * @param blockNumber The block number to get the vote balance at
1231      * @return The number of votes the account had as of the given block
1232      */
1233     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
1234         require(blockNumber < block.number, "DFL::getPriorVotes: not yet determined");
1235 
1236         uint32 nCheckpoints = numCheckpoints[account];
1237         if (nCheckpoints == 0) {
1238             return 0;
1239         }
1240 
1241         // First check most recent balance
1242         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1243             return checkpoints[account][nCheckpoints - 1].votes;
1244         }
1245 
1246         // Next check implicit zero balance
1247         if (checkpoints[account][0].fromBlock > blockNumber) {
1248             return 0;
1249         }
1250 
1251         uint32 lower = 0;
1252         uint32 upper = nCheckpoints - 1;
1253         while (upper > lower) {
1254             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1255             Checkpoint memory cp = checkpoints[account][center];
1256             if (cp.fromBlock == blockNumber) {
1257                 return cp.votes;
1258             } else if (cp.fromBlock < blockNumber) {
1259                 lower = center;
1260             } else {
1261                 upper = center - 1;
1262             }
1263         }
1264         return checkpoints[account][lower].votes;
1265     }
1266 
1267     function _delegate(address delegator, address delegatee) internal {
1268         address currentDelegate = delegates[delegator];
1269         uint96 delegatorBalance = balances[delegator];
1270         delegates[delegator] = delegatee;
1271 
1272         emit DelegateChanged(delegator, currentDelegate, delegatee);
1273 
1274         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1275     }
1276 
1277     function _transferTokens(address src, address dst, uint96 amount) internal {
1278         require(src != address(0), "DFL::_transferTokens: cannot transfer from the zero address");
1279         require(dst != address(0), "DFL::_transferTokens: cannot transfer to the zero address");
1280 
1281         balances[src] = sub96(balances[src], amount, "DFL::_transferTokens: transfer amount exceeds balance");
1282         balances[dst] = add96(balances[dst], amount, "DFL::_transferTokens: transfer amount overflows");
1283         emit Transfer(src, dst, amount);
1284 
1285         _moveDelegates(delegates[src], delegates[dst], amount);
1286     }
1287 
1288     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
1289         if (srcRep != dstRep && amount > 0) {
1290             if (srcRep != address(0)) {
1291                 uint32 srcRepNum = numCheckpoints[srcRep];
1292                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1293                 uint96 srcRepNew = sub96(srcRepOld, amount, "DFL::_moveVotes: vote amount underflows");
1294                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1295             }
1296 
1297             if (dstRep != address(0)) {
1298                 uint32 dstRepNum = numCheckpoints[dstRep];
1299                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1300                 uint96 dstRepNew = add96(dstRepOld, amount, "DFL::_moveVotes: vote amount overflows");
1301                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1302             }
1303         }
1304     }
1305 
1306     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
1307       uint32 blockNumber = safe32(block.number, "DFL::_writeCheckpoint: block number exceeds 32 bits");
1308 
1309       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1310           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1311       } else {
1312           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1313           numCheckpoints[delegatee] = nCheckpoints + 1;
1314       }
1315 
1316       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1317     }
1318 
1319     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1320         require(n < 2**32, errorMessage);
1321         return uint32(n);
1322     }
1323 
1324     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
1325         require(n < 2**96, errorMessage);
1326         return uint96(n);
1327     }
1328 
1329     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
1330         uint96 c = a + b;
1331         require(c >= a, errorMessage);
1332         return c;
1333     }
1334 
1335     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
1336         require(b <= a, errorMessage);
1337         return a - b;
1338     }
1339 
1340     function getChainId() internal pure returns (uint) {
1341         uint256 chainId;
1342         assembly { chainId := chainid() }
1343         return chainId;
1344     }
1345 }
1346 
1347 // File: contracts\DeFIL.sol
1348 
1349 pragma solidity ^0.5.16;
1350 
1351 // Forked from Compound/CToken
1352 
1353 
1354 
1355 
1356 
1357 
1358 
1359 
1360 contract DeFIL is ReentrancyGuard, EIP20Interface, Exponential, ErrorReporter {
1361     /**
1362      * @notice EIP-20 token name for this token
1363      */
1364     string public constant name = "Certificate of eFIL";
1365     /**
1366      * @notice EIP-20 token symbol for this token
1367      */
1368     string public constant symbol = "ceFIL";
1369     /**
1370      * @notice EIP-20 token decimals for this token
1371      */
1372     uint8 public constant decimals = 18;
1373     /**
1374      * @notice Maximum fraction of interest that can be set aside for reserves
1375      */
1376     uint internal constant reserveFactorMaxMantissa = 1e18;
1377     /**
1378      * @notice Address of eFIL token
1379      */
1380     address public eFILAddress;
1381     /**
1382      * @notice Address of mFIL token
1383      */
1384     address public mFILAddress;
1385     /**
1386      * @notice The address who owns the reserves
1387      */
1388     address public reservesOwner;
1389     /**
1390      * @notice Administrator for this contract
1391      */
1392     address public admin;
1393     /**
1394      * @notice Pending administrator for this contract
1395      */
1396     address public pendingAdmin;
1397     /**
1398      * @notice Model which tells what the current interest rate should be
1399      */
1400     InterestRateModel public interestRateModel;
1401     /**
1402      * @notice Initial exchange rate used when minting the first CTokens (used when totalSupply = 0)
1403      */
1404     uint internal constant initialExchangeRateMantissa = 0.002e18; // 1 eFIL = 500 ceFIL
1405     /**
1406      * @notice Fraction of interest currently set aside for reserves
1407      */
1408     uint public reserveFactorMantissa;
1409     /**
1410      * @notice Block number that interest was last accrued at
1411      */
1412     uint public accrualBlockNumber;
1413     /**
1414      * @notice Accumulator of the total earned interest rate since the opening
1415      */
1416     uint public borrowIndex;
1417     /**
1418      * @notice Total amount of outstanding borrows of the underlying
1419      */
1420     uint public totalBorrows;
1421     /**
1422      * @notice Total amount of reserves of the underlying held
1423      */
1424     uint public totalReserves;
1425     /**
1426      * @notice Total number of tokens in circulation
1427      */
1428     uint public totalSupply;
1429 
1430     // Is mint allowed.
1431     bool public mintAllowed;
1432     // Is borrow allowed.
1433     bool public borrowAllowed;
1434     /**
1435      * @notice Official record of token balances for each account
1436      */
1437     mapping (address => uint) internal accountTokens;
1438     /**
1439      * @notice Approved token transfer amounts on behalf of others
1440      */
1441     mapping (address => mapping (address => uint)) internal transferAllowances;
1442 
1443     /**
1444      * @notice Container for borrow balance information
1445      * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action
1446      * @member interestIndex Global borrowIndex as of the most recent balance-changing action
1447      */
1448     struct BorrowSnapshot {
1449         uint principal;
1450         uint interestIndex;
1451     }
1452     /**
1453      * @notice Mapping of account addresses to outstanding borrow balances
1454      */
1455     mapping(address => BorrowSnapshot) internal accountBorrows;
1456 
1457     // Total collaterals
1458     uint public totalCollaterals;
1459     // Mapping of account to outstanding collateral balances
1460     mapping (address => uint) internal accountCollaterals;
1461     // Multiplier used to decide when liquidate borrow is allowed
1462     uint public liquidateFactorMantissa;
1463     // No liquidateFactorMantissa may bellows this value
1464     uint internal constant liquidateFactorMinMantissa = 1e18; // 100%
1465 
1466     /*** For DFL ***/
1467     /**
1468      * @notice Address of DFL token
1469      */
1470     DFL public dflToken;
1471     // By using the special 'min speed=0.00017e18' and 'start speed=86.805721e18'
1472     // We will got 99999999.8568 DFLs in the end.
1473     // The havle period in block number
1474     uint internal constant halvePeriod = 576000; // 100 days
1475     // Minimum speed
1476     uint internal constant minSpeed = 0.00017e18; // 1e18 / 5760
1477     // Current speed (per block)
1478     uint public currentSpeed = 86.805721e18; // 500000e18 / 5760; // start with 500,000 per day
1479     // The block number when next havle will happens
1480     uint public nextHalveBlockNumber;
1481 
1482     // The address of uniswap incentive contract for receiving DFL
1483     address public uniswapAddress;
1484     // The address of miner league for receiving DFL
1485     address public minerLeagueAddress;
1486     // The address of operator for receiving DFL
1487     address public operatorAddress;
1488     // The address of technical support for receiving DFL
1489     address public technicalAddress;
1490     // The address for undistributed DFL
1491     address public undistributedAddress;
1492 
1493     // The percentage of DFL distributes to uniswap incentive
1494     uint public uniswapPercentage;
1495     // The percentage of DFL distributes to miner league
1496     uint public minerLeaguePercentage;
1497     // The percentage of DFL distributes to operator
1498     uint public operatorPercentage;
1499     // The percentage of DFL distributes to technical support, unupdatable
1500     uint internal constant technicalPercentage = 0.02e18; // 2%
1501 
1502     // The threshold above which the flywheel transfers DFL
1503     uint internal constant dflClaimThreshold = 0.1e18; // 0.1 DFL
1504     // Block number that DFL was last accrued at
1505     uint public dflAccrualBlockNumber;
1506     // The last updated index of DFL for suppliers
1507     uint public dflSupplyIndex;
1508     // The initial dfl supply index
1509     uint internal constant dflInitialSupplyIndex = 1e36;
1510     // The index for each supplier as of the last time they accrued DFL
1511     mapping(address => uint) public dflSupplierIndex;
1512     // The DFL accrued but not yet transferred to each user
1513     mapping(address => uint) public dflAccrued;
1514 
1515     /*** Events ***/
1516     /**
1517      * @notice Event emitted when interest is accrued
1518      */
1519     event AccrueInterest(uint cashPrior, uint interestAccumulated, uint borrowIndex, uint totalBorrows);
1520     /**
1521      * @notice Event emitted when tokens are minted
1522      */
1523     event Mint(address minter, uint mintAmount, uint mintTokens);
1524     /**
1525      * @notice Event emitted when mFIL are collateralized
1526      */
1527     event Collateralize(address collateralizer, uint collateralizeAmount);
1528     /**
1529      * @notice Event emitted when tokens are redeemed
1530      */
1531     event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);
1532     /**
1533      * @notice Event emitted when underlying is borrowed
1534      */
1535     event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);
1536     /**
1537      * @notice Event emitted when a borrow is repaid
1538      */
1539     event RepayBorrow(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);
1540     /**
1541      * @notice Event emitted when collaterals are redeemed
1542      */
1543     event RedeemCollateral(address redeemer, uint redeemAmount);
1544     /**
1545      * @notice Event emitted when a liquidate borrow is repaid
1546      */
1547     event LiquidateBorrow(address liquidator, address borrower, uint accountBorrows, uint accountCollaterals);
1548 
1549     /*** Admin Events ***/
1550     /**
1551      * @notice Event emitted when pendingAdmin is changed
1552      */
1553     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
1554     /**
1555      * @notice Event emitted when pendingAdmin is accepted, which means admin is updated
1556      */
1557     event NewAdmin(address oldAdmin, address newAdmin);
1558     /**
1559      * @notice Event emitted when mintAllowed is changed
1560      */
1561     event MintAllowed(bool mintAllowed);
1562     /**
1563      * @notice Event emitted when borrowAllowed is changed
1564      */
1565     event BorrowAllowed(bool borrowAllowed);
1566     /**
1567      * @notice Event emitted when interestRateModel is changed
1568      */
1569     event NewInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);
1570     /**
1571      * @notice Event emitted when the reserve factor is changed
1572      */
1573     event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);
1574     /**
1575      * @notice Event emitted when the liquidate factor is changed
1576      */
1577     event NewLiquidateFactor(uint oldLiquidateFactorMantissa, uint newLiquidateFactorMantissa);
1578     /**
1579      * @notice EIP20 Transfer event
1580      */
1581     event Transfer(address indexed from, address indexed to, uint amount);
1582     /**
1583      * @notice EIP20 Approval event
1584      */
1585     event Approval(address indexed owner, address indexed spender, uint amount);
1586     /**
1587      * @notice Failure event
1588      */
1589     event Failure(uint error, uint info, uint detail);
1590 
1591     // Event emitted when reserves owner is changed
1592     event ReservesOwnerChanged(address oldAddress, address newAddress);
1593     // Event emitted when uniswap address is changed
1594     event UniswapAddressChanged(address oldAddress, address newAddress);
1595     // Event emitted when miner leagure address is changed
1596     event MinerLeagueAddressChanged(address oldAddress, address newAddress);
1597     // Event emitted when operator address is changed
1598     event OperatorAddressChanged(address oldAddress, address newAddress);
1599     // Event emitted when technical address is changed
1600     event TechnicalAddressChanged(address oldAddress, address newAddress);
1601     // Event emitted when undistributed address is changed
1602     event UndistributedAddressChanged(address oldAddress, address newAddress);
1603     // Event emitted when reserved is reduced
1604     event ReservesReduced(address toTho, uint amount);
1605     // Event emitted when DFL is accrued
1606     event AccrueDFL(uint uniswapPart, uint minerLeaguePart, uint operatorPart, uint technicalPart, uint supplyPart, uint dflSupplyIndex);
1607     // Emitted when DFL is distributed to a supplier
1608     event DistributedDFL(address supplier, uint supplierDelta);
1609     // Event emitted when DFL percentage is changed
1610     event PercentagesChanged(uint uniswapPercentage, uint minerLeaguePercentage, uint operatorPercentage);
1611 
1612     /**
1613      * @notice constructor
1614      */
1615     constructor(address interestRateModelAddress,
1616                 address eFILAddress_,
1617                 address mFILAddress_,
1618                 address dflAddress_,
1619                 address reservesOwner_,
1620                 address uniswapAddress_,
1621                 address minerLeagueAddress_,
1622                 address operatorAddress_,
1623                 address technicalAddress_,
1624                 address undistributedAddress_) public {
1625         // set admin
1626         admin = msg.sender;
1627 
1628         // Initialize block number and borrow index
1629         accrualBlockNumber = getBlockNumber();
1630         borrowIndex = mantissaOne;
1631 
1632         // reserve 50%
1633         uint err = _setReserveFactorFresh(0.5e18);
1634         require(err == uint(Error.NO_ERROR), "setting reserve factor failed");
1635 
1636         // set liquidate factor to 200%
1637         err = _setLiquidateFactorFresh(2e18);
1638         require(err == uint(Error.NO_ERROR), "setting liquidate factor failed");
1639 
1640         // Set the interest rate model (depends on block number / borrow index)
1641         err = _setInterestRateModelFresh(InterestRateModel(interestRateModelAddress));
1642         require(err == uint(Error.NO_ERROR), "setting interest rate model failed");
1643 
1644         // uniswapPercentage = 0.25e18; // 25%
1645         // minerLeaguePercentage = 0.1e18; // 10%
1646         // operatorPercentage = 0.03e18; // 3%
1647         err = _setDFLPercentagesFresh(0.25e18, 0.1e18, 0.03e18);
1648         require(err == uint(Error.NO_ERROR), "setting DFL percentages failed");
1649 
1650         // allow mint/borrow
1651         mintAllowed = true;
1652         borrowAllowed = true;
1653 
1654         // token addresses & tokens
1655         eFILAddress = eFILAddress_;
1656         mFILAddress = mFILAddress_;
1657         dflToken = DFL(dflAddress_);
1658         // set owner of reserves
1659         reservesOwner = reservesOwner_;
1660 
1661         // DFL
1662         dflAccrualBlockNumber = getBlockNumber();
1663         dflSupplyIndex = dflInitialSupplyIndex;
1664         nextHalveBlockNumber = dflAccrualBlockNumber + halvePeriod;
1665 
1666         // DFL addresses
1667         uniswapAddress = uniswapAddress_;
1668         minerLeagueAddress = minerLeagueAddress_;
1669         operatorAddress = operatorAddress_;
1670         technicalAddress = technicalAddress_;
1671         undistributedAddress = undistributedAddress_;
1672 
1673         emit Transfer(address(0), address(this), 0);
1674     }
1675 
1676     /**
1677      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
1678      * @dev Called by both `transfer` and `transferFrom` internally
1679      * @param spender The address of the account performing the transfer
1680      * @param src The address of the source account
1681      * @param dst The address of the destination account
1682      * @param tokens The number of tokens to transfer
1683      * @return Whether or not the transfer succeeded
1684      */
1685     function transferTokens(address spender, address src, address dst, uint tokens) internal returns (uint) {
1686         /* Do not allow self-transfers */
1687         if (src == dst || dst == address(0)) {
1688             return fail(Error.BAD_INPUT, FailureInfo.TRANSFER_NOT_ALLOWED);
1689         }
1690 
1691         // Keep the flywheel moving
1692         accrueDFL();
1693         distributeSupplierDFL(src, false);
1694         distributeSupplierDFL(dst, false);
1695 
1696         /* Get the allowance, infinite for the account owner */
1697         uint startingAllowance = 0;
1698         if (spender == src) {
1699             startingAllowance = uint(-1);
1700         } else {
1701             startingAllowance = transferAllowances[src][spender];
1702         }
1703 
1704         /* Do the calculations, checking for {under,over}flow */
1705         MathError mathErr;
1706         uint allowanceNew;
1707         uint srcTokensNew;
1708         uint dstTokensNew;
1709 
1710         (mathErr, allowanceNew) = subUInt(startingAllowance, tokens);
1711         if (mathErr != MathError.NO_ERROR) {
1712             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ALLOWED);
1713         }
1714 
1715         (mathErr, srcTokensNew) = subUInt(accountTokens[src], tokens);
1716         if (mathErr != MathError.NO_ERROR) {
1717             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ENOUGH);
1718         }
1719 
1720         (mathErr, dstTokensNew) = addUInt(accountTokens[dst], tokens);
1721         if (mathErr != MathError.NO_ERROR) {
1722             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_TOO_MUCH);
1723         }
1724 
1725         /////////////////////////
1726         // EFFECTS & INTERACTIONS
1727         // (No safe failures beyond this point)
1728 
1729         accountTokens[src] = srcTokensNew;
1730         accountTokens[dst] = dstTokensNew;
1731 
1732         /* Eat some of the allowance (if necessary) */
1733         if (startingAllowance != uint(-1)) {
1734             transferAllowances[src][spender] = allowanceNew;
1735         }
1736 
1737         /* We emit a Transfer event */
1738         emit Transfer(src, dst, tokens);
1739         return uint(Error.NO_ERROR);
1740     }
1741 
1742     /**
1743      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1744      * @param dst The address of the destination account
1745      * @param amount The number of tokens to transfer
1746      * @return Whether or not the transfer succeeded
1747      */
1748     function transfer(address dst, uint256 amount) external nonReentrant returns (bool) {
1749         return transferTokens(msg.sender, msg.sender, dst, amount) == uint(Error.NO_ERROR);
1750     }
1751 
1752     /**
1753      * @notice Transfer `amount` tokens from `src` to `dst`
1754      * @param src The address of the source account
1755      * @param dst The address of the destination account
1756      * @param amount The number of tokens to transfer
1757      * @return Whether or not the transfer succeeded
1758      */
1759     function transferFrom(address src, address dst, uint256 amount) external nonReentrant returns (bool) {
1760         return transferTokens(msg.sender, src, dst, amount) == uint(Error.NO_ERROR);
1761     }
1762 
1763     /**
1764      * @notice Approve `spender` to transfer up to `amount` from `src`
1765      * @dev This will overwrite the approval amount for `spender`
1766      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1767      * @param spender The address of the account which may transfer tokens
1768      * @param amount The number of tokens that are approved (-1 means infinite)
1769      * @return Whether or not the approval succeeded
1770      */
1771     function approve(address spender, uint256 amount) external returns (bool) {
1772         require(spender != address(0), "cannot approve to the zero address");
1773         address src = msg.sender;
1774         transferAllowances[src][spender] = amount;
1775         emit Approval(src, spender, amount);
1776         return true;
1777     }
1778 
1779     /**
1780      * @notice Get the current allowance from `owner` for `spender`
1781      * @param owner The address of the account which owns the tokens to be spent
1782      * @param spender The address of the account which may transfer tokens
1783      * @return The number of tokens allowed to be spent (-1 means infinite)
1784      */
1785     function allowance(address owner, address spender) external view returns (uint256) {
1786         return transferAllowances[owner][spender];
1787     }
1788 
1789     /**
1790      * @notice Get the token balance of the `owner`
1791      * @param owner The address of the account to query
1792      * @return The number of tokens owned by `owner`
1793      */
1794     function balanceOf(address owner) external view returns (uint256) {
1795         return accountTokens[owner];
1796     }
1797 
1798     /**
1799      * @notice Get the underlying balance of the `owner`
1800      * @dev This also accrues interest in a transaction
1801      * @param owner The address of the account to query
1802      * @return The amount of underlying owned by `owner`
1803      */
1804     function balanceOfUnderlying(address owner) external returns (uint) {
1805         Exp memory exchangeRate = Exp({mantissa: exchangeRateCurrent()});
1806         (MathError mErr, uint balance) = mulScalarTruncate(exchangeRate, accountTokens[owner]);
1807         require(mErr == MathError.NO_ERROR, "balance could not be calculated");
1808         return balance;
1809     }
1810 
1811     /**
1812      * @notice Get the collateral of the `account`
1813      * @param account The address of the account to query
1814      * @return The number of collaterals owned by `account`
1815      */
1816     function getCollateral(address account) external view returns (uint256) {
1817         return accountCollaterals[account];
1818     }
1819 
1820     /**
1821      * @dev Function to simply retrieve block number
1822      *  This exists mainly for inheriting test contracts to stub this result.
1823      */
1824     function getBlockNumber() internal view returns (uint) {
1825         return block.number;
1826     }
1827 
1828     /**
1829      * @notice Returns the current per-block borrow interest rate
1830      * @return The borrow interest rate per block, scaled by 1e18
1831      */
1832     function borrowRatePerBlock() external view returns (uint) {
1833         return interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1834     }
1835 
1836     /**
1837      * @notice Returns the current per-block supply interest rate
1838      * @return The supply interest rate per block, scaled by 1e18
1839      */
1840     function supplyRatePerBlock() external view returns (uint) {
1841         return interestRateModel.getSupplyRate(getCashPrior(), totalBorrows, totalReserves, reserveFactorMantissa);
1842     }
1843 
1844     /**
1845      * @notice Returns the current total borrows plus accrued interest
1846      * @return The total borrows with interest
1847      */
1848     function totalBorrowsCurrent() external nonReentrant returns (uint) {
1849         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1850         return totalBorrows;
1851     }
1852 
1853     /**
1854      * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
1855      * @param account The address whose balance should be calculated after updating borrowIndex
1856      * @return The calculated balance
1857      */
1858     function borrowBalanceCurrent(address account) external nonReentrant returns (uint) {
1859         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1860         return borrowBalanceStored(account);
1861     }
1862 
1863     /**
1864      * @notice Return the borrow balance of account based on stored data
1865      * @param account The address whose balance should be calculated
1866      * @return The calculated balance
1867      */
1868     function borrowBalanceStored(address account) public view returns (uint) {
1869         (MathError err, uint result) = borrowBalanceStoredInternal(account);
1870         require(err == MathError.NO_ERROR, "borrowBalanceStored: borrowBalanceStoredInternal failed");
1871         return result;
1872     }
1873 
1874     /**
1875      * @notice Return the borrow balance of account based on stored data
1876      * @param account The address whose balance should be calculated
1877      * @return (error code, the calculated balance or 0 if error code is non-zero)
1878      */
1879     function borrowBalanceStoredInternal(address account) internal view returns (MathError, uint) {
1880         /* Note: we do not assert that is up to date */
1881         MathError mathErr;
1882         uint principalTimesIndex;
1883         uint result;
1884 
1885         /* Get borrowBalance and borrowIndex */
1886         BorrowSnapshot storage borrowSnapshot = accountBorrows[account];
1887 
1888         /* If borrowBalance = 0 then borrowIndex is likely also 0.
1889          * Rather than failing the calculation with a division by 0, we immediately return 0 in this case.
1890          */
1891         if (borrowSnapshot.principal == 0) {
1892             return (MathError.NO_ERROR, 0);
1893         }
1894 
1895         /* Calculate new borrow balance using the interest index:
1896          *  recentBorrowBalance = borrower.borrowBalance * global.borrowIndex / borrower.borrowIndex
1897          */
1898         (mathErr, principalTimesIndex) = mulUInt(borrowSnapshot.principal, borrowIndex);
1899         if (mathErr != MathError.NO_ERROR) {
1900             return (mathErr, 0);
1901         }
1902 
1903         (mathErr, result) = divUInt(principalTimesIndex, borrowSnapshot.interestIndex);
1904         if (mathErr != MathError.NO_ERROR) {
1905             return (mathErr, 0);
1906         }
1907 
1908         return (MathError.NO_ERROR, result);
1909     }
1910 
1911     /**
1912      * @notice Accrue interest then return the up-to-date exchange rate
1913      * @return Calculated exchange rate scaled by 1e18
1914      */
1915     function exchangeRateCurrent() public returns (uint) {
1916         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1917         return exchangeRateStored();
1918     }
1919 
1920     /**
1921      * @notice Calculates the exchange rate from the underlying to the ceFIL
1922      * @dev This function does not accrue interest before calculating the exchange rate
1923      * @return Calculated exchange rate scaled by 1e18
1924      */
1925     function exchangeRateStored() public view returns (uint) {
1926         (MathError err, uint result) = exchangeRateStoredInternal();
1927         require(err == MathError.NO_ERROR, "exchangeRateStored: exchangeRateStoredInternal failed");
1928         return result;
1929     }
1930 
1931     /**
1932      * @notice Calculates the exchange rate from the underlying to the ceFIL
1933      * @dev This function does not accrue interest before calculating the exchange rate
1934      * @return (error code, calculated exchange rate scaled by 1e18)
1935      */
1936     function exchangeRateStoredInternal() internal view returns (MathError, uint) {
1937         uint _totalSupply = totalSupply;
1938         if (_totalSupply == 0) {
1939             /*
1940              * If there are no tokens minted:
1941              *  exchangeRate = initialExchangeRate
1942              */
1943             return (MathError.NO_ERROR, initialExchangeRateMantissa);
1944         } else {
1945             /*
1946              * Otherwise:
1947              *  exchangeRate = (totalCash + totalBorrows - totalReserves) / totalSupply
1948              */
1949             uint totalCash = getCashPrior();
1950             uint cashPlusBorrowsMinusReserves;
1951             Exp memory exchangeRate;
1952             MathError mathErr;
1953 
1954             (mathErr, cashPlusBorrowsMinusReserves) = addThenSubUInt(totalCash, totalBorrows, totalReserves);
1955             if (mathErr != MathError.NO_ERROR) {
1956                 return (mathErr, 0);
1957             }
1958 
1959             (mathErr, exchangeRate) = getExp(cashPlusBorrowsMinusReserves, _totalSupply);
1960             if (mathErr != MathError.NO_ERROR) {
1961                 return (mathErr, 0);
1962             }
1963 
1964             return (MathError.NO_ERROR, exchangeRate.mantissa);
1965         }
1966     }
1967 
1968     /**
1969      * @notice Accrue interest then return the up-to-date collateral rate
1970      * @return Calculated collateral rate scaled by 1e18
1971      */
1972     function collateralRateCurrent(address borrower) external returns (uint) {
1973         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1974         return collateralRateStored(borrower);
1975     }
1976 
1977     /**
1978      * @notice Calculates the collateral rate of borrower from stored states
1979      * @dev This function does not accrue interest before calculating the collateral rate
1980      * @return Calculated exchange rate scaled by 1e18
1981      */
1982     function collateralRateStored(address borrower) public view returns (uint) {
1983         (MathError err, uint rate, ,) = collateralRateInternal(borrower);
1984         require(err == MathError.NO_ERROR, "collateralRateStored: collateralRateInternal failed");
1985         return rate;
1986     }
1987 
1988     function collateralRateInternal(address borrower) internal view returns (MathError, uint, uint, uint) {
1989         MathError mathErr;
1990         uint _accountBorrows;
1991         uint _accountCollaterals;
1992         Exp memory collateralRate;
1993 
1994         (mathErr, _accountBorrows) = borrowBalanceStoredInternal(borrower);
1995         if (mathErr != MathError.NO_ERROR) {
1996             return (mathErr, 0, 0, 0);
1997         }
1998 
1999         _accountCollaterals = accountCollaterals[borrower];
2000         (mathErr, collateralRate) = getExp(_accountBorrows, _accountCollaterals);
2001         if (mathErr != MathError.NO_ERROR) {
2002             return (mathErr, 0, 0, 0);
2003         }
2004 
2005         return (MathError.NO_ERROR, collateralRate.mantissa, _accountBorrows, _accountCollaterals);
2006     }
2007 
2008     // Accrue DFL then return the up-to-date accrued amount
2009     function accruedDFLCurrent(address supplier) external nonReentrant returns (uint) {
2010         accrueDFL();
2011         return accruedDFLStoredInternal(supplier);
2012     }
2013 
2014     // Accrue DFL then return the up-to-date accrued amount
2015     function accruedDFLStored(address supplier) public view returns (uint) {
2016         return accruedDFLStoredInternal(supplier);
2017     }
2018 
2019     // Return the accrued DFL of account based on stored data
2020     function accruedDFLStoredInternal(address supplier) internal view returns(uint) {
2021         Double memory supplyIndex = Double({mantissa: dflSupplyIndex});
2022         Double memory supplierIndex = Double({mantissa: dflSupplierIndex[supplier]});
2023         if (supplierIndex.mantissa == 0 && supplyIndex.mantissa > 0) {
2024             supplierIndex.mantissa = dflInitialSupplyIndex;
2025         }
2026 
2027         Double memory deltaIndex = sub_(supplyIndex, supplierIndex);
2028         uint supplierDelta = mul_(accountTokens[supplier], deltaIndex);
2029         uint supplierAccrued = add_(dflAccrued[supplier], supplierDelta);
2030         return supplierAccrued;
2031     }
2032 
2033     /**
2034      * @notice Get cash balance of this in the underlying asset
2035      * @return The quantity of underlying asset owned by this contract
2036      */
2037     function getCash() external view returns (uint) {
2038         return getCashPrior();
2039     }
2040 
2041     /**
2042      * @notice Applies accrued interest to total borrows and reserves
2043      * @dev This calculates interest accrued from the last checkpointed block
2044      *   up to the current block and writes new checkpoint to storage.
2045      */
2046     function accrueInterest() public returns (uint) {
2047         /* Remember the initial block number */
2048         uint currentBlockNumber = getBlockNumber();
2049         uint accrualBlockNumberPrior = accrualBlockNumber;
2050 
2051         /* Short-circuit accumulating 0 interest */
2052         if (accrualBlockNumberPrior == currentBlockNumber) {
2053             return uint(Error.NO_ERROR);
2054         }
2055 
2056         /* Read the previous values out of storage */
2057         uint cashPrior = getCashPrior();
2058         uint borrowsPrior = totalBorrows;
2059         uint reservesPrior = totalReserves;
2060         uint borrowIndexPrior = borrowIndex;
2061 
2062         /* Calculate the current borrow interest rate */
2063         uint borrowRateMantissa = interestRateModel.getBorrowRate(cashPrior, borrowsPrior, reservesPrior);
2064 
2065         /* Calculate the number of blocks elapsed since the last accrual */
2066         (MathError mathErr, uint blockDelta) = subUInt(currentBlockNumber, accrualBlockNumberPrior);
2067         require(mathErr == MathError.NO_ERROR, "could not calculate block delta");
2068 
2069         /*
2070          * Calculate the interest accumulated into borrows and reserves and the new index:
2071          *  simpleInterestFactor = borrowRate * blockDelta
2072          *  interestAccumulated = simpleInterestFactor * totalBorrows
2073          *  totalBorrowsNew = interestAccumulated + totalBorrows
2074          *  totalReservesNew = interestAccumulated * reserveFactor + totalReserves
2075          *  borrowIndexNew = simpleInterestFactor * borrowIndex + borrowIndex
2076          */
2077 
2078         Exp memory simpleInterestFactor;
2079         uint interestAccumulated;
2080         uint totalBorrowsNew;
2081         uint totalReservesNew;
2082         uint borrowIndexNew;
2083 
2084         (mathErr, simpleInterestFactor) = mulScalar(Exp({mantissa: borrowRateMantissa}), blockDelta);
2085         if (mathErr != MathError.NO_ERROR) {
2086             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED, uint(mathErr));
2087         }
2088 
2089         (mathErr, interestAccumulated) = mulScalarTruncate(simpleInterestFactor, borrowsPrior);
2090         if (mathErr != MathError.NO_ERROR) {
2091             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED, uint(mathErr));
2092         }
2093 
2094         (mathErr, totalBorrowsNew) = addUInt(interestAccumulated, borrowsPrior);
2095         if (mathErr != MathError.NO_ERROR) {
2096             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED, uint(mathErr));
2097         }
2098 
2099         (mathErr, totalReservesNew) = mulScalarTruncateAddUInt(Exp({mantissa: reserveFactorMantissa}), interestAccumulated, reservesPrior);
2100         if (mathErr != MathError.NO_ERROR) {
2101             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED, uint(mathErr));
2102         }
2103 
2104         (mathErr, borrowIndexNew) = mulScalarTruncateAddUInt(simpleInterestFactor, borrowIndexPrior, borrowIndexPrior);
2105         if (mathErr != MathError.NO_ERROR) {
2106             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED, uint(mathErr));
2107         }
2108 
2109         /////////////////////////
2110         // EFFECTS & INTERACTIONS
2111         // (No safe failures beyond this point)
2112 
2113         /* We write the previously calculated values into storage */
2114         accrualBlockNumber = currentBlockNumber;
2115         borrowIndex = borrowIndexNew;
2116         totalBorrows = totalBorrowsNew;
2117         totalReserves = totalReservesNew;
2118 
2119         /* We emit an AccrueInterest event */
2120         emit AccrueInterest(cashPrior, interestAccumulated, borrowIndexNew, totalBorrowsNew);
2121 
2122         return uint(Error.NO_ERROR);
2123     }
2124 
2125     /**
2126      * @notice Sender supplies assets into and receives cTokens in exchange
2127      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2128      * @param mintAmount The amount of the underlying asset to supply
2129      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2130      */
2131     function mint(uint mintAmount) external nonReentrant returns (uint) {
2132         uint err = accrueInterest();
2133         if (err != uint(Error.NO_ERROR)) {
2134             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
2135             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
2136         }
2137 
2138         // Keep the flywheel moving
2139         accrueDFL();
2140         distributeSupplierDFL(msg.sender, false);
2141 
2142         // mintFresh emits the actual Mint event if successful and logs on errors, so we don't need to
2143         (err,) = mintFresh(msg.sender, mintAmount);
2144         return err;
2145     }
2146 
2147     struct MintLocalVars {
2148         Error err;
2149         MathError mathErr;
2150         uint exchangeRateMantissa;
2151         uint mintTokens;
2152         uint totalSupplyNew;
2153         uint accountTokensNew;
2154         uint actualMintAmount;
2155     }
2156 
2157     /**
2158      * @notice User supplies assets into and receives cTokens in exchange
2159      * @dev Assumes interest has already been accrued up to the current block
2160      * @param minter The address of the account which is supplying the assets
2161      * @param mintAmount The amount of the underlying asset to supply
2162      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual mint amount.
2163      */
2164     function mintFresh(address minter, uint mintAmount) internal returns (uint, uint) {
2165         if (!mintAllowed || accountCollaterals[minter] != 0) {
2166             return (fail(Error.REJECTION, FailureInfo.MINT_REJECTION), 0);
2167         }
2168 
2169         MintLocalVars memory vars;
2170 
2171         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
2172         if (vars.mathErr != MathError.NO_ERROR) {
2173             return (failOpaque(Error.MATH_ERROR, FailureInfo.MINT_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr)), 0);
2174         }
2175 
2176         /////////////////////////
2177         // EFFECTS & INTERACTIONS
2178         // (No safe failures beyond this point)
2179         vars.actualMintAmount = doTransferIn(eFILAddress, minter, mintAmount);
2180 
2181         /*
2182          * We get the current exchange rate and calculate the number of cTokens to be minted:
2183          *  mintTokens = actualMintAmount / exchangeRate
2184          */
2185 
2186         (vars.mathErr, vars.mintTokens) = divScalarByExpTruncate(vars.actualMintAmount, Exp({mantissa: vars.exchangeRateMantissa}));
2187         require(vars.mathErr == MathError.NO_ERROR, "MINT_EXCHANGE_CALCULATION_FAILED");
2188 
2189         /*
2190          * We calculate the new total supply of cTokens and minter token balance, checking for overflow:
2191          *  totalSupplyNew = totalSupply + mintTokens
2192          *  accountTokensNew = accountTokens[minter] + mintTokens
2193          */
2194         (vars.mathErr, vars.totalSupplyNew) = addUInt(totalSupply, vars.mintTokens);
2195         require(vars.mathErr == MathError.NO_ERROR, "MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED");
2196 
2197         (vars.mathErr, vars.accountTokensNew) = addUInt(accountTokens[minter], vars.mintTokens);
2198         require(vars.mathErr == MathError.NO_ERROR, "MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED");
2199 
2200         /* We write previously calculated values into storage */
2201         totalSupply = vars.totalSupplyNew;
2202         accountTokens[minter] = vars.accountTokensNew;
2203 
2204         /* We emit a Mint event, and a Transfer event */
2205         emit Mint(minter, vars.actualMintAmount, vars.mintTokens);
2206         emit Transfer(address(this), minter, vars.mintTokens);
2207 
2208         return (uint(Error.NO_ERROR), vars.actualMintAmount);
2209     }
2210 
2211     /**
2212      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2213      * @param collateralizeAmount The amount of the underlying asset to collateralize
2214      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2215      */
2216     function collateralize(uint collateralizeAmount) external nonReentrant returns (uint) {
2217         uint err = accrueInterest();
2218         if (err != uint(Error.NO_ERROR)) {
2219             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
2220             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
2221         }
2222 
2223         // Keep the flywheel moving
2224         accrueDFL();
2225 
2226         (err,) = collateralizeFresh(msg.sender, collateralizeAmount);
2227         return err;
2228     }
2229 
2230     struct CollateralizeLocalVars {
2231         Error err;
2232         MathError mathErr;
2233         uint totalCollateralsNew;
2234         uint accountCollateralsNew;
2235         uint actualCollateralizeAmount;
2236     }
2237 
2238     /**
2239      * @param collateralizer The address of the account which is supplying the assets
2240      * @param collateralizeAmount The amount of the underlying asset to supply
2241      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual collateralize amount.
2242      */
2243     function collateralizeFresh(address collateralizer, uint collateralizeAmount) internal returns (uint, uint) {
2244         if (accountTokens[collateralizer] != 0) {
2245             return (fail(Error.REJECTION, FailureInfo.COLLATERALIZE_REJECTION), 0);
2246         }
2247 
2248         CollateralizeLocalVars memory vars;
2249 
2250         /////////////////////////
2251         // EFFECTS & INTERACTIONS
2252         // (No safe failures beyond this point)
2253         vars.actualCollateralizeAmount = doTransferIn(mFILAddress, collateralizer, collateralizeAmount);
2254 
2255         (vars.mathErr, vars.totalCollateralsNew) = addUInt(totalCollaterals, vars.actualCollateralizeAmount);
2256         require(vars.mathErr == MathError.NO_ERROR, "COLLATERALIZE_NEW_TOTAL_COLLATERALS_CALCULATION_FAILED");
2257 
2258         (vars.mathErr, vars.accountCollateralsNew) = addUInt(accountCollaterals[collateralizer], vars.actualCollateralizeAmount);
2259         require(vars.mathErr == MathError.NO_ERROR, "COLLATERALIZE_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED");
2260 
2261         /* We write previously calculated values into storage */
2262         totalCollaterals = vars.totalCollateralsNew;
2263         accountCollaterals[collateralizer] = vars.accountCollateralsNew;
2264 
2265         /* We emit a Collateralize event, and a Transfer event */
2266         emit Collateralize(collateralizer, vars.actualCollateralizeAmount);
2267         return (uint(Error.NO_ERROR), vars.actualCollateralizeAmount);
2268     }
2269 
2270     /**
2271      * @notice Sender redeems cTokens in exchange for the underlying asset
2272      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2273      * @param redeemTokens The number of cTokens to redeem into underlying
2274      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2275      */
2276     function redeem(uint redeemTokens) external nonReentrant returns (uint) {
2277         uint err = accrueInterest();
2278         if (err != uint(Error.NO_ERROR)) {
2279             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
2280             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
2281         }
2282 
2283         // Keep the flywheel moving
2284         accrueDFL();
2285         distributeSupplierDFL(msg.sender, false);
2286 
2287         // redeemFresh emits redeem-specific logs on errors, so we don't need to
2288         return redeemFresh(msg.sender, redeemTokens, 0);
2289     }
2290 
2291     /**
2292      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
2293      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2294      * @param redeemAmount The amount of underlying to redeem
2295      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2296      */
2297     function redeemUnderlying(uint redeemAmount) external nonReentrant returns (uint) {
2298         uint err = accrueInterest();
2299         if (err != uint(Error.NO_ERROR)) {
2300             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
2301             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
2302         }
2303         // Keep the flywheel moving
2304         accrueDFL();
2305         distributeSupplierDFL(msg.sender, false);
2306 
2307         // redeemFresh emits redeem-specific logs on errors, so we don't need to
2308         return redeemFresh(msg.sender, 0, redeemAmount);
2309     }
2310 
2311     struct RedeemLocalVars {
2312         Error err;
2313         MathError mathErr;
2314         uint exchangeRateMantissa;
2315         uint redeemTokens;
2316         uint redeemAmount;
2317         uint totalSupplyNew;
2318         uint accountTokensNew;
2319     }
2320 
2321     /**
2322      * @notice User redeems cTokens in exchange for the underlying asset
2323      * @dev Assumes interest has already been accrued up to the current block
2324      * @param redeemer The address of the account which is redeeming the tokens
2325      * @param redeemTokensIn The number of cTokens to redeem into underlying (only one of redeemTokensIn or redeemAmountIn may be non-zero)
2326      * @param redeemAmountIn The number of underlying tokens to receive from redeeming cTokens (only one of redeemTokensIn or redeemAmountIn may be non-zero)
2327      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2328      */
2329     function redeemFresh(address redeemer, uint redeemTokensIn, uint redeemAmountIn) internal returns (uint) {
2330         require(redeemTokensIn == 0 || redeemAmountIn == 0, "one of redeemTokensIn or redeemAmountIn must be zero");
2331 
2332         RedeemLocalVars memory vars;
2333 
2334         /* exchangeRate = invoke Exchange Rate Stored() */
2335         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
2336         if (vars.mathErr != MathError.NO_ERROR) {
2337             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr));
2338         }
2339 
2340         /* If redeemTokensIn > 0: */
2341         if (redeemTokensIn > 0) {
2342             /*
2343              * We calculate the exchange rate and the amount of underlying to be redeemed:
2344              *  redeemTokens = redeemTokensIn
2345              *  redeemAmount = redeemTokensIn x exchangeRateCurrent
2346              */
2347             vars.redeemTokens = redeemTokensIn;
2348 
2349             (vars.mathErr, vars.redeemAmount) = mulScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), redeemTokensIn);
2350             if (vars.mathErr != MathError.NO_ERROR) {
2351                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED, uint(vars.mathErr));
2352             }
2353         } else {
2354             /*
2355              * We get the current exchange rate and calculate the amount to be redeemed:
2356              *  redeemTokens = redeemAmountIn / exchangeRate
2357              *  redeemAmount = redeemAmountIn
2358              */
2359 
2360             (vars.mathErr, vars.redeemTokens) = divScalarByExpTruncate(redeemAmountIn, Exp({mantissa: vars.exchangeRateMantissa}));
2361             if (vars.mathErr != MathError.NO_ERROR) {
2362                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED, uint(vars.mathErr));
2363             }
2364 
2365             vars.redeemAmount = redeemAmountIn;
2366         }
2367 
2368         /*
2369          * We calculate the new total supply and redeemer balance, checking for underflow:
2370          *  totalSupplyNew = totalSupply - redeemTokens
2371          *  accountTokensNew = accountTokens[redeemer] - redeemTokens
2372          */
2373         (vars.mathErr, vars.totalSupplyNew) = subUInt(totalSupply, vars.redeemTokens);
2374         if (vars.mathErr != MathError.NO_ERROR) {
2375             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, uint(vars.mathErr));
2376         }
2377 
2378         (vars.mathErr, vars.accountTokensNew) = subUInt(accountTokens[redeemer], vars.redeemTokens);
2379         if (vars.mathErr != MathError.NO_ERROR) {
2380             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
2381         }
2382 
2383         /* Fail gracefully if protocol has insufficient cash */
2384         if (getCashPrior() < vars.redeemAmount) {
2385             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDEEM_TRANSFER_OUT_NOT_POSSIBLE);
2386         }
2387 
2388         /////////////////////////
2389         // EFFECTS & INTERACTIONS
2390         // (No safe failures beyond this point)
2391         doTransferOut(eFILAddress, redeemer, vars.redeemAmount);
2392 
2393         /* We write previously calculated values into storage */
2394         totalSupply = vars.totalSupplyNew;
2395         accountTokens[redeemer] = vars.accountTokensNew;
2396 
2397         /* We emit a Transfer event, and a Redeem event */
2398         emit Transfer(redeemer, address(this), vars.redeemTokens);
2399         emit Redeem(redeemer, vars.redeemAmount, vars.redeemTokens);
2400         return uint(Error.NO_ERROR);
2401     }
2402 
2403     /**
2404       * @notice Sender borrows assets from the protocol to their own address
2405       * @param borrowAmount The amount of the underlying asset to borrow
2406       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2407       */
2408     function borrow(uint borrowAmount) external nonReentrant returns (uint) {
2409         uint err = accrueInterest();
2410         if (err != uint(Error.NO_ERROR)) {
2411             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
2412             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
2413         }
2414         // Keep the flywheel moving
2415         accrueDFL();
2416 
2417         // borrowFresh emits borrow-specific logs on errors, so we don't need to
2418         return borrowFresh(msg.sender, borrowAmount);
2419     }
2420 
2421     struct BorrowLocalVars {
2422         MathError mathErr;
2423         uint actualBorrowAmount;
2424         uint accountBorrows;
2425         uint accountBorrowsNew;
2426         uint totalBorrowsNew;
2427     }
2428 
2429     /**
2430       * @notice Users borrow assets from the protocol to their own address
2431       * @param borrowAmount The amount of the underlying asset to borrow
2432       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2433       */
2434     function borrowFresh(address borrower, uint borrowAmount) internal returns (uint) {
2435         if (!borrowAllowed) {
2436             return fail(Error.REJECTION, FailureInfo.BORROW_REJECTION);
2437         }
2438 
2439         BorrowLocalVars memory vars;
2440 
2441         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
2442         if (vars.mathErr != MathError.NO_ERROR) {
2443             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
2444         }
2445 
2446         if (borrowAmount == uint(-1)) {
2447             vars.actualBorrowAmount = accountCollaterals[borrower] > vars.accountBorrows ? accountCollaterals[borrower] - vars.accountBorrows : 0;
2448         } else {
2449             vars.actualBorrowAmount = borrowAmount;
2450         }
2451 
2452         /* Fail gracefully if protocol has insufficient underlying cash */
2453         if (getCashPrior() < vars.actualBorrowAmount) {
2454             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.BORROW_CASH_NOT_AVAILABLE);
2455         }
2456 
2457         /*
2458          * We calculate the new borrower and total borrow balances, failing on overflow:
2459          *  accountBorrowsNew = accountBorrows + actualBorrowAmount
2460          *  totalBorrowsNew = totalBorrows + actualBorrowAmount
2461          */
2462         (vars.mathErr, vars.accountBorrowsNew) = addUInt(vars.accountBorrows, vars.actualBorrowAmount);
2463         if (vars.mathErr != MathError.NO_ERROR) {
2464             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
2465         }
2466 
2467         // Check collaterals
2468         if (accountCollaterals[borrower] < vars.accountBorrowsNew) {
2469             return fail(Error.INSUFFICIENT_COLLATERAL, FailureInfo.BORROW_INSUFFICIENT_COLLATERAL);
2470         }
2471 
2472         (vars.mathErr, vars.totalBorrowsNew) = addUInt(totalBorrows, vars.actualBorrowAmount);
2473         if (vars.mathErr != MathError.NO_ERROR) {
2474             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
2475         }
2476 
2477         /////////////////////////
2478         // EFFECTS & INTERACTIONS
2479         // (No safe failures beyond this point)
2480         doTransferOut(eFILAddress, borrower, vars.actualBorrowAmount);
2481 
2482         /* We write the previously calculated values into storage */
2483         accountBorrows[borrower].principal = vars.accountBorrowsNew;
2484         accountBorrows[borrower].interestIndex = borrowIndex;
2485         totalBorrows = vars.totalBorrowsNew;
2486 
2487         /* We emit a Borrow event */
2488         emit Borrow(borrower, vars.actualBorrowAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
2489         return uint(Error.NO_ERROR);
2490     }
2491 
2492     /**
2493      * @notice Sender repays their own borrow
2494      * @param repayAmount The amount to repay
2495      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2496      */
2497     function repayBorrow(uint repayAmount) external nonReentrant returns (uint) {
2498         uint err = accrueInterest();
2499         if (err != uint(Error.NO_ERROR)) {
2500             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
2501             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
2502         }
2503         // Keep the flywheel moving
2504         accrueDFL();
2505 
2506         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
2507         (err,) = repayBorrowFresh(msg.sender, msg.sender, repayAmount);
2508         return err;
2509     }
2510 
2511     /**
2512      * @notice Sender repays a borrow belonging to borrower
2513      * @param borrower the account with the debt being payed off
2514      * @param repayAmount The amount to repay
2515      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2516      */
2517     function repayBorrowBehalf(address borrower, uint repayAmount) external nonReentrant returns (uint) {
2518         uint err = accrueInterest();
2519         if (err != uint(Error.NO_ERROR)) {
2520             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
2521             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
2522         }
2523         // Keep the flywheel moving
2524         accrueDFL();
2525 
2526         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
2527         (err,) = repayBorrowFresh(msg.sender, borrower, repayAmount);
2528         return err;
2529     }
2530 
2531     struct RepayBorrowLocalVars {
2532         Error err;
2533         MathError mathErr;
2534         uint repayAmount;
2535         uint borrowerIndex;
2536         uint accountBorrows;
2537         uint accountBorrowsNew;
2538         uint totalBorrowsNew;
2539         uint actualRepayAmount;
2540     }
2541 
2542     /**
2543      * @notice Borrows are repaid by another user (possibly the borrower).
2544      * @param payer the account paying off the borrow
2545      * @param borrower the account with the debt being payed off
2546      * @param repayAmount the amount of undelrying tokens being returned
2547      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
2548      */
2549     function repayBorrowFresh(address payer, address borrower, uint repayAmount) internal returns (uint, uint) {
2550         RepayBorrowLocalVars memory vars;
2551 
2552         /* We remember the original borrowerIndex for verification purposes */
2553         vars.borrowerIndex = accountBorrows[borrower].interestIndex;
2554 
2555         /* We fetch the amount the borrower owes, with accumulated interest */
2556         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
2557         if (vars.mathErr != MathError.NO_ERROR) {
2558             return (failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr)), 0);
2559         }
2560 
2561         /* If repayAmount == -1, repayAmount = accountBorrows */
2562         if (repayAmount == uint(-1)) {
2563             vars.repayAmount = vars.accountBorrows;
2564         } else {
2565             vars.repayAmount = repayAmount;
2566         }
2567 
2568         /////////////////////////
2569         // EFFECTS & INTERACTIONS
2570         // (No safe failures beyond this point)
2571         vars.actualRepayAmount = doTransferIn(eFILAddress, payer, vars.repayAmount);
2572 
2573         /*
2574          * We calculate the new borrower and total borrow balances, failing on underflow:
2575          *  accountBorrowsNew = accountBorrows - actualRepayAmount
2576          *  totalBorrowsNew = totalBorrows - actualRepayAmount
2577          */
2578         (vars.mathErr, vars.accountBorrowsNew) = subUInt(vars.accountBorrows, vars.actualRepayAmount);
2579         require(vars.mathErr == MathError.NO_ERROR, "REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED");
2580 
2581         (vars.mathErr, vars.totalBorrowsNew) = subUInt(totalBorrows, vars.actualRepayAmount);
2582         require(vars.mathErr == MathError.NO_ERROR, "REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED");
2583 
2584         /* We write the previously calculated values into storage */
2585         accountBorrows[borrower].principal = vars.accountBorrowsNew;
2586         accountBorrows[borrower].interestIndex = borrowIndex;
2587         totalBorrows = vars.totalBorrowsNew;
2588 
2589         /* We emit a RepayBorrow event */
2590         emit RepayBorrow(payer, borrower, vars.actualRepayAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
2591         return (uint(Error.NO_ERROR), vars.actualRepayAmount);
2592     }
2593 
2594     /**
2595      * redeem collaterals
2596      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2597      * @param redeemAmount The number of collateral to redeem into underlying
2598      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2599      */
2600     function redeemCollateral(uint redeemAmount) external nonReentrant returns (uint) {
2601         uint err = accrueInterest();
2602         if (err != uint(Error.NO_ERROR)) {
2603             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
2604             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
2605         }
2606         // Keep the flywheel moving
2607         accrueDFL();
2608 
2609         // redeemCollateralFresh emits redeem-collaterals-specific logs on errors, so we don't need to
2610         return redeemCollateralFresh(msg.sender, redeemAmount);
2611     }
2612 
2613     struct RedeemCollateralLocalVars {
2614         Error err;
2615         MathError mathErr;
2616         uint redeemAmount;
2617         uint accountBorrows;
2618         uint accountCollateralsOld;
2619         uint accountCollateralsNew;
2620         uint totalCollateralsNew;
2621     }
2622 
2623     /**
2624      * redeem collaterals
2625      * @dev Assumes interest has already been accrued up to the current block
2626      * @param redeemer The address of the account which is redeeming
2627      * @param redeemAmount The number of collaterals to redeem into underlying
2628      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2629      */
2630     function redeemCollateralFresh(address redeemer, uint redeemAmount) internal returns (uint) {
2631         RedeemCollateralLocalVars memory vars;
2632 
2633         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(redeemer);
2634         if (vars.mathErr != MathError.NO_ERROR) {
2635             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_COLLATERAL_ACCUMULATED_BORROW_CALCULATION_FAILED, uint(vars.mathErr));
2636         }
2637 
2638         vars.accountCollateralsOld = accountCollaterals[redeemer];
2639         if (redeemAmount == uint(-1)) {
2640             vars.redeemAmount = vars.accountCollateralsOld >= vars.accountBorrows ? vars.accountCollateralsOld - vars.accountBorrows : 0;
2641         } else {
2642             vars.redeemAmount = redeemAmount;
2643         }
2644 
2645         (vars.mathErr, vars.accountCollateralsNew) = subUInt(accountCollaterals[redeemer], vars.redeemAmount);
2646         if (vars.mathErr != MathError.NO_ERROR) {
2647             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_COLLATERAL_NEW_ACCOUNT_COLLATERAL_CALCULATION_FAILED, uint(vars.mathErr));
2648         }
2649 
2650         // Check collateral
2651         if (vars.accountCollateralsNew < vars.accountBorrows) {
2652             return fail(Error.INSUFFICIENT_COLLATERAL, FailureInfo.REDEEM_COLLATERAL_INSUFFICIENT_COLLATERAL);
2653         }
2654 
2655         (vars.mathErr, vars.totalCollateralsNew) = subUInt(totalCollaterals, vars.redeemAmount);
2656         require(vars.mathErr == MathError.NO_ERROR, "REDEEM_COLLATERALS_NEW_TOTAL_COLLATERALS_CALCULATION_FAILED");
2657 
2658         /////////////////////////
2659         // EFFECTS & INTERACTIONS
2660         // (No safe failures beyond this point)
2661         doTransferOut(mFILAddress, redeemer, vars.redeemAmount);
2662 
2663         /* We write previously calculated values into storage */
2664         totalCollaterals = vars.totalCollateralsNew;
2665         accountCollaterals[redeemer] = vars.accountCollateralsNew;
2666 
2667         /* We emit a RedeemCollateral event */
2668         emit RedeemCollateral(redeemer, vars.redeemAmount);
2669         return uint(Error.NO_ERROR);
2670     }
2671 
2672     /**
2673      * liquidate borrow
2674      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2675      * @param borrower The borrower's address
2676      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2677      */
2678     function liquidateBorrow(address borrower) external nonReentrant returns (uint) {
2679         uint err = accrueInterest();
2680         if (err != uint(Error.NO_ERROR)) {
2681             return fail(Error(err), FailureInfo.ACCRUE_INTEREST_FAILED);
2682         }
2683         // Keep the flywheel moving
2684         accrueDFL();
2685 
2686         return liquidateBorrowFresh(msg.sender, borrower);
2687     }
2688 
2689     struct LiquidateBorrowLocalVars {
2690         Error err;
2691         MathError mathErr;
2692         uint accountBorrows;
2693         uint accountCollaterals;
2694         uint collateralRate;
2695         uint totalBorrowsNew;
2696     }
2697 
2698     /**
2699      * liquidate borrow
2700      * @dev Assumes interest has already been accrued up to the current block
2701      * @param liquidator The liquidator's address
2702      * @param borrower The borrower's address
2703      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2704      */
2705     function liquidateBorrowFresh(address liquidator, address borrower) internal returns (uint) {
2706         // make things simple
2707         if (accountCollaterals[liquidator] != 0 || accountTokens[liquidator] != 0) {
2708             return fail(Error.REJECTION, FailureInfo.LIQUIDATE_BORROW_REJECTION);
2709         }
2710 
2711         LiquidateBorrowLocalVars memory vars;
2712 
2713         (vars.mathErr, vars.collateralRate, vars.accountBorrows, vars.accountCollaterals) = collateralRateInternal(borrower);
2714         if (vars.mathErr != MathError.NO_ERROR) {
2715             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_BORROW_COLLATERAL_RATE_CALCULATION_FAILED, uint(vars.mathErr));
2716         }
2717 
2718         if (vars.collateralRate < liquidateFactorMantissa) {
2719             return fail(Error.REJECTION, FailureInfo.LIQUIDATE_BORROW_NOT_SATISFIED);
2720         }
2721 
2722         /////////////////////////
2723         // EFFECTS & INTERACTIONS
2724         // (No safe failures beyond this point)
2725         require(doTransferIn(eFILAddress, liquidator, vars.accountBorrows) == vars.accountBorrows, "LIQUIDATE_BORROW_TRANSFER_IN_FAILED");
2726 
2727         (vars.mathErr, vars.totalBorrowsNew) = subUInt(totalBorrows, vars.accountBorrows);
2728         require(vars.mathErr == MathError.NO_ERROR, "LIQUIDATE_BORROW_NEW_TOTAL_BORROWS_CALCULATION_FAILED");
2729 
2730         /* We write the previously calculated values into storage */
2731         accountBorrows[borrower].principal = 0;
2732         accountBorrows[borrower].interestIndex = borrowIndex;
2733         totalBorrows = vars.totalBorrowsNew;
2734 
2735         accountCollaterals[borrower] = 0;
2736         accountCollaterals[liquidator] = vars.accountCollaterals;
2737 
2738         /* We emit a RepayBorrow event */
2739         emit LiquidateBorrow(liquidator, borrower, vars.accountBorrows, vars.accountCollaterals);
2740         return uint(Error.NO_ERROR);
2741     }
2742 
2743     /*** DFL ***/
2744 
2745     // accrue DFL
2746     function accrueDFL() internal {
2747         uint startBlockNumber = dflAccrualBlockNumber;
2748         uint endBlockNumber = startBlockNumber;
2749         uint currentBlockNumber = getBlockNumber();
2750         while (endBlockNumber < currentBlockNumber) {
2751             if (currentSpeed < minSpeed) {
2752                 break;
2753             }
2754 
2755             startBlockNumber = endBlockNumber;
2756             if (currentBlockNumber < nextHalveBlockNumber) {
2757                 endBlockNumber = currentBlockNumber;
2758             } else {
2759                 endBlockNumber = nextHalveBlockNumber;
2760             }
2761 
2762             distributeAndUpdateSupplyIndex(startBlockNumber, endBlockNumber);
2763 
2764             if (endBlockNumber == nextHalveBlockNumber) {
2765                 nextHalveBlockNumber = nextHalveBlockNumber + halvePeriod;
2766                 currentSpeed = currentSpeed / 2;
2767             }
2768         }
2769         // update dflAccrualBlockNumber
2770         dflAccrualBlockNumber = currentBlockNumber;
2771     }
2772 
2773     // Accrue DFL for suppliers by updating the supply index
2774     function distributeAndUpdateSupplyIndex(uint startBlockNumber, uint endBlockNumber) internal {
2775         uint deltaBlocks = sub_(endBlockNumber, startBlockNumber);
2776         if (deltaBlocks > 0) {
2777             uint deltaDFLs = mul_(deltaBlocks, currentSpeed);
2778             dflToken.mint(address(this), deltaDFLs);
2779 
2780             uint uniswapPart = div_(mul_(uniswapPercentage, deltaDFLs), mantissaOne);
2781             uint minerLeaguePart = div_(mul_(minerLeaguePercentage, deltaDFLs), mantissaOne);
2782             uint operatorPart = div_(mul_(operatorPercentage, deltaDFLs), mantissaOne);
2783             uint technicalPart = div_(mul_(technicalPercentage, deltaDFLs), mantissaOne);
2784             uint supplyPart = sub_(sub_(sub_(sub_(deltaDFLs, uniswapPart), minerLeaguePart), operatorPart), technicalPart);
2785 
2786             // accrue, not transfer directly
2787             dflAccrued[uniswapAddress] = add_(dflAccrued[uniswapAddress], uniswapPart);
2788             dflAccrued[minerLeagueAddress] = add_(dflAccrued[minerLeagueAddress], minerLeaguePart);
2789             dflAccrued[operatorAddress] = add_(dflAccrued[operatorAddress], operatorPart);
2790             dflAccrued[technicalAddress] = add_(dflAccrued[technicalAddress], technicalPart);
2791 
2792             if (totalSupply > 0) {
2793                 Double memory ratio = fraction(supplyPart, totalSupply);
2794                 Double memory index = add_(Double({mantissa: dflSupplyIndex}), ratio);
2795                 dflSupplyIndex = index.mantissa;
2796             } else {
2797                 dflAccrued[undistributedAddress] = add_(dflAccrued[undistributedAddress], supplyPart);
2798             }
2799 
2800             emit AccrueDFL(uniswapPart, minerLeaguePart, operatorPart, technicalPart, supplyPart, dflSupplyIndex);
2801         }
2802     }
2803 
2804     // Calculate DFL accrued by a supplier and possibly transfer it to them
2805     function distributeSupplierDFL(address supplier, bool distributeAll) internal {
2806         /* Verify accrued block number equals current block number */
2807         require(dflAccrualBlockNumber == getBlockNumber(), "FRESHNESS_CHECK");
2808         uint supplierAccrued = accruedDFLStoredInternal(supplier);
2809 
2810         dflAccrued[supplier] = transferDFL(supplier, supplierAccrued, distributeAll ? 0 : dflClaimThreshold);
2811         dflSupplierIndex[supplier] = dflSupplyIndex;
2812         emit DistributedDFL(supplier, supplierAccrued - dflAccrued[supplier]);
2813     }
2814 
2815     // Transfer DFL to the user, if they are above the threshold
2816     function transferDFL(address user, uint userAccrued, uint threshold) internal returns (uint) {
2817         if (userAccrued >= threshold && userAccrued > 0) {
2818             uint dflRemaining = dflToken.balanceOf(address(this));
2819             if (userAccrued <= dflRemaining) {
2820                 dflToken.transfer(user, userAccrued);
2821                 return 0;
2822             }
2823         }
2824         return userAccrued;
2825     }
2826 
2827     function claimDFL() public nonReentrant {
2828         accrueDFL();
2829         distributeSupplierDFL(msg.sender, true);
2830     }
2831 
2832     // Claim all DFL accrued by the suppliers
2833     function claimDFL(address[] memory holders) public nonReentrant {
2834         accrueDFL();
2835         for (uint i = 0; i < holders.length; i++) {
2836             distributeSupplierDFL(holders[i], true);
2837         }
2838     }
2839 
2840     // Reduce reserves, only by staking contract
2841     function claimReserves() public nonReentrant {
2842         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
2843 
2844         uint cash = getCashPrior();
2845         uint actualAmount = cash > totalReserves ? totalReserves : cash;
2846 
2847         doTransferOut(eFILAddress, reservesOwner, actualAmount);
2848         totalReserves = sub_(totalReserves, actualAmount);
2849 
2850         emit ReservesReduced(reservesOwner, actualAmount);
2851     }
2852 
2853     /*** Admin Functions ***/
2854 
2855     /**
2856       * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
2857       * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
2858       * @param newPendingAdmin New pending admin.
2859       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2860       */
2861     function _setPendingAdmin(address newPendingAdmin) external returns (uint) {
2862         // Check caller = admin
2863         if (msg.sender != admin) {
2864             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
2865         }
2866 
2867         // Save current value, if any, for inclusion in log
2868         address oldPendingAdmin = pendingAdmin;
2869 
2870         // Store pendingAdmin with value newPendingAdmin
2871         pendingAdmin = newPendingAdmin;
2872 
2873         // Emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin)
2874         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
2875 
2876         return uint(Error.NO_ERROR);
2877     }
2878 
2879     /**
2880       * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
2881       * @dev Admin function for pending admin to accept role and update admin
2882       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2883       */
2884     function _acceptAdmin() external returns (uint) {
2885         // Check caller is pendingAdmin and pendingAdmin ≠ address(0)
2886         if (msg.sender != pendingAdmin || msg.sender == address(0)) {
2887             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
2888         }
2889 
2890         // Save current values for inclusion in log
2891         address oldAdmin = admin;
2892         address oldPendingAdmin = pendingAdmin;
2893 
2894         // Store admin with value pendingAdmin
2895         admin = pendingAdmin;
2896 
2897         // Clear the pending value
2898         pendingAdmin = address(0);
2899 
2900         emit NewAdmin(oldAdmin, admin);
2901         emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
2902 
2903         return uint(Error.NO_ERROR);
2904     }
2905 
2906     /**
2907       * @dev Change mintAllowed
2908       * @param mintAllowed_ New value.
2909       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2910       */
2911     function _setMintAllowed(bool mintAllowed_) external returns (uint) {
2912         // Check caller = admin
2913         if (msg.sender != admin) {
2914             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
2915         }
2916 
2917         if (mintAllowed != mintAllowed_) {
2918             mintAllowed = mintAllowed_;
2919             emit MintAllowed(mintAllowed_);
2920         }
2921 
2922         return uint(Error.NO_ERROR);
2923     }
2924 
2925     /**
2926       * @dev Change borrowAllowed
2927       * @param borrowAllowed_ New value.
2928       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2929       */
2930     function _setBorrowAllowed(bool borrowAllowed_) external returns (uint) {
2931         // Check caller = admin
2932         if (msg.sender != admin) {
2933             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
2934         }
2935 
2936         if (borrowAllowed != borrowAllowed_) {
2937             borrowAllowed = borrowAllowed_;
2938             emit BorrowAllowed(borrowAllowed_);
2939         }
2940 
2941         return uint(Error.NO_ERROR);
2942     }
2943 
2944     /**
2945       * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
2946       * @dev Admin function to accrue interest and set a new reserve factor
2947       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2948       */
2949     function _setReserveFactor(uint newReserveFactorMantissa) external nonReentrant returns (uint) {
2950         uint error = accrueInterest();
2951         if (error != uint(Error.NO_ERROR)) {
2952             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reserve factor change failed.
2953             return fail(Error(error), FailureInfo.ACCRUE_INTEREST_FAILED);
2954         }
2955         // _setReserveFactorFresh emits reserve-factor-specific logs on errors, so we don't need to.
2956         return _setReserveFactorFresh(newReserveFactorMantissa);
2957     }
2958 
2959     /**
2960       * @notice Sets a new reserve factor for the protocol (*requires fresh interest accrual)
2961       * @dev Admin function to set a new reserve factor
2962       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2963       */
2964     function _setReserveFactorFresh(uint newReserveFactorMantissa) internal returns (uint) {
2965         // Check caller is admin
2966         if (msg.sender != admin) {
2967             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
2968         }
2969 
2970         // Check newReserveFactor ≤ maxReserveFactor
2971         if (newReserveFactorMantissa > reserveFactorMaxMantissa) {
2972             return fail(Error.BAD_INPUT, FailureInfo.SET_RESERVE_FACTOR_BOUNDS_CHECK);
2973         }
2974 
2975         uint oldReserveFactorMantissa = reserveFactorMantissa;
2976         reserveFactorMantissa = newReserveFactorMantissa;
2977 
2978         emit NewReserveFactor(oldReserveFactorMantissa, newReserveFactorMantissa);
2979 
2980         return uint(Error.NO_ERROR);
2981     }
2982 
2983     /**
2984       * @notice accrues interest and sets a new liquidate factor for the protocol using _setLiquidateFactorFresh
2985       * @dev Admin function to accrue interest and set a new liquidate factor
2986       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2987       */
2988     function _setLiquidateFactor(uint newLiquidateFactorMantissa) external nonReentrant returns (uint) {
2989         uint error = accrueInterest();
2990         if (error != uint(Error.NO_ERROR)) {
2991             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted liquidate factor change failed.
2992             return fail(Error(error), FailureInfo.ACCRUE_INTEREST_FAILED);
2993         }
2994         return _setLiquidateFactorFresh(newLiquidateFactorMantissa);
2995     }
2996 
2997     function _setLiquidateFactorFresh(uint newLiquidateFactorMantissa) internal returns (uint) {
2998         // Check caller is admin
2999         if (msg.sender != admin) {
3000             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
3001         }
3002 
3003         if (newLiquidateFactorMantissa < liquidateFactorMinMantissa) {
3004             return fail(Error.BAD_INPUT, FailureInfo.SET_LIQUIDATE_FACTOR_BOUNDS_CHECK);
3005         }
3006 
3007         uint oldLiquidateFactorMantissa = liquidateFactorMantissa;
3008         liquidateFactorMantissa = newLiquidateFactorMantissa;
3009 
3010         emit NewLiquidateFactor(oldLiquidateFactorMantissa, newLiquidateFactorMantissa);
3011 
3012         return uint(Error.NO_ERROR);
3013     }
3014 
3015     /**
3016      * @notice accrues interest and updates the interest rate model using _setInterestRateModelFresh
3017      * @dev Admin function to accrue interest and update the interest rate model
3018      * @param newInterestRateModel the new interest rate model to use
3019      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
3020      */
3021     function _setInterestRateModel(InterestRateModel newInterestRateModel) public nonReentrant returns (uint) {
3022         uint error = accrueInterest();
3023         if (error != uint(Error.NO_ERROR)) {
3024             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted change of interest rate model failed
3025             return fail(Error(error), FailureInfo.ACCRUE_INTEREST_FAILED);
3026         }
3027         // _setInterestRateModelFresh emits interest-rate-model-update-specific logs on errors, so we don't need to.
3028         return _setInterestRateModelFresh(newInterestRateModel);
3029     }
3030 
3031     /**
3032      * @notice updates the interest rate model (*requires fresh interest accrual)
3033      * @dev Admin function to update the interest rate model
3034      * @param newInterestRateModel the new interest rate model to use
3035      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
3036      */
3037     function _setInterestRateModelFresh(InterestRateModel newInterestRateModel) internal returns (uint) {
3038         // Used to store old model for use in the event that is emitted on success
3039         InterestRateModel oldInterestRateModel;
3040 
3041         // Check caller is admin
3042         if (msg.sender != admin) {
3043             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
3044         }
3045 
3046         // Track the current interest rate model
3047         oldInterestRateModel = interestRateModel;
3048 
3049         // Ensure invoke newInterestRateModel.isInterestRateModel() returns true
3050         require(newInterestRateModel.isInterestRateModel(), "marker method returned false");
3051 
3052         // Set the interest rate model to newInterestRateModel
3053         interestRateModel = newInterestRateModel;
3054 
3055         // Emit NewInterestRateModel(oldInterestRateModel, newInterestRateModel)
3056         emit NewInterestRateModel(oldInterestRateModel, newInterestRateModel);
3057 
3058         return uint(Error.NO_ERROR);
3059     }
3060 
3061     /**
3062       * @dev Change reservesOwner
3063       * @param newReservesOwner New value.
3064       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
3065       */
3066     function _setReservesOwner(address newReservesOwner) public returns (uint) {
3067         claimReserves();
3068         return _setReservesOwnerFresh(newReservesOwner);
3069     }
3070 
3071     function _setReservesOwnerFresh(address newReservesOwner) internal returns (uint) {
3072         // Check caller = admin
3073         if (msg.sender != admin) {
3074             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
3075         }
3076 
3077         address oldReservesOwner = reservesOwner;
3078         reservesOwner = newReservesOwner;
3079 
3080         emit ReservesOwnerChanged(oldReservesOwner, newReservesOwner);
3081         return uint(Error.NO_ERROR);
3082     }
3083 
3084     /**
3085       * @dev Change minerLeagueAddress
3086       * @param newMinerLeagueAddress New value.
3087       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
3088       */
3089     function _setMinerLeagueAddress(address newMinerLeagueAddress) external nonReentrant returns (uint) {
3090         // accrue
3091         accrueDFL();
3092         return _setMinerLeagueAddressFresh(newMinerLeagueAddress);
3093     }
3094 
3095     function _setMinerLeagueAddressFresh(address newMinerLeagueAddress) internal returns (uint) {
3096         if (msg.sender != minerLeagueAddress) {
3097             return fail(Error.UNAUTHORIZED, FailureInfo.PARTICIPANT_CHECK);
3098         }
3099 
3100         // transfers accrued
3101         if (dflAccrued[minerLeagueAddress] != 0) {
3102             doTransferOut(address(dflToken), minerLeagueAddress, dflAccrued[minerLeagueAddress]);
3103             delete dflAccrued[minerLeagueAddress];
3104         }
3105 
3106         address oldMinerLeagueAddress = minerLeagueAddress;
3107         minerLeagueAddress = newMinerLeagueAddress;
3108 
3109         emit MinerLeagueAddressChanged(oldMinerLeagueAddress, newMinerLeagueAddress);
3110         return uint(Error.NO_ERROR);
3111     }
3112 
3113     /**
3114       * @dev Change operatorAddress
3115       * @param newOperatorAddress New value.
3116       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
3117       */
3118     function _setOperatorAddress(address newOperatorAddress) external nonReentrant returns (uint) {
3119         // accrue
3120         accrueDFL();
3121         return _setOperatorAddressFresh(newOperatorAddress);
3122     }
3123 
3124     function _setOperatorAddressFresh(address newOperatorAddress) internal returns (uint) {
3125         if (msg.sender != operatorAddress) {
3126             return fail(Error.UNAUTHORIZED, FailureInfo.PARTICIPANT_CHECK);
3127         }
3128 
3129         // transfers accrued
3130         if (dflAccrued[operatorAddress] != 0) {
3131             doTransferOut(address(dflToken), operatorAddress, dflAccrued[operatorAddress]);
3132             delete dflAccrued[operatorAddress];
3133         }
3134 
3135         address oldOperatorAddress = operatorAddress;
3136         operatorAddress = newOperatorAddress;
3137 
3138         emit OperatorAddressChanged(oldOperatorAddress, newOperatorAddress);
3139         return uint(Error.NO_ERROR);
3140     }
3141 
3142     /**
3143       * @dev Change technicalAddress
3144       * @param newTechnicalAddress New value.
3145       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
3146       */
3147     function _setTechnicalAddress(address newTechnicalAddress) external nonReentrant returns (uint) {
3148         // accrue
3149         accrueDFL();
3150         return _setTechnicalAddressFresh(newTechnicalAddress);
3151     }
3152 
3153     function _setTechnicalAddressFresh(address newTechnicalAddress) internal returns (uint) {
3154         if (msg.sender != technicalAddress) {
3155             return fail(Error.UNAUTHORIZED, FailureInfo.PARTICIPANT_CHECK);
3156         }
3157 
3158         // transfers accrued
3159         if (dflAccrued[technicalAddress] != 0) {
3160             doTransferOut(address(dflToken), technicalAddress, dflAccrued[technicalAddress]);
3161             delete dflAccrued[technicalAddress];
3162         }
3163 
3164         address oldTechnicalAddress = technicalAddress;
3165         technicalAddress = newTechnicalAddress;
3166 
3167         emit TechnicalAddressChanged(oldTechnicalAddress, newTechnicalAddress);
3168         return uint(Error.NO_ERROR);
3169     }
3170 
3171     /**
3172       * @dev Change uniswapAddress
3173       * @param newUniswapAddress New value.
3174       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
3175       */
3176     function _setUniswapAddress(address newUniswapAddress) external nonReentrant returns (uint) {
3177         // accrue
3178         accrueDFL();
3179         return _setUniswapAddressFresh(newUniswapAddress);
3180     }
3181 
3182     function _setUniswapAddressFresh(address newUniswapAddress) internal returns (uint) {
3183         // Check caller = admin
3184         if (msg.sender != admin) {
3185             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
3186         }
3187 
3188         // transfers accrued
3189         if (dflAccrued[uniswapAddress] != 0) {
3190             doTransferOut(address(dflToken), uniswapAddress, dflAccrued[uniswapAddress]);
3191             delete dflAccrued[uniswapAddress];
3192         }
3193 
3194         address oldUniswapAddress = uniswapAddress;
3195         uniswapAddress = newUniswapAddress;
3196 
3197         emit UniswapAddressChanged(oldUniswapAddress, newUniswapAddress);
3198         return uint(Error.NO_ERROR);
3199     }
3200 
3201     /**
3202       * @dev Change undistributedAddress
3203       * @param newUndistributedAddress New value.
3204       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
3205       */
3206     function _setUndistributedAddress(address newUndistributedAddress) external nonReentrant returns (uint) {
3207         // accrue
3208         accrueDFL();
3209         return _setUndistributedAddressFresh(newUndistributedAddress);
3210     }
3211 
3212     function _setUndistributedAddressFresh(address newUndistributedAddress) internal returns (uint) {
3213         // Check caller = admin
3214         if (msg.sender != admin) {
3215             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
3216         }
3217 
3218         // transfers accrued to old address
3219         if (dflAccrued[undistributedAddress] != 0) {
3220             doTransferOut(address(dflToken), undistributedAddress, dflAccrued[undistributedAddress]);
3221             delete dflAccrued[undistributedAddress];
3222         }
3223 
3224         address oldUndistributedAddress = undistributedAddress;
3225         undistributedAddress = newUndistributedAddress;
3226 
3227         emit UndistributedAddressChanged(oldUndistributedAddress, newUndistributedAddress);
3228         return uint(Error.NO_ERROR);
3229     }
3230 
3231     /**
3232       * @dev Change DFL percentages
3233       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
3234       */
3235     function _setDFLPercentages(uint uniswapPercentage_,
3236                                 uint minerLeaguePercentage_,
3237                                 uint operatorPercentage_) external nonReentrant returns (uint) {
3238         accrueDFL();
3239         return _setDFLPercentagesFresh(uniswapPercentage_, minerLeaguePercentage_, operatorPercentage_);
3240     }
3241 
3242     function _setDFLPercentagesFresh(uint uniswapPercentage_,
3243                                      uint minerLeaguePercentage_,
3244                                      uint operatorPercentage_) internal returns (uint) {
3245         // Check caller = admin
3246         if (msg.sender != admin) {
3247             return fail(Error.UNAUTHORIZED, FailureInfo.ADMIN_CHECK);
3248         }
3249 
3250         uint sumPercentage = add_(add_(add_(uniswapPercentage_, minerLeaguePercentage_), operatorPercentage_), technicalPercentage);
3251         require(sumPercentage <= mantissaOne, "PERCENTAGE_EXCEEDS");
3252 
3253         uniswapPercentage = uniswapPercentage_;
3254         minerLeaguePercentage = minerLeaguePercentage_;
3255         operatorPercentage = operatorPercentage_;
3256 
3257         emit PercentagesChanged(uniswapPercentage_, minerLeaguePercentage_, operatorPercentage_);
3258         return uint(Error.NO_ERROR);
3259     }
3260 
3261     /*** Safe Token ***/
3262 
3263     /**
3264      * @notice Gets balance of this contract in terms of the underlying
3265      * @dev This excludes the value of the current message, if any
3266      * @return The quantity of underlying tokens owned by this contract
3267      */
3268     function getCashPrior() internal view returns (uint) {
3269         EIP20Interface token = EIP20Interface(eFILAddress);
3270         return token.balanceOf(address(this));
3271     }
3272 
3273     /**
3274      * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and reverts in that case.
3275      *      This will revert due to insufficient balance or insufficient allowance.
3276      *      This function returns the actual amount received,
3277      *      which may be less than `amount` if there is a fee attached to the transfer.
3278      *
3279      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
3280      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
3281      */
3282     function doTransferIn(address underlying, address from, uint amount) internal returns (uint) {
3283         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
3284         uint balanceBefore = EIP20Interface(underlying).balanceOf(address(this));
3285         token.transferFrom(from, address(this), amount);
3286 
3287         bool success;
3288         assembly {
3289             switch returndatasize()
3290                 case 0 {                       // This is a non-standard ERC-20
3291                     success := not(0)          // set success to true
3292                 }
3293                 case 32 {                      // This is a compliant ERC-20
3294                     returndatacopy(0, 0, 32)
3295                     success := mload(0)        // Set `success = returndata` of external call
3296                 }
3297                 default {                      // This is an excessively non-compliant ERC-20, revert.
3298                     revert(0, 0)
3299                 }
3300         }
3301         require(success, "TOKEN_TRANSFER_IN_FAILED");
3302 
3303         // Calculate the amount that was *actually* transferred
3304         uint balanceAfter = EIP20Interface(underlying).balanceOf(address(this));
3305         require(balanceAfter >= balanceBefore, "TOKEN_TRANSFER_IN_OVERFLOW");
3306         return balanceAfter - balanceBefore;   // underflow already checked above, just subtract
3307     }
3308 
3309     /**
3310      * @dev Similar to EIP20 transfer, except it handles a False success from `transfer` and returns an explanatory
3311      *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
3312      *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
3313      *      it is >= amount, this should not revert in normal conditions.
3314      *
3315      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
3316      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
3317      */
3318     function doTransferOut(address underlying, address to, uint amount) internal {
3319         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
3320         token.transfer(to, amount);
3321 
3322         bool success;
3323         assembly {
3324             switch returndatasize()
3325                 case 0 {                      // This is a non-standard ERC-20
3326                     success := not(0)          // set success to true
3327                 }
3328                 case 32 {                     // This is a complaint ERC-20
3329                     returndatacopy(0, 0, 32)
3330                     success := mload(0)        // Set `success = returndata` of external call
3331                 }
3332                 default {                     // This is an excessively non-compliant ERC-20, revert.
3333                     revert(0, 0)
3334                 }
3335         }
3336         require(success, "TOKEN_TRANSFER_OUT_FAILED");
3337     }
3338 }
3339 
3340 // File: contracts\StakingDFL.sol
3341 
3342 pragma solidity ^0.5.16;
3343 
3344 
3345 
3346 
3347 
3348 
3349 
3350 contract StakingDFL is ReentrancyGuard, Exponential {
3351     using SafeMath for uint;
3352 
3353     /**
3354      * @notice Address of DeFIL contract
3355      */
3356     address public deFILAddress;
3357     /**
3358      * @notice Address of DFL
3359      */
3360     address public dflAddress;
3361     /**
3362      * @notice Address of eFIL
3363      */
3364     address public eFILAddress;
3365     /**
3366      * @notice Administrator for this contract
3367      */
3368     address public admin;
3369     /**
3370      * @notice Pending administrator for this contract
3371      */
3372     address public pendingAdmin;
3373 
3374     // Minimum bonus amount per share
3375     uint public minBonusAmount;
3376 
3377     // Reserved part that stands for already shared bonus.
3378     uint public sharedBonusAmount;
3379 
3380     // Total number of deposits.
3381     uint public totalDeposits;
3382 
3383     // Mapping of account to outstanding deposit balances
3384     mapping (address => uint) public accountDeposits;
3385 
3386     // The initial accrual index
3387     uint public constant initialAccruedIndex = 1e36;
3388 
3389     // The last accrued index
3390     uint public accruedIndex;
3391 
3392     // The index for each account as of the last time they accrued
3393     mapping(address => uint) public accountAccruedIndex;
3394 
3395     /*** Events ***/
3396     // Event emitted when new Staking tokens is deposited
3397     event Deposit(address account, uint amount);
3398 
3399     // Event emitted when new Staking tokens is withdrawed
3400     event Withdraw(address account, uint amount);
3401 
3402     // Emitted when bonus is accrued
3403     event Bonus(uint amount, uint accruedIndex);
3404 
3405     // Emitted when bonus is distributed to a participant
3406     event Distributed(address account, uint amount);
3407 
3408     // Event emitted when pendingAdmin is changed
3409     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
3410 
3411     // Event emitted when pendingAdmin is accepted, which means admin is updated
3412     event NewAdmin(address oldAdmin, address newAdmin);
3413 
3414     constructor(address dflAddress_,
3415                 address eFILAddress_,
3416                 uint minBonusAmount_) public {
3417         // set admin
3418         admin = msg.sender;
3419 
3420         dflAddress = dflAddress_;
3421         eFILAddress = eFILAddress_;
3422         minBonusAmount = minBonusAmount_;
3423 
3424         // init accrued index
3425         accruedIndex = initialAccruedIndex;
3426     }
3427 
3428     function accrueBonus() public {
3429         DeFIL deFIL = DeFIL(deFILAddress);
3430         deFIL.claimReserves();
3431 
3432         if (totalDeposits == 0) {
3433             return;
3434         }
3435 
3436         EIP20Interface bonusToken = EIP20Interface(eFILAddress);
3437         uint thisBalance = bonusToken.balanceOf(address(this));
3438         uint avaiableBalance = thisBalance.sub(sharedBonusAmount);
3439         if (avaiableBalance < minBonusAmount) {
3440             return;
3441         }
3442 
3443         Double memory ratio = fraction(avaiableBalance, totalDeposits);
3444         Double memory doubleAccruedIndex = add_(Double({mantissa: accruedIndex}), ratio);
3445 
3446         // update accruedIndex
3447         accruedIndex = doubleAccruedIndex.mantissa;
3448         sharedBonusAmount = sharedBonusAmount.add(avaiableBalance);
3449 
3450         emit Bonus(avaiableBalance, doubleAccruedIndex.mantissa);
3451     }
3452 
3453     // Accrue bonus and return the accrued bonus of account
3454     function accruedBonusCurrent() external nonReentrant returns(uint) {
3455         accrueBonus();
3456         return accruedBonusStoredInternal(msg.sender);
3457     }
3458 
3459     // Return the accrued bonus of account based on stored data
3460     function accruedBonusStored() public view returns(uint) {
3461         return accruedBonusStoredInternal(msg.sender);
3462     }
3463 
3464     // Return the accrued bonus of account based on stored data
3465     function accruedBonusStoredInternal(address account) public view returns(uint) {
3466         Double memory doubleAccruedIndex = Double({mantissa: accruedIndex});
3467         Double memory doubleAccountIndex = Double({mantissa: accountAccruedIndex[account]});
3468         if (doubleAccountIndex.mantissa == 0 && doubleAccruedIndex.mantissa > 0) {
3469             doubleAccountIndex.mantissa = initialAccruedIndex;
3470         }
3471 
3472         Double memory deltaIndex = sub_(doubleAccruedIndex, doubleAccountIndex);
3473         uint accountDelta = mul_(accountDeposits[account], deltaIndex);
3474         return accountDelta;
3475     }
3476 
3477     function claim(address[] memory accounts) public nonReentrant {
3478         accrueBonus();
3479         for (uint i = 0; i < accounts.length; i++) {
3480             distributeBonus(accounts[i]);
3481         }
3482     }
3483 
3484     function distributeBonus(address account) internal {
3485         uint accountDelta = accruedBonusStoredInternal(account);
3486         // transfer bonus token to account
3487         doTransferOut(eFILAddress, account, accountDelta);
3488 
3489         accountAccruedIndex[account] = accruedIndex;
3490         sharedBonusAmount = sharedBonusAmount.sub(accountDelta);
3491 
3492         emit Distributed(account, accountDelta);
3493     }
3494 
3495     // Deposit Staking tokens
3496     function deposit(uint amount) external nonReentrant {
3497         address account = msg.sender;
3498         // accrue & distribute
3499         accrueBonus();
3500         distributeBonus(account);
3501 
3502         // transfer staking token in
3503         uint actualAmount = doTransferIn(dflAddress, account, amount);
3504 
3505         // increase total deposits
3506         totalDeposits = totalDeposits.add(actualAmount);
3507         accountDeposits[account] = accountDeposits[account].add(actualAmount);
3508 
3509         emit Deposit(account, actualAmount);
3510     }
3511 
3512     // Withdraw staking tokens
3513     function withdraw(uint amount) external nonReentrant {
3514         address account = msg.sender;
3515         require(accountDeposits[account] >= amount, "withdraw: insufficient value");
3516 
3517         // accrue & distribute
3518         accrueBonus();
3519         distributeBonus(account);
3520 
3521         // transfer staking tokens back to account
3522         doTransferOut(dflAddress, account, amount);
3523 
3524         // decrease total deposits
3525         totalDeposits = totalDeposits.sub(amount);
3526         accountDeposits[account] = accountDeposits[account].sub(amount);
3527 
3528         emit Withdraw(account, amount);
3529     }
3530 
3531     /*** Admin Functions ***/
3532 
3533     /**
3534       * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
3535       * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
3536       * @param newPendingAdmin New pending admin.
3537       */
3538     function _setPendingAdmin(address newPendingAdmin) external {
3539         require(msg.sender == admin, "Not admin");
3540         require(newPendingAdmin != address(0), "Bad pending admin");
3541 
3542         // Save current value, if any, for inclusion in log
3543         address oldPendingAdmin = pendingAdmin;
3544 
3545         // Store pendingAdmin with value newPendingAdmin
3546         pendingAdmin = newPendingAdmin;
3547 
3548         // Emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin)
3549         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
3550     }
3551 
3552     /**
3553       * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
3554       * @dev Admin function for pending admin to accept role and update admin
3555       */
3556     function _acceptAdmin() external {
3557         // Check caller is pendingAdmin
3558         require(msg.sender == pendingAdmin && msg.sender != address(0), "Not pending admin");
3559 
3560         // Save current values for inclusion in log
3561         address oldAdmin = admin;
3562         address oldPendingAdmin = pendingAdmin;
3563 
3564         // Store admin with value pendingAdmin
3565         admin = pendingAdmin;
3566 
3567         // Clear the pending value
3568         pendingAdmin = address(0);
3569 
3570         emit NewAdmin(oldAdmin, admin);
3571         emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
3572     }
3573 
3574     /**
3575       * @dev set DeFIL address
3576       * @param deFILAddress_ New value.
3577       */
3578     function _setDeFILAddress(address deFILAddress_) external {
3579         require(deFILAddress == address(0), "Can noly set once");
3580         require(msg.sender == admin, "Not admin");
3581         deFILAddress = deFILAddress_;
3582     }
3583 
3584     /**
3585       * @dev Change minBonusAmount
3586       * @param minBonusAmount_ New value.
3587       */
3588     function _setMinBonusAmount(uint minBonusAmount_) external {
3589         require(msg.sender == admin, "Not admin");
3590         accrueBonus();
3591         minBonusAmount = minBonusAmount_;
3592     }
3593 
3594     /*** Safe Token ***/
3595 
3596     /**
3597      * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and reverts in that case.
3598      *      This will revert due to insufficient balance or insufficient allowance.
3599      *      This function returns the actual amount received,
3600      *      which may be less than `amount` if there is a fee attached to the transfer.
3601      *
3602      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
3603      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
3604      */
3605     function doTransferIn(address underlying, address from, uint amount) internal returns (uint) {
3606         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
3607         uint balanceBefore = EIP20Interface(underlying).balanceOf(address(this));
3608         token.transferFrom(from, address(this), amount);
3609 
3610         bool success;
3611         assembly {
3612             switch returndatasize()
3613                 case 0 {                       // This is a non-standard ERC-20
3614                     success := not(0)          // set success to true
3615                 }
3616                 case 32 {                      // This is a compliant ERC-20
3617                     returndatacopy(0, 0, 32)
3618                     success := mload(0)        // Set `success = returndata` of external call
3619                 }
3620                 default {                      // This is an excessively non-compliant ERC-20, revert.
3621                     revert(0, 0)
3622                 }
3623         }
3624         require(success, "TOKEN_TRANSFER_IN_FAILED");
3625 
3626         // Calculate the amount that was *actually* transferred
3627         uint balanceAfter = EIP20Interface(underlying).balanceOf(address(this));
3628         require(balanceAfter >= balanceBefore, "TOKEN_TRANSFER_IN_OVERFLOW");
3629         return balanceAfter - balanceBefore;   // underflow already checked above, just subtract
3630     }
3631 
3632     /**
3633      * @dev Similar to EIP20 transfer, except it handles a False success from `transfer` and returns an explanatory
3634      *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
3635      *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
3636      *      it is >= amount, this should not revert in normal conditions.
3637      *
3638      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
3639      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
3640      */
3641     function doTransferOut(address underlying, address to, uint amount) internal {
3642         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
3643         token.transfer(to, amount);
3644 
3645         bool success;
3646         assembly {
3647             switch returndatasize()
3648                 case 0 {                      // This is a non-standard ERC-20
3649                     success := not(0)          // set success to true
3650                 }
3651                 case 32 {                     // This is a complaint ERC-20
3652                     returndatacopy(0, 0, 32)
3653                     success := mload(0)        // Set `success = returndata` of external call
3654                 }
3655                 default {                     // This is an excessively non-compliant ERC-20, revert.
3656                     revert(0, 0)
3657                 }
3658         }
3659         require(success, "TOKEN_TRANSFER_OUT_FAILED");
3660     }
3661 }