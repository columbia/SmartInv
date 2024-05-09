1 pragma solidity ^0.4.24;
2 
3 // File: contracts/vendors/kyber/ERC20Interface.sol
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
17 // File: contracts/vendors/kyber/PermissionGroups.sol
18 
19 contract PermissionGroups {
20 
21     address public admin;
22     address public pendingAdmin;
23     mapping(address=>bool) internal operators;
24     mapping(address=>bool) internal alerters;
25     address[] internal operatorsGroup;
26     address[] internal alertersGroup;
27     uint constant internal MAX_GROUP_SIZE = 50;
28 
29     constructor () public {
30         admin = msg.sender;
31     }
32 
33     modifier onlyAdmin() {
34         require(msg.sender == admin);
35         _;
36     }
37 
38     modifier onlyOperator() {
39         require(operators[msg.sender]);
40         _;
41     }
42 
43     modifier onlyAlerter() {
44         require(alerters[msg.sender]);
45         _;
46     }
47 
48     function getOperators () external view returns(address[]) {
49         return operatorsGroup;
50     }
51 
52     function getAlerters () external view returns(address[]) {
53         return alertersGroup;
54     }
55 
56     event TransferAdminPending(address pendingAdmin);
57 
58     /**
59      * @dev Allows the current admin to set the pendingAdmin address.
60      * @param newAdmin The address to transfer ownership to.
61      */
62     function transferAdmin(address newAdmin) public onlyAdmin {
63         require(newAdmin != address(0));
64         emit TransferAdminPending(pendingAdmin);
65         pendingAdmin = newAdmin;
66     }
67 
68     /**
69      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
70      * @param newAdmin The address to transfer ownership to.
71      */
72     function transferAdminQuickly(address newAdmin) public onlyAdmin {
73         require(newAdmin != address(0));
74         emit TransferAdminPending(newAdmin);
75         emit AdminClaimed(newAdmin, admin);
76         admin = newAdmin;
77     }
78 
79     event AdminClaimed( address newAdmin, address previousAdmin);
80 
81     /**
82      * @dev Allows the pendingAdmin address to finalize the change admin process.
83      */
84     function claimAdmin() public {
85         require(pendingAdmin == msg.sender);
86         emit AdminClaimed(pendingAdmin, admin);
87         admin = pendingAdmin;
88         pendingAdmin = address(0);
89     }
90 
91     event AlerterAdded (address newAlerter, bool isAdd);
92 
93     function addAlerter(address newAlerter) public onlyAdmin {
94         require(!alerters[newAlerter]); // prevent duplicates.
95         require(alertersGroup.length < MAX_GROUP_SIZE);
96 
97         AlerterAdded(newAlerter, true);
98         alerters[newAlerter] = true;
99         alertersGroup.push(newAlerter);
100     }
101 
102     function removeAlerter (address alerter) public onlyAdmin {
103         require(alerters[alerter]);
104         alerters[alerter] = false;
105 
106         for (uint i = 0; i < alertersGroup.length; ++i) {
107             if (alertersGroup[i] == alerter) {
108                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
109                 alertersGroup.length--;
110                 AlerterAdded(alerter, false);
111                 break;
112             }
113         }
114     }
115 
116     event OperatorAdded(address newOperator, bool isAdd);
117 
118     function addOperator(address newOperator) public onlyAdmin {
119         require(!operators[newOperator]); // prevent duplicates.
120         require(operatorsGroup.length < MAX_GROUP_SIZE);
121 
122         emit OperatorAdded(newOperator, true);
123         operators[newOperator] = true;
124         operatorsGroup.push(newOperator);
125     }
126 
127     function removeOperator (address operator) public onlyAdmin {
128         require(operators[operator]);
129         operators[operator] = false;
130 
131         for (uint i = 0; i < operatorsGroup.length; ++i) {
132             if (operatorsGroup[i] == operator) {
133                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
134                 operatorsGroup.length -= 1;
135                 emit OperatorAdded(operator, false);
136                 break;
137             }
138         }
139     }
140 }
141 
142 // File: contracts/vendors/kyber/Withdrawable.sol
143 
144 /**
145  * @title Contracts that should be able to recover tokens or ethers
146  * @author Ilan Doron
147  * @dev This allows to recover any tokens or Ethers received in a contract.
148  * This will prevent any accidental loss of tokens.
149  */
150 contract Withdrawable is PermissionGroups {
151 
152     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
153 
154     /**
155      * @dev Withdraw all ERC20 compatible tokens
156      * @param token ERC20 The address of the token contract
157      */
158     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
159         require(token.transfer(sendTo, amount));
160         emit TokenWithdraw(token, amount, sendTo);
161     }
162 
163     event EtherWithdraw(uint amount, address sendTo);
164 
165     /**
166      * @dev Withdraw Ethers
167      */
168     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
169         sendTo.transfer(amount);
170         emit EtherWithdraw(amount, sendTo);
171     }
172 }
173 
174 // File: contracts/vendors/kyber/Utils.sol
175 
176 /// @title Kyber constants contract
177 contract Utils {
178 
179     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
180     uint  constant internal PRECISION = (10**18);
181     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
182     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
183     uint  constant internal MAX_DECIMALS = 18;
184     uint  constant internal ETH_DECIMALS = 18;
185     mapping(address=>uint) internal decimals;
186 
187     function setDecimals(ERC20 token) internal {
188         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
189         else decimals[token] = token.decimals();
190     }
191 
192     function getDecimals(ERC20 token) internal view returns(uint) {
193         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
194         uint tokenDecimals = decimals[token];
195         // technically, there might be token with decimals 0
196         // moreover, very possible that old tokens have decimals 0
197         // these tokens will just have higher gas fees.
198         if(tokenDecimals == 0) return token.decimals();
199 
200         return tokenDecimals;
201     }
202 
203     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
204         require(srcQty <= MAX_QTY);
205         require(rate <= MAX_RATE);
206 
207         if (dstDecimals >= srcDecimals) {
208             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
209             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
210         } else {
211             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
212             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
213         }
214     }
215 
216     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
217         require(dstQty <= MAX_QTY);
218         require(rate <= MAX_RATE);
219         
220         //source quantity is rounded up. to avoid dest quantity being too low.
221         uint numerator;
222         uint denominator;
223         if (srcDecimals >= dstDecimals) {
224             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
225             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
226             denominator = rate;
227         } else {
228             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
229             numerator = (PRECISION * dstQty);
230             denominator = (rate * (10**(dstDecimals - srcDecimals)));
231         }
232         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
233     }
234 }
235 
236 // File: contracts/vendors/kyber/Utils2.sol
237 
238 contract Utils2 is Utils {
239 
240     /// @dev get the balance of a user.
241     /// @param token The token type
242     /// @return The balance
243     function getBalance(ERC20 token, address user) public view returns(uint) {
244         if (token == ETH_TOKEN_ADDRESS)
245             return user.balance;
246         else
247             return token.balanceOf(user);
248     }
249 
250     function getDecimalsSafe(ERC20 token) internal returns(uint) {
251 
252         if (decimals[token] == 0) {
253             setDecimals(token);
254         }
255 
256         return decimals[token];
257     }
258 
259     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
260         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
261     }
262 
263     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
264         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
265     }
266 
267     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
268         internal pure returns(uint)
269     {
270         require(srcAmount <= MAX_QTY);
271         require(destAmount <= MAX_QTY);
272 
273         if (dstDecimals >= srcDecimals) {
274             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
275             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
276         } else {
277             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
278             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
279         }
280     }
281 }
282 
283 // File: contracts/vendors/kyber/KyberNetworkInterface.sol
284 
285 /// @title Kyber Network interface
286 interface KyberNetworkInterface {
287     function maxGasPrice() public view returns(uint);
288     function getUserCapInWei(address user) public view returns(uint);
289     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint);
290     function enabled() public view returns(bool);
291     function info(bytes32 id) public view returns(uint);
292 
293     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
294         returns (uint expectedRate, uint slippageRate);
295 
296     function tradeWithHint(address trader, ERC20 src, uint srcAmount, ERC20 dest, address destAddress,
297         uint maxDestAmount, uint minConversionRate, address walletId, bytes hint) public payable returns(uint);
298 }
299 
300 // File: contracts/vendors/kyber/KyberNetworkProxyInterface.sol
301 
302 /// @title Kyber Network interface
303 interface KyberNetworkProxyInterface {
304     function maxGasPrice() public view returns(uint);
305     function getUserCapInWei(address user) public view returns(uint);
306     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint);
307     function enabled() public view returns(bool);
308     function info(bytes32 id) public view returns(uint);
309 
310     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
311         returns (uint expectedRate, uint slippageRate);
312 
313     function tradeWithHint(ERC20 src, uint srcAmount, ERC20 dest, address destAddress, uint maxDestAmount,
314         uint minConversionRate, address walletId, bytes hint) public payable returns(uint);
315 }
316 
317 // File: contracts/vendors/kyber/SimpleNetworkInterface.sol
318 
319 /// @title simple interface for Kyber Network 
320 interface SimpleNetworkInterface {
321     function swapTokenToToken(ERC20 src, uint srcAmount, ERC20 dest, uint minConversionRate) public returns(uint);
322     function swapEtherToToken(ERC20 token, uint minConversionRate) public payable returns(uint);
323     function swapTokenToEther(ERC20 token, uint srcAmount, uint minConversionRate) public returns(uint);
324 }
325 
326 // File: contracts/vendors/kyber/KyberNetworkProxy.sol
327 
328 ////////////////////////////////////////////////////////////////////////////////////////////////////////
329 /// @title Kyber Network proxy for main contract
330 contract KyberNetworkProxy is KyberNetworkProxyInterface, SimpleNetworkInterface, Withdrawable, Utils2 {
331 
332     KyberNetworkInterface public kyberNetworkContract;
333 
334     function KyberNetworkProxy(address _admin) public {
335         require(_admin != address(0));
336         admin = _admin;
337     }
338 
339     /// @notice use token address ETH_TOKEN_ADDRESS for ether
340     /// @dev makes a trade between src and dest token and send dest token to destAddress
341     /// @param src Src token
342     /// @param srcAmount amount of src tokens
343     /// @param dest   Destination token
344     /// @param destAddress Address to send tokens to
345     /// @param maxDestAmount A limit on the amount of dest tokens
346     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
347     /// @param walletId is the wallet ID to send part of the fees
348     /// @return amount of actual dest tokens
349     function trade(
350         ERC20 src,
351         uint srcAmount,
352         ERC20 dest,
353         address destAddress,
354         uint maxDestAmount,
355         uint minConversionRate,
356         address walletId
357     )
358         public
359         payable
360         returns(uint)
361     {
362         bytes memory hint;
363 
364         return tradeWithHint(
365             src,
366             srcAmount,
367             dest,
368             destAddress,
369             maxDestAmount,
370             minConversionRate,
371             walletId,
372             hint
373         );
374     }
375 
376     /// @dev makes a trade between src and dest token and send dest tokens to msg sender
377     /// @param src Src token
378     /// @param srcAmount amount of src tokens
379     /// @param dest Destination token
380     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
381     /// @return amount of actual dest tokens
382     function swapTokenToToken(
383         ERC20 src,
384         uint srcAmount,
385         ERC20 dest,
386         uint minConversionRate
387     )
388         public
389         returns(uint)
390     {
391         bytes memory hint;
392 
393         return tradeWithHint(
394             src,
395             srcAmount,
396             dest,
397             msg.sender,
398             MAX_QTY,
399             minConversionRate,
400             0,
401             hint
402         );
403     }
404 
405     /// @dev makes a trade from Ether to token. Sends token to msg sender
406     /// @param token Destination token
407     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
408     /// @return amount of actual dest tokens
409     function swapEtherToToken(ERC20 token, uint minConversionRate) public payable returns(uint) {
410         bytes memory hint;
411 
412         return tradeWithHint(
413             ETH_TOKEN_ADDRESS,
414             msg.value,
415             token,
416             msg.sender,
417             MAX_QTY,
418             minConversionRate,
419             0,
420             hint
421         );
422     }
423 
424     /// @dev makes a trade from token to Ether, sends Ether to msg sender
425     /// @param token Src token
426     /// @param srcAmount amount of src tokens
427     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
428     /// @return amount of actual dest tokens
429     function swapTokenToEther(ERC20 token, uint srcAmount, uint minConversionRate) public returns(uint) {
430         bytes memory hint;
431 
432         return tradeWithHint(
433             token,
434             srcAmount,
435             ETH_TOKEN_ADDRESS,
436             msg.sender,
437             MAX_QTY,
438             minConversionRate,
439             0,
440             hint
441         );
442     }
443 
444     struct UserBalance {
445         uint srcBalance;
446         uint destBalance;
447     }
448 
449     event ExecuteTrade(address indexed trader, ERC20 src, ERC20 dest, uint actualSrcAmount, uint actualDestAmount);
450 
451     /// @notice use token address ETH_TOKEN_ADDRESS for ether
452     /// @dev makes a trade between src and dest token and send dest token to destAddress
453     /// @param src Src token
454     /// @param srcAmount amount of src tokens
455     /// @param dest Destination token
456     /// @param destAddress Address to send tokens to
457     /// @param maxDestAmount A limit on the amount of dest tokens
458     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
459     /// @param walletId is the wallet ID to send part of the fees
460     /// @param hint will give hints for the trade.
461     /// @return amount of actual dest tokens
462     function tradeWithHint(
463         ERC20 src,
464         uint srcAmount,
465         ERC20 dest,
466         address destAddress,
467         uint maxDestAmount,
468         uint minConversionRate,
469         address walletId,
470         bytes hint
471     )
472         public
473         payable
474         returns(uint)
475     {
476         require(src == ETH_TOKEN_ADDRESS || msg.value == 0);
477         
478         UserBalance memory userBalanceBefore;
479 
480         userBalanceBefore.srcBalance = getBalance(src, msg.sender);
481         userBalanceBefore.destBalance = getBalance(dest, destAddress);
482 
483         if (src == ETH_TOKEN_ADDRESS) {
484             userBalanceBefore.srcBalance += msg.value;
485         } else {
486             require(src.transferFrom(msg.sender, kyberNetworkContract, srcAmount));
487         }
488 
489         uint reportedDestAmount = kyberNetworkContract.tradeWithHint.value(msg.value)(
490             msg.sender,
491             src,
492             srcAmount,
493             dest,
494             destAddress,
495             maxDestAmount,
496             minConversionRate,
497             walletId,
498             hint
499         );
500 
501         TradeOutcome memory tradeOutcome = calculateTradeOutcome(
502             userBalanceBefore.srcBalance,
503             userBalanceBefore.destBalance,
504             src,
505             dest,
506             destAddress
507         );
508 
509         require(reportedDestAmount == tradeOutcome.userDeltaDestAmount);
510         require(tradeOutcome.userDeltaDestAmount <= maxDestAmount);
511         require(tradeOutcome.actualRate >= minConversionRate);
512 
513         ExecuteTrade(msg.sender, src, dest, tradeOutcome.userDeltaSrcAmount, tradeOutcome.userDeltaDestAmount);
514         return tradeOutcome.userDeltaDestAmount;
515     }
516 
517     event KyberNetworkSet(address newNetworkContract, address oldNetworkContract);
518 
519     function setKyberNetworkContract(KyberNetworkInterface _kyberNetworkContract) public onlyAdmin {
520 
521         require(_kyberNetworkContract != address(0));
522 
523         KyberNetworkSet(_kyberNetworkContract, kyberNetworkContract);
524 
525         kyberNetworkContract = _kyberNetworkContract;
526     }
527 
528     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
529         public view
530         returns(uint expectedRate, uint slippageRate)
531     {
532         return kyberNetworkContract.getExpectedRate(src, dest, srcQty);
533     }
534 
535     function getUserCapInWei(address user) public view returns(uint) {
536         return kyberNetworkContract.getUserCapInWei(user);
537     }
538 
539     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint) {
540         return kyberNetworkContract.getUserCapInTokenWei(user, token);
541     }
542 
543     function maxGasPrice() public view returns(uint) {
544         return kyberNetworkContract.maxGasPrice();
545     }
546 
547     function enabled() public view returns(bool) {
548         return kyberNetworkContract.enabled();
549     }
550 
551     function info(bytes32 field) public view returns(uint) {
552         return kyberNetworkContract.info(field);
553     }
554 
555     struct TradeOutcome {
556         uint userDeltaSrcAmount;
557         uint userDeltaDestAmount;
558         uint actualRate;
559     }
560 
561     function calculateTradeOutcome (uint srcBalanceBefore, uint destBalanceBefore, ERC20 src, ERC20 dest,
562         address destAddress)
563         internal returns(TradeOutcome outcome)
564     {
565         uint userSrcBalanceAfter;
566         uint userDestBalanceAfter;
567 
568         userSrcBalanceAfter = getBalance(src, msg.sender);
569         userDestBalanceAfter = getBalance(dest, destAddress);
570 
571         //protect from underflow
572         require(userDestBalanceAfter > destBalanceBefore);
573         require(srcBalanceBefore > userSrcBalanceAfter);
574 
575         outcome.userDeltaDestAmount = userDestBalanceAfter - destBalanceBefore;
576         outcome.userDeltaSrcAmount = srcBalanceBefore - userSrcBalanceAfter;
577 
578         outcome.actualRate = calcRateFromQty(
579                 outcome.userDeltaSrcAmount,
580                 outcome.userDeltaDestAmount,
581                 getDecimalsSafe(src),
582                 getDecimalsSafe(dest)
583             );
584     }
585 }
586 
587 // File: contracts/vendors/kyber/KyberReserveInterface.sol
588 
589 /// @title Kyber Reserve contract
590 interface KyberReserveInterface {
591 
592     function trade(
593         ERC20 srcToken,
594         uint srcAmount,
595         ERC20 destToken,
596         address destAddress,
597         uint conversionRate,
598         bool validate
599     )
600         public
601         payable
602         returns(bool);
603 
604     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
605 }
606 
607 // File: contracts/vendors/kyber/WhiteListInterface.sol
608 
609 contract WhiteListInterface {
610     function getUserCapInWei(address user) external view returns (uint userCapWei);
611 }
612 
613 // File: contracts/vendors/kyber/ExpectedRateInterface.sol
614 
615 interface ExpectedRateInterface {
616     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
617         returns (uint expectedRate, uint slippageRate);
618 }
619 
620 // File: contracts/vendors/kyber/FeeBurnerInterface.sol
621 
622 interface FeeBurnerInterface {
623     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
624 }
625 
626 // File: contracts/vendors/kyber/KyberNetwork.sol
627 
628 ////////////////////////////////////////////////////////////////////////////////////////////////////////
629 /// @title Kyber Network main contract
630 contract KyberNetwork is Withdrawable, Utils2, KyberNetworkInterface {
631 
632     uint public negligibleRateDiff = 10; // basic rate steps will be in 0.01%
633     KyberReserveInterface[] public reserves;
634     mapping(address=>bool) public isReserve;
635     WhiteListInterface public whiteListContract;
636     ExpectedRateInterface public expectedRateContract;
637     FeeBurnerInterface    public feeBurnerContract;
638     address               public kyberNetworkProxyContract;
639     uint                  public maxGasPriceValue = 50 * 1000 * 1000 * 1000; // 50 gwei
640     bool                  public isEnabled = false; // network is enabled
641     mapping(bytes32=>uint) public infoFields; // this is only a UI field for external app.
642     mapping(address=>address[]) public reservesPerTokenSrc; //reserves supporting token to eth
643     mapping(address=>address[]) public reservesPerTokenDest;//reserves support eth to token
644 
645     function KyberNetwork(address _admin) public {
646         require(_admin != address(0));
647         admin = _admin;
648     }
649 
650     event EtherReceival(address indexed sender, uint amount);
651 
652     /* solhint-disable no-complex-fallback */
653     // To avoid users trying to swap tokens using default payable function. We added this short code
654     //  to verify Ethers will be received only from reserves if transferred without a specific function call.
655     function() public payable {
656         require(isReserve[msg.sender]);
657         EtherReceival(msg.sender, msg.value);
658     }
659     /* solhint-enable no-complex-fallback */
660 
661     struct TradeInput {
662         address trader;
663         ERC20 src;
664         uint srcAmount;
665         ERC20 dest;
666         address destAddress;
667         uint maxDestAmount;
668         uint minConversionRate;
669         address walletId;
670         bytes hint;
671     }
672 
673     function tradeWithHint(
674         address trader,
675         ERC20 src,
676         uint srcAmount,
677         ERC20 dest,
678         address destAddress,
679         uint maxDestAmount,
680         uint minConversionRate,
681         address walletId,
682         bytes hint
683     )
684         public
685         payable
686         returns(uint)
687     {
688         require(hint.length == 0);
689         require(msg.sender == kyberNetworkProxyContract);
690 
691         TradeInput memory tradeInput;
692 
693         tradeInput.trader = trader;
694         tradeInput.src = src;
695         tradeInput.srcAmount = srcAmount;
696         tradeInput.dest = dest;
697         tradeInput.destAddress = destAddress;
698         tradeInput.maxDestAmount = maxDestAmount;
699         tradeInput.minConversionRate = minConversionRate;
700         tradeInput.walletId = walletId;
701         tradeInput.hint = hint;
702 
703         return trade(tradeInput);
704     }
705 
706     event AddReserveToNetwork(KyberReserveInterface reserve, bool add);
707 
708     /// @notice can be called only by admin
709     /// @dev add or deletes a reserve to/from the network.
710     /// @param reserve The reserve address.
711     /// @param add If true, the add reserve. Otherwise delete reserve.
712     function addReserve(KyberReserveInterface reserve, bool add) public onlyAdmin {
713 
714         if (add) {
715             require(!isReserve[reserve]);
716             reserves.push(reserve);
717             isReserve[reserve] = true;
718             AddReserveToNetwork(reserve, true);
719         } else {
720             isReserve[reserve] = false;
721             // will have trouble if more than 50k reserves...
722             for (uint i = 0; i < reserves.length; i++) {
723                 if (reserves[i] == reserve) {
724                     reserves[i] = reserves[reserves.length - 1];
725                     reserves.length--;
726                     AddReserveToNetwork(reserve, false);
727                     break;
728                 }
729             }
730         }
731     }
732 
733     event ListReservePairs(address reserve, ERC20 src, ERC20 dest, bool add);
734 
735     /// @notice can be called only by admin
736     /// @dev allow or prevent a specific reserve to trade a pair of tokens
737     /// @param reserve The reserve address.
738     /// @param token token address
739     /// @param ethToToken will it support ether to token trade
740     /// @param tokenToEth will it support token to ether trade
741     /// @param add If true then list this pair, otherwise unlist it.
742     function listPairForReserve(address reserve, ERC20 token, bool ethToToken, bool tokenToEth, bool add)
743         public onlyAdmin
744     {
745         require(isReserve[reserve]);
746 
747         if (ethToToken) {
748             listPairs(reserve, token, false, add);
749 
750             ListReservePairs(reserve, ETH_TOKEN_ADDRESS, token, add);
751         }
752 
753         if (tokenToEth) {
754             listPairs(reserve, token, true, add);
755             if (add) {
756                 token.approve(reserve, 2**255); // approve infinity
757             } else {
758                 token.approve(reserve, 0);
759             }
760 
761             ListReservePairs(reserve, token, ETH_TOKEN_ADDRESS, add);
762         }
763 
764         setDecimals(token);
765     }
766 
767     function setWhiteList(WhiteListInterface whiteList) public onlyAdmin {
768         require(whiteList != address(0));
769         whiteListContract = whiteList;
770     }
771 
772     function setExpectedRate(ExpectedRateInterface expectedRate) public onlyAdmin {
773         require(expectedRate != address(0));
774         expectedRateContract = expectedRate;
775     }
776 
777     function setFeeBurner(FeeBurnerInterface feeBurner) public onlyAdmin {
778         require(feeBurner != address(0));
779         feeBurnerContract = feeBurner;
780     }
781 
782     function setParams(
783         uint                  _maxGasPrice,
784         uint                  _negligibleRateDiff
785     )
786         public
787         onlyAdmin
788     {
789         require(_negligibleRateDiff <= 100 * 100); // at most 100%
790 
791         maxGasPriceValue = _maxGasPrice;
792         negligibleRateDiff = _negligibleRateDiff;
793     }
794 
795     function setEnable(bool _enable) public onlyAdmin {
796         if (_enable) {
797             require(whiteListContract != address(0));
798             require(feeBurnerContract != address(0));
799             require(expectedRateContract != address(0));
800             require(kyberNetworkProxyContract != address(0));
801         }
802         isEnabled = _enable;
803     }
804 
805     function setInfo(bytes32 field, uint value) public onlyOperator {
806         infoFields[field] = value;
807     }
808 
809     event KyberProxySet(address proxy, address sender);
810 
811     function setKyberProxy(address networkProxy) public onlyAdmin {
812         require(networkProxy != address(0));
813         kyberNetworkProxyContract = networkProxy;
814         KyberProxySet(kyberNetworkProxyContract, msg.sender);
815     }
816 
817     /// @dev returns number of reserves
818     /// @return number of reserves
819     function getNumReserves() public view returns(uint) {
820         return reserves.length;
821     }
822 
823     /// @notice should be called off chain with as much gas as needed
824     /// @dev get an array of all reserves
825     /// @return An array of all reserves
826     function getReserves() public view returns(KyberReserveInterface[]) {
827         return reserves;
828     }
829 
830     function maxGasPrice() public view returns(uint) {
831         return maxGasPriceValue;
832     }
833 
834     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
835         public view
836         returns(uint expectedRate, uint slippageRate)
837     {
838         require(expectedRateContract != address(0));
839         return expectedRateContract.getExpectedRate(src, dest, srcQty);
840     }
841 
842     function getUserCapInWei(address user) public view returns(uint) {
843         return whiteListContract.getUserCapInWei(user);
844     }
845 
846     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint) {
847         //future feature
848         user;
849         token;
850         require(false);
851     }
852 
853     struct BestRateResult {
854         uint rate;
855         address reserve1;
856         address reserve2;
857         uint weiAmount;
858         uint rateSrcToEth;
859         uint rateEthToDest;
860         uint destAmount;
861     }
862 
863     /// @notice use token address ETH_TOKEN_ADDRESS for ether
864     /// @dev best conversion rate for a pair of tokens, if number of reserves have small differences. randomize
865     /// @param src Src token
866     /// @param dest Destination token
867     /// @return obsolete - used to return best reserve index. not relevant anymore for this API.
868     function findBestRate(ERC20 src, ERC20 dest, uint srcAmount) public view returns(uint obsolete, uint rate) {
869         BestRateResult memory result = findBestRateTokenToToken(src, dest, srcAmount);
870         return(0, result.rate);
871     }
872 
873     function enabled() public view returns(bool) {
874         return isEnabled;
875     }
876 
877     function info(bytes32 field) public view returns(uint) {
878         return infoFields[field];
879     }
880 
881     /* solhint-disable code-complexity */
882     // Not sure how solhing defines complexity. Anyway, from our point of view, below code follows the required
883     //  algorithm to choose a reserve, it has been tested, reviewed and found to be clear enough.
884     //@dev this function always src or dest are ether. can't do token to token
885     function searchBestRate(ERC20 src, ERC20 dest, uint srcAmount) public view returns(address, uint) {
886         uint bestRate = 0;
887         uint bestReserve = 0;
888         uint numRelevantReserves = 0;
889 
890         //return 1 for ether to ether
891         if (src == dest) return (reserves[bestReserve], PRECISION);
892 
893         address[] memory reserveArr;
894 
895         if (src == ETH_TOKEN_ADDRESS) {
896             reserveArr = reservesPerTokenDest[dest];
897         } else {
898             reserveArr = reservesPerTokenSrc[src];
899         }
900 
901         if (reserveArr.length == 0) return (reserves[bestReserve], bestRate);
902 
903         uint[] memory rates = new uint[](reserveArr.length);
904         uint[] memory reserveCandidates = new uint[](reserveArr.length);
905 
906         for (uint i = 0; i < reserveArr.length; i++) {
907             //list all reserves that have this token.
908             rates[i] = (KyberReserveInterface(reserveArr[i])).getConversionRate(src, dest, srcAmount, block.number);
909 
910             if (rates[i] > bestRate) {
911                 //best rate is highest rate
912                 bestRate = rates[i];
913             }
914         }
915 
916         if (bestRate > 0) {
917             uint random = 0;
918             uint smallestRelevantRate = (bestRate * 10000) / (10000 + negligibleRateDiff);
919 
920             for (i = 0; i < reserveArr.length; i++) {
921                 if (rates[i] >= smallestRelevantRate) {
922                     reserveCandidates[numRelevantReserves++] = i;
923                 }
924             }
925 
926             if (numRelevantReserves > 1) {
927                 //when encountering small rate diff from bestRate. draw from relevant reserves
928                 random = uint(block.blockhash(block.number-1)) % numRelevantReserves;
929             }
930 
931             bestReserve = reserveCandidates[random];
932             bestRate = rates[bestReserve];
933         }
934 
935         return (reserveArr[bestReserve], bestRate);
936     }
937     /* solhint-enable code-complexity */
938 
939     function findBestRateTokenToToken(ERC20 src, ERC20 dest, uint srcAmount) internal view
940         returns(BestRateResult result)
941     {
942         (result.reserve1, result.rateSrcToEth) = searchBestRate(src, ETH_TOKEN_ADDRESS, srcAmount);
943         result.weiAmount = calcDestAmount(src, ETH_TOKEN_ADDRESS, srcAmount, result.rateSrcToEth);
944 
945         (result.reserve2, result.rateEthToDest) = searchBestRate(ETH_TOKEN_ADDRESS, dest, result.weiAmount);
946         result.destAmount = calcDestAmount(ETH_TOKEN_ADDRESS, dest, result.weiAmount, result.rateEthToDest);
947 
948         result.rate = calcRateFromQty(srcAmount, result.destAmount, getDecimals(src), getDecimals(dest));
949     }
950 
951     function listPairs(address reserve, ERC20 token, bool isTokenToEth, bool add) internal {
952         uint i;
953         address[] storage reserveArr = reservesPerTokenDest[token];
954 
955         if (isTokenToEth) {
956             reserveArr = reservesPerTokenSrc[token];
957         }
958 
959         for (i = 0; i < reserveArr.length; i++) {
960             if (reserve == reserveArr[i]) {
961                 if (add) {
962                     break; //already added
963                 } else {
964                     //remove
965                     reserveArr[i] = reserveArr[reserveArr.length - 1];
966                     reserveArr.length--;
967                 }
968             }
969         }
970 
971         if (add && i == reserveArr.length) {
972             //if reserve wasn't found add it
973             reserveArr.push(reserve);
974         }
975     }
976 
977     event KyberTrade(address srcAddress, ERC20 srcToken, uint srcAmount, address destAddress, ERC20 destToken,
978         uint destAmount);
979     /* solhint-disable function-max-lines */
980     // Most of the lins here are functions calls spread over multiple lines. We find this function readable enough
981     //  and keep its size as is.
982     /// @notice use token address ETH_TOKEN_ADDRESS for ether
983     /// @dev trade api for kyber network.
984     /// @param tradeInput structure of trade inputs
985     function trade(TradeInput tradeInput) internal returns(uint) {
986         require(isEnabled);
987         require(tx.gasprice <= maxGasPriceValue);
988         require(validateTradeInput(tradeInput.src, tradeInput.srcAmount, tradeInput.dest, tradeInput.destAddress));
989 
990         BestRateResult memory rateResult =
991         findBestRateTokenToToken(tradeInput.src, tradeInput.dest, tradeInput.srcAmount);
992 
993         require(rateResult.rate > 0);
994         require(rateResult.rate < MAX_RATE);
995         require(rateResult.rate >= tradeInput.minConversionRate);
996 
997         uint actualDestAmount;
998         uint weiAmount;
999         uint actualSrcAmount;
1000 
1001         (actualSrcAmount, weiAmount, actualDestAmount) = calcActualAmounts(tradeInput.src,
1002             tradeInput.dest,
1003             tradeInput.srcAmount,
1004             tradeInput.maxDestAmount,
1005             rateResult);
1006 
1007         if (actualSrcAmount < tradeInput.srcAmount) {
1008             //if there is "change" send back to trader
1009             if (tradeInput.src == ETH_TOKEN_ADDRESS) {
1010                 tradeInput.trader.transfer(tradeInput.srcAmount - actualSrcAmount);
1011             } else {
1012                 tradeInput.src.transfer(tradeInput.trader, (tradeInput.srcAmount - actualSrcAmount));
1013             }
1014         }
1015 
1016         // verify trade size is smaller than user cap
1017         require(weiAmount <= getUserCapInWei(tradeInput.trader));
1018 
1019         //do the trade
1020         //src to ETH
1021         require(doReserveTrade(
1022                 tradeInput.src,
1023                 actualSrcAmount,
1024                 ETH_TOKEN_ADDRESS,
1025                 this,
1026                 weiAmount,
1027                 KyberReserveInterface(rateResult.reserve1),
1028                 rateResult.rateSrcToEth,
1029                 true));
1030 
1031         //Eth to dest
1032         require(doReserveTrade(
1033                 ETH_TOKEN_ADDRESS,
1034                 weiAmount,
1035                 tradeInput.dest,
1036                 tradeInput.destAddress,
1037                 actualDestAmount,
1038                 KyberReserveInterface(rateResult.reserve2),
1039                 rateResult.rateEthToDest,
1040                 true));
1041 
1042         //when src is ether, reserve1 is doing a "fake" trade. (ether to ether) - don't burn.
1043         //when dest is ether, reserve2 is doing a "fake" trade. (ether to ether) - don't burn.
1044         if (tradeInput.src != ETH_TOKEN_ADDRESS)
1045             require(feeBurnerContract.handleFees(weiAmount, rateResult.reserve1, tradeInput.walletId));
1046         if (tradeInput.dest != ETH_TOKEN_ADDRESS)
1047             require(feeBurnerContract.handleFees(weiAmount, rateResult.reserve2, tradeInput.walletId));
1048 
1049         KyberTrade(tradeInput.trader, tradeInput.src, actualSrcAmount, tradeInput.destAddress, tradeInput.dest,
1050             actualDestAmount);
1051 
1052         return actualDestAmount;
1053     }
1054     /* solhint-enable function-max-lines */
1055 
1056     function calcActualAmounts (ERC20 src, ERC20 dest, uint srcAmount, uint maxDestAmount, BestRateResult rateResult)
1057         internal view returns(uint actualSrcAmount, uint weiAmount, uint actualDestAmount)
1058     {
1059         if (rateResult.destAmount > maxDestAmount) {
1060             actualDestAmount = maxDestAmount;
1061             weiAmount = calcSrcAmount(ETH_TOKEN_ADDRESS, dest, actualDestAmount, rateResult.rateEthToDest);
1062             actualSrcAmount = calcSrcAmount(src, ETH_TOKEN_ADDRESS, weiAmount, rateResult.rateSrcToEth);
1063             require(actualSrcAmount <= srcAmount);
1064         } else {
1065             actualDestAmount = rateResult.destAmount;
1066             actualSrcAmount = srcAmount;
1067             weiAmount = rateResult.weiAmount;
1068         }
1069     }
1070 
1071     /// @notice use token address ETH_TOKEN_ADDRESS for ether
1072     /// @dev do one trade with a reserve
1073     /// @param src Src token
1074     /// @param amount amount of src tokens
1075     /// @param dest   Destination token
1076     /// @param destAddress Address to send tokens to
1077     /// @param reserve Reserve to use
1078     /// @param validate If true, additional validations are applicable
1079     /// @return true if trade is successful
1080     function doReserveTrade(
1081         ERC20 src,
1082         uint amount,
1083         ERC20 dest,
1084         address destAddress,
1085         uint expectedDestAmount,
1086         KyberReserveInterface reserve,
1087         uint conversionRate,
1088         bool validate
1089     )
1090         internal
1091         returns(bool)
1092     {
1093         uint callValue = 0;
1094 
1095         if (src == dest) {
1096             //this is for a "fake" trade when both src and dest are ethers.
1097             if (destAddress != (address(this)))
1098                 destAddress.transfer(amount);
1099             return true;
1100         }
1101 
1102         if (src == ETH_TOKEN_ADDRESS) {
1103             callValue = amount;
1104         }
1105 
1106         // reserve sends tokens/eth to network. network sends it to destination
1107         require(reserve.trade.value(callValue)(src, amount, dest, this, conversionRate, validate));
1108 
1109         if (destAddress != address(this)) {
1110             //for token to token dest address is network. and Ether / token already here...
1111             if (dest == ETH_TOKEN_ADDRESS) {
1112                 destAddress.transfer(expectedDestAmount);
1113             } else {
1114                 require(dest.transfer(destAddress, expectedDestAmount));
1115             }
1116         }
1117 
1118         return true;
1119     }
1120 
1121     /// @notice use token address ETH_TOKEN_ADDRESS for ether
1122     /// @dev checks that user sent ether/tokens to contract before trade
1123     /// @param src Src token
1124     /// @param srcAmount amount of src tokens
1125     /// @return true if tradeInput is valid
1126     function validateTradeInput(ERC20 src, uint srcAmount, ERC20 dest, address destAddress)
1127         internal
1128         view
1129         returns(bool)
1130     {
1131         require(srcAmount <= MAX_QTY);
1132         require(srcAmount != 0);
1133         require(destAddress != address(0));
1134         require(src != dest);
1135 
1136         if (src == ETH_TOKEN_ADDRESS) {
1137             require(msg.value == srcAmount);
1138         } else {
1139             require(msg.value == 0);
1140             //funds should have been moved to this contract already.
1141             require(src.balanceOf(this) >= srcAmount);
1142         }
1143 
1144         return true;
1145     }
1146 }
1147 
1148 // File: contracts/interfaces/Token.sol
1149 
1150 contract Token {
1151     function transfer(address _to, uint _value) public returns (bool success);
1152     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
1153     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
1154     function approve(address _spender, uint256 _value) public returns (bool success);
1155     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
1156     function balanceOf(address _owner) public view returns (uint256 balance);
1157 }
1158 
1159 // File: contracts/interfaces/TokenConverter.sol
1160 
1161 contract TokenConverter {
1162     address public constant ETH_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
1163     function getReturn(Token _fromToken, Token _toToken, uint256 _fromAmount) external view returns (uint256 amount);
1164     function convert(Token _fromToken, Token _toToken, uint256 _fromAmount, uint256 _minReturn) external payable returns (uint256 amount);
1165 }
1166 
1167 // File: contracts/interfaces/AvailableProvider.sol
1168 
1169 interface AvailableProvider {
1170    function isAvailable(Token _from, Token _to, uint256 _amount) external view returns (bool);
1171 }
1172 
1173 // File: contracts/utils/Ownable.sol
1174 
1175 contract Ownable {
1176     address public owner;
1177 
1178     event SetOwner(address _owner);
1179 
1180     modifier onlyOwner() {
1181         require(msg.sender == owner, "msg.sender is not the owner");
1182         _;
1183     }
1184 
1185     constructor() public {
1186         owner = msg.sender;
1187         emit SetOwner(msg.sender);
1188     }
1189 
1190     /**
1191         @dev Transfers the ownership of the contract.
1192 
1193         @param _to Address of the new owner
1194     */
1195     function transferTo(address _to) public onlyOwner returns (bool) {
1196         require(_to != address(0), "Can't transfer to address 0x0");
1197         emit SetOwner(_to);
1198         owner = _to;
1199         return true;
1200     }
1201 }
1202 
1203 // File: contracts/KyberProxy.sol
1204 
1205 contract KyberConverter is TokenConverter, AvailableProvider, Ownable {
1206     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
1207 
1208     KyberNetworkProxy kyber;
1209 
1210     event Swap(address indexed sender, ERC20 srcToken, ERC20 destToken, uint amount);
1211 
1212     event WithdrawTokens(address _token, address _to, uint256 _amount);
1213     event WithdrawEth(address _to, uint256 _amount);
1214     event SetKyber(address _kyber);
1215 
1216     constructor (KyberNetworkProxy _kyber) public {
1217         kyber = _kyber;
1218         emit SetKyber(_kyber);
1219     }
1220 
1221     function setKyber(KyberNetworkProxy _kyber) external onlyOwner returns (bool) {
1222         kyber = _kyber;
1223         emit SetKyber(_kyber);
1224         return true;
1225     }
1226 
1227     function isAvailable(Token, Token, uint256) external view returns (bool) {
1228         KyberNetworkProxy _kyber = kyber;
1229         return tx.gasprice <= _kyber.maxGasPrice() && _kyber.enabled();
1230     }
1231 
1232     function getReturn(
1233         Token from,
1234         Token to, 
1235         uint256 srcQty
1236     ) external view returns (uint256) {
1237         ERC20 srcToken = ERC20(from);
1238         ERC20 destToken = ERC20(to);   
1239         (uint256 amount,) = kyber.getExpectedRate(srcToken, destToken, srcQty);
1240         return amount;
1241     }
1242 
1243     function convert(
1244         Token from,
1245         Token to, 
1246         uint256 srcQty, 
1247         uint256 minReturn
1248     ) external payable returns (uint256 destAmount) {
1249 
1250         ERC20 srcToken = ERC20(from);
1251         ERC20 destToken = ERC20(to);       
1252 
1253         if (srcToken == ETH_TOKEN_ADDRESS && destToken != ETH_TOKEN_ADDRESS) {
1254             require(msg.value == srcQty, "ETH not enought");
1255             destAmount = execSwapEtherToToken(destToken, srcQty, msg.sender);
1256         } else if (srcToken != ETH_TOKEN_ADDRESS && destToken == ETH_TOKEN_ADDRESS) {
1257             require(msg.value == 0, "ETH not required");    
1258             destAmount = execSwapTokenToEther(srcToken, srcQty, msg.sender);
1259         } else {
1260             require(msg.value == 0, "ETH not required");    
1261             destAmount = execSwapTokenToToken(srcToken, srcQty, destToken, msg.sender);
1262         }
1263 
1264         require(destAmount > minReturn, "Return amount too low");   
1265         emit Swap(msg.sender, srcToken, destToken, destAmount);
1266     
1267         return destAmount;
1268     }
1269 
1270     /*
1271     @dev Swap the user's ETH to ERC20 token
1272     @param token destination token contract address
1273     @param destAddress address to send swapped tokens to
1274     */
1275     function execSwapEtherToToken(
1276         ERC20 token, 
1277         uint srcQty,
1278         address destAddress
1279     ) internal returns (uint) {
1280         // Swap the ETH to ERC20 token
1281         uint destAmount = kyber.swapEtherToToken.value(srcQty)(token, 0);
1282 
1283         // Send the swapped tokens to the destination address
1284         require(token.transfer(destAddress, destAmount), "Error sending tokens");
1285 
1286         return destAmount;
1287     }
1288 
1289     /*
1290     @dev Swap the user's ERC20 token to ETH
1291     @param token source token contract address
1292     @param tokenQty amount of source tokens
1293     @param destAddress address to send swapped ETH to
1294     */
1295     function execSwapTokenToEther(
1296         ERC20 token, 
1297         uint256 tokenQty, 
1298         address destAddress
1299     ) internal returns (uint) {
1300             
1301         // Check that the player has transferred the token to this contract
1302         require(token.transferFrom(msg.sender, this, tokenQty), "Error pulling tokens");
1303 
1304         // Set the spender's token allowance to tokenQty
1305         require(token.approve(kyber, tokenQty), "Error pulling tokens");
1306 
1307         // Swap the ERC20 token to ETH
1308         uint destAmount = kyber.swapTokenToEther(token, tokenQty, 0);
1309 
1310         // Send the swapped ETH to the destination address
1311         require(destAddress.send(destAmount), "Error sending ETH");
1312 
1313         return destAmount;
1314 
1315     }
1316 
1317     /*
1318     @dev Swap the user's ERC20 token to another ERC20 token
1319     @param srcToken source token contract address
1320     @param srcQty amount of source tokens
1321     @param destToken destination token contract address
1322     @param destAddress address to send swapped tokens to
1323     */
1324     function execSwapTokenToToken(
1325         ERC20 srcToken, 
1326         uint256 srcQty, 
1327         ERC20 destToken, 
1328         address destAddress
1329     ) internal returns (uint) {
1330 
1331         // Check that the player has transferred the token to this contract
1332         require(srcToken.transferFrom(msg.sender, this, srcQty), "Error pulling tokens");
1333 
1334         // Set the spender's token allowance to tokenQty
1335         require(srcToken.approve(kyber, srcQty), "Error approve transfer tokens");
1336 
1337         // Swap the ERC20 token to ERC20
1338         uint destAmount = kyber.swapTokenToToken(srcToken, srcQty, destToken, 0);
1339 
1340         // Send the swapped tokens to the destination address
1341         require(destToken.transfer(destAddress, destAmount), "Error sending tokens");
1342 
1343         return destAmount;
1344     }
1345 
1346     function withdrawTokens(
1347         Token _token,
1348         address _to,
1349         uint256 _amount
1350     ) external onlyOwner returns (bool) {
1351         emit WithdrawTokens(_token, _to, _amount);
1352         return _token.transfer(_to, _amount);
1353     }
1354 
1355     function withdrawEther(
1356         address _to,
1357         uint256 _amount
1358     ) external onlyOwner {
1359         emit WithdrawEth(_to, _amount);
1360         _to.transfer(_amount);
1361     }
1362 
1363     function setConverter(
1364         KyberNetworkProxy _converter
1365     ) public onlyOwner returns (bool) {
1366         kyber = _converter;
1367     }
1368 
1369     function getConverter() public view returns (address) {
1370         return address(kyber);
1371     }
1372 
1373     function() external payable {}
1374 }