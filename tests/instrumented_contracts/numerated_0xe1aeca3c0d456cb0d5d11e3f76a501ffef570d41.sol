1 /***
2 
3 ORIGINAL ARTS "THE WICKED PUNKS" DEVELOPED BY THE WICKED STUDIO
4 
5 Twitter (X): https://twitter.com/TheWickedPunks
6 
7 © 2023 THE WICKED STUDIO
8 
9 STATUS: REVEALED
10 
11 Igne et Ossibus
12 
13 */
14 
15 
16 pragma solidity ^0.8.0;
17 abstract contract ReentrancyGuard {
18 
19     uint256 private constant _NOT_ENTERED = 1;
20     uint256 private constant _ENTERED = 2;
21 
22     uint256 private _status;
23 
24     constructor() {
25         _status = _NOT_ENTERED;
26     }
27 
28     modifier nonReentrant() {
29         _nonReentrantBefore();
30         _;
31         _nonReentrantAfter();
32     }
33 
34     function _nonReentrantBefore() private {
35         // On the first call to nonReentrant, _status will be _NOT_ENTERED
36         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
37 
38         // Any calls to nonReentrant after this point will fail
39         _status = _ENTERED;
40     }
41 
42     function _nonReentrantAfter() private {
43 
44         _status = _NOT_ENTERED;
45     }
46 }
47 
48 pragma solidity ^0.8.0;
49 
50 abstract contract Context {
51     function _msgSender() internal view virtual returns (address) {
52         return msg.sender;
53     }
54 
55     function _msgData() internal view virtual returns (bytes calldata) {
56         return msg.data;
57     }
58 }
59 
60 pragma solidity ^0.8.0;
61 
62 abstract contract Ownable is Context {
63     address private _owner;
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     constructor() {
68         _transferOwnership(_msgSender());
69     }
70 
71     modifier onlyOwner() {
72         _checkOwner();
73         _;
74     }
75 
76     function owner() public view virtual returns (address) {
77         return _owner;
78     }
79 
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _transferOwnership(newOwner);
91     }
92 
93     function _transferOwnership(address newOwner) internal virtual {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 pragma solidity ^0.8.0;
101 
102 library Math {
103     enum Rounding {
104         Down, // Toward negative infinity
105         Up, // Toward infinity
106         Zero // Toward zero
107     }
108 
109     function max(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a > b ? a : b;
111     }
112 
113     function min(uint256 a, uint256 b) internal pure returns (uint256) {
114         return a < b ? a : b;
115     }
116 
117     function average(uint256 a, uint256 b) internal pure returns (uint256) {
118         // (a + b) / 2 can overflow.
119         return (a & b) + (a ^ b) / 2;
120     }
121 
122     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
123         // (a + b - 1) / b can overflow on addition, so we distribute.
124         return a == 0 ? 0 : (a - 1) / b + 1;
125     }
126 
127     function mulDiv(
128         uint256 x,
129         uint256 y,
130         uint256 denominator
131     ) internal pure returns (uint256 result) {
132         unchecked {
133 
134             uint256 prod0; // Least significant 256 bits of the product
135             uint256 prod1; // Most significant 256 bits of the product
136             assembly {
137                 let mm := mulmod(x, y, not(0))
138                 prod0 := mul(x, y)
139                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
140             }
141 
142             // Handle non-overflow cases, 256 by 256 division.
143             if (prod1 == 0) {
144                 return prod0 / denominator;
145             }
146 
147             // Make sure the result is less than 2^256. Also prevents denominator == 0.
148             require(denominator > prod1);
149 
150             uint256 remainder;
151             assembly {
152                 // Compute remainder using mulmod.
153                 remainder := mulmod(x, y, denominator)
154 
155                 // Subtract 256 bit number from 512 bit number.
156                 prod1 := sub(prod1, gt(remainder, prod0))
157                 prod0 := sub(prod0, remainder)
158             }
159 
160             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
161             // See https://cs.stackexchange.com/q/138556/92363.
162 
163             // Does not overflow because the denominator cannot be zero at this stage in the function.
164             uint256 twos = denominator & (~denominator + 1);
165             assembly {
166                 // Divide denominator by twos.
167                 denominator := div(denominator, twos)
168 
169                 // Divide [prod1 prod0] by twos.
170                 prod0 := div(prod0, twos)
171 
172                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
173                 twos := add(div(sub(0, twos), twos), 1)
174             }
175 
176             // Shift in bits from prod1 into prod0.
177             prod0 |= prod1 * twos;
178             uint256 inverse = (3 * denominator) ^ 2;
179 
180             inverse *= 2 - denominator * inverse; // inverse mod 2^8
181             inverse *= 2 - denominator * inverse; // inverse mod 2^16
182             inverse *= 2 - denominator * inverse; // inverse mod 2^32
183             inverse *= 2 - denominator * inverse; // inverse mod 2^64
184             inverse *= 2 - denominator * inverse; // inverse mod 2^128
185             inverse *= 2 - denominator * inverse; // inverse mod 2^256
186             result = prod0 * inverse;
187             return result;
188         }
189     }
190 
191     function mulDiv(
192         uint256 x,
193         uint256 y,
194         uint256 denominator,
195         Rounding rounding
196     ) internal pure returns (uint256) {
197         uint256 result = mulDiv(x, y, denominator);
198         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
199             result += 1;
200         }
201         return result;
202     }
203 
204     function sqrt(uint256 a) internal pure returns (uint256) {
205         if (a == 0) {
206             return 0;
207         }
208 
209         uint256 result = 1 << (log2(a) >> 1);
210 
211         unchecked {
212             result = (result + a / result) >> 1;
213             result = (result + a / result) >> 1;
214             result = (result + a / result) >> 1;
215             result = (result + a / result) >> 1;
216             result = (result + a / result) >> 1;
217             result = (result + a / result) >> 1;
218             result = (result + a / result) >> 1;
219             return min(result, a / result);
220         }
221     }
222 
223     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
224         unchecked {
225             uint256 result = sqrt(a);
226             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
227         }
228     }
229 
230     function log2(uint256 value) internal pure returns (uint256) {
231         uint256 result = 0;
232         unchecked {
233             if (value >> 128 > 0) {
234                 value >>= 128;
235                 result += 128;
236             }
237             if (value >> 64 > 0) {
238                 value >>= 64;
239                 result += 64;
240             }
241             if (value >> 32 > 0) {
242                 value >>= 32;
243                 result += 32;
244             }
245             if (value >> 16 > 0) {
246                 value >>= 16;
247                 result += 16;
248             }
249             if (value >> 8 > 0) {
250                 value >>= 8;
251                 result += 8;
252             }
253             if (value >> 4 > 0) {
254                 value >>= 4;
255                 result += 4;
256             }
257             if (value >> 2 > 0) {
258                 value >>= 2;
259                 result += 2;
260             }
261             if (value >> 1 > 0) {
262                 result += 1;
263             }
264         }
265         return result;
266     }
267 
268     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
269         unchecked {
270             uint256 result = log2(value);
271             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
272         }
273     }
274 
275     function log10(uint256 value) internal pure returns (uint256) {
276         uint256 result = 0;
277         unchecked {
278             if (value >= 10**64) {
279                 value /= 10**64;
280                 result += 64;
281             }
282             if (value >= 10**32) {
283                 value /= 10**32;
284                 result += 32;
285             }
286             if (value >= 10**16) {
287                 value /= 10**16;
288                 result += 16;
289             }
290             if (value >= 10**8) {
291                 value /= 10**8;
292                 result += 8;
293             }
294             if (value >= 10**4) {
295                 value /= 10**4;
296                 result += 4;
297             }
298             if (value >= 10**2) {
299                 value /= 10**2;
300                 result += 2;
301             }
302             if (value >= 10**1) {
303                 result += 1;
304             }
305         }
306         return result;
307     }
308 
309     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
310         unchecked {
311             uint256 result = log10(value);
312             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
313         }
314     }
315 
316     function log256(uint256 value) internal pure returns (uint256) {
317         uint256 result = 0;
318         unchecked {
319             if (value >> 128 > 0) {
320                 value >>= 128;
321                 result += 16;
322             }
323             if (value >> 64 > 0) {
324                 value >>= 64;
325                 result += 8;
326             }
327             if (value >> 32 > 0) {
328                 value >>= 32;
329                 result += 4;
330             }
331             if (value >> 16 > 0) {
332                 value >>= 16;
333                 result += 2;
334             }
335             if (value >> 8 > 0) {
336                 result += 1;
337             }
338         }
339         return result;
340     }
341 
342     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
343         unchecked {
344             uint256 result = log256(value);
345             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
346         }
347     }
348 }
349 
350 pragma solidity ^0.8.0;
351 
352 library Strings {
353     bytes16 private constant _SYMBOLS = "0123456789abcdef";
354     uint8 private constant _ADDRESS_LENGTH = 20;
355 
356     /**
357      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
358      */
359     function toString(uint256 value) internal pure returns (string memory) {
360         unchecked {
361             uint256 length = Math.log10(value) + 1;
362             string memory buffer = new string(length);
363             uint256 ptr;
364             /// @solidity memory-safe-assembly
365             assembly {
366                 ptr := add(buffer, add(32, length))
367             }
368             while (true) {
369                 ptr--;
370                 /// @solidity memory-safe-assembly
371                 assembly {
372                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
373                 }
374                 value /= 10;
375                 if (value == 0) break;
376             }
377             return buffer;
378         }
379     }
380 
381     function toHexString(uint256 value) internal pure returns (string memory) {
382         unchecked {
383             return toHexString(value, Math.log256(value) + 1);
384         }
385     }
386 
387     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
388         bytes memory buffer = new bytes(2 * length + 2);
389         buffer[0] = "0";
390         buffer[1] = "x";
391         for (uint256 i = 2 * length + 1; i > 1; --i) {
392             buffer[i] = _SYMBOLS[value & 0xf];
393             value >>= 4;
394         }
395         require(value == 0, "Strings: hex length insufficient");
396         return string(buffer);
397     }
398 
399     function toHexString(address addr) internal pure returns (string memory) {
400         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
401     }
402 }
403 
404 // ERC721A Contracts v4.2.3
405 // Creator: Chiru Labs
406 
407 pragma solidity ^0.8.4;
408 
409 interface IERC721A {
410 
411     error ApprovalCallerNotOwnerNorApproved();
412 
413     error ApprovalQueryForNonexistentToken();
414 
415     error BalanceQueryForZeroAddress();
416 
417     error MintToZeroAddress();
418 
419     error MintZeroQuantity();
420 
421     error OwnerQueryForNonexistentToken();
422 
423     error TransferCallerNotOwnerNorApproved();
424 
425     error TransferFromIncorrectOwner();
426 
427     error TransferToNonERC721ReceiverImplementer();
428 
429     error TransferToZeroAddress();
430 
431     error URIQueryForNonexistentToken();
432 
433     error MintERC2309QuantityExceedsLimit();
434 
435     error OwnershipNotInitializedForExtraData();
436 
437     struct TokenOwnership {
438         // The address of the owner.
439         address addr;
440         // Stores the start time of ownership with minimal overhead for tokenomics.
441         uint64 startTimestamp;
442         // Whether the token has been burned.
443         bool burned;
444         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
445         uint24 extraData;
446     }
447 
448     function totalSupply() external view returns (uint256);
449 
450     function supportsInterface(bytes4 interfaceId) external view returns (bool);
451 
452     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
453 
454     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
455 
456     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
457 
458     function balanceOf(address owner) external view returns (uint256 balance);
459 
460     function ownerOf(uint256 tokenId) external view returns (address owner);
461 
462     function safeTransferFrom(
463         address from,
464         address to,
465         uint256 tokenId,
466         bytes calldata data
467     ) external payable;
468 
469     function safeTransferFrom(
470         address from,
471         address to,
472         uint256 tokenId
473     ) external payable;
474 
475     function transferFrom(
476         address from,
477         address to,
478         uint256 tokenId
479     ) external payable;
480 
481     function approve(address to, uint256 tokenId) external payable;
482     function setApprovalForAll(address operator, bool _approved) external;
483     function getApproved(uint256 tokenId) external view returns (address operator);
484     function isApprovedForAll(address owner, address operator) external view returns (bool);
485     function name() external view returns (string memory);
486     function symbol() external view returns (string memory);
487     function tokenURI(uint256 tokenId) external view returns (string memory);
488 
489     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
490 }
491 
492 // ERC721A Contracts v4.2.3
493 // Creator: Chiru Labs
494 
495 pragma solidity ^0.8.4;
496 
497 /**
498  * @dev Interface of ERC721 token receiver.
499  */
500 interface ERC721A__IERC721Receiver {
501     function onERC721Received(
502         address operator,
503         address from,
504         uint256 tokenId,
505         bytes calldata data
506     ) external returns (bytes4);
507 }
508 
509 contract ERC721A is IERC721A {
510     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
511     struct TokenApprovalRef {
512         address value;
513     }
514 
515     // Mask of an entry in packed address data.
516     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
517 
518     // The bit position of `numberMinted` in packed address data.
519     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
520 
521     // The bit position of `numberBurned` in packed address data.
522     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
523 
524     // The bit position of `aux` in packed address data.
525     uint256 private constant _BITPOS_AUX = 192;
526 
527     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
528     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
529 
530     // The bit position of `startTimestamp` in packed ownership.
531     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
532 
533     // The bit mask of the `burned` bit in packed ownership.
534     uint256 private constant _BITMASK_BURNED = 1 << 224;
535 
536     // The bit position of the `nextInitialized` bit in packed ownership.
537     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
538 
539     // The bit mask of the `nextInitialized` bit in packed ownership.
540     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
541 
542     // The bit position of `extraData` in packed ownership.
543     uint256 private constant _BITPOS_EXTRA_DATA = 232;
544 
545     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
546     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
547 
548     // The mask of the lower 160 bits for addresses.
549     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
550     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
551 
552     // The `Transfer` event signature is given by:
553     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
554     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
555         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
556 
557     uint256 private _currentIndex;
558 
559     // The number of tokens burned.
560     uint256 private _burnCounter;
561 
562     // Token name
563     string private _name;
564 
565     // Token symbol
566     string private _symbol;
567 
568     mapping(uint256 => uint256) private _packedOwnerships;
569     mapping(address => uint256) private _packedAddressData;
570     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
571     mapping(address => mapping(address => bool)) private _operatorApprovals;
572 
573     constructor(string memory name_, string memory symbol_) {
574         _name = name_;
575         _symbol = symbol_;
576         _currentIndex = _startTokenId();
577     }
578 
579     function _startTokenId() internal view virtual returns (uint256) {
580         return 0;
581     }
582 
583     function _nextTokenId() internal view virtual returns (uint256) {
584         return _currentIndex;
585     }
586 
587     function totalSupply() public view virtual override returns (uint256) {
588         // Counter underflow is impossible as _burnCounter cannot be incremented
589         // more than `_currentIndex - _startTokenId()` times.
590         unchecked {
591             return _currentIndex - _burnCounter - _startTokenId();
592         }
593     }
594 
595     function _totalMinted() internal view virtual returns (uint256) {
596         // Counter underflow is impossible as `_currentIndex` does not decrement,
597         // and it is initialized to `_startTokenId()`.
598         unchecked {
599             return _currentIndex - _startTokenId();
600         }
601     }
602 
603     function _totalBurned() internal view virtual returns (uint256) {
604         return _burnCounter;
605     }
606 
607     function balanceOf(address owner) public view virtual override returns (uint256) {
608         if (owner == address(0)) revert BalanceQueryForZeroAddress();
609         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
610     }
611 
612     function _numberMinted(address owner) internal view returns (uint256) {
613         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
614     }
615 
616     function _numberBurned(address owner) internal view returns (uint256) {
617         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
618     }
619 
620     function _getAux(address owner) internal view returns (uint64) {
621         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
622     }
623 
624     function _setAux(address owner, uint64 aux) internal virtual {
625         uint256 packed = _packedAddressData[owner];
626         uint256 auxCasted;
627         // Cast `aux` with assembly to avoid redundant masking.
628         assembly {
629             auxCasted := aux
630         }
631         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
632         _packedAddressData[owner] = packed;
633     }
634 
635     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
636 
637         return
638             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
639             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
640             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
641     }
642 
643     function name() public view virtual override returns (string memory) {
644         return _name;
645     }
646 
647     function symbol() public view virtual override returns (string memory) {
648         return _symbol;
649     }
650 
651     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
652         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
653 
654         string memory baseURI = _baseURI();
655         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
656     }
657 
658     function _baseURI() internal view virtual returns (string memory) {
659         return '';
660     }
661 
662     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
663         return address(uint160(_packedOwnershipOf(tokenId)));
664     }
665 
666     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
667         return _unpackedOwnership(_packedOwnershipOf(tokenId));
668     }
669 
670     /**
671      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
672      */
673     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
674         return _unpackedOwnership(_packedOwnerships[index]);
675     }
676 
677     /**
678      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
679      */
680     function _initializeOwnershipAt(uint256 index) internal virtual {
681         if (_packedOwnerships[index] == 0) {
682             _packedOwnerships[index] = _packedOwnershipOf(index);
683         }
684     }
685 
686     /**
687      * Returns the packed ownership data of `tokenId`.
688      */
689     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
690         uint256 curr = tokenId;
691 
692         unchecked {
693             if (_startTokenId() <= curr)
694                 if (curr < _currentIndex) {
695                     uint256 packed = _packedOwnerships[curr];
696                     // If not burned.
697                     if (packed & _BITMASK_BURNED == 0) {
698 
699                         while (packed == 0) {
700                             packed = _packedOwnerships[--curr];
701                         }
702                         return packed;
703                     }
704                 }
705         }
706         revert OwnerQueryForNonexistentToken();
707     }
708 
709     /**
710      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
711      */
712     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
713         ownership.addr = address(uint160(packed));
714         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
715         ownership.burned = packed & _BITMASK_BURNED != 0;
716         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
717     }
718 
719     /**
720      * @dev Packs ownership data into a single uint256.
721      */
722     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
723         assembly {
724             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
725             owner := and(owner, _BITMASK_ADDRESS)
726             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
727             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
728         }
729     }
730 
731     /**
732      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
733      */
734     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
735         // For branchless setting of the `nextInitialized` flag.
736         assembly {
737             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
738             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
739         }
740     }
741 
742     function approve(address to, uint256 tokenId) public payable virtual override {
743         address owner = ownerOf(tokenId);
744 
745         if (_msgSenderERC721A() != owner)
746             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
747                 revert ApprovalCallerNotOwnerNorApproved();
748             }
749 
750         _tokenApprovals[tokenId].value = to;
751         emit Approval(owner, to, tokenId);
752     }
753 
754     function getApproved(uint256 tokenId) public view virtual override returns (address) {
755         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
756 
757         return _tokenApprovals[tokenId].value;
758     }
759 
760     function setApprovalForAll(address operator, bool approved) public virtual override {
761         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
762         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
763     }
764 
765     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
766         return _operatorApprovals[owner][operator];
767     }
768 
769     function _exists(uint256 tokenId) internal view virtual returns (bool) {
770         return
771             _startTokenId() <= tokenId &&
772             tokenId < _currentIndex && // If within bounds,
773             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
774     }
775 
776     /**
777      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
778      */
779     function _isSenderApprovedOrOwner(
780         address approvedAddress,
781         address owner,
782         address msgSender
783     ) private pure returns (bool result) {
784         assembly {
785             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
786             owner := and(owner, _BITMASK_ADDRESS)
787             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
788             msgSender := and(msgSender, _BITMASK_ADDRESS)
789             // `msgSender == owner || msgSender == approvedAddress`.
790             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
791         }
792     }
793 
794     /**
795      * @dev Returns the storage slot and value for the approved address of `tokenId`.
796      */
797     function _getApprovedSlotAndAddress(uint256 tokenId)
798         private
799         view
800         returns (uint256 approvedAddressSlot, address approvedAddress)
801     {
802         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
803         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
804         assembly {
805             approvedAddressSlot := tokenApproval.slot
806             approvedAddress := sload(approvedAddressSlot)
807         }
808     }
809 
810     function transferFrom(
811         address from,
812         address to,
813         uint256 tokenId
814     ) public payable virtual override {
815         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
816 
817         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
818 
819         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
820 
821         // The nested ifs save around 20+ gas over a compound boolean condition.
822         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
823             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
824 
825         if (to == address(0)) revert TransferToZeroAddress();
826 
827         _beforeTokenTransfers(from, to, tokenId, 1);
828 
829         // Clear approvals from the previous owner.
830         assembly {
831             if approvedAddress {
832                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
833                 sstore(approvedAddressSlot, 0)
834             }
835         }
836 
837         unchecked {
838             // We can directly increment and decrement the balances.
839             --_packedAddressData[from]; // Updates: `balance -= 1`.
840             ++_packedAddressData[to]; // Updates: `balance += 1`.
841             _packedOwnerships[tokenId] = _packOwnershipData(
842                 to,
843                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
844             );
845 
846             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
847             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
848                 uint256 nextTokenId = tokenId + 1;
849                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
850                 if (_packedOwnerships[nextTokenId] == 0) {
851                     // If the next slot is within bounds.
852                     if (nextTokenId != _currentIndex) {
853                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
854                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
855                     }
856                 }
857             }
858         }
859 
860         emit Transfer(from, to, tokenId);
861         _afterTokenTransfers(from, to, tokenId, 1);
862     }
863 
864     /**
865      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
866      */
867     function safeTransferFrom(
868         address from,
869         address to,
870         uint256 tokenId
871     ) public payable virtual override {
872         safeTransferFrom(from, to, tokenId, '');
873     }
874 
875     function safeTransferFrom(
876         address from,
877         address to,
878         uint256 tokenId,
879         bytes memory _data
880     ) public payable virtual override {
881         transferFrom(from, to, tokenId);
882         if (to.code.length != 0)
883             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
884                 revert TransferToNonERC721ReceiverImplementer();
885             }
886     }
887 
888     function _beforeTokenTransfers(
889         address from,
890         address to,
891         uint256 startTokenId,
892         uint256 quantity
893     ) internal virtual {}
894 
895  
896     function _afterTokenTransfers(
897         address from,
898         address to,
899         uint256 startTokenId,
900         uint256 quantity
901     ) internal virtual {}
902 
903     function _checkContractOnERC721Received(
904         address from,
905         address to,
906         uint256 tokenId,
907         bytes memory _data
908     ) private returns (bool) {
909         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
910             bytes4 retval
911         ) {
912             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
913         } catch (bytes memory reason) {
914             if (reason.length == 0) {
915                 revert TransferToNonERC721ReceiverImplementer();
916             } else {
917                 assembly {
918                     revert(add(32, reason), mload(reason))
919                 }
920             }
921         }
922     }
923 
924     function _mint(address to, uint256 quantity) internal virtual {
925         uint256 startTokenId = _currentIndex;
926         if (quantity == 0) revert MintZeroQuantity();
927 
928         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
929 
930         unchecked {
931 
932             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
933 
934             _packedOwnerships[startTokenId] = _packOwnershipData(
935                 to,
936                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
937             );
938 
939             uint256 toMasked;
940             uint256 end = startTokenId + quantity;
941 
942             assembly {
943                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
944                 toMasked := and(to, _BITMASK_ADDRESS)
945                 // Emit the `Transfer` event.
946                 log4(
947                     0, // Start of data (0, since no data).
948                     0, // End of data (0, since no data).
949                     _TRANSFER_EVENT_SIGNATURE, // Signature.
950                     0, // `address(0)`.
951                     toMasked, // `to`.
952                     startTokenId // `tokenId`.
953                 )
954 
955                 for {
956                     let tokenId := add(startTokenId, 1)
957                 } iszero(eq(tokenId, end)) {
958                     tokenId := add(tokenId, 1)
959                 } {
960                     // Emit the `Transfer` event. Similar to above.
961                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
962                 }
963             }
964             if (toMasked == 0) revert MintToZeroAddress();
965 
966             _currentIndex = end;
967         }
968         _afterTokenTransfers(address(0), to, startTokenId, quantity);
969     }
970 
971     function _mintERC2309(address to, uint256 quantity) internal virtual {
972         uint256 startTokenId = _currentIndex;
973         if (to == address(0)) revert MintToZeroAddress();
974         if (quantity == 0) revert MintZeroQuantity();
975         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
976 
977         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
978 
979         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
980         unchecked {
981 
982             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
983 
984             _packedOwnerships[startTokenId] = _packOwnershipData(
985                 to,
986                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
987             );
988 
989             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
990 
991             _currentIndex = startTokenId + quantity;
992         }
993         _afterTokenTransfers(address(0), to, startTokenId, quantity);
994     }
995 
996     function _safeMint(
997         address to,
998         uint256 quantity,
999         bytes memory _data
1000     ) internal virtual {
1001         _mint(to, quantity);
1002 
1003         unchecked {
1004             if (to.code.length != 0) {
1005                 uint256 end = _currentIndex;
1006                 uint256 index = end - quantity;
1007                 do {
1008                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1009                         revert TransferToNonERC721ReceiverImplementer();
1010                     }
1011                 } while (index < end);
1012                 // Reentrancy protection.
1013                 if (_currentIndex != end) revert();
1014             }
1015         }
1016     }
1017 
1018     function _safeMint(address to, uint256 quantity) internal virtual {
1019         _safeMint(to, quantity, '');
1020     }
1021 
1022     function _burn(uint256 tokenId) internal virtual {
1023         _burn(tokenId, false);
1024     }
1025 
1026     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1027         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1028 
1029         address from = address(uint160(prevOwnershipPacked));
1030 
1031         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1032 
1033         if (approvalCheck) {
1034             // The nested ifs save around 20+ gas over a compound boolean condition.
1035             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1036                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1037         }
1038 
1039         _beforeTokenTransfers(from, address(0), tokenId, 1);
1040 
1041         // Clear approvals from the previous owner.
1042         assembly {
1043             if approvedAddress {
1044                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1045                 sstore(approvedAddressSlot, 0)
1046             }
1047         }
1048 
1049         unchecked {
1050 
1051             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1052 
1053             _packedOwnerships[tokenId] = _packOwnershipData(
1054                 from,
1055                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1056             );
1057 
1058             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1059             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1060                 uint256 nextTokenId = tokenId + 1;
1061                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1062                 if (_packedOwnerships[nextTokenId] == 0) {
1063                     // If the next slot is within bounds.
1064                     if (nextTokenId != _currentIndex) {
1065                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1066                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1067                     }
1068                 }
1069             }
1070         }
1071 
1072         emit Transfer(from, address(0), tokenId);
1073         _afterTokenTransfers(from, address(0), tokenId, 1);
1074 
1075         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1076         unchecked {
1077             _burnCounter++;
1078         }
1079     }
1080 
1081     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1082         uint256 packed = _packedOwnerships[index];
1083         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1084         uint256 extraDataCasted;
1085         // Cast `extraData` with assembly to avoid redundant masking.
1086         assembly {
1087             extraDataCasted := extraData
1088         }
1089         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1090         _packedOwnerships[index] = packed;
1091     }
1092 
1093     function _extraData(
1094         address from,
1095         address to,
1096         uint24 previousExtraData
1097     ) internal view virtual returns (uint24) {}
1098 
1099     function _nextExtraData(
1100         address from,
1101         address to,
1102         uint256 prevOwnershipPacked
1103     ) private view returns (uint256) {
1104         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1105         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1106     }
1107 
1108     function _msgSenderERC721A() internal view virtual returns (address) {
1109         return msg.sender;
1110     }
1111 
1112     /**
1113      * @dev Converts a uint256 to its ASCII string decimal representation.
1114      */
1115     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1116         assembly {
1117             let m := add(mload(0x40), 0xa0)
1118             // Update the free memory pointer to allocate.
1119             mstore(0x40, m)
1120             // Assign the `str` to the end.
1121             str := sub(m, 0x20)
1122             // Zeroize the slot after the string.
1123             mstore(str, 0)
1124 
1125             // Cache the end of the memory to calculate the length later.
1126             let end := str
1127 
1128             // We write the string from rightmost digit to leftmost digit.
1129             // The following is essentially a do-while loop that also handles the zero case.
1130             // prettier-ignore
1131             for { let temp := value } 1 {} {
1132                 str := sub(str, 1)
1133                 // Write the character to the pointer.
1134                 // The ASCII index of the '0' character is 48.
1135                 mstore8(str, add(48, mod(temp, 10)))
1136                 // Keep dividing `temp` until zero.
1137                 temp := div(temp, 10)
1138                 // prettier-ignore
1139                 if iszero(temp) { break }
1140             }
1141 
1142             let length := sub(end, str)
1143             // Move the pointer 32 bytes leftwards to make room for the length.
1144             str := sub(str, 0x20)
1145             // Store the length.
1146             mstore(str, length)
1147         }
1148     }
1149 }
1150 
1151 //SPDX-License-Identifier: MIT
1152 
1153 pragma solidity ^0.8.19;
1154 contract TheWickedPunks  is ERC721A, Ownable, ReentrancyGuard {
1155 	using Strings for uint256;
1156 
1157 	uint256 public maxSupply = 6666;
1158     uint256 public maxFreeSupply = 6666;
1159 
1160     uint256 public cost = 0.0005 ether;
1161     uint256 public notPayableAmount = 5;
1162     uint256 public maxPerWallet = 110;
1163 
1164     bool public isRevealed = true;
1165 	bool public pause = false;
1166 
1167     string private baseURL = "";
1168     string public hiddenMetadataUrl = "REVEALED";
1169 
1170     mapping(address => uint256) public userBalance;
1171 
1172 	constructor(
1173         string memory _baseMetadataUrl
1174 	)
1175 	ERC721A("The Wicked Punks", "WICKEDPUNKS") {
1176         setBaseUri(_baseMetadataUrl);
1177     }
1178 
1179 	function _baseURI() internal view override returns (string memory) {
1180 		return baseURL;
1181 	}
1182 
1183     function setBaseUri(string memory _baseURL) public onlyOwner {
1184 	    baseURL = _baseURL;
1185 	}
1186 
1187     function mint(uint256 mintAmount) external payable {
1188 		require(!pause, "Sale is on pause");
1189         if(userBalance[msg.sender] >= notPayableAmount) require(msg.value >= cost * mintAmount, "Insufficient eth funds");
1190         else{
1191             if(totalSupply() + mintAmount <= maxFreeSupply){
1192                 if(mintAmount > (notPayableAmount - userBalance[msg.sender])) require(msg.value >= cost * (mintAmount - (notPayableAmount - userBalance[msg.sender])), "Insufficient funds");
1193             }
1194             else require(msg.value >= cost * mintAmount, "Insufficient eth funds");
1195         }
1196         require(_totalMinted() + mintAmount <= maxSupply,"Exceeds max supply");
1197         require(userBalance[msg.sender] + mintAmount <= maxPerWallet, "Exceeds max per wallet");
1198         _safeMint(msg.sender, mintAmount);
1199         userBalance[msg.sender] = userBalance[msg.sender] + mintAmount;
1200 	}
1201 
1202     function airdrop(address to, uint256 mintAmount) external onlyOwner {
1203 		require(
1204 			_totalMinted() + mintAmount <= maxSupply,
1205 			"Exceeds max supply"
1206 		);
1207 		_safeMint(to, mintAmount);
1208         
1209 	}
1210 
1211     function sethiddenMetadataUrl(string memory _hiddenMetadataUrl) public onlyOwner {
1212 	    hiddenMetadataUrl = _hiddenMetadataUrl;
1213 	}
1214 
1215     function reveal(bool _state) external onlyOwner {
1216 	    isRevealed = _state;
1217 	}
1218 
1219 	function _startTokenId() internal view virtual override returns (uint256) {
1220     	return 1;
1221   	}
1222 
1223 	function setMaxSupply(uint256 newMaxSupply) external onlyOwner {
1224 		maxSupply = newMaxSupply;
1225 	}
1226 
1227     function setMaxFreeSupply(uint256 newMaxFreeSupply) external onlyOwner {
1228 		maxFreeSupply = newMaxFreeSupply;
1229 	}
1230 
1231 	function tokenURI(uint256 tokenId)
1232 		public
1233 		view
1234 		override
1235 		returns (string memory)
1236 	{
1237         require(_exists(tokenId), "That token doesn't exist");
1238         if(isRevealed == false) {
1239             return hiddenMetadataUrl;
1240         }
1241         else return bytes(_baseURI()).length > 0 
1242             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1243             : "";
1244 	}
1245 
1246 	function setCost(uint256 _newCost) public onlyOwner{
1247 		cost = _newCost;
1248 	}
1249 
1250 	function setPause(bool _state) public onlyOwner{
1251 		pause = _state;
1252 	}
1253 
1254     function setNotPayableAmount(uint256 _newAmt) public onlyOwner{
1255         require(_newAmt < maxPerWallet, "Its Not possible");
1256         notPayableAmount = _newAmt;
1257     }
1258 
1259     function setMaxPerWallet(uint256 _newAmt) public  onlyOwner{
1260         require(_newAmt > notPayableAmount, "Its Not possible");
1261         maxPerWallet = _newAmt;
1262     }
1263 
1264 	function withdraw() external onlyOwner {
1265 		(bool success, ) = payable(owner()).call{
1266             value: address(this).balance
1267         }("");
1268         require(success);
1269 	}
1270 }