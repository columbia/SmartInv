1 pragma solidity ^0.4.22;
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
17 // File: contracts/SupplierInterface.sol
18 
19 interface SupplierInterface {
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
36 // File: contracts/PermissionGroups.sol
37 
38 contract PermissionGroups {
39 
40     address public admin;
41     address public pendingAdmin;
42     mapping(address=>bool) internal operators;
43     mapping(address=>bool) internal quoters;
44     address[] internal operatorsGroup;
45     address[] internal quotersGroup;
46     uint constant internal MAX_GROUP_SIZE = 50;
47 
48     constructor() public {
49         admin = msg.sender;
50     }
51 
52     modifier onlyAdmin() {
53         require(msg.sender == admin);
54         _;
55     }
56 
57     modifier onlyOperator() {
58         require(operators[msg.sender]);
59         _;
60     }
61 
62     modifier onlyQuoter() {
63         require(quoters[msg.sender]);
64         _;
65     }
66 
67     function getOperators () external view returns(address[]) {
68         return operatorsGroup;
69     }
70 
71     function getQuoters () external view returns(address[]) {
72         return quotersGroup;
73     }
74 
75     event TransferAdminPending(address pendingAdmin);
76 
77     /**
78      * @dev Allows the current admin to set the pendingAdmin address.
79      * @param newAdmin The address to transfer ownership to.
80      */
81     function transferAdmin(address newAdmin) public onlyAdmin {
82         require(newAdmin != address(0));
83         emit TransferAdminPending(pendingAdmin);
84         pendingAdmin = newAdmin;
85     }
86 
87     /**
88      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
89      * @param newAdmin The address to transfer ownership to.
90      */
91     function transferAdminQuickly(address newAdmin) public onlyAdmin {
92         require(newAdmin != address(0));
93         emit TransferAdminPending(newAdmin);
94         emit AdminClaimed(newAdmin, admin);
95         admin = newAdmin;
96     }
97 
98     event AdminClaimed( address newAdmin, address previousAdmin);
99 
100     /**
101      * @dev Allows the pendingAdmin address to finalize the change admin process.
102      */
103     function claimAdmin() public {
104         require(pendingAdmin == msg.sender);
105         emit AdminClaimed(pendingAdmin, admin);
106         admin = pendingAdmin;
107         pendingAdmin = address(0);
108     }
109 
110     event OperatorAdded(address newOperator, bool isAdd);
111 
112     function addOperator(address newOperator) public onlyAdmin {
113         require(!operators[newOperator]); // prevent duplicates.
114         require(operatorsGroup.length < MAX_GROUP_SIZE);
115 
116         emit OperatorAdded(newOperator, true);
117         operators[newOperator] = true;
118         operatorsGroup.push(newOperator);
119     }
120 
121     function removeOperator (address operator) public onlyAdmin {
122         require(operators[operator]);
123         operators[operator] = false;
124 
125         for (uint i = 0; i < operatorsGroup.length; ++i) {
126             if (operatorsGroup[i] == operator) {
127                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
128                 operatorsGroup.length -= 1;
129                 emit OperatorAdded(operator, false);
130                 break;
131             }
132         }
133     }
134 
135     event QuoterAdded (address newQuoter, bool isAdd);
136 
137     function addQuoter(address newQuoter) public onlyAdmin {
138         require(!quoters[newQuoter]); // prevent duplicates.
139         require(quotersGroup.length < MAX_GROUP_SIZE);
140 
141         emit QuoterAdded(newQuoter, true);
142         quoters[newQuoter] = true;
143         quotersGroup.push(newQuoter);
144     }
145 
146     function removeQuoter (address alerter) public onlyAdmin {
147         require(quoters[alerter]);
148         quoters[alerter] = false;
149 
150         for (uint i = 0; i < quotersGroup.length; ++i) {
151             if (quotersGroup[i] == alerter) {
152                 quotersGroup[i] = quotersGroup[quotersGroup.length - 1];
153                 quotersGroup.length--;
154                 emit QuoterAdded(alerter, false);
155                 break;
156             }
157         }
158     }
159 }
160 
161 // File: contracts/Withdrawable.sol
162 
163 /**
164  * @title Contracts that should be able to recover tokens or ethers
165  * @dev This allows to recover any tokens or Ethers received in a contract.
166  * This will prevent any accidental loss of tokens.
167  */
168 contract Withdrawable is PermissionGroups {
169 
170     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
171 
172     /**
173      * @dev Withdraw all ERC20 compatible tokens
174      * @param token ERC20 The address of the token contract
175      */
176     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
177         require(token.transfer(sendTo, amount));
178         emit TokenWithdraw(token, amount, sendTo);
179     }
180 
181     event EtherWithdraw(uint amount, address sendTo);
182 
183     /**
184      * @dev Withdraw Ethers
185      */
186     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
187         sendTo.transfer(amount);
188         emit EtherWithdraw(amount, sendTo);
189     }
190 }
191 
192 // File: contracts/Base.sol
193 
194 /**
195  * The Base contract does this and that...
196  */
197 contract Base {
198 
199     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
200     uint  constant internal PRECISION = (10**18);
201     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
202     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
203     uint  constant internal MAX_DECIMALS = 18;
204     uint  constant internal ETH_DECIMALS = 18;
205     mapping(address=>uint) internal decimals;
206 
207 	function setDecimals(ERC20 token) internal {
208         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
209         else decimals[token] = token.decimals();
210     }
211 
212     function getDecimals(ERC20 token) internal view returns(uint) {
213         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
214         uint tokenDecimals = decimals[token];
215         // technically, there might be token with decimals 0
216         // moreover, very possible that old tokens have decimals 0
217         // these tokens will just have higher gas fees.
218         if(tokenDecimals == 0) return token.decimals();
219 
220         return tokenDecimals;
221     }
222 
223     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
224         require(srcQty <= MAX_QTY);
225         require(rate <= MAX_RATE);
226 
227         if (dstDecimals >= srcDecimals) {
228             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
229             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
230         } else {
231             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
232             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
233         }
234     }
235 
236     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
237         require(dstQty <= MAX_QTY);
238         require(rate <= MAX_RATE);
239         
240         //source quantity is rounded up. to avoid dest quantity being too low.
241         uint numerator;
242         uint denominator;
243         if (srcDecimals >= dstDecimals) {
244             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
245             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
246             denominator = rate;
247         } else {
248             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
249             numerator = (PRECISION * dstQty);
250             denominator = (rate * (10**(dstDecimals - srcDecimals)));
251         }
252         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
253     }
254 }
255 
256 // File: contracts/WhiteListInterface.sol
257 
258 contract WhiteListInterface {
259     function getUserCapInWei(address user) external view returns (uint userCapWei);
260 }
261 
262 // File: contracts/ExpectedRateInterface.sol
263 
264 interface ExpectedRateInterface {
265     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
266         returns (uint expectedRate, uint slippageRate);
267 }
268 
269 // File: contracts/MartletInstantlyTrader.sol
270 
271 contract MartletInstantlyTrader is Withdrawable, Base {
272 
273     uint public negligibleRateDiff = 10; // basic rate steps will be in 0.01%
274     SupplierInterface[] public suppliers;
275     mapping(address=>bool) public isSupplier;
276     WhiteListInterface public whiteListContract;
277     ExpectedRateInterface public expectedRateContract;
278     uint                  public maxGasPrice = 50 * 1000 * 1000 * 1000; // 50 gwei
279     bool                  public enabled = false; // network is enabled
280     mapping(bytes32=>uint) public info; // this is only a UI field for external app.
281     mapping(address=>mapping(bytes32=>bool)) public perSupplierListedPairs;
282 
283     constructor (address _admin) public {
284         require(_admin != address(0));
285         admin = _admin;
286     }
287 
288     event EtherReceival(address indexed sender, uint amount);
289 
290     /* solhint-disable no-complex-fallback */
291     function() public payable {
292         require(isSupplier[msg.sender]);
293         emit EtherReceival(msg.sender, msg.value);
294     }
295     /* solhint-enable no-complex-fallback */
296 
297     event ExecuteTrade(address indexed sender, ERC20 src, ERC20 dest, uint actualSrcAmount, uint actualDestAmount);
298 
299     /// @notice use token address ETH_TOKEN_ADDRESS for ether
300     /// @dev makes a trade between src and dest token and send dest token to destAddress
301     /// @param src Src token
302     /// @param srcAmount amount of src tokens
303     /// @param dest   Destination token
304     /// @param destAddress Address to send tokens to
305     /// @param maxDestAmount A limit on the amount of dest tokens
306     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
307     /// @return amount of actual dest tokens
308     function trade(
309         ERC20 src,
310         uint srcAmount,
311         ERC20 dest,
312         address destAddress,
313         uint maxDestAmount,
314         uint minConversionRate
315     )
316         public
317         payable
318         returns(uint)
319     {
320         require(enabled);
321 
322         uint userSrcBalanceBefore;
323         uint userSrcBalanceAfter;
324         uint userDestBalanceBefore;
325         uint userDestBalanceAfter;
326 
327         userSrcBalanceBefore = getBalance(src, msg.sender);
328         if (src == ETH_TOKEN_ADDRESS)
329             userSrcBalanceBefore += msg.value;
330         userDestBalanceBefore = getBalance(dest, destAddress);
331 
332         // emit LogEx(srcAmount, maxDestAmount, minConversionRate);
333         // uint actualDestAmount = 24;
334         uint actualDestAmount = doTrade(src,
335                                         srcAmount,
336                                         dest,
337                                         destAddress,
338                                         maxDestAmount,
339                                         minConversionRate
340                                         );
341         require(actualDestAmount > 0);
342 
343         userSrcBalanceAfter = getBalance(src, msg.sender);
344         userDestBalanceAfter = getBalance(dest, destAddress);
345 
346         require(userSrcBalanceAfter <= userSrcBalanceBefore);
347         require(userDestBalanceAfter >= userDestBalanceBefore);
348 
349         require((userDestBalanceAfter - userDestBalanceBefore) >=
350             calcDstQty((userSrcBalanceBefore - userSrcBalanceAfter), getDecimals(src), getDecimals(dest),
351                 minConversionRate));
352 
353         return actualDestAmount;
354     }
355 
356     event AddSupplier(SupplierInterface supplier, bool add);
357 
358     /// @notice can be called only by admin
359     /// @dev add or deletes a supplier to/from the network.
360     /// @param supplier The supplier address.
361     /// @param add If true, the add supplier. Otherwise delete supplier.
362     function addSupplier(SupplierInterface supplier, bool add) public onlyAdmin {
363 
364         if (add) {
365             require(!isSupplier[supplier]);
366             suppliers.push(supplier);
367             isSupplier[supplier] = true;
368             emit AddSupplier(supplier, true);
369         } else {
370             isSupplier[supplier] = false;
371             for (uint i = 0; i < suppliers.length; i++) {
372                 if (suppliers[i] == supplier) {
373                     suppliers[i] = suppliers[suppliers.length - 1];
374                     suppliers.length--;
375                     emit AddSupplier(supplier, false);
376                     break;
377                 }
378             }
379         }
380     }
381 
382     event ListSupplierPairs(address supplier, ERC20 src, ERC20 dest, bool add);
383 
384     /// @notice can be called only by admin
385     /// @dev allow or prevent a specific supplier to trade a pair of tokens
386     /// @param supplier The supplier address.
387     /// @param src Src token
388     /// @param dest Destination token
389     /// @param add If true then enable trade, otherwise delist pair.
390     function listPairForSupplier(address supplier, ERC20 src, ERC20 dest, bool add) public onlyAdmin {
391         (perSupplierListedPairs[supplier])[keccak256(src, dest)] = add;
392 
393         if (src != ETH_TOKEN_ADDRESS) {
394             if (add) {
395                 src.approve(supplier, 2**255); // approve infinity
396                 // src.approve(supplier, src.balanceOf(msg.sender));
397             } else {
398                 src.approve(supplier, 0);
399             }
400         }
401 
402         setDecimals(src);
403         setDecimals(dest);
404 
405         emit ListSupplierPairs(supplier, src, dest, add);
406     }
407 
408     function setParams(
409         WhiteListInterface    _whiteList,
410         ExpectedRateInterface _expectedRate,
411         uint                  _maxGasPrice,
412         uint                  _negligibleRateDiff
413     )
414         public
415         onlyAdmin
416     {
417         require(_whiteList != address(0));
418         require(_expectedRate != address(0));
419         require(_negligibleRateDiff <= 100 * 100); // at most 100%
420         
421         whiteListContract = _whiteList;
422         expectedRateContract = _expectedRate;
423         maxGasPrice = _maxGasPrice;
424         negligibleRateDiff = _negligibleRateDiff;
425     }
426 
427     function setEnable(bool _enable) public onlyAdmin {
428         if (_enable) {
429             require(whiteListContract != address(0));
430             require(expectedRateContract != address(0));
431         }
432         enabled = _enable;
433     }
434 
435     function setInfo(bytes32 field, uint value) public onlyOperator {
436         info[field] = value;
437     }
438 
439     /// @dev returns number of suppliers
440     /// @return number of suppliers
441     function getNumSuppliers() public view returns(uint) {
442         return suppliers.length;
443     }
444 
445     /// @notice should be called off chain with as much gas as needed
446     /// @dev get an array of all suppliers
447     /// @return An array of all suppliers
448     function getSuppliers() public view returns(SupplierInterface[]) {
449         return suppliers;
450     }
451 
452     /// @dev get the balance of a user.
453     /// @param token The token type
454     /// @return The balance
455     function getBalance(ERC20 token, address user) public view returns(uint) {
456         if (token == ETH_TOKEN_ADDRESS)
457             return user.balance;
458         else
459             return token.balanceOf(user);
460     }
461 
462     /// @notice use token address ETH_TOKEN_ADDRESS for ether
463     /// @dev best conversion rate for a pair of tokens, if number of suppliers have small differences. randomize
464     /// @param src Src token
465     /// @param dest Destination token
466     /* solhint-disable code-complexity */
467     function findBestRate(ERC20 src, ERC20 dest, uint srcQty) public view returns(uint, uint) {
468         uint bestRate = 0;
469         uint bestSupplier = 0;
470         uint numRelevantSuppliers = 0;
471         uint numSuppliers = suppliers.length;
472         uint[] memory rates = new uint[](numSuppliers);
473         uint[] memory supplierCandidates = new uint[](numSuppliers);
474 
475         for (uint i = 0; i < numSuppliers; i++) {
476             //list all suppliers that have this token.
477             if (!(perSupplierListedPairs[suppliers[i]])[keccak256(src, dest)]) continue;
478 
479             rates[i] = suppliers[i].getConversionRate(src, dest, srcQty, block.number);
480 
481             if (rates[i] > bestRate) {
482                 //best rate is highest rate
483                 bestRate = rates[i];
484             }
485         }
486 
487         if (bestRate > 0) {
488             uint random = 0;
489             uint smallestRelevantRate = (bestRate * 10000) / (10000 + negligibleRateDiff);
490 
491             for (i = 0; i < numSuppliers; i++) {
492                 if (rates[i] >= smallestRelevantRate) {
493                     supplierCandidates[numRelevantSuppliers++] = i;
494                 }
495             }
496 
497             if (numRelevantSuppliers > 1) {
498                 //when encountering small rate diff from bestRate. draw from relevant suppliers
499                 random = uint(blockhash(block.number-1)) % numRelevantSuppliers;
500             }
501 
502             bestSupplier = supplierCandidates[random];
503             bestRate = rates[bestSupplier];
504         }
505 
506         return (bestSupplier, bestRate);
507     }
508     /* solhint-enable code-complexity */
509 
510     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
511         public view
512         returns (uint expectedRate, uint slippageRate)
513     {
514         require(expectedRateContract != address(0));
515         return expectedRateContract.getExpectedRate(src, dest, srcQty);
516     }
517 
518     function getUserCapInWei(address user) public view returns(uint) {
519         return whiteListContract.getUserCapInWei(user);
520     }
521 
522     // event LogEx(uint no, uint n1, uint n2);
523 
524     function doTrade(
525         ERC20 src,
526         uint srcAmount,
527         ERC20 dest,
528         address destAddress,
529         uint maxDestAmount,
530         uint minConversionRate
531     )
532         internal
533         returns(uint)
534     {
535         require(tx.gasprice <= maxGasPrice);
536         require(validateTradeInput(src, srcAmount, destAddress));
537 
538         uint supplierInd;
539         uint rate;
540 
541         (supplierInd, rate) = findBestRate(src, dest, srcAmount);
542         SupplierInterface theSupplier = suppliers[supplierInd];
543         require(rate > 0);
544         require(rate < MAX_RATE);
545         require(rate >= minConversionRate);
546 
547         uint actualSrcAmount = srcAmount;
548         uint actualDestAmount = calcDestAmount(src, dest, actualSrcAmount, rate);
549         if (actualDestAmount > maxDestAmount) {
550             actualDestAmount = maxDestAmount;
551             actualSrcAmount = calcSrcAmount(src, dest, actualDestAmount, rate);
552             require(actualSrcAmount <= srcAmount);
553         }
554 
555         // do the trade
556         // verify trade size is smaller than user cap
557         uint ethAmount;
558         if (src == ETH_TOKEN_ADDRESS) {
559             ethAmount = actualSrcAmount;
560         } else {
561             ethAmount = actualDestAmount;
562         }
563 
564         require(ethAmount <= getUserCapInWei(msg.sender));
565         require(doSupplierTrade(
566                 src,
567                 actualSrcAmount,
568                 dest,
569                 destAddress,
570                 actualDestAmount,
571                 theSupplier,
572                 rate,
573                 true));
574 
575         if ((actualSrcAmount < srcAmount) && (src == ETH_TOKEN_ADDRESS)) {
576             msg.sender.transfer(srcAmount - actualSrcAmount);
577         }
578 
579 
580         emit ExecuteTrade(msg.sender, src, dest, actualSrcAmount, actualDestAmount);
581         return actualDestAmount;
582     }
583 
584     /// @notice use token address ETH_TOKEN_ADDRESS for ether
585     /// @dev do one trade with a supplier
586     /// @param src Src token
587     /// @param amount amount of src tokens
588     /// @param dest   Destination token
589     /// @param destAddress Address to send tokens to
590     /// @param supplier Supplier to use
591     /// @param validate If true, additional validations are applicable
592     /// @return true if trade is successful
593     function doSupplierTrade(
594         ERC20 src,
595         uint amount,
596         ERC20 dest,
597         address destAddress,
598         uint expectedDestAmount,
599         SupplierInterface supplier,
600         uint conversionRate,
601         bool validate
602     )
603         internal
604         returns(bool)
605     {
606         uint callValue = 0;
607         
608         if (src == ETH_TOKEN_ADDRESS) {
609             callValue = amount;
610         } else {
611             // take src tokens to this contract
612             require(src.transferFrom(msg.sender, this, amount));
613         }
614 
615         // supplier sends tokens/eth to network. network sends it to destination
616 
617         require(supplier.trade.value(callValue)(src, amount, dest, this, conversionRate, validate));
618         emit SupplierTrade(callValue, src, amount, dest, this, conversionRate, validate);
619 
620         if (dest == ETH_TOKEN_ADDRESS) {
621             destAddress.transfer(expectedDestAmount);
622         } else {
623             require(dest.transfer(destAddress, expectedDestAmount));
624         }
625 
626         return true;
627     }
628 
629     event SupplierTrade(uint v, ERC20 src, uint amnt, ERC20 dest, address destAddress, uint conversionRate, bool validate);
630 
631     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
632         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
633     }
634 
635     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
636         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
637     }
638 
639     /// @notice use token address ETH_TOKEN_ADDRESS for ether
640     /// @dev checks that user sent ether/tokens to contract before trade
641     /// @param src Src token
642     /// @param srcAmount amount of src tokens
643     /// @return true if input is valid
644     function validateTradeInput(ERC20 src, uint srcAmount, address destAddress) internal view returns(bool) {
645         if ((srcAmount >= MAX_QTY) || (srcAmount == 0) || (destAddress == 0))
646             return false;
647 
648         if (src == ETH_TOKEN_ADDRESS) {
649             if (msg.value != srcAmount)
650                 return false;
651         } else {
652             if ((msg.value != 0) || (src.allowance(msg.sender, this) < srcAmount))
653                 return false;
654         }
655 
656         return true;
657     }
658 }