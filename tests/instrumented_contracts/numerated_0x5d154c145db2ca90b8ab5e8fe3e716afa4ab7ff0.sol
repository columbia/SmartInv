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
409         Last bit of the rate indicates whether to use internal inventory:
410           0 - use uniswap
411           1 - use internal inventory
412     */
413     function getConversionRate(
414         ERC20 src,
415         ERC20 dest,
416         uint srcQty,
417         uint blockNumber
418     )
419         public
420         view
421         returns(uint)
422     {
423         // This makes the UNUSED warning go away.
424         blockNumber;
425         if (!isValidTokens(src, dest)) return 0;
426         if (!tradeEnabled) return 0;
427         if (srcQty == 0) return 0;
428 
429         ERC20 token;
430         if (src == ETH_TOKEN_ADDRESS) {
431             token = dest;
432         } else if (dest == ETH_TOKEN_ADDRESS) {
433             token = src;
434         } else {
435             // Should never arrive here - isValidTokens requires one side to be ETH
436             revert();
437         }
438 
439         uint convertedQuantity;
440         uint rateSrcDest;
441         uint rateDestSrc;
442         (convertedQuantity, rateSrcDest) = calcUniswapConversion(src, dest, srcQty);
443         (, rateDestSrc) = calcUniswapConversion(dest, src, convertedQuantity);
444 
445         uint quantityWithPremium = addPremium(token, convertedQuantity);
446 
447         bool useInternalInventory = shouldUseInternalInventory(
448             src, /* srcToken */
449             srcQty, /* srcAmount */
450             dest, /* destToken */
451             quantityWithPremium, /* destAmount */
452             rateSrcDest, /* rateSrcDest */
453             rateDestSrc /* rateDestSrc */
454         );
455 
456         uint rate;
457         if (useInternalInventory) {
458             // If using internal inventory add premium to converted quantity
459             rate = calcRateFromQty(
460                 srcQty, /* srcAmount */
461                 quantityWithPremium, /* destAmount */
462                 getDecimals(src), /* srcDecimals */
463                 getDecimals(dest) /* dstDecimals */
464             );
465         } else {
466             // Use rate calculated from uniswap quantities after fees
467             rate = rateSrcDest;
468         }
469         return applyInternalInventoryHintToRate(rate, useInternalInventory);
470     }
471 
472     function applyInternalInventoryHintToRate(
473         uint rate,
474         bool useInternalInventory
475     )
476         internal
477         pure
478         returns(uint)
479     {
480         return rate % 2 == (useInternalInventory ? 1 : 0)
481             ? rate
482             : rate - 1;
483     }
484 
485 
486     event TradeExecute(
487         address indexed sender,
488         address src,
489         uint srcAmount,
490         address destToken,
491         uint destAmount,
492         address destAddress,
493         bool useInternalInventory
494     );
495 
496     /**
497       conversionRate: expected conversion rate should be >= this value.
498      */
499     function trade(
500         ERC20 srcToken,
501         uint srcAmount,
502         ERC20 destToken,
503         address destAddress,
504         uint conversionRate,
505         bool validate
506     )
507         public
508         payable
509         returns(bool)
510     {
511         require(tradeEnabled);
512         require(msg.sender == kyberNetwork);
513         require(isValidTokens(srcToken, destToken));
514 
515         if (validate) {
516             require(conversionRate > 0);
517             if (srcToken == ETH_TOKEN_ADDRESS)
518                 require(msg.value == srcAmount);
519             else
520                 require(msg.value == 0);
521         }
522 
523         // Making sure srcAmount has been transfered to the reserve.
524         // If srcToken is ETH the value has already been transfered by calling
525         // the function.
526         if (srcToken != ETH_TOKEN_ADDRESS)
527             require(srcToken.transferFrom(msg.sender, address(this), srcAmount));
528 
529         uint expectedDestAmount = calcDestAmount(
530             srcToken, /* src */
531             destToken, /* dest */
532             srcAmount, /* srcAmount */
533             conversionRate /* rate */
534         );
535 
536         bool useInternalInventory = conversionRate % 2 == 1;
537 
538         uint destAmount;
539         UniswapExchange exchange;
540         if (srcToken == ETH_TOKEN_ADDRESS) {
541             if (!useInternalInventory) {
542                 // Deduct fees (in ETH) before converting
543                 uint quantity = deductFee(srcAmount);
544                 exchange = UniswapExchange(tokenExchange[address(destToken)]);
545                 destAmount = exchange.ethToTokenSwapInput.value(quantity)(
546                     1, /* min_tokens: uniswap requires it to be > 0 */
547                     2 ** 255 /* deadline */
548                 );
549                 require(destAmount >= expectedDestAmount);
550             }
551 
552             // Transfer user-expected dest amount
553             require(destToken.transfer(destAddress, expectedDestAmount));
554         } else {
555             if (!useInternalInventory) {
556                 exchange = UniswapExchange(tokenExchange[address(srcToken)]);
557                 destAmount = exchange.tokenToEthSwapInput(
558                     srcAmount,
559                     1, /* min_eth: uniswap requires it to be > 0 */
560                     2 ** 255 /* deadline */
561                 );
562                 // Deduct fees (in ETH) after converting
563                 destAmount = deductFee(destAmount);
564                 require(destAmount >= expectedDestAmount);
565             }
566 
567             // Transfer user-expected dest amount
568             destAddress.transfer(expectedDestAmount);
569         }
570 
571         TradeExecute(
572             msg.sender, /* sender */
573             srcToken, /* src */
574             srcAmount, /* srcAmount */
575             destToken, /* destToken */
576             expectedDestAmount, /* destAmount */
577             destAddress, /* destAddress */
578             useInternalInventory /* useInternalInventory */
579         );
580         return true;
581     }
582 
583     event FeeUpdated(
584         uint bps
585     );
586 
587     function setFee(
588         uint bps
589     )
590         public
591         onlyAdmin
592     {
593         require(bps <= 10000);
594 
595         feeBps = bps;
596 
597         FeeUpdated(bps);
598     }
599 
600     event InternalActivationConfigUpdated(
601         ERC20 token,
602         uint minSpreadBps,
603         uint premiumBps
604     );
605 
606     function setInternalActivationConfig(
607         ERC20 token,
608         uint minSpreadBps,
609         uint premiumBps
610     )
611         public
612         onlyAdmin
613     {
614         require(tokenExchange[address(token)] != address(0));
615         require(minSpreadBps <= 1000); // min spread <= 10%
616         require(premiumBps <= 500); // premium <= 5%
617 
618         internalActivationMinSpreadBps[address(token)] = minSpreadBps;
619         internalPricePremiumBps[address(token)] = premiumBps;
620 
621         InternalActivationConfigUpdated(token, minSpreadBps, premiumBps);
622     }
623 
624     event InternalInventoryLimitsUpdated(
625         ERC20 token,
626         uint minBalance,
627         uint maxBalance
628     );
629 
630     function setInternalInventoryLimits(
631         ERC20 token,
632         uint minBalance,
633         uint maxBalance
634     )
635         public
636         onlyOperator
637     {
638         require(tokenExchange[address(token)] != address(0));
639 
640         internalInventoryMin[address(token)] = minBalance;
641         internalInventoryMax[address(token)] = maxBalance;
642 
643         InternalInventoryLimitsUpdated(token, minBalance, maxBalance);
644     }
645 
646     event TokenListed(
647         ERC20 token,
648         UniswapExchange exchange
649     );
650 
651     function listToken(ERC20 token)
652         public
653         onlyAdmin
654     {
655         require(address(token) != 0);
656 
657         UniswapExchange uniswapExchange = UniswapExchange(
658             uniswapFactory.getExchange(token)
659         );
660         tokenExchange[address(token)] = address(uniswapExchange);
661         setDecimals(token);
662 
663         require(token.approve(uniswapExchange, 2 ** 255));
664 
665         // internal inventory disabled by default
666         internalInventoryMin[address(token)] = 2 ** 255;
667         internalInventoryMax[address(token)] = 0;
668         internalActivationMinSpreadBps[address(token)] = 0;
669         internalPricePremiumBps[address(token)] = 0;
670 
671         TokenListed(token, uniswapExchange);
672     }
673 
674     event TokenDelisted(ERC20 token);
675 
676     function delistToken(ERC20 token)
677         public
678         onlyAdmin
679     {
680         require(tokenExchange[address(token)] != address(0));
681 
682         delete tokenExchange[address(token)];
683         delete internalInventoryMin[address(token)];
684         delete internalInventoryMax[address(token)];
685         delete internalActivationMinSpreadBps[address(token)];
686         delete internalPricePremiumBps[address(token)];
687 
688         TokenDelisted(token);
689     }
690 
691     function isValidTokens(
692         ERC20 src,
693         ERC20 dest
694     )
695         public
696         view
697         returns(bool)
698     {
699         return (
700             (
701                 src == ETH_TOKEN_ADDRESS &&
702                 tokenExchange[address(dest)] != address(0)
703             ) ||
704             (
705                 tokenExchange[address(src)] != address(0) &&
706                 dest == ETH_TOKEN_ADDRESS
707             )
708         );
709     }
710 
711     event TradeEnabled(
712         bool enable
713     );
714 
715     function enableTrade()
716         public
717         onlyAdmin
718         returns(bool)
719     {
720         tradeEnabled = true;
721         TradeEnabled(true);
722         return true;
723     }
724 
725     function disableTrade()
726         public
727         onlyAlerter
728         returns(bool)
729     {
730         tradeEnabled = false;
731         TradeEnabled(false);
732         return true;
733     }
734 
735     event KyberNetworkSet(
736         address kyberNetwork
737     );
738 
739     function setKyberNetwork(
740         address _kyberNetwork
741     )
742         public
743         onlyAdmin
744     {
745         require(_kyberNetwork != 0);
746         kyberNetwork = _kyberNetwork;
747         KyberNetworkSet(kyberNetwork);
748     }
749 
750     /*
751      * Uses amounts and rates to check if the reserve's internal inventory can
752      * be used directly.
753      *
754      * rateEthToToken and rateTokenToEth are in kyber rate format meaning
755      * rate as numerator and 1e18 as denominator.
756      */
757     function shouldUseInternalInventory(
758         ERC20 srcToken,
759         uint srcAmount,
760         ERC20 destToken,
761         uint destAmount,
762         uint rateSrcDest,
763         uint rateDestSrc
764     )
765         public
766         view
767         returns(bool)
768     {
769         require(srcAmount < MAX_QTY);
770         require(destAmount < MAX_QTY);
771 
772         // Check for internal inventory balance limitations
773         ERC20 token;
774         if (srcToken == ETH_TOKEN_ADDRESS) {
775             token = destToken;
776             uint tokenBalance = token.balanceOf(this);
777             if (
778                 tokenBalance < destAmount ||
779                 tokenBalance - destAmount < internalInventoryMin[token]
780             ) {
781                 return false;
782             }
783         } else {
784             token = srcToken;
785             if (this.balance < destAmount) return false;
786             if (token.balanceOf(this) + srcAmount > internalInventoryMax[token]) {
787                 return false;
788             }
789         }
790 
791         uint normalizedDestSrc = 10 ** 36 / rateDestSrc;
792 
793         // Check for arbitrage
794         if (rateSrcDest > normalizedDestSrc) return false;
795 
796         uint activationSpread = internalActivationMinSpreadBps[token];
797         uint spread = uint(calculateSpreadBps(normalizedDestSrc, rateSrcDest));
798         return spread >= activationSpread;
799     }
800 
801     /*
802      * Spread calculation is (ask - bid) / ((ask + bid) / 2).
803      * We multiply by 10000 to get result in BPS.
804      *
805      * Note: if askRate > bidRate result will be negative indicating
806      * internal arbitrage.
807      */
808     function calculateSpreadBps(
809         uint _askRate,
810         uint _bidRate
811     )
812         public
813         pure
814         returns(int)
815     {
816         int askRate = int(_askRate);
817         int bidRate = int(_bidRate);
818         return 10000 * 2 * (askRate - bidRate) / (askRate + bidRate);
819     }
820 
821     function deductFee(
822         uint amount
823     )
824         public
825         view
826         returns(uint)
827     {
828         return amount * (10000 - feeBps) / 10000;
829     }
830 
831     function addPremium(
832         ERC20 token,
833         uint amount
834     )
835         public
836         view
837         returns(uint)
838     {
839         require(amount <= MAX_QTY);
840         return amount * (10000 + internalPricePremiumBps[token]) / 10000;
841     }
842 
843     function calcUniswapConversion(
844         ERC20 src,
845         ERC20 dest,
846         uint srcQty
847     )
848         internal
849         view
850         returns(uint destQty, uint rate)
851     {
852         UniswapExchange exchange;
853         if (src == ETH_TOKEN_ADDRESS) {
854             exchange = UniswapExchange(tokenExchange[address(dest)]);
855             destQty = exchange.getEthToTokenInputPrice(
856                 deductFee(srcQty)
857             );
858         } else {
859             exchange = UniswapExchange(tokenExchange[address(src)]);
860             destQty = deductFee(
861                 exchange.getTokenToEthInputPrice(srcQty)
862             );
863         }
864 
865         rate = calcRateFromQty(
866             srcQty, /* srcAmount */
867             destQty, /* destAmount */
868             getDecimals(src), /* srcDecimals */
869             getDecimals(dest) /* dstDecimals */
870         );
871     }
872 }