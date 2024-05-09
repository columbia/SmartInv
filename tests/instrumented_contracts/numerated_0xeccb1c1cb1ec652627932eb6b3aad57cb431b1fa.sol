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
14 interface ExpectedRateInterface {
15     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
16         returns (uint expectedRate, uint slippageRate);
17 }
18 
19 interface KyberReserveInterface {
20 
21     function trade(
22         ERC20 srcToken,
23         uint srcAmount,
24         ERC20 destToken,
25         address destAddress,
26         uint conversionRate,
27         bool validate
28     )
29         public
30         payable
31         returns(bool);
32 
33     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
34 }
35 
36 contract PermissionGroups {
37 
38     address public admin;
39     address public pendingAdmin;
40     mapping(address=>bool) internal operators;
41     mapping(address=>bool) internal alerters;
42     address[] internal operatorsGroup;
43     address[] internal alertersGroup;
44     uint constant internal MAX_GROUP_SIZE = 50;
45 
46     function PermissionGroups() public {
47         admin = msg.sender;
48     }
49 
50     modifier onlyAdmin() {
51         require(msg.sender == admin);
52         _;
53     }
54 
55     modifier onlyOperator() {
56         require(operators[msg.sender]);
57         _;
58     }
59 
60     modifier onlyAlerter() {
61         require(alerters[msg.sender]);
62         _;
63     }
64 
65     function getOperators () external view returns(address[]) {
66         return operatorsGroup;
67     }
68 
69     function getAlerters () external view returns(address[]) {
70         return alertersGroup;
71     }
72 
73     event TransferAdminPending(address pendingAdmin);
74 
75     /**
76      * @dev Allows the current admin to set the pendingAdmin address.
77      * @param newAdmin The address to transfer ownership to.
78      */
79     function transferAdmin(address newAdmin) public onlyAdmin {
80         require(newAdmin != address(0));
81         TransferAdminPending(pendingAdmin);
82         pendingAdmin = newAdmin;
83     }
84 
85     /**
86      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
87      * @param newAdmin The address to transfer ownership to.
88      */
89     function transferAdminQuickly(address newAdmin) public onlyAdmin {
90         require(newAdmin != address(0));
91         TransferAdminPending(newAdmin);
92         AdminClaimed(newAdmin, admin);
93         admin = newAdmin;
94     }
95 
96     event AdminClaimed( address newAdmin, address previousAdmin);
97 
98     /**
99      * @dev Allows the pendingAdmin address to finalize the change admin process.
100      */
101     function claimAdmin() public {
102         require(pendingAdmin == msg.sender);
103         AdminClaimed(pendingAdmin, admin);
104         admin = pendingAdmin;
105         pendingAdmin = address(0);
106     }
107 
108     event AlerterAdded (address newAlerter, bool isAdd);
109 
110     function addAlerter(address newAlerter) public onlyAdmin {
111         require(!alerters[newAlerter]); // prevent duplicates.
112         require(alertersGroup.length < MAX_GROUP_SIZE);
113 
114         AlerterAdded(newAlerter, true);
115         alerters[newAlerter] = true;
116         alertersGroup.push(newAlerter);
117     }
118 
119     function removeAlerter (address alerter) public onlyAdmin {
120         require(alerters[alerter]);
121         alerters[alerter] = false;
122 
123         for (uint i = 0; i < alertersGroup.length; ++i) {
124             if (alertersGroup[i] == alerter) {
125                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
126                 alertersGroup.length--;
127                 AlerterAdded(alerter, false);
128                 break;
129             }
130         }
131     }
132 
133     event OperatorAdded(address newOperator, bool isAdd);
134 
135     function addOperator(address newOperator) public onlyAdmin {
136         require(!operators[newOperator]); // prevent duplicates.
137         require(operatorsGroup.length < MAX_GROUP_SIZE);
138 
139         OperatorAdded(newOperator, true);
140         operators[newOperator] = true;
141         operatorsGroup.push(newOperator);
142     }
143 
144     function removeOperator (address operator) public onlyAdmin {
145         require(operators[operator]);
146         operators[operator] = false;
147 
148         for (uint i = 0; i < operatorsGroup.length; ++i) {
149             if (operatorsGroup[i] == operator) {
150                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
151                 operatorsGroup.length -= 1;
152                 OperatorAdded(operator, false);
153                 break;
154             }
155         }
156     }
157 }
158 
159 contract Withdrawable is PermissionGroups {
160 
161     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
162 
163     /**
164      * @dev Withdraw all ERC20 compatible tokens
165      * @param token ERC20 The address of the token contract
166      */
167     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
168         require(token.transfer(sendTo, amount));
169         TokenWithdraw(token, amount, sendTo);
170     }
171 
172     event EtherWithdraw(uint amount, address sendTo);
173 
174     /**
175      * @dev Withdraw Ethers
176      */
177     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
178         sendTo.transfer(amount);
179         EtherWithdraw(amount, sendTo);
180     }
181 }
182 
183 contract Utils {
184 
185     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
186     uint  constant internal PRECISION = (10**18);
187     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
188     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
189     uint  constant internal MAX_DECIMALS = 18;
190     uint  constant internal ETH_DECIMALS = 18;
191     mapping(address=>uint) internal decimals;
192 
193     function setDecimals(ERC20 token) internal {
194         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
195         else decimals[token] = token.decimals();
196     }
197 
198     function getDecimals(ERC20 token) internal view returns(uint) {
199         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
200         uint tokenDecimals = decimals[token];
201         // technically, there might be token with decimals 0
202         // moreover, very possible that old tokens have decimals 0
203         // these tokens will just have higher gas fees.
204         if(tokenDecimals == 0) return token.decimals();
205 
206         return tokenDecimals;
207     }
208 
209     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
210         require(srcQty <= MAX_QTY);
211         require(rate <= MAX_RATE);
212 
213         if (dstDecimals >= srcDecimals) {
214             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
215             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
216         } else {
217             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
218             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
219         }
220     }
221 
222     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
223         require(dstQty <= MAX_QTY);
224         require(rate <= MAX_RATE);
225 
226         //source quantity is rounded up. to avoid dest quantity being too low.
227         uint numerator;
228         uint denominator;
229         if (srcDecimals >= dstDecimals) {
230             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
231             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
232             denominator = rate;
233         } else {
234             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
235             numerator = (PRECISION * dstQty);
236             denominator = (rate * (10**(dstDecimals - srcDecimals)));
237         }
238         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
239     }
240 }
241 
242 contract KyberNetwork is Withdrawable, Utils {
243 
244     uint public negligibleRateDiff = 10; // basic rate steps will be in 0.01%
245     KyberReserveInterface[] public reserves;
246     mapping(address=>bool) public isReserve;
247     WhiteListInterface public whiteListContract;
248     ExpectedRateInterface public expectedRateContract;
249     FeeBurnerInterface    public feeBurnerContract;
250     uint                  public maxGasPrice = 50 * 1000 * 1000 * 1000; // 50 gwei
251     bool                  public enabled = false; // network is enabled
252     uint                  public networkState; // this is only a field for UI.
253     mapping(address=>mapping(bytes32=>bool)) public perReserveListedPairs;
254 
255     function KyberNetwork(address _admin) public {
256         require(_admin != address(0));
257         admin = _admin;
258     }
259 
260     event EtherReceival(address indexed sender, uint amount);
261 
262     /* solhint-disable no-complex-fallback */
263     function() public payable {
264         require(isReserve[msg.sender]);
265         EtherReceival(msg.sender, msg.value);
266     }
267     /* solhint-enable no-complex-fallback */
268 
269     event ExecuteTrade(address indexed sender, ERC20 src, ERC20 dest, uint actualSrcAmount, uint actualDestAmount);
270 
271     /// @notice use token address ETH_TOKEN_ADDRESS for ether
272     /// @dev makes a trade between src and dest token and send dest token to destAddress
273     /// @param src Src token
274     /// @param srcAmount amount of src tokens
275     /// @param dest   Destination token
276     /// @param destAddress Address to send tokens to
277     /// @param maxDestAmount A limit on the amount of dest tokens
278     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
279     /// @param walletId is the wallet ID to send part of the fees
280     /// @return amount of actual dest tokens
281     function trade(
282         ERC20 src,
283         uint srcAmount,
284         ERC20 dest,
285         address destAddress,
286         uint maxDestAmount,
287         uint minConversionRate,
288         address walletId
289     )
290         public
291         payable
292         returns(uint)
293     {
294         require(enabled);
295 
296         uint userSrcBalanceBefore;
297         uint userSrcBalanceAfter;
298         uint userDestBalanceBefore;
299         uint userDestBalanceAfter;
300 
301         userSrcBalanceBefore = getBalance(src, msg.sender);
302         if (src == ETH_TOKEN_ADDRESS)
303             userSrcBalanceBefore += msg.value;
304         userDestBalanceBefore = getBalance(dest, destAddress);
305 
306         uint actualDestAmount = doTrade(src,
307                                         srcAmount,
308                                         dest,
309                                         destAddress,
310                                         maxDestAmount,
311                                         minConversionRate,
312                                         walletId
313                                         );
314         require(actualDestAmount > 0);
315 
316         userSrcBalanceAfter = getBalance(src, msg.sender);
317         userDestBalanceAfter = getBalance(dest, destAddress);
318 
319         require(userSrcBalanceAfter <= userSrcBalanceBefore);
320         require(userDestBalanceAfter >= userDestBalanceBefore);
321 
322         require((userDestBalanceAfter - userDestBalanceBefore) >=
323             calcDstQty((userSrcBalanceBefore - userSrcBalanceAfter), getDecimals(src), getDecimals(dest),
324                 minConversionRate));
325 
326         return actualDestAmount;
327     }
328 
329     event AddReserveToNetwork(KyberReserveInterface reserve, bool add);
330 
331     /// @notice can be called only by admin
332     /// @dev add or deletes a reserve to/from the network.
333     /// @param reserve The reserve address.
334     /// @param add If true, the add reserve. Otherwise delete reserve.
335     function addReserve(KyberReserveInterface reserve, bool add) public onlyAdmin {
336 
337         if (add) {
338             require(!isReserve[reserve]);
339             reserves.push(reserve);
340             isReserve[reserve] = true;
341             AddReserveToNetwork(reserve, true);
342         } else {
343             isReserve[reserve] = false;
344             // will have trouble if more than 50k reserves...
345             for (uint i = 0; i < reserves.length; i++) {
346                 if (reserves[i] == reserve) {
347                     reserves[i] = reserves[reserves.length - 1];
348                     reserves.length--;
349                     AddReserveToNetwork(reserve, false);
350                     break;
351                 }
352             }
353         }
354     }
355 
356     event ListReservePairs(address reserve, ERC20 src, ERC20 dest, bool add);
357 
358     /// @notice can be called only by admin
359     /// @dev allow or prevent a specific reserve to trade a pair of tokens
360     /// @param reserve The reserve address.
361     /// @param src Src token
362     /// @param dest Destination token
363     /// @param add If true then enable trade, otherwise delist pair.
364     function listPairForReserve(address reserve, ERC20 src, ERC20 dest, bool add) public onlyAdmin {
365         (perReserveListedPairs[reserve])[keccak256(src, dest)] = add;
366 
367         if (src != ETH_TOKEN_ADDRESS) {
368             if (add) {
369                 src.approve(reserve, 2**255); // approve infinity
370             } else {
371                 src.approve(reserve, 0);
372             }
373         }
374 
375         setDecimals(src);
376         setDecimals(dest);
377 
378         ListReservePairs(reserve, src, dest, add);
379     }
380 
381     function setParams(
382         WhiteListInterface    _whiteList,
383         ExpectedRateInterface _expectedRate,
384         FeeBurnerInterface    _feeBurner,
385         uint                  _maxGasPrice,
386         uint                  _negligibleRateDiff
387     )
388         public
389         onlyAdmin
390     {
391         require(_whiteList != address(0));
392         require(_feeBurner != address(0));
393         require(_expectedRate != address(0));
394         whiteListContract = _whiteList;
395         expectedRateContract = _expectedRate;
396         feeBurnerContract = _feeBurner;
397         maxGasPrice = _maxGasPrice;
398         negligibleRateDiff = _negligibleRateDiff;
399     }
400 
401     function setEnable(bool _enable) public onlyAdmin {
402         if (_enable) {
403             require(whiteListContract != address(0));
404             require(feeBurnerContract != address(0));
405             require(expectedRateContract != address(0));
406         }
407         enabled = _enable;
408     }
409 
410     function setNetworkState(uint _networkState) public onlyOperator {
411         networkState = _networkState;
412     }
413 
414     /// @dev returns number of reserves
415     /// @return number of reserves
416     function getNumReserves() public view returns(uint) {
417         return reserves.length;
418     }
419 
420     /// @notice should be called off chain with as much gas as needed
421     /// @dev get an array of all reserves
422     /// @return An array of all reserves
423     function getReserves() public view returns(KyberReserveInterface[]) {
424         return reserves;
425     }
426 
427     /// @dev get the balance of a user.
428     /// @param token The token type
429     /// @return The balance
430     function getBalance(ERC20 token, address user) public view returns(uint) {
431         if (token == ETH_TOKEN_ADDRESS)
432             return user.balance;
433         else
434             return token.balanceOf(user);
435     }
436 
437     /// @notice use token address ETH_TOKEN_ADDRESS for ether
438     /// @dev best conversion rate for a pair of tokens, if number of reserves have small differences. randomize
439     /// @param src Src token
440     /// @param dest Destination token
441     /* solhint-disable code-complexity */
442     function findBestRate(ERC20 src, ERC20 dest, uint srcQty) public view returns(uint, uint) {
443         uint bestRate = 0;
444         uint bestReserve = 0;
445         uint numRelevantReserves = 0;
446         uint numReserves = reserves.length;
447         uint[] memory rates = new uint[](numReserves);
448         uint[] memory reserveCandidates = new uint[](numReserves);
449 
450         for (uint i = 0; i < numReserves; i++) {
451             //list all reserves that have this token.
452             if (!(perReserveListedPairs[reserves[i]])[keccak256(src, dest)]) continue;
453 
454             rates[i] = reserves[i].getConversionRate(src, dest, srcQty, block.number);
455 
456             if (rates[i] > bestRate) {
457                 //best rate is highest rate
458                 bestRate = rates[i];
459             }
460         }
461 
462         if (bestRate > 0) {
463             uint random = 0;
464             uint smallestRelevantRate = (bestRate * 10000) / (10000 + negligibleRateDiff);
465 
466             for (i = 0; i < numReserves; i++) {
467                 if (rates[i] >= smallestRelevantRate) {
468                     reserveCandidates[numRelevantReserves++] = i;
469                 }
470             }
471 
472             if (numRelevantReserves > 1) {
473                 //when encountering small rate diff from bestRate. draw from relevant reserves
474                 random = uint(block.blockhash(block.number-1)) % numRelevantReserves;
475             }
476 
477             bestReserve = reserveCandidates[random];
478             bestRate = rates[bestReserve];
479         }
480 
481         return (bestReserve, bestRate);
482     }
483     /* solhint-enable code-complexity */
484 
485     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
486         public view
487         returns (uint expectedRate, uint slippageRate)
488     {
489         require(expectedRateContract != address(0));
490         return expectedRateContract.getExpectedRate(src, dest, srcQty);
491     }
492 
493     function getUserCapInWei(address user) public view returns(uint) {
494         return whiteListContract.getUserCapInWei(user);
495     }
496 
497     function doTrade(
498         ERC20 src,
499         uint srcAmount,
500         ERC20 dest,
501         address destAddress,
502         uint maxDestAmount,
503         uint minConversionRate,
504         address walletId
505     )
506         internal
507         returns(uint)
508     {
509         require(tx.gasprice <= maxGasPrice);
510         require(validateTradeInput(src, srcAmount, destAddress));
511 
512         uint reserveInd;
513         uint rate;
514 
515         (reserveInd, rate) = findBestRate(src, dest, srcAmount);
516         KyberReserveInterface theReserve = reserves[reserveInd];
517         require(rate > 0);
518         require(rate < MAX_RATE);
519         require(rate >= minConversionRate);
520 
521         uint actualSrcAmount = srcAmount;
522         uint actualDestAmount = calcDestAmount(src, dest, actualSrcAmount, rate);
523         if (actualDestAmount > maxDestAmount) {
524             actualDestAmount = maxDestAmount;
525             actualSrcAmount = calcSrcAmount(src, dest, actualDestAmount, rate);
526             require(actualSrcAmount <= srcAmount);
527         }
528 
529         // do the trade
530         // verify trade size is smaller than user cap
531         uint ethAmount;
532         if (src == ETH_TOKEN_ADDRESS) {
533             ethAmount = actualSrcAmount;
534         } else {
535             ethAmount = actualDestAmount;
536         }
537 
538         require(ethAmount <= getUserCapInWei(msg.sender));
539         require(doReserveTrade(
540                 src,
541                 actualSrcAmount,
542                 dest,
543                 destAddress,
544                 actualDestAmount,
545                 theReserve,
546                 rate,
547                 true));
548 
549         if ((actualSrcAmount < srcAmount) && (src == ETH_TOKEN_ADDRESS)) {
550             msg.sender.transfer(srcAmount - actualSrcAmount);
551         }
552 
553         require(feeBurnerContract.handleFees(ethAmount, theReserve, walletId));
554 
555         ExecuteTrade(msg.sender, src, dest, actualSrcAmount, actualDestAmount);
556         return actualDestAmount;
557     }
558 
559     /// @notice use token address ETH_TOKEN_ADDRESS for ether
560     /// @dev do one trade with a reserve
561     /// @param src Src token
562     /// @param amount amount of src tokens
563     /// @param dest   Destination token
564     /// @param destAddress Address to send tokens to
565     /// @param reserve Reserve to use
566     /// @param validate If true, additional validations are applicable
567     /// @return true if trade is successful
568     function doReserveTrade(
569         ERC20 src,
570         uint amount,
571         ERC20 dest,
572         address destAddress,
573         uint expectedDestAmount,
574         KyberReserveInterface reserve,
575         uint conversionRate,
576         bool validate
577     )
578         internal
579         returns(bool)
580     {
581         uint callValue = 0;
582 
583         if (src == ETH_TOKEN_ADDRESS) {
584             callValue = amount;
585         } else {
586             // take src tokens to this contract
587             src.transferFrom(msg.sender, this, amount);
588         }
589 
590         // reserve sends tokens/eth to network. network sends it to destination
591         require(reserve.trade.value(callValue)(src, amount, dest, this, conversionRate, validate));
592 
593         if (dest == ETH_TOKEN_ADDRESS) {
594             destAddress.transfer(expectedDestAmount);
595         } else {
596             require(dest.transfer(destAddress, expectedDestAmount));
597         }
598 
599         return true;
600     }
601 
602     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
603         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
604     }
605 
606     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
607         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
608     }
609 
610     /// @notice use token address ETH_TOKEN_ADDRESS for ether
611     /// @dev checks that user sent ether/tokens to contract before trade
612     /// @param src Src token
613     /// @param srcAmount amount of src tokens
614     /// @return true if input is valid
615     function validateTradeInput(ERC20 src, uint srcAmount, address destAddress) internal view returns(bool) {
616         if ((srcAmount >= MAX_QTY) || (srcAmount == 0) || (destAddress == 0))
617             return false;
618 
619         if (src == ETH_TOKEN_ADDRESS) {
620             if (msg.value != srcAmount)
621                 return false;
622         } else {
623             if ((msg.value != 0) || (src.allowance(msg.sender, this) < srcAmount))
624                 return false;
625         }
626 
627         return true;
628     }
629 }
630 
631 contract WhiteListInterface {
632     function getUserCapInWei(address user) external view returns (uint userCapWei);
633 }
634 
635 interface FeeBurnerInterface {
636     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
637 }