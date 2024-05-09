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
346     bool public tradeEnabled = true;
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
378     function setDutchXFee() public {
379         (dutchXFeeNum, dutchXFeeDen) = dutchX.getFeeRatio(this);
380     }
381 
382     struct AuctionData {
383         uint index;
384         ERC20 srcToken;
385         ERC20 dstToken;
386         uint num;
387         uint den;
388     }
389 
390     /**
391         Returns rate = dest quantity / source quantity.
392     */
393     function getConversionRate(
394         ERC20 src,
395         ERC20 dest,
396         uint srcQty,
397         uint blockNumber
398     )
399         public
400         view
401         returns(uint)
402     {
403         blockNumber;
404         if (!tradeEnabled) return 0;
405         if (!listedTokens[src] || !listedTokens[dest]) return 0;
406 
407         AuctionData memory auctionData;
408         auctionData.srcToken = src == ETH_TOKEN_ADDRESS ? ERC20(weth) : src;
409         auctionData.dstToken = dest == ETH_TOKEN_ADDRESS ? ERC20(weth) : dest;
410         auctionData.index = dutchX.getAuctionIndex(auctionData.dstToken, auctionData.srcToken);
411         if (auctionData.index == 0) return 0;
412 
413         (auctionData.num, auctionData.den) = dutchX.getCurrentAuctionPrice(
414                 auctionData.dstToken,
415                 auctionData.srcToken,
416                 auctionData.index
417             );
418 
419         if (!sufficientLiquidity(auctionData.srcToken, srcQty, auctionData.dstToken,
420             auctionData.num, auctionData.den)) {
421             return 0;
422         }
423 
424         // if source is Eth, reduce kyber fee from source.
425         uint actualSrcQty = (src == ETH_TOKEN_ADDRESS) ? srcQty * (BPS - feeBps) / BPS : srcQty;
426         require(actualSrcQty * auctionData.den > actualSrcQty);
427         uint convertedQty = (actualSrcQty * auctionData.den) / auctionData.num;
428         // reduce dutchX fees
429         convertedQty -= convertedQty * dutchXFeeNum / dutchXFeeDen;
430 
431         // if destination is Eth, reduce kyber fee from destination.
432         convertedQty = (src == ETH_TOKEN_ADDRESS) ? convertedQty : convertedQty * (BPS - feeBps) / BPS;
433 
434         return calcRateFromQty(
435             actualSrcQty, /* srcAmount */
436             convertedQty, /* destAmount */
437             getDecimals(src), /* srcDecimals */
438             getDecimals(dest) /* dstDecimals */
439         );
440     }
441 
442     event TradeExecute(
443         address indexed sender,
444         address src,
445         uint srcAmount,
446         address destToken,
447         uint destAmount,
448         address destAddress,
449         uint auctionIndex
450     );
451 
452     function trade(
453         ERC20 srcToken,
454         uint srcAmount,
455         ERC20 destToken,
456         address destAddress,
457         uint conversionRate,
458         bool validate
459     )
460         public
461         payable
462         returns(bool)
463     {
464         validate;
465 
466         require(tradeEnabled);
467         require(msg.sender == kyberNetwork);
468 
469         AuctionData memory auctionData;
470         auctionData.srcToken = srcToken == ETH_TOKEN_ADDRESS ? ERC20(weth) : srcToken;
471         auctionData.dstToken = destToken == ETH_TOKEN_ADDRESS ? ERC20(weth) : destToken;
472         auctionData.index = dutchX.getAuctionIndex(auctionData.dstToken, auctionData.srcToken);
473         if (auctionData.index == 0) revert();
474 
475         uint actualSrcQty;
476 
477         if (srcToken == ETH_TOKEN_ADDRESS){
478             require(srcAmount == msg.value);
479             actualSrcQty = srcAmount * (BPS - feeBps) / BPS;
480             weth.deposit.value(actualSrcQty)();
481         } else {
482             require(msg.value == 0);
483             require(srcToken.transferFrom(msg.sender, address(this), srcAmount));
484             actualSrcQty = srcAmount;
485         }
486 
487         dutchX.deposit(auctionData.srcToken, actualSrcQty);
488         dutchX.postBuyOrder(auctionData.dstToken, auctionData.srcToken, auctionData.index, actualSrcQty);
489 
490         uint destAmount;
491         uint frtsIssued;
492         (destAmount, frtsIssued) = dutchX.claimBuyerFunds(auctionData.dstToken, auctionData.srcToken, this,
493             auctionData.index);
494         dutchX.withdraw(auctionData.dstToken, destAmount);
495 
496         if (destToken == ETH_TOKEN_ADDRESS) {
497             weth.withdraw(destAmount);
498             destAmount = destAmount * (BPS - feeBps) / BPS;
499             destAddress.transfer(destAmount);
500         } else {
501             require(auctionData.dstToken.transfer(destAddress, destAmount));
502         }
503 
504         require(conversionRate <= calcRateFromQty(
505             actualSrcQty, /* srcAmount */
506             destAmount, /* destAmount */
507             getDecimals(srcToken), /* srcDecimals */
508             getDecimals(destToken) /* dstDecimals */
509         ));
510         
511         TradeExecute(
512             msg.sender, /* sender */
513             srcToken, /* src */
514             srcAmount, /* srcAmount */
515             destToken, /* destToken */
516             destAmount, /* destAmount */
517             destAddress, /* destAddress */
518             auctionData.index
519         );
520 
521         return true;
522     }
523 
524     event FeeUpdated(
525         uint bps
526     );
527 
528     function setFee(uint bps) public onlyAdmin {
529         require(bps <= BPS);
530         feeBps = bps;
531         FeeUpdated(bps);
532     }
533 
534     event TokenListed(
535         ERC20 token
536     );
537 
538     function listToken(ERC20 token)
539         public
540         onlyAdmin
541     {
542         require(address(token) != 0);
543 
544         listedTokens[token] = true;
545 
546         setDecimals(token);
547 
548         require(token.approve(dutchX, 2**255));
549 
550         TokenListed(token);
551     }
552 
553     event TokenDelisted(ERC20 token);
554 
555     function delistToken(ERC20 token)
556         public
557         onlyAdmin
558     {
559         require(listedTokens[token] == true);
560         listedTokens[token] == false;
561 
562         TokenDelisted(token);
563     }
564 
565     event TradeEnabled(
566         bool enable
567     );
568 
569     function enableTrade()
570         public
571         onlyAdmin
572         returns(bool)
573     {
574         tradeEnabled = true;
575         TradeEnabled(true);
576         return true;
577     }
578 
579     function disableTrade()
580         public
581         onlyAlerter
582         returns(bool)
583     {
584         tradeEnabled = false;
585         TradeEnabled(false);
586         return true;
587     }
588 
589     event KyberNetworkSet(
590         address kyberNetwork
591     );
592 
593     function setKyberNetwork(
594         address _kyberNetwork
595     )
596         public
597         onlyAdmin
598     {
599         require(_kyberNetwork != 0);
600         kyberNetwork = _kyberNetwork;
601         KyberNetworkSet(kyberNetwork);
602     }
603 
604     event DutchXSet(
605         DutchXExchange dutchX
606     );
607 
608     function setDutchX(
609         DutchXExchange _dutchX
610     )
611         public
612         onlyAdmin
613     {
614         require(_dutchX != DutchXExchange(0));
615         dutchX = _dutchX;
616         DutchXSet(dutchX);
617     }
618 
619     event Execution(bool success, address caller, address destination, uint value, bytes data);
620 
621     function executeTransaction(address destination, uint value, bytes data)
622         public
623         onlyOperator
624     {
625         if (destination.call.value(value)(data)) {
626             Execution(true, msg.sender, destination, value, data);
627         } else {
628             Execution(false, msg.sender, destination, value, data);
629         }
630     }
631 
632     function sufficientLiquidity(ERC20 src, uint srcQty, ERC20 dest, uint num, uint den) internal view returns(bool) {
633 
634         uint buyVolume = dutchX.buyVolumes(dest, src);
635         uint sellVolume = dutchX.sellVolumesCurrent(dest, src);
636 
637         // 10^30 * 10^37 = 10^67
638         require(sellVolume * num > sellVolume);
639         uint outstandingVolume = (sellVolume * num) / den - buyVolume;
640 
641         if (outstandingVolume > srcQty) return true;
642 
643         return false;
644     }
645 }