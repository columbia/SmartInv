1 pragma solidity ^0.5.16;
2 
3 contract ErrorReporter {
4     /**
5      * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
6      * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
7      **/
8     event Failure(uint256 error, uint256 info, uint256 detail);
9 
10     enum Error {
11         NO_ERROR,
12         OPAQUE_ERROR, // To be used when reporting errors from upgradeable contracts; the opaque code should be given as `detail` in the `Failure` event
13         UNAUTHORIZED,
14         INTEGER_OVERFLOW,
15         INTEGER_UNDERFLOW,
16         DIVISION_BY_ZERO,
17         BAD_INPUT,
18         TOKEN_INSUFFICIENT_ALLOWANCE,
19         TOKEN_INSUFFICIENT_BALANCE,
20         TOKEN_TRANSFER_FAILED,
21         MARKET_NOT_SUPPORTED,
22         SUPPLY_RATE_CALCULATION_FAILED,
23         BORROW_RATE_CALCULATION_FAILED,
24         TOKEN_INSUFFICIENT_CASH,
25         TOKEN_TRANSFER_OUT_FAILED,
26         INSUFFICIENT_LIQUIDITY,
27         INSUFFICIENT_BALANCE,
28         INVALID_COLLATERAL_RATIO,
29         MISSING_ASSET_PRICE,
30         EQUITY_INSUFFICIENT_BALANCE,
31         INVALID_CLOSE_AMOUNT_REQUESTED,
32         ASSET_NOT_PRICED,
33         INVALID_LIQUIDATION_DISCOUNT,
34         INVALID_COMBINED_RISK_PARAMETERS
35     }
36 
37     /*
38      * Note: FailureInfo (but not Error) is kept in alphabetical order
39      *       This is because FailureInfo grows significantly faster, and
40      *       the order of Error has some meaning, while the order of FailureInfo
41      *       is entirely arbitrary.
42      */
43     enum FailureInfo {
44         BORROW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED,
45         BORROW_ACCOUNT_SHORTFALL_PRESENT,
46         BORROW_AMOUNT_LIQUIDITY_SHORTFALL,
47         BORROW_AMOUNT_VALUE_CALCULATION_FAILED,
48         BORROW_MARKET_NOT_SUPPORTED,
49         BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED,
50         BORROW_NEW_BORROW_RATE_CALCULATION_FAILED,
51         BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
52         BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
53         BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED,
54         BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED,
55         BORROW_ORIGINATION_FEE_CALCULATION_FAILED,
56         BORROW_TRANSFER_OUT_FAILED,
57         EQUITY_WITHDRAWAL_AMOUNT_VALIDATION,
58         EQUITY_WITHDRAWAL_CALCULATE_EQUITY,
59         EQUITY_WITHDRAWAL_MODEL_OWNER_CHECK,
60         EQUITY_WITHDRAWAL_TRANSFER_OUT_FAILED,
61         LIQUIDATE_ACCUMULATED_BORROW_BALANCE_CALCULATION_FAILED,
62         LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET,
63         LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET,
64         LIQUIDATE_AMOUNT_SEIZE_CALCULATION_FAILED,
65         LIQUIDATE_BORROW_DENOMINATED_COLLATERAL_CALCULATION_FAILED,
66         LIQUIDATE_CLOSE_AMOUNT_TOO_HIGH,
67         LIQUIDATE_DISCOUNTED_REPAY_TO_EVEN_AMOUNT_CALCULATION_FAILED,
68         LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_BORROWED_ASSET,
69         LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET,
70         LIQUIDATE_NEW_BORROW_RATE_CALCULATION_FAILED_BORROWED_ASSET,
71         LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_BORROWED_ASSET,
72         LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET,
73         LIQUIDATE_NEW_SUPPLY_RATE_CALCULATION_FAILED_BORROWED_ASSET,
74         LIQUIDATE_NEW_TOTAL_BORROW_CALCULATION_FAILED_BORROWED_ASSET,
75         LIQUIDATE_NEW_TOTAL_CASH_CALCULATION_FAILED_BORROWED_ASSET,
76         LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET,
77         LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET,
78         LIQUIDATE_TRANSFER_IN_FAILED,
79         LIQUIDATE_TRANSFER_IN_NOT_POSSIBLE,
80         REPAY_BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED,
81         REPAY_BORROW_NEW_BORROW_RATE_CALCULATION_FAILED,
82         REPAY_BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
83         REPAY_BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
84         REPAY_BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED,
85         REPAY_BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED,
86         REPAY_BORROW_TRANSFER_IN_FAILED,
87         REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE,
88         SET_ADMIN_OWNER_CHECK,
89         SET_ASSET_PRICE_CHECK_ORACLE,
90         SET_MARKET_INTEREST_RATE_MODEL_OWNER_CHECK,
91         SET_ORACLE_OWNER_CHECK,
92         SET_ORIGINATION_FEE_OWNER_CHECK,
93         SET_RISK_PARAMETERS_OWNER_CHECK,
94         SET_RISK_PARAMETERS_VALIDATION,
95         SUPPLY_ACCUMULATED_BALANCE_CALCULATION_FAILED,
96         SUPPLY_MARKET_NOT_SUPPORTED,
97         SUPPLY_NEW_BORROW_INDEX_CALCULATION_FAILED,
98         SUPPLY_NEW_BORROW_RATE_CALCULATION_FAILED,
99         SUPPLY_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
100         SUPPLY_NEW_SUPPLY_RATE_CALCULATION_FAILED,
101         SUPPLY_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
102         SUPPLY_NEW_TOTAL_CASH_CALCULATION_FAILED,
103         SUPPLY_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
104         SUPPLY_TRANSFER_IN_FAILED,
105         SUPPLY_TRANSFER_IN_NOT_POSSIBLE,
106         SUPPORT_MARKET_OWNER_CHECK,
107         SUPPORT_MARKET_PRICE_CHECK,
108         SUSPEND_MARKET_OWNER_CHECK,
109         WITHDRAW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED,
110         WITHDRAW_ACCOUNT_SHORTFALL_PRESENT,
111         WITHDRAW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
112         WITHDRAW_AMOUNT_LIQUIDITY_SHORTFALL,
113         WITHDRAW_AMOUNT_VALUE_CALCULATION_FAILED,
114         WITHDRAW_CAPACITY_CALCULATION_FAILED,
115         WITHDRAW_NEW_BORROW_INDEX_CALCULATION_FAILED,
116         WITHDRAW_NEW_BORROW_RATE_CALCULATION_FAILED,
117         WITHDRAW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
118         WITHDRAW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
119         WITHDRAW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
120         WITHDRAW_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
121         WITHDRAW_TRANSFER_OUT_FAILED,
122         WITHDRAW_TRANSFER_OUT_NOT_POSSIBLE
123     }
124 
125     /**
126      * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
127      */
128     function fail(Error err, FailureInfo info) internal returns (uint256) {
129         emit Failure(uint256(err), uint256(info), 0);
130 
131         return uint256(err);
132     }
133 
134     /**
135      * @dev use this when reporting an opaque error from an upgradeable collaborator contract
136      */
137     function failOpaque(FailureInfo info, uint256 opaqueError) internal returns (uint256) {
138         emit Failure(uint256(Error.OPAQUE_ERROR), uint256(info), opaqueError);
139 
140         return uint256(Error.OPAQUE_ERROR);
141     }
142 }
143 
144 contract CarefulMath is ErrorReporter {
145     /**
146      * @dev Multiplies two numbers, returns an error on overflow.
147      */
148     function mul(uint256 a, uint256 b) internal pure returns (Error, uint256) {
149         if (a == 0) {
150             return (Error.NO_ERROR, 0);
151         }
152 
153         uint256 c = a * b;
154 
155         if (c / a != b) {
156             return (Error.INTEGER_OVERFLOW, 0);
157         } else {
158             return (Error.NO_ERROR, c);
159         }
160     }
161 
162     /**
163      * @dev Integer division of two numbers, truncating the quotient.
164      */
165     function div(uint256 a, uint256 b) internal pure returns (Error, uint256) {
166         if (b == 0) {
167             return (Error.DIVISION_BY_ZERO, 0);
168         }
169 
170         return (Error.NO_ERROR, a / b);
171     }
172 
173     /**
174      * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
175      */
176     function sub(uint256 a, uint256 b) internal pure returns (Error, uint256) {
177         if (b <= a) {
178             return (Error.NO_ERROR, a - b);
179         } else {
180             return (Error.INTEGER_UNDERFLOW, 0);
181         }
182     }
183 
184     /**
185      * @dev Adds two numbers, returns an error on overflow.
186      */
187     function add(uint256 a, uint256 b) internal pure returns (Error, uint256) {
188         uint256 c = a + b;
189 
190         if (c >= a) {
191             return (Error.NO_ERROR, c);
192         } else {
193             return (Error.INTEGER_OVERFLOW, 0);
194         }
195     }
196 
197     /**
198      * @dev add a and b and then subtract c
199      */
200     function addThenSub(
201         uint256 a,
202         uint256 b,
203         uint256 c
204     ) internal pure returns (Error, uint256) {
205         (Error err0, uint256 sum) = add(a, b);
206 
207         if (err0 != Error.NO_ERROR) {
208             return (err0, 0);
209         }
210 
211         return sub(sum, c);
212     }
213 }
214 
215 contract Exponential is ErrorReporter, CarefulMath {
216     // TODO: We may wish to put the result of 10**18 here instead of the expression.
217     // Per https://solidity.readthedocs.io/en/latest/contracts.html#constant-state-variables
218     // the optimizer MAY replace the expression 10**18 with its calculated value.
219     uint256 constant expScale = 10**18;
220 
221     // See TODO on expScale
222     uint256 constant halfExpScale = expScale / 2;
223 
224     struct Exp {
225         uint256 mantissa;
226     }
227 
228     uint256 constant mantissaOne = 10**18;
229     uint256 constant mantissaOneTenth = 10**17;
230 
231     /**
232      * @dev Creates an exponential from numerator and denominator values.
233      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
234      *            or if `denom` is zero.
235      */
236     function getExp(uint256 num, uint256 denom) internal pure returns (Error, Exp memory) {
237         (Error err0, uint256 scaledNumerator) = mul(num, expScale);
238         if (err0 != Error.NO_ERROR) {
239             return (err0, Exp({mantissa: 0}));
240         }
241 
242         (Error err1, uint256 rational) = div(scaledNumerator, denom);
243         if (err1 != Error.NO_ERROR) {
244             return (err1, Exp({mantissa: 0}));
245         }
246 
247         return (Error.NO_ERROR, Exp({mantissa: rational}));
248     }
249 
250     /**
251      * @dev Adds two exponentials, returning a new exponential.
252      */
253     function addExp(Exp memory a, Exp memory b) internal pure returns (Error, Exp memory) {
254         (Error error, uint256 result) = add(a.mantissa, b.mantissa);
255 
256         return (error, Exp({mantissa: result}));
257     }
258 
259     /**
260      * @dev Subtracts two exponentials, returning a new exponential.
261      */
262     function subExp(Exp memory a, Exp memory b) internal pure returns (Error, Exp memory) {
263         (Error error, uint256 result) = sub(a.mantissa, b.mantissa);
264 
265         return (error, Exp({mantissa: result}));
266     }
267 
268     /**
269      * @dev Multiply an Exp by a scalar, returning a new Exp.
270      */
271     function mulScalar(Exp memory a, uint256 scalar) internal pure returns (Error, Exp memory) {
272         (Error err0, uint256 scaledMantissa) = mul(a.mantissa, scalar);
273         if (err0 != Error.NO_ERROR) {
274             return (err0, Exp({mantissa: 0}));
275         }
276 
277         return (Error.NO_ERROR, Exp({mantissa: scaledMantissa}));
278     }
279 
280     /**
281      * @dev Divide an Exp by a scalar, returning a new Exp.
282      */
283     function divScalar(Exp memory a, uint256 scalar) internal pure returns (Error, Exp memory) {
284         (Error err0, uint256 descaledMantissa) = div(a.mantissa, scalar);
285         if (err0 != Error.NO_ERROR) {
286             return (err0, Exp({mantissa: 0}));
287         }
288 
289         return (Error.NO_ERROR, Exp({mantissa: descaledMantissa}));
290     }
291 
292     /**
293      * @dev Divide a scalar by an Exp, returning a new Exp.
294      */
295     function divScalarByExp(uint256 scalar, Exp memory divisor) internal pure returns (Error, Exp memory) {
296         /*
297             We are doing this as:
298             getExp(mul(expScale, scalar), divisor.mantissa)
299 
300             How it works:
301             Exp = a / b;
302             Scalar = s;
303             `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
304         */
305         (Error err0, uint256 numerator) = mul(expScale, scalar);
306         if (err0 != Error.NO_ERROR) {
307             return (err0, Exp({mantissa: 0}));
308         }
309         return getExp(numerator, divisor.mantissa);
310     }
311 
312     /**
313      * @dev Multiplies two exponentials, returning a new exponential.
314      */
315     function mulExp(Exp memory a, Exp memory b) internal pure returns (Error, Exp memory) {
316         (Error err0, uint256 doubleScaledProduct) = mul(a.mantissa, b.mantissa);
317         if (err0 != Error.NO_ERROR) {
318             return (err0, Exp({mantissa: 0}));
319         }
320 
321         // We add half the scale before dividing so that we get rounding instead of truncation.
322         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
323         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
324         (Error err1, uint256 doubleScaledProductWithHalfScale) = add(halfExpScale, doubleScaledProduct);
325         if (err1 != Error.NO_ERROR) {
326             return (err1, Exp({mantissa: 0}));
327         }
328 
329         (Error err2, uint256 product) = div(doubleScaledProductWithHalfScale, expScale);
330         // The only error `div` can return is Error.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
331         assert(err2 == Error.NO_ERROR);
332 
333         return (Error.NO_ERROR, Exp({mantissa: product}));
334     }
335 
336     /**
337      * @dev Divides two exponentials, returning a new exponential.
338      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
339      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
340      */
341     function divExp(Exp memory a, Exp memory b) internal pure returns (Error, Exp memory) {
342         return getExp(a.mantissa, b.mantissa);
343     }
344 
345     /**
346      * @dev Truncates the given exp to a whole number value.
347      *      For example, truncate(Exp{mantissa: 15 * (10**18)}) = 15
348      */
349     function truncate(Exp memory exp) internal pure returns (uint256) {
350         // Note: We are not using careful math here as we're performing a division that cannot fail
351         return exp.mantissa / 10**18;
352     }
353 
354     /**
355      * @dev Checks if first Exp is less than second Exp.
356      */
357     function lessThanExp(Exp memory left, Exp memory right) internal pure returns (bool) {
358         return left.mantissa < right.mantissa; //TODO: Add some simple tests and this in another PR yo.
359     }
360 
361     /**
362      * @dev Checks if left Exp <= right Exp.
363      */
364     function lessThanOrEqualExp(Exp memory left, Exp memory right) internal pure returns (bool) {
365         return left.mantissa <= right.mantissa;
366     }
367 
368     /**
369      * @dev Checks if first Exp is greater than second Exp.
370      */
371     function greaterThanExp(Exp memory left, Exp memory right) internal pure returns (bool) {
372         return left.mantissa > right.mantissa;
373     }
374 
375     /**
376      * @dev returns true if Exp is exactly zero
377      */
378     function isZeroExp(Exp memory value) internal pure returns (bool) {
379         return value.mantissa == 0;
380     }
381 }
382 
383 contract PriceOracle is Exponential {
384     /**
385      * @dev flag for whether or not contract is paused
386      *
387      */
388     bool public paused;
389 
390     uint256 public constant numBlocksPerPeriod = 240; // approximately 1 hour: 60 seconds/minute * 60 minutes/hour * 1 block/15 seconds
391 
392     uint256 public constant maxSwingMantissa = (10**17); // 0.1
393 
394     /**
395      * @dev Mapping of asset addresses and their corresponding price in terms of Eth-Wei
396      *      which is simply equal to AssetWeiPrice * 10e18. For instance, if OMG token was
397      *      worth 5x Eth then the price for OMG would be 5*10e18 or Exp({mantissa: 5000000000000000000}).
398      * map: assetAddress -> Exp
399      */
400     mapping(address => Exp) public _assetPrices;
401 
402     constructor(address _poster) public {
403         anchorAdmin = msg.sender;
404         poster = _poster;
405         maxSwing = Exp({mantissa: maxSwingMantissa});
406     }
407 
408     /**
409      * @notice Do not pay into PriceOracle
410      */
411     function() external payable {
412         revert();
413     }
414 
415     enum OracleError {
416         NO_ERROR,
417         UNAUTHORIZED,
418         FAILED_TO_SET_PRICE
419     }
420 
421     enum OracleFailureInfo {
422         ACCEPT_ANCHOR_ADMIN_PENDING_ANCHOR_ADMIN_CHECK,
423         SET_PAUSED_OWNER_CHECK,
424         SET_PENDING_ANCHOR_ADMIN_OWNER_CHECK,
425         SET_PENDING_ANCHOR_PERMISSION_CHECK,
426         SET_PRICE_CALCULATE_SWING,
427         SET_PRICE_CAP_TO_MAX,
428         SET_PRICE_MAX_SWING_CHECK,
429         SET_PRICE_NO_ANCHOR_PRICE_OR_INITIAL_PRICE_ZERO,
430         SET_PRICE_PERMISSION_CHECK,
431         SET_PRICE_ZERO_PRICE,
432         SET_PRICES_PARAM_VALIDATION
433     }
434 
435     /**
436      * @dev `msgSender` is msg.sender; `error` corresponds to enum OracleError; `info` corresponds to enum OracleFailureInfo, and `detail` is an arbitrary
437      * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
438      **/
439     event OracleFailure(address msgSender, address asset, uint256 error, uint256 info, uint256 detail);
440 
441     /**
442      * @dev use this when reporting a known error from the price oracle or a non-upgradeable collaborator
443      *      Using Oracle in name because we already inherit a `fail` function from ErrorReporter.sol via Exponential.sol
444      */
445     function failOracle(
446         address asset,
447         OracleError err,
448         OracleFailureInfo info
449     ) internal returns (uint256) {
450         emit OracleFailure(msg.sender, asset, uint256(err), uint256(info), 0);
451 
452         return uint256(err);
453     }
454 
455     /**
456      * @dev Use this when reporting an error from the money market. Give the money market result as `details`
457      */
458     function failOracleWithDetails(
459         address asset,
460         OracleError err,
461         OracleFailureInfo info,
462         uint256 details
463     ) internal returns (uint256) {
464         emit OracleFailure(msg.sender, asset, uint256(err), uint256(info), details);
465 
466         return uint256(err);
467     }
468 
469     /**
470      * @dev An administrator who can set the pending anchor value for assets.
471      *      Set in the constructor.
472      */
473     address public anchorAdmin;
474 
475     /**
476      * @dev pending anchor administrator for this contract.
477      */
478     address public pendingAnchorAdmin;
479 
480     /**
481      * @dev Address of the price poster.
482      *      Set in the constructor.
483      */
484     address public poster;
485 
486     /**
487      * @dev maxSwing the maximum allowed percentage difference between a new price and the anchor's price
488      *      Set only in the constructor
489      */
490     Exp public maxSwing;
491 
492     struct Anchor {
493         // floor(block.number / numBlocksPerPeriod) + 1
494         uint256 period;
495         // Price in ETH, scaled by 10**18
496         uint256 priceMantissa;
497     }
498 
499     /**
500      * @dev anchors by asset
501      */
502     mapping(address => Anchor) public anchors;
503 
504     /**
505      * @dev pending anchor prices by asset
506      */
507     mapping(address => uint256) public pendingAnchors;
508 
509     /**
510      * @dev emitted when a pending anchor is set
511      * @param asset Asset for which to set a pending anchor
512      * @param oldScaledPrice if an unused pending anchor was present, its value; otherwise 0.
513      * @param newScaledPrice the new scaled pending anchor price
514      */
515     event NewPendingAnchor(address anchorAdmin, address asset, uint256 oldScaledPrice, uint256 newScaledPrice);
516 
517     /**
518      * @notice provides ability to override the anchor price for an asset
519      * @dev Admin function to set the anchor price for an asset
520      * @param asset Asset for which to override the anchor price
521      * @param newScaledPrice New anchor price
522      * @return uint 0=success, otherwise a failure (see enum OracleError for details)
523      */
524     function _setPendingAnchor(address asset, uint256 newScaledPrice) public returns (uint256) {
525         // Check caller = anchorAdmin. Note: Deliberately not allowing admin. They can just change anchorAdmin if desired.
526         if (msg.sender != anchorAdmin) {
527             return failOracle(asset, OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PENDING_ANCHOR_PERMISSION_CHECK);
528         }
529 
530         uint256 oldScaledPrice = pendingAnchors[asset];
531         pendingAnchors[asset] = newScaledPrice;
532 
533         emit NewPendingAnchor(msg.sender, asset, oldScaledPrice, newScaledPrice);
534 
535         return uint256(OracleError.NO_ERROR);
536     }
537 
538     /**
539      * @dev emitted for all price changes
540      */
541     event PricePosted(
542         address asset,
543         uint256 previousPriceMantissa,
544         uint256 requestedPriceMantissa,
545         uint256 newPriceMantissa
546     );
547 
548     /**
549      * @dev emitted if this contract successfully posts a capped-to-max price to the money market
550      */
551     event CappedPricePosted(
552         address asset,
553         uint256 requestedPriceMantissa,
554         uint256 anchorPriceMantissa,
555         uint256 cappedPriceMantissa
556     );
557 
558     /**
559      * @dev emitted when admin either pauses or resumes the contract; newState is the resulting state
560      */
561     event SetPaused(bool newState);
562 
563     /**
564      * @dev emitted when pendingAnchorAdmin is changed
565      */
566     event NewPendingAnchorAdmin(address oldPendingAnchorAdmin, address newPendingAnchorAdmin);
567 
568     /**
569      * @dev emitted when pendingAnchorAdmin is accepted, which means anchor admin is updated
570      */
571     event NewAnchorAdmin(address oldAnchorAdmin, address newAnchorAdmin);
572 
573     /**
574      * @notice set `paused` to the specified state
575      * @dev Admin function to pause or resume the market
576      * @param requestedState value to assign to `paused`
577      * @return uint 0=success, otherwise a failure
578      */
579     function _setPaused(bool requestedState) public returns (uint256) {
580         // Check caller = anchorAdmin
581         if (msg.sender != anchorAdmin) {
582             return failOracle(address(0), OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PAUSED_OWNER_CHECK);
583         }
584 
585         paused = requestedState;
586         emit SetPaused(requestedState);
587 
588         return uint256(Error.NO_ERROR);
589     }
590 
591     /**
592      * @notice Begins transfer of anchor admin rights. The newPendingAnchorAdmin must call `_acceptAnchorAdmin` to finalize the transfer.
593      * @dev Admin function to begin change of anchor admin. The newPendingAnchorAdmin must call `_acceptAnchorAdmin` to finalize the transfer.
594      * @param newPendingAnchorAdmin New pending anchor admin.
595      * @return uint 0=success, otherwise a failure
596      *
597      * TODO: Should we add a second arg to verify, like a checksum of `newAnchorAdmin` address?
598      */
599     function _setPendingAnchorAdmin(address newPendingAnchorAdmin) public returns (uint256) {
600         // Check caller = anchorAdmin
601         if (msg.sender != anchorAdmin) {
602             return
603                 failOracle(
604                     address(0),
605                     OracleError.UNAUTHORIZED,
606                     OracleFailureInfo.SET_PENDING_ANCHOR_ADMIN_OWNER_CHECK
607                 );
608         }
609 
610         // save current value, if any, for inclusion in log
611         address oldPendingAnchorAdmin = pendingAnchorAdmin;
612         // Store pendingAdmin = newPendingAdmin
613         pendingAnchorAdmin = newPendingAnchorAdmin;
614 
615         emit NewPendingAnchorAdmin(oldPendingAnchorAdmin, newPendingAnchorAdmin);
616 
617         return uint256(Error.NO_ERROR);
618     }
619 
620     /**
621      * @notice Accepts transfer of anchor admin rights. msg.sender must be pendingAnchorAdmin
622      * @dev Admin function for pending anchor admin to accept role and update anchor admin
623      * @return uint 0=success, otherwise a failure
624      */
625     function _acceptAnchorAdmin() public returns (uint256) {
626         // Check caller = pendingAnchorAdmin
627         // msg.sender can't be zero
628         if (msg.sender != pendingAnchorAdmin) {
629             return
630                 failOracle(
631                     address(0),
632                     OracleError.UNAUTHORIZED,
633                     OracleFailureInfo.ACCEPT_ANCHOR_ADMIN_PENDING_ANCHOR_ADMIN_CHECK
634                 );
635         }
636 
637         // Save current value for inclusion in log
638         address oldAnchorAdmin = anchorAdmin;
639         // Store admin = pendingAnchorAdmin
640         anchorAdmin = pendingAnchorAdmin;
641         // Clear the pending value
642         pendingAnchorAdmin = address(0);
643 
644         emit NewAnchorAdmin(oldAnchorAdmin, msg.sender);
645 
646         return uint256(Error.NO_ERROR);
647     }
648 
649     /**
650      * @notice retrieves price of an asset
651      * @dev function to get price for an asset
652      * @param asset Asset for which to get the price
653      * @return uint mantissa of asset price (scaled by 1e18) or zero if unset or contract paused
654      */
655     function assetPrices(address asset) public view returns (uint256) {
656         // Note: zero is treated by the money market as an invalid
657         //       price and will cease operations with that asset
658         //       when zero.
659         //
660         // We get the price as:
661         //
662         //  1. If the contract is paused, return 0.
663         //  2. Return price in `_assetPrices`, which may be zero.
664 
665         if (paused) {
666             return 0;
667         }
668         return _assetPrices[asset].mantissa;
669     }
670 
671     /**
672      * @notice retrieves price of an asset
673      * @dev function to get price for an asset
674      * @param asset Asset for which to get the price
675      * @return uint mantissa of asset price (scaled by 1e18) or zero if unset or contract paused
676      */
677     function getPrice(address asset) public view returns (uint256) {
678         return assetPrices(asset);
679     }
680 
681     struct SetPriceLocalVars {
682         Exp price;
683         Exp swing;
684         Exp anchorPrice;
685         uint256 anchorPeriod;
686         uint256 currentPeriod;
687         bool priceCapped;
688         uint256 cappingAnchorPriceMantissa;
689         uint256 pendingAnchorMantissa;
690     }
691 
692     /**
693      * @notice entry point for updating prices
694      * @dev function to set price for an asset
695      * @param asset Asset for which to set the price
696      * @param requestedPriceMantissa requested new price, scaled by 10**18
697      * @return uint 0=success, otherwise a failure (see enum OracleError for details)
698      */
699     function setPrice(address asset, uint256 requestedPriceMantissa) public returns (uint256) {
700         // Fail when msg.sender is not poster
701         if (msg.sender != poster) {
702             return failOracle(asset, OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PRICE_PERMISSION_CHECK);
703         }
704 
705         return setPriceInternal(asset, requestedPriceMantissa);
706     }
707 
708     function setPriceInternal(address asset, uint256 requestedPriceMantissa) internal returns (uint256) {
709         // re-used for intermediate errors
710         Error err;
711         SetPriceLocalVars memory localVars;
712         // We add 1 for currentPeriod so that it can never be zero and there's no ambiguity about an unset value.
713         // (It can be a problem in tests with low block numbers.)
714         localVars.currentPeriod = (block.number / numBlocksPerPeriod) + 1;
715         localVars.pendingAnchorMantissa = pendingAnchors[asset];
716         localVars.price = Exp({mantissa: requestedPriceMantissa});
717 
718         if (localVars.pendingAnchorMantissa != 0) {
719             // let's explicitly set to 0 rather than relying on default of declaration
720             localVars.anchorPeriod = 0;
721             localVars.anchorPrice = Exp({mantissa: localVars.pendingAnchorMantissa});
722 
723             // Verify movement is within max swing of pending anchor (currently: 10%)
724             (err, localVars.swing) = calculateSwing(localVars.anchorPrice, localVars.price);
725             if (err != Error.NO_ERROR) {
726                 return
727                     failOracleWithDetails(
728                         asset,
729                         OracleError.FAILED_TO_SET_PRICE,
730                         OracleFailureInfo.SET_PRICE_CALCULATE_SWING,
731                         uint256(err)
732                     );
733             }
734 
735             // Fail when swing > maxSwing
736             if (greaterThanExp(localVars.swing, maxSwing)) {
737                 return
738                     failOracleWithDetails(
739                         asset,
740                         OracleError.FAILED_TO_SET_PRICE,
741                         OracleFailureInfo.SET_PRICE_MAX_SWING_CHECK,
742                         localVars.swing.mantissa
743                     );
744             }
745         } else {
746             localVars.anchorPeriod = anchors[asset].period;
747             localVars.anchorPrice = Exp({mantissa: anchors[asset].priceMantissa});
748 
749             if (localVars.anchorPeriod != 0) {
750                 (err, localVars.priceCapped, localVars.price) = capToMax(localVars.anchorPrice, localVars.price);
751                 if (err != Error.NO_ERROR) {
752                     return
753                         failOracleWithDetails(
754                             asset,
755                             OracleError.FAILED_TO_SET_PRICE,
756                             OracleFailureInfo.SET_PRICE_CAP_TO_MAX,
757                             uint256(err)
758                         );
759                 }
760                 if (localVars.priceCapped) {
761                     // save for use in log
762                     localVars.cappingAnchorPriceMantissa = localVars.anchorPrice.mantissa;
763                 }
764             } else {
765                 // Setting first price. Accept as is (already assigned above from requestedPriceMantissa) and use as anchor
766                 localVars.anchorPrice = Exp({mantissa: requestedPriceMantissa});
767             }
768         }
769 
770         // Fail if anchorPrice or price is zero.
771         // zero anchor represents an unexpected situation likely due to a problem in this contract
772         // zero price is more likely as the result of bad input from the caller of this function
773         if (isZeroExp(localVars.anchorPrice)) {
774             // If we get here price could also be zero, but it does not seem worthwhile to distinguish the 3rd case
775             return
776                 failOracle(
777                     asset,
778                     OracleError.FAILED_TO_SET_PRICE,
779                     OracleFailureInfo.SET_PRICE_NO_ANCHOR_PRICE_OR_INITIAL_PRICE_ZERO
780                 );
781         }
782 
783         if (isZeroExp(localVars.price)) {
784             return failOracle(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_ZERO_PRICE);
785         }
786 
787         // BEGIN SIDE EFFECTS
788 
789         // Set pendingAnchor = Nothing
790         // Pending anchor is only used once.
791         if (pendingAnchors[asset] != 0) {
792             pendingAnchors[asset] = 0;
793         }
794 
795         // If currentPeriod > anchorPeriod:
796         //  Set anchors[asset] = (currentPeriod, price)
797         //  The new anchor is if we're in a new period or we had a pending anchor, then we become the new anchor
798         if (localVars.currentPeriod > localVars.anchorPeriod) {
799             anchors[asset] = Anchor({period: localVars.currentPeriod, priceMantissa: localVars.price.mantissa});
800         }
801 
802         uint256 previousPrice = _assetPrices[asset].mantissa;
803 
804         setPriceStorageInternal(asset, localVars.price.mantissa);
805 
806         emit PricePosted(asset, previousPrice, requestedPriceMantissa, localVars.price.mantissa);
807 
808         if (localVars.priceCapped) {
809             // We have set a capped price. Log it so we can detect the situation and investigate.
810             emit CappedPricePosted(
811                 asset,
812                 requestedPriceMantissa,
813                 localVars.cappingAnchorPriceMantissa,
814                 localVars.price.mantissa
815             );
816         }
817 
818         return uint256(OracleError.NO_ERROR);
819     }
820 
821     // As a function to allow harness overrides
822     function setPriceStorageInternal(address asset, uint256 priceMantissa) internal {
823         _assetPrices[asset] = Exp({mantissa: priceMantissa});
824     }
825 
826     // abs(price - anchorPrice) / anchorPrice
827     function calculateSwing(Exp memory anchorPrice, Exp memory price) internal pure returns (Error, Exp memory) {
828         Exp memory numerator;
829         Error err;
830 
831         if (greaterThanExp(anchorPrice, price)) {
832             (err, numerator) = subExp(anchorPrice, price);
833             // can't underflow
834             assert(err == Error.NO_ERROR);
835         } else {
836             (err, numerator) = subExp(price, anchorPrice);
837             // Given greaterThan check above, price >= anchorPrice so can't underflow.
838             assert(err == Error.NO_ERROR);
839         }
840 
841         return divExp(numerator, anchorPrice);
842     }
843 
844     function capToMax(Exp memory anchorPrice, Exp memory price)
845         internal
846         view
847         returns (
848             Error,
849             bool,
850             Exp memory
851         )
852     {
853         Exp memory one = Exp({mantissa: mantissaOne});
854         Exp memory onePlusMaxSwing;
855         Exp memory oneMinusMaxSwing;
856         Exp memory max;
857         Exp memory min;
858         // re-used for intermediate errors
859         Error err;
860 
861         (err, onePlusMaxSwing) = addExp(one, maxSwing);
862         if (err != Error.NO_ERROR) {
863             return (err, false, Exp({mantissa: 0}));
864         }
865 
866         // max = anchorPrice * (1 + maxSwing)
867         (err, max) = mulExp(anchorPrice, onePlusMaxSwing);
868         if (err != Error.NO_ERROR) {
869             return (err, false, Exp({mantissa: 0}));
870         }
871 
872         // If price > anchorPrice * (1 + maxSwing)
873         // Set price = anchorPrice * (1 + maxSwing)
874         if (greaterThanExp(price, max)) {
875             return (Error.NO_ERROR, true, max);
876         }
877 
878         (err, oneMinusMaxSwing) = subExp(one, maxSwing);
879         if (err != Error.NO_ERROR) {
880             return (err, false, Exp({mantissa: 0}));
881         }
882 
883         // min = anchorPrice * (1 - maxSwing)
884         (err, min) = mulExp(anchorPrice, oneMinusMaxSwing);
885         // We can't overflow here or we would have already overflowed above when calculating `max`
886         assert(err == Error.NO_ERROR);
887 
888         // If  price < anchorPrice * (1 - maxSwing)
889         // Set price = anchorPrice * (1 - maxSwing)
890         if (lessThanExp(price, min)) {
891             return (Error.NO_ERROR, true, min);
892         }
893 
894         return (Error.NO_ERROR, false, price);
895     }
896 
897     /**
898      * @notice entry point for updating multiple prices
899      * @dev function to set prices for a variable number of assets.
900      * @param assets a list of up to assets for which to set a price. required: 0 < assets.length == requestedPriceMantissas.length
901      * @param requestedPriceMantissas requested new prices for the assets, scaled by 10**18. required: 0 < assets.length == requestedPriceMantissas.length
902      * @return uint values in same order as inputs. For each: 0=success, otherwise a failure (see enum OracleError for details)
903      */
904     function setPrices(address[] memory assets, uint256[] memory requestedPriceMantissas)
905         public
906         returns (uint256[] memory)
907     {
908         uint256 numAssets = assets.length;
909         uint256 numPrices = requestedPriceMantissas.length;
910         uint256[] memory result;
911 
912         // Fail when msg.sender is not poster
913         if (msg.sender != poster) {
914             result = new uint256[](1);
915             result[0] = failOracle(address(0), OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PRICE_PERMISSION_CHECK);
916             return result;
917         }
918 
919         if ((numAssets == 0) || (numPrices != numAssets)) {
920             result = new uint256[](1);
921             result[0] = failOracle(
922                 address(0),
923                 OracleError.FAILED_TO_SET_PRICE,
924                 OracleFailureInfo.SET_PRICES_PARAM_VALIDATION
925             );
926             return result;
927         }
928 
929         result = new uint256[](numAssets);
930 
931         for (uint256 i = 0; i < numAssets; i++) {
932             result[i] = setPriceInternal(assets[i], requestedPriceMantissas[i]);
933         }
934 
935         return result;
936     }
937 }
