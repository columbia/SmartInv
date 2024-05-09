1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: @openzeppelin/contracts/utils/Strings.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev String operations.
122  */
123 library Strings {
124     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
125     uint8 private constant _ADDRESS_LENGTH = 20;
126 
127     /**
128      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
129      */
130     function toString(uint256 value) internal pure returns (string memory) {
131         // Inspired by OraclizeAPI's implementation - MIT licence
132         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
133 
134         if (value == 0) {
135             return "0";
136         }
137         uint256 temp = value;
138         uint256 digits;
139         while (temp != 0) {
140             digits++;
141             temp /= 10;
142         }
143         bytes memory buffer = new bytes(digits);
144         while (value != 0) {
145             digits -= 1;
146             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
147             value /= 10;
148         }
149         return string(buffer);
150     }
151 
152     /**
153      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
154      */
155     function toHexString(uint256 value) internal pure returns (string memory) {
156         if (value == 0) {
157             return "0x00";
158         }
159         uint256 temp = value;
160         uint256 length = 0;
161         while (temp != 0) {
162             length++;
163             temp >>= 8;
164         }
165         return toHexString(value, length);
166     }
167 
168     /**
169      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
170      */
171     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
172         bytes memory buffer = new bytes(2 * length + 2);
173         buffer[0] = "0";
174         buffer[1] = "x";
175         for (uint256 i = 2 * length + 1; i > 1; --i) {
176             buffer[i] = _HEX_SYMBOLS[value & 0xf];
177             value >>= 4;
178         }
179         require(value == 0, "Strings: hex length insufficient");
180         return string(buffer);
181     }
182 
183     /**
184      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
185      */
186     function toHexString(address addr) internal pure returns (string memory) {
187         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
188     }
189 }
190 
191 // File: contracts/IERC721A.sol
192 
193 
194 // ERC721A Contracts v4.2.2
195 // Creator: Chiru Labs
196 
197 // This file has been adapted by The Blinkless to support Passive Viral Minting
198 // www.theblinkless.com
199 
200 pragma solidity ^0.8.4;
201 
202 /**
203  * @dev Interface of ERC721A.
204  */
205 interface IERC721A {
206     /**
207      * The caller must own the token or be an approved operator.
208      */
209     error ApprovalCallerNotOwnerNorApproved();
210 
211     /**
212      * The token does not exist.
213      */
214     error ApprovalQueryForNonexistentToken();
215 
216     /**
217      * The caller cannot approve to their own address.
218      */
219     error ApproveToCaller();
220 
221     /**
222      * Cannot query the balance for the zero address.
223      */
224     error BalanceQueryForZeroAddress();
225 
226     /**
227      * Cannot mint to the zero address.
228      */
229     error MintToZeroAddress();
230 
231     /**
232      * The quantity of tokens minted must be more than zero.
233      */
234     error MintZeroQuantity();
235 
236     /**
237      * The token does not exist.
238      */
239     error OwnerQueryForNonexistentToken();
240 
241     /**
242      * The caller must own the token or be an approved operator.
243      */
244     error TransferCallerNotOwnerNorApproved();
245 
246     /**
247      * The token must be owned by `from`.
248      */
249     error TransferFromIncorrectOwner();
250 
251     /**
252      * Cannot safely transfer to a contract that does not implement the
253      * ERC721Receiver interface.
254      */
255     error TransferToNonERC721ReceiverImplementer();
256 
257     /**
258      * Cannot transfer to the zero address.
259      */
260     error TransferToZeroAddress();
261 
262     /**
263      * The token does not exist.
264      */
265     error URIQueryForNonexistentToken();
266 
267     /**
268      * The `quantity` minted with ERC2309 exceeds the safety limit.
269      */
270     error MintERC2309QuantityExceedsLimit();
271 
272     /**
273      * The `extraData` cannot be set on an unintialized ownership slot.
274      */
275     error OwnershipNotInitializedForExtraData();
276 
277     // =============================================================
278     //                            STRUCTS
279     // =============================================================
280 
281     struct TokenOwnership {
282         // The address of the owner.
283         address addr;
284         // Stores the start time of ownership with minimal overhead for tokenomics.
285         uint64 startTimestamp;
286         // Whether the token has been burned.
287         bool burned;
288         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
289         uint24 extraData;
290     }
291 
292     // =============================================================
293     //                         TOKEN COUNTERS
294     // =============================================================
295 
296     /**
297      * @dev Returns the total number of tokens in existence.
298      * Burned tokens will reduce the count.
299      * To get the total number of tokens minted, please see {_totalMinted}.
300      */
301     function totalSupply() external view returns (uint256);
302 
303     // =============================================================
304     //                            IERC165
305     // =============================================================
306 
307     /**
308      * @dev Returns true if this contract implements the interface defined by
309      * `interfaceId`. See the corresponding
310      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
311      * to learn more about how these ids are created.
312      *
313      * This function call must use less than 30000 gas.
314      */
315     function supportsInterface(bytes4 interfaceId) external view returns (bool);
316 
317     // =============================================================
318     //                            IERC721
319     // =============================================================
320 
321     /**
322      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
323      */
324     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
325 
326     /**
327      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
328      */
329     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
330 
331     /**
332      * @dev Emitted when `owner` enables or disables
333      * (`approved`) `operator` to manage all of its assets.
334      */
335     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
336 
337     /**
338      * @dev Returns the number of tokens in `owner`'s account.
339      */
340     function balanceOf(address owner) external view returns (uint256 balance);
341 
342     /**
343      * @dev Returns the owner of the `tokenId` token.
344      *
345      * Requirements:
346      *
347      * - `tokenId` must exist.
348      */
349     function ownerOf(uint256 tokenId) external view returns (address owner);
350 
351     /**
352      * @dev Safely transfers `tokenId` token from `from` to `to`,
353      * checking first that contract recipients are aware of the ERC721 protocol
354      * to prevent tokens from being forever locked.
355      *
356      * Requirements:
357      *
358      * - `from` cannot be the zero address.
359      * - `to` cannot be the zero address.
360      * - `tokenId` token must exist and be owned by `from`.
361      * - If the caller is not `from`, it must be have been allowed to move
362      * this token by either {approve} or {setApprovalForAll}.
363      * - If `to` refers to a smart contract, it must implement
364      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
365      *
366      * Emits a {Transfer} event.
367      */
368     function safeTransferFrom(
369         address from,
370         address to,
371         uint256 tokenId,
372         bytes calldata data
373     ) external;
374 
375     /**
376      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
377      */
378     function safeTransferFrom(
379         address from,
380         address to,
381         uint256 tokenId
382     ) external;
383 
384     /**
385      * @dev Transfers `tokenId` from `from` to `to`.
386      *
387      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
388      * whenever possible.
389      *
390      * Requirements:
391      *
392      * - `from` cannot be the zero address.
393      * - `to` cannot be the zero address.
394      * - `tokenId` token must be owned by `from`.
395      * - If the caller is not `from`, it must be approved to move this token
396      * by either {approve} or {setApprovalForAll}.
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
410      * Only a single account can be approved at a time, so approving the
411      * zero address clears previous approvals.
412      *
413      * Requirements:
414      *
415      * - The caller must own the token or be an approved operator.
416      * - `tokenId` must exist.
417      *
418      * Emits an {Approval} event.
419      */
420     function approve(address to, uint256 tokenId) external;
421 
422     /**
423      * @dev Approve or remove `operator` as an operator for the caller.
424      * Operators can call {transferFrom} or {safeTransferFrom}
425      * for any token owned by the caller.
426      *
427      * Requirements:
428      *
429      * - The `operator` cannot be the caller.
430      *
431      * Emits an {ApprovalForAll} event.
432      */
433     function setApprovalForAll(address operator, bool _approved) external;
434 
435     /**
436      * @dev Returns the account approved for `tokenId` token.
437      *
438      * Requirements:
439      *
440      * - `tokenId` must exist.
441      */
442     function getApproved(uint256 tokenId) external view returns (address operator);
443 
444     /**
445      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
446      *
447      * See {setApprovalForAll}.
448      */
449     function isApprovedForAll(address owner, address operator) external view returns (bool);
450 
451     // =============================================================
452     //                        IERC721Metadata
453     // =============================================================
454 
455     /**
456      * @dev Returns the token collection name.
457      */
458     function name() external view returns (string memory);
459 
460     /**
461      * @dev Returns the token collection symbol.
462      */
463     function symbol() external view returns (string memory);
464 
465     /**
466      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
467      */
468     function tokenURI(uint256 tokenId) external view returns (string memory);
469 
470     // =============================================================
471     //                           IERC2309
472     // =============================================================
473 
474     /**
475      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
476      * (inclusive) is transferred from `from` to `to`, as defined in the
477      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
478      *
479      * See {_mintERC2309} for more details.
480      */
481     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
482 }
483 // File: contracts/ERC721A.sol
484 
485 
486 // ERC721A Contracts v4.2.2
487 // Creator: Chiru Labs
488 
489 // This file has been adapted by The Blinkless to support Passive Viral Minting
490 // www.theblinkless.com
491 
492 pragma solidity ^0.8.4;
493 
494 
495 /**
496  * @dev Interface of ERC721 token receiver.
497  */
498 interface ERC721A__IERC721Receiver {
499     function onERC721Received(
500         address operator,
501         address from,
502         uint256 tokenId,
503         bytes calldata data
504     ) external returns (bytes4);
505 }
506 
507 /**
508  * @title ERC721A
509  *
510  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
511  * Non-Fungible Token Standard, including the Metadata extension.
512  * Optimized for lower gas during batch mints.
513  *
514  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
515  * starting from `_startTokenId()`.
516  *
517  * Assumptions:
518  *
519  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
520  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
521  */
522 contract ERC721A is IERC721A {
523     // Reference type for token approval.
524     struct TokenApprovalRef {
525         address value;
526     }
527 
528     // =============================================================
529     //                           CONSTANTS
530     // =============================================================
531 
532     // Mask of an entry in packed address data.
533     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
534 
535     // The bit position of `numberMinted` in packed address data.
536     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
537 
538     // The bit position of `numberBurned` in packed address data.
539     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
540 
541     // The bit position of `aux` in packed address data.
542     uint256 private constant _BITPOS_AUX = 192;
543 
544     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
545     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
546 
547     // The bit position of `startTimestamp` in packed ownership.
548     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
549 
550     // The bit mask of the `burned` bit in packed ownership.
551     uint256 private constant _BITMASK_BURNED = 1 << 224;
552 
553     // The bit position of the `nextInitialized` bit in packed ownership.
554     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
555 
556     // The bit mask of the `nextInitialized` bit in packed ownership.
557     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
558 
559     // The bit position of `extraData` in packed ownership.
560     uint256 private constant _BITPOS_EXTRA_DATA = 232;
561 
562     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
563     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
564 
565     // The mask of the lower 160 bits for addresses.
566     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
567 
568     // The maximum `quantity` that can be minted with {_mintERC2309}.
569     // This limit is to prevent overflows on the address data entries.
570     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
571     // is required to cause an overflow, which is unrealistic.
572     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
573 
574     // The `Transfer` event signature is given by:
575     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
576     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
577         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
578 
579     // =============================================================
580     //                            STORAGE
581     // =============================================================
582 
583     // The next token ID to be minted.
584     uint256 private _currentIndex;
585 
586     // The number of tokens burned.
587     uint256 private _burnCounter;
588 
589     // Token name
590     string private _name;
591 
592     // Token symbol
593     string private _symbol;
594 
595     string public metadataPath;
596 
597     // Mapping from token ID to ownership details
598     // An empty struct value does not necessarily mean the token is unowned.
599     // See {_packedOwnershipOf} implementation for details.
600     //
601     // Bits Layout:
602     // - [0..159]   `addr`
603     // - [160..223] `startTimestamp`
604     // - [224]      `burned`
605     // - [225]      `nextInitialized`
606     // - [232..255] `extraData`
607     mapping(uint256 => uint256) private _packedOwnerships;
608 
609     // Mapping owner address to address data.
610     //
611     // Bits Layout:
612     // - [0..63]    `balance`
613     // - [64..127]  `numberMinted`
614     // - [128..191] `numberBurned`
615     // - [192..255] `aux`
616     mapping(address => uint256) private _packedAddressData;
617 
618     // Mapping from token ID to approved address.
619     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
620 
621     // Mapping from owner to operator approvals
622     mapping(address => mapping(address => bool)) private _operatorApprovals;
623 
624     // =============================================================
625     //                          CONSTRUCTOR
626     // =============================================================
627 
628     constructor(string memory name_, string memory symbol_) {
629         _name = name_;
630         _symbol = symbol_;
631         _currentIndex = _startTokenId();
632     }
633 
634     // =============================================================
635     //                   TOKEN COUNTING OPERATIONS
636     // =============================================================
637 
638     /**
639      * @dev Returns the starting token ID.
640      * To change the starting token ID, please override this function.
641      */
642     function _startTokenId() internal view virtual returns (uint256) {
643         return 0;
644     }
645 
646     /**
647      * @dev Returns the next token ID to be minted.
648      */
649     function _nextTokenId() internal view virtual returns (uint256) {
650         return _currentIndex;
651     }
652 
653     /**
654      * @dev Returns the total number of tokens in existence.
655      * Burned tokens will reduce the count.
656      * To get the total number of tokens minted, please see {_totalMinted}.
657      */
658     function totalSupply() public view virtual override returns (uint256) {
659         // Counter underflow is impossible as _burnCounter cannot be incremented
660         // more than `_currentIndex - _startTokenId()` times.
661         unchecked {
662             return _currentIndex - _burnCounter - _startTokenId();
663         }
664     }
665 
666     /**
667      * @dev Returns the total amount of tokens minted in the contract.
668      */
669     function _totalMinted() internal view virtual returns (uint256) {
670         // Counter underflow is impossible as `_currentIndex` does not decrement,
671         // and it is initialized to `_startTokenId()`.
672         unchecked {
673             return _currentIndex - _startTokenId();
674         }
675     }
676 
677     /**
678      * @dev Returns the total number of tokens burned.
679      */
680     function _totalBurned() internal view virtual returns (uint256) {
681         return _burnCounter;
682     }
683 
684     // =============================================================
685     //                    ADDRESS DATA OPERATIONS
686     // =============================================================
687 
688     /**
689      * @dev Returns the number of tokens in `owner`'s account.
690      */
691     function balanceOf(address owner) public view virtual override returns (uint256) {
692         if (owner == address(0)) revert BalanceQueryForZeroAddress();
693         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
694     }
695 
696     /**
697      * Returns the number of tokens minted by `owner`.
698      */
699     function _numberMinted(address owner) internal view returns (uint256) {
700         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
701     }
702 
703     /**
704      * Returns the number of tokens burned by or on behalf of `owner`.
705      */
706     function _numberBurned(address owner) internal view returns (uint256) {
707         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
708     }
709 
710     /**
711      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
712      */
713     function _getAux(address owner) internal view returns (uint64) {
714         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
715     }
716 
717     /**
718      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
719      * If there are multiple variables, please pack them into a uint64.
720      */
721     function _setAux(address owner, uint64 aux) internal virtual {
722         uint256 packed = _packedAddressData[owner];
723         uint256 auxCasted;
724         // Cast `aux` with assembly to avoid redundant masking.
725         assembly {
726             auxCasted := aux
727         }
728         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
729         _packedAddressData[owner] = packed;
730     }
731 
732     // =============================================================
733     //                            IERC165
734     // =============================================================
735 
736     /**
737      * @dev Returns true if this contract implements the interface defined by
738      * `interfaceId`. See the corresponding
739      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
740      * to learn more about how these ids are created.
741      *
742      * This function call must use less than 30000 gas.
743      */
744     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
745         // The interface IDs are constants representing the first 4 bytes
746         // of the XOR of all function selectors in the interface.
747         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
748         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
749         return
750             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
751             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
752             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
753     }
754 
755     // =============================================================
756     //                        IERC721Metadata
757     // =============================================================
758 
759     /**
760      * @dev Returns the token collection name.
761      */
762     function name() public view virtual override returns (string memory) {
763         return _name;
764     }
765 
766     /**
767      * @dev Returns the token collection symbol.
768      */
769     function symbol() public view virtual override returns (string memory) {
770         return _symbol;
771     }
772 
773      /**
774      * @dev See {IERC721Metadata-tokenURI}.
775      */
776     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
777         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
778 
779         string memory baseURI = _baseURI();
780         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, Strings.toString(tokenId),'.json')) : '';
781     }
782 
783     /**
784      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
785      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
786      * by default, can be overriden in child contracts.
787      */
788     function _baseURI() internal view virtual returns (string memory) {
789         return metadataPath;
790     }
791 
792     // =============================================================
793     //                     OWNERSHIPS OPERATIONS
794     // =============================================================
795 
796     /**
797      * @dev Returns the owner of the `tokenId` token.
798      *
799      * Requirements:
800      *
801      * - `tokenId` must exist.
802      */
803     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
804         return address(uint160(_packedOwnershipOf(tokenId)));
805     }
806 
807     /**
808      * @dev Gas spent here starts off proportional to the maximum mint batch size.
809      * It gradually moves to O(1) as tokens get transferred around over time.
810      */
811     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
812         return _unpackedOwnership(_packedOwnershipOf(tokenId));
813     }
814 
815     /**
816      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
817      */
818     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
819         return _unpackedOwnership(_packedOwnerships[index]);
820     }
821 
822     /**
823      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
824      */
825     function _initializeOwnershipAt(uint256 index) internal virtual {
826         if (_packedOwnerships[index] == 0) {
827             _packedOwnerships[index] = _packedOwnershipOf(index);
828         }
829     }
830 
831     /**
832      * Returns the packed ownership data of `tokenId`.
833      */
834     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
835         uint256 curr = tokenId;
836 
837         unchecked {
838             if (_startTokenId() <= curr)
839                 if (curr < _currentIndex) {
840                     uint256 packed = _packedOwnerships[curr];
841                     // If not burned.
842                     if (packed & _BITMASK_BURNED == 0) {
843                         // Invariant:
844                         // There will always be an initialized ownership slot
845                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
846                         // before an unintialized ownership slot
847                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
848                         // Hence, `curr` will not underflow.
849                         //
850                         // We can directly compare the packed value.
851                         // If the address is zero, packed will be zero.
852                         while (packed == 0) {
853                             packed = _packedOwnerships[--curr];
854                         }
855                         return packed;
856                     }
857                 }
858         }
859         revert OwnerQueryForNonexistentToken();
860     }
861 
862     /**
863      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
864      */
865     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
866         ownership.addr = address(uint160(packed));
867         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
868         ownership.burned = packed & _BITMASK_BURNED != 0;
869         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
870     }
871 
872     /**
873      * @dev Packs ownership data into a single uint256.
874      */
875     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
876         assembly {
877             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
878             owner := and(owner, _BITMASK_ADDRESS)
879             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
880             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
881         }
882     }
883 
884     /**
885      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
886      */
887     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
888         // For branchless setting of the `nextInitialized` flag.
889         assembly {
890             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
891             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
892         }
893     }
894 
895     // =============================================================
896     //                      APPROVAL OPERATIONS
897     // =============================================================
898 
899     /**
900      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
901      * The approval is cleared when the token is transferred.
902      *
903      * Only a single account can be approved at a time, so approving the
904      * zero address clears previous approvals.
905      *
906      * Requirements:
907      *
908      * - The caller must own the token or be an approved operator.
909      * - `tokenId` must exist.
910      *
911      * Emits an {Approval} event.
912      */
913     function approve(address to, uint256 tokenId) public virtual override {
914         address owner = ownerOf(tokenId);
915 
916         if (_msgSenderERC721A() != owner)
917             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
918                 revert ApprovalCallerNotOwnerNorApproved();
919             }
920 
921         _tokenApprovals[tokenId].value = to;
922         emit Approval(owner, to, tokenId);
923     }
924 
925     /**
926      * @dev Returns the account approved for `tokenId` token.
927      *
928      * Requirements:
929      *
930      * - `tokenId` must exist.
931      */
932     function getApproved(uint256 tokenId) public view virtual override returns (address) {
933         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
934 
935         return _tokenApprovals[tokenId].value;
936     }
937 
938     /**
939      * @dev Approve or remove `operator` as an operator for the caller.
940      * Operators can call {transferFrom} or {safeTransferFrom}
941      * for any token owned by the caller.
942      *
943      * Requirements:
944      *
945      * - The `operator` cannot be the caller.
946      *
947      * Emits an {ApprovalForAll} event.
948      */
949     function setApprovalForAll(address operator, bool approved) public virtual override {
950         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
951 
952         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
953         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
954     }
955 
956     /**
957      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
958      *
959      * See {setApprovalForAll}.
960      */
961     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
962         return _operatorApprovals[owner][operator];
963     }
964 
965     /**
966      * @dev Returns whether `tokenId` exists.
967      *
968      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
969      *
970      * Tokens start existing when they are minted. See {_mint}.
971      */
972     function _exists(uint256 tokenId) internal view virtual returns (bool) {
973         return
974             _startTokenId() <= tokenId &&
975             tokenId < _currentIndex && // If within bounds,
976             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
977     }
978 
979     /**
980      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
981      */
982     function _isSenderApprovedOrOwner(
983         address approvedAddress,
984         address owner,
985         address msgSender
986     ) private pure returns (bool result) {
987         assembly {
988             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
989             owner := and(owner, _BITMASK_ADDRESS)
990             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
991             msgSender := and(msgSender, _BITMASK_ADDRESS)
992             // `msgSender == owner || msgSender == approvedAddress`.
993             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
994         }
995     }
996 
997     /**
998      * @dev Returns the storage slot and value for the approved address of `tokenId`.
999      */
1000     function _getApprovedSlotAndAddress(uint256 tokenId)
1001         private
1002         view
1003         returns (uint256 approvedAddressSlot, address approvedAddress)
1004     {
1005         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1006         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1007         assembly {
1008             approvedAddressSlot := tokenApproval.slot
1009             approvedAddress := sload(approvedAddressSlot)
1010         }
1011     }
1012 
1013     // =============================================================
1014     //                      TRANSFER OPERATIONS
1015     // =============================================================
1016 
1017     /**
1018      * @dev Transfers `tokenId` from `from` to `to`.
1019      *
1020      * Requirements:
1021      *
1022      * - `from` cannot be the zero address.
1023      * - `to` cannot be the zero address.
1024      * - `tokenId` token must be owned by `from`.
1025      * - If the caller is not `from`, it must be approved to move this token
1026      * by either {approve} or {setApprovalForAll}.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function transferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) public virtual override {
1035         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1036 
1037         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1038 
1039         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1040 
1041         // The nested ifs save around 20+ gas over a compound boolean condition.
1042         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1043             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1044 
1045         if (to == address(0)) revert TransferToZeroAddress();
1046 
1047         _beforeTokenTransfers(from, to, tokenId, 1);
1048 
1049         // Clear approvals from the previous owner.
1050         assembly {
1051             if approvedAddress {
1052                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1053                 sstore(approvedAddressSlot, 0)
1054             }
1055         }
1056 
1057         // Underflow of the sender's balance is impossible because we check for
1058         // ownership above and the recipient's balance can't realistically overflow.
1059         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1060         unchecked {
1061             // We can directly increment and decrement the balances.
1062             --_packedAddressData[from]; // Updates: `balance -= 1`.
1063             ++_packedAddressData[to]; // Updates: `balance += 1`.
1064 
1065             // Updates:
1066             // - `address` to the next owner.
1067             // - `startTimestamp` to the timestamp of transfering.
1068             // - `burned` to `false`.
1069             // - `nextInitialized` to `true`.
1070             _packedOwnerships[tokenId] = _packOwnershipData(
1071                 to,
1072                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1073             );
1074 
1075             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1076             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1077                 uint256 nextTokenId = tokenId + 1;
1078                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1079                 if (_packedOwnerships[nextTokenId] == 0) {
1080                     // If the next slot is within bounds.
1081                     if (nextTokenId != _currentIndex) {
1082                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1083                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1084                     }
1085                 }
1086             }
1087         }
1088 
1089 
1090         emit Transfer(from, to, tokenId);
1091         _afterTokenTransfers(from, to, tokenId, 1);
1092     }
1093 
1094     /**
1095      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1096      */
1097     function safeTransferFrom(
1098         address from,
1099         address to,
1100         uint256 tokenId
1101     ) public virtual override {
1102         safeTransferFrom(from, to, tokenId, '');
1103     }
1104 
1105     /**
1106      * @dev Safely transfers `tokenId` token from `from` to `to`.
1107      *
1108      * Requirements:
1109      *
1110      * - `from` cannot be the zero address.
1111      * - `to` cannot be the zero address.
1112      * - `tokenId` token must exist and be owned by `from`.
1113      * - If the caller is not `from`, it must be approved to move this token
1114      * by either {approve} or {setApprovalForAll}.
1115      * - If `to` refers to a smart contract, it must implement
1116      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1117      *
1118      * Emits a {Transfer} event.
1119      */
1120     function safeTransferFrom(
1121         address from,
1122         address to,
1123         uint256 tokenId,
1124         bytes memory _data
1125     ) public virtual override {
1126         transferFrom(from, to, tokenId);
1127         if (to.code.length != 0)
1128             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1129                 revert TransferToNonERC721ReceiverImplementer();
1130             }
1131     }
1132 
1133     /**
1134      * @dev Hook that is called before a set of serially-ordered token IDs
1135      * are about to be transferred. This includes minting.
1136      * And also called before burning one token.
1137      *
1138      * `startTokenId` - the first token ID to be transferred.
1139      * `quantity` - the amount to be transferred.
1140      *
1141      * Calling conditions:
1142      *
1143      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1144      * transferred to `to`.
1145      * - When `from` is zero, `tokenId` will be minted for `to`.
1146      * - When `to` is zero, `tokenId` will be burned by `from`.
1147      * - `from` and `to` are never both zero.
1148      */
1149     function _beforeTokenTransfers(
1150         address from,
1151         address to,
1152         uint256 startTokenId,
1153         uint256 quantity
1154     ) internal virtual {}
1155 
1156     /**
1157      * @dev Hook that is called after a set of serially-ordered token IDs
1158      * have been transferred. This includes minting.
1159      * And also called after one token has been burned.
1160      *
1161      * `startTokenId` - the first token ID to be transferred.
1162      * `quantity` - the amount to be transferred.
1163      *
1164      * Calling conditions:
1165      *
1166      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1167      * transferred to `to`.
1168      * - When `from` is zero, `tokenId` has been minted for `to`.
1169      * - When `to` is zero, `tokenId` has been burned by `from`.
1170      * - `from` and `to` are never both zero.
1171      */
1172     function _afterTokenTransfers(
1173         address from,
1174         address to,
1175         uint256 startTokenId,
1176         uint256 quantity
1177     ) internal virtual {}
1178 
1179     /**
1180      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1181      *
1182      * `from` - Previous owner of the given token ID.
1183      * `to` - Target address that will receive the token.
1184      * `tokenId` - Token ID to be transferred.
1185      * `_data` - Optional data to send along with the call.
1186      *
1187      * Returns whether the call correctly returned the expected magic value.
1188      */
1189     function _checkContractOnERC721Received(
1190         address from,
1191         address to,
1192         uint256 tokenId,
1193         bytes memory _data
1194     ) private returns (bool) {
1195         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1196             bytes4 retval
1197         ) {
1198             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1199         } catch (bytes memory reason) {
1200             if (reason.length == 0) {
1201                 revert TransferToNonERC721ReceiverImplementer();
1202             } else {
1203                 assembly {
1204                     revert(add(32, reason), mload(reason))
1205                 }
1206             }
1207         }
1208     }
1209 
1210     // =============================================================
1211     //                        MINT OPERATIONS
1212     // =============================================================
1213 
1214     /**
1215      * @dev Mints `quantity` tokens and transfers them to `to`.
1216      *
1217      * Requirements:
1218      *
1219      * - `to` cannot be the zero address.
1220      * - `quantity` must be greater than 0.
1221      *
1222      * Emits a {Transfer} event for each mint.
1223      */
1224     function _mint(address to, uint256 quantity) internal virtual {
1225         uint256 startTokenId = _currentIndex;
1226         if (quantity == 0) revert MintZeroQuantity();
1227 
1228         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1229 
1230         // Overflows are incredibly unrealistic.
1231         // `balance` and `numberMinted` have a maximum limit of 2**64.
1232         // `tokenId` has a maximum limit of 2**256.
1233         unchecked {
1234             // Updates:
1235             // - `balance += quantity`.
1236             // - `numberMinted += quantity`.
1237             //
1238             // We can directly add to the `balance` and `numberMinted`.
1239             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1240 
1241             // Updates:
1242             // - `address` to the owner.
1243             // - `startTimestamp` to the timestamp of minting.
1244             // - `burned` to `false`.
1245             // - `nextInitialized` to `quantity == 1`.
1246             _packedOwnerships[startTokenId] = _packOwnershipData(
1247                 to,
1248                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1249             );
1250 
1251             uint256 toMasked;
1252             uint256 end = startTokenId + quantity;
1253 
1254             // Use assembly to loop and emit the `Transfer` event for gas savings.
1255             // The duplicated `log4` removes an extra check and reduces stack juggling.
1256             // The assembly, together with the surrounding Solidity code, have been
1257             // delicately arranged to nudge the compiler into producing optimized opcodes.
1258             assembly {
1259                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1260                 toMasked := and(to, _BITMASK_ADDRESS)
1261                 // Emit the `Transfer` event.
1262                 log4(
1263                     0, // Start of data (0, since no data).
1264                     0, // End of data (0, since no data).
1265                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1266                     0, // `address(0)`.
1267                     toMasked, // `to`.
1268                     startTokenId // `tokenId`.
1269                 )
1270 
1271                 for {
1272                     let tokenId := add(startTokenId, 1)
1273                 } iszero(eq(tokenId, end)) {
1274                     tokenId := add(tokenId, 1)
1275                 } {
1276                     // Emit the `Transfer` event. Similar to above.
1277                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1278                 }
1279             }
1280             if (toMasked == 0) revert MintToZeroAddress();
1281 
1282             _currentIndex = end;
1283         }
1284         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1285     }
1286 
1287     /**
1288      * @dev Mints `quantity` tokens and transfers them to `to`.
1289      *
1290      * This function is intended for efficient minting only during contract creation.
1291      *
1292      * It emits only one {ConsecutiveTransfer} as defined in
1293      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1294      * instead of a sequence of {Transfer} event(s).
1295      *
1296      * Calling this function outside of contract creation WILL make your contract
1297      * non-compliant with the ERC721 standard.
1298      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1299      * {ConsecutiveTransfer} event is only permissible during contract creation.
1300      *
1301      * Requirements:
1302      *
1303      * - `to` cannot be the zero address.
1304      * - `quantity` must be greater than 0.
1305      *
1306      * Emits a {ConsecutiveTransfer} event.
1307      */
1308     function _mintERC2309(address to, uint256 quantity) internal virtual {
1309         uint256 startTokenId = _currentIndex;
1310         if (to == address(0)) revert MintToZeroAddress();
1311         if (quantity == 0) revert MintZeroQuantity();
1312         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1313 
1314         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1315 
1316         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1317         unchecked {
1318             // Updates:
1319             // - `balance += quantity`.
1320             // - `numberMinted += quantity`.
1321             //
1322             // We can directly add to the `balance` and `numberMinted`.
1323             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1324 
1325             // Updates:
1326             // - `address` to the owner.
1327             // - `startTimestamp` to the timestamp of minting.
1328             // - `burned` to `false`.
1329             // - `nextInitialized` to `quantity == 1`.
1330             _packedOwnerships[startTokenId] = _packOwnershipData(
1331                 to,
1332                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1333             );
1334 
1335             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1336 
1337             _currentIndex = startTokenId + quantity;
1338         }
1339         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1340     }
1341 
1342     /**
1343      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1344      *
1345      * Requirements:
1346      *
1347      * - If `to` refers to a smart contract, it must implement
1348      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1349      * - `quantity` must be greater than 0.
1350      *
1351      * See {_mint}.
1352      *
1353      * Emits a {Transfer} event for each mint.
1354      */
1355     function _safeMint(
1356         address to,
1357         uint256 quantity,
1358         bytes memory _data
1359     ) internal virtual {
1360         _mint(to, quantity);
1361 
1362         unchecked {
1363             if (to.code.length != 0) {
1364                 uint256 end = _currentIndex;
1365                 uint256 index = end - quantity;
1366                 do {
1367                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1368                         revert TransferToNonERC721ReceiverImplementer();
1369                     }
1370                 } while (index < end);
1371                 // Reentrancy protection.
1372                 if (_currentIndex != end) revert();
1373             }
1374         }
1375     }
1376 
1377     /**
1378      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1379      */
1380     function _safeMint(address to, uint256 quantity) internal virtual {
1381         _safeMint(to, quantity, '');
1382     }
1383 
1384     // =============================================================
1385     //                        BURN OPERATIONS
1386     // =============================================================
1387 
1388     /**
1389      * @dev Equivalent to `_burn(tokenId, false)`.
1390      */
1391     function _burn(uint256 tokenId) internal virtual {
1392         _burn(tokenId, false);
1393     }
1394 
1395     /**
1396      * @dev Destroys `tokenId`.
1397      * The approval is cleared when the token is burned.
1398      *
1399      * Requirements:
1400      *
1401      * - `tokenId` must exist.
1402      *
1403      * Emits a {Transfer} event.
1404      */
1405     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1406         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1407 
1408         address from = address(uint160(prevOwnershipPacked));
1409 
1410         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1411 
1412         if (approvalCheck) {
1413             // The nested ifs save around 20+ gas over a compound boolean condition.
1414             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1415                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1416         }
1417 
1418         _beforeTokenTransfers(from, address(0), tokenId, 1);
1419 
1420         // Clear approvals from the previous owner.
1421         assembly {
1422             if approvedAddress {
1423                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1424                 sstore(approvedAddressSlot, 0)
1425             }
1426         }
1427 
1428         // Underflow of the sender's balance is impossible because we check for
1429         // ownership above and the recipient's balance can't realistically overflow.
1430         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1431         unchecked {
1432             // Updates:
1433             // - `balance -= 1`.
1434             // - `numberBurned += 1`.
1435             //
1436             // We can directly decrement the balance, and increment the number burned.
1437             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1438             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1439 
1440             // Updates:
1441             // - `address` to the last owner.
1442             // - `startTimestamp` to the timestamp of burning.
1443             // - `burned` to `true`.
1444             // - `nextInitialized` to `true`.
1445             _packedOwnerships[tokenId] = _packOwnershipData(
1446                 from,
1447                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1448             );
1449 
1450             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1451             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1452                 uint256 nextTokenId = tokenId + 1;
1453                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1454                 if (_packedOwnerships[nextTokenId] == 0) {
1455                     // If the next slot is within bounds.
1456                     if (nextTokenId != _currentIndex) {
1457                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1458                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1459                     }
1460                 }
1461             }
1462         }
1463 
1464         emit Transfer(from, address(0), tokenId);
1465         _afterTokenTransfers(from, address(0), tokenId, 1);
1466 
1467         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1468         unchecked {
1469             _burnCounter++;
1470         }
1471     }
1472 
1473     // =============================================================
1474     //                     EXTRA DATA OPERATIONS
1475     // =============================================================
1476 
1477     /**
1478      * @dev Directly sets the extra data for the ownership data `index`.
1479      */
1480     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1481         uint256 packed = _packedOwnerships[index];
1482         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1483         uint256 extraDataCasted;
1484         // Cast `extraData` with assembly to avoid redundant masking.
1485         assembly {
1486             extraDataCasted := extraData
1487         }
1488         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1489         _packedOwnerships[index] = packed;
1490     }
1491 
1492     /**
1493      * @dev Called during each token transfer to set the 24bit `extraData` field.
1494      * Intended to be overridden by the cosumer contract.
1495      *
1496      * `previousExtraData` - the value of `extraData` before transfer.
1497      *
1498      * Calling conditions:
1499      *
1500      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1501      * transferred to `to`.
1502      * - When `from` is zero, `tokenId` will be minted for `to`.
1503      * - When `to` is zero, `tokenId` will be burned by `from`.
1504      * - `from` and `to` are never both zero.
1505      */
1506     function _extraData(
1507         address from,
1508         address to,
1509         uint24 previousExtraData
1510     ) internal view virtual returns (uint24) {}
1511 
1512     /**
1513      * @dev Returns the next extra data for the packed ownership data.
1514      * The returned result is shifted into position.
1515      */
1516     function _nextExtraData(
1517         address from,
1518         address to,
1519         uint256 prevOwnershipPacked
1520     ) private view returns (uint256) {
1521         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1522         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1523     }
1524 
1525     // =============================================================
1526     //                       OTHER OPERATIONS
1527     // =============================================================
1528 
1529     /**
1530      * @dev Returns the message sender (defaults to `msg.sender`).
1531      *
1532      * If you are writing GSN compatible contracts, you need to override this function.
1533      */
1534     function _msgSenderERC721A() internal view virtual returns (address) {
1535         return msg.sender;
1536     }
1537 
1538     /**
1539      * @dev Converts a uint256 to its ASCII string decimal representation.
1540      */
1541     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1542         assembly {
1543             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1544             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aligned.
1545             // We will need 1 32-byte word to store the length,
1546             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1547             str := add(mload(0x40), 0x80)
1548             // Update the free memory pointer to allocate.
1549             mstore(0x40, str)
1550 
1551             // Cache the end of the memory to calculate the length later.
1552             let end := str
1553 
1554             // We write the string from rightmost digit to leftmost digit.
1555             // The following is essentially a do-while loop that also handles the zero case.
1556             // prettier-ignore
1557             for { let temp := value } 1 {} {
1558                 str := sub(str, 1)
1559                 // Write the character to the pointer.
1560                 // The ASCII index of the '0' character is 48.
1561                 mstore8(str, add(48, mod(temp, 10)))
1562                 // Keep dividing `temp` until zero.
1563                 temp := div(temp, 10)
1564                 // prettier-ignore
1565                 if iszero(temp) { break }
1566             }
1567 
1568             let length := sub(end, str)
1569             // Move the pointer 32 bytes leftwards to make room for the length.
1570             str := sub(str, 0x20)
1571             // Store the length.
1572             mstore(str, length)
1573         }
1574     }
1575 }
1576 // File: contracts/IERC721ABurnable.sol
1577 
1578 
1579 // ERC721A Contracts v4.2.2
1580 // Creator: Chiru Labs
1581 
1582 pragma solidity ^0.8.4;
1583 
1584 
1585 /**
1586  * @dev Interface of ERC721ABurnable.
1587  */
1588 interface IERC721ABurnable is IERC721A {
1589     /**
1590      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1591      *
1592      * Requirements:
1593      *
1594      * - The caller must own `tokenId` or be an approved operator.
1595      */
1596     function burn(uint256 tokenId) external;
1597 }
1598 // File: contracts/ERC721ABurnable.sol
1599 
1600 
1601 // ERC721A Contracts v4.2.2
1602 // Creator: Chiru Labs
1603 
1604 pragma solidity ^0.8.4;
1605 
1606 
1607 
1608 /**
1609  * @title ERC721ABurnable.
1610  *
1611  * @dev ERC721A token that can be irreversibly burned (destroyed).
1612  */
1613 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1614     /**
1615      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1616      *
1617      * Requirements:
1618      *
1619      * - The caller must own `tokenId` or be an approved operator.
1620      */
1621     function burn(uint256 tokenId) public virtual override {
1622         _burn(tokenId, true);
1623     }
1624 }
1625 // File: contracts/BlinkRaffle.sol
1626 
1627 
1628 // creators: The Blinkless
1629 
1630 // DISCLAIMER: This file is provided for educational purposes only 
1631 // and The Blinkless is not liable for its use or misuse.
1632 
1633 pragma solidity ^0.8.4;
1634 
1635 
1636 
1637 
1638 contract BlinkRaffle is ERC721ABurnable, Ownable {
1639 
1640     bool public currentlyMinting = false;
1641     uint256 public maxSupply = 5000;
1642     uint256 public mintPrice = 0.005 ether;
1643     address payoutWallet = 0xeD2faa60373eC70E57B39152aeE5Ce4ed7C333c7; //wallet for payouts
1644 
1645     constructor(string memory _metadataPath) ERC721A("Blink Raffle", "BLNKRF") {
1646         //mint initial token to owner
1647         _mint(msg.sender, 1);
1648         //set path to metadata
1649         metadataPath = _metadataPath;
1650     }
1651 
1652     /*
1653     * Ensures the caller is not a proxy contract or bot, but is an actual wallet.
1654     */
1655     modifier callerIsUser() {
1656         //we only want to mint to real people
1657         require(tx.origin == msg.sender, "The caller is another contract");
1658         _;
1659     }
1660 
1661     /**
1662     * Mint a token
1663     */
1664     function mint(uint256 amount) external payable callerIsUser{
1665         require(amount <= 10, "Max 10 per transaction");
1666         require(currentlyMinting == true, "Minting disabled.");
1667         require(totalSupply() + amount < maxSupply, "Max supply reached.");
1668         require(msg.value >= (mintPrice * amount), "Not enough funds to mint.");
1669         //mint the token
1670         _mint(msg.sender, amount);
1671     }
1672 
1673 
1674     /**
1675     * Update the base URI for metadata
1676     */
1677     function updateBaseURI(string memory baseURI) external onlyOwner{
1678          metadataPath = baseURI;
1679     }
1680 
1681     /**
1682     * Update Price to mint
1683     */
1684     function updateMintPrice(uint256 _mintPrice) external onlyOwner{
1685          mintPrice = _mintPrice;
1686     }
1687 
1688     /**
1689     * Update mint status
1690     */
1691     function updateCurrentlyMinting(bool _currentlyMinting) external onlyOwner{
1692          currentlyMinting = _currentlyMinting;
1693     }
1694 
1695 
1696     /**
1697     * Update the payout wallet address
1698     */
1699     function updatePayoutWallet(address _payoutWallet) public onlyOwner{
1700         payoutWallet = _payoutWallet;
1701     }
1702 
1703     /**
1704     * Update max supply
1705     */
1706     function updateMaxSupply(uint256 _maxSupply) public onlyOwner{
1707         maxSupply = _maxSupply;
1708     }
1709 
1710 
1711    /*
1712     * Withdraw by owner
1713     */
1714     function withdraw() external onlyOwner {
1715         (bool success, ) = payable(payoutWallet).call{value: address(this).balance}("");
1716         require(success, "Transfer failed.");
1717     }
1718 
1719 
1720 
1721     /*
1722     * These are here to receive ETH sent to the contract address
1723     */
1724     receive() external payable {}
1725 
1726     fallback() external payable {}
1727    
1728 }