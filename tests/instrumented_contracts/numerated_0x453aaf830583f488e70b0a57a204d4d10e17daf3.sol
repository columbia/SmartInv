1 pragma solidity =0.5.13;
2 
3 // * Gods Unchained Cards Exchange
4 //
5 // * Version 1.0
6 //
7 // * A dedicated, specialized contract enabling exchange of Gods Unchained cards.
8 //   Considers Gods Unchained specific characteristics like quality and proto
9 //   and allows multicard offchain listing and dynamic package purchases.
10 //
11 // * https://gu.cards
12 // * Copyright gu.cards
13 
14 interface ICards {
15     function getProto(uint tokenId) external view returns (uint16 proto);
16     function getQuality(uint tokenId) external view returns (uint8 quality);
17 }
18 
19 interface IERC721 {
20     function transferFrom(address _from, address _to, uint256 _tokenId) external;
21     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
22     function ownerOf(uint256 tokenId) external view returns (address owner);
23 }
24 
25 contract GodsUnchainedCards is IERC721, ICards {}
26 
27 /**
28  * @dev Wrappers over Solidity's arithmetic operations with added overflow
29  * checks.
30  *
31  * Arithmetic operations in Solidity wrap on overflow. This can easily result
32  * in bugs, because programmers usually assume that an overflow raises an
33  * error, which is the standard behavior in high level programming languages.
34  * `SafeMath` restores this intuition by reverting the transaction when an
35  * operation overflows.
36  *
37  * Using this library instead of the unchecked operations eliminates an entire
38  * class of bugs, so it's recommended to use it always.
39  */
40 library SafeMath {
41     /**
42      * @dev Returns the addition of two unsigned integers, reverting on
43      * overflow.
44      *
45      * Counterpart to Solidity's `+` operator.
46      *
47      * Requirements:
48      * - Addition cannot overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "SafeMath: addition overflow");
53 
54         return c;
55     }
56 
57     /**
58      * @dev Returns the subtraction of two unsigned integers, reverting on
59      * overflow (when the result is negative).
60      *
61      * Counterpart to Solidity's `-` operator.
62      *
63      * Requirements:
64      * - Subtraction cannot overflow.
65      */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a, "SafeMath: subtraction overflow");
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the multiplication of two unsigned integers, reverting on
75      * overflow.
76      *
77      * Counterpart to Solidity's `*` operator.
78      *
79      * Requirements:
80      * - Multiplication cannot overflow.
81      */
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
84         // benefit is lost if 'b' is also tested.
85         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
86         if (a == 0) {
87             return 0;
88         }
89 
90         uint256 c = a * b;
91         require(c / a == b, "SafeMath: multiplication overflow");
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the integer division of two unsigned integers. Reverts on
98      * division by zero. The result is rounded towards zero.
99      *
100      * Counterpart to Solidity's `/` operator. Note: this function uses a
101      * `revert` opcode (which leaves remaining gas untouched) while Solidity
102      * uses an invalid opcode to revert (consuming all remaining gas).
103      *
104      * Requirements:
105      * - The divisor cannot be zero.
106      */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Solidity only automatically asserts when dividing by 0
109         require(b > 0, "SafeMath: division by zero");
110         uint256 c = a / b;
111         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
118      * Reverts when dividing by zero.
119      *
120      * Counterpart to Solidity's `%` operator. This function uses a `revert`
121      * opcode (which leaves remaining gas untouched) while Solidity uses an
122      * invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      * - The divisor cannot be zero.
126      */
127     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
128         require(b != 0, "SafeMath: modulo by zero");
129         return a % b;
130     }
131 }
132 
133 contract CardExchange {
134     using SafeMath for uint256;
135 
136     ////////////////////////////////////////////////
137     //////// V A R I A B L E S
138     //
139     // Current address of the Gods Unchained cards (CARD) token contract.
140     //
141     GodsUnchainedCards constant public godsUnchainedCards = GodsUnchainedCards(0x0E3A2A1f2146d86A604adc220b4967A898D7Fe07);
142     //
143     // Mapping of all buy orders.
144     //
145     mapping (address => mapping(uint256 => BuyOrder)) public buyOrdersById;
146     //
147     // Mapping of all sell orders.
148     //
149     mapping (address => mapping(uint256 => SellOrder)) public sellOrdersById;
150     //
151     // EIP712 sellOrder implementation, to safely create sell orders without chain interaction.
152     //
153     string private constant domain = "EIP712Domain(string name)";
154     bytes32 public constant domainTypeHash = keccak256(abi.encodePacked(domain));
155     bytes32 private domainSeparator = keccak256(abi.encode(domainTypeHash, keccak256("Sell Gods Unchained cards on gu.cards")));
156     string private constant sellOrdersForTokenIdsType = "SellOrders(uint256[] ids,uint256[] tokenIds,uint256[] prices)";
157     bytes32 public constant sellOrdersForTokenIdsTypeHash = keccak256(abi.encodePacked(sellOrdersForTokenIdsType));
158     string private constant sellOrdersForProtosAndQualitiesType = "SellOrders(uint256[] ids,uint256[] protos,uint256[] qualities,uint256[] prices)";
159     bytes32 public constant sellOrdersForProtosAndQualitiesTypeHash = keccak256(abi.encodePacked(sellOrdersForProtosAndQualitiesType));
160     //
161     // Accumulated locked funds from binding buy orders are save from contract killing or withdraw
162     // until the orders are executed or canceled.
163     //
164     uint256 public lockedInFunds;
165     //
166     // In case the exchange needs to be paused.
167     //
168     bool public paused;
169     //
170     // Exchange fee. 
171     // Devided by 1000 than applied to the price.
172     // e.g. 25 = 2.5%
173     //
174     uint256 public exchangeFee;
175     //
176     // Standard contract ownership.
177     //
178     address payable public owner;
179     address payable private nextOwner;
180     
181     ////////////////////////////////////////////////
182     //////// E V E N T S
183     //
184     event BuyOrderCreated(uint256 id);
185     event SellOrderCreated(uint256 id);
186     event BuyOrderCanceled(uint256 id);
187     event SellOrderCanceled(uint256 id);
188     event Settled(uint256 buyOrderId, uint256 sellOrderId);
189 
190     ////////////////////////////////////////////////
191     //////// S T R U C T S
192     //
193     //  An instruction from an orderer to buy a card.
194     //
195     struct BuyOrder {
196         //
197         // The id of the buy order.
198         //
199         uint256 id;
200         //
201         // Price in wei.
202         //
203         uint256 price;
204         //
205         // Exchange fee set the moment buy order is created.
206         //
207         uint256 fee;
208         //
209         // Which concrete card.
210         //
211         uint16 proto;
212         //
213         // The quality of the card.
214         //
215         uint8 quality;
216         //
217         // Where to send the card or refund to.
218         //
219         address payable buyer;
220         //
221         // Has the order been settled yet?
222         //
223         bool settled;
224         //
225         // Has the order been canceled yet?
226         //
227         bool canceled;
228     }
229     //
230     //  An instruction from a seller to sell a concrete card (token) for a certain amount of ETH.
231     //
232     struct SellOrder {
233         //
234         // The id of the sell order.
235         //
236         uint256 id;
237         //
238         // The concrete token id of the card.
239         //
240         uint256 tokenId;
241         //
242         // Which concrete card.
243         //
244         uint16 proto;
245         //
246         // The quality of the card.
247         //
248         uint8 quality;
249         //
250         // Price in wei.
251         //
252         uint256 price;
253         //
254         // Where to send the ETH to?
255         //
256         address payable seller;
257         //
258         // Has the order been settled yet?
259         //
260         bool settled;
261         //
262         // Has the order been canceled yet?
263         //
264         bool canceled;
265         //
266         // Has the orders tokenId been set?
267         // tokenId 0 is actually an existing token.
268         //
269         bool tokenIsSet;
270     }
271 
272     ////////////////////////////////////////////////
273     //////// M O D I F I E R S
274     //
275     // Invokable only by contract owner.
276     //
277     modifier onlyOwner {
278         require(msg.sender == owner, "Function called by non-owner.");
279         _;
280     }
281     //
282     // Invokable only if exchange is not paused.
283     //
284     modifier onlyUnpaused {
285         require(paused == false, "Exchange is paused.");
286         _;
287     }
288 
289     ////////////////////////////////////////////////
290     //////// C O N S T R U C T O R
291     //
292     // Sets the contract owner
293     // and initalizes the EIP712 domain separator.
294     //
295     constructor() public {
296         owner = msg.sender;
297     }
298 
299     ////////////////////////////////////////////////
300     //////// F U N C T I O N S
301     //
302     // Public method to create one or multiple buy orders.
303     //
304     function createBuyOrders(uint256[] calldata ids, uint256[] calldata protos, uint256[] calldata prices, uint256[] calldata qualities) onlyUnpaused external payable {
305         _createBuyOrders(ids, protos, prices, qualities);
306     }
307     //
308     // Public Method to create one or multiple buy orders and settles them right after.
309     //
310     function createBuyOrdersAndSettle(uint256[] calldata orderData, uint256[] calldata sellOrderIds, uint256[] calldata tokenIds, address[] calldata sellOrderAddresses) onlyUnpaused external payable {
311         uint256[] memory buyOrderIds = _unpackOrderData(orderData, 0);
312         _createBuyOrders(
313             buyOrderIds,
314             _unpackOrderData(orderData, 1),
315             _unpackOrderData(orderData, 3),
316             _unpackOrderData(orderData, 2)
317         );
318         uint256 length = tokenIds.length;
319         for (uint256 i = 0; i < length; i++) {
320             _updateSellOrderTokenId(sellOrdersById[sellOrderAddresses[i]][sellOrderIds[i]], tokenIds[i]);
321             _settle(
322                 buyOrdersById[msg.sender][buyOrderIds[i]],
323                 sellOrdersById[sellOrderAddresses[i]][sellOrderIds[i]]
324             );
325         }
326     }
327     //
328     // Public method to create a single buy order and settle with offchain/onchain sell order for token ids.
329     // Dedicated for offchain listings, use createBuyOrdersAndSettle otherwise.
330     //
331     // orderData[0] == buyOrderId
332     // orderData[1] == buyOrderProto
333     // orderData[2] == buyOrderPrice
334     // orderData[3] == buyOrderQuality
335     // orderData[4] == sellOrderId
336     //
337     function createBuyOrderAndSettleWithOffChainSellOrderForTokenIds(uint256[] calldata orderData, address sellOrderAddress, uint256[] calldata sellOrderIds, uint256[] calldata sellOrderTokenIds, uint256[] calldata sellOrderPrices, uint8 v, bytes32 r, bytes32 s) onlyUnpaused external payable {
338         _ensureBuyOrderPrice(orderData[2]);
339         _createBuyOrder(orderData[0], uint16(orderData[1]), orderData[2], uint8(orderData[3]));
340         _createOffChainSignedSellOrdersForTokenIds(sellOrderIds, sellOrderTokenIds, sellOrderPrices, v, r, s);
341         _settle(buyOrdersById[msg.sender][orderData[0]], sellOrdersById[sellOrderAddress][orderData[4]]);
342     }
343     //
344     // Public method to create a single buy order and settle with offchain/onchain sell order for proto and qualities.
345     // Dedicated for offchain listings, use createBuyOrdersAndSettle otherwise.
346     //
347     function createBuyOrderAndSettleWithOffChainSellOrderForProtosAndQualities(uint256 buyOrderId, uint16 buyOrderProto, uint256 buyOrderPrice, uint8 buyOrderQuality, uint256 sellOrderId, address sellOrderAddress, uint256 tokenId, uint256[] calldata sellOrderData, uint8 v, bytes32 r, bytes32 s) onlyUnpaused external payable {
348         _ensureBuyOrderPrice(buyOrderPrice);
349         _createBuyOrder(buyOrderId, buyOrderProto, buyOrderPrice, buyOrderQuality);
350         _createOffChainSignedSellOrdersForProtosAndQualities(
351             _unpackOrderData(sellOrderData, 0),
352             _unpackOrderData(sellOrderData, 1),
353             _unpackOrderData(sellOrderData, 2),
354             _unpackOrderData(sellOrderData, 3),
355             v,
356             r,
357             s
358         );
359         _updateSellOrderTokenId(sellOrdersById[sellOrderAddress][sellOrderId], tokenId);
360         _settle(buyOrdersById[msg.sender][buyOrderId], sellOrdersById[sellOrderAddress][sellOrderId]);
361     }
362     //
363     // Ensures buy order pice is bigger than zero 
364     // and send ether is more then buy order price + fee.
365     //
366     function _ensureBuyOrderPrice(uint256 price) private view {
367         require(
368             msg.value >= (price.add(price.mul(exchangeFee).div(1000))) &&
369             price > 0,
370             "Amount sent to the contract needs to cover at least this buy order's price and fee (and needs to be bigger than 0)."
371         );
372     }
373     //
374     // Internal, private method to unpack order data
375     // Parts:
376     // 0    ids
377     // 1    protos
378     // 2    qualities
379     // 3    prices
380     //
381     function _unpackOrderData(uint256[] memory orderData, uint256 part) private pure returns (uint256[] memory data) {
382         uint256 length = orderData.length/4;
383         uint256[] memory returnData = new uint256[](length);
384         for (uint256 i = 0; i < length; i++) {
385             returnData[i] = orderData[i*4+part];
386         }
387         return returnData;
388     }
389     //
390     // Internal, private method to create buy orders.
391     //
392     function _createBuyOrders(uint256[] memory ids, uint256[] memory protos, uint256[] memory prices, uint256[] memory qualities) private {
393         uint256 totalAmountToPay = 0;
394         uint256 length = ids.length;
395 
396         for (uint256 i = 0; i < length; i++) {
397             _createBuyOrder(ids[i], uint16(protos[i]), prices[i], uint8(qualities[i]));
398             totalAmountToPay = totalAmountToPay.add(
399                 prices[i].add(prices[i].mul(exchangeFee).div(1000))
400             );
401         }
402         
403         require(msg.value >= totalAmountToPay && msg.value > 0, "ETH sent to the contract is insufficient (prices + exchange fees)!");
404     }
405     //
406     // Internal, private method to create a single buy order.
407     //
408     function _createBuyOrder(uint256 id, uint16 proto, uint256 price, uint8 quality) private {
409         BuyOrder storage buyOrder = buyOrdersById[msg.sender][id];
410         require(buyOrder.id == 0, "Buy order with this ID does already exist!");
411         buyOrder.id = id;
412         buyOrder.proto = proto;
413         buyOrder.price = price;
414         buyOrder.fee = price.mul(exchangeFee).div(1000);
415         buyOrder.quality = quality;
416         buyOrder.buyer = msg.sender;
417         
418         lockedInFunds = lockedInFunds.add(buyOrder.price.add(buyOrder.fee));
419 
420         emit BuyOrderCreated(buyOrder.id);
421     }
422     //
423     // Public method to cancel buy orders.
424     //
425     function cancelBuyOrders(uint256[] calldata ids) external {
426         uint256 length = ids.length;
427         for (uint256 i = 0; i < length; i++) {
428             BuyOrder storage buyOrder = buyOrdersById[msg.sender][ids[i]];
429             require(buyOrder.settled == false, "Order has already been settled!");
430             require(buyOrder.canceled == false, "Order has already been canceled!");
431             buyOrder.canceled = true; // prevent reentrancy, before transfer
432             lockedInFunds = lockedInFunds.sub(buyOrder.price.add(buyOrder.fee));
433             buyOrder.buyer.transfer(buyOrder.price.add(buyOrder.fee)); // refund
434             emit BuyOrderCanceled(buyOrder.id);
435         }
436     }
437     //
438     // Public method to creates sell orders for token ids.
439     //
440     function createSellOrdersForTokenIds(uint256[] calldata ids, uint256[] calldata prices, uint256[] calldata tokenIds) onlyUnpaused external {
441         _createSellOrdersForTokenIds(ids, prices, tokenIds, msg.sender);
442     }
443     //
444     // Internal, private method to create sell orders.
445     //
446     function _createSellOrdersForTokenIds(uint256[] memory ids, uint256[] memory prices, uint256[] memory tokenIds, address payable seller) private {
447         uint256 length = ids.length;
448         for (uint256 i = 0; i < length; i++) {
449             _createSellOrderForTokenId(ids[i], prices[i], tokenIds[i], seller);
450         }
451     }
452     //
453     // Internal, private method to create sell orders for token ids.
454     //
455     function _createSellOrderForTokenId(uint256 id, uint256 price, uint256 tokenId, address seller) private {
456         _createSellOrder(
457             id,
458             price,
459             tokenId,
460             godsUnchainedCards.getProto(tokenId),
461             godsUnchainedCards.getQuality(tokenId),
462             seller,
463             true
464         );
465     }
466      //
467     // Public method to creates sell orders for protos and qualities.
468     //
469     function createSellOrdersForProtosAndQualities(uint256[] calldata ids, uint256[] calldata prices, uint256[] calldata protos, uint256[] calldata qualities) onlyUnpaused external {
470         _createSellOrdersForProtosAndQualities(ids, prices, protos, qualities, msg.sender);
471     }
472     //
473     // Internal, private method to create sell orders.
474     //
475     function _createSellOrdersForProtosAndQualities(uint256[] memory ids, uint256[] memory prices, uint256[] memory protos, uint256[] memory qualities, address payable seller) private {
476         uint256 length = ids.length;
477         for (uint256 i = 0; i < length; i++) {
478             _createSellOrderForProtoAndQuality(ids[i], prices[i], protos[i], qualities[i], seller);
479         }
480     }
481     //
482     // Internal, private method to create sell orders for token ids.
483     //
484     function _createSellOrderForProtoAndQuality(uint256 id, uint256 price, uint256 proto, uint256 quality, address seller) private {
485         _createSellOrder(
486             id,
487             price,
488             0,
489             proto,
490             quality,
491             seller,
492             false
493         );
494     }
495     //
496     // Internal, private method to create sell orders.
497     //
498     function _createSellOrder(uint256 id, uint256 price, uint256 tokenId, uint256 proto, uint256 quality, address seller, bool tokenIsSet) private {
499         address payable payableSeller = address(uint160(seller));
500         require(price > 0, "Sell order price needs to be bigger than 0.");
501 
502         SellOrder storage sellOrder = sellOrdersById[seller][id];
503         require(sellOrder.id == 0, "Sell order with this ID does already exist!");
504         require(godsUnchainedCards.isApprovedForAll(payableSeller, address(this)), "Operator approval missing!");
505         sellOrder.id = id;
506         sellOrder.price = price;
507         sellOrder.proto = uint16(proto);
508         sellOrder.quality = uint8(quality);
509         sellOrder.seller = payableSeller;
510         
511         if(tokenIsSet) { _updateSellOrderTokenId(sellOrder, tokenId); }
512         
513         emit SellOrderCreated(sellOrder.id);
514     }
515     //
516     // Internal, private method to update sell order tokenId.
517     //
518     function _updateSellOrderTokenId(SellOrder storage sellOrder, uint256 tokenId) private {
519         if(
520             sellOrder.tokenIsSet ||
521             sellOrder.canceled ||
522             sellOrder.settled
523         ) { return; }
524         require(godsUnchainedCards.ownerOf(tokenId) == sellOrder.seller, "Seller is not owner of this token!");
525         require(
526             sellOrder.proto == godsUnchainedCards.getProto(tokenId) &&
527             sellOrder.quality == godsUnchainedCards.getQuality(tokenId)
528             , "Token does not correspond to sell order proto/quality!"
529         );
530         sellOrder.tokenIsSet = true;
531         sellOrder.tokenId = tokenId;
532     }
533     //
534     // Public method to create sell orders for token ids and settle (e.g. into existing buy orders).
535     //
536     function createSellOrdersForTokenIdsAndSettle(uint256[] calldata sellOrderIds, address[] calldata sellOrderAddresses, uint256[] calldata sellOrderPrices, uint256[] calldata sellOrderTokenIds, uint256[] calldata buyOrderIds, address[] calldata buyOrderAddresses) onlyUnpaused external {
537         _createSellOrdersForTokenIds(sellOrderIds, sellOrderPrices, sellOrderTokenIds, msg.sender);
538         _settle(buyOrderIds, buyOrderAddresses, sellOrderIds, sellOrderAddresses);
539     }
540     //
541     // Turns sell orders created off chain into onchain sell orders for token ids.
542     //
543     function createOffChainSignedSellOrdersForTokenIds(uint256[] calldata sellOrderIds, uint256[] calldata sellOrderTokenIds, uint256[] calldata sellOrderPrices, uint8 v, bytes32 r, bytes32 s) onlyUnpaused external {
544         _createOffChainSignedSellOrdersForTokenIds(sellOrderIds, sellOrderTokenIds, sellOrderPrices, v, r, s);
545     }
546     //
547     // Internal private method to turn off chain sell orders into on chain sell orders for token ids.
548     //
549     function _createOffChainSignedSellOrdersForTokenIds(uint256[] memory sellOrderIds, uint256[] memory sellOrderTokenIds, uint256[] memory sellOrderPrices, uint8 v, bytes32 r, bytes32 s) private {
550         uint256 length = sellOrderIds.length;
551         address seller = _recoverForTokenIds(sellOrderIds, sellOrderTokenIds, sellOrderPrices, v, r, s);
552         for (
553             uint256 i = 0;
554             i < length;
555             i++
556         ) {
557             if(sellOrdersById[seller][sellOrderIds[i]].id == 0) {
558                 // onchain sell order does not exist yet, create it
559                 _createSellOrderForTokenId(
560                     sellOrderIds[i],
561                     sellOrderPrices[i],
562                     sellOrderTokenIds[i],
563                     seller
564                 );
565             }
566         }
567     }
568     //
569     // Public method to create sell orders for protos and qualities and settle (e.g. into existing buy orders).
570     //
571     function createSellOrdersForProtosAndQualitiesAndSettle(uint256[] calldata sellOrderData, uint256[] calldata tokenIds, uint256[] calldata buyOrderIds, address[] calldata buyOrderAddresses) onlyUnpaused external {
572         uint256[] memory sellOrderIds = _unpackOrderData(sellOrderData, 0);
573         _createSellOrdersForProtosAndQualities(
574             sellOrderIds,
575             _unpackOrderData(sellOrderData, 3),
576             _unpackOrderData(sellOrderData, 1),
577             _unpackOrderData(sellOrderData, 2),
578             msg.sender
579         );
580         uint256 length = buyOrderIds.length;
581         for (uint256 i = 0; i < length; i++) {
582           _updateSellOrderTokenId(sellOrdersById[msg.sender][sellOrderIds[i]], tokenIds[i]);
583           _settle(buyOrdersById[buyOrderAddresses[i]][buyOrderIds[i]], sellOrdersById[msg.sender][sellOrderIds[i]]);
584         }
585     }
586     //
587     // Turns sell orders created off chain into onchain sell orders for protos and qualities.
588     //
589     function createOffChainSignedSellOrdersForProtosAndQualities(uint256[] calldata sellOrderIds, uint256[] calldata sellOrderProtos, uint256[] calldata sellOrderQualities, uint256[] calldata sellOrderPrices, uint8 v, bytes32 r, bytes32 s) onlyUnpaused external {
590         _createOffChainSignedSellOrdersForProtosAndQualities(sellOrderIds, sellOrderProtos, sellOrderQualities, sellOrderPrices, v, r, s);
591     }
592     //
593     // Internal private method to turn off chain sell orders into on chain sell orders for protos and qualities.
594     //
595     function _createOffChainSignedSellOrdersForProtosAndQualities(uint256[] memory sellOrderIds, uint256[] memory sellOrderProtos, uint256[] memory sellOrderQualities, uint256[] memory sellOrderPrices, uint8 v, bytes32 r, bytes32 s) private {
596         uint256 length = sellOrderIds.length;
597         address seller = _recoverForProtosAndQualities(sellOrderIds, sellOrderProtos, sellOrderQualities, sellOrderPrices, v, r, s);
598         for (
599             uint256 i = 0;
600             i < length;
601             i++
602         ) {
603             if(sellOrdersById[seller][sellOrderIds[i]].id == 0) {
604                 // onchain sell order does not exist yet, create it
605                 _createSellOrderForProtoAndQuality(
606                     sellOrderIds[i],
607                     sellOrderPrices[i],
608                     sellOrderProtos[i],
609                     sellOrderQualities[i],
610                     seller
611                 );
612             }
613         }
614     }
615     //
616     // Public method that allows to recover an off chain sell order for token ids
617     //
618     function recoverSellOrderForTokenIds(uint256[] calldata ids, uint256[] calldata tokenIds, uint256[] calldata prices,  uint8 v, bytes32 r, bytes32 s) external view returns (address) {
619         return _recoverForTokenIds(ids, tokenIds, prices, v, r, s);
620     }
621     //
622     // Internal, private method to recover off chain sell order
623     //
624     function _recoverForTokenIds(uint256[] memory ids, uint256[] memory tokenIds, uint256[] memory prices, uint8 v, bytes32 r, bytes32 s) private view returns (address) {
625         return ecrecover(hashSellOrdersForTokenIds(ids, tokenIds, prices), v, r, s);
626     }
627     //
628     // Internal, private method to hash a sell orders for token ids
629     //
630     function hashSellOrdersForTokenIds(uint256[] memory ids, uint256[] memory tokenIds, uint256[] memory prices) private view returns (bytes32){
631         return keccak256(abi.encodePacked(
632            "\x19\x01",
633            domainSeparator,
634            keccak256(abi.encode(
635                 sellOrdersForTokenIdsTypeHash,
636                 keccak256(abi.encodePacked(ids)),
637                 keccak256(abi.encodePacked(tokenIds)),
638                 keccak256(abi.encodePacked(prices))
639             ))
640         ));
641     }
642     //
643     // Public method that allows to recover an off chain sell order for token ids
644     //
645     function recoverSellOrderForProtosAndQualities(uint256[] calldata ids, uint256[] calldata protos, uint256[] calldata qualities, uint256[] calldata prices,  uint8 v, bytes32 r, bytes32 s) external view returns (address) {
646         return _recoverForProtosAndQualities(ids, protos, qualities, prices, v, r, s);
647     }
648     //
649     // Internal, private method to recover off chain sell orders for protos and qualities
650     //
651     function _recoverForProtosAndQualities(uint256[] memory ids, uint256[] memory protos, uint256[] memory qualities, uint256[] memory prices, uint8 v, bytes32 r, bytes32 s) private view returns (address) {
652         return ecrecover(hashSellOrdersForProtosAndQualitiesIds(ids, protos, qualities, prices), v, r, s);
653     }
654      //
655     // Internal, private method to hash a sell order for protos & qualities
656     //
657     function hashSellOrdersForProtosAndQualitiesIds(uint256[] memory ids, uint256[] memory protos, uint256[] memory qualities, uint256[] memory prices) private view returns (bytes32){
658         return keccak256(abi.encodePacked(
659            "\x19\x01",
660            domainSeparator,
661            keccak256(abi.encode(
662                 sellOrdersForProtosAndQualitiesTypeHash,
663                 keccak256(abi.encodePacked(ids)),
664                 keccak256(abi.encodePacked(protos)),
665                 keccak256(abi.encodePacked(qualities)),
666                 keccak256(abi.encodePacked(prices))
667             ))
668         ));
669     }
670     //
671     // Cancels sell orders.
672     //
673     function cancelSellOrders(uint256[] calldata ids) onlyUnpaused external {
674         uint256 length = ids.length;
675         for (uint256 i = 0; i < length; i++) {
676             SellOrder storage sellOrder = sellOrdersById[msg.sender][ids[i]];
677             if(sellOrder.id == 0) { // off-chain sell order
678                 sellOrder.id = ids[i];
679             }
680             require(sellOrder.canceled == false, "Order has already been canceled!");
681             require(sellOrder.settled == false, "Order has already been settled!");
682             sellOrder.canceled = true;
683             emit SellOrderCanceled(sellOrder.id);
684         }
685     }
686     //
687     // Public method to settle buy and sell orders (transfers cards for ETH).
688     //
689     function settle(uint256[] calldata buyOrderIds, address[] calldata buyOrderAddresses, uint256[] calldata sellOrderIds, address[] calldata sellOrderAddresses) onlyUnpaused external {
690         _settle(buyOrderIds, buyOrderAddresses, sellOrderIds, sellOrderAddresses);
691     }
692     //
693     // Public method to settle .
694     //
695     function settleWithToken(uint256[] calldata buyOrderIds, address[] calldata buyOrderAddresses, uint256[] calldata sellOrderIds, address[] calldata sellOrderAddresses, uint256[] calldata tokenIds) onlyUnpaused external {
696         uint256 length = tokenIds.length;
697         for (uint256 i = 0; i < length; i++) {
698           _updateSellOrderTokenId(
699               sellOrdersById[sellOrderAddresses[i]][sellOrderIds[i]],
700               tokenIds[i]
701           );
702           _settle(buyOrdersById[buyOrderAddresses[i]][buyOrderIds[i]], sellOrdersById[sellOrderAddresses[i]][sellOrderIds[i]]);
703         }
704     }
705     //
706     // Internal, private method to settle buy orders with sell order.
707     //
708     function _settle(uint256[] memory buyOrderIds, address[] memory buyOrderAddresses, uint256[] memory sellOrderIds, address[] memory sellOrderAddresses) private {
709         uint256 length = buyOrderIds.length;
710         for (uint256 i = 0; i < length; i++) {
711             _settle(
712                 buyOrdersById[buyOrderAddresses[i]][buyOrderIds[i]],
713                 sellOrdersById[sellOrderAddresses[i]][sellOrderIds[i]]
714             );
715         }
716     }
717     //
718     // Internal, private method to settle a buy order with a sell order.
719     function _settle(BuyOrder storage buyOrder, SellOrder storage sellOrder) private {
720         if(
721             sellOrder.settled || sellOrder.canceled ||
722             buyOrder.settled || buyOrder.canceled
723         ) { return; }
724 
725         uint256 proto = godsUnchainedCards.getProto(sellOrder.tokenId);
726         uint256 quality = godsUnchainedCards.getQuality(sellOrder.tokenId);
727         require(buyOrder.price >= sellOrder.price, "Sell order exceeds what the buyer is willing to pay!");
728         require(buyOrder.proto == proto && sellOrder.proto == proto, "Order protos are not matching!");
729         require(buyOrder.quality == quality && sellOrder.quality == quality, "Order qualities are not matching!");
730         
731         sellOrder.settled = buyOrder.settled = true; // prevent reentrancy, before transfer or unlocking funds
732         lockedInFunds = lockedInFunds.sub(buyOrder.price.add(buyOrder.fee));
733         godsUnchainedCards.transferFrom(sellOrder.seller, buyOrder.buyer, sellOrder.tokenId);
734         sellOrder.seller.transfer(sellOrder.price);
735 
736         emit Settled(buyOrder.id, sellOrder.id);
737     }
738     //
739     // Public method to pause or unpause the exchange.
740     //
741     function setPausedTo(bool value) external onlyOwner {
742         paused = value;
743     }
744     //
745     // Set exchange fee.
746     //
747     function setExchangeFee(uint256 value) external onlyOwner {
748         exchangeFee = value;
749     }
750     //
751     // Funds withdrawal, considers unresolved orders and keeps user funds save.
752     //
753     function withdraw(address payable beneficiary, uint256 amount) external onlyOwner {
754         require(lockedInFunds.add(amount) <= address(this).balance, "Not enough funds. Funds are partially locked from unsettled buy orders.");
755         beneficiary.transfer(amount);
756     }
757     //
758     // Standard contract ownership transfer.
759     //
760     function approveNextOwner(address payable _nextOwner) external onlyOwner {
761         require(_nextOwner != owner, "Cannot approve current owner.");
762         nextOwner = _nextOwner;
763     }
764     //
765     // Accept the next owner.
766     //
767     function acceptNextOwner() external {
768         require(msg.sender == nextOwner, "The new owner has to accept the previously set new owner.");
769         owner = nextOwner;
770     }
771     //
772     // Contract may be destroyed only when there are no ongoing orders and no locked in funds.
773     // So it would be required to either refund everybody or resolve all the orders,
774     // before the contract can be killed
775     //
776     function kill() external onlyOwner {
777         require(lockedInFunds == 0, "All orders need to be settled or refundeded before self-destruct.");
778         selfdestruct(owner);
779     }
780     //
781     // Fallback function deliberately left empty. It's primary use case
782     // is to top up the exchange.
783     //
784     function () external payable {}
785     
786 }