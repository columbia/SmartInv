1 pragma solidity 0.4.24;
2 
3 /**
4  * @title Math
5  * @dev Assorted math operations
6  */
7 library Math {
8     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
9         return a >= b ? a : b;
10     }
11 
12     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
13         return a < b ? a : b;
14     }
15 
16     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
17         return a >= b ? a : b;
18     }
19 
20     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
21         return a < b ? a : b;
22     }
23 }
24 
25 /**
26  * @title Ownable
27  * @dev The Ownable contract has an owner address, and provides basic authorization control
28  * functions, this simplifies the implementation of "user permissions".
29  */
30 contract Ownable {
31     address public owner;
32 
33     event OwnershipRenounced(address indexed previousOwner);
34     event OwnershipTransferred(
35         address indexed previousOwner,
36         address indexed newOwner
37     );
38 
39     /**
40     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41     * account.
42     */
43     constructor() public {
44         owner = msg.sender;
45     }
46 
47     /**
48     * @dev Throws if called by any account other than the owner.
49     */
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     /**
56     * @dev Allows the current owner to relinquish control of the contract.
57     * @notice Renouncing to ownership will leave the contract without an owner.
58     * It will not be possible to call the functions with the `onlyOwner`
59     * modifier anymore.
60     */
61     function renounceOwnership() public onlyOwner {
62         emit OwnershipRenounced(owner);
63         owner = address(0);
64     }
65 
66     /**
67     * @dev Allows the current owner to transfer control of the contract to a newOwner.
68     * @param _newOwner The address to transfer ownership to.
69     */
70     function transferOwnership(address _newOwner) public onlyOwner {
71         _transferOwnership(_newOwner);
72     }
73 
74     /**
75     * @dev Transfers control of the contract to a newOwner.
76     * @param _newOwner The address to transfer ownership to.
77     */
78     function _transferOwnership(address _newOwner) internal {
79         require(_newOwner != address(0));
80         emit OwnershipTransferred(owner, _newOwner);
81         owner = _newOwner;
82     }
83 }
84 
85 /**
86  * @title SafeMath
87  * @dev Math operations with safety checks that throw on error
88  */
89 library SafeMath {
90 
91     /**
92     * @dev Multiplies two numbers, throws on overflow.
93     */
94     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
95         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
96         // benefit is lost if 'b' is also tested.
97         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
98         if (a == 0) {
99             return 0;
100         }
101 
102         c = a * b;
103         assert(c / a == b);
104         return c;
105     }
106 
107     /**
108     * @dev Integer division of two numbers, truncating the quotient.
109     */
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         // assert(b > 0); // Solidity automatically throws when dividing by 0
112         // uint256 c = a / b;
113         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
114         return a / b;
115     }
116 
117     /**
118     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
119     */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         assert(b <= a);
122         return a - b;
123     }
124 
125     /**
126     * @dev Adds two numbers, throws on overflow.
127     */
128     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
129         c = a + b;
130         assert(c >= a);
131         return c;
132     }
133 }
134 
135 /// @notice The Orderbook contract stores the state and priority of orders and
136 /// allows the Darknodes to easily reach consensus. Eventually, this contract
137 /// will only store a subset of order states, such as cancellation, to improve
138 /// the throughput of orders.
139 contract Orderbook  {
140     /// @notice OrderState enumerates the possible states of an order. All
141     /// orders default to the Undefined state.
142     enum OrderState {Undefined, Open, Confirmed, Canceled}
143 
144     /// @notice returns a list of matched orders to the given orderID.
145     function orderMatch(bytes32 _orderID) external view returns (bytes32);
146 
147     /// @notice returns the trader of the given orderID.
148     /// Trader is the one who signs the message and does the actual trading.
149     function orderTrader(bytes32 _orderID) external view returns (address);
150 
151     /// @notice returns status of the given orderID.
152     function orderState(bytes32 _orderID) external view returns (OrderState);
153 
154     /// @notice returns the darknode address which confirms the given orderID.
155     function orderConfirmer(bytes32 _orderID) external view returns (address);
156 }
157 
158 
159 /// @notice RenExTokens is a registry of tokens that can be traded on RenEx.
160 contract RenExTokens is Ownable {
161     struct TokenDetails {
162         address addr;
163         uint8 decimals;
164         bool registered;
165     }
166 
167     mapping(uint32 => TokenDetails) public tokens;
168 
169     /// @notice Allows the owner to register and the details for a token.
170     /// Once details have been submitted, they cannot be overwritten.
171     /// To re-register the same token with different details (e.g. if the address
172     /// has changed), a different token identifier should be used and the
173     /// previous token identifier should be deregistered.
174     /// If a token is not Ethereum-based, the address will be set to 0x0.
175     ///
176     /// @param _tokenCode A unique 32-bit token identifier.
177     /// @param _tokenAddress The address of the token.
178     /// @param _tokenDecimals The decimals to use for the token.
179     function registerToken(uint32 _tokenCode, address _tokenAddress, uint8 _tokenDecimals) public onlyOwner;
180 
181     /// @notice Sets a token as being deregistered. The details are still stored
182     /// to prevent the token from being re-registered with different details.
183     ///
184     /// @param _tokenCode The unique 32-bit token identifier.
185     function deregisterToken(uint32 _tokenCode) external onlyOwner;
186 }
187 
188 
189 /// @notice RenExBalances is responsible for holding RenEx trader funds.
190 contract RenExBalances {
191     address public settlementContract;
192 
193     /// @notice Restricts a function to only being called by the RenExSettlement
194     /// contract.
195     modifier onlyRenExSettlementContract() {
196         require(msg.sender == address(settlementContract), "not authorized");
197         _;
198     }
199 
200     /// @notice Transfer a token value from one trader to another, transferring
201     /// a fee to the RewardVault. Can only be called by the RenExSettlement
202     /// contract.
203     ///
204     /// @param _traderFrom The address of the trader to decrement the balance of.
205     /// @param _traderTo The address of the trader to increment the balance of.
206     /// @param _token The token's address.
207     /// @param _value The number of tokens to decrement the balance by (in the
208     ///        token's smallest unit).
209     /// @param _fee The fee amount to forward on to the RewardVault.
210     /// @param _feePayee The recipient of the fee.
211     function transferBalanceWithFee(address _traderFrom, address _traderTo, address _token, uint256 _value, uint256 _fee, address _feePayee)
212     external onlyRenExSettlementContract;
213 }
214 
215 
216 /// @notice A library for calculating and verifying order match details
217 library SettlementUtils {
218 
219     struct OrderDetails {
220         uint64 settlementID;
221         uint64 tokens;
222         uint256 price;
223         uint256 volume;
224         uint256 minimumVolume;
225     }
226 
227     /// @notice Calculates the ID of the order.
228     /// @param details Order details that are not required for settlement
229     ///        execution. They are combined as a single byte array.
230     /// @param order The order details required for settlement execution.
231     function hashOrder(bytes details, OrderDetails memory order) internal pure returns (bytes32) {
232         return keccak256(
233             abi.encodePacked(
234                 details,
235                 order.settlementID,
236                 order.tokens,
237                 order.price,
238                 order.volume,
239                 order.minimumVolume
240             )
241         );
242     }
243 
244     /// @notice Verifies that two orders match when considering the tokens,
245     /// price, volumes / minimum volumes and settlement IDs. verifyMatchDetails is used
246     /// my the DarknodeSlasher to verify challenges. Settlement layers may also
247     /// use this function.
248     /// @dev When verifying two orders for settlement, you should also:
249     ///   1) verify the orders have been confirmed together
250     ///   2) verify the orders' traders are distinct
251     /// @param _buy The buy order details.
252     /// @param _sell The sell order details.
253     function verifyMatchDetails(OrderDetails memory _buy, OrderDetails memory _sell) internal pure returns (bool) {
254 
255         // Buy and sell tokens should match
256         if (!verifyTokens(_buy.tokens, _sell.tokens)) {
257             return false;
258         }
259 
260         // Buy price should be greater than sell price
261         if (_buy.price < _sell.price) {
262             return false;
263         }
264 
265         // // Buy volume should be greater than sell minimum volume
266         if (_buy.volume < _sell.minimumVolume) {
267             return false;
268         }
269 
270         // Sell volume should be greater than buy minimum volume
271         if (_sell.volume < _buy.minimumVolume) {
272             return false;
273         }
274 
275         // Require that the orders were submitted to the same settlement layer
276         if (_buy.settlementID != _sell.settlementID) {
277             return false;
278         }
279 
280         return true;
281     }
282 
283     /// @notice Verifies that two token requirements can be matched and that the
284     /// tokens are formatted correctly.
285     /// @param _buyTokens The buy token details.
286     /// @param _sellToken The sell token details.
287     function verifyTokens(uint64 _buyTokens, uint64 _sellToken) internal pure returns (bool) {
288         return ((
289                 uint32(_buyTokens) == uint32(_sellToken >> 32)) && (
290                 uint32(_sellToken) == uint32(_buyTokens >> 32)) && (
291                 uint32(_buyTokens >> 32) <= uint32(_buyTokens))
292         );
293     }
294 }
295 
296 /// @notice RenExSettlement implements the Settlement interface. It implements
297 /// the on-chain settlement for the RenEx settlement layer, and the fee payment
298 /// for the RenExAtomic settlement layer.
299 contract RenExSettlement is Ownable {
300     using SafeMath for uint256;
301 
302     string public VERSION; // Passed in as a constructor parameter.
303 
304     // This contract handles the settlements with ID 1 and 2.
305     uint32 constant public RENEX_SETTLEMENT_ID = 1;
306     uint32 constant public RENEX_ATOMIC_SETTLEMENT_ID = 2;
307 
308     // Fees in RenEx are 0.2%. To represent this as integers, it is broken into
309     // a numerator and denominator.
310     uint256 constant public DARKNODE_FEES_NUMERATOR = 2;
311     uint256 constant public DARKNODE_FEES_DENOMINATOR = 1000;
312 
313     // Constants used in the price / volume inputs.
314     int16 constant private PRICE_OFFSET = 12;
315     int16 constant private VOLUME_OFFSET = 12;
316 
317     // Constructor parameters, updatable by the owner
318     Orderbook public orderbookContract;
319     RenExTokens public renExTokensContract;
320     RenExBalances public renExBalancesContract;
321     address public slasherAddress;
322     uint256 public submissionGasPriceLimit;
323 
324     enum OrderStatus {None, Submitted, Settled, Slashed}
325 
326     struct TokenPair {
327         RenExTokens.TokenDetails priorityToken;
328         RenExTokens.TokenDetails secondaryToken;
329     }
330 
331     // A uint256 tuple representing a value and an associated fee
332     struct ValueWithFees {
333         uint256 value;
334         uint256 fees;
335     }
336 
337     // A uint256 tuple representing a fraction
338     struct Fraction {
339         uint256 numerator;
340         uint256 denominator;
341     }
342 
343     // We use left and right because the tokens do not always represent the
344     // priority and secondary tokens.
345     struct SettlementDetails {
346         uint256 leftVolume;
347         uint256 rightVolume;
348         uint256 leftTokenFee;
349         uint256 rightTokenFee;
350         address leftTokenAddress;
351         address rightTokenAddress;
352     }
353 
354     // Events
355     event LogOrderbookUpdated(Orderbook previousOrderbook, Orderbook nextOrderbook);
356     event LogRenExTokensUpdated(RenExTokens previousRenExTokens, RenExTokens nextRenExTokens);
357     event LogRenExBalancesUpdated(RenExBalances previousRenExBalances, RenExBalances nextRenExBalances);
358     event LogSubmissionGasPriceLimitUpdated(uint256 previousSubmissionGasPriceLimit, uint256 nextSubmissionGasPriceLimit);
359     event LogSlasherUpdated(address previousSlasher, address nextSlasher);
360 
361     // Order Storage
362     mapping(bytes32 => SettlementUtils.OrderDetails) public orderDetails;
363     mapping(bytes32 => address) public orderSubmitter;
364     mapping(bytes32 => OrderStatus) public orderStatus;
365 
366     // Match storage (match details are indexed by [buyID][sellID])
367     mapping(bytes32 => mapping(bytes32 => uint256)) public matchTimestamp;
368 
369     /// @notice Prevents a function from being called with a gas price higher
370     /// than the specified limit.
371     ///
372     /// @param _gasPriceLimit The gas price upper-limit in Wei.
373     modifier withGasPriceLimit(uint256 _gasPriceLimit) {
374         require(tx.gasprice <= _gasPriceLimit, "gas price too high");
375         _;
376     }
377 
378     /// @notice Restricts a function to only being called by the slasher
379     /// address.
380     modifier onlySlasher() {
381         require(msg.sender == slasherAddress, "unauthorized");
382         _;
383     }
384 
385     /// @notice The contract constructor.
386     ///
387     /// @param _VERSION A string defining the contract version.
388     /// @param _orderbookContract The address of the Orderbook contract.
389     /// @param _renExBalancesContract The address of the RenExBalances
390     ///        contract.
391     /// @param _renExTokensContract The address of the RenExTokens contract.
392     constructor(
393         string _VERSION,
394         Orderbook _orderbookContract,
395         RenExTokens _renExTokensContract,
396         RenExBalances _renExBalancesContract,
397         address _slasherAddress,
398         uint256 _submissionGasPriceLimit
399     ) public {
400         VERSION = _VERSION;
401         orderbookContract = _orderbookContract;
402         renExTokensContract = _renExTokensContract;
403         renExBalancesContract = _renExBalancesContract;
404         slasherAddress = _slasherAddress;
405         submissionGasPriceLimit = _submissionGasPriceLimit;
406     }
407 
408     /// @notice The owner of the contract can update the Orderbook address.
409     /// @param _newOrderbookContract The address of the new Orderbook contract.
410     function updateOrderbook(Orderbook _newOrderbookContract) external onlyOwner {
411         emit LogOrderbookUpdated(orderbookContract, _newOrderbookContract);
412         orderbookContract = _newOrderbookContract;
413     }
414 
415     /// @notice The owner of the contract can update the RenExTokens address.
416     /// @param _newRenExTokensContract The address of the new RenExTokens
417     ///       contract.
418     function updateRenExTokens(RenExTokens _newRenExTokensContract) external onlyOwner {
419         emit LogRenExTokensUpdated(renExTokensContract, _newRenExTokensContract);
420         renExTokensContract = _newRenExTokensContract;
421     }
422     
423     /// @notice The owner of the contract can update the RenExBalances address.
424     /// @param _newRenExBalancesContract The address of the new RenExBalances
425     ///       contract.
426     function updateRenExBalances(RenExBalances _newRenExBalancesContract) external onlyOwner {
427         emit LogRenExBalancesUpdated(renExBalancesContract, _newRenExBalancesContract);
428         renExBalancesContract = _newRenExBalancesContract;
429     }
430 
431     /// @notice The owner of the contract can update the order submission gas
432     /// price limit.
433     /// @param _newSubmissionGasPriceLimit The new gas price limit.
434     function updateSubmissionGasPriceLimit(uint256 _newSubmissionGasPriceLimit) external onlyOwner {
435         emit LogSubmissionGasPriceLimitUpdated(submissionGasPriceLimit, _newSubmissionGasPriceLimit);
436         submissionGasPriceLimit = _newSubmissionGasPriceLimit;
437     }
438 
439     /// @notice The owner of the contract can update the slasher address.
440     /// @param _newSlasherAddress The new slasher address.
441     function updateSlasher(address _newSlasherAddress) external onlyOwner {
442         emit LogSlasherUpdated(slasherAddress, _newSlasherAddress);
443         slasherAddress = _newSlasherAddress;
444     }
445 
446     /// @notice Stores the details of an order.
447     ///
448     /// @param _prefix The miscellaneous details of the order required for
449     ///        calculating the order id.
450     /// @param _settlementID The settlement identifier.
451     /// @param _tokens The encoding of the token pair (buy token is encoded as
452     ///        the first 32 bytes and sell token is encoded as the last 32
453     ///        bytes).
454     /// @param _price The price of the order. Interpreted as the cost for 1
455     ///        standard unit of the non-priority token, in 1e12 (i.e.
456     ///        PRICE_OFFSET) units of the priority token).
457     /// @param _volume The volume of the order. Interpreted as the maximum
458     ///        number of 1e-12 (i.e. VOLUME_OFFSET) units of the non-priority
459     ///        token that can be traded by this order.
460     /// @param _minimumVolume The minimum volume the trader is willing to
461     ///        accept. Encoded the same as the volume.
462     function submitOrder(
463         bytes _prefix,
464         uint64 _settlementID,
465         uint64 _tokens,
466         uint256 _price,
467         uint256 _volume,
468         uint256 _minimumVolume
469     ) external withGasPriceLimit(submissionGasPriceLimit) {
470 
471         SettlementUtils.OrderDetails memory order = SettlementUtils.OrderDetails({
472             settlementID: _settlementID,
473             tokens: _tokens,
474             price: _price,
475             volume: _volume,
476             minimumVolume: _minimumVolume
477         });
478         bytes32 orderID = SettlementUtils.hashOrder(_prefix, order);
479 
480         require(orderStatus[orderID] == OrderStatus.None, "order already submitted");
481         require(orderbookContract.orderState(orderID) == Orderbook.OrderState.Confirmed, "unconfirmed order");
482 
483         orderSubmitter[orderID] = msg.sender;
484         orderStatus[orderID] = OrderStatus.Submitted;
485         orderDetails[orderID] = order;
486     }
487 
488     /// @notice Settles two orders that are matched. `submitOrder` must have been
489     /// called for each order before this function is called.
490     ///
491     /// @param _buyID The 32 byte ID of the buy order.
492     /// @param _sellID The 32 byte ID of the sell order.
493     function settle(bytes32 _buyID, bytes32 _sellID) external {
494         require(orderStatus[_buyID] == OrderStatus.Submitted, "invalid buy status");
495         require(orderStatus[_sellID] == OrderStatus.Submitted, "invalid sell status");
496 
497         // Check the settlement ID (only have to check for one, since
498         // `verifyMatchDetails` checks that they are the same)
499         require(
500             orderDetails[_buyID].settlementID == RENEX_ATOMIC_SETTLEMENT_ID ||
501             orderDetails[_buyID].settlementID == RENEX_SETTLEMENT_ID,
502             "invalid settlement id"
503         );
504 
505         // Verify that the two order details are compatible.
506         require(SettlementUtils.verifyMatchDetails(orderDetails[_buyID], orderDetails[_sellID]), "incompatible orders");
507 
508         // Verify that the two orders have been confirmed to one another.
509         require(orderbookContract.orderMatch(_buyID) == _sellID, "unconfirmed orders");
510 
511         // Retrieve token details.
512         TokenPair memory tokens = getTokenDetails(orderDetails[_buyID].tokens);
513 
514         // Require that the tokens have been registered.
515         require(tokens.priorityToken.registered, "unregistered priority token");
516         require(tokens.secondaryToken.registered, "unregistered secondary token");
517 
518         address buyer = orderbookContract.orderTrader(_buyID);
519         address seller = orderbookContract.orderTrader(_sellID);
520 
521         require(buyer != seller, "orders from same trader");
522 
523         execute(_buyID, _sellID, buyer, seller, tokens);
524 
525         /* solium-disable-next-line security/no-block-members */
526         matchTimestamp[_buyID][_sellID] = now;
527 
528         // Store that the orders have been settled.
529         orderStatus[_buyID] = OrderStatus.Settled;
530         orderStatus[_sellID] = OrderStatus.Settled;
531     }
532 
533     /// @notice Slashes the bond of a guilty trader. This is called when an
534     /// atomic swap is not executed successfully.
535     /// To open an atomic order, a trader must have a balance equivalent to
536     /// 0.6% of the trade in the Ethereum-based token. 0.2% is always paid in
537     /// darknode fees when the order is matched. If the remaining amount is
538     /// is slashed, it is distributed as follows:
539     ///   1) 0.2% goes to the other trader, covering their fee
540     ///   2) 0.2% goes to the slasher address
541     /// Only one order in a match can be slashed.
542     ///
543     /// @param _guiltyOrderID The 32 byte ID of the order of the guilty trader.
544     function slash(bytes32 _guiltyOrderID) external onlySlasher {
545         require(orderDetails[_guiltyOrderID].settlementID == RENEX_ATOMIC_SETTLEMENT_ID, "slashing non-atomic trade");
546 
547         bytes32 innocentOrderID = orderbookContract.orderMatch(_guiltyOrderID);
548 
549         require(orderStatus[_guiltyOrderID] == OrderStatus.Settled, "invalid order status");
550         require(orderStatus[innocentOrderID] == OrderStatus.Settled, "invalid order status");
551         orderStatus[_guiltyOrderID] = OrderStatus.Slashed;
552 
553         (bytes32 buyID, bytes32 sellID) = isBuyOrder(_guiltyOrderID) ?
554             (_guiltyOrderID, innocentOrderID) : (innocentOrderID, _guiltyOrderID);
555 
556         TokenPair memory tokens = getTokenDetails(orderDetails[buyID].tokens);
557 
558         SettlementDetails memory settlementDetails = calculateAtomicFees(buyID, sellID, tokens);
559 
560         // Transfer the fee amount to the other trader
561         renExBalancesContract.transferBalanceWithFee(
562             orderbookContract.orderTrader(_guiltyOrderID),
563             orderbookContract.orderTrader(innocentOrderID),
564             settlementDetails.leftTokenAddress,
565             settlementDetails.leftTokenFee,
566             0,
567             0x0
568         );
569 
570         // Transfer the fee amount to the slasher
571         renExBalancesContract.transferBalanceWithFee(
572             orderbookContract.orderTrader(_guiltyOrderID),
573             slasherAddress,
574             settlementDetails.leftTokenAddress,
575             settlementDetails.leftTokenFee,
576             0,
577             0x0
578         );
579     }
580 
581     /// @notice Retrieves the settlement details of an order.
582     /// For atomic swaps, it returns the full volumes, not the settled fees.
583     ///
584     /// @param _orderID The order to lookup the details of. Can be the ID of a
585     ///        buy or a sell order.
586     /// @return [
587     ///     a boolean representing whether or not the order has been settled,
588     ///     a boolean representing whether or not the order is a buy
589     ///     the 32-byte order ID of the matched order
590     ///     the volume of the priority token,
591     ///     the volume of the secondary token,
592     ///     the fee paid in the priority token,
593     ///     the fee paid in the secondary token,
594     ///     the token code of the priority token,
595     ///     the token code of the secondary token
596     /// ]
597     function getMatchDetails(bytes32 _orderID)
598     external view returns (
599         bool settled,
600         bool orderIsBuy,
601         bytes32 matchedID,
602         uint256 priorityVolume,
603         uint256 secondaryVolume,
604         uint256 priorityFee,
605         uint256 secondaryFee,
606         uint32 priorityToken,
607         uint32 secondaryToken
608     ) {
609         matchedID = orderbookContract.orderMatch(_orderID);
610 
611         orderIsBuy = isBuyOrder(_orderID);
612 
613         (bytes32 buyID, bytes32 sellID) = orderIsBuy ?
614             (_orderID, matchedID) : (matchedID, _orderID);
615 
616         SettlementDetails memory settlementDetails = calculateSettlementDetails(
617             buyID,
618             sellID,
619             getTokenDetails(orderDetails[buyID].tokens)
620         );
621 
622         return (
623             orderStatus[_orderID] == OrderStatus.Settled || orderStatus[_orderID] == OrderStatus.Slashed,
624             orderIsBuy,
625             matchedID,
626             settlementDetails.leftVolume,
627             settlementDetails.rightVolume,
628             settlementDetails.leftTokenFee,
629             settlementDetails.rightTokenFee,
630             uint32(orderDetails[buyID].tokens >> 32),
631             uint32(orderDetails[buyID].tokens)
632         );
633     }
634 
635     /// @notice Exposes the hashOrder function for computing a hash of an
636     /// order's details. An order hash is used as its ID. See `submitOrder`
637     /// for the parameter descriptions.
638     ///
639     /// @return The 32-byte hash of the order.
640     function hashOrder(
641         bytes _prefix,
642         uint64 _settlementID,
643         uint64 _tokens,
644         uint256 _price,
645         uint256 _volume,
646         uint256 _minimumVolume
647     ) external pure returns (bytes32) {
648         return SettlementUtils.hashOrder(_prefix, SettlementUtils.OrderDetails({
649             settlementID: _settlementID,
650             tokens: _tokens,
651             price: _price,
652             volume: _volume,
653             minimumVolume: _minimumVolume
654         }));
655     }
656 
657     /// @notice Called by `settle`, executes the settlement for a RenEx order
658     /// or distributes the fees for a RenExAtomic swap.
659     ///
660     /// @param _buyID The 32 byte ID of the buy order.
661     /// @param _sellID The 32 byte ID of the sell order.
662     /// @param _buyer The address of the buy trader.
663     /// @param _seller The address of the sell trader.
664     /// @param _tokens The details of the priority and secondary tokens.
665     function execute(
666         bytes32 _buyID,
667         bytes32 _sellID,
668         address _buyer,
669         address _seller,
670         TokenPair memory _tokens
671     ) private {
672         // Calculate the fees for atomic swaps, and the settlement details
673         // otherwise.
674         SettlementDetails memory settlementDetails = (orderDetails[_buyID].settlementID == RENEX_ATOMIC_SETTLEMENT_ID) ?
675             settlementDetails = calculateAtomicFees(_buyID, _sellID, _tokens) :
676             settlementDetails = calculateSettlementDetails(_buyID, _sellID, _tokens);
677 
678         // Transfer priority token value
679         renExBalancesContract.transferBalanceWithFee(
680             _buyer,
681             _seller,
682             settlementDetails.leftTokenAddress,
683             settlementDetails.leftVolume,
684             settlementDetails.leftTokenFee,
685             orderSubmitter[_buyID]
686         );
687 
688         // Transfer secondary token value
689         renExBalancesContract.transferBalanceWithFee(
690             _seller,
691             _buyer,
692             settlementDetails.rightTokenAddress,
693             settlementDetails.rightVolume,
694             settlementDetails.rightTokenFee,
695             orderSubmitter[_sellID]
696         );
697     }
698 
699     /// @notice Calculates the details required to execute two matched orders.
700     ///
701     /// @param _buyID The 32 byte ID of the buy order.
702     /// @param _sellID The 32 byte ID of the sell order.
703     /// @param _tokens The details of the priority and secondary tokens.
704     /// @return A struct containing the settlement details.
705     function calculateSettlementDetails(
706         bytes32 _buyID,
707         bytes32 _sellID,
708         TokenPair memory _tokens
709     ) private view returns (SettlementDetails memory) {
710 
711         // Calculate the mid-price (using numerator and denominator to not loose
712         // precision).
713         Fraction memory midPrice = Fraction(orderDetails[_buyID].price + orderDetails[_sellID].price, 2);
714 
715         // Calculate the lower of the two max volumes of each trader
716         uint256 commonVolume = Math.min256(orderDetails[_buyID].volume, orderDetails[_sellID].volume);
717 
718         uint256 priorityTokenVolume = joinFraction(
719             commonVolume.mul(midPrice.numerator),
720             midPrice.denominator,
721             int16(_tokens.priorityToken.decimals) - PRICE_OFFSET - VOLUME_OFFSET
722         );
723         uint256 secondaryTokenVolume = joinFraction(
724             commonVolume,
725             1,
726             int16(_tokens.secondaryToken.decimals) - VOLUME_OFFSET
727         );
728 
729         // Calculate darknode fees
730         ValueWithFees memory priorityVwF = subtractDarknodeFee(priorityTokenVolume);
731         ValueWithFees memory secondaryVwF = subtractDarknodeFee(secondaryTokenVolume);
732 
733         return SettlementDetails({
734             leftVolume: priorityVwF.value,
735             rightVolume: secondaryVwF.value,
736             leftTokenFee: priorityVwF.fees,
737             rightTokenFee: secondaryVwF.fees,
738             leftTokenAddress: _tokens.priorityToken.addr,
739             rightTokenAddress: _tokens.secondaryToken.addr
740         });
741     }
742 
743     /// @notice Calculates the fees to be transferred for an atomic swap.
744     ///
745     /// @param _buyID The 32 byte ID of the buy order.
746     /// @param _sellID The 32 byte ID of the sell order.
747     /// @param _tokens The details of the priority and secondary tokens.
748     /// @return A struct containing the fee details.
749     function calculateAtomicFees(
750         bytes32 _buyID,
751         bytes32 _sellID,
752         TokenPair memory _tokens
753     ) private view returns (SettlementDetails memory) {
754 
755         // Calculate the mid-price (using numerator and denominator to not loose
756         // precision).
757         Fraction memory midPrice = Fraction(orderDetails[_buyID].price + orderDetails[_sellID].price, 2);
758 
759         // Calculate the lower of the two max volumes of each trader
760         uint256 commonVolume = Math.min256(orderDetails[_buyID].volume, orderDetails[_sellID].volume);
761 
762         if (isEthereumBased(_tokens.secondaryToken.addr)) {
763             uint256 secondaryTokenVolume = joinFraction(
764                 commonVolume,
765                 1,
766                 int16(_tokens.secondaryToken.decimals) - VOLUME_OFFSET
767             );
768 
769             // Calculate darknode fees
770             ValueWithFees memory secondaryVwF = subtractDarknodeFee(secondaryTokenVolume);
771 
772             return SettlementDetails({
773                 leftVolume: 0,
774                 rightVolume: 0,
775                 leftTokenFee: secondaryVwF.fees,
776                 rightTokenFee: secondaryVwF.fees,
777                 leftTokenAddress: _tokens.secondaryToken.addr,
778                 rightTokenAddress: _tokens.secondaryToken.addr
779             });
780         } else if (isEthereumBased(_tokens.priorityToken.addr)) {
781             uint256 priorityTokenVolume = joinFraction(
782                 commonVolume.mul(midPrice.numerator),
783                 midPrice.denominator,
784                 int16(_tokens.priorityToken.decimals) - PRICE_OFFSET - VOLUME_OFFSET
785             );
786 
787             // Calculate darknode fees
788             ValueWithFees memory priorityVwF = subtractDarknodeFee(priorityTokenVolume);
789 
790             return SettlementDetails({
791                 leftVolume: 0,
792                 rightVolume: 0,
793                 leftTokenFee: priorityVwF.fees,
794                 rightTokenFee: priorityVwF.fees,
795                 leftTokenAddress: _tokens.priorityToken.addr,
796                 rightTokenAddress: _tokens.priorityToken.addr
797             });
798         } else {
799             // Currently, at least one token must be Ethereum-based.
800             // This will be implemented in the future.
801             revert("non-eth atomic swaps are not supported");
802         }
803     }
804 
805     /// @notice Order parity is set by the order tokens are listed. This returns
806     /// whether an order is a buy or a sell.
807     /// @return true if _orderID is a buy order.
808     function isBuyOrder(bytes32 _orderID) private view returns (bool) {
809         uint64 tokens = orderDetails[_orderID].tokens;
810         uint32 firstToken = uint32(tokens >> 32);
811         uint32 secondaryToken = uint32(tokens);
812         return (firstToken < secondaryToken);
813     }
814 
815     /// @return (value - fee, fee) where fee is 0.2% of value
816     function subtractDarknodeFee(uint256 _value) private pure returns (ValueWithFees memory) {
817         uint256 newValue = (_value * (DARKNODE_FEES_DENOMINATOR - DARKNODE_FEES_NUMERATOR)) / DARKNODE_FEES_DENOMINATOR;
818         return ValueWithFees(newValue, _value - newValue);
819     }
820 
821     /// @notice Gets the order details of the priority and secondary token from
822     /// the RenExTokens contract and returns them as a single struct.
823     ///
824     /// @param _tokens The 64-bit combined token identifiers.
825     /// @return A TokenPair struct containing two TokenDetails structs.
826     function getTokenDetails(uint64 _tokens) private view returns (TokenPair memory) {
827         (
828             address priorityAddress,
829             uint8 priorityDecimals,
830             bool priorityRegistered
831         ) = renExTokensContract.tokens(uint32(_tokens >> 32));
832 
833         (
834             address secondaryAddress,
835             uint8 secondaryDecimals,
836             bool secondaryRegistered
837         ) = renExTokensContract.tokens(uint32(_tokens));
838 
839         return TokenPair({
840             priorityToken: RenExTokens.TokenDetails(priorityAddress, priorityDecimals, priorityRegistered),
841             secondaryToken: RenExTokens.TokenDetails(secondaryAddress, secondaryDecimals, secondaryRegistered)
842         });
843     }
844 
845     /// @return true if _tokenAddress is 0x0, representing a token that is not
846     /// on Ethereum
847     function isEthereumBased(address _tokenAddress) private pure returns (bool) {
848         return (_tokenAddress != address(0x0));
849     }
850 
851     /// @notice Computes (_numerator / _denominator) * 10 ** _scale
852     function joinFraction(uint256 _numerator, uint256 _denominator, int16 _scale) private pure returns (uint256) {
853         if (_scale >= 0) {
854             // Check that (10**_scale) doesn't overflow
855             assert(_scale <= 77); // log10(2**256) = 77.06
856             return _numerator.mul(10 ** uint256(_scale)) / _denominator;
857         } else {
858             /// @dev If _scale is less than -77, 10**-_scale would overflow.
859             // For now, -_scale > -24 (when a token has 0 decimals and
860             // VOLUME_OFFSET and PRICE_OFFSET are each 12). It is unlikely these
861             // will be increased to add to more than 77.
862             // assert((-_scale) <= 77); // log10(2**256) = 77.06
863             return (_numerator / _denominator) / 10 ** uint256(-_scale);
864         }
865     }
866 }