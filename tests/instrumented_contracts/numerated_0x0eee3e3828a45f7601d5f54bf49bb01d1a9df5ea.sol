1 pragma solidity ^0.4.24;
2 contract PriceOracleInterface {
3 
4     /**
5       * @notice Gets the price of a given asset
6       * @dev fetches the price of a given asset
7       * @param asset Asset to get the price of
8       * @return the price scaled by 10**18, or zero if the price is not available
9       */
10     function assetPrices(address asset) public view returns (uint);
11 }
12 contract ErrorReporter {
13 
14     /**
15       * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
16       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
17       **/
18     event Failure(uint error, uint info, uint detail);
19 
20     enum Error {
21         NO_ERROR,
22         OPAQUE_ERROR, // To be used when reporting errors from upgradeable contracts; the opaque code should be given as `detail` in the `Failure` event
23         UNAUTHORIZED,
24         INTEGER_OVERFLOW,
25         INTEGER_UNDERFLOW,
26         DIVISION_BY_ZERO,
27         BAD_INPUT,
28         TOKEN_INSUFFICIENT_ALLOWANCE,
29         TOKEN_INSUFFICIENT_BALANCE,
30         TOKEN_TRANSFER_FAILED,
31         MARKET_NOT_SUPPORTED,
32         SUPPLY_RATE_CALCULATION_FAILED,
33         BORROW_RATE_CALCULATION_FAILED,
34         TOKEN_INSUFFICIENT_CASH,
35         TOKEN_TRANSFER_OUT_FAILED,
36         INSUFFICIENT_LIQUIDITY,
37         INSUFFICIENT_BALANCE,
38         INVALID_COLLATERAL_RATIO,
39         MISSING_ASSET_PRICE,
40         EQUITY_INSUFFICIENT_BALANCE,
41         INVALID_CLOSE_AMOUNT_REQUESTED,
42         ASSET_NOT_PRICED,
43         INVALID_LIQUIDATION_DISCOUNT,
44         INVALID_COMBINED_RISK_PARAMETERS,
45         ZERO_ORACLE_ADDRESS,
46         CONTRACT_PAUSED
47     }
48 
49     /*
50      * Note: FailureInfo (but not Error) is kept in alphabetical order
51      *       This is because FailureInfo grows significantly faster, and
52      *       the order of Error has some meaning, while the order of FailureInfo
53      *       is entirely arbitrary.
54      */
55     enum FailureInfo {
56         ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
57         BORROW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED,
58         BORROW_ACCOUNT_SHORTFALL_PRESENT,
59         BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
60         BORROW_AMOUNT_LIQUIDITY_SHORTFALL,
61         BORROW_AMOUNT_VALUE_CALCULATION_FAILED,
62         BORROW_CONTRACT_PAUSED,
63         BORROW_MARKET_NOT_SUPPORTED,
64         BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED,
65         BORROW_NEW_BORROW_RATE_CALCULATION_FAILED,
66         BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
67         BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
68         BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
69         BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED,
70         BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED,
71         BORROW_ORIGINATION_FEE_CALCULATION_FAILED,
72         BORROW_TRANSFER_OUT_FAILED,
73         EQUITY_WITHDRAWAL_AMOUNT_VALIDATION,
74         EQUITY_WITHDRAWAL_CALCULATE_EQUITY,
75         EQUITY_WITHDRAWAL_MODEL_OWNER_CHECK,
76         EQUITY_WITHDRAWAL_TRANSFER_OUT_FAILED,
77         LIQUIDATE_ACCUMULATED_BORROW_BALANCE_CALCULATION_FAILED,
78         LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET,
79         LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET,
80         LIQUIDATE_AMOUNT_SEIZE_CALCULATION_FAILED,
81         LIQUIDATE_BORROW_DENOMINATED_COLLATERAL_CALCULATION_FAILED,
82         LIQUIDATE_CLOSE_AMOUNT_TOO_HIGH,
83         LIQUIDATE_CONTRACT_PAUSED,
84         LIQUIDATE_DISCOUNTED_REPAY_TO_EVEN_AMOUNT_CALCULATION_FAILED,
85         LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_BORROWED_ASSET,
86         LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET,
87         LIQUIDATE_NEW_BORROW_RATE_CALCULATION_FAILED_BORROWED_ASSET,
88         LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_BORROWED_ASSET,
89         LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET,
90         LIQUIDATE_NEW_SUPPLY_RATE_CALCULATION_FAILED_BORROWED_ASSET,
91         LIQUIDATE_NEW_TOTAL_BORROW_CALCULATION_FAILED_BORROWED_ASSET,
92         LIQUIDATE_NEW_TOTAL_CASH_CALCULATION_FAILED_BORROWED_ASSET,
93         LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET,
94         LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET,
95         LIQUIDATE_FETCH_ASSET_PRICE_FAILED,
96         LIQUIDATE_TRANSFER_IN_FAILED,
97         LIQUIDATE_TRANSFER_IN_NOT_POSSIBLE,
98         REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
99         REPAY_BORROW_CONTRACT_PAUSED,
100         REPAY_BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED,
101         REPAY_BORROW_NEW_BORROW_RATE_CALCULATION_FAILED,
102         REPAY_BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
103         REPAY_BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
104         REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
105         REPAY_BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED,
106         REPAY_BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED,
107         REPAY_BORROW_TRANSFER_IN_FAILED,
108         REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE,
109         SET_ASSET_PRICE_CHECK_ORACLE,
110         SET_MARKET_INTEREST_RATE_MODEL_OWNER_CHECK,
111         SET_ORACLE_OWNER_CHECK,
112         SET_ORIGINATION_FEE_OWNER_CHECK,
113         SET_PAUSED_OWNER_CHECK,
114         SET_PENDING_ADMIN_OWNER_CHECK,
115         SET_RISK_PARAMETERS_OWNER_CHECK,
116         SET_RISK_PARAMETERS_VALIDATION,
117         SUPPLY_ACCUMULATED_BALANCE_CALCULATION_FAILED,
118         SUPPLY_CONTRACT_PAUSED,
119         SUPPLY_MARKET_NOT_SUPPORTED,
120         SUPPLY_NEW_BORROW_INDEX_CALCULATION_FAILED,
121         SUPPLY_NEW_BORROW_RATE_CALCULATION_FAILED,
122         SUPPLY_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
123         SUPPLY_NEW_SUPPLY_RATE_CALCULATION_FAILED,
124         SUPPLY_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
125         SUPPLY_NEW_TOTAL_CASH_CALCULATION_FAILED,
126         SUPPLY_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
127         SUPPLY_TRANSFER_IN_FAILED,
128         SUPPLY_TRANSFER_IN_NOT_POSSIBLE,
129         SUPPORT_MARKET_FETCH_PRICE_FAILED,
130         SUPPORT_MARKET_OWNER_CHECK,
131         SUPPORT_MARKET_PRICE_CHECK,
132         SUSPEND_MARKET_OWNER_CHECK,
133         WITHDRAW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED,
134         WITHDRAW_ACCOUNT_SHORTFALL_PRESENT,
135         WITHDRAW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
136         WITHDRAW_AMOUNT_LIQUIDITY_SHORTFALL,
137         WITHDRAW_AMOUNT_VALUE_CALCULATION_FAILED,
138         WITHDRAW_CAPACITY_CALCULATION_FAILED,
139         WITHDRAW_CONTRACT_PAUSED,
140         WITHDRAW_NEW_BORROW_INDEX_CALCULATION_FAILED,
141         WITHDRAW_NEW_BORROW_RATE_CALCULATION_FAILED,
142         WITHDRAW_NEW_SUPPLY_INDEX_CALCULATION_FAILED,
143         WITHDRAW_NEW_SUPPLY_RATE_CALCULATION_FAILED,
144         WITHDRAW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
145         WITHDRAW_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
146         WITHDRAW_TRANSFER_OUT_FAILED,
147         WITHDRAW_TRANSFER_OUT_NOT_POSSIBLE
148     }
149 
150 
151     /**
152       * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
153       */
154     function fail(Error err, FailureInfo info) internal returns (uint) {
155         emit Failure(uint(err), uint(info), 0);
156 
157         return uint(err);
158     }
159 
160 
161     /**
162       * @dev use this when reporting an opaque error from an upgradeable collaborator contract
163       */
164     function failOpaque(FailureInfo info, uint opaqueError) internal returns (uint) {
165         emit Failure(uint(Error.OPAQUE_ERROR), uint(info), opaqueError);
166 
167         return uint(Error.OPAQUE_ERROR);
168     }
169 
170 }
171 contract InterestRateModel {
172 
173     /**
174       * @notice Gets the current supply interest rate based on the given asset, total cash and total borrows
175       * @dev The return value should be scaled by 1e18, thus a return value of
176       *      `(true, 1000000000000)` implies an interest rate of 0.000001 or 0.0001% *per block*.
177       * @param asset The asset to get the interest rate of
178       * @param cash The total cash of the asset in the market
179       * @param borrows The total borrows of the asset in the market
180       * @return Success or failure and the supply interest rate per block scaled by 10e18
181       */
182     function getSupplyRate(address asset, uint cash, uint borrows) public view returns (uint, uint);
183 
184     /**
185       * @notice Gets the current borrow interest rate based on the given asset, total cash and total borrows
186       * @dev The return value should be scaled by 1e18, thus a return value of
187       *      `(true, 1000000000000)` implies an interest rate of 0.000001 or 0.0001% *per block*.
188       * @param asset The asset to get the interest rate of
189       * @param cash The total cash of the asset in the market
190       * @param borrows The total borrows of the asset in the market
191       * @return Success or failure and the borrow interest rate per block scaled by 10e18
192       */
193     function getBorrowRate(address asset, uint cash, uint borrows) public view returns (uint, uint);
194 }
195 contract EIP20Interface {
196     /* This is a slight change to the ERC20 base standard.
197     function totalSupply() constant returns (uint256 supply);
198     is replaced with:
199     uint256 public totalSupply;
200     This automatically creates a getter function for the totalSupply.
201     This is moved to the base contract since public getter functions are not
202     currently recognised as an implementation of the matching abstract
203     function by the compiler.
204     */
205     /// total amount of tokens
206     uint256 public totalSupply;
207 
208     /// @param _owner The address from which the balance will be retrieved
209     /// @return The balance
210     function balanceOf(address _owner) public view returns (uint256 balance);
211 
212     /// @notice send `_value` token to `_to` from `msg.sender`
213     /// @param _to The address of the recipient
214     /// @param _value The amount of token to be transferred
215     /// @return Whether the transfer was successful or not
216     function transfer(address _to, uint256 _value) public returns (bool success);
217 
218     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
219     /// @param _from The address of the sender
220     /// @param _to The address of the recipient
221     /// @param _value The amount of token to be transferred
222     /// @return Whether the transfer was successful or not
223     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
224 
225     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
226     /// @param _spender The address of the account able to transfer the tokens
227     /// @param _value The amount of tokens to be approved for transfer
228     /// @return Whether the approval was successful or not
229     function approve(address _spender, uint256 _value) public returns (bool success);
230 
231     /// @param _owner The address of the account owning tokens
232     /// @param _spender The address of the account able to transfer the tokens
233     /// @return Amount of remaining tokens allowed to spent
234     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
235 
236     // solhint-disable-next-line no-simple-event-func-name
237     event Transfer(address indexed _from, address indexed _to, uint256 _value);
238     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
239 }
240 
241 contract EIP20NonStandardInterface {
242     /* This is a slight change to the ERC20 base standard.
243     function totalSupply() constant returns (uint256 supply);
244     is replaced with:
245     uint256 public totalSupply;
246     This automatically creates a getter function for the totalSupply.
247     This is moved to the base contract since public getter functions are not
248     currently recognised as an implementation of the matching abstract
249     function by the compiler.
250     */
251     /// total amount of tokens
252     uint256 public totalSupply;
253 
254     /// @param _owner The address from which the balance will be retrieved
255     /// @return The balance
256     function balanceOf(address _owner) public view returns (uint256 balance);
257 
258     ///
259     /// !!!!!!!!!!!!!!
260     /// !!! NOTICE !!! `transfer` does not return a value, in violation of the ERC-20 specification
261     /// !!!!!!!!!!!!!!
262     ///
263 
264     /// @notice send `_value` token to `_to` from `msg.sender`
265     /// @param _to The address of the recipient
266     /// @param _value The amount of token to be transferred
267     /// @return Whether the transfer was successful or not
268     function transfer(address _to, uint256 _value) public;
269 
270     ///
271     /// !!!!!!!!!!!!!!
272     /// !!! NOTICE !!! `transferFrom` does not return a value, in violation of the ERC-20 specification
273     /// !!!!!!!!!!!!!!
274     ///
275 
276     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
277     /// @param _from The address of the sender
278     /// @param _to The address of the recipient
279     /// @param _value The amount of token to be transferred
280     /// @return Whether the transfer was successful or not
281     function transferFrom(address _from, address _to, uint256 _value) public;
282 
283     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
284     /// @param _spender The address of the account able to transfer the tokens
285     /// @param _value The amount of tokens to be approved for transfer
286     /// @return Whether the approval was successful or not
287     function approve(address _spender, uint256 _value) public returns (bool success);
288 
289     /// @param _owner The address of the account owning tokens
290     /// @param _spender The address of the account able to transfer the tokens
291     /// @return Amount of remaining tokens allowed to spent
292     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
293 
294     // solhint-disable-next-line no-simple-event-func-name
295     event Transfer(address indexed _from, address indexed _to, uint256 _value);
296     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
297 }
298 
299 contract CarefulMath is ErrorReporter {
300 
301     /**
302     * @dev Multiplies two numbers, returns an error on overflow.
303     */
304     function mul(uint a, uint b) internal pure returns (Error, uint) {
305         if (a == 0) {
306             return (Error.NO_ERROR, 0);
307         }
308 
309         uint c = a * b;
310 
311         if (c / a != b) {
312             return (Error.INTEGER_OVERFLOW, 0);
313         } else {
314             return (Error.NO_ERROR, c);
315         }
316     }
317 
318     /**
319     * @dev Integer division of two numbers, truncating the quotient.
320     */
321     function div(uint a, uint b) internal pure returns (Error, uint) {
322         if (b == 0) {
323             return (Error.DIVISION_BY_ZERO, 0);
324         }
325 
326         return (Error.NO_ERROR, a / b);
327     }
328 
329     /**
330     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
331     */
332     function sub(uint a, uint b) internal pure returns (Error, uint) {
333         if (b <= a) {
334             return (Error.NO_ERROR, a - b);
335         } else {
336             return (Error.INTEGER_UNDERFLOW, 0);
337         }
338     }
339 
340     /**
341     * @dev Adds two numbers, returns an error on overflow.
342     */
343     function add(uint a, uint b) internal pure returns (Error, uint) {
344         uint c = a + b;
345 
346         if (c >= a) {
347             return (Error.NO_ERROR, c);
348         } else {
349             return (Error.INTEGER_OVERFLOW, 0);
350         }
351     }
352 
353     /**
354     * @dev add a and b and then subtract c
355     */
356     function addThenSub(uint a, uint b, uint c) internal pure returns (Error, uint) {
357         (Error err0, uint sum) = add(a, b);
358 
359         if (err0 != Error.NO_ERROR) {
360             return (err0, 0);
361         }
362 
363         return sub(sum, c);
364     }
365 }
366 contract SafeToken is ErrorReporter {
367 
368     /**
369       * @dev Checks whether or not there is sufficient allowance for this contract to move amount from `from` and
370       *      whether or not `from` has a balance of at least `amount`. Does NOT do a transfer.
371       */
372     function checkTransferIn(address asset, address from, uint amount) internal view returns (Error) {
373 
374         EIP20Interface token = EIP20Interface(asset);
375 
376         if (token.allowance(from, address(this)) < amount) {
377             return Error.TOKEN_INSUFFICIENT_ALLOWANCE;
378         }
379 
380         if (token.balanceOf(from) < amount) {
381             return Error.TOKEN_INSUFFICIENT_BALANCE;
382         }
383 
384         return Error.NO_ERROR;
385     }
386 
387     /**
388       * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and returns an explanatory
389       *      error code rather than reverting.  If caller has not called `checkTransferIn`, this may revert due to
390       *      insufficient balance or insufficient allowance. If caller has called `checkTransferIn` prior to this call,
391       *      and it returned Error.NO_ERROR, this should not revert in normal conditions.
392       *
393       *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
394       *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
395       */
396     function doTransferIn(address asset, address from, uint amount) internal returns (Error) {
397         EIP20NonStandardInterface token = EIP20NonStandardInterface(asset);
398 
399         bool result;
400 
401         token.transferFrom(from, address(this), amount);
402 
403         assembly {
404             switch returndatasize()
405                 case 0 {                      // This is a non-standard ERC-20
406                     result := not(0)          // set result to true
407                 }
408                 case 32 {                     // This is a complaint ERC-20
409                     returndatacopy(0, 0, 32)
410                     result := mload(0)        // Set `result = returndata` of external call
411                 }
412                 default {                     // This is an excessively non-compliant ERC-20, revert.
413                     revert(0, 0)
414                 }
415         }
416 
417         if (!result) {
418             return Error.TOKEN_TRANSFER_FAILED;
419         }
420 
421         return Error.NO_ERROR;
422     }
423 
424     /**
425       * @dev Checks balance of this contract in asset
426       */
427     function getCash(address asset) internal view returns (uint) {
428         EIP20Interface token = EIP20Interface(asset);
429 
430         return token.balanceOf(address(this));
431     }
432 
433     /**
434       * @dev Checks balance of `from` in `asset`
435       */
436     function getBalanceOf(address asset, address from) internal view returns (uint) {
437         EIP20Interface token = EIP20Interface(asset);
438 
439         return token.balanceOf(from);
440     }
441 
442     /**
443       * @dev Similar to EIP20 transfer, except it handles a False result from `transfer` and returns an explanatory
444       *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
445       *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
446       *      it is >= amount, this should not revert in normal conditions.
447       *
448       *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
449       *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
450       */
451     function doTransferOut(address asset, address to, uint amount) internal returns (Error) {
452         EIP20NonStandardInterface token = EIP20NonStandardInterface(asset);
453 
454         bool result;
455 
456         token.transfer(to, amount);
457 
458         assembly {
459             switch returndatasize()
460                 case 0 {                      // This is a non-standard ERC-20
461                     result := not(0)          // set result to true
462                 }
463                 case 32 {                     // This is a complaint ERC-20
464                     returndatacopy(0, 0, 32)
465                     result := mload(0)        // Set `result = returndata` of external call
466                 }
467                 default {                     // This is an excessively non-compliant ERC-20, revert.
468                     revert(0, 0)
469                 }
470         }
471 
472         if (!result) {
473             return Error.TOKEN_TRANSFER_OUT_FAILED;
474         }
475 
476         return Error.NO_ERROR;
477     }
478 }
479 contract Exponential is ErrorReporter, CarefulMath {
480 
481     // TODO: We may wish to put the result of 10**18 here instead of the expression.
482     // Per https://solidity.readthedocs.io/en/latest/contracts.html#constant-state-variables
483     // the optimizer MAY replace the expression 10**18 with its calculated value.
484     uint constant expScale = 10**18;
485 
486     // See TODO on expScale
487     uint constant halfExpScale = expScale/2;
488 
489     struct Exp {
490         uint mantissa;
491     }
492 
493     uint constant mantissaOne = 10**18;
494     uint constant mantissaOneTenth = 10**17;
495 
496     /**
497     * @dev Creates an exponential from numerator and denominator values.
498     *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
499     *            or if `denom` is zero.
500     */
501     function getExp(uint num, uint denom) pure internal returns (Error, Exp memory) {
502         (Error err0, uint scaledNumerator) = mul(num, expScale);
503         if (err0 != Error.NO_ERROR) {
504             return (err0, Exp({mantissa: 0}));
505         }
506 
507         (Error err1, uint rational) = div(scaledNumerator, denom);
508         if (err1 != Error.NO_ERROR) {
509             return (err1, Exp({mantissa: 0}));
510         }
511 
512         return (Error.NO_ERROR, Exp({mantissa: rational}));
513     }
514 
515     /**
516     * @dev Adds two exponentials, returning a new exponential.
517     */
518     function addExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
519         (Error error, uint result) = add(a.mantissa, b.mantissa);
520 
521         return (error, Exp({mantissa: result}));
522     }
523 
524     /**
525     * @dev Subtracts two exponentials, returning a new exponential.
526     */
527     function subExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
528         (Error error, uint result) = sub(a.mantissa, b.mantissa);
529 
530         return (error, Exp({mantissa: result}));
531     }
532 
533     /**
534     * @dev Multiply an Exp by a scalar, returning a new Exp.
535     */
536     function mulScalar(Exp memory a, uint scalar) pure internal returns (Error, Exp memory) {
537         (Error err0, uint scaledMantissa) = mul(a.mantissa, scalar);
538         if (err0 != Error.NO_ERROR) {
539             return (err0, Exp({mantissa: 0}));
540         }
541 
542         return (Error.NO_ERROR, Exp({mantissa: scaledMantissa}));
543     }
544 
545     /**
546     * @dev Divide an Exp by a scalar, returning a new Exp.
547     */
548     function divScalar(Exp memory a, uint scalar) pure internal returns (Error, Exp memory) {
549         (Error err0, uint descaledMantissa) = div(a.mantissa, scalar);
550         if (err0 != Error.NO_ERROR) {
551             return (err0, Exp({mantissa: 0}));
552         }
553 
554         return (Error.NO_ERROR, Exp({mantissa: descaledMantissa}));
555     }
556 
557     /**
558     * @dev Divide a scalar by an Exp, returning a new Exp.
559     */
560     function divScalarByExp(uint scalar, Exp divisor) pure internal returns (Error, Exp memory) {
561         /*
562             We are doing this as:
563             getExp(mul(expScale, scalar), divisor.mantissa)
564 
565             How it works:
566             Exp = a / b;
567             Scalar = s;
568             `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
569         */
570         (Error err0, uint numerator) = mul(expScale, scalar);
571         if (err0 != Error.NO_ERROR) {
572             return (err0, Exp({mantissa: 0}));
573         }
574         return getExp(numerator, divisor.mantissa);
575     }
576 
577     /**
578     * @dev Multiplies two exponentials, returning a new exponential.
579     */
580     function mulExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
581 
582         (Error err0, uint doubleScaledProduct) = mul(a.mantissa, b.mantissa);
583         if (err0 != Error.NO_ERROR) {
584             return (err0, Exp({mantissa: 0}));
585         }
586 
587         // We add half the scale before dividing so that we get rounding instead of truncation.
588         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
589         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
590         (Error err1, uint doubleScaledProductWithHalfScale) = add(halfExpScale, doubleScaledProduct);
591         if (err1 != Error.NO_ERROR) {
592             return (err1, Exp({mantissa: 0}));
593         }
594 
595         (Error err2, uint product) = div(doubleScaledProductWithHalfScale, expScale);
596         // The only error `div` can return is Error.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
597         assert(err2 == Error.NO_ERROR);
598 
599         return (Error.NO_ERROR, Exp({mantissa: product}));
600     }
601 
602     /**
603       * @dev Divides two exponentials, returning a new exponential.
604       *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
605       *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
606       */
607     function divExp(Exp memory a, Exp memory b) pure internal returns (Error, Exp memory) {
608         return getExp(a.mantissa, b.mantissa);
609     }
610 
611     /**
612       * @dev Truncates the given exp to a whole number value.
613       *      For example, truncate(Exp{mantissa: 15 * (10**18)}) = 15
614       */
615     function truncate(Exp memory exp) pure internal returns (uint) {
616         // Note: We are not using careful math here as we're performing a division that cannot fail
617         return exp.mantissa / 10**18;
618     }
619 
620     /**
621       * @dev Checks if first Exp is less than second Exp.
622       */
623     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
624         return left.mantissa < right.mantissa; //TODO: Add some simple tests and this in another PR yo.
625     }
626 
627     /**
628       * @dev Checks if left Exp <= right Exp.
629       */
630     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
631         return left.mantissa <= right.mantissa;
632     }
633 
634     /**
635       * @dev returns true if Exp is exactly zero
636       */
637     function isZeroExp(Exp memory value) pure internal returns (bool) {
638         return value.mantissa == 0;
639     }
640 }
641 contract MoneyMarket is Exponential, SafeToken {
642 
643     uint constant initialInterestIndex = 10 ** 18;
644     uint constant defaultOriginationFee = 0; // default is zero bps
645 
646     uint constant minimumCollateralRatioMantissa = 11 * (10 ** 17); // 1.1
647     uint constant maximumLiquidationDiscountMantissa = (10 ** 17); // 0.1
648 
649     /**
650       * @notice `MoneyMarket` is the core Compound MoneyMarket contract
651       */
652     constructor() public {
653         admin = msg.sender;
654         collateralRatio = Exp({mantissa: 2 * mantissaOne});
655         originationFee = Exp({mantissa: defaultOriginationFee});
656         liquidationDiscount = Exp({mantissa: 0});
657         // oracle must be configured via _setOracle
658     }
659 
660     /**
661       * @notice Do not pay directly into MoneyMarket, please use `supply`.
662       */
663     function() payable public {
664         revert();
665     }
666 
667     /**
668       * @dev pending Administrator for this contract.
669       */
670     address public pendingAdmin;
671 
672     /**
673       * @dev Administrator for this contract. Initially set in constructor, but can
674       *      be changed by the admin itself.
675       */
676     address public admin;
677 
678     /**
679       * @dev Account allowed to set oracle prices for this contract. Initially set
680       *      in constructor, but can be changed by the admin.
681       */
682     address public oracle;
683 
684     /**
685       * @dev Container for customer balance information written to storage.
686       *
687       *      struct Balance {
688       *        principal = customer total balance with accrued interest after applying the customer's most recent balance-changing action
689       *        interestIndex = the total interestIndex as calculated after applying the customer's most recent balance-changing action
690       *      }
691       */
692     struct Balance {
693         uint principal;
694         uint interestIndex;
695     }
696 
697     /**
698       * @dev 2-level map: customerAddress -> assetAddress -> balance for supplies
699       */
700     mapping(address => mapping(address => Balance)) public supplyBalances;
701 
702 
703     /**
704       * @dev 2-level map: customerAddress -> assetAddress -> balance for borrows
705       */
706     mapping(address => mapping(address => Balance)) public borrowBalances;
707 
708 
709     /**
710       * @dev Container for per-asset balance sheet and interest rate information written to storage, intended to be stored in a map where the asset address is the key
711       *
712       *      struct Market {
713       *         isSupported = Whether this market is supported or not (not to be confused with the list of collateral assets)
714       *         blockNumber = when the other values in this struct were calculated
715       *         totalSupply = total amount of this asset supplied (in asset wei)
716       *         supplyRateMantissa = the per-block interest rate for supplies of asset as of blockNumber, scaled by 10e18
717       *         supplyIndex = the interest index for supplies of asset as of blockNumber; initialized in _supportMarket
718       *         totalBorrows = total amount of this asset borrowed (in asset wei)
719       *         borrowRateMantissa = the per-block interest rate for borrows of asset as of blockNumber, scaled by 10e18
720       *         borrowIndex = the interest index for borrows of asset as of blockNumber; initialized in _supportMarket
721       *     }
722       */
723     struct Market {
724         bool isSupported;
725         uint blockNumber;
726         InterestRateModel interestRateModel;
727 
728         uint totalSupply;
729         uint supplyRateMantissa;
730         uint supplyIndex;
731 
732         uint totalBorrows;
733         uint borrowRateMantissa;
734         uint borrowIndex;
735     }
736 
737     /**
738       * @dev map: assetAddress -> Market
739       */
740     mapping(address => Market) public markets;
741 
742     /**
743       * @dev list: collateralMarkets
744       */
745     address[] public collateralMarkets;
746 
747     /**
748       * @dev The collateral ratio that borrows must maintain (e.g. 2 implies 2:1). This
749       *      is initially set in the constructor, but can be changed by the admin.
750       */
751     Exp public collateralRatio;
752 
753     /**
754       * @dev originationFee for new borrows.
755       *
756       */
757     Exp public originationFee;
758 
759     /**
760       * @dev liquidationDiscount for collateral when liquidating borrows
761       *
762       */
763     Exp public liquidationDiscount;
764 
765     /**
766       * @dev flag for whether or not contract is paused
767       *
768       */
769     bool public paused;
770 
771 
772     /**
773       * @dev emitted when a supply is received
774       *      Note: newBalance - amount - startingBalance = interest accumulated since last change
775       */
776     event SupplyReceived(address account, address asset, uint amount, uint startingBalance, uint newBalance);
777 
778     /**
779       * @dev emitted when a supply is withdrawn
780       *      Note: startingBalance - amount - startingBalance = interest accumulated since last change
781       */
782     event SupplyWithdrawn(address account, address asset, uint amount, uint startingBalance, uint newBalance);
783 
784     /**
785       * @dev emitted when a new borrow is taken
786       *      Note: newBalance - borrowAmountWithFee - startingBalance = interest accumulated since last change
787       */
788     event BorrowTaken(address account, address asset, uint amount, uint startingBalance, uint borrowAmountWithFee, uint newBalance);
789 
790     /**
791       * @dev emitted when a borrow is repaid
792       *      Note: newBalance - amount - startingBalance = interest accumulated since last change
793       */
794     event BorrowRepaid(address account, address asset, uint amount, uint startingBalance, uint newBalance);
795 
796     /**
797       * @dev emitted when a borrow is liquidated
798       *      targetAccount = user whose borrow was liquidated
799       *      assetBorrow = asset borrowed
800       *      borrowBalanceBefore = borrowBalance as most recently stored before the liquidation
801       *      borrowBalanceAccumulated = borroBalanceBefore + accumulated interest as of immediately prior to the liquidation
802       *      amountRepaid = amount of borrow repaid
803       *      liquidator = account requesting the liquidation
804       *      assetCollateral = asset taken from targetUser and given to liquidator in exchange for liquidated loan
805       *      borrowBalanceAfter = new stored borrow balance (should equal borrowBalanceAccumulated - amountRepaid)
806       *      collateralBalanceBefore = collateral balance as most recently stored before the liquidation
807       *      collateralBalanceAccumulated = collateralBalanceBefore + accumulated interest as of immediately prior to the liquidation
808       *      amountSeized = amount of collateral seized by liquidator
809       *      collateralBalanceAfter = new stored collateral balance (should equal collateralBalanceAccumulated - amountSeized)
810       */
811     event BorrowLiquidated(address targetAccount,
812         address assetBorrow,
813         uint borrowBalanceBefore,
814         uint borrowBalanceAccumulated,
815         uint amountRepaid,
816         uint borrowBalanceAfter,
817         address liquidator,
818         address assetCollateral,
819         uint collateralBalanceBefore,
820         uint collateralBalanceAccumulated,
821         uint amountSeized,
822         uint collateralBalanceAfter);
823 
824     /**
825       * @dev emitted when pendingAdmin is changed
826       */
827     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
828 
829     /**
830       * @dev emitted when pendingAdmin is accepted, which means admin is updated
831       */
832     event NewAdmin(address oldAdmin, address newAdmin);
833 
834     /**
835       * @dev newOracle - address of new oracle
836       */
837     event NewOracle(address oldOracle, address newOracle);
838 
839     /**
840       * @dev emitted when new market is supported by admin
841       */
842     event SupportedMarket(address asset, address interestRateModel);
843 
844     /**
845       * @dev emitted when risk parameters are changed by admin
846       */
847     event NewRiskParameters(uint oldCollateralRatioMantissa, uint newCollateralRatioMantissa, uint oldLiquidationDiscountMantissa, uint newLiquidationDiscountMantissa);
848 
849     /**
850       * @dev emitted when origination fee is changed by admin
851       */
852     event NewOriginationFee(uint oldOriginationFeeMantissa, uint newOriginationFeeMantissa);
853 
854     /**
855       * @dev emitted when market has new interest rate model set
856       */
857     event SetMarketInterestRateModel(address asset, address interestRateModel);
858 
859     /**
860       * @dev emitted when admin withdraws equity
861       * Note that `equityAvailableBefore` indicates equity before `amount` was removed.
862       */
863     event EquityWithdrawn(address asset, uint equityAvailableBefore, uint amount, address owner);
864 
865     /**
866       * @dev emitted when a supported market is suspended by admin
867       */
868     event SuspendedMarket(address asset);
869 
870     /**
871       * @dev emitted when admin either pauses or resumes the contract; newState is the resulting state
872       */
873     event SetPaused(bool newState);
874 
875     /**
876       * @dev Simple function to calculate min between two numbers.
877       */
878     function min(uint a, uint b) pure internal returns (uint) {
879         if (a < b) {
880             return a;
881         } else {
882             return b;
883         }
884     }
885 
886     /**
887       * @dev Function to simply retrieve block number
888       *      This exists mainly for inheriting test contracts to stub this result.
889       */
890     function getBlockNumber() internal view returns (uint) {
891         return block.number;
892     }
893 
894     /**
895       * @dev Adds a given asset to the list of collateral markets. This operation is impossible to reverse.
896       *      Note: this will not add the asset if it already exists.
897       */
898     function addCollateralMarket(address asset) internal {
899         for (uint i = 0; i < collateralMarkets.length; i++) {
900             if (collateralMarkets[i] == asset) {
901                 return;
902             }
903         }
904 
905         collateralMarkets.push(asset);
906     }
907 
908     /**
909       * @notice return the number of elements in `collateralMarkets`
910       * @dev you can then externally call `collateralMarkets(uint)` to pull each market address
911       * @return the length of `collateralMarkets`
912       */
913     function getCollateralMarketsLength() public view returns (uint) {
914         return collateralMarkets.length;
915     }
916 
917     /**
918       * @dev Calculates a new supply index based on the prevailing interest rates applied over time
919       *      This is defined as `we multiply the most recent supply index by (1 + blocks times rate)`
920       */
921     function calculateInterestIndex(uint startingInterestIndex, uint interestRateMantissa, uint blockStart, uint blockEnd) pure internal returns (Error, uint) {
922 
923         // Get the block delta
924         (Error err0, uint blockDelta) = sub(blockEnd, blockStart);
925         if (err0 != Error.NO_ERROR) {
926             return (err0, 0);
927         }
928 
929         // Scale the interest rate times number of blocks
930         // Note: Doing Exp construction inline to avoid `CompilerError: Stack too deep, try removing local variables.`
931         (Error err1, Exp memory blocksTimesRate) = mulScalar(Exp({mantissa: interestRateMantissa}), blockDelta);
932         if (err1 != Error.NO_ERROR) {
933             return (err1, 0);
934         }
935 
936         // Add one to that result (which is really Exp({mantissa: expScale}) which equals 1.0)
937         (Error err2, Exp memory onePlusBlocksTimesRate) = addExp(blocksTimesRate, Exp({mantissa: mantissaOne}));
938         if (err2 != Error.NO_ERROR) {
939             return (err2, 0);
940         }
941 
942         // Then scale that accumulated interest by the old interest index to get the new interest index
943         (Error err3, Exp memory newInterestIndexExp) = mulScalar(onePlusBlocksTimesRate, startingInterestIndex);
944         if (err3 != Error.NO_ERROR) {
945             return (err3, 0);
946         }
947 
948         // Finally, truncate the interest index. This works only if interest index starts large enough
949         // that is can be accurately represented with a whole number.
950         return (Error.NO_ERROR, truncate(newInterestIndexExp));
951     }
952 
953     /**
954       * @dev Calculates a new balance based on a previous balance and a pair of interest indices
955       *      This is defined as: `The user's last balance checkpoint is multiplied by the currentSupplyIndex
956       *      value and divided by the user's checkpoint index value`
957       *
958       *      TODO: Is there a way to handle this that is less likely to overflow?
959       */
960     function calculateBalance(uint startingBalance, uint interestIndexStart, uint interestIndexEnd) pure internal returns (Error, uint) {
961         if (startingBalance == 0) {
962             // We are accumulating interest on any previous balance; if there's no previous balance, then there is
963             // nothing to accumulate.
964             return (Error.NO_ERROR, 0);
965         }
966         (Error err0, uint balanceTimesIndex) = mul(startingBalance, interestIndexEnd);
967         if (err0 != Error.NO_ERROR) {
968             return (err0, 0);
969         }
970 
971         return div(balanceTimesIndex, interestIndexStart);
972     }
973 
974     /**
975       * @dev Gets the price for the amount specified of the given asset.
976       */
977     function getPriceForAssetAmount(address asset, uint assetAmount) internal view returns (Error, Exp memory)  {
978         (Error err, Exp memory assetPrice) = fetchAssetPrice(asset);
979         if (err != Error.NO_ERROR) {
980             return (err, Exp({mantissa: 0}));
981         }
982 
983         if (isZeroExp(assetPrice)) {
984             return (Error.MISSING_ASSET_PRICE, Exp({mantissa: 0}));
985         }
986 
987         return mulScalar(assetPrice, assetAmount); // assetAmountWei * oraclePrice = assetValueInEth
988     }
989 
990     /**
991       * @dev Gets the price for the amount specified of the given asset multiplied by the current
992       *      collateral ratio (i.e., assetAmountWei * collateralRatio * oraclePrice = totalValueInEth).
993       *      We will group this as `(oraclePrice * collateralRatio) * assetAmountWei`
994       */
995     function getPriceForAssetAmountMulCollatRatio(address asset, uint assetAmount) internal view returns (Error, Exp memory)  {
996         Error err;
997         Exp memory assetPrice;
998         Exp memory scaledPrice;
999         (err, assetPrice) = fetchAssetPrice(asset);
1000         if (err != Error.NO_ERROR) {
1001             return (err, Exp({mantissa: 0}));
1002         }
1003 
1004         if (isZeroExp(assetPrice)) {
1005             return (Error.MISSING_ASSET_PRICE, Exp({mantissa: 0}));
1006         }
1007 
1008         // Now, multiply the assetValue by the collateral ratio
1009         (err, scaledPrice) = mulExp(collateralRatio, assetPrice);
1010         if (err != Error.NO_ERROR) {
1011             return (err, Exp({mantissa: 0}));
1012         }
1013 
1014         // Get the price for the given asset amount
1015         return mulScalar(scaledPrice, assetAmount);
1016     }
1017 
1018     /**
1019       * @dev Calculates the origination fee added to a given borrowAmount
1020       *      This is simply `(1 + originationFee) * borrowAmount`
1021       *
1022       *      TODO: Track at what magnitude this fee rounds down to zero?
1023       */
1024     function calculateBorrowAmountWithFee(uint borrowAmount) view internal returns (Error, uint) {
1025         // When origination fee is zero, the amount with fee is simply equal to the amount
1026         if (isZeroExp(originationFee)) {
1027             return (Error.NO_ERROR, borrowAmount);
1028         }
1029 
1030         (Error err0, Exp memory originationFeeFactor) = addExp(originationFee, Exp({mantissa: mantissaOne}));
1031         if (err0 != Error.NO_ERROR) {
1032             return (err0, 0);
1033         }
1034 
1035         (Error err1, Exp memory borrowAmountWithFee) = mulScalar(originationFeeFactor, borrowAmount);
1036         if (err1 != Error.NO_ERROR) {
1037             return (err1, 0);
1038         }
1039 
1040         return (Error.NO_ERROR, truncate(borrowAmountWithFee));
1041     }
1042 
1043     /**
1044       * @dev fetches the price of asset from the PriceOracle and converts it to Exp
1045       * @param asset asset whose price should be fetched
1046       */
1047     function fetchAssetPrice(address asset) internal view returns (Error, Exp memory) {
1048         if (oracle == address(0)) {
1049             return (Error.ZERO_ORACLE_ADDRESS, Exp({mantissa: 0}));
1050         }
1051 
1052         PriceOracleInterface oracleInterface = PriceOracleInterface(oracle);
1053         uint priceMantissa = oracleInterface.assetPrices(asset);
1054 
1055         return (Error.NO_ERROR, Exp({mantissa: priceMantissa}));
1056     }
1057 
1058     /**
1059       * @notice Reads scaled price of specified asset from the price oracle
1060       * @dev Reads scaled price of specified asset from the price oracle.
1061       *      The plural name is to match a previous storage mapping that this function replaced.
1062       * @param asset Asset whose price should be retrieved
1063       * @return 0 on an error or missing price, the price scaled by 1e18 otherwise
1064       */
1065     function assetPrices(address asset) public view returns (uint) {
1066         (Error err, Exp memory result) = fetchAssetPrice(asset);
1067         if (err != Error.NO_ERROR) {
1068             return 0;
1069         }
1070         return result.mantissa;
1071     }
1072 
1073     /**
1074       * @dev Gets the amount of the specified asset given the specified Eth value
1075       *      ethValue / oraclePrice = assetAmountWei
1076       *      If there's no oraclePrice, this returns (Error.DIVISION_BY_ZERO, 0)
1077       */
1078     function getAssetAmountForValue(address asset, Exp ethValue) internal view returns (Error, uint) {
1079         Error err;
1080         Exp memory assetPrice;
1081         Exp memory assetAmount;
1082 
1083         (err, assetPrice) = fetchAssetPrice(asset);
1084         if (err != Error.NO_ERROR) {
1085             return (err, 0);
1086         }
1087 
1088         (err, assetAmount) = divExp(ethValue, assetPrice);
1089         if (err != Error.NO_ERROR) {
1090             return (err, 0);
1091         }
1092 
1093         return (Error.NO_ERROR, truncate(assetAmount));
1094     }
1095 
1096     /**
1097       * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
1098       * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
1099       * @param newPendingAdmin New pending admin.
1100       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1101       *
1102       * TODO: Should we add a second arg to verify, like a checksum of `newAdmin` address?
1103       */
1104     function _setPendingAdmin(address newPendingAdmin) public returns (uint) {
1105         // Check caller = admin
1106         if (msg.sender != admin) {
1107             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
1108         }
1109 
1110         // save current value, if any, for inclusion in log
1111         address oldPendingAdmin = pendingAdmin;
1112         // Store pendingAdmin = newPendingAdmin
1113         pendingAdmin = newPendingAdmin;
1114 
1115         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
1116 
1117         return uint(Error.NO_ERROR);
1118     }
1119 
1120     /**
1121       * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
1122       * @dev Admin function for pending admin to accept role and update admin
1123       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1124       */
1125     function _acceptAdmin() public returns (uint) {
1126         // Check caller = pendingAdmin
1127         // msg.sender can't be zero
1128         if (msg.sender != pendingAdmin) {
1129             return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);
1130         }
1131 
1132         // Save current value for inclusion in log
1133         address oldAdmin = admin;
1134         // Store admin = pendingAdmin
1135         admin = pendingAdmin;
1136         // Clear the pending value
1137         pendingAdmin = 0;
1138 
1139         emit NewAdmin(oldAdmin, msg.sender);
1140 
1141         return uint(Error.NO_ERROR);
1142     }
1143 
1144     /**
1145       * @notice Set new oracle, who can set asset prices
1146       * @dev Admin function to change oracle
1147       * @param newOracle New oracle address
1148       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1149       */
1150     function _setOracle(address newOracle) public returns (uint) {
1151         // Check caller = admin
1152         if (msg.sender != admin) {
1153             return fail(Error.UNAUTHORIZED, FailureInfo.SET_ORACLE_OWNER_CHECK);
1154         }
1155 
1156         // Verify contract at newOracle address supports assetPrices call.
1157         // This will revert if it doesn't.
1158         PriceOracleInterface oracleInterface = PriceOracleInterface(newOracle);
1159         oracleInterface.assetPrices(address(0));
1160 
1161         address oldOracle = oracle;
1162 
1163         // Store oracle = newOracle
1164         oracle = newOracle;
1165 
1166         emit NewOracle(oldOracle, newOracle);
1167 
1168         return uint(Error.NO_ERROR);
1169     }
1170 
1171     /**
1172       * @notice set `paused` to the specified state
1173       * @dev Admin function to pause or resume the market
1174       * @param requestedState value to assign to `paused`
1175       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1176       */
1177     function _setPaused(bool requestedState) public returns (uint) {
1178         // Check caller = admin
1179         if (msg.sender != admin) {
1180             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PAUSED_OWNER_CHECK);
1181         }
1182 
1183         paused = requestedState;
1184         emit SetPaused(requestedState);
1185 
1186         return uint(Error.NO_ERROR);
1187     }
1188 
1189     /**
1190       * @notice returns the liquidity for given account.
1191       *         a positive result indicates ability to borrow, whereas
1192       *         a negative result indicates a shortfall which may be liquidated
1193       * @dev returns account liquidity in terms of eth-wei value, scaled by 1e18
1194       *      note: this includes interest trued up on all balances
1195       * @param account the account to examine
1196       * @return signed integer in terms of eth-wei (negative indicates a shortfall)
1197       */
1198     function getAccountLiquidity(address account) public view returns (int) {
1199         (Error err, Exp memory accountLiquidity, Exp memory accountShortfall) = calculateAccountLiquidity(account);
1200         require(err == Error.NO_ERROR);
1201 
1202         if (isZeroExp(accountLiquidity)) {
1203             return -1 * int(truncate(accountShortfall));
1204         } else {
1205             return int(truncate(accountLiquidity));
1206         }
1207     }
1208 
1209     /**
1210       * @notice return supply balance with any accumulated interest for `asset` belonging to `account`
1211       * @dev returns supply balance with any accumulated interest for `asset` belonging to `account`
1212       * @param account the account to examine
1213       * @param asset the market asset whose supply balance belonging to `account` should be checked
1214       * @return uint supply balance on success, throws on failed assertion otherwise
1215       */
1216     function getSupplyBalance(address account, address asset) view public returns (uint) {
1217         Error err;
1218         uint newSupplyIndex;
1219         uint userSupplyCurrent;
1220 
1221         Market storage market = markets[asset];
1222         Balance storage supplyBalance = supplyBalances[account][asset];
1223 
1224         // Calculate the newSupplyIndex, needed to calculate user's supplyCurrent
1225         (err, newSupplyIndex) = calculateInterestIndex(market.supplyIndex, market.supplyRateMantissa, market.blockNumber, getBlockNumber());
1226         require(err == Error.NO_ERROR);
1227 
1228         // Use newSupplyIndex and stored principal to calculate the accumulated balance
1229         (err, userSupplyCurrent) = calculateBalance(supplyBalance.principal, supplyBalance.interestIndex, newSupplyIndex);
1230         require(err == Error.NO_ERROR);
1231 
1232         return userSupplyCurrent;
1233     }
1234 
1235     /**
1236       * @notice return borrow balance with any accumulated interest for `asset` belonging to `account`
1237       * @dev returns borrow balance with any accumulated interest for `asset` belonging to `account`
1238       * @param account the account to examine
1239       * @param asset the market asset whose borrow balance belonging to `account` should be checked
1240       * @return uint borrow balance on success, throws on failed assertion otherwise
1241       */
1242     function getBorrowBalance(address account, address asset) view public returns (uint) {
1243         Error err;
1244         uint newBorrowIndex;
1245         uint userBorrowCurrent;
1246 
1247         Market storage market = markets[asset];
1248         Balance storage borrowBalance = borrowBalances[account][asset];
1249 
1250         // Calculate the newBorrowIndex, needed to calculate user's borrowCurrent
1251         (err, newBorrowIndex) = calculateInterestIndex(market.borrowIndex, market.borrowRateMantissa, market.blockNumber, getBlockNumber());
1252         require(err == Error.NO_ERROR);
1253 
1254         // Use newBorrowIndex and stored principal to calculate the accumulated balance
1255         (err, userBorrowCurrent) = calculateBalance(borrowBalance.principal, borrowBalance.interestIndex, newBorrowIndex);
1256         require(err == Error.NO_ERROR);
1257 
1258         return userBorrowCurrent;
1259     }
1260 
1261 
1262     /**
1263       * @notice Supports a given market (asset) for use with Compound
1264       * @dev Admin function to add support for a market
1265       * @param asset Asset to support; MUST already have a non-zero price set
1266       * @param interestRateModel InterestRateModel to use for the asset
1267       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1268       */
1269     function _supportMarket(address asset, InterestRateModel interestRateModel) public returns (uint) {
1270         // Check caller = admin
1271         if (msg.sender != admin) {
1272             return fail(Error.UNAUTHORIZED, FailureInfo.SUPPORT_MARKET_OWNER_CHECK);
1273         }
1274 
1275         (Error err, Exp memory assetPrice) = fetchAssetPrice(asset);
1276         if (err != Error.NO_ERROR) {
1277             return fail(err, FailureInfo.SUPPORT_MARKET_FETCH_PRICE_FAILED);
1278         }
1279 
1280         if (isZeroExp(assetPrice)) {
1281             return fail(Error.ASSET_NOT_PRICED, FailureInfo.SUPPORT_MARKET_PRICE_CHECK);
1282         }
1283 
1284         // Set the interest rate model to `modelAddress`
1285         markets[asset].interestRateModel = interestRateModel;
1286 
1287         // Append asset to collateralAssets if not set
1288         addCollateralMarket(asset);
1289 
1290         // Set market isSupported to true
1291         markets[asset].isSupported = true;
1292 
1293         // Default supply and borrow index to 1e18
1294         if (markets[asset].supplyIndex == 0) {
1295             markets[asset].supplyIndex = initialInterestIndex;
1296         }
1297 
1298         if (markets[asset].borrowIndex == 0) {
1299             markets[asset].borrowIndex = initialInterestIndex;
1300         }
1301 
1302         emit SupportedMarket(asset, interestRateModel);
1303 
1304         return uint(Error.NO_ERROR);
1305     }
1306 
1307     /**
1308       * @notice Suspends a given *supported* market (asset) from use with Compound.
1309       *         Assets in this state do count for collateral, but users may only withdraw, payBorrow,
1310       *         and liquidate the asset. The liquidate function no longer checks collateralization.
1311       * @dev Admin function to suspend a market
1312       * @param asset Asset to suspend
1313       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1314       */
1315     function _suspendMarket(address asset) public returns (uint) {
1316         // Check caller = admin
1317         if (msg.sender != admin) {
1318             return fail(Error.UNAUTHORIZED, FailureInfo.SUSPEND_MARKET_OWNER_CHECK);
1319         }
1320 
1321         // If the market is not configured at all, we don't want to add any configuration for it.
1322         // If we find !markets[asset].isSupported then either the market is not configured at all, or it
1323         // has already been marked as unsupported. We can just return without doing anything.
1324         // Caller is responsible for knowing the difference between not-configured and already unsupported.
1325         if (!markets[asset].isSupported) {
1326             return uint(Error.NO_ERROR);
1327         }
1328 
1329         // If we get here, we know market is configured and is supported, so set isSupported to false
1330         markets[asset].isSupported = false;
1331 
1332         emit SuspendedMarket(asset);
1333 
1334         return uint(Error.NO_ERROR);
1335     }
1336 
1337     /**
1338       * @notice Sets the risk parameters: collateral ratio and liquidation discount
1339       * @dev Owner function to set the risk parameters
1340       * @param collateralRatioMantissa rational collateral ratio, scaled by 1e18. The de-scaled value must be >= 1.1
1341       * @param liquidationDiscountMantissa rational liquidation discount, scaled by 1e18. The de-scaled value must be <= 0.1 and must be less than (descaled collateral ratio minus 1)
1342       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1343       */
1344     function _setRiskParameters(uint collateralRatioMantissa, uint liquidationDiscountMantissa) public returns (uint) {
1345         // Check caller = admin
1346         if (msg.sender != admin) {
1347             return fail(Error.UNAUTHORIZED, FailureInfo.SET_RISK_PARAMETERS_OWNER_CHECK);
1348         }
1349 
1350         Exp memory newCollateralRatio = Exp({mantissa: collateralRatioMantissa});
1351         Exp memory newLiquidationDiscount = Exp({mantissa: liquidationDiscountMantissa});
1352         Exp memory minimumCollateralRatio = Exp({mantissa: minimumCollateralRatioMantissa});
1353         Exp memory maximumLiquidationDiscount = Exp({mantissa: maximumLiquidationDiscountMantissa});
1354 
1355         Error err;
1356         Exp memory newLiquidationDiscountPlusOne;
1357 
1358         // Make sure new collateral ratio value is not below minimum value
1359         if (lessThanExp(newCollateralRatio, minimumCollateralRatio)) {
1360             return fail(Error.INVALID_COLLATERAL_RATIO, FailureInfo.SET_RISK_PARAMETERS_VALIDATION);
1361         }
1362 
1363         // Make sure new liquidation discount does not exceed the maximum value, but reverse operands so we can use the
1364         // existing `lessThanExp` function rather than adding a `greaterThan` function to Exponential.
1365         if (lessThanExp(maximumLiquidationDiscount, newLiquidationDiscount)) {
1366             return fail(Error.INVALID_LIQUIDATION_DISCOUNT, FailureInfo.SET_RISK_PARAMETERS_VALIDATION);
1367         }
1368 
1369         // C = L+1 is not allowed because it would cause division by zero error in `calculateDiscountedRepayToEvenAmount`
1370         // C < L+1 is not allowed because it would cause integer underflow error in `calculateDiscountedRepayToEvenAmount`
1371         (err, newLiquidationDiscountPlusOne) = addExp(newLiquidationDiscount, Exp({mantissa: mantissaOne}));
1372         assert(err == Error.NO_ERROR); // We already validated that newLiquidationDiscount does not approach overflow size
1373 
1374         if (lessThanOrEqualExp(newCollateralRatio, newLiquidationDiscountPlusOne)) {
1375             return fail(Error.INVALID_COMBINED_RISK_PARAMETERS, FailureInfo.SET_RISK_PARAMETERS_VALIDATION);
1376         }
1377 
1378         // Save current values so we can emit them in log.
1379         Exp memory oldCollateralRatio = collateralRatio;
1380         Exp memory oldLiquidationDiscount = liquidationDiscount;
1381 
1382         // Store new values
1383         collateralRatio = newCollateralRatio;
1384         liquidationDiscount = newLiquidationDiscount;
1385 
1386         emit NewRiskParameters(oldCollateralRatio.mantissa, collateralRatioMantissa, oldLiquidationDiscount.mantissa, liquidationDiscountMantissa);
1387 
1388         return uint(Error.NO_ERROR);
1389     }
1390 
1391     /**
1392       * @notice Sets the origination fee (which is a multiplier on new borrows)
1393       * @dev Owner function to set the origination fee
1394       * @param originationFeeMantissa rational collateral ratio, scaled by 1e18. The de-scaled value must be >= 1.1
1395       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1396       */
1397     function _setOriginationFee(uint originationFeeMantissa) public returns (uint) {
1398         // Check caller = admin
1399         if (msg.sender != admin) {
1400             return fail(Error.UNAUTHORIZED, FailureInfo.SET_ORIGINATION_FEE_OWNER_CHECK);
1401         }
1402 
1403         // Save current value so we can emit it in log.
1404         Exp memory oldOriginationFee = originationFee;
1405 
1406         originationFee = Exp({mantissa: originationFeeMantissa});
1407 
1408         emit NewOriginationFee(oldOriginationFee.mantissa, originationFeeMantissa);
1409 
1410         return uint(Error.NO_ERROR);
1411     }
1412 
1413     /**
1414       * @notice Sets the interest rate model for a given market
1415       * @dev Admin function to set interest rate model
1416       * @param asset Asset to support
1417       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1418       */
1419     function _setMarketInterestRateModel(address asset, InterestRateModel interestRateModel) public returns (uint) {
1420         // Check caller = admin
1421         if (msg.sender != admin) {
1422             return fail(Error.UNAUTHORIZED, FailureInfo.SET_MARKET_INTEREST_RATE_MODEL_OWNER_CHECK);
1423         }
1424 
1425         // Set the interest rate model to `modelAddress`
1426         markets[asset].interestRateModel = interestRateModel;
1427 
1428         emit SetMarketInterestRateModel(asset, interestRateModel);
1429 
1430         return uint(Error.NO_ERROR);
1431     }
1432 
1433     /**
1434       * @notice withdraws `amount` of `asset` from equity for asset, as long as `amount` <= equity. Equity= cash - (supply + borrows)
1435       * @dev withdraws `amount` of `asset` from equity  for asset, enforcing amount <= cash - (supply + borrows)
1436       * @param asset asset whose equity should be withdrawn
1437       * @param amount amount of equity to withdraw; must not exceed equity available
1438       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1439       */
1440     function _withdrawEquity(address asset, uint amount) public returns (uint) {
1441         // Check caller = admin
1442         if (msg.sender != admin) {
1443             return fail(Error.UNAUTHORIZED, FailureInfo.EQUITY_WITHDRAWAL_MODEL_OWNER_CHECK);
1444         }
1445 
1446         // Check that amount is less than cash (from ERC-20 of self) plus borrows minus supply.
1447         uint cash = getCash(asset);
1448         (Error err0, uint equity) = addThenSub(cash, markets[asset].totalBorrows, markets[asset].totalSupply);
1449         if (err0 != Error.NO_ERROR) {
1450             return fail(err0, FailureInfo.EQUITY_WITHDRAWAL_CALCULATE_EQUITY);
1451         }
1452 
1453         if (amount > equity) {
1454             return fail(Error.EQUITY_INSUFFICIENT_BALANCE, FailureInfo.EQUITY_WITHDRAWAL_AMOUNT_VALIDATION);
1455         }
1456 
1457         /////////////////////////
1458         // EFFECTS & INTERACTIONS
1459         // (No safe failures beyond this point)
1460 
1461         // We ERC-20 transfer the asset out of the protocol to the admin
1462         Error err2 = doTransferOut(asset, admin, amount);
1463         if (err2 != Error.NO_ERROR) {
1464             // This is safe since it's our first interaction and it didn't do anything if it failed
1465             return fail(err2, FailureInfo.EQUITY_WITHDRAWAL_TRANSFER_OUT_FAILED);
1466         }
1467 
1468         //event EquityWithdrawn(address asset, uint equityAvailableBefore, uint amount, address owner)
1469         emit EquityWithdrawn(asset, equity, amount, admin);
1470 
1471         return uint(Error.NO_ERROR); // success
1472     }
1473 
1474     /**
1475       * The `SupplyLocalVars` struct is used internally in the `supply` function.
1476       *
1477       * To avoid solidity limits on the number of local variables we:
1478       * 1. Use a struct to hold local computation localResults
1479       * 2. Re-use a single variable for Error returns. (This is required with 1 because variable binding to tuple localResults
1480       *    requires either both to be declared inline or both to be previously declared.
1481       * 3. Re-use a boolean error-like return variable.
1482       */
1483     struct SupplyLocalVars {
1484         uint startingBalance;
1485         uint newSupplyIndex;
1486         uint userSupplyCurrent;
1487         uint userSupplyUpdated;
1488         uint newTotalSupply;
1489         uint currentCash;
1490         uint updatedCash;
1491         uint newSupplyRateMantissa;
1492         uint newBorrowIndex;
1493         uint newBorrowRateMantissa;
1494     }
1495 
1496 
1497     /**
1498       * @notice supply `amount` of `asset` (which must be supported) to `msg.sender` in the protocol
1499       * @dev add amount of supported asset to msg.sender's account
1500       * @param asset The market asset to supply
1501       * @param amount The amount to supply
1502       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1503       */
1504     function supply(address asset, uint amount) public returns (uint) {
1505         if (paused) {
1506             return fail(Error.CONTRACT_PAUSED, FailureInfo.SUPPLY_CONTRACT_PAUSED);
1507         }
1508 
1509         Market storage market = markets[asset];
1510         Balance storage balance = supplyBalances[msg.sender][asset];
1511 
1512         SupplyLocalVars memory localResults; // Holds all our uint calculation results
1513         Error err; // Re-used for every function call that includes an Error in its return value(s).
1514         uint rateCalculationResultCode; // Used for 2 interest rate calculation calls
1515 
1516         // Fail if market not supported
1517         if (!market.isSupported) {
1518             return fail(Error.MARKET_NOT_SUPPORTED, FailureInfo.SUPPLY_MARKET_NOT_SUPPORTED);
1519         }
1520 
1521         // Fail gracefully if asset is not approved or has insufficient balance
1522         err = checkTransferIn(asset, msg.sender, amount);
1523         if (err != Error.NO_ERROR) {
1524             return fail(err, FailureInfo.SUPPLY_TRANSFER_IN_NOT_POSSIBLE);
1525         }
1526 
1527         // We calculate the newSupplyIndex, user's supplyCurrent and supplyUpdated for the asset
1528         (err, localResults.newSupplyIndex) = calculateInterestIndex(market.supplyIndex, market.supplyRateMantissa, market.blockNumber, getBlockNumber());
1529         if (err != Error.NO_ERROR) {
1530             return fail(err, FailureInfo.SUPPLY_NEW_SUPPLY_INDEX_CALCULATION_FAILED);
1531         }
1532 
1533         (err, localResults.userSupplyCurrent) = calculateBalance(balance.principal, balance.interestIndex, localResults.newSupplyIndex);
1534         if (err != Error.NO_ERROR) {
1535             return fail(err, FailureInfo.SUPPLY_ACCUMULATED_BALANCE_CALCULATION_FAILED);
1536         }
1537 
1538         (err, localResults.userSupplyUpdated) = add(localResults.userSupplyCurrent, amount);
1539         if (err != Error.NO_ERROR) {
1540             return fail(err, FailureInfo.SUPPLY_NEW_TOTAL_BALANCE_CALCULATION_FAILED);
1541         }
1542 
1543         // We calculate the protocol's totalSupply by subtracting the user's prior checkpointed balance, adding user's updated supply
1544         (err, localResults.newTotalSupply) = addThenSub(market.totalSupply, localResults.userSupplyUpdated, balance.principal);
1545         if (err != Error.NO_ERROR) {
1546             return fail(err, FailureInfo.SUPPLY_NEW_TOTAL_SUPPLY_CALCULATION_FAILED);
1547         }
1548 
1549         // We need to calculate what the updated cash will be after we transfer in from user
1550         localResults.currentCash = getCash(asset);
1551 
1552         (err, localResults.updatedCash) = add(localResults.currentCash, amount);
1553         if (err != Error.NO_ERROR) {
1554             return fail(err, FailureInfo.SUPPLY_NEW_TOTAL_CASH_CALCULATION_FAILED);
1555         }
1556 
1557         // The utilization rate has changed! We calculate a new supply index and borrow index for the asset, and save it.
1558         (rateCalculationResultCode, localResults.newSupplyRateMantissa) = market.interestRateModel.getSupplyRate(asset, localResults.updatedCash, market.totalBorrows);
1559         if (rateCalculationResultCode != 0) {
1560             return failOpaque(FailureInfo.SUPPLY_NEW_SUPPLY_RATE_CALCULATION_FAILED, rateCalculationResultCode);
1561         }
1562 
1563         // We calculate the newBorrowIndex (we already had newSupplyIndex)
1564         (err, localResults.newBorrowIndex) = calculateInterestIndex(market.borrowIndex, market.borrowRateMantissa, market.blockNumber, getBlockNumber());
1565         if (err != Error.NO_ERROR) {
1566             return fail(err, FailureInfo.SUPPLY_NEW_BORROW_INDEX_CALCULATION_FAILED);
1567         }
1568 
1569         (rateCalculationResultCode, localResults.newBorrowRateMantissa) = market.interestRateModel.getBorrowRate(asset, localResults.updatedCash, market.totalBorrows);
1570         if (rateCalculationResultCode != 0) {
1571             return failOpaque(FailureInfo.SUPPLY_NEW_BORROW_RATE_CALCULATION_FAILED, rateCalculationResultCode);
1572         }
1573 
1574         /////////////////////////
1575         // EFFECTS & INTERACTIONS
1576         // (No safe failures beyond this point)
1577 
1578         // We ERC-20 transfer the asset into the protocol (note: pre-conditions already checked above)
1579         err = doTransferIn(asset, msg.sender, amount);
1580         if (err != Error.NO_ERROR) {
1581             // This is safe since it's our first interaction and it didn't do anything if it failed
1582             return fail(err, FailureInfo.SUPPLY_TRANSFER_IN_FAILED);
1583         }
1584 
1585         // Save market updates
1586         market.blockNumber = getBlockNumber();
1587         market.totalSupply =  localResults.newTotalSupply;
1588         market.supplyRateMantissa = localResults.newSupplyRateMantissa;
1589         market.supplyIndex = localResults.newSupplyIndex;
1590         market.borrowRateMantissa = localResults.newBorrowRateMantissa;
1591         market.borrowIndex = localResults.newBorrowIndex;
1592 
1593         // Save user updates
1594         localResults.startingBalance = balance.principal; // save for use in `SupplyReceived` event
1595         balance.principal = localResults.userSupplyUpdated;
1596         balance.interestIndex = localResults.newSupplyIndex;
1597 
1598         emit SupplyReceived(msg.sender, asset, amount, localResults.startingBalance, localResults.userSupplyUpdated);
1599 
1600         return uint(Error.NO_ERROR); // success
1601     }
1602 
1603     struct WithdrawLocalVars {
1604         uint withdrawAmount;
1605         uint startingBalance;
1606         uint newSupplyIndex;
1607         uint userSupplyCurrent;
1608         uint userSupplyUpdated;
1609         uint newTotalSupply;
1610         uint currentCash;
1611         uint updatedCash;
1612         uint newSupplyRateMantissa;
1613         uint newBorrowIndex;
1614         uint newBorrowRateMantissa;
1615 
1616         Exp accountLiquidity;
1617         Exp accountShortfall;
1618         Exp ethValueOfWithdrawal;
1619         uint withdrawCapacity;
1620     }
1621 
1622 
1623     /**
1624       * @notice withdraw `amount` of `asset` from sender's account to sender's address
1625       * @dev withdraw `amount` of `asset` from msg.sender's account to msg.sender
1626       * @param asset The market asset to withdraw
1627       * @param requestedAmount The amount to withdraw (or -1 for max)
1628       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1629       */
1630     function withdraw(address asset, uint requestedAmount) public returns (uint) {
1631         if (paused) {
1632             return fail(Error.CONTRACT_PAUSED, FailureInfo.WITHDRAW_CONTRACT_PAUSED);
1633         }
1634 
1635         Market storage market = markets[asset];
1636         Balance storage supplyBalance = supplyBalances[msg.sender][asset];
1637 
1638         WithdrawLocalVars memory localResults; // Holds all our calculation results
1639         Error err; // Re-used for every function call that includes an Error in its return value(s).
1640         uint rateCalculationResultCode; // Used for 2 interest rate calculation calls
1641 
1642         // We calculate the user's accountLiquidity and accountShortfall.
1643         (err, localResults.accountLiquidity, localResults.accountShortfall) = calculateAccountLiquidity(msg.sender);
1644         if (err != Error.NO_ERROR) {
1645             return fail(err, FailureInfo.WITHDRAW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED);
1646         }
1647 
1648         // We calculate the newSupplyIndex, user's supplyCurrent and supplyUpdated for the asset
1649         (err, localResults.newSupplyIndex) = calculateInterestIndex(market.supplyIndex, market.supplyRateMantissa, market.blockNumber, getBlockNumber());
1650         if (err != Error.NO_ERROR) {
1651             return fail(err, FailureInfo.WITHDRAW_NEW_SUPPLY_INDEX_CALCULATION_FAILED);
1652         }
1653 
1654         (err, localResults.userSupplyCurrent) = calculateBalance(supplyBalance.principal, supplyBalance.interestIndex, localResults.newSupplyIndex);
1655         if (err != Error.NO_ERROR) {
1656             return fail(err, FailureInfo.WITHDRAW_ACCUMULATED_BALANCE_CALCULATION_FAILED);
1657         }
1658 
1659         // If the user specifies -1 amount to withdraw ("max"),  withdrawAmount => the lesser of withdrawCapacity and supplyCurrent
1660         if (requestedAmount == uint(-1)) {
1661             (err, localResults.withdrawCapacity) = getAssetAmountForValue(asset, localResults.accountLiquidity);
1662             if (err != Error.NO_ERROR) {
1663                 return fail(err, FailureInfo.WITHDRAW_CAPACITY_CALCULATION_FAILED);
1664             }
1665             localResults.withdrawAmount = min(localResults.withdrawCapacity, localResults.userSupplyCurrent);
1666         } else {
1667             localResults.withdrawAmount = requestedAmount;
1668         }
1669 
1670         // From here on we should NOT use requestedAmount.
1671 
1672         // Fail gracefully if protocol has insufficient cash
1673         // If protocol has insufficient cash, the sub operation will underflow.
1674         localResults.currentCash = getCash(asset);
1675         (err, localResults.updatedCash) = sub(localResults.currentCash, localResults.withdrawAmount);
1676         if (err != Error.NO_ERROR) {
1677             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.WITHDRAW_TRANSFER_OUT_NOT_POSSIBLE);
1678         }
1679 
1680         // We check that the amount is less than or equal to supplyCurrent
1681         // If amount is greater than supplyCurrent, this will fail with Error.INTEGER_UNDERFLOW
1682         (err, localResults.userSupplyUpdated) = sub(localResults.userSupplyCurrent, localResults.withdrawAmount);
1683         if (err != Error.NO_ERROR) {
1684             return fail(Error.INSUFFICIENT_BALANCE, FailureInfo.WITHDRAW_NEW_TOTAL_BALANCE_CALCULATION_FAILED);
1685         }
1686 
1687         // Fail if customer already has a shortfall
1688         if (!isZeroExp(localResults.accountShortfall)) {
1689             return fail(Error.INSUFFICIENT_LIQUIDITY, FailureInfo.WITHDRAW_ACCOUNT_SHORTFALL_PRESENT);
1690         }
1691 
1692         // We want to know the user's withdrawCapacity, denominated in the asset
1693         // Customer's withdrawCapacity of asset is (accountLiquidity in Eth)/ (price of asset in Eth)
1694         // Equivalently, we calculate the eth value of the withdrawal amount and compare it directly to the accountLiquidity in Eth
1695         (err, localResults.ethValueOfWithdrawal) = getPriceForAssetAmount(asset, localResults.withdrawAmount); // amount * oraclePrice = ethValueOfWithdrawal
1696         if (err != Error.NO_ERROR) {
1697             return fail(err, FailureInfo.WITHDRAW_AMOUNT_VALUE_CALCULATION_FAILED);
1698         }
1699 
1700         // We check that the amount is less than withdrawCapacity (here), and less than or equal to supplyCurrent (below)
1701         if (lessThanExp(localResults.accountLiquidity, localResults.ethValueOfWithdrawal) ) {
1702             return fail(Error.INSUFFICIENT_LIQUIDITY, FailureInfo.WITHDRAW_AMOUNT_LIQUIDITY_SHORTFALL);
1703         }
1704 
1705         // We calculate the protocol's totalSupply by subtracting the user's prior checkpointed balance, adding user's updated supply.
1706         // Note that, even though the customer is withdrawing, if they've accumulated a lot of interest since their last
1707         // action, the updated balance *could* be higher than the prior checkpointed balance.
1708         (err, localResults.newTotalSupply) = addThenSub(market.totalSupply, localResults.userSupplyUpdated, supplyBalance.principal);
1709         if (err != Error.NO_ERROR) {
1710             return fail(err, FailureInfo.WITHDRAW_NEW_TOTAL_SUPPLY_CALCULATION_FAILED);
1711         }
1712 
1713         // The utilization rate has changed! We calculate a new supply index and borrow index for the asset, and save it.
1714         (rateCalculationResultCode, localResults.newSupplyRateMantissa) = market.interestRateModel.getSupplyRate(asset, localResults.updatedCash, market.totalBorrows);
1715         if (rateCalculationResultCode != 0) {
1716             return failOpaque(FailureInfo.WITHDRAW_NEW_SUPPLY_RATE_CALCULATION_FAILED, rateCalculationResultCode);
1717         }
1718 
1719         // We calculate the newBorrowIndex
1720         (err, localResults.newBorrowIndex) = calculateInterestIndex(market.borrowIndex, market.borrowRateMantissa, market.blockNumber, getBlockNumber());
1721         if (err != Error.NO_ERROR) {
1722             return fail(err, FailureInfo.WITHDRAW_NEW_BORROW_INDEX_CALCULATION_FAILED);
1723         }
1724 
1725         (rateCalculationResultCode, localResults.newBorrowRateMantissa) = market.interestRateModel.getBorrowRate(asset, localResults.updatedCash, market.totalBorrows);
1726         if (rateCalculationResultCode != 0) {
1727             return failOpaque(FailureInfo.WITHDRAW_NEW_BORROW_RATE_CALCULATION_FAILED, rateCalculationResultCode);
1728         }
1729 
1730         /////////////////////////
1731         // EFFECTS & INTERACTIONS
1732         // (No safe failures beyond this point)
1733 
1734         // We ERC-20 transfer the asset into the protocol (note: pre-conditions already checked above)
1735         err = doTransferOut(asset, msg.sender, localResults.withdrawAmount);
1736         if (err != Error.NO_ERROR) {
1737             // This is safe since it's our first interaction and it didn't do anything if it failed
1738             return fail(err, FailureInfo.WITHDRAW_TRANSFER_OUT_FAILED);
1739         }
1740 
1741         // Save market updates
1742         market.blockNumber = getBlockNumber();
1743         market.totalSupply =  localResults.newTotalSupply;
1744         market.supplyRateMantissa = localResults.newSupplyRateMantissa;
1745         market.supplyIndex = localResults.newSupplyIndex;
1746         market.borrowRateMantissa = localResults.newBorrowRateMantissa;
1747         market.borrowIndex = localResults.newBorrowIndex;
1748 
1749         // Save user updates
1750         localResults.startingBalance = supplyBalance.principal; // save for use in `SupplyWithdrawn` event
1751         supplyBalance.principal = localResults.userSupplyUpdated;
1752         supplyBalance.interestIndex = localResults.newSupplyIndex;
1753 
1754         emit SupplyWithdrawn(msg.sender, asset, localResults.withdrawAmount, localResults.startingBalance, localResults.userSupplyUpdated);
1755 
1756         return uint(Error.NO_ERROR); // success
1757     }
1758 
1759     struct AccountValueLocalVars {
1760         address assetAddress;
1761         uint collateralMarketsLength;
1762 
1763         uint newSupplyIndex;
1764         uint userSupplyCurrent;
1765         Exp supplyTotalValue;
1766         Exp sumSupplies;
1767 
1768         uint newBorrowIndex;
1769         uint userBorrowCurrent;
1770         Exp borrowTotalValue;
1771         Exp sumBorrows;
1772     }
1773 
1774     /**
1775       * @dev Gets the user's account liquidity and account shortfall balances. This includes
1776       *      any accumulated interest thus far but does NOT actually update anything in
1777       *      storage, it simply calculates the account liquidity and shortfall with liquidity being
1778       *      returned as the first Exp, ie (Error, accountLiquidity, accountShortfall).
1779       */
1780     function calculateAccountLiquidity(address userAddress) internal view returns (Error, Exp memory, Exp memory) {
1781         Error err;
1782         uint sumSupplyValuesMantissa;
1783         uint sumBorrowValuesMantissa;
1784         (err, sumSupplyValuesMantissa, sumBorrowValuesMantissa) = calculateAccountValuesInternal(userAddress);
1785         if (err != Error.NO_ERROR) {
1786             return(err, Exp({mantissa: 0}), Exp({mantissa: 0}));
1787         }
1788 
1789         Exp memory result;
1790         
1791         Exp memory sumSupplyValuesFinal = Exp({mantissa: sumSupplyValuesMantissa});
1792         Exp memory sumBorrowValuesFinal; // need to apply collateral ratio
1793 
1794         (err, sumBorrowValuesFinal) = mulExp(collateralRatio, Exp({mantissa: sumBorrowValuesMantissa}));
1795         if (err != Error.NO_ERROR) {
1796             return (err, Exp({mantissa: 0}), Exp({mantissa: 0}));
1797         }
1798 
1799         // if sumSupplies < sumBorrows, then the user is under collateralized and has account shortfall.
1800         // else the user meets the collateral ratio and has account liquidity.
1801         if (lessThanExp(sumSupplyValuesFinal, sumBorrowValuesFinal)) {
1802             // accountShortfall = borrows - supplies
1803             (err, result) = subExp(sumBorrowValuesFinal, sumSupplyValuesFinal);
1804             assert(err == Error.NO_ERROR); // Note: we have checked that sumBorrows is greater than sumSupplies directly above, therefore `subExp` cannot fail.
1805 
1806             return (Error.NO_ERROR, Exp({mantissa: 0}), result);
1807         } else {
1808             // accountLiquidity = supplies - borrows
1809             (err, result) = subExp(sumSupplyValuesFinal, sumBorrowValuesFinal);
1810             assert(err == Error.NO_ERROR); // Note: we have checked that sumSupplies is greater than sumBorrows directly above, therefore `subExp` cannot fail.
1811 
1812             return (Error.NO_ERROR, result, Exp({mantissa: 0}));
1813         }
1814     }
1815 
1816     /**
1817       * @notice Gets the ETH values of the user's accumulated supply and borrow balances, scaled by 10e18.
1818       *         This includes any accumulated interest thus far but does NOT actually update anything in
1819       *         storage
1820       * @dev Gets ETH values of accumulated supply and borrow balances
1821       * @param userAddress account for which to sum values
1822       * @return (error code, sum ETH value of supplies scaled by 10e18, sum ETH value of borrows scaled by 10e18)
1823       * TODO: Possibly should add a Min(500, collateralMarkets.length) for extra safety
1824       * TODO: To help save gas we could think about using the current Market.interestIndex
1825       *       accumulate interest rather than calculating it
1826       */
1827     function calculateAccountValuesInternal(address userAddress) internal view returns (Error, uint, uint) {
1828         
1829         /** By definition, all collateralMarkets are those that contribute to the user's
1830           * liquidity and shortfall so we need only loop through those markets.
1831           * To handle avoiding intermediate negative results, we will sum all the user's
1832           * supply balances and borrow balances (with collateral ratio) separately and then
1833           * subtract the sums at the end.
1834           */
1835 
1836         AccountValueLocalVars memory localResults; // Re-used for all intermediate results
1837         localResults.sumSupplies = Exp({mantissa: 0});
1838         localResults.sumBorrows = Exp({mantissa: 0});
1839         Error err; // Re-used for all intermediate errors
1840         localResults.collateralMarketsLength = collateralMarkets.length;
1841 
1842         for (uint i = 0; i < localResults.collateralMarketsLength; i++) {
1843             localResults.assetAddress = collateralMarkets[i];
1844             Market storage currentMarket = markets[localResults.assetAddress];
1845             Balance storage supplyBalance = supplyBalances[userAddress][localResults.assetAddress];
1846             Balance storage borrowBalance = borrowBalances[userAddress][localResults.assetAddress];
1847 
1848             if (supplyBalance.principal > 0) {
1849                 // We calculate the newSupplyIndex and user’s supplyCurrent (includes interest)
1850                 (err, localResults.newSupplyIndex) = calculateInterestIndex(currentMarket.supplyIndex, currentMarket.supplyRateMantissa, currentMarket.blockNumber, getBlockNumber());
1851                 if (err != Error.NO_ERROR) {
1852                     return (err, 0, 0);
1853                 }
1854 
1855                 (err, localResults.userSupplyCurrent) = calculateBalance(supplyBalance.principal, supplyBalance.interestIndex, localResults.newSupplyIndex);
1856                 if (err != Error.NO_ERROR) {
1857                     return (err, 0, 0);
1858                 }
1859 
1860                 // We have the user's supply balance with interest so let's multiply by the asset price to get the total value
1861                 (err, localResults.supplyTotalValue) = getPriceForAssetAmount(localResults.assetAddress, localResults.userSupplyCurrent); // supplyCurrent * oraclePrice = supplyValueInEth
1862                 if (err != Error.NO_ERROR) {
1863                     return (err, 0, 0);
1864                 }
1865 
1866                 // Add this to our running sum of supplies
1867                 (err, localResults.sumSupplies) = addExp(localResults.supplyTotalValue, localResults.sumSupplies);
1868                 if (err != Error.NO_ERROR) {
1869                     return (err, 0, 0);
1870                 }
1871             }
1872 
1873             if (borrowBalance.principal > 0) {
1874                 // We perform a similar actions to get the user's borrow balance
1875                 (err, localResults.newBorrowIndex) = calculateInterestIndex(currentMarket.borrowIndex, currentMarket.borrowRateMantissa, currentMarket.blockNumber, getBlockNumber());
1876                 if (err != Error.NO_ERROR) {
1877                     return (err, 0, 0);
1878                 }
1879 
1880                 (err, localResults.userBorrowCurrent) = calculateBalance(borrowBalance.principal, borrowBalance.interestIndex, localResults.newBorrowIndex);
1881                 if (err != Error.NO_ERROR) {
1882                     return (err, 0, 0);
1883                 }
1884 
1885                 // In the case of borrow, we multiply the borrow value by the collateral ratio
1886                 (err, localResults.borrowTotalValue) = getPriceForAssetAmount(localResults.assetAddress, localResults.userBorrowCurrent); // ( borrowCurrent* oraclePrice * collateralRatio) = borrowTotalValueInEth
1887                 if (err != Error.NO_ERROR) {
1888                     return (err, 0, 0);
1889                 }
1890 
1891                 // Add this to our running sum of borrows
1892                 (err, localResults.sumBorrows) = addExp(localResults.borrowTotalValue, localResults.sumBorrows);
1893                 if (err != Error.NO_ERROR) {
1894                     return (err, 0, 0);
1895                 }
1896             }
1897         }
1898         
1899         return (Error.NO_ERROR, localResults.sumSupplies.mantissa, localResults.sumBorrows.mantissa);
1900     }
1901 
1902     /**
1903       * @notice Gets the ETH values of the user's accumulated supply and borrow balances, scaled by 10e18.
1904       *         This includes any accumulated interest thus far but does NOT actually update anything in
1905       *         storage
1906       * @dev Gets ETH values of accumulated supply and borrow balances
1907       * @param userAddress account for which to sum values
1908       * @return (uint 0=success; otherwise a failure (see ErrorReporter.sol for details),
1909       *          sum ETH value of supplies scaled by 10e18,
1910       *          sum ETH value of borrows scaled by 10e18)
1911       */
1912     function calculateAccountValues(address userAddress) public view returns (uint, uint, uint) {
1913         (Error err, uint supplyValue, uint borrowValue) = calculateAccountValuesInternal(userAddress);
1914         if (err != Error.NO_ERROR) {
1915 
1916             return (uint(err), 0, 0);
1917         }
1918 
1919         return (0, supplyValue, borrowValue);
1920     }
1921 
1922     struct PayBorrowLocalVars {
1923         uint newBorrowIndex;
1924         uint userBorrowCurrent;
1925         uint repayAmount;
1926 
1927         uint userBorrowUpdated;
1928         uint newTotalBorrows;
1929         uint currentCash;
1930         uint updatedCash;
1931 
1932         uint newSupplyIndex;
1933         uint newSupplyRateMantissa;
1934         uint newBorrowRateMantissa;
1935 
1936         uint startingBalance;
1937     }
1938 
1939     /**
1940       * @notice Users repay borrowed assets from their own address to the protocol.
1941       * @param asset The market asset to repay
1942       * @param amount The amount to repay (or -1 for max)
1943       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1944       */
1945     function repayBorrow(address asset, uint amount) public returns (uint) {
1946         if (paused) {
1947             return fail(Error.CONTRACT_PAUSED, FailureInfo.REPAY_BORROW_CONTRACT_PAUSED);
1948         }
1949         PayBorrowLocalVars memory localResults;
1950         Market storage market = markets[asset];
1951         Balance storage borrowBalance = borrowBalances[msg.sender][asset];
1952         Error err;
1953         uint rateCalculationResultCode;
1954 
1955         // We calculate the newBorrowIndex, user's borrowCurrent and borrowUpdated for the asset
1956         (err, localResults.newBorrowIndex) = calculateInterestIndex(market.borrowIndex, market.borrowRateMantissa, market.blockNumber, getBlockNumber());
1957         if (err != Error.NO_ERROR) {
1958             return fail(err, FailureInfo.REPAY_BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED);
1959         }
1960 
1961         (err, localResults.userBorrowCurrent) = calculateBalance(borrowBalance.principal, borrowBalance.interestIndex, localResults.newBorrowIndex);
1962         if (err != Error.NO_ERROR) {
1963             return fail(err, FailureInfo.REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED);
1964         }
1965 
1966         // If the user specifies -1 amount to repay (“max”), repayAmount =>
1967         // the lesser of the senders ERC-20 balance and borrowCurrent
1968         if (amount == uint(-1)) {
1969             localResults.repayAmount = min(getBalanceOf(asset, msg.sender), localResults.userBorrowCurrent);
1970         } else {
1971             localResults.repayAmount = amount;
1972         }
1973 
1974         // Subtract the `repayAmount` from the `userBorrowCurrent` to get `userBorrowUpdated`
1975         // Note: this checks that repayAmount is less than borrowCurrent
1976         (err, localResults.userBorrowUpdated) = sub(localResults.userBorrowCurrent, localResults.repayAmount);
1977         if (err != Error.NO_ERROR) {
1978             return fail(err, FailureInfo.REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED);
1979         }
1980 
1981         // Fail gracefully if asset is not approved or has insufficient balance
1982         // Note: this checks that repayAmount is less than or equal to their ERC-20 balance
1983         err = checkTransferIn(asset, msg.sender, localResults.repayAmount);
1984         if (err != Error.NO_ERROR) {
1985             return fail(err, FailureInfo.REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE);
1986         }
1987 
1988         // We calculate the protocol's totalBorrow by subtracting the user's prior checkpointed balance, adding user's updated borrow
1989         // Note that, even though the customer is paying some of their borrow, if they've accumulated a lot of interest since their last
1990         // action, the updated balance *could* be higher than the prior checkpointed balance.
1991         (err, localResults.newTotalBorrows) = addThenSub(market.totalBorrows, localResults.userBorrowUpdated, borrowBalance.principal);
1992         if (err != Error.NO_ERROR) {
1993             return fail(err, FailureInfo.REPAY_BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED);
1994         }
1995 
1996         // We need to calculate what the updated cash will be after we transfer in from user
1997         localResults.currentCash = getCash(asset);
1998 
1999         (err, localResults.updatedCash) = add(localResults.currentCash, localResults.repayAmount);
2000         if (err != Error.NO_ERROR) {
2001             return fail(err, FailureInfo.REPAY_BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED);
2002         }
2003 
2004         // The utilization rate has changed! We calculate a new supply index and borrow index for the asset, and save it.
2005 
2006         // We calculate the newSupplyIndex, but we have newBorrowIndex already
2007         (err, localResults.newSupplyIndex) = calculateInterestIndex(market.supplyIndex, market.supplyRateMantissa, market.blockNumber, getBlockNumber());
2008         if (err != Error.NO_ERROR) {
2009             return fail(err, FailureInfo.REPAY_BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED);
2010         }
2011 
2012         (rateCalculationResultCode, localResults.newSupplyRateMantissa) = market.interestRateModel.getSupplyRate(asset, localResults.updatedCash, localResults.newTotalBorrows);
2013         if (rateCalculationResultCode != 0) {
2014             return failOpaque(FailureInfo.REPAY_BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED, rateCalculationResultCode);
2015         }
2016 
2017         (rateCalculationResultCode, localResults.newBorrowRateMantissa) = market.interestRateModel.getBorrowRate(asset, localResults.updatedCash, localResults.newTotalBorrows);
2018         if (rateCalculationResultCode != 0) {
2019             return failOpaque(FailureInfo.REPAY_BORROW_NEW_BORROW_RATE_CALCULATION_FAILED, rateCalculationResultCode);
2020         }
2021 
2022         /////////////////////////
2023         // EFFECTS & INTERACTIONS
2024         // (No safe failures beyond this point)
2025 
2026         // We ERC-20 transfer the asset into the protocol (note: pre-conditions already checked above)
2027         err = doTransferIn(asset, msg.sender, localResults.repayAmount);
2028         if (err != Error.NO_ERROR) {
2029             // This is safe since it's our first interaction and it didn't do anything if it failed
2030             return fail(err, FailureInfo.REPAY_BORROW_TRANSFER_IN_FAILED);
2031         }
2032 
2033         // Save market updates
2034         market.blockNumber = getBlockNumber();
2035         market.totalBorrows =  localResults.newTotalBorrows;
2036         market.supplyRateMantissa = localResults.newSupplyRateMantissa;
2037         market.supplyIndex = localResults.newSupplyIndex;
2038         market.borrowRateMantissa = localResults.newBorrowRateMantissa;
2039         market.borrowIndex = localResults.newBorrowIndex;
2040 
2041         // Save user updates
2042         localResults.startingBalance = borrowBalance.principal; // save for use in `BorrowRepaid` event
2043         borrowBalance.principal = localResults.userBorrowUpdated;
2044         borrowBalance.interestIndex = localResults.newBorrowIndex;
2045 
2046         emit BorrowRepaid(msg.sender, asset, localResults.repayAmount, localResults.startingBalance, localResults.userBorrowUpdated);
2047 
2048         return uint(Error.NO_ERROR); // success
2049     }
2050 
2051     struct BorrowLocalVars {
2052         uint newBorrowIndex;
2053         uint userBorrowCurrent;
2054         uint borrowAmountWithFee;
2055 
2056         uint userBorrowUpdated;
2057         uint newTotalBorrows;
2058         uint currentCash;
2059         uint updatedCash;
2060 
2061         uint newSupplyIndex;
2062         uint newSupplyRateMantissa;
2063         uint newBorrowRateMantissa;
2064 
2065         uint startingBalance;
2066 
2067         Exp accountLiquidity;
2068         Exp accountShortfall;
2069         Exp ethValueOfBorrowAmountWithFee;
2070     }
2071 
2072     struct LiquidateLocalVars {
2073         // we need these addresses in the struct for use with `emitLiquidationEvent` to avoid `CompilerError: Stack too deep, try removing local variables.`
2074         address targetAccount;
2075         address assetBorrow;
2076         address liquidator;
2077         address assetCollateral;
2078 
2079         // borrow index and supply index are global to the asset, not specific to the user
2080         uint newBorrowIndex_UnderwaterAsset;
2081         uint newSupplyIndex_UnderwaterAsset;
2082         uint newBorrowIndex_CollateralAsset;
2083         uint newSupplyIndex_CollateralAsset;
2084 
2085         // the target borrow's full balance with accumulated interest
2086         uint currentBorrowBalance_TargetUnderwaterAsset;
2087         // currentBorrowBalance_TargetUnderwaterAsset minus whatever gets repaid as part of the liquidation
2088         uint updatedBorrowBalance_TargetUnderwaterAsset;
2089 
2090         uint newTotalBorrows_ProtocolUnderwaterAsset;
2091 
2092         uint startingBorrowBalance_TargetUnderwaterAsset;
2093         uint startingSupplyBalance_TargetCollateralAsset;
2094         uint startingSupplyBalance_LiquidatorCollateralAsset;
2095 
2096         uint currentSupplyBalance_TargetCollateralAsset;
2097         uint updatedSupplyBalance_TargetCollateralAsset;
2098 
2099         // If liquidator already has a balance of collateralAsset, we will accumulate
2100         // interest on it before transferring seized collateral from the borrower.
2101         uint currentSupplyBalance_LiquidatorCollateralAsset;
2102         // This will be the liquidator's accumulated balance of collateral asset before the liquidation (if any)
2103         // plus the amount seized from the borrower.
2104         uint updatedSupplyBalance_LiquidatorCollateralAsset;
2105 
2106         uint newTotalSupply_ProtocolCollateralAsset;
2107         uint currentCash_ProtocolUnderwaterAsset;
2108         uint updatedCash_ProtocolUnderwaterAsset;
2109 
2110         // cash does not change for collateral asset
2111 
2112         uint newSupplyRateMantissa_ProtocolUnderwaterAsset;
2113         uint newBorrowRateMantissa_ProtocolUnderwaterAsset;
2114 
2115         // Why no variables for the interest rates for the collateral asset?
2116         // We don't need to calculate new rates for the collateral asset since neither cash nor borrows change
2117 
2118         uint discountedRepayToEvenAmount;
2119 
2120         //[supplyCurrent / (1 + liquidationDiscount)] * (Oracle price for the collateral / Oracle price for the borrow) (discountedBorrowDenominatedCollateral)
2121         uint discountedBorrowDenominatedCollateral;
2122 
2123         uint maxCloseableBorrowAmount_TargetUnderwaterAsset;
2124         uint closeBorrowAmount_TargetUnderwaterAsset;
2125         uint seizeSupplyAmount_TargetCollateralAsset;
2126 
2127         Exp collateralPrice;
2128         Exp underwaterAssetPrice;
2129     }
2130 
2131     /**
2132       * @notice users repay all or some of an underwater borrow and receive collateral
2133       * @param targetAccount The account whose borrow should be liquidated
2134       * @param assetBorrow The market asset to repay
2135       * @param assetCollateral The borrower's market asset to receive in exchange
2136       * @param requestedAmountClose The amount to repay (or -1 for max)
2137       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2138       */
2139     function liquidateBorrow(address targetAccount, address assetBorrow, address assetCollateral, uint requestedAmountClose) public returns (uint) {
2140         if (paused) {
2141             return fail(Error.CONTRACT_PAUSED, FailureInfo.LIQUIDATE_CONTRACT_PAUSED);
2142         }
2143         LiquidateLocalVars memory localResults;
2144         // Copy these addresses into the struct for use with `emitLiquidationEvent`
2145         // We'll use localResults.liquidator inside this function for clarity vs using msg.sender.
2146         localResults.targetAccount = targetAccount;
2147         localResults.assetBorrow = assetBorrow;
2148         localResults.liquidator = msg.sender;
2149         localResults.assetCollateral = assetCollateral;
2150 
2151         Market storage borrowMarket = markets[assetBorrow];
2152         Market storage collateralMarket = markets[assetCollateral];
2153         Balance storage borrowBalance_TargeUnderwaterAsset = borrowBalances[targetAccount][assetBorrow];
2154         Balance storage supplyBalance_TargetCollateralAsset = supplyBalances[targetAccount][assetCollateral];
2155 
2156         // Liquidator might already hold some of the collateral asset
2157         Balance storage supplyBalance_LiquidatorCollateralAsset = supplyBalances[localResults.liquidator][assetCollateral];
2158 
2159         uint rateCalculationResultCode; // Used for multiple interest rate calculation calls
2160         Error err; // re-used for all intermediate errors
2161 
2162         (err, localResults.collateralPrice) = fetchAssetPrice(assetCollateral);
2163         if(err != Error.NO_ERROR) {
2164             return fail(err, FailureInfo.LIQUIDATE_FETCH_ASSET_PRICE_FAILED);
2165         }
2166 
2167         (err, localResults.underwaterAssetPrice) = fetchAssetPrice(assetBorrow);
2168         // If the price oracle is not set, then we would have failed on the first call to fetchAssetPrice
2169         assert(err == Error.NO_ERROR);
2170 
2171         // We calculate newBorrowIndex_UnderwaterAsset and then use it to help calculate currentBorrowBalance_TargetUnderwaterAsset
2172         (err, localResults.newBorrowIndex_UnderwaterAsset) = calculateInterestIndex(borrowMarket.borrowIndex, borrowMarket.borrowRateMantissa, borrowMarket.blockNumber, getBlockNumber());
2173         if (err != Error.NO_ERROR) {
2174             return fail(err, FailureInfo.LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_BORROWED_ASSET);
2175         }
2176 
2177         (err, localResults.currentBorrowBalance_TargetUnderwaterAsset) = calculateBalance(borrowBalance_TargeUnderwaterAsset.principal, borrowBalance_TargeUnderwaterAsset.interestIndex, localResults.newBorrowIndex_UnderwaterAsset);
2178         if (err != Error.NO_ERROR) {
2179             return fail(err, FailureInfo.LIQUIDATE_ACCUMULATED_BORROW_BALANCE_CALCULATION_FAILED);
2180         }
2181 
2182         // We calculate newSupplyIndex_CollateralAsset and then use it to help calculate currentSupplyBalance_TargetCollateralAsset
2183         (err, localResults.newSupplyIndex_CollateralAsset) = calculateInterestIndex(collateralMarket.supplyIndex, collateralMarket.supplyRateMantissa, collateralMarket.blockNumber, getBlockNumber());
2184         if (err != Error.NO_ERROR) {
2185             return fail(err, FailureInfo.LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET);
2186         }
2187 
2188         (err, localResults.currentSupplyBalance_TargetCollateralAsset) = calculateBalance(supplyBalance_TargetCollateralAsset.principal, supplyBalance_TargetCollateralAsset.interestIndex, localResults.newSupplyIndex_CollateralAsset);
2189         if (err != Error.NO_ERROR) {
2190             return fail(err, FailureInfo.LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET);
2191         }
2192 
2193         // Liquidator may or may not already have some collateral asset.
2194         // If they do, we need to accumulate interest on it before adding the seized collateral to it.
2195         // We re-use newSupplyIndex_CollateralAsset calculated above to help calculate currentSupplyBalance_LiquidatorCollateralAsset
2196         (err, localResults.currentSupplyBalance_LiquidatorCollateralAsset) = calculateBalance(supplyBalance_LiquidatorCollateralAsset.principal, supplyBalance_LiquidatorCollateralAsset.interestIndex, localResults.newSupplyIndex_CollateralAsset);
2197         if (err != Error.NO_ERROR) {
2198             return fail(err, FailureInfo.LIQUIDATE_ACCUMULATED_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET);
2199         }
2200 
2201         // We update the protocol's totalSupply for assetCollateral in 2 steps, first by adding target user's accumulated
2202         // interest and then by adding the liquidator's accumulated interest.
2203 
2204         // Step 1 of 2: We add the target user's supplyCurrent and subtract their checkpointedBalance
2205         // (which has the desired effect of adding accrued interest from the target user)
2206         (err, localResults.newTotalSupply_ProtocolCollateralAsset) = addThenSub(collateralMarket.totalSupply, localResults.currentSupplyBalance_TargetCollateralAsset, supplyBalance_TargetCollateralAsset.principal);
2207         if (err != Error.NO_ERROR) {
2208             return fail(err, FailureInfo.LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_BORROWER_COLLATERAL_ASSET);
2209         }
2210 
2211         // Step 2 of 2: We add the liquidator's supplyCurrent of collateral asset and subtract their checkpointedBalance
2212         // (which has the desired effect of adding accrued interest from the calling user)
2213         (err, localResults.newTotalSupply_ProtocolCollateralAsset) = addThenSub(localResults.newTotalSupply_ProtocolCollateralAsset, localResults.currentSupplyBalance_LiquidatorCollateralAsset, supplyBalance_LiquidatorCollateralAsset.principal);
2214         if (err != Error.NO_ERROR) {
2215             return fail(err, FailureInfo.LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET);
2216         }
2217 
2218         // We calculate maxCloseableBorrowAmount_TargetUnderwaterAsset, the amount of borrow that can be closed from the target user
2219         // This is equal to the lesser of
2220         // 1. borrowCurrent; (already calculated)
2221         // 2. ONLY IF MARKET SUPPORTED: discountedRepayToEvenAmount:
2222         // discountedRepayToEvenAmount=
2223         //      shortfall / [Oracle price for the borrow * (collateralRatio - liquidationDiscount - 1)]
2224         // 3. discountedBorrowDenominatedCollateral
2225         //      [supplyCurrent / (1 + liquidationDiscount)] * (Oracle price for the collateral / Oracle price for the borrow)
2226 
2227         // Here we calculate item 3. discountedBorrowDenominatedCollateral =
2228         // [supplyCurrent / (1 + liquidationDiscount)] * (Oracle price for the collateral / Oracle price for the borrow)
2229         (err, localResults.discountedBorrowDenominatedCollateral) =
2230         calculateDiscountedBorrowDenominatedCollateral(localResults.underwaterAssetPrice, localResults.collateralPrice, localResults.currentSupplyBalance_TargetCollateralAsset);
2231         if (err != Error.NO_ERROR) {
2232             return fail(err, FailureInfo.LIQUIDATE_BORROW_DENOMINATED_COLLATERAL_CALCULATION_FAILED);
2233         }
2234 
2235         if (borrowMarket.isSupported) {
2236             // Market is supported, so we calculate item 2 from above.
2237             (err, localResults.discountedRepayToEvenAmount) =
2238             calculateDiscountedRepayToEvenAmount(targetAccount, localResults.underwaterAssetPrice);
2239             if (err != Error.NO_ERROR) {
2240                 return fail(err, FailureInfo.LIQUIDATE_DISCOUNTED_REPAY_TO_EVEN_AMOUNT_CALCULATION_FAILED);
2241             }
2242 
2243             // We need to do a two-step min to select from all 3 values
2244             // min1&3 = min(item 1, item 3)
2245             localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset = min(localResults.currentBorrowBalance_TargetUnderwaterAsset, localResults.discountedBorrowDenominatedCollateral);
2246 
2247             // min1&3&2 = min(min1&3, 2)
2248             localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset = min(localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset, localResults.discountedRepayToEvenAmount);
2249         } else {
2250             // Market is not supported, so we don't need to calculate item 2.
2251             localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset = min(localResults.currentBorrowBalance_TargetUnderwaterAsset, localResults.discountedBorrowDenominatedCollateral);
2252         }
2253 
2254         // If liquidateBorrowAmount = -1, then closeBorrowAmount_TargetUnderwaterAsset = maxCloseableBorrowAmount_TargetUnderwaterAsset
2255         if (requestedAmountClose == uint(-1)) {
2256             localResults.closeBorrowAmount_TargetUnderwaterAsset = localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset;
2257         } else {
2258             localResults.closeBorrowAmount_TargetUnderwaterAsset = requestedAmountClose;
2259         }
2260 
2261         // From here on, no more use of `requestedAmountClose`
2262 
2263         // Verify closeBorrowAmount_TargetUnderwaterAsset <= maxCloseableBorrowAmount_TargetUnderwaterAsset
2264         if (localResults.closeBorrowAmount_TargetUnderwaterAsset > localResults.maxCloseableBorrowAmount_TargetUnderwaterAsset) {
2265             return fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_TOO_HIGH);
2266         }
2267 
2268         // seizeSupplyAmount_TargetCollateralAsset = closeBorrowAmount_TargetUnderwaterAsset * priceBorrow/priceCollateral *(1+liquidationDiscount)
2269         (err, localResults.seizeSupplyAmount_TargetCollateralAsset) = calculateAmountSeize(localResults.underwaterAssetPrice, localResults.collateralPrice, localResults.closeBorrowAmount_TargetUnderwaterAsset);
2270         if (err != Error.NO_ERROR) {
2271             return fail(err, FailureInfo.LIQUIDATE_AMOUNT_SEIZE_CALCULATION_FAILED);
2272         }
2273 
2274         // We are going to ERC-20 transfer closeBorrowAmount_TargetUnderwaterAsset of assetBorrow into Compound
2275         // Fail gracefully if asset is not approved or has insufficient balance
2276         err = checkTransferIn(assetBorrow, localResults.liquidator, localResults.closeBorrowAmount_TargetUnderwaterAsset);
2277         if (err != Error.NO_ERROR) {
2278             return fail(err, FailureInfo.LIQUIDATE_TRANSFER_IN_NOT_POSSIBLE);
2279         }
2280 
2281         // We are going to repay the target user's borrow using the calling user's funds
2282         // We update the protocol's totalBorrow for assetBorrow, by subtracting the target user's prior checkpointed balance,
2283         // adding borrowCurrent, and subtracting closeBorrowAmount_TargetUnderwaterAsset.
2284 
2285         // Subtract the `closeBorrowAmount_TargetUnderwaterAsset` from the `currentBorrowBalance_TargetUnderwaterAsset` to get `updatedBorrowBalance_TargetUnderwaterAsset`
2286         (err, localResults.updatedBorrowBalance_TargetUnderwaterAsset) = sub(localResults.currentBorrowBalance_TargetUnderwaterAsset, localResults.closeBorrowAmount_TargetUnderwaterAsset);
2287         // We have ensured above that localResults.closeBorrowAmount_TargetUnderwaterAsset <= localResults.currentBorrowBalance_TargetUnderwaterAsset, so the sub can't underflow
2288         assert(err == Error.NO_ERROR);
2289 
2290         // We calculate the protocol's totalBorrow for assetBorrow by subtracting the user's prior checkpointed balance, adding user's updated borrow
2291         // Note that, even though the liquidator is paying some of the borrow, if the borrow has accumulated a lot of interest since the last
2292         // action, the updated balance *could* be higher than the prior checkpointed balance.
2293         (err, localResults.newTotalBorrows_ProtocolUnderwaterAsset) = addThenSub(borrowMarket.totalBorrows, localResults.updatedBorrowBalance_TargetUnderwaterAsset, borrowBalance_TargeUnderwaterAsset.principal);
2294         if (err != Error.NO_ERROR) {
2295             return fail(err, FailureInfo.LIQUIDATE_NEW_TOTAL_BORROW_CALCULATION_FAILED_BORROWED_ASSET);
2296         }
2297 
2298         // We need to calculate what the updated cash will be after we transfer in from liquidator
2299         localResults.currentCash_ProtocolUnderwaterAsset = getCash(assetBorrow);
2300         (err, localResults.updatedCash_ProtocolUnderwaterAsset) = add(localResults.currentCash_ProtocolUnderwaterAsset, localResults.closeBorrowAmount_TargetUnderwaterAsset);
2301         if (err != Error.NO_ERROR) {
2302             return fail(err, FailureInfo.LIQUIDATE_NEW_TOTAL_CASH_CALCULATION_FAILED_BORROWED_ASSET);
2303         }
2304 
2305         // The utilization rate has changed! We calculate a new supply index, borrow index, supply rate, and borrow rate for assetBorrow
2306         // (Please note that we don't need to do the same thing for assetCollateral because neither cash nor borrows of assetCollateral happen in this process.)
2307 
2308         // We calculate the newSupplyIndex_UnderwaterAsset, but we already have newBorrowIndex_UnderwaterAsset so don't recalculate it.
2309         (err, localResults.newSupplyIndex_UnderwaterAsset) = calculateInterestIndex(borrowMarket.supplyIndex, borrowMarket.supplyRateMantissa, borrowMarket.blockNumber, getBlockNumber());
2310         if (err != Error.NO_ERROR) {
2311             return fail(err, FailureInfo.LIQUIDATE_NEW_SUPPLY_INDEX_CALCULATION_FAILED_BORROWED_ASSET);
2312         }
2313 
2314         (rateCalculationResultCode, localResults.newSupplyRateMantissa_ProtocolUnderwaterAsset) = borrowMarket.interestRateModel.getSupplyRate(assetBorrow, localResults.updatedCash_ProtocolUnderwaterAsset, localResults.newTotalBorrows_ProtocolUnderwaterAsset);
2315         if (rateCalculationResultCode != 0) {
2316             return failOpaque(FailureInfo.LIQUIDATE_NEW_SUPPLY_RATE_CALCULATION_FAILED_BORROWED_ASSET, rateCalculationResultCode);
2317         }
2318 
2319         (rateCalculationResultCode, localResults.newBorrowRateMantissa_ProtocolUnderwaterAsset) = borrowMarket.interestRateModel.getBorrowRate(assetBorrow, localResults.updatedCash_ProtocolUnderwaterAsset, localResults.newTotalBorrows_ProtocolUnderwaterAsset);
2320         if (rateCalculationResultCode != 0) {
2321             return failOpaque(FailureInfo.LIQUIDATE_NEW_BORROW_RATE_CALCULATION_FAILED_BORROWED_ASSET, rateCalculationResultCode);
2322         }
2323 
2324         // Now we look at collateral. We calculated target user's accumulated supply balance and the supply index above.
2325         // Now we need to calculate the borrow index.
2326         // We don't need to calculate new rates for the collateral asset because we have not changed utilization:
2327         //  - accumulating interest on the target user's collateral does not change cash or borrows
2328         //  - transferring seized amount of collateral internally from the target user to the liquidator does not change cash or borrows.
2329         (err, localResults.newBorrowIndex_CollateralAsset) = calculateInterestIndex(collateralMarket.borrowIndex, collateralMarket.borrowRateMantissa, collateralMarket.blockNumber, getBlockNumber());
2330         if (err != Error.NO_ERROR) {
2331             return fail(err, FailureInfo.LIQUIDATE_NEW_BORROW_INDEX_CALCULATION_FAILED_COLLATERAL_ASSET);
2332         }
2333 
2334         // We checkpoint the target user's assetCollateral supply balance, supplyCurrent - seizeSupplyAmount_TargetCollateralAsset at the updated index
2335         (err, localResults.updatedSupplyBalance_TargetCollateralAsset) = sub(localResults.currentSupplyBalance_TargetCollateralAsset, localResults.seizeSupplyAmount_TargetCollateralAsset);
2336         // The sub won't underflow because because seizeSupplyAmount_TargetCollateralAsset <= target user's collateral balance
2337         // maxCloseableBorrowAmount_TargetUnderwaterAsset is limited by the discounted borrow denominated collateral. That limits closeBorrowAmount_TargetUnderwaterAsset
2338         // which in turn limits seizeSupplyAmount_TargetCollateralAsset.
2339         assert (err == Error.NO_ERROR);
2340 
2341         // We checkpoint the liquidating user's assetCollateral supply balance, supplyCurrent + seizeSupplyAmount_TargetCollateralAsset at the updated index
2342         (err, localResults.updatedSupplyBalance_LiquidatorCollateralAsset) = add(localResults.currentSupplyBalance_LiquidatorCollateralAsset, localResults.seizeSupplyAmount_TargetCollateralAsset);
2343         // We can't overflow here because if this would overflow, then we would have already overflowed above and failed
2344         // with LIQUIDATE_NEW_TOTAL_SUPPLY_BALANCE_CALCULATION_FAILED_LIQUIDATOR_COLLATERAL_ASSET
2345         assert (err == Error.NO_ERROR);
2346 
2347         /////////////////////////
2348         // EFFECTS & INTERACTIONS
2349         // (No safe failures beyond this point)
2350 
2351         // We ERC-20 transfer the asset into the protocol (note: pre-conditions already checked above)
2352         err = doTransferIn(assetBorrow, localResults.liquidator, localResults.closeBorrowAmount_TargetUnderwaterAsset);
2353         if (err != Error.NO_ERROR) {
2354             // This is safe since it's our first interaction and it didn't do anything if it failed
2355             return fail(err, FailureInfo.LIQUIDATE_TRANSFER_IN_FAILED);
2356         }
2357 
2358         // Save borrow market updates
2359         borrowMarket.blockNumber = getBlockNumber();
2360         borrowMarket.totalBorrows = localResults.newTotalBorrows_ProtocolUnderwaterAsset;
2361         // borrowMarket.totalSupply does not need to be updated
2362         borrowMarket.supplyRateMantissa = localResults.newSupplyRateMantissa_ProtocolUnderwaterAsset;
2363         borrowMarket.supplyIndex = localResults.newSupplyIndex_UnderwaterAsset;
2364         borrowMarket.borrowRateMantissa = localResults.newBorrowRateMantissa_ProtocolUnderwaterAsset;
2365         borrowMarket.borrowIndex = localResults.newBorrowIndex_UnderwaterAsset;
2366 
2367         // Save collateral market updates
2368         // We didn't calculate new rates for collateralMarket (because neither cash nor borrows changed), just new indexes and total supply.
2369         collateralMarket.blockNumber = getBlockNumber();
2370         collateralMarket.totalSupply = localResults.newTotalSupply_ProtocolCollateralAsset;
2371         collateralMarket.supplyIndex = localResults.newSupplyIndex_CollateralAsset;
2372         collateralMarket.borrowIndex = localResults.newBorrowIndex_CollateralAsset;
2373 
2374         // Save user updates
2375 
2376         localResults.startingBorrowBalance_TargetUnderwaterAsset = borrowBalance_TargeUnderwaterAsset.principal; // save for use in event
2377         borrowBalance_TargeUnderwaterAsset.principal = localResults.updatedBorrowBalance_TargetUnderwaterAsset;
2378         borrowBalance_TargeUnderwaterAsset.interestIndex = localResults.newBorrowIndex_UnderwaterAsset;
2379 
2380         localResults.startingSupplyBalance_TargetCollateralAsset = supplyBalance_TargetCollateralAsset.principal; // save for use in event
2381         supplyBalance_TargetCollateralAsset.principal = localResults.updatedSupplyBalance_TargetCollateralAsset;
2382         supplyBalance_TargetCollateralAsset.interestIndex = localResults.newSupplyIndex_CollateralAsset;
2383 
2384         localResults.startingSupplyBalance_LiquidatorCollateralAsset = supplyBalance_LiquidatorCollateralAsset.principal; // save for use in event
2385         supplyBalance_LiquidatorCollateralAsset.principal = localResults.updatedSupplyBalance_LiquidatorCollateralAsset;
2386         supplyBalance_LiquidatorCollateralAsset.interestIndex = localResults.newSupplyIndex_CollateralAsset;
2387 
2388         emitLiquidationEvent(localResults);
2389 
2390         return uint(Error.NO_ERROR); // success
2391     }
2392 
2393     /**
2394       * @dev this function exists to avoid error `CompilerError: Stack too deep, try removing local variables.` in `liquidateBorrow`
2395       */
2396     function emitLiquidationEvent(LiquidateLocalVars memory localResults) internal {
2397         // event BorrowLiquidated(address targetAccount, address assetBorrow, uint borrowBalanceBefore, uint borrowBalanceAccumulated, uint amountRepaid, uint borrowBalanceAfter,
2398         // address liquidator, address assetCollateral, uint collateralBalanceBefore, uint collateralBalanceAccumulated, uint amountSeized, uint collateralBalanceAfter);
2399         emit BorrowLiquidated(localResults.targetAccount,
2400             localResults.assetBorrow,
2401             localResults.startingBorrowBalance_TargetUnderwaterAsset,
2402             localResults.currentBorrowBalance_TargetUnderwaterAsset,
2403             localResults.closeBorrowAmount_TargetUnderwaterAsset,
2404             localResults.updatedBorrowBalance_TargetUnderwaterAsset,
2405             localResults.liquidator,
2406             localResults.assetCollateral,
2407             localResults.startingSupplyBalance_TargetCollateralAsset,
2408             localResults.currentSupplyBalance_TargetCollateralAsset,
2409             localResults.seizeSupplyAmount_TargetCollateralAsset,
2410             localResults.updatedSupplyBalance_TargetCollateralAsset);
2411     }
2412 
2413     /**
2414       * @dev This should ONLY be called if market is supported. It returns shortfall / [Oracle price for the borrow * (collateralRatio - liquidationDiscount - 1)]
2415       *      If the market isn't supported, we support liquidation of asset regardless of shortfall because we want borrows of the unsupported asset to be closed.
2416       *      Note that if collateralRatio = liquidationDiscount + 1, then the denominator will be zero and the function will fail with DIVISION_BY_ZERO.
2417       **/
2418     function calculateDiscountedRepayToEvenAmount(address targetAccount, Exp memory underwaterAssetPrice) internal view returns (Error, uint) {
2419         Error err;
2420         Exp memory _accountLiquidity; // unused return value from calculateAccountLiquidity
2421         Exp memory accountShortfall_TargetUser;
2422         Exp memory collateralRatioMinusLiquidationDiscount; // collateralRatio - liquidationDiscount
2423         Exp memory discountedCollateralRatioMinusOne; // collateralRatioMinusLiquidationDiscount - 1, aka collateralRatio - liquidationDiscount - 1
2424         Exp memory discountedPrice_UnderwaterAsset;
2425         Exp memory rawResult;
2426 
2427         // we calculate the target user's shortfall, denominated in Ether, that the user is below the collateral ratio
2428         (err, _accountLiquidity, accountShortfall_TargetUser) = calculateAccountLiquidity(targetAccount);
2429         if (err != Error.NO_ERROR) {
2430             return (err, 0);
2431         }
2432 
2433         (err, collateralRatioMinusLiquidationDiscount) = subExp(collateralRatio, liquidationDiscount);
2434         if (err != Error.NO_ERROR) {
2435             return (err, 0);
2436         }
2437 
2438         (err, discountedCollateralRatioMinusOne) = subExp(collateralRatioMinusLiquidationDiscount, Exp({mantissa: mantissaOne}));
2439         if (err != Error.NO_ERROR) {
2440             return (err, 0);
2441         }
2442 
2443         (err, discountedPrice_UnderwaterAsset) = mulExp(underwaterAssetPrice, discountedCollateralRatioMinusOne);
2444         // calculateAccountLiquidity multiplies underwaterAssetPrice by collateralRatio
2445         // discountedCollateralRatioMinusOne < collateralRatio
2446         // so if underwaterAssetPrice * collateralRatio did not overflow then
2447         // underwaterAssetPrice * discountedCollateralRatioMinusOne can't overflow either
2448         assert(err == Error.NO_ERROR);
2449 
2450         (err, rawResult) = divExp(accountShortfall_TargetUser, discountedPrice_UnderwaterAsset);
2451         // It's theoretically possible an asset could have such a low price that it truncates to zero when discounted.
2452         if (err != Error.NO_ERROR) {
2453             return (err, 0);
2454         }
2455 
2456         return (Error.NO_ERROR, truncate(rawResult));
2457     }
2458 
2459     /**
2460       * @dev discountedBorrowDenominatedCollateral = [supplyCurrent / (1 + liquidationDiscount)] * (Oracle price for the collateral / Oracle price for the borrow)
2461       */
2462     function calculateDiscountedBorrowDenominatedCollateral(Exp memory underwaterAssetPrice, Exp memory collateralPrice, uint supplyCurrent_TargetCollateralAsset) view internal returns (Error, uint) {
2463         // To avoid rounding issues, we re-order and group the operations so we do 1 division and only at the end
2464         // [supplyCurrent * (Oracle price for the collateral)] / [ (1 + liquidationDiscount) * (Oracle price for the borrow) ]
2465         Error err;
2466         Exp memory onePlusLiquidationDiscount; // (1 + liquidationDiscount)
2467         Exp memory supplyCurrentTimesOracleCollateral; // supplyCurrent * Oracle price for the collateral
2468         Exp memory onePlusLiquidationDiscountTimesOracleBorrow; // (1 + liquidationDiscount) * Oracle price for the borrow
2469         Exp memory rawResult;
2470 
2471         (err, onePlusLiquidationDiscount) = addExp(Exp({mantissa: mantissaOne}), liquidationDiscount);
2472         if (err != Error.NO_ERROR) {
2473             return (err, 0);
2474         }
2475 
2476         (err, supplyCurrentTimesOracleCollateral) = mulScalar(collateralPrice, supplyCurrent_TargetCollateralAsset);
2477         if (err != Error.NO_ERROR) {
2478             return (err, 0);
2479         }
2480 
2481         (err, onePlusLiquidationDiscountTimesOracleBorrow) = mulExp(onePlusLiquidationDiscount, underwaterAssetPrice);
2482         if (err != Error.NO_ERROR) {
2483             return (err, 0);
2484         }
2485 
2486         (err, rawResult) = divExp(supplyCurrentTimesOracleCollateral, onePlusLiquidationDiscountTimesOracleBorrow);
2487         if (err != Error.NO_ERROR) {
2488             return (err, 0);
2489         }
2490 
2491         return (Error.NO_ERROR, truncate(rawResult));
2492     }
2493 
2494 
2495     /**
2496       * @dev returns closeBorrowAmount_TargetUnderwaterAsset * (1+liquidationDiscount) * priceBorrow/priceCollateral
2497       **/
2498     function calculateAmountSeize(Exp memory underwaterAssetPrice, Exp memory collateralPrice, uint closeBorrowAmount_TargetUnderwaterAsset) internal view returns (Error, uint) {
2499         // To avoid rounding issues, we re-order and group the operations to move the division to the end, rather than just taking the ratio of the 2 prices:
2500         // underwaterAssetPrice * (1+liquidationDiscount) *closeBorrowAmount_TargetUnderwaterAsset) / collateralPrice
2501 
2502         // re-used for all intermediate errors
2503         Error err;
2504 
2505         // (1+liquidationDiscount)
2506         Exp memory liquidationMultiplier;
2507 
2508         // assetPrice-of-underwaterAsset * (1+liquidationDiscount)
2509         Exp memory priceUnderwaterAssetTimesLiquidationMultiplier;
2510 
2511         // priceUnderwaterAssetTimesLiquidationMultiplier * closeBorrowAmount_TargetUnderwaterAsset
2512         // or, expanded:
2513         // underwaterAssetPrice * (1+liquidationDiscount) * closeBorrowAmount_TargetUnderwaterAsset
2514         Exp memory finalNumerator;
2515 
2516         // finalNumerator / priceCollateral
2517         Exp memory rawResult;
2518 
2519         (err, liquidationMultiplier) = addExp(Exp({mantissa: mantissaOne}), liquidationDiscount);
2520         // liquidation discount will be enforced < 1, so 1 + liquidationDiscount can't overflow.
2521         assert(err == Error.NO_ERROR);
2522 
2523         (err, priceUnderwaterAssetTimesLiquidationMultiplier) = mulExp(underwaterAssetPrice, liquidationMultiplier);
2524         if (err != Error.NO_ERROR) {
2525             return (err, 0);
2526         }
2527 
2528         (err, finalNumerator) = mulScalar(priceUnderwaterAssetTimesLiquidationMultiplier, closeBorrowAmount_TargetUnderwaterAsset);
2529         if (err != Error.NO_ERROR) {
2530             return (err, 0);
2531         }
2532 
2533         (err, rawResult) = divExp(finalNumerator, collateralPrice);
2534         if (err != Error.NO_ERROR) {
2535             return (err, 0);
2536         }
2537 
2538         return (Error.NO_ERROR, truncate(rawResult));
2539     }
2540 
2541 
2542     /**
2543       * @notice Users borrow assets from the protocol to their own address
2544       * @param asset The market asset to borrow
2545       * @param amount The amount to borrow
2546       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2547       */
2548     function borrow(address asset, uint amount) public returns (uint) {
2549         if (paused) {
2550             return fail(Error.CONTRACT_PAUSED, FailureInfo.BORROW_CONTRACT_PAUSED);
2551         }
2552         BorrowLocalVars memory localResults;
2553         Market storage market = markets[asset];
2554         Balance storage borrowBalance = borrowBalances[msg.sender][asset];
2555 
2556         Error err;
2557         uint rateCalculationResultCode;
2558 
2559         // Fail if market not supported
2560         if (!market.isSupported) {
2561             return fail(Error.MARKET_NOT_SUPPORTED, FailureInfo.BORROW_MARKET_NOT_SUPPORTED);
2562         }
2563 
2564         // We calculate the newBorrowIndex, user's borrowCurrent and borrowUpdated for the asset
2565         (err, localResults.newBorrowIndex) = calculateInterestIndex(market.borrowIndex, market.borrowRateMantissa, market.blockNumber, getBlockNumber());
2566         if (err != Error.NO_ERROR) {
2567             return fail(err, FailureInfo.BORROW_NEW_BORROW_INDEX_CALCULATION_FAILED);
2568         }
2569 
2570         (err, localResults.userBorrowCurrent) = calculateBalance(borrowBalance.principal, borrowBalance.interestIndex, localResults.newBorrowIndex);
2571         if (err != Error.NO_ERROR) {
2572             return fail(err, FailureInfo.BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED);
2573         }
2574 
2575         // Calculate origination fee.
2576         (err, localResults.borrowAmountWithFee) = calculateBorrowAmountWithFee(amount);
2577         if (err != Error.NO_ERROR) {
2578             return fail(err, FailureInfo.BORROW_ORIGINATION_FEE_CALCULATION_FAILED);
2579         }
2580 
2581         // Add the `borrowAmountWithFee` to the `userBorrowCurrent` to get `userBorrowUpdated`
2582         (err, localResults.userBorrowUpdated) = add(localResults.userBorrowCurrent, localResults.borrowAmountWithFee);
2583         if (err != Error.NO_ERROR) {
2584             return fail(err, FailureInfo.BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED);
2585         }
2586 
2587         // We calculate the protocol's totalBorrow by subtracting the user's prior checkpointed balance, adding user's updated borrow with fee
2588         (err, localResults.newTotalBorrows) = addThenSub(market.totalBorrows, localResults.userBorrowUpdated, borrowBalance.principal);
2589         if (err != Error.NO_ERROR) {
2590             return fail(err, FailureInfo.BORROW_NEW_TOTAL_BORROW_CALCULATION_FAILED);
2591         }
2592 
2593         // Check customer liquidity
2594         (err, localResults.accountLiquidity, localResults.accountShortfall) = calculateAccountLiquidity(msg.sender);
2595         if (err != Error.NO_ERROR) {
2596             return fail(err, FailureInfo.BORROW_ACCOUNT_LIQUIDITY_CALCULATION_FAILED);
2597         }
2598 
2599         // Fail if customer already has a shortfall
2600         if (!isZeroExp(localResults.accountShortfall)) {
2601             return fail(Error.INSUFFICIENT_LIQUIDITY, FailureInfo.BORROW_ACCOUNT_SHORTFALL_PRESENT);
2602         }
2603 
2604         // Would the customer have a shortfall after this borrow (including origination fee)?
2605         // We calculate the eth-equivalent value of (borrow amount + fee) of asset and fail if it exceeds accountLiquidity.
2606         // This implements: `[(collateralRatio*oraclea*borrowAmount)*(1+borrowFee)] > accountLiquidity`
2607         (err, localResults.ethValueOfBorrowAmountWithFee) = getPriceForAssetAmountMulCollatRatio(asset, localResults.borrowAmountWithFee);
2608         if (err != Error.NO_ERROR) {
2609             return fail(err, FailureInfo.BORROW_AMOUNT_VALUE_CALCULATION_FAILED);
2610         }
2611         if (lessThanExp(localResults.accountLiquidity, localResults.ethValueOfBorrowAmountWithFee)) {
2612             return fail(Error.INSUFFICIENT_LIQUIDITY, FailureInfo.BORROW_AMOUNT_LIQUIDITY_SHORTFALL);
2613         }
2614 
2615         // Fail gracefully if protocol has insufficient cash
2616         localResults.currentCash = getCash(asset);
2617         // We need to calculate what the updated cash will be after we transfer out to the user
2618         (err, localResults.updatedCash) = sub(localResults.currentCash, amount);
2619         if (err != Error.NO_ERROR) {
2620             // Note: we ignore error here and call this token insufficient cash
2621             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.BORROW_NEW_TOTAL_CASH_CALCULATION_FAILED);
2622         }
2623 
2624         // The utilization rate has changed! We calculate a new supply index and borrow index for the asset, and save it.
2625 
2626         // We calculate the newSupplyIndex, but we have newBorrowIndex already
2627         (err, localResults.newSupplyIndex) = calculateInterestIndex(market.supplyIndex, market.supplyRateMantissa, market.blockNumber, getBlockNumber());
2628         if (err != Error.NO_ERROR) {
2629             return fail(err, FailureInfo.BORROW_NEW_SUPPLY_INDEX_CALCULATION_FAILED);
2630         }
2631 
2632         (rateCalculationResultCode, localResults.newSupplyRateMantissa) = market.interestRateModel.getSupplyRate(asset, localResults.updatedCash, localResults.newTotalBorrows);
2633         if (rateCalculationResultCode != 0) {
2634             return failOpaque(FailureInfo.BORROW_NEW_SUPPLY_RATE_CALCULATION_FAILED, rateCalculationResultCode);
2635         }
2636 
2637         (rateCalculationResultCode, localResults.newBorrowRateMantissa) = market.interestRateModel.getBorrowRate(asset, localResults.updatedCash, localResults.newTotalBorrows);
2638         if (rateCalculationResultCode != 0) {
2639             return failOpaque(FailureInfo.BORROW_NEW_BORROW_RATE_CALCULATION_FAILED, rateCalculationResultCode);
2640         }
2641 
2642         /////////////////////////
2643         // EFFECTS & INTERACTIONS
2644         // (No safe failures beyond this point)
2645 
2646         // We ERC-20 transfer the asset into the protocol (note: pre-conditions already checked above)
2647         err = doTransferOut(asset, msg.sender, amount);
2648         if (err != Error.NO_ERROR) {
2649             // This is safe since it's our first interaction and it didn't do anything if it failed
2650             return fail(err, FailureInfo.BORROW_TRANSFER_OUT_FAILED);
2651         }
2652 
2653         // Save market updates
2654         market.blockNumber = getBlockNumber();
2655         market.totalBorrows =  localResults.newTotalBorrows;
2656         market.supplyRateMantissa = localResults.newSupplyRateMantissa;
2657         market.supplyIndex = localResults.newSupplyIndex;
2658         market.borrowRateMantissa = localResults.newBorrowRateMantissa;
2659         market.borrowIndex = localResults.newBorrowIndex;
2660 
2661         // Save user updates
2662         localResults.startingBalance = borrowBalance.principal; // save for use in `BorrowTaken` event
2663         borrowBalance.principal = localResults.userBorrowUpdated;
2664         borrowBalance.interestIndex = localResults.newBorrowIndex;
2665 
2666         emit BorrowTaken(msg.sender, asset, amount, localResults.startingBalance, localResults.borrowAmountWithFee, localResults.userBorrowUpdated);
2667 
2668         return uint(Error.NO_ERROR); // success
2669     }
2670 }