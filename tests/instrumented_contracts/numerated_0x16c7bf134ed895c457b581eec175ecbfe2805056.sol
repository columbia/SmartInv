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
17 // File: contracts/KyberReserveInterface.sol
18 
19 /// @title Kyber Reserve contract
20 interface KyberReserveInterface {
21 
22     function trade(
23         ERC20 srcToken,
24         uint srcAmount,
25         ERC20 destToken,
26         address destAddress,
27         uint conversionRate,
28         bool validate
29     )
30         public
31         payable
32         returns(bool);
33 
34     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
35 }
36 
37 // File: contracts/Utils.sol
38 
39 /// @title Kyber constants contract
40 contract Utils {
41 
42     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
43     uint  constant internal PRECISION = (10**18);
44     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
45     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
46     uint  constant internal MAX_DECIMALS = 18;
47     uint  constant internal ETH_DECIMALS = 18;
48     mapping(address=>uint) internal decimals;
49 
50     function setDecimals(ERC20 token) internal {
51         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
52         else decimals[token] = token.decimals();
53     }
54 
55     function getDecimals(ERC20 token) internal view returns(uint) {
56         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
57         uint tokenDecimals = decimals[token];
58         // technically, there might be token with decimals 0
59         // moreover, very possible that old tokens have decimals 0
60         // these tokens will just have higher gas fees.
61         if(tokenDecimals == 0) return token.decimals();
62 
63         return tokenDecimals;
64     }
65 
66     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
67         require(srcQty <= MAX_QTY);
68         require(rate <= MAX_RATE);
69 
70         if (dstDecimals >= srcDecimals) {
71             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
72             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
73         } else {
74             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
75             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
76         }
77     }
78 
79     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
80         require(dstQty <= MAX_QTY);
81         require(rate <= MAX_RATE);
82         
83         //source quantity is rounded up. to avoid dest quantity being too low.
84         uint numerator;
85         uint denominator;
86         if (srcDecimals >= dstDecimals) {
87             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
88             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
89             denominator = rate;
90         } else {
91             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
92             numerator = (PRECISION * dstQty);
93             denominator = (rate * (10**(dstDecimals - srcDecimals)));
94         }
95         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
96     }
97 }
98 
99 // File: contracts/Utils2.sol
100 
101 contract Utils2 is Utils {
102 
103     /// @dev get the balance of a user.
104     /// @param token The token type
105     /// @return The balance
106     function getBalance(ERC20 token, address user) public view returns(uint) {
107         if (token == ETH_TOKEN_ADDRESS)
108             return user.balance;
109         else
110             return token.balanceOf(user);
111     }
112 
113     function getDecimalsSafe(ERC20 token) internal returns(uint) {
114 
115         if (decimals[token] == 0) {
116             setDecimals(token);
117         }
118 
119         return decimals[token];
120     }
121 
122     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
123         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
124     }
125 
126     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
127         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
128     }
129 
130     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
131         internal pure returns(uint)
132     {
133         require(srcAmount <= MAX_QTY);
134         require(destAmount <= MAX_QTY);
135 
136         if (dstDecimals >= srcDecimals) {
137             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
138             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
139         } else {
140             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
141             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
142         }
143     }
144 }
145 
146 // File: contracts/PermissionGroups.sol
147 
148 contract PermissionGroups {
149 
150     address public admin;
151     address public pendingAdmin;
152     mapping(address=>bool) internal operators;
153     mapping(address=>bool) internal alerters;
154     address[] internal operatorsGroup;
155     address[] internal alertersGroup;
156     uint constant internal MAX_GROUP_SIZE = 50;
157 
158     function PermissionGroups() public {
159         admin = msg.sender;
160     }
161 
162     modifier onlyAdmin() {
163         require(msg.sender == admin);
164         _;
165     }
166 
167     modifier onlyOperator() {
168         require(operators[msg.sender]);
169         _;
170     }
171 
172     modifier onlyAlerter() {
173         require(alerters[msg.sender]);
174         _;
175     }
176 
177     function getOperators () external view returns(address[]) {
178         return operatorsGroup;
179     }
180 
181     function getAlerters () external view returns(address[]) {
182         return alertersGroup;
183     }
184 
185     event TransferAdminPending(address pendingAdmin);
186 
187     /**
188      * @dev Allows the current admin to set the pendingAdmin address.
189      * @param newAdmin The address to transfer ownership to.
190      */
191     function transferAdmin(address newAdmin) public onlyAdmin {
192         require(newAdmin != address(0));
193         TransferAdminPending(pendingAdmin);
194         pendingAdmin = newAdmin;
195     }
196 
197     /**
198      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
199      * @param newAdmin The address to transfer ownership to.
200      */
201     function transferAdminQuickly(address newAdmin) public onlyAdmin {
202         require(newAdmin != address(0));
203         TransferAdminPending(newAdmin);
204         AdminClaimed(newAdmin, admin);
205         admin = newAdmin;
206     }
207 
208     event AdminClaimed( address newAdmin, address previousAdmin);
209 
210     /**
211      * @dev Allows the pendingAdmin address to finalize the change admin process.
212      */
213     function claimAdmin() public {
214         require(pendingAdmin == msg.sender);
215         AdminClaimed(pendingAdmin, admin);
216         admin = pendingAdmin;
217         pendingAdmin = address(0);
218     }
219 
220     event AlerterAdded (address newAlerter, bool isAdd);
221 
222     function addAlerter(address newAlerter) public onlyAdmin {
223         require(!alerters[newAlerter]); // prevent duplicates.
224         require(alertersGroup.length < MAX_GROUP_SIZE);
225 
226         AlerterAdded(newAlerter, true);
227         alerters[newAlerter] = true;
228         alertersGroup.push(newAlerter);
229     }
230 
231     function removeAlerter (address alerter) public onlyAdmin {
232         require(alerters[alerter]);
233         alerters[alerter] = false;
234 
235         for (uint i = 0; i < alertersGroup.length; ++i) {
236             if (alertersGroup[i] == alerter) {
237                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
238                 alertersGroup.length--;
239                 AlerterAdded(alerter, false);
240                 break;
241             }
242         }
243     }
244 
245     event OperatorAdded(address newOperator, bool isAdd);
246 
247     function addOperator(address newOperator) public onlyAdmin {
248         require(!operators[newOperator]); // prevent duplicates.
249         require(operatorsGroup.length < MAX_GROUP_SIZE);
250 
251         OperatorAdded(newOperator, true);
252         operators[newOperator] = true;
253         operatorsGroup.push(newOperator);
254     }
255 
256     function removeOperator (address operator) public onlyAdmin {
257         require(operators[operator]);
258         operators[operator] = false;
259 
260         for (uint i = 0; i < operatorsGroup.length; ++i) {
261             if (operatorsGroup[i] == operator) {
262                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
263                 operatorsGroup.length -= 1;
264                 OperatorAdded(operator, false);
265                 break;
266             }
267         }
268     }
269 }
270 
271 // File: contracts/Withdrawable.sol
272 
273 /**
274  * @title Contracts that should be able to recover tokens or ethers
275  * @author Ilan Doron
276  * @dev This allows to recover any tokens or Ethers received in a contract.
277  * This will prevent any accidental loss of tokens.
278  */
279 contract Withdrawable is PermissionGroups {
280 
281     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
282 
283     /**
284      * @dev Withdraw all ERC20 compatible tokens
285      * @param token ERC20 The address of the token contract
286      */
287     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
288         require(token.transfer(sendTo, amount));
289         TokenWithdraw(token, amount, sendTo);
290     }
291 
292     event EtherWithdraw(uint amount, address sendTo);
293 
294     /**
295      * @dev Withdraw Ethers
296      */
297     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
298         sendTo.transfer(amount);
299         EtherWithdraw(amount, sendTo);
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
343 /*
344  * A reserve that connects to Uniswap.
345  *
346  * This reserve makes use of an internal inventory for locally filling orders
347  * using the reserve's inventory when certain conditions are met.
348  * Conditions are:
349  * - After trading the inventory will remain within defined limits.
350  * - Uniswap prices do not display internal arbitrage.
351  * - Uniswap ask and bid prices meet minimum spread requirements.
352  *
353  * An additional premium may be added to the converted price for optional
354  * promotions.
355  */
356 contract KyberUniswapReserve is KyberReserveInterface, Withdrawable, Utils2 {
357     // Parts per 10000
358     uint public constant DEFAULT_FEE_BPS = 25;
359 
360     UniswapFactory public uniswapFactory;
361     address public kyberNetwork;
362 
363     uint public feeBps = DEFAULT_FEE_BPS;
364 
365     // Uniswap exchange contract for every listed token
366     // token -> exchange
367     mapping (address => address) public tokenExchange;
368 
369     // Internal inventory balance limits
370     // token -> limit
371     mapping (address => uint) public internalInventoryMin;
372     mapping (address => uint) public internalInventoryMax;
373 
374     // Minimum spread in BPS required for using internal inventory
375     // token -> limit
376     mapping (address => uint) public internalActivationMinSpreadBps;
377 
378     // Premium BPS added to internal price (making it better).
379     // token -> limit
380     mapping (address => uint) public internalPricePremiumBps;
381 
382     bool public tradeEnabled = true;
383 
384     /**
385         Constructor
386     */
387     function KyberUniswapReserve(
388         UniswapFactory _uniswapFactory,
389         address _admin,
390         address _kyberNetwork
391     )
392         public
393     {
394         require(address(_uniswapFactory) != 0);
395         require(_admin != 0);
396         require(_kyberNetwork != 0);
397 
398         uniswapFactory = _uniswapFactory;
399         admin = _admin;
400         kyberNetwork = _kyberNetwork;
401     }
402 
403     function() public payable {
404         // anyone can deposit ether
405     }
406 
407     /**
408         Returns dest quantity / source quantity.
409     */
410     function getConversionRate(
411         ERC20 src,
412         ERC20 dest,
413         uint srcQty,
414         uint blockNumber
415     )
416         public
417         view
418         returns(uint)
419     {
420         // This makes the UNUSED warning go away.
421         blockNumber;
422 
423         if (!isValidTokens(src, dest)) return 0;
424         if (!tradeEnabled) return 0;
425         if (srcQty == 0) return 0;
426 
427         ERC20 token;
428         if (src == ETH_TOKEN_ADDRESS) {
429             token = dest;
430         } else if (dest == ETH_TOKEN_ADDRESS) {
431             token = src;
432         } else {
433             // Should never arrive here - isValidTokens requires one side to be ETH
434             revert();
435         }
436 
437         uint convertedQuantity;
438         uint rateSrcDest;
439         uint rateDestSrc;
440         (convertedQuantity, rateSrcDest) = calcUniswapConversion(src, dest, srcQty);
441         (, rateDestSrc) = calcUniswapConversion(dest, src, convertedQuantity);
442 
443         uint quantityWithPremium = addPremium(token, convertedQuantity);
444 
445         if (shouldUseInternalInventory(
446             src, /* srcToken */
447             srcQty, /* srcAmount */
448             dest, /* destToken */
449             quantityWithPremium, /* destAmount */
450             rateSrcDest, /* rateSrcDest */
451             rateDestSrc /* rateDestSrc */
452         )) {
453             // If using internal inventory add premium to converted quantity
454             return calcRateFromQty(
455                 srcQty, /* srcAmount */
456                 quantityWithPremium, /* destAmount */
457                 getDecimals(src), /* srcDecimals */
458                 getDecimals(dest) /* dstDecimals */
459             );
460         } else {
461             // Use rate calculated from uniswap quantities after fees
462             return rateSrcDest;
463         }
464     }
465 
466     event TradeExecute(
467         address indexed sender,
468         address src,
469         uint srcAmount,
470         address destToken,
471         uint destAmount,
472         address destAddress,
473         bool useInternalInventory
474     );
475 
476     /**
477       conversionRate: expected conversion rate should be >= this value.
478      */
479     function trade(
480         ERC20 srcToken,
481         uint srcAmount,
482         ERC20 destToken,
483         address destAddress,
484         uint conversionRate,
485         bool validate
486     )
487         public
488         payable
489         returns(bool)
490     {
491         require(tradeEnabled);
492         require(msg.sender == kyberNetwork);
493         require(isValidTokens(srcToken, destToken));
494 
495         if (validate) {
496             require(conversionRate > 0);
497             if (srcToken == ETH_TOKEN_ADDRESS)
498                 require(msg.value == srcAmount);
499             else
500                 require(msg.value == 0);
501         }
502 
503         // Making sure srcAmount has been transfered to the reserve.
504         // If srcToken is ETH the value has already been transfered by calling
505         // the function.
506         if (srcToken != ETH_TOKEN_ADDRESS)
507             require(srcToken.transferFrom(msg.sender, address(this), srcAmount));
508 
509         uint expectedDestAmount = calcDestAmount(
510             srcToken, /* src */
511             destToken, /* dest */
512             srcAmount, /* srcAmount */
513             conversionRate /* rate */
514         );
515 
516         uint rateDestSrc;
517         (, rateDestSrc) = calcUniswapConversion(
518             destToken,
519             srcToken,
520             expectedDestAmount
521         );
522         bool useInternalInventory = shouldUseInternalInventory(
523             srcToken, /* srcToken */
524             0, /* srcAmount */
525             destToken, /* destToken */
526             expectedDestAmount, /* destAmount */
527             conversionRate, /* rateSrcDest */
528             rateDestSrc /* rateDestSrc */
529         );
530 
531         uint destAmount;
532         UniswapExchange exchange;
533         if (srcToken == ETH_TOKEN_ADDRESS) {
534             if (!useInternalInventory) {
535                 // Deduct fees (in ETH) before converting
536                 uint quantity = deductFee(srcAmount);
537                 exchange = UniswapExchange(tokenExchange[address(destToken)]);
538                 destAmount = exchange.ethToTokenSwapInput.value(quantity)(
539                     1, /* min_tokens: uniswap requires it to be > 0 */
540                     2 ** 255 /* deadline */
541                 );
542                 require(destAmount >= expectedDestAmount);
543             }
544 
545             // Transfer user-expected dest amount
546             require(destToken.transfer(destAddress, expectedDestAmount));
547         } else {
548             if (!useInternalInventory) {
549                 exchange = UniswapExchange(tokenExchange[address(srcToken)]);
550                 destAmount = exchange.tokenToEthSwapInput(
551                     srcAmount,
552                     1, /* min_eth: uniswap requires it to be > 0 */
553                     2 ** 255 /* deadline */
554                 );
555                 // Deduct fees (in ETH) after converting
556                 destAmount = deductFee(destAmount);
557                 require(destAmount >= expectedDestAmount);
558             }
559 
560             // Transfer user-expected dest amount
561             destAddress.transfer(expectedDestAmount);
562         }
563 
564         TradeExecute(
565             msg.sender, /* sender */
566             srcToken, /* src */
567             srcAmount, /* srcAmount */
568             destToken, /* destToken */
569             expectedDestAmount, /* destAmount */
570             destAddress, /* destAddress */
571             useInternalInventory /* useInternalInventory */
572         );
573         return true;
574     }
575 
576     event FeeUpdated(
577         uint bps
578     );
579 
580     function setFee(
581         uint bps
582     )
583         public
584         onlyAdmin
585     {
586         require(bps <= 10000);
587 
588         feeBps = bps;
589 
590         FeeUpdated(bps);
591     }
592 
593     event InternalActivationConfigUpdated(
594         ERC20 token,
595         uint minSpreadBps,
596         uint premiumBps
597     );
598 
599     function setInternalActivationConfig(
600         ERC20 token,
601         uint minSpreadBps,
602         uint premiumBps
603     )
604         public
605         onlyAdmin
606     {
607         require(tokenExchange[address(token)] != address(0));
608         require(minSpreadBps <= 1000); // min spread <= 10%
609         require(premiumBps <= 500); // premium <= 5%
610 
611         internalActivationMinSpreadBps[address(token)] = minSpreadBps;
612         internalPricePremiumBps[address(token)] = premiumBps;
613 
614         InternalActivationConfigUpdated(token, minSpreadBps, premiumBps);
615     }
616 
617     event InternalInventoryLimitsUpdated(
618         ERC20 token,
619         uint minBalance,
620         uint maxBalance
621     );
622 
623     function setInternalInventoryLimits(
624         ERC20 token,
625         uint minBalance,
626         uint maxBalance
627     )
628         public
629         onlyOperator
630     {
631         require(tokenExchange[address(token)] != address(0));
632 
633         internalInventoryMin[address(token)] = minBalance;
634         internalInventoryMax[address(token)] = maxBalance;
635 
636         InternalInventoryLimitsUpdated(token, minBalance, maxBalance);
637     }
638 
639     event TokenListed(
640         ERC20 token,
641         UniswapExchange exchange
642     );
643 
644     function listToken(ERC20 token)
645         public
646         onlyAdmin
647     {
648         require(address(token) != 0);
649 
650         UniswapExchange uniswapExchange = UniswapExchange(
651             uniswapFactory.getExchange(token)
652         );
653         tokenExchange[address(token)] = address(uniswapExchange);
654         setDecimals(token);
655 
656         require(token.approve(uniswapExchange, 2 ** 255));
657 
658         // internal inventory disabled by default
659         internalInventoryMin[address(token)] = 2 ** 255;
660         internalInventoryMax[address(token)] = 0;
661         internalActivationMinSpreadBps[address(token)] = 0;
662         internalPricePremiumBps[address(token)] = 0;
663 
664         TokenListed(token, uniswapExchange);
665     }
666 
667     event TokenDelisted(ERC20 token);
668 
669     function delistToken(ERC20 token)
670         public
671         onlyAdmin
672     {
673         require(tokenExchange[address(token)] != address(0));
674 
675         delete tokenExchange[address(token)];
676         delete internalInventoryMin[address(token)];
677         delete internalInventoryMax[address(token)];
678         delete internalActivationMinSpreadBps[address(token)];
679         delete internalPricePremiumBps[address(token)];
680 
681         TokenDelisted(token);
682     }
683 
684     function isValidTokens(
685         ERC20 src,
686         ERC20 dest
687     )
688         public
689         view
690         returns(bool)
691     {
692         return (
693             (
694                 src == ETH_TOKEN_ADDRESS &&
695                 tokenExchange[address(dest)] != address(0)
696             ) ||
697             (
698                 tokenExchange[address(src)] != address(0) &&
699                 dest == ETH_TOKEN_ADDRESS
700             )
701         );
702     }
703 
704     event TradeEnabled(
705         bool enable
706     );
707 
708     function enableTrade()
709         public
710         onlyAdmin
711         returns(bool)
712     {
713         tradeEnabled = true;
714         TradeEnabled(true);
715         return true;
716     }
717 
718     function disableTrade()
719         public
720         onlyAlerter
721         returns(bool)
722     {
723         tradeEnabled = false;
724         TradeEnabled(false);
725         return true;
726     }
727 
728     event KyberNetworkSet(
729         address kyberNetwork
730     );
731 
732     function setKyberNetwork(
733         address _kyberNetwork
734     )
735         public
736         onlyAdmin
737     {
738         require(_kyberNetwork != 0);
739         kyberNetwork = _kyberNetwork;
740         KyberNetworkSet(kyberNetwork);
741     }
742 
743     /*
744      * Uses amounts and rates to check if the reserve's internal inventory can
745      * be used directly.
746      *
747      * rateEthToToken and rateTokenToEth are in kyber rate format meaning
748      * rate as numerator and 1e18 as denominator.
749      */
750     function shouldUseInternalInventory(
751         ERC20 srcToken,
752         uint srcAmount,
753         ERC20 destToken,
754         uint destAmount,
755         uint rateSrcDest,
756         uint rateDestSrc
757     )
758         public
759         view
760         returns(bool)
761     {
762         require(srcAmount < MAX_QTY);
763         require(destAmount < MAX_QTY);
764 
765         // Check for internal inventory balance limitations
766         ERC20 token;
767         uint rateEthToToken;
768         uint rateTokenToEth;
769         if (srcToken == ETH_TOKEN_ADDRESS) {
770             token = destToken;
771             uint tokenBalance = token.balanceOf(this);
772             if (
773                 tokenBalance < destAmount ||
774                 tokenBalance - destAmount < internalInventoryMin[token]
775             ) {
776                 return false;
777             }
778             rateEthToToken = rateSrcDest;
779             // Normalize rate direction to enable comparison for checking spread
780             // and arbitrage: from ETH / Token -> Token / ETH
781             rateTokenToEth = 10 ** 36 / rateDestSrc;
782         } else {
783             token = srcToken;
784             if (this.balance < destAmount) return false;
785             if (token.balanceOf(this) + srcAmount > internalInventoryMax[token]) {
786                 return false;
787             }
788             rateEthToToken = rateDestSrc;
789             // Normalize rate direction to enable comparison for checking spread
790             // and arbitrage: from ETH / Token -> Token / ETH
791             rateTokenToEth = 10 ** 36 / rateSrcDest;
792         }
793 
794         // Check for arbitrage
795         if (rateTokenToEth < rateEthToToken) return false;
796 
797         uint activationSpread = internalActivationMinSpreadBps[token];
798         uint spread = uint(calculateSpreadBps(rateEthToToken, rateTokenToEth));
799         return spread >= activationSpread;
800     }
801 
802     /*
803      * Spread calculation is (ask - bid) / ((ask + bid) / 2).
804      * We multiply by 10000 to get result in BPS.
805      *
806      * Note: if askRate > bidRate result will be negative indicating
807      * internal arbitrage.
808      */
809     function calculateSpreadBps(
810         uint _askRate,
811         uint _bidRate
812     )
813         public
814         pure
815         returns(int)
816     {
817         int askRate = int(_askRate);
818         int bidRate = int(_bidRate);
819         return 10000 * 2 * (askRate - bidRate) / (askRate + bidRate);
820     }
821 
822     function deductFee(
823         uint amount
824     )
825         public
826         view
827         returns(uint)
828     {
829         return amount * (10000 - feeBps) / 10000;
830     }
831 
832     function addPremium(
833         ERC20 token,
834         uint amount
835     )
836         public
837         view
838         returns(uint)
839     {
840         require(amount <= MAX_QTY);
841         return amount * (10000 + internalPricePremiumBps[token]) / 10000;
842     }
843 
844     function calcUniswapConversion(
845         ERC20 src,
846         ERC20 dest,
847         uint srcQty
848     )
849         internal
850         view
851         returns(uint destQty, uint rate)
852     {
853         UniswapExchange exchange;
854         if (src == ETH_TOKEN_ADDRESS) {
855             exchange = UniswapExchange(tokenExchange[address(dest)]);
856             destQty = exchange.getEthToTokenInputPrice(
857                 deductFee(srcQty)
858             );
859         } else {
860             exchange = UniswapExchange(tokenExchange[address(src)]);
861             destQty = deductFee(
862                 exchange.getTokenToEthInputPrice(srcQty)
863             );
864         }
865 
866         rate = calcRateFromQty(
867             srcQty, /* srcAmount */
868             destQty, /* destAmount */
869             getDecimals(src), /* srcDecimals */
870             getDecimals(dest) /* dstDecimals */
871         );
872     }
873 }