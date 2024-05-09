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
303 // File: contracts/dutchX/KyberDutchXReserve.sol
304 
305 interface WETH9 {
306     function approve(address spender, uint amount) public returns(bool);
307     function withdraw(uint amount) public;
308     function deposit() public payable;
309 }
310 
311 
312 interface DutchXExchange {
313     // Two functions below are in fact: mapping (address => mapping (address => uint)) public sellVolumesCurrent;
314     // Token => Token => amount
315     function buyVolumes(address sellToken, address buyToken) public view returns (uint);
316     function sellVolumesCurrent(address sellToken, address buyToken) public view returns (uint);
317     function deposit(address tokenAddress,uint amount) public returns(uint);
318     function postBuyOrder(address sellToken,address buyToken,uint auctionIndex,uint amount) public returns (uint);
319 
320     function claimBuyerFunds(address sellToken, address buyToken, address user, uint auctionIndex) public
321         returns(uint returned, uint frtsIssued);
322 
323     function withdraw(address tokenAddress,uint amount) public returns (uint);
324     function getAuctionIndex(address sellToken, address buyToken) public view returns(uint index);
325     function getFeeRatio(address user) public view returns (uint num, uint den); // feeRatio < 10^4
326 
327     function getCurrentAuctionPrice(address sellToken, address buyToken, uint auctionIndex) public view
328         returns (uint num, uint den);
329 }
330 
331 
332 contract KyberDutchXReserve is KyberReserveInterface, Withdrawable, Utils2 {
333 
334     uint public constant BPS = 10000;
335     uint public constant DEFAULT_KYBER_FEE_BPS = 25;
336     uint public feeBps = DEFAULT_KYBER_FEE_BPS;
337     uint public dutchXFeeNum;
338     uint public dutchXFeeDen;
339 
340     DutchXExchange public dutchX;
341     address public kyberNetwork;
342     WETH9 public weth;
343 
344     mapping(address => bool) listedTokens;
345 
346     bool public tradeEnabled;
347 
348     /**
349         Constructor
350     */
351     function KyberDutchXReserve(
352         DutchXExchange _dutchX,
353         address _admin,
354         address _kyberNetwork,
355         WETH9 _weth
356     )
357         public
358     {
359         require(address(_dutchX) != 0);
360         require(_admin != 0);
361         require(_kyberNetwork != 0);
362         require(_weth != WETH9(0));
363 
364         dutchX = _dutchX;
365         admin = _admin;
366         kyberNetwork = _kyberNetwork;
367         weth = _weth;
368 
369         weth.approve(dutchX, 2 ** 255);
370         setDecimals(ETH_TOKEN_ADDRESS);
371         listedTokens[ETH_TOKEN_ADDRESS] = true;
372     }
373 
374     function() public payable {
375         // anyone can deposit ether
376     }
377 
378     struct AuctionData {
379         uint index;
380         ERC20 srcToken;
381         ERC20 dstToken;
382         uint num;
383         uint den;
384     }
385 
386     /**
387         Returns rate = dest quantity / source quantity.
388     */
389     function getConversionRate(
390         ERC20 src,
391         ERC20 dest,
392         uint srcQty,
393         uint blockNumber
394     )
395         public
396         view
397         returns(uint)
398     {
399         blockNumber;
400         if (!tradeEnabled) return 0;
401         if (!listedTokens[src] || !listedTokens[dest]) return 0;
402 
403         AuctionData memory auctionData;
404         auctionData.srcToken = src == ETH_TOKEN_ADDRESS ? ERC20(weth) : src;
405         auctionData.dstToken = dest == ETH_TOKEN_ADDRESS ? ERC20(weth) : dest;
406         auctionData.index = dutchX.getAuctionIndex(auctionData.dstToken, auctionData.srcToken);
407         if (auctionData.index == 0) return 0;
408 
409         (auctionData.num, auctionData.den) = dutchX.getCurrentAuctionPrice(
410                 auctionData.dstToken,
411                 auctionData.srcToken,
412                 auctionData.index
413             );
414 
415         if (!sufficientLiquidity(auctionData.srcToken, srcQty, auctionData.dstToken,
416             auctionData.num, auctionData.den)) {
417             return 0;
418         }
419 
420         // if source is Eth, reduce kyber fee from source.
421         uint actualSrcQty = (src == ETH_TOKEN_ADDRESS) ? srcQty * (BPS - feeBps) / BPS : srcQty;
422         require(actualSrcQty * auctionData.den > actualSrcQty);
423         uint convertedQty = (actualSrcQty * auctionData.den) / auctionData.num;
424         // reduce dutchX fees
425         convertedQty -= convertedQty * dutchXFeeNum / dutchXFeeDen;
426 
427         // if destination is Eth, reduce kyber fee from destination.
428         convertedQty = (src == ETH_TOKEN_ADDRESS) ? convertedQty : convertedQty * (BPS - feeBps) / BPS;
429 
430         return calcRateFromQty(
431             actualSrcQty, /* srcAmount */
432             convertedQty, /* destAmount */
433             getDecimals(src), /* srcDecimals */
434             getDecimals(dest) /* dstDecimals */
435         );
436     }
437 
438     event TradeExecute(
439         address indexed sender,
440         address src,
441         uint srcAmount,
442         address destToken,
443         uint destAmount,
444         address destAddress,
445         uint auctionIndex
446     );
447 
448     function trade(
449         ERC20 srcToken,
450         uint srcAmount,
451         ERC20 destToken,
452         address destAddress,
453         uint conversionRate,
454         bool validate
455     )
456         public
457         payable
458         returns(bool)
459     {
460         validate;
461 
462         require(tradeEnabled);
463         require(msg.sender == kyberNetwork);
464 
465         AuctionData memory auctionData;
466         auctionData.srcToken = srcToken == ETH_TOKEN_ADDRESS ? ERC20(weth) : srcToken;
467         auctionData.dstToken = destToken == ETH_TOKEN_ADDRESS ? ERC20(weth) : destToken;
468         auctionData.index = dutchX.getAuctionIndex(auctionData.dstToken, auctionData.srcToken);
469         if (auctionData.index == 0) revert();
470 
471         uint actualSrcQty;
472 
473         if (srcToken == ETH_TOKEN_ADDRESS){
474             require(srcAmount == msg.value);
475             actualSrcQty = srcAmount * (BPS - feeBps) / BPS;
476             weth.deposit.value(actualSrcQty)();
477         } else {
478             require(msg.value == 0);
479             require(srcToken.transferFrom(msg.sender, address(this), srcAmount));
480             actualSrcQty = srcAmount;
481         }
482 
483         dutchX.deposit(auctionData.srcToken, actualSrcQty);
484         dutchX.postBuyOrder(auctionData.dstToken, auctionData.srcToken, auctionData.index, actualSrcQty);
485 
486         uint destAmount;
487         uint frtsIssued;
488         (destAmount, frtsIssued) = dutchX.claimBuyerFunds(auctionData.dstToken, auctionData.srcToken, this,
489             auctionData.index);
490         dutchX.withdraw(auctionData.dstToken, destAmount);
491 
492         if (destToken == ETH_TOKEN_ADDRESS) {
493             weth.withdraw(destAmount);
494             destAmount = destAmount * (BPS - feeBps) / BPS;
495             destAddress.transfer(destAmount);
496         } else {
497             require(auctionData.dstToken.transfer(destAddress, destAmount));
498         }
499 
500         require(conversionRate <= calcRateFromQty(
501             actualSrcQty, /* srcAmount */
502             destAmount, /* destAmount */
503             getDecimals(srcToken), /* srcDecimals */
504             getDecimals(destToken) /* dstDecimals */
505         ));
506         
507         TradeExecute(
508             msg.sender, /* sender */
509             srcToken, /* src */
510             srcAmount, /* srcAmount */
511             destToken, /* destToken */
512             destAmount, /* destAmount */
513             destAddress, /* destAddress */
514             auctionData.index
515         );
516 
517         return true;
518     }
519 
520     event FeeUpdated(
521         uint bps
522     );
523 
524     function setFee(uint bps) public onlyAdmin {
525         require(bps <= BPS);
526         feeBps = bps;
527         FeeUpdated(bps);
528     }
529 
530     event TokenListed(
531         ERC20 token
532     );
533 
534     function listToken(ERC20 token)
535         public
536         onlyAdmin
537     {
538         require(address(token) != 0);
539 
540         listedTokens[token] = true;
541 
542         setDecimals(token);
543 
544         require(token.approve(dutchX, 2**255));
545 
546         TokenListed(token);
547     }
548 
549     event TokenDelisted(ERC20 token);
550 
551     function delistToken(ERC20 token)
552         public
553         onlyAdmin
554     {
555         require(listedTokens[token] == true);
556         listedTokens[token] == false;
557 
558         TokenDelisted(token);
559     }
560 
561     event TradeEnabled(
562         bool enable
563     );
564 
565     function setDutchXFee() public {
566         (dutchXFeeNum, dutchXFeeDen) = dutchX.getFeeRatio(this);
567 
568         // can't use denominator 0 (EVM bad instruction)
569         if (dutchXFeeDen == 0) {
570             tradeEnabled = false;
571         } else {
572             tradeEnabled = true;
573         }
574 
575         TradeEnabled(tradeEnabled);
576     }
577 
578     function disableTrade()
579         public
580         onlyAlerter
581         returns(bool)
582     {
583         tradeEnabled = false;
584         TradeEnabled(false);
585         return true;
586     }
587 
588     event KyberNetworkSet(
589         address kyberNetwork
590     );
591 
592     function setKyberNetwork(
593         address _kyberNetwork
594     )
595         public
596         onlyAdmin
597     {
598         require(_kyberNetwork != 0);
599         kyberNetwork = _kyberNetwork;
600         KyberNetworkSet(kyberNetwork);
601     }
602 
603     event DutchXSet(
604         DutchXExchange dutchX
605     );
606 
607     function setDutchX(
608         DutchXExchange _dutchX
609     )
610         public
611         onlyAdmin
612     {
613         require(_dutchX != DutchXExchange(0));
614         dutchX = _dutchX;
615         DutchXSet(dutchX);
616     }
617 
618     event Execution(bool success, address caller, address destination, uint value, bytes data);
619 
620     function executeTransaction(address destination, uint value, bytes data)
621         public
622         onlyOperator
623     {
624         if (destination.call.value(value)(data)) {
625             Execution(true, msg.sender, destination, value, data);
626         } else {
627             Execution(false, msg.sender, destination, value, data);
628         }
629     }
630 
631     function sufficientLiquidity(ERC20 src, uint srcQty, ERC20 dest, uint num, uint den) internal view returns(bool) {
632 
633         uint buyVolume = dutchX.buyVolumes(dest, src);
634         uint sellVolume = dutchX.sellVolumesCurrent(dest, src);
635 
636         // 10^30 * 10^37 = 10^67
637         require(sellVolume * num > sellVolume);
638         uint outstandingVolume = (sellVolume * num) / den - buyVolume;
639 
640         if (outstandingVolume > srcQty) return true;
641 
642         return false;
643     }
644 }