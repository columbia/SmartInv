1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.4.26;
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     if (a == 0) {
11       return 0;
12     }
13     c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     // uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return a / b;
26   }
27 
28   /**
29   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40     c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 contract Ownable {
47   address public owner;
48 
49 
50   event OwnershipRenounced(address indexed previousOwner);
51   event OwnershipTransferred(
52     address indexed previousOwner,
53     address indexed newOwner
54   );
55 
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61   constructor() public {
62     owner = msg.sender;
63   }
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) public onlyOwner {
78     require(newOwner != address(0));
79     emit OwnershipTransferred(owner, newOwner);
80     owner = newOwner;
81   }
82 
83   /**
84    * @dev Allows the current owner to relinquish control of the contract.
85    */
86   function renounceOwnership() public onlyOwner {
87     emit OwnershipRenounced(owner);
88     owner = address(0);
89   }
90 }
91 
92 contract ERC20Basic {
93   function totalSupply() public view returns (uint256);
94   function balanceOf(address who) public view returns (uint256);
95   function transfer(address to, uint256 value) public returns (bool);
96   event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 contract ERC20 is ERC20Basic {
100   function allowance(address owner, address spender)
101     public view returns (uint256);
102 
103   function transferFrom(address from, address to, uint256 value)
104     public returns (bool);
105 
106   function approve(address spender, uint256 value) public returns (bool);
107   event Approval(
108     address indexed owner,
109     address indexed spender,
110     uint256 value
111   );
112 }
113 
114 library ArrayUtils {
115 
116     /**
117      * Replace bytes in an array with bytes in another array, guarded by a bitmask
118      * Efficiency of this function is a bit unpredictable because of the EVM's word-specific model (arrays under 32 bytes will be slower)
119      *
120      * @dev Mask must be the size of the byte array. A nonzero byte means the byte array can be changed.
121      * @param array The original array
122      * @param desired The target array
123      * @param mask The mask specifying which bits can be changed
124      * @return The updated byte array (the parameter will be modified inplace)
125      */
126     function guardedArrayReplace(bytes memory array, bytes memory desired, bytes memory mask)
127         internal
128         pure
129     {
130         require(array.length == desired.length);
131         require(array.length == mask.length);
132 
133         uint words = array.length / 0x20;
134         uint index = words * 0x20;
135         assert(index / 0x20 == words);
136         uint i;
137 
138         for (i = 0; i < words; i++) {
139             /* Conceptually: array[i] = (!mask[i] && array[i]) || (mask[i] && desired[i]), bitwise in word chunks. */
140             assembly {
141                 let commonIndex := mul(0x20, add(1, i))
142                 let maskValue := mload(add(mask, commonIndex))
143                 mstore(add(array, commonIndex), or(and(not(maskValue), mload(add(array, commonIndex))), and(maskValue, mload(add(desired, commonIndex)))))
144             }
145         }
146 
147         /* Deal with the last section of the byte array. */
148         if (words > 0) {
149             /* This overlaps with bytes already set but is still more efficient than iterating through each of the remaining bytes individually. */
150             i = words;
151             assembly {
152                 let commonIndex := mul(0x20, add(1, i))
153                 let maskValue := mload(add(mask, commonIndex))
154                 mstore(add(array, commonIndex), or(and(not(maskValue), mload(add(array, commonIndex))), and(maskValue, mload(add(desired, commonIndex)))))
155             }
156         } else {
157             /* If the byte array is shorter than a word, we must unfortunately do the whole thing bytewise.
158                (bounds checks could still probably be optimized away in assembly, but this is a rare case) */
159             for (i = index; i < array.length; i++) {
160                 array[i] = ((mask[i] ^ 0xff) & array[i]) | (mask[i] & desired[i]);
161             }
162         }
163     }
164 
165     /**
166      * Test if two arrays are equal
167      * @param a First array
168      * @param b Second array
169      * @return Whether or not all bytes in the arrays are equal
170      */
171     function arrayEq(bytes memory a, bytes memory b)
172         internal
173         pure
174         returns (bool)
175     {
176         return keccak256(a) == keccak256(b);
177     }
178 
179     /**
180      * Unsafe write byte array into a memory location
181      *
182      * @param index Memory location
183      * @param source Byte array to write
184      * @return End memory index
185      */
186     function unsafeWriteBytes(uint index, bytes source)
187         internal
188         pure
189         returns (uint)
190     {
191         if (source.length > 0) {
192             assembly {
193                 let length := mload(source)
194                 let end := add(source, add(0x20, length))
195                 let arrIndex := add(source, 0x20)
196                 let tempIndex := index
197                 for { } eq(lt(arrIndex, end), 1) {
198                     arrIndex := add(arrIndex, 0x20)
199                     tempIndex := add(tempIndex, 0x20)
200                 } {
201                     mstore(tempIndex, mload(arrIndex))
202                 }
203                 index := add(index, length)
204             }
205         }
206         return index;
207     }
208 
209     /**
210      * Unsafe write address into a memory location
211      *
212      * @param index Memory location
213      * @param source Address to write
214      * @return End memory index
215      */
216     function unsafeWriteAddress(uint index, address source)
217         internal
218         pure
219         returns (uint)
220     {
221         uint conv = uint(source) << 0x60;
222         assembly {
223             mstore(index, conv)
224             index := add(index, 0x14)
225         }
226         return index;
227     }
228 
229     /**
230      * Unsafe write address into a memory location using entire word
231      *
232      * @param index Memory location
233      * @param source uint to write
234      * @return End memory index
235      */
236     function unsafeWriteAddressWord(uint index, address source)
237         internal
238         pure
239         returns (uint)
240     {
241         assembly {
242             mstore(index, source)
243             index := add(index, 0x20)
244         }
245         return index;
246     }
247 
248     /**
249      * Unsafe write uint into a memory location
250      *
251      * @param index Memory location
252      * @param source uint to write
253      * @return End memory index
254      */
255     function unsafeWriteUint(uint index, uint source)
256         internal
257         pure
258         returns (uint)
259     {
260         assembly {
261             mstore(index, source)
262             index := add(index, 0x20)
263         }
264         return index;
265     }
266 
267     /**
268      * Unsafe write uint8 into a memory location
269      *
270      * @param index Memory location
271      * @param source uint8 to write
272      * @return End memory index
273      */
274     function unsafeWriteUint8(uint index, uint8 source)
275         internal
276         pure
277         returns (uint)
278     {
279         assembly {
280             mstore8(index, source)
281             index := add(index, 0x1)
282         }
283         return index;
284     }
285 
286     /**
287      * Unsafe write uint8 into a memory location using entire word
288      *
289      * @param index Memory location
290      * @param source uint to write
291      * @return End memory index
292      */
293     function unsafeWriteUint8Word(uint index, uint8 source)
294         internal
295         pure
296         returns (uint)
297     {
298         assembly {
299             mstore(index, source)
300             index := add(index, 0x20)
301         }
302         return index;
303     }
304 
305     /**
306      * Unsafe write bytes32 into a memory location using entire word
307      *
308      * @param index Memory location
309      * @param source uint to write
310      * @return End memory index
311      */
312     function unsafeWriteBytes32(uint index, bytes32 source)
313         internal
314         pure
315         returns (uint)
316     {
317         assembly {
318             mstore(index, source)
319             index := add(index, 0x20)
320         }
321         return index;
322     }
323 }
324 
325 contract ReentrancyGuarded {
326 
327     bool reentrancyLock = false;
328 
329     /* Prevent a contract function from being reentrant-called. */
330     modifier reentrancyGuard {
331         if (reentrancyLock) {
332             revert();
333         }
334         reentrancyLock = true;
335         _;
336         reentrancyLock = false;
337     }
338 
339 }
340 
341 contract TokenRecipient {
342     event ReceivedEther(address indexed sender, uint amount);
343     event ReceivedTokens(address indexed from, uint256 value, address indexed token, bytes extraData);
344 
345     /**
346      * @dev Receive tokens and generate a log event
347      * @param from Address from which to transfer tokens
348      * @param value Amount of tokens to transfer
349      * @param token Address of token
350      * @param extraData Additional data to log
351      */
352     function receiveApproval(address from, uint256 value, address token, bytes extraData) public {
353         ERC20 t = ERC20(token);
354         require(t.transferFrom(from, this, value));
355         emit ReceivedTokens(from, value, token, extraData);
356     }
357 
358     /**
359      * @dev Receive Ether and generate a log event
360      */
361     function () payable public {
362         emit ReceivedEther(msg.sender, msg.value);
363     }
364 }
365 
366 contract ExchangeCore is ReentrancyGuarded, Ownable {
367     string public constant name = "Core Sky Exchange Contract";
368     string public constant version = "1.0";
369 
370     // NOTE: these hashes are derived and verified in the constructor.
371     bytes32 private constant _EIP_712_DOMAIN_TYPEHASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
372     bytes32 private constant _NAME_HASH = 0x240721be4dc054d34213adcc557aff0c01d2ce39ebc5b40065e0890de2509142;
373     bytes32 private constant _VERSION_HASH = 0xe6bbd6277e1bf288eed5e8d1780f9a50b239e86b153736bceebccf4ea79d90b3;
374     bytes32 private constant _ORDER_TYPEHASH = 0xdba08a88a748f356e8faf8578488343eab21b1741728779c9dcfdc782bc800f8;
375 
376     bytes4 private constant _EIP_1271_MAGIC_VALUE = 0x1626ba7e;
377 
378     //    // NOTE: chainId opcode is not supported in solidiy 0.4.x; here we hardcode as 1.
379     // In order to protect against orders that are replayable across forked chains,
380     // either the solidity version needs to be bumped up or it needs to be retrieved
381     // from another contract.
382     // uint256 private constant _CHAIN_ID = 1;
383 
384     uint256 private _CHAIN_ID = 1;
385 
386     // Note: the domain separator is derived and verified in the constructor. */
387     bytes32 public DOMAIN_SEPARATOR;
388 
389     // exchange wrap contract for batch match orders
390     address public exchangeWrap;
391 
392     /* The token used to pay exchange fees. */
393     ERC20 public exchangeToken;
394 
395     /* User registry. */
396     ProxyRegistry public registry;
397 
398     /* Token transfer proxy. */
399     TokenTransferProxy public tokenTransferProxy;
400 
401     /* Cancelled / finalized orders, by hash. */
402     mapping(bytes32 => bool) public cancelledOrFinalized;
403 
404     /* Orders verified by on-chain approval (alternative to ECDSA signatures so that smart contracts can place orders directly). */
405     /* Note that the maker's nonce at the time of approval **plus one** is stored in the mapping. */
406     mapping(bytes32 => uint256) private _approvedOrdersByNonce;
407 
408     /* Track per-maker nonces that can be incremented by the maker to cancel orders in bulk. */
409     // The current nonce for the maker represents the only valid nonce that can be signed by the maker
410     // If a signature was signed with a nonce that's different from the one stored in nonces, it
411     // will fail validation.
412     mapping(address => uint256) public nonces;
413 
414     /* For split fee orders, minimum required protocol maker fee, in basis points. Paid to owner (who can change it). */
415     uint public minimumMakerProtocolFee = 0;
416 
417     /* For split fee orders, minimum required protocol taker fee, in basis points. Paid to owner (who can change it). */
418     uint public minimumTakerProtocolFee = 0;
419 
420     /* Recipient of protocol fees. */
421     address public protocolFeeRecipient;
422 
423     /* Fee method: protocol fee or split fee. */
424     enum FeeMethod { ProtocolFee, SplitFee }
425 
426     /* Inverse basis point. */
427     uint public constant INVERSE_BASIS_POINT = 10000;
428 
429     /* An ECDSA signature. */
430     struct Sig {
431         /* v parameter */
432         uint8 v;
433         /* r parameter */
434         bytes32 r;
435         /* s parameter */
436         bytes32 s;
437     }
438 
439     /* An order on the exchange. */
440     struct Order {
441         /* Exchange address, intended as a versioning mechanism. */
442         address exchange;
443         /* Order maker address. */
444         address maker;
445         /* Order taker address, if specified. */
446         address taker;
447         /* Maker relayer fee of the order, unused for taker order. */
448         uint makerRelayerFee;
449         /* Taker relayer fee of the order, or maximum taker fee for a taker order. */
450         uint takerRelayerFee;
451         /* Maker protocol fee of the order, unused for taker order. */
452         uint makerProtocolFee;
453         /* Taker protocol fee of the order, or maximum taker fee for a taker order. */
454         uint takerProtocolFee;
455         /* Order fee recipient or zero address for taker order. */
456         address feeRecipient;
457         /* Fee method (protocol token or split fee). */
458         FeeMethod feeMethod;
459         /* Side (buy/sell). */
460         SaleKindInterface.Side side;
461         /* Kind of sale. */
462         SaleKindInterface.SaleKind saleKind;
463         /* Target. */
464         address target;
465         /* HowToCall. */
466         AuthenticatedProxy.HowToCall howToCall;
467         /* Calldata. */
468         bytes calldata;
469         /* Calldata replacement pattern, or an empty byte array for no replacement. */
470         bytes replacementPattern;
471         /* Static call target, zero-address for no static call. */
472         address staticTarget;
473         /* Static call extra data. */
474         bytes staticExtradata;
475         /* Token used to pay for the order, or the zero-address as a sentinel value for Ether. */
476         address paymentToken;
477         /* Base price of the order (in paymentTokens). */
478         uint basePrice;
479         /* Auction extra parameter - minimum bid increment for English auctions, starting/ending price difference. */
480         uint extra;
481         /* Listing timestamp. */
482         uint listingTime;
483         /* Expiration timestamp - 0 for no expiry. */
484         uint expirationTime;
485         /* Order salt, used to prevent duplicate hashes. */
486         uint salt;
487         /* NOTE: uint nonce is an additional component of the order but is read from storage */
488         address _sender;
489         /* NOTE: no signature is required */
490     }
491 
492     event OrderApprovedPartOne    (bytes32 indexed hash, address exchange, address indexed maker, address taker, uint makerRelayerFee, uint takerRelayerFee, uint makerProtocolFee, uint takerProtocolFee, address indexed feeRecipient, FeeMethod feeMethod, SaleKindInterface.Side side, SaleKindInterface.SaleKind saleKind, address target);
493     event OrderApprovedPartTwo    (bytes32 indexed hash, AuthenticatedProxy.HowToCall howToCall, bytes calldata, bytes replacementPattern, address staticTarget, bytes staticExtradata, address paymentToken, uint basePrice, uint extra, uint listingTime, uint expirationTime, uint salt, bool orderbookInclusionDesired);
494     event OrderCancelled          (bytes32 indexed hash);
495     event OrdersMatched           (bytes32 buyHash, bytes32 sellHash, address indexed maker, address indexed taker, uint price, bytes32 indexed metadata);
496     event NonceIncremented        (address indexed maker, uint newNonce);
497 
498     constructor () public {
499         require(keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)") == _EIP_712_DOMAIN_TYPEHASH);
500         require(keccak256(bytes(name)) == _NAME_HASH);
501         require(keccak256(bytes(version)) == _VERSION_HASH);
502         require(keccak256("Order(address exchange,address maker,address taker,uint256 makerRelayerFee,uint256 takerRelayerFee,uint256 makerProtocolFee,uint256 takerProtocolFee,address feeRecipient,uint8 feeMethod,uint8 side,uint8 saleKind,address target,uint8 howToCall,bytes calldata,bytes replacementPattern,address staticTarget,bytes staticExtradata,address paymentToken,uint256 basePrice,uint256 extra,uint256 listingTime,uint256 expirationTime,uint256 salt,uint256 nonce)") == _ORDER_TYPEHASH);
503         DOMAIN_SEPARATOR = _deriveDomainSeparator();
504     }
505 
506     /**
507      * @dev Derive the domain separator for EIP-712 signatures.
508      * @return The domain separator.
509      */
510     function _deriveDomainSeparator() private view returns (bytes32) {
511         return keccak256(
512             abi.encode(
513                 _EIP_712_DOMAIN_TYPEHASH, // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
514                 _NAME_HASH, // keccak256("Wyvern Exchange Contract")
515                 _VERSION_HASH, // keccak256(bytes("2.3"))
516                 _CHAIN_ID, // NOTE: this is fixed, need to use solidity 0.5+ or make external call to support!
517                 address(this)
518             )
519         );
520     }
521 
522     /**
523      * Increment a particular maker's nonce, thereby invalidating all orders that were not signed
524      * with the original nonce.
525      */
526     function incrementNonce() external {
527         uint newNonce = ++nonces[msg.sender];
528         emit NonceIncremented(msg.sender, newNonce);
529     }
530     
531     /**
532      * @dev Change The token used to pay exchange fees (owner only)
533      * @param newExchangeToken New exchangeToken
534      */
535     function changeExchangeToken(ERC20 newExchangeToken)
536         public
537         onlyOwner
538     {
539         exchangeToken = newExchangeToken;
540     }
541 
542     function changeChainID(uint256 chainID)
543         public
544         onlyOwner
545     {
546         _CHAIN_ID = chainID;
547         DOMAIN_SEPARATOR = _deriveDomainSeparator();
548     }
549 
550     /**
551      * @dev Change exchangeWrap (owner only)
552      * @param _exchangeWrap New exchangeWrap
553      */
554     function changeExchangeWrap(address _exchangeWrap)
555         public
556         onlyOwner
557     {
558         exchangeWrap = _exchangeWrap;
559     }
560 
561     /**
562      * if exchangeWrap send orders, The real sender is _sender
563      */
564     function getSender(address _sender) internal view returns(address) {
565         if(msg.sender == exchangeWrap) {
566             return _sender;
567         }
568         return msg.sender;
569     }
570 
571     /**
572      * @dev Change the minimum maker fee paid to the protocol (owner only)
573      * @param newMinimumMakerProtocolFee New fee to set in basis points
574      */
575     function changeMinimumMakerProtocolFee(uint newMinimumMakerProtocolFee)
576         public
577         onlyOwner
578     {
579         minimumMakerProtocolFee = newMinimumMakerProtocolFee;
580     }
581 
582     /**
583      * @dev Change the minimum taker fee paid to the protocol (owner only)
584      * @param newMinimumTakerProtocolFee New fee to set in basis points
585      */
586     function changeMinimumTakerProtocolFee(uint newMinimumTakerProtocolFee)
587         public
588         onlyOwner
589     {
590         minimumTakerProtocolFee = newMinimumTakerProtocolFee;
591     }
592 
593     /**
594      * @dev Change the protocol fee recipient (owner only)
595      * @param newProtocolFeeRecipient New protocol fee recipient address
596      */
597     function changeProtocolFeeRecipient(address newProtocolFeeRecipient)
598         public
599         onlyOwner
600     {
601         protocolFeeRecipient = newProtocolFeeRecipient;
602     }
603 
604     /**
605      * @dev Transfer tokens
606      * @param token Token to transfer
607      * @param from Address to charge fees
608      * @param to Address to receive fees
609      * @param amount Amount of protocol tokens to charge
610      */
611     function transferTokens(address token, address from, address to, uint amount)
612         internal
613     {
614         if (amount > 0) {
615             require(tokenTransferProxy.transferFrom(token, from, to, amount), 'Transfer Token Error.');
616         }
617     }
618 
619     /**
620      * @dev Charge a fee in protocol tokens
621      * @param from Address to charge fees
622      * @param to Address to receive fees
623      * @param amount Amount of protocol tokens to charge
624      */
625     function chargeProtocolFee(address from, address to, uint amount)
626         internal
627     {
628         transferTokens(exchangeToken, from, to, amount);
629     }
630 
631     /**
632      * @dev Execute a STATICCALL (introduced with Ethereum Metropolis, non-state-modifying external call)
633      * @param target Contract to call
634      * @param calldata Calldata (appended to extradata)
635      * @param extradata Base data for STATICCALL (probably function selector and argument encoding)
636      * @return The result of the call (success or failure)
637      */
638     function staticCall(address target, bytes memory calldata, bytes memory extradata)
639         public
640         view
641         returns (bool result)
642     {
643         bytes memory combined = new bytes(calldata.length + extradata.length);
644         uint index;
645         assembly {
646             index := add(combined, 0x20)
647         }
648         index = ArrayUtils.unsafeWriteBytes(index, extradata);
649         ArrayUtils.unsafeWriteBytes(index, calldata);
650         assembly {
651             result := staticcall(gas, target, add(combined, 0x20), mload(combined), mload(0x40), 0)
652         }
653         return result;
654     }
655 
656     /**
657      * @dev Hash an order, returning the canonical EIP-712 order hash without the domain separator
658      * @param order Order to hash
659      * @param nonce maker nonce to hash
660      * @return Hash of order
661      */
662     function hashOrder(Order memory order, uint nonce)
663         internal
664         pure
665         returns (bytes32 hash)
666     {
667         /* Unfortunately abi.encodePacked doesn't work here, stack size constraints. */
668         uint size = 800;
669         bytes memory array = new bytes(size);
670         uint index;
671         assembly {
672             index := add(array, 0x20)
673         }
674         index = ArrayUtils.unsafeWriteBytes32(index, _ORDER_TYPEHASH);
675         index = ArrayUtils.unsafeWriteAddressWord(index, order.exchange);
676         index = ArrayUtils.unsafeWriteAddressWord(index, order.maker);
677         index = ArrayUtils.unsafeWriteAddressWord(index, order.taker);
678         index = ArrayUtils.unsafeWriteUint(index, order.makerRelayerFee);
679         index = ArrayUtils.unsafeWriteUint(index, order.takerRelayerFee);
680         index = ArrayUtils.unsafeWriteUint(index, order.makerProtocolFee);
681         index = ArrayUtils.unsafeWriteUint(index, order.takerProtocolFee);
682         index = ArrayUtils.unsafeWriteAddressWord(index, order.feeRecipient);
683         index = ArrayUtils.unsafeWriteUint8Word(index, uint8(order.feeMethod));
684         index = ArrayUtils.unsafeWriteUint8Word(index, uint8(order.side));
685         index = ArrayUtils.unsafeWriteUint8Word(index, uint8(order.saleKind));
686         index = ArrayUtils.unsafeWriteAddressWord(index, order.target);
687         index = ArrayUtils.unsafeWriteUint8Word(index, uint8(order.howToCall));
688         index = ArrayUtils.unsafeWriteBytes32(index, keccak256(order.calldata));
689         index = ArrayUtils.unsafeWriteBytes32(index, keccak256(order.replacementPattern));
690         index = ArrayUtils.unsafeWriteAddressWord(index, order.staticTarget);
691         index = ArrayUtils.unsafeWriteBytes32(index, keccak256(order.staticExtradata));
692         index = ArrayUtils.unsafeWriteAddressWord(index, order.paymentToken);
693         index = ArrayUtils.unsafeWriteUint(index, order.basePrice);
694         index = ArrayUtils.unsafeWriteUint(index, order.extra);
695         index = ArrayUtils.unsafeWriteUint(index, order.listingTime);
696         index = ArrayUtils.unsafeWriteUint(index, order.expirationTime);
697         index = ArrayUtils.unsafeWriteUint(index, order.salt);
698         index = ArrayUtils.unsafeWriteUint(index, nonce);
699         assembly {
700             hash := keccak256(add(array, 0x20), size)
701         }
702         return hash;
703     }
704 
705     /**
706      * @dev Hash an order, returning the hash that a client must sign via EIP-712 including the message prefix
707      * @param order Order to hash
708      * @param nonce Nonce to hash
709      * @return Hash of message prefix and order hash per Ethereum format
710      */
711     function hashToSign(Order memory order, uint nonce)
712         internal
713         view
714         returns (bytes32)
715     {
716         return keccak256(
717             abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hashOrder(order, nonce))
718         );
719     }
720 
721     /**
722      * @dev Assert an order is valid and return its hash
723      * @param order Order to validate
724      * @param nonce Nonce to validate
725      * @param sig ECDSA signature
726      */
727     function requireValidOrder(Order memory order, Sig memory sig, uint nonce)
728         internal
729         view
730         returns (bytes32)
731     {
732         bytes32 hash = hashToSign(order, nonce);
733         require(validateOrder(hash, order, sig), "Not a validate order");
734         return hash;
735     }
736 
737     /**
738      * @dev Validate order parameters (does *not* check signature validity)
739      * @param order Order to validate
740      */
741     function validateOrderParameters(Order memory order)
742         internal
743         view
744         returns (bool)
745     {
746         /* Order must be targeted at this protocol version (this Exchange contract). */
747         if (order.exchange != address(this)) {
748             return false;
749         }
750 
751         /* Order must have a maker. */
752         if (order.maker == address(0)) {
753             return false;
754         }
755 
756         /* Order must possess valid sale kind parameter combination. */
757         if (!SaleKindInterface.validateParameters(order.saleKind, order.expirationTime)) {
758             return false;
759         }
760 
761         /* If using the split fee method, order must have sufficient protocol fees. */
762         if (order.feeMethod == FeeMethod.SplitFee && (order.makerProtocolFee < minimumMakerProtocolFee || order.takerProtocolFee < minimumTakerProtocolFee)) {
763             return false;
764         }
765 
766         return true;
767     }
768 
769     /**
770      * @dev Validate a provided previously approved / signed order, hash, and signature.
771      * @param hash Order hash (already calculated, passed to avoid recalculation)
772      * @param order Order to validate
773      * @param sig ECDSA signature
774      */
775     function validateOrder(bytes32 hash, Order memory order, Sig memory sig)
776         internal
777         view
778         returns (bool)
779     {
780         /* Not done in an if-conditional to prevent unnecessary ecrecover evaluation, which seems to happen even though it should short-circuit. */
781 
782         /* Order must have valid parameters. */
783         if (!validateOrderParameters(order)) {
784             return false;
785         }
786 
787         /* Order must have not been canceled or already filled. */
788         if (cancelledOrFinalized[hash]) {
789             return false;
790         }
791 
792         /* Return true if order has been previously approved with the current nonce */
793         uint approvedOrderNoncePlusOne = _approvedOrdersByNonce[hash];
794         if (approvedOrderNoncePlusOne != 0) {
795             return approvedOrderNoncePlusOne == nonces[order.maker] + 1;
796         }
797 
798         /* Prevent signature malleability and non-standard v values. */
799         if (uint256(sig.s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
800             return false;
801         }
802         if (sig.v != 27 && sig.v != 28) {
803             return false;
804         }
805 
806         /* recover via ECDSA, signed by maker (already verified as non-zero). */
807         if (ecrecover(hash, sig.v, sig.r, sig.s) == order.maker) {
808             return true;
809         }
810 
811         /* fallback — attempt EIP-1271 isValidSignature check. */
812         return _tryContractSignature(order.maker, hash, sig);
813     }
814 
815     function _tryContractSignature(address orderMaker, bytes32 hash, Sig memory sig) internal view returns (bool) {
816         bytes memory isValidSignatureData = abi.encodeWithSelector(
817             _EIP_1271_MAGIC_VALUE,
818             hash,
819             abi.encodePacked(sig.r, sig.s, sig.v)
820         );
821 
822         bytes4 result;
823 
824         // NOTE: solidity 0.4.x does not support STATICCALL outside of assembly
825         assembly {
826             let success := staticcall(           // perform a staticcall
827                 gas,                             // forward all available gas
828                 orderMaker,                      // call the order maker
829                 add(isValidSignatureData, 0x20), // calldata offset comes after length
830                 mload(isValidSignatureData),     // load calldata length
831                 0,                               // do not use memory for return data
832                 0                                // do not use memory for return data
833             )
834 
835             if iszero(success) {                     // if the call fails
836                 returndatacopy(0, 0, returndatasize) // copy returndata buffer to memory
837                 revert(0, returndatasize)            // revert + pass through revert data
838             }
839 
840             if eq(returndatasize, 0x20) {  // if returndata == 32 (one word)
841                 returndatacopy(0, 0, 0x20) // copy return data to memory in scratch space
842                 result := mload(0)         // load return data from memory to the stack
843             }
844         }
845 
846         return result == _EIP_1271_MAGIC_VALUE;
847     }
848 
849     /**
850      * @dev Determine if an order has been approved. Note that the order may not still
851      * be valid in cases where the maker's nonce has been incremented.
852      * @param hash Hash of the order
853      * @return whether or not the order was approved.
854      */
855     function approvedOrders(bytes32 hash) public view returns (bool approved) {
856         return _approvedOrdersByNonce[hash] != 0;
857     }
858 
859     /**
860      * @dev Approve an order and optionally mark it for orderbook inclusion. Must be called by the maker of the order
861      * @param order Order to approve
862      * @param orderbookInclusionDesired Whether orderbook providers should include the order in their orderbooks
863      */
864     function approveOrder(Order memory order, bool orderbookInclusionDesired)
865         internal
866     {
867         /* CHECKS */
868 
869         /* Assert sender is authorized to approve order. */
870         require(msg.sender == order.maker, "Sender must to be order.maker");
871 
872         /* Calculate order hash. */
873         bytes32 hash = hashToSign(order, nonces[order.maker]);
874 
875         /* Assert order has not already been approved. */
876         require(_approvedOrdersByNonce[hash] == 0, "Order has already been approved");
877 
878         /* EFFECTS */
879 
880         /* Mark order as approved. */
881         _approvedOrdersByNonce[hash] = nonces[order.maker] + 1;
882 
883         /* Log approval event. Must be split in two due to Solidity stack size limitations. */
884         {
885             emit OrderApprovedPartOne(hash, order.exchange, order.maker, order.taker, order.makerRelayerFee, order.takerRelayerFee, order.makerProtocolFee, order.takerProtocolFee, order.feeRecipient, order.feeMethod, order.side, order.saleKind, order.target);
886         }
887         {
888             emit OrderApprovedPartTwo(hash, order.howToCall, order.calldata, order.replacementPattern, order.staticTarget, order.staticExtradata, order.paymentToken, order.basePrice, order.extra, order.listingTime, order.expirationTime, order.salt, orderbookInclusionDesired);
889         }
890     }
891 
892     /**
893      * @dev Cancel an order, preventing it from being matched. Must be called by the maker of the order
894      * @param order Order to cancel
895      * @param nonce Nonce to cancel
896      * @param sig ECDSA signature
897      */
898     function cancelOrder(Order memory order, Sig memory sig, uint nonce)
899         internal
900     {
901         /* CHECKS */
902 
903         /* Calculate order hash. */
904         bytes32 hash = requireValidOrder(order, sig, nonce);
905 
906         /* Assert sender is authorized to cancel order. */
907         require(msg.sender == order.maker, "Sender must to be order.maker");
908 
909         /* EFFECTS */
910 
911         /* Mark order as cancelled, preventing it from being matched. */
912         cancelledOrFinalized[hash] = true;
913 
914         /* Log cancel event. */
915         emit OrderCancelled(hash);
916     }
917 
918     /**
919      * @dev Calculate the current price of an order (convenience function)
920      * @param order Order to calculate the price of
921      * @return The current price of the order
922      */
923     function calculateCurrentPrice (Order memory order)
924         internal
925         view
926         returns (uint)
927     {
928         return SaleKindInterface.calculateFinalPrice(order.side, order.saleKind, order.basePrice, order.extra, order.listingTime, order.expirationTime);
929     }
930 
931     /**
932      * @dev Calculate the price two orders would match at, if in fact they would match (otherwise fail)
933      * @param buy Buy-side order
934      * @param sell Sell-side order
935      * @return Match price
936      */
937     function calculateMatchPrice(Order memory buy, Order memory sell)
938         view
939         internal
940         returns (uint)
941     {
942         /* Calculate sell price. */
943         uint sellPrice = SaleKindInterface.calculateFinalPrice(sell.side, sell.saleKind, sell.basePrice, sell.extra, sell.listingTime, sell.expirationTime);
944 
945         /* Calculate buy price. */
946         uint buyPrice = SaleKindInterface.calculateFinalPrice(buy.side, buy.saleKind, buy.basePrice, buy.extra, buy.listingTime, buy.expirationTime);
947 
948         /* Require price cross. */
949         require(buyPrice >= sellPrice, "buyPrice>= sellPrice");
950 
951         /* Maker/taker priority. */
952         return sell.feeRecipient != address(0) ? sellPrice : buyPrice;
953     }
954 
955     /**
956      * @dev Execute all ERC20 token / Ether transfers associated with an order match (fees and buyer => seller transfer)
957      * @param buy Buy-side order
958      * @param sell Sell-side order
959      */
960     function executeFundsTransfer(Order memory buy, Order memory sell)
961         internal
962         returns (uint)
963     {
964         /* Only payable in the special case of unwrapped Ether. */
965         if (sell.paymentToken != address(0)) {
966             require(msg.value == 0, "Do not send ETH.");
967         }
968 
969         /* Calculate match price. */
970         uint price = calculateMatchPrice(buy, sell);
971 
972         /* If paying using a token (not Ether), transfer tokens. This is done prior to fee payments to that a seller will have tokens before being charged fees. */
973         if (price > 0 && sell.paymentToken != address(0)) {
974             transferTokens(sell.paymentToken, buy.maker, sell.maker, price);
975         }
976 
977         /* Amount that will be received by seller (for Ether). */
978         uint receiveAmount = price;
979 
980         /* Amount that must be sent by buyer (for Ether). */
981         uint requiredAmount = price;
982 
983         /* Determine maker/taker and charge fees accordingly. */
984         if (sell.feeRecipient != address(0)) {
985             /* Sell-side order is maker. */
986 
987             /* Assert taker fee is less than or equal to maximum fee specified by buyer. */
988             require(sell.takerRelayerFee <= buy.takerRelayerFee, "sell.takerRelayerFee <= buy.takerRelayerFee");
989 
990             if (sell.feeMethod == FeeMethod.SplitFee) {
991                 /* Assert taker fee is less than or equal to maximum fee specified by buyer. */
992                 require(sell.takerProtocolFee <= buy.takerProtocolFee, "sell.takerProtocolFee <= buy.takerProtocolFee");
993 
994                 /* Maker fees are deducted from the token amount that the maker receives. Taker fees are extra tokens that must be paid by the taker. */
995 
996                 if (sell.makerRelayerFee > 0) {
997                     uint makerRelayerFee = SafeMath.div(SafeMath.mul(sell.makerRelayerFee, price), INVERSE_BASIS_POINT);
998                     if (sell.paymentToken == address(0)) {
999                         receiveAmount = SafeMath.sub(receiveAmount, makerRelayerFee);
1000                         sell.feeRecipient.transfer(makerRelayerFee);
1001                     } else {
1002                         transferTokens(sell.paymentToken, sell.maker, sell.feeRecipient, makerRelayerFee);
1003                     }
1004                 }
1005 
1006                 if (sell.takerRelayerFee > 0) {
1007                     uint takerRelayerFee = SafeMath.div(SafeMath.mul(sell.takerRelayerFee, price), INVERSE_BASIS_POINT);
1008                     if (sell.paymentToken == address(0)) {
1009                         requiredAmount = SafeMath.add(requiredAmount, takerRelayerFee);
1010                         sell.feeRecipient.transfer(takerRelayerFee);
1011                     } else {
1012                         transferTokens(sell.paymentToken, buy.maker, sell.feeRecipient, takerRelayerFee);
1013                     }
1014                 }
1015 
1016                 if (sell.makerProtocolFee > 0) {
1017                     uint makerProtocolFee = SafeMath.div(SafeMath.mul(sell.makerProtocolFee, price), INVERSE_BASIS_POINT);
1018                     if (sell.paymentToken == address(0)) {
1019                         receiveAmount = SafeMath.sub(receiveAmount, makerProtocolFee);
1020                         protocolFeeRecipient.transfer(makerProtocolFee);
1021                     } else {
1022                         transferTokens(sell.paymentToken, sell.maker, protocolFeeRecipient, makerProtocolFee);
1023                     }
1024                 }
1025 
1026                 if (sell.takerProtocolFee > 0) {
1027                     uint takerProtocolFee = SafeMath.div(SafeMath.mul(sell.takerProtocolFee, price), INVERSE_BASIS_POINT);
1028                     if (sell.paymentToken == address(0)) {
1029                         requiredAmount = SafeMath.add(requiredAmount, takerProtocolFee);
1030                         protocolFeeRecipient.transfer(takerProtocolFee);
1031                     } else {
1032                         transferTokens(sell.paymentToken, buy.maker, protocolFeeRecipient, takerProtocolFee);
1033                     }
1034                 }
1035 
1036             } else {
1037                 /* Charge maker fee to seller. */
1038                 chargeProtocolFee(sell.maker, sell.feeRecipient, sell.makerRelayerFee);
1039 
1040                 /* Charge taker fee to buyer. */
1041                 chargeProtocolFee(buy.maker, sell.feeRecipient, sell.takerRelayerFee);
1042             }
1043         } else {
1044             /* Buy-side order is maker. */
1045 
1046             /* Assert taker fee is less than or equal to maximum fee specified by seller. */
1047             require(buy.takerRelayerFee <= sell.takerRelayerFee, "buy.takerRelayerFee <= sell.takerRelayerFee");
1048 
1049             if (sell.feeMethod == FeeMethod.SplitFee) {
1050                 /* The Exchange does not escrow Ether, so direct Ether can only be used to with sell-side maker / buy-side taker orders. */
1051                 require(sell.paymentToken != address(0), "sell.paymentToken != address(0)");
1052 
1053                 /* Assert taker fee is less than or equal to maximum fee specified by seller. */
1054                 require(buy.takerProtocolFee <= sell.takerProtocolFee, "buy.takerProtocolFee <= sell.takerProtocolFee");
1055 
1056                 if (buy.makerRelayerFee > 0) {
1057                     makerRelayerFee = SafeMath.div(SafeMath.mul(buy.makerRelayerFee, price), INVERSE_BASIS_POINT);
1058                     transferTokens(sell.paymentToken, buy.maker, buy.feeRecipient, makerRelayerFee);
1059                 }
1060 
1061                 if (buy.takerRelayerFee > 0) {
1062                     takerRelayerFee = SafeMath.div(SafeMath.mul(buy.takerRelayerFee, price), INVERSE_BASIS_POINT);
1063                     transferTokens(sell.paymentToken, sell.maker, buy.feeRecipient, takerRelayerFee);
1064                 }
1065 
1066                 if (buy.makerProtocolFee > 0) {
1067                     makerProtocolFee = SafeMath.div(SafeMath.mul(buy.makerProtocolFee, price), INVERSE_BASIS_POINT);
1068                     transferTokens(sell.paymentToken, buy.maker, protocolFeeRecipient, makerProtocolFee);
1069                 }
1070 
1071                 if (buy.takerProtocolFee > 0) {
1072                     takerProtocolFee = SafeMath.div(SafeMath.mul(buy.takerProtocolFee, price), INVERSE_BASIS_POINT);
1073                     transferTokens(sell.paymentToken, sell.maker, protocolFeeRecipient, takerProtocolFee);
1074                 }
1075 
1076             } else {
1077                 /* Charge maker fee to buyer. */
1078                 chargeProtocolFee(buy.maker, buy.feeRecipient, buy.makerRelayerFee);
1079 
1080                 /* Charge taker fee to seller. */
1081                 chargeProtocolFee(sell.maker, buy.feeRecipient, buy.takerRelayerFee);
1082             }
1083         }
1084 
1085         if (sell.paymentToken == address(0)) {
1086             /* Special-case Ether, order must be matched by buyer. */
1087             require(msg.value >= requiredAmount, "msg.value >= requiredAmount");
1088             sell.maker.transfer(receiveAmount);
1089             /* Allow overshoot for variable-price auctions, refund difference. */
1090             uint diff = SafeMath.sub(msg.value, requiredAmount);
1091             if (diff > 0) {
1092                 buy.maker.transfer(diff);
1093             }
1094         }
1095 
1096         /* This contract should never hold Ether, however, we cannot assert this, since it is impossible to prevent anyone from sending Ether e.g. with selfdestruct. */
1097 
1098         return price;
1099     }
1100 
1101     /**
1102      * @dev Return whether or not two orders can be matched with each other by basic parameters (does not check order signatures / calldata or perform static calls)
1103      * @param buy Buy-side order
1104      * @param sell Sell-side order
1105      * @return Whether or not the two orders can be matched
1106      */
1107     function ordersCanMatch(Order memory buy, Order memory sell)
1108         internal
1109         view
1110         returns (bool)
1111     {
1112         return (
1113             /* Must be opposite-side. */
1114             (buy.side == SaleKindInterface.Side.Buy && sell.side == SaleKindInterface.Side.Sell) &&
1115             /* Must use same fee method. */
1116             (buy.feeMethod == sell.feeMethod) &&
1117             /* Must use same payment token. */
1118             (buy.paymentToken == sell.paymentToken) &&
1119             /* Must match maker/taker addresses. */
1120             (sell.taker == address(0) || sell.taker == buy.maker) &&
1121             (buy.taker == address(0) || buy.taker == sell.maker) &&
1122             /* One must be maker and the other must be taker (no bool XOR in Solidity). */
1123             ((sell.feeRecipient == address(0) && buy.feeRecipient != address(0)) || (sell.feeRecipient != address(0) && buy.feeRecipient == address(0))) &&
1124             /* Must match target. */
1125             (buy.target == sell.target) &&
1126             /* Must match howToCall. */
1127             (buy.howToCall == sell.howToCall) &&
1128             /* Buy-side order must be settleable. */
1129             SaleKindInterface.canSettleOrder(buy.listingTime, buy.expirationTime) &&
1130             /* Sell-side order must be settleable. */
1131             SaleKindInterface.canSettleOrder(sell.listingTime, sell.expirationTime)
1132         );
1133     }
1134 
1135     /**
1136      * @dev Atomically match two orders, ensuring validity of the match, and execute all associated state transitions. Protected against reentrancy by a contract-global lock.
1137      * @param buy Buy-side order
1138      * @param buySig Buy-side order signature
1139      * @param sell Sell-side order
1140      * @param sellSig Sell-side order signature
1141      */
1142     function atomicMatch(Order memory buy, Sig memory buySig, Order memory sell, Sig memory sellSig, bytes32 metadata)
1143         internal
1144         reentrancyGuard
1145     {
1146         /* CHECKS */
1147         address msgSender = getSender(sell._sender);
1148 
1149         /* Ensure buy order validity and calculate hash if necessary. */
1150         bytes32 buyHash;
1151         if ( buy.maker == msgSender ) {
1152             require(validateOrderParameters(buy), "validateOrderParameters buy");
1153         } else {
1154             buyHash = _requireValidOrderWithNonce(buy, buySig);
1155         }
1156 
1157         /* Ensure sell order validity and calculate hash if necessary. */
1158         bytes32 sellHash;
1159         if ( sell.maker == msgSender ) {
1160             require(validateOrderParameters(sell), "validateOrderParameters sell");
1161         } else {
1162             sellHash = _requireValidOrderWithNonce(sell, sellSig);
1163         }
1164 
1165         /* Must be matchable. */
1166         require(ordersCanMatch(buy, sell), "ordersCanMatch buy and sell");
1167 
1168         /* Target must exist (prevent malicious selfdestructs just prior to order settlement). */
1169         uint size;
1170         address target = sell.target;
1171         assembly {
1172             size := extcodesize(target)
1173         }
1174         require(size > 0, "size require");
1175 
1176         /* Must match calldata after replacement, if specified. */
1177         if (buy.replacementPattern.length > 0) {
1178           ArrayUtils.guardedArrayReplace(buy.calldata, sell.calldata, buy.replacementPattern);
1179         }
1180         if (sell.replacementPattern.length > 0) {
1181           ArrayUtils.guardedArrayReplace(sell.calldata, buy.calldata, sell.replacementPattern);
1182         }
1183         require(ArrayUtils.arrayEq(buy.calldata, sell.calldata), "buy and sell calldata eq");
1184 
1185         /* Retrieve delegateProxy contract. */
1186         OwnableDelegateProxy delegateProxy = registry.proxies(sell.maker);
1187 
1188         /* Proxy must exist. */
1189         require(delegateProxy != address(0), "delegateProxy is zero");
1190 
1191         /* Access the passthrough AuthenticatedProxy. */
1192         AuthenticatedProxy proxy = AuthenticatedProxy(delegateProxy);
1193 
1194         /* EFFECTS */
1195 
1196         /* Mark previously signed or approved orders as finalized. */
1197         if (msgSender != buy.maker) {
1198             cancelledOrFinalized[buyHash] = true;
1199         }
1200         if (msgSender != sell.maker) {
1201             cancelledOrFinalized[sellHash] = true;
1202         }
1203 
1204         /* INTERACTIONS */
1205 
1206         /* Execute funds transfer and pay fees. */
1207         uint price = executeFundsTransfer(buy, sell);
1208 
1209         /* Assert implementation. */
1210         require(delegateProxy.implementation() == registry.delegateProxyImplementation(), "implementation require");
1211 
1212         /* Execute specified call through proxy. */
1213         require(proxy.proxy(sell.target, sell.howToCall, sell.calldata), "target calldata require");
1214 
1215         /* Static calls are intentionally done after the effectful call so they can check resulting state. */
1216 
1217         /* Handle buy-side static call if specified. */
1218         if (buy.staticTarget != address(0)) {
1219             require(staticCall(buy.staticTarget, sell.calldata, buy.staticExtradata), "staticCall buy");
1220         }
1221 
1222         /* Handle sell-side static call if specified. */
1223         if (sell.staticTarget != address(0)) {
1224             require(staticCall(sell.staticTarget, sell.calldata, sell.staticExtradata), "staticCall sell");
1225         }
1226 
1227         /* Log match event. */
1228         emit OrdersMatched(buyHash, sellHash, sell.feeRecipient != address(0) ? sell.maker : buy.maker, sell.feeRecipient != address(0) ? buy.maker : sell.maker, price, metadata);
1229     }
1230 
1231     function _requireValidOrderWithNonce(Order memory order, Sig memory sig) internal view returns (bytes32) {
1232         return requireValidOrder(order, sig, nonces[order.maker]);
1233     }
1234 }
1235 
1236 contract Exchange is ExchangeCore {
1237 
1238     /**
1239      * @dev Call guardedArrayReplace - library function exposed for testing.
1240      */
1241     function guardedArrayReplace(bytes array, bytes desired, bytes mask)
1242         public
1243         pure
1244         returns (bytes)
1245     {
1246         ArrayUtils.guardedArrayReplace(array, desired, mask);
1247         return array;
1248     }
1249 
1250     /**
1251      * @dev Call calculateFinalPrice - library function exposed for testing.
1252      */
1253     function calculateFinalPrice(SaleKindInterface.Side side, SaleKindInterface.SaleKind saleKind, uint basePrice, uint extra, uint listingTime, uint expirationTime)
1254         public
1255         view
1256         returns (uint)
1257     {
1258         return SaleKindInterface.calculateFinalPrice(side, saleKind, basePrice, extra, listingTime, expirationTime);
1259     }
1260 
1261     /**
1262      * @dev Call hashOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1263      */
1264     function hashOrder_(
1265         address[7] addrs,
1266         uint[9] uints,
1267         FeeMethod feeMethod,
1268         SaleKindInterface.Side side,
1269         SaleKindInterface.SaleKind saleKind,
1270         AuthenticatedProxy.HowToCall howToCall,
1271         bytes calldata,
1272         bytes replacementPattern,
1273         bytes staticExtradata)
1274         public
1275         view
1276         returns (bytes32)
1277     {
1278         return hashOrder(
1279           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8], msg.sender),
1280           nonces[addrs[1]]
1281         );
1282     }
1283 
1284     /**
1285      * @dev Call hashToSign - Solidity ABI encoding limitation workaround, hopefully temporary.
1286      */
1287     function hashToSign_(
1288         address[7] addrs,
1289         uint[9] uints,
1290         FeeMethod feeMethod,
1291         SaleKindInterface.Side side,
1292         SaleKindInterface.SaleKind saleKind,
1293         AuthenticatedProxy.HowToCall howToCall,
1294         bytes calldata,
1295         bytes replacementPattern,
1296         bytes staticExtradata)
1297         public
1298         view
1299         returns (bytes32)
1300     {
1301         return hashToSign(
1302           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8], msg.sender),
1303           nonces[addrs[1]]
1304         );
1305     }
1306 
1307     /**
1308      * @dev Call validateOrderParameters - Solidity ABI encoding limitation workaround, hopefully temporary.
1309      */
1310     function validateOrderParameters_ (
1311         address[7] addrs,
1312         uint[9] uints,
1313         FeeMethod feeMethod,
1314         SaleKindInterface.Side side,
1315         SaleKindInterface.SaleKind saleKind,
1316         AuthenticatedProxy.HowToCall howToCall,
1317         bytes calldata,
1318         bytes replacementPattern,
1319         bytes staticExtradata)
1320         view
1321         public
1322         returns (bool)
1323     {
1324         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8], msg.sender);
1325         return validateOrderParameters(
1326           order
1327         );
1328     }
1329 
1330     /**
1331      * @dev Call validateOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1332      */
1333     function validateOrder_ (
1334         address[7] addrs,
1335         uint[9] uints,
1336         FeeMethod feeMethod,
1337         SaleKindInterface.Side side,
1338         SaleKindInterface.SaleKind saleKind,
1339         AuthenticatedProxy.HowToCall howToCall,
1340         bytes calldata,
1341         bytes replacementPattern,
1342         bytes staticExtradata,
1343         uint8 v,
1344         bytes32 r,
1345         bytes32 s)
1346         view
1347         public
1348         returns (bool)
1349     {
1350         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8], msg.sender);
1351         return validateOrder(
1352           hashToSign(order, nonces[order.maker]),
1353           order,
1354           Sig(v, r, s)
1355         );
1356     }
1357 
1358     /**
1359      * @dev Call approveOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1360      */
1361     function approveOrder_ (
1362         address[7] addrs,
1363         uint[9] uints,
1364         FeeMethod feeMethod,
1365         SaleKindInterface.Side side,
1366         SaleKindInterface.SaleKind saleKind,
1367         AuthenticatedProxy.HowToCall howToCall,
1368         bytes calldata,
1369         bytes replacementPattern,
1370         bytes staticExtradata,
1371         bool orderbookInclusionDesired)
1372         public
1373     {
1374         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8], msg.sender);
1375         return approveOrder(order, orderbookInclusionDesired);
1376     }
1377 
1378     /**
1379      * @dev Call cancelOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1380      */
1381     function cancelOrder_(
1382         address[7] addrs,
1383         uint[9] uints,
1384         FeeMethod feeMethod,
1385         SaleKindInterface.Side side,
1386         SaleKindInterface.SaleKind saleKind,
1387         AuthenticatedProxy.HowToCall howToCall,
1388         bytes calldata,
1389         bytes replacementPattern,
1390         bytes staticExtradata,
1391         uint8 v,
1392         bytes32 r,
1393         bytes32 s)
1394         public
1395     {
1396         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8], msg.sender);
1397         return cancelOrder(
1398           order,
1399           Sig(v, r, s),
1400           nonces[order.maker]
1401         );
1402     }
1403 
1404     /**
1405      * @dev Call cancelOrder, supplying a specific nonce — enables cancelling orders
1406      that were signed with nonces greater than the current nonce.
1407      */
1408     function cancelOrderWithNonce_(
1409         address[7] addrs,
1410         uint[9] uints,
1411         FeeMethod feeMethod,
1412         SaleKindInterface.Side side,
1413         SaleKindInterface.SaleKind saleKind,
1414         AuthenticatedProxy.HowToCall howToCall,
1415         bytes calldata,
1416         bytes replacementPattern,
1417         bytes staticExtradata,
1418         uint8 v,
1419         bytes32 r,
1420         bytes32 s,
1421         uint nonce)
1422         public
1423     {
1424         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8], msg.sender);
1425         return cancelOrder(
1426           order,
1427           Sig(v, r, s),
1428           nonce
1429         );
1430     }
1431 
1432     /**
1433      * @dev Call calculateCurrentPrice - Solidity ABI encoding limitation workaround, hopefully temporary.
1434      */
1435     function calculateCurrentPrice_(
1436         address[7] addrs,
1437         uint[9] uints,
1438         FeeMethod feeMethod,
1439         SaleKindInterface.Side side,
1440         SaleKindInterface.SaleKind saleKind,
1441         AuthenticatedProxy.HowToCall howToCall,
1442         bytes calldata,
1443         bytes replacementPattern,
1444         bytes staticExtradata)
1445         public
1446         view
1447         returns (uint)
1448     {
1449         return calculateCurrentPrice(
1450           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8], msg.sender)
1451         );
1452     }
1453 
1454     /**
1455      * @dev Call ordersCanMatch - Solidity ABI encoding limitation workaround, hopefully temporary.
1456      */
1457     function ordersCanMatch_(
1458         address[14] addrs,
1459         uint[18] uints,
1460         uint8[8] feeMethodsSidesKindsHowToCalls,
1461         bytes calldataBuy,
1462         bytes calldataSell,
1463         bytes replacementPatternBuy,
1464         bytes replacementPatternSell,
1465         bytes staticExtradataBuy,
1466         bytes staticExtradataSell)
1467         public
1468         view
1469         returns (bool)
1470     {
1471         Order memory buy = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8], msg.sender);
1472         Order memory sell = Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17], msg.sender);
1473         return ordersCanMatch(
1474           buy,
1475           sell
1476         );
1477     }
1478 
1479     /**
1480      * @dev Return whether or not two orders' calldata specifications can match
1481      * @param buyCalldata Buy-side order calldata
1482      * @param buyReplacementPattern Buy-side order calldata replacement mask
1483      * @param sellCalldata Sell-side order calldata
1484      * @param sellReplacementPattern Sell-side order calldata replacement mask
1485      * @return Whether the orders' calldata can be matched
1486      */
1487     function orderCalldataCanMatch(bytes buyCalldata, bytes buyReplacementPattern, bytes sellCalldata, bytes sellReplacementPattern)
1488         public
1489         pure
1490         returns (bool)
1491     {
1492         if (buyReplacementPattern.length > 0) {
1493           ArrayUtils.guardedArrayReplace(buyCalldata, sellCalldata, buyReplacementPattern);
1494         }
1495         if (sellReplacementPattern.length > 0) {
1496           ArrayUtils.guardedArrayReplace(sellCalldata, buyCalldata, sellReplacementPattern);
1497         }
1498         return ArrayUtils.arrayEq(buyCalldata, sellCalldata);
1499     }
1500 
1501     /**
1502      * @dev Call calculateMatchPrice - Solidity ABI encoding limitation workaround, hopefully temporary.
1503      */
1504     function calculateMatchPrice_(
1505         address[14] addrs,
1506         uint[18] uints,
1507         uint8[8] feeMethodsSidesKindsHowToCalls,
1508         bytes calldataBuy,
1509         bytes calldataSell,
1510         bytes replacementPatternBuy,
1511         bytes replacementPatternSell,
1512         bytes staticExtradataBuy,
1513         bytes staticExtradataSell)
1514         public
1515         view
1516         returns (uint)
1517     {
1518         Order memory buy = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8], msg.sender);
1519         Order memory sell = Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17], msg.sender);
1520         return calculateMatchPrice(
1521           buy,
1522           sell
1523         );
1524     }
1525 
1526     /**
1527      * @dev Call atomicMatch - Solidity ABI encoding limitation workaround, hopefully temporary.
1528      */
1529     function atomicMatch_(
1530         address[15] addrs,
1531         uint[18] uints,
1532         uint8[8] feeMethodsSidesKindsHowToCalls,
1533         bytes calldataBuy,
1534         bytes calldataSell,
1535         bytes replacementPatternBuy,
1536         bytes replacementPatternSell,
1537         bytes staticExtradataBuy,
1538         bytes staticExtradataSell,
1539         uint8[2] vs,
1540         bytes32[5] rssMetadata)
1541         public
1542         payable
1543     {
1544 
1545         return atomicMatch(
1546           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8], addrs[14]),
1547           Sig(vs[0], rssMetadata[0], rssMetadata[1]),
1548           Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17], addrs[14]),
1549           Sig(vs[1], rssMetadata[2], rssMetadata[3]),
1550           rssMetadata[4]
1551         );
1552     }
1553 
1554 }
1555 
1556 contract MarketExchange is Exchange {
1557     /**
1558      * @dev Initialize a WyvernExchange instance
1559      * @param registryAddress Address of the registry instance which this Exchange instance will use
1560      * @param tokenAddress Address of the token used for protocol fees
1561      */
1562     constructor (ProxyRegistry registryAddress, TokenTransferProxy tokenTransferProxyAddress, ERC20 tokenAddress, address protocolFeeAddress) public {
1563         registry = registryAddress;
1564         tokenTransferProxy = tokenTransferProxyAddress;
1565         exchangeToken = tokenAddress;
1566         protocolFeeRecipient = protocolFeeAddress;
1567         owner = msg.sender;
1568     }
1569 }
1570 
1571 library SaleKindInterface {
1572 
1573     /**
1574      * Side: buy or sell.
1575      */
1576     enum Side { Buy, Sell }
1577 
1578     /**
1579      * Currently supported kinds of sale: fixed price, Dutch auction.
1580      * English auctions cannot be supported without stronger escrow guarantees.
1581      * Future interesting options: Vickrey auction, nonlinear Dutch auctions.
1582      */
1583     enum SaleKind { FixedPrice, DutchAuction }
1584 
1585     /**
1586      * @dev Check whether the parameters of a sale are valid
1587      * @param saleKind Kind of sale
1588      * @param expirationTime Order expiration time
1589      * @return Whether the parameters were valid
1590      */
1591     function validateParameters(SaleKind saleKind, uint expirationTime)
1592         pure
1593         internal
1594         returns (bool)
1595     {
1596         /* Auctions must have a set expiration date. */
1597         return (saleKind == SaleKind.FixedPrice || expirationTime > 0);
1598     }
1599 
1600     /**
1601      * @dev Return whether or not an order can be settled
1602      * @dev Precondition: parameters have passed validateParameters
1603      * @param listingTime Order listing time
1604      * @param expirationTime Order expiration time
1605      */
1606     function canSettleOrder(uint listingTime, uint expirationTime)
1607         view
1608         internal
1609         returns (bool)
1610     {
1611         return (listingTime < now) && (expirationTime == 0 || now < expirationTime);
1612     }
1613 
1614     /**
1615      * @dev Calculate the settlement price of an order
1616      * @dev Precondition: parameters have passed validateParameters.
1617      * @param side Order side
1618      * @param saleKind Method of sale
1619      * @param basePrice Order base price
1620      * @param extra Order extra price data
1621      * @param listingTime Order listing time
1622      * @param expirationTime Order expiration time
1623      */
1624     function calculateFinalPrice(Side side, SaleKind saleKind, uint basePrice, uint extra, uint listingTime, uint expirationTime)
1625         view
1626         internal
1627         returns (uint finalPrice)
1628     {
1629         if (saleKind == SaleKind.FixedPrice) {
1630             return basePrice;
1631         } else if (saleKind == SaleKind.DutchAuction) {
1632             uint diff = SafeMath.div(SafeMath.mul(extra, SafeMath.sub(now, listingTime)), SafeMath.sub(expirationTime, listingTime));
1633             if (side == Side.Sell) {
1634                 /* Sell-side - start price: basePrice. End price: basePrice - extra. */
1635                 return SafeMath.sub(basePrice, diff);
1636             } else {
1637                 /* Buy-side - start price: basePrice. End price: basePrice + extra. */
1638                 return SafeMath.add(basePrice, diff);
1639             }
1640         }
1641     }
1642 
1643 }
1644 
1645 contract ProxyRegistry is Ownable {
1646 
1647     /* DelegateProxy implementation contract. Must be initialized. */
1648     address public delegateProxyImplementation;
1649 
1650     /* Authenticated proxies by user. */
1651     mapping(address => OwnableDelegateProxy) public proxies;
1652 
1653     /* Contracts pending access. */
1654     mapping(address => uint) public pending;
1655 
1656     /* Contracts allowed to call those proxies. */
1657     mapping(address => bool) public contracts;
1658 
1659     /* Delay period for adding an authenticated contract.
1660        This mitigates a particular class of potential attack on the Wyvern DAO (which owns this registry) - if at any point the value of assets held by proxy contracts exceeded the value of half the WYV supply (votes in the DAO),
1661        a malicious but rational attacker could buy half the Wyvern and grant themselves access to all the proxy contracts. A delay period renders this attack nonthreatening - given two weeks, if that happened, users would have
1662        plenty of time to notice and transfer their assets.
1663     */
1664     uint public DELAY_PERIOD = 2 weeks;
1665 
1666     /**
1667      * Start the process to enable access for specified contract. Subject to delay period.
1668      *
1669      * @dev ProxyRegistry owner only
1670      * @param addr Address to which to grant permissions
1671      */
1672     function startGrantAuthentication (address addr)
1673         public
1674         onlyOwner
1675     {
1676         require(!contracts[addr] && pending[addr] == 0);
1677         pending[addr] = now;
1678     }
1679 
1680     /**
1681      * End the process to nable access for specified contract after delay period has passed.
1682      *
1683      * @dev ProxyRegistry owner only
1684      * @param addr Address to which to grant permissions
1685      */
1686     function endGrantAuthentication (address addr)
1687         public
1688         onlyOwner
1689     {
1690         require(!contracts[addr] && pending[addr] != 0 && ((pending[addr] + DELAY_PERIOD) < now));
1691         pending[addr] = 0;
1692         contracts[addr] = true;
1693     }
1694 
1695     /**
1696      * Revoke access for specified contract. Can be done instantly.
1697      *
1698      * @dev ProxyRegistry owner only
1699      * @param addr Address of which to revoke permissions
1700      */
1701     function revokeAuthentication (address addr)
1702         public
1703         onlyOwner
1704     {
1705         contracts[addr] = false;
1706     }
1707 
1708     /**
1709      * Register a proxy contract with this registry
1710      *
1711      * @dev Must be called by the user which the proxy is for, creates a new AuthenticatedProxy
1712      * @return New AuthenticatedProxy contract
1713      */
1714     function registerProxy()
1715         public
1716         returns (OwnableDelegateProxy proxy)
1717     {
1718         require(proxies[msg.sender] == address(0));
1719         proxy = new OwnableDelegateProxy(msg.sender, delegateProxyImplementation, abi.encodeWithSignature("initialize(address,address)", msg.sender, address(this)));
1720         proxies[msg.sender] = proxy;
1721         return proxy;
1722     }
1723 
1724 }
1725 
1726 contract TokenTransferProxy {
1727 
1728     /* Authentication registry. */
1729     ProxyRegistry public registry;
1730 
1731     /**
1732      * Call ERC20 `transferFrom`
1733      *
1734      * @dev Authenticated contract only
1735      * @param token ERC20 token address
1736      * @param from From address
1737      * @param to To address
1738      * @param amount Transfer amount
1739      */
1740     function transferFrom(address token, address from, address to, uint amount)
1741         public
1742         returns (bool)
1743     {
1744         require(registry.contracts(msg.sender));
1745         return ERC20(token).transferFrom(from, to, amount);
1746     }
1747 
1748 }
1749 
1750 contract OwnedUpgradeabilityStorage {
1751 
1752   // Current implementation
1753   address internal _implementation;
1754 
1755   // Owner of the contract
1756   address private _upgradeabilityOwner;
1757 
1758   /**
1759    * @dev Tells the address of the owner
1760    * @return the address of the owner
1761    */
1762   function upgradeabilityOwner() public view returns (address) {
1763     return _upgradeabilityOwner;
1764   }
1765 
1766   /**
1767    * @dev Sets the address of the owner
1768    */
1769   function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
1770     _upgradeabilityOwner = newUpgradeabilityOwner;
1771   }
1772 
1773   /**
1774   * @dev Tells the address of the current implementation
1775   * @return address of the current implementation
1776   */
1777   function implementation() public view returns (address) {
1778     return _implementation;
1779   }
1780 
1781   /**
1782   * @dev Tells the proxy type (EIP 897)
1783   * @return Proxy type, 2 for forwarding proxy
1784   */
1785   function proxyType() public pure returns (uint256 proxyTypeId) {
1786     return 2;
1787   }
1788 }
1789 
1790 contract AuthenticatedProxy is TokenRecipient, OwnedUpgradeabilityStorage {
1791 
1792     /* Whether initialized. */
1793     bool initialized = false;
1794 
1795     /* Address which owns this proxy. */
1796     address public user;
1797 
1798     /* Associated registry with contract authentication information. */
1799     ProxyRegistry public registry;
1800 
1801     /* Whether access has been revoked. */
1802     bool public revoked;
1803 
1804     /* Delegate call could be used to atomically transfer multiple assets owned by the proxy contract with one order. */
1805     enum HowToCall { Call, DelegateCall }
1806 
1807     /* Event fired when the proxy access is revoked or unrevoked. */
1808     event Revoked(bool revoked);
1809 
1810     /**
1811      * Initialize an AuthenticatedProxy
1812      *
1813      * @param addrUser Address of user on whose behalf this proxy will act
1814      * @param addrRegistry Address of ProxyRegistry contract which will manage this proxy
1815      */
1816     function initialize (address addrUser, ProxyRegistry addrRegistry)
1817         public
1818     {
1819         require(!initialized);
1820         initialized = true;
1821         user = addrUser;
1822         registry = addrRegistry;
1823     }
1824 
1825     /**
1826      * Set the revoked flag (allows a user to revoke ProxyRegistry access)
1827      *
1828      * @dev Can be called by the user only
1829      * @param revoke Whether or not to revoke access
1830      */
1831     function setRevoke(bool revoke)
1832         public
1833     {
1834         require(msg.sender == user);
1835         revoked = revoke;
1836         emit Revoked(revoke);
1837     }
1838 
1839     /**
1840      * Execute a message call from the proxy contract
1841      *
1842      * @dev Can be called by the user, or by a contract authorized by the registry as long as the user has not revoked access
1843      * @param dest Address to which the call will be sent
1844      * @param howToCall Which kind of call to make
1845      * @param calldata Calldata to send
1846      * @return Result of the call (success or failure)
1847      */
1848     function proxy(address dest, HowToCall howToCall, bytes calldata)
1849         public
1850         returns (bool result)
1851     {
1852         require(msg.sender == user || (!revoked && registry.contracts(msg.sender)));
1853         if (howToCall == HowToCall.Call) {
1854             result = dest.call(calldata);
1855         } else if (howToCall == HowToCall.DelegateCall) {
1856             result = dest.delegatecall(calldata);
1857         }
1858         return result;
1859     }
1860 
1861     /**
1862      * Execute a message call and assert success
1863      *
1864      * @dev Same functionality as `proxy`, just asserts the return value
1865      * @param dest Address to which the call will be sent
1866      * @param howToCall What kind of call to make
1867      * @param calldata Calldata to send
1868      */
1869     function proxyAssert(address dest, HowToCall howToCall, bytes calldata)
1870         public
1871     {
1872         require(proxy(dest, howToCall, calldata));
1873     }
1874 
1875 }
1876 
1877 contract Proxy {
1878 
1879   /**
1880   * @dev Tells the address of the implementation where every call will be delegated.
1881   * @return address of the implementation to which it will be delegated
1882   */
1883   function implementation() public view returns (address);
1884 
1885   /**
1886   * @dev Tells the type of proxy (EIP 897)
1887   * @return Type of proxy, 2 for upgradeable proxy
1888   */
1889   function proxyType() public pure returns (uint256 proxyTypeId);
1890 
1891   /**
1892   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
1893   * This function will return whatever the implementation call returns
1894   */
1895   function () payable public {
1896     address _impl = implementation();
1897     require(_impl != address(0));
1898 
1899     assembly {
1900       let ptr := mload(0x40)
1901       calldatacopy(ptr, 0, calldatasize)
1902       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
1903       let size := returndatasize
1904       returndatacopy(ptr, 0, size)
1905 
1906       switch result
1907       case 0 { revert(ptr, size) }
1908       default { return(ptr, size) }
1909     }
1910   }
1911 }
1912 
1913 contract OwnedUpgradeabilityProxy is Proxy, OwnedUpgradeabilityStorage {
1914   /**
1915   * @dev Event to show ownership has been transferred
1916   * @param previousOwner representing the address of the previous owner
1917   * @param newOwner representing the address of the new owner
1918   */
1919   event ProxyOwnershipTransferred(address previousOwner, address newOwner);
1920 
1921   /**
1922   * @dev This event will be emitted every time the implementation gets upgraded
1923   * @param implementation representing the address of the upgraded implementation
1924   */
1925   event Upgraded(address indexed implementation);
1926 
1927   /**
1928   * @dev Upgrades the implementation address
1929   * @param implementation representing the address of the new implementation to be set
1930   */
1931   function _upgradeTo(address implementation) internal {
1932     require(_implementation != implementation);
1933     _implementation = implementation;
1934     emit Upgraded(implementation);
1935   }
1936 
1937   /**
1938   * @dev Throws if called by any account other than the owner.
1939   */
1940   modifier onlyProxyOwner() {
1941     require(msg.sender == proxyOwner());
1942     _;
1943   }
1944 
1945   /**
1946    * @dev Tells the address of the proxy owner
1947    * @return the address of the proxy owner
1948    */
1949   function proxyOwner() public view returns (address) {
1950     return upgradeabilityOwner();
1951   }
1952 
1953   /**
1954    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1955    * @param newOwner The address to transfer ownership to.
1956    */
1957   function transferProxyOwnership(address newOwner) public onlyProxyOwner {
1958     require(newOwner != address(0));
1959     emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
1960     setUpgradeabilityOwner(newOwner);
1961   }
1962 
1963   /**
1964    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy.
1965    * @param implementation representing the address of the new implementation to be set.
1966    */
1967   function upgradeTo(address implementation) public onlyProxyOwner {
1968     _upgradeTo(implementation);
1969   }
1970 
1971   /**
1972    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy
1973    * and delegatecall the new implementation for initialization.
1974    * @param implementation representing the address of the new implementation to be set.
1975    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
1976    * signature of the implementation to be called with the needed payload
1977    */
1978   function upgradeToAndCall(address implementation, bytes data) payable public onlyProxyOwner {
1979     upgradeTo(implementation);
1980     require(address(this).delegatecall(data));
1981   }
1982 }
1983 
1984 contract OwnableDelegateProxy is OwnedUpgradeabilityProxy {
1985 
1986     constructor(address owner, address initialImplementation, bytes calldata)
1987         public
1988     {
1989         setUpgradeabilityOwner(owner);
1990         _upgradeTo(initialImplementation);
1991         require(initialImplementation.delegatecall(calldata));
1992     }
1993 
1994 }