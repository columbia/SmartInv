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
17 // File: contracts/ExpectedRateInterface.sol
18 
19 interface ExpectedRateInterface {
20     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty, bool usePermissionless) public view
21         returns (uint expectedRate, uint slippageRate);
22 }
23 
24 // File: contracts/FeeBurnerInterface.sol
25 
26 interface FeeBurnerInterface {
27     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
28     function setReserveData(address reserve, uint feesInBps, address kncWallet) public;
29 }
30 
31 // File: contracts/KyberNetworkInterface.sol
32 
33 /// @title Kyber Network interface
34 interface KyberNetworkInterface {
35     function maxGasPrice() public view returns(uint);
36     function getUserCapInWei(address user) public view returns(uint);
37     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint);
38     function enabled() public view returns(bool);
39     function info(bytes32 id) public view returns(uint);
40 
41     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
42         returns (uint expectedRate, uint slippageRate);
43 
44     function tradeWithHint(address trader, ERC20 src, uint srcAmount, ERC20 dest, address destAddress,
45         uint maxDestAmount, uint minConversionRate, address walletId, bytes hint) public payable returns(uint);
46 }
47 
48 // File: contracts/KyberReserveInterface.sol
49 
50 /// @title Kyber Reserve contract
51 interface KyberReserveInterface {
52 
53     function trade(
54         ERC20 srcToken,
55         uint srcAmount,
56         ERC20 destToken,
57         address destAddress,
58         uint conversionRate,
59         bool validate
60     )
61         public
62         payable
63         returns(bool);
64 
65     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
66 }
67 
68 // File: contracts/Utils.sol
69 
70 /// @title Kyber constants contract
71 contract Utils {
72 
73     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
74     uint  constant internal PRECISION = (10**18);
75     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
76     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
77     uint  constant internal MAX_DECIMALS = 18;
78     uint  constant internal ETH_DECIMALS = 18;
79     mapping(address=>uint) internal decimals;
80 
81     function setDecimals(ERC20 token) internal {
82         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
83         else decimals[token] = token.decimals();
84     }
85 
86     function getDecimals(ERC20 token) internal view returns(uint) {
87         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
88         uint tokenDecimals = decimals[token];
89         // technically, there might be token with decimals 0
90         // moreover, very possible that old tokens have decimals 0
91         // these tokens will just have higher gas fees.
92         if(tokenDecimals == 0) return token.decimals();
93 
94         return tokenDecimals;
95     }
96 
97     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
98         require(srcQty <= MAX_QTY);
99         require(rate <= MAX_RATE);
100 
101         if (dstDecimals >= srcDecimals) {
102             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
103             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
104         } else {
105             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
106             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
107         }
108     }
109 
110     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
111         require(dstQty <= MAX_QTY);
112         require(rate <= MAX_RATE);
113         
114         //source quantity is rounded up. to avoid dest quantity being too low.
115         uint numerator;
116         uint denominator;
117         if (srcDecimals >= dstDecimals) {
118             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
119             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
120             denominator = rate;
121         } else {
122             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
123             numerator = (PRECISION * dstQty);
124             denominator = (rate * (10**(dstDecimals - srcDecimals)));
125         }
126         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
127     }
128 }
129 
130 // File: contracts/Utils2.sol
131 
132 contract Utils2 is Utils {
133 
134     /// @dev get the balance of a user.
135     /// @param token The token type
136     /// @return The balance
137     function getBalance(ERC20 token, address user) public view returns(uint) {
138         if (token == ETH_TOKEN_ADDRESS)
139             return user.balance;
140         else
141             return token.balanceOf(user);
142     }
143 
144     function getDecimalsSafe(ERC20 token) internal returns(uint) {
145 
146         if (decimals[token] == 0) {
147             setDecimals(token);
148         }
149 
150         return decimals[token];
151     }
152 
153     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
154         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
155     }
156 
157     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
158         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
159     }
160 
161     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
162         internal pure returns(uint)
163     {
164         require(srcAmount <= MAX_QTY);
165         require(destAmount <= MAX_QTY);
166 
167         if (dstDecimals >= srcDecimals) {
168             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
169             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
170         } else {
171             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
172             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
173         }
174     }
175 }
176 
177 // File: contracts/WhiteListInterface.sol
178 
179 contract WhiteListInterface {
180     function getUserCapInWei(address user) external view returns (uint userCapWei);
181 }
182 
183 // File: contracts/PermissionGroups.sol
184 
185 contract PermissionGroups {
186 
187     address public admin;
188     address public pendingAdmin;
189     mapping(address=>bool) internal operators;
190     mapping(address=>bool) internal alerters;
191     address[] internal operatorsGroup;
192     address[] internal alertersGroup;
193     uint constant internal MAX_GROUP_SIZE = 50;
194 
195     function PermissionGroups() public {
196         admin = msg.sender;
197     }
198 
199     modifier onlyAdmin() {
200         require(msg.sender == admin);
201         _;
202     }
203 
204     modifier onlyOperator() {
205         require(operators[msg.sender]);
206         _;
207     }
208 
209     modifier onlyAlerter() {
210         require(alerters[msg.sender]);
211         _;
212     }
213 
214     function getOperators () external view returns(address[]) {
215         return operatorsGroup;
216     }
217 
218     function getAlerters () external view returns(address[]) {
219         return alertersGroup;
220     }
221 
222     event TransferAdminPending(address pendingAdmin);
223 
224     /**
225      * @dev Allows the current admin to set the pendingAdmin address.
226      * @param newAdmin The address to transfer ownership to.
227      */
228     function transferAdmin(address newAdmin) public onlyAdmin {
229         require(newAdmin != address(0));
230         TransferAdminPending(pendingAdmin);
231         pendingAdmin = newAdmin;
232     }
233 
234     /**
235      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
236      * @param newAdmin The address to transfer ownership to.
237      */
238     function transferAdminQuickly(address newAdmin) public onlyAdmin {
239         require(newAdmin != address(0));
240         TransferAdminPending(newAdmin);
241         AdminClaimed(newAdmin, admin);
242         admin = newAdmin;
243     }
244 
245     event AdminClaimed( address newAdmin, address previousAdmin);
246 
247     /**
248      * @dev Allows the pendingAdmin address to finalize the change admin process.
249      */
250     function claimAdmin() public {
251         require(pendingAdmin == msg.sender);
252         AdminClaimed(pendingAdmin, admin);
253         admin = pendingAdmin;
254         pendingAdmin = address(0);
255     }
256 
257     event AlerterAdded (address newAlerter, bool isAdd);
258 
259     function addAlerter(address newAlerter) public onlyAdmin {
260         require(!alerters[newAlerter]); // prevent duplicates.
261         require(alertersGroup.length < MAX_GROUP_SIZE);
262 
263         AlerterAdded(newAlerter, true);
264         alerters[newAlerter] = true;
265         alertersGroup.push(newAlerter);
266     }
267 
268     function removeAlerter (address alerter) public onlyAdmin {
269         require(alerters[alerter]);
270         alerters[alerter] = false;
271 
272         for (uint i = 0; i < alertersGroup.length; ++i) {
273             if (alertersGroup[i] == alerter) {
274                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
275                 alertersGroup.length--;
276                 AlerterAdded(alerter, false);
277                 break;
278             }
279         }
280     }
281 
282     event OperatorAdded(address newOperator, bool isAdd);
283 
284     function addOperator(address newOperator) public onlyAdmin {
285         require(!operators[newOperator]); // prevent duplicates.
286         require(operatorsGroup.length < MAX_GROUP_SIZE);
287 
288         OperatorAdded(newOperator, true);
289         operators[newOperator] = true;
290         operatorsGroup.push(newOperator);
291     }
292 
293     function removeOperator (address operator) public onlyAdmin {
294         require(operators[operator]);
295         operators[operator] = false;
296 
297         for (uint i = 0; i < operatorsGroup.length; ++i) {
298             if (operatorsGroup[i] == operator) {
299                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
300                 operatorsGroup.length -= 1;
301                 OperatorAdded(operator, false);
302                 break;
303             }
304         }
305     }
306 }
307 
308 // File: contracts/Withdrawable.sol
309 
310 /**
311  * @title Contracts that should be able to recover tokens or ethers
312  * @author Ilan Doron
313  * @dev This allows to recover any tokens or Ethers received in a contract.
314  * This will prevent any accidental loss of tokens.
315  */
316 contract Withdrawable is PermissionGroups {
317 
318     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
319 
320     /**
321      * @dev Withdraw all ERC20 compatible tokens
322      * @param token ERC20 The address of the token contract
323      */
324     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
325         require(token.transfer(sendTo, amount));
326         TokenWithdraw(token, amount, sendTo);
327     }
328 
329     event EtherWithdraw(uint amount, address sendTo);
330 
331     /**
332      * @dev Withdraw Ethers
333      */
334     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
335         sendTo.transfer(amount);
336         EtherWithdraw(amount, sendTo);
337     }
338 }
339 
340 // File: contracts/KyberNetwork.sol
341 
342 /**
343  * @title Helps contracts guard against reentrancy attacks.
344  */
345 contract ReentrancyGuard {
346 
347     /// @dev counter to allow mutex lock with only one SSTORE operation
348     uint256 private guardCounter = 1;
349 
350     /**
351      * @dev Prevents a function from calling itself, directly or indirectly.
352      * Calling one `nonReentrant` function from
353      * another is not supported. Instead, you can implement a
354      * `private` function doing the actual work, and an `external`
355      * wrapper marked as `nonReentrant`.
356      */
357     modifier nonReentrant() {
358         guardCounter += 1;
359         uint256 localCounter = guardCounter;
360         _;
361         require(localCounter == guardCounter);
362     }
363 }
364 
365 
366 ////////////////////////////////////////////////////////////////////////////////////////////////////////
367 /// @title Kyber Network main contract
368 contract KyberNetwork is Withdrawable, Utils2, KyberNetworkInterface, ReentrancyGuard {
369 
370     bytes public constant PERM_HINT = "PERM";
371     uint  public constant PERM_HINT_GET_RATE = 1 << 255; // for get rate. bit mask hint.
372 
373     uint public negligibleRateDiff = 10; // basic rate steps will be in 0.01%
374     KyberReserveInterface[] public reserves;
375     mapping(address=>ReserveType) public reserveType;
376     WhiteListInterface public whiteListContract;
377     ExpectedRateInterface public expectedRateContract;
378     FeeBurnerInterface    public feeBurnerContract;
379     address               public kyberNetworkProxyContract;
380     uint                  public maxGasPriceValue = 50 * 1000 * 1000 * 1000; // 50 gwei
381     bool                  public isEnabled = false; // network is enabled
382     mapping(bytes32=>uint) public infoFields; // this is only a UI field for external app.
383 
384     mapping(address=>address[]) public reservesPerTokenSrc; //reserves supporting token to eth
385     mapping(address=>address[]) public reservesPerTokenDest;//reserves support eth to token
386 
387     enum ReserveType {NONE, PERMISSIONED, PERMISSIONLESS}
388     bytes internal constant EMPTY_HINT = "";
389 
390     function KyberNetwork(address _admin) public {
391         require(_admin != address(0));
392         admin = _admin;
393     }
394 
395     event EtherReceival(address indexed sender, uint amount);
396 
397     /* solhint-disable no-complex-fallback */
398     // To avoid users trying to swap tokens using default payable function. We added this short code
399     //  to verify Ethers will be received only from reserves if transferred without a specific function call.
400     function() public payable {
401         require(reserveType[msg.sender] != ReserveType.NONE);
402         EtherReceival(msg.sender, msg.value);
403     }
404     /* solhint-enable no-complex-fallback */
405 
406     struct TradeInput {
407         address trader;
408         ERC20 src;
409         uint srcAmount;
410         ERC20 dest;
411         address destAddress;
412         uint maxDestAmount;
413         uint minConversionRate;
414         address walletId;
415         bytes hint;
416     }
417 
418     function tradeWithHint(
419         address trader,
420         ERC20 src,
421         uint srcAmount,
422         ERC20 dest,
423         address destAddress,
424         uint maxDestAmount,
425         uint minConversionRate,
426         address walletId,
427         bytes hint
428     )
429         public
430         nonReentrant
431         payable
432         returns(uint)
433     {
434         require(msg.sender == kyberNetworkProxyContract);
435         require((hint.length == 0) || (hint.length == 4));
436 
437         TradeInput memory tradeInput;
438 
439         tradeInput.trader = trader;
440         tradeInput.src = src;
441         tradeInput.srcAmount = srcAmount;
442         tradeInput.dest = dest;
443         tradeInput.destAddress = destAddress;
444         tradeInput.maxDestAmount = maxDestAmount;
445         tradeInput.minConversionRate = minConversionRate;
446         tradeInput.walletId = walletId;
447         tradeInput.hint = hint;
448 
449         return trade(tradeInput);
450     }
451 
452     event AddReserveToNetwork(KyberReserveInterface indexed reserve, bool add, bool isPermissionless);
453 
454     /// @notice can be called only by operator
455     /// @dev add or deletes a reserve to/from the network.
456     /// @param reserve The reserve address.
457     /// @param isPermissionless is the new reserve from permissionless type.
458     function addReserve(KyberReserveInterface reserve, bool isPermissionless) public onlyOperator
459         returns(bool)
460     {
461         require(reserveType[reserve] == ReserveType.NONE);
462         reserves.push(reserve);
463 
464         reserveType[reserve] = isPermissionless ? ReserveType.PERMISSIONLESS : ReserveType.PERMISSIONED;
465 
466         AddReserveToNetwork(reserve, true, isPermissionless);
467 
468         return true;
469     }
470 
471     event RemoveReserveFromNetwork(KyberReserveInterface reserve);
472 
473     /// @notice can be called only by operator
474     /// @dev removes a reserve from Kyber network.
475     /// @param reserve The reserve address.
476     /// @param index in reserve array.
477     function removeReserve(KyberReserveInterface reserve, uint index) public onlyOperator
478         returns(bool)
479     {
480 
481         require(reserveType[reserve] != ReserveType.NONE);
482         require(reserves[index] == reserve);
483 
484         reserveType[reserve] = ReserveType.NONE;
485         reserves[index] = reserves[reserves.length - 1];
486         reserves.length--;
487 
488         RemoveReserveFromNetwork(reserve);
489 
490         return true;
491     }
492 
493     event ListReservePairs(address indexed reserve, ERC20 src, ERC20 dest, bool add);
494 
495     /// @notice can be called only by operator
496     /// @dev allow or prevent a specific reserve to trade a pair of tokens
497     /// @param reserve The reserve address.
498     /// @param token token address
499     /// @param ethToToken will it support ether to token trade
500     /// @param tokenToEth will it support token to ether trade
501     /// @param add If true then list this pair, otherwise unlist it.
502     function listPairForReserve(address reserve, ERC20 token, bool ethToToken, bool tokenToEth, bool add)
503         public
504         onlyOperator
505         returns(bool)
506     {
507         require(reserveType[reserve] != ReserveType.NONE);
508 
509         if (ethToToken) {
510             listPairs(reserve, token, false, add);
511 
512             ListReservePairs(reserve, ETH_TOKEN_ADDRESS, token, add);
513         }
514 
515         if (tokenToEth) {
516             listPairs(reserve, token, true, add);
517 
518             if (add) {
519                 require(token.approve(reserve, 2**255)); // approve infinity
520             } else {
521                 require(token.approve(reserve, 0));
522             }
523 
524             ListReservePairs(reserve, token, ETH_TOKEN_ADDRESS, add);
525         }
526 
527         setDecimals(token);
528 
529         return true;
530     }
531 
532     event WhiteListContractSet(WhiteListInterface newContract, WhiteListInterface currentContract);
533 
534     ///@param whiteList can be empty
535     function setWhiteList(WhiteListInterface whiteList) public onlyAdmin {
536         WhiteListContractSet(whiteList, whiteListContract);
537         whiteListContract = whiteList;
538     }
539 
540     event ExpectedRateContractSet(ExpectedRateInterface newContract, ExpectedRateInterface currentContract);
541 
542     function setExpectedRate(ExpectedRateInterface expectedRate) public onlyAdmin {
543         require(expectedRate != address(0));
544 
545         ExpectedRateContractSet(expectedRate, expectedRateContract);
546         expectedRateContract = expectedRate;
547     }
548 
549     event FeeBurnerContractSet(FeeBurnerInterface newContract, FeeBurnerInterface currentContract);
550 
551     function setFeeBurner(FeeBurnerInterface feeBurner) public onlyAdmin {
552         require(feeBurner != address(0));
553 
554         FeeBurnerContractSet(feeBurner, feeBurnerContract);
555         feeBurnerContract = feeBurner;
556     }
557 
558     event KyberNetwrokParamsSet(uint maxGasPrice, uint negligibleRateDiff);
559 
560     function setParams(
561         uint                  _maxGasPrice,
562         uint                  _negligibleRateDiff
563     )
564         public
565         onlyAdmin
566     {
567         require(_negligibleRateDiff <= 100 * 100); // at most 100%
568 
569         maxGasPriceValue = _maxGasPrice;
570         negligibleRateDiff = _negligibleRateDiff;
571         KyberNetwrokParamsSet(maxGasPriceValue, negligibleRateDiff);
572     }
573 
574     event KyberNetworkSetEnable(bool isEnabled);
575 
576     function setEnable(bool _enable) public onlyAdmin {
577         if (_enable) {
578             require(feeBurnerContract != address(0));
579             require(expectedRateContract != address(0));
580             require(kyberNetworkProxyContract != address(0));
581         }
582         isEnabled = _enable;
583 
584         KyberNetworkSetEnable(isEnabled);
585     }
586 
587     function setInfo(bytes32 field, uint value) public onlyOperator {
588         infoFields[field] = value;
589     }
590 
591     event KyberProxySet(address proxy, address sender);
592 
593     function setKyberProxy(address networkProxy) public onlyAdmin {
594         require(networkProxy != address(0));
595         kyberNetworkProxyContract = networkProxy;
596         KyberProxySet(kyberNetworkProxyContract, msg.sender);
597     }
598 
599     /// @dev returns number of reserves
600     /// @return number of reserves
601     function getNumReserves() public view returns(uint) {
602         return reserves.length;
603     }
604 
605     /// @notice should be called off chain
606     /// @dev get an array of all reserves
607     /// @return An array of all reserves
608     function getReserves() public view returns(KyberReserveInterface[]) {
609         return reserves;
610     }
611 
612     function maxGasPrice() public view returns(uint) {
613         return maxGasPriceValue;
614     }
615 
616     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
617         public view
618         returns(uint expectedRate, uint slippageRate)
619     {
620         require(expectedRateContract != address(0));
621         bool includePermissionless = true;
622 
623         if (srcQty & PERM_HINT_GET_RATE > 0) {
624             includePermissionless = false;
625             srcQty = srcQty & ~PERM_HINT_GET_RATE;
626         }
627 
628         return expectedRateContract.getExpectedRate(src, dest, srcQty, includePermissionless);
629     }
630 
631     function getExpectedRateOnlyPermission(ERC20 src, ERC20 dest, uint srcQty)
632         public view
633         returns(uint expectedRate, uint slippageRate)
634     {
635         require(expectedRateContract != address(0));
636         return expectedRateContract.getExpectedRate(src, dest, srcQty, false);
637     }
638 
639     function getUserCapInWei(address user) public view returns(uint) {
640         if (whiteListContract == address(0)) return (2 ** 255);
641         return whiteListContract.getUserCapInWei(user);
642     }
643 
644     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint) {
645         //future feature
646         user;
647         token;
648         require(false);
649     }
650 
651     struct BestRateResult {
652         uint rate;
653         address reserve1;
654         address reserve2;
655         uint weiAmount;
656         uint rateSrcToEth;
657         uint rateEthToDest;
658         uint destAmount;
659     }
660 
661     /// @notice use token address ETH_TOKEN_ADDRESS for ether
662     /// @dev best conversion rate for a pair of tokens, if number of reserves have small differences. randomize
663     /// @param src Src token
664     /// @param dest Destination token
665     /// @return obsolete - used to return best reserve index. not relevant anymore for this API.
666     function findBestRate(ERC20 src, ERC20 dest, uint srcAmount) public view returns(uint obsolete, uint rate) {
667         BestRateResult memory result = findBestRateTokenToToken(src, dest, srcAmount, EMPTY_HINT);
668         return(0, result.rate);
669     }
670 
671     function findBestRateOnlyPermission(ERC20 src, ERC20 dest, uint srcAmount)
672         public
673         view
674         returns(uint obsolete, uint rate)
675     {
676         BestRateResult memory result = findBestRateTokenToToken(src, dest, srcAmount, PERM_HINT);
677         return(0, result.rate);
678     }
679 
680     function enabled() public view returns(bool) {
681         return isEnabled;
682     }
683 
684     function info(bytes32 field) public view returns(uint) {
685         return infoFields[field];
686     }
687 
688     /* solhint-disable code-complexity */
689     // Regarding complexity. Below code follows the required algorithm for choosing a reserve.
690     //  It has been tested, reviewed and found to be clear enough.
691     //@dev this function always src or dest are ether. can't do token to token
692     function searchBestRate(ERC20 src, ERC20 dest, uint srcAmount, bool usePermissionless)
693         public
694         view
695         returns(address, uint)
696     {
697         uint bestRate = 0;
698         uint bestReserve = 0;
699         uint numRelevantReserves = 0;
700 
701         //return 1 for ether to ether
702         if (src == dest) return (reserves[bestReserve], PRECISION);
703 
704         address[] memory reserveArr;
705 
706         reserveArr = src == ETH_TOKEN_ADDRESS ? reservesPerTokenDest[dest] : reservesPerTokenSrc[src];
707 
708         if (reserveArr.length == 0) return (reserves[bestReserve], bestRate);
709 
710         uint[] memory rates = new uint[](reserveArr.length);
711         uint[] memory reserveCandidates = new uint[](reserveArr.length);
712 
713         for (uint i = 0; i < reserveArr.length; i++) {
714             //list all reserves that have this token.
715             if (!usePermissionless && reserveType[reserveArr[i]] == ReserveType.PERMISSIONLESS) {
716                 continue;
717             }
718 
719             rates[i] = (KyberReserveInterface(reserveArr[i])).getConversionRate(src, dest, srcAmount, block.number);
720 
721             if (rates[i] > bestRate) {
722                 //best rate is highest rate
723                 bestRate = rates[i];
724             }
725         }
726 
727         if (bestRate > 0) {
728             uint smallestRelevantRate = (bestRate * 10000) / (10000 + negligibleRateDiff);
729 
730             for (i = 0; i < reserveArr.length; i++) {
731                 if (rates[i] >= smallestRelevantRate) {
732                     reserveCandidates[numRelevantReserves++] = i;
733                 }
734             }
735 
736             if (numRelevantReserves > 1) {
737                 //when encountering small rate diff from bestRate. draw from relevant reserves
738                 bestReserve = reserveCandidates[uint(block.blockhash(block.number-1)) % numRelevantReserves];
739             } else {
740                 bestReserve = reserveCandidates[0];
741             }
742 
743             bestRate = rates[bestReserve];
744         }
745 
746         return (reserveArr[bestReserve], bestRate);
747     }
748     /* solhint-enable code-complexity */
749 
750     function findBestRateTokenToToken(ERC20 src, ERC20 dest, uint srcAmount, bytes hint) internal view
751         returns(BestRateResult result)
752     {
753         //by default we use permission less reserves
754         bool usePermissionless = true;
755 
756         // if hint in first 4 bytes == 'PERM' only permissioned reserves will be used.
757         if ((hint.length >= 4) && (keccak256(hint[0], hint[1], hint[2], hint[3]) == keccak256(PERM_HINT))) {
758             usePermissionless = false;
759         }
760 
761         (result.reserve1, result.rateSrcToEth) =
762             searchBestRate(src, ETH_TOKEN_ADDRESS, srcAmount, usePermissionless);
763 
764         result.weiAmount = calcDestAmount(src, ETH_TOKEN_ADDRESS, srcAmount, result.rateSrcToEth);
765 
766         (result.reserve2, result.rateEthToDest) =
767             searchBestRate(ETH_TOKEN_ADDRESS, dest, result.weiAmount, usePermissionless);
768 
769         result.destAmount = calcDestAmount(ETH_TOKEN_ADDRESS, dest, result.weiAmount, result.rateEthToDest);
770 
771         result.rate = calcRateFromQty(srcAmount, result.destAmount, getDecimals(src), getDecimals(dest));
772     }
773 
774     function listPairs(address reserve, ERC20 token, bool isTokenToEth, bool add) internal {
775         uint i;
776         address[] storage reserveArr = reservesPerTokenDest[token];
777 
778         if (isTokenToEth) {
779             reserveArr = reservesPerTokenSrc[token];
780         }
781 
782         for (i = 0; i < reserveArr.length; i++) {
783             if (reserve == reserveArr[i]) {
784                 if (add) {
785                     break; //already added
786                 } else {
787                     //remove
788                     reserveArr[i] = reserveArr[reserveArr.length - 1];
789                     reserveArr.length--;
790                     break;
791                 }
792             }
793         }
794 
795         if (add && i == reserveArr.length) {
796             //if reserve wasn't found add it
797             reserveArr.push(reserve);
798         }
799     }
800 
801     event KyberTrade(address indexed trader, ERC20 src, ERC20 dest, uint srcAmount, uint dstAmount,
802         address destAddress, uint ethWeiValue, address reserve1, address reserve2, bytes hint);
803 
804     /* solhint-disable function-max-lines */
805     //  Most of the lines here are functions calls spread over multiple lines. We find this function readable enough
806     /// @notice use token address ETH_TOKEN_ADDRESS for ether
807     /// @dev trade api for kyber network.
808     /// @param tradeInput structure of trade inputs
809     function trade(TradeInput tradeInput) internal returns(uint) {
810         require(isEnabled);
811         require(tx.gasprice <= maxGasPriceValue);
812         require(validateTradeInput(tradeInput.src, tradeInput.srcAmount, tradeInput.dest, tradeInput.destAddress));
813 
814         BestRateResult memory rateResult =
815             findBestRateTokenToToken(tradeInput.src, tradeInput.dest, tradeInput.srcAmount, tradeInput.hint);
816 
817         require(rateResult.rate > 0);
818         require(rateResult.rate < MAX_RATE);
819         require(rateResult.rate >= tradeInput.minConversionRate);
820 
821         uint actualDestAmount;
822         uint weiAmount;
823         uint actualSrcAmount;
824 
825         (actualSrcAmount, weiAmount, actualDestAmount) = calcActualAmounts(tradeInput.src,
826             tradeInput.dest,
827             tradeInput.srcAmount,
828             tradeInput.maxDestAmount,
829             rateResult);
830 
831         require(getUserCapInWei(tradeInput.trader) >= weiAmount);
832         require(handleChange(tradeInput.src, tradeInput.srcAmount, actualSrcAmount, tradeInput.trader));
833 
834         require(doReserveTrade(     //src to ETH
835                 tradeInput.src,
836                 actualSrcAmount,
837                 ETH_TOKEN_ADDRESS,
838                 this,
839                 weiAmount,
840                 KyberReserveInterface(rateResult.reserve1),
841                 rateResult.rateSrcToEth,
842                 true));
843 
844         require(doReserveTrade(     //Eth to dest
845                 ETH_TOKEN_ADDRESS,
846                 weiAmount,
847                 tradeInput.dest,
848                 tradeInput.destAddress,
849                 actualDestAmount,
850                 KyberReserveInterface(rateResult.reserve2),
851                 rateResult.rateEthToDest,
852                 true));
853 
854         if (tradeInput.src != ETH_TOKEN_ADDRESS) //"fake" trade. (ether to ether) - don't burn.
855             require(feeBurnerContract.handleFees(weiAmount, rateResult.reserve1, tradeInput.walletId));
856         if (tradeInput.dest != ETH_TOKEN_ADDRESS) //"fake" trade. (ether to ether) - don't burn.
857             require(feeBurnerContract.handleFees(weiAmount, rateResult.reserve2, tradeInput.walletId));
858 
859         KyberTrade({
860             trader: tradeInput.trader,
861             src: tradeInput.src,
862             dest: tradeInput.dest,
863             srcAmount: actualSrcAmount,
864             dstAmount: actualDestAmount,
865             destAddress: tradeInput.destAddress,
866             ethWeiValue: weiAmount,
867             reserve1: (tradeInput.src == ETH_TOKEN_ADDRESS) ? address(0) : rateResult.reserve1,
868             reserve2:  (tradeInput.dest == ETH_TOKEN_ADDRESS) ? address(0) : rateResult.reserve2,
869             hint: tradeInput.hint
870         });
871 
872         return actualDestAmount;
873     }
874     /* solhint-enable function-max-lines */
875 
876     function calcActualAmounts (ERC20 src, ERC20 dest, uint srcAmount, uint maxDestAmount, BestRateResult rateResult)
877         internal view returns(uint actualSrcAmount, uint weiAmount, uint actualDestAmount)
878     {
879         if (rateResult.destAmount > maxDestAmount) {
880             actualDestAmount = maxDestAmount;
881             weiAmount = calcSrcAmount(ETH_TOKEN_ADDRESS, dest, actualDestAmount, rateResult.rateEthToDest);
882             actualSrcAmount = calcSrcAmount(src, ETH_TOKEN_ADDRESS, weiAmount, rateResult.rateSrcToEth);
883             require(actualSrcAmount <= srcAmount);
884         } else {
885             actualDestAmount = rateResult.destAmount;
886             actualSrcAmount = srcAmount;
887             weiAmount = rateResult.weiAmount;
888         }
889     }
890 
891     /// @notice use token address ETH_TOKEN_ADDRESS for ether
892     /// @dev do one trade with a reserve
893     /// @param src Src token
894     /// @param amount amount of src tokens
895     /// @param dest   Destination token
896     /// @param destAddress Address to send tokens to
897     /// @param reserve Reserve to use
898     /// @param validate If true, additional validations are applicable
899     /// @return true if trade is successful
900     function doReserveTrade(
901         ERC20 src,
902         uint amount,
903         ERC20 dest,
904         address destAddress,
905         uint expectedDestAmount,
906         KyberReserveInterface reserve,
907         uint conversionRate,
908         bool validate
909     )
910         internal
911         returns(bool)
912     {
913         uint callValue = 0;
914 
915         if (src == dest) {
916             //this is for a "fake" trade when both src and dest are ethers.
917             if (destAddress != (address(this)))
918                 destAddress.transfer(amount);
919             return true;
920         }
921 
922         if (src == ETH_TOKEN_ADDRESS) {
923             callValue = amount;
924         }
925 
926         // reserve sends tokens/eth to network. network sends it to destination
927         require(reserve.trade.value(callValue)(src, amount, dest, this, conversionRate, validate));
928 
929         if (destAddress != address(this)) {
930             //for token to token dest address is network. and Ether / token already here...
931             if (dest == ETH_TOKEN_ADDRESS) {
932                 destAddress.transfer(expectedDestAmount);
933             } else {
934                 require(dest.transfer(destAddress, expectedDestAmount));
935             }
936         }
937 
938         return true;
939     }
940 
941     /// when user sets max dest amount we could have too many source tokens == change. so we send it back to user.
942     function handleChange (ERC20 src, uint srcAmount, uint requiredSrcAmount, address trader) internal returns (bool) {
943 
944         if (requiredSrcAmount < srcAmount) {
945             //if there is "change" send back to trader
946             if (src == ETH_TOKEN_ADDRESS) {
947                 trader.transfer(srcAmount - requiredSrcAmount);
948             } else {
949                 require(src.transfer(trader, (srcAmount - requiredSrcAmount)));
950             }
951         }
952 
953         return true;
954     }
955 
956     /// @notice use token address ETH_TOKEN_ADDRESS for ether
957     /// @dev checks that user sent ether/tokens to contract before trade
958     /// @param src Src token
959     /// @param srcAmount amount of src tokens
960     /// @return true if tradeInput is valid
961     function validateTradeInput(ERC20 src, uint srcAmount, ERC20 dest, address destAddress)
962         internal
963         view
964         returns(bool)
965     {
966         require(srcAmount <= MAX_QTY);
967         require(srcAmount != 0);
968         require(destAddress != address(0));
969         require(src != dest);
970 
971         if (src == ETH_TOKEN_ADDRESS) {
972             require(msg.value == srcAmount);
973         } else {
974             require(msg.value == 0);
975             //funds should have been moved to this contract already.
976             require(src.balanceOf(this) >= srcAmount);
977         }
978 
979         return true;
980     }
981 }
982 
983 // File: contracts/ExpectedRate.sol
984 
985 contract ExpectedRate is Withdrawable, ExpectedRateInterface, Utils2 {
986 
987     KyberNetwork public kyberNetwork;
988     uint public quantityFactor = 2;
989     uint public worstCaseRateFactorInBps = 50;
990     uint constant UNIT_QTY_FOR_FEE_BURNER = 10 ** 18;
991     ERC20 public knc;
992 
993     function ExpectedRate(KyberNetwork _kyberNetwork, ERC20 _knc, address _admin) public {
994         require(_admin != address(0));
995         require(_knc != address(0));
996         require(_kyberNetwork != address(0));
997         kyberNetwork = _kyberNetwork;
998         admin = _admin;
999         knc = _knc;
1000     }
1001 
1002     event QuantityFactorSet (uint newFactor, uint oldFactor, address sender);
1003 
1004     function setQuantityFactor(uint newFactor) public onlyOperator {
1005         require(newFactor <= 100);
1006 
1007         QuantityFactorSet(newFactor, quantityFactor, msg.sender);
1008         quantityFactor = newFactor;
1009     }
1010 
1011     event MinSlippageFactorSet (uint newMin, uint oldMin, address sender);
1012 
1013     function setWorstCaseRateFactor(uint bps) public onlyOperator {
1014         require(bps <= 100 * 100);
1015 
1016         MinSlippageFactorSet(bps, worstCaseRateFactorInBps, msg.sender);
1017         worstCaseRateFactorInBps = bps;
1018     }
1019 
1020     //@dev when srcQty too small or 0 the expected rate will be calculated without quantity,
1021     // will enable rate reference before committing to any quantity
1022     //@dev when srcQty too small (no actual dest qty) slippage rate will be 0.
1023     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty, bool usePermissionless)
1024         public view
1025         returns (uint expectedRate, uint slippageRate)
1026     {
1027         require(quantityFactor != 0);
1028         require(srcQty <= MAX_QTY);
1029         require(srcQty * quantityFactor <= MAX_QTY);
1030 
1031         if (srcQty == 0) srcQty = 1;
1032 
1033         bool didRevert = false;
1034 
1035         (didRevert, expectedRate, slippageRate) = safeFindBestRate(src, dest, srcQty, usePermissionless);
1036         if (didRevert) return (0, 0);
1037 
1038         if (expectedRate == 0) {
1039             expectedRate = expectedRateSmallQty(src, dest, srcQty, usePermissionless);
1040         }
1041 
1042         if (src == knc &&
1043             dest == ETH_TOKEN_ADDRESS &&
1044             srcQty == UNIT_QTY_FOR_FEE_BURNER )
1045         {
1046             if (checkKncArbitrageRate(expectedRate)) expectedRate = 0;
1047         }
1048 
1049         require(expectedRate <= MAX_RATE);
1050 
1051         uint worstCaseSlippageRate = ((10000 - worstCaseRateFactorInBps) * expectedRate) / 10000;
1052         if (slippageRate >= worstCaseSlippageRate) {
1053             slippageRate = worstCaseSlippageRate;
1054         }
1055 
1056         return (expectedRate, slippageRate);
1057     }
1058 
1059     function checkKncArbitrageRate(uint currentKncToEthRate) public view returns(bool) {
1060         uint converseRate;
1061         uint slippage;
1062     	(converseRate, slippage) = getExpectedRate(ETH_TOKEN_ADDRESS, knc, UNIT_QTY_FOR_FEE_BURNER, true);
1063         require(converseRate <= MAX_RATE && currentKncToEthRate <= MAX_RATE);
1064         return ((converseRate * currentKncToEthRate) > (PRECISION ** 2));
1065     }
1066 
1067     //@dev for small src quantities dest qty might be 0, then returned rate is zero.
1068     //@dev for backward compatibility we would like to return non zero rate (correct one) for small src qty
1069     function expectedRateSmallQty(ERC20 src, ERC20 dest, uint srcQty, bool usePermissionless)
1070         internal view returns(uint)
1071     {
1072         address reserve;
1073         uint rateSrcToEth;
1074         uint rateEthToDest;
1075         (reserve, rateSrcToEth) = kyberNetwork.searchBestRate(src, ETH_TOKEN_ADDRESS, srcQty, usePermissionless);
1076 
1077         uint ethQty = calcDestAmount(src, ETH_TOKEN_ADDRESS, srcQty, rateSrcToEth);
1078 
1079         (reserve, rateEthToDest) = kyberNetwork.searchBestRate(ETH_TOKEN_ADDRESS, dest, ethQty, usePermissionless);
1080         return rateSrcToEth * rateEthToDest / PRECISION;
1081     }
1082 
1083     function safeFindBestRate(ERC20 src, ERC20 dest, uint srcQty, bool usePermissionless)
1084         internal view
1085         returns (bool didRevert, uint expectedRate, uint slippageRate)
1086     {
1087         bytes4 sig = usePermissionless ?
1088             bytes4(keccak256("findBestRate(address,address,uint256)")) :
1089             bytes4(keccak256("findBestRateOnlyPermission(address,address,uint256)")); //Function signatures
1090 
1091         (didRevert, expectedRate) = assemblyFindBestRate(src, dest, srcQty, sig);
1092 
1093         if (didRevert) return (true, 0, 0);
1094 
1095         if (quantityFactor != 1) {
1096             (didRevert, slippageRate) = assemblyFindBestRate(src, dest, (srcQty * quantityFactor), sig);
1097         } else {
1098             slippageRate = expectedRate;
1099         }
1100     }
1101 
1102     function assemblyFindBestRate(ERC20 src, ERC20 dest, uint srcQty, bytes4 sig)
1103         internal view
1104         returns (bool didRevert, uint rate)
1105     {
1106         address addr = address(kyberNetwork);  // kyber address
1107         uint success;
1108 
1109         assembly {
1110             let x := mload(0x40)        // "free memory pointer"
1111             mstore(x,sig)               // function signature
1112             mstore(add(x,0x04),src)     // src address padded to 32 bytes
1113             mstore(add(x,0x24),dest)    // dest padded to 32 bytes
1114             mstore(add(x,0x44),srcQty)  // uint 32 bytes
1115             mstore(0x40,add(x,0xa4))    // set free storage pointer to empty space after output
1116 
1117             // input size = sig + ERC20 (address) + ERC20 + uint
1118             // = 4 + 32 + 32 + 32 = 100 = 0x64
1119             success := staticcall(
1120                 gas,  // gas
1121                 addr, // Kyber addr
1122                 x,    // Inputs at location x
1123                 0x64, // Inputs size bytes
1124                 add(x, 0x64),    // output storage after input
1125                 0x40) // Output size are (uint, uint) = 64 bytes
1126 
1127             rate := mload(add(x,0x84))  //Assign 2nd output to rate, first output not used,
1128             mstore(0x40,x)    // Set empty storage pointer back to start position
1129         }
1130 
1131         if (success != 1) didRevert = true;
1132     }
1133 }