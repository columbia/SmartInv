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
194 // ERC721A Contracts v4.2.3
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
214      * Cannot query the balance for the zero address.
215      */
216     error BalanceQueryForZeroAddress();
217 
218     /**
219      * Cannot mint to the zero address.
220      */
221     error MintToZeroAddress();
222 
223     /**
224      * The quantity of tokens minted must be more than zero.
225      */
226     error MintZeroQuantity();
227 
228     /**
229      * The token does not exist.
230      */
231     error OwnerQueryForNonexistentToken();
232 
233     /**
234      * The caller must own the token or be an approved operator.
235      */
236     error TransferCallerNotOwnerNorApproved();
237 
238     /**
239      * The token must be owned by `from`.
240      */
241     error TransferFromIncorrectOwner();
242 
243     /**
244      * Cannot safely transfer to a contract that does not implement the
245      * ERC721Receiver interface.
246      */
247     error TransferToNonERC721ReceiverImplementer();
248 
249     /**
250      * Cannot transfer to the zero address.
251      */
252     error TransferToZeroAddress();
253 
254     /**
255      * The token does not exist.
256      */
257     error URIQueryForNonexistentToken();
258 
259     /**
260      * The `quantity` minted with ERC2309 exceeds the safety limit.
261      */
262     error MintERC2309QuantityExceedsLimit();
263 
264     /**
265      * The `extraData` cannot be set on an unintialized ownership slot.
266      */
267     error OwnershipNotInitializedForExtraData();
268 
269     // =============================================================
270     //                            STRUCTS
271     // =============================================================
272 
273     struct TokenOwnership {
274         // The address of the owner.
275         address addr;
276         // Stores the start time of ownership with minimal overhead for tokenomics.
277         uint64 startTimestamp;
278         // Whether the token has been burned.
279         bool burned;
280         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
281         uint24 extraData;
282     }
283 
284     // =============================================================
285     //                         TOKEN COUNTERS
286     // =============================================================
287 
288     /**
289      * @dev Returns the total number of tokens in existence.
290      * Burned tokens will reduce the count.
291      * To get the total number of tokens minted, please see {_totalMinted}.
292      */
293     function totalSupply() external view returns (uint256);
294 
295     // =============================================================
296     //                            IERC165
297     // =============================================================
298 
299     /**
300      * @dev Returns true if this contract implements the interface defined by
301      * `interfaceId`. See the corresponding
302      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
303      * to learn more about how these ids are created.
304      *
305      * This function call must use less than 30000 gas.
306      */
307     function supportsInterface(bytes4 interfaceId) external view returns (bool);
308 
309     // =============================================================
310     //                            IERC721
311     // =============================================================
312 
313     /**
314      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
315      */
316     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
317 
318     /**
319      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
320      */
321     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
322 
323     /**
324      * @dev Emitted when `owner` enables or disables
325      * (`approved`) `operator` to manage all of its assets.
326      */
327     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
328 
329     /**
330      * @dev Returns the number of tokens in `owner`'s account.
331      */
332     function balanceOf(address owner) external view returns (uint256 balance);
333 
334     /**
335      * @dev Returns the owner of the `tokenId` token.
336      *
337      * Requirements:
338      *
339      * - `tokenId` must exist.
340      */
341     function ownerOf(uint256 tokenId) external view returns (address owner);
342 
343     /**
344      * @dev Safely transfers `tokenId` token from `from` to `to`,
345      * checking first that contract recipients are aware of the ERC721 protocol
346      * to prevent tokens from being forever locked.
347      *
348      * Requirements:
349      *
350      * - `from` cannot be the zero address.
351      * - `to` cannot be the zero address.
352      * - `tokenId` token must exist and be owned by `from`.
353      * - If the caller is not `from`, it must be have been allowed to move
354      * this token by either {approve} or {setApprovalForAll}.
355      * - If `to` refers to a smart contract, it must implement
356      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
357      *
358      * Emits a {Transfer} event.
359      */
360     function safeTransferFrom(
361         address from,
362         address to,
363         uint256 tokenId,
364         bytes calldata data
365     ) external payable;
366 
367     /**
368      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
369      */
370     function safeTransferFrom(
371         address from,
372         address to,
373         uint256 tokenId
374     ) external payable;
375 
376     /**
377      * @dev Transfers `tokenId` from `from` to `to`.
378      *
379      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
380      * whenever possible.
381      *
382      * Requirements:
383      *
384      * - `from` cannot be the zero address.
385      * - `to` cannot be the zero address.
386      * - `tokenId` token must be owned by `from`.
387      * - If the caller is not `from`, it must be approved to move this token
388      * by either {approve} or {setApprovalForAll}.
389      *
390      * Emits a {Transfer} event.
391      */
392     function transferFrom(
393         address from,
394         address to,
395         uint256 tokenId
396     ) external payable;
397 
398     /**
399      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
400      * The approval is cleared when the token is transferred.
401      *
402      * Only a single account can be approved at a time, so approving the
403      * zero address clears previous approvals.
404      *
405      * Requirements:
406      *
407      * - The caller must own the token or be an approved operator.
408      * - `tokenId` must exist.
409      *
410      * Emits an {Approval} event.
411      */
412     function approve(address to, uint256 tokenId) external payable;
413 
414     /**
415      * @dev Approve or remove `operator` as an operator for the caller.
416      * Operators can call {transferFrom} or {safeTransferFrom}
417      * for any token owned by the caller.
418      *
419      * Requirements:
420      *
421      * - The `operator` cannot be the caller.
422      *
423      * Emits an {ApprovalForAll} event.
424      */
425     function setApprovalForAll(address operator, bool _approved) external;
426 
427     /**
428      * @dev Returns the account approved for `tokenId` token.
429      *
430      * Requirements:
431      *
432      * - `tokenId` must exist.
433      */
434     function getApproved(uint256 tokenId) external view returns (address operator);
435 
436     /**
437      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
438      *
439      * See {setApprovalForAll}.
440      */
441     function isApprovedForAll(address owner, address operator) external view returns (bool);
442 
443     // =============================================================
444     //                        IERC721Metadata
445     // =============================================================
446 
447     /**
448      * @dev Returns the token collection name.
449      */
450     function name() external view returns (string memory);
451 
452     /**
453      * @dev Returns the token collection symbol.
454      */
455     function symbol() external view returns (string memory);
456 
457     /**
458      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
459      */
460     function tokenURI(uint256 tokenId) external view returns (string memory);
461 
462     // =============================================================
463     //                           IERC2309
464     // =============================================================
465 
466     /**
467      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
468      * (inclusive) is transferred from `from` to `to`, as defined in the
469      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
470      *
471      * See {_mintERC2309} for more details.
472      */
473     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
474 }
475 
476 // File: erc721a/contracts/ERC721A.sol
477 
478 
479 // ERC721A Contracts v4.2.3
480 // Creator: Chiru Labs
481 
482 pragma solidity ^0.8.4;
483 
484 
485 /**
486  * @dev Interface of ERC721 token receiver.
487  */
488 interface ERC721A__IERC721Receiver {
489     function onERC721Received(
490         address operator,
491         address from,
492         uint256 tokenId,
493         bytes calldata data
494     ) external returns (bytes4);
495 }
496 
497 /**
498  * @title ERC721A
499  *
500  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
501  * Non-Fungible Token Standard, including the Metadata extension.
502  * Optimized for lower gas during batch mints.
503  *
504  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
505  * starting from `_startTokenId()`.
506  *
507  * Assumptions:
508  *
509  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
510  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
511  */
512 contract ERC721A is IERC721A {
513     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
514     struct TokenApprovalRef {
515         address value;
516     }
517 
518     // =============================================================
519     //                           CONSTANTS
520     // =============================================================
521 
522     // Mask of an entry in packed address data.
523     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
524 
525     // The bit position of `numberMinted` in packed address data.
526     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
527 
528     // The bit position of `numberBurned` in packed address data.
529     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
530 
531     // The bit position of `aux` in packed address data.
532     uint256 private constant _BITPOS_AUX = 192;
533 
534     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
535     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
536 
537     // The bit position of `startTimestamp` in packed ownership.
538     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
539 
540     // The bit mask of the `burned` bit in packed ownership.
541     uint256 private constant _BITMASK_BURNED = 1 << 224;
542 
543     // The bit position of the `nextInitialized` bit in packed ownership.
544     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
545 
546     // The bit mask of the `nextInitialized` bit in packed ownership.
547     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
548 
549     // The bit position of `extraData` in packed ownership.
550     uint256 private constant _BITPOS_EXTRA_DATA = 232;
551 
552     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
553     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
554 
555     // The mask of the lower 160 bits for addresses.
556     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
557 
558     // The maximum `quantity` that can be minted with {_mintERC2309}.
559     // This limit is to prevent overflows on the address data entries.
560     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
561     // is required to cause an overflow, which is unrealistic.
562     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
563 
564     // The `Transfer` event signature is given by:
565     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
566     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
567         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
568 
569     // =============================================================
570     //                            STORAGE
571     // =============================================================
572 
573     // The next token ID to be minted.
574     uint256 private _currentIndex;
575 
576     // The number of tokens burned.
577     uint256 private _burnCounter;
578 
579     // Token name
580     string private _name;
581 
582     // Token symbol
583     string private _symbol;
584 
585     // Mapping from token ID to ownership details
586     // An empty struct value does not necessarily mean the token is unowned.
587     // See {_packedOwnershipOf} implementation for details.
588     //
589     // Bits Layout:
590     // - [0..159]   `addr`
591     // - [160..223] `startTimestamp`
592     // - [224]      `burned`
593     // - [225]      `nextInitialized`
594     // - [232..255] `extraData`
595     mapping(uint256 => uint256) private _packedOwnerships;
596 
597     // Mapping owner address to address data.
598     //
599     // Bits Layout:
600     // - [0..63]    `balance`
601     // - [64..127]  `numberMinted`
602     // - [128..191] `numberBurned`
603     // - [192..255] `aux`
604     mapping(address => uint256) private _packedAddressData;
605 
606     // Mapping from token ID to approved address.
607     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
608 
609     // Mapping from owner to operator approvals
610     mapping(address => mapping(address => bool)) private _operatorApprovals;
611 
612     // =============================================================
613     //                          CONSTRUCTOR
614     // =============================================================
615 
616     constructor(string memory name_, string memory symbol_) {
617         _name = name_;
618         _symbol = symbol_;
619         _currentIndex = _startTokenId();
620     }
621 
622     // =============================================================
623     //                   TOKEN COUNTING OPERATIONS
624     // =============================================================
625 
626     /**
627      * @dev Returns the starting token ID.
628      * To change the starting token ID, please override this function.
629      */
630     function _startTokenId() internal view virtual returns (uint256) {
631         return 0;
632     }
633 
634     /**
635      * @dev Returns the next token ID to be minted.
636      */
637     function _nextTokenId() internal view virtual returns (uint256) {
638         return _currentIndex;
639     }
640 
641     /**
642      * @dev Returns the total number of tokens in existence.
643      * Burned tokens will reduce the count.
644      * To get the total number of tokens minted, please see {_totalMinted}.
645      */
646     function totalSupply() public view virtual override returns (uint256) {
647         // Counter underflow is impossible as _burnCounter cannot be incremented
648         // more than `_currentIndex - _startTokenId()` times.
649         unchecked {
650             return _currentIndex - _burnCounter - _startTokenId();
651         }
652     }
653 
654     /**
655      * @dev Returns the total amount of tokens minted in the contract.
656      */
657     function _totalMinted() internal view virtual returns (uint256) {
658         // Counter underflow is impossible as `_currentIndex` does not decrement,
659         // and it is initialized to `_startTokenId()`.
660         unchecked {
661             return _currentIndex - _startTokenId();
662         }
663     }
664 
665     /**
666      * @dev Returns the total number of tokens burned.
667      */
668     function _totalBurned() internal view virtual returns (uint256) {
669         return _burnCounter;
670     }
671 
672     // =============================================================
673     //                    ADDRESS DATA OPERATIONS
674     // =============================================================
675 
676     /**
677      * @dev Returns the number of tokens in `owner`'s account.
678      */
679     function balanceOf(address owner) public view virtual override returns (uint256) {
680         if (owner == address(0)) revert BalanceQueryForZeroAddress();
681         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
682     }
683 
684     /**
685      * Returns the number of tokens minted by `owner`.
686      */
687     function _numberMinted(address owner) internal view returns (uint256) {
688         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
689     }
690 
691     /**
692      * Returns the number of tokens burned by or on behalf of `owner`.
693      */
694     function _numberBurned(address owner) internal view returns (uint256) {
695         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
696     }
697 
698     /**
699      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
700      */
701     function _getAux(address owner) internal view returns (uint64) {
702         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
703     }
704 
705     /**
706      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
707      * If there are multiple variables, please pack them into a uint64.
708      */
709     function _setAux(address owner, uint64 aux) internal virtual {
710         uint256 packed = _packedAddressData[owner];
711         uint256 auxCasted;
712         // Cast `aux` with assembly to avoid redundant masking.
713         assembly {
714             auxCasted := aux
715         }
716         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
717         _packedAddressData[owner] = packed;
718     }
719 
720     // =============================================================
721     //                            IERC165
722     // =============================================================
723 
724     /**
725      * @dev Returns true if this contract implements the interface defined by
726      * `interfaceId`. See the corresponding
727      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
728      * to learn more about how these ids are created.
729      *
730      * This function call must use less than 30000 gas.
731      */
732     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
733         // The interface IDs are constants representing the first 4 bytes
734         // of the XOR of all function selectors in the interface.
735         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
736         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
737         return
738             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
739             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
740             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
741     }
742 
743     // =============================================================
744     //                        IERC721Metadata
745     // =============================================================
746 
747     /**
748      * @dev Returns the token collection name.
749      */
750     function name() public view virtual override returns (string memory) {
751         return _name;
752     }
753 
754     /**
755      * @dev Returns the token collection symbol.
756      */
757     function symbol() public view virtual override returns (string memory) {
758         return _symbol;
759     }
760 
761     /**
762      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
763      */
764     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
765         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
766 
767         string memory baseURI = _baseURI();
768         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
769     }
770 
771     /**
772      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
773      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
774      * by default, it can be overridden in child contracts.
775      */
776     function _baseURI() internal view virtual returns (string memory) {
777         return '';
778     }
779 
780     // =============================================================
781     //                     OWNERSHIPS OPERATIONS
782     // =============================================================
783 
784     /**
785      * @dev Returns the owner of the `tokenId` token.
786      *
787      * Requirements:
788      *
789      * - `tokenId` must exist.
790      */
791     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
792         return address(uint160(_packedOwnershipOf(tokenId)));
793     }
794 
795     /**
796      * @dev Gas spent here starts off proportional to the maximum mint batch size.
797      * It gradually moves to O(1) as tokens get transferred around over time.
798      */
799     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
800         return _unpackedOwnership(_packedOwnershipOf(tokenId));
801     }
802 
803     /**
804      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
805      */
806     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
807         return _unpackedOwnership(_packedOwnerships[index]);
808     }
809 
810     /**
811      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
812      */
813     function _initializeOwnershipAt(uint256 index) internal virtual {
814         if (_packedOwnerships[index] == 0) {
815             _packedOwnerships[index] = _packedOwnershipOf(index);
816         }
817     }
818 
819     /**
820      * Returns the packed ownership data of `tokenId`.
821      */
822     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
823         uint256 curr = tokenId;
824 
825         unchecked {
826             if (_startTokenId() <= curr)
827                 if (curr < _currentIndex) {
828                     uint256 packed = _packedOwnerships[curr];
829                     // If not burned.
830                     if (packed & _BITMASK_BURNED == 0) {
831                         // Invariant:
832                         // There will always be an initialized ownership slot
833                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
834                         // before an unintialized ownership slot
835                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
836                         // Hence, `curr` will not underflow.
837                         //
838                         // We can directly compare the packed value.
839                         // If the address is zero, packed will be zero.
840                         while (packed == 0) {
841                             packed = _packedOwnerships[--curr];
842                         }
843                         return packed;
844                     }
845                 }
846         }
847         revert OwnerQueryForNonexistentToken();
848     }
849 
850     /**
851      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
852      */
853     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
854         ownership.addr = address(uint160(packed));
855         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
856         ownership.burned = packed & _BITMASK_BURNED != 0;
857         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
858     }
859 
860     /**
861      * @dev Packs ownership data into a single uint256.
862      */
863     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
864         assembly {
865             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
866             owner := and(owner, _BITMASK_ADDRESS)
867             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
868             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
869         }
870     }
871 
872     /**
873      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
874      */
875     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
876         // For branchless setting of the `nextInitialized` flag.
877         assembly {
878             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
879             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
880         }
881     }
882 
883     // =============================================================
884     //                      APPROVAL OPERATIONS
885     // =============================================================
886 
887     /**
888      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
889      * The approval is cleared when the token is transferred.
890      *
891      * Only a single account can be approved at a time, so approving the
892      * zero address clears previous approvals.
893      *
894      * Requirements:
895      *
896      * - The caller must own the token or be an approved operator.
897      * - `tokenId` must exist.
898      *
899      * Emits an {Approval} event.
900      */
901     function approve(address to, uint256 tokenId) public payable virtual override {
902         address owner = ownerOf(tokenId);
903 
904         if (_msgSenderERC721A() != owner)
905             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
906                 revert ApprovalCallerNotOwnerNorApproved();
907             }
908 
909         _tokenApprovals[tokenId].value = to;
910         emit Approval(owner, to, tokenId);
911     }
912 
913     /**
914      * @dev Returns the account approved for `tokenId` token.
915      *
916      * Requirements:
917      *
918      * - `tokenId` must exist.
919      */
920     function getApproved(uint256 tokenId) public view virtual override returns (address) {
921         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
922 
923         return _tokenApprovals[tokenId].value;
924     }
925 
926     /**
927      * @dev Approve or remove `operator` as an operator for the caller.
928      * Operators can call {transferFrom} or {safeTransferFrom}
929      * for any token owned by the caller.
930      *
931      * Requirements:
932      *
933      * - The `operator` cannot be the caller.
934      *
935      * Emits an {ApprovalForAll} event.
936      */
937     function setApprovalForAll(address operator, bool approved) public virtual override {
938         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
939         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
940     }
941 
942     /**
943      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
944      *
945      * See {setApprovalForAll}.
946      */
947     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
948         return _operatorApprovals[owner][operator];
949     }
950 
951     /**
952      * @dev Returns whether `tokenId` exists.
953      *
954      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
955      *
956      * Tokens start existing when they are minted. See {_mint}.
957      */
958     function _exists(uint256 tokenId) internal view virtual returns (bool) {
959         return
960             _startTokenId() <= tokenId &&
961             tokenId < _currentIndex && // If within bounds,
962             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
963     }
964 
965     /**
966      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
967      */
968     function _isSenderApprovedOrOwner(
969         address approvedAddress,
970         address owner,
971         address msgSender
972     ) private pure returns (bool result) {
973         assembly {
974             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
975             owner := and(owner, _BITMASK_ADDRESS)
976             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
977             msgSender := and(msgSender, _BITMASK_ADDRESS)
978             // `msgSender == owner || msgSender == approvedAddress`.
979             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
980         }
981     }
982 
983     /**
984      * @dev Returns the storage slot and value for the approved address of `tokenId`.
985      */
986     function _getApprovedSlotAndAddress(uint256 tokenId)
987         private
988         view
989         returns (uint256 approvedAddressSlot, address approvedAddress)
990     {
991         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
992         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
993         assembly {
994             approvedAddressSlot := tokenApproval.slot
995             approvedAddress := sload(approvedAddressSlot)
996         }
997     }
998 
999     // =============================================================
1000     //                      TRANSFER OPERATIONS
1001     // =============================================================
1002 
1003     /**
1004      * @dev Transfers `tokenId` from `from` to `to`.
1005      *
1006      * Requirements:
1007      *
1008      * - `from` cannot be the zero address.
1009      * - `to` cannot be the zero address.
1010      * - `tokenId` token must be owned by `from`.
1011      * - If the caller is not `from`, it must be approved to move this token
1012      * by either {approve} or {setApprovalForAll}.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function transferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) public payable virtual override {
1021         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1022 
1023         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1024 
1025         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1026 
1027         // The nested ifs save around 20+ gas over a compound boolean condition.
1028         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1029             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1030 
1031         if (to == address(0)) revert TransferToZeroAddress();
1032 
1033         _beforeTokenTransfers(from, to, tokenId, 1);
1034 
1035         // Clear approvals from the previous owner.
1036         assembly {
1037             if approvedAddress {
1038                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1039                 sstore(approvedAddressSlot, 0)
1040             }
1041         }
1042 
1043         // Underflow of the sender's balance is impossible because we check for
1044         // ownership above and the recipient's balance can't realistically overflow.
1045         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1046         unchecked {
1047             // We can directly increment and decrement the balances.
1048             --_packedAddressData[from]; // Updates: `balance -= 1`.
1049             ++_packedAddressData[to]; // Updates: `balance += 1`.
1050 
1051             // Updates:
1052             // - `address` to the next owner.
1053             // - `startTimestamp` to the timestamp of transfering.
1054             // - `burned` to `false`.
1055             // - `nextInitialized` to `true`.
1056             _packedOwnerships[tokenId] = _packOwnershipData(
1057                 to,
1058                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1059             );
1060 
1061             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1062             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1063                 uint256 nextTokenId = tokenId + 1;
1064                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1065                 if (_packedOwnerships[nextTokenId] == 0) {
1066                     // If the next slot is within bounds.
1067                     if (nextTokenId != _currentIndex) {
1068                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1069                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1070                     }
1071                 }
1072             }
1073         }
1074 
1075         emit Transfer(from, to, tokenId);
1076         _afterTokenTransfers(from, to, tokenId, 1);
1077     }
1078 
1079     /**
1080      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1081      */
1082     function safeTransferFrom(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) public payable virtual override {
1087         safeTransferFrom(from, to, tokenId, '');
1088     }
1089 
1090     /**
1091      * @dev Safely transfers `tokenId` token from `from` to `to`.
1092      *
1093      * Requirements:
1094      *
1095      * - `from` cannot be the zero address.
1096      * - `to` cannot be the zero address.
1097      * - `tokenId` token must exist and be owned by `from`.
1098      * - If the caller is not `from`, it must be approved to move this token
1099      * by either {approve} or {setApprovalForAll}.
1100      * - If `to` refers to a smart contract, it must implement
1101      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function safeTransferFrom(
1106         address from,
1107         address to,
1108         uint256 tokenId,
1109         bytes memory _data
1110     ) public payable virtual override {
1111         transferFrom(from, to, tokenId);
1112         if (to.code.length != 0)
1113             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1114                 revert TransferToNonERC721ReceiverImplementer();
1115             }
1116     }
1117 
1118     /**
1119      * @dev Hook that is called before a set of serially-ordered token IDs
1120      * are about to be transferred. This includes minting.
1121      * And also called before burning one token.
1122      *
1123      * `startTokenId` - the first token ID to be transferred.
1124      * `quantity` - the amount to be transferred.
1125      *
1126      * Calling conditions:
1127      *
1128      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1129      * transferred to `to`.
1130      * - When `from` is zero, `tokenId` will be minted for `to`.
1131      * - When `to` is zero, `tokenId` will be burned by `from`.
1132      * - `from` and `to` are never both zero.
1133      */
1134     function _beforeTokenTransfers(
1135         address from,
1136         address to,
1137         uint256 startTokenId,
1138         uint256 quantity
1139     ) internal virtual {}
1140 
1141     /**
1142      * @dev Hook that is called after a set of serially-ordered token IDs
1143      * have been transferred. This includes minting.
1144      * And also called after one token has been burned.
1145      *
1146      * `startTokenId` - the first token ID to be transferred.
1147      * `quantity` - the amount to be transferred.
1148      *
1149      * Calling conditions:
1150      *
1151      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1152      * transferred to `to`.
1153      * - When `from` is zero, `tokenId` has been minted for `to`.
1154      * - When `to` is zero, `tokenId` has been burned by `from`.
1155      * - `from` and `to` are never both zero.
1156      */
1157     function _afterTokenTransfers(
1158         address from,
1159         address to,
1160         uint256 startTokenId,
1161         uint256 quantity
1162     ) internal virtual {}
1163 
1164     /**
1165      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1166      *
1167      * `from` - Previous owner of the given token ID.
1168      * `to` - Target address that will receive the token.
1169      * `tokenId` - Token ID to be transferred.
1170      * `_data` - Optional data to send along with the call.
1171      *
1172      * Returns whether the call correctly returned the expected magic value.
1173      */
1174     function _checkContractOnERC721Received(
1175         address from,
1176         address to,
1177         uint256 tokenId,
1178         bytes memory _data
1179     ) private returns (bool) {
1180         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1181             bytes4 retval
1182         ) {
1183             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1184         } catch (bytes memory reason) {
1185             if (reason.length == 0) {
1186                 revert TransferToNonERC721ReceiverImplementer();
1187             } else {
1188                 assembly {
1189                     revert(add(32, reason), mload(reason))
1190                 }
1191             }
1192         }
1193     }
1194 
1195     // =============================================================
1196     //                        MINT OPERATIONS
1197     // =============================================================
1198 
1199     /**
1200      * @dev Mints `quantity` tokens and transfers them to `to`.
1201      *
1202      * Requirements:
1203      *
1204      * - `to` cannot be the zero address.
1205      * - `quantity` must be greater than 0.
1206      *
1207      * Emits a {Transfer} event for each mint.
1208      */
1209     function _mint(address to, uint256 quantity) internal virtual {
1210         uint256 startTokenId = _currentIndex;
1211         if (quantity == 0) revert MintZeroQuantity();
1212 
1213         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1214 
1215         // Overflows are incredibly unrealistic.
1216         // `balance` and `numberMinted` have a maximum limit of 2**64.
1217         // `tokenId` has a maximum limit of 2**256.
1218         unchecked {
1219             // Updates:
1220             // - `balance += quantity`.
1221             // - `numberMinted += quantity`.
1222             //
1223             // We can directly add to the `balance` and `numberMinted`.
1224             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1225 
1226             // Updates:
1227             // - `address` to the owner.
1228             // - `startTimestamp` to the timestamp of minting.
1229             // - `burned` to `false`.
1230             // - `nextInitialized` to `quantity == 1`.
1231             _packedOwnerships[startTokenId] = _packOwnershipData(
1232                 to,
1233                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1234             );
1235 
1236             uint256 toMasked;
1237             uint256 end = startTokenId + quantity;
1238 
1239             // Use assembly to loop and emit the `Transfer` event for gas savings.
1240             // The duplicated `log4` removes an extra check and reduces stack juggling.
1241             // The assembly, together with the surrounding Solidity code, have been
1242             // delicately arranged to nudge the compiler into producing optimized opcodes.
1243             assembly {
1244                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1245                 toMasked := and(to, _BITMASK_ADDRESS)
1246                 // Emit the `Transfer` event.
1247                 log4(
1248                     0, // Start of data (0, since no data).
1249                     0, // End of data (0, since no data).
1250                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1251                     0, // `address(0)`.
1252                     toMasked, // `to`.
1253                     startTokenId // `tokenId`.
1254                 )
1255 
1256                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1257                 // that overflows uint256 will make the loop run out of gas.
1258                 // The compiler will optimize the `iszero` away for performance.
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
1531             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1532             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1533             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1534             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1535             let m := add(mload(0x40), 0xa0)
1536             // Update the free memory pointer to allocate.
1537             mstore(0x40, m)
1538             // Assign the `str` to the end.
1539             str := sub(m, 0x20)
1540             // Zeroize the slot after the string.
1541             mstore(str, 0)
1542 
1543             // Cache the end of the memory to calculate the length later.
1544             let end := str
1545 
1546             // We write the string from rightmost digit to leftmost digit.
1547             // The following is essentially a do-while loop that also handles the zero case.
1548             // prettier-ignore
1549             for { let temp := value } 1 {} {
1550                 str := sub(str, 1)
1551                 // Write the character to the pointer.
1552                 // The ASCII index of the '0' character is 48.
1553                 mstore8(str, add(48, mod(temp, 10)))
1554                 // Keep dividing `temp` until zero.
1555                 temp := div(temp, 10)
1556                 // prettier-ignore
1557                 if iszero(temp) { break }
1558             }
1559 
1560             let length := sub(end, str)
1561             // Move the pointer 32 bytes leftwards to make room for the length.
1562             str := sub(str, 0x20)
1563             // Store the length.
1564             mstore(str, length)
1565         }
1566     }
1567 }
1568 
1569 // File: close mint 2.sol
1570 
1571 
1572 
1573 pragma solidity 0.8.9;
1574 
1575 
1576 
1577 
1578 contract POURKOKO is ERC721A, Ownable {
1579     using Strings for uint256;
1580 
1581     uint256 public maxSupply = 888;
1582     uint256 public price  = 0 ;
1583     uint256 private maxTransactionAmount =2;
1584     string baseURI = "ipfs://QmdPn517S3Zn9VhbK2Tr3Bs8ode7yC2cDJruHpsW3ri7Mt/";
1585     bool paused;
1586 
1587 
1588 
1589     constructor () ERC721A("Pour KoKo","PK"){
1590 
1591     }
1592 
1593     function mint(uint256 _quantity) public payable{
1594         require(totalSupply()+_quantity <= maxSupply,"Exceeds Max Supply");
1595         if(msg.sender != owner()){
1596             require(!paused,"Minting Paused");
1597             require(msg.value >= _quantity * price,"Insufficient Fund");
1598             require(_quantity <= maxTransactionAmount,"You cannot mint more than 10");
1599         }
1600         _safeMint(msg.sender,_quantity);
1601     }
1602 
1603     function setPrice(uint256 _price) public onlyOwner {
1604         price = _price;
1605     }
1606 
1607     function _baseURI() internal view virtual override returns (string memory) {
1608         return baseURI;
1609     }
1610 
1611     function setBaseURI(string memory newURI) public onlyOwner{
1612         baseURI = newURI;
1613     }
1614 
1615     function tooglePause() public onlyOwner{
1616         paused = !paused;
1617     }
1618 
1619     
1620 
1621     function tokenURI(uint256 _tokenId)
1622         public
1623         view
1624         virtual
1625         override
1626         returns (string memory)
1627     {
1628         require(
1629             _exists(_tokenId),
1630             "ERC721Metadata: URI query for nonexistent token"
1631         );
1632         string memory baseURIE = _baseURI();
1633         return baseURIE;
1634     }
1635 
1636 
1637     
1638 }