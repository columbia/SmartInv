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
146 // File: contracts/permissionless/OrderIdManager.sol
147 
148 contract OrderIdManager {
149     struct OrderIdData {
150         uint32 firstOrderId;
151         uint takenBitmap;
152     }
153 
154     uint constant public NUM_ORDERS = 32;
155 
156     function fetchNewOrderId(OrderIdData storage freeOrders)
157         internal
158         returns(uint32)
159     {
160         uint orderBitmap = freeOrders.takenBitmap;
161         uint bitPointer = 1;
162 
163         for (uint i = 0; i < NUM_ORDERS; ++i) {
164 
165             if ((orderBitmap & bitPointer) == 0) {
166                 freeOrders.takenBitmap = orderBitmap | bitPointer;
167                 return(uint32(uint(freeOrders.firstOrderId) + i));
168             }
169 
170             bitPointer *= 2;
171         }
172 
173         revert();
174     }
175 
176     /// @dev mark order as free to use.
177     function releaseOrderId(OrderIdData storage freeOrders, uint32 orderId)
178         internal
179         returns(bool)
180     {
181         require(orderId >= freeOrders.firstOrderId);
182         require(orderId < (freeOrders.firstOrderId + NUM_ORDERS));
183 
184         uint orderBitNum = uint(orderId) - uint(freeOrders.firstOrderId);
185         uint bitPointer = uint(1) << orderBitNum;
186 
187         require(bitPointer & freeOrders.takenBitmap > 0);
188 
189         freeOrders.takenBitmap &= ~bitPointer;
190         return true;
191     }
192 
193     function allocateOrderIds(
194         OrderIdData storage makerOrders,
195         uint32 firstAllocatedId
196     )
197         internal
198         returns(bool)
199     {
200         if (makerOrders.firstOrderId > 0) {
201             return false;
202         }
203 
204         makerOrders.firstOrderId = firstAllocatedId;
205         makerOrders.takenBitmap = 0;
206 
207         return true;
208     }
209 
210     function orderAllocationRequired(OrderIdData storage freeOrders) internal view returns (bool) {
211 
212         if (freeOrders.firstOrderId == 0) return true;
213         return false;
214     }
215 
216     function getNumActiveOrderIds(OrderIdData storage makerOrders) internal view returns (uint numActiveOrders) {
217         for (uint i = 0; i < NUM_ORDERS; ++i) {
218             if ((makerOrders.takenBitmap & (uint(1) << i)) > 0) numActiveOrders++;
219         }
220     }
221 }
222 
223 // File: contracts/permissionless/OrderListInterface.sol
224 
225 interface OrderListInterface {
226     function getOrderDetails(uint32 orderId) public view returns (address, uint128, uint128, uint32, uint32);
227     function add(address maker, uint32 orderId, uint128 srcAmount, uint128 dstAmount) public returns (bool);
228     function remove(uint32 orderId) public returns (bool);
229     function update(uint32 orderId, uint128 srcAmount, uint128 dstAmount) public returns (bool);
230     function getFirstOrder() public view returns(uint32 orderId, bool isEmpty);
231     function allocateIds(uint32 howMany) public returns(uint32);
232     function findPrevOrderId(uint128 srcAmount, uint128 dstAmount) public view returns(uint32);
233 
234     function addAfterId(address maker, uint32 orderId, uint128 srcAmount, uint128 dstAmount, uint32 prevId) public
235         returns (bool);
236 
237     function updateWithPositionHint(uint32 orderId, uint128 srcAmount, uint128 dstAmount, uint32 prevId) public
238         returns(bool, uint);
239 }
240 
241 // File: contracts/permissionless/OrderListFactoryInterface.sol
242 
243 interface OrderListFactoryInterface {
244     function newOrdersContract(address admin) public returns(OrderListInterface);
245 }
246 
247 // File: contracts/permissionless/OrderbookReserveInterface.sol
248 
249 interface OrderbookReserveInterface {
250     function init() public returns(bool);
251     function kncRateBlocksTrade() public view returns(bool);
252 }
253 
254 // File: contracts/permissionless/OrderbookReserve.sol
255 
256 contract FeeBurnerRateInterface {
257     uint public kncPerEthRatePrecision;
258 }
259 
260 
261 interface MedianizerInterface {
262     function peek() public view returns (bytes32, bool);
263 }
264 
265 
266 contract OrderbookReserve is OrderIdManager, Utils2, KyberReserveInterface, OrderbookReserveInterface {
267 
268     uint public constant BURN_TO_STAKE_FACTOR = 5;      // stake per order must be xfactor expected burn amount.
269     uint public constant MAX_BURN_FEE_BPS = 100;        // 1%
270     uint public constant MIN_REMAINING_ORDER_RATIO = 2; // Ratio between min new order value and min order value.
271     uint public constant MAX_USD_PER_ETH = 100000;      // Above this value price is surely compromised.
272 
273     uint32 constant public TAIL_ID = 1;         // tail Id in order list contract
274     uint32 constant public HEAD_ID = 2;         // head Id in order list contract
275 
276     struct OrderLimits {
277         uint minNewOrderSizeUsd; // Basis for setting min new order size Eth
278         uint maxOrdersPerTrade;     // Limit number of iterated orders per trade / getRate loops.
279         uint minNewOrderSizeWei;    // Below this value can't create new order.
280         uint minOrderSizeWei;       // below this value order will be removed.
281     }
282 
283     uint public kncPerEthBaseRatePrecision; // according to base rate all stakes are calculated.
284 
285     struct ExternalContracts {
286         ERC20 kncToken;          // not constant. to enable testing while not on main net
287         ERC20 token;             // only supported token.
288         FeeBurnerRateInterface feeBurner;
289         address kyberNetwork;
290         MedianizerInterface medianizer; // price feed Eth - USD from maker DAO.
291         OrderListFactoryInterface orderListFactory;
292     }
293 
294     //struct for getOrderData() return value. used only in memory.
295     struct OrderData {
296         address maker;
297         uint32 nextId;
298         bool isLastOrder;
299         uint128 srcAmount;
300         uint128 dstAmount;
301     }
302 
303     OrderLimits public limits;
304     ExternalContracts public contracts;
305 
306     // sorted lists of orders. one list for token to Eth, other for Eth to token.
307     // Each order is added in the correct position in the list to keep it sorted.
308     OrderListInterface public tokenToEthList;
309     OrderListInterface public ethToTokenList;
310 
311     //funds data
312     mapping(address => mapping(address => uint)) public makerFunds; // deposited maker funds.
313     mapping(address => uint) public makerKnc;            // for knc staking.
314     mapping(address => uint) public makerTotalOrdersWei; // per maker how many Wei in orders, for stake calculation.
315 
316     uint public makerBurnFeeBps;    // knc burn fee per order that is taken.
317 
318     //each maker will have orders that will be reused.
319     mapping(address => OrderIdData) public makerOrdersTokenToEth;
320     mapping(address => OrderIdData) public makerOrdersEthToToken;
321 
322     function OrderbookReserve(
323         ERC20 knc,
324         ERC20 reserveToken,
325         address burner,
326         address network,
327         MedianizerInterface medianizer,
328         OrderListFactoryInterface factory,
329         uint minNewOrderUsd,
330         uint maxOrdersPerTrade,
331         uint burnFeeBps
332     )
333         public
334     {
335 
336         require(knc != address(0));
337         require(reserveToken != address(0));
338         require(burner != address(0));
339         require(network != address(0));
340         require(medianizer != address(0));
341         require(factory != address(0));
342         require(burnFeeBps != 0);
343         require(burnFeeBps <= MAX_BURN_FEE_BPS);
344         require(maxOrdersPerTrade != 0);
345         require(minNewOrderUsd > 0);
346 
347         contracts.kyberNetwork = network;
348         contracts.feeBurner = FeeBurnerRateInterface(burner);
349         contracts.medianizer = medianizer;
350         contracts.orderListFactory = factory;
351         contracts.kncToken = knc;
352         contracts.token = reserveToken;
353 
354         makerBurnFeeBps = burnFeeBps;
355         limits.minNewOrderSizeUsd = minNewOrderUsd;
356         limits.maxOrdersPerTrade = maxOrdersPerTrade;
357 
358         require(setMinOrderSizeEth());
359     
360         require(contracts.kncToken.approve(contracts.feeBurner, (2**255)));
361 
362         //can only support tokens with decimals() API
363         setDecimals(contracts.token);
364 
365         kncPerEthBaseRatePrecision = contracts.feeBurner.kncPerEthRatePrecision();
366     }
367 
368     ///@dev separate init function for this contract, if this init is in the C'tor. gas consumption too high.
369     function init() public returns(bool) {
370         if ((tokenToEthList != address(0)) && (ethToTokenList != address(0))) return true;
371         if ((tokenToEthList != address(0)) || (ethToTokenList != address(0))) revert();
372 
373         tokenToEthList = contracts.orderListFactory.newOrdersContract(this);
374         ethToTokenList = contracts.orderListFactory.newOrdersContract(this);
375 
376         return true;
377     }
378 
379     function setKncPerEthBaseRate() public {
380         uint kncPerEthRatePrecision = contracts.feeBurner.kncPerEthRatePrecision();
381         if (kncPerEthRatePrecision < kncPerEthBaseRatePrecision) {
382             kncPerEthBaseRatePrecision = kncPerEthRatePrecision;
383         }
384     }
385 
386     function getConversionRate(ERC20 src, ERC20 dst, uint srcQty, uint blockNumber) public view returns(uint) {
387         require((src == ETH_TOKEN_ADDRESS) || (dst == ETH_TOKEN_ADDRESS));
388         require((src == contracts.token) || (dst == contracts.token));
389         require(srcQty <= MAX_QTY);
390 
391         if (kncRateBlocksTrade()) return 0;
392 
393         blockNumber; // in this reserve no order expiry == no use for blockNumber. here to avoid compiler warning.
394 
395         //user order ETH -> token is matched with maker order token -> ETH
396         OrderListInterface list = (src == ETH_TOKEN_ADDRESS) ? tokenToEthList : ethToTokenList;
397 
398         uint32 orderId;
399         OrderData memory orderData;
400 
401         uint128 userRemainingSrcQty = uint128(srcQty);
402         uint128 totalUserDstAmount = 0;
403         uint maxOrders = limits.maxOrdersPerTrade;
404 
405         for (
406             (orderId, orderData.isLastOrder) = list.getFirstOrder();
407             ((userRemainingSrcQty > 0) && (!orderData.isLastOrder) && (maxOrders-- > 0));
408             orderId = orderData.nextId
409         ) {
410             orderData = getOrderData(list, orderId);
411             // maker dst quantity is the requested quantity he wants to receive. user src quantity is what user gives.
412             // so user src quantity is matched with maker dst quantity
413             if (orderData.dstAmount <= userRemainingSrcQty) {
414                 totalUserDstAmount += orderData.srcAmount;
415                 userRemainingSrcQty -= orderData.dstAmount;
416             } else {
417                 totalUserDstAmount += uint128(uint(orderData.srcAmount) * uint(userRemainingSrcQty) /
418                     uint(orderData.dstAmount));
419                 userRemainingSrcQty = 0;
420             }
421         }
422 
423         if (userRemainingSrcQty != 0) return 0; //not enough tokens to exchange.
424 
425         return calcRateFromQty(srcQty, totalUserDstAmount, getDecimals(src), getDecimals(dst));
426     }
427 
428     event OrderbookReserveTrade(ERC20 srcToken, ERC20 dstToken, uint srcAmount, uint dstAmount);
429 
430     function trade(
431         ERC20 srcToken,
432         uint srcAmount,
433         ERC20 dstToken,
434         address dstAddress,
435         uint conversionRate,
436         bool validate
437     )
438         public
439         payable
440         returns(bool)
441     {
442         require(msg.sender == contracts.kyberNetwork);
443         require((srcToken == ETH_TOKEN_ADDRESS) || (dstToken == ETH_TOKEN_ADDRESS));
444         require((srcToken == contracts.token) || (dstToken == contracts.token));
445         require(srcAmount <= MAX_QTY);
446 
447         conversionRate;
448         validate;
449 
450         if (srcToken == ETH_TOKEN_ADDRESS) {
451             require(msg.value == srcAmount);
452         } else {
453             require(msg.value == 0);
454             require(srcToken.transferFrom(msg.sender, this, srcAmount));
455         }
456 
457         uint totalDstAmount = doTrade(
458                 srcToken,
459                 srcAmount,
460                 dstToken
461             );
462 
463         require(conversionRate <= calcRateFromQty(srcAmount, totalDstAmount, getDecimals(srcToken),
464             getDecimals(dstToken)));
465 
466         //all orders were successfully taken. send to dstAddress
467         if (dstToken == ETH_TOKEN_ADDRESS) {
468             dstAddress.transfer(totalDstAmount);
469         } else {
470             require(dstToken.transfer(dstAddress, totalDstAmount));
471         }
472 
473         OrderbookReserveTrade(srcToken, dstToken, srcAmount, totalDstAmount);
474         return true;
475     }
476 
477     function doTrade(
478         ERC20 srcToken,
479         uint srcAmount,
480         ERC20 dstToken
481     )
482         internal
483         returns(uint)
484     {
485         OrderListInterface list = (srcToken == ETH_TOKEN_ADDRESS) ? tokenToEthList : ethToTokenList;
486 
487         uint32 orderId;
488         OrderData memory orderData;
489         uint128 userRemainingSrcQty = uint128(srcAmount);
490         uint128 totalUserDstAmount = 0;
491 
492         for (
493             (orderId, orderData.isLastOrder) = list.getFirstOrder();
494             ((userRemainingSrcQty > 0) && (!orderData.isLastOrder));
495             orderId = orderData.nextId
496         ) {
497         // maker dst quantity is the requested quantity he wants to receive. user src quantity is what user gives.
498         // so user src quantity is matched with maker dst quantity
499             orderData = getOrderData(list, orderId);
500             if (orderData.dstAmount <= userRemainingSrcQty) {
501                 totalUserDstAmount += orderData.srcAmount;
502                 userRemainingSrcQty -= orderData.dstAmount;
503                 require(takeFullOrder({
504                     maker: orderData.maker,
505                     orderId: orderId,
506                     userSrc: srcToken,
507                     userDst: dstToken,
508                     userSrcAmount: orderData.dstAmount,
509                     userDstAmount: orderData.srcAmount
510                 }));
511             } else {
512                 uint128 partialDstQty = uint128(uint(orderData.srcAmount) * uint(userRemainingSrcQty) /
513                     uint(orderData.dstAmount));
514                 totalUserDstAmount += partialDstQty;
515                 require(takePartialOrder({
516                     maker: orderData.maker,
517                     orderId: orderId,
518                     userSrc: srcToken,
519                     userDst: dstToken,
520                     userPartialSrcAmount: userRemainingSrcQty,
521                     userTakeDstAmount: partialDstQty,
522                     orderSrcAmount: orderData.srcAmount,
523                     orderDstAmount: orderData.dstAmount
524                 }));
525                 userRemainingSrcQty = 0;
526             }
527         }
528 
529         require(userRemainingSrcQty == 0 && totalUserDstAmount > 0);
530 
531         return totalUserDstAmount;
532     }
533 
534     ///@param srcAmount is the token amount that will be payed. must be deposited before hand in the makers account.
535     ///@param dstAmount is the eth amount the maker expects to get for his tokens.
536     function submitTokenToEthOrder(uint128 srcAmount, uint128 dstAmount)
537         public
538         returns(bool)
539     {
540         return submitTokenToEthOrderWHint(srcAmount, dstAmount, 0);
541     }
542 
543     function submitTokenToEthOrderWHint(uint128 srcAmount, uint128 dstAmount, uint32 hintPrevOrder)
544         public
545         returns(bool)
546     {
547         uint32 newId = fetchNewOrderId(makerOrdersTokenToEth[msg.sender]);
548         return addOrder(false, newId, srcAmount, dstAmount, hintPrevOrder);
549     }
550 
551     ///@param srcAmount is the Ether amount that will be payed, must be deposited before hand.
552     ///@param dstAmount is the token amount the maker expects to get for his Ether.
553     function submitEthToTokenOrder(uint128 srcAmount, uint128 dstAmount)
554         public
555         returns(bool)
556     {
557         return submitEthToTokenOrderWHint(srcAmount, dstAmount, 0);
558     }
559 
560     function submitEthToTokenOrderWHint(uint128 srcAmount, uint128 dstAmount, uint32 hintPrevOrder)
561         public
562         returns(bool)
563     {
564         uint32 newId = fetchNewOrderId(makerOrdersEthToToken[msg.sender]);
565         return addOrder(true, newId, srcAmount, dstAmount, hintPrevOrder);
566     }
567 
568     ///@dev notice here a batch of orders represented in arrays. order x is represented by x cells of all arrays.
569     ///@dev all arrays expected to the same length.
570     ///@param isEthToToken per each order. is order x eth to token (= src is Eth) or vice versa.
571     ///@param srcAmount per each order. source amount for order x.
572     ///@param dstAmount per each order. destination amount for order x.
573     ///@param hintPrevOrder per each order what is the order it should be added after in ordered list. 0 for no hint.
574     ///@param isAfterPrevOrder per each order, set true if should be added in list right after previous added order.
575     function addOrderBatch(bool[] isEthToToken, uint128[] srcAmount, uint128[] dstAmount,
576         uint32[] hintPrevOrder, bool[] isAfterPrevOrder)
577         public
578         returns(bool)
579     {
580         require(isEthToToken.length == hintPrevOrder.length);
581         require(isEthToToken.length == dstAmount.length);
582         require(isEthToToken.length == srcAmount.length);
583         require(isEthToToken.length == isAfterPrevOrder.length);
584 
585         address maker = msg.sender;
586         uint32 prevId;
587         uint32 newId = 0;
588 
589         for (uint i = 0; i < isEthToToken.length; ++i) {
590             prevId = isAfterPrevOrder[i] ? newId : hintPrevOrder[i];
591             newId = fetchNewOrderId(isEthToToken[i] ? makerOrdersEthToToken[maker] : makerOrdersTokenToEth[maker]);
592             require(addOrder(isEthToToken[i], newId, srcAmount[i], dstAmount[i], prevId));
593         }
594 
595         return true;
596     }
597 
598     function updateTokenToEthOrder(uint32 orderId, uint128 newSrcAmount, uint128 newDstAmount)
599         public
600         returns(bool)
601     {
602         require(updateTokenToEthOrderWHint(orderId, newSrcAmount, newDstAmount, 0));
603         return true;
604     }
605 
606     function updateTokenToEthOrderWHint(
607         uint32 orderId,
608         uint128 newSrcAmount,
609         uint128 newDstAmount,
610         uint32 hintPrevOrder
611     )
612         public
613         returns(bool)
614     {
615         require(updateOrder(false, orderId, newSrcAmount, newDstAmount, hintPrevOrder));
616         return true;
617     }
618 
619     function updateEthToTokenOrder(uint32 orderId, uint128 newSrcAmount, uint128 newDstAmount)
620         public
621         returns(bool)
622     {
623         return updateEthToTokenOrderWHint(orderId, newSrcAmount, newDstAmount, 0);
624     }
625 
626     function updateEthToTokenOrderWHint(
627         uint32 orderId,
628         uint128 newSrcAmount,
629         uint128 newDstAmount,
630         uint32 hintPrevOrder
631     )
632         public
633         returns(bool)
634     {
635         require(updateOrder(true, orderId, newSrcAmount, newDstAmount, hintPrevOrder));
636         return true;
637     }
638 
639     function updateOrderBatch(bool[] isEthToToken, uint32[] orderId, uint128[] newSrcAmount,
640         uint128[] newDstAmount, uint32[] hintPrevOrder)
641         public
642         returns(bool)
643     {
644         require(isEthToToken.length == orderId.length);
645         require(isEthToToken.length == newSrcAmount.length);
646         require(isEthToToken.length == newDstAmount.length);
647         require(isEthToToken.length == hintPrevOrder.length);
648 
649         for (uint i = 0; i < isEthToToken.length; ++i) {
650             require(updateOrder(isEthToToken[i], orderId[i], newSrcAmount[i], newDstAmount[i],
651                 hintPrevOrder[i]));
652         }
653 
654         return true;
655     }
656 
657     event TokenDeposited(address indexed maker, uint amount);
658 
659     function depositToken(address maker, uint amount) public {
660         require(maker != address(0));
661         require(amount < MAX_QTY);
662 
663         require(contracts.token.transferFrom(msg.sender, this, amount));
664 
665         makerFunds[maker][contracts.token] += amount;
666         TokenDeposited(maker, amount);
667     }
668 
669     event EtherDeposited(address indexed maker, uint amount);
670 
671     function depositEther(address maker) public payable {
672         require(maker != address(0));
673 
674         makerFunds[maker][ETH_TOKEN_ADDRESS] += msg.value;
675         EtherDeposited(maker, msg.value);
676     }
677 
678     event KncFeeDeposited(address indexed maker, uint amount);
679 
680     // knc will be staked per order. part of the amount will be used as fee.
681     function depositKncForFee(address maker, uint amount) public {
682         require(maker != address(0));
683         require(amount < MAX_QTY);
684 
685         require(contracts.kncToken.transferFrom(msg.sender, this, amount));
686 
687         makerKnc[maker] += amount;
688 
689         KncFeeDeposited(maker, amount);
690 
691         if (orderAllocationRequired(makerOrdersTokenToEth[maker])) {
692             require(allocateOrderIds(
693                 makerOrdersTokenToEth[maker], /* makerOrders */
694                 tokenToEthList.allocateIds(uint32(NUM_ORDERS)) /* firstAllocatedId */
695             ));
696         }
697 
698         if (orderAllocationRequired(makerOrdersEthToToken[maker])) {
699             require(allocateOrderIds(
700                 makerOrdersEthToToken[maker], /* makerOrders */
701                 ethToTokenList.allocateIds(uint32(NUM_ORDERS)) /* firstAllocatedId */
702             ));
703         }
704     }
705 
706     function withdrawToken(uint amount) public {
707 
708         address maker = msg.sender;
709         uint makerFreeAmount = makerFunds[maker][contracts.token];
710 
711         require(makerFreeAmount >= amount);
712 
713         makerFunds[maker][contracts.token] -= amount;
714 
715         require(contracts.token.transfer(maker, amount));
716     }
717 
718     function withdrawEther(uint amount) public {
719 
720         address maker = msg.sender;
721         uint makerFreeAmount = makerFunds[maker][ETH_TOKEN_ADDRESS];
722 
723         require(makerFreeAmount >= amount);
724 
725         makerFunds[maker][ETH_TOKEN_ADDRESS] -= amount;
726 
727         maker.transfer(amount);
728     }
729 
730     function withdrawKncFee(uint amount) public {
731 
732         address maker = msg.sender;
733         
734         require(makerKnc[maker] >= amount);
735         require(makerUnlockedKnc(maker) >= amount);
736 
737         makerKnc[maker] -= amount;
738 
739         require(contracts.kncToken.transfer(maker, amount));
740     }
741 
742     function cancelTokenToEthOrder(uint32 orderId) public returns(bool) {
743         require(cancelOrder(false, orderId));
744         return true;
745     }
746 
747     function cancelEthToTokenOrder(uint32 orderId) public returns(bool) {
748         require(cancelOrder(true, orderId));
749         return true;
750     }
751 
752     function setMinOrderSizeEth() public returns(bool) {
753         //get eth to $ from maker dao;
754         bytes32 usdPerEthInWei;
755         bool valid;
756         (usdPerEthInWei, valid) = contracts.medianizer.peek();
757         require(valid);
758 
759         // ensuring that there is no underflow or overflow possible,
760         // even if the price is compromised
761         uint usdPerEth = uint(usdPerEthInWei) / (1 ether);
762         require(usdPerEth != 0);
763         require(usdPerEth < MAX_USD_PER_ETH);
764 
765         // set Eth order limits according to price
766         uint minNewOrderSizeWei = limits.minNewOrderSizeUsd * PRECISION * (1 ether) / uint(usdPerEthInWei);
767 
768         limits.minNewOrderSizeWei = minNewOrderSizeWei;
769         limits.minOrderSizeWei = limits.minNewOrderSizeWei / MIN_REMAINING_ORDER_RATIO;
770 
771         return true;
772     }
773 
774     ///@dev Each maker stakes per order KNC that is factor of the required burn amount.
775     ///@dev If Knc per Eth rate becomes lower by more then factor, stake will not be enough and trade will be blocked.
776     function kncRateBlocksTrade() public view returns (bool) {
777         return (contracts.feeBurner.kncPerEthRatePrecision() > kncPerEthBaseRatePrecision * BURN_TO_STAKE_FACTOR);
778     }
779 
780     function getTokenToEthAddOrderHint(uint128 srcAmount, uint128 dstAmount) public view returns (uint32) {
781         require(dstAmount >= limits.minNewOrderSizeWei);
782         return tokenToEthList.findPrevOrderId(srcAmount, dstAmount);
783     }
784 
785     function getEthToTokenAddOrderHint(uint128 srcAmount, uint128 dstAmount) public view returns (uint32) {
786         require(srcAmount >= limits.minNewOrderSizeWei);
787         return ethToTokenList.findPrevOrderId(srcAmount, dstAmount);
788     }
789 
790     function getTokenToEthUpdateOrderHint(uint32 orderId, uint128 srcAmount, uint128 dstAmount)
791         public
792         view
793         returns (uint32)
794     {
795         require(dstAmount >= limits.minNewOrderSizeWei);
796         uint32 prevId = tokenToEthList.findPrevOrderId(srcAmount, dstAmount);
797         address add;
798         uint128 noUse;
799         uint32 next;
800 
801         if (prevId == orderId) {
802             (add, noUse, noUse, prevId, next) = tokenToEthList.getOrderDetails(orderId);
803         }
804 
805         return prevId;
806     }
807 
808     function getEthToTokenUpdateOrderHint(uint32 orderId, uint128 srcAmount, uint128 dstAmount)
809         public
810         view
811         returns (uint32)
812     {
813         require(srcAmount >= limits.minNewOrderSizeWei);
814         uint32 prevId = ethToTokenList.findPrevOrderId(srcAmount, dstAmount);
815         address add;
816         uint128 noUse;
817         uint32 next;
818 
819         if (prevId == orderId) {
820             (add, noUse, noUse, prevId, next) = ethToTokenList.getOrderDetails(orderId);
821         }
822 
823         return prevId;
824     }
825 
826     function getTokenToEthOrder(uint32 orderId)
827         public view
828         returns (
829             address _maker,
830             uint128 _srcAmount,
831             uint128 _dstAmount,
832             uint32 _prevId,
833             uint32 _nextId
834         )
835     {
836         return tokenToEthList.getOrderDetails(orderId);
837     }
838 
839     function getEthToTokenOrder(uint32 orderId)
840         public view
841         returns (
842             address _maker,
843             uint128 _srcAmount,
844             uint128 _dstAmount,
845             uint32 _prevId,
846             uint32 _nextId
847         )
848     {
849         return ethToTokenList.getOrderDetails(orderId);
850     }
851 
852     function makerRequiredKncStake(address maker) public view returns (uint) {
853         return(calcKncStake(makerTotalOrdersWei[maker]));
854     }
855 
856     function makerUnlockedKnc(address maker) public view returns (uint) {
857         uint requiredKncStake = makerRequiredKncStake(maker);
858         if (requiredKncStake > makerKnc[maker]) return 0;
859         return (makerKnc[maker] - requiredKncStake);
860     }
861 
862     function calcKncStake(uint weiAmount) public view returns(uint) {
863         return(calcBurnAmount(weiAmount) * BURN_TO_STAKE_FACTOR);
864     }
865 
866     function calcBurnAmount(uint weiAmount) public view returns(uint) {
867         return(weiAmount * makerBurnFeeBps * kncPerEthBaseRatePrecision / (10000 * PRECISION));
868     }
869 
870     function calcBurnAmountFromFeeBurner(uint weiAmount) public view returns(uint) {
871         return(weiAmount * makerBurnFeeBps * contracts.feeBurner.kncPerEthRatePrecision() / (10000 * PRECISION));
872     }
873 
874     ///@dev This function is not fully optimized gas wise. Consider before calling on chain.
875     function getEthToTokenMakerOrderIds(address maker) public view returns(uint32[] orderList) {
876         OrderIdData storage makerOrders = makerOrdersEthToToken[maker];
877         orderList = new uint32[](getNumActiveOrderIds(makerOrders));
878         uint activeOrder = 0;
879 
880         for (uint32 i = 0; i < NUM_ORDERS; ++i) {
881             if ((makerOrders.takenBitmap & (uint(1) << i) > 0)) orderList[activeOrder++] = makerOrders.firstOrderId + i;
882         }
883     }
884 
885     ///@dev This function is not fully optimized gas wise. Consider before calling on chain.
886     function getTokenToEthMakerOrderIds(address maker) public view returns(uint32[] orderList) {
887         OrderIdData storage makerOrders = makerOrdersTokenToEth[maker];
888         orderList = new uint32[](getNumActiveOrderIds(makerOrders));
889         uint activeOrder = 0;
890 
891         for (uint32 i = 0; i < NUM_ORDERS; ++i) {
892             if ((makerOrders.takenBitmap & (uint(1) << i) > 0)) orderList[activeOrder++] = makerOrders.firstOrderId + i;
893         }
894     }
895 
896     ///@dev This function is not fully optimized gas wise. Consider before calling on chain.
897     function getEthToTokenOrderList() public view returns(uint32[] orderList) {
898         OrderListInterface list = ethToTokenList;
899         return getList(list);
900     }
901 
902     ///@dev This function is not fully optimized gas wise. Consider before calling on chain.
903     function getTokenToEthOrderList() public view returns(uint32[] orderList) {
904         OrderListInterface list = tokenToEthList;
905         return getList(list);
906     }
907 
908     event NewLimitOrder(
909         address indexed maker,
910         uint32 orderId,
911         bool isEthToToken,
912         uint128 srcAmount,
913         uint128 dstAmount,
914         bool addedWithHint
915     );
916 
917     function addOrder(bool isEthToToken, uint32 newId, uint128 srcAmount, uint128 dstAmount, uint32 hintPrevOrder)
918         internal
919         returns(bool)
920     {
921         require(srcAmount < MAX_QTY);
922         require(dstAmount < MAX_QTY);
923         address maker = msg.sender;
924 
925         require(secureAddOrderFunds(maker, isEthToToken, srcAmount, dstAmount));
926         require(validateLegalRate(srcAmount, dstAmount, isEthToToken));
927 
928         bool addedWithHint = false;
929         OrderListInterface list = isEthToToken ? ethToTokenList : tokenToEthList;
930 
931         if (hintPrevOrder != 0) {
932             addedWithHint = list.addAfterId(maker, newId, srcAmount, dstAmount, hintPrevOrder);
933         }
934 
935         if (!addedWithHint) {
936             require(list.add(maker, newId, srcAmount, dstAmount));
937         }
938 
939         NewLimitOrder(maker, newId, isEthToToken, srcAmount, dstAmount, addedWithHint);
940 
941         return true;
942     }
943 
944     event OrderUpdated(
945         address indexed maker,
946         bool isEthToToken,
947         uint orderId,
948         uint128 srcAmount,
949         uint128 dstAmount,
950         bool updatedWithHint
951     );
952 
953     function updateOrder(bool isEthToToken, uint32 orderId, uint128 newSrcAmount,
954         uint128 newDstAmount, uint32 hintPrevOrder)
955         internal
956         returns(bool)
957     {
958         require(newSrcAmount < MAX_QTY);
959         require(newDstAmount < MAX_QTY);
960         address maker;
961         uint128 currDstAmount;
962         uint128 currSrcAmount;
963         uint32 noUse;
964         uint noUse2;
965 
966         require(validateLegalRate(newSrcAmount, newDstAmount, isEthToToken));
967 
968         OrderListInterface list = isEthToToken ? ethToTokenList : tokenToEthList;
969 
970         (maker, currSrcAmount, currDstAmount, noUse, noUse) = list.getOrderDetails(orderId);
971         require(maker == msg.sender);
972 
973         if (!secureUpdateOrderFunds(maker, isEthToToken, currSrcAmount, currDstAmount, newSrcAmount, newDstAmount)) {
974             return false;
975         }
976 
977         bool updatedWithHint = false;
978 
979         if (hintPrevOrder != 0) {
980             (updatedWithHint, noUse2) = list.updateWithPositionHint(orderId, newSrcAmount, newDstAmount, hintPrevOrder);
981         }
982 
983         if (!updatedWithHint) {
984             require(list.update(orderId, newSrcAmount, newDstAmount));
985         }
986 
987         OrderUpdated(maker, isEthToToken, orderId, newSrcAmount, newDstAmount, updatedWithHint);
988 
989         return true;
990     }
991 
992     event OrderCanceled(address indexed maker, bool isEthToToken, uint32 orderId, uint128 srcAmount, uint dstAmount);
993 
994     function cancelOrder(bool isEthToToken, uint32 orderId) internal returns(bool) {
995 
996         address maker = msg.sender;
997         OrderListInterface list = isEthToToken ? ethToTokenList : tokenToEthList;
998         OrderData memory orderData = getOrderData(list, orderId);
999 
1000         require(orderData.maker == maker);
1001 
1002         uint weiAmount = isEthToToken ? orderData.srcAmount : orderData.dstAmount;
1003         require(releaseOrderStakes(maker, weiAmount, 0));
1004 
1005         require(removeOrder(list, maker, isEthToToken ? ETH_TOKEN_ADDRESS : contracts.token, orderId));
1006 
1007         //funds go back to makers account
1008         makerFunds[maker][isEthToToken ? ETH_TOKEN_ADDRESS : contracts.token] += orderData.srcAmount;
1009 
1010         OrderCanceled(maker, isEthToToken, orderId, orderData.srcAmount, orderData.dstAmount);
1011 
1012         return true;
1013     }
1014 
1015     ///@param maker is the maker of this order
1016     ///@param isEthToToken which order type the maker is updating / adding
1017     ///@param srcAmount is the orders src amount (token or ETH) could be negative if funds are released.
1018     function bindOrderFunds(address maker, bool isEthToToken, int srcAmount)
1019         internal
1020         returns(bool)
1021     {
1022         address fundsAddress = isEthToToken ? ETH_TOKEN_ADDRESS : contracts.token;
1023 
1024         if (srcAmount < 0) {
1025             makerFunds[maker][fundsAddress] += uint(-srcAmount);
1026         } else {
1027             require(makerFunds[maker][fundsAddress] >= uint(srcAmount));
1028             makerFunds[maker][fundsAddress] -= uint(srcAmount);
1029         }
1030 
1031         return true;
1032     }
1033 
1034     ///@param maker is the maker address
1035     ///@param weiAmount is the wei amount inside order that should result in knc staking
1036     function bindOrderStakes(address maker, int weiAmount) internal returns(bool) {
1037 
1038         if (weiAmount < 0) {
1039             uint decreaseWeiAmount = uint(-weiAmount);
1040             if (decreaseWeiAmount > makerTotalOrdersWei[maker]) decreaseWeiAmount = makerTotalOrdersWei[maker];
1041             makerTotalOrdersWei[maker] -= decreaseWeiAmount;
1042             return true;
1043         }
1044 
1045         require(makerKnc[maker] >= calcKncStake(makerTotalOrdersWei[maker] + uint(weiAmount)));
1046 
1047         makerTotalOrdersWei[maker] += uint(weiAmount);
1048 
1049         return true;
1050     }
1051 
1052     ///@dev if totalWeiAmount is 0 we only release stakes.
1053     ///@dev if totalWeiAmount == weiForBurn. all staked amount will be burned. so no knc returned to maker
1054     ///@param maker is the maker address
1055     ///@param totalWeiAmount is total wei amount that was released from order - including taken wei amount.
1056     ///@param weiForBurn is the part in order wei amount that was taken and should result in burning.
1057     function releaseOrderStakes(address maker, uint totalWeiAmount, uint weiForBurn) internal returns(bool) {
1058 
1059         require(weiForBurn <= totalWeiAmount);
1060 
1061         if (totalWeiAmount > makerTotalOrdersWei[maker]) {
1062             makerTotalOrdersWei[maker] = 0;
1063         } else {
1064             makerTotalOrdersWei[maker] -= totalWeiAmount;
1065         }
1066 
1067         if (weiForBurn == 0) return true;
1068 
1069         uint burnAmount = calcBurnAmountFromFeeBurner(weiForBurn);
1070 
1071         require(makerKnc[maker] >= burnAmount);
1072         makerKnc[maker] -= burnAmount;
1073 
1074         return true;
1075     }
1076 
1077     ///@dev funds are valid only when required knc amount can be staked for this order.
1078     function secureAddOrderFunds(address maker, bool isEthToToken, uint128 srcAmount, uint128 dstAmount)
1079         internal returns(bool)
1080     {
1081         uint weiAmount = isEthToToken ? srcAmount : dstAmount;
1082 
1083         require(weiAmount >= limits.minNewOrderSizeWei);
1084         require(bindOrderFunds(maker, isEthToToken, int(srcAmount)));
1085         require(bindOrderStakes(maker, int(weiAmount)));
1086 
1087         return true;
1088     }
1089 
1090     ///@dev funds are valid only when required knc amount can be staked for this order.
1091     function secureUpdateOrderFunds(address maker, bool isEthToToken, uint128 prevSrcAmount, uint128 prevDstAmount,
1092         uint128 newSrcAmount, uint128 newDstAmount)
1093         internal
1094         returns(bool)
1095     {
1096         uint weiAmount = isEthToToken ? newSrcAmount : newDstAmount;
1097         int weiDiff = isEthToToken ? (int(newSrcAmount) - int(prevSrcAmount)) :
1098             (int(newDstAmount) - int(prevDstAmount));
1099 
1100         require(weiAmount >= limits.minNewOrderSizeWei);
1101 
1102         require(bindOrderFunds(maker, isEthToToken, int(newSrcAmount) - int(prevSrcAmount)));
1103 
1104         require(bindOrderStakes(maker, weiDiff));
1105 
1106         return true;
1107     }
1108 
1109     event FullOrderTaken(address maker, uint32 orderId, bool isEthToToken);
1110 
1111     function takeFullOrder(
1112         address maker,
1113         uint32 orderId,
1114         ERC20 userSrc,
1115         ERC20 userDst,
1116         uint128 userSrcAmount,
1117         uint128 userDstAmount
1118     )
1119         internal
1120         returns (bool)
1121     {
1122         OrderListInterface list = (userSrc == ETH_TOKEN_ADDRESS) ? tokenToEthList : ethToTokenList;
1123 
1124         //userDst == maker source
1125         require(removeOrder(list, maker, userDst, orderId));
1126 
1127         FullOrderTaken(maker, orderId, userSrc == ETH_TOKEN_ADDRESS);
1128 
1129         return takeOrder(maker, userSrc, userSrcAmount, userDstAmount, 0);
1130     }
1131 
1132     event PartialOrderTaken(address maker, uint32 orderId, bool isEthToToken, bool isRemoved);
1133 
1134     function takePartialOrder(
1135         address maker,
1136         uint32 orderId,
1137         ERC20 userSrc,
1138         ERC20 userDst,
1139         uint128 userPartialSrcAmount,
1140         uint128 userTakeDstAmount,
1141         uint128 orderSrcAmount,
1142         uint128 orderDstAmount
1143     )
1144         internal
1145         returns(bool)
1146     {
1147         require(userPartialSrcAmount < orderDstAmount);
1148         require(userTakeDstAmount < orderSrcAmount);
1149 
1150         //must reuse parameters, otherwise stack too deep error.
1151         orderSrcAmount -= userTakeDstAmount;
1152         orderDstAmount -= userPartialSrcAmount;
1153 
1154         OrderListInterface list = (userSrc == ETH_TOKEN_ADDRESS) ? tokenToEthList : ethToTokenList;
1155         uint weiValueNotReleasedFromOrder = (userSrc == ETH_TOKEN_ADDRESS) ? orderDstAmount : orderSrcAmount;
1156         uint additionalReleasedWei = 0;
1157 
1158         if (weiValueNotReleasedFromOrder < limits.minOrderSizeWei) {
1159             // remaining order amount too small. remove order and add remaining funds to free funds
1160             makerFunds[maker][userDst] += orderSrcAmount;
1161             additionalReleasedWei = weiValueNotReleasedFromOrder;
1162 
1163             //for remove order we give makerSrc == userDst
1164             require(removeOrder(list, maker, userDst, orderId));
1165         } else {
1166             bool isSuccess;
1167 
1168             // update order values, taken order is always first order
1169             (isSuccess,) = list.updateWithPositionHint(orderId, orderSrcAmount, orderDstAmount, HEAD_ID);
1170             require(isSuccess);
1171         }
1172 
1173         PartialOrderTaken(maker, orderId, userSrc == ETH_TOKEN_ADDRESS, additionalReleasedWei > 0);
1174 
1175         //stakes are returned for unused wei value
1176         return(takeOrder(maker, userSrc, userPartialSrcAmount, userTakeDstAmount, additionalReleasedWei));
1177     }
1178     
1179     function takeOrder(
1180         address maker,
1181         ERC20 userSrc,
1182         uint userSrcAmount,
1183         uint userDstAmount,
1184         uint additionalReleasedWei
1185     )
1186         internal
1187         returns(bool)
1188     {
1189         uint weiAmount = userSrc == (ETH_TOKEN_ADDRESS) ? userSrcAmount : userDstAmount;
1190 
1191         //token / eth already collected. just update maker balance
1192         makerFunds[maker][userSrc] += userSrcAmount;
1193 
1194         // send dst tokens in one batch. not here
1195         //handle knc stakes and fee. releasedWeiValue was released and not traded.
1196         return releaseOrderStakes(maker, (weiAmount + additionalReleasedWei), weiAmount);
1197     }
1198 
1199     function removeOrder(
1200         OrderListInterface list,
1201         address maker,
1202         ERC20 makerSrc,
1203         uint32 orderId
1204     )
1205         internal returns(bool)
1206     {
1207         require(list.remove(orderId));
1208         OrderIdData storage orders = (makerSrc == ETH_TOKEN_ADDRESS) ?
1209             makerOrdersEthToToken[maker] : makerOrdersTokenToEth[maker];
1210         require(releaseOrderId(orders, orderId));
1211 
1212         return true;
1213     }
1214 
1215     function getList(OrderListInterface list) internal view returns(uint32[] memory orderList) {
1216         OrderData memory orderData;
1217         uint32 orderId;
1218         bool isEmpty;
1219 
1220         (orderId, isEmpty) = list.getFirstOrder();
1221         if (isEmpty) return(new uint32[](0));
1222 
1223         uint numOrders = 0;
1224 
1225         for (; !orderData.isLastOrder; orderId = orderData.nextId) {
1226             orderData = getOrderData(list, orderId);
1227             numOrders++;
1228         }
1229 
1230         orderList = new uint32[](numOrders);
1231 
1232         (orderId, orderData.isLastOrder) = list.getFirstOrder();
1233 
1234         for (uint i = 0; i < numOrders; i++) {
1235             orderList[i] = orderId;
1236             orderData = getOrderData(list, orderId);
1237             orderId = orderData.nextId;
1238         }
1239     }
1240 
1241     function getOrderData(OrderListInterface list, uint32 orderId) internal view returns (OrderData data) {
1242         uint32 prevId;
1243         (data.maker, data.srcAmount, data.dstAmount, prevId, data.nextId) = list.getOrderDetails(orderId);
1244         data.isLastOrder = (data.nextId == TAIL_ID);
1245     }
1246 
1247     function validateLegalRate (uint srcAmount, uint dstAmount, bool isEthToToken)
1248         internal view returns(bool)
1249     {
1250         uint rate;
1251 
1252         /// notice, rate is calculated from taker perspective,
1253         ///     for taker amounts are opposite. order srcAmount will be DstAmount for taker.
1254         if (isEthToToken) {
1255             rate = calcRateFromQty(dstAmount, srcAmount, getDecimals(contracts.token), ETH_DECIMALS);
1256         } else {
1257             rate = calcRateFromQty(dstAmount, srcAmount, ETH_DECIMALS, getDecimals(contracts.token));
1258         }
1259 
1260         if (rate > MAX_RATE) return false;
1261         return true;
1262     }
1263 }