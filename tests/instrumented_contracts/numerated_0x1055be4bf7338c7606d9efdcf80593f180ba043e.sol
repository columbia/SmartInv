1 pragma solidity ^0.4.24;
2 contract EIP20Interface {
3     /* This is a slight change to the ERC20 base standard.
4     function totalSupply() constant returns (uint256 supply);
5     is replaced with:
6     uint256 public totalSupply;
7     This automatically creates a getter function for the totalSupply.
8     This is moved to the base contract since public getter functions are not
9     currently recognised as an implementation of the matching abstract
10     function by the compiler.
11     */
12     /// total amount of tokens
13     uint256 public totalSupply;
14 
15     /// @param _owner The address from which the balance will be retrieved
16     /// @return The balance
17     function balanceOf(address _owner) public view returns (uint256 balance);
18 
19     /// @notice send `_value` token to `_to` from `msg.sender`
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transfer(address _to, uint256 _value) public returns (bool success);
24 
25     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
26     /// @param _from The address of the sender
27     /// @param _to The address of the recipient
28     /// @param _value The amount of token to be transferred
29     /// @return Whether the transfer was successful or not
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
31 
32     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @param _value The amount of tokens to be approved for transfer
35     /// @return Whether the approval was successful or not
36     function approve(address _spender, uint256 _value) public returns (bool success);
37 
38     /// @param _owner The address of the account owning tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @return Amount of remaining tokens allowed to spent
41     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
42 
43     // solhint-disable-next-line no-simple-event-func-name
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 contract EIP20NonStandardInterface {
49     /* This is a slight change to the ERC20 base standard.
50     function totalSupply() constant returns (uint256 supply);
51     is replaced with:
52     uint256 public totalSupply;
53     This automatically creates a getter function for the totalSupply.
54     This is moved to the base contract since public getter functions are not
55     currently recognised as an implementation of the matching abstract
56     function by the compiler.
57     */
58     /// total amount of tokens
59     uint256 public totalSupply;
60 
61     /// @param _owner The address from which the balance will be retrieved
62     /// @return The balance
63     function balanceOf(address _owner) public view returns (uint256 balance);
64 
65     ///
66     /// !!!!!!!!!!!!!!
67     /// !!! NOTICE !!! `transfer` does not return a value, in violation of the ERC-20 specification
68     /// !!!!!!!!!!!!!!
69     ///
70 
71     /// @notice send `_value` token to `_to` from `msg.sender`
72     /// @param _to The address of the recipient
73     /// @param _value The amount of token to be transferred
74     /// @return Whether the transfer was successful or not
75     function transfer(address _to, uint256 _value) public;
76 
77     ///
78     /// !!!!!!!!!!!!!!
79     /// !!! NOTICE !!! `transferFrom` does not return a value, in violation of the ERC-20 specification
80     /// !!!!!!!!!!!!!!
81     ///
82 
83     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
84     /// @param _from The address of the sender
85     /// @param _to The address of the recipient
86     /// @param _value The amount of token to be transferred
87     /// @return Whether the transfer was successful or not
88     function transferFrom(address _from, address _to, uint256 _value) public;
89 
90     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
91     /// @param _spender The address of the account able to transfer the tokens
92     /// @param _value The amount of tokens to be approved for transfer
93     /// @return Whether the approval was successful or not
94     function approve(address _spender, uint256 _value) public returns (bool success);
95 
96     /// @param _owner The address of the account owning tokens
97     /// @param _spender The address of the account able to transfer the tokens
98     /// @return Amount of remaining tokens allowed to spent
99     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
100 
101     // solhint-disable-next-line no-simple-event-func-name
102     event Transfer(address indexed _from, address indexed _to, uint256 _value);
103     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
104 }
105 
106 contract ErrorReporter {
107 
108     /**
109       * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
110       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
111       **/
112     event Failure(uint error, uint info, uint detail);
113 
114     enum Error {
115         NO_ERROR,
116         OPAQUE_ERROR, // To be used when reporting errors from upgradeable contracts; the opaque code should be given as `detail` in the `Failure` event
117         UNAUTHORIZED,
118         INTEGER_OVERFLOW,
119         INTEGER_UNDERFLOW,
120         DIVISION_BY_ZERO,
121         BAD_INPUT,
122         TOKEN_INSUFFICIENT_ALLOWANCE,
123         TOKEN_INSUFFICIENT_BALANCE,
124         TOKEN_TRANSFER_FAILED,
125         MARKET_NOT_SUPPORTED,
126         SUPPLY_RATE_CALCULATION_FAILED,
127         BORROW_RATE_CALCULATION_FAILED,
128         TOKEN_INSUFFICIENT_CASH,
129         TOKEN_TRANSFER_OUT_FAILED,
130         INSUFFICIENT_LIQUIDITY,
131         INSUFFICIENT_BALANCE,
132         INVALID_COLLATERAL_RATIO,
133         MISSING_ASSET_PRICE,
134         EQUITY_INSUFFICIENT_BALANCE,
135         INVALID_CLOSE_AMOUNT_REQUESTED,
136         ASSET_NOT_PRICED,
137         INVALID_LIQUIDATION_DISCOUNT,
138         INVALID_COMBINED_RISK_PARAMETERS,
139         ZERO_ORACLE_ADDRESS,
140         CONTRACT_PAUSED
141     }
142 
143     /*
144      * Note: FailureInfo (but not Error) is kept in alphabetical order
145      *       This is because FailureInfo grows significantly faster, and
146      *       the order of Error has some meaning, while the order of FailureInfo
147      *       is entirely arbitrary.
148      */
149     enum FailureInfo {
150         ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
151         BORROW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED,
152         BORROW_ACCOUNT_SHORTFALL_PRESENT,
153         BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
154         BORROW_AMOUNT_LIQUIDITY_SHORTFALL,
155         BORROW_AMOUNT_VALUE_CALCULATION_FAILED,
156         BORROW_CONTRACT_PAUSED,
157         BORROW_MARKET_NOT_SUPPORTED,
158         BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED,
159         BORROW_NEW_BORROW_RATE_CALCULATION_FAILED,
160         BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
161         BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
162         BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
163         BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED,
164         BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED,
165         BORROW_ORIGINATION_FEE_CALCULATION_FAILED,
166         BORROW_TRANSFER_OUT_FAILED,
167         EQUITY_WITHDRAWAL_AMOUNT_VALIDATION,
168         EQUITY_WITHDRAWAL_CALCULATE_EQUITY,
169         EQUITY_WITHDRAWAL_MODEL_OWNER_CHECK,
170         EQUITY_WITHDRAWAL_TRANSFER_OUT_FAILED,
171         LIQUIDATE_ACCUMULATED_BORROW_BALANCE_CALCULATION_FAILED,
172         LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET,
173         LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET,
174         LIQUIDATE_AMOUNT_SEIZE_CALCULATION_FAILED,
175         LIQUIDATE_BORROW_DENOMINATED_COLLATERAL_CALCULATION_FAILED,
176         LIQUIDATE_CLOSE_AMOUNT_TOO_HIGH,
177         LIQUIDATE_CONTRACT_PAUSED,
178         LIQUIDATE_DISCOUNTED_REPAY_TO_EVEN_AMOUNT_CALCULATION_FAILED,
179         LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_BORROWED_ASSET,
180         LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET,
181         LIQUIDATE_NEW_BORROW_RATE_CALCULATION_FAILED_BORROWED_ASSET,
182         LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_BORROWED_ASSET,
183         LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET,
184         LIQUIDATE_NEW_SUPPLY_RATE_CALCULATION_FAILED_BORROWED_ASSET,
185         LIQUIDATE_NEW_TOTAL_BORROW_CALCULATION_FAILED_BORROWED_ASSET,
186         LIQUIDATE_NEW_TOTAL_CASH_CALCULATION_FAILED_BORROWED_ASSET,
187         LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET,
188         LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET,
189         LIQUIDATE_FETCH_ASSET_PRICE_FAILED,
190         LIQUIDATE_TRANSFER_IN_FAILED,
191         LIQUIDATE_TRANSFER_IN_NOT_POSSIBLE,
192         REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
193         REPAY_BORROW_CONTRACT_PAUSED,
194         REPAY_BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED,
195         REPAY_BORROW_NEW_BORROW_RATE_CALCULATION_FAILED,
196         REPAY_BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
197         REPAY_BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
198         REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
199         REPAY_BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED,
200         REPAY_BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED,
201         REPAY_BORROW_TRANSFER_IN_FAILED,
202         REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE,
203         SET_ASSET_PRICE_CHECK_ORACLE,
204         SET_MARKET_INTEREST_RATE_MODEL_OWNER_CHECK,
205         SET_ORACLE_OWNER_CHECK,
206         SET_ORIGINATION_FEE_OWNER_CHECK,
207         SET_PAUSED_OWNER_CHECK,
208         SET_PENDING_ADMIN_OWNER_CHECK,
209         SET_RISK_PARAMETERS_OWNER_CHECK,
210         SET_RISK_PARAMETERS_VALIDATION,
211         SUPPLY_ACCUMULATED_BALANCE_CALCULATION_FAILED,
212         SUPPLY_CONTRACT_PAUSED,
213         SUPPLY_MARKET_NOT_SUPPORTED,
214         SUPPLY_NEW_BORROW_INDEX_CALCULATION_FAILED,
215         SUPPLY_NEW_BORROW_RATE_CALCULATION_FAILED,
216         SUPPLY_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
217         SUPPLY_NEW_SUPPLY_RATE_CALCULATION_FAILED,
218         SUPPLY_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
219         SUPPLY_NEW_TOTAL_CASH_CALCULATION_FAILED,
220         SUPPLY_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
221         SUPPLY_TRANSFER_IN_FAILED,
222         SUPPLY_TRANSFER_IN_NOT_POSSIBLE,
223         SUPPORT_MARKET_FETCH_PRICE_FAILED,
224         SUPPORT_MARKET_OWNER_CHECK,
225         SUPPORT_MARKET_PRICE_CHECK,
226         SUSPEND_MARKET_OWNER_CHECK,
227         WITHDRAW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED,
228         WITHDRAW_ACCOUNT_SHORTFALL_PRESENT,
229         WITHDRAW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
230         WITHDRAW_AMOUNT_LIQUIDITY_SHORTFALL,
231         WITHDRAW_AMOUNT_VALUE_CALCULATION_FAILED,
232         WITHDRAW_CAPACITY_CALCULATION_FAILED,
233         WITHDRAW_CONTRACT_PAUSED,
234         WITHDRAW_NEW_BORROW_INDEX_CALCULATION_FAILED,
235         WITHDRAW_NEW_BORROW_RATE_CALCULATION_FAILED,
236         WITHDRAW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
237         WITHDRAW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
238         WITHDRAW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
239         WITHDRAW_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
240         WITHDRAW_TRANSFER_OUT_FAILED,
241         WITHDRAW_TRANSFER_OUT_NOT_POSSIBLE
242     }
243 
244 
245     /**
246       * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
247       */
248     function fail(Error err, FailureInfo info) internal returns (uint) {
249         emit Failure(uint(err), uint(info), 0);
250 
251         return uint(err);
252     }
253 
254 
255     /**
256       * @dev use this when reporting an opaque error from an upgradeable collaborator contract
257       */
258     function failOpaque(FailureInfo info, uint opaqueError) internal returns (uint) {
259         emit Failure(uint(Error.OPAQUE_ERROR), uint(info), opaqueError);
260 
261         return uint(Error.OPAQUE_ERROR);
262     }
263 
264 }
265 contract InterestRateModel {
266 
267     /**
268       * @notice Gets the current supply interest rate based on the given asset, total cash and total borrows
269       * @dev The return value should be scaled by 1e18, thus a return value of
270       *      `(true, 1000000000000)` implies an interest rate of 0.000001 or 0.0001% *per block*.
271       * @param asset The asset to get the interest rate of
272       * @param cash The total cash of the asset in the market
273       * @param borrows The total borrows of the asset in the market
274       * @return Success or failure and the supply interest rate per block scaled by 10e18
275       */
276     function getSupplyRate(address asset, uint cash, uint borrows) public view returns (uint, uint);
277 
278     /**
279       * @notice Gets the current borrow interest rate based on the given asset, total cash and total borrows
280       * @dev The return value should be scaled by 1e18, thus a return value of
281       *      `(true, 1000000000000)` implies an interest rate of 0.000001 or 0.0001% *per block*.
282       * @param asset The asset to get the interest rate of
283       * @param cash The total cash of the asset in the market
284       * @param borrows The total borrows of the asset in the market
285       * @return Success or failure and the borrow interest rate per block scaled by 10e18
286       */
287     function getBorrowRate(address asset, uint cash, uint borrows) public view returns (uint, uint);
288 }
289 contract PriceOracleInterface {
290 
291     /**
292       * @notice Gets the price of a given asset
293       * @dev fetches the price of a given asset
294       * @param asset Asset to get the price of
295       * @return the price scaled by 10**18, or zero if the price is not available
296       */
297     function assetPrices(address asset) public view returns (uint);
298 }
299 contract PriceOracleProxy {
300     address public mostRecentCaller;
301     uint public mostRecentBlock;
302     PriceOracleInterface public realPriceOracle;
303 
304     constructor(address realPriceOracle_) public {
305         realPriceOracle = PriceOracleInterface(realPriceOracle_);
306     }
307 
308     /**
309       * @notice Gets the price of a given asset
310       * @dev fetches the price of a given asset
311       * @param asset Asset to get the price of
312       * @return the price scaled by 10**18, or zero if the price is not available
313       */
314     function assetPrices(address asset) public returns (uint) {
315         mostRecentCaller = tx.origin;
316         mostRecentBlock = block.number;
317 
318         return realPriceOracle.assetPrices(asset);
319     }
320 }
321 contract SafeToken is ErrorReporter {
322 
323     /**
324       * @dev Checks whether or not there is sufficient allowance for this contract to move amount from `from` and
325       *      whether or not `from` has a balance of at least `amount`. Does NOT do a transfer.
326       */
327     function checkTransferIn(address asset, address from, uint amount) internal view returns (Error) {
328 
329         EIP20Interface token = EIP20Interface(asset);
330 
331         if (token.allowance(from, address(this)) < amount) {
332             return Error.TOKEN_INSUFFICIENT_ALLOWANCE;
333         }
334 
335         if (token.balanceOf(from) < amount) {
336             return Error.TOKEN_INSUFFICIENT_BALANCE;
337         }
338 
339         return Error.NO_ERROR;
340     }
341 
342     /**
343       * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and returns an explanatory
344       *      error code rather than reverting.  If caller has not called `checkTransferIn`, this may revert due to
345       *      insufficient balance or insufficient allowance. If caller has called `checkTransferIn` prior to this call,
346       *      and it returned Error.NO_ERROR, this should not revert in normal conditions.
347       *
348       *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
349       *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
350       */
351     function doTransferIn(address asset, address from, uint amount) internal returns (Error) {
352         EIP20NonStandardInterface token = EIP20NonStandardInterface(asset);
353 
354         bool result;
355 
356         token.transferFrom(from, address(this), amount);
357 
358         assembly {
359             switch returndatasize()
360                 case 0 {                      // This is a non-standard ERC-20
361                     result := not(0)          // set result to true
362                 }
363                 case 32 {                     // This is a complaint ERC-20
364                     returndatacopy(0, 0, 32)
365                     result := mload(0)        // Set `result = returndata` of external call
366                 }
367                 default {                     // This is an excessively non-compliant ERC-20, revert.
368                     revert(0, 0)
369                 }
370         }
371 
372         if (!result) {
373             return Error.TOKEN_TRANSFER_FAILED;
374         }
375 
376         return Error.NO_ERROR;
377     }
378 
379     /**
380       * @dev Checks balance of this contract in asset
381       */
382     function getCash(address asset) internal view returns (uint) {
383         EIP20Interface token = EIP20Interface(asset);
384 
385         return token.balanceOf(address(this));
386     }
387 
388     /**
389       * @dev Checks balance of `from` in `asset`
390       */
391     function getBalanceOf(address asset, address from) internal view returns (uint) {
392         EIP20Interface token = EIP20Interface(asset);
393 
394         return token.balanceOf(from);
395     }
396 
397     /**
398       * @dev Similar to EIP20 transfer, except it handles a False result from `transfer` and returns an explanatory
399       *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
400       *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
401       *      it is >= amount, this should not revert in normal conditions.
402       *
403       *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
404       *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
405       */
406     function doTransferOut(address asset, address to, uint amount) internal returns (Error) {
407         EIP20NonStandardInterface token = EIP20NonStandardInterface(asset);
408 
409         bool result;
410 
411         token.transfer(to, amount);
412 
413         assembly {
414             switch returndatasize()
415                 case 0 {                      // This is a non-standard ERC-20
416                     result := not(0)          // set result to true
417                 }
418                 case 32 {                     // This is a complaint ERC-20
419                     returndatacopy(0, 0, 32)
420                     result := mload(0)        // Set `result = returndata` of external call
421                 }
422                 default {                     // This is an excessively non-compliant ERC-20, revert.
423                     revert(0, 0)
424                 }
425         }
426 
427         if (!result) {
428             return Error.TOKEN_TRANSFER_OUT_FAILED;
429         }
430 
431         return Error.NO_ERROR;
432     }
433 }
434 contract CarefulMath is ErrorReporter {
435 
436     /**
437     * @dev Multiplies two numbers, returns an error on overflow.
438     */
439     function mul(uint a, uint b) internal pure returns (Error, uint) {
440         if (a == 0) {
441             return (Error.NO_ERROR, 0);
442         }
443 
444         uint c = a * b;
445 
446         if (c / a != b) {
447             return (Error.INTEGER_OVERFLOW, 0);
448         } else {
449             return (Error.NO_ERROR, c);
450         }
451     }
452 
453     /**
454     * @dev Integer division of two numbers, truncating the quotient.
455     */
456     function div(uint a, uint b) internal pure returns (Error, uint) {
457         if (b == 0) {
458             return (Error.DIVISION_BY_ZERO, 0);
459         }
460 
461         return (Error.NO_ERROR, a / b);
462     }
463 
464     /**
465     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
466     */
467     function sub(uint a, uint b) internal pure returns (Error, uint) {
468         if (b <= a) {
469             return (Error.NO_ERROR, a - b);
470         } else {
471             return (Error.INTEGER_UNDERFLOW, 0);
472         }
473     }
474 
475     /**
476     * @dev Adds two numbers, returns an error on overflow.
477     */
478     function add(uint a, uint b) internal pure returns (Error, uint) {
479         uint c = a + b;
480 
481         if (c >= a) {
482             return (Error.NO_ERROR, c);
483         } else {
484             return (Error.INTEGER_OVERFLOW, 0);
485         }
486     }
487 
488     /**
489     * @dev add a and b and then subtract c
490     */
491     function addThenSub(uint a, uint b, uint c) internal pure returns (Error, uint) {
492         (Error err0, uint sum) = add(a, b);
493 
494         if (err0 != Error.NO_ERROR) {
495             return (err0, 0);
496         }
497 
498         return sub(sum, c);
499     }
500 }
501 contract Exponential is ErrorReporter, CarefulMath {
502 
503     // TODO: We may wish to put the result of 10**18 here instead of the expression.
504     // Per https://solidity.readthedocs.io/en/latest/contracts.html#constant-state-variables
505     // the optimizer MAY replace the expression 10**18 with its calculated value.
506     uint constant expScale = 10**18;
507 
508     // See TODO on expScale
509     uint constant halfExpScale = expScale/2;
510 
511     struct Exp {
512         uint mantissa;
513     }
514 
515     uint constant mantissaOne = 10**18;
516     uint constant mantissaOneTenth = 10**17;
517 
518     /**
519     * @dev Creates an exponential from numerator and denominator values.
520     *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
521     *            or if `denom` is zero.
522     */
523     function getExp(uint num, uint denom) pure internal returns (Error, Exp memory) {
524         (Error err0, uint scaledNumerator) = mul(num, expScale);
525         if (err0 != Error.NO_ERROR) {
526             return (err0, Exp({mantissa: 0}));
527         }
528 
529         (Error err1, uint rational) = div(scaledNumerator, denom);
530         if (err1 != Error.NO_ERROR) {
531             return (err1, Exp({mantissa: 0}));
532         }
533 
534         return (Error.NO_ERROR, Exp({mantissa: rational}));
535     }
536 
537     /**
538     * @dev Adds two exponentials, returning a new exponential.
539     */
540     function addExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
541         (Error error, uint result) = add(a.mantissa, b.mantissa);
542 
543         return (error, Exp({mantissa: result}));
544     }
545 
546     /**
547     * @dev Subtracts two exponentials, returning a new exponential.
548     */
549     function subExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
550         (Error error, uint result) = sub(a.mantissa, b.mantissa);
551 
552         return (error, Exp({mantissa: result}));
553     }
554 
555     /**
556     * @dev Multiply an Exp by a scalar, returning a new Exp.
557     */
558     function mulScalar(Exp memory a, uint scalar) pure internal returns (Error, Exp memory) {
559         (Error err0, uint scaledMantissa) = mul(a.mantissa, scalar);
560         if (err0 != Error.NO_ERROR) {
561             return (err0, Exp({mantissa: 0}));
562         }
563 
564         return (Error.NO_ERROR, Exp({mantissa: scaledMantissa}));
565     }
566 
567     /**
568     * @dev Divide an Exp by a scalar, returning a new Exp.
569     */
570     function divScalar(Exp memory a, uint scalar) pure internal returns (Error, Exp memory) {
571         (Error err0, uint descaledMantissa) = div(a.mantissa, scalar);
572         if (err0 != Error.NO_ERROR) {
573             return (err0, Exp({mantissa: 0}));
574         }
575 
576         return (Error.NO_ERROR, Exp({mantissa: descaledMantissa}));
577     }
578 
579     /**
580     * @dev Divide a scalar by an Exp, returning a new Exp.
581     */
582     function divScalarByExp(uint scalar, Exp divisor) pure internal returns (Error, Exp memory) {
583         /*
584             We are doing this as:
585             getExp(mul(expScale, scalar), divisor.mantissa)
586 
587             How it works:
588             Exp = a / b;
589             Scalar = s;
590             `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
591         */
592         (Error err0, uint numerator) = mul(expScale, scalar);
593         if (err0 != Error.NO_ERROR) {
594             return (err0, Exp({mantissa: 0}));
595         }
596         return getExp(numerator, divisor.mantissa);
597     }
598 
599     /**
600     * @dev Multiplies two exponentials, returning a new exponential.
601     */
602     function mulExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
603 
604         (Error err0, uint doubleScaledProduct) = mul(a.mantissa, b.mantissa);
605         if (err0 != Error.NO_ERROR) {
606             return (err0, Exp({mantissa: 0}));
607         }
608 
609         // We add half the scale before dividing so that we get rounding instead of truncation.
610         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
611         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
612         (Error err1, uint doubleScaledProductWithHalfScale) = add(halfExpScale, doubleScaledProduct);
613         if (err1 != Error.NO_ERROR) {
614             return (err1, Exp({mantissa: 0}));
615         }
616 
617         (Error err2, uint product) = div(doubleScaledProductWithHalfScale, expScale);
618         // The only error `div` can return is Error.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
619         assert(err2 == Error.NO_ERROR);
620 
621         return (Error.NO_ERROR, Exp({mantissa: product}));
622     }
623 
624     /**
625       * @dev Divides two exponentials, returning a new exponential.
626       *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
627       *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
628       */
629     function divExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
630         return getExp(a.mantissa, b.mantissa);
631     }
632 
633     /**
634       * @dev Truncates the given exp to a whole number value.
635       *      For example, truncate(Exp{mantissa: 15 * (10**18)}) = 15
636       */
637     function truncate(Exp memory exp) pure internal returns (uint) {
638         // Note: We are not using careful math here as we're performing a division that cannot fail
639         return exp.mantissa / 10**18;
640     }
641 
642     /**
643       * @dev Checks if first Exp is less than second Exp.
644       */
645     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
646         return left.mantissa < right.mantissa; //TODO: Add some simple tests and this in another PR yo.
647     }
648 
649     /**
650       * @dev Checks if left Exp <= right Exp.
651       */
652     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
653         return left.mantissa <= right.mantissa;
654     }
655 
656     /**
657       * @dev returns true if Exp is exactly zero
658       */
659     function isZeroExp(Exp memory value) pure internal returns (bool) {
660         return value.mantissa == 0;
661     }
662 }
663 
664 contract MoneyMarket is Exponential, SafeToken {
665 
666     uint constant initialInterestIndex = 10 ** 18;
667     uint constant defaultOriginationFee = 0; // default is zero bps
668 
669     uint constant minimumCollateralRatioMantissa = 11 * (10 ** 17); // 1.1
670     uint constant maximumLiquidationDiscountMantissa = (10 ** 17); // 0.1
671 
672     /**
673       * @notice `MoneyMarket` is the core Compound MoneyMarket contract
674       */
675     constructor() public {
676         admin = msg.sender;
677         collateralRatio = Exp({mantissa: 2 * mantissaOne});
678         originationFee = Exp({mantissa: defaultOriginationFee});
679         liquidationDiscount = Exp({mantissa: 0});
680         // oracle must be configured via _setOracle
681     }
682 
683     /**
684       * @notice Do not pay directly into MoneyMarket, please use `supply`.
685       */
686     function() payable public {
687         revert();
688     }
689 
690     /**
691       * @dev pending Administrator for this contract.
692       */
693     address public pendingAdmin;
694 
695     /**
696       * @dev Administrator for this contract. Initially set in constructor, but can
697       *      be changed by the admin itself.
698       */
699     address public admin;
700 
701     /**
702       * @dev Account allowed to set oracle prices for this contract. Initially set
703       *      in constructor, but can be changed by the admin.
704       */
705     address public oracle;
706 
707     /**
708       * @dev Container for customer balance information written to storage.
709       *
710       *      struct Balance {
711       *        principal = customer total balance with accrued interest after applying the customer's most recent balance-changing action
712       *        interestIndex = the total interestIndex as calculated after applying the customer's most recent balance-changing action
713       *      }
714       */
715     struct Balance {
716         uint principal;
717         uint interestIndex;
718     }
719 
720     /**
721       * @dev 2-level map: customerAddress -> assetAddress -> balance for supplies
722       */
723     mapping(address => mapping(address => Balance)) public supplyBalances;
724 
725 
726     /**
727       * @dev 2-level map: customerAddress -> assetAddress -> balance for borrows
728       */
729     mapping(address => mapping(address => Balance)) public borrowBalances;
730 
731 
732     /**
733       * @dev Container for per-asset balance sheet and interest rate information written to storage, intended to be stored in a map where the asset address is the key
734       *
735       *      struct Market {
736       *         isSupported = Whether this market is supported or not (not to be confused with the list of collateral assets)
737       *         blockNumber = when the other values in this struct were calculated
738       *         totalSupply = total amount of this asset supplied (in asset wei)
739       *         supplyRateMantissa = the per-block interest rate for supplies of asset as of blockNumber, scaled by 10e18
740       *         supplyIndex = the interest index for supplies of asset as of blockNumber; initialized in _supportMarket
741       *         totalBorrows = total amount of this asset borrowed (in asset wei)
742       *         borrowRateMantissa = the per-block interest rate for borrows of asset as of blockNumber, scaled by 10e18
743       *         borrowIndex = the interest index for borrows of asset as of blockNumber; initialized in _supportMarket
744       *     }
745       */
746     struct Market {
747         bool isSupported;
748         uint blockNumber;
749         InterestRateModel interestRateModel;
750 
751         uint totalSupply;
752         uint supplyRateMantissa;
753         uint supplyIndex;
754 
755         uint totalBorrows;
756         uint borrowRateMantissa;
757         uint borrowIndex;
758     }
759 
760     /**
761       * @dev map: assetAddress -> Market
762       */
763     mapping(address => Market) public markets;
764 
765     /**
766       * @dev list: collateralMarkets
767       */
768     address[] public collateralMarkets;
769 
770     /**
771       * @dev The collateral ratio that borrows must maintain (e.g. 2 implies 2:1). This
772       *      is initially set in the constructor, but can be changed by the admin.
773       */
774     Exp public collateralRatio;
775 
776     /**
777       * @dev originationFee for new borrows.
778       *
779       */
780     Exp public originationFee;
781 
782     /**
783       * @dev liquidationDiscount for collateral when liquidating borrows
784       *
785       */
786     Exp public liquidationDiscount;
787 
788     /**
789       * @dev flag for whether or not contract is paused
790       *
791       */
792     bool public paused;
793 
794 
795     /**
796       * @dev emitted when a supply is received
797       *      Note: newBalance - amount - startingBalance = interest accumulated since last change
798       */
799     event SupplyReceived(address account, address asset, uint amount, uint startingBalance, uint newBalance);
800 
801     /**
802       * @dev emitted when a supply is withdrawn
803       *      Note: startingBalance - amount - startingBalance = interest accumulated since last change
804       */
805     event SupplyWithdrawn(address account, address asset, uint amount, uint startingBalance, uint newBalance);
806 
807     /**
808       * @dev emitted when a new borrow is taken
809       *      Note: newBalance - borrowAmountWithFee - startingBalance = interest accumulated since last change
810       */
811     event BorrowTaken(address account, address asset, uint amount, uint startingBalance, uint borrowAmountWithFee, uint newBalance);
812 
813     /**
814       * @dev emitted when a borrow is repaid
815       *      Note: newBalance - amount - startingBalance = interest accumulated since last change
816       */
817     event BorrowRepaid(address account, address asset, uint amount, uint startingBalance, uint newBalance);
818 
819     /**
820       * @dev emitted when a borrow is liquidated
821       *      targetAccount = user whose borrow was liquidated
822       *      assetBorrow = asset borrowed
823       *      borrowBalanceBefore = borrowBalance as most recently stored before the liquidation
824       *      borrowBalanceAccumulated = borroBalanceBefore + accumulated interest as of immediately prior to the liquidation
825       *      amountRepaid = amount of borrow repaid
826       *      liquidator = account requesting the liquidation
827       *      assetCollateral = asset taken from targetUser and given to liquidator in exchange for liquidated loan
828       *      borrowBalanceAfter = new stored borrow balance (should equal borrowBalanceAccumulated - amountRepaid)
829       *      collateralBalanceBefore = collateral balance as most recently stored before the liquidation
830       *      collateralBalanceAccumulated = collateralBalanceBefore + accumulated interest as of immediately prior to the liquidation
831       *      amountSeized = amount of collateral seized by liquidator
832       *      collateralBalanceAfter = new stored collateral balance (should equal collateralBalanceAccumulated - amountSeized)
833       */
834     event BorrowLiquidated(address targetAccount,
835         address assetBorrow,
836         uint borrowBalanceBefore,
837         uint borrowBalanceAccumulated,
838         uint amountRepaid,
839         uint borrowBalanceAfter,
840         address liquidator,
841         address assetCollateral,
842         uint collateralBalanceBefore,
843         uint collateralBalanceAccumulated,
844         uint amountSeized,
845         uint collateralBalanceAfter);
846 
847     /**
848       * @dev emitted when pendingAdmin is changed
849       */
850     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
851 
852     /**
853       * @dev emitted when pendingAdmin is accepted, which means admin is updated
854       */
855     event NewAdmin(address oldAdmin, address newAdmin);
856 
857     /**
858       * @dev newOracle - address of new oracle
859       */
860     event NewOracle(address oldOracle, address newOracle);
861 
862     /**
863       * @dev emitted when new market is supported by admin
864       */
865     event SupportedMarket(address asset, address interestRateModel);
866 
867     /**
868       * @dev emitted when risk parameters are changed by admin
869       */
870     event NewRiskParameters(uint oldCollateralRatioMantissa, uint newCollateralRatioMantissa, uint oldLiquidationDiscountMantissa, uint newLiquidationDiscountMantissa);
871 
872     /**
873       * @dev emitted when origination fee is changed by admin
874       */
875     event NewOriginationFee(uint oldOriginationFeeMantissa, uint newOriginationFeeMantissa);
876 
877     /**
878       * @dev emitted when market has new interest rate model set
879       */
880     event SetMarketInterestRateModel(address asset, address interestRateModel);
881 
882     /**
883       * @dev emitted when admin withdraws equity
884       * Note that `equityAvailableBefore` indicates equity before `amount` was removed.
885       */
886     event EquityWithdrawn(address asset, uint equityAvailableBefore, uint amount, address owner);
887 
888     /**
889       * @dev emitted when a supported market is suspended by admin
890       */
891     event SuspendedMarket(address asset);
892 
893     /**
894       * @dev emitted when admin either pauses or resumes the contract; newState is the resulting state
895       */
896     event SetPaused(bool newState);
897 
898     /**
899       * @dev Simple function to calculate min between two numbers.
900       */
901     function min(uint a, uint b) pure internal returns (uint) {
902         if (a < b) {
903             return a;
904         } else {
905             return b;
906         }
907     }
908 
909     /**
910       * @dev Function to simply retrieve block number
911       *      This exists mainly for inheriting test contracts to stub this result.
912       */
913     function getBlockNumber() internal view returns (uint) {
914         return block.number;
915     }
916 
917     /**
918       * @dev Adds a given asset to the list of collateral markets. This operation is impossible to reverse.
919       *      Note: this will not add the asset if it already exists.
920       */
921     function addCollateralMarket(address asset) internal {
922         for (uint i = 0; i < collateralMarkets.length; i++) {
923             if (collateralMarkets[i] == asset) {
924                 return;
925             }
926         }
927 
928         collateralMarkets.push(asset);
929     }
930 
931     /**
932       * @notice return the number of elements in `collateralMarkets`
933       * @dev you can then externally call `collateralMarkets(uint)` to pull each market address
934       * @return the length of `collateralMarkets`
935       */
936     function getCollateralMarketsLength() public view returns (uint) {
937         return collateralMarkets.length;
938     }
939 
940     /**
941       * @dev Calculates a new supply index based on the prevailing interest rates applied over time
942       *      This is defined as `we multiply the most recent supply index by (1 + blocks times rate)`
943       */
944     function calculateInterestIndex(uint startingInterestIndex, uint interestRateMantissa, uint blockStart, uint blockEnd) pure internal returns (Error, uint) {
945 
946         // Get the block delta
947         (Error err0, uint blockDelta) = sub(blockEnd, blockStart);
948         if (err0 != Error.NO_ERROR) {
949             return (err0, 0);
950         }
951 
952         // Scale the interest rate times number of blocks
953         // Note: Doing Exp construction inline to avoid `CompilerError: Stack too deep, try removing local variables.`
954         (Error err1, Exp memory blocksTimesRate) = mulScalar(Exp({mantissa: interestRateMantissa}), blockDelta);
955         if (err1 != Error.NO_ERROR) {
956             return (err1, 0);
957         }
958 
959         // Add one to that result (which is really Exp({mantissa: expScale}) which equals 1.0)
960         (Error err2, Exp memory onePlusBlocksTimesRate) = addExp(blocksTimesRate, Exp({mantissa: mantissaOne}));
961         if (err2 != Error.NO_ERROR) {
962             return (err2, 0);
963         }
964 
965         // Then scale that accumulated interest by the old interest index to get the new interest index
966         (Error err3, Exp memory newInterestIndexExp) = mulScalar(onePlusBlocksTimesRate, startingInterestIndex);
967         if (err3 != Error.NO_ERROR) {
968             return (err3, 0);
969         }
970 
971         // Finally, truncate the interest index. This works only if interest index starts large enough
972         // that is can be accurately represented with a whole number.
973         return (Error.NO_ERROR, truncate(newInterestIndexExp));
974     }
975 
976     /**
977       * @dev Calculates a new balance based on a previous balance and a pair of interest indices
978       *      This is defined as: `The user's last balance checkpoint is multiplied by the currentSupplyIndex
979       *      value and divided by the user's checkpoint index value`
980       *
981       *      TODO: Is there a way to handle this that is less likely to overflow?
982       */
983     function calculateBalance(uint startingBalance, uint interestIndexStart, uint interestIndexEnd) pure internal returns (Error, uint) {
984         if (startingBalance == 0) {
985             // We are accumulating interest on any previous balance; if there's no previous balance, then there is
986             // nothing to accumulate.
987             return (Error.NO_ERROR, 0);
988         }
989         (Error err0, uint balanceTimesIndex) = mul(startingBalance, interestIndexEnd);
990         if (err0 != Error.NO_ERROR) {
991             return (err0, 0);
992         }
993 
994         return div(balanceTimesIndex, interestIndexStart);
995     }
996 
997     /**
998       * @dev Gets the price for the amount specified of the given asset.
999       */
1000     function getPriceForAssetAmount(address asset, uint assetAmount) internal view returns (Error, Exp memory)  {
1001         (Error err, Exp memory assetPrice) = fetchAssetPrice(asset);
1002         if (err != Error.NO_ERROR) {
1003             return (err, Exp({mantissa: 0}));
1004         }
1005 
1006         if (isZeroExp(assetPrice)) {
1007             return (Error.MISSING_ASSET_PRICE, Exp({mantissa: 0}));
1008         }
1009 
1010         return mulScalar(assetPrice, assetAmount); // assetAmountWei * oraclePrice = assetValueInEth
1011     }
1012 
1013     /**
1014       * @dev Gets the price for the amount specified of the given asset multiplied by the current
1015       *      collateral ratio (i.e., assetAmountWei * collateralRatio * oraclePrice = totalValueInEth).
1016       *      We will group this as `(oraclePrice * collateralRatio) * assetAmountWei`
1017       */
1018     function getPriceForAssetAmountMulCollatRatio(address asset, uint assetAmount) internal view returns (Error, Exp memory)  {
1019         Error err;
1020         Exp memory assetPrice;
1021         Exp memory scaledPrice;
1022         (err, assetPrice) = fetchAssetPrice(asset);
1023         if (err != Error.NO_ERROR) {
1024             return (err, Exp({mantissa: 0}));
1025         }
1026 
1027         if (isZeroExp(assetPrice)) {
1028             return (Error.MISSING_ASSET_PRICE, Exp({mantissa: 0}));
1029         }
1030 
1031         // Now, multiply the assetValue by the collateral ratio
1032         (err, scaledPrice) = mulExp(collateralRatio, assetPrice);
1033         if (err != Error.NO_ERROR) {
1034             return (err, Exp({mantissa: 0}));
1035         }
1036 
1037         // Get the price for the given asset amount
1038         return mulScalar(scaledPrice, assetAmount);
1039     }
1040 
1041     /**
1042       * @dev Calculates the origination fee added to a given borrowAmount
1043       *      This is simply `(1 + originationFee) * borrowAmount`
1044       *
1045       *      TODO: Track at what magnitude this fee rounds down to zero?
1046       */
1047     function calculateBorrowAmountWithFee(uint borrowAmount) view internal returns (Error, uint) {
1048         // When origination fee is zero, the amount with fee is simply equal to the amount
1049         if (isZeroExp(originationFee)) {
1050             return (Error.NO_ERROR, borrowAmount);
1051         }
1052 
1053         (Error err0, Exp memory originationFeeFactor) = addExp(originationFee, Exp({mantissa: mantissaOne}));
1054         if (err0 != Error.NO_ERROR) {
1055             return (err0, 0);
1056         }
1057 
1058         (Error err1, Exp memory borrowAmountWithFee) = mulScalar(originationFeeFactor, borrowAmount);
1059         if (err1 != Error.NO_ERROR) {
1060             return (err1, 0);
1061         }
1062 
1063         return (Error.NO_ERROR, truncate(borrowAmountWithFee));
1064     }
1065 
1066     /**
1067       * @dev fetches the price of asset from the PriceOracle and converts it to Exp
1068       * @param asset asset whose price should be fetched
1069       */
1070     function fetchAssetPrice(address asset) internal view returns (Error, Exp memory) {
1071         if (oracle == address(0)) {
1072             return (Error.ZERO_ORACLE_ADDRESS, Exp({mantissa: 0}));
1073         }
1074 
1075         PriceOracleInterface oracleInterface = PriceOracleInterface(oracle);
1076         uint priceMantissa = oracleInterface.assetPrices(asset);
1077 
1078         return (Error.NO_ERROR, Exp({mantissa: priceMantissa}));
1079     }
1080 
1081     /**
1082       * @notice Reads scaled price of specified asset from the price oracle
1083       * @dev Reads scaled price of specified asset from the price oracle.
1084       *      The plural name is to match a previous storage mapping that this function replaced.
1085       * @param asset Asset whose price should be retrieved
1086       * @return 0 on an error or missing price, the price scaled by 1e18 otherwise
1087       */
1088     function assetPrices(address asset) public view returns (uint) {
1089         (Error err, Exp memory result) = fetchAssetPrice(asset);
1090         if (err != Error.NO_ERROR) {
1091             return 0;
1092         }
1093         return result.mantissa;
1094     }
1095 
1096     /**
1097       * @dev Gets the amount of the specified asset given the specified Eth value
1098       *      ethValue / oraclePrice = assetAmountWei
1099       *      If there's no oraclePrice, this returns (Error.DIVISION_BY_ZERO, 0)
1100       */
1101     function getAssetAmountForValue(address asset, Exp ethValue) internal view returns (Error, uint) {
1102         Error err;
1103         Exp memory assetPrice;
1104         Exp memory assetAmount;
1105 
1106         (err, assetPrice) = fetchAssetPrice(asset);
1107         if (err != Error.NO_ERROR) {
1108             return (err, 0);
1109         }
1110 
1111         (err, assetAmount) = divExp(ethValue, assetPrice);
1112         if (err != Error.NO_ERROR) {
1113             return (err, 0);
1114         }
1115 
1116         return (Error.NO_ERROR, truncate(assetAmount));
1117     }
1118 
1119     /**
1120       * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
1121       * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
1122       * @param newPendingAdmin New pending admin.
1123       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1124       *
1125       * TODO: Should we add a second arg to verify, like a checksum of `newAdmin` address?
1126       */
1127     function _setPendingAdmin(address newPendingAdmin) public returns (uint) {
1128         // Check caller = admin
1129         if (msg.sender != admin) {
1130             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
1131         }
1132 
1133         // save current value, if any, for inclusion in log
1134         address oldPendingAdmin = pendingAdmin;
1135         // Store pendingAdmin = newPendingAdmin
1136         pendingAdmin = newPendingAdmin;
1137 
1138         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
1139 
1140         return uint(Error.NO_ERROR);
1141     }
1142 
1143     /**
1144       * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
1145       * @dev Admin function for pending admin to accept role and update admin
1146       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1147       */
1148     function _acceptAdmin() public returns (uint) {
1149         // Check caller = pendingAdmin
1150         // msg.sender can't be zero
1151         if (msg.sender != pendingAdmin) {
1152             return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);
1153         }
1154 
1155         // Save current value for inclusion in log
1156         address oldAdmin = admin;
1157         // Store admin = pendingAdmin
1158         admin = pendingAdmin;
1159         // Clear the pending value
1160         pendingAdmin = 0;
1161 
1162         emit NewAdmin(oldAdmin, msg.sender);
1163 
1164         return uint(Error.NO_ERROR);
1165     }
1166 
1167     /**
1168       * @notice Set new oracle, who can set asset prices
1169       * @dev Admin function to change oracle
1170       * @param newOracle New oracle address
1171       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1172       */
1173     function _setOracle(address newOracle) public returns (uint) {
1174         // Check caller = admin
1175         if (msg.sender != admin) {
1176             return fail(Error.UNAUTHORIZED, FailureInfo.SET_ORACLE_OWNER_CHECK);
1177         }
1178 
1179         // Verify contract at newOracle address supports assetPrices call.
1180         // This will revert if it doesn't.
1181         PriceOracleInterface oracleInterface = PriceOracleInterface(newOracle);
1182         oracleInterface.assetPrices(address(0));
1183 
1184         address oldOracle = oracle;
1185 
1186         // Store oracle = newOracle
1187         oracle = newOracle;
1188 
1189         emit NewOracle(oldOracle, newOracle);
1190 
1191         return uint(Error.NO_ERROR);
1192     }
1193 
1194     /**
1195       * @notice set `paused` to the specified state
1196       * @dev Admin function to pause or resume the market
1197       * @param requestedState value to assign to `paused`
1198       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1199       */
1200     function _setPaused(bool requestedState) public returns (uint) {
1201         // Check caller = admin
1202         if (msg.sender != admin) {
1203             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PAUSED_OWNER_CHECK);
1204         }
1205 
1206         paused = requestedState;
1207         emit SetPaused(requestedState);
1208 
1209         return uint(Error.NO_ERROR);
1210     }
1211 
1212     /**
1213       * @notice returns the liquidity for given account.
1214       *         a positive result indicates ability to borrow, whereas
1215       *         a negative result indicates a shortfall which may be liquidated
1216       * @dev returns account liquidity in terms of eth-wei value, scaled by 1e18
1217       *      note: this includes interest trued up on all balances
1218       * @param account the account to examine
1219       * @return signed integer in terms of eth-wei (negative indicates a shortfall)
1220       */
1221     function getAccountLiquidity(address account) public view returns (int) {
1222         (Error err, Exp memory accountLiquidity, Exp memory accountShortfall) = calculateAccountLiquidity(account);
1223         require(err == Error.NO_ERROR);
1224 
1225         if (isZeroExp(accountLiquidity)) {
1226             return -1 * int(truncate(accountShortfall));
1227         } else {
1228             return int(truncate(accountLiquidity));
1229         }
1230     }
1231 
1232     /**
1233       * @notice return supply balance with any accumulated interest for `asset` belonging to `account`
1234       * @dev returns supply balance with any accumulated interest for `asset` belonging to `account`
1235       * @param account the account to examine
1236       * @param asset the market asset whose supply balance belonging to `account` should be checked
1237       * @return uint supply balance on success, throws on failed assertion otherwise
1238       */
1239     function getSupplyBalance(address account, address asset) view public returns (uint) {
1240         Error err;
1241         uint newSupplyIndex;
1242         uint userSupplyCurrent;
1243 
1244         Market storage market = markets[asset];
1245         Balance storage supplyBalance = supplyBalances[account][asset];
1246 
1247         // Calculate the newSupplyIndex, needed to calculate user's supplyCurrent
1248         (err, newSupplyIndex) = calculateInterestIndex(market.supplyIndex, market.supplyRateMantissa, market.blockNumber, getBlockNumber());
1249         require(err == Error.NO_ERROR);
1250 
1251         // Use newSupplyIndex and stored principal to calculate the accumulated balance
1252         (err, userSupplyCurrent) = calculateBalance(supplyBalance.principal, supplyBalance.interestIndex, newSupplyIndex);
1253         require(err == Error.NO_ERROR);
1254 
1255         return userSupplyCurrent;
1256     }
1257 
1258     /**
1259       * @notice return borrow balance with any accumulated interest for `asset` belonging to `account`
1260       * @dev returns borrow balance with any accumulated interest for `asset` belonging to `account`
1261       * @param account the account to examine
1262       * @param asset the market asset whose borrow balance belonging to `account` should be checked
1263       * @return uint borrow balance on success, throws on failed assertion otherwise
1264       */
1265     function getBorrowBalance(address account, address asset) view public returns (uint) {
1266         Error err;
1267         uint newBorrowIndex;
1268         uint userBorrowCurrent;
1269 
1270         Market storage market = markets[asset];
1271         Balance storage borrowBalance = borrowBalances[account][asset];
1272 
1273         // Calculate the newBorrowIndex, needed to calculate user's borrowCurrent
1274         (err, newBorrowIndex) = calculateInterestIndex(market.borrowIndex, market.borrowRateMantissa, market.blockNumber, getBlockNumber());
1275         require(err == Error.NO_ERROR);
1276 
1277         // Use newBorrowIndex and stored principal to calculate the accumulated balance
1278         (err, userBorrowCurrent) = calculateBalance(borrowBalance.principal, borrowBalance.interestIndex, newBorrowIndex);
1279         require(err == Error.NO_ERROR);
1280 
1281         return userBorrowCurrent;
1282     }
1283 
1284 
1285     /**
1286       * @notice Supports a given market (asset) for use with Compound
1287       * @dev Admin function to add support for a market
1288       * @param asset Asset to support; MUST already have a non-zero price set
1289       * @param interestRateModel InterestRateModel to use for the asset
1290       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1291       */
1292     function _supportMarket(address asset, InterestRateModel interestRateModel) public returns (uint) {
1293         // Check caller = admin
1294         if (msg.sender != admin) {
1295             return fail(Error.UNAUTHORIZED, FailureInfo.SUPPORT_MARKET_OWNER_CHECK);
1296         }
1297 
1298         (Error err, Exp memory assetPrice) = fetchAssetPrice(asset);
1299         if (err != Error.NO_ERROR) {
1300             return fail(err, FailureInfo.SUPPORT_MARKET_FETCH_PRICE_FAILED);
1301         }
1302 
1303         if (isZeroExp(assetPrice)) {
1304             return fail(Error.ASSET_NOT_PRICED, FailureInfo.SUPPORT_MARKET_PRICE_CHECK);
1305         }
1306 
1307         // Set the interest rate model to `modelAddress`
1308         markets[asset].interestRateModel = interestRateModel;
1309 
1310         // Append asset to collateralAssets if not set
1311         addCollateralMarket(asset);
1312 
1313         // Set market isSupported to true
1314         markets[asset].isSupported = true;
1315 
1316         // Default supply and borrow index to 1e18
1317         if (markets[asset].supplyIndex == 0) {
1318             markets[asset].supplyIndex = initialInterestIndex;
1319         }
1320 
1321         if (markets[asset].borrowIndex == 0) {
1322             markets[asset].borrowIndex = initialInterestIndex;
1323         }
1324 
1325         emit SupportedMarket(asset, interestRateModel);
1326 
1327         return uint(Error.NO_ERROR);
1328     }
1329 
1330     /**
1331       * @notice Suspends a given *supported* market (asset) from use with Compound.
1332       *         Assets in this state do count for collateral, but users may only withdraw, payBorrow,
1333       *         and liquidate the asset. The liquidate function no longer checks collateralization.
1334       * @dev Admin function to suspend a market
1335       * @param asset Asset to suspend
1336       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1337       */
1338     function _suspendMarket(address asset) public returns (uint) {
1339         // Check caller = admin
1340         if (msg.sender != admin) {
1341             return fail(Error.UNAUTHORIZED, FailureInfo.SUSPEND_MARKET_OWNER_CHECK);
1342         }
1343 
1344         // If the market is not configured at all, we don't want to add any configuration for it.
1345         // If we find !markets[asset].isSupported then either the market is not configured at all, or it
1346         // has already been marked as unsupported. We can just return without doing anything.
1347         // Caller is responsible for knowing the difference between not-configured and already unsupported.
1348         if (!markets[asset].isSupported) {
1349             return uint(Error.NO_ERROR);
1350         }
1351 
1352         // If we get here, we know market is configured and is supported, so set isSupported to false
1353         markets[asset].isSupported = false;
1354 
1355         emit SuspendedMarket(asset);
1356 
1357         return uint(Error.NO_ERROR);
1358     }
1359 
1360     /**
1361       * @notice Sets the risk parameters: collateral ratio and liquidation discount
1362       * @dev Owner function to set the risk parameters
1363       * @param collateralRatioMantissa rational collateral ratio, scaled by 1e18. The de-scaled value must be >= 1.1
1364       * @param liquidationDiscountMantissa rational liquidation discount, scaled by 1e18. The de-scaled value must be <= 0.1 and must be less than (descaled collateral ratio minus 1)
1365       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1366       */
1367     function _setRiskParameters(uint collateralRatioMantissa, uint liquidationDiscountMantissa) public returns (uint) {
1368         // Check caller = admin
1369         if (msg.sender != admin) {
1370             return fail(Error.UNAUTHORIZED, FailureInfo.SET_RISK_PARAMETERS_OWNER_CHECK);
1371         }
1372 
1373         Exp memory newCollateralRatio = Exp({mantissa: collateralRatioMantissa});
1374         Exp memory newLiquidationDiscount = Exp({mantissa: liquidationDiscountMantissa});
1375         Exp memory minimumCollateralRatio = Exp({mantissa: minimumCollateralRatioMantissa});
1376         Exp memory maximumLiquidationDiscount = Exp({mantissa: maximumLiquidationDiscountMantissa});
1377 
1378         Error err;
1379         Exp memory newLiquidationDiscountPlusOne;
1380 
1381         // Make sure new collateral ratio value is not below minimum value
1382         if (lessThanExp(newCollateralRatio, minimumCollateralRatio)) {
1383             return fail(Error.INVALID_COLLATERAL_RATIO, FailureInfo.SET_RISK_PARAMETERS_VALIDATION);
1384         }
1385 
1386         // Make sure new liquidation discount does not exceed the maximum value, but reverse operands so we can use the
1387         // existing `lessThanExp` function rather than adding a `greaterThan` function to Exponential.
1388         if (lessThanExp(maximumLiquidationDiscount, newLiquidationDiscount)) {
1389             return fail(Error.INVALID_LIQUIDATION_DISCOUNT, FailureInfo.SET_RISK_PARAMETERS_VALIDATION);
1390         }
1391 
1392         // C = L+1 is not allowed because it would cause division by zero error in `calculateDiscountedRepayToEvenAmount`
1393         // C < L+1 is not allowed because it would cause integer underflow error in `calculateDiscountedRepayToEvenAmount`
1394         (err, newLiquidationDiscountPlusOne) = addExp(newLiquidationDiscount, Exp({mantissa: mantissaOne}));
1395         assert(err == Error.NO_ERROR); // We already validated that newLiquidationDiscount does not approach overflow size
1396 
1397         if (lessThanOrEqualExp(newCollateralRatio, newLiquidationDiscountPlusOne)) {
1398             return fail(Error.INVALID_COMBINED_RISK_PARAMETERS, FailureInfo.SET_RISK_PARAMETERS_VALIDATION);
1399         }
1400 
1401         // Save current values so we can emit them in log.
1402         Exp memory oldCollateralRatio = collateralRatio;
1403         Exp memory oldLiquidationDiscount = liquidationDiscount;
1404 
1405         // Store new values
1406         collateralRatio = newCollateralRatio;
1407         liquidationDiscount = newLiquidationDiscount;
1408 
1409         emit NewRiskParameters(oldCollateralRatio.mantissa, collateralRatioMantissa, oldLiquidationDiscount.mantissa, liquidationDiscountMantissa);
1410 
1411         return uint(Error.NO_ERROR);
1412     }
1413 
1414     /**
1415       * @notice Sets the origination fee (which is a multiplier on new borrows)
1416       * @dev Owner function to set the origination fee
1417       * @param originationFeeMantissa rational collateral ratio, scaled by 1e18. The de-scaled value must be >= 1.1
1418       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1419       */
1420     function _setOriginationFee(uint originationFeeMantissa) public returns (uint) {
1421         // Check caller = admin
1422         if (msg.sender != admin) {
1423             return fail(Error.UNAUTHORIZED, FailureInfo.SET_ORIGINATION_FEE_OWNER_CHECK);
1424         }
1425 
1426         // Save current value so we can emit it in log.
1427         Exp memory oldOriginationFee = originationFee;
1428 
1429         originationFee = Exp({mantissa: originationFeeMantissa});
1430 
1431         emit NewOriginationFee(oldOriginationFee.mantissa, originationFeeMantissa);
1432 
1433         return uint(Error.NO_ERROR);
1434     }
1435 
1436     /**
1437       * @notice Sets the interest rate model for a given market
1438       * @dev Admin function to set interest rate model
1439       * @param asset Asset to support
1440       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1441       */
1442     function _setMarketInterestRateModel(address asset, InterestRateModel interestRateModel) public returns (uint) {
1443         // Check caller = admin
1444         if (msg.sender != admin) {
1445             return fail(Error.UNAUTHORIZED, FailureInfo.SET_MARKET_INTEREST_RATE_MODEL_OWNER_CHECK);
1446         }
1447 
1448         // Set the interest rate model to `modelAddress`
1449         markets[asset].interestRateModel = interestRateModel;
1450 
1451         emit SetMarketInterestRateModel(asset, interestRateModel);
1452 
1453         return uint(Error.NO_ERROR);
1454     }
1455 
1456     /**
1457       * @notice withdraws `amount` of `asset` from equity for asset, as long as `amount` <= equity. Equity= cash - (supply + borrows)
1458       * @dev withdraws `amount` of `asset` from equity  for asset, enforcing amount <= cash - (supply + borrows)
1459       * @param asset asset whose equity should be withdrawn
1460       * @param amount amount of equity to withdraw; must not exceed equity available
1461       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1462       */
1463     function _withdrawEquity(address asset, uint amount) public returns (uint) {
1464         // Check caller = admin
1465         if (msg.sender != admin) {
1466             return fail(Error.UNAUTHORIZED, FailureInfo.EQUITY_WITHDRAWAL_MODEL_OWNER_CHECK);
1467         }
1468 
1469         // Check that amount is less than cash (from ERC-20 of self) plus borrows minus supply.
1470         uint cash = getCash(asset);
1471         (Error err0, uint equity) = addThenSub(cash, markets[asset].totalBorrows, markets[asset].totalSupply);
1472         if (err0 != Error.NO_ERROR) {
1473             return fail(err0, FailureInfo.EQUITY_WITHDRAWAL_CALCULATE_EQUITY);
1474         }
1475 
1476         if (amount > equity) {
1477             return fail(Error.EQUITY_INSUFFICIENT_BALANCE, FailureInfo.EQUITY_WITHDRAWAL_AMOUNT_VALIDATION);
1478         }
1479 
1480         /////////////////////////
1481         // EFFECTS & INTERACTIONS
1482         // (No safe failures beyond this point)
1483 
1484         // We ERC-20 transfer the asset out of the protocol to the admin
1485         Error err2 = doTransferOut(asset, admin, amount);
1486         if (err2 != Error.NO_ERROR) {
1487             // This is safe since it's our first interaction and it didn't do anything if it failed
1488             return fail(err2, FailureInfo.EQUITY_WITHDRAWAL_TRANSFER_OUT_FAILED);
1489         }
1490 
1491         //event EquityWithdrawn(address asset, uint equityAvailableBefore, uint amount, address owner)
1492         emit EquityWithdrawn(asset, equity, amount, admin);
1493 
1494         return uint(Error.NO_ERROR); // success
1495     }
1496 
1497     /**
1498       * The `SupplyLocalVars` struct is used internally in the `supply` function.
1499       *
1500       * To avoid solidity limits on the number of local variables we:
1501       * 1. Use a struct to hold local computation localResults
1502       * 2. Re-use a single variable for Error returns. (This is required with 1 because variable binding to tuple localResults
1503       *    requires either both to be declared inline or both to be previously declared.
1504       * 3. Re-use a boolean error-like return variable.
1505       */
1506     struct SupplyLocalVars {
1507         uint startingBalance;
1508         uint newSupplyIndex;
1509         uint userSupplyCurrent;
1510         uint userSupplyUpdated;
1511         uint newTotalSupply;
1512         uint currentCash;
1513         uint updatedCash;
1514         uint newSupplyRateMantissa;
1515         uint newBorrowIndex;
1516         uint newBorrowRateMantissa;
1517     }
1518 
1519 
1520     /**
1521       * @notice supply `amount` of `asset` (which must be supported) to `msg.sender` in the protocol
1522       * @dev add amount of supported asset to msg.sender's account
1523       * @param asset The market asset to supply
1524       * @param amount The amount to supply
1525       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1526       */
1527     function supply(address asset, uint amount) public returns (uint) {
1528         if (paused) {
1529             return fail(Error.CONTRACT_PAUSED, FailureInfo.SUPPLY_CONTRACT_PAUSED);
1530         }
1531 
1532         Market storage market = markets[asset];
1533         Balance storage balance = supplyBalances[msg.sender][asset];
1534 
1535         SupplyLocalVars memory localResults; // Holds all our uint calculation results
1536         Error err; // Re-used for every function call that includes an Error in its return value(s).
1537         uint rateCalculationResultCode; // Used for 2 interest rate calculation calls
1538 
1539         // Fail if market not supported
1540         if (!market.isSupported) {
1541             return fail(Error.MARKET_NOT_SUPPORTED, FailureInfo.SUPPLY_MARKET_NOT_SUPPORTED);
1542         }
1543 
1544         // Fail gracefully if asset is not approved or has insufficient balance
1545         err = checkTransferIn(asset, msg.sender, amount);
1546         if (err != Error.NO_ERROR) {
1547             return fail(err, FailureInfo.SUPPLY_TRANSFER_IN_NOT_POSSIBLE);
1548         }
1549 
1550         // We calculate the newSupplyIndex, user's supplyCurrent and supplyUpdated for the asset
1551         (err, localResults.newSupplyIndex) = calculateInterestIndex(market.supplyIndex, market.supplyRateMantissa, market.blockNumber, getBlockNumber());
1552         if (err != Error.NO_ERROR) {
1553             return fail(err, FailureInfo.SUPPLY_NEW_SUPPLY_INDEX_CALCULATION_FAILED);
1554         }
1555 
1556         (err, localResults.userSupplyCurrent) = calculateBalance(balance.principal, balance.interestIndex, localResults.newSupplyIndex);
1557         if (err != Error.NO_ERROR) {
1558             return fail(err, FailureInfo.SUPPLY_ACCUMULATED_BALANCE_CALCULATION_FAILED);
1559         }
1560 
1561         (err, localResults.userSupplyUpdated) = add(localResults.userSupplyCurrent, amount);
1562         if (err != Error.NO_ERROR) {
1563             return fail(err, FailureInfo.SUPPLY_NEW_TOTAL_BALANCE_CALCULATION_FAILED);
1564         }
1565 
1566         // We calculate the protocol's totalSupply by subtracting the user's prior checkpointed balance, adding user's updated supply
1567         (err, localResults.newTotalSupply) = addThenSub(market.totalSupply, localResults.userSupplyUpdated, balance.principal);
1568         if (err != Error.NO_ERROR) {
1569             return fail(err, FailureInfo.SUPPLY_NEW_TOTAL_SUPPLY_CALCULATION_FAILED);
1570         }
1571 
1572         // We need to calculate what the updated cash will be after we transfer in from user
1573         localResults.currentCash = getCash(asset);
1574 
1575         (err, localResults.updatedCash) = add(localResults.currentCash, amount);
1576         if (err != Error.NO_ERROR) {
1577             return fail(err, FailureInfo.SUPPLY_NEW_TOTAL_CASH_CALCULATION_FAILED);
1578         }
1579 
1580         // The utilization rate has changed! We calculate a new supply index and borrow index for the asset, and save it.
1581         (rateCalculationResultCode, localResults.newSupplyRateMantissa) = market.interestRateModel.getSupplyRate(asset, localResults.updatedCash, market.totalBorrows);
1582         if (rateCalculationResultCode != 0) {
1583             return failOpaque(FailureInfo.SUPPLY_NEW_SUPPLY_RATE_CALCULATION_FAILED, rateCalculationResultCode);
1584         }
1585 
1586         // We calculate the newBorrowIndex (we already had newSupplyIndex)
1587         (err, localResults.newBorrowIndex) = calculateInterestIndex(market.borrowIndex, market.borrowRateMantissa, market.blockNumber, getBlockNumber());
1588         if (err != Error.NO_ERROR) {
1589             return fail(err, FailureInfo.SUPPLY_NEW_BORROW_INDEX_CALCULATION_FAILED);
1590         }
1591 
1592         (rateCalculationResultCode, localResults.newBorrowRateMantissa) = market.interestRateModel.getBorrowRate(asset, localResults.updatedCash, market.totalBorrows);
1593         if (rateCalculationResultCode != 0) {
1594             return failOpaque(FailureInfo.SUPPLY_NEW_BORROW_RATE_CALCULATION_FAILED, rateCalculationResultCode);
1595         }
1596 
1597         /////////////////////////
1598         // EFFECTS & INTERACTIONS
1599         // (No safe failures beyond this point)
1600 
1601         // We ERC-20 transfer the asset into the protocol (note: pre-conditions already checked above)
1602         err = doTransferIn(asset, msg.sender, amount);
1603         if (err != Error.NO_ERROR) {
1604             // This is safe since it's our first interaction and it didn't do anything if it failed
1605             return fail(err, FailureInfo.SUPPLY_TRANSFER_IN_FAILED);
1606         }
1607 
1608         // Save market updates
1609         market.blockNumber = getBlockNumber();
1610         market.totalSupply =  localResults.newTotalSupply;
1611         market.supplyRateMantissa = localResults.newSupplyRateMantissa;
1612         market.supplyIndex = localResults.newSupplyIndex;
1613         market.borrowRateMantissa = localResults.newBorrowRateMantissa;
1614         market.borrowIndex = localResults.newBorrowIndex;
1615 
1616         // Save user updates
1617         localResults.startingBalance = balance.principal; // save for use in `SupplyReceived` event
1618         balance.principal = localResults.userSupplyUpdated;
1619         balance.interestIndex = localResults.newSupplyIndex;
1620 
1621         emit SupplyReceived(msg.sender, asset, amount, localResults.startingBalance, localResults.userSupplyUpdated);
1622 
1623         return uint(Error.NO_ERROR); // success
1624     }
1625 
1626     struct WithdrawLocalVars {
1627         uint withdrawAmount;
1628         uint startingBalance;
1629         uint newSupplyIndex;
1630         uint userSupplyCurrent;
1631         uint userSupplyUpdated;
1632         uint newTotalSupply;
1633         uint currentCash;
1634         uint updatedCash;
1635         uint newSupplyRateMantissa;
1636         uint newBorrowIndex;
1637         uint newBorrowRateMantissa;
1638 
1639         Exp accountLiquidity;
1640         Exp accountShortfall;
1641         Exp ethValueOfWithdrawal;
1642         uint withdrawCapacity;
1643     }
1644 
1645 
1646     /**
1647       * @notice withdraw `amount` of `asset` from sender's account to sender's address
1648       * @dev withdraw `amount` of `asset` from msg.sender's account to msg.sender
1649       * @param asset The market asset to withdraw
1650       * @param requestedAmount The amount to withdraw (or -1 for max)
1651       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1652       */
1653     function withdraw(address asset, uint requestedAmount) public returns (uint) {
1654         if (paused) {
1655             return fail(Error.CONTRACT_PAUSED, FailureInfo.WITHDRAW_CONTRACT_PAUSED);
1656         }
1657 
1658         Market storage market = markets[asset];
1659         Balance storage supplyBalance = supplyBalances[msg.sender][asset];
1660 
1661         WithdrawLocalVars memory localResults; // Holds all our calculation results
1662         Error err; // Re-used for every function call that includes an Error in its return value(s).
1663         uint rateCalculationResultCode; // Used for 2 interest rate calculation calls
1664 
1665         // We calculate the user's accountLiquidity and accountShortfall.
1666         (err, localResults.accountLiquidity, localResults.accountShortfall) = calculateAccountLiquidity(msg.sender);
1667         if (err != Error.NO_ERROR) {
1668             return fail(err, FailureInfo.WITHDRAW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED);
1669         }
1670 
1671         // We calculate the newSupplyIndex, user's supplyCurrent and supplyUpdated for the asset
1672         (err, localResults.newSupplyIndex) = calculateInterestIndex(market.supplyIndex, market.supplyRateMantissa, market.blockNumber, getBlockNumber());
1673         if (err != Error.NO_ERROR) {
1674             return fail(err, FailureInfo.WITHDRAW_NEW_SUPPLY_INDEX_CALCULATION_FAILED);
1675         }
1676 
1677         (err, localResults.userSupplyCurrent) = calculateBalance(supplyBalance.principal, supplyBalance.interestIndex, localResults.newSupplyIndex);
1678         if (err != Error.NO_ERROR) {
1679             return fail(err, FailureInfo.WITHDRAW_ACCUMULATED_BALANCE_CALCULATION_FAILED);
1680         }
1681 
1682         // If the user specifies -1 amount to withdraw ("max"),  withdrawAmount => the lesser of withdrawCapacity and supplyCurrent
1683         if (requestedAmount == uint(-1)) {
1684             (err, localResults.withdrawCapacity) = getAssetAmountForValue(asset, localResults.accountLiquidity);
1685             if (err != Error.NO_ERROR) {
1686                 return fail(err, FailureInfo.WITHDRAW_CAPACITY_CALCULATION_FAILED);
1687             }
1688             localResults.withdrawAmount = min(localResults.withdrawCapacity, localResults.userSupplyCurrent);
1689         } else {
1690             localResults.withdrawAmount = requestedAmount;
1691         }
1692 
1693         // From here on we should NOT use requestedAmount.
1694 
1695         // Fail gracefully if protocol has insufficient cash
1696         // If protocol has insufficient cash, the sub operation will underflow.
1697         localResults.currentCash = getCash(asset);
1698         (err, localResults.updatedCash) = sub(localResults.currentCash, localResults.withdrawAmount);
1699         if (err != Error.NO_ERROR) {
1700             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.WITHDRAW_TRANSFER_OUT_NOT_POSSIBLE);
1701         }
1702 
1703         // We check that the amount is less than or equal to supplyCurrent
1704         // If amount is greater than supplyCurrent, this will fail with Error.INTEGER_UNDERFLOW
1705         (err, localResults.userSupplyUpdated) = sub(localResults.userSupplyCurrent, localResults.withdrawAmount);
1706         if (err != Error.NO_ERROR) {
1707             return fail(Error.INSUFFICIENT_BALANCE, FailureInfo.WITHDRAW_NEW_TOTAL_BALANCE_CALCULATION_FAILED);
1708         }
1709 
1710         // Fail if customer already has a shortfall
1711         if (!isZeroExp(localResults.accountShortfall)) {
1712             return fail(Error.INSUFFICIENT_LIQUIDITY, FailureInfo.WITHDRAW_ACCOUNT_SHORTFALL_PRESENT);
1713         }
1714 
1715         // We want to know the user's withdrawCapacity, denominated in the asset
1716         // Customer's withdrawCapacity of asset is (accountLiquidity in Eth)/ (price of asset in Eth)
1717         // Equivalently, we calculate the eth value of the withdrawal amount and compare it directly to the accountLiquidity in Eth
1718         (err, localResults.ethValueOfWithdrawal) = getPriceForAssetAmount(asset, localResults.withdrawAmount); // amount * oraclePrice = ethValueOfWithdrawal
1719         if (err != Error.NO_ERROR) {
1720             return fail(err, FailureInfo.WITHDRAW_AMOUNT_VALUE_CALCULATION_FAILED);
1721         }
1722 
1723         // We check that the amount is less than withdrawCapacity (here), and less than or equal to supplyCurrent (below)
1724         if (lessThanExp(localResults.accountLiquidity, localResults.ethValueOfWithdrawal) ) {
1725             return fail(Error.INSUFFICIENT_LIQUIDITY, FailureInfo.WITHDRAW_AMOUNT_LIQUIDITY_SHORTFALL);
1726         }
1727 
1728         // We calculate the protocol's totalSupply by subtracting the user's prior checkpointed balance, adding user's updated supply.
1729         // Note that, even though the customer is withdrawing, if they've accumulated a lot of interest since their last
1730         // action, the updated balance *could* be higher than the prior checkpointed balance.
1731         (err, localResults.newTotalSupply) = addThenSub(market.totalSupply, localResults.userSupplyUpdated, supplyBalance.principal);
1732         if (err != Error.NO_ERROR) {
1733             return fail(err, FailureInfo.WITHDRAW_NEW_TOTAL_SUPPLY_CALCULATION_FAILED);
1734         }
1735 
1736         // The utilization rate has changed! We calculate a new supply index and borrow index for the asset, and save it.
1737         (rateCalculationResultCode, localResults.newSupplyRateMantissa) = market.interestRateModel.getSupplyRate(asset, localResults.updatedCash, market.totalBorrows);
1738         if (rateCalculationResultCode != 0) {
1739             return failOpaque(FailureInfo.WITHDRAW_NEW_SUPPLY_RATE_CALCULATION_FAILED, rateCalculationResultCode);
1740         }
1741 
1742         // We calculate the newBorrowIndex
1743         (err, localResults.newBorrowIndex) = calculateInterestIndex(market.borrowIndex, market.borrowRateMantissa, market.blockNumber, getBlockNumber());
1744         if (err != Error.NO_ERROR) {
1745             return fail(err, FailureInfo.WITHDRAW_NEW_BORROW_INDEX_CALCULATION_FAILED);
1746         }
1747 
1748         (rateCalculationResultCode, localResults.newBorrowRateMantissa) = market.interestRateModel.getBorrowRate(asset, localResults.updatedCash, market.totalBorrows);
1749         if (rateCalculationResultCode != 0) {
1750             return failOpaque(FailureInfo.WITHDRAW_NEW_BORROW_RATE_CALCULATION_FAILED, rateCalculationResultCode);
1751         }
1752 
1753         /////////////////////////
1754         // EFFECTS & INTERACTIONS
1755         // (No safe failures beyond this point)
1756 
1757         // We ERC-20 transfer the asset into the protocol (note: pre-conditions already checked above)
1758         err = doTransferOut(asset, msg.sender, localResults.withdrawAmount);
1759         if (err != Error.NO_ERROR) {
1760             // This is safe since it's our first interaction and it didn't do anything if it failed
1761             return fail(err, FailureInfo.WITHDRAW_TRANSFER_OUT_FAILED);
1762         }
1763 
1764         // Save market updates
1765         market.blockNumber = getBlockNumber();
1766         market.totalSupply =  localResults.newTotalSupply;
1767         market.supplyRateMantissa = localResults.newSupplyRateMantissa;
1768         market.supplyIndex = localResults.newSupplyIndex;
1769         market.borrowRateMantissa = localResults.newBorrowRateMantissa;
1770         market.borrowIndex = localResults.newBorrowIndex;
1771 
1772         // Save user updates
1773         localResults.startingBalance = supplyBalance.principal; // save for use in `SupplyWithdrawn` event
1774         supplyBalance.principal = localResults.userSupplyUpdated;
1775         supplyBalance.interestIndex = localResults.newSupplyIndex;
1776 
1777         emit SupplyWithdrawn(msg.sender, asset, localResults.withdrawAmount, localResults.startingBalance, localResults.userSupplyUpdated);
1778 
1779         return uint(Error.NO_ERROR); // success
1780     }
1781 
1782     struct AccountValueLocalVars {
1783         address assetAddress;
1784         uint collateralMarketsLength;
1785 
1786         uint newSupplyIndex;
1787         uint userSupplyCurrent;
1788         Exp supplyTotalValue;
1789         Exp sumSupplies;
1790 
1791         uint newBorrowIndex;
1792         uint userBorrowCurrent;
1793         Exp borrowTotalValue;
1794         Exp sumBorrows;
1795     }
1796 
1797     /**
1798       * @dev Gets the user's account liquidity and account shortfall balances. This includes
1799       *      any accumulated interest thus far but does NOT actually update anything in
1800       *      storage, it simply calculates the account liquidity and shortfall with liquidity being
1801       *      returned as the first Exp, ie (Error, accountLiquidity, accountShortfall).
1802       */
1803     function calculateAccountLiquidity(address userAddress) internal view returns (Error, Exp memory, Exp memory) {
1804         Error err;
1805         uint sumSupplyValuesMantissa;
1806         uint sumBorrowValuesMantissa;
1807         (err, sumSupplyValuesMantissa, sumBorrowValuesMantissa) = calculateAccountValuesInternal(userAddress);
1808         if (err != Error.NO_ERROR) {
1809             return(err, Exp({mantissa: 0}), Exp({mantissa: 0}));
1810         }
1811 
1812         Exp memory result;
1813         
1814         Exp memory sumSupplyValuesFinal = Exp({mantissa: sumSupplyValuesMantissa});
1815         Exp memory sumBorrowValuesFinal; // need to apply collateral ratio
1816 
1817         (err, sumBorrowValuesFinal) = mulExp(collateralRatio, Exp({mantissa: sumBorrowValuesMantissa}));
1818         if (err != Error.NO_ERROR) {
1819             return (err, Exp({mantissa: 0}), Exp({mantissa: 0}));
1820         }
1821 
1822         // if sumSupplies < sumBorrows, then the user is under collateralized and has account shortfall.
1823         // else the user meets the collateral ratio and has account liquidity.
1824         if (lessThanExp(sumSupplyValuesFinal, sumBorrowValuesFinal)) {
1825             // accountShortfall = borrows - supplies
1826             (err, result) = subExp(sumBorrowValuesFinal, sumSupplyValuesFinal);
1827             assert(err == Error.NO_ERROR); // Note: we have checked that sumBorrows is greater than sumSupplies directly above, therefore `subExp` cannot fail.
1828 
1829             return (Error.NO_ERROR, Exp({mantissa: 0}), result);
1830         } else {
1831             // accountLiquidity = supplies - borrows
1832             (err, result) = subExp(sumSupplyValuesFinal, sumBorrowValuesFinal);
1833             assert(err == Error.NO_ERROR); // Note: we have checked that sumSupplies is greater than sumBorrows directly above, therefore `subExp` cannot fail.
1834 
1835             return (Error.NO_ERROR, result, Exp({mantissa: 0}));
1836         }
1837     }
1838 
1839     /**
1840       * @notice Gets the ETH values of the user's accumulated supply and borrow balances, scaled by 10e18.
1841       *         This includes any accumulated interest thus far but does NOT actually update anything in
1842       *         storage
1843       * @dev Gets ETH values of accumulated supply and borrow balances
1844       * @param userAddress account for which to sum values
1845       * @return (error code, sum ETH value of supplies scaled by 10e18, sum ETH value of borrows scaled by 10e18)
1846       * TODO: Possibly should add a Min(500, collateralMarkets.length) for extra safety
1847       * TODO: To help save gas we could think about using the current Market.interestIndex
1848       *       accumulate interest rather than calculating it
1849       */
1850     function calculateAccountValuesInternal(address userAddress) internal view returns (Error, uint, uint) {
1851         
1852         /** By definition, all collateralMarkets are those that contribute to the user's
1853           * liquidity and shortfall so we need only loop through those markets.
1854           * To handle avoiding intermediate negative results, we will sum all the user's
1855           * supply balances and borrow balances (with collateral ratio) separately and then
1856           * subtract the sums at the end.
1857           */
1858 
1859         AccountValueLocalVars memory localResults; // Re-used for all intermediate results
1860         localResults.sumSupplies = Exp({mantissa: 0});
1861         localResults.sumBorrows = Exp({mantissa: 0});
1862         Error err; // Re-used for all intermediate errors
1863         localResults.collateralMarketsLength = collateralMarkets.length;
1864 
1865         for (uint i = 0; i < localResults.collateralMarketsLength; i++) {
1866             localResults.assetAddress = collateralMarkets[i];
1867             Market storage currentMarket = markets[localResults.assetAddress];
1868             Balance storage supplyBalance = supplyBalances[userAddress][localResults.assetAddress];
1869             Balance storage borrowBalance = borrowBalances[userAddress][localResults.assetAddress];
1870 
1871             if (supplyBalance.principal > 0) {
1872                 // We calculate the newSupplyIndex and user’s supplyCurrent (includes interest)
1873                 (err, localResults.newSupplyIndex) = calculateInterestIndex(currentMarket.supplyIndex, currentMarket.supplyRateMantissa, currentMarket.blockNumber, getBlockNumber());
1874                 if (err != Error.NO_ERROR) {
1875                     return (err, 0, 0);
1876                 }
1877 
1878                 (err, localResults.userSupplyCurrent) = calculateBalance(supplyBalance.principal, supplyBalance.interestIndex, localResults.newSupplyIndex);
1879                 if (err != Error.NO_ERROR) {
1880                     return (err, 0, 0);
1881                 }
1882 
1883                 // We have the user's supply balance with interest so let's multiply by the asset price to get the total value
1884                 (err, localResults.supplyTotalValue) = getPriceForAssetAmount(localResults.assetAddress, localResults.userSupplyCurrent); // supplyCurrent * oraclePrice = supplyValueInEth
1885                 if (err != Error.NO_ERROR) {
1886                     return (err, 0, 0);
1887                 }
1888 
1889                 // Add this to our running sum of supplies
1890                 (err, localResults.sumSupplies) = addExp(localResults.supplyTotalValue, localResults.sumSupplies);
1891                 if (err != Error.NO_ERROR) {
1892                     return (err, 0, 0);
1893                 }
1894             }
1895 
1896             if (borrowBalance.principal > 0) {
1897                 // We perform a similar actions to get the user's borrow balance
1898                 (err, localResults.newBorrowIndex) = calculateInterestIndex(currentMarket.borrowIndex, currentMarket.borrowRateMantissa, currentMarket.blockNumber, getBlockNumber());
1899                 if (err != Error.NO_ERROR) {
1900                     return (err, 0, 0);
1901                 }
1902 
1903                 (err, localResults.userBorrowCurrent) = calculateBalance(borrowBalance.principal, borrowBalance.interestIndex, localResults.newBorrowIndex);
1904                 if (err != Error.NO_ERROR) {
1905                     return (err, 0, 0);
1906                 }
1907 
1908                 // In the case of borrow, we multiply the borrow value by the collateral ratio
1909                 (err, localResults.borrowTotalValue) = getPriceForAssetAmount(localResults.assetAddress, localResults.userBorrowCurrent); // ( borrowCurrent* oraclePrice * collateralRatio) = borrowTotalValueInEth
1910                 if (err != Error.NO_ERROR) {
1911                     return (err, 0, 0);
1912                 }
1913 
1914                 // Add this to our running sum of borrows
1915                 (err, localResults.sumBorrows) = addExp(localResults.borrowTotalValue, localResults.sumBorrows);
1916                 if (err != Error.NO_ERROR) {
1917                     return (err, 0, 0);
1918                 }
1919             }
1920         }
1921         
1922         return (Error.NO_ERROR, localResults.sumSupplies.mantissa, localResults.sumBorrows.mantissa);
1923     }
1924 
1925     /**
1926       * @notice Gets the ETH values of the user's accumulated supply and borrow balances, scaled by 10e18.
1927       *         This includes any accumulated interest thus far but does NOT actually update anything in
1928       *         storage
1929       * @dev Gets ETH values of accumulated supply and borrow balances
1930       * @param userAddress account for which to sum values
1931       * @return (uint 0=success; otherwise a failure (see ErrorReporter.sol for details),
1932       *          sum ETH value of supplies scaled by 10e18,
1933       *          sum ETH value of borrows scaled by 10e18)
1934       */
1935     function calculateAccountValues(address userAddress) public view returns (uint, uint, uint) {
1936         (Error err, uint supplyValue, uint borrowValue) = calculateAccountValuesInternal(userAddress);
1937         if (err != Error.NO_ERROR) {
1938 
1939             return (uint(err), 0, 0);
1940         }
1941 
1942         return (0, supplyValue, borrowValue);
1943     }
1944 
1945     struct PayBorrowLocalVars {
1946         uint newBorrowIndex;
1947         uint userBorrowCurrent;
1948         uint repayAmount;
1949 
1950         uint userBorrowUpdated;
1951         uint newTotalBorrows;
1952         uint currentCash;
1953         uint updatedCash;
1954 
1955         uint newSupplyIndex;
1956         uint newSupplyRateMantissa;
1957         uint newBorrowRateMantissa;
1958 
1959         uint startingBalance;
1960     }
1961 
1962     /**
1963       * @notice Users repay borrowed assets from their own address to the protocol.
1964       * @param asset The market asset to repay
1965       * @param amount The amount to repay (or -1 for max)
1966       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1967       */
1968     function repayBorrow(address asset, uint amount) public returns (uint) {
1969         if (paused) {
1970             return fail(Error.CONTRACT_PAUSED, FailureInfo.REPAY_BORROW_CONTRACT_PAUSED);
1971         }
1972         PayBorrowLocalVars memory localResults;
1973         Market storage market = markets[asset];
1974         Balance storage borrowBalance = borrowBalances[msg.sender][asset];
1975         Error err;
1976         uint rateCalculationResultCode;
1977 
1978         // We calculate the newBorrowIndex, user's borrowCurrent and borrowUpdated for the asset
1979         (err, localResults.newBorrowIndex) = calculateInterestIndex(market.borrowIndex, market.borrowRateMantissa, market.blockNumber, getBlockNumber());
1980         if (err != Error.NO_ERROR) {
1981             return fail(err, FailureInfo.REPAY_BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED);
1982         }
1983 
1984         (err, localResults.userBorrowCurrent) = calculateBalance(borrowBalance.principal, borrowBalance.interestIndex, localResults.newBorrowIndex);
1985         if (err != Error.NO_ERROR) {
1986             return fail(err, FailureInfo.REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED);
1987         }
1988 
1989         // If the user specifies -1 amount to repay (“max”), repayAmount =>
1990         // the lesser of the senders ERC-20 balance and borrowCurrent
1991         if (amount == uint(-1)) {
1992             localResults.repayAmount = min(getBalanceOf(asset, msg.sender), localResults.userBorrowCurrent);
1993         } else {
1994             localResults.repayAmount = amount;
1995         }
1996 
1997         // Subtract the `repayAmount` from the `userBorrowCurrent` to get `userBorrowUpdated`
1998         // Note: this checks that repayAmount is less than borrowCurrent
1999         (err, localResults.userBorrowUpdated) = sub(localResults.userBorrowCurrent, localResults.repayAmount);
2000         if (err != Error.NO_ERROR) {
2001             return fail(err, FailureInfo.REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED);
2002         }
2003 
2004         // Fail gracefully if asset is not approved or has insufficient balance
2005         // Note: this checks that repayAmount is less than or equal to their ERC-20 balance
2006         err = checkTransferIn(asset, msg.sender, localResults.repayAmount);
2007         if (err != Error.NO_ERROR) {
2008             return fail(err, FailureInfo.REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE);
2009         }
2010 
2011         // We calculate the protocol's totalBorrow by subtracting the user's prior checkpointed balance, adding user's updated borrow
2012         // Note that, even though the customer is paying some of their borrow, if they've accumulated a lot of interest since their last
2013         // action, the updated balance *could* be higher than the prior checkpointed balance.
2014         (err, localResults.newTotalBorrows) = addThenSub(market.totalBorrows, localResults.userBorrowUpdated, borrowBalance.principal);
2015         if (err != Error.NO_ERROR) {
2016             return fail(err, FailureInfo.REPAY_BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED);
2017         }
2018 
2019         // We need to calculate what the updated cash will be after we transfer in from user
2020         localResults.currentCash = getCash(asset);
2021 
2022         (err, localResults.updatedCash) = add(localResults.currentCash, localResults.repayAmount);
2023         if (err != Error.NO_ERROR) {
2024             return fail(err, FailureInfo.REPAY_BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED);
2025         }
2026 
2027         // The utilization rate has changed! We calculate a new supply index and borrow index for the asset, and save it.
2028 
2029         // We calculate the newSupplyIndex, but we have newBorrowIndex already
2030         (err, localResults.newSupplyIndex) = calculateInterestIndex(market.supplyIndex, market.supplyRateMantissa, market.blockNumber, getBlockNumber());
2031         if (err != Error.NO_ERROR) {
2032             return fail(err, FailureInfo.REPAY_BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED);
2033         }
2034 
2035         (rateCalculationResultCode, localResults.newSupplyRateMantissa) = market.interestRateModel.getSupplyRate(asset, localResults.updatedCash, localResults.newTotalBorrows);
2036         if (rateCalculationResultCode != 0) {
2037             return failOpaque(FailureInfo.REPAY_BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED, rateCalculationResultCode);
2038         }
2039 
2040         (rateCalculationResultCode, localResults.newBorrowRateMantissa) = market.interestRateModel.getBorrowRate(asset, localResults.updatedCash, localResults.newTotalBorrows);
2041         if (rateCalculationResultCode != 0) {
2042             return failOpaque(FailureInfo.REPAY_BORROW_NEW_BORROW_RATE_CALCULATION_FAILED, rateCalculationResultCode);
2043         }
2044 
2045         /////////////////////////
2046         // EFFECTS & INTERACTIONS
2047         // (No safe failures beyond this point)
2048 
2049         // We ERC-20 transfer the asset into the protocol (note: pre-conditions already checked above)
2050         err = doTransferIn(asset, msg.sender, localResults.repayAmount);
2051         if (err != Error.NO_ERROR) {
2052             // This is safe since it's our first interaction and it didn't do anything if it failed
2053             return fail(err, FailureInfo.REPAY_BORROW_TRANSFER_IN_FAILED);
2054         }
2055 
2056         // Save market updates
2057         market.blockNumber = getBlockNumber();
2058         market.totalBorrows =  localResults.newTotalBorrows;
2059         market.supplyRateMantissa = localResults.newSupplyRateMantissa;
2060         market.supplyIndex = localResults.newSupplyIndex;
2061         market.borrowRateMantissa = localResults.newBorrowRateMantissa;
2062         market.borrowIndex = localResults.newBorrowIndex;
2063 
2064         // Save user updates
2065         localResults.startingBalance = borrowBalance.principal; // save for use in `BorrowRepaid` event
2066         borrowBalance.principal = localResults.userBorrowUpdated;
2067         borrowBalance.interestIndex = localResults.newBorrowIndex;
2068 
2069         emit BorrowRepaid(msg.sender, asset, localResults.repayAmount, localResults.startingBalance, localResults.userBorrowUpdated);
2070 
2071         return uint(Error.NO_ERROR); // success
2072     }
2073 
2074     struct BorrowLocalVars {
2075         uint newBorrowIndex;
2076         uint userBorrowCurrent;
2077         uint borrowAmountWithFee;
2078 
2079         uint userBorrowUpdated;
2080         uint newTotalBorrows;
2081         uint currentCash;
2082         uint updatedCash;
2083 
2084         uint newSupplyIndex;
2085         uint newSupplyRateMantissa;
2086         uint newBorrowRateMantissa;
2087 
2088         uint startingBalance;
2089 
2090         Exp accountLiquidity;
2091         Exp accountShortfall;
2092         Exp ethValueOfBorrowAmountWithFee;
2093     }
2094 
2095     struct LiquidateLocalVars {
2096         // we need these addresses in the struct for use with `emitLiquidationEvent` to avoid `CompilerError: Stack too deep, try removing local variables.`
2097         address targetAccount;
2098         address assetBorrow;
2099         address liquidator;
2100         address assetCollateral;
2101 
2102         // borrow index and supply index are global to the asset, not specific to the user
2103         uint newBorrowIndex_UnderwaterAsset;
2104         uint newSupplyIndex_UnderwaterAsset;
2105         uint newBorrowIndex_CollateralAsset;
2106         uint newSupplyIndex_CollateralAsset;
2107 
2108         // the target borrow's full balance with accumulated interest
2109         uint currentBorrowBalance_TargetUnderwaterAsset;
2110         // currentBorrowBalance_TargetUnderwaterAsset minus whatever gets repaid as part of the liquidation
2111         uint updatedBorrowBalance_TargetUnderwaterAsset;
2112 
2113         uint newTotalBorrows_ProtocolUnderwaterAsset;
2114 
2115         uint startingBorrowBalance_TargetUnderwaterAsset;
2116         uint startingSupplyBalance_TargetCollateralAsset;
2117         uint startingSupplyBalance_LiquidatorCollateralAsset;
2118 
2119         uint currentSupplyBalance_TargetCollateralAsset;
2120         uint updatedSupplyBalance_TargetCollateralAsset;
2121 
2122         // If liquidator already has a balance of collateralAsset, we will accumulate
2123         // interest on it before transferring seized collateral from the borrower.
2124         uint currentSupplyBalance_LiquidatorCollateralAsset;
2125         // This will be the liquidator's accumulated balance of collateral asset before the liquidation (if any)
2126         // plus the amount seized from the borrower.
2127         uint updatedSupplyBalance_LiquidatorCollateralAsset;
2128 
2129         uint newTotalSupply_ProtocolCollateralAsset;
2130         uint currentCash_ProtocolUnderwaterAsset;
2131         uint updatedCash_ProtocolUnderwaterAsset;
2132 
2133         // cash does not change for collateral asset
2134 
2135         uint newSupplyRateMantissa_ProtocolUnderwaterAsset;
2136         uint newBorrowRateMantissa_ProtocolUnderwaterAsset;
2137 
2138         // Why no variables for the interest rates for the collateral asset?
2139         // We don't need to calculate new rates for the collateral asset since neither cash nor borrows change
2140 
2141         uint discountedRepayToEvenAmount;
2142 
2143         //[supplyCurrent / (1 + liquidationDiscount)] * (Oracle price for the collateral / Oracle price for the borrow) (discountedBorrowDenominatedCollateral)
2144         uint discountedBorrowDenominatedCollateral;
2145 
2146         uint maxCloseableBorrowAmount_TargetUnderwaterAsset;
2147         uint closeBorrowAmount_TargetUnderwaterAsset;
2148         uint seizeSupplyAmount_TargetCollateralAsset;
2149 
2150         Exp collateralPrice;
2151         Exp underwaterAssetPrice;
2152     }
2153 
2154     /**
2155       * @notice users repay all or some of an underwater borrow and receive collateral
2156       * @param targetAccount The account whose borrow should be liquidated
2157       * @param assetBorrow The market asset to repay
2158       * @param assetCollateral The borrower's market asset to receive in exchange
2159       * @param requestedAmountClose The amount to repay (or -1 for max)
2160       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2161       */
2162     function liquidateBorrow(address targetAccount, address assetBorrow, address assetCollateral, uint requestedAmountClose) public returns (uint) {
2163         if (paused) {
2164             return fail(Error.CONTRACT_PAUSED, FailureInfo.LIQUIDATE_CONTRACT_PAUSED);
2165         }
2166         LiquidateLocalVars memory localResults;
2167         // Copy these addresses into the struct for use with `emitLiquidationEvent`
2168         // We'll use localResults.liquidator inside this function for clarity vs using msg.sender.
2169         localResults.targetAccount = targetAccount;
2170         localResults.assetBorrow = assetBorrow;
2171         localResults.liquidator = msg.sender;
2172         localResults.assetCollateral = assetCollateral;
2173 
2174         Market storage borrowMarket = markets[assetBorrow];
2175         Market storage collateralMarket = markets[assetCollateral];
2176         Balance storage borrowBalance_TargeUnderwaterAsset = borrowBalances[targetAccount][assetBorrow];
2177         Balance storage supplyBalance_TargetCollateralAsset = supplyBalances[targetAccount][assetCollateral];
2178 
2179         // Liquidator might already hold some of the collateral asset
2180         Balance storage supplyBalance_LiquidatorCollateralAsset = supplyBalances[localResults.liquidator][assetCollateral];
2181 
2182         uint rateCalculationResultCode; // Used for multiple interest rate calculation calls
2183         Error err; // re-used for all intermediate errors
2184 
2185         (err, localResults.collateralPrice) = fetchAssetPrice(assetCollateral);
2186         if(err != Error.NO_ERROR) {
2187             return fail(err, FailureInfo.LIQUIDATE_FETCH_ASSET_PRICE_FAILED);
2188         }
2189 
2190         (err, localResults.underwaterAssetPrice) = fetchAssetPrice(assetBorrow);
2191         // If the price oracle is not set, then we would have failed on the first call to fetchAssetPrice
2192         assert(err == Error.NO_ERROR);
2193 
2194         // We calculate newBorrowIndex_UnderwaterAsset and then use it to help calculate currentBorrowBalance_TargetUnderwaterAsset
2195         (err, localResults.newBorrowIndex_UnderwaterAsset) = calculateInterestIndex(borrowMarket.borrowIndex, borrowMarket.borrowRateMantissa, borrowMarket.blockNumber, getBlockNumber());
2196         if (err != Error.NO_ERROR) {
2197             return fail(err, FailureInfo.LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_BORROWED_ASSET);
2198         }
2199 
2200         (err, localResults.currentBorrowBalance_TargetUnderwaterAsset) = calculateBalance(borrowBalance_TargeUnderwaterAsset.principal, borrowBalance_TargeUnderwaterAsset.interestIndex, localResults.newBorrowIndex_UnderwaterAsset);
2201         if (err != Error.NO_ERROR) {
2202             return fail(err, FailureInfo.LIQUIDATE_ACCUMULATED_BORROW_BALANCE_CALCULATION_FAILED);
2203         }
2204 
2205         // We calculate newSupplyIndex_CollateralAsset and then use it to help calculate currentSupplyBalance_TargetCollateralAsset
2206         (err, localResults.newSupplyIndex_CollateralAsset) = calculateInterestIndex(collateralMarket.supplyIndex, collateralMarket.supplyRateMantissa, collateralMarket.blockNumber, getBlockNumber());
2207         if (err != Error.NO_ERROR) {
2208             return fail(err, FailureInfo.LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET);
2209         }
2210 
2211         (err, localResults.currentSupplyBalance_TargetCollateralAsset) = calculateBalance(supplyBalance_TargetCollateralAsset.principal, supplyBalance_TargetCollateralAsset.interestIndex, localResults.newSupplyIndex_CollateralAsset);
2212         if (err != Error.NO_ERROR) {
2213             return fail(err, FailureInfo.LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET);
2214         }
2215 
2216         // Liquidator may or may not already have some collateral asset.
2217         // If they do, we need to accumulate interest on it before adding the seized collateral to it.
2218         // We re-use newSupplyIndex_CollateralAsset calculated above to help calculate currentSupplyBalance_LiquidatorCollateralAsset
2219         (err, localResults.currentSupplyBalance_LiquidatorCollateralAsset) = calculateBalance(supplyBalance_LiquidatorCollateralAsset.principal, supplyBalance_LiquidatorCollateralAsset.interestIndex, localResults.newSupplyIndex_CollateralAsset);
2220         if (err != Error.NO_ERROR) {
2221             return fail(err, FailureInfo.LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET);
2222         }
2223 
2224         // We update the protocol's totalSupply for assetCollateral in 2 steps, first by adding target user's accumulated
2225         // interest and then by adding the liquidator's accumulated interest.
2226 
2227         // Step 1 of 2: We add the target user's supplyCurrent and subtract their checkpointedBalance
2228         // (which has the desired effect of adding accrued interest from the target user)
2229         (err, localResults.newTotalSupply_ProtocolCollateralAsset) = addThenSub(collateralMarket.totalSupply, localResults.currentSupplyBalance_TargetCollateralAsset, supplyBalance_TargetCollateralAsset.principal);
2230         if (err != Error.NO_ERROR) {
2231             return fail(err, FailureInfo.LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET);
2232         }
2233 
2234         // Step 2 of 2: We add the liquidator's supplyCurrent of collateral asset and subtract their checkpointedBalance
2235         // (which has the desired effect of adding accrued interest from the calling user)
2236         (err, localResults.newTotalSupply_ProtocolCollateralAsset) = addThenSub(localResults.newTotalSupply_ProtocolCollateralAsset, localResults.currentSupplyBalance_LiquidatorCollateralAsset, supplyBalance_LiquidatorCollateralAsset.principal);
2237         if (err != Error.NO_ERROR) {
2238             return fail(err, FailureInfo.LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET);
2239         }
2240 
2241         // We calculate maxCloseableBorrowAmount_TargetUnderwaterAsset, the amount of borrow that can be closed from the target user
2242         // This is equal to the lesser of
2243         // 1. borrowCurrent; (already calculated)
2244         // 2. ONLY IF MARKET SUPPORTED: discountedRepayToEvenAmount:
2245         // discountedRepayToEvenAmount=
2246         //      shortfall / [Oracle price for the borrow * (collateralRatio - liquidationDiscount - 1)]
2247         // 3. discountedBorrowDenominatedCollateral
2248         //      [supplyCurrent / (1 + liquidationDiscount)] * (Oracle price for the collateral / Oracle price for the borrow)
2249 
2250         // Here we calculate item 3. discountedBorrowDenominatedCollateral =
2251         // [supplyCurrent / (1 + liquidationDiscount)] * (Oracle price for the collateral / Oracle price for the borrow)
2252         (err, localResults.discountedBorrowDenominatedCollateral) =
2253         calculateDiscountedBorrowDenominatedCollateral(localResults.underwaterAssetPrice, localResults.collateralPrice, localResults.currentSupplyBalance_TargetCollateralAsset);
2254         if (err != Error.NO_ERROR) {
2255             return fail(err, FailureInfo.LIQUIDATE_BORROW_DENOMINATED_COLLATERAL_CALCULATION_FAILED);
2256         }
2257 
2258         if (borrowMarket.isSupported) {
2259             // Market is supported, so we calculate item 2 from above.
2260             (err, localResults.discountedRepayToEvenAmount) =
2261             calculateDiscountedRepayToEvenAmount(targetAccount, localResults.underwaterAssetPrice);
2262             if (err != Error.NO_ERROR) {
2263                 return fail(err, FailureInfo.LIQUIDATE_DISCOUNTED_REPAY_TO_EVEN_AMOUNT_CALCULATION_FAILED);
2264             }
2265 
2266             // We need to do a two-step min to select from all 3 values
2267             // min1&3 = min(item 1, item 3)
2268             localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset = min(localResults.currentBorrowBalance_TargetUnderwaterAsset, localResults.discountedBorrowDenominatedCollateral);
2269 
2270             // min1&3&2 = min(min1&3, 2)
2271             localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset = min(localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset, localResults.discountedRepayToEvenAmount);
2272         } else {
2273             // Market is not supported, so we don't need to calculate item 2.
2274             localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset = min(localResults.currentBorrowBalance_TargetUnderwaterAsset, localResults.discountedBorrowDenominatedCollateral);
2275         }
2276 
2277         // If liquidateBorrowAmount = -1, then closeBorrowAmount_TargetUnderwaterAsset = maxCloseableBorrowAmount_TargetUnderwaterAsset
2278         if (requestedAmountClose == uint(-1)) {
2279             localResults.closeBorrowAmount_TargetUnderwaterAsset = localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset;
2280         } else {
2281             localResults.closeBorrowAmount_TargetUnderwaterAsset = requestedAmountClose;
2282         }
2283 
2284         // From here on, no more use of `requestedAmountClose`
2285 
2286         // Verify closeBorrowAmount_TargetUnderwaterAsset <= maxCloseableBorrowAmount_TargetUnderwaterAsset
2287         if (localResults.closeBorrowAmount_TargetUnderwaterAsset > localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset) {
2288             return fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_TOO_HIGH);
2289         }
2290 
2291         // seizeSupplyAmount_TargetCollateralAsset = closeBorrowAmount_TargetUnderwaterAsset * priceBorrow/priceCollateral *(1+liquidationDiscount)
2292         (err, localResults.seizeSupplyAmount_TargetCollateralAsset) = calculateAmountSeize(localResults.underwaterAssetPrice, localResults.collateralPrice, localResults.closeBorrowAmount_TargetUnderwaterAsset);
2293         if (err != Error.NO_ERROR) {
2294             return fail(err, FailureInfo.LIQUIDATE_AMOUNT_SEIZE_CALCULATION_FAILED);
2295         }
2296 
2297         // We are going to ERC-20 transfer closeBorrowAmount_TargetUnderwaterAsset of assetBorrow into Compound
2298         // Fail gracefully if asset is not approved or has insufficient balance
2299         err = checkTransferIn(assetBorrow, localResults.liquidator, localResults.closeBorrowAmount_TargetUnderwaterAsset);
2300         if (err != Error.NO_ERROR) {
2301             return fail(err, FailureInfo.LIQUIDATE_TRANSFER_IN_NOT_POSSIBLE);
2302         }
2303 
2304         // We are going to repay the target user's borrow using the calling user's funds
2305         // We update the protocol's totalBorrow for assetBorrow, by subtracting the target user's prior checkpointed balance,
2306         // adding borrowCurrent, and subtracting closeBorrowAmount_TargetUnderwaterAsset.
2307 
2308         // Subtract the `closeBorrowAmount_TargetUnderwaterAsset` from the `currentBorrowBalance_TargetUnderwaterAsset` to get `updatedBorrowBalance_TargetUnderwaterAsset`
2309         (err, localResults.updatedBorrowBalance_TargetUnderwaterAsset) = sub(localResults.currentBorrowBalance_TargetUnderwaterAsset, localResults.closeBorrowAmount_TargetUnderwaterAsset);
2310         // We have ensured above that localResults.closeBorrowAmount_TargetUnderwaterAsset <= localResults.currentBorrowBalance_TargetUnderwaterAsset, so the sub can't underflow
2311         assert(err == Error.NO_ERROR);
2312 
2313         // We calculate the protocol's totalBorrow for assetBorrow by subtracting the user's prior checkpointed balance, adding user's updated borrow
2314         // Note that, even though the liquidator is paying some of the borrow, if the borrow has accumulated a lot of interest since the last
2315         // action, the updated balance *could* be higher than the prior checkpointed balance.
2316         (err, localResults.newTotalBorrows_ProtocolUnderwaterAsset) = addThenSub(borrowMarket.totalBorrows, localResults.updatedBorrowBalance_TargetUnderwaterAsset, borrowBalance_TargeUnderwaterAsset.principal);
2317         if (err != Error.NO_ERROR) {
2318             return fail(err, FailureInfo.LIQUIDATE_NEW_TOTAL_BORROW_CALCULATION_FAILED_BORROWED_ASSET);
2319         }
2320 
2321         // We need to calculate what the updated cash will be after we transfer in from liquidator
2322         localResults.currentCash_ProtocolUnderwaterAsset = getCash(assetBorrow);
2323         (err, localResults.updatedCash_ProtocolUnderwaterAsset) = add(localResults.currentCash_ProtocolUnderwaterAsset, localResults.closeBorrowAmount_TargetUnderwaterAsset);
2324         if (err != Error.NO_ERROR) {
2325             return fail(err, FailureInfo.LIQUIDATE_NEW_TOTAL_CASH_CALCULATION_FAILED_BORROWED_ASSET);
2326         }
2327 
2328         // The utilization rate has changed! We calculate a new supply index, borrow index, supply rate, and borrow rate for assetBorrow
2329         // (Please note that we don't need to do the same thing for assetCollateral because neither cash nor borrows of assetCollateral happen in this process.)
2330 
2331         // We calculate the newSupplyIndex_UnderwaterAsset, but we already have newBorrowIndex_UnderwaterAsset so don't recalculate it.
2332         (err, localResults.newSupplyIndex_UnderwaterAsset) = calculateInterestIndex(borrowMarket.supplyIndex, borrowMarket.supplyRateMantissa, borrowMarket.blockNumber, getBlockNumber());
2333         if (err != Error.NO_ERROR) {
2334             return fail(err, FailureInfo.LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_BORROWED_ASSET);
2335         }
2336 
2337         (rateCalculationResultCode, localResults.newSupplyRateMantissa_ProtocolUnderwaterAsset) = borrowMarket.interestRateModel.getSupplyRate(assetBorrow, localResults.updatedCash_ProtocolUnderwaterAsset, localResults.newTotalBorrows_ProtocolUnderwaterAsset);
2338         if (rateCalculationResultCode != 0) {
2339             return failOpaque(FailureInfo.LIQUIDATE_NEW_SUPPLY_RATE_CALCULATION_FAILED_BORROWED_ASSET, rateCalculationResultCode);
2340         }
2341 
2342         (rateCalculationResultCode, localResults.newBorrowRateMantissa_ProtocolUnderwaterAsset) = borrowMarket.interestRateModel.getBorrowRate(assetBorrow, localResults.updatedCash_ProtocolUnderwaterAsset, localResults.newTotalBorrows_ProtocolUnderwaterAsset);
2343         if (rateCalculationResultCode != 0) {
2344             return failOpaque(FailureInfo.LIQUIDATE_NEW_BORROW_RATE_CALCULATION_FAILED_BORROWED_ASSET, rateCalculationResultCode);
2345         }
2346 
2347         // Now we look at collateral. We calculated target user's accumulated supply balance and the supply index above.
2348         // Now we need to calculate the borrow index.
2349         // We don't need to calculate new rates for the collateral asset because we have not changed utilization:
2350         //  - accumulating interest on the target user's collateral does not change cash or borrows
2351         //  - transferring seized amount of collateral internally from the target user to the liquidator does not change cash or borrows.
2352         (err, localResults.newBorrowIndex_CollateralAsset) = calculateInterestIndex(collateralMarket.borrowIndex, collateralMarket.borrowRateMantissa, collateralMarket.blockNumber, getBlockNumber());
2353         if (err != Error.NO_ERROR) {
2354             return fail(err, FailureInfo.LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET);
2355         }
2356 
2357         // We checkpoint the target user's assetCollateral supply balance, supplyCurrent - seizeSupplyAmount_TargetCollateralAsset at the updated index
2358         (err, localResults.updatedSupplyBalance_TargetCollateralAsset) = sub(localResults.currentSupplyBalance_TargetCollateralAsset, localResults.seizeSupplyAmount_TargetCollateralAsset);
2359         // The sub won't underflow because because seizeSupplyAmount_TargetCollateralAsset <= target user's collateral balance
2360         // maxCloseableBorrowAmount_TargetUnderwaterAsset is limited by the discounted borrow denominated collateral. That limits closeBorrowAmount_TargetUnderwaterAsset
2361         // which in turn limits seizeSupplyAmount_TargetCollateralAsset.
2362         assert (err == Error.NO_ERROR);
2363 
2364         // We checkpoint the liquidating user's assetCollateral supply balance, supplyCurrent + seizeSupplyAmount_TargetCollateralAsset at the updated index
2365         (err, localResults.updatedSupplyBalance_LiquidatorCollateralAsset) = add(localResults.currentSupplyBalance_LiquidatorCollateralAsset, localResults.seizeSupplyAmount_TargetCollateralAsset);
2366         // We can't overflow here because if this would overflow, then we would have already overflowed above and failed
2367         // with LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET
2368         assert (err == Error.NO_ERROR);
2369 
2370         /////////////////////////
2371         // EFFECTS & INTERACTIONS
2372         // (No safe failures beyond this point)
2373 
2374         // We ERC-20 transfer the asset into the protocol (note: pre-conditions already checked above)
2375         err = doTransferIn(assetBorrow, localResults.liquidator, localResults.closeBorrowAmount_TargetUnderwaterAsset);
2376         if (err != Error.NO_ERROR) {
2377             // This is safe since it's our first interaction and it didn't do anything if it failed
2378             return fail(err, FailureInfo.LIQUIDATE_TRANSFER_IN_FAILED);
2379         }
2380 
2381         // Save borrow market updates
2382         borrowMarket.blockNumber = getBlockNumber();
2383         borrowMarket.totalBorrows = localResults.newTotalBorrows_ProtocolUnderwaterAsset;
2384         // borrowMarket.totalSupply does not need to be updated
2385         borrowMarket.supplyRateMantissa = localResults.newSupplyRateMantissa_ProtocolUnderwaterAsset;
2386         borrowMarket.supplyIndex = localResults.newSupplyIndex_UnderwaterAsset;
2387         borrowMarket.borrowRateMantissa = localResults.newBorrowRateMantissa_ProtocolUnderwaterAsset;
2388         borrowMarket.borrowIndex = localResults.newBorrowIndex_UnderwaterAsset;
2389 
2390         // Save collateral market updates
2391         // We didn't calculate new rates for collateralMarket (because neither cash nor borrows changed), just new indexes and total supply.
2392         collateralMarket.blockNumber = getBlockNumber();
2393         collateralMarket.totalSupply = localResults.newTotalSupply_ProtocolCollateralAsset;
2394         collateralMarket.supplyIndex = localResults.newSupplyIndex_CollateralAsset;
2395         collateralMarket.borrowIndex = localResults.newBorrowIndex_CollateralAsset;
2396 
2397         // Save user updates
2398 
2399         localResults.startingBorrowBalance_TargetUnderwaterAsset = borrowBalance_TargeUnderwaterAsset.principal; // save for use in event
2400         borrowBalance_TargeUnderwaterAsset.principal = localResults.updatedBorrowBalance_TargetUnderwaterAsset;
2401         borrowBalance_TargeUnderwaterAsset.interestIndex = localResults.newBorrowIndex_UnderwaterAsset;
2402 
2403         localResults.startingSupplyBalance_TargetCollateralAsset = supplyBalance_TargetCollateralAsset.principal; // save for use in event
2404         supplyBalance_TargetCollateralAsset.principal = localResults.updatedSupplyBalance_TargetCollateralAsset;
2405         supplyBalance_TargetCollateralAsset.interestIndex = localResults.newSupplyIndex_CollateralAsset;
2406 
2407         localResults.startingSupplyBalance_LiquidatorCollateralAsset = supplyBalance_LiquidatorCollateralAsset.principal; // save for use in event
2408         supplyBalance_LiquidatorCollateralAsset.principal = localResults.updatedSupplyBalance_LiquidatorCollateralAsset;
2409         supplyBalance_LiquidatorCollateralAsset.interestIndex = localResults.newSupplyIndex_CollateralAsset;
2410 
2411         emitLiquidationEvent(localResults);
2412 
2413         return uint(Error.NO_ERROR); // success
2414     }
2415 
2416     /**
2417       * @dev this function exists to avoid error `CompilerError: Stack too deep, try removing local variables.` in `liquidateBorrow`
2418       */
2419     function emitLiquidationEvent(LiquidateLocalVars memory localResults) internal {
2420         // event BorrowLiquidated(address targetAccount, address assetBorrow, uint borrowBalanceBefore, uint borrowBalanceAccumulated, uint amountRepaid, uint borrowBalanceAfter,
2421         // address liquidator, address assetCollateral, uint collateralBalanceBefore, uint collateralBalanceAccumulated, uint amountSeized, uint collateralBalanceAfter);
2422         emit BorrowLiquidated(localResults.targetAccount,
2423             localResults.assetBorrow,
2424             localResults.startingBorrowBalance_TargetUnderwaterAsset,
2425             localResults.currentBorrowBalance_TargetUnderwaterAsset,
2426             localResults.closeBorrowAmount_TargetUnderwaterAsset,
2427             localResults.updatedBorrowBalance_TargetUnderwaterAsset,
2428             localResults.liquidator,
2429             localResults.assetCollateral,
2430             localResults.startingSupplyBalance_TargetCollateralAsset,
2431             localResults.currentSupplyBalance_TargetCollateralAsset,
2432             localResults.seizeSupplyAmount_TargetCollateralAsset,
2433             localResults.updatedSupplyBalance_TargetCollateralAsset);
2434     }
2435 
2436     /**
2437       * @dev This should ONLY be called if market is supported. It returns shortfall / [Oracle price for the borrow * (collateralRatio - liquidationDiscount - 1)]
2438       *      If the market isn't supported, we support liquidation of asset regardless of shortfall because we want borrows of the unsupported asset to be closed.
2439       *      Note that if collateralRatio = liquidationDiscount + 1, then the denominator will be zero and the function will fail with DIVISION_BY_ZERO.
2440       **/
2441     function calculateDiscountedRepayToEvenAmount(address targetAccount, Exp memory underwaterAssetPrice) internal view returns (Error, uint) {
2442         Error err;
2443         Exp memory _accountLiquidity; // unused return value from calculateAccountLiquidity
2444         Exp memory accountShortfall_TargetUser;
2445         Exp memory collateralRatioMinusLiquidationDiscount; // collateralRatio - liquidationDiscount
2446         Exp memory discountedCollateralRatioMinusOne; // collateralRatioMinusLiquidationDiscount - 1, aka collateralRatio - liquidationDiscount - 1
2447         Exp memory discountedPrice_UnderwaterAsset;
2448         Exp memory rawResult;
2449 
2450         // we calculate the target user's shortfall, denominated in Ether, that the user is below the collateral ratio
2451         (err, _accountLiquidity, accountShortfall_TargetUser) = calculateAccountLiquidity(targetAccount);
2452         if (err != Error.NO_ERROR) {
2453             return (err, 0);
2454         }
2455 
2456         (err, collateralRatioMinusLiquidationDiscount) = subExp(collateralRatio, liquidationDiscount);
2457         if (err != Error.NO_ERROR) {
2458             return (err, 0);
2459         }
2460 
2461         (err, discountedCollateralRatioMinusOne) = subExp(collateralRatioMinusLiquidationDiscount, Exp({mantissa: mantissaOne}));
2462         if (err != Error.NO_ERROR) {
2463             return (err, 0);
2464         }
2465 
2466         (err, discountedPrice_UnderwaterAsset) = mulExp(underwaterAssetPrice, discountedCollateralRatioMinusOne);
2467         // calculateAccountLiquidity multiplies underwaterAssetPrice by collateralRatio
2468         // discountedCollateralRatioMinusOne < collateralRatio
2469         // so if underwaterAssetPrice * collateralRatio did not overflow then
2470         // underwaterAssetPrice * discountedCollateralRatioMinusOne can't overflow either
2471         assert(err == Error.NO_ERROR);
2472 
2473         (err, rawResult) = divExp(accountShortfall_TargetUser, discountedPrice_UnderwaterAsset);
2474         // It's theoretically possible an asset could have such a low price that it truncates to zero when discounted.
2475         if (err != Error.NO_ERROR) {
2476             return (err, 0);
2477         }
2478 
2479         return (Error.NO_ERROR, truncate(rawResult));
2480     }
2481 
2482     /**
2483       * @dev discountedBorrowDenominatedCollateral = [supplyCurrent / (1 + liquidationDiscount)] * (Oracle price for the collateral / Oracle price for the borrow)
2484       */
2485     function calculateDiscountedBorrowDenominatedCollateral(Exp memory underwaterAssetPrice, Exp memory collateralPrice, uint supplyCurrent_TargetCollateralAsset) view internal returns (Error, uint) {
2486         // To avoid rounding issues, we re-order and group the operations so we do 1 division and only at the end
2487         // [supplyCurrent * (Oracle price for the collateral)] / [ (1 + liquidationDiscount) * (Oracle price for the borrow) ]
2488         Error err;
2489         Exp memory onePlusLiquidationDiscount; // (1 + liquidationDiscount)
2490         Exp memory supplyCurrentTimesOracleCollateral; // supplyCurrent * Oracle price for the collateral
2491         Exp memory onePlusLiquidationDiscountTimesOracleBorrow; // (1 + liquidationDiscount) * Oracle price for the borrow
2492         Exp memory rawResult;
2493 
2494         (err, onePlusLiquidationDiscount) = addExp(Exp({mantissa: mantissaOne}), liquidationDiscount);
2495         if (err != Error.NO_ERROR) {
2496             return (err, 0);
2497         }
2498 
2499         (err, supplyCurrentTimesOracleCollateral) = mulScalar(collateralPrice, supplyCurrent_TargetCollateralAsset);
2500         if (err != Error.NO_ERROR) {
2501             return (err, 0);
2502         }
2503 
2504         (err, onePlusLiquidationDiscountTimesOracleBorrow) = mulExp(onePlusLiquidationDiscount, underwaterAssetPrice);
2505         if (err != Error.NO_ERROR) {
2506             return (err, 0);
2507         }
2508 
2509         (err, rawResult) = divExp(supplyCurrentTimesOracleCollateral, onePlusLiquidationDiscountTimesOracleBorrow);
2510         if (err != Error.NO_ERROR) {
2511             return (err, 0);
2512         }
2513 
2514         return (Error.NO_ERROR, truncate(rawResult));
2515     }
2516 
2517 
2518     /**
2519       * @dev returns closeBorrowAmount_TargetUnderwaterAsset * (1+liquidationDiscount) * priceBorrow/priceCollateral
2520       **/
2521     function calculateAmountSeize(Exp memory underwaterAssetPrice, Exp memory collateralPrice, uint closeBorrowAmount_TargetUnderwaterAsset) internal view returns (Error, uint) {
2522         // To avoid rounding issues, we re-order and group the operations to move the division to the end, rather than just taking the ratio of the 2 prices:
2523         // underwaterAssetPrice * (1+liquidationDiscount) *closeBorrowAmount_TargetUnderwaterAsset) / collateralPrice
2524 
2525         // re-used for all intermediate errors
2526         Error err;
2527 
2528         // (1+liquidationDiscount)
2529         Exp memory liquidationMultiplier;
2530 
2531         // assetPrice-of-underwaterAsset * (1+liquidationDiscount)
2532         Exp memory priceUnderwaterAssetTimesLiquidationMultiplier;
2533 
2534         // priceUnderwaterAssetTimesLiquidationMultiplier * closeBorrowAmount_TargetUnderwaterAsset
2535         // or, expanded:
2536         // underwaterAssetPrice * (1+liquidationDiscount) * closeBorrowAmount_TargetUnderwaterAsset
2537         Exp memory finalNumerator;
2538 
2539         // finalNumerator / priceCollateral
2540         Exp memory rawResult;
2541 
2542         (err, liquidationMultiplier) = addExp(Exp({mantissa: mantissaOne}), liquidationDiscount);
2543         // liquidation discount will be enforced < 1, so 1 + liquidationDiscount can't overflow.
2544         assert(err == Error.NO_ERROR);
2545 
2546         (err, priceUnderwaterAssetTimesLiquidationMultiplier) = mulExp(underwaterAssetPrice, liquidationMultiplier);
2547         if (err != Error.NO_ERROR) {
2548             return (err, 0);
2549         }
2550 
2551         (err, finalNumerator) = mulScalar(priceUnderwaterAssetTimesLiquidationMultiplier, closeBorrowAmount_TargetUnderwaterAsset);
2552         if (err != Error.NO_ERROR) {
2553             return (err, 0);
2554         }
2555 
2556         (err, rawResult) = divExp(finalNumerator, collateralPrice);
2557         if (err != Error.NO_ERROR) {
2558             return (err, 0);
2559         }
2560 
2561         return (Error.NO_ERROR, truncate(rawResult));
2562     }
2563 
2564 
2565     /**
2566       * @notice Users borrow assets from the protocol to their own address
2567       * @param asset The market asset to borrow
2568       * @param amount The amount to borrow
2569       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2570       */
2571     function borrow(address asset, uint amount) public returns (uint) {
2572         if (paused) {
2573             return fail(Error.CONTRACT_PAUSED, FailureInfo.BORROW_CONTRACT_PAUSED);
2574         }
2575         BorrowLocalVars memory localResults;
2576         Market storage market = markets[asset];
2577         Balance storage borrowBalance = borrowBalances[msg.sender][asset];
2578 
2579         Error err;
2580         uint rateCalculationResultCode;
2581 
2582         // Fail if market not supported
2583         if (!market.isSupported) {
2584             return fail(Error.MARKET_NOT_SUPPORTED, FailureInfo.BORROW_MARKET_NOT_SUPPORTED);
2585         }
2586 
2587         // We calculate the newBorrowIndex, user's borrowCurrent and borrowUpdated for the asset
2588         (err, localResults.newBorrowIndex) = calculateInterestIndex(market.borrowIndex, market.borrowRateMantissa, market.blockNumber, getBlockNumber());
2589         if (err != Error.NO_ERROR) {
2590             return fail(err, FailureInfo.BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED);
2591         }
2592 
2593         (err, localResults.userBorrowCurrent) = calculateBalance(borrowBalance.principal, borrowBalance.interestIndex, localResults.newBorrowIndex);
2594         if (err != Error.NO_ERROR) {
2595             return fail(err, FailureInfo.BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED); // failing here not where desired (which is below)
2596         }
2597 
2598         // Calculate origination fee.
2599         (err, localResults.borrowAmountWithFee) = calculateBorrowAmountWithFee(amount);
2600         if (err != Error.NO_ERROR) {
2601             return fail(err, FailureInfo.BORROW_ORIGINATION_FEE_CALCULATION_FAILED);
2602         }
2603 
2604         // Add the `borrowAmountWithFee` to the `userBorrowCurrent` to get `userBorrowUpdated`
2605         (err, localResults.userBorrowUpdated) = add(localResults.userBorrowCurrent, localResults.borrowAmountWithFee);
2606         if (err != Error.NO_ERROR) {
2607             return fail(err, FailureInfo.BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED); // now failing here
2608         }
2609 
2610         // We calculate the protocol's totalBorrow by subtracting the user's prior checkpointed balance, adding user's updated borrow with fee
2611         (err, localResults.newTotalBorrows) = addThenSub(market.totalBorrows, localResults.userBorrowUpdated, borrowBalance.principal);
2612         if (err != Error.NO_ERROR) {
2613             return fail(err, FailureInfo.BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED); // want this one
2614         }
2615 
2616         // Check customer liquidity
2617         (err, localResults.accountLiquidity, localResults.accountShortfall) = calculateAccountLiquidity(msg.sender);
2618         if (err != Error.NO_ERROR) {
2619             return fail(err, FailureInfo.BORROW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED);
2620         }
2621 
2622         // Fail if customer already has a shortfall
2623         if (!isZeroExp(localResults.accountShortfall)) {
2624             return fail(Error.INSUFFICIENT_LIQUIDITY, FailureInfo.BORROW_ACCOUNT_SHORTFALL_PRESENT);
2625         }
2626 
2627         // Would the customer have a shortfall after this borrow (including origination fee)?
2628         // We calculate the eth-equivalent value of (borrow amount + fee) of asset and fail if it exceeds accountLiquidity.
2629         // This implements: `[(collateralRatio*oraclea*borrowAmount)*(1+borrowFee)] > accountLiquidity`
2630         (err, localResults.ethValueOfBorrowAmountWithFee) = getPriceForAssetAmountMulCollatRatio(asset, localResults.borrowAmountWithFee);
2631         if (err != Error.NO_ERROR) {
2632             return fail(err, FailureInfo.BORROW_AMOUNT_VALUE_CALCULATION_FAILED);
2633         }
2634         if (lessThanExp(localResults.accountLiquidity, localResults.ethValueOfBorrowAmountWithFee)) {
2635             return fail(Error.INSUFFICIENT_LIQUIDITY, FailureInfo.BORROW_AMOUNT_LIQUIDITY_SHORTFALL);
2636         }
2637 
2638         // Fail gracefully if protocol has insufficient cash
2639         localResults.currentCash = getCash(asset);
2640         // We need to calculate what the updated cash will be after we transfer out to the user
2641         (err, localResults.updatedCash) = sub(localResults.currentCash, amount);
2642         if (err != Error.NO_ERROR) {
2643             // Note: we ignore error here and call this token insufficient cash
2644             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED);
2645         }
2646 
2647         // The utilization rate has changed! We calculate a new supply index and borrow index for the asset, and save it.
2648 
2649         // We calculate the newSupplyIndex, but we have newBorrowIndex already
2650         (err, localResults.newSupplyIndex) = calculateInterestIndex(market.supplyIndex, market.supplyRateMantissa, market.blockNumber, getBlockNumber());
2651         if (err != Error.NO_ERROR) {
2652             return fail(err, FailureInfo.BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED);
2653         }
2654 
2655         (rateCalculationResultCode, localResults.newSupplyRateMantissa) = market.interestRateModel.getSupplyRate(asset, localResults.updatedCash, localResults.newTotalBorrows);
2656         if (rateCalculationResultCode != 0) {
2657             return failOpaque(FailureInfo.BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED, rateCalculationResultCode);
2658         }
2659 
2660         (rateCalculationResultCode, localResults.newBorrowRateMantissa) = market.interestRateModel.getBorrowRate(asset, localResults.updatedCash, localResults.newTotalBorrows);
2661         if (rateCalculationResultCode != 0) {
2662             return failOpaque(FailureInfo.BORROW_NEW_BORROW_RATE_CALCULATION_FAILED, rateCalculationResultCode);
2663         }
2664 
2665         /////////////////////////
2666         // EFFECTS & INTERACTIONS
2667         // (No safe failures beyond this point)
2668 
2669         // We ERC-20 transfer the asset into the protocol (note: pre-conditions already checked above)
2670         err = doTransferOut(asset, msg.sender, amount);
2671         if (err != Error.NO_ERROR) {
2672             // This is safe since it's our first interaction and it didn't do anything if it failed
2673             return fail(err, FailureInfo.BORROW_TRANSFER_OUT_FAILED);
2674         }
2675 
2676         // Save market updates
2677         market.blockNumber = getBlockNumber();
2678         market.totalBorrows =  localResults.newTotalBorrows;
2679         market.supplyRateMantissa = localResults.newSupplyRateMantissa;
2680         market.supplyIndex = localResults.newSupplyIndex;
2681         market.borrowRateMantissa = localResults.newBorrowRateMantissa;
2682         market.borrowIndex = localResults.newBorrowIndex;
2683 
2684         // Save user updates
2685         localResults.startingBalance = borrowBalance.principal; // save for use in `BorrowTaken` event
2686         borrowBalance.principal = localResults.userBorrowUpdated;
2687         borrowBalance.interestIndex = localResults.newBorrowIndex;
2688 
2689         emit BorrowTaken(msg.sender, asset, amount, localResults.startingBalance, localResults.borrowAmountWithFee, localResults.userBorrowUpdated);
2690 
2691         return uint(Error.NO_ERROR); // success
2692     }
2693 }
2694 contract LiquidationChecker {
2695     MoneyMarket public moneyMarket;
2696     address public liquidator;
2697     bool public allowLiquidation;
2698 
2699     constructor(address moneyMarket_, address liquidator_) public {
2700         moneyMarket = MoneyMarket(moneyMarket_);
2701         liquidator = liquidator_;
2702         allowLiquidation = false;
2703     }
2704 
2705     function isAllowed(address asset, uint newCash) internal returns(bool) {
2706         return allowLiquidation || !isLiquidate(asset, newCash);
2707     }
2708 
2709     function isLiquidate(address asset, uint newCash) internal returns(bool) {
2710         return cashIsUp(asset, newCash) && oracleTouched();
2711     }
2712 
2713     function cashIsUp(address asset, uint newCash) internal view returns(bool) {
2714         uint oldCash = EIP20Interface(asset).balanceOf(moneyMarket);
2715 
2716         return newCash >= oldCash;
2717     }
2718 
2719     function oracleTouched() internal returns(bool) {
2720         PriceOracleProxy oracle = PriceOracleProxy(moneyMarket.oracle());
2721 
2722         bool sameOrigin = oracle.mostRecentCaller() == tx.origin;
2723         bool sameBlock = oracle.mostRecentBlock() == block.number;
2724 
2725         return sameOrigin && sameBlock;
2726     }
2727 
2728     function setAllowLiquidation(bool allowLiquidation_) public {
2729         require(msg.sender == liquidator, "LIQUIDATION_CHECKER_INVALID_LIQUIDATOR");
2730 
2731         allowLiquidation = allowLiquidation_;
2732     }
2733 }
2734 contract Liquidator is ErrorReporter, SafeToken {
2735 
2736     MoneyMarket public moneyMarket;
2737 
2738     constructor(address moneyMarket_) public {
2739         moneyMarket = MoneyMarket(moneyMarket_);
2740     }
2741 
2742     event BorrowLiquidated(address targetAccount,
2743         address assetBorrow,
2744         uint borrowBalanceBefore,
2745         uint borrowBalanceAccumulated,
2746         uint amountRepaid,
2747         uint borrowBalanceAfter,
2748         address liquidator,
2749         address assetCollateral,
2750         uint collateralBalanceBefore,
2751         uint collateralBalanceAccumulated,
2752         uint amountSeized,
2753         uint collateralBalanceAfter);
2754 
2755     function liquidateBorrow(address targetAccount, address assetBorrow, address assetCollateral, uint requestedAmountClose) public returns (uint) {
2756         require(targetAccount != address(this), "FAILED_LIQUIDATE_LIQUIDATOR");
2757         require(targetAccount != msg.sender, "FAILED_LIQUIDATE_SELF");
2758         require(msg.sender != address(this), "FAILED_LIQUIDATE_RECURSIVE");
2759         require(assetBorrow != assetCollateral, "FAILED_LIQUIDATE_IN_KIND");
2760 
2761         InterestRateModel interestRateModel;
2762         (,,interestRateModel,,,,,,) = moneyMarket.markets(assetBorrow);
2763 
2764         require(interestRateModel != address(0), "FAILED_LIQUIDATE_NO_INTEREST_RATE_MODEL");
2765         require(checkTransferIn(assetBorrow, msg.sender, requestedAmountClose) == Error.NO_ERROR, "FAILED_LIQUIDATE_TRANSFER_IN_INVALID");
2766 
2767         require(doTransferIn(assetBorrow, msg.sender, requestedAmountClose) == Error.NO_ERROR, "FAILED_LIQUIDATE_TRANSFER_IN_FAILED");
2768 
2769         tokenAllowAll(assetBorrow, moneyMarket);
2770 
2771         LiquidationChecker(interestRateModel).setAllowLiquidation(true);
2772 
2773         uint result = moneyMarket.liquidateBorrow(targetAccount, assetBorrow, assetCollateral, requestedAmountClose);
2774 
2775         require(moneyMarket.withdraw(assetCollateral, uint(-1)) == uint(Error.NO_ERROR), "FAILED_LIQUIDATE_WITHDRAW_FAILED");
2776 
2777         LiquidationChecker(interestRateModel).setAllowLiquidation(false);
2778 
2779         // Ensure there's no remaining balances here
2780         require(moneyMarket.getSupplyBalance(address(this), assetCollateral) == 0, "FAILED_LIQUIDATE_REMAINING_SUPPLY_COLLATERAL"); // just to be sure
2781         require(moneyMarket.getSupplyBalance(address(this), assetBorrow) == 0, "FAILED_LIQUIDATE_REMAINING_SUPPLY_BORROW"); // just to be sure
2782         require(moneyMarket.getBorrowBalance(address(this), assetCollateral) == 0, "FAILED_LIQUIDATE_REMAINING_BORROW_COLLATERAL"); // just to be sure
2783         require(moneyMarket.getBorrowBalance(address(this), assetBorrow) == 0, "FAILED_LIQUIDATE_REMAINING_BORROW_BORROW"); // just to be sure
2784 
2785         // Transfer out everything remaining
2786         tokenTransferAll(assetCollateral, msg.sender);
2787         tokenTransferAll(assetBorrow, msg.sender);
2788 
2789         return uint(result);
2790     }
2791 
2792     function tokenAllowAll(address asset, address allowee) internal {
2793         EIP20Interface token = EIP20Interface(asset);
2794 
2795         require(token.approve(allowee, uint(-1)), "FAILED_LIQUIDATE_ASSET_ALLOWANCE_FAILED");
2796     }
2797 
2798     function tokenTransferAll(address asset, address recipient) internal {
2799         uint balance = getBalanceOf(asset, address(this));
2800 
2801         require(doTransferOut(asset, recipient, balance) == Error.NO_ERROR, "FAILED_LIQUIDATE_TRANSFER_OUT_FAILED");
2802     }
2803 }