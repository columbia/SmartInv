1 pragma solidity 0.4.18;
2 
3 interface ERC20 {
4     function totalSupply() public view returns (uint supply);
5     function balanceOf(address _owner) public view returns (uint balance);
6     function transfer(address _to, uint _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
8     function approve(address _spender, uint _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public view returns (uint remaining);
10     function decimals() public view returns(uint digits);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 interface KyberReserveInterface {
15 
16     function trade(
17         ERC20 srcToken,
18         uint srcAmount,
19         ERC20 destToken,
20         address destAddress,
21         uint conversionRate,
22         bool validate
23     )
24         public
25         payable
26         returns(bool);
27 
28     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
29 }
30 
31 contract Utils {
32 
33     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
34     uint  constant internal PRECISION = (10**18);
35     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
36     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
37     uint  constant internal MAX_DECIMALS = 18;
38     uint  constant internal ETH_DECIMALS = 18;
39     mapping(address=>uint) internal decimals;
40 
41     function setDecimals(ERC20 token) internal {
42         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
43         else decimals[token] = token.decimals();
44     }
45 
46     function getDecimals(ERC20 token) internal view returns(uint) {
47         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
48         uint tokenDecimals = decimals[token];
49         // technically, there might be token with decimals 0
50         // moreover, very possible that old tokens have decimals 0
51         // these tokens will just have higher gas fees.
52         if(tokenDecimals == 0) return token.decimals();
53 
54         return tokenDecimals;
55     }
56 
57     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
58         require(srcQty <= MAX_QTY);
59         require(rate <= MAX_RATE);
60 
61         if (dstDecimals >= srcDecimals) {
62             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
63             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
64         } else {
65             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
66             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
67         }
68     }
69 
70     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
71         require(dstQty <= MAX_QTY);
72         require(rate <= MAX_RATE);
73 
74         //source quantity is rounded up. to avoid dest quantity being too low.
75         uint numerator;
76         uint denominator;
77         if (srcDecimals >= dstDecimals) {
78             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
79             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
80             denominator = rate;
81         } else {
82             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
83             numerator = (PRECISION * dstQty);
84             denominator = (rate * (10**(dstDecimals - srcDecimals)));
85         }
86         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
87     }
88 }
89 
90 contract WhiteListInterface {
91     function getUserCapInWei(address user) external view returns (uint userCapWei);
92 }
93 
94 interface FeeBurnerInterface {
95     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
96 }
97 
98 interface ExpectedRateInterface {
99     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
100         returns (uint expectedRate, uint slippageRate);
101 }
102 
103 contract PermissionGroups {
104 
105     address public admin;
106     address public pendingAdmin;
107     mapping(address=>bool) internal operators;
108     mapping(address=>bool) internal alerters;
109     address[] internal operatorsGroup;
110     address[] internal alertersGroup;
111     uint constant internal MAX_GROUP_SIZE = 50;
112 
113     function PermissionGroups() public {
114         admin = msg.sender;
115     }
116 
117     modifier onlyAdmin() {
118         require(msg.sender == admin);
119         _;
120     }
121 
122     modifier onlyOperator() {
123         require(operators[msg.sender]);
124         _;
125     }
126 
127     modifier onlyAlerter() {
128         require(alerters[msg.sender]);
129         _;
130     }
131 
132     function getOperators () external view returns(address[]) {
133         return operatorsGroup;
134     }
135 
136     function getAlerters () external view returns(address[]) {
137         return alertersGroup;
138     }
139 
140     event TransferAdminPending(address pendingAdmin);
141 
142     /**
143      * @dev Allows the current admin to set the pendingAdmin address.
144      * @param newAdmin The address to transfer ownership to.
145      */
146     function transferAdmin(address newAdmin) public onlyAdmin {
147         require(newAdmin != address(0));
148         TransferAdminPending(pendingAdmin);
149         pendingAdmin = newAdmin;
150     }
151 
152     /**
153      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
154      * @param newAdmin The address to transfer ownership to.
155      */
156     function transferAdminQuickly(address newAdmin) public onlyAdmin {
157         require(newAdmin != address(0));
158         TransferAdminPending(newAdmin);
159         AdminClaimed(newAdmin, admin);
160         admin = newAdmin;
161     }
162 
163     event AdminClaimed( address newAdmin, address previousAdmin);
164 
165     /**
166      * @dev Allows the pendingAdmin address to finalize the change admin process.
167      */
168     function claimAdmin() public {
169         require(pendingAdmin == msg.sender);
170         AdminClaimed(pendingAdmin, admin);
171         admin = pendingAdmin;
172         pendingAdmin = address(0);
173     }
174 
175     event AlerterAdded (address newAlerter, bool isAdd);
176 
177     function addAlerter(address newAlerter) public onlyAdmin {
178         require(!alerters[newAlerter]); // prevent duplicates.
179         require(alertersGroup.length < MAX_GROUP_SIZE);
180 
181         AlerterAdded(newAlerter, true);
182         alerters[newAlerter] = true;
183         alertersGroup.push(newAlerter);
184     }
185 
186     function removeAlerter (address alerter) public onlyAdmin {
187         require(alerters[alerter]);
188         alerters[alerter] = false;
189 
190         for (uint i = 0; i < alertersGroup.length; ++i) {
191             if (alertersGroup[i] == alerter) {
192                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
193                 alertersGroup.length--;
194                 AlerterAdded(alerter, false);
195                 break;
196             }
197         }
198     }
199 
200     event OperatorAdded(address newOperator, bool isAdd);
201 
202     function addOperator(address newOperator) public onlyAdmin {
203         require(!operators[newOperator]); // prevent duplicates.
204         require(operatorsGroup.length < MAX_GROUP_SIZE);
205 
206         OperatorAdded(newOperator, true);
207         operators[newOperator] = true;
208         operatorsGroup.push(newOperator);
209     }
210 
211     function removeOperator (address operator) public onlyAdmin {
212         require(operators[operator]);
213         operators[operator] = false;
214 
215         for (uint i = 0; i < operatorsGroup.length; ++i) {
216             if (operatorsGroup[i] == operator) {
217                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
218                 operatorsGroup.length -= 1;
219                 OperatorAdded(operator, false);
220                 break;
221             }
222         }
223     }
224 }
225 
226 contract Withdrawable is PermissionGroups {
227 
228     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
229 
230     /**
231      * @dev Withdraw all ERC20 compatible tokens
232      * @param token ERC20 The address of the token contract
233      */
234     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
235         require(token.transfer(sendTo, amount));
236         TokenWithdraw(token, amount, sendTo);
237     }
238 
239     event EtherWithdraw(uint amount, address sendTo);
240 
241     /**
242      * @dev Withdraw Ethers
243      */
244     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
245         sendTo.transfer(amount);
246         EtherWithdraw(amount, sendTo);
247     }
248 }
249 
250 contract KyberNetwork is Withdrawable, Utils {
251 
252     uint public negligibleRateDiff = 10; // basic rate steps will be in 0.01%
253     KyberReserveInterface[] public reserves;
254     mapping(address=>bool) public isReserve;
255     WhiteListInterface public whiteListContract;
256     ExpectedRateInterface public expectedRateContract;
257     FeeBurnerInterface    public feeBurnerContract;
258     uint                  public maxGasPrice = 50 * 1000 * 1000 * 1000; // 50 gwei
259     bool                  public enabled = false; // network is enabled
260     mapping(bytes32=>uint) public info; // this is only a UI field for external app.
261     mapping(address=>mapping(bytes32=>bool)) public perReserveListedPairs;
262 
263     function KyberNetwork(address _admin) public {
264         require(_admin != address(0));
265         admin = _admin;
266     }
267 
268     event EtherReceival(address indexed sender, uint amount);
269 
270     /* solhint-disable no-complex-fallback */
271     function() public payable {
272         require(isReserve[msg.sender]);
273         EtherReceival(msg.sender, msg.value);
274     }
275     /* solhint-enable no-complex-fallback */
276 
277     event ExecuteTrade(address indexed sender, ERC20 src, ERC20 dest, uint actualSrcAmount, uint actualDestAmount);
278 
279     /// @notice use token address ETH_TOKEN_ADDRESS for ether
280     /// @dev makes a trade between src and dest token and send dest token to destAddress
281     /// @param src Src token
282     /// @param srcAmount amount of src tokens
283     /// @param dest   Destination token
284     /// @param destAddress Address to send tokens to
285     /// @param maxDestAmount A limit on the amount of dest tokens
286     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
287     /// @param walletId is the wallet ID to send part of the fees
288     /// @return amount of actual dest tokens
289     function trade(
290         ERC20 src,
291         uint srcAmount,
292         ERC20 dest,
293         address destAddress,
294         uint maxDestAmount,
295         uint minConversionRate,
296         address walletId
297     )
298         public
299         payable
300         returns(uint)
301     {
302         require(enabled);
303 
304         uint userSrcBalanceBefore;
305         uint userSrcBalanceAfter;
306         uint userDestBalanceBefore;
307         uint userDestBalanceAfter;
308 
309         userSrcBalanceBefore = getBalance(src, msg.sender);
310         if (src == ETH_TOKEN_ADDRESS)
311             userSrcBalanceBefore += msg.value;
312         userDestBalanceBefore = getBalance(dest, destAddress);
313 
314         uint actualDestAmount = doTrade(src,
315                                         srcAmount,
316                                         dest,
317                                         destAddress,
318                                         maxDestAmount,
319                                         minConversionRate,
320                                         walletId
321                                         );
322         require(actualDestAmount > 0);
323 
324         userSrcBalanceAfter = getBalance(src, msg.sender);
325         userDestBalanceAfter = getBalance(dest, destAddress);
326 
327         require(userSrcBalanceAfter <= userSrcBalanceBefore);
328         require(userDestBalanceAfter >= userDestBalanceBefore);
329 
330         require((userDestBalanceAfter - userDestBalanceBefore) >=
331             calcDstQty((userSrcBalanceBefore - userSrcBalanceAfter), getDecimals(src), getDecimals(dest),
332                 minConversionRate));
333 
334         return actualDestAmount;
335     }
336 
337     event AddReserveToNetwork(KyberReserveInterface reserve, bool add);
338 
339     /// @notice can be called only by admin
340     /// @dev add or deletes a reserve to/from the network.
341     /// @param reserve The reserve address.
342     /// @param add If true, the add reserve. Otherwise delete reserve.
343     function addReserve(KyberReserveInterface reserve, bool add) public onlyAdmin {
344 
345         if (add) {
346             require(!isReserve[reserve]);
347             reserves.push(reserve);
348             isReserve[reserve] = true;
349             AddReserveToNetwork(reserve, true);
350         } else {
351             isReserve[reserve] = false;
352             // will have trouble if more than 50k reserves...
353             for (uint i = 0; i < reserves.length; i++) {
354                 if (reserves[i] == reserve) {
355                     reserves[i] = reserves[reserves.length - 1];
356                     reserves.length--;
357                     AddReserveToNetwork(reserve, false);
358                     break;
359                 }
360             }
361         }
362     }
363 
364     event ListReservePairs(address reserve, ERC20 src, ERC20 dest, bool add);
365 
366     /// @notice can be called only by admin
367     /// @dev allow or prevent a specific reserve to trade a pair of tokens
368     /// @param reserve The reserve address.
369     /// @param src Src token
370     /// @param dest Destination token
371     /// @param add If true then enable trade, otherwise delist pair.
372     function listPairForReserve(address reserve, ERC20 src, ERC20 dest, bool add) public onlyAdmin {
373         (perReserveListedPairs[reserve])[keccak256(src, dest)] = add;
374 
375         if (src != ETH_TOKEN_ADDRESS) {
376             if (add) {
377                 src.approve(reserve, 2**255); // approve infinity
378             } else {
379                 src.approve(reserve, 0);
380             }
381         }
382 
383         setDecimals(src);
384         setDecimals(dest);
385 
386         ListReservePairs(reserve, src, dest, add);
387     }
388 
389     function setParams(
390         WhiteListInterface    _whiteList,
391         ExpectedRateInterface _expectedRate,
392         FeeBurnerInterface    _feeBurner,
393         uint                  _maxGasPrice,
394         uint                  _negligibleRateDiff
395     )
396         public
397         onlyAdmin
398     {
399         require(_whiteList != address(0));
400         require(_feeBurner != address(0));
401         require(_expectedRate != address(0));
402         require(_negligibleRateDiff <= 100 * 100); // at most 100%
403 
404         whiteListContract = _whiteList;
405         expectedRateContract = _expectedRate;
406         feeBurnerContract = _feeBurner;
407         maxGasPrice = _maxGasPrice;
408         negligibleRateDiff = _negligibleRateDiff;
409     }
410 
411     function setEnable(bool _enable) public onlyAdmin {
412         if (_enable) {
413             require(whiteListContract != address(0));
414             require(feeBurnerContract != address(0));
415             require(expectedRateContract != address(0));
416         }
417         enabled = _enable;
418     }
419 
420     function setInfo(bytes32 field, uint value) public onlyOperator {
421         info[field] = value;
422     }
423 
424     /// @dev returns number of reserves
425     /// @return number of reserves
426     function getNumReserves() public view returns(uint) {
427         return reserves.length;
428     }
429 
430     /// @notice should be called off chain with as much gas as needed
431     /// @dev get an array of all reserves
432     /// @return An array of all reserves
433     function getReserves() public view returns(KyberReserveInterface[]) {
434         return reserves;
435     }
436 
437     /// @dev get the balance of a user.
438     /// @param token The token type
439     /// @return The balance
440     function getBalance(ERC20 token, address user) public view returns(uint) {
441         if (token == ETH_TOKEN_ADDRESS)
442             return user.balance;
443         else
444             return token.balanceOf(user);
445     }
446 
447     /// @notice use token address ETH_TOKEN_ADDRESS for ether
448     /// @dev best conversion rate for a pair of tokens, if number of reserves have small differences. randomize
449     /// @param src Src token
450     /// @param dest Destination token
451     /* solhint-disable code-complexity */
452     function findBestRate(ERC20 src, ERC20 dest, uint srcQty) public view returns(uint, uint) {
453         uint bestRate = 0;
454         uint bestReserve = 0;
455         uint numRelevantReserves = 0;
456         uint numReserves = reserves.length;
457         uint[] memory rates = new uint[](numReserves);
458         uint[] memory reserveCandidates = new uint[](numReserves);
459 
460         for (uint i = 0; i < numReserves; i++) {
461             //list all reserves that have this token.
462             if (!(perReserveListedPairs[reserves[i]])[keccak256(src, dest)]) continue;
463 
464             rates[i] = reserves[i].getConversionRate(src, dest, srcQty, block.number);
465 
466             if (rates[i] > bestRate) {
467                 //best rate is highest rate
468                 bestRate = rates[i];
469             }
470         }
471 
472         if (bestRate > 0) {
473             uint random = 0;
474             uint smallestRelevantRate = (bestRate * 10000) / (10000 + negligibleRateDiff);
475 
476             for (i = 0; i < numReserves; i++) {
477                 if (rates[i] >= smallestRelevantRate) {
478                     reserveCandidates[numRelevantReserves++] = i;
479                 }
480             }
481 
482             if (numRelevantReserves > 1) {
483                 //when encountering small rate diff from bestRate. draw from relevant reserves
484                 random = uint(block.blockhash(block.number-1)) % numRelevantReserves;
485             }
486 
487             bestReserve = reserveCandidates[random];
488             bestRate = rates[bestReserve];
489         }
490 
491         return (bestReserve, bestRate);
492     }
493     /* solhint-enable code-complexity */
494 
495     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
496         public view
497         returns (uint expectedRate, uint slippageRate)
498     {
499         require(expectedRateContract != address(0));
500         return expectedRateContract.getExpectedRate(src, dest, srcQty);
501     }
502 
503     function getUserCapInWei(address user) public view returns(uint) {
504         return whiteListContract.getUserCapInWei(user);
505     }
506 
507     function doTrade(
508         ERC20 src,
509         uint srcAmount,
510         ERC20 dest,
511         address destAddress,
512         uint maxDestAmount,
513         uint minConversionRate,
514         address walletId
515     )
516         internal
517         returns(uint)
518     {
519         require(tx.gasprice <= maxGasPrice);
520         require(validateTradeInput(src, srcAmount, destAddress));
521 
522         uint reserveInd;
523         uint rate;
524 
525         (reserveInd, rate) = findBestRate(src, dest, srcAmount);
526         KyberReserveInterface theReserve = reserves[reserveInd];
527         require(rate > 0);
528         require(rate < MAX_RATE);
529         require(rate >= minConversionRate);
530 
531         uint actualSrcAmount = srcAmount;
532         uint actualDestAmount = calcDestAmount(src, dest, actualSrcAmount, rate);
533         if (actualDestAmount > maxDestAmount) {
534             actualDestAmount = maxDestAmount;
535             actualSrcAmount = calcSrcAmount(src, dest, actualDestAmount, rate);
536             require(actualSrcAmount <= srcAmount);
537         }
538 
539         // do the trade
540         // verify trade size is smaller than user cap
541         uint ethAmount;
542         if (src == ETH_TOKEN_ADDRESS) {
543             ethAmount = actualSrcAmount;
544         } else {
545             ethAmount = actualDestAmount;
546         }
547 
548         require(ethAmount <= getUserCapInWei(msg.sender));
549         require(doReserveTrade(
550                 src,
551                 actualSrcAmount,
552                 dest,
553                 destAddress,
554                 actualDestAmount,
555                 theReserve,
556                 rate,
557                 true));
558 
559         if ((actualSrcAmount < srcAmount) && (src == ETH_TOKEN_ADDRESS)) {
560             msg.sender.transfer(srcAmount - actualSrcAmount);
561         }
562 
563         require(feeBurnerContract.handleFees(ethAmount, theReserve, walletId));
564 
565         ExecuteTrade(msg.sender, src, dest, actualSrcAmount, actualDestAmount);
566         return actualDestAmount;
567     }
568 
569     /// @notice use token address ETH_TOKEN_ADDRESS for ether
570     /// @dev do one trade with a reserve
571     /// @param src Src token
572     /// @param amount amount of src tokens
573     /// @param dest   Destination token
574     /// @param destAddress Address to send tokens to
575     /// @param reserve Reserve to use
576     /// @param validate If true, additional validations are applicable
577     /// @return true if trade is successful
578     function doReserveTrade(
579         ERC20 src,
580         uint amount,
581         ERC20 dest,
582         address destAddress,
583         uint expectedDestAmount,
584         KyberReserveInterface reserve,
585         uint conversionRate,
586         bool validate
587     )
588         internal
589         returns(bool)
590     {
591         uint callValue = 0;
592 
593         if (src == ETH_TOKEN_ADDRESS) {
594             callValue = amount;
595         } else {
596             // take src tokens to this contract
597             src.transferFrom(msg.sender, this, amount);
598         }
599 
600         // reserve sends tokens/eth to network. network sends it to destination
601         require(reserve.trade.value(callValue)(src, amount, dest, this, conversionRate, validate));
602 
603         if (dest == ETH_TOKEN_ADDRESS) {
604             destAddress.transfer(expectedDestAmount);
605         } else {
606             require(dest.transfer(destAddress, expectedDestAmount));
607         }
608 
609         return true;
610     }
611 
612     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
613         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
614     }
615 
616     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
617         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
618     }
619 
620     /// @notice use token address ETH_TOKEN_ADDRESS for ether
621     /// @dev checks that user sent ether/tokens to contract before trade
622     /// @param src Src token
623     /// @param srcAmount amount of src tokens
624     /// @return true if input is valid
625     function validateTradeInput(ERC20 src, uint srcAmount, address destAddress) internal view returns(bool) {
626         if ((srcAmount >= MAX_QTY) || (srcAmount == 0) || (destAddress == 0))
627             return false;
628 
629         if (src == ETH_TOKEN_ADDRESS) {
630             if (msg.value != srcAmount)
631                 return false;
632         } else {
633             if ((msg.value != 0) || (src.allowance(msg.sender, this) < srcAmount))
634                 return false;
635         }
636 
637         return true;
638     }
639 }
640 
641 contract ExpectedRate is Withdrawable, ExpectedRateInterface, Utils {
642 
643     KyberNetwork public kyberNetwork;
644     uint public quantityFactor = 2;
645     uint public minSlippageFactorInBps = 50;
646 
647     function ExpectedRate(KyberNetwork _kyberNetwork, address _admin) public {
648         require(_admin != address(0));
649         require(_kyberNetwork != address(0));
650         kyberNetwork = _kyberNetwork;
651         admin = _admin;
652     }
653 
654     event QuantityFactorSet (uint newFactor, uint oldFactor, address sender);
655 
656     function setQuantityFactor(uint newFactor) public onlyOperator {
657         require(newFactor <= 100);
658 
659         QuantityFactorSet(quantityFactor, newFactor, msg.sender);
660         quantityFactor = newFactor;
661     }
662 
663     event MinSlippageFactorSet (uint newMin, uint oldMin, address sender);
664 
665     function setMinSlippageFactor(uint bps) public onlyOperator {
666         require(minSlippageFactorInBps <= 100 * 100);
667 
668         MinSlippageFactorSet(bps, minSlippageFactorInBps, msg.sender);
669         minSlippageFactorInBps = bps;
670     }
671 
672     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
673         public view
674         returns (uint expectedRate, uint slippageRate)
675     {
676         require(quantityFactor != 0);
677         require(srcQty <= MAX_QTY);
678         require(srcQty * quantityFactor <= MAX_QTY);
679 
680         uint bestReserve;
681         uint minSlippage;
682 
683         (bestReserve, expectedRate) = kyberNetwork.findBestRate(src, dest, srcQty);
684         (bestReserve, slippageRate) = kyberNetwork.findBestRate(src, dest, (srcQty * quantityFactor));
685 
686         require(expectedRate <= MAX_RATE);
687 
688         minSlippage = ((10000 - minSlippageFactorInBps) * expectedRate) / 10000;
689         if (slippageRate >= minSlippage) {
690             slippageRate = minSlippage;
691         }
692 
693         return (expectedRate, slippageRate);
694     }
695 }