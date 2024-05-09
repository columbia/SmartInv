1 pragma solidity ^0.4.24;
2 contract ErrorReporter {
3 
4     /**
5       * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
6       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
7       **/
8     event Failure(uint error, uint info, uint detail);
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
46         BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
47         BORROW_AMOUNT_LIQUIDITY_SHORTFALL,
48         BORROW_AMOUNT_VALUE_CALCULATION_FAILED,
49         BORROW_MARKET_NOT_SUPPORTED,
50         BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED,
51         BORROW_NEW_BORROW_RATE_CALCULATION_FAILED,
52         BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
53         BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
54         BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
55         BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED,
56         BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED,
57         BORROW_ORIGINATION_FEE_CALCULATION_FAILED,
58         BORROW_TRANSFER_OUT_FAILED,
59         EQUITY_WITHDRAWAL_AMOUNT_VALIDATION,
60         EQUITY_WITHDRAWAL_CALCULATE_EQUITY,
61         EQUITY_WITHDRAWAL_MODEL_OWNER_CHECK,
62         EQUITY_WITHDRAWAL_TRANSFER_OUT_FAILED,
63         LIQUIDATE_ACCUMULATED_BORROW_BALANCE_CALCULATION_FAILED,
64         LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET,
65         LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET,
66         LIQUIDATE_AMOUNT_SEIZE_CALCULATION_FAILED,
67         LIQUIDATE_BORROW_DENOMINATED_COLLATERAL_CALCULATION_FAILED,
68         LIQUIDATE_CLOSE_AMOUNT_TOO_HIGH,
69         LIQUIDATE_DISCOUNTED_REPAY_TO_EVEN_AMOUNT_CALCULATION_FAILED,
70         LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_BORROWED_ASSET,
71         LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET,
72         LIQUIDATE_NEW_BORROW_RATE_CALCULATION_FAILED_BORROWED_ASSET,
73         LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_BORROWED_ASSET,
74         LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET,
75         LIQUIDATE_NEW_SUPPLY_RATE_CALCULATION_FAILED_BORROWED_ASSET,
76         LIQUIDATE_NEW_TOTAL_BORROW_CALCULATION_FAILED_BORROWED_ASSET,
77         LIQUIDATE_NEW_TOTAL_CASH_CALCULATION_FAILED_BORROWED_ASSET,
78         LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET,
79         LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET,
80         LIQUIDATE_TRANSFER_IN_FAILED,
81         LIQUIDATE_TRANSFER_IN_NOT_POSSIBLE,
82         REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
83         REPAY_BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED,
84         REPAY_BORROW_NEW_BORROW_RATE_CALCULATION_FAILED,
85         REPAY_BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
86         REPAY_BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
87         REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
88         REPAY_BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED,
89         REPAY_BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED,
90         REPAY_BORROW_TRANSFER_IN_FAILED,
91         REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE,
92         SET_ADMIN_OWNER_CHECK,
93         SET_ASSET_PRICE_CHECK_ORACLE,
94         SET_MARKET_INTEREST_RATE_MODEL_OWNER_CHECK,
95         SET_ORACLE_OWNER_CHECK,
96         SET_ORIGINATION_FEE_OWNER_CHECK,
97         SET_RISK_PARAMETERS_OWNER_CHECK,
98         SET_RISK_PARAMETERS_VALIDATION,
99         SUPPLY_ACCUMULATED_BALANCE_CALCULATION_FAILED,
100         SUPPLY_MARKET_NOT_SUPPORTED,
101         SUPPLY_NEW_BORROW_INDEX_CALCULATION_FAILED,
102         SUPPLY_NEW_BORROW_RATE_CALCULATION_FAILED,
103         SUPPLY_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
104         SUPPLY_NEW_SUPPLY_RATE_CALCULATION_FAILED,
105         SUPPLY_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
106         SUPPLY_NEW_TOTAL_CASH_CALCULATION_FAILED,
107         SUPPLY_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
108         SUPPLY_TRANSFER_IN_FAILED,
109         SUPPLY_TRANSFER_IN_NOT_POSSIBLE,
110         SUPPORT_MARKET_OWNER_CHECK,
111         SUPPORT_MARKET_PRICE_CHECK,
112         SUSPEND_MARKET_OWNER_CHECK,
113         WITHDRAW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED,
114         WITHDRAW_ACCOUNT_SHORTFALL_PRESENT,
115         WITHDRAW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
116         WITHDRAW_AMOUNT_LIQUIDITY_SHORTFALL,
117         WITHDRAW_AMOUNT_VALUE_CALCULATION_FAILED,
118         WITHDRAW_CAPACITY_CALCULATION_FAILED,
119         WITHDRAW_NEW_BORROW_INDEX_CALCULATION_FAILED,
120         WITHDRAW_NEW_BORROW_RATE_CALCULATION_FAILED,
121         WITHDRAW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
122         WITHDRAW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
123         WITHDRAW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
124         WITHDRAW_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
125         WITHDRAW_TRANSFER_OUT_FAILED,
126         WITHDRAW_TRANSFER_OUT_NOT_POSSIBLE
127     }
128 
129 
130     /**
131       * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
132       */
133     function fail(Error err, FailureInfo info) internal returns (uint) {
134         emit Failure(uint(err), uint(info), 0);
135 
136         return uint(err);
137     }
138 
139 
140     /**
141       * @dev use this when reporting an opaque error from an upgradeable collaborator contract
142       */
143     function failOpaque(FailureInfo info, uint opaqueError) internal returns (uint) {
144         emit Failure(uint(Error.OPAQUE_ERROR), uint(info), opaqueError);
145 
146         return uint(Error.OPAQUE_ERROR);
147     }
148 
149 }
150 contract CarefulMath is ErrorReporter {
151 
152     /**
153     * @dev Multiplies two numbers, returns an error on overflow.
154     */
155     function mul(uint a, uint b) internal pure returns (Error, uint) {
156         if (a == 0) {
157             return (Error.NO_ERROR, 0);
158         }
159 
160         uint c = a * b;
161 
162         if (c / a != b) {
163             return (Error.INTEGER_OVERFLOW, 0);
164         } else {
165             return (Error.NO_ERROR, c);
166         }
167     }
168 
169     /**
170     * @dev Integer division of two numbers, truncating the quotient.
171     */
172     function div(uint a, uint b) internal pure returns (Error, uint) {
173         if (b == 0) {
174             return (Error.DIVISION_BY_ZERO, 0);
175         }
176 
177         return (Error.NO_ERROR, a / b);
178     }
179 
180     /**
181     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
182     */
183     function sub(uint a, uint b) internal pure returns (Error, uint) {
184         if (b <= a) {
185             return (Error.NO_ERROR, a - b);
186         } else {
187             return (Error.INTEGER_UNDERFLOW, 0);
188         }
189     }
190 
191     /**
192     * @dev Adds two numbers, returns an error on overflow.
193     */
194     function add(uint a, uint b) internal pure returns (Error, uint) {
195         uint c = a + b;
196 
197         if (c >= a) {
198             return (Error.NO_ERROR, c);
199         } else {
200             return (Error.INTEGER_OVERFLOW, 0);
201         }
202     }
203 
204     /**
205     * @dev add a and b and then subtract c
206     */
207     function addThenSub(uint a, uint b, uint c) internal pure returns (Error, uint) {
208         (Error err0, uint sum) = add(a, b);
209 
210         if (err0 != Error.NO_ERROR) {
211             return (err0, 0);
212         }
213 
214         return sub(sum, c);
215     }
216 }
217 contract Exponential is ErrorReporter, CarefulMath {
218 
219     // TODO: We may wish to put the result of 10**18 here instead of the expression.
220     // Per https://solidity.readthedocs.io/en/latest/contracts.html#constant-state-variables
221     // the optimizer MAY replace the expression 10**18 with its calculated value.
222     uint constant expScale = 10**18;
223 
224     // See TODO on expScale
225     uint constant halfExpScale = expScale/2;
226 
227     struct Exp {
228         uint mantissa;
229     }
230 
231     uint constant mantissaOne = 10**18;
232     uint constant mantissaOneTenth = 10**17;
233 
234     /**
235     * @dev Creates an exponential from numerator and denominator values.
236     *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
237     *            or if `denom` is zero.
238     */
239     function getExp(uint num, uint denom) pure internal returns (Error, Exp memory) {
240         (Error err0, uint scaledNumerator) = mul(num, expScale);
241         if (err0 != Error.NO_ERROR) {
242             return (err0, Exp({mantissa: 0}));
243         }
244 
245         (Error err1, uint rational) = div(scaledNumerator, denom);
246         if (err1 != Error.NO_ERROR) {
247             return (err1, Exp({mantissa: 0}));
248         }
249 
250         return (Error.NO_ERROR, Exp({mantissa: rational}));
251     }
252 
253     /**
254     * @dev Adds two exponentials, returning a new exponential.
255     */
256     function addExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
257         (Error error, uint result) = add(a.mantissa, b.mantissa);
258 
259         return (error, Exp({mantissa: result}));
260     }
261 
262     /**
263     * @dev Subtracts two exponentials, returning a new exponential.
264     */
265     function subExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
266         (Error error, uint result) = sub(a.mantissa, b.mantissa);
267 
268         return (error, Exp({mantissa: result}));
269     }
270 
271     /**
272     * @dev Multiply an Exp by a scalar, returning a new Exp.
273     */
274     function mulScalar(Exp memory a, uint scalar) pure internal returns (Error, Exp memory) {
275         (Error err0, uint scaledMantissa) = mul(a.mantissa, scalar);
276         if (err0 != Error.NO_ERROR) {
277             return (err0, Exp({mantissa: 0}));
278         }
279 
280         return (Error.NO_ERROR, Exp({mantissa: scaledMantissa}));
281     }
282 
283     /**
284     * @dev Divide an Exp by a scalar, returning a new Exp.
285     */
286     function divScalar(Exp memory a, uint scalar) pure internal returns (Error, Exp memory) {
287         (Error err0, uint descaledMantissa) = div(a.mantissa, scalar);
288         if (err0 != Error.NO_ERROR) {
289             return (err0, Exp({mantissa: 0}));
290         }
291 
292         return (Error.NO_ERROR, Exp({mantissa: descaledMantissa}));
293     }
294 
295     /**
296     * @dev Divide a scalar by an Exp, returning a new Exp.
297     */
298     function divScalarByExp(uint scalar, Exp divisor) pure internal returns (Error, Exp memory) {
299         /*
300             We are doing this as:
301             getExp(mul(expScale, scalar), divisor.mantissa)
302 
303             How it works:
304             Exp = a / b;
305             Scalar = s;
306             `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
307         */
308         (Error err0, uint numerator) = mul(expScale, scalar);
309         if (err0 != Error.NO_ERROR) {
310             return (err0, Exp({mantissa: 0}));
311         }
312         return getExp(numerator, divisor.mantissa);
313     }
314 
315     /**
316     * @dev Multiplies two exponentials, returning a new exponential.
317     */
318     function mulExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
319 
320         (Error err0, uint doubleScaledProduct) = mul(a.mantissa, b.mantissa);
321         if (err0 != Error.NO_ERROR) {
322             return (err0, Exp({mantissa: 0}));
323         }
324 
325         // We add half the scale before dividing so that we get rounding instead of truncation.
326         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
327         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
328         (Error err1, uint doubleScaledProductWithHalfScale) = add(halfExpScale, doubleScaledProduct);
329         if (err1 != Error.NO_ERROR) {
330             return (err1, Exp({mantissa: 0}));
331         }
332 
333         (Error err2, uint product) = div(doubleScaledProductWithHalfScale, expScale);
334         // The only error `div` can return is Error.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
335         assert(err2 == Error.NO_ERROR);
336 
337         return (Error.NO_ERROR, Exp({mantissa: product}));
338     }
339 
340     /**
341       * @dev Divides two exponentials, returning a new exponential.
342       *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
343       *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
344       */
345     function divExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
346         return getExp(a.mantissa, b.mantissa);
347     }
348 
349     /**
350       * @dev Truncates the given exp to a whole number value.
351       *      For example, truncate(Exp{mantissa: 15 * (10**18)}) = 15
352       */
353     function truncate(Exp memory exp) pure internal returns (uint) {
354         // Note: We are not using careful math here as we're performing a division that cannot fail
355         return exp.mantissa / 10**18;
356     }
357 
358     /**
359       * @dev Checks if first Exp is less than second Exp.
360       */
361     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
362         return left.mantissa < right.mantissa; //TODO: Add some simple tests and this in another PR yo.
363     }
364 
365     /**
366       * @dev Checks if left Exp <= right Exp.
367       */
368     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
369         return left.mantissa <= right.mantissa;
370     }
371 
372     /**
373       * @dev Checks if first Exp is greater than second Exp.
374       */
375     function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
376         return left.mantissa > right.mantissa;
377     }
378 
379     /**
380       * @dev returns true if Exp is exactly zero
381       */
382     function isZeroExp(Exp memory value) pure internal returns (bool) {
383         return value.mantissa == 0;
384     }
385 }
386 contract PriceOracle is Exponential {
387 
388     /**
389       * @dev flag for whether or not contract is paused
390       *
391       */
392     bool public paused;
393 
394     uint public constant numBlocksPerPeriod = 240; // approximately 1 hour: 60 seconds/minute * 60 minutes/hour * 1 block/15 seconds
395 
396     uint public constant maxSwingMantissa = (10 ** 17); // 0.1
397 
398     /**
399       * @dev Mapping of asset addresses and their corresponding price in terms of Eth-Wei
400       *      which is simply equal to AssetWeiPrice * 10e18. For instance, if OMG token was
401       *      worth 5x Eth then the price for OMG would be 5*10e18 or Exp({mantissa: 5000000000000000000}).
402       * map: assetAddress -> Exp
403       */
404     mapping(address => Exp) public _assetPrices;
405 
406     constructor(address _poster) public {
407         anchorAdmin = msg.sender;
408         poster = _poster;
409         maxSwing = Exp({mantissa : maxSwingMantissa});
410     }
411 
412     /**
413       * @notice Do not pay into PriceOracle
414       */
415     function() payable public {
416         revert();
417     }
418 
419     enum OracleError {
420         NO_ERROR,
421         UNAUTHORIZED,
422         FAILED_TO_SET_PRICE
423     }
424 
425     enum OracleFailureInfo {
426         ACCEPT_ANCHOR_ADMIN_PENDING_ANCHOR_ADMIN_CHECK,
427         SET_PAUSED_OWNER_CHECK,
428         SET_PENDING_ANCHOR_ADMIN_OWNER_CHECK,
429         SET_PENDING_ANCHOR_PERMISSION_CHECK,
430         SET_PRICE_CALCULATE_SWING,
431         SET_PRICE_CAP_TO_MAX,
432         SET_PRICE_MAX_SWING_CHECK,
433         SET_PRICE_NO_ANCHOR_PRICE_OR_INITIAL_PRICE_ZERO,
434         SET_PRICE_PERMISSION_CHECK,
435         SET_PRICE_ZERO_PRICE,
436         SET_PRICES_PARAM_VALIDATION
437     }
438 
439     /**
440       * @dev `msgSender` is msg.sender; `error` corresponds to enum OracleError; `info` corresponds to enum OracleFailureInfo, and `detail` is an arbitrary
441       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
442       **/
443     event OracleFailure(address msgSender, address asset, uint error, uint info, uint detail);
444 
445     /**
446       * @dev use this when reporting a known error from the price oracle or a non-upgradeable collaborator
447       *      Using Oracle in name because we already inherit a `fail` function from ErrorReporter.sol via Exponential.sol
448       */
449     function failOracle(address asset, OracleError err, OracleFailureInfo info) internal returns (uint) {
450         emit OracleFailure(msg.sender, asset, uint(err), uint(info), 0);
451 
452         return uint(err);
453     }
454 
455     /**
456       * @dev Use this when reporting an error from the money market. Give the money market result as `details`
457       */
458     function failOracleWithDetails(address asset, OracleError err, OracleFailureInfo info, uint details) internal returns (uint) {
459         emit OracleFailure(msg.sender, asset, uint(err), uint(info), details);
460 
461         return uint(err);
462     }
463 
464     /**
465       * @dev An administrator who can set the pending anchor value for assets.
466       *      Set in the constructor.
467       */
468     address public anchorAdmin;
469 
470     /**
471       * @dev pending anchor administrator for this contract.
472       */
473     address public pendingAnchorAdmin;
474 
475     /**
476       * @dev Address of the price poster.
477       *      Set in the constructor.
478       */
479     address public poster;
480 
481     /**
482       * @dev maxSwing the maximum allowed percentage difference between a new price and the anchor's price
483       *      Set only in the constructor
484       */
485     Exp public maxSwing;
486 
487     struct Anchor {
488         // floor(block.number / numBlocksPerPeriod) + 1
489         uint period;
490 
491         // Price in ETH, scaled by 10**18
492         uint priceMantissa;
493     }
494 
495     /**
496       * @dev anchors by asset
497       */
498     mapping(address => Anchor) public anchors;
499 
500     /**
501       * @dev pending anchor prices by asset
502       */
503     mapping(address => uint) public pendingAnchors;
504 
505     /**
506       * @dev emitted when a pending anchor is set
507       * @param asset Asset for which to set a pending anchor
508       * @param oldScaledPrice if an unused pending anchor was present, its value; otherwise 0.
509       * @param newScaledPrice the new scaled pending anchor price
510       */
511     event NewPendingAnchor(address anchorAdmin, address asset, uint oldScaledPrice, uint newScaledPrice);
512 
513     /**
514       * @notice provides ability to override the anchor price for an asset
515       * @dev Admin function to set the anchor price for an asset
516       * @param asset Asset for which to override the anchor price
517       * @param newScaledPrice New anchor price
518       * @return uint 0=success, otherwise a failure (see enum OracleError for details)
519       */
520     function _setPendingAnchor(address asset, uint newScaledPrice) public returns (uint) {
521         // Check caller = anchorAdmin. Note: Deliberately not allowing admin. They can just change anchorAdmin if desired.
522         if (msg.sender != anchorAdmin) {
523             return failOracle(asset, OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PENDING_ANCHOR_PERMISSION_CHECK);
524         }
525 
526         uint oldScaledPrice = pendingAnchors[asset];
527         pendingAnchors[asset] = newScaledPrice;
528 
529         emit NewPendingAnchor(msg.sender, asset, oldScaledPrice, newScaledPrice);
530 
531         return uint(OracleError.NO_ERROR);
532     }
533 
534     /**
535       * @dev emitted for all price changes
536       */
537     event PricePosted(address asset, uint previousPriceMantissa, uint requestedPriceMantissa, uint newPriceMantissa);
538 
539     /**
540       * @dev emitted if this contract successfully posts a capped-to-max price to the money market
541       */
542     event CappedPricePosted(address asset, uint requestedPriceMantissa, uint anchorPriceMantissa, uint cappedPriceMantissa);
543 
544     /**
545       * @dev emitted when admin either pauses or resumes the contract; newState is the resulting state
546       */
547     event SetPaused(bool newState);
548 
549     /**
550       * @dev emitted when pendingAnchorAdmin is changed
551       */
552     event NewPendingAnchorAdmin(address oldPendingAnchorAdmin, address newPendingAnchorAdmin);
553 
554     /**
555       * @dev emitted when pendingAnchorAdmin is accepted, which means anchor admin is updated
556       */
557     event NewAnchorAdmin(address oldAnchorAdmin, address newAnchorAdmin);
558 
559     /**
560       * @notice set `paused` to the specified state
561       * @dev Admin function to pause or resume the market
562       * @param requestedState value to assign to `paused`
563       * @return uint 0=success, otherwise a failure
564       */
565     function _setPaused(bool requestedState) public returns (uint) {
566         // Check caller = anchorAdmin
567         if (msg.sender != anchorAdmin) {
568             return failOracle(0, OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PAUSED_OWNER_CHECK);
569         }
570 
571         paused = requestedState;
572         emit SetPaused(requestedState);
573 
574         return uint(Error.NO_ERROR);
575     }
576 
577     /**
578       * @notice Begins transfer of anchor admin rights. The newPendingAnchorAdmin must call `_acceptAnchorAdmin` to finalize the transfer.
579       * @dev Admin function to begin change of anchor admin. The newPendingAnchorAdmin must call `_acceptAnchorAdmin` to finalize the transfer.
580       * @param newPendingAnchorAdmin New pending anchor admin.
581       * @return uint 0=success, otherwise a failure
582       *
583       * TODO: Should we add a second arg to verify, like a checksum of `newAnchorAdmin` address?
584       */
585     function _setPendingAnchorAdmin(address newPendingAnchorAdmin) public returns (uint) {
586         // Check caller = anchorAdmin
587         if (msg.sender != anchorAdmin) {
588             return failOracle(0, OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PENDING_ANCHOR_ADMIN_OWNER_CHECK);
589         }
590 
591         // save current value, if any, for inclusion in log
592         address oldPendingAnchorAdmin = pendingAnchorAdmin;
593         // Store pendingAdmin = newPendingAdmin
594         pendingAnchorAdmin = newPendingAnchorAdmin;
595 
596         emit NewPendingAnchorAdmin(oldPendingAnchorAdmin, newPendingAnchorAdmin);
597 
598         return uint(Error.NO_ERROR);
599     }
600 
601     /**
602       * @notice Accepts transfer of anchor admin rights. msg.sender must be pendingAnchorAdmin
603       * @dev Admin function for pending anchor admin to accept role and update anchor admin
604       * @return uint 0=success, otherwise a failure
605       */
606     function _acceptAnchorAdmin() public returns (uint) {
607         // Check caller = pendingAnchorAdmin
608         // msg.sender can't be zero
609         if (msg.sender != pendingAnchorAdmin) {
610             return failOracle(0, OracleError.UNAUTHORIZED, OracleFailureInfo.ACCEPT_ANCHOR_ADMIN_PENDING_ANCHOR_ADMIN_CHECK);
611         }
612 
613         // Save current value for inclusion in log
614         address oldAnchorAdmin = anchorAdmin;
615         // Store admin = pendingAnchorAdmin
616         anchorAdmin = pendingAnchorAdmin;
617         // Clear the pending value
618         pendingAnchorAdmin = 0;
619 
620         emit NewAnchorAdmin(oldAnchorAdmin, msg.sender);
621 
622         return uint(Error.NO_ERROR);
623     }
624 
625     /**
626       * @notice retrieves price of an asset
627       * @dev function to get price for an asset
628       * @param asset Asset for which to get the price
629       * @return uint mantissa of asset price (scaled by 1e18) or zero if unset or contract paused
630       */
631     function assetPrices(address asset) public view returns (uint) {
632         if (paused) {
633             return 0;
634         } else {
635             return _assetPrices[asset].mantissa;
636         }
637     }
638 
639     /**
640       * @notice retrieves price of an asset
641       * @dev function to get price for an asset
642       * @param asset Asset for which to get the price
643       * @return uint mantissa of asset price (scaled by 1e18) or zero if unset or contract paused
644       */
645     function getPrice(address asset) public view returns (uint) {
646         return assetPrices(asset);
647     }
648 
649     struct SetPriceLocalVars {
650         Exp price;
651         Exp swing;
652         Exp anchorPrice;
653         uint anchorPeriod;
654         uint currentPeriod;
655         bool priceCapped;
656         uint cappingAnchorPriceMantissa;
657         uint pendingAnchorMantissa;
658     }
659 
660     /**
661       * @notice entry point for updating prices
662       * @dev function to set price for an asset
663       * @param asset Asset for which to set the price
664       * @param requestedPriceMantissa requested new price, scaled by 10**18
665       * @return uint 0=success, otherwise a failure (see enum OracleError for details)
666       */
667     function setPrice(address asset, uint requestedPriceMantissa) public returns (uint) {
668         // Fail when msg.sender is not poster
669         if (msg.sender != poster) {
670             return failOracle(asset, OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PRICE_PERMISSION_CHECK);
671         }
672 
673         return setPriceInternal(asset, requestedPriceMantissa);
674     }
675 
676     function setPriceInternal(address asset, uint requestedPriceMantissa) internal returns (uint) {
677         // re-used for intermediate errors
678         Error err;
679         SetPriceLocalVars memory localVars;
680         // We add 1 for currentPeriod so that it can never be zero and there's no ambiguity about an unset value.
681         // (It can be a problem in tests with low block numbers.)
682         localVars.currentPeriod = (block.number / numBlocksPerPeriod) + 1;
683         localVars.pendingAnchorMantissa = pendingAnchors[asset];
684         localVars.price = Exp({mantissa : requestedPriceMantissa});
685 
686         if (localVars.pendingAnchorMantissa != 0) {
687             // let's explicitly set to 0 rather than relying on default of declaration
688             localVars.anchorPeriod = 0;
689             localVars.anchorPrice = Exp({mantissa : localVars.pendingAnchorMantissa});
690 
691             // Verify movement is within max swing of pending anchor (currently: 10%)
692             (err, localVars.swing) = calculateSwing(localVars.anchorPrice, localVars.price);
693             if (err != Error.NO_ERROR) {
694                 return failOracleWithDetails(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_CALCULATE_SWING, uint(err));
695             }
696 
697             // Fail when swing > maxSwing
698             if (greaterThanExp(localVars.swing, maxSwing)) {
699                 return failOracleWithDetails(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_MAX_SWING_CHECK, localVars.swing.mantissa);
700             }
701         } else {
702             localVars.anchorPeriod = anchors[asset].period;
703             localVars.anchorPrice = Exp({mantissa : anchors[asset].priceMantissa});
704 
705             if (localVars.anchorPeriod != 0) {
706                 (err, localVars.priceCapped, localVars.price) = capToMax(localVars.anchorPrice, localVars.price);
707                 if (err != Error.NO_ERROR) {
708                     return failOracleWithDetails(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_CAP_TO_MAX, uint(err));
709                 }
710                 if (localVars.priceCapped) {
711                     // save for use in log
712                     localVars.cappingAnchorPriceMantissa = localVars.anchorPrice.mantissa;
713                 }
714             } else {
715                 // Setting first price. Accept as is (already assigned above from requestedPriceMantissa) and use as anchor
716                 localVars.anchorPrice = Exp({mantissa : requestedPriceMantissa});
717             }
718         }
719 
720         // Fail if anchorPrice or price is zero.
721         // zero anchor represents an unexpected situation likely due to a problem in this contract
722         // zero price is more likely as the result of bad input from the caller of this function
723         if (isZeroExp(localVars.anchorPrice)) {
724             // If we get here price could also be zero, but it does not seem worthwhile to distinguish the 3rd case
725             return failOracle(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_NO_ANCHOR_PRICE_OR_INITIAL_PRICE_ZERO);
726         }
727 
728         if (isZeroExp(localVars.price)) {
729             return failOracle(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_ZERO_PRICE);
730         }
731 
732         // BEGIN SIDE EFFECTS
733 
734         // Set pendingAnchor = Nothing
735         // Pending anchor is only used once.
736         if (pendingAnchors[asset] != 0) {
737             pendingAnchors[asset] = 0;
738         }
739 
740         // If currentPeriod > anchorPeriod:
741         //  Set anchors[asset] = (currentPeriod, price)
742         //  The new anchor is if we're in a new period or we had a pending anchor, then we become the new anchor
743         if (localVars.currentPeriod > localVars.anchorPeriod) {
744             anchors[asset] = Anchor({period : localVars.currentPeriod, priceMantissa : localVars.price.mantissa});
745         }
746 
747         uint previousPrice = _assetPrices[asset].mantissa;
748 
749         setPriceStorageInternal(asset, localVars.price.mantissa);
750 
751         emit PricePosted(asset, previousPrice, requestedPriceMantissa, localVars.price.mantissa);
752 
753         if (localVars.priceCapped) {
754             // We have set a capped price. Log it so we can detect the situation and investigate.
755             emit CappedPricePosted(asset, requestedPriceMantissa, localVars.cappingAnchorPriceMantissa, localVars.price.mantissa);
756         }
757 
758         return uint(OracleError.NO_ERROR);
759     }
760 
761     // As a function to allow harness overrides
762     function setPriceStorageInternal(address asset, uint256 priceMantissa) internal {
763         _assetPrices[asset] = Exp({mantissa: priceMantissa});
764     }
765 
766     // abs(price - anchorPrice) / anchorPrice
767     function calculateSwing(Exp memory anchorPrice, Exp memory price) pure internal returns (Error, Exp memory) {
768         Exp memory numerator;
769         Error err;
770 
771         if (greaterThanExp(anchorPrice, price)) {
772             (err, numerator) = subExp(anchorPrice, price);
773             // can't underflow
774             assert(err == Error.NO_ERROR);
775         } else {
776             (err, numerator) = subExp(price, anchorPrice);
777             // Given greaterThan check above, price >= anchorPrice so can't underflow.
778             assert(err == Error.NO_ERROR);
779         }
780 
781         return divExp(numerator, anchorPrice);
782     }
783 
784     function capToMax(Exp memory anchorPrice, Exp memory price) view internal returns (Error, bool, Exp memory) {
785         Exp memory one = Exp({mantissa : mantissaOne});
786         Exp memory onePlusMaxSwing;
787         Exp memory oneMinusMaxSwing;
788         Exp memory max;
789         Exp memory min;
790         // re-used for intermediate errors
791         Error err;
792 
793         (err, onePlusMaxSwing) = addExp(one, maxSwing);
794         if (err != Error.NO_ERROR) {
795             return (err, false, Exp({mantissa : 0}));
796         }
797 
798         // max = anchorPrice * (1 + maxSwing)
799         (err, max) = mulExp(anchorPrice, onePlusMaxSwing);
800         if (err != Error.NO_ERROR) {
801             return (err, false, Exp({mantissa : 0}));
802         }
803 
804         // If price > anchorPrice * (1 + maxSwing)
805         // Set price = anchorPrice * (1 + maxSwing)
806         if (greaterThanExp(price, max)) {
807             return (Error.NO_ERROR, true, max);
808         }
809 
810         (err, oneMinusMaxSwing) = subExp(one, maxSwing);
811         if (err != Error.NO_ERROR) {
812             return (err, false, Exp({mantissa : 0}));
813         }
814 
815         // min = anchorPrice * (1 - maxSwing)
816         (err, min) = mulExp(anchorPrice, oneMinusMaxSwing);
817         // We can't overflow here or we would have already overflowed above when calculating `max`
818         assert(err == Error.NO_ERROR);
819 
820         // If  price < anchorPrice * (1 - maxSwing)
821         // Set price = anchorPrice * (1 - maxSwing)
822         if (lessThanExp(price, min)) {
823             return (Error.NO_ERROR, true, min);
824         }
825 
826         return (Error.NO_ERROR, false, price);
827     }
828 
829     /**
830       * @notice entry point for updating multiple prices
831       * @dev function to set prices for a variable number of assets.
832       * @param assets a list of up to assets for which to set a price. required: 0 < assets.length == requestedPriceMantissas.length
833       * @param requestedPriceMantissas requested new prices for the assets, scaled by 10**18. required: 0 < assets.length == requestedPriceMantissas.length
834       * @return uint values in same order as inputs. For each: 0=success, otherwise a failure (see enum OracleError for details)
835       */
836     function setPrices(address[] assets, uint[] requestedPriceMantissas) public returns (uint[] memory) {
837         uint numAssets = assets.length;
838         uint numPrices = requestedPriceMantissas.length;
839         uint[] memory result;
840 
841         // Fail when msg.sender is not poster
842         if (msg.sender != poster) {
843             result = new uint[](1);
844             result[0] = failOracle(0, OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PRICE_PERMISSION_CHECK);
845             return result;
846         }
847 
848         if ((numAssets == 0) || (numPrices != numAssets)) {
849             result = new uint[](1);
850             result[0] = failOracle(0, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICES_PARAM_VALIDATION);
851             return result;
852         }
853 
854         result = new uint[](numAssets);
855 
856         for (uint i = 0; i < numAssets; i++) {
857             result[i] = setPriceInternal(assets[i], requestedPriceMantissas[i]);
858         }
859 
860         return result;
861     }
862 }