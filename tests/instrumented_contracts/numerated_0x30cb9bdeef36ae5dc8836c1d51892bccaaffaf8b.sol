1 /**
2 
3 The Cyber Syndicate Code of Conduct
4 
5 Preamble:
6 We, the members of the Cyber Syndicate, unite under this code to uphold a set of principles that define our actions, ethics, and responsibilities as cyber mercenaries. Our mission is to execute contracts related to hacking, assassinations, theft, and more, while maintaining a sense of honor, morality, and professionalism.
7 
8 Article 1: Protection of the Vulnerable
9 
10 We shall never cause harm to children, pregnant women, or innocent civilians in the execution of our duties. The well-being of the most vulnerable is sacrosanct.
11 
12 Article 2: Honesty in Contracts
13 
14 We accept only contracts that adhere to moral and ethical standards. We refuse to engage in tasks involving extremism, explicit criminal activities, or actions that would tarnish our reputation as cyber professionals.
15 
16 Article 3: The Pursuit of Justice
17 
18 We commit to not taking contracts that would intentionally target innocent individuals or cause undue suffering. Our actions shall be guided by the pursuit of justice and proportional response.
19 
20 Article 4: Unity and Loyalty
21 
22 We stand as one, united by loyalty to our fellow Syndicate members. Betrayal of our comrades is a grave offense, punishable by our own code.
23 
24 Article 5: Confidentiality
25 
26 We respect client confidentiality and will not disclose sensitive information about our employers or colleagues to unauthorized parties. Breaching this trust is a breach of our code.
27 
28 Article 6: Continuous Improvement
29 
30 We shall constantly strive for excellence in our cyber skills and remain at the forefront of technological advancements to better serve our clients.
31 
32 Article 7: Non-Discrimination
33 
34 We do not discriminate based on race, gender, nationality, or any other characteristic when it comes to accepting contracts or admitting new members into the Syndicate.
35 
36 Article 8: Responsibility
37 
38 We are responsible for the consequences of our actions. We shall exercise due diligence and minimize collateral damage in all our operations.
39 
40 Article 9: Dispute Resolution
41 
42 Disputes among Syndicate members shall be resolved internally through a fair and impartial process, with the overarching goal of maintaining unity and honor within the organization.
43 
44 Article 10: Adherence to Law
45 
46 We acknowledge that our actions must comply with local and international laws, and we shall not engage in activities that would result in criminal prosecution.
47 
48 Article 11: Protection of Innocents
49 
50 In executing contracts, members of the order shall make every effort to avoid harming the innocent or minimize harm when possible. However, contract fulfillment takes precedence, and an acceptable level of losses may be incurred while completing a mission.
51 Conclusion:
52 The Cyber Syndicate, as a collective of cyber mercenaries, vows to adhere to this Code of Conduct, honoring its principles and holding its members accountable to maintain the highest standards of integrity and professionalism. Failure to uphold this code may result in expulsion from the Syndicate or more severe consequences, as determined by our governing body.
53 
54 */
55 
56 pragma solidity ^0.8.0;
57 abstract contract ReentrancyGuard {
58 
59     uint256 private constant _NOT_ENTERED = 1;
60     uint256 private constant _ENTERED = 2;
61 
62     uint256 private _status;
63 
64     constructor() {
65         _status = _NOT_ENTERED;
66     }
67 
68     modifier nonReentrant() {
69         _nonReentrantBefore();
70         _;
71         _nonReentrantAfter();
72     }
73 
74     function _nonReentrantBefore() private {
75         // On the first call to nonReentrant, _status will be _NOT_ENTERED
76         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
77 
78         // Any calls to nonReentrant after this point will fail
79         _status = _ENTERED;
80     }
81 
82     function _nonReentrantAfter() private {
83 
84         _status = _NOT_ENTERED;
85     }
86 }
87 
88 pragma solidity ^0.8.0;
89 
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 pragma solidity ^0.8.0;
101 
102 abstract contract Ownable is Context {
103     address private _owner;
104 
105     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
106 
107     constructor() {
108         _transferOwnership(_msgSender());
109     }
110 
111     modifier onlyOwner() {
112         _checkOwner();
113         _;
114     }
115 
116     function owner() public view virtual returns (address) {
117         return _owner;
118     }
119 
120     function _checkOwner() internal view virtual {
121         require(owner() == _msgSender(), "Ownable: caller is not the owner");
122     }
123 
124     function renounceOwnership() public virtual onlyOwner {
125         _transferOwnership(address(0));
126     }
127 
128     function transferOwnership(address newOwner) public virtual onlyOwner {
129         require(newOwner != address(0), "Ownable: new owner is the zero address");
130         _transferOwnership(newOwner);
131     }
132 
133     function _transferOwnership(address newOwner) internal virtual {
134         address oldOwner = _owner;
135         _owner = newOwner;
136         emit OwnershipTransferred(oldOwner, newOwner);
137     }
138 }
139 
140 pragma solidity ^0.8.0;
141 
142 library Math {
143     enum Rounding {
144         Down, // Toward negative infinity
145         Up, // Toward infinity
146         Zero // Toward zero
147     }
148 
149     function max(uint256 a, uint256 b) internal pure returns (uint256) {
150         return a > b ? a : b;
151     }
152 
153     function min(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a < b ? a : b;
155     }
156 
157     function average(uint256 a, uint256 b) internal pure returns (uint256) {
158         // (a + b) / 2 can overflow.
159         return (a & b) + (a ^ b) / 2;
160     }
161 
162     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
163         // (a + b - 1) / b can overflow on addition, so we distribute.
164         return a == 0 ? 0 : (a - 1) / b + 1;
165     }
166 
167     function mulDiv(
168         uint256 x,
169         uint256 y,
170         uint256 denominator
171     ) internal pure returns (uint256 result) {
172         unchecked {
173 
174             uint256 prod0; // Least significant 256 bits of the product
175             uint256 prod1; // Most significant 256 bits of the product
176             assembly {
177                 let mm := mulmod(x, y, not(0))
178                 prod0 := mul(x, y)
179                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
180             }
181 
182             // Handle non-overflow cases, 256 by 256 division.
183             if (prod1 == 0) {
184                 return prod0 / denominator;
185             }
186 
187             // Make sure the result is less than 2^256. Also prevents denominator == 0.
188             require(denominator > prod1);
189 
190             uint256 remainder;
191             assembly {
192                 // Compute remainder using mulmod.
193                 remainder := mulmod(x, y, denominator)
194 
195                 // Subtract 256 bit number from 512 bit number.
196                 prod1 := sub(prod1, gt(remainder, prod0))
197                 prod0 := sub(prod0, remainder)
198             }
199 
200             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
201             // See https://cs.stackexchange.com/q/138556/92363.
202 
203             // Does not overflow because the denominator cannot be zero at this stage in the function.
204             uint256 twos = denominator & (~denominator + 1);
205             assembly {
206                 // Divide denominator by twos.
207                 denominator := div(denominator, twos)
208 
209                 // Divide [prod1 prod0] by twos.
210                 prod0 := div(prod0, twos)
211 
212                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
213                 twos := add(div(sub(0, twos), twos), 1)
214             }
215 
216             // Shift in bits from prod1 into prod0.
217             prod0 |= prod1 * twos;
218             uint256 inverse = (3 * denominator) ^ 2;
219 
220             inverse *= 2 - denominator * inverse; // inverse mod 2^8
221             inverse *= 2 - denominator * inverse; // inverse mod 2^16
222             inverse *= 2 - denominator * inverse; // inverse mod 2^32
223             inverse *= 2 - denominator * inverse; // inverse mod 2^64
224             inverse *= 2 - denominator * inverse; // inverse mod 2^128
225             inverse *= 2 - denominator * inverse; // inverse mod 2^256
226             result = prod0 * inverse;
227             return result;
228         }
229     }
230 
231     function mulDiv(
232         uint256 x,
233         uint256 y,
234         uint256 denominator,
235         Rounding rounding
236     ) internal pure returns (uint256) {
237         uint256 result = mulDiv(x, y, denominator);
238         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
239             result += 1;
240         }
241         return result;
242     }
243 
244     function sqrt(uint256 a) internal pure returns (uint256) {
245         if (a == 0) {
246             return 0;
247         }
248 
249         uint256 result = 1 << (log2(a) >> 1);
250 
251         unchecked {
252             result = (result + a / result) >> 1;
253             result = (result + a / result) >> 1;
254             result = (result + a / result) >> 1;
255             result = (result + a / result) >> 1;
256             result = (result + a / result) >> 1;
257             result = (result + a / result) >> 1;
258             result = (result + a / result) >> 1;
259             return min(result, a / result);
260         }
261     }
262 
263     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
264         unchecked {
265             uint256 result = sqrt(a);
266             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
267         }
268     }
269 
270     function log2(uint256 value) internal pure returns (uint256) {
271         uint256 result = 0;
272         unchecked {
273             if (value >> 128 > 0) {
274                 value >>= 128;
275                 result += 128;
276             }
277             if (value >> 64 > 0) {
278                 value >>= 64;
279                 result += 64;
280             }
281             if (value >> 32 > 0) {
282                 value >>= 32;
283                 result += 32;
284             }
285             if (value >> 16 > 0) {
286                 value >>= 16;
287                 result += 16;
288             }
289             if (value >> 8 > 0) {
290                 value >>= 8;
291                 result += 8;
292             }
293             if (value >> 4 > 0) {
294                 value >>= 4;
295                 result += 4;
296             }
297             if (value >> 2 > 0) {
298                 value >>= 2;
299                 result += 2;
300             }
301             if (value >> 1 > 0) {
302                 result += 1;
303             }
304         }
305         return result;
306     }
307 
308     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
309         unchecked {
310             uint256 result = log2(value);
311             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
312         }
313     }
314 
315     function log10(uint256 value) internal pure returns (uint256) {
316         uint256 result = 0;
317         unchecked {
318             if (value >= 10**64) {
319                 value /= 10**64;
320                 result += 64;
321             }
322             if (value >= 10**32) {
323                 value /= 10**32;
324                 result += 32;
325             }
326             if (value >= 10**16) {
327                 value /= 10**16;
328                 result += 16;
329             }
330             if (value >= 10**8) {
331                 value /= 10**8;
332                 result += 8;
333             }
334             if (value >= 10**4) {
335                 value /= 10**4;
336                 result += 4;
337             }
338             if (value >= 10**2) {
339                 value /= 10**2;
340                 result += 2;
341             }
342             if (value >= 10**1) {
343                 result += 1;
344             }
345         }
346         return result;
347     }
348 
349     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
350         unchecked {
351             uint256 result = log10(value);
352             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
353         }
354     }
355 
356     function log256(uint256 value) internal pure returns (uint256) {
357         uint256 result = 0;
358         unchecked {
359             if (value >> 128 > 0) {
360                 value >>= 128;
361                 result += 16;
362             }
363             if (value >> 64 > 0) {
364                 value >>= 64;
365                 result += 8;
366             }
367             if (value >> 32 > 0) {
368                 value >>= 32;
369                 result += 4;
370             }
371             if (value >> 16 > 0) {
372                 value >>= 16;
373                 result += 2;
374             }
375             if (value >> 8 > 0) {
376                 result += 1;
377             }
378         }
379         return result;
380     }
381 
382     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
383         unchecked {
384             uint256 result = log256(value);
385             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
386         }
387     }
388 }
389 
390 pragma solidity ^0.8.0;
391 
392 library Strings {
393     bytes16 private constant _SYMBOLS = "0123456789abcdef";
394     uint8 private constant _ADDRESS_LENGTH = 20;
395 
396     /**
397      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
398      */
399     function toString(uint256 value) internal pure returns (string memory) {
400         unchecked {
401             uint256 length = Math.log10(value) + 1;
402             string memory buffer = new string(length);
403             uint256 ptr;
404             /// @solidity memory-safe-assembly
405             assembly {
406                 ptr := add(buffer, add(32, length))
407             }
408             while (true) {
409                 ptr--;
410                 /// @solidity memory-safe-assembly
411                 assembly {
412                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
413                 }
414                 value /= 10;
415                 if (value == 0) break;
416             }
417             return buffer;
418         }
419     }
420 
421     function toHexString(uint256 value) internal pure returns (string memory) {
422         unchecked {
423             return toHexString(value, Math.log256(value) + 1);
424         }
425     }
426 
427     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
428         bytes memory buffer = new bytes(2 * length + 2);
429         buffer[0] = "0";
430         buffer[1] = "x";
431         for (uint256 i = 2 * length + 1; i > 1; --i) {
432             buffer[i] = _SYMBOLS[value & 0xf];
433             value >>= 4;
434         }
435         require(value == 0, "Strings: hex length insufficient");
436         return string(buffer);
437     }
438 
439     function toHexString(address addr) internal pure returns (string memory) {
440         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
441     }
442 }
443 
444 // ERC721A Contracts v4.2.3
445 // Creator: Chiru Labs
446 
447 pragma solidity ^0.8.4;
448 
449 interface IERC721A {
450 
451     error ApprovalCallerNotOwnerNorApproved();
452 
453     error ApprovalQueryForNonexistentToken();
454 
455     error BalanceQueryForZeroAddress();
456 
457     error MintToZeroAddress();
458 
459     error MintZeroQuantity();
460 
461     error OwnerQueryForNonexistentToken();
462 
463     error TransferCallerNotOwnerNorApproved();
464 
465     error TransferFromIncorrectOwner();
466 
467     error TransferToNonERC721ReceiverImplementer();
468 
469     error TransferToZeroAddress();
470 
471     error URIQueryForNonexistentToken();
472 
473     error MintERC2309QuantityExceedsLimit();
474 
475     error OwnershipNotInitializedForExtraData();
476 
477     struct TokenOwnership {
478         // The address of the owner.
479         address addr;
480         // Stores the start time of ownership with minimal overhead for tokenomics.
481         uint64 startTimestamp;
482         // Whether the token has been burned.
483         bool burned;
484         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
485         uint24 extraData;
486     }
487 
488     function totalSupply() external view returns (uint256);
489 
490     function supportsInterface(bytes4 interfaceId) external view returns (bool);
491 
492     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
493 
494     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
495 
496     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
497 
498     function balanceOf(address owner) external view returns (uint256 balance);
499 
500     function ownerOf(uint256 tokenId) external view returns (address owner);
501 
502     function safeTransferFrom(
503         address from,
504         address to,
505         uint256 tokenId,
506         bytes calldata data
507     ) external payable;
508 
509     function safeTransferFrom(
510         address from,
511         address to,
512         uint256 tokenId
513     ) external payable;
514 
515     function transferFrom(
516         address from,
517         address to,
518         uint256 tokenId
519     ) external payable;
520 
521     function approve(address to, uint256 tokenId) external payable;
522     function setApprovalForAll(address operator, bool _approved) external;
523     function getApproved(uint256 tokenId) external view returns (address operator);
524     function isApprovedForAll(address owner, address operator) external view returns (bool);
525     function name() external view returns (string memory);
526     function symbol() external view returns (string memory);
527     function tokenURI(uint256 tokenId) external view returns (string memory);
528 
529     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
530 }
531 
532 // ERC721A Contracts v4.2.3
533 // Creator: Chiru Labs
534 
535 pragma solidity ^0.8.4;
536 
537 /**
538  * @dev Interface of ERC721 token receiver.
539  */
540 interface ERC721A__IERC721Receiver {
541     function onERC721Received(
542         address operator,
543         address from,
544         uint256 tokenId,
545         bytes calldata data
546     ) external returns (bytes4);
547 }
548 
549 contract ERC721A is IERC721A {
550     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
551     struct TokenApprovalRef {
552         address value;
553     }
554 
555     // Mask of an entry in packed address data.
556     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
557 
558     // The bit position of `numberMinted` in packed address data.
559     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
560 
561     // The bit position of `numberBurned` in packed address data.
562     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
563 
564     // The bit position of `aux` in packed address data.
565     uint256 private constant _BITPOS_AUX = 192;
566 
567     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
568     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
569 
570     // The bit position of `startTimestamp` in packed ownership.
571     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
572 
573     // The bit mask of the `burned` bit in packed ownership.
574     uint256 private constant _BITMASK_BURNED = 1 << 224;
575 
576     // The bit position of the `nextInitialized` bit in packed ownership.
577     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
578 
579     // The bit mask of the `nextInitialized` bit in packed ownership.
580     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
581 
582     // The bit position of `extraData` in packed ownership.
583     uint256 private constant _BITPOS_EXTRA_DATA = 232;
584 
585     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
586     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
587 
588     // The mask of the lower 160 bits for addresses.
589     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
590     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
591 
592     // The `Transfer` event signature is given by:
593     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
594     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
595         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
596 
597     uint256 private _currentIndex;
598 
599     // The number of tokens burned.
600     uint256 private _burnCounter;
601 
602     // Token name
603     string private _name;
604 
605     // Token symbol
606     string private _symbol;
607 
608     mapping(uint256 => uint256) private _packedOwnerships;
609     mapping(address => uint256) private _packedAddressData;
610     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
611     mapping(address => mapping(address => bool)) private _operatorApprovals;
612 
613     constructor(string memory name_, string memory symbol_) {
614         _name = name_;
615         _symbol = symbol_;
616         _currentIndex = _startTokenId();
617     }
618 
619     function _startTokenId() internal view virtual returns (uint256) {
620         return 0;
621     }
622 
623     function _nextTokenId() internal view virtual returns (uint256) {
624         return _currentIndex;
625     }
626 
627     function totalSupply() public view virtual override returns (uint256) {
628         // Counter underflow is impossible as _burnCounter cannot be incremented
629         // more than `_currentIndex - _startTokenId()` times.
630         unchecked {
631             return _currentIndex - _burnCounter - _startTokenId();
632         }
633     }
634 
635     function _totalMinted() internal view virtual returns (uint256) {
636         // Counter underflow is impossible as `_currentIndex` does not decrement,
637         // and it is initialized to `_startTokenId()`.
638         unchecked {
639             return _currentIndex - _startTokenId();
640         }
641     }
642 
643     function _totalBurned() internal view virtual returns (uint256) {
644         return _burnCounter;
645     }
646 
647     function balanceOf(address owner) public view virtual override returns (uint256) {
648         if (owner == address(0)) revert BalanceQueryForZeroAddress();
649         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
650     }
651 
652     function _numberMinted(address owner) internal view returns (uint256) {
653         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
654     }
655 
656     function _numberBurned(address owner) internal view returns (uint256) {
657         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
658     }
659 
660     function _getAux(address owner) internal view returns (uint64) {
661         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
662     }
663 
664     function _setAux(address owner, uint64 aux) internal virtual {
665         uint256 packed = _packedAddressData[owner];
666         uint256 auxCasted;
667         // Cast `aux` with assembly to avoid redundant masking.
668         assembly {
669             auxCasted := aux
670         }
671         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
672         _packedAddressData[owner] = packed;
673     }
674 
675     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
676 
677         return
678             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
679             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
680             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
681     }
682 
683     function name() public view virtual override returns (string memory) {
684         return _name;
685     }
686 
687     function symbol() public view virtual override returns (string memory) {
688         return _symbol;
689     }
690 
691     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
692         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
693 
694         string memory baseURI = _baseURI();
695         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
696     }
697 
698     function _baseURI() internal view virtual returns (string memory) {
699         return '';
700     }
701 
702     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
703         return address(uint160(_packedOwnershipOf(tokenId)));
704     }
705 
706     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
707         return _unpackedOwnership(_packedOwnershipOf(tokenId));
708     }
709 
710     /**
711      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
712      */
713     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
714         return _unpackedOwnership(_packedOwnerships[index]);
715     }
716 
717     /**
718      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
719      */
720     function _initializeOwnershipAt(uint256 index) internal virtual {
721         if (_packedOwnerships[index] == 0) {
722             _packedOwnerships[index] = _packedOwnershipOf(index);
723         }
724     }
725 
726     /**
727      * Returns the packed ownership data of `tokenId`.
728      */
729     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
730         uint256 curr = tokenId;
731 
732         unchecked {
733             if (_startTokenId() <= curr)
734                 if (curr < _currentIndex) {
735                     uint256 packed = _packedOwnerships[curr];
736                     // If not burned.
737                     if (packed & _BITMASK_BURNED == 0) {
738 
739                         while (packed == 0) {
740                             packed = _packedOwnerships[--curr];
741                         }
742                         return packed;
743                     }
744                 }
745         }
746         revert OwnerQueryForNonexistentToken();
747     }
748 
749     /**
750      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
751      */
752     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
753         ownership.addr = address(uint160(packed));
754         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
755         ownership.burned = packed & _BITMASK_BURNED != 0;
756         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
757     }
758 
759     /**
760      * @dev Packs ownership data into a single uint256.
761      */
762     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
763         assembly {
764             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
765             owner := and(owner, _BITMASK_ADDRESS)
766             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
767             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
768         }
769     }
770 
771     /**
772      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
773      */
774     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
775         // For branchless setting of the `nextInitialized` flag.
776         assembly {
777             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
778             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
779         }
780     }
781 
782     function approve(address to, uint256 tokenId) public payable virtual override {
783         address owner = ownerOf(tokenId);
784 
785         if (_msgSenderERC721A() != owner)
786             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
787                 revert ApprovalCallerNotOwnerNorApproved();
788             }
789 
790         _tokenApprovals[tokenId].value = to;
791         emit Approval(owner, to, tokenId);
792     }
793 
794     function getApproved(uint256 tokenId) public view virtual override returns (address) {
795         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
796 
797         return _tokenApprovals[tokenId].value;
798     }
799 
800     function setApprovalForAll(address operator, bool approved) public virtual override {
801         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
802         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
803     }
804 
805     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
806         return _operatorApprovals[owner][operator];
807     }
808 
809     function _exists(uint256 tokenId) internal view virtual returns (bool) {
810         return
811             _startTokenId() <= tokenId &&
812             tokenId < _currentIndex && // If within bounds,
813             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
814     }
815 
816     /**
817      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
818      */
819     function _isSenderApprovedOrOwner(
820         address approvedAddress,
821         address owner,
822         address msgSender
823     ) private pure returns (bool result) {
824         assembly {
825             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
826             owner := and(owner, _BITMASK_ADDRESS)
827             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
828             msgSender := and(msgSender, _BITMASK_ADDRESS)
829             // `msgSender == owner || msgSender == approvedAddress`.
830             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
831         }
832     }
833 
834     /**
835      * @dev Returns the storage slot and value for the approved address of `tokenId`.
836      */
837     function _getApprovedSlotAndAddress(uint256 tokenId)
838         private
839         view
840         returns (uint256 approvedAddressSlot, address approvedAddress)
841     {
842         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
843         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
844         assembly {
845             approvedAddressSlot := tokenApproval.slot
846             approvedAddress := sload(approvedAddressSlot)
847         }
848     }
849 
850     function transferFrom(
851         address from,
852         address to,
853         uint256 tokenId
854     ) public payable virtual override {
855         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
856 
857         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
858 
859         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
860 
861         // The nested ifs save around 20+ gas over a compound boolean condition.
862         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
863             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
864 
865         if (to == address(0)) revert TransferToZeroAddress();
866 
867         _beforeTokenTransfers(from, to, tokenId, 1);
868 
869         // Clear approvals from the previous owner.
870         assembly {
871             if approvedAddress {
872                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
873                 sstore(approvedAddressSlot, 0)
874             }
875         }
876 
877         unchecked {
878             // We can directly increment and decrement the balances.
879             --_packedAddressData[from]; // Updates: `balance -= 1`.
880             ++_packedAddressData[to]; // Updates: `balance += 1`.
881             _packedOwnerships[tokenId] = _packOwnershipData(
882                 to,
883                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
884             );
885 
886             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
887             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
888                 uint256 nextTokenId = tokenId + 1;
889                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
890                 if (_packedOwnerships[nextTokenId] == 0) {
891                     // If the next slot is within bounds.
892                     if (nextTokenId != _currentIndex) {
893                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
894                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
895                     }
896                 }
897             }
898         }
899 
900         emit Transfer(from, to, tokenId);
901         _afterTokenTransfers(from, to, tokenId, 1);
902     }
903 
904     /**
905      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
906      */
907     function safeTransferFrom(
908         address from,
909         address to,
910         uint256 tokenId
911     ) public payable virtual override {
912         safeTransferFrom(from, to, tokenId, '');
913     }
914 
915     function safeTransferFrom(
916         address from,
917         address to,
918         uint256 tokenId,
919         bytes memory _data
920     ) public payable virtual override {
921         transferFrom(from, to, tokenId);
922         if (to.code.length != 0)
923             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
924                 revert TransferToNonERC721ReceiverImplementer();
925             }
926     }
927 
928     function _beforeTokenTransfers(
929         address from,
930         address to,
931         uint256 startTokenId,
932         uint256 quantity
933     ) internal virtual {}
934 
935  
936     function _afterTokenTransfers(
937         address from,
938         address to,
939         uint256 startTokenId,
940         uint256 quantity
941     ) internal virtual {}
942 
943     function _checkContractOnERC721Received(
944         address from,
945         address to,
946         uint256 tokenId,
947         bytes memory _data
948     ) private returns (bool) {
949         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
950             bytes4 retval
951         ) {
952             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
953         } catch (bytes memory reason) {
954             if (reason.length == 0) {
955                 revert TransferToNonERC721ReceiverImplementer();
956             } else {
957                 assembly {
958                     revert(add(32, reason), mload(reason))
959                 }
960             }
961         }
962     }
963 
964     function _mint(address to, uint256 quantity) internal virtual {
965         uint256 startTokenId = _currentIndex;
966         if (quantity == 0) revert MintZeroQuantity();
967 
968         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
969 
970         unchecked {
971 
972             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
973 
974             _packedOwnerships[startTokenId] = _packOwnershipData(
975                 to,
976                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
977             );
978 
979             uint256 toMasked;
980             uint256 end = startTokenId + quantity;
981 
982             assembly {
983                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
984                 toMasked := and(to, _BITMASK_ADDRESS)
985                 // Emit the `Transfer` event.
986                 log4(
987                     0, // Start of data (0, since no data).
988                     0, // End of data (0, since no data).
989                     _TRANSFER_EVENT_SIGNATURE, // Signature.
990                     0, // `address(0)`.
991                     toMasked, // `to`.
992                     startTokenId // `tokenId`.
993                 )
994 
995                 for {
996                     let tokenId := add(startTokenId, 1)
997                 } iszero(eq(tokenId, end)) {
998                     tokenId := add(tokenId, 1)
999                 } {
1000                     // Emit the `Transfer` event. Similar to above.
1001                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1002                 }
1003             }
1004             if (toMasked == 0) revert MintToZeroAddress();
1005 
1006             _currentIndex = end;
1007         }
1008         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1009     }
1010 
1011     function _mintERC2309(address to, uint256 quantity) internal virtual {
1012         uint256 startTokenId = _currentIndex;
1013         if (to == address(0)) revert MintToZeroAddress();
1014         if (quantity == 0) revert MintZeroQuantity();
1015         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1016 
1017         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1018 
1019         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1020         unchecked {
1021 
1022             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1023 
1024             _packedOwnerships[startTokenId] = _packOwnershipData(
1025                 to,
1026                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1027             );
1028 
1029             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1030 
1031             _currentIndex = startTokenId + quantity;
1032         }
1033         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1034     }
1035 
1036     function _safeMint(
1037         address to,
1038         uint256 quantity,
1039         bytes memory _data
1040     ) internal virtual {
1041         _mint(to, quantity);
1042 
1043         unchecked {
1044             if (to.code.length != 0) {
1045                 uint256 end = _currentIndex;
1046                 uint256 index = end - quantity;
1047                 do {
1048                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1049                         revert TransferToNonERC721ReceiverImplementer();
1050                     }
1051                 } while (index < end);
1052                 // Reentrancy protection.
1053                 if (_currentIndex != end) revert();
1054             }
1055         }
1056     }
1057 
1058     function _safeMint(address to, uint256 quantity) internal virtual {
1059         _safeMint(to, quantity, '');
1060     }
1061 
1062     function _burn(uint256 tokenId) internal virtual {
1063         _burn(tokenId, false);
1064     }
1065 
1066     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1067         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1068 
1069         address from = address(uint160(prevOwnershipPacked));
1070 
1071         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1072 
1073         if (approvalCheck) {
1074             // The nested ifs save around 20+ gas over a compound boolean condition.
1075             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1076                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1077         }
1078 
1079         _beforeTokenTransfers(from, address(0), tokenId, 1);
1080 
1081         // Clear approvals from the previous owner.
1082         assembly {
1083             if approvedAddress {
1084                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1085                 sstore(approvedAddressSlot, 0)
1086             }
1087         }
1088 
1089         unchecked {
1090 
1091             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1092 
1093             _packedOwnerships[tokenId] = _packOwnershipData(
1094                 from,
1095                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1096             );
1097 
1098             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1099             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1100                 uint256 nextTokenId = tokenId + 1;
1101                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1102                 if (_packedOwnerships[nextTokenId] == 0) {
1103                     // If the next slot is within bounds.
1104                     if (nextTokenId != _currentIndex) {
1105                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1106                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1107                     }
1108                 }
1109             }
1110         }
1111 
1112         emit Transfer(from, address(0), tokenId);
1113         _afterTokenTransfers(from, address(0), tokenId, 1);
1114 
1115         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1116         unchecked {
1117             _burnCounter++;
1118         }
1119     }
1120 
1121     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1122         uint256 packed = _packedOwnerships[index];
1123         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1124         uint256 extraDataCasted;
1125         // Cast `extraData` with assembly to avoid redundant masking.
1126         assembly {
1127             extraDataCasted := extraData
1128         }
1129         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1130         _packedOwnerships[index] = packed;
1131     }
1132 
1133     function _extraData(
1134         address from,
1135         address to,
1136         uint24 previousExtraData
1137     ) internal view virtual returns (uint24) {}
1138 
1139     function _nextExtraData(
1140         address from,
1141         address to,
1142         uint256 prevOwnershipPacked
1143     ) private view returns (uint256) {
1144         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1145         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1146     }
1147 
1148     function _msgSenderERC721A() internal view virtual returns (address) {
1149         return msg.sender;
1150     }
1151 
1152     /**
1153      * @dev Converts a uint256 to its ASCII string decimal representation.
1154      */
1155     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1156         assembly {
1157             let m := add(mload(0x40), 0xa0)
1158             // Update the free memory pointer to allocate.
1159             mstore(0x40, m)
1160             // Assign the `str` to the end.
1161             str := sub(m, 0x20)
1162             // Zeroize the slot after the string.
1163             mstore(str, 0)
1164 
1165             // Cache the end of the memory to calculate the length later.
1166             let end := str
1167 
1168             // We write the string from rightmost digit to leftmost digit.
1169             // The following is essentially a do-while loop that also handles the zero case.
1170             // prettier-ignore
1171             for { let temp := value } 1 {} {
1172                 str := sub(str, 1)
1173                 // Write the character to the pointer.
1174                 // The ASCII index of the '0' character is 48.
1175                 mstore8(str, add(48, mod(temp, 10)))
1176                 // Keep dividing `temp` until zero.
1177                 temp := div(temp, 10)
1178                 // prettier-ignore
1179                 if iszero(temp) { break }
1180             }
1181 
1182             let length := sub(end, str)
1183             // Move the pointer 32 bytes leftwards to make room for the length!
1184             str := sub(str, 0x20)
1185             // Store the length.
1186             mstore(str, length)
1187         }
1188     }
1189 }
1190 
1191 //SPDX-License-Identifier: MIT
1192 
1193 pragma solidity ^0.8.19;
1194 contract CyberneticSyndicate  is ERC721A, Ownable, ReentrancyGuard {
1195 	using Strings for uint256;
1196 
1197 	uint256 public maxSupply = 10000;
1198     uint256 public maxFreeSupply = 10000;
1199 
1200     uint256 public cost = 0.0002 ether;
1201     uint256 public notPayableAmount = 4;
1202     uint256 public maxPerWallet = 120;
1203 
1204     bool public isRevealed = true;
1205 	bool public pause = true;
1206 
1207     string private baseURL = "";
1208     string public hiddenMetadataUrl = "REVEALED";
1209 
1210     mapping(address => uint256) public userBalance;
1211 
1212 	constructor(
1213         string memory _baseMetadataUrl
1214 	)
1215 	ERC721A("Cybernetic Syndicate", "CYBERSYNDICATE") {
1216         setBaseUri(_baseMetadataUrl);
1217     }
1218 
1219 	function _baseURI() internal view override returns (string memory) {
1220 		return baseURL;
1221 	}
1222 
1223     function setBaseUri(string memory _baseURL) public onlyOwner {
1224 	    baseURL = _baseURL;
1225 	}
1226 
1227     function mint(uint256 mintAmount) external payable {
1228 		require(!pause, "The sale is on pause");
1229         if(userBalance[msg.sender] >= notPayableAmount) require(msg.value >= cost * mintAmount, "Insufficient eth funds");
1230         else{
1231             if(totalSupply() + mintAmount <= maxFreeSupply){
1232                 if(mintAmount > (notPayableAmount - userBalance[msg.sender])) require(msg.value >= cost * (mintAmount - (notPayableAmount - userBalance[msg.sender])), "Insufficient funds");
1233             }
1234             else require(msg.value >= cost * mintAmount, "Insufficient eth funds");
1235         }
1236         require(_totalMinted() + mintAmount <= maxSupply,"Exceeds max supply");
1237         require(userBalance[msg.sender] + mintAmount <= maxPerWallet, "Exceeds max per wallet");
1238         _safeMint(msg.sender, mintAmount);
1239         userBalance[msg.sender] = userBalance[msg.sender] + mintAmount;
1240 	}
1241 
1242     function airdrop(address to, uint256 mintAmount) external onlyOwner {
1243 		require(
1244 			_totalMinted() + mintAmount <= maxSupply,
1245 			"Exceeds max supply"
1246 		);
1247 		_safeMint(to, mintAmount);
1248         
1249 	}
1250 
1251     function sethiddenMetadataUrl(string memory _hiddenMetadataUrl) public onlyOwner {
1252 	    hiddenMetadataUrl = _hiddenMetadataUrl;
1253 	}
1254 
1255     function reveal(bool _state) external onlyOwner {
1256 	    isRevealed = _state;
1257 	}
1258 
1259 	function _startTokenId() internal view virtual override returns (uint256) {
1260     	return 1;
1261   	}
1262 
1263 	function setMaxSupply(uint256 newMaxSupply) external onlyOwner {
1264 		maxSupply = newMaxSupply;
1265 	}
1266 
1267     function setMaxFreeSupply(uint256 newMaxFreeSupply) external onlyOwner {
1268 		maxFreeSupply = newMaxFreeSupply;
1269 	}
1270 
1271 	function tokenURI(uint256 tokenId)
1272 		public
1273 		view
1274 		override
1275 		returns (string memory)
1276 	{
1277         require(_exists(tokenId), "That token doesn't exist");
1278         if(isRevealed == false) {
1279             return hiddenMetadataUrl;
1280         }
1281         else return bytes(_baseURI()).length > 0 
1282             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1283             : "";
1284 	}
1285 
1286 	function setCost(uint256 _newCost) public onlyOwner{
1287 		cost = _newCost;
1288 	}
1289 
1290 	function setPause(bool _state) public onlyOwner{
1291 		pause = _state;
1292 	}
1293 
1294     function setNotPayableAmount(uint256 _newAmt) public onlyOwner{
1295         require(_newAmt < maxPerWallet, "Its Not possible");
1296         notPayableAmount = _newAmt;
1297     }
1298 
1299     function setMaxPerWallet(uint256 _newAmt) public  onlyOwner{
1300         require(_newAmt > notPayableAmount, "Its Not possible");
1301         maxPerWallet = _newAmt;
1302     }
1303 
1304 	function withdraw() external onlyOwner {
1305 		(bool success, ) = payable(owner()).call{
1306             value: address(this).balance
1307         }("");
1308         require(success);
1309 	}
1310 }