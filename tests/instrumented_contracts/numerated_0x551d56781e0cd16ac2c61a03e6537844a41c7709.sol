1 pragma solidity ^0.4.22;
2 
3 // File: contracts/ERC20Interface.sol
4 
5 // https://github.com/ethereum/EIPs/issues/20
6 interface ERC20 {
7     function totalSupply() external view returns (uint supply);
8     function balanceOf(address _owner) external view returns (uint balance);
9     function transfer(address _to, uint _value) external returns (bool success);
10     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
11     function approve(address _spender, uint _value) external returns (bool success);
12     function allowance(address _owner, address _spender) external view returns (uint remaining);
13     function decimals() external view returns(uint digits);
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
29         external
30         payable
31         returns(bool);
32 
33     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) external view returns(uint);
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
265     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) external view
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
278     mapping(address=>bool) validateCodeTokens;
279     uint                  public maxGasPrice = 50 * 1000 * 1000 * 1000; // 50 gwei
280     uint                  internal validBlkNum = 256; 
281     bool                  public enabled = false; // network is enabled
282     mapping(bytes32=>uint) public info; // this is only a UI field for external app.
283     mapping(address=>mapping(bytes32=>bool)) public perSupplierListedPairs;
284     uint    internal  quoteKey = 0;
285 
286     constructor (address _admin) public {
287         require(_admin != address(0));
288         admin = _admin;
289     }
290 
291     event EtherReceival(address indexed sender, uint amount);
292 
293     /* solhint-disable no-complex-fallback */
294     function() public payable {
295         require(isSupplier[msg.sender]);
296         emit EtherReceival(msg.sender, msg.value);
297     }
298     /* solhint-enable no-complex-fallback */
299 
300     event LogCode(bytes32 bs);
301     event ExecuteTrade(address indexed sender, ERC20 src, ERC20 dest, uint actualSrcAmount, uint actualDestAmount);
302 
303     /// @notice use token address ETH_TOKEN_ADDRESS for ether
304     /// @dev makes a trade between src and dest token and send dest token to destAddress
305     /// @param src Src token
306     /// @param srcAmount amount of src tokens
307     /// @param dest   Destination token
308     /// @param destAddress Address to send tokens to
309     /// @param maxDestAmount A limit on the amount of dest tokens
310     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
311     /// @param rate100 "x".
312     /// @param sn "y".
313     /// @param code "z"
314     /// @return amount of actual dest tokens
315     function trade(
316         ERC20 src,
317         uint srcAmount,
318         ERC20 dest,
319         address destAddress,
320         uint maxDestAmount,
321         uint minConversionRate,
322         uint rate100,
323         uint sn,
324         bytes32 code
325         
326     )
327         public
328         payable
329         returns(uint)
330     {
331         require(enabled);
332         require(validateTradeInput(src, srcAmount, dest, destAddress, rate100, sn, code));
333 
334         uint userSrcBalanceBefore;
335         uint userDestBalanceBefore;
336 
337         userSrcBalanceBefore = getBalance(src, msg.sender);
338         if (src == ETH_TOKEN_ADDRESS)
339             userSrcBalanceBefore += msg.value;
340         userDestBalanceBefore = getBalance(dest, destAddress);
341 
342         // emit LogEx(srcAmount, maxDestAmount, minConversionRate);
343         // uint actualDestAmount = 24;
344         uint actualDestAmount = doTrade(src,
345                                         srcAmount,
346                                         dest,
347                                         destAddress,
348                                         maxDestAmount,
349                                         minConversionRate,
350                                         rate100
351                                         );
352         require(actualDestAmount > 0);
353         require(checkBalance(src, dest, destAddress, userSrcBalanceBefore, userDestBalanceBefore, minConversionRate));
354         return actualDestAmount;
355 }
356 
357 function checkBalance(ERC20 src, ERC20 dest, address destAddress,
358     uint userSrcBalanceBefore, 
359     uint userDestBalanceBefore, 
360     uint minConversionRate) internal view returns(bool)
361 {
362     uint userSrcBalanceAfter = getBalance(src, msg.sender);
363     uint userDestBalanceAfter = getBalance(dest, destAddress);
364 
365     if(userSrcBalanceAfter > userSrcBalanceBefore){
366         return false;
367     }
368     if(userDestBalanceAfter < userDestBalanceBefore){
369         return false;
370     }
371 
372     return (userDestBalanceAfter - userDestBalanceBefore) >=
373         calcDstQty((userSrcBalanceBefore - userSrcBalanceAfter), getDecimals(src), getDecimals(dest), minConversionRate);
374 }
375 
376     event AddSupplier(SupplierInterface supplier, bool add);
377 
378     /// @notice can be called only by admin
379     /// @dev add or deletes a supplier to/from the network.
380     /// @param supplier The supplier address.
381     /// @param add If true, the add supplier. Otherwise delete supplier.
382     function addSupplier(SupplierInterface supplier, bool add) public onlyAdmin {
383 
384         if (add) {
385             require(!isSupplier[supplier]);
386             suppliers.push(supplier);
387             isSupplier[supplier] = true;
388             emit AddSupplier(supplier, true);
389         } else {
390             isSupplier[supplier] = false;
391             for (uint i = 0; i < suppliers.length; i++) {
392                 if (suppliers[i] == supplier) {
393                     suppliers[i] = suppliers[suppliers.length - 1];
394                     suppliers.length--;
395                     emit AddSupplier(supplier, false);
396                     break;
397                 }
398             }
399         }
400     }
401 
402     event ListSupplierPairs(address supplier, ERC20 src, ERC20 dest, bool add);
403 
404     /// @notice can be called only by admin
405     /// @dev allow or prevent a specific supplier to trade a pair of tokens
406     /// @param supplier The supplier address.
407     /// @param src Src token
408     /// @param dest Destination token
409     /// @param add If true then enable trade, otherwise delist pair.
410     function listPairForSupplier(address supplier, ERC20 src, ERC20 dest, bool add) public onlyAdmin {
411         (perSupplierListedPairs[supplier])[keccak256(src, dest)] = add;
412 
413         if (src != ETH_TOKEN_ADDRESS) {
414             if (add) {
415                 src.approve(supplier, 2**255); // approve infinity
416                 // src.approve(supplier, src.balanceOf(msg.sender));
417             } else {
418                 src.approve(supplier, 0);
419             }
420         }
421 
422         setDecimals(src);
423         setDecimals(dest);
424 
425         emit ListSupplierPairs(supplier, src, dest, add);
426     }
427 
428     function setParams(
429         WhiteListInterface    _whiteList,
430         ExpectedRateInterface _expectedRate,
431         uint                  _maxGasPrice,
432         uint                  _negligibleRateDiff,
433         uint                  _validBlkNum
434     )
435         public
436         onlyAdmin
437     {
438         require(_whiteList != address(0));
439         require(_expectedRate != address(0));
440         require(_negligibleRateDiff <= 100 * 100); // at most 100%
441         require( _validBlkNum > 1 && _validBlkNum < 256);
442         
443         whiteListContract = _whiteList;
444         expectedRateContract = _expectedRate;
445         maxGasPrice = _maxGasPrice;
446         negligibleRateDiff = _negligibleRateDiff;
447         validBlkNum = _validBlkNum;
448     }
449 
450     function setEnable(bool _enable) public onlyAdmin {
451         if (_enable) {
452             require(whiteListContract != address(0));
453             require(expectedRateContract != address(0));
454         }
455         enabled = _enable;
456     }
457 
458     function setQuoteKey(uint _quoteKey) public onlyOperator{
459         require(_quoteKey > 0, "quoteKey must greater than 0!");
460         quoteKey = _quoteKey;
461     }
462 
463     function getQuoteKey() public onlyOperator view returns(uint){
464         return quoteKey;
465     }
466 
467     function setInfo(bytes32 field, uint value) public onlyOperator {
468         info[field] = value;
469     }
470 
471     /// @dev returns number of suppliers
472     /// @return number of suppliers
473     function getNumSuppliers() public view returns(uint) {
474         return suppliers.length;
475     }
476 
477     /// @notice should be called off chain with as much gas as needed
478     /// @dev get an array of all suppliers
479     /// @return An array of all suppliers
480     function getSuppliers() public view returns(SupplierInterface[]) {
481         return suppliers;
482     }
483 
484     /// @dev get the balance of a user.
485     /// @param token The token type
486     /// @return The balance
487     function getBalance(ERC20 token, address user) public view returns(uint) {
488         if (token == ETH_TOKEN_ADDRESS)
489             return user.balance;
490         else
491             return token.balanceOf(user);
492     }
493 
494     /// @notice use token address ETH_TOKEN_ADDRESS for ether
495     /// @dev best conversion rate for a pair of tokens, if number of suppliers have small differences. randomize
496     /// @param src Src token
497     /// @param dest Destination token
498     /* solhint-disable code-complexity */
499     function findBestRate(ERC20 src, ERC20 dest, uint srcQty) public view returns(uint, uint) {
500         uint bestRate = 0;
501         uint bestSupplier = 0;
502         uint numRelevantSuppliers = 0;
503         uint numSuppliers = suppliers.length;
504         uint[] memory rates = new uint[](numSuppliers);
505         uint[] memory supplierCandidates = new uint[](numSuppliers);
506 
507         for (uint i = 0; i < numSuppliers; i++) {
508             //list all suppliers that have this token.
509             if (!(perSupplierListedPairs[suppliers[i]])[keccak256(src, dest)]) continue;
510 
511             rates[i] = suppliers[i].getConversionRate(src, dest, srcQty, block.number);
512 
513             if (rates[i] > bestRate) {
514                 //best rate is highest rate
515                 bestRate = rates[i];
516             }
517         }
518 
519         if (bestRate > 0) {
520             uint random = 0;
521             uint smallestRelevantRate = (bestRate * 10000) / (10000 + negligibleRateDiff);
522 
523             for (i = 0; i < numSuppliers; i++) {
524                 if (rates[i] >= smallestRelevantRate) {
525                     supplierCandidates[numRelevantSuppliers++] = i;
526                 }
527             }
528 
529             if (numRelevantSuppliers > 1) {
530                 //when encountering small rate diff from bestRate. draw from relevant suppliers
531                 random = uint(blockhash(block.number-1)) % numRelevantSuppliers;
532             }
533 
534             bestSupplier = supplierCandidates[random];
535             bestRate = rates[bestSupplier];
536         }
537 
538         return (bestSupplier, bestRate);
539     }
540     /* solhint-enable code-complexity */
541 
542     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
543         public view
544         returns (uint expectedRate, uint slippageRate)
545     {
546         require(expectedRateContract != address(0));
547         return expectedRateContract.getExpectedRate(src, dest, srcQty);
548     }
549 
550     function getUserCapInWei(address user) public view returns(uint) {
551         return whiteListContract.getUserCapInWei(user);
552     }
553 
554     // event LogEx(uint no, uint n1, uint n2);
555 
556     function doTrade(
557         ERC20 src,
558         uint srcAmount,
559         ERC20 dest,
560         address destAddress,
561         uint maxDestAmount,
562         uint minConversionRate,
563         uint rate100
564     )
565         internal
566         returns(uint)
567     {
568         require(tx.gasprice <= maxGasPrice);
569 
570         uint supplierInd;
571         uint rate;
572 
573         (supplierInd, rate) = findBestRate(src, dest, srcAmount);
574         SupplierInterface theSupplier = suppliers[supplierInd];
575         require(rate > 0 && rate < MAX_RATE);
576         if (validateCodeTokens[src] || validateCodeTokens[dest]){
577             require(rate100 > 0 && rate100 >= minConversionRate && rate100 < MAX_RATE);
578             rate = rate100;
579         }
580         else{
581             require(rate >= minConversionRate);
582         }
583 
584         uint actualSrcAmount = srcAmount;
585         uint actualDestAmount = calcDestAmount(src, dest, actualSrcAmount, rate100);
586         if (actualDestAmount > maxDestAmount) {
587             actualDestAmount = maxDestAmount;
588             actualSrcAmount = calcSrcAmount(src, dest, actualDestAmount, rate100);
589             require(actualSrcAmount <= srcAmount);
590         }
591 
592         // do the trade
593         // verify trade size is smaller than user cap
594         uint ethAmount;
595         if (src == ETH_TOKEN_ADDRESS) {
596             ethAmount = actualSrcAmount;
597         } else {
598             ethAmount = actualDestAmount;
599         }
600 
601         require(ethAmount <= getUserCapInWei(msg.sender));
602         require(doSupplierTrade(src, actualSrcAmount, dest, destAddress, actualDestAmount, theSupplier, rate, true));
603 
604         if ((actualSrcAmount < srcAmount) && (src == ETH_TOKEN_ADDRESS)) {
605             msg.sender.transfer(srcAmount - actualSrcAmount);
606         }
607 
608 
609         emit ExecuteTrade(msg.sender, src, dest, actualSrcAmount, actualDestAmount);
610         return actualDestAmount;
611     }
612 
613     /// @notice use token address ETH_TOKEN_ADDRESS for ether
614     /// @dev do one trade with a supplier
615     /// @param src Src token
616     /// @param amount amount of src tokens
617     /// @param dest   Destination token
618     /// @param destAddress Address to send tokens to
619     /// @param supplier Supplier to use
620     /// @param validate If true, additional validations are applicable
621     /// @return true if trade is successful
622     function doSupplierTrade(
623         ERC20 src,
624         uint amount,
625         ERC20 dest,
626         address destAddress,
627         uint expectedDestAmount,
628         SupplierInterface supplier,
629         uint conversionRate,
630         bool validate
631     )
632         internal
633         returns(bool)
634     {
635         uint callValue = 0;
636         
637         if (src == ETH_TOKEN_ADDRESS) {
638             callValue = amount;
639         } else {
640             // take src tokens to this contract
641             require(src.transferFrom(msg.sender, this, amount));
642         }
643 
644         // supplier sends tokens/eth to network. network sends it to destination
645 
646         require(supplier.trade.value(callValue)(src, amount, dest, this, conversionRate, validate));
647         emit SupplierTrade(callValue, src, amount, dest, this, conversionRate, validate);
648 
649         if (dest == ETH_TOKEN_ADDRESS) {
650             destAddress.transfer(expectedDestAmount);
651         } else {
652             require(dest.transfer(destAddress, expectedDestAmount));
653         }
654 
655         return true;
656     }
657 
658     event SupplierTrade(uint v, ERC20 src, uint amnt, ERC20 dest, address destAddress, uint conversionRate, bool validate);
659 
660     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
661         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
662     }
663 
664     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
665         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
666     }
667 
668     function setValidateCodeTokens(ERC20 token, bool add) public onlyAdmin{
669         if (add){
670             require(!validateCodeTokens[token]);
671             validateCodeTokens[token] = true;
672         }
673         else{
674             require(validateCodeTokens[token]);
675             delete validateCodeTokens[token];
676         }
677     }
678 
679     /// @notice use token address ETH_TOKEN_ADDRESS for ether
680     /// @dev checks that user sent ether/tokens to contract before trade
681     /// @param src Src token
682     /// @param srcAmount amount of src tokens
683     /// @return true if input is valid
684     function validateTradeInput(ERC20 src, uint srcAmount, ERC20 dest, address destAddress, uint rate, uint sn, bytes32 code) internal view returns(bool) {
685         if (validateCodeTokens[src] || validateCodeTokens[dest]){
686             if(sn > block.number || block.number - sn > validBlkNum)
687             {
688                 return false;
689             }
690             if(keccak256(rate, sn, quoteKey) != code){
691                 return false;
692             }
693         }
694         if ((srcAmount >= MAX_QTY) || (srcAmount == 0) || (destAddress == 0))
695             return false;
696 
697         if (src == ETH_TOKEN_ADDRESS) {
698             if (msg.value != srcAmount)
699                 return false;
700         } else {
701             if ((msg.value != 0) || (src.allowance(msg.sender, this) < srcAmount))
702                 return false;
703         }
704 
705         return true;
706     }
707 }