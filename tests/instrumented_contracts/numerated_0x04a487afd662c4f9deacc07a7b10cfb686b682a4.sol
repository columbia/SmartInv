1 pragma solidity 0.4.18;
2 
3 // File: /home/yaron/kyber/oasis_set_otc/smart-contracts/contracts/ERC20Interface.sol
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
17 // File: /home/yaron/kyber/oasis_set_otc/smart-contracts/contracts/Utils.sol
18 
19 /// @title Kyber constants contract
20 contract Utils {
21 
22     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
23     uint  constant internal PRECISION = (10**18);
24     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
25     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
26     uint  constant internal MAX_DECIMALS = 18;
27     uint  constant internal ETH_DECIMALS = 18;
28     mapping(address=>uint) internal decimals;
29 
30     function setDecimals(ERC20 token) internal {
31         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
32         else decimals[token] = token.decimals();
33     }
34 
35     function getDecimals(ERC20 token) internal view returns(uint) {
36         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
37         uint tokenDecimals = decimals[token];
38         // technically, there might be token with decimals 0
39         // moreover, very possible that old tokens have decimals 0
40         // these tokens will just have higher gas fees.
41         if(tokenDecimals == 0) return token.decimals();
42 
43         return tokenDecimals;
44     }
45 
46     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
47         require(srcQty <= MAX_QTY);
48         require(rate <= MAX_RATE);
49 
50         if (dstDecimals >= srcDecimals) {
51             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
52             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
53         } else {
54             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
55             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
56         }
57     }
58 
59     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
60         require(dstQty <= MAX_QTY);
61         require(rate <= MAX_RATE);
62         
63         //source quantity is rounded up. to avoid dest quantity being too low.
64         uint numerator;
65         uint denominator;
66         if (srcDecimals >= dstDecimals) {
67             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
68             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
69             denominator = rate;
70         } else {
71             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
72             numerator = (PRECISION * dstQty);
73             denominator = (rate * (10**(dstDecimals - srcDecimals)));
74         }
75         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
76     }
77 }
78 
79 // File: /home/yaron/kyber/oasis_set_otc/smart-contracts/contracts/Utils2.sol
80 
81 contract Utils2 is Utils {
82 
83     /// @dev get the balance of a user.
84     /// @param token The token type
85     /// @return The balance
86     function getBalance(ERC20 token, address user) public view returns(uint) {
87         if (token == ETH_TOKEN_ADDRESS)
88             return user.balance;
89         else
90             return token.balanceOf(user);
91     }
92 
93     function getDecimalsSafe(ERC20 token) internal returns(uint) {
94 
95         if (decimals[token] == 0) {
96             setDecimals(token);
97         }
98 
99         return decimals[token];
100     }
101 
102     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
103         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
104     }
105 
106     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
107         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
108     }
109 
110     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
111         internal pure returns(uint)
112     {
113         require(srcAmount <= MAX_QTY);
114         require(destAmount <= MAX_QTY);
115 
116         if (dstDecimals >= srcDecimals) {
117             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
118             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
119         } else {
120             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
121             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
122         }
123     }
124 }
125 
126 // File: /home/yaron/kyber/oasis_set_otc/smart-contracts/contracts/PermissionGroups.sol
127 
128 contract PermissionGroups {
129 
130     address public admin;
131     address public pendingAdmin;
132     mapping(address=>bool) internal operators;
133     mapping(address=>bool) internal alerters;
134     address[] internal operatorsGroup;
135     address[] internal alertersGroup;
136     uint constant internal MAX_GROUP_SIZE = 50;
137 
138     function PermissionGroups() public {
139         admin = msg.sender;
140     }
141 
142     modifier onlyAdmin() {
143         require(msg.sender == admin);
144         _;
145     }
146 
147     modifier onlyOperator() {
148         require(operators[msg.sender]);
149         _;
150     }
151 
152     modifier onlyAlerter() {
153         require(alerters[msg.sender]);
154         _;
155     }
156 
157     function getOperators () external view returns(address[]) {
158         return operatorsGroup;
159     }
160 
161     function getAlerters () external view returns(address[]) {
162         return alertersGroup;
163     }
164 
165     event TransferAdminPending(address pendingAdmin);
166 
167     /**
168      * @dev Allows the current admin to set the pendingAdmin address.
169      * @param newAdmin The address to transfer ownership to.
170      */
171     function transferAdmin(address newAdmin) public onlyAdmin {
172         require(newAdmin != address(0));
173         TransferAdminPending(pendingAdmin);
174         pendingAdmin = newAdmin;
175     }
176 
177     /**
178      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
179      * @param newAdmin The address to transfer ownership to.
180      */
181     function transferAdminQuickly(address newAdmin) public onlyAdmin {
182         require(newAdmin != address(0));
183         TransferAdminPending(newAdmin);
184         AdminClaimed(newAdmin, admin);
185         admin = newAdmin;
186     }
187 
188     event AdminClaimed( address newAdmin, address previousAdmin);
189 
190     /**
191      * @dev Allows the pendingAdmin address to finalize the change admin process.
192      */
193     function claimAdmin() public {
194         require(pendingAdmin == msg.sender);
195         AdminClaimed(pendingAdmin, admin);
196         admin = pendingAdmin;
197         pendingAdmin = address(0);
198     }
199 
200     event AlerterAdded (address newAlerter, bool isAdd);
201 
202     function addAlerter(address newAlerter) public onlyAdmin {
203         require(!alerters[newAlerter]); // prevent duplicates.
204         require(alertersGroup.length < MAX_GROUP_SIZE);
205 
206         AlerterAdded(newAlerter, true);
207         alerters[newAlerter] = true;
208         alertersGroup.push(newAlerter);
209     }
210 
211     function removeAlerter (address alerter) public onlyAdmin {
212         require(alerters[alerter]);
213         alerters[alerter] = false;
214 
215         for (uint i = 0; i < alertersGroup.length; ++i) {
216             if (alertersGroup[i] == alerter) {
217                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
218                 alertersGroup.length--;
219                 AlerterAdded(alerter, false);
220                 break;
221             }
222         }
223     }
224 
225     event OperatorAdded(address newOperator, bool isAdd);
226 
227     function addOperator(address newOperator) public onlyAdmin {
228         require(!operators[newOperator]); // prevent duplicates.
229         require(operatorsGroup.length < MAX_GROUP_SIZE);
230 
231         OperatorAdded(newOperator, true);
232         operators[newOperator] = true;
233         operatorsGroup.push(newOperator);
234     }
235 
236     function removeOperator (address operator) public onlyAdmin {
237         require(operators[operator]);
238         operators[operator] = false;
239 
240         for (uint i = 0; i < operatorsGroup.length; ++i) {
241             if (operatorsGroup[i] == operator) {
242                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
243                 operatorsGroup.length -= 1;
244                 OperatorAdded(operator, false);
245                 break;
246             }
247         }
248     }
249 }
250 
251 // File: /home/yaron/kyber/oasis_set_otc/smart-contracts/contracts/Withdrawable.sol
252 
253 /**
254  * @title Contracts that should be able to recover tokens or ethers
255  * @author Ilan Doron
256  * @dev This allows to recover any tokens or Ethers received in a contract.
257  * This will prevent any accidental loss of tokens.
258  */
259 contract Withdrawable is PermissionGroups {
260 
261     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
262 
263     /**
264      * @dev Withdraw all ERC20 compatible tokens
265      * @param token ERC20 The address of the token contract
266      */
267     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
268         require(token.transfer(sendTo, amount));
269         TokenWithdraw(token, amount, sendTo);
270     }
271 
272     event EtherWithdraw(uint amount, address sendTo);
273 
274     /**
275      * @dev Withdraw Ethers
276      */
277     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
278         sendTo.transfer(amount);
279         EtherWithdraw(amount, sendTo);
280     }
281 }
282 
283 // File: /home/yaron/kyber/oasis_set_otc/smart-contracts/contracts/KyberReserveInterface.sol
284 
285 /// @title Kyber Reserve contract
286 interface KyberReserveInterface {
287 
288     function trade(
289         ERC20 srcToken,
290         uint srcAmount,
291         ERC20 destToken,
292         address destAddress,
293         uint conversionRate,
294         bool validate
295     )
296         public
297         payable
298         returns(bool);
299 
300     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
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
328     mapping(address=>uint) public minTokenBalance;
329     mapping(address=>uint) public maxTokenBalance;
330     mapping(address=>uint) public internalPricePremiumBps;
331     mapping(address=>uint) public minOasisSpreadForinternalPricingBps;
332     bool public tradeEnabled;
333     uint public feeBps;
334 
335     function KyberOasisReserve(
336         address _kyberNetwork,
337         OtcInterface _otc,
338         WethInterface _wethToken,
339         address _admin,
340         uint _feeBps
341     )
342         public
343     {
344         require(_admin != address(0));
345         require(_kyberNetwork != address(0));
346         require(_otc != address(0));
347         require(_wethToken != address(0));
348         require(_feeBps < 10000);
349         require(getDecimals(_wethToken) == COMMON_DECIMALS);
350 
351         kyberNetwork = _kyberNetwork;
352         otc = _otc;
353         wethToken = _wethToken;
354         admin = _admin;
355         feeBps = _feeBps;
356         tradeEnabled = true;
357 
358         require(wethToken.approve(otc, 2**255));
359     }
360 
361     function() public payable {
362         // anyone can deposit ether
363     }
364 
365     function listToken(ERC20 token, uint minSrcAmount) public onlyAdmin {
366         require(token != address(0));
367         require(!isTokenListed[token]);
368         require(getDecimals(token) == COMMON_DECIMALS);
369 
370         require(token.approve(otc, 2**255));
371         isTokenListed[token] = true;
372         tokenMinSrcAmount[token] = minSrcAmount;
373         minTokenBalance[token] = 2 ** 255; // disable by default
374         maxTokenBalance[token] = 0; // disable by default;
375         internalPricePremiumBps[token] = 0; // NA by default
376         minOasisSpreadForinternalPricingBps[token] = 0; // NA by default
377     }
378 
379     function delistToken(ERC20 token) public onlyAdmin {
380         require(isTokenListed[token]);
381 
382         require(token.approve(otc, 0));
383         delete isTokenListed[token];
384         delete tokenMinSrcAmount[token];
385         delete minTokenBalance[token];
386         delete maxTokenBalance[token];
387         delete internalPricePremiumBps[token];
388         delete minOasisSpreadForinternalPricingBps[token];
389     }
390 
391     function setInternalPriceAdminParams(ERC20 token,
392                                          uint minSpreadBps,
393                                          uint premiumBps) public onlyAdmin {
394         require(isTokenListed[token]);
395         require(premiumBps <= 500); // premium <= 5%
396         require(minSpreadBps <= 1000); // min spread <= 10%
397 
398         internalPricePremiumBps[token] = premiumBps;
399         minOasisSpreadForinternalPricingBps[token] = minSpreadBps;
400     }
401 
402     function setInternalInventoryMinMax(ERC20 token,
403                                         uint  minBalance,
404                                         uint  maxBalance) public onlyOperator {
405         require(isTokenListed[token]);
406 
407         // don't require anything on min and max balance as it might be used for disable
408         minTokenBalance[token] = minBalance;
409         maxTokenBalance[token] = maxBalance;
410     }
411 
412     event TradeExecute(
413         address indexed sender,
414         address src,
415         uint srcAmount,
416         address destToken,
417         uint destAmount,
418         address destAddress
419     );
420 
421     function trade(
422         ERC20 srcToken,
423         uint srcAmount,
424         ERC20 destToken,
425         address destAddress,
426         uint conversionRate,
427         bool validate
428     )
429         public
430         payable
431         returns(bool)
432     {
433 
434         require(tradeEnabled);
435         require(msg.sender == kyberNetwork);
436 
437         require(doTrade(srcToken, srcAmount, destToken, destAddress, conversionRate, validate));
438 
439         return true;
440     }
441 
442     event TradeEnabled(bool enable);
443 
444     function enableTrade() public onlyAdmin returns(bool) {
445         tradeEnabled = true;
446         TradeEnabled(true);
447 
448         return true;
449     }
450 
451     function disableTrade() public onlyAlerter returns(bool) {
452         tradeEnabled = false;
453         TradeEnabled(false);
454 
455         return true;
456     }
457 
458     event KyberNetworkSet(address kyberNetwork);
459 
460     function setKyberNetwork(address _kyberNetwork) public onlyAdmin {
461         require(_kyberNetwork != address(0));
462 
463         kyberNetwork = _kyberNetwork;
464         KyberNetworkSet(kyberNetwork);
465     }
466 
467     event FeeBpsSet(uint feeBps);
468 
469     function setFeeBps(uint _feeBps) public onlyAdmin {
470         require(_feeBps < 10000);
471 
472         feeBps = _feeBps;
473         FeeBpsSet(feeBps);
474     }
475 
476     function valueAfterReducingFee(uint val) public view returns(uint) {
477         require(val <= MAX_QTY);
478         return ((10000 - feeBps) * val) / 10000;
479     }
480 
481     function valueBeforeFeesWereReduced(uint val) public view returns(uint) {
482         require(val <= MAX_QTY);
483         return val * 10000 / (10000 - feeBps);
484     }
485 
486     function valueAfterAddingPremium(ERC20 token, uint val) public view returns(uint) {
487         require(val <= MAX_QTY);
488         uint premium = internalPricePremiumBps[token];
489 
490         return val * (10000 + premium) / 10000;
491     }
492     function shouldUseInternalInventory(ERC20 token,
493                                         uint tokenVal,
494                                         uint ethVal,
495                                         bool ethToToken) public view returns(bool) {
496         require(tokenVal <= MAX_QTY);
497 
498         uint tokenBalance = token.balanceOf(this);
499         if (ethToToken) {
500             if (tokenBalance < tokenVal) return false;
501             if (tokenBalance - tokenVal < minTokenBalance[token]) return false;
502         }
503         else {
504             if (this.balance < ethVal) return false;
505             if (tokenBalance + tokenVal > maxTokenBalance[token]) return false;
506         }
507 
508         // check that spread in first level makes sense
509         uint x1; uint y1; uint x2; uint y2;
510         (,x1,y1) = getMatchingOffer(token, wethToken, 0);
511         (,y2,x2) = getMatchingOffer(wethToken, token, 0);
512 
513         require(x1 <= MAX_QTY && x2 <= MAX_QTY && y1 <= MAX_QTY && y2 <= MAX_QTY);
514 
515         // check if there is an arbitrage
516         if (x1*y2 > x2*y1) return false;
517 
518         // spread is (x1/y1 - x2/y2) / (x1/y1)
519         if (10000 * (x2*y1 - x1*y2) < x1*y2*minOasisSpreadForinternalPricingBps[token]) return false;
520 
521 
522         return true;
523     }
524 
525     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint) {
526         uint  rate;
527         uint  actualSrcQty;
528         ERC20 actualSrc;
529         ERC20 actualDest;
530         uint offerPayAmt;
531         uint offerBuyAmt;
532 
533         blockNumber;
534 
535         if (!tradeEnabled) return 0;
536         if (!validTokens(src, dest)) return 0;
537 
538         if (src == ETH_TOKEN_ADDRESS) {
539             actualSrc = wethToken;
540             actualDest = dest;
541             actualSrcQty = srcQty;
542         } else if (dest == ETH_TOKEN_ADDRESS) {
543             actualSrc = src;
544             actualDest = wethToken;
545 
546             if (srcQty < tokenMinSrcAmount[src]) {
547                 /* remove rounding errors and present rate for 0 src amount. */
548                 actualSrcQty = tokenMinSrcAmount[src];
549             } else {
550                 actualSrcQty = srcQty;
551             }
552         } else {
553             return 0;
554         }
555 
556         // otc's terminology is of offer maker, so their sellGem is the taker's dest token.
557         (, offerPayAmt, offerBuyAmt) = getMatchingOffer(actualDest, actualSrc, actualSrcQty);
558 
559         // make sure to take only one level of order book to avoid gas inflation.
560         if (actualSrcQty > offerBuyAmt) return 0;
561 
562         bool tradeFromInventory = false;
563         uint valueWithPremium = valueAfterAddingPremium(token, offerPayAmt);
564         ERC20 token;
565         if (src == ETH_TOKEN_ADDRESS) {
566             token = dest;
567             tradeFromInventory = shouldUseInternalInventory(token,
568                                                             valueWithPremium,
569                                                             offerBuyAmt,
570                                                             true);
571         }
572         else {
573             token = src;
574             tradeFromInventory = shouldUseInternalInventory(token,
575                                                             offerBuyAmt,
576                                                             valueWithPremium,
577                                                             false);
578         }
579 
580         rate = calcRateFromQty(offerBuyAmt, offerPayAmt, COMMON_DECIMALS, COMMON_DECIMALS);
581 
582         if (tradeFromInventory) return valueAfterAddingPremium(token,rate);
583         else return valueAfterReducingFee(rate);
584     }
585 
586     function doTrade(
587         ERC20 srcToken,
588         uint srcAmount,
589         ERC20 destToken,
590         address destAddress,
591         uint conversionRate,
592         bool validate
593     )
594         internal
595         returns(bool)
596     {
597         uint actualDestAmount;
598 
599         require(validTokens(srcToken, destToken));
600 
601         // can skip validation if done at kyber network level
602         if (validate) {
603             require(conversionRate > 0);
604             if (srcToken == ETH_TOKEN_ADDRESS)
605                 require(msg.value == srcAmount);
606             else
607                 require(msg.value == 0);
608         }
609 
610         uint userExpectedDestAmount = calcDstQty(srcAmount, COMMON_DECIMALS, COMMON_DECIMALS, conversionRate);
611         require(userExpectedDestAmount > 0); // sanity check
612 
613         uint destAmountIncludingFees = valueBeforeFeesWereReduced(userExpectedDestAmount);
614 
615         if (srcToken == ETH_TOKEN_ADDRESS) {
616             if(!shouldUseInternalInventory(destToken,
617                                            userExpectedDestAmount,
618                                            0,
619                                            true)) {
620                 wethToken.deposit.value(msg.value)();
621 
622                 actualDestAmount = takeMatchingOffer(wethToken, destToken, srcAmount);
623                 require(actualDestAmount >= destAmountIncludingFees);
624             }
625 
626             // transfer back only requested dest amount.
627             require(destToken.transfer(destAddress, userExpectedDestAmount));
628         } else {
629             require(srcToken.transferFrom(msg.sender, this, srcAmount));
630 
631             if(!shouldUseInternalInventory(srcToken,
632                                            0,
633                                            userExpectedDestAmount,
634                                            false)) {
635                 actualDestAmount = takeMatchingOffer(srcToken, wethToken, srcAmount);
636                 require(actualDestAmount >= destAmountIncludingFees);
637                 wethToken.withdraw(actualDestAmount);
638             }
639 
640             // transfer back only requested dest amount.
641             destAddress.transfer(userExpectedDestAmount);
642         }
643 
644         TradeExecute(msg.sender, srcToken, srcAmount, destToken, userExpectedDestAmount, destAddress);
645 
646         return true;
647     }
648 
649     function takeMatchingOffer(
650         ERC20 srcToken,
651         ERC20 destToken,
652         uint srcAmount
653     )
654         internal
655         returns(uint actualDestAmount)
656     {
657         uint offerId;
658         uint offerPayAmt;
659         uint offerBuyAmt;
660 
661         // otc's terminology is of offer maker, so their sellGem is our (the taker's) dest token.
662         (offerId, offerPayAmt, offerBuyAmt) = getMatchingOffer(destToken, srcToken, srcAmount);
663 
664         require(srcAmount <= MAX_QTY);
665         require(offerPayAmt <= MAX_QTY);
666         actualDestAmount = srcAmount * offerPayAmt / offerBuyAmt;
667 
668         require(uint128(actualDestAmount) == actualDestAmount);
669         otc.take(bytes32(offerId), uint128(actualDestAmount));  // Take the portion of the offer that we need
670         return;
671     }
672 
673     function getMatchingOffer(
674         ERC20 offerSellGem,
675         ERC20 offerBuyGem,
676         uint payAmount
677     )
678         internal
679         view
680         returns(
681             uint offerId,
682             uint offerPayAmount,
683             uint offerBuyAmount
684         )
685     {
686         offerId = otc.getBestOffer(offerSellGem, offerBuyGem);
687         (offerPayAmount, , offerBuyAmount, ) = otc.getOffer(offerId);
688         uint depth = 1;
689 
690         while (payAmount > offerBuyAmount) {
691             offerId = otc.getWorseOffer(offerId); // We look for the next best offer
692             if (offerId == 0 || ++depth > 7) {
693                 offerId = 0;
694                 offerPayAmount = 0;
695                 offerBuyAmount = 0;
696                 break;
697             }
698             (offerPayAmount, , offerBuyAmount, ) = otc.getOffer(offerId);
699         }
700 
701         return;
702     }
703 
704     function validTokens(ERC20 src, ERC20 dest) internal view returns (bool valid) {
705         return ((isTokenListed[src] && ETH_TOKEN_ADDRESS == dest) ||
706                 (isTokenListed[dest] && ETH_TOKEN_ADDRESS == src));
707     }
708 }