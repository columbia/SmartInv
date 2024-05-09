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
17 // File: contracts/PermissionGroups.sol
18 
19 contract PermissionGroups {
20 
21     address public admin;
22     address public pendingAdmin;
23     mapping(address=>bool) internal operators;
24     mapping(address=>bool) internal alerters;
25     address[] internal operatorsGroup;
26     address[] internal alertersGroup;
27     uint constant internal MAX_GROUP_SIZE = 50;
28 
29     function PermissionGroups() public {
30         admin = msg.sender;
31     }
32 
33     modifier onlyAdmin() {
34         require(msg.sender == admin);
35         _;
36     }
37 
38     modifier onlyOperator() {
39         require(operators[msg.sender]);
40         _;
41     }
42 
43     modifier onlyAlerter() {
44         require(alerters[msg.sender]);
45         _;
46     }
47 
48     function getOperators () external view returns(address[]) {
49         return operatorsGroup;
50     }
51 
52     function getAlerters () external view returns(address[]) {
53         return alertersGroup;
54     }
55 
56     event TransferAdminPending(address pendingAdmin);
57 
58     /**
59      * @dev Allows the current admin to set the pendingAdmin address.
60      * @param newAdmin The address to transfer ownership to.
61      */
62     function transferAdmin(address newAdmin) public onlyAdmin {
63         require(newAdmin != address(0));
64         TransferAdminPending(pendingAdmin);
65         pendingAdmin = newAdmin;
66     }
67 
68     /**
69      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
70      * @param newAdmin The address to transfer ownership to.
71      */
72     function transferAdminQuickly(address newAdmin) public onlyAdmin {
73         require(newAdmin != address(0));
74         TransferAdminPending(newAdmin);
75         AdminClaimed(newAdmin, admin);
76         admin = newAdmin;
77     }
78 
79     event AdminClaimed( address newAdmin, address previousAdmin);
80 
81     /**
82      * @dev Allows the pendingAdmin address to finalize the change admin process.
83      */
84     function claimAdmin() public {
85         require(pendingAdmin == msg.sender);
86         AdminClaimed(pendingAdmin, admin);
87         admin = pendingAdmin;
88         pendingAdmin = address(0);
89     }
90 
91     event AlerterAdded (address newAlerter, bool isAdd);
92 
93     function addAlerter(address newAlerter) public onlyAdmin {
94         require(!alerters[newAlerter]); // prevent duplicates.
95         require(alertersGroup.length < MAX_GROUP_SIZE);
96 
97         AlerterAdded(newAlerter, true);
98         alerters[newAlerter] = true;
99         alertersGroup.push(newAlerter);
100     }
101 
102     function removeAlerter (address alerter) public onlyAdmin {
103         require(alerters[alerter]);
104         alerters[alerter] = false;
105 
106         for (uint i = 0; i < alertersGroup.length; ++i) {
107             if (alertersGroup[i] == alerter) {
108                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
109                 alertersGroup.length--;
110                 AlerterAdded(alerter, false);
111                 break;
112             }
113         }
114     }
115 
116     event OperatorAdded(address newOperator, bool isAdd);
117 
118     function addOperator(address newOperator) public onlyAdmin {
119         require(!operators[newOperator]); // prevent duplicates.
120         require(operatorsGroup.length < MAX_GROUP_SIZE);
121 
122         OperatorAdded(newOperator, true);
123         operators[newOperator] = true;
124         operatorsGroup.push(newOperator);
125     }
126 
127     function removeOperator (address operator) public onlyAdmin {
128         require(operators[operator]);
129         operators[operator] = false;
130 
131         for (uint i = 0; i < operatorsGroup.length; ++i) {
132             if (operatorsGroup[i] == operator) {
133                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
134                 operatorsGroup.length -= 1;
135                 OperatorAdded(operator, false);
136                 break;
137             }
138         }
139     }
140 }
141 
142 // File: contracts/Withdrawable.sol
143 
144 /**
145  * @title Contracts that should be able to recover tokens or ethers
146  * @author Ilan Doron
147  * @dev This allows to recover any tokens or Ethers received in a contract.
148  * This will prevent any accidental loss of tokens.
149  */
150 contract Withdrawable is PermissionGroups {
151 
152     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
153 
154     /**
155      * @dev Withdraw all ERC20 compatible tokens
156      * @param token ERC20 The address of the token contract
157      */
158     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
159         require(token.transfer(sendTo, amount));
160         TokenWithdraw(token, amount, sendTo);
161     }
162 
163     event EtherWithdraw(uint amount, address sendTo);
164 
165     /**
166      * @dev Withdraw Ethers
167      */
168     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
169         sendTo.transfer(amount);
170         EtherWithdraw(amount, sendTo);
171     }
172 }
173 
174 // File: contracts/KyberReserveInterface.sol
175 
176 /// @title Kyber Reserve contract
177 interface KyberReserveInterface {
178 
179     function trade(
180         ERC20 srcToken,
181         uint srcAmount,
182         ERC20 destToken,
183         address destAddress,
184         uint conversionRate,
185         bool validate
186     )
187         public
188         payable
189         returns(bool);
190 
191     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
192 }
193 
194 // File: contracts/Utils.sol
195 
196 /// @title Kyber constants contract
197 contract Utils {
198 
199     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
200     uint  constant internal PRECISION = (10**18);
201     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
202     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
203     uint  constant internal MAX_DECIMALS = 18;
204     uint  constant internal ETH_DECIMALS = 18;
205     mapping(address=>uint) internal decimals;
206 
207     function setDecimals(ERC20 token) internal {
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
256 // File: contracts/Utils2.sol
257 
258 contract Utils2 is Utils {
259 
260     /// @dev get the balance of a user.
261     /// @param token The token type
262     /// @return The balance
263     function getBalance(ERC20 token, address user) public view returns(uint) {
264         if (token == ETH_TOKEN_ADDRESS)
265             return user.balance;
266         else
267             return token.balanceOf(user);
268     }
269 
270     function getDecimalsSafe(ERC20 token) internal returns(uint) {
271 
272         if (decimals[token] == 0) {
273             setDecimals(token);
274         }
275 
276         return decimals[token];
277     }
278 
279     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
280         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
281     }
282 
283     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
284         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
285     }
286 
287     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
288         internal pure returns(uint)
289     {
290         require(srcAmount <= MAX_QTY);
291         require(destAmount <= MAX_QTY);
292 
293         if (dstDecimals >= srcDecimals) {
294             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
295             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
296         } else {
297             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
298             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
299         }
300     }
301 }
302 
303 // File: contracts/uniswap/KyberUniswapReserve.sol
304 
305 interface UniswapExchange {
306     function ethToTokenSwapInput(
307         uint256 min_tokens,
308         uint256 deadline
309     )
310         external
311         payable
312         returns (uint256  tokens_bought);
313 
314     function tokenToEthSwapInput(
315         uint256 tokens_sold,
316         uint256 min_eth,
317         uint256 deadline
318     )
319         external
320         returns (uint256  eth_bought);
321 
322     function getEthToTokenInputPrice(
323         uint256 eth_sold
324     )
325         external
326         view
327         returns (uint256 tokens_bought);
328 
329     function getTokenToEthInputPrice(
330         uint256 tokens_sold
331     )
332         external
333         view
334         returns (uint256 eth_bought);
335 }
336 
337 
338 interface UniswapFactory {
339     function getExchange(address token) external view returns (address exchange);
340 }
341 
342 
343 contract KyberUniswapReserve is KyberReserveInterface, Withdrawable, Utils2 {
344     // Parts per 10000
345     uint public constant DEFAULT_FEE_BPS = 25;
346 
347     UniswapFactory public uniswapFactory;
348     address public kyberNetwork;
349 
350     uint public feeBps = DEFAULT_FEE_BPS;
351 
352     // Uniswap exchange contract for every listed token
353     // token -> exchange
354     mapping (address => address) public tokenExchange;
355 
356     bool public tradeEnabled = true;
357 
358     /**
359         Constructor
360     */
361     function KyberUniswapReserve(
362         UniswapFactory _uniswapFactory,
363         address _admin,
364         address _kyberNetwork
365     )
366         public
367     {
368         require(address(_uniswapFactory) != 0);
369         require(_admin != 0);
370         require(_kyberNetwork != 0);
371 
372         uniswapFactory = _uniswapFactory;
373         admin = _admin;
374         kyberNetwork = _kyberNetwork;
375     }
376 
377     function() public payable {
378         // anyone can deposit ether
379     }
380 
381     /**
382         Returns dest quantity / source quantity.
383     */
384     function getConversionRate(
385         ERC20 src,
386         ERC20 dest,
387         uint srcQty,
388         uint blockNumber
389     )
390         public
391         view
392         returns(uint)
393     {
394         // This makes the UNUSED warning go away.
395         blockNumber;
396 
397         require(isValidTokens(src, dest));
398 
399         if (!tradeEnabled) return 0;
400 
401         ERC20 token;
402         if (src == ETH_TOKEN_ADDRESS) {
403             token = dest;
404         } else if (dest == ETH_TOKEN_ADDRESS) {
405             token = src;
406         } else {
407             // Should never arrive here - isValidTokens requires one side to be ETH
408             revert();
409         }
410 
411         UniswapExchange exchange = UniswapExchange(tokenExchange[token]);
412 
413         uint convertedQuantity;
414         if (src == ETH_TOKEN_ADDRESS) {
415             uint quantity = srcQty * (10000 - feeBps) / 10000;
416             convertedQuantity = exchange.getEthToTokenInputPrice(quantity);
417         } else {
418             convertedQuantity = exchange.getTokenToEthInputPrice(srcQty);
419             convertedQuantity = convertedQuantity * (10000 - feeBps) / 10000;
420         }
421 
422         return calcRateFromQty(
423             srcQty, /* srcAmount */
424             convertedQuantity, /* destAmount */
425             getDecimals(src), /* srcDecimals */
426             getDecimals(dest) /* dstDecimals */
427         );
428     }
429 
430     event TradeExecute(
431         address indexed sender,
432         address src,
433         uint srcAmount,
434         address destToken,
435         uint destAmount,
436         address destAddress
437     );
438 
439     /**
440       conversionRate: expected conversion rate should be >= this value.
441      */
442     function trade(
443         ERC20 srcToken,
444         uint srcAmount,
445         ERC20 destToken,
446         address destAddress,
447         uint conversionRate,
448         bool validate
449     )
450         public
451         payable
452         returns(bool)
453     {
454         // Not using this variable that is part of the interface.
455         validate;
456 
457         require(tradeEnabled);
458         require(msg.sender == kyberNetwork);
459         require(isValidTokens(srcToken, destToken));
460 
461         uint expectedConversionRate = getConversionRate(
462             srcToken,
463             destToken,
464             srcAmount,
465             0 /* blockNumber */
466         );
467         require(expectedConversionRate >= conversionRate);
468 
469         uint destAmount;
470         UniswapExchange exchange;
471         if (srcToken == ETH_TOKEN_ADDRESS) {
472             require(srcAmount == msg.value);
473 
474             // Fees in ETH
475             uint quantity = srcAmount * (10000 - feeBps) / 10000;
476             exchange = UniswapExchange(tokenExchange[destToken]);
477             destAmount = exchange.ethToTokenSwapInput.value(quantity)(
478                 1, /* min_tokens: uniswap requires it to be > 0 */
479                 2 ** 255 /* deadline */
480             );
481             require(destToken.transfer(destAddress, destAmount));
482         } else {
483             require(msg.value == 0);
484             require(srcToken.transferFrom(msg.sender, address(this), srcAmount));
485 
486             exchange = UniswapExchange(tokenExchange[srcToken]);
487             destAmount = exchange.tokenToEthSwapInput(
488                 srcAmount,
489                 1, /* min_eth: uniswap requires it to be > 0 */
490                 2 ** 255 /* deadline */
491             );
492             // Fees in ETH
493             destAmount = destAmount * (10000 - feeBps) / 10000;
494             destAddress.transfer(destAmount);
495         }
496 
497         TradeExecute(
498             msg.sender, /* sender */
499             srcToken, /* src */
500             srcAmount, /* srcAmount */
501             destToken, /* destToken */
502             destAmount, /* destAmount */
503             destAddress /* destAddress */
504         );
505         return true;
506     }
507 
508     event FeeUpdated(
509         uint bps
510     );
511 
512     function setFee(
513         uint bps
514     )
515         public
516         onlyAdmin
517     {
518         require(bps <= 10000);
519 
520         feeBps = bps;
521 
522         FeeUpdated(bps);
523     }
524 
525     event TokenListed(
526         ERC20 token,
527         UniswapExchange exchange
528     );
529 
530     function listToken(ERC20 token)
531         public
532         onlyAdmin
533     {
534         require(address(token) != 0);
535 
536         UniswapExchange uniswapExchange = UniswapExchange(
537             uniswapFactory.getExchange(token)
538         );
539         tokenExchange[token] = uniswapExchange;
540         setDecimals(token);
541 
542         require(token.approve(uniswapExchange, 2**255));
543 
544         TokenListed(token, uniswapExchange);
545     }
546 
547     event TokenDelisted(ERC20 token);
548 
549     function delistToken(ERC20 token)
550         public
551         onlyAdmin
552     {
553         require(tokenExchange[token] != 0);
554         tokenExchange[token] = 0;
555 
556 
557         TokenDelisted(token);
558     }
559 
560     function isValidTokens(
561         ERC20 src,
562         ERC20 dest
563     )
564         public
565         view
566         returns(bool)
567     {
568         return (
569             (src == ETH_TOKEN_ADDRESS && tokenExchange[dest] != 0) ||
570             (tokenExchange[src] != 0 && dest == ETH_TOKEN_ADDRESS)
571         );
572     }
573 
574     event TradeEnabled(
575         bool enable
576     );
577 
578     function enableTrade()
579         public
580         onlyAdmin
581         returns(bool)
582     {
583         tradeEnabled = true;
584         TradeEnabled(true);
585         return true;
586     }
587 
588     function disableTrade()
589         public
590         onlyAlerter
591         returns(bool)
592     {
593         tradeEnabled = false;
594         TradeEnabled(false);
595         return true;
596     }
597 
598     event KyberNetworkSet(
599         address kyberNetwork
600     );
601 
602     function setKyberNetwork(
603         address _kyberNetwork
604     )
605         public
606         onlyAdmin
607     {
608         require(_kyberNetwork != 0);
609         kyberNetwork = _kyberNetwork;
610         KyberNetworkSet(kyberNetwork);
611     }
612 }