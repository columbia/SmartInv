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
307     function getBestOffer(ERC20 sellGem, ERC20 buyGem) public constant returns(uint);
308     function getWorseOffer(uint id) public constant returns(uint);
309     function take(bytes32 id, uint128 maxTakeAmount) public;
310 }
311 
312 
313 contract WethInterface is ERC20 {
314     function deposit() public payable;
315     function withdraw(uint) public;
316 }
317 
318 
319 contract KyberOasisReserve is KyberReserveInterface, Withdrawable, Utils2 {
320 
321     uint constant internal COMMON_DECIMALS = 18;
322     address public sanityRatesContract = 0;
323     address public kyberNetwork;
324     OtcInterface public otc;
325     WethInterface public wethToken;
326     mapping(address=>bool) public isTokenListed;
327     mapping(address=>uint) public tokenMinSrcAmount;
328     bool public tradeEnabled;
329     uint public feeBps;
330 
331     function KyberOasisReserve(
332         address _kyberNetwork,
333         OtcInterface _otc,
334         WethInterface _wethToken,
335         address _admin,
336         uint _feeBps
337     )
338         public
339     {
340         require(_admin != address(0));
341         require(_kyberNetwork != address(0));
342         require(_otc != address(0));
343         require(_wethToken != address(0));
344         require(_feeBps < 10000);
345         require(getDecimals(_wethToken) == COMMON_DECIMALS);
346 
347         kyberNetwork = _kyberNetwork;
348         otc = _otc;
349         wethToken = _wethToken;
350         admin = _admin;
351         feeBps = _feeBps;
352         tradeEnabled = true;
353 
354         require(wethToken.approve(otc, 2**255));
355     }
356 
357     function() public payable {
358         require(msg.sender == address(wethToken));
359     }
360 
361     function listToken(ERC20 token, uint minSrcAmount) public onlyAdmin {
362         require(token != address(0));
363         require(!isTokenListed[token]);
364         require(getDecimals(token) == COMMON_DECIMALS);
365 
366         require(token.approve(otc, 2**255));
367         isTokenListed[token] = true;
368         tokenMinSrcAmount[token] = minSrcAmount;
369     }
370 
371     function delistToken(ERC20 token) public onlyAdmin {
372         require(isTokenListed[token]);
373 
374         require(token.approve(otc, 0));
375         delete isTokenListed[token];
376         delete tokenMinSrcAmount[token];
377     }
378 
379     event TradeExecute(
380         address indexed sender,
381         address src,
382         uint srcAmount,
383         address destToken,
384         uint destAmount,
385         address destAddress
386     );
387 
388     function trade(
389         ERC20 srcToken,
390         uint srcAmount,
391         ERC20 destToken,
392         address destAddress,
393         uint conversionRate,
394         bool validate
395     )
396         public
397         payable
398         returns(bool)
399     {
400 
401         require(tradeEnabled);
402         require(msg.sender == kyberNetwork);
403 
404         require(doTrade(srcToken, srcAmount, destToken, destAddress, conversionRate, validate));
405 
406         return true;
407     }
408 
409     event TradeEnabled(bool enable);
410 
411     function enableTrade() public onlyAdmin returns(bool) {
412         tradeEnabled = true;
413         TradeEnabled(true);
414 
415         return true;
416     }
417 
418     function disableTrade() public onlyAlerter returns(bool) {
419         tradeEnabled = false;
420         TradeEnabled(false);
421 
422         return true;
423     }
424 
425     event KyberNetworkSet(address kyberNetwork);
426 
427     function setKyberNetwork(address _kyberNetwork) public onlyAdmin {
428         require(_kyberNetwork != address(0));
429 
430         kyberNetwork = _kyberNetwork;
431         KyberNetworkSet(kyberNetwork);
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
456         ERC20 actualSrc;
457         ERC20 actualDest;
458         uint offerPayAmt;
459         uint offerBuyAmt;
460 
461         blockNumber;
462 
463         if (!tradeEnabled) return 0;
464         if (!validTokens(src, dest)) return 0;
465 
466         if (src == ETH_TOKEN_ADDRESS) {
467             actualSrc = wethToken;
468             actualDest = dest;
469             actualSrcQty = srcQty;
470         } else if (dest == ETH_TOKEN_ADDRESS) {
471             actualSrc = src;
472             actualDest = wethToken;
473 
474             if (srcQty < tokenMinSrcAmount[src]) {
475                 /* remove rounding errors and present rate for 0 src amount. */
476                 actualSrcQty = tokenMinSrcAmount[src];
477             } else {
478                 actualSrcQty = srcQty;
479             }
480         } else {
481             return 0;
482         }
483 
484         // otc's terminology is of offer maker, so their sellGem is the taker's dest token.
485         (, offerPayAmt, offerBuyAmt) = getMatchingOffer(actualDest, actualSrc, actualSrcQty); 
486 
487         // make sure to take only one level of order book to avoid gas inflation.
488         if (actualSrcQty > offerBuyAmt) return 0;
489 
490         rate = calcRateFromQty(offerBuyAmt, offerPayAmt, COMMON_DECIMALS, COMMON_DECIMALS);
491         return valueAfterReducingFee(rate);
492     }
493 
494     function doTrade(
495         ERC20 srcToken,
496         uint srcAmount,
497         ERC20 destToken,
498         address destAddress,
499         uint conversionRate,
500         bool validate
501     )
502         internal
503         returns(bool)
504     {
505         uint actualDestAmount;
506 
507         require(validTokens(srcToken, destToken));
508 
509         // can skip validation if done at kyber network level
510         if (validate) {
511             require(conversionRate > 0);
512             if (srcToken == ETH_TOKEN_ADDRESS)
513                 require(msg.value == srcAmount);
514             else
515                 require(msg.value == 0);
516         }
517 
518         uint userExpectedDestAmount = calcDstQty(srcAmount, COMMON_DECIMALS, COMMON_DECIMALS, conversionRate);
519         require(userExpectedDestAmount > 0); // sanity check
520 
521         uint destAmountIncludingFees = valueBeforeFeesWereReduced(userExpectedDestAmount);
522 
523         if (srcToken == ETH_TOKEN_ADDRESS) {
524             wethToken.deposit.value(msg.value)();
525 
526             actualDestAmount = takeMatchingOffer(wethToken, destToken, srcAmount);
527             require(actualDestAmount >= destAmountIncludingFees);
528 
529             // transfer back only requested dest amount.
530             require(destToken.transfer(destAddress, userExpectedDestAmount));
531         } else {
532             require(srcToken.transferFrom(msg.sender, this, srcAmount));
533  
534             actualDestAmount = takeMatchingOffer(srcToken, wethToken, srcAmount);
535             require(actualDestAmount >= destAmountIncludingFees);
536             wethToken.withdraw(actualDestAmount);
537 
538             // transfer back only requested dest amount.
539             destAddress.transfer(userExpectedDestAmount); 
540         }
541 
542         TradeExecute(msg.sender, srcToken, srcAmount, destToken, userExpectedDestAmount, destAddress);
543 
544         return true;
545     }
546 
547     function takeMatchingOffer(
548         ERC20 srcToken,
549         ERC20 destToken,
550         uint srcAmount
551     )
552         internal
553         returns(uint actualDestAmount)
554     {
555         uint offerId;
556         uint offerPayAmt;
557         uint offerBuyAmt;
558 
559         // otc's terminology is of offer maker, so their sellGem is our (the taker's) dest token.
560         (offerId, offerPayAmt, offerBuyAmt) = getMatchingOffer(destToken, srcToken, srcAmount);
561 
562         require(srcAmount <= MAX_QTY);
563         require(offerPayAmt <= MAX_QTY);
564         actualDestAmount = srcAmount * offerPayAmt / offerBuyAmt;
565 
566         require(uint128(actualDestAmount) == actualDestAmount);
567         otc.take(bytes32(offerId), uint128(actualDestAmount));  // Take the portion of the offer that we need
568         return;
569     }
570 
571     function getMatchingOffer(
572         ERC20 offerSellGem,
573         ERC20 offerBuyGem,
574         uint payAmount
575     )
576         internal
577         view
578         returns(
579             uint offerId,
580             uint offerPayAmount,
581             uint offerBuyAmount
582         )
583     {
584         offerId = otc.getBestOffer(offerSellGem, offerBuyGem);
585         (offerPayAmount, , offerBuyAmount, ) = otc.getOffer(offerId);
586         uint depth = 1;
587 
588         while (payAmount > offerBuyAmount) {
589             offerId = otc.getWorseOffer(offerId); // We look for the next best offer
590             if (offerId == 0 || ++depth > 7) {
591                 offerId = 0;
592                 offerPayAmount = 0;
593                 offerBuyAmount = 0;
594                 break;
595             }
596             (offerPayAmount, , offerBuyAmount, ) = otc.getOffer(offerId);
597         }
598 
599         return;
600     }
601 
602     function validTokens(ERC20 src, ERC20 dest) internal view returns (bool valid) {
603         return ((isTokenListed[src] && ETH_TOKEN_ADDRESS == dest) ||
604                 (isTokenListed[dest] && ETH_TOKEN_ADDRESS == src));
605     }
606 }