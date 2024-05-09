1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 contract ERC20Basic {
70   uint256 public totalSupply;
71   function balanceOf(address who) public view returns (uint256);
72   function transfer(address to, uint256 value) public returns (bool);
73   event Transfer(address indexed from, address indexed to, uint256 value);
74 }
75 
76 contract ERC20 is ERC20Basic {
77   function allowance(address owner, address spender) public view returns (uint256);
78   function transferFrom(address from, address to, uint256 value) public returns (bool);
79   function approve(address spender, uint256 value) public returns (bool);
80   event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 library ArrayUtils {
84 
85     /**
86      * Replace bytes in an array with bytes in another array, guarded by a "bytemask"
87      * 
88      * @dev Mask must be 1/8th the size of the byte array. A 1-bit means the byte array can be changed.
89      * @param array The original array
90      * @param desired The target array
91      * @param mask The mask specifying which bytes can be changed
92      * @return The updated byte array (the parameter will be modified inplace)
93      */
94     function guardedArrayReplace(bytes memory array, bytes memory desired, bytes memory mask)
95         pure
96         internal
97     {
98         byte[8] memory bitmasks = [byte(2 ** 7), byte(2 ** 6), byte(2 ** 5), byte(2 ** 4), byte(2 ** 3), byte(2 ** 2), byte(2 ** 1), byte(2 ** 0)];
99         require(array.length == desired.length);
100         require(mask.length >= array.length / 8);
101         bool masked;
102         for (uint i = 0; i < array.length; i++ ) {
103             /* 1-bit means value can be changed. */
104             masked = (mask[i / 8] & bitmasks[i % 8]) == 0;
105             if (!masked) {
106                 array[i] = desired[i];
107             }
108         }
109     }
110 
111     /**
112      * Test if two arrays are equal
113      * 
114      * @dev Arrays must be of equal length, otherwise will return false
115      * @param a First array
116      * @param b Second array
117      * @return Whether or not all bytes in the arrays are equal
118      */
119     function arrayEq(bytes memory a, bytes memory b)
120         pure
121         internal
122         returns (bool)
123     {
124         if (a.length != b.length) {
125             return false;
126         }
127         for (uint i = 0; i < a.length; i++) {
128             if (a[i] != b[i]) {
129                 return false;
130             }
131         }
132         return true;
133     }
134 
135 }
136 
137 contract ReentrancyGuarded {
138 
139     bool reentrancyLock = false;
140 
141     /* Prevent a contract function from being reentrant-called. */
142     modifier reentrancyGuard {
143         if (reentrancyLock) {
144             revert();
145         }
146         reentrancyLock = true;
147         _;
148         reentrancyLock = false;
149     }
150 
151 }
152 
153 contract TokenRecipient {
154     event ReceivedEther(address indexed sender, uint amount);
155     event ReceivedTokens(address indexed from, uint256 value, address indexed token, bytes extraData);
156 
157     /**
158      * @dev Receive tokens and generate a log event
159      * @param from Address from which to transfer tokens
160      * @param value Amount of tokens to transfer
161      * @param token Address of token
162      * @param extraData Additional data to log
163      */
164     function receiveApproval(address from, uint256 value, address token, bytes extraData) public {
165         ERC20 t = ERC20(token);
166         require(t.transferFrom(from, this, value));
167         ReceivedTokens(from, value, token, extraData);
168     }
169 
170     /**
171      * @dev Receive Ether and generate a log event
172      */
173     function () payable public {
174         ReceivedEther(msg.sender, msg.value);
175     }
176 }
177 
178 contract ExchangeCore is ReentrancyGuarded, Ownable {
179 
180     /* The token used to pay exchange fees. */
181     ERC20 public exchangeToken;
182 
183     /* User registry. */
184     ProxyRegistry public registry;
185 
186     /* Token transfer proxy. */
187     TokenTransferProxy public tokenTransferProxy;
188 
189     /* Cancelled / finalized orders, by hash. */
190     mapping(bytes32 => bool) public cancelledOrFinalized;
191 
192     /* Orders verified by on-chain approval (alternative to ECDSA signatures so that smart contracts can place orders directly). */
193     mapping(bytes32 => bool) public approvedOrders;
194 
195     /* For split fee orders, minimum required protocol maker fee, in basis points. Paid to owner (who can change it). */
196     uint public minimumMakerProtocolFee = 0;
197 
198     /* For split fee orders, minimum required protocol taker fee, in basis points. Paid to owner (who can change it). */
199     uint public minimumTakerProtocolFee = 0;
200 
201     /* Recipient of protocol fees. */
202     address public protocolFeeRecipient;
203 
204     /* Fee method: protocol fee or split fee. */
205     enum FeeMethod { ProtocolFee, SplitFee }
206 
207     /* Inverse basis point. */
208     uint public constant INVERSE_BASIS_POINT = 10000;
209 
210     /* An ECDSA signature. */ 
211     struct Sig {
212         /* v parameter */
213         uint8 v;
214         /* r parameter */
215         bytes32 r;
216         /* s parameter */
217         bytes32 s;
218     }
219 
220     /* An order on the exchange. */
221     struct Order {
222         /* Exchange address, intended as a versioning mechanism. */
223         address exchange;
224         /* Order maker address. */
225         address maker;
226         /* Order taker address, if specified. */
227         address taker;
228         /* Maker relayer fee of the order, unused for taker order. */
229         uint makerRelayerFee;
230         /* Taker relayer fee of the order, or maximum taker fee for a taker order. */
231         uint takerRelayerFee;
232         /* Maker protocol fee of the order, unused for taker order. */
233         uint makerProtocolFee;
234         /* Taker protocol fee of the order, or maximum taker fee for a taker order. */
235         uint takerProtocolFee;
236         /* Order fee recipient or zero address for taker order. */
237         address feeRecipient;
238         /* Fee method (protocol token or split fee). */
239         FeeMethod feeMethod;
240         /* Side (buy/sell). */
241         SaleKindInterface.Side side;
242         /* Kind of sale. */
243         SaleKindInterface.SaleKind saleKind;
244         /* Target. */
245         address target;
246         /* HowToCall. */
247         AuthenticatedProxy.HowToCall howToCall;
248         /* Calldata. */
249         bytes calldata;
250         /* Calldata replacement pattern, or an empty byte array for no replacement. */
251         bytes replacementPattern;
252         /* Static call target, zero-address for no static call. */
253         address staticTarget;
254         /* Static call extra data. */
255         bytes staticExtradata;
256         /* Token used to pay for the order, or the zero-address as a sentinel value for Ether. */
257         ERC20 paymentToken;
258         /* Base price of the order (in paymentTokens). */
259         uint basePrice;
260         /* Auction extra parameter - minimum bid increment for English auctions, starting/ending price difference. */
261         uint extra;
262         /* Listing timestamp. */
263         uint listingTime;
264         /* Expiration timestamp - 0 for no expiry. */
265         uint expirationTime;
266         /* Order salt, used to prevent duplicate hashes. */
267         uint salt;
268     }
269     
270     event OrderApprovedPartOne    (bytes32 indexed hash, address exchange, address indexed maker, address taker, uint makerRelayerFee, uint takerRelayerFee, uint makerProtocolFee, uint takerProtocolFee, address indexed feeRecipient, FeeMethod feeMethod, SaleKindInterface.Side side, SaleKindInterface.SaleKind saleKind, address target);
271     event OrderApprovedPartTwo    (bytes32 indexed hash, AuthenticatedProxy.HowToCall howToCall, bytes calldata, bytes replacementPattern, address staticTarget, bytes staticExtradata, ERC20 paymentToken, uint basePrice, uint extra, uint listingTime, uint expirationTime, uint salt, bool orderbookInclusionDesired);
272     event OrderCancelled          (bytes32 indexed hash);
273     event OrdersMatched           (bytes32 buyHash, bytes32 sellHash, address indexed maker, address indexed taker, uint price, bytes32 indexed metadata);
274 
275     /**
276      * @dev Change the minimum maker fee paid to the protocol (owner only)
277      * @param newMinimumMakerProtocolFee New fee to set in basis points
278      */
279     function changeMinimumMakerProtocolFee(uint newMinimumMakerProtocolFee)
280         public
281         onlyOwner
282     {
283         minimumMakerProtocolFee = newMinimumMakerProtocolFee;
284     }
285 
286     /**
287      * @dev Change the minimum taker fee paid to the protocol (owner only)
288      * @param newMinimumTakerProtocolFee New fee to set in basis points
289      */
290     function changeMinimumTakerProtocolFee(uint newMinimumTakerProtocolFee)
291         public
292         onlyOwner
293     {
294         minimumTakerProtocolFee = newMinimumTakerProtocolFee;
295     }
296 
297     /**
298      * @dev Change the protocol fee recipient (owner only)
299      * @param newProtocolFeeRecipient New protocol fee recipient address
300      */
301     function changeProtocolFeeRecipient(address newProtocolFeeRecipient)
302         public
303         onlyOwner
304     {
305         protocolFeeRecipient = newProtocolFeeRecipient;
306     }
307 
308     /**
309      * @dev Transfer tokens
310      * @param token Token to transfer
311      * @param from Address to charge fees
312      * @param to Address to receive fees
313      * @param amount Amount of protocol tokens to charge
314      */
315     function transferTokens(address token, address from, address to, uint amount)
316         internal
317     {
318         if (amount > 0) {
319             require(tokenTransferProxy.transferFrom(token, from, to, amount));
320         }
321     }
322 
323     /**
324      * @dev Charge a fee in protocol tokens
325      * @param from Address to charge fees
326      * @param to Address to receive fees
327      * @param amount Amount of protocol tokens to charge
328      */
329     function chargeProtocolFee(address from, address to, uint amount)
330         internal
331     {
332         transferTokens(exchangeToken, from, to, amount);
333     }
334 
335     /**
336      * @dev Execute a STATICCALL (introduced with Ethereum Metropolis, non-state-modifying external call)
337      * @param target Contract to call
338      * @param calldata Calldata (appended to extradata)
339      * @param extradata Base data for STATICCALL (probably function selector and argument encoding)
340      * @return The result of the call (success or failure)
341      */
342     function staticCall(address target, bytes memory calldata, bytes memory extradata)
343         public
344         view
345         returns (bool result)
346     {
347         bytes memory combined = new bytes(SafeMath.add(calldata.length, extradata.length));
348         for (uint i = 0; i < extradata.length; i++) {
349             combined[i] = extradata[i];
350         }
351         for (uint j = 0; j < calldata.length; j++) {
352             combined[j + extradata.length] = calldata[j];
353         }
354         assembly {
355             result := staticcall(gas, target, add(combined, 0x20), mload(combined), mload(0x40), 0)
356         }
357         return result;
358     }
359 
360     /**
361      * @dev Keccak256 order hash, part one
362      * @param order Order to hash
363      * @return Part one of the order hash 
364      */
365     function hashOrderPartOne(Order memory order)
366         internal
367         pure
368         returns (bytes32)
369     {
370         return keccak256(order.exchange, order.maker, order.taker, order.makerRelayerFee, order.takerRelayerFee, order.makerProtocolFee, order.takerProtocolFee, order.feeRecipient, order.feeMethod, order.side, order.saleKind, order.target, order.howToCall);
371     }
372 
373     /**
374      * @dev Keccak256 order hash, part two
375      * @param order Order to hash
376      * @return Part two of the order hash
377      */
378     function hashOrderPartTwo(Order memory order)
379         internal
380         pure
381         returns (bytes32)
382     {
383         return keccak256(order.calldata, order.replacementPattern, order.staticTarget, order.staticExtradata, order.paymentToken, order.basePrice, order.extra, order.listingTime, order.expirationTime, order.salt);
384     }
385 
386     /**
387      * @dev Hash an order, returning the hash that a client must sign, including the standard message prefix
388      * @param order Order to hash
389      * @return Hash of message prefix, order hash part one, and order hash part two concatenated
390      */
391     function hashToSign(Order memory order)
392         internal
393         pure
394         returns (bytes32)
395     {
396         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
397         bytes32 hash = keccak256(prefix, hashOrderPartOne(order), hashOrderPartTwo(order));
398         return hash;
399     }
400 
401     /**
402      * @dev Assert an order is valid and return its hash
403      * @param order Order to validate
404      * @param sig ECDSA signature
405      */
406     function requireValidOrder(Order memory order, Sig memory sig)
407         internal
408         view
409         returns (bytes32)
410     {
411         bytes32 hash = hashToSign(order);
412         require(validateOrder(hash, order, sig));
413         return hash;
414     }
415 
416     /**
417      * @dev Validate order parameters (does *not* check signature validity)
418      * @param order Order to validate
419      */
420     function validateOrderParameters(Order memory order)
421         internal
422         view
423         returns (bool)
424     {
425         /* Order must be targeted at this protocol version (this Exchange contract). */
426         if (order.exchange != address(this)) {
427             return false;
428         }
429 
430         /* Order must possess valid sale kind parameter combination. */
431         if (!SaleKindInterface.validateParameters(order.saleKind, order.expirationTime)) {
432             return false;
433         }
434 
435         /* If using the split fee method, order must have sufficient protocol fees. */
436         if (order.feeMethod == FeeMethod.SplitFee && (order.makerProtocolFee < minimumMakerProtocolFee || order.takerProtocolFee < minimumTakerProtocolFee)) {
437             return false;
438         }
439 
440         return true;
441     }
442 
443     /**
444      * @dev Validate a provided previously approved / signed order, hash, and signature.
445      * @param hash Order hash (already calculated, passed to avoid recalculation)
446      * @param order Order to validate
447      * @param sig ECDSA signature
448      */
449     function validateOrder(bytes32 hash, Order memory order, Sig memory sig) 
450         internal
451         view
452         returns (bool)
453     {
454         /* Not done in an if-conditional to prevent unnecessary ecrecover evaluation, which seems to happen even though it should short-circuit. */
455 
456         /* Order must have valid parameters. */
457         if (!validateOrderParameters(order)) {
458             return false;
459         }
460 
461         /* Order must have not been canceled or already filled. */
462         if (cancelledOrFinalized[hash]) {
463             return false;
464         }
465         
466         /* Order authentication. Order must be either:
467         /* (a) previously approved */
468         if (approvedOrders[hash]) {
469             return true;
470         }
471 
472         /* or (b) ECDSA-signed by maker. */
473         if (ecrecover(hash, sig.v, sig.r, sig.s) == order.maker) {
474             return true;
475         }
476 
477         return false;
478     }
479 
480     /**
481      * @dev Approve an order and optionally mark it for orderbook inclusion. Must be called by the maker of the order
482      * @param order Order to approve
483      * @param orderbookInclusionDesired Whether orderbook providers should include the order in their orderbooks
484      */
485     function approveOrder(Order memory order, bool orderbookInclusionDesired)
486         internal
487     {
488         /* CHECKS */
489 
490         /* Assert sender is authorized to approve order. */
491         require(msg.sender == order.maker);
492 
493         /* Calculate order hash. */
494         bytes32 hash = hashToSign(order);
495 
496         /* Assert order has not already been approved. */
497         require(!approvedOrders[hash]);
498 
499         /* EFFECTS */
500     
501         /* Mark order as approved. */
502         approvedOrders[hash] = true;
503   
504         /* Log approval event. Must be split in two due to Solidity stack size limitations. */
505         {
506             OrderApprovedPartOne(hash, order.exchange, order.maker, order.taker, order.makerRelayerFee, order.takerRelayerFee, order.makerProtocolFee, order.takerProtocolFee, order.feeRecipient, order.feeMethod, order.side, order.saleKind, order.target);
507         }
508         {   
509             OrderApprovedPartTwo(hash, order.howToCall, order.calldata, order.replacementPattern, order.staticTarget, order.staticExtradata, order.paymentToken, order.basePrice, order.extra, order.listingTime, order.expirationTime, order.salt, orderbookInclusionDesired);
510         }
511     }
512 
513     /**
514      * @dev Cancel an order, preventing it from being matched. Must be called by the maker of the order
515      * @param order Order to cancel
516      * @param sig ECDSA signature
517      */
518     function cancelOrder(Order memory order, Sig memory sig) 
519         internal
520     {
521         /* CHECKS */
522 
523         /* Calculate order hash. */
524         bytes32 hash = requireValidOrder(order, sig);
525 
526         /* Assert sender is authorized to cancel order. */
527         require(msg.sender == order.maker);
528   
529         /* EFFECTS */
530       
531         /* Mark order as cancelled, preventing it from being matched. */
532         cancelledOrFinalized[hash] = true;
533 
534         /* Log cancel event. */
535         OrderCancelled(hash);
536     }
537 
538     /**
539      * @dev Calculate the current price of an order (convenience function)
540      * @param order Order to calculate the price of
541      * @return The current price of the order
542      */
543     function calculateCurrentPrice (Order memory order)
544         internal  
545         view
546         returns (uint)
547     {
548         return SaleKindInterface.calculateFinalPrice(order.side, order.saleKind, order.basePrice, order.extra, order.listingTime, order.expirationTime);
549     }
550 
551     /**
552      * @dev Calculate the price two orders would match at, if in fact they would match (otherwise fail)
553      * @param buy Buy-side order
554      * @param sell Sell-side order
555      * @return Match price
556      */
557     function calculateMatchPrice(Order memory buy, Order memory sell)
558         view
559         internal
560         returns (uint)
561     {
562         /* Calculate sell price. */
563         uint sellPrice = SaleKindInterface.calculateFinalPrice(sell.side, sell.saleKind, sell.basePrice, sell.extra, sell.listingTime, sell.expirationTime);
564 
565         /* Calculate buy price. */
566         uint buyPrice = SaleKindInterface.calculateFinalPrice(buy.side, buy.saleKind, buy.basePrice, buy.extra, buy.listingTime, buy.expirationTime);
567 
568         /* Require price cross. */
569         require(buyPrice >= sellPrice);
570         
571         /* Maker/taker priority. */
572         return sell.feeRecipient != address(0) ? sellPrice : buyPrice;
573     }
574 
575     /**
576      * @dev Execute all ERC20 token / Ether transfers associated with an order match (fees and buyer => seller transfer)
577      * @param buy Buy-side order
578      * @param sell Sell-side order
579      */
580     function executeFundsTransfer(Order memory buy, Order memory sell)
581         internal
582         returns (uint)
583     {
584         /* Only payable in the special case of unwrapped Ether. */
585         if (sell.paymentToken != address(0)) {
586             require(msg.value == 0);
587         }
588 
589         /* Calculate match price. */
590         uint price = calculateMatchPrice(buy, sell);
591 
592         /* If paying using a token (not Ether), transfer tokens. This is done prior to fee payments to that a seller will have tokens before being charged fees. */
593         if (price > 0 && sell.paymentToken != address(0)) {
594             transferTokens(sell.paymentToken, buy.maker, sell.maker, price);
595         }
596 
597         /* Amount that will be received by seller (for Ether). */
598         uint receiveAmount = price;
599 
600         /* Amount that must be sent by buyer (for Ether). */
601         uint requiredAmount = price;
602 
603         /* Determine maker/taker and charge fees accordingly. */
604         if (sell.feeRecipient != address(0)) {
605             /* Sell-side order is maker. */
606       
607             /* Assert taker fee is less than or equal to maximum fee specified by buyer. */
608             require(sell.takerRelayerFee <= buy.takerRelayerFee);
609 
610             if (sell.feeMethod == FeeMethod.SplitFee) {
611                 /* Assert taker fee is less than or equal to maximum fee specified by buyer. */
612                 require(sell.takerProtocolFee <= buy.takerProtocolFee);
613 
614                 /* Maker fees are deducted from the token amount that the maker receives. Taker fees are extra tokens that must be paid by the taker. */
615 
616                 if (sell.makerRelayerFee > 0) {
617                     uint makerRelayerFee = SafeMath.div(SafeMath.mul(sell.makerRelayerFee, price), INVERSE_BASIS_POINT);
618                     if (sell.paymentToken == address(0)) {
619                         receiveAmount = SafeMath.sub(receiveAmount, makerRelayerFee);
620                         sell.feeRecipient.transfer(makerRelayerFee);
621                     } else {
622                         transferTokens(sell.paymentToken, sell.maker, sell.feeRecipient, makerRelayerFee);
623                     }
624                 }
625 
626                 if (sell.takerRelayerFee > 0) {
627                     uint takerRelayerFee = SafeMath.div(SafeMath.mul(sell.takerRelayerFee, price), INVERSE_BASIS_POINT);
628                     if (sell.paymentToken == address(0)) {
629                         requiredAmount = SafeMath.add(requiredAmount, takerRelayerFee);
630                         sell.feeRecipient.transfer(takerRelayerFee);
631                     } else {
632                         transferTokens(sell.paymentToken, buy.maker, sell.feeRecipient, takerRelayerFee);
633                     }
634                 }
635 
636                 if (sell.makerProtocolFee > 0) {
637                     uint makerProtocolFee = SafeMath.div(SafeMath.mul(sell.makerProtocolFee, price), INVERSE_BASIS_POINT);
638                     if (sell.paymentToken == address(0)) {
639                         receiveAmount = SafeMath.sub(receiveAmount, makerProtocolFee);
640                         protocolFeeRecipient.transfer(makerProtocolFee);
641                     } else {
642                         transferTokens(sell.paymentToken, sell.maker, protocolFeeRecipient, makerProtocolFee);
643                     }
644                 }
645 
646                 if (sell.takerProtocolFee > 0) {
647                     uint takerProtocolFee = SafeMath.div(SafeMath.mul(sell.takerProtocolFee, price), INVERSE_BASIS_POINT);
648                     if (sell.paymentToken == address(0)) {
649                         requiredAmount = SafeMath.add(requiredAmount, takerProtocolFee);
650                         protocolFeeRecipient.transfer(takerProtocolFee);
651                     } else {
652                         transferTokens(sell.paymentToken, buy.maker, protocolFeeRecipient, takerProtocolFee);
653                     }
654                 }
655 
656             } else {
657                 /* Charge maker fee to seller. */
658                 chargeProtocolFee(sell.maker, sell.feeRecipient, sell.makerRelayerFee);
659 
660                 /* Charge taker fee to buyer. */
661                 chargeProtocolFee(buy.maker, sell.feeRecipient, sell.takerRelayerFee);
662             }
663         } else {
664             /* Buy-side order is maker. */
665 
666             /* Assert taker fee is less than or equal to maximum fee specified by seller. */
667             require(buy.takerRelayerFee <= sell.takerRelayerFee);
668 
669             if (sell.feeMethod == FeeMethod.SplitFee) {
670                 /* The Exchange does not escrow Ether, so direct Ether can only be used to with sell-side maker / buy-side taker orders. */
671                 require(sell.paymentToken != address(0));
672 
673                 /* Assert taker fee is less than or equal to maximum fee specified by seller. */
674                 require(buy.takerProtocolFee <= sell.takerProtocolFee);
675 
676                 if (buy.makerRelayerFee > 0) {
677                     makerRelayerFee = SafeMath.div(SafeMath.mul(buy.makerRelayerFee, price), INVERSE_BASIS_POINT);
678                     transferTokens(sell.paymentToken, buy.maker, buy.feeRecipient, makerRelayerFee);
679                 }
680 
681                 if (buy.takerRelayerFee > 0) {
682                     takerRelayerFee = SafeMath.div(SafeMath.mul(buy.takerRelayerFee, price), INVERSE_BASIS_POINT);
683                     transferTokens(sell.paymentToken, sell.maker, buy.feeRecipient, takerRelayerFee);
684                 }
685 
686                 if (buy.makerProtocolFee > 0) {
687                     makerProtocolFee = SafeMath.div(SafeMath.mul(buy.makerProtocolFee, price), INVERSE_BASIS_POINT);
688                     transferTokens(sell.paymentToken, buy.maker, protocolFeeRecipient, makerProtocolFee);
689                 }
690 
691                 if (buy.takerProtocolFee > 0) {
692                     takerProtocolFee = SafeMath.div(SafeMath.mul(buy.takerProtocolFee, price), INVERSE_BASIS_POINT);
693                     transferTokens(sell.paymentToken, sell.maker, protocolFeeRecipient, takerProtocolFee);
694                 }
695 
696             } else {
697                 /* Charge maker fee to buyer. */
698                 chargeProtocolFee(buy.maker, buy.feeRecipient, buy.makerRelayerFee);
699       
700                 /* Charge taker fee to seller. */
701                 chargeProtocolFee(sell.maker, buy.feeRecipient, buy.takerRelayerFee);
702             }
703         }
704 
705         if (sell.paymentToken == address(0)) {
706             /* Special-case Ether, order must be matched by buyer. */
707             require(msg.value >= requiredAmount);
708             sell.maker.transfer(receiveAmount);
709             /* Allow overshoot for variable-price auctions, refund difference. */
710             uint diff = SafeMath.sub(msg.value, requiredAmount);
711             if (diff > 0) {
712                 buy.maker.transfer(diff);
713             }
714         }
715 
716         /* This contract should never hold Ether, however, we cannot assert this, since it is impossible to prevent anyone from sending Ether e.g. with selfdestruct. */
717 
718         return price;
719     }
720 
721     /**
722      * @dev Return whether or not two orders can be matched with each other by basic parameters (does not check order signatures / calldata or perform static calls)
723      * @param buy Buy-side order
724      * @param sell Sell-side order
725      * @return Whether or not the two orders can be matched
726      */
727     function ordersCanMatch(Order memory buy, Order memory sell)
728         internal
729         view
730         returns (bool)
731     {
732         return (
733             /* Must be opposite-side. */
734             (buy.side == SaleKindInterface.Side.Buy && sell.side == SaleKindInterface.Side.Sell) &&     
735             /* Must use same fee method. */
736             (buy.feeMethod == sell.feeMethod) &&
737             /* Must use same payment token. */
738             (buy.paymentToken == sell.paymentToken) &&
739             /* Must match maker/taker addresses. */
740             (sell.taker == address(0) || sell.taker == buy.maker) &&
741             (buy.taker == address(0) || buy.taker == sell.maker) &&
742             /* One must be maker and the other must be taker (no bool XOR in Solidity). */
743             ((sell.feeRecipient == address(0) && buy.feeRecipient != address(0)) || (sell.feeRecipient != address(0) && buy.feeRecipient == address(0))) &&
744             /* Must match target. */
745             (buy.target == sell.target) &&
746             /* Must match howToCall. */
747             (buy.howToCall == sell.howToCall) &&
748             /* Buy-side order must be settleable. */
749             SaleKindInterface.canSettleOrder(buy.listingTime, buy.expirationTime) &&
750             /* Sell-side order must be settleable. */
751             SaleKindInterface.canSettleOrder(sell.listingTime, sell.expirationTime)
752         );
753     }
754 
755     /**
756      * @dev Atomically match two orders, ensuring validity of the match, and execute all associated state transitions. Protected against reentrancy by a contract-global lock.
757      * @param buy Buy-side order
758      * @param buySig Buy-side order signature
759      * @param sell Sell-side order
760      * @param sellSig Sell-side order signature
761      */
762     function atomicMatch(Order memory buy, Sig memory buySig, Order memory sell, Sig memory sellSig, bytes32 metadata)
763         internal
764         reentrancyGuard
765     {
766         /* CHECKS */
767       
768         /* Ensure buy order validity and calculate hash if necessary. */
769         bytes32 buyHash;
770         if (buy.maker == msg.sender) {
771             require(validateOrderParameters(buy));
772         } else {
773             buyHash = requireValidOrder(buy, buySig);
774         }
775 
776         /* Ensure sell order validity and calculate hash if necessary. */
777         bytes32 sellHash;
778         if (sell.maker == msg.sender) {
779             require(validateOrderParameters(sell));
780         } else {
781             sellHash = requireValidOrder(sell, sellSig);
782         }
783         
784         /* Must be matchable. */
785         require(ordersCanMatch(buy, sell));
786 
787         /* Target must exist (prevent malicious selfdestructs just prior to order settlement). */
788         uint size;
789         address target = sell.target;
790         assembly {
791             size := extcodesize(target)
792         }
793         require(size > 0);
794       
795         /* Must match calldata after replacement, if specified. */ 
796         if (buy.replacementPattern.length > 0) {
797           ArrayUtils.guardedArrayReplace(buy.calldata, sell.calldata, buy.replacementPattern);
798         }
799         if (sell.replacementPattern.length > 0) {
800           ArrayUtils.guardedArrayReplace(sell.calldata, buy.calldata, sell.replacementPattern);
801         }
802         require(ArrayUtils.arrayEq(buy.calldata, sell.calldata));
803 
804         /* Retrieve proxy (the registry contract is trusted). */
805         AuthenticatedProxy proxy = registry.proxies(sell.maker);
806 
807         /* Proxy must exist. */
808         require(proxy != address(0));
809 
810         /* EFFECTS */
811 
812         /* Mark previously signed or approved orders as finalized. */
813         if (msg.sender != buy.maker) {
814             cancelledOrFinalized[buyHash] = true;
815         }
816         if (msg.sender != sell.maker) {
817             cancelledOrFinalized[sellHash] = true;
818         }
819 
820         /* INTERACTIONS */
821 
822         /* Execute funds transfer and pay fees. */
823         uint price = executeFundsTransfer(buy, sell);
824 
825         /* Execute specified call through proxy. */
826         require(proxy.proxy(sell.target, sell.howToCall, sell.calldata));
827 
828         /* Static calls are intentionally done after the effectful call so they can check resulting state. */
829 
830         /* Handle buy-side static call if specified. */
831         if (buy.staticTarget != address(0)) {
832             require(staticCall(buy.staticTarget, sell.calldata, buy.staticExtradata));
833         }
834 
835         /* Handle sell-side static call if specified. */
836         if (sell.staticTarget != address(0)) {
837             require(staticCall(sell.staticTarget, sell.calldata, sell.staticExtradata));
838         }
839 
840         /* Log match event. */
841         OrdersMatched(buyHash, sellHash, sell.feeRecipient != address(0) ? sell.maker : buy.maker, sell.feeRecipient != address(0) ? buy.maker : sell.maker, price, metadata);
842     }
843 
844 }
845 
846 contract Exchange is ExchangeCore {
847 
848     /**
849      * @dev Call guardedArrayReplace - library function exposed for testing.
850      */
851     function guardedArrayReplace(bytes array, bytes desired, bytes mask)
852         public
853         pure
854         returns (bytes)
855     {
856         ArrayUtils.guardedArrayReplace(array, desired, mask);
857         return array;
858     }
859 
860     /**
861      * @dev Call calculateFinalPrice - library function exposed for testing.
862      */
863     function calculateFinalPrice(SaleKindInterface.Side side, SaleKindInterface.SaleKind saleKind, uint basePrice, uint extra, uint listingTime, uint expirationTime)
864         public
865         view
866         returns (uint)
867     {
868         return SaleKindInterface.calculateFinalPrice(side, saleKind, basePrice, extra, listingTime, expirationTime);
869     }
870 
871     /**
872      * @dev Call hashOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
873      */
874     function hashOrder_(
875         address[7] addrs,
876         uint[9] uints,
877         FeeMethod feeMethod,
878         SaleKindInterface.Side side,
879         SaleKindInterface.SaleKind saleKind,
880         AuthenticatedProxy.HowToCall howToCall,
881         bytes calldata,
882         bytes replacementPattern,
883         bytes staticExtradata)
884         public
885         pure
886         returns (bytes32)
887     { 
888         return hashToSign(
889           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8])
890         );
891     }
892 
893     /**
894      * @dev Call validateOrderParameters - Solidity ABI encoding limitation workaround, hopefully temporary.
895      */
896     function validateOrderParameters_ (
897         address[7] addrs,
898         uint[9] uints,
899         FeeMethod feeMethod,
900         SaleKindInterface.Side side,
901         SaleKindInterface.SaleKind saleKind,
902         AuthenticatedProxy.HowToCall howToCall,
903         bytes calldata,
904         bytes replacementPattern,
905         bytes staticExtradata)
906         view
907         public
908         returns (bool)
909     {
910         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
911         return validateOrderParameters(
912           order
913         );
914     }
915 
916     /**
917      * @dev Call validateOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
918      */
919     function validateOrder_ (
920         address[7] addrs,
921         uint[9] uints,
922         FeeMethod feeMethod,
923         SaleKindInterface.Side side,
924         SaleKindInterface.SaleKind saleKind,
925         AuthenticatedProxy.HowToCall howToCall,
926         bytes calldata,
927         bytes replacementPattern,
928         bytes staticExtradata,
929         uint8 v,
930         bytes32 r,
931         bytes32 s)
932         view
933         public
934         returns (bool)
935     {
936         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
937         return validateOrder(
938           hashToSign(order),
939           order,
940           Sig(v, r, s)
941         );
942     }
943 
944     /**
945      * @dev Call approveOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
946      */
947     function approveOrder_ (
948         address[7] addrs,
949         uint[9] uints,
950         FeeMethod feeMethod,
951         SaleKindInterface.Side side,
952         SaleKindInterface.SaleKind saleKind,
953         AuthenticatedProxy.HowToCall howToCall,
954         bytes calldata,
955         bytes replacementPattern,
956         bytes staticExtradata,
957         bool orderbookInclusionDesired) 
958         public
959     {
960         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
961         return approveOrder(order, orderbookInclusionDesired);
962     }
963 
964     /**
965      * @dev Call cancelOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
966      */
967     function cancelOrder_(
968         address[7] addrs,
969         uint[9] uints,
970         FeeMethod feeMethod,
971         SaleKindInterface.Side side,
972         SaleKindInterface.SaleKind saleKind,
973         AuthenticatedProxy.HowToCall howToCall,
974         bytes calldata,
975         bytes replacementPattern,
976         bytes staticExtradata,
977         uint8 v,
978         bytes32 r,
979         bytes32 s)
980         public
981     {
982 
983         return cancelOrder(
984           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]),
985           Sig(v, r, s)
986         );
987     }
988 
989     /**
990      * @dev Call calculateCurrentPrice - Solidity ABI encoding limitation workaround, hopefully temporary.
991      */
992     function calculateCurrentPrice_(
993         address[7] addrs,
994         uint[9] uints,
995         FeeMethod feeMethod,
996         SaleKindInterface.Side side,
997         SaleKindInterface.SaleKind saleKind,
998         AuthenticatedProxy.HowToCall howToCall,
999         bytes calldata,
1000         bytes replacementPattern,
1001         bytes staticExtradata)
1002         public
1003         view
1004         returns (uint)
1005     {
1006         return calculateCurrentPrice(
1007           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8])
1008         );
1009     }
1010 
1011     /**
1012      * @dev Call ordersCanMatch - Solidity ABI encoding limitation workaround, hopefully temporary.
1013      */
1014     function ordersCanMatch_(
1015         address[14] addrs,
1016         uint[18] uints,
1017         uint8[8] feeMethodsSidesKindsHowToCalls,
1018         bytes calldataBuy,
1019         bytes calldataSell,
1020         bytes replacementPatternBuy,
1021         bytes replacementPatternSell,
1022         bytes staticExtradataBuy,
1023         bytes staticExtradataSell)
1024         public
1025         view
1026         returns (bool)
1027     {
1028         Order memory buy = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1029         Order memory sell = Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17]);
1030         return ordersCanMatch(
1031           buy,
1032           sell
1033         );
1034     }
1035 
1036     /**
1037      * @dev Return whether or not two orders' calldata specifications can match
1038      * @param buyCalldata Buy-side order calldata
1039      * @param buyReplacementPattern Buy-side order calldata replacement mask
1040      * @param sellCalldata Sell-side order calldata
1041      * @param sellReplacementPattern Sell-side order calldata replacement mask
1042      * @return Whether the orders' calldata can be matched
1043      */
1044     function orderCalldataCanMatch(bytes buyCalldata, bytes buyReplacementPattern, bytes sellCalldata, bytes sellReplacementPattern)
1045         public
1046         pure
1047         returns (bool)
1048     {
1049         if (buyReplacementPattern.length > 0) {
1050           ArrayUtils.guardedArrayReplace(buyCalldata, sellCalldata, buyReplacementPattern);
1051         }
1052         if (sellReplacementPattern.length > 0) {
1053           ArrayUtils.guardedArrayReplace(sellCalldata, buyCalldata, sellReplacementPattern);
1054         }
1055         return ArrayUtils.arrayEq(buyCalldata, sellCalldata);
1056     }
1057 
1058     /**
1059      * @dev Call calculateMatchPrice - Solidity ABI encoding limitation workaround, hopefully temporary.
1060      */
1061     function calculateMatchPrice_(
1062         address[14] addrs,
1063         uint[18] uints,
1064         uint8[8] feeMethodsSidesKindsHowToCalls,
1065         bytes calldataBuy,
1066         bytes calldataSell,
1067         bytes replacementPatternBuy,
1068         bytes replacementPatternSell,
1069         bytes staticExtradataBuy,
1070         bytes staticExtradataSell)
1071         public
1072         view
1073         returns (uint)
1074     {
1075         Order memory buy = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1076         Order memory sell = Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17]);
1077         return calculateMatchPrice(
1078           buy,
1079           sell
1080         );
1081     }
1082 
1083     /**
1084      * @dev Call atomicMatch - Solidity ABI encoding limitation workaround, hopefully temporary.
1085      */
1086     function atomicMatch_(
1087         address[14] addrs,
1088         uint[18] uints,
1089         uint8[8] feeMethodsSidesKindsHowToCalls,
1090         bytes calldataBuy,
1091         bytes calldataSell,
1092         bytes replacementPatternBuy,
1093         bytes replacementPatternSell,
1094         bytes staticExtradataBuy,
1095         bytes staticExtradataSell,
1096         uint8[2] vs,
1097         bytes32[5] rssMetadata)
1098         public
1099         payable
1100     {
1101 
1102         return atomicMatch(
1103           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]),
1104           Sig(vs[0], rssMetadata[0], rssMetadata[1]),
1105           Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17]),
1106           Sig(vs[1], rssMetadata[2], rssMetadata[3]),
1107           rssMetadata[4]
1108         );
1109     }
1110 
1111 }
1112 
1113 contract WyvernExchange is Exchange {
1114 
1115     string public constant name = "Project Wyvern Exchange";
1116 
1117     string public constant version = "2";
1118 
1119     string public constant codename = "Bakunawa";
1120 
1121     /**
1122      * @dev Initialize a WyvernExchange instance
1123      * @param registryAddress Address of the registry instance which this Exchange instance will use
1124      * @param tokenAddress Address of the token used for protocol fees
1125      */
1126     function WyvernExchange (ProxyRegistry registryAddress, TokenTransferProxy tokenTransferProxyAddress, ERC20 tokenAddress, address protocolFeeAddress) public {
1127         registry = registryAddress;
1128         tokenTransferProxy = tokenTransferProxyAddress;
1129         exchangeToken = tokenAddress;
1130         protocolFeeRecipient = protocolFeeAddress;
1131         owner = msg.sender;
1132     }
1133 
1134 }
1135 
1136 library SaleKindInterface {
1137 
1138     /**
1139      * Side: buy or sell.
1140      */
1141     enum Side { Buy, Sell }
1142 
1143     /**
1144      * Currently supported kinds of sale: fixed price, Dutch auction. 
1145      * English auctions cannot be supported without stronger escrow guarantees.
1146      * Future interesting options: Vickrey auction, nonlinear Dutch auctions.
1147      */
1148     enum SaleKind { FixedPrice, DutchAuction }
1149 
1150     /**
1151      * @dev Check whether the parameters of a sale are valid
1152      * @param saleKind Kind of sale
1153      * @param expirationTime Order expiration time
1154      * @return Whether the parameters were valid
1155      */
1156     function validateParameters(SaleKind saleKind, uint expirationTime)
1157         pure
1158         internal
1159         returns (bool)
1160     {
1161         /* Auctions must have a set expiration date. */
1162         return (saleKind == SaleKind.FixedPrice || expirationTime > 0);
1163     }
1164 
1165     /**
1166      * @dev Return whether or not an order can be settled
1167      * @dev Precondition: parameters have passed validateParameters
1168      * @param listingTime Order listing time
1169      * @param expirationTime Order expiration time
1170      */
1171     function canSettleOrder(uint listingTime, uint expirationTime)
1172         view
1173         internal
1174         returns (bool)
1175     {
1176         return (listingTime < now) && (expirationTime == 0 || now < expirationTime);
1177     }
1178 
1179     /**
1180      * @dev Calculate the settlement price of an order
1181      * @dev Precondition: parameters have passed validateParameters.
1182      * @param side Order side
1183      * @param saleKind Method of sale
1184      * @param basePrice Order base price
1185      * @param extra Order extra price data
1186      * @param listingTime Order listing time
1187      * @param expirationTime Order expiration time
1188      */
1189     function calculateFinalPrice(Side side, SaleKind saleKind, uint basePrice, uint extra, uint listingTime, uint expirationTime)
1190         view
1191         internal
1192         returns (uint finalPrice)
1193     {
1194         if (saleKind == SaleKind.FixedPrice) {
1195             return basePrice;
1196         } else if (saleKind == SaleKind.DutchAuction) {
1197             uint diff = SafeMath.div(SafeMath.mul(extra, SafeMath.sub(now, listingTime)), SafeMath.sub(expirationTime, listingTime));
1198             if (side == Side.Sell) {
1199                 /* Sell-side - start price: basePrice. End price: basePrice - extra. */
1200                 return SafeMath.sub(basePrice, diff);
1201             } else {
1202                 /* Buy-side - start price: basePrice. End price: basePrice + extra. */
1203                 return SafeMath.add(basePrice, diff);
1204             }
1205         }
1206     }
1207 
1208 }
1209 
1210 contract AuthenticatedProxy is TokenRecipient {
1211 
1212     /* Address which owns this proxy. */
1213     address public user;
1214 
1215     /* Associated registry with contract authentication information. */
1216     ProxyRegistry public registry;
1217 
1218     /* Whether access has been revoked. */
1219     bool public revoked;
1220 
1221     /* Delegate call could be used to atomically transfer multiple assets owned by the proxy contract with one order. */
1222     enum HowToCall { Call, DelegateCall }
1223 
1224     /* Event fired when the proxy access is revoked or unrevoked. */
1225     event Revoked(bool revoked);
1226 
1227     /**
1228      * Create an AuthenticatedProxy
1229      *
1230      * @param addrUser Address of user on whose behalf this proxy will act
1231      * @param addrRegistry Address of ProxyRegistry contract which will manage this proxy
1232      */
1233     function AuthenticatedProxy(address addrUser, ProxyRegistry addrRegistry) public {
1234         user = addrUser;
1235         registry = addrRegistry;
1236     }
1237 
1238     /**
1239      * Set the revoked flag (allows a user to revoke ProxyRegistry access)
1240      *
1241      * @dev Can be called by the user only
1242      * @param revoke Whether or not to revoke access
1243      */
1244     function setRevoke(bool revoke)
1245         public
1246     {
1247         require(msg.sender == user);
1248         revoked = revoke;
1249         Revoked(revoke);
1250     }
1251 
1252     /**
1253      * Execute a message call from the proxy contract
1254      *
1255      * @dev Can be called by the user, or by a contract authorized by the registry as long as the user has not revoked access
1256      * @param dest Address to which the call will be sent
1257      * @param howToCall Which kind of call to make
1258      * @param calldata Calldata to send
1259      * @return Result of the call (success or failure)
1260      */
1261     function proxy(address dest, HowToCall howToCall, bytes calldata)
1262         public
1263         returns (bool result)
1264     {
1265         require(msg.sender == user || (!revoked && registry.contracts(msg.sender)));
1266         if (howToCall == HowToCall.Call) {
1267             result = dest.call(calldata);
1268         } else if (howToCall == HowToCall.DelegateCall) {
1269             result = dest.delegatecall(calldata);
1270         }
1271         return result;
1272     }
1273 
1274     /**
1275      * Execute a message call and assert success
1276      * 
1277      * @dev Same functionality as `proxy`, just asserts the return value
1278      * @param dest Address to which the call will be sent
1279      * @param howToCall What kind of call to make
1280      * @param calldata Calldata to send
1281      */
1282     function proxyAssert(address dest, HowToCall howToCall, bytes calldata)
1283         public
1284     {
1285         require(proxy(dest, howToCall, calldata));
1286     }
1287 
1288 }
1289 
1290 contract ProxyRegistry is Ownable {
1291 
1292     /* Authenticated proxies by user. */
1293     mapping(address => AuthenticatedProxy) public proxies;
1294 
1295     /* Contracts pending access. */
1296     mapping(address => uint) public pending;
1297 
1298     /* Contracts allowed to call those proxies. */
1299     mapping(address => bool) public contracts;
1300 
1301     /* Delay period for adding an authenticated contract.
1302        This mitigates a particular class of potential attack on the Wyvern DAO (which owns this registry) - if at any point the value of assets held by proxy contracts exceeded the value of half the WYV supply (votes in the DAO),
1303        a malicious but rational attacker could buy half the Wyvern and grant themselves access to all the proxy contracts. A delay period renders this attack nonthreatening - given two weeks, if that happened, users would have
1304        plenty of time to notice and transfer their assets.
1305     */
1306     uint public DELAY_PERIOD = 2 weeks;
1307 
1308     /**
1309      * Start the process to enable access for specified contract. Subject to delay period.
1310      *
1311      * @dev ProxyRegistry owner only
1312      * @param addr Address to which to grant permissions
1313      */
1314     function startGrantAuthentication (address addr)
1315         public
1316         onlyOwner
1317     {
1318         require(!contracts[addr] && pending[addr] == 0);
1319         pending[addr] = now;
1320     }
1321 
1322     /**
1323      * End the process to nable access for specified contract after delay period has passed.
1324      *
1325      * @dev ProxyRegistry owner only
1326      * @param addr Address to which to grant permissions
1327      */
1328     function endGrantAuthentication (address addr)
1329         public
1330         onlyOwner
1331     {
1332         require(!contracts[addr] && pending[addr] != 0 && ((pending[addr] + DELAY_PERIOD) < now));
1333         pending[addr] = 0;
1334         contracts[addr] = true;
1335     }
1336 
1337     /**
1338      * Revoke access for specified contract. Can be done instantly.
1339      *
1340      * @dev ProxyRegistry owner only
1341      * @param addr Address of which to revoke permissions
1342      */    
1343     function revokeAuthentication (address addr)
1344         public
1345         onlyOwner
1346     {
1347         contracts[addr] = false;
1348     }
1349 
1350     /**
1351      * Register a proxy contract with this registry
1352      *
1353      * @dev Must be called by the user which the proxy is for, creates a new AuthenticatedProxy
1354      * @return New AuthenticatedProxy contract
1355      */
1356     function registerProxy()
1357         public
1358         returns (AuthenticatedProxy proxy)
1359     {
1360         require(proxies[msg.sender] == address(0));
1361         proxy = new AuthenticatedProxy(msg.sender, this);
1362         proxies[msg.sender] = proxy;
1363         return proxy;
1364     }
1365 
1366 }
1367 
1368 contract TokenTransferProxy {
1369 
1370     /* Authentication registry. */
1371     ProxyRegistry public registry;
1372 
1373     /**
1374      * Call ERC20 `transferFrom`
1375      *
1376      * @dev Authenticated contract only
1377      * @param token ERC20 token address
1378      * @param from From address
1379      * @param to To address
1380      * @param amount Transfer amount
1381      */
1382     function transferFrom(address token, address from, address to, uint amount)
1383         public
1384         returns (bool)
1385     {
1386         require(registry.contracts(msg.sender));
1387         return ERC20(token).transferFrom(from, to, amount);
1388     }
1389 
1390 }