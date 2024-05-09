1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/access/Ownable.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _transferOwnership(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _transferOwnership(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _transferOwnership(newOwner);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Internal function without access restriction.
168      */
169     function _transferOwnership(address newOwner) internal virtual {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 
176 // File: erc721a/contracts/IERC721A.sol
177 
178 
179 // ERC721A Contracts v4.1.0
180 // Creator: Chiru Labs
181 
182 pragma solidity ^0.8.4;
183 
184 /**
185  * @dev Interface of an ERC721A compliant contract.
186  */
187 interface IERC721A {
188     /**
189      * The caller must own the token or be an approved operator.
190      */
191     error ApprovalCallerNotOwnerNorApproved();
192 
193     /**
194      * The token does not exist.
195      */
196     error ApprovalQueryForNonexistentToken();
197 
198     /**
199      * The caller cannot approve to their own address.
200      */
201     error ApproveToCaller();
202 
203     /**
204      * Cannot query the balance for the zero address.
205      */
206     error BalanceQueryForZeroAddress();
207 
208     /**
209      * Cannot mint to the zero address.
210      */
211     error MintToZeroAddress();
212 
213     /**
214      * The quantity of tokens minted must be more than zero.
215      */
216     error MintZeroQuantity();
217 
218     /**
219      * The token does not exist.
220      */
221     error OwnerQueryForNonexistentToken();
222 
223     /**
224      * The caller must own the token or be an approved operator.
225      */
226     error TransferCallerNotOwnerNorApproved();
227 
228     /**
229      * The token must be owned by `from`.
230      */
231     error TransferFromIncorrectOwner();
232 
233     /**
234      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
235      */
236     error TransferToNonERC721ReceiverImplementer();
237 
238     /**
239      * Cannot transfer to the zero address.
240      */
241     error TransferToZeroAddress();
242 
243     /**
244      * The token does not exist.
245      */
246     error URIQueryForNonexistentToken();
247 
248     /**
249      * The `quantity` minted with ERC2309 exceeds the safety limit.
250      */
251     error MintERC2309QuantityExceedsLimit();
252 
253     /**
254      * The `extraData` cannot be set on an unintialized ownership slot.
255      */
256     error OwnershipNotInitializedForExtraData();
257 
258     struct TokenOwnership {
259         // The address of the owner.
260         address addr;
261         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
262         uint64 startTimestamp;
263         // Whether the token has been burned.
264         bool burned;
265         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
266         uint24 extraData;
267     }
268 
269     /**
270      * @dev Returns the total amount of tokens stored by the contract.
271      *
272      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
273      */
274     function totalSupply() external view returns (uint256);
275 
276     // ==============================
277     //            IERC165
278     // ==============================
279 
280     /**
281      * @dev Returns true if this contract implements the interface defined by
282      * `interfaceId`. See the corresponding
283      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
284      * to learn more about how these ids are created.
285      *
286      * This function call must use less than 30 000 gas.
287      */
288     function supportsInterface(bytes4 interfaceId) external view returns (bool);
289 
290     // ==============================
291     //            IERC721
292     // ==============================
293 
294     /**
295      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
296      */
297     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
298 
299     /**
300      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
301      */
302     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
303 
304     /**
305      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
306      */
307     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
308 
309     /**
310      * @dev Returns the number of tokens in ``owner``'s account.
311      */
312     function balanceOf(address owner) external view returns (uint256 balance);
313 
314     /**
315      * @dev Returns the owner of the `tokenId` token.
316      *
317      * Requirements:
318      *
319      * - `tokenId` must exist.
320      */
321     function ownerOf(uint256 tokenId) external view returns (address owner);
322 
323     /**
324      * @dev Safely transfers `tokenId` token from `from` to `to`.
325      *
326      * Requirements:
327      *
328      * - `from` cannot be the zero address.
329      * - `to` cannot be the zero address.
330      * - `tokenId` token must exist and be owned by `from`.
331      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
332      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
333      *
334      * Emits a {Transfer} event.
335      */
336     function safeTransferFrom(
337         address from,
338         address to,
339         uint256 tokenId,
340         bytes calldata data
341     ) external;
342 
343     /**
344      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
345      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
346      *
347      * Requirements:
348      *
349      * - `from` cannot be the zero address.
350      * - `to` cannot be the zero address.
351      * - `tokenId` token must exist and be owned by `from`.
352      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
353      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
354      *
355      * Emits a {Transfer} event.
356      */
357     function safeTransferFrom(
358         address from,
359         address to,
360         uint256 tokenId
361     ) external;
362 
363     /**
364      * @dev Transfers `tokenId` token from `from` to `to`.
365      *
366      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
367      *
368      * Requirements:
369      *
370      * - `from` cannot be the zero address.
371      * - `to` cannot be the zero address.
372      * - `tokenId` token must be owned by `from`.
373      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
374      *
375      * Emits a {Transfer} event.
376      */
377     function transferFrom(
378         address from,
379         address to,
380         uint256 tokenId
381     ) external;
382 
383     /**
384      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
385      * The approval is cleared when the token is transferred.
386      *
387      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
388      *
389      * Requirements:
390      *
391      * - The caller must own the token or be an approved operator.
392      * - `tokenId` must exist.
393      *
394      * Emits an {Approval} event.
395      */
396     function approve(address to, uint256 tokenId) external;
397 
398     /**
399      * @dev Approve or remove `operator` as an operator for the caller.
400      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
401      *
402      * Requirements:
403      *
404      * - The `operator` cannot be the caller.
405      *
406      * Emits an {ApprovalForAll} event.
407      */
408     function setApprovalForAll(address operator, bool _approved) external;
409 
410     /**
411      * @dev Returns the account approved for `tokenId` token.
412      *
413      * Requirements:
414      *
415      * - `tokenId` must exist.
416      */
417     function getApproved(uint256 tokenId) external view returns (address operator);
418 
419     /**
420      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
421      *
422      * See {setApprovalForAll}
423      */
424     function isApprovedForAll(address owner, address operator) external view returns (bool);
425 
426     // ==============================
427     //        IERC721Metadata
428     // ==============================
429 
430     /**
431      * @dev Returns the token collection name.
432      */
433     function name() external view returns (string memory);
434 
435     /**
436      * @dev Returns the token collection symbol.
437      */
438     function symbol() external view returns (string memory);
439 
440     /**
441      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
442      */
443     function tokenURI(uint256 tokenId) external view returns (string memory);
444 
445     // ==============================
446     //            IERC2309
447     // ==============================
448 
449     /**
450      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
451      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
452      */
453     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
454 }
455 
456 // File: erc721a/contracts/ERC721A.sol
457 
458 
459 // ERC721A Contracts v4.1.0
460 // Creator: Chiru Labs
461 
462 pragma solidity ^0.8.4;
463 
464 
465 /**
466  * @dev ERC721 token receiver interface.
467  */
468 interface ERC721A__IERC721Receiver {
469     function onERC721Received(
470         address operator,
471         address from,
472         uint256 tokenId,
473         bytes calldata data
474     ) external returns (bytes4);
475 }
476 
477 /**
478  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
479  * including the Metadata extension. Built to optimize for lower gas during batch mints.
480  *
481  * Assumes serials are sequentially minted starting at `_startTokenId()`
482  * (defaults to 0, e.g. 0, 1, 2, 3..).
483  *
484  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
485  *
486  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
487  */
488 contract ERC721A is IERC721A {
489     // Mask of an entry in packed address data.
490     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
491 
492     // The bit position of `numberMinted` in packed address data.
493     uint256 private constant BITPOS_NUMBER_MINTED = 64;
494 
495     // The bit position of `numberBurned` in packed address data.
496     uint256 private constant BITPOS_NUMBER_BURNED = 128;
497 
498     // The bit position of `aux` in packed address data.
499     uint256 private constant BITPOS_AUX = 192;
500 
501     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
502     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
503 
504     // The bit position of `startTimestamp` in packed ownership.
505     uint256 private constant BITPOS_START_TIMESTAMP = 160;
506 
507     // The bit mask of the `burned` bit in packed ownership.
508     uint256 private constant BITMASK_BURNED = 1 << 224;
509 
510     // The bit position of the `nextInitialized` bit in packed ownership.
511     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
512 
513     // The bit mask of the `nextInitialized` bit in packed ownership.
514     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
515 
516     // The bit position of `extraData` in packed ownership.
517     uint256 private constant BITPOS_EXTRA_DATA = 232;
518 
519     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
520     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
521 
522     // The mask of the lower 160 bits for addresses.
523     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
524 
525     // The maximum `quantity` that can be minted with `_mintERC2309`.
526     // This limit is to prevent overflows on the address data entries.
527     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
528     // is required to cause an overflow, which is unrealistic.
529     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
530 
531     // The tokenId of the next token to be minted.
532     uint256 private _currentIndex;
533 
534     // The number of tokens burned.
535     uint256 private _burnCounter;
536 
537     // Token name
538     string private _name;
539 
540     // Token symbol
541     string private _symbol;
542 
543     // Mapping from token ID to ownership details
544     // An empty struct value does not necessarily mean the token is unowned.
545     // See `_packedOwnershipOf` implementation for details.
546     //
547     // Bits Layout:
548     // - [0..159]   `addr`
549     // - [160..223] `startTimestamp`
550     // - [224]      `burned`
551     // - [225]      `nextInitialized`
552     // - [232..255] `extraData`
553     mapping(uint256 => uint256) private _packedOwnerships;
554 
555     // Mapping owner address to address data.
556     //
557     // Bits Layout:
558     // - [0..63]    `balance`
559     // - [64..127]  `numberMinted`
560     // - [128..191] `numberBurned`
561     // - [192..255] `aux`
562     mapping(address => uint256) private _packedAddressData;
563 
564     // Mapping from token ID to approved address.
565     mapping(uint256 => address) private _tokenApprovals;
566 
567     // Mapping from owner to operator approvals
568     mapping(address => mapping(address => bool)) private _operatorApprovals;
569 
570     constructor(string memory name_, string memory symbol_) {
571         _name = name_;
572         _symbol = symbol_;
573         _currentIndex = _startTokenId();
574     }
575 
576     /**
577      * @dev Returns the starting token ID.
578      * To change the starting token ID, please override this function.
579      */
580     function _startTokenId() internal view virtual returns (uint256) {
581         return 0;
582     }
583 
584     /**
585      * @dev Returns the next token ID to be minted.
586      */
587     function _nextTokenId() internal view returns (uint256) {
588         return _currentIndex;
589     }
590 
591     /**
592      * @dev Returns the total number of tokens in existence.
593      * Burned tokens will reduce the count.
594      * To get the total number of tokens minted, please see `_totalMinted`.
595      */
596     function totalSupply() public view override returns (uint256) {
597         // Counter underflow is impossible as _burnCounter cannot be incremented
598         // more than `_currentIndex - _startTokenId()` times.
599         unchecked {
600             return _currentIndex - _burnCounter - _startTokenId();
601         }
602     }
603 
604     /**
605      * @dev Returns the total amount of tokens minted in the contract.
606      */
607     function _totalMinted() internal view returns (uint256) {
608         // Counter underflow is impossible as _currentIndex does not decrement,
609         // and it is initialized to `_startTokenId()`
610         unchecked {
611             return _currentIndex - _startTokenId();
612         }
613     }
614 
615     /**
616      * @dev Returns the total number of tokens burned.
617      */
618     function _totalBurned() internal view returns (uint256) {
619         return _burnCounter;
620     }
621 
622     /**
623      * @dev See {IERC165-supportsInterface}.
624      */
625     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
626         // The interface IDs are constants representing the first 4 bytes of the XOR of
627         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
628         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
629         return
630             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
631             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
632             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
633     }
634 
635     /**
636      * @dev See {IERC721-balanceOf}.
637      */
638     function balanceOf(address owner) public view override returns (uint256) {
639         if (owner == address(0)) revert BalanceQueryForZeroAddress();
640         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
641     }
642 
643     /**
644      * Returns the number of tokens minted by `owner`.
645      */
646     function _numberMinted(address owner) internal view returns (uint256) {
647         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
648     }
649 
650     /**
651      * Returns the number of tokens burned by or on behalf of `owner`.
652      */
653     function _numberBurned(address owner) internal view returns (uint256) {
654         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
655     }
656 
657     /**
658      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
659      */
660     function _getAux(address owner) internal view returns (uint64) {
661         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
662     }
663 
664     /**
665      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
666      * If there are multiple variables, please pack them into a uint64.
667      */
668     function _setAux(address owner, uint64 aux) internal {
669         uint256 packed = _packedAddressData[owner];
670         uint256 auxCasted;
671         // Cast `aux` with assembly to avoid redundant masking.
672         assembly {
673             auxCasted := aux
674         }
675         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
676         _packedAddressData[owner] = packed;
677     }
678 
679     /**
680      * Returns the packed ownership data of `tokenId`.
681      */
682     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
683         uint256 curr = tokenId;
684 
685         unchecked {
686             if (_startTokenId() <= curr)
687                 if (curr < _currentIndex) {
688                     uint256 packed = _packedOwnerships[curr];
689                     // If not burned.
690                     if (packed & BITMASK_BURNED == 0) {
691                         // Invariant:
692                         // There will always be an ownership that has an address and is not burned
693                         // before an ownership that does not have an address and is not burned.
694                         // Hence, curr will not underflow.
695                         //
696                         // We can directly compare the packed value.
697                         // If the address is zero, packed is zero.
698                         while (packed == 0) {
699                             packed = _packedOwnerships[--curr];
700                         }
701                         return packed;
702                     }
703                 }
704         }
705         revert OwnerQueryForNonexistentToken();
706     }
707 
708     /**
709      * Returns the unpacked `TokenOwnership` struct from `packed`.
710      */
711     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
712         ownership.addr = address(uint160(packed));
713         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
714         ownership.burned = packed & BITMASK_BURNED != 0;
715         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
716     }
717 
718     /**
719      * Returns the unpacked `TokenOwnership` struct at `index`.
720      */
721     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
722         return _unpackedOwnership(_packedOwnerships[index]);
723     }
724 
725     /**
726      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
727      */
728     function _initializeOwnershipAt(uint256 index) internal {
729         if (_packedOwnerships[index] == 0) {
730             _packedOwnerships[index] = _packedOwnershipOf(index);
731         }
732     }
733 
734     /**
735      * Gas spent here starts off proportional to the maximum mint batch size.
736      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
737      */
738     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
739         return _unpackedOwnership(_packedOwnershipOf(tokenId));
740     }
741 
742     /**
743      * @dev Packs ownership data into a single uint256.
744      */
745     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
746         assembly {
747             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
748             owner := and(owner, BITMASK_ADDRESS)
749             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
750             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
751         }
752     }
753 
754     /**
755      * @dev See {IERC721-ownerOf}.
756      */
757     function ownerOf(uint256 tokenId) public view override returns (address) {
758         return address(uint160(_packedOwnershipOf(tokenId)));
759     }
760 
761     /**
762      * @dev See {IERC721Metadata-name}.
763      */
764     function name() public view virtual override returns (string memory) {
765         return _name;
766     }
767 
768     /**
769      * @dev See {IERC721Metadata-symbol}.
770      */
771     function symbol() public view virtual override returns (string memory) {
772         return _symbol;
773     }
774 
775     /**
776      * @dev See {IERC721Metadata-tokenURI}.
777      */
778     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
779         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
780 
781         string memory baseURI = _baseURI();
782         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
783     }
784 
785     /**
786      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
787      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
788      * by default, it can be overridden in child contracts.
789      */
790     function _baseURI() internal view virtual returns (string memory) {
791         return '';
792     }
793 
794     /**
795      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
796      */
797     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
798         // For branchless setting of the `nextInitialized` flag.
799         assembly {
800             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
801             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
802         }
803     }
804 
805     /**
806      * @dev See {IERC721-approve}.
807      */
808     function approve(address to, uint256 tokenId) public override {
809         address owner = ownerOf(tokenId);
810 
811         if (_msgSenderERC721A() != owner)
812             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
813                 revert ApprovalCallerNotOwnerNorApproved();
814             }
815 
816         _tokenApprovals[tokenId] = to;
817         emit Approval(owner, to, tokenId);
818     }
819 
820     /**
821      * @dev See {IERC721-getApproved}.
822      */
823     function getApproved(uint256 tokenId) public view override returns (address) {
824         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
825 
826         return _tokenApprovals[tokenId];
827     }
828 
829     /**
830      * @dev See {IERC721-setApprovalForAll}.
831      */
832     function setApprovalForAll(address operator, bool approved) public virtual override {
833         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
834 
835         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
836         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
837     }
838 
839     /**
840      * @dev See {IERC721-isApprovedForAll}.
841      */
842     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
843         return _operatorApprovals[owner][operator];
844     }
845 
846     /**
847      * @dev See {IERC721-safeTransferFrom}.
848      */
849     function safeTransferFrom(
850         address from,
851         address to,
852         uint256 tokenId
853     ) public virtual override {
854         safeTransferFrom(from, to, tokenId, '');
855     }
856 
857     /**
858      * @dev See {IERC721-safeTransferFrom}.
859      */
860     function safeTransferFrom(
861         address from,
862         address to,
863         uint256 tokenId,
864         bytes memory _data
865     ) public virtual override {
866         transferFrom(from, to, tokenId);
867         if (to.code.length != 0)
868             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
869                 revert TransferToNonERC721ReceiverImplementer();
870             }
871     }
872 
873     /**
874      * @dev Returns whether `tokenId` exists.
875      *
876      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
877      *
878      * Tokens start existing when they are minted (`_mint`),
879      */
880     function _exists(uint256 tokenId) internal view returns (bool) {
881         return
882             _startTokenId() <= tokenId &&
883             tokenId < _currentIndex && // If within bounds,
884             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
885     }
886 
887     /**
888      * @dev Equivalent to `_safeMint(to, quantity, '')`.
889      */
890     function _safeMint(address to, uint256 quantity) internal {
891         _safeMint(to, quantity, '');
892     }
893 
894     /**
895      * @dev Safely mints `quantity` tokens and transfers them to `to`.
896      *
897      * Requirements:
898      *
899      * - If `to` refers to a smart contract, it must implement
900      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
901      * - `quantity` must be greater than 0.
902      *
903      * See {_mint}.
904      *
905      * Emits a {Transfer} event for each mint.
906      */
907     function _safeMint(
908         address to,
909         uint256 quantity,
910         bytes memory _data
911     ) internal {
912         _mint(to, quantity);
913 
914         unchecked {
915             if (to.code.length != 0) {
916                 uint256 end = _currentIndex;
917                 uint256 index = end - quantity;
918                 do {
919                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
920                         revert TransferToNonERC721ReceiverImplementer();
921                     }
922                 } while (index < end);
923                 // Reentrancy protection.
924                 if (_currentIndex != end) revert();
925             }
926         }
927     }
928 
929     /**
930      * @dev Mints `quantity` tokens and transfers them to `to`.
931      *
932      * Requirements:
933      *
934      * - `to` cannot be the zero address.
935      * - `quantity` must be greater than 0.
936      *
937      * Emits a {Transfer} event for each mint.
938      */
939     function _mint(address to, uint256 quantity) internal {
940         uint256 startTokenId = _currentIndex;
941         if (to == address(0)) revert MintToZeroAddress();
942         if (quantity == 0) revert MintZeroQuantity();
943 
944         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
945 
946         // Overflows are incredibly unrealistic.
947         // `balance` and `numberMinted` have a maximum limit of 2**64.
948         // `tokenId` has a maximum limit of 2**256.
949         unchecked {
950             // Updates:
951             // - `balance += quantity`.
952             // - `numberMinted += quantity`.
953             //
954             // We can directly add to the `balance` and `numberMinted`.
955             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
956 
957             // Updates:
958             // - `address` to the owner.
959             // - `startTimestamp` to the timestamp of minting.
960             // - `burned` to `false`.
961             // - `nextInitialized` to `quantity == 1`.
962             _packedOwnerships[startTokenId] = _packOwnershipData(
963                 to,
964                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
965             );
966 
967             uint256 tokenId = startTokenId;
968             uint256 end = startTokenId + quantity;
969             do {
970                 emit Transfer(address(0), to, tokenId++);
971             } while (tokenId < end);
972 
973             _currentIndex = end;
974         }
975         _afterTokenTransfers(address(0), to, startTokenId, quantity);
976     }
977 
978     /**
979      * @dev Mints `quantity` tokens and transfers them to `to`.
980      *
981      * This function is intended for efficient minting only during contract creation.
982      *
983      * It emits only one {ConsecutiveTransfer} as defined in
984      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
985      * instead of a sequence of {Transfer} event(s).
986      *
987      * Calling this function outside of contract creation WILL make your contract
988      * non-compliant with the ERC721 standard.
989      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
990      * {ConsecutiveTransfer} event is only permissible during contract creation.
991      *
992      * Requirements:
993      *
994      * - `to` cannot be the zero address.
995      * - `quantity` must be greater than 0.
996      *
997      * Emits a {ConsecutiveTransfer} event.
998      */
999     function _mintERC2309(address to, uint256 quantity) internal {
1000         uint256 startTokenId = _currentIndex;
1001         if (to == address(0)) revert MintToZeroAddress();
1002         if (quantity == 0) revert MintZeroQuantity();
1003         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1004 
1005         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1006 
1007         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1008         unchecked {
1009             // Updates:
1010             // - `balance += quantity`.
1011             // - `numberMinted += quantity`.
1012             //
1013             // We can directly add to the `balance` and `numberMinted`.
1014             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1015 
1016             // Updates:
1017             // - `address` to the owner.
1018             // - `startTimestamp` to the timestamp of minting.
1019             // - `burned` to `false`.
1020             // - `nextInitialized` to `quantity == 1`.
1021             _packedOwnerships[startTokenId] = _packOwnershipData(
1022                 to,
1023                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1024             );
1025 
1026             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1027 
1028             _currentIndex = startTokenId + quantity;
1029         }
1030         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1031     }
1032 
1033     /**
1034      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1035      */
1036     function _getApprovedAddress(uint256 tokenId)
1037         private
1038         view
1039         returns (uint256 approvedAddressSlot, address approvedAddress)
1040     {
1041         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1042         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1043         assembly {
1044             // Compute the slot.
1045             mstore(0x00, tokenId)
1046             mstore(0x20, tokenApprovalsPtr.slot)
1047             approvedAddressSlot := keccak256(0x00, 0x40)
1048             // Load the slot's value from storage.
1049             approvedAddress := sload(approvedAddressSlot)
1050         }
1051     }
1052 
1053     /**
1054      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1055      */
1056     function _isOwnerOrApproved(
1057         address approvedAddress,
1058         address from,
1059         address msgSender
1060     ) private pure returns (bool result) {
1061         assembly {
1062             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1063             from := and(from, BITMASK_ADDRESS)
1064             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1065             msgSender := and(msgSender, BITMASK_ADDRESS)
1066             // `msgSender == from || msgSender == approvedAddress`.
1067             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1068         }
1069     }
1070 
1071     /**
1072      * @dev Transfers `tokenId` from `from` to `to`.
1073      *
1074      * Requirements:
1075      *
1076      * - `to` cannot be the zero address.
1077      * - `tokenId` token must be owned by `from`.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function transferFrom(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) public virtual override {
1086         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1087 
1088         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1089 
1090         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1091 
1092         // The nested ifs save around 20+ gas over a compound boolean condition.
1093         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1094             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1095 
1096         if (to == address(0)) revert TransferToZeroAddress();
1097 
1098         _beforeTokenTransfers(from, to, tokenId, 1);
1099 
1100         // Clear approvals from the previous owner.
1101         assembly {
1102             if approvedAddress {
1103                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1104                 sstore(approvedAddressSlot, 0)
1105             }
1106         }
1107 
1108         // Underflow of the sender's balance is impossible because we check for
1109         // ownership above and the recipient's balance can't realistically overflow.
1110         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1111         unchecked {
1112             // We can directly increment and decrement the balances.
1113             --_packedAddressData[from]; // Updates: `balance -= 1`.
1114             ++_packedAddressData[to]; // Updates: `balance += 1`.
1115 
1116             // Updates:
1117             // - `address` to the next owner.
1118             // - `startTimestamp` to the timestamp of transfering.
1119             // - `burned` to `false`.
1120             // - `nextInitialized` to `true`.
1121             _packedOwnerships[tokenId] = _packOwnershipData(
1122                 to,
1123                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1124             );
1125 
1126             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1127             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1128                 uint256 nextTokenId = tokenId + 1;
1129                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1130                 if (_packedOwnerships[nextTokenId] == 0) {
1131                     // If the next slot is within bounds.
1132                     if (nextTokenId != _currentIndex) {
1133                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1134                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1135                     }
1136                 }
1137             }
1138         }
1139 
1140         emit Transfer(from, to, tokenId);
1141         _afterTokenTransfers(from, to, tokenId, 1);
1142     }
1143 
1144     /**
1145      * @dev Equivalent to `_burn(tokenId, false)`.
1146      */
1147     function _burn(uint256 tokenId) internal virtual {
1148         _burn(tokenId, false);
1149     }
1150 
1151     /**
1152      * @dev Destroys `tokenId`.
1153      * The approval is cleared when the token is burned.
1154      *
1155      * Requirements:
1156      *
1157      * - `tokenId` must exist.
1158      *
1159      * Emits a {Transfer} event.
1160      */
1161     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1162         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1163 
1164         address from = address(uint160(prevOwnershipPacked));
1165 
1166         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1167 
1168         if (approvalCheck) {
1169             // The nested ifs save around 20+ gas over a compound boolean condition.
1170             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1171                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1172         }
1173 
1174         _beforeTokenTransfers(from, address(0), tokenId, 1);
1175 
1176         // Clear approvals from the previous owner.
1177         assembly {
1178             if approvedAddress {
1179                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1180                 sstore(approvedAddressSlot, 0)
1181             }
1182         }
1183 
1184         // Underflow of the sender's balance is impossible because we check for
1185         // ownership above and the recipient's balance can't realistically overflow.
1186         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1187         unchecked {
1188             // Updates:
1189             // - `balance -= 1`.
1190             // - `numberBurned += 1`.
1191             //
1192             // We can directly decrement the balance, and increment the number burned.
1193             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1194             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1195 
1196             // Updates:
1197             // - `address` to the last owner.
1198             // - `startTimestamp` to the timestamp of burning.
1199             // - `burned` to `true`.
1200             // - `nextInitialized` to `true`.
1201             _packedOwnerships[tokenId] = _packOwnershipData(
1202                 from,
1203                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1204             );
1205 
1206             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1207             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1208                 uint256 nextTokenId = tokenId + 1;
1209                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1210                 if (_packedOwnerships[nextTokenId] == 0) {
1211                     // If the next slot is within bounds.
1212                     if (nextTokenId != _currentIndex) {
1213                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1214                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1215                     }
1216                 }
1217             }
1218         }
1219 
1220         emit Transfer(from, address(0), tokenId);
1221         _afterTokenTransfers(from, address(0), tokenId, 1);
1222 
1223         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1224         unchecked {
1225             _burnCounter++;
1226         }
1227     }
1228 
1229     /**
1230      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1231      *
1232      * @param from address representing the previous owner of the given token ID
1233      * @param to target address that will receive the tokens
1234      * @param tokenId uint256 ID of the token to be transferred
1235      * @param _data bytes optional data to send along with the call
1236      * @return bool whether the call correctly returned the expected magic value
1237      */
1238     function _checkContractOnERC721Received(
1239         address from,
1240         address to,
1241         uint256 tokenId,
1242         bytes memory _data
1243     ) private returns (bool) {
1244         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1245             bytes4 retval
1246         ) {
1247             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1248         } catch (bytes memory reason) {
1249             if (reason.length == 0) {
1250                 revert TransferToNonERC721ReceiverImplementer();
1251             } else {
1252                 assembly {
1253                     revert(add(32, reason), mload(reason))
1254                 }
1255             }
1256         }
1257     }
1258 
1259     /**
1260      * @dev Directly sets the extra data for the ownership data `index`.
1261      */
1262     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1263         uint256 packed = _packedOwnerships[index];
1264         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1265         uint256 extraDataCasted;
1266         // Cast `extraData` with assembly to avoid redundant masking.
1267         assembly {
1268             extraDataCasted := extraData
1269         }
1270         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1271         _packedOwnerships[index] = packed;
1272     }
1273 
1274     /**
1275      * @dev Returns the next extra data for the packed ownership data.
1276      * The returned result is shifted into position.
1277      */
1278     function _nextExtraData(
1279         address from,
1280         address to,
1281         uint256 prevOwnershipPacked
1282     ) private view returns (uint256) {
1283         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1284         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1285     }
1286 
1287     /**
1288      * @dev Called during each token transfer to set the 24bit `extraData` field.
1289      * Intended to be overridden by the cosumer contract.
1290      *
1291      * `previousExtraData` - the value of `extraData` before transfer.
1292      *
1293      * Calling conditions:
1294      *
1295      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1296      * transferred to `to`.
1297      * - When `from` is zero, `tokenId` will be minted for `to`.
1298      * - When `to` is zero, `tokenId` will be burned by `from`.
1299      * - `from` and `to` are never both zero.
1300      */
1301     function _extraData(
1302         address from,
1303         address to,
1304         uint24 previousExtraData
1305     ) internal view virtual returns (uint24) {}
1306 
1307     /**
1308      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1309      * This includes minting.
1310      * And also called before burning one token.
1311      *
1312      * startTokenId - the first token id to be transferred
1313      * quantity - the amount to be transferred
1314      *
1315      * Calling conditions:
1316      *
1317      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1318      * transferred to `to`.
1319      * - When `from` is zero, `tokenId` will be minted for `to`.
1320      * - When `to` is zero, `tokenId` will be burned by `from`.
1321      * - `from` and `to` are never both zero.
1322      */
1323     function _beforeTokenTransfers(
1324         address from,
1325         address to,
1326         uint256 startTokenId,
1327         uint256 quantity
1328     ) internal virtual {}
1329 
1330     /**
1331      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1332      * This includes minting.
1333      * And also called after one token has been burned.
1334      *
1335      * startTokenId - the first token id to be transferred
1336      * quantity - the amount to be transferred
1337      *
1338      * Calling conditions:
1339      *
1340      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1341      * transferred to `to`.
1342      * - When `from` is zero, `tokenId` has been minted for `to`.
1343      * - When `to` is zero, `tokenId` has been burned by `from`.
1344      * - `from` and `to` are never both zero.
1345      */
1346     function _afterTokenTransfers(
1347         address from,
1348         address to,
1349         uint256 startTokenId,
1350         uint256 quantity
1351     ) internal virtual {}
1352 
1353     /**
1354      * @dev Returns the message sender (defaults to `msg.sender`).
1355      *
1356      * If you are writing GSN compatible contracts, you need to override this function.
1357      */
1358     function _msgSenderERC721A() internal view virtual returns (address) {
1359         return msg.sender;
1360     }
1361 
1362     /**
1363      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1364      */
1365     function _toString(uint256 value) internal pure returns (string memory ptr) {
1366         assembly {
1367             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1368             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1369             // We will need 1 32-byte word to store the length,
1370             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1371             ptr := add(mload(0x40), 128)
1372             // Update the free memory pointer to allocate.
1373             mstore(0x40, ptr)
1374 
1375             // Cache the end of the memory to calculate the length later.
1376             let end := ptr
1377 
1378             // We write the string from the rightmost digit to the leftmost digit.
1379             // The following is essentially a do-while loop that also handles the zero case.
1380             // Costs a bit more than early returning for the zero case,
1381             // but cheaper in terms of deployment and overall runtime costs.
1382             for {
1383                 // Initialize and perform the first pass without check.
1384                 let temp := value
1385                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1386                 ptr := sub(ptr, 1)
1387                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1388                 mstore8(ptr, add(48, mod(temp, 10)))
1389                 temp := div(temp, 10)
1390             } temp {
1391                 // Keep dividing `temp` until zero.
1392                 temp := div(temp, 10)
1393             } {
1394                 // Body of the for loop.
1395                 ptr := sub(ptr, 1)
1396                 mstore8(ptr, add(48, mod(temp, 10)))
1397             }
1398 
1399             let length := sub(end, ptr)
1400             // Move the pointer 32 bytes leftwards to make room for the length.
1401             ptr := sub(ptr, 32)
1402             // Store the length.
1403             mstore(ptr, length)
1404         }
1405     }
1406 }
1407 
1408 // File: contracts/1 ethh floor.sol
1409 
1410 //SPDX-License-Identifier: MIT
1411 pragma solidity ^0.8.4;
1412 
1413 
1414 
1415 
1416 
1417 
1418 contract RR_1_Eth_Floor is Ownable, ERC721A {
1419     uint256 constant public MAX_SUPPLY = 1000;
1420     
1421 
1422     uint256 public publicPrice = 0.002 ether;
1423 
1424     uint256 constant public PUBLIC_MINT_LIMIT_TXN = 2;
1425     uint256 constant public PUBLIC_MINT_LIMIT = 4;
1426 
1427     string public revealedURI;
1428 
1429     // OpenSea CONTRACT_URI - https://docs.opensea.io/docs/contract-level-metadata
1430     string public CONTRACT_URI = "ipfs://35GWFQCUU8YDTKA6G1YJSCTP68Z4HK5PJX";
1431 
1432     bool public paused = true;
1433     bool public revealed = false;
1434 
1435     bool public freeSale = true;
1436     bool public publicSale = false;
1437 
1438     
1439     address constant internal DEV_ADDRESS = 0x5F7b3a3Cc9431E0A6199FC7BE3C792Cd84783cf7;
1440     
1441     
1442 
1443     mapping(address => bool) public userMintedFree;
1444     mapping(address => uint256) public numUserMints;
1445 
1446     constructor(string memory _name, string memory _symbol, string memory _baseUri) ERC721A("RR 1 ETH FLOOR", "RR1ETH") { }
1447 
1448     
1449 
1450     // This function is if you want to override the first Token ID# for ERC721A
1451     // Note: Fun fact - by overloading this method you save a small amount of gas for minting (technically just the first mint)
1452     function _startTokenId() internal view virtual override returns (uint256) {
1453         return 1;
1454     }
1455 
1456     function refundOverpay(uint256 price) private {
1457         if (msg.value > price) {
1458             (bool succ, ) = payable(msg.sender).call{
1459                 value: (msg.value - price)
1460             }("");
1461             require(succ, "Transfer failed");
1462         }
1463         else if (msg.value < price) {
1464             revert("Not enough ETH sent");
1465         }
1466     }
1467 
1468     
1469     
1470     function freeMint(uint256 quantity) external payable mintCompliance(quantity) {
1471         require(freeSale, "Free sale inactive");
1472         require(msg.value == 0, "This phase is free");
1473         require(quantity == 1, "Only #1 free");
1474 
1475         uint256 newSupply = totalSupply() + quantity;
1476         
1477         require(newSupply <= 100, "Not enough free supply");
1478 
1479         require(!userMintedFree[msg.sender], "User max free limit");
1480         
1481         userMintedFree[msg.sender] = true;
1482 
1483         if(newSupply == 100) {
1484             freeSale = false;
1485             publicSale = true;
1486         }
1487 
1488         _safeMint(msg.sender, quantity);
1489     }
1490 
1491     function publicMint(uint256 quantity) external payable mintCompliance(quantity) {
1492         require(publicSale, "Public sale inactive");
1493         require(quantity <= PUBLIC_MINT_LIMIT_TXN, "Quantity too high");
1494 
1495         uint256 price = publicPrice;
1496         uint256 currMints = numUserMints[msg.sender];
1497                 
1498         require(currMints + quantity <= PUBLIC_MINT_LIMIT, "User max mint limit");
1499         
1500         refundOverpay(price * quantity);
1501 
1502         numUserMints[msg.sender] = (currMints + quantity);
1503 
1504         _safeMint(msg.sender, quantity);
1505     }
1506 
1507    
1508 
1509     // Note: walletOfOwner is only really necessary for enumerability when staking/using on websites etc.
1510         // That said, it's a public view so we can keep it in.
1511         // This could also be optimized if someone REALLY wanted, but it's just a public view.
1512         // Check the pinned tweets of 0xInuarashi for more ideas on this method!
1513         // For now, this is just the version that existed in v1.
1514     function walletOfOwner(address _owner) public view returns (uint256[] memory)
1515     {
1516         uint256 ownerTokenCount = balanceOf(_owner);
1517         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1518         uint256 currentTokenId = 1;
1519         uint256 ownedTokenIndex = 0;
1520 
1521         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= MAX_SUPPLY) {
1522             address currentTokenOwner = ownerOf(currentTokenId);
1523 
1524             if (currentTokenOwner == _owner) {
1525                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1526 
1527                 ownedTokenIndex++;
1528             }
1529 
1530         currentTokenId++;
1531         }
1532 
1533         return ownedTokenIds;
1534     }
1535 
1536     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1537         // Note: You don't REALLY need this require statement since nothing should be querying for non-existing tokens after reveal.
1538             // That said, it's a public view method so gas efficiency shouldn't come into play.
1539         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1540         
1541         if (revealed) {
1542             return string(abi.encodePacked(revealedURI, Strings.toString(_tokenId), ".json"));
1543         }
1544         else {
1545             return revealedURI;
1546         }
1547     }
1548 
1549     // https://docs.opensea.io/docs/contract-level-metadata
1550     // https://ethereum.stackexchange.com/questions/110924/how-to-properly-implement-a-contracturi-for-on-chain-nfts
1551     function contractURI() public view returns (string memory) {
1552         return CONTRACT_URI;
1553     }
1554 
1555    
1556 
1557     function setPublicPrice(uint256 _publicPrice) public onlyOwner {
1558         publicPrice = _publicPrice;
1559     }
1560 
1561     function setBaseURI(string memory _baseUri) public onlyOwner {
1562         revealedURI = _baseUri;
1563     }
1564 
1565 
1566     function revealCollection(bool _revealed, string memory _baseUri) public onlyOwner {
1567         revealed = _revealed;
1568         revealedURI = _baseUri;
1569     }
1570 
1571 
1572     function setContractURI(string memory _contractURI) public onlyOwner {
1573         CONTRACT_URI = _contractURI;
1574     }
1575 
1576     // Note: Another option is to inherit Pausable without implementing the logic yourself.
1577        
1578     function setPaused(bool _state) public onlyOwner {
1579         paused = _state;
1580     }
1581 
1582     function setRevealed(bool _state) public onlyOwner {
1583         revealed = _state;
1584     }
1585 
1586     function setPublicEnabled(bool _state) public onlyOwner {
1587         publicSale = _state;
1588         freeSale = !_state;
1589     }
1590     function setFreeEnabled(bool _state) public onlyOwner {
1591         freeSale = _state;
1592         publicSale = !_state;
1593     }
1594 
1595 
1596     function withdraw() external payable onlyOwner {
1597         // Get the current funds to calculate initial percentages
1598         uint256 currBalance = address(this).balance;
1599 
1600         (bool succ, ) = payable(DEV_ADDRESS).call{
1601             value: (currBalance * 10000) / 10000
1602         }("0x5F7b3a3Cc9431E0A6199FC7BE3C792Cd84783cf7");
1603         require(succ, "Dev transfer failed");
1604 
1605     }
1606 
1607     // Owner-only mint functionality to "Airdrop" mints to specific users
1608         // Note: These will likely end up hidden on OpenSea
1609     function mintToUser(uint256 quantity, address receiver) public onlyOwner mintCompliance(quantity) {
1610         _safeMint(receiver, quantity);
1611     }
1612 
1613    
1614 
1615     modifier mintCompliance(uint256 quantity) {
1616         require(!paused, "Contract is paused");
1617         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough mints left");
1618         require(tx.origin == msg.sender, "No contract minting");
1619         _;
1620     }
1621 }