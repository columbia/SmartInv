1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Context.sol
80 
81 
82 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev Provides information about the current execution context, including the
88  * sender of the transaction and its data. While these are generally available
89  * via msg.sender and msg.data, they should not be accessed in such a direct
90  * manner, since when dealing with meta-transactions the account sending and
91  * paying for execution may not be the actual sender (as far as an application
92  * is concerned).
93  *
94  * This contract is only required for intermediate, library-like contracts.
95  */
96 abstract contract Context {
97     function _msgSender() internal view virtual returns (address) {
98         return msg.sender;
99     }
100 
101     function _msgData() internal view virtual returns (bytes calldata) {
102         return msg.data;
103     }
104 }
105 
106 // File: @openzeppelin/contracts/access/Ownable.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 
114 /**
115  * @dev Contract module which provides a basic access control mechanism, where
116  * there is an account (an owner) that can be granted exclusive access to
117  * specific functions.
118  *
119  * By default, the owner account will be the one that deploys the contract. This
120  * can later be changed with {transferOwnership}.
121  *
122  * This module is used through inheritance. It will make available the modifier
123  * `onlyOwner`, which can be applied to your functions to restrict their use to
124  * the owner.
125  */
126 abstract contract Ownable is Context {
127     address private _owner;
128 
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131     /**
132      * @dev Initializes the contract setting the deployer as the initial owner.
133      */
134     constructor() {
135         _transferOwnership(_msgSender());
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         _checkOwner();
143         _;
144     }
145 
146     /**
147      * @dev Returns the address of the current owner.
148      */
149     function owner() public view virtual returns (address) {
150         return _owner;
151     }
152 
153     /**
154      * @dev Throws if the sender is not the owner.
155      */
156     function _checkOwner() internal view virtual {
157         require(owner() == _msgSender(), "Ownable: caller is not the owner");
158     }
159 
160     /**
161      * @dev Leaves the contract without owner. It will not be possible to call
162      * `onlyOwner` functions anymore. Can only be called by the current owner.
163      *
164      * NOTE: Renouncing ownership will leave the contract without an owner,
165      * thereby removing any functionality that is only available to the owner.
166      */
167     function renounceOwnership() public virtual onlyOwner {
168         _transferOwnership(address(0));
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(newOwner != address(0), "Ownable: new owner is the zero address");
177         _transferOwnership(newOwner);
178     }
179 
180     /**
181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
182      * Internal function without access restriction.
183      */
184     function _transferOwnership(address newOwner) internal virtual {
185         address oldOwner = _owner;
186         _owner = newOwner;
187         emit OwnershipTransferred(oldOwner, newOwner);
188     }
189 }
190 
191 // File: contracts/IERC721A.sol
192 
193 
194 // ERC721A Contracts v4.2.2
195 // Creator: Chiru Labs
196 
197 pragma solidity ^0.8.4;
198 
199 /**
200  * @dev Interface of ERC721A.
201  */
202 interface IERC721A {
203     /**
204      * The caller must own the token or be an approved operator.
205      */
206     error ApprovalCallerNotOwnerNorApproved();
207 
208     /**
209      * The token does not exist.
210      */
211     error ApprovalQueryForNonexistentToken();
212 
213     /**
214      * The caller cannot approve to their own address.
215      */
216     error ApproveToCaller();
217 
218     /**
219      * Cannot query the balance for the zero address.
220      */
221     error BalanceQueryForZeroAddress();
222 
223     /**
224      * Cannot mint to the zero address.
225      */
226     error MintToZeroAddress();
227 
228     /**
229      * The quantity of tokens minted must be more than zero.
230      */
231     error MintZeroQuantity();
232 
233     /**
234      * The token does not exist.
235      */
236     error OwnerQueryForNonexistentToken();
237 
238     /**
239      * The caller must own the token or be an approved operator.
240      */
241     error TransferCallerNotOwnerNorApproved();
242 
243     /**
244      * The token must be owned by `from`.
245      */
246     error TransferFromIncorrectOwner();
247 
248     /**
249      * Cannot safely transfer to a contract that does not implement the
250      * ERC721Receiver interface.
251      */
252     error TransferToNonERC721ReceiverImplementer();
253 
254     /**
255      * Cannot transfer to the zero address.
256      */
257     error TransferToZeroAddress();
258 
259     /**
260      * The token does not exist.
261      */
262     error URIQueryForNonexistentToken();
263 
264     /**
265      * The `quantity` minted with ERC2309 exceeds the safety limit.
266      */
267     error MintERC2309QuantityExceedsLimit();
268 
269     /**
270      * The `extraData` cannot be set on an unintialized ownership slot.
271      */
272     error OwnershipNotInitializedForExtraData();
273 
274     // =============================================================
275     //                            STRUCTS
276     // =============================================================
277 
278     struct TokenOwnership {
279         // The address of the owner.
280         address addr;
281         // Stores the start time of ownership with minimal overhead for tokenomics.
282         uint64 startTimestamp;
283         // Whether the token has been burned.
284         bool burned;
285         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
286         uint24 extraData;
287     }
288 
289     // =============================================================
290     //                         TOKEN COUNTERS
291     // =============================================================
292 
293     /**
294      * @dev Returns the total number of tokens in existence.
295      * Burned tokens will reduce the count.
296      * To get the total number of tokens minted, please see {_totalMinted}.
297      */
298     function totalSupply() external view returns (uint256);
299 
300     // =============================================================
301     //                            IERC165
302     // =============================================================
303 
304     /**
305      * @dev Returns true if this contract implements the interface defined by
306      * `interfaceId`. See the corresponding
307      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
308      * to learn more about how these ids are created.
309      *
310      * This function call must use less than 30000 gas.
311      */
312     function supportsInterface(bytes4 interfaceId) external view returns (bool);
313 
314     // =============================================================
315     //                            IERC721
316     // =============================================================
317 
318     /**
319      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
320      */
321     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
322 
323     /**
324      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
325      */
326     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
327 
328     /**
329      * @dev Emitted when `owner` enables or disables
330      * (`approved`) `operator` to manage all of its assets.
331      */
332     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
333 
334     /**
335      * @dev Returns the number of tokens in `owner`'s account.
336      */
337     function balanceOf(address owner) external view returns (uint256 balance);
338 
339     /**
340      * @dev Returns the owner of the `tokenId` token.
341      *
342      * Requirements:
343      *
344      * - `tokenId` must exist.
345      */
346     function ownerOf(uint256 tokenId) external view returns (address owner);
347 
348     /**
349      * @dev Safely transfers `tokenId` token from `from` to `to`,
350      * checking first that contract recipients are aware of the ERC721 protocol
351      * to prevent tokens from being forever locked.
352      *
353      * Requirements:
354      *
355      * - `from` cannot be the zero address.
356      * - `to` cannot be the zero address.
357      * - `tokenId` token must exist and be owned by `from`.
358      * - If the caller is not `from`, it must be have been allowed to move
359      * this token by either {approve} or {setApprovalForAll}.
360      * - If `to` refers to a smart contract, it must implement
361      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
362      *
363      * Emits a {Transfer} event.
364      */
365     function safeTransferFrom(
366         address from,
367         address to,
368         uint256 tokenId,
369         bytes calldata data
370     ) external;
371 
372     /**
373      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
374      */
375     function safeTransferFrom(
376         address from,
377         address to,
378         uint256 tokenId
379     ) external;
380 
381     /**
382      * @dev Transfers `tokenId` from `from` to `to`.
383      *
384      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
385      * whenever possible.
386      *
387      * Requirements:
388      *
389      * - `from` cannot be the zero address.
390      * - `to` cannot be the zero address.
391      * - `tokenId` token must be owned by `from`.
392      * - If the caller is not `from`, it must be approved to move this token
393      * by either {approve} or {setApprovalForAll}.
394      *
395      * Emits a {Transfer} event.
396      */
397     function transferFrom(
398         address from,
399         address to,
400         uint256 tokenId
401     ) external;
402 
403     /**
404      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
405      * The approval is cleared when the token is transferred.
406      *
407      * Only a single account can be approved at a time, so approving the
408      * zero address clears previous approvals.
409      *
410      * Requirements:
411      *
412      * - The caller must own the token or be an approved operator.
413      * - `tokenId` must exist.
414      *
415      * Emits an {Approval} event.
416      */
417     function approve(address to, uint256 tokenId) external;
418 
419     /**
420      * @dev Approve or remove `operator` as an operator for the caller.
421      * Operators can call {transferFrom} or {safeTransferFrom}
422      * for any token owned by the caller.
423      *
424      * Requirements:
425      *
426      * - The `operator` cannot be the caller.
427      *
428      * Emits an {ApprovalForAll} event.
429      */
430     function setApprovalForAll(address operator, bool _approved) external;
431 
432     /**
433      * @dev Returns the account approved for `tokenId` token.
434      *
435      * Requirements:
436      *
437      * - `tokenId` must exist.
438      */
439     function getApproved(uint256 tokenId) external view returns (address operator);
440 
441     /**
442      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
443      *
444      * See {setApprovalForAll}.
445      */
446     function isApprovedForAll(address owner, address operator) external view returns (bool);
447 
448     // =============================================================
449     //                        IERC721Metadata
450     // =============================================================
451 
452     /**
453      * @dev Returns the token collection name.
454      */
455     function name() external view returns (string memory);
456 
457     /**
458      * @dev Returns the token collection symbol.
459      */
460     function symbol() external view returns (string memory);
461 
462     /**
463      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
464      */
465     function tokenURI(uint256 tokenId) external view returns (string memory);
466 
467     // =============================================================
468     //                           IERC2309
469     // =============================================================
470 
471     /**
472      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
473      * (inclusive) is transferred from `from` to `to`, as defined in the
474      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
475      *
476      * See {_mintERC2309} for more details.
477      */
478     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
479 }
480 // File: contracts/ERC721A.sol
481 
482 
483 // ERC721A Contracts v4.2.2
484 // Creator: Chiru Labs
485 
486 pragma solidity ^0.8.4;
487 
488 
489 /**
490  * @dev Interface of ERC721 token receiver.
491  */
492 interface ERC721A__IERC721Receiver {
493     function onERC721Received(
494         address operator,
495         address from,
496         uint256 tokenId,
497         bytes calldata data
498     ) external returns (bytes4);
499 }
500 
501 /**
502  * @title ERC721A
503  *
504  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
505  * Non-Fungible Token Standard, including the Metadata extension.
506  * Optimized for lower gas during batch mints.
507  *
508  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
509  * starting from `_startTokenId()`.
510  *
511  * Assumptions:
512  *
513  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
514  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
515  */
516 contract ERC721A is IERC721A {
517     // Reference type for token approval.
518     struct TokenApprovalRef {
519         address value;
520     }
521 
522     // =============================================================
523     //                           CONSTANTS
524     // =============================================================
525 
526     // Mask of an entry in packed address data.
527     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
528 
529     // The bit position of `numberMinted` in packed address data.
530     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
531 
532     // The bit position of `numberBurned` in packed address data.
533     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
534 
535     // The bit position of `aux` in packed address data.
536     uint256 private constant _BITPOS_AUX = 192;
537 
538     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
539     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
540 
541     // The bit position of `startTimestamp` in packed ownership.
542     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
543 
544     // The bit mask of the `burned` bit in packed ownership.
545     uint256 private constant _BITMASK_BURNED = 1 << 224;
546 
547     // The bit position of the `nextInitialized` bit in packed ownership.
548     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
549 
550     // The bit mask of the `nextInitialized` bit in packed ownership.
551     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
552 
553     // The bit position of `extraData` in packed ownership.
554     uint256 private constant _BITPOS_EXTRA_DATA = 232;
555 
556     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
557     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
558 
559     // The mask of the lower 160 bits for addresses.
560     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
561 
562     // The maximum `quantity` that can be minted with {_mintERC2309}.
563     // This limit is to prevent overflows on the address data entries.
564     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
565     // is required to cause an overflow, which is unrealistic.
566     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
567 
568     // The `Transfer` event signature is given by:
569     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
570     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
571         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
572 
573     // =============================================================
574     //                            STORAGE
575     // =============================================================
576 
577     // The next token ID to be minted.
578     uint256 private _currentIndex;
579 
580     // The number of tokens burned.
581     uint256 private _burnCounter;
582 
583     // Token name
584     string private _name;
585 
586     // Token symbol
587     string private _symbol;
588 
589     // Mapping from token ID to ownership details
590     // An empty struct value does not necessarily mean the token is unowned.
591     // See {_packedOwnershipOf} implementation for details.
592     //
593     // Bits Layout:
594     // - [0..159]   `addr`
595     // - [160..223] `startTimestamp`
596     // - [224]      `burned`
597     // - [225]      `nextInitialized`
598     // - [232..255] `extraData`
599     mapping(uint256 => uint256) private _packedOwnerships;
600 
601     // Mapping owner address to address data.
602     //
603     // Bits Layout:
604     // - [0..63]    `balance`
605     // - [64..127]  `numberMinted`
606     // - [128..191] `numberBurned`
607     // - [192..255] `aux`
608     mapping(address => uint256) private _packedAddressData;
609 
610     // Mapping from token ID to approved address.
611     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
612 
613     // Mapping from owner to operator approvals
614     mapping(address => mapping(address => bool)) private _operatorApprovals;
615 
616     // =============================================================
617     //                          CONSTRUCTOR
618     // =============================================================
619 
620     constructor(string memory name_, string memory symbol_) {
621         _name = name_;
622         _symbol = symbol_;
623         _currentIndex = _startTokenId();
624     }
625 
626     // =============================================================
627     //                   TOKEN COUNTING OPERATIONS
628     // =============================================================
629 
630     /**
631      * @dev Returns the starting token ID.
632      * To change the starting token ID, please override this function.
633      */
634     function _startTokenId() internal view virtual returns (uint256) {
635         return 0;
636     }
637 
638     /**
639      * @dev Returns the next token ID to be minted.
640      */
641     function _nextTokenId() internal view virtual returns (uint256) {
642         return _currentIndex;
643     }
644 
645     /**
646      * @dev Returns the total number of tokens in existence.
647      * Burned tokens will reduce the count.
648      * To get the total number of tokens minted, please see {_totalMinted}.
649      */
650     function totalSupply() public view virtual override returns (uint256) {
651         // Counter underflow is impossible as _burnCounter cannot be incremented
652         // more than `_currentIndex - _startTokenId()` times.
653         unchecked {
654             return _currentIndex - _burnCounter - _startTokenId();
655         }
656     }
657 
658     /**
659      * @dev Returns the total amount of tokens minted in the contract.
660      */
661     function _totalMinted() internal view virtual returns (uint256) {
662         // Counter underflow is impossible as `_currentIndex` does not decrement,
663         // and it is initialized to `_startTokenId()`.
664         unchecked {
665             return _currentIndex - _startTokenId();
666         }
667     }
668 
669     /**
670      * @dev Returns the total number of tokens burned.
671      */
672     function _totalBurned() internal view virtual returns (uint256) {
673         return _burnCounter;
674     }
675 
676     // =============================================================
677     //                    ADDRESS DATA OPERATIONS
678     // =============================================================
679 
680     /**
681      * @dev Returns the number of tokens in `owner`'s account.
682      */
683     function balanceOf(address owner) public view virtual override returns (uint256) {
684         if (owner == address(0)) revert BalanceQueryForZeroAddress();
685         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
686     }
687 
688     /**
689      * Returns the number of tokens minted by `owner`.
690      */
691     function _numberMinted(address owner) internal view returns (uint256) {
692         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
693     }
694 
695     /**
696      * Returns the number of tokens burned by or on behalf of `owner`.
697      */
698     function _numberBurned(address owner) internal view returns (uint256) {
699         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
700     }
701 
702     /**
703      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
704      */
705     function _getAux(address owner) internal view returns (uint64) {
706         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
707     }
708 
709     /**
710      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
711      * If there are multiple variables, please pack them into a uint64.
712      */
713     function _setAux(address owner, uint64 aux) internal virtual {
714         uint256 packed = _packedAddressData[owner];
715         uint256 auxCasted;
716         // Cast `aux` with assembly to avoid redundant masking.
717         assembly {
718             auxCasted := aux
719         }
720         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
721         _packedAddressData[owner] = packed;
722     }
723 
724     // =============================================================
725     //                            IERC165
726     // =============================================================
727 
728     /**
729      * @dev Returns true if this contract implements the interface defined by
730      * `interfaceId`. See the corresponding
731      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
732      * to learn more about how these ids are created.
733      *
734      * This function call must use less than 30000 gas.
735      */
736     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
737         // The interface IDs are constants representing the first 4 bytes
738         // of the XOR of all function selectors in the interface.
739         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
740         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
741         return
742             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
743             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
744             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
745     }
746 
747     // =============================================================
748     //                        IERC721Metadata
749     // =============================================================
750 
751     /**
752      * @dev Returns the token collection name.
753      */
754     function name() public view virtual override returns (string memory) {
755         return _name;
756     }
757 
758     /**
759      * @dev Returns the token collection symbol.
760      */
761     function symbol() public view virtual override returns (string memory) {
762         return _symbol;
763     }
764 
765     /**
766      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
767      */
768     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
769         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
770 
771         string memory baseURI = _baseURI();
772         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
773     }
774 
775     /**
776      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
777      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
778      * by default, it can be overridden in child contracts.
779      */
780     function _baseURI() internal view virtual returns (string memory) {
781         return '';
782     }
783 
784     // =============================================================
785     //                     OWNERSHIPS OPERATIONS
786     // =============================================================
787 
788     /**
789      * @dev Returns the owner of the `tokenId` token.
790      *
791      * Requirements:
792      *
793      * - `tokenId` must exist.
794      */
795     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
796         return address(uint160(_packedOwnershipOf(tokenId)));
797     }
798 
799     /**
800      * @dev Gas spent here starts off proportional to the maximum mint batch size.
801      * It gradually moves to O(1) as tokens get transferred around over time.
802      */
803     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
804         return _unpackedOwnership(_packedOwnershipOf(tokenId));
805     }
806 
807     /**
808      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
809      */
810     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
811         return _unpackedOwnership(_packedOwnerships[index]);
812     }
813 
814     /**
815      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
816      */
817     function _initializeOwnershipAt(uint256 index) internal virtual {
818         if (_packedOwnerships[index] == 0) {
819             _packedOwnerships[index] = _packedOwnershipOf(index);
820         }
821     }
822 
823     /**
824      * Returns the packed ownership data of `tokenId`.
825      */
826     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
827         uint256 curr = tokenId;
828 
829         unchecked {
830             if (_startTokenId() <= curr)
831                 if (curr < _currentIndex) {
832                     uint256 packed = _packedOwnerships[curr];
833                     // If not burned.
834                     if (packed & _BITMASK_BURNED == 0) {
835                         // Invariant:
836                         // There will always be an initialized ownership slot
837                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
838                         // before an unintialized ownership slot
839                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
840                         // Hence, `curr` will not underflow.
841                         //
842                         // We can directly compare the packed value.
843                         // If the address is zero, packed will be zero.
844                         while (packed == 0) {
845                             packed = _packedOwnerships[--curr];
846                         }
847                         return packed;
848                     }
849                 }
850         }
851         revert OwnerQueryForNonexistentToken();
852     }
853 
854     /**
855      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
856      */
857     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
858         ownership.addr = address(uint160(packed));
859         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
860         ownership.burned = packed & _BITMASK_BURNED != 0;
861         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
862     }
863 
864     /**
865      * @dev Packs ownership data into a single uint256.
866      */
867     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
868         assembly {
869             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
870             owner := and(owner, _BITMASK_ADDRESS)
871             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
872             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
873         }
874     }
875 
876     /**
877      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
878      */
879     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
880         // For branchless setting of the `nextInitialized` flag.
881         assembly {
882             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
883             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
884         }
885     }
886 
887     // =============================================================
888     //                      APPROVAL OPERATIONS
889     // =============================================================
890 
891     /**
892      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
893      * The approval is cleared when the token is transferred.
894      *
895      * Only a single account can be approved at a time, so approving the
896      * zero address clears previous approvals.
897      *
898      * Requirements:
899      *
900      * - The caller must own the token or be an approved operator.
901      * - `tokenId` must exist.
902      *
903      * Emits an {Approval} event.
904      */
905     function approve(address to, uint256 tokenId) public virtual override {
906         address owner = ownerOf(tokenId);
907 
908         if (_msgSenderERC721A() != owner)
909             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
910                 revert ApprovalCallerNotOwnerNorApproved();
911             }
912 
913         _tokenApprovals[tokenId].value = to;
914         emit Approval(owner, to, tokenId);
915     }
916 
917     /**
918      * @dev Returns the account approved for `tokenId` token.
919      *
920      * Requirements:
921      *
922      * - `tokenId` must exist.
923      */
924     function getApproved(uint256 tokenId) public view virtual override returns (address) {
925         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
926 
927         return _tokenApprovals[tokenId].value;
928     }
929 
930     /**
931      * @dev Approve or remove `operator` as an operator for the caller.
932      * Operators can call {transferFrom} or {safeTransferFrom}
933      * for any token owned by the caller.
934      *
935      * Requirements:
936      *
937      * - The `operator` cannot be the caller.
938      *
939      * Emits an {ApprovalForAll} event.
940      */
941     function setApprovalForAll(address operator, bool approved) public virtual override {
942         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
943 
944         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
945         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
946     }
947 
948     /**
949      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
950      *
951      * See {setApprovalForAll}.
952      */
953     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
954         return _operatorApprovals[owner][operator];
955     }
956 
957     /**
958      * @dev Returns whether `tokenId` exists.
959      *
960      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
961      *
962      * Tokens start existing when they are minted. See {_mint}.
963      */
964     function _exists(uint256 tokenId) internal view virtual returns (bool) {
965         return
966             _startTokenId() <= tokenId &&
967             tokenId < _currentIndex && // If within bounds,
968             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
969     }
970 
971     /**
972      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
973      */
974     function _isSenderApprovedOrOwner(
975         address approvedAddress,
976         address owner,
977         address msgSender
978     ) private pure returns (bool result) {
979         assembly {
980             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
981             owner := and(owner, _BITMASK_ADDRESS)
982             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
983             msgSender := and(msgSender, _BITMASK_ADDRESS)
984             // `msgSender == owner || msgSender == approvedAddress`.
985             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
986         }
987     }
988 
989     /**
990      * @dev Returns the storage slot and value for the approved address of `tokenId`.
991      */
992     function _getApprovedSlotAndAddress(uint256 tokenId)
993         private
994         view
995         returns (uint256 approvedAddressSlot, address approvedAddress)
996     {
997         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
998         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
999         assembly {
1000             approvedAddressSlot := tokenApproval.slot
1001             approvedAddress := sload(approvedAddressSlot)
1002         }
1003     }
1004 
1005     // =============================================================
1006     //                      TRANSFER OPERATIONS
1007     // =============================================================
1008 
1009     /**
1010      * @dev Transfers `tokenId` from `from` to `to`.
1011      *
1012      * Requirements:
1013      *
1014      * - `from` cannot be the zero address.
1015      * - `to` cannot be the zero address.
1016      * - `tokenId` token must be owned by `from`.
1017      * - If the caller is not `from`, it must be approved to move this token
1018      * by either {approve} or {setApprovalForAll}.
1019      *
1020      * Emits a {Transfer} event.
1021      */
1022     function transferFrom(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) public virtual override {
1027         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1028 
1029         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1030 
1031         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1032 
1033         // The nested ifs save around 20+ gas over a compound boolean condition.
1034         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1035             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1036 
1037         if (to == address(0)) revert TransferToZeroAddress();
1038 
1039         _beforeTokenTransfers(from, to, tokenId, 1);
1040 
1041         // Clear approvals from the previous owner.
1042         assembly {
1043             if approvedAddress {
1044                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1045                 sstore(approvedAddressSlot, 0)
1046             }
1047         }
1048 
1049         // Underflow of the sender's balance is impossible because we check for
1050         // ownership above and the recipient's balance can't realistically overflow.
1051         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1052         unchecked {
1053             // We can directly increment and decrement the balances.
1054             --_packedAddressData[from]; // Updates: `balance -= 1`.
1055             ++_packedAddressData[to]; // Updates: `balance += 1`.
1056 
1057             // Updates:
1058             // - `address` to the next owner.
1059             // - `startTimestamp` to the timestamp of transfering.
1060             // - `burned` to `false`.
1061             // - `nextInitialized` to `true`.
1062             _packedOwnerships[tokenId] = _packOwnershipData(
1063                 to,
1064                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
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
1081         emit Transfer(from, to, tokenId);
1082         _afterTokenTransfers(from, to, tokenId, 1);
1083     }
1084 
1085     /**
1086      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1087      */
1088     function safeTransferFrom(
1089         address from,
1090         address to,
1091         uint256 tokenId
1092     ) public virtual override {
1093         safeTransferFrom(from, to, tokenId, '');
1094     }
1095 
1096     /**
1097      * @dev Safely transfers `tokenId` token from `from` to `to`.
1098      *
1099      * Requirements:
1100      *
1101      * - `from` cannot be the zero address.
1102      * - `to` cannot be the zero address.
1103      * - `tokenId` token must exist and be owned by `from`.
1104      * - If the caller is not `from`, it must be approved to move this token
1105      * by either {approve} or {setApprovalForAll}.
1106      * - If `to` refers to a smart contract, it must implement
1107      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function safeTransferFrom(
1112         address from,
1113         address to,
1114         uint256 tokenId,
1115         bytes memory _data
1116     ) public virtual override {
1117         transferFrom(from, to, tokenId);
1118         if (to.code.length != 0)
1119             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1120                 revert TransferToNonERC721ReceiverImplementer();
1121             }
1122     }
1123 
1124     /**
1125      * @dev Hook that is called before a set of serially-ordered token IDs
1126      * are about to be transferred. This includes minting.
1127      * And also called before burning one token.
1128      *
1129      * `startTokenId` - the first token ID to be transferred.
1130      * `quantity` - the amount to be transferred.
1131      *
1132      * Calling conditions:
1133      *
1134      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1135      * transferred to `to`.
1136      * - When `from` is zero, `tokenId` will be minted for `to`.
1137      * - When `to` is zero, `tokenId` will be burned by `from`.
1138      * - `from` and `to` are never both zero.
1139      */
1140     function _beforeTokenTransfers(
1141         address from,
1142         address to,
1143         uint256 startTokenId,
1144         uint256 quantity
1145     ) internal virtual {}
1146 
1147     /**
1148      * @dev Hook that is called after a set of serially-ordered token IDs
1149      * have been transferred. This includes minting.
1150      * And also called after one token has been burned.
1151      *
1152      * `startTokenId` - the first token ID to be transferred.
1153      * `quantity` - the amount to be transferred.
1154      *
1155      * Calling conditions:
1156      *
1157      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1158      * transferred to `to`.
1159      * - When `from` is zero, `tokenId` has been minted for `to`.
1160      * - When `to` is zero, `tokenId` has been burned by `from`.
1161      * - `from` and `to` are never both zero.
1162      */
1163     function _afterTokenTransfers(
1164         address from,
1165         address to,
1166         uint256 startTokenId,
1167         uint256 quantity
1168     ) internal virtual {}
1169 
1170     /**
1171      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1172      *
1173      * `from` - Previous owner of the given token ID.
1174      * `to` - Target address that will receive the token.
1175      * `tokenId` - Token ID to be transferred.
1176      * `_data` - Optional data to send along with the call.
1177      *
1178      * Returns whether the call correctly returned the expected magic value.
1179      */
1180     function _checkContractOnERC721Received(
1181         address from,
1182         address to,
1183         uint256 tokenId,
1184         bytes memory _data
1185     ) private returns (bool) {
1186         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1187             bytes4 retval
1188         ) {
1189             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1190         } catch (bytes memory reason) {
1191             if (reason.length == 0) {
1192                 revert TransferToNonERC721ReceiverImplementer();
1193             } else {
1194                 assembly {
1195                     revert(add(32, reason), mload(reason))
1196                 }
1197             }
1198         }
1199     }
1200 
1201     // =============================================================
1202     //                        MINT OPERATIONS
1203     // =============================================================
1204 
1205     /**
1206      * @dev Mints `quantity` tokens and transfers them to `to`.
1207      *
1208      * Requirements:
1209      *
1210      * - `to` cannot be the zero address.
1211      * - `quantity` must be greater than 0.
1212      *
1213      * Emits a {Transfer} event for each mint.
1214      */
1215     function _mint(address to, uint256 quantity) internal virtual {
1216         uint256 startTokenId = _currentIndex;
1217         if (quantity == 0) revert MintZeroQuantity();
1218 
1219         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1220 
1221         // Overflows are incredibly unrealistic.
1222         // `balance` and `numberMinted` have a maximum limit of 2**64.
1223         // `tokenId` has a maximum limit of 2**256.
1224         unchecked {
1225             // Updates:
1226             // - `balance += quantity`.
1227             // - `numberMinted += quantity`.
1228             //
1229             // We can directly add to the `balance` and `numberMinted`.
1230             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1231 
1232             // Updates:
1233             // - `address` to the owner.
1234             // - `startTimestamp` to the timestamp of minting.
1235             // - `burned` to `false`.
1236             // - `nextInitialized` to `quantity == 1`.
1237             _packedOwnerships[startTokenId] = _packOwnershipData(
1238                 to,
1239                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1240             );
1241 
1242             uint256 toMasked;
1243             uint256 end = startTokenId + quantity;
1244 
1245             // Use assembly to loop and emit the `Transfer` event for gas savings.
1246             assembly {
1247                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1248                 toMasked := and(to, _BITMASK_ADDRESS)
1249                 // Emit the `Transfer` event.
1250                 log4(
1251                     0, // Start of data (0, since no data).
1252                     0, // End of data (0, since no data).
1253                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1254                     0, // `address(0)`.
1255                     toMasked, // `to`.
1256                     startTokenId // `tokenId`.
1257                 )
1258 
1259                 for {
1260                     let tokenId := add(startTokenId, 1)
1261                 } iszero(eq(tokenId, end)) {
1262                     tokenId := add(tokenId, 1)
1263                 } {
1264                     // Emit the `Transfer` event. Similar to above.
1265                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1266                 }
1267             }
1268             if (toMasked == 0) revert MintToZeroAddress();
1269 
1270             _currentIndex = end;
1271         }
1272         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1273     }
1274 
1275     /**
1276      * @dev Mints `quantity` tokens and transfers them to `to`.
1277      *
1278      * This function is intended for efficient minting only during contract creation.
1279      *
1280      * It emits only one {ConsecutiveTransfer} as defined in
1281      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1282      * instead of a sequence of {Transfer} event(s).
1283      *
1284      * Calling this function outside of contract creation WILL make your contract
1285      * non-compliant with the ERC721 standard.
1286      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1287      * {ConsecutiveTransfer} event is only permissible during contract creation.
1288      *
1289      * Requirements:
1290      *
1291      * - `to` cannot be the zero address.
1292      * - `quantity` must be greater than 0.
1293      *
1294      * Emits a {ConsecutiveTransfer} event.
1295      */
1296     function _mintERC2309(address to, uint256 quantity) internal virtual {
1297         uint256 startTokenId = _currentIndex;
1298         if (to == address(0)) revert MintToZeroAddress();
1299         if (quantity == 0) revert MintZeroQuantity();
1300         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1301 
1302         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1303 
1304         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1305         unchecked {
1306             // Updates:
1307             // - `balance += quantity`.
1308             // - `numberMinted += quantity`.
1309             //
1310             // We can directly add to the `balance` and `numberMinted`.
1311             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1312 
1313             // Updates:
1314             // - `address` to the owner.
1315             // - `startTimestamp` to the timestamp of minting.
1316             // - `burned` to `false`.
1317             // - `nextInitialized` to `quantity == 1`.
1318             _packedOwnerships[startTokenId] = _packOwnershipData(
1319                 to,
1320                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1321             );
1322 
1323             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1324 
1325             _currentIndex = startTokenId + quantity;
1326         }
1327         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1328     }
1329 
1330     /**
1331      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1332      *
1333      * Requirements:
1334      *
1335      * - If `to` refers to a smart contract, it must implement
1336      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1337      * - `quantity` must be greater than 0.
1338      *
1339      * See {_mint}.
1340      *
1341      * Emits a {Transfer} event for each mint.
1342      */
1343     function _safeMint(
1344         address to,
1345         uint256 quantity,
1346         bytes memory _data
1347     ) internal virtual {
1348         _mint(to, quantity);
1349 
1350         unchecked {
1351             if (to.code.length != 0) {
1352                 uint256 end = _currentIndex;
1353                 uint256 index = end - quantity;
1354                 do {
1355                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1356                         revert TransferToNonERC721ReceiverImplementer();
1357                     }
1358                 } while (index < end);
1359                 // Reentrancy protection.
1360                 if (_currentIndex != end) revert();
1361             }
1362         }
1363     }
1364 
1365     /**
1366      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1367      */
1368     function _safeMint(address to, uint256 quantity) internal virtual {
1369         _safeMint(to, quantity, '');
1370     }
1371 
1372     // =============================================================
1373     //                        BURN OPERATIONS
1374     // =============================================================
1375 
1376     /**
1377      * @dev Equivalent to `_burn(tokenId, false)`.
1378      */
1379     function _burn(uint256 tokenId) internal virtual {
1380         _burn(tokenId, false);
1381     }
1382 
1383     /**
1384      * @dev Destroys `tokenId`.
1385      * The approval is cleared when the token is burned.
1386      *
1387      * Requirements:
1388      *
1389      * - `tokenId` must exist.
1390      *
1391      * Emits a {Transfer} event.
1392      */
1393     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1394         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1395 
1396         address from = address(uint160(prevOwnershipPacked));
1397 
1398         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1399 
1400         if (approvalCheck) {
1401             // The nested ifs save around 20+ gas over a compound boolean condition.
1402             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1403                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1404         }
1405 
1406         _beforeTokenTransfers(from, address(0), tokenId, 1);
1407 
1408         // Clear approvals from the previous owner.
1409         assembly {
1410             if approvedAddress {
1411                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1412                 sstore(approvedAddressSlot, 0)
1413             }
1414         }
1415 
1416         // Underflow of the sender's balance is impossible because we check for
1417         // ownership above and the recipient's balance can't realistically overflow.
1418         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1419         unchecked {
1420             // Updates:
1421             // - `balance -= 1`.
1422             // - `numberBurned += 1`.
1423             //
1424             // We can directly decrement the balance, and increment the number burned.
1425             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1426             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1427 
1428             // Updates:
1429             // - `address` to the last owner.
1430             // - `startTimestamp` to the timestamp of burning.
1431             // - `burned` to `true`.
1432             // - `nextInitialized` to `true`.
1433             _packedOwnerships[tokenId] = _packOwnershipData(
1434                 from,
1435                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1436             );
1437 
1438             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1439             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1440                 uint256 nextTokenId = tokenId + 1;
1441                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1442                 if (_packedOwnerships[nextTokenId] == 0) {
1443                     // If the next slot is within bounds.
1444                     if (nextTokenId != _currentIndex) {
1445                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1446                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1447                     }
1448                 }
1449             }
1450         }
1451 
1452         emit Transfer(from, address(0), tokenId);
1453         _afterTokenTransfers(from, address(0), tokenId, 1);
1454 
1455         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1456         unchecked {
1457             _burnCounter++;
1458         }
1459     }
1460 
1461     // =============================================================
1462     //                     EXTRA DATA OPERATIONS
1463     // =============================================================
1464 
1465     /**
1466      * @dev Directly sets the extra data for the ownership data `index`.
1467      */
1468     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1469         uint256 packed = _packedOwnerships[index];
1470         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1471         uint256 extraDataCasted;
1472         // Cast `extraData` with assembly to avoid redundant masking.
1473         assembly {
1474             extraDataCasted := extraData
1475         }
1476         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1477         _packedOwnerships[index] = packed;
1478     }
1479 
1480     /**
1481      * @dev Called during each token transfer to set the 24bit `extraData` field.
1482      * Intended to be overridden by the cosumer contract.
1483      *
1484      * `previousExtraData` - the value of `extraData` before transfer.
1485      *
1486      * Calling conditions:
1487      *
1488      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1489      * transferred to `to`.
1490      * - When `from` is zero, `tokenId` will be minted for `to`.
1491      * - When `to` is zero, `tokenId` will be burned by `from`.
1492      * - `from` and `to` are never both zero.
1493      */
1494     function _extraData(
1495         address from,
1496         address to,
1497         uint24 previousExtraData
1498     ) internal view virtual returns (uint24) {}
1499 
1500     /**
1501      * @dev Returns the next extra data for the packed ownership data.
1502      * The returned result is shifted into position.
1503      */
1504     function _nextExtraData(
1505         address from,
1506         address to,
1507         uint256 prevOwnershipPacked
1508     ) private view returns (uint256) {
1509         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1510         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1511     }
1512 
1513     // =============================================================
1514     //                       OTHER OPERATIONS
1515     // =============================================================
1516 
1517     /**
1518      * @dev Returns the message sender (defaults to `msg.sender`).
1519      *
1520      * If you are writing GSN compatible contracts, you need to override this function.
1521      */
1522     function _msgSenderERC721A() internal view virtual returns (address) {
1523         return msg.sender;
1524     }
1525 
1526     /**
1527      * @dev Converts a uint256 to its ASCII string decimal representation.
1528      */
1529     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1530         assembly {
1531             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1532             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1533             // We will need 1 32-byte word to store the length,
1534             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1535             str := add(mload(0x40), 0x80)
1536             // Update the free memory pointer to allocate.
1537             mstore(0x40, str)
1538 
1539             // Cache the end of the memory to calculate the length later.
1540             let end := str
1541 
1542             // We write the string from rightmost digit to leftmost digit.
1543             // The following is essentially a do-while loop that also handles the zero case.
1544             // prettier-ignore
1545             for { let temp := value } 1 {} {
1546                 str := sub(str, 1)
1547                 // Write the character to the pointer.
1548                 // The ASCII index of the '0' character is 48.
1549                 mstore8(str, add(48, mod(temp, 10)))
1550                 // Keep dividing `temp` until zero.
1551                 temp := div(temp, 10)
1552                 // prettier-ignore
1553                 if iszero(temp) { break }
1554             }
1555 
1556             let length := sub(end, str)
1557             // Move the pointer 32 bytes leftwards to make room for the length.
1558             str := sub(str, 0x20)
1559             // Store the length.
1560             mstore(str, length)
1561         }
1562     }
1563 }
1564 // File: contracts/SuperJuice.sol
1565 
1566 
1567 pragma solidity ^0.8.4;
1568 
1569 
1570 
1571 
1572 contract SuperJuice is ERC721A, Ownable {
1573    
1574     string metadataPath;
1575 
1576   constructor(string memory _metadataPath) ERC721A("SuperJuice", "SPRJ") {
1577       metadataPath = _metadataPath;
1578   }
1579     
1580     /**
1581     * Mint a token
1582     */
1583     function mint(uint _amount) external onlyOwner{
1584       _mint(msg.sender, _amount);
1585     }
1586 
1587     /**
1588     * Update the base URI for metadata
1589     */
1590     function updateBaseURI(string memory baseURI) external onlyOwner{
1591          metadataPath = baseURI;
1592     }
1593 
1594 
1595     /**
1596      * @dev See {IERC721Metadata-tokenURI}.
1597      */
1598     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1599          return bytes(metadataPath).length != 0 ? string(abi.encodePacked(metadataPath, Strings.toString(_tokenId),'.json')) : '';
1600     }
1601 
1602 
1603     
1604 }