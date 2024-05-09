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
336 
337     uint public feeBps = DEFAULT_KYBER_FEE_BPS;
338     uint public dutchXFeeNum;
339     uint public dutchXFeeDen;
340 
341     DutchXExchange public dutchX;
342     address public kyberNetwork;
343     WETH9 public weth;
344 
345     mapping(address => bool) public listedTokens;
346 
347     bool public tradeEnabled;
348 
349     /**
350         Constructor
351     */
352     function KyberDutchXReserve(
353         DutchXExchange _dutchX,
354         address _admin,
355         address _kyberNetwork,
356         WETH9 _weth
357     )
358         public
359     {
360         require(address(_dutchX) != address(0));
361         require(_admin != address(0));
362         require(_kyberNetwork != address(0));
363         require(_weth != WETH9(0));
364 
365         dutchX = _dutchX;
366         admin = _admin;
367         kyberNetwork = _kyberNetwork;
368         weth = _weth;
369 
370         setDutchXFee();
371         require(weth.approve(dutchX, 2 ** 255));
372         setDecimals(ETH_TOKEN_ADDRESS);
373     }
374 
375     function() public payable {
376         // anyone can deposit ether
377     }
378 
379     struct AuctionData {
380         uint index;
381         ERC20 srcToken;
382         ERC20 dstToken;
383         uint priceNum; // numerator
384         uint priceDen; // denominator
385     }
386 
387     /**
388         Returns rate = dest quantity / source quantity.
389     */
390     function getConversionRate(
391         ERC20 src,
392         ERC20 dest,
393         uint srcQty,
394         uint blockNumber
395     )
396         public
397         view
398         returns(uint)
399     {
400         blockNumber;
401         if (!tradeEnabled) return 0;
402 
403         if (src == ETH_TOKEN_ADDRESS) {
404             if (!listedTokens[dest]) return 0;
405         } else if (dest == ETH_TOKEN_ADDRESS) {
406             if (!listedTokens[src]) return 0;
407         } else {
408             return 0;
409         }
410 
411         AuctionData memory auctionData = getAuctionData(src, dest);
412         if (auctionData.index == 0) return 0;
413 
414         (auctionData.priceNum, auctionData.priceDen) = dutchX.getCurrentAuctionPrice(
415                 auctionData.dstToken,
416                 auctionData.srcToken,
417                 auctionData.index
418             );
419 
420         if (!sufficientLiquidity(auctionData.srcToken, srcQty, auctionData.dstToken,
421             auctionData.priceNum, auctionData.priceDen)) {
422             return 0;
423         }
424 
425         // if source is Eth, reduce kyber fee from source.
426         uint actualSrcQty = (src == ETH_TOKEN_ADDRESS) ? srcQty * (BPS - feeBps) / BPS : srcQty;
427         require(actualSrcQty * auctionData.priceDen > actualSrcQty);
428         uint convertedQty = (actualSrcQty * auctionData.priceDen) / auctionData.priceNum;
429         // reduce dutchX fees
430         convertedQty = convertedQty * (dutchXFeeDen - dutchXFeeNum) / dutchXFeeDen;
431 
432         // if destination is Eth, reduce kyber fee from destination.
433         convertedQty = (dest == ETH_TOKEN_ADDRESS) ? convertedQty * (BPS - feeBps) / BPS : convertedQty;
434 
435         // here use original srcQty, which will give the real rate (as seen by internal kyberNetwork)
436         return calcRateFromQty(
437             srcQty, /* srcAmount */
438             convertedQty, /* destAmount */
439             getDecimals(src), /* srcDecimals */
440             getDecimals(dest) /* dstDecimals */
441         );
442     }
443 
444     event TradeExecute(
445         address indexed sender,
446         address src,
447         uint srcAmount,
448         address destToken,
449         uint destAmount,
450         address destAddress,
451         uint auctionIndex
452     );
453 
454     function trade(
455         ERC20 srcToken,
456         uint srcAmount,
457         ERC20 destToken,
458         address destAddress,
459         uint conversionRate,
460         bool validate
461     )
462         public
463         payable
464         returns(bool)
465     {
466         validate;
467 
468         require(tradeEnabled);
469         require(msg.sender == kyberNetwork);
470 
471         AuctionData memory auctionData = getAuctionData(srcToken, destToken);
472         require(auctionData.index != 0);
473 
474         uint actualSrcQty;
475 
476         if (srcToken == ETH_TOKEN_ADDRESS){
477             require(srcAmount == msg.value);
478             actualSrcQty = srcAmount * (BPS - feeBps) / BPS;
479             weth.deposit.value(actualSrcQty)();
480         } else {
481             require(msg.value == 0);
482             require(srcToken.transferFrom(msg.sender, address(this), srcAmount));
483             actualSrcQty = srcAmount;
484         }
485 
486         dutchX.deposit(auctionData.srcToken, actualSrcQty);
487         dutchX.postBuyOrder(auctionData.dstToken, auctionData.srcToken, auctionData.index, actualSrcQty);
488 
489         uint destAmount;
490         uint frtsIssued;
491         (destAmount, frtsIssued) = dutchX.claimBuyerFunds(
492             auctionData.dstToken,
493             auctionData.srcToken,
494             this,
495             auctionData.index
496         );
497 
498         dutchX.withdraw(auctionData.dstToken, destAmount);
499 
500         if (destToken == ETH_TOKEN_ADDRESS) {
501             weth.withdraw(destAmount);
502             destAmount = destAmount * (BPS - feeBps) / BPS;
503             destAddress.transfer(destAmount);
504         } else {
505             require(auctionData.dstToken.transfer(destAddress, destAmount));
506         }
507 
508         require(conversionRate <= calcRateFromQty(
509             srcAmount, /* srcAmount */
510             destAmount, /* destAmount */
511             getDecimals(srcToken), /* srcDecimals */
512             getDecimals(destToken) /* dstDecimals */
513         ));
514         
515         TradeExecute(
516             msg.sender, /* sender */
517             srcToken, /* src */
518             srcAmount, /* srcAmount */
519             destToken, /* destToken */
520             destAmount, /* destAmount */
521             destAddress, /* destAddress */
522             auctionData.index
523         );
524 
525         return true;
526     }
527 
528     event FeeUpdated(
529         uint bps
530     );
531 
532     function setFee(uint bps) public onlyAdmin {
533         require(bps <= BPS);
534         feeBps = bps;
535         FeeUpdated(bps);
536     }
537 
538     event TokenListed(
539         ERC20 token
540     );
541 
542     function listToken(ERC20 token)
543         public
544         onlyAdmin
545     {
546         require(address(token) != address(0));
547 
548         listedTokens[token] = true;
549         setDecimals(token);
550         require(token.approve(dutchX, 2**255));
551         TokenListed(token);
552     }
553 
554     event TokenDelisted(ERC20 token);
555 
556     function delistToken(ERC20 token)
557         public
558         onlyAdmin
559     {
560         require(listedTokens[token]);
561         listedTokens[token] = false;
562 
563         TokenDelisted(token);
564     }
565 
566     event TradeEnabled(
567         bool enable
568     );
569 
570     function setDutchXFee() public {
571         (dutchXFeeNum, dutchXFeeDen) = dutchX.getFeeRatio(this);
572 
573         // can't use denominator 0 (EVM bad instruction)
574         if (dutchXFeeDen == 0) {
575             tradeEnabled = false;
576         }
577 
578         TradeEnabled(tradeEnabled);
579     }
580 
581     function disableTrade()
582         public
583         onlyAlerter
584         returns(bool)
585     {
586         tradeEnabled = false;
587         TradeEnabled(tradeEnabled);
588         return true;
589     }
590 
591     function enableTrade()
592         public
593         onlyAdmin
594         returns(bool)
595     {
596         tradeEnabled = true;
597         TradeEnabled(tradeEnabled);
598         return true;
599     }
600 
601     event KyberNetworkSet(
602         address kyberNetwork
603     );
604 
605     function setKyberNetwork(
606         address _kyberNetwork
607     )
608         public
609         onlyAdmin
610     {
611         require(_kyberNetwork != address(0));
612         kyberNetwork = _kyberNetwork;
613         KyberNetworkSet(kyberNetwork);
614     }
615 
616     event Execution(bool success, address caller, address destination, uint value, bytes data);
617 
618     function executeTransaction(address destination, uint value, bytes data)
619         public
620         onlyOperator
621     {
622         if (destination.call.value(value)(data)) {
623             Execution(true, msg.sender, destination, value, data);
624         } else {
625             revert();
626         }
627     }
628 
629     function sufficientLiquidity(ERC20 src, uint srcQty, ERC20 dest, uint priceNum, uint priceDen)
630         internal view returns(bool)
631     {
632         uint buyVolume = dutchX.buyVolumes(dest, src);
633         uint sellVolume = dutchX.sellVolumesCurrent(dest, src);
634 
635         // 10^30 * 10^37 = 10^67
636         require(sellVolume * priceNum > sellVolume);
637         uint outstandingVolume = (sellVolume * priceNum) / priceDen - buyVolume;
638 
639         if (outstandingVolume >= srcQty) return true;
640 
641         return false;
642     }
643 
644     function getAuctionData(ERC20 src, ERC20 dst) internal view returns (AuctionData data) {
645         data.srcToken = src == ETH_TOKEN_ADDRESS ? ERC20(weth) : src;
646         data.dstToken = dst == ETH_TOKEN_ADDRESS ? ERC20(weth) : dst;
647         data.index = dutchX.getAuctionIndex(data.dstToken, data.srcToken);
648     }
649 }