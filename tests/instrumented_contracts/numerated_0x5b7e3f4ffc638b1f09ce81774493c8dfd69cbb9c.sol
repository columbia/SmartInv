1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
70 }
71 
72 // File: @openzeppelin/contracts/utils/Context.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         return msg.data;
96     }
97 }
98 
99 // File: @openzeppelin/contracts/access/Ownable.sol
100 
101 
102 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 
107 /**
108  * @dev Contract module which provides a basic access control mechanism, where
109  * there is an account (an owner) that can be granted exclusive access to
110  * specific functions.
111  *
112  * By default, the owner account will be the one that deploys the contract. This
113  * can later be changed with {transferOwnership}.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be applied to your functions to restrict their use to
117  * the owner.
118  */
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     /**
125      * @dev Initializes the contract setting the deployer as the initial owner.
126      */
127     constructor() {
128         _transferOwnership(_msgSender());
129     }
130 
131     /**
132      * @dev Returns the address of the current owner.
133      */
134     function owner() public view virtual returns (address) {
135         return _owner;
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         require(owner() == _msgSender(), "Ownable: caller is not the owner");
143         _;
144     }
145 
146     /**
147      * @dev Leaves the contract without owner. It will not be possible to call
148      * `onlyOwner` functions anymore. Can only be called by the current owner.
149      *
150      * NOTE: Renouncing ownership will leave the contract without an owner,
151      * thereby removing any functionality that is only available to the owner.
152      */
153     function renounceOwnership() public virtual onlyOwner {
154         _transferOwnership(address(0));
155     }
156 
157     /**
158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
159      * Can only be called by the current owner.
160      */
161     function transferOwnership(address newOwner) public virtual onlyOwner {
162         require(newOwner != address(0), "Ownable: new owner is the zero address");
163         _transferOwnership(newOwner);
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Internal function without access restriction.
169      */
170     function _transferOwnership(address newOwner) internal virtual {
171         address oldOwner = _owner;
172         _owner = newOwner;
173         emit OwnershipTransferred(oldOwner, newOwner);
174     }
175 }
176 
177 // File: erc721a/contracts/IERC721A.sol
178 
179 
180 // ERC721A Contracts v4.2.2
181 // Creator: Chiru Labs
182 
183 pragma solidity ^0.8.4;
184 
185 /**
186  * @dev Interface of ERC721A.
187  */
188 interface IERC721A {
189     /**
190      * The caller must own the token or be an approved operator.
191      */
192     error ApprovalCallerNotOwnerNorApproved();
193 
194     /**
195      * The token does not exist.
196      */
197     error ApprovalQueryForNonexistentToken();
198 
199     /**
200      * The caller cannot approve to their own address.
201      */
202     error ApproveToCaller();
203 
204     /**
205      * Cannot query the balance for the zero address.
206      */
207     error BalanceQueryForZeroAddress();
208 
209     /**
210      * Cannot mint to the zero address.
211      */
212     error MintToZeroAddress();
213 
214     /**
215      * The quantity of tokens minted must be more than zero.
216      */
217     error MintZeroQuantity();
218 
219     /**
220      * The token does not exist.
221      */
222     error OwnerQueryForNonexistentToken();
223 
224     /**
225      * The caller must own the token or be an approved operator.
226      */
227     error TransferCallerNotOwnerNorApproved();
228 
229     /**
230      * The token must be owned by `from`.
231      */
232     error TransferFromIncorrectOwner();
233 
234     /**
235      * Cannot safely transfer to a contract that does not implement the
236      * ERC721Receiver interface.
237      */
238     error TransferToNonERC721ReceiverImplementer();
239 
240     /**
241      * Cannot transfer to the zero address.
242      */
243     error TransferToZeroAddress();
244 
245     /**
246      * The token does not exist.
247      */
248     error URIQueryForNonexistentToken();
249 
250     /**
251      * The `quantity` minted with ERC2309 exceeds the safety limit.
252      */
253     error MintERC2309QuantityExceedsLimit();
254 
255     /**
256      * The `extraData` cannot be set on an unintialized ownership slot.
257      */
258     error OwnershipNotInitializedForExtraData();
259 
260     // =============================================================
261     //                            STRUCTS
262     // =============================================================
263 
264     struct TokenOwnership {
265         // The address of the owner.
266         address addr;
267         // Stores the start time of ownership with minimal overhead for tokenomics.
268         uint64 startTimestamp;
269         // Whether the token has been burned.
270         bool burned;
271         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
272         uint24 extraData;
273     }
274 
275     // =============================================================
276     //                         TOKEN COUNTERS
277     // =============================================================
278 
279     /**
280      * @dev Returns the total number of tokens in existence.
281      * Burned tokens will reduce the count.
282      * To get the total number of tokens minted, please see {_totalMinted}.
283      */
284     function totalSupply() external view returns (uint256);
285 
286     // =============================================================
287     //                            IERC165
288     // =============================================================
289 
290     /**
291      * @dev Returns true if this contract implements the interface defined by
292      * `interfaceId`. See the corresponding
293      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
294      * to learn more about how these ids are created.
295      *
296      * This function call must use less than 30000 gas.
297      */
298     function supportsInterface(bytes4 interfaceId) external view returns (bool);
299 
300     // =============================================================
301     //                            IERC721
302     // =============================================================
303 
304     /**
305      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
306      */
307     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
308 
309     /**
310      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
311      */
312     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
313 
314     /**
315      * @dev Emitted when `owner` enables or disables
316      * (`approved`) `operator` to manage all of its assets.
317      */
318     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
319 
320     /**
321      * @dev Returns the number of tokens in `owner`'s account.
322      */
323     function balanceOf(address owner) external view returns (uint256 balance);
324 
325     /**
326      * @dev Returns the owner of the `tokenId` token.
327      *
328      * Requirements:
329      *
330      * - `tokenId` must exist.
331      */
332     function ownerOf(uint256 tokenId) external view returns (address owner);
333 
334     /**
335      * @dev Safely transfers `tokenId` token from `from` to `to`,
336      * checking first that contract recipients are aware of the ERC721 protocol
337      * to prevent tokens from being forever locked.
338      *
339      * Requirements:
340      *
341      * - `from` cannot be the zero address.
342      * - `to` cannot be the zero address.
343      * - `tokenId` token must exist and be owned by `from`.
344      * - If the caller is not `from`, it must be have been allowed to move
345      * this token by either {approve} or {setApprovalForAll}.
346      * - If `to` refers to a smart contract, it must implement
347      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
348      *
349      * Emits a {Transfer} event.
350      */
351     function safeTransferFrom(
352         address from,
353         address to,
354         uint256 tokenId,
355         bytes calldata data
356     ) external;
357 
358     /**
359      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
360      */
361     function safeTransferFrom(
362         address from,
363         address to,
364         uint256 tokenId
365     ) external;
366 
367     /**
368      * @dev Transfers `tokenId` from `from` to `to`.
369      *
370      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
371      * whenever possible.
372      *
373      * Requirements:
374      *
375      * - `from` cannot be the zero address.
376      * - `to` cannot be the zero address.
377      * - `tokenId` token must be owned by `from`.
378      * - If the caller is not `from`, it must be approved to move this token
379      * by either {approve} or {setApprovalForAll}.
380      *
381      * Emits a {Transfer} event.
382      */
383     function transferFrom(
384         address from,
385         address to,
386         uint256 tokenId
387     ) external;
388 
389     /**
390      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
391      * The approval is cleared when the token is transferred.
392      *
393      * Only a single account can be approved at a time, so approving the
394      * zero address clears previous approvals.
395      *
396      * Requirements:
397      *
398      * - The caller must own the token or be an approved operator.
399      * - `tokenId` must exist.
400      *
401      * Emits an {Approval} event.
402      */
403     function approve(address to, uint256 tokenId) external;
404 
405     /**
406      * @dev Approve or remove `operator` as an operator for the caller.
407      * Operators can call {transferFrom} or {safeTransferFrom}
408      * for any token owned by the caller.
409      *
410      * Requirements:
411      *
412      * - The `operator` cannot be the caller.
413      *
414      * Emits an {ApprovalForAll} event.
415      */
416     function setApprovalForAll(address operator, bool _approved) external;
417 
418     /**
419      * @dev Returns the account approved for `tokenId` token.
420      *
421      * Requirements:
422      *
423      * - `tokenId` must exist.
424      */
425     function getApproved(uint256 tokenId) external view returns (address operator);
426 
427     /**
428      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
429      *
430      * See {setApprovalForAll}.
431      */
432     function isApprovedForAll(address owner, address operator) external view returns (bool);
433 
434     // =============================================================
435     //                        IERC721Metadata
436     // =============================================================
437 
438     /**
439      * @dev Returns the token collection name.
440      */
441     function name() external view returns (string memory);
442 
443     /**
444      * @dev Returns the token collection symbol.
445      */
446     function symbol() external view returns (string memory);
447 
448     /**
449      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
450      */
451     function tokenURI(uint256 tokenId) external view returns (string memory);
452 
453     // =============================================================
454     //                           IERC2309
455     // =============================================================
456 
457     /**
458      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
459      * (inclusive) is transferred from `from` to `to`, as defined in the
460      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
461      *
462      * See {_mintERC2309} for more details.
463      */
464     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
465 }
466 
467 // File: erc721a/contracts/ERC721A.sol
468 
469 
470 // ERC721A Contracts v4.2.2
471 // Creator: Chiru Labs
472 
473 pragma solidity ^0.8.4;
474 
475 
476 /**
477  * @dev Interface of ERC721 token receiver.
478  */
479 interface ERC721A__IERC721Receiver {
480     function onERC721Received(
481         address operator,
482         address from,
483         uint256 tokenId,
484         bytes calldata data
485     ) external returns (bytes4);
486 }
487 
488 /**
489  * @title ERC721A
490  *
491  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
492  * Non-Fungible Token Standard, including the Metadata extension.
493  * Optimized for lower gas during batch mints.
494  *
495  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
496  * starting from `_startTokenId()`.
497  *
498  * Assumptions:
499  *
500  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
501  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
502  */
503 contract ERC721A is IERC721A {
504     // Reference type for token approval.
505     struct TokenApprovalRef {
506         address value;
507     }
508 
509     // =============================================================
510     //                           CONSTANTS
511     // =============================================================
512 
513     // Mask of an entry in packed address data.
514     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
515 
516     // The bit position of `numberMinted` in packed address data.
517     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
518 
519     // The bit position of `numberBurned` in packed address data.
520     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
521 
522     // The bit position of `aux` in packed address data.
523     uint256 private constant _BITPOS_AUX = 192;
524 
525     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
526     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
527 
528     // The bit position of `startTimestamp` in packed ownership.
529     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
530 
531     // The bit mask of the `burned` bit in packed ownership.
532     uint256 private constant _BITMASK_BURNED = 1 << 224;
533 
534     // The bit position of the `nextInitialized` bit in packed ownership.
535     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
536 
537     // The bit mask of the `nextInitialized` bit in packed ownership.
538     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
539 
540     // The bit position of `extraData` in packed ownership.
541     uint256 private constant _BITPOS_EXTRA_DATA = 232;
542 
543     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
544     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
545 
546     // The mask of the lower 160 bits for addresses.
547     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
548 
549     // The maximum `quantity` that can be minted with {_mintERC2309}.
550     // This limit is to prevent overflows on the address data entries.
551     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
552     // is required to cause an overflow, which is unrealistic.
553     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
554 
555     // The `Transfer` event signature is given by:
556     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
557     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
558         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
559 
560     // =============================================================
561     //                            STORAGE
562     // =============================================================
563 
564     // The next token ID to be minted.
565     uint256 private _currentIndex;
566 
567     // The number of tokens burned.
568     uint256 private _burnCounter;
569 
570     // Token name
571     string private _name;
572 
573     // Token symbol
574     string private _symbol;
575 
576     // Mapping from token ID to ownership details
577     // An empty struct value does not necessarily mean the token is unowned.
578     // See {_packedOwnershipOf} implementation for details.
579     //
580     // Bits Layout:
581     // - [0..159]   `addr`
582     // - [160..223] `startTimestamp`
583     // - [224]      `burned`
584     // - [225]      `nextInitialized`
585     // - [232..255] `extraData`
586     mapping(uint256 => uint256) private _packedOwnerships;
587 
588     // Mapping owner address to address data.
589     //
590     // Bits Layout:
591     // - [0..63]    `balance`
592     // - [64..127]  `numberMinted`
593     // - [128..191] `numberBurned`
594     // - [192..255] `aux`
595     mapping(address => uint256) private _packedAddressData;
596 
597     // Mapping from token ID to approved address.
598     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
599 
600     // Mapping from owner to operator approvals
601     mapping(address => mapping(address => bool)) private _operatorApprovals;
602 
603     // =============================================================
604     //                          CONSTRUCTOR
605     // =============================================================
606 
607     constructor(string memory name_, string memory symbol_) {
608         _name = name_;
609         _symbol = symbol_;
610         _currentIndex = _startTokenId();
611     }
612 
613     // =============================================================
614     //                   TOKEN COUNTING OPERATIONS
615     // =============================================================
616 
617     /**
618      * @dev Returns the starting token ID.
619      * To change the starting token ID, please override this function.
620      */
621     function _startTokenId() internal view virtual returns (uint256) {
622         return 0;
623     }
624 
625     /**
626      * @dev Returns the next token ID to be minted.
627      */
628     function _nextTokenId() internal view virtual returns (uint256) {
629         return _currentIndex;
630     }
631 
632     /**
633      * @dev Returns the total number of tokens in existence.
634      * Burned tokens will reduce the count.
635      * To get the total number of tokens minted, please see {_totalMinted}.
636      */
637     function totalSupply() public view virtual override returns (uint256) {
638         // Counter underflow is impossible as _burnCounter cannot be incremented
639         // more than `_currentIndex - _startTokenId()` times.
640         unchecked {
641             return _currentIndex - _burnCounter - _startTokenId();
642         }
643     }
644 
645     /**
646      * @dev Returns the total amount of tokens minted in the contract.
647      */
648     function _totalMinted() internal view virtual returns (uint256) {
649         // Counter underflow is impossible as `_currentIndex` does not decrement,
650         // and it is initialized to `_startTokenId()`.
651         unchecked {
652             return _currentIndex - _startTokenId();
653         }
654     }
655 
656     /**
657      * @dev Returns the total number of tokens burned.
658      */
659     function _totalBurned() internal view virtual returns (uint256) {
660         return _burnCounter;
661     }
662 
663     // =============================================================
664     //                    ADDRESS DATA OPERATIONS
665     // =============================================================
666 
667     /**
668      * @dev Returns the number of tokens in `owner`'s account.
669      */
670     function balanceOf(address owner) public view virtual override returns (uint256) {
671         if (owner == address(0)) revert BalanceQueryForZeroAddress();
672         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
673     }
674 
675     /**
676      * Returns the number of tokens minted by `owner`.
677      */
678     function _numberMinted(address owner) internal view returns (uint256) {
679         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
680     }
681 
682     /**
683      * Returns the number of tokens burned by or on behalf of `owner`.
684      */
685     function _numberBurned(address owner) internal view returns (uint256) {
686         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
687     }
688 
689     /**
690      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
691      */
692     function _getAux(address owner) internal view returns (uint64) {
693         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
694     }
695 
696     /**
697      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
698      * If there are multiple variables, please pack them into a uint64.
699      */
700     function _setAux(address owner, uint64 aux) internal virtual {
701         uint256 packed = _packedAddressData[owner];
702         uint256 auxCasted;
703         // Cast `aux` with assembly to avoid redundant masking.
704         assembly {
705             auxCasted := aux
706         }
707         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
708         _packedAddressData[owner] = packed;
709     }
710 
711     // =============================================================
712     //                            IERC165
713     // =============================================================
714 
715     /**
716      * @dev Returns true if this contract implements the interface defined by
717      * `interfaceId`. See the corresponding
718      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
719      * to learn more about how these ids are created.
720      *
721      * This function call must use less than 30000 gas.
722      */
723     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
724         // The interface IDs are constants representing the first 4 bytes
725         // of the XOR of all function selectors in the interface.
726         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
727         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
728         return
729             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
730             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
731             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
732     }
733 
734     // =============================================================
735     //                        IERC721Metadata
736     // =============================================================
737 
738     /**
739      * @dev Returns the token collection name.
740      */
741     function name() public view virtual override returns (string memory) {
742         return _name;
743     }
744 
745     /**
746      * @dev Returns the token collection symbol.
747      */
748     function symbol() public view virtual override returns (string memory) {
749         return _symbol;
750     }
751 
752     /**
753      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
754      */
755     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
756         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
757 
758         string memory baseURI = _baseURI();
759         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
760     }
761 
762     /**
763      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
764      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
765      * by default, it can be overridden in child contracts.
766      */
767     function _baseURI() internal view virtual returns (string memory) {
768         return '';
769     }
770 
771     // =============================================================
772     //                     OWNERSHIPS OPERATIONS
773     // =============================================================
774 
775     /**
776      * @dev Returns the owner of the `tokenId` token.
777      *
778      * Requirements:
779      *
780      * - `tokenId` must exist.
781      */
782     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
783         return address(uint160(_packedOwnershipOf(tokenId)));
784     }
785 
786     /**
787      * @dev Gas spent here starts off proportional to the maximum mint batch size.
788      * It gradually moves to O(1) as tokens get transferred around over time.
789      */
790     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
791         return _unpackedOwnership(_packedOwnershipOf(tokenId));
792     }
793 
794     /**
795      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
796      */
797     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
798         return _unpackedOwnership(_packedOwnerships[index]);
799     }
800 
801     /**
802      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
803      */
804     function _initializeOwnershipAt(uint256 index) internal virtual {
805         if (_packedOwnerships[index] == 0) {
806             _packedOwnerships[index] = _packedOwnershipOf(index);
807         }
808     }
809 
810     /**
811      * Returns the packed ownership data of `tokenId`.
812      */
813     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
814         uint256 curr = tokenId;
815 
816         unchecked {
817             if (_startTokenId() <= curr)
818                 if (curr < _currentIndex) {
819                     uint256 packed = _packedOwnerships[curr];
820                     // If not burned.
821                     if (packed & _BITMASK_BURNED == 0) {
822                         // Invariant:
823                         // There will always be an initialized ownership slot
824                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
825                         // before an unintialized ownership slot
826                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
827                         // Hence, `curr` will not underflow.
828                         //
829                         // We can directly compare the packed value.
830                         // If the address is zero, packed will be zero.
831                         while (packed == 0) {
832                             packed = _packedOwnerships[--curr];
833                         }
834                         return packed;
835                     }
836                 }
837         }
838         revert OwnerQueryForNonexistentToken();
839     }
840 
841     /**
842      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
843      */
844     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
845         ownership.addr = address(uint160(packed));
846         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
847         ownership.burned = packed & _BITMASK_BURNED != 0;
848         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
849     }
850 
851     /**
852      * @dev Packs ownership data into a single uint256.
853      */
854     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
855         assembly {
856             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
857             owner := and(owner, _BITMASK_ADDRESS)
858             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
859             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
860         }
861     }
862 
863     /**
864      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
865      */
866     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
867         // For branchless setting of the `nextInitialized` flag.
868         assembly {
869             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
870             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
871         }
872     }
873 
874     // =============================================================
875     //                      APPROVAL OPERATIONS
876     // =============================================================
877 
878     /**
879      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
880      * The approval is cleared when the token is transferred.
881      *
882      * Only a single account can be approved at a time, so approving the
883      * zero address clears previous approvals.
884      *
885      * Requirements:
886      *
887      * - The caller must own the token or be an approved operator.
888      * - `tokenId` must exist.
889      *
890      * Emits an {Approval} event.
891      */
892     function approve(address to, uint256 tokenId) public virtual override {
893         address owner = ownerOf(tokenId);
894 
895         if (_msgSenderERC721A() != owner)
896             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
897                 revert ApprovalCallerNotOwnerNorApproved();
898             }
899 
900         _tokenApprovals[tokenId].value = to;
901         emit Approval(owner, to, tokenId);
902     }
903 
904     /**
905      * @dev Returns the account approved for `tokenId` token.
906      *
907      * Requirements:
908      *
909      * - `tokenId` must exist.
910      */
911     function getApproved(uint256 tokenId) public view virtual override returns (address) {
912         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
913 
914         return _tokenApprovals[tokenId].value;
915     }
916 
917     /**
918      * @dev Approve or remove `operator` as an operator for the caller.
919      * Operators can call {transferFrom} or {safeTransferFrom}
920      * for any token owned by the caller.
921      *
922      * Requirements:
923      *
924      * - The `operator` cannot be the caller.
925      *
926      * Emits an {ApprovalForAll} event.
927      */
928     function setApprovalForAll(address operator, bool approved) public virtual override {
929         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
930 
931         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
932         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
933     }
934 
935     /**
936      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
937      *
938      * See {setApprovalForAll}.
939      */
940     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
941         return _operatorApprovals[owner][operator];
942     }
943 
944     /**
945      * @dev Returns whether `tokenId` exists.
946      *
947      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
948      *
949      * Tokens start existing when they are minted. See {_mint}.
950      */
951     function _exists(uint256 tokenId) internal view virtual returns (bool) {
952         return
953             _startTokenId() <= tokenId &&
954             tokenId < _currentIndex && // If within bounds,
955             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
956     }
957 
958     /**
959      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
960      */
961     function _isSenderApprovedOrOwner(
962         address approvedAddress,
963         address owner,
964         address msgSender
965     ) private pure returns (bool result) {
966         assembly {
967             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
968             owner := and(owner, _BITMASK_ADDRESS)
969             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
970             msgSender := and(msgSender, _BITMASK_ADDRESS)
971             // `msgSender == owner || msgSender == approvedAddress`.
972             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
973         }
974     }
975 
976     /**
977      * @dev Returns the storage slot and value for the approved address of `tokenId`.
978      */
979     function _getApprovedSlotAndAddress(uint256 tokenId)
980         private
981         view
982         returns (uint256 approvedAddressSlot, address approvedAddress)
983     {
984         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
985         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
986         assembly {
987             approvedAddressSlot := tokenApproval.slot
988             approvedAddress := sload(approvedAddressSlot)
989         }
990     }
991 
992     // =============================================================
993     //                      TRANSFER OPERATIONS
994     // =============================================================
995 
996     /**
997      * @dev Transfers `tokenId` from `from` to `to`.
998      *
999      * Requirements:
1000      *
1001      * - `from` cannot be the zero address.
1002      * - `to` cannot be the zero address.
1003      * - `tokenId` token must be owned by `from`.
1004      * - If the caller is not `from`, it must be approved to move this token
1005      * by either {approve} or {setApprovalForAll}.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function transferFrom(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) public virtual override {
1014         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1015 
1016         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1017 
1018         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1019 
1020         // The nested ifs save around 20+ gas over a compound boolean condition.
1021         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1022             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1023 
1024         if (to == address(0)) revert TransferToZeroAddress();
1025 
1026         _beforeTokenTransfers(from, to, tokenId, 1);
1027 
1028         // Clear approvals from the previous owner.
1029         assembly {
1030             if approvedAddress {
1031                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1032                 sstore(approvedAddressSlot, 0)
1033             }
1034         }
1035 
1036         // Underflow of the sender's balance is impossible because we check for
1037         // ownership above and the recipient's balance can't realistically overflow.
1038         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1039         unchecked {
1040             // We can directly increment and decrement the balances.
1041             --_packedAddressData[from]; // Updates: `balance -= 1`.
1042             ++_packedAddressData[to]; // Updates: `balance += 1`.
1043 
1044             // Updates:
1045             // - `address` to the next owner.
1046             // - `startTimestamp` to the timestamp of transfering.
1047             // - `burned` to `false`.
1048             // - `nextInitialized` to `true`.
1049             _packedOwnerships[tokenId] = _packOwnershipData(
1050                 to,
1051                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1052             );
1053 
1054             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1055             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1056                 uint256 nextTokenId = tokenId + 1;
1057                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1058                 if (_packedOwnerships[nextTokenId] == 0) {
1059                     // If the next slot is within bounds.
1060                     if (nextTokenId != _currentIndex) {
1061                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1062                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1063                     }
1064                 }
1065             }
1066         }
1067 
1068         emit Transfer(from, to, tokenId);
1069         _afterTokenTransfers(from, to, tokenId, 1);
1070     }
1071 
1072     /**
1073      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1074      */
1075     function safeTransferFrom(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) public virtual override {
1080         safeTransferFrom(from, to, tokenId, '');
1081     }
1082 
1083     /**
1084      * @dev Safely transfers `tokenId` token from `from` to `to`.
1085      *
1086      * Requirements:
1087      *
1088      * - `from` cannot be the zero address.
1089      * - `to` cannot be the zero address.
1090      * - `tokenId` token must exist and be owned by `from`.
1091      * - If the caller is not `from`, it must be approved to move this token
1092      * by either {approve} or {setApprovalForAll}.
1093      * - If `to` refers to a smart contract, it must implement
1094      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function safeTransferFrom(
1099         address from,
1100         address to,
1101         uint256 tokenId,
1102         bytes memory _data
1103     ) public virtual override {
1104         transferFrom(from, to, tokenId);
1105         if (to.code.length != 0)
1106             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1107                 revert TransferToNonERC721ReceiverImplementer();
1108             }
1109     }
1110 
1111     /**
1112      * @dev Hook that is called before a set of serially-ordered token IDs
1113      * are about to be transferred. This includes minting.
1114      * And also called before burning one token.
1115      *
1116      * `startTokenId` - the first token ID to be transferred.
1117      * `quantity` - the amount to be transferred.
1118      *
1119      * Calling conditions:
1120      *
1121      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1122      * transferred to `to`.
1123      * - When `from` is zero, `tokenId` will be minted for `to`.
1124      * - When `to` is zero, `tokenId` will be burned by `from`.
1125      * - `from` and `to` are never both zero.
1126      */
1127     function _beforeTokenTransfers(
1128         address from,
1129         address to,
1130         uint256 startTokenId,
1131         uint256 quantity
1132     ) internal virtual {}
1133 
1134     /**
1135      * @dev Hook that is called after a set of serially-ordered token IDs
1136      * have been transferred. This includes minting.
1137      * And also called after one token has been burned.
1138      *
1139      * `startTokenId` - the first token ID to be transferred.
1140      * `quantity` - the amount to be transferred.
1141      *
1142      * Calling conditions:
1143      *
1144      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1145      * transferred to `to`.
1146      * - When `from` is zero, `tokenId` has been minted for `to`.
1147      * - When `to` is zero, `tokenId` has been burned by `from`.
1148      * - `from` and `to` are never both zero.
1149      */
1150     function _afterTokenTransfers(
1151         address from,
1152         address to,
1153         uint256 startTokenId,
1154         uint256 quantity
1155     ) internal virtual {}
1156 
1157     /**
1158      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1159      *
1160      * `from` - Previous owner of the given token ID.
1161      * `to` - Target address that will receive the token.
1162      * `tokenId` - Token ID to be transferred.
1163      * `_data` - Optional data to send along with the call.
1164      *
1165      * Returns whether the call correctly returned the expected magic value.
1166      */
1167     function _checkContractOnERC721Received(
1168         address from,
1169         address to,
1170         uint256 tokenId,
1171         bytes memory _data
1172     ) private returns (bool) {
1173         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1174             bytes4 retval
1175         ) {
1176             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1177         } catch (bytes memory reason) {
1178             if (reason.length == 0) {
1179                 revert TransferToNonERC721ReceiverImplementer();
1180             } else {
1181                 assembly {
1182                     revert(add(32, reason), mload(reason))
1183                 }
1184             }
1185         }
1186     }
1187 
1188     // =============================================================
1189     //                        MINT OPERATIONS
1190     // =============================================================
1191 
1192     /**
1193      * @dev Mints `quantity` tokens and transfers them to `to`.
1194      *
1195      * Requirements:
1196      *
1197      * - `to` cannot be the zero address.
1198      * - `quantity` must be greater than 0.
1199      *
1200      * Emits a {Transfer} event for each mint.
1201      */
1202     function _mint(address to, uint256 quantity) internal virtual {
1203         uint256 startTokenId = _currentIndex;
1204         if (quantity == 0) revert MintZeroQuantity();
1205 
1206         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1207 
1208         // Overflows are incredibly unrealistic.
1209         // `balance` and `numberMinted` have a maximum limit of 2**64.
1210         // `tokenId` has a maximum limit of 2**256.
1211         unchecked {
1212             // Updates:
1213             // - `balance += quantity`.
1214             // - `numberMinted += quantity`.
1215             //
1216             // We can directly add to the `balance` and `numberMinted`.
1217             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1218 
1219             // Updates:
1220             // - `address` to the owner.
1221             // - `startTimestamp` to the timestamp of minting.
1222             // - `burned` to `false`.
1223             // - `nextInitialized` to `quantity == 1`.
1224             _packedOwnerships[startTokenId] = _packOwnershipData(
1225                 to,
1226                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1227             );
1228 
1229             uint256 toMasked;
1230             uint256 end = startTokenId + quantity;
1231 
1232             // Use assembly to loop and emit the `Transfer` event for gas savings.
1233             assembly {
1234                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1235                 toMasked := and(to, _BITMASK_ADDRESS)
1236                 // Emit the `Transfer` event.
1237                 log4(
1238                     0, // Start of data (0, since no data).
1239                     0, // End of data (0, since no data).
1240                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1241                     0, // `address(0)`.
1242                     toMasked, // `to`.
1243                     startTokenId // `tokenId`.
1244                 )
1245 
1246                 for {
1247                     let tokenId := add(startTokenId, 1)
1248                 } iszero(eq(tokenId, end)) {
1249                     tokenId := add(tokenId, 1)
1250                 } {
1251                     // Emit the `Transfer` event. Similar to above.
1252                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1253                 }
1254             }
1255             if (toMasked == 0) revert MintToZeroAddress();
1256 
1257             _currentIndex = end;
1258         }
1259         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1260     }
1261 
1262     /**
1263      * @dev Mints `quantity` tokens and transfers them to `to`.
1264      *
1265      * This function is intended for efficient minting only during contract creation.
1266      *
1267      * It emits only one {ConsecutiveTransfer} as defined in
1268      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1269      * instead of a sequence of {Transfer} event(s).
1270      *
1271      * Calling this function outside of contract creation WILL make your contract
1272      * non-compliant with the ERC721 standard.
1273      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1274      * {ConsecutiveTransfer} event is only permissible during contract creation.
1275      *
1276      * Requirements:
1277      *
1278      * - `to` cannot be the zero address.
1279      * - `quantity` must be greater than 0.
1280      *
1281      * Emits a {ConsecutiveTransfer} event.
1282      */
1283     function _mintERC2309(address to, uint256 quantity) internal virtual {
1284         uint256 startTokenId = _currentIndex;
1285         if (to == address(0)) revert MintToZeroAddress();
1286         if (quantity == 0) revert MintZeroQuantity();
1287         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1288 
1289         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1290 
1291         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1292         unchecked {
1293             // Updates:
1294             // - `balance += quantity`.
1295             // - `numberMinted += quantity`.
1296             //
1297             // We can directly add to the `balance` and `numberMinted`.
1298             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1299 
1300             // Updates:
1301             // - `address` to the owner.
1302             // - `startTimestamp` to the timestamp of minting.
1303             // - `burned` to `false`.
1304             // - `nextInitialized` to `quantity == 1`.
1305             _packedOwnerships[startTokenId] = _packOwnershipData(
1306                 to,
1307                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1308             );
1309 
1310             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1311 
1312             _currentIndex = startTokenId + quantity;
1313         }
1314         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1315     }
1316 
1317     /**
1318      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1319      *
1320      * Requirements:
1321      *
1322      * - If `to` refers to a smart contract, it must implement
1323      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1324      * - `quantity` must be greater than 0.
1325      *
1326      * See {_mint}.
1327      *
1328      * Emits a {Transfer} event for each mint.
1329      */
1330     function _safeMint(
1331         address to,
1332         uint256 quantity,
1333         bytes memory _data
1334     ) internal virtual {
1335         _mint(to, quantity);
1336 
1337         unchecked {
1338             if (to.code.length != 0) {
1339                 uint256 end = _currentIndex;
1340                 uint256 index = end - quantity;
1341                 do {
1342                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1343                         revert TransferToNonERC721ReceiverImplementer();
1344                     }
1345                 } while (index < end);
1346                 // Reentrancy protection.
1347                 if (_currentIndex != end) revert();
1348             }
1349         }
1350     }
1351 
1352     /**
1353      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1354      */
1355     function _safeMint(address to, uint256 quantity) internal virtual {
1356         _safeMint(to, quantity, '');
1357     }
1358 
1359     // =============================================================
1360     //                        BURN OPERATIONS
1361     // =============================================================
1362 
1363     /**
1364      * @dev Equivalent to `_burn(tokenId, false)`.
1365      */
1366     function _burn(uint256 tokenId) internal virtual {
1367         _burn(tokenId, false);
1368     }
1369 
1370     /**
1371      * @dev Destroys `tokenId`.
1372      * The approval is cleared when the token is burned.
1373      *
1374      * Requirements:
1375      *
1376      * - `tokenId` must exist.
1377      *
1378      * Emits a {Transfer} event.
1379      */
1380     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1381         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1382 
1383         address from = address(uint160(prevOwnershipPacked));
1384 
1385         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1386 
1387         if (approvalCheck) {
1388             // The nested ifs save around 20+ gas over a compound boolean condition.
1389             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1390                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1391         }
1392 
1393         _beforeTokenTransfers(from, address(0), tokenId, 1);
1394 
1395         // Clear approvals from the previous owner.
1396         assembly {
1397             if approvedAddress {
1398                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1399                 sstore(approvedAddressSlot, 0)
1400             }
1401         }
1402 
1403         // Underflow of the sender's balance is impossible because we check for
1404         // ownership above and the recipient's balance can't realistically overflow.
1405         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1406         unchecked {
1407             // Updates:
1408             // - `balance -= 1`.
1409             // - `numberBurned += 1`.
1410             //
1411             // We can directly decrement the balance, and increment the number burned.
1412             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1413             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1414 
1415             // Updates:
1416             // - `address` to the last owner.
1417             // - `startTimestamp` to the timestamp of burning.
1418             // - `burned` to `true`.
1419             // - `nextInitialized` to `true`.
1420             _packedOwnerships[tokenId] = _packOwnershipData(
1421                 from,
1422                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1423             );
1424 
1425             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1426             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1427                 uint256 nextTokenId = tokenId + 1;
1428                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1429                 if (_packedOwnerships[nextTokenId] == 0) {
1430                     // If the next slot is within bounds.
1431                     if (nextTokenId != _currentIndex) {
1432                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1433                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1434                     }
1435                 }
1436             }
1437         }
1438 
1439         emit Transfer(from, address(0), tokenId);
1440         _afterTokenTransfers(from, address(0), tokenId, 1);
1441 
1442         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1443         unchecked {
1444             _burnCounter++;
1445         }
1446     }
1447 
1448     // =============================================================
1449     //                     EXTRA DATA OPERATIONS
1450     // =============================================================
1451 
1452     /**
1453      * @dev Directly sets the extra data for the ownership data `index`.
1454      */
1455     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1456         uint256 packed = _packedOwnerships[index];
1457         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1458         uint256 extraDataCasted;
1459         // Cast `extraData` with assembly to avoid redundant masking.
1460         assembly {
1461             extraDataCasted := extraData
1462         }
1463         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1464         _packedOwnerships[index] = packed;
1465     }
1466 
1467     /**
1468      * @dev Called during each token transfer to set the 24bit `extraData` field.
1469      * Intended to be overridden by the cosumer contract.
1470      *
1471      * `previousExtraData` - the value of `extraData` before transfer.
1472      *
1473      * Calling conditions:
1474      *
1475      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1476      * transferred to `to`.
1477      * - When `from` is zero, `tokenId` will be minted for `to`.
1478      * - When `to` is zero, `tokenId` will be burned by `from`.
1479      * - `from` and `to` are never both zero.
1480      */
1481     function _extraData(
1482         address from,
1483         address to,
1484         uint24 previousExtraData
1485     ) internal view virtual returns (uint24) {}
1486 
1487     /**
1488      * @dev Returns the next extra data for the packed ownership data.
1489      * The returned result is shifted into position.
1490      */
1491     function _nextExtraData(
1492         address from,
1493         address to,
1494         uint256 prevOwnershipPacked
1495     ) private view returns (uint256) {
1496         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1497         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1498     }
1499 
1500     // =============================================================
1501     //                       OTHER OPERATIONS
1502     // =============================================================
1503 
1504     /**
1505      * @dev Returns the message sender (defaults to `msg.sender`).
1506      *
1507      * If you are writing GSN compatible contracts, you need to override this function.
1508      */
1509     function _msgSenderERC721A() internal view virtual returns (address) {
1510         return msg.sender;
1511     }
1512 
1513     /**
1514      * @dev Converts a uint256 to its ASCII string decimal representation.
1515      */
1516     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1517         assembly {
1518             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1519             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1520             // We will need 1 32-byte word to store the length,
1521             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1522             str := add(mload(0x40), 0x80)
1523             // Update the free memory pointer to allocate.
1524             mstore(0x40, str)
1525 
1526             // Cache the end of the memory to calculate the length later.
1527             let end := str
1528 
1529             // We write the string from rightmost digit to leftmost digit.
1530             // The following is essentially a do-while loop that also handles the zero case.
1531             // prettier-ignore
1532             for { let temp := value } 1 {} {
1533                 str := sub(str, 1)
1534                 // Write the character to the pointer.
1535                 // The ASCII index of the '0' character is 48.
1536                 mstore8(str, add(48, mod(temp, 10)))
1537                 // Keep dividing `temp` until zero.
1538                 temp := div(temp, 10)
1539                 // prettier-ignore
1540                 if iszero(temp) { break }
1541             }
1542 
1543             let length := sub(end, str)
1544             // Move the pointer 32 bytes leftwards to make room for the length.
1545             str := sub(str, 0x20)
1546             // Store the length.
1547             mstore(str, length)
1548         }
1549     }
1550 }
1551 
1552 // File: contracts/Pie.sol
1553 
1554 
1555 pragma solidity ^0.8.13;
1556 
1557 
1558 
1559 
1560 contract MicroPenisMinter is ERC721A, Ownable {
1561 
1562     string public baseURI = "ipfs://QmcdYEgZKSijSEUXUpkCWpFum6bmz8m59Zpt6DRXp7pTqG";
1563     uint256 public maxBitches = 1000;
1564     uint256 public price = 0.002 ether;
1565 
1566     bool public bitchTime = false;
1567 
1568     constructor() ERC721A("Micro Penis Minter", "PNS") {}
1569 
1570     function suckPenis(uint256 blowjob) external payable {
1571         require(!bitchTime, "Fuck off");
1572         require(maxBitches >= totalSupply() + blowjob, "Too many biches");
1573         require(blowjob > 0, "Suck me off");
1574         require(blowjob * price <= msg.value, "Poor bitch");
1575 
1576         _safeMint(msg.sender, blowjob);
1577     }
1578 
1579     function _startTokenId() internal override view virtual returns (uint256) {
1580         return 1;
1581     }
1582 
1583     function minted(address _owner) public view returns (uint256) {
1584         return _numberMinted(_owner);
1585     }
1586 
1587     function thanksPig() external onlyOwner {
1588         (bool success, ) = _msgSender().call{value: address(this).balance}("");
1589         require(success, "Failed to send");
1590     }
1591 
1592     function teamMint(address _to, uint256 _amount) external onlyOwner {
1593         _safeMint(_to, _amount);
1594     }
1595 
1596     function toggleBitchTime() external onlyOwner {
1597         bitchTime = !bitchTime;
1598     }
1599 
1600     function setSupply(uint256 _supply) external onlyOwner {
1601         maxBitches = _supply;
1602     }
1603 
1604     function setPrice(uint256 _price) external onlyOwner {
1605         price = _price;
1606     }
1607 
1608     function setBaseURI(string memory baseURI_) external onlyOwner {
1609         baseURI = baseURI_;
1610     }
1611 
1612     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1613         require(_exists(_tokenId), "Token does not exist.");
1614         return bytes(baseURI).length > 0 ? baseURI : "";
1615     }
1616 }