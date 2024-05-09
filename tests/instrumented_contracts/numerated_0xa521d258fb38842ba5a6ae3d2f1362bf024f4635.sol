1 /**
2 
3 In a world ravaged by nuclear catastrophe, Pepe stands as the last survivor. 
4 Alone in a desolate wasteland where the remnants of civilization lie in ruin, he navigates the ashen landscape, 
5 searching for signs of life or a glimmer of hope. Surrounded by the echoes of a once-thriving world, 
6 Pepe's journey is a testament to the enduring spirit of resilience. Fueled by whatever alcohol he can find, 
7 he embarks on a journey of survival, with hallucinogenic mushrooms as his companions. 
8 Yet, the wealth he possesses means nothing in this bleak reality, for there is no one to share it with. 
9 It's a tale of solitude and survival in a world where all is lifeless and still, a narrative of The Last Pepe.
10 
11 */
12 
13 pragma solidity ^0.8.0;
14 abstract contract ReentrancyGuard {
15 
16     uint256 private constant _NOT_ENTERED = 1;
17     uint256 private constant _ENTERED = 2;
18 
19     uint256 private _status;
20 
21     constructor() {
22         _status = _NOT_ENTERED;
23     }
24 
25     modifier nonReentrant() {
26         _nonReentrantBefore();
27         _;
28         _nonReentrantAfter();
29     }
30 
31     function _nonReentrantBefore() private {
32         // On the first call to nonReentrant, _status will be _NOT_ENTERED
33         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
34 
35         // Any calls to nonReentrant after this point will fail
36         _status = _ENTERED;
37     }
38 
39     function _nonReentrantAfter() private {
40 
41         _status = _NOT_ENTERED;
42     }
43 }
44 
45 pragma solidity ^0.8.0;
46 
47 abstract contract Context {
48     function _msgSender() internal view virtual returns (address) {
49         return msg.sender;
50     }
51 
52     function _msgData() internal view virtual returns (bytes calldata) {
53         return msg.data;
54     }
55 }
56 
57 pragma solidity ^0.8.0;
58 
59 abstract contract Ownable is Context {
60     address private _owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     constructor() {
65         _transferOwnership(_msgSender());
66     }
67 
68     modifier onlyOwner() {
69         _checkOwner();
70         _;
71     }
72 
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     function _checkOwner() internal view virtual {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79     }
80 
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         _transferOwnership(newOwner);
88     }
89 
90     function _transferOwnership(address newOwner) internal virtual {
91         address oldOwner = _owner;
92         _owner = newOwner;
93         emit OwnershipTransferred(oldOwner, newOwner);
94     }
95 }
96 
97 pragma solidity ^0.8.0;
98 
99 library Math {
100     enum Rounding {
101         Down, // Toward negative infinity
102         Up, // Toward infinity
103         Zero // Toward zero
104     }
105 
106     function max(uint256 a, uint256 b) internal pure returns (uint256) {
107         return a > b ? a : b;
108     }
109 
110     function min(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a < b ? a : b;
112     }
113 
114     function average(uint256 a, uint256 b) internal pure returns (uint256) {
115         // (a + b) / 2 can overflow.
116         return (a & b) + (a ^ b) / 2;
117     }
118 
119     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
120         // (a + b - 1) / b can overflow on addition, so we distribute.
121         return a == 0 ? 0 : (a - 1) / b + 1;
122     }
123 
124     function mulDiv(
125         uint256 x,
126         uint256 y,
127         uint256 denominator
128     ) internal pure returns (uint256 result) {
129         unchecked {
130 
131             uint256 prod0; // Least significant 256 bits of the product
132             uint256 prod1; // Most significant 256 bits of the product
133             assembly {
134                 let mm := mulmod(x, y, not(0))
135                 prod0 := mul(x, y)
136                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
137             }
138 
139             // Handle non-overflow cases, 256 by 256 division.
140             if (prod1 == 0) {
141                 return prod0 / denominator;
142             }
143 
144             // Make sure the result is less than 2^256. Also prevents denominator == 0.
145             require(denominator > prod1);
146 
147             uint256 remainder;
148             assembly {
149                 // Compute remainder using mulmod.
150                 remainder := mulmod(x, y, denominator)
151 
152                 // Subtract 256 bit number from 512 bit number.
153                 prod1 := sub(prod1, gt(remainder, prod0))
154                 prod0 := sub(prod0, remainder)
155             }
156 
157             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
158             // See https://cs.stackexchange.com/q/138556/92363.
159 
160             // Does not overflow because the denominator cannot be zero at this stage in the function.
161             uint256 twos = denominator & (~denominator + 1);
162             assembly {
163                 // Divide denominator by twos.
164                 denominator := div(denominator, twos)
165 
166                 // Divide [prod1 prod0] by twos.
167                 prod0 := div(prod0, twos)
168 
169                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
170                 twos := add(div(sub(0, twos), twos), 1)
171             }
172 
173             // Shift in bits from prod1 into prod0.
174             prod0 |= prod1 * twos;
175             uint256 inverse = (3 * denominator) ^ 2;
176 
177             inverse *= 2 - denominator * inverse; // inverse mod 2^8
178             inverse *= 2 - denominator * inverse; // inverse mod 2^16
179             inverse *= 2 - denominator * inverse; // inverse mod 2^32
180             inverse *= 2 - denominator * inverse; // inverse mod 2^64
181             inverse *= 2 - denominator * inverse; // inverse mod 2^128
182             inverse *= 2 - denominator * inverse; // inverse mod 2^256
183             result = prod0 * inverse;
184             return result;
185         }
186     }
187 
188     function mulDiv(
189         uint256 x,
190         uint256 y,
191         uint256 denominator,
192         Rounding rounding
193     ) internal pure returns (uint256) {
194         uint256 result = mulDiv(x, y, denominator);
195         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
196             result += 1;
197         }
198         return result;
199     }
200 
201     function sqrt(uint256 a) internal pure returns (uint256) {
202         if (a == 0) {
203             return 0;
204         }
205 
206         uint256 result = 1 << (log2(a) >> 1);
207 
208         unchecked {
209             result = (result + a / result) >> 1;
210             result = (result + a / result) >> 1;
211             result = (result + a / result) >> 1;
212             result = (result + a / result) >> 1;
213             result = (result + a / result) >> 1;
214             result = (result + a / result) >> 1;
215             result = (result + a / result) >> 1;
216             return min(result, a / result);
217         }
218     }
219 
220     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
221         unchecked {
222             uint256 result = sqrt(a);
223             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
224         }
225     }
226 
227     function log2(uint256 value) internal pure returns (uint256) {
228         uint256 result = 0;
229         unchecked {
230             if (value >> 128 > 0) {
231                 value >>= 128;
232                 result += 128;
233             }
234             if (value >> 64 > 0) {
235                 value >>= 64;
236                 result += 64;
237             }
238             if (value >> 32 > 0) {
239                 value >>= 32;
240                 result += 32;
241             }
242             if (value >> 16 > 0) {
243                 value >>= 16;
244                 result += 16;
245             }
246             if (value >> 8 > 0) {
247                 value >>= 8;
248                 result += 8;
249             }
250             if (value >> 4 > 0) {
251                 value >>= 4;
252                 result += 4;
253             }
254             if (value >> 2 > 0) {
255                 value >>= 2;
256                 result += 2;
257             }
258             if (value >> 1 > 0) {
259                 result += 1;
260             }
261         }
262         return result;
263     }
264 
265     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
266         unchecked {
267             uint256 result = log2(value);
268             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
269         }
270     }
271 
272     function log10(uint256 value) internal pure returns (uint256) {
273         uint256 result = 0;
274         unchecked {
275             if (value >= 10**64) {
276                 value /= 10**64;
277                 result += 64;
278             }
279             if (value >= 10**32) {
280                 value /= 10**32;
281                 result += 32;
282             }
283             if (value >= 10**16) {
284                 value /= 10**16;
285                 result += 16;
286             }
287             if (value >= 10**8) {
288                 value /= 10**8;
289                 result += 8;
290             }
291             if (value >= 10**4) {
292                 value /= 10**4;
293                 result += 4;
294             }
295             if (value >= 10**2) {
296                 value /= 10**2;
297                 result += 2;
298             }
299             if (value >= 10**1) {
300                 result += 1;
301             }
302         }
303         return result;
304     }
305 
306     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
307         unchecked {
308             uint256 result = log10(value);
309             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
310         }
311     }
312 
313     function log256(uint256 value) internal pure returns (uint256) {
314         uint256 result = 0;
315         unchecked {
316             if (value >> 128 > 0) {
317                 value >>= 128;
318                 result += 16;
319             }
320             if (value >> 64 > 0) {
321                 value >>= 64;
322                 result += 8;
323             }
324             if (value >> 32 > 0) {
325                 value >>= 32;
326                 result += 4;
327             }
328             if (value >> 16 > 0) {
329                 value >>= 16;
330                 result += 2;
331             }
332             if (value >> 8 > 0) {
333                 result += 1;
334             }
335         }
336         return result;
337     }
338 
339     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
340         unchecked {
341             uint256 result = log256(value);
342             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
343         }
344     }
345 }
346 
347 pragma solidity ^0.8.0;
348 
349 library Strings {
350     bytes16 private constant _SYMBOLS = "0123456789abcdef";
351     uint8 private constant _ADDRESS_LENGTH = 20;
352 
353     /**
354      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
355      */
356     function toString(uint256 value) internal pure returns (string memory) {
357         unchecked {
358             uint256 length = Math.log10(value) + 1;
359             string memory buffer = new string(length);
360             uint256 ptr;
361             /// @solidity memory-safe-assembly
362             assembly {
363                 ptr := add(buffer, add(32, length))
364             }
365             while (true) {
366                 ptr--;
367                 /// @solidity memory-safe-assembly
368                 assembly {
369                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
370                 }
371                 value /= 10;
372                 if (value == 0) break;
373             }
374             return buffer;
375         }
376     }
377 
378     function toHexString(uint256 value) internal pure returns (string memory) {
379         unchecked {
380             return toHexString(value, Math.log256(value) + 1);
381         }
382     }
383 
384     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
385         bytes memory buffer = new bytes(2 * length + 2);
386         buffer[0] = "0";
387         buffer[1] = "x";
388         for (uint256 i = 2 * length + 1; i > 1; --i) {
389             buffer[i] = _SYMBOLS[value & 0xf];
390             value >>= 4;
391         }
392         require(value == 0, "Strings: hex length insufficient");
393         return string(buffer);
394     }
395 
396     function toHexString(address addr) internal pure returns (string memory) {
397         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
398     }
399 }
400 
401 // ERC721A Contracts v4.2.3
402 // Creator: Chiru Labs
403 
404 pragma solidity ^0.8.4;
405 
406 interface IERC721A {
407 
408     error ApprovalCallerNotOwnerNorApproved();
409 
410     error ApprovalQueryForNonexistentToken();
411 
412     error BalanceQueryForZeroAddress();
413 
414     error MintToZeroAddress();
415 
416     error MintZeroQuantity();
417 
418     error OwnerQueryForNonexistentToken();
419 
420     error TransferCallerNotOwnerNorApproved();
421 
422     error TransferFromIncorrectOwner();
423 
424     error TransferToNonERC721ReceiverImplementer();
425 
426     error TransferToZeroAddress();
427 
428     error URIQueryForNonexistentToken();
429 
430     error MintERC2309QuantityExceedsLimit();
431 
432     error OwnershipNotInitializedForExtraData();
433 
434     struct TokenOwnership {
435         // The address of the owner.
436         address addr;
437         // Stores the start time of ownership with minimal overhead for tokenomics.
438         uint64 startTimestamp;
439         // Whether the token has been burned.
440         bool burned;
441         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
442         uint24 extraData;
443     }
444 
445     function totalSupply() external view returns (uint256);
446 
447     function supportsInterface(bytes4 interfaceId) external view returns (bool);
448 
449     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
450 
451     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
452 
453     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
454 
455     function balanceOf(address owner) external view returns (uint256 balance);
456 
457     function ownerOf(uint256 tokenId) external view returns (address owner);
458 
459     function safeTransferFrom(
460         address from,
461         address to,
462         uint256 tokenId,
463         bytes calldata data
464     ) external payable;
465 
466     function safeTransferFrom(
467         address from,
468         address to,
469         uint256 tokenId
470     ) external payable;
471 
472     function transferFrom(
473         address from,
474         address to,
475         uint256 tokenId
476     ) external payable;
477 
478     function approve(address to, uint256 tokenId) external payable;
479     function setApprovalForAll(address operator, bool _approved) external;
480     function getApproved(uint256 tokenId) external view returns (address operator);
481     function isApprovedForAll(address owner, address operator) external view returns (bool);
482     function name() external view returns (string memory);
483     function symbol() external view returns (string memory);
484     function tokenURI(uint256 tokenId) external view returns (string memory);
485 
486     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
487 }
488 
489 // ERC721A Contracts v4.2.3
490 // Creator: Chiru Labs
491 
492 pragma solidity ^0.8.4;
493 
494 /**
495  * @dev Interface of ERC721 token receiver.
496  */
497 interface ERC721A__IERC721Receiver {
498     function onERC721Received(
499         address operator,
500         address from,
501         uint256 tokenId,
502         bytes calldata data
503     ) external returns (bytes4);
504 }
505 
506 contract ERC721A is IERC721A {
507     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
508     struct TokenApprovalRef {
509         address value;
510     }
511 
512     // Mask of an entry in packed address data.
513     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
514 
515     // The bit position of `numberMinted` in packed address data.
516     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
517 
518     // The bit position of `numberBurned` in packed address data.
519     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
520 
521     // The bit position of `aux` in packed address data.
522     uint256 private constant _BITPOS_AUX = 192;
523 
524     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
525     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
526 
527     // The bit position of `startTimestamp` in packed ownership.
528     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
529 
530     // The bit mask of the `burned` bit in packed ownership.
531     uint256 private constant _BITMASK_BURNED = 1 << 224;
532 
533     // The bit position of the `nextInitialized` bit in packed ownership.
534     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
535 
536     // The bit mask of the `nextInitialized` bit in packed ownership.
537     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
538 
539     // The bit position of `extraData` in packed ownership.
540     uint256 private constant _BITPOS_EXTRA_DATA = 232;
541 
542     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
543     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
544 
545     // The mask of the lower 160 bits for addresses.
546     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
547     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
548 
549     // The `Transfer` event signature is given by:
550     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
551     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
552         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
553 
554     uint256 private _currentIndex;
555 
556     // The number of tokens burned.
557     uint256 private _burnCounter;
558 
559     // Token name
560     string private _name;
561 
562     // Token symbol
563     string private _symbol;
564 
565     mapping(uint256 => uint256) private _packedOwnerships;
566     mapping(address => uint256) private _packedAddressData;
567     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
568     mapping(address => mapping(address => bool)) private _operatorApprovals;
569 
570     constructor(string memory name_, string memory symbol_) {
571         _name = name_;
572         _symbol = symbol_;
573         _currentIndex = _startTokenId();
574     }
575 
576     function _startTokenId() internal view virtual returns (uint256) {
577         return 0;
578     }
579 
580     function _nextTokenId() internal view virtual returns (uint256) {
581         return _currentIndex;
582     }
583 
584     function totalSupply() public view virtual override returns (uint256) {
585         // Counter underflow is impossible as _burnCounter cannot be incremented
586         // more than `_currentIndex - _startTokenId()` times.
587         unchecked {
588             return _currentIndex - _burnCounter - _startTokenId();
589         }
590     }
591 
592     function _totalMinted() internal view virtual returns (uint256) {
593         // Counter underflow is impossible as `_currentIndex` does not decrement,
594         // and it is initialized to `_startTokenId()`.
595         unchecked {
596             return _currentIndex - _startTokenId();
597         }
598     }
599 
600     function _totalBurned() internal view virtual returns (uint256) {
601         return _burnCounter;
602     }
603 
604     function balanceOf(address owner) public view virtual override returns (uint256) {
605         if (owner == address(0)) revert BalanceQueryForZeroAddress();
606         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
607     }
608 
609     function _numberMinted(address owner) internal view returns (uint256) {
610         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
611     }
612 
613     function _numberBurned(address owner) internal view returns (uint256) {
614         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
615     }
616 
617     function _getAux(address owner) internal view returns (uint64) {
618         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
619     }
620 
621     function _setAux(address owner, uint64 aux) internal virtual {
622         uint256 packed = _packedAddressData[owner];
623         uint256 auxCasted;
624         // Cast `aux` with assembly to avoid redundant masking.
625         assembly {
626             auxCasted := aux
627         }
628         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
629         _packedAddressData[owner] = packed;
630     }
631 
632     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
633 
634         return
635             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
636             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
637             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
638     }
639 
640     function name() public view virtual override returns (string memory) {
641         return _name;
642     }
643 
644     function symbol() public view virtual override returns (string memory) {
645         return _symbol;
646     }
647 
648     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
649         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
650 
651         string memory baseURI = _baseURI();
652         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
653     }
654 
655     function _baseURI() internal view virtual returns (string memory) {
656         return '';
657     }
658 
659     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
660         return address(uint160(_packedOwnershipOf(tokenId)));
661     }
662 
663     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
664         return _unpackedOwnership(_packedOwnershipOf(tokenId));
665     }
666 
667     /**
668      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
669      */
670     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
671         return _unpackedOwnership(_packedOwnerships[index]);
672     }
673 
674     /**
675      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
676      */
677     function _initializeOwnershipAt(uint256 index) internal virtual {
678         if (_packedOwnerships[index] == 0) {
679             _packedOwnerships[index] = _packedOwnershipOf(index);
680         }
681     }
682 
683     /**
684      * Returns the packed ownership data of `tokenId`.
685      */
686     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
687         uint256 curr = tokenId;
688 
689         unchecked {
690             if (_startTokenId() <= curr)
691                 if (curr < _currentIndex) {
692                     uint256 packed = _packedOwnerships[curr];
693                     // If not burned.
694                     if (packed & _BITMASK_BURNED == 0) {
695 
696                         while (packed == 0) {
697                             packed = _packedOwnerships[--curr];
698                         }
699                         return packed;
700                     }
701                 }
702         }
703         revert OwnerQueryForNonexistentToken();
704     }
705 
706     /**
707      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
708      */
709     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
710         ownership.addr = address(uint160(packed));
711         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
712         ownership.burned = packed & _BITMASK_BURNED != 0;
713         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
714     }
715 
716     /**
717      * @dev Packs ownership data into a single uint256.
718      */
719     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
720         assembly {
721             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
722             owner := and(owner, _BITMASK_ADDRESS)
723             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
724             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
725         }
726     }
727 
728     /**
729      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
730      */
731     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
732         // For branchless setting of the `nextInitialized` flag.
733         assembly {
734             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
735             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
736         }
737     }
738 
739     function approve(address to, uint256 tokenId) public payable virtual override {
740         address owner = ownerOf(tokenId);
741 
742         if (_msgSenderERC721A() != owner)
743             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
744                 revert ApprovalCallerNotOwnerNorApproved();
745             }
746 
747         _tokenApprovals[tokenId].value = to;
748         emit Approval(owner, to, tokenId);
749     }
750 
751     function getApproved(uint256 tokenId) public view virtual override returns (address) {
752         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
753 
754         return _tokenApprovals[tokenId].value;
755     }
756 
757     function setApprovalForAll(address operator, bool approved) public virtual override {
758         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
759         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
760     }
761 
762     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
763         return _operatorApprovals[owner][operator];
764     }
765 
766     function _exists(uint256 tokenId) internal view virtual returns (bool) {
767         return
768             _startTokenId() <= tokenId &&
769             tokenId < _currentIndex && // If within bounds,
770             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
771     }
772 
773     /**
774      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
775      */
776     function _isSenderApprovedOrOwner(
777         address approvedAddress,
778         address owner,
779         address msgSender
780     ) private pure returns (bool result) {
781         assembly {
782             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
783             owner := and(owner, _BITMASK_ADDRESS)
784             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
785             msgSender := and(msgSender, _BITMASK_ADDRESS)
786             // `msgSender == owner || msgSender == approvedAddress`.
787             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
788         }
789     }
790 
791     /**
792      * @dev Returns the storage slot and value for the approved address of `tokenId`.
793      */
794     function _getApprovedSlotAndAddress(uint256 tokenId)
795         private
796         view
797         returns (uint256 approvedAddressSlot, address approvedAddress)
798     {
799         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
800         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
801         assembly {
802             approvedAddressSlot := tokenApproval.slot
803             approvedAddress := sload(approvedAddressSlot)
804         }
805     }
806 
807     function transferFrom(
808         address from,
809         address to,
810         uint256 tokenId
811     ) public payable virtual override {
812         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
813 
814         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
815 
816         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
817 
818         // The nested ifs save around 20+ gas over a compound boolean condition.
819         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
820             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
821 
822         if (to == address(0)) revert TransferToZeroAddress();
823 
824         _beforeTokenTransfers(from, to, tokenId, 1);
825 
826         // Clear approvals from the previous owner.
827         assembly {
828             if approvedAddress {
829                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
830                 sstore(approvedAddressSlot, 0)
831             }
832         }
833 
834         unchecked {
835             // We can directly increment and decrement the balances.
836             --_packedAddressData[from]; // Updates: `balance -= 1`.
837             ++_packedAddressData[to]; // Updates: `balance += 1`.
838             _packedOwnerships[tokenId] = _packOwnershipData(
839                 to,
840                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
841             );
842 
843             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
844             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
845                 uint256 nextTokenId = tokenId + 1;
846                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
847                 if (_packedOwnerships[nextTokenId] == 0) {
848                     // If the next slot is within bounds.
849                     if (nextTokenId != _currentIndex) {
850                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
851                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
852                     }
853                 }
854             }
855         }
856 
857         emit Transfer(from, to, tokenId);
858         _afterTokenTransfers(from, to, tokenId, 1);
859     }
860 
861     /**
862      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
863      */
864     function safeTransferFrom(
865         address from,
866         address to,
867         uint256 tokenId
868     ) public payable virtual override {
869         safeTransferFrom(from, to, tokenId, '');
870     }
871 
872     function safeTransferFrom(
873         address from,
874         address to,
875         uint256 tokenId,
876         bytes memory _data
877     ) public payable virtual override {
878         transferFrom(from, to, tokenId);
879         if (to.code.length != 0)
880             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
881                 revert TransferToNonERC721ReceiverImplementer();
882             }
883     }
884 
885     function _beforeTokenTransfers(
886         address from,
887         address to,
888         uint256 startTokenId,
889         uint256 quantity
890     ) internal virtual {}
891 
892  
893     function _afterTokenTransfers(
894         address from,
895         address to,
896         uint256 startTokenId,
897         uint256 quantity
898     ) internal virtual {}
899 
900     function _checkContractOnERC721Received(
901         address from,
902         address to,
903         uint256 tokenId,
904         bytes memory _data
905     ) private returns (bool) {
906         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
907             bytes4 retval
908         ) {
909             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
910         } catch (bytes memory reason) {
911             if (reason.length == 0) {
912                 revert TransferToNonERC721ReceiverImplementer();
913             } else {
914                 assembly {
915                     revert(add(32, reason), mload(reason))
916                 }
917             }
918         }
919     }
920 
921     function _mint(address to, uint256 quantity) internal virtual {
922         uint256 startTokenId = _currentIndex;
923         if (quantity == 0) revert MintZeroQuantity();
924 
925         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
926 
927         unchecked {
928 
929             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
930 
931             _packedOwnerships[startTokenId] = _packOwnershipData(
932                 to,
933                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
934             );
935 
936             uint256 toMasked;
937             uint256 end = startTokenId + quantity;
938 
939             assembly {
940                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
941                 toMasked := and(to, _BITMASK_ADDRESS)
942                 // Emit the `Transfer` event.
943                 log4(
944                     0, // Start of data (0, since no data).
945                     0, // End of data (0, since no data).
946                     _TRANSFER_EVENT_SIGNATURE, // Signature.
947                     0, // `address(0)`.
948                     toMasked, // `to`.
949                     startTokenId // `tokenId`.
950                 )
951 
952                 for {
953                     let tokenId := add(startTokenId, 1)
954                 } iszero(eq(tokenId, end)) {
955                     tokenId := add(tokenId, 1)
956                 } {
957                     // Emit the `Transfer` event. Similar to above.
958                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
959                 }
960             }
961             if (toMasked == 0) revert MintToZeroAddress();
962 
963             _currentIndex = end;
964         }
965         _afterTokenTransfers(address(0), to, startTokenId, quantity);
966     }
967 
968     function _mintERC2309(address to, uint256 quantity) internal virtual {
969         uint256 startTokenId = _currentIndex;
970         if (to == address(0)) revert MintToZeroAddress();
971         if (quantity == 0) revert MintZeroQuantity();
972         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
973 
974         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
975 
976         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
977         unchecked {
978 
979             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
980 
981             _packedOwnerships[startTokenId] = _packOwnershipData(
982                 to,
983                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
984             );
985 
986             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
987 
988             _currentIndex = startTokenId + quantity;
989         }
990         _afterTokenTransfers(address(0), to, startTokenId, quantity);
991     }
992 
993     function _safeMint(
994         address to,
995         uint256 quantity,
996         bytes memory _data
997     ) internal virtual {
998         _mint(to, quantity);
999 
1000         unchecked {
1001             if (to.code.length != 0) {
1002                 uint256 end = _currentIndex;
1003                 uint256 index = end - quantity;
1004                 do {
1005                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1006                         revert TransferToNonERC721ReceiverImplementer();
1007                     }
1008                 } while (index < end);
1009                 // Reentrancy protection.
1010                 if (_currentIndex != end) revert();
1011             }
1012         }
1013     }
1014 
1015     function _safeMint(address to, uint256 quantity) internal virtual {
1016         _safeMint(to, quantity, '');
1017     }
1018 
1019     function _burn(uint256 tokenId) internal virtual {
1020         _burn(tokenId, false);
1021     }
1022 
1023     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1024         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1025 
1026         address from = address(uint160(prevOwnershipPacked));
1027 
1028         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1029 
1030         if (approvalCheck) {
1031             // The nested ifs save around 20+ gas over a compound boolean condition.
1032             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1033                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1034         }
1035 
1036         _beforeTokenTransfers(from, address(0), tokenId, 1);
1037 
1038         // Clear approvals from the previous owner.
1039         assembly {
1040             if approvedAddress {
1041                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1042                 sstore(approvedAddressSlot, 0)
1043             }
1044         }
1045 
1046         unchecked {
1047 
1048             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1049 
1050             _packedOwnerships[tokenId] = _packOwnershipData(
1051                 from,
1052                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1053             );
1054 
1055             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1056             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1057                 uint256 nextTokenId = tokenId + 1;
1058                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1059                 if (_packedOwnerships[nextTokenId] == 0) {
1060                     // If the next slot is within bounds.
1061                     if (nextTokenId != _currentIndex) {
1062                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1063                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1064                     }
1065                 }
1066             }
1067         }
1068 
1069         emit Transfer(from, address(0), tokenId);
1070         _afterTokenTransfers(from, address(0), tokenId, 1);
1071 
1072         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1073         unchecked {
1074             _burnCounter++;
1075         }
1076     }
1077 
1078     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1079         uint256 packed = _packedOwnerships[index];
1080         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1081         uint256 extraDataCasted;
1082         // Cast `extraData` with assembly to avoid redundant masking.
1083         assembly {
1084             extraDataCasted := extraData
1085         }
1086         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1087         _packedOwnerships[index] = packed;
1088     }
1089 
1090     function _extraData(
1091         address from,
1092         address to,
1093         uint24 previousExtraData
1094     ) internal view virtual returns (uint24) {}
1095 
1096     function _nextExtraData(
1097         address from,
1098         address to,
1099         uint256 prevOwnershipPacked
1100     ) private view returns (uint256) {
1101         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1102         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1103     }
1104 
1105     function _msgSenderERC721A() internal view virtual returns (address) {
1106         return msg.sender;
1107     }
1108 
1109     /**
1110      * @dev Converts a uint256 to its ASCII string decimal representation.
1111      */
1112     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1113         assembly {
1114             let m := add(mload(0x40), 0xa0)
1115             // Update the free memory pointer to allocate.
1116             mstore(0x40, m)
1117             // Assign the `str` to the end.
1118             str := sub(m, 0x20)
1119             // Zeroize the slot after the string.
1120             mstore(str, 0)
1121 
1122             // Cache the end of the memory to calculate the length later.
1123             let end := str
1124 
1125             // We write the string from rightmost digit to leftmost digit.
1126             // The following is essentially a do-while loop that also handles the zero case.
1127             // prettier-ignore
1128             for { let temp := value } 1 {} {
1129                 str := sub(str, 1)
1130                 // Write the character to the pointer.
1131                 // The ASCII index of the '0' character is 48.
1132                 mstore8(str, add(48, mod(temp, 10)))
1133                 // Keep dividing `temp` until zero.
1134                 temp := div(temp, 10)
1135                 // prettier-ignore
1136                 if iszero(temp) { break }
1137             }
1138 
1139             let length := sub(end, str)
1140             // Move the pointer 32 bytes leftwards to make room for the length.
1141             str := sub(str, 0x20)
1142             // Store the length.
1143             mstore(str, length)
1144         }
1145     }
1146 }
1147 
1148 //SPDX-License-Identifier: MIT
1149 
1150 pragma solidity ^0.8.19;
1151 contract LastPepe  is ERC721A, Ownable, ReentrancyGuard {
1152 	using Strings for uint256;
1153 
1154 	uint256 public maxSupply = 6969;
1155     uint256 public maxFreeSupply = 6969;
1156 
1157     uint256 public cost = 0.0009 ether;
1158     uint256 public notPayableAmount = 5;
1159     uint256 public maxPerWallet = 100;
1160 
1161     bool public isRevealed = true;
1162 	bool public pause = false;
1163 
1164     string private baseURL = "";
1165     string public hiddenMetadataUrl = "REVEALED";
1166 
1167     mapping(address => uint256) public userBalance;
1168 
1169 	constructor(
1170         string memory _baseMetadataUrl
1171 	)
1172 	ERC721A("The Last Pepe", "$LASTPEPE") {
1173         setBaseUri(_baseMetadataUrl);
1174     }
1175 
1176 	function _baseURI() internal view override returns (string memory) {
1177 		return baseURL;
1178 	}
1179 
1180     function setBaseUri(string memory _baseURL) public onlyOwner {
1181 	    baseURL = _baseURL;
1182 	}
1183 
1184     function mint(uint256 mintAmount) external payable {
1185 		require(!pause, "The Last Pepe sale is on pause");
1186         if(userBalance[msg.sender] >= notPayableAmount) require(msg.value >= cost * mintAmount, "Insufficient eth funds");
1187         else{
1188             if(totalSupply() + mintAmount <= maxFreeSupply){
1189                 if(mintAmount > (notPayableAmount - userBalance[msg.sender])) require(msg.value >= cost * (mintAmount - (notPayableAmount - userBalance[msg.sender])), "Insufficient funds");
1190             }
1191             else require(msg.value >= cost * mintAmount, "Insufficient eth funds");
1192         }
1193         require(_totalMinted() + mintAmount <= maxSupply,"Exceeds max supply");
1194         require(userBalance[msg.sender] + mintAmount <= maxPerWallet, "Exceeds max Pepe per wallet");
1195         _safeMint(msg.sender, mintAmount);
1196         userBalance[msg.sender] = userBalance[msg.sender] + mintAmount;
1197 	}
1198 
1199     function airdrop(address to, uint256 mintAmount) external onlyOwner {
1200 		require(
1201 			_totalMinted() + mintAmount <= maxSupply,
1202 			"Exceeds max supply"
1203 		);
1204 		_safeMint(to, mintAmount);
1205         
1206 	}
1207 
1208     function sethiddenMetadataUrl(string memory _hiddenMetadataUrl) public onlyOwner {
1209 	    hiddenMetadataUrl = _hiddenMetadataUrl;
1210 	}
1211 
1212     function reveal(bool _state) external onlyOwner {
1213 	    isRevealed = _state;
1214 	}
1215 
1216 	function _startTokenId() internal view virtual override returns (uint256) {
1217     	return 1;
1218   	}
1219 
1220 	function setMaxSupply(uint256 newMaxSupply) external onlyOwner {
1221 		maxSupply = newMaxSupply;
1222 	}
1223 
1224     function setMaxFreeSupply(uint256 newMaxFreeSupply) external onlyOwner {
1225 		maxFreeSupply = newMaxFreeSupply;
1226 	}
1227 
1228 	function tokenURI(uint256 tokenId)
1229 		public
1230 		view
1231 		override
1232 		returns (string memory)
1233 	{
1234         require(_exists(tokenId), "That Pepe token doesn't exist");
1235         if(isRevealed == false) {
1236             return hiddenMetadataUrl;
1237         }
1238         else return bytes(_baseURI()).length > 0 
1239             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1240             : "";
1241 	}
1242 
1243 	function setCost(uint256 _newCost) public onlyOwner{
1244 		cost = _newCost;
1245 	}
1246 
1247 	function setPause(bool _state) public onlyOwner{
1248 		pause = _state;
1249 	}
1250 
1251     function setNotPayableAmount(uint256 _newAmt) public onlyOwner{
1252         require(_newAmt < maxPerWallet, "Arggggg! Its Not possible");
1253         notPayableAmount = _newAmt;
1254     }
1255 
1256     function setMaxPerWallet(uint256 _newAmt) public  onlyOwner{
1257         require(_newAmt > notPayableAmount, "Argggg! Its Not possible");
1258         maxPerWallet = _newAmt;
1259     }
1260 
1261 	function withdraw() external onlyOwner {
1262 		(bool success, ) = payable(owner()).call{
1263             value: address(this).balance
1264         }("");
1265         require(success);
1266 	}
1267 }