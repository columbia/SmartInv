1 pragma solidity ^0.4.11;
2 
3 // NB: this is the newer ERC20 returning bool, need different book contract for older style tokens
4 contract ERC20 {
5   function totalSupply() constant returns (uint);
6   function balanceOf(address _owner) constant returns (uint balance);
7   function transfer(address _to, uint _value) returns (bool success);
8   function transferFrom(address _from, address _to, uint _value) returns (bool success);
9   function approve(address _spender, uint _value) returns (bool success);
10   function allowance(address _owner, address _spender) constant returns (uint remaining);
11   event Transfer(address indexed _from, address indexed _to, uint _value);
12   event Approval(address indexed _owner, address indexed _spender, uint _value);
13 }
14 
15 // UbiTok.io on-chain continuous limit order book matching engine.
16 // This variation is for a "nice" ERC20 token as base, ETH as quoted, and standard fees with reward token.
17 // Copyright (c) Bonnag Limited. All Rights Reserved.
18 // Version 1.1.0y - variant with totalsupply validation disabled
19 // This contract allows minPriceExponent, baseMinInitialSize, and baseMinRemainingSize
20 // to be set at init() time appropriately for the token decimals and likely value.
21 // 
22 //
23 contract BookERC20EthV1p1y {
24 
25   enum BookType {
26     ERC20EthV1
27   }
28 
29   enum Direction {
30     Invalid,
31     Buy,
32     Sell
33   }
34 
35   enum Status {
36     Unknown,
37     Rejected,
38     Open,
39     Done,
40     NeedsGas,
41     Sending, // not used by contract - web only
42     FailedSend, // not used by contract - web only
43     FailedTxn // not used by contract - web only
44   }
45 
46   enum ReasonCode {
47     None,
48     InvalidPrice,
49     InvalidSize,
50     InvalidTerms,
51     InsufficientFunds,
52     WouldTake,
53     Unmatched,
54     TooManyMatches,
55     ClientCancel
56   }
57 
58   enum Terms {
59     GTCNoGasTopup,
60     GTCWithGasTopup,
61     ImmediateOrCancel,
62     MakerOnly
63   }
64 
65   struct Order {
66     // these are immutable once placed:
67 
68     address client;
69     uint16 price;              // packed representation of side + price
70     uint sizeBase;
71     Terms terms;
72 
73     // these are mutable until Done or Rejected:
74     
75     Status status;
76     ReasonCode reasonCode;
77     uint128 executedBase;      // gross amount executed in base currency (before fee deduction)
78     uint128 executedCntr;      // gross amount executed in counter currency (before fee deduction)
79     uint128 feesBaseOrCntr;    // base for buy, cntr for sell
80     uint128 feesRwrd;
81   }
82   
83   struct OrderChain {
84     uint128 firstOrderId;
85     uint128 lastOrderId;
86   }
87 
88   struct OrderChainNode {
89     uint128 nextOrderId;
90     uint128 prevOrderId;
91   }
92   
93   // It should be possible to reconstruct the expected state of the contract given:
94   //  - ClientPaymentEvent log history
95   //  - ClientOrderEvent log history
96   //  - Calling getOrder for the other immutable order fields of orders referenced by ClientOrderEvent
97   
98   enum ClientPaymentEventType {
99     Deposit,
100     Withdraw,
101     TransferFrom,
102     Transfer
103   }
104 
105   enum BalanceType {
106     Base,
107     Cntr,
108     Rwrd
109   }
110 
111   event ClientPaymentEvent(
112     address indexed client,
113     ClientPaymentEventType clientPaymentEventType,
114     BalanceType balanceType,
115     int clientBalanceDelta
116   );
117 
118   enum ClientOrderEventType {
119     Create,
120     Continue,
121     Cancel
122   }
123 
124   event ClientOrderEvent(
125     address indexed client,
126     ClientOrderEventType clientOrderEventType,
127     uint128 orderId,
128     uint maxMatches
129   );
130 
131   enum MarketOrderEventType {
132     // orderCount++, depth += depthBase
133     Add,
134     // orderCount--, depth -= depthBase
135     Remove,
136     // orderCount--, depth -= depthBase, traded += tradeBase
137     // (depth change and traded change differ when tiny remaining amount refunded)
138     CompleteFill,
139     // orderCount unchanged, depth -= depthBase, traded += tradeBase
140     PartialFill
141   }
142 
143   // Technically not needed but these events can be used to maintain an order book or
144   // watch for fills. Note that the orderId and price are those of the maker.
145 
146   event MarketOrderEvent(
147     uint256 indexed eventTimestamp,
148     uint128 indexed orderId,
149     MarketOrderEventType marketOrderEventType,
150     uint16 price,
151     uint depthBase,
152     uint tradeBase
153   );
154 
155   // the base token (e.g. TEST)
156   
157   ERC20 baseToken;
158 
159   // minimum order size (inclusive)
160   uint baseMinInitialSize; // set at init
161 
162   // if following partial match, the remaning gets smaller than this, remove from book and refund:
163   // generally we make this 10% of baseMinInitialSize
164   uint baseMinRemainingSize; // set at init
165 
166   // maximum order size (exclusive)
167   // chosen so that even multiplied by the max price (or divided by the min price),
168   // and then multiplied by ethRwrdRate, it still fits in 2^127, allowing us to save
169   // some gas by storing executed + fee fields as uint128.
170   // even with 18 decimals, this still allows order sizes up to 1,000,000,000.
171   // if we encounter a token with e.g. 36 decimals we'll have to revisit ...
172   uint constant baseMaxSize = 10 ** 30;
173 
174   // the counter currency (ETH)
175   // (no address because it is ETH)
176 
177   // avoid the book getting cluttered up with tiny amounts not worth the gas
178   uint constant cntrMinInitialSize = 10 finney;
179 
180   // see comments for baseMaxSize
181   uint constant cntrMaxSize = 10 ** 30;
182 
183   // the reward token that can be used to pay fees (UBI)
184 
185   ERC20 rwrdToken; // set at init
186 
187   // used to convert ETH amount to reward tokens when paying fee with reward tokens
188   uint constant ethRwrdRate = 1000;
189   
190   // funds that belong to clients (base, counter, and reward)
191 
192   mapping (address => uint) balanceBaseForClient;
193   mapping (address => uint) balanceCntrForClient;
194   mapping (address => uint) balanceRwrdForClient;
195 
196   // fee charged on liquidity taken, expressed as a divisor
197   // (e.g. 2000 means 1/2000, or 0.05%)
198 
199   uint constant feeDivisor = 2000;
200   
201   // fees charged are given to:
202   
203   address feeCollector; // set at init
204 
205   // all orders ever created
206   
207   mapping (uint128 => Order) orderForOrderId;
208 
209   // Effectively a compact mapping from price to whether there are any open orders at that price.
210   // See "Price Calculation Constants" below as to why 85.
211 
212   uint256[85] occupiedPriceBitmaps;
213 
214   // These allow us to walk over the orders in the book at a given price level (and add more).
215 
216   mapping (uint16 => OrderChain) orderChainForOccupiedPrice;
217   mapping (uint128 => OrderChainNode) orderChainNodeForOpenOrderId;
218 
219   // These allow a client to (reasonably) efficiently find their own orders
220   // without relying on events (which even indexed are a bit expensive to search
221   // and cannot be accessed from smart contracts). See walkOrders.
222 
223   mapping (address => uint128) mostRecentOrderIdForClient;
224   mapping (uint128 => uint128) clientPreviousOrderIdBeforeOrderId;
225 
226   // Price Calculation Constants.
227   //
228   // We pack direction and price into a crafty decimal floating point representation
229   // for efficient indexing by price, the main thing we lose by doing so is precision -
230   // we only have 3 significant figures in our prices.
231   //
232   // An unpacked price consists of:
233   //
234   //   direction - invalid / buy / sell
235   //   mantissa  - ranges from 100 to 999 representing 0.100 to 0.999
236   //   exponent  - ranges from minimumPriceExponent to minimumPriceExponent + 11
237   //               (e.g. -5 to +6 for a typical pair where minPriceExponent = -5)
238   //
239   // The packed representation has 21601 different price values:
240   //
241   //      0  = invalid (can be used as marker value)
242   //      1  = buy at maximum price (0.999 * 10 ** 6)
243   //    ...  = other buy prices in descending order
244   //   5400  = buy at 1.00
245   //    ...  = other buy prices in descending order
246   //  10800  = buy at minimum price (0.100 * 10 ** -5)
247   //  10801  = sell at minimum price (0.100 * 10 ** -5)
248   //    ...  = other sell prices in descending order
249   //  16201  = sell at 1.00
250   //    ...  = other sell prices in descending order
251   //  21600  = sell at maximum price (0.999 * 10 ** 6)
252   //  21601+ = do not use
253   //
254   // If we want to map each packed price to a boolean value (which we do),
255   // we require 85 256-bit words. Or 42.5 for each side of the book.
256   
257   int8 minPriceExponent; // set at init
258 
259   uint constant invalidPrice = 0;
260 
261   // careful: max = largest unpacked value, not largest packed value
262   uint constant maxBuyPrice = 1; 
263   uint constant minBuyPrice = 10800;
264   uint constant minSellPrice = 10801;
265   uint constant maxSellPrice = 21600;
266 
267   // Constructor.
268   //
269   // Sets feeCollector to the creator. Creator needs to call init() to finish setup.
270   //
271   function BookERC20EthV1p1y() {
272     address creator = msg.sender;
273     feeCollector = creator;
274   }
275 
276   // "Public" Management - set address of base and reward tokens.
277   //
278   // Can only be done once (normally immediately after creation) by the fee collector.
279   //
280   // Used instead of a constructor to make deployment easier.
281   //
282   // baseMinInitialSize is the minimum order size in token-wei;
283   // the minimum resting size will be one tenth of that.
284   //
285   // minPriceExponent controls the range of prices supported by the contract;
286   // the range will be 0.100*10**minPriceExponent to 0.999*10**(minPriceExponent + 11)
287   // but careful; this is in token-wei : wei, ignoring the number of decimals of the token
288   // e.g. -5 implies 1 token-wei worth between 0.100e-5 to 0.999e+6 wei
289   // which implies same token:eth exchange rate if token decimals are 18 like eth,
290   // but if token decimals are 8, that would imply 1 token worth 10 wei to 0.000999 ETH.
291   //
292   function init(ERC20 _baseToken, ERC20 _rwrdToken, uint _baseMinInitialSize, int8 _minPriceExponent) public {
293     require(msg.sender == feeCollector);
294     require(address(baseToken) == 0);
295     require(address(_baseToken) != 0);
296     require(address(rwrdToken) == 0);
297     require(address(_rwrdToken) != 0);
298     require(_baseMinInitialSize >= 10);
299     require(_baseMinInitialSize < baseMaxSize / 1000000);
300     require(_minPriceExponent >= -20 && _minPriceExponent <= 20);
301     if (_minPriceExponent < 2) {
302       require(_baseMinInitialSize >= 10 ** uint(3-int(minPriceExponent)));
303     }
304     baseMinInitialSize = _baseMinInitialSize;
305     // dust prevention. truncation ok, know >= 10
306     baseMinRemainingSize = _baseMinInitialSize / 10;
307     minPriceExponent = _minPriceExponent;
308     // attempt to catch bad tokens (disabled for YOLO)
309     //require(_baseToken.totalSupply() > 0);
310     baseToken = _baseToken;
311     require(_rwrdToken.totalSupply() > 0);
312     rwrdToken = _rwrdToken;
313   }
314 
315   // "Public" Management - change fee collector
316   //
317   // The new fee collector only gets fees charged after this point.
318   //
319   function changeFeeCollector(address newFeeCollector) public {
320     address oldFeeCollector = feeCollector;
321     require(msg.sender == oldFeeCollector);
322     require(newFeeCollector != oldFeeCollector);
323     feeCollector = newFeeCollector;
324   }
325   
326   // Public Info View - what is being traded here, what are the limits?
327   //
328   function getBookInfo() public constant returns (
329       BookType _bookType, address _baseToken, address _rwrdToken,
330       uint _baseMinInitialSize, uint _cntrMinInitialSize, int8 _minPriceExponent,
331       uint _feeDivisor, address _feeCollector
332     ) {
333     return (
334       BookType.ERC20EthV1,
335       address(baseToken),
336       address(rwrdToken),
337       baseMinInitialSize, // can assume min resting size is one tenth of this
338       cntrMinInitialSize,
339       minPriceExponent,
340       feeDivisor,
341       feeCollector
342     );
343   }
344 
345   // Public Funds View - get balances held by contract on behalf of the client,
346   // or balances approved for deposit but not yet claimed by the contract.
347   //
348   // Excludes funds in open orders.
349   //
350   // Helps a web ui get a consistent snapshot of balances.
351   //
352   // It would be nice to return the off-exchange ETH balance too but there's a
353   // bizarre bug in geth (and apparently as a result via MetaMask) that leads
354   // to unpredictable behaviour when looking up client balances in constant
355   // functions - see e.g. https://github.com/ethereum/solidity/issues/2325 .
356   //
357   function getClientBalances(address client) public constant returns (
358       uint bookBalanceBase,
359       uint bookBalanceCntr,
360       uint bookBalanceRwrd,
361       uint approvedBalanceBase,
362       uint approvedBalanceRwrd,
363       uint ownBalanceBase,
364       uint ownBalanceRwrd
365     ) {
366     bookBalanceBase = balanceBaseForClient[client];
367     bookBalanceCntr = balanceCntrForClient[client];
368     bookBalanceRwrd = balanceRwrdForClient[client];
369     approvedBalanceBase = baseToken.allowance(client, address(this));
370     approvedBalanceRwrd = rwrdToken.allowance(client, address(this));
371     ownBalanceBase = baseToken.balanceOf(client);
372     ownBalanceRwrd = rwrdToken.balanceOf(client);
373   }
374 
375   // Public Funds Manipulation - deposit previously-approved base tokens.
376   //
377   function transferFromBase() public {
378     address client = msg.sender;
379     address book = address(this);
380     // we trust the ERC20 token contract not to do nasty things like call back into us -
381     // if we cannot trust the token then why are we allowing it to be traded?
382     uint amountBase = baseToken.allowance(client, book);
383     require(amountBase > 0);
384     // NB: needs change for older ERC20 tokens that don't return bool
385     require(baseToken.transferFrom(client, book, amountBase));
386     // belt and braces
387     assert(baseToken.allowance(client, book) == 0);
388     balanceBaseForClient[client] += amountBase;
389     ClientPaymentEvent(client, ClientPaymentEventType.TransferFrom, BalanceType.Base, int(amountBase));
390   }
391 
392   // Public Funds Manipulation - withdraw base tokens (as a transfer).
393   //
394   function transferBase(uint amountBase) public {
395     address client = msg.sender;
396     require(amountBase > 0);
397     require(amountBase <= balanceBaseForClient[client]);
398     // overflow safe since we checked less than balance above
399     balanceBaseForClient[client] -= amountBase;
400     // we trust the ERC20 token contract not to do nasty things like call back into us -
401     // if we cannot trust the token then why are we allowing it to be traded?
402     // NB: needs change for older ERC20 tokens that don't return bool
403     require(baseToken.transfer(client, amountBase));
404     ClientPaymentEvent(client, ClientPaymentEventType.Transfer, BalanceType.Base, -int(amountBase));
405   }
406 
407   // Public Funds Manipulation - deposit counter currency (ETH).
408   //
409   function depositCntr() public payable {
410     address client = msg.sender;
411     uint amountCntr = msg.value;
412     require(amountCntr > 0);
413     // overflow safe - if someone owns pow(2,255) ETH we have bigger problems
414     balanceCntrForClient[client] += amountCntr;
415     ClientPaymentEvent(client, ClientPaymentEventType.Deposit, BalanceType.Cntr, int(amountCntr));
416   }
417 
418   // Public Funds Manipulation - withdraw counter currency (ETH).
419   //
420   function withdrawCntr(uint amountCntr) public {
421     address client = msg.sender;
422     require(amountCntr > 0);
423     require(amountCntr <= balanceCntrForClient[client]);
424     // overflow safe - checked less than balance above
425     balanceCntrForClient[client] -= amountCntr;
426     // safe - not enough gas to do anything interesting in fallback, already adjusted balance
427     client.transfer(amountCntr);
428     ClientPaymentEvent(client, ClientPaymentEventType.Withdraw, BalanceType.Cntr, -int(amountCntr));
429   }
430 
431   // Public Funds Manipulation - deposit previously-approved reward tokens.
432   //
433   function transferFromRwrd() public {
434     address client = msg.sender;
435     address book = address(this);
436     uint amountRwrd = rwrdToken.allowance(client, book);
437     require(amountRwrd > 0);
438     // we wrote the reward token so we know it supports ERC20 properly and is not evil
439     require(rwrdToken.transferFrom(client, book, amountRwrd));
440     // belt and braces
441     assert(rwrdToken.allowance(client, book) == 0);
442     balanceRwrdForClient[client] += amountRwrd;
443     ClientPaymentEvent(client, ClientPaymentEventType.TransferFrom, BalanceType.Rwrd, int(amountRwrd));
444   }
445 
446   // Public Funds Manipulation - withdraw base tokens (as a transfer).
447   //
448   function transferRwrd(uint amountRwrd) public {
449     address client = msg.sender;
450     require(amountRwrd > 0);
451     require(amountRwrd <= balanceRwrdForClient[client]);
452     // overflow safe - checked less than balance above
453     balanceRwrdForClient[client] -= amountRwrd;
454     // we wrote the reward token so we know it supports ERC20 properly and is not evil
455     require(rwrdToken.transfer(client, amountRwrd));
456     ClientPaymentEvent(client, ClientPaymentEventType.Transfer, BalanceType.Rwrd, -int(amountRwrd));
457   }
458 
459   // Public Order View - get full details of an order.
460   //
461   // If the orderId does not exist, status will be Unknown.
462   //
463   function getOrder(uint128 orderId) public constant returns (
464     address client, uint16 price, uint sizeBase, Terms terms,
465     Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
466     uint feesBaseOrCntr, uint feesRwrd) {
467     Order storage order = orderForOrderId[orderId];
468     return (order.client, order.price, order.sizeBase, order.terms,
469             order.status, order.reasonCode, order.executedBase, order.executedCntr,
470             order.feesBaseOrCntr, order.feesRwrd);
471   }
472 
473   // Public Order View - get mutable details of an order.
474   //
475   // If the orderId does not exist, status will be Unknown.
476   //
477   function getOrderState(uint128 orderId) public constant returns (
478     Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
479     uint feesBaseOrCntr, uint feesRwrd) {
480     Order storage order = orderForOrderId[orderId];
481     return (order.status, order.reasonCode, order.executedBase, order.executedCntr,
482             order.feesBaseOrCntr, order.feesRwrd);
483   }
484   
485   // Public Order View - enumerate all recent orders + all open orders for one client.
486   //
487   // Not really designed for use from a smart contract transaction.
488   //
489   // Idea is:
490   //  - client ensures order ids are generated so that most-signficant part is time-based;
491   //  - client decides they want all orders after a certain point-in-time,
492   //    and chooses minClosedOrderIdCutoff accordingly;
493   //  - before that point-in-time they just get open and needs gas orders
494   //  - client calls walkClientOrders with maybeLastOrderIdReturned = 0 initially;
495   //  - then repeats with the orderId returned by walkClientOrders;
496   //  - (and stops if it returns a zero orderId);
497   //
498   // Note that client is only used when maybeLastOrderIdReturned = 0.
499   //
500   function walkClientOrders(
501       address client, uint128 maybeLastOrderIdReturned, uint128 minClosedOrderIdCutoff
502     ) public constant returns (
503       uint128 orderId, uint16 price, uint sizeBase, Terms terms,
504       Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
505       uint feesBaseOrCntr, uint feesRwrd) {
506     if (maybeLastOrderIdReturned == 0) {
507       orderId = mostRecentOrderIdForClient[client];
508     } else {
509       orderId = clientPreviousOrderIdBeforeOrderId[maybeLastOrderIdReturned];
510     }
511     while (true) {
512       if (orderId == 0) return;
513       Order storage order = orderForOrderId[orderId];
514       if (orderId >= minClosedOrderIdCutoff) break;
515       if (order.status == Status.Open || order.status == Status.NeedsGas) break;
516       orderId = clientPreviousOrderIdBeforeOrderId[orderId];
517     }
518     return (orderId, order.price, order.sizeBase, order.terms,
519             order.status, order.reasonCode, order.executedBase, order.executedCntr,
520             order.feesBaseOrCntr, order.feesRwrd);
521   }
522  
523   // Internal Price Calculation - turn packed price into a friendlier unpacked price.
524   //
525   function unpackPrice(uint16 price) internal constant returns (
526       Direction direction, uint16 mantissa, int8 exponent
527     ) {
528     uint sidedPriceIndex = uint(price);
529     uint priceIndex;
530     if (sidedPriceIndex < 1 || sidedPriceIndex > maxSellPrice) {
531       direction = Direction.Invalid;
532       mantissa = 0;
533       exponent = 0;
534       return;
535     } else if (sidedPriceIndex <= minBuyPrice) {
536       direction = Direction.Buy;
537       priceIndex = minBuyPrice - sidedPriceIndex;
538     } else {
539       direction = Direction.Sell;
540       priceIndex = sidedPriceIndex - minSellPrice;
541     }
542     uint zeroBasedMantissa = priceIndex % 900;
543     uint zeroBasedExponent = priceIndex / 900;
544     mantissa = uint16(zeroBasedMantissa + 100);
545     exponent = int8(zeroBasedExponent) + minPriceExponent;
546     return;
547   }
548   
549   // Internal Price Calculation - is a packed price on the buy side?
550   //
551   // Throws an error if price is invalid.
552   //
553   function isBuyPrice(uint16 price) internal constant returns (bool isBuy) {
554     // yes, this looks odd, but max here is highest _unpacked_ price
555     return price >= maxBuyPrice && price <= minBuyPrice;
556   }
557   
558   // Internal Price Calculation - turn a packed buy price into a packed sell price.
559   //
560   // Invalid price remains invalid.
561   //
562   function computeOppositePrice(uint16 price) internal constant returns (uint16 opposite) {
563     if (price < maxBuyPrice || price > maxSellPrice) {
564       return uint16(invalidPrice);
565     } else if (price <= minBuyPrice) {
566       return uint16(maxSellPrice - (price - maxBuyPrice));
567     } else {
568       return uint16(maxBuyPrice + (maxSellPrice - price));
569     }
570   }
571   
572   // Internal Price Calculation - compute amount in counter currency that would
573   // be obtained by selling baseAmount at the given unpacked price (if no fees).
574   //
575   // Notes:
576   //  - Does not validate price - caller must ensure valid.
577   //  - Could overflow producing very unexpected results if baseAmount very
578   //    large - caller must check this.
579   //  - This rounds the amount towards zero.
580   //  - May truncate to zero if baseAmount very small - potentially allowing
581   //    zero-cost buys or pointless sales - caller must check this.
582   //
583   function computeCntrAmountUsingUnpacked(
584       uint baseAmount, uint16 mantissa, int8 exponent
585     ) internal constant returns (uint cntrAmount) {
586     if (exponent < 0) {
587       return baseAmount * uint(mantissa) / 1000 / 10 ** uint(-exponent);
588     } else {
589       return baseAmount * uint(mantissa) / 1000 * 10 ** uint(exponent);
590     }
591   }
592 
593   // Internal Price Calculation - compute amount in counter currency that would
594   // be obtained by selling baseAmount at the given packed price (if no fees).
595   //
596   // Notes:
597   //  - Does not validate price - caller must ensure valid.
598   //  - Direction of the packed price is ignored.
599   //  - Could overflow producing very unexpected results if baseAmount very
600   //    large - caller must check this.
601   //  - This rounds the amount towards zero (regardless of Buy or Sell).
602   //  - May truncate to zero if baseAmount very small - potentially allowing
603   //    zero-cost buys or pointless sales - caller must check this.
604   //
605   function computeCntrAmountUsingPacked(
606       uint baseAmount, uint16 price
607     ) internal constant returns (uint) {
608     var (, mantissa, exponent) = unpackPrice(price);
609     return computeCntrAmountUsingUnpacked(baseAmount, mantissa, exponent);
610   }
611 
612   // Public Order Placement - create order and try to match it and/or add it to the book.
613   //
614   function createOrder(
615       uint128 orderId, uint16 price, uint sizeBase, Terms terms, uint maxMatches
616     ) public {
617     address client = msg.sender;
618     require(orderId != 0 && orderForOrderId[orderId].client == 0);
619     ClientOrderEvent(client, ClientOrderEventType.Create, orderId, maxMatches);
620     orderForOrderId[orderId] =
621       Order(client, price, sizeBase, terms, Status.Unknown, ReasonCode.None, 0, 0, 0, 0);
622     uint128 previousMostRecentOrderIdForClient = mostRecentOrderIdForClient[client];
623     mostRecentOrderIdForClient[client] = orderId;
624     clientPreviousOrderIdBeforeOrderId[orderId] = previousMostRecentOrderIdForClient;
625     Order storage order = orderForOrderId[orderId];
626     var (direction, mantissa, exponent) = unpackPrice(price);
627     if (direction == Direction.Invalid) {
628       order.status = Status.Rejected;
629       order.reasonCode = ReasonCode.InvalidPrice;
630       return;
631     }
632     if (sizeBase < baseMinInitialSize || sizeBase > baseMaxSize) {
633       order.status = Status.Rejected;
634       order.reasonCode = ReasonCode.InvalidSize;
635       return;
636     }
637     uint sizeCntr = computeCntrAmountUsingUnpacked(sizeBase, mantissa, exponent);
638     if (sizeCntr < cntrMinInitialSize || sizeCntr > cntrMaxSize) {
639       order.status = Status.Rejected;
640       order.reasonCode = ReasonCode.InvalidSize;
641       return;
642     }
643     if (terms == Terms.MakerOnly && maxMatches != 0) {
644       order.status = Status.Rejected;
645       order.reasonCode = ReasonCode.InvalidTerms;
646       return;
647     }
648     if (!debitFunds(client, direction, sizeBase, sizeCntr)) {
649       order.status = Status.Rejected;
650       order.reasonCode = ReasonCode.InsufficientFunds;
651       return;
652     }
653     processOrder(orderId, maxMatches);
654   }
655 
656   // Public Order Placement - cancel order
657   //
658   function cancelOrder(uint128 orderId) public {
659     address client = msg.sender;
660     Order storage order = orderForOrderId[orderId];
661     require(order.client == client);
662     Status status = order.status;
663     if (status != Status.Open && status != Status.NeedsGas) {
664       return;
665     }
666     ClientOrderEvent(client, ClientOrderEventType.Cancel, orderId, 0);
667     if (status == Status.Open) {
668       removeOpenOrderFromBook(orderId);
669       MarketOrderEvent(block.timestamp, orderId, MarketOrderEventType.Remove, order.price,
670         order.sizeBase - order.executedBase, 0);
671     }
672     refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.ClientCancel);
673   }
674 
675   // Public Order Placement - continue placing an order in 'NeedsGas' state
676   //
677   function continueOrder(uint128 orderId, uint maxMatches) public {
678     address client = msg.sender;
679     Order storage order = orderForOrderId[orderId];
680     require(order.client == client);
681     if (order.status != Status.NeedsGas) {
682       return;
683     }
684     ClientOrderEvent(client, ClientOrderEventType.Continue, orderId, maxMatches);
685     order.status = Status.Unknown;
686     processOrder(orderId, maxMatches);
687   }
688 
689   // Internal Order Placement - remove a still-open order from the book.
690   //
691   // Caller's job to update/refund the order + raise event, this just
692   // updates the order chain and bitmask.
693   //
694   // Too expensive to do on each resting order match - we only do this for an
695   // order being cancelled. See matchWithOccupiedPrice for similar logic.
696   //
697   function removeOpenOrderFromBook(uint128 orderId) internal {
698     Order storage order = orderForOrderId[orderId];
699     uint16 price = order.price;
700     OrderChain storage orderChain = orderChainForOccupiedPrice[price];
701     OrderChainNode storage orderChainNode = orderChainNodeForOpenOrderId[orderId];
702     uint128 nextOrderId = orderChainNode.nextOrderId;
703     uint128 prevOrderId = orderChainNode.prevOrderId;
704     if (nextOrderId != 0) {
705       OrderChainNode storage nextOrderChainNode = orderChainNodeForOpenOrderId[nextOrderId];
706       nextOrderChainNode.prevOrderId = prevOrderId;
707     } else {
708       orderChain.lastOrderId = prevOrderId;
709     }
710     if (prevOrderId != 0) {
711       OrderChainNode storage prevOrderChainNode = orderChainNodeForOpenOrderId[prevOrderId];
712       prevOrderChainNode.nextOrderId = nextOrderId;
713     } else {
714       orderChain.firstOrderId = nextOrderId;
715     }
716     if (nextOrderId == 0 && prevOrderId == 0) {
717       uint bmi = price / 256;  // index into array of bitmaps
718       uint bti = price % 256;  // bit position within bitmap
719       // we know was previously occupied so XOR clears
720       occupiedPriceBitmaps[bmi] ^= 2 ** bti;
721     }
722   }
723 
724   // Internal Order Placement - credit funds received when taking liquidity from book
725   //
726   function creditExecutedFundsLessFees(uint128 orderId, uint originalExecutedBase, uint originalExecutedCntr) internal {
727     Order storage order = orderForOrderId[orderId];
728     uint liquidityTakenBase = order.executedBase - originalExecutedBase;
729     uint liquidityTakenCntr = order.executedCntr - originalExecutedCntr;
730     // Normally we deduct the fee from the currency bought (base for buy, cntr for sell),
731     // however we also accept reward tokens from the reward balance if it covers the fee,
732     // with the reward amount converted from the ETH amount (the counter currency here)
733     // at a fixed exchange rate.
734     // Overflow safe since we ensure order size < 10^30 in both currencies (see baseMaxSize).
735     // Can truncate to zero, which is fine.
736     uint feesRwrd = liquidityTakenCntr / feeDivisor * ethRwrdRate;
737     uint feesBaseOrCntr;
738     address client = order.client;
739     uint availRwrd = balanceRwrdForClient[client];
740     if (feesRwrd <= availRwrd) {
741       balanceRwrdForClient[client] = availRwrd - feesRwrd;
742       balanceRwrdForClient[feeCollector] = feesRwrd;
743       // Need += rather than = because could have paid some fees earlier in NeedsGas situation.
744       // Overflow safe since we ensure order size < 10^30 in both currencies (see baseMaxSize).
745       // Can truncate to zero, which is fine.
746       order.feesRwrd += uint128(feesRwrd);
747       if (isBuyPrice(order.price)) {
748         balanceBaseForClient[client] += liquidityTakenBase;
749       } else {
750         balanceCntrForClient[client] += liquidityTakenCntr;
751       }
752     } else if (isBuyPrice(order.price)) {
753       // See comments in branch above re: use of += and overflow safety.
754       feesBaseOrCntr = liquidityTakenBase / feeDivisor;
755       balanceBaseForClient[order.client] += (liquidityTakenBase - feesBaseOrCntr);
756       order.feesBaseOrCntr += uint128(feesBaseOrCntr);
757       balanceBaseForClient[feeCollector] += feesBaseOrCntr;
758     } else {
759       // See comments in branch above re: use of += and overflow safety.
760       feesBaseOrCntr = liquidityTakenCntr / feeDivisor;
761       balanceCntrForClient[order.client] += (liquidityTakenCntr - feesBaseOrCntr);
762       order.feesBaseOrCntr += uint128(feesBaseOrCntr);
763       balanceCntrForClient[feeCollector] += feesBaseOrCntr;
764     }
765   }
766 
767   // Internal Order Placement - process a created and sanity checked order.
768   //
769   // Used both for new orders and for gas topup.
770   //
771   function processOrder(uint128 orderId, uint maxMatches) internal {
772     Order storage order = orderForOrderId[orderId];
773 
774     uint ourOriginalExecutedBase = order.executedBase;
775     uint ourOriginalExecutedCntr = order.executedCntr;
776 
777     var (ourDirection,) = unpackPrice(order.price);
778     uint theirPriceStart = (ourDirection == Direction.Buy) ? minSellPrice : maxBuyPrice;
779     uint theirPriceEnd = computeOppositePrice(order.price);
780    
781     MatchStopReason matchStopReason =
782       matchAgainstBook(orderId, theirPriceStart, theirPriceEnd, maxMatches);
783 
784     creditExecutedFundsLessFees(orderId, ourOriginalExecutedBase, ourOriginalExecutedCntr);
785 
786     if (order.terms == Terms.ImmediateOrCancel) {
787       if (matchStopReason == MatchStopReason.Satisfied) {
788         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
789         return;
790       } else if (matchStopReason == MatchStopReason.MaxMatches) {
791         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.TooManyMatches);
792         return;
793       } else if (matchStopReason == MatchStopReason.BookExhausted) {
794         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.Unmatched);
795         return;
796       }
797     } else if (order.terms == Terms.MakerOnly) {
798       if (matchStopReason == MatchStopReason.MaxMatches) {
799         refundUnmatchedAndFinish(orderId, Status.Rejected, ReasonCode.WouldTake);
800         return;
801       } else if (matchStopReason == MatchStopReason.BookExhausted) {
802         enterOrder(orderId);
803         return;
804       }
805     } else if (order.terms == Terms.GTCNoGasTopup) {
806       if (matchStopReason == MatchStopReason.Satisfied) {
807         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
808         return;
809       } else if (matchStopReason == MatchStopReason.MaxMatches) {
810         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.TooManyMatches);
811         return;
812       } else if (matchStopReason == MatchStopReason.BookExhausted) {
813         enterOrder(orderId);
814         return;
815       }
816     } else if (order.terms == Terms.GTCWithGasTopup) {
817       if (matchStopReason == MatchStopReason.Satisfied) {
818         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
819         return;
820       } else if (matchStopReason == MatchStopReason.MaxMatches) {
821         order.status = Status.NeedsGas;
822         return;
823       } else if (matchStopReason == MatchStopReason.BookExhausted) {
824         enterOrder(orderId);
825         return;
826       }
827     }
828     assert(false); // should not be possible to reach here
829   }
830  
831   // Used internally to indicate why we stopped matching an order against the book.
832 
833   enum MatchStopReason {
834     None,
835     MaxMatches,
836     Satisfied,
837     PriceExhausted,
838     BookExhausted
839   }
840  
841   // Internal Order Placement - Match the given order against the book.
842   //
843   // Resting orders matched will be updated, removed from book and funds credited to their owners.
844   //
845   // Only updates the executedBase and executedCntr of the given order - caller is responsible
846   // for crediting matched funds, charging fees, marking order as done / entering it into the book.
847   //
848   // matchStopReason returned will be one of MaxMatches, Satisfied or BookExhausted.
849   //
850   // Calling with maxMatches == 0 is ok - and expected when the order is a maker-only order.
851   //
852   function matchAgainstBook(
853       uint128 orderId, uint theirPriceStart, uint theirPriceEnd, uint maxMatches
854     ) internal returns (
855       MatchStopReason matchStopReason
856     ) {
857     Order storage order = orderForOrderId[orderId];
858     
859     uint bmi = theirPriceStart / 256;  // index into array of bitmaps
860     uint bti = theirPriceStart % 256;  // bit position within bitmap
861     uint bmiEnd = theirPriceEnd / 256; // last bitmap to search
862     uint btiEnd = theirPriceEnd % 256; // stop at this bit in the last bitmap
863 
864     uint cbm = occupiedPriceBitmaps[bmi]; // original copy of current bitmap
865     uint dbm = cbm; // dirty version of current bitmap where we may have cleared bits
866     uint wbm = cbm >> bti; // working copy of current bitmap which we keep shifting
867     
868     // these loops are pretty ugly, and somewhat unpredicatable in terms of gas,
869     // ... but no-one else has come up with a better matching engine yet!
870 
871     bool removedLastAtPrice;
872     matchStopReason = MatchStopReason.None;
873 
874     while (bmi < bmiEnd) {
875       if (wbm == 0 || bti == 256) {
876         if (dbm != cbm) {
877           occupiedPriceBitmaps[bmi] = dbm;
878         }
879         bti = 0;
880         bmi++;
881         cbm = occupiedPriceBitmaps[bmi];
882         wbm = cbm;
883         dbm = cbm;
884       } else {
885         if ((wbm & 1) != 0) {
886           // careful - copy-and-pasted in loop below ...
887           (removedLastAtPrice, maxMatches, matchStopReason) =
888             matchWithOccupiedPrice(order, uint16(bmi * 256 + bti), maxMatches);
889           if (removedLastAtPrice) {
890             dbm ^= 2 ** bti;
891           }
892           if (matchStopReason == MatchStopReason.PriceExhausted) {
893             matchStopReason = MatchStopReason.None;
894           } else if (matchStopReason != MatchStopReason.None) {
895             // we might still have changes in dbm to write back - see later
896             break;
897           }
898         }
899         bti += 1;
900         wbm /= 2;
901       }
902     }
903     if (matchStopReason == MatchStopReason.None) {
904       // we've reached the last bitmap we need to search,
905       // we'll stop at btiEnd not 256 this time.
906       while (bti <= btiEnd && wbm != 0) {
907         if ((wbm & 1) != 0) {
908           // careful - copy-and-pasted in loop above ...
909           (removedLastAtPrice, maxMatches, matchStopReason) =
910             matchWithOccupiedPrice(order, uint16(bmi * 256 + bti), maxMatches);
911           if (removedLastAtPrice) {
912             dbm ^= 2 ** bti;
913           }
914           if (matchStopReason == MatchStopReason.PriceExhausted) {
915             matchStopReason = MatchStopReason.None;
916           } else if (matchStopReason != MatchStopReason.None) {
917             break;
918           }
919         }
920         bti += 1;
921         wbm /= 2;
922       }
923     }
924     // Careful - if we exited the first loop early, or we went into the second loop,
925     // (luckily can't both happen) then we haven't flushed the dirty bitmap back to
926     // storage - do that now if we need to.
927     if (dbm != cbm) {
928       occupiedPriceBitmaps[bmi] = dbm;
929     }
930     if (matchStopReason == MatchStopReason.None) {
931       matchStopReason = MatchStopReason.BookExhausted;
932     }
933   }
934 
935   // Internal Order Placement.
936   //
937   // Match our order against up to maxMatches resting orders at the given price (which
938   // is known by the caller to have at least one resting order).
939   //
940   // The matches (partial or complete) of the resting orders are recorded, and their
941   // funds are credited.
942   //
943   // The order chain for the resting orders is updated, but the occupied price bitmap is NOT -
944   // the caller must clear the relevant bit if removedLastAtPrice = true is returned.
945   //
946   // Only updates the executedBase and executedCntr of our order - caller is responsible
947   // for e.g. crediting our matched funds, updating status.
948   //
949   // Calling with maxMatches == 0 is ok - and expected when the order is a maker-only order.
950   //
951   // Returns:
952   //   removedLastAtPrice:
953   //     true iff there are no longer any resting orders at this price - caller will need
954   //     to update the occupied price bitmap.
955   //
956   //   matchesLeft:
957   //     maxMatches passed in minus the number of matches made by this call
958   //
959   //   matchStopReason:
960   //     If our order is completely matched, matchStopReason will be Satisfied.
961   //     If our order is not completely matched, matchStopReason will be either:
962   //        MaxMatches (we are not allowed to match any more times)
963   //     or:
964   //        PriceExhausted (nothing left on the book at this exact price)
965   //
966   function matchWithOccupiedPrice(
967       Order storage ourOrder, uint16 theirPrice, uint maxMatches
968     ) internal returns (
969     bool removedLastAtPrice, uint matchesLeft, MatchStopReason matchStopReason) {
970     matchesLeft = maxMatches;
971     uint workingOurExecutedBase = ourOrder.executedBase;
972     uint workingOurExecutedCntr = ourOrder.executedCntr;
973     uint128 theirOrderId = orderChainForOccupiedPrice[theirPrice].firstOrderId;
974     matchStopReason = MatchStopReason.None;
975     while (true) {
976       if (matchesLeft == 0) {
977         matchStopReason = MatchStopReason.MaxMatches;
978         break;
979       }
980       uint matchBase;
981       uint matchCntr;
982       (theirOrderId, matchBase, matchCntr, matchStopReason) =
983         matchWithTheirs((ourOrder.sizeBase - workingOurExecutedBase), theirOrderId, theirPrice);
984       workingOurExecutedBase += matchBase;
985       workingOurExecutedCntr += matchCntr;
986       matchesLeft -= 1;
987       if (matchStopReason != MatchStopReason.None) {
988         break;
989       }
990     }
991     ourOrder.executedBase = uint128(workingOurExecutedBase);
992     ourOrder.executedCntr = uint128(workingOurExecutedCntr);
993     if (theirOrderId == 0) {
994       orderChainForOccupiedPrice[theirPrice].firstOrderId = 0;
995       orderChainForOccupiedPrice[theirPrice].lastOrderId = 0;
996       removedLastAtPrice = true;
997     } else {
998       // NB: in some cases (e.g. maxMatches == 0) this is a no-op.
999       orderChainForOccupiedPrice[theirPrice].firstOrderId = theirOrderId;
1000       orderChainNodeForOpenOrderId[theirOrderId].prevOrderId = 0;
1001       removedLastAtPrice = false;
1002     }
1003   }
1004   
1005   // Internal Order Placement.
1006   //
1007   // Match up to our remaining amount against a resting order in the book.
1008   //
1009   // The match (partial, complete or effectively-complete) of the resting order
1010   // is recorded, and their funds are credited.
1011   //
1012   // Their order is NOT removed from the book by this call - the caller must do that
1013   // if the nextTheirOrderId returned is not equal to the theirOrderId passed in.
1014   //
1015   // Returns:
1016   //
1017   //   nextTheirOrderId:
1018   //     If we did not completely match their order, will be same as theirOrderId.
1019   //     If we completely matched their order, will be orderId of next order at the
1020   //     same price - or zero if this was the last order and we've now filled it.
1021   //
1022   //   matchStopReason:
1023   //     If our order is completely matched, matchStopReason will be Satisfied.
1024   //     If our order is not completely matched, matchStopReason will be either
1025   //     PriceExhausted (if nothing left at this exact price) or None (if can continue).
1026   // 
1027   function matchWithTheirs(
1028     uint ourRemainingBase, uint128 theirOrderId, uint16 theirPrice) internal returns (
1029     uint128 nextTheirOrderId, uint matchBase, uint matchCntr, MatchStopReason matchStopReason) {
1030     Order storage theirOrder = orderForOrderId[theirOrderId];
1031     uint theirRemainingBase = theirOrder.sizeBase - theirOrder.executedBase;
1032     if (ourRemainingBase < theirRemainingBase) {
1033       matchBase = ourRemainingBase;
1034     } else {
1035       matchBase = theirRemainingBase;
1036     }
1037     matchCntr = computeCntrAmountUsingPacked(matchBase, theirPrice);
1038     // It may seem a bit odd to stop here if our remaining amount is very small -
1039     // there could still be resting orders we can match it against. But the gas
1040     // cost of matching each order is quite high - potentially high enough to
1041     // wipe out the profit the taker hopes for from trading the tiny amount left.
1042     if ((ourRemainingBase - matchBase) < baseMinRemainingSize) {
1043       matchStopReason = MatchStopReason.Satisfied;
1044     } else {
1045       matchStopReason = MatchStopReason.None;
1046     }
1047     bool theirsDead = recordTheirMatch(theirOrder, theirOrderId, theirPrice, matchBase, matchCntr);
1048     if (theirsDead) {
1049       nextTheirOrderId = orderChainNodeForOpenOrderId[theirOrderId].nextOrderId;
1050       if (matchStopReason == MatchStopReason.None && nextTheirOrderId == 0) {
1051         matchStopReason = MatchStopReason.PriceExhausted;
1052       }
1053     } else {
1054       nextTheirOrderId = theirOrderId;
1055     }
1056   }
1057 
1058   // Internal Order Placement.
1059   //
1060   // Record match (partial or complete) of resting order, and credit them their funds.
1061   //
1062   // If their order is completely matched, the order is marked as done,
1063   // and "theirsDead" is returned as true.
1064   //
1065   // The order is NOT removed from the book by this call - the caller
1066   // must do that if theirsDead is true.
1067   //
1068   // No sanity checks are made - the caller must be sure the order is
1069   // not already done and has sufficient remaining. (Yes, we'd like to
1070   // check here too but we cannot afford the gas).
1071   //
1072   function recordTheirMatch(
1073       Order storage theirOrder, uint128 theirOrderId, uint16 theirPrice, uint matchBase, uint matchCntr
1074     ) internal returns (bool theirsDead) {
1075     // they are a maker so no fees
1076     // overflow safe - see comments about baseMaxSize
1077     // executedBase cannot go > sizeBase due to logic in matchWithTheirs
1078     theirOrder.executedBase += uint128(matchBase);
1079     theirOrder.executedCntr += uint128(matchCntr);
1080     if (isBuyPrice(theirPrice)) {
1081       // they have bought base (using the counter they already paid when creating the order)
1082       balanceBaseForClient[theirOrder.client] += matchBase;
1083     } else {
1084       // they have bought counter (using the base they already paid when creating the order)
1085       balanceCntrForClient[theirOrder.client] += matchCntr;
1086     }
1087     uint stillRemainingBase = theirOrder.sizeBase - theirOrder.executedBase;
1088     // avoid leaving tiny amounts in the book - refund remaining if too small
1089     if (stillRemainingBase < baseMinRemainingSize) {
1090       refundUnmatchedAndFinish(theirOrderId, Status.Done, ReasonCode.None);
1091       // someone building an UI on top needs to know how much was match and how much was refund
1092       MarketOrderEvent(block.timestamp, theirOrderId, MarketOrderEventType.CompleteFill,
1093         theirPrice, matchBase + stillRemainingBase, matchBase);
1094       return true;
1095     } else {
1096       MarketOrderEvent(block.timestamp, theirOrderId, MarketOrderEventType.PartialFill,
1097         theirPrice, matchBase, matchBase);
1098       return false;
1099     }
1100   }
1101 
1102   // Internal Order Placement.
1103   //
1104   // Refund any unmatched funds in an order (based on executed vs size) and move to a final state.
1105   //
1106   // The order is NOT removed from the book by this call and no event is raised.
1107   //
1108   // No sanity checks are made - the caller must be sure the order has not already been refunded.
1109   //
1110   function refundUnmatchedAndFinish(uint128 orderId, Status status, ReasonCode reasonCode) internal {
1111     Order storage order = orderForOrderId[orderId];
1112     uint16 price = order.price;
1113     if (isBuyPrice(price)) {
1114       uint sizeCntr = computeCntrAmountUsingPacked(order.sizeBase, price);
1115       balanceCntrForClient[order.client] += sizeCntr - order.executedCntr;
1116     } else {
1117       balanceBaseForClient[order.client] += order.sizeBase - order.executedBase;
1118     }
1119     order.status = status;
1120     order.reasonCode = reasonCode;
1121   }
1122 
1123   // Internal Order Placement.
1124   //
1125   // Enter a not completely matched order into the book, marking the order as open.
1126   //
1127   // This updates the occupied price bitmap and chain.
1128   //
1129   // No sanity checks are made - the caller must be sure the order
1130   // has some unmatched amount and has been paid for!
1131   //
1132   function enterOrder(uint128 orderId) internal {
1133     Order storage order = orderForOrderId[orderId];
1134     uint16 price = order.price;
1135     OrderChain storage orderChain = orderChainForOccupiedPrice[price];
1136     OrderChainNode storage orderChainNode = orderChainNodeForOpenOrderId[orderId];
1137     if (orderChain.firstOrderId == 0) {
1138       orderChain.firstOrderId = orderId;
1139       orderChain.lastOrderId = orderId;
1140       orderChainNode.nextOrderId = 0;
1141       orderChainNode.prevOrderId = 0;
1142       uint bitmapIndex = price / 256;
1143       uint bitIndex = price % 256;
1144       occupiedPriceBitmaps[bitmapIndex] |= (2 ** bitIndex);
1145     } else {
1146       uint128 existingLastOrderId = orderChain.lastOrderId;
1147       OrderChainNode storage existingLastOrderChainNode = orderChainNodeForOpenOrderId[existingLastOrderId];
1148       orderChainNode.nextOrderId = 0;
1149       orderChainNode.prevOrderId = existingLastOrderId;
1150       existingLastOrderChainNode.nextOrderId = orderId;
1151       orderChain.lastOrderId = orderId;
1152     }
1153     MarketOrderEvent(block.timestamp, orderId, MarketOrderEventType.Add,
1154       price, order.sizeBase - order.executedBase, 0);
1155     order.status = Status.Open;
1156   }
1157 
1158   // Internal Order Placement.
1159   //
1160   // Charge the client for the cost of placing an order in the given direction.
1161   //
1162   // Return true if successful, false otherwise.
1163   //
1164   function debitFunds(
1165       address client, Direction direction, uint sizeBase, uint sizeCntr
1166     ) internal returns (bool success) {
1167     if (direction == Direction.Buy) {
1168       uint availableCntr = balanceCntrForClient[client];
1169       if (availableCntr < sizeCntr) {
1170         return false;
1171       }
1172       balanceCntrForClient[client] = availableCntr - sizeCntr;
1173       return true;
1174     } else if (direction == Direction.Sell) {
1175       uint availableBase = balanceBaseForClient[client];
1176       if (availableBase < sizeBase) {
1177         return false;
1178       }
1179       balanceBaseForClient[client] = availableBase - sizeBase;
1180       return true;
1181     } else {
1182       return false;
1183     }
1184   }
1185 
1186   // Public Book View
1187   // 
1188   // Intended for public book depth enumeration from web3 (or similar).
1189   //
1190   // Not suitable for use from a smart contract transaction - gas usage
1191   // could be very high if we have many orders at the same price.
1192   //
1193   // Start at the given inclusive price (and side) and walk down the book
1194   // (getting less aggressive) until we find some open orders or reach the
1195   // least aggressive price.
1196   //
1197   // Returns the price where we found the order(s), the depth at that price
1198   // (zero if none found), order count there, and the current blockNumber.
1199   //
1200   // (The blockNumber is handy if you're taking a snapshot which you intend
1201   //  to keep up-to-date with the market order events).
1202   //
1203   // To walk the book, the caller should start by calling walkBook with the
1204   // most aggressive buy price (Buy @ 999000).
1205   // If the price returned is the least aggressive buy price (Buy @ 0.000001),
1206   // the side is complete.
1207   // Otherwise, call walkBook again with the (packed) price returned + 1.
1208   // Then repeat for the sell side, starting with Sell @ 0.000001 and stopping
1209   // when Sell @ 999000 is returned.
1210   //
1211   function walkBook(uint16 fromPrice) public constant returns (
1212       uint16 price, uint depthBase, uint orderCount, uint blockNumber
1213     ) {
1214     uint priceStart = fromPrice;
1215     uint priceEnd = (isBuyPrice(fromPrice)) ? minBuyPrice : maxSellPrice;
1216     
1217     // See comments in matchAgainstBook re: how these crazy loops work.
1218     
1219     uint bmi = priceStart / 256;
1220     uint bti = priceStart % 256;
1221     uint bmiEnd = priceEnd / 256;
1222     uint btiEnd = priceEnd % 256;
1223 
1224     uint wbm = occupiedPriceBitmaps[bmi] >> bti;
1225     
1226     while (bmi < bmiEnd) {
1227       if (wbm == 0 || bti == 256) {
1228         bti = 0;
1229         bmi++;
1230         wbm = occupiedPriceBitmaps[bmi];
1231       } else {
1232         if ((wbm & 1) != 0) {
1233           // careful - copy-pasted in below loop
1234           price = uint16(bmi * 256 + bti);
1235           (depthBase, orderCount) = sumDepth(orderChainForOccupiedPrice[price].firstOrderId);
1236           return (price, depthBase, orderCount, block.number);
1237         }
1238         bti += 1;
1239         wbm /= 2;
1240       }
1241     }
1242     // we've reached the last bitmap we need to search, stop at btiEnd not 256 this time.
1243     while (bti <= btiEnd && wbm != 0) {
1244       if ((wbm & 1) != 0) {
1245         // careful - copy-pasted in above loop
1246         price = uint16(bmi * 256 + bti);
1247         (depthBase, orderCount) = sumDepth(orderChainForOccupiedPrice[price].firstOrderId);
1248         return (price, depthBase, orderCount, block.number);
1249       }
1250       bti += 1;
1251       wbm /= 2;
1252     }
1253     return (uint16(priceEnd), 0, 0, block.number);
1254   }
1255 
1256   // Internal Book View.
1257   //
1258   // See walkBook - adds up open depth at a price starting from an
1259   // order which is assumed to be open. Careful - unlimited gas use.
1260   //
1261   function sumDepth(uint128 orderId) internal constant returns (uint depth, uint orderCount) {
1262     while (true) {
1263       Order storage order = orderForOrderId[orderId];
1264       depth += order.sizeBase - order.executedBase;
1265       orderCount++;
1266       orderId = orderChainNodeForOpenOrderId[orderId].nextOrderId;
1267       if (orderId == 0) {
1268         return (depth, orderCount);
1269       }
1270     }
1271   }
1272 }