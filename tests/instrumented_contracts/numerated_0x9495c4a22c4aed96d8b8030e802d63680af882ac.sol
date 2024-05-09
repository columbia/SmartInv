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
194 // ERC721A Contracts v4.1.0
195 // Creator: Chiru Labs
196 
197 pragma solidity ^0.8.4;
198 
199 /**
200  * @dev Interface of an ERC721A compliant contract.
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
249      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
250      */
251     error TransferToNonERC721ReceiverImplementer();
252 
253     /**
254      * Cannot transfer to the zero address.
255      */
256     error TransferToZeroAddress();
257 
258     /**
259      * The token does not exist.
260      */
261     error URIQueryForNonexistentToken();
262 
263     /**
264      * The `quantity` minted with ERC2309 exceeds the safety limit.
265      */
266     error MintERC2309QuantityExceedsLimit();
267 
268     /**
269      * The `extraData` cannot be set on an unintialized ownership slot.
270      */
271     error OwnershipNotInitializedForExtraData();
272 
273     struct TokenOwnership {
274         // The address of the owner.
275         address addr;
276         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
277         uint64 startTimestamp;
278         // Whether the token has been burned.
279         bool burned;
280         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
281         uint24 extraData;
282     }
283 
284     /**
285      * @dev Returns the total amount of tokens stored by the contract.
286      *
287      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
288      */
289     function totalSupply() external view returns (uint256);
290 
291     // ==============================
292     //            IERC165
293     // ==============================
294 
295     /**
296      * @dev Returns true if this contract implements the interface defined by
297      * `interfaceId`. See the corresponding
298      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
299      * to learn more about how these ids are created.
300      *
301      * This function call must use less than 30 000 gas.
302      */
303     function supportsInterface(bytes4 interfaceId) external view returns (bool);
304 
305     // ==============================
306     //            IERC721
307     // ==============================
308 
309     /**
310      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
311      */
312     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
313 
314     /**
315      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
316      */
317     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
318 
319     /**
320      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
321      */
322     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
323 
324     /**
325      * @dev Returns the number of tokens in ``owner``'s account.
326      */
327     function balanceOf(address owner) external view returns (uint256 balance);
328 
329     /**
330      * @dev Returns the owner of the `tokenId` token.
331      *
332      * Requirements:
333      *
334      * - `tokenId` must exist.
335      */
336     function ownerOf(uint256 tokenId) external view returns (address owner);
337 
338     /**
339      * @dev Safely transfers `tokenId` token from `from` to `to`.
340      *
341      * Requirements:
342      *
343      * - `from` cannot be the zero address.
344      * - `to` cannot be the zero address.
345      * - `tokenId` token must exist and be owned by `from`.
346      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
347      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
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
359      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
360      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
361      *
362      * Requirements:
363      *
364      * - `from` cannot be the zero address.
365      * - `to` cannot be the zero address.
366      * - `tokenId` token must exist and be owned by `from`.
367      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
368      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
369      *
370      * Emits a {Transfer} event.
371      */
372     function safeTransferFrom(
373         address from,
374         address to,
375         uint256 tokenId
376     ) external;
377 
378     /**
379      * @dev Transfers `tokenId` token from `from` to `to`.
380      *
381      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
382      *
383      * Requirements:
384      *
385      * - `from` cannot be the zero address.
386      * - `to` cannot be the zero address.
387      * - `tokenId` token must be owned by `from`.
388      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
389      *
390      * Emits a {Transfer} event.
391      */
392     function transferFrom(
393         address from,
394         address to,
395         uint256 tokenId
396     ) external;
397 
398     /**
399      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
400      * The approval is cleared when the token is transferred.
401      *
402      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
403      *
404      * Requirements:
405      *
406      * - The caller must own the token or be an approved operator.
407      * - `tokenId` must exist.
408      *
409      * Emits an {Approval} event.
410      */
411     function approve(address to, uint256 tokenId) external;
412 
413     /**
414      * @dev Approve or remove `operator` as an operator for the caller.
415      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
416      *
417      * Requirements:
418      *
419      * - The `operator` cannot be the caller.
420      *
421      * Emits an {ApprovalForAll} event.
422      */
423     function setApprovalForAll(address operator, bool _approved) external;
424 
425     /**
426      * @dev Returns the account approved for `tokenId` token.
427      *
428      * Requirements:
429      *
430      * - `tokenId` must exist.
431      */
432     function getApproved(uint256 tokenId) external view returns (address operator);
433 
434     /**
435      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
436      *
437      * See {setApprovalForAll}
438      */
439     function isApprovedForAll(address owner, address operator) external view returns (bool);
440 
441     // ==============================
442     //        IERC721Metadata
443     // ==============================
444 
445     /**
446      * @dev Returns the token collection name.
447      */
448     function name() external view returns (string memory);
449 
450     /**
451      * @dev Returns the token collection symbol.
452      */
453     function symbol() external view returns (string memory);
454 
455     /**
456      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
457      */
458     function tokenURI(uint256 tokenId) external view returns (string memory);
459 
460     // ==============================
461     //            IERC2309
462     // ==============================
463 
464     /**
465      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
466      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
467      */
468     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
469 }
470 
471 // File: erc721a/contracts/ERC721A.sol
472 
473 
474 // ERC721A Contracts v4.1.0
475 // Creator: Chiru Labs
476 
477 pragma solidity ^0.8.4;
478 
479 
480 /**
481  * @dev ERC721 token receiver interface.
482  */
483 interface ERC721A__IERC721Receiver {
484     function onERC721Received(
485         address operator,
486         address from,
487         uint256 tokenId,
488         bytes calldata data
489     ) external returns (bytes4);
490 }
491 
492 /**
493  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
494  * including the Metadata extension. Built to optimize for lower gas during batch mints.
495  *
496  * Assumes serials are sequentially minted starting at `_startTokenId()`
497  * (defaults to 0, e.g. 0, 1, 2, 3..).
498  *
499  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
500  *
501  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
502  */
503 contract ERC721A is IERC721A {
504     // Mask of an entry in packed address data.
505     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
506 
507     // The bit position of `numberMinted` in packed address data.
508     uint256 private constant BITPOS_NUMBER_MINTED = 64;
509 
510     // The bit position of `numberBurned` in packed address data.
511     uint256 private constant BITPOS_NUMBER_BURNED = 128;
512 
513     // The bit position of `aux` in packed address data.
514     uint256 private constant BITPOS_AUX = 192;
515 
516     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
517     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
518 
519     // The bit position of `startTimestamp` in packed ownership.
520     uint256 private constant BITPOS_START_TIMESTAMP = 160;
521 
522     // The bit mask of the `burned` bit in packed ownership.
523     uint256 private constant BITMASK_BURNED = 1 << 224;
524 
525     // The bit position of the `nextInitialized` bit in packed ownership.
526     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
527 
528     // The bit mask of the `nextInitialized` bit in packed ownership.
529     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
530 
531     // The bit position of `extraData` in packed ownership.
532     uint256 private constant BITPOS_EXTRA_DATA = 232;
533 
534     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
535     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
536 
537     // The mask of the lower 160 bits for addresses.
538     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
539 
540     // The maximum `quantity` that can be minted with `_mintERC2309`.
541     // This limit is to prevent overflows on the address data entries.
542     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
543     // is required to cause an overflow, which is unrealistic.
544     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
545 
546     // The tokenId of the next token to be minted.
547     uint256 private _currentIndex;
548 
549     // The number of tokens burned.
550     uint256 private _burnCounter;
551 
552     // Token name
553     string private _name;
554 
555     // Token symbol
556     string private _symbol;
557 
558     // Mapping from token ID to ownership details
559     // An empty struct value does not necessarily mean the token is unowned.
560     // See `_packedOwnershipOf` implementation for details.
561     //
562     // Bits Layout:
563     // - [0..159]   `addr`
564     // - [160..223] `startTimestamp`
565     // - [224]      `burned`
566     // - [225]      `nextInitialized`
567     // - [232..255] `extraData`
568     mapping(uint256 => uint256) private _packedOwnerships;
569 
570     // Mapping owner address to address data.
571     //
572     // Bits Layout:
573     // - [0..63]    `balance`
574     // - [64..127]  `numberMinted`
575     // - [128..191] `numberBurned`
576     // - [192..255] `aux`
577     mapping(address => uint256) private _packedAddressData;
578 
579     // Mapping from token ID to approved address.
580     mapping(uint256 => address) private _tokenApprovals;
581 
582     // Mapping from owner to operator approvals
583     mapping(address => mapping(address => bool)) private _operatorApprovals;
584 
585     constructor(string memory name_, string memory symbol_) {
586         _name = name_;
587         _symbol = symbol_;
588         _currentIndex = _startTokenId();
589     }
590 
591     /**
592      * @dev Returns the starting token ID.
593      * To change the starting token ID, please override this function.
594      */
595     function _startTokenId() internal view virtual returns (uint256) {
596         return 0;
597     }
598 
599     /**
600      * @dev Returns the next token ID to be minted.
601      */
602     function _nextTokenId() internal view returns (uint256) {
603         return _currentIndex;
604     }
605 
606     /**
607      * @dev Returns the total number of tokens in existence.
608      * Burned tokens will reduce the count.
609      * To get the total number of tokens minted, please see `_totalMinted`.
610      */
611     function totalSupply() public view override returns (uint256) {
612         // Counter underflow is impossible as _burnCounter cannot be incremented
613         // more than `_currentIndex - _startTokenId()` times.
614         unchecked {
615             return _currentIndex - _burnCounter - _startTokenId();
616         }
617     }
618 
619     /**
620      * @dev Returns the total amount of tokens minted in the contract.
621      */
622     function _totalMinted() internal view returns (uint256) {
623         // Counter underflow is impossible as _currentIndex does not decrement,
624         // and it is initialized to `_startTokenId()`
625         unchecked {
626             return _currentIndex - _startTokenId();
627         }
628     }
629 
630     /**
631      * @dev Returns the total number of tokens burned.
632      */
633     function _totalBurned() internal view returns (uint256) {
634         return _burnCounter;
635     }
636 
637     /**
638      * @dev See {IERC165-supportsInterface}.
639      */
640     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
641         // The interface IDs are constants representing the first 4 bytes of the XOR of
642         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
643         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
644         return
645             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
646             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
647             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
648     }
649 
650     /**
651      * @dev See {IERC721-balanceOf}.
652      */
653     function balanceOf(address owner) public view override returns (uint256) {
654         if (owner == address(0)) revert BalanceQueryForZeroAddress();
655         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
656     }
657 
658     /**
659      * Returns the number of tokens minted by `owner`.
660      */
661     function _numberMinted(address owner) internal view returns (uint256) {
662         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
663     }
664 
665     /**
666      * Returns the number of tokens burned by or on behalf of `owner`.
667      */
668     function _numberBurned(address owner) internal view returns (uint256) {
669         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
670     }
671 
672     /**
673      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
674      */
675     function _getAux(address owner) internal view returns (uint64) {
676         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
677     }
678 
679     /**
680      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
681      * If there are multiple variables, please pack them into a uint64.
682      */
683     function _setAux(address owner, uint64 aux) internal {
684         uint256 packed = _packedAddressData[owner];
685         uint256 auxCasted;
686         // Cast `aux` with assembly to avoid redundant masking.
687         assembly {
688             auxCasted := aux
689         }
690         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
691         _packedAddressData[owner] = packed;
692     }
693 
694     /**
695      * Returns the packed ownership data of `tokenId`.
696      */
697     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
698         uint256 curr = tokenId;
699 
700         unchecked {
701             if (_startTokenId() <= curr)
702                 if (curr < _currentIndex) {
703                     uint256 packed = _packedOwnerships[curr];
704                     // If not burned.
705                     if (packed & BITMASK_BURNED == 0) {
706                         // Invariant:
707                         // There will always be an ownership that has an address and is not burned
708                         // before an ownership that does not have an address and is not burned.
709                         // Hence, curr will not underflow.
710                         //
711                         // We can directly compare the packed value.
712                         // If the address is zero, packed is zero.
713                         while (packed == 0) {
714                             packed = _packedOwnerships[--curr];
715                         }
716                         return packed;
717                     }
718                 }
719         }
720         revert OwnerQueryForNonexistentToken();
721     }
722 
723     /**
724      * Returns the unpacked `TokenOwnership` struct from `packed`.
725      */
726     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
727         ownership.addr = address(uint160(packed));
728         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
729         ownership.burned = packed & BITMASK_BURNED != 0;
730         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
731     }
732 
733     /**
734      * Returns the unpacked `TokenOwnership` struct at `index`.
735      */
736     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
737         return _unpackedOwnership(_packedOwnerships[index]);
738     }
739 
740     /**
741      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
742      */
743     function _initializeOwnershipAt(uint256 index) internal {
744         if (_packedOwnerships[index] == 0) {
745             _packedOwnerships[index] = _packedOwnershipOf(index);
746         }
747     }
748 
749     /**
750      * Gas spent here starts off proportional to the maximum mint batch size.
751      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
752      */
753     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
754         return _unpackedOwnership(_packedOwnershipOf(tokenId));
755     }
756 
757     /**
758      * @dev Packs ownership data into a single uint256.
759      */
760     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
761         assembly {
762             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
763             owner := and(owner, BITMASK_ADDRESS)
764             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
765             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
766         }
767     }
768 
769     /**
770      * @dev See {IERC721-ownerOf}.
771      */
772     function ownerOf(uint256 tokenId) public view override returns (address) {
773         return address(uint160(_packedOwnershipOf(tokenId)));
774     }
775 
776     /**
777      * @dev See {IERC721Metadata-name}.
778      */
779     function name() public view virtual override returns (string memory) {
780         return _name;
781     }
782 
783     /**
784      * @dev See {IERC721Metadata-symbol}.
785      */
786     function symbol() public view virtual override returns (string memory) {
787         return _symbol;
788     }
789 
790     /**
791      * @dev See {IERC721Metadata-tokenURI}.
792      */
793     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
794         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
795 
796         string memory baseURI = _baseURI();
797         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
798     }
799 
800     /**
801      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
802      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
803      * by default, it can be overridden in child contracts.
804      */
805     function _baseURI() internal view virtual returns (string memory) {
806         return '';
807     }
808 
809     /**
810      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
811      */
812     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
813         // For branchless setting of the `nextInitialized` flag.
814         assembly {
815             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
816             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
817         }
818     }
819 
820     /**
821      * @dev See {IERC721-approve}.
822      */
823     function approve(address to, uint256 tokenId) public override {
824         address owner = ownerOf(tokenId);
825 
826         if (_msgSenderERC721A() != owner)
827             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
828                 revert ApprovalCallerNotOwnerNorApproved();
829             }
830 
831         _tokenApprovals[tokenId] = to;
832         emit Approval(owner, to, tokenId);
833     }
834 
835     /**
836      * @dev See {IERC721-getApproved}.
837      */
838     function getApproved(uint256 tokenId) public view override returns (address) {
839         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
840 
841         return _tokenApprovals[tokenId];
842     }
843 
844     /**
845      * @dev See {IERC721-setApprovalForAll}.
846      */
847     function setApprovalForAll(address operator, bool approved) public virtual override {
848         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
849 
850         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
851         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
852     }
853 
854     /**
855      * @dev See {IERC721-isApprovedForAll}.
856      */
857     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
858         return _operatorApprovals[owner][operator];
859     }
860 
861     /**
862      * @dev See {IERC721-safeTransferFrom}.
863      */
864     function safeTransferFrom(
865         address from,
866         address to,
867         uint256 tokenId
868     ) public virtual override {
869         safeTransferFrom(from, to, tokenId, '');
870     }
871 
872     /**
873      * @dev See {IERC721-safeTransferFrom}.
874      */
875     function safeTransferFrom(
876         address from,
877         address to,
878         uint256 tokenId,
879         bytes memory _data
880     ) public virtual override {
881         transferFrom(from, to, tokenId);
882         if (to.code.length != 0)
883             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
884                 revert TransferToNonERC721ReceiverImplementer();
885             }
886     }
887 
888     /**
889      * @dev Returns whether `tokenId` exists.
890      *
891      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
892      *
893      * Tokens start existing when they are minted (`_mint`),
894      */
895     function _exists(uint256 tokenId) internal view returns (bool) {
896         return
897             _startTokenId() <= tokenId &&
898             tokenId < _currentIndex && // If within bounds,
899             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
900     }
901 
902     /**
903      * @dev Equivalent to `_safeMint(to, quantity, '')`.
904      */
905     function _safeMint(address to, uint256 quantity) internal {
906         _safeMint(to, quantity, '');
907     }
908 
909     /**
910      * @dev Safely mints `quantity` tokens and transfers them to `to`.
911      *
912      * Requirements:
913      *
914      * - If `to` refers to a smart contract, it must implement
915      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
916      * - `quantity` must be greater than 0.
917      *
918      * See {_mint}.
919      *
920      * Emits a {Transfer} event for each mint.
921      */
922     function _safeMint(
923         address to,
924         uint256 quantity,
925         bytes memory _data
926     ) internal {
927         _mint(to, quantity);
928 
929         unchecked {
930             if (to.code.length != 0) {
931                 uint256 end = _currentIndex;
932                 uint256 index = end - quantity;
933                 do {
934                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
935                         revert TransferToNonERC721ReceiverImplementer();
936                     }
937                 } while (index < end);
938                 // Reentrancy protection.
939                 if (_currentIndex != end) revert();
940             }
941         }
942     }
943 
944     /**
945      * @dev Mints `quantity` tokens and transfers them to `to`.
946      *
947      * Requirements:
948      *
949      * - `to` cannot be the zero address.
950      * - `quantity` must be greater than 0.
951      *
952      * Emits a {Transfer} event for each mint.
953      */
954     function _mint(address to, uint256 quantity) internal {
955         uint256 startTokenId = _currentIndex;
956         if (to == address(0)) revert MintToZeroAddress();
957         if (quantity == 0) revert MintZeroQuantity();
958 
959         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
960 
961         // Overflows are incredibly unrealistic.
962         // `balance` and `numberMinted` have a maximum limit of 2**64.
963         // `tokenId` has a maximum limit of 2**256.
964         unchecked {
965             // Updates:
966             // - `balance += quantity`.
967             // - `numberMinted += quantity`.
968             //
969             // We can directly add to the `balance` and `numberMinted`.
970             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
971 
972             // Updates:
973             // - `address` to the owner.
974             // - `startTimestamp` to the timestamp of minting.
975             // - `burned` to `false`.
976             // - `nextInitialized` to `quantity == 1`.
977             _packedOwnerships[startTokenId] = _packOwnershipData(
978                 to,
979                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
980             );
981 
982             uint256 tokenId = startTokenId;
983             uint256 end = startTokenId + quantity;
984             do {
985                 emit Transfer(address(0), to, tokenId++);
986             } while (tokenId < end);
987 
988             _currentIndex = end;
989         }
990         _afterTokenTransfers(address(0), to, startTokenId, quantity);
991     }
992 
993     /**
994      * @dev Mints `quantity` tokens and transfers them to `to`.
995      *
996      * This function is intended for efficient minting only during contract creation.
997      *
998      * It emits only one {ConsecutiveTransfer} as defined in
999      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1000      * instead of a sequence of {Transfer} event(s).
1001      *
1002      * Calling this function outside of contract creation WILL make your contract
1003      * non-compliant with the ERC721 standard.
1004      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1005      * {ConsecutiveTransfer} event is only permissible during contract creation.
1006      *
1007      * Requirements:
1008      *
1009      * - `to` cannot be the zero address.
1010      * - `quantity` must be greater than 0.
1011      *
1012      * Emits a {ConsecutiveTransfer} event.
1013      */
1014     function _mintERC2309(address to, uint256 quantity) internal {
1015         uint256 startTokenId = _currentIndex;
1016         if (to == address(0)) revert MintToZeroAddress();
1017         if (quantity == 0) revert MintZeroQuantity();
1018         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1019 
1020         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1021 
1022         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1023         unchecked {
1024             // Updates:
1025             // - `balance += quantity`.
1026             // - `numberMinted += quantity`.
1027             //
1028             // We can directly add to the `balance` and `numberMinted`.
1029             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1030 
1031             // Updates:
1032             // - `address` to the owner.
1033             // - `startTimestamp` to the timestamp of minting.
1034             // - `burned` to `false`.
1035             // - `nextInitialized` to `quantity == 1`.
1036             _packedOwnerships[startTokenId] = _packOwnershipData(
1037                 to,
1038                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1039             );
1040 
1041             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1042 
1043             _currentIndex = startTokenId + quantity;
1044         }
1045         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1046     }
1047 
1048     /**
1049      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1050      */
1051     function _getApprovedAddress(uint256 tokenId)
1052         private
1053         view
1054         returns (uint256 approvedAddressSlot, address approvedAddress)
1055     {
1056         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1057         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1058         assembly {
1059             // Compute the slot.
1060             mstore(0x00, tokenId)
1061             mstore(0x20, tokenApprovalsPtr.slot)
1062             approvedAddressSlot := keccak256(0x00, 0x40)
1063             // Load the slot's value from storage.
1064             approvedAddress := sload(approvedAddressSlot)
1065         }
1066     }
1067 
1068     /**
1069      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1070      */
1071     function _isOwnerOrApproved(
1072         address approvedAddress,
1073         address from,
1074         address msgSender
1075     ) private pure returns (bool result) {
1076         assembly {
1077             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1078             from := and(from, BITMASK_ADDRESS)
1079             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1080             msgSender := and(msgSender, BITMASK_ADDRESS)
1081             // `msgSender == from || msgSender == approvedAddress`.
1082             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1083         }
1084     }
1085 
1086     /**
1087      * @dev Transfers `tokenId` from `from` to `to`.
1088      *
1089      * Requirements:
1090      *
1091      * - `to` cannot be the zero address.
1092      * - `tokenId` token must be owned by `from`.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function transferFrom(
1097         address from,
1098         address to,
1099         uint256 tokenId
1100     ) public virtual override {
1101         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1102 
1103         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1104 
1105         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1106 
1107         // The nested ifs save around 20+ gas over a compound boolean condition.
1108         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1109             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1110 
1111         if (to == address(0)) revert TransferToZeroAddress();
1112 
1113         _beforeTokenTransfers(from, to, tokenId, 1);
1114 
1115         // Clear approvals from the previous owner.
1116         assembly {
1117             if approvedAddress {
1118                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1119                 sstore(approvedAddressSlot, 0)
1120             }
1121         }
1122 
1123         // Underflow of the sender's balance is impossible because we check for
1124         // ownership above and the recipient's balance can't realistically overflow.
1125         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1126         unchecked {
1127             // We can directly increment and decrement the balances.
1128             --_packedAddressData[from]; // Updates: `balance -= 1`.
1129             ++_packedAddressData[to]; // Updates: `balance += 1`.
1130 
1131             // Updates:
1132             // - `address` to the next owner.
1133             // - `startTimestamp` to the timestamp of transfering.
1134             // - `burned` to `false`.
1135             // - `nextInitialized` to `true`.
1136             _packedOwnerships[tokenId] = _packOwnershipData(
1137                 to,
1138                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1139             );
1140 
1141             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1142             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1143                 uint256 nextTokenId = tokenId + 1;
1144                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1145                 if (_packedOwnerships[nextTokenId] == 0) {
1146                     // If the next slot is within bounds.
1147                     if (nextTokenId != _currentIndex) {
1148                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1149                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1150                     }
1151                 }
1152             }
1153         }
1154 
1155         emit Transfer(from, to, tokenId);
1156         _afterTokenTransfers(from, to, tokenId, 1);
1157     }
1158 
1159     /**
1160      * @dev Equivalent to `_burn(tokenId, false)`.
1161      */
1162     function _burn(uint256 tokenId) internal virtual {
1163         _burn(tokenId, false);
1164     }
1165 
1166     /**
1167      * @dev Destroys `tokenId`.
1168      * The approval is cleared when the token is burned.
1169      *
1170      * Requirements:
1171      *
1172      * - `tokenId` must exist.
1173      *
1174      * Emits a {Transfer} event.
1175      */
1176     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1177         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1178 
1179         address from = address(uint160(prevOwnershipPacked));
1180 
1181         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1182 
1183         if (approvalCheck) {
1184             // The nested ifs save around 20+ gas over a compound boolean condition.
1185             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1186                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1187         }
1188 
1189         _beforeTokenTransfers(from, address(0), tokenId, 1);
1190 
1191         // Clear approvals from the previous owner.
1192         assembly {
1193             if approvedAddress {
1194                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1195                 sstore(approvedAddressSlot, 0)
1196             }
1197         }
1198 
1199         // Underflow of the sender's balance is impossible because we check for
1200         // ownership above and the recipient's balance can't realistically overflow.
1201         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1202         unchecked {
1203             // Updates:
1204             // - `balance -= 1`.
1205             // - `numberBurned += 1`.
1206             //
1207             // We can directly decrement the balance, and increment the number burned.
1208             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1209             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1210 
1211             // Updates:
1212             // - `address` to the last owner.
1213             // - `startTimestamp` to the timestamp of burning.
1214             // - `burned` to `true`.
1215             // - `nextInitialized` to `true`.
1216             _packedOwnerships[tokenId] = _packOwnershipData(
1217                 from,
1218                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1219             );
1220 
1221             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1222             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1223                 uint256 nextTokenId = tokenId + 1;
1224                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1225                 if (_packedOwnerships[nextTokenId] == 0) {
1226                     // If the next slot is within bounds.
1227                     if (nextTokenId != _currentIndex) {
1228                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1229                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1230                     }
1231                 }
1232             }
1233         }
1234 
1235         emit Transfer(from, address(0), tokenId);
1236         _afterTokenTransfers(from, address(0), tokenId, 1);
1237 
1238         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1239         unchecked {
1240             _burnCounter++;
1241         }
1242     }
1243 
1244     /**
1245      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1246      *
1247      * @param from address representing the previous owner of the given token ID
1248      * @param to target address that will receive the tokens
1249      * @param tokenId uint256 ID of the token to be transferred
1250      * @param _data bytes optional data to send along with the call
1251      * @return bool whether the call correctly returned the expected magic value
1252      */
1253     function _checkContractOnERC721Received(
1254         address from,
1255         address to,
1256         uint256 tokenId,
1257         bytes memory _data
1258     ) private returns (bool) {
1259         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1260             bytes4 retval
1261         ) {
1262             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1263         } catch (bytes memory reason) {
1264             if (reason.length == 0) {
1265                 revert TransferToNonERC721ReceiverImplementer();
1266             } else {
1267                 assembly {
1268                     revert(add(32, reason), mload(reason))
1269                 }
1270             }
1271         }
1272     }
1273 
1274     /**
1275      * @dev Directly sets the extra data for the ownership data `index`.
1276      */
1277     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1278         uint256 packed = _packedOwnerships[index];
1279         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1280         uint256 extraDataCasted;
1281         // Cast `extraData` with assembly to avoid redundant masking.
1282         assembly {
1283             extraDataCasted := extraData
1284         }
1285         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1286         _packedOwnerships[index] = packed;
1287     }
1288 
1289     /**
1290      * @dev Returns the next extra data for the packed ownership data.
1291      * The returned result is shifted into position.
1292      */
1293     function _nextExtraData(
1294         address from,
1295         address to,
1296         uint256 prevOwnershipPacked
1297     ) private view returns (uint256) {
1298         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1299         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1300     }
1301 
1302     /**
1303      * @dev Called during each token transfer to set the 24bit `extraData` field.
1304      * Intended to be overridden by the cosumer contract.
1305      *
1306      * `previousExtraData` - the value of `extraData` before transfer.
1307      *
1308      * Calling conditions:
1309      *
1310      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1311      * transferred to `to`.
1312      * - When `from` is zero, `tokenId` will be minted for `to`.
1313      * - When `to` is zero, `tokenId` will be burned by `from`.
1314      * - `from` and `to` are never both zero.
1315      */
1316     function _extraData(
1317         address from,
1318         address to,
1319         uint24 previousExtraData
1320     ) internal view virtual returns (uint24) {}
1321 
1322     /**
1323      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1324      * This includes minting.
1325      * And also called before burning one token.
1326      *
1327      * startTokenId - the first token id to be transferred
1328      * quantity - the amount to be transferred
1329      *
1330      * Calling conditions:
1331      *
1332      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1333      * transferred to `to`.
1334      * - When `from` is zero, `tokenId` will be minted for `to`.
1335      * - When `to` is zero, `tokenId` will be burned by `from`.
1336      * - `from` and `to` are never both zero.
1337      */
1338     function _beforeTokenTransfers(
1339         address from,
1340         address to,
1341         uint256 startTokenId,
1342         uint256 quantity
1343     ) internal virtual {}
1344 
1345     /**
1346      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1347      * This includes minting.
1348      * And also called after one token has been burned.
1349      *
1350      * startTokenId - the first token id to be transferred
1351      * quantity - the amount to be transferred
1352      *
1353      * Calling conditions:
1354      *
1355      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1356      * transferred to `to`.
1357      * - When `from` is zero, `tokenId` has been minted for `to`.
1358      * - When `to` is zero, `tokenId` has been burned by `from`.
1359      * - `from` and `to` are never both zero.
1360      */
1361     function _afterTokenTransfers(
1362         address from,
1363         address to,
1364         uint256 startTokenId,
1365         uint256 quantity
1366     ) internal virtual {}
1367 
1368     /**
1369      * @dev Returns the message sender (defaults to `msg.sender`).
1370      *
1371      * If you are writing GSN compatible contracts, you need to override this function.
1372      */
1373     function _msgSenderERC721A() internal view virtual returns (address) {
1374         return msg.sender;
1375     }
1376 
1377     /**
1378      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1379      */
1380     function _toString(uint256 value) internal pure returns (string memory ptr) {
1381         assembly {
1382             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1383             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1384             // We will need 1 32-byte word to store the length,
1385             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1386             ptr := add(mload(0x40), 128)
1387             // Update the free memory pointer to allocate.
1388             mstore(0x40, ptr)
1389 
1390             // Cache the end of the memory to calculate the length later.
1391             let end := ptr
1392 
1393             // We write the string from the rightmost digit to the leftmost digit.
1394             // The following is essentially a do-while loop that also handles the zero case.
1395             // Costs a bit more than early returning for the zero case,
1396             // but cheaper in terms of deployment and overall runtime costs.
1397             for {
1398                 // Initialize and perform the first pass without check.
1399                 let temp := value
1400                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1401                 ptr := sub(ptr, 1)
1402                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1403                 mstore8(ptr, add(48, mod(temp, 10)))
1404                 temp := div(temp, 10)
1405             } temp {
1406                 // Keep dividing `temp` until zero.
1407                 temp := div(temp, 10)
1408             } {
1409                 // Body of the for loop.
1410                 ptr := sub(ptr, 1)
1411                 mstore8(ptr, add(48, mod(temp, 10)))
1412             }
1413 
1414             let length := sub(end, ptr)
1415             // Move the pointer 32 bytes leftwards to make room for the length.
1416             ptr := sub(ptr, 32)
1417             // Store the length.
1418             mstore(ptr, length)
1419         }
1420     }
1421 }
1422 
1423 // File: Brain.sol
1424 
1425 //SPDX-License-Identifier: MIT
1426 
1427 pragma solidity ^0.8.4;
1428 
1429 
1430 
1431 
1432 contract Brain is ERC721A, Ownable {
1433   uint256 constant EXTRA_MINT_PRICE = 0.0069 ether;
1434   uint256 constant MAX_SUPPLY_PLUS_ONE = 10001;
1435   uint256 constant MAX_PER_TRANSACTION_PLUS_ONE = 4;
1436 
1437   using Strings for uint256;
1438 
1439   string tokenBaseUri = "ipfs://QmeizPvgosgNb49fYR1z56mAbvuMeAZhoyrmc6XZDR4VZ6/";
1440   string public baseExtension = ".json";
1441 
1442   bool public paused = true;
1443 
1444   mapping(address => uint256) private _freeMintedCount;
1445 
1446   constructor() ERC721A("bigbrain.wtf", "BIGBRAIN") {}
1447 
1448   function mint(uint256 _quantity) external payable {
1449     require(!paused, "Minting paused");
1450 
1451     uint256 _totalSupply = totalSupply();
1452 
1453     require(_totalSupply + _quantity < MAX_SUPPLY_PLUS_ONE, "Exceeds supply");
1454     require(_quantity < MAX_PER_TRANSACTION_PLUS_ONE, "Exceeds max per tx");
1455 
1456     uint256 payForCount = _quantity;
1457     uint256 freeMintCount = _freeMintedCount[msg.sender];
1458 
1459     if (freeMintCount < 1) {
1460       if (_quantity > 1) {
1461         payForCount = _quantity - 1;
1462       } else {
1463         payForCount = 0;
1464       }
1465 
1466       _freeMintedCount[msg.sender] = 1;
1467     }
1468 
1469     require(msg.value >= payForCount * EXTRA_MINT_PRICE, "ETH sent not correct");
1470 
1471     _mint(msg.sender, _quantity);
1472   }
1473 
1474   function tokenURI(uint256 tokenId)
1475         public
1476         view
1477         virtual
1478         override
1479         returns (string memory)
1480     {
1481         require(
1482             _exists(tokenId),
1483             "ERC721Metadata: URI query for nonexistent token"
1484         );
1485         string memory currentBaseURI = _baseURI();
1486         return
1487             bytes(currentBaseURI).length > 0
1488                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1489                 : "";
1490     }
1491 
1492   function freeMintedCount(address owner) external view returns (uint256) {
1493     return _freeMintedCount[owner];
1494   }
1495 
1496   function _startTokenId() internal pure override returns (uint256) {
1497     return 1;
1498   }
1499 
1500   function _baseURI() internal view override returns (string memory) {
1501     return tokenBaseUri;
1502   }
1503 
1504   function setBaseURI(string calldata _newBaseUri) external onlyOwner {
1505     tokenBaseUri = _newBaseUri;
1506   }
1507 
1508   function flipSale() external onlyOwner {
1509     paused = !paused;
1510   }
1511 
1512   function collectReserves() external onlyOwner {
1513     require(totalSupply() == 0, "Reserves already taken");
1514 
1515     _mint(msg.sender, 100);
1516   }
1517 
1518   function withdraw() external onlyOwner {
1519     require(
1520       payable(owner()).send(address(this).balance),
1521       "Withdraw unsuccessful"
1522     );
1523   }
1524 }