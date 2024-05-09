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
20     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
21         returns (uint expectedRate, uint slippageRate);
22 }
23 
24 // File: contracts/FeeBurnerInterface.sol
25 
26 interface FeeBurnerInterface {
27     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
28 }
29 
30 // File: contracts/KyberNetworkInterface.sol
31 
32 /// @title Kyber Network interface
33 interface KyberNetworkInterface {
34     function maxGasPrice() public view returns(uint);
35     function getUserCapInWei(address user) public view returns(uint);
36     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint);
37     function enabled() public view returns(bool);
38     function info(bytes32 id) public view returns(uint);
39 
40     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
41         returns (uint expectedRate, uint slippageRate);
42 
43     function tradeWithHint(address trader, ERC20 src, uint srcAmount, ERC20 dest, address destAddress,
44         uint maxDestAmount, uint minConversionRate, address walletId, bytes hint) public payable returns(uint);
45 }
46 
47 // File: contracts/KyberReserveInterface.sol
48 
49 /// @title Kyber Reserve contract
50 interface KyberReserveInterface {
51 
52     function trade(
53         ERC20 srcToken,
54         uint srcAmount,
55         ERC20 destToken,
56         address destAddress,
57         uint conversionRate,
58         bool validate
59     )
60         public
61         payable
62         returns(bool);
63 
64     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
65 }
66 
67 // File: contracts/Utils.sol
68 
69 /// @title Kyber constants contract
70 contract Utils {
71 
72     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
73     uint  constant internal PRECISION = (10**18);
74     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
75     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
76     uint  constant internal MAX_DECIMALS = 18;
77     uint  constant internal ETH_DECIMALS = 18;
78     mapping(address=>uint) internal decimals;
79 
80     function setDecimals(ERC20 token) internal {
81         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
82         else decimals[token] = token.decimals();
83     }
84 
85     function getDecimals(ERC20 token) internal view returns(uint) {
86         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
87         uint tokenDecimals = decimals[token];
88         // technically, there might be token with decimals 0
89         // moreover, very possible that old tokens have decimals 0
90         // these tokens will just have higher gas fees.
91         if(tokenDecimals == 0) return token.decimals();
92 
93         return tokenDecimals;
94     }
95 
96     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
97         require(srcQty <= MAX_QTY);
98         require(rate <= MAX_RATE);
99 
100         if (dstDecimals >= srcDecimals) {
101             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
102             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
103         } else {
104             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
105             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
106         }
107     }
108 
109     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
110         require(dstQty <= MAX_QTY);
111         require(rate <= MAX_RATE);
112         
113         //source quantity is rounded up. to avoid dest quantity being too low.
114         uint numerator;
115         uint denominator;
116         if (srcDecimals >= dstDecimals) {
117             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
118             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
119             denominator = rate;
120         } else {
121             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
122             numerator = (PRECISION * dstQty);
123             denominator = (rate * (10**(dstDecimals - srcDecimals)));
124         }
125         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
126     }
127 }
128 
129 // File: contracts/Utils2.sol
130 
131 contract Utils2 is Utils {
132 
133     /// @dev get the balance of a user.
134     /// @param token The token type
135     /// @return The balance
136     function getBalance(ERC20 token, address user) public view returns(uint) {
137         if (token == ETH_TOKEN_ADDRESS)
138             return user.balance;
139         else
140             return token.balanceOf(user);
141     }
142 
143     function getDecimalsSafe(ERC20 token) internal returns(uint) {
144 
145         if (decimals[token] == 0) {
146             setDecimals(token);
147         }
148 
149         return decimals[token];
150     }
151 
152     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
153         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
154     }
155 
156     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
157         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
158     }
159 
160     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
161         internal pure returns(uint)
162     {
163         require(srcAmount <= MAX_QTY);
164         require(destAmount <= MAX_QTY);
165 
166         if (dstDecimals >= srcDecimals) {
167             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
168             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
169         } else {
170             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
171             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
172         }
173     }
174 }
175 
176 // File: contracts/WhiteListInterface.sol
177 
178 contract WhiteListInterface {
179     function getUserCapInWei(address user) external view returns (uint userCapWei);
180 }
181 
182 // File: contracts/PermissionGroups.sol
183 
184 contract PermissionGroups {
185 
186     address public admin;
187     address public pendingAdmin;
188     mapping(address=>bool) internal operators;
189     mapping(address=>bool) internal alerters;
190     address[] internal operatorsGroup;
191     address[] internal alertersGroup;
192     uint constant internal MAX_GROUP_SIZE = 50;
193 
194     function PermissionGroups() public {
195         admin = msg.sender;
196     }
197 
198     modifier onlyAdmin() {
199         require(msg.sender == admin);
200         _;
201     }
202 
203     modifier onlyOperator() {
204         require(operators[msg.sender]);
205         _;
206     }
207 
208     modifier onlyAlerter() {
209         require(alerters[msg.sender]);
210         _;
211     }
212 
213     function getOperators () external view returns(address[]) {
214         return operatorsGroup;
215     }
216 
217     function getAlerters () external view returns(address[]) {
218         return alertersGroup;
219     }
220 
221     event TransferAdminPending(address pendingAdmin);
222 
223     /**
224      * @dev Allows the current admin to set the pendingAdmin address.
225      * @param newAdmin The address to transfer ownership to.
226      */
227     function transferAdmin(address newAdmin) public onlyAdmin {
228         require(newAdmin != address(0));
229         TransferAdminPending(pendingAdmin);
230         pendingAdmin = newAdmin;
231     }
232 
233     /**
234      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
235      * @param newAdmin The address to transfer ownership to.
236      */
237     function transferAdminQuickly(address newAdmin) public onlyAdmin {
238         require(newAdmin != address(0));
239         TransferAdminPending(newAdmin);
240         AdminClaimed(newAdmin, admin);
241         admin = newAdmin;
242     }
243 
244     event AdminClaimed( address newAdmin, address previousAdmin);
245 
246     /**
247      * @dev Allows the pendingAdmin address to finalize the change admin process.
248      */
249     function claimAdmin() public {
250         require(pendingAdmin == msg.sender);
251         AdminClaimed(pendingAdmin, admin);
252         admin = pendingAdmin;
253         pendingAdmin = address(0);
254     }
255 
256     event AlerterAdded (address newAlerter, bool isAdd);
257 
258     function addAlerter(address newAlerter) public onlyAdmin {
259         require(!alerters[newAlerter]); // prevent duplicates.
260         require(alertersGroup.length < MAX_GROUP_SIZE);
261 
262         AlerterAdded(newAlerter, true);
263         alerters[newAlerter] = true;
264         alertersGroup.push(newAlerter);
265     }
266 
267     function removeAlerter (address alerter) public onlyAdmin {
268         require(alerters[alerter]);
269         alerters[alerter] = false;
270 
271         for (uint i = 0; i < alertersGroup.length; ++i) {
272             if (alertersGroup[i] == alerter) {
273                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
274                 alertersGroup.length--;
275                 AlerterAdded(alerter, false);
276                 break;
277             }
278         }
279     }
280 
281     event OperatorAdded(address newOperator, bool isAdd);
282 
283     function addOperator(address newOperator) public onlyAdmin {
284         require(!operators[newOperator]); // prevent duplicates.
285         require(operatorsGroup.length < MAX_GROUP_SIZE);
286 
287         OperatorAdded(newOperator, true);
288         operators[newOperator] = true;
289         operatorsGroup.push(newOperator);
290     }
291 
292     function removeOperator (address operator) public onlyAdmin {
293         require(operators[operator]);
294         operators[operator] = false;
295 
296         for (uint i = 0; i < operatorsGroup.length; ++i) {
297             if (operatorsGroup[i] == operator) {
298                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
299                 operatorsGroup.length -= 1;
300                 OperatorAdded(operator, false);
301                 break;
302             }
303         }
304     }
305 }
306 
307 // File: contracts/Withdrawable.sol
308 
309 /**
310  * @title Contracts that should be able to recover tokens or ethers
311  * @author Ilan Doron
312  * @dev This allows to recover any tokens or Ethers received in a contract.
313  * This will prevent any accidental loss of tokens.
314  */
315 contract Withdrawable is PermissionGroups {
316 
317     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
318 
319     /**
320      * @dev Withdraw all ERC20 compatible tokens
321      * @param token ERC20 The address of the token contract
322      */
323     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
324         require(token.transfer(sendTo, amount));
325         TokenWithdraw(token, amount, sendTo);
326     }
327 
328     event EtherWithdraw(uint amount, address sendTo);
329 
330     /**
331      * @dev Withdraw Ethers
332      */
333     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
334         sendTo.transfer(amount);
335         EtherWithdraw(amount, sendTo);
336     }
337 }
338 
339 // File: contracts/KyberNetwork.sol
340 
341 ////////////////////////////////////////////////////////////////////////////////////////////////////////
342 /// @title Kyber Network main contract
343 contract KyberNetwork is Withdrawable, Utils2, KyberNetworkInterface {
344 
345     uint public negligibleRateDiff = 10; // basic rate steps will be in 0.01%
346     KyberReserveInterface[] public reserves;
347     mapping(address=>bool) public isReserve;
348     WhiteListInterface public whiteListContract;
349     ExpectedRateInterface public expectedRateContract;
350     FeeBurnerInterface    public feeBurnerContract;
351     address               public kyberNetworkProxyContract;
352     uint                  public maxGasPriceValue = 50 * 1000 * 1000 * 1000; // 50 gwei
353     bool                  public isEnabled = false; // network is enabled
354     mapping(bytes32=>uint) public infoFields; // this is only a UI field for external app.
355     mapping(address=>address[]) public reservesPerTokenSrc; //reserves supporting token to eth
356     mapping(address=>address[]) public reservesPerTokenDest;//reserves support eth to token
357 
358     function KyberNetwork(address _admin) public {
359         require(_admin != address(0));
360         admin = _admin;
361     }
362 
363     event EtherReceival(address indexed sender, uint amount);
364 
365     /* solhint-disable no-complex-fallback */
366     // To avoid users trying to swap tokens using default payable function. We added this short code
367     //  to verify Ethers will be received only from reserves if transferred without a specific function call.
368     function() public payable {
369         require(isReserve[msg.sender]);
370         EtherReceival(msg.sender, msg.value);
371     }
372     /* solhint-enable no-complex-fallback */
373 
374     struct TradeInput {
375         address trader;
376         ERC20 src;
377         uint srcAmount;
378         ERC20 dest;
379         address destAddress;
380         uint maxDestAmount;
381         uint minConversionRate;
382         address walletId;
383         bytes hint;
384     }
385 
386     function tradeWithHint(
387         address trader,
388         ERC20 src,
389         uint srcAmount,
390         ERC20 dest,
391         address destAddress,
392         uint maxDestAmount,
393         uint minConversionRate,
394         address walletId,
395         bytes hint
396     )
397         public
398         payable
399         returns(uint)
400     {
401         require(hint.length == 0);
402         require(msg.sender == kyberNetworkProxyContract);
403 
404         TradeInput memory tradeInput;
405 
406         tradeInput.trader = trader;
407         tradeInput.src = src;
408         tradeInput.srcAmount = srcAmount;
409         tradeInput.dest = dest;
410         tradeInput.destAddress = destAddress;
411         tradeInput.maxDestAmount = maxDestAmount;
412         tradeInput.minConversionRate = minConversionRate;
413         tradeInput.walletId = walletId;
414         tradeInput.hint = hint;
415 
416         return trade(tradeInput);
417     }
418 
419     event AddReserveToNetwork(KyberReserveInterface reserve, bool add);
420 
421     /// @notice can be called only by admin
422     /// @dev add or deletes a reserve to/from the network.
423     /// @param reserve The reserve address.
424     /// @param add If true, the add reserve. Otherwise delete reserve.
425     function addReserve(KyberReserveInterface reserve, bool add) public onlyAdmin {
426 
427         if (add) {
428             require(!isReserve[reserve]);
429             reserves.push(reserve);
430             isReserve[reserve] = true;
431             AddReserveToNetwork(reserve, true);
432         } else {
433             isReserve[reserve] = false;
434             // will have trouble if more than 50k reserves...
435             for (uint i = 0; i < reserves.length; i++) {
436                 if (reserves[i] == reserve) {
437                     reserves[i] = reserves[reserves.length - 1];
438                     reserves.length--;
439                     AddReserveToNetwork(reserve, false);
440                     break;
441                 }
442             }
443         }
444     }
445 
446     event ListReservePairs(address reserve, ERC20 src, ERC20 dest, bool add);
447 
448     /// @notice can be called only by admin
449     /// @dev allow or prevent a specific reserve to trade a pair of tokens
450     /// @param reserve The reserve address.
451     /// @param token token address
452     /// @param ethToToken will it support ether to token trade
453     /// @param tokenToEth will it support token to ether trade
454     /// @param add If true then list this pair, otherwise unlist it.
455     function listPairForReserve(address reserve, ERC20 token, bool ethToToken, bool tokenToEth, bool add)
456         public onlyAdmin
457     {
458         require(isReserve[reserve]);
459 
460         if (ethToToken) {
461             listPairs(reserve, token, false, add);
462 
463             ListReservePairs(reserve, ETH_TOKEN_ADDRESS, token, add);
464         }
465 
466         if (tokenToEth) {
467             listPairs(reserve, token, true, add);
468             if (add) {
469                 token.approve(reserve, 2**255); // approve infinity
470             } else {
471                 token.approve(reserve, 0);
472             }
473 
474             ListReservePairs(reserve, token, ETH_TOKEN_ADDRESS, add);
475         }
476 
477         setDecimals(token);
478     }
479 
480     function setWhiteList(WhiteListInterface whiteList) public onlyAdmin {
481         require(whiteList != address(0));
482         whiteListContract = whiteList;
483     }
484 
485     function setExpectedRate(ExpectedRateInterface expectedRate) public onlyAdmin {
486         require(expectedRate != address(0));
487         expectedRateContract = expectedRate;
488     }
489 
490     function setFeeBurner(FeeBurnerInterface feeBurner) public onlyAdmin {
491         require(feeBurner != address(0));
492         feeBurnerContract = feeBurner;
493     }
494 
495     function setParams(
496         uint                  _maxGasPrice,
497         uint                  _negligibleRateDiff
498     )
499         public
500         onlyAdmin
501     {
502         require(_negligibleRateDiff <= 100 * 100); // at most 100%
503 
504         maxGasPriceValue = _maxGasPrice;
505         negligibleRateDiff = _negligibleRateDiff;
506     }
507 
508     function setEnable(bool _enable) public onlyAdmin {
509         if (_enable) {
510             require(whiteListContract != address(0));
511             require(feeBurnerContract != address(0));
512             require(expectedRateContract != address(0));
513             require(kyberNetworkProxyContract != address(0));
514         }
515         isEnabled = _enable;
516     }
517 
518     function setInfo(bytes32 field, uint value) public onlyOperator {
519         infoFields[field] = value;
520     }
521 
522     event KyberProxySet(address proxy, address sender);
523 
524     function setKyberProxy(address networkProxy) public onlyAdmin {
525         require(networkProxy != address(0));
526         kyberNetworkProxyContract = networkProxy;
527         KyberProxySet(kyberNetworkProxyContract, msg.sender);
528     }
529 
530     /// @dev returns number of reserves
531     /// @return number of reserves
532     function getNumReserves() public view returns(uint) {
533         return reserves.length;
534     }
535 
536     /// @notice should be called off chain with as much gas as needed
537     /// @dev get an array of all reserves
538     /// @return An array of all reserves
539     function getReserves() public view returns(KyberReserveInterface[]) {
540         return reserves;
541     }
542 
543     function maxGasPrice() public view returns(uint) {
544         return maxGasPriceValue;
545     }
546 
547     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
548         public view
549         returns(uint expectedRate, uint slippageRate)
550     {
551         require(expectedRateContract != address(0));
552         return expectedRateContract.getExpectedRate(src, dest, srcQty);
553     }
554 
555     function getUserCapInWei(address user) public view returns(uint) {
556         return whiteListContract.getUserCapInWei(user);
557     }
558 
559     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint) {
560         //future feature
561         user;
562         token;
563         require(false);
564     }
565 
566     struct BestRateResult {
567         uint rate;
568         address reserve1;
569         address reserve2;
570         uint weiAmount;
571         uint rateSrcToEth;
572         uint rateEthToDest;
573         uint destAmount;
574     }
575 
576     /// @notice use token address ETH_TOKEN_ADDRESS for ether
577     /// @dev best conversion rate for a pair of tokens, if number of reserves have small differences. randomize
578     /// @param src Src token
579     /// @param dest Destination token
580     /// @return obsolete - used to return best reserve index. not relevant anymore for this API.
581     function findBestRate(ERC20 src, ERC20 dest, uint srcAmount) public view returns(uint obsolete, uint rate) {
582         BestRateResult memory result = findBestRateTokenToToken(src, dest, srcAmount);
583         return(0, result.rate);
584     }
585 
586     function enabled() public view returns(bool) {
587         return isEnabled;
588     }
589 
590     function info(bytes32 field) public view returns(uint) {
591         return infoFields[field];
592     }
593 
594     /* solhint-disable code-complexity */
595     // Not sure how solhing defines complexity. Anyway, from our point of view, below code follows the required
596     //  algorithm to choose a reserve, it has been tested, reviewed and found to be clear enough.
597     //@dev this function always src or dest are ether. can't do token to token
598     function searchBestRate(ERC20 src, ERC20 dest, uint srcAmount) public view returns(address, uint) {
599         uint bestRate = 0;
600         uint bestReserve = 0;
601         uint numRelevantReserves = 0;
602 
603         //return 1 for ether to ether
604         if (src == dest) return (reserves[bestReserve], PRECISION);
605 
606         address[] memory reserveArr;
607 
608         if (src == ETH_TOKEN_ADDRESS) {
609             reserveArr = reservesPerTokenDest[dest];
610         } else {
611             reserveArr = reservesPerTokenSrc[src];
612         }
613 
614         if (reserveArr.length == 0) return (reserves[bestReserve], bestRate);
615 
616         uint[] memory rates = new uint[](reserveArr.length);
617         uint[] memory reserveCandidates = new uint[](reserveArr.length);
618 
619         for (uint i = 0; i < reserveArr.length; i++) {
620             //list all reserves that have this token.
621             rates[i] = (KyberReserveInterface(reserveArr[i])).getConversionRate(src, dest, srcAmount, block.number);
622 
623             if (rates[i] > bestRate) {
624                 //best rate is highest rate
625                 bestRate = rates[i];
626             }
627         }
628 
629         if (bestRate > 0) {
630             uint random = 0;
631             uint smallestRelevantRate = (bestRate * 10000) / (10000 + negligibleRateDiff);
632 
633             for (i = 0; i < reserveArr.length; i++) {
634                 if (rates[i] >= smallestRelevantRate) {
635                     reserveCandidates[numRelevantReserves++] = i;
636                 }
637             }
638 
639             if (numRelevantReserves > 1) {
640                 //when encountering small rate diff from bestRate. draw from relevant reserves
641                 random = uint(block.blockhash(block.number-1)) % numRelevantReserves;
642             }
643 
644             bestReserve = reserveCandidates[random];
645             bestRate = rates[bestReserve];
646         }
647 
648         return (reserveArr[bestReserve], bestRate);
649     }
650     /* solhint-enable code-complexity */
651 
652     function findBestRateTokenToToken(ERC20 src, ERC20 dest, uint srcAmount) internal view
653         returns(BestRateResult result)
654     {
655         (result.reserve1, result.rateSrcToEth) = searchBestRate(src, ETH_TOKEN_ADDRESS, srcAmount);
656         result.weiAmount = calcDestAmount(src, ETH_TOKEN_ADDRESS, srcAmount, result.rateSrcToEth);
657 
658         (result.reserve2, result.rateEthToDest) = searchBestRate(ETH_TOKEN_ADDRESS, dest, result.weiAmount);
659         result.destAmount = calcDestAmount(ETH_TOKEN_ADDRESS, dest, result.weiAmount, result.rateEthToDest);
660 
661         result.rate = calcRateFromQty(srcAmount, result.destAmount, getDecimals(src), getDecimals(dest));
662     }
663 
664     function listPairs(address reserve, ERC20 token, bool isTokenToEth, bool add) internal {
665         uint i;
666         address[] storage reserveArr = reservesPerTokenDest[token];
667 
668         if (isTokenToEth) {
669             reserveArr = reservesPerTokenSrc[token];
670         }
671 
672         for (i = 0; i < reserveArr.length; i++) {
673             if (reserve == reserveArr[i]) {
674                 if (add) {
675                     break; //already added
676                 } else {
677                     //remove
678                     reserveArr[i] = reserveArr[reserveArr.length - 1];
679                     reserveArr.length--;
680                 }
681             }
682         }
683 
684         if (add && i == reserveArr.length) {
685             //if reserve wasn't found add it
686             reserveArr.push(reserve);
687         }
688     }
689 
690     event KyberTrade(address srcAddress, ERC20 srcToken, uint srcAmount, address destAddress, ERC20 destToken,
691         uint destAmount);
692     /* solhint-disable function-max-lines */
693     // Most of the lins here are functions calls spread over multiple lines. We find this function readable enough
694     //  and keep its size as is.
695     /// @notice use token address ETH_TOKEN_ADDRESS for ether
696     /// @dev trade api for kyber network.
697     /// @param tradeInput structure of trade inputs
698     function trade(TradeInput tradeInput) internal returns(uint) {
699         require(isEnabled);
700         require(tx.gasprice <= maxGasPriceValue);
701         require(validateTradeInput(tradeInput.src, tradeInput.srcAmount, tradeInput.dest, tradeInput.destAddress));
702 
703         BestRateResult memory rateResult =
704         findBestRateTokenToToken(tradeInput.src, tradeInput.dest, tradeInput.srcAmount);
705 
706         require(rateResult.rate > 0);
707         require(rateResult.rate < MAX_RATE);
708         require(rateResult.rate >= tradeInput.minConversionRate);
709 
710         uint actualDestAmount;
711         uint weiAmount;
712         uint actualSrcAmount;
713 
714         (actualSrcAmount, weiAmount, actualDestAmount) = calcActualAmounts(tradeInput.src,
715             tradeInput.dest,
716             tradeInput.srcAmount,
717             tradeInput.maxDestAmount,
718             rateResult);
719 
720         if (actualSrcAmount < tradeInput.srcAmount) {
721             //if there is "change" send back to trader
722             if (tradeInput.src == ETH_TOKEN_ADDRESS) {
723                 tradeInput.trader.transfer(tradeInput.srcAmount - actualSrcAmount);
724             } else {
725                 tradeInput.src.transfer(tradeInput.trader, (tradeInput.srcAmount - actualSrcAmount));
726             }
727         }
728 
729         // verify trade size is smaller than user cap
730         require(weiAmount <= getUserCapInWei(tradeInput.trader));
731 
732         //do the trade
733         //src to ETH
734         require(doReserveTrade(
735                 tradeInput.src,
736                 actualSrcAmount,
737                 ETH_TOKEN_ADDRESS,
738                 this,
739                 weiAmount,
740                 KyberReserveInterface(rateResult.reserve1),
741                 rateResult.rateSrcToEth,
742                 true));
743 
744         //Eth to dest
745         require(doReserveTrade(
746                 ETH_TOKEN_ADDRESS,
747                 weiAmount,
748                 tradeInput.dest,
749                 tradeInput.destAddress,
750                 actualDestAmount,
751                 KyberReserveInterface(rateResult.reserve2),
752                 rateResult.rateEthToDest,
753                 true));
754 
755         //when src is ether, reserve1 is doing a "fake" trade. (ether to ether) - don't burn.
756         //when dest is ether, reserve2 is doing a "fake" trade. (ether to ether) - don't burn.
757         if (tradeInput.src != ETH_TOKEN_ADDRESS)
758             require(feeBurnerContract.handleFees(weiAmount, rateResult.reserve1, tradeInput.walletId));
759         if (tradeInput.dest != ETH_TOKEN_ADDRESS)
760             require(feeBurnerContract.handleFees(weiAmount, rateResult.reserve2, tradeInput.walletId));
761 
762         KyberTrade(tradeInput.trader, tradeInput.src, actualSrcAmount, tradeInput.destAddress, tradeInput.dest,
763             actualDestAmount);
764 
765         return actualDestAmount;
766     }
767     /* solhint-enable function-max-lines */
768 
769     function calcActualAmounts (ERC20 src, ERC20 dest, uint srcAmount, uint maxDestAmount, BestRateResult rateResult)
770         internal view returns(uint actualSrcAmount, uint weiAmount, uint actualDestAmount)
771     {
772         if (rateResult.destAmount > maxDestAmount) {
773             actualDestAmount = maxDestAmount;
774             weiAmount = calcSrcAmount(ETH_TOKEN_ADDRESS, dest, actualDestAmount, rateResult.rateEthToDest);
775             actualSrcAmount = calcSrcAmount(src, ETH_TOKEN_ADDRESS, weiAmount, rateResult.rateSrcToEth);
776             require(actualSrcAmount <= srcAmount);
777         } else {
778             actualDestAmount = rateResult.destAmount;
779             actualSrcAmount = srcAmount;
780             weiAmount = rateResult.weiAmount;
781         }
782     }
783 
784     /// @notice use token address ETH_TOKEN_ADDRESS for ether
785     /// @dev do one trade with a reserve
786     /// @param src Src token
787     /// @param amount amount of src tokens
788     /// @param dest   Destination token
789     /// @param destAddress Address to send tokens to
790     /// @param reserve Reserve to use
791     /// @param validate If true, additional validations are applicable
792     /// @return true if trade is successful
793     function doReserveTrade(
794         ERC20 src,
795         uint amount,
796         ERC20 dest,
797         address destAddress,
798         uint expectedDestAmount,
799         KyberReserveInterface reserve,
800         uint conversionRate,
801         bool validate
802     )
803         internal
804         returns(bool)
805     {
806         uint callValue = 0;
807 
808         if (src == dest) {
809             //this is for a "fake" trade when both src and dest are ethers.
810             if (destAddress != (address(this)))
811                 destAddress.transfer(amount);
812             return true;
813         }
814 
815         if (src == ETH_TOKEN_ADDRESS) {
816             callValue = amount;
817         }
818 
819         // reserve sends tokens/eth to network. network sends it to destination
820         require(reserve.trade.value(callValue)(src, amount, dest, this, conversionRate, validate));
821 
822         if (destAddress != address(this)) {
823             //for token to token dest address is network. and Ether / token already here...
824             if (dest == ETH_TOKEN_ADDRESS) {
825                 destAddress.transfer(expectedDestAmount);
826             } else {
827                 require(dest.transfer(destAddress, expectedDestAmount));
828             }
829         }
830 
831         return true;
832     }
833 
834     /// @notice use token address ETH_TOKEN_ADDRESS for ether
835     /// @dev checks that user sent ether/tokens to contract before trade
836     /// @param src Src token
837     /// @param srcAmount amount of src tokens
838     /// @return true if tradeInput is valid
839     function validateTradeInput(ERC20 src, uint srcAmount, ERC20 dest, address destAddress)
840         internal
841         view
842         returns(bool)
843     {
844         require(srcAmount <= MAX_QTY);
845         require(srcAmount != 0);
846         require(destAddress != address(0));
847         require(src != dest);
848 
849         if (src == ETH_TOKEN_ADDRESS) {
850             require(msg.value == srcAmount);
851         } else {
852             require(msg.value == 0);
853             //funds should have been moved to this contract already.
854             require(src.balanceOf(this) >= srcAmount);
855         }
856 
857         return true;
858     }
859 }
860 
861 // File: contracts/ExpectedRate.sol
862 
863 contract ExpectedRate is Withdrawable, ExpectedRateInterface, Utils2 {
864 
865     KyberNetwork public kyberNetwork;
866     uint public quantityFactor = 2;
867     uint public worstCaseRateFactorInBps = 50;
868 
869     function ExpectedRate(KyberNetwork _kyberNetwork, address _admin) public {
870         require(_admin != address(0));
871         require(_kyberNetwork != address(0));
872         kyberNetwork = _kyberNetwork;
873         admin = _admin;
874     }
875 
876     event QuantityFactorSet (uint newFactor, uint oldFactor, address sender);
877 
878     function setQuantityFactor(uint newFactor) public onlyOperator {
879         require(newFactor <= 100);
880 
881         QuantityFactorSet(newFactor, quantityFactor, msg.sender);
882         quantityFactor = newFactor;
883     }
884 
885     event MinSlippageFactorSet (uint newMin, uint oldMin, address sender);
886 
887     function setWorstCaseRateFactor(uint bps) public onlyOperator {
888         require(bps <= 100 * 100);
889 
890         MinSlippageFactorSet(bps, worstCaseRateFactorInBps, msg.sender);
891         worstCaseRateFactorInBps = bps;
892     }
893 
894     //@dev when srcQty too small or 0 the expected rate will be calculated without quantity,
895     // will enable rate reference before committing to any quantity
896     //@dev when srcQty too small (no actual dest qty) slippage rate will be 0.
897     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
898         public view
899         returns (uint expectedRate, uint slippageRate)
900     {
901         require(quantityFactor != 0);
902         require(srcQty <= MAX_QTY);
903         require(srcQty * quantityFactor <= MAX_QTY);
904 
905         if (srcQty == 0) srcQty = 1;
906 
907         uint bestReserve;
908         uint worstCaseSlippageRate;
909 
910         (bestReserve, expectedRate) = kyberNetwork.findBestRate(src, dest, srcQty);
911         (bestReserve, slippageRate) = kyberNetwork.findBestRate(src, dest, (srcQty * quantityFactor));
912 
913         if (expectedRate == 0) {
914             expectedRate = expectedRateSmallQty(src, dest, srcQty);
915         }
916 
917         require(expectedRate <= MAX_RATE);
918 
919         worstCaseSlippageRate = ((10000 - worstCaseRateFactorInBps) * expectedRate) / 10000;
920         if (slippageRate >= worstCaseSlippageRate) {
921             slippageRate = worstCaseSlippageRate;
922         }
923 
924         return (expectedRate, slippageRate);
925     }
926 
927     //@dev for small src quantities dest qty might be 0, then returned rate is zero.
928     //@dev for backward compatibility we would like to return non zero rate (correct one) for small src qty
929     function expectedRateSmallQty(ERC20 src, ERC20 dest, uint srcQty) internal view returns(uint) {
930         address reserve;
931         uint rateSrcToEth;
932         uint rateEthToDest;
933         (reserve, rateSrcToEth) = kyberNetwork.searchBestRate(src, ETH_TOKEN_ADDRESS, srcQty);
934 
935         uint ethQty = calcDestAmount(src, dest, srcQty, rateSrcToEth);
936 
937         (reserve, rateEthToDest) = kyberNetwork.searchBestRate(ETH_TOKEN_ADDRESS, dest, ethQty);
938         return rateSrcToEth * rateEthToDest / PRECISION;
939     }
940 }