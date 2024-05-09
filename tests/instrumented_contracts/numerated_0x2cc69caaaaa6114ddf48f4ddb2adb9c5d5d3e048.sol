1 pragma solidity ^0.4.24;
2 
3 // Amis Dex OnChainOrderBook follows ERC20 Standards
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
15 // Amis Dex on-chain order book matching engine Version 0.1.2.
16 // https://github.com/amisolution/ERC20-AMIS/contracts/OnChainOrderBookV012b.sol
17 // This smart contract is a variation of a neat ERC20 token as base, ETH as quoted, 
18 // and standard fees with incentivized reward token.
19 // This contract allows minPriceExponent, baseMinInitialSize, and baseMinRemainingSize
20 // to be set at init() time appropriately for the token decimals and likely value.
21 //
22 contract OnChainOrderBookV012b {
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
40     Sending,    // not used by contract - web UI only
41     FailedSend, // not used by contract - web UI only
42     FailedTxn   // not used by contract - web UI only
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
77     uint128 executedCntr;      // gross amount executed in quoted currency (before fee deduction)
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
92   // Rebuild the expected state of the contract given:
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
154   // the base token (e.g. AMIS)
155   
156   ERC20 baseToken;
157 
158   // minimum order size (inclusive)
159   uint baseMinInitialSize; // set at init
160 
161   // if following partial match, the remaining gets smaller than this, remove from Order Book and refund:
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
173   // the counter currency or ETH traded pair
174   // (no address because it is ETH)
175 
176   // avoid the book getting cluttered up with tiny amounts not worth the gas
177   uint constant cntrMinInitialSize = 10 finney;
178 
179   // see comments for baseMaxSize
180   uint constant cntrMaxSize = 10 ** 30;
181 
182   // the reward token that can be used to pay fees (AMIS / ORA / CRSW)
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
270   function OnChainOrderBookV012b() {
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
374   // Public Funds moves - deposit previously-approved base tokens.
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
391   // Public Funds moves - withdraw base tokens (as a transfer).
392   //
393   function transferBase(uint amountBase) public {
394     address client = msg.sender;
395     require(amountBase > 0);
396     require(amountBase <= balanceBaseForClient[client]);
397     // overflow safe since we checked less than balance above
398     balanceBaseForClient[client] -= amountBase;
399     // we trust the ERC20 token contract not to do nasty things like call back into us -
400     require(baseToken.transfer(client, amountBase));
401     ClientPaymentEvent(client, ClientPaymentEventType.Transfer, BalanceType.Base, -int(amountBase));
402   }
403 
404   // Public Funds moves - deposit counter quoted currency (ETH or DAI).
405   //
406   function depositCntr() public payable {
407     address client = msg.sender;
408     uint amountCntr = msg.value;
409     require(amountCntr > 0);
410     // overflow safe - if someone owns pow(2,255) ETH we have bigger problems
411     balanceCntrForClient[client] += amountCntr;
412     ClientPaymentEvent(client, ClientPaymentEventType.Deposit, BalanceType.Cntr, int(amountCntr));
413   }
414 
415   // Public Funds Move - withdraw counter quoted currency (ETH or DAI).
416   //
417   function withdrawCntr(uint amountCntr) public {
418     address client = msg.sender;
419     require(amountCntr > 0);
420     require(amountCntr <= balanceCntrForClient[client]);
421     // overflow safe - checked less than balance above
422     balanceCntrForClient[client] -= amountCntr;
423     // safe - not enough gas to do anything interesting in fallback, already adjusted balance
424     client.transfer(amountCntr);
425     ClientPaymentEvent(client, ClientPaymentEventType.Withdraw, BalanceType.Cntr, -int(amountCntr));
426   }
427 
428   // Public Funds Move - deposit previously-approved incentivized reward tokens.
429   //
430   function transferFromRwrd() public {
431     address client = msg.sender;
432     address book = address(this);
433     uint amountRwrd = rwrdToken.allowance(client, book);
434     require(amountRwrd > 0);
435     // we created the incentivized reward token so we know it supports ERC20 properly and is not evil
436     require(rwrdToken.transferFrom(client, book, amountRwrd));
437     // belt and braces
438     assert(rwrdToken.allowance(client, book) == 0);
439     balanceRwrdForClient[client] += amountRwrd;
440     ClientPaymentEvent(client, ClientPaymentEventType.TransferFrom, BalanceType.Rwrd, int(amountRwrd));
441   }
442 
443   // Public Funds Manipulation - withdraw base tokens (as a transfer).
444   //
445   function transferRwrd(uint amountRwrd) public {
446     address client = msg.sender;
447     require(amountRwrd > 0);
448     require(amountRwrd <= balanceRwrdForClient[client]);
449     // overflow safe - checked less than balance above
450     balanceRwrdForClient[client] -= amountRwrd;
451     // we created the incentivized reward token so we know it supports ERC20 properly and is not evil
452     require(rwrdToken.transfer(client, amountRwrd));
453     ClientPaymentEvent(client, ClientPaymentEventType.Transfer, BalanceType.Rwrd, -int(amountRwrd));
454   }
455 
456   // Public Order View - get full details of an order.
457   //
458   // If the orderId does not exist, status will be Unknown.
459   //
460   function getOrder(uint128 orderId) public constant returns (
461     address client, uint16 price, uint sizeBase, Terms terms,
462     Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
463     uint feesBaseOrCntr, uint feesRwrd) {
464     Order storage order = orderForOrderId[orderId];
465     return (order.client, order.price, order.sizeBase, order.terms,
466             order.status, order.reasonCode, order.executedBase, order.executedCntr,
467             order.feesBaseOrCntr, order.feesRwrd);
468   }
469 
470   // Public Order View - get mutable details of an order.
471   //
472   // If the orderId does not exist, status will be Unknown.
473   //
474   function getOrderState(uint128 orderId) public constant returns (
475     Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
476     uint feesBaseOrCntr, uint feesRwrd) {
477     Order storage order = orderForOrderId[orderId];
478     return (order.status, order.reasonCode, order.executedBase, order.executedCntr,
479             order.feesBaseOrCntr, order.feesRwrd);
480   }
481   
482   // Public Order View - enumerate all recent orders + all open orders for one client.
483   //
484   // Not really designed for use from a smart contract transaction.
485   // Baseline concept:
486   //  - client ensures order ids are generated so that most-signficant part is time-based;
487   //  - client decides they want all orders after a certain point-in-time,
488   //    and chooses minClosedOrderIdCutoff accordingly;
489   //  - before that point-in-time they just get open and needs gas orders
490   //  - client calls walkClientOrders with maybeLastOrderIdReturned = 0 initially;
491   //  - then repeats with the orderId returned by walkClientOrders;
492   //  - (and stops if it returns a zero orderId);
493   //
494   // Note that client is only used when maybeLastOrderIdReturned = 0.
495   //
496   function walkClientOrders(
497       address client, uint128 maybeLastOrderIdReturned, uint128 minClosedOrderIdCutoff
498     ) public constant returns (
499       uint128 orderId, uint16 price, uint sizeBase, Terms terms,
500       Status status, ReasonCode reasonCode, uint executedBase, uint executedCntr,
501       uint feesBaseOrCntr, uint feesRwrd) {
502     if (maybeLastOrderIdReturned == 0) {
503       orderId = mostRecentOrderIdForClient[client];
504     } else {
505       orderId = clientPreviousOrderIdBeforeOrderId[maybeLastOrderIdReturned];
506     }
507     while (true) {
508       if (orderId == 0) return;
509       Order storage order = orderForOrderId[orderId];
510       if (orderId >= minClosedOrderIdCutoff) break;
511       if (order.status == Status.Open || order.status == Status.NeedsGas) break;
512       orderId = clientPreviousOrderIdBeforeOrderId[orderId];
513     }
514     return (orderId, order.price, order.sizeBase, order.terms,
515             order.status, order.reasonCode, order.executedBase, order.executedCntr,
516             order.feesBaseOrCntr, order.feesRwrd);
517   }
518  
519   // Internal Price Calculation - turn packed price into a friendlier unpacked price.
520   //
521   function unpackPrice(uint16 price) internal constant returns (
522       Direction direction, uint16 mantissa, int8 exponent
523     ) {
524     uint sidedPriceIndex = uint(price);
525     uint priceIndex;
526     if (sidedPriceIndex < 1 || sidedPriceIndex > maxSellPrice) {
527       direction = Direction.Invalid;
528       mantissa = 0;
529       exponent = 0;
530       return;
531     } else if (sidedPriceIndex <= minBuyPrice) {
532       direction = Direction.Buy;
533       priceIndex = minBuyPrice - sidedPriceIndex;
534     } else {
535       direction = Direction.Sell;
536       priceIndex = sidedPriceIndex - minSellPrice;
537     }
538     uint zeroBasedMantissa = priceIndex % 900;
539     uint zeroBasedExponent = priceIndex / 900;
540     mantissa = uint16(zeroBasedMantissa + 100);
541     exponent = int8(zeroBasedExponent) + minPriceExponent;
542     return;
543   }
544   
545   // Internal Price Calculation - is a packed price on the buy side?
546   //
547   // Throws an error if price is invalid.
548   //
549   function isBuyPrice(uint16 price) internal constant returns (bool isBuy) {
550     // yes, this looks odd, but max here is highest _unpacked_ price
551     return price >= maxBuyPrice && price <= minBuyPrice;
552   }
553   
554   // Internal Price Calculation - turn a packed buy price into a packed sell price.
555   //
556   // Invalid price remains invalid.
557   //
558   function computeOppositePrice(uint16 price) internal constant returns (uint16 opposite) {
559     if (price < maxBuyPrice || price > maxSellPrice) {
560       return uint16(invalidPrice);
561     } else if (price <= minBuyPrice) {
562       return uint16(maxSellPrice - (price - maxBuyPrice));
563     } else {
564       return uint16(maxBuyPrice + (maxSellPrice - price));
565     }
566   }
567   
568   // Internal Price Calculation - compute amount in counter currency that would
569   // be obtained by selling baseAmount at the given unpacked price (if no fees).
570   //
571   // Notes:
572   //  - Does not validate price - caller must ensure valid.
573   //  - Could overflow producing very unexpected results if baseAmount very
574   //    large - caller must check this.
575   //  - This rounds the amount towards zero.
576   //  - May truncate to zero if baseAmount very small - potentially allowing
577   //    zero-cost buys or pointless sales - caller must check this.
578   //
579   function computeCntrAmountUsingUnpacked(
580       uint baseAmount, uint16 mantissa, int8 exponent
581     ) internal constant returns (uint cntrAmount) {
582     if (exponent < 0) {
583       return baseAmount * uint(mantissa) / 1000 / 10 ** uint(-exponent);
584     } else {
585       return baseAmount * uint(mantissa) / 1000 * 10 ** uint(exponent);
586     }
587   }
588 
589   // Internal Price Calculation - compute amount in counter currency that would
590   // be obtained by selling baseAmount at the given packed price (if no fees).
591   //
592   // Notes:
593   //  - Does not validate price - caller must ensure valid.
594   //  - Direction of the packed price is ignored.
595   //  - Could overflow producing very unexpected results if baseAmount very
596   //    large - caller must check this.
597   //  - This rounds the amount towards zero (regardless of Buy or Sell).
598   //  - May truncate to zero if baseAmount very small - potentially allowing
599   //    zero-cost buys or pointless sales - caller must check this.
600   //
601   function computeCntrAmountUsingPacked(
602       uint baseAmount, uint16 price
603     ) internal constant returns (uint) {
604     var (, mantissa, exponent) = unpackPrice(price);
605     return computeCntrAmountUsingUnpacked(baseAmount, mantissa, exponent);
606   }
607 
608   // Public Order Placement - create order and try to match it and/or add it to the book.
609   //
610   function createOrder(
611       uint128 orderId, uint16 price, uint sizeBase, Terms terms, uint maxMatches
612     ) public {
613     address client = msg.sender;
614     require(orderId != 0 && orderForOrderId[orderId].client == 0);
615     ClientOrderEvent(client, ClientOrderEventType.Create, orderId, maxMatches);
616     orderForOrderId[orderId] =
617       Order(client, price, sizeBase, terms, Status.Unknown, ReasonCode.None, 0, 0, 0, 0);
618     uint128 previousMostRecentOrderIdForClient = mostRecentOrderIdForClient[client];
619     mostRecentOrderIdForClient[client] = orderId;
620     clientPreviousOrderIdBeforeOrderId[orderId] = previousMostRecentOrderIdForClient;
621     Order storage order = orderForOrderId[orderId];
622     var (direction, mantissa, exponent) = unpackPrice(price);
623     if (direction == Direction.Invalid) {
624       order.status = Status.Rejected;
625       order.reasonCode = ReasonCode.InvalidPrice;
626       return;
627     }
628     if (sizeBase < baseMinInitialSize || sizeBase > baseMaxSize) {
629       order.status = Status.Rejected;
630       order.reasonCode = ReasonCode.InvalidSize;
631       return;
632     }
633     uint sizeCntr = computeCntrAmountUsingUnpacked(sizeBase, mantissa, exponent);
634     if (sizeCntr < cntrMinInitialSize || sizeCntr > cntrMaxSize) {
635       order.status = Status.Rejected;
636       order.reasonCode = ReasonCode.InvalidSize;
637       return;
638     }
639     if (terms == Terms.MakerOnly && maxMatches != 0) {
640       order.status = Status.Rejected;
641       order.reasonCode = ReasonCode.InvalidTerms;
642       return;
643     }
644     if (!debitFunds(client, direction, sizeBase, sizeCntr)) {
645       order.status = Status.Rejected;
646       order.reasonCode = ReasonCode.InsufficientFunds;
647       return;
648     }
649     processOrder(orderId, maxMatches);
650   }
651 
652   // Public Order Placement - cancel order
653   //
654   function cancelOrder(uint128 orderId) public {
655     address client = msg.sender;
656     Order storage order = orderForOrderId[orderId];
657     require(order.client == client);
658     Status status = order.status;
659     if (status != Status.Open && status != Status.NeedsGas) {
660       return;
661     }
662     ClientOrderEvent(client, ClientOrderEventType.Cancel, orderId, 0);
663     if (status == Status.Open) {
664       removeOpenOrderFromBook(orderId);
665       MarketOrderEvent(block.timestamp, orderId, MarketOrderEventType.Remove, order.price,
666         order.sizeBase - order.executedBase, 0);
667     }
668     refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.ClientCancel);
669   }
670 
671   // Public Order Placement - continue placing an order in 'NeedsGas' state
672   //
673   function continueOrder(uint128 orderId, uint maxMatches) public {
674     address client = msg.sender;
675     Order storage order = orderForOrderId[orderId];
676     require(order.client == client);
677     if (order.status != Status.NeedsGas) {
678       return;
679     }
680     ClientOrderEvent(client, ClientOrderEventType.Continue, orderId, maxMatches);
681     order.status = Status.Unknown;
682     processOrder(orderId, maxMatches);
683   }
684 
685   // Internal Order Placement - remove a still-open order from the book.
686   //
687   // Caller's job to update/refund the order + raise event, this just
688   // updates the order chain and bitmask.
689   //
690   // Too expensive to do on each resting order match - we only do this for an
691   // order being cancelled. See matchWithOccupiedPrice for similar logic.
692   //
693   function removeOpenOrderFromBook(uint128 orderId) internal {
694     Order storage order = orderForOrderId[orderId];
695     uint16 price = order.price;
696     OrderChain storage orderChain = orderChainForOccupiedPrice[price];
697     OrderChainNode storage orderChainNode = orderChainNodeForOpenOrderId[orderId];
698     uint128 nextOrderId = orderChainNode.nextOrderId;
699     uint128 prevOrderId = orderChainNode.prevOrderId;
700     if (nextOrderId != 0) {
701       OrderChainNode storage nextOrderChainNode = orderChainNodeForOpenOrderId[nextOrderId];
702       nextOrderChainNode.prevOrderId = prevOrderId;
703     } else {
704       orderChain.lastOrderId = prevOrderId;
705     }
706     if (prevOrderId != 0) {
707       OrderChainNode storage prevOrderChainNode = orderChainNodeForOpenOrderId[prevOrderId];
708       prevOrderChainNode.nextOrderId = nextOrderId;
709     } else {
710       orderChain.firstOrderId = nextOrderId;
711     }
712     if (nextOrderId == 0 && prevOrderId == 0) {
713       uint bmi = price / 256;  // index into array of bitmaps
714       uint bti = price % 256;  // bit position within bitmap
715       // we know was previously occupied so XOR clears
716       occupiedPriceBitmaps[bmi] ^= 2 ** bti;
717     }
718   }
719 
720   // Internal Order Placement - credit funds received when taking liquidity from book
721   //
722   function creditExecutedFundsLessFees(uint128 orderId, uint originalExecutedBase, uint originalExecutedCntr) internal {
723     Order storage order = orderForOrderId[orderId];
724     uint liquidityTakenBase = order.executedBase - originalExecutedBase;
725     uint liquidityTakenCntr = order.executedCntr - originalExecutedCntr;
726     // Normally we deduct the fee from the currency bought (base for buy, cntr for sell),
727     // however we also accept reward tokens from the reward balance if it covers the fee,
728     // with the reward amount converted from the ETH amount (the counter currency here)
729     // at a fixed exchange rate.
730     // Overflow safe since we ensure order size < 10^30 in both currencies (see baseMaxSize).
731     // Can truncate to zero, which is fine.
732     uint feesRwrd = liquidityTakenCntr / feeDivisor * ethRwrdRate;
733     uint feesBaseOrCntr;
734     address client = order.client;
735     uint availRwrd = balanceRwrdForClient[client];
736     if (feesRwrd <= availRwrd) {
737       balanceRwrdForClient[client] = availRwrd - feesRwrd;
738       balanceRwrdForClient[feeCollector] = feesRwrd;
739       // Need += rather than = because could have paid some fees earlier in NeedsGas situation.
740       // Overflow safe since we ensure order size < 10^30 in both currencies (see baseMaxSize).
741       // Can truncate to zero, which is fine.
742       order.feesRwrd += uint128(feesRwrd);
743       if (isBuyPrice(order.price)) {
744         balanceBaseForClient[client] += liquidityTakenBase;
745       } else {
746         balanceCntrForClient[client] += liquidityTakenCntr;
747       }
748     } else if (isBuyPrice(order.price)) {
749       // See comments in branch above re: use of += and overflow safety.
750       feesBaseOrCntr = liquidityTakenBase / feeDivisor;
751       balanceBaseForClient[order.client] += (liquidityTakenBase - feesBaseOrCntr);
752       order.feesBaseOrCntr += uint128(feesBaseOrCntr);
753       balanceBaseForClient[feeCollector] += feesBaseOrCntr;
754     } else {
755       // See comments in branch above re: use of += and overflow safety.
756       feesBaseOrCntr = liquidityTakenCntr / feeDivisor;
757       balanceCntrForClient[order.client] += (liquidityTakenCntr - feesBaseOrCntr);
758       order.feesBaseOrCntr += uint128(feesBaseOrCntr);
759       balanceCntrForClient[feeCollector] += feesBaseOrCntr;
760     }
761   }
762 
763   // Internal Order Placement - process a created and sanity checked order.
764   //
765   // Used both for new orders and for gas topup.
766   //
767   function processOrder(uint128 orderId, uint maxMatches) internal {
768     Order storage order = orderForOrderId[orderId];
769 
770     uint ourOriginalExecutedBase = order.executedBase;
771     uint ourOriginalExecutedCntr = order.executedCntr;
772 
773     var (ourDirection,) = unpackPrice(order.price);
774     uint theirPriceStart = (ourDirection == Direction.Buy) ? minSellPrice : maxBuyPrice;
775     uint theirPriceEnd = computeOppositePrice(order.price);
776    
777     MatchStopReason matchStopReason =
778       matchAgainstBook(orderId, theirPriceStart, theirPriceEnd, maxMatches);
779 
780     creditExecutedFundsLessFees(orderId, ourOriginalExecutedBase, ourOriginalExecutedCntr);
781 
782     if (order.terms == Terms.ImmediateOrCancel) {
783       if (matchStopReason == MatchStopReason.Satisfied) {
784         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
785         return;
786       } else if (matchStopReason == MatchStopReason.MaxMatches) {
787         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.TooManyMatches);
788         return;
789       } else if (matchStopReason == MatchStopReason.BookExhausted) {
790         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.Unmatched);
791         return;
792       }
793     } else if (order.terms == Terms.MakerOnly) {
794       if (matchStopReason == MatchStopReason.MaxMatches) {
795         refundUnmatchedAndFinish(orderId, Status.Rejected, ReasonCode.WouldTake);
796         return;
797       } else if (matchStopReason == MatchStopReason.BookExhausted) {
798         enterOrder(orderId);
799         return;
800       }
801     } else if (order.terms == Terms.GTCNoGasTopup) {
802       if (matchStopReason == MatchStopReason.Satisfied) {
803         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
804         return;
805       } else if (matchStopReason == MatchStopReason.MaxMatches) {
806         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.TooManyMatches);
807         return;
808       } else if (matchStopReason == MatchStopReason.BookExhausted) {
809         enterOrder(orderId);
810         return;
811       }
812     } else if (order.terms == Terms.GTCWithGasTopup) {
813       if (matchStopReason == MatchStopReason.Satisfied) {
814         refundUnmatchedAndFinish(orderId, Status.Done, ReasonCode.None);
815         return;
816       } else if (matchStopReason == MatchStopReason.MaxMatches) {
817         order.status = Status.NeedsGas;
818         return;
819       } else if (matchStopReason == MatchStopReason.BookExhausted) {
820         enterOrder(orderId);
821         return;
822       }
823     }
824     assert(false); // should not be possible to reach here
825   }
826  
827   // Used internally to indicate why we stopped matching an order against the book.
828 
829   enum MatchStopReason {
830     None,
831     MaxMatches,
832     Satisfied,
833     PriceExhausted,
834     BookExhausted
835   }
836  
837   // Internal Order Placement - Match the given order against the book.
838   //
839   // Resting orders matched will be updated, removed from book and funds credited to their owners.
840   //
841   // Only updates the executedBase and executedCntr of the given order - caller is responsible
842   // for crediting matched funds, charging fees, marking order as done / entering it into the book.
843   //
844   // matchStopReason returned will be one of MaxMatches, Satisfied or BookExhausted.
845   //
846   // Calling with maxMatches == 0 is ok - and expected when the order is a maker-only order.
847   //
848   function matchAgainstBook(
849       uint128 orderId, uint theirPriceStart, uint theirPriceEnd, uint maxMatches
850     ) internal returns (
851       MatchStopReason matchStopReason
852     ) {
853     Order storage order = orderForOrderId[orderId];
854     
855     uint bmi = theirPriceStart / 256;  // index into array of bitmaps
856     uint bti = theirPriceStart % 256;  // bit position within bitmap
857     uint bmiEnd = theirPriceEnd / 256; // last bitmap to search
858     uint btiEnd = theirPriceEnd % 256; // stop at this bit in the last bitmap
859 
860     uint cbm = occupiedPriceBitmaps[bmi]; // original copy of current bitmap
861     uint dbm = cbm; // dirty version of current bitmap where we may have cleared bits
862     uint wbm = cbm >> bti; // working copy of current bitmap which we keep shifting
863     
864     // Optimized loops could render a better matching engine yet!
865 
866     bool removedLastAtPrice;
867     matchStopReason = MatchStopReason.None;
868 
869     while (bmi < bmiEnd) {
870       if (wbm == 0 || bti == 256) {
871         if (dbm != cbm) {
872           occupiedPriceBitmaps[bmi] = dbm;
873         }
874         bti = 0;
875         bmi++;
876         cbm = occupiedPriceBitmaps[bmi];
877         wbm = cbm;
878         dbm = cbm;
879       } else {
880         if ((wbm & 1) != 0) {
881           // careful - copy-and-pasted in loop below ...
882           (removedLastAtPrice, maxMatches, matchStopReason) =
883             matchWithOccupiedPrice(order, uint16(bmi * 256 + bti), maxMatches);
884           if (removedLastAtPrice) {
885             dbm ^= 2 ** bti;
886           }
887           if (matchStopReason == MatchStopReason.PriceExhausted) {
888             matchStopReason = MatchStopReason.None;
889           } else if (matchStopReason != MatchStopReason.None) {
890             // we might still have changes in dbm to write back - see later
891             break;
892           }
893         }
894         bti += 1;
895         wbm /= 2;
896       }
897     }
898     if (matchStopReason == MatchStopReason.None) {
899       // we've reached the last bitmap we need to search,
900       // we'll stop at btiEnd not 256 this time.
901       while (bti <= btiEnd && wbm != 0) {
902         if ((wbm & 1) != 0) {
903           // careful - copy-and-pasted in loop above ...
904           (removedLastAtPrice, maxMatches, matchStopReason) =
905             matchWithOccupiedPrice(order, uint16(bmi * 256 + bti), maxMatches);
906           if (removedLastAtPrice) {
907             dbm ^= 2 ** bti;
908           }
909           if (matchStopReason == MatchStopReason.PriceExhausted) {
910             matchStopReason = MatchStopReason.None;
911           } else if (matchStopReason != MatchStopReason.None) {
912             break;
913           }
914         }
915         bti += 1;
916         wbm /= 2;
917       }
918     }
919     // Careful - if we exited the first loop early, or we went into the second loop,
920     // (luckily can't both happen) then we haven't flushed the dirty bitmap back to
921     // storage - do that now if we need to.
922     if (dbm != cbm) {
923       occupiedPriceBitmaps[bmi] = dbm;
924     }
925     if (matchStopReason == MatchStopReason.None) {
926       matchStopReason = MatchStopReason.BookExhausted;
927     }
928   }
929 
930   // Internal Order Placement.
931   //
932   // Match our order against up to maxMatches resting orders at the given price (which
933   // is known by the caller to have at least one resting order).
934   //
935   // The matches (partial or complete) of the resting orders are recorded, and their
936   // funds are credited.
937   //
938   // The on chain orderbook with resting orders is updated, but the occupied price bitmap is NOT -
939   // the caller must clear the relevant bit if removedLastAtPrice = true is returned.
940   //
941   // Only updates the executedBase and executedCntr of our order - caller is responsible
942   // for e.g. crediting our matched funds, updating status.
943   //
944   // Calling with maxMatches == 0 is ok - and expected when the order is a maker-only order.
945   //
946   // Returns:
947   //   removedLastAtPrice:
948   //     true iff there are no longer any resting orders at this price - caller will need
949   //     to update the occupied price bitmap.
950   //
951   //   matchesLeft:
952   //     maxMatches passed in minus the number of matches made by this call
953   //
954   //   matchStopReason:
955   //     If our order is completely matched, matchStopReason will be Satisfied.
956   //     If our order is not completely matched, matchStopReason will be either:
957   //        MaxMatches (we are not allowed to match any more times)
958   //     or:
959   //        PriceExhausted (nothing left on the book at this exact price)
960   //
961   function matchWithOccupiedPrice(
962       Order storage ourOrder, uint16 theirPrice, uint maxMatches
963     ) internal returns (
964     bool removedLastAtPrice, uint matchesLeft, MatchStopReason matchStopReason) {
965     matchesLeft = maxMatches;
966     uint workingOurExecutedBase = ourOrder.executedBase;
967     uint workingOurExecutedCntr = ourOrder.executedCntr;
968     uint128 theirOrderId = orderChainForOccupiedPrice[theirPrice].firstOrderId;
969     matchStopReason = MatchStopReason.None;
970     while (true) {
971       if (matchesLeft == 0) {
972         matchStopReason = MatchStopReason.MaxMatches;
973         break;
974       }
975       uint matchBase;
976       uint matchCntr;
977       (theirOrderId, matchBase, matchCntr, matchStopReason) =
978         matchWithTheirs((ourOrder.sizeBase - workingOurExecutedBase), theirOrderId, theirPrice);
979       workingOurExecutedBase += matchBase;
980       workingOurExecutedCntr += matchCntr;
981       matchesLeft -= 1;
982       if (matchStopReason != MatchStopReason.None) {
983         break;
984       }
985     }
986     ourOrder.executedBase = uint128(workingOurExecutedBase);
987     ourOrder.executedCntr = uint128(workingOurExecutedCntr);
988     if (theirOrderId == 0) {
989       orderChainForOccupiedPrice[theirPrice].firstOrderId = 0;
990       orderChainForOccupiedPrice[theirPrice].lastOrderId = 0;
991       removedLastAtPrice = true;
992     } else {
993       // NB: in some cases (e.g. maxMatches == 0) this is a no-op.
994       orderChainForOccupiedPrice[theirPrice].firstOrderId = theirOrderId;
995       orderChainNodeForOpenOrderId[theirOrderId].prevOrderId = 0;
996       removedLastAtPrice = false;
997     }
998   }
999   
1000   // Internal Order Placement.
1001   //
1002   // Match up to our remaining amount against a resting order in the book.
1003   //
1004   // The match (partial, complete or effectively-complete) of the resting order
1005   // is recorded, and their funds are credited.
1006   //
1007   // Their order is NOT removed from the book by this call - the caller must do that
1008   // if the nextTheirOrderId returned is not equal to the theirOrderId passed in.
1009   //
1010   // Returns:
1011   //
1012   //   nextTheirOrderId:
1013   //     If we did not completely match their order, will be same as theirOrderId.
1014   //     If we completely matched their order, will be orderId of next order at the
1015   //     same price - or zero if this was the last order and we've now filled it.
1016   //
1017   //   matchStopReason:
1018   //     If our order is completely matched, matchStopReason will be Satisfied.
1019   //     If our order is not completely matched, matchStopReason will be either
1020   //     PriceExhausted (if nothing left at this exact price) or None (if can continue).
1021   // 
1022   function matchWithTheirs(
1023     uint ourRemainingBase, uint128 theirOrderId, uint16 theirPrice) internal returns (
1024     uint128 nextTheirOrderId, uint matchBase, uint matchCntr, MatchStopReason matchStopReason) {
1025     Order storage theirOrder = orderForOrderId[theirOrderId];
1026     uint theirRemainingBase = theirOrder.sizeBase - theirOrder.executedBase;
1027     if (ourRemainingBase < theirRemainingBase) {
1028       matchBase = ourRemainingBase;
1029     } else {
1030       matchBase = theirRemainingBase;
1031     }
1032     matchCntr = computeCntrAmountUsingPacked(matchBase, theirPrice);
1033     // It may seem a bit odd to stop here if our remaining amount is very small -
1034     // there could still be resting orders we can match it against. During network congestion gas
1035     // cost of matching each order can become quite high - potentially high enough to
1036     // wipe out the profit the taker hopes for from trading the tiny amount left.
1037     if ((ourRemainingBase - matchBase) < baseMinRemainingSize) {
1038       matchStopReason = MatchStopReason.Satisfied;
1039     } else {
1040       matchStopReason = MatchStopReason.None;
1041     }
1042     bool theirsDead = recordTheirMatch(theirOrder, theirOrderId, theirPrice, matchBase, matchCntr);
1043     if (theirsDead) {
1044       nextTheirOrderId = orderChainNodeForOpenOrderId[theirOrderId].nextOrderId;
1045       if (matchStopReason == MatchStopReason.None && nextTheirOrderId == 0) {
1046         matchStopReason = MatchStopReason.PriceExhausted;
1047       }
1048     } else {
1049       nextTheirOrderId = theirOrderId;
1050     }
1051   }
1052 
1053   // Internal Order Placement.
1054   //
1055   // Record match (partial or complete) of resting order, and credit them their funds.
1056   //
1057   // If their order is completely matched, the order is marked as done,
1058   // and "theirsDead" is returned as true.
1059   //
1060   // The order is NOT removed from the book by this call - the caller
1061   // must do that if theirsDead is true.
1062   //
1063   // No sanity checks are made - the caller must be sure the order is
1064   // not already done and has sufficient remaining. (Yes, we'd like to
1065   // check here too but we cannot afford the gas).
1066   //
1067   function recordTheirMatch(
1068       Order storage theirOrder, uint128 theirOrderId, uint16 theirPrice, uint matchBase, uint matchCntr
1069     ) internal returns (bool theirsDead) {
1070     // they are a maker so no fees
1071     // overflow safe - see comments about baseMaxSize
1072     // executedBase cannot go > sizeBase due to logic in matchWithTheirs
1073     theirOrder.executedBase += uint128(matchBase);
1074     theirOrder.executedCntr += uint128(matchCntr);
1075     if (isBuyPrice(theirPrice)) {
1076       // they have bought base (using the counter they already paid when creating the order)
1077       balanceBaseForClient[theirOrder.client] += matchBase;
1078     } else {
1079       // they have bought counter (using the base they already paid when creating the order)
1080       balanceCntrForClient[theirOrder.client] += matchCntr;
1081     }
1082     uint stillRemainingBase = theirOrder.sizeBase - theirOrder.executedBase;
1083     // avoid leaving tiny amounts in the book - refund remaining if too small
1084     if (stillRemainingBase < baseMinRemainingSize) {
1085       refundUnmatchedAndFinish(theirOrderId, Status.Done, ReasonCode.None);
1086       // someone building an UI on top needs to know how much was match and how much was refund
1087       MarketOrderEvent(block.timestamp, theirOrderId, MarketOrderEventType.CompleteFill,
1088         theirPrice, matchBase + stillRemainingBase, matchBase);
1089       return true;
1090     } else {
1091       MarketOrderEvent(block.timestamp, theirOrderId, MarketOrderEventType.PartialFill,
1092         theirPrice, matchBase, matchBase);
1093       return false;
1094     }
1095   }
1096 
1097   // Internal Order Placement.
1098   //
1099   // Refund any unmatched funds in an order (based on executed vs size) and move to a final state.
1100   //
1101   // The order is NOT removed from the book by this call and no event is raised.
1102   //
1103   // No sanity checks are made - the caller must be sure the order has not already been refunded.
1104   //
1105   function refundUnmatchedAndFinish(uint128 orderId, Status status, ReasonCode reasonCode) internal {
1106     Order storage order = orderForOrderId[orderId];
1107     uint16 price = order.price;
1108     if (isBuyPrice(price)) {
1109       uint sizeCntr = computeCntrAmountUsingPacked(order.sizeBase, price);
1110       balanceCntrForClient[order.client] += sizeCntr - order.executedCntr;
1111     } else {
1112       balanceBaseForClient[order.client] += order.sizeBase - order.executedBase;
1113     }
1114     order.status = status;
1115     order.reasonCode = reasonCode;
1116   }
1117 
1118   // Internal Order Placement.
1119   //
1120   // Enter a not completely matched order into the book, marking the order as open.
1121   //
1122   // This updates the occupied price bitmap and chain.
1123   //
1124   // No sanity checks are made - the caller must be sure the order
1125   // has some unmatched amount and has been paid for!
1126   //
1127   function enterOrder(uint128 orderId) internal {
1128     Order storage order = orderForOrderId[orderId];
1129     uint16 price = order.price;
1130     OrderChain storage orderChain = orderChainForOccupiedPrice[price];
1131     OrderChainNode storage orderChainNode = orderChainNodeForOpenOrderId[orderId];
1132     if (orderChain.firstOrderId == 0) {
1133       orderChain.firstOrderId = orderId;
1134       orderChain.lastOrderId = orderId;
1135       orderChainNode.nextOrderId = 0;
1136       orderChainNode.prevOrderId = 0;
1137       uint bitmapIndex = price / 256;
1138       uint bitIndex = price % 256;
1139       occupiedPriceBitmaps[bitmapIndex] |= (2 ** bitIndex);
1140     } else {
1141       uint128 existingLastOrderId = orderChain.lastOrderId;
1142       OrderChainNode storage existingLastOrderChainNode = orderChainNodeForOpenOrderId[existingLastOrderId];
1143       orderChainNode.nextOrderId = 0;
1144       orderChainNode.prevOrderId = existingLastOrderId;
1145       existingLastOrderChainNode.nextOrderId = orderId;
1146       orderChain.lastOrderId = orderId;
1147     }
1148     MarketOrderEvent(block.timestamp, orderId, MarketOrderEventType.Add,
1149       price, order.sizeBase - order.executedBase, 0);
1150     order.status = Status.Open;
1151   }
1152 
1153   // Internal Order Placement.
1154   //
1155   // Charge the client for the cost of placing an order in the given direction.
1156   //
1157   // Return true if successful, false otherwise.
1158   //
1159   function debitFunds(
1160       address client, Direction direction, uint sizeBase, uint sizeCntr
1161     ) internal returns (bool success) {
1162     if (direction == Direction.Buy) {
1163       uint availableCntr = balanceCntrForClient[client];
1164       if (availableCntr < sizeCntr) {
1165         return false;
1166       }
1167       balanceCntrForClient[client] = availableCntr - sizeCntr;
1168       return true;
1169     } else if (direction == Direction.Sell) {
1170       uint availableBase = balanceBaseForClient[client];
1171       if (availableBase < sizeBase) {
1172         return false;
1173       }
1174       balanceBaseForClient[client] = availableBase - sizeBase;
1175       return true;
1176     } else {
1177       return false;
1178     }
1179   }
1180 
1181   // Public Book View
1182   // 
1183   // Intended for public book depth enumeration from web3 (or similar).
1184   //
1185   // Not suitable for use from a smart contract transaction - gas usage
1186   // could be very high if we have many orders at the same price.
1187   //
1188   // Start at the given inclusive price (and side) and walk down the book
1189   // (getting less aggressive) until we find some open orders or reach the
1190   // least aggressive price.
1191   //
1192   // Returns the price where we found the order(s), the depth at that price
1193   // (zero if none found), order count there, and the current blockNumber.
1194   //
1195   // (The blockNumber is handy if you're taking a snapshot which you intend
1196   //  to keep up-to-date with the market order events).
1197   //
1198   // To walk through the on-chain orderbook, the caller should start by calling walkBook with the
1199   // most aggressive buy price (Buy @ 999000).
1200   // If the price returned is the least aggressive buy price (Buy @ 0.000001),
1201   // the side is complete.
1202   // Otherwise, call walkBook again with the (packed) price returned + 1.
1203   // Then repeat for the sell side, starting with Sell @ 0.000001 and stopping
1204   // when Sell @ 999000 is returned.
1205   //
1206   function walkBook(uint16 fromPrice) public constant returns (
1207       uint16 price, uint depthBase, uint orderCount, uint blockNumber
1208     ) {
1209     uint priceStart = fromPrice;
1210     uint priceEnd = (isBuyPrice(fromPrice)) ? minBuyPrice : maxSellPrice;
1211     
1212     // See comments in matchAgainstBook re: how these crazy loops work.
1213     
1214     uint bmi = priceStart / 256;
1215     uint bti = priceStart % 256;
1216     uint bmiEnd = priceEnd / 256;
1217     uint btiEnd = priceEnd % 256;
1218 
1219     uint wbm = occupiedPriceBitmaps[bmi] >> bti;
1220     
1221     while (bmi < bmiEnd) {
1222       if (wbm == 0 || bti == 256) {
1223         bti = 0;
1224         bmi++;
1225         wbm = occupiedPriceBitmaps[bmi];
1226       } else {
1227         if ((wbm & 1) != 0) {
1228           // careful - copy-pasted in below loop
1229           price = uint16(bmi * 256 + bti);
1230           (depthBase, orderCount) = sumDepth(orderChainForOccupiedPrice[price].firstOrderId);
1231           return (price, depthBase, orderCount, block.number);
1232         }
1233         bti += 1;
1234         wbm /= 2;
1235       }
1236     }
1237     // we've reached the last bitmap we need to search, stop at btiEnd not 256 this time.
1238     while (bti <= btiEnd && wbm != 0) {
1239       if ((wbm & 1) != 0) {
1240         // careful - copy-pasted in above loop
1241         price = uint16(bmi * 256 + bti);
1242         (depthBase, orderCount) = sumDepth(orderChainForOccupiedPrice[price].firstOrderId);
1243         return (price, depthBase, orderCount, block.number);
1244       }
1245       bti += 1;
1246       wbm /= 2;
1247     }
1248     return (uint16(priceEnd), 0, 0, block.number);
1249   }
1250 
1251   // Internal Book View.
1252   //
1253   // See walkBook - adds up open depth at a price starting from an
1254   // order which is assumed to be open. Careful - unlimited gas use.
1255   //
1256   function sumDepth(uint128 orderId) internal constant returns (uint depth, uint orderCount) {
1257     while (true) {
1258       Order storage order = orderForOrderId[orderId];
1259       depth += order.sizeBase - order.executedBase;
1260       orderCount++;
1261       orderId = orderChainNodeForOpenOrderId[orderId].nextOrderId;
1262       if (orderId == 0) {
1263         return (depth, orderCount);
1264       }
1265     }
1266   }
1267 }
1268 
1269 // helper for automating book creation
1270 contract OnChainOrderBookV012bFactory {
1271 
1272     event BookCreated (address bookAddress);
1273 
1274     function OnChainOrderBookV012bFactory() {
1275     }
1276 
1277     function createBook(ERC20 _baseToken, ERC20 _rwrdToken, address _feeCollector, uint _baseMinInitialSize, int8 _minPriceExponent) public {
1278         OnChainOrderBookV012b book = new OnChainOrderBookV012b();
1279         book.init(_baseToken, _rwrdToken, _baseMinInitialSize, _minPriceExponent);
1280         book.changeFeeCollector(_feeCollector);
1281         BookCreated(address(book));
1282     }
1283 }