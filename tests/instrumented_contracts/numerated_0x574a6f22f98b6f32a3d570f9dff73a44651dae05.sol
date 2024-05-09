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
312 /* for declaring the mapping here, must define this interface as contract */
313 contract DutchXExchange {
314     // Token => Token => amount
315     mapping (address => mapping (address => uint)) public sellVolumesCurrent;
316     // Token => Token => amount
317     mapping (address => mapping (address => uint)) public buyVolumes;
318     address public ethToken;
319     function deposit(address tokenAddress,uint amount) public returns(uint);
320     function postBuyOrder(address sellToken,address buyToken,uint auctionIndex,uint amount) public returns (uint);
321 
322     function claimBuyerFunds(address sellToken, address buyToken, address user, uint auctionIndex) public
323         returns(uint returned, uint frtsIssued);
324 
325     function withdraw(address tokenAddress,uint amount) public returns (uint);
326     function getAuctionIndex(address sellToken, address buyToken) public view returns(uint index);
327     function getFeeRatio(address user) public view returns (uint num, uint den); // feeRatio < 10^4
328 
329     function getCurrentAuctionPrice(address sellToken, address buyToken, uint auctionIndex) public view
330         returns (uint num, uint den);
331 }
332 
333 
334 contract KyberDutchXReserve is KyberReserveInterface, Withdrawable, Utils2 {
335 
336     uint public constant BPS = 10000;
337     uint public constant DEFAULT_KYBER_FEE_BPS = 25;
338     uint public feeBps = DEFAULT_KYBER_FEE_BPS;
339     uint public dutchXFeeNum;
340     uint public dutchXFeeDen;
341 
342     DutchXExchange public dutchX;
343     address public kyberNetwork;
344     WETH9 public weth;
345 
346     mapping(address => bool) listedTokens;
347 
348     bool public tradeEnabled = true;
349 
350     /**
351         Constructor
352     */
353     function KyberDutchXReserve(
354         DutchXExchange _dutchX,
355         address _admin,
356         address _kyberNetwork,
357         WETH9 _weth
358     )
359         public
360     {
361         require(address(_dutchX) != 0);
362         require(_admin != 0);
363         require(_kyberNetwork != 0);
364         require(_weth != WETH9(0));
365 
366         dutchX = _dutchX;
367         admin = _admin;
368         kyberNetwork = _kyberNetwork;
369 
370 //        require(dutchX.ethToken() == address(_weth));
371         weth = _weth;
372 
373         weth.approve(dutchX, 2 ** 255);
374         setDecimals(ETH_TOKEN_ADDRESS);
375         listedTokens[ETH_TOKEN_ADDRESS] = true;
376     }
377 
378     function() public payable {
379         // anyone can deposit ether
380     }
381 
382     function setDutchXFees() public {
383         (dutchXFeeNum, dutchXFeeDen) = dutchX.getFeeRatio(this);
384     }
385 
386     struct AuctionData {
387         uint index;
388         ERC20 srcToken;
389         ERC20 dstToken;
390         uint num;
391         uint den;
392     }
393 
394     /**
395         Returns dest quantity / source quantity.
396     */
397     function getConversionRate(
398         ERC20 src,
399         ERC20 dest,
400         uint srcQty,
401         uint blockNumber
402     )
403         public
404         view
405         returns(uint)
406     {
407         blockNumber;
408         if (!tradeEnabled) return 0;
409         if (!listedTokens[src] || !listedTokens[dest]) return 0;
410 
411         AuctionData memory auctionData;
412         auctionData.srcToken = src == ETH_TOKEN_ADDRESS ? ERC20(weth) : src;
413         auctionData.dstToken = dest == ETH_TOKEN_ADDRESS ? ERC20(weth) : dest;
414         auctionData.index = dutchX.getAuctionIndex(auctionData.dstToken, auctionData.srcToken);
415         if (auctionData.index == 0) return 0;
416 
417         (auctionData.num, auctionData.den) = dutchX.getCurrentAuctionPrice(
418                 auctionData.dstToken,
419                 auctionData.srcToken,
420                 auctionData.index
421             );
422 
423         if (!sufficientLiquidity(auctionData.srcToken, srcQty, auctionData.dstToken,
424             auctionData.num, auctionData.den)) {
425             return 0;
426         }
427 
428         uint actualSrcQty = (src == ETH_TOKEN_ADDRESS) ? srcQty * (BPS - feeBps) / BPS : srcQty;
429         require(actualSrcQty * auctionData.den > actualSrcQty);
430         uint convertedQty = (actualSrcQty * auctionData.den) / auctionData.num;
431         convertedQty = (src == ETH_TOKEN_ADDRESS) ? convertedQty : convertedQty * (BPS - feeBps) / BPS;
432 
433         return calcRateFromQty(
434             actualSrcQty, /* srcAmount */
435             convertedQty, /* destAmount */
436             getDecimals(src), /* srcDecimals */
437             getDecimals(dest) /* dstDecimals */
438         );
439     }
440 
441     event TradeExecute(
442         address indexed sender,
443         address src,
444         uint srcAmount,
445         address destToken,
446         uint destAmount,
447         address destAddress,
448         uint auctionIndex
449     );
450 
451     function trade(
452         ERC20 srcToken,
453         uint srcAmount,
454         ERC20 destToken,
455         address destAddress,
456         uint conversionRate,
457         bool validate
458     )
459         public
460         payable
461         returns(bool)
462     {
463         validate;
464 
465         require(tradeEnabled);
466         require(msg.sender == kyberNetwork);
467 
468         AuctionData memory auctionData;
469         auctionData.srcToken = srcToken == ETH_TOKEN_ADDRESS ? ERC20(weth) : srcToken;
470         auctionData.dstToken = destToken == ETH_TOKEN_ADDRESS ? ERC20(weth) : destToken;
471         auctionData.index = dutchX.getAuctionIndex(auctionData.dstToken, auctionData.srcToken);
472         if (auctionData.index == 0) revert();
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
491         (destAmount, frtsIssued) = dutchX.claimBuyerFunds(auctionData.dstToken, auctionData.srcToken, this,
492             auctionData.index);
493         dutchX.withdraw(auctionData.dstToken, destAmount);
494 
495         if (destToken == ETH_TOKEN_ADDRESS) {
496             weth.withdraw(destAmount);
497             destAmount = destAmount * (BPS - feeBps) / BPS;
498             destAddress.transfer(destAmount);
499         } else {
500             require(auctionData.dstToken.transfer(destAddress, destAmount));
501         }
502 
503         require(conversionRate <= calcRateFromQty(
504             actualSrcQty, /* srcAmount */
505             destAmount, /* destAmount */
506             getDecimals(srcToken), /* srcDecimals */
507             getDecimals(destToken) /* dstDecimals */
508         ));
509         
510         TradeExecute(
511             msg.sender, /* sender */
512             srcToken, /* src */
513             srcAmount, /* srcAmount */
514             destToken, /* destToken */
515             destAmount, /* destAmount */
516             destAddress, /* destAddress */
517             auctionData.index
518         );
519 
520         return true;
521     }
522 
523     event FeeUpdated(
524         uint bps
525     );
526 
527     function setFee(uint bps) public onlyAdmin {
528         require(bps <= BPS);
529         feeBps = bps;
530         FeeUpdated(bps);
531     }
532 
533     event TokenListed(
534         ERC20 token
535     );
536 
537     function listToken(ERC20 token)
538         public
539         onlyAdmin
540     {
541         require(address(token) != 0);
542 
543         listedTokens[token] = true;
544 
545         setDecimals(token);
546 
547         require(token.approve(dutchX, 2**255));
548 
549         TokenListed(token);
550     }
551 
552     event TokenDelisted(ERC20 token);
553 
554     function delistToken(ERC20 token)
555         public
556         onlyAdmin
557     {
558         require(listedTokens[token] == true);
559         listedTokens[token] == false;
560 
561         TokenDelisted(token);
562     }
563 
564     event TradeEnabled(
565         bool enable
566     );
567 
568     function enableTrade()
569         public
570         onlyAdmin
571         returns(bool)
572     {
573         tradeEnabled = true;
574         TradeEnabled(true);
575         return true;
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