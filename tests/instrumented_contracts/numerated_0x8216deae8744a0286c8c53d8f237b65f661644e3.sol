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
15 // UbiTok.io limit order book with an "nice" ERC20 token as base, ETH as quoted, and standard fees.
16 // Copyright (c) Bonnag Limited. All Rights Reserved.
17 //
18 contract BookERC20EthV1 {
19 
20   enum BookType {
21     ERC20EthV1
22   }
23 
24   enum Direction {
25     Invalid,
26     Buy,
27     Sell
28   }
29 
30   enum Status {
31     Unknown,
32     Rejected,
33     Open,
34     Done,
35     NeedsGas,
36     Sending, // not used by contract - web only
37     FailedSend, // not used by contract - web only
38     FailedTxn // not used by contract - web only
39   }
40 
41   enum ReasonCode {
42     None,
43     InvalidPrice,
44     InvalidSize,
45     InvalidTerms,
46     InsufficientFunds,
47     WouldTake,
48     Unmatched,
49     TooManyMatches,
50     ClientCancel
51   }
52 
53   enum Terms {
54     GTCNoGasTopup,
55     GTCWithGasTopup,
56     ImmediateOrCancel,
57     MakerOnly
58   }
59 
60   struct Order {
61     // these are immutable once placed:
62 
63     address client;
64     uint16 price;              // packed representation of side + price
65     uint sizeBase;
66     Terms terms;
67 
68     // these are mutable until Done or Rejected:
69     
70     Status status;
71     ReasonCode reasonCode;
72     uint128 executedBase;      // gross amount executed in base currency (before fee deduction)
73     uint128 executedCntr;      // gross amount executed in counter currency (before fee deduction)
74     uint128 feesBaseOrCntr;    // base for buy, cntr for sell
75     uint128 feesRwrd;
76   }
77   
78   struct OrderChain {
79     uint128 firstOrderId;
80     uint128 lastOrderId;
81   }
82 
83   struct OrderChainNode {
84     uint128 nextOrderId;
85     uint128 prevOrderId;
86   }
87   
88   enum ClientPaymentEventType {
89     Deposit,
90     Withdraw,
91     TransferFrom,
92     Transfer
93   }
94 
95   enum BalanceType {
96     Base,
97     Cntr,
98     Rwrd
99   }
100 
101   event ClientPaymentEvent(
102     address indexed client,
103     ClientPaymentEventType clientPaymentEventType,
104     BalanceType balanceType,
105     int clientBalanceDelta
106   );
107 
108   enum ClientOrderEventType {
109     Create,
110     Continue,
111     Cancel
112   }
113 
114   event ClientOrderEvent(
115     address indexed client,
116     ClientOrderEventType clientOrderEventType,
117     uint128 orderId
118   );
119 
120   enum MarketOrderEventType {
121     // orderCount++, depth += depthBase
122     Add,
123     // orderCount--, depth -= depthBase
124     Remove,
125     // orderCount--, depth -= depthBase, traded += tradeBase
126     // (depth change and traded change differ when tiny remaining amount refunded)
127     CompleteFill,
128     // orderCount unchanged, depth -= depthBase, traded += tradeBase
129     PartialFill
130   }
131 
132   // these events can be used to build an order book or watch for fills
133   // note that the orderId and price are those of the maker
134   event MarketOrderEvent(
135     uint256 indexed eventTimestamp,
136     uint128 indexed orderId,
137     MarketOrderEventType marketOrderEventType,
138     uint16 price,
139     uint depthBase,
140     uint tradeBase
141   );
142 
143   // the base token (e.g. TEST)
144   
145   ERC20 baseToken;
146 
147   // minimum order size (inclusive)
148   uint constant baseMinInitialSize = 100 finney;
149 
150   // if following partial match, the remaning gets smaller than this, remove from book and refund:
151   // generally we make this 10% of baseMinInitialSize
152   uint constant baseMinRemainingSize = 10 finney;
153 
154   // maximum order size (exclusive)
155   // chosen so that even multiplied by the max price (or divided by the min price),
156   // and then multiplied by ethRwrdRate, it still fits in 2^127, allowing us to save
157   // some gas by storing executed + fee fields as uint128.
158   // even with 18 decimals, this still allows order sizes up to 1,000,000,000.
159   // if we encounter a token with e.g. 36 decimals we'll have to revisit ...
160   uint constant baseMaxSize = 10 ** 30;
161 
162   // the counter currency (ETH)
163   // (no address because it is ETH)
164 
165   // avoid the book getting cluttered up with tiny amounts not worth the gas
166   uint constant cntrMinInitialSize = 10 finney;
167 
168   // see comments for baseMaxSize
169   uint constant cntrMaxSize = 10 ** 30;
170 
171   // the reward token that can be used to pay fees (UBI)
172 
173   ERC20 rwrdToken;
174 
175   // used to convert ETH amount to reward tokens when paying fee with reward tokens
176   uint constant ethRwrdRate = 1000;
177   
178   // funds that belong to clients (base, counter, and reward)
179 
180   mapping (address => uint) balanceBaseForClient;
181   mapping (address => uint) balanceCntrForClient;
182   mapping (address => uint) balanceRwrdForClient;
183 
184   // fee charged on liquidity taken, expressed as a divisor
185   // (e.g. 2000 means 1/2000, or 0.05%)
186 
187   uint constant feeDivisor = 2000;
188   
189   // fees charged are given to:
190   
191   address feeCollector;
192 
193   // all orders ever created
194   
195   mapping (uint128 => Order) orderForOrderId;
196   
197   // Effectively a compact mapping from price to whether there are any open orders at that price.
198   // See "Price Calculation Constants" below as to why 85.
199 
200   uint256[85] occupiedPriceBitmaps;
201 
202   // These allow us to walk over the orders in the book at a given price level (and add more).
203 
204   mapping (uint16 => OrderChain) orderChainForOccupiedPrice;
205   mapping (uint128 => OrderChainNode) orderChainNodeForOpenOrderId;
206 
207   // These allow a client to (reasonably) efficiently find their own orders
208   // without relying on events (which even indexed are a bit expensive to search
209   // and cannot be accessed from smart contracts). See walkOrders.
210 
211   mapping (address => uint128) mostRecentOrderIdForClient;
212   mapping (uint128 => uint128) clientPreviousOrderIdBeforeOrderId;
213 
214   // Price Calculation Constants.
215   //
216   // We pack direction and price into a crafty decimal floating point representation
217   // for efficient indexing by price, the main thing we lose by doing so is precision -
218   // we only have 3 significant figures in our prices.
219   //
220   // An unpacked price consists of:
221   //
222   //   direction - invalid / buy / sell
223   //   mantissa  - ranges from 100 to 999 representing 0.100 to 0.999
224   //   exponent  - ranges from minimumPriceExponent to minimumPriceExponent + 11
225   //               (e.g. -5 to +6 for a typical pair where minPriceExponent = -5)
226   //
227   // The packed representation has 21601 different price values:
228   //
229   //      0  = invalid (can be used as marker value)
230   //      1  = buy at maximum price (0.999 * 10 ** 6)
231   //    ...  = other buy prices in descending order
232   //   5401  = buy at 1.00
233   //    ...  = other buy prices in descending order
234   //  10800  = buy at minimum price (0.100 * 10 ** -5)
235   //  10801  = sell at minimum price (0.100 * 10 ** -5)
236   //    ...  = other sell prices in descending order
237   //  16201  = sell at 1.00
238   //    ...  = other sell prices in descending order
239   //  21600  = sell at maximum price (0.999 * 10 ** 6)
240   //  21601+ = do not use
241   //
242   // If we want to map each packed price to a boolean value (which we do),
243   // we require 85 256-bit words. Or 42.5 for each side of the book.
244   
245   int8 constant minPriceExponent = -5;
246 
247   uint constant invalidPrice = 0;
248 
249   // careful: max = largest unpacked value, not largest packed value
250   uint constant maxBuyPrice = 1; 
251   uint constant minBuyPrice = 10800;
252   uint constant minSellPrice = 10801;
253   uint constant maxSellPrice = 21600;
254 
255   // Constructor.
256   //
257   // Sets feeCollector to the creator. Creator needs to call init() to finish setup.
258   //
259   function BookERC20EthV1() {
260     address creator = msg.sender;
261     feeCollector = creator;
262   }
263 
264   // "Public" Management - set address of base and reward tokens.
265   //
266   // Can only be done once (normally immediately after creation) by the fee collector.
267   //
268   // Used instead of a constructor to make deployment easier.
269   //
270   function init(ERC20 _baseToken, ERC20 _rwrdToken) public {
271     require(msg.sender == feeCollector);
272     require(address(baseToken) == 0);
273     require(address(_baseToken) != 0);
274     require(address(rwrdToken) == 0);
275     require(address(_rwrdToken) != 0);
276     // attempt to catch bad tokens:
277     require(_baseToken.totalSupply() > 0);
278     baseToken = _baseToken;
279     require(_rwrdToken.totalSupply() > 0);
280     rwrdToken = _rwrdToken;
281   }
282 
283   // "Public" Management - change fee collector
284   //
285   // The new fee collector only gets fees charged after this point.
286   //
287   function changeFeeCollector(address newFeeCollector) public {
288     address oldFeeCollector = feeCollector;
289     require(msg.sender == oldFeeCollector);
290     require(newFeeCollector != oldFeeCollector);
291     feeCollector = newFeeCollector;
292   }
293   
294   // Public Info View - what is being traded here, what are the limits?
295   //
296   function getBookInfo() public constant returns (
297       BookType _bookType, address _baseToken, address _rwrdToken,
298       uint _baseMinInitialSize, uint _cntrMinInitialSize,
299       uint _feeDivisor, address _feeCollector
300     ) {
301     return (
302       BookType.ERC20EthV1,
303       address(baseToken),
304       address(rwrdToken),
305       baseMinInitialSize,
306       cntrMinInitialSize,
307       feeDivisor,
308       feeCollector
309     );
310   }
311 
312   // Public Funds View - get balances held by contract on behalf of the client,
313   // or balances approved for deposit but not yet claimed by the contract.
314   //
315   // Excludes funds in open orders.
316   //
317   // Helps a web ui get a consistent snapshot of balances.
318   //
319   // It would be nice to return the off-exchange ETH balance too but there's a
320   // bizarre bug in geth (and apparently as a result via MetaMask) that leads
321   // to unpredictable behaviour when looking up client balances in constant
322   // functions - see e.g. https://github.com/ethereum/solidity/issues/2325 .
323   //
324   function getClientBalances(address client) public constant returns (
325       uint bookBalanceBase,
326       uint bookBalanceCntr,
327       uint bookBalanceRwrd,
328       uint approvedBalanceBase,
329       uint approvedBalanceRwrd,
330       uint ownBalanceBase,
331       uint ownBalanceRwrd
332     ) {
333     bookBalanceBase = balanceBaseForClient[client];
334     bookBalanceCntr = balanceCntrForClient[client];
335     bookBalanceRwrd = balanceRwrdForClient[client];
336     approvedBalanceBase = baseToken.allowance(client, address(this));
337     approvedBalanceRwrd = rwrdToken.allowance(client, address(this));
338     ownBalanceBase = baseToken.balanceOf(client);
339     ownBalanceRwrd = rwrdToken.balanceOf(client);
340   }
341 
342   // Public Funds Manipulation - deposit previously-approved base tokens.
343   //
344   function transferFromBase() public {
345     address client = msg.sender;
346     address book = address(this);
347     // we trust the ERC20 token contract not to do nasty things like call back into us -
348     // if we cannot trust the token then why are we allowing it to be traded?
349     uint amountBase = baseToken.allowance(client, book);
350     require(amountBase > 0);
351     // NB: needs change for older ERC20 tokens that don't return bool
352     require(baseToken.transferFrom(client, book, amountBase));
353     // belt and braces
354     assert(baseToken.allowance(client, book) == 0);
355     balanceBaseForClient[client] += amountBase;
356     ClientPaymentEvent(client, ClientPaymentEventType.TransferFrom, BalanceType.Base, int(amountBase));
357   }
358 
359   // Public Funds Manipulation - withdraw base tokens (as a transfer).
360   //
361   function transferBase(uint amountBase) public {
362     address client = msg.sender;
363     require(amountBase > 0);
364     require(amountBase <= balanceBaseForClient[client]);
365     // overflow safe since we checked less than balance above
366     balanceBaseForClient[client] -= amountBase;
367     // we trust the ERC20 token contract not to do nasty things like call back into us -
368     // if we cannot trust the token then why are we allowing it to be traded?
369     // NB: needs change for older ERC20 tokens that don't return bool
370     require(baseToken.transfer(client, amountBase));
371     ClientPaymentEvent(client, ClientPaymentEventType.Transfer, BalanceType.Base, -int(amountBase));
372   }
373 
374   // Public Funds Manipulation - deposit counter currency (ETH).
375   //
376   function depositCntr() public payable {
377     address client = msg.sender;
378     uint amountCntr = msg.value;
379     require(amountCntr > 0);
380     // overflow safe - if someone owns pow(2,255) ETH we have bigger problems
381     balanceCntrForClient[client] += amountCntr;
382     ClientPaymentEvent(client, ClientPaymentEventType.Deposit, BalanceType.Cntr, int(amountCntr));
383   }
384 
385   // Public Funds Manipulation - withdraw counter currency (ETH).
386   //
387   function withdrawCntr(uint amountCntr) public {
388     address client = msg.sender;
389     require(amountCntr > 0);
390     require(amountCntr <= balanceCntrForClient[client]);
391     // overflow safe - checked less than balance above
392     balanceCntrForClient[client] -= amountCntr;
393     // safe - not enough gas to do anything interesting in fallback, already adjusted balance
394     client.transfer(amountCntr);
395     ClientPaymentEvent(client, ClientPaymentEventType.Withdraw, BalanceType.Cntr, -int(amountCntr));
396   }
397 
398   // Public Funds Manipulation - deposit previously-approved reward tokens.
399   //
400   function transferFromRwrd() public {
401     address client = msg.sender;
402     address book = address(this);
403     uint amountRwrd = rwrdToken.allowance(client, book);
404     require(amountRwrd > 0);
405     // we wrote the reward token so we know it supports ERC20 properly and is not evil
406     require(rwrdToken.transferFrom(client, book, amountRwrd));
407     // belt and braces
408     assert(rwrdToken.allowance(client, book) == 0);
409     balanceRwrdForClient[client] += amountRwrd;
410     ClientPaymentEvent(client, ClientPaymentEventType.TransferFrom, BalanceType.Rwrd, int(amountRwrd));
411   }
412 
413   // Public Funds Manipulation - withdraw base tokens (as a transfer).
414   //
415   function transferRwrd(uint amountRwrd) public {
416     address client = msg.sender;
417     require(amountRwrd > 0);
418     require(amountRwrd <= balanceRwrdForClient[client]);
419     // overflow safe - checked less than balance above
420     balanceRwrdForClient[client] -= amountRwrd;
421     // we wrote the reward token so we know it supports ERC20 properly and is not evil
422     require(rwrdToken.transfer(client, amountRwrd));
423     ClientPaymentEvent(client, ClientPaymentEventType.Transfer, BalanceType.Rwrd, -int(amountRwrd));
424   }
425 
426   // Public Order View - get full details of an order.
427   //
428   // If the orderId does not exist, status will be Unknown.
429   //
430   function getOrder(uint128 orderId) public constant returns (
431     address client, uint16 price, uint sizeBase, Terms terms,
432     Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
433     uint feesBaseOrCntr, uint feesRwrd) {
434     Order storage order = orderForOrderId[orderId];
435     return (order.client, order.price, order.sizeBase, order.terms,
436             order.status, order.reasonCode, order.executedBase, order.executedCntr,
437             order.feesBaseOrCntr, order.feesRwrd);
438   }
439 
440   // Public Order View - get mutable details of an order.
441   //
442   // If the orderId does not exist, status will be Unknown.
443   //
444   function getOrderState(uint128 orderId) public constant returns (
445     Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
446     uint feesBaseOrCntr, uint feesRwrd) {
447     Order storage order = orderForOrderId[orderId];
448     return (order.status, order.reasonCode, order.executedBase, order.executedCntr,
449             order.feesBaseOrCntr, order.feesRwrd);
450   }
451   
452   // Public Order View - enumerate all recent orders + all open orders for one client.
453   //
454   // Not really designed for use from a smart contract transaction.
455   //
456   // Idea is:
457   //  - client ensures order ids are generated so that most-signficant part is time-based;
458   //  - client decides they want all orders after a certain point-in-time,
459   //    and chooses minClosedOrderIdCutoff accordingly;
460   //  - before that point-in-time they just get open and needs gas orders
461   //  - client calls walkClientOrders with maybeLastOrderIdReturned = 0 initially;
462   //  - then repeats with the orderId returned by walkClientOrders;
463   //  - (and stops if it returns a zero orderId);
464   //
465   // Note that client is only used when maybeLastOrderIdReturned = 0.
466   //
467   function walkClientOrders(
468       address client, uint128 maybeLastOrderIdReturned, uint128 minClosedOrderIdCutoff
469     ) public constant returns (
470       uint128 orderId, uint16 price, uint sizeBase, Terms terms,
471       Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
472       uint feesBaseOrCntr, uint feesRwrd) {
473     if (maybeLastOrderIdReturned == 0) {
474       orderId = mostRecentOrderIdForClient[client];
475     } else {
476       orderId = clientPreviousOrderIdBeforeOrderId[maybeLastOrderIdReturned];
477     }
478     while (true) {
479       if (orderId == 0) return;
480       Order storage order = orderForOrderId[orderId];
481       if (orderId >= minClosedOrderIdCutoff) break;
482       if (order.status == Status.Open || order.status == Status.NeedsGas) break;
483       orderId = clientPreviousOrderIdBeforeOrderId[orderId];
484     }
485     return (orderId, order.price, order.sizeBase, order.terms,
486             order.status, order.reasonCode, order.executedBase, order.executedCntr,
487             order.feesBaseOrCntr, order.feesRwrd);
488   }
489  
490   // Internal Price Calculation - turn packed price into a friendlier unpacked price.
491   //
492   function unpackPrice(uint16 price) internal constant returns (
493       Direction direction, uint16 mantissa, int8 exponent
494     ) {
495     uint sidedPriceIndex = uint(price);
496     uint priceIndex;
497     if (sidedPriceIndex < 1 || sidedPriceIndex > maxSellPrice) {
498       direction = Direction.Invalid;
499       mantissa = 0;
500       exponent = 0;
501       return;
502     } else if (sidedPriceIndex <= minBuyPrice) {
503       direction = Direction.Buy;
504       priceIndex = minBuyPrice - sidedPriceIndex;
505     } else {
506       direction = Direction.Sell;
507       priceIndex = sidedPriceIndex - minSellPrice;
508     }
509     uint zeroBasedMantissa = priceIndex % 900;
510     uint zeroBasedExponent = priceIndex / 900;
511     mantissa = uint16(zeroBasedMantissa + 100);
512     exponent = int8(zeroBasedExponent) + minPriceExponent;
513     return;
514   }
515   
516   // Internal Price Calculation - is a packed price on the buy side?
517   //
518   // Throws an error if price is invalid.
519   //
520   function isBuyPrice(uint16 price) internal constant returns (bool isBuy) {
521     // yes, this looks odd, but max here is highest _unpacked_ price
522     return price >= maxBuyPrice && price <= minBuyPrice;
523   }
524   
525   // Internal Price Calculation - turn a packed buy price into a packed sell price.
526   //
527   // Invalid price remains invalid.
528   //
529   function computeOppositePrice(uint16 price) internal constant returns (uint16 opposite) {
530     if (price < maxBuyPrice || price > maxSellPrice) {
531       return uint16(invalidPrice);
532     } else if (price <= minBuyPrice) {
533       return uint16(maxSellPrice - (price - maxBuyPrice));
534     } else {
535       return uint16(maxBuyPrice + (maxSellPrice - price));
536     }
537   }
538   
539   // Internal Price Calculation - compute amount in counter currency that would
540   // be obtained by selling baseAmount at the given unpacked price (if no fees).
541   //
542   // Notes:
543   //  - Does not validate price - caller must ensure valid.
544   //  - Could overflow producing very unexpected results if baseAmount very
545   //    large - caller must check this.
546   //  - This rounds the amount towards zero.
547   //  - May truncate to zero if baseAmount very small - potentially allowing
548   //    zero-cost buys or pointless sales - caller must check this.
549   //
550   function computeCntrAmountUsingUnpacked(
551       uint baseAmount, uint16 mantissa, int8 exponent
552     ) internal constant returns (uint cntrAmount) {
553     if (exponent < 0) {
554       return baseAmount * uint(mantissa) / 1000 / 10 ** uint(-exponent);
555     } else {
556       return baseAmount * uint(mantissa) / 1000 * 10 ** uint(exponent);
557     }
558   }
559 
560   // Internal Price Calculation - compute amount in counter currency that would
561   // be obtained by selling baseAmount at the given packed price (if no fees).
562   //
563   // Notes:
564   //  - Does not validate price - caller must ensure valid.
565   //  - Direction of the packed price is ignored.
566   //  - Could overflow producing very unexpected results if baseAmount very
567   //    large - caller must check this.
568   //  - This rounds the amount towards zero (regardless of Buy or Sell).
569   //  - May truncate to zero if baseAmount very small - potentially allowing
570   //    zero-cost buys or pointless sales - caller must check this.
571   //
572   function computeCntrAmountUsingPacked(
573       uint baseAmount, uint16 price
574     ) internal constant returns (uint) {
575     var (, mantissa, exponent) = unpackPrice(price);
576     return computeCntrAmountUsingUnpacked(baseAmount, mantissa, exponent);
577   }
578 
579   // Public Order Placement - create order and try to match it and/or add it to the book.
580   //
581   function createOrder(
582       uint128 orderId, uint16 price, uint sizeBase, Terms terms, uint maxMatches
583     ) public {
584     address client = msg.sender;
585     require(client != 0 && orderId != 0 && orderForOrderId[orderId].client == 0);
586     ClientOrderEvent(client, ClientOrderEventType.Create, orderId);
587     orderForOrderId[orderId] =
588       Order(client, price, sizeBase, terms, Status.Unknown, ReasonCode.None, 0, 0, 0, 0);
589     uint128 previousMostRecentOrderIdForClient = mostRecentOrderIdForClient[client];
590     mostRecentOrderIdForClient[client] = orderId;
591     clientPreviousOrderIdBeforeOrderId[orderId] = previousMostRecentOrderIdForClient;
592     Order storage order = orderForOrderId[orderId];
593     var (direction, mantissa, exponent) = unpackPrice(price);
594     if (direction == Direction.Invalid) {
595       order.status = Status.Rejected;
596       order.reasonCode = ReasonCode.InvalidPrice;
597       return;
598     }
599     if (sizeBase < baseMinInitialSize || sizeBase > baseMaxSize) {
600       order.status = Status.Rejected;
601       order.reasonCode = ReasonCode.InvalidSize;
602       return;
603     }
604     uint sizeCntr = computeCntrAmountUsingUnpacked(sizeBase, mantissa, exponent);
605     if (sizeCntr < cntrMinInitialSize || sizeCntr > cntrMaxSize) {
606       order.status = Status.Rejected;
607       order.reasonCode = ReasonCode.InvalidSize;
608       return;
609     }
610     if (terms == Terms.MakerOnly && maxMatches != 0) {
611       order.status = Status.Rejected;
612       order.reasonCode = ReasonCode.InvalidTerms;
613       return;
614     }
615     if (!debitFunds(client, direction, sizeBase, sizeCntr)) {
616       order.status = Status.Rejected;
617       order.reasonCode = ReasonCode.InsufficientFunds;
618       return;
619     }
620     processOrder(orderId, maxMatches);
621   }
622 
623   // Public Order Placement - cancel order
624   //
625   function cancelOrder(uint128 orderId) public {
626     address client = msg.sender;
627     Order storage order = orderForOrderId[orderId];
628     require(order.client == client);
629     Status status = order.status;
630     if (status != Status.Open && status != Status.NeedsGas) {
631       return;
632     }
633     if (status == Status.Open) {
634       removeOpenOrderFromBook(orderId);
635       MarketOrderEvent(block.timestamp, orderId, MarketOrderEventType.Remove, order.price,
636         order.sizeBase - order.executedBase, 0);
637     }
638     refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.ClientCancel);
639   }
640 
641   // Public Order Placement - continue placing an order in 'NeedsGas' state
642   //
643   function continueOrder(uint128 orderId, uint maxMatches) public {
644     address client = msg.sender;
645     Order storage order = orderForOrderId[orderId];
646     require(order.client == client);
647     if (order.status != Status.NeedsGas) {
648       return;
649     }
650     order.status = Status.Unknown;
651     processOrder(orderId, maxMatches);
652   }
653 
654   // Internal Order Placement - remove a still-open order from the book.
655   //
656   // Caller's job to update/refund the order + raise event, this just
657   // updates the order chain and bitmask.
658   //
659   // Too expensive to do on each resting order match - we only do this for an
660   // order being cancelled. See matchWithOccupiedPrice for similar logic.
661   //
662   function removeOpenOrderFromBook(uint128 orderId) internal {
663     Order storage order = orderForOrderId[orderId];
664     uint16 price = order.price;
665     OrderChain storage orderChain = orderChainForOccupiedPrice[price];
666     OrderChainNode storage orderChainNode = orderChainNodeForOpenOrderId[orderId];
667     uint128 nextOrderId = orderChainNode.nextOrderId;
668     uint128 prevOrderId = orderChainNode.prevOrderId;
669     if (nextOrderId != 0) {
670       OrderChainNode storage nextOrderChainNode = orderChainNodeForOpenOrderId[nextOrderId];
671       nextOrderChainNode.prevOrderId = prevOrderId;
672     } else {
673       orderChain.lastOrderId = prevOrderId;
674     }
675     if (prevOrderId != 0) {
676       OrderChainNode storage prevOrderChainNode = orderChainNodeForOpenOrderId[prevOrderId];
677       prevOrderChainNode.nextOrderId = nextOrderId;
678     } else {
679       orderChain.firstOrderId = nextOrderId;
680     }
681     if (nextOrderId == 0 && prevOrderId == 0) {
682       uint bmi = price / 256;  // index into array of bitmaps
683       uint bti = price % 256;  // bit position within bitmap
684       // we know was previously occupied so XOR clears
685       occupiedPriceBitmaps[bmi] ^= 2 ** bti;
686     }
687   }
688 
689   // Internal Order Placement - credit funds received when taking liquidity from book
690   //
691   function creditExecutedFundsLessFees(uint128 orderId, uint originalExecutedBase, uint originalExecutedCntr) internal {
692     Order storage order = orderForOrderId[orderId];
693     uint liquidityTakenBase = order.executedBase - originalExecutedBase;
694     uint liquidityTakenCntr = order.executedCntr - originalExecutedCntr;
695     // Normally we deduct the fee from the currency bought (base for buy, cntr for sell),
696     // however we also accept reward tokens from the reward balance if it covers the fee,
697     // with the reward amount converted from the ETH amount (the counter currency here)
698     // at a fixed exchange rate.
699     // Overflow safe since we ensure order size < 10^30 in both currencies (see baseMaxSize).
700     // Can truncate to zero, which is fine.
701     uint feesRwrd = liquidityTakenCntr / feeDivisor * ethRwrdRate;
702     uint feesBaseOrCntr;
703     address client = order.client;
704     uint availRwrd = balanceRwrdForClient[client];
705     if (feesRwrd <= availRwrd) {
706       balanceRwrdForClient[client] = availRwrd - feesRwrd;
707       balanceRwrdForClient[feeCollector] = feesRwrd;
708       // Need += rather than = because could have paid some fees earlier in NeedsGas situation.
709       // Overflow safe since we ensure order size < 10^30 in both currencies (see baseMaxSize).
710       // Can truncate to zero, which is fine.
711       order.feesRwrd += uint128(feesRwrd);
712       if (isBuyPrice(order.price)) {
713         balanceBaseForClient[client] += liquidityTakenBase;
714       } else {
715         balanceCntrForClient[client] += liquidityTakenCntr;
716       }
717     } else if (isBuyPrice(order.price)) {
718       // See comments in branch above re: use of += and overflow safety.
719       feesBaseOrCntr = liquidityTakenBase / feeDivisor;
720       balanceBaseForClient[order.client] += (liquidityTakenBase - feesBaseOrCntr);
721       order.feesBaseOrCntr += uint128(feesBaseOrCntr);
722       balanceBaseForClient[feeCollector] += feesBaseOrCntr;
723     } else {
724       // See comments in branch above re: use of += and overflow safety.
725       feesBaseOrCntr = liquidityTakenCntr / feeDivisor;
726       balanceCntrForClient[order.client] += (liquidityTakenCntr - feesBaseOrCntr);
727       order.feesBaseOrCntr += uint128(feesBaseOrCntr);
728       balanceCntrForClient[feeCollector] += feesBaseOrCntr;
729     }
730   }
731 
732   // Internal Order Placement - process a created and sanity checked order.
733   //
734   // Used both for new orders and for gas topup.
735   //
736   function processOrder(uint128 orderId, uint maxMatches) internal {
737     Order storage order = orderForOrderId[orderId];
738 
739     uint ourOriginalExecutedBase = order.executedBase;
740     uint ourOriginalExecutedCntr = order.executedCntr;
741 
742     var (ourDirection,) = unpackPrice(order.price);
743     uint theirPriceStart = (ourDirection == Direction.Buy) ? minSellPrice : maxBuyPrice;
744     uint theirPriceEnd = computeOppositePrice(order.price);
745    
746     MatchStopReason matchStopReason =
747       matchAgainstBook(orderId, theirPriceStart, theirPriceEnd, maxMatches);
748 
749     creditExecutedFundsLessFees(orderId, ourOriginalExecutedBase, ourOriginalExecutedCntr);
750 
751     if (order.terms == Terms.ImmediateOrCancel) {
752       if (matchStopReason == MatchStopReason.Satisfied) {
753         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
754         return;
755       } else if (matchStopReason == MatchStopReason.MaxMatches) {
756         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.TooManyMatches);
757         return;
758       } else if (matchStopReason == MatchStopReason.BookExhausted) {
759         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.Unmatched);
760         return;
761       }
762     } else if (order.terms == Terms.MakerOnly) {
763       if (matchStopReason == MatchStopReason.MaxMatches) {
764         refundUnmatchedAndFinish(orderId, Status.Rejected, ReasonCode.WouldTake);
765         return;
766       } else if (matchStopReason == MatchStopReason.BookExhausted) {
767         enterOrder(orderId);
768         return;
769       }
770     } else if (order.terms == Terms.GTCNoGasTopup) {
771       if (matchStopReason == MatchStopReason.Satisfied) {
772         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
773         return;
774       } else if (matchStopReason == MatchStopReason.MaxMatches) {
775         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.TooManyMatches);
776         return;
777       } else if (matchStopReason == MatchStopReason.BookExhausted) {
778         enterOrder(orderId);
779         return;
780       }
781     } else if (order.terms == Terms.GTCWithGasTopup) {
782       if (matchStopReason == MatchStopReason.Satisfied) {
783         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
784         return;
785       } else if (matchStopReason == MatchStopReason.MaxMatches) {
786         order.status = Status.NeedsGas;
787         return;
788       } else if (matchStopReason == MatchStopReason.BookExhausted) {
789         enterOrder(orderId);
790         return;
791       }
792     }
793     assert(false); // should not be possible to reach here
794   }
795  
796   // Used internally to indicate why we stopped matching an order against the book.
797 
798   enum MatchStopReason {
799     None,
800     MaxMatches,
801     Satisfied,
802     PriceExhausted,
803     BookExhausted
804   }
805  
806   // Internal Order Placement - Match the given order against the book.
807   //
808   // Resting orders matched will be updated, removed from book and funds credited to their owners.
809   //
810   // Only updates the executedBase and executedCntr of the given order - caller is responsible
811   // for crediting matched funds, charging fees, marking order as done / entering it into the book.
812   //
813   // matchStopReason returned will be one of MaxMatches, Satisfied or BookExhausted.
814   //
815   function matchAgainstBook(
816       uint128 orderId, uint theirPriceStart, uint theirPriceEnd, uint maxMatches
817     ) internal returns (
818       MatchStopReason matchStopReason
819     ) {
820     Order storage order = orderForOrderId[orderId];
821     
822     uint bmi = theirPriceStart / 256;  // index into array of bitmaps
823     uint bti = theirPriceStart % 256;  // bit position within bitmap
824     uint bmiEnd = theirPriceEnd / 256; // last bitmap to search
825     uint btiEnd = theirPriceEnd % 256; // stop at this bit in the last bitmap
826 
827     uint cbm = occupiedPriceBitmaps[bmi]; // original copy of current bitmap
828     uint dbm = cbm; // dirty version of current bitmap where we may have cleared bits
829     uint wbm = cbm >> bti; // working copy of current bitmap which we keep shifting
830     
831     // these loops are pretty ugly, and somewhat unpredicatable in terms of gas,
832     // ... but no-one else has come up with a better matching engine yet!
833 
834     bool removedLastAtPrice;
835     matchStopReason = MatchStopReason.None;
836 
837     while (bmi < bmiEnd) {
838       if (wbm == 0 || bti == 256) {
839         if (dbm != cbm) {
840           occupiedPriceBitmaps[bmi] = dbm;
841         }
842         bti = 0;
843         bmi++;
844         cbm = occupiedPriceBitmaps[bmi];
845         wbm = cbm;
846         dbm = cbm;
847       } else {
848         if ((wbm & 1) != 0) {
849           // careful - copy-and-pasted in loop below ...
850           (removedLastAtPrice, maxMatches, matchStopReason) =
851             matchWithOccupiedPrice(order, uint16(bmi * 256 + bti), maxMatches);
852           if (removedLastAtPrice) {
853             dbm ^= 2 ** bti;
854           }
855           if (matchStopReason == MatchStopReason.PriceExhausted) {
856             matchStopReason = MatchStopReason.None;
857           } else if (matchStopReason != MatchStopReason.None) {
858             break;
859           }
860         }
861         bti += 1;
862         wbm /= 2;
863       }
864     }
865     if (matchStopReason == MatchStopReason.None) {
866       // we've reached the last bitmap we need to search,
867       // we'll stop at btiEnd not 256 this time.
868       while (bti <= btiEnd && wbm != 0) {
869         if ((wbm & 1) != 0) {
870           // careful - copy-and-pasted in loop above ...
871           (removedLastAtPrice, maxMatches, matchStopReason) =
872             matchWithOccupiedPrice(order, uint16(bmi * 256 + bti), maxMatches);
873           if (removedLastAtPrice) {
874             dbm ^= 2 ** bti;
875           }
876           if (matchStopReason == MatchStopReason.PriceExhausted) {
877             matchStopReason = MatchStopReason.None;
878           } else if (matchStopReason != MatchStopReason.None) {
879             break;
880           }
881         }
882         bti += 1;
883         wbm /= 2;
884       }
885     }
886     // Careful - if we exited the first loop early, or we went into the second loop,
887     // (luckily can't both happen) then we haven't flushed the dirty bitmap back to
888     // storage - do that now if we need to.
889     if (dbm != cbm) {
890       occupiedPriceBitmaps[bmi] = dbm;
891     }
892     if (matchStopReason == MatchStopReason.None) {
893       matchStopReason = MatchStopReason.BookExhausted;
894     }
895   }
896 
897   // Internal Order Placement.
898   //
899   // Match our order against up to maxMatches resting orders at the given price (which
900   // is known by the caller to have at least one resting order).
901   //
902   // The matches (partial or complete) of the resting orders are recorded, and their
903   // funds are credited.
904   //
905   // The order chain for the resting orders is updated, but the occupied price bitmap is NOT -
906   // the caller must clear the relevant bit if removedLastAtPrice = true is returned.
907   //
908   // Only updates the executedBase and executedCntr of our order - caller is responsible
909   // for e.g. crediting our matched funds, updating status.
910   //
911   // Calling with maxMatches == 0 is ok - and expected when the order is a maker-only order.
912   //
913   // Returns:
914   //   removedLastAtPrice:
915   //     true iff there are no longer any resting orders at this price - caller will need
916   //     to update the occupied price bitmap.
917   //
918   //   matchesLeft:
919   //     maxMatches passed in minus the number of matches made by this call
920   //
921   //   matchStopReason:
922   //     If our order is completely matched, matchStopReason will be Satisfied.
923   //     If our order is not completely matched, matchStopReason will be either:
924   //        MaxMatches (we are not allowed to match any more times)
925   //     or:
926   //        PriceExhausted (nothing left on the book at this exact price)
927   //
928   function matchWithOccupiedPrice(
929       Order storage ourOrder, uint16 theirPrice, uint maxMatches
930     ) internal returns (
931     bool removedLastAtPrice, uint matchesLeft, MatchStopReason matchStopReason) {
932     matchesLeft = maxMatches;
933     uint workingOurExecutedBase = ourOrder.executedBase;
934     uint workingOurExecutedCntr = ourOrder.executedCntr;
935     uint128 theirOrderId = orderChainForOccupiedPrice[theirPrice].firstOrderId;
936     matchStopReason = MatchStopReason.None;
937     while (true) {
938       if (matchesLeft == 0) {
939         matchStopReason = MatchStopReason.MaxMatches;
940         break;
941       }
942       uint matchBase;
943       uint matchCntr;
944       (theirOrderId, matchBase, matchCntr, matchStopReason) =
945         matchWithTheirs((ourOrder.sizeBase - workingOurExecutedBase), theirOrderId, theirPrice);
946       workingOurExecutedBase += matchBase;
947       workingOurExecutedCntr += matchCntr;
948       matchesLeft -= 1;
949       if (matchStopReason != MatchStopReason.None) {
950         break;
951       }
952     }
953     ourOrder.executedBase = uint128(workingOurExecutedBase);
954     ourOrder.executedCntr = uint128(workingOurExecutedCntr);
955     if (theirOrderId == 0) {
956       orderChainForOccupiedPrice[theirPrice].firstOrderId = 0;
957       orderChainForOccupiedPrice[theirPrice].lastOrderId = 0;
958       removedLastAtPrice = true;
959     } else {
960       // NB: in some cases (e.g. maxMatches == 0) this is a no-op.
961       orderChainForOccupiedPrice[theirPrice].firstOrderId = theirOrderId;
962       orderChainNodeForOpenOrderId[theirOrderId].prevOrderId = 0;
963       removedLastAtPrice = false;
964     }
965   }
966   
967   // Internal Order Placement.
968   //
969   // Match up to our remaining amount against a resting order in the book.
970   //
971   // The match (partial, complete or effectively-complete) of the resting order
972   // is recorded, and their funds are credited.
973   //
974   // Their order is NOT removed from the book by this call - the caller must do that
975   // if the nextTheirOrderId returned is not equal to the theirOrderId passed in.
976   //
977   // Returns:
978   //
979   //   nextTheirOrderId:
980   //     If we did not completely match their order, will be same as theirOrderId.
981   //     If we completely matched their order, will be orderId of next order at the
982   //     same price - or zero if this was the last order and we've now filled it.
983   //
984   //   matchStopReason:
985   //     If our order is completely matched, matchStopReason will be Satisfied.
986   //     If our order is not completely matched, matchStopReason will be either
987   //     PriceExhausted (if nothing left at this exact price) or None (if can continue).
988   // 
989   function matchWithTheirs(
990     uint ourRemainingBase, uint128 theirOrderId, uint16 theirPrice) internal returns (
991     uint128 nextTheirOrderId, uint matchBase, uint matchCntr, MatchStopReason matchStopReason) {
992     Order storage theirOrder = orderForOrderId[theirOrderId];
993     uint theirRemainingBase = theirOrder.sizeBase - theirOrder.executedBase;
994     if (ourRemainingBase < theirRemainingBase) {
995       matchBase = ourRemainingBase;
996     } else {
997       matchBase = theirRemainingBase;
998     }
999     matchCntr = computeCntrAmountUsingPacked(matchBase, theirPrice);
1000     // It may seem a bit odd to stop here if our remaining amount is very small -
1001     // there could still be resting orders we can match it against. But the gas
1002     // cost of matching each order is quite high - potentially high enough to
1003     // wipe out the profit the taker hopes for from trading the tiny amount left.
1004     if ((ourRemainingBase - matchBase) < baseMinRemainingSize) {
1005       matchStopReason = MatchStopReason.Satisfied;
1006     } else {
1007       matchStopReason = MatchStopReason.None;
1008     }
1009     bool theirsDead = recordTheirMatch(theirOrder, theirOrderId, theirPrice, matchBase, matchCntr);
1010     if (theirsDead) {
1011       nextTheirOrderId = orderChainNodeForOpenOrderId[theirOrderId].nextOrderId;
1012       if (matchStopReason == MatchStopReason.None && nextTheirOrderId == 0) {
1013         matchStopReason = MatchStopReason.PriceExhausted;
1014       }
1015     } else {
1016       nextTheirOrderId = theirOrderId;
1017     }
1018   }
1019 
1020   // Internal Order Placement.
1021   //
1022   // Record match (partial or complete) of resting order, and credit them their funds.
1023   //
1024   // If their order is completely matched, the order is marked as done,
1025   // and "theirsDead" is returned as true.
1026   //
1027   // The order is NOT removed from the book by this call - the caller
1028   // must do that if theirsDead is true.
1029   //
1030   // No sanity checks are made - the caller must be sure the order is
1031   // not already done and has sufficient remaining. (Yes, we'd like to
1032   // check here too but we cannot afford the gas).
1033   //
1034   function recordTheirMatch(
1035       Order storage theirOrder, uint128 theirOrderId, uint16 theirPrice, uint matchBase, uint matchCntr
1036     ) internal returns (bool theirsDead) {
1037     // they are a maker so no fees
1038     // overflow safe - see comments about baseMaxSize
1039     // executedBase cannot go > sizeBase due to logic in matchWithTheirs
1040     theirOrder.executedBase += uint128(matchBase);
1041     theirOrder.executedCntr += uint128(matchCntr);
1042     if (isBuyPrice(theirPrice)) {
1043       // they have bought base (using the counter they already paid when creating the order)
1044       balanceBaseForClient[theirOrder.client] += matchBase;
1045     } else {
1046       // they have bought counter (using the base they already paid when creating the order)
1047       balanceCntrForClient[theirOrder.client] += matchCntr;
1048     }
1049     uint stillRemainingBase = theirOrder.sizeBase - theirOrder.executedBase;
1050     // avoid leaving tiny amounts in the book - refund remaining if too small
1051     if (stillRemainingBase < baseMinRemainingSize) {
1052       refundUnmatchedAndFinish(theirOrderId, Status.Done, ReasonCode.None);
1053       // someone building an UI on top needs to know how much was match and how much was refund
1054       MarketOrderEvent(block.timestamp, theirOrderId, MarketOrderEventType.CompleteFill,
1055         theirPrice, matchBase + stillRemainingBase, matchBase);
1056       return true;
1057     } else {
1058       MarketOrderEvent(block.timestamp, theirOrderId, MarketOrderEventType.PartialFill,
1059         theirPrice, matchBase, matchBase);
1060       return false;
1061     }
1062   }
1063 
1064   // Internal Order Placement.
1065   //
1066   // Refund any unmatched funds in an order (based on executed vs size) and move to a final state.
1067   //
1068   // The order is NOT removed from the book by this call and no event is raised.
1069   //
1070   // No sanity checks are made - the caller must be sure the order has not already been refunded.
1071   //
1072   function refundUnmatchedAndFinish(uint128 orderId, Status status, ReasonCode reasonCode) internal {
1073     Order storage order = orderForOrderId[orderId];
1074     uint16 price = order.price;
1075     if (isBuyPrice(price)) {
1076       uint sizeCntr = computeCntrAmountUsingPacked(order.sizeBase, price);
1077       balanceCntrForClient[order.client] += sizeCntr - order.executedCntr;
1078     } else {
1079       balanceBaseForClient[order.client] += order.sizeBase - order.executedBase;
1080     }
1081     order.status = status;
1082     order.reasonCode = reasonCode;
1083   }
1084 
1085   // Internal Order Placement.
1086   //
1087   // Enter a not completely matched order into the book, marking the order as open.
1088   //
1089   // This updates the occupied price bitmap and chain.
1090   //
1091   // No sanity checks are made - the caller must be sure the order
1092   // has some unmatched amount and has been paid for!
1093   //
1094   function enterOrder(uint128 orderId) internal {
1095     Order storage order = orderForOrderId[orderId];
1096     uint16 price = order.price;
1097     OrderChain storage orderChain = orderChainForOccupiedPrice[price];
1098     OrderChainNode storage orderChainNode = orderChainNodeForOpenOrderId[orderId];
1099     if (orderChain.firstOrderId == 0) {
1100       orderChain.firstOrderId = orderId;
1101       orderChain.lastOrderId = orderId;
1102       orderChainNode.nextOrderId = 0;
1103       orderChainNode.prevOrderId = 0;
1104       uint bitmapIndex = price / 256;
1105       uint bitIndex = price % 256;
1106       occupiedPriceBitmaps[bitmapIndex] |= (2 ** bitIndex);
1107     } else {
1108       uint128 existingLastOrderId = orderChain.lastOrderId;
1109       OrderChainNode storage existingLastOrderChainNode = orderChainNodeForOpenOrderId[existingLastOrderId];
1110       orderChainNode.nextOrderId = 0;
1111       orderChainNode.prevOrderId = existingLastOrderId;
1112       existingLastOrderChainNode.nextOrderId = orderId;
1113       orderChain.lastOrderId = orderId;
1114     }
1115     MarketOrderEvent(block.timestamp, orderId, MarketOrderEventType.Add,
1116       price, order.sizeBase - order.executedBase, 0);
1117     order.status = Status.Open;
1118   }
1119 
1120   // Internal Order Placement.
1121   //
1122   // Charge the client for the cost of placing an order in the given direction.
1123   //
1124   // Return true if successful, false otherwise.
1125   //
1126   function debitFunds(
1127       address client, Direction direction, uint sizeBase, uint sizeCntr
1128     ) internal returns (bool success) {
1129     if (direction == Direction.Buy) {
1130       uint availableCntr = balanceCntrForClient[client];
1131       if (availableCntr < sizeCntr) {
1132         return false;
1133       }
1134       balanceCntrForClient[client] = availableCntr - sizeCntr;
1135       return true;
1136     } else if (direction == Direction.Sell) {
1137       uint availableBase = balanceBaseForClient[client];
1138       if (availableBase < sizeBase) {
1139         return false;
1140       }
1141       balanceBaseForClient[client] = availableBase - sizeBase;
1142       return true;
1143     } else {
1144       return false;
1145     }
1146   }
1147 
1148   // Public Book View
1149   // 
1150   // Intended for public book depth enumeration from web3 (or similar).
1151   //
1152   // Not suitable for use from a smart contract transaction - gas usage
1153   // could be very high if we have many orders at the same price.
1154   //
1155   // Start at the given inclusive price (and side) and walk down the book
1156   // (getting less aggressive) until we find some open orders or reach the
1157   // least aggressive price.
1158   //
1159   // Returns the price where we found the order(s), the depth at that price
1160   // (zero if none found), order count there, and the current blockNumber.
1161   //
1162   // (The blockNumber is handy if you're taking a snapshot which you intend
1163   //  to keep up-to-date with the market order events).
1164   //
1165   // To walk the book, the caller should start by calling walkBook with the
1166   // most aggressive buy price (Buy @ 999000).
1167   // If the price returned is the least aggressive buy price (Buy @ 0.000001),
1168   // the side is complete.
1169   // Otherwise, call walkBook again with the (packed) price returned + 1.
1170   // Then repeat for the sell side, starting with Sell @ 0.000001 and stopping
1171   // when Sell @ 999000 is returned.
1172   //
1173   function walkBook(uint16 fromPrice) public constant returns (
1174       uint16 price, uint depthBase, uint orderCount, uint blockNumber
1175     ) {
1176     uint priceStart = fromPrice;
1177     uint priceEnd = (isBuyPrice(fromPrice)) ? minBuyPrice : maxSellPrice;
1178     
1179     // See comments in matchAgainstBook re: how these crazy loops work.
1180     
1181     uint bmi = priceStart / 256;
1182     uint bti = priceStart % 256;
1183     uint bmiEnd = priceEnd / 256;
1184     uint btiEnd = priceEnd % 256;
1185 
1186     uint wbm = occupiedPriceBitmaps[bmi] >> bti;
1187     
1188     while (bmi < bmiEnd) {
1189       if (wbm == 0 || bti == 256) {
1190         bti = 0;
1191         bmi++;
1192         wbm = occupiedPriceBitmaps[bmi];
1193       } else {
1194         if ((wbm & 1) != 0) {
1195           // careful - copy-pasted in below loop
1196           price = uint16(bmi * 256 + bti);
1197           (depthBase, orderCount) = sumDepth(orderChainForOccupiedPrice[price].firstOrderId);
1198           return (price, depthBase, orderCount, block.number);
1199         }
1200         bti += 1;
1201         wbm /= 2;
1202       }
1203     }
1204     // we've reached the last bitmap we need to search, stop at btiEnd not 256 this time.
1205     while (bti <= btiEnd && wbm != 0) {
1206       if ((wbm & 1) != 0) {
1207         // careful - copy-pasted in above loop
1208         price = uint16(bmi * 256 + bti);
1209         (depthBase, orderCount) = sumDepth(orderChainForOccupiedPrice[price].firstOrderId);
1210         return (price, depthBase, orderCount, block.number);
1211       }
1212       bti += 1;
1213       wbm /= 2;
1214     }
1215     return (uint16(priceEnd), 0, 0, block.number);
1216   }
1217 
1218   // Internal Book View.
1219   //
1220   // See walkBook - adds up open depth at a price starting from an
1221   // order which is assumed to be open. Careful - unlimited gas use.
1222   //
1223   function sumDepth(uint128 orderId) internal constant returns (uint depth, uint orderCount) {
1224     while (true) {
1225       Order storage order = orderForOrderId[orderId];
1226       depth += order.sizeBase - order.executedBase;
1227       orderCount++;
1228       orderId = orderChainNodeForOpenOrderId[orderId].nextOrderId;
1229       if (orderId == 0) {
1230         return (depth, orderCount);
1231       }
1232     }
1233   }
1234 }