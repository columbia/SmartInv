1 pragma solidity 0.4.18;
2 
3 contract Utils {
4 
5     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
6     uint  constant internal PRECISION = (10**18);
7     uint  constant internal MAX_QTY   = (10**28); // 1B tokens
8     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
9     uint  constant internal MAX_DECIMALS = 18;
10 
11     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
12         if (dstDecimals >= srcDecimals) {
13             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
14             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
15         } else {
16             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
17             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
18         }
19     }
20 
21     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
22         //source quantity is rounded up. to avoid dest quantity being too low.
23         uint numerator;
24         uint denominator;
25         if (srcDecimals >= dstDecimals) {
26             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
27             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
28             denominator = rate;
29         } else {
30             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
31             numerator = (PRECISION * dstQty);
32             denominator = (rate * (10**(dstDecimals - srcDecimals)));
33         }
34         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
35     }
36 }
37 
38 interface ERC20 {
39     function totalSupply() public view returns (uint supply);
40     function balanceOf(address _owner) public view returns (uint balance);
41     function transfer(address _to, uint _value) public returns (bool success);
42     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
43     function approve(address _spender, uint _value) public returns (bool success);
44     function allowance(address _owner, address _spender) public view returns (uint remaining);
45     function decimals() public view returns(uint digits);
46     event Approval(address indexed _owner, address indexed _spender, uint _value);
47 }
48 
49 interface BurnableToken {
50     function transferFrom(address _from, address _to, uint _value) public returns (bool);
51     function burnFrom(address _from, uint256 _value) public returns (bool);
52 }
53 
54 interface ExpectedRateInterface {
55     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
56         returns (uint expectedRate, uint slippageRate);
57 }
58 
59 contract PermissionGroups {
60 
61     address public admin;
62     address public pendingAdmin;
63     mapping(address=>bool) internal operators;
64     mapping(address=>bool) internal alerters;
65     address[] internal operatorsGroup;
66     address[] internal alertersGroup;
67 
68     function PermissionGroups() public {
69         admin = msg.sender;
70     }
71 
72     modifier onlyAdmin() {
73         require(msg.sender == admin);
74         _;
75     }
76 
77     modifier onlyOperator() {
78         require(operators[msg.sender]);
79         _;
80     }
81 
82     modifier onlyAlerter() {
83         require(alerters[msg.sender]);
84         _;
85     }
86 
87     function getOperators () external view returns(address[]) {
88         return operatorsGroup;
89     }
90 
91     function getAlerters () external view returns(address[]) {
92         return alertersGroup;
93     }
94 
95     event TransferAdminPending(address pendingAdmin);
96 
97     /**
98      * @dev Allows the current admin to set the pendingAdmin address.
99      * @param newAdmin The address to transfer ownership to.
100      */
101     function transferAdmin(address newAdmin) public onlyAdmin {
102         require(newAdmin != address(0));
103         TransferAdminPending(pendingAdmin);
104         pendingAdmin = newAdmin;
105     }
106 
107     event AdminClaimed( address newAdmin, address previousAdmin);
108 
109     /**
110      * @dev Allows the pendingAdmin address to finalize the change admin process.
111      */
112     function claimAdmin() public {
113         require(pendingAdmin == msg.sender);
114         AdminClaimed(pendingAdmin, admin);
115         admin = pendingAdmin;
116         pendingAdmin = address(0);
117     }
118 
119     event AlerterAdded (address newAlerter, bool isAdd);
120 
121     function addAlerter(address newAlerter) public onlyAdmin {
122         require(!alerters[newAlerter]); // prevent duplicates.
123         AlerterAdded(newAlerter, true);
124         alerters[newAlerter] = true;
125         alertersGroup.push(newAlerter);
126     }
127 
128     function removeAlerter (address alerter) public onlyAdmin {
129         require(alerters[alerter]);
130         alerters[alerter] = false;
131 
132         for (uint i = 0; i < alertersGroup.length; ++i) {
133             if (alertersGroup[i] == alerter) {
134                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
135                 alertersGroup.length--;
136                 AlerterAdded(alerter, false);
137                 break;
138             }
139         }
140     }
141 
142     event OperatorAdded(address newOperator, bool isAdd);
143 
144     function addOperator(address newOperator) public onlyAdmin {
145         require(!operators[newOperator]); // prevent duplicates.
146         OperatorAdded(newOperator, true);
147         operators[newOperator] = true;
148         operatorsGroup.push(newOperator);
149     }
150 
151     function removeOperator (address operator) public onlyAdmin {
152         require(operators[operator]);
153         operators[operator] = false;
154 
155         for (uint i = 0; i < operatorsGroup.length; ++i) {
156             if (operatorsGroup[i] == operator) {
157                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
158                 operatorsGroup.length -= 1;
159                 OperatorAdded(operator, false);
160                 break;
161             }
162         }
163     }
164 }
165 
166 interface SanityRatesInterface {
167     function getSanityRate(ERC20 src, ERC20 dest) public view returns(uint);
168 }
169 
170 contract Withdrawable is PermissionGroups {
171 
172     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
173 
174     /**
175      * @dev Withdraw all ERC20 compatible tokens
176      * @param token ERC20 The address of the token contract
177      */
178     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
179         require(token.transfer(sendTo, amount));
180         TokenWithdraw(token, amount, sendTo);
181     }
182 
183     event EtherWithdraw(uint amount, address sendTo);
184 
185     /**
186      * @dev Withdraw Ethers
187      */
188     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
189         sendTo.transfer(amount);
190         EtherWithdraw(amount, sendTo);
191     }
192 }
193 
194 contract KyberNetwork is Withdrawable, Utils {
195 
196     uint public negligibleRateDiff = 10; // basic rate steps will be in 0.01%
197     KyberReserve[] public reserves;
198     mapping(address=>bool) public isReserve;
199     WhiteList public whiteListContract;
200     ExpectedRateInterface public expectedRateContract;
201     FeeBurnerInterface    public feeBurnerContract;
202     uint                  public maxGasPrice = 50 * 1000 * 1000 * 1000; // 50 gwei
203     bool                  public enabled = false; // network is enabled
204     mapping(address=>mapping(bytes32=>bool)) public perReserveListedPairs;
205 
206     function KyberNetwork(address _admin) public {
207         require(_admin != address(0));
208         admin = _admin;
209     }
210 
211     event EtherReceival(address indexed sender, uint amount);
212 
213     /* solhint-disable no-complex-fallback */
214     function() public payable {
215         require(isReserve[msg.sender]);
216         EtherReceival(msg.sender, msg.value);
217     }
218     /* solhint-enable no-complex-fallback */
219 
220     event ExecuteTrade(address indexed sender, ERC20 src, ERC20 dest, uint actualSrcAmount, uint actualDestAmount);
221 
222     /// @notice use token address ETH_TOKEN_ADDRESS for ether
223     /// @dev makes a trade between src and dest token and send dest token to destAddress
224     /// @param src Src token
225     /// @param srcAmount amount of src tokens
226     /// @param dest   Destination token
227     /// @param destAddress Address to send tokens to
228     /// @param maxDestAmount A limit on the amount of dest tokens
229     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
230     /// @param walletId is the wallet ID to send part of the fees
231     /// @return amount of actual dest tokens
232     function trade(
233         ERC20 src,
234         uint srcAmount,
235         ERC20 dest,
236         address destAddress,
237         uint maxDestAmount,
238         uint minConversionRate,
239         address walletId
240     )
241         public
242         payable
243         returns(uint)
244     {
245         require(enabled);
246 
247         uint userSrcBalanceBefore;
248         uint userSrcBalanceAfter;
249         uint userDestBalanceBefore;
250         uint userDestBalanceAfter;
251 
252         userSrcBalanceBefore = getBalance(src, msg.sender);
253         if (src == ETH_TOKEN_ADDRESS)
254             userSrcBalanceBefore += msg.value;
255         userDestBalanceBefore = getBalance(dest, destAddress);
256 
257         uint actualDestAmount = doTrade(src,
258                                         srcAmount,
259                                         dest,
260                                         destAddress,
261                                         maxDestAmount,
262                                         minConversionRate,
263                                         walletId
264                                         );
265         require(actualDestAmount > 0);
266 
267         userSrcBalanceAfter = getBalance(src, msg.sender);
268         userDestBalanceAfter = getBalance(dest, destAddress);
269 
270         require(userSrcBalanceAfter <= userSrcBalanceBefore);
271         require(userDestBalanceAfter >= userDestBalanceBefore);
272 
273         require((userDestBalanceAfter - userDestBalanceBefore) >=
274             calcDstQty((userSrcBalanceBefore - userSrcBalanceAfter), getDecimals(src), getDecimals(dest),
275                 minConversionRate));
276 
277         return actualDestAmount;
278     }
279 
280     event AddReserveToNetwork(KyberReserve reserve, bool add);
281 
282     /// @notice can be called only by admin
283     /// @dev add or deletes a reserve to/from the network.
284     /// @param reserve The reserve address.
285     /// @param add If true, the add reserve. Otherwise delete reserve.
286     function addReserve(KyberReserve reserve, bool add) public onlyAdmin {
287 
288         if (add) {
289             require(!isReserve[reserve]);
290             reserves.push(reserve);
291             isReserve[reserve] = true;
292             AddReserveToNetwork(reserve, true);
293         } else {
294             isReserve[reserve] = false;
295             // will have trouble if more than 50k reserves...
296             for (uint i = 0; i < reserves.length; i++) {
297                 if (reserves[i] == reserve) {
298                     reserves[i] = reserves[reserves.length - 1];
299                     reserves.length--;
300                     AddReserveToNetwork(reserve, false);
301                     break;
302                 }
303             }
304         }
305     }
306 
307     event ListReservePairs(address reserve, ERC20 src, ERC20 dest, bool add);
308 
309     /// @notice can be called only by admin
310     /// @dev allow or prevent a specific reserve to trade a pair of tokens
311     /// @param reserve The reserve address.
312     /// @param src Src token
313     /// @param dest Destination token
314     /// @param add If true then enable trade, otherwise delist pair.
315     function listPairForReserve(address reserve, ERC20 src, ERC20 dest, bool add) public onlyAdmin {
316         (perReserveListedPairs[reserve])[keccak256(src, dest)] = add;
317 
318         if (src != ETH_TOKEN_ADDRESS) {
319             if (add) {
320                 src.approve(reserve, 2**255); // approve infinity
321             } else {
322                 src.approve(reserve, 0);
323             }
324         }
325 
326         ListReservePairs(reserve, src, dest, add);
327     }
328 
329     function setParams(
330         WhiteList _whiteList,
331         ExpectedRateInterface _expectedRate,
332         FeeBurnerInterface    _feeBurner,
333         uint                  _maxGasPrice,
334         uint                  _negligibleRateDiff
335     )
336         public
337         onlyAdmin
338     {
339         require(_whiteList != address(0));
340         require(_feeBurner != address(0));
341         require(_expectedRate != address(0));
342         whiteListContract = _whiteList;
343         expectedRateContract = _expectedRate;
344         feeBurnerContract = _feeBurner;
345         maxGasPrice = _maxGasPrice;
346         negligibleRateDiff = _negligibleRateDiff;
347     }
348 
349     function setEnable(bool _enable) public onlyAdmin {
350         if (_enable) {
351             require(whiteListContract != address(0));
352             require(feeBurnerContract != address(0));
353             require(expectedRateContract != address(0));
354         }
355         enabled = _enable;
356     }
357 
358     /// @dev returns number of reserves
359     /// @return number of reserves
360     function getNumReserves() public view returns(uint) {
361         return reserves.length;
362     }
363 
364     /// @notice should be called off chain with as much gas as needed
365     /// @dev get an array of all reserves
366     /// @return An array of all reserves
367     function getReserves() public view returns(KyberReserve[]) {
368         return reserves;
369     }
370 
371     /// @dev get the balance of a user.
372     /// @param token The token type
373     /// @return The balance
374     function getBalance(ERC20 token, address user) public view returns(uint) {
375         if (token == ETH_TOKEN_ADDRESS)
376             return user.balance;
377         else
378             return token.balanceOf(user);
379     }
380 
381     /// @notice use token address ETH_TOKEN_ADDRESS for ether
382     /// @dev best conversion rate for a pair of tokens, if number of reserves have small differences. randomize
383     /// @param src Src token
384     /// @param dest Destination token
385     /* solhint-disable code-complexity */
386     function findBestRate(ERC20 src, ERC20 dest, uint srcQty) public view returns(uint, uint) {
387         uint bestRate = 0;
388         uint bestReserve = 0;
389         uint numRelevantReserves = 0;
390         uint numReserves = reserves.length;
391         uint[] memory rates = new uint[](numReserves);
392         uint[] memory reserveCandidates = new uint[](numReserves);
393 
394         for (uint i = 0; i < numReserves; i++) {
395             //list all reserves that have this token.
396             if (!(perReserveListedPairs[reserves[i]])[keccak256(src, dest)]) continue;
397 
398             rates[i] = reserves[i].getConversionRate(src, dest, srcQty, block.number);
399 
400             if (rates[i] > bestRate) {
401                 //best rate is highest rate
402                 bestRate = rates[i];
403             }
404         }
405 
406         if (bestRate > 0) {
407             uint random = 0;
408             uint smallestRelevantRate = (bestRate * 10000) / (10000 + negligibleRateDiff);
409 
410             for (i = 0; i < numReserves; i++) {
411                 if (rates[i] >= smallestRelevantRate) {
412                     reserveCandidates[numRelevantReserves++] = i;
413                 }
414             }
415 
416             if (numRelevantReserves > 1) {
417                 //when encountering small rate diff from bestRate. draw from relevant reserves
418                 random = uint(block.blockhash(block.number-1)) % numRelevantReserves;
419             }
420 
421             bestReserve = reserveCandidates[random];
422             bestRate = rates[bestReserve];
423         }
424 
425         return (bestReserve, bestRate);
426     }
427     /* solhint-enable code-complexity */
428 
429     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
430         public view
431         returns (uint expectedRate, uint slippageRate)
432     {
433         require(expectedRateContract != address(0));
434         return expectedRateContract.getExpectedRate(src, dest, srcQty);
435     }
436 
437     function getUserCapInWei(address user) public view returns(uint) {
438         return whiteListContract.getUserCapInWei(user);
439     }
440 
441     function doTrade(
442         ERC20 src,
443         uint srcAmount,
444         ERC20 dest,
445         address destAddress,
446         uint maxDestAmount,
447         uint minConversionRate,
448         address walletId
449     )
450         internal
451         returns(uint)
452     {
453         require(tx.gasprice <= maxGasPrice);
454         require(validateTradeInput(src, srcAmount, destAddress));
455 
456         uint reserveInd;
457         uint rate;
458 
459         (reserveInd, rate) = findBestRate(src, dest, srcAmount);
460         KyberReserve theReserve = reserves[reserveInd];
461         require(rate > 0);
462         require(rate < MAX_RATE);
463         require(rate >= minConversionRate);
464 
465         uint actualSrcAmount = srcAmount;
466         uint actualDestAmount = calcDestAmount(src, dest, actualSrcAmount, rate);
467         if (actualDestAmount > maxDestAmount) {
468             actualDestAmount = maxDestAmount;
469             actualSrcAmount = calcSrcAmount(src, dest, actualDestAmount, rate);
470             require(actualSrcAmount <= srcAmount);
471         }
472 
473         // do the trade
474         // verify trade size is smaller than user cap
475         uint ethAmount;
476         if (src == ETH_TOKEN_ADDRESS) {
477             ethAmount = actualSrcAmount;
478         } else {
479             ethAmount = actualDestAmount;
480         }
481 
482         require(ethAmount <= getUserCapInWei(msg.sender));
483         require(doReserveTrade(
484                 src,
485                 actualSrcAmount,
486                 dest,
487                 destAddress,
488                 actualDestAmount,
489                 theReserve,
490                 rate,
491                 true));
492 
493         if ((actualSrcAmount < srcAmount) && (src == ETH_TOKEN_ADDRESS)) {
494             msg.sender.transfer(srcAmount - actualSrcAmount);
495         }
496 
497         require(feeBurnerContract.handleFees(ethAmount, theReserve, walletId));
498 
499         ExecuteTrade(msg.sender, src, dest, actualSrcAmount, actualDestAmount);
500         return actualDestAmount;
501     }
502 
503     /// @notice use token address ETH_TOKEN_ADDRESS for ether
504     /// @dev do one trade with a reserve
505     /// @param src Src token
506     /// @param amount amount of src tokens
507     /// @param dest   Destination token
508     /// @param destAddress Address to send tokens to
509     /// @param reserve Reserve to use
510     /// @param validate If true, additional validations are applicable
511     /// @return true if trade is successful
512     function doReserveTrade(
513         ERC20 src,
514         uint amount,
515         ERC20 dest,
516         address destAddress,
517         uint expectedDestAmount,
518         KyberReserve reserve,
519         uint conversionRate,
520         bool validate
521     )
522         internal
523         returns(bool)
524     {
525         uint callValue = 0;
526 
527         if (src == ETH_TOKEN_ADDRESS) {
528             callValue = amount;
529         } else {
530             // take src tokens to this contract
531             src.transferFrom(msg.sender, this, amount);
532         }
533 
534         // reserve sends tokens/eth to network. network sends it to destination
535         require(reserve.trade.value(callValue)(src, amount, dest, this, conversionRate, validate));
536 
537         if (dest == ETH_TOKEN_ADDRESS) {
538             destAddress.transfer(expectedDestAmount);
539         } else {
540             require(dest.transfer(destAddress, expectedDestAmount));
541         }
542 
543         return true;
544     }
545 
546     function getDecimals(ERC20 token) internal view returns(uint) {
547         if (token == ETH_TOKEN_ADDRESS) return 18;
548         return token.decimals();
549     }
550 
551     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
552         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
553     }
554 
555     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
556         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
557     }
558 
559     /// @notice use token address ETH_TOKEN_ADDRESS for ether
560     /// @dev checks that user sent ether/tokens to contract before trade
561     /// @param src Src token
562     /// @param srcAmount amount of src tokens
563     /// @return true if input is valid
564     function validateTradeInput(ERC20 src, uint srcAmount, address destAddress) internal view returns(bool) {
565         if ((srcAmount >= MAX_QTY) || (srcAmount == 0) || (destAddress == 0))
566             return false;
567 
568         if (src == ETH_TOKEN_ADDRESS) {
569             if (msg.value != srcAmount)
570                 return false;
571         } else {
572             if ((msg.value != 0) || (src.allowance(msg.sender, this) < srcAmount))
573                 return false;
574         }
575 
576         return true;
577     }
578 }
579 
580 contract KyberReserve is Withdrawable, Utils {
581 
582     address public kyberNetwork;
583     bool public tradeEnabled;
584     ConversionRates public conversionRatesContract;
585     SanityRatesInterface public sanityRatesContract;
586     mapping(bytes32=>bool) public approvedWithdrawAddresses; // sha3(token,address)=>bool
587 
588     function KyberReserve(address _kyberNetwork, ConversionRates _ratesContract, address _admin) public {
589         require(_admin != address(0));
590         require(_ratesContract != address(0));
591         require(_kyberNetwork != address(0));
592         kyberNetwork = _kyberNetwork;
593         conversionRatesContract = _ratesContract;
594         admin = _admin;
595         tradeEnabled = true;
596     }
597 
598     event DepositToken(ERC20 token, uint amount);
599 
600     function() public payable {
601         DepositToken(ETH_TOKEN_ADDRESS, msg.value);
602     }
603 
604     event TradeExecute(
605         address indexed origin,
606         address src,
607         uint srcAmount,
608         address destToken,
609         uint destAmount,
610         address destAddress
611     );
612 
613     function trade(
614         ERC20 srcToken,
615         uint srcAmount,
616         ERC20 destToken,
617         address destAddress,
618         uint conversionRate,
619         bool validate
620     )
621         public
622         payable
623         returns(bool)
624     {
625         require(tradeEnabled);
626         require(msg.sender == kyberNetwork);
627 
628         require(doTrade(srcToken, srcAmount, destToken, destAddress, conversionRate, validate));
629 
630         return true;
631     }
632 
633     event TradeEnabled(bool enable);
634 
635     function enableTrade() public onlyAdmin returns(bool) {
636         tradeEnabled = true;
637         TradeEnabled(true);
638 
639         return true;
640     }
641 
642     function disableTrade() public onlyAlerter returns(bool) {
643         tradeEnabled = false;
644         TradeEnabled(false);
645 
646         return true;
647     }
648 
649     event WithdrawAddressApproved(ERC20 token, address addr, bool approve);
650 
651     function approveWithdrawAddress(ERC20 token, address addr, bool approve) public onlyAdmin {
652         approvedWithdrawAddresses[keccak256(token, addr)] = approve;
653         WithdrawAddressApproved(token, addr, approve);
654     }
655 
656     event WithdrawFunds(ERC20 token, uint amount, address destination);
657 
658     function withdraw(ERC20 token, uint amount, address destination) public onlyOperator returns(bool) {
659         require(approvedWithdrawAddresses[keccak256(token, destination)]);
660 
661         if (token == ETH_TOKEN_ADDRESS) {
662             destination.transfer(amount);
663         } else {
664             require(token.transfer(destination, amount));
665         }
666 
667         WithdrawFunds(token, amount, destination);
668 
669         return true;
670     }
671 
672     event SetContractAddresses(address network, address rate, address sanity);
673 
674     function setContracts(address _kyberNetwork, ConversionRates _conversionRates, SanityRatesInterface _sanityRates)
675         public
676         onlyAdmin
677     {
678         require(_kyberNetwork != address(0));
679         require(_conversionRates != address(0));
680 
681         kyberNetwork = _kyberNetwork;
682         conversionRatesContract = _conversionRates;
683         sanityRatesContract = _sanityRates;
684 
685         SetContractAddresses(kyberNetwork, conversionRatesContract, sanityRatesContract);
686     }
687 
688     ////////////////////////////////////////////////////////////////////////////
689     /// status functions ///////////////////////////////////////////////////////
690     ////////////////////////////////////////////////////////////////////////////
691     function getBalance(ERC20 token) public view returns(uint) {
692         if (token == ETH_TOKEN_ADDRESS)
693             return this.balance;
694         else
695             return token.balanceOf(this);
696     }
697 
698     function getDecimals(ERC20 token) public view returns(uint) {
699         if (token == ETH_TOKEN_ADDRESS) return 18;
700         return token.decimals();
701     }
702 
703     function getDestQty(ERC20 src, ERC20 dest, uint srcQty, uint rate) public view returns(uint) {
704         uint dstDecimals = getDecimals(dest);
705         uint srcDecimals = getDecimals(src);
706 
707         return calcDstQty(srcQty, srcDecimals, dstDecimals, rate);
708     }
709 
710     function getSrcQty(ERC20 src, ERC20 dest, uint dstQty, uint rate) public view returns(uint) {
711         uint dstDecimals = getDecimals(dest);
712         uint srcDecimals = getDecimals(src);
713 
714         return calcSrcQty(dstQty, srcDecimals, dstDecimals, rate);
715     }
716 
717     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint) {
718         ERC20 token;
719         bool  buy;
720 
721         if (!tradeEnabled) return 0;
722 
723         if (ETH_TOKEN_ADDRESS == src) {
724             buy = true;
725             token = dest;
726         } else if (ETH_TOKEN_ADDRESS == dest) {
727             buy = false;
728             token = src;
729         } else {
730             return 0; // pair is not listed
731         }
732 
733         uint rate = conversionRatesContract.getRate(token, blockNumber, buy, srcQty);
734         uint destQty = getDestQty(src, dest, srcQty, rate);
735 
736         if (getBalance(dest) < destQty) return 0;
737 
738         if (sanityRatesContract != address(0)) {
739             uint sanityRate = sanityRatesContract.getSanityRate(src, dest);
740             if (rate > sanityRate) return 0;
741         }
742 
743         return rate;
744     }
745 
746     /// @dev do a trade
747     /// @param srcToken Src token
748     /// @param srcAmount Amount of src token
749     /// @param destToken Destination token
750     /// @param destAddress Destination address to send tokens to
751     /// @param validate If true, additional validations are applicable
752     /// @return true iff trade is successful
753     function doTrade(
754         ERC20 srcToken,
755         uint srcAmount,
756         ERC20 destToken,
757         address destAddress,
758         uint conversionRate,
759         bool validate
760     )
761         internal
762         returns(bool)
763     {
764         // can skip validation if done at kyber network level
765         if (validate) {
766             require(conversionRate > 0);
767             if (srcToken == ETH_TOKEN_ADDRESS)
768                 require(msg.value == srcAmount);
769             else
770                 require(msg.value == 0);
771         }
772 
773         uint destAmount = getDestQty(srcToken, destToken, srcAmount, conversionRate);
774         // sanity check
775         require(destAmount > 0);
776 
777         // add to imbalance
778         ERC20 token;
779         int buy;
780         if (srcToken == ETH_TOKEN_ADDRESS) {
781             buy = int(destAmount);
782             token = destToken;
783         } else {
784             buy = -1 * int(srcAmount);
785             token = srcToken;
786         }
787 
788         conversionRatesContract.recordImbalance(
789             token,
790             buy,
791             0,
792             block.number
793         );
794 
795         // collect src tokens
796         if (srcToken != ETH_TOKEN_ADDRESS) {
797             require(srcToken.transferFrom(msg.sender, this, srcAmount));
798         }
799 
800         // send dest tokens
801         if (destToken == ETH_TOKEN_ADDRESS) {
802             destAddress.transfer(destAmount);
803         } else {
804             require(destToken.transfer(destAddress, destAmount));
805         }
806 
807         TradeExecute(msg.sender, srcToken, srcAmount, destToken, destAmount, destAddress);
808 
809         return true;
810     }
811 }
812 
813 contract VolumeImbalanceRecorder is Withdrawable {
814 
815     uint constant internal SLIDING_WINDOW_SIZE = 5;
816     uint constant internal POW_2_64 = 2 ** 64;
817 
818     struct TokenControlInfo {
819         uint minimalRecordResolution; // can be roughly 1 cent
820         uint maxPerBlockImbalance; // in twei resolution
821         uint maxTotalImbalance; // max total imbalance (between rate updates)
822                             // before halting trade
823     }
824 
825     mapping(address => TokenControlInfo) internal tokenControlInfo;
826 
827     struct TokenImbalanceData {
828         int  lastBlockBuyUnitsImbalance;
829         uint lastBlock;
830 
831         int  totalBuyUnitsImbalance;
832         uint lastRateUpdateBlock;
833     }
834 
835     mapping(address => mapping(uint=>uint)) public tokenImbalanceData;
836 
837     function VolumeImbalanceRecorder(address _admin) public {
838         require(_admin != address(0));
839         admin = _admin;
840     }
841 
842     function setTokenControlInfo(
843         ERC20 token,
844         uint minimalRecordResolution,
845         uint maxPerBlockImbalance,
846         uint maxTotalImbalance
847     )
848         public
849         onlyAdmin
850     {
851         tokenControlInfo[token] =
852             TokenControlInfo(
853                 minimalRecordResolution,
854                 maxPerBlockImbalance,
855                 maxTotalImbalance
856             );
857     }
858 
859     function getTokenControlInfo(ERC20 token) public view returns(uint, uint, uint) {
860         return (tokenControlInfo[token].minimalRecordResolution,
861                 tokenControlInfo[token].maxPerBlockImbalance,
862                 tokenControlInfo[token].maxTotalImbalance);
863     }
864 
865     function addImbalance(
866         ERC20 token,
867         int buyAmount,
868         uint rateUpdateBlock,
869         uint currentBlock
870     )
871         internal
872     {
873         uint currentBlockIndex = currentBlock % SLIDING_WINDOW_SIZE;
874         int recordedBuyAmount = int(buyAmount / int(tokenControlInfo[token].minimalRecordResolution));
875 
876         int prevImbalance = 0;
877 
878         TokenImbalanceData memory currentBlockData =
879             decodeTokenImbalanceData(tokenImbalanceData[token][currentBlockIndex]);
880 
881         // first scenario - this is not the first tx in the current block
882         if (currentBlockData.lastBlock == currentBlock) {
883             if (uint(currentBlockData.lastRateUpdateBlock) == rateUpdateBlock) {
884                 // just increase imbalance
885                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
886                 currentBlockData.totalBuyUnitsImbalance += recordedBuyAmount;
887             } else {
888                 // imbalance was changed in the middle of the block
889                 prevImbalance = getImbalanceInRange(token, rateUpdateBlock, currentBlock);
890                 currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
891                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
892                 currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
893             }
894         } else {
895             // first tx in the current block
896             int currentBlockImbalance;
897             (prevImbalance, currentBlockImbalance) = getImbalanceSinceRateUpdate(token, rateUpdateBlock, currentBlock);
898 
899             currentBlockData.lastBlockBuyUnitsImbalance = recordedBuyAmount;
900             currentBlockData.lastBlock = uint(currentBlock);
901             currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
902             currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
903         }
904 
905         tokenImbalanceData[token][currentBlockIndex] = encodeTokenImbalanceData(currentBlockData);
906     }
907 
908     function setGarbageToVolumeRecorder(ERC20 token) internal {
909         for (uint i = 0; i < SLIDING_WINDOW_SIZE; i++) {
910             tokenImbalanceData[token][i] = 0x1;
911         }
912     }
913 
914     function getImbalanceInRange(ERC20 token, uint startBlock, uint endBlock) internal view returns(int buyImbalance) {
915         // check the imbalance in the sliding window
916         require(startBlock <= endBlock);
917 
918         buyImbalance = 0;
919 
920         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
921             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
922 
923             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
924                 buyImbalance += int(perBlockData.lastBlockBuyUnitsImbalance);
925             }
926         }
927     }
928 
929     function getImbalanceSinceRateUpdate(ERC20 token, uint rateUpdateBlock, uint currentBlock)
930         internal view
931         returns(int buyImbalance, int currentBlockImbalance)
932     {
933         buyImbalance = 0;
934         currentBlockImbalance = 0;
935         uint latestBlock = 0;
936         int imbalanceInRange = 0;
937         uint startBlock = rateUpdateBlock;
938         uint endBlock = currentBlock;
939 
940         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
941             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
942 
943             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
944                 imbalanceInRange += perBlockData.lastBlockBuyUnitsImbalance;
945             }
946 
947             if (perBlockData.lastRateUpdateBlock != rateUpdateBlock) continue;
948             if (perBlockData.lastBlock < latestBlock) continue;
949 
950             latestBlock = perBlockData.lastBlock;
951             buyImbalance = perBlockData.totalBuyUnitsImbalance;
952             if (uint(perBlockData.lastBlock) == currentBlock) {
953                 currentBlockImbalance = perBlockData.lastBlockBuyUnitsImbalance;
954             }
955         }
956 
957         if (buyImbalance == 0) {
958             buyImbalance = imbalanceInRange;
959         }
960     }
961 
962     function getImbalance(ERC20 token, uint rateUpdateBlock, uint currentBlock)
963         internal view
964         returns(int totalImbalance, int currentBlockImbalance)
965     {
966 
967         int resolution = int(tokenControlInfo[token].minimalRecordResolution);
968 
969         (totalImbalance, currentBlockImbalance) =
970             getImbalanceSinceRateUpdate(
971                 token,
972                 rateUpdateBlock,
973                 currentBlock);
974 
975         totalImbalance *= resolution;
976         currentBlockImbalance *= resolution;
977     }
978 
979     function getMaxPerBlockImbalance(ERC20 token) internal view returns(uint) {
980         return tokenControlInfo[token].maxPerBlockImbalance;
981     }
982 
983     function getMaxTotalImbalance(ERC20 token) internal view returns(uint) {
984         return tokenControlInfo[token].maxTotalImbalance;
985     }
986 
987     function encodeTokenImbalanceData(TokenImbalanceData data) internal pure returns(uint) {
988         // check for overflows
989         require(data.lastBlockBuyUnitsImbalance < int(POW_2_64 / 2));
990         require(data.lastBlockBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
991         require(data.lastBlock < POW_2_64);
992         require(data.totalBuyUnitsImbalance < int(POW_2_64 / 2));
993         require(data.totalBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
994         require(data.lastRateUpdateBlock < POW_2_64);
995 
996         // do encoding
997         uint result = uint(data.lastBlockBuyUnitsImbalance) & (POW_2_64 - 1);
998         result |= data.lastBlock * POW_2_64;
999         result |= (uint(data.totalBuyUnitsImbalance) & (POW_2_64 - 1)) * POW_2_64 * POW_2_64;
1000         result |= data.lastRateUpdateBlock * POW_2_64 * POW_2_64 * POW_2_64;
1001 
1002         return result;
1003     }
1004 
1005     function decodeTokenImbalanceData(uint input) internal pure returns(TokenImbalanceData) {
1006         TokenImbalanceData memory data;
1007 
1008         data.lastBlockBuyUnitsImbalance = int(int64(input & (POW_2_64 - 1)));
1009         data.lastBlock = uint(uint64((input / POW_2_64) & (POW_2_64 - 1)));
1010         data.totalBuyUnitsImbalance = int(int64((input / (POW_2_64 * POW_2_64)) & (POW_2_64 - 1)));
1011         data.lastRateUpdateBlock = uint(uint64((input / (POW_2_64 * POW_2_64 * POW_2_64))));
1012 
1013         return data;
1014     }
1015 }
1016 
1017 contract ConversionRates is VolumeImbalanceRecorder, Utils {
1018 
1019     // bps - basic rate steps. one step is 1 / 10000 of the rate.
1020     struct StepFunction {
1021         int[] x; // quantity for each step. Quantity of each step includes previous steps.
1022         int[] y; // rate change per quantity step  in bps.
1023     }
1024 
1025     struct TokenData {
1026         bool listed;  // was added to reserve
1027         bool enabled; // whether trade is enabled
1028 
1029         // position in the compact data
1030         uint compactDataArrayIndex;
1031         uint compactDataFieldIndex;
1032 
1033         // rate data. base and changes according to quantity and reserve balance.
1034         // generally speaking. Sell rate is 1 / buy rate i.e. the buy in the other direction.
1035         uint baseBuyRate;  // in PRECISION units. see KyberConstants
1036         uint baseSellRate; // PRECISION units. without (sell / buy) spread it is 1 / baseBuyRate
1037         StepFunction buyRateQtyStepFunction; // in bps. higher quantity - bigger the rate.
1038         StepFunction sellRateQtyStepFunction;// in bps. higher the qua
1039         StepFunction buyRateImbalanceStepFunction; // in BPS. higher reserve imbalance - bigger the rate.
1040         StepFunction sellRateImbalanceStepFunction;
1041     }
1042 
1043     /*
1044     this is the data for tokenRatesCompactData
1045     but solidity compiler optimizer is sub-optimal, and cannot write this structure in a single storage write
1046     so we represent it as bytes32 and do the byte tricks ourselves.
1047     struct TokenRatesCompactData {
1048         bytes14 buy;  // change buy rate of token from baseBuyRate in 10 bps
1049         bytes14 sell; // change sell rate of token from baseSellRate in 10 bps
1050 
1051         uint32 blockNumber;
1052     } */
1053     uint public validRateDurationInBlocks = 10; // rates are valid for this amount of blocks
1054     ERC20[] internal listedTokens;
1055     mapping(address=>TokenData) internal tokenData;
1056     bytes32[] internal tokenRatesCompactData;
1057     uint public numTokensInCurrentCompactData = 0;
1058     address public reserveContract;
1059     uint constant internal NUM_TOKENS_IN_COMPACT_DATA = 14;
1060     uint constant internal BYTES_14_OFFSET = (2 ** (8 * NUM_TOKENS_IN_COMPACT_DATA));
1061 
1062     function ConversionRates(address _admin) public VolumeImbalanceRecorder(_admin)
1063         { } // solhint-disable-line no-empty-blocks
1064 
1065     function addToken(ERC20 token) public onlyAdmin {
1066 
1067         require(!tokenData[token].listed);
1068         tokenData[token].listed = true;
1069         listedTokens.push(token);
1070 
1071         if (numTokensInCurrentCompactData == 0) {
1072             tokenRatesCompactData.length++; // add new structure
1073         }
1074 
1075         tokenData[token].compactDataArrayIndex = tokenRatesCompactData.length - 1;
1076         tokenData[token].compactDataFieldIndex = numTokensInCurrentCompactData;
1077 
1078         numTokensInCurrentCompactData = (numTokensInCurrentCompactData + 1) % NUM_TOKENS_IN_COMPACT_DATA;
1079 
1080         setGarbageToVolumeRecorder(token);
1081     }
1082 
1083     function setCompactData(bytes14[] buy, bytes14[] sell, uint blockNumber, uint[] indices) public onlyOperator {
1084 
1085         require(buy.length == sell.length);
1086         require(indices.length == buy.length);
1087         require(blockNumber <= 0xFFFFFFFF);
1088 
1089         uint bytes14Offset = BYTES_14_OFFSET;
1090 
1091         for (uint i = 0; i < indices.length; i++) {
1092             require(indices[i] < tokenRatesCompactData.length);
1093             uint data = uint(buy[i]) | uint(sell[i]) * bytes14Offset | (blockNumber * (bytes14Offset * bytes14Offset));
1094             tokenRatesCompactData[indices[i]] = bytes32(data);
1095         }
1096     }
1097 
1098     function setBaseRate(
1099         ERC20[] tokens,
1100         uint[] baseBuy,
1101         uint[] baseSell,
1102         bytes14[] buy,
1103         bytes14[] sell,
1104         uint blockNumber,
1105         uint[] indices
1106     )
1107         public
1108         onlyOperator
1109     {
1110         require(tokens.length == baseBuy.length);
1111         require(tokens.length == baseSell.length);
1112         require(sell.length == buy.length);
1113         require(sell.length == indices.length);
1114 
1115         for (uint ind = 0; ind < tokens.length; ind++) {
1116             require(tokenData[tokens[ind]].listed);
1117             tokenData[tokens[ind]].baseBuyRate = baseBuy[ind];
1118             tokenData[tokens[ind]].baseSellRate = baseSell[ind];
1119         }
1120 
1121         setCompactData(buy, sell, blockNumber, indices);
1122     }
1123 
1124     function setQtyStepFunction(
1125         ERC20 token,
1126         int[] xBuy,
1127         int[] yBuy,
1128         int[] xSell,
1129         int[] ySell
1130     )
1131         public
1132         onlyOperator
1133     {
1134         require(xBuy.length == yBuy.length);
1135         require(xSell.length == ySell.length);
1136         require(tokenData[token].listed);
1137 
1138         tokenData[token].buyRateQtyStepFunction = StepFunction(xBuy, yBuy);
1139         tokenData[token].sellRateQtyStepFunction = StepFunction(xSell, ySell);
1140     }
1141 
1142     function setImbalanceStepFunction(
1143         ERC20 token,
1144         int[] xBuy,
1145         int[] yBuy,
1146         int[] xSell,
1147         int[] ySell
1148     )
1149         public
1150         onlyOperator
1151     {
1152         require(xBuy.length == yBuy.length);
1153         require(xSell.length == ySell.length);
1154         require(tokenData[token].listed);
1155 
1156         tokenData[token].buyRateImbalanceStepFunction = StepFunction(xBuy, yBuy);
1157         tokenData[token].sellRateImbalanceStepFunction = StepFunction(xSell, ySell);
1158     }
1159 
1160     function setValidRateDurationInBlocks(uint duration) public onlyAdmin {
1161         validRateDurationInBlocks = duration;
1162     }
1163 
1164     function enableTokenTrade(ERC20 token) public onlyAdmin {
1165         require(tokenData[token].listed);
1166         require(tokenControlInfo[token].minimalRecordResolution != 0);
1167         tokenData[token].enabled = true;
1168     }
1169 
1170     function disableTokenTrade(ERC20 token) public onlyAlerter {
1171         require(tokenData[token].listed);
1172         tokenData[token].enabled = false;
1173     }
1174 
1175     function setReserveAddress(address reserve) public onlyAdmin {
1176         reserveContract = reserve;
1177     }
1178 
1179     function recordImbalance(
1180         ERC20 token,
1181         int buyAmount,
1182         uint rateUpdateBlock,
1183         uint currentBlock
1184     )
1185         public
1186     {
1187         require(msg.sender == reserveContract);
1188 
1189         if (rateUpdateBlock == 0) rateUpdateBlock = getRateUpdateBlock(token);
1190 
1191         return addImbalance(token, buyAmount, rateUpdateBlock, currentBlock);
1192     }
1193 
1194     /* solhint-disable function-max-lines */
1195     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint) {
1196         // check if trade is enabled
1197         if (!tokenData[token].enabled) return 0;
1198         if (tokenControlInfo[token].minimalRecordResolution == 0) return 0; // token control info not set
1199 
1200         // get rate update block
1201         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
1202 
1203         uint updateRateBlock = getLast4Bytes(compactData);
1204         if (currentBlockNumber >= updateRateBlock + validRateDurationInBlocks) return 0; // rate is expired
1205         // check imbalance
1206         int totalImbalance;
1207         int blockImbalance;
1208         (totalImbalance, blockImbalance) = getImbalance(token, updateRateBlock, currentBlockNumber);
1209 
1210         // calculate actual rate
1211         int imbalanceQty;
1212         int extraBps;
1213         int8 rateUpdate;
1214         uint rate;
1215 
1216         if (buy) {
1217             // start with base rate
1218             rate = tokenData[token].baseBuyRate;
1219 
1220             // add rate update
1221             rateUpdate = getRateByteFromCompactData(compactData, token, true);
1222             extraBps = int(rateUpdate) * 10;
1223             rate = addBps(rate, extraBps);
1224 
1225             // compute token qty
1226             qty = getTokenQty(token, rate, qty);
1227             imbalanceQty = int(qty);
1228             totalImbalance += imbalanceQty;
1229 
1230             // add qty overhead
1231             extraBps = executeStepFunction(tokenData[token].buyRateQtyStepFunction, int(qty));
1232             rate = addBps(rate, extraBps);
1233 
1234             // add imbalance overhead
1235             extraBps = executeStepFunction(tokenData[token].buyRateImbalanceStepFunction, totalImbalance);
1236             rate = addBps(rate, extraBps);
1237         } else {
1238             // start with base rate
1239             rate = tokenData[token].baseSellRate;
1240 
1241             // add rate update
1242             rateUpdate = getRateByteFromCompactData(compactData, token, false);
1243             extraBps = int(rateUpdate) * 10;
1244             rate = addBps(rate, extraBps);
1245 
1246             // compute token qty
1247             imbalanceQty = -1 * int(qty);
1248             totalImbalance += imbalanceQty;
1249 
1250             // add qty overhead
1251             extraBps = executeStepFunction(tokenData[token].sellRateQtyStepFunction, int(qty));
1252             rate = addBps(rate, extraBps);
1253 
1254             // add imbalance overhead
1255             extraBps = executeStepFunction(tokenData[token].sellRateImbalanceStepFunction, totalImbalance);
1256             rate = addBps(rate, extraBps);
1257         }
1258 
1259         if (abs(totalImbalance + imbalanceQty) >= getMaxTotalImbalance(token)) return 0;
1260         if (abs(blockImbalance + imbalanceQty) >= getMaxPerBlockImbalance(token)) return 0;
1261 
1262         return rate;
1263     }
1264     /* solhint-enable function-max-lines */
1265 
1266     function getBasicRate(ERC20 token, bool buy) public view returns(uint) {
1267         if (buy)
1268             return tokenData[token].baseBuyRate;
1269         else
1270             return tokenData[token].baseSellRate;
1271     }
1272 
1273     function getCompactData(ERC20 token) public view returns(uint, uint, byte, byte) {
1274         uint arrayIndex = tokenData[token].compactDataArrayIndex;
1275         uint fieldOffset = tokenData[token].compactDataFieldIndex;
1276 
1277         return (
1278             arrayIndex,
1279             fieldOffset,
1280             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, true)),
1281             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, false))
1282         );
1283     }
1284 
1285     function getTokenBasicData(ERC20 token) public view returns(bool, bool) {
1286         return (tokenData[token].listed, tokenData[token].enabled);
1287     }
1288 
1289     /* solhint-disable code-complexity */
1290     function getStepFunctionData(ERC20 token, uint command, uint param) public view returns(int) {
1291         if (command == 0) return int(tokenData[token].buyRateQtyStepFunction.x.length);
1292         if (command == 1) return tokenData[token].buyRateQtyStepFunction.x[param];
1293         if (command == 2) return int(tokenData[token].buyRateQtyStepFunction.y.length);
1294         if (command == 3) return tokenData[token].buyRateQtyStepFunction.y[param];
1295 
1296         if (command == 4) return int(tokenData[token].sellRateQtyStepFunction.x.length);
1297         if (command == 5) return tokenData[token].sellRateQtyStepFunction.x[param];
1298         if (command == 6) return int(tokenData[token].sellRateQtyStepFunction.y.length);
1299         if (command == 7) return tokenData[token].sellRateQtyStepFunction.y[param];
1300 
1301         if (command == 8) return int(tokenData[token].buyRateImbalanceStepFunction.x.length);
1302         if (command == 9) return tokenData[token].buyRateImbalanceStepFunction.x[param];
1303         if (command == 10) return int(tokenData[token].buyRateImbalanceStepFunction.y.length);
1304         if (command == 11) return tokenData[token].buyRateImbalanceStepFunction.y[param];
1305 
1306         if (command == 12) return int(tokenData[token].sellRateImbalanceStepFunction.x.length);
1307         if (command == 13) return tokenData[token].sellRateImbalanceStepFunction.x[param];
1308         if (command == 14) return int(tokenData[token].sellRateImbalanceStepFunction.y.length);
1309         if (command == 15) return tokenData[token].sellRateImbalanceStepFunction.y[param];
1310 
1311         revert();
1312     }
1313     /* solhint-enable code-complexity */
1314 
1315     function getRateUpdateBlock(ERC20 token) public view returns(uint) {
1316         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
1317         return getLast4Bytes(compactData);
1318     }
1319 
1320     function getListedTokens() public view returns(ERC20[]) {
1321         return listedTokens;
1322     }
1323 
1324     function getTokenQty(ERC20 token, uint ethQty, uint rate) internal view returns(uint) {
1325         uint dstDecimals = token.decimals();
1326         uint srcDecimals = 18;
1327 
1328         return calcDstQty(ethQty, srcDecimals, dstDecimals, rate);
1329     }
1330 
1331     function getLast4Bytes(bytes32 b) internal pure returns(uint) {
1332         // cannot trust compiler with not turning bit operations into EXP opcode
1333         return uint(b) / (BYTES_14_OFFSET * BYTES_14_OFFSET);
1334     }
1335 
1336     function getRateByteFromCompactData(bytes32 data, ERC20 token, bool buy) internal view returns(int8) {
1337         uint fieldOffset = tokenData[token].compactDataFieldIndex;
1338         uint byteOffset;
1339         if (buy)
1340             byteOffset = 32 - NUM_TOKENS_IN_COMPACT_DATA + fieldOffset;
1341         else
1342             byteOffset = 4 + fieldOffset;
1343 
1344         return int8(data[byteOffset]);
1345     }
1346 
1347     function executeStepFunction(StepFunction f, int x) internal pure returns(int) {
1348         uint len = f.y.length;
1349         for (uint ind = 0; ind < len; ind++) {
1350             if (x <= f.x[ind]) return f.y[ind];
1351         }
1352 
1353         return f.y[len-1];
1354     }
1355 
1356     function addBps(uint rate, int bps) internal pure returns(uint) {
1357         uint maxBps = 100 * 100;
1358         return (rate * uint(int(maxBps) + bps)) / maxBps;
1359     }
1360 
1361     function abs(int x) internal pure returns(uint) {
1362         if (x < 0)
1363             return uint(-1 * x);
1364         else
1365             return uint(x);
1366     }
1367 }
1368 
1369 contract SanityRates is SanityRatesInterface, Withdrawable, Utils {
1370     mapping(address=>uint) public tokenRate;
1371     mapping(address=>uint) public reasonableDiffInBps;
1372 
1373     function SanityRates(address _admin) public {
1374         require(_admin != address(0));
1375         admin = _admin;
1376     }
1377 
1378     function setReasonableDiff(ERC20[] srcs, uint[] diff) public onlyAdmin {
1379         require(srcs.length == diff.length);
1380         for (uint i = 0; i < srcs.length; i++) {
1381             reasonableDiffInBps[srcs[i]] = diff[i];
1382         }
1383     }
1384 
1385     function setSanityRates(ERC20[] srcs, uint[] rates) public onlyOperator {
1386         require(srcs.length == rates.length);
1387 
1388         for (uint i = 0; i < srcs.length; i++) {
1389             tokenRate[srcs[i]] = rates[i];
1390         }
1391     }
1392 
1393     function getSanityRate(ERC20 src, ERC20 dest) public view returns(uint) {
1394         if (src != ETH_TOKEN_ADDRESS && dest != ETH_TOKEN_ADDRESS) return 0;
1395 
1396         uint rate;
1397         address token;
1398         if (src == ETH_TOKEN_ADDRESS) {
1399             rate = (PRECISION*PRECISION)/tokenRate[dest];
1400             token = dest;
1401         } else {
1402             rate = tokenRate[src];
1403             token = src;
1404         }
1405 
1406         return rate * (10000 + reasonableDiffInBps[token])/10000;
1407     }
1408 }
1409 
1410 contract ExpectedRate is Withdrawable, ExpectedRateInterface {
1411 
1412     KyberNetwork public kyberNetwork;
1413     uint public quantityFactor = 2;
1414     uint public minSlippageFactorInBps = 50;
1415 
1416     function ExpectedRate(KyberNetwork _kyberNetwork, address _admin) public {
1417         require(_admin != address(0));
1418         require(_kyberNetwork != address(0));
1419         kyberNetwork = _kyberNetwork;
1420         admin = _admin;
1421     }
1422 
1423     event QuantityFactorSet (uint newFactor, uint oldFactor, address sender);
1424 
1425     function setQuantityFactor(uint newFactor) public onlyOperator {
1426         QuantityFactorSet(quantityFactor, newFactor, msg.sender);
1427         quantityFactor = newFactor;
1428     }
1429 
1430     event MinSlippageFactorSet (uint newMin, uint oldMin, address sender);
1431 
1432     function setMinSlippageFactor(uint bps) public onlyOperator {
1433         MinSlippageFactorSet(bps, minSlippageFactorInBps, msg.sender);
1434         minSlippageFactorInBps = bps;
1435     }
1436 
1437     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
1438         public view
1439         returns (uint expectedRate, uint slippageRate)
1440     {
1441         require(quantityFactor != 0);
1442 
1443         uint bestReserve;
1444         uint minSlippage;
1445 
1446         (bestReserve, expectedRate) = kyberNetwork.findBestRate(src, dest, srcQty);
1447         (bestReserve, slippageRate) = kyberNetwork.findBestRate(src, dest, (srcQty * quantityFactor));
1448 
1449         minSlippage = ((10000 - minSlippageFactorInBps) * expectedRate) / 10000;
1450         if (slippageRate >= minSlippage) {
1451             slippageRate = minSlippage;
1452         }
1453 
1454         return (expectedRate, slippageRate);
1455     }
1456 }
1457 
1458 interface FeeBurnerInterface {
1459     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
1460 }
1461 
1462 contract FeeBurner is Withdrawable, FeeBurnerInterface {
1463 
1464     mapping(address=>uint) public reserveFeesInBps;
1465     mapping(address=>address) public reserveKNCWallet;
1466     mapping(address=>uint) public walletFeesInBps;
1467     mapping(address=>uint) public reserveFeeToBurn;
1468     mapping(address=>mapping(address=>uint)) public reserveFeeToWallet;
1469 
1470     BurnableToken public knc;
1471     address public kyberNetwork;
1472     uint public kncPerETHRate = 300;
1473 
1474     function FeeBurner(address _admin, BurnableToken kncToken) public {
1475         require(_admin != address(0));
1476         require(kncToken != address(0));
1477         admin = _admin;
1478         knc = kncToken;
1479     }
1480 
1481     function setReserveData(address reserve, uint feesInBps, address kncWallet) public onlyAdmin {
1482         require(feesInBps < 100); // make sure it is always < 1%
1483         require(kncWallet != address(0));
1484         reserveFeesInBps[reserve] = feesInBps;
1485         reserveKNCWallet[reserve] = kncWallet;
1486     }
1487 
1488     function setWalletFees(address wallet, uint feesInBps) public onlyAdmin {
1489         require(feesInBps < 10000); // under 100%
1490         walletFeesInBps[wallet] = feesInBps;
1491     }
1492 
1493     function setKyberNetwork(address _kyberNetwork) public onlyAdmin {
1494         require(_kyberNetwork != address(0));
1495         kyberNetwork = _kyberNetwork;
1496     }
1497 
1498     function setKNCRate(uint rate) public onlyAdmin {
1499         kncPerETHRate = rate;
1500     }
1501 
1502     event AssignFeeToWallet(address reserve, address wallet, uint walletFee);
1503     event AssignBurnFees(address reserve, uint burnFee);
1504 
1505     function handleFees(uint tradeWeiAmount, address reserve, address wallet) public returns(bool) {
1506         require(msg.sender == kyberNetwork);
1507 
1508         uint kncAmount = tradeWeiAmount * kncPerETHRate;
1509         uint fee = kncAmount * reserveFeesInBps[reserve] / 10000;
1510 
1511         uint walletFee = fee * walletFeesInBps[wallet] / 10000;
1512         require(fee >= walletFee);
1513         uint feeToBurn = fee - walletFee;
1514 
1515         if (walletFee > 0) {
1516             reserveFeeToWallet[reserve][wallet] += walletFee;
1517             AssignFeeToWallet(reserve, wallet, walletFee);
1518         }
1519 
1520         if (feeToBurn > 0) {
1521             AssignBurnFees(reserve, feeToBurn);
1522             reserveFeeToBurn[reserve] += feeToBurn;
1523         }
1524 
1525         return true;
1526     }
1527 
1528     // this function is callable by anyone
1529     event BurnAssignedFees(address indexed reserve, address sender);
1530 
1531     function burnReserveFees(address reserve) public {
1532         uint burnAmount = reserveFeeToBurn[reserve];
1533         require(burnAmount > 1);
1534         reserveFeeToBurn[reserve] = 1; // leave 1 twei to avoid spikes in gas fee
1535         require(knc.burnFrom(reserveKNCWallet[reserve], burnAmount - 1));
1536 
1537         BurnAssignedFees(reserve, msg.sender);
1538     }
1539 
1540     event SendWalletFees(address indexed wallet, address reserve, address sender);
1541 
1542     // this function is callable by anyone
1543     function sendFeeToWallet(address wallet, address reserve) public {
1544         uint feeAmount = reserveFeeToWallet[reserve][wallet];
1545         require(feeAmount > 1);
1546         reserveFeeToWallet[reserve][wallet] = 1; // leave 1 twei to avoid spikes in gas fee
1547         require(knc.transferFrom(reserveKNCWallet[reserve], wallet, feeAmount - 1));
1548 
1549         SendWalletFees(wallet, reserve, msg.sender);
1550     }
1551 }
1552 
1553 contract WhiteList is Withdrawable {
1554 
1555     uint public weiPerSgd; // amount of weis in 1 singapore dollar
1556     mapping (address=>uint) public userCategory; // each user has a category defining cap on trade. 0 for standard.
1557     mapping (uint=>uint)    public categoryCap;  // will define cap on trade amount per category in singapore Dollar.
1558 
1559     function WhiteList(address _admin) public {
1560         require(_admin != address(0));
1561         admin = _admin;
1562     }
1563 
1564     function getUserCapInWei(address user) external view returns (uint userCapWei) {
1565         uint category = userCategory[user];
1566         return (categoryCap[category] * weiPerSgd);
1567     }
1568 
1569     event UserCategorySet(address user, uint category);
1570 
1571     function setUserCategory(address user, uint category) public onlyOperator {
1572         userCategory[user] = category;
1573         UserCategorySet(user, category);
1574     }
1575 
1576     event CategoryCapSet (uint category, uint sgdCap);
1577 
1578     function setCategoryCap(uint category, uint sgdCap) public onlyOperator {
1579         categoryCap[category] = sgdCap;
1580         CategoryCapSet(category, sgdCap);
1581     }
1582 
1583     event SgdToWeiRateSet (uint rate);
1584 
1585     function setSgdToEthRate(uint _sgdToWeiRate) public onlyOperator {
1586         weiPerSgd = _sgdToWeiRate;
1587         SgdToWeiRateSet(_sgdToWeiRate);
1588     }
1589 }