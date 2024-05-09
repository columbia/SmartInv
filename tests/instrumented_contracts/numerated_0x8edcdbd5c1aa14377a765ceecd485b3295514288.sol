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
191 // File: erc721a/contracts/IERC721A.sol
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
480 
481 // File: erc721a/contracts/ERC721A.sol
482 
483 
484 // ERC721A Contracts v4.2.2
485 // Creator: Chiru Labs
486 
487 pragma solidity ^0.8.4;
488 
489 
490 /**
491  * @dev Interface of ERC721 token receiver.
492  */
493 interface ERC721A__IERC721Receiver {
494     function onERC721Received(
495         address operator,
496         address from,
497         uint256 tokenId,
498         bytes calldata data
499     ) external returns (bytes4);
500 }
501 
502 /**
503  * @title ERC721A
504  *
505  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
506  * Non-Fungible Token Standard, including the Metadata extension.
507  * Optimized for lower gas during batch mints.
508  *
509  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
510  * starting from `_startTokenId()`.
511  *
512  * Assumptions:
513  *
514  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
515  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
516  */
517 contract ERC721A is IERC721A {
518     // Reference type for token approval.
519     struct TokenApprovalRef {
520         address value;
521     }
522 
523     // =============================================================
524     //                           CONSTANTS
525     // =============================================================
526 
527     // Mask of an entry in packed address data.
528     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
529 
530     // The bit position of `numberMinted` in packed address data.
531     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
532 
533     // The bit position of `numberBurned` in packed address data.
534     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
535 
536     // The bit position of `aux` in packed address data.
537     uint256 private constant _BITPOS_AUX = 192;
538 
539     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
540     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
541 
542     // The bit position of `startTimestamp` in packed ownership.
543     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
544 
545     // The bit mask of the `burned` bit in packed ownership.
546     uint256 private constant _BITMASK_BURNED = 1 << 224;
547 
548     // The bit position of the `nextInitialized` bit in packed ownership.
549     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
550 
551     // The bit mask of the `nextInitialized` bit in packed ownership.
552     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
553 
554     // The bit position of `extraData` in packed ownership.
555     uint256 private constant _BITPOS_EXTRA_DATA = 232;
556 
557     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
558     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
559 
560     // The mask of the lower 160 bits for addresses.
561     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
562 
563     // The maximum `quantity` that can be minted with {_mintERC2309}.
564     // This limit is to prevent overflows on the address data entries.
565     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
566     // is required to cause an overflow, which is unrealistic.
567     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
568 
569     // The `Transfer` event signature is given by:
570     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
571     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
572         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
573 
574     // =============================================================
575     //                            STORAGE
576     // =============================================================
577 
578     // The next token ID to be minted.
579     uint256 private _currentIndex;
580 
581     // The number of tokens burned.
582     uint256 private _burnCounter;
583 
584     // Token name
585     string private _name;
586 
587     // Token symbol
588     string private _symbol;
589 
590     // Mapping from token ID to ownership details
591     // An empty struct value does not necessarily mean the token is unowned.
592     // See {_packedOwnershipOf} implementation for details.
593     //
594     // Bits Layout:
595     // - [0..159]   `addr`
596     // - [160..223] `startTimestamp`
597     // - [224]      `burned`
598     // - [225]      `nextInitialized`
599     // - [232..255] `extraData`
600     mapping(uint256 => uint256) private _packedOwnerships;
601 
602     // Mapping owner address to address data.
603     //
604     // Bits Layout:
605     // - [0..63]    `balance`
606     // - [64..127]  `numberMinted`
607     // - [128..191] `numberBurned`
608     // - [192..255] `aux`
609     mapping(address => uint256) private _packedAddressData;
610 
611     // Mapping from token ID to approved address.
612     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
613 
614     // Mapping from owner to operator approvals
615     mapping(address => mapping(address => bool)) private _operatorApprovals;
616 
617     // =============================================================
618     //                          CONSTRUCTOR
619     // =============================================================
620 
621     constructor(string memory name_, string memory symbol_) {
622         _name = name_;
623         _symbol = symbol_;
624         _currentIndex = _startTokenId();
625     }
626 
627     // =============================================================
628     //                   TOKEN COUNTING OPERATIONS
629     // =============================================================
630 
631     /**
632      * @dev Returns the starting token ID.
633      * To change the starting token ID, please override this function.
634      */
635     function _startTokenId() internal view virtual returns (uint256) {
636         return 0;
637     }
638 
639     /**
640      * @dev Returns the next token ID to be minted.
641      */
642     function _nextTokenId() internal view virtual returns (uint256) {
643         return _currentIndex;
644     }
645 
646     /**
647      * @dev Returns the total number of tokens in existence.
648      * Burned tokens will reduce the count.
649      * To get the total number of tokens minted, please see {_totalMinted}.
650      */
651     function totalSupply() public view virtual override returns (uint256) {
652         // Counter underflow is impossible as _burnCounter cannot be incremented
653         // more than `_currentIndex - _startTokenId()` times.
654         unchecked {
655             return _currentIndex - _burnCounter - _startTokenId();
656         }
657     }
658 
659     /**
660      * @dev Returns the total amount of tokens minted in the contract.
661      */
662     function _totalMinted() internal view virtual returns (uint256) {
663         // Counter underflow is impossible as `_currentIndex` does not decrement,
664         // and it is initialized to `_startTokenId()`.
665         unchecked {
666             return _currentIndex - _startTokenId();
667         }
668     }
669 
670     /**
671      * @dev Returns the total number of tokens burned.
672      */
673     function _totalBurned() internal view virtual returns (uint256) {
674         return _burnCounter;
675     }
676 
677     // =============================================================
678     //                    ADDRESS DATA OPERATIONS
679     // =============================================================
680 
681     /**
682      * @dev Returns the number of tokens in `owner`'s account.
683      */
684     function balanceOf(address owner) public view virtual override returns (uint256) {
685         if (owner == address(0)) revert BalanceQueryForZeroAddress();
686         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
687     }
688 
689     /**
690      * Returns the number of tokens minted by `owner`.
691      */
692     function _numberMinted(address owner) internal view returns (uint256) {
693         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
694     }
695 
696     /**
697      * Returns the number of tokens burned by or on behalf of `owner`.
698      */
699     function _numberBurned(address owner) internal view returns (uint256) {
700         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
701     }
702 
703     /**
704      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
705      */
706     function _getAux(address owner) internal view returns (uint64) {
707         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
708     }
709 
710     /**
711      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
712      * If there are multiple variables, please pack them into a uint64.
713      */
714     function _setAux(address owner, uint64 aux) internal virtual {
715         uint256 packed = _packedAddressData[owner];
716         uint256 auxCasted;
717         // Cast `aux` with assembly to avoid redundant masking.
718         assembly {
719             auxCasted := aux
720         }
721         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
722         _packedAddressData[owner] = packed;
723     }
724 
725     // =============================================================
726     //                            IERC165
727     // =============================================================
728 
729     /**
730      * @dev Returns true if this contract implements the interface defined by
731      * `interfaceId`. See the corresponding
732      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
733      * to learn more about how these ids are created.
734      *
735      * This function call must use less than 30000 gas.
736      */
737     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
738         // The interface IDs are constants representing the first 4 bytes
739         // of the XOR of all function selectors in the interface.
740         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
741         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
742         return
743             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
744             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
745             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
746     }
747 
748     // =============================================================
749     //                        IERC721Metadata
750     // =============================================================
751 
752     /**
753      * @dev Returns the token collection name.
754      */
755     function name() public view virtual override returns (string memory) {
756         return _name;
757     }
758 
759     /**
760      * @dev Returns the token collection symbol.
761      */
762     function symbol() public view virtual override returns (string memory) {
763         return _symbol;
764     }
765 
766     /**
767      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
768      */
769     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
770         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
771 
772         string memory baseURI = _baseURI();
773         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
774     }
775 
776     /**
777      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
778      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
779      * by default, it can be overridden in child contracts.
780      */
781     function _baseURI() internal view virtual returns (string memory) {
782         return '';
783     }
784 
785     // =============================================================
786     //                     OWNERSHIPS OPERATIONS
787     // =============================================================
788 
789     /**
790      * @dev Returns the owner of the `tokenId` token.
791      *
792      * Requirements:
793      *
794      * - `tokenId` must exist.
795      */
796     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
797         return address(uint160(_packedOwnershipOf(tokenId)));
798     }
799 
800     /**
801      * @dev Gas spent here starts off proportional to the maximum mint batch size.
802      * It gradually moves to O(1) as tokens get transferred around over time.
803      */
804     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
805         return _unpackedOwnership(_packedOwnershipOf(tokenId));
806     }
807 
808     /**
809      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
810      */
811     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
812         return _unpackedOwnership(_packedOwnerships[index]);
813     }
814 
815     /**
816      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
817      */
818     function _initializeOwnershipAt(uint256 index) internal virtual {
819         if (_packedOwnerships[index] == 0) {
820             _packedOwnerships[index] = _packedOwnershipOf(index);
821         }
822     }
823 
824     /**
825      * Returns the packed ownership data of `tokenId`.
826      */
827     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
828         uint256 curr = tokenId;
829 
830         unchecked {
831             if (_startTokenId() <= curr)
832                 if (curr < _currentIndex) {
833                     uint256 packed = _packedOwnerships[curr];
834                     // If not burned.
835                     if (packed & _BITMASK_BURNED == 0) {
836                         // Invariant:
837                         // There will always be an initialized ownership slot
838                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
839                         // before an unintialized ownership slot
840                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
841                         // Hence, `curr` will not underflow.
842                         //
843                         // We can directly compare the packed value.
844                         // If the address is zero, packed will be zero.
845                         while (packed == 0) {
846                             packed = _packedOwnerships[--curr];
847                         }
848                         return packed;
849                     }
850                 }
851         }
852         revert OwnerQueryForNonexistentToken();
853     }
854 
855     /**
856      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
857      */
858     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
859         ownership.addr = address(uint160(packed));
860         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
861         ownership.burned = packed & _BITMASK_BURNED != 0;
862         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
863     }
864 
865     /**
866      * @dev Packs ownership data into a single uint256.
867      */
868     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
869         assembly {
870             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
871             owner := and(owner, _BITMASK_ADDRESS)
872             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
873             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
874         }
875     }
876 
877     /**
878      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
879      */
880     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
881         // For branchless setting of the `nextInitialized` flag.
882         assembly {
883             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
884             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
885         }
886     }
887 
888     // =============================================================
889     //                      APPROVAL OPERATIONS
890     // =============================================================
891 
892     /**
893      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
894      * The approval is cleared when the token is transferred.
895      *
896      * Only a single account can be approved at a time, so approving the
897      * zero address clears previous approvals.
898      *
899      * Requirements:
900      *
901      * - The caller must own the token or be an approved operator.
902      * - `tokenId` must exist.
903      *
904      * Emits an {Approval} event.
905      */
906     function approve(address to, uint256 tokenId) public virtual override {
907         address owner = ownerOf(tokenId);
908 
909         if (_msgSenderERC721A() != owner)
910             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
911                 revert ApprovalCallerNotOwnerNorApproved();
912             }
913 
914         _tokenApprovals[tokenId].value = to;
915         emit Approval(owner, to, tokenId);
916     }
917 
918     /**
919      * @dev Returns the account approved for `tokenId` token.
920      *
921      * Requirements:
922      *
923      * - `tokenId` must exist.
924      */
925     function getApproved(uint256 tokenId) public view virtual override returns (address) {
926         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
927 
928         return _tokenApprovals[tokenId].value;
929     }
930 
931     /**
932      * @dev Approve or remove `operator` as an operator for the caller.
933      * Operators can call {transferFrom} or {safeTransferFrom}
934      * for any token owned by the caller.
935      *
936      * Requirements:
937      *
938      * - The `operator` cannot be the caller.
939      *
940      * Emits an {ApprovalForAll} event.
941      */
942     function setApprovalForAll(address operator, bool approved) public virtual override {
943         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
944 
945         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
946         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
947     }
948 
949     /**
950      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
951      *
952      * See {setApprovalForAll}.
953      */
954     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
955         return _operatorApprovals[owner][operator];
956     }
957 
958     /**
959      * @dev Returns whether `tokenId` exists.
960      *
961      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
962      *
963      * Tokens start existing when they are minted. See {_mint}.
964      */
965     function _exists(uint256 tokenId) internal view virtual returns (bool) {
966         return
967             _startTokenId() <= tokenId &&
968             tokenId < _currentIndex && // If within bounds,
969             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
970     }
971 
972     /**
973      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
974      */
975     function _isSenderApprovedOrOwner(
976         address approvedAddress,
977         address owner,
978         address msgSender
979     ) private pure returns (bool result) {
980         assembly {
981             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
982             owner := and(owner, _BITMASK_ADDRESS)
983             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
984             msgSender := and(msgSender, _BITMASK_ADDRESS)
985             // `msgSender == owner || msgSender == approvedAddress`.
986             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
987         }
988     }
989 
990     /**
991      * @dev Returns the storage slot and value for the approved address of `tokenId`.
992      */
993     function _getApprovedSlotAndAddress(uint256 tokenId)
994         private
995         view
996         returns (uint256 approvedAddressSlot, address approvedAddress)
997     {
998         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
999         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1000         assembly {
1001             approvedAddressSlot := tokenApproval.slot
1002             approvedAddress := sload(approvedAddressSlot)
1003         }
1004     }
1005 
1006     // =============================================================
1007     //                      TRANSFER OPERATIONS
1008     // =============================================================
1009 
1010     /**
1011      * @dev Transfers `tokenId` from `from` to `to`.
1012      *
1013      * Requirements:
1014      *
1015      * - `from` cannot be the zero address.
1016      * - `to` cannot be the zero address.
1017      * - `tokenId` token must be owned by `from`.
1018      * - If the caller is not `from`, it must be approved to move this token
1019      * by either {approve} or {setApprovalForAll}.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function transferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) public virtual override {
1028         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1029 
1030         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1031 
1032         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1033 
1034         // The nested ifs save around 20+ gas over a compound boolean condition.
1035         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1036             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1037 
1038         if (to == address(0)) revert TransferToZeroAddress();
1039 
1040         _beforeTokenTransfers(from, to, tokenId, 1);
1041 
1042         // Clear approvals from the previous owner.
1043         assembly {
1044             if approvedAddress {
1045                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1046                 sstore(approvedAddressSlot, 0)
1047             }
1048         }
1049 
1050         // Underflow of the sender's balance is impossible because we check for
1051         // ownership above and the recipient's balance can't realistically overflow.
1052         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1053         unchecked {
1054             // We can directly increment and decrement the balances.
1055             --_packedAddressData[from]; // Updates: `balance -= 1`.
1056             ++_packedAddressData[to]; // Updates: `balance += 1`.
1057 
1058             // Updates:
1059             // - `address` to the next owner.
1060             // - `startTimestamp` to the timestamp of transfering.
1061             // - `burned` to `false`.
1062             // - `nextInitialized` to `true`.
1063             _packedOwnerships[tokenId] = _packOwnershipData(
1064                 to,
1065                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1066             );
1067 
1068             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1069             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1070                 uint256 nextTokenId = tokenId + 1;
1071                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1072                 if (_packedOwnerships[nextTokenId] == 0) {
1073                     // If the next slot is within bounds.
1074                     if (nextTokenId != _currentIndex) {
1075                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1076                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1077                     }
1078                 }
1079             }
1080         }
1081 
1082         emit Transfer(from, to, tokenId);
1083         _afterTokenTransfers(from, to, tokenId, 1);
1084     }
1085 
1086     /**
1087      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1088      */
1089     function safeTransferFrom(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) public virtual override {
1094         safeTransferFrom(from, to, tokenId, '');
1095     }
1096 
1097     /**
1098      * @dev Safely transfers `tokenId` token from `from` to `to`.
1099      *
1100      * Requirements:
1101      *
1102      * - `from` cannot be the zero address.
1103      * - `to` cannot be the zero address.
1104      * - `tokenId` token must exist and be owned by `from`.
1105      * - If the caller is not `from`, it must be approved to move this token
1106      * by either {approve} or {setApprovalForAll}.
1107      * - If `to` refers to a smart contract, it must implement
1108      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1109      *
1110      * Emits a {Transfer} event.
1111      */
1112     function safeTransferFrom(
1113         address from,
1114         address to,
1115         uint256 tokenId,
1116         bytes memory _data
1117     ) public virtual override {
1118         transferFrom(from, to, tokenId);
1119         if (to.code.length != 0)
1120             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1121                 revert TransferToNonERC721ReceiverImplementer();
1122             }
1123     }
1124 
1125     /**
1126      * @dev Hook that is called before a set of serially-ordered token IDs
1127      * are about to be transferred. This includes minting.
1128      * And also called before burning one token.
1129      *
1130      * `startTokenId` - the first token ID to be transferred.
1131      * `quantity` - the amount to be transferred.
1132      *
1133      * Calling conditions:
1134      *
1135      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1136      * transferred to `to`.
1137      * - When `from` is zero, `tokenId` will be minted for `to`.
1138      * - When `to` is zero, `tokenId` will be burned by `from`.
1139      * - `from` and `to` are never both zero.
1140      */
1141     function _beforeTokenTransfers(
1142         address from,
1143         address to,
1144         uint256 startTokenId,
1145         uint256 quantity
1146     ) internal virtual {}
1147 
1148     /**
1149      * @dev Hook that is called after a set of serially-ordered token IDs
1150      * have been transferred. This includes minting.
1151      * And also called after one token has been burned.
1152      *
1153      * `startTokenId` - the first token ID to be transferred.
1154      * `quantity` - the amount to be transferred.
1155      *
1156      * Calling conditions:
1157      *
1158      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1159      * transferred to `to`.
1160      * - When `from` is zero, `tokenId` has been minted for `to`.
1161      * - When `to` is zero, `tokenId` has been burned by `from`.
1162      * - `from` and `to` are never both zero.
1163      */
1164     function _afterTokenTransfers(
1165         address from,
1166         address to,
1167         uint256 startTokenId,
1168         uint256 quantity
1169     ) internal virtual {}
1170 
1171     /**
1172      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1173      *
1174      * `from` - Previous owner of the given token ID.
1175      * `to` - Target address that will receive the token.
1176      * `tokenId` - Token ID to be transferred.
1177      * `_data` - Optional data to send along with the call.
1178      *
1179      * Returns whether the call correctly returned the expected magic value.
1180      */
1181     function _checkContractOnERC721Received(
1182         address from,
1183         address to,
1184         uint256 tokenId,
1185         bytes memory _data
1186     ) private returns (bool) {
1187         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1188             bytes4 retval
1189         ) {
1190             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1191         } catch (bytes memory reason) {
1192             if (reason.length == 0) {
1193                 revert TransferToNonERC721ReceiverImplementer();
1194             } else {
1195                 assembly {
1196                     revert(add(32, reason), mload(reason))
1197                 }
1198             }
1199         }
1200     }
1201 
1202     // =============================================================
1203     //                        MINT OPERATIONS
1204     // =============================================================
1205 
1206     /**
1207      * @dev Mints `quantity` tokens and transfers them to `to`.
1208      *
1209      * Requirements:
1210      *
1211      * - `to` cannot be the zero address.
1212      * - `quantity` must be greater than 0.
1213      *
1214      * Emits a {Transfer} event for each mint.
1215      */
1216     function _mint(address to, uint256 quantity) internal virtual {
1217         uint256 startTokenId = _currentIndex;
1218         if (quantity == 0) revert MintZeroQuantity();
1219 
1220         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1221 
1222         // Overflows are incredibly unrealistic.
1223         // `balance` and `numberMinted` have a maximum limit of 2**64.
1224         // `tokenId` has a maximum limit of 2**256.
1225         unchecked {
1226             // Updates:
1227             // - `balance += quantity`.
1228             // - `numberMinted += quantity`.
1229             //
1230             // We can directly add to the `balance` and `numberMinted`.
1231             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1232 
1233             // Updates:
1234             // - `address` to the owner.
1235             // - `startTimestamp` to the timestamp of minting.
1236             // - `burned` to `false`.
1237             // - `nextInitialized` to `quantity == 1`.
1238             _packedOwnerships[startTokenId] = _packOwnershipData(
1239                 to,
1240                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1241             );
1242 
1243             uint256 toMasked;
1244             uint256 end = startTokenId + quantity;
1245 
1246             // Use assembly to loop and emit the `Transfer` event for gas savings.
1247             assembly {
1248                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1249                 toMasked := and(to, _BITMASK_ADDRESS)
1250                 // Emit the `Transfer` event.
1251                 log4(
1252                     0, // Start of data (0, since no data).
1253                     0, // End of data (0, since no data).
1254                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1255                     0, // `address(0)`.
1256                     toMasked, // `to`.
1257                     startTokenId // `tokenId`.
1258                 )
1259 
1260                 for {
1261                     let tokenId := add(startTokenId, 1)
1262                 } iszero(eq(tokenId, end)) {
1263                     tokenId := add(tokenId, 1)
1264                 } {
1265                     // Emit the `Transfer` event. Similar to above.
1266                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1267                 }
1268             }
1269             if (toMasked == 0) revert MintToZeroAddress();
1270 
1271             _currentIndex = end;
1272         }
1273         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1274     }
1275 
1276     /**
1277      * @dev Mints `quantity` tokens and transfers them to `to`.
1278      *
1279      * This function is intended for efficient minting only during contract creation.
1280      *
1281      * It emits only one {ConsecutiveTransfer} as defined in
1282      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1283      * instead of a sequence of {Transfer} event(s).
1284      *
1285      * Calling this function outside of contract creation WILL make your contract
1286      * non-compliant with the ERC721 standard.
1287      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1288      * {ConsecutiveTransfer} event is only permissible during contract creation.
1289      *
1290      * Requirements:
1291      *
1292      * - `to` cannot be the zero address.
1293      * - `quantity` must be greater than 0.
1294      *
1295      * Emits a {ConsecutiveTransfer} event.
1296      */
1297     function _mintERC2309(address to, uint256 quantity) internal virtual {
1298         uint256 startTokenId = _currentIndex;
1299         if (to == address(0)) revert MintToZeroAddress();
1300         if (quantity == 0) revert MintZeroQuantity();
1301         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1302 
1303         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1304 
1305         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1306         unchecked {
1307             // Updates:
1308             // - `balance += quantity`.
1309             // - `numberMinted += quantity`.
1310             //
1311             // We can directly add to the `balance` and `numberMinted`.
1312             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1313 
1314             // Updates:
1315             // - `address` to the owner.
1316             // - `startTimestamp` to the timestamp of minting.
1317             // - `burned` to `false`.
1318             // - `nextInitialized` to `quantity == 1`.
1319             _packedOwnerships[startTokenId] = _packOwnershipData(
1320                 to,
1321                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1322             );
1323 
1324             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1325 
1326             _currentIndex = startTokenId + quantity;
1327         }
1328         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1329     }
1330 
1331     /**
1332      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1333      *
1334      * Requirements:
1335      *
1336      * - If `to` refers to a smart contract, it must implement
1337      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1338      * - `quantity` must be greater than 0.
1339      *
1340      * See {_mint}.
1341      *
1342      * Emits a {Transfer} event for each mint.
1343      */
1344     function _safeMint(
1345         address to,
1346         uint256 quantity,
1347         bytes memory _data
1348     ) internal virtual {
1349         _mint(to, quantity);
1350 
1351         unchecked {
1352             if (to.code.length != 0) {
1353                 uint256 end = _currentIndex;
1354                 uint256 index = end - quantity;
1355                 do {
1356                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1357                         revert TransferToNonERC721ReceiverImplementer();
1358                     }
1359                 } while (index < end);
1360                 // Reentrancy protection.
1361                 if (_currentIndex != end) revert();
1362             }
1363         }
1364     }
1365 
1366     /**
1367      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1368      */
1369     function _safeMint(address to, uint256 quantity) internal virtual {
1370         _safeMint(to, quantity, '');
1371     }
1372 
1373     // =============================================================
1374     //                        BURN OPERATIONS
1375     // =============================================================
1376 
1377     /**
1378      * @dev Equivalent to `_burn(tokenId, false)`.
1379      */
1380     function _burn(uint256 tokenId) internal virtual {
1381         _burn(tokenId, false);
1382     }
1383 
1384     /**
1385      * @dev Destroys `tokenId`.
1386      * The approval is cleared when the token is burned.
1387      *
1388      * Requirements:
1389      *
1390      * - `tokenId` must exist.
1391      *
1392      * Emits a {Transfer} event.
1393      */
1394     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1395         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1396 
1397         address from = address(uint160(prevOwnershipPacked));
1398 
1399         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1400 
1401         if (approvalCheck) {
1402             // The nested ifs save around 20+ gas over a compound boolean condition.
1403             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1404                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1405         }
1406 
1407         _beforeTokenTransfers(from, address(0), tokenId, 1);
1408 
1409         // Clear approvals from the previous owner.
1410         assembly {
1411             if approvedAddress {
1412                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1413                 sstore(approvedAddressSlot, 0)
1414             }
1415         }
1416 
1417         // Underflow of the sender's balance is impossible because we check for
1418         // ownership above and the recipient's balance can't realistically overflow.
1419         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1420         unchecked {
1421             // Updates:
1422             // - `balance -= 1`.
1423             // - `numberBurned += 1`.
1424             //
1425             // We can directly decrement the balance, and increment the number burned.
1426             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1427             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1428 
1429             // Updates:
1430             // - `address` to the last owner.
1431             // - `startTimestamp` to the timestamp of burning.
1432             // - `burned` to `true`.
1433             // - `nextInitialized` to `true`.
1434             _packedOwnerships[tokenId] = _packOwnershipData(
1435                 from,
1436                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1437             );
1438 
1439             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1440             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1441                 uint256 nextTokenId = tokenId + 1;
1442                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1443                 if (_packedOwnerships[nextTokenId] == 0) {
1444                     // If the next slot is within bounds.
1445                     if (nextTokenId != _currentIndex) {
1446                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1447                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1448                     }
1449                 }
1450             }
1451         }
1452 
1453         emit Transfer(from, address(0), tokenId);
1454         _afterTokenTransfers(from, address(0), tokenId, 1);
1455 
1456         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1457         unchecked {
1458             _burnCounter++;
1459         }
1460     }
1461 
1462     // =============================================================
1463     //                     EXTRA DATA OPERATIONS
1464     // =============================================================
1465 
1466     /**
1467      * @dev Directly sets the extra data for the ownership data `index`.
1468      */
1469     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1470         uint256 packed = _packedOwnerships[index];
1471         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1472         uint256 extraDataCasted;
1473         // Cast `extraData` with assembly to avoid redundant masking.
1474         assembly {
1475             extraDataCasted := extraData
1476         }
1477         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1478         _packedOwnerships[index] = packed;
1479     }
1480 
1481     /**
1482      * @dev Called during each token transfer to set the 24bit `extraData` field.
1483      * Intended to be overridden by the cosumer contract.
1484      *
1485      * `previousExtraData` - the value of `extraData` before transfer.
1486      *
1487      * Calling conditions:
1488      *
1489      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1490      * transferred to `to`.
1491      * - When `from` is zero, `tokenId` will be minted for `to`.
1492      * - When `to` is zero, `tokenId` will be burned by `from`.
1493      * - `from` and `to` are never both zero.
1494      */
1495     function _extraData(
1496         address from,
1497         address to,
1498         uint24 previousExtraData
1499     ) internal view virtual returns (uint24) {}
1500 
1501     /**
1502      * @dev Returns the next extra data for the packed ownership data.
1503      * The returned result is shifted into position.
1504      */
1505     function _nextExtraData(
1506         address from,
1507         address to,
1508         uint256 prevOwnershipPacked
1509     ) private view returns (uint256) {
1510         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1511         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1512     }
1513 
1514     // =============================================================
1515     //                       OTHER OPERATIONS
1516     // =============================================================
1517 
1518     /**
1519      * @dev Returns the message sender (defaults to `msg.sender`).
1520      *
1521      * If you are writing GSN compatible contracts, you need to override this function.
1522      */
1523     function _msgSenderERC721A() internal view virtual returns (address) {
1524         return msg.sender;
1525     }
1526 
1527     /**
1528      * @dev Converts a uint256 to its ASCII string decimal representation.
1529      */
1530     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1531         assembly {
1532             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1533             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1534             // We will need 1 32-byte word to store the length,
1535             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1536             str := add(mload(0x40), 0x80)
1537             // Update the free memory pointer to allocate.
1538             mstore(0x40, str)
1539 
1540             // Cache the end of the memory to calculate the length later.
1541             let end := str
1542 
1543             // We write the string from rightmost digit to leftmost digit.
1544             // The following is essentially a do-while loop that also handles the zero case.
1545             // prettier-ignore
1546             for { let temp := value } 1 {} {
1547                 str := sub(str, 1)
1548                 // Write the character to the pointer.
1549                 // The ASCII index of the '0' character is 48.
1550                 mstore8(str, add(48, mod(temp, 10)))
1551                 // Keep dividing `temp` until zero.
1552                 temp := div(temp, 10)
1553                 // prettier-ignore
1554                 if iszero(temp) { break }
1555             }
1556 
1557             let length := sub(end, str)
1558             // Move the pointer 32 bytes leftwards to make room for the length.
1559             str := sub(str, 0x20)
1560             // Store the length.
1561             mstore(str, length)
1562         }
1563     }
1564 }
1565 
1566 // File: contracts/121.sol
1567 
1568 
1569 pragma solidity ^0.8.7;
1570 
1571 
1572 
1573 
1574 contract AAC is ERC721A,Ownable {
1575     using Strings for uint256;
1576 
1577     enum EPublicMintStatus {
1578         NOTACTIVE,
1579         ALLOWLIST_MINT,
1580         PUBLIC_MINT,
1581         CLOSED
1582     }
1583 
1584     EPublicMintStatus public publicMintStatus;
1585 
1586     string  public baseTokenURI;
1587     string  public defaultTokenURI;
1588     uint256 public maxSupply;
1589     uint256 public publicSalePrice;
1590     mapping(address => uint256) public usermint;
1591 
1592     constructor(
1593         string memory _baseTokenURI,
1594         uint   _maxSupply,
1595         uint   _publicSalePrice
1596     ) ERC721A ("Angry Ape Club", "AAC") {
1597         baseTokenURI = _baseTokenURI;
1598         maxSupply = _maxSupply;
1599         publicSalePrice = _publicSalePrice;
1600         _safeMint(_msgSender(), 1);
1601     }
1602 
1603     modifier callerIsUser() {
1604         require(tx.origin == msg.sender, "Must from real wallet address");
1605         _;
1606     }
1607 
1608     function mint(uint256 _quantity) external callerIsUser payable   {
1609         require(publicMintStatus==EPublicMintStatus.PUBLIC_MINT, "Public sale closed");
1610         require(_quantity <= 20, "Invalid quantity");
1611         require(totalSupply() + _quantity <= maxSupply, "Exceed supply");
1612 
1613         uint256 _remainFreeQuantity = 0;
1614         if (1 > usermint[msg.sender] ) {
1615             _remainFreeQuantity = 3 - usermint[msg.sender];
1616         }
1617 
1618         uint256 _needPayPrice = 0;
1619         if (_quantity > _remainFreeQuantity) {
1620             _needPayPrice = (_quantity - _remainFreeQuantity) * publicSalePrice;
1621         }
1622 
1623         require(msg.value >= _needPayPrice, "Ether is not enough");
1624         usermint[msg.sender]+=_quantity;
1625         _safeMint(msg.sender, _quantity);
1626     }
1627 
1628 
1629     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1630         require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1631         string memory currentBaseURI = _baseURI();
1632         return
1633         bytes(currentBaseURI).length > 0 ? string(
1634             abi.encodePacked(
1635                 currentBaseURI,
1636                 tokenId.toString(),
1637                 ".json"
1638             )
1639         ) : defaultTokenURI;
1640     }
1641 
1642     function _baseURI() internal view override returns (string memory) {
1643         return baseTokenURI;
1644     }
1645 
1646     function setBaseURI(string calldata _baseTokenURI) external onlyOwner {
1647         baseTokenURI = _baseTokenURI;
1648     }
1649 
1650     function setDefaultURI(string calldata _defaultURI) external onlyOwner {
1651         defaultTokenURI = _defaultURI;
1652     }
1653 
1654     function setPublicPrice(uint256 mintprice) external onlyOwner {
1655         publicSalePrice = mintprice;
1656     }
1657 
1658     function setPublicMintStatus(uint256 status) external onlyOwner {
1659         publicMintStatus = EPublicMintStatus(status);
1660     }
1661 
1662     function _startTokenId() internal view virtual override returns (uint256) {
1663         return 1;
1664     }
1665 
1666     function marketMint(address[] memory marketmintaddress,uint256[] memory mintquantity) public payable onlyOwner  {
1667         for (uint256 i = 0; i < marketmintaddress.length; i++) {
1668             require(totalSupply() + mintquantity[i] <= maxSupply, "Exceed supply");
1669             _safeMint(marketmintaddress[i], mintquantity[i]);
1670         }
1671     }
1672 
1673     function withdrawMoney() external onlyOwner {
1674         (bool success,) = msg.sender.call{value : address(this).balance}("");
1675         require(success, "Transfer failed.");
1676     }
1677     function numberMinted(address owner) external view returns (uint256) {
1678      return _numberMinted(owner);
1679   }
1680 }