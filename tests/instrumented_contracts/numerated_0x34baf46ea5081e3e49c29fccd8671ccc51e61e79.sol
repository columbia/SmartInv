1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 contract ErrorReporter {
5     /**
6      * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
7      * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
8      */
9     event Failure(uint256 error, uint256 info, uint256 detail);
10 
11     enum Error {
12         NO_ERROR,
13         OPAQUE_ERROR, // To be used when reporting errors from upgradeable contracts; the opaque code should be given as `detail` in the `Failure` event
14         UNAUTHORIZED,
15         INTEGER_OVERFLOW,
16         INTEGER_UNDERFLOW,
17         DIVISION_BY_ZERO,
18         BAD_INPUT,
19         TOKEN_INSUFFICIENT_ALLOWANCE,
20         TOKEN_INSUFFICIENT_BALANCE,
21         TOKEN_TRANSFER_FAILED,
22         MARKET_NOT_SUPPORTED,
23         SUPPLY_RATE_CALCULATION_FAILED,
24         BORROW_RATE_CALCULATION_FAILED,
25         TOKEN_INSUFFICIENT_CASH,
26         TOKEN_TRANSFER_OUT_FAILED,
27         INSUFFICIENT_LIQUIDITY,
28         INSUFFICIENT_BALANCE,
29         INVALID_COLLATERAL_RATIO,
30         MISSING_ASSET_PRICE,
31         EQUITY_INSUFFICIENT_BALANCE,
32         INVALID_CLOSE_AMOUNT_REQUESTED,
33         ASSET_NOT_PRICED,
34         INVALID_LIQUIDATION_DISCOUNT,
35         INVALID_COMBINED_RISK_PARAMETERS
36     }
37 
38     /**
39      * Note: FailureInfo (but not Error) is kept in alphabetical order
40      *       This is because FailureInfo grows significantly faster, and
41      *       the order of Error has some meaning, while the order of FailureInfo
42      *       is entirely arbitrary.
43      */
44     enum FailureInfo {
45         BORROW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED,
46         BORROW_ACCOUNT_SHORTFALL_PRESENT,
47         BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
48         BORROW_AMOUNT_LIQUIDITY_SHORTFALL,
49         BORROW_AMOUNT_VALUE_CALCULATION_FAILED,
50         BORROW_MARKET_NOT_SUPPORTED,
51         BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED,
52         BORROW_NEW_BORROW_RATE_CALCULATION_FAILED,
53         BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
54         BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
55         BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
56         BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED,
57         BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED,
58         BORROW_ORIGINATION_FEE_CALCULATION_FAILED,
59         BORROW_TRANSFER_OUT_FAILED,
60         EQUITY_WITHDRAWAL_AMOUNT_VALIDATION,
61         EQUITY_WITHDRAWAL_CALCULATE_EQUITY,
62         EQUITY_WITHDRAWAL_MODEL_OWNER_CHECK,
63         EQUITY_WITHDRAWAL_TRANSFER_OUT_FAILED,
64         LIQUIDATE_ACCUMULATED_BORROW_BALANCE_CALCULATION_FAILED,
65         LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET,
66         LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET,
67         LIQUIDATE_AMOUNT_SEIZE_CALCULATION_FAILED,
68         LIQUIDATE_BORROW_DENOMINATED_COLLATERAL_CALCULATION_FAILED,
69         LIQUIDATE_CLOSE_AMOUNT_TOO_HIGH,
70         LIQUIDATE_DISCOUNTED_REPAY_TO_EVEN_AMOUNT_CALCULATION_FAILED,
71         LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_BORROWED_ASSET,
72         LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET,
73         LIQUIDATE_NEW_BORROW_RATE_CALCULATION_FAILED_BORROWED_ASSET,
74         LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_BORROWED_ASSET,
75         LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET,
76         LIQUIDATE_NEW_SUPPLY_RATE_CALCULATION_FAILED_BORROWED_ASSET,
77         LIQUIDATE_NEW_TOTAL_BORROW_CALCULATION_FAILED_BORROWED_ASSET,
78         LIQUIDATE_NEW_TOTAL_CASH_CALCULATION_FAILED_BORROWED_ASSET,
79         LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET,
80         LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET,
81         LIQUIDATE_TRANSFER_IN_FAILED,
82         LIQUIDATE_TRANSFER_IN_NOT_POSSIBLE,
83         REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
84         REPAY_BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED,
85         REPAY_BORROW_NEW_BORROW_RATE_CALCULATION_FAILED,
86         REPAY_BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
87         REPAY_BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
88         REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
89         REPAY_BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED,
90         REPAY_BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED,
91         REPAY_BORROW_TRANSFER_IN_FAILED,
92         REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE,
93         SET_ADMIN_OWNER_CHECK,
94         SET_ASSET_PRICE_CHECK_ORACLE,
95         SET_MARKET_INTEREST_RATE_MODEL_OWNER_CHECK,
96         SET_ORACLE_OWNER_CHECK,
97         SET_ORIGINATION_FEE_OWNER_CHECK,
98         SET_RISK_PARAMETERS_OWNER_CHECK,
99         SET_RISK_PARAMETERS_VALIDATION,
100         SUPPLY_ACCUMULATED_BALANCE_CALCULATION_FAILED,
101         SUPPLY_MARKET_NOT_SUPPORTED,
102         SUPPLY_NEW_BORROW_INDEX_CALCULATION_FAILED,
103         SUPPLY_NEW_BORROW_RATE_CALCULATION_FAILED,
104         SUPPLY_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
105         SUPPLY_NEW_SUPPLY_RATE_CALCULATION_FAILED,
106         SUPPLY_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
107         SUPPLY_NEW_TOTAL_CASH_CALCULATION_FAILED,
108         SUPPLY_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
109         SUPPLY_TRANSFER_IN_FAILED,
110         SUPPLY_TRANSFER_IN_NOT_POSSIBLE,
111         SUPPORT_MARKET_OWNER_CHECK,
112         SUPPORT_MARKET_PRICE_CHECK,
113         SUSPEND_MARKET_OWNER_CHECK,
114         WITHDRAW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED,
115         WITHDRAW_ACCOUNT_SHORTFALL_PRESENT,
116         WITHDRAW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
117         WITHDRAW_AMOUNT_LIQUIDITY_SHORTFALL,
118         WITHDRAW_AMOUNT_VALUE_CALCULATION_FAILED,
119         WITHDRAW_CAPACITY_CALCULATION_FAILED,
120         WITHDRAW_NEW_BORROW_INDEX_CALCULATION_FAILED,
121         WITHDRAW_NEW_BORROW_RATE_CALCULATION_FAILED,
122         WITHDRAW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
123         WITHDRAW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
124         WITHDRAW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
125         WITHDRAW_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
126         WITHDRAW_TRANSFER_OUT_FAILED,
127         WITHDRAW_TRANSFER_OUT_NOT_POSSIBLE
128     }
129 
130     /**
131      * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
132      */
133     function fail(Error err, FailureInfo info) internal returns (uint256) {
134         emit Failure(uint256(err), uint256(info), 0);
135 
136         return uint256(err);
137     }
138 
139     /**
140      * @dev use this when reporting an opaque error from an upgradeable collaborator contract
141      */
142     function failOpaque(FailureInfo info, uint256 opaqueError)
143         internal
144         returns (uint256)
145     {
146         emit Failure(uint256(Error.OPAQUE_ERROR), uint256(info), opaqueError);
147 
148         return uint256(Error.OPAQUE_ERROR);
149     }
150 }
151 
152 contract CarefulMath is ErrorReporter {
153     /**
154      * @dev Multiplies two numbers, returns an error on overflow.
155      */
156     function mul(uint256 a, uint256 b) internal pure returns (Error, uint256) {
157         if (a == 0) {
158             return (Error.NO_ERROR, 0);
159         }
160 
161         uint256 c = a * b;
162 
163         if (c / a != b) {
164             return (Error.INTEGER_OVERFLOW, 0);
165         } else {
166             return (Error.NO_ERROR, c);
167         }
168     }
169 
170     /**
171      * @dev Integer division of two numbers, truncating the quotient.
172      */
173     function div(uint256 a, uint256 b) internal pure returns (Error, uint256) {
174         if (b == 0) {
175             return (Error.DIVISION_BY_ZERO, 0);
176         }
177 
178         return (Error.NO_ERROR, a / b);
179     }
180 
181     /**
182      * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
183      */
184     function sub(uint256 a, uint256 b) internal pure returns (Error, uint256) {
185         if (b <= a) {
186             return (Error.NO_ERROR, a - b);
187         } else {
188             return (Error.INTEGER_UNDERFLOW, 0);
189         }
190     }
191 
192     /**
193      * @dev Adds two numbers, returns an error on overflow.
194      */
195     function add(uint256 a, uint256 b) internal pure returns (Error, uint256) {
196         uint256 c = a + b;
197 
198         if (c >= a) {
199             return (Error.NO_ERROR, c);
200         } else {
201             return (Error.INTEGER_OVERFLOW, 0);
202         }
203     }
204 
205     /**
206      * @dev add a and b and then subtract c
207      */
208     function addThenSub(
209         uint256 a,
210         uint256 b,
211         uint256 c
212     ) internal pure returns (Error, uint256) {
213         (Error err0, uint256 sum) = add(a, b);
214 
215         if (err0 != Error.NO_ERROR) {
216             return (err0, 0);
217         }
218 
219         return sub(sum, c);
220     }
221 
222     /**
223      * @dev Add two numbers together, overflow will lead to revert.
224      */
225     function srcAdd(uint256 x, uint256 y) internal pure returns (uint256 z) {
226         require((z = x + y) >= x, "ds-math-add-overflow");
227     }
228 
229     /**
230      * @dev Integer subtraction of two numbers, overflow will lead to revert.
231      */
232     function srcSub(uint256 x, uint256 y) internal pure returns (uint256 z) {
233         require((z = x - y) <= x, "ds-math-sub-underflow");
234     }
235 
236     /**
237      * @dev Multiplies two numbers, overflow will lead to revert.
238      */
239     function srcMul(uint256 x, uint256 y) internal pure returns (uint256 z) {
240         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
241     }
242 
243     /**
244      * @dev Integer division of two numbers, truncating the quotient.
245      */
246     function srcDiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
247         require(y > 0, "ds-math-div-overflow");
248         z = x / y;
249     }
250 
251     /**
252      * @dev x to the power of y power(base, exponent)
253      */
254     function pow(uint256 base, uint256 exponent) internal pure returns (uint256) {
255         if (exponent == 0) {
256             return 1;
257         } else if (exponent == 1) {
258             return base;
259         } else if (base == 0 && exponent != 0) {
260             return 0;
261         } else {
262             uint256 z = base;
263             for (uint256 i = 1; i < exponent; i++) z = srcMul(z, base);
264             return z;
265         }
266     }
267 }
268 
269 contract Exponential is CarefulMath {
270     // TODO: We may wish to put the result of 10**18 here instead of the expression.
271     // Per https://solidity.readthedocs.io/en/latest/contracts.html#constant-state-variables
272     // the optimizer MAY replace the expression 10**18 with its calculated value.
273     uint256 constant expScale = 10**18;
274 
275     // See TODO on expScale
276     uint256 constant halfExpScale = expScale / 2;
277 
278     struct Exp {
279         uint256 mantissa;
280     }
281 
282     uint256 constant mantissaOne = 10**18;
283     uint256 constant mantissaOneTenth = 10**17;
284 
285     /**
286      * @dev Creates an exponential from numerator and denominator values.
287      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
288      *            or if `denom` is zero.
289      */
290     function getExp(uint256 num, uint256 denom)
291         internal
292         pure
293         returns (Error, Exp memory)
294     {
295         (Error err0, uint256 scaledNumerator) = mul(num, expScale);
296         if (err0 != Error.NO_ERROR) {
297             return (err0, Exp({ mantissa: 0 }));
298         }
299 
300         (Error err1, uint256 rational) = div(scaledNumerator, denom);
301         if (err1 != Error.NO_ERROR) {
302             return (err1, Exp({ mantissa: 0 }));
303         }
304 
305         return (Error.NO_ERROR, Exp({ mantissa: rational }));
306     }
307 
308     /**
309      * @dev Adds two exponentials, returning a new exponential.
310      */
311     function addExp(Exp memory a, Exp memory b)
312         internal
313         pure
314         returns (Error, Exp memory)
315     {
316         (Error error, uint256 result) = add(a.mantissa, b.mantissa);
317 
318         return (error, Exp({ mantissa: result }));
319     }
320 
321     /**
322      * @dev Subtracts two exponentials, returning a new exponential.
323      */
324     function subExp(Exp memory a, Exp memory b)
325         internal
326         pure
327         returns (Error, Exp memory)
328     {
329         (Error error, uint256 result) = sub(a.mantissa, b.mantissa);
330 
331         return (error, Exp({ mantissa: result }));
332     }
333 
334     /**
335      * @dev Multiply an Exp by a scalar, returning a new Exp.
336      */
337     function mulScalar(Exp memory a, uint256 scalar)
338         internal
339         pure
340         returns (Error, Exp memory)
341     {
342         (Error err0, uint256 scaledMantissa) = mul(a.mantissa, scalar);
343         if (err0 != Error.NO_ERROR) {
344             return (err0, Exp({ mantissa: 0 }));
345         }
346 
347         return (Error.NO_ERROR, Exp({ mantissa: scaledMantissa }));
348     }
349 
350     /**
351      * @dev Divide an Exp by a scalar, returning a new Exp.
352      */
353     function divScalar(Exp memory a, uint256 scalar)
354         internal
355         pure
356         returns (Error, Exp memory)
357     {
358         (Error err0, uint256 descaledMantissa) = div(a.mantissa, scalar);
359         if (err0 != Error.NO_ERROR) {
360             return (err0, Exp({ mantissa: 0 }));
361         }
362 
363         return (Error.NO_ERROR, Exp({ mantissa: descaledMantissa }));
364     }
365 
366     /**
367      * @dev Divide a scalar by an Exp, returning a new Exp.
368      */
369     function divScalarByExp(uint256 scalar, Exp memory divisor)
370         internal
371         pure
372         returns (Error, Exp memory)
373     {
374         /*
375             We are doing this as:
376             getExp(mul(expScale, scalar), divisor.mantissa)
377 
378             How it works:
379             Exp = a / b;
380             Scalar = s;
381             `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
382         */
383         (Error err0, uint256 numerator) = mul(expScale, scalar);
384         if (err0 != Error.NO_ERROR) {
385             return (err0, Exp({ mantissa: 0 }));
386         }
387         return getExp(numerator, divisor.mantissa);
388     }
389 
390     /**
391      * @dev Multiplies two exponentials, returning a new exponential.
392      */
393     function mulExp(Exp memory a, Exp memory b)
394         internal
395         pure
396         returns (Error, Exp memory)
397     {
398         (Error err0, uint256 doubleScaledProduct) = mul(a.mantissa, b.mantissa);
399         if (err0 != Error.NO_ERROR) {
400             return (err0, Exp({ mantissa: 0 }));
401         }
402 
403         // We add half the scale before dividing so that we get rounding instead of truncation.
404         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
405         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
406         (Error err1, uint256 doubleScaledProductWithHalfScale) =
407             add(halfExpScale, doubleScaledProduct);
408         if (err1 != Error.NO_ERROR) {
409             return (err1, Exp({ mantissa: 0 }));
410         }
411 
412         (Error err2, uint256 product) =
413             div(doubleScaledProductWithHalfScale, expScale);
414         // The only error `div` can return is Error.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
415         assert(err2 == Error.NO_ERROR);
416 
417         return (Error.NO_ERROR, Exp({ mantissa: product }));
418     }
419 
420     /**
421      * @dev Divides two exponentials, returning a new exponential.
422      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
423      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
424      */
425     function divExp(Exp memory a, Exp memory b)
426         internal
427         pure
428         returns (Error, Exp memory)
429     {
430         return getExp(a.mantissa, b.mantissa);
431     }
432 
433     /**
434      * @dev Truncates the given exp to a whole number value.
435      *      For example, truncate(Exp{mantissa: 15 * (10**18)}) = 15
436      */
437     function truncate(Exp memory exp) internal pure returns (uint256) {
438         // Note: We are not using careful math here as we're performing a division that cannot fail
439         return exp.mantissa / 10**18;
440     }
441 
442     /**
443      * @dev Checks if first Exp is less than second Exp.
444      */
445     function lessThanExp(Exp memory left, Exp memory right)
446         internal
447         pure
448         returns (bool)
449     {
450         return left.mantissa < right.mantissa;
451     }
452 
453     /**
454      * @dev Checks if left Exp <= right Exp.
455      */
456     function lessThanOrEqualExp(Exp memory left, Exp memory right)
457         internal
458         pure
459         returns (bool)
460     {
461         return left.mantissa <= right.mantissa;
462     }
463 
464     /**
465      * @dev Checks if first Exp is greater than second Exp.
466      */
467     function greaterThanExp(Exp memory left, Exp memory right)
468         internal
469         pure
470         returns (bool)
471     {
472         return left.mantissa > right.mantissa;
473     }
474 
475     /**
476      * @dev returns true if Exp is exactly zero
477      */
478     function isZeroExp(Exp memory value) internal pure returns (bool) {
479         return value.mantissa == 0;
480     }
481 }
482 
483 interface ExchangeRateModel {
484     function scale() external view returns (uint256);
485 
486     function token() external view returns (address);
487 
488     function getExchangeRate() external view returns (uint256);
489 
490     function getMaxSwingRate(uint256 interval) external view returns (uint256);
491 
492     function getFixedInterestRate(uint256 interval)
493         external
494         view
495         returns (uint256);
496 
497     function getFixedExchangeRate(uint256 interval)
498         external
499         view
500         returns (uint256);
501 }
502 
503 interface IERC20 {
504     function decimals() external view returns (uint8);
505 }
506 
507 interface IAggregator {
508     function latestAnswer() external view returns (int256);
509 
510     function latestTimestamp() external view returns (uint256);
511 
512     function latestRound() external view returns (uint256);
513 
514     function getAnswer(uint256 roundId) external view returns (int256);
515 
516     function getTimestamp(uint256 roundId) external view returns (uint256);
517 
518     function decimals() external view returns (uint8);
519 }
520 
521 interface IStatusOracle {
522 
523     function getAssetPriceStatus(address _asset) external view returns (bool);
524 }
525 
526 contract PriceOracle is Exponential {
527     // Flag for whether or not contract is paused.
528     bool public paused;
529 
530     // Approximately 1 hour: 60 seconds/minute * 60 minutes/hour * 1 block/15 seconds.
531     uint256 public constant numBlocksPerPeriod = 240;
532 
533     uint256 public constant maxSwingMantissa = (5 * 10**15); // 0.005
534 
535     uint256 public constant MINIMUM_SWING = 10**15;
536     uint256 public constant MAXIMUM_SWING = 10**17;
537 
538     uint256 public constant SECONDS_PER_WEEK = 604800;
539 
540     /**
541      * @dev An administrator who can set the pending anchor value for assets.
542      *      Set in the constructor.
543      */
544     address public anchorAdmin;
545 
546     /**
547      * @dev Pending anchor administrator for this contract.
548      */
549     address public pendingAnchorAdmin;
550 
551     /**
552      * @dev Address of the price poster.
553      *      Set in the constructor.
554      */
555     address public poster;
556 
557     /**
558      * @dev The maximum allowed percentage difference between a new price and the anchor's price
559      *      Set only in the constructor
560      */
561     Exp public maxSwing;
562 
563     /**
564      * @dev The maximum allowed percentage difference for all assets between a new price and the anchor's price
565      */
566     mapping(address => Exp) public maxSwings;
567 
568     /**
569      * @dev Mapping of asset addresses to exchange rate information.
570      *      Dynamic changes in asset prices based on exchange rates.
571      * map: assetAddress -> ExchangeRateInfo
572      */
573     struct ExchangeRateInfo {
574         address exchangeRateModel; // Address of exchange rate model contract
575         uint256 exchangeRate; // Exchange rate between token and wrapped token
576         uint256 maxSwingRate; // Maximum changing ratio of the exchange rate
577         uint256 maxSwingDuration; // Duration of maximum changing ratio of the exchange rate
578     }
579     mapping(address => ExchangeRateInfo) public exchangeRates;
580 
581     /**
582      * @dev Mapping of asset addresses to asset addresses. Stable coin can share a price.
583      *
584      * map: assetAddress -> Reader
585      */
586     struct Reader {
587         address asset; // Asset to read price
588         int256 decimalsDifference; // Standard decimal is 18, so this is equal to the decimal of `asset` - 18.
589     }
590     mapping(address => Reader) public readers;
591 
592     /**
593      * @dev Mapping of asset addresses and their corresponding price in terms of Eth-Wei
594      *      which is simply equal to AssetWeiPrice * 10e18. For instance, if OMG token was
595      *      worth 5x Eth then the price for OMG would be 5*10e18 or Exp({mantissa: 5000000000000000000}).
596      * map: assetAddress -> Exp
597      */
598     mapping(address => Exp) public _assetPrices;
599     
600     /**
601      * @dev Mapping of asset addresses to aggregator.
602      */
603     mapping(address => IAggregator) public aggregator;
604 
605     /**
606      * @dev Mapping of asset addresses to statusOracle.
607      */
608     mapping(address => IStatusOracle) public statusOracle;
609 
610     constructor(address _poster, uint256 _maxSwing) public {
611         anchorAdmin = msg.sender;
612         poster = _poster;
613         _setMaxSwing(_maxSwing);
614     }
615 
616     /**
617      * @notice Do not pay into PriceOracle.
618      */
619     receive() external payable {
620         revert();
621     }
622 
623     enum OracleError { NO_ERROR, UNAUTHORIZED, FAILED_TO_SET_PRICE }
624 
625     enum OracleFailureInfo {
626         ACCEPT_ANCHOR_ADMIN_PENDING_ANCHOR_ADMIN_CHECK,
627         SET_PAUSED_OWNER_CHECK,
628         SET_PENDING_ANCHOR_ADMIN_OWNER_CHECK,
629         SET_PENDING_ANCHOR_PERMISSION_CHECK,
630         SET_PRICE_CALCULATE_SWING,
631         SET_PRICE_CAP_TO_MAX,
632         SET_PRICE_MAX_SWING_CHECK,
633         SET_PRICE_NO_ANCHOR_PRICE_OR_INITIAL_PRICE_ZERO,
634         SET_PRICE_PERMISSION_CHECK,
635         SET_PRICE_ZERO_PRICE,
636         SET_PRICES_PARAM_VALIDATION,
637         SET_PRICE_IS_READER_ASSET,
638         ADMIN_CONFIG
639     }
640 
641     /**
642      * @dev `msgSender` is msg.sender; `error` corresponds to enum OracleError;
643      *      `info` corresponds to enum OracleFailureInfo, and `detail` is an arbitrary
644      *      contract-specific code that enables us to report opaque error codes from upgradeable contracts.
645      */
646     event OracleFailure(
647         address msgSender,
648         address asset,
649         uint256 error,
650         uint256 info,
651         uint256 detail
652     );
653 
654     /**
655      * @dev Use this when reporting a known error from the price oracle or a non-upgradeable collaborator
656      *      Using Oracle in name because we already inherit a `fail` function from ErrorReporter.sol
657      *      via Exponential.sol
658      */
659     function failOracle(
660         address _asset,
661         OracleError _err,
662         OracleFailureInfo _info
663     ) internal returns (uint256) {
664         emit OracleFailure(msg.sender, _asset, uint256(_err), uint256(_info), 0);
665 
666         return uint256(_err);
667     }
668 
669     /**
670      * @dev Use this to report an error when set asset price.
671      *      Give the `error` corresponds to enum Error as `_details`.
672      */
673     function failOracleWithDetails(
674         address _asset,
675         OracleError _err,
676         OracleFailureInfo _info,
677         uint256 _details
678     ) internal returns (uint256) {
679         emit OracleFailure(
680             msg.sender,
681             _asset,
682             uint256(_err),
683             uint256(_info),
684             _details
685         );
686 
687         return uint256(_err);
688     }
689 
690     struct Anchor {
691         // Floor(block.number / numBlocksPerPeriod) + 1
692         uint256 period;
693         // Price in ETH, scaled by 10**18
694         uint256 priceMantissa;
695     }
696 
697     /**
698      * @dev Anchors by asset.
699      */
700     mapping(address => Anchor) public anchors;
701 
702     /**
703      * @dev Pending anchor prices by asset.
704      */
705     mapping(address => uint256) public pendingAnchors;
706 
707     /**
708      * @dev Emitted when a pending anchor is set.
709      * @param asset Asset for which to set a pending anchor.
710      * @param oldScaledPrice If an unused pending anchor was present, its value; otherwise 0.
711      * @param newScaledPrice The new scaled pending anchor price.
712      */
713     event NewPendingAnchor(
714         address anchorAdmin,
715         address asset,
716         uint256 oldScaledPrice,
717         uint256 newScaledPrice
718     );
719 
720     /**
721      * @notice Provides ability to override the anchor price for an asset.
722      * @dev Admin function to set the anchor price for an asset.
723      * @param _asset Asset for which to override the anchor price.
724      * @param _newScaledPrice New anchor price.
725      * @return uint 0=success, otherwise a failure (see enum OracleError for details).
726      */
727     function _setPendingAnchor(address _asset, uint256 _newScaledPrice)
728         external
729         returns (uint256)
730     {
731         // Check caller = anchorAdmin.
732         // Note: Deliberately not allowing admin. They can just change anchorAdmin if desired.
733         if (msg.sender != anchorAdmin) {
734             return
735                 failOracle(
736                     _asset,
737                     OracleError.UNAUTHORIZED,
738                     OracleFailureInfo.SET_PENDING_ANCHOR_PERMISSION_CHECK
739                 );
740         }
741 
742         uint256 _oldScaledPrice = pendingAnchors[_asset];
743         pendingAnchors[_asset] = _newScaledPrice;
744 
745         emit NewPendingAnchor(
746             msg.sender,
747             _asset,
748             _oldScaledPrice,
749             _newScaledPrice
750         );
751 
752         return uint256(OracleError.NO_ERROR);
753     }
754 
755     /**
756      * @dev Emitted for all exchangeRates changes.
757      */
758     event SetExchangeRate(
759         address asset,
760         address exchangeRateModel,
761         uint256 exchangeRate,
762         uint256 maxSwingRate,
763         uint256 maxSwingDuration
764     );
765     event SetMaxSwingRate(
766         address asset,
767         uint256 oldMaxSwingRate,
768         uint256 newMaxSwingRate,
769         uint256 maxSwingDuration
770     );
771 
772     /**
773      * @dev Emitted for all readers changes.
774      */
775     event ReaderPosted(
776         address asset,
777         address oldReader,
778         address newReader,
779         int256 decimalsDifference
780     );
781 
782     /**
783      * @dev Emitted for max swing changes.
784      */
785     event SetMaxSwing(uint256 maxSwing);
786 
787     /**
788      * @dev Emitted for max swing changes.
789      */
790     event SetMaxSwingForAsset(address asset, uint256 maxSwing);
791 
792     /**
793      * @dev Emitted for max swing changes.
794      */
795     event SetAssetAggregator(address asset, address aggregator);
796 
797     /**
798      * @dev Emitted for statusOracle changes.
799      */
800     event SetAssetStatusOracle(address asset, IStatusOracle statusOracle);
801 
802     /**
803      * @dev Emitted for all price changes.
804      */
805     event PricePosted(
806         address asset,
807         uint256 previousPriceMantissa,
808         uint256 requestedPriceMantissa,
809         uint256 newPriceMantissa
810     );
811 
812     /**
813      * @dev Emitted if this contract successfully posts a capped-to-max price.
814      */
815     event CappedPricePosted(
816         address asset,
817         uint256 requestedPriceMantissa,
818         uint256 anchorPriceMantissa,
819         uint256 cappedPriceMantissa
820     );
821 
822     /**
823      * @dev Emitted when admin either pauses or resumes the contract; `newState` is the resulting state.
824      */
825     event SetPaused(bool newState);
826 
827     /**
828      * @dev Emitted when `pendingAnchorAdmin` is changed.
829      */
830     event NewPendingAnchorAdmin(
831         address oldPendingAnchorAdmin,
832         address newPendingAnchorAdmin
833     );
834 
835     /**
836      * @dev Emitted when `pendingAnchorAdmin` is accepted, which means anchor admin is updated.
837      */
838     event NewAnchorAdmin(address oldAnchorAdmin, address newAnchorAdmin);
839 
840     /**
841      * @dev Emitted when `poster` is changed.
842      */
843     event NewPoster(address oldPoster, address newPoster);
844 
845     /**
846      * @notice Set `paused` to the specified state.
847      * @dev Admin function to pause or resume the contract.
848      * @param _requestedState Value to assign to `paused`.
849      * @return uint 0=success, otherwise a failure.
850      */
851     function _setPaused(bool _requestedState) external returns (uint256) {
852         // Check caller = anchorAdmin
853         if (msg.sender != anchorAdmin) {
854             return
855                 failOracle(
856                     address(0),
857                     OracleError.UNAUTHORIZED,
858                     OracleFailureInfo.SET_PAUSED_OWNER_CHECK
859                 );
860         }
861 
862         paused = _requestedState;
863         emit SetPaused(_requestedState);
864 
865         return uint256(Error.NO_ERROR);
866     }
867 
868     /**
869      * @notice Begins to transfer the right of anchor admin.
870      *         The `_newPendingAnchorAdmin` must call `_acceptAnchorAdmin` to finalize the transfer.
871      * @dev Admin function to change the anchor admin.
872      *      The `_newPendingAnchorAdmin` must call `_acceptAnchorAdmin` to finalize the transfer.
873      * @param _newPendingAnchorAdmin New pending anchor admin.
874      * @return uint 0=success, otherwise a failure.
875      */
876     function _setPendingAnchorAdmin(address _newPendingAnchorAdmin)
877         external
878         returns (uint256)
879     {
880         // Check caller = anchorAdmin.
881         if (msg.sender != anchorAdmin) {
882             return
883                 failOracle(
884                     address(0),
885                     OracleError.UNAUTHORIZED,
886                     OracleFailureInfo.SET_PENDING_ANCHOR_ADMIN_OWNER_CHECK
887                 );
888         }
889 
890         // Save current value, if any, for inclusion in log.
891         address _oldPendingAnchorAdmin = pendingAnchorAdmin;
892         // Store pendingAdmin = newPendingAdmin.
893         pendingAnchorAdmin = _newPendingAnchorAdmin;
894 
895         emit NewPendingAnchorAdmin(
896             _oldPendingAnchorAdmin,
897             _newPendingAnchorAdmin
898         );
899 
900         return uint256(Error.NO_ERROR);
901     }
902 
903     /**
904      * @notice Accepts transfer of anchor admin rights. `msg.sender` must be `pendingAnchorAdmin`.
905      * @dev Admin function for pending anchor admin to accept role and update anchor admin`
906      * @return uint 0=success, otherwise a failure`
907      */
908     function _acceptAnchorAdmin() external returns (uint256) {
909         // Check caller = pendingAnchorAdmin.
910         // `msg.sender` can't be zero.
911         if (msg.sender != pendingAnchorAdmin) {
912             return
913                 failOracle(
914                     address(0),
915                     OracleError.UNAUTHORIZED,
916                     OracleFailureInfo
917                         .ACCEPT_ANCHOR_ADMIN_PENDING_ANCHOR_ADMIN_CHECK
918                 );
919         }
920 
921         // Save current value for inclusion in log.
922         address _oldAnchorAdmin = anchorAdmin;
923         // Store admin = pendingAnchorAdmin.
924         anchorAdmin = pendingAnchorAdmin;
925         // Clear the pending value.
926         pendingAnchorAdmin = address(0);
927 
928         emit NewAnchorAdmin(_oldAnchorAdmin, msg.sender);
929 
930         return uint256(Error.NO_ERROR);
931     }
932 
933     /**
934      * @notice Set new poster.
935      * @dev Admin function to change of poster.
936      * @param _newPoster New poster.
937      * @return uint 0=success, otherwise a failure.
938      *
939      * TODO: Should we add a second arg to verify, like a checksum of `newAnchorAdmin` address?
940      */
941     function _setPoster(address _newPoster) external returns (uint256) {
942         assert(poster != _newPoster);
943         // Check caller = anchorAdmin.
944         if (msg.sender != anchorAdmin) {
945             return
946                 failOracle(
947                     address(0),
948                     OracleError.UNAUTHORIZED,
949                     OracleFailureInfo.ADMIN_CONFIG
950                 );
951         }
952 
953         // Save current value, if any, for inclusion in log.
954         address _oldPoster = poster;
955         // Store poster = newPoster.
956         poster = _newPoster;
957 
958         emit NewPoster(_oldPoster, _newPoster);
959 
960         return uint256(Error.NO_ERROR);
961     }
962 
963     /**
964      * @notice Set new exchange rate model.
965      * @dev Function to set exchangeRateModel for an asset.
966      * @param _asset Asset to set the new `_exchangeRateModel`.
967      * @param _exchangeRateModel New `_exchangeRateModel` cnotract address,
968      *                          if the `_exchangeRateModel` is address(0), revert to cancle.
969      * @param _maxSwingDuration A value greater than zero and less than the seconds of a week.
970      * @return uint 0=success, otherwise a failure (see enum OracleError for details).
971      */
972     function setExchangeRate(
973         address _asset,
974         address _exchangeRateModel,
975         uint256 _maxSwingDuration
976     ) external returns (uint256) {
977         // Check caller = anchorAdmin.
978         if (msg.sender != anchorAdmin) {
979             return
980                 failOracle(
981                     _asset,
982                     OracleError.UNAUTHORIZED,
983                     OracleFailureInfo.ADMIN_CONFIG
984                 );
985         }
986 
987         require(
988             _exchangeRateModel != address(0),
989             "setExchangeRate: exchangeRateModel cannot be a zero address."
990         );
991         require(
992             _maxSwingDuration > 0 && _maxSwingDuration <= SECONDS_PER_WEEK,
993             "setExchangeRate: maxSwingDuration cannot be zero, less than 604800 (seconds per week)."
994         );
995 
996         uint256 _currentExchangeRate =
997             ExchangeRateModel(_exchangeRateModel).getExchangeRate();
998         require(
999             _currentExchangeRate > 0,
1000             "setExchangeRate: currentExchangeRate not zero."
1001         );
1002 
1003         uint256 _maxSwingRate =
1004             ExchangeRateModel(_exchangeRateModel).getMaxSwingRate(
1005                 _maxSwingDuration
1006             );
1007         require(
1008             _maxSwingRate > 0 &&
1009                 _maxSwingRate <=
1010                 ExchangeRateModel(_exchangeRateModel).getMaxSwingRate(
1011                     SECONDS_PER_WEEK
1012                 ),
1013             "setExchangeRate: maxSwingRate cannot be zero, less than 604800 (seconds per week)."
1014         );
1015 
1016         exchangeRates[_asset].exchangeRateModel = _exchangeRateModel;
1017         exchangeRates[_asset].exchangeRate = _currentExchangeRate;
1018         exchangeRates[_asset].maxSwingRate = _maxSwingRate;
1019         exchangeRates[_asset].maxSwingDuration = _maxSwingDuration;
1020 
1021         emit SetExchangeRate(
1022             _asset,
1023             _exchangeRateModel,
1024             _currentExchangeRate,
1025             _maxSwingRate,
1026             _maxSwingDuration
1027         );
1028         return uint256(OracleError.NO_ERROR);
1029     }
1030 
1031     /**
1032      * @notice Set the asset’s `exchangeRateModel` to disabled.
1033      * @dev Admin function to disable of exchangeRateModel.
1034      * @param _asset Asset for which to disable the `exchangeRateModel`.
1035      * @return uint 0=success, otherwise a failure.
1036      */
1037     function _disableExchangeRate(address _asset)
1038         public
1039         returns (uint256)
1040     {
1041         // Check caller = anchorAdmin.
1042         if (msg.sender != anchorAdmin) {
1043             return
1044                 failOracle(
1045                     _asset,
1046                     OracleError.UNAUTHORIZED,
1047                     OracleFailureInfo.ADMIN_CONFIG
1048                 );
1049         }
1050 
1051         exchangeRates[_asset].exchangeRateModel = address(0);
1052         exchangeRates[_asset].exchangeRate = 0;
1053         exchangeRates[_asset].maxSwingRate = 0;
1054         exchangeRates[_asset].maxSwingDuration = 0;
1055 
1056         emit SetExchangeRate(
1057             _asset,
1058             address(0),
1059             0,
1060             0,
1061             0
1062         );
1063         return uint256(OracleError.NO_ERROR);
1064     }
1065 
1066     /**
1067      * @notice Set a new `maxSwingRate`.
1068      * @dev Function to set exchange rate `maxSwingRate` for an asset.
1069      * @param _asset Asset for which to set the exchange rate `maxSwingRate`.
1070      * @param _maxSwingDuration Interval time.
1071      * @return uint 0=success, otherwise a failure (see enum OracleError for details)
1072      */
1073     function setMaxSwingRate(address _asset, uint256 _maxSwingDuration)
1074         external
1075         returns (uint256)
1076     {
1077         // Check caller = anchorAdmin
1078         if (msg.sender != anchorAdmin) {
1079             return
1080                 failOracle(
1081                     _asset,
1082                     OracleError.UNAUTHORIZED,
1083                     OracleFailureInfo.ADMIN_CONFIG
1084                 );
1085         }
1086 
1087         require(
1088             _maxSwingDuration > 0 && _maxSwingDuration <= SECONDS_PER_WEEK,
1089             "setMaxSwingRate: maxSwingDuration cannot be zero, less than 604800 (seconds per week)."
1090         );
1091 
1092         ExchangeRateModel _exchangeRateModel =
1093             ExchangeRateModel(exchangeRates[_asset].exchangeRateModel);
1094         uint256 _newMaxSwingRate =
1095             _exchangeRateModel.getMaxSwingRate(_maxSwingDuration);
1096         uint256 _oldMaxSwingRate = exchangeRates[_asset].maxSwingRate;
1097         require(
1098             _oldMaxSwingRate != _newMaxSwingRate,
1099             "setMaxSwingRate: the same max swing rate."
1100         );
1101         require(
1102             _newMaxSwingRate > 0 &&
1103                 _newMaxSwingRate <=
1104                 _exchangeRateModel.getMaxSwingRate(SECONDS_PER_WEEK),
1105             "setMaxSwingRate: maxSwingRate cannot be zero, less than 31536000 (seconds per week)."
1106         );
1107 
1108         exchangeRates[_asset].maxSwingRate = _newMaxSwingRate;
1109         exchangeRates[_asset].maxSwingDuration = _maxSwingDuration;
1110 
1111         emit SetMaxSwingRate(
1112             _asset,
1113             _oldMaxSwingRate,
1114             _newMaxSwingRate,
1115             _maxSwingDuration
1116         );
1117         return uint256(OracleError.NO_ERROR);
1118     }
1119 
1120     /**
1121      * @notice Entry point for updating prices.
1122      * @dev Set reader for an asset.
1123      * @param _asset Asset for which to set the reader.
1124      * @param _readAsset Reader address, if the reader is address(0), cancel the reader.
1125      * @return uint 0=success, otherwise a failure (see enum OracleError for details).
1126      */
1127     function setReaders(address _asset, address _readAsset)
1128         external
1129         returns (uint256)
1130     {
1131         // Check caller = anchorAdmin
1132         if (msg.sender != anchorAdmin) {
1133             return
1134                 failOracle(
1135                     _asset,
1136                     OracleError.UNAUTHORIZED,
1137                     OracleFailureInfo.ADMIN_CONFIG
1138                 );
1139         }
1140 
1141         address _oldReadAsset = readers[_asset].asset;
1142         // require(_readAsset != _oldReadAsset, "setReaders: Old and new values cannot be the same.");
1143         require(
1144             _readAsset != _asset,
1145             "setReaders: asset and readAsset cannot be the same."
1146         );
1147 
1148         readers[_asset].asset = _readAsset;
1149         if (_readAsset == address(0)) readers[_asset].decimalsDifference = 0;
1150         else
1151             readers[_asset].decimalsDifference = int256(
1152                 IERC20(_asset).decimals() - IERC20(_readAsset).decimals()
1153             );
1154 
1155         emit ReaderPosted(
1156             _asset,
1157             _oldReadAsset,
1158             _readAsset,
1159             readers[_asset].decimalsDifference
1160         );
1161         return uint256(OracleError.NO_ERROR);
1162     }
1163 
1164     /**
1165      * @notice Set `maxSwing` to the specified value.
1166      * @dev Admin function to change of max swing.
1167      * @param _maxSwing Value to assign to `maxSwing`.
1168      * @return uint 0=success, otherwise a failure.
1169      */
1170     function _setMaxSwing(uint256 _maxSwing) public returns (uint256) {
1171         // Check caller = anchorAdmin
1172         if (msg.sender != anchorAdmin) {
1173             return
1174                 failOracle(
1175                     address(0),
1176                     OracleError.UNAUTHORIZED,
1177                     OracleFailureInfo.ADMIN_CONFIG
1178                 );
1179         }
1180 
1181         uint256 _oldMaxSwing = maxSwing.mantissa;
1182         require(
1183             _maxSwing != _oldMaxSwing,
1184             "_setMaxSwing: Old and new values cannot be the same."
1185         );
1186 
1187         require(
1188             _maxSwing >= MINIMUM_SWING && _maxSwing <= MAXIMUM_SWING,
1189             "_setMaxSwing: 0.1% <= _maxSwing <= 10%."
1190         );
1191         maxSwing = Exp({ mantissa: _maxSwing });
1192         emit SetMaxSwing(_maxSwing);
1193 
1194         return uint256(Error.NO_ERROR);
1195     }
1196 
1197     /**
1198      * @notice Set `maxSwing` for asset to the specified value.
1199      * @dev Admin function to change of max swing.
1200      * @param _asset Asset for which to set the `maxSwing`.
1201      * @param _maxSwing Value to assign to `maxSwing`.
1202      * @return uint 0=success, otherwise a failure.
1203      */
1204     function _setMaxSwingForAsset(address _asset, uint256 _maxSwing)
1205         public
1206         returns (uint256)
1207     {
1208         // Check caller = anchorAdmin
1209         if (msg.sender != anchorAdmin) {
1210             return
1211                 failOracle(
1212                     address(0),
1213                     OracleError.UNAUTHORIZED,
1214                     OracleFailureInfo.ADMIN_CONFIG
1215                 );
1216         }
1217 
1218         uint256 _oldMaxSwing = maxSwings[_asset].mantissa;
1219         require(
1220             _maxSwing != _oldMaxSwing,
1221             "_setMaxSwingForAsset: Old and new values cannot be the same."
1222         );
1223         require(
1224             _maxSwing >= MINIMUM_SWING && _maxSwing <= MAXIMUM_SWING,
1225             "_setMaxSwingForAsset: 0.1% <= _maxSwing <= 10%."
1226         );
1227         maxSwings[_asset] = Exp({ mantissa: _maxSwing });
1228         emit SetMaxSwingForAsset(_asset, _maxSwing);
1229 
1230         return uint256(Error.NO_ERROR);
1231     }
1232 
1233     function _setMaxSwingForAssetBatch(
1234         address[] calldata _assets,
1235         uint256[] calldata _maxSwings
1236     ) external {
1237         require(
1238             _assets.length == _maxSwings.length,
1239             "_setMaxSwingForAssetBatch: assets & maxSwings must match the current length."
1240         );
1241         for (uint256 i = 0; i < _assets.length; i++)
1242             _setMaxSwingForAsset(_assets[i], _maxSwings[i]);
1243     }
1244 
1245     /**
1246      * @notice Set `aggregator` for asset to the specified address.
1247      * @dev Admin function to change of aggregator.
1248      * @param _asset Asset for which to set the `aggregator`.
1249      * @param _aggregator Address to assign to `aggregator`.
1250      * @return uint 0=success, otherwise a failure.
1251      */
1252     function _setAssetAggregator(address _asset, IAggregator _aggregator)
1253         public
1254         returns (uint256)
1255     {
1256         // Check caller = anchorAdmin
1257         if (msg.sender != anchorAdmin) {
1258             return
1259                 failOracle(
1260                     address(0),
1261                     OracleError.UNAUTHORIZED,
1262                     OracleFailureInfo.ADMIN_CONFIG
1263                 );
1264         }
1265 
1266         require(
1267             _aggregator.decimals() > 0,
1268             "_setAssetAggregator: This is not the aggregator contract!"
1269         );
1270 
1271         IAggregator _oldAssetAggregator = aggregator[_asset];
1272         require(
1273             _aggregator != _oldAssetAggregator,
1274             "_setAssetAggregator: Old and new address cannot be the same."
1275         );
1276         
1277         aggregator[_asset] = IAggregator(_aggregator);
1278         emit SetAssetAggregator(_asset, address(_aggregator));
1279 
1280         return uint256(Error.NO_ERROR);
1281     }
1282 
1283     function _setAssetAggregatorBatch(
1284         address[] calldata _assets,
1285         IAggregator[] calldata _aggregators
1286     ) external {
1287         require(
1288             _assets.length == _aggregators.length,
1289             "_setAssetAggregatorBatch: assets & aggregators must match the current length."
1290         );
1291         for (uint256 i = 0; i < _assets.length; i++)
1292             _setAssetAggregator(_assets[i], _aggregators[i]);
1293     }
1294 
1295     /**
1296      * @notice Set the asset’s `aggregator` to disabled.
1297      * @dev Admin function to disable of aggregator.
1298      * @param _asset Asset for which to disable the `aggregator`.
1299      * @return uint 0=success, otherwise a failure.
1300      */
1301     function _disableAssetAggregator(address _asset)
1302         public
1303         returns (uint256)
1304     {
1305         // Check caller = anchorAdmin
1306         if (msg.sender != anchorAdmin) {
1307             return
1308                 failOracle(
1309                     address(0),
1310                     OracleError.UNAUTHORIZED,
1311                     OracleFailureInfo.ADMIN_CONFIG
1312                 );
1313         }
1314 
1315         require(
1316             _getReaderPrice(_asset) > 0,
1317             "_disableAssetAggregator: The price of local assets cannot be 0!"
1318         );
1319         
1320         aggregator[_asset] = IAggregator(address(0));
1321         emit SetAssetAggregator(_asset, address(0));
1322 
1323         return uint256(Error.NO_ERROR);
1324     }
1325 
1326     function _disableAssetAggregatorBatch(address[] calldata _assets) external {
1327         for (uint256 i = 0; i < _assets.length; i++)
1328             _disableAssetAggregator(_assets[i]);
1329     }
1330 
1331     /**
1332      * @notice Set `statusOracle` for asset to the specified address.
1333      * @dev Admin function to change of statusOracle.
1334      * @param _asset Asset for which to set the `statusOracle`.
1335      * @param _statusOracle Address to assign to `statusOracle`.
1336      * @return uint 0=success, otherwise a failure.SetAssetStatusOracle
1337      */
1338     function _setAssetStatusOracle(address _asset, IStatusOracle _statusOracle)
1339         public
1340         returns (uint256)
1341     {
1342         // Check caller = anchorAdmin
1343         if (msg.sender != anchorAdmin) {
1344             return
1345                 failOracle(
1346                     address(0),
1347                     OracleError.UNAUTHORIZED,
1348                     OracleFailureInfo.ADMIN_CONFIG
1349                 );
1350         }
1351 
1352         _statusOracle.getAssetPriceStatus(_asset);
1353         
1354         statusOracle[_asset] = _statusOracle;
1355         emit SetAssetStatusOracle(_asset, _statusOracle);
1356 
1357         return uint256(Error.NO_ERROR);
1358     }
1359 
1360     function _setAssetStatusOracleBatch(
1361         address[] calldata _assets,
1362         IStatusOracle[] calldata _statusOracles
1363     ) external {
1364         require(
1365             _assets.length == _statusOracles.length,
1366             "_setAssetStatusOracleBatch: assets & _statusOracles must match the current length."
1367         );
1368         for (uint256 i = 0; i < _assets.length; i++)
1369             _setAssetStatusOracle(_assets[i], _statusOracles[i]);
1370     }
1371 
1372     /**
1373      * @notice Set the `statusOracle` to disabled.
1374      * @dev Admin function to disable of statusOracle.
1375      * @return uint 0=success, otherwise a failure.
1376      */
1377     function _disableAssetStatusOracle(address _asset)
1378         public
1379         returns (uint256)
1380     {
1381         // Check caller = anchorAdmin
1382         if (msg.sender != anchorAdmin) {
1383             return
1384                 failOracle(
1385                     address(0),
1386                     OracleError.UNAUTHORIZED,
1387                     OracleFailureInfo.ADMIN_CONFIG
1388                 );
1389         }
1390         statusOracle[_asset] = IStatusOracle(0);
1391         
1392         emit SetAssetStatusOracle(_asset, IStatusOracle(0));
1393 
1394         return uint256(Error.NO_ERROR);
1395     }
1396 
1397     function _disableAssetStatusOracleBatch(address[] calldata _assets) external {
1398         for (uint256 i = 0; i < _assets.length; i++)
1399             _disableAssetStatusOracle(_assets[i]);
1400     }
1401 
1402     /**
1403      * @notice Asset prices are provided by chain link or other aggregator.
1404      * @dev Get price of `asset` from aggregator.
1405      * @param _asset Asset for which to get the price.
1406      * @return Uint mantissa of asset price (scaled by 1e18) or zero if unset or under unexpected case.
1407      */
1408     function _getAssetAggregatorPrice(address _asset) internal view returns (uint256) {
1409         IAggregator _assetAggregator = aggregator[_asset];
1410         if (address(_assetAggregator) == address(0))
1411             return 0;
1412 
1413         int256 _aggregatorPrice = _assetAggregator.latestAnswer();
1414         if (_aggregatorPrice <= 0)
1415             return 0;
1416 
1417         return srcMul(
1418             uint256(_aggregatorPrice), 
1419             10 ** (srcSub(36, srcAdd(uint256(IERC20(_asset).decimals()), uint256(_assetAggregator.decimals()))))
1420         );
1421     }
1422 
1423     function getAssetAggregatorPrice(address _asset) external view returns (uint256) {
1424         return _getAssetAggregatorPrice(_asset);
1425     }
1426 
1427     /**
1428      * @notice Asset prices are provided by aggregator or a reader.
1429      * @dev Get price of `asset`.
1430      * @param _asset Asset for which to get the price.
1431      * @return Uint mantissa of asset price (scaled by 1e18) or zero if unset or under unexpected case.
1432      */
1433     function _getAssetPrice(address _asset) internal view returns (uint256) {
1434         uint256 _assetPrice = _getAssetAggregatorPrice(_asset);
1435         if (_assetPrice == 0)
1436             return _getReaderPrice(_asset);
1437         
1438         return _assetPrice;
1439     }
1440 
1441     function getAssetPrice(address _asset) external view returns (uint256) {
1442         return _getAssetPrice(_asset);
1443     }
1444 
1445     /**
1446      * @notice This is a basic function to read price, although this is a public function,
1447      *         It is not recommended, the recommended function is `assetPrices(asset)`.
1448      *         If `asset` does not has a reader to reader price, then read price from original
1449      *         structure `_assetPrices`;
1450      *         If `asset` has a reader to read price, first gets the price of reader, then
1451      *         `readerPrice * 10 ** |(18-assetDecimals)|`
1452      * @dev Get price of `asset`.
1453      * @param _asset Asset for which to get the price.
1454      * @return Uint mantissa of asset price (scaled by 1e18) or zero if unset.
1455      */
1456     function _getReaderPrice(address _asset) internal view returns (uint256) {
1457         Reader storage _reader = readers[_asset];
1458         if (_reader.asset == address(0)) return _assetPrices[_asset].mantissa;
1459 
1460         uint256 readerPrice = _assetPrices[_reader.asset].mantissa;
1461 
1462         if (_reader.decimalsDifference < 0)
1463             return
1464                 srcMul(
1465                     readerPrice,
1466                     pow(10, uint256(0 - _reader.decimalsDifference))
1467                 );
1468 
1469         return srcDiv(readerPrice, pow(10, uint256(_reader.decimalsDifference)));
1470     }
1471 
1472     function getReaderPrice(address _asset) external view returns (uint256) {
1473         return _getReaderPrice(_asset);
1474     }
1475 
1476     /**
1477      * @notice Retrieves price of an asset.
1478      * @dev Get price for an asset.
1479      * @param _asset Asset for which to get the price.
1480      * @return Uint mantissa of asset price (scaled by 1e18) or zero if unset or contract paused.
1481      */
1482     function assetPrices(address _asset) internal view returns (uint256) {
1483         // Note: zero is treated by the xSwap as an invalid
1484         //       price and will cease operations with that asset
1485         //       when zero.
1486         //
1487         // We get the price as:
1488         //
1489         //  1. If the contract is paused, return 0.
1490         //  2. If the asset has an exchange rate model, the asset price is calculated based on the exchange rate.
1491         //  3. Return price in `_assetPrices`, which may be zero.
1492 
1493         if (paused) {
1494             return 0;
1495         } else {
1496             uint256 _assetPrice = _getAssetPrice(_asset);
1497             ExchangeRateInfo storage _exchangeRateInfo = exchangeRates[_asset];
1498             if (_exchangeRateInfo.exchangeRateModel != address(0)) {
1499                 uint256 _scale =
1500                     ExchangeRateModel(_exchangeRateInfo.exchangeRateModel)
1501                         .scale();
1502                 uint256 _currentExchangeRate =
1503                     ExchangeRateModel(_exchangeRateInfo.exchangeRateModel)
1504                         .getExchangeRate();
1505                 uint256 _currentChangeRate;
1506                 Error _err;
1507                 (_err, _currentChangeRate) = mul(_currentExchangeRate, _scale);
1508                 if (_err != Error.NO_ERROR) return 0;
1509 
1510                 _currentChangeRate =
1511                     _currentChangeRate /
1512                     _exchangeRateInfo.exchangeRate;
1513                 // require(_currentExchangeRate >= _exchangeRateInfo.exchangeRate && _currentChangeRate <= _exchangeRateInfo.maxSwingRate, "assetPrices: Abnormal exchange rate.");
1514                 if (
1515                     _currentExchangeRate < _exchangeRateInfo.exchangeRate ||
1516                     _currentChangeRate > _exchangeRateInfo.maxSwingRate
1517                 ) return 0;
1518 
1519                 uint256 _price;
1520                 (_err, _price) = mul(_assetPrice, _currentExchangeRate);
1521                 if (_err != Error.NO_ERROR) return 0;
1522 
1523                 return _price / _scale;
1524             } else {
1525                 return _assetPrice;
1526             }
1527         }
1528     }
1529 
1530     /**
1531      * @notice Retrieves price of an asset.
1532      * @dev Get price for an asset.
1533      * @param _asset Asset for which to get the price.
1534      * @return Uint mantissa of asset price (scaled by 1e18) or zero if unset or contract paused.
1535      */
1536     function getUnderlyingPrice(address _asset) external view returns (uint256) {
1537         return assetPrices(_asset);
1538     }
1539 
1540     /**
1541      * @notice The asset price status is provided by statusOracle.
1542      * @dev Get price status of `asset` from statusOracle.
1543      * @param _asset Asset for which to get the price status.
1544      * @return The asset price status is Boolean, the price status model is not set to true.true: available, false: unavailable.
1545      */
1546     function _getAssetPriceStatus(address _asset) internal view returns (bool) {
1547 
1548         IStatusOracle _statusOracle = statusOracle[_asset];
1549         if (_statusOracle == IStatusOracle(0))
1550             return true;
1551 
1552         return _statusOracle.getAssetPriceStatus(_asset);
1553     }
1554 
1555     function getAssetPriceStatus(address _asset) external view returns (bool) {
1556         return _getAssetPriceStatus(_asset);
1557     }
1558 
1559     /**
1560      * @notice Retrieve asset price and status.
1561      * @dev Get the price and status of the asset.
1562      * @param _asset The asset whose price and status are to be obtained.
1563      * @return Asset price and status.
1564      */
1565     function getUnderlyingPriceAndStatus(address _asset) external view returns (uint256, bool) {
1566         uint256 _assetPrice = assetPrices(_asset);
1567         return (_assetPrice, _getAssetPriceStatus(_asset));
1568     }
1569 
1570     /**
1571      * @dev Get exchange rate info of an asset in the time of `interval`.
1572      * @param _asset Asset for which to get the exchange rate info.
1573      * @param _interval Time to get accmulator interest rate.
1574      * @return Asset price, exchange rate model address, the token that is using this exchange rate model,
1575      *         exchange rate model contract address,
1576      *         the token that is using this exchange rate model,
1577      *         scale between token and wrapped token,
1578      *         exchange rate between token and wrapped token,
1579      *         After the time of `_interval`, get the accmulator interest rate.
1580      */
1581     function getExchangeRateInfo(address _asset, uint256 _interval)
1582         external
1583         view
1584         returns (
1585             uint256,
1586             address,
1587             address,
1588             uint256,
1589             uint256,
1590             uint256
1591         )
1592     {
1593         if (exchangeRates[_asset].exchangeRateModel == address(0))
1594             return (_getReaderPrice(_asset), address(0), address(0), 0, 0, 0);
1595 
1596         return (
1597             _getReaderPrice(_asset),
1598             exchangeRates[_asset].exchangeRateModel,
1599             ExchangeRateModel(exchangeRates[_asset].exchangeRateModel).token(),
1600             ExchangeRateModel(exchangeRates[_asset].exchangeRateModel).scale(),
1601             ExchangeRateModel(exchangeRates[_asset].exchangeRateModel)
1602                 .getExchangeRate(),
1603             ExchangeRateModel(exchangeRates[_asset].exchangeRateModel)
1604                 .getFixedInterestRate(_interval)
1605         );
1606     }
1607 
1608     struct SetPriceLocalVars {
1609         Exp price;
1610         Exp swing;
1611         Exp maxSwing;
1612         Exp anchorPrice;
1613         uint256 anchorPeriod;
1614         uint256 currentPeriod;
1615         bool priceCapped;
1616         uint256 cappingAnchorPriceMantissa;
1617         uint256 pendingAnchorMantissa;
1618     }
1619 
1620     /**
1621      * @notice Entry point for updating prices.
1622      *         1) If admin has set a `readerPrice` for this asset, then poster can not use this function.
1623      *         2) Standard stablecoin has 18 deicmals, and its price should be 1e18,
1624      *            so when the poster set a new price for a token,
1625      *            `requestedPriceMantissa` = actualPrice * 10 ** (18-tokenDecimals),
1626      *            actualPrice is scaled by 10**18.
1627      * @dev Set price for an asset.
1628      * @param _asset Asset for which to set the price.
1629      * @param _requestedPriceMantissa Requested new price, scaled by 10**18.
1630      * @return Uint 0=success, otherwise a failure (see enum OracleError for details).
1631      */
1632     function setPrice(address _asset, uint256 _requestedPriceMantissa)
1633         external
1634         returns (uint256)
1635     {
1636         // Fail when msg.sender is not poster
1637         if (msg.sender != poster) {
1638             return
1639                 failOracle(
1640                     _asset,
1641                     OracleError.UNAUTHORIZED,
1642                     OracleFailureInfo.SET_PRICE_PERMISSION_CHECK
1643                 );
1644         }
1645 
1646         return setPriceInternal(_asset, _requestedPriceMantissa);
1647     }
1648 
1649     function setPriceInternal(address _asset, uint256 _requestedPriceMantissa)
1650         internal
1651         returns (uint256)
1652     {
1653         // re-used for intermediate errors
1654         Error _err;
1655         SetPriceLocalVars memory _localVars;
1656         // We add 1 for currentPeriod so that it can never be zero and there's no ambiguity about an unset value.
1657         // (It can be a problem in tests with low block numbers.)
1658         _localVars.currentPeriod = (block.number / numBlocksPerPeriod) + 1;
1659         _localVars.pendingAnchorMantissa = pendingAnchors[_asset];
1660         _localVars.price = Exp({ mantissa: _requestedPriceMantissa });
1661 
1662         if (exchangeRates[_asset].exchangeRateModel != address(0)) {
1663             uint256 _currentExchangeRate =
1664                 ExchangeRateModel(exchangeRates[_asset].exchangeRateModel)
1665                     .getExchangeRate();
1666             uint256 _scale =
1667                 ExchangeRateModel(exchangeRates[_asset].exchangeRateModel)
1668                     .scale();
1669             uint256 _currentChangeRate;
1670             (_err, _currentChangeRate) = mul(_currentExchangeRate, _scale);
1671             assert(_err == Error.NO_ERROR);
1672 
1673             _currentChangeRate =
1674                 _currentChangeRate /
1675                 exchangeRates[_asset].exchangeRate;
1676             require(
1677                 _currentExchangeRate >= exchangeRates[_asset].exchangeRate &&
1678                     _currentChangeRate <= exchangeRates[_asset].maxSwingRate,
1679                 "setPriceInternal: Abnormal exchange rate."
1680             );
1681             exchangeRates[_asset].exchangeRate = _currentExchangeRate;
1682         }
1683 
1684         if (readers[_asset].asset != address(0)) {
1685             return
1686                 failOracle(
1687                     _asset,
1688                     OracleError.FAILED_TO_SET_PRICE,
1689                     OracleFailureInfo.SET_PRICE_IS_READER_ASSET
1690                 );
1691         }
1692 
1693         _localVars.maxSwing = maxSwings[_asset].mantissa == 0
1694             ? maxSwing
1695             : maxSwings[_asset];
1696         if (_localVars.pendingAnchorMantissa != 0) {
1697             // let's explicitly set to 0 rather than relying on default of declaration
1698             _localVars.anchorPeriod = 0;
1699             _localVars.anchorPrice = Exp({
1700                 mantissa: _localVars.pendingAnchorMantissa
1701             });
1702 
1703             // Verify movement is within max swing of pending anchor (currently: 10%)
1704             (_err, _localVars.swing) = calculateSwing(
1705                 _localVars.anchorPrice,
1706                 _localVars.price
1707             );
1708             if (_err != Error.NO_ERROR) {
1709                 return
1710                     failOracleWithDetails(
1711                         _asset,
1712                         OracleError.FAILED_TO_SET_PRICE,
1713                         OracleFailureInfo.SET_PRICE_CALCULATE_SWING,
1714                         uint256(_err)
1715                     );
1716             }
1717 
1718             // Fail when swing > maxSwing
1719             // if (greaterThanExp(_localVars.swing, maxSwing)) {
1720             if (greaterThanExp(_localVars.swing, _localVars.maxSwing)) {
1721                 return
1722                     failOracleWithDetails(
1723                         _asset,
1724                         OracleError.FAILED_TO_SET_PRICE,
1725                         OracleFailureInfo.SET_PRICE_MAX_SWING_CHECK,
1726                         _localVars.swing.mantissa
1727                     );
1728             }
1729         } else {
1730             _localVars.anchorPeriod = anchors[_asset].period;
1731             _localVars.anchorPrice = Exp({
1732                 mantissa: anchors[_asset].priceMantissa
1733             });
1734 
1735             if (_localVars.anchorPeriod != 0) {
1736                 // (_err, _localVars.priceCapped, _localVars.price) = capToMax(_localVars.anchorPrice, _localVars.price);
1737                 (_err, _localVars.priceCapped, _localVars.price) = capToMax(
1738                     _localVars.anchorPrice,
1739                     _localVars.price,
1740                     _localVars.maxSwing
1741                 );
1742                 if (_err != Error.NO_ERROR) {
1743                     return
1744                         failOracleWithDetails(
1745                             _asset,
1746                             OracleError.FAILED_TO_SET_PRICE,
1747                             OracleFailureInfo.SET_PRICE_CAP_TO_MAX,
1748                             uint256(_err)
1749                         );
1750                 }
1751                 if (_localVars.priceCapped) {
1752                     // save for use in log
1753                     _localVars.cappingAnchorPriceMantissa = _localVars
1754                         .anchorPrice
1755                         .mantissa;
1756                 }
1757             } else {
1758                 // Setting first price. Accept as is (already assigned above from _requestedPriceMantissa) and use as anchor
1759                 _localVars.anchorPrice = Exp({
1760                     mantissa: _requestedPriceMantissa
1761                 });
1762             }
1763         }
1764 
1765         // Fail if anchorPrice or price is zero.
1766         // zero anchor represents an unexpected situation likely due to a problem in this contract
1767         // zero price is more likely as the result of bad input from the caller of this function
1768         if (isZeroExp(_localVars.anchorPrice)) {
1769             // If we get here price could also be zero, but it does not seem worthwhile to distinguish the 3rd case
1770             return
1771                 failOracle(
1772                     _asset,
1773                     OracleError.FAILED_TO_SET_PRICE,
1774                     OracleFailureInfo
1775                         .SET_PRICE_NO_ANCHOR_PRICE_OR_INITIAL_PRICE_ZERO
1776                 );
1777         }
1778 
1779         if (isZeroExp(_localVars.price)) {
1780             return
1781                 failOracle(
1782                     _asset,
1783                     OracleError.FAILED_TO_SET_PRICE,
1784                     OracleFailureInfo.SET_PRICE_ZERO_PRICE
1785                 );
1786         }
1787 
1788         // BEGIN SIDE EFFECTS
1789 
1790         // Set pendingAnchor = Nothing
1791         // Pending anchor is only used once.
1792         if (pendingAnchors[_asset] != 0) {
1793             pendingAnchors[_asset] = 0;
1794         }
1795 
1796         // If currentPeriod > anchorPeriod:
1797         //  Set anchors[_asset] = (currentPeriod, price)
1798         //  The new anchor is if we're in a new period or we had a pending anchor, then we become the new anchor
1799         if (_localVars.currentPeriod > _localVars.anchorPeriod) {
1800             anchors[_asset] = Anchor({
1801                 period: _localVars.currentPeriod,
1802                 priceMantissa: _localVars.price.mantissa
1803             });
1804         }
1805 
1806         uint256 _previousPrice = _assetPrices[_asset].mantissa;
1807 
1808         setPriceStorageInternal(_asset, _localVars.price.mantissa);
1809 
1810         emit PricePosted(
1811             _asset,
1812             _previousPrice,
1813             _requestedPriceMantissa,
1814             _localVars.price.mantissa
1815         );
1816 
1817         if (_localVars.priceCapped) {
1818             // We have set a capped price. Log it so we can detect the situation and investigate.
1819             emit CappedPricePosted(
1820                 _asset,
1821                 _requestedPriceMantissa,
1822                 _localVars.cappingAnchorPriceMantissa,
1823                 _localVars.price.mantissa
1824             );
1825         }
1826 
1827         return uint256(OracleError.NO_ERROR);
1828     }
1829 
1830     // As a function to allow harness overrides
1831     function setPriceStorageInternal(address _asset, uint256 _priceMantissa)
1832         internal
1833     {
1834         _assetPrices[_asset] = Exp({ mantissa: _priceMantissa });
1835     }
1836 
1837     // abs(price - anchorPrice) / anchorPrice
1838     function calculateSwing(Exp memory _anchorPrice, Exp memory _price)
1839         internal
1840         pure
1841         returns (Error, Exp memory)
1842     {
1843         Exp memory numerator;
1844         Error err;
1845 
1846         if (greaterThanExp(_anchorPrice, _price)) {
1847             (err, numerator) = subExp(_anchorPrice, _price);
1848             // can't underflow
1849             assert(err == Error.NO_ERROR);
1850         } else {
1851             (err, numerator) = subExp(_price, _anchorPrice);
1852             // Given greaterThan check above, _price >= _anchorPrice so can't underflow.
1853             assert(err == Error.NO_ERROR);
1854         }
1855 
1856         return divExp(numerator, _anchorPrice);
1857     }
1858 
1859     // Base on the current anchor price, get the final valid price.
1860     function capToMax(
1861         Exp memory _anchorPrice,
1862         Exp memory _price,
1863         Exp memory _maxSwing
1864     )
1865         internal
1866         pure
1867         returns (
1868             Error,
1869             bool,
1870             Exp memory
1871         )
1872     {
1873         Exp memory one = Exp({ mantissa: mantissaOne });
1874         Exp memory onePlusMaxSwing;
1875         Exp memory oneMinusMaxSwing;
1876         Exp memory max;
1877         Exp memory min;
1878         // re-used for intermediate errors
1879         Error err;
1880 
1881         (err, onePlusMaxSwing) = addExp(one, _maxSwing);
1882         if (err != Error.NO_ERROR) {
1883             return (err, false, Exp({ mantissa: 0 }));
1884         }
1885 
1886         // max = _anchorPrice * (1 + _maxSwing)
1887         (err, max) = mulExp(_anchorPrice, onePlusMaxSwing);
1888         if (err != Error.NO_ERROR) {
1889             return (err, false, Exp({ mantissa: 0 }));
1890         }
1891 
1892         // If _price > _anchorPrice * (1 + _maxSwing)
1893         // Set _price = _anchorPrice * (1 + _maxSwing)
1894         if (greaterThanExp(_price, max)) {
1895             return (Error.NO_ERROR, true, max);
1896         }
1897 
1898         (err, oneMinusMaxSwing) = subExp(one, _maxSwing);
1899         if (err != Error.NO_ERROR) {
1900             return (err, false, Exp({ mantissa: 0 }));
1901         }
1902 
1903         // min = _anchorPrice * (1 - _maxSwing)
1904         (err, min) = mulExp(_anchorPrice, oneMinusMaxSwing);
1905         // We can't overflow here or we would have already overflowed above when calculating `max`
1906         assert(err == Error.NO_ERROR);
1907 
1908         // If  _price < _anchorPrice * (1 - _maxSwing)
1909         // Set _price = _anchorPrice * (1 - _maxSwing)
1910         if (lessThanExp(_price, min)) {
1911             return (Error.NO_ERROR, true, min);
1912         }
1913 
1914         return (Error.NO_ERROR, false, _price);
1915     }
1916 
1917     /**
1918      * @notice Entry point for updating multiple prices.
1919      * @dev Set prices for a variable number of assets.
1920      * @param _assets A list of up to assets for which to set a price.
1921      *        Notice: 0 < _assets.length == _requestedPriceMantissas.length
1922      * @param _requestedPriceMantissas Requested new prices for the assets, scaled by 10**18.
1923      *        Notice: 0 < _assets.length == _requestedPriceMantissas.length
1924      * @return Uint values in same order as inputs.
1925      *         For each: 0=success, otherwise a failure (see enum OracleError for details)
1926      */
1927     function setPrices(
1928         address[] memory _assets,
1929         uint256[] memory _requestedPriceMantissas
1930     ) external returns (uint256[] memory) {
1931         uint256 numAssets = _assets.length;
1932         uint256 numPrices = _requestedPriceMantissas.length;
1933         uint256[] memory result;
1934 
1935         // Fail when msg.sender is not poster
1936         if (msg.sender != poster) {
1937             result = new uint256[](1);
1938             result[0] = failOracle(
1939                 address(0),
1940                 OracleError.UNAUTHORIZED,
1941                 OracleFailureInfo.SET_PRICE_PERMISSION_CHECK
1942             );
1943             return result;
1944         }
1945 
1946         if ((numAssets == 0) || (numPrices != numAssets)) {
1947             result = new uint256[](1);
1948             result[0] = failOracle(
1949                 address(0),
1950                 OracleError.FAILED_TO_SET_PRICE,
1951                 OracleFailureInfo.SET_PRICES_PARAM_VALIDATION
1952             );
1953             return result;
1954         }
1955 
1956         result = new uint256[](numAssets);
1957 
1958         for (uint256 i = 0; i < numAssets; i++) {
1959             result[i] = setPriceInternal(_assets[i], _requestedPriceMantissas[i]);
1960         }
1961 
1962         return result;
1963     }
1964 }