1 pragma solidity 0.4.18;
2 
3 interface KyberReserveInterface {
4 
5     function trade(
6         ERC20 srcToken,
7         uint srcAmount,
8         ERC20 destToken,
9         address destAddress,
10         uint conversionRate,
11         bool validate
12     )
13         public
14         payable
15         returns(bool);
16 
17     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
18 }
19 
20 interface ERC20 {
21     function totalSupply() public view returns (uint supply);
22     function balanceOf(address _owner) public view returns (uint balance);
23     function transfer(address _to, uint _value) public returns (bool success);
24     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
25     function approve(address _spender, uint _value) public returns (bool success);
26     function allowance(address _owner, address _spender) public view returns (uint remaining);
27     function decimals() public view returns(uint digits);
28     event Approval(address indexed _owner, address indexed _spender, uint _value);
29 }
30 
31 interface FeeBurnerInterface {
32     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
33 }
34 
35 contract WhiteListInterface {
36     function getUserCapInWei(address user) external view returns (uint userCapWei);
37 }
38 
39 contract Utils {
40 
41     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
42     uint  constant internal PRECISION = (10**18);
43     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
44     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
45     uint  constant internal MAX_DECIMALS = 18;
46     uint  constant internal ETH_DECIMALS = 18;
47     mapping(address=>uint) internal decimals;
48 
49     function setDecimals(ERC20 token) internal {
50         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
51         else decimals[token] = token.decimals();
52     }
53 
54     function getDecimals(ERC20 token) internal view returns(uint) {
55         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
56         uint tokenDecimals = decimals[token];
57         // technically, there might be token with decimals 0
58         // moreover, very possible that old tokens have decimals 0
59         // these tokens will just have higher gas fees.
60         if(tokenDecimals == 0) return token.decimals();
61 
62         return tokenDecimals;
63     }
64 
65     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
66         require(srcQty <= MAX_QTY);
67         require(rate <= MAX_RATE);
68 
69         if (dstDecimals >= srcDecimals) {
70             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
71             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
72         } else {
73             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
74             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
75         }
76     }
77 
78     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
79         require(dstQty <= MAX_QTY);
80         require(rate <= MAX_RATE);
81 
82         //source quantity is rounded up. to avoid dest quantity being too low.
83         uint numerator;
84         uint denominator;
85         if (srcDecimals >= dstDecimals) {
86             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
87             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
88             denominator = rate;
89         } else {
90             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
91             numerator = (PRECISION * dstQty);
92             denominator = (rate * (10**(dstDecimals - srcDecimals)));
93         }
94         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
95     }
96 }
97 
98 contract PermissionGroups {
99 
100     address public admin;
101     address public pendingAdmin;
102     mapping(address=>bool) internal operators;
103     mapping(address=>bool) internal alerters;
104     address[] internal operatorsGroup;
105     address[] internal alertersGroup;
106     uint constant internal MAX_GROUP_SIZE = 50;
107 
108     function PermissionGroups() public {
109         admin = msg.sender;
110     }
111 
112     modifier onlyAdmin() {
113         require(msg.sender == admin);
114         _;
115     }
116 
117     modifier onlyOperator() {
118         require(operators[msg.sender]);
119         _;
120     }
121 
122     modifier onlyAlerter() {
123         require(alerters[msg.sender]);
124         _;
125     }
126 
127     function getOperators () external view returns(address[]) {
128         return operatorsGroup;
129     }
130 
131     function getAlerters () external view returns(address[]) {
132         return alertersGroup;
133     }
134 
135     event TransferAdminPending(address pendingAdmin);
136 
137     /**
138      * @dev Allows the current admin to set the pendingAdmin address.
139      * @param newAdmin The address to transfer ownership to.
140      */
141     function transferAdmin(address newAdmin) public onlyAdmin {
142         require(newAdmin != address(0));
143         TransferAdminPending(pendingAdmin);
144         pendingAdmin = newAdmin;
145     }
146 
147     /**
148      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
149      * @param newAdmin The address to transfer ownership to.
150      */
151     function transferAdminQuickly(address newAdmin) public onlyAdmin {
152         require(newAdmin != address(0));
153         TransferAdminPending(newAdmin);
154         AdminClaimed(newAdmin, admin);
155         admin = newAdmin;
156     }
157 
158     event AdminClaimed( address newAdmin, address previousAdmin);
159 
160     /**
161      * @dev Allows the pendingAdmin address to finalize the change admin process.
162      */
163     function claimAdmin() public {
164         require(pendingAdmin == msg.sender);
165         AdminClaimed(pendingAdmin, admin);
166         admin = pendingAdmin;
167         pendingAdmin = address(0);
168     }
169 
170     event AlerterAdded (address newAlerter, bool isAdd);
171 
172     function addAlerter(address newAlerter) public onlyAdmin {
173         require(!alerters[newAlerter]); // prevent duplicates.
174         require(alertersGroup.length < MAX_GROUP_SIZE);
175 
176         AlerterAdded(newAlerter, true);
177         alerters[newAlerter] = true;
178         alertersGroup.push(newAlerter);
179     }
180 
181     function removeAlerter (address alerter) public onlyAdmin {
182         require(alerters[alerter]);
183         alerters[alerter] = false;
184 
185         for (uint i = 0; i < alertersGroup.length; ++i) {
186             if (alertersGroup[i] == alerter) {
187                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
188                 alertersGroup.length--;
189                 AlerterAdded(alerter, false);
190                 break;
191             }
192         }
193     }
194 
195     event OperatorAdded(address newOperator, bool isAdd);
196 
197     function addOperator(address newOperator) public onlyAdmin {
198         require(!operators[newOperator]); // prevent duplicates.
199         require(operatorsGroup.length < MAX_GROUP_SIZE);
200 
201         OperatorAdded(newOperator, true);
202         operators[newOperator] = true;
203         operatorsGroup.push(newOperator);
204     }
205 
206     function removeOperator (address operator) public onlyAdmin {
207         require(operators[operator]);
208         operators[operator] = false;
209 
210         for (uint i = 0; i < operatorsGroup.length; ++i) {
211             if (operatorsGroup[i] == operator) {
212                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
213                 operatorsGroup.length -= 1;
214                 OperatorAdded(operator, false);
215                 break;
216             }
217         }
218     }
219 }
220 
221 contract Withdrawable is PermissionGroups {
222 
223     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
224 
225     /**
226      * @dev Withdraw all ERC20 compatible tokens
227      * @param token ERC20 The address of the token contract
228      */
229     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
230         require(token.transfer(sendTo, amount));
231         TokenWithdraw(token, amount, sendTo);
232     }
233 
234     event EtherWithdraw(uint amount, address sendTo);
235 
236     /**
237      * @dev Withdraw Ethers
238      */
239     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
240         sendTo.transfer(amount);
241         EtherWithdraw(amount, sendTo);
242     }
243 }
244 
245 contract KyberNetwork is Withdrawable, Utils {
246 
247     uint public negligibleRateDiff = 10; // basic rate steps will be in 0.01%
248     KyberReserveInterface[] public reserves;
249     mapping(address=>bool) public isReserve;
250     WhiteListInterface public whiteListContract;
251     ExpectedRateInterface public expectedRateContract;
252     FeeBurnerInterface    public feeBurnerContract;
253     uint                  public maxGasPrice = 50 * 1000 * 1000 * 1000; // 50 gwei
254     bool                  public enabled = false; // network is enabled
255     uint                  public networkState; // this is only a field for UI.
256     mapping(address=>mapping(bytes32=>bool)) public perReserveListedPairs;
257 
258     function KyberNetwork(address _admin) public {
259         require(_admin != address(0));
260         admin = _admin;
261     }
262 
263     event EtherReceival(address indexed sender, uint amount);
264 
265     /* solhint-disable no-complex-fallback */
266     function() public payable {
267         require(isReserve[msg.sender]);
268         EtherReceival(msg.sender, msg.value);
269     }
270     /* solhint-enable no-complex-fallback */
271 
272     event ExecuteTrade(address indexed sender, ERC20 src, ERC20 dest, uint actualSrcAmount, uint actualDestAmount);
273 
274     /// @notice use token address ETH_TOKEN_ADDRESS for ether
275     /// @dev makes a trade between src and dest token and send dest token to destAddress
276     /// @param src Src token
277     /// @param srcAmount amount of src tokens
278     /// @param dest   Destination token
279     /// @param destAddress Address to send tokens to
280     /// @param maxDestAmount A limit on the amount of dest tokens
281     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
282     /// @param walletId is the wallet ID to send part of the fees
283     /// @return amount of actual dest tokens
284     function trade(
285         ERC20 src,
286         uint srcAmount,
287         ERC20 dest,
288         address destAddress,
289         uint maxDestAmount,
290         uint minConversionRate,
291         address walletId
292     )
293         public
294         payable
295         returns(uint)
296     {
297         require(enabled);
298 
299         uint userSrcBalanceBefore;
300         uint userSrcBalanceAfter;
301         uint userDestBalanceBefore;
302         uint userDestBalanceAfter;
303 
304         userSrcBalanceBefore = getBalance(src, msg.sender);
305         if (src == ETH_TOKEN_ADDRESS)
306             userSrcBalanceBefore += msg.value;
307         userDestBalanceBefore = getBalance(dest, destAddress);
308 
309         uint actualDestAmount = doTrade(src,
310                                         srcAmount,
311                                         dest,
312                                         destAddress,
313                                         maxDestAmount,
314                                         minConversionRate,
315                                         walletId
316                                         );
317         require(actualDestAmount > 0);
318 
319         userSrcBalanceAfter = getBalance(src, msg.sender);
320         userDestBalanceAfter = getBalance(dest, destAddress);
321 
322         require(userSrcBalanceAfter <= userSrcBalanceBefore);
323         require(userDestBalanceAfter >= userDestBalanceBefore);
324 
325         require((userDestBalanceAfter - userDestBalanceBefore) >=
326             calcDstQty((userSrcBalanceBefore - userSrcBalanceAfter), getDecimals(src), getDecimals(dest),
327                 minConversionRate));
328 
329         return actualDestAmount;
330     }
331 
332     event AddReserveToNetwork(KyberReserveInterface reserve, bool add);
333 
334     /// @notice can be called only by admin
335     /// @dev add or deletes a reserve to/from the network.
336     /// @param reserve The reserve address.
337     /// @param add If true, the add reserve. Otherwise delete reserve.
338     function addReserve(KyberReserveInterface reserve, bool add) public onlyAdmin {
339 
340         if (add) {
341             require(!isReserve[reserve]);
342             reserves.push(reserve);
343             isReserve[reserve] = true;
344             AddReserveToNetwork(reserve, true);
345         } else {
346             isReserve[reserve] = false;
347             // will have trouble if more than 50k reserves...
348             for (uint i = 0; i < reserves.length; i++) {
349                 if (reserves[i] == reserve) {
350                     reserves[i] = reserves[reserves.length - 1];
351                     reserves.length--;
352                     AddReserveToNetwork(reserve, false);
353                     break;
354                 }
355             }
356         }
357     }
358 
359     event ListReservePairs(address reserve, ERC20 src, ERC20 dest, bool add);
360 
361     /// @notice can be called only by admin
362     /// @dev allow or prevent a specific reserve to trade a pair of tokens
363     /// @param reserve The reserve address.
364     /// @param src Src token
365     /// @param dest Destination token
366     /// @param add If true then enable trade, otherwise delist pair.
367     function listPairForReserve(address reserve, ERC20 src, ERC20 dest, bool add) public onlyAdmin {
368         (perReserveListedPairs[reserve])[keccak256(src, dest)] = add;
369 
370         if (src != ETH_TOKEN_ADDRESS) {
371             if (add) {
372                 src.approve(reserve, 2**255); // approve infinity
373             } else {
374                 src.approve(reserve, 0);
375             }
376         }
377 
378         setDecimals(src);
379         setDecimals(dest);
380 
381         ListReservePairs(reserve, src, dest, add);
382     }
383 
384     function setParams(
385         WhiteListInterface    _whiteList,
386         ExpectedRateInterface _expectedRate,
387         FeeBurnerInterface    _feeBurner,
388         uint                  _maxGasPrice,
389         uint                  _negligibleRateDiff
390     )
391         public
392         onlyAdmin
393     {
394         require(_whiteList != address(0));
395         require(_feeBurner != address(0));
396         require(_expectedRate != address(0));
397         whiteListContract = _whiteList;
398         expectedRateContract = _expectedRate;
399         feeBurnerContract = _feeBurner;
400         maxGasPrice = _maxGasPrice;
401         negligibleRateDiff = _negligibleRateDiff;
402     }
403 
404     function setEnable(bool _enable) public onlyAdmin {
405         if (_enable) {
406             require(whiteListContract != address(0));
407             require(feeBurnerContract != address(0));
408             require(expectedRateContract != address(0));
409         }
410         enabled = _enable;
411     }
412 
413     function setNetworkState(uint _networkState) public onlyOperator {
414         networkState = _networkState;
415     }
416 
417     /// @dev returns number of reserves
418     /// @return number of reserves
419     function getNumReserves() public view returns(uint) {
420         return reserves.length;
421     }
422 
423     /// @notice should be called off chain with as much gas as needed
424     /// @dev get an array of all reserves
425     /// @return An array of all reserves
426     function getReserves() public view returns(KyberReserveInterface[]) {
427         return reserves;
428     }
429 
430     /// @dev get the balance of a user.
431     /// @param token The token type
432     /// @return The balance
433     function getBalance(ERC20 token, address user) public view returns(uint) {
434         if (token == ETH_TOKEN_ADDRESS)
435             return user.balance;
436         else
437             return token.balanceOf(user);
438     }
439 
440     /// @notice use token address ETH_TOKEN_ADDRESS for ether
441     /// @dev best conversion rate for a pair of tokens, if number of reserves have small differences. randomize
442     /// @param src Src token
443     /// @param dest Destination token
444     /* solhint-disable code-complexity */
445     function findBestRate(ERC20 src, ERC20 dest, uint srcQty) public view returns(uint, uint) {
446         uint bestRate = 0;
447         uint bestReserve = 0;
448         uint numRelevantReserves = 0;
449         uint numReserves = reserves.length;
450         uint[] memory rates = new uint[](numReserves);
451         uint[] memory reserveCandidates = new uint[](numReserves);
452 
453         for (uint i = 0; i < numReserves; i++) {
454             //list all reserves that have this token.
455             if (!(perReserveListedPairs[reserves[i]])[keccak256(src, dest)]) continue;
456 
457             rates[i] = reserves[i].getConversionRate(src, dest, srcQty, block.number);
458 
459             if (rates[i] > bestRate) {
460                 //best rate is highest rate
461                 bestRate = rates[i];
462             }
463         }
464 
465         if (bestRate > 0) {
466             uint random = 0;
467             uint smallestRelevantRate = (bestRate * 10000) / (10000 + negligibleRateDiff);
468 
469             for (i = 0; i < numReserves; i++) {
470                 if (rates[i] >= smallestRelevantRate) {
471                     reserveCandidates[numRelevantReserves++] = i;
472                 }
473             }
474 
475             if (numRelevantReserves > 1) {
476                 //when encountering small rate diff from bestRate. draw from relevant reserves
477                 random = uint(block.blockhash(block.number-1)) % numRelevantReserves;
478             }
479 
480             bestReserve = reserveCandidates[random];
481             bestRate = rates[bestReserve];
482         }
483 
484         return (bestReserve, bestRate);
485     }
486     /* solhint-enable code-complexity */
487 
488     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
489         public view
490         returns (uint expectedRate, uint slippageRate)
491     {
492         require(expectedRateContract != address(0));
493         return expectedRateContract.getExpectedRate(src, dest, srcQty);
494     }
495 
496     function getUserCapInWei(address user) public view returns(uint) {
497         return whiteListContract.getUserCapInWei(user);
498     }
499 
500     function doTrade(
501         ERC20 src,
502         uint srcAmount,
503         ERC20 dest,
504         address destAddress,
505         uint maxDestAmount,
506         uint minConversionRate,
507         address walletId
508     )
509         internal
510         returns(uint)
511     {
512         require(tx.gasprice <= maxGasPrice);
513         require(validateTradeInput(src, srcAmount, destAddress));
514 
515         uint reserveInd;
516         uint rate;
517 
518         (reserveInd, rate) = findBestRate(src, dest, srcAmount);
519         KyberReserveInterface theReserve = reserves[reserveInd];
520         require(rate > 0);
521         require(rate < MAX_RATE);
522         require(rate >= minConversionRate);
523 
524         uint actualSrcAmount = srcAmount;
525         uint actualDestAmount = calcDestAmount(src, dest, actualSrcAmount, rate);
526         if (actualDestAmount > maxDestAmount) {
527             actualDestAmount = maxDestAmount;
528             actualSrcAmount = calcSrcAmount(src, dest, actualDestAmount, rate);
529             require(actualSrcAmount <= srcAmount);
530         }
531 
532         // do the trade
533         // verify trade size is smaller than user cap
534         uint ethAmount;
535         if (src == ETH_TOKEN_ADDRESS) {
536             ethAmount = actualSrcAmount;
537         } else {
538             ethAmount = actualDestAmount;
539         }
540 
541         require(ethAmount <= getUserCapInWei(msg.sender));
542         require(doReserveTrade(
543                 src,
544                 actualSrcAmount,
545                 dest,
546                 destAddress,
547                 actualDestAmount,
548                 theReserve,
549                 rate,
550                 true));
551 
552         if ((actualSrcAmount < srcAmount) && (src == ETH_TOKEN_ADDRESS)) {
553             msg.sender.transfer(srcAmount - actualSrcAmount);
554         }
555 
556         require(feeBurnerContract.handleFees(ethAmount, theReserve, walletId));
557 
558         ExecuteTrade(msg.sender, src, dest, actualSrcAmount, actualDestAmount);
559         return actualDestAmount;
560     }
561 
562     /// @notice use token address ETH_TOKEN_ADDRESS for ether
563     /// @dev do one trade with a reserve
564     /// @param src Src token
565     /// @param amount amount of src tokens
566     /// @param dest   Destination token
567     /// @param destAddress Address to send tokens to
568     /// @param reserve Reserve to use
569     /// @param validate If true, additional validations are applicable
570     /// @return true if trade is successful
571     function doReserveTrade(
572         ERC20 src,
573         uint amount,
574         ERC20 dest,
575         address destAddress,
576         uint expectedDestAmount,
577         KyberReserveInterface reserve,
578         uint conversionRate,
579         bool validate
580     )
581         internal
582         returns(bool)
583     {
584         uint callValue = 0;
585 
586         if (src == ETH_TOKEN_ADDRESS) {
587             callValue = amount;
588         } else {
589             // take src tokens to this contract
590             src.transferFrom(msg.sender, this, amount);
591         }
592 
593         // reserve sends tokens/eth to network. network sends it to destination
594         require(reserve.trade.value(callValue)(src, amount, dest, this, conversionRate, validate));
595 
596         if (dest == ETH_TOKEN_ADDRESS) {
597             destAddress.transfer(expectedDestAmount);
598         } else {
599             require(dest.transfer(destAddress, expectedDestAmount));
600         }
601 
602         return true;
603     }
604 
605     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
606         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
607     }
608 
609     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
610         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
611     }
612 
613     /// @notice use token address ETH_TOKEN_ADDRESS for ether
614     /// @dev checks that user sent ether/tokens to contract before trade
615     /// @param src Src token
616     /// @param srcAmount amount of src tokens
617     /// @return true if input is valid
618     function validateTradeInput(ERC20 src, uint srcAmount, address destAddress) internal view returns(bool) {
619         if ((srcAmount >= MAX_QTY) || (srcAmount == 0) || (destAddress == 0))
620             return false;
621 
622         if (src == ETH_TOKEN_ADDRESS) {
623             if (msg.value != srcAmount)
624                 return false;
625         } else {
626             if ((msg.value != 0) || (src.allowance(msg.sender, this) < srcAmount))
627                 return false;
628         }
629 
630         return true;
631     }
632 }
633 
634 interface ExpectedRateInterface {
635     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
636         returns (uint expectedRate, uint slippageRate);
637 }
638 
639 contract ExpectedRate is Withdrawable, ExpectedRateInterface {
640 
641     KyberNetwork public kyberNetwork;
642     uint public quantityFactor = 2;
643     uint public minSlippageFactorInBps = 50;
644 
645     function ExpectedRate(KyberNetwork _kyberNetwork, address _admin) public {
646         require(_admin != address(0));
647         require(_kyberNetwork != address(0));
648         kyberNetwork = _kyberNetwork;
649         admin = _admin;
650     }
651 
652     event QuantityFactorSet (uint newFactor, uint oldFactor, address sender);
653 
654     function setQuantityFactor(uint newFactor) public onlyOperator {
655         QuantityFactorSet(quantityFactor, newFactor, msg.sender);
656         quantityFactor = newFactor;
657     }
658 
659     event MinSlippageFactorSet (uint newMin, uint oldMin, address sender);
660 
661     function setMinSlippageFactor(uint bps) public onlyOperator {
662         MinSlippageFactorSet(bps, minSlippageFactorInBps, msg.sender);
663         minSlippageFactorInBps = bps;
664     }
665 
666     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
667         public view
668         returns (uint expectedRate, uint slippageRate)
669     {
670         require(quantityFactor != 0);
671 
672         uint bestReserve;
673         uint minSlippage;
674 
675         (bestReserve, expectedRate) = kyberNetwork.findBestRate(src, dest, srcQty);
676         (bestReserve, slippageRate) = kyberNetwork.findBestRate(src, dest, (srcQty * quantityFactor));
677 
678         minSlippage = ((10000 - minSlippageFactorInBps) * expectedRate) / 10000;
679         if (slippageRate >= minSlippage) {
680             slippageRate = minSlippage;
681         }
682 
683         return (expectedRate, slippageRate);
684     }
685 }