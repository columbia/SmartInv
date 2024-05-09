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
17 // File: contracts/KyberNetworkInterface.sol
18 
19 /// @title Kyber Network interface
20 interface KyberNetworkInterface {
21     function maxGasPrice() public view returns(uint);
22     function getUserCapInWei(address user) public view returns(uint);
23     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint);
24     function enabled() public view returns(bool);
25     function info(bytes32 id) public view returns(uint);
26 
27     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
28         returns (uint expectedRate, uint slippageRate);
29 
30     function tradeWithHint(address trader, ERC20 src, uint srcAmount, ERC20 dest, address destAddress,
31         uint maxDestAmount, uint minConversionRate, address walletId, bytes hint) public payable returns(uint);
32 }
33 
34 // File: contracts/KyberNetworkProxyInterface.sol
35 
36 /// @title Kyber Network interface
37 interface KyberNetworkProxyInterface {
38     function maxGasPrice() public view returns(uint);
39     function getUserCapInWei(address user) public view returns(uint);
40     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint);
41     function enabled() public view returns(bool);
42     function info(bytes32 id) public view returns(uint);
43 
44     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
45         returns (uint expectedRate, uint slippageRate);
46 
47     function tradeWithHint(ERC20 src, uint srcAmount, ERC20 dest, address destAddress, uint maxDestAmount,
48         uint minConversionRate, address walletId, bytes hint) public payable returns(uint);
49 }
50 
51 // File: contracts/SimpleNetworkInterface.sol
52 
53 /// @title simple interface for Kyber Network 
54 interface SimpleNetworkInterface {
55     function swapTokenToToken(ERC20 src, uint srcAmount, ERC20 dest, uint minConversionRate) public returns(uint);
56     function swapEtherToToken(ERC20 token, uint minConversionRate) public payable returns(uint);
57     function swapTokenToEther(ERC20 token, uint srcAmount, uint minConversionRate) public returns(uint);
58 }
59 
60 // File: contracts/Utils.sol
61 
62 /// @title Kyber constants contract
63 contract Utils {
64 
65     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
66     uint  constant internal PRECISION = (10**18);
67     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
68     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
69     uint  constant internal MAX_DECIMALS = 18;
70     uint  constant internal ETH_DECIMALS = 18;
71     mapping(address=>uint) internal decimals;
72 
73     function setDecimals(ERC20 token) internal {
74         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
75         else decimals[token] = token.decimals();
76     }
77 
78     function getDecimals(ERC20 token) internal view returns(uint) {
79         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
80         uint tokenDecimals = decimals[token];
81         // technically, there might be token with decimals 0
82         // moreover, very possible that old tokens have decimals 0
83         // these tokens will just have higher gas fees.
84         if(tokenDecimals == 0) return token.decimals();
85 
86         return tokenDecimals;
87     }
88 
89     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
90         require(srcQty <= MAX_QTY);
91         require(rate <= MAX_RATE);
92 
93         if (dstDecimals >= srcDecimals) {
94             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
95             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
96         } else {
97             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
98             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
99         }
100     }
101 
102     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
103         require(dstQty <= MAX_QTY);
104         require(rate <= MAX_RATE);
105         
106         //source quantity is rounded up. to avoid dest quantity being too low.
107         uint numerator;
108         uint denominator;
109         if (srcDecimals >= dstDecimals) {
110             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
111             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
112             denominator = rate;
113         } else {
114             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
115             numerator = (PRECISION * dstQty);
116             denominator = (rate * (10**(dstDecimals - srcDecimals)));
117         }
118         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
119     }
120 }
121 
122 // File: contracts/Utils2.sol
123 
124 contract Utils2 is Utils {
125 
126     /// @dev get the balance of a user.
127     /// @param token The token type
128     /// @return The balance
129     function getBalance(ERC20 token, address user) public view returns(uint) {
130         if (token == ETH_TOKEN_ADDRESS)
131             return user.balance;
132         else
133             return token.balanceOf(user);
134     }
135 
136     function getDecimalsSafe(ERC20 token) internal returns(uint) {
137 
138         if (decimals[token] == 0) {
139             setDecimals(token);
140         }
141 
142         return decimals[token];
143     }
144 
145     /// @dev notice, overrides previous implementation.
146     function setDecimals(ERC20 token) internal {
147         uint decimal;
148 
149         if (token == ETH_TOKEN_ADDRESS) {
150             decimal = ETH_DECIMALS;
151         } else {
152             if (!address(token).call(bytes4(keccak256("decimals()")))) {/* solhint-disable-line avoid-low-level-calls */
153                 //above code can only be performed with low level call. otherwise all operation will revert.
154                 // call failed
155                 decimal = 18;
156             } else {
157                 decimal = token.decimals();
158             }
159         }
160 
161         decimals[token] = decimal;
162     }
163 
164     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
165         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
166     }
167 
168     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
169         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
170     }
171 
172     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
173         internal pure returns(uint)
174     {
175         require(srcAmount <= MAX_QTY);
176         require(destAmount <= MAX_QTY);
177 
178         if (dstDecimals >= srcDecimals) {
179             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
180             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
181         } else {
182             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
183             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
184         }
185     }
186 }
187 
188 // File: contracts/PermissionGroups.sol
189 
190 contract PermissionGroups {
191 
192     address public admin;
193     address public pendingAdmin;
194     mapping(address=>bool) internal operators;
195     mapping(address=>bool) internal alerters;
196     address[] internal operatorsGroup;
197     address[] internal alertersGroup;
198     uint constant internal MAX_GROUP_SIZE = 50;
199 
200     function PermissionGroups() public {
201         admin = msg.sender;
202     }
203 
204     modifier onlyAdmin() {
205         require(msg.sender == admin);
206         _;
207     }
208 
209     modifier onlyOperator() {
210         require(operators[msg.sender]);
211         _;
212     }
213 
214     modifier onlyAlerter() {
215         require(alerters[msg.sender]);
216         _;
217     }
218 
219     function getOperators () external view returns(address[]) {
220         return operatorsGroup;
221     }
222 
223     function getAlerters () external view returns(address[]) {
224         return alertersGroup;
225     }
226 
227     event TransferAdminPending(address pendingAdmin);
228 
229     /**
230      * @dev Allows the current admin to set the pendingAdmin address.
231      * @param newAdmin The address to transfer ownership to.
232      */
233     function transferAdmin(address newAdmin) public onlyAdmin {
234         require(newAdmin != address(0));
235         TransferAdminPending(pendingAdmin);
236         pendingAdmin = newAdmin;
237     }
238 
239     /**
240      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
241      * @param newAdmin The address to transfer ownership to.
242      */
243     function transferAdminQuickly(address newAdmin) public onlyAdmin {
244         require(newAdmin != address(0));
245         TransferAdminPending(newAdmin);
246         AdminClaimed(newAdmin, admin);
247         admin = newAdmin;
248     }
249 
250     event AdminClaimed( address newAdmin, address previousAdmin);
251 
252     /**
253      * @dev Allows the pendingAdmin address to finalize the change admin process.
254      */
255     function claimAdmin() public {
256         require(pendingAdmin == msg.sender);
257         AdminClaimed(pendingAdmin, admin);
258         admin = pendingAdmin;
259         pendingAdmin = address(0);
260     }
261 
262     event AlerterAdded (address newAlerter, bool isAdd);
263 
264     function addAlerter(address newAlerter) public onlyAdmin {
265         require(!alerters[newAlerter]); // prevent duplicates.
266         require(alertersGroup.length < MAX_GROUP_SIZE);
267 
268         AlerterAdded(newAlerter, true);
269         alerters[newAlerter] = true;
270         alertersGroup.push(newAlerter);
271     }
272 
273     function removeAlerter (address alerter) public onlyAdmin {
274         require(alerters[alerter]);
275         alerters[alerter] = false;
276 
277         for (uint i = 0; i < alertersGroup.length; ++i) {
278             if (alertersGroup[i] == alerter) {
279                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
280                 alertersGroup.length--;
281                 AlerterAdded(alerter, false);
282                 break;
283             }
284         }
285     }
286 
287     event OperatorAdded(address newOperator, bool isAdd);
288 
289     function addOperator(address newOperator) public onlyAdmin {
290         require(!operators[newOperator]); // prevent duplicates.
291         require(operatorsGroup.length < MAX_GROUP_SIZE);
292 
293         OperatorAdded(newOperator, true);
294         operators[newOperator] = true;
295         operatorsGroup.push(newOperator);
296     }
297 
298     function removeOperator (address operator) public onlyAdmin {
299         require(operators[operator]);
300         operators[operator] = false;
301 
302         for (uint i = 0; i < operatorsGroup.length; ++i) {
303             if (operatorsGroup[i] == operator) {
304                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
305                 operatorsGroup.length -= 1;
306                 OperatorAdded(operator, false);
307                 break;
308             }
309         }
310     }
311 }
312 
313 // File: contracts/Withdrawable.sol
314 
315 /**
316  * @title Contracts that should be able to recover tokens or ethers
317  * @author Ilan Doron
318  * @dev This allows to recover any tokens or Ethers received in a contract.
319  * This will prevent any accidental loss of tokens.
320  */
321 contract Withdrawable is PermissionGroups {
322 
323     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
324 
325     /**
326      * @dev Withdraw all ERC20 compatible tokens
327      * @param token ERC20 The address of the token contract
328      */
329     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
330         require(token.transfer(sendTo, amount));
331         TokenWithdraw(token, amount, sendTo);
332     }
333 
334     event EtherWithdraw(uint amount, address sendTo);
335 
336     /**
337      * @dev Withdraw Ethers
338      */
339     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
340         sendTo.transfer(amount);
341         EtherWithdraw(amount, sendTo);
342     }
343 }
344 
345 // File: contracts/KyberNetworkProxy.sol
346 
347 ////////////////////////////////////////////////////////////////////////////////////////////////////////
348 /// @title Kyber Network proxy for main contract
349 contract KyberNetworkProxy is KyberNetworkProxyInterface, SimpleNetworkInterface, Withdrawable, Utils2 {
350 
351     KyberNetworkInterface public kyberNetworkContract;
352 
353     function KyberNetworkProxy(address _admin) public {
354         require(_admin != address(0));
355         admin = _admin;
356     }
357 
358     /// @notice use token address ETH_TOKEN_ADDRESS for ether
359     /// @dev makes a trade between src and dest token and send dest token to destAddress
360     /// @param src Src token
361     /// @param srcAmount amount of src tokens
362     /// @param dest   Destination token
363     /// @param destAddress Address to send tokens to
364     /// @param maxDestAmount A limit on the amount of dest tokens
365     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
366     /// @param walletId is the wallet ID to send part of the fees
367     /// @return amount of actual dest tokens
368     function trade(
369         ERC20 src,
370         uint srcAmount,
371         ERC20 dest,
372         address destAddress,
373         uint maxDestAmount,
374         uint minConversionRate,
375         address walletId
376     )
377         public
378         payable
379         returns(uint)
380     {
381         bytes memory hint;
382 
383         return tradeWithHint(
384             src,
385             srcAmount,
386             dest,
387             destAddress,
388             maxDestAmount,
389             minConversionRate,
390             walletId,
391             hint
392         );
393     }
394 
395     /// @dev makes a trade between src and dest token and send dest tokens to msg sender
396     /// @param src Src token
397     /// @param srcAmount amount of src tokens
398     /// @param dest Destination token
399     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
400     /// @return amount of actual dest tokens
401     function swapTokenToToken(
402         ERC20 src,
403         uint srcAmount,
404         ERC20 dest,
405         uint minConversionRate
406     )
407         public
408         returns(uint)
409     {
410         bytes memory hint;
411 
412         return tradeWithHint(
413             src,
414             srcAmount,
415             dest,
416             msg.sender,
417             MAX_QTY,
418             minConversionRate,
419             0,
420             hint
421         );
422     }
423 
424     /// @dev makes a trade from Ether to token. Sends token to msg sender
425     /// @param token Destination token
426     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
427     /// @return amount of actual dest tokens
428     function swapEtherToToken(ERC20 token, uint minConversionRate) public payable returns(uint) {
429         bytes memory hint;
430 
431         return tradeWithHint(
432             ETH_TOKEN_ADDRESS,
433             msg.value,
434             token,
435             msg.sender,
436             MAX_QTY,
437             minConversionRate,
438             0,
439             hint
440         );
441     }
442 
443     /// @dev makes a trade from token to Ether, sends Ether to msg sender
444     /// @param token Src token
445     /// @param srcAmount amount of src tokens
446     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
447     /// @return amount of actual dest tokens
448     function swapTokenToEther(ERC20 token, uint srcAmount, uint minConversionRate) public returns(uint) {
449         bytes memory hint;
450 
451         return tradeWithHint(
452             token,
453             srcAmount,
454             ETH_TOKEN_ADDRESS,
455             msg.sender,
456             MAX_QTY,
457             minConversionRate,
458             0,
459             hint
460         );
461     }
462 
463     struct UserBalance {
464         uint srcBalance;
465         uint destBalance;
466     }
467 
468     event ExecuteTrade(address indexed trader, ERC20 src, ERC20 dest, uint actualSrcAmount, uint actualDestAmount);
469 
470     /// @notice use token address ETH_TOKEN_ADDRESS for ether
471     /// @dev makes a trade between src and dest token and send dest token to destAddress
472     /// @param src Src token
473     /// @param srcAmount amount of src tokens
474     /// @param dest Destination token
475     /// @param destAddress Address to send tokens to
476     /// @param maxDestAmount A limit on the amount of dest tokens
477     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
478     /// @param walletId is the wallet ID to send part of the fees
479     /// @param hint will give hints for the trade.
480     /// @return amount of actual dest tokens
481     function tradeWithHint(
482         ERC20 src,
483         uint srcAmount,
484         ERC20 dest,
485         address destAddress,
486         uint maxDestAmount,
487         uint minConversionRate,
488         address walletId,
489         bytes hint
490     )
491         public
492         payable
493         returns(uint)
494     {
495         require(src == ETH_TOKEN_ADDRESS || msg.value == 0);
496         
497         UserBalance memory userBalanceBefore;
498 
499         userBalanceBefore.srcBalance = getBalance(src, msg.sender);
500         userBalanceBefore.destBalance = getBalance(dest, destAddress);
501 
502         if (src == ETH_TOKEN_ADDRESS) {
503             userBalanceBefore.srcBalance += msg.value;
504         } else {
505             require(src.transferFrom(msg.sender, kyberNetworkContract, srcAmount));
506         }
507 
508         uint reportedDestAmount = kyberNetworkContract.tradeWithHint.value(msg.value)(
509             msg.sender,
510             src,
511             srcAmount,
512             dest,
513             destAddress,
514             maxDestAmount,
515             minConversionRate,
516             walletId,
517             hint
518         );
519 
520         TradeOutcome memory tradeOutcome = calculateTradeOutcome(
521             userBalanceBefore.srcBalance,
522             userBalanceBefore.destBalance,
523             src,
524             dest,
525             destAddress
526         );
527 
528         require(reportedDestAmount == tradeOutcome.userDeltaDestAmount);
529         require(tradeOutcome.userDeltaDestAmount <= maxDestAmount);
530         require(tradeOutcome.actualRate >= minConversionRate);
531 
532         ExecuteTrade(msg.sender, src, dest, tradeOutcome.userDeltaSrcAmount, tradeOutcome.userDeltaDestAmount);
533         return tradeOutcome.userDeltaDestAmount;
534     }
535 
536     event KyberNetworkSet(address newNetworkContract, address oldNetworkContract);
537 
538     function setKyberNetworkContract(KyberNetworkInterface _kyberNetworkContract) public onlyAdmin {
539 
540         require(_kyberNetworkContract != address(0));
541 
542         KyberNetworkSet(_kyberNetworkContract, kyberNetworkContract);
543 
544         kyberNetworkContract = _kyberNetworkContract;
545     }
546 
547     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
548         public view
549         returns(uint expectedRate, uint slippageRate)
550     {
551         return kyberNetworkContract.getExpectedRate(src, dest, srcQty);
552     }
553 
554     function getUserCapInWei(address user) public view returns(uint) {
555         return kyberNetworkContract.getUserCapInWei(user);
556     }
557 
558     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint) {
559         return kyberNetworkContract.getUserCapInTokenWei(user, token);
560     }
561 
562     function maxGasPrice() public view returns(uint) {
563         return kyberNetworkContract.maxGasPrice();
564     }
565 
566     function enabled() public view returns(bool) {
567         return kyberNetworkContract.enabled();
568     }
569 
570     function info(bytes32 field) public view returns(uint) {
571         return kyberNetworkContract.info(field);
572     }
573 
574     struct TradeOutcome {
575         uint userDeltaSrcAmount;
576         uint userDeltaDestAmount;
577         uint actualRate;
578     }
579 
580     function calculateTradeOutcome (uint srcBalanceBefore, uint destBalanceBefore, ERC20 src, ERC20 dest,
581         address destAddress)
582         internal returns(TradeOutcome outcome)
583     {
584         uint userSrcBalanceAfter;
585         uint userDestBalanceAfter;
586 
587         userSrcBalanceAfter = getBalance(src, msg.sender);
588         userDestBalanceAfter = getBalance(dest, destAddress);
589 
590         //protect from underflow
591         require(userDestBalanceAfter > destBalanceBefore);
592         require(srcBalanceBefore > userSrcBalanceAfter);
593 
594         outcome.userDeltaDestAmount = userDestBalanceAfter - destBalanceBefore;
595         outcome.userDeltaSrcAmount = srcBalanceBefore - userSrcBalanceAfter;
596 
597         outcome.actualRate = calcRateFromQty(
598                 outcome.userDeltaSrcAmount,
599                 outcome.userDeltaDestAmount,
600                 getDecimalsSafe(src),
601                 getDecimalsSafe(dest)
602             );
603     }
604 }