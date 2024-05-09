1 pragma solidity 0.4.18;
2 
3 contract PermissionGroups {
4 
5     address public admin;
6     address public pendingAdmin;
7     mapping(address=>bool) internal operators;
8     mapping(address=>bool) internal alerters;
9     address[] internal operatorsGroup;
10     address[] internal alertersGroup;
11 
12     function PermissionGroups() public {
13         admin = msg.sender;
14     }
15 
16     modifier onlyAdmin() {
17         require(msg.sender == admin);
18         _;
19     }
20 
21     modifier onlyOperator() {
22         require(operators[msg.sender]);
23         _;
24     }
25 
26     modifier onlyAlerter() {
27         require(alerters[msg.sender]);
28         _;
29     }
30 
31     function getOperators () external view returns(address[]) {
32         return operatorsGroup;
33     }
34 
35     function getAlerters () external view returns(address[]) {
36         return alertersGroup;
37     }
38 
39     event TransferAdminPending(address pendingAdmin);
40 
41     /**
42      * @dev Allows the current admin to set the pendingAdmin address.
43      * @param newAdmin The address to transfer ownership to.
44      */
45     function transferAdmin(address newAdmin) public onlyAdmin {
46         require(newAdmin != address(0));
47         TransferAdminPending(pendingAdmin);
48         pendingAdmin = newAdmin;
49     }
50 
51     event AdminClaimed( address newAdmin, address previousAdmin);
52 
53     /**
54      * @dev Allows the pendingAdmin address to finalize the change admin process.
55      */
56     function claimAdmin() public {
57         require(pendingAdmin == msg.sender);
58         AdminClaimed(pendingAdmin, admin);
59         admin = pendingAdmin;
60         pendingAdmin = address(0);
61     }
62 
63     event AlerterAdded (address newAlerter, bool isAdd);
64 
65     function addAlerter(address newAlerter) public onlyAdmin {
66         require(!alerters[newAlerter]); // prevent duplicates.
67         AlerterAdded(newAlerter, true);
68         alerters[newAlerter] = true;
69         alertersGroup.push(newAlerter);
70     }
71 
72     function removeAlerter (address alerter) public onlyAdmin {
73         require(alerters[alerter]);
74         alerters[alerter] = false;
75 
76         for (uint i = 0; i < alertersGroup.length; ++i) {
77             if (alertersGroup[i] == alerter) {
78                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
79                 alertersGroup.length--;
80                 AlerterAdded(alerter, false);
81                 break;
82             }
83         }
84     }
85 
86     event OperatorAdded(address newOperator, bool isAdd);
87 
88     function addOperator(address newOperator) public onlyAdmin {
89         require(!operators[newOperator]); // prevent duplicates.
90         OperatorAdded(newOperator, true);
91         operators[newOperator] = true;
92         operatorsGroup.push(newOperator);
93     }
94 
95     function removeOperator (address operator) public onlyAdmin {
96         require(operators[operator]);
97         operators[operator] = false;
98 
99         for (uint i = 0; i < operatorsGroup.length; ++i) {
100             if (operatorsGroup[i] == operator) {
101                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
102                 operatorsGroup.length -= 1;
103                 OperatorAdded(operator, false);
104                 break;
105             }
106         }
107     }
108 }
109 
110 contract Utils {
111 
112     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
113     uint  constant internal PRECISION = (10**18);
114     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
115     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
116     uint  constant internal MAX_DECIMALS = 18;
117     uint  constant internal ETH_DECIMALS = 18;
118     mapping(address=>uint) internal decimals;
119 
120     function setDecimals(ERC20 token) internal {
121         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
122         else decimals[token] = token.decimals();
123     }
124 
125     function getDecimals(ERC20 token) internal view returns(uint) {
126         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
127         uint tokenDecimals = decimals[token];
128         // technically, there might be token with decimals 0
129         // moreover, very possible that old tokens have decimals 0
130         // these tokens will just have higher gas fees.
131         if(tokenDecimals == 0) return token.decimals();
132 
133         return tokenDecimals;
134     }
135 
136     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
137         require(srcQty <= MAX_QTY);
138         require(rate <= MAX_RATE);
139 
140         if (dstDecimals >= srcDecimals) {
141             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
142             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
143         } else {
144             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
145             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
146         }
147     }
148 
149     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
150         require(dstQty <= MAX_QTY);
151         require(rate <= MAX_RATE);
152 
153         //source quantity is rounded up. to avoid dest quantity being too low.
154         uint numerator;
155         uint denominator;
156         if (srcDecimals >= dstDecimals) {
157             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
158             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
159             denominator = rate;
160         } else {
161             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
162             numerator = (PRECISION * dstQty);
163             denominator = (rate * (10**(dstDecimals - srcDecimals)));
164         }
165         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
166     }
167 }
168 
169 interface KyberReserveInterface {
170 
171     function trade(
172         ERC20 srcToken,
173         uint srcAmount,
174         ERC20 destToken,
175         address destAddress,
176         uint conversionRate,
177         bool validate
178     )
179         public
180         payable
181         returns(bool);
182 
183     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
184 }
185 
186 contract Withdrawable is PermissionGroups {
187 
188     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
189 
190     /**
191      * @dev Withdraw all ERC20 compatible tokens
192      * @param token ERC20 The address of the token contract
193      */
194     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
195         require(token.transfer(sendTo, amount));
196         TokenWithdraw(token, amount, sendTo);
197     }
198 
199     event EtherWithdraw(uint amount, address sendTo);
200 
201     /**
202      * @dev Withdraw Ethers
203      */
204     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
205         sendTo.transfer(amount);
206         EtherWithdraw(amount, sendTo);
207     }
208 }
209 
210 contract KyberNetwork is Withdrawable, Utils {
211 
212     uint public negligibleRateDiff = 10; // basic rate steps will be in 0.01%
213     KyberReserveInterface[] public reserves;
214     mapping(address=>bool) public isReserve;
215     WhiteListInterface public whiteListContract;
216     ExpectedRateInterface public expectedRateContract;
217     FeeBurnerInterface    public feeBurnerContract;
218     uint                  public maxGasPrice = 50 * 1000 * 1000 * 1000; // 50 gwei
219     bool                  public enabled = false; // network is enabled
220     mapping(address=>mapping(bytes32=>bool)) public perReserveListedPairs;
221 
222     function KyberNetwork(address _admin) public {
223         require(_admin != address(0));
224         admin = _admin;
225     }
226 
227     event EtherReceival(address indexed sender, uint amount);
228 
229     /* solhint-disable no-complex-fallback */
230     function() public payable {
231         require(isReserve[msg.sender]);
232         EtherReceival(msg.sender, msg.value);
233     }
234     /* solhint-enable no-complex-fallback */
235 
236     event ExecuteTrade(address indexed sender, ERC20 src, ERC20 dest, uint actualSrcAmount, uint actualDestAmount);
237 
238     /// @notice use token address ETH_TOKEN_ADDRESS for ether
239     /// @dev makes a trade between src and dest token and send dest token to destAddress
240     /// @param src Src token
241     /// @param srcAmount amount of src tokens
242     /// @param dest   Destination token
243     /// @param destAddress Address to send tokens to
244     /// @param maxDestAmount A limit on the amount of dest tokens
245     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
246     /// @param walletId is the wallet ID to send part of the fees
247     /// @return amount of actual dest tokens
248     function trade(
249         ERC20 src,
250         uint srcAmount,
251         ERC20 dest,
252         address destAddress,
253         uint maxDestAmount,
254         uint minConversionRate,
255         address walletId
256     )
257         public
258         payable
259         returns(uint)
260     {
261         require(enabled);
262 
263         uint userSrcBalanceBefore;
264         uint userSrcBalanceAfter;
265         uint userDestBalanceBefore;
266         uint userDestBalanceAfter;
267 
268         userSrcBalanceBefore = getBalance(src, msg.sender);
269         if (src == ETH_TOKEN_ADDRESS)
270             userSrcBalanceBefore += msg.value;
271         userDestBalanceBefore = getBalance(dest, destAddress);
272 
273         uint actualDestAmount = doTrade(src,
274                                         srcAmount,
275                                         dest,
276                                         destAddress,
277                                         maxDestAmount,
278                                         minConversionRate,
279                                         walletId
280                                         );
281         require(actualDestAmount > 0);
282 
283         userSrcBalanceAfter = getBalance(src, msg.sender);
284         userDestBalanceAfter = getBalance(dest, destAddress);
285 
286         require(userSrcBalanceAfter <= userSrcBalanceBefore);
287         require(userDestBalanceAfter >= userDestBalanceBefore);
288 
289         require((userDestBalanceAfter - userDestBalanceBefore) >=
290             calcDstQty((userSrcBalanceBefore - userSrcBalanceAfter), getDecimals(src), getDecimals(dest),
291                 minConversionRate));
292 
293         return actualDestAmount;
294     }
295 
296     event AddReserveToNetwork(KyberReserveInterface reserve, bool add);
297 
298     /// @notice can be called only by admin
299     /// @dev add or deletes a reserve to/from the network.
300     /// @param reserve The reserve address.
301     /// @param add If true, the add reserve. Otherwise delete reserve.
302     function addReserve(KyberReserveInterface reserve, bool add) public onlyAdmin {
303 
304         if (add) {
305             require(!isReserve[reserve]);
306             reserves.push(reserve);
307             isReserve[reserve] = true;
308             AddReserveToNetwork(reserve, true);
309         } else {
310             isReserve[reserve] = false;
311             // will have trouble if more than 50k reserves...
312             for (uint i = 0; i < reserves.length; i++) {
313                 if (reserves[i] == reserve) {
314                     reserves[i] = reserves[reserves.length - 1];
315                     reserves.length--;
316                     AddReserveToNetwork(reserve, false);
317                     break;
318                 }
319             }
320         }
321     }
322 
323     event ListReservePairs(address reserve, ERC20 src, ERC20 dest, bool add);
324 
325     /// @notice can be called only by admin
326     /// @dev allow or prevent a specific reserve to trade a pair of tokens
327     /// @param reserve The reserve address.
328     /// @param src Src token
329     /// @param dest Destination token
330     /// @param add If true then enable trade, otherwise delist pair.
331     function listPairForReserve(address reserve, ERC20 src, ERC20 dest, bool add) public onlyAdmin {
332         (perReserveListedPairs[reserve])[keccak256(src, dest)] = add;
333 
334         if (src != ETH_TOKEN_ADDRESS) {
335             if (add) {
336                 src.approve(reserve, 2**255); // approve infinity
337             } else {
338                 src.approve(reserve, 0);
339             }
340         }
341 
342         setDecimals(src);
343         setDecimals(dest);
344 
345         ListReservePairs(reserve, src, dest, add);
346     }
347 
348     function setParams(
349         WhiteListInterface    _whiteList,
350         ExpectedRateInterface _expectedRate,
351         FeeBurnerInterface    _feeBurner,
352         uint                  _maxGasPrice,
353         uint                  _negligibleRateDiff
354     )
355         public
356         onlyAdmin
357     {
358         require(_whiteList != address(0));
359         require(_feeBurner != address(0));
360         require(_expectedRate != address(0));
361         whiteListContract = _whiteList;
362         expectedRateContract = _expectedRate;
363         feeBurnerContract = _feeBurner;
364         maxGasPrice = _maxGasPrice;
365         negligibleRateDiff = _negligibleRateDiff;
366     }
367 
368     function setEnable(bool _enable) public onlyAdmin {
369         if (_enable) {
370             require(whiteListContract != address(0));
371             require(feeBurnerContract != address(0));
372             require(expectedRateContract != address(0));
373         }
374         enabled = _enable;
375     }
376 
377     /// @dev returns number of reserves
378     /// @return number of reserves
379     function getNumReserves() public view returns(uint) {
380         return reserves.length;
381     }
382 
383     /// @notice should be called off chain with as much gas as needed
384     /// @dev get an array of all reserves
385     /// @return An array of all reserves
386     function getReserves() public view returns(KyberReserveInterface[]) {
387         return reserves;
388     }
389 
390     /// @dev get the balance of a user.
391     /// @param token The token type
392     /// @return The balance
393     function getBalance(ERC20 token, address user) public view returns(uint) {
394         if (token == ETH_TOKEN_ADDRESS)
395             return user.balance;
396         else
397             return token.balanceOf(user);
398     }
399 
400     /// @notice use token address ETH_TOKEN_ADDRESS for ether
401     /// @dev best conversion rate for a pair of tokens, if number of reserves have small differences. randomize
402     /// @param src Src token
403     /// @param dest Destination token
404     /* solhint-disable code-complexity */
405     function findBestRate(ERC20 src, ERC20 dest, uint srcQty) public view returns(uint, uint) {
406         uint bestRate = 0;
407         uint bestReserve = 0;
408         uint numRelevantReserves = 0;
409         uint numReserves = reserves.length;
410         uint[] memory rates = new uint[](numReserves);
411         uint[] memory reserveCandidates = new uint[](numReserves);
412 
413         for (uint i = 0; i < numReserves; i++) {
414             //list all reserves that have this token.
415             if (!(perReserveListedPairs[reserves[i]])[keccak256(src, dest)]) continue;
416 
417             rates[i] = reserves[i].getConversionRate(src, dest, srcQty, block.number);
418 
419             if (rates[i] > bestRate) {
420                 //best rate is highest rate
421                 bestRate = rates[i];
422             }
423         }
424 
425         if (bestRate > 0) {
426             uint random = 0;
427             uint smallestRelevantRate = (bestRate * 10000) / (10000 + negligibleRateDiff);
428 
429             for (i = 0; i < numReserves; i++) {
430                 if (rates[i] >= smallestRelevantRate) {
431                     reserveCandidates[numRelevantReserves++] = i;
432                 }
433             }
434 
435             if (numRelevantReserves > 1) {
436                 //when encountering small rate diff from bestRate. draw from relevant reserves
437                 random = uint(block.blockhash(block.number-1)) % numRelevantReserves;
438             }
439 
440             bestReserve = reserveCandidates[random];
441             bestRate = rates[bestReserve];
442         }
443 
444         return (bestReserve, bestRate);
445     }
446     /* solhint-enable code-complexity */
447 
448     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
449         public view
450         returns (uint expectedRate, uint slippageRate)
451     {
452         require(expectedRateContract != address(0));
453         return expectedRateContract.getExpectedRate(src, dest, srcQty);
454     }
455 
456     function getUserCapInWei(address user) public view returns(uint) {
457         return whiteListContract.getUserCapInWei(user);
458     }
459 
460     function doTrade(
461         ERC20 src,
462         uint srcAmount,
463         ERC20 dest,
464         address destAddress,
465         uint maxDestAmount,
466         uint minConversionRate,
467         address walletId
468     )
469         internal
470         returns(uint)
471     {
472         require(tx.gasprice <= maxGasPrice);
473         require(validateTradeInput(src, srcAmount, destAddress));
474 
475         uint reserveInd;
476         uint rate;
477 
478         (reserveInd, rate) = findBestRate(src, dest, srcAmount);
479         KyberReserveInterface theReserve = reserves[reserveInd];
480         require(rate > 0);
481         require(rate < MAX_RATE);
482         require(rate >= minConversionRate);
483 
484         uint actualSrcAmount = srcAmount;
485         uint actualDestAmount = calcDestAmount(src, dest, actualSrcAmount, rate);
486         if (actualDestAmount > maxDestAmount) {
487             actualDestAmount = maxDestAmount;
488             actualSrcAmount = calcSrcAmount(src, dest, actualDestAmount, rate);
489             require(actualSrcAmount <= srcAmount);
490         }
491 
492         // do the trade
493         // verify trade size is smaller than user cap
494         uint ethAmount;
495         if (src == ETH_TOKEN_ADDRESS) {
496             ethAmount = actualSrcAmount;
497         } else {
498             ethAmount = actualDestAmount;
499         }
500 
501         require(ethAmount <= getUserCapInWei(msg.sender));
502         require(doReserveTrade(
503                 src,
504                 actualSrcAmount,
505                 dest,
506                 destAddress,
507                 actualDestAmount,
508                 theReserve,
509                 rate,
510                 true));
511 
512         if ((actualSrcAmount < srcAmount) && (src == ETH_TOKEN_ADDRESS)) {
513             msg.sender.transfer(srcAmount - actualSrcAmount);
514         }
515 
516         require(feeBurnerContract.handleFees(ethAmount, theReserve, walletId));
517 
518         ExecuteTrade(msg.sender, src, dest, actualSrcAmount, actualDestAmount);
519         return actualDestAmount;
520     }
521 
522     /// @notice use token address ETH_TOKEN_ADDRESS for ether
523     /// @dev do one trade with a reserve
524     /// @param src Src token
525     /// @param amount amount of src tokens
526     /// @param dest   Destination token
527     /// @param destAddress Address to send tokens to
528     /// @param reserve Reserve to use
529     /// @param validate If true, additional validations are applicable
530     /// @return true if trade is successful
531     function doReserveTrade(
532         ERC20 src,
533         uint amount,
534         ERC20 dest,
535         address destAddress,
536         uint expectedDestAmount,
537         KyberReserveInterface reserve,
538         uint conversionRate,
539         bool validate
540     )
541         internal
542         returns(bool)
543     {
544         uint callValue = 0;
545 
546         if (src == ETH_TOKEN_ADDRESS) {
547             callValue = amount;
548         } else {
549             // take src tokens to this contract
550             src.transferFrom(msg.sender, this, amount);
551         }
552 
553         // reserve sends tokens/eth to network. network sends it to destination
554         require(reserve.trade.value(callValue)(src, amount, dest, this, conversionRate, validate));
555 
556         if (dest == ETH_TOKEN_ADDRESS) {
557             destAddress.transfer(expectedDestAmount);
558         } else {
559             require(dest.transfer(destAddress, expectedDestAmount));
560         }
561 
562         return true;
563     }
564 
565     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
566         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
567     }
568 
569     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
570         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
571     }
572 
573     /// @notice use token address ETH_TOKEN_ADDRESS for ether
574     /// @dev checks that user sent ether/tokens to contract before trade
575     /// @param src Src token
576     /// @param srcAmount amount of src tokens
577     /// @return true if input is valid
578     function validateTradeInput(ERC20 src, uint srcAmount, address destAddress) internal view returns(bool) {
579         if ((srcAmount >= MAX_QTY) || (srcAmount == 0) || (destAddress == 0))
580             return false;
581 
582         if (src == ETH_TOKEN_ADDRESS) {
583             if (msg.value != srcAmount)
584                 return false;
585         } else {
586             if ((msg.value != 0) || (src.allowance(msg.sender, this) < srcAmount))
587                 return false;
588         }
589 
590         return true;
591     }
592 }
593 
594 interface FeeBurnerInterface {
595     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
596 }
597 
598 interface ERC20 {
599     function totalSupply() public view returns (uint supply);
600     function balanceOf(address _owner) public view returns (uint balance);
601     function transfer(address _to, uint _value) public returns (bool success);
602     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
603     function approve(address _spender, uint _value) public returns (bool success);
604     function allowance(address _owner, address _spender) public view returns (uint remaining);
605     function decimals() public view returns(uint digits);
606     event Approval(address indexed _owner, address indexed _spender, uint _value);
607 }
608 
609 interface ExpectedRateInterface {
610     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
611         returns (uint expectedRate, uint slippageRate);
612 }
613 
614 contract WhiteListInterface {
615     function getUserCapInWei(address user) external view returns (uint userCapWei);
616 }