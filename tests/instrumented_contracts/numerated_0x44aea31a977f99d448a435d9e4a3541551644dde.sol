1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5 888888ba   .88888.   888888ba   .88888.  888888ba  dP    dP .d88888b  
6 88    `8b d8'   `8b  88    `8b d8'   `8b 88    `8b Y8.  .8P 88.    "' 
7 88     88 88     88 a88aaaa8P' 88     88 88     88  Y8aa8P  `Y88888b. 
8 88     88 88     88  88   `8b. 88     88 88     88    88          `8b 
9 88     88 Y8.   .8P  88    .88 Y8.   .8P 88    .8P    88    d8'   .8P 
10 dP     dP  `8888P'   88888888P  `8888P'  8888888P     dP     Y88888P                                                                                                      
11                                                                                                                                                        
12 */
13 
14 // File: @openzeppelin/contracts/utils/Context.sol
15 
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Provides information about the current execution context, including the
23  * sender of the transaction and its data. While these are generally available
24  * via msg.sender and msg.data, they should not be accessed in such a direct
25  * manner, since when dealing with meta-transactions the account sending and
26  * paying for execution may not be the actual sender (as far as an application
27  * is concerned).
28  *
29  * This contract is only required for intermediate, library-like contracts.
30  */
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 
42 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
43 
44 
45 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
46 
47 pragma solidity ^0.8.0;
48 
49 /**
50  * @dev String operations.
51  */
52 library Strings {
53     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
54     uint8 private constant _ADDRESS_LENGTH = 20;
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
58      */
59     function toString(uint256 value) internal pure returns (string memory) {
60         // Inspired by OraclizeAPI's implementation - MIT licence
61         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
62 
63         if (value == 0) {
64             return "0";
65         }
66         uint256 temp = value;
67         uint256 digits;
68         while (temp != 0) {
69             digits++;
70             temp /= 10;
71         }
72         bytes memory buffer = new bytes(digits);
73         while (value != 0) {
74             digits -= 1;
75             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
76             value /= 10;
77         }
78         return string(buffer);
79     }
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
83      */
84     function toHexString(uint256 value) internal pure returns (string memory) {
85         if (value == 0) {
86             return "0x00";
87         }
88         uint256 temp = value;
89         uint256 length = 0;
90         while (temp != 0) {
91             length++;
92             temp >>= 8;
93         }
94         return toHexString(value, length);
95     }
96 
97     /**
98      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
99      */
100     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
101         bytes memory buffer = new bytes(2 * length + 2);
102         buffer[0] = "0";
103         buffer[1] = "x";
104         for (uint256 i = 2 * length + 1; i > 1; --i) {
105             buffer[i] = _HEX_SYMBOLS[value & 0xf];
106             value >>= 4;
107         }
108         require(value == 0, "Strings: hex length insufficient");
109         return string(buffer);
110     }
111 
112     /**
113      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
114      */
115     function toHexString(address addr) internal pure returns (string memory) {
116         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
117     }
118 }
119 
120 // File: @openzeppelin/contracts/access/Ownable.sol
121 
122 
123 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
124 
125 pragma solidity ^0.8.0;
126 
127 
128 /**
129  * @dev Contract module which provides a basic access control mechanism, where
130  * there is an account (an owner) that can be granted exclusive access to
131  * specific functions.
132  *
133  * By default, the owner account will be the one that deploys the contract. This
134  * can later be changed with {transferOwnership}.
135  *
136  * This module is used through inheritance. It will make available the modifier
137  * `onlyOwner`, which can be applied to your functions to restrict their use to
138  * the owner.
139  */
140 abstract contract Ownable is Context {
141     address private _owner;
142 
143     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
144 
145     /**
146      * @dev Initializes the contract setting the deployer as the initial owner.
147      */
148     constructor() {
149         _transferOwnership(_msgSender());
150     }
151 
152     /**
153      * @dev Throws if called by any account other than the owner.
154      */
155     modifier onlyOwner() {
156         _checkOwner();
157         _;
158     }
159 
160     /**
161      * @dev Returns the address of the current owner.
162      */
163     function owner() public view virtual returns (address) {
164         return _owner;
165     }
166 
167     /**
168      * @dev Throws if the sender is not the owner.
169      */
170     function _checkOwner() internal view virtual {
171         require(owner() == _msgSender(), "Ownable: caller is not the owner");
172     }
173 
174     /**
175      * @dev Leaves the contract without owner. It will not be possible to call
176      * `onlyOwner` functions anymore. Can only be called by the current owner.
177      *
178      * NOTE: Renouncing ownership will leave the contract without an owner,
179      * thereby removing any functionality that is only available to the owner.
180      */
181     function renounceOwnership() public virtual onlyOwner {
182         _transferOwnership(address(0));
183     }
184 
185     /**
186      * @dev Transfers ownership of the contract to a new account (`newOwner`).
187      * Can only be called by the current owner.
188      */
189     function transferOwnership(address newOwner) public virtual onlyOwner {
190         require(newOwner != address(0), "Ownable: new owner is the zero address");
191         _transferOwnership(newOwner);
192     }
193 
194     /**
195      * @dev Transfers ownership of the contract to a new account (`newOwner`).
196      * Internal function without access restriction.
197      */
198     function _transferOwnership(address newOwner) internal virtual {
199         address oldOwner = _owner;
200         _owner = newOwner;
201         emit OwnershipTransferred(oldOwner, newOwner);
202     }
203 }
204 
205 // File: erc721a/contracts/IERC721A.sol
206 
207 
208 // ERC721A Contracts v4.2.2
209 // Creator: Chiru Labs
210 
211 pragma solidity ^0.8.4;
212 
213 /**
214  * @dev Interface of ERC721A.
215  */
216 interface IERC721A {
217     /**
218      * The caller must own the token or be an approved operator.
219      */
220     error ApprovalCallerNotOwnerNorApproved();
221 
222     /**
223      * The token does not exist.
224      */
225     error ApprovalQueryForNonexistentToken();
226 
227     /**
228      * The caller cannot approve to their own address.
229      */
230     error ApproveToCaller();
231 
232     /**
233      * Cannot query the balance for the zero address.
234      */
235     error BalanceQueryForZeroAddress();
236 
237     /**
238      * Cannot mint to the zero address.
239      */
240     error MintToZeroAddress();
241 
242     /**
243      * The quantity of tokens minted must be more than zero.
244      */
245     error MintZeroQuantity();
246 
247     /**
248      * The token does not exist.
249      */
250     error OwnerQueryForNonexistentToken();
251 
252     /**
253      * The caller must own the token or be an approved operator.
254      */
255     error TransferCallerNotOwnerNorApproved();
256 
257     /**
258      * The token must be owned by `from`.
259      */
260     error TransferFromIncorrectOwner();
261 
262     /**
263      * Cannot safely transfer to a contract that does not implement the
264      * ERC721Receiver interface.
265      */
266     error TransferToNonERC721ReceiverImplementer();
267 
268     /**
269      * Cannot transfer to the zero address.
270      */
271     error TransferToZeroAddress();
272 
273     /**
274      * The token does not exist.
275      */
276     error URIQueryForNonexistentToken();
277 
278     /**
279      * The `quantity` minted with ERC2309 exceeds the safety limit.
280      */
281     error MintERC2309QuantityExceedsLimit();
282 
283     /**
284      * The `extraData` cannot be set on an unintialized ownership slot.
285      */
286     error OwnershipNotInitializedForExtraData();
287 
288     // =============================================================
289     //                            STRUCTS
290     // =============================================================
291 
292     struct TokenOwnership {
293         // The address of the owner.
294         address addr;
295         // Stores the start time of ownership with minimal overhead for tokenomics.
296         uint64 startTimestamp;
297         // Whether the token has been burned.
298         bool burned;
299         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
300         uint24 extraData;
301     }
302 
303     // =============================================================
304     //                         TOKEN COUNTERS
305     // =============================================================
306 
307     /**
308      * @dev Returns the total number of tokens in existence.
309      * Burned tokens will reduce the count.
310      * To get the total number of tokens minted, please see {_totalMinted}.
311      */
312     function totalSupply() external view returns (uint256);
313 
314     // =============================================================
315     //                            IERC165
316     // =============================================================
317 
318     /**
319      * @dev Returns true if this contract implements the interface defined by
320      * `interfaceId`. See the corresponding
321      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
322      * to learn more about how these ids are created.
323      *
324      * This function call must use less than 30000 gas.
325      */
326     function supportsInterface(bytes4 interfaceId) external view returns (bool);
327 
328     // =============================================================
329     //                            IERC721
330     // =============================================================
331 
332     /**
333      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
334      */
335     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
339      */
340     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
341 
342     /**
343      * @dev Emitted when `owner` enables or disables
344      * (`approved`) `operator` to manage all of its assets.
345      */
346     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
347 
348     /**
349      * @dev Returns the number of tokens in `owner`'s account.
350      */
351     function balanceOf(address owner) external view returns (uint256 balance);
352 
353     /**
354      * @dev Returns the owner of the `tokenId` token.
355      *
356      * Requirements:
357      *
358      * - `tokenId` must exist.
359      */
360     function ownerOf(uint256 tokenId) external view returns (address owner);
361 
362     /**
363      * @dev Safely transfers `tokenId` token from `from` to `to`,
364      * checking first that contract recipients are aware of the ERC721 protocol
365      * to prevent tokens from being forever locked.
366      *
367      * Requirements:
368      *
369      * - `from` cannot be the zero address.
370      * - `to` cannot be the zero address.
371      * - `tokenId` token must exist and be owned by `from`.
372      * - If the caller is not `from`, it must be have been allowed to move
373      * this token by either {approve} or {setApprovalForAll}.
374      * - If `to` refers to a smart contract, it must implement
375      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
376      *
377      * Emits a {Transfer} event.
378      */
379     function safeTransferFrom(
380         address from,
381         address to,
382         uint256 tokenId,
383         bytes calldata data
384     ) external;
385 
386     /**
387      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
388      */
389     function safeTransferFrom(
390         address from,
391         address to,
392         uint256 tokenId
393     ) external;
394 
395     /**
396      * @dev Transfers `tokenId` from `from` to `to`.
397      *
398      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
399      * whenever possible.
400      *
401      * Requirements:
402      *
403      * - `from` cannot be the zero address.
404      * - `to` cannot be the zero address.
405      * - `tokenId` token must be owned by `from`.
406      * - If the caller is not `from`, it must be approved to move this token
407      * by either {approve} or {setApprovalForAll}.
408      *
409      * Emits a {Transfer} event.
410      */
411     function transferFrom(
412         address from,
413         address to,
414         uint256 tokenId
415     ) external;
416 
417     /**
418      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
419      * The approval is cleared when the token is transferred.
420      *
421      * Only a single account can be approved at a time, so approving the
422      * zero address clears previous approvals.
423      *
424      * Requirements:
425      *
426      * - The caller must own the token or be an approved operator.
427      * - `tokenId` must exist.
428      *
429      * Emits an {Approval} event.
430      */
431     function approve(address to, uint256 tokenId) external;
432 
433     /**
434      * @dev Approve or remove `operator` as an operator for the caller.
435      * Operators can call {transferFrom} or {safeTransferFrom}
436      * for any token owned by the caller.
437      *
438      * Requirements:
439      *
440      * - The `operator` cannot be the caller.
441      *
442      * Emits an {ApprovalForAll} event.
443      */
444     function setApprovalForAll(address operator, bool _approved) external;
445 
446     /**
447      * @dev Returns the account approved for `tokenId` token.
448      *
449      * Requirements:
450      *
451      * - `tokenId` must exist.
452      */
453     function getApproved(uint256 tokenId) external view returns (address operator);
454 
455     /**
456      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
457      *
458      * See {setApprovalForAll}.
459      */
460     function isApprovedForAll(address owner, address operator) external view returns (bool);
461 
462     // =============================================================
463     //                        IERC721Metadata
464     // =============================================================
465 
466     /**
467      * @dev Returns the token collection name.
468      */
469     function name() external view returns (string memory);
470 
471     /**
472      * @dev Returns the token collection symbol.
473      */
474     function symbol() external view returns (string memory);
475 
476     /**
477      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
478      */
479     function tokenURI(uint256 tokenId) external view returns (string memory);
480 
481     // =============================================================
482     //                           IERC2309
483     // =============================================================
484 
485     /**
486      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
487      * (inclusive) is transferred from `from` to `to`, as defined in the
488      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
489      *
490      * See {_mintERC2309} for more details.
491      */
492     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
493 }
494 // File: erc721a/contracts/ERC721A.sol
495 
496 
497 // ERC721A Contracts v4.2.2
498 // Creator: Chiru Labs
499 
500 pragma solidity ^0.8.4;
501 
502 
503 /**
504  * @dev Interface of ERC721 token receiver.
505  */
506 interface ERC721A__IERC721Receiver {
507     function onERC721Received(
508         address operator,
509         address from,
510         uint256 tokenId,
511         bytes calldata data
512     ) external returns (bytes4);
513 }
514 
515 /**
516  * @title ERC721A
517  *
518  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
519  * Non-Fungible Token Standard, including the Metadata extension.
520  * Optimized for lower gas during batch mints.
521  *
522  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
523  * starting from `_startTokenId()`.
524  *
525  * Assumptions:
526  *
527  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
528  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
529  */
530 contract ERC721A is IERC721A {
531     // Reference type for token approval.
532     struct TokenApprovalRef {
533         address value;
534     }
535 
536     // =============================================================
537     //                           CONSTANTS
538     // =============================================================
539 
540     // Mask of an entry in packed address data.
541     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
542 
543     // The bit position of `numberMinted` in packed address data.
544     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
545 
546     // The bit position of `numberBurned` in packed address data.
547     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
548 
549     // The bit position of `aux` in packed address data.
550     uint256 private constant _BITPOS_AUX = 192;
551 
552     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
553     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
554 
555     // The bit position of `startTimestamp` in packed ownership.
556     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
557 
558     // The bit mask of the `burned` bit in packed ownership.
559     uint256 private constant _BITMASK_BURNED = 1 << 224;
560 
561     // The bit position of the `nextInitialized` bit in packed ownership.
562     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
563 
564     // The bit mask of the `nextInitialized` bit in packed ownership.
565     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
566 
567     // The bit position of `extraData` in packed ownership.
568     uint256 private constant _BITPOS_EXTRA_DATA = 232;
569 
570     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
571     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
572 
573     // The mask of the lower 160 bits for addresses.
574     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
575 
576     // The maximum `quantity` that can be minted with {_mintERC2309}.
577     // This limit is to prevent overflows on the address data entries.
578     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
579     // is required to cause an overflow, which is unrealistic.
580     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
581 
582     // The `Transfer` event signature is given by:
583     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
584     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
585         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
586 
587     // =============================================================
588     //                            STORAGE
589     // =============================================================
590 
591     // The next token ID to be minted.
592     uint256 private _currentIndex;
593 
594     // The number of tokens burned.
595     uint256 private _burnCounter;
596 
597     // Token name
598     string private _name;
599 
600     // Token symbol
601     string private _symbol;
602 
603     // Mapping from token ID to ownership details
604     // An empty struct value does not necessarily mean the token is unowned.
605     // See {_packedOwnershipOf} implementation for details.
606     //
607     // Bits Layout:
608     // - [0..159]   `addr`
609     // - [160..223] `startTimestamp`
610     // - [224]      `burned`
611     // - [225]      `nextInitialized`
612     // - [232..255] `extraData`
613     mapping(uint256 => uint256) private _packedOwnerships;
614 
615     // Mapping owner address to address data.
616     //
617     // Bits Layout:
618     // - [0..63]    `balance`
619     // - [64..127]  `numberMinted`
620     // - [128..191] `numberBurned`
621     // - [192..255] `aux`
622     mapping(address => uint256) private _packedAddressData;
623 
624     // Mapping from token ID to approved address.
625     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
626 
627     // Mapping from owner to operator approvals
628     mapping(address => mapping(address => bool)) private _operatorApprovals;
629 
630     // =============================================================
631     //                          CONSTRUCTOR
632     // =============================================================
633 
634     constructor(string memory name_, string memory symbol_) {
635         _name = name_;
636         _symbol = symbol_;
637         _currentIndex = _startTokenId();
638     }
639 
640     // =============================================================
641     //                   TOKEN COUNTING OPERATIONS
642     // =============================================================
643 
644     /**
645      * @dev Returns the starting token ID.
646      * To change the starting token ID, please override this function.
647      */
648     function _startTokenId() internal view virtual returns (uint256) {
649         return 0;
650     }
651 
652     /**
653      * @dev Returns the next token ID to be minted.
654      */
655     function _nextTokenId() internal view virtual returns (uint256) {
656         return _currentIndex;
657     }
658 
659     /**
660      * @dev Returns the total number of tokens in existence.
661      * Burned tokens will reduce the count.
662      * To get the total number of tokens minted, please see {_totalMinted}.
663      */
664     function totalSupply() public view virtual override returns (uint256) {
665         // Counter underflow is impossible as _burnCounter cannot be incremented
666         // more than `_currentIndex - _startTokenId()` times.
667         unchecked {
668             return _currentIndex - _burnCounter - _startTokenId();
669         }
670     }
671 
672     /**
673      * @dev Returns the total amount of tokens minted in the contract.
674      */
675     function _totalMinted() internal view virtual returns (uint256) {
676         // Counter underflow is impossible as `_currentIndex` does not decrement,
677         // and it is initialized to `_startTokenId()`.
678         unchecked {
679             return _currentIndex - _startTokenId();
680         }
681     }
682 
683     /**
684      * @dev Returns the total number of tokens burned.
685      */
686     function _totalBurned() internal view virtual returns (uint256) {
687         return _burnCounter;
688     }
689 
690     // =============================================================
691     //                    ADDRESS DATA OPERATIONS
692     // =============================================================
693 
694     /**
695      * @dev Returns the number of tokens in `owner`'s account.
696      */
697     function balanceOf(address owner) public view virtual override returns (uint256) {
698         if (owner == address(0)) revert BalanceQueryForZeroAddress();
699         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
700     }
701 
702     /**
703      * Returns the number of tokens minted by `owner`.
704      */
705     function _numberMinted(address owner) internal view returns (uint256) {
706         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
707     }
708 
709     /**
710      * Returns the number of tokens burned by or on behalf of `owner`.
711      */
712     function _numberBurned(address owner) internal view returns (uint256) {
713         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
714     }
715 
716     /**
717      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
718      */
719     function _getAux(address owner) internal view returns (uint64) {
720         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
721     }
722 
723     /**
724      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
725      * If there are multiple variables, please pack them into a uint64.
726      */
727     function _setAux(address owner, uint64 aux) internal virtual {
728         uint256 packed = _packedAddressData[owner];
729         uint256 auxCasted;
730         // Cast `aux` with assembly to avoid redundant masking.
731         assembly {
732             auxCasted := aux
733         }
734         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
735         _packedAddressData[owner] = packed;
736     }
737 
738     // =============================================================
739     //                            IERC165
740     // =============================================================
741 
742     /**
743      * @dev Returns true if this contract implements the interface defined by
744      * `interfaceId`. See the corresponding
745      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
746      * to learn more about how these ids are created.
747      *
748      * This function call must use less than 30000 gas.
749      */
750     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
751         // The interface IDs are constants representing the first 4 bytes
752         // of the XOR of all function selectors in the interface.
753         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
754         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
755         return
756             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
757             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
758             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
759     }
760 
761     // =============================================================
762     //                        IERC721Metadata
763     // =============================================================
764 
765     /**
766      * @dev Returns the token collection name.
767      */
768     function name() public view virtual override returns (string memory) {
769         return _name;
770     }
771 
772     /**
773      * @dev Returns the token collection symbol.
774      */
775     function symbol() public view virtual override returns (string memory) {
776         return _symbol;
777     }
778 
779     /**
780      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
781      */
782     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
783         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
784 
785         string memory baseURI = _baseURI();
786         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
787     }
788 
789     /**
790      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
791      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
792      * by default, it can be overridden in child contracts.
793      */
794     function _baseURI() internal view virtual returns (string memory) {
795         return '';
796     }
797 
798     // =============================================================
799     //                     OWNERSHIPS OPERATIONS
800     // =============================================================
801 
802     /**
803      * @dev Returns the owner of the `tokenId` token.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must exist.
808      */
809     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
810         return address(uint160(_packedOwnershipOf(tokenId)));
811     }
812 
813     /**
814      * @dev Gas spent here starts off proportional to the maximum mint batch size.
815      * It gradually moves to O(1) as tokens get transferred around over time.
816      */
817     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
818         return _unpackedOwnership(_packedOwnershipOf(tokenId));
819     }
820 
821     /**
822      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
823      */
824     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
825         return _unpackedOwnership(_packedOwnerships[index]);
826     }
827 
828     /**
829      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
830      */
831     function _initializeOwnershipAt(uint256 index) internal virtual {
832         if (_packedOwnerships[index] == 0) {
833             _packedOwnerships[index] = _packedOwnershipOf(index);
834         }
835     }
836 
837     /**
838      * Returns the packed ownership data of `tokenId`.
839      */
840     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
841         uint256 curr = tokenId;
842 
843         unchecked {
844             if (_startTokenId() <= curr)
845                 if (curr < _currentIndex) {
846                     uint256 packed = _packedOwnerships[curr];
847                     // If not burned.
848                     if (packed & _BITMASK_BURNED == 0) {
849                         // Invariant:
850                         // There will always be an initialized ownership slot
851                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
852                         // before an unintialized ownership slot
853                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
854                         // Hence, `curr` will not underflow.
855                         //
856                         // We can directly compare the packed value.
857                         // If the address is zero, packed will be zero.
858                         while (packed == 0) {
859                             packed = _packedOwnerships[--curr];
860                         }
861                         return packed;
862                     }
863                 }
864         }
865         revert OwnerQueryForNonexistentToken();
866     }
867 
868     /**
869      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
870      */
871     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
872         ownership.addr = address(uint160(packed));
873         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
874         ownership.burned = packed & _BITMASK_BURNED != 0;
875         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
876     }
877 
878     /**
879      * @dev Packs ownership data into a single uint256.
880      */
881     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
882         assembly {
883             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
884             owner := and(owner, _BITMASK_ADDRESS)
885             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
886             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
887         }
888     }
889 
890     /**
891      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
892      */
893     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
894         // For branchless setting of the `nextInitialized` flag.
895         assembly {
896             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
897             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
898         }
899     }
900 
901     // =============================================================
902     //                      APPROVAL OPERATIONS
903     // =============================================================
904 
905     /**
906      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
907      * The approval is cleared when the token is transferred.
908      *
909      * Only a single account can be approved at a time, so approving the
910      * zero address clears previous approvals.
911      *
912      * Requirements:
913      *
914      * - The caller must own the token or be an approved operator.
915      * - `tokenId` must exist.
916      *
917      * Emits an {Approval} event.
918      */
919     function approve(address to, uint256 tokenId) public virtual override {
920         address owner = ownerOf(tokenId);
921 
922         if (_msgSenderERC721A() != owner)
923             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
924                 revert ApprovalCallerNotOwnerNorApproved();
925             }
926 
927         _tokenApprovals[tokenId].value = to;
928         emit Approval(owner, to, tokenId);
929     }
930 
931     /**
932      * @dev Returns the account approved for `tokenId` token.
933      *
934      * Requirements:
935      *
936      * - `tokenId` must exist.
937      */
938     function getApproved(uint256 tokenId) public view virtual override returns (address) {
939         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
940 
941         return _tokenApprovals[tokenId].value;
942     }
943 
944     /**
945      * @dev Approve or remove `operator` as an operator for the caller.
946      * Operators can call {transferFrom} or {safeTransferFrom}
947      * for any token owned by the caller.
948      *
949      * Requirements:
950      *
951      * - The `operator` cannot be the caller.
952      *
953      * Emits an {ApprovalForAll} event.
954      */
955     function setApprovalForAll(address operator, bool approved) public virtual override {
956         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
957 
958         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
959         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
960     }
961 
962     /**
963      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
964      *
965      * See {setApprovalForAll}.
966      */
967     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
968         return _operatorApprovals[owner][operator];
969     }
970 
971     /**
972      * @dev Returns whether `tokenId` exists.
973      *
974      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
975      *
976      * Tokens start existing when they are minted. See {_mint}.
977      */
978     function _exists(uint256 tokenId) internal view virtual returns (bool) {
979         return
980             _startTokenId() <= tokenId &&
981             tokenId < _currentIndex && // If within bounds,
982             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
983     }
984 
985     /**
986      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
987      */
988     function _isSenderApprovedOrOwner(
989         address approvedAddress,
990         address owner,
991         address msgSender
992     ) private pure returns (bool result) {
993         assembly {
994             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
995             owner := and(owner, _BITMASK_ADDRESS)
996             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
997             msgSender := and(msgSender, _BITMASK_ADDRESS)
998             // `msgSender == owner || msgSender == approvedAddress`.
999             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1000         }
1001     }
1002 
1003     /**
1004      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1005      */
1006     function _getApprovedSlotAndAddress(uint256 tokenId)
1007         private
1008         view
1009         returns (uint256 approvedAddressSlot, address approvedAddress)
1010     {
1011         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1012         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1013         assembly {
1014             approvedAddressSlot := tokenApproval.slot
1015             approvedAddress := sload(approvedAddressSlot)
1016         }
1017     }
1018 
1019     // =============================================================
1020     //                      TRANSFER OPERATIONS
1021     // =============================================================
1022 
1023     /**
1024      * @dev Transfers `tokenId` from `from` to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - `from` cannot be the zero address.
1029      * - `to` cannot be the zero address.
1030      * - `tokenId` token must be owned by `from`.
1031      * - If the caller is not `from`, it must be approved to move this token
1032      * by either {approve} or {setApprovalForAll}.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function transferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) public virtual override {
1041         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1042 
1043         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1044 
1045         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1046 
1047         // The nested ifs save around 20+ gas over a compound boolean condition.
1048         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1049             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1050 
1051         if (to == address(0)) revert TransferToZeroAddress();
1052 
1053         _beforeTokenTransfers(from, to, tokenId, 1);
1054 
1055         // Clear approvals from the previous owner.
1056         assembly {
1057             if approvedAddress {
1058                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1059                 sstore(approvedAddressSlot, 0)
1060             }
1061         }
1062 
1063         // Underflow of the sender's balance is impossible because we check for
1064         // ownership above and the recipient's balance can't realistically overflow.
1065         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1066         unchecked {
1067             // We can directly increment and decrement the balances.
1068             --_packedAddressData[from]; // Updates: `balance -= 1`.
1069             ++_packedAddressData[to]; // Updates: `balance += 1`.
1070 
1071             // Updates:
1072             // - `address` to the next owner.
1073             // - `startTimestamp` to the timestamp of transfering.
1074             // - `burned` to `false`.
1075             // - `nextInitialized` to `true`.
1076             _packedOwnerships[tokenId] = _packOwnershipData(
1077                 to,
1078                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1079             );
1080 
1081             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1082             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1083                 uint256 nextTokenId = tokenId + 1;
1084                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1085                 if (_packedOwnerships[nextTokenId] == 0) {
1086                     // If the next slot is within bounds.
1087                     if (nextTokenId != _currentIndex) {
1088                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1089                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1090                     }
1091                 }
1092             }
1093         }
1094 
1095         emit Transfer(from, to, tokenId);
1096         _afterTokenTransfers(from, to, tokenId, 1);
1097     }
1098 
1099     /**
1100      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1101      */
1102     function safeTransferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) public virtual override {
1107         safeTransferFrom(from, to, tokenId, '');
1108     }
1109 
1110     /**
1111      * @dev Safely transfers `tokenId` token from `from` to `to`.
1112      *
1113      * Requirements:
1114      *
1115      * - `from` cannot be the zero address.
1116      * - `to` cannot be the zero address.
1117      * - `tokenId` token must exist and be owned by `from`.
1118      * - If the caller is not `from`, it must be approved to move this token
1119      * by either {approve} or {setApprovalForAll}.
1120      * - If `to` refers to a smart contract, it must implement
1121      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function safeTransferFrom(
1126         address from,
1127         address to,
1128         uint256 tokenId,
1129         bytes memory _data
1130     ) public virtual override {
1131         transferFrom(from, to, tokenId);
1132         if (to.code.length != 0)
1133             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1134                 revert TransferToNonERC721ReceiverImplementer();
1135             }
1136     }
1137 
1138     /**
1139      * @dev Hook that is called before a set of serially-ordered token IDs
1140      * are about to be transferred. This includes minting.
1141      * And also called before burning one token.
1142      *
1143      * `startTokenId` - the first token ID to be transferred.
1144      * `quantity` - the amount to be transferred.
1145      *
1146      * Calling conditions:
1147      *
1148      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1149      * transferred to `to`.
1150      * - When `from` is zero, `tokenId` will be minted for `to`.
1151      * - When `to` is zero, `tokenId` will be burned by `from`.
1152      * - `from` and `to` are never both zero.
1153      */
1154     function _beforeTokenTransfers(
1155         address from,
1156         address to,
1157         uint256 startTokenId,
1158         uint256 quantity
1159     ) internal virtual {}
1160 
1161     /**
1162      * @dev Hook that is called after a set of serially-ordered token IDs
1163      * have been transferred. This includes minting.
1164      * And also called after one token has been burned.
1165      *
1166      * `startTokenId` - the first token ID to be transferred.
1167      * `quantity` - the amount to be transferred.
1168      *
1169      * Calling conditions:
1170      *
1171      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1172      * transferred to `to`.
1173      * - When `from` is zero, `tokenId` has been minted for `to`.
1174      * - When `to` is zero, `tokenId` has been burned by `from`.
1175      * - `from` and `to` are never both zero.
1176      */
1177     function _afterTokenTransfers(
1178         address from,
1179         address to,
1180         uint256 startTokenId,
1181         uint256 quantity
1182     ) internal virtual {}
1183 
1184     /**
1185      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1186      *
1187      * `from` - Previous owner of the given token ID.
1188      * `to` - Target address that will receive the token.
1189      * `tokenId` - Token ID to be transferred.
1190      * `_data` - Optional data to send along with the call.
1191      *
1192      * Returns whether the call correctly returned the expected magic value.
1193      */
1194     function _checkContractOnERC721Received(
1195         address from,
1196         address to,
1197         uint256 tokenId,
1198         bytes memory _data
1199     ) private returns (bool) {
1200         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1201             bytes4 retval
1202         ) {
1203             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1204         } catch (bytes memory reason) {
1205             if (reason.length == 0) {
1206                 revert TransferToNonERC721ReceiverImplementer();
1207             } else {
1208                 assembly {
1209                     revert(add(32, reason), mload(reason))
1210                 }
1211             }
1212         }
1213     }
1214 
1215     // =============================================================
1216     //                        MINT OPERATIONS
1217     // =============================================================
1218 
1219     /**
1220      * @dev Mints `quantity` tokens and transfers them to `to`.
1221      *
1222      * Requirements:
1223      *
1224      * - `to` cannot be the zero address.
1225      * - `quantity` must be greater than 0.
1226      *
1227      * Emits a {Transfer} event for each mint.
1228      */
1229     function _mint(address to, uint256 quantity) internal virtual {
1230         uint256 startTokenId = _currentIndex;
1231         if (quantity == 0) revert MintZeroQuantity();
1232 
1233         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1234 
1235         // Overflows are incredibly unrealistic.
1236         // `balance` and `numberMinted` have a maximum limit of 2**64.
1237         // `tokenId` has a maximum limit of 2**256.
1238         unchecked {
1239             // Updates:
1240             // - `balance += quantity`.
1241             // - `numberMinted += quantity`.
1242             //
1243             // We can directly add to the `balance` and `numberMinted`.
1244             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1245 
1246             // Updates:
1247             // - `address` to the owner.
1248             // - `startTimestamp` to the timestamp of minting.
1249             // - `burned` to `false`.
1250             // - `nextInitialized` to `quantity == 1`.
1251             _packedOwnerships[startTokenId] = _packOwnershipData(
1252                 to,
1253                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1254             );
1255 
1256             uint256 toMasked;
1257             uint256 end = startTokenId + quantity;
1258 
1259             // Use assembly to loop and emit the `Transfer` event for gas savings.
1260             assembly {
1261                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1262                 toMasked := and(to, _BITMASK_ADDRESS)
1263                 // Emit the `Transfer` event.
1264                 log4(
1265                     0, // Start of data (0, since no data).
1266                     0, // End of data (0, since no data).
1267                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1268                     0, // `address(0)`.
1269                     toMasked, // `to`.
1270                     startTokenId // `tokenId`.
1271                 )
1272 
1273                 for {
1274                     let tokenId := add(startTokenId, 1)
1275                 } iszero(eq(tokenId, end)) {
1276                     tokenId := add(tokenId, 1)
1277                 } {
1278                     // Emit the `Transfer` event. Similar to above.
1279                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1280                 }
1281             }
1282             if (toMasked == 0) revert MintToZeroAddress();
1283 
1284             _currentIndex = end;
1285         }
1286         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1287     }
1288 
1289     /**
1290      * @dev Mints `quantity` tokens and transfers them to `to`.
1291      *
1292      * This function is intended for efficient minting only during contract creation.
1293      *
1294      * It emits only one {ConsecutiveTransfer} as defined in
1295      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1296      * instead of a sequence of {Transfer} event(s).
1297      *
1298      * Calling this function outside of contract creation WILL make your contract
1299      * non-compliant with the ERC721 standard.
1300      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1301      * {ConsecutiveTransfer} event is only permissible during contract creation.
1302      *
1303      * Requirements:
1304      *
1305      * - `to` cannot be the zero address.
1306      * - `quantity` must be greater than 0.
1307      *
1308      * Emits a {ConsecutiveTransfer} event.
1309      */
1310     function _mintERC2309(address to, uint256 quantity) internal virtual {
1311         uint256 startTokenId = _currentIndex;
1312         if (to == address(0)) revert MintToZeroAddress();
1313         if (quantity == 0) revert MintZeroQuantity();
1314         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1315 
1316         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1317 
1318         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1319         unchecked {
1320             // Updates:
1321             // - `balance += quantity`.
1322             // - `numberMinted += quantity`.
1323             //
1324             // We can directly add to the `balance` and `numberMinted`.
1325             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1326 
1327             // Updates:
1328             // - `address` to the owner.
1329             // - `startTimestamp` to the timestamp of minting.
1330             // - `burned` to `false`.
1331             // - `nextInitialized` to `quantity == 1`.
1332             _packedOwnerships[startTokenId] = _packOwnershipData(
1333                 to,
1334                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1335             );
1336 
1337             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1338 
1339             _currentIndex = startTokenId + quantity;
1340         }
1341         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1342     }
1343 
1344     /**
1345      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1346      *
1347      * Requirements:
1348      *
1349      * - If `to` refers to a smart contract, it must implement
1350      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1351      * - `quantity` must be greater than 0.
1352      *
1353      * See {_mint}.
1354      *
1355      * Emits a {Transfer} event for each mint.
1356      */
1357     function _safeMint(
1358         address to,
1359         uint256 quantity,
1360         bytes memory _data
1361     ) internal virtual {
1362         _mint(to, quantity);
1363 
1364         unchecked {
1365             if (to.code.length != 0) {
1366                 uint256 end = _currentIndex;
1367                 uint256 index = end - quantity;
1368                 do {
1369                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1370                         revert TransferToNonERC721ReceiverImplementer();
1371                     }
1372                 } while (index < end);
1373                 // Reentrancy protection.
1374                 if (_currentIndex != end) revert();
1375             }
1376         }
1377     }
1378 
1379     /**
1380      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1381      */
1382     function _safeMint(address to, uint256 quantity) internal virtual {
1383         _safeMint(to, quantity, '');
1384     }
1385 
1386     // =============================================================
1387     //                        BURN OPERATIONS
1388     // =============================================================
1389 
1390     /**
1391      * @dev Equivalent to `_burn(tokenId, false)`.
1392      */
1393     function _burn(uint256 tokenId) internal virtual {
1394         _burn(tokenId, false);
1395     }
1396 
1397     /**
1398      * @dev Destroys `tokenId`.
1399      * The approval is cleared when the token is burned.
1400      *
1401      * Requirements:
1402      *
1403      * - `tokenId` must exist.
1404      *
1405      * Emits a {Transfer} event.
1406      */
1407     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1408         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1409 
1410         address from = address(uint160(prevOwnershipPacked));
1411 
1412         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1413 
1414         if (approvalCheck) {
1415             // The nested ifs save around 20+ gas over a compound boolean condition.
1416             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1417                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1418         }
1419 
1420         _beforeTokenTransfers(from, address(0), tokenId, 1);
1421 
1422         // Clear approvals from the previous owner.
1423         assembly {
1424             if approvedAddress {
1425                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1426                 sstore(approvedAddressSlot, 0)
1427             }
1428         }
1429 
1430         // Underflow of the sender's balance is impossible because we check for
1431         // ownership above and the recipient's balance can't realistically overflow.
1432         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1433         unchecked {
1434             // Updates:
1435             // - `balance -= 1`.
1436             // - `numberBurned += 1`.
1437             //
1438             // We can directly decrement the balance, and increment the number burned.
1439             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1440             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1441 
1442             // Updates:
1443             // - `address` to the last owner.
1444             // - `startTimestamp` to the timestamp of burning.
1445             // - `burned` to `true`.
1446             // - `nextInitialized` to `true`.
1447             _packedOwnerships[tokenId] = _packOwnershipData(
1448                 from,
1449                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1450             );
1451 
1452             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1453             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1454                 uint256 nextTokenId = tokenId + 1;
1455                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1456                 if (_packedOwnerships[nextTokenId] == 0) {
1457                     // If the next slot is within bounds.
1458                     if (nextTokenId != _currentIndex) {
1459                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1460                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1461                     }
1462                 }
1463             }
1464         }
1465 
1466         emit Transfer(from, address(0), tokenId);
1467         _afterTokenTransfers(from, address(0), tokenId, 1);
1468 
1469         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1470         unchecked {
1471             _burnCounter++;
1472         }
1473     }
1474 
1475     // =============================================================
1476     //                     EXTRA DATA OPERATIONS
1477     // =============================================================
1478 
1479     /**
1480      * @dev Directly sets the extra data for the ownership data `index`.
1481      */
1482     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1483         uint256 packed = _packedOwnerships[index];
1484         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1485         uint256 extraDataCasted;
1486         // Cast `extraData` with assembly to avoid redundant masking.
1487         assembly {
1488             extraDataCasted := extraData
1489         }
1490         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1491         _packedOwnerships[index] = packed;
1492     }
1493 
1494     /**
1495      * @dev Called during each token transfer to set the 24bit `extraData` field.
1496      * Intended to be overridden by the cosumer contract.
1497      *
1498      * `previousExtraData` - the value of `extraData` before transfer.
1499      *
1500      * Calling conditions:
1501      *
1502      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1503      * transferred to `to`.
1504      * - When `from` is zero, `tokenId` will be minted for `to`.
1505      * - When `to` is zero, `tokenId` will be burned by `from`.
1506      * - `from` and `to` are never both zero.
1507      */
1508     function _extraData(
1509         address from,
1510         address to,
1511         uint24 previousExtraData
1512     ) internal view virtual returns (uint24) {}
1513 
1514     /**
1515      * @dev Returns the next extra data for the packed ownership data.
1516      * The returned result is shifted into position.
1517      */
1518     function _nextExtraData(
1519         address from,
1520         address to,
1521         uint256 prevOwnershipPacked
1522     ) private view returns (uint256) {
1523         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1524         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1525     }
1526 
1527     // =============================================================
1528     //                       OTHER OPERATIONS
1529     // =============================================================
1530 
1531     /**
1532      * @dev Returns the message sender (defaults to `msg.sender`).
1533      *
1534      * If you are writing GSN compatible contracts, you need to override this function.
1535      */
1536     function _msgSenderERC721A() internal view virtual returns (address) {
1537         return msg.sender;
1538     }
1539 
1540     /**
1541      * @dev Converts a uint256 to its ASCII string decimal representation.
1542      */
1543     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1544         assembly {
1545             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1546             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1547             // We will need 1 32-byte word to store the length,
1548             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1549             str := add(mload(0x40), 0x80)
1550             // Update the free memory pointer to allocate.
1551             mstore(0x40, str)
1552 
1553             // Cache the end of the memory to calculate the length later.
1554             let end := str
1555 
1556             // We write the string from rightmost digit to leftmost digit.
1557             // The following is essentially a do-while loop that also handles the zero case.
1558             // prettier-ignore
1559             for { let temp := value } 1 {} {
1560                 str := sub(str, 1)
1561                 // Write the character to the pointer.
1562                 // The ASCII index of the '0' character is 48.
1563                 mstore8(str, add(48, mod(temp, 10)))
1564                 // Keep dividing `temp` until zero.
1565                 temp := div(temp, 10)
1566                 // prettier-ignore
1567                 if iszero(temp) { break }
1568             }
1569 
1570             let length := sub(end, str)
1571             // Move the pointer 32 bytes leftwards to make room for the length.
1572             str := sub(str, 0x20)
1573             // Store the length.
1574             mstore(str, length)
1575         }
1576     }
1577 }
1578 
1579 // File: contracts/NOBODYS.sol
1580 
1581 pragma solidity ^0.8.4;
1582 
1583 contract NOBODYS is ERC721A, Ownable {
1584 
1585     using Strings for uint256;
1586 
1587     string public baseURI = "https://nobodys.s3.amazonaws.com/metadata/";
1588 
1589     uint256 public price = 0.001 ether;
1590     uint256 public maxPerTx = 10;
1591     uint256 public maxSupply = 10000;
1592 
1593     uint256 public maxFreePerWallet = 1;
1594     uint256 public totalFreeMinted = 0;
1595     uint256 public maxFreeSupply = 5000;
1596 
1597     mapping(address => uint256) public _mintedFreeAmount;
1598 
1599     constructor() ERC721A("NOBODYS Official", "NOBODYS") {}
1600 
1601     function mint(uint256 _amount) external payable {
1602 
1603         require(msg.value >= _amount * price, "Incorrect amount of ETH.");
1604         require(totalSupply() + _amount <= maxSupply, "Sold out.");
1605         require(tx.origin == msg.sender, "Only humans please.");
1606         require(_amount <= maxPerTx, "You may only mint a max of 10 per transaction");
1607 
1608         _mint(msg.sender, _amount);
1609     }
1610 
1611     function mintFree(uint256 _amount) external payable {
1612         require(_mintedFreeAmount[msg.sender] + _amount <= maxFreePerWallet, "You have minted the max free amount allowed per wallet.");
1613 		require(totalFreeMinted + _amount <= maxFreeSupply, "Cannot exceed Free supply." );
1614         require(totalSupply() + _amount <= maxSupply, "Sold out.");
1615 
1616         _mintedFreeAmount[msg.sender]++;
1617         totalFreeMinted++;
1618         _safeMint(msg.sender, _amount);
1619 	}
1620 
1621     function teamMint(uint256 _amount, address _wallet) external onlyOwner {
1622         require(totalSupply() + _amount <= maxSupply);
1623         _mint(_wallet, _amount);
1624     }
1625 
1626     function tokenURI(uint256 tokenId)
1627         public view virtual override returns (string memory) {
1628         require(
1629             _exists(tokenId),
1630             "ERC721Metadata: URI query for nonexistent token"
1631         );
1632         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1633     }
1634 
1635     function setBaseURI(string calldata baseURI_) external onlyOwner {
1636         baseURI = baseURI_;
1637     }
1638 
1639     function setPrice(uint256 _price) external onlyOwner {
1640         price = _price;
1641     }
1642 
1643     function setMaxPerTx(uint256 _amount) external onlyOwner {
1644         maxPerTx = _amount;
1645     }
1646 
1647     function reduceSupply(uint256 _newSupply) external onlyOwner {
1648         require(_newSupply < maxSupply);
1649         maxSupply = _newSupply;
1650     }
1651 
1652     function setmaxFreeSupply(uint256 _newMaxFreeSupply) public onlyOwner {
1653         maxFreeSupply = _newMaxFreeSupply;
1654     }
1655 
1656     function _startTokenId() internal pure override returns (uint256) {
1657         return 1;
1658     }
1659 
1660     function withdraw() external onlyOwner {
1661         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1662         require(success, "Transfer failed.");
1663     }
1664 
1665 }