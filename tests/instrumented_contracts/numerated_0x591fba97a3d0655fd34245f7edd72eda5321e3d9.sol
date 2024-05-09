1 // Seisdalo by Dalo De Artes
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 // SPDX-License-Identifier: MIT
4 
5 
6 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15     uint8 private constant _ADDRESS_LENGTH = 20;
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 
73     /**
74      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
75      */
76     function toHexString(address addr) internal pure returns (string memory) {
77         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
78     }
79 }
80 
81 // File: @openzeppelin/contracts/utils/Context.sol
82 
83 
84 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Provides information about the current execution context, including the
90  * sender of the transaction and its data. While these are generally available
91  * via msg.sender and msg.data, they should not be accessed in such a direct
92  * manner, since when dealing with meta-transactions the account sending and
93  * paying for execution may not be the actual sender (as far as an application
94  * is concerned).
95  *
96  * This contract is only required for intermediate, library-like contracts.
97  */
98 abstract contract Context {
99     function _msgSender() internal view virtual returns (address) {
100         return msg.sender;
101     }
102 
103     function _msgData() internal view virtual returns (bytes calldata) {
104         return msg.data;
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
196 // ERC721A Contracts v4.1.0
197 // Creator: Chiru Labs
198 
199 pragma solidity ^0.8.4;
200 
201 /**
202  * @dev Interface of an ERC721A compliant contract.
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
251      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
252      */
253     error TransferToNonERC721ReceiverImplementer();
254 
255     /**
256      * Cannot transfer to the zero address.
257      */
258     error TransferToZeroAddress();
259 
260     /**
261      * The token does not exist.
262      */
263     error URIQueryForNonexistentToken();
264 
265     /**
266      * The `quantity` minted with ERC2309 exceeds the safety limit.
267      */
268     error MintERC2309QuantityExceedsLimit();
269 
270     /**
271      * The `extraData` cannot be set on an unintialized ownership slot.
272      */
273     error OwnershipNotInitializedForExtraData();
274 
275     struct TokenOwnership {
276         // The address of the owner.
277         address addr;
278         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
279         uint64 startTimestamp;
280         // Whether the token has been burned.
281         bool burned;
282         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
283         uint24 extraData;
284     }
285 
286     /**
287      * @dev Returns the total amount of tokens stored by the contract.
288      *
289      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
290      */
291     function totalSupply() external view returns (uint256);
292 
293     // ==============================
294     //            IERC165
295     // ==============================
296 
297     /**
298      * @dev Returns true if this contract implements the interface defined by
299      * `interfaceId`. See the corresponding
300      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
301      * to learn more about how these ids are created.
302      *
303      * This function call must use less than 30 000 gas.
304      */
305     function supportsInterface(bytes4 interfaceId) external view returns (bool);
306 
307     // ==============================
308     //            IERC721
309     // ==============================
310 
311     /**
312      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
313      */
314     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
315 
316     /**
317      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
318      */
319     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
320 
321     /**
322      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
323      */
324     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
325 
326     /**
327      * @dev Returns the number of tokens in ``owner``'s account.
328      */
329     function balanceOf(address owner) external view returns (uint256 balance);
330 
331     /**
332      * @dev Returns the owner of the `tokenId` token.
333      *
334      * Requirements:
335      *
336      * - `tokenId` must exist.
337      */
338     function ownerOf(uint256 tokenId) external view returns (address owner);
339 
340     /**
341      * @dev Safely transfers `tokenId` token from `from` to `to`.
342      *
343      * Requirements:
344      *
345      * - `from` cannot be the zero address.
346      * - `to` cannot be the zero address.
347      * - `tokenId` token must exist and be owned by `from`.
348      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
349      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
350      *
351      * Emits a {Transfer} event.
352      */
353     function safeTransferFrom(
354         address from,
355         address to,
356         uint256 tokenId,
357         bytes calldata data
358     ) external;
359 
360     /**
361      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
362      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
363      *
364      * Requirements:
365      *
366      * - `from` cannot be the zero address.
367      * - `to` cannot be the zero address.
368      * - `tokenId` token must exist and be owned by `from`.
369      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
370      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
371      *
372      * Emits a {Transfer} event.
373      */
374     function safeTransferFrom(
375         address from,
376         address to,
377         uint256 tokenId
378     ) external;
379 
380     /**
381      * @dev Transfers `tokenId` token from `from` to `to`.
382      *
383      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
384      *
385      * Requirements:
386      *
387      * - `from` cannot be the zero address.
388      * - `to` cannot be the zero address.
389      * - `tokenId` token must be owned by `from`.
390      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
391      *
392      * Emits a {Transfer} event.
393      */
394     function transferFrom(
395         address from,
396         address to,
397         uint256 tokenId
398     ) external;
399 
400     /**
401      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
402      * The approval is cleared when the token is transferred.
403      *
404      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
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
417      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
418      *
419      * Requirements:
420      *
421      * - The `operator` cannot be the caller.
422      *
423      * Emits an {ApprovalForAll} event.
424      */
425     function setApprovalForAll(address operator, bool _approved) external;
426 
427     /**
428      * @dev Returns the account approved for `tokenId` token.
429      *
430      * Requirements:
431      *
432      * - `tokenId` must exist.
433      */
434     function getApproved(uint256 tokenId) external view returns (address operator);
435 
436     /**
437      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
438      *
439      * See {setApprovalForAll}
440      */
441     function isApprovedForAll(address owner, address operator) external view returns (bool);
442 
443     // ==============================
444     //        IERC721Metadata
445     // ==============================
446 
447     /**
448      * @dev Returns the token collection name.
449      */
450     function name() external view returns (string memory);
451 
452     /**
453      * @dev Returns the token collection symbol.
454      */
455     function symbol() external view returns (string memory);
456 
457     /**
458      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
459      */
460     function tokenURI(uint256 tokenId) external view returns (string memory);
461 
462     // ==============================
463     //            IERC2309
464     // ==============================
465 
466     /**
467      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
468      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
469      */
470     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
471 }
472 
473 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
474 
475 
476 // ERC721A Contracts v4.1.0
477 // Creator: Chiru Labs
478 
479 pragma solidity ^0.8.4;
480 
481 
482 /**
483  * @dev Interface of an ERC721AQueryable compliant contract.
484  */
485 interface IERC721AQueryable is IERC721A {
486     /**
487      * Invalid query range (`start` >= `stop`).
488      */
489     error InvalidQueryRange();
490 
491     /**
492      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
493      *
494      * If the `tokenId` is out of bounds:
495      *   - `addr` = `address(0)`
496      *   - `startTimestamp` = `0`
497      *   - `burned` = `false`
498      *
499      * If the `tokenId` is burned:
500      *   - `addr` = `<Address of owner before token was burned>`
501      *   - `startTimestamp` = `<Timestamp when token was burned>`
502      *   - `burned = `true`
503      *
504      * Otherwise:
505      *   - `addr` = `<Address of owner>`
506      *   - `startTimestamp` = `<Timestamp of start of ownership>`
507      *   - `burned = `false`
508      */
509     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
510 
511     /**
512      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
513      * See {ERC721AQueryable-explicitOwnershipOf}
514      */
515     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
516 
517     /**
518      * @dev Returns an array of token IDs owned by `owner`,
519      * in the range [`start`, `stop`)
520      * (i.e. `start <= tokenId < stop`).
521      *
522      * This function allows for tokens to be queried if the collection
523      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
524      *
525      * Requirements:
526      *
527      * - `start` < `stop`
528      */
529     function tokensOfOwnerIn(
530         address owner,
531         uint256 start,
532         uint256 stop
533     ) external view returns (uint256[] memory);
534 
535     /**
536      * @dev Returns an array of token IDs owned by `owner`.
537      *
538      * This function scans the ownership mapping and is O(totalSupply) in complexity.
539      * It is meant to be called off-chain.
540      *
541      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
542      * multiple smaller scans if the collection is large enough to cause
543      * an out-of-gas error (10K pfp collections should be fine).
544      */
545     function tokensOfOwner(address owner) external view returns (uint256[] memory);
546 }
547 
548 // File: erc721a/contracts/ERC721A.sol
549 
550 
551 // ERC721A Contracts v4.1.0
552 // Creator: Chiru Labs
553 
554 pragma solidity ^0.8.4;
555 
556 
557 /**
558  * @dev ERC721 token receiver interface.
559  */
560 interface ERC721A__IERC721Receiver {
561     function onERC721Received(
562         address operator,
563         address from,
564         uint256 tokenId,
565         bytes calldata data
566     ) external returns (bytes4);
567 }
568 
569 /**
570  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
571  * including the Metadata extension. Built to optimize for lower gas during batch mints.
572  *
573  * Assumes serials are sequentially minted starting at `_startTokenId()`
574  * (defaults to 0, e.g. 0, 1, 2, 3..).
575  *
576  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
577  *
578  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
579  */
580 contract ERC721A is IERC721A {
581     // Mask of an entry in packed address data.
582     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
583 
584     // The bit position of `numberMinted` in packed address data.
585     uint256 private constant BITPOS_NUMBER_MINTED = 64;
586 
587     // The bit position of `numberBurned` in packed address data.
588     uint256 private constant BITPOS_NUMBER_BURNED = 128;
589 
590     // The bit position of `aux` in packed address data.
591     uint256 private constant BITPOS_AUX = 192;
592 
593     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
594     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
595 
596     // The bit position of `startTimestamp` in packed ownership.
597     uint256 private constant BITPOS_START_TIMESTAMP = 160;
598 
599     // The bit mask of the `burned` bit in packed ownership.
600     uint256 private constant BITMASK_BURNED = 1 << 224;
601 
602     // The bit position of the `nextInitialized` bit in packed ownership.
603     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
604 
605     // The bit mask of the `nextInitialized` bit in packed ownership.
606     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
607 
608     // The bit position of `extraData` in packed ownership.
609     uint256 private constant BITPOS_EXTRA_DATA = 232;
610 
611     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
612     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
613 
614     // The mask of the lower 160 bits for addresses.
615     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
616 
617     // The maximum `quantity` that can be minted with `_mintERC2309`.
618     // This limit is to prevent overflows on the address data entries.
619     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
620     // is required to cause an overflow, which is unrealistic.
621     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
622 
623     // The tokenId of the next token to be minted.
624     uint256 private _currentIndex;
625 
626     // The number of tokens burned.
627     uint256 private _burnCounter;
628 
629     // Token name
630     string private _name;
631 
632     // Token symbol
633     string private _symbol;
634 
635     // Mapping from token ID to ownership details
636     // An empty struct value does not necessarily mean the token is unowned.
637     // See `_packedOwnershipOf` implementation for details.
638     //
639     // Bits Layout:
640     // - [0..159]   `addr`
641     // - [160..223] `startTimestamp`
642     // - [224]      `burned`
643     // - [225]      `nextInitialized`
644     // - [232..255] `extraData`
645     mapping(uint256 => uint256) private _packedOwnerships;
646 
647     // Mapping owner address to address data.
648     //
649     // Bits Layout:
650     // - [0..63]    `balance`
651     // - [64..127]  `numberMinted`
652     // - [128..191] `numberBurned`
653     // - [192..255] `aux`
654     mapping(address => uint256) private _packedAddressData;
655 
656     // Mapping from token ID to approved address.
657     mapping(uint256 => address) private _tokenApprovals;
658 
659     // Mapping from owner to operator approvals
660     mapping(address => mapping(address => bool)) private _operatorApprovals;
661 
662     constructor(string memory name_, string memory symbol_) {
663         _name = name_;
664         _symbol = symbol_;
665         _currentIndex = _startTokenId();
666     }
667 
668     /**
669      * @dev Returns the starting token ID.
670      * To change the starting token ID, please override this function.
671      */
672     function _startTokenId() internal view virtual returns (uint256) {
673         return 0;
674     }
675 
676     /**
677      * @dev Returns the next token ID to be minted.
678      */
679     function _nextTokenId() internal view returns (uint256) {
680         return _currentIndex;
681     }
682 
683     /**
684      * @dev Returns the total number of tokens in existence.
685      * Burned tokens will reduce the count.
686      * To get the total number of tokens minted, please see `_totalMinted`.
687      */
688     function totalSupply() public view override returns (uint256) {
689         // Counter underflow is impossible as _burnCounter cannot be incremented
690         // more than `_currentIndex - _startTokenId()` times.
691         unchecked {
692             return _currentIndex - _burnCounter - _startTokenId();
693         }
694     }
695 
696     /**
697      * @dev Returns the total amount of tokens minted in the contract.
698      */
699     function _totalMinted() internal view returns (uint256) {
700         // Counter underflow is impossible as _currentIndex does not decrement,
701         // and it is initialized to `_startTokenId()`
702         unchecked {
703             return _currentIndex - _startTokenId();
704         }
705     }
706 
707     /**
708      * @dev Returns the total number of tokens burned.
709      */
710     function _totalBurned() internal view returns (uint256) {
711         return _burnCounter;
712     }
713 
714     /**
715      * @dev See {IERC165-supportsInterface}.
716      */
717     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
718         // The interface IDs are constants representing the first 4 bytes of the XOR of
719         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
720         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
721         return
722             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
723             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
724             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
725     }
726 
727     /**
728      * @dev See {IERC721-balanceOf}.
729      */
730     function balanceOf(address owner) public view override returns (uint256) {
731         if (owner == address(0)) revert BalanceQueryForZeroAddress();
732         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
733     }
734 
735     /**
736      * Returns the number of tokens minted by `owner`.
737      */
738     function _numberMinted(address owner) internal view returns (uint256) {
739         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
740     }
741 
742     /**
743      * Returns the number of tokens burned by or on behalf of `owner`.
744      */
745     function _numberBurned(address owner) internal view returns (uint256) {
746         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
747     }
748 
749     /**
750      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
751      */
752     function _getAux(address owner) internal view returns (uint64) {
753         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
754     }
755 
756     /**
757      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
758      * If there are multiple variables, please pack them into a uint64.
759      */
760     function _setAux(address owner, uint64 aux) internal {
761         uint256 packed = _packedAddressData[owner];
762         uint256 auxCasted;
763         // Cast `aux` with assembly to avoid redundant masking.
764         assembly {
765             auxCasted := aux
766         }
767         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
768         _packedAddressData[owner] = packed;
769     }
770 
771     /**
772      * Returns the packed ownership data of `tokenId`.
773      */
774     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
775         uint256 curr = tokenId;
776 
777         unchecked {
778             if (_startTokenId() <= curr)
779                 if (curr < _currentIndex) {
780                     uint256 packed = _packedOwnerships[curr];
781                     // If not burned.
782                     if (packed & BITMASK_BURNED == 0) {
783                         // Invariant:
784                         // There will always be an ownership that has an address and is not burned
785                         // before an ownership that does not have an address and is not burned.
786                         // Hence, curr will not underflow.
787                         //
788                         // We can directly compare the packed value.
789                         // If the address is zero, packed is zero.
790                         while (packed == 0) {
791                             packed = _packedOwnerships[--curr];
792                         }
793                         return packed;
794                     }
795                 }
796         }
797         revert OwnerQueryForNonexistentToken();
798     }
799 
800     /**
801      * Returns the unpacked `TokenOwnership` struct from `packed`.
802      */
803     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
804         ownership.addr = address(uint160(packed));
805         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
806         ownership.burned = packed & BITMASK_BURNED != 0;
807         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
808     }
809 
810     /**
811      * Returns the unpacked `TokenOwnership` struct at `index`.
812      */
813     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
814         return _unpackedOwnership(_packedOwnerships[index]);
815     }
816 
817     /**
818      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
819      */
820     function _initializeOwnershipAt(uint256 index) internal {
821         if (_packedOwnerships[index] == 0) {
822             _packedOwnerships[index] = _packedOwnershipOf(index);
823         }
824     }
825 
826     /**
827      * Gas spent here starts off proportional to the maximum mint batch size.
828      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
829      */
830     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
831         return _unpackedOwnership(_packedOwnershipOf(tokenId));
832     }
833 
834     /**
835      * @dev Packs ownership data into a single uint256.
836      */
837     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
838         assembly {
839             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
840             owner := and(owner, BITMASK_ADDRESS)
841             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
842             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
843         }
844     }
845 
846     /**
847      * @dev See {IERC721-ownerOf}.
848      */
849     function ownerOf(uint256 tokenId) public view override returns (address) {
850         return address(uint160(_packedOwnershipOf(tokenId)));
851     }
852 
853     /**
854      * @dev See {IERC721Metadata-name}.
855      */
856     function name() public view virtual override returns (string memory) {
857         return _name;
858     }
859 
860     /**
861      * @dev See {IERC721Metadata-symbol}.
862      */
863     function symbol() public view virtual override returns (string memory) {
864         return _symbol;
865     }
866 
867     /**
868      * @dev See {IERC721Metadata-tokenURI}.
869      */
870     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
871         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
872 
873         string memory baseURI = _baseURI();
874         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
875     }
876 
877     /**
878      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
879      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
880      * by default, it can be overridden in child contracts.
881      */
882     function _baseURI() internal view virtual returns (string memory) {
883         return '';
884     }
885 
886     /**
887      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
888      */
889     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
890         // For branchless setting of the `nextInitialized` flag.
891         assembly {
892             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
893             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
894         }
895     }
896 
897     /**
898      * @dev See {IERC721-approve}.
899      */
900     function approve(address to, uint256 tokenId) public override {
901         address owner = ownerOf(tokenId);
902 
903         if (_msgSenderERC721A() != owner)
904             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
905                 revert ApprovalCallerNotOwnerNorApproved();
906             }
907 
908         _tokenApprovals[tokenId] = to;
909         emit Approval(owner, to, tokenId);
910     }
911 
912     /**
913      * @dev See {IERC721-getApproved}.
914      */
915     function getApproved(uint256 tokenId) public view override returns (address) {
916         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
917 
918         return _tokenApprovals[tokenId];
919     }
920 
921     /**
922      * @dev See {IERC721-setApprovalForAll}.
923      */
924     function setApprovalForAll(address operator, bool approved) public virtual override {
925         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
926 
927         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
928         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
929     }
930 
931     /**
932      * @dev See {IERC721-isApprovedForAll}.
933      */
934     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
935         return _operatorApprovals[owner][operator];
936     }
937 
938     /**
939      * @dev See {IERC721-safeTransferFrom}.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId
945     ) public virtual override {
946         safeTransferFrom(from, to, tokenId, '');
947     }
948 
949     /**
950      * @dev See {IERC721-safeTransferFrom}.
951      */
952     function safeTransferFrom(
953         address from,
954         address to,
955         uint256 tokenId,
956         bytes memory _data
957     ) public virtual override {
958         transferFrom(from, to, tokenId);
959         if (to.code.length != 0)
960             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
961                 revert TransferToNonERC721ReceiverImplementer();
962             }
963     }
964 
965     /**
966      * @dev Returns whether `tokenId` exists.
967      *
968      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
969      *
970      * Tokens start existing when they are minted (`_mint`),
971      */
972     function _exists(uint256 tokenId) internal view returns (bool) {
973         return
974             _startTokenId() <= tokenId &&
975             tokenId < _currentIndex && // If within bounds,
976             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
977     }
978 
979     /**
980      * @dev Equivalent to `_safeMint(to, quantity, '')`.
981      */
982     function _safeMint(address to, uint256 quantity) internal {
983         _safeMint(to, quantity, '');
984     }
985 
986     /**
987      * @dev Safely mints `quantity` tokens and transfers them to `to`.
988      *
989      * Requirements:
990      *
991      * - If `to` refers to a smart contract, it must implement
992      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
993      * - `quantity` must be greater than 0.
994      *
995      * See {_mint}.
996      *
997      * Emits a {Transfer} event for each mint.
998      */
999     function _safeMint(
1000         address to,
1001         uint256 quantity,
1002         bytes memory _data
1003     ) internal {
1004         _mint(to, quantity);
1005 
1006         unchecked {
1007             if (to.code.length != 0) {
1008                 uint256 end = _currentIndex;
1009                 uint256 index = end - quantity;
1010                 do {
1011                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1012                         revert TransferToNonERC721ReceiverImplementer();
1013                     }
1014                 } while (index < end);
1015                 // Reentrancy protection.
1016                 if (_currentIndex != end) revert();
1017             }
1018         }
1019     }
1020 
1021     /**
1022      * @dev Mints `quantity` tokens and transfers them to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `quantity` must be greater than 0.
1028      *
1029      * Emits a {Transfer} event for each mint.
1030      */
1031     function _mint(address to, uint256 quantity) internal {
1032         uint256 startTokenId = _currentIndex;
1033         if (to == address(0)) revert MintToZeroAddress();
1034         if (quantity == 0) revert MintZeroQuantity();
1035 
1036         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1037 
1038         // Overflows are incredibly unrealistic.
1039         // `balance` and `numberMinted` have a maximum limit of 2**64.
1040         // `tokenId` has a maximum limit of 2**256.
1041         unchecked {
1042             // Updates:
1043             // - `balance += quantity`.
1044             // - `numberMinted += quantity`.
1045             //
1046             // We can directly add to the `balance` and `numberMinted`.
1047             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1048 
1049             // Updates:
1050             // - `address` to the owner.
1051             // - `startTimestamp` to the timestamp of minting.
1052             // - `burned` to `false`.
1053             // - `nextInitialized` to `quantity == 1`.
1054             _packedOwnerships[startTokenId] = _packOwnershipData(
1055                 to,
1056                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1057             );
1058 
1059             uint256 tokenId = startTokenId;
1060             uint256 end = startTokenId + quantity;
1061             do {
1062                 emit Transfer(address(0), to, tokenId++);
1063             } while (tokenId < end);
1064 
1065             _currentIndex = end;
1066         }
1067         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1068     }
1069 
1070     /**
1071      * @dev Mints `quantity` tokens and transfers them to `to`.
1072      *
1073      * This function is intended for efficient minting only during contract creation.
1074      *
1075      * It emits only one {ConsecutiveTransfer} as defined in
1076      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1077      * instead of a sequence of {Transfer} event(s).
1078      *
1079      * Calling this function outside of contract creation WILL make your contract
1080      * non-compliant with the ERC721 standard.
1081      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1082      * {ConsecutiveTransfer} event is only permissible during contract creation.
1083      *
1084      * Requirements:
1085      *
1086      * - `to` cannot be the zero address.
1087      * - `quantity` must be greater than 0.
1088      *
1089      * Emits a {ConsecutiveTransfer} event.
1090      */
1091     function _mintERC2309(address to, uint256 quantity) internal {
1092         uint256 startTokenId = _currentIndex;
1093         if (to == address(0)) revert MintToZeroAddress();
1094         if (quantity == 0) revert MintZeroQuantity();
1095         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1096 
1097         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1098 
1099         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1100         unchecked {
1101             // Updates:
1102             // - `balance += quantity`.
1103             // - `numberMinted += quantity`.
1104             //
1105             // We can directly add to the `balance` and `numberMinted`.
1106             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1107 
1108             // Updates:
1109             // - `address` to the owner.
1110             // - `startTimestamp` to the timestamp of minting.
1111             // - `burned` to `false`.
1112             // - `nextInitialized` to `quantity == 1`.
1113             _packedOwnerships[startTokenId] = _packOwnershipData(
1114                 to,
1115                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1116             );
1117 
1118             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1119 
1120             _currentIndex = startTokenId + quantity;
1121         }
1122         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1123     }
1124 
1125     /**
1126      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1127      */
1128     function _getApprovedAddress(uint256 tokenId)
1129         private
1130         view
1131         returns (uint256 approvedAddressSlot, address approvedAddress)
1132     {
1133         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1134         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1135         assembly {
1136             // Compute the slot.
1137             mstore(0x00, tokenId)
1138             mstore(0x20, tokenApprovalsPtr.slot)
1139             approvedAddressSlot := keccak256(0x00, 0x40)
1140             // Load the slot's value from storage.
1141             approvedAddress := sload(approvedAddressSlot)
1142         }
1143     }
1144 
1145     /**
1146      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1147      */
1148     function _isOwnerOrApproved(
1149         address approvedAddress,
1150         address from,
1151         address msgSender
1152     ) private pure returns (bool result) {
1153         assembly {
1154             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1155             from := and(from, BITMASK_ADDRESS)
1156             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1157             msgSender := and(msgSender, BITMASK_ADDRESS)
1158             // `msgSender == from || msgSender == approvedAddress`.
1159             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1160         }
1161     }
1162 
1163     /**
1164      * @dev Transfers `tokenId` from `from` to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - `to` cannot be the zero address.
1169      * - `tokenId` token must be owned by `from`.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function transferFrom(
1174         address from,
1175         address to,
1176         uint256 tokenId
1177     ) public virtual override {
1178         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1179 
1180         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1181 
1182         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1183 
1184         // The nested ifs save around 20+ gas over a compound boolean condition.
1185         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1186             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1187 
1188         if (to == address(0)) revert TransferToZeroAddress();
1189 
1190         _beforeTokenTransfers(from, to, tokenId, 1);
1191 
1192         // Clear approvals from the previous owner.
1193         assembly {
1194             if approvedAddress {
1195                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1196                 sstore(approvedAddressSlot, 0)
1197             }
1198         }
1199 
1200         // Underflow of the sender's balance is impossible because we check for
1201         // ownership above and the recipient's balance can't realistically overflow.
1202         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1203         unchecked {
1204             // We can directly increment and decrement the balances.
1205             --_packedAddressData[from]; // Updates: `balance -= 1`.
1206             ++_packedAddressData[to]; // Updates: `balance += 1`.
1207 
1208             // Updates:
1209             // - `address` to the next owner.
1210             // - `startTimestamp` to the timestamp of transfering.
1211             // - `burned` to `false`.
1212             // - `nextInitialized` to `true`.
1213             _packedOwnerships[tokenId] = _packOwnershipData(
1214                 to,
1215                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1216             );
1217 
1218             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1219             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1220                 uint256 nextTokenId = tokenId + 1;
1221                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1222                 if (_packedOwnerships[nextTokenId] == 0) {
1223                     // If the next slot is within bounds.
1224                     if (nextTokenId != _currentIndex) {
1225                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1226                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1227                     }
1228                 }
1229             }
1230         }
1231 
1232         emit Transfer(from, to, tokenId);
1233         _afterTokenTransfers(from, to, tokenId, 1);
1234     }
1235 
1236     /**
1237      * @dev Equivalent to `_burn(tokenId, false)`.
1238      */
1239     function _burn(uint256 tokenId) internal virtual {
1240         _burn(tokenId, false);
1241     }
1242 
1243     /**
1244      * @dev Destroys `tokenId`.
1245      * The approval is cleared when the token is burned.
1246      *
1247      * Requirements:
1248      *
1249      * - `tokenId` must exist.
1250      *
1251      * Emits a {Transfer} event.
1252      */
1253     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1254         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1255 
1256         address from = address(uint160(prevOwnershipPacked));
1257 
1258         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1259 
1260         if (approvalCheck) {
1261             // The nested ifs save around 20+ gas over a compound boolean condition.
1262             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1263                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1264         }
1265 
1266         _beforeTokenTransfers(from, address(0), tokenId, 1);
1267 
1268         // Clear approvals from the previous owner.
1269         assembly {
1270             if approvedAddress {
1271                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1272                 sstore(approvedAddressSlot, 0)
1273             }
1274         }
1275 
1276         // Underflow of the sender's balance is impossible because we check for
1277         // ownership above and the recipient's balance can't realistically overflow.
1278         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1279         unchecked {
1280             // Updates:
1281             // - `balance -= 1`.
1282             // - `numberBurned += 1`.
1283             //
1284             // We can directly decrement the balance, and increment the number burned.
1285             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1286             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1287 
1288             // Updates:
1289             // - `address` to the last owner.
1290             // - `startTimestamp` to the timestamp of burning.
1291             // - `burned` to `true`.
1292             // - `nextInitialized` to `true`.
1293             _packedOwnerships[tokenId] = _packOwnershipData(
1294                 from,
1295                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1296             );
1297 
1298             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1299             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1300                 uint256 nextTokenId = tokenId + 1;
1301                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1302                 if (_packedOwnerships[nextTokenId] == 0) {
1303                     // If the next slot is within bounds.
1304                     if (nextTokenId != _currentIndex) {
1305                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1306                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1307                     }
1308                 }
1309             }
1310         }
1311 
1312         emit Transfer(from, address(0), tokenId);
1313         _afterTokenTransfers(from, address(0), tokenId, 1);
1314 
1315         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1316         unchecked {
1317             _burnCounter++;
1318         }
1319     }
1320 
1321     /**
1322      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1323      *
1324      * @param from address representing the previous owner of the given token ID
1325      * @param to target address that will receive the tokens
1326      * @param tokenId uint256 ID of the token to be transferred
1327      * @param _data bytes optional data to send along with the call
1328      * @return bool whether the call correctly returned the expected magic value
1329      */
1330     function _checkContractOnERC721Received(
1331         address from,
1332         address to,
1333         uint256 tokenId,
1334         bytes memory _data
1335     ) private returns (bool) {
1336         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1337             bytes4 retval
1338         ) {
1339             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1340         } catch (bytes memory reason) {
1341             if (reason.length == 0) {
1342                 revert TransferToNonERC721ReceiverImplementer();
1343             } else {
1344                 assembly {
1345                     revert(add(32, reason), mload(reason))
1346                 }
1347             }
1348         }
1349     }
1350 
1351     /**
1352      * @dev Directly sets the extra data for the ownership data `index`.
1353      */
1354     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1355         uint256 packed = _packedOwnerships[index];
1356         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1357         uint256 extraDataCasted;
1358         // Cast `extraData` with assembly to avoid redundant masking.
1359         assembly {
1360             extraDataCasted := extraData
1361         }
1362         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1363         _packedOwnerships[index] = packed;
1364     }
1365 
1366     /**
1367      * @dev Returns the next extra data for the packed ownership data.
1368      * The returned result is shifted into position.
1369      */
1370     function _nextExtraData(
1371         address from,
1372         address to,
1373         uint256 prevOwnershipPacked
1374     ) private view returns (uint256) {
1375         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1376         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1377     }
1378 
1379     /**
1380      * @dev Called during each token transfer to set the 24bit `extraData` field.
1381      * Intended to be overridden by the cosumer contract.
1382      *
1383      * `previousExtraData` - the value of `extraData` before transfer.
1384      *
1385      * Calling conditions:
1386      *
1387      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1388      * transferred to `to`.
1389      * - When `from` is zero, `tokenId` will be minted for `to`.
1390      * - When `to` is zero, `tokenId` will be burned by `from`.
1391      * - `from` and `to` are never both zero.
1392      */
1393     function _extraData(
1394         address from,
1395         address to,
1396         uint24 previousExtraData
1397     ) internal view virtual returns (uint24) {}
1398 
1399     /**
1400      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1401      * This includes minting.
1402      * And also called before burning one token.
1403      *
1404      * startTokenId - the first token id to be transferred
1405      * quantity - the amount to be transferred
1406      *
1407      * Calling conditions:
1408      *
1409      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1410      * transferred to `to`.
1411      * - When `from` is zero, `tokenId` will be minted for `to`.
1412      * - When `to` is zero, `tokenId` will be burned by `from`.
1413      * - `from` and `to` are never both zero.
1414      */
1415     function _beforeTokenTransfers(
1416         address from,
1417         address to,
1418         uint256 startTokenId,
1419         uint256 quantity
1420     ) internal virtual {}
1421 
1422     /**
1423      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1424      * This includes minting.
1425      * And also called after one token has been burned.
1426      *
1427      * startTokenId - the first token id to be transferred
1428      * quantity - the amount to be transferred
1429      *
1430      * Calling conditions:
1431      *
1432      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1433      * transferred to `to`.
1434      * - When `from` is zero, `tokenId` has been minted for `to`.
1435      * - When `to` is zero, `tokenId` has been burned by `from`.
1436      * - `from` and `to` are never both zero.
1437      */
1438     function _afterTokenTransfers(
1439         address from,
1440         address to,
1441         uint256 startTokenId,
1442         uint256 quantity
1443     ) internal virtual {}
1444 
1445     /**
1446      * @dev Returns the message sender (defaults to `msg.sender`).
1447      *
1448      * If you are writing GSN compatible contracts, you need to override this function.
1449      */
1450     function _msgSenderERC721A() internal view virtual returns (address) {
1451         return msg.sender;
1452     }
1453 
1454     /**
1455      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1456      */
1457     function _toString(uint256 value) internal pure returns (string memory ptr) {
1458         assembly {
1459             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1460             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1461             // We will need 1 32-byte word to store the length,
1462             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1463             ptr := add(mload(0x40), 128)
1464             // Update the free memory pointer to allocate.
1465             mstore(0x40, ptr)
1466 
1467             // Cache the end of the memory to calculate the length later.
1468             let end := ptr
1469 
1470             // We write the string from the rightmost digit to the leftmost digit.
1471             // The following is essentially a do-while loop that also handles the zero case.
1472             // Costs a bit more than early returning for the zero case,
1473             // but cheaper in terms of deployment and overall runtime costs.
1474             for {
1475                 // Initialize and perform the first pass without check.
1476                 let temp := value
1477                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1478                 ptr := sub(ptr, 1)
1479                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1480                 mstore8(ptr, add(48, mod(temp, 10)))
1481                 temp := div(temp, 10)
1482             } temp {
1483                 // Keep dividing `temp` until zero.
1484                 temp := div(temp, 10)
1485             } {
1486                 // Body of the for loop.
1487                 ptr := sub(ptr, 1)
1488                 mstore8(ptr, add(48, mod(temp, 10)))
1489             }
1490 
1491             let length := sub(end, ptr)
1492             // Move the pointer 32 bytes leftwards to make room for the length.
1493             ptr := sub(ptr, 32)
1494             // Store the length.
1495             mstore(ptr, length)
1496         }
1497     }
1498 }
1499 
1500 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1501 
1502 
1503 // ERC721A Contracts v4.1.0
1504 // Creator: Chiru Labs
1505 
1506 pragma solidity ^0.8.4;
1507 
1508 
1509 
1510 /**
1511  * @title ERC721A Queryable
1512  * @dev ERC721A subclass with convenience query functions.
1513  */
1514 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1515     /**
1516      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1517      *
1518      * If the `tokenId` is out of bounds:
1519      *   - `addr` = `address(0)`
1520      *   - `startTimestamp` = `0`
1521      *   - `burned` = `false`
1522      *   - `extraData` = `0`
1523      *
1524      * If the `tokenId` is burned:
1525      *   - `addr` = `<Address of owner before token was burned>`
1526      *   - `startTimestamp` = `<Timestamp when token was burned>`
1527      *   - `burned = `true`
1528      *   - `extraData` = `<Extra data when token was burned>`
1529      *
1530      * Otherwise:
1531      *   - `addr` = `<Address of owner>`
1532      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1533      *   - `burned = `false`
1534      *   - `extraData` = `<Extra data at start of ownership>`
1535      */
1536     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1537         TokenOwnership memory ownership;
1538         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1539             return ownership;
1540         }
1541         ownership = _ownershipAt(tokenId);
1542         if (ownership.burned) {
1543             return ownership;
1544         }
1545         return _ownershipOf(tokenId);
1546     }
1547 
1548     /**
1549      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1550      * See {ERC721AQueryable-explicitOwnershipOf}
1551      */
1552     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1553         unchecked {
1554             uint256 tokenIdsLength = tokenIds.length;
1555             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1556             for (uint256 i; i != tokenIdsLength; ++i) {
1557                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1558             }
1559             return ownerships;
1560         }
1561     }
1562 
1563     /**
1564      * @dev Returns an array of token IDs owned by `owner`,
1565      * in the range [`start`, `stop`)
1566      * (i.e. `start <= tokenId < stop`).
1567      *
1568      * This function allows for tokens to be queried if the collection
1569      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1570      *
1571      * Requirements:
1572      *
1573      * - `start` < `stop`
1574      */
1575     function tokensOfOwnerIn(
1576         address owner,
1577         uint256 start,
1578         uint256 stop
1579     ) external view override returns (uint256[] memory) {
1580         unchecked {
1581             if (start >= stop) revert InvalidQueryRange();
1582             uint256 tokenIdsIdx;
1583             uint256 stopLimit = _nextTokenId();
1584             // Set `start = max(start, _startTokenId())`.
1585             if (start < _startTokenId()) {
1586                 start = _startTokenId();
1587             }
1588             // Set `stop = min(stop, stopLimit)`.
1589             if (stop > stopLimit) {
1590                 stop = stopLimit;
1591             }
1592             uint256 tokenIdsMaxLength = balanceOf(owner);
1593             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1594             // to cater for cases where `balanceOf(owner)` is too big.
1595             if (start < stop) {
1596                 uint256 rangeLength = stop - start;
1597                 if (rangeLength < tokenIdsMaxLength) {
1598                     tokenIdsMaxLength = rangeLength;
1599                 }
1600             } else {
1601                 tokenIdsMaxLength = 0;
1602             }
1603             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1604             if (tokenIdsMaxLength == 0) {
1605                 return tokenIds;
1606             }
1607             // We need to call `explicitOwnershipOf(start)`,
1608             // because the slot at `start` may not be initialized.
1609             TokenOwnership memory ownership = explicitOwnershipOf(start);
1610             address currOwnershipAddr;
1611             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1612             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1613             if (!ownership.burned) {
1614                 currOwnershipAddr = ownership.addr;
1615             }
1616             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1617                 ownership = _ownershipAt(i);
1618                 if (ownership.burned) {
1619                     continue;
1620                 }
1621                 if (ownership.addr != address(0)) {
1622                     currOwnershipAddr = ownership.addr;
1623                 }
1624                 if (currOwnershipAddr == owner) {
1625                     tokenIds[tokenIdsIdx++] = i;
1626                 }
1627             }
1628             // Downsize the array to fit.
1629             assembly {
1630                 mstore(tokenIds, tokenIdsIdx)
1631             }
1632             return tokenIds;
1633         }
1634     }
1635 
1636     /**
1637      * @dev Returns an array of token IDs owned by `owner`.
1638      *
1639      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1640      * It is meant to be called off-chain.
1641      *
1642      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1643      * multiple smaller scans if the collection is large enough to cause
1644      * an out-of-gas error (10K pfp collections should be fine).
1645      */
1646     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1647         unchecked {
1648             uint256 tokenIdsIdx;
1649             address currOwnershipAddr;
1650             uint256 tokenIdsLength = balanceOf(owner);
1651             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1652             TokenOwnership memory ownership;
1653             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1654                 ownership = _ownershipAt(i);
1655                 if (ownership.burned) {
1656                     continue;
1657                 }
1658                 if (ownership.addr != address(0)) {
1659                     currOwnershipAddr = ownership.addr;
1660                 }
1661                 if (currOwnershipAddr == owner) {
1662                     tokenIds[tokenIdsIdx++] = i;
1663                 }
1664             }
1665             return tokenIds;
1666         }
1667     }
1668 }
1669 
1670 // File: contracts/Seisdalo.sol
1671 
1672 
1673 
1674 pragma solidity ^0.8.4;
1675 
1676 
1677 
1678 
1679 
1680 contract Seisdalo is ERC721A, ERC721AQueryable, Ownable {
1681 
1682   using Strings for uint256;
1683   
1684   uint256 MAX_SUPPLY = 666;
1685   uint256 MAX_FREE_PER_WALLET = 1;
1686   uint256 MAX_PER_TRANSACTION = 5;
1687   uint256 MINT_PRICE = 0 ether;
1688   uint256 EXTRA_MINT_PRICE = 0.005 ether;
1689 
1690   string tokenBaseUri = "ipfs://bafybeiatgdf2m6xaghjax6nqbp6jvcsytlnolcsj6wn5al3lnqbvudejme/";
1691 
1692   bool public paused = false;
1693 
1694   mapping(address => uint256) private _freeMintedCount;
1695 
1696   constructor() ERC721A("Seisdalo by Dela De Artes", "SD") {}
1697 
1698   function mint(uint256 _quantity) external payable {
1699     unchecked {
1700       require(!paused, "Minting paused");
1701 
1702       uint256 _totalSupply = totalSupply();
1703 
1704       require(_totalSupply + _quantity < MAX_SUPPLY + 1, "No more Seisdela");
1705       require(_quantity < MAX_PER_TRANSACTION + 1, "Max per transaction is 5");
1706       require(tx.origin == msg.sender, "No contracts allowed");
1707 
1708       uint256 payCount = _quantity;
1709       uint256 freeMintCount = _freeMintedCount[msg.sender];
1710 
1711       if (freeMintCount < 1) {
1712         if (_quantity > 1) {
1713           payCount = _quantity - 1;
1714         } else {
1715           payCount = 0;
1716         }
1717 
1718         _freeMintedCount[msg.sender] = 1;
1719       }
1720 
1721       require(
1722         msg.value == payCount * EXTRA_MINT_PRICE,
1723         "INCORRECT ETH AMOUNT"
1724       );
1725 
1726       _mint(msg.sender, _quantity);
1727     }
1728   }
1729 
1730   function freeMintedCount(address owner) external view returns (uint256) {
1731     return _freeMintedCount[owner];
1732   }
1733 
1734   function _startTokenId() internal pure override returns (uint256) {
1735     return 1;
1736   }
1737 
1738   function _baseURI() internal view override returns (string memory) {
1739     return tokenBaseUri;
1740   }
1741 
1742   function setBaseURI(string calldata _newBaseUri) external onlyOwner {
1743     tokenBaseUri = _newBaseUri;
1744   }
1745 
1746   function flipSale() external onlyOwner {
1747     paused = !paused;
1748   }
1749 
1750   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1751     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1752 
1753     string memory currentBaseURI = _baseURI();
1754     return bytes(currentBaseURI).length > 0
1755         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
1756         : '';
1757   }
1758 
1759 
1760   function withdraw() public onlyOwner {
1761     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1762     require(os);
1763   }
1764 }