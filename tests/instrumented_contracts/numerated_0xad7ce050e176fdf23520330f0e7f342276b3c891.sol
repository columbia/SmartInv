1 // File: contracts/ArrayUtils.sol
2 
3 pragma solidity 0.4.26;
4 
5 library ArrayUtils {
6 
7     /**
8      * Replace bytes in an array with bytes in another array, guarded by a bitmask
9      * Efficiency of this function is a bit unpredictable because of the EVM's word-specific model (arrays under 32 bytes will be slower)
10      *
11      * @dev Mask must be the size of the byte array. A nonzero byte means the byte array can be changed.
12      * @param array The original array
13      * @param desired The target array
14      * @param mask The mask specifying which bits can be changed
15      * @return The updated byte array (the parameter will be modified inplace)
16      */
17     function guardedArrayReplace(bytes memory array, bytes memory desired, bytes memory mask)
18     internal
19     pure
20     {
21         require(array.length == desired.length);
22         require(array.length == mask.length);
23 
24         uint words = array.length / 0x20;
25         uint index = words * 0x20;
26         assert(index / 0x20 == words);
27         uint i;
28 
29         for (i = 0; i < words; i++) {
30             /* Conceptually: array[i] = (!mask[i] && array[i]) || (mask[i] && desired[i]), bitwise in word chunks. */
31             assembly {
32                 let commonIndex := mul(0x20, add(1, i))
33                 let maskValue := mload(add(mask, commonIndex))
34                 mstore(add(array, commonIndex), or(and(not(maskValue), mload(add(array, commonIndex))), and(maskValue, mload(add(desired, commonIndex)))))
35             }
36         }
37 
38         /* Deal with the last section of the byte array. */
39         if (words > 0) {
40             /* This overlaps with bytes already set but is still more efficient than iterating through each of the remaining bytes individually. */
41             i = words;
42             assembly {
43                 let commonIndex := mul(0x20, add(1, i))
44                 let maskValue := mload(add(mask, commonIndex))
45                 mstore(add(array, commonIndex), or(and(not(maskValue), mload(add(array, commonIndex))), and(maskValue, mload(add(desired, commonIndex)))))
46             }
47         } else {
48             /* If the byte array is shorter than a word, we must unfortunately do the whole thing bytewise.
49                (bounds checks could still probably be optimized away in assembly, but this is a rare case) */
50             for (i = index; i < array.length; i++) {
51                 array[i] = ((mask[i] ^ 0xff) & array[i]) | (mask[i] & desired[i]);
52             }
53         }
54     }
55 
56     /**
57      * Test if two arrays are equal
58      * @param a First array
59      * @param b Second array
60      * @return Whether or not all bytes in the arrays are equal
61      */
62     function arrayEq(bytes memory a, bytes memory b)
63     internal
64     pure
65     returns (bool)
66     {
67         return keccak256(a) == keccak256(b);
68     }
69 
70     /**
71      * Unsafe write byte array into a memory location
72      *
73      * @param index Memory location
74      * @param source Byte array to write
75      * @return End memory index
76      */
77     function unsafeWriteBytes(uint index, bytes source)
78     internal
79     pure
80     returns (uint)
81     {
82         if (source.length > 0) {
83             assembly {
84                 let length := mload(source)
85                 let end := add(source, add(0x20, length))
86                 let arrIndex := add(source, 0x20)
87                 let tempIndex := index
88                 for { } eq(lt(arrIndex, end), 1) {
89                     arrIndex := add(arrIndex, 0x20)
90                     tempIndex := add(tempIndex, 0x20)
91                 } {
92                     mstore(tempIndex, mload(arrIndex))
93                 }
94                 index := add(index, length)
95             }
96         }
97         return index;
98     }
99 
100     /**
101      * Unsafe write address into a memory location
102      *
103      * @param index Memory location
104      * @param source Address to write
105      * @return End memory index
106      */
107     function unsafeWriteAddress(uint index, address source)
108     internal
109     pure
110     returns (uint)
111     {
112         uint conv = uint(source) << 0x60;
113         assembly {
114             mstore(index, conv)
115             index := add(index, 0x14)
116         }
117         return index;
118     }
119 
120     /**
121      * Unsafe write address into a memory location using entire word
122      *
123      * @param index Memory location
124      * @param source uint to write
125      * @return End memory index
126      */
127     function unsafeWriteAddressWord(uint index, address source)
128     internal
129     pure
130     returns (uint)
131     {
132         assembly {
133             mstore(index, source)
134             index := add(index, 0x20)
135         }
136         return index;
137     }
138 
139     /**
140      * Unsafe write uint into a memory location
141      *
142      * @param index Memory location
143      * @param source uint to write
144      * @return End memory index
145      */
146     function unsafeWriteUint(uint index, uint source)
147     internal
148     pure
149     returns (uint)
150     {
151         assembly {
152             mstore(index, source)
153             index := add(index, 0x20)
154         }
155         return index;
156     }
157 
158     /**
159      * Unsafe write uint8 into a memory location
160      *
161      * @param index Memory location
162      * @param source uint8 to write
163      * @return End memory index
164      */
165     function unsafeWriteUint8(uint index, uint8 source)
166     internal
167     pure
168     returns (uint)
169     {
170         assembly {
171             mstore8(index, source)
172             index := add(index, 0x1)
173         }
174         return index;
175     }
176 
177     /**
178      * Unsafe write uint8 into a memory location using entire word
179      *
180      * @param index Memory location
181      * @param source uint to write
182      * @return End memory index
183      */
184     function unsafeWriteUint8Word(uint index, uint8 source)
185     internal
186     pure
187     returns (uint)
188     {
189         assembly {
190             mstore(index, source)
191             index := add(index, 0x20)
192         }
193         return index;
194     }
195 
196     /**
197      * Unsafe write bytes32 into a memory location using entire word
198      *
199      * @param index Memory location
200      * @param source uint to write
201      * @return End memory index
202      */
203     function unsafeWriteBytes32(uint index, bytes32 source)
204     internal
205     pure
206     returns (uint)
207     {
208         assembly {
209             mstore(index, source)
210             index := add(index, 0x20)
211         }
212         return index;
213     }
214 }
215 
216 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
217 
218 pragma solidity ^0.4.24;
219 
220 /**
221  * @title ERC20 interface
222  * @dev see https://github.com/ethereum/EIPs/issues/20
223  */
224 interface IERC20 {
225   function totalSupply() external view returns (uint256);
226 
227   function balanceOf(address who) external view returns (uint256);
228 
229   function allowance(address owner, address spender)
230     external view returns (uint256);
231 
232   function transfer(address to, uint256 value) external returns (bool);
233 
234   function approve(address spender, uint256 value)
235     external returns (bool);
236 
237   function transferFrom(address from, address to, uint256 value)
238     external returns (bool);
239 
240   event Transfer(
241     address indexed from,
242     address indexed to,
243     uint256 value
244   );
245 
246   event Approval(
247     address indexed owner,
248     address indexed spender,
249     uint256 value
250   );
251 }
252 
253 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
254 
255 pragma solidity ^0.4.24;
256 
257 /**
258  * @title SafeMath
259  * @dev Math operations with safety checks that revert on error
260  */
261 library SafeMath {
262 
263   /**
264   * @dev Multiplies two numbers, reverts on overflow.
265   */
266   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
267     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
268     // benefit is lost if 'b' is also tested.
269     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
270     if (a == 0) {
271       return 0;
272     }
273 
274     uint256 c = a * b;
275     require(c / a == b);
276 
277     return c;
278   }
279 
280   /**
281   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
282   */
283   function div(uint256 a, uint256 b) internal pure returns (uint256) {
284     require(b > 0); // Solidity only automatically asserts when dividing by 0
285     uint256 c = a / b;
286     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
287 
288     return c;
289   }
290 
291   /**
292   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
293   */
294   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
295     require(b <= a);
296     uint256 c = a - b;
297 
298     return c;
299   }
300 
301   /**
302   * @dev Adds two numbers, reverts on overflow.
303   */
304   function add(uint256 a, uint256 b) internal pure returns (uint256) {
305     uint256 c = a + b;
306     require(c >= a);
307 
308     return c;
309   }
310 
311   /**
312   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
313   * reverts when dividing by zero.
314   */
315   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
316     require(b != 0);
317     return a % b;
318   }
319 }
320 
321 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
322 
323 pragma solidity ^0.4.24;
324 
325 
326 
327 /**
328  * @title SafeERC20
329  * @dev Wrappers around ERC20 operations that throw on failure.
330  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
331  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
332  */
333 library SafeERC20 {
334 
335   using SafeMath for uint256;
336 
337   function safeTransfer(
338     IERC20 token,
339     address to,
340     uint256 value
341   )
342     internal
343   {
344     require(token.transfer(to, value));
345   }
346 
347   function safeTransferFrom(
348     IERC20 token,
349     address from,
350     address to,
351     uint256 value
352   )
353     internal
354   {
355     require(token.transferFrom(from, to, value));
356   }
357 
358   function safeApprove(
359     IERC20 token,
360     address spender,
361     uint256 value
362   )
363     internal
364   {
365     // safeApprove should only be called when setting an initial allowance, 
366     // or when resetting it to zero. To increase and decrease it, use 
367     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
368     require((value == 0) || (token.allowance(address(this), spender) == 0));
369     require(token.approve(spender, value));
370   }
371 
372   function safeIncreaseAllowance(
373     IERC20 token,
374     address spender,
375     uint256 value
376   )
377     internal
378   {
379     uint256 newAllowance = token.allowance(address(this), spender).add(value);
380     require(token.approve(spender, newAllowance));
381   }
382 
383   function safeDecreaseAllowance(
384     IERC20 token,
385     address spender,
386     uint256 value
387   )
388     internal
389   {
390     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
391     require(token.approve(spender, newAllowance));
392   }
393 }
394 
395 // File: contracts/TokenTransferProxy.sol
396 
397 pragma solidity 0.4.26;
398 
399 
400 
401 contract TokenTransferProxy {
402     using SafeERC20 for IERC20;
403 
404     /* Whether initialized. */
405     bool public initialized = false;
406 
407     address public exchangeAddress;
408 
409     function initialize (address _exchangeAddress)
410     public
411     {
412         require(!initialized);
413         initialized = true;
414         exchangeAddress = _exchangeAddress;
415     }
416     /**
417      * Call ERC20 `transferFrom`
418      *
419      * @dev Authenticated contract only
420      * @param token IERC20 token address
421      * @param from From address
422      * @param to To address
423      * @param amount Transfer amount
424      */
425     function transferFrom(address token, address from, address to, uint amount)
426     public
427     returns (bool)
428     {
429         require(msg.sender==exchangeAddress, "not authorized");
430         IERC20(token).safeTransferFrom(from, to, amount);
431         return true;
432     }
433 
434 }
435 
436 // File: contracts/IERC2981.sol
437 
438 pragma solidity 0.4.26;
439 
440 ///
441 /// @dev Interface for the NFT Royalty Standard
442 ///
443 
444 interface IERC2981 {
445     /// @notice Called with the sale price to determine how much royalty
446     //          is owed and to whom.
447     /// @param _tokenId - the NFT asset queried for royalty information
448     /// @param _salePrice - the sale price of the NFT asset specified by _tokenId
449     /// @return receiver - address of who should be sent the royalty payment
450     /// @return royaltyAmount - the royalty payment amount for _salePrice
451     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount);
452 }
453 
454 // File: contracts/IRoyaltyRegisterHub.sol
455 
456 pragma solidity 0.4.26;
457 
458 ///
459 /// @dev Interface for the NFT Royalty Standard
460 ///
461 
462 interface IRoyaltyRegisterHub {
463     /// @notice Called with the sale price to determine how much royalty
464     //          is owed and to whom.
465     /// @param _nftAddress - the NFT contract address
466     /// @param _salePrice - the sale price of the NFT asset specified by _tokenId
467     /// @return receiver - address of who should be sent the royalty payment
468     /// @return royaltyAmount - the royalty payment amount for _salePrice
469     function royaltyInfo(address _nftAddress, uint256 _salePrice)  external view returns (address receiver, uint256 royaltyAmount);
470 }
471 
472 // File: contracts/ReentrancyGuarded.sol
473 
474 pragma solidity 0.4.26;
475 
476 contract ReentrancyGuarded {
477 
478     bool reentrancyLock = false;
479 
480     /* Prevent a contract function from being reentrant-called. */
481     modifier reentrancyGuard {
482         if (reentrancyLock) {
483             revert();
484         }
485         reentrancyLock = true;
486         _;
487         reentrancyLock = false;
488     }
489 
490 }
491 
492 // File: contracts/Ownable.sol
493 
494 pragma solidity 0.4.26;
495 
496 contract Ownable {
497     address public owner;
498 
499     event OwnershipRenounced(address indexed previousOwner);
500     event OwnershipTransferred(
501         address indexed previousOwner,
502         address indexed newOwner
503     );
504 
505 
506     /**
507      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
508      * account.
509      */
510     constructor() public {
511         owner = msg.sender;
512     }
513 
514     /**
515      * @dev Throws if called by any account other than the owner.
516      */
517     modifier onlyOwner() {
518         require(msg.sender == owner);
519         _;
520     }
521 
522     /**
523      * @dev Allows the current owner to transfer control of the contract to a newOwner.
524      * @param newOwner The address to transfer ownership to.
525      */
526     function transferOwnership(address newOwner) public onlyOwner {
527         require(newOwner != address(0));
528         emit OwnershipTransferred(owner, newOwner);
529         owner = newOwner;
530     }
531 
532     /**
533      * @dev Allows the current owner to relinquish control of the contract.
534      */
535     function renounceOwnership() public onlyOwner {
536         emit OwnershipRenounced(owner);
537         owner = address(0);
538     }
539 }
540 
541 // File: contracts/Governable.sol
542 
543 pragma solidity 0.4.26;
544 
545 contract Governable {
546     address public governor;
547     address public pendingGovernor;
548 
549     event GovernanceTransferred(
550         address indexed previousGovernor,
551         address indexed newGovernor
552     );
553     event NewPendingGovernor(address indexed newPendingGovernor);
554 
555 
556     /**
557      * @dev The Governable constructor sets the original `governor` of the contract to the sender
558      * account.
559      */
560     constructor() public {
561         governor = msg.sender;
562     }
563 
564     /**
565      * @dev Throws if called by any account other than the governor.
566      */
567     modifier onlyGovernor() {
568         require(msg.sender == governor);
569         _;
570     }
571 
572     function acceptGovernance() external {
573         require(msg.sender == pendingGovernor, "acceptGovernance: Call must come from pendingGovernor.");
574         address previousGovernor = governor;
575         governor = msg.sender;
576         pendingGovernor = address(0);
577 
578         emit GovernanceTransferred(previousGovernor, governor);
579     }
580 
581     function setPendingGovernor(address pendingGovernor_) external {
582         require(msg.sender == governor, "setPendingGovernor: Call must come from governor.");
583         pendingGovernor = pendingGovernor_;
584 
585         emit NewPendingGovernor(pendingGovernor);
586     }
587 }
588 
589 // File: contracts/SaleKindInterface.sol
590 
591 pragma solidity 0.4.26;
592 
593 
594 library SaleKindInterface {
595 
596     /**
597      * Side: buy or sell.
598      */
599     enum Side { Buy, Sell }
600 
601     /**
602      * Currently supported kinds of sale: fixed price, Dutch auction.
603      * English auctions cannot be supported without stronger escrow guarantees.
604      * Future interesting options: Vickrey auction, nonlinear Dutch auctions.
605      */
606     enum SaleKind { FixedPrice, DutchAuction }
607 
608     /**
609      * @dev Check whether the parameters of a sale are valid
610      * @param saleKind Kind of sale
611      * @param expirationTime Order expiration time
612      * @return Whether the parameters were valid
613      */
614     function validateParameters(SaleKind saleKind, uint expirationTime)
615     pure
616     internal
617     returns (bool)
618     {
619         /* Auctions must have a set expiration date. */
620         return (saleKind == SaleKind.FixedPrice || expirationTime > 0);
621     }
622 
623     /**
624      * @dev Return whether or not an order can be settled
625      * @dev Precondition: parameters have passed validateParameters
626      * @param listingTime Order listing time
627      * @param expirationTime Order expiration time
628      */
629     function canSettleOrder(uint listingTime, uint expirationTime)
630     view
631     internal
632     returns (bool)
633     {
634         return (listingTime < now) && (expirationTime == 0 || now < expirationTime);
635     }
636 
637     /**
638      * @dev Calculate the settlement price of an order
639      * @dev Precondition: parameters have passed validateParameters.
640      * @param side Order side
641      * @param saleKind Method of sale
642      * @param basePrice Order base price
643      * @param extra Order extra price data
644      * @param listingTime Order listing time
645      * @param expirationTime Order expiration time
646      */
647     function calculateFinalPrice(Side side, SaleKind saleKind, uint basePrice, uint extra, uint listingTime, uint expirationTime)
648     view
649     internal
650     returns (uint finalPrice)
651     {
652         if (saleKind == SaleKind.FixedPrice) {
653             return basePrice;
654         } else if (saleKind == SaleKind.DutchAuction) {
655             uint diff = SafeMath.div(SafeMath.mul(extra, SafeMath.sub(now, listingTime)), SafeMath.sub(expirationTime, listingTime));
656             if (side == Side.Sell) {
657                 /* Sell-side - start price: basePrice. End price: basePrice - extra. */
658                 return SafeMath.sub(basePrice, diff);
659             } else {
660                 /* Buy-side - start price: basePrice. End price: basePrice + extra. */
661                 return SafeMath.add(basePrice, diff);
662             }
663         }
664     }
665 
666 }
667 
668 // File: contracts/ExchangeCore.sol
669 
670 pragma solidity 0.4.26;
671 
672 
673 
674 
675 
676 
677 
678 
679 
680 contract ExchangeCore is ReentrancyGuarded, Ownable, Governable {
681     string public constant name = "NiftyConnect Exchange Contract";
682     string public constant version = "1.0";
683 
684     // NOTE: these hashes are derived and verified in the constructor.
685     bytes32 private constant _EIP_712_DOMAIN_TYPEHASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
686     bytes32 private constant _NAME_HASH = 0x97b3fae253daa304aa40063e4f71c3efec8d260848d7379fc623e35f84c73f47;
687     bytes32 private constant _VERSION_HASH = 0xe6bbd6277e1bf288eed5e8d1780f9a50b239e86b153736bceebccf4ea79d90b3;
688     bytes32 private constant _ORDER_TYPEHASH = 0xf446866267029076a71bb126e250b9480cd4ac2699baa745a582b10b361ec951;
689 
690     bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a; // bytes4(keccak256("royaltyInfo(uint256,uint256)"));
691     bytes4 private constant _EIP_165_SUPPORT_INTERFACE = 0x01ffc9a7; // bytes4(keccak256("supportsInterface(bytes4)"));
692 
693     //    // NOTE: chainId opcode is not supported in solidiy 0.4.x; here we hardcode as 56.
694     // In order to protect against orders that are replayable across forked chains,
695     // either the solidity version needs to be bumped up or it needs to be retrieved
696     // from another contract.
697     uint256 private constant _CHAIN_ID = 1;
698 
699     // Note: the domain separator is derived and verified in the constructor. */
700     bytes32 public constant DOMAIN_SEPARATOR = 0x048b125515112cdaed03d1edbee453f1de399178750917e49ce82b75444d7a21;
701 
702     uint256 public constant MAXIMUM_EXCHANGE_RATE = 500; //5%
703 
704     /* Token transfer proxy. */
705     TokenTransferProxy public tokenTransferProxy;
706 
707     /* Cancelled / finalized orders, by hash. */
708     mapping(bytes32 => bool) public cancelledOrFinalized;
709 
710     /* Orders verified by on-chain approval (alternative to ECDSA signatures so that smart contracts can place orders directly). */
711     /* Note that the maker's nonce at the time of approval **plus one** is stored in the mapping. */
712     mapping(bytes32 => uint256) private _approvedOrdersByNonce;
713 
714     /* Track per-maker nonces that can be incremented by the maker to cancel orders in bulk. */
715     // The current nonce for the maker represents the only valid nonce that can be signed by the maker
716     // If a signature was signed with a nonce that's different from the one stored in nonces, it
717     // will fail validation.
718     mapping(address => uint256) public nonces;
719 
720     /* Required protocol taker fee, in basis points. Paid to takerRelayerFeeRecipient, makerRelayerFeeRecipient and protocol owner */
721     /* Initial rate 2% */
722     uint public exchangeFeeRate = 0;
723 
724     /* Share of exchangeFee which will be paid to takerRelayerFeeRecipient, in basis points. */
725     /* Initial share 15% */
726     uint public takerRelayerFeeShare = 1500;
727 
728     /* Share of exchangeFee which will be paid to makerRelayerFeeRecipient, in basis points. */
729     /* Initial share 80% */
730     uint public makerRelayerFeeShare = 8000;
731 
732     /* Share of exchangeFee which will be paid to protocolFeeRecipient, in basis points. */
733     /* Initial share 5% */
734     uint public protocolFeeShare = 500;
735 
736     /* Recipient of protocol fees. */
737     address public protocolFeeRecipient;
738 
739     /* Inverse basis point. */
740     uint public constant INVERSE_BASIS_POINT = 10000;
741 
742     /*  */
743     address public merkleValidatorContract;
744 
745     /*  */
746     address public royaltyRegisterHub;
747 
748     /* An order on the exchange. */
749     struct Order {
750         /* Exchange address, intended as a versioning mechanism. */
751         address exchange;
752         /* Order maker address. */
753         address maker;
754         /* Order taker address, if specified. */
755         address taker;
756         /*  Order fee recipient or zero address for taker order. */
757         address makerRelayerFeeRecipient;
758         /*  Taker order fee recipient */
759         address takerRelayerFeeRecipient;
760         /* Side (buy/sell). */
761         SaleKindInterface.Side side;
762         /* Kind of sale. */
763         SaleKindInterface.SaleKind saleKind;
764         /* nftAddress. */
765         address nftAddress;
766         /* nft tokenId. */
767         uint tokenId;
768         /* Calldata. */
769         bytes calldata;
770         /* Calldata replacement pattern, or an empty byte array for no replacement. */
771         bytes replacementPattern;
772         /* Static call target, zero-address for no static call. */
773         address staticTarget;
774         /* Static call extra data. */
775         bytes staticExtradata;
776         /* Token used to pay for the order, or the zero-address as a sentinel value for Ether. */
777         address paymentToken;
778         /* Base price of the order (in paymentTokens). */
779         uint basePrice;
780         /* Auction extra parameter - minimum bid increment for English auctions, starting/ending price difference. */
781         uint extra;
782         /* Listing timestamp. */
783         uint listingTime;
784         /* Expiration timestamp - 0 for no expiry. */
785         uint expirationTime;
786         /* Order salt, used to prevent duplicate hashes. */
787         uint salt;
788         /* NOTE: uint nonce is an additional component of the order but is read from storage */
789     }
790 
791     event OrderApprovedPartOne    (bytes32 indexed hash, address exchange, address indexed maker, address taker, address indexed makerRelayerFeeRecipient, SaleKindInterface.Side side, SaleKindInterface.SaleKind saleKind, address nftAddress, uint256 tokenId, bytes32 ipfsHash);
792     event OrderApprovedPartTwo    (bytes32 indexed hash, bytes calldata, bytes replacementPattern, address staticTarget, bytes staticExtradata, address paymentToken, uint basePrice, uint extra, uint listingTime, uint expirationTime, uint salt);
793     event OrderCancelled          (bytes32 indexed hash);
794     event OrdersMatched           (bytes32 buyHash, bytes32 sellHash, address indexed maker, address indexed taker, address makerRelayerFeeRecipient, address takerRelayerFeeRecipient, uint price, bytes32 indexed metadata);
795     event NonceIncremented        (address indexed maker, uint newNonce);
796 
797     constructor () public {
798         require(keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)") == _EIP_712_DOMAIN_TYPEHASH);
799         require(keccak256(bytes(name)) == _NAME_HASH);
800         require(keccak256(bytes(version)) == _VERSION_HASH);
801         require(keccak256("Order(address exchange,address maker,address taker,address makerRelayerFeeRecipient,address takerRelayerFeeRecipient,uint8 side,uint8 saleKind,address nftAddress,uint tokenId,bytes32 merkleRoot,bytes calldata,bytes replacementPattern,address staticTarget,bytes staticExtradata,address paymentToken,uint256 basePrice,uint256 extra,uint256 listingTime,uint256 expirationTime,uint256 salt,uint256 nonce)") == _ORDER_TYPEHASH);
802         require(DOMAIN_SEPARATOR == _deriveDomainSeparator());
803     }
804 
805     /**
806      * @dev Derive the domain separator for EIP-712 signatures.
807      * @return The domain separator.
808      */
809     function _deriveDomainSeparator() private view returns (bytes32) {
810         return keccak256(
811             abi.encode(
812             _EIP_712_DOMAIN_TYPEHASH, // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
813             _NAME_HASH, // keccak256("NiftyConnect Exchange Contract")
814             _VERSION_HASH, // keccak256(bytes("1.0"))
815             _CHAIN_ID,
816             address(this)
817         )); // NOTE: this is fixed, need to use solidity 0.5+ or make external call to support!
818     }
819 
820     function checkRoyalties(address _contract) internal returns (bool) {
821         bool success;
822         bytes memory data = abi.encodeWithSelector(_EIP_165_SUPPORT_INTERFACE, _INTERFACE_ID_ERC2981);
823         bytes memory result = new bytes(32);
824         assembly {
825             success := call(
826                 gas,            // gas remaining
827                 _contract,      // destination address
828                 0,              // no ether
829                 add(data, 32),  // input buffer (starts after the first 32 bytes in the `data` array)
830                 mload(data),    // input length (loaded from the first 32 bytes in the `data` array)
831                 result,         // output buffer
832                 32              // output length
833             )
834         }
835         if (!success) {
836             return false;
837         }
838         bool supportERC2981;
839         assembly {
840             supportERC2981 := mload(result)
841         }
842         return supportERC2981;
843     }
844 
845     /**
846      * Increment a particular maker's nonce, thereby invalidating all orders that were not signed
847      * with the original nonce.
848      */
849     function incrementNonce() external {
850         uint newNonce = ++nonces[msg.sender];
851         emit NonceIncremented(msg.sender, newNonce);
852     }
853 
854     /**
855      * @dev Change the exchange fee rate
856      * @param newExchangeFeeRate New fee to set in basis points
857      */
858     function changeExchangeFeeRate(uint newExchangeFeeRate)
859     public
860     onlyGovernor
861     {
862         require(newExchangeFeeRate<=MAXIMUM_EXCHANGE_RATE, "invalid exchange fee rate");
863         exchangeFeeRate = newExchangeFeeRate;
864     }
865 
866     /**
867      * @dev Change the taker fee paid to the taker relayer (owner only)
868      * @param newTakerRelayerFeeShare New fee to set in basis points
869      * @param newMakerRelayerFeeShare New fee to set in basis points
870      * @param newProtocolFeeShare New fee to set in basis points
871      */
872     function changeTakerRelayerFeeShare(uint newTakerRelayerFeeShare, uint newMakerRelayerFeeShare, uint newProtocolFeeShare)
873     public
874     onlyGovernor
875     {
876         require(SafeMath.add(SafeMath.add(newTakerRelayerFeeShare, newMakerRelayerFeeShare), newProtocolFeeShare) == INVERSE_BASIS_POINT, "invalid new fee share");
877         takerRelayerFeeShare = newTakerRelayerFeeShare;
878         makerRelayerFeeShare = newMakerRelayerFeeShare;
879         protocolFeeShare = newProtocolFeeShare;
880     }
881 
882     /**
883      * @dev Change the protocol fee recipient (owner only)
884      * @param newProtocolFeeRecipient New protocol fee recipient address
885      */
886     function changeProtocolFeeRecipient(address newProtocolFeeRecipient)
887     public
888     onlyOwner
889     {
890         protocolFeeRecipient = newProtocolFeeRecipient;
891     }
892 
893     /**
894      * @dev Transfer tokens
895      * @param token Token to transfer
896      * @param from Address to charge fees
897      * @param to Address to receive fees
898      * @param amount Amount of protocol tokens to charge
899      */
900     function transferTokens(address token, address from, address to, uint amount)
901     internal
902     {
903         if (amount > 0) {
904             require(tokenTransferProxy.transferFrom(token, from, to, amount));
905         }
906     }
907 
908     /**
909      * @dev Execute a STATICCALL (introduced with Ethereum Metropolis, non-state-modifying external call)
910      * @param target Contract to call
911      * @param calldata Calldata (appended to extradata)
912      * @param extradata Base data for STATICCALL (probably function selector and argument encoding)
913      * @return The result of the call (success or failure)
914      */
915     function staticCall(address target, bytes memory calldata, bytes memory extradata)
916     public
917     view
918     returns (bool result)
919     {
920         bytes memory combined = new bytes(calldata.length + extradata.length);
921         uint index;
922         assembly {
923             index := add(combined, 0x20)
924         }
925         index = ArrayUtils.unsafeWriteBytes(index, extradata);
926         ArrayUtils.unsafeWriteBytes(index, calldata);
927         assembly {
928             result := staticcall(gas, target, add(combined, 0x20), mload(combined), mload(0x40), 0)
929         }
930         return result;
931     }
932 
933     /**
934      * @dev Hash an order, returning the canonical EIP-712 order hash without the domain separator
935      * @param order Order to hash
936      * @param nonce maker nonce to hash
937      * @return Hash of order
938      */
939     function hashOrder(Order memory order, uint nonce)
940     internal
941     pure
942     returns (bytes32 hash)
943     {
944         /* Unfortunately abi.encodePacked doesn't work here, stack size constraints. */
945         uint size = 672;
946         bytes memory array = new bytes(size);
947         uint index;
948         assembly {
949             index := add(array, 0x20)
950         }
951         index = ArrayUtils.unsafeWriteBytes32(index, _ORDER_TYPEHASH);
952         index = ArrayUtils.unsafeWriteAddressWord(index, order.exchange);
953         index = ArrayUtils.unsafeWriteAddressWord(index, order.maker);
954         index = ArrayUtils.unsafeWriteAddressWord(index, order.taker);
955         index = ArrayUtils.unsafeWriteAddressWord(index, order.makerRelayerFeeRecipient);
956         index = ArrayUtils.unsafeWriteAddressWord(index, order.takerRelayerFeeRecipient);
957         index = ArrayUtils.unsafeWriteUint8Word(index, uint8(order.side));
958         index = ArrayUtils.unsafeWriteUint8Word(index, uint8(order.saleKind));
959         index = ArrayUtils.unsafeWriteAddressWord(index, order.nftAddress);
960         index = ArrayUtils.unsafeWriteUint(index, order.tokenId);
961         index = ArrayUtils.unsafeWriteBytes32(index, keccak256(order.calldata));
962         index = ArrayUtils.unsafeWriteBytes32(index, keccak256(order.replacementPattern));
963         index = ArrayUtils.unsafeWriteAddressWord(index, order.staticTarget);
964         index = ArrayUtils.unsafeWriteBytes32(index, keccak256(order.staticExtradata));
965         index = ArrayUtils.unsafeWriteAddressWord(index, order.paymentToken);
966         index = ArrayUtils.unsafeWriteUint(index, order.basePrice);
967         index = ArrayUtils.unsafeWriteUint(index, order.extra);
968         index = ArrayUtils.unsafeWriteUint(index, order.listingTime);
969         index = ArrayUtils.unsafeWriteUint(index, order.expirationTime);
970         index = ArrayUtils.unsafeWriteUint(index, order.salt);
971         index = ArrayUtils.unsafeWriteUint(index, nonce);
972         assembly {
973             hash := keccak256(add(array, 0x20), size)
974         }
975         return hash;
976     }
977 
978     /**
979      * @dev Hash an order, returning the hash that a client must sign via EIP-712 including the message prefix
980      * @param order Order to hash
981      * @param nonce Nonce to hash
982      * @return Hash of message prefix and order hash per Ethereum format
983      */
984     function hashToSign(Order memory order, uint nonce)
985     internal
986     pure
987     returns (bytes32)
988     {
989         return keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hashOrder(order, nonce)));
990     }
991 
992     /**
993      * @dev Assert an order is valid and return its hash
994      * @param order Order to validate
995      * @param nonce Nonce to validate
996      */
997     function requireValidOrder(Order memory order, uint nonce)
998     internal
999     view
1000     returns (bytes32)
1001     {
1002         bytes32 hash = hashToSign(order, nonce);
1003         require(validateOrder(hash, order), "invalid order");
1004         return hash;
1005     }
1006 
1007     /**
1008      * @dev Validate order parameters
1009      * @param order Order to validate
1010      */
1011     function validateOrderParameters(Order memory order)
1012     internal
1013     view
1014     returns (bool)
1015     {
1016         /* Order must be targeted at this protocol version (this Exchange contract). */
1017         if (order.exchange != address(this)) {
1018             return false;
1019         }
1020 
1021         /* Order must have a maker. */
1022         if (order.maker == address(0)) {
1023             return false;
1024         }
1025 
1026         /* Order must possess valid sale kind parameter combination. */
1027         if (!SaleKindInterface.validateParameters(order.saleKind, order.expirationTime)) {
1028             return false;
1029         }
1030 
1031         return true;
1032     }
1033 
1034     /**
1035      * @dev Validate a provided previously approved / signed order, hash
1036      * @param hash Order hash (already calculated, passed to avoid recalculation)
1037      * @param order Order to validate
1038      */
1039     function validateOrder(bytes32 hash, Order memory order)
1040     internal
1041     view
1042     returns (bool)
1043     {
1044         /* Not done in an if-conditional to prevent unnecessary ecrecover evaluation, which seems to happen even though it should short-circuit. */
1045 
1046         /* Order must have valid parameters. */
1047         if (!validateOrderParameters(order)) {
1048             return false;
1049         }
1050 
1051         /* Order must have not been canceled or already filled. */
1052         if (cancelledOrFinalized[hash]) {
1053             return false;
1054         }
1055 
1056         /* Return true if order has been previously approved with the current nonce */
1057         uint approvedOrderNoncePlusOne = _approvedOrdersByNonce[hash];
1058         if (approvedOrderNoncePlusOne == 0) {
1059             return false;
1060         }
1061         return approvedOrderNoncePlusOne == nonces[order.maker] + 1;
1062     }
1063 
1064     /**
1065      * @dev Determine if an order has been approved. Note that the order may not still
1066      * be valid in cases where the maker's nonce has been incremented.
1067      * @param hash Hash of the order
1068      * @return whether or not the order was approved.
1069      */
1070     function approvedOrders(bytes32 hash) public view returns (bool approved) {
1071         return _approvedOrdersByNonce[hash] != 0;
1072     }
1073 
1074     /**
1075      * @dev Approve an order and optionally mark it for orderbook inclusion. Must be called by the maker of the order
1076      * @param order Order to approve
1077      * @param ipfsHash Order metadata on IPFS
1078      */
1079     function makeOrder(Order memory order, bytes32 ipfsHash)
1080     internal
1081     {
1082         /* CHECKS */
1083 
1084         /* Assert sender is authorized to approve order. */
1085         require(msg.sender == order.maker);
1086 
1087         /* Calculate order hash. */
1088         bytes32 hash = hashToSign(order, nonces[order.maker]);
1089 
1090         /* Assert order has not already been approved. */
1091         require(_approvedOrdersByNonce[hash] == 0, "duplicated order hash");
1092 
1093         /* EFFECTS */
1094 
1095         /* Mark order as approved. */
1096         _approvedOrdersByNonce[hash] = nonces[order.maker] + 1;
1097 
1098         /* Log approval event. Must be split in two due to Solidity stack size limitations. */
1099         {
1100             emit OrderApprovedPartOne(hash, order.exchange, order.maker, order.taker, order.makerRelayerFeeRecipient, order.side, order.saleKind, order.nftAddress, order.tokenId, ipfsHash);
1101         }
1102         {
1103             emit OrderApprovedPartTwo(hash, order.calldata, order.replacementPattern, order.staticTarget, order.staticExtradata, order.paymentToken, order.basePrice, order.extra, order.listingTime, order.expirationTime, order.salt);
1104         }
1105     }
1106 
1107     /**
1108      * @dev Cancel an order, preventing it from being matched. Must be called by the maker of the order
1109      * @param order Order to cancel
1110      * @param nonce Nonce to cancel
1111      */
1112     function cancelOrder(Order memory order, uint nonce)
1113     internal
1114     {
1115         /* CHECKS */
1116 
1117         /* Calculate order hash. */
1118         bytes32 hash = requireValidOrder(order, nonce);
1119 
1120         /* Assert sender is authorized to cancel order. */
1121         require(msg.sender == order.maker);
1122 
1123         /* EFFECTS */
1124 
1125         /* Mark order as cancelled, preventing it from being matched. */
1126         cancelledOrFinalized[hash] = true;
1127 
1128         /* Log cancel event. */
1129         emit OrderCancelled(hash);
1130     }
1131 
1132     /**
1133      * @dev Calculate the current price of an order (convenience function)
1134      * @param order Order to calculate the price of
1135      * @return The current price of the order
1136      */
1137     function calculateCurrentPrice (Order memory order)
1138     internal
1139     view
1140     returns (uint)
1141     {
1142         return SaleKindInterface.calculateFinalPrice(order.side, order.saleKind, order.basePrice, order.extra, order.listingTime, order.expirationTime);
1143     }
1144 
1145     /**
1146      * @dev Calculate the price two orders would match at, if in fact they would match (otherwise fail)
1147      * @param buy Buy-side order
1148      * @param sell Sell-side order
1149      * @return Match price
1150      */
1151     function calculateMatchPrice(Order memory buy, Order memory sell)
1152     view
1153     internal
1154     returns (uint)
1155     {
1156         /* Calculate sell price. */
1157         uint sellPrice = SaleKindInterface.calculateFinalPrice(sell.side, sell.saleKind, sell.basePrice, sell.extra, sell.listingTime, sell.expirationTime);
1158 
1159         /* Calculate buy price. */
1160         uint buyPrice = SaleKindInterface.calculateFinalPrice(buy.side, buy.saleKind, buy.basePrice, buy.extra, buy.listingTime, buy.expirationTime);
1161 
1162         /* Require price cross. */
1163         require(buyPrice >= sellPrice);
1164 
1165         /* Maker/taker priority. */
1166         return sell.makerRelayerFeeRecipient != address(0) ? sellPrice : buyPrice;
1167     }
1168 
1169     /**
1170      * @dev Execute all IERC20 token / Ether transfers associated with an order match (fees and buyer => seller transfer)
1171      * @param buy Buy-side order
1172      * @param sell Sell-side order
1173      */
1174     function executeFundsTransfer(Order memory buy, Order memory sell)
1175     internal
1176     returns (uint)
1177     {
1178         /* Only payable in the special case of unwrapped Ether. */
1179         if (sell.paymentToken != address(0)) {
1180             require(msg.value == 0);
1181         }
1182 
1183         /* Calculate match price. */
1184         uint price = calculateMatchPrice(buy, sell);
1185 
1186         /* If paying using a token (not Ether), transfer tokens. This is done prior to fee payments to that a seller will have tokens before being charged fees. */
1187         if (price > 0 && sell.paymentToken != address(0)) {
1188             transferTokens(sell.paymentToken, buy.maker, sell.maker, price);
1189         }
1190 
1191         /* Amount that will be received by seller (for Ether). */
1192         uint receiveAmount = price;
1193 
1194         /* Amount that must be sent by buyer (for Ether). */
1195         uint requiredAmount = price;
1196 
1197         uint exchangeFee = SafeMath.div(SafeMath.mul(exchangeFeeRate, price), INVERSE_BASIS_POINT);
1198 
1199         address royaltyReceiver = address(0x00);
1200         uint256 royaltyAmount;
1201         if (checkRoyalties(sell.nftAddress)) {
1202             (royaltyReceiver, royaltyAmount) = IERC2981(sell.nftAddress).royaltyInfo(buy.tokenId, price);
1203         } else {
1204             (royaltyReceiver, royaltyAmount) = IRoyaltyRegisterHub(royaltyRegisterHub).royaltyInfo(sell.nftAddress, price);
1205         }
1206 
1207         if (royaltyReceiver != address(0x00) && royaltyAmount != 0) {
1208             if (sell.paymentToken == address(0)) {
1209                 receiveAmount = SafeMath.sub(receiveAmount, royaltyAmount);
1210                 royaltyReceiver.transfer(royaltyAmount);
1211             } else {
1212                 transferTokens(sell.paymentToken, sell.maker, royaltyReceiver, royaltyAmount);
1213             }
1214         }
1215 
1216         /* Determine maker/taker and charge fees accordingly. */
1217         if (sell.makerRelayerFeeRecipient != address(0) && exchangeFee != 0) {
1218             /* Sell-side order is maker. */
1219 
1220             /* Maker fees are deducted from the token amount that the maker receives. Taker fees are extra tokens that must be paid by the taker. */
1221 
1222             uint makerRelayerFee = SafeMath.div(SafeMath.mul(makerRelayerFeeShare, exchangeFee), INVERSE_BASIS_POINT);
1223             if (sell.paymentToken == address(0)) {
1224                 receiveAmount = SafeMath.sub(receiveAmount, makerRelayerFee);
1225                 sell.makerRelayerFeeRecipient.transfer(makerRelayerFee);
1226             } else {
1227                 transferTokens(sell.paymentToken, sell.maker, sell.makerRelayerFeeRecipient, makerRelayerFee);
1228             }
1229 
1230             if (buy.takerRelayerFeeRecipient != address(0)) {
1231                 uint takerRelayerFee = SafeMath.div(SafeMath.mul(takerRelayerFeeShare, exchangeFee), INVERSE_BASIS_POINT);
1232                 if (sell.paymentToken == address(0)) {
1233                     receiveAmount = SafeMath.sub(receiveAmount, takerRelayerFee);
1234                     buy.takerRelayerFeeRecipient.transfer(takerRelayerFee);
1235                 } else {
1236                     transferTokens(sell.paymentToken, sell.maker, buy.takerRelayerFeeRecipient, takerRelayerFee);
1237                 }
1238             }
1239 
1240             uint protocolFee = SafeMath.div(SafeMath.mul(protocolFeeShare, exchangeFee), INVERSE_BASIS_POINT);
1241             if (sell.paymentToken == address(0)) {
1242                 receiveAmount = SafeMath.sub(receiveAmount, protocolFee);
1243                 protocolFeeRecipient.transfer(protocolFee);
1244             } else {
1245                 transferTokens(sell.paymentToken, sell.maker, protocolFeeRecipient, protocolFee);
1246             }
1247         } else if (sell.makerRelayerFeeRecipient == address(0)){
1248             /* Buy-side order is maker. */
1249 
1250             /* The Exchange does not escrow Ether, so direct Ether can only be used to with sell-side maker / buy-side taker orders. */
1251             require(sell.paymentToken != address(0));
1252 
1253             if (exchangeFee != 0) {
1254                 makerRelayerFee = SafeMath.div(SafeMath.mul(makerRelayerFeeShare, exchangeFee), INVERSE_BASIS_POINT);
1255                 transferTokens(sell.paymentToken, sell.maker, buy.makerRelayerFeeRecipient, makerRelayerFee);
1256 
1257                 if (sell.takerRelayerFeeRecipient != address(0)) {
1258                     takerRelayerFee = SafeMath.div(SafeMath.mul(takerRelayerFeeShare, exchangeFee), INVERSE_BASIS_POINT);
1259                     transferTokens(sell.paymentToken, sell.maker, sell.takerRelayerFeeRecipient, takerRelayerFee);
1260                 }
1261 
1262                 protocolFee = SafeMath.div(SafeMath.mul(protocolFeeShare, exchangeFee), INVERSE_BASIS_POINT);
1263                 transferTokens(sell.paymentToken, sell.maker, protocolFeeRecipient, protocolFee);
1264             }
1265         }
1266 
1267         if (sell.paymentToken == address(0)) {
1268             /* Special-case Ether, order must be matched by buyer. */
1269             require(msg.value >= requiredAmount);
1270             sell.maker.transfer(receiveAmount);
1271             /* Allow overshoot for variable-price auctions, refund difference. */
1272             uint diff = SafeMath.sub(msg.value, requiredAmount);
1273             if (diff > 0) {
1274                 buy.maker.transfer(diff);
1275             }
1276         }
1277 
1278         /* This contract should never hold Ether, however, we cannot assert this, since it is impossible to prevent anyone from sending Ether e.g. with selfdestruct. */
1279 
1280         return price;
1281     }
1282 
1283     /**
1284      * @dev Return whether or not two orders can be matched with each other by basic parameters (does not check order signatures / calldata or perform static calls)
1285      * @param buy Buy-side order
1286      * @param sell Sell-side order
1287      * @return Whether or not the two orders can be matched
1288      */
1289     function ordersCanMatch(Order memory buy, Order memory sell)
1290     internal
1291     view
1292     returns (bool)
1293     {
1294         return (
1295         /* Must be opposite-side. */
1296         (buy.side == SaleKindInterface.Side.Buy && sell.side == SaleKindInterface.Side.Sell) &&
1297         /* Must use same payment token. */
1298         (buy.paymentToken == sell.paymentToken) &&
1299         /* Must match maker/taker addresses. */
1300         (sell.taker == address(0) || sell.taker == buy.maker) &&
1301         (buy.taker == address(0) || buy.taker == sell.maker) &&
1302         /* One must be maker and the other must be taker (no bool XOR in Solidity). */
1303         ((sell.makerRelayerFeeRecipient == address(0) && buy.makerRelayerFeeRecipient != address(0)) || (sell.makerRelayerFeeRecipient != address(0) && buy.makerRelayerFeeRecipient == address(0))) &&
1304         /* Must match nftAddress. */
1305         (buy.nftAddress == sell.nftAddress) &&
1306         /* Buy-side order must be settleable. */
1307         SaleKindInterface.canSettleOrder(buy.listingTime, buy.expirationTime) &&
1308         /* Sell-side order must be settleable. */
1309         SaleKindInterface.canSettleOrder(sell.listingTime, sell.expirationTime)
1310         );
1311     }
1312 
1313     /**
1314      * @dev Atomically match two orders, ensuring validity of the match, and execute all associated state transitions. Protected against reentrancy by a contract-global lock.
1315      * @param buy Buy-side order
1316      * @param sell Sell-side order
1317      */
1318     function takeOrder(Order memory buy, Order memory sell, bytes32 metadata)
1319     internal
1320     reentrancyGuard
1321     {
1322         /* CHECKS */
1323 
1324         /* Ensure buy order validity and calculate hash if necessary. */
1325         bytes32 buyHash;
1326         if (buy.maker == msg.sender) {
1327             require(validateOrderParameters(buy), "invalid buy params");
1328         } else {
1329             buyHash = _requireValidOrderWithNonce(buy);
1330         }
1331 
1332         /* Ensure sell order validity and calculate hash if necessary. */
1333         bytes32 sellHash;
1334         if (sell.maker == msg.sender) {
1335             require(validateOrderParameters(sell), "invalid sell params");
1336         } else {
1337             sellHash = _requireValidOrderWithNonce(sell);
1338         }
1339 
1340         /* Must be matchable. */
1341         require(ordersCanMatch(buy, sell), "order can't match");
1342 
1343         /* Must match calldata after replacement, if specified. */
1344         if (buy.replacementPattern.length > 0) {
1345             ArrayUtils.guardedArrayReplace(buy.calldata, sell.calldata, buy.replacementPattern);
1346         }
1347         if (sell.replacementPattern.length > 0) {
1348             ArrayUtils.guardedArrayReplace(sell.calldata, buy.calldata, sell.replacementPattern);
1349         }
1350         require(ArrayUtils.arrayEq(buy.calldata, sell.calldata), "calldata doesn't equal");
1351 
1352         /* EFFECTS */
1353 
1354         /* Mark previously signed or approved orders as finalized. */
1355         if (msg.sender != buy.maker) {
1356             cancelledOrFinalized[buyHash] = true;
1357         }
1358         if (msg.sender != sell.maker) {
1359             cancelledOrFinalized[sellHash] = true;
1360         }
1361 
1362         /* INTERACTIONS */
1363 
1364         /* Execute funds transfer and pay fees. */
1365         uint price = executeFundsTransfer(buy, sell);
1366 
1367         require(merkleValidatorContract.delegatecall(sell.calldata), "order calldata failure");
1368 
1369         /* Static calls are intentionally done after the effectful call so they can check resulting state. */
1370 
1371         /* Handle buy-side static call if specified. */
1372         if (buy.staticTarget != address(0)) {
1373             require(staticCall(buy.staticTarget, sell.calldata, buy.staticExtradata));
1374         }
1375 
1376         /* Handle sell-side static call if specified. */
1377         if (sell.staticTarget != address(0)) {
1378             require(staticCall(sell.staticTarget, sell.calldata, sell.staticExtradata));
1379         }
1380 
1381         /* Log match event. */
1382         emit OrdersMatched(
1383             buyHash, sellHash,
1384             sell.makerRelayerFeeRecipient != address(0) ? sell.maker : buy.maker,
1385             sell.makerRelayerFeeRecipient != address(0) ? buy.maker : sell.maker,
1386             sell.makerRelayerFeeRecipient != address(0) ? sell.makerRelayerFeeRecipient : buy.makerRelayerFeeRecipient,
1387             sell.makerRelayerFeeRecipient != address(0) ? buy.takerRelayerFeeRecipient : sell.takerRelayerFeeRecipient,
1388             price, metadata);
1389     }
1390 
1391     function _requireValidOrderWithNonce(Order memory order) internal view returns (bytes32) {
1392         return requireValidOrder(order, nonces[order.maker]);
1393     }
1394 }
1395 
1396 // File: contracts/NiftyConnectExchange.sol
1397 
1398 pragma solidity 0.4.26;
1399 
1400 
1401 
1402 
1403 contract NiftyConnectExchange is ExchangeCore {
1404 
1405     enum MerkleValidatorSelector {
1406         MatchERC721UsingCriteria,
1407         MatchERC721WithSafeTransferUsingCriteria,
1408         MatchERC1155UsingCriteria
1409     }
1410 
1411     constructor (
1412         TokenTransferProxy tokenTransferProxyAddress,
1413         address protocolFeeAddress,
1414         address merkleValidatorAddress,
1415         address royaltyRegisterHubAddress)
1416     public {
1417         tokenTransferProxy = tokenTransferProxyAddress;
1418         protocolFeeRecipient = protocolFeeAddress;
1419         merkleValidatorContract = merkleValidatorAddress;
1420         royaltyRegisterHub = royaltyRegisterHubAddress;
1421     }
1422 
1423     function buildCallData(
1424         uint selector,
1425         address from,
1426         address to,
1427         address nftAddress,
1428         uint256 tokenId,
1429         uint256 amount,
1430         bytes32 merkleRoot,
1431         bytes32[] memory merkleProof)
1432     public view returns(bytes) {
1433         MerkleValidatorSelector merkleValidatorSelector = MerkleValidatorSelector(selector);
1434         if (merkleValidatorSelector == MerkleValidatorSelector.MatchERC721UsingCriteria) {
1435             return abi.encodeWithSignature("matchERC721UsingCriteria(address,address,address,uint256,bytes32,bytes32[])", from, to, nftAddress, tokenId, merkleRoot, merkleProof);
1436         } else if (merkleValidatorSelector == MerkleValidatorSelector.MatchERC721WithSafeTransferUsingCriteria) {
1437             return abi.encodeWithSignature("matchERC721WithSafeTransferUsingCriteria(address,address,address,uint256,bytes32,bytes32[])", from, to, nftAddress, tokenId, merkleRoot, merkleProof);
1438         } else if (merkleValidatorSelector == MerkleValidatorSelector.MatchERC1155UsingCriteria) {
1439             return abi.encodeWithSignature("matchERC1155UsingCriteria(address,address,address,uint256,uint256,bytes32,bytes32[])", from, to, nftAddress, tokenId, amount, merkleRoot, merkleProof);
1440         } else {
1441             return new bytes(0);
1442         }
1443     }
1444 
1445     function buildCallDataInternal(
1446         address from,
1447         address to,
1448         address nftAddress,
1449         uint[9] uints,
1450         bytes32 merkleRoot)
1451     internal view returns(bytes) {
1452         bytes32[] memory merkleProof;
1453         if (uints[8]==0) {
1454             require(merkleRoot==bytes32(0x00), "invalid merkleRoot");
1455             return buildCallData(uints[5],from,to,nftAddress,uints[6],uints[7],merkleRoot,merkleProof);
1456         }
1457         require(uints[8]>=2&&merkleRoot!=bytes32(0x00), "invalid merkle data");
1458         uint256 merkleProofLength;
1459         uint256 divResult = uints[8];
1460         bool hasMod = false;
1461         for(;divResult!=0;) {
1462             uint256 tempDivResult = divResult/2;
1463             if (SafeMath.mul(tempDivResult, 2)<divResult) {
1464                 hasMod = true;
1465             }
1466             divResult=tempDivResult;
1467             merkleProofLength++;
1468         }
1469         if (!hasMod) {
1470             merkleProofLength--;
1471         }
1472         merkleProof = new bytes32[](merkleProofLength);
1473         return buildCallData(uints[5],from,to,nftAddress,uints[6],uints[7],merkleRoot,merkleProof);
1474     }
1475 
1476     function guardedArrayReplace(bytes array, bytes desired, bytes mask)
1477     public
1478     pure
1479     returns (bytes)
1480     {
1481         ArrayUtils.guardedArrayReplace(array, desired, mask);
1482         return array;
1483     }
1484 
1485     function calculateFinalPrice(SaleKindInterface.Side side, SaleKindInterface.SaleKind saleKind, uint basePrice, uint extra, uint listingTime, uint expirationTime)
1486     public
1487     view
1488     returns (uint)
1489     {
1490         return SaleKindInterface.calculateFinalPrice(side, saleKind, basePrice, extra, listingTime, expirationTime);
1491     }
1492 
1493     function hashToSign_(
1494         address[9] addrs,
1495         uint[9] uints,
1496         SaleKindInterface.Side side,
1497         SaleKindInterface.SaleKind saleKind,
1498         bytes replacementPattern,
1499         bytes staticExtradata,
1500         bytes32 merkleRoot)
1501     public
1502     view
1503     returns (bytes32)
1504     {
1505         bytes memory orderCallData = buildCallDataInternal(addrs[7],addrs[8],addrs[4],uints,merkleRoot);
1506         return hashToSign(
1507             Order(addrs[0], addrs[1], addrs[2], addrs[3], address(0x00), side, saleKind, addrs[4], uints[6], orderCallData, replacementPattern, addrs[5], staticExtradata, IERC20(addrs[6]), uints[0], uints[1], uints[2], uints[3], uints[4]),
1508             nonces[addrs[1]]
1509         );
1510     }
1511 
1512     function validateOrderParameters_ (
1513         address[9] addrs,
1514         uint[9] uints,
1515         SaleKindInterface.Side side,
1516         SaleKindInterface.SaleKind saleKind,
1517         bytes replacementPattern,
1518         bytes staticExtradata,
1519         bytes32 merkleRoot)
1520     view
1521     public
1522     returns (bool) {
1523         bytes memory orderCallData = buildCallDataInternal(addrs[7],addrs[8],addrs[4],uints,merkleRoot);
1524         Order memory order = Order(addrs[0], addrs[1], addrs[2], addrs[3], address(0x00), side, saleKind, addrs[4], uints[6], orderCallData, replacementPattern, addrs[5], staticExtradata, IERC20(addrs[6]), uints[0], uints[1], uints[2], uints[3], uints[4]);
1525         return validateOrderParameters(
1526             order
1527         );
1528     }
1529 
1530     function validateOrder_ (
1531         address[9] addrs,
1532         uint[9] uints,
1533         SaleKindInterface.Side side,
1534         SaleKindInterface.SaleKind saleKind,
1535         bytes replacementPattern,
1536         bytes staticExtradata,
1537         bytes32 merkleRoot)
1538     view
1539     public
1540     returns (bool)
1541     {
1542         bytes memory orderCallData = buildCallDataInternal(addrs[7],addrs[8],addrs[4],uints,merkleRoot);
1543         Order memory order = Order(addrs[0], addrs[1], addrs[2], addrs[3], address(0x00), side, saleKind, addrs[4], uints[6], orderCallData, replacementPattern, addrs[5], staticExtradata, IERC20(addrs[6]), uints[0], uints[1], uints[2], uints[3], uints[4]);
1544         return validateOrder(
1545             hashToSign(order, nonces[order.maker]),
1546             order
1547         );
1548     }
1549 
1550     function makeOrder_ (
1551         address[9] addrs,
1552         uint[9] uints,
1553         SaleKindInterface.Side side,
1554         SaleKindInterface.SaleKind saleKind,
1555         bytes replacementPattern,
1556         bytes staticExtradata,
1557         bytes32[2] merkleData)
1558     public
1559     {
1560         bytes memory orderCallData = buildCallDataInternal(addrs[7],addrs[8],addrs[4],uints,merkleData[0]);
1561         require(addrs[3]!=address(0x00), "makerRelayerFeeRecipient must not be zero");
1562         require(orderCallData.length==replacementPattern.length, "replacement pattern length mismatch");
1563         Order memory order = Order(addrs[0], addrs[1], addrs[2], addrs[3], address(0x00), side, saleKind, addrs[4], uints[6], orderCallData, replacementPattern, addrs[5], staticExtradata, IERC20(addrs[6]), uints[0], uints[1], uints[2], uints[3], uints[4]);
1564         return makeOrder(order, merkleData[1]);
1565     }
1566 
1567     function cancelOrder_(
1568         address[9] addrs,
1569         uint[9] uints,
1570         SaleKindInterface.Side side,
1571         SaleKindInterface.SaleKind saleKind,
1572         bytes replacementPattern,
1573         bytes staticExtradata,
1574         bytes32 merkleRoot)
1575     public
1576     {
1577         bytes memory orderCallData = buildCallDataInternal(addrs[7],addrs[8],addrs[4],uints,merkleRoot);
1578         Order memory order = Order(addrs[0], addrs[1], addrs[2], addrs[3], address(0x00), side, saleKind, addrs[4], uints[6], orderCallData, replacementPattern, addrs[5], staticExtradata, IERC20(addrs[6]), uints[0], uints[1], uints[2], uints[3], uints[4]);
1579         return cancelOrder(
1580             order,
1581             nonces[order.maker]
1582         );
1583     }
1584 
1585     function calculateCurrentPrice_(
1586         address[9] addrs,
1587         uint[9] uints,
1588         SaleKindInterface.Side side,
1589         SaleKindInterface.SaleKind saleKind,
1590         bytes replacementPattern,
1591         bytes staticExtradata,
1592         bytes32 merkleRoot)
1593     public
1594     view
1595     returns (uint)
1596     {
1597         bytes memory orderCallData = buildCallDataInternal(addrs[7],addrs[8],addrs[4],uints,merkleRoot);
1598         return calculateCurrentPrice(
1599             Order(addrs[0], addrs[1], addrs[2], addrs[3], address(0x00), side, saleKind, addrs[4], uints[6], orderCallData, replacementPattern, addrs[5], staticExtradata, IERC20(addrs[6]), uints[0], uints[1], uints[2], uints[3], uints[4])
1600         );
1601     }
1602 
1603     function ordersCanMatch_(
1604         address[16] addrs,
1605         uint[12] uints,
1606         uint8[4] sidesKinds,
1607         bytes calldataBuy,
1608         bytes calldataSell,
1609         bytes replacementPatternBuy,
1610         bytes replacementPatternSell,
1611         bytes staticExtradataBuy,
1612         bytes staticExtradataSell)
1613     public
1614     view
1615     returns (bool)
1616     {
1617         Order memory buy = Order(addrs[0], addrs[1], addrs[2], addrs[3], addrs[4], SaleKindInterface.Side(sidesKinds[0]), SaleKindInterface.SaleKind(sidesKinds[1]), addrs[5], uints[5], calldataBuy, replacementPatternBuy, addrs[6], staticExtradataBuy, IERC20(addrs[7]), uints[0], uints[1], uints[2], uints[3], uints[4]);
1618         Order memory sell = Order(addrs[8], addrs[9], addrs[10], addrs[11], addrs[12], SaleKindInterface.Side(sidesKinds[2]), SaleKindInterface.SaleKind(sidesKinds[3]), addrs[13], uints[11], calldataSell, replacementPatternSell, addrs[14], staticExtradataSell, IERC20(addrs[15]), uints[6], uints[7], uints[8], uints[9], uints[10]);
1619         return ordersCanMatch(
1620             buy,
1621             sell
1622         );
1623     }
1624 
1625     function orderCalldataCanMatch(bytes buyCalldata, bytes buyReplacementPattern, bytes sellCalldata, bytes sellReplacementPattern)
1626     public
1627     pure
1628     returns (bool)
1629     {
1630         if (buyReplacementPattern.length > 0) {
1631             ArrayUtils.guardedArrayReplace(buyCalldata, sellCalldata, buyReplacementPattern);
1632         }
1633         if (sellReplacementPattern.length > 0) {
1634             ArrayUtils.guardedArrayReplace(sellCalldata, buyCalldata, sellReplacementPattern);
1635         }
1636         return ArrayUtils.arrayEq(buyCalldata, sellCalldata);
1637     }
1638 
1639     function calculateMatchPrice_(
1640         address[16] addrs,
1641         uint[12] uints,
1642         uint8[4] sidesKinds,
1643         bytes calldataBuy,
1644         bytes calldataSell,
1645         bytes replacementPatternBuy,
1646         bytes replacementPatternSell,
1647         bytes staticExtradataBuy,
1648         bytes staticExtradataSell)
1649     public
1650     view
1651     returns (uint)
1652     {
1653         Order memory buy = Order(addrs[0], addrs[1], addrs[2], addrs[3], addrs[4], SaleKindInterface.Side(sidesKinds[0]), SaleKindInterface.SaleKind(sidesKinds[1]), addrs[5], uints[5], calldataBuy, replacementPatternBuy, addrs[6], staticExtradataBuy, IERC20(addrs[7]), uints[0], uints[1], uints[2], uints[3], uints[4]);
1654         Order memory sell = Order(addrs[8], addrs[9], addrs[10], addrs[11], addrs[12], SaleKindInterface.Side(sidesKinds[2]), SaleKindInterface.SaleKind(sidesKinds[3]), addrs[13], uints[11], calldataSell, replacementPatternSell, addrs[14], staticExtradataSell, IERC20(addrs[15]), uints[6], uints[7], uints[8], uints[9], uints[10]);
1655         return calculateMatchPrice(
1656             buy,
1657             sell
1658         );
1659     }
1660 
1661     function takeOrder_(
1662         address[16] addrs,
1663         uint[12] uints,
1664         uint8[4] sidesKinds,
1665         bytes calldataBuy,
1666         bytes calldataSell,
1667         bytes replacementPatternBuy,
1668         bytes replacementPatternSell,
1669         bytes staticExtradataBuy,
1670         bytes staticExtradataSell,
1671         bytes32 rssMetadata)
1672     public
1673     payable
1674     {
1675 
1676         return takeOrder(
1677             Order(addrs[0], addrs[1], addrs[2], addrs[3], addrs[4], SaleKindInterface.Side(sidesKinds[0]), SaleKindInterface.SaleKind(sidesKinds[1]), addrs[5], uints[5], calldataBuy, replacementPatternBuy, addrs[6], staticExtradataBuy, IERC20(addrs[7]), uints[0], uints[1], uints[2], uints[3], uints[4]),
1678             Order(addrs[8], addrs[9], addrs[10], addrs[11], addrs[12], SaleKindInterface.Side(sidesKinds[2]), SaleKindInterface.SaleKind(sidesKinds[3]), addrs[13], uints[11], calldataSell, replacementPatternSell, addrs[14], staticExtradataSell, IERC20(addrs[15]), uints[6], uints[7], uints[8], uints[9], uints[10]),
1679             rssMetadata
1680         );
1681     }
1682 
1683 }