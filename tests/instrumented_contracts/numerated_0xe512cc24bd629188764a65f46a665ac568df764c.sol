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
79 interface FeeBurnerInterface {
80     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
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
94 contract WhiteListInterface {
95     function getUserCapInWei(address user) external view returns (uint userCapWei);
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
106 
107     function PermissionGroups() public {
108         admin = msg.sender;
109     }
110 
111     modifier onlyAdmin() {
112         require(msg.sender == admin);
113         _;
114     }
115 
116     modifier onlyOperator() {
117         require(operators[msg.sender]);
118         _;
119     }
120 
121     modifier onlyAlerter() {
122         require(alerters[msg.sender]);
123         _;
124     }
125 
126     function getOperators () external view returns(address[]) {
127         return operatorsGroup;
128     }
129 
130     function getAlerters () external view returns(address[]) {
131         return alertersGroup;
132     }
133 
134     event TransferAdminPending(address pendingAdmin);
135 
136     /**
137      * @dev Allows the current admin to set the pendingAdmin address.
138      * @param newAdmin The address to transfer ownership to.
139      */
140     function transferAdmin(address newAdmin) public onlyAdmin {
141         require(newAdmin != address(0));
142         TransferAdminPending(pendingAdmin);
143         pendingAdmin = newAdmin;
144     }
145 
146     event AdminClaimed( address newAdmin, address previousAdmin);
147 
148     /**
149      * @dev Allows the pendingAdmin address to finalize the change admin process.
150      */
151     function claimAdmin() public {
152         require(pendingAdmin == msg.sender);
153         AdminClaimed(pendingAdmin, admin);
154         admin = pendingAdmin;
155         pendingAdmin = address(0);
156     }
157 
158     event AlerterAdded (address newAlerter, bool isAdd);
159 
160     function addAlerter(address newAlerter) public onlyAdmin {
161         require(!alerters[newAlerter]); // prevent duplicates.
162         AlerterAdded(newAlerter, true);
163         alerters[newAlerter] = true;
164         alertersGroup.push(newAlerter);
165     }
166 
167     function removeAlerter (address alerter) public onlyAdmin {
168         require(alerters[alerter]);
169         alerters[alerter] = false;
170 
171         for (uint i = 0; i < alertersGroup.length; ++i) {
172             if (alertersGroup[i] == alerter) {
173                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
174                 alertersGroup.length--;
175                 AlerterAdded(alerter, false);
176                 break;
177             }
178         }
179     }
180 
181     event OperatorAdded(address newOperator, bool isAdd);
182 
183     function addOperator(address newOperator) public onlyAdmin {
184         require(!operators[newOperator]); // prevent duplicates.
185         OperatorAdded(newOperator, true);
186         operators[newOperator] = true;
187         operatorsGroup.push(newOperator);
188     }
189 
190     function removeOperator (address operator) public onlyAdmin {
191         require(operators[operator]);
192         operators[operator] = false;
193 
194         for (uint i = 0; i < operatorsGroup.length; ++i) {
195             if (operatorsGroup[i] == operator) {
196                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
197                 operatorsGroup.length -= 1;
198                 OperatorAdded(operator, false);
199                 break;
200             }
201         }
202     }
203 }
204 
205 contract Withdrawable is PermissionGroups {
206 
207     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
208 
209     /**
210      * @dev Withdraw all ERC20 compatible tokens
211      * @param token ERC20 The address of the token contract
212      */
213     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
214         require(token.transfer(sendTo, amount));
215         TokenWithdraw(token, amount, sendTo);
216     }
217 
218     event EtherWithdraw(uint amount, address sendTo);
219 
220     /**
221      * @dev Withdraw Ethers
222      */
223     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
224         sendTo.transfer(amount);
225         EtherWithdraw(amount, sendTo);
226     }
227 }
228 
229 interface ExpectedRateInterface {
230     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
231         returns (uint expectedRate, uint slippageRate);
232 }
233 
234 contract ExpectedRate is Withdrawable, ExpectedRateInterface {
235 
236     KyberNetwork public kyberNetwork;
237     uint public quantityFactor = 2;
238     uint public minSlippageFactorInBps = 50;
239 
240     function ExpectedRate(KyberNetwork _kyberNetwork, address _admin) public {
241         require(_admin != address(0));
242         require(_kyberNetwork != address(0));
243         kyberNetwork = _kyberNetwork;
244         admin = _admin;
245     }
246 
247     event QuantityFactorSet (uint newFactor, uint oldFactor, address sender);
248 
249     function setQuantityFactor(uint newFactor) public onlyOperator {
250         QuantityFactorSet(quantityFactor, newFactor, msg.sender);
251         quantityFactor = newFactor;
252     }
253 
254     event MinSlippageFactorSet (uint newMin, uint oldMin, address sender);
255 
256     function setMinSlippageFactor(uint bps) public onlyOperator {
257         MinSlippageFactorSet(bps, minSlippageFactorInBps, msg.sender);
258         minSlippageFactorInBps = bps;
259     }
260 
261     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
262         public view
263         returns (uint expectedRate, uint slippageRate)
264     {
265         require(quantityFactor != 0);
266 
267         uint bestReserve;
268         uint minSlippage;
269 
270         (bestReserve, expectedRate) = kyberNetwork.findBestRate(src, dest, srcQty);
271         (bestReserve, slippageRate) = kyberNetwork.findBestRate(src, dest, (srcQty * quantityFactor));
272 
273         minSlippage = ((10000 - minSlippageFactorInBps) * expectedRate) / 10000;
274         if (slippageRate >= minSlippage) {
275             slippageRate = minSlippage;
276         }
277 
278         return (expectedRate, slippageRate);
279     }
280 }
281 
282 contract KyberNetwork is Withdrawable, Utils {
283 
284     uint public negligibleRateDiff = 10; // basic rate steps will be in 0.01%
285     KyberReserveInterface[] public reserves;
286     mapping(address=>bool) public isReserve;
287     WhiteListInterface public whiteListContract;
288     ExpectedRateInterface public expectedRateContract;
289     FeeBurnerInterface    public feeBurnerContract;
290     uint                  public maxGasPrice = 50 * 1000 * 1000 * 1000; // 50 gwei
291     bool                  public enabled = false; // network is enabled
292     mapping(address=>mapping(bytes32=>bool)) public perReserveListedPairs;
293 
294     function KyberNetwork(address _admin) public {
295         require(_admin != address(0));
296         admin = _admin;
297     }
298 
299     event EtherReceival(address indexed sender, uint amount);
300 
301     /* solhint-disable no-complex-fallback */
302     function() public payable {
303         require(isReserve[msg.sender]);
304         EtherReceival(msg.sender, msg.value);
305     }
306     /* solhint-enable no-complex-fallback */
307 
308     event ExecuteTrade(address indexed sender, ERC20 src, ERC20 dest, uint actualSrcAmount, uint actualDestAmount);
309 
310     /// @notice use token address ETH_TOKEN_ADDRESS for ether
311     /// @dev makes a trade between src and dest token and send dest token to destAddress
312     /// @param src Src token
313     /// @param srcAmount amount of src tokens
314     /// @param dest   Destination token
315     /// @param destAddress Address to send tokens to
316     /// @param maxDestAmount A limit on the amount of dest tokens
317     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
318     /// @param walletId is the wallet ID to send part of the fees
319     /// @return amount of actual dest tokens
320     function trade(
321         ERC20 src,
322         uint srcAmount,
323         ERC20 dest,
324         address destAddress,
325         uint maxDestAmount,
326         uint minConversionRate,
327         address walletId
328     )
329         public
330         payable
331         returns(uint)
332     {
333         require(enabled);
334 
335         uint userSrcBalanceBefore;
336         uint userSrcBalanceAfter;
337         uint userDestBalanceBefore;
338         uint userDestBalanceAfter;
339 
340         userSrcBalanceBefore = getBalance(src, msg.sender);
341         if (src == ETH_TOKEN_ADDRESS)
342             userSrcBalanceBefore += msg.value;
343         userDestBalanceBefore = getBalance(dest, destAddress);
344 
345         uint actualDestAmount = doTrade(src,
346                                         srcAmount,
347                                         dest,
348                                         destAddress,
349                                         maxDestAmount,
350                                         minConversionRate,
351                                         walletId
352                                         );
353         require(actualDestAmount > 0);
354 
355         userSrcBalanceAfter = getBalance(src, msg.sender);
356         userDestBalanceAfter = getBalance(dest, destAddress);
357 
358         require(userSrcBalanceAfter <= userSrcBalanceBefore);
359         require(userDestBalanceAfter >= userDestBalanceBefore);
360 
361         require((userDestBalanceAfter - userDestBalanceBefore) >=
362             calcDstQty((userSrcBalanceBefore - userSrcBalanceAfter), getDecimals(src), getDecimals(dest),
363                 minConversionRate));
364 
365         return actualDestAmount;
366     }
367 
368     event AddReserveToNetwork(KyberReserveInterface reserve, bool add);
369 
370     /// @notice can be called only by admin
371     /// @dev add or deletes a reserve to/from the network.
372     /// @param reserve The reserve address.
373     /// @param add If true, the add reserve. Otherwise delete reserve.
374     function addReserve(KyberReserveInterface reserve, bool add) public onlyAdmin {
375 
376         if (add) {
377             require(!isReserve[reserve]);
378             reserves.push(reserve);
379             isReserve[reserve] = true;
380             AddReserveToNetwork(reserve, true);
381         } else {
382             isReserve[reserve] = false;
383             // will have trouble if more than 50k reserves...
384             for (uint i = 0; i < reserves.length; i++) {
385                 if (reserves[i] == reserve) {
386                     reserves[i] = reserves[reserves.length - 1];
387                     reserves.length--;
388                     AddReserveToNetwork(reserve, false);
389                     break;
390                 }
391             }
392         }
393     }
394 
395     event ListReservePairs(address reserve, ERC20 src, ERC20 dest, bool add);
396 
397     /// @notice can be called only by admin
398     /// @dev allow or prevent a specific reserve to trade a pair of tokens
399     /// @param reserve The reserve address.
400     /// @param src Src token
401     /// @param dest Destination token
402     /// @param add If true then enable trade, otherwise delist pair.
403     function listPairForReserve(address reserve, ERC20 src, ERC20 dest, bool add) public onlyAdmin {
404         (perReserveListedPairs[reserve])[keccak256(src, dest)] = add;
405 
406         if (src != ETH_TOKEN_ADDRESS) {
407             if (add) {
408                 src.approve(reserve, 2**255); // approve infinity
409             } else {
410                 src.approve(reserve, 0);
411             }
412         }
413 
414         setDecimals(src);
415         setDecimals(dest);
416 
417         ListReservePairs(reserve, src, dest, add);
418     }
419 
420     function setParams(
421         WhiteListInterface    _whiteList,
422         ExpectedRateInterface _expectedRate,
423         FeeBurnerInterface    _feeBurner,
424         uint                  _maxGasPrice,
425         uint                  _negligibleRateDiff
426     )
427         public
428         onlyAdmin
429     {
430         require(_whiteList != address(0));
431         require(_feeBurner != address(0));
432         require(_expectedRate != address(0));
433         whiteListContract = _whiteList;
434         expectedRateContract = _expectedRate;
435         feeBurnerContract = _feeBurner;
436         maxGasPrice = _maxGasPrice;
437         negligibleRateDiff = _negligibleRateDiff;
438     }
439 
440     function setEnable(bool _enable) public onlyAdmin {
441         if (_enable) {
442             require(whiteListContract != address(0));
443             require(feeBurnerContract != address(0));
444             require(expectedRateContract != address(0));
445         }
446         enabled = _enable;
447     }
448 
449     /// @dev returns number of reserves
450     /// @return number of reserves
451     function getNumReserves() public view returns(uint) {
452         return reserves.length;
453     }
454 
455     /// @notice should be called off chain with as much gas as needed
456     /// @dev get an array of all reserves
457     /// @return An array of all reserves
458     function getReserves() public view returns(KyberReserveInterface[]) {
459         return reserves;
460     }
461 
462     /// @dev get the balance of a user.
463     /// @param token The token type
464     /// @return The balance
465     function getBalance(ERC20 token, address user) public view returns(uint) {
466         if (token == ETH_TOKEN_ADDRESS)
467             return user.balance;
468         else
469             return token.balanceOf(user);
470     }
471 
472     /// @notice use token address ETH_TOKEN_ADDRESS for ether
473     /// @dev best conversion rate for a pair of tokens, if number of reserves have small differences. randomize
474     /// @param src Src token
475     /// @param dest Destination token
476     /* solhint-disable code-complexity */
477     function findBestRate(ERC20 src, ERC20 dest, uint srcQty) public view returns(uint, uint) {
478         uint bestRate = 0;
479         uint bestReserve = 0;
480         uint numRelevantReserves = 0;
481         uint numReserves = reserves.length;
482         uint[] memory rates = new uint[](numReserves);
483         uint[] memory reserveCandidates = new uint[](numReserves);
484 
485         for (uint i = 0; i < numReserves; i++) {
486             //list all reserves that have this token.
487             if (!(perReserveListedPairs[reserves[i]])[keccak256(src, dest)]) continue;
488 
489             rates[i] = reserves[i].getConversionRate(src, dest, srcQty, block.number);
490 
491             if (rates[i] > bestRate) {
492                 //best rate is highest rate
493                 bestRate = rates[i];
494             }
495         }
496 
497         if (bestRate > 0) {
498             uint random = 0;
499             uint smallestRelevantRate = (bestRate * 10000) / (10000 + negligibleRateDiff);
500 
501             for (i = 0; i < numReserves; i++) {
502                 if (rates[i] >= smallestRelevantRate) {
503                     reserveCandidates[numRelevantReserves++] = i;
504                 }
505             }
506 
507             if (numRelevantReserves > 1) {
508                 //when encountering small rate diff from bestRate. draw from relevant reserves
509                 random = uint(block.blockhash(block.number-1)) % numRelevantReserves;
510             }
511 
512             bestReserve = reserveCandidates[random];
513             bestRate = rates[bestReserve];
514         }
515 
516         return (bestReserve, bestRate);
517     }
518     /* solhint-enable code-complexity */
519 
520     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
521         public view
522         returns (uint expectedRate, uint slippageRate)
523     {
524         require(expectedRateContract != address(0));
525         return expectedRateContract.getExpectedRate(src, dest, srcQty);
526     }
527 
528     function getUserCapInWei(address user) public view returns(uint) {
529         return whiteListContract.getUserCapInWei(user);
530     }
531 
532     function doTrade(
533         ERC20 src,
534         uint srcAmount,
535         ERC20 dest,
536         address destAddress,
537         uint maxDestAmount,
538         uint minConversionRate,
539         address walletId
540     )
541         internal
542         returns(uint)
543     {
544         require(tx.gasprice <= maxGasPrice);
545         require(validateTradeInput(src, srcAmount, destAddress));
546 
547         uint reserveInd;
548         uint rate;
549 
550         (reserveInd, rate) = findBestRate(src, dest, srcAmount);
551         KyberReserveInterface theReserve = reserves[reserveInd];
552         require(rate > 0);
553         require(rate < MAX_RATE);
554         require(rate >= minConversionRate);
555 
556         uint actualSrcAmount = srcAmount;
557         uint actualDestAmount = calcDestAmount(src, dest, actualSrcAmount, rate);
558         if (actualDestAmount > maxDestAmount) {
559             actualDestAmount = maxDestAmount;
560             actualSrcAmount = calcSrcAmount(src, dest, actualDestAmount, rate);
561             require(actualSrcAmount <= srcAmount);
562         }
563 
564         // do the trade
565         // verify trade size is smaller than user cap
566         uint ethAmount;
567         if (src == ETH_TOKEN_ADDRESS) {
568             ethAmount = actualSrcAmount;
569         } else {
570             ethAmount = actualDestAmount;
571         }
572 
573         require(ethAmount <= getUserCapInWei(msg.sender));
574         require(doReserveTrade(
575                 src,
576                 actualSrcAmount,
577                 dest,
578                 destAddress,
579                 actualDestAmount,
580                 theReserve,
581                 rate,
582                 true));
583 
584         if ((actualSrcAmount < srcAmount) && (src == ETH_TOKEN_ADDRESS)) {
585             msg.sender.transfer(srcAmount - actualSrcAmount);
586         }
587 
588         require(feeBurnerContract.handleFees(ethAmount, theReserve, walletId));
589 
590         ExecuteTrade(msg.sender, src, dest, actualSrcAmount, actualDestAmount);
591         return actualDestAmount;
592     }
593 
594     /// @notice use token address ETH_TOKEN_ADDRESS for ether
595     /// @dev do one trade with a reserve
596     /// @param src Src token
597     /// @param amount amount of src tokens
598     /// @param dest   Destination token
599     /// @param destAddress Address to send tokens to
600     /// @param reserve Reserve to use
601     /// @param validate If true, additional validations are applicable
602     /// @return true if trade is successful
603     function doReserveTrade(
604         ERC20 src,
605         uint amount,
606         ERC20 dest,
607         address destAddress,
608         uint expectedDestAmount,
609         KyberReserveInterface reserve,
610         uint conversionRate,
611         bool validate
612     )
613         internal
614         returns(bool)
615     {
616         uint callValue = 0;
617 
618         if (src == ETH_TOKEN_ADDRESS) {
619             callValue = amount;
620         } else {
621             // take src tokens to this contract
622             src.transferFrom(msg.sender, this, amount);
623         }
624 
625         // reserve sends tokens/eth to network. network sends it to destination
626         require(reserve.trade.value(callValue)(src, amount, dest, this, conversionRate, validate));
627 
628         if (dest == ETH_TOKEN_ADDRESS) {
629             destAddress.transfer(expectedDestAmount);
630         } else {
631             require(dest.transfer(destAddress, expectedDestAmount));
632         }
633 
634         return true;
635     }
636 
637     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
638         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
639     }
640 
641     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
642         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
643     }
644 
645     /// @notice use token address ETH_TOKEN_ADDRESS for ether
646     /// @dev checks that user sent ether/tokens to contract before trade
647     /// @param src Src token
648     /// @param srcAmount amount of src tokens
649     /// @return true if input is valid
650     function validateTradeInput(ERC20 src, uint srcAmount, address destAddress) internal view returns(bool) {
651         if ((srcAmount >= MAX_QTY) || (srcAmount == 0) || (destAddress == 0))
652             return false;
653 
654         if (src == ETH_TOKEN_ADDRESS) {
655             if (msg.value != srcAmount)
656                 return false;
657         } else {
658             if ((msg.value != 0) || (src.allowance(msg.sender, this) < srcAmount))
659                 return false;
660         }
661 
662         return true;
663     }
664 }