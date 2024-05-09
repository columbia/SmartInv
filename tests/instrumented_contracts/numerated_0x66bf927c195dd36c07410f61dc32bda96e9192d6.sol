1 //    _   _  ___  ____ _____ _   _ _____ ____  _   _   _     ___ ____ _   _ _____ ____  
2 //   | \ | |/ _ \|  _ \_   _| | | | ____|  _ \| \ | | | |   |_ _/ ___| | | |_   _/ ___| 
3 //   |  \| | | | | |_) || | | |_| |  _| | |_) |  \| | | |    | | |  _| |_| | | | \___ \ 
4 //   | |\  | |_| |  _ < | | |  _  | |___|  _ <| |\  | | |___ | | |_| |  _  | | |  ___) |
5 //   |_| \_|\___/|_| \_\|_| |_| |_|_____|_| \_\_| \_| |_____|___\____|_| |_| |_| |____/ 
6 //                                                                                      
7 
8 
9 // File: @openzeppelin/contracts/utils/Strings.sol
10 
11 
12 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev String operations.
18  */
19 library Strings {
20     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
21     uint8 private constant _ADDRESS_LENGTH = 20;
22 
23     /**
24      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
25      */
26     function toString(uint256 value) internal pure returns (string memory) {
27         // Inspired by OraclizeAPI's implementation - MIT licence
28         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
29 
30         if (value == 0) {
31             return "0";
32         }
33         uint256 temp = value;
34         uint256 digits;
35         while (temp != 0) {
36             digits++;
37             temp /= 10;
38         }
39         bytes memory buffer = new bytes(digits);
40         while (value != 0) {
41             digits -= 1;
42             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
43             value /= 10;
44         }
45         return string(buffer);
46     }
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
50      */
51     function toHexString(uint256 value) internal pure returns (string memory) {
52         if (value == 0) {
53             return "0x00";
54         }
55         uint256 temp = value;
56         uint256 length = 0;
57         while (temp != 0) {
58             length++;
59             temp >>= 8;
60         }
61         return toHexString(value, length);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
66      */
67     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
68         bytes memory buffer = new bytes(2 * length + 2);
69         buffer[0] = "0";
70         buffer[1] = "x";
71         for (uint256 i = 2 * length + 1; i > 1; --i) {
72             buffer[i] = _HEX_SYMBOLS[value & 0xf];
73             value >>= 4;
74         }
75         require(value == 0, "Strings: hex length insufficient");
76         return string(buffer);
77     }
78 
79     /**
80      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
81      */
82     function toHexString(address addr) internal pure returns (string memory) {
83         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
84     }
85 }
86 
87 // File: @openzeppelin/contracts/utils/Context.sol
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Provides information about the current execution context, including the
96  * sender of the transaction and its data. While these are generally available
97  * via msg.sender and msg.data, they should not be accessed in such a direct
98  * manner, since when dealing with meta-transactions the account sending and
99  * paying for execution may not be the actual sender (as far as an application
100  * is concerned).
101  *
102  * This contract is only required for intermediate, library-like contracts.
103  */
104 abstract contract Context {
105     function _msgSender() internal view virtual returns (address) {
106         return msg.sender;
107     }
108 
109     function _msgData() internal view virtual returns (bytes calldata) {
110         return msg.data;
111     }
112 }
113 
114 // File: @openzeppelin/contracts/access/Ownable.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 
122 /**
123  * @dev Contract module which provides a basic access control mechanism, where
124  * there is an account (an owner) that can be granted exclusive access to
125  * specific functions.
126  *
127  * By default, the owner account will be the one that deploys the contract. This
128  * can later be changed with {transferOwnership}.
129  *
130  * This module is used through inheritance. It will make available the modifier
131  * `onlyOwner`, which can be applied to your functions to restrict their use to
132  * the owner.
133  */
134 abstract contract Ownable is Context {
135     address private _owner;
136 
137     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
138 
139     /**
140      * @dev Initializes the contract setting the deployer as the initial owner.
141      */
142     constructor() {
143         _transferOwnership(_msgSender());
144     }
145 
146     /**
147      * @dev Throws if called by any account other than the owner.
148      */
149     modifier onlyOwner() {
150         _checkOwner();
151         _;
152     }
153 
154     /**
155      * @dev Returns the address of the current owner.
156      */
157     function owner() public view virtual returns (address) {
158         return _owner;
159     }
160 
161     /**
162      * @dev Throws if the sender is not the owner.
163      */
164     function _checkOwner() internal view virtual {
165         require(owner() == _msgSender(), "Ownable: caller is not the owner");
166     }
167 
168     /**
169      * @dev Leaves the contract without owner. It will not be possible to call
170      * `onlyOwner` functions anymore. Can only be called by the current owner.
171      *
172      * NOTE: Renouncing ownership will leave the contract without an owner,
173      * thereby removing any functionality that is only available to the owner.
174      */
175     function renounceOwnership() public virtual onlyOwner {
176         _transferOwnership(address(0));
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      * Can only be called by the current owner.
182      */
183     function transferOwnership(address newOwner) public virtual onlyOwner {
184         require(newOwner != address(0), "Ownable: new owner is the zero address");
185         _transferOwnership(newOwner);
186     }
187 
188     /**
189      * @dev Transfers ownership of the contract to a new account (`newOwner`).
190      * Internal function without access restriction.
191      */
192     function _transferOwnership(address newOwner) internal virtual {
193         address oldOwner = _owner;
194         _owner = newOwner;
195         emit OwnershipTransferred(oldOwner, newOwner);
196     }
197 }
198 
199 // File: erc721a/contracts/IERC721A.sol
200 
201 
202 // ERC721A Contracts v4.1.0
203 // Creator: Chiru Labs
204 
205 pragma solidity ^0.8.4;
206 
207 /**
208  * @dev Interface of an ERC721A compliant contract.
209  */
210 interface IERC721A {
211     /**
212      * The caller must own the token or be an approved operator.
213      */
214     error ApprovalCallerNotOwnerNorApproved();
215 
216     /**
217      * The token does not exist.
218      */
219     error ApprovalQueryForNonexistentToken();
220 
221     /**
222      * The caller cannot approve to their own address.
223      */
224     error ApproveToCaller();
225 
226     /**
227      * Cannot query the balance for the zero address.
228      */
229     error BalanceQueryForZeroAddress();
230 
231     /**
232      * Cannot mint to the zero address.
233      */
234     error MintToZeroAddress();
235 
236     /**
237      * The quantity of tokens minted must be more than zero.
238      */
239     error MintZeroQuantity();
240 
241     /**
242      * The token does not exist.
243      */
244     error OwnerQueryForNonexistentToken();
245 
246     /**
247      * The caller must own the token or be an approved operator.
248      */
249     error TransferCallerNotOwnerNorApproved();
250 
251     /**
252      * The token must be owned by `from`.
253      */
254     error TransferFromIncorrectOwner();
255 
256     /**
257      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
258      */
259     error TransferToNonERC721ReceiverImplementer();
260 
261     /**
262      * Cannot transfer to the zero address.
263      */
264     error TransferToZeroAddress();
265 
266     /**
267      * The token does not exist.
268      */
269     error URIQueryForNonexistentToken();
270 
271     /**
272      * The `quantity` minted with ERC2309 exceeds the safety limit.
273      */
274     error MintERC2309QuantityExceedsLimit();
275 
276     /**
277      * The `extraData` cannot be set on an unintialized ownership slot.
278      */
279     error OwnershipNotInitializedForExtraData();
280 
281     struct TokenOwnership {
282         // The address of the owner.
283         address addr;
284         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
285         uint64 startTimestamp;
286         // Whether the token has been burned.
287         bool burned;
288         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
289         uint24 extraData;
290     }
291 
292     /**
293      * @dev Returns the total amount of tokens stored by the contract.
294      *
295      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
296      */
297     function totalSupply() external view returns (uint256);
298 
299     // ==============================
300     //            IERC165
301     // ==============================
302 
303     /**
304      * @dev Returns true if this contract implements the interface defined by
305      * `interfaceId`. See the corresponding
306      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
307      * to learn more about how these ids are created.
308      *
309      * This function call must use less than 30 000 gas.
310      */
311     function supportsInterface(bytes4 interfaceId) external view returns (bool);
312 
313     // ==============================
314     //            IERC721
315     // ==============================
316 
317     /**
318      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
319      */
320     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
321 
322     /**
323      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
324      */
325     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
326 
327     /**
328      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
329      */
330     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
331 
332     /**
333      * @dev Returns the number of tokens in ``owner``'s account.
334      */
335     function balanceOf(address owner) external view returns (uint256 balance);
336 
337     /**
338      * @dev Returns the owner of the `tokenId` token.
339      *
340      * Requirements:
341      *
342      * - `tokenId` must exist.
343      */
344     function ownerOf(uint256 tokenId) external view returns (address owner);
345 
346     /**
347      * @dev Safely transfers `tokenId` token from `from` to `to`.
348      *
349      * Requirements:
350      *
351      * - `from` cannot be the zero address.
352      * - `to` cannot be the zero address.
353      * - `tokenId` token must exist and be owned by `from`.
354      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
355      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
356      *
357      * Emits a {Transfer} event.
358      */
359     function safeTransferFrom(
360         address from,
361         address to,
362         uint256 tokenId,
363         bytes calldata data
364     ) external;
365 
366     /**
367      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
368      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
369      *
370      * Requirements:
371      *
372      * - `from` cannot be the zero address.
373      * - `to` cannot be the zero address.
374      * - `tokenId` token must exist and be owned by `from`.
375      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
376      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
377      *
378      * Emits a {Transfer} event.
379      */
380     function safeTransferFrom(
381         address from,
382         address to,
383         uint256 tokenId
384     ) external;
385 
386     /**
387      * @dev Transfers `tokenId` token from `from` to `to`.
388      *
389      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
390      *
391      * Requirements:
392      *
393      * - `from` cannot be the zero address.
394      * - `to` cannot be the zero address.
395      * - `tokenId` token must be owned by `from`.
396      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
397      *
398      * Emits a {Transfer} event.
399      */
400     function transferFrom(
401         address from,
402         address to,
403         uint256 tokenId
404     ) external;
405 
406     /**
407      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
408      * The approval is cleared when the token is transferred.
409      *
410      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
411      *
412      * Requirements:
413      *
414      * - The caller must own the token or be an approved operator.
415      * - `tokenId` must exist.
416      *
417      * Emits an {Approval} event.
418      */
419     function approve(address to, uint256 tokenId) external;
420 
421     /**
422      * @dev Approve or remove `operator` as an operator for the caller.
423      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
424      *
425      * Requirements:
426      *
427      * - The `operator` cannot be the caller.
428      *
429      * Emits an {ApprovalForAll} event.
430      */
431     function setApprovalForAll(address operator, bool _approved) external;
432 
433     /**
434      * @dev Returns the account approved for `tokenId` token.
435      *
436      * Requirements:
437      *
438      * - `tokenId` must exist.
439      */
440     function getApproved(uint256 tokenId) external view returns (address operator);
441 
442     /**
443      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
444      *
445      * See {setApprovalForAll}
446      */
447     function isApprovedForAll(address owner, address operator) external view returns (bool);
448 
449     // ==============================
450     //        IERC721Metadata
451     // ==============================
452 
453     /**
454      * @dev Returns the token collection name.
455      */
456     function name() external view returns (string memory);
457 
458     /**
459      * @dev Returns the token collection symbol.
460      */
461     function symbol() external view returns (string memory);
462 
463     /**
464      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
465      */
466     function tokenURI(uint256 tokenId) external view returns (string memory);
467 
468     // ==============================
469     //            IERC2309
470     // ==============================
471 
472     /**
473      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
474      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
475      */
476     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
477 }
478 
479 // File: erc721a/contracts/ERC721A.sol
480 
481 
482 // ERC721A Contracts v4.1.0
483 // Creator: Chiru Labs
484 
485 pragma solidity ^0.8.4;
486 
487 
488 /**
489  * @dev ERC721 token receiver interface.
490  */
491 interface ERC721A__IERC721Receiver {
492     function onERC721Received(
493         address operator,
494         address from,
495         uint256 tokenId,
496         bytes calldata data
497     ) external returns (bytes4);
498 }
499 
500 /**
501  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
502  * including the Metadata extension. Built to optimize for lower gas during batch mints.
503  *
504  * Assumes serials are sequentially minted starting at `_startTokenId()`
505  * (defaults to 0, e.g. 0, 1, 2, 3..).
506  *
507  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
508  *
509  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
510  */
511 contract ERC721A is IERC721A {
512     // Mask of an entry in packed address data.
513     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
514 
515     // The bit position of `numberMinted` in packed address data.
516     uint256 private constant BITPOS_NUMBER_MINTED = 64;
517 
518     // The bit position of `numberBurned` in packed address data.
519     uint256 private constant BITPOS_NUMBER_BURNED = 128;
520 
521     // The bit position of `aux` in packed address data.
522     uint256 private constant BITPOS_AUX = 192;
523 
524     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
525     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
526 
527     // The bit position of `startTimestamp` in packed ownership.
528     uint256 private constant BITPOS_START_TIMESTAMP = 160;
529 
530     // The bit mask of the `burned` bit in packed ownership.
531     uint256 private constant BITMASK_BURNED = 1 << 224;
532 
533     // The bit position of the `nextInitialized` bit in packed ownership.
534     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
535 
536     // The bit mask of the `nextInitialized` bit in packed ownership.
537     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
538 
539     // The bit position of `extraData` in packed ownership.
540     uint256 private constant BITPOS_EXTRA_DATA = 232;
541 
542     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
543     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
544 
545     // The mask of the lower 160 bits for addresses.
546     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
547 
548     // The maximum `quantity` that can be minted with `_mintERC2309`.
549     // This limit is to prevent overflows on the address data entries.
550     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
551     // is required to cause an overflow, which is unrealistic.
552     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
553 
554     // The tokenId of the next token to be minted.
555     uint256 private _currentIndex;
556 
557     // The number of tokens burned.
558     uint256 private _burnCounter;
559 
560     // Token name
561     string private _name;
562 
563     // Token symbol
564     string private _symbol;
565 
566     // Mapping from token ID to ownership details
567     // An empty struct value does not necessarily mean the token is unowned.
568     // See `_packedOwnershipOf` implementation for details.
569     //
570     // Bits Layout:
571     // - [0..159]   `addr`
572     // - [160..223] `startTimestamp`
573     // - [224]      `burned`
574     // - [225]      `nextInitialized`
575     // - [232..255] `extraData`
576     mapping(uint256 => uint256) private _packedOwnerships;
577 
578     // Mapping owner address to address data.
579     //
580     // Bits Layout:
581     // - [0..63]    `balance`
582     // - [64..127]  `numberMinted`
583     // - [128..191] `numberBurned`
584     // - [192..255] `aux`
585     mapping(address => uint256) private _packedAddressData;
586 
587     // Mapping from token ID to approved address.
588     mapping(uint256 => address) private _tokenApprovals;
589 
590     // Mapping from owner to operator approvals
591     mapping(address => mapping(address => bool)) private _operatorApprovals;
592 
593     constructor(string memory name_, string memory symbol_) {
594         _name = name_;
595         _symbol = symbol_;
596         _currentIndex = _startTokenId();
597     }
598 
599     /**
600      * @dev Returns the starting token ID.
601      * To change the starting token ID, please override this function.
602      */
603     function _startTokenId() internal view virtual returns (uint256) {
604         return 0;
605     }
606 
607     /**
608      * @dev Returns the next token ID to be minted.
609      */
610     function _nextTokenId() internal view returns (uint256) {
611         return _currentIndex;
612     }
613 
614     /**
615      * @dev Returns the total number of tokens in existence.
616      * Burned tokens will reduce the count.
617      * To get the total number of tokens minted, please see `_totalMinted`.
618      */
619     function totalSupply() public view override returns (uint256) {
620         // Counter underflow is impossible as _burnCounter cannot be incremented
621         // more than `_currentIndex - _startTokenId()` times.
622         unchecked {
623             return _currentIndex - _burnCounter - _startTokenId();
624         }
625     }
626 
627     /**
628      * @dev Returns the total amount of tokens minted in the contract.
629      */
630     function _totalMinted() internal view returns (uint256) {
631         // Counter underflow is impossible as _currentIndex does not decrement,
632         // and it is initialized to `_startTokenId()`
633         unchecked {
634             return _currentIndex - _startTokenId();
635         }
636     }
637 
638     /**
639      * @dev Returns the total number of tokens burned.
640      */
641     function _totalBurned() internal view returns (uint256) {
642         return _burnCounter;
643     }
644 
645     /**
646      * @dev See {IERC165-supportsInterface}.
647      */
648     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
649         // The interface IDs are constants representing the first 4 bytes of the XOR of
650         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
651         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
652         return
653             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
654             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
655             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
656     }
657 
658     /**
659      * @dev See {IERC721-balanceOf}.
660      */
661     function balanceOf(address owner) public view override returns (uint256) {
662         if (owner == address(0)) revert BalanceQueryForZeroAddress();
663         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
664     }
665 
666     /**
667      * Returns the number of tokens minted by `owner`.
668      */
669     function _numberMinted(address owner) internal view returns (uint256) {
670         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
671     }
672 
673     /**
674      * Returns the number of tokens burned by or on behalf of `owner`.
675      */
676     function _numberBurned(address owner) internal view returns (uint256) {
677         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
678     }
679 
680     /**
681      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
682      */
683     function _getAux(address owner) internal view returns (uint64) {
684         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
685     }
686 
687     /**
688      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
689      * If there are multiple variables, please pack them into a uint64.
690      */
691     function _setAux(address owner, uint64 aux) internal {
692         uint256 packed = _packedAddressData[owner];
693         uint256 auxCasted;
694         // Cast `aux` with assembly to avoid redundant masking.
695         assembly {
696             auxCasted := aux
697         }
698         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
699         _packedAddressData[owner] = packed;
700     }
701 
702     /**
703      * Returns the packed ownership data of `tokenId`.
704      */
705     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
706         uint256 curr = tokenId;
707 
708         unchecked {
709             if (_startTokenId() <= curr)
710                 if (curr < _currentIndex) {
711                     uint256 packed = _packedOwnerships[curr];
712                     // If not burned.
713                     if (packed & BITMASK_BURNED == 0) {
714                         // Invariant:
715                         // There will always be an ownership that has an address and is not burned
716                         // before an ownership that does not have an address and is not burned.
717                         // Hence, curr will not underflow.
718                         //
719                         // We can directly compare the packed value.
720                         // If the address is zero, packed is zero.
721                         while (packed == 0) {
722                             packed = _packedOwnerships[--curr];
723                         }
724                         return packed;
725                     }
726                 }
727         }
728         revert OwnerQueryForNonexistentToken();
729     }
730 
731     /**
732      * Returns the unpacked `TokenOwnership` struct from `packed`.
733      */
734     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
735         ownership.addr = address(uint160(packed));
736         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
737         ownership.burned = packed & BITMASK_BURNED != 0;
738         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
739     }
740 
741     /**
742      * Returns the unpacked `TokenOwnership` struct at `index`.
743      */
744     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
745         return _unpackedOwnership(_packedOwnerships[index]);
746     }
747 
748     /**
749      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
750      */
751     function _initializeOwnershipAt(uint256 index) internal {
752         if (_packedOwnerships[index] == 0) {
753             _packedOwnerships[index] = _packedOwnershipOf(index);
754         }
755     }
756 
757     /**
758      * Gas spent here starts off proportional to the maximum mint batch size.
759      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
760      */
761     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
762         return _unpackedOwnership(_packedOwnershipOf(tokenId));
763     }
764 
765     /**
766      * @dev Packs ownership data into a single uint256.
767      */
768     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
769         assembly {
770             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
771             owner := and(owner, BITMASK_ADDRESS)
772             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
773             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
774         }
775     }
776 
777     /**
778      * @dev See {IERC721-ownerOf}.
779      */
780     function ownerOf(uint256 tokenId) public view override returns (address) {
781         return address(uint160(_packedOwnershipOf(tokenId)));
782     }
783 
784     /**
785      * @dev See {IERC721Metadata-name}.
786      */
787     function name() public view virtual override returns (string memory) {
788         return _name;
789     }
790 
791     /**
792      * @dev See {IERC721Metadata-symbol}.
793      */
794     function symbol() public view virtual override returns (string memory) {
795         return _symbol;
796     }
797 
798     /**
799      * @dev See {IERC721Metadata-tokenURI}.
800      */
801     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
802         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
803 
804         string memory baseURI = _baseURI();
805         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
806     }
807 
808     /**
809      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
810      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
811      * by default, it can be overridden in child contracts.
812      */
813     function _baseURI() internal view virtual returns (string memory) {
814         return '';
815     }
816 
817     /**
818      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
819      */
820     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
821         // For branchless setting of the `nextInitialized` flag.
822         assembly {
823             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
824             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
825         }
826     }
827 
828     /**
829      * @dev See {IERC721-approve}.
830      */
831     function approve(address to, uint256 tokenId) public override {
832         address owner = ownerOf(tokenId);
833 
834         if (_msgSenderERC721A() != owner)
835             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
836                 revert ApprovalCallerNotOwnerNorApproved();
837             }
838 
839         _tokenApprovals[tokenId] = to;
840         emit Approval(owner, to, tokenId);
841     }
842 
843     /**
844      * @dev See {IERC721-getApproved}.
845      */
846     function getApproved(uint256 tokenId) public view override returns (address) {
847         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
848 
849         return _tokenApprovals[tokenId];
850     }
851 
852     /**
853      * @dev See {IERC721-setApprovalForAll}.
854      */
855     function setApprovalForAll(address operator, bool approved) public virtual override {
856         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
857 
858         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
859         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
860     }
861 
862     /**
863      * @dev See {IERC721-isApprovedForAll}.
864      */
865     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
866         return _operatorApprovals[owner][operator];
867     }
868 
869     /**
870      * @dev See {IERC721-safeTransferFrom}.
871      */
872     function safeTransferFrom(
873         address from,
874         address to,
875         uint256 tokenId
876     ) public virtual override {
877         safeTransferFrom(from, to, tokenId, '');
878     }
879 
880     /**
881      * @dev See {IERC721-safeTransferFrom}.
882      */
883     function safeTransferFrom(
884         address from,
885         address to,
886         uint256 tokenId,
887         bytes memory _data
888     ) public virtual override {
889         transferFrom(from, to, tokenId);
890         if (to.code.length != 0)
891             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
892                 revert TransferToNonERC721ReceiverImplementer();
893             }
894     }
895 
896     /**
897      * @dev Returns whether `tokenId` exists.
898      *
899      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
900      *
901      * Tokens start existing when they are minted (`_mint`),
902      */
903     function _exists(uint256 tokenId) internal view returns (bool) {
904         return
905             _startTokenId() <= tokenId &&
906             tokenId < _currentIndex && // If within bounds,
907             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
908     }
909 
910     /**
911      * @dev Equivalent to `_safeMint(to, quantity, '')`.
912      */
913     function _safeMint(address to, uint256 quantity) internal {
914         _safeMint(to, quantity, '');
915     }
916 
917     /**
918      * @dev Safely mints `quantity` tokens and transfers them to `to`.
919      *
920      * Requirements:
921      *
922      * - If `to` refers to a smart contract, it must implement
923      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
924      * - `quantity` must be greater than 0.
925      *
926      * See {_mint}.
927      *
928      * Emits a {Transfer} event for each mint.
929      */
930     function _safeMint(
931         address to,
932         uint256 quantity,
933         bytes memory _data
934     ) internal {
935         _mint(to, quantity);
936 
937         unchecked {
938             if (to.code.length != 0) {
939                 uint256 end = _currentIndex;
940                 uint256 index = end - quantity;
941                 do {
942                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
943                         revert TransferToNonERC721ReceiverImplementer();
944                     }
945                 } while (index < end);
946                 // Reentrancy protection.
947                 if (_currentIndex != end) revert();
948             }
949         }
950     }
951 
952     /**
953      * @dev Mints `quantity` tokens and transfers them to `to`.
954      *
955      * Requirements:
956      *
957      * - `to` cannot be the zero address.
958      * - `quantity` must be greater than 0.
959      *
960      * Emits a {Transfer} event for each mint.
961      */
962     function _mint(address to, uint256 quantity) internal {
963         uint256 startTokenId = _currentIndex;
964         if (to == address(0)) revert MintToZeroAddress();
965         if (quantity == 0) revert MintZeroQuantity();
966 
967         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
968 
969         // Overflows are incredibly unrealistic.
970         // `balance` and `numberMinted` have a maximum limit of 2**64.
971         // `tokenId` has a maximum limit of 2**256.
972         unchecked {
973             // Updates:
974             // - `balance += quantity`.
975             // - `numberMinted += quantity`.
976             //
977             // We can directly add to the `balance` and `numberMinted`.
978             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
979 
980             // Updates:
981             // - `address` to the owner.
982             // - `startTimestamp` to the timestamp of minting.
983             // - `burned` to `false`.
984             // - `nextInitialized` to `quantity == 1`.
985             _packedOwnerships[startTokenId] = _packOwnershipData(
986                 to,
987                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
988             );
989 
990             uint256 tokenId = startTokenId;
991             uint256 end = startTokenId + quantity;
992             do {
993                 emit Transfer(address(0), to, tokenId++);
994             } while (tokenId < end);
995 
996             _currentIndex = end;
997         }
998         _afterTokenTransfers(address(0), to, startTokenId, quantity);
999     }
1000 
1001     /**
1002      * @dev Mints `quantity` tokens and transfers them to `to`.
1003      *
1004      * This function is intended for efficient minting only during contract creation.
1005      *
1006      * It emits only one {ConsecutiveTransfer} as defined in
1007      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1008      * instead of a sequence of {Transfer} event(s).
1009      *
1010      * Calling this function outside of contract creation WILL make your contract
1011      * non-compliant with the ERC721 standard.
1012      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1013      * {ConsecutiveTransfer} event is only permissible during contract creation.
1014      *
1015      * Requirements:
1016      *
1017      * - `to` cannot be the zero address.
1018      * - `quantity` must be greater than 0.
1019      *
1020      * Emits a {ConsecutiveTransfer} event.
1021      */
1022     function _mintERC2309(address to, uint256 quantity) internal {
1023         uint256 startTokenId = _currentIndex;
1024         if (to == address(0)) revert MintToZeroAddress();
1025         if (quantity == 0) revert MintZeroQuantity();
1026         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1027 
1028         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1029 
1030         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1031         unchecked {
1032             // Updates:
1033             // - `balance += quantity`.
1034             // - `numberMinted += quantity`.
1035             //
1036             // We can directly add to the `balance` and `numberMinted`.
1037             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1038 
1039             // Updates:
1040             // - `address` to the owner.
1041             // - `startTimestamp` to the timestamp of minting.
1042             // - `burned` to `false`.
1043             // - `nextInitialized` to `quantity == 1`.
1044             _packedOwnerships[startTokenId] = _packOwnershipData(
1045                 to,
1046                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1047             );
1048 
1049             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1050 
1051             _currentIndex = startTokenId + quantity;
1052         }
1053         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1054     }
1055 
1056     /**
1057      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1058      */
1059     function _getApprovedAddress(uint256 tokenId)
1060         private
1061         view
1062         returns (uint256 approvedAddressSlot, address approvedAddress)
1063     {
1064         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1065         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1066         assembly {
1067             // Compute the slot.
1068             mstore(0x00, tokenId)
1069             mstore(0x20, tokenApprovalsPtr.slot)
1070             approvedAddressSlot := keccak256(0x00, 0x40)
1071             // Load the slot's value from storage.
1072             approvedAddress := sload(approvedAddressSlot)
1073         }
1074     }
1075 
1076     /**
1077      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1078      */
1079     function _isOwnerOrApproved(
1080         address approvedAddress,
1081         address from,
1082         address msgSender
1083     ) private pure returns (bool result) {
1084         assembly {
1085             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1086             from := and(from, BITMASK_ADDRESS)
1087             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1088             msgSender := and(msgSender, BITMASK_ADDRESS)
1089             // `msgSender == from || msgSender == approvedAddress`.
1090             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1091         }
1092     }
1093 
1094     /**
1095      * @dev Transfers `tokenId` from `from` to `to`.
1096      *
1097      * Requirements:
1098      *
1099      * - `to` cannot be the zero address.
1100      * - `tokenId` token must be owned by `from`.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function transferFrom(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) public virtual override {
1109         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1110 
1111         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1112 
1113         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1114 
1115         // The nested ifs save around 20+ gas over a compound boolean condition.
1116         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1117             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1118 
1119         if (to == address(0)) revert TransferToZeroAddress();
1120 
1121         _beforeTokenTransfers(from, to, tokenId, 1);
1122 
1123         // Clear approvals from the previous owner.
1124         assembly {
1125             if approvedAddress {
1126                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1127                 sstore(approvedAddressSlot, 0)
1128             }
1129         }
1130 
1131         // Underflow of the sender's balance is impossible because we check for
1132         // ownership above and the recipient's balance can't realistically overflow.
1133         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1134         unchecked {
1135             // We can directly increment and decrement the balances.
1136             --_packedAddressData[from]; // Updates: `balance -= 1`.
1137             ++_packedAddressData[to]; // Updates: `balance += 1`.
1138 
1139             // Updates:
1140             // - `address` to the next owner.
1141             // - `startTimestamp` to the timestamp of transfering.
1142             // - `burned` to `false`.
1143             // - `nextInitialized` to `true`.
1144             _packedOwnerships[tokenId] = _packOwnershipData(
1145                 to,
1146                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1147             );
1148 
1149             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1150             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1151                 uint256 nextTokenId = tokenId + 1;
1152                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1153                 if (_packedOwnerships[nextTokenId] == 0) {
1154                     // If the next slot is within bounds.
1155                     if (nextTokenId != _currentIndex) {
1156                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1157                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1158                     }
1159                 }
1160             }
1161         }
1162 
1163         emit Transfer(from, to, tokenId);
1164         _afterTokenTransfers(from, to, tokenId, 1);
1165     }
1166 
1167     /**
1168      * @dev Equivalent to `_burn(tokenId, false)`.
1169      */
1170     function _burn(uint256 tokenId) internal virtual {
1171         _burn(tokenId, false);
1172     }
1173 
1174     /**
1175      * @dev Destroys `tokenId`.
1176      * The approval is cleared when the token is burned.
1177      *
1178      * Requirements:
1179      *
1180      * - `tokenId` must exist.
1181      *
1182      * Emits a {Transfer} event.
1183      */
1184     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1185         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1186 
1187         address from = address(uint160(prevOwnershipPacked));
1188 
1189         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1190 
1191         if (approvalCheck) {
1192             // The nested ifs save around 20+ gas over a compound boolean condition.
1193             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1194                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1195         }
1196 
1197         _beforeTokenTransfers(from, address(0), tokenId, 1);
1198 
1199         // Clear approvals from the previous owner.
1200         assembly {
1201             if approvedAddress {
1202                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1203                 sstore(approvedAddressSlot, 0)
1204             }
1205         }
1206 
1207         // Underflow of the sender's balance is impossible because we check for
1208         // ownership above and the recipient's balance can't realistically overflow.
1209         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1210         unchecked {
1211             // Updates:
1212             // - `balance -= 1`.
1213             // - `numberBurned += 1`.
1214             //
1215             // We can directly decrement the balance, and increment the number burned.
1216             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1217             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1218 
1219             // Updates:
1220             // - `address` to the last owner.
1221             // - `startTimestamp` to the timestamp of burning.
1222             // - `burned` to `true`.
1223             // - `nextInitialized` to `true`.
1224             _packedOwnerships[tokenId] = _packOwnershipData(
1225                 from,
1226                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1227             );
1228 
1229             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1230             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1231                 uint256 nextTokenId = tokenId + 1;
1232                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1233                 if (_packedOwnerships[nextTokenId] == 0) {
1234                     // If the next slot is within bounds.
1235                     if (nextTokenId != _currentIndex) {
1236                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1237                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1238                     }
1239                 }
1240             }
1241         }
1242 
1243         emit Transfer(from, address(0), tokenId);
1244         _afterTokenTransfers(from, address(0), tokenId, 1);
1245 
1246         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1247         unchecked {
1248             _burnCounter++;
1249         }
1250     }
1251 
1252     /**
1253      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1254      *
1255      * @param from address representing the previous owner of the given token ID
1256      * @param to target address that will receive the tokens
1257      * @param tokenId uint256 ID of the token to be transferred
1258      * @param _data bytes optional data to send along with the call
1259      * @return bool whether the call correctly returned the expected magic value
1260      */
1261     function _checkContractOnERC721Received(
1262         address from,
1263         address to,
1264         uint256 tokenId,
1265         bytes memory _data
1266     ) private returns (bool) {
1267         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1268             bytes4 retval
1269         ) {
1270             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1271         } catch (bytes memory reason) {
1272             if (reason.length == 0) {
1273                 revert TransferToNonERC721ReceiverImplementer();
1274             } else {
1275                 assembly {
1276                     revert(add(32, reason), mload(reason))
1277                 }
1278             }
1279         }
1280     }
1281 
1282     /**
1283      * @dev Directly sets the extra data for the ownership data `index`.
1284      */
1285     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1286         uint256 packed = _packedOwnerships[index];
1287         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1288         uint256 extraDataCasted;
1289         // Cast `extraData` with assembly to avoid redundant masking.
1290         assembly {
1291             extraDataCasted := extraData
1292         }
1293         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1294         _packedOwnerships[index] = packed;
1295     }
1296 
1297     /**
1298      * @dev Returns the next extra data for the packed ownership data.
1299      * The returned result is shifted into position.
1300      */
1301     function _nextExtraData(
1302         address from,
1303         address to,
1304         uint256 prevOwnershipPacked
1305     ) private view returns (uint256) {
1306         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1307         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1308     }
1309 
1310     /**
1311      * @dev Called during each token transfer to set the 24bit `extraData` field.
1312      * Intended to be overridden by the cosumer contract.
1313      *
1314      * `previousExtraData` - the value of `extraData` before transfer.
1315      *
1316      * Calling conditions:
1317      *
1318      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1319      * transferred to `to`.
1320      * - When `from` is zero, `tokenId` will be minted for `to`.
1321      * - When `to` is zero, `tokenId` will be burned by `from`.
1322      * - `from` and `to` are never both zero.
1323      */
1324     function _extraData(
1325         address from,
1326         address to,
1327         uint24 previousExtraData
1328     ) internal view virtual returns (uint24) {}
1329 
1330     /**
1331      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1332      * This includes minting.
1333      * And also called before burning one token.
1334      *
1335      * startTokenId - the first token id to be transferred
1336      * quantity - the amount to be transferred
1337      *
1338      * Calling conditions:
1339      *
1340      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1341      * transferred to `to`.
1342      * - When `from` is zero, `tokenId` will be minted for `to`.
1343      * - When `to` is zero, `tokenId` will be burned by `from`.
1344      * - `from` and `to` are never both zero.
1345      */
1346     function _beforeTokenTransfers(
1347         address from,
1348         address to,
1349         uint256 startTokenId,
1350         uint256 quantity
1351     ) internal virtual {}
1352 
1353     /**
1354      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1355      * This includes minting.
1356      * And also called after one token has been burned.
1357      *
1358      * startTokenId - the first token id to be transferred
1359      * quantity - the amount to be transferred
1360      *
1361      * Calling conditions:
1362      *
1363      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1364      * transferred to `to`.
1365      * - When `from` is zero, `tokenId` has been minted for `to`.
1366      * - When `to` is zero, `tokenId` has been burned by `from`.
1367      * - `from` and `to` are never both zero.
1368      */
1369     function _afterTokenTransfers(
1370         address from,
1371         address to,
1372         uint256 startTokenId,
1373         uint256 quantity
1374     ) internal virtual {}
1375 
1376     /**
1377      * @dev Returns the message sender (defaults to `msg.sender`).
1378      *
1379      * If you are writing GSN compatible contracts, you need to override this function.
1380      */
1381     function _msgSenderERC721A() internal view virtual returns (address) {
1382         return msg.sender;
1383     }
1384 
1385     /**
1386      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1387      */
1388     function _toString(uint256 value) internal pure returns (string memory ptr) {
1389         assembly {
1390             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1391             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1392             // We will need 1 32-byte word to store the length,
1393             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1394             ptr := add(mload(0x40), 128)
1395             // Update the free memory pointer to allocate.
1396             mstore(0x40, ptr)
1397 
1398             // Cache the end of the memory to calculate the length later.
1399             let end := ptr
1400 
1401             // We write the string from the rightmost digit to the leftmost digit.
1402             // The following is essentially a do-while loop that also handles the zero case.
1403             // Costs a bit more than early returning for the zero case,
1404             // but cheaper in terms of deployment and overall runtime costs.
1405             for {
1406                 // Initialize and perform the first pass without check.
1407                 let temp := value
1408                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1409                 ptr := sub(ptr, 1)
1410                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1411                 mstore8(ptr, add(48, mod(temp, 10)))
1412                 temp := div(temp, 10)
1413             } temp {
1414                 // Keep dividing `temp` until zero.
1415                 temp := div(temp, 10)
1416             } {
1417                 // Body of the for loop.
1418                 ptr := sub(ptr, 1)
1419                 mstore8(ptr, add(48, mod(temp, 10)))
1420             }
1421 
1422             let length := sub(end, ptr)
1423             // Move the pointer 32 bytes leftwards to make room for the length.
1424             ptr := sub(ptr, 32)
1425             // Store the length.
1426             mstore(ptr, length)
1427         }
1428     }
1429 }
1430 
1431 // File: contracts/NorthernLights.sol
1432 
1433 
1434 //    _   _  ___  ____ _____ _   _ _____ ____  _   _   _     ___ ____ _   _ _____ ____  
1435 //   | \ | |/ _ \|  _ \_   _| | | | ____|  _ \| \ | | | |   |_ _/ ___| | | |_   _/ ___| 
1436 //   |  \| | | | | |_) || | | |_| |  _| | |_) |  \| | | |    | | |  _| |_| | | | \___ \ 
1437 //   | |\  | |_| |  _ < | | |  _  | |___|  _ <| |\  | | |___ | | |_| |  _  | | |  ___) |
1438 //   |_| \_|\___/|_| \_\|_| |_| |_|_____|_| \_\_| \_| |_____|___\____|_| |_| |_| |____/ 
1439 //                                                                                      
1440 
1441 
1442 //SPDX-License-Identifier: MIT
1443 pragma solidity ^0.8.4;
1444 
1445 
1446 
1447 
1448 
1449 
1450 contract Northern_Lights is Ownable, ERC721A {
1451     uint256 constant public MAX_SUPPLY = 1000;
1452     
1453 
1454     uint256 public publicPrice = 0.005 ether;
1455 
1456     uint256 constant public PUBLIC_MINT_LIMIT_TXN = 2;
1457     uint256 constant public PUBLIC_MINT_LIMIT = 4;
1458 
1459     string private revealedURI = "ipfs://QmdD629PiUPUUco4YYvik276JkTUvKDpTxub4mGZPSRfvX/";
1460 
1461     
1462 
1463     bool public paused = false;
1464     bool public revealed = true;
1465 
1466     bool public freeSale = false;
1467     bool public publicSale = false;
1468 
1469     
1470     address constant internal DEV_ADDRESS = 0x9ABB35294EbbDDE863a7119E639900Def8F18B36;
1471     
1472     
1473 
1474     mapping(address => bool) public userMintedFree;
1475     mapping(address => uint256) public numUserMints;
1476 
1477     constructor(string memory _name, string memory _symbol, string memory _baseUri) ERC721A("Northern Lights", "NL") { }
1478 
1479     
1480     function _startTokenId() internal view virtual override returns (uint256) {
1481         return 1;
1482     }
1483 
1484     function refundOverpay(uint256 price) private {
1485         if (msg.value > price) {
1486             (bool succ, ) = payable(msg.sender).call{
1487                 value: (msg.value - price)
1488             }("");
1489             require(succ, "Transfer failed");
1490         }
1491         else if (msg.value < price) {
1492             revert("Not enough ETH sent");
1493         }
1494     }
1495 
1496     
1497     
1498     function freeMint(uint256 quantity) external payable mintCompliance(quantity) {
1499         require(freeSale, "Free sale inactive");
1500         require(msg.value == 0, "This phase is free");
1501         require(quantity == 1, "Only #1 free");
1502 
1503         uint256 newSupply = totalSupply() + quantity;
1504         
1505         require(newSupply <= 600, "Not enough free supply");
1506 
1507         require(!userMintedFree[msg.sender], "User max free limit");
1508         
1509         userMintedFree[msg.sender] = true;
1510 
1511         if(newSupply == 600) {
1512             freeSale = false;
1513             publicSale = true;
1514         }
1515 
1516         _safeMint(msg.sender, quantity);
1517     }
1518 
1519     function publicMint(uint256 quantity) external payable mintCompliance(quantity) {
1520         require(publicSale, "Public sale inactive");
1521         require(quantity <= PUBLIC_MINT_LIMIT_TXN, "Quantity too high");
1522 
1523         uint256 price = publicPrice;
1524         uint256 currMints = numUserMints[msg.sender];
1525                 
1526         require(currMints + quantity <= PUBLIC_MINT_LIMIT, "User max mint limit");
1527         
1528         refundOverpay(price * quantity);
1529 
1530         numUserMints[msg.sender] = (currMints + quantity);
1531 
1532         _safeMint(msg.sender, quantity);
1533     }
1534 
1535     
1536     function walletOfOwner(address _owner) public view returns (uint256[] memory)
1537     {
1538         uint256 ownerTokenCount = balanceOf(_owner);
1539         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1540         uint256 currentTokenId = 1;
1541         uint256 ownedTokenIndex = 0;
1542 
1543         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= MAX_SUPPLY) {
1544             address currentTokenOwner = ownerOf(currentTokenId);
1545 
1546             if (currentTokenOwner == _owner) {
1547                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1548 
1549                 ownedTokenIndex++;
1550             }
1551 
1552         currentTokenId++;
1553         }
1554 
1555         return ownedTokenIds;
1556     }
1557 
1558     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1559         
1560         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1561         
1562         if (revealed) {
1563             return string(abi.encodePacked(revealedURI, Strings.toString(_tokenId), ".json"));
1564         }
1565         else {
1566             return revealedURI;
1567         }
1568     }
1569 
1570     function setPublicPrice(uint256 _publicPrice) public onlyOwner {
1571         publicPrice = _publicPrice;
1572     }
1573 
1574     function setBaseURI(string memory _baseUri) public onlyOwner {
1575         revealedURI = _baseUri;
1576     }
1577 
1578 
1579     function setPaused(bool _state) public onlyOwner {
1580         paused = _state;
1581     }
1582 
1583     function setRevealed(bool _state) public onlyOwner {
1584         revealed = _state;
1585     }
1586 
1587     function setPublicEnabled(bool _state) public onlyOwner {
1588         publicSale = _state;
1589         freeSale = !_state;
1590     }
1591     function setFreeEnabled(bool _state) public onlyOwner {
1592         freeSale = _state;
1593         publicSale = !_state;
1594     }
1595 
1596 
1597     function withdraw() external payable onlyOwner {
1598         
1599         uint256 currBalance = address(this).balance;
1600 
1601         (bool succ, ) = payable(DEV_ADDRESS).call{
1602             value: (currBalance * 10000) / 10000
1603         }("0x9ABB35294EbbDDE863a7119E639900Def8F18B36");
1604         require(succ, "Dev transfer failed");
1605 
1606     }
1607 
1608     
1609     function mintToUser(uint256 quantity, address receiver) public onlyOwner mintCompliance(quantity) {
1610         _safeMint(receiver, quantity);
1611     }
1612 
1613    
1614 
1615     modifier mintCompliance(uint256 quantity) {
1616         require(!paused, "Contract is paused");
1617         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough mints left");
1618         require(tx.origin == msg.sender, "No contract minting");
1619         _;
1620     }
1621 }