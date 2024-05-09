1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5   #####                                   #    #                 ######                            
6  #     # #####  #   # #####  #####  ####  #   #    ##   #    # # #     # #    # ##### #####  ####  
7  #       #    #  # #  #    #   #   #    # #  #    #  #  ##  ## # #     # #    #   #     #   #      
8  #       #    #   #   #    #   #   #    # ###    #    # # ## # # ######  #    #   #     #    ####  
9  #       #####    #   #####    #   #    # #  #   ###### #    # # #     # #    #   #     #        # 
10  #     # #   #    #   #        #   #    # #   #  #    # #    # # #     # #    #   #     #   #    # 
11   #####  #    #   #   #        #    ####  #    # #    # #    # # ######   ####    #     #    ####  
12                                                                                                                                                                                               
13                                                                                                                                                        
14 */
15 
16 // File: @openzeppelin/contracts/utils/Context.sol
17 
18 
19 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 
43 
44 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
45 
46 
47 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
48 
49 pragma solidity ^0.8.0;
50 
51 /**
52  * @dev String operations.
53  */
54 library Strings {
55     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
56     uint8 private constant _ADDRESS_LENGTH = 20;
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
60      */
61     function toString(uint256 value) internal pure returns (string memory) {
62         // Inspired by OraclizeAPI's implementation - MIT licence
63         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
64 
65         if (value == 0) {
66             return "0";
67         }
68         uint256 temp = value;
69         uint256 digits;
70         while (temp != 0) {
71             digits++;
72             temp /= 10;
73         }
74         bytes memory buffer = new bytes(digits);
75         while (value != 0) {
76             digits -= 1;
77             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
78             value /= 10;
79         }
80         return string(buffer);
81     }
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
85      */
86     function toHexString(uint256 value) internal pure returns (string memory) {
87         if (value == 0) {
88             return "0x00";
89         }
90         uint256 temp = value;
91         uint256 length = 0;
92         while (temp != 0) {
93             length++;
94             temp >>= 8;
95         }
96         return toHexString(value, length);
97     }
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
101      */
102     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
103         bytes memory buffer = new bytes(2 * length + 2);
104         buffer[0] = "0";
105         buffer[1] = "x";
106         for (uint256 i = 2 * length + 1; i > 1; --i) {
107             buffer[i] = _HEX_SYMBOLS[value & 0xf];
108             value >>= 4;
109         }
110         require(value == 0, "Strings: hex length insufficient");
111         return string(buffer);
112     }
113 
114     /**
115      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
116      */
117     function toHexString(address addr) internal pure returns (string memory) {
118         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
119     }
120 }
121 
122 // File: @openzeppelin/contracts/access/Ownable.sol
123 
124 
125 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 
130 /**
131  * @dev Contract module which provides a basic access control mechanism, where
132  * there is an account (an owner) that can be granted exclusive access to
133  * specific functions.
134  *
135  * By default, the owner account will be the one that deploys the contract. This
136  * can later be changed with {transferOwnership}.
137  *
138  * This module is used through inheritance. It will make available the modifier
139  * `onlyOwner`, which can be applied to your functions to restrict their use to
140  * the owner.
141  */
142 abstract contract Ownable is Context {
143     address private _owner;
144 
145     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
146 
147     /**
148      * @dev Initializes the contract setting the deployer as the initial owner.
149      */
150     constructor() {
151         _transferOwnership(_msgSender());
152     }
153 
154     /**
155      * @dev Throws if called by any account other than the owner.
156      */
157     modifier onlyOwner() {
158         _checkOwner();
159         _;
160     }
161 
162     /**
163      * @dev Returns the address of the current owner.
164      */
165     function owner() public view virtual returns (address) {
166         return _owner;
167     }
168 
169     /**
170      * @dev Throws if the sender is not the owner.
171      */
172     function _checkOwner() internal view virtual {
173         require(owner() == _msgSender(), "Ownable: caller is not the owner");
174     }
175 
176     /**
177      * @dev Leaves the contract without owner. It will not be possible to call
178      * `onlyOwner` functions anymore. Can only be called by the current owner.
179      *
180      * NOTE: Renouncing ownership will leave the contract without an owner,
181      * thereby removing any functionality that is only available to the owner.
182      */
183     function renounceOwnership() public virtual onlyOwner {
184         _transferOwnership(address(0));
185     }
186 
187     /**
188      * @dev Transfers ownership of the contract to a new account (`newOwner`).
189      * Can only be called by the current owner.
190      */
191     function transferOwnership(address newOwner) public virtual onlyOwner {
192         require(newOwner != address(0), "Ownable: new owner is the zero address");
193         _transferOwnership(newOwner);
194     }
195 
196     /**
197      * @dev Transfers ownership of the contract to a new account (`newOwner`).
198      * Internal function without access restriction.
199      */
200     function _transferOwnership(address newOwner) internal virtual {
201         address oldOwner = _owner;
202         _owner = newOwner;
203         emit OwnershipTransferred(oldOwner, newOwner);
204     }
205 }
206 
207 // File: erc721a/contracts/IERC721A.sol
208 
209 
210 // ERC721A Contracts v4.2.2
211 // Creator: Chiru Labs
212 
213 pragma solidity ^0.8.4;
214 
215 /**
216  * @dev Interface of ERC721A.
217  */
218 interface IERC721A {
219     /**
220      * The caller must own the token or be an approved operator.
221      */
222     error ApprovalCallerNotOwnerNorApproved();
223 
224     /**
225      * The token does not exist.
226      */
227     error ApprovalQueryForNonexistentToken();
228 
229     /**
230      * The caller cannot approve to their own address.
231      */
232     error ApproveToCaller();
233 
234     /**
235      * Cannot query the balance for the zero address.
236      */
237     error BalanceQueryForZeroAddress();
238 
239     /**
240      * Cannot mint to the zero address.
241      */
242     error MintToZeroAddress();
243 
244     /**
245      * The quantity of tokens minted must be more than zero.
246      */
247     error MintZeroQuantity();
248 
249     /**
250      * The token does not exist.
251      */
252     error OwnerQueryForNonexistentToken();
253 
254     /**
255      * The caller must own the token or be an approved operator.
256      */
257     error TransferCallerNotOwnerNorApproved();
258 
259     /**
260      * The token must be owned by `from`.
261      */
262     error TransferFromIncorrectOwner();
263 
264     /**
265      * Cannot safely transfer to a contract that does not implement the
266      * ERC721Receiver interface.
267      */
268     error TransferToNonERC721ReceiverImplementer();
269 
270     /**
271      * Cannot transfer to the zero address.
272      */
273     error TransferToZeroAddress();
274 
275     /**
276      * The token does not exist.
277      */
278     error URIQueryForNonexistentToken();
279 
280     /**
281      * The `quantity` minted with ERC2309 exceeds the safety limit.
282      */
283     error MintERC2309QuantityExceedsLimit();
284 
285     /**
286      * The `extraData` cannot be set on an unintialized ownership slot.
287      */
288     error OwnershipNotInitializedForExtraData();
289 
290     // =============================================================
291     //                            STRUCTS
292     // =============================================================
293 
294     struct TokenOwnership {
295         // The address of the owner.
296         address addr;
297         // Stores the start time of ownership with minimal overhead for tokenomics.
298         uint64 startTimestamp;
299         // Whether the token has been burned.
300         bool burned;
301         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
302         uint24 extraData;
303     }
304 
305     // =============================================================
306     //                         TOKEN COUNTERS
307     // =============================================================
308 
309     /**
310      * @dev Returns the total number of tokens in existence.
311      * Burned tokens will reduce the count.
312      * To get the total number of tokens minted, please see {_totalMinted}.
313      */
314     function totalSupply() external view returns (uint256);
315 
316     // =============================================================
317     //                            IERC165
318     // =============================================================
319 
320     /**
321      * @dev Returns true if this contract implements the interface defined by
322      * `interfaceId`. See the corresponding
323      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
324      * to learn more about how these ids are created.
325      *
326      * This function call must use less than 30000 gas.
327      */
328     function supportsInterface(bytes4 interfaceId) external view returns (bool);
329 
330     // =============================================================
331     //                            IERC721
332     // =============================================================
333 
334     /**
335      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
336      */
337     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
338 
339     /**
340      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
341      */
342     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
343 
344     /**
345      * @dev Emitted when `owner` enables or disables
346      * (`approved`) `operator` to manage all of its assets.
347      */
348     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
349 
350     /**
351      * @dev Returns the number of tokens in `owner`'s account.
352      */
353     function balanceOf(address owner) external view returns (uint256 balance);
354 
355     /**
356      * @dev Returns the owner of the `tokenId` token.
357      *
358      * Requirements:
359      *
360      * - `tokenId` must exist.
361      */
362     function ownerOf(uint256 tokenId) external view returns (address owner);
363 
364     /**
365      * @dev Safely transfers `tokenId` token from `from` to `to`,
366      * checking first that contract recipients are aware of the ERC721 protocol
367      * to prevent tokens from being forever locked.
368      *
369      * Requirements:
370      *
371      * - `from` cannot be the zero address.
372      * - `to` cannot be the zero address.
373      * - `tokenId` token must exist and be owned by `from`.
374      * - If the caller is not `from`, it must be have been allowed to move
375      * this token by either {approve} or {setApprovalForAll}.
376      * - If `to` refers to a smart contract, it must implement
377      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
378      *
379      * Emits a {Transfer} event.
380      */
381     function safeTransferFrom(
382         address from,
383         address to,
384         uint256 tokenId,
385         bytes calldata data
386     ) external;
387 
388     /**
389      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
390      */
391     function safeTransferFrom(
392         address from,
393         address to,
394         uint256 tokenId
395     ) external;
396 
397     /**
398      * @dev Transfers `tokenId` from `from` to `to`.
399      *
400      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
401      * whenever possible.
402      *
403      * Requirements:
404      *
405      * - `from` cannot be the zero address.
406      * - `to` cannot be the zero address.
407      * - `tokenId` token must be owned by `from`.
408      * - If the caller is not `from`, it must be approved to move this token
409      * by either {approve} or {setApprovalForAll}.
410      *
411      * Emits a {Transfer} event.
412      */
413     function transferFrom(
414         address from,
415         address to,
416         uint256 tokenId
417     ) external;
418 
419     /**
420      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
421      * The approval is cleared when the token is transferred.
422      *
423      * Only a single account can be approved at a time, so approving the
424      * zero address clears previous approvals.
425      *
426      * Requirements:
427      *
428      * - The caller must own the token or be an approved operator.
429      * - `tokenId` must exist.
430      *
431      * Emits an {Approval} event.
432      */
433     function approve(address to, uint256 tokenId) external;
434 
435     /**
436      * @dev Approve or remove `operator` as an operator for the caller.
437      * Operators can call {transferFrom} or {safeTransferFrom}
438      * for any token owned by the caller.
439      *
440      * Requirements:
441      *
442      * - The `operator` cannot be the caller.
443      *
444      * Emits an {ApprovalForAll} event.
445      */
446     function setApprovalForAll(address operator, bool _approved) external;
447 
448     /**
449      * @dev Returns the account approved for `tokenId` token.
450      *
451      * Requirements:
452      *
453      * - `tokenId` must exist.
454      */
455     function getApproved(uint256 tokenId) external view returns (address operator);
456 
457     /**
458      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
459      *
460      * See {setApprovalForAll}.
461      */
462     function isApprovedForAll(address owner, address operator) external view returns (bool);
463 
464     // =============================================================
465     //                        IERC721Metadata
466     // =============================================================
467 
468     /**
469      * @dev Returns the token collection name.
470      */
471     function name() external view returns (string memory);
472 
473     /**
474      * @dev Returns the token collection symbol.
475      */
476     function symbol() external view returns (string memory);
477 
478     /**
479      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
480      */
481     function tokenURI(uint256 tokenId) external view returns (string memory);
482 
483     // =============================================================
484     //                           IERC2309
485     // =============================================================
486 
487     /**
488      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
489      * (inclusive) is transferred from `from` to `to`, as defined in the
490      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
491      *
492      * See {_mintERC2309} for more details.
493      */
494     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
495 }
496 // File: erc721a/contracts/ERC721A.sol
497 
498 
499 // ERC721A Contracts v4.2.2
500 // Creator: Chiru Labs
501 
502 pragma solidity ^0.8.4;
503 
504 
505 /**
506  * @dev Interface of ERC721 token receiver.
507  */
508 interface ERC721A__IERC721Receiver {
509     function onERC721Received(
510         address operator,
511         address from,
512         uint256 tokenId,
513         bytes calldata data
514     ) external returns (bytes4);
515 }
516 
517 /**
518  * @title ERC721A
519  *
520  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
521  * Non-Fungible Token Standard, including the Metadata extension.
522  * Optimized for lower gas during batch mints.
523  *
524  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
525  * starting from `_startTokenId()`.
526  *
527  * Assumptions:
528  *
529  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
530  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
531  */
532 contract ERC721A is IERC721A {
533     // Reference type for token approval.
534     struct TokenApprovalRef {
535         address value;
536     }
537 
538     // =============================================================
539     //                           CONSTANTS
540     // =============================================================
541 
542     // Mask of an entry in packed address data.
543     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
544 
545     // The bit position of `numberMinted` in packed address data.
546     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
547 
548     // The bit position of `numberBurned` in packed address data.
549     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
550 
551     // The bit position of `aux` in packed address data.
552     uint256 private constant _BITPOS_AUX = 192;
553 
554     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
555     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
556 
557     // The bit position of `startTimestamp` in packed ownership.
558     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
559 
560     // The bit mask of the `burned` bit in packed ownership.
561     uint256 private constant _BITMASK_BURNED = 1 << 224;
562 
563     // The bit position of the `nextInitialized` bit in packed ownership.
564     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
565 
566     // The bit mask of the `nextInitialized` bit in packed ownership.
567     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
568 
569     // The bit position of `extraData` in packed ownership.
570     uint256 private constant _BITPOS_EXTRA_DATA = 232;
571 
572     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
573     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
574 
575     // The mask of the lower 160 bits for addresses.
576     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
577 
578     // The maximum `quantity` that can be minted with {_mintERC2309}.
579     // This limit is to prevent overflows on the address data entries.
580     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
581     // is required to cause an overflow, which is unrealistic.
582     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
583 
584     // The `Transfer` event signature is given by:
585     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
586     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
587         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
588 
589     // =============================================================
590     //                            STORAGE
591     // =============================================================
592 
593     // The next token ID to be minted.
594     uint256 private _currentIndex;
595 
596     // The number of tokens burned.
597     uint256 private _burnCounter;
598 
599     // Token name
600     string private _name;
601 
602     // Token symbol
603     string private _symbol;
604 
605     // Mapping from token ID to ownership details
606     // An empty struct value does not necessarily mean the token is unowned.
607     // See {_packedOwnershipOf} implementation for details.
608     //
609     // Bits Layout:
610     // - [0..159]   `addr`
611     // - [160..223] `startTimestamp`
612     // - [224]      `burned`
613     // - [225]      `nextInitialized`
614     // - [232..255] `extraData`
615     mapping(uint256 => uint256) private _packedOwnerships;
616 
617     // Mapping owner address to address data.
618     //
619     // Bits Layout:
620     // - [0..63]    `balance`
621     // - [64..127]  `numberMinted`
622     // - [128..191] `numberBurned`
623     // - [192..255] `aux`
624     mapping(address => uint256) private _packedAddressData;
625 
626     // Mapping from token ID to approved address.
627     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
628 
629     // Mapping from owner to operator approvals
630     mapping(address => mapping(address => bool)) private _operatorApprovals;
631 
632     // =============================================================
633     //                          CONSTRUCTOR
634     // =============================================================
635 
636     constructor(string memory name_, string memory symbol_) {
637         _name = name_;
638         _symbol = symbol_;
639         _currentIndex = _startTokenId();
640     }
641 
642     // =============================================================
643     //                   TOKEN COUNTING OPERATIONS
644     // =============================================================
645 
646     /**
647      * @dev Returns the starting token ID.
648      * To change the starting token ID, please override this function.
649      */
650     function _startTokenId() internal view virtual returns (uint256) {
651         return 0;
652     }
653 
654     /**
655      * @dev Returns the next token ID to be minted.
656      */
657     function _nextTokenId() internal view virtual returns (uint256) {
658         return _currentIndex;
659     }
660 
661     /**
662      * @dev Returns the total number of tokens in existence.
663      * Burned tokens will reduce the count.
664      * To get the total number of tokens minted, please see {_totalMinted}.
665      */
666     function totalSupply() public view virtual override returns (uint256) {
667         // Counter underflow is impossible as _burnCounter cannot be incremented
668         // more than `_currentIndex - _startTokenId()` times.
669         unchecked {
670             return _currentIndex - _burnCounter - _startTokenId();
671         }
672     }
673 
674     /**
675      * @dev Returns the total amount of tokens minted in the contract.
676      */
677     function _totalMinted() internal view virtual returns (uint256) {
678         // Counter underflow is impossible as `_currentIndex` does not decrement,
679         // and it is initialized to `_startTokenId()`.
680         unchecked {
681             return _currentIndex - _startTokenId();
682         }
683     }
684 
685     /**
686      * @dev Returns the total number of tokens burned.
687      */
688     function _totalBurned() internal view virtual returns (uint256) {
689         return _burnCounter;
690     }
691 
692     // =============================================================
693     //                    ADDRESS DATA OPERATIONS
694     // =============================================================
695 
696     /**
697      * @dev Returns the number of tokens in `owner`'s account.
698      */
699     function balanceOf(address owner) public view virtual override returns (uint256) {
700         if (owner == address(0)) revert BalanceQueryForZeroAddress();
701         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
702     }
703 
704     /**
705      * Returns the number of tokens minted by `owner`.
706      */
707     function _numberMinted(address owner) internal view returns (uint256) {
708         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
709     }
710 
711     /**
712      * Returns the number of tokens burned by or on behalf of `owner`.
713      */
714     function _numberBurned(address owner) internal view returns (uint256) {
715         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
716     }
717 
718     /**
719      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
720      */
721     function _getAux(address owner) internal view returns (uint64) {
722         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
723     }
724 
725     /**
726      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
727      * If there are multiple variables, please pack them into a uint64.
728      */
729     function _setAux(address owner, uint64 aux) internal virtual {
730         uint256 packed = _packedAddressData[owner];
731         uint256 auxCasted;
732         // Cast `aux` with assembly to avoid redundant masking.
733         assembly {
734             auxCasted := aux
735         }
736         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
737         _packedAddressData[owner] = packed;
738     }
739 
740     // =============================================================
741     //                            IERC165
742     // =============================================================
743 
744     /**
745      * @dev Returns true if this contract implements the interface defined by
746      * `interfaceId`. See the corresponding
747      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
748      * to learn more about how these ids are created.
749      *
750      * This function call must use less than 30000 gas.
751      */
752     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
753         // The interface IDs are constants representing the first 4 bytes
754         // of the XOR of all function selectors in the interface.
755         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
756         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
757         return
758             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
759             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
760             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
761     }
762 
763     // =============================================================
764     //                        IERC721Metadata
765     // =============================================================
766 
767     /**
768      * @dev Returns the token collection name.
769      */
770     function name() public view virtual override returns (string memory) {
771         return _name;
772     }
773 
774     /**
775      * @dev Returns the token collection symbol.
776      */
777     function symbol() public view virtual override returns (string memory) {
778         return _symbol;
779     }
780 
781     /**
782      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
783      */
784     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
785         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
786 
787         string memory baseURI = _baseURI();
788         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
789     }
790 
791     /**
792      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
793      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
794      * by default, it can be overridden in child contracts.
795      */
796     function _baseURI() internal view virtual returns (string memory) {
797         return '';
798     }
799 
800     // =============================================================
801     //                     OWNERSHIPS OPERATIONS
802     // =============================================================
803 
804     /**
805      * @dev Returns the owner of the `tokenId` token.
806      *
807      * Requirements:
808      *
809      * - `tokenId` must exist.
810      */
811     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
812         return address(uint160(_packedOwnershipOf(tokenId)));
813     }
814 
815     /**
816      * @dev Gas spent here starts off proportional to the maximum mint batch size.
817      * It gradually moves to O(1) as tokens get transferred around over time.
818      */
819     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
820         return _unpackedOwnership(_packedOwnershipOf(tokenId));
821     }
822 
823     /**
824      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
825      */
826     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
827         return _unpackedOwnership(_packedOwnerships[index]);
828     }
829 
830     /**
831      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
832      */
833     function _initializeOwnershipAt(uint256 index) internal virtual {
834         if (_packedOwnerships[index] == 0) {
835             _packedOwnerships[index] = _packedOwnershipOf(index);
836         }
837     }
838 
839     /**
840      * Returns the packed ownership data of `tokenId`.
841      */
842     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
843         uint256 curr = tokenId;
844 
845         unchecked {
846             if (_startTokenId() <= curr)
847                 if (curr < _currentIndex) {
848                     uint256 packed = _packedOwnerships[curr];
849                     // If not burned.
850                     if (packed & _BITMASK_BURNED == 0) {
851                         // Invariant:
852                         // There will always be an initialized ownership slot
853                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
854                         // before an unintialized ownership slot
855                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
856                         // Hence, `curr` will not underflow.
857                         //
858                         // We can directly compare the packed value.
859                         // If the address is zero, packed will be zero.
860                         while (packed == 0) {
861                             packed = _packedOwnerships[--curr];
862                         }
863                         return packed;
864                     }
865                 }
866         }
867         revert OwnerQueryForNonexistentToken();
868     }
869 
870     /**
871      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
872      */
873     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
874         ownership.addr = address(uint160(packed));
875         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
876         ownership.burned = packed & _BITMASK_BURNED != 0;
877         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
878     }
879 
880     /**
881      * @dev Packs ownership data into a single uint256.
882      */
883     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
884         assembly {
885             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
886             owner := and(owner, _BITMASK_ADDRESS)
887             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
888             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
889         }
890     }
891 
892     /**
893      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
894      */
895     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
896         // For branchless setting of the `nextInitialized` flag.
897         assembly {
898             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
899             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
900         }
901     }
902 
903     // =============================================================
904     //                      APPROVAL OPERATIONS
905     // =============================================================
906 
907     /**
908      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
909      * The approval is cleared when the token is transferred.
910      *
911      * Only a single account can be approved at a time, so approving the
912      * zero address clears previous approvals.
913      *
914      * Requirements:
915      *
916      * - The caller must own the token or be an approved operator.
917      * - `tokenId` must exist.
918      *
919      * Emits an {Approval} event.
920      */
921     function approve(address to, uint256 tokenId) public virtual override {
922         address owner = ownerOf(tokenId);
923 
924         if (_msgSenderERC721A() != owner)
925             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
926                 revert ApprovalCallerNotOwnerNorApproved();
927             }
928 
929         _tokenApprovals[tokenId].value = to;
930         emit Approval(owner, to, tokenId);
931     }
932 
933     /**
934      * @dev Returns the account approved for `tokenId` token.
935      *
936      * Requirements:
937      *
938      * - `tokenId` must exist.
939      */
940     function getApproved(uint256 tokenId) public view virtual override returns (address) {
941         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
942 
943         return _tokenApprovals[tokenId].value;
944     }
945 
946     /**
947      * @dev Approve or remove `operator` as an operator for the caller.
948      * Operators can call {transferFrom} or {safeTransferFrom}
949      * for any token owned by the caller.
950      *
951      * Requirements:
952      *
953      * - The `operator` cannot be the caller.
954      *
955      * Emits an {ApprovalForAll} event.
956      */
957     function setApprovalForAll(address operator, bool approved) public virtual override {
958         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
959 
960         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
961         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
962     }
963 
964     /**
965      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
966      *
967      * See {setApprovalForAll}.
968      */
969     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
970         return _operatorApprovals[owner][operator];
971     }
972 
973     /**
974      * @dev Returns whether `tokenId` exists.
975      *
976      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
977      *
978      * Tokens start existing when they are minted. See {_mint}.
979      */
980     function _exists(uint256 tokenId) internal view virtual returns (bool) {
981         return
982             _startTokenId() <= tokenId &&
983             tokenId < _currentIndex && // If within bounds,
984             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
985     }
986 
987     /**
988      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
989      */
990     function _isSenderApprovedOrOwner(
991         address approvedAddress,
992         address owner,
993         address msgSender
994     ) private pure returns (bool result) {
995         assembly {
996             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
997             owner := and(owner, _BITMASK_ADDRESS)
998             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
999             msgSender := and(msgSender, _BITMASK_ADDRESS)
1000             // `msgSender == owner || msgSender == approvedAddress`.
1001             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1002         }
1003     }
1004 
1005     /**
1006      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1007      */
1008     function _getApprovedSlotAndAddress(uint256 tokenId)
1009         private
1010         view
1011         returns (uint256 approvedAddressSlot, address approvedAddress)
1012     {
1013         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1014         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1015         assembly {
1016             approvedAddressSlot := tokenApproval.slot
1017             approvedAddress := sload(approvedAddressSlot)
1018         }
1019     }
1020 
1021     // =============================================================
1022     //                      TRANSFER OPERATIONS
1023     // =============================================================
1024 
1025     /**
1026      * @dev Transfers `tokenId` from `from` to `to`.
1027      *
1028      * Requirements:
1029      *
1030      * - `from` cannot be the zero address.
1031      * - `to` cannot be the zero address.
1032      * - `tokenId` token must be owned by `from`.
1033      * - If the caller is not `from`, it must be approved to move this token
1034      * by either {approve} or {setApprovalForAll}.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function transferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) public virtual override {
1043         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1044 
1045         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1046 
1047         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1048 
1049         // The nested ifs save around 20+ gas over a compound boolean condition.
1050         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1051             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1052 
1053         if (to == address(0)) revert TransferToZeroAddress();
1054 
1055         _beforeTokenTransfers(from, to, tokenId, 1);
1056 
1057         // Clear approvals from the previous owner.
1058         assembly {
1059             if approvedAddress {
1060                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1061                 sstore(approvedAddressSlot, 0)
1062             }
1063         }
1064 
1065         // Underflow of the sender's balance is impossible because we check for
1066         // ownership above and the recipient's balance can't realistically overflow.
1067         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1068         unchecked {
1069             // We can directly increment and decrement the balances.
1070             --_packedAddressData[from]; // Updates: `balance -= 1`.
1071             ++_packedAddressData[to]; // Updates: `balance += 1`.
1072 
1073             // Updates:
1074             // - `address` to the next owner.
1075             // - `startTimestamp` to the timestamp of transfering.
1076             // - `burned` to `false`.
1077             // - `nextInitialized` to `true`.
1078             _packedOwnerships[tokenId] = _packOwnershipData(
1079                 to,
1080                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1081             );
1082 
1083             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1084             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1085                 uint256 nextTokenId = tokenId + 1;
1086                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1087                 if (_packedOwnerships[nextTokenId] == 0) {
1088                     // If the next slot is within bounds.
1089                     if (nextTokenId != _currentIndex) {
1090                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1091                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1092                     }
1093                 }
1094             }
1095         }
1096 
1097         emit Transfer(from, to, tokenId);
1098         _afterTokenTransfers(from, to, tokenId, 1);
1099     }
1100 
1101     /**
1102      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1103      */
1104     function safeTransferFrom(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) public virtual override {
1109         safeTransferFrom(from, to, tokenId, '');
1110     }
1111 
1112     /**
1113      * @dev Safely transfers `tokenId` token from `from` to `to`.
1114      *
1115      * Requirements:
1116      *
1117      * - `from` cannot be the zero address.
1118      * - `to` cannot be the zero address.
1119      * - `tokenId` token must exist and be owned by `from`.
1120      * - If the caller is not `from`, it must be approved to move this token
1121      * by either {approve} or {setApprovalForAll}.
1122      * - If `to` refers to a smart contract, it must implement
1123      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1124      *
1125      * Emits a {Transfer} event.
1126      */
1127     function safeTransferFrom(
1128         address from,
1129         address to,
1130         uint256 tokenId,
1131         bytes memory _data
1132     ) public virtual override {
1133         transferFrom(from, to, tokenId);
1134         if (to.code.length != 0)
1135             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1136                 revert TransferToNonERC721ReceiverImplementer();
1137             }
1138     }
1139 
1140     /**
1141      * @dev Hook that is called before a set of serially-ordered token IDs
1142      * are about to be transferred. This includes minting.
1143      * And also called before burning one token.
1144      *
1145      * `startTokenId` - the first token ID to be transferred.
1146      * `quantity` - the amount to be transferred.
1147      *
1148      * Calling conditions:
1149      *
1150      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1151      * transferred to `to`.
1152      * - When `from` is zero, `tokenId` will be minted for `to`.
1153      * - When `to` is zero, `tokenId` will be burned by `from`.
1154      * - `from` and `to` are never both zero.
1155      */
1156     function _beforeTokenTransfers(
1157         address from,
1158         address to,
1159         uint256 startTokenId,
1160         uint256 quantity
1161     ) internal virtual {}
1162 
1163     /**
1164      * @dev Hook that is called after a set of serially-ordered token IDs
1165      * have been transferred. This includes minting.
1166      * And also called after one token has been burned.
1167      *
1168      * `startTokenId` - the first token ID to be transferred.
1169      * `quantity` - the amount to be transferred.
1170      *
1171      * Calling conditions:
1172      *
1173      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1174      * transferred to `to`.
1175      * - When `from` is zero, `tokenId` has been minted for `to`.
1176      * - When `to` is zero, `tokenId` has been burned by `from`.
1177      * - `from` and `to` are never both zero.
1178      */
1179     function _afterTokenTransfers(
1180         address from,
1181         address to,
1182         uint256 startTokenId,
1183         uint256 quantity
1184     ) internal virtual {}
1185 
1186     /**
1187      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1188      *
1189      * `from` - Previous owner of the given token ID.
1190      * `to` - Target address that will receive the token.
1191      * `tokenId` - Token ID to be transferred.
1192      * `_data` - Optional data to send along with the call.
1193      *
1194      * Returns whether the call correctly returned the expected magic value.
1195      */
1196     function _checkContractOnERC721Received(
1197         address from,
1198         address to,
1199         uint256 tokenId,
1200         bytes memory _data
1201     ) private returns (bool) {
1202         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1203             bytes4 retval
1204         ) {
1205             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1206         } catch (bytes memory reason) {
1207             if (reason.length == 0) {
1208                 revert TransferToNonERC721ReceiverImplementer();
1209             } else {
1210                 assembly {
1211                     revert(add(32, reason), mload(reason))
1212                 }
1213             }
1214         }
1215     }
1216 
1217     // =============================================================
1218     //                        MINT OPERATIONS
1219     // =============================================================
1220 
1221     /**
1222      * @dev Mints `quantity` tokens and transfers them to `to`.
1223      *
1224      * Requirements:
1225      *
1226      * - `to` cannot be the zero address.
1227      * - `quantity` must be greater than 0.
1228      *
1229      * Emits a {Transfer} event for each mint.
1230      */
1231     function _mint(address to, uint256 quantity) internal virtual {
1232         uint256 startTokenId = _currentIndex;
1233         if (quantity == 0) revert MintZeroQuantity();
1234 
1235         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1236 
1237         // Overflows are incredibly unrealistic.
1238         // `balance` and `numberMinted` have a maximum limit of 2**64.
1239         // `tokenId` has a maximum limit of 2**256.
1240         unchecked {
1241             // Updates:
1242             // - `balance += quantity`.
1243             // - `numberMinted += quantity`.
1244             //
1245             // We can directly add to the `balance` and `numberMinted`.
1246             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1247 
1248             // Updates:
1249             // - `address` to the owner.
1250             // - `startTimestamp` to the timestamp of minting.
1251             // - `burned` to `false`.
1252             // - `nextInitialized` to `quantity == 1`.
1253             _packedOwnerships[startTokenId] = _packOwnershipData(
1254                 to,
1255                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1256             );
1257 
1258             uint256 toMasked;
1259             uint256 end = startTokenId + quantity;
1260 
1261             // Use assembly to loop and emit the `Transfer` event for gas savings.
1262             assembly {
1263                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1264                 toMasked := and(to, _BITMASK_ADDRESS)
1265                 // Emit the `Transfer` event.
1266                 log4(
1267                     0, // Start of data (0, since no data).
1268                     0, // End of data (0, since no data).
1269                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1270                     0, // `address(0)`.
1271                     toMasked, // `to`.
1272                     startTokenId // `tokenId`.
1273                 )
1274 
1275                 for {
1276                     let tokenId := add(startTokenId, 1)
1277                 } iszero(eq(tokenId, end)) {
1278                     tokenId := add(tokenId, 1)
1279                 } {
1280                     // Emit the `Transfer` event. Similar to above.
1281                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1282                 }
1283             }
1284             if (toMasked == 0) revert MintToZeroAddress();
1285 
1286             _currentIndex = end;
1287         }
1288         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1289     }
1290 
1291     /**
1292      * @dev Mints `quantity` tokens and transfers them to `to`.
1293      *
1294      * This function is intended for efficient minting only during contract creation.
1295      *
1296      * It emits only one {ConsecutiveTransfer} as defined in
1297      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1298      * instead of a sequence of {Transfer} event(s).
1299      *
1300      * Calling this function outside of contract creation WILL make your contract
1301      * non-compliant with the ERC721 standard.
1302      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1303      * {ConsecutiveTransfer} event is only permissible during contract creation.
1304      *
1305      * Requirements:
1306      *
1307      * - `to` cannot be the zero address.
1308      * - `quantity` must be greater than 0.
1309      *
1310      * Emits a {ConsecutiveTransfer} event.
1311      */
1312     function _mintERC2309(address to, uint256 quantity) internal virtual {
1313         uint256 startTokenId = _currentIndex;
1314         if (to == address(0)) revert MintToZeroAddress();
1315         if (quantity == 0) revert MintZeroQuantity();
1316         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1317 
1318         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1319 
1320         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1321         unchecked {
1322             // Updates:
1323             // - `balance += quantity`.
1324             // - `numberMinted += quantity`.
1325             //
1326             // We can directly add to the `balance` and `numberMinted`.
1327             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1328 
1329             // Updates:
1330             // - `address` to the owner.
1331             // - `startTimestamp` to the timestamp of minting.
1332             // - `burned` to `false`.
1333             // - `nextInitialized` to `quantity == 1`.
1334             _packedOwnerships[startTokenId] = _packOwnershipData(
1335                 to,
1336                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1337             );
1338 
1339             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1340 
1341             _currentIndex = startTokenId + quantity;
1342         }
1343         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1344     }
1345 
1346     /**
1347      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1348      *
1349      * Requirements:
1350      *
1351      * - If `to` refers to a smart contract, it must implement
1352      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1353      * - `quantity` must be greater than 0.
1354      *
1355      * See {_mint}.
1356      *
1357      * Emits a {Transfer} event for each mint.
1358      */
1359     function _safeMint(
1360         address to,
1361         uint256 quantity,
1362         bytes memory _data
1363     ) internal virtual {
1364         _mint(to, quantity);
1365 
1366         unchecked {
1367             if (to.code.length != 0) {
1368                 uint256 end = _currentIndex;
1369                 uint256 index = end - quantity;
1370                 do {
1371                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1372                         revert TransferToNonERC721ReceiverImplementer();
1373                     }
1374                 } while (index < end);
1375                 // Reentrancy protection.
1376                 if (_currentIndex != end) revert();
1377             }
1378         }
1379     }
1380 
1381     /**
1382      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1383      */
1384     function _safeMint(address to, uint256 quantity) internal virtual {
1385         _safeMint(to, quantity, '');
1386     }
1387 
1388     // =============================================================
1389     //                        BURN OPERATIONS
1390     // =============================================================
1391 
1392     /**
1393      * @dev Equivalent to `_burn(tokenId, false)`.
1394      */
1395     function _burn(uint256 tokenId) internal virtual {
1396         _burn(tokenId, false);
1397     }
1398 
1399     /**
1400      * @dev Destroys `tokenId`.
1401      * The approval is cleared when the token is burned.
1402      *
1403      * Requirements:
1404      *
1405      * - `tokenId` must exist.
1406      *
1407      * Emits a {Transfer} event.
1408      */
1409     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1410         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1411 
1412         address from = address(uint160(prevOwnershipPacked));
1413 
1414         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1415 
1416         if (approvalCheck) {
1417             // The nested ifs save around 20+ gas over a compound boolean condition.
1418             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1419                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1420         }
1421 
1422         _beforeTokenTransfers(from, address(0), tokenId, 1);
1423 
1424         // Clear approvals from the previous owner.
1425         assembly {
1426             if approvedAddress {
1427                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1428                 sstore(approvedAddressSlot, 0)
1429             }
1430         }
1431 
1432         // Underflow of the sender's balance is impossible because we check for
1433         // ownership above and the recipient's balance can't realistically overflow.
1434         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1435         unchecked {
1436             // Updates:
1437             // - `balance -= 1`.
1438             // - `numberBurned += 1`.
1439             //
1440             // We can directly decrement the balance, and increment the number burned.
1441             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1442             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1443 
1444             // Updates:
1445             // - `address` to the last owner.
1446             // - `startTimestamp` to the timestamp of burning.
1447             // - `burned` to `true`.
1448             // - `nextInitialized` to `true`.
1449             _packedOwnerships[tokenId] = _packOwnershipData(
1450                 from,
1451                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1452             );
1453 
1454             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1455             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1456                 uint256 nextTokenId = tokenId + 1;
1457                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1458                 if (_packedOwnerships[nextTokenId] == 0) {
1459                     // If the next slot is within bounds.
1460                     if (nextTokenId != _currentIndex) {
1461                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1462                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1463                     }
1464                 }
1465             }
1466         }
1467 
1468         emit Transfer(from, address(0), tokenId);
1469         _afterTokenTransfers(from, address(0), tokenId, 1);
1470 
1471         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1472         unchecked {
1473             _burnCounter++;
1474         }
1475     }
1476 
1477     // =============================================================
1478     //                     EXTRA DATA OPERATIONS
1479     // =============================================================
1480 
1481     /**
1482      * @dev Directly sets the extra data for the ownership data `index`.
1483      */
1484     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1485         uint256 packed = _packedOwnerships[index];
1486         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1487         uint256 extraDataCasted;
1488         // Cast `extraData` with assembly to avoid redundant masking.
1489         assembly {
1490             extraDataCasted := extraData
1491         }
1492         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1493         _packedOwnerships[index] = packed;
1494     }
1495 
1496     /**
1497      * @dev Called during each token transfer to set the 24bit `extraData` field.
1498      * Intended to be overridden by the cosumer contract.
1499      *
1500      * `previousExtraData` - the value of `extraData` before transfer.
1501      *
1502      * Calling conditions:
1503      *
1504      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1505      * transferred to `to`.
1506      * - When `from` is zero, `tokenId` will be minted for `to`.
1507      * - When `to` is zero, `tokenId` will be burned by `from`.
1508      * - `from` and `to` are never both zero.
1509      */
1510     function _extraData(
1511         address from,
1512         address to,
1513         uint24 previousExtraData
1514     ) internal view virtual returns (uint24) {}
1515 
1516     /**
1517      * @dev Returns the next extra data for the packed ownership data.
1518      * The returned result is shifted into position.
1519      */
1520     function _nextExtraData(
1521         address from,
1522         address to,
1523         uint256 prevOwnershipPacked
1524     ) private view returns (uint256) {
1525         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1526         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1527     }
1528 
1529     // =============================================================
1530     //                       OTHER OPERATIONS
1531     // =============================================================
1532 
1533     /**
1534      * @dev Returns the message sender (defaults to `msg.sender`).
1535      *
1536      * If you are writing GSN compatible contracts, you need to override this function.
1537      */
1538     function _msgSenderERC721A() internal view virtual returns (address) {
1539         return msg.sender;
1540     }
1541 
1542     /**
1543      * @dev Converts a uint256 to its ASCII string decimal representation.
1544      */
1545     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1546         assembly {
1547             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1548             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1549             // We will need 1 32-byte word to store the length,
1550             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1551             str := add(mload(0x40), 0x80)
1552             // Update the free memory pointer to allocate.
1553             mstore(0x40, str)
1554 
1555             // Cache the end of the memory to calculate the length later.
1556             let end := str
1557 
1558             // We write the string from rightmost digit to leftmost digit.
1559             // The following is essentially a do-while loop that also handles the zero case.
1560             // prettier-ignore
1561             for { let temp := value } 1 {} {
1562                 str := sub(str, 1)
1563                 // Write the character to the pointer.
1564                 // The ASCII index of the '0' character is 48.
1565                 mstore8(str, add(48, mod(temp, 10)))
1566                 // Keep dividing `temp` until zero.
1567                 temp := div(temp, 10)
1568                 // prettier-ignore
1569                 if iszero(temp) { break }
1570             }
1571 
1572             let length := sub(end, str)
1573             // Move the pointer 32 bytes leftwards to make room for the length.
1574             str := sub(str, 0x20)
1575             // Store the length.
1576             mstore(str, length)
1577         }
1578     }
1579 }
1580 
1581 // File: contracts/CryptoKamiButts.sol
1582 
1583 pragma solidity ^0.8.4;
1584 
1585 contract CryptoKamiButts is ERC721A, Ownable {
1586 
1587     using Strings for uint256;
1588 
1589     string public baseURI = "https://cryptokamibutts.s3.amazonaws.com/metadata/";
1590 
1591     uint256 public price = 0.002 ether;
1592     uint256 public maxPerTx = 10;
1593     uint256 public maxSupply = 5555;
1594 
1595     uint256 public maxFreePerWallet = 1;
1596     uint256 public totalFreeMinted = 0;
1597     uint256 public maxFreeSupply = 3333;
1598 
1599     mapping(address => uint256) public _mintedFreeAmount;
1600 
1601     constructor() ERC721A("CryptoKamiButts", "KAMIBUTTS") {
1602         _mint(msg.sender, 1);
1603     }
1604 
1605     function mint(uint256 _amount) external payable {
1606 
1607         require(msg.value >= _amount * price, "Incorrect amount of ETH.");
1608         require(totalSupply() + _amount <= maxSupply, "Sold out.");
1609         require(tx.origin == msg.sender, "Only humans please.");
1610         require(_amount <= maxPerTx, "You may only mint a max of 10 per transaction");
1611 
1612         _mint(msg.sender, _amount);
1613     }
1614 
1615     function freeMint(uint256 _amount) external payable {
1616         require(_mintedFreeAmount[msg.sender] + _amount <= maxFreePerWallet, "You have minted the max free amount allowed per wallet.");
1617 		require(totalFreeMinted + _amount <= maxFreeSupply, "Cannot exceed Free supply." );
1618         require(totalSupply() + _amount <= maxSupply, "Sold out.");
1619 
1620         _mintedFreeAmount[msg.sender]++;
1621         totalFreeMinted++;
1622         _safeMint(msg.sender, _amount);
1623 	}
1624 
1625     function tokenURI(uint256 tokenId)
1626         public view virtual override returns (string memory) {
1627         require(
1628             _exists(tokenId),
1629             "ERC721Metadata: URI query for nonexistent token"
1630         );
1631         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1632     }
1633 
1634     function setBaseURI(string calldata baseURI_) external onlyOwner {
1635         baseURI = baseURI_;
1636     }
1637 
1638     function setPrice(uint256 _price) external onlyOwner {
1639         price = _price;
1640     }
1641 
1642     function setMaxPerTx(uint256 _amount) external onlyOwner {
1643         maxPerTx = _amount;
1644     }
1645 
1646     function reduceSupply(uint256 _newSupply) external onlyOwner {
1647         require(_newSupply < maxSupply);
1648         maxSupply = _newSupply;
1649     }
1650 
1651     function setmaxFreeSupply(uint256 _newMaxFreeSupply) public onlyOwner {
1652         maxFreeSupply = _newMaxFreeSupply;
1653     }
1654 
1655     function _startTokenId() internal pure override returns (uint256) {
1656         return 1;
1657     }
1658 
1659     function withdraw() external onlyOwner {
1660         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1661         require(success, "Transfer failed.");
1662     }
1663 
1664 }