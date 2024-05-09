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
152     /// @dev notice, overrides previous implementation.
153     function setDecimals(ERC20 token) internal {
154         uint decimal;
155 
156         if (token == ETH_TOKEN_ADDRESS) {
157             decimal = ETH_DECIMALS;
158         } else {
159             if (!address(token).call(bytes4(keccak256("decimals()")))) {/* solhint-disable-line avoid-low-level-calls */
160                 //above code can only be performed with low level call. otherwise all operation will revert.
161                 // call failed
162                 decimal = 18;
163             } else {
164                 decimal = token.decimals();
165             }
166         }
167 
168         decimals[token] = decimal;
169     }
170 
171     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
172         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
173     }
174 
175     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
176         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
177     }
178 
179     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
180         internal pure returns(uint)
181     {
182         require(srcAmount <= MAX_QTY);
183         require(destAmount <= MAX_QTY);
184 
185         if (dstDecimals >= srcDecimals) {
186             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
187             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
188         } else {
189             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
190             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
191         }
192     }
193 }
194 
195 // File: contracts/WhiteListInterface.sol
196 
197 contract WhiteListInterface {
198     function getUserCapInWei(address user) external view returns (uint userCapWei);
199 }
200 
201 // File: contracts/PermissionGroups.sol
202 
203 contract PermissionGroups {
204 
205     address public admin;
206     address public pendingAdmin;
207     mapping(address=>bool) internal operators;
208     mapping(address=>bool) internal alerters;
209     address[] internal operatorsGroup;
210     address[] internal alertersGroup;
211     uint constant internal MAX_GROUP_SIZE = 50;
212 
213     function PermissionGroups() public {
214         admin = msg.sender;
215     }
216 
217     modifier onlyAdmin() {
218         require(msg.sender == admin);
219         _;
220     }
221 
222     modifier onlyOperator() {
223         require(operators[msg.sender]);
224         _;
225     }
226 
227     modifier onlyAlerter() {
228         require(alerters[msg.sender]);
229         _;
230     }
231 
232     function getOperators () external view returns(address[]) {
233         return operatorsGroup;
234     }
235 
236     function getAlerters () external view returns(address[]) {
237         return alertersGroup;
238     }
239 
240     event TransferAdminPending(address pendingAdmin);
241 
242     /**
243      * @dev Allows the current admin to set the pendingAdmin address.
244      * @param newAdmin The address to transfer ownership to.
245      */
246     function transferAdmin(address newAdmin) public onlyAdmin {
247         require(newAdmin != address(0));
248         TransferAdminPending(pendingAdmin);
249         pendingAdmin = newAdmin;
250     }
251 
252     /**
253      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
254      * @param newAdmin The address to transfer ownership to.
255      */
256     function transferAdminQuickly(address newAdmin) public onlyAdmin {
257         require(newAdmin != address(0));
258         TransferAdminPending(newAdmin);
259         AdminClaimed(newAdmin, admin);
260         admin = newAdmin;
261     }
262 
263     event AdminClaimed( address newAdmin, address previousAdmin);
264 
265     /**
266      * @dev Allows the pendingAdmin address to finalize the change admin process.
267      */
268     function claimAdmin() public {
269         require(pendingAdmin == msg.sender);
270         AdminClaimed(pendingAdmin, admin);
271         admin = pendingAdmin;
272         pendingAdmin = address(0);
273     }
274 
275     event AlerterAdded (address newAlerter, bool isAdd);
276 
277     function addAlerter(address newAlerter) public onlyAdmin {
278         require(!alerters[newAlerter]); // prevent duplicates.
279         require(alertersGroup.length < MAX_GROUP_SIZE);
280 
281         AlerterAdded(newAlerter, true);
282         alerters[newAlerter] = true;
283         alertersGroup.push(newAlerter);
284     }
285 
286     function removeAlerter (address alerter) public onlyAdmin {
287         require(alerters[alerter]);
288         alerters[alerter] = false;
289 
290         for (uint i = 0; i < alertersGroup.length; ++i) {
291             if (alertersGroup[i] == alerter) {
292                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
293                 alertersGroup.length--;
294                 AlerterAdded(alerter, false);
295                 break;
296             }
297         }
298     }
299 
300     event OperatorAdded(address newOperator, bool isAdd);
301 
302     function addOperator(address newOperator) public onlyAdmin {
303         require(!operators[newOperator]); // prevent duplicates.
304         require(operatorsGroup.length < MAX_GROUP_SIZE);
305 
306         OperatorAdded(newOperator, true);
307         operators[newOperator] = true;
308         operatorsGroup.push(newOperator);
309     }
310 
311     function removeOperator (address operator) public onlyAdmin {
312         require(operators[operator]);
313         operators[operator] = false;
314 
315         for (uint i = 0; i < operatorsGroup.length; ++i) {
316             if (operatorsGroup[i] == operator) {
317                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
318                 operatorsGroup.length -= 1;
319                 OperatorAdded(operator, false);
320                 break;
321             }
322         }
323     }
324 }
325 
326 // File: contracts/Withdrawable.sol
327 
328 /**
329  * @title Contracts that should be able to recover tokens or ethers
330  * @author Ilan Doron
331  * @dev This allows to recover any tokens or Ethers received in a contract.
332  * This will prevent any accidental loss of tokens.
333  */
334 contract Withdrawable is PermissionGroups {
335 
336     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
337 
338     /**
339      * @dev Withdraw all ERC20 compatible tokens
340      * @param token ERC20 The address of the token contract
341      */
342     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
343         require(token.transfer(sendTo, amount));
344         TokenWithdraw(token, amount, sendTo);
345     }
346 
347     event EtherWithdraw(uint amount, address sendTo);
348 
349     /**
350      * @dev Withdraw Ethers
351      */
352     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
353         sendTo.transfer(amount);
354         EtherWithdraw(amount, sendTo);
355     }
356 }
357 
358 // File: contracts/KyberNetwork.sol
359 
360 ////////////////////////////////////////////////////////////////////////////////////////////////////////
361 /// @title Kyber Network main contract
362 contract KyberNetwork is Withdrawable, Utils2, KyberNetworkInterface {
363 
364     uint public negligibleRateDiff = 10; // basic rate steps will be in 0.01%
365     KyberReserveInterface[] public reserves;
366     mapping(address=>bool) public isReserve;
367     WhiteListInterface public whiteListContract;
368     ExpectedRateInterface public expectedRateContract;
369     FeeBurnerInterface    public feeBurnerContract;
370     address               public kyberNetworkProxyContract;
371     uint                  public maxGasPriceValue = 50 * 1000 * 1000 * 1000; // 50 gwei
372     bool                  public isEnabled = false; // network is enabled
373     mapping(bytes32=>uint) public infoFields; // this is only a UI field for external app.
374     mapping(address=>address[]) public reservesPerTokenSrc; //reserves supporting token to eth
375     mapping(address=>address[]) public reservesPerTokenDest;//reserves support eth to token
376 
377     function KyberNetwork(address _admin) public {
378         require(_admin != address(0));
379         admin = _admin;
380     }
381 
382     event EtherReceival(address indexed sender, uint amount);
383 
384     /* solhint-disable no-complex-fallback */
385     // To avoid users trying to swap tokens using default payable function. We added this short code
386     //  to verify Ethers will be received only from reserves if transferred without a specific function call.
387     function() public payable {
388         require(isReserve[msg.sender]);
389         EtherReceival(msg.sender, msg.value);
390     }
391     /* solhint-enable no-complex-fallback */
392 
393     struct TradeInput {
394         address trader;
395         ERC20 src;
396         uint srcAmount;
397         ERC20 dest;
398         address destAddress;
399         uint maxDestAmount;
400         uint minConversionRate;
401         address walletId;
402         bytes hint;
403     }
404 
405     function tradeWithHint(
406         address trader,
407         ERC20 src,
408         uint srcAmount,
409         ERC20 dest,
410         address destAddress,
411         uint maxDestAmount,
412         uint minConversionRate,
413         address walletId,
414         bytes hint
415     )
416         public
417         payable
418         returns(uint)
419     {
420         require(hint.length == 0);
421         require(msg.sender == kyberNetworkProxyContract);
422 
423         TradeInput memory tradeInput;
424 
425         tradeInput.trader = trader;
426         tradeInput.src = src;
427         tradeInput.srcAmount = srcAmount;
428         tradeInput.dest = dest;
429         tradeInput.destAddress = destAddress;
430         tradeInput.maxDestAmount = maxDestAmount;
431         tradeInput.minConversionRate = minConversionRate;
432         tradeInput.walletId = walletId;
433         tradeInput.hint = hint;
434 
435         return trade(tradeInput);
436     }
437 
438     event AddReserveToNetwork(KyberReserveInterface reserve, bool add);
439 
440     /// @notice can be called only by admin
441     /// @dev add or deletes a reserve to/from the network.
442     /// @param reserve The reserve address.
443     /// @param add If true, the add reserve. Otherwise delete reserve.
444     function addReserve(KyberReserveInterface reserve, bool add) public onlyAdmin {
445 
446         if (add) {
447             require(!isReserve[reserve]);
448             reserves.push(reserve);
449             isReserve[reserve] = true;
450             AddReserveToNetwork(reserve, true);
451         } else {
452             isReserve[reserve] = false;
453             // will have trouble if more than 50k reserves...
454             for (uint i = 0; i < reserves.length; i++) {
455                 if (reserves[i] == reserve) {
456                     reserves[i] = reserves[reserves.length - 1];
457                     reserves.length--;
458                     AddReserveToNetwork(reserve, false);
459                     break;
460                 }
461             }
462         }
463     }
464 
465     event ListReservePairs(address reserve, ERC20 src, ERC20 dest, bool add);
466 
467     /// @notice can be called only by admin
468     /// @dev allow or prevent a specific reserve to trade a pair of tokens
469     /// @param reserve The reserve address.
470     /// @param token token address
471     /// @param ethToToken will it support ether to token trade
472     /// @param tokenToEth will it support token to ether trade
473     /// @param add If true then list this pair, otherwise unlist it.
474     function listPairForReserve(address reserve, ERC20 token, bool ethToToken, bool tokenToEth, bool add)
475         public onlyAdmin
476     {
477         require(isReserve[reserve]);
478 
479         if (ethToToken) {
480             listPairs(reserve, token, false, add);
481 
482             ListReservePairs(reserve, ETH_TOKEN_ADDRESS, token, add);
483         }
484 
485         if (tokenToEth) {
486             listPairs(reserve, token, true, add);
487             if (add) {
488                 token.approve(reserve, 2**255); // approve infinity
489             } else {
490                 token.approve(reserve, 0);
491             }
492 
493             ListReservePairs(reserve, token, ETH_TOKEN_ADDRESS, add);
494         }
495 
496         setDecimals(token);
497     }
498 
499     function setWhiteList(WhiteListInterface whiteList) public onlyAdmin {
500         require(whiteList != address(0));
501         whiteListContract = whiteList;
502     }
503 
504     function setExpectedRate(ExpectedRateInterface expectedRate) public onlyAdmin {
505         require(expectedRate != address(0));
506         expectedRateContract = expectedRate;
507     }
508 
509     function setFeeBurner(FeeBurnerInterface feeBurner) public onlyAdmin {
510         require(feeBurner != address(0));
511         feeBurnerContract = feeBurner;
512     }
513 
514     function setParams(
515         uint                  _maxGasPrice,
516         uint                  _negligibleRateDiff
517     )
518         public
519         onlyAdmin
520     {
521         require(_negligibleRateDiff <= 100 * 100); // at most 100%
522 
523         maxGasPriceValue = _maxGasPrice;
524         negligibleRateDiff = _negligibleRateDiff;
525     }
526 
527     function setEnable(bool _enable) public onlyAdmin {
528         if (_enable) {
529             require(whiteListContract != address(0));
530             require(feeBurnerContract != address(0));
531             require(expectedRateContract != address(0));
532             require(kyberNetworkProxyContract != address(0));
533         }
534         isEnabled = _enable;
535     }
536 
537     function setInfo(bytes32 field, uint value) public onlyOperator {
538         infoFields[field] = value;
539     }
540 
541     event KyberProxySet(address proxy, address sender);
542 
543     function setKyberProxy(address networkProxy) public onlyAdmin {
544         require(networkProxy != address(0));
545         kyberNetworkProxyContract = networkProxy;
546         KyberProxySet(kyberNetworkProxyContract, msg.sender);
547     }
548 
549     /// @dev returns number of reserves
550     /// @return number of reserves
551     function getNumReserves() public view returns(uint) {
552         return reserves.length;
553     }
554 
555     /// @notice should be called off chain with as much gas as needed
556     /// @dev get an array of all reserves
557     /// @return An array of all reserves
558     function getReserves() public view returns(KyberReserveInterface[]) {
559         return reserves;
560     }
561 
562     function maxGasPrice() public view returns(uint) {
563         return maxGasPriceValue;
564     }
565 
566     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
567         public view
568         returns(uint expectedRate, uint slippageRate)
569     {
570         require(expectedRateContract != address(0));
571         return expectedRateContract.getExpectedRate(src, dest, srcQty);
572     }
573 
574     function getUserCapInWei(address user) public view returns(uint) {
575         return whiteListContract.getUserCapInWei(user);
576     }
577 
578     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint) {
579         //future feature
580         user;
581         token;
582         require(false);
583     }
584 
585     struct BestRateResult {
586         uint rate;
587         address reserve1;
588         address reserve2;
589         uint weiAmount;
590         uint rateSrcToEth;
591         uint rateEthToDest;
592         uint destAmount;
593     }
594 
595     /// @notice use token address ETH_TOKEN_ADDRESS for ether
596     /// @dev best conversion rate for a pair of tokens, if number of reserves have small differences. randomize
597     /// @param src Src token
598     /// @param dest Destination token
599     /// @return obsolete - used to return best reserve index. not relevant anymore for this API.
600     function findBestRate(ERC20 src, ERC20 dest, uint srcAmount) public view returns(uint obsolete, uint rate) {
601         BestRateResult memory result = findBestRateTokenToToken(src, dest, srcAmount);
602         return(0, result.rate);
603     }
604 
605     function enabled() public view returns(bool) {
606         return isEnabled;
607     }
608 
609     function info(bytes32 field) public view returns(uint) {
610         return infoFields[field];
611     }
612 
613     /* solhint-disable code-complexity */
614     // Not sure how solhing defines complexity. Anyway, from our point of view, below code follows the required
615     //  algorithm to choose a reserve, it has been tested, reviewed and found to be clear enough.
616     //@dev this function always src or dest are ether. can't do token to token
617     function searchBestRate(ERC20 src, ERC20 dest, uint srcAmount) public view returns(address, uint) {
618         uint bestRate = 0;
619         uint bestReserve = 0;
620         uint numRelevantReserves = 0;
621 
622         //return 1 for ether to ether
623         if (src == dest) return (reserves[bestReserve], PRECISION);
624 
625         address[] memory reserveArr;
626 
627         if (src == ETH_TOKEN_ADDRESS) {
628             reserveArr = reservesPerTokenDest[dest];
629         } else {
630             reserveArr = reservesPerTokenSrc[src];
631         }
632 
633         if (reserveArr.length == 0) return (reserves[bestReserve], bestRate);
634 
635         uint[] memory rates = new uint[](reserveArr.length);
636         uint[] memory reserveCandidates = new uint[](reserveArr.length);
637 
638         for (uint i = 0; i < reserveArr.length; i++) {
639             //list all reserves that have this token.
640             rates[i] = (KyberReserveInterface(reserveArr[i])).getConversionRate(src, dest, srcAmount, block.number);
641 
642             if (rates[i] > bestRate) {
643                 //best rate is highest rate
644                 bestRate = rates[i];
645             }
646         }
647 
648         if (bestRate > 0) {
649             uint random = 0;
650             uint smallestRelevantRate = (bestRate * 10000) / (10000 + negligibleRateDiff);
651 
652             for (i = 0; i < reserveArr.length; i++) {
653                 if (rates[i] >= smallestRelevantRate) {
654                     reserveCandidates[numRelevantReserves++] = i;
655                 }
656             }
657 
658             if (numRelevantReserves > 1) {
659                 //when encountering small rate diff from bestRate. draw from relevant reserves
660                 random = uint(block.blockhash(block.number-1)) % numRelevantReserves;
661             }
662 
663             bestReserve = reserveCandidates[random];
664             bestRate = rates[bestReserve];
665         }
666 
667         return (reserveArr[bestReserve], bestRate);
668     }
669     /* solhint-enable code-complexity */
670 
671     function findBestRateTokenToToken(ERC20 src, ERC20 dest, uint srcAmount) internal view
672         returns(BestRateResult result)
673     {
674         (result.reserve1, result.rateSrcToEth) = searchBestRate(src, ETH_TOKEN_ADDRESS, srcAmount);
675         result.weiAmount = calcDestAmount(src, ETH_TOKEN_ADDRESS, srcAmount, result.rateSrcToEth);
676 
677         (result.reserve2, result.rateEthToDest) = searchBestRate(ETH_TOKEN_ADDRESS, dest, result.weiAmount);
678         result.destAmount = calcDestAmount(ETH_TOKEN_ADDRESS, dest, result.weiAmount, result.rateEthToDest);
679 
680         result.rate = calcRateFromQty(srcAmount, result.destAmount, getDecimals(src), getDecimals(dest));
681     }
682 
683     function listPairs(address reserve, ERC20 token, bool isTokenToEth, bool add) internal {
684         uint i;
685         address[] storage reserveArr = reservesPerTokenDest[token];
686 
687         if (isTokenToEth) {
688             reserveArr = reservesPerTokenSrc[token];
689         }
690 
691         for (i = 0; i < reserveArr.length; i++) {
692             if (reserve == reserveArr[i]) {
693                 if (add) {
694                     break; //already added
695                 } else {
696                     //remove
697                     reserveArr[i] = reserveArr[reserveArr.length - 1];
698                     reserveArr.length--;
699                 }
700             }
701         }
702 
703         if (add && i == reserveArr.length) {
704             //if reserve wasn't found add it
705             reserveArr.push(reserve);
706         }
707     }
708 
709     event KyberTrade(address srcAddress, ERC20 srcToken, uint srcAmount, address destAddress, ERC20 destToken,
710         uint destAmount);
711     /* solhint-disable function-max-lines */
712     // Most of the lins here are functions calls spread over multiple lines. We find this function readable enough
713     //  and keep its size as is.
714     /// @notice use token address ETH_TOKEN_ADDRESS for ether
715     /// @dev trade api for kyber network.
716     /// @param tradeInput structure of trade inputs
717     function trade(TradeInput tradeInput) internal returns(uint) {
718         require(isEnabled);
719         require(tx.gasprice <= maxGasPriceValue);
720         require(validateTradeInput(tradeInput.src, tradeInput.srcAmount, tradeInput.dest, tradeInput.destAddress));
721 
722         BestRateResult memory rateResult =
723         findBestRateTokenToToken(tradeInput.src, tradeInput.dest, tradeInput.srcAmount);
724 
725         require(rateResult.rate > 0);
726         require(rateResult.rate < MAX_RATE);
727         require(rateResult.rate >= tradeInput.minConversionRate);
728 
729         uint actualDestAmount;
730         uint weiAmount;
731         uint actualSrcAmount;
732 
733         (actualSrcAmount, weiAmount, actualDestAmount) = calcActualAmounts(tradeInput.src,
734             tradeInput.dest,
735             tradeInput.srcAmount,
736             tradeInput.maxDestAmount,
737             rateResult);
738 
739         if (actualSrcAmount < tradeInput.srcAmount) {
740             //if there is "change" send back to trader
741             if (tradeInput.src == ETH_TOKEN_ADDRESS) {
742                 tradeInput.trader.transfer(tradeInput.srcAmount - actualSrcAmount);
743             } else {
744                 tradeInput.src.transfer(tradeInput.trader, (tradeInput.srcAmount - actualSrcAmount));
745             }
746         }
747 
748         // verify trade size is smaller than user cap
749         require(weiAmount <= getUserCapInWei(tradeInput.trader));
750 
751         //do the trade
752         //src to ETH
753         require(doReserveTrade(
754                 tradeInput.src,
755                 actualSrcAmount,
756                 ETH_TOKEN_ADDRESS,
757                 this,
758                 weiAmount,
759                 KyberReserveInterface(rateResult.reserve1),
760                 rateResult.rateSrcToEth,
761                 true));
762 
763         //Eth to dest
764         require(doReserveTrade(
765                 ETH_TOKEN_ADDRESS,
766                 weiAmount,
767                 tradeInput.dest,
768                 tradeInput.destAddress,
769                 actualDestAmount,
770                 KyberReserveInterface(rateResult.reserve2),
771                 rateResult.rateEthToDest,
772                 true));
773 
774         //when src is ether, reserve1 is doing a "fake" trade. (ether to ether) - don't burn.
775         //when dest is ether, reserve2 is doing a "fake" trade. (ether to ether) - don't burn.
776         if (tradeInput.src != ETH_TOKEN_ADDRESS)
777             require(feeBurnerContract.handleFees(weiAmount, rateResult.reserve1, tradeInput.walletId));
778         if (tradeInput.dest != ETH_TOKEN_ADDRESS)
779             require(feeBurnerContract.handleFees(weiAmount, rateResult.reserve2, tradeInput.walletId));
780 
781         KyberTrade(tradeInput.trader, tradeInput.src, actualSrcAmount, tradeInput.destAddress, tradeInput.dest,
782             actualDestAmount);
783 
784         return actualDestAmount;
785     }
786     /* solhint-enable function-max-lines */
787 
788     function calcActualAmounts (ERC20 src, ERC20 dest, uint srcAmount, uint maxDestAmount, BestRateResult rateResult)
789         internal view returns(uint actualSrcAmount, uint weiAmount, uint actualDestAmount)
790     {
791         if (rateResult.destAmount > maxDestAmount) {
792             actualDestAmount = maxDestAmount;
793             weiAmount = calcSrcAmount(ETH_TOKEN_ADDRESS, dest, actualDestAmount, rateResult.rateEthToDest);
794             actualSrcAmount = calcSrcAmount(src, ETH_TOKEN_ADDRESS, weiAmount, rateResult.rateSrcToEth);
795             require(actualSrcAmount <= srcAmount);
796         } else {
797             actualDestAmount = rateResult.destAmount;
798             actualSrcAmount = srcAmount;
799             weiAmount = rateResult.weiAmount;
800         }
801     }
802 
803     /// @notice use token address ETH_TOKEN_ADDRESS for ether
804     /// @dev do one trade with a reserve
805     /// @param src Src token
806     /// @param amount amount of src tokens
807     /// @param dest   Destination token
808     /// @param destAddress Address to send tokens to
809     /// @param reserve Reserve to use
810     /// @param validate If true, additional validations are applicable
811     /// @return true if trade is successful
812     function doReserveTrade(
813         ERC20 src,
814         uint amount,
815         ERC20 dest,
816         address destAddress,
817         uint expectedDestAmount,
818         KyberReserveInterface reserve,
819         uint conversionRate,
820         bool validate
821     )
822         internal
823         returns(bool)
824     {
825         uint callValue = 0;
826 
827         if (src == dest) {
828             //this is for a "fake" trade when both src and dest are ethers.
829             if (destAddress != (address(this)))
830                 destAddress.transfer(amount);
831             return true;
832         }
833 
834         if (src == ETH_TOKEN_ADDRESS) {
835             callValue = amount;
836         }
837 
838         // reserve sends tokens/eth to network. network sends it to destination
839         require(reserve.trade.value(callValue)(src, amount, dest, this, conversionRate, validate));
840 
841         if (destAddress != address(this)) {
842             //for token to token dest address is network. and Ether / token already here...
843             if (dest == ETH_TOKEN_ADDRESS) {
844                 destAddress.transfer(expectedDestAmount);
845             } else {
846                 require(dest.transfer(destAddress, expectedDestAmount));
847             }
848         }
849 
850         return true;
851     }
852 
853     /// @notice use token address ETH_TOKEN_ADDRESS for ether
854     /// @dev checks that user sent ether/tokens to contract before trade
855     /// @param src Src token
856     /// @param srcAmount amount of src tokens
857     /// @return true if tradeInput is valid
858     function validateTradeInput(ERC20 src, uint srcAmount, ERC20 dest, address destAddress)
859         internal
860         view
861         returns(bool)
862     {
863         require(srcAmount <= MAX_QTY);
864         require(srcAmount != 0);
865         require(destAddress != address(0));
866         require(src != dest);
867 
868         if (src == ETH_TOKEN_ADDRESS) {
869             require(msg.value == srcAmount);
870         } else {
871             require(msg.value == 0);
872             //funds should have been moved to this contract already.
873             require(src.balanceOf(this) >= srcAmount);
874         }
875 
876         return true;
877     }
878 }