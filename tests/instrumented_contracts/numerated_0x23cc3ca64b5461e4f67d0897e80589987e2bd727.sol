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
303 // File: contracts/uniswap/UniswapReserve.sol
304 
305 interface UniswapExchange {
306     function getEthToTokenInputPrice(
307         uint256 eth_sold
308     )
309         external
310         view
311         returns (uint256 tokens_bought);
312 
313     function getTokenToEthInputPrice(
314         uint256 tokens_sold
315     )
316         external
317         view
318         returns (uint256 eth_bought);
319 
320     function ethToTokenSwapInput(
321         uint256 min_tokens,
322         uint256 deadline
323     )
324         external
325         payable
326         returns (uint256  tokens_bought);
327 
328     function tokenToEthSwapInput(
329         uint256 tokens_sold,
330         uint256 min_eth,
331         uint256 deadline
332     )
333         external
334         returns (uint256  eth_bought);
335 }
336 
337 
338 interface UniswapFactory {
339     function getExchange(address token) external view returns (address exchange);
340 }
341 
342 
343 contract UniswapReserve is KyberReserveInterface, Withdrawable, Utils2 {
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
361     function UniswapReserve(
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
408             revert;
409         }
410 
411         UniswapExchange exchange = UniswapExchange(
412             uniswapFactory.getExchange(token)
413         );
414 
415         uint convertedQuantity;
416         if (src == ETH_TOKEN_ADDRESS) {
417             uint quantity = srcQty * (10000 - feeBps) / 10000;
418             convertedQuantity = exchange.getEthToTokenInputPrice(quantity);
419         } else {
420             convertedQuantity = exchange.getTokenToEthInputPrice(srcQty);
421             convertedQuantity = convertedQuantity * (10000 - feeBps) / 10000;
422         }
423 
424         return calcRateFromQty(
425             srcQty, /* srcAmount */
426             convertedQuantity, /* destAmount */
427             getDecimals(src), /* srcDecimals */
428             getDecimals(dest) /* dstDecimals */
429         );
430     }
431 
432     event TradeExecute(
433         address indexed sender,
434         address src,
435         uint srcAmount,
436         address destToken,
437         uint destAmount,
438         address destAddress
439     );
440 
441     /**
442       conversionRate: expected conversion rate should be >= this value.
443      */
444     function trade(
445         ERC20 srcToken,
446         uint srcAmount,
447         ERC20 destToken,
448         address destAddress,
449         uint conversionRate,
450         bool validate
451     )
452         public
453         payable
454         returns(bool)
455     {
456         require(tradeEnabled);
457         require(msg.sender == kyberNetwork);
458         require(isValidTokens(srcToken, destToken));
459 
460         uint expectedConversionRate = getConversionRate(
461             srcToken,
462             destToken,
463             srcAmount,
464             0 /* blockNumber */
465         );
466         require (expectedConversionRate <= conversionRate);
467 
468         uint destAmount;
469         UniswapExchange exchange;
470         if (srcToken == ETH_TOKEN_ADDRESS) {
471             require(srcAmount == msg.value);
472 
473             // Fees in ETH
474             uint quantity = srcAmount * (10000 - feeBps) / 10000;
475             exchange = UniswapExchange(tokenExchange[destToken]);
476             destAmount = exchange.ethToTokenSwapInput.value(quantity)(
477                 0,
478                 2 ** 255 /* deadline */
479             );
480             require(destToken.transfer(destAddress, destAmount));
481         } else {
482             require(msg.value == 0);
483             require(srcToken.transferFrom(msg.sender, address(this), srcAmount));
484 
485             exchange = UniswapExchange(tokenExchange[srcToken]);
486             destAmount = exchange.tokenToEthSwapInput(
487                 srcAmount,
488                 0,
489                 2 ** 255 /* deadline */
490             );
491             // Fees in ETH
492             destAmount = destAmount * (10000 - feeBps) / 10000;
493             destAddress.transfer(destAmount);
494         }
495 
496         TradeExecute(
497             msg.sender /* sender */,
498             srcToken /* src */,
499             srcAmount /* srcAmount */,
500             destToken /* destToken */,
501             destAmount /* destAmount */,
502             destAddress /* destAddress */
503         );
504         return true;
505     }
506 
507     event FeeUpdated(
508         uint bps
509     );
510 
511     function setFee(
512         uint bps
513     )
514         public
515         onlyAdmin
516     {
517         require(bps <= 10000);
518 
519         feeBps = bps;
520 
521         FeeUpdated(bps);
522     }
523 
524     event TokenListed(
525         ERC20 token,
526         UniswapExchange exchange
527     );
528 
529     function listToken(ERC20 token)
530         public
531         onlyAdmin
532     {
533         require(address(token) != 0);
534 
535         UniswapExchange uniswapExchange = UniswapExchange(
536             uniswapFactory.getExchange(token)
537         );
538         tokenExchange[token] = uniswapExchange;
539         setDecimals(token);
540 
541         require(token.approve(uniswapExchange, 2**255));
542 
543         TokenListed(token, uniswapExchange);
544     }
545 
546     event TokenDelisted(ERC20 token);
547 
548     function delistToken(ERC20 token)
549         public
550         onlyAdmin
551     {
552         require(tokenExchange[token] != 0);
553         tokenExchange[token] = 0;
554 
555 
556         TokenDelisted(token);
557     }
558 
559     function isValidTokens(
560         ERC20 src,
561         ERC20 dest
562     )
563         public
564         view
565         returns(bool)
566     {
567         return (
568             (src == ETH_TOKEN_ADDRESS && tokenExchange[dest] != 0) ||
569             (tokenExchange[src] != 0 && dest == ETH_TOKEN_ADDRESS)
570         );
571     }
572 
573     event TradeEnabled(
574         bool enable
575     );
576 
577     function enableTrade()
578         public
579         onlyAdmin
580         returns(bool)
581     {
582         tradeEnabled = true;
583         TradeEnabled(true);
584         return true;
585     }
586 
587     function disableTrade()
588         public
589         onlyAlerter
590         returns(bool)
591     {
592         tradeEnabled = false;
593         TradeEnabled(false);
594         return true;
595     }
596 }