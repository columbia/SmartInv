1 pragma solidity ^0.4.24;
2 
3 contract EIP20Interface {
4     /* This is a slight change to the ERC20 base standard.
5     function totalSupply() constant returns (uint256 supply);
6     is replaced with:
7     uint256 public totalSupply;
8     This automatically creates a getter function for the totalSupply.
9     This is moved to the base contract since public getter functions are not
10     currently recognised as an implementation of the matching abstract
11     function by the compiler.
12     */
13     /// total amount of tokens
14     uint256 public totalSupply;
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) public view returns (uint256 balance);
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) public returns (bool success);
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
32 
33     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of tokens to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) public returns (bool success);
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
43 
44     // solhint-disable-next-line no-simple-event-func-name
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 }
48 
49 contract EIP20NonStandardInterface {
50     /* This is a slight change to the ERC20 base standard.
51     function totalSupply() constant returns (uint256 supply);
52     is replaced with:
53     uint256 public totalSupply;
54     This automatically creates a getter function for the totalSupply.
55     This is moved to the base contract since public getter functions are not
56     currently recognised as an implementation of the matching abstract
57     function by the compiler.
58     */
59     /// total amount of tokens
60     uint256 public totalSupply;
61 
62     /// @param _owner The address from which the balance will be retrieved
63     /// @return The balance
64     function balanceOf(address _owner) public view returns (uint256 balance);
65 
66     ///
67     /// !!!!!!!!!!!!!!
68     /// !!! NOTICE !!! `transfer` does not return a value, in violation of the ERC-20 specification
69     /// !!!!!!!!!!!!!!
70     ///
71 
72     /// @notice send `_value` token to `_to` from `msg.sender`
73     /// @param _to The address of the recipient
74     /// @param _value The amount of token to be transferred
75     /// @return Whether the transfer was successful or not
76     function transfer(address _to, uint256 _value) public;
77 
78     ///
79     /// !!!!!!!!!!!!!!
80     /// !!! NOTICE !!! `transferFrom` does not return a value, in violation of the ERC-20 specification
81     /// !!!!!!!!!!!!!!
82     ///
83 
84     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
85     /// @param _from The address of the sender
86     /// @param _to The address of the recipient
87     /// @param _value The amount of token to be transferred
88     /// @return Whether the transfer was successful or not
89     function transferFrom(address _from, address _to, uint256 _value) public;
90 
91     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
92     /// @param _spender The address of the account able to transfer the tokens
93     /// @param _value The amount of tokens to be approved for transfer
94     /// @return Whether the approval was successful or not
95     // function approve(address _spender, uint256 _value) public returns (bool success);
96     function approve(address _spender, uint256 _value) public;
97 
98     /// @param _owner The address of the account owning tokens
99     /// @param _spender The address of the account able to transfer the tokens
100     /// @return Amount of remaining tokens allowed to spent
101     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
102 
103     // solhint-disable-next-line no-simple-event-func-name
104     event Transfer(address indexed _from, address indexed _to, uint256 _value);
105     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
106 }
107 
108 contract ErrorReporter {
109 
110     /**
111       * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
112       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
113       **/
114     event Failure(uint error, uint info, uint detail);
115 
116     enum Error {
117         NO_ERROR,
118         OPAQUE_ERROR, // To be used when reporting errors from upgradeable contracts; the opaque code should be given as `detail` in the `Failure` event
119         UNAUTHORIZED,
120         INTEGER_OVERFLOW,
121         INTEGER_UNDERFLOW,
122         DIVISION_BY_ZERO,
123         BAD_INPUT,
124         TOKEN_INSUFFICIENT_ALLOWANCE,
125         TOKEN_INSUFFICIENT_BALANCE,
126         TOKEN_TRANSFER_FAILED,
127         MARKET_NOT_SUPPORTED,
128         SUPPLY_RATE_CALCULATION_FAILED,
129         BORROW_RATE_CALCULATION_FAILED,
130         TOKEN_INSUFFICIENT_CASH,
131         TOKEN_TRANSFER_OUT_FAILED,
132         INSUFFICIENT_LIQUIDITY,
133         INSUFFICIENT_BALANCE,
134         INVALID_COLLATERAL_RATIO,
135         MISSING_ASSET_PRICE,
136         EQUITY_INSUFFICIENT_BALANCE,
137         INVALID_CLOSE_AMOUNT_REQUESTED,
138         ASSET_NOT_PRICED,
139         INVALID_LIQUIDATION_DISCOUNT,
140         INVALID_COMBINED_RISK_PARAMETERS,
141         ZERO_ORACLE_ADDRESS,
142         CONTRACT_PAUSED
143     }
144 
145     /*
146      * Note: FailureInfo (but not Error) is kept in alphabetical order
147      *       This is because FailureInfo grows significantly faster, and
148      *       the order of Error has some meaning, while the order of FailureInfo
149      *       is entirely arbitrary.
150      */
151     enum FailureInfo {
152         ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
153         BORROW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED,
154         BORROW_ACCOUNT_SHORTFALL_PRESENT,
155         BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
156         BORROW_AMOUNT_LIQUIDITY_SHORTFALL,
157         BORROW_AMOUNT_VALUE_CALCULATION_FAILED,
158         BORROW_CONTRACT_PAUSED,
159         BORROW_MARKET_NOT_SUPPORTED,
160         BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED,
161         BORROW_NEW_BORROW_RATE_CALCULATION_FAILED,
162         BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
163         BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
164         BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
165         BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED,
166         BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED,
167         BORROW_ORIGINATION_FEE_CALCULATION_FAILED,
168         BORROW_TRANSFER_OUT_FAILED,
169         EQUITY_WITHDRAWAL_AMOUNT_VALIDATION,
170         EQUITY_WITHDRAWAL_CALCULATE_EQUITY,
171         EQUITY_WITHDRAWAL_MODEL_OWNER_CHECK,
172         EQUITY_WITHDRAWAL_TRANSFER_OUT_FAILED,
173         LIQUIDATE_ACCUMULATED_BORROW_BALANCE_CALCULATION_FAILED,
174         LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET,
175         LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET,
176         LIQUIDATE_AMOUNT_SEIZE_CALCULATION_FAILED,
177         LIQUIDATE_BORROW_DENOMINATED_COLLATERAL_CALCULATION_FAILED,
178         LIQUIDATE_CLOSE_AMOUNT_TOO_HIGH,
179         LIQUIDATE_CONTRACT_PAUSED,
180         LIQUIDATE_DISCOUNTED_REPAY_TO_EVEN_AMOUNT_CALCULATION_FAILED,
181         LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_BORROWED_ASSET,
182         LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET,
183         LIQUIDATE_NEW_BORROW_RATE_CALCULATION_FAILED_BORROWED_ASSET,
184         LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_BORROWED_ASSET,
185         LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET,
186         LIQUIDATE_NEW_SUPPLY_RATE_CALCULATION_FAILED_BORROWED_ASSET,
187         LIQUIDATE_NEW_TOTAL_BORROW_CALCULATION_FAILED_BORROWED_ASSET,
188         LIQUIDATE_NEW_TOTAL_CASH_CALCULATION_FAILED_BORROWED_ASSET,
189         LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET,
190         LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET,
191         LIQUIDATE_FETCH_ASSET_PRICE_FAILED,
192         LIQUIDATE_TRANSFER_IN_FAILED,
193         LIQUIDATE_TRANSFER_IN_NOT_POSSIBLE,
194         REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
195         REPAY_BORROW_CONTRACT_PAUSED,
196         REPAY_BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED,
197         REPAY_BORROW_NEW_BORROW_RATE_CALCULATION_FAILED,
198         REPAY_BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
199         REPAY_BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
200         REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
201         REPAY_BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED,
202         REPAY_BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED,
203         REPAY_BORROW_TRANSFER_IN_FAILED,
204         REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE,
205         SET_ASSET_PRICE_CHECK_ORACLE,
206         SET_MARKET_INTEREST_RATE_MODEL_OWNER_CHECK,
207         SET_ORACLE_OWNER_CHECK,
208         SET_ORIGINATION_FEE_OWNER_CHECK,
209         SET_PAUSED_OWNER_CHECK,
210         SET_PENDING_ADMIN_OWNER_CHECK,
211         SET_RISK_PARAMETERS_OWNER_CHECK,
212         SET_RISK_PARAMETERS_VALIDATION,
213         SUPPLY_ACCUMULATED_BALANCE_CALCULATION_FAILED,
214         SUPPLY_CONTRACT_PAUSED,
215         SUPPLY_MARKET_NOT_SUPPORTED,
216         SUPPLY_NEW_BORROW_INDEX_CALCULATION_FAILED,
217         SUPPLY_NEW_BORROW_RATE_CALCULATION_FAILED,
218         SUPPLY_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
219         SUPPLY_NEW_SUPPLY_RATE_CALCULATION_FAILED,
220         SUPPLY_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
221         SUPPLY_NEW_TOTAL_CASH_CALCULATION_FAILED,
222         SUPPLY_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
223         SUPPLY_TRANSFER_IN_FAILED,
224         SUPPLY_TRANSFER_IN_NOT_POSSIBLE,
225         SUPPORT_MARKET_FETCH_PRICE_FAILED,
226         SUPPORT_MARKET_OWNER_CHECK,
227         SUPPORT_MARKET_PRICE_CHECK,
228         SUSPEND_MARKET_OWNER_CHECK,
229         WITHDRAW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED,
230         WITHDRAW_ACCOUNT_SHORTFALL_PRESENT,
231         WITHDRAW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
232         WITHDRAW_AMOUNT_LIQUIDITY_SHORTFALL,
233         WITHDRAW_AMOUNT_VALUE_CALCULATION_FAILED,
234         WITHDRAW_CAPACITY_CALCULATION_FAILED,
235         WITHDRAW_CONTRACT_PAUSED,
236         WITHDRAW_NEW_BORROW_INDEX_CALCULATION_FAILED,
237         WITHDRAW_NEW_BORROW_RATE_CALCULATION_FAILED,
238         WITHDRAW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
239         WITHDRAW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
240         WITHDRAW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
241         WITHDRAW_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
242         WITHDRAW_TRANSFER_OUT_FAILED,
243         WITHDRAW_TRANSFER_OUT_NOT_POSSIBLE
244     }
245 
246 
247     /**
248       * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
249       */
250     function fail(Error err, FailureInfo info) internal returns (uint) {
251         emit Failure(uint(err), uint(info), 0);
252 
253         return uint(err);
254     }
255 
256 
257     /**
258       * @dev use this when reporting an opaque error from an upgradeable collaborator contract
259       */
260     function failOpaque(FailureInfo info, uint opaqueError) internal returns (uint) {
261         emit Failure(uint(Error.OPAQUE_ERROR), uint(info), opaqueError);
262 
263         return uint(Error.OPAQUE_ERROR);
264     }
265 
266 }
267 contract InterestRateModel {
268 
269     /**
270       * @notice Gets the current supply interest rate based on the given asset, total cash and total borrows
271       * @dev The return value should be scaled by 1e18, thus a return value of
272       *      `(true, 1000000000000)` implies an interest rate of 0.000001 or 0.0001% *per block*.
273       * @param asset The asset to get the interest rate of
274       * @param cash The total cash of the asset in the market
275       * @param borrows The total borrows of the asset in the market
276       * @return Success or failure and the supply interest rate per block scaled by 10e18
277       */
278     function getSupplyRate(address asset, uint cash, uint borrows) public view returns (uint, uint);
279 
280     /**
281       * @notice Gets the current borrow interest rate based on the given asset, total cash and total borrows
282       * @dev The return value should be scaled by 1e18, thus a return value of
283       *      `(true, 1000000000000)` implies an interest rate of 0.000001 or 0.0001% *per block*.
284       * @param asset The asset to get the interest rate of
285       * @param cash The total cash of the asset in the market
286       * @param borrows The total borrows of the asset in the market
287       * @return Success or failure and the borrow interest rate per block scaled by 10e18
288       */
289     function getBorrowRate(address asset, uint cash, uint borrows) public view returns (uint, uint);
290 }
291 contract PriceOracleInterface {
292 
293     /**
294       * @notice Gets the price of a given asset
295       * @dev fetches the price of a given asset
296       * @param asset Asset to get the price of
297       * @return the price scaled by 10**18, or zero if the price is not available
298       */
299     function assetPrices(address asset) public view returns (uint);
300 }
301 contract PriceOracleProxy {
302     address public mostRecentCaller;
303     uint public mostRecentBlock;
304     PriceOracleInterface public realPriceOracle;
305 
306     constructor(address realPriceOracle_) public {
307         realPriceOracle = PriceOracleInterface(realPriceOracle_);
308     }
309 
310     /**
311       * @notice Gets the price of a given asset
312       * @dev fetches the price of a given asset
313       * @param asset Asset to get the price of
314       * @return the price scaled by 10**18, or zero if the price is not available
315       */
316     function assetPrices(address asset) public returns (uint) {
317         mostRecentCaller = tx.origin;
318         mostRecentBlock = block.number;
319 
320         return realPriceOracle.assetPrices(asset);
321     }
322 }
323 contract SafeToken is ErrorReporter {
324 
325     /**
326       * @dev Checks whether or not there is sufficient allowance for this contract to move amount from `from` and
327       *      whether or not `from` has a balance of at least `amount`. Does NOT do a transfer.
328       */
329     function checkTransferIn(address asset, address from, uint amount) internal view returns (Error) {
330 
331         EIP20Interface token = EIP20Interface(asset);
332 
333         if (token.allowance(from, address(this)) < amount) {
334             return Error.TOKEN_INSUFFICIENT_ALLOWANCE;
335         }
336 
337         if (token.balanceOf(from) < amount) {
338             return Error.TOKEN_INSUFFICIENT_BALANCE;
339         }
340 
341         return Error.NO_ERROR;
342     }
343 
344     /**
345       * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and returns an explanatory
346       *      error code rather than reverting.  If caller has not called `checkTransferIn`, this may revert due to
347       *      insufficient balance or insufficient allowance. If caller has called `checkTransferIn` prior to this call,
348       *      and it returned Error.NO_ERROR, this should not revert in normal conditions.
349       *
350       *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
351       *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
352       */
353     function doTransferIn(address asset, address from, uint amount) internal returns (Error) {
354         EIP20NonStandardInterface token = EIP20NonStandardInterface(asset);
355 
356         bool result;
357 
358         token.transferFrom(from, address(this), amount);
359 
360         assembly {
361             switch returndatasize()
362                 case 0 {                      // This is a non-standard ERC-20
363                     result := not(0)          // set result to true
364                 }
365                 case 32 {                     // This is a complaint ERC-20
366                     returndatacopy(0, 0, 32)
367                     result := mload(0)        // Set `result = returndata` of external call
368                 }
369                 default {                     // This is an excessively non-compliant ERC-20, revert.
370                     revert(0, 0)
371                 }
372         }
373 
374         if (!result) {
375             return Error.TOKEN_TRANSFER_FAILED;
376         }
377 
378         return Error.NO_ERROR;
379     }
380 
381     /**
382       * @dev Checks balance of this contract in asset
383       */
384     function getCash(address asset) internal view returns (uint) {
385         EIP20Interface token = EIP20Interface(asset);
386 
387         return token.balanceOf(address(this));
388     }
389 
390     /**
391       * @dev Checks balance of `from` in `asset`
392       */
393     function getBalanceOf(address asset, address from) internal view returns (uint) {
394         EIP20Interface token = EIP20Interface(asset);
395 
396         return token.balanceOf(from);
397     }
398 
399     /**
400       * @dev Similar to EIP20 transfer, except it handles a False result from `transfer` and returns an explanatory
401       *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
402       *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
403       *      it is >= amount, this should not revert in normal conditions.
404       *
405       *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
406       *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
407       */
408     function doTransferOut(address asset, address to, uint amount) internal returns (Error) {
409         EIP20NonStandardInterface token = EIP20NonStandardInterface(asset);
410 
411         bool result;
412 
413         token.transfer(to, amount);
414 
415         assembly {
416             switch returndatasize()
417                 case 0 {                      // This is a non-standard ERC-20
418                     result := not(0)          // set result to true
419                 }
420                 case 32 {                     // This is a complaint ERC-20
421                     returndatacopy(0, 0, 32)
422                     result := mload(0)        // Set `result = returndata` of external call
423                 }
424                 default {                     // This is an excessively non-compliant ERC-20, revert.
425                     revert(0, 0)
426                 }
427         }
428 
429         if (!result) {
430             return Error.TOKEN_TRANSFER_OUT_FAILED;
431         }
432 
433         return Error.NO_ERROR;
434     }
435 
436     function doApprove(address asset, address to, uint amount) internal returns (Error) {
437         EIP20NonStandardInterface token = EIP20NonStandardInterface(asset);
438 
439         bool result;
440 
441         token.approve(to, amount);
442 
443         assembly {
444             switch returndatasize()
445                 case 0 {                      // This is a non-standard ERC-20
446                     result := not(0)          // set result to true
447                 }
448                 case 32 {                     // This is a complaint ERC-20
449                     returndatacopy(0, 0, 32)
450                     result := mload(0)        // Set `result = returndata` of external call
451                 }
452                 default {                     // This is an excessively non-compliant ERC-20, revert.
453                     revert(0, 0)
454                 }
455         }
456 
457         if (!result) {
458             return Error.TOKEN_TRANSFER_OUT_FAILED;
459         }
460 
461         return Error.NO_ERROR;
462     }
463 }
464 contract CarefulMath is ErrorReporter {
465 
466     /**
467     * @dev Multiplies two numbers, returns an error on overflow.
468     */
469     function mul(uint a, uint b) internal pure returns (Error, uint) {
470         if (a == 0) {
471             return (Error.NO_ERROR, 0);
472         }
473 
474         uint c = a * b;
475 
476         if (c / a != b) {
477             return (Error.INTEGER_OVERFLOW, 0);
478         } else {
479             return (Error.NO_ERROR, c);
480         }
481     }
482 
483     /**
484     * @dev Integer division of two numbers, truncating the quotient.
485     */
486     function div(uint a, uint b) internal pure returns (Error, uint) {
487         if (b == 0) {
488             return (Error.DIVISION_BY_ZERO, 0);
489         }
490 
491         return (Error.NO_ERROR, a / b);
492     }
493 
494     /**
495     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
496     */
497     function sub(uint a, uint b) internal pure returns (Error, uint) {
498         if (b <= a) {
499             return (Error.NO_ERROR, a - b);
500         } else {
501             return (Error.INTEGER_UNDERFLOW, 0);
502         }
503     }
504 
505     /**
506     * @dev Adds two numbers, returns an error on overflow.
507     */
508     function add(uint a, uint b) internal pure returns (Error, uint) {
509         uint c = a + b;
510 
511         if (c >= a) {
512             return (Error.NO_ERROR, c);
513         } else {
514             return (Error.INTEGER_OVERFLOW, 0);
515         }
516     }
517 
518     /**
519     * @dev add a and b and then subtract c
520     */
521     function addThenSub(uint a, uint b, uint c) internal pure returns (Error, uint) {
522         (Error err0, uint sum) = add(a, b);
523 
524         if (err0 != Error.NO_ERROR) {
525             return (err0, 0);
526         }
527 
528         return sub(sum, c);
529     }
530 }
531 contract Exponential is ErrorReporter, CarefulMath {
532 
533     // TODO: We may wish to put the result of 10**18 here instead of the expression.
534     // Per https://solidity.readthedocs.io/en/latest/contracts.html#constant-state-variables
535     // the optimizer MAY replace the expression 10**18 with its calculated value.
536     uint constant expScale = 10**18;
537 
538     // See TODO on expScale
539     uint constant halfExpScale = expScale/2;
540 
541     struct Exp {
542         uint mantissa;
543     }
544 
545     uint constant mantissaOne = 10**18;
546     uint constant mantissaOneTenth = 10**17;
547 
548     /**
549     * @dev Creates an exponential from numerator and denominator values.
550     *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
551     *            or if `denom` is zero.
552     */
553     function getExp(uint num, uint denom) pure internal returns (Error, Exp memory) {
554         (Error err0, uint scaledNumerator) = mul(num, expScale);
555         if (err0 != Error.NO_ERROR) {
556             return (err0, Exp({mantissa: 0}));
557         }
558 
559         (Error err1, uint rational) = div(scaledNumerator, denom);
560         if (err1 != Error.NO_ERROR) {
561             return (err1, Exp({mantissa: 0}));
562         }
563 
564         return (Error.NO_ERROR, Exp({mantissa: rational}));
565     }
566 
567     /**
568     * @dev Adds two exponentials, returning a new exponential.
569     */
570     function addExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
571         (Error error, uint result) = add(a.mantissa, b.mantissa);
572 
573         return (error, Exp({mantissa: result}));
574     }
575 
576     /**
577     * @dev Subtracts two exponentials, returning a new exponential.
578     */
579     function subExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
580         (Error error, uint result) = sub(a.mantissa, b.mantissa);
581 
582         return (error, Exp({mantissa: result}));
583     }
584 
585     /**
586     * @dev Multiply an Exp by a scalar, returning a new Exp.
587     */
588     function mulScalar(Exp memory a, uint scalar) pure internal returns (Error, Exp memory) {
589         (Error err0, uint scaledMantissa) = mul(a.mantissa, scalar);
590         if (err0 != Error.NO_ERROR) {
591             return (err0, Exp({mantissa: 0}));
592         }
593 
594         return (Error.NO_ERROR, Exp({mantissa: scaledMantissa}));
595     }
596 
597     /**
598     * @dev Divide an Exp by a scalar, returning a new Exp.
599     */
600     function divScalar(Exp memory a, uint scalar) pure internal returns (Error, Exp memory) {
601         (Error err0, uint descaledMantissa) = div(a.mantissa, scalar);
602         if (err0 != Error.NO_ERROR) {
603             return (err0, Exp({mantissa: 0}));
604         }
605 
606         return (Error.NO_ERROR, Exp({mantissa: descaledMantissa}));
607     }
608 
609     /**
610     * @dev Divide a scalar by an Exp, returning a new Exp.
611     */
612     function divScalarByExp(uint scalar, Exp divisor) pure internal returns (Error, Exp memory) {
613         /*
614             We are doing this as:
615             getExp(mul(expScale, scalar), divisor.mantissa)
616 
617             How it works:
618             Exp = a / b;
619             Scalar = s;
620             `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
621         */
622         (Error err0, uint numerator) = mul(expScale, scalar);
623         if (err0 != Error.NO_ERROR) {
624             return (err0, Exp({mantissa: 0}));
625         }
626         return getExp(numerator, divisor.mantissa);
627     }
628 
629     /**
630     * @dev Multiplies two exponentials, returning a new exponential.
631     */
632     function mulExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
633 
634         (Error err0, uint doubleScaledProduct) = mul(a.mantissa, b.mantissa);
635         if (err0 != Error.NO_ERROR) {
636             return (err0, Exp({mantissa: 0}));
637         }
638 
639         // We add half the scale before dividing so that we get rounding instead of truncation.
640         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
641         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
642         (Error err1, uint doubleScaledProductWithHalfScale) = add(halfExpScale, doubleScaledProduct);
643         if (err1 != Error.NO_ERROR) {
644             return (err1, Exp({mantissa: 0}));
645         }
646 
647         (Error err2, uint product) = div(doubleScaledProductWithHalfScale, expScale);
648         // The only error `div` can return is Error.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
649         assert(err2 == Error.NO_ERROR);
650 
651         return (Error.NO_ERROR, Exp({mantissa: product}));
652     }
653 
654     /**
655       * @dev Divides two exponentials, returning a new exponential.
656       *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
657       *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
658       */
659     function divExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
660         return getExp(a.mantissa, b.mantissa);
661     }
662 
663     /**
664       * @dev Truncates the given exp to a whole number value.
665       *      For example, truncate(Exp{mantissa: 15 * (10**18)}) = 15
666       */
667     function truncate(Exp memory exp) pure internal returns (uint) {
668         // Note: We are not using careful math here as we're performing a division that cannot fail
669         return exp.mantissa / 10**18;
670     }
671 
672     /**
673       * @dev Checks if first Exp is less than second Exp.
674       */
675     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
676         return left.mantissa < right.mantissa; //TODO: Add some simple tests and this in another PR yo.
677     }
678 
679     /**
680       * @dev Checks if left Exp <= right Exp.
681       */
682     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
683         return left.mantissa <= right.mantissa;
684     }
685 
686     /**
687       * @dev returns true if Exp is exactly zero
688       */
689     function isZeroExp(Exp memory value) pure internal returns (bool) {
690         return value.mantissa == 0;
691     }
692 }
693 
694 contract MoneyMarket is Exponential, SafeToken {
695 
696     uint constant initialInterestIndex = 10 ** 18;
697     uint constant defaultOriginationFee = 0; // default is zero bps
698 
699     uint constant minimumCollateralRatioMantissa = 11 * (10 ** 17); // 1.1
700     uint constant maximumLiquidationDiscountMantissa = (10 ** 17); // 0.1
701 
702     /**
703       * @notice `MoneyMarket` is the core Lendf.Me MoneyMarket contract
704       */
705     constructor() public {
706         admin = msg.sender;
707         collateralRatio = Exp({mantissa: 2 * mantissaOne});
708         originationFee = Exp({mantissa: defaultOriginationFee});
709         liquidationDiscount = Exp({mantissa: 0});
710         // oracle must be configured via _setOracle
711     }
712 
713     /**
714       * @notice Do not pay directly into MoneyMarket, please use `supply`.
715       */
716     function() payable public {
717         revert();
718     }
719 
720     /**
721       * @dev pending Administrator for this contract.
722       */
723     address public pendingAdmin;
724 
725     /**
726       * @dev Administrator for this contract. Initially set in constructor, but can
727       *      be changed by the admin itself.
728       */
729     address public admin;
730 
731     /**
732       * @dev Account allowed to set oracle prices for this contract. Initially set
733       *      in constructor, but can be changed by the admin.
734       */
735     address public oracle;
736 
737     /**
738       * @dev Container for customer balance information written to storage.
739       *
740       *      struct Balance {
741       *        principal = customer total balance with accrued interest after applying the customer's most recent balance-changing action
742       *        interestIndex = the total interestIndex as calculated after applying the customer's most recent balance-changing action
743       *      }
744       */
745     struct Balance {
746         uint principal;
747         uint interestIndex;
748     }
749 
750     /**
751       * @dev 2-level map: customerAddress -> assetAddress -> balance for supplies
752       */
753     mapping(address => mapping(address => Balance)) public supplyBalances;
754 
755 
756     /**
757       * @dev 2-level map: customerAddress -> assetAddress -> balance for borrows
758       */
759     mapping(address => mapping(address => Balance)) public borrowBalances;
760 
761 
762     /**
763       * @dev Container for per-asset balance sheet and interest rate information written to storage, intended to be stored in a map where the asset address is the key
764       *
765       *      struct Market {
766       *         isSupported = Whether this market is supported or not (not to be confused with the list of collateral assets)
767       *         blockNumber = when the other values in this struct were calculated
768       *         totalSupply = total amount of this asset supplied (in asset wei)
769       *         supplyRateMantissa = the per-block interest rate for supplies of asset as of blockNumber, scaled by 10e18
770       *         supplyIndex = the interest index for supplies of asset as of blockNumber; initialized in _supportMarket
771       *         totalBorrows = total amount of this asset borrowed (in asset wei)
772       *         borrowRateMantissa = the per-block interest rate for borrows of asset as of blockNumber, scaled by 10e18
773       *         borrowIndex = the interest index for borrows of asset as of blockNumber; initialized in _supportMarket
774       *     }
775       */
776     struct Market {
777         bool isSupported;
778         uint blockNumber;
779         InterestRateModel interestRateModel;
780 
781         uint totalSupply;
782         uint supplyRateMantissa;
783         uint supplyIndex;
784 
785         uint totalBorrows;
786         uint borrowRateMantissa;
787         uint borrowIndex;
788     }
789 
790     /**
791       * @dev map: assetAddress -> Market
792       */
793     mapping(address => Market) public markets;
794 
795     /**
796       * @dev list: collateralMarkets
797       */
798     address[] public collateralMarkets;
799 
800     /**
801       * @dev The collateral ratio that borrows must maintain (e.g. 2 implies 2:1). This
802       *      is initially set in the constructor, but can be changed by the admin.
803       */
804     Exp public collateralRatio;
805 
806     /**
807       * @dev originationFee for new borrows.
808       *
809       */
810     Exp public originationFee;
811 
812     /**
813       * @dev liquidationDiscount for collateral when liquidating borrows
814       *
815       */
816     Exp public liquidationDiscount;
817 
818     /**
819       * @dev flag for whether or not contract is paused
820       *
821       */
822     bool public paused;
823 
824 
825     /**
826       * @dev emitted when a supply is received
827       *      Note: newBalance - amount - startingBalance = interest accumulated since last change
828       */
829     event SupplyReceived(address account, address asset, uint amount, uint startingBalance, uint newBalance);
830 
831     /**
832       * @dev emitted when a supply is withdrawn
833       *      Note: startingBalance - amount - startingBalance = interest accumulated since last change
834       */
835     event SupplyWithdrawn(address account, address asset, uint amount, uint startingBalance, uint newBalance);
836 
837     /**
838       * @dev emitted when a new borrow is taken
839       *      Note: newBalance - borrowAmountWithFee - startingBalance = interest accumulated since last change
840       */
841     event BorrowTaken(address account, address asset, uint amount, uint startingBalance, uint borrowAmountWithFee, uint newBalance);
842 
843     /**
844       * @dev emitted when a borrow is repaid
845       *      Note: newBalance - amount - startingBalance = interest accumulated since last change
846       */
847     event BorrowRepaid(address account, address asset, uint amount, uint startingBalance, uint newBalance);
848 
849     /**
850       * @dev emitted when a borrow is liquidated
851       *      targetAccount = user whose borrow was liquidated
852       *      assetBorrow = asset borrowed
853       *      borrowBalanceBefore = borrowBalance as most recently stored before the liquidation
854       *      borrowBalanceAccumulated = borroBalanceBefore + accumulated interest as of immediately prior to the liquidation
855       *      amountRepaid = amount of borrow repaid
856       *      liquidator = account requesting the liquidation
857       *      assetCollateral = asset taken from targetUser and given to liquidator in exchange for liquidated loan
858       *      borrowBalanceAfter = new stored borrow balance (should equal borrowBalanceAccumulated - amountRepaid)
859       *      collateralBalanceBefore = collateral balance as most recently stored before the liquidation
860       *      collateralBalanceAccumulated = collateralBalanceBefore + accumulated interest as of immediately prior to the liquidation
861       *      amountSeized = amount of collateral seized by liquidator
862       *      collateralBalanceAfter = new stored collateral balance (should equal collateralBalanceAccumulated - amountSeized)
863       */
864     event BorrowLiquidated(address targetAccount,
865         address assetBorrow,
866         uint borrowBalanceBefore,
867         uint borrowBalanceAccumulated,
868         uint amountRepaid,
869         uint borrowBalanceAfter,
870         address liquidator,
871         address assetCollateral,
872         uint collateralBalanceBefore,
873         uint collateralBalanceAccumulated,
874         uint amountSeized,
875         uint collateralBalanceAfter);
876 
877     /**
878       * @dev emitted when pendingAdmin is changed
879       */
880     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
881 
882     /**
883       * @dev emitted when pendingAdmin is accepted, which means admin is updated
884       */
885     event NewAdmin(address oldAdmin, address newAdmin);
886 
887     /**
888       * @dev newOracle - address of new oracle
889       */
890     event NewOracle(address oldOracle, address newOracle);
891 
892     /**
893       * @dev emitted when new market is supported by admin
894       */
895     event SupportedMarket(address asset, address interestRateModel);
896 
897     /**
898       * @dev emitted when risk parameters are changed by admin
899       */
900     event NewRiskParameters(uint oldCollateralRatioMantissa, uint newCollateralRatioMantissa, uint oldLiquidationDiscountMantissa, uint newLiquidationDiscountMantissa);
901 
902     /**
903       * @dev emitted when origination fee is changed by admin
904       */
905     event NewOriginationFee(uint oldOriginationFeeMantissa, uint newOriginationFeeMantissa);
906 
907     /**
908       * @dev emitted when market has new interest rate model set
909       */
910     event SetMarketInterestRateModel(address asset, address interestRateModel);
911 
912     /**
913       * @dev emitted when admin withdraws equity
914       * Note that `equityAvailableBefore` indicates equity before `amount` was removed.
915       */
916     event EquityWithdrawn(address asset, uint equityAvailableBefore, uint amount, address owner);
917 
918     /**
919       * @dev emitted when a supported market is suspended by admin
920       */
921     event SuspendedMarket(address asset);
922 
923     /**
924       * @dev emitted when admin either pauses or resumes the contract; newState is the resulting state
925       */
926     event SetPaused(bool newState);
927 
928     /**
929       * @dev Simple function to calculate min between two numbers.
930       */
931     function min(uint a, uint b) pure internal returns (uint) {
932         if (a < b) {
933             return a;
934         } else {
935             return b;
936         }
937     }
938 
939     /**
940       * @dev Function to simply retrieve block number
941       *      This exists mainly for inheriting test contracts to stub this result.
942       */
943     function getBlockNumber() internal view returns (uint) {
944         return block.number;
945     }
946 
947     /**
948       * @dev Adds a given asset to the list of collateral markets. This operation is impossible to reverse.
949       *      Note: this will not add the asset if it already exists.
950       */
951     function addCollateralMarket(address asset) internal {
952         for (uint i = 0; i < collateralMarkets.length; i++) {
953             if (collateralMarkets[i] == asset) {
954                 return;
955             }
956         }
957 
958         collateralMarkets.push(asset);
959     }
960 
961     /**
962       * @notice return the number of elements in `collateralMarkets`
963       * @dev you can then externally call `collateralMarkets(uint)` to pull each market address
964       * @return the length of `collateralMarkets`
965       */
966     function getCollateralMarketsLength() public view returns (uint) {
967         return collateralMarkets.length;
968     }
969 
970     /**
971       * @dev Calculates a new supply index based on the prevailing interest rates applied over time
972       *      This is defined as `we multiply the most recent supply index by (1 + blocks times rate)`
973       */
974     function calculateInterestIndex(uint startingInterestIndex, uint interestRateMantissa, uint blockStart, uint blockEnd) pure internal returns (Error, uint) {
975 
976         // Get the block delta
977         (Error err0, uint blockDelta) = sub(blockEnd, blockStart);
978         if (err0 != Error.NO_ERROR) {
979             return (err0, 0);
980         }
981 
982         // Scale the interest rate times number of blocks
983         // Note: Doing Exp construction inline to avoid `CompilerError: Stack too deep, try removing local variables.`
984         (Error err1, Exp memory blocksTimesRate) = mulScalar(Exp({mantissa: interestRateMantissa}), blockDelta);
985         if (err1 != Error.NO_ERROR) {
986             return (err1, 0);
987         }
988 
989         // Add one to that result (which is really Exp({mantissa: expScale}) which equals 1.0)
990         (Error err2, Exp memory onePlusBlocksTimesRate) = addExp(blocksTimesRate, Exp({mantissa: mantissaOne}));
991         if (err2 != Error.NO_ERROR) {
992             return (err2, 0);
993         }
994 
995         // Then scale that accumulated interest by the old interest index to get the new interest index
996         (Error err3, Exp memory newInterestIndexExp) = mulScalar(onePlusBlocksTimesRate, startingInterestIndex);
997         if (err3 != Error.NO_ERROR) {
998             return (err3, 0);
999         }
1000 
1001         // Finally, truncate the interest index. This works only if interest index starts large enough
1002         // that is can be accurately represented with a whole number.
1003         return (Error.NO_ERROR, truncate(newInterestIndexExp));
1004     }
1005 
1006     /**
1007       * @dev Calculates a new balance based on a previous balance and a pair of interest indices
1008       *      This is defined as: `The user's last balance checkpoint is multiplied by the currentSupplyIndex
1009       *      value and divided by the user's checkpoint index value`
1010       *
1011       *      TODO: Is there a way to handle this that is less likely to overflow?
1012       */
1013     function calculateBalance(uint startingBalance, uint interestIndexStart, uint interestIndexEnd) pure internal returns (Error, uint) {
1014         if (startingBalance == 0) {
1015             // We are accumulating interest on any previous balance; if there's no previous balance, then there is
1016             // nothing to accumulate.
1017             return (Error.NO_ERROR, 0);
1018         }
1019         (Error err0, uint balanceTimesIndex) = mul(startingBalance, interestIndexEnd);
1020         if (err0 != Error.NO_ERROR) {
1021             return (err0, 0);
1022         }
1023 
1024         return div(balanceTimesIndex, interestIndexStart);
1025     }
1026 
1027     /**
1028       * @dev Gets the price for the amount specified of the given asset.
1029       */
1030     function getPriceForAssetAmount(address asset, uint assetAmount) internal view returns (Error, Exp memory)  {
1031         (Error err, Exp memory assetPrice) = fetchAssetPrice(asset);
1032         if (err != Error.NO_ERROR) {
1033             return (err, Exp({mantissa: 0}));
1034         }
1035 
1036         if (isZeroExp(assetPrice)) {
1037             return (Error.MISSING_ASSET_PRICE, Exp({mantissa: 0}));
1038         }
1039 
1040         return mulScalar(assetPrice, assetAmount); // assetAmountWei * oraclePrice = assetValueInEth
1041     }
1042 
1043     /**
1044       * @dev Gets the price for the amount specified of the given asset multiplied by the current
1045       *      collateral ratio (i.e., assetAmountWei * collateralRatio * oraclePrice = totalValueInEth).
1046       *      We will group this as `(oraclePrice * collateralRatio) * assetAmountWei`
1047       */
1048     function getPriceForAssetAmountMulCollatRatio(address asset, uint assetAmount) internal view returns (Error, Exp memory)  {
1049         Error err;
1050         Exp memory assetPrice;
1051         Exp memory scaledPrice;
1052         (err, assetPrice) = fetchAssetPrice(asset);
1053         if (err != Error.NO_ERROR) {
1054             return (err, Exp({mantissa: 0}));
1055         }
1056 
1057         if (isZeroExp(assetPrice)) {
1058             return (Error.MISSING_ASSET_PRICE, Exp({mantissa: 0}));
1059         }
1060 
1061         // Now, multiply the assetValue by the collateral ratio
1062         (err, scaledPrice) = mulExp(collateralRatio, assetPrice);
1063         if (err != Error.NO_ERROR) {
1064             return (err, Exp({mantissa: 0}));
1065         }
1066 
1067         // Get the price for the given asset amount
1068         return mulScalar(scaledPrice, assetAmount);
1069     }
1070 
1071     /**
1072       * @dev Calculates the origination fee added to a given borrowAmount
1073       *      This is simply `(1 + originationFee) * borrowAmount`
1074       *
1075       *      TODO: Track at what magnitude this fee rounds down to zero?
1076       */
1077     function calculateBorrowAmountWithFee(uint borrowAmount) view internal returns (Error, uint) {
1078         // When origination fee is zero, the amount with fee is simply equal to the amount
1079         if (isZeroExp(originationFee)) {
1080             return (Error.NO_ERROR, borrowAmount);
1081         }
1082 
1083         (Error err0, Exp memory originationFeeFactor) = addExp(originationFee, Exp({mantissa: mantissaOne}));
1084         if (err0 != Error.NO_ERROR) {
1085             return (err0, 0);
1086         }
1087 
1088         (Error err1, Exp memory borrowAmountWithFee) = mulScalar(originationFeeFactor, borrowAmount);
1089         if (err1 != Error.NO_ERROR) {
1090             return (err1, 0);
1091         }
1092 
1093         return (Error.NO_ERROR, truncate(borrowAmountWithFee));
1094     }
1095 
1096     /**
1097       * @dev fetches the price of asset from the PriceOracle and converts it to Exp
1098       * @param asset asset whose price should be fetched
1099       */
1100     function fetchAssetPrice(address asset) internal view returns (Error, Exp memory) {
1101         if (oracle == address(0)) {
1102             return (Error.ZERO_ORACLE_ADDRESS, Exp({mantissa: 0}));
1103         }
1104 
1105         PriceOracleInterface oracleInterface = PriceOracleInterface(oracle);
1106         uint priceMantissa = oracleInterface.assetPrices(asset);
1107 
1108         return (Error.NO_ERROR, Exp({mantissa: priceMantissa}));
1109     }
1110 
1111     /**
1112       * @notice Reads scaled price of specified asset from the price oracle
1113       * @dev Reads scaled price of specified asset from the price oracle.
1114       *      The plural name is to match a previous storage mapping that this function replaced.
1115       * @param asset Asset whose price should be retrieved
1116       * @return 0 on an error or missing price, the price scaled by 1e18 otherwise
1117       */
1118     function assetPrices(address asset) public view returns (uint) {
1119         (Error err, Exp memory result) = fetchAssetPrice(asset);
1120         if (err != Error.NO_ERROR) {
1121             return 0;
1122         }
1123         return result.mantissa;
1124     }
1125 
1126     /**
1127       * @dev Gets the amount of the specified asset given the specified Eth value
1128       *      ethValue / oraclePrice = assetAmountWei
1129       *      If there's no oraclePrice, this returns (Error.DIVISION_BY_ZERO, 0)
1130       */
1131     function getAssetAmountForValue(address asset, Exp ethValue) internal view returns (Error, uint) {
1132         Error err;
1133         Exp memory assetPrice;
1134         Exp memory assetAmount;
1135 
1136         (err, assetPrice) = fetchAssetPrice(asset);
1137         if (err != Error.NO_ERROR) {
1138             return (err, 0);
1139         }
1140 
1141         (err, assetAmount) = divExp(ethValue, assetPrice);
1142         if (err != Error.NO_ERROR) {
1143             return (err, 0);
1144         }
1145 
1146         return (Error.NO_ERROR, truncate(assetAmount));
1147     }
1148 
1149     /**
1150       * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
1151       * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
1152       * @param newPendingAdmin New pending admin.
1153       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1154       *
1155       * TODO: Should we add a second arg to verify, like a checksum of `newAdmin` address?
1156       */
1157     function _setPendingAdmin(address newPendingAdmin) public returns (uint) {
1158         // Check caller = admin
1159         if (msg.sender != admin) {
1160             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
1161         }
1162 
1163         // save current value, if any, for inclusion in log
1164         address oldPendingAdmin = pendingAdmin;
1165         // Store pendingAdmin = newPendingAdmin
1166         pendingAdmin = newPendingAdmin;
1167 
1168         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
1169 
1170         return uint(Error.NO_ERROR);
1171     }
1172 
1173     /**
1174       * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
1175       * @dev Admin function for pending admin to accept role and update admin
1176       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1177       */
1178     function _acceptAdmin() public returns (uint) {
1179         // Check caller = pendingAdmin
1180         // msg.sender can't be zero
1181         if (msg.sender != pendingAdmin) {
1182             return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);
1183         }
1184 
1185         // Save current value for inclusion in log
1186         address oldAdmin = admin;
1187         // Store admin = pendingAdmin
1188         admin = pendingAdmin;
1189         // Clear the pending value
1190         pendingAdmin = 0;
1191 
1192         emit NewAdmin(oldAdmin, msg.sender);
1193 
1194         return uint(Error.NO_ERROR);
1195     }
1196 
1197     /**
1198       * @notice Set new oracle, who can set asset prices
1199       * @dev Admin function to change oracle
1200       * @param newOracle New oracle address
1201       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1202       */
1203     function _setOracle(address newOracle) public returns (uint) {
1204         // Check caller = admin
1205         if (msg.sender != admin) {
1206             return fail(Error.UNAUTHORIZED, FailureInfo.SET_ORACLE_OWNER_CHECK);
1207         }
1208 
1209         // Verify contract at newOracle address supports assetPrices call.
1210         // This will revert if it doesn't.
1211         PriceOracleInterface oracleInterface = PriceOracleInterface(newOracle);
1212         oracleInterface.assetPrices(address(0));
1213 
1214         address oldOracle = oracle;
1215 
1216         // Store oracle = newOracle
1217         oracle = newOracle;
1218 
1219         emit NewOracle(oldOracle, newOracle);
1220 
1221         return uint(Error.NO_ERROR);
1222     }
1223 
1224     /**
1225       * @notice set `paused` to the specified state
1226       * @dev Admin function to pause or resume the market
1227       * @param requestedState value to assign to `paused`
1228       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1229       */
1230     function _setPaused(bool requestedState) public returns (uint) {
1231         // Check caller = admin
1232         if (msg.sender != admin) {
1233             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PAUSED_OWNER_CHECK);
1234         }
1235 
1236         paused = requestedState;
1237         emit SetPaused(requestedState);
1238 
1239         return uint(Error.NO_ERROR);
1240     }
1241 
1242     /**
1243       * @notice returns the liquidity for given account.
1244       *         a positive result indicates ability to borrow, whereas
1245       *         a negative result indicates a shortfall which may be liquidated
1246       * @dev returns account liquidity in terms of eth-wei value, scaled by 1e18
1247       *      note: this includes interest trued up on all balances
1248       * @param account the account to examine
1249       * @return signed integer in terms of eth-wei (negative indicates a shortfall)
1250       */
1251     function getAccountLiquidity(address account) public view returns (int) {
1252         (Error err, Exp memory accountLiquidity, Exp memory accountShortfall) = calculateAccountLiquidity(account);
1253         require(err == Error.NO_ERROR);
1254 
1255         if (isZeroExp(accountLiquidity)) {
1256             return -1 * int(truncate(accountShortfall));
1257         } else {
1258             return int(truncate(accountLiquidity));
1259         }
1260     }
1261 
1262     /**
1263       * @notice return supply balance with any accumulated interest for `asset` belonging to `account`
1264       * @dev returns supply balance with any accumulated interest for `asset` belonging to `account`
1265       * @param account the account to examine
1266       * @param asset the market asset whose supply balance belonging to `account` should be checked
1267       * @return uint supply balance on success, throws on failed assertion otherwise
1268       */
1269     function getSupplyBalance(address account, address asset) view public returns (uint) {
1270         Error err;
1271         uint newSupplyIndex;
1272         uint userSupplyCurrent;
1273 
1274         Market storage market = markets[asset];
1275         Balance storage supplyBalance = supplyBalances[account][asset];
1276 
1277         // Calculate the newSupplyIndex, needed to calculate user's supplyCurrent
1278         (err, newSupplyIndex) = calculateInterestIndex(market.supplyIndex, market.supplyRateMantissa, market.blockNumber, getBlockNumber());
1279         require(err == Error.NO_ERROR);
1280 
1281         // Use newSupplyIndex and stored principal to calculate the accumulated balance
1282         (err, userSupplyCurrent) = calculateBalance(supplyBalance.principal, supplyBalance.interestIndex, newSupplyIndex);
1283         require(err == Error.NO_ERROR);
1284 
1285         return userSupplyCurrent;
1286     }
1287 
1288     /**
1289       * @notice return borrow balance with any accumulated interest for `asset` belonging to `account`
1290       * @dev returns borrow balance with any accumulated interest for `asset` belonging to `account`
1291       * @param account the account to examine
1292       * @param asset the market asset whose borrow balance belonging to `account` should be checked
1293       * @return uint borrow balance on success, throws on failed assertion otherwise
1294       */
1295     function getBorrowBalance(address account, address asset) view public returns (uint) {
1296         Error err;
1297         uint newBorrowIndex;
1298         uint userBorrowCurrent;
1299 
1300         Market storage market = markets[asset];
1301         Balance storage borrowBalance = borrowBalances[account][asset];
1302 
1303         // Calculate the newBorrowIndex, needed to calculate user's borrowCurrent
1304         (err, newBorrowIndex) = calculateInterestIndex(market.borrowIndex, market.borrowRateMantissa, market.blockNumber, getBlockNumber());
1305         require(err == Error.NO_ERROR);
1306 
1307         // Use newBorrowIndex and stored principal to calculate the accumulated balance
1308         (err, userBorrowCurrent) = calculateBalance(borrowBalance.principal, borrowBalance.interestIndex, newBorrowIndex);
1309         require(err == Error.NO_ERROR);
1310 
1311         return userBorrowCurrent;
1312     }
1313 
1314 
1315     /**
1316       * @notice Supports a given market (asset) for use with Lendf.Me
1317       * @dev Admin function to add support for a market
1318       * @param asset Asset to support; MUST already have a non-zero price set
1319       * @param interestRateModel InterestRateModel to use for the asset
1320       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1321       */
1322     function _supportMarket(address asset, InterestRateModel interestRateModel) public returns (uint) {
1323         // Check caller = admin
1324         if (msg.sender != admin) {
1325             return fail(Error.UNAUTHORIZED, FailureInfo.SUPPORT_MARKET_OWNER_CHECK);
1326         }
1327 
1328         (Error err, Exp memory assetPrice) = fetchAssetPrice(asset);
1329         if (err != Error.NO_ERROR) {
1330             return fail(err, FailureInfo.SUPPORT_MARKET_FETCH_PRICE_FAILED);
1331         }
1332 
1333         if (isZeroExp(assetPrice)) {
1334             return fail(Error.ASSET_NOT_PRICED, FailureInfo.SUPPORT_MARKET_PRICE_CHECK);
1335         }
1336 
1337         // Set the interest rate model to `modelAddress`
1338         markets[asset].interestRateModel = interestRateModel;
1339 
1340         // Append asset to collateralAssets if not set
1341         addCollateralMarket(asset);
1342 
1343         // Set market isSupported to true
1344         markets[asset].isSupported = true;
1345 
1346         // Default supply and borrow index to 1e18
1347         if (markets[asset].supplyIndex == 0) {
1348             markets[asset].supplyIndex = initialInterestIndex;
1349         }
1350 
1351         if (markets[asset].borrowIndex == 0) {
1352             markets[asset].borrowIndex = initialInterestIndex;
1353         }
1354 
1355         emit SupportedMarket(asset, interestRateModel);
1356 
1357         return uint(Error.NO_ERROR);
1358     }
1359 
1360     /**
1361       * @notice Suspends a given *supported* market (asset) from use with Lendf.Me.
1362       *         Assets in this state do count for collateral, but users may only withdraw, payBorrow,
1363       *         and liquidate the asset. The liquidate function no longer checks collateralization.
1364       * @dev Admin function to suspend a market
1365       * @param asset Asset to suspend
1366       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1367       */
1368     function _suspendMarket(address asset) public returns (uint) {
1369         // Check caller = admin
1370         if (msg.sender != admin) {
1371             return fail(Error.UNAUTHORIZED, FailureInfo.SUSPEND_MARKET_OWNER_CHECK);
1372         }
1373 
1374         // If the market is not configured at all, we don't want to add any configuration for it.
1375         // If we find !markets[asset].isSupported then either the market is not configured at all, or it
1376         // has already been marked as unsupported. We can just return without doing anything.
1377         // Caller is responsible for knowing the difference between not-configured and already unsupported.
1378         if (!markets[asset].isSupported) {
1379             return uint(Error.NO_ERROR);
1380         }
1381 
1382         // If we get here, we know market is configured and is supported, so set isSupported to false
1383         markets[asset].isSupported = false;
1384 
1385         emit SuspendedMarket(asset);
1386 
1387         return uint(Error.NO_ERROR);
1388     }
1389 
1390     /**
1391       * @notice Sets the risk parameters: collateral ratio and liquidation discount
1392       * @dev Owner function to set the risk parameters
1393       * @param collateralRatioMantissa rational collateral ratio, scaled by 1e18. The de-scaled value must be >= 1.1
1394       * @param liquidationDiscountMantissa rational liquidation discount, scaled by 1e18. The de-scaled value must be <= 0.1 and must be less than (descaled collateral ratio minus 1)
1395       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1396       */
1397     function _setRiskParameters(uint collateralRatioMantissa, uint liquidationDiscountMantissa) public returns (uint) {
1398         // Check caller = admin
1399         if (msg.sender != admin) {
1400             return fail(Error.UNAUTHORIZED, FailureInfo.SET_RISK_PARAMETERS_OWNER_CHECK);
1401         }
1402 
1403         Exp memory newCollateralRatio = Exp({mantissa: collateralRatioMantissa});
1404         Exp memory newLiquidationDiscount = Exp({mantissa: liquidationDiscountMantissa});
1405         Exp memory minimumCollateralRatio = Exp({mantissa: minimumCollateralRatioMantissa});
1406         Exp memory maximumLiquidationDiscount = Exp({mantissa: maximumLiquidationDiscountMantissa});
1407 
1408         Error err;
1409         Exp memory newLiquidationDiscountPlusOne;
1410 
1411         // Make sure new collateral ratio value is not below minimum value
1412         if (lessThanExp(newCollateralRatio, minimumCollateralRatio)) {
1413             return fail(Error.INVALID_COLLATERAL_RATIO, FailureInfo.SET_RISK_PARAMETERS_VALIDATION);
1414         }
1415 
1416         // Make sure new liquidation discount does not exceed the maximum value, but reverse operands so we can use the
1417         // existing `lessThanExp` function rather than adding a `greaterThan` function to Exponential.
1418         if (lessThanExp(maximumLiquidationDiscount, newLiquidationDiscount)) {
1419             return fail(Error.INVALID_LIQUIDATION_DISCOUNT, FailureInfo.SET_RISK_PARAMETERS_VALIDATION);
1420         }
1421 
1422         // C = L+1 is not allowed because it would cause division by zero error in `calculateDiscountedRepayToEvenAmount`
1423         // C < L+1 is not allowed because it would cause integer underflow error in `calculateDiscountedRepayToEvenAmount`
1424         (err, newLiquidationDiscountPlusOne) = addExp(newLiquidationDiscount, Exp({mantissa: mantissaOne}));
1425         assert(err == Error.NO_ERROR); // We already validated that newLiquidationDiscount does not approach overflow size
1426 
1427         if (lessThanOrEqualExp(newCollateralRatio, newLiquidationDiscountPlusOne)) {
1428             return fail(Error.INVALID_COMBINED_RISK_PARAMETERS, FailureInfo.SET_RISK_PARAMETERS_VALIDATION);
1429         }
1430 
1431         // Save current values so we can emit them in log.
1432         Exp memory oldCollateralRatio = collateralRatio;
1433         Exp memory oldLiquidationDiscount = liquidationDiscount;
1434 
1435         // Store new values
1436         collateralRatio = newCollateralRatio;
1437         liquidationDiscount = newLiquidationDiscount;
1438 
1439         emit NewRiskParameters(oldCollateralRatio.mantissa, collateralRatioMantissa, oldLiquidationDiscount.mantissa, liquidationDiscountMantissa);
1440 
1441         return uint(Error.NO_ERROR);
1442     }
1443 
1444     /**
1445       * @notice Sets the origination fee (which is a multiplier on new borrows)
1446       * @dev Owner function to set the origination fee
1447       * @param originationFeeMantissa rational collateral ratio, scaled by 1e18. The de-scaled value must be >= 1.1
1448       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1449       */
1450     function _setOriginationFee(uint originationFeeMantissa) public returns (uint) {
1451         // Check caller = admin
1452         if (msg.sender != admin) {
1453             return fail(Error.UNAUTHORIZED, FailureInfo.SET_ORIGINATION_FEE_OWNER_CHECK);
1454         }
1455 
1456         // Save current value so we can emit it in log.
1457         Exp memory oldOriginationFee = originationFee;
1458 
1459         originationFee = Exp({mantissa: originationFeeMantissa});
1460 
1461         emit NewOriginationFee(oldOriginationFee.mantissa, originationFeeMantissa);
1462 
1463         return uint(Error.NO_ERROR);
1464     }
1465 
1466     /**
1467       * @notice Sets the interest rate model for a given market
1468       * @dev Admin function to set interest rate model
1469       * @param asset Asset to support
1470       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1471       */
1472     function _setMarketInterestRateModel(address asset, InterestRateModel interestRateModel) public returns (uint) {
1473         // Check caller = admin
1474         if (msg.sender != admin) {
1475             return fail(Error.UNAUTHORIZED, FailureInfo.SET_MARKET_INTEREST_RATE_MODEL_OWNER_CHECK);
1476         }
1477 
1478         // Set the interest rate model to `modelAddress`
1479         markets[asset].interestRateModel = interestRateModel;
1480 
1481         emit SetMarketInterestRateModel(asset, interestRateModel);
1482 
1483         return uint(Error.NO_ERROR);
1484     }
1485 
1486     /**
1487       * @notice withdraws `amount` of `asset` from equity for asset, as long as `amount` <= equity. Equity= cash - (supply + borrows)
1488       * @dev withdraws `amount` of `asset` from equity  for asset, enforcing amount <= cash - (supply + borrows)
1489       * @param asset asset whose equity should be withdrawn
1490       * @param amount amount of equity to withdraw; must not exceed equity available
1491       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1492       */
1493     function _withdrawEquity(address asset, uint amount) public returns (uint) {
1494         // Check caller = admin
1495         if (msg.sender != admin) {
1496             return fail(Error.UNAUTHORIZED, FailureInfo.EQUITY_WITHDRAWAL_MODEL_OWNER_CHECK);
1497         }
1498 
1499         // Check that amount is less than cash (from ERC-20 of self) plus borrows minus supply.
1500         uint cash = getCash(asset);
1501         (Error err0, uint equity) = addThenSub(cash, markets[asset].totalBorrows, markets[asset].totalSupply);
1502         if (err0 != Error.NO_ERROR) {
1503             return fail(err0, FailureInfo.EQUITY_WITHDRAWAL_CALCULATE_EQUITY);
1504         }
1505 
1506         if (amount > equity) {
1507             return fail(Error.EQUITY_INSUFFICIENT_BALANCE, FailureInfo.EQUITY_WITHDRAWAL_AMOUNT_VALIDATION);
1508         }
1509 
1510         /////////////////////////
1511         // EFFECTS & INTERACTIONS
1512         // (No safe failures beyond this point)
1513 
1514         // We ERC-20 transfer the asset out of the protocol to the admin
1515         Error err2 = doTransferOut(asset, admin, amount);
1516         if (err2 != Error.NO_ERROR) {
1517             // This is safe since it's our first interaction and it didn't do anything if it failed
1518             return fail(err2, FailureInfo.EQUITY_WITHDRAWAL_TRANSFER_OUT_FAILED);
1519         }
1520 
1521         //event EquityWithdrawn(address asset, uint equityAvailableBefore, uint amount, address owner)
1522         emit EquityWithdrawn(asset, equity, amount, admin);
1523 
1524         return uint(Error.NO_ERROR); // success
1525     }
1526 
1527     /**
1528       * The `SupplyLocalVars` struct is used internally in the `supply` function.
1529       *
1530       * To avoid solidity limits on the number of local variables we:
1531       * 1. Use a struct to hold local computation localResults
1532       * 2. Re-use a single variable for Error returns. (This is required with 1 because variable binding to tuple localResults
1533       *    requires either both to be declared inline or both to be previously declared.
1534       * 3. Re-use a boolean error-like return variable.
1535       */
1536     struct SupplyLocalVars {
1537         uint startingBalance;
1538         uint newSupplyIndex;
1539         uint userSupplyCurrent;
1540         uint userSupplyUpdated;
1541         uint newTotalSupply;
1542         uint currentCash;
1543         uint updatedCash;
1544         uint newSupplyRateMantissa;
1545         uint newBorrowIndex;
1546         uint newBorrowRateMantissa;
1547     }
1548 
1549 
1550     /**
1551       * @notice supply `amount` of `asset` (which must be supported) to `msg.sender` in the protocol
1552       * @dev add amount of supported asset to msg.sender's account
1553       * @param asset The market asset to supply
1554       * @param amount The amount to supply
1555       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1556       */
1557     function supply(address asset, uint amount) public returns (uint) {
1558         if (paused) {
1559             return fail(Error.CONTRACT_PAUSED, FailureInfo.SUPPLY_CONTRACT_PAUSED);
1560         }
1561 
1562         Market storage market = markets[asset];
1563         Balance storage balance = supplyBalances[msg.sender][asset];
1564 
1565         SupplyLocalVars memory localResults; // Holds all our uint calculation results
1566         Error err; // Re-used for every function call that includes an Error in its return value(s).
1567         uint rateCalculationResultCode; // Used for 2 interest rate calculation calls
1568 
1569         // Fail if market not supported
1570         if (!market.isSupported) {
1571             return fail(Error.MARKET_NOT_SUPPORTED, FailureInfo.SUPPLY_MARKET_NOT_SUPPORTED);
1572         }
1573 
1574         // Fail gracefully if asset is not approved or has insufficient balance
1575         err = checkTransferIn(asset, msg.sender, amount);
1576         if (err != Error.NO_ERROR) {
1577             return fail(err, FailureInfo.SUPPLY_TRANSFER_IN_NOT_POSSIBLE);
1578         }
1579 
1580         // We calculate the newSupplyIndex, user's supplyCurrent and supplyUpdated for the asset
1581         (err, localResults.newSupplyIndex) = calculateInterestIndex(market.supplyIndex, market.supplyRateMantissa, market.blockNumber, getBlockNumber());
1582         if (err != Error.NO_ERROR) {
1583             return fail(err, FailureInfo.SUPPLY_NEW_SUPPLY_INDEX_CALCULATION_FAILED);
1584         }
1585 
1586         (err, localResults.userSupplyCurrent) = calculateBalance(balance.principal, balance.interestIndex, localResults.newSupplyIndex);
1587         if (err != Error.NO_ERROR) {
1588             return fail(err, FailureInfo.SUPPLY_ACCUMULATED_BALANCE_CALCULATION_FAILED);
1589         }
1590 
1591         (err, localResults.userSupplyUpdated) = add(localResults.userSupplyCurrent, amount);
1592         if (err != Error.NO_ERROR) {
1593             return fail(err, FailureInfo.SUPPLY_NEW_TOTAL_BALANCE_CALCULATION_FAILED);
1594         }
1595 
1596         // We calculate the protocol's totalSupply by subtracting the user's prior checkpointed balance, adding user's updated supply
1597         (err, localResults.newTotalSupply) = addThenSub(market.totalSupply, localResults.userSupplyUpdated, balance.principal);
1598         if (err != Error.NO_ERROR) {
1599             return fail(err, FailureInfo.SUPPLY_NEW_TOTAL_SUPPLY_CALCULATION_FAILED);
1600         }
1601 
1602         // We need to calculate what the updated cash will be after we transfer in from user
1603         localResults.currentCash = getCash(asset);
1604 
1605         (err, localResults.updatedCash) = add(localResults.currentCash, amount);
1606         if (err != Error.NO_ERROR) {
1607             return fail(err, FailureInfo.SUPPLY_NEW_TOTAL_CASH_CALCULATION_FAILED);
1608         }
1609 
1610         // The utilization rate has changed! We calculate a new supply index and borrow index for the asset, and save it.
1611         (rateCalculationResultCode, localResults.newSupplyRateMantissa) = market.interestRateModel.getSupplyRate(asset, localResults.updatedCash, market.totalBorrows);
1612         if (rateCalculationResultCode != 0) {
1613             return failOpaque(FailureInfo.SUPPLY_NEW_SUPPLY_RATE_CALCULATION_FAILED, rateCalculationResultCode);
1614         }
1615 
1616         // We calculate the newBorrowIndex (we already had newSupplyIndex)
1617         (err, localResults.newBorrowIndex) = calculateInterestIndex(market.borrowIndex, market.borrowRateMantissa, market.blockNumber, getBlockNumber());
1618         if (err != Error.NO_ERROR) {
1619             return fail(err, FailureInfo.SUPPLY_NEW_BORROW_INDEX_CALCULATION_FAILED);
1620         }
1621 
1622         (rateCalculationResultCode, localResults.newBorrowRateMantissa) = market.interestRateModel.getBorrowRate(asset, localResults.updatedCash, market.totalBorrows);
1623         if (rateCalculationResultCode != 0) {
1624             return failOpaque(FailureInfo.SUPPLY_NEW_BORROW_RATE_CALCULATION_FAILED, rateCalculationResultCode);
1625         }
1626 
1627         /////////////////////////
1628         // EFFECTS & INTERACTIONS
1629         // (No safe failures beyond this point)
1630 
1631         // We ERC-20 transfer the asset into the protocol (note: pre-conditions already checked above)
1632         err = doTransferIn(asset, msg.sender, amount);
1633         if (err != Error.NO_ERROR) {
1634             // This is safe since it's our first interaction and it didn't do anything if it failed
1635             return fail(err, FailureInfo.SUPPLY_TRANSFER_IN_FAILED);
1636         }
1637 
1638         // Save market updates
1639         market.blockNumber = getBlockNumber();
1640         market.totalSupply =  localResults.newTotalSupply;
1641         market.supplyRateMantissa = localResults.newSupplyRateMantissa;
1642         market.supplyIndex = localResults.newSupplyIndex;
1643         market.borrowRateMantissa = localResults.newBorrowRateMantissa;
1644         market.borrowIndex = localResults.newBorrowIndex;
1645 
1646         // Save user updates
1647         localResults.startingBalance = balance.principal; // save for use in `SupplyReceived` event
1648         balance.principal = localResults.userSupplyUpdated;
1649         balance.interestIndex = localResults.newSupplyIndex;
1650 
1651         emit SupplyReceived(msg.sender, asset, amount, localResults.startingBalance, localResults.userSupplyUpdated);
1652 
1653         return uint(Error.NO_ERROR); // success
1654     }
1655 
1656     struct WithdrawLocalVars {
1657         uint withdrawAmount;
1658         uint startingBalance;
1659         uint newSupplyIndex;
1660         uint userSupplyCurrent;
1661         uint userSupplyUpdated;
1662         uint newTotalSupply;
1663         uint currentCash;
1664         uint updatedCash;
1665         uint newSupplyRateMantissa;
1666         uint newBorrowIndex;
1667         uint newBorrowRateMantissa;
1668 
1669         Exp accountLiquidity;
1670         Exp accountShortfall;
1671         Exp ethValueOfWithdrawal;
1672         uint withdrawCapacity;
1673     }
1674 
1675 
1676     /**
1677       * @notice withdraw `amount` of `asset` from sender's account to sender's address
1678       * @dev withdraw `amount` of `asset` from msg.sender's account to msg.sender
1679       * @param asset The market asset to withdraw
1680       * @param requestedAmount The amount to withdraw (or -1 for max)
1681       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1682       */
1683     function withdraw(address asset, uint requestedAmount) public returns (uint) {
1684         if (paused) {
1685             return fail(Error.CONTRACT_PAUSED, FailureInfo.WITHDRAW_CONTRACT_PAUSED);
1686         }
1687 
1688         Market storage market = markets[asset];
1689         Balance storage supplyBalance = supplyBalances[msg.sender][asset];
1690 
1691         WithdrawLocalVars memory localResults; // Holds all our calculation results
1692         Error err; // Re-used for every function call that includes an Error in its return value(s).
1693         uint rateCalculationResultCode; // Used for 2 interest rate calculation calls
1694 
1695         // We calculate the user's accountLiquidity and accountShortfall.
1696         (err, localResults.accountLiquidity, localResults.accountShortfall) = calculateAccountLiquidity(msg.sender);
1697         if (err != Error.NO_ERROR) {
1698             return fail(err, FailureInfo.WITHDRAW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED);
1699         }
1700 
1701         // We calculate the newSupplyIndex, user's supplyCurrent and supplyUpdated for the asset
1702         (err, localResults.newSupplyIndex) = calculateInterestIndex(market.supplyIndex, market.supplyRateMantissa, market.blockNumber, getBlockNumber());
1703         if (err != Error.NO_ERROR) {
1704             return fail(err, FailureInfo.WITHDRAW_NEW_SUPPLY_INDEX_CALCULATION_FAILED);
1705         }
1706 
1707         (err, localResults.userSupplyCurrent) = calculateBalance(supplyBalance.principal, supplyBalance.interestIndex, localResults.newSupplyIndex);
1708         if (err != Error.NO_ERROR) {
1709             return fail(err, FailureInfo.WITHDRAW_ACCUMULATED_BALANCE_CALCULATION_FAILED);
1710         }
1711 
1712         // If the user specifies -1 amount to withdraw ("max"),  withdrawAmount => the lesser of withdrawCapacity and supplyCurrent
1713         if (requestedAmount == uint(-1)) {
1714             (err, localResults.withdrawCapacity) = getAssetAmountForValue(asset, localResults.accountLiquidity);
1715             if (err != Error.NO_ERROR) {
1716                 return fail(err, FailureInfo.WITHDRAW_CAPACITY_CALCULATION_FAILED);
1717             }
1718             localResults.withdrawAmount = min(localResults.withdrawCapacity, localResults.userSupplyCurrent);
1719         } else {
1720             localResults.withdrawAmount = requestedAmount;
1721         }
1722 
1723         // From here on we should NOT use requestedAmount.
1724 
1725         // Fail gracefully if protocol has insufficient cash
1726         // If protocol has insufficient cash, the sub operation will underflow.
1727         localResults.currentCash = getCash(asset);
1728         (err, localResults.updatedCash) = sub(localResults.currentCash, localResults.withdrawAmount);
1729         if (err != Error.NO_ERROR) {
1730             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.WITHDRAW_TRANSFER_OUT_NOT_POSSIBLE);
1731         }
1732 
1733         // We check that the amount is less than or equal to supplyCurrent
1734         // If amount is greater than supplyCurrent, this will fail with Error.INTEGER_UNDERFLOW
1735         (err, localResults.userSupplyUpdated) = sub(localResults.userSupplyCurrent, localResults.withdrawAmount);
1736         if (err != Error.NO_ERROR) {
1737             return fail(Error.INSUFFICIENT_BALANCE, FailureInfo.WITHDRAW_NEW_TOTAL_BALANCE_CALCULATION_FAILED);
1738         }
1739 
1740         // Fail if customer already has a shortfall
1741         if (!isZeroExp(localResults.accountShortfall)) {
1742             return fail(Error.INSUFFICIENT_LIQUIDITY, FailureInfo.WITHDRAW_ACCOUNT_SHORTFALL_PRESENT);
1743         }
1744 
1745         // We want to know the user's withdrawCapacity, denominated in the asset
1746         // Customer's withdrawCapacity of asset is (accountLiquidity in Eth)/ (price of asset in Eth)
1747         // Equivalently, we calculate the eth value of the withdrawal amount and compare it directly to the accountLiquidity in Eth
1748         (err, localResults.ethValueOfWithdrawal) = getPriceForAssetAmount(asset, localResults.withdrawAmount); // amount * oraclePrice = ethValueOfWithdrawal
1749         if (err != Error.NO_ERROR) {
1750             return fail(err, FailureInfo.WITHDRAW_AMOUNT_VALUE_CALCULATION_FAILED);
1751         }
1752 
1753         // We check that the amount is less than withdrawCapacity (here), and less than or equal to supplyCurrent (below)
1754         if (lessThanExp(localResults.accountLiquidity, localResults.ethValueOfWithdrawal) ) {
1755             return fail(Error.INSUFFICIENT_LIQUIDITY, FailureInfo.WITHDRAW_AMOUNT_LIQUIDITY_SHORTFALL);
1756         }
1757 
1758         // We calculate the protocol's totalSupply by subtracting the user's prior checkpointed balance, adding user's updated supply.
1759         // Note that, even though the customer is withdrawing, if they've accumulated a lot of interest since their last
1760         // action, the updated balance *could* be higher than the prior checkpointed balance.
1761         (err, localResults.newTotalSupply) = addThenSub(market.totalSupply, localResults.userSupplyUpdated, supplyBalance.principal);
1762         if (err != Error.NO_ERROR) {
1763             return fail(err, FailureInfo.WITHDRAW_NEW_TOTAL_SUPPLY_CALCULATION_FAILED);
1764         }
1765 
1766         // The utilization rate has changed! We calculate a new supply index and borrow index for the asset, and save it.
1767         (rateCalculationResultCode, localResults.newSupplyRateMantissa) = market.interestRateModel.getSupplyRate(asset, localResults.updatedCash, market.totalBorrows);
1768         if (rateCalculationResultCode != 0) {
1769             return failOpaque(FailureInfo.WITHDRAW_NEW_SUPPLY_RATE_CALCULATION_FAILED, rateCalculationResultCode);
1770         }
1771 
1772         // We calculate the newBorrowIndex
1773         (err, localResults.newBorrowIndex) = calculateInterestIndex(market.borrowIndex, market.borrowRateMantissa, market.blockNumber, getBlockNumber());
1774         if (err != Error.NO_ERROR) {
1775             return fail(err, FailureInfo.WITHDRAW_NEW_BORROW_INDEX_CALCULATION_FAILED);
1776         }
1777 
1778         (rateCalculationResultCode, localResults.newBorrowRateMantissa) = market.interestRateModel.getBorrowRate(asset, localResults.updatedCash, market.totalBorrows);
1779         if (rateCalculationResultCode != 0) {
1780             return failOpaque(FailureInfo.WITHDRAW_NEW_BORROW_RATE_CALCULATION_FAILED, rateCalculationResultCode);
1781         }
1782 
1783         /////////////////////////
1784         // EFFECTS & INTERACTIONS
1785         // (No safe failures beyond this point)
1786 
1787         // We ERC-20 transfer the asset into the protocol (note: pre-conditions already checked above)
1788         err = doTransferOut(asset, msg.sender, localResults.withdrawAmount);
1789         if (err != Error.NO_ERROR) {
1790             // This is safe since it's our first interaction and it didn't do anything if it failed
1791             return fail(err, FailureInfo.WITHDRAW_TRANSFER_OUT_FAILED);
1792         }
1793 
1794         // Save market updates
1795         market.blockNumber = getBlockNumber();
1796         market.totalSupply =  localResults.newTotalSupply;
1797         market.supplyRateMantissa = localResults.newSupplyRateMantissa;
1798         market.supplyIndex = localResults.newSupplyIndex;
1799         market.borrowRateMantissa = localResults.newBorrowRateMantissa;
1800         market.borrowIndex = localResults.newBorrowIndex;
1801 
1802         // Save user updates
1803         localResults.startingBalance = supplyBalance.principal; // save for use in `SupplyWithdrawn` event
1804         supplyBalance.principal = localResults.userSupplyUpdated;
1805         supplyBalance.interestIndex = localResults.newSupplyIndex;
1806 
1807         emit SupplyWithdrawn(msg.sender, asset, localResults.withdrawAmount, localResults.startingBalance, localResults.userSupplyUpdated);
1808 
1809         return uint(Error.NO_ERROR); // success
1810     }
1811 
1812     struct AccountValueLocalVars {
1813         address assetAddress;
1814         uint collateralMarketsLength;
1815 
1816         uint newSupplyIndex;
1817         uint userSupplyCurrent;
1818         Exp supplyTotalValue;
1819         Exp sumSupplies;
1820 
1821         uint newBorrowIndex;
1822         uint userBorrowCurrent;
1823         Exp borrowTotalValue;
1824         Exp sumBorrows;
1825     }
1826 
1827     /**
1828       * @dev Gets the user's account liquidity and account shortfall balances. This includes
1829       *      any accumulated interest thus far but does NOT actually update anything in
1830       *      storage, it simply calculates the account liquidity and shortfall with liquidity being
1831       *      returned as the first Exp, ie (Error, accountLiquidity, accountShortfall).
1832       */
1833     function calculateAccountLiquidity(address userAddress) internal view returns (Error, Exp memory, Exp memory) {
1834         Error err;
1835         uint sumSupplyValuesMantissa;
1836         uint sumBorrowValuesMantissa;
1837         (err, sumSupplyValuesMantissa, sumBorrowValuesMantissa) = calculateAccountValuesInternal(userAddress);
1838         if (err != Error.NO_ERROR) {
1839             return(err, Exp({mantissa: 0}), Exp({mantissa: 0}));
1840         }
1841 
1842         Exp memory result;
1843 
1844         Exp memory sumSupplyValuesFinal = Exp({mantissa: sumSupplyValuesMantissa});
1845         Exp memory sumBorrowValuesFinal; // need to apply collateral ratio
1846 
1847         (err, sumBorrowValuesFinal) = mulExp(collateralRatio, Exp({mantissa: sumBorrowValuesMantissa}));
1848         if (err != Error.NO_ERROR) {
1849             return (err, Exp({mantissa: 0}), Exp({mantissa: 0}));
1850         }
1851 
1852         // if sumSupplies < sumBorrows, then the user is under collateralized and has account shortfall.
1853         // else the user meets the collateral ratio and has account liquidity.
1854         if (lessThanExp(sumSupplyValuesFinal, sumBorrowValuesFinal)) {
1855             // accountShortfall = borrows - supplies
1856             (err, result) = subExp(sumBorrowValuesFinal, sumSupplyValuesFinal);
1857             assert(err == Error.NO_ERROR); // Note: we have checked that sumBorrows is greater than sumSupplies directly above, therefore `subExp` cannot fail.
1858 
1859             return (Error.NO_ERROR, Exp({mantissa: 0}), result);
1860         } else {
1861             // accountLiquidity = supplies - borrows
1862             (err, result) = subExp(sumSupplyValuesFinal, sumBorrowValuesFinal);
1863             assert(err == Error.NO_ERROR); // Note: we have checked that sumSupplies is greater than sumBorrows directly above, therefore `subExp` cannot fail.
1864 
1865             return (Error.NO_ERROR, result, Exp({mantissa: 0}));
1866         }
1867     }
1868 
1869     /**
1870       * @notice Gets the ETH values of the user's accumulated supply and borrow balances, scaled by 10e18.
1871       *         This includes any accumulated interest thus far but does NOT actually update anything in
1872       *         storage
1873       * @dev Gets ETH values of accumulated supply and borrow balances
1874       * @param userAddress account for which to sum values
1875       * @return (error code, sum ETH value of supplies scaled by 10e18, sum ETH value of borrows scaled by 10e18)
1876       * TODO: Possibly should add a Min(500, collateralMarkets.length) for extra safety
1877       * TODO: To help save gas we could think about using the current Market.interestIndex
1878       *       accumulate interest rather than calculating it
1879       */
1880     function calculateAccountValuesInternal(address userAddress) internal view returns (Error, uint, uint) {
1881         /** By definition, all collateralMarkets are those that contribute to the user's
1882           * liquidity and shortfall so we need only loop through those markets.
1883           * To handle avoiding intermediate negative results, we will sum all the user's
1884           * supply balances and borrow balances (with collateral ratio) separately and then
1885           * subtract the sums at the end.
1886           */
1887 
1888         AccountValueLocalVars memory localResults; // Re-used for all intermediate results
1889         localResults.sumSupplies = Exp({mantissa: 0});
1890         localResults.sumBorrows = Exp({mantissa: 0});
1891         Error err; // Re-used for all intermediate errors
1892         localResults.collateralMarketsLength = collateralMarkets.length;
1893 
1894         for (uint i = 0; i < localResults.collateralMarketsLength; i++) {
1895             localResults.assetAddress = collateralMarkets[i];
1896             Market storage currentMarket = markets[localResults.assetAddress];
1897             Balance storage supplyBalance = supplyBalances[userAddress][localResults.assetAddress];
1898             Balance storage borrowBalance = borrowBalances[userAddress][localResults.assetAddress];
1899 
1900             if (supplyBalance.principal > 0) {
1901                 // We calculate the newSupplyIndex and user’s supplyCurrent (includes interest)
1902                 (err, localResults.newSupplyIndex) = calculateInterestIndex(currentMarket.supplyIndex, currentMarket.supplyRateMantissa, currentMarket.blockNumber, getBlockNumber());
1903                 if (err != Error.NO_ERROR) {
1904                     return (err, 0, 0);
1905                 }
1906 
1907                 (err, localResults.userSupplyCurrent) = calculateBalance(supplyBalance.principal, supplyBalance.interestIndex, localResults.newSupplyIndex);
1908                 if (err != Error.NO_ERROR) {
1909                     return (err, 0, 0);
1910                 }
1911 
1912                 // We have the user's supply balance with interest so let's multiply by the asset price to get the total value
1913                 (err, localResults.supplyTotalValue) = getPriceForAssetAmount(localResults.assetAddress, localResults.userSupplyCurrent); // supplyCurrent * oraclePrice = supplyValueInEth
1914                 if (err != Error.NO_ERROR) {
1915                     return (err, 0, 0);
1916                 }
1917 
1918                 // Add this to our running sum of supplies
1919                 (err, localResults.sumSupplies) = addExp(localResults.supplyTotalValue, localResults.sumSupplies);
1920                 if (err != Error.NO_ERROR) {
1921                     return (err, 0, 0);
1922                 }
1923             }
1924 
1925             if (borrowBalance.principal > 0) {
1926                 // We perform a similar actions to get the user's borrow balance
1927                 (err, localResults.newBorrowIndex) = calculateInterestIndex(currentMarket.borrowIndex, currentMarket.borrowRateMantissa, currentMarket.blockNumber, getBlockNumber());
1928                 if (err != Error.NO_ERROR) {
1929                     return (err, 0, 0);
1930                 }
1931 
1932                 (err, localResults.userBorrowCurrent) = calculateBalance(borrowBalance.principal, borrowBalance.interestIndex, localResults.newBorrowIndex);
1933                 if (err != Error.NO_ERROR) {
1934                     return (err, 0, 0);
1935                 }
1936 
1937                 // In the case of borrow, we multiply the borrow value by the collateral ratio
1938                 (err, localResults.borrowTotalValue) = getPriceForAssetAmount(localResults.assetAddress, localResults.userBorrowCurrent); // ( borrowCurrent* oraclePrice * collateralRatio) = borrowTotalValueInEth
1939                 if (err != Error.NO_ERROR) {
1940                     return (err, 0, 0);
1941                 }
1942 
1943                 // Add this to our running sum of borrows
1944                 (err, localResults.sumBorrows) = addExp(localResults.borrowTotalValue, localResults.sumBorrows);
1945                 if (err != Error.NO_ERROR) {
1946                     return (err, 0, 0);
1947                 }
1948             }
1949         }
1950 
1951         return (Error.NO_ERROR, localResults.sumSupplies.mantissa, localResults.sumBorrows.mantissa);
1952     }
1953 
1954     /**
1955       * @notice Gets the ETH values of the user's accumulated supply and borrow balances, scaled by 10e18.
1956       *         This includes any accumulated interest thus far but does NOT actually update anything in
1957       *         storage
1958       * @dev Gets ETH values of accumulated supply and borrow balances
1959       * @param userAddress account for which to sum values
1960       * @return (uint 0=success; otherwise a failure (see ErrorReporter.sol for details),
1961       *          sum ETH value of supplies scaled by 10e18,
1962       *          sum ETH value of borrows scaled by 10e18)
1963       */
1964     function calculateAccountValues(address userAddress) public view returns (uint, uint, uint) {
1965         (Error err, uint supplyValue, uint borrowValue) = calculateAccountValuesInternal(userAddress);
1966         if (err != Error.NO_ERROR) {
1967 
1968             return (uint(err), 0, 0);
1969         }
1970 
1971         return (0, supplyValue, borrowValue);
1972     }
1973 
1974     struct PayBorrowLocalVars {
1975         uint newBorrowIndex;
1976         uint userBorrowCurrent;
1977         uint repayAmount;
1978 
1979         uint userBorrowUpdated;
1980         uint newTotalBorrows;
1981         uint currentCash;
1982         uint updatedCash;
1983 
1984         uint newSupplyIndex;
1985         uint newSupplyRateMantissa;
1986         uint newBorrowRateMantissa;
1987 
1988         uint startingBalance;
1989     }
1990 
1991     /**
1992       * @notice Users repay borrowed assets from their own address to the protocol.
1993       * @param asset The market asset to repay
1994       * @param amount The amount to repay (or -1 for max)
1995       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1996       */
1997     function repayBorrow(address asset, uint amount) public returns (uint) {
1998         if (paused) {
1999             return fail(Error.CONTRACT_PAUSED, FailureInfo.REPAY_BORROW_CONTRACT_PAUSED);
2000         }
2001         PayBorrowLocalVars memory localResults;
2002         Market storage market = markets[asset];
2003         Balance storage borrowBalance = borrowBalances[msg.sender][asset];
2004         Error err;
2005         uint rateCalculationResultCode;
2006 
2007         // We calculate the newBorrowIndex, user's borrowCurrent and borrowUpdated for the asset
2008         (err, localResults.newBorrowIndex) = calculateInterestIndex(market.borrowIndex, market.borrowRateMantissa, market.blockNumber, getBlockNumber());
2009         if (err != Error.NO_ERROR) {
2010             return fail(err, FailureInfo.REPAY_BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED);
2011         }
2012 
2013         (err, localResults.userBorrowCurrent) = calculateBalance(borrowBalance.principal, borrowBalance.interestIndex, localResults.newBorrowIndex);
2014         if (err != Error.NO_ERROR) {
2015             return fail(err, FailureInfo.REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED);
2016         }
2017 
2018         // If the user specifies -1 amount to repay (“max”), repayAmount =>
2019         // the lesser of the senders ERC-20 balance and borrowCurrent
2020         if (amount == uint(-1)) {
2021             localResults.repayAmount = min(getBalanceOf(asset, msg.sender), localResults.userBorrowCurrent);
2022         } else {
2023             localResults.repayAmount = amount;
2024         }
2025 
2026         // Subtract the `repayAmount` from the `userBorrowCurrent` to get `userBorrowUpdated`
2027         // Note: this checks that repayAmount is less than borrowCurrent
2028         (err, localResults.userBorrowUpdated) = sub(localResults.userBorrowCurrent, localResults.repayAmount);
2029         if (err != Error.NO_ERROR) {
2030             return fail(err, FailureInfo.REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED);
2031         }
2032 
2033         // Fail gracefully if asset is not approved or has insufficient balance
2034         // Note: this checks that repayAmount is less than or equal to their ERC-20 balance
2035         err = checkTransferIn(asset, msg.sender, localResults.repayAmount);
2036         if (err != Error.NO_ERROR) {
2037             return fail(err, FailureInfo.REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE);
2038         }
2039 
2040         // We calculate the protocol's totalBorrow by subtracting the user's prior checkpointed balance, adding user's updated borrow
2041         // Note that, even though the customer is paying some of their borrow, if they've accumulated a lot of interest since their last
2042         // action, the updated balance *could* be higher than the prior checkpointed balance.
2043         (err, localResults.newTotalBorrows) = addThenSub(market.totalBorrows, localResults.userBorrowUpdated, borrowBalance.principal);
2044         if (err != Error.NO_ERROR) {
2045             return fail(err, FailureInfo.REPAY_BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED);
2046         }
2047 
2048         // We need to calculate what the updated cash will be after we transfer in from user
2049         localResults.currentCash = getCash(asset);
2050 
2051         (err, localResults.updatedCash) = add(localResults.currentCash, localResults.repayAmount);
2052         if (err != Error.NO_ERROR) {
2053             return fail(err, FailureInfo.REPAY_BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED);
2054         }
2055 
2056         // The utilization rate has changed! We calculate a new supply index and borrow index for the asset, and save it.
2057 
2058         // We calculate the newSupplyIndex, but we have newBorrowIndex already
2059         (err, localResults.newSupplyIndex) = calculateInterestIndex(market.supplyIndex, market.supplyRateMantissa, market.blockNumber, getBlockNumber());
2060         if (err != Error.NO_ERROR) {
2061             return fail(err, FailureInfo.REPAY_BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED);
2062         }
2063 
2064         (rateCalculationResultCode, localResults.newSupplyRateMantissa) = market.interestRateModel.getSupplyRate(asset, localResults.updatedCash, localResults.newTotalBorrows);
2065         if (rateCalculationResultCode != 0) {
2066             return failOpaque(FailureInfo.REPAY_BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED, rateCalculationResultCode);
2067         }
2068 
2069         (rateCalculationResultCode, localResults.newBorrowRateMantissa) = market.interestRateModel.getBorrowRate(asset, localResults.updatedCash, localResults.newTotalBorrows);
2070         if (rateCalculationResultCode != 0) {
2071             return failOpaque(FailureInfo.REPAY_BORROW_NEW_BORROW_RATE_CALCULATION_FAILED, rateCalculationResultCode);
2072         }
2073 
2074         /////////////////////////
2075         // EFFECTS & INTERACTIONS
2076         // (No safe failures beyond this point)
2077 
2078         // We ERC-20 transfer the asset into the protocol (note: pre-conditions already checked above)
2079         err = doTransferIn(asset, msg.sender, localResults.repayAmount);
2080         if (err != Error.NO_ERROR) {
2081             // This is safe since it's our first interaction and it didn't do anything if it failed
2082             return fail(err, FailureInfo.REPAY_BORROW_TRANSFER_IN_FAILED);
2083         }
2084 
2085         // Save market updates
2086         market.blockNumber = getBlockNumber();
2087         market.totalBorrows =  localResults.newTotalBorrows;
2088         market.supplyRateMantissa = localResults.newSupplyRateMantissa;
2089         market.supplyIndex = localResults.newSupplyIndex;
2090         market.borrowRateMantissa = localResults.newBorrowRateMantissa;
2091         market.borrowIndex = localResults.newBorrowIndex;
2092 
2093         // Save user updates
2094         localResults.startingBalance = borrowBalance.principal; // save for use in `BorrowRepaid` event
2095         borrowBalance.principal = localResults.userBorrowUpdated;
2096         borrowBalance.interestIndex = localResults.newBorrowIndex;
2097 
2098         emit BorrowRepaid(msg.sender, asset, localResults.repayAmount, localResults.startingBalance, localResults.userBorrowUpdated);
2099 
2100         return uint(Error.NO_ERROR); // success
2101     }
2102 
2103     struct BorrowLocalVars {
2104         uint newBorrowIndex;
2105         uint userBorrowCurrent;
2106         uint borrowAmountWithFee;
2107 
2108         uint userBorrowUpdated;
2109         uint newTotalBorrows;
2110         uint currentCash;
2111         uint updatedCash;
2112 
2113         uint newSupplyIndex;
2114         uint newSupplyRateMantissa;
2115         uint newBorrowRateMantissa;
2116 
2117         uint startingBalance;
2118 
2119         Exp accountLiquidity;
2120         Exp accountShortfall;
2121         Exp ethValueOfBorrowAmountWithFee;
2122     }
2123 
2124     struct LiquidateLocalVars {
2125         // we need these addresses in the struct for use with `emitLiquidationEvent` to avoid `CompilerError: Stack too deep, try removing local variables.`
2126         address targetAccount;
2127         address assetBorrow;
2128         address liquidator;
2129         address assetCollateral;
2130 
2131         // borrow index and supply index are global to the asset, not specific to the user
2132         uint newBorrowIndex_UnderwaterAsset;
2133         uint newSupplyIndex_UnderwaterAsset;
2134         uint newBorrowIndex_CollateralAsset;
2135         uint newSupplyIndex_CollateralAsset;
2136 
2137         // the target borrow's full balance with accumulated interest
2138         uint currentBorrowBalance_TargetUnderwaterAsset;
2139         // currentBorrowBalance_TargetUnderwaterAsset minus whatever gets repaid as part of the liquidation
2140         uint updatedBorrowBalance_TargetUnderwaterAsset;
2141 
2142         uint newTotalBorrows_ProtocolUnderwaterAsset;
2143 
2144         uint startingBorrowBalance_TargetUnderwaterAsset;
2145         uint startingSupplyBalance_TargetCollateralAsset;
2146         uint startingSupplyBalance_LiquidatorCollateralAsset;
2147 
2148         uint currentSupplyBalance_TargetCollateralAsset;
2149         uint updatedSupplyBalance_TargetCollateralAsset;
2150 
2151         // If liquidator already has a balance of collateralAsset, we will accumulate
2152         // interest on it before transferring seized collateral from the borrower.
2153         uint currentSupplyBalance_LiquidatorCollateralAsset;
2154         // This will be the liquidator's accumulated balance of collateral asset before the liquidation (if any)
2155         // plus the amount seized from the borrower.
2156         uint updatedSupplyBalance_LiquidatorCollateralAsset;
2157 
2158         uint newTotalSupply_ProtocolCollateralAsset;
2159         uint currentCash_ProtocolUnderwaterAsset;
2160         uint updatedCash_ProtocolUnderwaterAsset;
2161 
2162         // cash does not change for collateral asset
2163 
2164         uint newSupplyRateMantissa_ProtocolUnderwaterAsset;
2165         uint newBorrowRateMantissa_ProtocolUnderwaterAsset;
2166 
2167         // Why no variables for the interest rates for the collateral asset?
2168         // We don't need to calculate new rates for the collateral asset since neither cash nor borrows change
2169 
2170         uint discountedRepayToEvenAmount;
2171 
2172         //[supplyCurrent / (1 + liquidationDiscount)] * (Oracle price for the collateral / Oracle price for the borrow) (discountedBorrowDenominatedCollateral)
2173         uint discountedBorrowDenominatedCollateral;
2174 
2175         uint maxCloseableBorrowAmount_TargetUnderwaterAsset;
2176         uint closeBorrowAmount_TargetUnderwaterAsset;
2177         uint seizeSupplyAmount_TargetCollateralAsset;
2178 
2179         Exp collateralPrice;
2180         Exp underwaterAssetPrice;
2181     }
2182 
2183     /**
2184       * @notice users repay all or some of an underwater borrow and receive collateral
2185       * @param targetAccount The account whose borrow should be liquidated
2186       * @param assetBorrow The market asset to repay
2187       * @param assetCollateral The borrower's market asset to receive in exchange
2188       * @param requestedAmountClose The amount to repay (or -1 for max)
2189       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2190       */
2191     function liquidateBorrow(address targetAccount, address assetBorrow, address assetCollateral, uint requestedAmountClose) public returns (uint) {
2192         if (paused) {
2193             return fail(Error.CONTRACT_PAUSED, FailureInfo.LIQUIDATE_CONTRACT_PAUSED);
2194         }
2195         LiquidateLocalVars memory localResults;
2196         // Copy these addresses into the struct for use with `emitLiquidationEvent`
2197         // We'll use localResults.liquidator inside this function for clarity vs using msg.sender.
2198         localResults.targetAccount = targetAccount;
2199         localResults.assetBorrow = assetBorrow;
2200         localResults.liquidator = msg.sender;
2201         localResults.assetCollateral = assetCollateral;
2202 
2203         Market storage borrowMarket = markets[assetBorrow];
2204         Market storage collateralMarket = markets[assetCollateral];
2205         Balance storage borrowBalance_TargeUnderwaterAsset = borrowBalances[targetAccount][assetBorrow];
2206         Balance storage supplyBalance_TargetCollateralAsset = supplyBalances[targetAccount][assetCollateral];
2207 
2208         // Liquidator might already hold some of the collateral asset
2209         Balance storage supplyBalance_LiquidatorCollateralAsset = supplyBalances[localResults.liquidator][assetCollateral];
2210 
2211         uint rateCalculationResultCode; // Used for multiple interest rate calculation calls
2212         Error err; // re-used for all intermediate errors
2213 
2214         (err, localResults.collateralPrice) = fetchAssetPrice(assetCollateral);
2215         if(err != Error.NO_ERROR) {
2216             return fail(err, FailureInfo.LIQUIDATE_FETCH_ASSET_PRICE_FAILED);
2217         }
2218 
2219         (err, localResults.underwaterAssetPrice) = fetchAssetPrice(assetBorrow);
2220         // If the price oracle is not set, then we would have failed on the first call to fetchAssetPrice
2221         assert(err == Error.NO_ERROR);
2222 
2223         // We calculate newBorrowIndex_UnderwaterAsset and then use it to help calculate currentBorrowBalance_TargetUnderwaterAsset
2224         (err, localResults.newBorrowIndex_UnderwaterAsset) = calculateInterestIndex(borrowMarket.borrowIndex, borrowMarket.borrowRateMantissa, borrowMarket.blockNumber, getBlockNumber());
2225         if (err != Error.NO_ERROR) {
2226             return fail(err, FailureInfo.LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_BORROWED_ASSET);
2227         }
2228 
2229         (err, localResults.currentBorrowBalance_TargetUnderwaterAsset) = calculateBalance(borrowBalance_TargeUnderwaterAsset.principal, borrowBalance_TargeUnderwaterAsset.interestIndex, localResults.newBorrowIndex_UnderwaterAsset);
2230         if (err != Error.NO_ERROR) {
2231             return fail(err, FailureInfo.LIQUIDATE_ACCUMULATED_BORROW_BALANCE_CALCULATION_FAILED);
2232         }
2233 
2234         // We calculate newSupplyIndex_CollateralAsset and then use it to help calculate currentSupplyBalance_TargetCollateralAsset
2235         (err, localResults.newSupplyIndex_CollateralAsset) = calculateInterestIndex(collateralMarket.supplyIndex, collateralMarket.supplyRateMantissa, collateralMarket.blockNumber, getBlockNumber());
2236         if (err != Error.NO_ERROR) {
2237             return fail(err, FailureInfo.LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET);
2238         }
2239 
2240         (err, localResults.currentSupplyBalance_TargetCollateralAsset) = calculateBalance(supplyBalance_TargetCollateralAsset.principal, supplyBalance_TargetCollateralAsset.interestIndex, localResults.newSupplyIndex_CollateralAsset);
2241         if (err != Error.NO_ERROR) {
2242             return fail(err, FailureInfo.LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET);
2243         }
2244 
2245         // Liquidator may or may not already have some collateral asset.
2246         // If they do, we need to accumulate interest on it before adding the seized collateral to it.
2247         // We re-use newSupplyIndex_CollateralAsset calculated above to help calculate currentSupplyBalance_LiquidatorCollateralAsset
2248         (err, localResults.currentSupplyBalance_LiquidatorCollateralAsset) = calculateBalance(supplyBalance_LiquidatorCollateralAsset.principal, supplyBalance_LiquidatorCollateralAsset.interestIndex, localResults.newSupplyIndex_CollateralAsset);
2249         if (err != Error.NO_ERROR) {
2250             return fail(err, FailureInfo.LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET);
2251         }
2252 
2253         // We update the protocol's totalSupply for assetCollateral in 2 steps, first by adding target user's accumulated
2254         // interest and then by adding the liquidator's accumulated interest.
2255 
2256         // Step 1 of 2: We add the target user's supplyCurrent and subtract their checkpointedBalance
2257         // (which has the desired effect of adding accrued interest from the target user)
2258         (err, localResults.newTotalSupply_ProtocolCollateralAsset) = addThenSub(collateralMarket.totalSupply, localResults.currentSupplyBalance_TargetCollateralAsset, supplyBalance_TargetCollateralAsset.principal);
2259         if (err != Error.NO_ERROR) {
2260             return fail(err, FailureInfo.LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET);
2261         }
2262 
2263         // Step 2 of 2: We add the liquidator's supplyCurrent of collateral asset and subtract their checkpointedBalance
2264         // (which has the desired effect of adding accrued interest from the calling user)
2265         (err, localResults.newTotalSupply_ProtocolCollateralAsset) = addThenSub(localResults.newTotalSupply_ProtocolCollateralAsset, localResults.currentSupplyBalance_LiquidatorCollateralAsset, supplyBalance_LiquidatorCollateralAsset.principal);
2266         if (err != Error.NO_ERROR) {
2267             return fail(err, FailureInfo.LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET);
2268         }
2269 
2270         // We calculate maxCloseableBorrowAmount_TargetUnderwaterAsset, the amount of borrow that can be closed from the target user
2271         // This is equal to the lesser of
2272         // 1. borrowCurrent; (already calculated)
2273         // 2. ONLY IF MARKET SUPPORTED: discountedRepayToEvenAmount:
2274         // discountedRepayToEvenAmount=
2275         //      shortfall / [Oracle price for the borrow * (collateralRatio - liquidationDiscount - 1)]
2276         // 3. discountedBorrowDenominatedCollateral
2277         //      [supplyCurrent / (1 + liquidationDiscount)] * (Oracle price for the collateral / Oracle price for the borrow)
2278 
2279         // Here we calculate item 3. discountedBorrowDenominatedCollateral =
2280         // [supplyCurrent / (1 + liquidationDiscount)] * (Oracle price for the collateral / Oracle price for the borrow)
2281         (err, localResults.discountedBorrowDenominatedCollateral) =
2282         calculateDiscountedBorrowDenominatedCollateral(localResults.underwaterAssetPrice, localResults.collateralPrice, localResults.currentSupplyBalance_TargetCollateralAsset);
2283         if (err != Error.NO_ERROR) {
2284             return fail(err, FailureInfo.LIQUIDATE_BORROW_DENOMINATED_COLLATERAL_CALCULATION_FAILED);
2285         }
2286 
2287         if (borrowMarket.isSupported) {
2288             // Market is supported, so we calculate item 2 from above.
2289             (err, localResults.discountedRepayToEvenAmount) =
2290             calculateDiscountedRepayToEvenAmount(targetAccount, localResults.underwaterAssetPrice);
2291             if (err != Error.NO_ERROR) {
2292                 return fail(err, FailureInfo.LIQUIDATE_DISCOUNTED_REPAY_TO_EVEN_AMOUNT_CALCULATION_FAILED);
2293             }
2294 
2295             // We need to do a two-step min to select from all 3 values
2296             // min1&3 = min(item 1, item 3)
2297             localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset = min(localResults.currentBorrowBalance_TargetUnderwaterAsset, localResults.discountedBorrowDenominatedCollateral);
2298 
2299             // min1&3&2 = min(min1&3, 2)
2300             localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset = min(localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset, localResults.discountedRepayToEvenAmount);
2301         } else {
2302             // Market is not supported, so we don't need to calculate item 2.
2303             localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset = min(localResults.currentBorrowBalance_TargetUnderwaterAsset, localResults.discountedBorrowDenominatedCollateral);
2304         }
2305 
2306         // If liquidateBorrowAmount = -1, then closeBorrowAmount_TargetUnderwaterAsset = maxCloseableBorrowAmount_TargetUnderwaterAsset
2307         if (requestedAmountClose == uint(-1)) {
2308             localResults.closeBorrowAmount_TargetUnderwaterAsset = localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset;
2309         } else {
2310             localResults.closeBorrowAmount_TargetUnderwaterAsset = requestedAmountClose;
2311         }
2312 
2313         // From here on, no more use of `requestedAmountClose`
2314 
2315         // Verify closeBorrowAmount_TargetUnderwaterAsset <= maxCloseableBorrowAmount_TargetUnderwaterAsset
2316         if (localResults.closeBorrowAmount_TargetUnderwaterAsset > localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset) {
2317             return fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_TOO_HIGH);
2318         }
2319 
2320         // seizeSupplyAmount_TargetCollateralAsset = closeBorrowAmount_TargetUnderwaterAsset * priceBorrow/priceCollateral *(1+liquidationDiscount)
2321         (err, localResults.seizeSupplyAmount_TargetCollateralAsset) = calculateAmountSeize(localResults.underwaterAssetPrice, localResults.collateralPrice, localResults.closeBorrowAmount_TargetUnderwaterAsset);
2322         if (err != Error.NO_ERROR) {
2323             return fail(err, FailureInfo.LIQUIDATE_AMOUNT_SEIZE_CALCULATION_FAILED);
2324         }
2325 
2326         // We are going to ERC-20 transfer closeBorrowAmount_TargetUnderwaterAsset of assetBorrow into Lendf.Me
2327         // Fail gracefully if asset is not approved or has insufficient balance
2328         err = checkTransferIn(assetBorrow, localResults.liquidator, localResults.closeBorrowAmount_TargetUnderwaterAsset);
2329         if (err != Error.NO_ERROR) {
2330             return fail(err, FailureInfo.LIQUIDATE_TRANSFER_IN_NOT_POSSIBLE);
2331         }
2332 
2333         // We are going to repay the target user's borrow using the calling user's funds
2334         // We update the protocol's totalBorrow for assetBorrow, by subtracting the target user's prior checkpointed balance,
2335         // adding borrowCurrent, and subtracting closeBorrowAmount_TargetUnderwaterAsset.
2336 
2337         // Subtract the `closeBorrowAmount_TargetUnderwaterAsset` from the `currentBorrowBalance_TargetUnderwaterAsset` to get `updatedBorrowBalance_TargetUnderwaterAsset`
2338         (err, localResults.updatedBorrowBalance_TargetUnderwaterAsset) = sub(localResults.currentBorrowBalance_TargetUnderwaterAsset, localResults.closeBorrowAmount_TargetUnderwaterAsset);
2339         // We have ensured above that localResults.closeBorrowAmount_TargetUnderwaterAsset <= localResults.currentBorrowBalance_TargetUnderwaterAsset, so the sub can't underflow
2340         assert(err == Error.NO_ERROR);
2341 
2342         // We calculate the protocol's totalBorrow for assetBorrow by subtracting the user's prior checkpointed balance, adding user's updated borrow
2343         // Note that, even though the liquidator is paying some of the borrow, if the borrow has accumulated a lot of interest since the last
2344         // action, the updated balance *could* be higher than the prior checkpointed balance.
2345         (err, localResults.newTotalBorrows_ProtocolUnderwaterAsset) = addThenSub(borrowMarket.totalBorrows, localResults.updatedBorrowBalance_TargetUnderwaterAsset, borrowBalance_TargeUnderwaterAsset.principal);
2346         if (err != Error.NO_ERROR) {
2347             return fail(err, FailureInfo.LIQUIDATE_NEW_TOTAL_BORROW_CALCULATION_FAILED_BORROWED_ASSET);
2348         }
2349 
2350         // We need to calculate what the updated cash will be after we transfer in from liquidator
2351         localResults.currentCash_ProtocolUnderwaterAsset = getCash(assetBorrow);
2352         (err, localResults.updatedCash_ProtocolUnderwaterAsset) = add(localResults.currentCash_ProtocolUnderwaterAsset, localResults.closeBorrowAmount_TargetUnderwaterAsset);
2353         if (err != Error.NO_ERROR) {
2354             return fail(err, FailureInfo.LIQUIDATE_NEW_TOTAL_CASH_CALCULATION_FAILED_BORROWED_ASSET);
2355         }
2356 
2357         // The utilization rate has changed! We calculate a new supply index, borrow index, supply rate, and borrow rate for assetBorrow
2358         // (Please note that we don't need to do the same thing for assetCollateral because neither cash nor borrows of assetCollateral happen in this process.)
2359 
2360         // We calculate the newSupplyIndex_UnderwaterAsset, but we already have newBorrowIndex_UnderwaterAsset so don't recalculate it.
2361         (err, localResults.newSupplyIndex_UnderwaterAsset) = calculateInterestIndex(borrowMarket.supplyIndex, borrowMarket.supplyRateMantissa, borrowMarket.blockNumber, getBlockNumber());
2362         if (err != Error.NO_ERROR) {
2363             return fail(err, FailureInfo.LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_BORROWED_ASSET);
2364         }
2365 
2366         (rateCalculationResultCode, localResults.newSupplyRateMantissa_ProtocolUnderwaterAsset) = borrowMarket.interestRateModel.getSupplyRate(assetBorrow, localResults.updatedCash_ProtocolUnderwaterAsset, localResults.newTotalBorrows_ProtocolUnderwaterAsset);
2367         if (rateCalculationResultCode != 0) {
2368             return failOpaque(FailureInfo.LIQUIDATE_NEW_SUPPLY_RATE_CALCULATION_FAILED_BORROWED_ASSET, rateCalculationResultCode);
2369         }
2370 
2371         (rateCalculationResultCode, localResults.newBorrowRateMantissa_ProtocolUnderwaterAsset) = borrowMarket.interestRateModel.getBorrowRate(assetBorrow, localResults.updatedCash_ProtocolUnderwaterAsset, localResults.newTotalBorrows_ProtocolUnderwaterAsset);
2372         if (rateCalculationResultCode != 0) {
2373             return failOpaque(FailureInfo.LIQUIDATE_NEW_BORROW_RATE_CALCULATION_FAILED_BORROWED_ASSET, rateCalculationResultCode);
2374         }
2375 
2376         // Now we look at collateral. We calculated target user's accumulated supply balance and the supply index above.
2377         // Now we need to calculate the borrow index.
2378         // We don't need to calculate new rates for the collateral asset because we have not changed utilization:
2379         //  - accumulating interest on the target user's collateral does not change cash or borrows
2380         //  - transferring seized amount of collateral internally from the target user to the liquidator does not change cash or borrows.
2381         (err, localResults.newBorrowIndex_CollateralAsset) = calculateInterestIndex(collateralMarket.borrowIndex, collateralMarket.borrowRateMantissa, collateralMarket.blockNumber, getBlockNumber());
2382         if (err != Error.NO_ERROR) {
2383             return fail(err, FailureInfo.LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET);
2384         }
2385 
2386         // We checkpoint the target user's assetCollateral supply balance, supplyCurrent - seizeSupplyAmount_TargetCollateralAsset at the updated index
2387         (err, localResults.updatedSupplyBalance_TargetCollateralAsset) = sub(localResults.currentSupplyBalance_TargetCollateralAsset, localResults.seizeSupplyAmount_TargetCollateralAsset);
2388         // The sub won't underflow because because seizeSupplyAmount_TargetCollateralAsset <= target user's collateral balance
2389         // maxCloseableBorrowAmount_TargetUnderwaterAsset is limited by the discounted borrow denominated collateral. That limits closeBorrowAmount_TargetUnderwaterAsset
2390         // which in turn limits seizeSupplyAmount_TargetCollateralAsset.
2391         assert (err == Error.NO_ERROR);
2392 
2393         // We checkpoint the liquidating user's assetCollateral supply balance, supplyCurrent + seizeSupplyAmount_TargetCollateralAsset at the updated index
2394         (err, localResults.updatedSupplyBalance_LiquidatorCollateralAsset) = add(localResults.currentSupplyBalance_LiquidatorCollateralAsset, localResults.seizeSupplyAmount_TargetCollateralAsset);
2395         // We can't overflow here because if this would overflow, then we would have already overflowed above and failed
2396         // with LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET
2397         assert (err == Error.NO_ERROR);
2398 
2399         /////////////////////////
2400         // EFFECTS & INTERACTIONS
2401         // (No safe failures beyond this point)
2402 
2403         // We ERC-20 transfer the asset into the protocol (note: pre-conditions already checked above)
2404         err = doTransferIn(assetBorrow, localResults.liquidator, localResults.closeBorrowAmount_TargetUnderwaterAsset);
2405         if (err != Error.NO_ERROR) {
2406             // This is safe since it's our first interaction and it didn't do anything if it failed
2407             return fail(err, FailureInfo.LIQUIDATE_TRANSFER_IN_FAILED);
2408         }
2409 
2410         // Save borrow market updates
2411         borrowMarket.blockNumber = getBlockNumber();
2412         borrowMarket.totalBorrows = localResults.newTotalBorrows_ProtocolUnderwaterAsset;
2413         // borrowMarket.totalSupply does not need to be updated
2414         borrowMarket.supplyRateMantissa = localResults.newSupplyRateMantissa_ProtocolUnderwaterAsset;
2415         borrowMarket.supplyIndex = localResults.newSupplyIndex_UnderwaterAsset;
2416         borrowMarket.borrowRateMantissa = localResults.newBorrowRateMantissa_ProtocolUnderwaterAsset;
2417         borrowMarket.borrowIndex = localResults.newBorrowIndex_UnderwaterAsset;
2418 
2419         // Save collateral market updates
2420         // We didn't calculate new rates for collateralMarket (because neither cash nor borrows changed), just new indexes and total supply.
2421         collateralMarket.blockNumber = getBlockNumber();
2422         collateralMarket.totalSupply = localResults.newTotalSupply_ProtocolCollateralAsset;
2423         collateralMarket.supplyIndex = localResults.newSupplyIndex_CollateralAsset;
2424         collateralMarket.borrowIndex = localResults.newBorrowIndex_CollateralAsset;
2425 
2426         // Save user updates
2427 
2428         localResults.startingBorrowBalance_TargetUnderwaterAsset = borrowBalance_TargeUnderwaterAsset.principal; // save for use in event
2429         borrowBalance_TargeUnderwaterAsset.principal = localResults.updatedBorrowBalance_TargetUnderwaterAsset;
2430         borrowBalance_TargeUnderwaterAsset.interestIndex = localResults.newBorrowIndex_UnderwaterAsset;
2431 
2432         localResults.startingSupplyBalance_TargetCollateralAsset = supplyBalance_TargetCollateralAsset.principal; // save for use in event
2433         supplyBalance_TargetCollateralAsset.principal = localResults.updatedSupplyBalance_TargetCollateralAsset;
2434         supplyBalance_TargetCollateralAsset.interestIndex = localResults.newSupplyIndex_CollateralAsset;
2435 
2436         localResults.startingSupplyBalance_LiquidatorCollateralAsset = supplyBalance_LiquidatorCollateralAsset.principal; // save for use in event
2437         supplyBalance_LiquidatorCollateralAsset.principal = localResults.updatedSupplyBalance_LiquidatorCollateralAsset;
2438         supplyBalance_LiquidatorCollateralAsset.interestIndex = localResults.newSupplyIndex_CollateralAsset;
2439 
2440         emitLiquidationEvent(localResults);
2441 
2442         return uint(Error.NO_ERROR); // success
2443     }
2444 
2445     /**
2446       * @dev this function exists to avoid error `CompilerError: Stack too deep, try removing local variables.` in `liquidateBorrow`
2447       */
2448     function emitLiquidationEvent(LiquidateLocalVars memory localResults) internal {
2449         // event BorrowLiquidated(address targetAccount, address assetBorrow, uint borrowBalanceBefore, uint borrowBalanceAccumulated, uint amountRepaid, uint borrowBalanceAfter,
2450         // address liquidator, address assetCollateral, uint collateralBalanceBefore, uint collateralBalanceAccumulated, uint amountSeized, uint collateralBalanceAfter);
2451         emit BorrowLiquidated(localResults.targetAccount,
2452             localResults.assetBorrow,
2453             localResults.startingBorrowBalance_TargetUnderwaterAsset,
2454             localResults.currentBorrowBalance_TargetUnderwaterAsset,
2455             localResults.closeBorrowAmount_TargetUnderwaterAsset,
2456             localResults.updatedBorrowBalance_TargetUnderwaterAsset,
2457             localResults.liquidator,
2458             localResults.assetCollateral,
2459             localResults.startingSupplyBalance_TargetCollateralAsset,
2460             localResults.currentSupplyBalance_TargetCollateralAsset,
2461             localResults.seizeSupplyAmount_TargetCollateralAsset,
2462             localResults.updatedSupplyBalance_TargetCollateralAsset);
2463     }
2464 
2465     /**
2466       * @dev This should ONLY be called if market is supported. It returns shortfall / [Oracle price for the borrow * (collateralRatio - liquidationDiscount - 1)]
2467       *      If the market isn't supported, we support liquidation of asset regardless of shortfall because we want borrows of the unsupported asset to be closed.
2468       *      Note that if collateralRatio = liquidationDiscount + 1, then the denominator will be zero and the function will fail with DIVISION_BY_ZERO.
2469       **/
2470     function calculateDiscountedRepayToEvenAmount(address targetAccount, Exp memory underwaterAssetPrice) internal view returns (Error, uint) {
2471         Error err;
2472         Exp memory _accountLiquidity; // unused return value from calculateAccountLiquidity
2473         Exp memory accountShortfall_TargetUser;
2474         Exp memory collateralRatioMinusLiquidationDiscount; // collateralRatio - liquidationDiscount
2475         Exp memory discountedCollateralRatioMinusOne; // collateralRatioMinusLiquidationDiscount - 1, aka collateralRatio - liquidationDiscount - 1
2476         Exp memory discountedPrice_UnderwaterAsset;
2477         Exp memory rawResult;
2478 
2479         // we calculate the target user's shortfall, denominated in Ether, that the user is below the collateral ratio
2480         (err, _accountLiquidity, accountShortfall_TargetUser) = calculateAccountLiquidity(targetAccount);
2481         if (err != Error.NO_ERROR) {
2482             return (err, 0);
2483         }
2484 
2485         (err, collateralRatioMinusLiquidationDiscount) = subExp(collateralRatio, liquidationDiscount);
2486         if (err != Error.NO_ERROR) {
2487             return (err, 0);
2488         }
2489 
2490         (err, discountedCollateralRatioMinusOne) = subExp(collateralRatioMinusLiquidationDiscount, Exp({mantissa: mantissaOne}));
2491         if (err != Error.NO_ERROR) {
2492             return (err, 0);
2493         }
2494 
2495         (err, discountedPrice_UnderwaterAsset) = mulExp(underwaterAssetPrice, discountedCollateralRatioMinusOne);
2496         // calculateAccountLiquidity multiplies underwaterAssetPrice by collateralRatio
2497         // discountedCollateralRatioMinusOne < collateralRatio
2498         // so if underwaterAssetPrice * collateralRatio did not overflow then
2499         // underwaterAssetPrice * discountedCollateralRatioMinusOne can't overflow either
2500         assert(err == Error.NO_ERROR);
2501 
2502         (err, rawResult) = divExp(accountShortfall_TargetUser, discountedPrice_UnderwaterAsset);
2503         // It's theoretically possible an asset could have such a low price that it truncates to zero when discounted.
2504         if (err != Error.NO_ERROR) {
2505             return (err, 0);
2506         }
2507 
2508         return (Error.NO_ERROR, truncate(rawResult));
2509     }
2510 
2511     /**
2512       * @dev discountedBorrowDenominatedCollateral = [supplyCurrent / (1 + liquidationDiscount)] * (Oracle price for the collateral / Oracle price for the borrow)
2513       */
2514     function calculateDiscountedBorrowDenominatedCollateral(Exp memory underwaterAssetPrice, Exp memory collateralPrice, uint supplyCurrent_TargetCollateralAsset) view internal returns (Error, uint) {
2515         // To avoid rounding issues, we re-order and group the operations so we do 1 division and only at the end
2516         // [supplyCurrent * (Oracle price for the collateral)] / [ (1 + liquidationDiscount) * (Oracle price for the borrow) ]
2517         Error err;
2518         Exp memory onePlusLiquidationDiscount; // (1 + liquidationDiscount)
2519         Exp memory supplyCurrentTimesOracleCollateral; // supplyCurrent * Oracle price for the collateral
2520         Exp memory onePlusLiquidationDiscountTimesOracleBorrow; // (1 + liquidationDiscount) * Oracle price for the borrow
2521         Exp memory rawResult;
2522 
2523         (err, onePlusLiquidationDiscount) = addExp(Exp({mantissa: mantissaOne}), liquidationDiscount);
2524         if (err != Error.NO_ERROR) {
2525             return (err, 0);
2526         }
2527 
2528         (err, supplyCurrentTimesOracleCollateral) = mulScalar(collateralPrice, supplyCurrent_TargetCollateralAsset);
2529         if (err != Error.NO_ERROR) {
2530             return (err, 0);
2531         }
2532 
2533         (err, onePlusLiquidationDiscountTimesOracleBorrow) = mulExp(onePlusLiquidationDiscount, underwaterAssetPrice);
2534         if (err != Error.NO_ERROR) {
2535             return (err, 0);
2536         }
2537 
2538         (err, rawResult) = divExp(supplyCurrentTimesOracleCollateral, onePlusLiquidationDiscountTimesOracleBorrow);
2539         if (err != Error.NO_ERROR) {
2540             return (err, 0);
2541         }
2542 
2543         return (Error.NO_ERROR, truncate(rawResult));
2544     }
2545 
2546 
2547     /**
2548       * @dev returns closeBorrowAmount_TargetUnderwaterAsset * (1+liquidationDiscount) * priceBorrow/priceCollateral
2549       **/
2550     function calculateAmountSeize(Exp memory underwaterAssetPrice, Exp memory collateralPrice, uint closeBorrowAmount_TargetUnderwaterAsset) internal view returns (Error, uint) {
2551         // To avoid rounding issues, we re-order and group the operations to move the division to the end, rather than just taking the ratio of the 2 prices:
2552         // underwaterAssetPrice * (1+liquidationDiscount) *closeBorrowAmount_TargetUnderwaterAsset) / collateralPrice
2553 
2554         // re-used for all intermediate errors
2555         Error err;
2556 
2557         // (1+liquidationDiscount)
2558         Exp memory liquidationMultiplier;
2559 
2560         // assetPrice-of-underwaterAsset * (1+liquidationDiscount)
2561         Exp memory priceUnderwaterAssetTimesLiquidationMultiplier;
2562 
2563         // priceUnderwaterAssetTimesLiquidationMultiplier * closeBorrowAmount_TargetUnderwaterAsset
2564         // or, expanded:
2565         // underwaterAssetPrice * (1+liquidationDiscount) * closeBorrowAmount_TargetUnderwaterAsset
2566         Exp memory finalNumerator;
2567 
2568         // finalNumerator / priceCollateral
2569         Exp memory rawResult;
2570 
2571         (err, liquidationMultiplier) = addExp(Exp({mantissa: mantissaOne}), liquidationDiscount);
2572         // liquidation discount will be enforced < 1, so 1 + liquidationDiscount can't overflow.
2573         assert(err == Error.NO_ERROR);
2574 
2575         (err, priceUnderwaterAssetTimesLiquidationMultiplier) = mulExp(underwaterAssetPrice, liquidationMultiplier);
2576         if (err != Error.NO_ERROR) {
2577             return (err, 0);
2578         }
2579 
2580         (err, finalNumerator) = mulScalar(priceUnderwaterAssetTimesLiquidationMultiplier, closeBorrowAmount_TargetUnderwaterAsset);
2581         if (err != Error.NO_ERROR) {
2582             return (err, 0);
2583         }
2584 
2585         (err, rawResult) = divExp(finalNumerator, collateralPrice);
2586         if (err != Error.NO_ERROR) {
2587             return (err, 0);
2588         }
2589 
2590         return (Error.NO_ERROR, truncate(rawResult));
2591     }
2592 
2593 
2594     /**
2595       * @notice Users borrow assets from the protocol to their own address
2596       * @param asset The market asset to borrow
2597       * @param amount The amount to borrow
2598       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2599       */
2600     function borrow(address asset, uint amount) public returns (uint) {
2601         if (paused) {
2602             return fail(Error.CONTRACT_PAUSED, FailureInfo.BORROW_CONTRACT_PAUSED);
2603         }
2604         BorrowLocalVars memory localResults;
2605         Market storage market = markets[asset];
2606         Balance storage borrowBalance = borrowBalances[msg.sender][asset];
2607 
2608         Error err;
2609         uint rateCalculationResultCode;
2610 
2611         // Fail if market not supported
2612         if (!market.isSupported) {
2613             return fail(Error.MARKET_NOT_SUPPORTED, FailureInfo.BORROW_MARKET_NOT_SUPPORTED);
2614         }
2615 
2616         // We calculate the newBorrowIndex, user's borrowCurrent and borrowUpdated for the asset
2617         (err, localResults.newBorrowIndex) = calculateInterestIndex(market.borrowIndex, market.borrowRateMantissa, market.blockNumber, getBlockNumber());
2618         if (err != Error.NO_ERROR) {
2619             return fail(err, FailureInfo.BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED);
2620         }
2621 
2622         (err, localResults.userBorrowCurrent) = calculateBalance(borrowBalance.principal, borrowBalance.interestIndex, localResults.newBorrowIndex);
2623         if (err != Error.NO_ERROR) {
2624             return fail(err, FailureInfo.BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED); // failing here not where desired (which is below)
2625         }
2626 
2627         // Calculate origination fee.
2628         (err, localResults.borrowAmountWithFee) = calculateBorrowAmountWithFee(amount);
2629         if (err != Error.NO_ERROR) {
2630             return fail(err, FailureInfo.BORROW_ORIGINATION_FEE_CALCULATION_FAILED);
2631         }
2632 
2633         // Add the `borrowAmountWithFee` to the `userBorrowCurrent` to get `userBorrowUpdated`
2634         (err, localResults.userBorrowUpdated) = add(localResults.userBorrowCurrent, localResults.borrowAmountWithFee);
2635         if (err != Error.NO_ERROR) {
2636             return fail(err, FailureInfo.BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED); // now failing here
2637         }
2638 
2639         // We calculate the protocol's totalBorrow by subtracting the user's prior checkpointed balance, adding user's updated borrow with fee
2640         (err, localResults.newTotalBorrows) = addThenSub(market.totalBorrows, localResults.userBorrowUpdated, borrowBalance.principal);
2641         if (err != Error.NO_ERROR) {
2642             return fail(err, FailureInfo.BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED); // want this one
2643         }
2644 
2645         // Check customer liquidity
2646         (err, localResults.accountLiquidity, localResults.accountShortfall) = calculateAccountLiquidity(msg.sender);
2647         if (err != Error.NO_ERROR) {
2648             return fail(err, FailureInfo.BORROW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED);
2649         }
2650 
2651         // Fail if customer already has a shortfall
2652         if (!isZeroExp(localResults.accountShortfall)) {
2653             return fail(Error.INSUFFICIENT_LIQUIDITY, FailureInfo.BORROW_ACCOUNT_SHORTFALL_PRESENT);
2654         }
2655 
2656         // Would the customer have a shortfall after this borrow (including origination fee)?
2657         // We calculate the eth-equivalent value of (borrow amount + fee) of asset and fail if it exceeds accountLiquidity.
2658         // This implements: `[(collateralRatio*oraclea*borrowAmount)*(1+borrowFee)] > accountLiquidity`
2659         (err, localResults.ethValueOfBorrowAmountWithFee) = getPriceForAssetAmountMulCollatRatio(asset, localResults.borrowAmountWithFee);
2660         if (err != Error.NO_ERROR) {
2661             return fail(err, FailureInfo.BORROW_AMOUNT_VALUE_CALCULATION_FAILED);
2662         }
2663         if (lessThanExp(localResults.accountLiquidity, localResults.ethValueOfBorrowAmountWithFee)) {
2664             return fail(Error.INSUFFICIENT_LIQUIDITY, FailureInfo.BORROW_AMOUNT_LIQUIDITY_SHORTFALL);
2665         }
2666 
2667         // Fail gracefully if protocol has insufficient cash
2668         localResults.currentCash = getCash(asset);
2669         // We need to calculate what the updated cash will be after we transfer out to the user
2670         (err, localResults.updatedCash) = sub(localResults.currentCash, amount);
2671         if (err != Error.NO_ERROR) {
2672             // Note: we ignore error here and call this token insufficient cash
2673             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED);
2674         }
2675 
2676         // The utilization rate has changed! We calculate a new supply index and borrow index for the asset, and save it.
2677 
2678         // We calculate the newSupplyIndex, but we have newBorrowIndex already
2679         (err, localResults.newSupplyIndex) = calculateInterestIndex(market.supplyIndex, market.supplyRateMantissa, market.blockNumber, getBlockNumber());
2680         if (err != Error.NO_ERROR) {
2681             return fail(err, FailureInfo.BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED);
2682         }
2683 
2684         (rateCalculationResultCode, localResults.newSupplyRateMantissa) = market.interestRateModel.getSupplyRate(asset, localResults.updatedCash, localResults.newTotalBorrows);
2685         if (rateCalculationResultCode != 0) {
2686             return failOpaque(FailureInfo.BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED, rateCalculationResultCode);
2687         }
2688 
2689         (rateCalculationResultCode, localResults.newBorrowRateMantissa) = market.interestRateModel.getBorrowRate(asset, localResults.updatedCash, localResults.newTotalBorrows);
2690         if (rateCalculationResultCode != 0) {
2691             return failOpaque(FailureInfo.BORROW_NEW_BORROW_RATE_CALCULATION_FAILED, rateCalculationResultCode);
2692         }
2693 
2694         /////////////////////////
2695         // EFFECTS & INTERACTIONS
2696         // (No safe failures beyond this point)
2697 
2698         // We ERC-20 transfer the asset into the protocol (note: pre-conditions already checked above)
2699         err = doTransferOut(asset, msg.sender, amount);
2700         if (err != Error.NO_ERROR) {
2701             // This is safe since it's our first interaction and it didn't do anything if it failed
2702             return fail(err, FailureInfo.BORROW_TRANSFER_OUT_FAILED);
2703         }
2704 
2705         // Save market updates
2706         market.blockNumber = getBlockNumber();
2707         market.totalBorrows =  localResults.newTotalBorrows;
2708         market.supplyRateMantissa = localResults.newSupplyRateMantissa;
2709         market.supplyIndex = localResults.newSupplyIndex;
2710         market.borrowRateMantissa = localResults.newBorrowRateMantissa;
2711         market.borrowIndex = localResults.newBorrowIndex;
2712 
2713         // Save user updates
2714         localResults.startingBalance = borrowBalance.principal; // save for use in `BorrowTaken` event
2715         borrowBalance.principal = localResults.userBorrowUpdated;
2716         borrowBalance.interestIndex = localResults.newBorrowIndex;
2717 
2718         emit BorrowTaken(msg.sender, asset, amount, localResults.startingBalance, localResults.borrowAmountWithFee, localResults.userBorrowUpdated);
2719 
2720         return uint(Error.NO_ERROR); // success
2721     }
2722 }
2723 contract LiquidationChecker {
2724     MoneyMarket public moneyMarket;
2725     address public liquidator;
2726     bool public allowLiquidation;
2727 
2728     constructor(address moneyMarket_, address liquidator_) public {
2729         moneyMarket = MoneyMarket(moneyMarket_);
2730         liquidator = liquidator_;
2731         allowLiquidation = false;
2732     }
2733 
2734     function isAllowed(address asset, uint newCash) internal returns(bool) {
2735         return allowLiquidation || !isLiquidate(asset, newCash);
2736     }
2737 
2738     function isLiquidate(address asset, uint newCash) internal returns(bool) {
2739         return cashIsUp(asset, newCash) && oracleTouched();
2740     }
2741 
2742     function cashIsUp(address asset, uint newCash) internal view returns(bool) {
2743         uint oldCash = EIP20Interface(asset).balanceOf(moneyMarket);
2744 
2745         return newCash >= oldCash;
2746     }
2747 
2748     function oracleTouched() internal returns(bool) {
2749         PriceOracleProxy oracle = PriceOracleProxy(moneyMarket.oracle());
2750 
2751         bool sameOrigin = oracle.mostRecentCaller() == tx.origin;
2752         bool sameBlock = oracle.mostRecentBlock() == block.number;
2753 
2754         return sameOrigin && sameBlock;
2755     }
2756 
2757     function setAllowLiquidation(bool allowLiquidation_) public {
2758         require(msg.sender == liquidator, "LIQUIDATION_CHECKER_INVALID_LIQUIDATOR");
2759 
2760         allowLiquidation = allowLiquidation_;
2761     }
2762 }
2763 contract Liquidator is ErrorReporter, SafeToken {
2764 
2765     MoneyMarket public moneyMarket;
2766 
2767     constructor(address moneyMarket_) public {
2768         moneyMarket = MoneyMarket(moneyMarket_);
2769     }
2770 
2771     event BorrowLiquidated(address targetAccount,
2772         address assetBorrow,
2773         uint borrowBalanceBefore,
2774         uint borrowBalanceAccumulated,
2775         uint amountRepaid,
2776         uint borrowBalanceAfter,
2777         address liquidator,
2778         address assetCollateral,
2779         uint collateralBalanceBefore,
2780         uint collateralBalanceAccumulated,
2781         uint amountSeized,
2782         uint collateralBalanceAfter);
2783 
2784     function liquidateBorrow(address targetAccount, address assetBorrow, address assetCollateral, uint requestedAmountClose) public returns (uint) {
2785         require(targetAccount != address(this), "FAILED_LIQUIDATE_LIQUIDATOR");
2786         require(targetAccount != msg.sender, "FAILED_LIQUIDATE_SELF");
2787         require(msg.sender != address(this), "FAILED_LIQUIDATE_RECURSIVE");
2788         require(assetBorrow != assetCollateral, "FAILED_LIQUIDATE_IN_KIND");
2789 
2790         InterestRateModel interestRateModel;
2791         (,,interestRateModel,,,,,,) = moneyMarket.markets(assetBorrow);
2792 
2793         require(interestRateModel != address(0), "FAILED_LIQUIDATE_NO_INTEREST_RATE_MODEL");
2794         require(checkTransferIn(assetBorrow, msg.sender, requestedAmountClose) == Error.NO_ERROR, "FAILED_LIQUIDATE_TRANSFER_IN_INVALID");
2795 
2796         require(doTransferIn(assetBorrow, msg.sender, requestedAmountClose) == Error.NO_ERROR, "FAILED_LIQUIDATE_TRANSFER_IN_FAILED");
2797 
2798         tokenAllowAll(assetBorrow, moneyMarket);
2799 
2800         LiquidationChecker(interestRateModel).setAllowLiquidation(true);
2801 
2802         uint result = moneyMarket.liquidateBorrow(targetAccount, assetBorrow, assetCollateral, requestedAmountClose);
2803 
2804         require(moneyMarket.withdraw(assetCollateral, uint(-1)) == uint(Error.NO_ERROR), "FAILED_LIQUIDATE_WITHDRAW_FAILED");
2805 
2806         LiquidationChecker(interestRateModel).setAllowLiquidation(false);
2807 
2808         // Ensure there's no remaining balances here
2809         require(moneyMarket.getSupplyBalance(address(this), assetCollateral) == 0, "FAILED_LIQUIDATE_REMAINING_SUPPLY_COLLATERAL"); // just to be sure
2810         require(moneyMarket.getSupplyBalance(address(this), assetBorrow) == 0, "FAILED_LIQUIDATE_REMAINING_SUPPLY_BORROW"); // just to be sure
2811         require(moneyMarket.getBorrowBalance(address(this), assetCollateral) == 0, "FAILED_LIQUIDATE_REMAINING_BORROW_COLLATERAL"); // just to be sure
2812         require(moneyMarket.getBorrowBalance(address(this), assetBorrow) == 0, "FAILED_LIQUIDATE_REMAINING_BORROW_BORROW"); // just to be sure
2813 
2814         // Transfer out everything remaining
2815         tokenTransferAll(assetCollateral, msg.sender);
2816         tokenTransferAll(assetBorrow, msg.sender);
2817 
2818         return uint(result);
2819     }
2820 
2821     function tokenAllowAll(address asset, address allowee) internal {
2822         EIP20Interface token = EIP20Interface(asset);
2823 
2824         if (token.allowance(address(this), allowee) != uint(-1))
2825             // require(token.approve(allowee, uint(-1)), "FAILED_LIQUIDATE_ASSET_ALLOWANCE_FAILED");
2826             require(doApprove(asset, allowee, uint(-1)) == Error.NO_ERROR, "FAILED_LIQUIDATE_ASSET_ALLOWANCE_FAILED");
2827     }
2828 
2829     function tokenTransferAll(address asset, address recipient) internal {
2830         uint balance = getBalanceOf(asset, address(this));
2831 
2832         if (balance > 0){
2833             require(doTransferOut(asset, recipient, balance) == Error.NO_ERROR, "FAILED_LIQUIDATE_TRANSFER_OUT_FAILED");
2834         }
2835     }
2836 }