1 // SPDX-License-Identifier: MIT
2 // ERC721A Contracts v4.0.1
3 
4 pragma solidity ^0.8.4;
5 
6 /**
7  * @dev Interface of an ERC721A compliant contract.
8  */
9 interface IERC721A {
10     /**
11      * The caller must own the token or be an approved operator.
12      */
13     error ApprovalCallerNotOwnerNorApproved();
14 
15     /**
16      * The token does not exist.
17      */
18     error ApprovalQueryForNonexistentToken();
19 
20     /**
21      * The caller cannot approve to their own address.
22      */
23     error ApproveToCaller();
24 
25     /**
26      * Cannot query the balance for the zero address.
27      */
28     error BalanceQueryForZeroAddress();
29 
30     /**
31      * Cannot mint to the zero address.
32      */
33     error MintToZeroAddress();
34 
35     /**
36      * The quantity of tokens minted must be more than zero.
37      */
38     error MintZeroQuantity();
39 
40     /**
41      * The token does not exist.
42      */
43     error OwnerQueryForNonexistentToken();
44 
45     /**
46      * The caller must own the token or be an approved operator.
47      */
48     error TransferCallerNotOwnerNorApproved();
49 
50     /**
51      * The token must be owned by `from`.
52      */
53     error TransferFromIncorrectOwner();
54 
55     /**
56      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
57      */
58     error TransferToNonERC721ReceiverImplementer();
59 
60     /**
61      * Cannot transfer to the zero address.
62      */
63     error TransferToZeroAddress();
64 
65     /**
66      * The token does not exist.
67      */
68     error URIQueryForNonexistentToken();
69 
70     struct TokenOwnership {
71         // The address of the owner.
72         address addr;
73         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
74         uint64 startTimestamp;
75         // Whether the token has been burned.
76         bool burned;
77     }
78 
79     /**
80      * @dev Returns the total amount of tokens stored by the contract.
81      *
82      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
83      */
84     function totalSupply() external view returns (uint256);
85 
86     // ==============================
87     //            IERC165
88     // ==============================
89 
90     /**
91      * @dev Returns true if this contract implements the interface defined by
92      * `interfaceId`. See the corresponding
93      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
94      * to learn more about how these ids are created.
95      *
96      * This function call must use less than 30 000 gas.
97      */
98     function supportsInterface(bytes4 interfaceId) external view returns (bool);
99 
100     // ==============================
101     //            IERC721
102     // ==============================
103 
104     /**
105      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
108 
109     /**
110      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
111      */
112     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
113 
114     /**
115      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
116      */
117     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
118 
119     /**
120      * @dev Returns the number of tokens in ``owner``'s account.
121      */
122     function balanceOf(address owner) external view returns (uint256 balance);
123 
124     /**
125      * @dev Returns the owner of the `tokenId` token.
126      *
127      * Requirements:
128      *
129      * - `tokenId` must exist.
130      */
131     function ownerOf(uint256 tokenId) external view returns (address owner);
132 
133     /**
134      * @dev Safely transfers `tokenId` token from `from` to `to`.
135      *
136      * Requirements:
137      *
138      * - `from` cannot be the zero address.
139      * - `to` cannot be the zero address.
140      * - `tokenId` token must exist and be owned by `from`.
141      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
142      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
143      *
144      * Emits a {Transfer} event.
145      */
146     function safeTransferFrom(
147         address from,
148         address to,
149         uint256 tokenId,
150         bytes calldata data
151     ) external;
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
155      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId
171     ) external;
172 
173     /**
174      * @dev Transfers `tokenId` token from `from` to `to`.
175      *
176      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
177      *
178      * Requirements:
179      *
180      * - `from` cannot be the zero address.
181      * - `to` cannot be the zero address.
182      * - `tokenId` token must be owned by `from`.
183      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
184      *
185      * Emits a {Transfer} event.
186      */
187     function transferFrom(
188         address from,
189         address to,
190         uint256 tokenId
191     ) external;
192 
193     /**
194      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
195      * The approval is cleared when the token is transferred.
196      *
197      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
198      *
199      * Requirements:
200      *
201      * - The caller must own the token or be an approved operator.
202      * - `tokenId` must exist.
203      *
204      * Emits an {Approval} event.
205      */
206     function approve(address to, uint256 tokenId) external;
207 
208     /**
209      * @dev Approve or remove `operator` as an operator for the caller.
210      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
211      *
212      * Requirements:
213      *
214      * - The `operator` cannot be the caller.
215      *
216      * Emits an {ApprovalForAll} event.
217      */
218     function setApprovalForAll(address operator, bool _approved) external;
219 
220     /**
221      * @dev Returns the account approved for `tokenId` token.
222      *
223      * Requirements:
224      *
225      * - `tokenId` must exist.
226      */
227     function getApproved(uint256 tokenId) external view returns (address operator);
228 
229     /**
230      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
231      *
232      * See {setApprovalForAll}
233      */
234     function isApprovedForAll(address owner, address operator) external view returns (bool);
235 
236     // ==============================
237     //        IERC721Metadata
238     // ==============================
239 
240     /**
241      * @dev Returns the token collection name.
242      */
243     function name() external view returns (string memory);
244 
245     /**
246      * @dev Returns the token collection symbol.
247      */
248     function symbol() external view returns (string memory);
249 
250     /**
251      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
252      */
253     function tokenURI(uint256 tokenId) external view returns (string memory);
254 }
255 
256 /**
257  * @dev ERC721 token receiver interface.
258  */
259 interface ERC721A__IERC721Receiver {
260     function onERC721Received(
261         address operator,
262         address from,
263         uint256 tokenId,
264         bytes calldata data
265     ) external returns (bytes4);
266 }
267 
268 /**
269  * @dev Provides information about the current execution context, including the
270  * sender of the transaction and its data. While these are generally available
271  * via msg.sender and msg.data, they should not be accessed in such a direct
272  * manner, since when dealing with meta-transactions the account sending and
273  * paying for execution may not be the actual sender (as far as an application
274  * is concerned).
275  *
276  * This contract is only required for intermediate, library-like contracts.
277  */
278 abstract contract Context {
279     function _msgSender() internal view virtual returns (address) {
280         return msg.sender;
281     }
282 
283     function _msgData() internal view virtual returns (bytes calldata) {
284         return msg.data;
285     }
286 }
287 
288 /**
289  * @dev Contract module which provides a basic access control mechanism, where
290  * there is an account (an owner) that can be granted exclusive access to
291  * specific functions.
292  *
293  * By default, the owner account will be the one that deploys the contract. This
294  * can later be changed with {transferOwnership}.
295  *
296  * This module is used through inheritance. It will make available the modifier
297  * `onlyOwner`, which can be applied to your functions to restrict their use to
298  * the owner.
299  */
300 abstract contract Ownable is Context {
301     address private _owner;
302 
303     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
304 
305     /**
306      * @dev Initializes the contract setting the deployer as the initial owner.
307      */
308     constructor() {
309         _transferOwnership(_msgSender());
310     }
311 
312     /**
313      * @dev Throws if called by any account other than the owner.
314      */
315     modifier onlyOwner() {
316         _checkOwner();
317         _;
318     }
319 
320     /**
321      * @dev Returns the address of the current owner.
322      */
323     function owner() public view virtual returns (address) {
324         return _owner;
325     }
326 
327     /**
328      * @dev Throws if the sender is not the owner.
329      */
330     function _checkOwner() internal view virtual {
331         require(owner() == _msgSender(), "Ownable: caller is not the owner");
332     }
333 
334     /**
335      * @dev Leaves the contract without owner. It will not be possible to call
336      * `onlyOwner` functions anymore. Can only be called by the current owner.
337      *
338      * NOTE: Renouncing ownership will leave the contract without an owner,
339      * thereby removing any functionality that is only available to the owner.
340      */
341     function renounceOwnership() public virtual onlyOwner {
342         _transferOwnership(address(0));
343     }
344 
345     /**
346      * @dev Transfers ownership of the contract to a new account (`newOwner`).
347      * Can only be called by the current owner.
348      */
349     function transferOwnership(address newOwner) public virtual onlyOwner {
350         require(newOwner != address(0), "Ownable: new owner is the zero address");
351         _transferOwnership(newOwner);
352     }
353 
354     /**
355      * @dev Transfers ownership of the contract to a new account (`newOwner`).
356      * Internal function without access restriction.
357      */
358     function _transferOwnership(address newOwner) internal virtual {
359         address oldOwner = _owner;
360         _owner = newOwner;
361         emit OwnershipTransferred(oldOwner, newOwner);
362     }
363 }
364 
365 /**
366  * @dev String operations.
367  */
368 library Strings {
369     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
370     uint8 private constant _ADDRESS_LENGTH = 20;
371 
372     /**
373      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
374      */
375     function toString(uint256 value) internal pure returns (string memory) {
376         // Inspired by OraclizeAPI's implementation - MIT licence
377         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
378 
379         if (value == 0) {
380             return "0";
381         }
382         uint256 temp = value;
383         uint256 digits;
384         while (temp != 0) {
385             digits++;
386             temp /= 10;
387         }
388         bytes memory buffer = new bytes(digits);
389         while (value != 0) {
390             digits -= 1;
391             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
392             value /= 10;
393         }
394         return string(buffer);
395     }
396 
397     /**
398      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
399      */
400     function toHexString(uint256 value) internal pure returns (string memory) {
401         if (value == 0) {
402             return "0x00";
403         }
404         uint256 temp = value;
405         uint256 length = 0;
406         while (temp != 0) {
407             length++;
408             temp >>= 8;
409         }
410         return toHexString(value, length);
411     }
412 
413     /**
414      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
415      */
416     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
417         bytes memory buffer = new bytes(2 * length + 2);
418         buffer[0] = "0";
419         buffer[1] = "x";
420         for (uint256 i = 2 * length + 1; i > 1; --i) {
421             buffer[i] = _HEX_SYMBOLS[value & 0xf];
422             value >>= 4;
423         }
424         require(value == 0, "Strings: hex length insufficient");
425         return string(buffer);
426     }
427 
428     /**
429      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
430      */
431     function toHexString(address addr) internal pure returns (string memory) {
432         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
433     }
434 }
435 
436 /**
437  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
438  * the Metadata extension. Built to optimize for lower gas during batch mints.
439  *
440  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
441  *
442  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
443  *
444  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
445  */
446 contract ERC721A is IERC721A {
447     // Mask of an entry in packed address data.
448     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
449 
450     // The bit position of `numberMinted` in packed address data.
451     uint256 private constant BITPOS_NUMBER_MINTED = 64;
452 
453     // The bit position of `numberBurned` in packed address data.
454     uint256 private constant BITPOS_NUMBER_BURNED = 128;
455 
456     // The bit position of `aux` in packed address data.
457     uint256 private constant BITPOS_AUX = 192;
458 
459     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
460     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
461 
462     // The bit position of `startTimestamp` in packed ownership.
463     uint256 private constant BITPOS_START_TIMESTAMP = 160;
464 
465     // The bit mask of the `burned` bit in packed ownership.
466     uint256 private constant BITMASK_BURNED = 1 << 224;
467 
468     // The bit position of the `nextInitialized` bit in packed ownership.
469     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
470 
471     // The bit mask of the `nextInitialized` bit in packed ownership.
472     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
473 
474     // The tokenId of the next token to be minted.
475     uint256 private _currentIndex;
476 
477     // The number of tokens burned.
478     uint256 private _burnCounter;
479 
480     // Token name
481     string private _name;
482 
483     // Token symbol
484     string private _symbol;
485 
486     // Mapping from token ID to ownership details
487     // An empty struct value does not necessarily mean the token is unowned.
488     // See `_packedOwnershipOf` implementation for details.
489     //
490     // Bits Layout:
491     // - [0..159]   `addr`
492     // - [160..223] `startTimestamp`
493     // - [224]      `burned`
494     // - [225]      `nextInitialized`
495     mapping(uint256 => uint256) private _packedOwnerships;
496 
497     // Mapping owner address to address data.
498     //
499     // Bits Layout:
500     // - [0..63]    `balance`
501     // - [64..127]  `numberMinted`
502     // - [128..191] `numberBurned`
503     // - [192..255] `aux`
504     mapping(address => uint256) private _packedAddressData;
505 
506     // Mapping from token ID to approved address.
507     mapping(uint256 => address) private _tokenApprovals;
508 
509     // Mapping from owner to operator approvals
510     mapping(address => mapping(address => bool)) private _operatorApprovals;
511 
512     constructor(string memory name_, string memory symbol_) {
513         _name = name_;
514         _symbol = symbol_;
515         _currentIndex = _startTokenId();
516     }
517 
518     /**
519      * @dev Returns the starting token ID.
520      * To change the starting token ID, please override this function.
521      */
522     function _startTokenId() internal view virtual returns (uint256) {
523         return 0;
524     }
525 
526     /**
527      * @dev Returns the next token ID to be minted.
528      */
529     function _nextTokenId() internal view returns (uint256) {
530         return _currentIndex;
531     }
532 
533     /**
534      * @dev Returns the total number of tokens in existence.
535      * Burned tokens will reduce the count.
536      * To get the total number of tokens minted, please see `_totalMinted`.
537      */
538     function totalSupply() public view override returns (uint256) {
539         // Counter underflow is impossible as _burnCounter cannot be incremented
540         // more than `_currentIndex - _startTokenId()` times.
541         unchecked {
542             return _currentIndex - _burnCounter - _startTokenId();
543         }
544     }
545 
546     /**
547      * @dev Returns the total amount of tokens minted in the contract.
548      */
549     function _totalMinted() internal view returns (uint256) {
550         // Counter underflow is impossible as _currentIndex does not decrement,
551         // and it is initialized to `_startTokenId()`
552         unchecked {
553             return _currentIndex - _startTokenId();
554         }
555     }
556 
557     /**
558      * @dev Returns the total number of tokens burned.
559      */
560     function _totalBurned() internal view returns (uint256) {
561         return _burnCounter;
562     }
563 
564     /**
565      * @dev See {IERC165-supportsInterface}.
566      */
567     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
568         // The interface IDs are constants representing the first 4 bytes of the XOR of
569         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
570         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
571         return
572             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
573             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
574             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
575     }
576 
577     /**
578      * @dev See {IERC721-balanceOf}.
579      */
580     function balanceOf(address owner) public view override returns (uint256) {
581         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
582         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
583     }
584 
585     /**
586      * Returns the number of tokens minted by `owner`.
587      */
588     function _numberMinted(address owner) internal view returns (uint256) {
589         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
590     }
591 
592     /**
593      * Returns the number of tokens burned by or on behalf of `owner`.
594      */
595     function _numberBurned(address owner) internal view returns (uint256) {
596         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
597     }
598 
599     /**
600      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
601      */
602     function _getAux(address owner) internal view returns (uint64) {
603         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
604     }
605 
606     /**
607      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
608      * If there are multiple variables, please pack them into a uint64.
609      */
610     function _setAux(address owner, uint64 aux) internal {
611         uint256 packed = _packedAddressData[owner];
612         uint256 auxCasted;
613         assembly {
614             // Cast aux without masking.
615             auxCasted := aux
616         }
617         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
618         _packedAddressData[owner] = packed;
619     }
620 
621     /**
622      * Returns the packed ownership data of `tokenId`.
623      */
624     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
625         uint256 curr = tokenId;
626 
627         unchecked {
628             if (_startTokenId() <= curr)
629                 if (curr < _currentIndex) {
630                     uint256 packed = _packedOwnerships[curr];
631                     // If not burned.
632                     if (packed & BITMASK_BURNED == 0) {
633                         // Invariant:
634                         // There will always be an ownership that has an address and is not burned
635                         // before an ownership that does not have an address and is not burned.
636                         // Hence, curr will not underflow.
637                         //
638                         // We can directly compare the packed value.
639                         // If the address is zero, packed is zero.
640                         while (packed == 0) {
641                             packed = _packedOwnerships[--curr];
642                         }
643                         return packed;
644                     }
645                 }
646         }
647         revert OwnerQueryForNonexistentToken();
648     }
649 
650     /**
651      * Returns the unpacked `TokenOwnership` struct from `packed`.
652      */
653     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
654         ownership.addr = address(uint160(packed));
655         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
656         ownership.burned = packed & BITMASK_BURNED != 0;
657     }
658 
659     /**
660      * Returns the unpacked `TokenOwnership` struct at `index`.
661      */
662     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
663         return _unpackedOwnership(_packedOwnerships[index]);
664     }
665 
666     /**
667      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
668      */
669     function _initializeOwnershipAt(uint256 index) internal {
670         if (_packedOwnerships[index] == 0) {
671             _packedOwnerships[index] = _packedOwnershipOf(index);
672         }
673     }
674 
675     /**
676      * Gas spent here starts off proportional to the maximum mint batch size.
677      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
678      */
679     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
680         return _unpackedOwnership(_packedOwnershipOf(tokenId));
681     }
682 
683     /**
684      * @dev See {IERC721-ownerOf}.
685      */
686     function ownerOf(uint256 tokenId) public view override returns (address) {
687         return address(uint160(_packedOwnershipOf(tokenId)));
688     }
689 
690     /**
691      * @dev See {IERC721Metadata-name}.
692      */
693     function name() public view virtual override returns (string memory) {
694         return _name;
695     }
696 
697     /**
698      * @dev See {IERC721Metadata-symbol}.
699      */
700     function symbol() public view virtual override returns (string memory) {
701         return _symbol;
702     }
703 
704     /**
705      * @dev See {IERC721Metadata-tokenURI}.
706      */
707     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
708         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
709 
710         string memory baseURI = _baseURI();
711         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
712     }
713 
714     /**
715      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
716      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
717      * by default, it can be overridden in child contracts.
718      */
719     function _baseURI() internal view virtual returns (string memory) {
720         return '';
721     }
722 
723     /**
724      * @dev Casts the address to uint256 without masking.
725      */
726     function _addressToUint256(address value) private pure returns (uint256 result) {
727         assembly {
728             result := value
729         }
730     }
731 
732     /**
733      * @dev Casts the boolean to uint256 without branching.
734      */
735     function _boolToUint256(bool value) private pure returns (uint256 result) {
736         assembly {
737             result := value
738         }
739     }
740 
741     /**
742      * @dev See {IERC721-approve}.
743      */
744     function approve(address to, uint256 tokenId) public override {
745         address owner = ownerOf(tokenId);
746 
747         if (_msgSenderERC721A() != owner)
748             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
749                 revert ApprovalCallerNotOwnerNorApproved();
750             }
751 
752         _tokenApprovals[tokenId] = to;
753         emit Approval(owner, to, tokenId);
754     }
755 
756     /**
757      * @dev See {IERC721-getApproved}.
758      */
759     function getApproved(uint256 tokenId) public view override returns (address) {
760         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
761 
762         return _tokenApprovals[tokenId];
763     }
764 
765     /**
766      * @dev See {IERC721-setApprovalForAll}.
767      */
768     function setApprovalForAll(address operator, bool approved) public virtual override {
769         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
770 
771         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
772         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
773     }
774 
775     /**
776      * @dev See {IERC721-isApprovedForAll}.
777      */
778     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
779         return _operatorApprovals[owner][operator];
780     }
781 
782     /**
783      * @dev See {IERC721-transferFrom}.
784      */
785     function transferFrom(
786         address from,
787         address to,
788         uint256 tokenId
789     ) public virtual override {
790         _transfer(from, to, tokenId);
791     }
792 
793     /**
794      * @dev See {IERC721-safeTransferFrom}.
795      */
796     function safeTransferFrom(
797         address from,
798         address to,
799         uint256 tokenId
800     ) public virtual override {
801         safeTransferFrom(from, to, tokenId, '');
802     }
803 
804     /**
805      * @dev See {IERC721-safeTransferFrom}.
806      */
807     function safeTransferFrom(
808         address from,
809         address to,
810         uint256 tokenId,
811         bytes memory _data
812     ) public virtual override {
813         _transfer(from, to, tokenId);
814         if (to.code.length != 0)
815             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
816                 revert TransferToNonERC721ReceiverImplementer();
817             }
818     }
819 
820     /**
821      * @dev Returns whether `tokenId` exists.
822      *
823      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
824      *
825      * Tokens start existing when they are minted (`_mint`),
826      */
827     function _exists(uint256 tokenId) internal view returns (bool) {
828         return
829             _startTokenId() <= tokenId &&
830             tokenId < _currentIndex && // If within bounds,
831             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
832     }
833 
834     /**
835      * @dev Equivalent to `_safeMint(to, quantity, '')`.
836      */
837     function _safeMint(address to, uint256 quantity) internal {
838         _safeMint(to, quantity, '');
839     }
840 
841     /**
842      * @dev Safely mints `quantity` tokens and transfers them to `to`.
843      *
844      * Requirements:
845      *
846      * - If `to` refers to a smart contract, it must implement
847      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
848      * - `quantity` must be greater than 0.
849      *
850      * Emits a {Transfer} event for each mint.
851      */
852     function _safeMint(
853         address to,
854         uint256 quantity,
855         bytes memory _data
856     ) internal virtual {
857 
858         _mint(to, quantity);
859 
860         unchecked {
861             if (to.code.length != 0) {
862                 uint256 end = _currentIndex;
863                 uint256 index = end - quantity;
864                 do {
865                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
866                         revert TransferToNonERC721ReceiverImplementer();
867                     }
868                 } while (index < end);
869                 // Reentrancy protection.
870                 if (_currentIndex != end) revert();
871             }
872         }
873     }
874 
875     /**
876      * @dev Mints `quantity` tokens and transfers them to `to`.
877      *
878      * Requirements:
879      *
880      * - `to` cannot be the zero address.
881      * - `quantity` must be greater than 0.
882      *
883      * Emits a {Transfer} event for each mint.
884      */
885     function _mint(address to, uint256 quantity) internal {
886         uint256 startTokenId = _currentIndex;
887         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
888         if (quantity == 0) revert MintZeroQuantity();
889 
890         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
891 
892         // Overflows are incredibly unrealistic.
893         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
894         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
895         unchecked {
896             // Updates:
897             // - `balance += quantity`.
898             // - `numberMinted += quantity`.
899             //
900             // We can directly add to the balance and number minted.
901             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
902 
903             // Updates:
904             // - `address` to the owner.
905             // - `startTimestamp` to the timestamp of minting.
906             // - `burned` to `false`.
907             // - `nextInitialized` to `quantity == 1`.
908             _packedOwnerships[startTokenId] =
909                 _addressToUint256(to) |
910                 (block.timestamp << BITPOS_START_TIMESTAMP) |
911                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
912 
913             uint256 offset;
914             do {
915                 emit Transfer(address(0), to, startTokenId + offset++);
916             } while (offset < quantity);
917 
918             _currentIndex = startTokenId + quantity;
919         }
920         _afterTokenTransfers(address(0), to, startTokenId, quantity);
921     }
922 
923     /**
924      * @dev Transfers `tokenId` from `from` to `to`.
925      *
926      * Requirements:
927      *
928      * - `to` cannot be the zero address.
929      * - `tokenId` token must be owned by `from`.
930      *
931      * Emits a {Transfer} event.
932      */
933     function _transfer(
934         address from,
935         address to,
936         uint256 tokenId
937     ) private {
938         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
939 
940         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
941 
942         address approvedAddress = _tokenApprovals[tokenId];
943 
944         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
945             isApprovedForAll(from, _msgSenderERC721A()) ||
946             approvedAddress == _msgSenderERC721A());
947 
948         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
949         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
950 
951         _beforeTokenTransfers(from, to, tokenId, 1);
952 
953         // Clear approvals from the previous owner.
954         if (_addressToUint256(approvedAddress) != 0) {
955             delete _tokenApprovals[tokenId];
956         }
957 
958         // Underflow of the sender's balance is impossible because we check for
959         // ownership above and the recipient's balance can't realistically overflow.
960         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
961         unchecked {
962             // We can directly increment and decrement the balances.
963             --_packedAddressData[from]; // Updates: `balance -= 1`.
964             ++_packedAddressData[to]; // Updates: `balance += 1`.
965 
966             // Updates:
967             // - `address` to the next owner.
968             // - `startTimestamp` to the timestamp of transfering.
969             // - `burned` to `false`.
970             // - `nextInitialized` to `true`.
971             _packedOwnerships[tokenId] =
972                 _addressToUint256(to) |
973                 (block.timestamp << BITPOS_START_TIMESTAMP) |
974                 BITMASK_NEXT_INITIALIZED;
975 
976             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
977             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
978                 uint256 nextTokenId = tokenId + 1;
979                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
980                 if (_packedOwnerships[nextTokenId] == 0) {
981                     // If the next slot is within bounds.
982                     if (nextTokenId != _currentIndex) {
983                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
984                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
985                     }
986                 }
987             }
988         }
989 
990         emit Transfer(from, to, tokenId);
991         _afterTokenTransfers(from, to, tokenId, 1);
992     }
993 
994     /**
995      * @dev Equivalent to `_burn(tokenId, false)`.
996      */
997     function _burn(uint256 tokenId) internal virtual {
998         _burn(tokenId, false);
999     }
1000 
1001     /**
1002      * @dev Destroys `tokenId`.
1003      * The approval is cleared when the token is burned.
1004      *
1005      * Requirements:
1006      *
1007      * - `tokenId` must exist.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1012         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1013 
1014         address from = address(uint160(prevOwnershipPacked));
1015         address approvedAddress = _tokenApprovals[tokenId];
1016 
1017         if (approvalCheck) {
1018             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1019                 isApprovedForAll(from, _msgSenderERC721A()) ||
1020                 approvedAddress == _msgSenderERC721A());
1021 
1022             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1023         }
1024 
1025         _beforeTokenTransfers(from, address(0), tokenId, 1);
1026 
1027         // Clear approvals from the previous owner.
1028         if (_addressToUint256(approvedAddress) != 0) {
1029             delete _tokenApprovals[tokenId];
1030         }
1031 
1032         // Underflow of the sender's balance is impossible because we check for
1033         // ownership above and the recipient's balance can't realistically overflow.
1034         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1035         unchecked {
1036             // Updates:
1037             // - `balance -= 1`.
1038             // - `numberBurned += 1`.
1039             //
1040             // We can directly decrement the balance, and increment the number burned.
1041             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1042             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1043 
1044             // Updates:
1045             // - `address` to the last owner.
1046             // - `startTimestamp` to the timestamp of burning.
1047             // - `burned` to `true`.
1048             // - `nextInitialized` to `true`.
1049             _packedOwnerships[tokenId] =
1050                 _addressToUint256(from) |
1051                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1052                 BITMASK_BURNED |
1053                 BITMASK_NEXT_INITIALIZED;
1054 
1055             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1056             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
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
1078     /**
1079      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1080      *
1081      * @param from address representing the previous owner of the given token ID
1082      * @param to target address that will receive the tokens
1083      * @param tokenId uint256 ID of the token to be transferred
1084      * @param _data bytes optional data to send along with the call
1085      * @return bool whether the call correctly returned the expected magic value
1086      */
1087     function _checkContractOnERC721Received(
1088         address from,
1089         address to,
1090         uint256 tokenId,
1091         bytes memory _data
1092     ) public virtual returns (bool) {
1093         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1094             bytes4 retval
1095         ) {
1096             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1097         } catch (bytes memory reason) {
1098             if (reason.length == 0) {
1099                 revert TransferToNonERC721ReceiverImplementer();
1100             } else {
1101                 assembly {
1102                     revert(add(32, reason), mload(reason))
1103                 }
1104             }
1105         }
1106     }
1107 
1108     /**
1109      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1110      * And also called before burning one token.
1111      *
1112      * startTokenId - the first token id to be transferred
1113      * quantity - the amount to be transferred
1114      *
1115      * Calling conditions:
1116      *
1117      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1118      * transferred to `to`.
1119      * - When `from` is zero, `tokenId` will be minted for `to`.
1120      * - When `to` is zero, `tokenId` will be burned by `from`.
1121      * - `from` and `to` are never both zero.
1122      */
1123     function _beforeTokenTransfers(
1124         address from,
1125         address to,
1126         uint256 startTokenId,
1127         uint256 quantity
1128     ) internal virtual {}
1129 
1130     /**
1131      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1132      * minting.
1133      * And also called after one token has been burned.
1134      *
1135      * startTokenId - the first token id to be transferred
1136      * quantity - the amount to be transferred
1137      *
1138      * Calling conditions:
1139      *
1140      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1141      * transferred to `to`.
1142      * - When `from` is zero, `tokenId` has been minted for `to`.
1143      * - When `to` is zero, `tokenId` has been burned by `from`.
1144      * - `from` and `to` are never both zero.
1145      */
1146     function _afterTokenTransfers(
1147         address from,
1148         address to,
1149         uint256 startTokenId,
1150         uint256 quantity
1151     ) internal virtual {}
1152 
1153     /**
1154      * @dev Returns the message sender (defaults to `msg.sender`).
1155      *
1156      * If you are writing GSN compatible contracts, you need to override this function.
1157      */
1158     function _msgSenderERC721A() internal view virtual returns (address) {
1159         return msg.sender;
1160     }
1161 
1162     /**
1163      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1164      */
1165     function _toString(uint256 value) internal pure returns (string memory ptr) {
1166         assembly {
1167             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1168             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1169             // We will need 1 32-byte word to store the length,
1170             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1171             ptr := add(mload(0x40), 128)
1172             // Update the free memory pointer to allocate.
1173             mstore(0x40, ptr)
1174 
1175             // Cache the end of the memory to calculate the length later.
1176             let end := ptr
1177 
1178             // We write the string from the rightmost digit to the leftmost digit.
1179             // The following is essentially a do-while loop that also handles the zero case.
1180             // Costs a bit more than early returning for the zero case,
1181             // but cheaper in terms of deployment and overall runtime costs.
1182             for {
1183                 // Initialize and perform the first pass without check.
1184                 let temp := value
1185                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1186                 ptr := sub(ptr, 1)
1187                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1188                 mstore8(ptr, add(48, mod(temp, 10)))
1189                 temp := div(temp, 10)
1190             } temp {
1191                 // Keep dividing `temp` until zero.
1192                 temp := div(temp, 10)
1193             } {
1194                 // Body of the for loop.
1195                 ptr := sub(ptr, 1)
1196                 mstore8(ptr, add(48, mod(temp, 10)))
1197             }
1198 
1199             let length := sub(end, ptr)
1200             // Move the pointer 32 bytes leftwards to make room for the length.
1201             ptr := sub(ptr, 32)
1202             // Store the length.
1203             mstore(ptr, length)
1204         }
1205     }
1206 }
1207 
1208 contract ClownPresale {
1209 
1210 	mapping (address => uint8) public _presaleAddresses;
1211 	mapping (address => bool) public _presaleAddressesMinted;
1212 	address public owner;
1213 
1214     constructor () {
1215         owner = msg.sender;
1216     }
1217 
1218     function setMainContract(address _address) public {
1219         require(msg.sender == owner, "Clowns: You are not the owner");
1220         owner = _address;
1221     }
1222 
1223     function addPresalers(address[] calldata _addresses) public {
1224         require(msg.sender == owner, "Clowns: You are not the owner");
1225         for (uint x = 0; x < _addresses.length; x++) {
1226             _presaleAddresses[_addresses[x]] = 1;
1227         }
1228     }
1229     
1230     function removePresalers(address[] calldata _addresses) public {
1231         require(msg.sender == owner, "Clowns: You are not the owner");
1232         for (uint x = 0; x < _addresses.length; x++) {
1233             _presaleAddresses[_addresses[x]] = 0;
1234         }
1235     }
1236 
1237     function isInPresale(address _address) public view returns (uint8) {
1238         return _presaleAddresses[_address];
1239     }
1240 
1241     function isInMintedPresale(address _address) public view returns (bool) {
1242         return _presaleAddressesMinted[_address];
1243     }
1244 
1245     function addToMinted(address _address) public {
1246         require(msg.sender == owner, "Clowns: You are not the owner");
1247         _presaleAddressesMinted[_address] = true;
1248     }
1249 
1250 }
1251 
1252 contract ClownSquad is ERC721A, Ownable {
1253     using Strings for uint256;
1254 
1255     string public baseURI;
1256     uint256 public MAX = 7777;
1257 
1258 	uint _saleTime = 1655697600;
1259 	uint _presaleTime = 1655676000;
1260 	uint _presaleTimeEnd = 1655726400;
1261     uint256 _price = 30000000000000000;
1262     address public _presaleContract;
1263 	address[] public _presaleAddresses;
1264 	address[] public _presaleAddressesMinted;
1265     mapping (uint256 => string) public _tokenURI;
1266     mapping(address => bool) public _minters;
1267     mapping(address => bool) public _mintersLast;
1268     mapping(address => bool) public _presaleAlreadyMinted;
1269 
1270     // The tokenId of the next token to be minted.
1271     uint256 private _currentIndex;
1272 
1273     constructor (string memory _initialBaseURI, address presaleContract) ERC721A("ClownSquad", "CS") {
1274         baseURI = _initialBaseURI;
1275         _presaleContract = presaleContract;
1276     }
1277 
1278     function setBaseURI(string calldata _baseURI) external onlyOwner {
1279         baseURI = _baseURI;
1280     }
1281 
1282     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1283         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1284 
1285         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1286     }
1287 
1288     function price(uint _count) public view returns (uint256) {
1289         return _price * _count;
1290     }
1291 
1292     function mint(address to, uint256 quantity) public payable {
1293         require(totalSupply() + quantity <= MAX, "Clowns: Not enough left to mint");
1294         require(totalSupply() < MAX, "Clowns: Not enough left to mint");
1295         require(block.timestamp >= _saleTime, "Clowns: Not sale time yet!");
1296 
1297         if (quantity > 1 && _minters[msg.sender] == false) {
1298             require(quantity == 2, "Clowns: Exceeds the max you can mint");
1299             require(msg.value >= price(quantity-1), "Clowns: Value below price");
1300             _safeMint(to, quantity, '');
1301             _minters[msg.sender] = true;
1302             _mintersLast[msg.sender] = true;
1303         } else if (quantity == 1 && _minters[msg.sender] == false) {
1304             require(quantity == 1, "Clowns: Exceeds the max you can mint");
1305             _safeMint(to, quantity, '');
1306             _minters[msg.sender] = true;
1307         } else if (_minters[msg.sender] == true && _mintersLast[msg.sender] == false) {
1308             require(quantity == 1, "Clowns: Exceeds the max you can mint");
1309             require(msg.value >= price(quantity), "Clowns: Value below price");
1310             _safeMint(to, quantity, '');
1311             _mintersLast[msg.sender] = true;
1312         }
1313     }
1314 
1315     function mintFromPresale(address to, uint256 quantity) public payable {
1316         require(block.timestamp < _presaleTimeEnd && block.timestamp >= _presaleTime, "Clowns: Presale ended!");
1317         require(totalSupply() + quantity <= MAX, "Clowns: Not enough left to mint");
1318         require(totalSupply() < MAX, "Clowns: Not enough left to mint");
1319         require(quantity == 1, "Clowns: Exceeds the max you can mint");
1320         require(quantity <= ClownPresale(_presaleContract).isInPresale(msg.sender), "Clowns: Exceeds the max you can mint in the presale");
1321         require(ClownPresale(_presaleContract).isInPresale(msg.sender) > 0, "Clowns: You are not in the presale");
1322         require(_presaleAlreadyMinted[msg.sender] == false, "Clowns: You already minted from the presale");
1323 
1324         _safeMint(to, quantity, '');
1325         _presaleAlreadyMinted[msg.sender] = true;
1326 
1327     }
1328 
1329     function didMintPresale(address addr) public view returns (bool) {
1330         return _presaleAlreadyMinted[addr];
1331     }
1332 
1333     function reserve(uint256 quantity) public payable onlyOwner {
1334         require(totalSupply() + quantity <= MAX, "Clowns: Not enough left to mint");
1335         require(totalSupply() < MAX, "Clowns: Not enough left to mint");
1336 
1337         _safeMint(msg.sender, quantity, '');
1338 
1339     }
1340 
1341     function didHeMintTheFreeOne(address addr) public view returns (bool) {
1342         return _minters[addr];
1343     }
1344 
1345     function didHeMint(address addr) public view returns (bool) {
1346         return _mintersLast[addr];
1347     }
1348 
1349     /**
1350      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1351      *
1352      * Requirements:
1353      *
1354      * - If `to` refers to a smart contract, it must implement
1355      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1356      * - `quantity` must be greater than 0.
1357      *
1358      * Emits a {Transfer} event for each mint.
1359      */
1360     function _safeMint(
1361         address to,
1362         uint256 quantity,
1363         bytes memory _data
1364     ) internal override {
1365 
1366         _mint(to, quantity);
1367 
1368         unchecked {
1369             if (to.code.length != 0) {
1370                 uint256 end = _currentIndex;
1371                 uint256 index = end - quantity;
1372                 do {
1373                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1374                         revert TransferToNonERC721ReceiverImplementer();
1375                     }
1376                 } while (index < end);
1377                 // Reentrancy protection.
1378                 if (_currentIndex != end) revert();
1379             }
1380         }
1381     }
1382 
1383     /**
1384      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1385      *
1386      * @param from address representing the previous owner of the given token ID
1387      * @param to target address that will receive the tokens
1388      * @param tokenId uint256 ID of the token to be transferred
1389      * @param _data bytes optional data to send along with the call
1390      * @return bool whether the call correctly returned the expected magic value
1391      */
1392     function _checkContractOnERC721Received(
1393         address from,
1394         address to,
1395         uint256 tokenId,
1396         bytes memory _data
1397     ) public override returns (bool) {
1398         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1399             bytes4 retval
1400         ) {
1401             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1402         } catch (bytes memory reason) {
1403             if (reason.length == 0) {
1404                 revert TransferToNonERC721ReceiverImplementer();
1405             } else {
1406                 assembly {
1407                     revert(add(32, reason), mload(reason))
1408                 }
1409             }
1410         }
1411     }
1412 
1413     function withdrawAll() public payable onlyOwner {
1414         require(payable(msg.sender).send(address(this).balance));
1415     }
1416 }
1417 
1418 // Creator: Elit Deus (Bleiserman)