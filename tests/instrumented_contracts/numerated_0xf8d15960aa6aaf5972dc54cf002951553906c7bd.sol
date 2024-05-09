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
18 // Version 1.0.0.
19 //
20 contract BookERC20EthV1 {
21 
22   enum BookType {
23     ERC20EthV1
24   }
25 
26   enum Direction {
27     Invalid,
28     Buy,
29     Sell
30   }
31 
32   enum Status {
33     Unknown,
34     Rejected,
35     Open,
36     Done,
37     NeedsGas,
38     Sending, // not used by contract - web only
39     FailedSend, // not used by contract - web only
40     FailedTxn // not used by contract - web only
41   }
42 
43   enum ReasonCode {
44     None,
45     InvalidPrice,
46     InvalidSize,
47     InvalidTerms,
48     InsufficientFunds,
49     WouldTake,
50     Unmatched,
51     TooManyMatches,
52     ClientCancel
53   }
54 
55   enum Terms {
56     GTCNoGasTopup,
57     GTCWithGasTopup,
58     ImmediateOrCancel,
59     MakerOnly
60   }
61 
62   struct Order {
63     // these are immutable once placed:
64 
65     address client;
66     uint16 price;              // packed representation of side + price
67     uint sizeBase;
68     Terms terms;
69 
70     // these are mutable until Done or Rejected:
71     
72     Status status;
73     ReasonCode reasonCode;
74     uint128 executedBase;      // gross amount executed in base currency (before fee deduction)
75     uint128 executedCntr;      // gross amount executed in counter currency (before fee deduction)
76     uint128 feesBaseOrCntr;    // base for buy, cntr for sell
77     uint128 feesRwrd;
78   }
79   
80   struct OrderChain {
81     uint128 firstOrderId;
82     uint128 lastOrderId;
83   }
84 
85   struct OrderChainNode {
86     uint128 nextOrderId;
87     uint128 prevOrderId;
88   }
89   
90   // It should be possible to reconstruct the expected state of the contract given:
91   //  - ClientPaymentEvent log history
92   //  - ClientOrderEvent log history
93   //  - Calling getOrder for the other immutable order fields of orders referenced by ClientOrderEvent
94   
95   enum ClientPaymentEventType {
96     Deposit,
97     Withdraw,
98     TransferFrom,
99     Transfer
100   }
101 
102   enum BalanceType {
103     Base,
104     Cntr,
105     Rwrd
106   }
107 
108   event ClientPaymentEvent(
109     address indexed client,
110     ClientPaymentEventType clientPaymentEventType,
111     BalanceType balanceType,
112     int clientBalanceDelta
113   );
114 
115   enum ClientOrderEventType {
116     Create,
117     Continue,
118     Cancel
119   }
120 
121   event ClientOrderEvent(
122     address indexed client,
123     ClientOrderEventType clientOrderEventType,
124     uint128 orderId,
125     uint maxMatches
126   );
127 
128   enum MarketOrderEventType {
129     // orderCount++, depth += depthBase
130     Add,
131     // orderCount--, depth -= depthBase
132     Remove,
133     // orderCount--, depth -= depthBase, traded += tradeBase
134     // (depth change and traded change differ when tiny remaining amount refunded)
135     CompleteFill,
136     // orderCount unchanged, depth -= depthBase, traded += tradeBase
137     PartialFill
138   }
139 
140   // Technically not needed but these events can be used to maintain an order book or
141   // watch for fills. Note that the orderId and price are those of the maker.
142 
143   event MarketOrderEvent(
144     uint256 indexed eventTimestamp,
145     uint128 indexed orderId,
146     MarketOrderEventType marketOrderEventType,
147     uint16 price,
148     uint depthBase,
149     uint tradeBase
150   );
151 
152   // the base token (e.g. TEST)
153   
154   ERC20 baseToken;
155 
156   // minimum order size (inclusive)
157   uint constant baseMinInitialSize = 100 finney;
158 
159   // if following partial match, the remaning gets smaller than this, remove from book and refund:
160   // generally we make this 10% of baseMinInitialSize
161   uint constant baseMinRemainingSize = 10 finney;
162 
163   // maximum order size (exclusive)
164   // chosen so that even multiplied by the max price (or divided by the min price),
165   // and then multiplied by ethRwrdRate, it still fits in 2^127, allowing us to save
166   // some gas by storing executed + fee fields as uint128.
167   // even with 18 decimals, this still allows order sizes up to 1,000,000,000.
168   // if we encounter a token with e.g. 36 decimals we'll have to revisit ...
169   uint constant baseMaxSize = 10 ** 30;
170 
171   // the counter currency (ETH)
172   // (no address because it is ETH)
173 
174   // avoid the book getting cluttered up with tiny amounts not worth the gas
175   uint constant cntrMinInitialSize = 10 finney;
176 
177   // see comments for baseMaxSize
178   uint constant cntrMaxSize = 10 ** 30;
179 
180   // the reward token that can be used to pay fees (UBI)
181 
182   ERC20 rwrdToken;
183 
184   // used to convert ETH amount to reward tokens when paying fee with reward tokens
185   uint constant ethRwrdRate = 1000;
186   
187   // funds that belong to clients (base, counter, and reward)
188 
189   mapping (address => uint) balanceBaseForClient;
190   mapping (address => uint) balanceCntrForClient;
191   mapping (address => uint) balanceRwrdForClient;
192 
193   // fee charged on liquidity taken, expressed as a divisor
194   // (e.g. 2000 means 1/2000, or 0.05%)
195 
196   uint constant feeDivisor = 2000;
197   
198   // fees charged are given to:
199   
200   address feeCollector;
201 
202   // all orders ever created
203   
204   mapping (uint128 => Order) orderForOrderId;
205   
206   // Effectively a compact mapping from price to whether there are any open orders at that price.
207   // See "Price Calculation Constants" below as to why 85.
208 
209   uint256[85] occupiedPriceBitmaps;
210 
211   // These allow us to walk over the orders in the book at a given price level (and add more).
212 
213   mapping (uint16 => OrderChain) orderChainForOccupiedPrice;
214   mapping (uint128 => OrderChainNode) orderChainNodeForOpenOrderId;
215 
216   // These allow a client to (reasonably) efficiently find their own orders
217   // without relying on events (which even indexed are a bit expensive to search
218   // and cannot be accessed from smart contracts). See walkOrders.
219 
220   mapping (address => uint128) mostRecentOrderIdForClient;
221   mapping (uint128 => uint128) clientPreviousOrderIdBeforeOrderId;
222 
223   // Price Calculation Constants.
224   //
225   // We pack direction and price into a crafty decimal floating point representation
226   // for efficient indexing by price, the main thing we lose by doing so is precision -
227   // we only have 3 significant figures in our prices.
228   //
229   // An unpacked price consists of:
230   //
231   //   direction - invalid / buy / sell
232   //   mantissa  - ranges from 100 to 999 representing 0.100 to 0.999
233   //   exponent  - ranges from minimumPriceExponent to minimumPriceExponent + 11
234   //               (e.g. -5 to +6 for a typical pair where minPriceExponent = -5)
235   //
236   // The packed representation has 21601 different price values:
237   //
238   //      0  = invalid (can be used as marker value)
239   //      1  = buy at maximum price (0.999 * 10 ** 6)
240   //    ...  = other buy prices in descending order
241   //   5400  = buy at 1.00
242   //    ...  = other buy prices in descending order
243   //  10800  = buy at minimum price (0.100 * 10 ** -5)
244   //  10801  = sell at minimum price (0.100 * 10 ** -5)
245   //    ...  = other sell prices in descending order
246   //  16201  = sell at 1.00
247   //    ...  = other sell prices in descending order
248   //  21600  = sell at maximum price (0.999 * 10 ** 6)
249   //  21601+ = do not use
250   //
251   // If we want to map each packed price to a boolean value (which we do),
252   // we require 85 256-bit words. Or 42.5 for each side of the book.
253   
254   int8 constant minPriceExponent = -5;
255 
256   uint constant invalidPrice = 0;
257 
258   // careful: max = largest unpacked value, not largest packed value
259   uint constant maxBuyPrice = 1; 
260   uint constant minBuyPrice = 10800;
261   uint constant minSellPrice = 10801;
262   uint constant maxSellPrice = 21600;
263 
264   // Constructor.
265   //
266   // Sets feeCollector to the creator. Creator needs to call init() to finish setup.
267   //
268   function BookERC20EthV1() {
269     address creator = msg.sender;
270     feeCollector = creator;
271   }
272 
273   // "Public" Management - set address of base and reward tokens.
274   //
275   // Can only be done once (normally immediately after creation) by the fee collector.
276   //
277   // Used instead of a constructor to make deployment easier.
278   //
279   function init(ERC20 _baseToken, ERC20 _rwrdToken) public {
280     require(msg.sender == feeCollector);
281     require(address(baseToken) == 0);
282     require(address(_baseToken) != 0);
283     require(address(rwrdToken) == 0);
284     require(address(_rwrdToken) != 0);
285     // attempt to catch bad tokens:
286     require(_baseToken.totalSupply() > 0);
287     baseToken = _baseToken;
288     require(_rwrdToken.totalSupply() > 0);
289     rwrdToken = _rwrdToken;
290   }
291 
292   // "Public" Management - change fee collector
293   //
294   // The new fee collector only gets fees charged after this point.
295   //
296   function changeFeeCollector(address newFeeCollector) public {
297     address oldFeeCollector = feeCollector;
298     require(msg.sender == oldFeeCollector);
299     require(newFeeCollector != oldFeeCollector);
300     feeCollector = newFeeCollector;
301   }
302   
303   // Public Info View - what is being traded here, what are the limits?
304   //
305   function getBookInfo() public constant returns (
306       BookType _bookType, address _baseToken, address _rwrdToken,
307       uint _baseMinInitialSize, uint _cntrMinInitialSize,
308       uint _feeDivisor, address _feeCollector
309     ) {
310     return (
311       BookType.ERC20EthV1,
312       address(baseToken),
313       address(rwrdToken),
314       baseMinInitialSize,
315       cntrMinInitialSize,
316       feeDivisor,
317       feeCollector
318     );
319   }
320 
321   // Public Funds View - get balances held by contract on behalf of the client,
322   // or balances approved for deposit but not yet claimed by the contract.
323   //
324   // Excludes funds in open orders.
325   //
326   // Helps a web ui get a consistent snapshot of balances.
327   //
328   // It would be nice to return the off-exchange ETH balance too but there's a
329   // bizarre bug in geth (and apparently as a result via MetaMask) that leads
330   // to unpredictable behaviour when looking up client balances in constant
331   // functions - see e.g. https://github.com/ethereum/solidity/issues/2325 .
332   //
333   function getClientBalances(address client) public constant returns (
334       uint bookBalanceBase,
335       uint bookBalanceCntr,
336       uint bookBalanceRwrd,
337       uint approvedBalanceBase,
338       uint approvedBalanceRwrd,
339       uint ownBalanceBase,
340       uint ownBalanceRwrd
341     ) {
342     bookBalanceBase = balanceBaseForClient[client];
343     bookBalanceCntr = balanceCntrForClient[client];
344     bookBalanceRwrd = balanceRwrdForClient[client];
345     approvedBalanceBase = baseToken.allowance(client, address(this));
346     approvedBalanceRwrd = rwrdToken.allowance(client, address(this));
347     ownBalanceBase = baseToken.balanceOf(client);
348     ownBalanceRwrd = rwrdToken.balanceOf(client);
349   }
350 
351   // Public Funds Manipulation - deposit previously-approved base tokens.
352   //
353   function transferFromBase() public {
354     address client = msg.sender;
355     address book = address(this);
356     // we trust the ERC20 token contract not to do nasty things like call back into us -
357     // if we cannot trust the token then why are we allowing it to be traded?
358     uint amountBase = baseToken.allowance(client, book);
359     require(amountBase > 0);
360     // NB: needs change for older ERC20 tokens that don't return bool
361     require(baseToken.transferFrom(client, book, amountBase));
362     // belt and braces
363     assert(baseToken.allowance(client, book) == 0);
364     balanceBaseForClient[client] += amountBase;
365     ClientPaymentEvent(client, ClientPaymentEventType.TransferFrom, BalanceType.Base, int(amountBase));
366   }
367 
368   // Public Funds Manipulation - withdraw base tokens (as a transfer).
369   //
370   function transferBase(uint amountBase) public {
371     address client = msg.sender;
372     require(amountBase > 0);
373     require(amountBase <= balanceBaseForClient[client]);
374     // overflow safe since we checked less than balance above
375     balanceBaseForClient[client] -= amountBase;
376     // we trust the ERC20 token contract not to do nasty things like call back into us -
377     // if we cannot trust the token then why are we allowing it to be traded?
378     // NB: needs change for older ERC20 tokens that don't return bool
379     require(baseToken.transfer(client, amountBase));
380     ClientPaymentEvent(client, ClientPaymentEventType.Transfer, BalanceType.Base, -int(amountBase));
381   }
382 
383   // Public Funds Manipulation - deposit counter currency (ETH).
384   //
385   function depositCntr() public payable {
386     address client = msg.sender;
387     uint amountCntr = msg.value;
388     require(amountCntr > 0);
389     // overflow safe - if someone owns pow(2,255) ETH we have bigger problems
390     balanceCntrForClient[client] += amountCntr;
391     ClientPaymentEvent(client, ClientPaymentEventType.Deposit, BalanceType.Cntr, int(amountCntr));
392   }
393 
394   // Public Funds Manipulation - withdraw counter currency (ETH).
395   //
396   function withdrawCntr(uint amountCntr) public {
397     address client = msg.sender;
398     require(amountCntr > 0);
399     require(amountCntr <= balanceCntrForClient[client]);
400     // overflow safe - checked less than balance above
401     balanceCntrForClient[client] -= amountCntr;
402     // safe - not enough gas to do anything interesting in fallback, already adjusted balance
403     client.transfer(amountCntr);
404     ClientPaymentEvent(client, ClientPaymentEventType.Withdraw, BalanceType.Cntr, -int(amountCntr));
405   }
406 
407   // Public Funds Manipulation - deposit previously-approved reward tokens.
408   //
409   function transferFromRwrd() public {
410     address client = msg.sender;
411     address book = address(this);
412     uint amountRwrd = rwrdToken.allowance(client, book);
413     require(amountRwrd > 0);
414     // we wrote the reward token so we know it supports ERC20 properly and is not evil
415     require(rwrdToken.transferFrom(client, book, amountRwrd));
416     // belt and braces
417     assert(rwrdToken.allowance(client, book) == 0);
418     balanceRwrdForClient[client] += amountRwrd;
419     ClientPaymentEvent(client, ClientPaymentEventType.TransferFrom, BalanceType.Rwrd, int(amountRwrd));
420   }
421 
422   // Public Funds Manipulation - withdraw base tokens (as a transfer).
423   //
424   function transferRwrd(uint amountRwrd) public {
425     address client = msg.sender;
426     require(amountRwrd > 0);
427     require(amountRwrd <= balanceRwrdForClient[client]);
428     // overflow safe - checked less than balance above
429     balanceRwrdForClient[client] -= amountRwrd;
430     // we wrote the reward token so we know it supports ERC20 properly and is not evil
431     require(rwrdToken.transfer(client, amountRwrd));
432     ClientPaymentEvent(client, ClientPaymentEventType.Transfer, BalanceType.Rwrd, -int(amountRwrd));
433   }
434 
435   // Public Order View - get full details of an order.
436   //
437   // If the orderId does not exist, status will be Unknown.
438   //
439   function getOrder(uint128 orderId) public constant returns (
440     address client, uint16 price, uint sizeBase, Terms terms,
441     Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
442     uint feesBaseOrCntr, uint feesRwrd) {
443     Order storage order = orderForOrderId[orderId];
444     return (order.client, order.price, order.sizeBase, order.terms,
445             order.status, order.reasonCode, order.executedBase, order.executedCntr,
446             order.feesBaseOrCntr, order.feesRwrd);
447   }
448 
449   // Public Order View - get mutable details of an order.
450   //
451   // If the orderId does not exist, status will be Unknown.
452   //
453   function getOrderState(uint128 orderId) public constant returns (
454     Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
455     uint feesBaseOrCntr, uint feesRwrd) {
456     Order storage order = orderForOrderId[orderId];
457     return (order.status, order.reasonCode, order.executedBase, order.executedCntr,
458             order.feesBaseOrCntr, order.feesRwrd);
459   }
460   
461   // Public Order View - enumerate all recent orders + all open orders for one client.
462   //
463   // Not really designed for use from a smart contract transaction.
464   //
465   // Idea is:
466   //  - client ensures order ids are generated so that most-signficant part is time-based;
467   //  - client decides they want all orders after a certain point-in-time,
468   //    and chooses minClosedOrderIdCutoff accordingly;
469   //  - before that point-in-time they just get open and needs gas orders
470   //  - client calls walkClientOrders with maybeLastOrderIdReturned = 0 initially;
471   //  - then repeats with the orderId returned by walkClientOrders;
472   //  - (and stops if it returns a zero orderId);
473   //
474   // Note that client is only used when maybeLastOrderIdReturned = 0.
475   //
476   function walkClientOrders(
477       address client, uint128 maybeLastOrderIdReturned, uint128 minClosedOrderIdCutoff
478     ) public constant returns (
479       uint128 orderId, uint16 price, uint sizeBase, Terms terms,
480       Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
481       uint feesBaseOrCntr, uint feesRwrd) {
482     if (maybeLastOrderIdReturned == 0) {
483       orderId = mostRecentOrderIdForClient[client];
484     } else {
485       orderId = clientPreviousOrderIdBeforeOrderId[maybeLastOrderIdReturned];
486     }
487     while (true) {
488       if (orderId == 0) return;
489       Order storage order = orderForOrderId[orderId];
490       if (orderId >= minClosedOrderIdCutoff) break;
491       if (order.status == Status.Open || order.status == Status.NeedsGas) break;
492       orderId = clientPreviousOrderIdBeforeOrderId[orderId];
493     }
494     return (orderId, order.price, order.sizeBase, order.terms,
495             order.status, order.reasonCode, order.executedBase, order.executedCntr,
496             order.feesBaseOrCntr, order.feesRwrd);
497   }
498  
499   // Internal Price Calculation - turn packed price into a friendlier unpacked price.
500   //
501   function unpackPrice(uint16 price) internal constant returns (
502       Direction direction, uint16 mantissa, int8 exponent
503     ) {
504     uint sidedPriceIndex = uint(price);
505     uint priceIndex;
506     if (sidedPriceIndex < 1 || sidedPriceIndex > maxSellPrice) {
507       direction = Direction.Invalid;
508       mantissa = 0;
509       exponent = 0;
510       return;
511     } else if (sidedPriceIndex <= minBuyPrice) {
512       direction = Direction.Buy;
513       priceIndex = minBuyPrice - sidedPriceIndex;
514     } else {
515       direction = Direction.Sell;
516       priceIndex = sidedPriceIndex - minSellPrice;
517     }
518     uint zeroBasedMantissa = priceIndex % 900;
519     uint zeroBasedExponent = priceIndex / 900;
520     mantissa = uint16(zeroBasedMantissa + 100);
521     exponent = int8(zeroBasedExponent) + minPriceExponent;
522     return;
523   }
524   
525   // Internal Price Calculation - is a packed price on the buy side?
526   //
527   // Throws an error if price is invalid.
528   //
529   function isBuyPrice(uint16 price) internal constant returns (bool isBuy) {
530     // yes, this looks odd, but max here is highest _unpacked_ price
531     return price >= maxBuyPrice && price <= minBuyPrice;
532   }
533   
534   // Internal Price Calculation - turn a packed buy price into a packed sell price.
535   //
536   // Invalid price remains invalid.
537   //
538   function computeOppositePrice(uint16 price) internal constant returns (uint16 opposite) {
539     if (price < maxBuyPrice || price > maxSellPrice) {
540       return uint16(invalidPrice);
541     } else if (price <= minBuyPrice) {
542       return uint16(maxSellPrice - (price - maxBuyPrice));
543     } else {
544       return uint16(maxBuyPrice + (maxSellPrice - price));
545     }
546   }
547   
548   // Internal Price Calculation - compute amount in counter currency that would
549   // be obtained by selling baseAmount at the given unpacked price (if no fees).
550   //
551   // Notes:
552   //  - Does not validate price - caller must ensure valid.
553   //  - Could overflow producing very unexpected results if baseAmount very
554   //    large - caller must check this.
555   //  - This rounds the amount towards zero.
556   //  - May truncate to zero if baseAmount very small - potentially allowing
557   //    zero-cost buys or pointless sales - caller must check this.
558   //
559   function computeCntrAmountUsingUnpacked(
560       uint baseAmount, uint16 mantissa, int8 exponent
561     ) internal constant returns (uint cntrAmount) {
562     if (exponent < 0) {
563       return baseAmount * uint(mantissa) / 1000 / 10 ** uint(-exponent);
564     } else {
565       return baseAmount * uint(mantissa) / 1000 * 10 ** uint(exponent);
566     }
567   }
568 
569   // Internal Price Calculation - compute amount in counter currency that would
570   // be obtained by selling baseAmount at the given packed price (if no fees).
571   //
572   // Notes:
573   //  - Does not validate price - caller must ensure valid.
574   //  - Direction of the packed price is ignored.
575   //  - Could overflow producing very unexpected results if baseAmount very
576   //    large - caller must check this.
577   //  - This rounds the amount towards zero (regardless of Buy or Sell).
578   //  - May truncate to zero if baseAmount very small - potentially allowing
579   //    zero-cost buys or pointless sales - caller must check this.
580   //
581   function computeCntrAmountUsingPacked(
582       uint baseAmount, uint16 price
583     ) internal constant returns (uint) {
584     var (, mantissa, exponent) = unpackPrice(price);
585     return computeCntrAmountUsingUnpacked(baseAmount, mantissa, exponent);
586   }
587 
588   // Public Order Placement - create order and try to match it and/or add it to the book.
589   //
590   function createOrder(
591       uint128 orderId, uint16 price, uint sizeBase, Terms terms, uint maxMatches
592     ) public {
593     address client = msg.sender;
594     require(orderId != 0 && orderForOrderId[orderId].client == 0);
595     ClientOrderEvent(client, ClientOrderEventType.Create, orderId, maxMatches);
596     orderForOrderId[orderId] =
597       Order(client, price, sizeBase, terms, Status.Unknown, ReasonCode.None, 0, 0, 0, 0);
598     uint128 previousMostRecentOrderIdForClient = mostRecentOrderIdForClient[client];
599     mostRecentOrderIdForClient[client] = orderId;
600     clientPreviousOrderIdBeforeOrderId[orderId] = previousMostRecentOrderIdForClient;
601     Order storage order = orderForOrderId[orderId];
602     var (direction, mantissa, exponent) = unpackPrice(price);
603     if (direction == Direction.Invalid) {
604       order.status = Status.Rejected;
605       order.reasonCode = ReasonCode.InvalidPrice;
606       return;
607     }
608     if (sizeBase < baseMinInitialSize || sizeBase > baseMaxSize) {
609       order.status = Status.Rejected;
610       order.reasonCode = ReasonCode.InvalidSize;
611       return;
612     }
613     uint sizeCntr = computeCntrAmountUsingUnpacked(sizeBase, mantissa, exponent);
614     if (sizeCntr < cntrMinInitialSize || sizeCntr > cntrMaxSize) {
615       order.status = Status.Rejected;
616       order.reasonCode = ReasonCode.InvalidSize;
617       return;
618     }
619     if (terms == Terms.MakerOnly && maxMatches != 0) {
620       order.status = Status.Rejected;
621       order.reasonCode = ReasonCode.InvalidTerms;
622       return;
623     }
624     if (!debitFunds(client, direction, sizeBase, sizeCntr)) {
625       order.status = Status.Rejected;
626       order.reasonCode = ReasonCode.InsufficientFunds;
627       return;
628     }
629     processOrder(orderId, maxMatches);
630   }
631 
632   // Public Order Placement - cancel order
633   //
634   function cancelOrder(uint128 orderId) public {
635     address client = msg.sender;
636     Order storage order = orderForOrderId[orderId];
637     require(order.client == client);
638     Status status = order.status;
639     if (status != Status.Open && status != Status.NeedsGas) {
640       return;
641     }
642     ClientOrderEvent(client, ClientOrderEventType.Cancel, orderId, 0);
643     if (status == Status.Open) {
644       removeOpenOrderFromBook(orderId);
645       MarketOrderEvent(block.timestamp, orderId, MarketOrderEventType.Remove, order.price,
646         order.sizeBase - order.executedBase, 0);
647     }
648     refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.ClientCancel);
649   }
650 
651   // Public Order Placement - continue placing an order in 'NeedsGas' state
652   //
653   function continueOrder(uint128 orderId, uint maxMatches) public {
654     address client = msg.sender;
655     Order storage order = orderForOrderId[orderId];
656     require(order.client == client);
657     if (order.status != Status.NeedsGas) {
658       return;
659     }
660     ClientOrderEvent(client, ClientOrderEventType.Continue, orderId, maxMatches);
661     order.status = Status.Unknown;
662     processOrder(orderId, maxMatches);
663   }
664 
665   // Internal Order Placement - remove a still-open order from the book.
666   //
667   // Caller's job to update/refund the order + raise event, this just
668   // updates the order chain and bitmask.
669   //
670   // Too expensive to do on each resting order match - we only do this for an
671   // order being cancelled. See matchWithOccupiedPrice for similar logic.
672   //
673   function removeOpenOrderFromBook(uint128 orderId) internal {
674     Order storage order = orderForOrderId[orderId];
675     uint16 price = order.price;
676     OrderChain storage orderChain = orderChainForOccupiedPrice[price];
677     OrderChainNode storage orderChainNode = orderChainNodeForOpenOrderId[orderId];
678     uint128 nextOrderId = orderChainNode.nextOrderId;
679     uint128 prevOrderId = orderChainNode.prevOrderId;
680     if (nextOrderId != 0) {
681       OrderChainNode storage nextOrderChainNode = orderChainNodeForOpenOrderId[nextOrderId];
682       nextOrderChainNode.prevOrderId = prevOrderId;
683     } else {
684       orderChain.lastOrderId = prevOrderId;
685     }
686     if (prevOrderId != 0) {
687       OrderChainNode storage prevOrderChainNode = orderChainNodeForOpenOrderId[prevOrderId];
688       prevOrderChainNode.nextOrderId = nextOrderId;
689     } else {
690       orderChain.firstOrderId = nextOrderId;
691     }
692     if (nextOrderId == 0 && prevOrderId == 0) {
693       uint bmi = price / 256;  // index into array of bitmaps
694       uint bti = price % 256;  // bit position within bitmap
695       // we know was previously occupied so XOR clears
696       occupiedPriceBitmaps[bmi] ^= 2 ** bti;
697     }
698   }
699 
700   // Internal Order Placement - credit funds received when taking liquidity from book
701   //
702   function creditExecutedFundsLessFees(uint128 orderId, uint originalExecutedBase, uint originalExecutedCntr) internal {
703     Order storage order = orderForOrderId[orderId];
704     uint liquidityTakenBase = order.executedBase - originalExecutedBase;
705     uint liquidityTakenCntr = order.executedCntr - originalExecutedCntr;
706     // Normally we deduct the fee from the currency bought (base for buy, cntr for sell),
707     // however we also accept reward tokens from the reward balance if it covers the fee,
708     // with the reward amount converted from the ETH amount (the counter currency here)
709     // at a fixed exchange rate.
710     // Overflow safe since we ensure order size < 10^30 in both currencies (see baseMaxSize).
711     // Can truncate to zero, which is fine.
712     uint feesRwrd = liquidityTakenCntr / feeDivisor * ethRwrdRate;
713     uint feesBaseOrCntr;
714     address client = order.client;
715     uint availRwrd = balanceRwrdForClient[client];
716     if (feesRwrd <= availRwrd) {
717       balanceRwrdForClient[client] = availRwrd - feesRwrd;
718       balanceRwrdForClient[feeCollector] = feesRwrd;
719       // Need += rather than = because could have paid some fees earlier in NeedsGas situation.
720       // Overflow safe since we ensure order size < 10^30 in both currencies (see baseMaxSize).
721       // Can truncate to zero, which is fine.
722       order.feesRwrd += uint128(feesRwrd);
723       if (isBuyPrice(order.price)) {
724         balanceBaseForClient[client] += liquidityTakenBase;
725       } else {
726         balanceCntrForClient[client] += liquidityTakenCntr;
727       }
728     } else if (isBuyPrice(order.price)) {
729       // See comments in branch above re: use of += and overflow safety.
730       feesBaseOrCntr = liquidityTakenBase / feeDivisor;
731       balanceBaseForClient[order.client] += (liquidityTakenBase - feesBaseOrCntr);
732       order.feesBaseOrCntr += uint128(feesBaseOrCntr);
733       balanceBaseForClient[feeCollector] += feesBaseOrCntr;
734     } else {
735       // See comments in branch above re: use of += and overflow safety.
736       feesBaseOrCntr = liquidityTakenCntr / feeDivisor;
737       balanceCntrForClient[order.client] += (liquidityTakenCntr - feesBaseOrCntr);
738       order.feesBaseOrCntr += uint128(feesBaseOrCntr);
739       balanceCntrForClient[feeCollector] += feesBaseOrCntr;
740     }
741   }
742 
743   // Internal Order Placement - process a created and sanity checked order.
744   //
745   // Used both for new orders and for gas topup.
746   //
747   function processOrder(uint128 orderId, uint maxMatches) internal {
748     Order storage order = orderForOrderId[orderId];
749 
750     uint ourOriginalExecutedBase = order.executedBase;
751     uint ourOriginalExecutedCntr = order.executedCntr;
752 
753     var (ourDirection,) = unpackPrice(order.price);
754     uint theirPriceStart = (ourDirection == Direction.Buy) ? minSellPrice : maxBuyPrice;
755     uint theirPriceEnd = computeOppositePrice(order.price);
756    
757     MatchStopReason matchStopReason =
758       matchAgainstBook(orderId, theirPriceStart, theirPriceEnd, maxMatches);
759 
760     creditExecutedFundsLessFees(orderId, ourOriginalExecutedBase, ourOriginalExecutedCntr);
761 
762     if (order.terms == Terms.ImmediateOrCancel) {
763       if (matchStopReason == MatchStopReason.Satisfied) {
764         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
765         return;
766       } else if (matchStopReason == MatchStopReason.MaxMatches) {
767         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.TooManyMatches);
768         return;
769       } else if (matchStopReason == MatchStopReason.BookExhausted) {
770         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.Unmatched);
771         return;
772       }
773     } else if (order.terms == Terms.MakerOnly) {
774       if (matchStopReason == MatchStopReason.MaxMatches) {
775         refundUnmatchedAndFinish(orderId, Status.Rejected, ReasonCode.WouldTake);
776         return;
777       } else if (matchStopReason == MatchStopReason.BookExhausted) {
778         enterOrder(orderId);
779         return;
780       }
781     } else if (order.terms == Terms.GTCNoGasTopup) {
782       if (matchStopReason == MatchStopReason.Satisfied) {
783         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
784         return;
785       } else if (matchStopReason == MatchStopReason.MaxMatches) {
786         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.TooManyMatches);
787         return;
788       } else if (matchStopReason == MatchStopReason.BookExhausted) {
789         enterOrder(orderId);
790         return;
791       }
792     } else if (order.terms == Terms.GTCWithGasTopup) {
793       if (matchStopReason == MatchStopReason.Satisfied) {
794         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
795         return;
796       } else if (matchStopReason == MatchStopReason.MaxMatches) {
797         order.status = Status.NeedsGas;
798         return;
799       } else if (matchStopReason == MatchStopReason.BookExhausted) {
800         enterOrder(orderId);
801         return;
802       }
803     }
804     assert(false); // should not be possible to reach here
805   }
806  
807   // Used internally to indicate why we stopped matching an order against the book.
808 
809   enum MatchStopReason {
810     None,
811     MaxMatches,
812     Satisfied,
813     PriceExhausted,
814     BookExhausted
815   }
816  
817   // Internal Order Placement - Match the given order against the book.
818   //
819   // Resting orders matched will be updated, removed from book and funds credited to their owners.
820   //
821   // Only updates the executedBase and executedCntr of the given order - caller is responsible
822   // for crediting matched funds, charging fees, marking order as done / entering it into the book.
823   //
824   // matchStopReason returned will be one of MaxMatches, Satisfied or BookExhausted.
825   //
826   // Calling with maxMatches == 0 is ok - and expected when the order is a maker-only order.
827   //
828   function matchAgainstBook(
829       uint128 orderId, uint theirPriceStart, uint theirPriceEnd, uint maxMatches
830     ) internal returns (
831       MatchStopReason matchStopReason
832     ) {
833     Order storage order = orderForOrderId[orderId];
834     
835     uint bmi = theirPriceStart / 256;  // index into array of bitmaps
836     uint bti = theirPriceStart % 256;  // bit position within bitmap
837     uint bmiEnd = theirPriceEnd / 256; // last bitmap to search
838     uint btiEnd = theirPriceEnd % 256; // stop at this bit in the last bitmap
839 
840     uint cbm = occupiedPriceBitmaps[bmi]; // original copy of current bitmap
841     uint dbm = cbm; // dirty version of current bitmap where we may have cleared bits
842     uint wbm = cbm >> bti; // working copy of current bitmap which we keep shifting
843     
844     // these loops are pretty ugly, and somewhat unpredicatable in terms of gas,
845     // ... but no-one else has come up with a better matching engine yet!
846 
847     bool removedLastAtPrice;
848     matchStopReason = MatchStopReason.None;
849 
850     while (bmi < bmiEnd) {
851       if (wbm == 0 || bti == 256) {
852         if (dbm != cbm) {
853           occupiedPriceBitmaps[bmi] = dbm;
854         }
855         bti = 0;
856         bmi++;
857         cbm = occupiedPriceBitmaps[bmi];
858         wbm = cbm;
859         dbm = cbm;
860       } else {
861         if ((wbm & 1) != 0) {
862           // careful - copy-and-pasted in loop below ...
863           (removedLastAtPrice, maxMatches, matchStopReason) =
864             matchWithOccupiedPrice(order, uint16(bmi * 256 + bti), maxMatches);
865           if (removedLastAtPrice) {
866             dbm ^= 2 ** bti;
867           }
868           if (matchStopReason == MatchStopReason.PriceExhausted) {
869             matchStopReason = MatchStopReason.None;
870           } else if (matchStopReason != MatchStopReason.None) {
871             // we might still have changes in dbm to write back - see later
872             break;
873           }
874         }
875         bti += 1;
876         wbm /= 2;
877       }
878     }
879     if (matchStopReason == MatchStopReason.None) {
880       // we've reached the last bitmap we need to search,
881       // we'll stop at btiEnd not 256 this time.
882       while (bti <= btiEnd && wbm != 0) {
883         if ((wbm & 1) != 0) {
884           // careful - copy-and-pasted in loop above ...
885           (removedLastAtPrice, maxMatches, matchStopReason) =
886             matchWithOccupiedPrice(order, uint16(bmi * 256 + bti), maxMatches);
887           if (removedLastAtPrice) {
888             dbm ^= 2 ** bti;
889           }
890           if (matchStopReason == MatchStopReason.PriceExhausted) {
891             matchStopReason = MatchStopReason.None;
892           } else if (matchStopReason != MatchStopReason.None) {
893             break;
894           }
895         }
896         bti += 1;
897         wbm /= 2;
898       }
899     }
900     // Careful - if we exited the first loop early, or we went into the second loop,
901     // (luckily can't both happen) then we haven't flushed the dirty bitmap back to
902     // storage - do that now if we need to.
903     if (dbm != cbm) {
904       occupiedPriceBitmaps[bmi] = dbm;
905     }
906     if (matchStopReason == MatchStopReason.None) {
907       matchStopReason = MatchStopReason.BookExhausted;
908     }
909   }
910 
911   // Internal Order Placement.
912   //
913   // Match our order against up to maxMatches resting orders at the given price (which
914   // is known by the caller to have at least one resting order).
915   //
916   // The matches (partial or complete) of the resting orders are recorded, and their
917   // funds are credited.
918   //
919   // The order chain for the resting orders is updated, but the occupied price bitmap is NOT -
920   // the caller must clear the relevant bit if removedLastAtPrice = true is returned.
921   //
922   // Only updates the executedBase and executedCntr of our order - caller is responsible
923   // for e.g. crediting our matched funds, updating status.
924   //
925   // Calling with maxMatches == 0 is ok - and expected when the order is a maker-only order.
926   //
927   // Returns:
928   //   removedLastAtPrice:
929   //     true iff there are no longer any resting orders at this price - caller will need
930   //     to update the occupied price bitmap.
931   //
932   //   matchesLeft:
933   //     maxMatches passed in minus the number of matches made by this call
934   //
935   //   matchStopReason:
936   //     If our order is completely matched, matchStopReason will be Satisfied.
937   //     If our order is not completely matched, matchStopReason will be either:
938   //        MaxMatches (we are not allowed to match any more times)
939   //     or:
940   //        PriceExhausted (nothing left on the book at this exact price)
941   //
942   function matchWithOccupiedPrice(
943       Order storage ourOrder, uint16 theirPrice, uint maxMatches
944     ) internal returns (
945     bool removedLastAtPrice, uint matchesLeft, MatchStopReason matchStopReason) {
946     matchesLeft = maxMatches;
947     uint workingOurExecutedBase = ourOrder.executedBase;
948     uint workingOurExecutedCntr = ourOrder.executedCntr;
949     uint128 theirOrderId = orderChainForOccupiedPrice[theirPrice].firstOrderId;
950     matchStopReason = MatchStopReason.None;
951     while (true) {
952       if (matchesLeft == 0) {
953         matchStopReason = MatchStopReason.MaxMatches;
954         break;
955       }
956       uint matchBase;
957       uint matchCntr;
958       (theirOrderId, matchBase, matchCntr, matchStopReason) =
959         matchWithTheirs((ourOrder.sizeBase - workingOurExecutedBase), theirOrderId, theirPrice);
960       workingOurExecutedBase += matchBase;
961       workingOurExecutedCntr += matchCntr;
962       matchesLeft -= 1;
963       if (matchStopReason != MatchStopReason.None) {
964         break;
965       }
966     }
967     ourOrder.executedBase = uint128(workingOurExecutedBase);
968     ourOrder.executedCntr = uint128(workingOurExecutedCntr);
969     if (theirOrderId == 0) {
970       orderChainForOccupiedPrice[theirPrice].firstOrderId = 0;
971       orderChainForOccupiedPrice[theirPrice].lastOrderId = 0;
972       removedLastAtPrice = true;
973     } else {
974       // NB: in some cases (e.g. maxMatches == 0) this is a no-op.
975       orderChainForOccupiedPrice[theirPrice].firstOrderId = theirOrderId;
976       orderChainNodeForOpenOrderId[theirOrderId].prevOrderId = 0;
977       removedLastAtPrice = false;
978     }
979   }
980   
981   // Internal Order Placement.
982   //
983   // Match up to our remaining amount against a resting order in the book.
984   //
985   // The match (partial, complete or effectively-complete) of the resting order
986   // is recorded, and their funds are credited.
987   //
988   // Their order is NOT removed from the book by this call - the caller must do that
989   // if the nextTheirOrderId returned is not equal to the theirOrderId passed in.
990   //
991   // Returns:
992   //
993   //   nextTheirOrderId:
994   //     If we did not completely match their order, will be same as theirOrderId.
995   //     If we completely matched their order, will be orderId of next order at the
996   //     same price - or zero if this was the last order and we've now filled it.
997   //
998   //   matchStopReason:
999   //     If our order is completely matched, matchStopReason will be Satisfied.
1000   //     If our order is not completely matched, matchStopReason will be either
1001   //     PriceExhausted (if nothing left at this exact price) or None (if can continue).
1002   // 
1003   function matchWithTheirs(
1004     uint ourRemainingBase, uint128 theirOrderId, uint16 theirPrice) internal returns (
1005     uint128 nextTheirOrderId, uint matchBase, uint matchCntr, MatchStopReason matchStopReason) {
1006     Order storage theirOrder = orderForOrderId[theirOrderId];
1007     uint theirRemainingBase = theirOrder.sizeBase - theirOrder.executedBase;
1008     if (ourRemainingBase < theirRemainingBase) {
1009       matchBase = ourRemainingBase;
1010     } else {
1011       matchBase = theirRemainingBase;
1012     }
1013     matchCntr = computeCntrAmountUsingPacked(matchBase, theirPrice);
1014     // It may seem a bit odd to stop here if our remaining amount is very small -
1015     // there could still be resting orders we can match it against. But the gas
1016     // cost of matching each order is quite high - potentially high enough to
1017     // wipe out the profit the taker hopes for from trading the tiny amount left.
1018     if ((ourRemainingBase - matchBase) < baseMinRemainingSize) {
1019       matchStopReason = MatchStopReason.Satisfied;
1020     } else {
1021       matchStopReason = MatchStopReason.None;
1022     }
1023     bool theirsDead = recordTheirMatch(theirOrder, theirOrderId, theirPrice, matchBase, matchCntr);
1024     if (theirsDead) {
1025       nextTheirOrderId = orderChainNodeForOpenOrderId[theirOrderId].nextOrderId;
1026       if (matchStopReason == MatchStopReason.None && nextTheirOrderId == 0) {
1027         matchStopReason = MatchStopReason.PriceExhausted;
1028       }
1029     } else {
1030       nextTheirOrderId = theirOrderId;
1031     }
1032   }
1033 
1034   // Internal Order Placement.
1035   //
1036   // Record match (partial or complete) of resting order, and credit them their funds.
1037   //
1038   // If their order is completely matched, the order is marked as done,
1039   // and "theirsDead" is returned as true.
1040   //
1041   // The order is NOT removed from the book by this call - the caller
1042   // must do that if theirsDead is true.
1043   //
1044   // No sanity checks are made - the caller must be sure the order is
1045   // not already done and has sufficient remaining. (Yes, we'd like to
1046   // check here too but we cannot afford the gas).
1047   //
1048   function recordTheirMatch(
1049       Order storage theirOrder, uint128 theirOrderId, uint16 theirPrice, uint matchBase, uint matchCntr
1050     ) internal returns (bool theirsDead) {
1051     // they are a maker so no fees
1052     // overflow safe - see comments about baseMaxSize
1053     // executedBase cannot go > sizeBase due to logic in matchWithTheirs
1054     theirOrder.executedBase += uint128(matchBase);
1055     theirOrder.executedCntr += uint128(matchCntr);
1056     if (isBuyPrice(theirPrice)) {
1057       // they have bought base (using the counter they already paid when creating the order)
1058       balanceBaseForClient[theirOrder.client] += matchBase;
1059     } else {
1060       // they have bought counter (using the base they already paid when creating the order)
1061       balanceCntrForClient[theirOrder.client] += matchCntr;
1062     }
1063     uint stillRemainingBase = theirOrder.sizeBase - theirOrder.executedBase;
1064     // avoid leaving tiny amounts in the book - refund remaining if too small
1065     if (stillRemainingBase < baseMinRemainingSize) {
1066       refundUnmatchedAndFinish(theirOrderId, Status.Done, ReasonCode.None);
1067       // someone building an UI on top needs to know how much was match and how much was refund
1068       MarketOrderEvent(block.timestamp, theirOrderId, MarketOrderEventType.CompleteFill,
1069         theirPrice, matchBase + stillRemainingBase, matchBase);
1070       return true;
1071     } else {
1072       MarketOrderEvent(block.timestamp, theirOrderId, MarketOrderEventType.PartialFill,
1073         theirPrice, matchBase, matchBase);
1074       return false;
1075     }
1076   }
1077 
1078   // Internal Order Placement.
1079   //
1080   // Refund any unmatched funds in an order (based on executed vs size) and move to a final state.
1081   //
1082   // The order is NOT removed from the book by this call and no event is raised.
1083   //
1084   // No sanity checks are made - the caller must be sure the order has not already been refunded.
1085   //
1086   function refundUnmatchedAndFinish(uint128 orderId, Status status, ReasonCode reasonCode) internal {
1087     Order storage order = orderForOrderId[orderId];
1088     uint16 price = order.price;
1089     if (isBuyPrice(price)) {
1090       uint sizeCntr = computeCntrAmountUsingPacked(order.sizeBase, price);
1091       balanceCntrForClient[order.client] += sizeCntr - order.executedCntr;
1092     } else {
1093       balanceBaseForClient[order.client] += order.sizeBase - order.executedBase;
1094     }
1095     order.status = status;
1096     order.reasonCode = reasonCode;
1097   }
1098 
1099   // Internal Order Placement.
1100   //
1101   // Enter a not completely matched order into the book, marking the order as open.
1102   //
1103   // This updates the occupied price bitmap and chain.
1104   //
1105   // No sanity checks are made - the caller must be sure the order
1106   // has some unmatched amount and has been paid for!
1107   //
1108   function enterOrder(uint128 orderId) internal {
1109     Order storage order = orderForOrderId[orderId];
1110     uint16 price = order.price;
1111     OrderChain storage orderChain = orderChainForOccupiedPrice[price];
1112     OrderChainNode storage orderChainNode = orderChainNodeForOpenOrderId[orderId];
1113     if (orderChain.firstOrderId == 0) {
1114       orderChain.firstOrderId = orderId;
1115       orderChain.lastOrderId = orderId;
1116       orderChainNode.nextOrderId = 0;
1117       orderChainNode.prevOrderId = 0;
1118       uint bitmapIndex = price / 256;
1119       uint bitIndex = price % 256;
1120       occupiedPriceBitmaps[bitmapIndex] |= (2 ** bitIndex);
1121     } else {
1122       uint128 existingLastOrderId = orderChain.lastOrderId;
1123       OrderChainNode storage existingLastOrderChainNode = orderChainNodeForOpenOrderId[existingLastOrderId];
1124       orderChainNode.nextOrderId = 0;
1125       orderChainNode.prevOrderId = existingLastOrderId;
1126       existingLastOrderChainNode.nextOrderId = orderId;
1127       orderChain.lastOrderId = orderId;
1128     }
1129     MarketOrderEvent(block.timestamp, orderId, MarketOrderEventType.Add,
1130       price, order.sizeBase - order.executedBase, 0);
1131     order.status = Status.Open;
1132   }
1133 
1134   // Internal Order Placement.
1135   //
1136   // Charge the client for the cost of placing an order in the given direction.
1137   //
1138   // Return true if successful, false otherwise.
1139   //
1140   function debitFunds(
1141       address client, Direction direction, uint sizeBase, uint sizeCntr
1142     ) internal returns (bool success) {
1143     if (direction == Direction.Buy) {
1144       uint availableCntr = balanceCntrForClient[client];
1145       if (availableCntr < sizeCntr) {
1146         return false;
1147       }
1148       balanceCntrForClient[client] = availableCntr - sizeCntr;
1149       return true;
1150     } else if (direction == Direction.Sell) {
1151       uint availableBase = balanceBaseForClient[client];
1152       if (availableBase < sizeBase) {
1153         return false;
1154       }
1155       balanceBaseForClient[client] = availableBase - sizeBase;
1156       return true;
1157     } else {
1158       return false;
1159     }
1160   }
1161 
1162   // Public Book View
1163   // 
1164   // Intended for public book depth enumeration from web3 (or similar).
1165   //
1166   // Not suitable for use from a smart contract transaction - gas usage
1167   // could be very high if we have many orders at the same price.
1168   //
1169   // Start at the given inclusive price (and side) and walk down the book
1170   // (getting less aggressive) until we find some open orders or reach the
1171   // least aggressive price.
1172   //
1173   // Returns the price where we found the order(s), the depth at that price
1174   // (zero if none found), order count there, and the current blockNumber.
1175   //
1176   // (The blockNumber is handy if you're taking a snapshot which you intend
1177   //  to keep up-to-date with the market order events).
1178   //
1179   // To walk the book, the caller should start by calling walkBook with the
1180   // most aggressive buy price (Buy @ 999000).
1181   // If the price returned is the least aggressive buy price (Buy @ 0.000001),
1182   // the side is complete.
1183   // Otherwise, call walkBook again with the (packed) price returned + 1.
1184   // Then repeat for the sell side, starting with Sell @ 0.000001 and stopping
1185   // when Sell @ 999000 is returned.
1186   //
1187   function walkBook(uint16 fromPrice) public constant returns (
1188       uint16 price, uint depthBase, uint orderCount, uint blockNumber
1189     ) {
1190     uint priceStart = fromPrice;
1191     uint priceEnd = (isBuyPrice(fromPrice)) ? minBuyPrice : maxSellPrice;
1192     
1193     // See comments in matchAgainstBook re: how these crazy loops work.
1194     
1195     uint bmi = priceStart / 256;
1196     uint bti = priceStart % 256;
1197     uint bmiEnd = priceEnd / 256;
1198     uint btiEnd = priceEnd % 256;
1199 
1200     uint wbm = occupiedPriceBitmaps[bmi] >> bti;
1201     
1202     while (bmi < bmiEnd) {
1203       if (wbm == 0 || bti == 256) {
1204         bti = 0;
1205         bmi++;
1206         wbm = occupiedPriceBitmaps[bmi];
1207       } else {
1208         if ((wbm & 1) != 0) {
1209           // careful - copy-pasted in below loop
1210           price = uint16(bmi * 256 + bti);
1211           (depthBase, orderCount) = sumDepth(orderChainForOccupiedPrice[price].firstOrderId);
1212           return (price, depthBase, orderCount, block.number);
1213         }
1214         bti += 1;
1215         wbm /= 2;
1216       }
1217     }
1218     // we've reached the last bitmap we need to search, stop at btiEnd not 256 this time.
1219     while (bti <= btiEnd && wbm != 0) {
1220       if ((wbm & 1) != 0) {
1221         // careful - copy-pasted in above loop
1222         price = uint16(bmi * 256 + bti);
1223         (depthBase, orderCount) = sumDepth(orderChainForOccupiedPrice[price].firstOrderId);
1224         return (price, depthBase, orderCount, block.number);
1225       }
1226       bti += 1;
1227       wbm /= 2;
1228     }
1229     return (uint16(priceEnd), 0, 0, block.number);
1230   }
1231 
1232   // Internal Book View.
1233   //
1234   // See walkBook - adds up open depth at a price starting from an
1235   // order which is assumed to be open. Careful - unlimited gas use.
1236   //
1237   function sumDepth(uint128 orderId) internal constant returns (uint depth, uint orderCount) {
1238     while (true) {
1239       Order storage order = orderForOrderId[orderId];
1240       depth += order.sizeBase - order.executedBase;
1241       orderCount++;
1242       orderId = orderChainNodeForOpenOrderId[orderId].nextOrderId;
1243       if (orderId == 0) {
1244         return (depth, orderCount);
1245       }
1246     }
1247   }
1248 }