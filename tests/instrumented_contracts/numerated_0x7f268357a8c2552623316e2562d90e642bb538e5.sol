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
366     string public constant name = "Wyvern Exchange Contract";
367     string public constant version = "2.3";
368 
369     // NOTE: these hashes are derived and verified in the constructor.
370     bytes32 private constant _EIP_712_DOMAIN_TYPEHASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
371     bytes32 private constant _NAME_HASH = 0x9a2ed463836165738cfa54208ff6e7847fd08cbaac309aac057086cb0a144d13;
372     bytes32 private constant _VERSION_HASH = 0xe2fd538c762ee69cab09ccd70e2438075b7004dd87577dc3937e9fcc8174bb64;
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
384     bytes32 public constant DOMAIN_SEPARATOR = 0x72982d92449bfb3d338412ce4738761aff47fb975ceb17a1bc3712ec716a5a68;
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
495         require(DOMAIN_SEPARATOR == _deriveDomainSeparator());
496     }
497 
498     /**
499      * @dev Derive the domain separator for EIP-712 signatures.
500      * @return The domain separator.
501      */
502     function _deriveDomainSeparator() private view returns (bytes32) {
503         return keccak256(
504             abi.encode(
505                 _EIP_712_DOMAIN_TYPEHASH, // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
506                 _NAME_HASH, // keccak256("Wyvern Exchange Contract")
507                 _VERSION_HASH, // keccak256(bytes("2.3"))
508                 _CHAIN_ID, // NOTE: this is fixed, need to use solidity 0.5+ or make external call to support!
509                 address(this)
510             )
511         );
512     }
513 
514     /**
515      * Increment a particular maker's nonce, thereby invalidating all orders that were not signed
516      * with the original nonce.
517      */
518     function incrementNonce() external {
519         uint newNonce = ++nonces[msg.sender];
520         emit NonceIncremented(msg.sender, newNonce);
521     }
522 
523     /**
524      * @dev Change the minimum maker fee paid to the protocol (owner only)
525      * @param newMinimumMakerProtocolFee New fee to set in basis points
526      */
527     function changeMinimumMakerProtocolFee(uint newMinimumMakerProtocolFee)
528         public
529         onlyOwner
530     {
531         minimumMakerProtocolFee = newMinimumMakerProtocolFee;
532     }
533 
534     /**
535      * @dev Change the minimum taker fee paid to the protocol (owner only)
536      * @param newMinimumTakerProtocolFee New fee to set in basis points
537      */
538     function changeMinimumTakerProtocolFee(uint newMinimumTakerProtocolFee)
539         public
540         onlyOwner
541     {
542         minimumTakerProtocolFee = newMinimumTakerProtocolFee;
543     }
544 
545     /**
546      * @dev Change the protocol fee recipient (owner only)
547      * @param newProtocolFeeRecipient New protocol fee recipient address
548      */
549     function changeProtocolFeeRecipient(address newProtocolFeeRecipient)
550         public
551         onlyOwner
552     {
553         protocolFeeRecipient = newProtocolFeeRecipient;
554     }
555 
556     /**
557      * @dev Transfer tokens
558      * @param token Token to transfer
559      * @param from Address to charge fees
560      * @param to Address to receive fees
561      * @param amount Amount of protocol tokens to charge
562      */
563     function transferTokens(address token, address from, address to, uint amount)
564         internal
565     {
566         if (amount > 0) {
567             require(tokenTransferProxy.transferFrom(token, from, to, amount));
568         }
569     }
570 
571     /**
572      * @dev Charge a fee in protocol tokens
573      * @param from Address to charge fees
574      * @param to Address to receive fees
575      * @param amount Amount of protocol tokens to charge
576      */
577     function chargeProtocolFee(address from, address to, uint amount)
578         internal
579     {
580         transferTokens(exchangeToken, from, to, amount);
581     }
582 
583     /**
584      * @dev Execute a STATICCALL (introduced with Ethereum Metropolis, non-state-modifying external call)
585      * @param target Contract to call
586      * @param calldata Calldata (appended to extradata)
587      * @param extradata Base data for STATICCALL (probably function selector and argument encoding)
588      * @return The result of the call (success or failure)
589      */
590     function staticCall(address target, bytes memory calldata, bytes memory extradata)
591         public
592         view
593         returns (bool result)
594     {
595         bytes memory combined = new bytes(calldata.length + extradata.length);
596         uint index;
597         assembly {
598             index := add(combined, 0x20)
599         }
600         index = ArrayUtils.unsafeWriteBytes(index, extradata);
601         ArrayUtils.unsafeWriteBytes(index, calldata);
602         assembly {
603             result := staticcall(gas, target, add(combined, 0x20), mload(combined), mload(0x40), 0)
604         }
605         return result;
606     }
607 
608     /**
609      * @dev Hash an order, returning the canonical EIP-712 order hash without the domain separator
610      * @param order Order to hash
611      * @param nonce maker nonce to hash
612      * @return Hash of order
613      */
614     function hashOrder(Order memory order, uint nonce)
615         internal
616         pure
617         returns (bytes32 hash)
618     {
619         /* Unfortunately abi.encodePacked doesn't work here, stack size constraints. */
620         uint size = 800;
621         bytes memory array = new bytes(size);
622         uint index;
623         assembly {
624             index := add(array, 0x20)
625         }
626         index = ArrayUtils.unsafeWriteBytes32(index, _ORDER_TYPEHASH);
627         index = ArrayUtils.unsafeWriteAddressWord(index, order.exchange);
628         index = ArrayUtils.unsafeWriteAddressWord(index, order.maker);
629         index = ArrayUtils.unsafeWriteAddressWord(index, order.taker);
630         index = ArrayUtils.unsafeWriteUint(index, order.makerRelayerFee);
631         index = ArrayUtils.unsafeWriteUint(index, order.takerRelayerFee);
632         index = ArrayUtils.unsafeWriteUint(index, order.makerProtocolFee);
633         index = ArrayUtils.unsafeWriteUint(index, order.takerProtocolFee);
634         index = ArrayUtils.unsafeWriteAddressWord(index, order.feeRecipient);
635         index = ArrayUtils.unsafeWriteUint8Word(index, uint8(order.feeMethod));
636         index = ArrayUtils.unsafeWriteUint8Word(index, uint8(order.side));
637         index = ArrayUtils.unsafeWriteUint8Word(index, uint8(order.saleKind));
638         index = ArrayUtils.unsafeWriteAddressWord(index, order.target);
639         index = ArrayUtils.unsafeWriteUint8Word(index, uint8(order.howToCall));
640         index = ArrayUtils.unsafeWriteBytes32(index, keccak256(order.calldata));
641         index = ArrayUtils.unsafeWriteBytes32(index, keccak256(order.replacementPattern));
642         index = ArrayUtils.unsafeWriteAddressWord(index, order.staticTarget);
643         index = ArrayUtils.unsafeWriteBytes32(index, keccak256(order.staticExtradata));
644         index = ArrayUtils.unsafeWriteAddressWord(index, order.paymentToken);
645         index = ArrayUtils.unsafeWriteUint(index, order.basePrice);
646         index = ArrayUtils.unsafeWriteUint(index, order.extra);
647         index = ArrayUtils.unsafeWriteUint(index, order.listingTime);
648         index = ArrayUtils.unsafeWriteUint(index, order.expirationTime);
649         index = ArrayUtils.unsafeWriteUint(index, order.salt);
650         index = ArrayUtils.unsafeWriteUint(index, nonce);
651         assembly {
652             hash := keccak256(add(array, 0x20), size)
653         }
654         return hash;
655     }
656 
657     /**
658      * @dev Hash an order, returning the hash that a client must sign via EIP-712 including the message prefix
659      * @param order Order to hash
660      * @param nonce Nonce to hash
661      * @return Hash of message prefix and order hash per Ethereum format
662      */
663     function hashToSign(Order memory order, uint nonce)
664         internal
665         pure
666         returns (bytes32)
667     {
668         return keccak256(
669             abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hashOrder(order, nonce))
670         );
671     }
672 
673     /**
674      * @dev Assert an order is valid and return its hash
675      * @param order Order to validate
676      * @param nonce Nonce to validate
677      * @param sig ECDSA signature
678      */
679     function requireValidOrder(Order memory order, Sig memory sig, uint nonce)
680         internal
681         view
682         returns (bytes32)
683     {
684         bytes32 hash = hashToSign(order, nonce);
685         require(validateOrder(hash, order, sig));
686         return hash;
687     }
688 
689     /**
690      * @dev Validate order parameters (does *not* check signature validity)
691      * @param order Order to validate
692      */
693     function validateOrderParameters(Order memory order)
694         internal
695         view
696         returns (bool)
697     {
698         /* Order must be targeted at this protocol version (this Exchange contract). */
699         if (order.exchange != address(this)) {
700             return false;
701         }
702 
703         /* Order must have a maker. */
704         if (order.maker == address(0)) {
705             return false;
706         }
707 
708         /* Order must possess valid sale kind parameter combination. */
709         if (!SaleKindInterface.validateParameters(order.saleKind, order.expirationTime)) {
710             return false;
711         }
712 
713         /* If using the split fee method, order must have sufficient protocol fees. */
714         if (order.feeMethod == FeeMethod.SplitFee && (order.makerProtocolFee < minimumMakerProtocolFee || order.takerProtocolFee < minimumTakerProtocolFee)) {
715             return false;
716         }
717 
718         return true;
719     }
720 
721     /**
722      * @dev Validate a provided previously approved / signed order, hash, and signature.
723      * @param hash Order hash (already calculated, passed to avoid recalculation)
724      * @param order Order to validate
725      * @param sig ECDSA signature
726      */
727     function validateOrder(bytes32 hash, Order memory order, Sig memory sig)
728         internal
729         view
730         returns (bool)
731     {
732         /* Not done in an if-conditional to prevent unnecessary ecrecover evaluation, which seems to happen even though it should short-circuit. */
733 
734         /* Order must have valid parameters. */
735         if (!validateOrderParameters(order)) {
736             return false;
737         }
738 
739         /* Order must have not been canceled or already filled. */
740         if (cancelledOrFinalized[hash]) {
741             return false;
742         }
743 
744         /* Return true if order has been previously approved with the current nonce */
745         uint approvedOrderNoncePlusOne = _approvedOrdersByNonce[hash];
746         if (approvedOrderNoncePlusOne != 0) {
747             return approvedOrderNoncePlusOne == nonces[order.maker] + 1;
748         }
749 
750         /* Prevent signature malleability and non-standard v values. */
751         if (uint256(sig.s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
752             return false;
753         }
754         if (sig.v != 27 && sig.v != 28) {
755             return false;
756         }
757 
758         /* recover via ECDSA, signed by maker (already verified as non-zero). */
759         if (ecrecover(hash, sig.v, sig.r, sig.s) == order.maker) {
760             return true;
761         }
762 
763         /* fallback — attempt EIP-1271 isValidSignature check. */
764         return _tryContractSignature(order.maker, hash, sig);
765     }
766 
767     function _tryContractSignature(address orderMaker, bytes32 hash, Sig memory sig) internal view returns (bool) {
768         bytes memory isValidSignatureData = abi.encodeWithSelector(
769             _EIP_1271_MAGIC_VALUE,
770             hash,
771             abi.encodePacked(sig.r, sig.s, sig.v)
772         );
773 
774         bytes4 result;
775 
776         // NOTE: solidity 0.4.x does not support STATICCALL outside of assembly
777         assembly {
778             let success := staticcall(           // perform a staticcall
779                 gas,                             // forward all available gas
780                 orderMaker,                      // call the order maker
781                 add(isValidSignatureData, 0x20), // calldata offset comes after length
782                 mload(isValidSignatureData),     // load calldata length
783                 0,                               // do not use memory for return data
784                 0                                // do not use memory for return data
785             )
786 
787             if iszero(success) {                     // if the call fails
788                 returndatacopy(0, 0, returndatasize) // copy returndata buffer to memory
789                 revert(0, returndatasize)            // revert + pass through revert data
790             }
791 
792             if eq(returndatasize, 0x20) {  // if returndata == 32 (one word)
793                 returndatacopy(0, 0, 0x20) // copy return data to memory in scratch space
794                 result := mload(0)         // load return data from memory to the stack
795             }
796         }
797 
798         return result == _EIP_1271_MAGIC_VALUE;
799     }
800 
801     /**
802      * @dev Determine if an order has been approved. Note that the order may not still
803      * be valid in cases where the maker's nonce has been incremented.
804      * @param hash Hash of the order
805      * @return whether or not the order was approved.
806      */
807     function approvedOrders(bytes32 hash) public view returns (bool approved) {
808         return _approvedOrdersByNonce[hash] != 0;
809     }
810 
811     /**
812      * @dev Approve an order and optionally mark it for orderbook inclusion. Must be called by the maker of the order
813      * @param order Order to approve
814      * @param orderbookInclusionDesired Whether orderbook providers should include the order in their orderbooks
815      */
816     function approveOrder(Order memory order, bool orderbookInclusionDesired)
817         internal
818     {
819         /* CHECKS */
820 
821         /* Assert sender is authorized to approve order. */
822         require(msg.sender == order.maker);
823 
824         /* Calculate order hash. */
825         bytes32 hash = hashToSign(order, nonces[order.maker]);
826 
827         /* Assert order has not already been approved. */
828         require(_approvedOrdersByNonce[hash] == 0);
829 
830         /* EFFECTS */
831 
832         /* Mark order as approved. */
833         _approvedOrdersByNonce[hash] = nonces[order.maker] + 1;
834 
835         /* Log approval event. Must be split in two due to Solidity stack size limitations. */
836         {
837             emit OrderApprovedPartOne(hash, order.exchange, order.maker, order.taker, order.makerRelayerFee, order.takerRelayerFee, order.makerProtocolFee, order.takerProtocolFee, order.feeRecipient, order.feeMethod, order.side, order.saleKind, order.target);
838         }
839         {
840             emit OrderApprovedPartTwo(hash, order.howToCall, order.calldata, order.replacementPattern, order.staticTarget, order.staticExtradata, order.paymentToken, order.basePrice, order.extra, order.listingTime, order.expirationTime, order.salt, orderbookInclusionDesired);
841         }
842     }
843 
844     /**
845      * @dev Cancel an order, preventing it from being matched. Must be called by the maker of the order
846      * @param order Order to cancel
847      * @param nonce Nonce to cancel
848      * @param sig ECDSA signature
849      */
850     function cancelOrder(Order memory order, Sig memory sig, uint nonce)
851         internal
852     {
853         /* CHECKS */
854 
855         /* Calculate order hash. */
856         bytes32 hash = requireValidOrder(order, sig, nonce);
857 
858         /* Assert sender is authorized to cancel order. */
859         require(msg.sender == order.maker);
860 
861         /* EFFECTS */
862 
863         /* Mark order as cancelled, preventing it from being matched. */
864         cancelledOrFinalized[hash] = true;
865 
866         /* Log cancel event. */
867         emit OrderCancelled(hash);
868     }
869 
870     /**
871      * @dev Calculate the current price of an order (convenience function)
872      * @param order Order to calculate the price of
873      * @return The current price of the order
874      */
875     function calculateCurrentPrice (Order memory order)
876         internal
877         view
878         returns (uint)
879     {
880         return SaleKindInterface.calculateFinalPrice(order.side, order.saleKind, order.basePrice, order.extra, order.listingTime, order.expirationTime);
881     }
882 
883     /**
884      * @dev Calculate the price two orders would match at, if in fact they would match (otherwise fail)
885      * @param buy Buy-side order
886      * @param sell Sell-side order
887      * @return Match price
888      */
889     function calculateMatchPrice(Order memory buy, Order memory sell)
890         view
891         internal
892         returns (uint)
893     {
894         /* Calculate sell price. */
895         uint sellPrice = SaleKindInterface.calculateFinalPrice(sell.side, sell.saleKind, sell.basePrice, sell.extra, sell.listingTime, sell.expirationTime);
896 
897         /* Calculate buy price. */
898         uint buyPrice = SaleKindInterface.calculateFinalPrice(buy.side, buy.saleKind, buy.basePrice, buy.extra, buy.listingTime, buy.expirationTime);
899 
900         /* Require price cross. */
901         require(buyPrice >= sellPrice);
902 
903         /* Maker/taker priority. */
904         return sell.feeRecipient != address(0) ? sellPrice : buyPrice;
905     }
906 
907     /**
908      * @dev Execute all ERC20 token / Ether transfers associated with an order match (fees and buyer => seller transfer)
909      * @param buy Buy-side order
910      * @param sell Sell-side order
911      */
912     function executeFundsTransfer(Order memory buy, Order memory sell)
913         internal
914         returns (uint)
915     {
916         /* Only payable in the special case of unwrapped Ether. */
917         if (sell.paymentToken != address(0)) {
918             require(msg.value == 0);
919         }
920 
921         /* Calculate match price. */
922         uint price = calculateMatchPrice(buy, sell);
923 
924         /* If paying using a token (not Ether), transfer tokens. This is done prior to fee payments to that a seller will have tokens before being charged fees. */
925         if (price > 0 && sell.paymentToken != address(0)) {
926             transferTokens(sell.paymentToken, buy.maker, sell.maker, price);
927         }
928 
929         /* Amount that will be received by seller (for Ether). */
930         uint receiveAmount = price;
931 
932         /* Amount that must be sent by buyer (for Ether). */
933         uint requiredAmount = price;
934 
935         /* Determine maker/taker and charge fees accordingly. */
936         if (sell.feeRecipient != address(0)) {
937             /* Sell-side order is maker. */
938 
939             /* Assert taker fee is less than or equal to maximum fee specified by buyer. */
940             require(sell.takerRelayerFee <= buy.takerRelayerFee);
941 
942             if (sell.feeMethod == FeeMethod.SplitFee) {
943                 /* Assert taker fee is less than or equal to maximum fee specified by buyer. */
944                 require(sell.takerProtocolFee <= buy.takerProtocolFee);
945 
946                 /* Maker fees are deducted from the token amount that the maker receives. Taker fees are extra tokens that must be paid by the taker. */
947 
948                 if (sell.makerRelayerFee > 0) {
949                     uint makerRelayerFee = SafeMath.div(SafeMath.mul(sell.makerRelayerFee, price), INVERSE_BASIS_POINT);
950                     if (sell.paymentToken == address(0)) {
951                         receiveAmount = SafeMath.sub(receiveAmount, makerRelayerFee);
952                         sell.feeRecipient.transfer(makerRelayerFee);
953                     } else {
954                         transferTokens(sell.paymentToken, sell.maker, sell.feeRecipient, makerRelayerFee);
955                     }
956                 }
957 
958                 if (sell.takerRelayerFee > 0) {
959                     uint takerRelayerFee = SafeMath.div(SafeMath.mul(sell.takerRelayerFee, price), INVERSE_BASIS_POINT);
960                     if (sell.paymentToken == address(0)) {
961                         requiredAmount = SafeMath.add(requiredAmount, takerRelayerFee);
962                         sell.feeRecipient.transfer(takerRelayerFee);
963                     } else {
964                         transferTokens(sell.paymentToken, buy.maker, sell.feeRecipient, takerRelayerFee);
965                     }
966                 }
967 
968                 if (sell.makerProtocolFee > 0) {
969                     uint makerProtocolFee = SafeMath.div(SafeMath.mul(sell.makerProtocolFee, price), INVERSE_BASIS_POINT);
970                     if (sell.paymentToken == address(0)) {
971                         receiveAmount = SafeMath.sub(receiveAmount, makerProtocolFee);
972                         protocolFeeRecipient.transfer(makerProtocolFee);
973                     } else {
974                         transferTokens(sell.paymentToken, sell.maker, protocolFeeRecipient, makerProtocolFee);
975                     }
976                 }
977 
978                 if (sell.takerProtocolFee > 0) {
979                     uint takerProtocolFee = SafeMath.div(SafeMath.mul(sell.takerProtocolFee, price), INVERSE_BASIS_POINT);
980                     if (sell.paymentToken == address(0)) {
981                         requiredAmount = SafeMath.add(requiredAmount, takerProtocolFee);
982                         protocolFeeRecipient.transfer(takerProtocolFee);
983                     } else {
984                         transferTokens(sell.paymentToken, buy.maker, protocolFeeRecipient, takerProtocolFee);
985                     }
986                 }
987 
988             } else {
989                 /* Charge maker fee to seller. */
990                 chargeProtocolFee(sell.maker, sell.feeRecipient, sell.makerRelayerFee);
991 
992                 /* Charge taker fee to buyer. */
993                 chargeProtocolFee(buy.maker, sell.feeRecipient, sell.takerRelayerFee);
994             }
995         } else {
996             /* Buy-side order is maker. */
997 
998             /* Assert taker fee is less than or equal to maximum fee specified by seller. */
999             require(buy.takerRelayerFee <= sell.takerRelayerFee);
1000 
1001             if (sell.feeMethod == FeeMethod.SplitFee) {
1002                 /* The Exchange does not escrow Ether, so direct Ether can only be used to with sell-side maker / buy-side taker orders. */
1003                 require(sell.paymentToken != address(0));
1004 
1005                 /* Assert taker fee is less than or equal to maximum fee specified by seller. */
1006                 require(buy.takerProtocolFee <= sell.takerProtocolFee);
1007 
1008                 if (buy.makerRelayerFee > 0) {
1009                     makerRelayerFee = SafeMath.div(SafeMath.mul(buy.makerRelayerFee, price), INVERSE_BASIS_POINT);
1010                     transferTokens(sell.paymentToken, buy.maker, buy.feeRecipient, makerRelayerFee);
1011                 }
1012 
1013                 if (buy.takerRelayerFee > 0) {
1014                     takerRelayerFee = SafeMath.div(SafeMath.mul(buy.takerRelayerFee, price), INVERSE_BASIS_POINT);
1015                     transferTokens(sell.paymentToken, sell.maker, buy.feeRecipient, takerRelayerFee);
1016                 }
1017 
1018                 if (buy.makerProtocolFee > 0) {
1019                     makerProtocolFee = SafeMath.div(SafeMath.mul(buy.makerProtocolFee, price), INVERSE_BASIS_POINT);
1020                     transferTokens(sell.paymentToken, buy.maker, protocolFeeRecipient, makerProtocolFee);
1021                 }
1022 
1023                 if (buy.takerProtocolFee > 0) {
1024                     takerProtocolFee = SafeMath.div(SafeMath.mul(buy.takerProtocolFee, price), INVERSE_BASIS_POINT);
1025                     transferTokens(sell.paymentToken, sell.maker, protocolFeeRecipient, takerProtocolFee);
1026                 }
1027 
1028             } else {
1029                 /* Charge maker fee to buyer. */
1030                 chargeProtocolFee(buy.maker, buy.feeRecipient, buy.makerRelayerFee);
1031 
1032                 /* Charge taker fee to seller. */
1033                 chargeProtocolFee(sell.maker, buy.feeRecipient, buy.takerRelayerFee);
1034             }
1035         }
1036 
1037         if (sell.paymentToken == address(0)) {
1038             /* Special-case Ether, order must be matched by buyer. */
1039             require(msg.value >= requiredAmount);
1040             sell.maker.transfer(receiveAmount);
1041             /* Allow overshoot for variable-price auctions, refund difference. */
1042             uint diff = SafeMath.sub(msg.value, requiredAmount);
1043             if (diff > 0) {
1044                 buy.maker.transfer(diff);
1045             }
1046         }
1047 
1048         /* This contract should never hold Ether, however, we cannot assert this, since it is impossible to prevent anyone from sending Ether e.g. with selfdestruct. */
1049 
1050         return price;
1051     }
1052 
1053     /**
1054      * @dev Return whether or not two orders can be matched with each other by basic parameters (does not check order signatures / calldata or perform static calls)
1055      * @param buy Buy-side order
1056      * @param sell Sell-side order
1057      * @return Whether or not the two orders can be matched
1058      */
1059     function ordersCanMatch(Order memory buy, Order memory sell)
1060         internal
1061         view
1062         returns (bool)
1063     {
1064         return (
1065             /* Must be opposite-side. */
1066             (buy.side == SaleKindInterface.Side.Buy && sell.side == SaleKindInterface.Side.Sell) &&
1067             /* Must use same fee method. */
1068             (buy.feeMethod == sell.feeMethod) &&
1069             /* Must use same payment token. */
1070             (buy.paymentToken == sell.paymentToken) &&
1071             /* Must match maker/taker addresses. */
1072             (sell.taker == address(0) || sell.taker == buy.maker) &&
1073             (buy.taker == address(0) || buy.taker == sell.maker) &&
1074             /* One must be maker and the other must be taker (no bool XOR in Solidity). */
1075             ((sell.feeRecipient == address(0) && buy.feeRecipient != address(0)) || (sell.feeRecipient != address(0) && buy.feeRecipient == address(0))) &&
1076             /* Must match target. */
1077             (buy.target == sell.target) &&
1078             /* Must match howToCall. */
1079             (buy.howToCall == sell.howToCall) &&
1080             /* Buy-side order must be settleable. */
1081             SaleKindInterface.canSettleOrder(buy.listingTime, buy.expirationTime) &&
1082             /* Sell-side order must be settleable. */
1083             SaleKindInterface.canSettleOrder(sell.listingTime, sell.expirationTime)
1084         );
1085     }
1086 
1087     /**
1088      * @dev Atomically match two orders, ensuring validity of the match, and execute all associated state transitions. Protected against reentrancy by a contract-global lock.
1089      * @param buy Buy-side order
1090      * @param buySig Buy-side order signature
1091      * @param sell Sell-side order
1092      * @param sellSig Sell-side order signature
1093      */
1094     function atomicMatch(Order memory buy, Sig memory buySig, Order memory sell, Sig memory sellSig, bytes32 metadata)
1095         internal
1096         reentrancyGuard
1097     {
1098         /* CHECKS */
1099 
1100         /* Ensure buy order validity and calculate hash if necessary. */
1101         bytes32 buyHash;
1102         if (buy.maker == msg.sender) {
1103             require(validateOrderParameters(buy));
1104         } else {
1105             buyHash = _requireValidOrderWithNonce(buy, buySig);
1106         }
1107 
1108         /* Ensure sell order validity and calculate hash if necessary. */
1109         bytes32 sellHash;
1110         if (sell.maker == msg.sender) {
1111             require(validateOrderParameters(sell));
1112         } else {
1113             sellHash = _requireValidOrderWithNonce(sell, sellSig);
1114         }
1115 
1116         /* Must be matchable. */
1117         require(ordersCanMatch(buy, sell));
1118 
1119         /* Target must exist (prevent malicious selfdestructs just prior to order settlement). */
1120         uint size;
1121         address target = sell.target;
1122         assembly {
1123             size := extcodesize(target)
1124         }
1125         require(size > 0);
1126 
1127         /* Must match calldata after replacement, if specified. */
1128         if (buy.replacementPattern.length > 0) {
1129           ArrayUtils.guardedArrayReplace(buy.calldata, sell.calldata, buy.replacementPattern);
1130         }
1131         if (sell.replacementPattern.length > 0) {
1132           ArrayUtils.guardedArrayReplace(sell.calldata, buy.calldata, sell.replacementPattern);
1133         }
1134         require(ArrayUtils.arrayEq(buy.calldata, sell.calldata));
1135 
1136         /* Retrieve delegateProxy contract. */
1137         OwnableDelegateProxy delegateProxy = registry.proxies(sell.maker);
1138 
1139         /* Proxy must exist. */
1140         require(delegateProxy != address(0));
1141 
1142         /* Access the passthrough AuthenticatedProxy. */
1143         AuthenticatedProxy proxy = AuthenticatedProxy(delegateProxy);
1144 
1145         /* EFFECTS */
1146 
1147         /* Mark previously signed or approved orders as finalized. */
1148         if (msg.sender != buy.maker) {
1149             cancelledOrFinalized[buyHash] = true;
1150         }
1151         if (msg.sender != sell.maker) {
1152             cancelledOrFinalized[sellHash] = true;
1153         }
1154 
1155         /* INTERACTIONS */
1156 
1157         /* Execute funds transfer and pay fees. */
1158         uint price = executeFundsTransfer(buy, sell);
1159 
1160         /* Assert implementation. */
1161         require(delegateProxy.implementation() == registry.delegateProxyImplementation());
1162 
1163         /* Execute specified call through proxy. */
1164         require(proxy.proxy(sell.target, sell.howToCall, sell.calldata));
1165 
1166         /* Static calls are intentionally done after the effectful call so they can check resulting state. */
1167 
1168         /* Handle buy-side static call if specified. */
1169         if (buy.staticTarget != address(0)) {
1170             require(staticCall(buy.staticTarget, sell.calldata, buy.staticExtradata));
1171         }
1172 
1173         /* Handle sell-side static call if specified. */
1174         if (sell.staticTarget != address(0)) {
1175             require(staticCall(sell.staticTarget, sell.calldata, sell.staticExtradata));
1176         }
1177 
1178         /* Log match event. */
1179         emit OrdersMatched(buyHash, sellHash, sell.feeRecipient != address(0) ? sell.maker : buy.maker, sell.feeRecipient != address(0) ? buy.maker : sell.maker, price, metadata);
1180     }
1181 
1182     function _requireValidOrderWithNonce(Order memory order, Sig memory sig) internal view returns (bytes32) {
1183         return requireValidOrder(order, sig, nonces[order.maker]);
1184     }
1185 }
1186 
1187 contract Exchange is ExchangeCore {
1188 
1189     /**
1190      * @dev Call guardedArrayReplace - library function exposed for testing.
1191      */
1192     function guardedArrayReplace(bytes array, bytes desired, bytes mask)
1193         public
1194         pure
1195         returns (bytes)
1196     {
1197         ArrayUtils.guardedArrayReplace(array, desired, mask);
1198         return array;
1199     }
1200 
1201     /**
1202      * @dev Call calculateFinalPrice - library function exposed for testing.
1203      */
1204     function calculateFinalPrice(SaleKindInterface.Side side, SaleKindInterface.SaleKind saleKind, uint basePrice, uint extra, uint listingTime, uint expirationTime)
1205         public
1206         view
1207         returns (uint)
1208     {
1209         return SaleKindInterface.calculateFinalPrice(side, saleKind, basePrice, extra, listingTime, expirationTime);
1210     }
1211 
1212     /**
1213      * @dev Call hashOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1214      */
1215     function hashOrder_(
1216         address[7] addrs,
1217         uint[9] uints,
1218         FeeMethod feeMethod,
1219         SaleKindInterface.Side side,
1220         SaleKindInterface.SaleKind saleKind,
1221         AuthenticatedProxy.HowToCall howToCall,
1222         bytes calldata,
1223         bytes replacementPattern,
1224         bytes staticExtradata)
1225         public
1226         view
1227         returns (bytes32)
1228     {
1229         return hashOrder(
1230           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]),
1231           nonces[addrs[1]]
1232         );
1233     }
1234 
1235     /**
1236      * @dev Call hashToSign - Solidity ABI encoding limitation workaround, hopefully temporary.
1237      */
1238     function hashToSign_(
1239         address[7] addrs,
1240         uint[9] uints,
1241         FeeMethod feeMethod,
1242         SaleKindInterface.Side side,
1243         SaleKindInterface.SaleKind saleKind,
1244         AuthenticatedProxy.HowToCall howToCall,
1245         bytes calldata,
1246         bytes replacementPattern,
1247         bytes staticExtradata)
1248         public
1249         view
1250         returns (bytes32)
1251     {
1252         return hashToSign(
1253           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]),
1254           nonces[addrs[1]]
1255         );
1256     }
1257 
1258     /**
1259      * @dev Call validateOrderParameters - Solidity ABI encoding limitation workaround, hopefully temporary.
1260      */
1261     function validateOrderParameters_ (
1262         address[7] addrs,
1263         uint[9] uints,
1264         FeeMethod feeMethod,
1265         SaleKindInterface.Side side,
1266         SaleKindInterface.SaleKind saleKind,
1267         AuthenticatedProxy.HowToCall howToCall,
1268         bytes calldata,
1269         bytes replacementPattern,
1270         bytes staticExtradata)
1271         view
1272         public
1273         returns (bool)
1274     {
1275         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1276         return validateOrderParameters(
1277           order
1278         );
1279     }
1280 
1281     /**
1282      * @dev Call validateOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1283      */
1284     function validateOrder_ (
1285         address[7] addrs,
1286         uint[9] uints,
1287         FeeMethod feeMethod,
1288         SaleKindInterface.Side side,
1289         SaleKindInterface.SaleKind saleKind,
1290         AuthenticatedProxy.HowToCall howToCall,
1291         bytes calldata,
1292         bytes replacementPattern,
1293         bytes staticExtradata,
1294         uint8 v,
1295         bytes32 r,
1296         bytes32 s)
1297         view
1298         public
1299         returns (bool)
1300     {
1301         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1302         return validateOrder(
1303           hashToSign(order, nonces[order.maker]),
1304           order,
1305           Sig(v, r, s)
1306         );
1307     }
1308 
1309     /**
1310      * @dev Call approveOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1311      */
1312     function approveOrder_ (
1313         address[7] addrs,
1314         uint[9] uints,
1315         FeeMethod feeMethod,
1316         SaleKindInterface.Side side,
1317         SaleKindInterface.SaleKind saleKind,
1318         AuthenticatedProxy.HowToCall howToCall,
1319         bytes calldata,
1320         bytes replacementPattern,
1321         bytes staticExtradata,
1322         bool orderbookInclusionDesired)
1323         public
1324     {
1325         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1326         return approveOrder(order, orderbookInclusionDesired);
1327     }
1328 
1329     /**
1330      * @dev Call cancelOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
1331      */
1332     function cancelOrder_(
1333         address[7] addrs,
1334         uint[9] uints,
1335         FeeMethod feeMethod,
1336         SaleKindInterface.Side side,
1337         SaleKindInterface.SaleKind saleKind,
1338         AuthenticatedProxy.HowToCall howToCall,
1339         bytes calldata,
1340         bytes replacementPattern,
1341         bytes staticExtradata,
1342         uint8 v,
1343         bytes32 r,
1344         bytes32 s)
1345         public
1346     {
1347         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1348         return cancelOrder(
1349           order,
1350           Sig(v, r, s),
1351           nonces[order.maker]
1352         );
1353     }
1354 
1355     /**
1356      * @dev Call cancelOrder, supplying a specific nonce — enables cancelling orders
1357      that were signed with nonces greater than the current nonce.
1358      */
1359     function cancelOrderWithNonce_(
1360         address[7] addrs,
1361         uint[9] uints,
1362         FeeMethod feeMethod,
1363         SaleKindInterface.Side side,
1364         SaleKindInterface.SaleKind saleKind,
1365         AuthenticatedProxy.HowToCall howToCall,
1366         bytes calldata,
1367         bytes replacementPattern,
1368         bytes staticExtradata,
1369         uint8 v,
1370         bytes32 r,
1371         bytes32 s,
1372         uint nonce)
1373         public
1374     {
1375         Order memory order = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1376         return cancelOrder(
1377           order,
1378           Sig(v, r, s),
1379           nonce
1380         );
1381     }
1382 
1383     /**
1384      * @dev Call calculateCurrentPrice - Solidity ABI encoding limitation workaround, hopefully temporary.
1385      */
1386     function calculateCurrentPrice_(
1387         address[7] addrs,
1388         uint[9] uints,
1389         FeeMethod feeMethod,
1390         SaleKindInterface.Side side,
1391         SaleKindInterface.SaleKind saleKind,
1392         AuthenticatedProxy.HowToCall howToCall,
1393         bytes calldata,
1394         bytes replacementPattern,
1395         bytes staticExtradata)
1396         public
1397         view
1398         returns (uint)
1399     {
1400         return calculateCurrentPrice(
1401           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], feeMethod, side, saleKind, addrs[4], howToCall, calldata, replacementPattern, addrs[5], staticExtradata, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8])
1402         );
1403     }
1404 
1405     /**
1406      * @dev Call ordersCanMatch - Solidity ABI encoding limitation workaround, hopefully temporary.
1407      */
1408     function ordersCanMatch_(
1409         address[14] addrs,
1410         uint[18] uints,
1411         uint8[8] feeMethodsSidesKindsHowToCalls,
1412         bytes calldataBuy,
1413         bytes calldataSell,
1414         bytes replacementPatternBuy,
1415         bytes replacementPatternSell,
1416         bytes staticExtradataBuy,
1417         bytes staticExtradataSell)
1418         public
1419         view
1420         returns (bool)
1421     {
1422         Order memory buy = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1423         Order memory sell = Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17]);
1424         return ordersCanMatch(
1425           buy,
1426           sell
1427         );
1428     }
1429 
1430     /**
1431      * @dev Return whether or not two orders' calldata specifications can match
1432      * @param buyCalldata Buy-side order calldata
1433      * @param buyReplacementPattern Buy-side order calldata replacement mask
1434      * @param sellCalldata Sell-side order calldata
1435      * @param sellReplacementPattern Sell-side order calldata replacement mask
1436      * @return Whether the orders' calldata can be matched
1437      */
1438     function orderCalldataCanMatch(bytes buyCalldata, bytes buyReplacementPattern, bytes sellCalldata, bytes sellReplacementPattern)
1439         public
1440         pure
1441         returns (bool)
1442     {
1443         if (buyReplacementPattern.length > 0) {
1444           ArrayUtils.guardedArrayReplace(buyCalldata, sellCalldata, buyReplacementPattern);
1445         }
1446         if (sellReplacementPattern.length > 0) {
1447           ArrayUtils.guardedArrayReplace(sellCalldata, buyCalldata, sellReplacementPattern);
1448         }
1449         return ArrayUtils.arrayEq(buyCalldata, sellCalldata);
1450     }
1451 
1452     /**
1453      * @dev Call calculateMatchPrice - Solidity ABI encoding limitation workaround, hopefully temporary.
1454      */
1455     function calculateMatchPrice_(
1456         address[14] addrs,
1457         uint[18] uints,
1458         uint8[8] feeMethodsSidesKindsHowToCalls,
1459         bytes calldataBuy,
1460         bytes calldataSell,
1461         bytes replacementPatternBuy,
1462         bytes replacementPatternSell,
1463         bytes staticExtradataBuy,
1464         bytes staticExtradataSell)
1465         public
1466         view
1467         returns (uint)
1468     {
1469         Order memory buy = Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]);
1470         Order memory sell = Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17]);
1471         return calculateMatchPrice(
1472           buy,
1473           sell
1474         );
1475     }
1476 
1477     /**
1478      * @dev Call atomicMatch - Solidity ABI encoding limitation workaround, hopefully temporary.
1479      */
1480     function atomicMatch_(
1481         address[14] addrs,
1482         uint[18] uints,
1483         uint8[8] feeMethodsSidesKindsHowToCalls,
1484         bytes calldataBuy,
1485         bytes calldataSell,
1486         bytes replacementPatternBuy,
1487         bytes replacementPatternSell,
1488         bytes staticExtradataBuy,
1489         bytes staticExtradataSell,
1490         uint8[2] vs,
1491         bytes32[5] rssMetadata)
1492         public
1493         payable
1494     {
1495 
1496         return atomicMatch(
1497           Order(addrs[0], addrs[1], addrs[2], uints[0], uints[1], uints[2], uints[3], addrs[3], FeeMethod(feeMethodsSidesKindsHowToCalls[0]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[1]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[2]), addrs[4], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[3]), calldataBuy, replacementPatternBuy, addrs[5], staticExtradataBuy, ERC20(addrs[6]), uints[4], uints[5], uints[6], uints[7], uints[8]),
1498           Sig(vs[0], rssMetadata[0], rssMetadata[1]),
1499           Order(addrs[7], addrs[8], addrs[9], uints[9], uints[10], uints[11], uints[12], addrs[10], FeeMethod(feeMethodsSidesKindsHowToCalls[4]), SaleKindInterface.Side(feeMethodsSidesKindsHowToCalls[5]), SaleKindInterface.SaleKind(feeMethodsSidesKindsHowToCalls[6]), addrs[11], AuthenticatedProxy.HowToCall(feeMethodsSidesKindsHowToCalls[7]), calldataSell, replacementPatternSell, addrs[12], staticExtradataSell, ERC20(addrs[13]), uints[13], uints[14], uints[15], uints[16], uints[17]),
1500           Sig(vs[1], rssMetadata[2], rssMetadata[3]),
1501           rssMetadata[4]
1502         );
1503     }
1504 
1505 }
1506 
1507 contract WyvernExchangeWithBulkCancellations is Exchange {
1508     string public constant codename = "Bulk Smash";
1509 
1510     /**
1511      * @dev Initialize a WyvernExchange instance
1512      * @param registryAddress Address of the registry instance which this Exchange instance will use
1513      * @param tokenAddress Address of the token used for protocol fees
1514      */
1515     constructor (ProxyRegistry registryAddress, TokenTransferProxy tokenTransferProxyAddress, ERC20 tokenAddress, address protocolFeeAddress) public {
1516         registry = registryAddress;
1517         tokenTransferProxy = tokenTransferProxyAddress;
1518         exchangeToken = tokenAddress;
1519         protocolFeeRecipient = protocolFeeAddress;
1520         owner = msg.sender;
1521     }
1522 }
1523 
1524 library SaleKindInterface {
1525 
1526     /**
1527      * Side: buy or sell.
1528      */
1529     enum Side { Buy, Sell }
1530 
1531     /**
1532      * Currently supported kinds of sale: fixed price, Dutch auction.
1533      * English auctions cannot be supported without stronger escrow guarantees.
1534      * Future interesting options: Vickrey auction, nonlinear Dutch auctions.
1535      */
1536     enum SaleKind { FixedPrice, DutchAuction }
1537 
1538     /**
1539      * @dev Check whether the parameters of a sale are valid
1540      * @param saleKind Kind of sale
1541      * @param expirationTime Order expiration time
1542      * @return Whether the parameters were valid
1543      */
1544     function validateParameters(SaleKind saleKind, uint expirationTime)
1545         pure
1546         internal
1547         returns (bool)
1548     {
1549         /* Auctions must have a set expiration date. */
1550         return (saleKind == SaleKind.FixedPrice || expirationTime > 0);
1551     }
1552 
1553     /**
1554      * @dev Return whether or not an order can be settled
1555      * @dev Precondition: parameters have passed validateParameters
1556      * @param listingTime Order listing time
1557      * @param expirationTime Order expiration time
1558      */
1559     function canSettleOrder(uint listingTime, uint expirationTime)
1560         view
1561         internal
1562         returns (bool)
1563     {
1564         return (listingTime < now) && (expirationTime == 0 || now < expirationTime);
1565     }
1566 
1567     /**
1568      * @dev Calculate the settlement price of an order
1569      * @dev Precondition: parameters have passed validateParameters.
1570      * @param side Order side
1571      * @param saleKind Method of sale
1572      * @param basePrice Order base price
1573      * @param extra Order extra price data
1574      * @param listingTime Order listing time
1575      * @param expirationTime Order expiration time
1576      */
1577     function calculateFinalPrice(Side side, SaleKind saleKind, uint basePrice, uint extra, uint listingTime, uint expirationTime)
1578         view
1579         internal
1580         returns (uint finalPrice)
1581     {
1582         if (saleKind == SaleKind.FixedPrice) {
1583             return basePrice;
1584         } else if (saleKind == SaleKind.DutchAuction) {
1585             uint diff = SafeMath.div(SafeMath.mul(extra, SafeMath.sub(now, listingTime)), SafeMath.sub(expirationTime, listingTime));
1586             if (side == Side.Sell) {
1587                 /* Sell-side - start price: basePrice. End price: basePrice - extra. */
1588                 return SafeMath.sub(basePrice, diff);
1589             } else {
1590                 /* Buy-side - start price: basePrice. End price: basePrice + extra. */
1591                 return SafeMath.add(basePrice, diff);
1592             }
1593         }
1594     }
1595 
1596 }
1597 
1598 contract ProxyRegistry is Ownable {
1599 
1600     /* DelegateProxy implementation contract. Must be initialized. */
1601     address public delegateProxyImplementation;
1602 
1603     /* Authenticated proxies by user. */
1604     mapping(address => OwnableDelegateProxy) public proxies;
1605 
1606     /* Contracts pending access. */
1607     mapping(address => uint) public pending;
1608 
1609     /* Contracts allowed to call those proxies. */
1610     mapping(address => bool) public contracts;
1611 
1612     /* Delay period for adding an authenticated contract.
1613        This mitigates a particular class of potential attack on the Wyvern DAO (which owns this registry) - if at any point the value of assets held by proxy contracts exceeded the value of half the WYV supply (votes in the DAO),
1614        a malicious but rational attacker could buy half the Wyvern and grant themselves access to all the proxy contracts. A delay period renders this attack nonthreatening - given two weeks, if that happened, users would have
1615        plenty of time to notice and transfer their assets.
1616     */
1617     uint public DELAY_PERIOD = 2 weeks;
1618 
1619     /**
1620      * Start the process to enable access for specified contract. Subject to delay period.
1621      *
1622      * @dev ProxyRegistry owner only
1623      * @param addr Address to which to grant permissions
1624      */
1625     function startGrantAuthentication (address addr)
1626         public
1627         onlyOwner
1628     {
1629         require(!contracts[addr] && pending[addr] == 0);
1630         pending[addr] = now;
1631     }
1632 
1633     /**
1634      * End the process to nable access for specified contract after delay period has passed.
1635      *
1636      * @dev ProxyRegistry owner only
1637      * @param addr Address to which to grant permissions
1638      */
1639     function endGrantAuthentication (address addr)
1640         public
1641         onlyOwner
1642     {
1643         require(!contracts[addr] && pending[addr] != 0 && ((pending[addr] + DELAY_PERIOD) < now));
1644         pending[addr] = 0;
1645         contracts[addr] = true;
1646     }
1647 
1648     /**
1649      * Revoke access for specified contract. Can be done instantly.
1650      *
1651      * @dev ProxyRegistry owner only
1652      * @param addr Address of which to revoke permissions
1653      */
1654     function revokeAuthentication (address addr)
1655         public
1656         onlyOwner
1657     {
1658         contracts[addr] = false;
1659     }
1660 
1661     /**
1662      * Register a proxy contract with this registry
1663      *
1664      * @dev Must be called by the user which the proxy is for, creates a new AuthenticatedProxy
1665      * @return New AuthenticatedProxy contract
1666      */
1667     function registerProxy()
1668         public
1669         returns (OwnableDelegateProxy proxy)
1670     {
1671         require(proxies[msg.sender] == address(0));
1672         proxy = new OwnableDelegateProxy(msg.sender, delegateProxyImplementation, abi.encodeWithSignature("initialize(address,address)", msg.sender, address(this)));
1673         proxies[msg.sender] = proxy;
1674         return proxy;
1675     }
1676 
1677 }
1678 
1679 contract TokenTransferProxy {
1680 
1681     /* Authentication registry. */
1682     ProxyRegistry public registry;
1683 
1684     /**
1685      * Call ERC20 `transferFrom`
1686      *
1687      * @dev Authenticated contract only
1688      * @param token ERC20 token address
1689      * @param from From address
1690      * @param to To address
1691      * @param amount Transfer amount
1692      */
1693     function transferFrom(address token, address from, address to, uint amount)
1694         public
1695         returns (bool)
1696     {
1697         require(registry.contracts(msg.sender));
1698         return ERC20(token).transferFrom(from, to, amount);
1699     }
1700 
1701 }
1702 
1703 contract OwnedUpgradeabilityStorage {
1704 
1705   // Current implementation
1706   address internal _implementation;
1707 
1708   // Owner of the contract
1709   address private _upgradeabilityOwner;
1710 
1711   /**
1712    * @dev Tells the address of the owner
1713    * @return the address of the owner
1714    */
1715   function upgradeabilityOwner() public view returns (address) {
1716     return _upgradeabilityOwner;
1717   }
1718 
1719   /**
1720    * @dev Sets the address of the owner
1721    */
1722   function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
1723     _upgradeabilityOwner = newUpgradeabilityOwner;
1724   }
1725 
1726   /**
1727   * @dev Tells the address of the current implementation
1728   * @return address of the current implementation
1729   */
1730   function implementation() public view returns (address) {
1731     return _implementation;
1732   }
1733 
1734   /**
1735   * @dev Tells the proxy type (EIP 897)
1736   * @return Proxy type, 2 for forwarding proxy
1737   */
1738   function proxyType() public pure returns (uint256 proxyTypeId) {
1739     return 2;
1740   }
1741 }
1742 
1743 contract AuthenticatedProxy is TokenRecipient, OwnedUpgradeabilityStorage {
1744 
1745     /* Whether initialized. */
1746     bool initialized = false;
1747 
1748     /* Address which owns this proxy. */
1749     address public user;
1750 
1751     /* Associated registry with contract authentication information. */
1752     ProxyRegistry public registry;
1753 
1754     /* Whether access has been revoked. */
1755     bool public revoked;
1756 
1757     /* Delegate call could be used to atomically transfer multiple assets owned by the proxy contract with one order. */
1758     enum HowToCall { Call, DelegateCall }
1759 
1760     /* Event fired when the proxy access is revoked or unrevoked. */
1761     event Revoked(bool revoked);
1762 
1763     /**
1764      * Initialize an AuthenticatedProxy
1765      *
1766      * @param addrUser Address of user on whose behalf this proxy will act
1767      * @param addrRegistry Address of ProxyRegistry contract which will manage this proxy
1768      */
1769     function initialize (address addrUser, ProxyRegistry addrRegistry)
1770         public
1771     {
1772         require(!initialized);
1773         initialized = true;
1774         user = addrUser;
1775         registry = addrRegistry;
1776     }
1777 
1778     /**
1779      * Set the revoked flag (allows a user to revoke ProxyRegistry access)
1780      *
1781      * @dev Can be called by the user only
1782      * @param revoke Whether or not to revoke access
1783      */
1784     function setRevoke(bool revoke)
1785         public
1786     {
1787         require(msg.sender == user);
1788         revoked = revoke;
1789         emit Revoked(revoke);
1790     }
1791 
1792     /**
1793      * Execute a message call from the proxy contract
1794      *
1795      * @dev Can be called by the user, or by a contract authorized by the registry as long as the user has not revoked access
1796      * @param dest Address to which the call will be sent
1797      * @param howToCall Which kind of call to make
1798      * @param calldata Calldata to send
1799      * @return Result of the call (success or failure)
1800      */
1801     function proxy(address dest, HowToCall howToCall, bytes calldata)
1802         public
1803         returns (bool result)
1804     {
1805         require(msg.sender == user || (!revoked && registry.contracts(msg.sender)));
1806         if (howToCall == HowToCall.Call) {
1807             result = dest.call(calldata);
1808         } else if (howToCall == HowToCall.DelegateCall) {
1809             result = dest.delegatecall(calldata);
1810         }
1811         return result;
1812     }
1813 
1814     /**
1815      * Execute a message call and assert success
1816      *
1817      * @dev Same functionality as `proxy`, just asserts the return value
1818      * @param dest Address to which the call will be sent
1819      * @param howToCall What kind of call to make
1820      * @param calldata Calldata to send
1821      */
1822     function proxyAssert(address dest, HowToCall howToCall, bytes calldata)
1823         public
1824     {
1825         require(proxy(dest, howToCall, calldata));
1826     }
1827 
1828 }
1829 
1830 contract Proxy {
1831 
1832   /**
1833   * @dev Tells the address of the implementation where every call will be delegated.
1834   * @return address of the implementation to which it will be delegated
1835   */
1836   function implementation() public view returns (address);
1837 
1838   /**
1839   * @dev Tells the type of proxy (EIP 897)
1840   * @return Type of proxy, 2 for upgradeable proxy
1841   */
1842   function proxyType() public pure returns (uint256 proxyTypeId);
1843 
1844   /**
1845   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
1846   * This function will return whatever the implementation call returns
1847   */
1848   function () payable public {
1849     address _impl = implementation();
1850     require(_impl != address(0));
1851 
1852     assembly {
1853       let ptr := mload(0x40)
1854       calldatacopy(ptr, 0, calldatasize)
1855       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
1856       let size := returndatasize
1857       returndatacopy(ptr, 0, size)
1858 
1859       switch result
1860       case 0 { revert(ptr, size) }
1861       default { return(ptr, size) }
1862     }
1863   }
1864 }
1865 
1866 contract OwnedUpgradeabilityProxy is Proxy, OwnedUpgradeabilityStorage {
1867   /**
1868   * @dev Event to show ownership has been transferred
1869   * @param previousOwner representing the address of the previous owner
1870   * @param newOwner representing the address of the new owner
1871   */
1872   event ProxyOwnershipTransferred(address previousOwner, address newOwner);
1873 
1874   /**
1875   * @dev This event will be emitted every time the implementation gets upgraded
1876   * @param implementation representing the address of the upgraded implementation
1877   */
1878   event Upgraded(address indexed implementation);
1879 
1880   /**
1881   * @dev Upgrades the implementation address
1882   * @param implementation representing the address of the new implementation to be set
1883   */
1884   function _upgradeTo(address implementation) internal {
1885     require(_implementation != implementation);
1886     _implementation = implementation;
1887     emit Upgraded(implementation);
1888   }
1889 
1890   /**
1891   * @dev Throws if called by any account other than the owner.
1892   */
1893   modifier onlyProxyOwner() {
1894     require(msg.sender == proxyOwner());
1895     _;
1896   }
1897 
1898   /**
1899    * @dev Tells the address of the proxy owner
1900    * @return the address of the proxy owner
1901    */
1902   function proxyOwner() public view returns (address) {
1903     return upgradeabilityOwner();
1904   }
1905 
1906   /**
1907    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1908    * @param newOwner The address to transfer ownership to.
1909    */
1910   function transferProxyOwnership(address newOwner) public onlyProxyOwner {
1911     require(newOwner != address(0));
1912     emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
1913     setUpgradeabilityOwner(newOwner);
1914   }
1915 
1916   /**
1917    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy.
1918    * @param implementation representing the address of the new implementation to be set.
1919    */
1920   function upgradeTo(address implementation) public onlyProxyOwner {
1921     _upgradeTo(implementation);
1922   }
1923 
1924   /**
1925    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy
1926    * and delegatecall the new implementation for initialization.
1927    * @param implementation representing the address of the new implementation to be set.
1928    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
1929    * signature of the implementation to be called with the needed payload
1930    */
1931   function upgradeToAndCall(address implementation, bytes data) payable public onlyProxyOwner {
1932     upgradeTo(implementation);
1933     require(address(this).delegatecall(data));
1934   }
1935 }
1936 
1937 contract OwnableDelegateProxy is OwnedUpgradeabilityProxy {
1938 
1939     constructor(address owner, address initialImplementation, bytes calldata)
1940         public
1941     {
1942         setUpgradeabilityOwner(owner);
1943         _upgradeTo(initialImplementation);
1944         require(initialImplementation.delegatecall(calldata));
1945     }
1946 
1947 }