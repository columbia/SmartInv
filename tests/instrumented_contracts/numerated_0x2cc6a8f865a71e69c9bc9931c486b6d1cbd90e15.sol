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
19 // This contract allows minPriceExponent, baseMinInitialSize, and baseMinRemainingSize
20 // to be set at init() time appropriately for the token decimals and likely value.
21 //
22 contract BookERC20EthV1Dec {
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
270   function BookERC20EthV1Dec() {
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
329       uint _baseMinInitialSize, uint _cntrMinInitialSize,
330       uint _feeDivisor, address _feeCollector
331     ) {
332     return (
333       BookType.ERC20EthV1,
334       address(baseToken),
335       address(rwrdToken),
336       baseMinInitialSize, // can assume min resting size is one tenth of this
337       cntrMinInitialSize,
338       feeDivisor,
339       feeCollector
340     );
341   }
342 
343   // Public Funds View - get balances held by contract on behalf of the client,
344   // or balances approved for deposit but not yet claimed by the contract.
345   //
346   // Excludes funds in open orders.
347   //
348   // Helps a web ui get a consistent snapshot of balances.
349   //
350   // It would be nice to return the off-exchange ETH balance too but there's a
351   // bizarre bug in geth (and apparently as a result via MetaMask) that leads
352   // to unpredictable behaviour when looking up client balances in constant
353   // functions - see e.g. https://github.com/ethereum/solidity/issues/2325 .
354   //
355   function getClientBalances(address client) public constant returns (
356       uint bookBalanceBase,
357       uint bookBalanceCntr,
358       uint bookBalanceRwrd,
359       uint approvedBalanceBase,
360       uint approvedBalanceRwrd,
361       uint ownBalanceBase,
362       uint ownBalanceRwrd
363     ) {
364     bookBalanceBase = balanceBaseForClient[client];
365     bookBalanceCntr = balanceCntrForClient[client];
366     bookBalanceRwrd = balanceRwrdForClient[client];
367     approvedBalanceBase = baseToken.allowance(client, address(this));
368     approvedBalanceRwrd = rwrdToken.allowance(client, address(this));
369     ownBalanceBase = baseToken.balanceOf(client);
370     ownBalanceRwrd = rwrdToken.balanceOf(client);
371   }
372 
373   // Public Funds Manipulation - deposit previously-approved base tokens.
374   //
375   function transferFromBase() public {
376     address client = msg.sender;
377     address book = address(this);
378     // we trust the ERC20 token contract not to do nasty things like call back into us -
379     // if we cannot trust the token then why are we allowing it to be traded?
380     uint amountBase = baseToken.allowance(client, book);
381     require(amountBase > 0);
382     // NB: needs change for older ERC20 tokens that don't return bool
383     require(baseToken.transferFrom(client, book, amountBase));
384     // belt and braces
385     assert(baseToken.allowance(client, book) == 0);
386     balanceBaseForClient[client] += amountBase;
387     ClientPaymentEvent(client, ClientPaymentEventType.TransferFrom, BalanceType.Base, int(amountBase));
388   }
389 
390   // Public Funds Manipulation - withdraw base tokens (as a transfer).
391   //
392   function transferBase(uint amountBase) public {
393     address client = msg.sender;
394     require(amountBase > 0);
395     require(amountBase <= balanceBaseForClient[client]);
396     // overflow safe since we checked less than balance above
397     balanceBaseForClient[client] -= amountBase;
398     // we trust the ERC20 token contract not to do nasty things like call back into us -
399     // if we cannot trust the token then why are we allowing it to be traded?
400     // NB: needs change for older ERC20 tokens that don't return bool
401     require(baseToken.transfer(client, amountBase));
402     ClientPaymentEvent(client, ClientPaymentEventType.Transfer, BalanceType.Base, -int(amountBase));
403   }
404 
405   // Public Funds Manipulation - deposit counter currency (ETH).
406   //
407   function depositCntr() public payable {
408     address client = msg.sender;
409     uint amountCntr = msg.value;
410     require(amountCntr > 0);
411     // overflow safe - if someone owns pow(2,255) ETH we have bigger problems
412     balanceCntrForClient[client] += amountCntr;
413     ClientPaymentEvent(client, ClientPaymentEventType.Deposit, BalanceType.Cntr, int(amountCntr));
414   }
415 
416   // Public Funds Manipulation - withdraw counter currency (ETH).
417   //
418   function withdrawCntr(uint amountCntr) public {
419     address client = msg.sender;
420     require(amountCntr > 0);
421     require(amountCntr <= balanceCntrForClient[client]);
422     // overflow safe - checked less than balance above
423     balanceCntrForClient[client] -= amountCntr;
424     // safe - not enough gas to do anything interesting in fallback, already adjusted balance
425     client.transfer(amountCntr);
426     ClientPaymentEvent(client, ClientPaymentEventType.Withdraw, BalanceType.Cntr, -int(amountCntr));
427   }
428 
429   // Public Funds Manipulation - deposit previously-approved reward tokens.
430   //
431   function transferFromRwrd() public {
432     address client = msg.sender;
433     address book = address(this);
434     uint amountRwrd = rwrdToken.allowance(client, book);
435     require(amountRwrd > 0);
436     // we wrote the reward token so we know it supports ERC20 properly and is not evil
437     require(rwrdToken.transferFrom(client, book, amountRwrd));
438     // belt and braces
439     assert(rwrdToken.allowance(client, book) == 0);
440     balanceRwrdForClient[client] += amountRwrd;
441     ClientPaymentEvent(client, ClientPaymentEventType.TransferFrom, BalanceType.Rwrd, int(amountRwrd));
442   }
443 
444   // Public Funds Manipulation - withdraw base tokens (as a transfer).
445   //
446   function transferRwrd(uint amountRwrd) public {
447     address client = msg.sender;
448     require(amountRwrd > 0);
449     require(amountRwrd <= balanceRwrdForClient[client]);
450     // overflow safe - checked less than balance above
451     balanceRwrdForClient[client] -= amountRwrd;
452     // we wrote the reward token so we know it supports ERC20 properly and is not evil
453     require(rwrdToken.transfer(client, amountRwrd));
454     ClientPaymentEvent(client, ClientPaymentEventType.Transfer, BalanceType.Rwrd, -int(amountRwrd));
455   }
456 
457   // Public Order View - get full details of an order.
458   //
459   // If the orderId does not exist, status will be Unknown.
460   //
461   function getOrder(uint128 orderId) public constant returns (
462     address client, uint16 price, uint sizeBase, Terms terms,
463     Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
464     uint feesBaseOrCntr, uint feesRwrd) {
465     Order storage order = orderForOrderId[orderId];
466     return (order.client, order.price, order.sizeBase, order.terms,
467             order.status, order.reasonCode, order.executedBase, order.executedCntr,
468             order.feesBaseOrCntr, order.feesRwrd);
469   }
470 
471   // Public Order View - get mutable details of an order.
472   //
473   // If the orderId does not exist, status will be Unknown.
474   //
475   function getOrderState(uint128 orderId) public constant returns (
476     Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
477     uint feesBaseOrCntr, uint feesRwrd) {
478     Order storage order = orderForOrderId[orderId];
479     return (order.status, order.reasonCode, order.executedBase, order.executedCntr,
480             order.feesBaseOrCntr, order.feesRwrd);
481   }
482   
483   // Public Order View - enumerate all recent orders + all open orders for one client.
484   //
485   // Not really designed for use from a smart contract transaction.
486   //
487   // Idea is:
488   //  - client ensures order ids are generated so that most-signficant part is time-based;
489   //  - client decides they want all orders after a certain point-in-time,
490   //    and chooses minClosedOrderIdCutoff accordingly;
491   //  - before that point-in-time they just get open and needs gas orders
492   //  - client calls walkClientOrders with maybeLastOrderIdReturned = 0 initially;
493   //  - then repeats with the orderId returned by walkClientOrders;
494   //  - (and stops if it returns a zero orderId);
495   //
496   // Note that client is only used when maybeLastOrderIdReturned = 0.
497   //
498   function walkClientOrders(
499       address client, uint128 maybeLastOrderIdReturned, uint128 minClosedOrderIdCutoff
500     ) public constant returns (
501       uint128 orderId, uint16 price, uint sizeBase, Terms terms,
502       Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
503       uint feesBaseOrCntr, uint feesRwrd) {
504     if (maybeLastOrderIdReturned == 0) {
505       orderId = mostRecentOrderIdForClient[client];
506     } else {
507       orderId = clientPreviousOrderIdBeforeOrderId[maybeLastOrderIdReturned];
508     }
509     while (true) {
510       if (orderId == 0) return;
511       Order storage order = orderForOrderId[orderId];
512       if (orderId >= minClosedOrderIdCutoff) break;
513       if (order.status == Status.Open || order.status == Status.NeedsGas) break;
514       orderId = clientPreviousOrderIdBeforeOrderId[orderId];
515     }
516     return (orderId, order.price, order.sizeBase, order.terms,
517             order.status, order.reasonCode, order.executedBase, order.executedCntr,
518             order.feesBaseOrCntr, order.feesRwrd);
519   }
520  
521   // Internal Price Calculation - turn packed price into a friendlier unpacked price.
522   //
523   function unpackPrice(uint16 price) internal constant returns (
524       Direction direction, uint16 mantissa, int8 exponent
525     ) {
526     uint sidedPriceIndex = uint(price);
527     uint priceIndex;
528     if (sidedPriceIndex < 1 || sidedPriceIndex > maxSellPrice) {
529       direction = Direction.Invalid;
530       mantissa = 0;
531       exponent = 0;
532       return;
533     } else if (sidedPriceIndex <= minBuyPrice) {
534       direction = Direction.Buy;
535       priceIndex = minBuyPrice - sidedPriceIndex;
536     } else {
537       direction = Direction.Sell;
538       priceIndex = sidedPriceIndex - minSellPrice;
539     }
540     uint zeroBasedMantissa = priceIndex % 900;
541     uint zeroBasedExponent = priceIndex / 900;
542     mantissa = uint16(zeroBasedMantissa + 100);
543     exponent = int8(zeroBasedExponent) + minPriceExponent;
544     return;
545   }
546   
547   // Internal Price Calculation - is a packed price on the buy side?
548   //
549   // Throws an error if price is invalid.
550   //
551   function isBuyPrice(uint16 price) internal constant returns (bool isBuy) {
552     // yes, this looks odd, but max here is highest _unpacked_ price
553     return price >= maxBuyPrice && price <= minBuyPrice;
554   }
555   
556   // Internal Price Calculation - turn a packed buy price into a packed sell price.
557   //
558   // Invalid price remains invalid.
559   //
560   function computeOppositePrice(uint16 price) internal constant returns (uint16 opposite) {
561     if (price < maxBuyPrice || price > maxSellPrice) {
562       return uint16(invalidPrice);
563     } else if (price <= minBuyPrice) {
564       return uint16(maxSellPrice - (price - maxBuyPrice));
565     } else {
566       return uint16(maxBuyPrice + (maxSellPrice - price));
567     }
568   }
569   
570   // Internal Price Calculation - compute amount in counter currency that would
571   // be obtained by selling baseAmount at the given unpacked price (if no fees).
572   //
573   // Notes:
574   //  - Does not validate price - caller must ensure valid.
575   //  - Could overflow producing very unexpected results if baseAmount very
576   //    large - caller must check this.
577   //  - This rounds the amount towards zero.
578   //  - May truncate to zero if baseAmount very small - potentially allowing
579   //    zero-cost buys or pointless sales - caller must check this.
580   //
581   function computeCntrAmountUsingUnpacked(
582       uint baseAmount, uint16 mantissa, int8 exponent
583     ) internal constant returns (uint cntrAmount) {
584     if (exponent < 0) {
585       return baseAmount * uint(mantissa) / 1000 / 10 ** uint(-exponent);
586     } else {
587       return baseAmount * uint(mantissa) / 1000 * 10 ** uint(exponent);
588     }
589   }
590 
591   // Internal Price Calculation - compute amount in counter currency that would
592   // be obtained by selling baseAmount at the given packed price (if no fees).
593   //
594   // Notes:
595   //  - Does not validate price - caller must ensure valid.
596   //  - Direction of the packed price is ignored.
597   //  - Could overflow producing very unexpected results if baseAmount very
598   //    large - caller must check this.
599   //  - This rounds the amount towards zero (regardless of Buy or Sell).
600   //  - May truncate to zero if baseAmount very small - potentially allowing
601   //    zero-cost buys or pointless sales - caller must check this.
602   //
603   function computeCntrAmountUsingPacked(
604       uint baseAmount, uint16 price
605     ) internal constant returns (uint) {
606     var (, mantissa, exponent) = unpackPrice(price);
607     return computeCntrAmountUsingUnpacked(baseAmount, mantissa, exponent);
608   }
609 
610   // Public Order Placement - create order and try to match it and/or add it to the book.
611   //
612   function createOrder(
613       uint128 orderId, uint16 price, uint sizeBase, Terms terms, uint maxMatches
614     ) public {
615     address client = msg.sender;
616     require(orderId != 0 && orderForOrderId[orderId].client == 0);
617     ClientOrderEvent(client, ClientOrderEventType.Create, orderId, maxMatches);
618     orderForOrderId[orderId] =
619       Order(client, price, sizeBase, terms, Status.Unknown, ReasonCode.None, 0, 0, 0, 0);
620     uint128 previousMostRecentOrderIdForClient = mostRecentOrderIdForClient[client];
621     mostRecentOrderIdForClient[client] = orderId;
622     clientPreviousOrderIdBeforeOrderId[orderId] = previousMostRecentOrderIdForClient;
623     Order storage order = orderForOrderId[orderId];
624     var (direction, mantissa, exponent) = unpackPrice(price);
625     if (direction == Direction.Invalid) {
626       order.status = Status.Rejected;
627       order.reasonCode = ReasonCode.InvalidPrice;
628       return;
629     }
630     if (sizeBase < baseMinInitialSize || sizeBase > baseMaxSize) {
631       order.status = Status.Rejected;
632       order.reasonCode = ReasonCode.InvalidSize;
633       return;
634     }
635     uint sizeCntr = computeCntrAmountUsingUnpacked(sizeBase, mantissa, exponent);
636     if (sizeCntr < cntrMinInitialSize || sizeCntr > cntrMaxSize) {
637       order.status = Status.Rejected;
638       order.reasonCode = ReasonCode.InvalidSize;
639       return;
640     }
641     if (terms == Terms.MakerOnly && maxMatches != 0) {
642       order.status = Status.Rejected;
643       order.reasonCode = ReasonCode.InvalidTerms;
644       return;
645     }
646     if (!debitFunds(client, direction, sizeBase, sizeCntr)) {
647       order.status = Status.Rejected;
648       order.reasonCode = ReasonCode.InsufficientFunds;
649       return;
650     }
651     processOrder(orderId, maxMatches);
652   }
653 
654   // Public Order Placement - cancel order
655   //
656   function cancelOrder(uint128 orderId) public {
657     address client = msg.sender;
658     Order storage order = orderForOrderId[orderId];
659     require(order.client == client);
660     Status status = order.status;
661     if (status != Status.Open && status != Status.NeedsGas) {
662       return;
663     }
664     ClientOrderEvent(client, ClientOrderEventType.Cancel, orderId, 0);
665     if (status == Status.Open) {
666       removeOpenOrderFromBook(orderId);
667       MarketOrderEvent(block.timestamp, orderId, MarketOrderEventType.Remove, order.price,
668         order.sizeBase - order.executedBase, 0);
669     }
670     refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.ClientCancel);
671   }
672 
673   // Public Order Placement - continue placing an order in 'NeedsGas' state
674   //
675   function continueOrder(uint128 orderId, uint maxMatches) public {
676     address client = msg.sender;
677     Order storage order = orderForOrderId[orderId];
678     require(order.client == client);
679     if (order.status != Status.NeedsGas) {
680       return;
681     }
682     ClientOrderEvent(client, ClientOrderEventType.Continue, orderId, maxMatches);
683     order.status = Status.Unknown;
684     processOrder(orderId, maxMatches);
685   }
686 
687   // Internal Order Placement - remove a still-open order from the book.
688   //
689   // Caller's job to update/refund the order + raise event, this just
690   // updates the order chain and bitmask.
691   //
692   // Too expensive to do on each resting order match - we only do this for an
693   // order being cancelled. See matchWithOccupiedPrice for similar logic.
694   //
695   function removeOpenOrderFromBook(uint128 orderId) internal {
696     Order storage order = orderForOrderId[orderId];
697     uint16 price = order.price;
698     OrderChain storage orderChain = orderChainForOccupiedPrice[price];
699     OrderChainNode storage orderChainNode = orderChainNodeForOpenOrderId[orderId];
700     uint128 nextOrderId = orderChainNode.nextOrderId;
701     uint128 prevOrderId = orderChainNode.prevOrderId;
702     if (nextOrderId != 0) {
703       OrderChainNode storage nextOrderChainNode = orderChainNodeForOpenOrderId[nextOrderId];
704       nextOrderChainNode.prevOrderId = prevOrderId;
705     } else {
706       orderChain.lastOrderId = prevOrderId;
707     }
708     if (prevOrderId != 0) {
709       OrderChainNode storage prevOrderChainNode = orderChainNodeForOpenOrderId[prevOrderId];
710       prevOrderChainNode.nextOrderId = nextOrderId;
711     } else {
712       orderChain.firstOrderId = nextOrderId;
713     }
714     if (nextOrderId == 0 && prevOrderId == 0) {
715       uint bmi = price / 256;  // index into array of bitmaps
716       uint bti = price % 256;  // bit position within bitmap
717       // we know was previously occupied so XOR clears
718       occupiedPriceBitmaps[bmi] ^= 2 ** bti;
719     }
720   }
721 
722   // Internal Order Placement - credit funds received when taking liquidity from book
723   //
724   function creditExecutedFundsLessFees(uint128 orderId, uint originalExecutedBase, uint originalExecutedCntr) internal {
725     Order storage order = orderForOrderId[orderId];
726     uint liquidityTakenBase = order.executedBase - originalExecutedBase;
727     uint liquidityTakenCntr = order.executedCntr - originalExecutedCntr;
728     // Normally we deduct the fee from the currency bought (base for buy, cntr for sell),
729     // however we also accept reward tokens from the reward balance if it covers the fee,
730     // with the reward amount converted from the ETH amount (the counter currency here)
731     // at a fixed exchange rate.
732     // Overflow safe since we ensure order size < 10^30 in both currencies (see baseMaxSize).
733     // Can truncate to zero, which is fine.
734     uint feesRwrd = liquidityTakenCntr / feeDivisor * ethRwrdRate;
735     uint feesBaseOrCntr;
736     address client = order.client;
737     uint availRwrd = balanceRwrdForClient[client];
738     if (feesRwrd <= availRwrd) {
739       balanceRwrdForClient[client] = availRwrd - feesRwrd;
740       balanceRwrdForClient[feeCollector] = feesRwrd;
741       // Need += rather than = because could have paid some fees earlier in NeedsGas situation.
742       // Overflow safe since we ensure order size < 10^30 in both currencies (see baseMaxSize).
743       // Can truncate to zero, which is fine.
744       order.feesRwrd += uint128(feesRwrd);
745       if (isBuyPrice(order.price)) {
746         balanceBaseForClient[client] += liquidityTakenBase;
747       } else {
748         balanceCntrForClient[client] += liquidityTakenCntr;
749       }
750     } else if (isBuyPrice(order.price)) {
751       // See comments in branch above re: use of += and overflow safety.
752       feesBaseOrCntr = liquidityTakenBase / feeDivisor;
753       balanceBaseForClient[order.client] += (liquidityTakenBase - feesBaseOrCntr);
754       order.feesBaseOrCntr += uint128(feesBaseOrCntr);
755       balanceBaseForClient[feeCollector] += feesBaseOrCntr;
756     } else {
757       // See comments in branch above re: use of += and overflow safety.
758       feesBaseOrCntr = liquidityTakenCntr / feeDivisor;
759       balanceCntrForClient[order.client] += (liquidityTakenCntr - feesBaseOrCntr);
760       order.feesBaseOrCntr += uint128(feesBaseOrCntr);
761       balanceCntrForClient[feeCollector] += feesBaseOrCntr;
762     }
763   }
764 
765   // Internal Order Placement - process a created and sanity checked order.
766   //
767   // Used both for new orders and for gas topup.
768   //
769   function processOrder(uint128 orderId, uint maxMatches) internal {
770     Order storage order = orderForOrderId[orderId];
771 
772     uint ourOriginalExecutedBase = order.executedBase;
773     uint ourOriginalExecutedCntr = order.executedCntr;
774 
775     var (ourDirection,) = unpackPrice(order.price);
776     uint theirPriceStart = (ourDirection == Direction.Buy) ? minSellPrice : maxBuyPrice;
777     uint theirPriceEnd = computeOppositePrice(order.price);
778    
779     MatchStopReason matchStopReason =
780       matchAgainstBook(orderId, theirPriceStart, theirPriceEnd, maxMatches);
781 
782     creditExecutedFundsLessFees(orderId, ourOriginalExecutedBase, ourOriginalExecutedCntr);
783 
784     if (order.terms == Terms.ImmediateOrCancel) {
785       if (matchStopReason == MatchStopReason.Satisfied) {
786         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
787         return;
788       } else if (matchStopReason == MatchStopReason.MaxMatches) {
789         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.TooManyMatches);
790         return;
791       } else if (matchStopReason == MatchStopReason.BookExhausted) {
792         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.Unmatched);
793         return;
794       }
795     } else if (order.terms == Terms.MakerOnly) {
796       if (matchStopReason == MatchStopReason.MaxMatches) {
797         refundUnmatchedAndFinish(orderId, Status.Rejected, ReasonCode.WouldTake);
798         return;
799       } else if (matchStopReason == MatchStopReason.BookExhausted) {
800         enterOrder(orderId);
801         return;
802       }
803     } else if (order.terms == Terms.GTCNoGasTopup) {
804       if (matchStopReason == MatchStopReason.Satisfied) {
805         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
806         return;
807       } else if (matchStopReason == MatchStopReason.MaxMatches) {
808         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.TooManyMatches);
809         return;
810       } else if (matchStopReason == MatchStopReason.BookExhausted) {
811         enterOrder(orderId);
812         return;
813       }
814     } else if (order.terms == Terms.GTCWithGasTopup) {
815       if (matchStopReason == MatchStopReason.Satisfied) {
816         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
817         return;
818       } else if (matchStopReason == MatchStopReason.MaxMatches) {
819         order.status = Status.NeedsGas;
820         return;
821       } else if (matchStopReason == MatchStopReason.BookExhausted) {
822         enterOrder(orderId);
823         return;
824       }
825     }
826     assert(false); // should not be possible to reach here
827   }
828  
829   // Used internally to indicate why we stopped matching an order against the book.
830 
831   enum MatchStopReason {
832     None,
833     MaxMatches,
834     Satisfied,
835     PriceExhausted,
836     BookExhausted
837   }
838  
839   // Internal Order Placement - Match the given order against the book.
840   //
841   // Resting orders matched will be updated, removed from book and funds credited to their owners.
842   //
843   // Only updates the executedBase and executedCntr of the given order - caller is responsible
844   // for crediting matched funds, charging fees, marking order as done / entering it into the book.
845   //
846   // matchStopReason returned will be one of MaxMatches, Satisfied or BookExhausted.
847   //
848   // Calling with maxMatches == 0 is ok - and expected when the order is a maker-only order.
849   //
850   function matchAgainstBook(
851       uint128 orderId, uint theirPriceStart, uint theirPriceEnd, uint maxMatches
852     ) internal returns (
853       MatchStopReason matchStopReason
854     ) {
855     Order storage order = orderForOrderId[orderId];
856     
857     uint bmi = theirPriceStart / 256;  // index into array of bitmaps
858     uint bti = theirPriceStart % 256;  // bit position within bitmap
859     uint bmiEnd = theirPriceEnd / 256; // last bitmap to search
860     uint btiEnd = theirPriceEnd % 256; // stop at this bit in the last bitmap
861 
862     uint cbm = occupiedPriceBitmaps[bmi]; // original copy of current bitmap
863     uint dbm = cbm; // dirty version of current bitmap where we may have cleared bits
864     uint wbm = cbm >> bti; // working copy of current bitmap which we keep shifting
865     
866     // these loops are pretty ugly, and somewhat unpredicatable in terms of gas,
867     // ... but no-one else has come up with a better matching engine yet!
868 
869     bool removedLastAtPrice;
870     matchStopReason = MatchStopReason.None;
871 
872     while (bmi < bmiEnd) {
873       if (wbm == 0 || bti == 256) {
874         if (dbm != cbm) {
875           occupiedPriceBitmaps[bmi] = dbm;
876         }
877         bti = 0;
878         bmi++;
879         cbm = occupiedPriceBitmaps[bmi];
880         wbm = cbm;
881         dbm = cbm;
882       } else {
883         if ((wbm & 1) != 0) {
884           // careful - copy-and-pasted in loop below ...
885           (removedLastAtPrice, maxMatches, matchStopReason) =
886             matchWithOccupiedPrice(order, uint16(bmi * 256 + bti), maxMatches);
887           if (removedLastAtPrice) {
888             dbm ^= 2 ** bti;
889           }
890           if (matchStopReason == MatchStopReason.PriceExhausted) {
891             matchStopReason = MatchStopReason.None;
892           } else if (matchStopReason != MatchStopReason.None) {
893             // we might still have changes in dbm to write back - see later
894             break;
895           }
896         }
897         bti += 1;
898         wbm /= 2;
899       }
900     }
901     if (matchStopReason == MatchStopReason.None) {
902       // we've reached the last bitmap we need to search,
903       // we'll stop at btiEnd not 256 this time.
904       while (bti <= btiEnd && wbm != 0) {
905         if ((wbm & 1) != 0) {
906           // careful - copy-and-pasted in loop above ...
907           (removedLastAtPrice, maxMatches, matchStopReason) =
908             matchWithOccupiedPrice(order, uint16(bmi * 256 + bti), maxMatches);
909           if (removedLastAtPrice) {
910             dbm ^= 2 ** bti;
911           }
912           if (matchStopReason == MatchStopReason.PriceExhausted) {
913             matchStopReason = MatchStopReason.None;
914           } else if (matchStopReason != MatchStopReason.None) {
915             break;
916           }
917         }
918         bti += 1;
919         wbm /= 2;
920       }
921     }
922     // Careful - if we exited the first loop early, or we went into the second loop,
923     // (luckily can't both happen) then we haven't flushed the dirty bitmap back to
924     // storage - do that now if we need to.
925     if (dbm != cbm) {
926       occupiedPriceBitmaps[bmi] = dbm;
927     }
928     if (matchStopReason == MatchStopReason.None) {
929       matchStopReason = MatchStopReason.BookExhausted;
930     }
931   }
932 
933   // Internal Order Placement.
934   //
935   // Match our order against up to maxMatches resting orders at the given price (which
936   // is known by the caller to have at least one resting order).
937   //
938   // The matches (partial or complete) of the resting orders are recorded, and their
939   // funds are credited.
940   //
941   // The order chain for the resting orders is updated, but the occupied price bitmap is NOT -
942   // the caller must clear the relevant bit if removedLastAtPrice = true is returned.
943   //
944   // Only updates the executedBase and executedCntr of our order - caller is responsible
945   // for e.g. crediting our matched funds, updating status.
946   //
947   // Calling with maxMatches == 0 is ok - and expected when the order is a maker-only order.
948   //
949   // Returns:
950   //   removedLastAtPrice:
951   //     true iff there are no longer any resting orders at this price - caller will need
952   //     to update the occupied price bitmap.
953   //
954   //   matchesLeft:
955   //     maxMatches passed in minus the number of matches made by this call
956   //
957   //   matchStopReason:
958   //     If our order is completely matched, matchStopReason will be Satisfied.
959   //     If our order is not completely matched, matchStopReason will be either:
960   //        MaxMatches (we are not allowed to match any more times)
961   //     or:
962   //        PriceExhausted (nothing left on the book at this exact price)
963   //
964   function matchWithOccupiedPrice(
965       Order storage ourOrder, uint16 theirPrice, uint maxMatches
966     ) internal returns (
967     bool removedLastAtPrice, uint matchesLeft, MatchStopReason matchStopReason) {
968     matchesLeft = maxMatches;
969     uint workingOurExecutedBase = ourOrder.executedBase;
970     uint workingOurExecutedCntr = ourOrder.executedCntr;
971     uint128 theirOrderId = orderChainForOccupiedPrice[theirPrice].firstOrderId;
972     matchStopReason = MatchStopReason.None;
973     while (true) {
974       if (matchesLeft == 0) {
975         matchStopReason = MatchStopReason.MaxMatches;
976         break;
977       }
978       uint matchBase;
979       uint matchCntr;
980       (theirOrderId, matchBase, matchCntr, matchStopReason) =
981         matchWithTheirs((ourOrder.sizeBase - workingOurExecutedBase), theirOrderId, theirPrice);
982       workingOurExecutedBase += matchBase;
983       workingOurExecutedCntr += matchCntr;
984       matchesLeft -= 1;
985       if (matchStopReason != MatchStopReason.None) {
986         break;
987       }
988     }
989     ourOrder.executedBase = uint128(workingOurExecutedBase);
990     ourOrder.executedCntr = uint128(workingOurExecutedCntr);
991     if (theirOrderId == 0) {
992       orderChainForOccupiedPrice[theirPrice].firstOrderId = 0;
993       orderChainForOccupiedPrice[theirPrice].lastOrderId = 0;
994       removedLastAtPrice = true;
995     } else {
996       // NB: in some cases (e.g. maxMatches == 0) this is a no-op.
997       orderChainForOccupiedPrice[theirPrice].firstOrderId = theirOrderId;
998       orderChainNodeForOpenOrderId[theirOrderId].prevOrderId = 0;
999       removedLastAtPrice = false;
1000     }
1001   }
1002   
1003   // Internal Order Placement.
1004   //
1005   // Match up to our remaining amount against a resting order in the book.
1006   //
1007   // The match (partial, complete or effectively-complete) of the resting order
1008   // is recorded, and their funds are credited.
1009   //
1010   // Their order is NOT removed from the book by this call - the caller must do that
1011   // if the nextTheirOrderId returned is not equal to the theirOrderId passed in.
1012   //
1013   // Returns:
1014   //
1015   //   nextTheirOrderId:
1016   //     If we did not completely match their order, will be same as theirOrderId.
1017   //     If we completely matched their order, will be orderId of next order at the
1018   //     same price - or zero if this was the last order and we've now filled it.
1019   //
1020   //   matchStopReason:
1021   //     If our order is completely matched, matchStopReason will be Satisfied.
1022   //     If our order is not completely matched, matchStopReason will be either
1023   //     PriceExhausted (if nothing left at this exact price) or None (if can continue).
1024   // 
1025   function matchWithTheirs(
1026     uint ourRemainingBase, uint128 theirOrderId, uint16 theirPrice) internal returns (
1027     uint128 nextTheirOrderId, uint matchBase, uint matchCntr, MatchStopReason matchStopReason) {
1028     Order storage theirOrder = orderForOrderId[theirOrderId];
1029     uint theirRemainingBase = theirOrder.sizeBase - theirOrder.executedBase;
1030     if (ourRemainingBase < theirRemainingBase) {
1031       matchBase = ourRemainingBase;
1032     } else {
1033       matchBase = theirRemainingBase;
1034     }
1035     matchCntr = computeCntrAmountUsingPacked(matchBase, theirPrice);
1036     // It may seem a bit odd to stop here if our remaining amount is very small -
1037     // there could still be resting orders we can match it against. But the gas
1038     // cost of matching each order is quite high - potentially high enough to
1039     // wipe out the profit the taker hopes for from trading the tiny amount left.
1040     if ((ourRemainingBase - matchBase) < baseMinRemainingSize) {
1041       matchStopReason = MatchStopReason.Satisfied;
1042     } else {
1043       matchStopReason = MatchStopReason.None;
1044     }
1045     bool theirsDead = recordTheirMatch(theirOrder, theirOrderId, theirPrice, matchBase, matchCntr);
1046     if (theirsDead) {
1047       nextTheirOrderId = orderChainNodeForOpenOrderId[theirOrderId].nextOrderId;
1048       if (matchStopReason == MatchStopReason.None && nextTheirOrderId == 0) {
1049         matchStopReason = MatchStopReason.PriceExhausted;
1050       }
1051     } else {
1052       nextTheirOrderId = theirOrderId;
1053     }
1054   }
1055 
1056   // Internal Order Placement.
1057   //
1058   // Record match (partial or complete) of resting order, and credit them their funds.
1059   //
1060   // If their order is completely matched, the order is marked as done,
1061   // and "theirsDead" is returned as true.
1062   //
1063   // The order is NOT removed from the book by this call - the caller
1064   // must do that if theirsDead is true.
1065   //
1066   // No sanity checks are made - the caller must be sure the order is
1067   // not already done and has sufficient remaining. (Yes, we'd like to
1068   // check here too but we cannot afford the gas).
1069   //
1070   function recordTheirMatch(
1071       Order storage theirOrder, uint128 theirOrderId, uint16 theirPrice, uint matchBase, uint matchCntr
1072     ) internal returns (bool theirsDead) {
1073     // they are a maker so no fees
1074     // overflow safe - see comments about baseMaxSize
1075     // executedBase cannot go > sizeBase due to logic in matchWithTheirs
1076     theirOrder.executedBase += uint128(matchBase);
1077     theirOrder.executedCntr += uint128(matchCntr);
1078     if (isBuyPrice(theirPrice)) {
1079       // they have bought base (using the counter they already paid when creating the order)
1080       balanceBaseForClient[theirOrder.client] += matchBase;
1081     } else {
1082       // they have bought counter (using the base they already paid when creating the order)
1083       balanceCntrForClient[theirOrder.client] += matchCntr;
1084     }
1085     uint stillRemainingBase = theirOrder.sizeBase - theirOrder.executedBase;
1086     // avoid leaving tiny amounts in the book - refund remaining if too small
1087     if (stillRemainingBase < baseMinRemainingSize) {
1088       refundUnmatchedAndFinish(theirOrderId, Status.Done, ReasonCode.None);
1089       // someone building an UI on top needs to know how much was match and how much was refund
1090       MarketOrderEvent(block.timestamp, theirOrderId, MarketOrderEventType.CompleteFill,
1091         theirPrice, matchBase + stillRemainingBase, matchBase);
1092       return true;
1093     } else {
1094       MarketOrderEvent(block.timestamp, theirOrderId, MarketOrderEventType.PartialFill,
1095         theirPrice, matchBase, matchBase);
1096       return false;
1097     }
1098   }
1099 
1100   // Internal Order Placement.
1101   //
1102   // Refund any unmatched funds in an order (based on executed vs size) and move to a final state.
1103   //
1104   // The order is NOT removed from the book by this call and no event is raised.
1105   //
1106   // No sanity checks are made - the caller must be sure the order has not already been refunded.
1107   //
1108   function refundUnmatchedAndFinish(uint128 orderId, Status status, ReasonCode reasonCode) internal {
1109     Order storage order = orderForOrderId[orderId];
1110     uint16 price = order.price;
1111     if (isBuyPrice(price)) {
1112       uint sizeCntr = computeCntrAmountUsingPacked(order.sizeBase, price);
1113       balanceCntrForClient[order.client] += sizeCntr - order.executedCntr;
1114     } else {
1115       balanceBaseForClient[order.client] += order.sizeBase - order.executedBase;
1116     }
1117     order.status = status;
1118     order.reasonCode = reasonCode;
1119   }
1120 
1121   // Internal Order Placement.
1122   //
1123   // Enter a not completely matched order into the book, marking the order as open.
1124   //
1125   // This updates the occupied price bitmap and chain.
1126   //
1127   // No sanity checks are made - the caller must be sure the order
1128   // has some unmatched amount and has been paid for!
1129   //
1130   function enterOrder(uint128 orderId) internal {
1131     Order storage order = orderForOrderId[orderId];
1132     uint16 price = order.price;
1133     OrderChain storage orderChain = orderChainForOccupiedPrice[price];
1134     OrderChainNode storage orderChainNode = orderChainNodeForOpenOrderId[orderId];
1135     if (orderChain.firstOrderId == 0) {
1136       orderChain.firstOrderId = orderId;
1137       orderChain.lastOrderId = orderId;
1138       orderChainNode.nextOrderId = 0;
1139       orderChainNode.prevOrderId = 0;
1140       uint bitmapIndex = price / 256;
1141       uint bitIndex = price % 256;
1142       occupiedPriceBitmaps[bitmapIndex] |= (2 ** bitIndex);
1143     } else {
1144       uint128 existingLastOrderId = orderChain.lastOrderId;
1145       OrderChainNode storage existingLastOrderChainNode = orderChainNodeForOpenOrderId[existingLastOrderId];
1146       orderChainNode.nextOrderId = 0;
1147       orderChainNode.prevOrderId = existingLastOrderId;
1148       existingLastOrderChainNode.nextOrderId = orderId;
1149       orderChain.lastOrderId = orderId;
1150     }
1151     MarketOrderEvent(block.timestamp, orderId, MarketOrderEventType.Add,
1152       price, order.sizeBase - order.executedBase, 0);
1153     order.status = Status.Open;
1154   }
1155 
1156   // Internal Order Placement.
1157   //
1158   // Charge the client for the cost of placing an order in the given direction.
1159   //
1160   // Return true if successful, false otherwise.
1161   //
1162   function debitFunds(
1163       address client, Direction direction, uint sizeBase, uint sizeCntr
1164     ) internal returns (bool success) {
1165     if (direction == Direction.Buy) {
1166       uint availableCntr = balanceCntrForClient[client];
1167       if (availableCntr < sizeCntr) {
1168         return false;
1169       }
1170       balanceCntrForClient[client] = availableCntr - sizeCntr;
1171       return true;
1172     } else if (direction == Direction.Sell) {
1173       uint availableBase = balanceBaseForClient[client];
1174       if (availableBase < sizeBase) {
1175         return false;
1176       }
1177       balanceBaseForClient[client] = availableBase - sizeBase;
1178       return true;
1179     } else {
1180       return false;
1181     }
1182   }
1183 
1184   // Public Book View
1185   // 
1186   // Intended for public book depth enumeration from web3 (or similar).
1187   //
1188   // Not suitable for use from a smart contract transaction - gas usage
1189   // could be very high if we have many orders at the same price.
1190   //
1191   // Start at the given inclusive price (and side) and walk down the book
1192   // (getting less aggressive) until we find some open orders or reach the
1193   // least aggressive price.
1194   //
1195   // Returns the price where we found the order(s), the depth at that price
1196   // (zero if none found), order count there, and the current blockNumber.
1197   //
1198   // (The blockNumber is handy if you're taking a snapshot which you intend
1199   //  to keep up-to-date with the market order events).
1200   //
1201   // To walk the book, the caller should start by calling walkBook with the
1202   // most aggressive buy price (Buy @ 999000).
1203   // If the price returned is the least aggressive buy price (Buy @ 0.000001),
1204   // the side is complete.
1205   // Otherwise, call walkBook again with the (packed) price returned + 1.
1206   // Then repeat for the sell side, starting with Sell @ 0.000001 and stopping
1207   // when Sell @ 999000 is returned.
1208   //
1209   function walkBook(uint16 fromPrice) public constant returns (
1210       uint16 price, uint depthBase, uint orderCount, uint blockNumber
1211     ) {
1212     uint priceStart = fromPrice;
1213     uint priceEnd = (isBuyPrice(fromPrice)) ? minBuyPrice : maxSellPrice;
1214     
1215     // See comments in matchAgainstBook re: how these crazy loops work.
1216     
1217     uint bmi = priceStart / 256;
1218     uint bti = priceStart % 256;
1219     uint bmiEnd = priceEnd / 256;
1220     uint btiEnd = priceEnd % 256;
1221 
1222     uint wbm = occupiedPriceBitmaps[bmi] >> bti;
1223     
1224     while (bmi < bmiEnd) {
1225       if (wbm == 0 || bti == 256) {
1226         bti = 0;
1227         bmi++;
1228         wbm = occupiedPriceBitmaps[bmi];
1229       } else {
1230         if ((wbm & 1) != 0) {
1231           // careful - copy-pasted in below loop
1232           price = uint16(bmi * 256 + bti);
1233           (depthBase, orderCount) = sumDepth(orderChainForOccupiedPrice[price].firstOrderId);
1234           return (price, depthBase, orderCount, block.number);
1235         }
1236         bti += 1;
1237         wbm /= 2;
1238       }
1239     }
1240     // we've reached the last bitmap we need to search, stop at btiEnd not 256 this time.
1241     while (bti <= btiEnd && wbm != 0) {
1242       if ((wbm & 1) != 0) {
1243         // careful - copy-pasted in above loop
1244         price = uint16(bmi * 256 + bti);
1245         (depthBase, orderCount) = sumDepth(orderChainForOccupiedPrice[price].firstOrderId);
1246         return (price, depthBase, orderCount, block.number);
1247       }
1248       bti += 1;
1249       wbm /= 2;
1250     }
1251     return (uint16(priceEnd), 0, 0, block.number);
1252   }
1253 
1254   // Internal Book View.
1255   //
1256   // See walkBook - adds up open depth at a price starting from an
1257   // order which is assumed to be open. Careful - unlimited gas use.
1258   //
1259   function sumDepth(uint128 orderId) internal constant returns (uint depth, uint orderCount) {
1260     while (true) {
1261       Order storage order = orderForOrderId[orderId];
1262       depth += order.sizeBase - order.executedBase;
1263       orderCount++;
1264       orderId = orderChainNodeForOpenOrderId[orderId].nextOrderId;
1265       if (orderId == 0) {
1266         return (depth, orderCount);
1267       }
1268     }
1269   }
1270 }