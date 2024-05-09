1 pragma solidity ^0.4.18;
2 
3 contract Utils {
4 
5     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
6     uint  constant internal PRECISION = (10**18);
7     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
8     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
9     uint  constant internal MAX_DECIMALS = 18;
10     uint  constant internal ETH_DECIMALS = 18;
11     mapping(address=>uint) internal decimals;
12 
13     function setDecimals(ERC20 token) internal {
14         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
15         else decimals[token] = token.decimals();
16     }
17 
18     function getDecimals(ERC20 token) internal view returns(uint) {
19         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
20         uint tokenDecimals = decimals[token];
21         // technically, there might be token with decimals 0
22         // moreover, very possible that old tokens have decimals 0
23         // these tokens will just have higher gas fees.
24         if(tokenDecimals == 0) return token.decimals();
25 
26         return tokenDecimals;
27     }
28 
29     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
30         require(srcQty <= MAX_QTY);
31         require(rate <= MAX_RATE);
32 
33         if (dstDecimals >= srcDecimals) {
34             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
35             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
36         } else {
37             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
38             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
39         }
40     }
41 
42     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
43         require(dstQty <= MAX_QTY);
44         require(rate <= MAX_RATE);
45 
46         //source quantity is rounded up. to avoid dest quantity being too low.
47         uint numerator;
48         uint denominator;
49         if (srcDecimals >= dstDecimals) {
50             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
51             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
52             denominator = rate;
53         } else {
54             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
55             numerator = (PRECISION * dstQty);
56             denominator = (rate * (10**(dstDecimals - srcDecimals)));
57         }
58         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
59     }
60 }
61 
62 interface FeeBurnerInterface {
63     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
64 }
65 
66 interface KyberReserveInterface {
67 
68     function trade(
69         ERC20 srcToken,
70         uint srcAmount,
71         ERC20 destToken,
72         address destAddress,
73         uint conversionRate,
74         bool validate
75     )
76         public
77         payable
78         returns(bool);
79 
80     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
81 }
82 
83 interface ERC20 {
84     function totalSupply() public view returns (uint supply);
85     function balanceOf(address _owner) public view returns (uint balance);
86     function transfer(address _to, uint _value) public returns (bool success);
87     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
88     function approve(address _spender, uint _value) public returns (bool success);
89     function allowance(address _owner, address _spender) public view returns (uint remaining);
90     function decimals() public view returns(uint digits);
91     event Approval(address indexed _owner, address indexed _spender, uint _value);
92 }
93 
94 interface ExpectedRateInterface {
95     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
96         returns (uint expectedRate, uint slippageRate);
97 }
98 
99 contract PermissionGroups {
100 
101     address public admin;
102     address public pendingAdmin;
103     mapping(address=>bool) internal operators;
104     mapping(address=>bool) internal alerters;
105     address[] internal operatorsGroup;
106     address[] internal alertersGroup;
107     uint constant internal MAX_GROUP_SIZE = 50;
108 
109     function PermissionGroups() public {
110         admin = msg.sender;
111     }
112 
113     modifier onlyAdmin() {
114         require(msg.sender == admin);
115         _;
116     }
117 
118     modifier onlyOperator() {
119         require(operators[msg.sender]);
120         _;
121     }
122 
123     modifier onlyAlerter() {
124         require(alerters[msg.sender]);
125         _;
126     }
127 
128     function getOperators () external view returns(address[]) {
129         return operatorsGroup;
130     }
131 
132     function getAlerters () external view returns(address[]) {
133         return alertersGroup;
134     }
135 
136     event TransferAdminPending(address pendingAdmin);
137 
138     /**
139      * @dev Allows the current admin to set the pendingAdmin address.
140      * @param newAdmin The address to transfer ownership to.
141      */
142     function transferAdmin(address newAdmin) public onlyAdmin {
143         require(newAdmin != address(0));
144         TransferAdminPending(pendingAdmin);
145         pendingAdmin = newAdmin;
146     }
147 
148     /**
149      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
150      * @param newAdmin The address to transfer ownership to.
151      */
152     function transferAdminQuickly(address newAdmin) public onlyAdmin {
153         require(newAdmin != address(0));
154         TransferAdminPending(newAdmin);
155         AdminClaimed(newAdmin, admin);
156         admin = newAdmin;
157     }
158 
159     event AdminClaimed( address newAdmin, address previousAdmin);
160 
161     /**
162      * @dev Allows the pendingAdmin address to finalize the change admin process.
163      */
164     function claimAdmin() public {
165         require(pendingAdmin == msg.sender);
166         AdminClaimed(pendingAdmin, admin);
167         admin = pendingAdmin;
168         pendingAdmin = address(0);
169     }
170 
171     event AlerterAdded (address newAlerter, bool isAdd);
172 
173     function addAlerter(address newAlerter) public onlyAdmin {
174         require(!alerters[newAlerter]); // prevent duplicates.
175         require(alertersGroup.length < MAX_GROUP_SIZE);
176 
177         AlerterAdded(newAlerter, true);
178         alerters[newAlerter] = true;
179         alertersGroup.push(newAlerter);
180     }
181 
182     function removeAlerter (address alerter) public onlyAdmin {
183         require(alerters[alerter]);
184         alerters[alerter] = false;
185 
186         for (uint i = 0; i < alertersGroup.length; ++i) {
187             if (alertersGroup[i] == alerter) {
188                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
189                 alertersGroup.length--;
190                 AlerterAdded(alerter, false);
191                 break;
192             }
193         }
194     }
195 
196     event OperatorAdded(address newOperator, bool isAdd);
197 
198     function addOperator(address newOperator) public onlyAdmin {
199         require(!operators[newOperator]); // prevent duplicates.
200         require(operatorsGroup.length < MAX_GROUP_SIZE);
201 
202         OperatorAdded(newOperator, true);
203         operators[newOperator] = true;
204         operatorsGroup.push(newOperator);
205     }
206 
207     function removeOperator (address operator) public onlyAdmin {
208         require(operators[operator]);
209         operators[operator] = false;
210 
211         for (uint i = 0; i < operatorsGroup.length; ++i) {
212             if (operatorsGroup[i] == operator) {
213                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
214                 operatorsGroup.length -= 1;
215                 OperatorAdded(operator, false);
216                 break;
217             }
218         }
219     }
220 }
221 
222 contract WhiteListInterface {
223     function getUserCapInWei(address user) external view returns (uint userCapWei);
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
641 
642 /// @title Contract for a burnable ERC
643 /// @dev From https://github.com/KyberNetwork/smart-contracts/blob/master/contracts/ERC20Interface.sol
644 /// @dev Added burn function
645 interface BurnableErc20 {
646     function totalSupply() public view returns (uint supply);
647     function balanceOf(address _owner) public view returns (uint balance);
648     function transfer(address _to, uint _value) public returns (bool success);
649     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
650     function approve(address _spender, uint _value) public returns (bool success);
651     function allowance(address _owner, address _spender) public view returns (uint remaining);
652     function decimals() public view returns(uint digits);
653     event Approval(address indexed _owner, address indexed _spender, uint _value);
654 
655     function burn(uint _value) public;
656 }
657 
658 
659 /// @title A contract to burn ERC20 tokens from ETH on the contract
660 /// @notice Sends the ETH on the contract to kyber for conversion to ERC20
661 ///  The converted ERC20 is then burned
662 /// @dev Used to burn the REQ fees. Request fees are paid in ETH. The ETH is sent by the 
663 ///  currency contracts to this burn contract. When the burn contract is called, it converts
664 ///  the ETH to REQ and burn the REQ
665 /// @author Request Network
666 contract Burner {
667     /// Kyber contract that will be used for the conversion
668     KyberNetwork public kyberContract;
669 
670     // Contract for the ERC20
671     BurnableErc20 public destErc20;
672 
673     /// @param _destErc20 Destination token
674     /// @param _kyberContract Kyber contract to use
675     function Burner(address _destErc20, address _kyberContract) public {
676         // Check inputs
677         require(_destErc20 != address(0));
678         require(_kyberContract != address(0));
679 
680         destErc20 = BurnableErc20(_destErc20);
681         kyberContract = KyberNetwork(_kyberContract);
682     }
683     
684     /// Fallback function to receive the ETH to burn later
685     function() public payable { }
686 
687     /// @dev Main function. Trade the ETH for ERC20 and burn them
688     /// @param maxSrcAmount Maximum amount of ETH to convert. If set to 0, all ETH on the
689     ///  contract will be burned
690     /// @param maxDestAmount A limit on the amount of converted ERC20 tokens. Default value is MAX_UINT
691     /// @param minConversionRate The minimal conversion rate. Default value is 1 (market rate)
692     /// @return amount of dest ERC20 tokens burned
693     function burn(uint maxSrcAmount, uint maxDestAmount, uint minConversionRate)
694         public
695         returns(uint)
696     {
697         // ETH to convert on Kyber, by default the amount of ETH on the contract
698         // If maxSrcAmount is defined, ethToConvert = min(balance on contract, maxSrcAmount)
699         uint ethToConvert = this.balance;
700         if (maxSrcAmount != 0 && maxSrcAmount < ethToConvert) {
701             ethToConvert = maxSrcAmount;
702         }
703 
704         // Set maxDestAmount to MAX_UINT if not sent as parameter
705         if (maxDestAmount == 0) {
706             maxDestAmount = 2**256 - 1;
707         }
708 
709         // Set minConversionRate to 1 if not sent as parameter
710         // A value of 1 will execute the trade according to market price in the time of the transaction confirmation
711         if (minConversionRate == 0) {
712             minConversionRate = 1;
713         }
714 
715         // Convert the ETH to ERC20
716         // erc20ToBurn is the amount of the ERC20 tokens converted by Kyber that will be burned
717         uint erc20ToBurn = kyberContract.trade.value(ethToConvert)(
718             // Source. From Kyber docs, this value denotes ETH
719             ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee),
720             
721             // Source amount
722             ethToConvert,
723 
724             // Destination. Downcast BurnableErc20 to ERC20
725             ERC20(destErc20),
726             
727             // destAddress: this contract
728             this,
729             
730             // maxDestAmount
731             maxDestAmount,
732             
733             // minConversionRate 
734             minConversionRate,
735             
736             // walletId
737             0
738         );
739 
740         // Burn the converted ERC20 tokens
741         destErc20.burn(erc20ToBurn);
742 
743         return erc20ToBurn;
744     }
745 }