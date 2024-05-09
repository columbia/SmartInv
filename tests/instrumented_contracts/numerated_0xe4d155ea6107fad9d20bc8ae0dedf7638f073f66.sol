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
18 // Version 1.1.0.
19 // This contract allows minPriceExponent, baseMinInitialSize, and baseMinRemainingSize
20 // to be set at init() time appropriately for the token decimals and likely value.
21 //
22 contract BookERC20EthV1p1 {
23 
24   enum BookType {
25     ERC20EthV1
26   }
27 
28   enum Direction {
29     Invalid,
30     Buy,
31     Sell
32   }
33 
34   enum Status {
35     Unknown,
36     Rejected,
37     Open,
38     Done,
39     NeedsGas,
40     Sending, // not used by contract - web only
41     FailedSend, // not used by contract - web only
42     FailedTxn // not used by contract - web only
43   }
44 
45   enum ReasonCode {
46     None,
47     InvalidPrice,
48     InvalidSize,
49     InvalidTerms,
50     InsufficientFunds,
51     WouldTake,
52     Unmatched,
53     TooManyMatches,
54     ClientCancel
55   }
56 
57   enum Terms {
58     GTCNoGasTopup,
59     GTCWithGasTopup,
60     ImmediateOrCancel,
61     MakerOnly
62   }
63 
64   struct Order {
65     // these are immutable once placed:
66 
67     address client;
68     uint16 price;              // packed representation of side + price
69     uint sizeBase;
70     Terms terms;
71 
72     // these are mutable until Done or Rejected:
73     
74     Status status;
75     ReasonCode reasonCode;
76     uint128 executedBase;      // gross amount executed in base currency (before fee deduction)
77     uint128 executedCntr;      // gross amount executed in counter currency (before fee deduction)
78     uint128 feesBaseOrCntr;    // base for buy, cntr for sell
79     uint128 feesRwrd;
80   }
81   
82   struct OrderChain {
83     uint128 firstOrderId;
84     uint128 lastOrderId;
85   }
86 
87   struct OrderChainNode {
88     uint128 nextOrderId;
89     uint128 prevOrderId;
90   }
91   
92   // It should be possible to reconstruct the expected state of the contract given:
93   //  - ClientPaymentEvent log history
94   //  - ClientOrderEvent log history
95   //  - Calling getOrder for the other immutable order fields of orders referenced by ClientOrderEvent
96   
97   enum ClientPaymentEventType {
98     Deposit,
99     Withdraw,
100     TransferFrom,
101     Transfer
102   }
103 
104   enum BalanceType {
105     Base,
106     Cntr,
107     Rwrd
108   }
109 
110   event ClientPaymentEvent(
111     address indexed client,
112     ClientPaymentEventType clientPaymentEventType,
113     BalanceType balanceType,
114     int clientBalanceDelta
115   );
116 
117   enum ClientOrderEventType {
118     Create,
119     Continue,
120     Cancel
121   }
122 
123   event ClientOrderEvent(
124     address indexed client,
125     ClientOrderEventType clientOrderEventType,
126     uint128 orderId,
127     uint maxMatches
128   );
129 
130   enum MarketOrderEventType {
131     // orderCount++, depth += depthBase
132     Add,
133     // orderCount--, depth -= depthBase
134     Remove,
135     // orderCount--, depth -= depthBase, traded += tradeBase
136     // (depth change and traded change differ when tiny remaining amount refunded)
137     CompleteFill,
138     // orderCount unchanged, depth -= depthBase, traded += tradeBase
139     PartialFill
140   }
141 
142   // Technically not needed but these events can be used to maintain an order book or
143   // watch for fills. Note that the orderId and price are those of the maker.
144 
145   event MarketOrderEvent(
146     uint256 indexed eventTimestamp,
147     uint128 indexed orderId,
148     MarketOrderEventType marketOrderEventType,
149     uint16 price,
150     uint depthBase,
151     uint tradeBase
152   );
153 
154   // the base token (e.g. TEST)
155   
156   ERC20 baseToken;
157 
158   // minimum order size (inclusive)
159   uint baseMinInitialSize; // set at init
160 
161   // if following partial match, the remaning gets smaller than this, remove from book and refund:
162   // generally we make this 10% of baseMinInitialSize
163   uint baseMinRemainingSize; // set at init
164 
165   // maximum order size (exclusive)
166   // chosen so that even multiplied by the max price (or divided by the min price),
167   // and then multiplied by ethRwrdRate, it still fits in 2^127, allowing us to save
168   // some gas by storing executed + fee fields as uint128.
169   // even with 18 decimals, this still allows order sizes up to 1,000,000,000.
170   // if we encounter a token with e.g. 36 decimals we'll have to revisit ...
171   uint constant baseMaxSize = 10 ** 30;
172 
173   // the counter currency (ETH)
174   // (no address because it is ETH)
175 
176   // avoid the book getting cluttered up with tiny amounts not worth the gas
177   uint constant cntrMinInitialSize = 10 finney;
178 
179   // see comments for baseMaxSize
180   uint constant cntrMaxSize = 10 ** 30;
181 
182   // the reward token that can be used to pay fees (UBI)
183 
184   ERC20 rwrdToken; // set at init
185 
186   // used to convert ETH amount to reward tokens when paying fee with reward tokens
187   uint constant ethRwrdRate = 1000;
188   
189   // funds that belong to clients (base, counter, and reward)
190 
191   mapping (address => uint) balanceBaseForClient;
192   mapping (address => uint) balanceCntrForClient;
193   mapping (address => uint) balanceRwrdForClient;
194 
195   // fee charged on liquidity taken, expressed as a divisor
196   // (e.g. 2000 means 1/2000, or 0.05%)
197 
198   uint constant feeDivisor = 2000;
199   
200   // fees charged are given to:
201   
202   address feeCollector; // set at init
203 
204   // all orders ever created
205   
206   mapping (uint128 => Order) orderForOrderId;
207 
208   // Effectively a compact mapping from price to whether there are any open orders at that price.
209   // See "Price Calculation Constants" below as to why 85.
210 
211   uint256[85] occupiedPriceBitmaps;
212 
213   // These allow us to walk over the orders in the book at a given price level (and add more).
214 
215   mapping (uint16 => OrderChain) orderChainForOccupiedPrice;
216   mapping (uint128 => OrderChainNode) orderChainNodeForOpenOrderId;
217 
218   // These allow a client to (reasonably) efficiently find their own orders
219   // without relying on events (which even indexed are a bit expensive to search
220   // and cannot be accessed from smart contracts). See walkOrders.
221 
222   mapping (address => uint128) mostRecentOrderIdForClient;
223   mapping (uint128 => uint128) clientPreviousOrderIdBeforeOrderId;
224 
225   // Price Calculation Constants.
226   //
227   // We pack direction and price into a crafty decimal floating point representation
228   // for efficient indexing by price, the main thing we lose by doing so is precision -
229   // we only have 3 significant figures in our prices.
230   //
231   // An unpacked price consists of:
232   //
233   //   direction - invalid / buy / sell
234   //   mantissa  - ranges from 100 to 999 representing 0.100 to 0.999
235   //   exponent  - ranges from minimumPriceExponent to minimumPriceExponent + 11
236   //               (e.g. -5 to +6 for a typical pair where minPriceExponent = -5)
237   //
238   // The packed representation has 21601 different price values:
239   //
240   //      0  = invalid (can be used as marker value)
241   //      1  = buy at maximum price (0.999 * 10 ** 6)
242   //    ...  = other buy prices in descending order
243   //   5400  = buy at 1.00
244   //    ...  = other buy prices in descending order
245   //  10800  = buy at minimum price (0.100 * 10 ** -5)
246   //  10801  = sell at minimum price (0.100 * 10 ** -5)
247   //    ...  = other sell prices in descending order
248   //  16201  = sell at 1.00
249   //    ...  = other sell prices in descending order
250   //  21600  = sell at maximum price (0.999 * 10 ** 6)
251   //  21601+ = do not use
252   //
253   // If we want to map each packed price to a boolean value (which we do),
254   // we require 85 256-bit words. Or 42.5 for each side of the book.
255   
256   int8 minPriceExponent; // set at init
257 
258   uint constant invalidPrice = 0;
259 
260   // careful: max = largest unpacked value, not largest packed value
261   uint constant maxBuyPrice = 1; 
262   uint constant minBuyPrice = 10800;
263   uint constant minSellPrice = 10801;
264   uint constant maxSellPrice = 21600;
265 
266   // Constructor.
267   //
268   // Sets feeCollector to the creator. Creator needs to call init() to finish setup.
269   //
270   function BookERC20EthV1p1() {
271     address creator = msg.sender;
272     feeCollector = creator;
273   }
274 
275   // "Public" Management - set address of base and reward tokens.
276   //
277   // Can only be done once (normally immediately after creation) by the fee collector.
278   //
279   // Used instead of a constructor to make deployment easier.
280   //
281   // baseMinInitialSize is the minimum order size in token-wei;
282   // the minimum resting size will be one tenth of that.
283   //
284   // minPriceExponent controls the range of prices supported by the contract;
285   // the range will be 0.100*10**minPriceExponent to 0.999*10**(minPriceExponent + 11)
286   // but careful; this is in token-wei : wei, ignoring the number of decimals of the token
287   // e.g. -5 implies 1 token-wei worth between 0.100e-5 to 0.999e+6 wei
288   // which implies same token:eth exchange rate if token decimals are 18 like eth,
289   // but if token decimals are 8, that would imply 1 token worth 10 wei to 0.000999 ETH.
290   //
291   function init(ERC20 _baseToken, ERC20 _rwrdToken, uint _baseMinInitialSize, int8 _minPriceExponent) public {
292     require(msg.sender == feeCollector);
293     require(address(baseToken) == 0);
294     require(address(_baseToken) != 0);
295     require(address(rwrdToken) == 0);
296     require(address(_rwrdToken) != 0);
297     require(_baseMinInitialSize >= 10);
298     require(_baseMinInitialSize < baseMaxSize / 1000000);
299     require(_minPriceExponent >= -20 && _minPriceExponent <= 20);
300     if (_minPriceExponent < 2) {
301       require(_baseMinInitialSize >= 10 ** uint(3-int(minPriceExponent)));
302     }
303     baseMinInitialSize = _baseMinInitialSize;
304     // dust prevention. truncation ok, know >= 10
305     baseMinRemainingSize = _baseMinInitialSize / 10;
306     minPriceExponent = _minPriceExponent;
307     // attempt to catch bad tokens:
308     require(_baseToken.totalSupply() > 0);
309     baseToken = _baseToken;
310     require(_rwrdToken.totalSupply() > 0);
311     rwrdToken = _rwrdToken;
312   }
313 
314   // "Public" Management - change fee collector
315   //
316   // The new fee collector only gets fees charged after this point.
317   //
318   function changeFeeCollector(address newFeeCollector) public {
319     address oldFeeCollector = feeCollector;
320     require(msg.sender == oldFeeCollector);
321     require(newFeeCollector != oldFeeCollector);
322     feeCollector = newFeeCollector;
323   }
324   
325   // Public Info View - what is being traded here, what are the limits?
326   //
327   function getBookInfo() public constant returns (
328       BookType _bookType, address _baseToken, address _rwrdToken,
329       uint _baseMinInitialSize, uint _cntrMinInitialSize, int8 _minPriceExponent,
330       uint _feeDivisor, address _feeCollector
331     ) {
332     return (
333       BookType.ERC20EthV1,
334       address(baseToken),
335       address(rwrdToken),
336       baseMinInitialSize, // can assume min resting size is one tenth of this
337       cntrMinInitialSize,
338       minPriceExponent,
339       feeDivisor,
340       feeCollector
341     );
342   }
343 
344   // Public Funds View - get balances held by contract on behalf of the client,
345   // or balances approved for deposit but not yet claimed by the contract.
346   //
347   // Excludes funds in open orders.
348   //
349   // Helps a web ui get a consistent snapshot of balances.
350   //
351   // It would be nice to return the off-exchange ETH balance too but there's a
352   // bizarre bug in geth (and apparently as a result via MetaMask) that leads
353   // to unpredictable behaviour when looking up client balances in constant
354   // functions - see e.g. https://github.com/ethereum/solidity/issues/2325 .
355   //
356   function getClientBalances(address client) public constant returns (
357       uint bookBalanceBase,
358       uint bookBalanceCntr,
359       uint bookBalanceRwrd,
360       uint approvedBalanceBase,
361       uint approvedBalanceRwrd,
362       uint ownBalanceBase,
363       uint ownBalanceRwrd
364     ) {
365     bookBalanceBase = balanceBaseForClient[client];
366     bookBalanceCntr = balanceCntrForClient[client];
367     bookBalanceRwrd = balanceRwrdForClient[client];
368     approvedBalanceBase = baseToken.allowance(client, address(this));
369     approvedBalanceRwrd = rwrdToken.allowance(client, address(this));
370     ownBalanceBase = baseToken.balanceOf(client);
371     ownBalanceRwrd = rwrdToken.balanceOf(client);
372   }
373 
374   // Public Funds Manipulation - deposit previously-approved base tokens.
375   //
376   function transferFromBase() public {
377     address client = msg.sender;
378     address book = address(this);
379     // we trust the ERC20 token contract not to do nasty things like call back into us -
380     // if we cannot trust the token then why are we allowing it to be traded?
381     uint amountBase = baseToken.allowance(client, book);
382     require(amountBase > 0);
383     // NB: needs change for older ERC20 tokens that don't return bool
384     require(baseToken.transferFrom(client, book, amountBase));
385     // belt and braces
386     assert(baseToken.allowance(client, book) == 0);
387     balanceBaseForClient[client] += amountBase;
388     ClientPaymentEvent(client, ClientPaymentEventType.TransferFrom, BalanceType.Base, int(amountBase));
389   }
390 
391   // Public Funds Manipulation - withdraw base tokens (as a transfer).
392   //
393   function transferBase(uint amountBase) public {
394     address client = msg.sender;
395     require(amountBase > 0);
396     require(amountBase <= balanceBaseForClient[client]);
397     // overflow safe since we checked less than balance above
398     balanceBaseForClient[client] -= amountBase;
399     // we trust the ERC20 token contract not to do nasty things like call back into us -
400     // if we cannot trust the token then why are we allowing it to be traded?
401     // NB: needs change for older ERC20 tokens that don't return bool
402     require(baseToken.transfer(client, amountBase));
403     ClientPaymentEvent(client, ClientPaymentEventType.Transfer, BalanceType.Base, -int(amountBase));
404   }
405 
406   // Public Funds Manipulation - deposit counter currency (ETH).
407   //
408   function depositCntr() public payable {
409     address client = msg.sender;
410     uint amountCntr = msg.value;
411     require(amountCntr > 0);
412     // overflow safe - if someone owns pow(2,255) ETH we have bigger problems
413     balanceCntrForClient[client] += amountCntr;
414     ClientPaymentEvent(client, ClientPaymentEventType.Deposit, BalanceType.Cntr, int(amountCntr));
415   }
416 
417   // Public Funds Manipulation - withdraw counter currency (ETH).
418   //
419   function withdrawCntr(uint amountCntr) public {
420     address client = msg.sender;
421     require(amountCntr > 0);
422     require(amountCntr <= balanceCntrForClient[client]);
423     // overflow safe - checked less than balance above
424     balanceCntrForClient[client] -= amountCntr;
425     // safe - not enough gas to do anything interesting in fallback, already adjusted balance
426     client.transfer(amountCntr);
427     ClientPaymentEvent(client, ClientPaymentEventType.Withdraw, BalanceType.Cntr, -int(amountCntr));
428   }
429 
430   // Public Funds Manipulation - deposit previously-approved reward tokens.
431   //
432   function transferFromRwrd() public {
433     address client = msg.sender;
434     address book = address(this);
435     uint amountRwrd = rwrdToken.allowance(client, book);
436     require(amountRwrd > 0);
437     // we wrote the reward token so we know it supports ERC20 properly and is not evil
438     require(rwrdToken.transferFrom(client, book, amountRwrd));
439     // belt and braces
440     assert(rwrdToken.allowance(client, book) == 0);
441     balanceRwrdForClient[client] += amountRwrd;
442     ClientPaymentEvent(client, ClientPaymentEventType.TransferFrom, BalanceType.Rwrd, int(amountRwrd));
443   }
444 
445   // Public Funds Manipulation - withdraw base tokens (as a transfer).
446   //
447   function transferRwrd(uint amountRwrd) public {
448     address client = msg.sender;
449     require(amountRwrd > 0);
450     require(amountRwrd <= balanceRwrdForClient[client]);
451     // overflow safe - checked less than balance above
452     balanceRwrdForClient[client] -= amountRwrd;
453     // we wrote the reward token so we know it supports ERC20 properly and is not evil
454     require(rwrdToken.transfer(client, amountRwrd));
455     ClientPaymentEvent(client, ClientPaymentEventType.Transfer, BalanceType.Rwrd, -int(amountRwrd));
456   }
457 
458   // Public Order View - get full details of an order.
459   //
460   // If the orderId does not exist, status will be Unknown.
461   //
462   function getOrder(uint128 orderId) public constant returns (
463     address client, uint16 price, uint sizeBase, Terms terms,
464     Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
465     uint feesBaseOrCntr, uint feesRwrd) {
466     Order storage order = orderForOrderId[orderId];
467     return (order.client, order.price, order.sizeBase, order.terms,
468             order.status, order.reasonCode, order.executedBase, order.executedCntr,
469             order.feesBaseOrCntr, order.feesRwrd);
470   }
471 
472   // Public Order View - get mutable details of an order.
473   //
474   // If the orderId does not exist, status will be Unknown.
475   //
476   function getOrderState(uint128 orderId) public constant returns (
477     Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
478     uint feesBaseOrCntr, uint feesRwrd) {
479     Order storage order = orderForOrderId[orderId];
480     return (order.status, order.reasonCode, order.executedBase, order.executedCntr,
481             order.feesBaseOrCntr, order.feesRwrd);
482   }
483   
484   // Public Order View - enumerate all recent orders + all open orders for one client.
485   //
486   // Not really designed for use from a smart contract transaction.
487   //
488   // Idea is:
489   //  - client ensures order ids are generated so that most-signficant part is time-based;
490   //  - client decides they want all orders after a certain point-in-time,
491   //    and chooses minClosedOrderIdCutoff accordingly;
492   //  - before that point-in-time they just get open and needs gas orders
493   //  - client calls walkClientOrders with maybeLastOrderIdReturned = 0 initially;
494   //  - then repeats with the orderId returned by walkClientOrders;
495   //  - (and stops if it returns a zero orderId);
496   //
497   // Note that client is only used when maybeLastOrderIdReturned = 0.
498   //
499   function walkClientOrders(
500       address client, uint128 maybeLastOrderIdReturned, uint128 minClosedOrderIdCutoff
501     ) public constant returns (
502       uint128 orderId, uint16 price, uint sizeBase, Terms terms,
503       Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
504       uint feesBaseOrCntr, uint feesRwrd) {
505     if (maybeLastOrderIdReturned == 0) {
506       orderId = mostRecentOrderIdForClient[client];
507     } else {
508       orderId = clientPreviousOrderIdBeforeOrderId[maybeLastOrderIdReturned];
509     }
510     while (true) {
511       if (orderId == 0) return;
512       Order storage order = orderForOrderId[orderId];
513       if (orderId >= minClosedOrderIdCutoff) break;
514       if (order.status == Status.Open || order.status == Status.NeedsGas) break;
515       orderId = clientPreviousOrderIdBeforeOrderId[orderId];
516     }
517     return (orderId, order.price, order.sizeBase, order.terms,
518             order.status, order.reasonCode, order.executedBase, order.executedCntr,
519             order.feesBaseOrCntr, order.feesRwrd);
520   }
521  
522   // Internal Price Calculation - turn packed price into a friendlier unpacked price.
523   //
524   function unpackPrice(uint16 price) internal constant returns (
525       Direction direction, uint16 mantissa, int8 exponent
526     ) {
527     uint sidedPriceIndex = uint(price);
528     uint priceIndex;
529     if (sidedPriceIndex < 1 || sidedPriceIndex > maxSellPrice) {
530       direction = Direction.Invalid;
531       mantissa = 0;
532       exponent = 0;
533       return;
534     } else if (sidedPriceIndex <= minBuyPrice) {
535       direction = Direction.Buy;
536       priceIndex = minBuyPrice - sidedPriceIndex;
537     } else {
538       direction = Direction.Sell;
539       priceIndex = sidedPriceIndex - minSellPrice;
540     }
541     uint zeroBasedMantissa = priceIndex % 900;
542     uint zeroBasedExponent = priceIndex / 900;
543     mantissa = uint16(zeroBasedMantissa + 100);
544     exponent = int8(zeroBasedExponent) + minPriceExponent;
545     return;
546   }
547   
548   // Internal Price Calculation - is a packed price on the buy side?
549   //
550   // Throws an error if price is invalid.
551   //
552   function isBuyPrice(uint16 price) internal constant returns (bool isBuy) {
553     // yes, this looks odd, but max here is highest _unpacked_ price
554     return price >= maxBuyPrice && price <= minBuyPrice;
555   }
556   
557   // Internal Price Calculation - turn a packed buy price into a packed sell price.
558   //
559   // Invalid price remains invalid.
560   //
561   function computeOppositePrice(uint16 price) internal constant returns (uint16 opposite) {
562     if (price < maxBuyPrice || price > maxSellPrice) {
563       return uint16(invalidPrice);
564     } else if (price <= minBuyPrice) {
565       return uint16(maxSellPrice - (price - maxBuyPrice));
566     } else {
567       return uint16(maxBuyPrice + (maxSellPrice - price));
568     }
569   }
570   
571   // Internal Price Calculation - compute amount in counter currency that would
572   // be obtained by selling baseAmount at the given unpacked price (if no fees).
573   //
574   // Notes:
575   //  - Does not validate price - caller must ensure valid.
576   //  - Could overflow producing very unexpected results if baseAmount very
577   //    large - caller must check this.
578   //  - This rounds the amount towards zero.
579   //  - May truncate to zero if baseAmount very small - potentially allowing
580   //    zero-cost buys or pointless sales - caller must check this.
581   //
582   function computeCntrAmountUsingUnpacked(
583       uint baseAmount, uint16 mantissa, int8 exponent
584     ) internal constant returns (uint cntrAmount) {
585     if (exponent < 0) {
586       return baseAmount * uint(mantissa) / 1000 / 10 ** uint(-exponent);
587     } else {
588       return baseAmount * uint(mantissa) / 1000 * 10 ** uint(exponent);
589     }
590   }
591 
592   // Internal Price Calculation - compute amount in counter currency that would
593   // be obtained by selling baseAmount at the given packed price (if no fees).
594   //
595   // Notes:
596   //  - Does not validate price - caller must ensure valid.
597   //  - Direction of the packed price is ignored.
598   //  - Could overflow producing very unexpected results if baseAmount very
599   //    large - caller must check this.
600   //  - This rounds the amount towards zero (regardless of Buy or Sell).
601   //  - May truncate to zero if baseAmount very small - potentially allowing
602   //    zero-cost buys or pointless sales - caller must check this.
603   //
604   function computeCntrAmountUsingPacked(
605       uint baseAmount, uint16 price
606     ) internal constant returns (uint) {
607     var (, mantissa, exponent) = unpackPrice(price);
608     return computeCntrAmountUsingUnpacked(baseAmount, mantissa, exponent);
609   }
610 
611   // Public Order Placement - create order and try to match it and/or add it to the book.
612   //
613   function createOrder(
614       uint128 orderId, uint16 price, uint sizeBase, Terms terms, uint maxMatches
615     ) public {
616     address client = msg.sender;
617     require(orderId != 0 && orderForOrderId[orderId].client == 0);
618     ClientOrderEvent(client, ClientOrderEventType.Create, orderId, maxMatches);
619     orderForOrderId[orderId] =
620       Order(client, price, sizeBase, terms, Status.Unknown, ReasonCode.None, 0, 0, 0, 0);
621     uint128 previousMostRecentOrderIdForClient = mostRecentOrderIdForClient[client];
622     mostRecentOrderIdForClient[client] = orderId;
623     clientPreviousOrderIdBeforeOrderId[orderId] = previousMostRecentOrderIdForClient;
624     Order storage order = orderForOrderId[orderId];
625     var (direction, mantissa, exponent) = unpackPrice(price);
626     if (direction == Direction.Invalid) {
627       order.status = Status.Rejected;
628       order.reasonCode = ReasonCode.InvalidPrice;
629       return;
630     }
631     if (sizeBase < baseMinInitialSize || sizeBase > baseMaxSize) {
632       order.status = Status.Rejected;
633       order.reasonCode = ReasonCode.InvalidSize;
634       return;
635     }
636     uint sizeCntr = computeCntrAmountUsingUnpacked(sizeBase, mantissa, exponent);
637     if (sizeCntr < cntrMinInitialSize || sizeCntr > cntrMaxSize) {
638       order.status = Status.Rejected;
639       order.reasonCode = ReasonCode.InvalidSize;
640       return;
641     }
642     if (terms == Terms.MakerOnly && maxMatches != 0) {
643       order.status = Status.Rejected;
644       order.reasonCode = ReasonCode.InvalidTerms;
645       return;
646     }
647     if (!debitFunds(client, direction, sizeBase, sizeCntr)) {
648       order.status = Status.Rejected;
649       order.reasonCode = ReasonCode.InsufficientFunds;
650       return;
651     }
652     processOrder(orderId, maxMatches);
653   }
654 
655   // Public Order Placement - cancel order
656   //
657   function cancelOrder(uint128 orderId) public {
658     address client = msg.sender;
659     Order storage order = orderForOrderId[orderId];
660     require(order.client == client);
661     Status status = order.status;
662     if (status != Status.Open && status != Status.NeedsGas) {
663       return;
664     }
665     ClientOrderEvent(client, ClientOrderEventType.Cancel, orderId, 0);
666     if (status == Status.Open) {
667       removeOpenOrderFromBook(orderId);
668       MarketOrderEvent(block.timestamp, orderId, MarketOrderEventType.Remove, order.price,
669         order.sizeBase - order.executedBase, 0);
670     }
671     refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.ClientCancel);
672   }
673 
674   // Public Order Placement - continue placing an order in 'NeedsGas' state
675   //
676   function continueOrder(uint128 orderId, uint maxMatches) public {
677     address client = msg.sender;
678     Order storage order = orderForOrderId[orderId];
679     require(order.client == client);
680     if (order.status != Status.NeedsGas) {
681       return;
682     }
683     ClientOrderEvent(client, ClientOrderEventType.Continue, orderId, maxMatches);
684     order.status = Status.Unknown;
685     processOrder(orderId, maxMatches);
686   }
687 
688   // Internal Order Placement - remove a still-open order from the book.
689   //
690   // Caller's job to update/refund the order + raise event, this just
691   // updates the order chain and bitmask.
692   //
693   // Too expensive to do on each resting order match - we only do this for an
694   // order being cancelled. See matchWithOccupiedPrice for similar logic.
695   //
696   function removeOpenOrderFromBook(uint128 orderId) internal {
697     Order storage order = orderForOrderId[orderId];
698     uint16 price = order.price;
699     OrderChain storage orderChain = orderChainForOccupiedPrice[price];
700     OrderChainNode storage orderChainNode = orderChainNodeForOpenOrderId[orderId];
701     uint128 nextOrderId = orderChainNode.nextOrderId;
702     uint128 prevOrderId = orderChainNode.prevOrderId;
703     if (nextOrderId != 0) {
704       OrderChainNode storage nextOrderChainNode = orderChainNodeForOpenOrderId[nextOrderId];
705       nextOrderChainNode.prevOrderId = prevOrderId;
706     } else {
707       orderChain.lastOrderId = prevOrderId;
708     }
709     if (prevOrderId != 0) {
710       OrderChainNode storage prevOrderChainNode = orderChainNodeForOpenOrderId[prevOrderId];
711       prevOrderChainNode.nextOrderId = nextOrderId;
712     } else {
713       orderChain.firstOrderId = nextOrderId;
714     }
715     if (nextOrderId == 0 && prevOrderId == 0) {
716       uint bmi = price / 256;  // index into array of bitmaps
717       uint bti = price % 256;  // bit position within bitmap
718       // we know was previously occupied so XOR clears
719       occupiedPriceBitmaps[bmi] ^= 2 ** bti;
720     }
721   }
722 
723   // Internal Order Placement - credit funds received when taking liquidity from book
724   //
725   function creditExecutedFundsLessFees(uint128 orderId, uint originalExecutedBase, uint originalExecutedCntr) internal {
726     Order storage order = orderForOrderId[orderId];
727     uint liquidityTakenBase = order.executedBase - originalExecutedBase;
728     uint liquidityTakenCntr = order.executedCntr - originalExecutedCntr;
729     // Normally we deduct the fee from the currency bought (base for buy, cntr for sell),
730     // however we also accept reward tokens from the reward balance if it covers the fee,
731     // with the reward amount converted from the ETH amount (the counter currency here)
732     // at a fixed exchange rate.
733     // Overflow safe since we ensure order size < 10^30 in both currencies (see baseMaxSize).
734     // Can truncate to zero, which is fine.
735     uint feesRwrd = liquidityTakenCntr / feeDivisor * ethRwrdRate;
736     uint feesBaseOrCntr;
737     address client = order.client;
738     uint availRwrd = balanceRwrdForClient[client];
739     if (feesRwrd <= availRwrd) {
740       balanceRwrdForClient[client] = availRwrd - feesRwrd;
741       balanceRwrdForClient[feeCollector] = feesRwrd;
742       // Need += rather than = because could have paid some fees earlier in NeedsGas situation.
743       // Overflow safe since we ensure order size < 10^30 in both currencies (see baseMaxSize).
744       // Can truncate to zero, which is fine.
745       order.feesRwrd += uint128(feesRwrd);
746       if (isBuyPrice(order.price)) {
747         balanceBaseForClient[client] += liquidityTakenBase;
748       } else {
749         balanceCntrForClient[client] += liquidityTakenCntr;
750       }
751     } else if (isBuyPrice(order.price)) {
752       // See comments in branch above re: use of += and overflow safety.
753       feesBaseOrCntr = liquidityTakenBase / feeDivisor;
754       balanceBaseForClient[order.client] += (liquidityTakenBase - feesBaseOrCntr);
755       order.feesBaseOrCntr += uint128(feesBaseOrCntr);
756       balanceBaseForClient[feeCollector] += feesBaseOrCntr;
757     } else {
758       // See comments in branch above re: use of += and overflow safety.
759       feesBaseOrCntr = liquidityTakenCntr / feeDivisor;
760       balanceCntrForClient[order.client] += (liquidityTakenCntr - feesBaseOrCntr);
761       order.feesBaseOrCntr += uint128(feesBaseOrCntr);
762       balanceCntrForClient[feeCollector] += feesBaseOrCntr;
763     }
764   }
765 
766   // Internal Order Placement - process a created and sanity checked order.
767   //
768   // Used both for new orders and for gas topup.
769   //
770   function processOrder(uint128 orderId, uint maxMatches) internal {
771     Order storage order = orderForOrderId[orderId];
772 
773     uint ourOriginalExecutedBase = order.executedBase;
774     uint ourOriginalExecutedCntr = order.executedCntr;
775 
776     var (ourDirection,) = unpackPrice(order.price);
777     uint theirPriceStart = (ourDirection == Direction.Buy) ? minSellPrice : maxBuyPrice;
778     uint theirPriceEnd = computeOppositePrice(order.price);
779    
780     MatchStopReason matchStopReason =
781       matchAgainstBook(orderId, theirPriceStart, theirPriceEnd, maxMatches);
782 
783     creditExecutedFundsLessFees(orderId, ourOriginalExecutedBase, ourOriginalExecutedCntr);
784 
785     if (order.terms == Terms.ImmediateOrCancel) {
786       if (matchStopReason == MatchStopReason.Satisfied) {
787         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
788         return;
789       } else if (matchStopReason == MatchStopReason.MaxMatches) {
790         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.TooManyMatches);
791         return;
792       } else if (matchStopReason == MatchStopReason.BookExhausted) {
793         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.Unmatched);
794         return;
795       }
796     } else if (order.terms == Terms.MakerOnly) {
797       if (matchStopReason == MatchStopReason.MaxMatches) {
798         refundUnmatchedAndFinish(orderId, Status.Rejected, ReasonCode.WouldTake);
799         return;
800       } else if (matchStopReason == MatchStopReason.BookExhausted) {
801         enterOrder(orderId);
802         return;
803       }
804     } else if (order.terms == Terms.GTCNoGasTopup) {
805       if (matchStopReason == MatchStopReason.Satisfied) {
806         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
807         return;
808       } else if (matchStopReason == MatchStopReason.MaxMatches) {
809         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.TooManyMatches);
810         return;
811       } else if (matchStopReason == MatchStopReason.BookExhausted) {
812         enterOrder(orderId);
813         return;
814       }
815     } else if (order.terms == Terms.GTCWithGasTopup) {
816       if (matchStopReason == MatchStopReason.Satisfied) {
817         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
818         return;
819       } else if (matchStopReason == MatchStopReason.MaxMatches) {
820         order.status = Status.NeedsGas;
821         return;
822       } else if (matchStopReason == MatchStopReason.BookExhausted) {
823         enterOrder(orderId);
824         return;
825       }
826     }
827     assert(false); // should not be possible to reach here
828   }
829  
830   // Used internally to indicate why we stopped matching an order against the book.
831 
832   enum MatchStopReason {
833     None,
834     MaxMatches,
835     Satisfied,
836     PriceExhausted,
837     BookExhausted
838   }
839  
840   // Internal Order Placement - Match the given order against the book.
841   //
842   // Resting orders matched will be updated, removed from book and funds credited to their owners.
843   //
844   // Only updates the executedBase and executedCntr of the given order - caller is responsible
845   // for crediting matched funds, charging fees, marking order as done / entering it into the book.
846   //
847   // matchStopReason returned will be one of MaxMatches, Satisfied or BookExhausted.
848   //
849   // Calling with maxMatches == 0 is ok - and expected when the order is a maker-only order.
850   //
851   function matchAgainstBook(
852       uint128 orderId, uint theirPriceStart, uint theirPriceEnd, uint maxMatches
853     ) internal returns (
854       MatchStopReason matchStopReason
855     ) {
856     Order storage order = orderForOrderId[orderId];
857     
858     uint bmi = theirPriceStart / 256;  // index into array of bitmaps
859     uint bti = theirPriceStart % 256;  // bit position within bitmap
860     uint bmiEnd = theirPriceEnd / 256; // last bitmap to search
861     uint btiEnd = theirPriceEnd % 256; // stop at this bit in the last bitmap
862 
863     uint cbm = occupiedPriceBitmaps[bmi]; // original copy of current bitmap
864     uint dbm = cbm; // dirty version of current bitmap where we may have cleared bits
865     uint wbm = cbm >> bti; // working copy of current bitmap which we keep shifting
866     
867     // these loops are pretty ugly, and somewhat unpredicatable in terms of gas,
868     // ... but no-one else has come up with a better matching engine yet!
869 
870     bool removedLastAtPrice;
871     matchStopReason = MatchStopReason.None;
872 
873     while (bmi < bmiEnd) {
874       if (wbm == 0 || bti == 256) {
875         if (dbm != cbm) {
876           occupiedPriceBitmaps[bmi] = dbm;
877         }
878         bti = 0;
879         bmi++;
880         cbm = occupiedPriceBitmaps[bmi];
881         wbm = cbm;
882         dbm = cbm;
883       } else {
884         if ((wbm & 1) != 0) {
885           // careful - copy-and-pasted in loop below ...
886           (removedLastAtPrice, maxMatches, matchStopReason) =
887             matchWithOccupiedPrice(order, uint16(bmi * 256 + bti), maxMatches);
888           if (removedLastAtPrice) {
889             dbm ^= 2 ** bti;
890           }
891           if (matchStopReason == MatchStopReason.PriceExhausted) {
892             matchStopReason = MatchStopReason.None;
893           } else if (matchStopReason != MatchStopReason.None) {
894             // we might still have changes in dbm to write back - see later
895             break;
896           }
897         }
898         bti += 1;
899         wbm /= 2;
900       }
901     }
902     if (matchStopReason == MatchStopReason.None) {
903       // we've reached the last bitmap we need to search,
904       // we'll stop at btiEnd not 256 this time.
905       while (bti <= btiEnd && wbm != 0) {
906         if ((wbm & 1) != 0) {
907           // careful - copy-and-pasted in loop above ...
908           (removedLastAtPrice, maxMatches, matchStopReason) =
909             matchWithOccupiedPrice(order, uint16(bmi * 256 + bti), maxMatches);
910           if (removedLastAtPrice) {
911             dbm ^= 2 ** bti;
912           }
913           if (matchStopReason == MatchStopReason.PriceExhausted) {
914             matchStopReason = MatchStopReason.None;
915           } else if (matchStopReason != MatchStopReason.None) {
916             break;
917           }
918         }
919         bti += 1;
920         wbm /= 2;
921       }
922     }
923     // Careful - if we exited the first loop early, or we went into the second loop,
924     // (luckily can't both happen) then we haven't flushed the dirty bitmap back to
925     // storage - do that now if we need to.
926     if (dbm != cbm) {
927       occupiedPriceBitmaps[bmi] = dbm;
928     }
929     if (matchStopReason == MatchStopReason.None) {
930       matchStopReason = MatchStopReason.BookExhausted;
931     }
932   }
933 
934   // Internal Order Placement.
935   //
936   // Match our order against up to maxMatches resting orders at the given price (which
937   // is known by the caller to have at least one resting order).
938   //
939   // The matches (partial or complete) of the resting orders are recorded, and their
940   // funds are credited.
941   //
942   // The order chain for the resting orders is updated, but the occupied price bitmap is NOT -
943   // the caller must clear the relevant bit if removedLastAtPrice = true is returned.
944   //
945   // Only updates the executedBase and executedCntr of our order - caller is responsible
946   // for e.g. crediting our matched funds, updating status.
947   //
948   // Calling with maxMatches == 0 is ok - and expected when the order is a maker-only order.
949   //
950   // Returns:
951   //   removedLastAtPrice:
952   //     true iff there are no longer any resting orders at this price - caller will need
953   //     to update the occupied price bitmap.
954   //
955   //   matchesLeft:
956   //     maxMatches passed in minus the number of matches made by this call
957   //
958   //   matchStopReason:
959   //     If our order is completely matched, matchStopReason will be Satisfied.
960   //     If our order is not completely matched, matchStopReason will be either:
961   //        MaxMatches (we are not allowed to match any more times)
962   //     or:
963   //        PriceExhausted (nothing left on the book at this exact price)
964   //
965   function matchWithOccupiedPrice(
966       Order storage ourOrder, uint16 theirPrice, uint maxMatches
967     ) internal returns (
968     bool removedLastAtPrice, uint matchesLeft, MatchStopReason matchStopReason) {
969     matchesLeft = maxMatches;
970     uint workingOurExecutedBase = ourOrder.executedBase;
971     uint workingOurExecutedCntr = ourOrder.executedCntr;
972     uint128 theirOrderId = orderChainForOccupiedPrice[theirPrice].firstOrderId;
973     matchStopReason = MatchStopReason.None;
974     while (true) {
975       if (matchesLeft == 0) {
976         matchStopReason = MatchStopReason.MaxMatches;
977         break;
978       }
979       uint matchBase;
980       uint matchCntr;
981       (theirOrderId, matchBase, matchCntr, matchStopReason) =
982         matchWithTheirs((ourOrder.sizeBase - workingOurExecutedBase), theirOrderId, theirPrice);
983       workingOurExecutedBase += matchBase;
984       workingOurExecutedCntr += matchCntr;
985       matchesLeft -= 1;
986       if (matchStopReason != MatchStopReason.None) {
987         break;
988       }
989     }
990     ourOrder.executedBase = uint128(workingOurExecutedBase);
991     ourOrder.executedCntr = uint128(workingOurExecutedCntr);
992     if (theirOrderId == 0) {
993       orderChainForOccupiedPrice[theirPrice].firstOrderId = 0;
994       orderChainForOccupiedPrice[theirPrice].lastOrderId = 0;
995       removedLastAtPrice = true;
996     } else {
997       // NB: in some cases (e.g. maxMatches == 0) this is a no-op.
998       orderChainForOccupiedPrice[theirPrice].firstOrderId = theirOrderId;
999       orderChainNodeForOpenOrderId[theirOrderId].prevOrderId = 0;
1000       removedLastAtPrice = false;
1001     }
1002   }
1003   
1004   // Internal Order Placement.
1005   //
1006   // Match up to our remaining amount against a resting order in the book.
1007   //
1008   // The match (partial, complete or effectively-complete) of the resting order
1009   // is recorded, and their funds are credited.
1010   //
1011   // Their order is NOT removed from the book by this call - the caller must do that
1012   // if the nextTheirOrderId returned is not equal to the theirOrderId passed in.
1013   //
1014   // Returns:
1015   //
1016   //   nextTheirOrderId:
1017   //     If we did not completely match their order, will be same as theirOrderId.
1018   //     If we completely matched their order, will be orderId of next order at the
1019   //     same price - or zero if this was the last order and we've now filled it.
1020   //
1021   //   matchStopReason:
1022   //     If our order is completely matched, matchStopReason will be Satisfied.
1023   //     If our order is not completely matched, matchStopReason will be either
1024   //     PriceExhausted (if nothing left at this exact price) or None (if can continue).
1025   // 
1026   function matchWithTheirs(
1027     uint ourRemainingBase, uint128 theirOrderId, uint16 theirPrice) internal returns (
1028     uint128 nextTheirOrderId, uint matchBase, uint matchCntr, MatchStopReason matchStopReason) {
1029     Order storage theirOrder = orderForOrderId[theirOrderId];
1030     uint theirRemainingBase = theirOrder.sizeBase - theirOrder.executedBase;
1031     if (ourRemainingBase < theirRemainingBase) {
1032       matchBase = ourRemainingBase;
1033     } else {
1034       matchBase = theirRemainingBase;
1035     }
1036     matchCntr = computeCntrAmountUsingPacked(matchBase, theirPrice);
1037     // It may seem a bit odd to stop here if our remaining amount is very small -
1038     // there could still be resting orders we can match it against. But the gas
1039     // cost of matching each order is quite high - potentially high enough to
1040     // wipe out the profit the taker hopes for from trading the tiny amount left.
1041     if ((ourRemainingBase - matchBase) < baseMinRemainingSize) {
1042       matchStopReason = MatchStopReason.Satisfied;
1043     } else {
1044       matchStopReason = MatchStopReason.None;
1045     }
1046     bool theirsDead = recordTheirMatch(theirOrder, theirOrderId, theirPrice, matchBase, matchCntr);
1047     if (theirsDead) {
1048       nextTheirOrderId = orderChainNodeForOpenOrderId[theirOrderId].nextOrderId;
1049       if (matchStopReason == MatchStopReason.None && nextTheirOrderId == 0) {
1050         matchStopReason = MatchStopReason.PriceExhausted;
1051       }
1052     } else {
1053       nextTheirOrderId = theirOrderId;
1054     }
1055   }
1056 
1057   // Internal Order Placement.
1058   //
1059   // Record match (partial or complete) of resting order, and credit them their funds.
1060   //
1061   // If their order is completely matched, the order is marked as done,
1062   // and "theirsDead" is returned as true.
1063   //
1064   // The order is NOT removed from the book by this call - the caller
1065   // must do that if theirsDead is true.
1066   //
1067   // No sanity checks are made - the caller must be sure the order is
1068   // not already done and has sufficient remaining. (Yes, we'd like to
1069   // check here too but we cannot afford the gas).
1070   //
1071   function recordTheirMatch(
1072       Order storage theirOrder, uint128 theirOrderId, uint16 theirPrice, uint matchBase, uint matchCntr
1073     ) internal returns (bool theirsDead) {
1074     // they are a maker so no fees
1075     // overflow safe - see comments about baseMaxSize
1076     // executedBase cannot go > sizeBase due to logic in matchWithTheirs
1077     theirOrder.executedBase += uint128(matchBase);
1078     theirOrder.executedCntr += uint128(matchCntr);
1079     if (isBuyPrice(theirPrice)) {
1080       // they have bought base (using the counter they already paid when creating the order)
1081       balanceBaseForClient[theirOrder.client] += matchBase;
1082     } else {
1083       // they have bought counter (using the base they already paid when creating the order)
1084       balanceCntrForClient[theirOrder.client] += matchCntr;
1085     }
1086     uint stillRemainingBase = theirOrder.sizeBase - theirOrder.executedBase;
1087     // avoid leaving tiny amounts in the book - refund remaining if too small
1088     if (stillRemainingBase < baseMinRemainingSize) {
1089       refundUnmatchedAndFinish(theirOrderId, Status.Done, ReasonCode.None);
1090       // someone building an UI on top needs to know how much was match and how much was refund
1091       MarketOrderEvent(block.timestamp, theirOrderId, MarketOrderEventType.CompleteFill,
1092         theirPrice, matchBase + stillRemainingBase, matchBase);
1093       return true;
1094     } else {
1095       MarketOrderEvent(block.timestamp, theirOrderId, MarketOrderEventType.PartialFill,
1096         theirPrice, matchBase, matchBase);
1097       return false;
1098     }
1099   }
1100 
1101   // Internal Order Placement.
1102   //
1103   // Refund any unmatched funds in an order (based on executed vs size) and move to a final state.
1104   //
1105   // The order is NOT removed from the book by this call and no event is raised.
1106   //
1107   // No sanity checks are made - the caller must be sure the order has not already been refunded.
1108   //
1109   function refundUnmatchedAndFinish(uint128 orderId, Status status, ReasonCode reasonCode) internal {
1110     Order storage order = orderForOrderId[orderId];
1111     uint16 price = order.price;
1112     if (isBuyPrice(price)) {
1113       uint sizeCntr = computeCntrAmountUsingPacked(order.sizeBase, price);
1114       balanceCntrForClient[order.client] += sizeCntr - order.executedCntr;
1115     } else {
1116       balanceBaseForClient[order.client] += order.sizeBase - order.executedBase;
1117     }
1118     order.status = status;
1119     order.reasonCode = reasonCode;
1120   }
1121 
1122   // Internal Order Placement.
1123   //
1124   // Enter a not completely matched order into the book, marking the order as open.
1125   //
1126   // This updates the occupied price bitmap and chain.
1127   //
1128   // No sanity checks are made - the caller must be sure the order
1129   // has some unmatched amount and has been paid for!
1130   //
1131   function enterOrder(uint128 orderId) internal {
1132     Order storage order = orderForOrderId[orderId];
1133     uint16 price = order.price;
1134     OrderChain storage orderChain = orderChainForOccupiedPrice[price];
1135     OrderChainNode storage orderChainNode = orderChainNodeForOpenOrderId[orderId];
1136     if (orderChain.firstOrderId == 0) {
1137       orderChain.firstOrderId = orderId;
1138       orderChain.lastOrderId = orderId;
1139       orderChainNode.nextOrderId = 0;
1140       orderChainNode.prevOrderId = 0;
1141       uint bitmapIndex = price / 256;
1142       uint bitIndex = price % 256;
1143       occupiedPriceBitmaps[bitmapIndex] |= (2 ** bitIndex);
1144     } else {
1145       uint128 existingLastOrderId = orderChain.lastOrderId;
1146       OrderChainNode storage existingLastOrderChainNode = orderChainNodeForOpenOrderId[existingLastOrderId];
1147       orderChainNode.nextOrderId = 0;
1148       orderChainNode.prevOrderId = existingLastOrderId;
1149       existingLastOrderChainNode.nextOrderId = orderId;
1150       orderChain.lastOrderId = orderId;
1151     }
1152     MarketOrderEvent(block.timestamp, orderId, MarketOrderEventType.Add,
1153       price, order.sizeBase - order.executedBase, 0);
1154     order.status = Status.Open;
1155   }
1156 
1157   // Internal Order Placement.
1158   //
1159   // Charge the client for the cost of placing an order in the given direction.
1160   //
1161   // Return true if successful, false otherwise.
1162   //
1163   function debitFunds(
1164       address client, Direction direction, uint sizeBase, uint sizeCntr
1165     ) internal returns (bool success) {
1166     if (direction == Direction.Buy) {
1167       uint availableCntr = balanceCntrForClient[client];
1168       if (availableCntr < sizeCntr) {
1169         return false;
1170       }
1171       balanceCntrForClient[client] = availableCntr - sizeCntr;
1172       return true;
1173     } else if (direction == Direction.Sell) {
1174       uint availableBase = balanceBaseForClient[client];
1175       if (availableBase < sizeBase) {
1176         return false;
1177       }
1178       balanceBaseForClient[client] = availableBase - sizeBase;
1179       return true;
1180     } else {
1181       return false;
1182     }
1183   }
1184 
1185   // Public Book View
1186   // 
1187   // Intended for public book depth enumeration from web3 (or similar).
1188   //
1189   // Not suitable for use from a smart contract transaction - gas usage
1190   // could be very high if we have many orders at the same price.
1191   //
1192   // Start at the given inclusive price (and side) and walk down the book
1193   // (getting less aggressive) until we find some open orders or reach the
1194   // least aggressive price.
1195   //
1196   // Returns the price where we found the order(s), the depth at that price
1197   // (zero if none found), order count there, and the current blockNumber.
1198   //
1199   // (The blockNumber is handy if you're taking a snapshot which you intend
1200   //  to keep up-to-date with the market order events).
1201   //
1202   // To walk the book, the caller should start by calling walkBook with the
1203   // most aggressive buy price (Buy @ 999000).
1204   // If the price returned is the least aggressive buy price (Buy @ 0.000001),
1205   // the side is complete.
1206   // Otherwise, call walkBook again with the (packed) price returned + 1.
1207   // Then repeat for the sell side, starting with Sell @ 0.000001 and stopping
1208   // when Sell @ 999000 is returned.
1209   //
1210   function walkBook(uint16 fromPrice) public constant returns (
1211       uint16 price, uint depthBase, uint orderCount, uint blockNumber
1212     ) {
1213     uint priceStart = fromPrice;
1214     uint priceEnd = (isBuyPrice(fromPrice)) ? minBuyPrice : maxSellPrice;
1215     
1216     // See comments in matchAgainstBook re: how these crazy loops work.
1217     
1218     uint bmi = priceStart / 256;
1219     uint bti = priceStart % 256;
1220     uint bmiEnd = priceEnd / 256;
1221     uint btiEnd = priceEnd % 256;
1222 
1223     uint wbm = occupiedPriceBitmaps[bmi] >> bti;
1224     
1225     while (bmi < bmiEnd) {
1226       if (wbm == 0 || bti == 256) {
1227         bti = 0;
1228         bmi++;
1229         wbm = occupiedPriceBitmaps[bmi];
1230       } else {
1231         if ((wbm & 1) != 0) {
1232           // careful - copy-pasted in below loop
1233           price = uint16(bmi * 256 + bti);
1234           (depthBase, orderCount) = sumDepth(orderChainForOccupiedPrice[price].firstOrderId);
1235           return (price, depthBase, orderCount, block.number);
1236         }
1237         bti += 1;
1238         wbm /= 2;
1239       }
1240     }
1241     // we've reached the last bitmap we need to search, stop at btiEnd not 256 this time.
1242     while (bti <= btiEnd && wbm != 0) {
1243       if ((wbm & 1) != 0) {
1244         // careful - copy-pasted in above loop
1245         price = uint16(bmi * 256 + bti);
1246         (depthBase, orderCount) = sumDepth(orderChainForOccupiedPrice[price].firstOrderId);
1247         return (price, depthBase, orderCount, block.number);
1248       }
1249       bti += 1;
1250       wbm /= 2;
1251     }
1252     return (uint16(priceEnd), 0, 0, block.number);
1253   }
1254 
1255   // Internal Book View.
1256   //
1257   // See walkBook - adds up open depth at a price starting from an
1258   // order which is assumed to be open. Careful - unlimited gas use.
1259   //
1260   function sumDepth(uint128 orderId) internal constant returns (uint depth, uint orderCount) {
1261     while (true) {
1262       Order storage order = orderForOrderId[orderId];
1263       depth += order.sizeBase - order.executedBase;
1264       orderCount++;
1265       orderId = orderChainNodeForOpenOrderId[orderId].nextOrderId;
1266       if (orderId == 0) {
1267         return (depth, orderCount);
1268       }
1269     }
1270   }
1271 }
1272 
1273 // helper for automating book creation
1274 contract BookERC20EthV1p1Factory {
1275 
1276     event BookCreated (address bookAddress);
1277 
1278     function BookERC20EthV1p1Factory() {
1279     }
1280 
1281     function createBook(ERC20 _baseToken, ERC20 _rwrdToken, address _feeCollector, uint _baseMinInitialSize, int8 _minPriceExponent) public {
1282         BookERC20EthV1p1 book = new BookERC20EthV1p1();
1283         book.init(_baseToken, _rwrdToken, _baseMinInitialSize, _minPriceExponent);
1284         book.changeFeeCollector(_feeCollector);
1285         BookCreated(address(book));
1286     }
1287 }