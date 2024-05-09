1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 
30 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
31 
32 
33 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev String operations.
39  */
40 library Strings {
41     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
42     uint8 private constant _ADDRESS_LENGTH = 20;
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
46      */
47     function toString(uint256 value) internal pure returns (string memory) {
48         // Inspired by OraclizeAPI's implementation - MIT licence
49         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
50 
51         if (value == 0) {
52             return "0";
53         }
54         uint256 temp = value;
55         uint256 digits;
56         while (temp != 0) {
57             digits++;
58             temp /= 10;
59         }
60         bytes memory buffer = new bytes(digits);
61         while (value != 0) {
62             digits -= 1;
63             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
64             value /= 10;
65         }
66         return string(buffer);
67     }
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
71      */
72     function toHexString(uint256 value) internal pure returns (string memory) {
73         if (value == 0) {
74             return "0x00";
75         }
76         uint256 temp = value;
77         uint256 length = 0;
78         while (temp != 0) {
79             length++;
80             temp >>= 8;
81         }
82         return toHexString(value, length);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
87      */
88     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
89         bytes memory buffer = new bytes(2 * length + 2);
90         buffer[0] = "0";
91         buffer[1] = "x";
92         for (uint256 i = 2 * length + 1; i > 1; --i) {
93             buffer[i] = _HEX_SYMBOLS[value & 0xf];
94             value >>= 4;
95         }
96         require(value == 0, "Strings: hex length insufficient");
97         return string(buffer);
98     }
99 
100     /**
101      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
102      */
103     function toHexString(address addr) internal pure returns (string memory) {
104         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
105     }
106 }
107 
108 // File: @openzeppelin/contracts/access/Ownable.sol
109 
110 
111 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 
116 /**
117  * @dev Contract module which provides a basic access control mechanism, where
118  * there is an account (an owner) that can be granted exclusive access to
119  * specific functions.
120  *
121  * By default, the owner account will be the one that deploys the contract. This
122  * can later be changed with {transferOwnership}.
123  *
124  * This module is used through inheritance. It will make available the modifier
125  * `onlyOwner`, which can be applied to your functions to restrict their use to
126  * the owner.
127  */
128 abstract contract Ownable is Context {
129     address private _owner;
130 
131     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
132 
133     /**
134      * @dev Initializes the contract setting the deployer as the initial owner.
135      */
136     constructor() {
137         _transferOwnership(_msgSender());
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         _checkOwner();
145         _;
146     }
147 
148     /**
149      * @dev Returns the address of the current owner.
150      */
151     function owner() public view virtual returns (address) {
152         return _owner;
153     }
154 
155     /**
156      * @dev Throws if the sender is not the owner.
157      */
158     function _checkOwner() internal view virtual {
159         require(owner() == _msgSender(), "Ownable: caller is not the owner");
160     }
161 
162     /**
163      * @dev Leaves the contract without owner. It will not be possible to call
164      * `onlyOwner` functions anymore. Can only be called by the current owner.
165      *
166      * NOTE: Renouncing ownership will leave the contract without an owner,
167      * thereby removing any functionality that is only available to the owner.
168      */
169     function renounceOwnership() public virtual onlyOwner {
170         _transferOwnership(address(0));
171     }
172 
173     /**
174      * @dev Transfers ownership of the contract to a new account (`newOwner`).
175      * Can only be called by the current owner.
176      */
177     function transferOwnership(address newOwner) public virtual onlyOwner {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         _transferOwnership(newOwner);
180     }
181 
182     /**
183      * @dev Transfers ownership of the contract to a new account (`newOwner`).
184      * Internal function without access restriction.
185      */
186     function _transferOwnership(address newOwner) internal virtual {
187         address oldOwner = _owner;
188         _owner = newOwner;
189         emit OwnershipTransferred(oldOwner, newOwner);
190     }
191 }
192 
193 // File: erc721a/contracts/IERC721A.sol
194 
195 
196 // ERC721A Contracts v4.2.2
197 // Creator: Chiru Labs
198 
199 pragma solidity ^0.8.4;
200 
201 /**
202  * @dev Interface of ERC721A.
203  */
204 interface IERC721A {
205     /**
206      * The caller must own the token or be an approved operator.
207      */
208     error ApprovalCallerNotOwnerNorApproved();
209 
210     /**
211      * The token does not exist.
212      */
213     error ApprovalQueryForNonexistentToken();
214 
215     /**
216      * The caller cannot approve to their own address.
217      */
218     error ApproveToCaller();
219 
220     /**
221      * Cannot query the balance for the zero address.
222      */
223     error BalanceQueryForZeroAddress();
224 
225     /**
226      * Cannot mint to the zero address.
227      */
228     error MintToZeroAddress();
229 
230     /**
231      * The quantity of tokens minted must be more than zero.
232      */
233     error MintZeroQuantity();
234 
235     /**
236      * The token does not exist.
237      */
238     error OwnerQueryForNonexistentToken();
239 
240     /**
241      * The caller must own the token or be an approved operator.
242      */
243     error TransferCallerNotOwnerNorApproved();
244 
245     /**
246      * The token must be owned by `from`.
247      */
248     error TransferFromIncorrectOwner();
249 
250     /**
251      * Cannot safely transfer to a contract that does not implement the
252      * ERC721Receiver interface.
253      */
254     error TransferToNonERC721ReceiverImplementer();
255 
256     /**
257      * Cannot transfer to the zero address.
258      */
259     error TransferToZeroAddress();
260 
261     /**
262      * The token does not exist.
263      */
264     error URIQueryForNonexistentToken();
265 
266     /**
267      * The `quantity` minted with ERC2309 exceeds the safety limit.
268      */
269     error MintERC2309QuantityExceedsLimit();
270 
271     /**
272      * The `extraData` cannot be set on an unintialized ownership slot.
273      */
274     error OwnershipNotInitializedForExtraData();
275 
276     // =============================================================
277     //                            STRUCTS
278     // =============================================================
279 
280     struct TokenOwnership {
281         // The address of the owner.
282         address addr;
283         // Stores the start time of ownership with minimal overhead for tokenomics.
284         uint64 startTimestamp;
285         // Whether the token has been burned.
286         bool burned;
287         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
288         uint24 extraData;
289     }
290 
291     // =============================================================
292     //                         TOKEN COUNTERS
293     // =============================================================
294 
295     /**
296      * @dev Returns the total number of tokens in existence.
297      * Burned tokens will reduce the count.
298      * To get the total number of tokens minted, please see {_totalMinted}.
299      */
300     function totalSupply() external view returns (uint256);
301 
302     // =============================================================
303     //                            IERC165
304     // =============================================================
305 
306     /**
307      * @dev Returns true if this contract implements the interface defined by
308      * `interfaceId`. See the corresponding
309      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
310      * to learn more about how these ids are created.
311      *
312      * This function call must use less than 30000 gas.
313      */
314     function supportsInterface(bytes4 interfaceId) external view returns (bool);
315 
316     // =============================================================
317     //                            IERC721
318     // =============================================================
319 
320     /**
321      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
322      */
323     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
324 
325     /**
326      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
327      */
328     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
329 
330     /**
331      * @dev Emitted when `owner` enables or disables
332      * (`approved`) `operator` to manage all of its assets.
333      */
334     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
335 
336     /**
337      * @dev Returns the number of tokens in `owner`'s account.
338      */
339     function balanceOf(address owner) external view returns (uint256 balance);
340 
341     /**
342      * @dev Returns the owner of the `tokenId` token.
343      *
344      * Requirements:
345      *
346      * - `tokenId` must exist.
347      */
348     function ownerOf(uint256 tokenId) external view returns (address owner);
349 
350     /**
351      * @dev Safely transfers `tokenId` token from `from` to `to`,
352      * checking first that contract recipients are aware of the ERC721 protocol
353      * to prevent tokens from being forever locked.
354      *
355      * Requirements:
356      *
357      * - `from` cannot be the zero address.
358      * - `to` cannot be the zero address.
359      * - `tokenId` token must exist and be owned by `from`.
360      * - If the caller is not `from`, it must be have been allowed to move
361      * this token by either {approve} or {setApprovalForAll}.
362      * - If `to` refers to a smart contract, it must implement
363      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
364      *
365      * Emits a {Transfer} event.
366      */
367     function safeTransferFrom(
368         address from,
369         address to,
370         uint256 tokenId,
371         bytes calldata data
372     ) external;
373 
374     /**
375      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
376      */
377     function safeTransferFrom(
378         address from,
379         address to,
380         uint256 tokenId
381     ) external;
382 
383     /**
384      * @dev Transfers `tokenId` from `from` to `to`.
385      *
386      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
387      * whenever possible.
388      *
389      * Requirements:
390      *
391      * - `from` cannot be the zero address.
392      * - `to` cannot be the zero address.
393      * - `tokenId` token must be owned by `from`.
394      * - If the caller is not `from`, it must be approved to move this token
395      * by either {approve} or {setApprovalForAll}.
396      *
397      * Emits a {Transfer} event.
398      */
399     function transferFrom(
400         address from,
401         address to,
402         uint256 tokenId
403     ) external;
404 
405     /**
406      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
407      * The approval is cleared when the token is transferred.
408      *
409      * Only a single account can be approved at a time, so approving the
410      * zero address clears previous approvals.
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
423      * Operators can call {transferFrom} or {safeTransferFrom}
424      * for any token owned by the caller.
425      *
426      * Requirements:
427      *
428      * - The `operator` cannot be the caller.
429      *
430      * Emits an {ApprovalForAll} event.
431      */
432     function setApprovalForAll(address operator, bool _approved) external;
433 
434     /**
435      * @dev Returns the account approved for `tokenId` token.
436      *
437      * Requirements:
438      *
439      * - `tokenId` must exist.
440      */
441     function getApproved(uint256 tokenId) external view returns (address operator);
442 
443     /**
444      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
445      *
446      * See {setApprovalForAll}.
447      */
448     function isApprovedForAll(address owner, address operator) external view returns (bool);
449 
450     // =============================================================
451     //                        IERC721Metadata
452     // =============================================================
453 
454     /**
455      * @dev Returns the token collection name.
456      */
457     function name() external view returns (string memory);
458 
459     /**
460      * @dev Returns the token collection symbol.
461      */
462     function symbol() external view returns (string memory);
463 
464     /**
465      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
466      */
467     function tokenURI(uint256 tokenId) external view returns (string memory);
468 
469     // =============================================================
470     //                           IERC2309
471     // =============================================================
472 
473     /**
474      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
475      * (inclusive) is transferred from `from` to `to`, as defined in the
476      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
477      *
478      * See {_mintERC2309} for more details.
479      */
480     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
481 }
482 // File: erc721a/contracts/ERC721A.sol
483 
484 
485 // ERC721A Contracts v4.2.2
486 // Creator: Chiru Labs
487 
488 pragma solidity ^0.8.4;
489 
490 
491 /**
492  * @dev Interface of ERC721 token receiver.
493  */
494 interface ERC721A__IERC721Receiver {
495     function onERC721Received(
496         address operator,
497         address from,
498         uint256 tokenId,
499         bytes calldata data
500     ) external returns (bytes4);
501 }
502 
503 /**
504  * @title ERC721A
505  *
506  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
507  * Non-Fungible Token Standard, including the Metadata extension.
508  * Optimized for lower gas during batch mints.
509  *
510  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
511  * starting from `_startTokenId()`.
512  *
513  * Assumptions:
514  *
515  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
516  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
517  */
518 contract ERC721A is IERC721A {
519     // Reference type for token approval.
520     struct TokenApprovalRef {
521         address value;
522     }
523 
524     // =============================================================
525     //                           CONSTANTS
526     // =============================================================
527 
528     // Mask of an entry in packed address data.
529     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
530 
531     // The bit position of `numberMinted` in packed address data.
532     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
533 
534     // The bit position of `numberBurned` in packed address data.
535     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
536 
537     // The bit position of `aux` in packed address data.
538     uint256 private constant _BITPOS_AUX = 192;
539 
540     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
541     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
542 
543     // The bit position of `startTimestamp` in packed ownership.
544     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
545 
546     // The bit mask of the `burned` bit in packed ownership.
547     uint256 private constant _BITMASK_BURNED = 1 << 224;
548 
549     // The bit position of the `nextInitialized` bit in packed ownership.
550     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
551 
552     // The bit mask of the `nextInitialized` bit in packed ownership.
553     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
554 
555     // The bit position of `extraData` in packed ownership.
556     uint256 private constant _BITPOS_EXTRA_DATA = 232;
557 
558     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
559     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
560 
561     // The mask of the lower 160 bits for addresses.
562     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
563 
564     // The maximum `quantity` that can be minted with {_mintERC2309}.
565     // This limit is to prevent overflows on the address data entries.
566     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
567     // is required to cause an overflow, which is unrealistic.
568     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
569 
570     // The `Transfer` event signature is given by:
571     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
572     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
573         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
574 
575     // =============================================================
576     //                            STORAGE
577     // =============================================================
578 
579     // The next token ID to be minted.
580     uint256 private _currentIndex;
581 
582     // The number of tokens burned.
583     uint256 private _burnCounter;
584 
585     // Token name
586     string private _name;
587 
588     // Token symbol
589     string private _symbol;
590 
591     // Mapping from token ID to ownership details
592     // An empty struct value does not necessarily mean the token is unowned.
593     // See {_packedOwnershipOf} implementation for details.
594     //
595     // Bits Layout:
596     // - [0..159]   `addr`
597     // - [160..223] `startTimestamp`
598     // - [224]      `burned`
599     // - [225]      `nextInitialized`
600     // - [232..255] `extraData`
601     mapping(uint256 => uint256) private _packedOwnerships;
602 
603     // Mapping owner address to address data.
604     //
605     // Bits Layout:
606     // - [0..63]    `balance`
607     // - [64..127]  `numberMinted`
608     // - [128..191] `numberBurned`
609     // - [192..255] `aux`
610     mapping(address => uint256) private _packedAddressData;
611 
612     // Mapping from token ID to approved address.
613     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
614 
615     // Mapping from owner to operator approvals
616     mapping(address => mapping(address => bool)) private _operatorApprovals;
617 
618     // =============================================================
619     //                          CONSTRUCTOR
620     // =============================================================
621 
622     constructor(string memory name_, string memory symbol_) {
623         _name = name_;
624         _symbol = symbol_;
625         _currentIndex = _startTokenId();
626     }
627 
628     // =============================================================
629     //                   TOKEN COUNTING OPERATIONS
630     // =============================================================
631 
632     /**
633      * @dev Returns the starting token ID.
634      * To change the starting token ID, please override this function.
635      */
636     function _startTokenId() internal view virtual returns (uint256) {
637         return 0;
638     }
639 
640     /**
641      * @dev Returns the next token ID to be minted.
642      */
643     function _nextTokenId() internal view virtual returns (uint256) {
644         return _currentIndex;
645     }
646 
647     /**
648      * @dev Returns the total number of tokens in existence.
649      * Burned tokens will reduce the count.
650      * To get the total number of tokens minted, please see {_totalMinted}.
651      */
652     function totalSupply() public view virtual override returns (uint256) {
653         // Counter underflow is impossible as _burnCounter cannot be incremented
654         // more than `_currentIndex - _startTokenId()` times.
655         unchecked {
656             return _currentIndex - _burnCounter - _startTokenId();
657         }
658     }
659 
660     /**
661      * @dev Returns the total amount of tokens minted in the contract.
662      */
663     function _totalMinted() internal view virtual returns (uint256) {
664         // Counter underflow is impossible as `_currentIndex` does not decrement,
665         // and it is initialized to `_startTokenId()`.
666         unchecked {
667             return _currentIndex - _startTokenId();
668         }
669     }
670 
671     /**
672      * @dev Returns the total number of tokens burned.
673      */
674     function _totalBurned() internal view virtual returns (uint256) {
675         return _burnCounter;
676     }
677 
678     // =============================================================
679     //                    ADDRESS DATA OPERATIONS
680     // =============================================================
681 
682     /**
683      * @dev Returns the number of tokens in `owner`'s account.
684      */
685     function balanceOf(address owner) public view virtual override returns (uint256) {
686         if (owner == address(0)) revert BalanceQueryForZeroAddress();
687         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
688     }
689 
690     /**
691      * Returns the number of tokens minted by `owner`.
692      */
693     function _numberMinted(address owner) internal view returns (uint256) {
694         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
695     }
696 
697     /**
698      * Returns the number of tokens burned by or on behalf of `owner`.
699      */
700     function _numberBurned(address owner) internal view returns (uint256) {
701         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
702     }
703 
704     /**
705      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
706      */
707     function _getAux(address owner) internal view returns (uint64) {
708         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
709     }
710 
711     /**
712      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
713      * If there are multiple variables, please pack them into a uint64.
714      */
715     function _setAux(address owner, uint64 aux) internal virtual {
716         uint256 packed = _packedAddressData[owner];
717         uint256 auxCasted;
718         // Cast `aux` with assembly to avoid redundant masking.
719         assembly {
720             auxCasted := aux
721         }
722         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
723         _packedAddressData[owner] = packed;
724     }
725 
726     // =============================================================
727     //                            IERC165
728     // =============================================================
729 
730     /**
731      * @dev Returns true if this contract implements the interface defined by
732      * `interfaceId`. See the corresponding
733      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
734      * to learn more about how these ids are created.
735      *
736      * This function call must use less than 30000 gas.
737      */
738     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
739         // The interface IDs are constants representing the first 4 bytes
740         // of the XOR of all function selectors in the interface.
741         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
742         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
743         return
744             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
745             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
746             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
747     }
748 
749     // =============================================================
750     //                        IERC721Metadata
751     // =============================================================
752 
753     /**
754      * @dev Returns the token collection name.
755      */
756     function name() public view virtual override returns (string memory) {
757         return _name;
758     }
759 
760     /**
761      * @dev Returns the token collection symbol.
762      */
763     function symbol() public view virtual override returns (string memory) {
764         return _symbol;
765     }
766 
767     /**
768      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
769      */
770     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
771         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
772 
773         string memory baseURI = _baseURI();
774         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
775     }
776 
777     /**
778      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
779      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
780      * by default, it can be overridden in child contracts.
781      */
782     function _baseURI() internal view virtual returns (string memory) {
783         return '';
784     }
785 
786     // =============================================================
787     //                     OWNERSHIPS OPERATIONS
788     // =============================================================
789 
790     /**
791      * @dev Returns the owner of the `tokenId` token.
792      *
793      * Requirements:
794      *
795      * - `tokenId` must exist.
796      */
797     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
798         return address(uint160(_packedOwnershipOf(tokenId)));
799     }
800 
801     /**
802      * @dev Gas spent here starts off proportional to the maximum mint batch size.
803      * It gradually moves to O(1) as tokens get transferred around over time.
804      */
805     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
806         return _unpackedOwnership(_packedOwnershipOf(tokenId));
807     }
808 
809     /**
810      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
811      */
812     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
813         return _unpackedOwnership(_packedOwnerships[index]);
814     }
815 
816     /**
817      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
818      */
819     function _initializeOwnershipAt(uint256 index) internal virtual {
820         if (_packedOwnerships[index] == 0) {
821             _packedOwnerships[index] = _packedOwnershipOf(index);
822         }
823     }
824 
825     /**
826      * Returns the packed ownership data of `tokenId`.
827      */
828     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
829         uint256 curr = tokenId;
830 
831         unchecked {
832             if (_startTokenId() <= curr)
833                 if (curr < _currentIndex) {
834                     uint256 packed = _packedOwnerships[curr];
835                     // If not burned.
836                     if (packed & _BITMASK_BURNED == 0) {
837                         // Invariant:
838                         // There will always be an initialized ownership slot
839                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
840                         // before an unintialized ownership slot
841                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
842                         // Hence, `curr` will not underflow.
843                         //
844                         // We can directly compare the packed value.
845                         // If the address is zero, packed will be zero.
846                         while (packed == 0) {
847                             packed = _packedOwnerships[--curr];
848                         }
849                         return packed;
850                     }
851                 }
852         }
853         revert OwnerQueryForNonexistentToken();
854     }
855 
856     /**
857      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
858      */
859     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
860         ownership.addr = address(uint160(packed));
861         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
862         ownership.burned = packed & _BITMASK_BURNED != 0;
863         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
864     }
865 
866     /**
867      * @dev Packs ownership data into a single uint256.
868      */
869     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
870         assembly {
871             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
872             owner := and(owner, _BITMASK_ADDRESS)
873             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
874             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
875         }
876     }
877 
878     /**
879      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
880      */
881     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
882         // For branchless setting of the `nextInitialized` flag.
883         assembly {
884             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
885             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
886         }
887     }
888 
889     // =============================================================
890     //                      APPROVAL OPERATIONS
891     // =============================================================
892 
893     /**
894      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
895      * The approval is cleared when the token is transferred.
896      *
897      * Only a single account can be approved at a time, so approving the
898      * zero address clears previous approvals.
899      *
900      * Requirements:
901      *
902      * - The caller must own the token or be an approved operator.
903      * - `tokenId` must exist.
904      *
905      * Emits an {Approval} event.
906      */
907     function approve(address to, uint256 tokenId) public virtual override {
908         address owner = ownerOf(tokenId);
909 
910         if (_msgSenderERC721A() != owner)
911             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
912                 revert ApprovalCallerNotOwnerNorApproved();
913             }
914 
915         _tokenApprovals[tokenId].value = to;
916         emit Approval(owner, to, tokenId);
917     }
918 
919     /**
920      * @dev Returns the account approved for `tokenId` token.
921      *
922      * Requirements:
923      *
924      * - `tokenId` must exist.
925      */
926     function getApproved(uint256 tokenId) public view virtual override returns (address) {
927         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
928 
929         return _tokenApprovals[tokenId].value;
930     }
931 
932     /**
933      * @dev Approve or remove `operator` as an operator for the caller.
934      * Operators can call {transferFrom} or {safeTransferFrom}
935      * for any token owned by the caller.
936      *
937      * Requirements:
938      *
939      * - The `operator` cannot be the caller.
940      *
941      * Emits an {ApprovalForAll} event.
942      */
943     function setApprovalForAll(address operator, bool approved) public virtual override {
944         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
945 
946         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
947         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
948     }
949 
950     /**
951      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
952      *
953      * See {setApprovalForAll}.
954      */
955     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
956         return _operatorApprovals[owner][operator];
957     }
958 
959     /**
960      * @dev Returns whether `tokenId` exists.
961      *
962      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
963      *
964      * Tokens start existing when they are minted. See {_mint}.
965      */
966     function _exists(uint256 tokenId) internal view virtual returns (bool) {
967         return
968             _startTokenId() <= tokenId &&
969             tokenId < _currentIndex && // If within bounds,
970             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
971     }
972 
973     /**
974      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
975      */
976     function _isSenderApprovedOrOwner(
977         address approvedAddress,
978         address owner,
979         address msgSender
980     ) private pure returns (bool result) {
981         assembly {
982             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
983             owner := and(owner, _BITMASK_ADDRESS)
984             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
985             msgSender := and(msgSender, _BITMASK_ADDRESS)
986             // `msgSender == owner || msgSender == approvedAddress`.
987             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
988         }
989     }
990 
991     /**
992      * @dev Returns the storage slot and value for the approved address of `tokenId`.
993      */
994     function _getApprovedSlotAndAddress(uint256 tokenId)
995         private
996         view
997         returns (uint256 approvedAddressSlot, address approvedAddress)
998     {
999         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1000         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1001         assembly {
1002             approvedAddressSlot := tokenApproval.slot
1003             approvedAddress := sload(approvedAddressSlot)
1004         }
1005     }
1006 
1007     // =============================================================
1008     //                      TRANSFER OPERATIONS
1009     // =============================================================
1010 
1011     /**
1012      * @dev Transfers `tokenId` from `from` to `to`.
1013      *
1014      * Requirements:
1015      *
1016      * - `from` cannot be the zero address.
1017      * - `to` cannot be the zero address.
1018      * - `tokenId` token must be owned by `from`.
1019      * - If the caller is not `from`, it must be approved to move this token
1020      * by either {approve} or {setApprovalForAll}.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function transferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) public virtual override {
1029         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1030 
1031         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1032 
1033         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1034 
1035         // The nested ifs save around 20+ gas over a compound boolean condition.
1036         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1037             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1038 
1039         if (to == address(0)) revert TransferToZeroAddress();
1040 
1041         _beforeTokenTransfers(from, to, tokenId, 1);
1042 
1043         // Clear approvals from the previous owner.
1044         assembly {
1045             if approvedAddress {
1046                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1047                 sstore(approvedAddressSlot, 0)
1048             }
1049         }
1050 
1051         // Underflow of the sender's balance is impossible because we check for
1052         // ownership above and the recipient's balance can't realistically overflow.
1053         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1054         unchecked {
1055             // We can directly increment and decrement the balances.
1056             --_packedAddressData[from]; // Updates: `balance -= 1`.
1057             ++_packedAddressData[to]; // Updates: `balance += 1`.
1058 
1059             // Updates:
1060             // - `address` to the next owner.
1061             // - `startTimestamp` to the timestamp of transfering.
1062             // - `burned` to `false`.
1063             // - `nextInitialized` to `true`.
1064             _packedOwnerships[tokenId] = _packOwnershipData(
1065                 to,
1066                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1067             );
1068 
1069             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1070             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1071                 uint256 nextTokenId = tokenId + 1;
1072                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1073                 if (_packedOwnerships[nextTokenId] == 0) {
1074                     // If the next slot is within bounds.
1075                     if (nextTokenId != _currentIndex) {
1076                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1077                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1078                     }
1079                 }
1080             }
1081         }
1082 
1083         emit Transfer(from, to, tokenId);
1084         _afterTokenTransfers(from, to, tokenId, 1);
1085     }
1086 
1087     /**
1088      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1089      */
1090     function safeTransferFrom(
1091         address from,
1092         address to,
1093         uint256 tokenId
1094     ) public virtual override {
1095         safeTransferFrom(from, to, tokenId, '');
1096     }
1097 
1098     /**
1099      * @dev Safely transfers `tokenId` token from `from` to `to`.
1100      *
1101      * Requirements:
1102      *
1103      * - `from` cannot be the zero address.
1104      * - `to` cannot be the zero address.
1105      * - `tokenId` token must exist and be owned by `from`.
1106      * - If the caller is not `from`, it must be approved to move this token
1107      * by either {approve} or {setApprovalForAll}.
1108      * - If `to` refers to a smart contract, it must implement
1109      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1110      *
1111      * Emits a {Transfer} event.
1112      */
1113     function safeTransferFrom(
1114         address from,
1115         address to,
1116         uint256 tokenId,
1117         bytes memory _data
1118     ) public virtual override {
1119         transferFrom(from, to, tokenId);
1120         if (to.code.length != 0)
1121             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1122                 revert TransferToNonERC721ReceiverImplementer();
1123             }
1124     }
1125 
1126     /**
1127      * @dev Hook that is called before a set of serially-ordered token IDs
1128      * are about to be transferred. This includes minting.
1129      * And also called before burning one token.
1130      *
1131      * `startTokenId` - the first token ID to be transferred.
1132      * `quantity` - the amount to be transferred.
1133      *
1134      * Calling conditions:
1135      *
1136      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1137      * transferred to `to`.
1138      * - When `from` is zero, `tokenId` will be minted for `to`.
1139      * - When `to` is zero, `tokenId` will be burned by `from`.
1140      * - `from` and `to` are never both zero.
1141      */
1142     function _beforeTokenTransfers(
1143         address from,
1144         address to,
1145         uint256 startTokenId,
1146         uint256 quantity
1147     ) internal virtual {}
1148 
1149     /**
1150      * @dev Hook that is called after a set of serially-ordered token IDs
1151      * have been transferred. This includes minting.
1152      * And also called after one token has been burned.
1153      *
1154      * `startTokenId` - the first token ID to be transferred.
1155      * `quantity` - the amount to be transferred.
1156      *
1157      * Calling conditions:
1158      *
1159      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1160      * transferred to `to`.
1161      * - When `from` is zero, `tokenId` has been minted for `to`.
1162      * - When `to` is zero, `tokenId` has been burned by `from`.
1163      * - `from` and `to` are never both zero.
1164      */
1165     function _afterTokenTransfers(
1166         address from,
1167         address to,
1168         uint256 startTokenId,
1169         uint256 quantity
1170     ) internal virtual {}
1171 
1172     /**
1173      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1174      *
1175      * `from` - Previous owner of the given token ID.
1176      * `to` - Target address that will receive the token.
1177      * `tokenId` - Token ID to be transferred.
1178      * `_data` - Optional data to send along with the call.
1179      *
1180      * Returns whether the call correctly returned the expected magic value.
1181      */
1182     function _checkContractOnERC721Received(
1183         address from,
1184         address to,
1185         uint256 tokenId,
1186         bytes memory _data
1187     ) private returns (bool) {
1188         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1189             bytes4 retval
1190         ) {
1191             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1192         } catch (bytes memory reason) {
1193             if (reason.length == 0) {
1194                 revert TransferToNonERC721ReceiverImplementer();
1195             } else {
1196                 assembly {
1197                     revert(add(32, reason), mload(reason))
1198                 }
1199             }
1200         }
1201     }
1202 
1203     // =============================================================
1204     //                        MINT OPERATIONS
1205     // =============================================================
1206 
1207     /**
1208      * @dev Mints `quantity` tokens and transfers them to `to`.
1209      *
1210      * Requirements:
1211      *
1212      * - `to` cannot be the zero address.
1213      * - `quantity` must be greater than 0.
1214      *
1215      * Emits a {Transfer} event for each mint.
1216      */
1217     function _mint(address to, uint256 quantity) internal virtual {
1218         uint256 startTokenId = _currentIndex;
1219         if (quantity == 0) revert MintZeroQuantity();
1220 
1221         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1222 
1223         // Overflows are incredibly unrealistic.
1224         // `balance` and `numberMinted` have a maximum limit of 2**64.
1225         // `tokenId` has a maximum limit of 2**256.
1226         unchecked {
1227             // Updates:
1228             // - `balance += quantity`.
1229             // - `numberMinted += quantity`.
1230             //
1231             // We can directly add to the `balance` and `numberMinted`.
1232             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1233 
1234             // Updates:
1235             // - `address` to the owner.
1236             // - `startTimestamp` to the timestamp of minting.
1237             // - `burned` to `false`.
1238             // - `nextInitialized` to `quantity == 1`.
1239             _packedOwnerships[startTokenId] = _packOwnershipData(
1240                 to,
1241                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1242             );
1243 
1244             uint256 toMasked;
1245             uint256 end = startTokenId + quantity;
1246 
1247             // Use assembly to loop and emit the `Transfer` event for gas savings.
1248             assembly {
1249                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1250                 toMasked := and(to, _BITMASK_ADDRESS)
1251                 // Emit the `Transfer` event.
1252                 log4(
1253                     0, // Start of data (0, since no data).
1254                     0, // End of data (0, since no data).
1255                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1256                     0, // `address(0)`.
1257                     toMasked, // `to`.
1258                     startTokenId // `tokenId`.
1259                 )
1260 
1261                 for {
1262                     let tokenId := add(startTokenId, 1)
1263                 } iszero(eq(tokenId, end)) {
1264                     tokenId := add(tokenId, 1)
1265                 } {
1266                     // Emit the `Transfer` event. Similar to above.
1267                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1268                 }
1269             }
1270             if (toMasked == 0) revert MintToZeroAddress();
1271 
1272             _currentIndex = end;
1273         }
1274         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1275     }
1276 
1277     /**
1278      * @dev Mints `quantity` tokens and transfers them to `to`.
1279      *
1280      * This function is intended for efficient minting only during contract creation.
1281      *
1282      * It emits only one {ConsecutiveTransfer} as defined in
1283      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1284      * instead of a sequence of {Transfer} event(s).
1285      *
1286      * Calling this function outside of contract creation WILL make your contract
1287      * non-compliant with the ERC721 standard.
1288      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1289      * {ConsecutiveTransfer} event is only permissible during contract creation.
1290      *
1291      * Requirements:
1292      *
1293      * - `to` cannot be the zero address.
1294      * - `quantity` must be greater than 0.
1295      *
1296      * Emits a {ConsecutiveTransfer} event.
1297      */
1298     function _mintERC2309(address to, uint256 quantity) internal virtual {
1299         uint256 startTokenId = _currentIndex;
1300         if (to == address(0)) revert MintToZeroAddress();
1301         if (quantity == 0) revert MintZeroQuantity();
1302         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1303 
1304         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1305 
1306         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1307         unchecked {
1308             // Updates:
1309             // - `balance += quantity`.
1310             // - `numberMinted += quantity`.
1311             //
1312             // We can directly add to the `balance` and `numberMinted`.
1313             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1314 
1315             // Updates:
1316             // - `address` to the owner.
1317             // - `startTimestamp` to the timestamp of minting.
1318             // - `burned` to `false`.
1319             // - `nextInitialized` to `quantity == 1`.
1320             _packedOwnerships[startTokenId] = _packOwnershipData(
1321                 to,
1322                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1323             );
1324 
1325             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1326 
1327             _currentIndex = startTokenId + quantity;
1328         }
1329         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1330     }
1331 
1332     /**
1333      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1334      *
1335      * Requirements:
1336      *
1337      * - If `to` refers to a smart contract, it must implement
1338      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1339      * - `quantity` must be greater than 0.
1340      *
1341      * See {_mint}.
1342      *
1343      * Emits a {Transfer} event for each mint.
1344      */
1345     function _safeMint(
1346         address to,
1347         uint256 quantity,
1348         bytes memory _data
1349     ) internal virtual {
1350         _mint(to, quantity);
1351 
1352         unchecked {
1353             if (to.code.length != 0) {
1354                 uint256 end = _currentIndex;
1355                 uint256 index = end - quantity;
1356                 do {
1357                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1358                         revert TransferToNonERC721ReceiverImplementer();
1359                     }
1360                 } while (index < end);
1361                 // Reentrancy protection.
1362                 if (_currentIndex != end) revert();
1363             }
1364         }
1365     }
1366 
1367     /**
1368      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1369      */
1370     function _safeMint(address to, uint256 quantity) internal virtual {
1371         _safeMint(to, quantity, '');
1372     }
1373 
1374     // =============================================================
1375     //                        BURN OPERATIONS
1376     // =============================================================
1377 
1378     /**
1379      * @dev Equivalent to `_burn(tokenId, false)`.
1380      */
1381     function _burn(uint256 tokenId) internal virtual {
1382         _burn(tokenId, false);
1383     }
1384 
1385     /**
1386      * @dev Destroys `tokenId`.
1387      * The approval is cleared when the token is burned.
1388      *
1389      * Requirements:
1390      *
1391      * - `tokenId` must exist.
1392      *
1393      * Emits a {Transfer} event.
1394      */
1395     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1396         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1397 
1398         address from = address(uint160(prevOwnershipPacked));
1399 
1400         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1401 
1402         if (approvalCheck) {
1403             // The nested ifs save around 20+ gas over a compound boolean condition.
1404             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1405                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1406         }
1407 
1408         _beforeTokenTransfers(from, address(0), tokenId, 1);
1409 
1410         // Clear approvals from the previous owner.
1411         assembly {
1412             if approvedAddress {
1413                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1414                 sstore(approvedAddressSlot, 0)
1415             }
1416         }
1417 
1418         // Underflow of the sender's balance is impossible because we check for
1419         // ownership above and the recipient's balance can't realistically overflow.
1420         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1421         unchecked {
1422             // Updates:
1423             // - `balance -= 1`.
1424             // - `numberBurned += 1`.
1425             //
1426             // We can directly decrement the balance, and increment the number burned.
1427             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1428             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1429 
1430             // Updates:
1431             // - `address` to the last owner.
1432             // - `startTimestamp` to the timestamp of burning.
1433             // - `burned` to `true`.
1434             // - `nextInitialized` to `true`.
1435             _packedOwnerships[tokenId] = _packOwnershipData(
1436                 from,
1437                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1438             );
1439 
1440             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1441             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1442                 uint256 nextTokenId = tokenId + 1;
1443                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1444                 if (_packedOwnerships[nextTokenId] == 0) {
1445                     // If the next slot is within bounds.
1446                     if (nextTokenId != _currentIndex) {
1447                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1448                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1449                     }
1450                 }
1451             }
1452         }
1453 
1454         emit Transfer(from, address(0), tokenId);
1455         _afterTokenTransfers(from, address(0), tokenId, 1);
1456 
1457         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1458         unchecked {
1459             _burnCounter++;
1460         }
1461     }
1462 
1463     // =============================================================
1464     //                     EXTRA DATA OPERATIONS
1465     // =============================================================
1466 
1467     /**
1468      * @dev Directly sets the extra data for the ownership data `index`.
1469      */
1470     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1471         uint256 packed = _packedOwnerships[index];
1472         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1473         uint256 extraDataCasted;
1474         // Cast `extraData` with assembly to avoid redundant masking.
1475         assembly {
1476             extraDataCasted := extraData
1477         }
1478         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1479         _packedOwnerships[index] = packed;
1480     }
1481 
1482     /**
1483      * @dev Called during each token transfer to set the 24bit `extraData` field.
1484      * Intended to be overridden by the cosumer contract.
1485      *
1486      * `previousExtraData` - the value of `extraData` before transfer.
1487      *
1488      * Calling conditions:
1489      *
1490      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1491      * transferred to `to`.
1492      * - When `from` is zero, `tokenId` will be minted for `to`.
1493      * - When `to` is zero, `tokenId` will be burned by `from`.
1494      * - `from` and `to` are never both zero.
1495      */
1496     function _extraData(
1497         address from,
1498         address to,
1499         uint24 previousExtraData
1500     ) internal view virtual returns (uint24) {}
1501 
1502     /**
1503      * @dev Returns the next extra data for the packed ownership data.
1504      * The returned result is shifted into position.
1505      */
1506     function _nextExtraData(
1507         address from,
1508         address to,
1509         uint256 prevOwnershipPacked
1510     ) private view returns (uint256) {
1511         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1512         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1513     }
1514 
1515     // =============================================================
1516     //                       OTHER OPERATIONS
1517     // =============================================================
1518 
1519     /**
1520      * @dev Returns the message sender (defaults to `msg.sender`).
1521      *
1522      * If you are writing GSN compatible contracts, you need to override this function.
1523      */
1524     function _msgSenderERC721A() internal view virtual returns (address) {
1525         return msg.sender;
1526     }
1527 
1528     /**
1529      * @dev Converts a uint256 to its ASCII string decimal representation.
1530      */
1531     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1532         assembly {
1533             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1534             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1535             // We will need 1 32-byte word to store the length,
1536             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1537             str := add(mload(0x40), 0x80)
1538             // Update the free memory pointer to allocate.
1539             mstore(0x40, str)
1540 
1541             // Cache the end of the memory to calculate the length later.
1542             let end := str
1543 
1544             // We write the string from rightmost digit to leftmost digit.
1545             // The following is essentially a do-while loop that also handles the zero case.
1546             // prettier-ignore
1547             for { let temp := value } 1 {} {
1548                 str := sub(str, 1)
1549                 // Write the character to the pointer.
1550                 // The ASCII index of the '0' character is 48.
1551                 mstore8(str, add(48, mod(temp, 10)))
1552                 // Keep dividing `temp` until zero.
1553                 temp := div(temp, 10)
1554                 // prettier-ignore
1555                 if iszero(temp) { break }
1556             }
1557 
1558             let length := sub(end, str)
1559             // Move the pointer 32 bytes leftwards to make room for the length.
1560             str := sub(str, 0x20)
1561             // Store the length.
1562             mstore(str, length)
1563         }
1564     }
1565 }
1566 
1567 // File: contracts/growlers.sol
1568 
1569 pragma solidity ^0.8.4;
1570 
1571 contract growlers is ERC721A, Ownable {
1572 
1573     using Strings for uint256;
1574 
1575     string public baseURI = "https://growlers.s3.amazonaws.com/metadata/";
1576 
1577     uint256 public price = 0.001 ether;
1578     uint256 public maxPerTx = 10;
1579     uint256 public maxSupply = 2222;
1580 
1581     uint256 public maxFreePerWallet = 1;
1582     uint256 public totalFreeMinted = 0;
1583     uint256 public maxFreeSupply = 2222;
1584 
1585     mapping(address => uint256) public _mintedFreeAmount;
1586 
1587     constructor() ERC721A("Growlers", "GROWL") {
1588         _mint(msg.sender, 1);
1589     }
1590 
1591     function mint(uint256 _amount) external payable {
1592 
1593         require(msg.value >= _amount * price, "Incorrect amount of ETH.");
1594         require(totalSupply() + _amount <= maxSupply, "Sold out.");
1595         require(tx.origin == msg.sender, "Only humans please.");
1596         require(_amount <= maxPerTx, "You may only mint a max of 10 per transaction");
1597 
1598         _mint(msg.sender, _amount);
1599     }
1600 
1601     function mintFree(uint256 _amount) external payable {
1602         require(_mintedFreeAmount[msg.sender] + _amount <= maxFreePerWallet, "You have minted the max free amount allowed per wallet.");
1603 		require(totalFreeMinted + _amount <= maxFreeSupply, "Cannot exceed Free supply." );
1604         require(totalSupply() + _amount <= maxSupply, "Sold out.");
1605 
1606         _mintedFreeAmount[msg.sender]++;
1607         totalFreeMinted++;
1608         _safeMint(msg.sender, _amount);
1609 	}
1610 
1611     function tokenURI(uint256 tokenId)
1612         public view virtual override returns (string memory) {
1613         require(
1614             _exists(tokenId),
1615             "ERC721Metadata: URI query for nonexistent token"
1616         );
1617         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1618     }
1619 
1620     function setBaseURI(string calldata baseURI_) external onlyOwner {
1621         baseURI = baseURI_;
1622     }
1623 
1624     function changePrice(uint256 _price) external onlyOwner {
1625         price = _price;
1626     }
1627 
1628     function setMaxPerTx(uint256 _amount) external onlyOwner {
1629         maxPerTx = _amount;
1630     }
1631 
1632     function setmaxFreeSupply(uint256 _newMaxFreeSupply) public onlyOwner {
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