1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipRenounced(address indexed previousOwner);
50   event OwnershipTransferred(
51     address indexed previousOwner,
52     address indexed newOwner
53   );
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   constructor() public {
61     owner = msg.sender;
62   }
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) public onlyOwner {
77     require(newOwner != address(0));
78     emit OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82   /**
83    * @dev Allows the current owner to relinquish control of the contract.
84    */
85   function renounceOwnership() public onlyOwner {
86     emit OwnershipRenounced(owner);
87     owner = address(0);
88   }
89 }
90 
91 contract ERC20Basic {
92   function totalSupply() public view returns (uint256);
93   function balanceOf(address who) public view returns (uint256);
94   function transfer(address to, uint256 value) public returns (bool);
95   event Transfer(address indexed from, address indexed to, uint256 value);
96 }
97 
98 contract ERC20 is ERC20Basic {
99   function allowance(address owner, address spender)
100     public view returns (uint256);
101 
102   function transferFrom(address from, address to, uint256 value)
103     public returns (bool);
104 
105   function approve(address spender, uint256 value) public returns (bool);
106   event Approval(
107     address indexed owner,
108     address indexed spender,
109     uint256 value
110   );
111 }
112 
113 library ArrayUtils {
114 
115     /**
116      * Replace bytes in an array with bytes in another array, guarded by a bitmask
117      * Efficiency of this function is a bit unpredictable because of the EVM's word-specific model (arrays under 32 bytes will be slower)
118      * 
119      * @dev Mask must be the size of the byte array. A nonzero byte means the byte array can be changed.
120      * @param array The original array
121      * @param desired The target array
122      * @param mask The mask specifying which bits can be changed
123      * @return The updated byte array (the parameter will be modified inplace)
124      */
125     function guardedArrayReplace(bytes memory array, bytes memory desired, bytes memory mask)
126         internal
127         pure
128     {
129         require(array.length == desired.length);
130         require(array.length == mask.length);
131 
132         uint words = array.length / 0x20;
133         uint index = words * 0x20;
134         assert(index / 0x20 == words);
135         uint i;
136 
137         for (i = 0; i < words; i++) {
138             /* Conceptually: array[i] = (!mask[i] && array[i]) || (mask[i] && desired[i]), bitwise in word chunks. */
139             assembly {
140                 let commonIndex := mul(0x20, add(1, i))
141                 let maskValue := mload(add(mask, commonIndex))
142                 mstore(add(array, commonIndex), or(and(not(maskValue), mload(add(array, commonIndex))), and(maskValue, mload(add(desired, commonIndex)))))
143             }
144         }
145 
146         /* Deal with the last section of the byte array. */
147         if (words > 0) {
148             /* This overlaps with bytes already set but is still more efficient than iterating through each of the remaining bytes individually. */
149             i = words;
150             assembly {
151                 let commonIndex := mul(0x20, add(1, i))
152                 let maskValue := mload(add(mask, commonIndex))
153                 mstore(add(array, commonIndex), or(and(not(maskValue), mload(add(array, commonIndex))), and(maskValue, mload(add(desired, commonIndex)))))
154             }
155         } else {
156             /* If the byte array is shorter than a word, we must unfortunately do the whole thing bytewise.
157                (bounds checks could still probably be optimized away in assembly, but this is a rare case) */
158             for (i = index; i < array.length; i++) {
159                 array[i] = ((mask[i] ^ 0xff) & array[i]) | (mask[i] & desired[i]);
160             }
161         }
162     }
163 
164     /**
165      * Test if two arrays are equal
166      * Source: https://github.com/GNSPS/solidity-bytes-utils/blob/master/contracts/BytesLib.sol
167      * 
168      * @dev Arrays must be of equal length, otherwise will return false
169      * @param a First array
170      * @param b Second array
171      * @return Whether or not all bytes in the arrays are equal
172      */
173     function arrayEq(bytes memory a, bytes memory b)
174         internal
175         pure
176         returns (bool)
177     {
178         bool success = true;
179 
180         assembly {
181             let length := mload(a)
182 
183             // if lengths don't match the arrays are not equal
184             switch eq(length, mload(b))
185             case 1 {
186                 // cb is a circuit breaker in the for loop since there's
187                 //  no said feature for inline assembly loops
188                 // cb = 1 - don't breaker
189                 // cb = 0 - break
190                 let cb := 1
191 
192                 let mc := add(a, 0x20)
193                 let end := add(mc, length)
194 
195                 for {
196                     let cc := add(b, 0x20)
197                 // the next line is the loop condition:
198                 // while(uint(mc < end) + cb == 2)
199                 } eq(add(lt(mc, end), cb), 2) {
200                     mc := add(mc, 0x20)
201                     cc := add(cc, 0x20)
202                 } {
203                     // if any of these checks fails then arrays are not equal
204                     if iszero(eq(mload(mc), mload(cc))) {
205                         // unsuccess:
206                         success := 0
207                         cb := 0
208                     }
209                 }
210             }
211             default {
212                 // unsuccess:
213                 success := 0
214             }
215         }
216 
217         return success;
218     }
219 
220     /**
221      * Unsafe write byte array into a memory location
222      *
223      * @param index Memory location
224      * @param source Byte array to write
225      * @return End memory index
226      */
227     function unsafeWriteBytes(uint index, bytes source)
228         internal
229         pure
230         returns (uint)
231     {
232         if (source.length > 0) {
233             assembly {
234                 let length := mload(source)
235                 let end := add(source, add(0x20, length))
236                 let arrIndex := add(source, 0x20)
237                 let tempIndex := index
238                 for { } eq(lt(arrIndex, end), 1) {
239                     arrIndex := add(arrIndex, 0x20)
240                     tempIndex := add(tempIndex, 0x20)
241                 } {
242                     mstore(tempIndex, mload(arrIndex))
243                 }
244                 index := add(index, length)
245             }
246         }
247         return index;
248     }
249 
250     /**
251      * Unsafe write address into a memory location
252      *
253      * @param index Memory location
254      * @param source Address to write
255      * @return End memory index
256      */
257     function unsafeWriteAddress(uint index, address source)
258         internal
259         pure
260         returns (uint)
261     {
262         uint conv = uint(source) << 0x60;
263         assembly {
264             mstore(index, conv)
265             index := add(index, 0x14)
266         }
267         return index;
268     }
269 
270     /**
271      * Unsafe write uint into a memory location
272      *
273      * @param index Memory location
274      * @param source uint to write
275      * @return End memory index
276      */
277     function unsafeWriteUint(uint index, uint source)
278         internal
279         pure
280         returns (uint)
281     {
282         assembly {
283             mstore(index, source)
284             index := add(index, 0x20)
285         }
286         return index;
287     }
288 
289     /**
290      * Unsafe write uint8 into a memory location
291      *
292      * @param index Memory location
293      * @param source uint8 to write
294      * @return End memory index
295      */
296     function unsafeWriteUint8(uint index, uint8 source)
297         internal
298         pure
299         returns (uint)
300     {
301         assembly {
302             mstore8(index, source)
303             index := add(index, 0x1)
304         }
305         return index;
306     }
307 
308 }
309 
310 contract ReentrancyGuarded {
311 
312     bool reentrancyLock = false;
313 
314     /* Prevent a contract function from being reentrant-called. */
315     modifier reentrancyGuard {
316         if (reentrancyLock) {
317             revert();
318         }
319         reentrancyLock = true;
320         _;
321         reentrancyLock = false;
322     }
323 
324 }
325 
326 contract TokenRecipient {
327     event ReceivedEther(address indexed sender, uint amount);
328     event ReceivedTokens(address indexed from, uint256 value, address indexed token, bytes extraData);
329 
330     /**
331      * @dev Receive tokens and generate a log event
332      * @param from Address from which to transfer tokens
333      * @param value Amount of tokens to transfer
334      * @param token Address of token
335      * @param extraData Additional data to log
336      */
337     function receiveApproval(address from, uint256 value, address token, bytes extraData) public {
338         ERC20 t = ERC20(token);
339         require(t.transferFrom(from, this, value));
340         emit ReceivedTokens(from, value, token, extraData);
341     }
342 
343     /**
344      * @dev Receive Ether and generate a log event
345      */
346     function () payable public {
347         emit ReceivedEther(msg.sender, msg.value);
348     }
349 }
350 
351 contract ExchangeCore is ReentrancyGuarded, Ownable {
352 
353     /* The token used to pay exchange fees. */
354     ERC20 public exchangeToken;
355 
356     /* User registry. */
357     ProxyRegistry public registry;
358 
359     /* Token transfer proxy. */
360     TokenTransferProxy public tokenTransferProxy;
361 
362     /* Cancelled / finalized orders, by hash. */
363     mapping(bytes32 => bool) public cancelledOrFinalized;
364 
365     /* Orders verified by on-chain approval (alternative to ECDSA signatures so that smart contracts can place orders directly). */
366     mapping(bytes32 => bool) public approvedOrders;
367 
368     /* For split fee orders, minimum required protocol maker fee, in basis points. Paid to owner (who can change it). */
369     uint public minimumMakerProtocolFee = 0;
370 
371     /* For split fee orders, minimum required protocol taker fee, in basis points. Paid to owner (who can change it). */
372     uint public minimumTakerProtocolFee = 0;
373 
374     /* Recipient of protocol fees. */
375     address public protocolFeeRecipient;
376 
377     /* Fee method: protocol fee or split fee. */
378     enum FeeMethod { ProtocolFee, SplitFee }
379 
380     /* Inverse basis point. */
381     uint public constant INVERSE_BASIS_POINT = 10000;
382 
383     /* An ECDSA signature. */ 
384     struct Sig {
385         /* v parameter */
386         uint8 v;
387         /* r parameter */
388         bytes32 r;
389         /* s parameter */
390         bytes32 s;
391     }
392 
393     /* An order on the exchange. */
394     struct Order {
395         /* Exchange address, intended as a versioning mechanism. */
396         address exchange;
397         /* Order maker address. */
398         address maker;
399         /* Order taker address, if specified. */
400         address taker;
401         /* Maker relayer fee of the order, unused for taker order. */
402         uint makerRelayerFee;
403         /* Taker relayer fee of the order, or maximum taker fee for a taker order. */
404         uint takerRelayerFee;
405         /* Maker protocol fee of the order, unused for taker order. */
406         uint makerProtocolFee;
407         /* Taker protocol fee of the order, or maximum taker fee for a taker order. */
408         uint takerProtocolFee;
409         /* Order fee recipient or zero address for taker order. */
410         address feeRecipient;
411         /* Fee method (protocol token or split fee). */
412         FeeMethod feeMethod;
413         /* Side (buy/sell). */
414         SaleKindInterface.Side side;
415         /* Kind of sale. */
416         SaleKindInterface.SaleKind saleKind;
417         /* Target. */
418         address target;
419         /* HowToCall. */
420         AuthenticatedProxy.HowToCall howToCall;
421         /* Calldata. */
422         bytes calldata;
423         /* Calldata replacement pattern, or an empty byte array for no replacement. */
424         bytes replacementPattern;
425         /* Static call target, zero-address for no static call. */
426         address staticTarget;
427         /* Static call extra data. */
428         bytes staticExtradata;
429         /* Token used to pay for the order, or the zero-address as a sentinel value for Ether. */
430         address paymentToken;
431         /* Base price of the order (in paymentTokens). */
432         uint basePrice;
433         /* Auction extra parameter - minimum bid increment for English auctions, starting/ending price difference. */
434         uint extra;
435         /* Listing timestamp. */
436         uint listingTime;
437         /* Expiration timestamp - 0 for no expiry. */
438         uint expirationTime;
439         /* Order salt, used to prevent duplicate hashes. */
440         uint salt;
441     }
442     
443     event OrderApprovedPartOne    (bytes32 indexed hash, address exchange, address indexed maker, address taker, uint makerRelayerFee, uint takerRelayerFee, uint makerProtocolFee, uint takerProtocolFee, address indexed feeRecipient, FeeMethod feeMethod, SaleKindInterface.Side side, SaleKindInterface.SaleKind saleKind, address target);
444     event OrderApprovedPartTwo    (bytes32 indexed hash, AuthenticatedProxy.HowToCall howToCall, bytes calldata, bytes replacementPattern, address staticTarget, bytes staticExtradata, address paymentToken, uint basePrice, uint extra, uint listingTime, uint expirationTime, uint salt, bool orderbookInclusionDesired);
445     event OrderCancelled          (bytes32 indexed hash);
446     event OrdersMatched           (bytes32 buyHash, bytes32 sellHash, address indexed maker, address indexed taker, uint price, bytes32 indexed metadata);
447 
448     /**
449      * @dev Change the minimum maker fee paid to the protocol (owner only)
450      * @param newMinimumMakerProtocolFee New fee to set in basis points
451      */
452     function changeMinimumMakerProtocolFee(uint newMinimumMakerProtocolFee)
453         public
454         onlyOwner
455     {
456         minimumMakerProtocolFee = newMinimumMakerProtocolFee;
457     }
458 
459     /**
460      * @dev Change the minimum taker fee paid to the protocol (owner only)
461      * @param newMinimumTakerProtocolFee New fee to set in basis points
462      */
463     function changeMinimumTakerProtocolFee(uint newMinimumTakerProtocolFee)
464         public
465         onlyOwner
466     {
467         minimumTakerProtocolFee = newMinimumTakerProtocolFee;
468     }
469 
470     /**
471      * @dev Change the protocol fee recipient (owner only)
472      * @param newProtocolFeeRecipient New protocol fee recipient address
473      */
474     function changeProtocolFeeRecipient(address newProtocolFeeRecipient)
475         public
476         onlyOwner
477     {
478         protocolFeeRecipient = newProtocolFeeRecipient;
479     }
480 
481     /**
482      * @dev Transfer tokens
483      * @param token Token to transfer
484      * @param from Address to charge fees
485      * @param to Address to receive fees
486      * @param amount Amount of protocol tokens to charge
487      */
488     function transferTokens(address token, address from, address to, uint amount)
489         internal
490     {
491         if (amount > 0) {
492             require(tokenTransferProxy.transferFrom(token, from, to, amount));
493         }
494     }
495 
496     /**
497      * @dev Charge a fee in protocol tokens
498      * @param from Address to charge fees
499      * @param to Address to receive fees
500      * @param amount Amount of protocol tokens to charge
501      */
502     function chargeProtocolFee(address from, address to, uint amount)
503         internal
504     {
505         transferTokens(exchangeToken, from, to, amount);
506     }
507 
508     /**
509      * @dev Execute a STATICCALL (introduced with Ethereum Metropolis, non-state-modifying external call)
510      * @param target Contract to call
511      * @param calldata Calldata (appended to extradata)
512      * @param extradata Base data for STATICCALL (probably function selector and argument encoding)
513      * @return The result of the call (success or failure)
514      */
515     function staticCall(address target, bytes memory calldata, bytes memory extradata)
516         public
517         view
518         returns (bool result)
519     {
520         bytes memory combined = new bytes(calldata.length + extradata.length);
521         uint index;
522         assembly {
523             index := add(combined, 0x20)
524         }
525         index = ArrayUtils.unsafeWriteBytes(index, extradata);
526         ArrayUtils.unsafeWriteBytes(index, calldata);
527         assembly {
528             result := staticcall(gas, target, add(combined, 0x20), mload(combined), mload(0x40), 0)
529         }
530         return result;
531     }
532 
533     /**
534      * Calculate size of an order struct when tightly packed
535      *
536      * @param order Order to calculate size of
537      * @return Size in bytes
538      */
539     function sizeOf(Order memory order)
540         internal
541         pure
542         returns (uint)
543     {
544         return ((0x14 * 7) + (0x20 * 9) + 4 + order.calldata.length + order.replacementPattern.length + order.staticExtradata.length);
545     }
546 
547     /**
548      * @dev Hash an order, returning the canonical order hash, without the message prefix
549      * @param order Order to hash
550      * @return Hash of order
551      */
552     function hashOrder(Order memory order)
553         internal
554         pure
555         returns (bytes32 hash)
556     {
557         /* Unfortunately abi.encodePacked doesn't work here, stack size constraints. */
558         uint size = sizeOf(order);
559         bytes memory array = new bytes(size);
560         uint index;
561         assembly {
562             index := add(array, 0x20)
563         }
564         index = ArrayUtils.unsafeWriteAddress(index, order.exchange);
565         index = ArrayUtils.unsafeWriteAddress(index, order.maker);
566         index = ArrayUtils.unsafeWriteAddress(index, order.taker);
567         index = ArrayUtils.unsafeWriteUint(index, order.makerRelayerFee);
568         index = ArrayUtils.unsafeWriteUint(index, order.takerRelayerFee);
569         index = ArrayUtils.unsafeWriteUint(index, order.makerProtocolFee);
570         index = ArrayUtils.unsafeWriteUint(index, order.takerProtocolFee);
571         index = ArrayUtils.unsafeWriteAddress(index, order.feeRecipient);
572         index = ArrayUtils.unsafeWriteUint8(index, uint8(order.feeMethod));
573         index = ArrayUtils.unsafeWriteUint8(index, uint8(order.side));
574         index = ArrayUtils.unsafeWriteUint8(index, uint8(order.saleKind));
575         index = ArrayUtils.unsafeWriteAddress(index, order.target);
576         index = ArrayUtils.unsafeWriteUint8(index, uint8(order.howToCall));
577         index = ArrayUtils.unsafeWriteBytes(index, order.calldata);
578         index = ArrayUtils.unsafeWriteBytes(index, order.replacementPattern);
579         index = ArrayUtils.unsafeWriteAddress(index, order.staticTarget);
580         index = ArrayUtils.unsafeWriteBytes(index, order.staticExtradata);
581         index = ArrayUtils.unsafeWriteAddress(index, order.paymentToken);
582         index = ArrayUtils.unsafeWriteUint(index, order.basePrice);
583         index = ArrayUtils.unsafeWriteUint(index, order.extra);
584         index = ArrayUtils.unsafeWriteUint(index, order.listingTime);
585         index = ArrayUtils.unsafeWriteUint(index, order.expirationTime);
586         index = ArrayUtils.unsafeWriteUint(index, order.salt);
587         assembly {
588             hash := keccak256(add(array, 0x20), size)
589         }
590         return hash;
591     }
592 
593     /**
594      * @dev Hash an order, returning the hash that a client must sign, including the standard message prefix
595      * @param order Order to hash
596      * @return Hash of message prefix and order hash per Ethereum format
597      */
598     function hashToSign(Order memory order)
599         internal
600         pure
601         returns (bytes32)
602     {
603         return keccak256("\x19Ethereum Signed Message:\n32", hashOrder(order));
604     }
605 
606     /**
607      * @dev Assert an order is valid and return its hash
608      * @param order Order to validate
609      * @param sig ECDSA signature
610      */
611     function requireValidOrder(Order memory order, Sig memory sig)
612         internal
613         view
614         returns (bytes32)
615     {
616         bytes32 hash = hashToSign(order);
617         require(validateOrder(hash, order, sig));
618         return hash;
619     }
620 
621     /**
622      * @dev Validate order parameters (does *not* check signature validity)
623      * @param order Order to validate
624      */
625     function validateOrderParameters(Order memory order)
626         internal
627         view
628         returns (bool)
629     {
630         /* Order must be targeted at this protocol version (this Exchange contract). */
631         if (order.exchange != address(this)) {
632             return false;
633         }
634 
635         /* Order must possess valid sale kind parameter combination. */
636         if (!SaleKindInterface.validateParameters(order.saleKind, order.expirationTime)) {
637             return false;
638         }
639 
640         /* If using the split fee method, order must have sufficient protocol fees. */
641         if (order.feeMethod == FeeMethod.SplitFee && (order.makerProtocolFee < minimumMakerProtocolFee || order.takerProtocolFee < minimumTakerProtocolFee)) {
642             return false;
643         }
644 
645         return true;
646     }
647 
648     /**
649      * @dev Validate a provided previously approved / signed order, hash, and signature.
650      * @param hash Order hash (already calculated, passed to avoid recalculation)
651      * @param order Order to validate
652      * @param sig ECDSA signature
653      */
654     function validateOrder(bytes32 hash, Order memory order, Sig memory sig) 
655         internal
656         view
657         returns (bool)
658     {
659         /* Not done in an if-conditional to prevent unnecessary ecrecover evaluation, which seems to happen even though it should short-circuit. */
660 
661         /* Order must have valid parameters. */
662         if (!validateOrderParameters(order)) {
663             return false;
664         }
665 
666         /* Order must have not been canceled or already filled. */
667         if (cancelledOrFinalized[hash]) {
668             return false;
669         }
670         
671         /* Order authentication. Order must be either:
672         /* (a) previously approved */
673         if (approvedOrders[hash]) {
674             return true;
675         }
676 
677         /* or (b) ECDSA-signed by maker. */
678         if (ecrecover(hash, sig.v, sig.r, sig.s) == order.maker) {
679             return true;
680         }
681 
682         return false;
683     }
684 
685     /**
686      * @dev Approve an order and optionally mark it for orderbook inclusion. Must be called by the maker of the order
687      * @param order Order to approve
688      * @param orderbookInclusionDesired Whether orderbook providers should include the order in their orderbooks
689      */
690     function approveOrder(Order memory order, bool orderbookInclusionDesired)
691         internal
692     {
693         /* CHECKS */
694 
695         /* Assert sender is authorized to approve order. */
696         require(msg.sender == order.maker);
697 
698         /* Calculate order hash. */
699         bytes32 hash = hashToSign(order);
700 
701         /* Assert order has not already been approved. */
702         require(!approvedOrders[hash]);
703 
704         /* EFFECTS */
705     
706         /* Mark order as approved. */
707         approvedOrders[hash] = true;
708   
709         /* Log approval event. Must be split in two due to Solidity stack size limitations. */
710         {
711             emit OrderApprovedPartOne(hash, order.exchange, order.maker, order.taker, order.makerRelayerFee, order.takerRelayerFee, order.makerProtocolFee, order.takerProtocolFee, order.feeRecipient, order.feeMethod, order.side, order.saleKind, order.target);
712         }
713         {   
714             emit OrderApprovedPartTwo(hash, order.howToCall, order.calldata, order.replacementPattern, order.staticTarget, order.staticExtradata, order.paymentToken, order.basePrice, order.extra, order.listingTime, order.expirationTime, order.salt, orderbookInclusionDesired);
715         }
716     }
717 
718     /**
719      * @dev Cancel an order, preventing it from being matched. Must be called by the maker of the order
720      * @param order Order to cancel
721      * @param sig ECDSA signature
722      */
723     function cancelOrder(Order memory order, Sig memory sig) 
724         internal
725     {
726         /* CHECKS */
727 
728         /* Calculate order hash. */
729         bytes32 hash = requireValidOrder(order, sig);
730 
731         /* Assert sender is authorized to cancel order. */
732         require(msg.sender == order.maker);
733   
734         /* EFFECTS */
735       
736         /* Mark order as cancelled, preventing it from being matched. */
737         cancelledOrFinalized[hash] = true;
738 
739         /* Log cancel event. */
740         emit OrderCancelled(hash);
741     }
742 
743     /**
744      * @dev Calculate the current price of an order (convenience function)
745      * @param order Order to calculate the price of
746      * @return The current price of the order
747      */
748     function calculateCurrentPrice (Order memory order)
749         internal  
750         view
751         returns (uint)
752     {
753         return SaleKindInterface.calculateFinalPrice(order.side, order.saleKind, order.basePrice, order.extra, order.listingTime, order.expirationTime);
754     }
755 
756     /**
757      * @dev Calculate the price two orders would match at, if in fact they would match (otherwise fail)
758      * @param buy Buy-side order
759      * @param sell Sell-side order
760      * @return Match price
761      */
762     function calculateMatchPrice(Order memory buy, Order memory sell)
763         view
764         internal
765         returns (uint)
766     {
767         /* Calculate sell price. */
768         uint sellPrice = SaleKindInterface.calculateFinalPrice(sell.side, sell.saleKind, sell.basePrice, sell.extra, sell.listingTime, sell.expirationTime);
769 
770         /* Calculate buy price. */
771         uint buyPrice = SaleKindInterface.calculateFinalPrice(buy.side, buy.saleKind, buy.basePrice, buy.extra, buy.listingTime, buy.expirationTime);
772 
773         /* Require price cross. */
774         require(buyPrice >= sellPrice);
775         
776         /* Maker/taker priority. */
777         return sell.feeRecipient != address(0) ? sellPrice : buyPrice;
778     }
779 
780     /**
781      * @dev Execute all ERC20 token / Ether transfers associated with an order match (fees and buyer => seller transfer)
782      * @param buy Buy-side order
783      * @param sell Sell-side order
784      */
785     function executeFundsTransfer(Order memory buy, Order memory sell)
786         internal
787         returns (uint)
788     {
789         /* Only payable in the special case of unwrapped Ether. */
790         if (sell.paymentToken != address(0)) {
791             require(msg.value == 0);
792         }
793 
794         /* Calculate match price. */
795         uint price = calculateMatchPrice(buy, sell);
796 
797         /* If paying using a token (not Ether), transfer tokens. This is done prior to fee payments to that a seller will have tokens before being charged fees. */
798         if (price > 0 && sell.paymentToken != address(0)) {
799             transferTokens(sell.paymentToken, buy.maker, sell.maker, price);
800         }
801 
802         /* Amount that will be received by seller (for Ether). */
803         uint receiveAmount = price;
804 
805         /* Amount that must be sent by buyer (for Ether). */
806         uint requiredAmount = price;
807 
808         /* Determine maker/taker and charge fees accordingly. */
809         if (sell.feeRecipient != address(0)) {
810             /* Sell-side order is maker. */
811       
812             /* Assert taker fee is less than or equal to maximum fee specified by buyer. */
813             require(sell.takerRelayerFee <= buy.takerRelayerFee);
814 
815             if (sell.feeMethod == FeeMethod.SplitFee) {
816                 /* Assert taker fee is less than or equal to maximum fee specified by buyer. */
817                 require(sell.takerProtocolFee <= buy.takerProtocolFee);
818 
819                 /* Maker fees are deducted from the token amount that the maker receives. Taker fees are extra tokens that must be paid by the taker. */
820 
821                 if (sell.makerRelayerFee > 0) {
822                     uint makerRelayerFee = SafeMath.div(SafeMath.mul(sell.makerRelayerFee, price), INVERSE_BASIS_POINT);
823                     if (sell.paymentToken == address(0)) {
824                         receiveAmount = SafeMath.sub(receiveAmount, makerRelayerFee);
825                         sell.feeRecipient.transfer(makerRelayerFee);
826                     } else {
827                         transferTokens(sell.paymentToken, sell.maker, sell.feeRecipient, makerRelayerFee);
828                     }
829                 }
830 
831                 if (sell.takerRelayerFee > 0) {
832                     uint takerRelayerFee = SafeMath.div(SafeMath.mul(sell.takerRelayerFee, price), INVERSE_BASIS_POINT);
833                     if (sell.paymentToken == address(0)) {
834                         requiredAmount = SafeMath.add(requiredAmount, takerRelayerFee);
835                         sell.feeRecipient.transfer(takerRelayerFee);
836                     } else {
837                         transferTokens(sell.paymentToken, buy.maker, sell.feeRecipient, takerRelayerFee);
838                     }
839                 }
840 
841                 if (sell.makerProtocolFee > 0) {
842                     uint makerProtocolFee = SafeMath.div(SafeMath.mul(sell.makerProtocolFee, price), INVERSE_BASIS_POINT);
843                     if (sell.paymentToken == address(0)) {
844                         receiveAmount = SafeMath.sub(receiveAmount, makerProtocolFee);
845                         protocolFeeRecipient.transfer(makerProtocolFee);
846                     } else {
847                         transferTokens(sell.paymentToken, sell.maker, protocolFeeRecipient, makerProtocolFee);
848                     }
849                 }
850 
851                 if (sell.takerProtocolFee > 0) {
852                     uint takerProtocolFee = SafeMath.div(SafeMath.mul(sell.takerProtocolFee, price), INVERSE_BASIS_POINT);
853                     if (sell.paymentToken == address(0)) {
854                         requiredAmount = SafeMath.add(requiredAmount, takerProtocolFee);
855                         protocolFeeRecipient.transfer(takerProtocolFee);
856                     } else {
857                         transferTokens(sell.paymentToken, buy.maker, protocolFeeRecipient, takerProtocolFee);
858                     }
859                 }
860 
861             } else {
862                 /* Charge maker fee to seller. */
863                 chargeProtocolFee(sell.maker, sell.feeRecipient, sell.makerRelayerFee);
864 
865                 /* Charge taker fee to buyer. */
866                 chargeProtocolFee(buy.maker, sell.feeRecipient, sell.takerRelayerFee);
867             }
868         } else {
869             /* Buy-side order is maker. */
870 
871             /* Assert taker fee is less than or equal to maximum fee specified by seller. */
872             require(buy.takerRelayerFee <= sell.takerRelayerFee);
873 
874             if (sell.feeMethod == FeeMethod.SplitFee) {
875                 /* The Exchange does not escrow Ether, so direct Ether can only be used to with sell-side maker / buy-side taker orders. */
876                 require(sell.paymentToken != address(0));
877 
878                 /* Assert taker fee is less than or equal to maximum fee specified by seller. */
879                 require(buy.takerProtocolFee <= sell.takerProtocolFee);
880 
881                 if (buy.makerRelayerFee > 0) {
882                     makerRelayerFee = SafeMath.div(SafeMath.mul(buy.makerRelayerFee, price), INVERSE_BASIS_POINT);
883                     transferTokens(sell.paymentToken, buy.maker, buy.feeRecipient, makerRelayerFee);
884                 }
885 
886                 if (buy.takerRelayerFee > 0) {
887                     takerRelayerFee = SafeMath.div(SafeMath.mul(buy.takerRelayerFee, price), INVERSE_BASIS_POINT);
888                     transferTokens(sell.paymentToken, sell.maker, buy.feeRecipient, takerRelayerFee);
889                 }
890 
891                 if (buy.makerProtocolFee > 0) {
892                     makerProtocolFee = SafeMath.div(SafeMath.mul(buy.makerProtocolFee, price), INVERSE_BASIS_POINT);
893                     transferTokens(sell.paymentToken, buy.maker, protocolFeeRecipient, makerProtocolFee);
894                 }
895 
896                 if (buy.takerProtocolFee > 0) {
897                     takerProtocolFee = SafeMath.div(SafeMath.mul(buy.takerProtocolFee, price), INVERSE_BASIS_POINT);
898                     transferTokens(sell.paymentToken, sell.maker, protocolFeeRecipient, takerProtocolFee);
899                 }
900 
901             } else {
902                 /* Charge maker fee to buyer. */
903                 chargeProtocolFee(buy.maker, buy.feeRecipient, buy.makerRelayerFee);
904       
905                 /* Charge taker fee to seller. */
906                 chargeProtocolFee(sell.maker, buy.feeRecipient, buy.takerRelayerFee);
907             }
908         }
909 
910         if (sell.paymentToken == address(0)) {
911             /* Special-case Ether, order must be matched by buyer. */
912             require(msg.value >= requiredAmount);
913             sell.maker.transfer(receiveAmount);
914             /* Allow overshoot for variable-price auctions, refund difference. */
915             uint diff = SafeMath.sub(msg.value, requiredAmount);
916             if (diff > 0) {
917                 buy.maker.transfer(diff);
918             }
919         }
920 
921         /* This contract should never hold Ether, however, we cannot assert this, since it is impossible to prevent anyone from sending Ether e.g. with selfdestruct. */
922 
923         return price;
924     }
925 
926     /**
927      * @dev Return whether or not two orders can be matched with each other by basic parameters (does not check order signatures / calldata or perform static calls)
928      * @param buy Buy-side order
929      * @param sell Sell-side order
930      * @return Whether or not the two orders can be matched
931      */
932     function ordersCanMatch(Order memory buy, Order memory sell)
933         internal
934         view
935         returns (bool)
936     {
937         return (
938             /* Must be opposite-side. */
939             (buy.side == SaleKindInterface.Side.Buy && sell.side == SaleKindInterface.Side.Sell) &&     
940             /* Must use same fee method. */
941             (buy.feeMethod == sell.feeMethod) &&
942             /* Must use same payment token. */
943             (buy.paymentToken == sell.paymentToken) &&
944             /* Must match maker/taker addresses. */
945             (sell.taker == address(0) || sell.taker == buy.maker) &&
946             (buy.taker == address(0) || buy.taker == sell.maker) &&
947             /* One must be maker and the other must be taker (no bool XOR in Solidity). */
948             ((sell.feeRecipient == address(0) && buy.feeRecipient != address(0)) || (sell.feeRecipient != address(0) && buy.feeRecipient == address(0))) &&
949             /* Must match target. */
950             (buy.target == sell.target) &&
951             /* Must match howToCall. */
952             (buy.howToCall == sell.howToCall) &&
953             /* Buy-side order must be settleable. */
954             SaleKindInterface.canSettleOrder(buy.listingTime, buy.expirationTime) &&
955             /* Sell-side order must be settleable. */
956             SaleKindInterface.canSettleOrder(sell.listingTime, sell.expirationTime)
957         );
958     }
959 
960     /**
961      * @dev Atomically match two orders, ensuring validity of the match, and execute all associated state transitions. Protected against reentrancy by a contract-global lock.
962      * @param buy Buy-side order
963      * @param buySig Buy-side order signature
964      * @param sell Sell-side order
965      * @param sellSig Sell-side order signature
966      */
967     function atomicMatch(Order memory buy, Sig memory buySig, Order memory sell, Sig memory sellSig, bytes32 metadata)
968         internal
969         reentrancyGuard
970     {
971         /* CHECKS */
972       
973         /* Ensure buy order validity and calculate hash if necessary. */
974         bytes32 buyHash;
975         if (buy.maker == msg.sender) {
976             require(validateOrderParameters(buy));
977         } else {
978             buyHash = requireValidOrder(buy, buySig);
979         }
980 
981         /* Ensure sell order validity and calculate hash if necessary. */
982         bytes32 sellHash;
983         if (sell.maker == msg.sender) {
984             require(validateOrderParameters(sell));
985         } else {
986             sellHash = requireValidOrder(sell, sellSig);
987         }
988         
989         /* Must be matchable. */
990         require(ordersCanMatch(buy, sell));
991 
992         /* Target must exist (prevent malicious selfdestructs just prior to order settlement). */
993         uint size;
994         address target = sell.target;
995         assembly {
996             size := extcodesize(target)
997         }
998         require(size > 0);
999       
1000         /* Must match calldata after replacement, if specified. */ 
1001         if (buy.replacementPattern.length > 0) {
1002           ArrayUtils.guardedArrayReplace(buy.calldata, sell.calldata, buy.replacementPattern);
1003         }
1004         if (sell.replacementPattern.length > 0) {
1005           ArrayUtils.guardedArrayReplace(sell.calldata, buy.calldata, sell.replacementPattern);
1006         }
1007         require(ArrayUtils.arrayEq(buy.calldata, sell.calldata));
1008 
1009         /* Retrieve delegateProxy contract. */
1010         OwnableDelegateProxy delegateProxy = registry.proxies(sell.maker);
1011 
1012         /* Proxy must exist. */
1013         require(delegateProxy != address(0));
1014 
1015         /* Assert implementation. */
1016         require(delegateProxy.implementation() == registry.delegateProxyImplementation());
1017 
1018         /* Access the passthrough AuthenticatedProxy. */
1019         AuthenticatedProxy proxy = AuthenticatedProxy(delegateProxy);
1020 
1021         /* EFFECTS */
1022 
1023         /* Mark previously signed or approved orders as finalized. */
1024         if (msg.sender != buy.maker) {
1025             cancelledOrFinalized[buyHash] = true;
1026         }
1027         if (msg.sender != sell.maker) {
1028             cancelledOrFinalized[sellHash] = true;
1029         }
1030 
1031         /* INTERACTIONS */
1032 
1033         /* Execute funds transfer and pay fees. */
1034         uint price = executeFundsTransfer(buy, sell);
1035 
1036         /* Execute specified call through proxy. */
1037         require(proxy.proxy(sell.target, sell.howToCall, sell.calldata));
1038 
1039         /* Static calls are intentionally done after the effectful call so they can check resulting state. */
1040 
1041         /* Handle buy-side static call if specified. */
1042         if (buy.staticTarget != address(0)) {
1043             require(staticCall(buy.staticTarget, sell.calldata, buy.staticExtradata));
1044         }
1045 
1046         /* Handle sell-side static call if specified. */
1047         if (sell.staticTarget != address(0)) {
1048             require(staticCall(sell.staticTarget, sell.calldata, sell.staticExtradata));
1049         }
1050 
1051         /* Log match event. */
1052         emit OrdersMatched(buyHash, sellHash, sell.feeRecipient != address(0) ? sell.maker : buy.maker, sell.feeRecipient != address(0) ? buy.maker : sell.maker, price, metadata);
1053     }
1054 
1055 }
1056 
1057 contract Exchange is ExchangeCore {
1058 
1059     /**
1060      * @dev Call guardedArrayReplace - library function exposed for testing.
1061      */
1062     function guardedArrayReplace(bytes array, bytes desired, bytes mask)
1063         public
1064         pure
1065         returns (bytes)
1066     {
1067         ArrayUtils.guardedArrayReplace(array, desired, mask);
1068         return array;
1069     }
1070 
1071     /**
1072      * Test copy byte array
1073      *
1074      * @param arrToCopy Array to copy
1075      * @return byte array
1076      */
1077     function testCopy(bytes arrToCopy)
1078         public
1079         pure
1080         returns (bytes)
1081     {
1082         bytes memory arr = new bytes(arrToCopy.length);
1083         uint index;
1084         assembly {
1085             index := add(arr, 0x20)
1086         }
1087         ArrayUtils.unsafeWriteBytes(index, arrToCopy);
1088         return arr;
1089     }
1090 
1091     /**
1092      * Test write address to bytes
1093      *
1094      * @param addr Address to write
1095      * @return byte array
1096      */
1097     function testCopyAddress(address addr)
1098         public
1099         pure
1100         returns (bytes)
1101     {
1102         bytes memory arr = new bytes(0x14);
1103         uint index;
1104         assembly {
1105             index := add(arr, 0x20)
1106         }
1107         ArrayUtils.unsafeWriteAddress(index, addr);
1108         return arr;
1109     }
1110 
1111     /**
1112      * @dev Call calculateFinalPrice - library function exposed for testing.
1113      */
1114     function calculateFinalPrice(SaleKindInterface.Side side, SaleKindInterface.SaleKind saleKind, uint basePrice, uint extra, uint listingTime, uint expirationTime)
1115         public
1116         view
1117         returns (uint)
1118     {
1119         return SaleKindInterface.calculateFinalPrice(side, saleKind, basePrice, extra, listingTime, expirationTime);
1120     }
1121 
1122     /**
1123      * @dev Call hashOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1124      */
1125     function hashOrder_(
1126         address[7] addrs,
1127         uint[9] uints,
1128         FeeMethod feeMethod,
1129         SaleKindInterface.Side side,
1130         SaleKindInterface.SaleKind saleKind,
1131         AuthenticatedProxy.HowToCall howToCall,
1132         bytes calldata,
1133         bytes replacementPattern,
1134         bytes staticExtradata)
1135         public
1136         pure
1137         returns (bytes32)
1138     {
1139         return hashOrder(
1140           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8])
1141         );
1142     }
1143 
1144     /**
1145      * @dev Call hashToSign - Solidity ABI encoding limitation workaround, hopefully temporary.
1146      */
1147     function hashToSign_(
1148         address[7] addrs,
1149         uint[9] uints,
1150         FeeMethod feeMethod,
1151         SaleKindInterface.Side side,
1152         SaleKindInterface.SaleKind saleKind,
1153         AuthenticatedProxy.HowToCall howToCall,
1154         bytes calldata,
1155         bytes replacementPattern,
1156         bytes staticExtradata)
1157         public
1158         pure
1159         returns (bytes32)
1160     { 
1161         return hashToSign(
1162           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8])
1163         );
1164     }
1165 
1166     /**
1167      * @dev Call validateOrderParameters - Solidity ABI encoding limitation workaround, hopefully temporary.
1168      */
1169     function validateOrderParameters_ (
1170         address[7] addrs,
1171         uint[9] uints,
1172         FeeMethod feeMethod,
1173         SaleKindInterface.Side side,
1174         SaleKindInterface.SaleKind saleKind,
1175         AuthenticatedProxy.HowToCall howToCall,
1176         bytes calldata,
1177         bytes replacementPattern,
1178         bytes staticExtradata)
1179         view
1180         public
1181         returns (bool)
1182     {
1183         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1184         return validateOrderParameters(
1185           order
1186         );
1187     }
1188 
1189     /**
1190      * @dev Call validateOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1191      */
1192     function validateOrder_ (
1193         address[7] addrs,
1194         uint[9] uints,
1195         FeeMethod feeMethod,
1196         SaleKindInterface.Side side,
1197         SaleKindInterface.SaleKind saleKind,
1198         AuthenticatedProxy.HowToCall howToCall,
1199         bytes calldata,
1200         bytes replacementPattern,
1201         bytes staticExtradata,
1202         uint8 v,
1203         bytes32 r,
1204         bytes32 s)
1205         view
1206         public
1207         returns (bool)
1208     {
1209         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1210         return validateOrder(
1211           hashToSign(order),
1212           order,
1213           Sig(v, r, s)
1214         );
1215     }
1216 
1217     /**
1218      * @dev Call approveOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1219      */
1220     function approveOrder_ (
1221         address[7] addrs,
1222         uint[9] uints,
1223         FeeMethod feeMethod,
1224         SaleKindInterface.Side side,
1225         SaleKindInterface.SaleKind saleKind,
1226         AuthenticatedProxy.HowToCall howToCall,
1227         bytes calldata,
1228         bytes replacementPattern,
1229         bytes staticExtradata,
1230         bool orderbookInclusionDesired) 
1231         public
1232     {
1233         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1234         return approveOrder(order, orderbookInclusionDesired);
1235     }
1236 
1237     /**
1238      * @dev Call cancelOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1239      */
1240     function cancelOrder_(
1241         address[7] addrs,
1242         uint[9] uints,
1243         FeeMethod feeMethod,
1244         SaleKindInterface.Side side,
1245         SaleKindInterface.SaleKind saleKind,
1246         AuthenticatedProxy.HowToCall howToCall,
1247         bytes calldata,
1248         bytes replacementPattern,
1249         bytes staticExtradata,
1250         uint8 v,
1251         bytes32 r,
1252         bytes32 s)
1253         public
1254     {
1255 
1256         return cancelOrder(
1257           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]),
1258           Sig(v, r, s)
1259         );
1260     }
1261 
1262     /**
1263      * @dev Call calculateCurrentPrice - Solidity ABI encoding limitation workaround, hopefully temporary.
1264      */
1265     function calculateCurrentPrice_(
1266         address[7] addrs,
1267         uint[9] uints,
1268         FeeMethod feeMethod,
1269         SaleKindInterface.Side side,
1270         SaleKindInterface.SaleKind saleKind,
1271         AuthenticatedProxy.HowToCall howToCall,
1272         bytes calldata,
1273         bytes replacementPattern,
1274         bytes staticExtradata)
1275         public
1276         view
1277         returns (uint)
1278     {
1279         return calculateCurrentPrice(
1280           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8])
1281         );
1282     }
1283 
1284     /**
1285      * @dev Call ordersCanMatch - Solidity ABI encoding limitation workaround, hopefully temporary.
1286      */
1287     function ordersCanMatch_(
1288         address[14] addrs,
1289         uint[18] uints,
1290         uint8[8] feeMethodsSidesKindsHowToCalls,
1291         bytes calldataBuy,
1292         bytes calldataSell,
1293         bytes replacementPatternBuy,
1294         bytes replacementPatternSell,
1295         bytes staticExtradataBuy,
1296         bytes staticExtradataSell)
1297         public
1298         view
1299         returns (bool)
1300     {
1301         Order memory buy = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1302         Order memory sell = Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17]);
1303         return ordersCanMatch(
1304           buy,
1305           sell
1306         );
1307     }
1308 
1309     /**
1310      * @dev Return whether or not two orders' calldata specifications can match
1311      * @param buyCalldata Buy-side order calldata
1312      * @param buyReplacementPattern Buy-side order calldata replacement mask
1313      * @param sellCalldata Sell-side order calldata
1314      * @param sellReplacementPattern Sell-side order calldata replacement mask
1315      * @return Whether the orders' calldata can be matched
1316      */
1317     function orderCalldataCanMatch(bytes buyCalldata, bytes buyReplacementPattern, bytes sellCalldata, bytes sellReplacementPattern)
1318         public
1319         pure
1320         returns (bool)
1321     {
1322         if (buyReplacementPattern.length > 0) {
1323           ArrayUtils.guardedArrayReplace(buyCalldata, sellCalldata, buyReplacementPattern);
1324         }
1325         if (sellReplacementPattern.length > 0) {
1326           ArrayUtils.guardedArrayReplace(sellCalldata, buyCalldata, sellReplacementPattern);
1327         }
1328         return ArrayUtils.arrayEq(buyCalldata, sellCalldata);
1329     }
1330 
1331     /**
1332      * @dev Call calculateMatchPrice - Solidity ABI encoding limitation workaround, hopefully temporary.
1333      */
1334     function calculateMatchPrice_(
1335         address[14] addrs,
1336         uint[18] uints,
1337         uint8[8] feeMethodsSidesKindsHowToCalls,
1338         bytes calldataBuy,
1339         bytes calldataSell,
1340         bytes replacementPatternBuy,
1341         bytes replacementPatternSell,
1342         bytes staticExtradataBuy,
1343         bytes staticExtradataSell)
1344         public
1345         view
1346         returns (uint)
1347     {
1348         Order memory buy = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1349         Order memory sell = Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17]);
1350         return calculateMatchPrice(
1351           buy,
1352           sell
1353         );
1354     }
1355 
1356     /**
1357      * @dev Call atomicMatch - Solidity ABI encoding limitation workaround, hopefully temporary.
1358      */
1359     function atomicMatch_(
1360         address[14] addrs,
1361         uint[18] uints,
1362         uint8[8] feeMethodsSidesKindsHowToCalls,
1363         bytes calldataBuy,
1364         bytes calldataSell,
1365         bytes replacementPatternBuy,
1366         bytes replacementPatternSell,
1367         bytes staticExtradataBuy,
1368         bytes staticExtradataSell,
1369         uint8[2] vs,
1370         bytes32[5] rssMetadata)
1371         public
1372         payable
1373     {
1374 
1375         return atomicMatch(
1376           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]),
1377           Sig(vs[0], rssMetadata[0], rssMetadata[1]),
1378           Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17]),
1379           Sig(vs[1], rssMetadata[2], rssMetadata[3]),
1380           rssMetadata[4]
1381         );
1382     }
1383 
1384 }
1385 
1386 contract WyvernExchange is Exchange {
1387 
1388     string public constant name = "Project Wyvern Exchange";
1389 
1390     string public constant version = "2.2";
1391 
1392     string public constant codename = "Lambton Worm";
1393 
1394     /**
1395      * @dev Initialize a WyvernExchange instance
1396      * @param registryAddress Address of the registry instance which this Exchange instance will use
1397      * @param tokenAddress Address of the token used for protocol fees
1398      */
1399     constructor (ProxyRegistry registryAddress, TokenTransferProxy tokenTransferProxyAddress, ERC20 tokenAddress, address protocolFeeAddress) public {
1400         registry = registryAddress;
1401         tokenTransferProxy = tokenTransferProxyAddress;
1402         exchangeToken = tokenAddress;
1403         protocolFeeRecipient = protocolFeeAddress;
1404         owner = msg.sender;
1405     }
1406 
1407 }
1408 
1409 library SaleKindInterface {
1410 
1411     /**
1412      * Side: buy or sell.
1413      */
1414     enum Side { Buy, Sell }
1415 
1416     /**
1417      * Currently supported kinds of sale: fixed price, Dutch auction. 
1418      * English auctions cannot be supported without stronger escrow guarantees.
1419      * Future interesting options: Vickrey auction, nonlinear Dutch auctions.
1420      */
1421     enum SaleKind { FixedPrice, DutchAuction }
1422 
1423     /**
1424      * @dev Check whether the parameters of a sale are valid
1425      * @param saleKind Kind of sale
1426      * @param expirationTime Order expiration time
1427      * @return Whether the parameters were valid
1428      */
1429     function validateParameters(SaleKind saleKind, uint expirationTime)
1430         pure
1431         internal
1432         returns (bool)
1433     {
1434         /* Auctions must have a set expiration date. */
1435         return (saleKind == SaleKind.FixedPrice || expirationTime > 0);
1436     }
1437 
1438     /**
1439      * @dev Return whether or not an order can be settled
1440      * @dev Precondition: parameters have passed validateParameters
1441      * @param listingTime Order listing time
1442      * @param expirationTime Order expiration time
1443      */
1444     function canSettleOrder(uint listingTime, uint expirationTime)
1445         view
1446         internal
1447         returns (bool)
1448     {
1449         return (listingTime < now) && (expirationTime == 0 || now < expirationTime);
1450     }
1451 
1452     /**
1453      * @dev Calculate the settlement price of an order
1454      * @dev Precondition: parameters have passed validateParameters.
1455      * @param side Order side
1456      * @param saleKind Method of sale
1457      * @param basePrice Order base price
1458      * @param extra Order extra price data
1459      * @param listingTime Order listing time
1460      * @param expirationTime Order expiration time
1461      */
1462     function calculateFinalPrice(Side side, SaleKind saleKind, uint basePrice, uint extra, uint listingTime, uint expirationTime)
1463         view
1464         internal
1465         returns (uint finalPrice)
1466     {
1467         if (saleKind == SaleKind.FixedPrice) {
1468             return basePrice;
1469         } else if (saleKind == SaleKind.DutchAuction) {
1470             uint diff = SafeMath.div(SafeMath.mul(extra, SafeMath.sub(now, listingTime)), SafeMath.sub(expirationTime, listingTime));
1471             if (side == Side.Sell) {
1472                 /* Sell-side - start price: basePrice. End price: basePrice - extra. */
1473                 return SafeMath.sub(basePrice, diff);
1474             } else {
1475                 /* Buy-side - start price: basePrice. End price: basePrice + extra. */
1476                 return SafeMath.add(basePrice, diff);
1477             }
1478         }
1479     }
1480 
1481 }
1482 
1483 contract ProxyRegistry is Ownable {
1484 
1485     /* DelegateProxy implementation contract. Must be initialized. */
1486     address public delegateProxyImplementation;
1487 
1488     /* Authenticated proxies by user. */
1489     mapping(address => OwnableDelegateProxy) public proxies;
1490 
1491     /* Contracts pending access. */
1492     mapping(address => uint) public pending;
1493 
1494     /* Contracts allowed to call those proxies. */
1495     mapping(address => bool) public contracts;
1496 
1497     /* Delay period for adding an authenticated contract.
1498        This mitigates a particular class of potential attack on the Wyvern DAO (which owns this registry) - if at any point the value of assets held by proxy contracts exceeded the value of half the WYV supply (votes in the DAO),
1499        a malicious but rational attacker could buy half the Wyvern and grant themselves access to all the proxy contracts. A delay period renders this attack nonthreatening - given two weeks, if that happened, users would have
1500        plenty of time to notice and transfer their assets.
1501     */
1502     uint public DELAY_PERIOD = 2 weeks;
1503 
1504     /**
1505      * Start the process to enable access for specified contract. Subject to delay period.
1506      *
1507      * @dev ProxyRegistry owner only
1508      * @param addr Address to which to grant permissions
1509      */
1510     function startGrantAuthentication (address addr)
1511         public
1512         onlyOwner
1513     {
1514         require(!contracts[addr] && pending[addr] == 0);
1515         pending[addr] = now;
1516     }
1517 
1518     /**
1519      * End the process to nable access for specified contract after delay period has passed.
1520      *
1521      * @dev ProxyRegistry owner only
1522      * @param addr Address to which to grant permissions
1523      */
1524     function endGrantAuthentication (address addr)
1525         public
1526         onlyOwner
1527     {
1528         require(!contracts[addr] && pending[addr] != 0 && ((pending[addr] + DELAY_PERIOD) < now));
1529         pending[addr] = 0;
1530         contracts[addr] = true;
1531     }
1532 
1533     /**
1534      * Revoke access for specified contract. Can be done instantly.
1535      *
1536      * @dev ProxyRegistry owner only
1537      * @param addr Address of which to revoke permissions
1538      */    
1539     function revokeAuthentication (address addr)
1540         public
1541         onlyOwner
1542     {
1543         contracts[addr] = false;
1544     }
1545 
1546     /**
1547      * Register a proxy contract with this registry
1548      *
1549      * @dev Must be called by the user which the proxy is for, creates a new AuthenticatedProxy
1550      * @return New AuthenticatedProxy contract
1551      */
1552     function registerProxy()
1553         public
1554         returns (OwnableDelegateProxy proxy)
1555     {
1556         require(proxies[msg.sender] == address(0));
1557         proxy = new OwnableDelegateProxy(msg.sender, delegateProxyImplementation, abi.encodeWithSignature("initialize(address,address)", msg.sender, address(this)));
1558         proxies[msg.sender] = proxy;
1559         return proxy;
1560     }
1561 
1562 }
1563 
1564 contract TokenTransferProxy {
1565 
1566     /* Authentication registry. */
1567     ProxyRegistry public registry;
1568 
1569     /**
1570      * Call ERC20 `transferFrom`
1571      *
1572      * @dev Authenticated contract only
1573      * @param token ERC20 token address
1574      * @param from From address
1575      * @param to To address
1576      * @param amount Transfer amount
1577      */
1578     function transferFrom(address token, address from, address to, uint amount)
1579         public
1580         returns (bool)
1581     {
1582         require(registry.contracts(msg.sender));
1583         return ERC20(token).transferFrom(from, to, amount);
1584     }
1585 
1586 }
1587 
1588 contract OwnedUpgradeabilityStorage {
1589 
1590   // Current implementation
1591   address internal _implementation;
1592 
1593   // Owner of the contract
1594   address private _upgradeabilityOwner;
1595 
1596   /**
1597    * @dev Tells the address of the owner
1598    * @return the address of the owner
1599    */
1600   function upgradeabilityOwner() public view returns (address) {
1601     return _upgradeabilityOwner;
1602   }
1603 
1604   /**
1605    * @dev Sets the address of the owner
1606    */
1607   function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
1608     _upgradeabilityOwner = newUpgradeabilityOwner;
1609   }
1610 
1611   /**
1612   * @dev Tells the address of the current implementation
1613   * @return address of the current implementation
1614   */
1615   function implementation() public view returns (address) {
1616     return _implementation;
1617   }
1618 
1619   /**
1620   * @dev Tells the proxy type (EIP 897)
1621   * @return Proxy type, 2 for forwarding proxy
1622   */
1623   function proxyType() public pure returns (uint256 proxyTypeId) {
1624     return 2;
1625   }
1626 }
1627 
1628 contract AuthenticatedProxy is TokenRecipient, OwnedUpgradeabilityStorage {
1629 
1630     /* Whether initialized. */
1631     bool initialized = false;
1632 
1633     /* Address which owns this proxy. */
1634     address public user;
1635 
1636     /* Associated registry with contract authentication information. */
1637     ProxyRegistry public registry;
1638 
1639     /* Whether access has been revoked. */
1640     bool public revoked;
1641 
1642     /* Delegate call could be used to atomically transfer multiple assets owned by the proxy contract with one order. */
1643     enum HowToCall { Call, DelegateCall }
1644 
1645     /* Event fired when the proxy access is revoked or unrevoked. */
1646     event Revoked(bool revoked);
1647 
1648     /**
1649      * Initialize an AuthenticatedProxy
1650      *
1651      * @param addrUser Address of user on whose behalf this proxy will act
1652      * @param addrRegistry Address of ProxyRegistry contract which will manage this proxy
1653      */
1654     function initialize (address addrUser, ProxyRegistry addrRegistry)
1655         public
1656     {
1657         require(!initialized);
1658         initialized = true;
1659         user = addrUser;
1660         registry = addrRegistry;
1661     }
1662 
1663     /**
1664      * Set the revoked flag (allows a user to revoke ProxyRegistry access)
1665      *
1666      * @dev Can be called by the user only
1667      * @param revoke Whether or not to revoke access
1668      */
1669     function setRevoke(bool revoke)
1670         public
1671     {
1672         require(msg.sender == user);
1673         revoked = revoke;
1674         emit Revoked(revoke);
1675     }
1676 
1677     /**
1678      * Execute a message call from the proxy contract
1679      *
1680      * @dev Can be called by the user, or by a contract authorized by the registry as long as the user has not revoked access
1681      * @param dest Address to which the call will be sent
1682      * @param howToCall Which kind of call to make
1683      * @param calldata Calldata to send
1684      * @return Result of the call (success or failure)
1685      */
1686     function proxy(address dest, HowToCall howToCall, bytes calldata)
1687         public
1688         returns (bool result)
1689     {
1690         require(msg.sender == user || (!revoked && registry.contracts(msg.sender)));
1691         if (howToCall == HowToCall.Call) {
1692             result = dest.call(calldata);
1693         } else if (howToCall == HowToCall.DelegateCall) {
1694             result = dest.delegatecall(calldata);
1695         }
1696         return result;
1697     }
1698 
1699     /**
1700      * Execute a message call and assert success
1701      * 
1702      * @dev Same functionality as `proxy`, just asserts the return value
1703      * @param dest Address to which the call will be sent
1704      * @param howToCall What kind of call to make
1705      * @param calldata Calldata to send
1706      */
1707     function proxyAssert(address dest, HowToCall howToCall, bytes calldata)
1708         public
1709     {
1710         require(proxy(dest, howToCall, calldata));
1711     }
1712 
1713 }
1714 
1715 contract Proxy {
1716 
1717   /**
1718   * @dev Tells the address of the implementation where every call will be delegated.
1719   * @return address of the implementation to which it will be delegated
1720   */
1721   function implementation() public view returns (address);
1722 
1723   /**
1724   * @dev Tells the type of proxy (EIP 897)
1725   * @return Type of proxy, 2 for upgradeable proxy
1726   */
1727   function proxyType() public pure returns (uint256 proxyTypeId);
1728 
1729   /**
1730   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
1731   * This function will return whatever the implementation call returns
1732   */
1733   function () payable public {
1734     address _impl = implementation();
1735     require(_impl != address(0));
1736 
1737     assembly {
1738       let ptr := mload(0x40)
1739       calldatacopy(ptr, 0, calldatasize)
1740       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
1741       let size := returndatasize
1742       returndatacopy(ptr, 0, size)
1743 
1744       switch result
1745       case 0 { revert(ptr, size) }
1746       default { return(ptr, size) }
1747     }
1748   }
1749 }
1750 
1751 contract OwnedUpgradeabilityProxy is Proxy, OwnedUpgradeabilityStorage {
1752   /**
1753   * @dev Event to show ownership has been transferred
1754   * @param previousOwner representing the address of the previous owner
1755   * @param newOwner representing the address of the new owner
1756   */
1757   event ProxyOwnershipTransferred(address previousOwner, address newOwner);
1758 
1759   /**
1760   * @dev This event will be emitted every time the implementation gets upgraded
1761   * @param implementation representing the address of the upgraded implementation
1762   */
1763   event Upgraded(address indexed implementation);
1764 
1765   /**
1766   * @dev Upgrades the implementation address
1767   * @param implementation representing the address of the new implementation to be set
1768   */
1769   function _upgradeTo(address implementation) internal {
1770     require(_implementation != implementation);
1771     _implementation = implementation;
1772     emit Upgraded(implementation);
1773   }
1774 
1775   /**
1776   * @dev Throws if called by any account other than the owner.
1777   */
1778   modifier onlyProxyOwner() {
1779     require(msg.sender == proxyOwner());
1780     _;
1781   }
1782 
1783   /**
1784    * @dev Tells the address of the proxy owner
1785    * @return the address of the proxy owner
1786    */
1787   function proxyOwner() public view returns (address) {
1788     return upgradeabilityOwner();
1789   }
1790 
1791   /**
1792    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1793    * @param newOwner The address to transfer ownership to.
1794    */
1795   function transferProxyOwnership(address newOwner) public onlyProxyOwner {
1796     require(newOwner != address(0));
1797     emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
1798     setUpgradeabilityOwner(newOwner);
1799   }
1800 
1801   /**
1802    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy.
1803    * @param implementation representing the address of the new implementation to be set.
1804    */
1805   function upgradeTo(address implementation) public onlyProxyOwner {
1806     _upgradeTo(implementation);
1807   }
1808 
1809   /**
1810    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy
1811    * and delegatecall the new implementation for initialization.
1812    * @param implementation representing the address of the new implementation to be set.
1813    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
1814    * signature of the implementation to be called with the needed payload
1815    */
1816   function upgradeToAndCall(address implementation, bytes data) payable public onlyProxyOwner {
1817     upgradeTo(implementation);
1818     require(address(this).delegatecall(data));
1819   }
1820 }
1821 
1822 contract OwnableDelegateProxy is OwnedUpgradeabilityProxy {
1823 
1824     constructor(address owner, address initialImplementation, bytes calldata)
1825         public
1826     {
1827         setUpgradeabilityOwner(owner);
1828         _upgradeTo(initialImplementation);
1829         require(initialImplementation.delegatecall(calldata));
1830     }
1831 
1832 }