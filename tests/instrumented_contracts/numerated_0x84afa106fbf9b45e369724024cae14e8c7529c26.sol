1 pragma solidity 0.4.18;
2 
3 // File: contracts/FeeBurnerInterface.sol
4 
5 interface FeeBurnerInterface {
6     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
7     function setReserveData(address reserve, uint feesInBps, address kncWallet) public;
8 }
9 
10 // File: contracts/ERC20Interface.sol
11 
12 // https://github.com/ethereum/EIPs/issues/20
13 interface ERC20 {
14     function totalSupply() public view returns (uint supply);
15     function balanceOf(address _owner) public view returns (uint balance);
16     function transfer(address _to, uint _value) public returns (bool success);
17     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
18     function approve(address _spender, uint _value) public returns (bool success);
19     function allowance(address _owner, address _spender) public view returns (uint remaining);
20     function decimals() public view returns(uint digits);
21     event Approval(address indexed _owner, address indexed _spender, uint _value);
22 }
23 
24 // File: contracts/KyberReserveInterface.sol
25 
26 /// @title Kyber Reserve contract
27 interface KyberReserveInterface {
28 
29     function trade(
30         ERC20 srcToken,
31         uint srcAmount,
32         ERC20 destToken,
33         address destAddress,
34         uint conversionRate,
35         bool validate
36     )
37         public
38         payable
39         returns(bool);
40 
41     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
42 }
43 
44 // File: contracts/Utils.sol
45 
46 /// @title Kyber constants contract
47 contract Utils {
48 
49     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
50     uint  constant internal PRECISION = (10**18);
51     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
52     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
53     uint  constant internal MAX_DECIMALS = 18;
54     uint  constant internal ETH_DECIMALS = 18;
55     mapping(address=>uint) internal decimals;
56 
57     function setDecimals(ERC20 token) internal {
58         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
59         else decimals[token] = token.decimals();
60     }
61 
62     function getDecimals(ERC20 token) internal view returns(uint) {
63         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
64         uint tokenDecimals = decimals[token];
65         // technically, there might be token with decimals 0
66         // moreover, very possible that old tokens have decimals 0
67         // these tokens will just have higher gas fees.
68         if(tokenDecimals == 0) return token.decimals();
69 
70         return tokenDecimals;
71     }
72 
73     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
74         require(srcQty <= MAX_QTY);
75         require(rate <= MAX_RATE);
76 
77         if (dstDecimals >= srcDecimals) {
78             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
79             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
80         } else {
81             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
82             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
83         }
84     }
85 
86     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
87         require(dstQty <= MAX_QTY);
88         require(rate <= MAX_RATE);
89         
90         //source quantity is rounded up. to avoid dest quantity being too low.
91         uint numerator;
92         uint denominator;
93         if (srcDecimals >= dstDecimals) {
94             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
95             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
96             denominator = rate;
97         } else {
98             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
99             numerator = (PRECISION * dstQty);
100             denominator = (rate * (10**(dstDecimals - srcDecimals)));
101         }
102         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
103     }
104 }
105 
106 // File: contracts/Utils2.sol
107 
108 contract Utils2 is Utils {
109 
110     /// @dev get the balance of a user.
111     /// @param token The token type
112     /// @return The balance
113     function getBalance(ERC20 token, address user) public view returns(uint) {
114         if (token == ETH_TOKEN_ADDRESS)
115             return user.balance;
116         else
117             return token.balanceOf(user);
118     }
119 
120     function getDecimalsSafe(ERC20 token) internal returns(uint) {
121 
122         if (decimals[token] == 0) {
123             setDecimals(token);
124         }
125 
126         return decimals[token];
127     }
128 
129     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
130         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
131     }
132 
133     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
134         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
135     }
136 
137     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
138         internal pure returns(uint)
139     {
140         require(srcAmount <= MAX_QTY);
141         require(destAmount <= MAX_QTY);
142 
143         if (dstDecimals >= srcDecimals) {
144             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
145             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
146         } else {
147             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
148             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
149         }
150     }
151 }
152 
153 // File: contracts/permissionless/OrderIdManager.sol
154 
155 contract OrderIdManager {
156     struct OrderIdData {
157         uint32 firstOrderId;
158         uint takenBitmap;
159     }
160 
161     uint constant public NUM_ORDERS = 32;
162 
163     function fetchNewOrderId(OrderIdData storage freeOrders)
164         internal
165         returns(uint32)
166     {
167         uint orderBitmap = freeOrders.takenBitmap;
168         uint bitPointer = 1;
169 
170         for (uint i = 0; i < NUM_ORDERS; ++i) {
171 
172             if ((orderBitmap & bitPointer) == 0) {
173                 freeOrders.takenBitmap = orderBitmap | bitPointer;
174                 return(uint32(uint(freeOrders.firstOrderId) + i));
175             }
176 
177             bitPointer *= 2;
178         }
179 
180         revert();
181     }
182 
183     /// @dev mark order as free to use.
184     function releaseOrderId(OrderIdData storage freeOrders, uint32 orderId)
185         internal
186         returns(bool)
187     {
188         require(orderId >= freeOrders.firstOrderId);
189         require(orderId < (freeOrders.firstOrderId + NUM_ORDERS));
190 
191         uint orderBitNum = uint(orderId) - uint(freeOrders.firstOrderId);
192         uint bitPointer = uint(1) << orderBitNum;
193 
194         require(bitPointer & freeOrders.takenBitmap > 0);
195 
196         freeOrders.takenBitmap &= ~bitPointer;
197         return true;
198     }
199 
200     function allocateOrderIds(
201         OrderIdData storage makerOrders,
202         uint32 firstAllocatedId
203     )
204         internal
205         returns(bool)
206     {
207         if (makerOrders.firstOrderId > 0) {
208             return false;
209         }
210 
211         makerOrders.firstOrderId = firstAllocatedId;
212         makerOrders.takenBitmap = 0;
213 
214         return true;
215     }
216 
217     function orderAllocationRequired(OrderIdData storage freeOrders) internal view returns (bool) {
218 
219         if (freeOrders.firstOrderId == 0) return true;
220         return false;
221     }
222 
223     function getNumActiveOrderIds(OrderIdData storage makerOrders) internal view returns (uint numActiveOrders) {
224         for (uint i = 0; i < NUM_ORDERS; ++i) {
225             if ((makerOrders.takenBitmap & (uint(1) << i)) > 0) numActiveOrders++;
226         }
227     }
228 }
229 
230 // File: contracts/permissionless/OrderListInterface.sol
231 
232 interface OrderListInterface {
233     function getOrderDetails(uint32 orderId) public view returns (address, uint128, uint128, uint32, uint32);
234     function add(address maker, uint32 orderId, uint128 srcAmount, uint128 dstAmount) public returns (bool);
235     function remove(uint32 orderId) public returns (bool);
236     function update(uint32 orderId, uint128 srcAmount, uint128 dstAmount) public returns (bool);
237     function getFirstOrder() public view returns(uint32 orderId, bool isEmpty);
238     function allocateIds(uint32 howMany) public returns(uint32);
239     function findPrevOrderId(uint128 srcAmount, uint128 dstAmount) public view returns(uint32);
240 
241     function addAfterId(address maker, uint32 orderId, uint128 srcAmount, uint128 dstAmount, uint32 prevId) public
242         returns (bool);
243 
244     function updateWithPositionHint(uint32 orderId, uint128 srcAmount, uint128 dstAmount, uint32 prevId) public
245         returns(bool, uint);
246 }
247 
248 // File: contracts/permissionless/OrderListFactoryInterface.sol
249 
250 interface OrderListFactoryInterface {
251     function newOrdersContract(address admin) public returns(OrderListInterface);
252 }
253 
254 // File: contracts/permissionless/OrderbookReserveInterface.sol
255 
256 interface OrderbookReserveInterface {
257     function init() public returns(bool);
258     function kncRateBlocksTrade() public view returns(bool);
259 }
260 
261 // File: contracts/permissionless/OrderbookReserve.sol
262 
263 contract FeeBurnerRateInterface {
264     uint public kncPerEthRatePrecision;
265 }
266 
267 
268 interface MedianizerInterface {
269     function peek() public view returns (bytes32, bool);
270 }
271 
272 
273 contract OrderbookReserve is OrderIdManager, Utils2, KyberReserveInterface, OrderbookReserveInterface {
274 
275     uint public constant BURN_TO_STAKE_FACTOR = 5;      // stake per order must be xfactor expected burn amount.
276     uint public constant MAX_BURN_FEE_BPS = 100;        // 1%
277     uint public constant MIN_REMAINING_ORDER_RATIO = 2; // Ratio between min new order value and min order value.
278     uint public constant MAX_USD_PER_ETH = 100000;      // Above this value price is surely compromised.
279 
280     uint32 constant public TAIL_ID = 1;         // tail Id in order list contract
281     uint32 constant public HEAD_ID = 2;         // head Id in order list contract
282 
283     struct OrderLimits {
284         uint minNewOrderSizeUsd; // Basis for setting min new order size Eth
285         uint maxOrdersPerTrade;     // Limit number of iterated orders per trade / getRate loops.
286         uint minNewOrderSizeWei;    // Below this value can't create new order.
287         uint minOrderSizeWei;       // below this value order will be removed.
288     }
289 
290     uint public kncPerEthBaseRatePrecision; // according to base rate all stakes are calculated.
291 
292     struct ExternalContracts {
293         ERC20 kncToken;          // not constant. to enable testing while not on main net
294         ERC20 token;             // only supported token.
295         FeeBurnerRateInterface feeBurner;
296         address kyberNetwork;
297         MedianizerInterface medianizer; // price feed Eth - USD from maker DAO.
298         OrderListFactoryInterface orderListFactory;
299     }
300 
301     //struct for getOrderData() return value. used only in memory.
302     struct OrderData {
303         address maker;
304         uint32 nextId;
305         bool isLastOrder;
306         uint128 srcAmount;
307         uint128 dstAmount;
308     }
309 
310     OrderLimits public limits;
311     ExternalContracts public contracts;
312 
313     // sorted lists of orders. one list for token to Eth, other for Eth to token.
314     // Each order is added in the correct position in the list to keep it sorted.
315     OrderListInterface public tokenToEthList;
316     OrderListInterface public ethToTokenList;
317 
318     //funds data
319     mapping(address => mapping(address => uint)) public makerFunds; // deposited maker funds.
320     mapping(address => uint) public makerKnc;            // for knc staking.
321     mapping(address => uint) public makerTotalOrdersWei; // per maker how many Wei in orders, for stake calculation.
322 
323     uint public makerBurnFeeBps;    // knc burn fee per order that is taken.
324 
325     //each maker will have orders that will be reused.
326     mapping(address => OrderIdData) public makerOrdersTokenToEth;
327     mapping(address => OrderIdData) public makerOrdersEthToToken;
328 
329     function OrderbookReserve(
330         ERC20 knc,
331         ERC20 reserveToken,
332         address burner,
333         address network,
334         MedianizerInterface medianizer,
335         OrderListFactoryInterface factory,
336         uint minNewOrderUsd,
337         uint maxOrdersPerTrade,
338         uint burnFeeBps
339     )
340         public
341     {
342 
343         require(knc != address(0));
344         require(reserveToken != address(0));
345         require(burner != address(0));
346         require(network != address(0));
347         require(medianizer != address(0));
348         require(factory != address(0));
349         require(burnFeeBps != 0);
350         require(burnFeeBps <= MAX_BURN_FEE_BPS);
351         require(maxOrdersPerTrade != 0);
352         require(minNewOrderUsd > 0);
353 
354         contracts.kyberNetwork = network;
355         contracts.feeBurner = FeeBurnerRateInterface(burner);
356         contracts.medianizer = medianizer;
357         contracts.orderListFactory = factory;
358         contracts.kncToken = knc;
359         contracts.token = reserveToken;
360 
361         makerBurnFeeBps = burnFeeBps;
362         limits.minNewOrderSizeUsd = minNewOrderUsd;
363         limits.maxOrdersPerTrade = maxOrdersPerTrade;
364 
365         require(setMinOrderSizeEth());
366     
367         require(contracts.kncToken.approve(contracts.feeBurner, (2**255)));
368 
369         //can only support tokens with decimals() API
370         setDecimals(contracts.token);
371 
372         kncPerEthBaseRatePrecision = contracts.feeBurner.kncPerEthRatePrecision();
373     }
374 
375     ///@dev separate init function for this contract, if this init is in the C'tor. gas consumption too high.
376     function init() public returns(bool) {
377         if ((tokenToEthList != address(0)) && (ethToTokenList != address(0))) return true;
378         if ((tokenToEthList != address(0)) || (ethToTokenList != address(0))) revert();
379 
380         tokenToEthList = contracts.orderListFactory.newOrdersContract(this);
381         ethToTokenList = contracts.orderListFactory.newOrdersContract(this);
382 
383         return true;
384     }
385 
386     function setKncPerEthBaseRate() public {
387         uint kncPerEthRatePrecision = contracts.feeBurner.kncPerEthRatePrecision();
388         if (kncPerEthRatePrecision < kncPerEthBaseRatePrecision) {
389             kncPerEthBaseRatePrecision = kncPerEthRatePrecision;
390         }
391     }
392 
393     function getConversionRate(ERC20 src, ERC20 dst, uint srcQty, uint blockNumber) public view returns(uint) {
394         require((src == ETH_TOKEN_ADDRESS) || (dst == ETH_TOKEN_ADDRESS));
395         require((src == contracts.token) || (dst == contracts.token));
396         require(srcQty <= MAX_QTY);
397 
398         if (kncRateBlocksTrade()) return 0;
399 
400         blockNumber; // in this reserve no order expiry == no use for blockNumber. here to avoid compiler warning.
401 
402         //user order ETH -> token is matched with maker order token -> ETH
403         OrderListInterface list = (src == ETH_TOKEN_ADDRESS) ? tokenToEthList : ethToTokenList;
404 
405         uint32 orderId;
406         OrderData memory orderData;
407 
408         uint128 userRemainingSrcQty = uint128(srcQty);
409         uint128 totalUserDstAmount = 0;
410         uint maxOrders = limits.maxOrdersPerTrade;
411 
412         for (
413             (orderId, orderData.isLastOrder) = list.getFirstOrder();
414             ((userRemainingSrcQty > 0) && (!orderData.isLastOrder) && (maxOrders-- > 0));
415             orderId = orderData.nextId
416         ) {
417             orderData = getOrderData(list, orderId);
418             // maker dst quantity is the requested quantity he wants to receive. user src quantity is what user gives.
419             // so user src quantity is matched with maker dst quantity
420             if (orderData.dstAmount <= userRemainingSrcQty) {
421                 totalUserDstAmount += orderData.srcAmount;
422                 userRemainingSrcQty -= orderData.dstAmount;
423             } else {
424                 totalUserDstAmount += uint128(uint(orderData.srcAmount) * uint(userRemainingSrcQty) /
425                     uint(orderData.dstAmount));
426                 userRemainingSrcQty = 0;
427             }
428         }
429 
430         if (userRemainingSrcQty != 0) return 0; //not enough tokens to exchange.
431 
432         return calcRateFromQty(srcQty, totalUserDstAmount, getDecimals(src), getDecimals(dst));
433     }
434 
435     event OrderbookReserveTrade(ERC20 srcToken, ERC20 dstToken, uint srcAmount, uint dstAmount);
436 
437     function trade(
438         ERC20 srcToken,
439         uint srcAmount,
440         ERC20 dstToken,
441         address dstAddress,
442         uint conversionRate,
443         bool validate
444     )
445         public
446         payable
447         returns(bool)
448     {
449         require(msg.sender == contracts.kyberNetwork);
450         require((srcToken == ETH_TOKEN_ADDRESS) || (dstToken == ETH_TOKEN_ADDRESS));
451         require((srcToken == contracts.token) || (dstToken == contracts.token));
452         require(srcAmount <= MAX_QTY);
453 
454         conversionRate;
455         validate;
456 
457         if (srcToken == ETH_TOKEN_ADDRESS) {
458             require(msg.value == srcAmount);
459         } else {
460             require(msg.value == 0);
461             require(srcToken.transferFrom(msg.sender, this, srcAmount));
462         }
463 
464         uint totalDstAmount = doTrade(
465                 srcToken,
466                 srcAmount,
467                 dstToken
468             );
469 
470         require(conversionRate <= calcRateFromQty(srcAmount, totalDstAmount, getDecimals(srcToken),
471             getDecimals(dstToken)));
472 
473         //all orders were successfully taken. send to dstAddress
474         if (dstToken == ETH_TOKEN_ADDRESS) {
475             dstAddress.transfer(totalDstAmount);
476         } else {
477             require(dstToken.transfer(dstAddress, totalDstAmount));
478         }
479 
480         OrderbookReserveTrade(srcToken, dstToken, srcAmount, totalDstAmount);
481         return true;
482     }
483 
484     function doTrade(
485         ERC20 srcToken,
486         uint srcAmount,
487         ERC20 dstToken
488     )
489         internal
490         returns(uint)
491     {
492         OrderListInterface list = (srcToken == ETH_TOKEN_ADDRESS) ? tokenToEthList : ethToTokenList;
493 
494         uint32 orderId;
495         OrderData memory orderData;
496         uint128 userRemainingSrcQty = uint128(srcAmount);
497         uint128 totalUserDstAmount = 0;
498 
499         for (
500             (orderId, orderData.isLastOrder) = list.getFirstOrder();
501             ((userRemainingSrcQty > 0) && (!orderData.isLastOrder));
502             orderId = orderData.nextId
503         ) {
504         // maker dst quantity is the requested quantity he wants to receive. user src quantity is what user gives.
505         // so user src quantity is matched with maker dst quantity
506             orderData = getOrderData(list, orderId);
507             if (orderData.dstAmount <= userRemainingSrcQty) {
508                 totalUserDstAmount += orderData.srcAmount;
509                 userRemainingSrcQty -= orderData.dstAmount;
510                 require(takeFullOrder({
511                     maker: orderData.maker,
512                     orderId: orderId,
513                     userSrc: srcToken,
514                     userDst: dstToken,
515                     userSrcAmount: orderData.dstAmount,
516                     userDstAmount: orderData.srcAmount
517                 }));
518             } else {
519                 uint128 partialDstQty = uint128(uint(orderData.srcAmount) * uint(userRemainingSrcQty) /
520                     uint(orderData.dstAmount));
521                 totalUserDstAmount += partialDstQty;
522                 require(takePartialOrder({
523                     maker: orderData.maker,
524                     orderId: orderId,
525                     userSrc: srcToken,
526                     userDst: dstToken,
527                     userPartialSrcAmount: userRemainingSrcQty,
528                     userTakeDstAmount: partialDstQty,
529                     orderSrcAmount: orderData.srcAmount,
530                     orderDstAmount: orderData.dstAmount
531                 }));
532                 userRemainingSrcQty = 0;
533             }
534         }
535 
536         require(userRemainingSrcQty == 0 && totalUserDstAmount > 0);
537 
538         return totalUserDstAmount;
539     }
540 
541     ///@param srcAmount is the token amount that will be payed. must be deposited before hand in the makers account.
542     ///@param dstAmount is the eth amount the maker expects to get for his tokens.
543     function submitTokenToEthOrder(uint128 srcAmount, uint128 dstAmount)
544         public
545         returns(bool)
546     {
547         return submitTokenToEthOrderWHint(srcAmount, dstAmount, 0);
548     }
549 
550     function submitTokenToEthOrderWHint(uint128 srcAmount, uint128 dstAmount, uint32 hintPrevOrder)
551         public
552         returns(bool)
553     {
554         uint32 newId = fetchNewOrderId(makerOrdersTokenToEth[msg.sender]);
555         return addOrder(false, newId, srcAmount, dstAmount, hintPrevOrder);
556     }
557 
558     ///@param srcAmount is the Ether amount that will be payed, must be deposited before hand.
559     ///@param dstAmount is the token amount the maker expects to get for his Ether.
560     function submitEthToTokenOrder(uint128 srcAmount, uint128 dstAmount)
561         public
562         returns(bool)
563     {
564         return submitEthToTokenOrderWHint(srcAmount, dstAmount, 0);
565     }
566 
567     function submitEthToTokenOrderWHint(uint128 srcAmount, uint128 dstAmount, uint32 hintPrevOrder)
568         public
569         returns(bool)
570     {
571         uint32 newId = fetchNewOrderId(makerOrdersEthToToken[msg.sender]);
572         return addOrder(true, newId, srcAmount, dstAmount, hintPrevOrder);
573     }
574 
575     ///@dev notice here a batch of orders represented in arrays. order x is represented by x cells of all arrays.
576     ///@dev all arrays expected to the same length.
577     ///@param isEthToToken per each order. is order x eth to token (= src is Eth) or vice versa.
578     ///@param srcAmount per each order. source amount for order x.
579     ///@param dstAmount per each order. destination amount for order x.
580     ///@param hintPrevOrder per each order what is the order it should be added after in ordered list. 0 for no hint.
581     ///@param isAfterPrevOrder per each order, set true if should be added in list right after previous added order.
582     function addOrderBatch(bool[] isEthToToken, uint128[] srcAmount, uint128[] dstAmount,
583         uint32[] hintPrevOrder, bool[] isAfterPrevOrder)
584         public
585         returns(bool)
586     {
587         require(isEthToToken.length == hintPrevOrder.length);
588         require(isEthToToken.length == dstAmount.length);
589         require(isEthToToken.length == srcAmount.length);
590         require(isEthToToken.length == isAfterPrevOrder.length);
591 
592         address maker = msg.sender;
593         uint32 prevId;
594         uint32 newId = 0;
595 
596         for (uint i = 0; i < isEthToToken.length; ++i) {
597             prevId = isAfterPrevOrder[i] ? newId : hintPrevOrder[i];
598             newId = fetchNewOrderId(isEthToToken[i] ? makerOrdersEthToToken[maker] : makerOrdersTokenToEth[maker]);
599             require(addOrder(isEthToToken[i], newId, srcAmount[i], dstAmount[i], prevId));
600         }
601 
602         return true;
603     }
604 
605     function updateTokenToEthOrder(uint32 orderId, uint128 newSrcAmount, uint128 newDstAmount)
606         public
607         returns(bool)
608     {
609         require(updateTokenToEthOrderWHint(orderId, newSrcAmount, newDstAmount, 0));
610         return true;
611     }
612 
613     function updateTokenToEthOrderWHint(
614         uint32 orderId,
615         uint128 newSrcAmount,
616         uint128 newDstAmount,
617         uint32 hintPrevOrder
618     )
619         public
620         returns(bool)
621     {
622         require(updateOrder(false, orderId, newSrcAmount, newDstAmount, hintPrevOrder));
623         return true;
624     }
625 
626     function updateEthToTokenOrder(uint32 orderId, uint128 newSrcAmount, uint128 newDstAmount)
627         public
628         returns(bool)
629     {
630         return updateEthToTokenOrderWHint(orderId, newSrcAmount, newDstAmount, 0);
631     }
632 
633     function updateEthToTokenOrderWHint(
634         uint32 orderId,
635         uint128 newSrcAmount,
636         uint128 newDstAmount,
637         uint32 hintPrevOrder
638     )
639         public
640         returns(bool)
641     {
642         require(updateOrder(true, orderId, newSrcAmount, newDstAmount, hintPrevOrder));
643         return true;
644     }
645 
646     function updateOrderBatch(bool[] isEthToToken, uint32[] orderId, uint128[] newSrcAmount,
647         uint128[] newDstAmount, uint32[] hintPrevOrder)
648         public
649         returns(bool)
650     {
651         require(isEthToToken.length == orderId.length);
652         require(isEthToToken.length == newSrcAmount.length);
653         require(isEthToToken.length == newDstAmount.length);
654         require(isEthToToken.length == hintPrevOrder.length);
655 
656         for (uint i = 0; i < isEthToToken.length; ++i) {
657             require(updateOrder(isEthToToken[i], orderId[i], newSrcAmount[i], newDstAmount[i],
658                 hintPrevOrder[i]));
659         }
660 
661         return true;
662     }
663 
664     event TokenDeposited(address indexed maker, uint amount);
665 
666     function depositToken(address maker, uint amount) public {
667         require(maker != address(0));
668         require(amount < MAX_QTY);
669 
670         require(contracts.token.transferFrom(msg.sender, this, amount));
671 
672         makerFunds[maker][contracts.token] += amount;
673         TokenDeposited(maker, amount);
674     }
675 
676     event EtherDeposited(address indexed maker, uint amount);
677 
678     function depositEther(address maker) public payable {
679         require(maker != address(0));
680 
681         makerFunds[maker][ETH_TOKEN_ADDRESS] += msg.value;
682         EtherDeposited(maker, msg.value);
683     }
684 
685     event KncFeeDeposited(address indexed maker, uint amount);
686 
687     // knc will be staked per order. part of the amount will be used as fee.
688     function depositKncForFee(address maker, uint amount) public {
689         require(maker != address(0));
690         require(amount < MAX_QTY);
691 
692         require(contracts.kncToken.transferFrom(msg.sender, this, amount));
693 
694         makerKnc[maker] += amount;
695 
696         KncFeeDeposited(maker, amount);
697 
698         if (orderAllocationRequired(makerOrdersTokenToEth[maker])) {
699             require(allocateOrderIds(
700                 makerOrdersTokenToEth[maker], /* makerOrders */
701                 tokenToEthList.allocateIds(uint32(NUM_ORDERS)) /* firstAllocatedId */
702             ));
703         }
704 
705         if (orderAllocationRequired(makerOrdersEthToToken[maker])) {
706             require(allocateOrderIds(
707                 makerOrdersEthToToken[maker], /* makerOrders */
708                 ethToTokenList.allocateIds(uint32(NUM_ORDERS)) /* firstAllocatedId */
709             ));
710         }
711     }
712 
713     function withdrawToken(uint amount) public {
714 
715         address maker = msg.sender;
716         uint makerFreeAmount = makerFunds[maker][contracts.token];
717 
718         require(makerFreeAmount >= amount);
719 
720         makerFunds[maker][contracts.token] -= amount;
721 
722         require(contracts.token.transfer(maker, amount));
723     }
724 
725     function withdrawEther(uint amount) public {
726 
727         address maker = msg.sender;
728         uint makerFreeAmount = makerFunds[maker][ETH_TOKEN_ADDRESS];
729 
730         require(makerFreeAmount >= amount);
731 
732         makerFunds[maker][ETH_TOKEN_ADDRESS] -= amount;
733 
734         maker.transfer(amount);
735     }
736 
737     function withdrawKncFee(uint amount) public {
738 
739         address maker = msg.sender;
740         
741         require(makerKnc[maker] >= amount);
742         require(makerUnlockedKnc(maker) >= amount);
743 
744         makerKnc[maker] -= amount;
745 
746         require(contracts.kncToken.transfer(maker, amount));
747     }
748 
749     function cancelTokenToEthOrder(uint32 orderId) public returns(bool) {
750         require(cancelOrder(false, orderId));
751         return true;
752     }
753 
754     function cancelEthToTokenOrder(uint32 orderId) public returns(bool) {
755         require(cancelOrder(true, orderId));
756         return true;
757     }
758 
759     function setMinOrderSizeEth() public returns(bool) {
760         //get eth to $ from maker dao;
761         bytes32 usdPerEthInWei;
762         bool valid;
763         (usdPerEthInWei, valid) = contracts.medianizer.peek();
764         require(valid);
765 
766         // ensuring that there is no underflow or overflow possible,
767         // even if the price is compromised
768         uint usdPerEth = uint(usdPerEthInWei) / (1 ether);
769         require(usdPerEth != 0);
770         require(usdPerEth < MAX_USD_PER_ETH);
771 
772         // set Eth order limits according to price
773         uint minNewOrderSizeWei = limits.minNewOrderSizeUsd * PRECISION * (1 ether) / uint(usdPerEthInWei);
774 
775         limits.minNewOrderSizeWei = minNewOrderSizeWei;
776         limits.minOrderSizeWei = limits.minNewOrderSizeWei / MIN_REMAINING_ORDER_RATIO;
777 
778         return true;
779     }
780 
781     ///@dev Each maker stakes per order KNC that is factor of the required burn amount.
782     ///@dev If Knc per Eth rate becomes lower by more then factor, stake will not be enough and trade will be blocked.
783     function kncRateBlocksTrade() public view returns (bool) {
784         return (contracts.feeBurner.kncPerEthRatePrecision() > kncPerEthBaseRatePrecision * BURN_TO_STAKE_FACTOR);
785     }
786 
787     function getTokenToEthAddOrderHint(uint128 srcAmount, uint128 dstAmount) public view returns (uint32) {
788         require(dstAmount >= limits.minNewOrderSizeWei);
789         return tokenToEthList.findPrevOrderId(srcAmount, dstAmount);
790     }
791 
792     function getEthToTokenAddOrderHint(uint128 srcAmount, uint128 dstAmount) public view returns (uint32) {
793         require(srcAmount >= limits.minNewOrderSizeWei);
794         return ethToTokenList.findPrevOrderId(srcAmount, dstAmount);
795     }
796 
797     function getTokenToEthUpdateOrderHint(uint32 orderId, uint128 srcAmount, uint128 dstAmount)
798         public
799         view
800         returns (uint32)
801     {
802         require(dstAmount >= limits.minNewOrderSizeWei);
803         uint32 prevId = tokenToEthList.findPrevOrderId(srcAmount, dstAmount);
804         address add;
805         uint128 noUse;
806         uint32 next;
807 
808         if (prevId == orderId) {
809             (add, noUse, noUse, prevId, next) = tokenToEthList.getOrderDetails(orderId);
810         }
811 
812         return prevId;
813     }
814 
815     function getEthToTokenUpdateOrderHint(uint32 orderId, uint128 srcAmount, uint128 dstAmount)
816         public
817         view
818         returns (uint32)
819     {
820         require(srcAmount >= limits.minNewOrderSizeWei);
821         uint32 prevId = ethToTokenList.findPrevOrderId(srcAmount, dstAmount);
822         address add;
823         uint128 noUse;
824         uint32 next;
825 
826         if (prevId == orderId) {
827             (add, noUse, noUse, prevId, next) = ethToTokenList.getOrderDetails(orderId);
828         }
829 
830         return prevId;
831     }
832 
833     function getTokenToEthOrder(uint32 orderId)
834         public view
835         returns (
836             address _maker,
837             uint128 _srcAmount,
838             uint128 _dstAmount,
839             uint32 _prevId,
840             uint32 _nextId
841         )
842     {
843         return tokenToEthList.getOrderDetails(orderId);
844     }
845 
846     function getEthToTokenOrder(uint32 orderId)
847         public view
848         returns (
849             address _maker,
850             uint128 _srcAmount,
851             uint128 _dstAmount,
852             uint32 _prevId,
853             uint32 _nextId
854         )
855     {
856         return ethToTokenList.getOrderDetails(orderId);
857     }
858 
859     function makerRequiredKncStake(address maker) public view returns (uint) {
860         return(calcKncStake(makerTotalOrdersWei[maker]));
861     }
862 
863     function makerUnlockedKnc(address maker) public view returns (uint) {
864         uint requiredKncStake = makerRequiredKncStake(maker);
865         if (requiredKncStake > makerKnc[maker]) return 0;
866         return (makerKnc[maker] - requiredKncStake);
867     }
868 
869     function calcKncStake(uint weiAmount) public view returns(uint) {
870         return(calcBurnAmount(weiAmount) * BURN_TO_STAKE_FACTOR);
871     }
872 
873     function calcBurnAmount(uint weiAmount) public view returns(uint) {
874         return(weiAmount * makerBurnFeeBps * kncPerEthBaseRatePrecision / (10000 * PRECISION));
875     }
876 
877     function calcBurnAmountFromFeeBurner(uint weiAmount) public view returns(uint) {
878         return(weiAmount * makerBurnFeeBps * contracts.feeBurner.kncPerEthRatePrecision() / (10000 * PRECISION));
879     }
880 
881     ///@dev This function is not fully optimized gas wise. Consider before calling on chain.
882     function getEthToTokenMakerOrderIds(address maker) public view returns(uint32[] orderList) {
883         OrderIdData storage makerOrders = makerOrdersEthToToken[maker];
884         orderList = new uint32[](getNumActiveOrderIds(makerOrders));
885         uint activeOrder = 0;
886 
887         for (uint32 i = 0; i < NUM_ORDERS; ++i) {
888             if ((makerOrders.takenBitmap & (uint(1) << i) > 0)) orderList[activeOrder++] = makerOrders.firstOrderId + i;
889         }
890     }
891 
892     ///@dev This function is not fully optimized gas wise. Consider before calling on chain.
893     function getTokenToEthMakerOrderIds(address maker) public view returns(uint32[] orderList) {
894         OrderIdData storage makerOrders = makerOrdersTokenToEth[maker];
895         orderList = new uint32[](getNumActiveOrderIds(makerOrders));
896         uint activeOrder = 0;
897 
898         for (uint32 i = 0; i < NUM_ORDERS; ++i) {
899             if ((makerOrders.takenBitmap & (uint(1) << i) > 0)) orderList[activeOrder++] = makerOrders.firstOrderId + i;
900         }
901     }
902 
903     ///@dev This function is not fully optimized gas wise. Consider before calling on chain.
904     function getEthToTokenOrderList() public view returns(uint32[] orderList) {
905         OrderListInterface list = ethToTokenList;
906         return getList(list);
907     }
908 
909     ///@dev This function is not fully optimized gas wise. Consider before calling on chain.
910     function getTokenToEthOrderList() public view returns(uint32[] orderList) {
911         OrderListInterface list = tokenToEthList;
912         return getList(list);
913     }
914 
915     event NewLimitOrder(
916         address indexed maker,
917         uint32 orderId,
918         bool isEthToToken,
919         uint128 srcAmount,
920         uint128 dstAmount,
921         bool addedWithHint
922     );
923 
924     function addOrder(bool isEthToToken, uint32 newId, uint128 srcAmount, uint128 dstAmount, uint32 hintPrevOrder)
925         internal
926         returns(bool)
927     {
928         require(srcAmount < MAX_QTY);
929         require(dstAmount < MAX_QTY);
930         address maker = msg.sender;
931 
932         require(secureAddOrderFunds(maker, isEthToToken, srcAmount, dstAmount));
933         require(validateLegalRate(srcAmount, dstAmount, isEthToToken));
934 
935         bool addedWithHint = false;
936         OrderListInterface list = isEthToToken ? ethToTokenList : tokenToEthList;
937 
938         if (hintPrevOrder != 0) {
939             addedWithHint = list.addAfterId(maker, newId, srcAmount, dstAmount, hintPrevOrder);
940         }
941 
942         if (!addedWithHint) {
943             require(list.add(maker, newId, srcAmount, dstAmount));
944         }
945 
946         NewLimitOrder(maker, newId, isEthToToken, srcAmount, dstAmount, addedWithHint);
947 
948         return true;
949     }
950 
951     event OrderUpdated(
952         address indexed maker,
953         bool isEthToToken,
954         uint orderId,
955         uint128 srcAmount,
956         uint128 dstAmount,
957         bool updatedWithHint
958     );
959 
960     function updateOrder(bool isEthToToken, uint32 orderId, uint128 newSrcAmount,
961         uint128 newDstAmount, uint32 hintPrevOrder)
962         internal
963         returns(bool)
964     {
965         require(newSrcAmount < MAX_QTY);
966         require(newDstAmount < MAX_QTY);
967         address maker;
968         uint128 currDstAmount;
969         uint128 currSrcAmount;
970         uint32 noUse;
971         uint noUse2;
972 
973         require(validateLegalRate(newSrcAmount, newDstAmount, isEthToToken));
974 
975         OrderListInterface list = isEthToToken ? ethToTokenList : tokenToEthList;
976 
977         (maker, currSrcAmount, currDstAmount, noUse, noUse) = list.getOrderDetails(orderId);
978         require(maker == msg.sender);
979 
980         if (!secureUpdateOrderFunds(maker, isEthToToken, currSrcAmount, currDstAmount, newSrcAmount, newDstAmount)) {
981             return false;
982         }
983 
984         bool updatedWithHint = false;
985 
986         if (hintPrevOrder != 0) {
987             (updatedWithHint, noUse2) = list.updateWithPositionHint(orderId, newSrcAmount, newDstAmount, hintPrevOrder);
988         }
989 
990         if (!updatedWithHint) {
991             require(list.update(orderId, newSrcAmount, newDstAmount));
992         }
993 
994         OrderUpdated(maker, isEthToToken, orderId, newSrcAmount, newDstAmount, updatedWithHint);
995 
996         return true;
997     }
998 
999     event OrderCanceled(address indexed maker, bool isEthToToken, uint32 orderId, uint128 srcAmount, uint dstAmount);
1000 
1001     function cancelOrder(bool isEthToToken, uint32 orderId) internal returns(bool) {
1002 
1003         address maker = msg.sender;
1004         OrderListInterface list = isEthToToken ? ethToTokenList : tokenToEthList;
1005         OrderData memory orderData = getOrderData(list, orderId);
1006 
1007         require(orderData.maker == maker);
1008 
1009         uint weiAmount = isEthToToken ? orderData.srcAmount : orderData.dstAmount;
1010         require(releaseOrderStakes(maker, weiAmount, 0));
1011 
1012         require(removeOrder(list, maker, isEthToToken ? ETH_TOKEN_ADDRESS : contracts.token, orderId));
1013 
1014         //funds go back to makers account
1015         makerFunds[maker][isEthToToken ? ETH_TOKEN_ADDRESS : contracts.token] += orderData.srcAmount;
1016 
1017         OrderCanceled(maker, isEthToToken, orderId, orderData.srcAmount, orderData.dstAmount);
1018 
1019         return true;
1020     }
1021 
1022     ///@param maker is the maker of this order
1023     ///@param isEthToToken which order type the maker is updating / adding
1024     ///@param srcAmount is the orders src amount (token or ETH) could be negative if funds are released.
1025     function bindOrderFunds(address maker, bool isEthToToken, int srcAmount)
1026         internal
1027         returns(bool)
1028     {
1029         address fundsAddress = isEthToToken ? ETH_TOKEN_ADDRESS : contracts.token;
1030 
1031         if (srcAmount < 0) {
1032             makerFunds[maker][fundsAddress] += uint(-srcAmount);
1033         } else {
1034             require(makerFunds[maker][fundsAddress] >= uint(srcAmount));
1035             makerFunds[maker][fundsAddress] -= uint(srcAmount);
1036         }
1037 
1038         return true;
1039     }
1040 
1041     ///@param maker is the maker address
1042     ///@param weiAmount is the wei amount inside order that should result in knc staking
1043     function bindOrderStakes(address maker, int weiAmount) internal returns(bool) {
1044 
1045         if (weiAmount < 0) {
1046             uint decreaseWeiAmount = uint(-weiAmount);
1047             if (decreaseWeiAmount > makerTotalOrdersWei[maker]) decreaseWeiAmount = makerTotalOrdersWei[maker];
1048             makerTotalOrdersWei[maker] -= decreaseWeiAmount;
1049             return true;
1050         }
1051 
1052         require(makerKnc[maker] >= calcKncStake(makerTotalOrdersWei[maker] + uint(weiAmount)));
1053 
1054         makerTotalOrdersWei[maker] += uint(weiAmount);
1055 
1056         return true;
1057     }
1058 
1059     ///@dev if totalWeiAmount is 0 we only release stakes.
1060     ///@dev if totalWeiAmount == weiForBurn. all staked amount will be burned. so no knc returned to maker
1061     ///@param maker is the maker address
1062     ///@param totalWeiAmount is total wei amount that was released from order - including taken wei amount.
1063     ///@param weiForBurn is the part in order wei amount that was taken and should result in burning.
1064     function releaseOrderStakes(address maker, uint totalWeiAmount, uint weiForBurn) internal returns(bool) {
1065 
1066         require(weiForBurn <= totalWeiAmount);
1067 
1068         if (totalWeiAmount > makerTotalOrdersWei[maker]) {
1069             makerTotalOrdersWei[maker] = 0;
1070         } else {
1071             makerTotalOrdersWei[maker] -= totalWeiAmount;
1072         }
1073 
1074         if (weiForBurn == 0) return true;
1075 
1076         uint burnAmount = calcBurnAmountFromFeeBurner(weiForBurn);
1077 
1078         require(makerKnc[maker] >= burnAmount);
1079         makerKnc[maker] -= burnAmount;
1080 
1081         return true;
1082     }
1083 
1084     ///@dev funds are valid only when required knc amount can be staked for this order.
1085     function secureAddOrderFunds(address maker, bool isEthToToken, uint128 srcAmount, uint128 dstAmount)
1086         internal returns(bool)
1087     {
1088         uint weiAmount = isEthToToken ? srcAmount : dstAmount;
1089 
1090         require(weiAmount >= limits.minNewOrderSizeWei);
1091         require(bindOrderFunds(maker, isEthToToken, int(srcAmount)));
1092         require(bindOrderStakes(maker, int(weiAmount)));
1093 
1094         return true;
1095     }
1096 
1097     ///@dev funds are valid only when required knc amount can be staked for this order.
1098     function secureUpdateOrderFunds(address maker, bool isEthToToken, uint128 prevSrcAmount, uint128 prevDstAmount,
1099         uint128 newSrcAmount, uint128 newDstAmount)
1100         internal
1101         returns(bool)
1102     {
1103         uint weiAmount = isEthToToken ? newSrcAmount : newDstAmount;
1104         int weiDiff = isEthToToken ? (int(newSrcAmount) - int(prevSrcAmount)) :
1105             (int(newDstAmount) - int(prevDstAmount));
1106 
1107         require(weiAmount >= limits.minNewOrderSizeWei);
1108 
1109         require(bindOrderFunds(maker, isEthToToken, int(newSrcAmount) - int(prevSrcAmount)));
1110 
1111         require(bindOrderStakes(maker, weiDiff));
1112 
1113         return true;
1114     }
1115 
1116     event FullOrderTaken(address maker, uint32 orderId, bool isEthToToken);
1117 
1118     function takeFullOrder(
1119         address maker,
1120         uint32 orderId,
1121         ERC20 userSrc,
1122         ERC20 userDst,
1123         uint128 userSrcAmount,
1124         uint128 userDstAmount
1125     )
1126         internal
1127         returns (bool)
1128     {
1129         OrderListInterface list = (userSrc == ETH_TOKEN_ADDRESS) ? tokenToEthList : ethToTokenList;
1130 
1131         //userDst == maker source
1132         require(removeOrder(list, maker, userDst, orderId));
1133 
1134         FullOrderTaken(maker, orderId, userSrc == ETH_TOKEN_ADDRESS);
1135 
1136         return takeOrder(maker, userSrc, userSrcAmount, userDstAmount, 0);
1137     }
1138 
1139     event PartialOrderTaken(address maker, uint32 orderId, bool isEthToToken, bool isRemoved);
1140 
1141     function takePartialOrder(
1142         address maker,
1143         uint32 orderId,
1144         ERC20 userSrc,
1145         ERC20 userDst,
1146         uint128 userPartialSrcAmount,
1147         uint128 userTakeDstAmount,
1148         uint128 orderSrcAmount,
1149         uint128 orderDstAmount
1150     )
1151         internal
1152         returns(bool)
1153     {
1154         require(userPartialSrcAmount < orderDstAmount);
1155         require(userTakeDstAmount < orderSrcAmount);
1156 
1157         //must reuse parameters, otherwise stack too deep error.
1158         orderSrcAmount -= userTakeDstAmount;
1159         orderDstAmount -= userPartialSrcAmount;
1160 
1161         OrderListInterface list = (userSrc == ETH_TOKEN_ADDRESS) ? tokenToEthList : ethToTokenList;
1162         uint weiValueNotReleasedFromOrder = (userSrc == ETH_TOKEN_ADDRESS) ? orderDstAmount : orderSrcAmount;
1163         uint additionalReleasedWei = 0;
1164 
1165         if (weiValueNotReleasedFromOrder < limits.minOrderSizeWei) {
1166             // remaining order amount too small. remove order and add remaining funds to free funds
1167             makerFunds[maker][userDst] += orderSrcAmount;
1168             additionalReleasedWei = weiValueNotReleasedFromOrder;
1169 
1170             //for remove order we give makerSrc == userDst
1171             require(removeOrder(list, maker, userDst, orderId));
1172         } else {
1173             bool isSuccess;
1174 
1175             // update order values, taken order is always first order
1176             (isSuccess,) = list.updateWithPositionHint(orderId, orderSrcAmount, orderDstAmount, HEAD_ID);
1177             require(isSuccess);
1178         }
1179 
1180         PartialOrderTaken(maker, orderId, userSrc == ETH_TOKEN_ADDRESS, additionalReleasedWei > 0);
1181 
1182         //stakes are returned for unused wei value
1183         return(takeOrder(maker, userSrc, userPartialSrcAmount, userTakeDstAmount, additionalReleasedWei));
1184     }
1185     
1186     function takeOrder(
1187         address maker,
1188         ERC20 userSrc,
1189         uint userSrcAmount,
1190         uint userDstAmount,
1191         uint additionalReleasedWei
1192     )
1193         internal
1194         returns(bool)
1195     {
1196         uint weiAmount = userSrc == (ETH_TOKEN_ADDRESS) ? userSrcAmount : userDstAmount;
1197 
1198         //token / eth already collected. just update maker balance
1199         makerFunds[maker][userSrc] += userSrcAmount;
1200 
1201         // send dst tokens in one batch. not here
1202         //handle knc stakes and fee. releasedWeiValue was released and not traded.
1203         return releaseOrderStakes(maker, (weiAmount + additionalReleasedWei), weiAmount);
1204     }
1205 
1206     function removeOrder(
1207         OrderListInterface list,
1208         address maker,
1209         ERC20 makerSrc,
1210         uint32 orderId
1211     )
1212         internal returns(bool)
1213     {
1214         require(list.remove(orderId));
1215         OrderIdData storage orders = (makerSrc == ETH_TOKEN_ADDRESS) ?
1216             makerOrdersEthToToken[maker] : makerOrdersTokenToEth[maker];
1217         require(releaseOrderId(orders, orderId));
1218 
1219         return true;
1220     }
1221 
1222     function getList(OrderListInterface list) internal view returns(uint32[] memory orderList) {
1223         OrderData memory orderData;
1224         uint32 orderId;
1225         bool isEmpty;
1226 
1227         (orderId, isEmpty) = list.getFirstOrder();
1228         if (isEmpty) return(new uint32[](0));
1229 
1230         uint numOrders = 0;
1231 
1232         for (; !orderData.isLastOrder; orderId = orderData.nextId) {
1233             orderData = getOrderData(list, orderId);
1234             numOrders++;
1235         }
1236 
1237         orderList = new uint32[](numOrders);
1238 
1239         (orderId, orderData.isLastOrder) = list.getFirstOrder();
1240 
1241         for (uint i = 0; i < numOrders; i++) {
1242             orderList[i] = orderId;
1243             orderData = getOrderData(list, orderId);
1244             orderId = orderData.nextId;
1245         }
1246     }
1247 
1248     function getOrderData(OrderListInterface list, uint32 orderId) internal view returns (OrderData data) {
1249         uint32 prevId;
1250         (data.maker, data.srcAmount, data.dstAmount, prevId, data.nextId) = list.getOrderDetails(orderId);
1251         data.isLastOrder = (data.nextId == TAIL_ID);
1252     }
1253 
1254     function validateLegalRate (uint srcAmount, uint dstAmount, bool isEthToToken)
1255         internal view returns(bool)
1256     {
1257         uint rate;
1258 
1259         /// notice, rate is calculated from taker perspective,
1260         ///     for taker amounts are opposite. order srcAmount will be DstAmount for taker.
1261         if (isEthToToken) {
1262             rate = calcRateFromQty(dstAmount, srcAmount, getDecimals(contracts.token), ETH_DECIMALS);
1263         } else {
1264             rate = calcRateFromQty(dstAmount, srcAmount, ETH_DECIMALS, getDecimals(contracts.token));
1265         }
1266 
1267         if (rate > MAX_RATE) return false;
1268         return true;
1269     }
1270 }
1271 
1272 // File: contracts/permissionless/PermissionlessOrderbookReserveLister.sol
1273 
1274 contract InternalNetworkInterface {
1275     function addReserve(
1276         KyberReserveInterface reserve,
1277         bool isPermissionless
1278     )
1279         public
1280         returns(bool);
1281 
1282     function removeReserve(
1283         KyberReserveInterface reserve,
1284         uint index
1285     )
1286         public
1287         returns(bool);
1288 
1289     function listPairForReserve(
1290         address reserve,
1291         ERC20 token,
1292         bool ethToToken,
1293         bool tokenToEth,
1294         bool add
1295     )
1296         public
1297         returns(bool);
1298 
1299     FeeBurnerInterface public feeBurnerContract;
1300 }
1301 
1302 
1303 contract PermissionlessOrderbookReserveLister {
1304     // KNC burn fee per wei value of an order. 25 in BPS = 0.25%.
1305     uint constant public ORDERBOOK_BURN_FEE_BPS = 25;
1306 
1307     uint public minNewOrderValueUsd = 1000; // set in order book minimum USD value of a new limit order
1308     uint public maxOrdersPerTrade;          // set in order book maximum orders to be traversed in rate query and trade
1309 
1310     InternalNetworkInterface public kyberNetworkContract;
1311     OrderListFactoryInterface public orderFactoryContract;
1312     MedianizerInterface public medianizerContract;
1313     ERC20 public kncToken;
1314 
1315     enum ListingStage {NO_RESERVE, RESERVE_ADDED, RESERVE_INIT, RESERVE_LISTED}
1316 
1317     mapping(address => OrderbookReserveInterface) public reserves; //Permissionless orderbook reserves mapped per token
1318     mapping(address => ListingStage) public reserveListingStage;   //Reserves listing stage
1319     mapping(address => bool) tokenListingBlocked;
1320 
1321     function PermissionlessOrderbookReserveLister(
1322         InternalNetworkInterface kyber,
1323         OrderListFactoryInterface factory,
1324         MedianizerInterface medianizer,
1325         ERC20 knc,
1326         address[] unsupportedTokens,
1327         uint maxOrders,
1328         uint minOrderValueUsd
1329     )
1330         public
1331     {
1332         require(kyber != address(0));
1333         require(factory != address(0));
1334         require(medianizer != address(0));
1335         require(knc != address(0));
1336         require(maxOrders > 1);
1337         require(minOrderValueUsd > 0);
1338 
1339         kyberNetworkContract = kyber;
1340         orderFactoryContract = factory;
1341         medianizerContract = medianizer;
1342         kncToken = knc;
1343         maxOrdersPerTrade = maxOrders;
1344         minNewOrderValueUsd = minOrderValueUsd;
1345 
1346         for (uint i = 0; i < unsupportedTokens.length; i++) {
1347             require(unsupportedTokens[i] != address(0));
1348             tokenListingBlocked[unsupportedTokens[i]] = true;
1349         }
1350     }
1351 
1352     event TokenOrderbookListingStage(ERC20 token, ListingStage stage);
1353 
1354     /// @dev anyone can call
1355     function addOrderbookContract(ERC20 token) public returns(bool) {
1356         require(reserveListingStage[token] == ListingStage.NO_RESERVE);
1357         require(!(tokenListingBlocked[token]));
1358 
1359         reserves[token] = new OrderbookReserve({
1360             knc: kncToken,
1361             reserveToken: token,
1362             burner: kyberNetworkContract.feeBurnerContract(),
1363             network: kyberNetworkContract,
1364             medianizer: medianizerContract,
1365             factory: orderFactoryContract,
1366             minNewOrderUsd: minNewOrderValueUsd,
1367             maxOrdersPerTrade: maxOrdersPerTrade,
1368             burnFeeBps: ORDERBOOK_BURN_FEE_BPS
1369         });
1370 
1371         reserveListingStage[token] = ListingStage.RESERVE_ADDED;
1372 
1373         TokenOrderbookListingStage(token, ListingStage.RESERVE_ADDED);
1374         return true;
1375     }
1376 
1377     /// @dev anyone can call
1378     function initOrderbookContract(ERC20 token) public returns(bool) {
1379         require(reserveListingStage[token] == ListingStage.RESERVE_ADDED);
1380         require(reserves[token].init());
1381 
1382         reserveListingStage[token] = ListingStage.RESERVE_INIT;
1383         TokenOrderbookListingStage(token, ListingStage.RESERVE_INIT);
1384         return true;
1385     }
1386 
1387     /// @dev anyone can call
1388     function listOrderbookContract(ERC20 token) public returns(bool) {
1389         require(reserveListingStage[token] == ListingStage.RESERVE_INIT);
1390 
1391         require(
1392             kyberNetworkContract.addReserve(
1393                 KyberReserveInterface(reserves[token]),
1394                 true
1395             )
1396         );
1397 
1398         require(
1399             kyberNetworkContract.listPairForReserve(
1400                 KyberReserveInterface(reserves[token]),
1401                 token,
1402                 true,
1403                 true,
1404                 true
1405             )
1406         );
1407 
1408         FeeBurnerInterface feeBurner = FeeBurnerInterface(kyberNetworkContract.feeBurnerContract());
1409 
1410         feeBurner.setReserveData(
1411             reserves[token], /* reserve */
1412             ORDERBOOK_BURN_FEE_BPS, /* fee */
1413             reserves[token] /* kncWallet */
1414         );
1415 
1416         reserveListingStage[token] = ListingStage.RESERVE_LISTED;
1417         TokenOrderbookListingStage(token, ListingStage.RESERVE_LISTED);
1418         return true;
1419     }
1420 
1421     function unlistOrderbookContract(ERC20 token, uint hintReserveIndex) public {
1422         require(reserveListingStage[token] == ListingStage.RESERVE_LISTED);
1423         require(reserves[token].kncRateBlocksTrade());
1424         require(kyberNetworkContract.removeReserve(KyberReserveInterface(reserves[token]), hintReserveIndex));
1425         reserveListingStage[token] = ListingStage.NO_RESERVE;
1426         reserves[token] = OrderbookReserveInterface(0);
1427         TokenOrderbookListingStage(token, ListingStage.NO_RESERVE);
1428     }
1429 
1430     /// @dev permission less reserve currently supports one token per reserve.
1431     function getOrderbookListingStage(ERC20 token)
1432         public
1433         view
1434         returns(address, ListingStage)
1435     {
1436         return (reserves[token], reserveListingStage[token]);
1437     }
1438 }