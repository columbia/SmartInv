1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.4.13;
4 
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     if (a == 0) {
12       return 0;
13     }
14     c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     // uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return a / b;
27   }
28 
29   /**
30   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
41     c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract Ownable {
48   address public owner;
49 
50 
51   event OwnershipRenounced(address indexed previousOwner);
52   event OwnershipTransferred(
53     address indexed previousOwner,
54     address indexed newOwner
55   );
56 
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   constructor() public {
63     owner = msg.sender;
64   }
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) public onlyOwner {
79     require(newOwner != address(0));
80     emit OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 
84   /**
85    * @dev Allows the current owner to relinquish control of the contract.
86    */
87   function renounceOwnership() public onlyOwner {
88     emit OwnershipRenounced(owner);
89     owner = address(0);
90   }
91 }
92 
93 contract ERC20Basic {
94   function totalSupply() public view returns (uint256);
95   function balanceOf(address who) public view returns (uint256);
96   function transfer(address to, uint256 value) public returns (bool);
97   event Transfer(address indexed from, address indexed to, uint256 value);
98 }
99 
100 contract ERC20 is ERC20Basic {
101   function allowance(address owner, address spender)
102     public view returns (uint256);
103 
104   function transferFrom(address from, address to, uint256 value)
105     public returns (bool);
106 
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(
109     address indexed owner,
110     address indexed spender,
111     uint256 value
112   );
113 }
114 
115 library ArrayUtils {
116 
117     /**
118      * Replace bytes in an array with bytes in another array, guarded by a bitmask
119      * Efficiency of this function is a bit unpredictable because of the EVM's word-specific model (arrays under 32 bytes will be slower)
120      * 
121      * @dev Mask must be the size of the byte array. A nonzero byte means the byte array can be changed.
122      * @param array The original array
123      * @param desired The target array
124      * @param mask The mask specifying which bits can be changed
125      * @return The updated byte array (the parameter will be modified inplace)
126      */
127     function guardedArrayReplace(bytes memory array, bytes memory desired, bytes memory mask)
128         internal
129         pure
130     {
131         require(array.length == desired.length);
132         require(array.length == mask.length);
133 
134         uint words = array.length / 0x20;
135         uint index = words * 0x20;
136         assert(index / 0x20 == words);
137         uint i;
138 
139         for (i = 0; i < words; i++) {
140             /* Conceptually: array[i] = (!mask[i] && array[i]) || (mask[i] && desired[i]), bitwise in word chunks. */
141             assembly {
142                 let commonIndex := mul(0x20, add(1, i))
143                 let maskValue := mload(add(mask, commonIndex))
144                 mstore(add(array, commonIndex), or(and(not(maskValue), mload(add(array, commonIndex))), and(maskValue, mload(add(desired, commonIndex)))))
145             }
146         }
147 
148         /* Deal with the last section of the byte array. */
149         if (words > 0) {
150             /* This overlaps with bytes already set but is still more efficient than iterating through each of the remaining bytes individually. */
151             i = words;
152             assembly {
153                 let commonIndex := mul(0x20, add(1, i))
154                 let maskValue := mload(add(mask, commonIndex))
155                 mstore(add(array, commonIndex), or(and(not(maskValue), mload(add(array, commonIndex))), and(maskValue, mload(add(desired, commonIndex)))))
156             }
157         } else {
158             /* If the byte array is shorter than a word, we must unfortunately do the whole thing bytewise.
159                (bounds checks could still probably be optimized away in assembly, but this is a rare case) */
160             for (i = index; i < array.length; i++) {
161                 array[i] = ((mask[i] ^ 0xff) & array[i]) | (mask[i] & desired[i]);
162             }
163         }
164     }
165 
166     /**
167      * Test if two arrays are equal
168      * Source: https://github.com/GNSPS/solidity-bytes-utils/blob/master/contracts/BytesLib.sol
169      * 
170      * @dev Arrays must be of equal length, otherwise will return false
171      * @param a First array
172      * @param b Second array
173      * @return Whether or not all bytes in the arrays are equal
174      */
175     function arrayEq(bytes memory a, bytes memory b)
176         internal
177         pure
178         returns (bool)
179     {
180         bool success = true;
181 
182         assembly {
183             let length := mload(a)
184 
185             // if lengths don't match the arrays are not equal
186             switch eq(length, mload(b))
187             case 1 {
188                 // cb is a circuit breaker in the for loop since there's
189                 //  no said feature for inline assembly loops
190                 // cb = 1 - don't breaker
191                 // cb = 0 - break
192                 let cb := 1
193 
194                 let mc := add(a, 0x20)
195                 let end := add(mc, length)
196 
197                 for {
198                     let cc := add(b, 0x20)
199                 // the next line is the loop condition:
200                 // while(uint(mc < end) + cb == 2)
201                 } eq(add(lt(mc, end), cb), 2) {
202                     mc := add(mc, 0x20)
203                     cc := add(cc, 0x20)
204                 } {
205                     // if any of these checks fails then arrays are not equal
206                     if iszero(eq(mload(mc), mload(cc))) {
207                         // unsuccess:
208                         success := 0
209                         cb := 0
210                     }
211                 }
212             }
213             default {
214                 // unsuccess:
215                 success := 0
216             }
217         }
218 
219         return success;
220     }
221 
222     /**
223      * Unsafe write byte array into a memory location
224      *
225      * @param index Memory location
226      * @param source Byte array to write
227      * @return End memory index
228      */
229     function unsafeWriteBytes(uint index, bytes source)
230         internal
231         pure
232         returns (uint)
233     {
234         if (source.length > 0) {
235             assembly {
236                 let length := mload(source)
237                 let end := add(source, add(0x20, length))
238                 let arrIndex := add(source, 0x20)
239                 let tempIndex := index
240                 for { } eq(lt(arrIndex, end), 1) {
241                     arrIndex := add(arrIndex, 0x20)
242                     tempIndex := add(tempIndex, 0x20)
243                 } {
244                     mstore(tempIndex, mload(arrIndex))
245                 }
246                 index := add(index, length)
247             }
248         }
249         return index;
250     }
251 
252     /**
253      * Unsafe write address into a memory location
254      *
255      * @param index Memory location
256      * @param source Address to write
257      * @return End memory index
258      */
259     function unsafeWriteAddress(uint index, address source)
260         internal
261         pure
262         returns (uint)
263     {
264         uint conv = uint(source) << 0x60;
265         assembly {
266             mstore(index, conv)
267             index := add(index, 0x14)
268         }
269         return index;
270     }
271 
272     /**
273      * Unsafe write uint into a memory location
274      *
275      * @param index Memory location
276      * @param source uint to write
277      * @return End memory index
278      */
279     function unsafeWriteUint(uint index, uint source)
280         internal
281         pure
282         returns (uint)
283     {
284         assembly {
285             mstore(index, source)
286             index := add(index, 0x20)
287         }
288         return index;
289     }
290 
291     /**
292      * Unsafe write uint8 into a memory location
293      *
294      * @param index Memory location
295      * @param source uint8 to write
296      * @return End memory index
297      */
298     function unsafeWriteUint8(uint index, uint8 source)
299         internal
300         pure
301         returns (uint)
302     {
303         assembly {
304             mstore8(index, source)
305             index := add(index, 0x1)
306         }
307         return index;
308     }
309 
310 }
311 
312 contract ReentrancyGuarded {
313 
314     bool reentrancyLock = false;
315 
316     /* Prevent a contract function from being reentrant-called. */
317     modifier reentrancyGuard {
318         if (reentrancyLock) {
319             revert();
320         }
321         reentrancyLock = true;
322         _;
323         reentrancyLock = false;
324     }
325 
326 }
327 
328 contract TokenRecipient {
329     event ReceivedEther(address indexed sender, uint amount);
330     event ReceivedTokens(address indexed from, uint256 value, address indexed token, bytes extraData);
331 
332     /**
333      * @dev Receive tokens and generate a log event
334      * @param from Address from which to transfer tokens
335      * @param value Amount of tokens to transfer
336      * @param token Address of token
337      * @param extraData Additional data to log
338      */
339     function receiveApproval(address from, uint256 value, address token, bytes extraData) public {
340         ERC20 t = ERC20(token);
341         require(t.transferFrom(from, this, value));
342         emit ReceivedTokens(from, value, token, extraData);
343     }
344 
345     /**
346      * @dev Receive Ether and generate a log event
347      */
348     function () payable public {
349         emit ReceivedEther(msg.sender, msg.value);
350     }
351 }
352 
353 contract ExchangeCore is ReentrancyGuarded, Ownable {
354 
355     /* The token used to pay exchange fees. */
356     ERC20 public exchangeToken;
357 
358     /* User registry. */
359     ProxyRegistry public registry;
360 
361     /* Token transfer proxy. */
362     TokenTransferProxy public tokenTransferProxy;
363 
364     /* Cancelled / finalized orders, by hash. */
365     mapping(bytes32 => bool) public cancelledOrFinalized;
366 
367     /* Orders verified by on-chain approval (alternative to ECDSA signatures so that smart contracts can place orders directly). */
368     mapping(bytes32 => bool) public approvedOrders;
369 
370     /* For split fee orders, minimum required protocol maker fee, in basis points. Paid to owner (who can change it). */
371     uint public minimumMakerProtocolFee = 0;
372 
373     /* For split fee orders, minimum required protocol taker fee, in basis points. Paid to owner (who can change it). */
374     uint public minimumTakerProtocolFee = 0;
375 
376     /* Recipient of protocol fees. */
377     address public protocolFeeRecipient;
378 
379     /* Fee method: protocol fee or split fee. */
380     enum FeeMethod { ProtocolFee, SplitFee }
381 
382     /* Inverse basis point. */
383     uint public constant INVERSE_BASIS_POINT = 10000;
384 
385     /* An ECDSA signature. */ 
386     struct Sig {
387         /* v parameter */
388         uint8 v;
389         /* r parameter */
390         bytes32 r;
391         /* s parameter */
392         bytes32 s;
393     }
394 
395     /* An order on the exchange. */
396     struct Order {
397         /* Exchange address, intended as a versioning mechanism. */
398         address exchange;
399         /* Order maker address. */
400         address maker;
401         /* Order taker address, if specified. */
402         address taker;
403         /* Maker relayer fee of the order, unused for taker order. */
404         uint makerRelayerFee;
405         /* Taker relayer fee of the order, or maximum taker fee for a taker order. */
406         uint takerRelayerFee;
407         /* Maker protocol fee of the order, unused for taker order. */
408         uint makerProtocolFee;
409         /* Taker protocol fee of the order, or maximum taker fee for a taker order. */
410         uint takerProtocolFee;
411         /* Order fee recipient or zero address for taker order. */
412         address feeRecipient;
413         /* Fee method (protocol token or split fee). */
414         FeeMethod feeMethod;
415         /* Side (buy/sell). */
416         SaleKindInterface.Side side;
417         /* Kind of sale. */
418         SaleKindInterface.SaleKind saleKind;
419         /* Target. */
420         address target;
421         /* HowToCall. */
422         AuthenticatedProxy.HowToCall howToCall;
423         /* Calldata. */
424         bytes calldata;
425         /* Calldata replacement pattern, or an empty byte array for no replacement. */
426         bytes replacementPattern;
427         /* Static call target, zero-address for no static call. */
428         address staticTarget;
429         /* Static call extra data. */
430         bytes staticExtradata;
431         /* Token used to pay for the order, or the zero-address as a sentinel value for Ether. */
432         address paymentToken;
433         /* Base price of the order (in paymentTokens). */
434         uint basePrice;
435         /* Auction extra parameter - minimum bid increment for English auctions, starting/ending price difference. */
436         uint extra;
437         /* Listing timestamp. */
438         uint listingTime;
439         /* Expiration timestamp - 0 for no expiry. */
440         uint expirationTime;
441         /* Order salt, used to prevent duplicate hashes. */
442         uint salt;
443     }
444     
445     event OrderApprovedPartOne    (bytes32 indexed hash, address exchange, address indexed maker, address taker, uint makerRelayerFee, uint takerRelayerFee, uint makerProtocolFee, uint takerProtocolFee, address indexed feeRecipient, FeeMethod feeMethod, SaleKindInterface.Side side, SaleKindInterface.SaleKind saleKind, address target);
446     event OrderApprovedPartTwo    (bytes32 indexed hash, AuthenticatedProxy.HowToCall howToCall, bytes calldata, bytes replacementPattern, address staticTarget, bytes staticExtradata, address paymentToken, uint basePrice, uint extra, uint listingTime, uint expirationTime, uint salt, bool orderbookInclusionDesired);
447     event OrderCancelled          (bytes32 indexed hash);
448     event OrdersMatched           (bytes32 buyHash, bytes32 sellHash, address indexed maker, address indexed taker, uint price, bytes32 indexed metadata);
449 
450     /**
451      * @dev Change the minimum maker fee paid to the protocol (owner only)
452      * @param newMinimumMakerProtocolFee New fee to set in basis points
453      */
454     function changeMinimumMakerProtocolFee(uint newMinimumMakerProtocolFee)
455         public
456         onlyOwner
457     {
458         minimumMakerProtocolFee = newMinimumMakerProtocolFee;
459     }
460 
461     /**
462      * @dev Change the minimum taker fee paid to the protocol (owner only)
463      * @param newMinimumTakerProtocolFee New fee to set in basis points
464      */
465     function changeMinimumTakerProtocolFee(uint newMinimumTakerProtocolFee)
466         public
467         onlyOwner
468     {
469         minimumTakerProtocolFee = newMinimumTakerProtocolFee;
470     }
471 
472     /**
473      * @dev Change the protocol fee recipient (owner only)
474      * @param newProtocolFeeRecipient New protocol fee recipient address
475      */
476     function changeProtocolFeeRecipient(address newProtocolFeeRecipient)
477         public
478         onlyOwner
479     {
480         protocolFeeRecipient = newProtocolFeeRecipient;
481     }
482 
483     /**
484      * @dev Change The token used to pay exchange fees (owner only)
485      * @param newExchangeToken New exchangeToken
486      */
487     function changeExchangeToken(ERC20 newExchangeToken)
488         public
489         onlyOwner
490     {
491         exchangeToken = newExchangeToken;
492     }
493 
494     /**
495      * @dev Transfer tokens
496      * @param token Token to transfer
497      * @param from Address to charge fees
498      * @param to Address to receive fees
499      * @param amount Amount of protocol tokens to charge
500      */
501     function transferTokens(address token, address from, address to, uint amount)
502         internal
503     {
504         if (amount > 0) {
505             require(tokenTransferProxy.transferFrom(token, from, to, amount));
506         }
507     }
508 
509     /**
510      * @dev Charge a fee in protocol tokens
511      * @param from Address to charge fees
512      * @param to Address to receive fees
513      * @param amount Amount of protocol tokens to charge
514      */
515     function chargeProtocolFee(address from, address to, uint amount)
516         internal
517     {
518         transferTokens(exchangeToken, from, to, amount);
519     }
520 
521     /**
522      * @dev Execute a STATICCALL (introduced with Ethereum Metropolis, non-state-modifying external call)
523      * @param target Contract to call
524      * @param calldata Calldata (appended to extradata)
525      * @param extradata Base data for STATICCALL (probably function selector and argument encoding)
526      * @return The result of the call (success or failure)
527      */
528     function staticCall(address target, bytes memory calldata, bytes memory extradata)
529         public
530         view
531         returns (bool result)
532     {
533         bytes memory combined = new bytes(calldata.length + extradata.length);
534         uint index;
535         assembly {
536             index := add(combined, 0x20)
537         }
538         index = ArrayUtils.unsafeWriteBytes(index, extradata);
539         ArrayUtils.unsafeWriteBytes(index, calldata);
540         assembly {
541             result := staticcall(gas, target, add(combined, 0x20), mload(combined), mload(0x40), 0)
542         }
543         return result;
544     }
545 
546     /**
547      * Calculate size of an order struct when tightly packed
548      *
549      * @param order Order to calculate size of
550      * @return Size in bytes
551      */
552     function sizeOf(Order memory order)
553         internal
554         pure
555         returns (uint)
556     {
557         return ((0x14 * 7) + (0x20 * 9) + 4 + order.calldata.length + order.replacementPattern.length + order.staticExtradata.length);
558     }
559 
560     /**
561      * @dev Hash an order, returning the canonical order hash, without the message prefix
562      * @param order Order to hash
563      * @return Hash of order
564      */
565     function hashOrder(Order memory order)
566         internal
567         pure
568         returns (bytes32 hash)
569     {
570         /* Unfortunately abi.encodePacked doesn't work here, stack size constraints. */
571         uint size = sizeOf(order);
572         bytes memory array = new bytes(size);
573         uint index;
574         assembly {
575             index := add(array, 0x20)
576         }
577         index = ArrayUtils.unsafeWriteAddress(index, order.exchange);
578         index = ArrayUtils.unsafeWriteAddress(index, order.maker);
579         index = ArrayUtils.unsafeWriteAddress(index, order.taker);
580         index = ArrayUtils.unsafeWriteUint(index, order.makerRelayerFee);
581         index = ArrayUtils.unsafeWriteUint(index, order.takerRelayerFee);
582         index = ArrayUtils.unsafeWriteUint(index, order.makerProtocolFee);
583         index = ArrayUtils.unsafeWriteUint(index, order.takerProtocolFee);
584         index = ArrayUtils.unsafeWriteAddress(index, order.feeRecipient);
585         index = ArrayUtils.unsafeWriteUint8(index, uint8(order.feeMethod));
586         index = ArrayUtils.unsafeWriteUint8(index, uint8(order.side));
587         index = ArrayUtils.unsafeWriteUint8(index, uint8(order.saleKind));
588         index = ArrayUtils.unsafeWriteAddress(index, order.target);
589         index = ArrayUtils.unsafeWriteUint8(index, uint8(order.howToCall));
590         index = ArrayUtils.unsafeWriteBytes(index, order.calldata);
591         index = ArrayUtils.unsafeWriteBytes(index, order.replacementPattern);
592         index = ArrayUtils.unsafeWriteAddress(index, order.staticTarget);
593         index = ArrayUtils.unsafeWriteBytes(index, order.staticExtradata);
594         index = ArrayUtils.unsafeWriteAddress(index, order.paymentToken);
595         index = ArrayUtils.unsafeWriteUint(index, order.basePrice);
596         index = ArrayUtils.unsafeWriteUint(index, order.extra);
597         index = ArrayUtils.unsafeWriteUint(index, order.listingTime);
598         index = ArrayUtils.unsafeWriteUint(index, order.expirationTime);
599         index = ArrayUtils.unsafeWriteUint(index, order.salt);
600         assembly {
601             hash := keccak256(add(array, 0x20), size)
602         }
603         return hash;
604     }
605 
606     /**
607      * @dev Hash an order, returning the hash that a client must sign, including the standard message prefix
608      * @param order Order to hash
609      * @return Hash of message prefix and order hash per Ethereum format
610      */
611     function hashToSign(Order memory order)
612         internal
613         pure
614         returns (bytes32)
615     {
616         return keccak256("\x19Ethereum Signed Message:\n32", hashOrder(order));
617     }
618 
619     /**
620      * @dev Assert an order is valid and return its hash
621      * @param order Order to validate
622      * @param sig ECDSA signature
623      */
624     function requireValidOrder(Order memory order, Sig memory sig)
625         internal
626         view
627         returns (bytes32)
628     {
629         bytes32 hash = hashToSign(order);
630         require(validateOrder(hash, order, sig));
631         return hash;
632     }
633 
634     /**
635      * @dev Validate order parameters (does *not* check signature validity)
636      * @param order Order to validate
637      */
638     function validateOrderParameters(Order memory order)
639         internal
640         view
641         returns (bool)
642     {
643         /* Order must be targeted at this protocol version (this Exchange contract). */
644         if (order.exchange != address(this)) {
645             return false;
646         }
647 
648         /* Order must possess valid sale kind parameter combination. */
649         if (!SaleKindInterface.validateParameters(order.saleKind, order.expirationTime)) {
650             return false;
651         }
652 
653         /* If using the split fee method, order must have sufficient protocol fees. */
654         if (order.feeMethod == FeeMethod.SplitFee && (order.makerProtocolFee < minimumMakerProtocolFee || order.takerProtocolFee < minimumTakerProtocolFee)) {
655             return false;
656         }
657 
658         return true;
659     }
660 
661     /**
662      * @dev Validate a provided previously approved / signed order, hash, and signature.
663      * @param hash Order hash (already calculated, passed to avoid recalculation)
664      * @param order Order to validate
665      * @param sig ECDSA signature
666      */
667     function validateOrder(bytes32 hash, Order memory order, Sig memory sig) 
668         internal
669         view
670         returns (bool)
671     {
672         /* Not done in an if-conditional to prevent unnecessary ecrecover evaluation, which seems to happen even though it should short-circuit. */
673 
674         /* Order must have valid parameters. */
675         if (!validateOrderParameters(order)) {
676             return false;
677         }
678 
679         /* Order must have not been canceled or already filled. */
680         if (cancelledOrFinalized[hash]) {
681             return false;
682         }
683         
684         /* Order authentication. Order must be either:
685         /* (a) previously approved */
686         if (approvedOrders[hash]) {
687             return true;
688         }
689 
690         /* or (b) ECDSA-signed by maker. */
691         if (ecrecover(hash, sig.v, sig.r, sig.s) == order.maker) {
692             return true;
693         }
694 
695         return false;
696     }
697 
698     /**
699      * @dev Approve an order and optionally mark it for orderbook inclusion. Must be called by the maker of the order
700      * @param order Order to approve
701      * @param orderbookInclusionDesired Whether orderbook providers should include the order in their orderbooks
702      */
703     function approveOrder(Order memory order, bool orderbookInclusionDesired)
704         internal
705     {
706         /* CHECKS */
707 
708         /* Assert sender is authorized to approve order. */
709         require(msg.sender == order.maker);
710 
711         /* Calculate order hash. */
712         bytes32 hash = hashToSign(order);
713 
714         /* Assert order has not already been approved. */
715         require(!approvedOrders[hash]);
716 
717         /* EFFECTS */
718     
719         /* Mark order as approved. */
720         approvedOrders[hash] = true;
721   
722         /* Log approval event. Must be split in two due to Solidity stack size limitations. */
723         {
724             emit OrderApprovedPartOne(hash, order.exchange, order.maker, order.taker, order.makerRelayerFee, order.takerRelayerFee, order.makerProtocolFee, order.takerProtocolFee, order.feeRecipient, order.feeMethod, order.side, order.saleKind, order.target);
725         }
726         {   
727             emit OrderApprovedPartTwo(hash, order.howToCall, order.calldata, order.replacementPattern, order.staticTarget, order.staticExtradata, order.paymentToken, order.basePrice, order.extra, order.listingTime, order.expirationTime, order.salt, orderbookInclusionDesired);
728         }
729     }
730 
731     /**
732      * @dev Cancel an order, preventing it from being matched. Must be called by the maker of the order
733      * @param order Order to cancel
734      * @param sig ECDSA signature
735      */
736     function cancelOrder(Order memory order, Sig memory sig) 
737         internal
738     {
739         /* CHECKS */
740 
741         /* Calculate order hash. */
742         bytes32 hash = requireValidOrder(order, sig);
743 
744         /* Assert sender is authorized to cancel order. */
745         require(msg.sender == order.maker);
746   
747         /* EFFECTS */
748       
749         /* Mark order as cancelled, preventing it from being matched. */
750         cancelledOrFinalized[hash] = true;
751 
752         /* Log cancel event. */
753         emit OrderCancelled(hash);
754     }
755 
756     /**
757      * @dev Calculate the current price of an order (convenience function)
758      * @param order Order to calculate the price of
759      * @return The current price of the order
760      */
761     function calculateCurrentPrice (Order memory order)
762         internal  
763         view
764         returns (uint)
765     {
766         return SaleKindInterface.calculateFinalPrice(order.side, order.saleKind, order.basePrice, order.extra, order.listingTime, order.expirationTime);
767     }
768 
769     /**
770      * @dev Calculate the price two orders would match at, if in fact they would match (otherwise fail)
771      * @param buy Buy-side order
772      * @param sell Sell-side order
773      * @return Match price
774      */
775     function calculateMatchPrice(Order memory buy, Order memory sell)
776         view
777         internal
778         returns (uint)
779     {
780         /* Calculate sell price. */
781         uint sellPrice = SaleKindInterface.calculateFinalPrice(sell.side, sell.saleKind, sell.basePrice, sell.extra, sell.listingTime, sell.expirationTime);
782 
783         /* Calculate buy price. */
784         uint buyPrice = SaleKindInterface.calculateFinalPrice(buy.side, buy.saleKind, buy.basePrice, buy.extra, buy.listingTime, buy.expirationTime);
785 
786         /* Require price cross. */
787         require(buyPrice >= sellPrice);
788         
789         /* Maker/taker priority. */
790         return sell.feeRecipient != address(0) ? sellPrice : buyPrice;
791     }
792 
793     /**
794      * @dev Execute all ERC20 token / Ether transfers associated with an order match (fees and buyer => seller transfer)
795      * @param buy Buy-side order
796      * @param sell Sell-side order
797      */
798     function executeFundsTransfer(Order memory buy, Order memory sell)
799         internal
800         returns (uint)
801     {
802         /* Only payable in the special case of unwrapped Ether. */
803         if (sell.paymentToken != address(0)) {
804             require(msg.value == 0);
805         }
806 
807         /* Calculate match price. */
808         uint price = calculateMatchPrice(buy, sell);
809 
810         /* If paying using a token (not Ether), transfer tokens. This is done prior to fee payments to that a seller will have tokens before being charged fees. */
811         if (price > 0 && sell.paymentToken != address(0)) {
812             transferTokens(sell.paymentToken, buy.maker, sell.maker, price);
813         }
814 
815         /* Amount that will be received by seller (for Ether). */
816         uint receiveAmount = price;
817 
818         /* Amount that must be sent by buyer (for Ether). */
819         uint requiredAmount = price;
820 
821         /* Determine maker/taker and charge fees accordingly. */
822         if (sell.feeRecipient != address(0)) {
823             /* Sell-side order is maker. */
824       
825             /* Assert taker fee is less than or equal to maximum fee specified by buyer. */
826             require(sell.takerRelayerFee <= buy.takerRelayerFee);
827 
828             if (sell.feeMethod == FeeMethod.SplitFee) {
829                 /* Assert taker fee is less than or equal to maximum fee specified by buyer. */
830                 require(sell.takerProtocolFee <= buy.takerProtocolFee);
831 
832                 /* Maker fees are deducted from the token amount that the maker receives. Taker fees are extra tokens that must be paid by the taker. */
833 
834                 if (sell.makerRelayerFee > 0) {
835                     uint makerRelayerFee = SafeMath.div(SafeMath.mul(sell.makerRelayerFee, price), INVERSE_BASIS_POINT);
836                     if (sell.paymentToken == address(0)) {
837                         receiveAmount = SafeMath.sub(receiveAmount, makerRelayerFee);
838                         sell.feeRecipient.transfer(makerRelayerFee);
839                     } else {
840                         transferTokens(sell.paymentToken, sell.maker, sell.feeRecipient, makerRelayerFee);
841                     }
842                 }
843 
844                 if (sell.takerRelayerFee > 0) {
845                     uint takerRelayerFee = SafeMath.div(SafeMath.mul(sell.takerRelayerFee, price), INVERSE_BASIS_POINT);
846                     if (sell.paymentToken == address(0)) {
847                         requiredAmount = SafeMath.add(requiredAmount, takerRelayerFee);
848                         sell.feeRecipient.transfer(takerRelayerFee);
849                     } else {
850                         transferTokens(sell.paymentToken, buy.maker, sell.feeRecipient, takerRelayerFee);
851                     }
852                 }
853 
854                 if (sell.makerProtocolFee > 0) {
855                     uint makerProtocolFee = SafeMath.div(SafeMath.mul(sell.makerProtocolFee, price), INVERSE_BASIS_POINT);
856                     if (sell.paymentToken == address(0)) {
857                         receiveAmount = SafeMath.sub(receiveAmount, makerProtocolFee);
858                         protocolFeeRecipient.transfer(makerProtocolFee);
859                     } else {
860                         transferTokens(sell.paymentToken, sell.maker, protocolFeeRecipient, makerProtocolFee);
861                     }
862                 }
863 
864                 if (sell.takerProtocolFee > 0) {
865                     uint takerProtocolFee = SafeMath.div(SafeMath.mul(sell.takerProtocolFee, price), INVERSE_BASIS_POINT);
866                     if (sell.paymentToken == address(0)) {
867                         requiredAmount = SafeMath.add(requiredAmount, takerProtocolFee);
868                         protocolFeeRecipient.transfer(takerProtocolFee);
869                     } else {
870                         transferTokens(sell.paymentToken, buy.maker, protocolFeeRecipient, takerProtocolFee);
871                     }
872                 }
873 
874             } else {
875                 /* Charge maker fee to seller. */
876                 chargeProtocolFee(sell.maker, sell.feeRecipient, sell.makerRelayerFee);
877 
878                 /* Charge taker fee to buyer. */
879                 chargeProtocolFee(buy.maker, sell.feeRecipient, sell.takerRelayerFee);
880             }
881         } else {
882             /* Buy-side order is maker. */
883 
884             /* Assert taker fee is less than or equal to maximum fee specified by seller. */
885             require(buy.takerRelayerFee <= sell.takerRelayerFee);
886 
887             if (sell.feeMethod == FeeMethod.SplitFee) {
888                 /* The Exchange does not escrow Ether, so direct Ether can only be used to with sell-side maker / buy-side taker orders. */
889                 require(sell.paymentToken != address(0));
890 
891                 /* Assert taker fee is less than or equal to maximum fee specified by seller. */
892                 require(buy.takerProtocolFee <= sell.takerProtocolFee);
893 
894                 if (buy.makerRelayerFee > 0) {
895                     makerRelayerFee = SafeMath.div(SafeMath.mul(buy.makerRelayerFee, price), INVERSE_BASIS_POINT);
896                     transferTokens(sell.paymentToken, buy.maker, buy.feeRecipient, makerRelayerFee);
897                 }
898 
899                 if (buy.takerRelayerFee > 0) {
900                     takerRelayerFee = SafeMath.div(SafeMath.mul(buy.takerRelayerFee, price), INVERSE_BASIS_POINT);
901                     transferTokens(sell.paymentToken, sell.maker, buy.feeRecipient, takerRelayerFee);
902                 }
903 
904                 if (buy.makerProtocolFee > 0) {
905                     makerProtocolFee = SafeMath.div(SafeMath.mul(buy.makerProtocolFee, price), INVERSE_BASIS_POINT);
906                     transferTokens(sell.paymentToken, buy.maker, protocolFeeRecipient, makerProtocolFee);
907                 }
908 
909                 if (buy.takerProtocolFee > 0) {
910                     takerProtocolFee = SafeMath.div(SafeMath.mul(buy.takerProtocolFee, price), INVERSE_BASIS_POINT);
911                     transferTokens(sell.paymentToken, sell.maker, protocolFeeRecipient, takerProtocolFee);
912                 }
913 
914             } else {
915                 /* Charge maker fee to buyer. */
916                 chargeProtocolFee(buy.maker, buy.feeRecipient, buy.makerRelayerFee);
917       
918                 /* Charge taker fee to seller. */
919                 chargeProtocolFee(sell.maker, buy.feeRecipient, buy.takerRelayerFee);
920             }
921         }
922 
923         if (sell.paymentToken == address(0)) {
924             /* Special-case Ether, order must be matched by buyer. */
925             require(msg.value >= requiredAmount);
926             sell.maker.transfer(receiveAmount);
927             /* Allow overshoot for variable-price auctions, refund difference. */
928             uint diff = SafeMath.sub(msg.value, requiredAmount);
929             if (diff > 0) {
930                 buy.maker.transfer(diff);
931             }
932         }
933 
934         /* This contract should never hold Ether, however, we cannot assert this, since it is impossible to prevent anyone from sending Ether e.g. with selfdestruct. */
935 
936         return price;
937     }
938 
939     /**
940      * @dev Return whether or not two orders can be matched with each other by basic parameters (does not check order signatures / calldata or perform static calls)
941      * @param buy Buy-side order
942      * @param sell Sell-side order
943      * @return Whether or not the two orders can be matched
944      */
945     function ordersCanMatch(Order memory buy, Order memory sell)
946         internal
947         view
948         returns (bool)
949     {
950         return (
951             /* Must be opposite-side. */
952             (buy.side == SaleKindInterface.Side.Buy && sell.side == SaleKindInterface.Side.Sell) &&     
953             /* Must use same fee method. */
954             (buy.feeMethod == sell.feeMethod) &&
955             /* Must use same payment token. */
956             (buy.paymentToken == sell.paymentToken) &&
957             /* Must match maker/taker addresses. */
958             (sell.taker == address(0) || sell.taker == buy.maker) &&
959             (buy.taker == address(0) || buy.taker == sell.maker) &&
960             /* One must be maker and the other must be taker (no bool XOR in Solidity). */
961             ((sell.feeRecipient == address(0) && buy.feeRecipient != address(0)) || (sell.feeRecipient != address(0) && buy.feeRecipient == address(0))) &&
962             /* Must match target. */
963             (buy.target == sell.target) &&
964             /* Must match howToCall. */
965             (buy.howToCall == sell.howToCall) &&
966             /* Buy-side order must be settleable. */
967             SaleKindInterface.canSettleOrder(buy.listingTime, buy.expirationTime) &&
968             /* Sell-side order must be settleable. */
969             SaleKindInterface.canSettleOrder(sell.listingTime, sell.expirationTime)
970         );
971     }
972 
973     /**
974      * @dev Atomically match two orders, ensuring validity of the match, and execute all associated state transitions. Protected against reentrancy by a contract-global lock.
975      * @param buy Buy-side order
976      * @param buySig Buy-side order signature
977      * @param sell Sell-side order
978      * @param sellSig Sell-side order signature
979      */
980     function atomicMatch(Order memory buy, Sig memory buySig, Order memory sell, Sig memory sellSig, bytes32 metadata)
981         internal
982         reentrancyGuard
983     {
984         /* CHECKS */
985       
986         /* Ensure buy order validity and calculate hash if necessary. */
987         bytes32 buyHash;
988         if (buy.maker == msg.sender) {
989             require(validateOrderParameters(buy));
990         } else {
991             buyHash = requireValidOrder(buy, buySig);
992         }
993 
994         /* Ensure sell order validity and calculate hash if necessary. */
995         bytes32 sellHash;
996         if (sell.maker == msg.sender) {
997             require(validateOrderParameters(sell));
998         } else {
999             sellHash = requireValidOrder(sell, sellSig);
1000         }
1001         
1002         /* Must be matchable. */
1003         require(ordersCanMatch(buy, sell));
1004 
1005         /* Target must exist (prevent malicious selfdestructs just prior to order settlement). */
1006         uint size;
1007         address target = sell.target;
1008         assembly {
1009             size := extcodesize(target)
1010         }
1011         require(size > 0);
1012       
1013         /* Must match calldata after replacement, if specified. */ 
1014         if (buy.replacementPattern.length > 0) {
1015           ArrayUtils.guardedArrayReplace(buy.calldata, sell.calldata, buy.replacementPattern);
1016         }
1017         if (sell.replacementPattern.length > 0) {
1018           ArrayUtils.guardedArrayReplace(sell.calldata, buy.calldata, sell.replacementPattern);
1019         }
1020         require(ArrayUtils.arrayEq(buy.calldata, sell.calldata));
1021 
1022         /* Retrieve delegateProxy contract. */
1023         OwnableDelegateProxy delegateProxy = registry.proxies(sell.maker);
1024 
1025         /* Proxy must exist. */
1026         require(delegateProxy != address(0));
1027 
1028         /* Assert implementation. */
1029         require(delegateProxy.implementation() == registry.delegateProxyImplementation());
1030 
1031         /* Access the passthrough AuthenticatedProxy. */
1032         AuthenticatedProxy proxy = AuthenticatedProxy(delegateProxy);
1033 
1034         /* EFFECTS */
1035 
1036         /* Mark previously signed or approved orders as finalized. */
1037         if (msg.sender != buy.maker) {
1038             cancelledOrFinalized[buyHash] = true;
1039         }
1040         if (msg.sender != sell.maker) {
1041             cancelledOrFinalized[sellHash] = true;
1042         }
1043 
1044         /* INTERACTIONS */
1045 
1046         /* Execute funds transfer and pay fees. */
1047         uint price = executeFundsTransfer(buy, sell);
1048 
1049         /* Execute specified call through proxy. */
1050         require(proxy.proxy(sell.target, sell.howToCall, sell.calldata));
1051 
1052         /* Static calls are intentionally done after the effectful call so they can check resulting state. */
1053 
1054         /* Handle buy-side static call if specified. */
1055         if (buy.staticTarget != address(0)) {
1056             require(staticCall(buy.staticTarget, sell.calldata, buy.staticExtradata));
1057         }
1058 
1059         /* Handle sell-side static call if specified. */
1060         if (sell.staticTarget != address(0)) {
1061             require(staticCall(sell.staticTarget, sell.calldata, sell.staticExtradata));
1062         }
1063 
1064         /* Log match event. */
1065         emit OrdersMatched(buyHash, sellHash, sell.feeRecipient != address(0) ? sell.maker : buy.maker, sell.feeRecipient != address(0) ? buy.maker : sell.maker, price, metadata);
1066     }
1067 
1068 }
1069 
1070 contract Exchange is ExchangeCore {
1071 
1072     /**
1073      * @dev Call guardedArrayReplace - library function exposed for testing.
1074      */
1075     function guardedArrayReplace(bytes array, bytes desired, bytes mask)
1076         public
1077         pure
1078         returns (bytes)
1079     {
1080         ArrayUtils.guardedArrayReplace(array, desired, mask);
1081         return array;
1082     }
1083 
1084     /**
1085      * Test copy byte array
1086      *
1087      * @param arrToCopy Array to copy
1088      * @return byte array
1089      */
1090     function testCopy(bytes arrToCopy)
1091         public
1092         pure
1093         returns (bytes)
1094     {
1095         bytes memory arr = new bytes(arrToCopy.length);
1096         uint index;
1097         assembly {
1098             index := add(arr, 0x20)
1099         }
1100         ArrayUtils.unsafeWriteBytes(index, arrToCopy);
1101         return arr;
1102     }
1103 
1104     /**
1105      * Test write address to bytes
1106      *
1107      * @param addr Address to write
1108      * @return byte array
1109      */
1110     function testCopyAddress(address addr)
1111         public
1112         pure
1113         returns (bytes)
1114     {
1115         bytes memory arr = new bytes(0x14);
1116         uint index;
1117         assembly {
1118             index := add(arr, 0x20)
1119         }
1120         ArrayUtils.unsafeWriteAddress(index, addr);
1121         return arr;
1122     }
1123 
1124     /**
1125      * @dev Call calculateFinalPrice - library function exposed for testing.
1126      */
1127     function calculateFinalPrice(SaleKindInterface.Side side, SaleKindInterface.SaleKind saleKind, uint basePrice, uint extra, uint listingTime, uint expirationTime)
1128         public
1129         view
1130         returns (uint)
1131     {
1132         return SaleKindInterface.calculateFinalPrice(side, saleKind, basePrice, extra, listingTime, expirationTime);
1133     }
1134 
1135     /**
1136      * @dev Call hashOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1137      */
1138     function hashOrder_(
1139         address[7] addrs,
1140         uint[9] uints,
1141         FeeMethod feeMethod,
1142         SaleKindInterface.Side side,
1143         SaleKindInterface.SaleKind saleKind,
1144         AuthenticatedProxy.HowToCall howToCall,
1145         bytes calldata,
1146         bytes replacementPattern,
1147         bytes staticExtradata)
1148         public
1149         pure
1150         returns (bytes32)
1151     {
1152         return hashOrder(
1153           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8])
1154         );
1155     }
1156 
1157     /**
1158      * @dev Call hashToSign - Solidity ABI encoding limitation workaround, hopefully temporary.
1159      */
1160     function hashToSign_(
1161         address[7] addrs,
1162         uint[9] uints,
1163         FeeMethod feeMethod,
1164         SaleKindInterface.Side side,
1165         SaleKindInterface.SaleKind saleKind,
1166         AuthenticatedProxy.HowToCall howToCall,
1167         bytes calldata,
1168         bytes replacementPattern,
1169         bytes staticExtradata)
1170         public
1171         pure
1172         returns (bytes32)
1173     { 
1174         return hashToSign(
1175           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8])
1176         );
1177     }
1178 
1179     /**
1180      * @dev Call validateOrderParameters - Solidity ABI encoding limitation workaround, hopefully temporary.
1181      */
1182     function validateOrderParameters_ (
1183         address[7] addrs,
1184         uint[9] uints,
1185         FeeMethod feeMethod,
1186         SaleKindInterface.Side side,
1187         SaleKindInterface.SaleKind saleKind,
1188         AuthenticatedProxy.HowToCall howToCall,
1189         bytes calldata,
1190         bytes replacementPattern,
1191         bytes staticExtradata)
1192         view
1193         public
1194         returns (bool)
1195     {
1196         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1197         return validateOrderParameters(
1198           order
1199         );
1200     }
1201 
1202     /**
1203      * @dev Call validateOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1204      */
1205     function validateOrder_ (
1206         address[7] addrs,
1207         uint[9] uints,
1208         FeeMethod feeMethod,
1209         SaleKindInterface.Side side,
1210         SaleKindInterface.SaleKind saleKind,
1211         AuthenticatedProxy.HowToCall howToCall,
1212         bytes calldata,
1213         bytes replacementPattern,
1214         bytes staticExtradata,
1215         uint8 v,
1216         bytes32 r,
1217         bytes32 s)
1218         view
1219         public
1220         returns (bool)
1221     {
1222         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1223         return validateOrder(
1224           hashToSign(order),
1225           order,
1226           Sig(v, r, s)
1227         );
1228     }
1229 
1230     /**
1231      * @dev Call approveOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1232      */
1233     function approveOrder_ (
1234         address[7] addrs,
1235         uint[9] uints,
1236         FeeMethod feeMethod,
1237         SaleKindInterface.Side side,
1238         SaleKindInterface.SaleKind saleKind,
1239         AuthenticatedProxy.HowToCall howToCall,
1240         bytes calldata,
1241         bytes replacementPattern,
1242         bytes staticExtradata,
1243         bool orderbookInclusionDesired) 
1244         public
1245     {
1246         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1247         return approveOrder(order, orderbookInclusionDesired);
1248     }
1249 
1250     /**
1251      * @dev Call cancelOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1252      */
1253     function cancelOrder_(
1254         address[7] addrs,
1255         uint[9] uints,
1256         FeeMethod feeMethod,
1257         SaleKindInterface.Side side,
1258         SaleKindInterface.SaleKind saleKind,
1259         AuthenticatedProxy.HowToCall howToCall,
1260         bytes calldata,
1261         bytes replacementPattern,
1262         bytes staticExtradata,
1263         uint8 v,
1264         bytes32 r,
1265         bytes32 s)
1266         public
1267     {
1268 
1269         return cancelOrder(
1270           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]),
1271           Sig(v, r, s)
1272         );
1273     }
1274 
1275     /**
1276      * @dev Call calculateCurrentPrice - Solidity ABI encoding limitation workaround, hopefully temporary.
1277      */
1278     function calculateCurrentPrice_(
1279         address[7] addrs,
1280         uint[9] uints,
1281         FeeMethod feeMethod,
1282         SaleKindInterface.Side side,
1283         SaleKindInterface.SaleKind saleKind,
1284         AuthenticatedProxy.HowToCall howToCall,
1285         bytes calldata,
1286         bytes replacementPattern,
1287         bytes staticExtradata)
1288         public
1289         view
1290         returns (uint)
1291     {
1292         return calculateCurrentPrice(
1293           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8])
1294         );
1295     }
1296 
1297     /**
1298      * @dev Call ordersCanMatch - Solidity ABI encoding limitation workaround, hopefully temporary.
1299      */
1300     function ordersCanMatch_(
1301         address[14] addrs,
1302         uint[18] uints,
1303         uint8[8] feeMethodsSidesKindsHowToCalls,
1304         bytes calldataBuy,
1305         bytes calldataSell,
1306         bytes replacementPatternBuy,
1307         bytes replacementPatternSell,
1308         bytes staticExtradataBuy,
1309         bytes staticExtradataSell)
1310         public
1311         view
1312         returns (bool)
1313     {
1314         Order memory buy = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1315         Order memory sell = Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17]);
1316         return ordersCanMatch(
1317           buy,
1318           sell
1319         );
1320     }
1321 
1322     /**
1323      * @dev Return whether or not two orders' calldata specifications can match
1324      * @param buyCalldata Buy-side order calldata
1325      * @param buyReplacementPattern Buy-side order calldata replacement mask
1326      * @param sellCalldata Sell-side order calldata
1327      * @param sellReplacementPattern Sell-side order calldata replacement mask
1328      * @return Whether the orders' calldata can be matched
1329      */
1330     function orderCalldataCanMatch(bytes buyCalldata, bytes buyReplacementPattern, bytes sellCalldata, bytes sellReplacementPattern)
1331         public
1332         pure
1333         returns (bool)
1334     {
1335         if (buyReplacementPattern.length > 0) {
1336           ArrayUtils.guardedArrayReplace(buyCalldata, sellCalldata, buyReplacementPattern);
1337         }
1338         if (sellReplacementPattern.length > 0) {
1339           ArrayUtils.guardedArrayReplace(sellCalldata, buyCalldata, sellReplacementPattern);
1340         }
1341         return ArrayUtils.arrayEq(buyCalldata, sellCalldata);
1342     }
1343 
1344     /**
1345      * @dev Call calculateMatchPrice - Solidity ABI encoding limitation workaround, hopefully temporary.
1346      */
1347     function calculateMatchPrice_(
1348         address[14] addrs,
1349         uint[18] uints,
1350         uint8[8] feeMethodsSidesKindsHowToCalls,
1351         bytes calldataBuy,
1352         bytes calldataSell,
1353         bytes replacementPatternBuy,
1354         bytes replacementPatternSell,
1355         bytes staticExtradataBuy,
1356         bytes staticExtradataSell)
1357         public
1358         view
1359         returns (uint)
1360     {
1361         Order memory buy = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1362         Order memory sell = Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17]);
1363         return calculateMatchPrice(
1364           buy,
1365           sell
1366         );
1367     }
1368 
1369     /**
1370      * @dev Call atomicMatch - Solidity ABI encoding limitation workaround, hopefully temporary.
1371      */
1372     function atomicMatch_(
1373         address[14] addrs,
1374         uint[18] uints,
1375         uint8[8] feeMethodsSidesKindsHowToCalls,
1376         bytes calldataBuy,
1377         bytes calldataSell,
1378         bytes replacementPatternBuy,
1379         bytes replacementPatternSell,
1380         bytes staticExtradataBuy,
1381         bytes staticExtradataSell,
1382         uint8[2] vs,
1383         bytes32[5] rssMetadata)
1384         public
1385         payable
1386     {
1387 
1388         return atomicMatch(
1389           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]),
1390           Sig(vs[0], rssMetadata[0], rssMetadata[1]),
1391           Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17]),
1392           Sig(vs[1], rssMetadata[2], rssMetadata[3]),
1393           rssMetadata[4]
1394         );
1395     }
1396 
1397 }
1398 
1399 contract BabyExchange is Exchange {
1400 
1401     string public constant name = "Project Baby Exchange";
1402 
1403     string public constant version = "2.2";
1404 
1405     /**
1406      * @dev Initialize a BabyExchange instance
1407      * @param registryAddress Address of the registry instance which this Exchange instance will use
1408      * @param tokenAddress Address of the token used for protocol fees
1409      */
1410     constructor (ProxyRegistry registryAddress, TokenTransferProxy tokenTransferProxyAddress, ERC20 tokenAddress, address protocolFeeAddress) public {
1411         registry = registryAddress;
1412         tokenTransferProxy = tokenTransferProxyAddress;
1413         exchangeToken = tokenAddress;
1414         protocolFeeRecipient = protocolFeeAddress;
1415         owner = msg.sender;
1416     }
1417 
1418 }
1419 
1420 library SaleKindInterface {
1421 
1422     /**
1423      * Side: buy or sell.
1424      */
1425     enum Side { Buy, Sell }
1426 
1427     /**
1428      * Currently supported kinds of sale: fixed price, Dutch auction. 
1429      * English auctions cannot be supported without stronger escrow guarantees.
1430      * Future interesting options: Vickrey auction, nonlinear Dutch auctions.
1431      */
1432     enum SaleKind { FixedPrice, DutchAuction }
1433 
1434     /**
1435      * @dev Check whether the parameters of a sale are valid
1436      * @param saleKind Kind of sale
1437      * @param expirationTime Order expiration time
1438      * @return Whether the parameters were valid
1439      */
1440     function validateParameters(SaleKind saleKind, uint expirationTime)
1441         pure
1442         internal
1443         returns (bool)
1444     {
1445         /* Auctions must have a set expiration date. */
1446         return (saleKind == SaleKind.FixedPrice || expirationTime > 0);
1447     }
1448 
1449     /**
1450      * @dev Return whether or not an order can be settled
1451      * @dev Precondition: parameters have passed validateParameters
1452      * @param listingTime Order listing time
1453      * @param expirationTime Order expiration time
1454      */
1455     function canSettleOrder(uint listingTime, uint expirationTime)
1456         view
1457         internal
1458         returns (bool)
1459     {
1460         return (listingTime < now) && (expirationTime == 0 || now < expirationTime);
1461     }
1462 
1463     /**
1464      * @dev Calculate the settlement price of an order
1465      * @dev Precondition: parameters have passed validateParameters.
1466      * @param side Order side
1467      * @param saleKind Method of sale
1468      * @param basePrice Order base price
1469      * @param extra Order extra price data
1470      * @param listingTime Order listing time
1471      * @param expirationTime Order expiration time
1472      */
1473     function calculateFinalPrice(Side side, SaleKind saleKind, uint basePrice, uint extra, uint listingTime, uint expirationTime)
1474         view
1475         internal
1476         returns (uint finalPrice)
1477     {
1478         if (saleKind == SaleKind.FixedPrice) {
1479             return basePrice;
1480         } else if (saleKind == SaleKind.DutchAuction) {
1481             uint diff = SafeMath.div(SafeMath.mul(extra, SafeMath.sub(now, listingTime)), SafeMath.sub(expirationTime, listingTime));
1482             if (side == Side.Sell) {
1483                 /* Sell-side - start price: basePrice. End price: basePrice - extra. */
1484                 return SafeMath.sub(basePrice, diff);
1485             } else {
1486                 /* Buy-side - start price: basePrice. End price: basePrice + extra. */
1487                 return SafeMath.add(basePrice, diff);
1488             }
1489         }
1490     }
1491 
1492 }
1493 
1494 contract ProxyRegistry is Ownable {
1495 
1496     /* DelegateProxy implementation contract. Must be initialized. */
1497     address public delegateProxyImplementation;
1498 
1499     /* Authenticated proxies by user. */
1500     mapping(address => OwnableDelegateProxy) public proxies;
1501 
1502     /* Contracts pending access. */
1503     mapping(address => uint) public pending;
1504 
1505     /* Contracts allowed to call those proxies. */
1506     mapping(address => bool) public contracts;
1507 
1508     /* Delay period for adding an authenticated contract.
1509        This mitigates a particular class of potential attack on the Baby DAO (which owns this registry) - if at any point the value of assets held by proxy contracts exceeded the value of half the Baby supply (votes in the offline DAO),
1510        a malicious but rational attacker could buy half the Baby and grant themselves access to all the proxy contracts. A delay period renders this attack nonthreatening - given two weeks, if that happened, users would have
1511        plenty of time to notice and transfer their assets.
1512     */
1513     uint public DELAY_PERIOD = 2 weeks;
1514 
1515     /**
1516      * Start the process to enable access for specified contract. Subject to delay period.
1517      *
1518      * @dev ProxyRegistry owner only
1519      * @param addr Address to which to grant permissions
1520      */
1521     function startGrantAuthentication (address addr)
1522         public
1523         onlyOwner
1524     {
1525         require(!contracts[addr] && pending[addr] == 0);
1526         pending[addr] = now;
1527     }
1528 
1529     /**
1530      * End the process to nable access for specified contract after delay period has passed.
1531      *
1532      * @dev ProxyRegistry owner only
1533      * @param addr Address to which to grant permissions
1534      */
1535     function endGrantAuthentication (address addr)
1536         public
1537         onlyOwner
1538     {
1539         require(!contracts[addr] && pending[addr] != 0 && ((pending[addr] + DELAY_PERIOD) < now));
1540         pending[addr] = 0;
1541         contracts[addr] = true;
1542     }
1543 
1544     /**
1545      * Revoke access for specified contract. Can be done instantly.
1546      *
1547      * @dev ProxyRegistry owner only
1548      * @param addr Address of which to revoke permissions
1549      */    
1550     function revokeAuthentication (address addr)
1551         public
1552         onlyOwner
1553     {
1554         contracts[addr] = false;
1555     }
1556 
1557     /**
1558      * Register a proxy contract with this registry
1559      *
1560      * @dev Must be called by the user which the proxy is for, creates a new AuthenticatedProxy
1561      * @return New AuthenticatedProxy contract
1562      */
1563     function registerProxy()
1564         public
1565         returns (OwnableDelegateProxy proxy)
1566     {
1567         require(proxies[msg.sender] == address(0));
1568         proxy = new OwnableDelegateProxy(msg.sender, delegateProxyImplementation, abi.encodeWithSignature("initialize(address,address)", msg.sender, address(this)));
1569         proxies[msg.sender] = proxy;
1570         return proxy;
1571     }
1572 
1573 }
1574 
1575 contract TokenTransferProxy {
1576 
1577     /* Authentication registry. */
1578     ProxyRegistry public registry;
1579 
1580     /**
1581      * Call ERC20 `transferFrom`
1582      *
1583      * @dev Authenticated contract only
1584      * @param token ERC20 token address
1585      * @param from From address
1586      * @param to To address
1587      * @param amount Transfer amount
1588      */
1589     function transferFrom(address token, address from, address to, uint amount)
1590         public
1591         returns (bool)
1592     {
1593         require(registry.contracts(msg.sender));
1594         return ERC20(token).transferFrom(from, to, amount);
1595     }
1596 
1597 }
1598 
1599 contract OwnedUpgradeabilityStorage {
1600 
1601   // Current implementation
1602   address internal _implementation;
1603 
1604   // Owner of the contract
1605   address private _upgradeabilityOwner;
1606 
1607   /**
1608    * @dev Tells the address of the owner
1609    * @return the address of the owner
1610    */
1611   function upgradeabilityOwner() public view returns (address) {
1612     return _upgradeabilityOwner;
1613   }
1614 
1615   /**
1616    * @dev Sets the address of the owner
1617    */
1618   function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
1619     _upgradeabilityOwner = newUpgradeabilityOwner;
1620   }
1621 
1622   /**
1623   * @dev Tells the address of the current implementation
1624   * @return address of the current implementation
1625   */
1626   function implementation() public view returns (address) {
1627     return _implementation;
1628   }
1629 
1630   /**
1631   * @dev Tells the proxy type (EIP 897)
1632   * @return Proxy type, 2 for forwarding proxy
1633   */
1634   function proxyType() public pure returns (uint256 proxyTypeId) {
1635     return 2;
1636   }
1637 }
1638 
1639 contract AuthenticatedProxy is TokenRecipient, OwnedUpgradeabilityStorage {
1640 
1641     /* Whether initialized. */
1642     bool initialized = false;
1643 
1644     /* Address which owns this proxy. */
1645     address public user;
1646 
1647     /* Associated registry with contract authentication information. */
1648     ProxyRegistry public registry;
1649 
1650     /* Whether access has been revoked. */
1651     bool public revoked;
1652 
1653     /* Delegate call could be used to atomically transfer multiple assets owned by the proxy contract with one order. */
1654     enum HowToCall { Call, DelegateCall }
1655 
1656     /* Event fired when the proxy access is revoked or unrevoked. */
1657     event Revoked(bool revoked);
1658 
1659     /**
1660      * Initialize an AuthenticatedProxy
1661      *
1662      * @param addrUser Address of user on whose behalf this proxy will act
1663      * @param addrRegistry Address of ProxyRegistry contract which will manage this proxy
1664      */
1665     function initialize (address addrUser, ProxyRegistry addrRegistry)
1666         public
1667     {
1668         require(!initialized);
1669         initialized = true;
1670         user = addrUser;
1671         registry = addrRegistry;
1672     }
1673 
1674     /**
1675      * Set the revoked flag (allows a user to revoke ProxyRegistry access)
1676      *
1677      * @dev Can be called by the user only
1678      * @param revoke Whether or not to revoke access
1679      */
1680     function setRevoke(bool revoke)
1681         public
1682     {
1683         require(msg.sender == user);
1684         revoked = revoke;
1685         emit Revoked(revoke);
1686     }
1687 
1688     /**
1689      * Execute a message call from the proxy contract
1690      *
1691      * @dev Can be called by the user, or by a contract authorized by the registry as long as the user has not revoked access
1692      * @param dest Address to which the call will be sent
1693      * @param howToCall Which kind of call to make
1694      * @param calldata Calldata to send
1695      * @return Result of the call (success or failure)
1696      */
1697     function proxy(address dest, HowToCall howToCall, bytes calldata)
1698         public
1699         returns (bool result)
1700     {
1701         require(msg.sender == user || (!revoked && registry.contracts(msg.sender)));
1702         if (howToCall == HowToCall.Call) {
1703             result = dest.call(calldata);
1704         } else if (howToCall == HowToCall.DelegateCall) {
1705             result = dest.delegatecall(calldata);
1706         }
1707         return result;
1708     }
1709 
1710     /**
1711      * Execute a message call and assert success
1712      * 
1713      * @dev Same functionality as `proxy`, just asserts the return value
1714      * @param dest Address to which the call will be sent
1715      * @param howToCall What kind of call to make
1716      * @param calldata Calldata to send
1717      */
1718     function proxyAssert(address dest, HowToCall howToCall, bytes calldata)
1719         public
1720     {
1721         require(proxy(dest, howToCall, calldata));
1722     }
1723 
1724 }
1725 
1726 contract Proxy {
1727 
1728   /**
1729   * @dev Tells the address of the implementation where every call will be delegated.
1730   * @return address of the implementation to which it will be delegated
1731   */
1732   function implementation() public view returns (address);
1733 
1734   /**
1735   * @dev Tells the type of proxy (EIP 897)
1736   * @return Type of proxy, 2 for upgradeable proxy
1737   */
1738   function proxyType() public pure returns (uint256 proxyTypeId);
1739 
1740   /**
1741   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
1742   * This function will return whatever the implementation call returns
1743   */
1744   function () payable public {
1745     address _impl = implementation();
1746     require(_impl != address(0));
1747 
1748     assembly {
1749       let ptr := mload(0x40)
1750       calldatacopy(ptr, 0, calldatasize)
1751       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
1752       let size := returndatasize
1753       returndatacopy(ptr, 0, size)
1754 
1755       switch result
1756       case 0 { revert(ptr, size) }
1757       default { return(ptr, size) }
1758     }
1759   }
1760 }
1761 
1762 contract OwnedUpgradeabilityProxy is Proxy, OwnedUpgradeabilityStorage {
1763   /**
1764   * @dev Event to show ownership has been transferred
1765   * @param previousOwner representing the address of the previous owner
1766   * @param newOwner representing the address of the new owner
1767   */
1768   event ProxyOwnershipTransferred(address previousOwner, address newOwner);
1769 
1770   /**
1771   * @dev This event will be emitted every time the implementation gets upgraded
1772   * @param implementation representing the address of the upgraded implementation
1773   */
1774   event Upgraded(address indexed implementation);
1775 
1776   /**
1777   * @dev Upgrades the implementation address
1778   * @param implementation representing the address of the new implementation to be set
1779   */
1780   function _upgradeTo(address implementation) internal {
1781     require(_implementation != implementation);
1782     _implementation = implementation;
1783     emit Upgraded(implementation);
1784   }
1785 
1786   /**
1787   * @dev Throws if called by any account other than the owner.
1788   */
1789   modifier onlyProxyOwner() {
1790     require(msg.sender == proxyOwner());
1791     _;
1792   }
1793 
1794   /**
1795    * @dev Tells the address of the proxy owner
1796    * @return the address of the proxy owner
1797    */
1798   function proxyOwner() public view returns (address) {
1799     return upgradeabilityOwner();
1800   }
1801 
1802   /**
1803    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1804    * @param newOwner The address to transfer ownership to.
1805    */
1806   function transferProxyOwnership(address newOwner) public onlyProxyOwner {
1807     require(newOwner != address(0));
1808     emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
1809     setUpgradeabilityOwner(newOwner);
1810   }
1811 
1812   /**
1813    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy.
1814    * @param implementation representing the address of the new implementation to be set.
1815    */
1816   function upgradeTo(address implementation) public onlyProxyOwner {
1817     _upgradeTo(implementation);
1818   }
1819 
1820   /**
1821    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy
1822    * and delegatecall the new implementation for initialization.
1823    * @param implementation representing the address of the new implementation to be set.
1824    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
1825    * signature of the implementation to be called with the needed payload
1826    */
1827   function upgradeToAndCall(address implementation, bytes data) payable public onlyProxyOwner {
1828     upgradeTo(implementation);
1829     require(address(this).delegatecall(data));
1830   }
1831 }
1832 
1833 contract OwnableDelegateProxy is OwnedUpgradeabilityProxy {
1834 
1835     constructor(address owner, address initialImplementation, bytes calldata)
1836         public
1837     {
1838         setUpgradeabilityOwner(owner);
1839         _upgradeTo(initialImplementation);
1840         require(initialImplementation.delegatecall(calldata));
1841     }
1842 
1843 }
