1 pragma solidity ^0.4.24;
2 
3 contract Token {
4     function transfer(address _to, uint _value) public returns (bool success);
5     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
6     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
7     function approve(address _spender, uint256 _value) public returns (bool success);
8     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
9     function balanceOf(address _owner) public view returns (uint256 balance);
10 }
11 
12 contract Ownable {
13     address public owner;
14 
15     modifier onlyOwner() {
16         require(msg.sender == owner, "msg.sender is not the owner");
17         _;
18     }
19 
20     constructor() public {
21         owner = msg.sender;
22     }
23 
24     /**
25         @dev Transfers the ownership of the contract.
26 
27         @param _to Address of the new owner
28     */
29     function transferTo(address _to) external onlyOwner returns (bool) {
30         require(_to != address(0), "Can't transfer to address 0x0");
31         owner = _to;
32         return true;
33     }
34 }
35 
36 
37 /**
38     @dev Defines the interface of a standard RCN oracle.
39 
40     The oracle is an agent in the RCN network that supplies a convertion rate between RCN and any other currency,
41     it's primarily used by the exchange but could be used by any other agent.
42 */
43 contract Oracle is Ownable {
44     uint256 public constant VERSION = 4;
45 
46     event NewSymbol(bytes32 _currency);
47 
48     mapping(bytes32 => bool) public supported;
49     bytes32[] public currencies;
50 
51     /**
52         @dev Returns the url where the oracle exposes a valid "oracleData" if needed
53     */
54     function url() public view returns (string);
55 
56     /**
57         @dev Returns a valid convertion rate from the currency given to RCN
58 
59         @param symbol Symbol of the currency
60         @param data Generic data field, could be used for off-chain signing
61     */
62     function getRate(bytes32 symbol, bytes data) public returns (uint256 rate, uint256 decimals);
63 
64     /**
65         @dev Adds a currency to the oracle, once added it cannot be removed
66 
67         @param ticker Symbol of the currency
68 
69         @return if the creation was done successfully
70     */
71     function addCurrency(string ticker) public onlyOwner returns (bool) {
72         bytes32 currency = encodeCurrency(ticker);
73         emit NewSymbol(currency);
74         supported[currency] = true;
75         currencies.push(currency);
76         return true;
77     }
78 
79     /**
80         @return the currency encoded as a bytes32
81     */
82     function encodeCurrency(string currency) public pure returns (bytes32 o) {
83         require(bytes(currency).length <= 32, "Currency too long");
84         assembly {
85             o := mload(add(currency, 32))
86         }
87     }
88     
89     /**
90         @return the currency string from a encoded bytes32
91     */
92     function decodeCurrency(bytes32 b) public pure returns (string o) {
93         uint256 ns = 256;
94         while (true) { if (ns == 0 || (b<<ns-8) != 0) break; ns -= 8; }
95         assembly {
96             ns := div(ns, 8)
97             o := mload(0x40)
98             mstore(0x40, add(o, and(add(add(ns, 0x20), 0x1f), not(0x1f))))
99             mstore(o, ns)
100             mstore(add(o, 32), b)
101         }
102     }
103 }
104 
105 contract Engine {
106     uint256 public VERSION;
107     string public VERSION_NAME;
108 
109     enum Status { initial, lent, paid, destroyed }
110     struct Approbation {
111         bool approved;
112         bytes data;
113         bytes32 checksum;
114     }
115 
116     function getTotalLoans() public view returns (uint256);
117     function getOracle(uint index) public view returns (Oracle);
118     function getBorrower(uint index) public view returns (address);
119     function getCosigner(uint index) public view returns (address);
120     function ownerOf(uint256) public view returns (address owner);
121     function getCreator(uint index) public view returns (address);
122     function getAmount(uint index) public view returns (uint256);
123     function getPaid(uint index) public view returns (uint256);
124     function getDueTime(uint index) public view returns (uint256);
125     function getApprobation(uint index, address _address) public view returns (bool);
126     function getStatus(uint index) public view returns (Status);
127     function isApproved(uint index) public view returns (bool);
128     function getPendingAmount(uint index) public returns (uint256);
129     function getCurrency(uint index) public view returns (bytes32);
130     function cosign(uint index, uint256 cost) external returns (bool);
131     function approveLoan(uint index) public returns (bool);
132     function transfer(address to, uint256 index) public returns (bool);
133     function takeOwnership(uint256 index) public returns (bool);
134     function withdrawal(uint index, address to, uint256 amount) public returns (bool);
135     function identifierToIndex(bytes32 signature) public view returns (uint256);
136 }
137 
138 
139 /**
140     @dev Defines the interface of a standard RCN cosigner.
141 
142     The cosigner is an agent that gives an insurance to the lender in the event of a defaulted loan, the confitions
143     of the insurance and the cost of the given are defined by the cosigner. 
144 
145     The lender will decide what cosigner to use, if any; the address of the cosigner and the valid data provided by the
146     agent should be passed as params when the lender calls the "lend" method on the engine.
147     
148     When the default conditions defined by the cosigner aligns with the status of the loan, the lender of the engine
149     should be able to call the "claim" method to receive the benefit; the cosigner can define aditional requirements to
150     call this method, like the transfer of the ownership of the loan.
151 */
152 contract Cosigner {
153     uint256 public constant VERSION = 2;
154     
155     /**
156         @return the url of the endpoint that exposes the insurance offers.
157     */
158     function url() public view returns (string);
159     
160     /**
161         @dev Retrieves the cost of a given insurance, this amount should be exact.
162 
163         @return the cost of the cosign, in RCN wei
164     */
165     function cost(address engine, uint256 index, bytes data, bytes oracleData) public view returns (uint256);
166     
167     /**
168         @dev The engine calls this method for confirmation of the conditions, if the cosigner accepts the liability of
169         the insurance it must call the method "cosign" of the engine. If the cosigner does not call that method, or
170         does not return true to this method, the operation fails.
171 
172         @return true if the cosigner accepts the liability
173     */
174     function requestCosign(Engine engine, uint256 index, bytes data, bytes oracleData) public returns (bool);
175     
176     /**
177         @dev Claims the benefit of the insurance if the loan is defaulted, this method should be only calleable by the
178         current lender of the loan.
179 
180         @return true if the claim was done correctly.
181     */
182     function claim(address engine, uint256 index, bytes oracleData) public returns (bool);
183 }
184 
185 
186 contract TokenConverter {
187     address public constant ETH_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
188     function getReturn(Token _fromToken, Token _toToken, uint256 _fromAmount) external view returns (uint256 amount);
189     function convert(Token _fromToken, Token _toToken, uint256 _fromAmount, uint256 _minReturn) external payable returns (uint256 amount);
190 }
191 
192 interface NanoLoanEngine {
193     function pay(uint index, uint256 _amount, address _from, bytes oracleData) public returns (bool);
194     function rcn() public view returns (Token);
195     function getOracle(uint256 index) public view returns (Oracle);
196     function getAmount(uint256 index) public view returns (uint256);
197     function getCurrency(uint256 index) public view returns (bytes32);
198     function convertRate(Oracle oracle, bytes32 currency, bytes data, uint256 amount) public view returns (uint256);
199     function lend(uint index, bytes oracleData, Cosigner cosigner, bytes cosignerData) public returns (bool);
200     function transfer(address to, uint256 index) public returns (bool);
201     function getPendingAmount(uint256 index) public returns (uint256);
202 }
203 
204 library LrpSafeMath {
205     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
206         uint256 z = x + y;
207         require((z >= x) && (z >= y));
208         return z;
209     }
210 
211     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
212         require(x >= y);
213         uint256 z = x - y;
214         return z;
215     }
216 
217     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
218         uint256 z = x * y;
219         require((x == 0)||(z/x == y));
220         return z;
221     }
222 
223     function min(uint256 a, uint256 b) internal pure returns(uint256) {
224         if (a < b) { 
225             return a;
226         } else { 
227             return b; 
228         }
229     }
230     
231     function max(uint256 a, uint256 b) internal pure returns(uint256) {
232         if (a > b) { 
233             return a;
234         } else { 
235             return b; 
236         }
237     }
238 }
239 
240 
241 contract ConverterRamp is Ownable {
242     using LrpSafeMath for uint256;
243 
244     address public constant ETH_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
245     uint256 public constant AUTO_MARGIN = 1000001;
246     // index of convert rules for pay and lend
247     uint256 public constant I_MARGIN_SPEND = 0;    // Extra sell percent of amount, 100.000 = 100%
248     uint256 public constant I_MAX_SPEND = 1;       // Max spend on perform a sell, 0 = maximum
249     uint256 public constant I_REBUY_THRESHOLD = 2; // Threshold of rebuy change, 0 if want to rebuy always
250     // index of loan parameters for pay and lend
251     uint256 public constant I_ENGINE = 0;     // NanoLoanEngine contract
252     uint256 public constant I_INDEX = 1;      // Loan index on Loans array of NanoLoanEngine
253     // for pay
254     uint256 public constant I_PAY_AMOUNT = 2; // Amount to pay of the loan
255     uint256 public constant I_PAY_FROM = 3;   // The identity of the payer of loan
256     // for lend
257     uint256 public constant I_LEND_COSIGNER = 2; // Cosigner contract
258 
259     event RequiredRebuy(address token, uint256 amount);
260     event Return(address token, address to, uint256 amount);
261     event OptimalSell(address token, uint256 amount);
262     event RequiredRcn(uint256 required);
263     event RunAutoMargin(uint256 loops, uint256 increment);
264 
265     function pay(
266         TokenConverter converter,
267         Token fromToken,
268         bytes32[4] loanParams,
269         bytes oracleData,
270         uint256[3] convertRules
271     ) external payable returns (bool) {
272         Token rcn = NanoLoanEngine(address(loanParams[I_ENGINE])).rcn();
273 
274         uint256 initialBalance = rcn.balanceOf(this);
275         uint256 requiredRcn = getRequiredRcnPay(loanParams, oracleData);
276         emit RequiredRcn(requiredRcn);
277 
278         uint256 optimalSell = getOptimalSell(converter, fromToken, rcn, requiredRcn, convertRules[I_MARGIN_SPEND]);
279         emit OptimalSell(fromToken, optimalSell);
280 
281         pullAmount(fromToken, optimalSell);
282         uint256 bought = convertSafe(converter, fromToken, rcn, optimalSell);
283 
284         // Pay loan
285         require(
286             executeOptimalPay({
287                 params: loanParams,
288                 oracleData: oracleData,
289                 rcnToPay: bought
290             }),
291             "Error paying the loan"
292         );
293 
294         require(
295             rebuyAndReturn({
296                 converter: converter,
297                 fromToken: rcn,
298                 toToken: fromToken,
299                 amount: rcn.balanceOf(this) - initialBalance,
300                 spentAmount: optimalSell,
301                 convertRules: convertRules
302             }),
303             "Error rebuying the tokens"
304         );
305 
306         require(rcn.balanceOf(this) == initialBalance, "Converter balance has incremented");
307         return true;
308     }
309 
310     function requiredLendSell(
311         TokenConverter converter,
312         Token fromToken,
313         bytes32[3] loanParams,
314         bytes oracleData,
315         bytes cosignerData,
316         uint256[3] convertRules
317     ) external view returns (uint256) {
318         Token rcn = NanoLoanEngine(address(loanParams[I_ENGINE])).rcn();
319         return getOptimalSell(
320             converter,
321             fromToken,
322             rcn,
323             getRequiredRcnLend(loanParams, oracleData, cosignerData),
324             convertRules[I_MARGIN_SPEND]
325         );
326     }
327 
328     function requiredPaySell(
329         TokenConverter converter,
330         Token fromToken,
331         bytes32[4] loanParams,
332         bytes oracleData,
333         uint256[3] convertRules
334     ) external view returns (uint256) {
335         Token rcn = NanoLoanEngine(address(loanParams[I_ENGINE])).rcn();
336         return getOptimalSell(
337             converter,
338             fromToken,
339             rcn,
340             getRequiredRcnPay(loanParams, oracleData),
341             convertRules[I_MARGIN_SPEND]
342         );
343     }
344 
345     function lend(
346         TokenConverter converter,
347         Token fromToken,
348         bytes32[3] loanParams,
349         bytes oracleData,
350         bytes cosignerData,
351         uint256[3] convertRules
352     ) external payable returns (bool) {
353         Token rcn = NanoLoanEngine(address(loanParams[I_ENGINE])).rcn();
354         uint256 initialBalance = rcn.balanceOf(this);
355         uint256 requiredRcn = getRequiredRcnLend(loanParams, oracleData, cosignerData);
356         emit RequiredRcn(requiredRcn);
357 
358         uint256 optimalSell = getOptimalSell(converter, fromToken, rcn, requiredRcn, convertRules[I_MARGIN_SPEND]);
359         emit OptimalSell(fromToken, optimalSell);
360 
361         pullAmount(fromToken, optimalSell);
362         uint256 bought = convertSafe(converter, fromToken, rcn, optimalSell);
363 
364         // Lend loan
365         require(rcn.approve(address(loanParams[0]), bought), "Error approving lend token transfer");
366         require(executeLend(loanParams, oracleData, cosignerData), "Error lending the loan");
367         require(rcn.approve(address(loanParams[0]), 0), "Error removing approve");
368         require(executeTransfer(loanParams, msg.sender), "Error transfering the loan");
369 
370         require(
371             rebuyAndReturn({
372                 converter: converter,
373                 fromToken: rcn,
374                 toToken: fromToken,
375                 amount: rcn.balanceOf(this) - initialBalance,
376                 spentAmount: optimalSell,
377                 convertRules: convertRules
378             }),
379             "Error rebuying the tokens"
380         );
381 
382         require(rcn.balanceOf(this) == initialBalance, "The contract balance should not change");
383         return true;
384     }
385 
386     function pullAmount(
387         Token token,
388         uint256 amount
389     ) private {
390         if (token == ETH_ADDRESS) {
391             require(msg.value >= amount, "Error pulling ETH amount");
392             if (msg.value > amount) {
393                 msg.sender.transfer(msg.value - amount);
394             }
395         } else {
396             require(token.transferFrom(msg.sender, this, amount), "Error pulling Token amount");
397         }
398     }
399 
400     function transfer(
401         Token token,
402         address to,
403         uint256 amount
404     ) private {
405         if (token == ETH_ADDRESS) {
406             to.transfer(amount);
407         } else {
408             require(token.transfer(to, amount), "Error sending tokens");
409         }
410     }
411 
412     function rebuyAndReturn(
413         TokenConverter converter,
414         Token fromToken,
415         Token toToken,
416         uint256 amount,
417         uint256 spentAmount,
418         uint256[3] memory convertRules
419     ) internal returns (bool) {
420         uint256 threshold = convertRules[I_REBUY_THRESHOLD];
421         uint256 bought = 0;
422 
423         if (amount != 0) {
424             if (amount > threshold) {
425                 bought = convertSafe(converter, fromToken, toToken, amount);
426                 emit RequiredRebuy(toToken, amount);
427                 emit Return(toToken, msg.sender, bought);
428                 transfer(toToken, msg.sender, bought);
429             } else {
430                 emit Return(fromToken, msg.sender, amount);
431                 transfer(fromToken, msg.sender, amount);
432             }
433         }
434 
435         uint256 maxSpend = convertRules[I_MAX_SPEND];
436         require(spentAmount.safeSubtract(bought) <= maxSpend || maxSpend == 0, "Max spend exceeded");
437         
438         return true;
439     }
440 
441     function getOptimalSell(
442         TokenConverter converter,
443         Token fromToken,
444         Token toToken,
445         uint256 requiredTo,
446         uint256 extraSell
447     ) internal returns (uint256 sellAmount) {
448         uint256 sellRate = (10 ** 18 * converter.getReturn(toToken, fromToken, requiredTo)) / requiredTo;
449         if (extraSell == AUTO_MARGIN) {
450             uint256 expectedReturn = 0;
451             uint256 optimalSell = applyRate(requiredTo, sellRate);
452             uint256 increment = applyRate(requiredTo / 100000, sellRate);
453             uint256 returnRebuy;
454             uint256 cl;
455 
456             while (expectedReturn < requiredTo && cl < 10) {
457                 optimalSell += increment;
458                 returnRebuy = converter.getReturn(fromToken, toToken, optimalSell);
459                 optimalSell = (optimalSell * requiredTo) / returnRebuy;
460                 expectedReturn = returnRebuy;
461                 cl++;
462             }
463             emit RunAutoMargin(cl, increment);
464 
465             return optimalSell;
466         } else {
467             return applyRate(requiredTo, sellRate).safeMult(uint256(100000).safeAdd(extraSell)) / 100000;
468         }
469     }
470 
471     function convertSafe(
472         TokenConverter converter,
473         Token fromToken,
474         Token toToken,
475         uint256 amount
476     ) internal returns (uint256 bought) {
477         if (fromToken != ETH_ADDRESS) require(fromToken.approve(converter, amount), "Error approving token transfer");
478         uint256 prevBalance = toToken != ETH_ADDRESS ? toToken.balanceOf(this) : address(this).balance;
479         uint256 sendEth = fromToken == ETH_ADDRESS ? amount : 0;
480         uint256 boughtAmount = converter.convert.value(sendEth)(fromToken, toToken, amount, 1);
481         require(
482             boughtAmount == (toToken != ETH_ADDRESS ? toToken.balanceOf(this) : address(this).balance) - prevBalance,
483             "Bought amound does does not match"
484         );
485         if (fromToken != ETH_ADDRESS) require(fromToken.approve(converter, 0), "Error removing token approve");
486         return boughtAmount;
487     }
488 
489     function executeOptimalPay(
490         bytes32[4] memory params,
491         bytes oracleData,
492         uint256 rcnToPay
493     ) internal returns (bool) {
494         NanoLoanEngine engine = NanoLoanEngine(address(params[I_ENGINE]));
495         uint256 index = uint256(params[I_INDEX]);
496         Oracle oracle = engine.getOracle(index);
497 
498         uint256 toPay;
499 
500         if (oracle == address(0)) {
501             toPay = rcnToPay;
502         } else {
503             uint256 rate;
504             uint256 decimals;
505             bytes32 currency = engine.getCurrency(index);
506 
507             (rate, decimals) = oracle.getRate(currency, oracleData);
508             toPay = (rcnToPay * (10 ** (18 - decimals + (18 * 2)) / rate)) / 10 ** 18;
509         }
510 
511         Token rcn = engine.rcn();
512         require(rcn.approve(engine, rcnToPay), "Error on payment approve");
513         require(engine.pay(index, toPay, address(params[I_PAY_FROM]), oracleData), "Error paying the loan");
514         require(rcn.approve(engine, 0), "Error removing the payment approve");
515         
516         return true;
517     }
518 
519     function executeLend(
520         bytes32[3] memory params,
521         bytes oracleData,
522         bytes cosignerData
523     ) internal returns (bool) {
524         NanoLoanEngine engine = NanoLoanEngine(address(params[I_ENGINE]));
525         uint256 index = uint256(params[I_INDEX]);
526         return engine.lend(index, oracleData, Cosigner(address(params[I_LEND_COSIGNER])), cosignerData);
527     }
528 
529     function executeTransfer(
530         bytes32[3] memory params,
531         address to
532     ) internal returns (bool) {
533         return NanoLoanEngine(address(params[I_ENGINE])).transfer(to, uint256(params[1]));
534     }
535 
536     function applyRate(
537         uint256 amount,
538         uint256 rate
539     ) internal pure returns (uint256) {
540         return amount.safeMult(rate) / 10 ** 18;
541     }
542 
543     function getRequiredRcnLend(
544         bytes32[3] memory params,
545         bytes oracleData,
546         bytes cosignerData
547     ) internal view returns (uint256 required) {
548         NanoLoanEngine engine = NanoLoanEngine(address(params[I_ENGINE]));
549         uint256 index = uint256(params[I_INDEX]);
550         Cosigner cosigner = Cosigner(address(params[I_LEND_COSIGNER]));
551 
552         if (cosigner != address(0)) {
553             required += cosigner.cost(engine, index, cosignerData, oracleData);
554         }
555         required += engine.convertRate(engine.getOracle(index), engine.getCurrency(index), oracleData, engine.getAmount(index));
556     }
557     
558     function getRequiredRcnPay(
559         bytes32[4] memory params,
560         bytes oracleData
561     ) internal view returns (uint256) {
562         NanoLoanEngine engine = NanoLoanEngine(address(params[I_ENGINE]));
563         uint256 index = uint256(params[I_INDEX]);
564         uint256 amount = uint256(params[I_PAY_AMOUNT]);
565         return engine.convertRate(engine.getOracle(index), engine.getCurrency(index), oracleData, amount);
566     }
567 
568     function withdrawTokens(
569         Token _token,
570         address _to,
571         uint256 _amount
572     ) external onlyOwner returns (bool) {
573         return _token.transfer(_to, _amount);
574     }
575 
576     function withdrawEther(
577         address _to,
578         uint256 _amount
579     ) external onlyOwner {
580         _to.transfer(_amount);
581     }
582 
583     function() external payable {}
584 }