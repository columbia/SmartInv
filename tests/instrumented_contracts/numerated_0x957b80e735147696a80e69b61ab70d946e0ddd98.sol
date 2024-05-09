1 pragma solidity ^0.4.25;
2 
3  /*
4   * @title: SafeMath
5   * @dev: Helper contract functions to arithmatic operations safely.
6   */
7 contract SafeMath {
8   function Sub(uint128 a, uint128 b) pure public returns (uint128) {
9     assert(b <= a);
10     return a - b;
11   }
12 
13   function Add(uint128 a, uint128 b) pure public returns (uint128) {
14     uint128 c = a + b;
15     assert(c>=a && c>=b);
16     return c;
17   }
18 }
19 
20  /*
21   * @title: Token
22   * @dev: Interface contract for ERC20 tokens
23   */
24 contract Token {
25   function totalSupply() public view returns (uint256 supply);
26   function balanceOf(address _owner) public view returns (uint256 balance);
27   function transfer(address _to, uint256 _value) public returns (bool success);
28   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
29   function approve(address _spender, uint256 _value) public returns (bool success);
30   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
31   event Transfer(address indexed _from, address indexed _to, uint256 _value);
32   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 }
34 
35  /*
36   * @title: Dex
37   * @author Dexhigh Services Pvt. Ltd (https://www.dexhigh.com)
38   * @dev The Dex Contract implement all the required functionalities viz order sharing, local exchange etc.
39   */
40 contract DEX is SafeMath
41 {
42     uint32 public lastTransferId = 1;
43 
44     // Events
45     event NewDeposit(uint32 indexed exId, uint32  prCode, uint32 indexed accountId, uint128 amount, uint64 timestamp, uint32 lastTransferId);
46     event NewWithdraw(uint32 indexed exId, uint32  prCode, uint32 indexed accountId, uint128 amount, uint64 timestamp, uint32 lastTransferId);
47     uint32 public lastNewOrderId = 1;
48     event NewOrder(uint32 indexed prTrade, uint32 indexed prBase, uint32 indexed accountId, uint32 id, bool isSell, uint80 price, uint104 qty, uint32 lastNewOrderId);
49     event NewCancel(uint32 indexed prTrade, uint32 indexed prBase, uint32 indexed accountId, uint32 id, bool isSell, uint80 price, uint104 qty, uint32 lastNewOrderId);
50     event NewBestBidAsk(uint32 indexed prTrade, uint32 indexed prBase, bool isBid, uint80 price);
51     uint32 public lastTradeId = 1;
52     event NewTrade(uint32 indexed prTrade, uint32 prBase, uint32 indexed bidId, uint32 indexed askId, uint32 accountIdBid, uint32 accountIdAsk, bool isSell, uint80 price, uint104 qty, uint32 lastTradeId, uint64 timestamp);
53 
54     // basePrice, All the prices will be "based" by basePrice
55     uint256 public constant basePrice = 10000000000;
56     uint80 public constant maxPrice = 10000000000000000000001;
57     uint104 public constant maxQty = 1000000000000000000000000000001;
58     uint128 public constant maxBalance = 1000000000000000000000000000000000001;
59     bool public isContractUse = true;
60 
61     //No Args constructor will add msg.sender as owner/operator
62     // Add ETH product
63     constructor() public
64     {
65         owner = msg.sender;
66         operator = owner;
67         AddOwner(msg.sender);
68         AddProduct(18, 0x0);
69         //lastProductId = 1; // productId == 1 -> ETH 0x0
70     }
71 
72     address public owner;
73     // Functions with this modifier can only be executed by the owner
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     address public operator;
80     // Functions with this modifier can only be executed by the operator
81     modifier onlyOperator() {
82         require(msg.sender == operator);
83         _;
84     }
85     function transferOperator(address _operator) onlyOwner public {
86         operator = _operator;
87     }
88 
89     // Functions with this modifier can only be executed by the owner of each exchange
90     modifier onlyExOwner()  {
91         require(owner_id[msg.sender] != 0);
92         _;
93     }
94 
95     // Functions with this modifier can only be executed when this contract is not abandoned
96     modifier onlyContractUse {
97         require(isContractUse == true);
98         _;
99     }
100 
101     uint32 public lastOwnerId;
102     mapping (uint32 => address) id_owner;
103     mapping (address => uint32) owner_id;
104     mapping (uint32 => uint8) ownerId_takerFeeRateLocal;
105     mapping (uint32 => uint32) ownerId_accountId;
106 
107     //Delete the owner of exchange
108     function DeleteOwner(uint32 exId) onlyOperator public
109     {
110         require(lastOwnerId >= exId && exId > 0);
111         owner_id[id_owner[exId]] = 0;
112     }
113 
114     //Add Owner of exchange
115     function AddOwner(address newOwner) onlyOperator public
116     {
117         require(owner_id[newOwner] == 0);
118 
119         owner_id[newOwner] = ++lastOwnerId;
120         id_owner[lastOwnerId] = newOwner;
121 
122         ownerId_accountId[lastOwnerId] = FindOrAddAccount(newOwner);
123     }
124     //Get exchange owner list and id
125     function GetOwnerList() view public returns (address[] owners, uint32[] ownerIds)
126     {
127         owners = new address[](lastOwnerId);
128         ownerIds = new uint32[](lastOwnerId);
129 
130         for (uint32 i = 1; i <= lastOwnerId; i++)
131         {
132             owners[i - 1] = id_owner[i];
133             ownerIds[i - 1] = i;
134         }
135     }
136     //Set local exchange fee
137     function setTakerFeeRateLocal(uint8 _takerFeeRate) public
138     {
139         require (_takerFeeRate <= 100);// takerFeeRate cannot be more than 1%
140         uint32 ownerId = owner_id[msg.sender];
141         require(ownerId != 0);
142         ownerId_takerFeeRateLocal[ownerId] = _takerFeeRate;//bp
143     }
144     // Get fee Rate for an exchange with owner id == ownerId
145     function getTakerFeeRateLocal(uint32 ownerId) public view returns (uint8)
146     {
147         return ownerId_takerFeeRateLocal[ownerId];//bp
148     }
149 
150     //Air Drop events
151     function airDrop(uint32 exId, uint32 prCode, uint32[] accountIds, uint104[] qtys) onlyExOwner public
152     {
153         uint32 accountId = FindOrRevertAccount();
154         require(accountId_freeze[accountId] == false);
155         uint256 n = accountIds.length;
156         require(n == qtys.length);
157 
158         uint128 sum = 0;
159         for (uint32 i = 0; i < n; i++)
160         {
161             sum += qtys[i];
162         }
163 
164         exId_prCode_AccountId_Balance[exId][prCode][accountId].available = Sub(exId_prCode_AccountId_Balance[exId][prCode][accountId].available, sum);
165 
166         for (i = 0; i < n; i++)
167         {
168             exId_prCode_AccountId_Balance[exId][prCode][accountIds[i]].available += qtys[i];
169             // exId_prCode_AccountId_Balance[exId][prCode][accountIds[i]].available >> qtys[i]
170             // 2^128 >> 2^104 -> minimum 2^24 times of airdrop need for overflow (hard to imagine)
171             // because prCode_AccountId_Balance[prCode][accountIds[i]].available restircted by maxBalance in deposit function
172         }
173     }
174 
175     //information of product
176     struct ProductInfo
177     {
178         uint256 divider;
179         bool isTradeBid;
180         bool isTradeAsk;
181         bool isDeposit;
182         bool isWithdraw;
183         uint32 ownerId;
184         uint104 minQty;
185     }
186 
187     uint32 public lastProductId;
188     uint256 public newProductFee;
189     mapping (uint32 => address) prCode_product;
190     mapping (address => uint32) product_prCode;
191     mapping (uint32 => ProductInfo) prCode_productInfo;
192 
193     // Add product by exchange owner
194     function AddProduct(uint256 decimals, address product) payable onlyExOwner public
195     {
196         require(msg.value >= newProductFee || msg.sender == operator);
197         require(product_prCode[product] == 0);
198         require(decimals <= 18);
199 
200         product_prCode[product] = ++lastProductId;
201         prCode_product[lastProductId] = product;
202 
203         ProductInfo memory productInfo;
204         productInfo.divider = 10 ** decimals; // max = 10 ^ 18 because of require(decimals <= 18);
205         productInfo.ownerId = owner_id[msg.sender];
206         prCode_productInfo[lastProductId] = productInfo;
207 
208         exId_prCode_AccountId_Balance[1][1][ownerId_accountId[1]].available += uint128(msg.value); //eth transfer < 2^128
209     }
210     // Set Product Information
211     function SetProductInfo(uint32 prCode, bool isTradeBid, bool isTradeAsk, bool isDeposit, bool isWithdraw, uint104 _minQty, uint32 exId) public
212     {
213         ProductInfo storage prInfo = prCode_productInfo[prCode];
214 
215         require(msg.sender == operator || owner_id[msg.sender] == prInfo.ownerId );
216 
217         prInfo.isTradeBid = isTradeBid;
218         prInfo.isTradeAsk = isTradeAsk;
219         prInfo.isDeposit = isDeposit;
220         prInfo.isWithdraw = isWithdraw;
221         prInfo.minQty = _minQty;
222         prInfo.ownerId = exId;
223     }
224     // Set product listing fee
225     function SetProductFee(uint256 productFee) onlyOperator public
226     {
227         newProductFee = productFee;
228     }
229     // Get product address and id
230     function GetProductList() view public returns (address[] products, uint32[] productIds)
231     {
232         products = new address[](lastProductId);
233         productIds = new uint32[](lastProductId);
234 
235         for (uint32 i = 1; i <= lastProductId; i++)
236         {
237             products[i - 1] = prCode_product[i];
238             productIds[i - 1] = i;
239         }
240     }
241     // Get infromation of product
242     function GetProductInfo(address product) view public returns (uint32 prCode, uint256 divider, bool isTradeBid, bool isTradeAsk, bool isDeposit, bool isWithdraw, uint32 ownerId, uint104 minQty)
243     {
244         prCode = product_prCode[product];
245 
246         divider = prCode_productInfo[prCode].divider;
247         isTradeBid = prCode_productInfo[prCode].isTradeBid;
248         isTradeAsk = prCode_productInfo[prCode].isTradeAsk;
249         isDeposit = prCode_productInfo[prCode].isDeposit;
250         isWithdraw = prCode_productInfo[prCode].isWithdraw;
251         ownerId = prCode_productInfo[prCode].ownerId;
252         minQty = prCode_productInfo[prCode].minQty;
253     }
254 
255     uint32 public lastAcccountId;
256     mapping (uint32 => uint8) id_announceLV;
257     //Each announceLV open information as
258     //0: None, 1: Trade, 2:Balance, 3:DepositWithdrawal, 4:OpenOrder
259     mapping (uint32 => address) id_account;
260     mapping (uint32 => bool) accountId_freeze;
261     mapping (address => uint32) account_id;
262     // Find or add account
263     function FindOrAddAccount(address findAddress) private returns (uint32)
264     {
265         if (account_id[findAddress] == 0)
266         {
267             account_id[findAddress] = ++lastAcccountId;
268             id_account[lastAcccountId] = findAddress;
269         }
270         return account_id[findAddress];
271     }
272     // Find or revert account
273     function FindOrRevertAccount() private view returns (uint32)
274     {
275         uint32 accountId = account_id[msg.sender];
276         require(accountId != 0);
277         return accountId;
278     }
279     // Get account id of msg sender
280     function GetMyAccountId() view public returns (uint32)
281     {
282         return account_id[msg.sender];
283     }
284     // Get account id of any users
285     function GetAccountId(address account) view public returns (uint32)
286     {
287         return account_id[account];
288     }
289     // Get account announcement level
290     function GetMyAnnounceLV() view public returns (uint32)
291     {
292         return id_announceLV[account_id[msg.sender]];
293     }
294     // Set account announce level
295     function ChangeAnnounceLV(uint8 announceLV) public
296     {
297         id_announceLV[FindOrRevertAccount()] = announceLV;
298     }
299     // Freeze or unfreez of account
300     function SetFreezeByAddress(bool isFreeze, address account) onlyOperator public
301     {
302         uint32 accountId = account_id[account];
303 
304         if (accountId != 0)
305         {
306             accountId_freeze[accountId] = isFreeze;
307         }
308     }
309 
310     // reserved: Balance held up in orderBook
311     // available: Balance available for trade
312     struct Balance
313     {
314         uint128 reserved;
315         uint128 available;
316     }
317 
318     struct ListItem
319     {
320         uint32 prev;
321         uint32 next;
322     }
323 
324     struct OrderLink
325     {
326         uint32 firstId;
327         uint32 lastId;
328         uint80 nextPrice;
329         uint80 prevPrice;
330         mapping (uint32 => ListItem) id_orderList;
331     }
332 
333     struct Order
334     {
335         uint32 exId;
336         uint32 accountId;
337         uint32 prTrade;
338         uint32 prBase;
339         uint104 qty;
340         uint80 price;
341         bool isSell;
342     }
343 
344     uint32 public lastOrderId;
345     mapping (uint32 => Order) id_Order;
346 
347     //orderbook information
348     struct OrderBook
349     {
350         uint8 tickSize;
351 
352         uint80 bestBidPrice;
353         uint80 bestAskPrice;
354 
355         mapping (uint80 => OrderLink) bidPrice_Order;
356         mapping (uint80 => OrderLink) askPrice_Order;
357     }
358     mapping (uint32 => mapping (uint32 => OrderBook)) basePID_tradePID_orderBook;
359     function SetOrderBookTickSize(uint32 prTrade, uint32 prBase, uint8 _tickSize) onlyOperator public
360     {
361         basePID_tradePID_orderBook[prBase][prTrade].tickSize = _tickSize;
362     }
363 
364     mapping (uint32 => mapping (uint32 => mapping (uint32 => Balance))) exId_prCode_AccountId_Balance;
365 
366     // open order list
367     struct OpenOrder
368     {
369         uint32 startId;
370         mapping(uint32 => ListItem) id_orderList;
371     }
372     mapping(uint32 => OpenOrder) accountId_OpenOrder;
373     function AddOpenOrder(uint32 accountId, uint32 orderId) private
374     {
375         OpenOrder storage openOrder = accountId_OpenOrder[accountId];
376 
377         if (openOrder.startId != 0)
378         {
379             openOrder.id_orderList[openOrder.startId].prev = orderId;
380             openOrder.id_orderList[orderId].next = openOrder.startId;
381         }
382         openOrder.startId = orderId;
383     }
384     function RemoveOpenOrder(uint32 accountId, uint32 orderId) private
385     {
386         OpenOrder storage openOrder = accountId_OpenOrder[accountId];
387 
388         uint32 nextId = openOrder.id_orderList[orderId].next;
389         uint32 prevId = openOrder.id_orderList[orderId].prev;
390 
391         if (nextId != 0)
392         {
393             openOrder.id_orderList[nextId].prev = prevId;
394         }
395 
396         if (prevId != 0)
397         {
398             openOrder.id_orderList[prevId].next = nextId;
399         }
400 
401         if (openOrder.startId == orderId)
402         {
403             openOrder.startId = nextId;
404         }
405     }
406 
407     //withdrawal and deposit record (DW records)
408     struct DWrecord
409     {
410         uint32 prCode;
411         bool isDeposit;
412         uint128 qty;
413         uint64 timestamp;
414     }
415 
416     struct DWrecords
417     {
418         uint32 N;
419         mapping (uint32 => DWrecord) N_DWrecord;
420     }
421     mapping (uint32 => mapping (uint32 => DWrecords)) exId_AccountId_DWrecords;
422 
423     //record deposit and withdrawal
424     function RecordDW(uint32 exId, uint32 accountId, uint32 prCode, bool isDeposit, uint128 qty) private
425     {
426         DWrecord memory dW;
427         dW.isDeposit = isDeposit;
428         dW.prCode = prCode;
429         dW.qty = qty;
430         dW.timestamp = uint64(now);
431 
432         exId_AccountId_DWrecords[exId][accountId].N_DWrecord[++exId_AccountId_DWrecords[exId][accountId].N] = dW;
433 
434         if (isDeposit == true)
435             emit NewDeposit(exId, prCode, accountId, qty, dW.timestamp, lastTransferId++);
436         else
437             emit NewWithdraw(exId, prCode, accountId, qty, dW.timestamp, lastTransferId++);
438     }
439     // returns 'N', DW  records with account id, accountId, for exchange id, exId
440     function GetDWrecords(uint32 N, uint32 exId, uint32 accountId) view public returns (uint32[] prCode, bool[] isDeposit, uint128[] qty, uint64[] timestamp)
441     {
442         checkAnnounceLV(accountId, 3);
443 
444         DWrecords storage dWrecords = exId_AccountId_DWrecords[exId][accountId];
445         uint32 n = dWrecords.N;
446 
447         if (n > N)
448             n = N;
449 
450         prCode = new uint32[](n);
451         isDeposit = new bool[](n);
452         qty = new uint128[](n);
453         timestamp = new uint64[](n);
454 
455         for (uint32 i = dWrecords.N; i > dWrecords.N - n; i--)
456         {
457             N = dWrecords.N - i;
458             prCode[N] = dWrecords.N_DWrecord[i].prCode;
459             isDeposit[N] = dWrecords.N_DWrecord[i].isDeposit;
460             qty[N] = dWrecords.N_DWrecord[i].qty;
461             timestamp[N] = dWrecords.N_DWrecord[i].timestamp;
462         }
463     }
464 
465     //Deposit ETH to exchange
466     function depositETH(uint32 exId) payable onlyContractUse public
467     {
468         require(exId <= lastOwnerId);
469         uint32 accountId = FindOrAddAccount(msg.sender);
470         exId_prCode_AccountId_Balance[exId][1][accountId].available = Add(exId_prCode_AccountId_Balance[exId][1][accountId].available, uint128(msg.value));
471         RecordDW(exId, accountId, 1, true, uint104(msg.value));
472     }
473     // Withdraw ETH from exchange
474     function withdrawETH(uint32 exId, uint104 amount) public
475     {
476         uint32 accountId = FindOrRevertAccount();
477         require(accountId_freeze[accountId] == false);
478         exId_prCode_AccountId_Balance[exId][1][accountId].available = Sub(exId_prCode_AccountId_Balance[exId][1][accountId].available, amount);
479         require(msg.sender.send(amount));
480         RecordDW(exId, accountId, 1, false,  amount);
481     }
482     // Deposit/Withdraw, ERC20's to exchange
483     function depositWithdrawToken(uint32 exId, uint128 amount, bool isDeposit, address prAddress) public
484     {
485         uint32 prCode = product_prCode[prAddress];
486         require(amount < maxBalance && prCode != 0);
487         uint32 accountId = FindOrAddAccount(msg.sender);
488         require(accountId_freeze[accountId] == false);
489 
490         if (isDeposit == true)
491         {
492             require(prCode_productInfo[prCode].isDeposit == true && isContractUse == true && exId <= lastOwnerId);
493             require(Token(prAddress).transferFrom(msg.sender, this, amount));
494             exId_prCode_AccountId_Balance[exId][prCode][accountId].available = Add(exId_prCode_AccountId_Balance[exId][prCode][accountId].available, amount);
495             require (exId_prCode_AccountId_Balance[exId][prCode][accountId].available < maxBalance);
496         }
497         else
498         {
499             require(prCode_productInfo[prCode].isWithdraw == true);
500             exId_prCode_AccountId_Balance[exId][prCode][accountId].available = Sub(exId_prCode_AccountId_Balance[exId][prCode][accountId].available, amount);
501             require(Token(prAddress).transfer(msg.sender, amount));
502         }
503         RecordDW(exId, accountId, prCode, isDeposit, amount);
504     }
505 
506     // This function will be never used in normal situations.
507     // This function is only prepared for emergency case such as smart contract hacking Vulnerability or smart contract abolishment
508     // Withdrawn fund by this function cannot belong to any exchange operators or owners.
509     // Withdrawn fund should be distributed to individual accounts having original ownership of withdrawn fund.
510     // After using this function, this contract cannot get any deposit or trade.
511     // After using this function, this contract will be abolished.
512     function emergencyWithdrawal(uint32 prCode, uint256 amount) onlyOwner public
513     {
514         isContractUse = false;//This cannot be return. After activating this, this contract cannot support any deposit or trade function.
515         if (prCode == 1)
516             require(msg.sender.send(amount));
517         else
518             Token(prCode_product[prCode]).transfer(msg.sender, amount);
519     }
520 
521     // Find tick size of each price
522     function GetNextTick(bool isAsk, uint80 price, uint8 n) public pure returns (uint80)
523     {
524         if (price > 0)
525         {
526             uint80 tick = GetTick(price, n);
527 
528             if (isAsk == true)
529                 return (((price - 1) / tick) + 1) * tick;
530             else
531                 return (price / tick) * tick;
532         }
533         else
534         {
535             return price;
536         }
537     }
538 
539     function GetTick(uint80 price, uint8 n)  public pure returns  (uint80)
540     {
541         if (n < 1)
542             n = 1;
543 
544         uint80 x = 1;
545 
546         for (uint8 i=1; i <= n / 2; i++)
547         {
548             x *= 10;
549         }
550 
551         if (price < 10 * x)
552             return 1;
553         else
554         {
555             uint80 tick = 10000;
556 
557             uint80 priceTenPercent = price / 10 / x;
558 
559             while (priceTenPercent > tick)
560             {
561                 tick *= 10;
562             }
563 
564             while (priceTenPercent < tick)
565             {
566                 tick /= 10;
567             }
568 
569             if (n % 2 == 1)
570             {
571                 if (price >= 50 * tick * x)
572                 {
573                     tick *= 5;
574                 }
575             }
576             else
577             {
578                 if (price < 50 * tick * x)
579                 {
580                     tick *= 5;
581                 }
582                 else
583                 {
584                     tick *= 10;
585                 }
586 
587             }
588 
589             return tick;
590         }
591     }
592     // New limit order
593     function LimitOrder(uint32 exId, uint32 prTrade, uint32 prBase, bool isSell, uint80 price, uint104 qty) public onlyContractUse  returns  (uint32)
594     {
595         uint32 accountId = FindOrRevertAccount();
596         require(accountId_freeze[accountId] == false);
597         uint80 lastBestPrice;
598         OrderBook storage orderBook = basePID_tradePID_orderBook[prBase][prTrade];
599         require(price != 0 && price <= maxPrice && qty <= maxQty &&
600             ((isSell == false && prCode_productInfo[prTrade].isTradeBid == true && prCode_productInfo[prBase].isTradeAsk == true)
601             || (isSell == true && prCode_productInfo[prTrade].isTradeAsk == true && prCode_productInfo[prBase].isTradeBid == true))
602             && prCode_productInfo[prTrade].minQty <= qty);
603 
604         if (isSell == true)
605         {
606             price = GetNextTick(true, price, orderBook.tickSize);
607             lastBestPrice = orderBook.bestAskPrice;
608         }
609         else
610         {
611             price = GetNextTick(false, price, orderBook.tickSize);
612             lastBestPrice = orderBook.bestBidPrice;
613         }
614 
615         Order memory order;
616         order.exId = exId;
617         order.isSell = isSell;
618         order.prTrade = prTrade;
619         order.prBase = prBase;
620         order.accountId = accountId;
621         order.price = price;
622         order.qty = qty;
623 
624         require (IsPossibleLimit(order));
625 
626         emit NewOrder(order.prTrade, order.prBase, order.accountId, ++lastOrderId, order.isSell, order.price, order.qty, lastNewOrderId++);
627 
628         BalanceUpdateByLimitAfterTrade(order, qty, matchOrder(orderBook, order, lastOrderId));
629 
630         if (order.qty != 0)
631         {
632             uint80 priceNext;
633             uint80 price0;
634 
635             if (isSell == true)
636             {
637                 price0 = orderBook.bestAskPrice;
638                 if (price0 == 0)
639                 {
640                     orderBook.askPrice_Order[price].prevPrice = 0;
641                     orderBook.askPrice_Order[price].nextPrice = 0;
642                     orderBook.bestAskPrice = price;
643                 }
644                 else if(price < price0)
645                 {
646                     orderBook.askPrice_Order[price0].prevPrice = price;
647                     orderBook.askPrice_Order[price].prevPrice = 0;
648                     orderBook.askPrice_Order[price].nextPrice = price0;
649                     orderBook.bestAskPrice = price;
650                 }
651                 else if (orderBook.askPrice_Order[price].firstId == 0)
652                 {
653                     priceNext = price0;
654 
655                     while (priceNext != 0 && priceNext < price)
656                     {
657                         price0 = priceNext;
658                         priceNext = orderBook.askPrice_Order[price0].nextPrice;
659                     }
660 
661                     orderBook.askPrice_Order[price0].nextPrice = price;
662                     orderBook.askPrice_Order[price].prevPrice = price0;
663                     orderBook.askPrice_Order[price].nextPrice = priceNext;
664                     if (priceNext != 0)
665                     {
666                         orderBook.askPrice_Order[priceNext].prevPrice = price;
667                     }
668                 }
669 
670                 OrderLink storage orderLink = orderBook.askPrice_Order[price];
671             }
672             else
673             {
674                 price0 = orderBook.bestBidPrice;
675                 if (price0 == 0)
676                 {
677                     orderBook.bidPrice_Order[price].prevPrice = 0;
678                     orderBook.bidPrice_Order[price].nextPrice = 0;
679                     orderBook.bestBidPrice = price;
680                 }
681                 else if (price > price0)
682                 {
683                     orderBook.bidPrice_Order[price0].prevPrice = price;
684                     orderBook.bidPrice_Order[price].prevPrice = 0;
685                     orderBook.bidPrice_Order[price].nextPrice = price0;
686                     orderBook.bestBidPrice = price;
687                 }
688                 else if (orderBook.bidPrice_Order[price].firstId == 0)
689                 {
690                     priceNext = price0;
691 
692                     while (priceNext != 0 && priceNext > price)
693                     {
694                         price0 = priceNext;
695                         priceNext = orderBook.bidPrice_Order[price0].nextPrice;
696                     }
697 
698                     orderBook.bidPrice_Order[price0].nextPrice = price;
699                     orderBook.bidPrice_Order[price].prevPrice = price0;
700                     orderBook.bidPrice_Order[price].nextPrice = priceNext;
701                     if (priceNext != 0)
702                     {
703                         orderBook.bidPrice_Order[priceNext].prevPrice = price;
704                     }
705                 }
706 
707                 orderLink = orderBook.bidPrice_Order[price];
708             }
709 
710             if (lastOrderId != 0)
711             {
712                 orderLink.id_orderList[lastOrderId].prev = orderLink.lastId;
713                 if (orderLink.firstId != 0)
714                 {
715                     orderLink.id_orderList[orderLink.lastId].next = lastOrderId;
716                 }
717                 else
718                 {
719                     orderLink.id_orderList[lastOrderId].next = 0;
720                     orderLink.firstId = lastOrderId;
721                 }
722                 orderLink.lastId = lastOrderId;
723             }
724 
725             AddOpenOrder(accountId, lastOrderId);
726             id_Order[lastOrderId] = order;
727         }
728 
729         if (isSell == true && lastBestPrice != orderBook.bestAskPrice)
730         {
731             emit NewBestBidAsk(prTrade, prBase, isSell, orderBook.bestAskPrice);
732         }
733         if (isSell == false && lastBestPrice != orderBook.bestBidPrice)
734         {
735             emit NewBestBidAsk(prTrade, prBase, isSell, orderBook.bestBidPrice);
736         }
737 
738         return lastOrderId;
739     }
740 
741     function BalanceUpdateByLimitAfterTrade(Order order, uint104 qty, uint104 tradedQty) private
742     {
743         uint32 exId = order.exId;
744         uint32 accountId = order.accountId;
745         uint32 prTrade = order.prTrade;
746         uint32 prBase = order.prBase;
747         uint80 price = order.price;
748         uint104 orderQty = order.qty;
749 
750         if (order.isSell)
751         {
752             Balance storage balance = exId_prCode_AccountId_Balance[exId][prTrade][accountId];
753             balance.available = Sub(balance.available, qty);
754 
755             if (orderQty != 0)
756                 balance.reserved = Add(balance.reserved, orderQty);
757         }
758         else
759         {
760             balance = exId_prCode_AccountId_Balance[exId][prBase][accountId];
761             if (orderQty != 0)
762             {
763                 // prCode_productInfo[prBase].divider * qty * price < 2^60 * 2^80 * 2^104 < 2^256
764                 
765                 uint256 a = prCode_productInfo[prBase].divider * orderQty * price;
766                 uint256 b = basePrice * prCode_productInfo[prTrade].divider;
767                 uint256 temp = a / b;
768                 
769                 require (temp < maxQty); // temp < maxQty < 2^104
770                 require (temp * b == a);
771                 
772                 balance.available = Sub(balance.available, tradedQty + uint104(temp));
773                 balance.reserved = Add(balance.reserved, uint104(temp));
774             }
775             else
776             {
777                 balance.available = Sub(balance.available, tradedQty);
778             }
779             tradedQty = qty - orderQty;
780 
781             prBase = prTrade;
782         }
783         if (tradedQty != 0)
784         {
785             uint104 takeFeeLocal = tradedQty * ownerId_takerFeeRateLocal[exId] / 10000;
786             exId_prCode_AccountId_Balance[exId][prBase][accountId].available += tradedQty - takeFeeLocal;
787             exId_prCode_AccountId_Balance[exId][prBase][ownerId_accountId[exId]].available += takeFeeLocal;
788         }
789     }
790 
791     function IsPossibleLimit(Order memory order) private view returns (bool)
792     {
793         if (order.isSell)
794         {
795             if (exId_prCode_AccountId_Balance[order.exId][order.prTrade][order.accountId].available >= order.qty)
796                 return true;
797             else
798                 return false;
799         }
800         else
801         {
802             if (exId_prCode_AccountId_Balance[order.exId][order.prBase][order.accountId].available >= prCode_productInfo[order.prBase].divider * order.qty * order.price / basePrice / prCode_productInfo[order.prTrade].divider)
803                 return true;
804             else
805                 return false;
806         }
807     }
808     // Heart of DexHI's onchain order matching algorithm
809     function matchOrder(OrderBook storage ob, Order memory order, uint32 id) private returns (uint104)
810     {
811         uint32 prTrade = order.prTrade;
812         uint32 prBase = order.prBase;
813         uint80 tradePrice;
814 
815         if (order.isSell == true)
816             tradePrice = ob.bestBidPrice;
817         else
818             tradePrice = ob.bestAskPrice;
819 
820         bool isBestPriceUpdate = false;
821 
822         uint104 qtyBase = 0;
823         uint104 tradeAmount;
824 
825         while (tradePrice != 0 && order.qty > 0 && ((order.isSell && order.price <= tradePrice) || (!order.isSell && order.price >= tradePrice)))
826         {
827             if (order.isSell == true)
828                 OrderLink storage orderLink = ob.bidPrice_Order[tradePrice];
829             else
830                 orderLink = ob.askPrice_Order[tradePrice];
831 
832             uint32 orderId = orderLink.firstId;
833 
834             while (orderLink.firstId != 0 && orderId != 0 && order.qty != 0)
835             {
836                 Order storage matchingOrder = id_Order[orderId];
837                 if (matchingOrder.qty >= order.qty)
838                 {
839                     tradeAmount = order.qty;
840                     matchingOrder.qty -= order.qty; //matchingOrder.qty cannot be negative by (matchingOrder.qty >= order.qty
841                     order.qty = 0;
842                 }
843                 else
844                 {
845                     tradeAmount = matchingOrder.qty;
846                     order.qty -= matchingOrder.qty;
847                     matchingOrder.qty = 0;
848                 }
849 
850                 qtyBase += BalanceUpdateByTradeCp(order, matchingOrder, tradeAmount);
851                 //return value of BalanceUpdateByTradeCp < maxqty < 2^100 so qtyBase < 2 * maxqty < 2 * 101 by below require(qtyBase < maxQty) -> qtyBase cannot be overflow
852                 require(qtyBase < maxQty);
853 
854                 uint32 orderAccountID = order.accountId;
855 
856                 if (order.isSell == true)
857                     emit NewTrade(prTrade, prBase, orderId, id, matchingOrder.accountId, orderAccountID, true, tradePrice,  tradeAmount, lastTradeId++, uint64(now));
858                 else
859                     emit NewTrade(prTrade, prBase, id, orderId, orderAccountID, matchingOrder.accountId, false, tradePrice,  tradeAmount, lastTradeId++, uint64(now));
860 
861                 if (matchingOrder.qty != 0)
862                 {
863                     break;
864                 }
865                 else
866                 {
867                     if (RemoveOrder(prTrade, prBase, matchingOrder.isSell, tradePrice, orderId) == true)
868                     {
869                         RemoveOpenOrder(matchingOrder.accountId, orderId);
870                     }
871                     orderId = orderLink.firstId;
872                 }
873             }
874 
875             if (orderLink.firstId == 0)
876             {
877                 tradePrice = orderLink.nextPrice;
878                 isBestPriceUpdate = true;
879             }
880         }
881 
882         if (isBestPriceUpdate == true)
883         {
884             if (order.isSell)
885             {
886                 ob.bestBidPrice = tradePrice;
887             }
888             else
889             {
890                 ob.bestAskPrice = tradePrice;
891             }
892 
893             emit NewBestBidAsk(prTrade, prBase, !order.isSell, tradePrice);
894         }
895 
896         return qtyBase;
897     }
898 
899     function BalanceUpdateByTradeCp(Order order, Order matchingOrder, uint104 tradeAmount) private returns (uint104)
900     {
901         uint32 accountId = matchingOrder.accountId;
902         uint32 prTrade = order.prTrade;
903         uint32 prBase = order.prBase;
904         require (tradeAmount < maxQty);
905         // qtyBase < 10 ^ 18 < 2^ 60 & tradedAmount < 2^104 & matching orderprice < 2^80 ->  prCode_productInfo[prBase].divider * tradeAmount * matchingOrder.price < 2^256
906         // so, below qtyBase cannot be overflow
907         uint256 qtyBase = prCode_productInfo[prBase].divider * tradeAmount * matchingOrder.price / basePrice / prCode_productInfo[prTrade].divider;
908         require (qtyBase < maxQty);
909 
910         Balance storage balanceTrade = exId_prCode_AccountId_Balance[matchingOrder.exId][prTrade][accountId];
911         Balance storage balanceBase = exId_prCode_AccountId_Balance[matchingOrder.exId][prBase][accountId];
912 
913         if (order.isSell == true)
914         {
915             balanceTrade.available = SafeMath.Add(balanceTrade.available, tradeAmount);
916             balanceBase.reserved = SafeMath.Sub(balanceBase.reserved, uint104(qtyBase));
917         }
918         else
919         {
920             balanceTrade.reserved = SafeMath.Sub(balanceTrade.reserved, tradeAmount);
921             balanceBase.available = SafeMath.Add(balanceBase.available, uint104(qtyBase));
922         }
923 
924         return uint104(qtyBase); // return value < maxQty = 1000000000000000000000000000001 < 2^100 by require (qtyBase < maxQty);
925     }
926     // Internal functions to remove order
927     function RemoveOrder(uint32 prTrade, uint32 prBase, bool isSell, uint80 price, uint32 id) private returns (bool)
928     {
929         OrderBook storage ob = basePID_tradePID_orderBook[prBase][prTrade];
930 
931         if (isSell == false)
932         {
933             OrderLink storage orderLink = ob.bidPrice_Order[price];
934         }
935         else
936         {
937             orderLink = ob.askPrice_Order[price];
938         }
939 
940         if (id != 0)
941         {
942             ListItem memory removeItem = orderLink.id_orderList[id];
943             if (removeItem.next != 0)
944             {
945                 orderLink.id_orderList[removeItem.next].prev = removeItem.prev;
946             }
947 
948             if (removeItem.prev != 0)
949             {
950                 orderLink.id_orderList[removeItem.prev].next = removeItem.next;
951             }
952 
953             if (id == orderLink.lastId)
954             {
955                 orderLink.lastId = removeItem.prev;
956             }
957 
958             if (id == orderLink.firstId)
959             {
960                 orderLink.firstId = removeItem.next;
961             }
962 
963             delete orderLink.id_orderList[id];
964 
965             if (orderLink.firstId == 0)
966             {
967                 if (orderLink.nextPrice != 0)
968                 {
969                     if (isSell == true)
970                         OrderLink storage replaceLink = ob.askPrice_Order[orderLink.nextPrice];
971                     else
972                         replaceLink = ob.bidPrice_Order[orderLink.nextPrice];
973 
974                     replaceLink.prevPrice = orderLink.prevPrice;
975                 }
976                 if (orderLink.prevPrice != 0)
977                 {
978                     if (isSell == true)
979                         replaceLink = ob.askPrice_Order[orderLink.prevPrice];
980                     else
981                         replaceLink = ob.bidPrice_Order[orderLink.prevPrice];
982 
983                     replaceLink.nextPrice = orderLink.nextPrice;
984                 }
985 
986                 if (price == ob.bestAskPrice)
987                 {
988                     ob.bestAskPrice = orderLink.nextPrice;
989                 }
990                 if (price == ob.bestBidPrice)
991                 {
992                     ob.bestBidPrice = orderLink.nextPrice;
993                 }
994             }
995             return true;
996         }
997         else
998         {
999             return false;
1000         }
1001     }
1002     // Cancel orders, keep eye on max block gas Fee
1003     function cancelOrders(uint32[] id) public ////uint32 exId
1004     {
1005         for (uint32 i = 0; i < id.length; i++)
1006         {
1007             cancelOrder(id[i]);
1008         }
1009     }
1010     //  Cancel order
1011     function cancelOrder(uint32 id) public returns (bool)
1012     {
1013         Order memory order = id_Order[id];
1014         uint32 accountId = account_id[msg.sender];
1015         require(order.accountId == accountId);
1016 
1017         uint32 prTrade = order.prTrade;
1018         uint32 prBase = order.prBase;
1019         bool isSell = order.isSell;
1020         //uint80 price = order.price;
1021         //uint104 qty = order.qty;
1022 
1023         if (RemoveOrder(prTrade, prBase, isSell, order.price, id) == false)
1024             return false;
1025         else
1026         {
1027             RemoveOpenOrder(accountId, id);
1028         }
1029 
1030         if (isSell)
1031         {
1032             Balance storage balance = exId_prCode_AccountId_Balance[order.exId][prTrade][accountId];
1033             balance.available = SafeMath.Add(balance.available, order.qty);
1034             balance.reserved = SafeMath.Sub(balance.reserved, order.qty);
1035         }
1036         else
1037         {
1038             balance = exId_prCode_AccountId_Balance[order.exId][prBase][accountId];
1039             // prCode_productInfo[prBase].divider * qty * price < 2^60 * 2^80 * 2^104 < 2^256
1040             uint256 a = prCode_productInfo[prBase].divider * order.qty * order.price;
1041             uint256 b = basePrice * prCode_productInfo[prTrade].divider;
1042             uint256 temp = a / b;
1043             require (temp < maxQty); // temp < maxQty < 2^104 -> temp cannot be overflow
1044             require (temp * b == a);
1045             balance.available = SafeMath.Add(balance.available, uint104(temp));
1046             balance.reserved = SafeMath.Sub(balance.reserved, uint104(temp));
1047         }
1048 
1049         emit NewCancel(prTrade, prBase, accountId, id, isSell, order.price, order.qty, lastNewOrderId++);
1050         return true;
1051     }
1052     function checkAnnounceLV(uint32 accountId, uint8 LV) private view returns (bool)
1053     {
1054         require(accountId == account_id[msg.sender] || id_announceLV[accountId] >= LV || msg.sender == operator || owner_id[msg.sender] != 0);
1055     }
1056     // Get balance by acount id
1057     function getBalance(uint32 exId, uint32[] prCode, uint32 accountId) view public returns (uint128[] available, uint128[] reserved)
1058     {
1059         if (accountId == 0)
1060             accountId = account_id[msg.sender];
1061         checkAnnounceLV(accountId, 2);
1062 
1063         uint256 n = prCode.length;
1064         available = new uint128[](n);
1065         reserved = new uint128[](n);
1066 
1067         for (uint32 i = 0; i < n; i++)
1068         {
1069             available[i] = exId_prCode_AccountId_Balance[exId][prCode[i]][accountId].available;
1070             reserved[i] = exId_prCode_AccountId_Balance[exId][prCode[i]][accountId].reserved;
1071         }
1072     }
1073     // Get balance by product
1074     function getBalanceByProduct(uint32 exId, uint32 prCode, uint128 minQty) view public returns (uint32[] accountId, uint128[] balanceSum)
1075     {
1076         require (owner_id[msg.sender] != 0 || msg.sender == operator);
1077         uint32 n = 0;
1078         for (uint32 i = 1; i <= lastAcccountId; i++)
1079         {
1080             if (exId_prCode_AccountId_Balance[exId][prCode][i].available + exId_prCode_AccountId_Balance[exId][prCode][i].reserved > minQty)
1081                 n++;
1082         }
1083         accountId = new uint32[](n);
1084         balanceSum = new uint128[](n);
1085 
1086         n = 0;
1087         uint128 temp;
1088         for (i = 1; i <= lastAcccountId; i++)
1089         {
1090             temp = exId_prCode_AccountId_Balance[exId][prCode][i].available + exId_prCode_AccountId_Balance[exId][prCode][i].reserved;
1091             if (temp >= minQty)
1092             {
1093                 accountId[n] = i;
1094                 balanceSum[n++] = temp;
1095             }
1096         }
1097     }
1098 
1099     // Get bestBidPrice and bestAskPrice of each orderbook
1100     function getOrderBookInfo(uint32[] prTrade, uint32 prBase) view public returns (uint80[] bestBidPrice, uint80[] bestAskPrice)
1101     {
1102         uint256 n = prTrade.length;
1103         bestBidPrice = new uint80[](n);
1104         bestAskPrice = new uint80[](n);
1105 
1106         for (uint256 i = 0; i < n; i++)
1107         {
1108             OrderBook memory orderBook = basePID_tradePID_orderBook[prBase][prTrade[i]];
1109             bestBidPrice[i] = orderBook.bestBidPrice;
1110             bestAskPrice[i] = orderBook.bestAskPrice;
1111         }
1112     }
1113 
1114     // Get order information by order id
1115     function getOrder(uint32 id) view public returns (uint32 prTrade, uint32 prBase, bool sell, uint80 price, uint104 qty, uint32 accountId, uint32 exId)
1116     {
1117         Order memory order = id_Order[id];
1118 
1119         accountId = order.accountId;
1120         checkAnnounceLV(accountId, 4);
1121 
1122         prTrade = order.prTrade;
1123         prBase = order.prBase;
1124         price = order.price;
1125         sell = order.isSell;
1126         qty = order.qty;
1127         exId = order.exId;
1128     }
1129 
1130     // Get message sender's open orders
1131     function GetMyOrders(uint32 exId, uint32 accountId, uint16 orderN) view public returns (uint32[] orderId, uint32[] prTrade, uint32[] prBase, bool[] sells, uint80[] prices, uint104[] qtys)
1132     {
1133         if (accountId == 0)
1134             accountId = account_id[msg.sender];
1135 
1136         checkAnnounceLV(accountId, 4);
1137 
1138         OpenOrder storage openOrder = accountId_OpenOrder[accountId];
1139 
1140         orderId = new uint32[](orderN);
1141         prTrade = new uint32[](orderN);
1142         prBase = new uint32[](orderN);
1143         qtys = new uint104[](orderN);
1144         prices = new uint80[](orderN);
1145         sells = new bool[](orderN);
1146 
1147         uint32 id = openOrder.startId;
1148         if (id != 0)
1149         {
1150             Order memory order;
1151             uint32 i = 0;
1152             while (id != 0 && i < orderN)
1153             {
1154                 order = id_Order[id];
1155 
1156                 if (exId == order.exId)
1157                 {
1158                     orderId[i] = id;
1159                     prTrade[i] = order.prTrade;
1160                     prBase[i] = order.prBase;
1161                     qtys[i] = order.qty;
1162                     prices[i] = order.price;
1163                     sells[i++] = order.isSell;
1164                 }
1165 
1166                 id = openOrder.id_orderList[id].next;
1167             }
1168         }
1169     }
1170 
1171     // Get all order id in each price
1172     function GetHogaDetail(uint32 prTrade, uint32 prBase, uint80 price, bool isSell, uint16 orderN) view public returns (uint32[] orderIds)
1173     {
1174         if (isSell == false)
1175         {
1176             OrderLink storage orderLink = basePID_tradePID_orderBook[prBase][prTrade].bidPrice_Order[price];
1177         }
1178         else if (isSell == true)
1179         {
1180             orderLink = basePID_tradePID_orderBook[prBase][prTrade].askPrice_Order[price];
1181         }
1182         else
1183         {
1184             return;
1185         }
1186 
1187         orderIds = new uint32[](orderN);
1188         uint16 n = 0;
1189         uint32 id0 = orderLink.firstId;
1190         while (id0 != 0 && orderN > n)
1191         {
1192             orderIds[n++] = id0;
1193             id0 = orderLink.id_orderList[id0].next;
1194         }
1195     }
1196 
1197     // Get orderbook screen
1198     function GetHoga(uint32 prTrade, uint32 prBase, uint32 hogaN) public view returns (uint80[] priceB, uint104[] volumeB, uint80[] priceA, uint104[] volumeA)
1199     {
1200         OrderBook storage ob = basePID_tradePID_orderBook[prBase][prTrade];
1201 
1202         (priceB, volumeB) = GetHoga(ob, hogaN, false);
1203         (priceA, volumeA) = GetHoga(ob, hogaN, true);
1204     }
1205 
1206     // Get orderbook screen
1207     function GetHoga(OrderBook storage ob, uint32 hogaN, bool isSell) private view returns (uint80[] prices, uint104[] volumes)
1208     {
1209         prices = new uint80[](hogaN);
1210         volumes = new uint104[](hogaN);
1211 
1212         uint32 n;
1213         uint32 id0;
1214         uint80 price;
1215         uint104 sum;
1216 
1217         if (isSell == false)
1218             price = ob.bestBidPrice;
1219         else
1220             price = ob.bestAskPrice;
1221 
1222         if (price != 0)
1223         {
1224             n = 0;
1225             while (price != 0 && n < hogaN)
1226             {
1227                 if (isSell == false)
1228                     OrderLink storage orderLink = ob.bidPrice_Order[price];
1229                 else
1230                     orderLink = ob.askPrice_Order[price];
1231 
1232                 id0 = orderLink.firstId;
1233                 sum = 0;
1234                 while (id0 != 0)
1235                 {
1236                     sum += id_Order[id0].qty;
1237                     id0 = orderLink.id_orderList[id0].next;
1238                 }
1239                 prices[n] = price;
1240                 volumes[n] = sum;
1241                 price = orderLink.nextPrice;
1242                 n++;
1243             }
1244 
1245             if (n > 0)
1246             {
1247                 while (n < hogaN)
1248                 {
1249                     if (isSell == true)
1250                         prices[n] = GetNextTick(true, prices[n - 1] + 1, ob.tickSize);
1251                     else
1252                         prices[n] = GetNextTick(false, prices[n - 1] - 1, ob.tickSize);
1253                     n++;
1254                 }
1255             }
1256         }
1257     }
1258 }