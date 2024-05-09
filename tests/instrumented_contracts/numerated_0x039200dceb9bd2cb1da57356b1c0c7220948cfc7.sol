1 pragma solidity ^0.4.26;
2 
3 contract DSValue {
4     
5     function peek() public view returns (bytes32, bool);
6 
7     function read() public view returns (bytes32);
8 }
9 
10 contract ErrorReporter {
11 
12     function fail(Error err, FailureInfo info) internal returns (uint) {
13         emit Failure(uint(err), uint(info), 0);
14 
15         return uint(err);
16     }
17 
18     function failOpaque(FailureInfo info, uint opaqueError) internal returns (uint) {
19         emit Failure(uint(Error.OPAQUE_ERROR), uint(info), opaqueError);
20 
21         return uint(Error.OPAQUE_ERROR);
22     }
23 
24     event Failure(uint error, uint info, uint detail);
25 
26     enum Error {
27         NO_ERROR,
28         OPAQUE_ERROR, 
29         UNAUTHORIZED,
30         INTEGER_OVERFLOW,
31         INTEGER_UNDERFLOW,
32         DIVISION_BY_ZERO,
33         BAD_INPUT,
34         TOKEN_INSUFFICIENT_ALLOWANCE,
35         TOKEN_INSUFFICIENT_BALANCE,
36         TOKEN_TRANSFER_FAILED,
37         MARKET_NOT_SUPPORTED,
38         SUPPLY_RATE_CALCULATION_FAILED,
39         BORROW_RATE_CALCULATION_FAILED,
40         TOKEN_INSUFFICIENT_CASH,
41         TOKEN_TRANSFER_OUT_FAILED,
42         INSUFFICIENT_LIQUIDITY,
43         INSUFFICIENT_BALANCE,
44         INVALID_COLLATERAL_RATIO,
45         MISSING_ASSET_PRICE,
46         EQUITY_INSUFFICIENT_BALANCE,
47         INVALID_CLOSE_AMOUNT_REQUESTED,
48         ASSET_NOT_PRICED,
49         INVALID_LIQUIDATION_DISCOUNT,
50         INVALID_COMBINED_RISK_PARAMETERS
51     }
52 
53     enum FailureInfo {
54         BORROW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED,
55         BORROW_ACCOUNT_SHORTFALL_PRESENT,
56         BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
57         BORROW_AMOUNT_LIQUIDITY_SHORTFALL,
58         BORROW_AMOUNT_VALUE_CALCULATION_FAILED,
59         BORROW_MARKET_NOT_SUPPORTED,
60         BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED,
61         BORROW_NEW_BORROW_RATE_CALCULATION_FAILED,
62         BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
63         BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
64         BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
65         BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED,
66         BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED,
67         BORROW_ORIGINATION_FEE_CALCULATION_FAILED,
68         BORROW_TRANSFER_OUT_FAILED,
69         EQUITY_WITHDRAWAL_AMOUNT_VALIDATION,
70         EQUITY_WITHDRAWAL_CALCULATE_EQUITY,
71         EQUITY_WITHDRAWAL_MODEL_OWNER_CHECK,
72         EQUITY_WITHDRAWAL_TRANSFER_OUT_FAILED,
73         LIQUIDATE_ACCUMULATED_BORROW_BALANCE_CALCULATION_FAILED,
74         LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET,
75         LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET,
76         LIQUIDATE_AMOUNT_SEIZE_CALCULATION_FAILED,
77         LIQUIDATE_BORROW_DENOMINATED_COLLATERAL_CALCULATION_FAILED,
78         LIQUIDATE_CLOSE_AMOUNT_TOO_HIGH,
79         LIQUIDATE_DISCOUNTED_REPAY_TO_EVEN_AMOUNT_CALCULATION_FAILED,
80         LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_BORROWED_ASSET,
81         LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET,
82         LIQUIDATE_NEW_BORROW_RATE_CALCULATION_FAILED_BORROWED_ASSET,
83         LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_BORROWED_ASSET,
84         LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET,
85         LIQUIDATE_NEW_SUPPLY_RATE_CALCULATION_FAILED_BORROWED_ASSET,
86         LIQUIDATE_NEW_TOTAL_BORROW_CALCULATION_FAILED_BORROWED_ASSET,
87         LIQUIDATE_NEW_TOTAL_CASH_CALCULATION_FAILED_BORROWED_ASSET,
88         LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET,
89         LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET,
90         LIQUIDATE_TRANSFER_IN_FAILED,
91         LIQUIDATE_TRANSFER_IN_NOT_POSSIBLE,
92         REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
93         REPAY_BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED,
94         REPAY_BORROW_NEW_BORROW_RATE_CALCULATION_FAILED,
95         REPAY_BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
96         REPAY_BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
97         REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
98         REPAY_BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED,
99         REPAY_BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED,
100         REPAY_BORROW_TRANSFER_IN_FAILED,
101         REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE,
102         SET_ADMIN_OWNER_CHECK,
103         SET_ASSET_PRICE_CHECK_ORACLE,
104         SET_MARKET_INTEREST_RATE_MODEL_OWNER_CHECK,
105         SET_ORACLE_OWNER_CHECK,
106         SET_ORIGINATION_FEE_OWNER_CHECK,
107         SET_RISK_PARAMETERS_OWNER_CHECK,
108         SET_RISK_PARAMETERS_VALIDATION,
109         SUPPLY_ACCUMULATED_BALANCE_CALCULATION_FAILED,
110         SUPPLY_MARKET_NOT_SUPPORTED,
111         SUPPLY_NEW_BORROW_INDEX_CALCULATION_FAILED,
112         SUPPLY_NEW_BORROW_RATE_CALCULATION_FAILED,
113         SUPPLY_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
114         SUPPLY_NEW_SUPPLY_RATE_CALCULATION_FAILED,
115         SUPPLY_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
116         SUPPLY_NEW_TOTAL_CASH_CALCULATION_FAILED,
117         SUPPLY_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
118         SUPPLY_TRANSFER_IN_FAILED,
119         SUPPLY_TRANSFER_IN_NOT_POSSIBLE,
120         SUPPORT_MARKET_OWNER_CHECK,
121         SUPPORT_MARKET_PRICE_CHECK,
122         SUSPEND_MARKET_OWNER_CHECK,
123         WITHDRAW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED,
124         WITHDRAW_ACCOUNT_SHORTFALL_PRESENT,
125         WITHDRAW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
126         WITHDRAW_AMOUNT_LIQUIDITY_SHORTFALL,
127         WITHDRAW_AMOUNT_VALUE_CALCULATION_FAILED,
128         WITHDRAW_CAPACITY_CALCULATION_FAILED,
129         WITHDRAW_NEW_BORROW_INDEX_CALCULATION_FAILED,
130         WITHDRAW_NEW_BORROW_RATE_CALCULATION_FAILED,
131         WITHDRAW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
132         WITHDRAW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
133         WITHDRAW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
134         WITHDRAW_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
135         WITHDRAW_TRANSFER_OUT_FAILED,
136         WITHDRAW_TRANSFER_OUT_NOT_POSSIBLE
137     }
138 
139 }
140 
141 /**
142   * @title Careful Math
143   * @notice Derived from OpenZeppelin's SafeMath library
144   *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
145   */
146   
147 contract CarefulMath is ErrorReporter {
148 
149 
150     function mul(uint a, uint b) internal pure returns (Error, uint) {
151         if (a == 0) {
152             return (Error.NO_ERROR, 0);
153         }
154 
155         uint c = a * b;
156 
157         if (c / a != b) {
158             return (Error.INTEGER_OVERFLOW, 0);
159         } else {
160             return (Error.NO_ERROR, c);
161         }
162     }
163 
164     function div(uint a, uint b) internal pure returns (Error, uint) {
165         if (b == 0) {
166             return (Error.DIVISION_BY_ZERO, 0);
167         }
168 
169         return (Error.NO_ERROR, a / b);
170     }
171 
172     function sub(uint a, uint b) internal pure returns (Error, uint) {
173         if (b <= a) {
174             return (Error.NO_ERROR, a - b);
175         } else {
176             return (Error.INTEGER_UNDERFLOW, 0);
177         }
178     }
179 
180     function add(uint a, uint b) internal pure returns (Error, uint) {
181         uint c = a + b;
182 
183         if (c >= a) {
184             return (Error.NO_ERROR, c);
185         } else {
186             return (Error.INTEGER_OVERFLOW, 0);
187         }
188     }
189 
190     function addThenSub(uint a, uint b, uint c) internal pure returns (Error, uint) {
191         (Error err0, uint sum) = add(a, b);
192 
193         if (err0 != Error.NO_ERROR) {
194             return (err0, 0);
195         }
196 
197         return sub(sum, c);
198     }
199 }
200 
201 contract Exponential is ErrorReporter, CarefulMath {
202 
203     // TODO: We may wish to put the result of 10**18 here instead of the expression.
204     // Per https://solidity.readthedocs.io/en/latest/contracts.html#constant-state-variables
205     // the optimizer MAY replace the expression 10**18 with its calculated value.
206     uint constant expScale = 10**18;
207 
208     // See TODO on expScale
209     uint constant halfExpScale = expScale/2;
210 
211     struct Exp {
212         uint mantissa;
213     }
214 
215     uint constant mantissaOne = 10**18;
216     uint constant mantissaOneTenth = 10**17;
217 
218     /**
219     * @dev Creates an exponential from numerator and denominator values.
220     *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
221     *            or if `denom` is zero.
222     */
223     function getExp(uint num, uint denom) pure internal returns (Error, Exp memory) {
224         (Error err0, uint scaledNumerator) = mul(num, expScale);
225         if (err0 != Error.NO_ERROR) {
226             return (err0, Exp({mantissa: 0}));
227         }
228 
229         (Error err1, uint rational) = div(scaledNumerator, denom);
230         if (err1 != Error.NO_ERROR) {
231             return (err1, Exp({mantissa: 0}));
232         }
233 
234         return (Error.NO_ERROR, Exp({mantissa: rational}));
235     }
236 
237 
238     function addExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
239         (Error error, uint result) = add(a.mantissa, b.mantissa);
240 
241         return (error, Exp({mantissa: result}));
242     }
243 
244 
245 
246     function subExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
247         (Error error, uint result) = sub(a.mantissa, b.mantissa);
248 
249         return (error, Exp({mantissa: result}));
250     }
251 
252 
253     function mulScalar(Exp memory a, uint scalar) pure internal returns (Error, Exp memory) {
254         (Error err0, uint scaledMantissa) = mul(a.mantissa, scalar);
255         if (err0 != Error.NO_ERROR) {
256             return (err0, Exp({mantissa: 0}));
257         }
258 
259         return (Error.NO_ERROR, Exp({mantissa: scaledMantissa}));
260     }
261 
262 
263     function divScalar(Exp memory a, uint scalar) pure internal returns (Error, Exp memory) {
264         (Error err0, uint descaledMantissa) = div(a.mantissa, scalar);
265         if (err0 != Error.NO_ERROR) {
266             return (err0, Exp({mantissa: 0}));
267         }
268 
269         return (Error.NO_ERROR, Exp({mantissa: descaledMantissa}));
270     }
271 
272 
273     function divScalarByExp(uint scalar, Exp divisor) pure internal returns (Error, Exp memory) {
274         /*
275             We are doing this as:
276             getExp(mul(expScale, scalar), divisor.mantissa)
277 
278             How it works:
279             Exp = a / b;
280             Scalar = s;
281             `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
282         */
283         (Error err0, uint numerator) = mul(expScale, scalar);
284         if (err0 != Error.NO_ERROR) {
285             return (err0, Exp({mantissa: 0}));
286         }
287         return getExp(numerator, divisor.mantissa);
288     }
289 
290 
291     function mulExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
292 
293         (Error err0, uint doubleScaledProduct) = mul(a.mantissa, b.mantissa);
294         if (err0 != Error.NO_ERROR) {
295             return (err0, Exp({mantissa: 0}));
296         }
297 
298         // We add half the scale before dividing so that we get rounding instead of truncation.
299         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
300         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
301         (Error err1, uint doubleScaledProductWithHalfScale) = add(halfExpScale, doubleScaledProduct);
302         if (err1 != Error.NO_ERROR) {
303             return (err1, Exp({mantissa: 0}));
304         }
305 
306         (Error err2, uint product) = div(doubleScaledProductWithHalfScale, expScale);
307         // The only error `div` can return is Error.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
308         assert(err2 == Error.NO_ERROR);
309 
310         return (Error.NO_ERROR, Exp({mantissa: product}));
311     }
312 
313     /**
314       * @dev Divides two exponentials, returning a new exponential.
315       *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
316       *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
317       */
318     function divExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
319         return getExp(a.mantissa, b.mantissa);
320     }
321 
322     /**
323       * @dev Truncates the given exp to a whole number value.
324       *      For example, truncate(Exp{mantissa: 15 * (10**18)}) = 15
325       */
326     function truncate(Exp memory exp) pure internal returns (uint) {
327         // Note: We are not using careful math here as we're performing a division that cannot fail
328         return exp.mantissa / 10**18;
329     }
330 
331     /**
332       * @dev Checks if first Exp is less than second Exp.
333       */
334     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
335         return left.mantissa < right.mantissa; //TODO: Add some simple tests and this in another PR yo.
336     }
337 
338     /**
339       * @dev Checks if left Exp <= right Exp.
340       */
341     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
342         return left.mantissa <= right.mantissa;
343     }
344 
345     /**
346       * @dev Checks if first Exp is greater than second Exp.
347       */
348     function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
349         return left.mantissa > right.mantissa;
350     }
351 
352     /**
353       * @dev returns true if Exp is exactly zero
354       */
355     function isZeroExp(Exp memory value) pure internal returns (bool) {
356         return value.mantissa == 0;
357     }
358 }
359 contract PriceOracle is Exponential {
360 
361     /**
362       * @dev flag for whether or not contract is paused
363       *
364       */
365     bool public paused;
366 
367     uint public constant numBlocksPerPeriod = 240; // approximately 1 hour: 60 seconds/minute * 60 minutes/hour * 1 block/15 seconds
368 
369     uint public constant maxSwingMantissa = (10 ** 17); // 0.1
370 
371     /**
372       * @dev Mapping of asset addresses to DSValue price oracle contracts. The price contracts
373       *      should be DSValue contracts whose value is the `eth:asset` price scaled by 1e18.
374       *      That is, 1 eth is worth how much of the asset (e.g. 1 eth = 100 USD). We want
375       *      to know the inverse, which is how much eth is one asset worth. This `asset:eth`
376       *      is the multiplicative inverse (in that example, 1/100). The math is a bit trickier
377       *      since we need to descale the number by 1e18, inverse, and then rescale the number.
378       *      We perform this operation to return the `asset:eth` price for these reader assets.
379       *
380       * map: assetAddress -> DSValue price oracle
381       */
382     mapping(address => DSValue) public readers;
383 
384     /**
385       * @dev Mapping of asset addresses and their corresponding price in terms of Eth-Wei
386       *      which is simply equal to AssetWeiPrice * 10e18. For instance, if OMG token was
387       *      worth 5x Eth then the price for OMG would be 5*10e18 or Exp({mantissa: 5000000000000000000}).
388       * map: assetAddress -> Exp
389       */
390     mapping(address => Exp) public _assetPrices;
391     constructor( ) public {
392         anchorAdmin = msg.sender;
393         poster = msg.sender;
394         maxSwing = Exp({mantissa : maxSwingMantissa}); 
395     }
396     
397     /**
398       * @notice Do not pay into PriceOracle
399       */
400     function() payable public {
401         revert();
402     }
403 
404     enum OracleError {
405         NO_ERROR,
406         UNAUTHORIZED,
407         FAILED_TO_SET_PRICE
408     }
409 
410     enum OracleFailureInfo {
411         ACCEPT_ANCHOR_ADMIN_PENDING_ANCHOR_ADMIN_CHECK,
412         SET_PAUSED_OWNER_CHECK,
413         SET_PENDING_ANCHOR_ADMIN_OWNER_CHECK,
414         SET_PENDING_ANCHOR_PERMISSION_CHECK,
415         SET_PRICE_CALCULATE_SWING,
416         SET_PRICE_CAP_TO_MAX,
417         SET_PRICE_MAX_SWING_CHECK,
418         SET_PRICE_NO_ANCHOR_PRICE_OR_INITIAL_PRICE_ZERO,
419         SET_PRICE_PERMISSION_CHECK,
420         SET_PRICE_ZERO_PRICE,
421         SET_PRICES_PARAM_VALIDATION,
422         SET_PRICE_IS_READER_ASSET
423     }
424 
425     /**
426       * @dev `msgSender` is msg.sender; `error` corresponds to enum OracleError; `info` corresponds to enum OracleFailureInfo, and `detail` is an arbitrary
427       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
428       **/
429     event OracleFailure(address msgSender, address asset, uint error, uint info, uint detail);
430 
431     /**
432       * @dev use this when reporting a known error from the price oracle or a non-upgradeable collaborator
433       *      Using Oracle in name because we already inherit a `fail` function from ErrorReporter.sol via Exponential.sol
434       */
435     function failOracle(address asset, OracleError err, OracleFailureInfo info) internal returns (uint) {
436         emit OracleFailure(msg.sender, asset, uint(err), uint(info), 0);
437 
438         return uint(err);
439     }
440 
441     /**
442       * @dev Use this when reporting an error from the money market. Give the money market result as `details`
443       */
444     function failOracleWithDetails(address asset, OracleError err, OracleFailureInfo info, uint details) internal returns (uint) {
445         emit OracleFailure(msg.sender, asset, uint(err), uint(info), details);
446 
447         return uint(err);
448     }
449 
450     /**
451       * @dev An administrator who can set the pending anchor value for assets.
452       *      Set in the constructor.
453       */
454     address public anchorAdmin;
455 
456     /**
457       * @dev pending anchor administrator for this contract.
458       */
459     address public pendingAnchorAdmin;
460 
461     /**
462       * @dev Address of the price poster.
463       *      Set in the constructor.
464       */
465     address public poster;
466 
467     /**
468       * @dev maxSwing the maximum allowed percentage difference between a new price and the anchor's price
469       *      Set only in the constructor
470       */
471     Exp public maxSwing;
472 
473     struct Anchor {
474         // floor(block.number / numBlocksPerPeriod) + 1
475         uint period;
476 
477         // Price in ETH, scaled by 10**18
478         uint priceMantissa;
479     }
480 
481     /**
482       * @dev anchors by asset
483       */
484     mapping(address => Anchor) public anchors;
485 
486     /**
487       * @dev pending anchor prices by asset
488       */
489     mapping(address => uint) public pendingAnchors;
490 
491     /**
492       * @dev emitted when a pending anchor is set
493       * @param asset Asset for which to set a pending anchor
494       * @param oldScaledPrice if an unused pending anchor was present, its value; otherwise 0.
495       * @param newScaledPrice the new scaled pending anchor price
496       */
497     event NewPendingAnchor(address anchorAdmin, address asset, uint oldScaledPrice, uint newScaledPrice);
498 
499     /**
500       * @notice provides ability to override the anchor price for an asset
501       * @dev Admin function to set the anchor price for an asset
502       * @param asset Asset for which to override the anchor price
503       * @param newScaledPrice New anchor price
504       * @return uint 0=success, otherwise a failure (see enum OracleError for details)
505       */
506     function _setPendingAnchor(address asset, uint newScaledPrice) public returns (uint) {
507         // Check caller = anchorAdmin. Note: Deliberately not allowing admin. They can just change anchorAdmin if desired.
508         if (msg.sender != anchorAdmin) {
509             return failOracle(asset, OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PENDING_ANCHOR_PERMISSION_CHECK);
510         }
511 
512         uint oldScaledPrice = pendingAnchors[asset];
513         pendingAnchors[asset] = newScaledPrice;
514 
515         emit NewPendingAnchor(msg.sender, asset, oldScaledPrice, newScaledPrice);
516 
517         return uint(OracleError.NO_ERROR);
518     }
519 
520     /**
521       * @dev emitted for all price changes
522       */
523     event PricePosted(address asset, uint previousPriceMantissa, uint requestedPriceMantissa, uint newPriceMantissa);
524 
525     /**
526       * @dev emitted if this contract successfully posts a capped-to-max price to the money market
527       */
528     event CappedPricePosted(address asset, uint requestedPriceMantissa, uint anchorPriceMantissa, uint cappedPriceMantissa);
529 
530     /**
531       * @dev emitted when admin either pauses or resumes the contract; newState is the resulting state
532       */
533     event SetPaused(bool newState);
534 
535     /**
536       * @dev emitted when pendingAnchorAdmin is changed
537       */
538     event NewPendingAnchorAdmin(address oldPendingAnchorAdmin, address newPendingAnchorAdmin);
539 
540     /**
541       * @dev emitted when pendingAnchorAdmin is accepted, which means anchor admin is updated
542       */
543     event NewAnchorAdmin(address oldAnchorAdmin, address newAnchorAdmin);
544 
545     /**
546       * @notice set `paused` to the specified state
547       * @dev Admin function to pause or resume the market
548       * @param requestedState value to assign to `paused`
549       * @return uint 0=success, otherwise a failure
550       */
551     function _setPaused(bool requestedState) public returns (uint) {
552         // Check caller = anchorAdmin
553         if (msg.sender != anchorAdmin) {
554             return failOracle(0, OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PAUSED_OWNER_CHECK);
555         }
556 
557         paused = requestedState;
558         emit SetPaused(requestedState);
559 
560         return uint(Error.NO_ERROR);
561     }
562 
563     /**
564       * @notice Begins transfer of anchor admin rights. The newPendingAnchorAdmin must call `_acceptAnchorAdmin` to finalize the transfer.
565       * @dev Admin function to begin change of anchor admin. The newPendingAnchorAdmin must call `_acceptAnchorAdmin` to finalize the transfer.
566       * @param newPendingAnchorAdmin New pending anchor admin.
567       * @return uint 0=success, otherwise a failure
568       *
569       * TODO: Should we add a second arg to verify, like a checksum of `newAnchorAdmin` address?
570       */
571     function _setPendingAnchorAdmin(address newPendingAnchorAdmin) public returns (uint) {
572         // Check caller = anchorAdmin
573         if (msg.sender != anchorAdmin) {
574             return failOracle(0, OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PENDING_ANCHOR_ADMIN_OWNER_CHECK);
575         }
576 
577         // save current value, if any, for inclusion in log
578         address oldPendingAnchorAdmin = pendingAnchorAdmin;
579         // Store pendingAdmin = newPendingAdmin
580         pendingAnchorAdmin = newPendingAnchorAdmin;
581 
582         emit NewPendingAnchorAdmin(oldPendingAnchorAdmin, newPendingAnchorAdmin);
583 
584         return uint(Error.NO_ERROR);
585     }
586 
587     /**
588       * @notice Accepts transfer of anchor admin rights. msg.sender must be pendingAnchorAdmin
589       * @dev Admin function for pending anchor admin to accept role and update anchor admin
590       * @return uint 0=success, otherwise a failure
591       */
592     function _acceptAnchorAdmin() public returns (uint) {
593         // Check caller = pendingAnchorAdmin
594         // msg.sender can't be zero
595         if (msg.sender != pendingAnchorAdmin) {
596             return failOracle(0, OracleError.UNAUTHORIZED, OracleFailureInfo.ACCEPT_ANCHOR_ADMIN_PENDING_ANCHOR_ADMIN_CHECK);
597         }
598 
599         // Save current value for inclusion in log
600         address oldAnchorAdmin = anchorAdmin;
601         // Store admin = pendingAnchorAdmin
602         anchorAdmin = pendingAnchorAdmin;
603         // Clear the pending value
604         pendingAnchorAdmin = 0;
605 
606         emit NewAnchorAdmin(oldAnchorAdmin, msg.sender);
607 
608         return uint(Error.NO_ERROR);
609     }
610 
611     /**
612       * @notice retrieves price of an asset
613       * @dev function to get price for an asset
614       * @param asset Asset for which to get the price
615       * @return uint mantissa of asset price (scaled by 1e18) or zero if unset or contract paused
616       */
617     function assetPrices(address asset) public view returns (uint) {
618         // Note: zero is treated by the money market as an invalid
619         //       price and will cease operations with that asset
620         //       when zero.
621         //
622         // We get the price as:
623         //
624         //  1. If the contract is paused, return 0.
625         //  2. If the asset is a reader asset:
626         //    a. If the reader has a value set, invert it and return.
627         //    b. Else, return 0.
628         //  3. Return price in `_assetPrices`, which may be zero.
629 
630         if (paused) {
631             return 0;
632         } else {
633             if (readers[asset] != address(0)) {
634                 (bytes32 readValue, bool foundValue) = readers[asset].peek();
635 
636                 if (foundValue) {
637                     (Error error, Exp memory invertedVal) = getExp(mantissaOne, uint256(readValue));
638 
639                     if (error != Error.NO_ERROR) {
640                         return 0;
641                     }
642 
643                     return invertedVal.mantissa;
644                 } else {
645                     return 0;
646                 }
647             } else {
648                 return _assetPrices[asset].mantissa;
649             }
650         }
651     }
652 
653     /**
654       * @notice retrieves price of an asset
655       * @dev function to get price for an asset
656       * @param asset Asset for which to get the price
657       * @return uint mantissa of asset price (scaled by 1e18) or zero if unset or contract paused
658       */
659     function getPrice(address asset) public view returns (uint) {
660         return assetPrices(asset);
661     }
662 
663     struct SetPriceLocalVars {
664         Exp price;
665         Exp swing;
666         Exp anchorPrice;
667         uint anchorPeriod;
668         uint currentPeriod;
669         bool priceCapped;
670         uint cappingAnchorPriceMantissa;
671         uint pendingAnchorMantissa;
672     }
673 
674     /**
675       * @notice entry point for updating prices
676       * @dev function to set price for an asset
677       * @param asset Asset for which to set the price
678       * @param requestedPriceMantissa requested new price, scaled by 10**18
679       * @return uint 0=success, otherwise a failure (see enum OracleError for details)
680       */
681     function setPrice(address asset, uint requestedPriceMantissa) public returns (uint) {
682         // Fail when msg.sender is not poster
683         if (msg.sender != poster) {
684             return failOracle(asset, OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PRICE_PERMISSION_CHECK);
685         }
686 
687         return setPriceInternal(asset, requestedPriceMantissa);
688     }
689 
690     function setPriceInternal(address asset, uint requestedPriceMantissa) internal returns (uint) {
691         // re-used for intermediate errors
692         Error err;
693         SetPriceLocalVars memory localVars;
694         // We add 1 for currentPeriod so that it can never be zero and there's no ambiguity about an unset value.
695         // (It can be a problem in tests with low block numbers.)
696         localVars.currentPeriod = (block.number / numBlocksPerPeriod) + 1;
697         localVars.pendingAnchorMantissa = pendingAnchors[asset];
698         localVars.price = Exp({mantissa : requestedPriceMantissa});
699 
700         if (readers[asset] != address(0)) {
701             return failOracle(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_IS_READER_ASSET);
702         }
703 
704         if (localVars.pendingAnchorMantissa != 0) {
705             // let's explicitly set to 0 rather than relying on default of declaration
706             localVars.anchorPeriod = 0;
707             localVars.anchorPrice = Exp({mantissa : localVars.pendingAnchorMantissa});
708 
709             // Verify movement is within max swing of pending anchor (currently: 10%)
710             (err, localVars.swing) = calculateSwing(localVars.anchorPrice, localVars.price);
711             if (err != Error.NO_ERROR) {
712                 return failOracleWithDetails(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_CALCULATE_SWING, uint(err));
713             }
714 
715             // Fail when swing > maxSwing
716             if (greaterThanExp(localVars.swing, maxSwing)) {
717                 return failOracleWithDetails(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_MAX_SWING_CHECK, localVars.swing.mantissa);
718             }
719         } else {
720             localVars.anchorPeriod = anchors[asset].period;
721             localVars.anchorPrice = Exp({mantissa : anchors[asset].priceMantissa});
722 
723             if (localVars.anchorPeriod != 0) {
724                 (err, localVars.priceCapped, localVars.price) = capToMax(localVars.anchorPrice, localVars.price);
725                 if (err != Error.NO_ERROR) {
726                     return failOracleWithDetails(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_CAP_TO_MAX, uint(err));
727                 }
728                 if (localVars.priceCapped) {
729                     // save for use in log
730                     localVars.cappingAnchorPriceMantissa = localVars.anchorPrice.mantissa;
731                 }
732             } else {
733                 // Setting first price. Accept as is (already assigned above from requestedPriceMantissa) and use as anchor
734                 localVars.anchorPrice = Exp({mantissa : requestedPriceMantissa});
735             }
736         }
737 
738         // Fail if anchorPrice or price is zero.
739         // zero anchor represents an unexpected situation likely due to a problem in this contract
740         // zero price is more likely as the result of bad input from the caller of this function
741         if (isZeroExp(localVars.anchorPrice)) {
742             // If we get here price could also be zero, but it does not seem worthwhile to distinguish the 3rd case
743             return failOracle(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_NO_ANCHOR_PRICE_OR_INITIAL_PRICE_ZERO);
744         }
745 
746         if (isZeroExp(localVars.price)) {
747             return failOracle(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_ZERO_PRICE);
748         }
749 
750         // BEGIN SIDE EFFECTS
751 
752         // Set pendingAnchor = Nothing
753         // Pending anchor is only used once.
754         if (pendingAnchors[asset] != 0) {
755             pendingAnchors[asset] = 0;
756         }
757 
758         // If currentPeriod > anchorPeriod:
759         //  Set anchors[asset] = (currentPeriod, price)
760         //  The new anchor is if we're in a new period or we had a pending anchor, then we become the new anchor
761         if (localVars.currentPeriod > localVars.anchorPeriod) {
762             anchors[asset] = Anchor({period : localVars.currentPeriod, priceMantissa : localVars.price.mantissa});
763         }
764 
765         uint previousPrice = _assetPrices[asset].mantissa;
766 
767         setPriceStorageInternal(asset, localVars.price.mantissa);
768 
769         emit PricePosted(asset, previousPrice, requestedPriceMantissa, localVars.price.mantissa);
770 
771         if (localVars.priceCapped) {
772             // We have set a capped price. Log it so we can detect the situation and investigate.
773             emit CappedPricePosted(asset, requestedPriceMantissa, localVars.cappingAnchorPriceMantissa, localVars.price.mantissa);
774         }
775 
776         return uint(OracleError.NO_ERROR);
777     }
778 
779     // As a function to allow harness overrides
780     function setPriceStorageInternal(address asset, uint256 priceMantissa) internal {
781         _assetPrices[asset] = Exp({mantissa: priceMantissa});
782     }
783 
784     // abs(price - anchorPrice) / anchorPrice
785     function calculateSwing(Exp memory anchorPrice, Exp memory price) pure internal returns (Error, Exp memory) {
786         Exp memory numerator;
787         Error err;
788 
789         if (greaterThanExp(anchorPrice, price)) {
790             (err, numerator) = subExp(anchorPrice, price);
791             // can't underflow
792             assert(err == Error.NO_ERROR);
793         } else {
794             (err, numerator) = subExp(price, anchorPrice);
795             // Given greaterThan check above, price >= anchorPrice so can't underflow.
796             assert(err == Error.NO_ERROR);
797         }
798 
799         return divExp(numerator, anchorPrice);
800     }
801 
802     function capToMax(Exp memory anchorPrice, Exp memory price) view internal returns (Error, bool, Exp memory) {
803         Exp memory one = Exp({mantissa : mantissaOne});
804         Exp memory onePlusMaxSwing;
805         Exp memory oneMinusMaxSwing;
806         Exp memory max;
807         Exp memory min;
808         // re-used for intermediate errors
809         Error err;
810 
811         (err, onePlusMaxSwing) = addExp(one, maxSwing);
812         if (err != Error.NO_ERROR) {
813             return (err, false, Exp({mantissa : 0}));
814         }
815 
816         // max = anchorPrice * (1 + maxSwing)
817         (err, max) = mulExp(anchorPrice, onePlusMaxSwing);
818         if (err != Error.NO_ERROR) {
819             return (err, false, Exp({mantissa : 0}));
820         }
821 
822         // If price > anchorPrice * (1 + maxSwing)
823         // Set price = anchorPrice * (1 + maxSwing)
824         if (greaterThanExp(price, max)) {
825             return (Error.NO_ERROR, true, max);
826         }
827 
828         (err, oneMinusMaxSwing) = subExp(one, maxSwing);
829         if (err != Error.NO_ERROR) {
830             return (err, false, Exp({mantissa : 0}));
831         }
832 
833         // min = anchorPrice * (1 - maxSwing)
834         (err, min) = mulExp(anchorPrice, oneMinusMaxSwing);
835         // We can't overflow here or we would have already overflowed above when calculating `max`
836         assert(err == Error.NO_ERROR);
837 
838         // If  price < anchorPrice * (1 - maxSwing)
839         // Set price = anchorPrice * (1 - maxSwing)
840         if (lessThanExp(price, min)) {
841             return (Error.NO_ERROR, true, min);
842         }
843 
844         return (Error.NO_ERROR, false, price);
845     }
846 
847     /**
848       * @notice entry point for updating multiple prices
849       * @dev function to set prices for a variable number of assets.
850       * @param assets a list of up to assets for which to set a price. required: 0 < assets.length == requestedPriceMantissas.length
851       * @param requestedPriceMantissas requested new prices for the assets, scaled by 10**18. required: 0 < assets.length == requestedPriceMantissas.length
852       * @return uint values in same order as inputs. For each: 0=success, otherwise a failure (see enum OracleError for details)
853       */
854     function setPrices(address[] assets, uint[] requestedPriceMantissas) public returns (uint[] memory) {
855         uint numAssets = assets.length;
856         uint numPrices = requestedPriceMantissas.length;
857         uint[] memory result;
858 
859         // Fail when msg.sender is not poster
860         if (msg.sender != poster) {
861             result = new uint[](1);
862             result[0] = failOracle(0, OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PRICE_PERMISSION_CHECK);
863             return result;
864         }
865 
866         if ((numAssets == 0) || (numPrices != numAssets)) {
867             result = new uint[](1);
868             result[0] = failOracle(0, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICES_PARAM_VALIDATION);
869             return result;
870         }
871 
872         result = new uint[](numAssets);
873 
874         for (uint i = 0; i < numAssets; i++) {
875             result[i] = setPriceInternal(assets[i], requestedPriceMantissas[i]);
876         }
877 
878         return result;
879     }
880     
881 }