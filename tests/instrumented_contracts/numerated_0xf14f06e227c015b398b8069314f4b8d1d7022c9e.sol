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
101         for (uint i = 0; i < array.length; i++ ) {
102             /* 1-bit means value can be changed. */
103             bool masked = (mask[i / 8] & bitmasks[i % 8]) == 0;
104             if (!masked) {
105                 array[i] = desired[i];
106             }
107         }
108     }
109 
110     /**
111      * Test if two arrays are equal
112      * 
113      * @dev Arrays must be of equal length, otherwise will return false
114      * @param a First array
115      * @param b Second array
116      * @return Whether or not all bytes in the arrays are equal
117      */
118     function arrayEq(bytes memory a, bytes memory b)
119         pure
120         internal
121         returns (bool)
122     {
123         if (a.length != b.length) {
124             return false;
125         }
126         for (uint i = 0; i < a.length; i++) {
127             if (a[i] != b[i]) {
128                 return false;
129             }
130         }
131         return true;
132     }
133 
134 }
135 
136 contract ReentrancyGuarded {
137 
138     bool reentrancyLock = false;
139 
140     /* Prevent a contract function from being reentrant-called. */
141     modifier reentrancyGuard {
142         if (reentrancyLock) {
143             revert();
144         }
145         reentrancyLock = true;
146         _;
147         reentrancyLock = false;
148     }
149 
150 }
151 
152 contract TokenRecipient {
153     event ReceivedEther(address indexed sender, uint amount);
154     event ReceivedTokens(address indexed from, uint256 value, address indexed token, bytes extraData);
155 
156     /**
157      * @dev Receive tokens and generate a log event
158      * @param from Address from which to transfer tokens
159      * @param value Amount of tokens to transfer
160      * @param token Address of token
161      * @param extraData Additional data to log
162      */
163     function receiveApproval(address from, uint256 value, address token, bytes extraData) public {
164         ERC20 t = ERC20(token);
165         require(t.transferFrom(from, this, value));
166         ReceivedTokens(from, value, token, extraData);
167     }
168 
169     /**
170      * @dev Receive Ether and generate a log event
171      */
172     function () payable public {
173         ReceivedEther(msg.sender, msg.value);
174     }
175 }
176 
177 contract ExchangeCore is ReentrancyGuarded {
178 
179     /* The token used to pay exchange fees. */
180     ERC20 public exchangeToken;
181 
182     /* User registry. */
183     ProxyRegistry public registry;
184 
185     /* Cancelled / finalized orders, by hash. */
186     mapping(bytes32 => bool) public cancelledOrFinalized;
187 
188     /* Orders verified by on-chain approval (alternative to ECDSA signatures so that smart contracts can place orders directly). */
189     mapping(bytes32 => bool) public approvedOrders;
190 
191     /* An ECDSA signature. */ 
192     struct Sig {
193         /* v parameter */
194         uint8 v;
195         /* r parameter */
196         bytes32 r;
197         /* s parameter */
198         bytes32 s;
199     }
200 
201     /* An order on the exchange. */
202     struct Order {
203         /* Exchange address, intended as a versioning mechanism. */
204         address exchange;
205         /* Order maker address. */
206         address maker;
207         /* Order taker address, if specified. */
208         address taker;
209         /* Maker fee of the order (in Exchange fee tokens), unused for taker order. */
210         uint makerFee;
211         /* Taker fee of the order (in Exchange fee tokens), or maximum taker fee for a taker order. */
212         uint takerFee;
213         /* Order fee recipient or zero address for taker order. */
214         address feeRecipient;
215         /* Side (buy/sell). */
216         SaleKindInterface.Side side;
217         /* Kind of sale. */
218         SaleKindInterface.SaleKind saleKind;
219         /* Target. */
220         address target;
221         /* HowToCall. */
222         AuthenticatedProxy.HowToCall howToCall;
223         /* Calldata. */
224         bytes calldata;
225         /* Calldata replacement pattern. */
226         bytes replacementPattern;
227         /* Static call target, zero-address for no static call. */
228         address staticTarget;
229         /* Static call extra data. */
230         bytes staticExtradata;
231         /* Token used to pay for the order. */
232         ERC20 paymentToken;
233         /* Base price of the order (in paymentTokens). */
234         uint basePrice;
235         /* Auction extra parameter - minimum bid increment for English auctions, starting/ending price difference. */
236         uint extra;
237         /* Listing timestamp. */
238         uint listingTime;
239         /* Expiration timestamp - 0 for no expiry. */
240         uint expirationTime;
241         /* Order salt, used to prevent duplicate hashes. */
242         uint salt;
243     }
244     
245     event OrderApprovedPartOne    (bytes32 indexed hash, address exchange, address indexed maker, address taker, uint makerFee, uint takerFee, address indexed feeRecipient, SaleKindInterface.Side side, SaleKindInterface.SaleKind saleKind, address target, AuthenticatedProxy.HowToCall howToCall, bytes calldata);
246     event OrderApprovedPartTwo    (bytes32 indexed hash, bytes replacementPattern, address staticTarget, bytes staticExtradata, ERC20 paymentToken, uint basePrice, uint extra, uint listingTime, uint expirationTime, uint salt, bool orderbookInclusionDesired);
247     event OrderCancelled          (bytes32 indexed hash);
248     event OrdersMatched           (bytes32 buyHash, bytes32 sellHash, address indexed maker, address indexed taker, uint price, bytes32 indexed metadata);
249 
250     /**
251      * @dev Charge an address fees in protocol tokens
252      * @param from Address to charge fees
253      * @param to Address to receive fees
254      * @param amount Amount of protocol tokens to charge
255      */
256     function chargeFee(address from, address to, uint amount)
257         internal
258     {
259         if (amount > 0) {
260             require(exchangeToken.transferFrom(from, to, amount));
261         }
262     }
263 
264     /**
265      * @dev Execute a STATICCALL (introduced with Ethereum Metropolis, non-state-modifying external call)
266      * @param target Contract to call
267      * @param calldata Calldata (appended to extradata)
268      * @param extradata Base data for STATICCALL (probably function selector and argument encoding)
269      * @return The result of the call (success or failure)
270      */
271     function staticCall(address target, bytes memory calldata, bytes memory extradata)
272         public
273         view
274         returns (bool result)
275     {
276         bytes memory combined = new bytes(SafeMath.add(calldata.length, extradata.length));
277         for (uint i = 0; i < extradata.length; i++) {
278             combined[i] = extradata[i];
279         }
280         for (uint j = 0; j < calldata.length; j++) {
281             combined[j + extradata.length] = calldata[j];
282         }
283         assembly {
284             result := staticcall(gas, target, add(combined, 0x20), mload(combined), mload(0x40), 0)
285         }
286         return result;
287     }
288 
289     /**
290      * @dev Keccak256 order hash, part one
291      * @param order Order to hash
292      * @return Part one of the order hash 
293      */
294     function hashOrderPartOne(Order memory order)
295         internal
296         pure
297         returns (bytes32)
298     {
299         return keccak256(order.exchange, order.maker, order.taker, order.makerFee, order.takerFee, order.feeRecipient, order.side, order.saleKind, order.target, order.howToCall, order.calldata, order.replacementPattern);
300     }
301 
302     /**
303      * @dev Keccak256 order hash, part two
304      * @param order Order to hash
305      * @return Part two of the order hash
306      */
307     function hashOrderPartTwo(Order memory order)
308         internal
309         pure
310         returns (bytes32)
311     {
312         return keccak256(order.staticTarget, order.staticExtradata, order.paymentToken, order.basePrice, order.extra, order.listingTime, order.expirationTime, order.salt);
313     }
314 
315     /**
316      * @dev Hash an order, returning the hash that a client must sign, including the standard message prefix
317      * @param order Order to hash
318      * @return Hash of message prefix, order hash part one, and order hash part two concatenated
319      */
320     function hashToSign(Order memory order)
321         internal
322         pure
323         returns (bytes32)
324     {
325         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
326         bytes32 hash = keccak256(prefix, hashOrderPartOne(order), hashOrderPartTwo(order));
327         return hash;
328     }
329 
330     /**
331      * @dev Assert an order is valid and return its hash
332      * @param order Order to validate
333      * @param sig ECDSA signature
334      */
335     function requireValidOrder(Order memory order, Sig memory sig)
336         internal
337         view
338         returns (bytes32)
339     {
340         bytes32 hash = hashToSign(order);
341         require(validateOrder(hash, order, sig));
342         return hash;
343     }
344 
345     /**
346      * @dev Validate a provided order, hash, and signature
347      * @param hash Order hash (already calculated, passed to avoid recalculation)
348      * @param order Order to validate
349      * @param sig ECDSA signature
350      */
351     function validateOrder(bytes32 hash, Order memory order, Sig memory sig) 
352         internal
353         view
354         returns (bool)
355     {
356         /* Not done in an if-conditional to prevent unnecessary ecrecover evaluation, which seems to happen even though it should short-circuit. */
357 
358         /* Order must be targeted at this protocol version (this Exchange contract). */
359         if (order.exchange != address(this)) {
360             return false;
361         }
362 
363         /* Order must have not been canceled or already filled. */
364         if (cancelledOrFinalized[hash]) {
365             return false;
366         }
367         
368         /* Order must possess valid sale kind parameter combination. */
369         if (!SaleKindInterface.validateParameters(order.saleKind, order.expirationTime)) {
370             return false;
371         }
372 
373         /* Order authentication. Order must be either:
374            (a) sent by maker */
375         if (msg.sender == order.maker) {
376             return true;
377         }
378   
379         /* (b) previously approved */
380         if (approvedOrders[hash]) {
381             return true;
382         }
383 
384         /* or (c) ECDSA-signed by maker. */
385         if (ecrecover(hash, sig.v, sig.r, sig.s) == order.maker) {
386             return true;
387         }
388 
389         return false;
390     }
391 
392     /**
393      * @dev Approve an order and optionally mark it for orderbook inclusion. Must be called by the maker of the order
394      * @param order Order to approve
395      * @param orderbookInclusionDesired Whether orderbook providers should include the order in their orderbooks
396      */
397     function approveOrder(Order memory order, bool orderbookInclusionDesired)
398         internal
399     {
400         /* CHECKS */
401 
402         /* Assert sender is authorized to approve order. */
403         require(msg.sender == order.maker);
404 
405         /* Calculate order hash. */
406         bytes32 hash = hashToSign(order);
407 
408         /* Assert order has not already been approved. */
409         require(!approvedOrders[hash]);
410 
411         /* EFFECTS */
412     
413         /* Mark order as approved. */
414         approvedOrders[hash] = true;
415   
416         /* Log approval event. Must be split in two due to Solidity stack size limitations. */
417         {
418             OrderApprovedPartOne(hash, order.exchange, order.maker, order.taker, order.makerFee, order.takerFee, order.feeRecipient, order.side, order.saleKind, order.target, order.howToCall, order.calldata);
419         }
420         {   
421             OrderApprovedPartTwo(hash, order.replacementPattern, order.staticTarget, order.staticExtradata, order.paymentToken, order.basePrice, order.extra, order.listingTime, order.expirationTime, order.salt, orderbookInclusionDesired);
422         }
423     }
424 
425     /**
426      * @dev Cancel an order, preventing it from being matched. Must be called by the maker of the order
427      * @param order Order to cancel
428      * @param sig ECDSA signature
429      */
430     function cancelOrder(Order memory order, Sig memory sig) 
431         internal
432     {
433         /* CHECKS */
434 
435         /* Calculate order hash. */
436         bytes32 hash = requireValidOrder(order, sig);
437 
438         /* Assert sender is authorized to cancel order. */
439         require(msg.sender == order.maker);
440   
441         /* EFFECTS */
442       
443         /* Mark order as cancelled, preventing it from being matched. */
444         cancelledOrFinalized[hash] = true;
445 
446         /* Log cancel event. */
447         OrderCancelled(hash);
448     }
449 
450     /**
451      * @dev Calculate the current price of an order (convenience function)
452      * @param order Order to calculate the price of
453      * @return The current price of the order
454      */
455     function calculateCurrentPrice (Order memory order)
456         internal  
457         view
458         returns (uint)
459     {
460         return SaleKindInterface.calculateFinalPrice(order.side, order.saleKind, order.basePrice, order.extra, order.listingTime, order.expirationTime);
461     }
462 
463     /**
464      * @dev Calculate the price two orders would match at, if in fact they would match (otherwise fail)
465      * @param buy Buy-side order
466      * @param sell Sell-side order
467      * @return Match price
468      */
469     function calculateMatchPrice(Order memory buy, Order memory sell)
470         view
471         internal
472         returns (uint)
473     {
474         /* Calculate sell price. */
475         uint sellPrice = SaleKindInterface.calculateFinalPrice(sell.side, sell.saleKind, sell.basePrice, sell.extra, sell.listingTime, sell.expirationTime);
476 
477         /* Calculate buy price. */
478         uint buyPrice = SaleKindInterface.calculateFinalPrice(buy.side, buy.saleKind, buy.basePrice, buy.extra, buy.listingTime, buy.expirationTime);
479 
480         /* Require price cross. */
481         require(buyPrice >= sellPrice);
482         
483         /* Maker/taker priority. */
484         return sell.feeRecipient != address(0) ? sellPrice : buyPrice;
485     }
486 
487     /**
488      * @dev Execute all ERC20 token transfers associated with an order match (fees and buyer => seller transfer)
489      * @param buy Buy-side order
490      * @param sell Sell-side order
491      */
492     function executeFundsTransfer(Order memory buy, Order memory sell)
493         internal
494         returns (uint)
495     {
496         /* Calculate match price. */
497         uint price = calculateMatchPrice(buy, sell);
498 
499         /* Determine maker/taker and charge fees accordingly. */
500         if (sell.feeRecipient != address(0)) {
501             /* Sell-side order is maker. */
502       
503             /* Assert taker fee is less than or equal to maximum fee specified by buyer. */
504             require(sell.takerFee <= buy.takerFee);
505             
506             /* Charge maker fee to seller. */
507             chargeFee(sell.maker, sell.feeRecipient, sell.makerFee);
508 
509             /* Charge taker fee to buyer. */
510             chargeFee(buy.maker, sell.feeRecipient, sell.takerFee);
511         } else {
512             /* Buy-side order is maker. */
513 
514             /* Assert taker fee is less than or equal to maximum fee specified by seller. */
515             require(buy.takerFee <= sell.takerFee);
516 
517             /* Charge maker fee to buyer. */
518             chargeFee(buy.maker, buy.feeRecipient, buy.makerFee);
519       
520             /* Charge taker fee to seller. */
521             chargeFee(sell.maker, buy.feeRecipient, buy.takerFee);
522         }
523 
524         if (price > 0) {
525             /* Debit buyer and credit seller. */
526             require(sell.paymentToken.transferFrom(buy.maker, sell.maker, price));
527         }
528 
529         return price;
530     }
531 
532     /**
533      * @dev Return whether or not two orders can be matched with each other by basic parameters (does not check order signatures / calldata or perform static calls)
534      * @param buy Buy-side order
535      * @param sell Sell-side order
536      * @return Whether or not the two orders can be matched
537      */
538     function ordersCanMatch(Order memory buy, Order memory sell)
539         internal
540         view
541         returns (bool)
542     {
543         return (
544             /* Must be opposite-side. */
545             (buy.side == SaleKindInterface.Side.Buy && sell.side == SaleKindInterface.Side.Sell) &&     
546             /* Must use same payment token. */
547             (buy.paymentToken == sell.paymentToken) &&
548             /* Must match maker/taker addresses. */
549             (sell.taker == address(0) || sell.taker == buy.maker) &&
550             (buy.taker == address(0) || buy.taker == sell.maker) &&
551             /* One must be maker and the other must be taker (no bool XOR in Solidity). */
552             ((sell.feeRecipient == address(0) && buy.feeRecipient != address(0)) || (sell.feeRecipient != address(0) && buy.feeRecipient == address(0))) &&
553             /* Must match target. */
554             (buy.target == sell.target) &&
555             /* Must match howToCall. */
556             (buy.howToCall == sell.howToCall) &&
557             /* Buy-side order must be settleable. */
558             SaleKindInterface.canSettleOrder(buy.listingTime, buy.expirationTime) &&
559             /* Sell-side order must be settleable. */
560             SaleKindInterface.canSettleOrder(sell.listingTime, sell.expirationTime)
561         );
562     }
563 
564     /**
565      * @dev Match two orders, ensuring validity of the match, and execute all associated state transitions. Protected against reentrancy by a contract-global lock.
566      * @param buy Buy-side order
567      * @param buySig Buy-side order signature
568      * @param sell Sell-side order
569      * @param sellSig Sell-side order signature
570      */
571     function atomicMatch(Order memory buy, Sig memory buySig, Order memory sell, Sig memory sellSig, bytes32 metadata)
572         internal
573         reentrancyGuard
574     {
575         /* CHECKS */
576       
577         /* Ensure buy order validity and calculate hash. */
578         bytes32 buyHash = requireValidOrder(buy, buySig);
579 
580         /* Ensure sell order validity and calculate hash. */
581         bytes32 sellHash = requireValidOrder(sell, sellSig); 
582         
583         /* Must be matchable. */
584         require(ordersCanMatch(buy, sell));
585 
586         /* Target must exist (prevent malicious selfdestructs just prior to order settlement). */
587         uint size;
588         address target = sell.target;
589         assembly {
590             size := extcodesize(target)
591         }
592         require(size > 0);
593       
594         /* Must match calldata after replacement, if specified. */ 
595         if (buy.replacementPattern.length > 0) {
596           ArrayUtils.guardedArrayReplace(buy.calldata, sell.calldata, buy.replacementPattern);
597         }
598         if (sell.replacementPattern.length > 0) {
599           ArrayUtils.guardedArrayReplace(sell.calldata, buy.calldata, sell.replacementPattern);
600         }
601         require(ArrayUtils.arrayEq(buy.calldata, sell.calldata));
602 
603         /* Retrieve proxy (the registry contract is trusted). */
604         AuthenticatedProxy proxy = registry.proxies(sell.maker);
605 
606         /* Proxy must exist. */
607         require(proxy != address(0));
608 
609         /* EFFECTS */
610 
611         /* Mark orders as finalized. */
612         cancelledOrFinalized[buyHash] = true;
613         cancelledOrFinalized[sellHash] = true;
614 
615         /* INTERACTIONS */
616 
617         /* Execute funds transfer and pay fees. */
618         uint price = executeFundsTransfer(buy, sell);
619 
620         /* Execute specified call through proxy. */
621         require(proxy.proxy(sell.target, sell.howToCall, sell.calldata));
622 
623         /* Static calls are intentionally done after the effectful call so they can check resulting state. */
624 
625         /* Handle buy-side static call if specified. */
626         if (buy.staticTarget != address(0)) {
627             require(staticCall(buy.staticTarget, sell.calldata, buy.staticExtradata));
628         }
629 
630         /* Handle sell-side static call if specified. */
631         if (sell.staticTarget != address(0)) {
632             require(staticCall(sell.staticTarget, sell.calldata, sell.staticExtradata));
633         }
634 
635         /* Log match event. */
636         OrdersMatched(buyHash, sellHash, sell.feeRecipient != address(0) ? sell.maker : buy.maker, sell.feeRecipient != address(0) ? buy.maker : sell.maker, price, metadata);
637     }
638 
639 }
640 
641 contract Exchange is ExchangeCore {
642 
643     /**
644      * @dev Call guardedArrayReplace - library function exposed for testing.
645      */
646     function guardedArrayReplace(bytes array, bytes desired, bytes mask)
647         public
648         pure
649         returns (bytes)
650     {
651         ArrayUtils.guardedArrayReplace(array, desired, mask);
652         return array;
653     }
654 
655     /**
656      * @dev Call calculateFinalPrice - library function exposed for testing.
657      */
658     function calculateFinalPrice(SaleKindInterface.Side side, SaleKindInterface.SaleKind saleKind, uint basePrice, uint extra, uint listingTime, uint expirationTime)
659         public
660         view
661         returns (uint)
662     {
663         return SaleKindInterface.calculateFinalPrice(side, saleKind, basePrice, extra, listingTime, expirationTime);
664     }
665 
666     /**
667      * @dev Call hashOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
668      */
669     function hashOrder_(
670         address[7] addrs,
671         uint[7] uints,
672         SaleKindInterface.Side side,
673         SaleKindInterface.SaleKind saleKind,
674         AuthenticatedProxy.HowToCall howToCall,
675         bytes calldata,
676         bytes replacementPattern,
677         bytes staticExtradata)
678         public
679         pure
680         returns (bytes32)
681     { 
682         return hashToSign(
683           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], addrs[3], side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[2], uints[3], uints[4], uints[5], uints[6])
684         );
685     }
686 
687     /**
688      * @dev Call validateOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
689      */
690     function validateOrder_ (
691         address[7] addrs,
692         uint[7] uints,
693         SaleKindInterface.Side side,
694         SaleKindInterface.SaleKind saleKind,
695         AuthenticatedProxy.HowToCall howToCall,
696         bytes calldata,
697         bytes replacementPattern,
698         bytes staticExtradata,
699         uint8 v,
700         bytes32 r,
701         bytes32 s)
702         view
703         public
704         returns (bool)
705     {
706         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], addrs[3], side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[2], uints[3], uints[4], uints[5], uints[6]);
707         return validateOrder(
708           hashToSign(order),
709           order,
710           Sig(v, r, s)
711         );
712     }
713 
714     /**
715      * @dev Call approveOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
716      */
717     function approveOrder_ (
718         address[7] addrs,
719         uint[7] uints,
720         SaleKindInterface.Side side,
721         SaleKindInterface.SaleKind saleKind,
722         AuthenticatedProxy.HowToCall howToCall,
723         bytes calldata,
724         bytes replacementPattern,
725         bytes staticExtradata,
726         bool orderbookInclusionDesired) 
727         public
728     {
729         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], addrs[3], side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[2], uints[3], uints[4], uints[5], uints[6]);
730         return approveOrder(order, orderbookInclusionDesired);
731     }
732 
733     /**
734      * @dev Call cancelOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
735      */
736     function cancelOrder_(
737         address[7] addrs,
738         uint[7] uints,
739         SaleKindInterface.Side side,
740         SaleKindInterface.SaleKind saleKind,
741         AuthenticatedProxy.HowToCall howToCall,
742         bytes calldata,
743         bytes replacementPattern,
744         bytes staticExtradata,
745         uint8 v,
746         bytes32 r,
747         bytes32 s)
748         public
749     {
750 
751         return cancelOrder(
752           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], addrs[3], side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[2], uints[3], uints[4], uints[5], uints[6]),
753           Sig(v, r, s)
754         );
755     }
756 
757     /**
758      * @dev Call calculateCurrentPrice - Solidity ABI encoding limitation workaround, hopefully temporary.
759      */
760     function calculateCurrentPrice_(
761         address[7] addrs,
762         uint[7] uints,
763         SaleKindInterface.Side side,
764         SaleKindInterface.SaleKind saleKind,
765         AuthenticatedProxy.HowToCall howToCall,
766         bytes calldata,
767         bytes replacementPattern,
768         bytes staticExtradata)
769         public
770         view
771         returns (uint)
772     {
773         return calculateCurrentPrice(
774           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], addrs[3], side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[2], uints[3], uints[4], uints[5], uints[6])
775         );
776     }
777 
778     /**
779      * @dev Call ordersCanMatch - Solidity ABI encoding limitation workaround, hopefully temporary.
780      */
781     function ordersCanMatch_(
782         address[14] addrs,
783         uint[14] uints,
784         uint8[6] sidesKindsHowToCalls,
785         bytes calldataBuy,
786         bytes calldataSell,
787         bytes replacementPatternBuy,
788         bytes replacementPatternSell,
789         bytes staticExtradataBuy,
790         bytes staticExtradataSell)
791         public
792         view
793         returns (bool)
794     {
795         Order memory buy = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], addrs[3], SaleKindInterface.Side(sidesKindsHowToCalls[0]), SaleKindInterface.SaleKind(sidesKindsHowToCalls[1]), addrs[4], AuthenticatedProxy.HowToCall(sidesKindsHowToCalls[2]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[2], uints[3], uints[4], uints[5], uints[6]);
796         Order memory sell = Order(addrs[7], addrs[8], addrs[9], uints[7], uints[8], addrs[10], SaleKindInterface.Side(sidesKindsHowToCalls[3]), SaleKindInterface.SaleKind(sidesKindsHowToCalls[4]), addrs[11], AuthenticatedProxy.HowToCall(sidesKindsHowToCalls[5]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[9], uints[10], uints[11], uints[12], uints[13]);
797         return ordersCanMatch(
798           buy,
799           sell
800         );
801     }
802 
803     /**
804      * @dev Return whether or not two orders' calldata specifications can match
805      * @param buyCalldata Buy-side order calldata
806      * @param buyReplacementPattern Buy-side order calldata replacement mask
807      * @param sellCalldata Sell-side order calldata
808      * @param sellReplacementPattern Sell-side order calldata replacement mask
809      * @return Whether the orders' calldata can be matched
810      */
811     function orderCalldataCanMatch(bytes buyCalldata, bytes buyReplacementPattern, bytes sellCalldata, bytes sellReplacementPattern)
812         public
813         pure
814         returns (bool)
815     {
816         ArrayUtils.guardedArrayReplace(buyCalldata, sellCalldata, buyReplacementPattern);
817         ArrayUtils.guardedArrayReplace(sellCalldata, buyCalldata, sellReplacementPattern);
818         return ArrayUtils.arrayEq(buyCalldata, sellCalldata);
819     }
820 
821     /**
822      * @dev Call calculateMatchPrice - Solidity ABI encoding limitation workaround, hopefully temporary.
823      */
824     function calculateMatchPrice_(
825         address[14] addrs,
826         uint[14] uints,
827         uint8[6] sidesKindsHowToCalls,
828         bytes calldataBuy,
829         bytes calldataSell,
830         bytes replacementPatternBuy,
831         bytes replacementPatternSell,
832         bytes staticExtradataBuy,
833         bytes staticExtradataSell)
834         public
835         view
836         returns (uint)
837     {
838         Order memory buy = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], addrs[3], SaleKindInterface.Side(sidesKindsHowToCalls[0]), SaleKindInterface.SaleKind(sidesKindsHowToCalls[1]), addrs[4], AuthenticatedProxy.HowToCall(sidesKindsHowToCalls[2]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[2], uints[3], uints[4], uints[5], uints[6]);
839         Order memory sell = Order(addrs[7], addrs[8], addrs[9], uints[7], uints[8], addrs[10], SaleKindInterface.Side(sidesKindsHowToCalls[3]), SaleKindInterface.SaleKind(sidesKindsHowToCalls[4]), addrs[11], AuthenticatedProxy.HowToCall(sidesKindsHowToCalls[5]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[9], uints[10], uints[11], uints[12], uints[13]);
840         return calculateMatchPrice(
841           buy,
842           sell
843         );
844     }
845 
846     /**
847      * @dev Call atomicMatch - Solidity ABI encoding limitation workaround, hopefully temporary.
848      */
849     function atomicMatch_(
850         address[14] addrs,
851         uint[14] uints,
852         uint8[6] sidesKindsHowToCalls,
853         bytes calldataBuy,
854         bytes calldataSell,
855         bytes replacementPatternBuy,
856         bytes replacementPatternSell,
857         bytes staticExtradataBuy,
858         bytes staticExtradataSell,
859         uint8[2] vs,
860         bytes32[5] rssMetadata)
861         public
862     {
863         return atomicMatch(
864           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], addrs[3], SaleKindInterface.Side(sidesKindsHowToCalls[0]), SaleKindInterface.SaleKind(sidesKindsHowToCalls[1]), addrs[4], AuthenticatedProxy.HowToCall(sidesKindsHowToCalls[2]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[2], uints[3], uints[4], uints[5], uints[6]),
865           Sig(vs[0], rssMetadata[0], rssMetadata[1]),
866           Order(addrs[7], addrs[8], addrs[9], uints[7], uints[8], addrs[10], SaleKindInterface.Side(sidesKindsHowToCalls[3]), SaleKindInterface.SaleKind(sidesKindsHowToCalls[4]), addrs[11], AuthenticatedProxy.HowToCall(sidesKindsHowToCalls[5]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[9], uints[10], uints[11], uints[12], uints[13]),
867           Sig(vs[1], rssMetadata[2], rssMetadata[3]),
868           rssMetadata[4]
869         );
870     }
871 
872 }
873 
874 contract WyvernExchange is Exchange {
875 
876     string public constant name = "Project Wyvern Exchange";
877 
878     /**
879      * @dev Initialize a WyvernExchange instance
880      * @param registryAddress Address of the registry instance which this Exchange instance will use
881      * @param tokenAddress Address of the token used for protocol fees
882      */
883     function WyvernExchange (ProxyRegistry registryAddress, ERC20 tokenAddress) public {
884         exchangeToken = tokenAddress;
885         registry = registryAddress;
886     }
887 
888 }
889 
890 library SaleKindInterface {
891 
892     /**
893      * Side: buy or sell.
894      */
895     enum Side { Buy, Sell }
896 
897     /**
898      * Currently supported kinds of sale: fixed price, Dutch auction. 
899      * English auctions cannot be supported without stronger escrow guarantees.
900      * Future interesting options: Vickrey auction, nonlinear Dutch auctions.
901      */
902     enum SaleKind { FixedPrice, DutchAuction }
903 
904     /**
905      * @dev Check whether the parameters of a sale are valid
906      * @param saleKind Kind of sale
907      * @param expirationTime Order expiration time
908      * @return Whether the parameters were valid
909      */
910     function validateParameters(SaleKind saleKind, uint expirationTime)
911         pure
912         internal
913         returns (bool)
914     {
915         /* Auctions must have a set expiration date. */
916         return (saleKind == SaleKind.FixedPrice || expirationTime > 0);
917     }
918 
919     /**
920      * @dev Return whether or not an order can be settled
921      * @dev Precondition: parameters have passed validateParameters
922      * @param listingTime Order listing time
923      * @param expirationTime Order expiration time
924      */
925     function canSettleOrder(uint listingTime, uint expirationTime)
926         view
927         internal
928         returns (bool)
929     {
930         return (listingTime < now) && (expirationTime == 0 || now < expirationTime);
931     }
932 
933     /**
934      * @dev Calculate the settlement price of an order
935      * @dev Precondition: parameters have passed validateParameters.
936      * @param side Order side
937      * @param saleKind Method of sale
938      * @param basePrice Order base price
939      * @param extra Order extra price data
940      * @param listingTime Order listing time
941      * @param expirationTime Order expiration time
942      */
943     function calculateFinalPrice(Side side, SaleKind saleKind, uint basePrice, uint extra, uint listingTime, uint expirationTime)
944         view
945         internal
946         returns (uint finalPrice)
947     {
948         if (saleKind == SaleKind.FixedPrice) {
949             return basePrice;
950         } else if (saleKind == SaleKind.DutchAuction) {
951             uint diff = SafeMath.div(SafeMath.mul(extra, SafeMath.sub(now, listingTime)), SafeMath.sub(expirationTime, listingTime));
952             if (side == Side.Sell) {
953                 /* Sell-side - start price: basePrice. End price: basePrice - extra. */
954                 return SafeMath.sub(basePrice, diff);
955             } else {
956                 /* Buy-side - start price: basePrice. End price: basePrice + extra. */
957                 return SafeMath.add(basePrice, diff);
958             }
959         }
960     }
961 
962 }
963 
964 contract AuthenticatedProxy is TokenRecipient {
965 
966     /* Address which owns this proxy. */
967     address public user;
968 
969     /* Associated registry with contract authentication information. */
970     ProxyRegistry public registry;
971 
972     /* Whether access has been revoked. */
973     bool public revoked;
974 
975     /* Delegate call could be used to atomically transfer multiple assets owned by the proxy contract with one order. */
976     enum HowToCall { Call, DelegateCall }
977 
978     /* Event fired when the proxy access is revoked or unrevoked. */
979     event Revoked(bool revoked);
980 
981     /**
982      * Create an AuthenticatedProxy
983      *
984      * @param addrUser Address of user on whose behalf this proxy will act
985      * @param addrRegistry Address of ProxyRegistry contract which will manage this proxy
986      */
987     function AuthenticatedProxy(address addrUser, ProxyRegistry addrRegistry) public {
988         user = addrUser;
989         registry = addrRegistry;
990     }
991 
992     /**
993      * Set the revoked flag (allows a user to revoke ProxyRegistry access)
994      *
995      * @dev Can be called by the user only
996      * @param revoke Whether or not to revoke access
997      */
998     function setRevoke(bool revoke)
999         public
1000     {
1001         require(msg.sender == user);
1002         revoked = revoke;
1003         Revoked(revoke);
1004     }
1005 
1006     /**
1007      * Execute a message call from the proxy contract
1008      *
1009      * @dev Can be called by the user, or by a contract authorized by the registry as long as the user has not revoked access
1010      * @param dest Address to which the call will be sent
1011      * @param howToCall Which kind of call to make
1012      * @param calldata Calldata to send
1013      * @return Result of the call (success or failure)
1014      */
1015     function proxy(address dest, HowToCall howToCall, bytes calldata)
1016         public
1017         returns (bool result)
1018     {
1019         require(msg.sender == user || (!revoked && registry.contracts(msg.sender)));
1020         if (howToCall == HowToCall.Call) {
1021             result = dest.call(calldata);
1022         } else if (howToCall == HowToCall.DelegateCall) {
1023             result = dest.delegatecall(calldata);
1024         }
1025         return result;
1026     }
1027 
1028     /**
1029      * Execute a message call and assert success
1030      * 
1031      * @dev Same functionality as `proxy`, just asserts the return value
1032      * @param dest Address to which the call will be sent
1033      * @param howToCall What kind of call to make
1034      * @param calldata Calldata to send
1035      */
1036     function proxyAssert(address dest, HowToCall howToCall, bytes calldata)
1037         public
1038     {
1039         require(proxy(dest, howToCall, calldata));
1040     }
1041 
1042 }
1043 
1044 contract ProxyRegistry is Ownable {
1045 
1046     /* Authenticated proxies by user. */
1047     mapping(address => AuthenticatedProxy) public proxies;
1048 
1049     /* Contracts pending access. */
1050     mapping(address => uint) public pending;
1051 
1052     /* Contracts allowed to call those proxies. */
1053     mapping(address => bool) public contracts;
1054 
1055     /* Delay period for adding an authenticated contract.
1056        This mitigates a particular class of potential attack on the Wyvern DAO (which owns this registry) - if at any point the value of assets held by proxy contracts exceeded the value of half the WYV supply (votes in the DAO),
1057        a malicious but rational attacker could buy half the Wyvern and grant themselves access to all the proxy contracts. A delay period renders this attack nonthreatening - given two weeks, if that happened, users would have
1058        plenty of time to notice and transfer their assets.
1059     */
1060     uint public DELAY_PERIOD = 2 weeks;
1061 
1062     /**
1063      * Start the process to enable access for specified contract. Subject to delay period.
1064      *
1065      * @dev ProxyRegistry owner only
1066      * @param addr Address to which to grant permissions
1067      */
1068     function startGrantAuthentication (address addr)
1069         public
1070         onlyOwner
1071     {
1072         require(!contracts[addr] && pending[addr] == 0);
1073         pending[addr] = now;
1074     }
1075 
1076     /**
1077      * End the process to nable access for specified contract after delay period has passed.
1078      *
1079      * @dev ProxyRegistry owner only
1080      * @param addr Address to which to grant permissions
1081      */
1082     function endGrantAuthentication (address addr)
1083         public
1084         onlyOwner
1085     {
1086         require(!contracts[addr] && pending[addr] != 0 && ((pending[addr] + DELAY_PERIOD) < now));
1087         pending[addr] = 0;
1088         contracts[addr] = true;
1089     }
1090 
1091     /**
1092      * Revoke access for specified contract. Can be done instantly.
1093      *
1094      * @dev ProxyRegistry owner only
1095      * @param addr Address of which to revoke permissions
1096      */    
1097     function revokeAuthentication (address addr)
1098         public
1099         onlyOwner
1100     {
1101         contracts[addr] = false;
1102     }
1103 
1104     /**
1105      * Register a proxy contract with this registry
1106      *
1107      * @dev Must be called by the user which the proxy is for, creates a new AuthenticatedProxy
1108      * @return New AuthenticatedProxy contract
1109      */
1110     function registerProxy()
1111         public
1112         returns (AuthenticatedProxy proxy)
1113     {
1114         require(proxies[msg.sender] == address(0));
1115         proxy = new AuthenticatedProxy(msg.sender, this);
1116         proxies[msg.sender] = proxy;
1117         return proxy;
1118     }
1119 
1120 }