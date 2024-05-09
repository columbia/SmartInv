1 pragma solidity 0.4.18;
2 
3 // File: contracts/ERC20Interface.sol
4 
5 // https://github.com/ethereum/EIPs/issues/20
6 interface ERC20 {
7     function totalSupply() public view returns (uint supply);
8     function balanceOf(address _owner) public view returns (uint balance);
9     function transfer(address _to, uint _value) public returns (bool success);
10     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
11     function approve(address _spender, uint _value) public returns (bool success);
12     function allowance(address _owner, address _spender) public view returns (uint remaining);
13     function decimals() public view returns(uint digits);
14     event Approval(address indexed _owner, address indexed _spender, uint _value);
15 }
16 
17 // File: contracts/KyberReserveInterface.sol
18 
19 /// @title Kyber Reserve contract
20 interface KyberReserveInterface {
21 
22     function trade(
23         ERC20 srcToken,
24         uint srcAmount,
25         ERC20 destToken,
26         address destAddress,
27         uint conversionRate,
28         bool validate
29     )
30         public
31         payable
32         returns(bool);
33 
34     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
35 }
36 
37 // File: contracts/Utils.sol
38 
39 /// @title Kyber constants contract
40 contract Utils {
41 
42     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
43     uint  constant internal PRECISION = (10**18);
44     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
45     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
46     uint  constant internal MAX_DECIMALS = 18;
47     uint  constant internal ETH_DECIMALS = 18;
48     mapping(address=>uint) internal decimals;
49 
50     function setDecimals(ERC20 token) internal {
51         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
52         else decimals[token] = token.decimals();
53     }
54 
55     function getDecimals(ERC20 token) internal view returns(uint) {
56         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
57         uint tokenDecimals = decimals[token];
58         // technically, there might be token with decimals 0
59         // moreover, very possible that old tokens have decimals 0
60         // these tokens will just have higher gas fees.
61         if(tokenDecimals == 0) return token.decimals();
62 
63         return tokenDecimals;
64     }
65 
66     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
67         require(srcQty <= MAX_QTY);
68         require(rate <= MAX_RATE);
69 
70         if (dstDecimals >= srcDecimals) {
71             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
72             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
73         } else {
74             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
75             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
76         }
77     }
78 
79     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
80         require(dstQty <= MAX_QTY);
81         require(rate <= MAX_RATE);
82         
83         //source quantity is rounded up. to avoid dest quantity being too low.
84         uint numerator;
85         uint denominator;
86         if (srcDecimals >= dstDecimals) {
87             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
88             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
89             denominator = rate;
90         } else {
91             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
92             numerator = (PRECISION * dstQty);
93             denominator = (rate * (10**(dstDecimals - srcDecimals)));
94         }
95         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
96     }
97 }
98 
99 // File: contracts/Utils2.sol
100 
101 contract Utils2 is Utils {
102 
103     /// @dev get the balance of a user.
104     /// @param token The token type
105     /// @return The balance
106     function getBalance(ERC20 token, address user) public view returns(uint) {
107         if (token == ETH_TOKEN_ADDRESS)
108             return user.balance;
109         else
110             return token.balanceOf(user);
111     }
112 
113     function getDecimalsSafe(ERC20 token) internal returns(uint) {
114 
115         if (decimals[token] == 0) {
116             setDecimals(token);
117         }
118 
119         return decimals[token];
120     }
121 
122     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
123         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
124     }
125 
126     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
127         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
128     }
129 
130     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
131         internal pure returns(uint)
132     {
133         require(srcAmount <= MAX_QTY);
134         require(destAmount <= MAX_QTY);
135 
136         if (dstDecimals >= srcDecimals) {
137             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
138             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
139         } else {
140             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
141             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
142         }
143     }
144 }
145 
146 // File: contracts/PermissionGroups.sol
147 
148 contract PermissionGroups {
149 
150     address public admin;
151     address public pendingAdmin;
152     mapping(address=>bool) internal operators;
153     mapping(address=>bool) internal alerters;
154     address[] internal operatorsGroup;
155     address[] internal alertersGroup;
156     uint constant internal MAX_GROUP_SIZE = 50;
157 
158     function PermissionGroups() public {
159         admin = msg.sender;
160     }
161 
162     modifier onlyAdmin() {
163         require(msg.sender == admin);
164         _;
165     }
166 
167     modifier onlyOperator() {
168         require(operators[msg.sender]);
169         _;
170     }
171 
172     modifier onlyAlerter() {
173         require(alerters[msg.sender]);
174         _;
175     }
176 
177     function getOperators () external view returns(address[]) {
178         return operatorsGroup;
179     }
180 
181     function getAlerters () external view returns(address[]) {
182         return alertersGroup;
183     }
184 
185     event TransferAdminPending(address pendingAdmin);
186 
187     /**
188      * @dev Allows the current admin to set the pendingAdmin address.
189      * @param newAdmin The address to transfer ownership to.
190      */
191     function transferAdmin(address newAdmin) public onlyAdmin {
192         require(newAdmin != address(0));
193         TransferAdminPending(pendingAdmin);
194         pendingAdmin = newAdmin;
195     }
196 
197     /**
198      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
199      * @param newAdmin The address to transfer ownership to.
200      */
201     function transferAdminQuickly(address newAdmin) public onlyAdmin {
202         require(newAdmin != address(0));
203         TransferAdminPending(newAdmin);
204         AdminClaimed(newAdmin, admin);
205         admin = newAdmin;
206     }
207 
208     event AdminClaimed( address newAdmin, address previousAdmin);
209 
210     /**
211      * @dev Allows the pendingAdmin address to finalize the change admin process.
212      */
213     function claimAdmin() public {
214         require(pendingAdmin == msg.sender);
215         AdminClaimed(pendingAdmin, admin);
216         admin = pendingAdmin;
217         pendingAdmin = address(0);
218     }
219 
220     event AlerterAdded (address newAlerter, bool isAdd);
221 
222     function addAlerter(address newAlerter) public onlyAdmin {
223         require(!alerters[newAlerter]); // prevent duplicates.
224         require(alertersGroup.length < MAX_GROUP_SIZE);
225 
226         AlerterAdded(newAlerter, true);
227         alerters[newAlerter] = true;
228         alertersGroup.push(newAlerter);
229     }
230 
231     function removeAlerter (address alerter) public onlyAdmin {
232         require(alerters[alerter]);
233         alerters[alerter] = false;
234 
235         for (uint i = 0; i < alertersGroup.length; ++i) {
236             if (alertersGroup[i] == alerter) {
237                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
238                 alertersGroup.length--;
239                 AlerterAdded(alerter, false);
240                 break;
241             }
242         }
243     }
244 
245     event OperatorAdded(address newOperator, bool isAdd);
246 
247     function addOperator(address newOperator) public onlyAdmin {
248         require(!operators[newOperator]); // prevent duplicates.
249         require(operatorsGroup.length < MAX_GROUP_SIZE);
250 
251         OperatorAdded(newOperator, true);
252         operators[newOperator] = true;
253         operatorsGroup.push(newOperator);
254     }
255 
256     function removeOperator (address operator) public onlyAdmin {
257         require(operators[operator]);
258         operators[operator] = false;
259 
260         for (uint i = 0; i < operatorsGroup.length; ++i) {
261             if (operatorsGroup[i] == operator) {
262                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
263                 operatorsGroup.length -= 1;
264                 OperatorAdded(operator, false);
265                 break;
266             }
267         }
268     }
269 }
270 
271 // File: contracts/Withdrawable.sol
272 
273 /**
274  * @title Contracts that should be able to recover tokens or ethers
275  * @author Ilan Doron
276  * @dev This allows to recover any tokens or Ethers received in a contract.
277  * This will prevent any accidental loss of tokens.
278  */
279 contract Withdrawable is PermissionGroups {
280 
281     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
282 
283     /**
284      * @dev Withdraw all ERC20 compatible tokens
285      * @param token ERC20 The address of the token contract
286      */
287     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
288         require(token.transfer(sendTo, amount));
289         TokenWithdraw(token, amount, sendTo);
290     }
291 
292     event EtherWithdraw(uint amount, address sendTo);
293 
294     /**
295      * @dev Withdraw Ethers
296      */
297     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
298         sendTo.transfer(amount);
299         EtherWithdraw(amount, sendTo);
300     }
301 }
302 
303 // File: contracts/oasisContracts/KyberOasisReserve.sol
304 
305 contract OtcInterface {
306     function getOffer(uint id) public constant returns (uint, ERC20, uint, ERC20);
307     function sellAllAmount(ERC20 payGem, uint payAmt, ERC20 buyGem, uint minFillAmount) public returns (uint fillAmt);
308     function getBestOffer(ERC20 sellGem, ERC20 buyGem) public constant returns(uint);
309 }
310 
311 
312 contract TokenInterface is ERC20 {
313     function deposit() public payable;
314     function withdraw(uint) public;
315 }
316 
317 
318 contract KyberOasisReserve is KyberReserveInterface, Withdrawable, Utils2 {
319 
320     uint constant internal MIN_TRADE_TOKEN_SRC_AMOUNT = (10**18);
321     uint constant internal COMMON_DECIMALS = 18;
322     address public sanityRatesContract = 0;
323     address public kyberNetwork;
324     OtcInterface public otc;
325     TokenInterface public wethToken;
326     ERC20 public tradeToken;
327     bool public tradeEnabled;
328     uint public feeBps;
329 
330     function KyberOasisReserve(
331         address _kyberNetwork,
332         OtcInterface _otc,
333         TokenInterface _wethToken,
334         ERC20 _tradeToken,
335         address _admin,
336         uint _feeBps
337     )
338         public
339     {
340         require(_admin != address(0));
341         require(_kyberNetwork != address(0));
342         require(_otc != address(0));
343         require(_wethToken != address(0));
344         require(_tradeToken != address(0));
345         require(_feeBps < 10000);
346         require(getDecimals(_wethToken) == COMMON_DECIMALS);
347         require(getDecimals(_tradeToken) == COMMON_DECIMALS);
348 
349         kyberNetwork = _kyberNetwork;
350         otc = _otc;
351         wethToken = _wethToken;
352         tradeToken = _tradeToken;
353         admin = _admin;
354         feeBps = _feeBps;
355         tradeEnabled = true;
356 
357         wethToken.approve(otc, 2**255);
358         tradeToken.approve(otc, 2**255);
359     }
360 
361     function() public payable {
362         require(msg.sender == address(wethToken));
363     }
364 
365     event TradeExecute(
366         address indexed sender,
367         address src,
368         uint srcAmount,
369         address destToken,
370         uint destAmount,
371         address destAddress
372     );
373 
374     function trade(
375         ERC20 srcToken,
376         uint srcAmount,
377         ERC20 destToken,
378         address destAddress,
379         uint conversionRate,
380         bool validate
381     )
382         public
383         payable
384         returns(bool)
385     {
386 
387         require(tradeEnabled);
388         require(msg.sender == kyberNetwork);
389 
390         require(doTrade(srcToken, srcAmount, destToken, destAddress, conversionRate, validate));
391 
392         return true;
393     }
394 
395     event TradeEnabled(bool enable);
396 
397     function enableTrade() public onlyAdmin returns(bool) {
398         tradeEnabled = true;
399         TradeEnabled(true);
400 
401         return true;
402     }
403 
404     function disableTrade() public onlyAlerter returns(bool) {
405         tradeEnabled = false;
406         TradeEnabled(false);
407 
408         return true;
409     }
410 
411     event KyberNetworkSet(address kyberNetwork);
412 
413     function setKyberNetwork(address _kyberNetwork) public onlyAdmin {
414         require(_kyberNetwork != address(0));
415 
416         kyberNetwork = _kyberNetwork;
417         KyberNetworkSet(kyberNetwork);
418     }
419 
420     event OtcSet(address otc);
421 
422     function setOtc(OtcInterface _otc) public onlyAdmin {
423         require(_otc != address(0));
424 
425         wethToken.approve(otc, 0);
426         tradeToken.approve(otc, 0);
427         wethToken.approve(_otc, 2**255);
428         tradeToken.approve(_otc, 2**255);
429 
430         otc = _otc;
431         OtcSet(otc);
432     }
433 
434     event FeeBpsSet(uint feeBps);
435 
436     function setFeeBps(uint _feeBps) public onlyAdmin {
437         require(_feeBps < 10000);
438 
439         feeBps = _feeBps;
440         FeeBpsSet(feeBps);
441     }
442 
443     function valueAfterReducingFee(uint val) public view returns(uint) {
444         require(val <= MAX_QTY);
445         return ((10000 - feeBps) * val) / 10000;
446     }
447 
448     function valueBeforeFeesWereReduced(uint val) public view returns(uint) {
449         require(val <= MAX_QTY);
450         return val * 10000 / (10000 - feeBps);
451     }
452 
453     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint) {
454         uint  rate;
455         uint  actualSrcQty;
456         ERC20 wrappedSrc;
457         ERC20 wrappedDest;
458         uint  bestOfferId;
459         uint  offerPayAmt;
460         uint  offerBuyAmt;
461 
462         blockNumber;
463 
464         if (!tradeEnabled) return 0;
465         if ((tradeToken != src) && (tradeToken != dest)) return 0;
466 
467         if (src == ETH_TOKEN_ADDRESS) {
468             wrappedSrc = wethToken;
469             wrappedDest = dest;
470             actualSrcQty = srcQty;
471         } else if (dest == ETH_TOKEN_ADDRESS) {
472             wrappedSrc = src;
473             wrappedDest = wethToken;
474 
475             if (srcQty < MIN_TRADE_TOKEN_SRC_AMOUNT) {
476                 /* Assuming token is stable, use a minimal amount to get rate also for small token quant. */
477                 actualSrcQty = MIN_TRADE_TOKEN_SRC_AMOUNT;
478             } else {
479                 actualSrcQty = srcQty;
480             }
481         } else {
482             return 0;
483         }
484 
485         // getBestOffer's terminology is of offer maker, so their sellGem is our (the taker's) dest token.
486         bestOfferId = otc.getBestOffer(wrappedDest, wrappedSrc);
487         (offerPayAmt, , offerBuyAmt,) = otc.getOffer(bestOfferId);
488 
489         // make sure to take only first level of order book to avoid gas inflation.
490         if (actualSrcQty > offerBuyAmt) return 0;
491 
492         rate = calcRateFromQty(offerBuyAmt, offerPayAmt, COMMON_DECIMALS, COMMON_DECIMALS);
493         return valueAfterReducingFee(rate);
494     }
495 
496     function doTrade(
497         ERC20 srcToken,
498         uint srcAmount,
499         ERC20 destToken,
500         address destAddress,
501         uint conversionRate,
502         bool validate
503     )
504         internal
505         returns(bool)
506     {
507         require((ETH_TOKEN_ADDRESS == srcToken) || (ETH_TOKEN_ADDRESS == destToken));
508         require((tradeToken == srcToken) || (tradeToken == destToken));
509 
510         uint actualDestAmount;
511 
512         // can skip validation if done at kyber network level
513         if (validate) {
514             require(conversionRate > 0);
515             if (srcToken == ETH_TOKEN_ADDRESS)
516                 require(msg.value == srcAmount);
517             else
518                 require(msg.value == 0);
519         }
520 
521         uint userExpectedDestAmount = calcDstQty(srcAmount, COMMON_DECIMALS, COMMON_DECIMALS, conversionRate);
522         require(userExpectedDestAmount > 0); // sanity check
523 
524         uint destAmountIncludingFees = valueBeforeFeesWereReduced(userExpectedDestAmount);
525 
526         if (srcToken == ETH_TOKEN_ADDRESS) {
527             wethToken.deposit.value(msg.value)();
528 
529             actualDestAmount = otc.sellAllAmount(wethToken, msg.value, destToken, destAmountIncludingFees);
530             require(actualDestAmount >= destAmountIncludingFees);
531 
532             // transfer back only requested dest amount.
533             require(destToken.transfer(destAddress, userExpectedDestAmount));
534         } else {
535             require(srcToken.transferFrom(msg.sender, this, srcAmount));
536  
537             actualDestAmount = otc.sellAllAmount(srcToken, srcAmount, wethToken, destAmountIncludingFees);
538             require(actualDestAmount >= destAmountIncludingFees);
539             wethToken.withdraw(actualDestAmount);
540 
541             // transfer back only requested dest amount.
542             destAddress.transfer(userExpectedDestAmount); 
543         }
544 
545         TradeExecute(msg.sender, srcToken, srcAmount, destToken, userExpectedDestAmount, destAddress);
546 
547         return true;
548     }
549 }