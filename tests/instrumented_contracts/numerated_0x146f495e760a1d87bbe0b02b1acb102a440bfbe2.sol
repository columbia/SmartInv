1 //  ██╗   ██╗████████╗ ██████╗ ██████╗ ██╗ █████╗ 
2 //  ██║   ██║╚══██╔══╝██╔═══██╗██╔══██╗██║██╔══██╗
3 //  ██║   ██║   ██║   ██║   ██║██████╔╝██║███████║
4 //  ██║   ██║   ██║   ██║   ██║██╔═══╝ ██║██╔══██║
5 //  ╚██████╔╝   ██║   ╚██████╔╝██║     ██║██║  ██║
6 //   ╚═════╝    ╚═╝    ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝
7 //                                                
8 
9 
10 // File: @openzeppelin/contracts/utils/Strings.sol
11 
12 
13 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev String operations.
19  */
20 library Strings {
21     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
22     uint8 private constant _ADDRESS_LENGTH = 20;
23 
24     /**
25      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
26      */
27     function toString(uint256 value) internal pure returns (string memory) {
28         // Inspired by OraclizeAPI's implementation - MIT licence
29         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
30 
31         if (value == 0) {
32             return "0";
33         }
34         uint256 temp = value;
35         uint256 digits;
36         while (temp != 0) {
37             digits++;
38             temp /= 10;
39         }
40         bytes memory buffer = new bytes(digits);
41         while (value != 0) {
42             digits -= 1;
43             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
44             value /= 10;
45         }
46         return string(buffer);
47     }
48 
49     /**
50      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
51      */
52     function toHexString(uint256 value) internal pure returns (string memory) {
53         if (value == 0) {
54             return "0x00";
55         }
56         uint256 temp = value;
57         uint256 length = 0;
58         while (temp != 0) {
59             length++;
60             temp >>= 8;
61         }
62         return toHexString(value, length);
63     }
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
67      */
68     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
69         bytes memory buffer = new bytes(2 * length + 2);
70         buffer[0] = "0";
71         buffer[1] = "x";
72         for (uint256 i = 2 * length + 1; i > 1; --i) {
73             buffer[i] = _HEX_SYMBOLS[value & 0xf];
74             value >>= 4;
75         }
76         require(value == 0, "Strings: hex length insufficient");
77         return string(buffer);
78     }
79 
80     /**
81      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
82      */
83     function toHexString(address addr) internal pure returns (string memory) {
84         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
85     }
86 }
87 
88 // File: @openzeppelin/contracts/utils/Context.sol
89 
90 
91 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Provides information about the current execution context, including the
97  * sender of the transaction and its data. While these are generally available
98  * via msg.sender and msg.data, they should not be accessed in such a direct
99  * manner, since when dealing with meta-transactions the account sending and
100  * paying for execution may not be the actual sender (as far as an application
101  * is concerned).
102  *
103  * This contract is only required for intermediate, library-like contracts.
104  */
105 abstract contract Context {
106     function _msgSender() internal view virtual returns (address) {
107         return msg.sender;
108     }
109 
110     function _msgData() internal view virtual returns (bytes calldata) {
111         return msg.data;
112     }
113 }
114 
115 // File: @openzeppelin/contracts/access/Ownable.sol
116 
117 
118 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 
123 /**
124  * @dev Contract module which provides a basic access control mechanism, where
125  * there is an account (an owner) that can be granted exclusive access to
126  * specific functions.
127  *
128  * By default, the owner account will be the one that deploys the contract. This
129  * can later be changed with {transferOwnership}.
130  *
131  * This module is used through inheritance. It will make available the modifier
132  * `onlyOwner`, which can be applied to your functions to restrict their use to
133  * the owner.
134  */
135 abstract contract Ownable is Context {
136     address private _owner;
137 
138     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
139 
140     /**
141      * @dev Initializes the contract setting the deployer as the initial owner.
142      */
143     constructor() {
144         _transferOwnership(_msgSender());
145     }
146 
147     /**
148      * @dev Throws if called by any account other than the owner.
149      */
150     modifier onlyOwner() {
151         _checkOwner();
152         _;
153     }
154 
155     /**
156      * @dev Returns the address of the current owner.
157      */
158     function owner() public view virtual returns (address) {
159         return _owner;
160     }
161 
162     /**
163      * @dev Throws if the sender is not the owner.
164      */
165     function _checkOwner() internal view virtual {
166         require(owner() == _msgSender(), "Ownable: caller is not the owner");
167     }
168 
169     /**
170      * @dev Leaves the contract without owner. It will not be possible to call
171      * `onlyOwner` functions anymore. Can only be called by the current owner.
172      *
173      * NOTE: Renouncing ownership will leave the contract without an owner,
174      * thereby removing any functionality that is only available to the owner.
175      */
176     function renounceOwnership() public virtual onlyOwner {
177         _transferOwnership(address(0));
178     }
179 
180     /**
181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
182      * Can only be called by the current owner.
183      */
184     function transferOwnership(address newOwner) public virtual onlyOwner {
185         require(newOwner != address(0), "Ownable: new owner is the zero address");
186         _transferOwnership(newOwner);
187     }
188 
189     /**
190      * @dev Transfers ownership of the contract to a new account (`newOwner`).
191      * Internal function without access restriction.
192      */
193     function _transferOwnership(address newOwner) internal virtual {
194         address oldOwner = _owner;
195         _owner = newOwner;
196         emit OwnershipTransferred(oldOwner, newOwner);
197     }
198 }
199 
200 // File: erc721a/contracts/IERC721A.sol
201 
202 
203 // ERC721A Contracts v4.1.0
204 // Creator: Chiru Labs
205 
206 pragma solidity ^0.8.4;
207 
208 /**
209  * @dev Interface of an ERC721A compliant contract.
210  */
211 interface IERC721A {
212     /**
213      * The caller must own the token or be an approved operator.
214      */
215     error ApprovalCallerNotOwnerNorApproved();
216 
217     /**
218      * The token does not exist.
219      */
220     error ApprovalQueryForNonexistentToken();
221 
222     /**
223      * The caller cannot approve to their own address.
224      */
225     error ApproveToCaller();
226 
227     /**
228      * Cannot query the balance for the zero address.
229      */
230     error BalanceQueryForZeroAddress();
231 
232     /**
233      * Cannot mint to the zero address.
234      */
235     error MintToZeroAddress();
236 
237     /**
238      * The quantity of tokens minted must be more than zero.
239      */
240     error MintZeroQuantity();
241 
242     /**
243      * The token does not exist.
244      */
245     error OwnerQueryForNonexistentToken();
246 
247     /**
248      * The caller must own the token or be an approved operator.
249      */
250     error TransferCallerNotOwnerNorApproved();
251 
252     /**
253      * The token must be owned by `from`.
254      */
255     error TransferFromIncorrectOwner();
256 
257     /**
258      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
259      */
260     error TransferToNonERC721ReceiverImplementer();
261 
262     /**
263      * Cannot transfer to the zero address.
264      */
265     error TransferToZeroAddress();
266 
267     /**
268      * The token does not exist.
269      */
270     error URIQueryForNonexistentToken();
271 
272     /**
273      * The `quantity` minted with ERC2309 exceeds the safety limit.
274      */
275     error MintERC2309QuantityExceedsLimit();
276 
277     /**
278      * The `extraData` cannot be set on an unintialized ownership slot.
279      */
280     error OwnershipNotInitializedForExtraData();
281 
282     struct TokenOwnership {
283         // The address of the owner.
284         address addr;
285         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
286         uint64 startTimestamp;
287         // Whether the token has been burned.
288         bool burned;
289         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
290         uint24 extraData;
291     }
292 
293     /**
294      * @dev Returns the total amount of tokens stored by the contract.
295      *
296      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
297      */
298     function totalSupply() external view returns (uint256);
299 
300     // ==============================
301     //            IERC165
302     // ==============================
303 
304     /**
305      * @dev Returns true if this contract implements the interface defined by
306      * `interfaceId`. See the corresponding
307      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
308      * to learn more about how these ids are created.
309      *
310      * This function call must use less than 30 000 gas.
311      */
312     function supportsInterface(bytes4 interfaceId) external view returns (bool);
313 
314     // ==============================
315     //            IERC721
316     // ==============================
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
329      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
330      */
331     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
332 
333     /**
334      * @dev Returns the number of tokens in ``owner``'s account.
335      */
336     function balanceOf(address owner) external view returns (uint256 balance);
337 
338     /**
339      * @dev Returns the owner of the `tokenId` token.
340      *
341      * Requirements:
342      *
343      * - `tokenId` must exist.
344      */
345     function ownerOf(uint256 tokenId) external view returns (address owner);
346 
347     /**
348      * @dev Safely transfers `tokenId` token from `from` to `to`.
349      *
350      * Requirements:
351      *
352      * - `from` cannot be the zero address.
353      * - `to` cannot be the zero address.
354      * - `tokenId` token must exist and be owned by `from`.
355      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
356      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
357      *
358      * Emits a {Transfer} event.
359      */
360     function safeTransferFrom(
361         address from,
362         address to,
363         uint256 tokenId,
364         bytes calldata data
365     ) external;
366 
367     /**
368      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
369      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
370      *
371      * Requirements:
372      *
373      * - `from` cannot be the zero address.
374      * - `to` cannot be the zero address.
375      * - `tokenId` token must exist and be owned by `from`.
376      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
377      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
378      *
379      * Emits a {Transfer} event.
380      */
381     function safeTransferFrom(
382         address from,
383         address to,
384         uint256 tokenId
385     ) external;
386 
387     /**
388      * @dev Transfers `tokenId` token from `from` to `to`.
389      *
390      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
391      *
392      * Requirements:
393      *
394      * - `from` cannot be the zero address.
395      * - `to` cannot be the zero address.
396      * - `tokenId` token must be owned by `from`.
397      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
398      *
399      * Emits a {Transfer} event.
400      */
401     function transferFrom(
402         address from,
403         address to,
404         uint256 tokenId
405     ) external;
406 
407     /**
408      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
409      * The approval is cleared when the token is transferred.
410      *
411      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
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
424      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
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
446      * See {setApprovalForAll}
447      */
448     function isApprovedForAll(address owner, address operator) external view returns (bool);
449 
450     // ==============================
451     //        IERC721Metadata
452     // ==============================
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
469     // ==============================
470     //            IERC2309
471     // ==============================
472 
473     /**
474      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
475      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
476      */
477     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
478 }
479 
480 // File: erc721a/contracts/ERC721A.sol
481 
482 
483 // ERC721A Contracts v4.1.0
484 // Creator: Chiru Labs
485 
486 pragma solidity ^0.8.4;
487 
488 
489 /**
490  * @dev ERC721 token receiver interface.
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
502  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
503  * including the Metadata extension. Built to optimize for lower gas during batch mints.
504  *
505  * Assumes serials are sequentially minted starting at `_startTokenId()`
506  * (defaults to 0, e.g. 0, 1, 2, 3..).
507  *
508  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
509  *
510  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
511  */
512 contract ERC721A is IERC721A {
513     // Mask of an entry in packed address data.
514     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
515 
516     // The bit position of `numberMinted` in packed address data.
517     uint256 private constant BITPOS_NUMBER_MINTED = 64;
518 
519     // The bit position of `numberBurned` in packed address data.
520     uint256 private constant BITPOS_NUMBER_BURNED = 128;
521 
522     // The bit position of `aux` in packed address data.
523     uint256 private constant BITPOS_AUX = 192;
524 
525     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
526     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
527 
528     // The bit position of `startTimestamp` in packed ownership.
529     uint256 private constant BITPOS_START_TIMESTAMP = 160;
530 
531     // The bit mask of the `burned` bit in packed ownership.
532     uint256 private constant BITMASK_BURNED = 1 << 224;
533 
534     // The bit position of the `nextInitialized` bit in packed ownership.
535     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
536 
537     // The bit mask of the `nextInitialized` bit in packed ownership.
538     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
539 
540     // The bit position of `extraData` in packed ownership.
541     uint256 private constant BITPOS_EXTRA_DATA = 232;
542 
543     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
544     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
545 
546     // The mask of the lower 160 bits for addresses.
547     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
548 
549     // The maximum `quantity` that can be minted with `_mintERC2309`.
550     // This limit is to prevent overflows on the address data entries.
551     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
552     // is required to cause an overflow, which is unrealistic.
553     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
554 
555     // The tokenId of the next token to be minted.
556     uint256 private _currentIndex;
557 
558     // The number of tokens burned.
559     uint256 private _burnCounter;
560 
561     // Token name
562     string private _name;
563 
564     // Token symbol
565     string private _symbol;
566 
567     // Mapping from token ID to ownership details
568     // An empty struct value does not necessarily mean the token is unowned.
569     // See `_packedOwnershipOf` implementation for details.
570     //
571     // Bits Layout:
572     // - [0..159]   `addr`
573     // - [160..223] `startTimestamp`
574     // - [224]      `burned`
575     // - [225]      `nextInitialized`
576     // - [232..255] `extraData`
577     mapping(uint256 => uint256) private _packedOwnerships;
578 
579     // Mapping owner address to address data.
580     //
581     // Bits Layout:
582     // - [0..63]    `balance`
583     // - [64..127]  `numberMinted`
584     // - [128..191] `numberBurned`
585     // - [192..255] `aux`
586     mapping(address => uint256) private _packedAddressData;
587 
588     // Mapping from token ID to approved address.
589     mapping(uint256 => address) private _tokenApprovals;
590 
591     // Mapping from owner to operator approvals
592     mapping(address => mapping(address => bool)) private _operatorApprovals;
593 
594     constructor(string memory name_, string memory symbol_) {
595         _name = name_;
596         _symbol = symbol_;
597         _currentIndex = _startTokenId();
598     }
599 
600     /**
601      * @dev Returns the starting token ID.
602      * To change the starting token ID, please override this function.
603      */
604     function _startTokenId() internal view virtual returns (uint256) {
605         return 0;
606     }
607 
608     /**
609      * @dev Returns the next token ID to be minted.
610      */
611     function _nextTokenId() internal view returns (uint256) {
612         return _currentIndex;
613     }
614 
615     /**
616      * @dev Returns the total number of tokens in existence.
617      * Burned tokens will reduce the count.
618      * To get the total number of tokens minted, please see `_totalMinted`.
619      */
620     function totalSupply() public view override returns (uint256) {
621         // Counter underflow is impossible as _burnCounter cannot be incremented
622         // more than `_currentIndex - _startTokenId()` times.
623         unchecked {
624             return _currentIndex - _burnCounter - _startTokenId();
625         }
626     }
627 
628     /**
629      * @dev Returns the total amount of tokens minted in the contract.
630      */
631     function _totalMinted() internal view returns (uint256) {
632         // Counter underflow is impossible as _currentIndex does not decrement,
633         // and it is initialized to `_startTokenId()`
634         unchecked {
635             return _currentIndex - _startTokenId();
636         }
637     }
638 
639     /**
640      * @dev Returns the total number of tokens burned.
641      */
642     function _totalBurned() internal view returns (uint256) {
643         return _burnCounter;
644     }
645 
646     /**
647      * @dev See {IERC165-supportsInterface}.
648      */
649     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
650         // The interface IDs are constants representing the first 4 bytes of the XOR of
651         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
652         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
653         return
654             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
655             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
656             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
657     }
658 
659     /**
660      * @dev See {IERC721-balanceOf}.
661      */
662     function balanceOf(address owner) public view override returns (uint256) {
663         if (owner == address(0)) revert BalanceQueryForZeroAddress();
664         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
665     }
666 
667     /**
668      * Returns the number of tokens minted by `owner`.
669      */
670     function _numberMinted(address owner) internal view returns (uint256) {
671         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
672     }
673 
674     /**
675      * Returns the number of tokens burned by or on behalf of `owner`.
676      */
677     function _numberBurned(address owner) internal view returns (uint256) {
678         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
679     }
680 
681     /**
682      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
683      */
684     function _getAux(address owner) internal view returns (uint64) {
685         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
686     }
687 
688     /**
689      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
690      * If there are multiple variables, please pack them into a uint64.
691      */
692     function _setAux(address owner, uint64 aux) internal {
693         uint256 packed = _packedAddressData[owner];
694         uint256 auxCasted;
695         // Cast `aux` with assembly to avoid redundant masking.
696         assembly {
697             auxCasted := aux
698         }
699         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
700         _packedAddressData[owner] = packed;
701     }
702 
703     /**
704      * Returns the packed ownership data of `tokenId`.
705      */
706     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
707         uint256 curr = tokenId;
708 
709         unchecked {
710             if (_startTokenId() <= curr)
711                 if (curr < _currentIndex) {
712                     uint256 packed = _packedOwnerships[curr];
713                     // If not burned.
714                     if (packed & BITMASK_BURNED == 0) {
715                         // Invariant:
716                         // There will always be an ownership that has an address and is not burned
717                         // before an ownership that does not have an address and is not burned.
718                         // Hence, curr will not underflow.
719                         //
720                         // We can directly compare the packed value.
721                         // If the address is zero, packed is zero.
722                         while (packed == 0) {
723                             packed = _packedOwnerships[--curr];
724                         }
725                         return packed;
726                     }
727                 }
728         }
729         revert OwnerQueryForNonexistentToken();
730     }
731 
732     /**
733      * Returns the unpacked `TokenOwnership` struct from `packed`.
734      */
735     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
736         ownership.addr = address(uint160(packed));
737         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
738         ownership.burned = packed & BITMASK_BURNED != 0;
739         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
740     }
741 
742     /**
743      * Returns the unpacked `TokenOwnership` struct at `index`.
744      */
745     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
746         return _unpackedOwnership(_packedOwnerships[index]);
747     }
748 
749     /**
750      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
751      */
752     function _initializeOwnershipAt(uint256 index) internal {
753         if (_packedOwnerships[index] == 0) {
754             _packedOwnerships[index] = _packedOwnershipOf(index);
755         }
756     }
757 
758     /**
759      * Gas spent here starts off proportional to the maximum mint batch size.
760      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
761      */
762     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
763         return _unpackedOwnership(_packedOwnershipOf(tokenId));
764     }
765 
766     /**
767      * @dev Packs ownership data into a single uint256.
768      */
769     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
770         assembly {
771             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
772             owner := and(owner, BITMASK_ADDRESS)
773             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
774             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
775         }
776     }
777 
778     /**
779      * @dev See {IERC721-ownerOf}.
780      */
781     function ownerOf(uint256 tokenId) public view override returns (address) {
782         return address(uint160(_packedOwnershipOf(tokenId)));
783     }
784 
785     /**
786      * @dev See {IERC721Metadata-name}.
787      */
788     function name() public view virtual override returns (string memory) {
789         return _name;
790     }
791 
792     /**
793      * @dev See {IERC721Metadata-symbol}.
794      */
795     function symbol() public view virtual override returns (string memory) {
796         return _symbol;
797     }
798 
799     /**
800      * @dev See {IERC721Metadata-tokenURI}.
801      */
802     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
803         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
804 
805         string memory baseURI = _baseURI();
806         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
807     }
808 
809     /**
810      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
811      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
812      * by default, it can be overridden in child contracts.
813      */
814     function _baseURI() internal view virtual returns (string memory) {
815         return '';
816     }
817 
818     /**
819      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
820      */
821     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
822         // For branchless setting of the `nextInitialized` flag.
823         assembly {
824             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
825             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
826         }
827     }
828 
829     /**
830      * @dev See {IERC721-approve}.
831      */
832     function approve(address to, uint256 tokenId) public override {
833         address owner = ownerOf(tokenId);
834 
835         if (_msgSenderERC721A() != owner)
836             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
837                 revert ApprovalCallerNotOwnerNorApproved();
838             }
839 
840         _tokenApprovals[tokenId] = to;
841         emit Approval(owner, to, tokenId);
842     }
843 
844     /**
845      * @dev See {IERC721-getApproved}.
846      */
847     function getApproved(uint256 tokenId) public view override returns (address) {
848         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
849 
850         return _tokenApprovals[tokenId];
851     }
852 
853     /**
854      * @dev See {IERC721-setApprovalForAll}.
855      */
856     function setApprovalForAll(address operator, bool approved) public virtual override {
857         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
858 
859         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
860         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
861     }
862 
863     /**
864      * @dev See {IERC721-isApprovedForAll}.
865      */
866     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
867         return _operatorApprovals[owner][operator];
868     }
869 
870     /**
871      * @dev See {IERC721-safeTransferFrom}.
872      */
873     function safeTransferFrom(
874         address from,
875         address to,
876         uint256 tokenId
877     ) public virtual override {
878         safeTransferFrom(from, to, tokenId, '');
879     }
880 
881     /**
882      * @dev See {IERC721-safeTransferFrom}.
883      */
884     function safeTransferFrom(
885         address from,
886         address to,
887         uint256 tokenId,
888         bytes memory _data
889     ) public virtual override {
890         transferFrom(from, to, tokenId);
891         if (to.code.length != 0)
892             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
893                 revert TransferToNonERC721ReceiverImplementer();
894             }
895     }
896 
897     /**
898      * @dev Returns whether `tokenId` exists.
899      *
900      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
901      *
902      * Tokens start existing when they are minted (`_mint`),
903      */
904     function _exists(uint256 tokenId) internal view returns (bool) {
905         return
906             _startTokenId() <= tokenId &&
907             tokenId < _currentIndex && // If within bounds,
908             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
909     }
910 
911     /**
912      * @dev Equivalent to `_safeMint(to, quantity, '')`.
913      */
914     function _safeMint(address to, uint256 quantity) internal {
915         _safeMint(to, quantity, '');
916     }
917 
918     /**
919      * @dev Safely mints `quantity` tokens and transfers them to `to`.
920      *
921      * Requirements:
922      *
923      * - If `to` refers to a smart contract, it must implement
924      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
925      * - `quantity` must be greater than 0.
926      *
927      * See {_mint}.
928      *
929      * Emits a {Transfer} event for each mint.
930      */
931     function _safeMint(
932         address to,
933         uint256 quantity,
934         bytes memory _data
935     ) internal {
936         _mint(to, quantity);
937 
938         unchecked {
939             if (to.code.length != 0) {
940                 uint256 end = _currentIndex;
941                 uint256 index = end - quantity;
942                 do {
943                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
944                         revert TransferToNonERC721ReceiverImplementer();
945                     }
946                 } while (index < end);
947                 // Reentrancy protection.
948                 if (_currentIndex != end) revert();
949             }
950         }
951     }
952 
953     /**
954      * @dev Mints `quantity` tokens and transfers them to `to`.
955      *
956      * Requirements:
957      *
958      * - `to` cannot be the zero address.
959      * - `quantity` must be greater than 0.
960      *
961      * Emits a {Transfer} event for each mint.
962      */
963     function _mint(address to, uint256 quantity) internal {
964         uint256 startTokenId = _currentIndex;
965         if (to == address(0)) revert MintToZeroAddress();
966         if (quantity == 0) revert MintZeroQuantity();
967 
968         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
969 
970         // Overflows are incredibly unrealistic.
971         // `balance` and `numberMinted` have a maximum limit of 2**64.
972         // `tokenId` has a maximum limit of 2**256.
973         unchecked {
974             // Updates:
975             // - `balance += quantity`.
976             // - `numberMinted += quantity`.
977             //
978             // We can directly add to the `balance` and `numberMinted`.
979             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
980 
981             // Updates:
982             // - `address` to the owner.
983             // - `startTimestamp` to the timestamp of minting.
984             // - `burned` to `false`.
985             // - `nextInitialized` to `quantity == 1`.
986             _packedOwnerships[startTokenId] = _packOwnershipData(
987                 to,
988                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
989             );
990 
991             uint256 tokenId = startTokenId;
992             uint256 end = startTokenId + quantity;
993             do {
994                 emit Transfer(address(0), to, tokenId++);
995             } while (tokenId < end);
996 
997             _currentIndex = end;
998         }
999         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1000     }
1001 
1002     /**
1003      * @dev Mints `quantity` tokens and transfers them to `to`.
1004      *
1005      * This function is intended for efficient minting only during contract creation.
1006      *
1007      * It emits only one {ConsecutiveTransfer} as defined in
1008      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1009      * instead of a sequence of {Transfer} event(s).
1010      *
1011      * Calling this function outside of contract creation WILL make your contract
1012      * non-compliant with the ERC721 standard.
1013      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1014      * {ConsecutiveTransfer} event is only permissible during contract creation.
1015      *
1016      * Requirements:
1017      *
1018      * - `to` cannot be the zero address.
1019      * - `quantity` must be greater than 0.
1020      *
1021      * Emits a {ConsecutiveTransfer} event.
1022      */
1023     function _mintERC2309(address to, uint256 quantity) internal {
1024         uint256 startTokenId = _currentIndex;
1025         if (to == address(0)) revert MintToZeroAddress();
1026         if (quantity == 0) revert MintZeroQuantity();
1027         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1028 
1029         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1030 
1031         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1032         unchecked {
1033             // Updates:
1034             // - `balance += quantity`.
1035             // - `numberMinted += quantity`.
1036             //
1037             // We can directly add to the `balance` and `numberMinted`.
1038             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1039 
1040             // Updates:
1041             // - `address` to the owner.
1042             // - `startTimestamp` to the timestamp of minting.
1043             // - `burned` to `false`.
1044             // - `nextInitialized` to `quantity == 1`.
1045             _packedOwnerships[startTokenId] = _packOwnershipData(
1046                 to,
1047                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1048             );
1049 
1050             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1051 
1052             _currentIndex = startTokenId + quantity;
1053         }
1054         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1055     }
1056 
1057     /**
1058      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1059      */
1060     function _getApprovedAddress(uint256 tokenId)
1061         private
1062         view
1063         returns (uint256 approvedAddressSlot, address approvedAddress)
1064     {
1065         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1066         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1067         assembly {
1068             // Compute the slot.
1069             mstore(0x00, tokenId)
1070             mstore(0x20, tokenApprovalsPtr.slot)
1071             approvedAddressSlot := keccak256(0x00, 0x40)
1072             // Load the slot's value from storage.
1073             approvedAddress := sload(approvedAddressSlot)
1074         }
1075     }
1076 
1077     /**
1078      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1079      */
1080     function _isOwnerOrApproved(
1081         address approvedAddress,
1082         address from,
1083         address msgSender
1084     ) private pure returns (bool result) {
1085         assembly {
1086             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1087             from := and(from, BITMASK_ADDRESS)
1088             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1089             msgSender := and(msgSender, BITMASK_ADDRESS)
1090             // `msgSender == from || msgSender == approvedAddress`.
1091             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1092         }
1093     }
1094 
1095     /**
1096      * @dev Transfers `tokenId` from `from` to `to`.
1097      *
1098      * Requirements:
1099      *
1100      * - `to` cannot be the zero address.
1101      * - `tokenId` token must be owned by `from`.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function transferFrom(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) public virtual override {
1110         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1111 
1112         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1113 
1114         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1115 
1116         // The nested ifs save around 20+ gas over a compound boolean condition.
1117         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1118             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1119 
1120         if (to == address(0)) revert TransferToZeroAddress();
1121 
1122         _beforeTokenTransfers(from, to, tokenId, 1);
1123 
1124         // Clear approvals from the previous owner.
1125         assembly {
1126             if approvedAddress {
1127                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1128                 sstore(approvedAddressSlot, 0)
1129             }
1130         }
1131 
1132         // Underflow of the sender's balance is impossible because we check for
1133         // ownership above and the recipient's balance can't realistically overflow.
1134         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1135         unchecked {
1136             // We can directly increment and decrement the balances.
1137             --_packedAddressData[from]; // Updates: `balance -= 1`.
1138             ++_packedAddressData[to]; // Updates: `balance += 1`.
1139 
1140             // Updates:
1141             // - `address` to the next owner.
1142             // - `startTimestamp` to the timestamp of transfering.
1143             // - `burned` to `false`.
1144             // - `nextInitialized` to `true`.
1145             _packedOwnerships[tokenId] = _packOwnershipData(
1146                 to,
1147                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1148             );
1149 
1150             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1151             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1152                 uint256 nextTokenId = tokenId + 1;
1153                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1154                 if (_packedOwnerships[nextTokenId] == 0) {
1155                     // If the next slot is within bounds.
1156                     if (nextTokenId != _currentIndex) {
1157                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1158                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1159                     }
1160                 }
1161             }
1162         }
1163 
1164         emit Transfer(from, to, tokenId);
1165         _afterTokenTransfers(from, to, tokenId, 1);
1166     }
1167 
1168     /**
1169      * @dev Equivalent to `_burn(tokenId, false)`.
1170      */
1171     function _burn(uint256 tokenId) internal virtual {
1172         _burn(tokenId, false);
1173     }
1174 
1175     /**
1176      * @dev Destroys `tokenId`.
1177      * The approval is cleared when the token is burned.
1178      *
1179      * Requirements:
1180      *
1181      * - `tokenId` must exist.
1182      *
1183      * Emits a {Transfer} event.
1184      */
1185     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1186         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1187 
1188         address from = address(uint160(prevOwnershipPacked));
1189 
1190         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1191 
1192         if (approvalCheck) {
1193             // The nested ifs save around 20+ gas over a compound boolean condition.
1194             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1195                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1196         }
1197 
1198         _beforeTokenTransfers(from, address(0), tokenId, 1);
1199 
1200         // Clear approvals from the previous owner.
1201         assembly {
1202             if approvedAddress {
1203                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1204                 sstore(approvedAddressSlot, 0)
1205             }
1206         }
1207 
1208         // Underflow of the sender's balance is impossible because we check for
1209         // ownership above and the recipient's balance can't realistically overflow.
1210         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1211         unchecked {
1212             // Updates:
1213             // - `balance -= 1`.
1214             // - `numberBurned += 1`.
1215             //
1216             // We can directly decrement the balance, and increment the number burned.
1217             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1218             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1219 
1220             // Updates:
1221             // - `address` to the last owner.
1222             // - `startTimestamp` to the timestamp of burning.
1223             // - `burned` to `true`.
1224             // - `nextInitialized` to `true`.
1225             _packedOwnerships[tokenId] = _packOwnershipData(
1226                 from,
1227                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1228             );
1229 
1230             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1231             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1232                 uint256 nextTokenId = tokenId + 1;
1233                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1234                 if (_packedOwnerships[nextTokenId] == 0) {
1235                     // If the next slot is within bounds.
1236                     if (nextTokenId != _currentIndex) {
1237                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1238                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1239                     }
1240                 }
1241             }
1242         }
1243 
1244         emit Transfer(from, address(0), tokenId);
1245         _afterTokenTransfers(from, address(0), tokenId, 1);
1246 
1247         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1248         unchecked {
1249             _burnCounter++;
1250         }
1251     }
1252 
1253     /**
1254      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1255      *
1256      * @param from address representing the previous owner of the given token ID
1257      * @param to target address that will receive the tokens
1258      * @param tokenId uint256 ID of the token to be transferred
1259      * @param _data bytes optional data to send along with the call
1260      * @return bool whether the call correctly returned the expected magic value
1261      */
1262     function _checkContractOnERC721Received(
1263         address from,
1264         address to,
1265         uint256 tokenId,
1266         bytes memory _data
1267     ) private returns (bool) {
1268         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1269             bytes4 retval
1270         ) {
1271             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1272         } catch (bytes memory reason) {
1273             if (reason.length == 0) {
1274                 revert TransferToNonERC721ReceiverImplementer();
1275             } else {
1276                 assembly {
1277                     revert(add(32, reason), mload(reason))
1278                 }
1279             }
1280         }
1281     }
1282 
1283     /**
1284      * @dev Directly sets the extra data for the ownership data `index`.
1285      */
1286     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1287         uint256 packed = _packedOwnerships[index];
1288         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1289         uint256 extraDataCasted;
1290         // Cast `extraData` with assembly to avoid redundant masking.
1291         assembly {
1292             extraDataCasted := extraData
1293         }
1294         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1295         _packedOwnerships[index] = packed;
1296     }
1297 
1298     /**
1299      * @dev Returns the next extra data for the packed ownership data.
1300      * The returned result is shifted into position.
1301      */
1302     function _nextExtraData(
1303         address from,
1304         address to,
1305         uint256 prevOwnershipPacked
1306     ) private view returns (uint256) {
1307         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1308         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1309     }
1310 
1311     /**
1312      * @dev Called during each token transfer to set the 24bit `extraData` field.
1313      * Intended to be overridden by the cosumer contract.
1314      *
1315      * `previousExtraData` - the value of `extraData` before transfer.
1316      *
1317      * Calling conditions:
1318      *
1319      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1320      * transferred to `to`.
1321      * - When `from` is zero, `tokenId` will be minted for `to`.
1322      * - When `to` is zero, `tokenId` will be burned by `from`.
1323      * - `from` and `to` are never both zero.
1324      */
1325     function _extraData(
1326         address from,
1327         address to,
1328         uint24 previousExtraData
1329     ) internal view virtual returns (uint24) {}
1330 
1331     /**
1332      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1333      * This includes minting.
1334      * And also called before burning one token.
1335      *
1336      * startTokenId - the first token id to be transferred
1337      * quantity - the amount to be transferred
1338      *
1339      * Calling conditions:
1340      *
1341      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1342      * transferred to `to`.
1343      * - When `from` is zero, `tokenId` will be minted for `to`.
1344      * - When `to` is zero, `tokenId` will be burned by `from`.
1345      * - `from` and `to` are never both zero.
1346      */
1347     function _beforeTokenTransfers(
1348         address from,
1349         address to,
1350         uint256 startTokenId,
1351         uint256 quantity
1352     ) internal virtual {}
1353 
1354     /**
1355      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1356      * This includes minting.
1357      * And also called after one token has been burned.
1358      *
1359      * startTokenId - the first token id to be transferred
1360      * quantity - the amount to be transferred
1361      *
1362      * Calling conditions:
1363      *
1364      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1365      * transferred to `to`.
1366      * - When `from` is zero, `tokenId` has been minted for `to`.
1367      * - When `to` is zero, `tokenId` has been burned by `from`.
1368      * - `from` and `to` are never both zero.
1369      */
1370     function _afterTokenTransfers(
1371         address from,
1372         address to,
1373         uint256 startTokenId,
1374         uint256 quantity
1375     ) internal virtual {}
1376 
1377     /**
1378      * @dev Returns the message sender (defaults to `msg.sender`).
1379      *
1380      * If you are writing GSN compatible contracts, you need to override this function.
1381      */
1382     function _msgSenderERC721A() internal view virtual returns (address) {
1383         return msg.sender;
1384     }
1385 
1386     /**
1387      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1388      */
1389     function _toString(uint256 value) internal pure returns (string memory ptr) {
1390         assembly {
1391             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1392             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1393             // We will need 1 32-byte word to store the length,
1394             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1395             ptr := add(mload(0x40), 128)
1396             // Update the free memory pointer to allocate.
1397             mstore(0x40, ptr)
1398 
1399             // Cache the end of the memory to calculate the length later.
1400             let end := ptr
1401 
1402             // We write the string from the rightmost digit to the leftmost digit.
1403             // The following is essentially a do-while loop that also handles the zero case.
1404             // Costs a bit more than early returning for the zero case,
1405             // but cheaper in terms of deployment and overall runtime costs.
1406             for {
1407                 // Initialize and perform the first pass without check.
1408                 let temp := value
1409                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1410                 ptr := sub(ptr, 1)
1411                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1412                 mstore8(ptr, add(48, mod(temp, 10)))
1413                 temp := div(temp, 10)
1414             } temp {
1415                 // Keep dividing `temp` until zero.
1416                 temp := div(temp, 10)
1417             } {
1418                 // Body of the for loop.
1419                 ptr := sub(ptr, 1)
1420                 mstore8(ptr, add(48, mod(temp, 10)))
1421             }
1422 
1423             let length := sub(end, ptr)
1424             // Move the pointer 32 bytes leftwards to make room for the length.
1425             ptr := sub(ptr, 32)
1426             // Store the length.
1427             mstore(ptr, length)
1428         }
1429     }
1430 }
1431 
1432 // File: contracts/utopia.sol
1433 
1434 
1435 //  ██╗   ██╗████████╗ ██████╗ ██████╗ ██╗ █████╗ 
1436 //  ██║   ██║╚══██╔══╝██╔═══██╗██╔══██╗██║██╔══██╗
1437 //  ██║   ██║   ██║   ██║   ██║██████╔╝██║███████║
1438 //  ██║   ██║   ██║   ██║   ██║██╔═══╝ ██║██╔══██║
1439 //  ╚██████╔╝   ██║   ╚██████╔╝██║     ██║██║  ██║
1440 //   ╚═════╝    ╚═╝    ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝
1441 //                                                
1442 
1443 
1444 //SPDX-License-Identifier: MIT
1445 pragma solidity ^0.8.4;
1446 
1447 
1448 
1449 
1450 
1451 
1452 contract Utopia is Ownable, ERC721A {
1453     uint256 constant public MAX_SUPPLY = 777;
1454     
1455 
1456     uint256 public publicPrice = 0.005 ether;
1457 
1458     uint256 constant public PUBLIC_MINT_LIMIT_TXN = 2;
1459     uint256 constant public PUBLIC_MINT_LIMIT = 4;
1460 
1461     string private revealedURI = "ipfs://QmfHMAYe9a6zJDeb2zy38Zhj4UREzQah5y9nNJNBmPBVDi/";
1462 
1463     
1464 
1465     bool public paused = false;
1466     bool public revealed = false;
1467 
1468     bool public freeSale = false;
1469     bool public publicSale = false;
1470 
1471     
1472     address constant internal DEV_ADDRESS = 0x0A8A88B4543dE7EF494c99A501e9b6E62415ab57;
1473     
1474     
1475 
1476     mapping(address => bool) public userMintedFree;
1477     mapping(address => uint256) public numUserMints;
1478 
1479     constructor(string memory _name, string memory _symbol, string memory _baseUri) ERC721A("Utopia", "UTPIA") { }
1480 
1481     
1482     function _startTokenId() internal view virtual override returns (uint256) {
1483         return 1;
1484     }
1485 
1486     function refundOverpay(uint256 price) private {
1487         if (msg.value > price) {
1488             (bool succ, ) = payable(msg.sender).call{
1489                 value: (msg.value - price)
1490             }("");
1491             require(succ, "Transfer failed");
1492         }
1493         else if (msg.value < price) {
1494             revert("Not enough ETH sent");
1495         }
1496     }
1497 
1498     
1499     
1500     function freeMint(uint256 quantity) external payable mintCompliance(quantity) {
1501         require(freeSale, "Free sale inactive");
1502         require(msg.value == 0, "This phase is free");
1503         require(quantity == 1, "Only #1 free");
1504 
1505         uint256 newSupply = totalSupply() + quantity;
1506         
1507         require(newSupply <= 100, "Not enough free supply");
1508 
1509         require(!userMintedFree[msg.sender], "User max free limit");
1510         
1511         userMintedFree[msg.sender] = true;
1512 
1513         if(newSupply == 100) {
1514             freeSale = false;
1515             publicSale = true;
1516         }
1517 
1518         _safeMint(msg.sender, quantity);
1519     }
1520 
1521     function publicMint(uint256 quantity) external payable mintCompliance(quantity) {
1522         require(publicSale, "Public sale inactive");
1523         require(quantity <= PUBLIC_MINT_LIMIT_TXN, "Quantity too high");
1524 
1525         uint256 price = publicPrice;
1526         uint256 currMints = numUserMints[msg.sender];
1527                 
1528         require(currMints + quantity <= PUBLIC_MINT_LIMIT, "User max mint limit");
1529         
1530         refundOverpay(price * quantity);
1531 
1532         numUserMints[msg.sender] = (currMints + quantity);
1533 
1534         _safeMint(msg.sender, quantity);
1535     }
1536 
1537     
1538     function walletOfOwner(address _owner) public view returns (uint256[] memory)
1539     {
1540         uint256 ownerTokenCount = balanceOf(_owner);
1541         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1542         uint256 currentTokenId = 1;
1543         uint256 ownedTokenIndex = 0;
1544 
1545         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= MAX_SUPPLY) {
1546             address currentTokenOwner = ownerOf(currentTokenId);
1547 
1548             if (currentTokenOwner == _owner) {
1549                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1550 
1551                 ownedTokenIndex++;
1552             }
1553 
1554         currentTokenId++;
1555         }
1556 
1557         return ownedTokenIds;
1558     }
1559 
1560     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1561         
1562         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1563         
1564         if (revealed) {
1565             return string(abi.encodePacked(revealedURI, Strings.toString(_tokenId), ".json"));
1566         }
1567         else {
1568             return revealedURI;
1569         }
1570     }
1571 
1572     function setPublicPrice(uint256 _publicPrice) public onlyOwner {
1573         publicPrice = _publicPrice;
1574     }
1575 
1576     function setBaseURI(string memory _baseUri) public onlyOwner {
1577         revealedURI = _baseUri;
1578     }
1579 
1580 
1581     function setPaused(bool _state) public onlyOwner {
1582         paused = _state;
1583     }
1584 
1585     function setRevealed(bool _state) public onlyOwner {
1586         revealed = _state;
1587     }
1588 
1589     function setPublicEnabled(bool _state) public onlyOwner {
1590         publicSale = _state;
1591         freeSale = !_state;
1592     }
1593     function setFreeEnabled(bool _state) public onlyOwner {
1594         freeSale = _state;
1595         publicSale = !_state;
1596     }
1597 
1598 
1599     function withdraw() external payable onlyOwner {
1600         
1601         uint256 currBalance = address(this).balance;
1602 
1603         (bool succ, ) = payable(DEV_ADDRESS).call{
1604             value: (currBalance * 10000) / 10000
1605         }("0x0A8A88B4543dE7EF494c99A501e9b6E62415ab57");
1606         require(succ, "Dev transfer failed");
1607 
1608     }
1609 
1610     
1611     function mintToUser(uint256 quantity, address receiver) public onlyOwner mintCompliance(quantity) {
1612         _safeMint(receiver, quantity);
1613     }
1614 
1615    
1616 
1617     modifier mintCompliance(uint256 quantity) {
1618         require(!paused, "Contract is paused");
1619         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough mints left");
1620         require(tx.origin == msg.sender, "No contract minting");
1621         _;
1622     }
1623 }