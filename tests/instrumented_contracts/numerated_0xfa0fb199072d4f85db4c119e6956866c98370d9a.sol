1 pragma solidity ^0.4.25;
2 
3 contract SafeMath {
4   function Sub(uint128 a, uint128 b) pure public returns (uint128) {
5     assert(b <= a);
6     return a - b;
7   }
8 
9   function Add(uint128 a, uint128 b) pure public returns (uint128) {
10     uint128 c = a + b;
11     assert(c>=a && c>=b);
12     return c;
13   }
14 }
15 
16 contract Token { 
17   function totalSupply() public view returns (uint256 supply);
18   function balanceOf(address _owner) public view returns (uint256 balance);
19   function transfer(address _to, uint256 _value) public returns (bool success);
20   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
21   function approve(address _spender, uint256 _value) public returns (bool success);
22   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
23   event Transfer(address indexed _from, address indexed _to, uint256 _value);
24   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 }
26 
27 contract DEX is SafeMath
28 {
29     uint32 public lastTransferId = 1;
30     event NewDeposit(uint32 indexed prCode, uint32 indexed accountId, uint128 amount, uint64 timestamp, uint32 lastTransferId);
31     event NewWithdraw(uint32 indexed prCode, uint32 indexed accountId, uint128 amount, uint64 timestamp, uint32 lastTransferId);
32     uint32 public lastNewOrderId = 1;
33     event NewOrder(uint32 indexed prTrade, uint32 indexed prBase, uint32 indexed accountId, uint32 id, bool isSell, uint80 price, uint104 qty, uint32 lastNewOrderId);
34     event NewCancel(uint32 indexed prTrade, uint32 indexed prBase, uint32 indexed accountId, uint32 id, bool isSell, uint80 price, uint104 qt, uint32 lastNewOrderId);
35     event NewBestBidAsk(uint32 indexed prTrade, uint32 indexed prBase, bool isBid, uint80 price);
36     uint32 public lastTradeId = 1;
37     event NewTrade(uint32 indexed prTrade, uint32 prBase, uint32 indexed bidId, uint32 indexed askId, uint32 accountIdBid, uint32 accountIdAsk, bool isSell, uint80 price, uint104 qty, uint32 lastTradeId, uint64 timestamp);
38     
39     uint256 public constant basePrice = 10000000000;
40     uint80 public constant maxPrice = 10000000000000000000001;
41     uint104 public constant maxQty = 1000000000000000000000000000001;
42     uint128 public constant maxBalance = 1000000000000000000000000000000000001;
43     bool public isContractUse;
44     
45     constructor() public
46     {
47         owner = msg.sender;
48         operator = owner;
49         AddOwner();
50         AddProduct(18, 0x0);
51         //lastProductId = 1; // productId == 1 -> ETH 0x0
52         isContractUse = true;
53     }
54     
55     address public owner;
56     // Functions with this modifier can only be executed by the owner
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61     
62     address public operator;
63     modifier onlyOperator() {
64         require(msg.sender == operator);
65         _;
66     }
67     function transferOperator(address _operator) onlyOwner public {
68         operator = _operator;
69     }
70     
71     modifier onlyExOwner()  {
72         require(owner_id[msg.sender] != 0);
73         _;
74     }
75     
76     modifier onlyContractUse {
77         require(isContractUse == true);
78         _;
79     }
80     function SetIsContractUse(bool _isContractUse) onlyOperator public 
81     {
82         isContractUse = _isContractUse;
83     }
84     
85     uint32 public lastOwnerId;
86     uint256 public newOwnerFee;
87     mapping (uint32 => address) id_owner;
88     mapping (address => uint32) owner_id;
89     mapping (uint32 => uint8) ownerId_takerFeeRateLocal;
90     mapping (uint32 => uint32) ownerId_accountId;
91     
92     function DeleteOwner(uint32 orderId) onlyOperator public 
93     {
94         require(lastOwnerId >= orderId && orderId > 0);
95         owner_id[id_owner[orderId]] = 0;
96     }
97     
98     function AddOwner() public payable 
99     {
100         require(msg.value >= newOwnerFee);
101         require(owner_id[msg.sender] == 0);
102         
103         owner_id[msg.sender] = ++lastOwnerId;
104         id_owner[lastOwnerId] = msg.sender;
105         
106         ownerId_accountId[lastOwnerId] = FindOrAddAccount();
107         prCode_AccountId_Balance[1][ownerId_accountId[1]].available += uint128(msg.value);
108         //overflow safe: eth balance & trasnfer << 2^128
109     }
110     function SetOwnerFee(uint256 ownerFee) onlyOperator public
111     {
112         newOwnerFee = ownerFee;
113     }
114     function GetOwnerList() view public returns (address[] owners, uint32[] ownerIds)
115     {
116         owners = new address[](lastOwnerId);
117         ownerIds = new uint32[](lastOwnerId);
118         
119         for (uint32 i = 1; i <= lastOwnerId; i++)
120         {
121             owners[i - 1] = id_owner[i];
122             ownerIds[i - 1] = i;
123         }
124     }
125     function setTakerFeeRateLocal(uint8 _takerFeeRate) public
126     {
127         require (_takerFeeRate <= 100);
128         uint32 ownerId = owner_id[msg.sender];
129         require(ownerId != 0);
130         ownerId_takerFeeRateLocal[ownerId] = _takerFeeRate;//bp
131     }
132     function getTakerFeeRateLocal(uint32 ownerId) public view returns (uint8)/////
133     {
134         return ownerId_takerFeeRateLocal[ownerId];//bp
135     }
136     
137     function airDrop(uint32 prCode, uint32[] accountIds, uint104[] qtys) public
138     {
139         require(owner_id[msg.sender] != 0);
140         //uint32 ownerId = owner_id[msg.sender];
141         uint32 accountId = FindOrRevertAccount();// ownerId_accountId[owner_id[msg.sender]];
142         require(accountId_freeze[accountId] == false);
143         uint256 n = accountIds.length;
144         require(n == qtys.length);// && n <= 1000000);
145         
146         uint128 sum = 0;
147         for (uint32 i = 0; i < n; i++)
148         {
149             sum += qtys[i];
150         }
151         
152         prCode_AccountId_Balance[prCode][accountId].available = Sub(prCode_AccountId_Balance[prCode][accountId].available, sum); 
153         
154         for (i = 0; i < n; i++)
155         {
156             prCode_AccountId_Balance[prCode][accountIds[i]].available += qtys[i];
157         }
158     }
159     
160     struct ProductInfo
161     {
162         uint256 divider;
163         bool isTradeBid;
164         bool isTradeAsk;
165         bool isDeposit;
166         bool isWithdraw;
167         uint32 ownerId;
168         uint104 minQty;
169     }
170     
171     uint32 public lastProductId;
172     uint256 public newProductFee;
173     mapping (uint32 => address) prCode_product;
174     mapping (address => uint32) product_prCode;
175     mapping (uint32 => ProductInfo) prCode_productInfo;
176     function AddProduct(uint256 decimals, address product) payable onlyExOwner public
177     {
178         require(msg.value >= newProductFee);
179         require(product_prCode[product] == 0);
180         require(decimals <= 18);
181         
182         product_prCode[product] = ++lastProductId;  
183         prCode_product[lastProductId] = product;
184         
185         ProductInfo memory productInfo;
186         productInfo.divider = 10 ** decimals; // max = 10 ^ 18
187         productInfo.ownerId = owner_id[msg.sender];
188         //productInfo.isDeposit = isDeposit;
189         prCode_productInfo[lastProductId] = productInfo;
190         
191         prCode_AccountId_Balance[1][ownerId_accountId[1]].available += uint128(msg.value);
192     }
193     function SetProductInfo(uint32 prCode, bool isTradeBid, bool isTradeAsk, bool isDeposit, bool isWithdraw, uint104 _minQty) public
194     {
195         ProductInfo storage prInfo = prCode_productInfo[prCode];
196         
197         require(msg.sender == operator || owner_id[msg.sender] == prInfo.ownerId );
198         
199         prInfo.isTradeBid = isTradeBid;
200         prInfo.isTradeAsk = isTradeAsk;
201         prInfo.isDeposit = isDeposit;
202         prInfo.isWithdraw = isWithdraw;
203         prInfo.minQty = _minQty;
204     }/*
205     function SetProductMinQty(uint32 prCode, uint104 _minQty) public
206     {
207         ProductInfo storage prInfo = prCode_productInfo[prCode];
208         require(msg.sender == operator || owner_id[msg.sender] == prInfo.ownerId );
209         
210         prInfo.minQty = _minQty;
211     }*/
212     function SetProductFee(uint256 productFee) onlyOperator public
213     {
214         newProductFee = productFee;
215     }
216     function GetProductList() view public returns (address[] products, uint32[] productIds)
217     {
218         products = new address[](lastProductId);
219         productIds = new uint32[](lastProductId);
220         
221         for (uint32 i = 1; i <= lastProductId; i++)
222         {
223             products[i - 1] = prCode_product[i];
224             productIds[i - 1] = i;
225         }
226     }
227     function GetProductInfo(address product) view public returns (uint32 prCode, uint256 divider, bool isTradeBid, bool isTradeAsk, bool isDeposit, bool isWithdraw, uint32 ownerId, uint104 minQty)
228     {
229         prCode = product_prCode[product];
230         require(prCode != 0);
231         
232         divider = prCode_productInfo[prCode].divider;
233         isTradeBid = prCode_productInfo[prCode].isTradeBid;
234         isTradeAsk = prCode_productInfo[prCode].isTradeAsk;
235         isDeposit = prCode_productInfo[prCode].isDeposit;
236         isWithdraw = prCode_productInfo[prCode].isWithdraw;
237         ownerId = prCode_productInfo[prCode].ownerId;
238         minQty = prCode_productInfo[prCode].minQty;
239     }/*
240     function AcceptProduct(uint32 prCode, bool isTrade) onlyOperator public
241     {
242         prCode_productInfo[prCode].isTrade = isTrade;
243     }*/
244     
245     uint32 public lastAcccountId;
246     mapping (uint32 => uint8) id_announceLV; //0: None, 1: Trade, 2:Balance, 3:DepositWithdrawal, 4:OpenOrder
247     mapping (uint32 => address) id_account;
248     mapping (uint32 => bool) accountId_freeze;
249     mapping (address => uint32) account_id;
250     
251     function FindOrAddAccount() private returns (uint32)
252     {
253         if (account_id[msg.sender] == 0)
254         {
255             account_id[msg.sender] = ++lastAcccountId;
256             id_account[lastAcccountId] = msg.sender;
257         }
258         return account_id[msg.sender];
259     }
260     function FindOrRevertAccount() private view returns (uint32)
261     {
262         uint32 accountId = account_id[msg.sender];
263         require(accountId != 0);
264         return accountId;
265     }
266     /*
267     function GetAccountList() view onlyOperator public returns (address[] owners)//, uint32[] Ids)// Delete Later`
268     {
269         owners = new address[](lastAcccountId);
270         //Ids = new uint32[](lastAcccountId);
271         
272         for (uint32 i = 1; i <= lastAcccountId; i++)
273         {
274             owners[i - 1] = id_account[i];
275             //Ids[i - 1] = i;
276         }
277     }*/
278     function GetMyAccountId() view public returns (uint32)
279     {
280         return account_id[msg.sender];
281     }
282     function GetAccountId(address account) view public returns (uint32)
283     {
284         return account_id[account];
285     }
286     function GetMyAnnounceLV() view public returns (uint32)
287     {
288         return id_announceLV[account_id[msg.sender]];
289     }
290     function ChangeAnnounceLV(uint8 announceLV) public
291     {
292         id_announceLV[FindOrRevertAccount()] = announceLV;
293     }
294     function SetFreezeByAddress(bool isFreeze, address account) onlyOperator public
295     {
296         uint32 accountId = account_id[account];
297         
298         if (accountId != 0)
299         {
300             accountId_freeze[accountId] = isFreeze;
301         }
302     }
303     
304     struct Balance
305     {
306         uint128 reserved;
307         uint128 available;
308     }
309     
310     struct ListItem
311     {
312         uint32 prev;
313         uint32 next;
314     }
315     
316     struct OrderLink
317     {
318         //uint32 orderN;
319         uint32 firstId;
320         uint32 lastId;
321         uint80 nextPrice;
322         uint80 prevPrice;
323         mapping (uint32 => ListItem) id_orderList;
324     }
325     
326     struct Order
327     {
328         uint32 ownerId;
329         uint32 accountId;
330         uint32 prTrade;
331         uint32 prBase;
332         uint104 qty;
333         uint80 price;
334         bool isSell;
335         //uint64 timestamp;
336     }
337 
338     uint32 public lastOrderId;
339     mapping (uint32 => Order) id_Order;
340         
341     struct OrderBook
342     {
343         uint8 tickSize;
344         
345         uint80 bestBidPrice;
346         uint80 bestAskPrice;
347 
348         mapping (uint80 => OrderLink) bidPrice_Order;
349         mapping (uint80 => OrderLink) askPrice_Order;
350     }
351     mapping (uint32 => mapping (uint32 => OrderBook)) basePID_tradePID_orderBook;
352     function SetOrderBookTickSize(uint32 prTrade, uint32 prBase, uint8 _tickSize) onlyOperator public
353     {
354         basePID_tradePID_orderBook[prBase][prTrade].tickSize = _tickSize;
355     }
356     
357     mapping (uint32 => mapping (uint32 => Balance)) prCode_AccountId_Balance;
358     
359     //trading fee
360     uint8 public takerFeeRateMain;
361     function setTakerFeeRateMain(uint8 _takerFeeRateMain) onlyOperator public
362     {
363         if (_takerFeeRateMain <= 100)
364             takerFeeRateMain = _takerFeeRateMain;//bp
365     }
366     
367     struct OpenOrder
368     {
369         uint32 startId;
370         mapping(uint32 => ListItem) id_orderList;
371     }
372     mapping(uint32 => OpenOrder) accountId_OpenOrder;
373     function AddOpenOrder(uint32 accountId, uint32 orderId) private
374     {
375         OpenOrder memory openOrder = accountId_OpenOrder[accountId];
376 
377         if (openOrder.startId != 0)
378         {
379             accountId_OpenOrder[accountId].id_orderList[openOrder.startId].prev = orderId;
380             accountId_OpenOrder[accountId].id_orderList[orderId].next = openOrder.startId;
381         }
382         accountId_OpenOrder[accountId].startId = orderId;
383     }
384     function RemoveOpenOrder(uint32 accountId, uint32 orderId) private
385     {
386         OpenOrder memory openOrder = accountId_OpenOrder[accountId];
387 
388         uint32 nextId = accountId_OpenOrder[accountId].id_orderList[orderId].next;
389         uint32 prevId = accountId_OpenOrder[accountId].id_orderList[orderId].prev;
390 
391         if (nextId != 0)
392         {
393             accountId_OpenOrder[accountId].id_orderList[nextId].prev = prevId;
394         }
395 
396         if (prevId != 0)
397         {
398             accountId_OpenOrder[accountId].id_orderList[prevId].next = nextId;
399         }
400         
401         if (openOrder.startId == orderId)
402         {
403             accountId_OpenOrder[accountId].startId = nextId;
404         }
405     }
406 
407     struct DWrecord
408     {
409         uint32 prCode;
410         bool isDeposit;
411         uint128 qty;
412         uint64 timestamp;
413     }
414     
415     struct DWrecords
416     {
417         uint32 N;
418         mapping (uint32 => DWrecord) N_DWrecord;
419     }
420     mapping (uint32 => DWrecords) AccountId_DWrecords;
421     function RecordDW(uint32 accountId, uint32 prCode, bool isDeposit, uint128 qty) private
422     {
423         //DWrecords storage dWrecords = AccountId_DWrecords[accountId];
424 
425         DWrecord memory dW;
426         dW.isDeposit = isDeposit;
427         dW.prCode = prCode;
428         dW.qty = qty;
429         dW.timestamp = uint64(now);
430 
431         AccountId_DWrecords[accountId].N_DWrecord[++AccountId_DWrecords[accountId].N] = dW;
432         
433         if (isDeposit == true)
434             emit NewDeposit(prCode, accountId, qty, dW.timestamp, lastTransferId++);
435         else 
436             emit NewWithdraw(prCode, accountId, qty, dW.timestamp, lastTransferId++);
437     }
438     function GetDWrecords(uint32 N, uint32 accountId) view public returns (uint32[] prCode, bool[] isDeposit, uint128[] qty, uint64[] timestamp)
439     {
440         //require (id_announceLV[accountId] > 2 || accountId == account_id[msg.sender]);
441         checkAnnounceLV(accountId, 3);
442         
443         DWrecords storage dWrecords = AccountId_DWrecords[accountId];
444         uint32 n = dWrecords.N;
445         
446         if (n > N)
447             n = N;
448             
449         prCode = new uint32[](n);
450         isDeposit = new bool[](n);
451         qty = new uint128[](n);
452         timestamp = new uint64[](n);
453 
454         for (uint32 i = dWrecords.N; i > dWrecords.N - n; i--)
455         {
456             N = dWrecords.N - i;
457             prCode[N] = dWrecords.N_DWrecord[i].prCode;//Bug0309
458             isDeposit[N] = dWrecords.N_DWrecord[i].isDeposit;//Bug0309
459             qty[N] = dWrecords.N_DWrecord[i].qty;//Bug0309
460             timestamp[N] = dWrecords.N_DWrecord[i].timestamp;//Bug0309
461         }
462     }
463     
464 /////////////////
465     function depositETH() payable public
466     {
467         uint32 accountId = FindOrAddAccount();
468         prCode_AccountId_Balance[1][accountId].available = Add(prCode_AccountId_Balance[1][accountId].available, uint128(msg.value));
469         RecordDW(accountId, 1, true, uint104(msg.value));
470     }
471 
472     function withdrawETH(uint104 amount) public
473     {
474         uint32 accountId = FindOrRevertAccount();
475         require(accountId_freeze[accountId] == false);
476         prCode_AccountId_Balance[1][accountId].available = Sub(prCode_AccountId_Balance[1][accountId].available, amount);
477         require(msg.sender.send(amount));
478         RecordDW(accountId, 1, false,  amount);
479     }
480 
481     function depositWithdrawToken(uint128 amount, bool isDeposit, address prAddress) public
482     {
483         uint32 prCode = product_prCode[prAddress];
484         require(amount < maxBalance && prCode != 0);
485         uint32 accountId = FindOrAddAccount();
486         require(accountId_freeze[accountId] == false);
487         //require(accountId != 0);
488         
489         if (isDeposit == true)
490         {
491             require(prCode_productInfo[prCode].isDeposit == true);//Bug0310
492             require(Token(prAddress).transferFrom(msg.sender, this, amount));
493             prCode_AccountId_Balance[prCode][accountId].available = Add(prCode_AccountId_Balance[prCode][accountId].available, amount);
494             require (prCode_AccountId_Balance[prCode][accountId].available < maxBalance);
495         }
496         else
497         {
498             require(prCode_productInfo[prCode].isWithdraw == true);//Bug0310
499             prCode_AccountId_Balance[prCode][accountId].available = Sub(prCode_AccountId_Balance[prCode][accountId].available, amount);
500             require(Token(prAddress).transfer(msg.sender, amount));    
501         }
502         RecordDW(accountId, prCode, isDeposit, amount);
503     }
504     
505     function emergencyWithdrawal(uint32 prCode, uint256 amount) onlyOwner public
506     {
507         require (isContractUse == false);//Added
508         if (prCode == 1)
509             require(msg.sender.send(amount));
510         else
511             Token(prCode_product[prCode]).transfer(msg.sender, amount);
512     }
513  /*
514     function withdrawToken(address prAddress, uint128 amount) public
515     {        
516         uint32 prCode = product_prCode[prAddress];
517         require(amount < maxBalance && prCode != 0);
518         uint32 accountId = account_id[msg.sender];
519         require(accountId != 0);
520         
521         //Balance storage balance = prCode_AccountId_Balance[prCode][accountId];
522         prCode_AccountId_Balance[prCode][accountId].available = SafeMath.Sub(prCode_AccountId_Balance[prCode][accountId].available, amount);
523         require(Token(prAddress).transfer(msg.sender, amount));
524         RecordDW(accountId, prCode, false, amount);
525     }
526     /*
527     function withdrawToken(address prAddress, uint128 amount, address toAddress) public
528     {        
529         uint32 prCode = product_prCode[prAddress];
530         require(amount < maxBalance && prCode != 0);
531         
532         uint32 accountId = account_id[msg.sender];
533         require(accountId != 0);
534         
535         //Balance storage balance = prCode_AccountId_Balance[prCode][accountId];
536         prCode_AccountId_Balance[prCode][accountId].available = SafeMath.Sub(prCode_AccountId_Balance[prCode][accountId].available, amount);
537         require(Token(prAddress).transfer(toAddress, amount));
538         RecordDW(accountId, prCode, false, amount);
539     }*/
540     /*
541     uint32 public maxOrderN;
542     function SetMaxOrderN(uint32 _maxOrderN) public onlyOwner
543     {
544         maxOrderN = _maxOrderN;
545     }*/
546     function GetNextTick(bool isAsk, uint80 price, uint8 n) public pure returns (uint80)
547     {
548         if (price > 0)
549         {
550             uint80 tick = GetTick(price, n);
551     
552             if (isAsk == true)
553                 return (((price - 1) / tick) + 1) * tick;
554             else
555                 return (price / tick) * tick;
556         }
557         else
558         {
559             return price;
560         }
561     }
562     
563     function GetTick(uint80 price, uint8 n)  public pure returns  (uint80)
564     {
565         if (n < 1)
566             n = 1;
567         
568         uint80 x = 1;
569         
570         for (uint8 i=1; i <= n / 2; i++)
571         {
572             x *= 10;
573         }
574         
575         if (price < 10 * x)
576             return 1;
577         else
578         {
579             uint80 tick = 10000;
580                 
581             uint80 priceTenPercent = price / 10 / x;
582                 
583             while (priceTenPercent > tick)
584             {
585                 tick *= 10;
586             }
587     
588             while (priceTenPercent < tick)
589             {
590                 tick /= 10;
591             }
592             
593             if (n % 2 == 1)
594             {
595                 if (price >= 50 * tick * x)
596                 {
597                     tick *= 5;
598                 }
599             }
600             else
601             {
602                 if (price < 50 * tick * x)
603                 {
604                     tick *= 5;
605                 }
606                 else
607                 {
608                     tick *= 10;
609                 }
610                 
611             }
612             
613             return tick;
614         }
615     }
616     /*
617     function LimitOrders(uint32 orderN, uint32 ownerId, uint32[] prTrade, uint32[] prBase, bool[] isSell, uint80[] price, uint104[] qty) public returns (uint32[])
618     {
619         require(orderN <= 10 &&  orderN == prTrade.length && orderN == prBase.length && orderN == isSell.length && orderN == price.length && orderN == qty.length);
620         
621         uint32[] memory orderId = new uint32[](orderN);
622         for (uint32 i = 0; i < orderN; i++)
623         {
624             orderId[i] = LimitOrder(ownerId, prTrade[i], prBase[i], isSell[i], price[i], qty[i]);
625         }
626         return orderId;
627     }
628     */
629     function LimitOrder(uint32 ownerId, uint32 prTrade, uint32 prBase, bool isSell, uint80 price, uint104 qty) public onlyContractUse  returns  (uint32)
630     {
631         uint32 accountId = FindOrRevertAccount();
632         require(accountId_freeze[accountId] == false);
633         uint80 lastBestPrice;
634         OrderBook storage orderBook = basePID_tradePID_orderBook[prBase][prTrade];
635         require(price != 0 && price <= maxPrice && qty <= maxQty &&
636             ((isSell == false && prCode_productInfo[prTrade].isTradeBid == true && prCode_productInfo[prBase].isTradeAsk == true) 
637             || (isSell == true && prCode_productInfo[prTrade].isTradeAsk == true && prCode_productInfo[prBase].isTradeBid == true)) 
638             && prCode_productInfo[prTrade].minQty <= qty);
639         
640         if (isSell == true)
641         {
642             price = GetNextTick(true, price, orderBook.tickSize);
643             lastBestPrice = orderBook.bestAskPrice;
644         }
645         else
646         {
647             price = GetNextTick(false, price, orderBook.tickSize);
648             lastBestPrice = orderBook.bestBidPrice;
649         }
650         
651         Order memory order;
652         order.ownerId = ownerId;
653         order.isSell = isSell;
654         order.prTrade = prTrade;
655         order.prBase = prBase;
656         order.accountId = accountId;
657         order.price = price;
658         order.qty = qty;
659         //order.timestamp = uint64(now);
660         
661         require (IsPossibleLimit(order));
662         
663         emit NewOrder(order.prTrade, order.prBase, order.accountId, ++lastOrderId, order.isSell, order.price, order.qty, lastNewOrderId++);
664 
665         //uint104 tradedQty = matchOrder(orderBook, order, lastOrderId);
666         //BalanceUpdateByLimitAfterTrade(order, qty, tradedQty);
667 
668         BalanceUpdateByLimitAfterTrade(order, qty, matchOrder(orderBook, order, lastOrderId));
669 
670         if (order.qty != 0)
671         {
672             uint80 priceNext;
673             uint80 price0;
674             
675             if (isSell == true)
676             {
677                 price0 = orderBook.bestAskPrice;
678                 if (price0 == 0)
679                 {
680                     orderBook.askPrice_Order[price].prevPrice = 0;
681                     orderBook.askPrice_Order[price].nextPrice = 0;
682                     orderBook.bestAskPrice = price;
683                 }
684                 else if(price < price0)
685                 {
686                     orderBook.askPrice_Order[price0].prevPrice = price;
687                     orderBook.askPrice_Order[price].prevPrice = 0;
688                     orderBook.askPrice_Order[price].nextPrice = price0;
689                     orderBook.bestAskPrice = price;
690                 }
691                 else if (orderBook.askPrice_Order[price].firstId == 0)// .orderN == 0)
692                 {
693                     priceNext = price0;
694                     
695                     while (priceNext != 0 && priceNext < price)
696                     {
697                         price0 = priceNext;
698                         priceNext = orderBook.askPrice_Order[price0].nextPrice;
699                     }
700                     
701                     orderBook.askPrice_Order[price0].nextPrice = price;
702                     orderBook.askPrice_Order[price].prevPrice = price0;
703                     orderBook.askPrice_Order[price].nextPrice = priceNext;
704                     if (priceNext != 0)
705                     {
706                         orderBook.askPrice_Order[priceNext].prevPrice = price;
707                     }
708                 }
709                 
710                 OrderLink storage orderLink = orderBook.askPrice_Order[price];
711             }
712             else
713             {
714                 price0 = orderBook.bestBidPrice;
715                 if (price0 == 0)
716                 {
717                     orderBook.bidPrice_Order[price].prevPrice = 0;
718                     orderBook.bidPrice_Order[price].nextPrice = 0;
719                     orderBook.bestBidPrice = price;
720                 }
721                 else if (price > price0)
722                 {
723                     orderBook.bidPrice_Order[price0].prevPrice = price;
724                     orderBook.bidPrice_Order[price].prevPrice = 0;
725                     orderBook.bidPrice_Order[price].nextPrice = price0;
726                     orderBook.bestBidPrice = price;
727                 }
728                 else if (orderBook.bidPrice_Order[price].firstId == 0)// .orderN == 0)
729                 {
730                     priceNext = price0;
731 
732                     while (priceNext != 0 && priceNext > price)
733                     {
734                         price0 = priceNext;
735                         priceNext = orderBook.bidPrice_Order[price0].nextPrice;
736                     }
737                     
738                     orderBook.bidPrice_Order[price0].nextPrice = price;
739                     orderBook.bidPrice_Order[price].prevPrice = price0;
740                     orderBook.bidPrice_Order[price].nextPrice = priceNext;
741                     if (priceNext != 0)
742                     {
743                         orderBook.bidPrice_Order[priceNext].prevPrice = price;
744                     }
745                 }
746 
747                 orderLink = orderBook.bidPrice_Order[price];
748             }
749             
750             if (lastOrderId != 0)
751             {
752                 orderLink.id_orderList[lastOrderId].prev = orderLink.lastId;// .firstID;
753                 if (orderLink.firstId != 0)
754                 {
755                     orderLink.id_orderList[orderLink.lastId].next = lastOrderId;
756                 }
757                 else
758                 {
759                     orderLink.id_orderList[lastOrderId].next = 0;
760                     orderLink.firstId = lastOrderId;
761                 }
762                 orderLink.lastId = lastOrderId;
763             }
764 
765             //orderLink.id_orderList.Add(id, listItem);
766             //id_Order.Add(id, order);
767             //orderLink.id_orderList[lastOrderId] = listItem;
768             
769             AddOpenOrder(accountId, lastOrderId);
770             //orderLink.orderN += 1;
771             id_Order[lastOrderId] = order;
772             //emit NewHogaChange(prTrade, prBase, isSell, price);
773             
774         }
775 
776         if (isSell == true && lastBestPrice != orderBook.bestAskPrice)
777         {
778             emit NewBestBidAsk(prTrade, prBase, isSell, orderBook.bestAskPrice);
779         }
780         if (isSell == false && lastBestPrice != orderBook.bestBidPrice)
781         {
782             emit NewBestBidAsk(prTrade, prBase, isSell, orderBook.bestBidPrice);
783         }
784         
785         return lastOrderId;
786     }
787     
788     function BalanceUpdateByLimitAfterTrade(Order order, uint104 qty, uint104 tradedQty) private
789     {
790         uint32 ownerId = order.ownerId;
791         uint32 accountId = order.accountId;
792         uint32 prTrade = order.prTrade;
793         uint32 prBase = order.prBase;
794         uint80 price = order.price;
795         uint104 orderQty = order.qty;
796         
797         //require(qty >= orderQty);// && tradedQty < maxQty);
798         
799         //Balance storage balance;
800         uint32 prTemp;
801 
802         if (order.isSell)
803         {
804             Balance storage balance = prCode_AccountId_Balance[prTrade][accountId];
805             balance.available = Sub(balance.available, qty);
806             
807             if (orderQty != 0)
808                 balance.reserved = Add(balance.reserved, orderQty);
809 
810             prTemp = prBase;
811         }
812         else
813         {
814             balance = prCode_AccountId_Balance[prBase][accountId];/////
815             if (orderQty != 0)
816             {
817                 uint256 temp = prCode_productInfo[prBase].divider * orderQty * price / basePrice / prCode_productInfo[prTrade].divider;
818                 require (temp < maxQty);
819                 balance.available = Sub(balance.available, tradedQty + uint104(temp));
820                 balance.reserved = Add(balance.reserved, uint104(temp));
821             }
822             else
823             {
824                 balance.available = Sub(balance.available, tradedQty);///////
825             }
826             tradedQty = qty - orderQty;
827 
828             prTemp = prTrade;
829         }
830         if (tradedQty != 0)
831         {
832             uint104 takeFeeMain = tradedQty * takerFeeRateMain / 10000;
833             uint104 takeFeeLocal = tradedQty * ownerId_takerFeeRateLocal[ownerId] / 10000;
834             prCode_AccountId_Balance[prTemp][accountId].available += tradedQty - takeFeeMain - takeFeeLocal;
835             prCode_AccountId_Balance[prTemp][ownerId_accountId[1]].available += takeFeeMain;
836             prCode_AccountId_Balance[prTemp][ownerId_accountId[ownerId]].available += takeFeeLocal;
837         }
838     }
839 
840     function IsPossibleLimit(Order memory order) private view returns (bool)
841     {
842         if (order.isSell)
843         {
844             if (prCode_AccountId_Balance[order.prTrade][order.accountId].available >= order.qty)
845                 return true;
846             else
847                 return false;
848         }
849         else
850         {
851             if (prCode_AccountId_Balance[order.prBase][order.accountId].available >= prCode_productInfo[order.prBase].divider * order.qty * order.price / basePrice / prCode_productInfo[order.prTrade].divider)
852                 return true;
853             else
854                 return false;
855         }
856     }
857 
858     function matchOrder(OrderBook storage ob, Order memory order, uint32 id) private returns (uint104)//, OrderBook storage orderBook, Order order, uint32 id) private returns (uint104)
859     {
860         uint32 prTrade = order.prTrade;
861         uint32 prBase = order.prBase; 
862         uint80 tradePrice;
863 
864         if (order.isSell == true)
865             tradePrice = ob.bestBidPrice;
866         else
867             tradePrice = ob.bestAskPrice;
868 
869         bool isBestPriceUpdate = false;
870 
871         //OrderLink storage orderLink;// = price_OrderLink[tradePrice];
872         uint104 qtyBase = 0;
873         //Order storage matchingOrder;
874         uint104 tradeAmount;
875         
876         while (tradePrice != 0 && order.qty > 0 && ((order.isSell && order.price <= tradePrice) || (!order.isSell && order.price >= tradePrice)))
877         {
878             if (order.isSell == true)
879                 OrderLink storage orderLink = ob.bidPrice_Order[tradePrice];
880             else
881                 orderLink = ob.askPrice_Order[tradePrice];
882                 
883             uint32 orderId = orderLink.firstId;
884             
885             while (orderLink.firstId != 0 && orderId != 0 && order.qty != 0)
886             {
887                 Order storage matchingOrder = id_Order[orderId];
888                 if (matchingOrder.qty >= order.qty)
889                 {
890                     tradeAmount = order.qty;
891                     matchingOrder.qty -= order.qty;
892                     order.qty = 0;
893                 }
894                 else
895                 {
896                     tradeAmount = matchingOrder.qty;
897                     order.qty -= matchingOrder.qty;
898                     matchingOrder.qty = 0;
899                 }
900                 
901                 qtyBase += BalanceUpdateByTradeCp(order, matchingOrder, tradeAmount);
902                 
903                 uint32 orderAccountID = order.accountId;
904 
905                 if (order.isSell == true)
906                     emit NewTrade(prTrade, prBase, orderId, id, matchingOrder.accountId, orderAccountID, true, tradePrice,  tradeAmount, lastTradeId++, uint64(now));
907                 else
908                     emit NewTrade(prTrade, prBase, id, orderId, orderAccountID, matchingOrder.accountId, false, tradePrice,  tradeAmount, lastTradeId++, uint64(now));
909                 
910                 if (matchingOrder.qty != 0)
911                 {
912                     //id_Order[tradePrice] = matchingOrder;
913                     break;
914                 }
915                 else
916                 {
917                     if (RemoveOrder(prTrade, prBase, matchingOrder.isSell, tradePrice, orderId) == true)
918                     {
919                         RemoveOpenOrder(matchingOrder.accountId, orderId);
920                     }
921                     orderId = orderLink.firstId;
922                 }
923             }
924             
925             //emit NewHogaChange(prTrade, prBase, !order.isSell, tradePrice);
926 
927             if (orderLink.firstId == 0)// .orderN == 0)
928             {
929                 tradePrice = orderLink.nextPrice;
930                 isBestPriceUpdate = true;
931             }
932         }
933         
934         if (isBestPriceUpdate == true)
935         {
936             if (order.isSell)
937             {
938                 ob.bestBidPrice = tradePrice;
939             }
940             else
941             {
942                 ob.bestAskPrice = tradePrice;
943             }
944             
945             emit NewBestBidAsk(prTrade, prBase, !order.isSell, tradePrice);
946         }
947 
948         return qtyBase;
949     }
950     
951     function BalanceUpdateByTradeCp(Order order, Order matchingOrder, uint104 tradeAmount) private returns (uint104)
952     {
953         uint32 accountId = matchingOrder.accountId;
954         uint32 prTrade = order.prTrade; 
955         uint32 prBase = order.prBase; 
956         require (tradeAmount < maxQty);
957         uint256 qtyBase = prCode_productInfo[prBase].divider * tradeAmount * matchingOrder.price / basePrice / prCode_productInfo[prTrade].divider;
958         require (qtyBase < maxQty);
959         /*
960         if (order.isSell == true)
961         {
962             prCode_AccountId_Balance[prTrade][accountId].available = SafeMath.Add(prCode_AccountId_Balance[prTrade][accountId].available, tradeAmount);
963             prCode_AccountId_Balance[prBase][accountId].reserved = SafeMath.Sub(prCode_AccountId_Balance[prBase][accountId].reserved, uint104(qtyBase));
964         }
965         else
966         {
967             prCode_AccountId_Balance[prTrade][accountId].reserved = SafeMath.Sub(prCode_AccountId_Balance[prTrade][accountId].reserved, tradeAmount);
968             prCode_AccountId_Balance[prBase][accountId].available = SafeMath.Add(prCode_AccountId_Balance[prBase][accountId].available, uint104(qtyBase));
969         }
970         */
971         Balance storage balanceTrade = prCode_AccountId_Balance[prTrade][accountId];
972         Balance storage balanceBase = prCode_AccountId_Balance[prBase][accountId];
973         
974         if (order.isSell == true)
975         {
976             balanceTrade.available = SafeMath.Add(balanceTrade.available, tradeAmount);
977             balanceBase.reserved = SafeMath.Sub(balanceBase.reserved, uint104(qtyBase));
978         }
979         else
980         {
981             balanceTrade.reserved = SafeMath.Sub(balanceTrade.reserved, tradeAmount);
982             balanceBase.available = SafeMath.Add(balanceBase.available, uint104(qtyBase));
983         }
984 
985         return uint104(qtyBase);
986     }
987     
988     function RemoveOrder(uint32 prTrade, uint32 prBase, bool isSell, uint80 price, uint32 id) private returns (bool)
989     {
990         OrderBook storage ob = basePID_tradePID_orderBook[prBase][prTrade];
991         
992         if (isSell == false)
993         {
994             OrderLink storage orderLink = ob.bidPrice_Order[price];
995         }
996         else
997         {
998             orderLink = ob.askPrice_Order[price];
999         }
1000         
1001         if (id != 0)
1002         {
1003             ListItem memory removeItem = orderLink.id_orderList[id];
1004             if (removeItem.next != 0)
1005             {
1006                 orderLink.id_orderList[removeItem.next].prev = removeItem.prev;
1007             }
1008 
1009             if (removeItem.prev != 0)
1010             {
1011                 orderLink.id_orderList[removeItem.prev].next = removeItem.next;
1012             }
1013 
1014             if (id == orderLink.lastId)
1015             {
1016                 orderLink.lastId = removeItem.prev;
1017             }
1018             
1019             if (id == orderLink.firstId)
1020             {
1021                 orderLink.firstId = removeItem.next;
1022             }
1023 
1024             delete orderLink.id_orderList[id];
1025 
1026             if (orderLink.firstId == 0)
1027             {
1028                 if (orderLink.nextPrice != 0)
1029                 {
1030                     if (isSell == true)
1031                         OrderLink storage replaceLink = ob.askPrice_Order[orderLink.nextPrice];
1032                     else
1033                         replaceLink = ob.bidPrice_Order[orderLink.nextPrice];
1034 
1035                     replaceLink.prevPrice = orderLink.prevPrice;
1036                 }
1037                 if (orderLink.prevPrice != 0)
1038                 {
1039                     if (isSell == true)
1040                         replaceLink = ob.askPrice_Order[orderLink.prevPrice];
1041                     else
1042                         replaceLink = ob.bidPrice_Order[orderLink.prevPrice];
1043 
1044                     replaceLink.nextPrice = orderLink.nextPrice;
1045                 }
1046 
1047                 if (price == ob.bestAskPrice)
1048                 {
1049                     ob.bestAskPrice = orderLink.nextPrice;
1050                 }
1051                 if (price == ob.bestBidPrice)
1052                 {
1053                     ob.bestBidPrice = orderLink.nextPrice;
1054                 }
1055             }
1056             return true;
1057         }
1058         else    
1059         {
1060             return false;
1061         }
1062     }
1063 
1064     function cancelOrders(uint32[] id) public
1065     {
1066         for (uint32 i = 0; i < id.length; i++)
1067         {
1068             cancelOrder(id[i]);
1069         }
1070     }
1071     
1072     function cancelOrder(uint32 id) public returns (bool)
1073     {
1074         Order memory order = id_Order[id];
1075         uint32 accountId = account_id[msg.sender];
1076         require(order.accountId == accountId);
1077         
1078         uint32 prTrade = order.prTrade;
1079         uint32 prBase = order.prBase;
1080         bool isSell = order.isSell;
1081         uint80 price = order.price;
1082         uint104 qty = order.qty;
1083         
1084         if (RemoveOrder(prTrade, prBase, isSell, price, id) == false)
1085             return false;
1086         else
1087         {
1088             RemoveOpenOrder(accountId, id);
1089         }
1090 
1091         //Balance storage balance;
1092         
1093         if (isSell)
1094         {
1095             Balance storage balance = prCode_AccountId_Balance[prTrade][accountId];
1096             balance.available = SafeMath.Add(balance.available, qty);
1097             balance.reserved = SafeMath.Sub(balance.reserved, qty);
1098         }
1099         else
1100         {
1101             balance = prCode_AccountId_Balance[prBase][accountId];
1102             uint256 temp = prCode_productInfo[prBase].divider * qty * price / basePrice / prCode_productInfo[prTrade].divider;
1103             require (temp < maxQty);
1104             balance.available = SafeMath.Add(balance.available, uint104(temp));
1105             balance.reserved = SafeMath.Sub(balance.reserved, uint104(temp));
1106         }
1107 
1108         //RemoveOrder(prTrade, prBase, isSell, price, id);//, msg);
1109         //emit NewHogaChange(prTrade, prBase, isSell, order.price);
1110         
1111         emit NewCancel(prTrade, prBase, accountId, id, isSell, price, qty, lastNewOrderId++);
1112         return true;
1113     }
1114     function checkAnnounceLV(uint32 accountId, uint8 LV) private view
1115     {
1116         require(accountId == account_id[msg.sender] || id_announceLV[accountId] >= LV || msg.sender == operator || owner_id[msg.sender] != 0);
1117     }
1118     /*
1119     function getBalance(uint32[] prCode) view public returns (uint128[] available, uint128[] reserved)
1120     {
1121         (available, reserved) = getBalance(prCode, msg.sender);
1122     }
1123       */
1124     function getBalance(uint32[] prCode, uint32 accountId) view public returns (uint128[] available, uint128[] reserved)
1125     {
1126         if (accountId == 0)
1127             accountId = account_id[msg.sender];
1128         checkAnnounceLV(accountId, 2);
1129         
1130         uint256 n = prCode.length;
1131         available = new uint128[](n);
1132         reserved = new uint128[](n);
1133         
1134         for (uint32 i = 0; i < n; i++)
1135         {
1136             available[i] = prCode_AccountId_Balance[prCode[i]][accountId].available;
1137             reserved[i] = prCode_AccountId_Balance[prCode[i]][accountId].reserved;
1138         }
1139     }
1140     
1141     function getBalanceByProduct(uint32 prCode, uint128 minQty) view public returns (uint32[] accountId, uint128[] balanceSum)
1142     {
1143         require (owner_id[msg.sender] != 0 || msg.sender == operator);
1144         uint32 n = 0;
1145         for (uint32 i = 1; i <= lastAcccountId; i++)//Bug0319
1146         {
1147             if (prCode_AccountId_Balance[prCode][i].available + prCode_AccountId_Balance[prCode][i].reserved >= minQty)
1148                 n++;
1149         }
1150         accountId = new uint32[](n);
1151         balanceSum = new uint128[](n);
1152         
1153         n = 0;
1154         uint128 temp;
1155         for (i = 1; i <= lastAcccountId; i++)//Bug0319
1156         {
1157             temp = prCode_AccountId_Balance[prCode][i].available + prCode_AccountId_Balance[prCode][i].reserved;
1158             if (temp >= minQty)//Bug0319
1159             {
1160                 accountId[n] = i;
1161                 balanceSum[n++] = temp;
1162             }
1163         }
1164     }
1165     
1166     function getOrderBookInfo(uint32[] prTrade, uint32 prBase) view public returns (uint80[] bestBidPrice, uint80[] bestAskPrice)
1167     {
1168         uint256 n = prTrade.length;
1169         //require(n == prBase.length);
1170         bestBidPrice = new uint80[](n);//prTrade.length);
1171         bestAskPrice = new uint80[](n);//prTrade.length);
1172         
1173         for (uint256 i = 0; i < n; i++)
1174         {
1175             OrderBook memory orderBook = basePID_tradePID_orderBook[prBase][prTrade[i]];// iCode_OrderBook[prCode];
1176             bestBidPrice[i] = orderBook.bestBidPrice;
1177             bestAskPrice[i] = orderBook.bestAskPrice;
1178         }
1179     }
1180     /*
1181     function getOrder(uint32[] id) view public returns (uint32[] prTrade, uint32[] prBase, bool[] sell, uint80[] price, uint104[] qty)
1182     {
1183         uint256 n = id.length;
1184         prTrade = new uint32[](n);
1185         prBase = new uint32[](n);
1186         sell = new bool[](n);
1187         price = new uint80[](n);
1188         qty = new uint104[](n);
1189         
1190         for (uint256 i = 0; i < n; i++)
1191         {
1192             Order memory order = id_Order[id[i]];
1193             prTrade[i] = order.prTrade;
1194             prBase[i] = order.prBase;
1195             sell[i] = order.isSell;
1196             price[i] = order.price;
1197             qty[i] = order.qty;
1198         }
1199     }
1200     */
1201     
1202     function getOrder(uint32 id) view public returns (uint32 prTrade, uint32 prBase, bool sell, uint80 price, uint104 qty, uint32 accountId)//, uint64 timestamp)
1203     {
1204         Order memory order = id_Order[id];
1205         
1206         accountId = order.accountId;
1207         checkAnnounceLV(accountId, 4);
1208         
1209         prTrade = order.prTrade;
1210         prBase = order.prBase;
1211         price = order.price;
1212         sell = order.isSell;
1213         qty = order.qty;
1214         //timestamp = order.timestamp;
1215     }
1216     
1217     function GetMyOrders(uint32 accountId) view public returns (uint32[] orderId, uint32[] prTrade, uint32[] prBase, bool[] sells, uint80[] prices, uint104[] qtys)//, uint64[] timestamp)
1218     {
1219         if (accountId == 0)
1220             accountId = account_id[msg.sender];
1221         
1222         checkAnnounceLV(accountId, 4);
1223         
1224         OpenOrder storage openOrder = accountId_OpenOrder[accountId];
1225      
1226         uint32 id = accountId_OpenOrder[accountId].startId;
1227         uint32 orderN = 0;
1228         while (id != 0)
1229         {
1230             id = openOrder.id_orderList[id].next;
1231             orderN++;
1232         }
1233 
1234         orderId = new uint32[](orderN);
1235         prTrade = new uint32[](orderN);
1236         prBase = new uint32[](orderN);
1237         qtys = new uint104[](orderN);
1238         prices = new uint80[](orderN);
1239         sells = new bool[](orderN);
1240         //timestamp = new uint64[](orderN);
1241         
1242         id = openOrder.startId;
1243         if (id != 0)
1244         {
1245             Order memory order;
1246             uint32 i = 0;
1247             while (id != 0)
1248             {
1249                 order = id_Order[id];
1250                 
1251                 orderId[i] = id;
1252                 prTrade[i] = order.prTrade;
1253                 prBase[i] = order.prBase;
1254                 qtys[i] = order.qty;
1255                 prices[i] = order.price;
1256                 sells[i++] = order.isSell;
1257                 //timestamp[i++] = order.timestamp;
1258 
1259                 id = openOrder.id_orderList[id].next;
1260             }
1261         }
1262     }
1263     
1264     function GetHogaDetail(uint32 prTrade, uint32 prBase, uint80 price, bool isSell) view public returns (uint32[] orderIds)
1265     {
1266         if (isSell == false)
1267         {
1268             OrderLink storage orderLink = basePID_tradePID_orderBook[prBase][prTrade].bidPrice_Order[price];
1269         }
1270         else if (isSell == true)
1271         {
1272             orderLink = basePID_tradePID_orderBook[prBase][prTrade].askPrice_Order[price];
1273         }
1274         else
1275         {
1276             return;
1277         }
1278         
1279         uint32 n = 0;
1280         uint32 id0 = orderLink.firstId;
1281         while (id0 != 0)
1282         {
1283             id0 = orderLink.id_orderList[id0].next;
1284             n++;
1285         }
1286         
1287         orderIds = new uint32[](n);
1288         n = 0;
1289         id0 = orderLink.firstId;
1290         while (id0 != 0)
1291         {
1292             orderIds[n++] = id0;
1293             id0 = orderLink.id_orderList[id0].next;
1294         }
1295     }
1296     
1297     function GetHoga(uint32 prTrade, uint32 prBase, uint32 hogaN) public view returns (uint80[] priceB, uint104[] volumeB, uint80[] priceA, uint104[] volumeA)
1298     {
1299         OrderBook storage ob = basePID_tradePID_orderBook[prBase][prTrade];
1300         
1301         (priceB, volumeB) = GetHoga(ob, hogaN, false);
1302         (priceA, volumeA) = GetHoga(ob, hogaN, true);
1303     }
1304     
1305     function GetHoga(OrderBook storage ob, uint32 hogaN, bool isSell) private view returns (uint80[] prices, uint104[] volumes)
1306     {
1307         prices = new uint80[](hogaN);
1308         volumes = new uint104[](hogaN);
1309         
1310         uint32 n;
1311         uint32 id0;
1312         uint80 price;
1313         uint104 sum;
1314         
1315         if (isSell == false)
1316             price = ob.bestBidPrice;
1317         else
1318             price = ob.bestAskPrice;// .bestBidPrice;
1319         
1320         if (price != 0)
1321         {
1322             n = 0;
1323             while (price != 0 && n < hogaN)
1324             {
1325                 if (isSell == false)
1326                     OrderLink storage orderLink = ob.bidPrice_Order[price];
1327                 else
1328                     orderLink = ob.askPrice_Order[price];
1329                 
1330                 id0 = orderLink.firstId;
1331                 sum = 0;
1332                 while (id0 != 0)
1333                 {
1334                     sum += id_Order[id0].qty;
1335                     id0 = orderLink.id_orderList[id0].next;
1336                 }
1337                 prices[n] = price;
1338                 volumes[n] = sum;
1339                 price = orderLink.nextPrice;
1340                 n++;
1341             }
1342 
1343             if (n > 0)
1344             {
1345                 while (n < hogaN)
1346                 {
1347                     if (isSell == true)
1348                         prices[n] = GetNextTick(true, prices[n - 1] + 1, ob.tickSize);
1349                     else
1350                         prices[n] = GetNextTick(false, prices[n - 1] - 1, ob.tickSize);
1351                     n++;
1352                 }
1353             }
1354         }
1355     }
1356 }