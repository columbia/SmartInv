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
150 contract DSValue {
151     // TODO: View or constant? It's clearly a view...
152     function peek() public view returns (bytes32, bool);
153 
154     function read() public view returns (bytes32);
155 }
156 contract CarefulMath is ErrorReporter {
157 
158     /**
159     * @dev Multiplies two numbers, returns an error on overflow.
160     */
161     function mul(uint a, uint b) internal pure returns (Error, uint) {
162         if (a == 0) {
163             return (Error.NO_ERROR, 0);
164         }
165 
166         uint c = a * b;
167 
168         if (c / a != b) {
169             return (Error.INTEGER_OVERFLOW, 0);
170         } else {
171             return (Error.NO_ERROR, c);
172         }
173     }
174 
175     /**
176     * @dev Integer division of two numbers, truncating the quotient.
177     */
178     function div(uint a, uint b) internal pure returns (Error, uint) {
179         if (b == 0) {
180             return (Error.DIVISION_BY_ZERO, 0);
181         }
182 
183         return (Error.NO_ERROR, a / b);
184     }
185 
186     /**
187     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
188     */
189     function sub(uint a, uint b) internal pure returns (Error, uint) {
190         if (b <= a) {
191             return (Error.NO_ERROR, a - b);
192         } else {
193             return (Error.INTEGER_UNDERFLOW, 0);
194         }
195     }
196 
197     /**
198     * @dev Adds two numbers, returns an error on overflow.
199     */
200     function add(uint a, uint b) internal pure returns (Error, uint) {
201         uint c = a + b;
202 
203         if (c >= a) {
204             return (Error.NO_ERROR, c);
205         } else {
206             return (Error.INTEGER_OVERFLOW, 0);
207         }
208     }
209 
210     /**
211     * @dev add a and b and then subtract c
212     */
213     function addThenSub(uint a, uint b, uint c) internal pure returns (Error, uint) {
214         (Error err0, uint sum) = add(a, b);
215 
216         if (err0 != Error.NO_ERROR) {
217             return (err0, 0);
218         }
219 
220         return sub(sum, c);
221     }
222 }
223 contract Exponential is ErrorReporter, CarefulMath {
224 
225     // TODO: We may wish to put the result of 10**18 here instead of the expression.
226     // Per https://solidity.readthedocs.io/en/latest/contracts.html#constant-state-variables
227     // the optimizer MAY replace the expression 10**18 with its calculated value.
228     uint constant expScale = 10**18;
229 
230     // See TODO on expScale
231     uint constant halfExpScale = expScale/2;
232 
233     struct Exp {
234         uint mantissa;
235     }
236 
237     uint constant mantissaOne = 10**18;
238     uint constant mantissaOneTenth = 10**17;
239 
240     /**
241     * @dev Creates an exponential from numerator and denominator values.
242     *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
243     *            or if `denom` is zero.
244     */
245     function getExp(uint num, uint denom) pure internal returns (Error, Exp memory) {
246         (Error err0, uint scaledNumerator) = mul(num, expScale);
247         if (err0 != Error.NO_ERROR) {
248             return (err0, Exp({mantissa: 0}));
249         }
250 
251         (Error err1, uint rational) = div(scaledNumerator, denom);
252         if (err1 != Error.NO_ERROR) {
253             return (err1, Exp({mantissa: 0}));
254         }
255 
256         return (Error.NO_ERROR, Exp({mantissa: rational}));
257     }
258 
259     /**
260     * @dev Adds two exponentials, returning a new exponential.
261     */
262     function addExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
263         (Error error, uint result) = add(a.mantissa, b.mantissa);
264 
265         return (error, Exp({mantissa: result}));
266     }
267 
268     /**
269     * @dev Subtracts two exponentials, returning a new exponential.
270     */
271     function subExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
272         (Error error, uint result) = sub(a.mantissa, b.mantissa);
273 
274         return (error, Exp({mantissa: result}));
275     }
276 
277     /**
278     * @dev Multiply an Exp by a scalar, returning a new Exp.
279     */
280     function mulScalar(Exp memory a, uint scalar) pure internal returns (Error, Exp memory) {
281         (Error err0, uint scaledMantissa) = mul(a.mantissa, scalar);
282         if (err0 != Error.NO_ERROR) {
283             return (err0, Exp({mantissa: 0}));
284         }
285 
286         return (Error.NO_ERROR, Exp({mantissa: scaledMantissa}));
287     }
288 
289     /**
290     * @dev Divide an Exp by a scalar, returning a new Exp.
291     */
292     function divScalar(Exp memory a, uint scalar) pure internal returns (Error, Exp memory) {
293         (Error err0, uint descaledMantissa) = div(a.mantissa, scalar);
294         if (err0 != Error.NO_ERROR) {
295             return (err0, Exp({mantissa: 0}));
296         }
297 
298         return (Error.NO_ERROR, Exp({mantissa: descaledMantissa}));
299     }
300 
301     /**
302     * @dev Divide a scalar by an Exp, returning a new Exp.
303     */
304     function divScalarByExp(uint scalar, Exp divisor) pure internal returns (Error, Exp memory) {
305         /*
306             We are doing this as:
307             getExp(mul(expScale, scalar), divisor.mantissa)
308 
309             How it works:
310             Exp = a / b;
311             Scalar = s;
312             `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
313         */
314         (Error err0, uint numerator) = mul(expScale, scalar);
315         if (err0 != Error.NO_ERROR) {
316             return (err0, Exp({mantissa: 0}));
317         }
318         return getExp(numerator, divisor.mantissa);
319     }
320 
321     /**
322     * @dev Multiplies two exponentials, returning a new exponential.
323     */
324     function mulExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
325 
326         (Error err0, uint doubleScaledProduct) = mul(a.mantissa, b.mantissa);
327         if (err0 != Error.NO_ERROR) {
328             return (err0, Exp({mantissa: 0}));
329         }
330 
331         // We add half the scale before dividing so that we get rounding instead of truncation.
332         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
333         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
334         (Error err1, uint doubleScaledProductWithHalfScale) = add(halfExpScale, doubleScaledProduct);
335         if (err1 != Error.NO_ERROR) {
336             return (err1, Exp({mantissa: 0}));
337         }
338 
339         (Error err2, uint product) = div(doubleScaledProductWithHalfScale, expScale);
340         // The only error `div` can return is Error.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
341         assert(err2 == Error.NO_ERROR);
342 
343         return (Error.NO_ERROR, Exp({mantissa: product}));
344     }
345 
346     /**
347       * @dev Divides two exponentials, returning a new exponential.
348       *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
349       *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
350       */
351     function divExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
352         return getExp(a.mantissa, b.mantissa);
353     }
354 
355     /**
356       * @dev Truncates the given exp to a whole number value.
357       *      For example, truncate(Exp{mantissa: 15 * (10**18)}) = 15
358       */
359     function truncate(Exp memory exp) pure internal returns (uint) {
360         // Note: We are not using careful math here as we're performing a division that cannot fail
361         return exp.mantissa / 10**18;
362     }
363 
364     /**
365       * @dev Checks if first Exp is less than second Exp.
366       */
367     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
368         return left.mantissa < right.mantissa; //TODO: Add some simple tests and this in another PR yo.
369     }
370 
371     /**
372       * @dev Checks if left Exp <= right Exp.
373       */
374     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
375         return left.mantissa <= right.mantissa;
376     }
377 
378     /**
379       * @dev Checks if first Exp is greater than second Exp.
380       */
381     function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
382         return left.mantissa > right.mantissa;
383     }
384 
385     /**
386       * @dev returns true if Exp is exactly zero
387       */
388     function isZeroExp(Exp memory value) pure internal returns (bool) {
389         return value.mantissa == 0;
390     }
391 }
392 contract PriceOracle is Exponential {
393 
394     /**
395       * @dev flag for whether or not contract is paused
396       *
397       */
398     bool public paused;
399 
400     uint public constant numBlocksPerPeriod = 240; // approximately 1 hour: 60 seconds/minute * 60 minutes/hour * 1 block/15 seconds
401 
402     uint public constant maxSwingMantissa = (10 ** 17); // 0.1
403 
404     /**
405       * @dev Mapping of asset addresses to DSValue price oracle contracts. The price contracts
406       *      should be DSValue contracts whose value is the `eth:asset` price scaled by 1e18.
407       *      That is, 1 eth is worth how much of the asset (e.g. 1 eth = 100 USD). We want
408       *      to know the inverse, which is how much eth is one asset worth. This `asset:eth`
409       *      is the multiplicative inverse (in that example, 1/100). The math is a bit trickier
410       *      since we need to descale the number by 1e18, inverse, and then rescale the number.
411       *      We perform this operation to return the `asset:eth` price for these reader assets.
412       *
413       * map: assetAddress -> DSValue price oracle
414       */
415     mapping(address => DSValue) public readers;
416 
417     /**
418       * @dev Mapping of asset addresses and their corresponding price in terms of Eth-Wei
419       *      which is simply equal to AssetWeiPrice * 10e18. For instance, if OMG token was
420       *      worth 5x Eth then the price for OMG would be 5*10e18 or Exp({mantissa: 5000000000000000000}).
421       * map: assetAddress -> Exp
422       */
423     mapping(address => Exp) public _assetPrices;
424 
425     constructor(address _poster, address addr0, address reader0, address addr1, address reader1) public {
426         anchorAdmin = msg.sender;
427         poster = _poster;
428         maxSwing = Exp({mantissa : maxSwingMantissa});
429 
430         // Make sure the assets are zero or different
431         assert(addr0 == address(0) || (addr0 != addr1));
432 
433         if (addr0 != address(0)) {
434             assert(reader0 != address(0));
435             readers[addr0] = DSValue(reader0);
436         } else {
437             assert(reader0 == address(0));
438         }
439 
440         if (addr1 != address(0)) {
441             assert(reader1 != address(0));
442             readers[addr1] = DSValue(reader1);
443         } else {
444             assert(reader1 == address(0));
445         }
446     }
447 
448     /**
449       * @notice Do not pay into PriceOracle
450       */
451     function() payable public {
452         revert();
453     }
454 
455     enum OracleError {
456         NO_ERROR,
457         UNAUTHORIZED,
458         FAILED_TO_SET_PRICE
459     }
460 
461     enum OracleFailureInfo {
462         ACCEPT_ANCHOR_ADMIN_PENDING_ANCHOR_ADMIN_CHECK,
463         SET_PAUSED_OWNER_CHECK,
464         SET_PENDING_ANCHOR_ADMIN_OWNER_CHECK,
465         SET_PENDING_ANCHOR_PERMISSION_CHECK,
466         SET_PRICE_CALCULATE_SWING,
467         SET_PRICE_CAP_TO_MAX,
468         SET_PRICE_MAX_SWING_CHECK,
469         SET_PRICE_NO_ANCHOR_PRICE_OR_INITIAL_PRICE_ZERO,
470         SET_PRICE_PERMISSION_CHECK,
471         SET_PRICE_ZERO_PRICE,
472         SET_PRICES_PARAM_VALIDATION,
473         SET_PRICE_IS_READER_ASSET
474     }
475 
476     /**
477       * @dev `msgSender` is msg.sender; `error` corresponds to enum OracleError; `info` corresponds to enum OracleFailureInfo, and `detail` is an arbitrary
478       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
479       **/
480     event OracleFailure(address msgSender, address asset, uint error, uint info, uint detail);
481 
482     /**
483       * @dev use this when reporting a known error from the price oracle or a non-upgradeable collaborator
484       *      Using Oracle in name because we already inherit a `fail` function from ErrorReporter.sol via Exponential.sol
485       */
486     function failOracle(address asset, OracleError err, OracleFailureInfo info) internal returns (uint) {
487         emit OracleFailure(msg.sender, asset, uint(err), uint(info), 0);
488 
489         return uint(err);
490     }
491 
492     /**
493       * @dev Use this when reporting an error from the money market. Give the money market result as `details`
494       */
495     function failOracleWithDetails(address asset, OracleError err, OracleFailureInfo info, uint details) internal returns (uint) {
496         emit OracleFailure(msg.sender, asset, uint(err), uint(info), details);
497 
498         return uint(err);
499     }
500 
501     /**
502       * @dev An administrator who can set the pending anchor value for assets.
503       *      Set in the constructor.
504       */
505     address public anchorAdmin;
506 
507     /**
508       * @dev pending anchor administrator for this contract.
509       */
510     address public pendingAnchorAdmin;
511 
512     /**
513       * @dev Address of the price poster.
514       *      Set in the constructor.
515       */
516     address public poster;
517 
518     /**
519       * @dev maxSwing the maximum allowed percentage difference between a new price and the anchor's price
520       *      Set only in the constructor
521       */
522     Exp public maxSwing;
523 
524     struct Anchor {
525         // floor(block.number / numBlocksPerPeriod) + 1
526         uint period;
527 
528         // Price in ETH, scaled by 10**18
529         uint priceMantissa;
530     }
531 
532     /**
533       * @dev anchors by asset
534       */
535     mapping(address => Anchor) public anchors;
536 
537     /**
538       * @dev pending anchor prices by asset
539       */
540     mapping(address => uint) public pendingAnchors;
541 
542     /**
543       * @dev emitted when a pending anchor is set
544       * @param asset Asset for which to set a pending anchor
545       * @param oldScaledPrice if an unused pending anchor was present, its value; otherwise 0.
546       * @param newScaledPrice the new scaled pending anchor price
547       */
548     event NewPendingAnchor(address anchorAdmin, address asset, uint oldScaledPrice, uint newScaledPrice);
549 
550     /**
551       * @notice provides ability to override the anchor price for an asset
552       * @dev Admin function to set the anchor price for an asset
553       * @param asset Asset for which to override the anchor price
554       * @param newScaledPrice New anchor price
555       * @return uint 0=success, otherwise a failure (see enum OracleError for details)
556       */
557     function _setPendingAnchor(address asset, uint newScaledPrice) public returns (uint) {
558         // Check caller = anchorAdmin. Note: Deliberately not allowing admin. They can just change anchorAdmin if desired.
559         if (msg.sender != anchorAdmin) {
560             return failOracle(asset, OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PENDING_ANCHOR_PERMISSION_CHECK);
561         }
562 
563         uint oldScaledPrice = pendingAnchors[asset];
564         pendingAnchors[asset] = newScaledPrice;
565 
566         emit NewPendingAnchor(msg.sender, asset, oldScaledPrice, newScaledPrice);
567 
568         return uint(OracleError.NO_ERROR);
569     }
570 
571     /**
572       * @dev emitted for all price changes
573       */
574     event PricePosted(address asset, uint previousPriceMantissa, uint requestedPriceMantissa, uint newPriceMantissa);
575 
576     /**
577       * @dev emitted if this contract successfully posts a capped-to-max price to the money market
578       */
579     event CappedPricePosted(address asset, uint requestedPriceMantissa, uint anchorPriceMantissa, uint cappedPriceMantissa);
580 
581     /**
582       * @dev emitted when admin either pauses or resumes the contract; newState is the resulting state
583       */
584     event SetPaused(bool newState);
585 
586     /**
587       * @dev emitted when pendingAnchorAdmin is changed
588       */
589     event NewPendingAnchorAdmin(address oldPendingAnchorAdmin, address newPendingAnchorAdmin);
590 
591     /**
592       * @dev emitted when pendingAnchorAdmin is accepted, which means anchor admin is updated
593       */
594     event NewAnchorAdmin(address oldAnchorAdmin, address newAnchorAdmin);
595 
596     /**
597       * @notice set `paused` to the specified state
598       * @dev Admin function to pause or resume the market
599       * @param requestedState value to assign to `paused`
600       * @return uint 0=success, otherwise a failure
601       */
602     function _setPaused(bool requestedState) public returns (uint) {
603         // Check caller = anchorAdmin
604         if (msg.sender != anchorAdmin) {
605             return failOracle(0, OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PAUSED_OWNER_CHECK);
606         }
607 
608         paused = requestedState;
609         emit SetPaused(requestedState);
610 
611         return uint(Error.NO_ERROR);
612     }
613 
614     /**
615       * @notice Begins transfer of anchor admin rights. The newPendingAnchorAdmin must call `_acceptAnchorAdmin` to finalize the transfer.
616       * @dev Admin function to begin change of anchor admin. The newPendingAnchorAdmin must call `_acceptAnchorAdmin` to finalize the transfer.
617       * @param newPendingAnchorAdmin New pending anchor admin.
618       * @return uint 0=success, otherwise a failure
619       *
620       * TODO: Should we add a second arg to verify, like a checksum of `newAnchorAdmin` address?
621       */
622     function _setPendingAnchorAdmin(address newPendingAnchorAdmin) public returns (uint) {
623         // Check caller = anchorAdmin
624         if (msg.sender != anchorAdmin) {
625             return failOracle(0, OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PENDING_ANCHOR_ADMIN_OWNER_CHECK);
626         }
627 
628         // save current value, if any, for inclusion in log
629         address oldPendingAnchorAdmin = pendingAnchorAdmin;
630         // Store pendingAdmin = newPendingAdmin
631         pendingAnchorAdmin = newPendingAnchorAdmin;
632 
633         emit NewPendingAnchorAdmin(oldPendingAnchorAdmin, newPendingAnchorAdmin);
634 
635         return uint(Error.NO_ERROR);
636     }
637 
638     /**
639       * @notice Accepts transfer of anchor admin rights. msg.sender must be pendingAnchorAdmin
640       * @dev Admin function for pending anchor admin to accept role and update anchor admin
641       * @return uint 0=success, otherwise a failure
642       */
643     function _acceptAnchorAdmin() public returns (uint) {
644         // Check caller = pendingAnchorAdmin
645         // msg.sender can't be zero
646         if (msg.sender != pendingAnchorAdmin) {
647             return failOracle(0, OracleError.UNAUTHORIZED, OracleFailureInfo.ACCEPT_ANCHOR_ADMIN_PENDING_ANCHOR_ADMIN_CHECK);
648         }
649 
650         // Save current value for inclusion in log
651         address oldAnchorAdmin = anchorAdmin;
652         // Store admin = pendingAnchorAdmin
653         anchorAdmin = pendingAnchorAdmin;
654         // Clear the pending value
655         pendingAnchorAdmin = 0;
656 
657         emit NewAnchorAdmin(oldAnchorAdmin, msg.sender);
658 
659         return uint(Error.NO_ERROR);
660     }
661 
662     /**
663       * @notice retrieves price of an asset
664       * @dev function to get price for an asset
665       * @param asset Asset for which to get the price
666       * @return uint mantissa of asset price (scaled by 1e18) or zero if unset or contract paused
667       */
668     function assetPrices(address asset) public view returns (uint) {
669         // Note: zero is treated by the money market as an invalid
670         //       price and will cease operations with that asset
671         //       when zero.
672         //
673         // We get the price as:
674         //
675         //  1. If the contract is paused, return 0.
676         //  2. If the asset is a reader asset:
677         //    a. If the reader has a value set, invert it and return.
678         //    b. Else, return 0.
679         //  3. Return price in `_assetPrices`, which may be zero.
680 
681         if (paused) {
682             return 0;
683         } else {
684             if (readers[asset] != address(0)) {
685                 (bytes32 readValue, bool foundValue) = readers[asset].peek();
686 
687                 if (foundValue) {
688                     (Error error, Exp memory invertedVal) = getExp(mantissaOne, uint256(readValue));
689 
690                     if (error != Error.NO_ERROR) {
691                         return 0;
692                     }
693 
694                     return invertedVal.mantissa;
695                 } else {
696                     return 0;
697                 }
698             } else {
699                 return _assetPrices[asset].mantissa;
700             }
701         }
702     }
703 
704     /**
705       * @notice retrieves price of an asset
706       * @dev function to get price for an asset
707       * @param asset Asset for which to get the price
708       * @return uint mantissa of asset price (scaled by 1e18) or zero if unset or contract paused
709       */
710     function getPrice(address asset) public view returns (uint) {
711         return assetPrices(asset);
712     }
713 
714     struct SetPriceLocalVars {
715         Exp price;
716         Exp swing;
717         Exp anchorPrice;
718         uint anchorPeriod;
719         uint currentPeriod;
720         bool priceCapped;
721         uint cappingAnchorPriceMantissa;
722         uint pendingAnchorMantissa;
723     }
724 
725     /**
726       * @notice entry point for updating prices
727       * @dev function to set price for an asset
728       * @param asset Asset for which to set the price
729       * @param requestedPriceMantissa requested new price, scaled by 10**18
730       * @return uint 0=success, otherwise a failure (see enum OracleError for details)
731       */
732     function setPrice(address asset, uint requestedPriceMantissa) public returns (uint) {
733         // Fail when msg.sender is not poster
734         if (msg.sender != poster) {
735             return failOracle(asset, OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PRICE_PERMISSION_CHECK);
736         }
737 
738         return setPriceInternal(asset, requestedPriceMantissa);
739     }
740 
741     function setPriceInternal(address asset, uint requestedPriceMantissa) internal returns (uint) {
742         // re-used for intermediate errors
743         Error err;
744         SetPriceLocalVars memory localVars;
745         // We add 1 for currentPeriod so that it can never be zero and there's no ambiguity about an unset value.
746         // (It can be a problem in tests with low block numbers.)
747         localVars.currentPeriod = (block.number / numBlocksPerPeriod) + 1;
748         localVars.pendingAnchorMantissa = pendingAnchors[asset];
749         localVars.price = Exp({mantissa : requestedPriceMantissa});
750 
751         if (readers[asset] != address(0)) {
752             return failOracle(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_IS_READER_ASSET);
753         }
754 
755         if (localVars.pendingAnchorMantissa != 0) {
756             // let's explicitly set to 0 rather than relying on default of declaration
757             localVars.anchorPeriod = 0;
758             localVars.anchorPrice = Exp({mantissa : localVars.pendingAnchorMantissa});
759 
760             // Verify movement is within max swing of pending anchor (currently: 10%)
761             (err, localVars.swing) = calculateSwing(localVars.anchorPrice, localVars.price);
762             if (err != Error.NO_ERROR) {
763                 return failOracleWithDetails(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_CALCULATE_SWING, uint(err));
764             }
765 
766             // Fail when swing > maxSwing
767             if (greaterThanExp(localVars.swing, maxSwing)) {
768                 return failOracleWithDetails(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_MAX_SWING_CHECK, localVars.swing.mantissa);
769             }
770         } else {
771             localVars.anchorPeriod = anchors[asset].period;
772             localVars.anchorPrice = Exp({mantissa : anchors[asset].priceMantissa});
773 
774             if (localVars.anchorPeriod != 0) {
775                 (err, localVars.priceCapped, localVars.price) = capToMax(localVars.anchorPrice, localVars.price);
776                 if (err != Error.NO_ERROR) {
777                     return failOracleWithDetails(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_CAP_TO_MAX, uint(err));
778                 }
779                 if (localVars.priceCapped) {
780                     // save for use in log
781                     localVars.cappingAnchorPriceMantissa = localVars.anchorPrice.mantissa;
782                 }
783             } else {
784                 // Setting first price. Accept as is (already assigned above from requestedPriceMantissa) and use as anchor
785                 localVars.anchorPrice = Exp({mantissa : requestedPriceMantissa});
786             }
787         }
788 
789         // Fail if anchorPrice or price is zero.
790         // zero anchor represents an unexpected situation likely due to a problem in this contract
791         // zero price is more likely as the result of bad input from the caller of this function
792         if (isZeroExp(localVars.anchorPrice)) {
793             // If we get here price could also be zero, but it does not seem worthwhile to distinguish the 3rd case
794             return failOracle(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_NO_ANCHOR_PRICE_OR_INITIAL_PRICE_ZERO);
795         }
796 
797         if (isZeroExp(localVars.price)) {
798             return failOracle(asset, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICE_ZERO_PRICE);
799         }
800 
801         // BEGIN SIDE EFFECTS
802 
803         // Set pendingAnchor = Nothing
804         // Pending anchor is only used once.
805         if (pendingAnchors[asset] != 0) {
806             pendingAnchors[asset] = 0;
807         }
808 
809         // If currentPeriod > anchorPeriod:
810         //  Set anchors[asset] = (currentPeriod, price)
811         //  The new anchor is if we're in a new period or we had a pending anchor, then we become the new anchor
812         if (localVars.currentPeriod > localVars.anchorPeriod) {
813             anchors[asset] = Anchor({period : localVars.currentPeriod, priceMantissa : localVars.price.mantissa});
814         }
815 
816         uint previousPrice = _assetPrices[asset].mantissa;
817 
818         setPriceStorageInternal(asset, localVars.price.mantissa);
819 
820         emit PricePosted(asset, previousPrice, requestedPriceMantissa, localVars.price.mantissa);
821 
822         if (localVars.priceCapped) {
823             // We have set a capped price. Log it so we can detect the situation and investigate.
824             emit CappedPricePosted(asset, requestedPriceMantissa, localVars.cappingAnchorPriceMantissa, localVars.price.mantissa);
825         }
826 
827         return uint(OracleError.NO_ERROR);
828     }
829 
830     // As a function to allow harness overrides
831     function setPriceStorageInternal(address asset, uint256 priceMantissa) internal {
832         _assetPrices[asset] = Exp({mantissa: priceMantissa});
833     }
834 
835     // abs(price - anchorPrice) / anchorPrice
836     function calculateSwing(Exp memory anchorPrice, Exp memory price) pure internal returns (Error, Exp memory) {
837         Exp memory numerator;
838         Error err;
839 
840         if (greaterThanExp(anchorPrice, price)) {
841             (err, numerator) = subExp(anchorPrice, price);
842             // can't underflow
843             assert(err == Error.NO_ERROR);
844         } else {
845             (err, numerator) = subExp(price, anchorPrice);
846             // Given greaterThan check above, price >= anchorPrice so can't underflow.
847             assert(err == Error.NO_ERROR);
848         }
849 
850         return divExp(numerator, anchorPrice);
851     }
852 
853     function capToMax(Exp memory anchorPrice, Exp memory price) view internal returns (Error, bool, Exp memory) {
854         Exp memory one = Exp({mantissa : mantissaOne});
855         Exp memory onePlusMaxSwing;
856         Exp memory oneMinusMaxSwing;
857         Exp memory max;
858         Exp memory min;
859         // re-used for intermediate errors
860         Error err;
861 
862         (err, onePlusMaxSwing) = addExp(one, maxSwing);
863         if (err != Error.NO_ERROR) {
864             return (err, false, Exp({mantissa : 0}));
865         }
866 
867         // max = anchorPrice * (1 + maxSwing)
868         (err, max) = mulExp(anchorPrice, onePlusMaxSwing);
869         if (err != Error.NO_ERROR) {
870             return (err, false, Exp({mantissa : 0}));
871         }
872 
873         // If price > anchorPrice * (1 + maxSwing)
874         // Set price = anchorPrice * (1 + maxSwing)
875         if (greaterThanExp(price, max)) {
876             return (Error.NO_ERROR, true, max);
877         }
878 
879         (err, oneMinusMaxSwing) = subExp(one, maxSwing);
880         if (err != Error.NO_ERROR) {
881             return (err, false, Exp({mantissa : 0}));
882         }
883 
884         // min = anchorPrice * (1 - maxSwing)
885         (err, min) = mulExp(anchorPrice, oneMinusMaxSwing);
886         // We can't overflow here or we would have already overflowed above when calculating `max`
887         assert(err == Error.NO_ERROR);
888 
889         // If  price < anchorPrice * (1 - maxSwing)
890         // Set price = anchorPrice * (1 - maxSwing)
891         if (lessThanExp(price, min)) {
892             return (Error.NO_ERROR, true, min);
893         }
894 
895         return (Error.NO_ERROR, false, price);
896     }
897 
898     /**
899       * @notice entry point for updating multiple prices
900       * @dev function to set prices for a variable number of assets.
901       * @param assets a list of up to assets for which to set a price. required: 0 < assets.length == requestedPriceMantissas.length
902       * @param requestedPriceMantissas requested new prices for the assets, scaled by 10**18. required: 0 < assets.length == requestedPriceMantissas.length
903       * @return uint values in same order as inputs. For each: 0=success, otherwise a failure (see enum OracleError for details)
904       */
905     function setPrices(address[] assets, uint[] requestedPriceMantissas) public returns (uint[] memory) {
906         uint numAssets = assets.length;
907         uint numPrices = requestedPriceMantissas.length;
908         uint[] memory result;
909 
910         // Fail when msg.sender is not poster
911         if (msg.sender != poster) {
912             result = new uint[](1);
913             result[0] = failOracle(0, OracleError.UNAUTHORIZED, OracleFailureInfo.SET_PRICE_PERMISSION_CHECK);
914             return result;
915         }
916 
917         if ((numAssets == 0) || (numPrices != numAssets)) {
918             result = new uint[](1);
919             result[0] = failOracle(0, OracleError.FAILED_TO_SET_PRICE, OracleFailureInfo.SET_PRICES_PARAM_VALIDATION);
920             return result;
921         }
922 
923         result = new uint[](numAssets);
924 
925         for (uint i = 0; i < numAssets; i++) {
926             result[i] = setPriceInternal(assets[i], requestedPriceMantissas[i]);
927         }
928 
929         return result;
930     }
931 }