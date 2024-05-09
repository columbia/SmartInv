1 pragma solidity 0.4.26;
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
166      * @param a First array
167      * @param b Second array
168      * @return Whether or not all bytes in the arrays are equal
169      */
170     function arrayEq(bytes memory a, bytes memory b)
171         internal
172         pure
173         returns (bool)
174     {
175         return keccak256(a) == keccak256(b);
176     }
177 
178     /**
179      * Unsafe write byte array into a memory location
180      *
181      * @param index Memory location
182      * @param source Byte array to write
183      * @return End memory index
184      */
185     function unsafeWriteBytes(uint index, bytes source)
186         internal
187         pure
188         returns (uint)
189     {
190         if (source.length > 0) {
191             assembly {
192                 let length := mload(source)
193                 let end := add(source, add(0x20, length))
194                 let arrIndex := add(source, 0x20)
195                 let tempIndex := index
196                 for { } eq(lt(arrIndex, end), 1) {
197                     arrIndex := add(arrIndex, 0x20)
198                     tempIndex := add(tempIndex, 0x20)
199                 } {
200                     mstore(tempIndex, mload(arrIndex))
201                 }
202                 index := add(index, length)
203             }
204         }
205         return index;
206     }
207 
208     /**
209      * Unsafe write address into a memory location
210      *
211      * @param index Memory location
212      * @param source Address to write
213      * @return End memory index
214      */
215     function unsafeWriteAddress(uint index, address source)
216         internal
217         pure
218         returns (uint)
219     {
220         uint conv = uint(source) << 0x60;
221         assembly {
222             mstore(index, conv)
223             index := add(index, 0x14)
224         }
225         return index;
226     }
227 
228     /**
229      * Unsafe write address into a memory location using entire word
230      *
231      * @param index Memory location
232      * @param source uint to write
233      * @return End memory index
234      */
235     function unsafeWriteAddressWord(uint index, address source)
236         internal
237         pure
238         returns (uint)
239     {
240         assembly {
241             mstore(index, source)
242             index := add(index, 0x20)
243         }
244         return index;
245     }
246 
247     /**
248      * Unsafe write uint into a memory location
249      *
250      * @param index Memory location
251      * @param source uint to write
252      * @return End memory index
253      */
254     function unsafeWriteUint(uint index, uint source)
255         internal
256         pure
257         returns (uint)
258     {
259         assembly {
260             mstore(index, source)
261             index := add(index, 0x20)
262         }
263         return index;
264     }
265 
266     /**
267      * Unsafe write uint8 into a memory location
268      *
269      * @param index Memory location
270      * @param source uint8 to write
271      * @return End memory index
272      */
273     function unsafeWriteUint8(uint index, uint8 source)
274         internal
275         pure
276         returns (uint)
277     {
278         assembly {
279             mstore8(index, source)
280             index := add(index, 0x1)
281         }
282         return index;
283     }
284 
285     /**
286      * Unsafe write uint8 into a memory location using entire word
287      *
288      * @param index Memory location
289      * @param source uint to write
290      * @return End memory index
291      */
292     function unsafeWriteUint8Word(uint index, uint8 source)
293         internal
294         pure
295         returns (uint)
296     {
297         assembly {
298             mstore(index, source)
299             index := add(index, 0x20)
300         }
301         return index;
302     }
303 
304     /**
305      * Unsafe write bytes32 into a memory location using entire word
306      *
307      * @param index Memory location
308      * @param source uint to write
309      * @return End memory index
310      */
311     function unsafeWriteBytes32(uint index, bytes32 source)
312         internal
313         pure
314         returns (uint)
315     {
316         assembly {
317             mstore(index, source)
318             index := add(index, 0x20)
319         }
320         return index;
321     }
322 }
323 
324 contract ReentrancyGuarded {
325 
326     bool reentrancyLock = false;
327 
328     /* Prevent a contract function from being reentrant-called. */
329     modifier reentrancyGuard {
330         if (reentrancyLock) {
331             revert();
332         }
333         reentrancyLock = true;
334         _;
335         reentrancyLock = false;
336     }
337 
338 }
339 
340 contract TokenRecipient {
341     event ReceivedEther(address indexed sender, uint amount);
342     event ReceivedTokens(address indexed from, uint256 value, address indexed token, bytes extraData);
343 
344     /**
345      * @dev Receive tokens and generate a log event
346      * @param from Address from which to transfer tokens
347      * @param value Amount of tokens to transfer
348      * @param token Address of token
349      * @param extraData Additional data to log
350      */
351     function receiveApproval(address from, uint256 value, address token, bytes extraData) public {
352         ERC20 t = ERC20(token);
353         require(t.transferFrom(from, this, value));
354         emit ReceivedTokens(from, value, token, extraData);
355     }
356 
357     /**
358      * @dev Receive Ether and generate a log event
359      */
360     function () payable public {
361         emit ReceivedEther(msg.sender, msg.value);
362     }
363 }
364 
365 contract ExchangeCore is ReentrancyGuarded, Ownable {
366     string public constant name = "StarBlock Exchange Contract";
367     string public constant version = "1.0";
368 
369     // NOTE: these hashes are derived and verified in the constructor.
370     bytes32 private constant _EIP_712_DOMAIN_TYPEHASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
371     bytes32 private constant _NAME_HASH = 0x908be1d09f2d17dd8812f5561d84e89cc7052e553487116c4cf73793bdba635d;
372     bytes32 private constant _VERSION_HASH = 0xe6bbd6277e1bf288eed5e8d1780f9a50b239e86b153736bceebccf4ea79d90b3;
373     bytes32 private constant _ORDER_TYPEHASH = 0xdba08a88a748f356e8faf8578488343eab21b1741728779c9dcfdc782bc800f8;
374 
375     bytes4 private constant _EIP_1271_MAGIC_VALUE = 0x1626ba7e;
376 
377     //    // NOTE: chainId opcode is not supported in solidiy 0.4.x; here we hardcode as 1.
378     // In order to protect against orders that are replayable across forked chains,
379     // either the solidity version needs to be bumped up or it needs to be retrieved
380     // from another contract.
381     uint256 private constant _CHAIN_ID = 1;
382 
383     // Note: the domain separator is derived and verified in the constructor. */
384     bytes32 public constant DOMAIN_SEPARATOR = _deriveDomainSeparator();
385 
386     /* The token used to pay exchange fees. */
387     ERC20 public exchangeToken;
388 
389     /* User registry. */
390     ProxyRegistry public registry;
391 
392     /* Token transfer proxy. */
393     TokenTransferProxy public tokenTransferProxy;
394 
395     /* Cancelled / finalized orders, by hash. */
396     mapping(bytes32 => bool) public cancelledOrFinalized;
397 
398     /* Orders verified by on-chain approval (alternative to ECDSA signatures so that smart contracts can place orders directly). */
399     /* Note that the maker's nonce at the time of approval **plus one** is stored in the mapping. */
400     mapping(bytes32 => uint256) private _approvedOrdersByNonce;
401 
402     /* Track per-maker nonces that can be incremented by the maker to cancel orders in bulk. */
403     // The current nonce for the maker represents the only valid nonce that can be signed by the maker
404     // If a signature was signed with a nonce that's different from the one stored in nonces, it
405     // will fail validation.
406     mapping(address => uint256) public nonces;
407 
408     /* For split fee orders, minimum required protocol maker fee, in basis points. Paid to owner (who can change it). */
409     uint public minimumMakerProtocolFee = 0;
410 
411     /* For split fee orders, minimum required protocol taker fee, in basis points. Paid to owner (who can change it). */
412     uint public minimumTakerProtocolFee = 0;
413 
414     /* Recipient of protocol fees. */
415     address public protocolFeeRecipient;
416 
417     /* Fee method: protocol fee or split fee. */
418     enum FeeMethod { ProtocolFee, SplitFee }
419 
420     /* Inverse basis point. */
421     uint public constant INVERSE_BASIS_POINT = 10000;
422 
423     /* An ECDSA signature. */
424     struct Sig {
425         /* v parameter */
426         uint8 v;
427         /* r parameter */
428         bytes32 r;
429         /* s parameter */
430         bytes32 s;
431     }
432 
433     /* An order on the exchange. */
434     struct Order {
435         /* Exchange address, intended as a versioning mechanism. */
436         address exchange;
437         /* Order maker address. */
438         address maker;
439         /* Order taker address, if specified. */
440         address taker;
441         /* Maker relayer fee of the order, unused for taker order. */
442         uint makerRelayerFee;
443         /* Taker relayer fee of the order, or maximum taker fee for a taker order. */
444         uint takerRelayerFee;
445         /* Maker protocol fee of the order, unused for taker order. */
446         uint makerProtocolFee;
447         /* Taker protocol fee of the order, or maximum taker fee for a taker order. */
448         uint takerProtocolFee;
449         /* Order fee recipient or zero address for taker order. */
450         address feeRecipient;
451         /* Fee method (protocol token or split fee). */
452         FeeMethod feeMethod;
453         /* Side (buy/sell). */
454         SaleKindInterface.Side side;
455         /* Kind of sale. */
456         SaleKindInterface.SaleKind saleKind;
457         /* Target. */
458         address target;
459         /* HowToCall. */
460         AuthenticatedProxy.HowToCall howToCall;
461         /* Calldata. */
462         bytes calldata;
463         /* Calldata replacement pattern, or an empty byte array for no replacement. */
464         bytes replacementPattern;
465         /* Static call target, zero-address for no static call. */
466         address staticTarget;
467         /* Static call extra data. */
468         bytes staticExtradata;
469         /* Token used to pay for the order, or the zero-address as a sentinel value for Ether. */
470         address paymentToken;
471         /* Base price of the order (in paymentTokens). */
472         uint basePrice;
473         /* Auction extra parameter - minimum bid increment for English auctions, starting/ending price difference. */
474         uint extra;
475         /* Listing timestamp. */
476         uint listingTime;
477         /* Expiration timestamp - 0 for no expiry. */
478         uint expirationTime;
479         /* Order salt, used to prevent duplicate hashes. */
480         uint salt;
481         /* NOTE: uint nonce is an additional component of the order but is read from storage */
482     }
483 
484     event OrderApprovedPartOne    (bytes32 indexed hash, address exchange, address indexed maker, address taker, uint makerRelayerFee, uint takerRelayerFee, uint makerProtocolFee, uint takerProtocolFee, address indexed feeRecipient, FeeMethod feeMethod, SaleKindInterface.Side side, SaleKindInterface.SaleKind saleKind, address target);
485     event OrderApprovedPartTwo    (bytes32 indexed hash, AuthenticatedProxy.HowToCall howToCall, bytes calldata, bytes replacementPattern, address staticTarget, bytes staticExtradata, address paymentToken, uint basePrice, uint extra, uint listingTime, uint expirationTime, uint salt, bool orderbookInclusionDesired);
486     event OrderCancelled          (bytes32 indexed hash);
487     event OrdersMatched           (bytes32 buyHash, bytes32 sellHash, address indexed maker, address indexed taker, uint price, bytes32 indexed metadata);
488     event NonceIncremented        (address indexed maker, uint newNonce);
489 
490     constructor () public {
491         require(keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)") == _EIP_712_DOMAIN_TYPEHASH);
492         require(keccak256(bytes(name)) == _NAME_HASH);
493         require(keccak256(bytes(version)) == _VERSION_HASH);
494         require(keccak256("Order(address exchange,address maker,address taker,uint256 makerRelayerFee,uint256 takerRelayerFee,uint256 makerProtocolFee,uint256 takerProtocolFee,address feeRecipient,uint8 feeMethod,uint8 side,uint8 saleKind,address target,uint8 howToCall,bytes calldata,bytes replacementPattern,address staticTarget,bytes staticExtradata,address paymentToken,uint256 basePrice,uint256 extra,uint256 listingTime,uint256 expirationTime,uint256 salt,uint256 nonce)") == _ORDER_TYPEHASH);
495     }
496 
497     /**
498      * @dev Derive the domain separator for EIP-712 signatures.
499      * @return The domain separator.
500      */
501     function _deriveDomainSeparator() private view returns (bytes32) {
502         return keccak256(
503             abi.encode(
504                 _EIP_712_DOMAIN_TYPEHASH, // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
505                 _NAME_HASH, // keccak256("StarBlock Exchange Contract")
506                 _VERSION_HASH, // keccak256(bytes("1.0"))
507                 _CHAIN_ID, // NOTE: this is fixed, need to use solidity 0.5+ or make external call to support!
508                 address(this)
509             )
510         );
511     }
512 
513     /**
514      * Increment a particular maker's nonce, thereby invalidating all orders that were not signed
515      * with the original nonce.
516      */
517     function incrementNonce() external {
518         uint newNonce = ++nonces[msg.sender];
519         emit NonceIncremented(msg.sender, newNonce);
520     }
521 
522     function withdrawMoney() external onlyOwner reentrancyGuard {
523       msg.sender.transfer(address(this).balance);
524     }
525 
526     /**
527      * @dev Change the minimum maker fee paid to the protocol (owner only)
528      * @param newMinimumMakerProtocolFee New fee to set in basis points
529      */
530     function changeMinimumMakerProtocolFee(uint newMinimumMakerProtocolFee)
531         public
532         onlyOwner
533     {
534         minimumMakerProtocolFee = newMinimumMakerProtocolFee;
535     }
536 
537     /**
538      * @dev Change the minimum taker fee paid to the protocol (owner only)
539      * @param newMinimumTakerProtocolFee New fee to set in basis points
540      */
541     function changeMinimumTakerProtocolFee(uint newMinimumTakerProtocolFee)
542         public
543         onlyOwner
544     {
545         minimumTakerProtocolFee = newMinimumTakerProtocolFee;
546     }
547 
548     /**
549      * @dev Change the protocol fee recipient (owner only)
550      * @param newProtocolFeeRecipient New protocol fee recipient address
551      */
552     function changeProtocolFeeRecipient(address newProtocolFeeRecipient)
553         public
554         onlyOwner
555     {
556         protocolFeeRecipient = newProtocolFeeRecipient;
557     }
558 
559     /**
560      * @dev Change exchangeToken (owner only)
561      * @param newExchangeToken New exchangeToken
562      */
563     function changeExchangeToken(ERC20 newExchangeToken)
564         public
565         onlyOwner
566     {
567         exchangeToken = newExchangeToken;
568     }
569 
570     /**
571      * @dev Transfer tokens
572      * @param token Token to transfer
573      * @param from Address to charge fees
574      * @param to Address to receive fees
575      * @param amount Amount of protocol tokens to charge
576      */
577     function transferTokens(address token, address from, address to, uint amount)
578         internal
579     {
580         if (amount > 0) {
581             require(tokenTransferProxy.transferFrom(token, from, to, amount));
582         }
583     }
584 
585     /**
586      * @dev Charge a fee in protocol tokens
587      * @param from Address to charge fees
588      * @param to Address to receive fees
589      * @param amount Amount of protocol tokens to charge
590      */
591     function chargeProtocolFee(address from, address to, uint amount)
592         internal
593     {
594         transferTokens(exchangeToken, from, to, amount);
595     }
596 
597     /**
598      * @dev Execute a STATICCALL (introduced with Ethereum Metropolis, non-state-modifying external call)
599      * @param target Contract to call
600      * @param calldata Calldata (appended to extradata)
601      * @param extradata Base data for STATICCALL (probably function selector and argument encoding)
602      * @return The result of the call (success or failure)
603      */
604     function staticCall(address target, bytes memory calldata, bytes memory extradata)
605         public
606         view
607         returns (bool result)
608     {
609         bytes memory combined = new bytes(calldata.length + extradata.length);
610         uint index;
611         assembly {
612             index := add(combined, 0x20)
613         }
614         index = ArrayUtils.unsafeWriteBytes(index, extradata);
615         ArrayUtils.unsafeWriteBytes(index, calldata);
616         assembly {
617             result := staticcall(gas, target, add(combined, 0x20), mload(combined), mload(0x40), 0)
618         }
619         return result;
620     }
621 
622     /**
623      * @dev Hash an order, returning the canonical EIP-712 order hash without the domain separator
624      * @param order Order to hash
625      * @param nonce maker nonce to hash
626      * @return Hash of order
627      */
628     function hashOrder(Order memory order, uint nonce)
629         internal
630         pure
631         returns (bytes32 hash)
632     {
633         /* Unfortunately abi.encodePacked doesn't work here, stack size constraints. */
634         uint size = 800;
635         bytes memory array = new bytes(size);
636         uint index;
637         assembly {
638             index := add(array, 0x20)
639         }
640         index = ArrayUtils.unsafeWriteBytes32(index, _ORDER_TYPEHASH);
641         index = ArrayUtils.unsafeWriteAddressWord(index, order.exchange);
642         index = ArrayUtils.unsafeWriteAddressWord(index, order.maker);
643         index = ArrayUtils.unsafeWriteAddressWord(index, order.taker);
644         index = ArrayUtils.unsafeWriteUint(index, order.makerRelayerFee);
645         index = ArrayUtils.unsafeWriteUint(index, order.takerRelayerFee);
646         index = ArrayUtils.unsafeWriteUint(index, order.makerProtocolFee);
647         index = ArrayUtils.unsafeWriteUint(index, order.takerProtocolFee);
648         index = ArrayUtils.unsafeWriteAddressWord(index, order.feeRecipient);
649         index = ArrayUtils.unsafeWriteUint8Word(index, uint8(order.feeMethod));
650         index = ArrayUtils.unsafeWriteUint8Word(index, uint8(order.side));
651         index = ArrayUtils.unsafeWriteUint8Word(index, uint8(order.saleKind));
652         index = ArrayUtils.unsafeWriteAddressWord(index, order.target);
653         index = ArrayUtils.unsafeWriteUint8Word(index, uint8(order.howToCall));
654         index = ArrayUtils.unsafeWriteBytes32(index, keccak256(order.calldata));
655         index = ArrayUtils.unsafeWriteBytes32(index, keccak256(order.replacementPattern));
656         index = ArrayUtils.unsafeWriteAddressWord(index, order.staticTarget);
657         index = ArrayUtils.unsafeWriteBytes32(index, keccak256(order.staticExtradata));
658         index = ArrayUtils.unsafeWriteAddressWord(index, order.paymentToken);
659         index = ArrayUtils.unsafeWriteUint(index, order.basePrice);
660         index = ArrayUtils.unsafeWriteUint(index, order.extra);
661         index = ArrayUtils.unsafeWriteUint(index, order.listingTime);
662         index = ArrayUtils.unsafeWriteUint(index, order.expirationTime);
663         index = ArrayUtils.unsafeWriteUint(index, order.salt);
664         index = ArrayUtils.unsafeWriteUint(index, nonce);
665         assembly {
666             hash := keccak256(add(array, 0x20), size)
667         }
668         return hash;
669     }
670 
671     /**
672      * @dev Hash an order, returning the hash that a client must sign via EIP-712 including the message prefix
673      * @param order Order to hash
674      * @param nonce Nonce to hash
675      * @return Hash of message prefix and order hash per Ethereum format
676      */
677     function hashToSign(Order memory order, uint nonce)
678         internal
679         pure
680         returns (bytes32)
681     {
682         return keccak256(
683             abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hashOrder(order, nonce))
684         );
685     }
686 
687     /**
688      * @dev Assert an order is valid and return its hash
689      * @param order Order to validate
690      * @param nonce Nonce to validate
691      * @param sig ECDSA signature
692      */
693     function requireValidOrder(Order memory order, Sig memory sig, uint nonce)
694         internal
695         view
696         returns (bytes32)
697     {
698         bytes32 hash = hashToSign(order, nonce);
699         require(validateOrder(hash, order, sig));
700         return hash;
701     }
702 
703     /**
704      * @dev Validate order parameters (does *not* check signature validity)
705      * @param order Order to validate
706      */
707     function validateOrderParameters(Order memory order)
708         internal
709         view
710         returns (bool)
711     {
712         /* Order must be targeted at this protocol version (this Exchange contract). */
713         if (order.exchange != address(this)) {
714             return false;
715         }
716 
717         /* Order must have a maker. */
718         if (order.maker == address(0)) {
719             return false;
720         }
721 
722         /* Order must possess valid sale kind parameter combination. */
723         if (!SaleKindInterface.validateParameters(order.saleKind, order.expirationTime)) {
724             return false;
725         }
726 
727         /* If using the split fee method, order must have sufficient protocol fees. */
728         if (order.feeMethod == FeeMethod.SplitFee && (order.makerProtocolFee < minimumMakerProtocolFee || order.takerProtocolFee < minimumTakerProtocolFee)) {
729             return false;
730         }
731 
732         return true;
733     }
734 
735     /**
736      * @dev Validate a provided previously approved / signed order, hash, and signature.
737      * @param hash Order hash (already calculated, passed to avoid recalculation)
738      * @param order Order to validate
739      * @param sig ECDSA signature
740      */
741     function validateOrder(bytes32 hash, Order memory order, Sig memory sig)
742         internal
743         view
744         returns (bool)
745     {
746         /* Not done in an if-conditional to prevent unnecessary ecrecover evaluation, which seems to happen even though it should short-circuit. */
747 
748         /* Order must have valid parameters. */
749         if (!validateOrderParameters(order)) {
750             return false;
751         }
752 
753         /* Order must have not been canceled or already filled. */
754         if (cancelledOrFinalized[hash]) {
755             return false;
756         }
757 
758         /* Return true if order has been previously approved with the current nonce */
759         uint approvedOrderNoncePlusOne = _approvedOrdersByNonce[hash];
760         if (approvedOrderNoncePlusOne != 0) {
761             return approvedOrderNoncePlusOne == nonces[order.maker] + 1;
762         }
763 
764         /* Prevent signature malleability and non-standard v values. */
765         if (uint256(sig.s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
766             return false;
767         }
768         if (sig.v != 27 && sig.v != 28) {
769             return false;
770         }
771 
772         /* recover via ECDSA, signed by maker (already verified as non-zero). */
773         if (ecrecover(hash, sig.v, sig.r, sig.s) == order.maker) {
774             return true;
775         }
776 
777         /* fallback — attempt EIP-1271 isValidSignature check. */
778         return _tryContractSignature(order.maker, hash, sig);
779     }
780 
781     function _tryContractSignature(address orderMaker, bytes32 hash, Sig memory sig) internal view returns (bool) {
782         bytes memory isValidSignatureData = abi.encodeWithSelector(
783             _EIP_1271_MAGIC_VALUE,
784             hash,
785             abi.encodePacked(sig.r, sig.s, sig.v)
786         );
787 
788         bytes4 result;
789 
790         // NOTE: solidity 0.4.x does not support STATICCALL outside of assembly
791         assembly {
792             let success := staticcall(           // perform a staticcall
793                 gas,                             // forward all available gas
794                 orderMaker,                      // call the order maker
795                 add(isValidSignatureData, 0x20), // calldata offset comes after length
796                 mload(isValidSignatureData),     // load calldata length
797                 0,                               // do not use memory for return data
798                 0                                // do not use memory for return data
799             )
800 
801             if iszero(success) {                     // if the call fails
802                 returndatacopy(0, 0, returndatasize) // copy returndata buffer to memory
803                 revert(0, returndatasize)            // revert + pass through revert data
804             }
805 
806             if eq(returndatasize, 0x20) {  // if returndata == 32 (one word)
807                 returndatacopy(0, 0, 0x20) // copy return data to memory in scratch space
808                 result := mload(0)         // load return data from memory to the stack
809             }
810         }
811 
812         return result == _EIP_1271_MAGIC_VALUE;
813     }
814 
815     /**
816      * @dev Determine if an order has been approved. Note that the order may not still
817      * be valid in cases where the maker's nonce has been incremented.
818      * @param hash Hash of the order
819      * @return whether or not the order was approved.
820      */
821     function approvedOrders(bytes32 hash) public view returns (bool approved) {
822         return _approvedOrdersByNonce[hash] != 0;
823     }
824 
825     /**
826      * @dev Approve an order and optionally mark it for orderbook inclusion. Must be called by the maker of the order
827      * @param order Order to approve
828      * @param orderbookInclusionDesired Whether orderbook providers should include the order in their orderbooks
829      */
830     function approveOrder(Order memory order, bool orderbookInclusionDesired)
831         internal
832     {
833         /* CHECKS */
834 
835         /* Assert sender is authorized to approve order. */
836         require(msg.sender == order.maker);
837 
838         /* Calculate order hash. */
839         bytes32 hash = hashToSign(order, nonces[order.maker]);
840 
841         /* Assert order has not already been approved. */
842         require(_approvedOrdersByNonce[hash] == 0);
843 
844         /* EFFECTS */
845 
846         /* Mark order as approved. */
847         _approvedOrdersByNonce[hash] = nonces[order.maker] + 1;
848 
849         /* Log approval event. Must be split in two due to Solidity stack size limitations. */
850         {
851             emit OrderApprovedPartOne(hash, order.exchange, order.maker, order.taker, order.makerRelayerFee, order.takerRelayerFee, order.makerProtocolFee, order.takerProtocolFee, order.feeRecipient, order.feeMethod, order.side, order.saleKind, order.target);
852         }
853         {
854             emit OrderApprovedPartTwo(hash, order.howToCall, order.calldata, order.replacementPattern, order.staticTarget, order.staticExtradata, order.paymentToken, order.basePrice, order.extra, order.listingTime, order.expirationTime, order.salt, orderbookInclusionDesired);
855         }
856     }
857 
858     /**
859      * @dev Cancel an order, preventing it from being matched. Must be called by the maker of the order
860      * @param order Order to cancel
861      * @param nonce Nonce to cancel
862      * @param sig ECDSA signature
863      */
864     function cancelOrder(Order memory order, Sig memory sig, uint nonce)
865         internal
866     {
867         /* CHECKS */
868 
869         /* Calculate order hash. */
870         bytes32 hash = requireValidOrder(order, sig, nonce);
871 
872         /* Assert sender is authorized to cancel order. */
873         require(msg.sender == order.maker);
874 
875         /* EFFECTS */
876 
877         /* Mark order as cancelled, preventing it from being matched. */
878         cancelledOrFinalized[hash] = true;
879 
880         /* Log cancel event. */
881         emit OrderCancelled(hash);
882     }
883 
884     /**
885      * @dev Calculate the current price of an order (convenience function)
886      * @param order Order to calculate the price of
887      * @return The current price of the order
888      */
889     function calculateCurrentPrice (Order memory order)
890         internal
891         view
892         returns (uint)
893     {
894         return SaleKindInterface.calculateFinalPrice(order.side, order.saleKind, order.basePrice, order.extra, order.listingTime, order.expirationTime);
895     }
896 
897     /**
898      * @dev Calculate the price two orders would match at, if in fact they would match (otherwise fail)
899      * @param buy Buy-side order
900      * @param sell Sell-side order
901      * @return Match price
902      */
903     function calculateMatchPrice(Order memory buy, Order memory sell)
904         view
905         internal
906         returns (uint)
907     {
908         /* Calculate sell price. */
909         uint sellPrice = SaleKindInterface.calculateFinalPrice(sell.side, sell.saleKind, sell.basePrice, sell.extra, sell.listingTime, sell.expirationTime);
910 
911         /* Calculate buy price. */
912         uint buyPrice = SaleKindInterface.calculateFinalPrice(buy.side, buy.saleKind, buy.basePrice, buy.extra, buy.listingTime, buy.expirationTime);
913 
914         /* Require price cross. */
915         require(buyPrice >= sellPrice);
916 
917         /* Maker/taker priority. */
918         return sell.feeRecipient != address(0) ? sellPrice : buyPrice;
919     }
920 
921     /**
922      * @dev Execute all ERC20 token / Ether transfers associated with an order match (fees and buyer => seller transfer)
923      * @param buy Buy-side order
924      * @param sell Sell-side order
925      */
926     function executeFundsTransfer(Order memory buy, Order memory sell)
927         internal
928         returns (uint)
929     {
930         /* Only payable in the special case of unwrapped Ether. */
931         if (sell.paymentToken != address(0)) {
932             require(msg.value == 0);
933         }
934 
935         /* Calculate match price. */
936         uint price = calculateMatchPrice(buy, sell);
937 
938         /* If paying using a token (not Ether), transfer tokens. This is done prior to fee payments to that a seller will have tokens before being charged fees. */
939         if (price > 0 && sell.paymentToken != address(0)) {
940             transferTokens(sell.paymentToken, buy.maker, sell.maker, price);
941         }
942 
943         /* Amount that will be received by seller (for Ether). */
944         uint receiveAmount = price;
945 
946         /* Amount that must be sent by buyer (for Ether). */
947         uint requiredAmount = price;
948 
949         /* Determine maker/taker and charge fees accordingly. */
950         if (sell.feeRecipient != address(0)) {
951             /* Sell-side order is maker. */
952 
953             /* Assert taker fee is less than or equal to maximum fee specified by buyer. */
954             require(sell.takerRelayerFee <= buy.takerRelayerFee);
955 
956             if (sell.feeMethod == FeeMethod.SplitFee) {
957                 /* Assert taker fee is less than or equal to maximum fee specified by buyer. */
958                 require(sell.takerProtocolFee <= buy.takerProtocolFee);
959 
960                 /* Maker fees are deducted from the token amount that the maker receives. Taker fees are extra tokens that must be paid by the taker. */
961 
962                 if (sell.makerRelayerFee > 0) {
963                     uint makerRelayerFee = SafeMath.div(SafeMath.mul(sell.makerRelayerFee, price), INVERSE_BASIS_POINT);
964                     if (sell.paymentToken == address(0)) {
965                         receiveAmount = SafeMath.sub(receiveAmount, makerRelayerFee);
966                         sell.feeRecipient.transfer(makerRelayerFee);
967                     } else {
968                         transferTokens(sell.paymentToken, sell.maker, sell.feeRecipient, makerRelayerFee);
969                     }
970                 }
971 
972                 if (sell.takerRelayerFee > 0) {
973                     uint takerRelayerFee = SafeMath.div(SafeMath.mul(sell.takerRelayerFee, price), INVERSE_BASIS_POINT);
974                     if (sell.paymentToken == address(0)) {
975                         requiredAmount = SafeMath.add(requiredAmount, takerRelayerFee);
976                         sell.feeRecipient.transfer(takerRelayerFee);
977                     } else {
978                         transferTokens(sell.paymentToken, buy.maker, sell.feeRecipient, takerRelayerFee);
979                     }
980                 }
981 
982                 if (sell.makerProtocolFee > 0) {
983                     uint makerProtocolFee = SafeMath.div(SafeMath.mul(sell.makerProtocolFee, price), INVERSE_BASIS_POINT);
984                     if (sell.paymentToken == address(0)) {
985                         receiveAmount = SafeMath.sub(receiveAmount, makerProtocolFee);
986                         protocolFeeRecipient.transfer(makerProtocolFee);
987                     } else {
988                         transferTokens(sell.paymentToken, sell.maker, protocolFeeRecipient, makerProtocolFee);
989                     }
990                 }
991 
992                 if (sell.takerProtocolFee > 0) {
993                     uint takerProtocolFee = SafeMath.div(SafeMath.mul(sell.takerProtocolFee, price), INVERSE_BASIS_POINT);
994                     if (sell.paymentToken == address(0)) {
995                         requiredAmount = SafeMath.add(requiredAmount, takerProtocolFee);
996                         protocolFeeRecipient.transfer(takerProtocolFee);
997                     } else {
998                         transferTokens(sell.paymentToken, buy.maker, protocolFeeRecipient, takerProtocolFee);
999                     }
1000                 }
1001 
1002             } else {
1003                 /* Charge maker fee to seller. */
1004                 chargeProtocolFee(sell.maker, sell.feeRecipient, sell.makerRelayerFee);
1005 
1006                 /* Charge taker fee to buyer. */
1007                 chargeProtocolFee(buy.maker, sell.feeRecipient, sell.takerRelayerFee);
1008             }
1009         } else {
1010             /* Buy-side order is maker. */
1011 
1012             /* Assert taker fee is less than or equal to maximum fee specified by seller. */
1013             require(buy.takerRelayerFee <= sell.takerRelayerFee);
1014 
1015             if (sell.feeMethod == FeeMethod.SplitFee) {
1016                 /* The Exchange does not escrow Ether, so direct Ether can only be used to with sell-side maker / buy-side taker orders. */
1017                 require(sell.paymentToken != address(0));
1018 
1019                 /* Assert taker fee is less than or equal to maximum fee specified by seller. */
1020                 require(buy.takerProtocolFee <= sell.takerProtocolFee);
1021 
1022                 if (buy.makerRelayerFee > 0) {
1023                     makerRelayerFee = SafeMath.div(SafeMath.mul(buy.makerRelayerFee, price), INVERSE_BASIS_POINT);
1024                     transferTokens(sell.paymentToken, buy.maker, buy.feeRecipient, makerRelayerFee);
1025                 }
1026 
1027                 if (buy.takerRelayerFee > 0) {
1028                     takerRelayerFee = SafeMath.div(SafeMath.mul(buy.takerRelayerFee, price), INVERSE_BASIS_POINT);
1029                     transferTokens(sell.paymentToken, sell.maker, buy.feeRecipient, takerRelayerFee);
1030                 }
1031 
1032                 if (buy.makerProtocolFee > 0) {
1033                     makerProtocolFee = SafeMath.div(SafeMath.mul(buy.makerProtocolFee, price), INVERSE_BASIS_POINT);
1034                     transferTokens(sell.paymentToken, buy.maker, protocolFeeRecipient, makerProtocolFee);
1035                 }
1036 
1037                 if (buy.takerProtocolFee > 0) {
1038                     takerProtocolFee = SafeMath.div(SafeMath.mul(buy.takerProtocolFee, price), INVERSE_BASIS_POINT);
1039                     transferTokens(sell.paymentToken, sell.maker, protocolFeeRecipient, takerProtocolFee);
1040                 }
1041 
1042             } else {
1043                 /* Charge maker fee to buyer. */
1044                 chargeProtocolFee(buy.maker, buy.feeRecipient, buy.makerRelayerFee);
1045 
1046                 /* Charge taker fee to seller. */
1047                 chargeProtocolFee(sell.maker, buy.feeRecipient, buy.takerRelayerFee);
1048             }
1049         }
1050 
1051         if (sell.paymentToken == address(0)) {
1052             /* Special-case Ether, order must be matched by buyer. */
1053             require(msg.value >= requiredAmount);
1054             sell.maker.transfer(receiveAmount);
1055             /* Allow overshoot for variable-price auctions, refund difference. */
1056             uint diff = SafeMath.sub(msg.value, requiredAmount);
1057             if (diff > 0) {
1058                 buy.maker.transfer(diff);
1059             }
1060         }
1061 
1062         /* This contract should never hold Ether, however, we cannot assert this, since it is impossible to prevent anyone from sending Ether e.g. with selfdestruct. */
1063 
1064         return price;
1065     }
1066 
1067     /**
1068      * @dev Return whether or not two orders can be matched with each other by basic parameters (does not check order signatures / calldata or perform static calls)
1069      * @param buy Buy-side order
1070      * @param sell Sell-side order
1071      * @return Whether or not the two orders can be matched
1072      */
1073     function ordersCanMatch(Order memory buy, Order memory sell)
1074         internal
1075         view
1076         returns (bool)
1077     {
1078         return (
1079             /* Must be opposite-side. */
1080             (buy.side == SaleKindInterface.Side.Buy && sell.side == SaleKindInterface.Side.Sell) &&
1081             /* Must use same fee method. */
1082             (buy.feeMethod == sell.feeMethod) &&
1083             /* Must use same payment token. */
1084             (buy.paymentToken == sell.paymentToken) &&
1085             /* Must match maker/taker addresses. */
1086             (sell.taker == address(0) || sell.taker == buy.maker) &&
1087             (buy.taker == address(0) || buy.taker == sell.maker) &&
1088             /* One must be maker and the other must be taker (no bool XOR in Solidity). */
1089             ((sell.feeRecipient == address(0) && buy.feeRecipient != address(0)) || (sell.feeRecipient != address(0) && buy.feeRecipient == address(0))) &&
1090             /* Must match target. */
1091             (buy.target == sell.target) &&
1092             /* Must match howToCall. */
1093             (buy.howToCall == sell.howToCall) &&
1094             /* Buy-side order must be settleable. */
1095             SaleKindInterface.canSettleOrder(buy.listingTime, buy.expirationTime) &&
1096             /* Sell-side order must be settleable. */
1097             SaleKindInterface.canSettleOrder(sell.listingTime, sell.expirationTime)
1098         );
1099     }
1100 
1101     /**
1102      * @dev Atomically match two orders, ensuring validity of the match, and execute all associated state transitions. Protected against reentrancy by a contract-global lock.
1103      * @param buy Buy-side order
1104      * @param buySig Buy-side order signature
1105      * @param sell Sell-side order
1106      * @param sellSig Sell-side order signature
1107      */
1108     function atomicMatch(Order memory buy, Sig memory buySig, Order memory sell, Sig memory sellSig, bytes32 metadata)
1109         internal
1110         reentrancyGuard
1111     {
1112         /* CHECKS */
1113 
1114         /* Ensure buy order validity and calculate hash if necessary. */
1115         bytes32 buyHash;
1116         if (buy.maker == msg.sender) {
1117             require(validateOrderParameters(buy));
1118         } else {
1119             buyHash = _requireValidOrderWithNonce(buy, buySig);
1120         }
1121 
1122         /* Ensure sell order validity and calculate hash if necessary. */
1123         bytes32 sellHash;
1124         if (sell.maker == msg.sender) {
1125             require(validateOrderParameters(sell));
1126         } else {
1127             sellHash = _requireValidOrderWithNonce(sell, sellSig);
1128         }
1129 
1130         /* Must be matchable. */
1131         require(ordersCanMatch(buy, sell));
1132 
1133         /* Target must exist (prevent malicious selfdestructs just prior to order settlement). */
1134         uint size;
1135         address target = sell.target;
1136         assembly {
1137             size := extcodesize(target)
1138         }
1139         require(size > 0);
1140 
1141         /* Must match calldata after replacement, if specified. */
1142         if (buy.replacementPattern.length > 0) {
1143           ArrayUtils.guardedArrayReplace(buy.calldata, sell.calldata, buy.replacementPattern);
1144         }
1145         if (sell.replacementPattern.length > 0) {
1146           ArrayUtils.guardedArrayReplace(sell.calldata, buy.calldata, sell.replacementPattern);
1147         }
1148         require(ArrayUtils.arrayEq(buy.calldata, sell.calldata));
1149 
1150         /* Retrieve delegateProxy contract. */
1151         OwnableDelegateProxy delegateProxy = registry.proxies(sell.maker);
1152 
1153         /* Proxy must exist. */
1154         require(delegateProxy != address(0));
1155 
1156         /* Access the passthrough AuthenticatedProxy. */
1157         AuthenticatedProxy proxy = AuthenticatedProxy(delegateProxy);
1158 
1159         /* EFFECTS */
1160 
1161         /* Mark previously signed or approved orders as finalized. */
1162         if (msg.sender != buy.maker) {
1163             cancelledOrFinalized[buyHash] = true;
1164         }
1165         if (msg.sender != sell.maker && sell.saleKind != SaleKindInterface.SaleKind.CollectionRandomSale) {
1166             cancelledOrFinalized[sellHash] = true;
1167         }
1168 
1169         /* INTERACTIONS */
1170 
1171         /* change the baseprice based on the qutity. */
1172         if (sell.saleKind == SaleKindInterface.SaleKind.CollectionRandomSale) {
1173            uint256 quantity = getQuantity(buy);
1174             if (quantity > 1) {
1175                 sell.basePrice = SafeMath.mul(sell.basePrice, quantity);
1176                 buy.basePrice = sell.basePrice;
1177             }
1178         }
1179 
1180         /* Execute funds transfer and pay fees. */
1181         uint price = executeFundsTransfer(buy, sell);
1182 
1183         /* Assert implementation. */
1184         require(delegateProxy.implementation() == registry.delegateProxyImplementation());
1185 
1186         /* Execute specified call through proxy. */
1187         require(proxy.proxy(sell.target, sell.howToCall, sell.calldata));
1188 
1189         /* Static calls are intentionally done after the effectful call so they can check resulting state. */
1190 
1191         /* Handle buy-side static call if specified. */
1192         if (buy.staticTarget != address(0)) {
1193             require(staticCall(buy.staticTarget, sell.calldata, buy.staticExtradata));
1194         }
1195 
1196         /* Handle sell-side static call if specified. */
1197         if (sell.staticTarget != address(0)) {
1198             require(staticCall(sell.staticTarget, sell.calldata, sell.staticExtradata));
1199         }
1200 
1201         /* Log match event. */
1202         emit OrdersMatched(buyHash, sellHash, sell.feeRecipient != address(0) ? sell.maker : buy.maker, sell.feeRecipient != address(0) ? buy.maker : sell.maker, price, metadata);
1203     }
1204 
1205     function _requireValidOrderWithNonce(Order memory order, Sig memory sig) internal view returns (bytes32) {
1206         return requireValidOrder(order, sig, nonces[order.maker]);
1207     }
1208 
1209       function getQuantity(Order memory buy) internal pure returns (uint256) {
1210             bytes memory quantityBytes = new bytes(2);
1211             uint index = SafeMath.sub(buy.calldata.length, 2);
1212             uint lastIndex = SafeMath.sub(buy.calldata.length, 1);
1213             quantityBytes[0] = buy.calldata[index];
1214             quantityBytes[1] = buy.calldata[lastIndex];
1215             uint256 quantity = bytesToUint(quantityBytes);
1216             return quantity;
1217      }
1218 
1219 
1220     function bytesToUint(bytes memory b) internal pure returns (uint256) {
1221         uint256 number;
1222         for(uint i = 0; i< b.length; i++) {
1223             uint index = SafeMath.add(i, 1);
1224             uint length = SafeMath.sub(b.length, index);
1225             uint offset = 2**SafeMath.mul(8, length);
1226             uint offsetCount = SafeMath.mul(uint8(b[i]), offset);
1227             number = SafeMath.add(number, offsetCount);
1228         }
1229         return number;
1230     }
1231 }
1232 
1233 contract Exchange is ExchangeCore {
1234 
1235     /**
1236      * @dev Call guardedArrayReplace - library function exposed for testing.
1237      */
1238     function guardedArrayReplace(bytes array, bytes desired, bytes mask)
1239         public
1240         pure
1241         returns (bytes)
1242     {
1243         ArrayUtils.guardedArrayReplace(array, desired, mask);
1244         return array;
1245     }
1246 
1247     /**
1248      * @dev Call calculateFinalPrice - library function exposed for testing.
1249      */
1250     function calculateFinalPrice(SaleKindInterface.Side side, SaleKindInterface.SaleKind saleKind, uint basePrice, uint extra, uint listingTime, uint expirationTime)
1251         public
1252         view
1253         returns (uint)
1254     {
1255         return SaleKindInterface.calculateFinalPrice(side, saleKind, basePrice, extra, listingTime, expirationTime);
1256     }
1257 
1258     /**
1259      * @dev Call hashOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1260      */
1261     function hashOrder_(
1262         address[7] addrs,
1263         uint[9] uints,
1264         FeeMethod feeMethod,
1265         SaleKindInterface.Side side,
1266         SaleKindInterface.SaleKind saleKind,
1267         AuthenticatedProxy.HowToCall howToCall,
1268         bytes calldata,
1269         bytes replacementPattern,
1270         bytes staticExtradata)
1271         public
1272         view
1273         returns (bytes32)
1274     {
1275         return hashOrder(
1276           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]),
1277           nonces[addrs[1]]
1278         );
1279     }
1280 
1281     /**
1282      * @dev Call hashToSign - Solidity ABI encoding limitation workaround, hopefully temporary.
1283      */
1284     function hashToSign_(
1285         address[7] addrs,
1286         uint[9] uints,
1287         FeeMethod feeMethod,
1288         SaleKindInterface.Side side,
1289         SaleKindInterface.SaleKind saleKind,
1290         AuthenticatedProxy.HowToCall howToCall,
1291         bytes calldata,
1292         bytes replacementPattern,
1293         bytes staticExtradata)
1294         public
1295         view
1296         returns (bytes32)
1297     {
1298         return hashToSign(
1299           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]),
1300           nonces[addrs[1]]
1301         );
1302     }
1303 
1304     /**
1305      * @dev Call validateOrderParameters - Solidity ABI encoding limitation workaround, hopefully temporary.
1306      */
1307     function validateOrderParameters_ (
1308         address[7] addrs,
1309         uint[9] uints,
1310         FeeMethod feeMethod,
1311         SaleKindInterface.Side side,
1312         SaleKindInterface.SaleKind saleKind,
1313         AuthenticatedProxy.HowToCall howToCall,
1314         bytes calldata,
1315         bytes replacementPattern,
1316         bytes staticExtradata)
1317         view
1318         public
1319         returns (bool)
1320     {
1321         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1322         return validateOrderParameters(
1323           order
1324         );
1325     }
1326 
1327     /**
1328      * @dev Call validateOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1329      */
1330     function validateOrder_ (
1331         address[7] addrs,
1332         uint[9] uints,
1333         FeeMethod feeMethod,
1334         SaleKindInterface.Side side,
1335         SaleKindInterface.SaleKind saleKind,
1336         AuthenticatedProxy.HowToCall howToCall,
1337         bytes calldata,
1338         bytes replacementPattern,
1339         bytes staticExtradata,
1340         uint8 v,
1341         bytes32 r,
1342         bytes32 s)
1343         view
1344         public
1345         returns (bool)
1346     {
1347         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1348         return validateOrder(
1349           hashToSign(order, nonces[order.maker]),
1350           order,
1351           Sig(v, r, s)
1352         );
1353     }
1354 
1355     /**
1356      * @dev Call approveOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1357      */
1358     function approveOrder_ (
1359         address[7] addrs,
1360         uint[9] uints,
1361         FeeMethod feeMethod,
1362         SaleKindInterface.Side side,
1363         SaleKindInterface.SaleKind saleKind,
1364         AuthenticatedProxy.HowToCall howToCall,
1365         bytes calldata,
1366         bytes replacementPattern,
1367         bytes staticExtradata,
1368         bool orderbookInclusionDesired)
1369         public
1370     {
1371         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1372         return approveOrder(order, orderbookInclusionDesired);
1373     }
1374 
1375     /**
1376      * @dev Call cancelOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1377      */
1378     function cancelOrder_(
1379         address[7] addrs,
1380         uint[9] uints,
1381         FeeMethod feeMethod,
1382         SaleKindInterface.Side side,
1383         SaleKindInterface.SaleKind saleKind,
1384         AuthenticatedProxy.HowToCall howToCall,
1385         bytes calldata,
1386         bytes replacementPattern,
1387         bytes staticExtradata,
1388         uint8 v,
1389         bytes32 r,
1390         bytes32 s)
1391         public
1392     {
1393         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1394         return cancelOrder(
1395           order,
1396           Sig(v, r, s),
1397           nonces[order.maker]
1398         );
1399     }
1400 
1401     /**
1402      * @dev Call cancelOrder, supplying a specific nonce — enables cancelling orders
1403      that were signed with nonces greater than the current nonce.
1404      */
1405     function cancelOrderWithNonce_(
1406         address[7] addrs,
1407         uint[9] uints,
1408         FeeMethod feeMethod,
1409         SaleKindInterface.Side side,
1410         SaleKindInterface.SaleKind saleKind,
1411         AuthenticatedProxy.HowToCall howToCall,
1412         bytes calldata,
1413         bytes replacementPattern,
1414         bytes staticExtradata,
1415         uint8 v,
1416         bytes32 r,
1417         bytes32 s,
1418         uint nonce)
1419         public
1420     {
1421         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1422         return cancelOrder(
1423           order,
1424           Sig(v, r, s),
1425           nonce
1426         );
1427     }
1428 
1429     /**
1430      * @dev Call calculateCurrentPrice - Solidity ABI encoding limitation workaround, hopefully temporary.
1431      */
1432     function calculateCurrentPrice_(
1433         address[7] addrs,
1434         uint[9] uints,
1435         FeeMethod feeMethod,
1436         SaleKindInterface.Side side,
1437         SaleKindInterface.SaleKind saleKind,
1438         AuthenticatedProxy.HowToCall howToCall,
1439         bytes calldata,
1440         bytes replacementPattern,
1441         bytes staticExtradata)
1442         public
1443         view
1444         returns (uint)
1445     {
1446         return calculateCurrentPrice(
1447           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8])
1448         );
1449     }
1450 
1451     /**
1452      * @dev Call ordersCanMatch - Solidity ABI encoding limitation workaround, hopefully temporary.
1453      */
1454     function ordersCanMatch_(
1455         address[14] addrs,
1456         uint[18] uints,
1457         uint8[8] feeMethodsSidesKindsHowToCalls,
1458         bytes calldataBuy,
1459         bytes calldataSell,
1460         bytes replacementPatternBuy,
1461         bytes replacementPatternSell,
1462         bytes staticExtradataBuy,
1463         bytes staticExtradataSell)
1464         public
1465         view
1466         returns (bool)
1467     {
1468         Order memory buy = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1469         Order memory sell = Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17]);
1470         return ordersCanMatch(
1471           buy,
1472           sell
1473         );
1474     }
1475 
1476     /**
1477      * @dev Return whether or not two orders' calldata specifications can match
1478      * @param buyCalldata Buy-side order calldata
1479      * @param buyReplacementPattern Buy-side order calldata replacement mask
1480      * @param sellCalldata Sell-side order calldata
1481      * @param sellReplacementPattern Sell-side order calldata replacement mask
1482      * @return Whether the orders' calldata can be matched
1483      */
1484     function orderCalldataCanMatch(bytes buyCalldata, bytes buyReplacementPattern, bytes sellCalldata, bytes sellReplacementPattern)
1485         public
1486         pure
1487         returns (bool)
1488     {
1489         if (buyReplacementPattern.length > 0) {
1490           ArrayUtils.guardedArrayReplace(buyCalldata, sellCalldata, buyReplacementPattern);
1491         }
1492         if (sellReplacementPattern.length > 0) {
1493           ArrayUtils.guardedArrayReplace(sellCalldata, buyCalldata, sellReplacementPattern);
1494         }
1495         return ArrayUtils.arrayEq(buyCalldata, sellCalldata);
1496     }
1497 
1498     /**
1499      * @dev Call calculateMatchPrice - Solidity ABI encoding limitation workaround, hopefully temporary.
1500      */
1501     function calculateMatchPrice_(
1502         address[14] addrs,
1503         uint[18] uints,
1504         uint8[8] feeMethodsSidesKindsHowToCalls,
1505         bytes calldataBuy,
1506         bytes calldataSell,
1507         bytes replacementPatternBuy,
1508         bytes replacementPatternSell,
1509         bytes staticExtradataBuy,
1510         bytes staticExtradataSell)
1511         public
1512         view
1513         returns (uint)
1514     {
1515         Order memory buy = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1516         Order memory sell = Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17]);
1517         return calculateMatchPrice(
1518           buy,
1519           sell
1520         );
1521     }
1522 
1523     /**
1524      * @dev Call atomicMatch - Solidity ABI encoding limitation workaround, hopefully temporary.
1525      */
1526     function atomicMatch_(
1527         address[14] addrs,
1528         uint[18] uints,
1529         uint8[8] feeMethodsSidesKindsHowToCalls,
1530         bytes calldataBuy,
1531         bytes calldataSell,
1532         bytes replacementPatternBuy,
1533         bytes replacementPatternSell,
1534         bytes staticExtradataBuy,
1535         bytes staticExtradataSell,
1536         uint8[2] vs,
1537         bytes32[5] rssMetadata)
1538         public
1539         payable
1540     {
1541 
1542         return atomicMatch(
1543           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]),
1544           Sig(vs[0], rssMetadata[0], rssMetadata[1]),
1545           Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17]),
1546           Sig(vs[1], rssMetadata[2], rssMetadata[3]),
1547           rssMetadata[4]
1548         );
1549     }
1550 }
1551 
1552 contract StarBlockExchange is Exchange {
1553     string public constant codename = "Bulk Smash";
1554 
1555     /**
1556      * @dev Initialize a WyvernExchange instance
1557      * @param registryAddress Address of the registry instance which this Exchange instance will use
1558      * @param tokenAddress Address of the token used for protocol fees
1559      */
1560     constructor (ProxyRegistry registryAddress, TokenTransferProxy tokenTransferProxyAddress, ERC20 tokenAddress, address protocolFeeAddress) public {
1561         registry = registryAddress;
1562         tokenTransferProxy = tokenTransferProxyAddress;
1563         exchangeToken = tokenAddress;
1564         protocolFeeRecipient = protocolFeeAddress;
1565         owner = msg.sender;
1566     }
1567 }
1568 
1569 library SaleKindInterface {
1570 
1571     /**
1572      * Side: buy or sell.
1573      */
1574     enum Side { Buy, Sell }
1575 
1576     /**
1577      * Currently supported kinds of sale: fixed price, Dutch auction.
1578      * English auctions cannot be supported without stronger escrow guarantees.
1579      * Future interesting options: Vickrey auction, nonlinear Dutch auctions.
1580      */
1581     enum SaleKind { FixedPrice, DutchAuction, CollectionRandomSale }
1582 
1583     /**
1584      * @dev Check whether the parameters of a sale are valid
1585      * @param saleKind Kind of sale
1586      * @param expirationTime Order expiration time
1587      * @return Whether the parameters were valid
1588      */
1589     function validateParameters(SaleKind saleKind, uint expirationTime)
1590         pure
1591         internal
1592         returns (bool)
1593     {
1594         /* Auctions must have a set expiration date. */
1595         if (expirationTime > 0 ) {
1596             return true;
1597         }else {
1598             if (saleKind == SaleKind.FixedPrice || saleKind == SaleKind.CollectionRandomSale) {
1599                 return true;
1600             }
1601         }
1602         return false;
1603     }
1604 
1605     /**
1606      * @dev Return whether or not an order can be settled
1607      * @dev Precondition: parameters have passed validateParameters
1608      * @param listingTime Order listing time
1609      * @param expirationTime Order expiration time
1610      */
1611     function canSettleOrder(uint listingTime, uint expirationTime)
1612         view
1613         internal
1614         returns (bool)
1615     {
1616         return (listingTime < now) && (expirationTime == 0 || now < expirationTime);
1617     }
1618 
1619     /**
1620      * @dev Calculate the settlement price of an order
1621      * @dev Precondition: parameters have passed validateParameters.
1622      * @param side Order side
1623      * @param saleKind Method of sale
1624      * @param basePrice Order base price
1625      * @param extra Order extra price data
1626      * @param listingTime Order listing time
1627      * @param expirationTime Order expiration time
1628      */
1629     function calculateFinalPrice(Side side, SaleKind saleKind, uint basePrice, uint extra, uint listingTime, uint expirationTime)
1630         view
1631         internal
1632         returns (uint finalPrice)
1633     {
1634         if (saleKind == SaleKind.FixedPrice || saleKind == SaleKind.CollectionRandomSale) {
1635             return basePrice;
1636         } else if (saleKind == SaleKind.DutchAuction) {
1637             uint diff = SafeMath.div(SafeMath.mul(extra, SafeMath.sub(now, listingTime)), SafeMath.sub(expirationTime, listingTime));
1638             if (side == Side.Sell) {
1639                 /* Sell-side - start price: basePrice. End price: basePrice - extra. */
1640                 return SafeMath.sub(basePrice, diff);
1641             } else {
1642                 /* Buy-side - start price: basePrice. End price: basePrice + extra. */
1643                 return SafeMath.add(basePrice, diff);
1644             }
1645         }
1646     }
1647 
1648 }
1649 
1650 contract ProxyRegistry is Ownable {
1651 
1652     /* DelegateProxy implementation contract. Must be initialized. */
1653     address public delegateProxyImplementation;
1654 
1655     /* Authenticated proxies by user. */
1656     mapping(address => OwnableDelegateProxy) public proxies;
1657 
1658     /* Contracts pending access. */
1659     mapping(address => uint) public pending;
1660 
1661     /* Contracts allowed to call those proxies. */
1662     mapping(address => bool) public contracts;
1663 
1664     /* Delay period for adding an authenticated contract.
1665        This mitigates a particular class of potential attack on the Wyvern DAO (which owns this registry) - if at any point the value of assets held by proxy contracts exceeded the value of half the WYV supply (votes in the DAO),
1666        a malicious but rational attacker could buy half the Wyvern and grant themselves access to all the proxy contracts. A delay period renders this attack nonthreatening - given two weeks, if that happened, users would have
1667        plenty of time to notice and transfer their assets.
1668     */
1669     uint public DELAY_PERIOD = 2 weeks;
1670 
1671     /**
1672      * Start the process to enable access for specified contract. Subject to delay period.
1673      *
1674      * @dev ProxyRegistry owner only
1675      * @param addr Address to which to grant permissions
1676      */
1677     function startGrantAuthentication (address addr)
1678         public
1679         onlyOwner
1680     {
1681         require(!contracts[addr] && pending[addr] == 0);
1682         pending[addr] = now;
1683     }
1684 
1685     /**
1686      * End the process to nable access for specified contract after delay period has passed.
1687      *
1688      * @dev ProxyRegistry owner only
1689      * @param addr Address to which to grant permissions
1690      */
1691     function endGrantAuthentication (address addr)
1692         public
1693         onlyOwner
1694     {
1695         require(!contracts[addr] && pending[addr] != 0 && ((pending[addr] + DELAY_PERIOD) < now));
1696         pending[addr] = 0;
1697         contracts[addr] = true;
1698     }
1699 
1700     /**
1701      * Revoke access for specified contract. Can be done instantly.
1702      *
1703      * @dev ProxyRegistry owner only
1704      * @param addr Address of which to revoke permissions
1705      */
1706     function revokeAuthentication (address addr)
1707         public
1708         onlyOwner
1709     {
1710         contracts[addr] = false;
1711     }
1712 
1713     /**
1714      * Register a proxy contract with this registry
1715      *
1716      * @dev Must be called by the user which the proxy is for, creates a new AuthenticatedProxy
1717      * @return New AuthenticatedProxy contract
1718      */
1719     function registerProxy()
1720         public
1721         returns (OwnableDelegateProxy proxy)
1722     {
1723         require(proxies[msg.sender] == address(0));
1724         proxy = new OwnableDelegateProxy(msg.sender, delegateProxyImplementation, abi.encodeWithSignature("initialize(address,address)", msg.sender, address(this)));
1725         proxies[msg.sender] = proxy;
1726         return proxy;
1727     }
1728 
1729 }
1730 
1731 contract TokenTransferProxy {
1732 
1733     /* Authentication registry. */
1734     ProxyRegistry public registry;
1735 
1736     /**
1737      * Call ERC20 `transferFrom`
1738      *
1739      * @dev Authenticated contract only
1740      * @param token ERC20 token address
1741      * @param from From address
1742      * @param to To address
1743      * @param amount Transfer amount
1744      */
1745     function transferFrom(address token, address from, address to, uint amount)
1746         public
1747         returns (bool)
1748     {
1749         require(registry.contracts(msg.sender));
1750         return ERC20(token).transferFrom(from, to, amount);
1751     }
1752 
1753 }
1754 
1755 contract OwnedUpgradeabilityStorage {
1756 
1757   // Current implementation
1758   address internal _implementation;
1759 
1760   // Owner of the contract
1761   address private _upgradeabilityOwner;
1762 
1763   /**
1764    * @dev Tells the address of the owner
1765    * @return the address of the owner
1766    */
1767   function upgradeabilityOwner() public view returns (address) {
1768     return _upgradeabilityOwner;
1769   }
1770 
1771   /**
1772    * @dev Sets the address of the owner
1773    */
1774   function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
1775     _upgradeabilityOwner = newUpgradeabilityOwner;
1776   }
1777 
1778   /**
1779   * @dev Tells the address of the current implementation
1780   * @return address of the current implementation
1781   */
1782   function implementation() public view returns (address) {
1783     return _implementation;
1784   }
1785 
1786   /**
1787   * @dev Tells the proxy type (EIP 897)
1788   * @return Proxy type, 2 for forwarding proxy
1789   */
1790   function proxyType() public pure returns (uint256 proxyTypeId) {
1791     return 2;
1792   }
1793 }
1794 
1795 contract AuthenticatedProxy is TokenRecipient, OwnedUpgradeabilityStorage {
1796 
1797     /* Whether initialized. */
1798     bool initialized = false;
1799 
1800     /* Address which owns this proxy. */
1801     address public user;
1802 
1803     /* Associated registry with contract authentication information. */
1804     ProxyRegistry public registry;
1805 
1806     /* Whether access has been revoked. */
1807     bool public revoked;
1808 
1809     /* Delegate call could be used to atomically transfer multiple assets owned by the proxy contract with one order. */
1810     enum HowToCall { Call, DelegateCall }
1811 
1812     /* Event fired when the proxy access is revoked or unrevoked. */
1813     event Revoked(bool revoked);
1814 
1815     /**
1816      * Initialize an AuthenticatedProxy
1817      *
1818      * @param addrUser Address of user on whose behalf this proxy will act
1819      * @param addrRegistry Address of ProxyRegistry contract which will manage this proxy
1820      */
1821     function initialize (address addrUser, ProxyRegistry addrRegistry)
1822         public
1823     {
1824         require(!initialized);
1825         initialized = true;
1826         user = addrUser;
1827         registry = addrRegistry;
1828     }
1829 
1830     /**
1831      * Set the revoked flag (allows a user to revoke ProxyRegistry access)
1832      *
1833      * @dev Can be called by the user only
1834      * @param revoke Whether or not to revoke access
1835      */
1836     function setRevoke(bool revoke)
1837         public
1838     {
1839         require(msg.sender == user);
1840         revoked = revoke;
1841         emit Revoked(revoke);
1842     }
1843 
1844     /**
1845      * Execute a message call from the proxy contract
1846      *
1847      * @dev Can be called by the user, or by a contract authorized by the registry as long as the user has not revoked access
1848      * @param dest Address to which the call will be sent
1849      * @param howToCall Which kind of call to make
1850      * @param calldata Calldata to send
1851      * @return Result of the call (success or failure)
1852      */
1853     function proxy(address dest, HowToCall howToCall, bytes calldata)
1854         public
1855         returns (bool result)
1856     {
1857         require(msg.sender == user || (!revoked && registry.contracts(msg.sender)));
1858         if (howToCall == HowToCall.Call) {
1859             result = dest.call(calldata);
1860         } else if (howToCall == HowToCall.DelegateCall) {
1861             result = dest.delegatecall(calldata);
1862         }
1863         return result;
1864     }
1865 
1866     /**
1867      * Execute a message call and assert success
1868      *
1869      * @dev Same functionality as `proxy`, just asserts the return value
1870      * @param dest Address to which the call will be sent
1871      * @param howToCall What kind of call to make
1872      * @param calldata Calldata to send
1873      */
1874     function proxyAssert(address dest, HowToCall howToCall, bytes calldata)
1875         public
1876     {
1877         require(proxy(dest, howToCall, calldata));
1878     }
1879 
1880 }
1881 
1882 contract Proxy {
1883 
1884   /**
1885   * @dev Tells the address of the implementation where every call will be delegated.
1886   * @return address of the implementation to which it will be delegated
1887   */
1888   function implementation() public view returns (address);
1889 
1890   /**
1891   * @dev Tells the type of proxy (EIP 897)
1892   * @return Type of proxy, 2 for upgradeable proxy
1893   */
1894   function proxyType() public pure returns (uint256 proxyTypeId);
1895 
1896   /**
1897   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
1898   * This function will return whatever the implementation call returns
1899   */
1900   function () payable public {
1901     address _impl = implementation();
1902     require(_impl != address(0));
1903 
1904     assembly {
1905       let ptr := mload(0x40)
1906       calldatacopy(ptr, 0, calldatasize)
1907       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
1908       let size := returndatasize
1909       returndatacopy(ptr, 0, size)
1910 
1911       switch result
1912       case 0 { revert(ptr, size) }
1913       default { return(ptr, size) }
1914     }
1915   }
1916 }
1917 
1918 contract OwnedUpgradeabilityProxy is Proxy, OwnedUpgradeabilityStorage {
1919   /**
1920   * @dev Event to show ownership has been transferred
1921   * @param previousOwner representing the address of the previous owner
1922   * @param newOwner representing the address of the new owner
1923   */
1924   event ProxyOwnershipTransferred(address previousOwner, address newOwner);
1925 
1926   /**
1927   * @dev This event will be emitted every time the implementation gets upgraded
1928   * @param implementation representing the address of the upgraded implementation
1929   */
1930   event Upgraded(address indexed implementation);
1931 
1932   /**
1933   * @dev Upgrades the implementation address
1934   * @param implementation representing the address of the new implementation to be set
1935   */
1936   function _upgradeTo(address implementation) internal {
1937     require(_implementation != implementation);
1938     _implementation = implementation;
1939     emit Upgraded(implementation);
1940   }
1941 
1942   /**
1943   * @dev Throws if called by any account other than the owner.
1944   */
1945   modifier onlyProxyOwner() {
1946     require(msg.sender == proxyOwner());
1947     _;
1948   }
1949 
1950   /**
1951    * @dev Tells the address of the proxy owner
1952    * @return the address of the proxy owner
1953    */
1954   function proxyOwner() public view returns (address) {
1955     return upgradeabilityOwner();
1956   }
1957 
1958   /**
1959    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1960    * @param newOwner The address to transfer ownership to.
1961    */
1962   function transferProxyOwnership(address newOwner) public onlyProxyOwner {
1963     require(newOwner != address(0));
1964     emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
1965     setUpgradeabilityOwner(newOwner);
1966   }
1967 
1968   /**
1969    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy.
1970    * @param implementation representing the address of the new implementation to be set.
1971    */
1972   function upgradeTo(address implementation) public onlyProxyOwner {
1973     _upgradeTo(implementation);
1974   }
1975 
1976   /**
1977    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy
1978    * and delegatecall the new implementation for initialization.
1979    * @param implementation representing the address of the new implementation to be set.
1980    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
1981    * signature of the implementation to be called with the needed payload
1982    */
1983   function upgradeToAndCall(address implementation, bytes data) payable public onlyProxyOwner {
1984     upgradeTo(implementation);
1985     require(address(this).delegatecall(data));
1986   }
1987 }
1988 
1989 contract OwnableDelegateProxy is OwnedUpgradeabilityProxy {
1990 
1991     constructor(address owner, address initialImplementation, bytes calldata)
1992         public
1993     {
1994         setUpgradeabilityOwner(owner);
1995         _upgradeTo(initialImplementation);
1996         require(initialImplementation.delegatecall(calldata));
1997     }
1998 
1999 }