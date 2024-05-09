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
145     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
146         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
147     }
148 
149     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
150         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
151     }
152 
153     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
154         internal pure returns(uint)
155     {
156         require(srcAmount <= MAX_QTY);
157         require(destAmount <= MAX_QTY);
158 
159         if (dstDecimals >= srcDecimals) {
160             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
161             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
162         } else {
163             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
164             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
165         }
166     }
167 }
168 
169 // File: contracts/PermissionGroups.sol
170 
171 contract PermissionGroups {
172 
173     address public admin;
174     address public pendingAdmin;
175     mapping(address=>bool) internal operators;
176     mapping(address=>bool) internal alerters;
177     address[] internal operatorsGroup;
178     address[] internal alertersGroup;
179     uint constant internal MAX_GROUP_SIZE = 50;
180 
181     function PermissionGroups() public {
182         admin = msg.sender;
183     }
184 
185     modifier onlyAdmin() {
186         require(msg.sender == admin);
187         _;
188     }
189 
190     modifier onlyOperator() {
191         require(operators[msg.sender]);
192         _;
193     }
194 
195     modifier onlyAlerter() {
196         require(alerters[msg.sender]);
197         _;
198     }
199 
200     function getOperators () external view returns(address[]) {
201         return operatorsGroup;
202     }
203 
204     function getAlerters () external view returns(address[]) {
205         return alertersGroup;
206     }
207 
208     event TransferAdminPending(address pendingAdmin);
209 
210     /**
211      * @dev Allows the current admin to set the pendingAdmin address.
212      * @param newAdmin The address to transfer ownership to.
213      */
214     function transferAdmin(address newAdmin) public onlyAdmin {
215         require(newAdmin != address(0));
216         TransferAdminPending(pendingAdmin);
217         pendingAdmin = newAdmin;
218     }
219 
220     /**
221      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
222      * @param newAdmin The address to transfer ownership to.
223      */
224     function transferAdminQuickly(address newAdmin) public onlyAdmin {
225         require(newAdmin != address(0));
226         TransferAdminPending(newAdmin);
227         AdminClaimed(newAdmin, admin);
228         admin = newAdmin;
229     }
230 
231     event AdminClaimed( address newAdmin, address previousAdmin);
232 
233     /**
234      * @dev Allows the pendingAdmin address to finalize the change admin process.
235      */
236     function claimAdmin() public {
237         require(pendingAdmin == msg.sender);
238         AdminClaimed(pendingAdmin, admin);
239         admin = pendingAdmin;
240         pendingAdmin = address(0);
241     }
242 
243     event AlerterAdded (address newAlerter, bool isAdd);
244 
245     function addAlerter(address newAlerter) public onlyAdmin {
246         require(!alerters[newAlerter]); // prevent duplicates.
247         require(alertersGroup.length < MAX_GROUP_SIZE);
248 
249         AlerterAdded(newAlerter, true);
250         alerters[newAlerter] = true;
251         alertersGroup.push(newAlerter);
252     }
253 
254     function removeAlerter (address alerter) public onlyAdmin {
255         require(alerters[alerter]);
256         alerters[alerter] = false;
257 
258         for (uint i = 0; i < alertersGroup.length; ++i) {
259             if (alertersGroup[i] == alerter) {
260                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
261                 alertersGroup.length--;
262                 AlerterAdded(alerter, false);
263                 break;
264             }
265         }
266     }
267 
268     event OperatorAdded(address newOperator, bool isAdd);
269 
270     function addOperator(address newOperator) public onlyAdmin {
271         require(!operators[newOperator]); // prevent duplicates.
272         require(operatorsGroup.length < MAX_GROUP_SIZE);
273 
274         OperatorAdded(newOperator, true);
275         operators[newOperator] = true;
276         operatorsGroup.push(newOperator);
277     }
278 
279     function removeOperator (address operator) public onlyAdmin {
280         require(operators[operator]);
281         operators[operator] = false;
282 
283         for (uint i = 0; i < operatorsGroup.length; ++i) {
284             if (operatorsGroup[i] == operator) {
285                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
286                 operatorsGroup.length -= 1;
287                 OperatorAdded(operator, false);
288                 break;
289             }
290         }
291     }
292 }
293 
294 // File: contracts/Withdrawable.sol
295 
296 /**
297  * @title Contracts that should be able to recover tokens or ethers
298  * @author Ilan Doron
299  * @dev This allows to recover any tokens or Ethers received in a contract.
300  * This will prevent any accidental loss of tokens.
301  */
302 contract Withdrawable is PermissionGroups {
303 
304     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
305 
306     /**
307      * @dev Withdraw all ERC20 compatible tokens
308      * @param token ERC20 The address of the token contract
309      */
310     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
311         require(token.transfer(sendTo, amount));
312         TokenWithdraw(token, amount, sendTo);
313     }
314 
315     event EtherWithdraw(uint amount, address sendTo);
316 
317     /**
318      * @dev Withdraw Ethers
319      */
320     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
321         sendTo.transfer(amount);
322         EtherWithdraw(amount, sendTo);
323     }
324 }
325 
326 // File: contracts/KyberNetworkProxy.sol
327 
328 ////////////////////////////////////////////////////////////////////////////////////////////////////////
329 /// @title Kyber Network proxy for main contract
330 contract KyberNetworkProxy is KyberNetworkProxyInterface, SimpleNetworkInterface, Withdrawable, Utils2 {
331 
332     KyberNetworkInterface public kyberNetworkContract;
333 
334     function KyberNetworkProxy(address _admin) public {
335         require(_admin != address(0));
336         admin = _admin;
337     }
338 
339     /// @notice use token address ETH_TOKEN_ADDRESS for ether
340     /// @dev makes a trade between src and dest token and send dest token to destAddress
341     /// @param src Src token
342     /// @param srcAmount amount of src tokens
343     /// @param dest   Destination token
344     /// @param destAddress Address to send tokens to
345     /// @param maxDestAmount A limit on the amount of dest tokens
346     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
347     /// @param walletId is the wallet ID to send part of the fees
348     /// @return amount of actual dest tokens
349     function trade(
350         ERC20 src,
351         uint srcAmount,
352         ERC20 dest,
353         address destAddress,
354         uint maxDestAmount,
355         uint minConversionRate,
356         address walletId
357     )
358         public
359         payable
360         returns(uint)
361     {
362         bytes memory hint;
363 
364         return tradeWithHint(
365             src,
366             srcAmount,
367             dest,
368             destAddress,
369             maxDestAmount,
370             minConversionRate,
371             walletId,
372             hint
373         );
374     }
375 
376     /// @dev makes a trade between src and dest token and send dest tokens to msg sender
377     /// @param src Src token
378     /// @param srcAmount amount of src tokens
379     /// @param dest Destination token
380     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
381     /// @return amount of actual dest tokens
382     function swapTokenToToken(
383         ERC20 src,
384         uint srcAmount,
385         ERC20 dest,
386         uint minConversionRate
387     )
388         public
389         returns(uint)
390     {
391         bytes memory hint;
392 
393         return tradeWithHint(
394             src,
395             srcAmount,
396             dest,
397             msg.sender,
398             MAX_QTY,
399             minConversionRate,
400             0,
401             hint
402         );
403     }
404 
405     /// @dev makes a trade from Ether to token. Sends token to msg sender
406     /// @param token Destination token
407     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
408     /// @return amount of actual dest tokens
409     function swapEtherToToken(ERC20 token, uint minConversionRate) public payable returns(uint) {
410         bytes memory hint;
411 
412         return tradeWithHint(
413             ETH_TOKEN_ADDRESS,
414             msg.value,
415             token,
416             msg.sender,
417             MAX_QTY,
418             minConversionRate,
419             0,
420             hint
421         );
422     }
423 
424     /// @dev makes a trade from token to Ether, sends Ether to msg sender
425     /// @param token Src token
426     /// @param srcAmount amount of src tokens
427     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
428     /// @return amount of actual dest tokens
429     function swapTokenToEther(ERC20 token, uint srcAmount, uint minConversionRate) public returns(uint) {
430         bytes memory hint;
431 
432         return tradeWithHint(
433             token,
434             srcAmount,
435             ETH_TOKEN_ADDRESS,
436             msg.sender,
437             MAX_QTY,
438             minConversionRate,
439             0,
440             hint
441         );
442     }
443 
444     struct UserBalance {
445         uint srcBalance;
446         uint destBalance;
447     }
448 
449     event ExecuteTrade(address indexed trader, ERC20 src, ERC20 dest, uint actualSrcAmount, uint actualDestAmount);
450 
451     /// @notice use token address ETH_TOKEN_ADDRESS for ether
452     /// @dev makes a trade between src and dest token and send dest token to destAddress
453     /// @param src Src token
454     /// @param srcAmount amount of src tokens
455     /// @param dest Destination token
456     /// @param destAddress Address to send tokens to
457     /// @param maxDestAmount A limit on the amount of dest tokens
458     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
459     /// @param walletId is the wallet ID to send part of the fees
460     /// @param hint will give hints for the trade.
461     /// @return amount of actual dest tokens
462     function tradeWithHint(
463         ERC20 src,
464         uint srcAmount,
465         ERC20 dest,
466         address destAddress,
467         uint maxDestAmount,
468         uint minConversionRate,
469         address walletId,
470         bytes hint
471     )
472         public
473         payable
474         returns(uint)
475     {
476         require(src == ETH_TOKEN_ADDRESS || msg.value == 0);
477         
478         UserBalance memory userBalanceBefore;
479 
480         userBalanceBefore.srcBalance = getBalance(src, msg.sender);
481         userBalanceBefore.destBalance = getBalance(dest, destAddress);
482 
483         if (src == ETH_TOKEN_ADDRESS) {
484             userBalanceBefore.srcBalance += msg.value;
485         } else {
486             require(src.transferFrom(msg.sender, kyberNetworkContract, srcAmount));
487         }
488 
489         uint reportedDestAmount = kyberNetworkContract.tradeWithHint.value(msg.value)(
490             msg.sender,
491             src,
492             srcAmount,
493             dest,
494             destAddress,
495             maxDestAmount,
496             minConversionRate,
497             walletId,
498             hint
499         );
500 
501         TradeOutcome memory tradeOutcome = calculateTradeOutcome(
502             userBalanceBefore.srcBalance,
503             userBalanceBefore.destBalance,
504             src,
505             dest,
506             destAddress
507         );
508 
509         require(reportedDestAmount == tradeOutcome.userDeltaDestAmount);
510         require(tradeOutcome.userDeltaDestAmount <= maxDestAmount);
511         require(tradeOutcome.actualRate >= minConversionRate);
512 
513         ExecuteTrade(msg.sender, src, dest, tradeOutcome.userDeltaSrcAmount, tradeOutcome.userDeltaDestAmount);
514         return tradeOutcome.userDeltaDestAmount;
515     }
516 
517     event KyberNetworkSet(address newNetworkContract, address oldNetworkContract);
518 
519     function setKyberNetworkContract(KyberNetworkInterface _kyberNetworkContract) public onlyAdmin {
520 
521         require(_kyberNetworkContract != address(0));
522 
523         KyberNetworkSet(_kyberNetworkContract, kyberNetworkContract);
524 
525         kyberNetworkContract = _kyberNetworkContract;
526     }
527 
528     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
529         public view
530         returns(uint expectedRate, uint slippageRate)
531     {
532         return kyberNetworkContract.getExpectedRate(src, dest, srcQty);
533     }
534 
535     function getUserCapInWei(address user) public view returns(uint) {
536         return kyberNetworkContract.getUserCapInWei(user);
537     }
538 
539     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint) {
540         return kyberNetworkContract.getUserCapInTokenWei(user, token);
541     }
542 
543     function maxGasPrice() public view returns(uint) {
544         return kyberNetworkContract.maxGasPrice();
545     }
546 
547     function enabled() public view returns(bool) {
548         return kyberNetworkContract.enabled();
549     }
550 
551     function info(bytes32 field) public view returns(uint) {
552         return kyberNetworkContract.info(field);
553     }
554 
555     struct TradeOutcome {
556         uint userDeltaSrcAmount;
557         uint userDeltaDestAmount;
558         uint actualRate;
559     }
560 
561     function calculateTradeOutcome (uint srcBalanceBefore, uint destBalanceBefore, ERC20 src, ERC20 dest,
562         address destAddress)
563         internal returns(TradeOutcome outcome)
564     {
565         uint userSrcBalanceAfter;
566         uint userDestBalanceAfter;
567 
568         userSrcBalanceAfter = getBalance(src, msg.sender);
569         userDestBalanceAfter = getBalance(dest, destAddress);
570 
571         //protect from underflow
572         require(userDestBalanceAfter > destBalanceBefore);
573         require(srcBalanceBefore > userSrcBalanceAfter);
574 
575         outcome.userDeltaDestAmount = userDestBalanceAfter - destBalanceBefore;
576         outcome.userDeltaSrcAmount = srcBalanceBefore - userSrcBalanceAfter;
577 
578         outcome.actualRate = calcRateFromQty(
579                 outcome.userDeltaSrcAmount,
580                 outcome.userDeltaDestAmount,
581                 getDecimalsSafe(src),
582                 getDecimalsSafe(dest)
583             );
584     }
585 }