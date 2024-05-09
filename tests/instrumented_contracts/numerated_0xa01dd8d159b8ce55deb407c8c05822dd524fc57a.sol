1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
32 
33 
34 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev String operations.
40  */
41 library Strings {
42     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
43     uint8 private constant _ADDRESS_LENGTH = 20;
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
47      */
48     function toString(uint256 value) internal pure returns (string memory) {
49         // Inspired by OraclizeAPI's implementation - MIT licence
50         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
51 
52         if (value == 0) {
53             return "0";
54         }
55         uint256 temp = value;
56         uint256 digits;
57         while (temp != 0) {
58             digits++;
59             temp /= 10;
60         }
61         bytes memory buffer = new bytes(digits);
62         while (value != 0) {
63             digits -= 1;
64             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
65             value /= 10;
66         }
67         return string(buffer);
68     }
69 
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
72      */
73     function toHexString(uint256 value) internal pure returns (string memory) {
74         if (value == 0) {
75             return "0x00";
76         }
77         uint256 temp = value;
78         uint256 length = 0;
79         while (temp != 0) {
80             length++;
81             temp >>= 8;
82         }
83         return toHexString(value, length);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
88      */
89     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
90         bytes memory buffer = new bytes(2 * length + 2);
91         buffer[0] = "0";
92         buffer[1] = "x";
93         for (uint256 i = 2 * length + 1; i > 1; --i) {
94             buffer[i] = _HEX_SYMBOLS[value & 0xf];
95             value >>= 4;
96         }
97         require(value == 0, "Strings: hex length insufficient");
98         return string(buffer);
99     }
100 
101     /**
102      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
103      */
104     function toHexString(address addr) internal pure returns (string memory) {
105         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
106     }
107 }
108 
109 // File: @openzeppelin/contracts/access/Ownable.sol
110 
111 
112 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 
117 /**
118  * @dev Contract module which provides a basic access control mechanism, where
119  * there is an account (an owner) that can be granted exclusive access to
120  * specific functions.
121  *
122  * By default, the owner account will be the one that deploys the contract. This
123  * can later be changed with {transferOwnership}.
124  *
125  * This module is used through inheritance. It will make available the modifier
126  * `onlyOwner`, which can be applied to your functions to restrict their use to
127  * the owner.
128  */
129 abstract contract Ownable is Context {
130     address private _owner;
131 
132     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133 
134     /**
135      * @dev Initializes the contract setting the deployer as the initial owner.
136      */
137     constructor() {
138         _transferOwnership(_msgSender());
139     }
140 
141     /**
142      * @dev Throws if called by any account other than the owner.
143      */
144     modifier onlyOwner() {
145         _checkOwner();
146         _;
147     }
148 
149     /**
150      * @dev Returns the address of the current owner.
151      */
152     function owner() public view virtual returns (address) {
153         return _owner;
154     }
155 
156     /**
157      * @dev Throws if the sender is not the owner.
158      */
159     function _checkOwner() internal view virtual {
160         require(owner() == _msgSender(), "Ownable: caller is not the owner");
161     }
162 
163     /**
164      * @dev Leaves the contract without owner. It will not be possible to call
165      * `onlyOwner` functions anymore. Can only be called by the current owner.
166      *
167      * NOTE: Renouncing ownership will leave the contract without an owner,
168      * thereby removing any functionality that is only available to the owner.
169      */
170     function renounceOwnership() public virtual onlyOwner {
171         _transferOwnership(address(0));
172     }
173 
174     /**
175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
176      * Can only be called by the current owner.
177      */
178     function transferOwnership(address newOwner) public virtual onlyOwner {
179         require(newOwner != address(0), "Ownable: new owner is the zero address");
180         _transferOwnership(newOwner);
181     }
182 
183     /**
184      * @dev Transfers ownership of the contract to a new account (`newOwner`).
185      * Internal function without access restriction.
186      */
187     function _transferOwnership(address newOwner) internal virtual {
188         address oldOwner = _owner;
189         _owner = newOwner;
190         emit OwnershipTransferred(oldOwner, newOwner);
191     }
192 }
193 
194 // File: erc721a/contracts/IERC721A.sol
195 
196 
197 // ERC721A Contracts v4.2.2
198 // Creator: Chiru Labs
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
483 // File: erc721a/contracts/ERC721A.sol
484 
485 
486 // ERC721A Contracts v4.2.2
487 // Creator: Chiru Labs
488 
489 pragma solidity ^0.8.4;
490 
491 
492 /**
493  * @dev Interface of ERC721 token receiver.
494  */
495 interface ERC721A__IERC721Receiver {
496     function onERC721Received(
497         address operator,
498         address from,
499         uint256 tokenId,
500         bytes calldata data
501     ) external returns (bytes4);
502 }
503 
504 /**
505  * @title ERC721A
506  *
507  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
508  * Non-Fungible Token Standard, including the Metadata extension.
509  * Optimized for lower gas during batch mints.
510  *
511  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
512  * starting from `_startTokenId()`.
513  *
514  * Assumptions:
515  *
516  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
517  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
518  */
519 contract ERC721A is IERC721A {
520     // Reference type for token approval.
521     struct TokenApprovalRef {
522         address value;
523     }
524 
525     // =============================================================
526     //                           CONSTANTS
527     // =============================================================
528 
529     // Mask of an entry in packed address data.
530     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
531 
532     // The bit position of `numberMinted` in packed address data.
533     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
534 
535     // The bit position of `numberBurned` in packed address data.
536     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
537 
538     // The bit position of `aux` in packed address data.
539     uint256 private constant _BITPOS_AUX = 192;
540 
541     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
542     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
543 
544     // The bit position of `startTimestamp` in packed ownership.
545     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
546 
547     // The bit mask of the `burned` bit in packed ownership.
548     uint256 private constant _BITMASK_BURNED = 1 << 224;
549 
550     // The bit position of the `nextInitialized` bit in packed ownership.
551     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
552 
553     // The bit mask of the `nextInitialized` bit in packed ownership.
554     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
555 
556     // The bit position of `extraData` in packed ownership.
557     uint256 private constant _BITPOS_EXTRA_DATA = 232;
558 
559     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
560     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
561 
562     // The mask of the lower 160 bits for addresses.
563     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
564 
565     // The maximum `quantity` that can be minted with {_mintERC2309}.
566     // This limit is to prevent overflows on the address data entries.
567     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
568     // is required to cause an overflow, which is unrealistic.
569     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
570 
571     // The `Transfer` event signature is given by:
572     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
573     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
574         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
575 
576     // =============================================================
577     //                            STORAGE
578     // =============================================================
579 
580     // The next token ID to be minted.
581     uint256 private _currentIndex;
582 
583     // The number of tokens burned.
584     uint256 private _burnCounter;
585 
586     // Token name
587     string private _name;
588 
589     // Token symbol
590     string private _symbol;
591 
592     // Mapping from token ID to ownership details
593     // An empty struct value does not necessarily mean the token is unowned.
594     // See {_packedOwnershipOf} implementation for details.
595     //
596     // Bits Layout:
597     // - [0..159]   `addr`
598     // - [160..223] `startTimestamp`
599     // - [224]      `burned`
600     // - [225]      `nextInitialized`
601     // - [232..255] `extraData`
602     mapping(uint256 => uint256) private _packedOwnerships;
603 
604     // Mapping owner address to address data.
605     //
606     // Bits Layout:
607     // - [0..63]    `balance`
608     // - [64..127]  `numberMinted`
609     // - [128..191] `numberBurned`
610     // - [192..255] `aux`
611     mapping(address => uint256) private _packedAddressData;
612 
613     // Mapping from token ID to approved address.
614     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
615 
616     // Mapping from owner to operator approvals
617     mapping(address => mapping(address => bool)) private _operatorApprovals;
618 
619     // =============================================================
620     //                          CONSTRUCTOR
621     // =============================================================
622 
623     constructor(string memory name_, string memory symbol_) {
624         _name = name_;
625         _symbol = symbol_;
626         _currentIndex = _startTokenId();
627     }
628 
629     // =============================================================
630     //                   TOKEN COUNTING OPERATIONS
631     // =============================================================
632 
633     /**
634      * @dev Returns the starting token ID.
635      * To change the starting token ID, please override this function.
636      */
637     function _startTokenId() internal view virtual returns (uint256) {
638         return 0;
639     }
640 
641     /**
642      * @dev Returns the next token ID to be minted.
643      */
644     function _nextTokenId() internal view virtual returns (uint256) {
645         return _currentIndex;
646     }
647 
648     /**
649      * @dev Returns the total number of tokens in existence.
650      * Burned tokens will reduce the count.
651      * To get the total number of tokens minted, please see {_totalMinted}.
652      */
653     function totalSupply() public view virtual override returns (uint256) {
654         // Counter underflow is impossible as _burnCounter cannot be incremented
655         // more than `_currentIndex - _startTokenId()` times.
656         unchecked {
657             return _currentIndex - _burnCounter - _startTokenId();
658         }
659     }
660 
661     /**
662      * @dev Returns the total amount of tokens minted in the contract.
663      */
664     function _totalMinted() internal view virtual returns (uint256) {
665         // Counter underflow is impossible as `_currentIndex` does not decrement,
666         // and it is initialized to `_startTokenId()`.
667         unchecked {
668             return _currentIndex - _startTokenId();
669         }
670     }
671 
672     /**
673      * @dev Returns the total number of tokens burned.
674      */
675     function _totalBurned() internal view virtual returns (uint256) {
676         return _burnCounter;
677     }
678 
679     // =============================================================
680     //                    ADDRESS DATA OPERATIONS
681     // =============================================================
682 
683     /**
684      * @dev Returns the number of tokens in `owner`'s account.
685      */
686     function balanceOf(address owner) public view virtual override returns (uint256) {
687         if (owner == address(0)) revert BalanceQueryForZeroAddress();
688         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
689     }
690 
691     /**
692      * Returns the number of tokens minted by `owner`.
693      */
694     function _numberMinted(address owner) internal view returns (uint256) {
695         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
696     }
697 
698     /**
699      * Returns the number of tokens burned by or on behalf of `owner`.
700      */
701     function _numberBurned(address owner) internal view returns (uint256) {
702         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
703     }
704 
705     /**
706      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
707      */
708     function _getAux(address owner) internal view returns (uint64) {
709         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
710     }
711 
712     /**
713      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
714      * If there are multiple variables, please pack them into a uint64.
715      */
716     function _setAux(address owner, uint64 aux) internal virtual {
717         uint256 packed = _packedAddressData[owner];
718         uint256 auxCasted;
719         // Cast `aux` with assembly to avoid redundant masking.
720         assembly {
721             auxCasted := aux
722         }
723         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
724         _packedAddressData[owner] = packed;
725     }
726 
727     // =============================================================
728     //                            IERC165
729     // =============================================================
730 
731     /**
732      * @dev Returns true if this contract implements the interface defined by
733      * `interfaceId`. See the corresponding
734      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
735      * to learn more about how these ids are created.
736      *
737      * This function call must use less than 30000 gas.
738      */
739     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
740         // The interface IDs are constants representing the first 4 bytes
741         // of the XOR of all function selectors in the interface.
742         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
743         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
744         return
745             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
746             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
747             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
748     }
749 
750     // =============================================================
751     //                        IERC721Metadata
752     // =============================================================
753 
754     /**
755      * @dev Returns the token collection name.
756      */
757     function name() public view virtual override returns (string memory) {
758         return _name;
759     }
760 
761     /**
762      * @dev Returns the token collection symbol.
763      */
764     function symbol() public view virtual override returns (string memory) {
765         return _symbol;
766     }
767 
768     /**
769      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
770      */
771     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
772         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
773 
774         string memory baseURI = _baseURI();
775         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
776     }
777 
778     /**
779      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
780      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
781      * by default, it can be overridden in child contracts.
782      */
783     function _baseURI() internal view virtual returns (string memory) {
784         return '';
785     }
786 
787     // =============================================================
788     //                     OWNERSHIPS OPERATIONS
789     // =============================================================
790 
791     /**
792      * @dev Returns the owner of the `tokenId` token.
793      *
794      * Requirements:
795      *
796      * - `tokenId` must exist.
797      */
798     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
799         return address(uint160(_packedOwnershipOf(tokenId)));
800     }
801 
802     /**
803      * @dev Gas spent here starts off proportional to the maximum mint batch size.
804      * It gradually moves to O(1) as tokens get transferred around over time.
805      */
806     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
807         return _unpackedOwnership(_packedOwnershipOf(tokenId));
808     }
809 
810     /**
811      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
812      */
813     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
814         return _unpackedOwnership(_packedOwnerships[index]);
815     }
816 
817     /**
818      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
819      */
820     function _initializeOwnershipAt(uint256 index) internal virtual {
821         if (_packedOwnerships[index] == 0) {
822             _packedOwnerships[index] = _packedOwnershipOf(index);
823         }
824     }
825 
826     /**
827      * Returns the packed ownership data of `tokenId`.
828      */
829     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
830         uint256 curr = tokenId;
831 
832         unchecked {
833             if (_startTokenId() <= curr)
834                 if (curr < _currentIndex) {
835                     uint256 packed = _packedOwnerships[curr];
836                     // If not burned.
837                     if (packed & _BITMASK_BURNED == 0) {
838                         // Invariant:
839                         // There will always be an initialized ownership slot
840                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
841                         // before an unintialized ownership slot
842                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
843                         // Hence, `curr` will not underflow.
844                         //
845                         // We can directly compare the packed value.
846                         // If the address is zero, packed will be zero.
847                         while (packed == 0) {
848                             packed = _packedOwnerships[--curr];
849                         }
850                         return packed;
851                     }
852                 }
853         }
854         revert OwnerQueryForNonexistentToken();
855     }
856 
857     /**
858      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
859      */
860     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
861         ownership.addr = address(uint160(packed));
862         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
863         ownership.burned = packed & _BITMASK_BURNED != 0;
864         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
865     }
866 
867     /**
868      * @dev Packs ownership data into a single uint256.
869      */
870     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
871         assembly {
872             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
873             owner := and(owner, _BITMASK_ADDRESS)
874             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
875             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
876         }
877     }
878 
879     /**
880      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
881      */
882     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
883         // For branchless setting of the `nextInitialized` flag.
884         assembly {
885             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
886             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
887         }
888     }
889 
890     // =============================================================
891     //                      APPROVAL OPERATIONS
892     // =============================================================
893 
894     /**
895      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
896      * The approval is cleared when the token is transferred.
897      *
898      * Only a single account can be approved at a time, so approving the
899      * zero address clears previous approvals.
900      *
901      * Requirements:
902      *
903      * - The caller must own the token or be an approved operator.
904      * - `tokenId` must exist.
905      *
906      * Emits an {Approval} event.
907      */
908     function approve(address to, uint256 tokenId) public virtual override {
909         address owner = ownerOf(tokenId);
910 
911         if (_msgSenderERC721A() != owner)
912             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
913                 revert ApprovalCallerNotOwnerNorApproved();
914             }
915 
916         _tokenApprovals[tokenId].value = to;
917         emit Approval(owner, to, tokenId);
918     }
919 
920     /**
921      * @dev Returns the account approved for `tokenId` token.
922      *
923      * Requirements:
924      *
925      * - `tokenId` must exist.
926      */
927     function getApproved(uint256 tokenId) public view virtual override returns (address) {
928         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
929 
930         return _tokenApprovals[tokenId].value;
931     }
932 
933     /**
934      * @dev Approve or remove `operator` as an operator for the caller.
935      * Operators can call {transferFrom} or {safeTransferFrom}
936      * for any token owned by the caller.
937      *
938      * Requirements:
939      *
940      * - The `operator` cannot be the caller.
941      *
942      * Emits an {ApprovalForAll} event.
943      */
944     function setApprovalForAll(address operator, bool approved) public virtual override {
945         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
946 
947         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
948         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
949     }
950 
951     /**
952      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
953      *
954      * See {setApprovalForAll}.
955      */
956     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
957         return _operatorApprovals[owner][operator];
958     }
959 
960     /**
961      * @dev Returns whether `tokenId` exists.
962      *
963      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
964      *
965      * Tokens start existing when they are minted. See {_mint}.
966      */
967     function _exists(uint256 tokenId) internal view virtual returns (bool) {
968         return
969             _startTokenId() <= tokenId &&
970             tokenId < _currentIndex && // If within bounds,
971             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
972     }
973 
974     /**
975      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
976      */
977     function _isSenderApprovedOrOwner(
978         address approvedAddress,
979         address owner,
980         address msgSender
981     ) private pure returns (bool result) {
982         assembly {
983             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
984             owner := and(owner, _BITMASK_ADDRESS)
985             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
986             msgSender := and(msgSender, _BITMASK_ADDRESS)
987             // `msgSender == owner || msgSender == approvedAddress`.
988             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
989         }
990     }
991 
992     /**
993      * @dev Returns the storage slot and value for the approved address of `tokenId`.
994      */
995     function _getApprovedSlotAndAddress(uint256 tokenId)
996         private
997         view
998         returns (uint256 approvedAddressSlot, address approvedAddress)
999     {
1000         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1001         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1002         assembly {
1003             approvedAddressSlot := tokenApproval.slot
1004             approvedAddress := sload(approvedAddressSlot)
1005         }
1006     }
1007 
1008     // =============================================================
1009     //                      TRANSFER OPERATIONS
1010     // =============================================================
1011 
1012     /**
1013      * @dev Transfers `tokenId` from `from` to `to`.
1014      *
1015      * Requirements:
1016      *
1017      * - `from` cannot be the zero address.
1018      * - `to` cannot be the zero address.
1019      * - `tokenId` token must be owned by `from`.
1020      * - If the caller is not `from`, it must be approved to move this token
1021      * by either {approve} or {setApprovalForAll}.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function transferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) public virtual override {
1030         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1031 
1032         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1033 
1034         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1035 
1036         // The nested ifs save around 20+ gas over a compound boolean condition.
1037         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1038             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1039 
1040         if (to == address(0)) revert TransferToZeroAddress();
1041 
1042         _beforeTokenTransfers(from, to, tokenId, 1);
1043 
1044         // Clear approvals from the previous owner.
1045         assembly {
1046             if approvedAddress {
1047                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1048                 sstore(approvedAddressSlot, 0)
1049             }
1050         }
1051 
1052         // Underflow of the sender's balance is impossible because we check for
1053         // ownership above and the recipient's balance can't realistically overflow.
1054         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1055         unchecked {
1056             // We can directly increment and decrement the balances.
1057             --_packedAddressData[from]; // Updates: `balance -= 1`.
1058             ++_packedAddressData[to]; // Updates: `balance += 1`.
1059 
1060             // Updates:
1061             // - `address` to the next owner.
1062             // - `startTimestamp` to the timestamp of transfering.
1063             // - `burned` to `false`.
1064             // - `nextInitialized` to `true`.
1065             _packedOwnerships[tokenId] = _packOwnershipData(
1066                 to,
1067                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1068             );
1069 
1070             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1071             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1072                 uint256 nextTokenId = tokenId + 1;
1073                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1074                 if (_packedOwnerships[nextTokenId] == 0) {
1075                     // If the next slot is within bounds.
1076                     if (nextTokenId != _currentIndex) {
1077                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1078                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1079                     }
1080                 }
1081             }
1082         }
1083 
1084         emit Transfer(from, to, tokenId);
1085         _afterTokenTransfers(from, to, tokenId, 1);
1086     }
1087 
1088     /**
1089      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1090      */
1091     function safeTransferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) public virtual override {
1096         safeTransferFrom(from, to, tokenId, '');
1097     }
1098 
1099     /**
1100      * @dev Safely transfers `tokenId` token from `from` to `to`.
1101      *
1102      * Requirements:
1103      *
1104      * - `from` cannot be the zero address.
1105      * - `to` cannot be the zero address.
1106      * - `tokenId` token must exist and be owned by `from`.
1107      * - If the caller is not `from`, it must be approved to move this token
1108      * by either {approve} or {setApprovalForAll}.
1109      * - If `to` refers to a smart contract, it must implement
1110      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function safeTransferFrom(
1115         address from,
1116         address to,
1117         uint256 tokenId,
1118         bytes memory _data
1119     ) public virtual override {
1120         transferFrom(from, to, tokenId);
1121         if (to.code.length != 0)
1122             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1123                 revert TransferToNonERC721ReceiverImplementer();
1124             }
1125     }
1126 
1127     /**
1128      * @dev Hook that is called before a set of serially-ordered token IDs
1129      * are about to be transferred. This includes minting.
1130      * And also called before burning one token.
1131      *
1132      * `startTokenId` - the first token ID to be transferred.
1133      * `quantity` - the amount to be transferred.
1134      *
1135      * Calling conditions:
1136      *
1137      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1138      * transferred to `to`.
1139      * - When `from` is zero, `tokenId` will be minted for `to`.
1140      * - When `to` is zero, `tokenId` will be burned by `from`.
1141      * - `from` and `to` are never both zero.
1142      */
1143     function _beforeTokenTransfers(
1144         address from,
1145         address to,
1146         uint256 startTokenId,
1147         uint256 quantity
1148     ) internal virtual {}
1149 
1150     /**
1151      * @dev Hook that is called after a set of serially-ordered token IDs
1152      * have been transferred. This includes minting.
1153      * And also called after one token has been burned.
1154      *
1155      * `startTokenId` - the first token ID to be transferred.
1156      * `quantity` - the amount to be transferred.
1157      *
1158      * Calling conditions:
1159      *
1160      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1161      * transferred to `to`.
1162      * - When `from` is zero, `tokenId` has been minted for `to`.
1163      * - When `to` is zero, `tokenId` has been burned by `from`.
1164      * - `from` and `to` are never both zero.
1165      */
1166     function _afterTokenTransfers(
1167         address from,
1168         address to,
1169         uint256 startTokenId,
1170         uint256 quantity
1171     ) internal virtual {}
1172 
1173     /**
1174      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1175      *
1176      * `from` - Previous owner of the given token ID.
1177      * `to` - Target address that will receive the token.
1178      * `tokenId` - Token ID to be transferred.
1179      * `_data` - Optional data to send along with the call.
1180      *
1181      * Returns whether the call correctly returned the expected magic value.
1182      */
1183     function _checkContractOnERC721Received(
1184         address from,
1185         address to,
1186         uint256 tokenId,
1187         bytes memory _data
1188     ) private returns (bool) {
1189         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1190             bytes4 retval
1191         ) {
1192             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1193         } catch (bytes memory reason) {
1194             if (reason.length == 0) {
1195                 revert TransferToNonERC721ReceiverImplementer();
1196             } else {
1197                 assembly {
1198                     revert(add(32, reason), mload(reason))
1199                 }
1200             }
1201         }
1202     }
1203 
1204     // =============================================================
1205     //                        MINT OPERATIONS
1206     // =============================================================
1207 
1208     /**
1209      * @dev Mints `quantity` tokens and transfers them to `to`.
1210      *
1211      * Requirements:
1212      *
1213      * - `to` cannot be the zero address.
1214      * - `quantity` must be greater than 0.
1215      *
1216      * Emits a {Transfer} event for each mint.
1217      */
1218     function _mint(address to, uint256 quantity) internal virtual {
1219         uint256 startTokenId = _currentIndex;
1220         if (quantity == 0) revert MintZeroQuantity();
1221 
1222         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1223 
1224         // Overflows are incredibly unrealistic.
1225         // `balance` and `numberMinted` have a maximum limit of 2**64.
1226         // `tokenId` has a maximum limit of 2**256.
1227         unchecked {
1228             // Updates:
1229             // - `balance += quantity`.
1230             // - `numberMinted += quantity`.
1231             //
1232             // We can directly add to the `balance` and `numberMinted`.
1233             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1234 
1235             // Updates:
1236             // - `address` to the owner.
1237             // - `startTimestamp` to the timestamp of minting.
1238             // - `burned` to `false`.
1239             // - `nextInitialized` to `quantity == 1`.
1240             _packedOwnerships[startTokenId] = _packOwnershipData(
1241                 to,
1242                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1243             );
1244 
1245             uint256 toMasked;
1246             uint256 end = startTokenId + quantity;
1247 
1248             // Use assembly to loop and emit the `Transfer` event for gas savings.
1249             assembly {
1250                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1251                 toMasked := and(to, _BITMASK_ADDRESS)
1252                 // Emit the `Transfer` event.
1253                 log4(
1254                     0, // Start of data (0, since no data).
1255                     0, // End of data (0, since no data).
1256                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1257                     0, // `address(0)`.
1258                     toMasked, // `to`.
1259                     startTokenId // `tokenId`.
1260                 )
1261 
1262                 for {
1263                     let tokenId := add(startTokenId, 1)
1264                 } iszero(eq(tokenId, end)) {
1265                     tokenId := add(tokenId, 1)
1266                 } {
1267                     // Emit the `Transfer` event. Similar to above.
1268                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1269                 }
1270             }
1271             if (toMasked == 0) revert MintToZeroAddress();
1272 
1273             _currentIndex = end;
1274         }
1275         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1276     }
1277 
1278     /**
1279      * @dev Mints `quantity` tokens and transfers them to `to`.
1280      *
1281      * This function is intended for efficient minting only during contract creation.
1282      *
1283      * It emits only one {ConsecutiveTransfer} as defined in
1284      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1285      * instead of a sequence of {Transfer} event(s).
1286      *
1287      * Calling this function outside of contract creation WILL make your contract
1288      * non-compliant with the ERC721 standard.
1289      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1290      * {ConsecutiveTransfer} event is only permissible during contract creation.
1291      *
1292      * Requirements:
1293      *
1294      * - `to` cannot be the zero address.
1295      * - `quantity` must be greater than 0.
1296      *
1297      * Emits a {ConsecutiveTransfer} event.
1298      */
1299     function _mintERC2309(address to, uint256 quantity) internal virtual {
1300         uint256 startTokenId = _currentIndex;
1301         if (to == address(0)) revert MintToZeroAddress();
1302         if (quantity == 0) revert MintZeroQuantity();
1303         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1304 
1305         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1306 
1307         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1308         unchecked {
1309             // Updates:
1310             // - `balance += quantity`.
1311             // - `numberMinted += quantity`.
1312             //
1313             // We can directly add to the `balance` and `numberMinted`.
1314             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1315 
1316             // Updates:
1317             // - `address` to the owner.
1318             // - `startTimestamp` to the timestamp of minting.
1319             // - `burned` to `false`.
1320             // - `nextInitialized` to `quantity == 1`.
1321             _packedOwnerships[startTokenId] = _packOwnershipData(
1322                 to,
1323                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1324             );
1325 
1326             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1327 
1328             _currentIndex = startTokenId + quantity;
1329         }
1330         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1331     }
1332 
1333     /**
1334      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1335      *
1336      * Requirements:
1337      *
1338      * - If `to` refers to a smart contract, it must implement
1339      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1340      * - `quantity` must be greater than 0.
1341      *
1342      * See {_mint}.
1343      *
1344      * Emits a {Transfer} event for each mint.
1345      */
1346     function _safeMint(
1347         address to,
1348         uint256 quantity,
1349         bytes memory _data
1350     ) internal virtual {
1351         _mint(to, quantity);
1352 
1353         unchecked {
1354             if (to.code.length != 0) {
1355                 uint256 end = _currentIndex;
1356                 uint256 index = end - quantity;
1357                 do {
1358                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1359                         revert TransferToNonERC721ReceiverImplementer();
1360                     }
1361                 } while (index < end);
1362                 // Reentrancy protection.
1363                 if (_currentIndex != end) revert();
1364             }
1365         }
1366     }
1367 
1368     /**
1369      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1370      */
1371     function _safeMint(address to, uint256 quantity) internal virtual {
1372         _safeMint(to, quantity, '');
1373     }
1374 
1375     // =============================================================
1376     //                        BURN OPERATIONS
1377     // =============================================================
1378 
1379     /**
1380      * @dev Equivalent to `_burn(tokenId, false)`.
1381      */
1382     function _burn(uint256 tokenId) internal virtual {
1383         _burn(tokenId, false);
1384     }
1385 
1386     /**
1387      * @dev Destroys `tokenId`.
1388      * The approval is cleared when the token is burned.
1389      *
1390      * Requirements:
1391      *
1392      * - `tokenId` must exist.
1393      *
1394      * Emits a {Transfer} event.
1395      */
1396     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1397         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1398 
1399         address from = address(uint160(prevOwnershipPacked));
1400 
1401         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1402 
1403         if (approvalCheck) {
1404             // The nested ifs save around 20+ gas over a compound boolean condition.
1405             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1406                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1407         }
1408 
1409         _beforeTokenTransfers(from, address(0), tokenId, 1);
1410 
1411         // Clear approvals from the previous owner.
1412         assembly {
1413             if approvedAddress {
1414                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1415                 sstore(approvedAddressSlot, 0)
1416             }
1417         }
1418 
1419         // Underflow of the sender's balance is impossible because we check for
1420         // ownership above and the recipient's balance can't realistically overflow.
1421         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1422         unchecked {
1423             // Updates:
1424             // - `balance -= 1`.
1425             // - `numberBurned += 1`.
1426             //
1427             // We can directly decrement the balance, and increment the number burned.
1428             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1429             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1430 
1431             // Updates:
1432             // - `address` to the last owner.
1433             // - `startTimestamp` to the timestamp of burning.
1434             // - `burned` to `true`.
1435             // - `nextInitialized` to `true`.
1436             _packedOwnerships[tokenId] = _packOwnershipData(
1437                 from,
1438                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1439             );
1440 
1441             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1442             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1443                 uint256 nextTokenId = tokenId + 1;
1444                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1445                 if (_packedOwnerships[nextTokenId] == 0) {
1446                     // If the next slot is within bounds.
1447                     if (nextTokenId != _currentIndex) {
1448                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1449                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1450                     }
1451                 }
1452             }
1453         }
1454 
1455         emit Transfer(from, address(0), tokenId);
1456         _afterTokenTransfers(from, address(0), tokenId, 1);
1457 
1458         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1459         unchecked {
1460             _burnCounter++;
1461         }
1462     }
1463 
1464     // =============================================================
1465     //                     EXTRA DATA OPERATIONS
1466     // =============================================================
1467 
1468     /**
1469      * @dev Directly sets the extra data for the ownership data `index`.
1470      */
1471     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1472         uint256 packed = _packedOwnerships[index];
1473         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1474         uint256 extraDataCasted;
1475         // Cast `extraData` with assembly to avoid redundant masking.
1476         assembly {
1477             extraDataCasted := extraData
1478         }
1479         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1480         _packedOwnerships[index] = packed;
1481     }
1482 
1483     /**
1484      * @dev Called during each token transfer to set the 24bit `extraData` field.
1485      * Intended to be overridden by the cosumer contract.
1486      *
1487      * `previousExtraData` - the value of `extraData` before transfer.
1488      *
1489      * Calling conditions:
1490      *
1491      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1492      * transferred to `to`.
1493      * - When `from` is zero, `tokenId` will be minted for `to`.
1494      * - When `to` is zero, `tokenId` will be burned by `from`.
1495      * - `from` and `to` are never both zero.
1496      */
1497     function _extraData(
1498         address from,
1499         address to,
1500         uint24 previousExtraData
1501     ) internal view virtual returns (uint24) {}
1502 
1503     /**
1504      * @dev Returns the next extra data for the packed ownership data.
1505      * The returned result is shifted into position.
1506      */
1507     function _nextExtraData(
1508         address from,
1509         address to,
1510         uint256 prevOwnershipPacked
1511     ) private view returns (uint256) {
1512         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1513         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1514     }
1515 
1516     // =============================================================
1517     //                       OTHER OPERATIONS
1518     // =============================================================
1519 
1520     /**
1521      * @dev Returns the message sender (defaults to `msg.sender`).
1522      *
1523      * If you are writing GSN compatible contracts, you need to override this function.
1524      */
1525     function _msgSenderERC721A() internal view virtual returns (address) {
1526         return msg.sender;
1527     }
1528 
1529     /**
1530      * @dev Converts a uint256 to its ASCII string decimal representation.
1531      */
1532     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1533         assembly {
1534             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1535             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1536             // We will need 1 32-byte word to store the length,
1537             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1538             str := add(mload(0x40), 0x80)
1539             // Update the free memory pointer to allocate.
1540             mstore(0x40, str)
1541 
1542             // Cache the end of the memory to calculate the length later.
1543             let end := str
1544 
1545             // We write the string from rightmost digit to leftmost digit.
1546             // The following is essentially a do-while loop that also handles the zero case.
1547             // prettier-ignore
1548             for { let temp := value } 1 {} {
1549                 str := sub(str, 1)
1550                 // Write the character to the pointer.
1551                 // The ASCII index of the '0' character is 48.
1552                 mstore8(str, add(48, mod(temp, 10)))
1553                 // Keep dividing `temp` until zero.
1554                 temp := div(temp, 10)
1555                 // prettier-ignore
1556                 if iszero(temp) { break }
1557             }
1558 
1559             let length := sub(end, str)
1560             // Move the pointer 32 bytes leftwards to make room for the length.
1561             str := sub(str, 0x20)
1562             // Store the length.
1563             mstore(str, length)
1564         }
1565     }
1566 }
1567 
1568 // File: contracts/RichCZYachtClub.sol
1569 
1570 pragma solidity ^0.8.4;
1571 
1572 contract RichCZYachtClub is ERC721A, Ownable {
1573 
1574     using Strings for uint256;
1575 
1576     string public baseURI = "https://richczyachtclub.s3.amazonaws.com/metadata/";
1577 
1578     uint256 public price = 0.001 ether;
1579     uint256 public maxPerTx = 20;
1580     uint256 public maxSupply = 6969;
1581 
1582     uint256 public maxFreePerWallet = 1;
1583     uint256 public totalFreeMinted = 0;
1584     uint256 public maxFreeSupply = 5000;
1585 
1586     mapping(address => uint256) public _mintedFreeAmount;
1587 
1588     constructor() ERC721A("Rich CZ Yacht CLub", "RCYC") {}
1589 
1590     function mint(uint256 _amount) external payable {
1591 
1592         require(msg.value >= _amount * price, "Incorrect amount of ETH.");
1593         require(totalSupply() + _amount <= maxSupply, "Sold out.");
1594         require(tx.origin == msg.sender, "Only humans please.");
1595         require(_amount <= maxPerTx, "You may only mint a max of 10 per transaction");
1596 
1597         _mint(msg.sender, _amount);
1598     }
1599 
1600     function mintFree(uint256 _amount) external payable {
1601         require(_mintedFreeAmount[msg.sender] + _amount <= maxFreePerWallet, "You have minted the max free amount allowed per wallet.");
1602 		require(totalFreeMinted + _amount <= maxFreeSupply, "Cannot exceed Free supply." );
1603         require(totalSupply() + _amount <= maxSupply, "Sold out.");
1604 
1605         _mintedFreeAmount[msg.sender]++;
1606         totalFreeMinted++;
1607         _safeMint(msg.sender, _amount);
1608 	}
1609 
1610     function tokenURI(uint256 tokenId)
1611         public view virtual override returns (string memory) {
1612         require(
1613             _exists(tokenId),
1614             "ERC721Metadata: URI query for nonexistent token"
1615         );
1616         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1617     }
1618 
1619     function setBaseURI(string calldata baseURI_) external onlyOwner {
1620         baseURI = baseURI_;
1621     }
1622 
1623     function setPrice(uint256 _price) external onlyOwner {
1624         price = _price;
1625     }
1626 
1627     function setMaxPerTx(uint256 _amount) external onlyOwner {
1628         maxPerTx = _amount;
1629     }
1630 
1631     function setmaxFreeSupply(uint256 _newMaxFreeSupply) public onlyOwner {
1632         require(_newMaxFreeSupply <= maxSupply);
1633         maxFreeSupply = _newMaxFreeSupply;
1634     }
1635 
1636     function _startTokenId() internal pure override returns (uint256) {
1637         return 1;
1638     }
1639 
1640     function withdraw() external onlyOwner {
1641         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1642         require(success, "Transfer failed.");
1643     }
1644 
1645 }