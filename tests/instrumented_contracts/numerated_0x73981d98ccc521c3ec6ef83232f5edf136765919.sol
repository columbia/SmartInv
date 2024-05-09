1 /**
2 
3 ▓█████ ██▒   █▓ ██▓ ██▓                      
4 ▓█   ▀▓██░   █▒▓██▒▓██▒                      
5 ▒███   ▓██  █▒░▒██▒▒██░                      
6 ▒▓█  ▄  ▒██ █░░░██░▒██░                      
7 ░▒████▒  ▒▀█░  ░██░░██████▒                  
8 ░░ ▒░ ░  ░ ▐░  ░▓  ░ ▒░▓  ░                  
9  ░ ░  ░  ░ ░░   ▒ ░░ ░ ▒  ░                  
10    ░       ░░   ▒ ░  ░ ░                     
11    ░  ░     ░   ░      ░  ░                  
12            ░                                 
13 ▓█████▄  ▄▄▄       ███▄    █  ██ ▄█▀▒███████▒
14 ▒██▀ ██▌▒████▄     ██ ▀█   █  ██▄█▒ ▒ ▒ ▒ ▄▀░
15 ░██   █▌▒██  ▀█▄  ▓██  ▀█ ██▒▓███▄░ ░ ▒ ▄▀▒░ 
16 ░▓█▄   ▌░██▄▄▄▄██ ▓██▒  ▐▌██▒▓██ █▄   ▄▀▒   ░
17 ░▒████▓  ▓█   ▓██▒▒██░   ▓██░▒██▒ █▄▒███████▒
18  ▒▒▓  ▒  ▒▒   ▓▒█░░ ▒░   ▒ ▒ ▒ ▒▒ ▓▒░▒▒ ▓░▒░▒
19  ░ ▒  ▒   ▒   ▒▒ ░░ ░░   ░ ▒░░ ░▒ ▒░░░▒ ▒ ░ ▒
20  ░ ░  ░   ░   ▒      ░   ░ ░ ░ ░░ ░ ░ ░ ░ ░ ░
21    ░          ░  ░         ░ ░  ░     ░ ░    
22  ░                                  ░        
23 */
24 
25 pragma solidity ^0.8.0;
26 abstract contract ReentrancyGuard {
27 
28     uint256 private constant _NOT_ENTERED = 1;
29     uint256 private constant _ENTERED = 2;
30 
31     uint256 private _status;
32 
33     constructor() {
34         _status = _NOT_ENTERED;
35     }
36 
37     modifier nonReentrant() {
38         _nonReentrantBefore();
39         _;
40         _nonReentrantAfter();
41     }
42 
43     function _nonReentrantBefore() private {
44         // On the first call to nonReentrant, _status will be _NOT_ENTERED
45         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
46 
47         // Any calls to nonReentrant after this point will fail
48         _status = _ENTERED;
49     }
50 
51     function _nonReentrantAfter() private {
52 
53         _status = _NOT_ENTERED;
54     }
55 }
56 
57 pragma solidity ^0.8.0;
58 
59 abstract contract Context {
60     function _msgSender() internal view virtual returns (address) {
61         return msg.sender;
62     }
63 
64     function _msgData() internal view virtual returns (bytes calldata) {
65         return msg.data;
66     }
67 }
68 
69 pragma solidity ^0.8.0;
70 
71 abstract contract Ownable is Context {
72     address private _owner;
73 
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     constructor() {
77         _transferOwnership(_msgSender());
78     }
79 
80     modifier onlyOwner() {
81         _checkOwner();
82         _;
83     }
84 
85     function owner() public view virtual returns (address) {
86         return _owner;
87     }
88 
89     function _checkOwner() internal view virtual {
90         require(owner() == _msgSender(), "Ownable: caller is not the owner");
91     }
92 
93     function renounceOwnership() public virtual onlyOwner {
94         _transferOwnership(address(0));
95     }
96 
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     function _transferOwnership(address newOwner) internal virtual {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
108 
109 pragma solidity ^0.8.0;
110 
111 library Math {
112     enum Rounding {
113         Down, // Toward negative infinity
114         Up, // Toward infinity
115         Zero // Toward zero
116     }
117 
118     function max(uint256 a, uint256 b) internal pure returns (uint256) {
119         return a > b ? a : b;
120     }
121 
122     function min(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a < b ? a : b;
124     }
125 
126     function average(uint256 a, uint256 b) internal pure returns (uint256) {
127         // (a + b) / 2 can overflow.
128         return (a & b) + (a ^ b) / 2;
129     }
130 
131     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
132         // (a + b - 1) / b can overflow on addition, so we distribute.
133         return a == 0 ? 0 : (a - 1) / b + 1;
134     }
135 
136     function mulDiv(
137         uint256 x,
138         uint256 y,
139         uint256 denominator
140     ) internal pure returns (uint256 result) {
141         unchecked {
142 
143             uint256 prod0; // Least significant 256 bits of the product
144             uint256 prod1; // Most significant 256 bits of the product
145             assembly {
146                 let mm := mulmod(x, y, not(0))
147                 prod0 := mul(x, y)
148                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
149             }
150 
151             // Handle non-overflow cases, 256 by 256 division.
152             if (prod1 == 0) {
153                 return prod0 / denominator;
154             }
155 
156             // Make sure the result is less than 2^256. Also prevents denominator == 0.
157             require(denominator > prod1);
158 
159             uint256 remainder;
160             assembly {
161                 // Compute remainder using mulmod.
162                 remainder := mulmod(x, y, denominator)
163 
164                 // Subtract 256 bit number from 512 bit number.
165                 prod1 := sub(prod1, gt(remainder, prod0))
166                 prod0 := sub(prod0, remainder)
167             }
168 
169             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
170             // See https://cs.stackexchange.com/q/138556/92363.
171 
172             // Does not overflow because the denominator cannot be zero at this stage in the function.
173             uint256 twos = denominator & (~denominator + 1);
174             assembly {
175                 // Divide denominator by twos.
176                 denominator := div(denominator, twos)
177 
178                 // Divide [prod1 prod0] by twos.
179                 prod0 := div(prod0, twos)
180 
181                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
182                 twos := add(div(sub(0, twos), twos), 1)
183             }
184 
185             // Shift in bits from prod1 into prod0.
186             prod0 |= prod1 * twos;
187             uint256 inverse = (3 * denominator) ^ 2;
188 
189             inverse *= 2 - denominator * inverse; // inverse mod 2^8
190             inverse *= 2 - denominator * inverse; // inverse mod 2^16
191             inverse *= 2 - denominator * inverse; // inverse mod 2^32
192             inverse *= 2 - denominator * inverse; // inverse mod 2^64
193             inverse *= 2 - denominator * inverse; // inverse mod 2^128
194             inverse *= 2 - denominator * inverse; // inverse mod 2^256
195             result = prod0 * inverse;
196             return result;
197         }
198     }
199 
200     function mulDiv(
201         uint256 x,
202         uint256 y,
203         uint256 denominator,
204         Rounding rounding
205     ) internal pure returns (uint256) {
206         uint256 result = mulDiv(x, y, denominator);
207         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
208             result += 1;
209         }
210         return result;
211     }
212 
213     function sqrt(uint256 a) internal pure returns (uint256) {
214         if (a == 0) {
215             return 0;
216         }
217 
218         uint256 result = 1 << (log2(a) >> 1);
219 
220         unchecked {
221             result = (result + a / result) >> 1;
222             result = (result + a / result) >> 1;
223             result = (result + a / result) >> 1;
224             result = (result + a / result) >> 1;
225             result = (result + a / result) >> 1;
226             result = (result + a / result) >> 1;
227             result = (result + a / result) >> 1;
228             return min(result, a / result);
229         }
230     }
231 
232     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
233         unchecked {
234             uint256 result = sqrt(a);
235             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
236         }
237     }
238 
239     function log2(uint256 value) internal pure returns (uint256) {
240         uint256 result = 0;
241         unchecked {
242             if (value >> 128 > 0) {
243                 value >>= 128;
244                 result += 128;
245             }
246             if (value >> 64 > 0) {
247                 value >>= 64;
248                 result += 64;
249             }
250             if (value >> 32 > 0) {
251                 value >>= 32;
252                 result += 32;
253             }
254             if (value >> 16 > 0) {
255                 value >>= 16;
256                 result += 16;
257             }
258             if (value >> 8 > 0) {
259                 value >>= 8;
260                 result += 8;
261             }
262             if (value >> 4 > 0) {
263                 value >>= 4;
264                 result += 4;
265             }
266             if (value >> 2 > 0) {
267                 value >>= 2;
268                 result += 2;
269             }
270             if (value >> 1 > 0) {
271                 result += 1;
272             }
273         }
274         return result;
275     }
276 
277     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
278         unchecked {
279             uint256 result = log2(value);
280             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
281         }
282     }
283 
284     function log10(uint256 value) internal pure returns (uint256) {
285         uint256 result = 0;
286         unchecked {
287             if (value >= 10**64) {
288                 value /= 10**64;
289                 result += 64;
290             }
291             if (value >= 10**32) {
292                 value /= 10**32;
293                 result += 32;
294             }
295             if (value >= 10**16) {
296                 value /= 10**16;
297                 result += 16;
298             }
299             if (value >= 10**8) {
300                 value /= 10**8;
301                 result += 8;
302             }
303             if (value >= 10**4) {
304                 value /= 10**4;
305                 result += 4;
306             }
307             if (value >= 10**2) {
308                 value /= 10**2;
309                 result += 2;
310             }
311             if (value >= 10**1) {
312                 result += 1;
313             }
314         }
315         return result;
316     }
317 
318     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
319         unchecked {
320             uint256 result = log10(value);
321             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
322         }
323     }
324 
325     function log256(uint256 value) internal pure returns (uint256) {
326         uint256 result = 0;
327         unchecked {
328             if (value >> 128 > 0) {
329                 value >>= 128;
330                 result += 16;
331             }
332             if (value >> 64 > 0) {
333                 value >>= 64;
334                 result += 8;
335             }
336             if (value >> 32 > 0) {
337                 value >>= 32;
338                 result += 4;
339             }
340             if (value >> 16 > 0) {
341                 value >>= 16;
342                 result += 2;
343             }
344             if (value >> 8 > 0) {
345                 result += 1;
346             }
347         }
348         return result;
349     }
350 
351     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
352         unchecked {
353             uint256 result = log256(value);
354             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
355         }
356     }
357 }
358 
359 pragma solidity ^0.8.0;
360 
361 library Strings {
362     bytes16 private constant _SYMBOLS = "0123456789abcdef";
363     uint8 private constant _ADDRESS_LENGTH = 20;
364 
365     /**
366      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
367      */
368     function toString(uint256 value) internal pure returns (string memory) {
369         unchecked {
370             uint256 length = Math.log10(value) + 1;
371             string memory buffer = new string(length);
372             uint256 ptr;
373             /// @solidity memory-safe-assembly
374             assembly {
375                 ptr := add(buffer, add(32, length))
376             }
377             while (true) {
378                 ptr--;
379                 /// @solidity memory-safe-assembly
380                 assembly {
381                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
382                 }
383                 value /= 10;
384                 if (value == 0) break;
385             }
386             return buffer;
387         }
388     }
389 
390     function toHexString(uint256 value) internal pure returns (string memory) {
391         unchecked {
392             return toHexString(value, Math.log256(value) + 1);
393         }
394     }
395 
396     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
397         bytes memory buffer = new bytes(2 * length + 2);
398         buffer[0] = "0";
399         buffer[1] = "x";
400         for (uint256 i = 2 * length + 1; i > 1; --i) {
401             buffer[i] = _SYMBOLS[value & 0xf];
402             value >>= 4;
403         }
404         require(value == 0, "Strings: hex length insufficient");
405         return string(buffer);
406     }
407 
408     function toHexString(address addr) internal pure returns (string memory) {
409         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
410     }
411 }
412 
413 // ERC721A Contracts v4.2.3
414 // Creator: Chiru Labs
415 
416 pragma solidity ^0.8.4;
417 
418 interface IERC721A {
419 
420     error ApprovalCallerNotOwnerNorApproved();
421 
422     error ApprovalQueryForNonexistentToken();
423 
424     error BalanceQueryForZeroAddress();
425 
426     error MintToZeroAddress();
427 
428     error MintZeroQuantity();
429 
430     error OwnerQueryForNonexistentToken();
431 
432     error TransferCallerNotOwnerNorApproved();
433 
434     error TransferFromIncorrectOwner();
435 
436     error TransferToNonERC721ReceiverImplementer();
437 
438     error TransferToZeroAddress();
439 
440     error URIQueryForNonexistentToken();
441 
442     error MintERC2309QuantityExceedsLimit();
443 
444     error OwnershipNotInitializedForExtraData();
445 
446     struct TokenOwnership {
447         // The address of the owner.
448         address addr;
449         // Stores the start time of ownership with minimal overhead for tokenomics.
450         uint64 startTimestamp;
451         // Whether the token has been burned.
452         bool burned;
453         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
454         uint24 extraData;
455     }
456 
457     function totalSupply() external view returns (uint256);
458 
459     function supportsInterface(bytes4 interfaceId) external view returns (bool);
460 
461     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
462 
463     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
464 
465     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
466 
467     function balanceOf(address owner) external view returns (uint256 balance);
468 
469     function ownerOf(uint256 tokenId) external view returns (address owner);
470 
471     function safeTransferFrom(
472         address from,
473         address to,
474         uint256 tokenId,
475         bytes calldata data
476     ) external payable;
477 
478     function safeTransferFrom(
479         address from,
480         address to,
481         uint256 tokenId
482     ) external payable;
483 
484     function transferFrom(
485         address from,
486         address to,
487         uint256 tokenId
488     ) external payable;
489 
490     function approve(address to, uint256 tokenId) external payable;
491     function setApprovalForAll(address operator, bool _approved) external;
492     function getApproved(uint256 tokenId) external view returns (address operator);
493     function isApprovedForAll(address owner, address operator) external view returns (bool);
494     function name() external view returns (string memory);
495     function symbol() external view returns (string memory);
496     function tokenURI(uint256 tokenId) external view returns (string memory);
497 
498     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
499 }
500 
501 // ERC721A Contracts v4.2.3
502 // Creator: Chiru Labs
503 
504 pragma solidity ^0.8.4;
505 
506 /**
507  * @dev Interface of ERC721 token receiver.
508  */
509 interface ERC721A__IERC721Receiver {
510     function onERC721Received(
511         address operator,
512         address from,
513         uint256 tokenId,
514         bytes calldata data
515     ) external returns (bytes4);
516 }
517 
518 contract ERC721A is IERC721A {
519     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
520     struct TokenApprovalRef {
521         address value;
522     }
523 
524     // Mask of an entry in packed address data.
525     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
526 
527     // The bit position of `numberMinted` in packed address data.
528     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
529 
530     // The bit position of `numberBurned` in packed address data.
531     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
532 
533     // The bit position of `aux` in packed address data.
534     uint256 private constant _BITPOS_AUX = 192;
535 
536     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
537     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
538 
539     // The bit position of `startTimestamp` in packed ownership.
540     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
541 
542     // The bit mask of the `burned` bit in packed ownership.
543     uint256 private constant _BITMASK_BURNED = 1 << 224;
544 
545     // The bit position of the `nextInitialized` bit in packed ownership.
546     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
547 
548     // The bit mask of the `nextInitialized` bit in packed ownership.
549     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
550 
551     // The bit position of `extraData` in packed ownership.
552     uint256 private constant _BITPOS_EXTRA_DATA = 232;
553 
554     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
555     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
556 
557     // The mask of the lower 160 bits for addresses.
558     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
559     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
560 
561     // The `Transfer` event signature is given by:
562     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
563     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
564         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
565 
566     uint256 private _currentIndex;
567 
568     // The number of tokens burned.
569     uint256 private _burnCounter;
570 
571     // Token name
572     string private _name;
573 
574     // Token symbol
575     string private _symbol;
576 
577     mapping(uint256 => uint256) private _packedOwnerships;
578     mapping(address => uint256) private _packedAddressData;
579     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
580     mapping(address => mapping(address => bool)) private _operatorApprovals;
581 
582     constructor(string memory name_, string memory symbol_) {
583         _name = name_;
584         _symbol = symbol_;
585         _currentIndex = _startTokenId();
586     }
587 
588     function _startTokenId() internal view virtual returns (uint256) {
589         return 0;
590     }
591 
592     function _nextTokenId() internal view virtual returns (uint256) {
593         return _currentIndex;
594     }
595 
596     function totalSupply() public view virtual override returns (uint256) {
597         // Counter underflow is impossible as _burnCounter cannot be incremented
598         // more than `_currentIndex - _startTokenId()` times.
599         unchecked {
600             return _currentIndex - _burnCounter - _startTokenId();
601         }
602     }
603 
604     function _totalMinted() internal view virtual returns (uint256) {
605         // Counter underflow is impossible as `_currentIndex` does not decrement,
606         // and it is initialized to `_startTokenId()`.
607         unchecked {
608             return _currentIndex - _startTokenId();
609         }
610     }
611 
612     function _totalBurned() internal view virtual returns (uint256) {
613         return _burnCounter;
614     }
615 
616     function balanceOf(address owner) public view virtual override returns (uint256) {
617         if (owner == address(0)) revert BalanceQueryForZeroAddress();
618         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
619     }
620 
621     function _numberMinted(address owner) internal view returns (uint256) {
622         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
623     }
624 
625     function _numberBurned(address owner) internal view returns (uint256) {
626         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
627     }
628 
629     function _getAux(address owner) internal view returns (uint64) {
630         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
631     }
632 
633     function _setAux(address owner, uint64 aux) internal virtual {
634         uint256 packed = _packedAddressData[owner];
635         uint256 auxCasted;
636         // Cast `aux` with assembly to avoid redundant masking.
637         assembly {
638             auxCasted := aux
639         }
640         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
641         _packedAddressData[owner] = packed;
642     }
643 
644     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
645 
646         return
647             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
648             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
649             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
650     }
651 
652     function name() public view virtual override returns (string memory) {
653         return _name;
654     }
655 
656     function symbol() public view virtual override returns (string memory) {
657         return _symbol;
658     }
659 
660     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
661         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
662 
663         string memory baseURI = _baseURI();
664         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
665     }
666 
667     function _baseURI() internal view virtual returns (string memory) {
668         return '';
669     }
670 
671     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
672         return address(uint160(_packedOwnershipOf(tokenId)));
673     }
674 
675     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
676         return _unpackedOwnership(_packedOwnershipOf(tokenId));
677     }
678 
679     /**
680      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
681      */
682     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
683         return _unpackedOwnership(_packedOwnerships[index]);
684     }
685 
686     /**
687      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
688      */
689     function _initializeOwnershipAt(uint256 index) internal virtual {
690         if (_packedOwnerships[index] == 0) {
691             _packedOwnerships[index] = _packedOwnershipOf(index);
692         }
693     }
694 
695     /**
696      * Returns the packed ownership data of `tokenId`.
697      */
698     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
699         uint256 curr = tokenId;
700 
701         unchecked {
702             if (_startTokenId() <= curr)
703                 if (curr < _currentIndex) {
704                     uint256 packed = _packedOwnerships[curr];
705                     // If not burned.
706                     if (packed & _BITMASK_BURNED == 0) {
707 
708                         while (packed == 0) {
709                             packed = _packedOwnerships[--curr];
710                         }
711                         return packed;
712                     }
713                 }
714         }
715         revert OwnerQueryForNonexistentToken();
716     }
717 
718     /**
719      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
720      */
721     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
722         ownership.addr = address(uint160(packed));
723         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
724         ownership.burned = packed & _BITMASK_BURNED != 0;
725         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
726     }
727 
728     /**
729      * @dev Packs ownership data into a single uint256.
730      */
731     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
732         assembly {
733             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
734             owner := and(owner, _BITMASK_ADDRESS)
735             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
736             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
737         }
738     }
739 
740     /**
741      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
742      */
743     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
744         // For branchless setting of the `nextInitialized` flag.
745         assembly {
746             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
747             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
748         }
749     }
750 
751     function approve(address to, uint256 tokenId) public payable virtual override {
752         address owner = ownerOf(tokenId);
753 
754         if (_msgSenderERC721A() != owner)
755             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
756                 revert ApprovalCallerNotOwnerNorApproved();
757             }
758 
759         _tokenApprovals[tokenId].value = to;
760         emit Approval(owner, to, tokenId);
761     }
762 
763     function getApproved(uint256 tokenId) public view virtual override returns (address) {
764         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
765 
766         return _tokenApprovals[tokenId].value;
767     }
768 
769     function setApprovalForAll(address operator, bool approved) public virtual override {
770         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
771         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
772     }
773 
774     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
775         return _operatorApprovals[owner][operator];
776     }
777 
778     function _exists(uint256 tokenId) internal view virtual returns (bool) {
779         return
780             _startTokenId() <= tokenId &&
781             tokenId < _currentIndex && // If within bounds,
782             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
783     }
784 
785     /**
786      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
787      */
788     function _isSenderApprovedOrOwner(
789         address approvedAddress,
790         address owner,
791         address msgSender
792     ) private pure returns (bool result) {
793         assembly {
794             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
795             owner := and(owner, _BITMASK_ADDRESS)
796             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
797             msgSender := and(msgSender, _BITMASK_ADDRESS)
798             // `msgSender == owner || msgSender == approvedAddress`.
799             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
800         }
801     }
802 
803     /**
804      * @dev Returns the storage slot and value for the approved address of `tokenId`.
805      */
806     function _getApprovedSlotAndAddress(uint256 tokenId)
807         private
808         view
809         returns (uint256 approvedAddressSlot, address approvedAddress)
810     {
811         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
812         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
813         assembly {
814             approvedAddressSlot := tokenApproval.slot
815             approvedAddress := sload(approvedAddressSlot)
816         }
817     }
818 
819     function transferFrom(
820         address from,
821         address to,
822         uint256 tokenId
823     ) public payable virtual override {
824         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
825 
826         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
827 
828         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
829 
830         // The nested ifs save around 20+ gas over a compound boolean condition.
831         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
832             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
833 
834         if (to == address(0)) revert TransferToZeroAddress();
835 
836         _beforeTokenTransfers(from, to, tokenId, 1);
837 
838         // Clear approvals from the previous owner.
839         assembly {
840             if approvedAddress {
841                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
842                 sstore(approvedAddressSlot, 0)
843             }
844         }
845 
846         unchecked {
847             // We can directly increment and decrement the balances.
848             --_packedAddressData[from]; // Updates: `balance -= 1`.
849             ++_packedAddressData[to]; // Updates: `balance += 1`.
850             _packedOwnerships[tokenId] = _packOwnershipData(
851                 to,
852                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
853             );
854 
855             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
856             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
857                 uint256 nextTokenId = tokenId + 1;
858                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
859                 if (_packedOwnerships[nextTokenId] == 0) {
860                     // If the next slot is within bounds.
861                     if (nextTokenId != _currentIndex) {
862                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
863                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
864                     }
865                 }
866             }
867         }
868 
869         emit Transfer(from, to, tokenId);
870         _afterTokenTransfers(from, to, tokenId, 1);
871     }
872 
873     /**
874      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
875      */
876     function safeTransferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public payable virtual override {
881         safeTransferFrom(from, to, tokenId, '');
882     }
883 
884     function safeTransferFrom(
885         address from,
886         address to,
887         uint256 tokenId,
888         bytes memory _data
889     ) public payable virtual override {
890         transferFrom(from, to, tokenId);
891         if (to.code.length != 0)
892             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
893                 revert TransferToNonERC721ReceiverImplementer();
894             }
895     }
896 
897     function _beforeTokenTransfers(
898         address from,
899         address to,
900         uint256 startTokenId,
901         uint256 quantity
902     ) internal virtual {}
903 
904  
905     function _afterTokenTransfers(
906         address from,
907         address to,
908         uint256 startTokenId,
909         uint256 quantity
910     ) internal virtual {}
911 
912     function _checkContractOnERC721Received(
913         address from,
914         address to,
915         uint256 tokenId,
916         bytes memory _data
917     ) private returns (bool) {
918         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
919             bytes4 retval
920         ) {
921             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
922         } catch (bytes memory reason) {
923             if (reason.length == 0) {
924                 revert TransferToNonERC721ReceiverImplementer();
925             } else {
926                 assembly {
927                     revert(add(32, reason), mload(reason))
928                 }
929             }
930         }
931     }
932 
933     function _mint(address to, uint256 quantity) internal virtual {
934         uint256 startTokenId = _currentIndex;
935         if (quantity == 0) revert MintZeroQuantity();
936 
937         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
938 
939         unchecked {
940 
941             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
942 
943             _packedOwnerships[startTokenId] = _packOwnershipData(
944                 to,
945                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
946             );
947 
948             uint256 toMasked;
949             uint256 end = startTokenId + quantity;
950 
951             assembly {
952                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
953                 toMasked := and(to, _BITMASK_ADDRESS)
954                 // Emit the `Transfer` event.
955                 log4(
956                     0, // Start of data (0, since no data).
957                     0, // End of data (0, since no data).
958                     _TRANSFER_EVENT_SIGNATURE, // Signature.
959                     0, // `address(0)`.
960                     toMasked, // `to`.
961                     startTokenId // `tokenId`.
962                 )
963 
964                 for {
965                     let tokenId := add(startTokenId, 1)
966                 } iszero(eq(tokenId, end)) {
967                     tokenId := add(tokenId, 1)
968                 } {
969                     // Emit the `Transfer` event. Similar to above.
970                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
971                 }
972             }
973             if (toMasked == 0) revert MintToZeroAddress();
974 
975             _currentIndex = end;
976         }
977         _afterTokenTransfers(address(0), to, startTokenId, quantity);
978     }
979 
980     function _mintERC2309(address to, uint256 quantity) internal virtual {
981         uint256 startTokenId = _currentIndex;
982         if (to == address(0)) revert MintToZeroAddress();
983         if (quantity == 0) revert MintZeroQuantity();
984         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
985 
986         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
987 
988         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
989         unchecked {
990 
991             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
992 
993             _packedOwnerships[startTokenId] = _packOwnershipData(
994                 to,
995                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
996             );
997 
998             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
999 
1000             _currentIndex = startTokenId + quantity;
1001         }
1002         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1003     }
1004 
1005     function _safeMint(
1006         address to,
1007         uint256 quantity,
1008         bytes memory _data
1009     ) internal virtual {
1010         _mint(to, quantity);
1011 
1012         unchecked {
1013             if (to.code.length != 0) {
1014                 uint256 end = _currentIndex;
1015                 uint256 index = end - quantity;
1016                 do {
1017                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1018                         revert TransferToNonERC721ReceiverImplementer();
1019                     }
1020                 } while (index < end);
1021                 // Reentrancy protection.
1022                 if (_currentIndex != end) revert();
1023             }
1024         }
1025     }
1026 
1027     function _safeMint(address to, uint256 quantity) internal virtual {
1028         _safeMint(to, quantity, '');
1029     }
1030 
1031     function _burn(uint256 tokenId) internal virtual {
1032         _burn(tokenId, false);
1033     }
1034 
1035     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1036         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1037 
1038         address from = address(uint160(prevOwnershipPacked));
1039 
1040         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1041 
1042         if (approvalCheck) {
1043             // The nested ifs save around 20+ gas over a compound boolean condition.
1044             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1045                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1046         }
1047 
1048         _beforeTokenTransfers(from, address(0), tokenId, 1);
1049 
1050         // Clear approvals from the previous owner.
1051         assembly {
1052             if approvedAddress {
1053                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1054                 sstore(approvedAddressSlot, 0)
1055             }
1056         }
1057 
1058         unchecked {
1059 
1060             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1061 
1062             _packedOwnerships[tokenId] = _packOwnershipData(
1063                 from,
1064                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1065             );
1066 
1067             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1068             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1069                 uint256 nextTokenId = tokenId + 1;
1070                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1071                 if (_packedOwnerships[nextTokenId] == 0) {
1072                     // If the next slot is within bounds.
1073                     if (nextTokenId != _currentIndex) {
1074                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1075                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1076                     }
1077                 }
1078             }
1079         }
1080 
1081         emit Transfer(from, address(0), tokenId);
1082         _afterTokenTransfers(from, address(0), tokenId, 1);
1083 
1084         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1085         unchecked {
1086             _burnCounter++;
1087         }
1088     }
1089 
1090     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1091         uint256 packed = _packedOwnerships[index];
1092         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1093         uint256 extraDataCasted;
1094         // Cast `extraData` with assembly to avoid redundant masking.
1095         assembly {
1096             extraDataCasted := extraData
1097         }
1098         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1099         _packedOwnerships[index] = packed;
1100     }
1101 
1102     function _extraData(
1103         address from,
1104         address to,
1105         uint24 previousExtraData
1106     ) internal view virtual returns (uint24) {}
1107 
1108     function _nextExtraData(
1109         address from,
1110         address to,
1111         uint256 prevOwnershipPacked
1112     ) private view returns (uint256) {
1113         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1114         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1115     }
1116 
1117     function _msgSenderERC721A() internal view virtual returns (address) {
1118         return msg.sender;
1119     }
1120 
1121     /**
1122      * @dev Converts a uint256 to its ASCII string decimal representation.
1123      */
1124     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1125         assembly {
1126             let m := add(mload(0x40), 0xa0)
1127             // Update the free memory pointer to allocate.
1128             mstore(0x40, m)
1129             // Assign the `str` to the end.
1130             str := sub(m, 0x20)
1131             // Zeroize the slot after the string.
1132             mstore(str, 0)
1133 
1134             // Cache the end of the memory to calculate the length later.
1135             let end := str
1136 
1137             // We write the string from rightmost digit to leftmost digit.
1138             // The following is essentially a do-while loop that also handles the zero case.
1139             // prettier-ignore
1140             for { let temp := value } 1 {} {
1141                 str := sub(str, 1)
1142                 // Write the character to the pointer.
1143                 // The ASCII index of the '0' character is 48.
1144                 mstore8(str, add(48, mod(temp, 10)))
1145                 // Keep dividing `temp` until zero.
1146                 temp := div(temp, 10)
1147                 // prettier-ignore
1148                 if iszero(temp) { break }
1149             }
1150 
1151             let length := sub(end, str)
1152             // Move the pointer 32 bytes leftwards to make room for the length.
1153             str := sub(str, 0x20)
1154             // Store the length.
1155             mstore(str, length)
1156         }
1157     }
1158 }
1159 
1160 //SPDX-License-Identifier: MIT
1161 
1162 pragma solidity ^0.8.19;
1163 contract EvilDankz  is ERC721A, Ownable, ReentrancyGuard {
1164 	using Strings for uint256;
1165     uint256 public maxSupply = 6666;
1166     uint256 public maxFreeSupply = 6000;
1167     uint256 public cost = 0.0008 ether;
1168     uint256 public notPayableAmount = 5;
1169     uint256 public maxPerWallet = 100;
1170     bool public isRevealed = true;
1171 	bool public pause = false;
1172     string private baseURL = "";
1173     string public hiddenMetadataUrl = "REVEALED";
1174 
1175     mapping(address => uint256) public userBalance;
1176 
1177 	constructor(
1178         string memory _baseMetadataUrl
1179 	)
1180 	ERC721A("EVIL DANKZ", "$DANKZ") {
1181         setBaseUri(_baseMetadataUrl);
1182     }
1183 
1184 	function _baseURI() internal view override returns (string memory) {
1185 		return baseURL;
1186 	}
1187 
1188     function setBaseUri(string memory _baseURL) public onlyOwner {
1189 	    baseURL = _baseURL;
1190 	}
1191 
1192     function mint(uint256 mintAmount) external payable {
1193 		require(!pause, "Dankz sale is on pause");
1194         if(userBalance[msg.sender] >= notPayableAmount) require(msg.value >= cost * mintAmount, "Insufficient eth funds");
1195         else{
1196             if(totalSupply() + mintAmount <= maxFreeSupply){
1197                 if(mintAmount > (notPayableAmount - userBalance[msg.sender])) require(msg.value >= cost * (mintAmount - (notPayableAmount - userBalance[msg.sender])), "Insufficient funds");
1198             }
1199             else require(msg.value >= cost * mintAmount, "Insufficient eth funds");
1200         }
1201         require(_totalMinted() + mintAmount <= maxSupply,"Exceeds max supply");
1202         require(userBalance[msg.sender] + mintAmount <= maxPerWallet, "Exceeds max Dankz per wallet");
1203         _safeMint(msg.sender, mintAmount);
1204         userBalance[msg.sender] = userBalance[msg.sender] + mintAmount;
1205 	}
1206 
1207     function airdrop(address to, uint256 mintAmount) external onlyOwner {
1208 		require(
1209 			_totalMinted() + mintAmount <= maxSupply,
1210 			"Exceeds max supply"
1211 		);
1212 		_safeMint(to, mintAmount);
1213         
1214 	}
1215 
1216     function sethiddenMetadataUrl(string memory _hiddenMetadataUrl) public onlyOwner {
1217 	    hiddenMetadataUrl = _hiddenMetadataUrl;
1218 	}
1219 
1220     function reveal(bool _state) external onlyOwner {
1221 	    isRevealed = _state;
1222 	}
1223 
1224 	function _startTokenId() internal view virtual override returns (uint256) {
1225     	return 1;
1226   	}
1227 
1228 	function setMaxSupply(uint256 newMaxSupply) external onlyOwner {
1229 		maxSupply = newMaxSupply;
1230 	}
1231 
1232     function setMaxFreeSupply(uint256 newMaxFreeSupply) external onlyOwner {
1233 		maxFreeSupply = newMaxFreeSupply;
1234 	}
1235 
1236 	function tokenURI(uint256 tokenId)
1237 		public
1238 		view
1239 		override
1240 		returns (string memory)
1241 	{
1242         require(_exists(tokenId), "That Dankz token doesn't exist");
1243         if(isRevealed == false) {
1244             return hiddenMetadataUrl;
1245         }
1246         else return bytes(_baseURI()).length > 0 
1247             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1248             : "";
1249 	}
1250 
1251 	function setCost(uint256 _newCost) public onlyOwner{
1252 		cost = _newCost;
1253 	}
1254 
1255 	function setPause(bool _state) public onlyOwner{
1256 		pause = _state;
1257 	}
1258 
1259     function setNotPayableAmount(uint256 _newAmt) public onlyOwner{
1260         require(_newAmt < maxPerWallet, "Its Not possible");
1261         notPayableAmount = _newAmt;
1262     }
1263 
1264     function setMaxPerWallet(uint256 _newAmt) public  onlyOwner{
1265         require(_newAmt > notPayableAmount, "Its Not possible");
1266         maxPerWallet = _newAmt;
1267     }
1268 
1269 	function withdraw() external onlyOwner {
1270 		(bool success, ) = payable(owner()).call{
1271             value: address(this).balance
1272         }("");
1273         require(success);
1274 	}
1275 }