1 // SPDX-License-Identifier: MIT 
2 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14     uint8 private constant _ADDRESS_LENGTH = 20;
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
74      */
75     function toHexString(address addr) internal pure returns (string memory) {
76         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
77     }
78 }
79 
80 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
81 
82 
83 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes calldata) {
103         return msg.data;
104     }
105 }
106 
107 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
108 
109 
110 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 
115 /**
116  * @dev Contract module which provides a basic access control mechanism, where
117  * there is an account (an owner) that can be granted exclusive access to
118  * specific functions.
119  *
120  * By default, the owner account will be the one that deploys the contract. This
121  * can later be changed with {transferOwnership}.
122  *
123  * This module is used through inheritance. It will make available the modifier
124  * `onlyOwner`, which can be applied to your functions to restrict their use to
125  * the owner.
126  */
127 abstract contract Ownable is Context {
128     address private _owner;
129 
130     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
131 
132     /**
133      * @dev Initializes the contract setting the deployer as the initial owner.
134      */
135     constructor() {
136         _transferOwnership(_msgSender());
137     }
138 
139     /**
140      * @dev Throws if called by any account other than the owner.
141      */
142     modifier onlyOwner() {
143         _checkOwner();
144         _;
145     }
146 
147     /**
148      * @dev Returns the address of the current owner.
149      */
150     function owner() public view virtual returns (address) {
151         return _owner;
152     }
153 
154     /**
155      * @dev Throws if the sender is not the owner.
156      */
157     function _checkOwner() internal view virtual {
158         require(owner() == _msgSender(), "Ownable: caller is not the owner");
159     }
160 
161     /**
162      * @dev Leaves the contract without owner. It will not be possible to call
163      * `onlyOwner` functions anymore. Can only be called by the current owner.
164      *
165      * NOTE: Renouncing ownership will leave the contract without an owner,
166      * thereby removing any functionality that is only available to the owner.
167      */
168     function renounceOwnership() public virtual onlyOwner {
169         _transferOwnership(address(0));
170     }
171 
172     /**
173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
174      * Can only be called by the current owner.
175      */
176     function transferOwnership(address newOwner) public virtual onlyOwner {
177         require(newOwner != address(0), "Ownable: new owner is the zero address");
178         _transferOwnership(newOwner);
179     }
180 
181     /**
182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
183      * Internal function without access restriction.
184      */
185     function _transferOwnership(address newOwner) internal virtual {
186         address oldOwner = _owner;
187         _owner = newOwner;
188         emit OwnershipTransferred(oldOwner, newOwner);
189     }
190 }
191 
192 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
193 
194 
195 // ERC721A Contracts v4.2.2
196 // Creator: Chiru Labs
197 
198 pragma solidity ^0.8.4;
199 
200 /**
201  * @dev Interface of ERC721A.
202  */
203 interface IERC721A {
204     /**
205      * The caller must own the token or be an approved operator.
206      */
207     error ApprovalCallerNotOwnerNorApproved();
208 
209     /**
210      * The token does not exist.
211      */
212     error ApprovalQueryForNonexistentToken();
213 
214     /**
215      * Cannot query the balance for the zero address.
216      */
217     error BalanceQueryForZeroAddress();
218 
219     /**
220      * Cannot mint to the zero address.
221      */
222     error MintToZeroAddress();
223 
224     /**
225      * The quantity of tokens minted must be more than zero.
226      */
227     error MintZeroQuantity();
228 
229     /**
230      * The token does not exist.
231      */
232     error OwnerQueryForNonexistentToken();
233 
234     /**
235      * The caller must own the token or be an approved operator.
236      */
237     error TransferCallerNotOwnerNorApproved();
238 
239     /**
240      * The token must be owned by `from`.
241      */
242     error TransferFromIncorrectOwner();
243 
244     /**
245      * Cannot safely transfer to a contract that does not implement the
246      * ERC721Receiver interface.
247      */
248     error TransferToNonERC721ReceiverImplementer();
249 
250     /**
251      * Cannot transfer to the zero address.
252      */
253     error TransferToZeroAddress();
254 
255     /**
256      * The token does not exist.
257      */
258     error URIQueryForNonexistentToken();
259 
260     /**
261      * The `quantity` minted with ERC2309 exceeds the safety limit.
262      */
263     error MintERC2309QuantityExceedsLimit();
264 
265     /**
266      * The `extraData` cannot be set on an unintialized ownership slot.
267      */
268     error OwnershipNotInitializedForExtraData();
269 
270     // =============================================================
271     //                            STRUCTS
272     // =============================================================
273 
274     struct TokenOwnership {
275         // The address of the owner.
276         address addr;
277         // Stores the start time of ownership with minimal overhead for tokenomics.
278         uint64 startTimestamp;
279         // Whether the token has been burned.
280         bool burned;
281         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
282         uint24 extraData;
283     }
284 
285     // =============================================================
286     //                         TOKEN COUNTERS
287     // =============================================================
288 
289     /**
290      * @dev Returns the total number of tokens in existence.
291      * Burned tokens will reduce the count.
292      * To get the total number of tokens minted, please see {_totalMinted}.
293      */
294     function totalSupply() external view returns (uint256);
295 
296     // =============================================================
297     //                            IERC165
298     // =============================================================
299 
300     /**
301      * @dev Returns true if this contract implements the interface defined by
302      * `interfaceId`. See the corresponding
303      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
304      * to learn more about how these ids are created.
305      *
306      * This function call must use less than 30000 gas.
307      */
308     function supportsInterface(bytes4 interfaceId) external view returns (bool);
309 
310     // =============================================================
311     //                            IERC721
312     // =============================================================
313 
314     /**
315      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
316      */
317     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
318 
319     /**
320      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
321      */
322     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
323 
324     /**
325      * @dev Emitted when `owner` enables or disables
326      * (`approved`) `operator` to manage all of its assets.
327      */
328     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
329 
330     /**
331      * @dev Returns the number of tokens in `owner`'s account.
332      */
333     function balanceOf(address owner) external view returns (uint256 balance);
334 
335     /**
336      * @dev Returns the owner of the `tokenId` token.
337      *
338      * Requirements:
339      *
340      * - `tokenId` must exist.
341      */
342     function ownerOf(uint256 tokenId) external view returns (address owner);
343 
344     /**
345      * @dev Safely transfers `tokenId` token from `from` to `to`,
346      * checking first that contract recipients are aware of the ERC721 protocol
347      * to prevent tokens from being forever locked.
348      *
349      * Requirements:
350      *
351      * - `from` cannot be the zero address.
352      * - `to` cannot be the zero address.
353      * - `tokenId` token must exist and be owned by `from`.
354      * - If the caller is not `from`, it must be have been allowed to move
355      * this token by either {approve} or {setApprovalForAll}.
356      * - If `to` refers to a smart contract, it must implement
357      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
358      *
359      * Emits a {Transfer} event.
360      */
361     function safeTransferFrom(
362         address from,
363         address to,
364         uint256 tokenId,
365         bytes calldata data
366     ) external;
367 
368     /**
369      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
370      */
371     function safeTransferFrom(
372         address from,
373         address to,
374         uint256 tokenId
375     ) external;
376 
377     /**
378      * @dev Transfers `tokenId` from `from` to `to`.
379      *
380      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
381      * whenever possible.
382      *
383      * Requirements:
384      *
385      * - `from` cannot be the zero address.
386      * - `to` cannot be the zero address.
387      * - `tokenId` token must be owned by `from`.
388      * - If the caller is not `from`, it must be approved to move this token
389      * by either {approve} or {setApprovalForAll}.
390      *
391      * Emits a {Transfer} event.
392      */
393     function transferFrom(
394         address from,
395         address to,
396         uint256 tokenId
397     ) external;
398 
399     /**
400      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
401      * The approval is cleared when the token is transferred.
402      *
403      * Only a single account can be approved at a time, so approving the
404      * zero address clears previous approvals.
405      *
406      * Requirements:
407      *
408      * - The caller must own the token or be an approved operator.
409      * - `tokenId` must exist.
410      *
411      * Emits an {Approval} event.
412      */
413     function approve(address to, uint256 tokenId) external;
414 
415     /**
416      * @dev Approve or remove `operator` as an operator for the caller.
417      * Operators can call {transferFrom} or {safeTransferFrom}
418      * for any token owned by the caller.
419      *
420      * Requirements:
421      *
422      * - The `operator` cannot be the caller.
423      *
424      * Emits an {ApprovalForAll} event.
425      */
426     function setApprovalForAll(address operator, bool _approved) external;
427 
428     /**
429      * @dev Returns the account approved for `tokenId` token.
430      *
431      * Requirements:
432      *
433      * - `tokenId` must exist.
434      */
435     function getApproved(uint256 tokenId) external view returns (address operator);
436 
437     /**
438      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
439      *
440      * See {setApprovalForAll}.
441      */
442     function isApprovedForAll(address owner, address operator) external view returns (bool);
443 
444     // =============================================================
445     //                        IERC721Metadata
446     // =============================================================
447 
448     /**
449      * @dev Returns the token collection name.
450      */
451     function name() external view returns (string memory);
452 
453     /**
454      * @dev Returns the token collection symbol.
455      */
456     function symbol() external view returns (string memory);
457 
458     /**
459      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
460      */
461     function tokenURI(uint256 tokenId) external view returns (string memory);
462 
463     // =============================================================
464     //                           IERC2309
465     // =============================================================
466 
467     /**
468      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
469      * (inclusive) is transferred from `from` to `to`, as defined in the
470      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
471      *
472      * See {_mintERC2309} for more details.
473      */
474     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
475 }
476 
477 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
478 
479 
480 // ERC721A Contracts v4.2.2
481 // Creator: Chiru Labs
482 
483 pragma solidity ^0.8.4;
484 
485 
486 /**
487  * @dev Interface of ERC721 token receiver.
488  */
489 interface ERC721A__IERC721Receiver {
490     function onERC721Received(
491         address operator,
492         address from,
493         uint256 tokenId,
494         bytes calldata data
495     ) external returns (bytes4);
496 }
497 
498 /**
499  * @title ERC721A
500  *
501  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
502  * Non-Fungible Token Standard, including the Metadata extension.
503  * Optimized for lower gas during batch mints.
504  *
505  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
506  * starting from `_startTokenId()`.
507  *
508  * Assumptions:
509  *
510  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
511  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
512  */
513 contract ERC721A is IERC721A {
514     // Reference type for token approval.
515     struct TokenApprovalRef {
516         address value;
517     }
518 
519     // =============================================================
520     //                           CONSTANTS
521     // =============================================================
522 
523     // Mask of an entry in packed address data.
524     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
525 
526     // The bit position of `numberMinted` in packed address data.
527     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
528 
529     // The bit position of `numberBurned` in packed address data.
530     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
531 
532     // The bit position of `aux` in packed address data.
533     uint256 private constant _BITPOS_AUX = 192;
534 
535     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
536     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
537 
538     // The bit position of `startTimestamp` in packed ownership.
539     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
540 
541     // The bit mask of the `burned` bit in packed ownership.
542     uint256 private constant _BITMASK_BURNED = 1 << 224;
543 
544     // The bit position of the `nextInitialized` bit in packed ownership.
545     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
546 
547     // The bit mask of the `nextInitialized` bit in packed ownership.
548     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
549 
550     // The bit position of `extraData` in packed ownership.
551     uint256 private constant _BITPOS_EXTRA_DATA = 232;
552 
553     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
554     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
555 
556     // The mask of the lower 160 bits for addresses.
557     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
558 
559     // The maximum `quantity` that can be minted with {_mintERC2309}.
560     // This limit is to prevent overflows on the address data entries.
561     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
562     // is required to cause an overflow, which is unrealistic.
563     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
564 
565     // The `Transfer` event signature is given by:
566     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
567     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
568         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
569 
570     // =============================================================
571     //                            STORAGE
572     // =============================================================
573 
574     // The next token ID to be minted.
575     uint256 private _currentIndex;
576 
577     // The number of tokens burned.
578     uint256 private _burnCounter;
579 
580     // Token name
581     string private _name;
582 
583     // Token symbol
584     string private _symbol;
585 
586     // Mapping from token ID to ownership details
587     // An empty struct value does not necessarily mean the token is unowned.
588     // See {_packedOwnershipOf} implementation for details.
589     //
590     // Bits Layout:
591     // - [0..159]   `addr`
592     // - [160..223] `startTimestamp`
593     // - [224]      `burned`
594     // - [225]      `nextInitialized`
595     // - [232..255] `extraData`
596     mapping(uint256 => uint256) private _packedOwnerships;
597 
598     // Mapping owner address to address data.
599     //
600     // Bits Layout:
601     // - [0..63]    `balance`
602     // - [64..127]  `numberMinted`
603     // - [128..191] `numberBurned`
604     // - [192..255] `aux`
605     mapping(address => uint256) private _packedAddressData;
606 
607     // Mapping from token ID to approved address.
608     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
609 
610     // Mapping from owner to operator approvals
611     mapping(address => mapping(address => bool)) private _operatorApprovals;
612 
613     // =============================================================
614     //                          CONSTRUCTOR
615     // =============================================================
616 
617     constructor(string memory name_, string memory symbol_) {
618         _name = name_;
619         _symbol = symbol_;
620         _currentIndex = _startTokenId();
621     }
622 
623     // =============================================================
624     //                   TOKEN COUNTING OPERATIONS
625     // =============================================================
626 
627     /**
628      * @dev Returns the starting token ID.
629      * To change the starting token ID, please override this function.
630      */
631     function _startTokenId() internal view virtual returns (uint256) {
632         return 0;
633     }
634 
635     /**
636      * @dev Returns the next token ID to be minted.
637      */
638     function _nextTokenId() internal view virtual returns (uint256) {
639         return _currentIndex;
640     }
641 
642     /**
643      * @dev Returns the total number of tokens in existence.
644      * Burned tokens will reduce the count.
645      * To get the total number of tokens minted, please see {_totalMinted}.
646      */
647     function totalSupply() public view virtual override returns (uint256) {
648         // Counter underflow is impossible as _burnCounter cannot be incremented
649         // more than `_currentIndex - _startTokenId()` times.
650         unchecked {
651             return _currentIndex - _burnCounter - _startTokenId();
652         }
653     }
654 
655     /**
656      * @dev Returns the total amount of tokens minted in the contract.
657      */
658     function _totalMinted() internal view virtual returns (uint256) {
659         // Counter underflow is impossible as `_currentIndex` does not decrement,
660         // and it is initialized to `_startTokenId()`.
661         unchecked {
662             return _currentIndex - _startTokenId();
663         }
664     }
665 
666     /**
667      * @dev Returns the total number of tokens burned.
668      */
669     function _totalBurned() internal view virtual returns (uint256) {
670         return _burnCounter;
671     }
672 
673     // =============================================================
674     //                    ADDRESS DATA OPERATIONS
675     // =============================================================
676 
677     /**
678      * @dev Returns the number of tokens in `owner`'s account.
679      */
680     function balanceOf(address owner) public view virtual override returns (uint256) {
681         if (owner == address(0)) revert BalanceQueryForZeroAddress();
682         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
683     }
684 
685     /**
686      * Returns the number of tokens minted by `owner`.
687      */
688     function _numberMinted(address owner) internal view returns (uint256) {
689         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
690     }
691 
692     /**
693      * Returns the number of tokens burned by or on behalf of `owner`.
694      */
695     function _numberBurned(address owner) internal view returns (uint256) {
696         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
697     }
698 
699     /**
700      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
701      */
702     function _getAux(address owner) internal view returns (uint64) {
703         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
704     }
705 
706     /**
707      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
708      * If there are multiple variables, please pack them into a uint64.
709      */
710     function _setAux(address owner, uint64 aux) internal virtual {
711         uint256 packed = _packedAddressData[owner];
712         uint256 auxCasted;
713         // Cast `aux` with assembly to avoid redundant masking.
714         assembly {
715             auxCasted := aux
716         }
717         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
718         _packedAddressData[owner] = packed;
719     }
720 
721     // =============================================================
722     //                            IERC165
723     // =============================================================
724 
725     /**
726      * @dev Returns true if this contract implements the interface defined by
727      * `interfaceId`. See the corresponding
728      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
729      * to learn more about how these ids are created.
730      *
731      * This function call must use less than 30000 gas.
732      */
733     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
734         // The interface IDs are constants representing the first 4 bytes
735         // of the XOR of all function selectors in the interface.
736         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
737         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
738         return
739             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
740             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
741             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
742     }
743 
744     // =============================================================
745     //                        IERC721Metadata
746     // =============================================================
747 
748     /**
749      * @dev Returns the token collection name.
750      */
751     function name() public view virtual override returns (string memory) {
752         return _name;
753     }
754 
755     /**
756      * @dev Returns the token collection symbol.
757      */
758     function symbol() public view virtual override returns (string memory) {
759         return _symbol;
760     }
761 
762     /**
763      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
764      */
765     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
766         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
767 
768         string memory baseURI = _baseURI();
769         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
770     }
771 
772     /**
773      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
774      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
775      * by default, it can be overridden in child contracts.
776      */
777     function _baseURI() internal view virtual returns (string memory) {
778         return '';
779     }
780 
781     // =============================================================
782     //                     OWNERSHIPS OPERATIONS
783     // =============================================================
784 
785     /**
786      * @dev Returns the owner of the `tokenId` token.
787      *
788      * Requirements:
789      *
790      * - `tokenId` must exist.
791      */
792     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
793         return address(uint160(_packedOwnershipOf(tokenId)));
794     }
795 
796     /**
797      * @dev Gas spent here starts off proportional to the maximum mint batch size.
798      * It gradually moves to O(1) as tokens get transferred around over time.
799      */
800     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
801         return _unpackedOwnership(_packedOwnershipOf(tokenId));
802     }
803 
804     /**
805      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
806      */
807     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
808         return _unpackedOwnership(_packedOwnerships[index]);
809     }
810 
811     /**
812      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
813      */
814     function _initializeOwnershipAt(uint256 index) internal virtual {
815         if (_packedOwnerships[index] == 0) {
816             _packedOwnerships[index] = _packedOwnershipOf(index);
817         }
818     }
819 
820     /**
821      * Returns the packed ownership data of `tokenId`.
822      */
823     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
824         uint256 curr = tokenId;
825 
826         unchecked {
827             if (_startTokenId() <= curr)
828                 if (curr < _currentIndex) {
829                     uint256 packed = _packedOwnerships[curr];
830                     // If not burned.
831                     if (packed & _BITMASK_BURNED == 0) {
832                         // Invariant:
833                         // There will always be an initialized ownership slot
834                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
835                         // before an unintialized ownership slot
836                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
837                         // Hence, `curr` will not underflow.
838                         //
839                         // We can directly compare the packed value.
840                         // If the address is zero, packed will be zero.
841                         while (packed == 0) {
842                             packed = _packedOwnerships[--curr];
843                         }
844                         return packed;
845                     }
846                 }
847         }
848         revert OwnerQueryForNonexistentToken();
849     }
850 
851     /**
852      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
853      */
854     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
855         ownership.addr = address(uint160(packed));
856         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
857         ownership.burned = packed & _BITMASK_BURNED != 0;
858         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
859     }
860 
861     /**
862      * @dev Packs ownership data into a single uint256.
863      */
864     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
865         assembly {
866             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
867             owner := and(owner, _BITMASK_ADDRESS)
868             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
869             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
870         }
871     }
872 
873     /**
874      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
875      */
876     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
877         // For branchless setting of the `nextInitialized` flag.
878         assembly {
879             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
880             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
881         }
882     }
883 
884     // =============================================================
885     //                      APPROVAL OPERATIONS
886     // =============================================================
887 
888     /**
889      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
890      * The approval is cleared when the token is transferred.
891      *
892      * Only a single account can be approved at a time, so approving the
893      * zero address clears previous approvals.
894      *
895      * Requirements:
896      *
897      * - The caller must own the token or be an approved operator.
898      * - `tokenId` must exist.
899      *
900      * Emits an {Approval} event.
901      */
902     function approve(address to, uint256 tokenId) public virtual override {
903         address owner = ownerOf(tokenId);
904 
905         if (_msgSenderERC721A() != owner)
906             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
907                 revert ApprovalCallerNotOwnerNorApproved();
908             }
909 
910         _tokenApprovals[tokenId].value = to;
911         emit Approval(owner, to, tokenId);
912     }
913 
914     /**
915      * @dev Returns the account approved for `tokenId` token.
916      *
917      * Requirements:
918      *
919      * - `tokenId` must exist.
920      */
921     function getApproved(uint256 tokenId) public view virtual override returns (address) {
922         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
923 
924         return _tokenApprovals[tokenId].value;
925     }
926 
927     /**
928      * @dev Approve or remove `operator` as an operator for the caller.
929      * Operators can call {transferFrom} or {safeTransferFrom}
930      * for any token owned by the caller.
931      *
932      * Requirements:
933      *
934      * - The `operator` cannot be the caller.
935      *
936      * Emits an {ApprovalForAll} event.
937      */
938     function setApprovalForAll(address operator, bool approved) public virtual override {
939         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
940         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
941     }
942 
943     /**
944      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
945      *
946      * See {setApprovalForAll}.
947      */
948     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
949         return _operatorApprovals[owner][operator];
950     }
951 
952     /**
953      * @dev Returns whether `tokenId` exists.
954      *
955      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
956      *
957      * Tokens start existing when they are minted. See {_mint}.
958      */
959     function _exists(uint256 tokenId) internal view virtual returns (bool) {
960         return
961             _startTokenId() <= tokenId &&
962             tokenId < _currentIndex && // If within bounds,
963             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
964     }
965 
966     /**
967      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
968      */
969     function _isSenderApprovedOrOwner(
970         address approvedAddress,
971         address owner,
972         address msgSender
973     ) private pure returns (bool result) {
974         assembly {
975             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
976             owner := and(owner, _BITMASK_ADDRESS)
977             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
978             msgSender := and(msgSender, _BITMASK_ADDRESS)
979             // `msgSender == owner || msgSender == approvedAddress`.
980             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
981         }
982     }
983 
984     /**
985      * @dev Returns the storage slot and value for the approved address of `tokenId`.
986      */
987     function _getApprovedSlotAndAddress(uint256 tokenId)
988         private
989         view
990         returns (uint256 approvedAddressSlot, address approvedAddress)
991     {
992         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
993         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
994         assembly {
995             approvedAddressSlot := tokenApproval.slot
996             approvedAddress := sload(approvedAddressSlot)
997         }
998     }
999 
1000     // =============================================================
1001     //                      TRANSFER OPERATIONS
1002     // =============================================================
1003 
1004     /**
1005      * @dev Transfers `tokenId` from `from` to `to`.
1006      *
1007      * Requirements:
1008      *
1009      * - `from` cannot be the zero address.
1010      * - `to` cannot be the zero address.
1011      * - `tokenId` token must be owned by `from`.
1012      * - If the caller is not `from`, it must be approved to move this token
1013      * by either {approve} or {setApprovalForAll}.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function transferFrom(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) public virtual override {
1022         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1023 
1024         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1025 
1026         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1027 
1028         // The nested ifs save around 20+ gas over a compound boolean condition.
1029         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1030             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1031 
1032         if (to == address(0)) revert TransferToZeroAddress();
1033 
1034         _beforeTokenTransfers(from, to, tokenId, 1);
1035 
1036         // Clear approvals from the previous owner.
1037         assembly {
1038             if approvedAddress {
1039                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1040                 sstore(approvedAddressSlot, 0)
1041             }
1042         }
1043 
1044         // Underflow of the sender's balance is impossible because we check for
1045         // ownership above and the recipient's balance can't realistically overflow.
1046         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1047         unchecked {
1048             // We can directly increment and decrement the balances.
1049             --_packedAddressData[from]; // Updates: `balance -= 1`.
1050             ++_packedAddressData[to]; // Updates: `balance += 1`.
1051 
1052             // Updates:
1053             // - `address` to the next owner.
1054             // - `startTimestamp` to the timestamp of transfering.
1055             // - `burned` to `false`.
1056             // - `nextInitialized` to `true`.
1057             _packedOwnerships[tokenId] = _packOwnershipData(
1058                 to,
1059                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1060             );
1061 
1062             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1063             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1064                 uint256 nextTokenId = tokenId + 1;
1065                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1066                 if (_packedOwnerships[nextTokenId] == 0) {
1067                     // If the next slot is within bounds.
1068                     if (nextTokenId != _currentIndex) {
1069                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1070                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1071                     }
1072                 }
1073             }
1074         }
1075 
1076         emit Transfer(from, to, tokenId);
1077         _afterTokenTransfers(from, to, tokenId, 1);
1078     }
1079 
1080     /**
1081      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1082      */
1083     function safeTransferFrom(
1084         address from,
1085         address to,
1086         uint256 tokenId
1087     ) public virtual override {
1088         safeTransferFrom(from, to, tokenId, '');
1089     }
1090 
1091     /**
1092      * @dev Safely transfers `tokenId` token from `from` to `to`.
1093      *
1094      * Requirements:
1095      *
1096      * - `from` cannot be the zero address.
1097      * - `to` cannot be the zero address.
1098      * - `tokenId` token must exist and be owned by `from`.
1099      * - If the caller is not `from`, it must be approved to move this token
1100      * by either {approve} or {setApprovalForAll}.
1101      * - If `to` refers to a smart contract, it must implement
1102      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1103      *
1104      * Emits a {Transfer} event.
1105      */
1106     function safeTransferFrom(
1107         address from,
1108         address to,
1109         uint256 tokenId,
1110         bytes memory _data
1111     ) public virtual override {
1112         transferFrom(from, to, tokenId);
1113         if (to.code.length != 0)
1114             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1115                 revert TransferToNonERC721ReceiverImplementer();
1116             }
1117     }
1118 
1119     /**
1120      * @dev Hook that is called before a set of serially-ordered token IDs
1121      * are about to be transferred. This includes minting.
1122      * And also called before burning one token.
1123      *
1124      * `startTokenId` - the first token ID to be transferred.
1125      * `quantity` - the amount to be transferred.
1126      *
1127      * Calling conditions:
1128      *
1129      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1130      * transferred to `to`.
1131      * - When `from` is zero, `tokenId` will be minted for `to`.
1132      * - When `to` is zero, `tokenId` will be burned by `from`.
1133      * - `from` and `to` are never both zero.
1134      */
1135     function _beforeTokenTransfers(
1136         address from,
1137         address to,
1138         uint256 startTokenId,
1139         uint256 quantity
1140     ) internal virtual {}
1141 
1142     /**
1143      * @dev Hook that is called after a set of serially-ordered token IDs
1144      * have been transferred. This includes minting.
1145      * And also called after one token has been burned.
1146      *
1147      * `startTokenId` - the first token ID to be transferred.
1148      * `quantity` - the amount to be transferred.
1149      *
1150      * Calling conditions:
1151      *
1152      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1153      * transferred to `to`.
1154      * - When `from` is zero, `tokenId` has been minted for `to`.
1155      * - When `to` is zero, `tokenId` has been burned by `from`.
1156      * - `from` and `to` are never both zero.
1157      */
1158     function _afterTokenTransfers(
1159         address from,
1160         address to,
1161         uint256 startTokenId,
1162         uint256 quantity
1163     ) internal virtual {}
1164 
1165     /**
1166      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1167      *
1168      * `from` - Previous owner of the given token ID.
1169      * `to` - Target address that will receive the token.
1170      * `tokenId` - Token ID to be transferred.
1171      * `_data` - Optional data to send along with the call.
1172      *
1173      * Returns whether the call correctly returned the expected magic value.
1174      */
1175     function _checkContractOnERC721Received(
1176         address from,
1177         address to,
1178         uint256 tokenId,
1179         bytes memory _data
1180     ) private returns (bool) {
1181         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1182             bytes4 retval
1183         ) {
1184             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1185         } catch (bytes memory reason) {
1186             if (reason.length == 0) {
1187                 revert TransferToNonERC721ReceiverImplementer();
1188             } else {
1189                 assembly {
1190                     revert(add(32, reason), mload(reason))
1191                 }
1192             }
1193         }
1194     }
1195 
1196     // =============================================================
1197     //                        MINT OPERATIONS
1198     // =============================================================
1199 
1200     /**
1201      * @dev Mints `quantity` tokens and transfers them to `to`.
1202      *
1203      * Requirements:
1204      *
1205      * - `to` cannot be the zero address.
1206      * - `quantity` must be greater than 0.
1207      *
1208      * Emits a {Transfer} event for each mint.
1209      */
1210     function _mint(address to, uint256 quantity) internal virtual {
1211         uint256 startTokenId = _currentIndex;
1212         if (quantity == 0) revert MintZeroQuantity();
1213 
1214         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1215 
1216         // Overflows are incredibly unrealistic.
1217         // `balance` and `numberMinted` have a maximum limit of 2**64.
1218         // `tokenId` has a maximum limit of 2**256.
1219         unchecked {
1220             // Updates:
1221             // - `balance += quantity`.
1222             // - `numberMinted += quantity`.
1223             //
1224             // We can directly add to the `balance` and `numberMinted`.
1225             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1226 
1227             // Updates:
1228             // - `address` to the owner.
1229             // - `startTimestamp` to the timestamp of minting.
1230             // - `burned` to `false`.
1231             // - `nextInitialized` to `quantity == 1`.
1232             _packedOwnerships[startTokenId] = _packOwnershipData(
1233                 to,
1234                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1235             );
1236 
1237             uint256 toMasked;
1238             uint256 end = startTokenId + quantity;
1239 
1240             // Use assembly to loop and emit the `Transfer` event for gas savings.
1241             // The duplicated `log4` removes an extra check and reduces stack juggling.
1242             // The assembly, together with the surrounding Solidity code, have been
1243             // delicately arranged to nudge the compiler into producing optimized opcodes.
1244             assembly {
1245                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1246                 toMasked := and(to, _BITMASK_ADDRESS)
1247                 // Emit the `Transfer` event.
1248                 log4(
1249                     0, // Start of data (0, since no data).
1250                     0, // End of data (0, since no data).
1251                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1252                     0, // `address(0)`.
1253                     toMasked, // `to`.
1254                     startTokenId // `tokenId`.
1255                 )
1256 
1257                 for {
1258                     let tokenId := add(startTokenId, 1)
1259                 } iszero(eq(tokenId, end)) {
1260                     tokenId := add(tokenId, 1)
1261                 } {
1262                     // Emit the `Transfer` event. Similar to above.
1263                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1264                 }
1265             }
1266             if (toMasked == 0) revert MintToZeroAddress();
1267 
1268             _currentIndex = end;
1269         }
1270         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1271     }
1272 
1273     /**
1274      * @dev Mints `quantity` tokens and transfers them to `to`.
1275      *
1276      * This function is intended for efficient minting only during contract creation.
1277      *
1278      * It emits only one {ConsecutiveTransfer} as defined in
1279      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1280      * instead of a sequence of {Transfer} event(s).
1281      *
1282      * Calling this function outside of contract creation WILL make your contract
1283      * non-compliant with the ERC721 standard.
1284      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1285      * {ConsecutiveTransfer} event is only permissible during contract creation.
1286      *
1287      * Requirements:
1288      *
1289      * - `to` cannot be the zero address.
1290      * - `quantity` must be greater than 0.
1291      *
1292      * Emits a {ConsecutiveTransfer} event.
1293      */
1294     function _mintERC2309(address to, uint256 quantity) internal virtual {
1295         uint256 startTokenId = _currentIndex;
1296         if (to == address(0)) revert MintToZeroAddress();
1297         if (quantity == 0) revert MintZeroQuantity();
1298         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1299 
1300         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1301 
1302         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1303         unchecked {
1304             // Updates:
1305             // - `balance += quantity`.
1306             // - `numberMinted += quantity`.
1307             //
1308             // We can directly add to the `balance` and `numberMinted`.
1309             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1310 
1311             // Updates:
1312             // - `address` to the owner.
1313             // - `startTimestamp` to the timestamp of minting.
1314             // - `burned` to `false`.
1315             // - `nextInitialized` to `quantity == 1`.
1316             _packedOwnerships[startTokenId] = _packOwnershipData(
1317                 to,
1318                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1319             );
1320 
1321             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1322 
1323             _currentIndex = startTokenId + quantity;
1324         }
1325         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1326     }
1327 
1328     /**
1329      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1330      *
1331      * Requirements:
1332      *
1333      * - If `to` refers to a smart contract, it must implement
1334      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1335      * - `quantity` must be greater than 0.
1336      *
1337      * See {_mint}.
1338      *
1339      * Emits a {Transfer} event for each mint.
1340      */
1341     function _safeMint(
1342         address to,
1343         uint256 quantity,
1344         bytes memory _data
1345     ) internal virtual {
1346         _mint(to, quantity);
1347 
1348         unchecked {
1349             if (to.code.length != 0) {
1350                 uint256 end = _currentIndex;
1351                 uint256 index = end - quantity;
1352                 do {
1353                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1354                         revert TransferToNonERC721ReceiverImplementer();
1355                     }
1356                 } while (index < end);
1357                 // Reentrancy protection.
1358                 if (_currentIndex != end) revert();
1359             }
1360         }
1361     }
1362 
1363     /**
1364      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1365      */
1366     function _safeMint(address to, uint256 quantity) internal virtual {
1367         _safeMint(to, quantity, '');
1368     }
1369 
1370     // =============================================================
1371     //                        BURN OPERATIONS
1372     // =============================================================
1373 
1374     /**
1375      * @dev Equivalent to `_burn(tokenId, false)`.
1376      */
1377     function _burn(uint256 tokenId) internal virtual {
1378         _burn(tokenId, false);
1379     }
1380 
1381     /**
1382      * @dev Destroys `tokenId`.
1383      * The approval is cleared when the token is burned.
1384      *
1385      * Requirements:
1386      *
1387      * - `tokenId` must exist.
1388      *
1389      * Emits a {Transfer} event.
1390      */
1391     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1392         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1393 
1394         address from = address(uint160(prevOwnershipPacked));
1395 
1396         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1397 
1398         if (approvalCheck) {
1399             // The nested ifs save around 20+ gas over a compound boolean condition.
1400             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1401                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1402         }
1403 
1404         _beforeTokenTransfers(from, address(0), tokenId, 1);
1405 
1406         // Clear approvals from the previous owner.
1407         assembly {
1408             if approvedAddress {
1409                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1410                 sstore(approvedAddressSlot, 0)
1411             }
1412         }
1413 
1414         // Underflow of the sender's balance is impossible because we check for
1415         // ownership above and the recipient's balance can't realistically overflow.
1416         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1417         unchecked {
1418             // Updates:
1419             // - `balance -= 1`.
1420             // - `numberBurned += 1`.
1421             //
1422             // We can directly decrement the balance, and increment the number burned.
1423             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1424             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1425 
1426             // Updates:
1427             // - `address` to the last owner.
1428             // - `startTimestamp` to the timestamp of burning.
1429             // - `burned` to `true`.
1430             // - `nextInitialized` to `true`.
1431             _packedOwnerships[tokenId] = _packOwnershipData(
1432                 from,
1433                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1434             );
1435 
1436             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1437             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1438                 uint256 nextTokenId = tokenId + 1;
1439                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1440                 if (_packedOwnerships[nextTokenId] == 0) {
1441                     // If the next slot is within bounds.
1442                     if (nextTokenId != _currentIndex) {
1443                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1444                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1445                     }
1446                 }
1447             }
1448         }
1449 
1450         emit Transfer(from, address(0), tokenId);
1451         _afterTokenTransfers(from, address(0), tokenId, 1);
1452 
1453         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1454         unchecked {
1455             _burnCounter++;
1456         }
1457     }
1458 
1459     // =============================================================
1460     //                     EXTRA DATA OPERATIONS
1461     // =============================================================
1462 
1463     /**
1464      * @dev Directly sets the extra data for the ownership data `index`.
1465      */
1466     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1467         uint256 packed = _packedOwnerships[index];
1468         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1469         uint256 extraDataCasted;
1470         // Cast `extraData` with assembly to avoid redundant masking.
1471         assembly {
1472             extraDataCasted := extraData
1473         }
1474         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1475         _packedOwnerships[index] = packed;
1476     }
1477 
1478     /**
1479      * @dev Called during each token transfer to set the 24bit `extraData` field.
1480      * Intended to be overridden by the cosumer contract.
1481      *
1482      * `previousExtraData` - the value of `extraData` before transfer.
1483      *
1484      * Calling conditions:
1485      *
1486      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1487      * transferred to `to`.
1488      * - When `from` is zero, `tokenId` will be minted for `to`.
1489      * - When `to` is zero, `tokenId` will be burned by `from`.
1490      * - `from` and `to` are never both zero.
1491      */
1492     function _extraData(
1493         address from,
1494         address to,
1495         uint24 previousExtraData
1496     ) internal view virtual returns (uint24) {}
1497 
1498     /**
1499      * @dev Returns the next extra data for the packed ownership data.
1500      * The returned result is shifted into position.
1501      */
1502     function _nextExtraData(
1503         address from,
1504         address to,
1505         uint256 prevOwnershipPacked
1506     ) private view returns (uint256) {
1507         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1508         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1509     }
1510 
1511     // =============================================================
1512     //                       OTHER OPERATIONS
1513     // =============================================================
1514 
1515     /**
1516      * @dev Returns the message sender (defaults to `msg.sender`).
1517      *
1518      * If you are writing GSN compatible contracts, you need to override this function.
1519      */
1520     function _msgSenderERC721A() internal view virtual returns (address) {
1521         return msg.sender;
1522     }
1523 
1524     /**
1525      * @dev Converts a uint256 to its ASCII string decimal representation.
1526      */
1527     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1528         assembly {
1529             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1530             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aligned.
1531             // We will need 1 32-byte word to store the length,
1532             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1533             str := add(mload(0x40), 0x80)
1534             // Update the free memory pointer to allocate.
1535             mstore(0x40, str)
1536 
1537             // Cache the end of the memory to calculate the length later.
1538             let end := str
1539 
1540             // We write the string from rightmost digit to leftmost digit.
1541             // The following is essentially a do-while loop that also handles the zero case.
1542             // prettier-ignore
1543             for { let temp := value } 1 {} {
1544                 str := sub(str, 1)
1545                 // Write the character to the pointer.
1546                 // The ASCII index of the '0' character is 48.
1547                 mstore8(str, add(48, mod(temp, 10)))
1548                 // Keep dividing `temp` until zero.
1549                 temp := div(temp, 10)
1550                 // prettier-ignore
1551                 if iszero(temp) { break }
1552             }
1553 
1554             let length := sub(end, str)
1555             // Move the pointer 32 bytes leftwards to make room for the length.
1556             str := sub(str, 0x20)
1557             // Store the length.
1558             mstore(str, length)
1559         }
1560     }
1561 }
1562 
1563 // File: contracts/Pixelatedy00ts.sol
1564 
1565 
1566 pragma solidity ^0.8.9;
1567 
1568 
1569 
1570 
1571 contract Pixelatedy00ts is ERC721A, Ownable {
1572     uint16   public maxSupply             = 4444;
1573     uint16   public maxFreeSupply         = 1000;
1574     uint8    public maxPerTx              = 20;
1575     uint8    public maxFreePerWallet      = 1;
1576     uint256  public mintPrice             = 0.0033 ether;
1577     bool     public mintEnabled;
1578     string   public baseURI = "ipfs://bafybeiexno4fnzspzopyn7wmchqe7paiewxnw2tvsg5h7n7lj2coyjtbke/";
1579     mapping(address => uint256) public _mintedFreeAmount;
1580 
1581     using Strings for uint256;
1582 
1583     constructor() ERC721A("Pixelated y00ts", "PXLYTS"){}
1584 
1585     function _baseURI() internal view virtual override returns (string memory) {
1586         return baseURI;
1587     }
1588 
1589     function setBaseURI(string memory baseURI_) public onlyOwner {
1590         baseURI = baseURI_;
1591     }
1592 
1593     function _startTokenId() internal view virtual override returns (uint256) {
1594     return 1;
1595   }
1596 
1597     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1598     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1599 
1600     string memory currentBaseURI = _baseURI();
1601     return bytes(currentBaseURI).length > 0
1602         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
1603         : '';
1604   }
1605 
1606     function toggleMinting() external onlyOwner {
1607       mintEnabled = !mintEnabled;
1608     }
1609 
1610     function setPrice(uint256 _newMintPrice) public onlyOwner {
1611     mintPrice = _newMintPrice;
1612   }
1613 
1614     function setMaxSupply(uint16 _newMaxSupply) public onlyOwner {
1615         maxSupply = _newMaxSupply;
1616     }
1617 
1618     function withdraw() external payable onlyOwner {
1619         payable(owner()).transfer(address(this).balance);
1620     }
1621 
1622     function mint(uint8 quantity) external payable {
1623         bool isFree = ((totalSupply() + quantity < maxFreeSupply + 1) &&
1624             (_mintedFreeAmount[msg.sender] < maxFreePerWallet));
1625 
1626         if (isFree) { 
1627             require(mintEnabled, "Mint is not live yet");
1628             require(totalSupply() + quantity <= 4344, "Not enough tokens left");
1629             require(quantity <= maxPerTx, "Max per TX reached.");
1630             if(quantity >= (maxFreePerWallet - _mintedFreeAmount[msg.sender]))
1631             {
1632              require(msg.value >= (quantity * mintPrice) - ((maxFreePerWallet - _mintedFreeAmount[msg.sender]) * mintPrice), "Not enough ether sent");
1633              _mintedFreeAmount[msg.sender] = maxFreePerWallet;
1634             }
1635             else if(quantity < (maxFreePerWallet - _mintedFreeAmount[msg.sender]))
1636             {
1637              require(msg.value >= 0, "Not enough ether sent");
1638              _mintedFreeAmount[msg.sender] += quantity;
1639             }
1640         }
1641         else{
1642         require(mintEnabled, "Mint is not live yet");
1643         require(msg.value >= quantity * mintPrice, "Not enough ether sent");
1644         require(totalSupply() + quantity <= 4344, "Not enough tokens left");
1645         require(quantity <= maxPerTx, "Max per TX reached.");
1646         }
1647 
1648         _safeMint(msg.sender, quantity);
1649     }
1650     function mintForOwner(uint16 quantity) public onlyOwner {
1651         require(mintEnabled);
1652         require(totalSupply() + quantity <= maxSupply);
1653         _safeMint(msg.sender, quantity);
1654     }
1655 }