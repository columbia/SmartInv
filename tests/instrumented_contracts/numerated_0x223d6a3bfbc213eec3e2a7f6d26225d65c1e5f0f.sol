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
180 // ERC721A Contracts v4.0.0
181 // Creator: Chiru Labs
182 
183 pragma solidity ^0.8.4;
184 
185 /**
186  * @dev Interface of an ERC721A compliant contract.
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
205      * The caller cannot approve to the current owner.
206      */
207     error ApprovalToCurrentOwner();
208 
209     /**
210      * Cannot query the balance for the zero address.
211      */
212     error BalanceQueryForZeroAddress();
213 
214     /**
215      * Cannot mint to the zero address.
216      */
217     error MintToZeroAddress();
218 
219     /**
220      * The quantity of tokens minted must be more than zero.
221      */
222     error MintZeroQuantity();
223 
224     /**
225      * The token does not exist.
226      */
227     error OwnerQueryForNonexistentToken();
228 
229     /**
230      * The caller must own the token or be an approved operator.
231      */
232     error TransferCallerNotOwnerNorApproved();
233 
234     /**
235      * The token must be owned by `from`.
236      */
237     error TransferFromIncorrectOwner();
238 
239     /**
240      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
241      */
242     error TransferToNonERC721ReceiverImplementer();
243 
244     /**
245      * Cannot transfer to the zero address.
246      */
247     error TransferToZeroAddress();
248 
249     /**
250      * The token does not exist.
251      */
252     error URIQueryForNonexistentToken();
253 
254     struct TokenOwnership {
255         // The address of the owner.
256         address addr;
257         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
258         uint64 startTimestamp;
259         // Whether the token has been burned.
260         bool burned;
261     }
262 
263     /**
264      * @dev Returns the total amount of tokens stored by the contract.
265      *
266      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
267      */
268     function totalSupply() external view returns (uint256);
269 
270     // ==============================
271     //            IERC165
272     // ==============================
273 
274     /**
275      * @dev Returns true if this contract implements the interface defined by
276      * `interfaceId`. See the corresponding
277      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
278      * to learn more about how these ids are created.
279      *
280      * This function call must use less than 30 000 gas.
281      */
282     function supportsInterface(bytes4 interfaceId) external view returns (bool);
283 
284     // ==============================
285     //            IERC721
286     // ==============================
287 
288     /**
289      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
290      */
291     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
292 
293     /**
294      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
295      */
296     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
297 
298     /**
299      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
300      */
301     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
302 
303     /**
304      * @dev Returns the number of tokens in ``owner``'s account.
305      */
306     function balanceOf(address owner) external view returns (uint256 balance);
307 
308     /**
309      * @dev Returns the owner of the `tokenId` token.
310      *
311      * Requirements:
312      *
313      * - `tokenId` must exist.
314      */
315     function ownerOf(uint256 tokenId) external view returns (address owner);
316 
317     /**
318      * @dev Safely transfers `tokenId` token from `from` to `to`.
319      *
320      * Requirements:
321      *
322      * - `from` cannot be the zero address.
323      * - `to` cannot be the zero address.
324      * - `tokenId` token must exist and be owned by `from`.
325      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
326      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
327      *
328      * Emits a {Transfer} event.
329      */
330     function safeTransferFrom(
331         address from,
332         address to,
333         uint256 tokenId,
334         bytes calldata data
335     ) external;
336 
337     /**
338      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
339      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
340      *
341      * Requirements:
342      *
343      * - `from` cannot be the zero address.
344      * - `to` cannot be the zero address.
345      * - `tokenId` token must exist and be owned by `from`.
346      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
347      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
348      *
349      * Emits a {Transfer} event.
350      */
351     function safeTransferFrom(
352         address from,
353         address to,
354         uint256 tokenId
355     ) external;
356 
357     /**
358      * @dev Transfers `tokenId` token from `from` to `to`.
359      *
360      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
361      *
362      * Requirements:
363      *
364      * - `from` cannot be the zero address.
365      * - `to` cannot be the zero address.
366      * - `tokenId` token must be owned by `from`.
367      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
368      *
369      * Emits a {Transfer} event.
370      */
371     function transferFrom(
372         address from,
373         address to,
374         uint256 tokenId
375     ) external;
376 
377     /**
378      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
379      * The approval is cleared when the token is transferred.
380      *
381      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
382      *
383      * Requirements:
384      *
385      * - The caller must own the token or be an approved operator.
386      * - `tokenId` must exist.
387      *
388      * Emits an {Approval} event.
389      */
390     function approve(address to, uint256 tokenId) external;
391 
392     /**
393      * @dev Approve or remove `operator` as an operator for the caller.
394      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
395      *
396      * Requirements:
397      *
398      * - The `operator` cannot be the caller.
399      *
400      * Emits an {ApprovalForAll} event.
401      */
402     function setApprovalForAll(address operator, bool _approved) external;
403 
404     /**
405      * @dev Returns the account approved for `tokenId` token.
406      *
407      * Requirements:
408      *
409      * - `tokenId` must exist.
410      */
411     function getApproved(uint256 tokenId) external view returns (address operator);
412 
413     /**
414      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
415      *
416      * See {setApprovalForAll}
417      */
418     function isApprovedForAll(address owner, address operator) external view returns (bool);
419 
420     // ==============================
421     //        IERC721Metadata
422     // ==============================
423 
424     /**
425      * @dev Returns the token collection name.
426      */
427     function name() external view returns (string memory);
428 
429     /**
430      * @dev Returns the token collection symbol.
431      */
432     function symbol() external view returns (string memory);
433 
434     /**
435      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
436      */
437     function tokenURI(uint256 tokenId) external view returns (string memory);
438 }
439 
440 // File: erc721a/contracts/ERC721A.sol
441 
442 
443 // ERC721A Contracts v4.0.0
444 // Creator: Chiru Labs
445 
446 pragma solidity ^0.8.4;
447 
448 
449 /**
450  * @dev ERC721 token receiver interface.
451  */
452 interface ERC721A__IERC721Receiver {
453     function onERC721Received(
454         address operator,
455         address from,
456         uint256 tokenId,
457         bytes calldata data
458     ) external returns (bytes4);
459 }
460 
461 /**
462  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
463  * the Metadata extension. Built to optimize for lower gas during batch mints.
464  *
465  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
466  *
467  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
468  *
469  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
470  */
471 contract ERC721A is IERC721A {
472     // Mask of an entry in packed address data.
473     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
474 
475     // The bit position of `numberMinted` in packed address data.
476     uint256 private constant BITPOS_NUMBER_MINTED = 64;
477 
478     // The bit position of `numberBurned` in packed address data.
479     uint256 private constant BITPOS_NUMBER_BURNED = 128;
480 
481     // The bit position of `aux` in packed address data.
482     uint256 private constant BITPOS_AUX = 192;
483 
484     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
485     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
486 
487     // The bit position of `startTimestamp` in packed ownership.
488     uint256 private constant BITPOS_START_TIMESTAMP = 160;
489 
490     // The bit mask of the `burned` bit in packed ownership.
491     uint256 private constant BITMASK_BURNED = 1 << 224;
492     
493     // The bit position of the `nextInitialized` bit in packed ownership.
494     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
495 
496     // The bit mask of the `nextInitialized` bit in packed ownership.
497     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
498 
499     // The tokenId of the next token to be minted.
500     uint256 private _currentIndex;
501 
502     // The number of tokens burned.
503     uint256 private _burnCounter;
504 
505     // Token name
506     string private _name;
507 
508     // Token symbol
509     string private _symbol;
510 
511     // Mapping from token ID to ownership details
512     // An empty struct value does not necessarily mean the token is unowned.
513     // See `_packedOwnershipOf` implementation for details.
514     //
515     // Bits Layout:
516     // - [0..159]   `addr`
517     // - [160..223] `startTimestamp`
518     // - [224]      `burned`
519     // - [225]      `nextInitialized`
520     mapping(uint256 => uint256) private _packedOwnerships;
521 
522     // Mapping owner address to address data.
523     //
524     // Bits Layout:
525     // - [0..63]    `balance`
526     // - [64..127]  `numberMinted`
527     // - [128..191] `numberBurned`
528     // - [192..255] `aux`
529     mapping(address => uint256) private _packedAddressData;
530 
531     // Mapping from token ID to approved address.
532     mapping(uint256 => address) private _tokenApprovals;
533 
534     // Mapping from owner to operator approvals
535     mapping(address => mapping(address => bool)) private _operatorApprovals;
536 
537     constructor(string memory name_, string memory symbol_) {
538         _name = name_;
539         _symbol = symbol_;
540         _currentIndex = _startTokenId();
541     }
542 
543     /**
544      * @dev Returns the starting token ID. 
545      * To change the starting token ID, please override this function.
546      */
547     function _startTokenId() internal view virtual returns (uint256) {
548         return 0;
549     }
550 
551     /**
552      * @dev Returns the next token ID to be minted.
553      */
554     function _nextTokenId() internal view returns (uint256) {
555         return _currentIndex;
556     }
557 
558     /**
559      * @dev Returns the total number of tokens in existence.
560      * Burned tokens will reduce the count. 
561      * To get the total number of tokens minted, please see `_totalMinted`.
562      */
563     function totalSupply() public view override returns (uint256) {
564         // Counter underflow is impossible as _burnCounter cannot be incremented
565         // more than `_currentIndex - _startTokenId()` times.
566         unchecked {
567             return _currentIndex - _burnCounter - _startTokenId();
568         }
569     }
570 
571     /**
572      * @dev Returns the total amount of tokens minted in the contract.
573      */
574     function _totalMinted() internal view returns (uint256) {
575         // Counter underflow is impossible as _currentIndex does not decrement,
576         // and it is initialized to `_startTokenId()`
577         unchecked {
578             return _currentIndex - _startTokenId();
579         }
580     }
581 
582     /**
583      * @dev Returns the total number of tokens burned.
584      */
585     function _totalBurned() internal view returns (uint256) {
586         return _burnCounter;
587     }
588 
589     /**
590      * @dev See {IERC165-supportsInterface}.
591      */
592     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
593         // The interface IDs are constants representing the first 4 bytes of the XOR of
594         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
595         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
596         return
597             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
598             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
599             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
600     }
601 
602     /**
603      * @dev See {IERC721-balanceOf}.
604      */
605     function balanceOf(address owner) public view override returns (uint256) {
606         if (owner == address(0)) revert BalanceQueryForZeroAddress();
607         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
608     }
609 
610     /**
611      * Returns the number of tokens minted by `owner`.
612      */
613     function _numberMinted(address owner) internal view returns (uint256) {
614         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
615     }
616 
617     /**
618      * Returns the number of tokens burned by or on behalf of `owner`.
619      */
620     function _numberBurned(address owner) internal view returns (uint256) {
621         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
622     }
623 
624     /**
625      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
626      */
627     function _getAux(address owner) internal view returns (uint64) {
628         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
629     }
630 
631     /**
632      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
633      * If there are multiple variables, please pack them into a uint64.
634      */
635     function _setAux(address owner, uint64 aux) internal {
636         uint256 packed = _packedAddressData[owner];
637         uint256 auxCasted;
638         assembly { // Cast aux without masking.
639             auxCasted := aux
640         }
641         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
642         _packedAddressData[owner] = packed;
643     }
644 
645     /**
646      * Returns the packed ownership data of `tokenId`.
647      */
648     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
649         uint256 curr = tokenId;
650 
651         unchecked {
652             if (_startTokenId() <= curr)
653                 if (curr < _currentIndex) {
654                     uint256 packed = _packedOwnerships[curr];
655                     // If not burned.
656                     if (packed & BITMASK_BURNED == 0) {
657                         // Invariant:
658                         // There will always be an ownership that has an address and is not burned
659                         // before an ownership that does not have an address and is not burned.
660                         // Hence, curr will not underflow.
661                         //
662                         // We can directly compare the packed value.
663                         // If the address is zero, packed is zero.
664                         while (packed == 0) {
665                             packed = _packedOwnerships[--curr];
666                         }
667                         return packed;
668                     }
669                 }
670         }
671         revert OwnerQueryForNonexistentToken();
672     }
673 
674     /**
675      * Returns the unpacked `TokenOwnership` struct from `packed`.
676      */
677     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
678         ownership.addr = address(uint160(packed));
679         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
680         ownership.burned = packed & BITMASK_BURNED != 0;
681     }
682 
683     /**
684      * Returns the unpacked `TokenOwnership` struct at `index`.
685      */
686     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
687         return _unpackedOwnership(_packedOwnerships[index]);
688     }
689 
690     /**
691      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
692      */
693     function _initializeOwnershipAt(uint256 index) internal {
694         if (_packedOwnerships[index] == 0) {
695             _packedOwnerships[index] = _packedOwnershipOf(index);
696         }
697     }
698 
699     /**
700      * Gas spent here starts off proportional to the maximum mint batch size.
701      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
702      */
703     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
704         return _unpackedOwnership(_packedOwnershipOf(tokenId));
705     }
706 
707     /**
708      * @dev See {IERC721-ownerOf}.
709      */
710     function ownerOf(uint256 tokenId) public view override returns (address) {
711         return address(uint160(_packedOwnershipOf(tokenId)));
712     }
713 
714     /**
715      * @dev See {IERC721Metadata-name}.
716      */
717     function name() public view virtual override returns (string memory) {
718         return _name;
719     }
720 
721     /**
722      * @dev See {IERC721Metadata-symbol}.
723      */
724     function symbol() public view virtual override returns (string memory) {
725         return _symbol;
726     }
727 
728     /**
729      * @dev See {IERC721Metadata-tokenURI}.
730      */
731     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
732         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
733 
734         string memory baseURI = _baseURI();
735         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
736     }
737 
738     /**
739      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
740      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
741      * by default, can be overriden in child contracts.
742      */
743     function _baseURI() internal view virtual returns (string memory) {
744         return '';
745     }
746 
747     /**
748      * @dev Casts the address to uint256 without masking.
749      */
750     function _addressToUint256(address value) private pure returns (uint256 result) {
751         assembly {
752             result := value
753         }
754     }
755 
756     /**
757      * @dev Casts the boolean to uint256 without branching.
758      */
759     function _boolToUint256(bool value) private pure returns (uint256 result) {
760         assembly {
761             result := value
762         }
763     }
764 
765     /**
766      * @dev See {IERC721-approve}.
767      */
768     function approve(address to, uint256 tokenId) public override {
769         address owner = address(uint160(_packedOwnershipOf(tokenId)));
770         if (to == owner) revert ApprovalToCurrentOwner();
771 
772         if (_msgSenderERC721A() != owner)
773             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
774                 revert ApprovalCallerNotOwnerNorApproved();
775             }
776 
777         _tokenApprovals[tokenId] = to;
778         emit Approval(owner, to, tokenId);
779     }
780 
781     /**
782      * @dev See {IERC721-getApproved}.
783      */
784     function getApproved(uint256 tokenId) public view override returns (address) {
785         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
786 
787         return _tokenApprovals[tokenId];
788     }
789 
790     /**
791      * @dev See {IERC721-setApprovalForAll}.
792      */
793     function setApprovalForAll(address operator, bool approved) public virtual override {
794         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
795 
796         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
797         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
798     }
799 
800     /**
801      * @dev See {IERC721-isApprovedForAll}.
802      */
803     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
804         return _operatorApprovals[owner][operator];
805     }
806 
807     /**
808      * @dev See {IERC721-transferFrom}.
809      */
810     function transferFrom(
811         address from,
812         address to,
813         uint256 tokenId
814     ) public virtual override {
815         _transfer(from, to, tokenId);
816     }
817 
818     /**
819      * @dev See {IERC721-safeTransferFrom}.
820      */
821     function safeTransferFrom(
822         address from,
823         address to,
824         uint256 tokenId
825     ) public virtual override {
826         safeTransferFrom(from, to, tokenId, '');
827     }
828 
829     /**
830      * @dev See {IERC721-safeTransferFrom}.
831      */
832     function safeTransferFrom(
833         address from,
834         address to,
835         uint256 tokenId,
836         bytes memory _data
837     ) public virtual override {
838         _transfer(from, to, tokenId);
839         if (to.code.length != 0)
840             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
841                 revert TransferToNonERC721ReceiverImplementer();
842             }
843     }
844 
845     /**
846      * @dev Returns whether `tokenId` exists.
847      *
848      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
849      *
850      * Tokens start existing when they are minted (`_mint`),
851      */
852     function _exists(uint256 tokenId) internal view returns (bool) {
853         return
854             _startTokenId() <= tokenId &&
855             tokenId < _currentIndex && // If within bounds,
856             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
857     }
858 
859     /**
860      * @dev Equivalent to `_safeMint(to, quantity, '')`.
861      */
862     function _safeMint(address to, uint256 quantity) internal {
863         _safeMint(to, quantity, '');
864     }
865 
866     /**
867      * @dev Safely mints `quantity` tokens and transfers them to `to`.
868      *
869      * Requirements:
870      *
871      * - If `to` refers to a smart contract, it must implement
872      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
873      * - `quantity` must be greater than 0.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _safeMint(
878         address to,
879         uint256 quantity,
880         bytes memory _data
881     ) internal {
882         uint256 startTokenId = _currentIndex;
883         if (to == address(0)) revert MintToZeroAddress();
884         if (quantity == 0) revert MintZeroQuantity();
885 
886         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
887 
888         // Overflows are incredibly unrealistic.
889         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
890         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
891         unchecked {
892             // Updates:
893             // - `balance += quantity`.
894             // - `numberMinted += quantity`.
895             //
896             // We can directly add to the balance and number minted.
897             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
898 
899             // Updates:
900             // - `address` to the owner.
901             // - `startTimestamp` to the timestamp of minting.
902             // - `burned` to `false`.
903             // - `nextInitialized` to `quantity == 1`.
904             _packedOwnerships[startTokenId] =
905                 _addressToUint256(to) |
906                 (block.timestamp << BITPOS_START_TIMESTAMP) |
907                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
908 
909             uint256 updatedIndex = startTokenId;
910             uint256 end = updatedIndex + quantity;
911 
912             if (to.code.length != 0) {
913                 do {
914                     emit Transfer(address(0), to, updatedIndex);
915                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
916                         revert TransferToNonERC721ReceiverImplementer();
917                     }
918                 } while (updatedIndex < end);
919                 // Reentrancy protection
920                 if (_currentIndex != startTokenId) revert();
921             } else {
922                 do {
923                     emit Transfer(address(0), to, updatedIndex++);
924                 } while (updatedIndex < end);
925             }
926             _currentIndex = updatedIndex;
927         }
928         _afterTokenTransfers(address(0), to, startTokenId, quantity);
929     }
930 
931     /**
932      * @dev Mints `quantity` tokens and transfers them to `to`.
933      *
934      * Requirements:
935      *
936      * - `to` cannot be the zero address.
937      * - `quantity` must be greater than 0.
938      *
939      * Emits a {Transfer} event.
940      */
941     function _mint(address to, uint256 quantity) internal {
942         uint256 startTokenId = _currentIndex;
943         if (to == address(0)) revert MintToZeroAddress();
944         if (quantity == 0) revert MintZeroQuantity();
945 
946         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
947 
948         // Overflows are incredibly unrealistic.
949         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
950         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
951         unchecked {
952             // Updates:
953             // - `balance += quantity`.
954             // - `numberMinted += quantity`.
955             //
956             // We can directly add to the balance and number minted.
957             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
958 
959             // Updates:
960             // - `address` to the owner.
961             // - `startTimestamp` to the timestamp of minting.
962             // - `burned` to `false`.
963             // - `nextInitialized` to `quantity == 1`.
964             _packedOwnerships[startTokenId] =
965                 _addressToUint256(to) |
966                 (block.timestamp << BITPOS_START_TIMESTAMP) |
967                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
968 
969             uint256 updatedIndex = startTokenId;
970             uint256 end = updatedIndex + quantity;
971 
972             do {
973                 emit Transfer(address(0), to, updatedIndex++);
974             } while (updatedIndex < end);
975 
976             _currentIndex = updatedIndex;
977         }
978         _afterTokenTransfers(address(0), to, startTokenId, quantity);
979     }
980 
981     /**
982      * @dev Transfers `tokenId` from `from` to `to`.
983      *
984      * Requirements:
985      *
986      * - `to` cannot be the zero address.
987      * - `tokenId` token must be owned by `from`.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _transfer(
992         address from,
993         address to,
994         uint256 tokenId
995     ) private {
996         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
997 
998         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
999 
1000         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1001             isApprovedForAll(from, _msgSenderERC721A()) ||
1002             getApproved(tokenId) == _msgSenderERC721A());
1003 
1004         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1005         if (to == address(0)) revert TransferToZeroAddress();
1006 
1007         _beforeTokenTransfers(from, to, tokenId, 1);
1008 
1009         // Clear approvals from the previous owner.
1010         delete _tokenApprovals[tokenId];
1011 
1012         // Underflow of the sender's balance is impossible because we check for
1013         // ownership above and the recipient's balance can't realistically overflow.
1014         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1015         unchecked {
1016             // We can directly increment and decrement the balances.
1017             --_packedAddressData[from]; // Updates: `balance -= 1`.
1018             ++_packedAddressData[to]; // Updates: `balance += 1`.
1019 
1020             // Updates:
1021             // - `address` to the next owner.
1022             // - `startTimestamp` to the timestamp of transfering.
1023             // - `burned` to `false`.
1024             // - `nextInitialized` to `true`.
1025             _packedOwnerships[tokenId] =
1026                 _addressToUint256(to) |
1027                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1028                 BITMASK_NEXT_INITIALIZED;
1029 
1030             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1031             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1032                 uint256 nextTokenId = tokenId + 1;
1033                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1034                 if (_packedOwnerships[nextTokenId] == 0) {
1035                     // If the next slot is within bounds.
1036                     if (nextTokenId != _currentIndex) {
1037                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1038                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1039                     }
1040                 }
1041             }
1042         }
1043 
1044         emit Transfer(from, to, tokenId);
1045         _afterTokenTransfers(from, to, tokenId, 1);
1046     }
1047 
1048     /**
1049      * @dev Equivalent to `_burn(tokenId, false)`.
1050      */
1051     function _burn(uint256 tokenId) internal virtual {
1052         _burn(tokenId, false);
1053     }
1054 
1055     /**
1056      * @dev Destroys `tokenId`.
1057      * The approval is cleared when the token is burned.
1058      *
1059      * Requirements:
1060      *
1061      * - `tokenId` must exist.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1066         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1067 
1068         address from = address(uint160(prevOwnershipPacked));
1069 
1070         if (approvalCheck) {
1071             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1072                 isApprovedForAll(from, _msgSenderERC721A()) ||
1073                 getApproved(tokenId) == _msgSenderERC721A());
1074 
1075             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1076         }
1077 
1078         _beforeTokenTransfers(from, address(0), tokenId, 1);
1079 
1080         // Clear approvals from the previous owner.
1081         delete _tokenApprovals[tokenId];
1082 
1083         // Underflow of the sender's balance is impossible because we check for
1084         // ownership above and the recipient's balance can't realistically overflow.
1085         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1086         unchecked {
1087             // Updates:
1088             // - `balance -= 1`.
1089             // - `numberBurned += 1`.
1090             //
1091             // We can directly decrement the balance, and increment the number burned.
1092             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1093             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1094 
1095             // Updates:
1096             // - `address` to the last owner.
1097             // - `startTimestamp` to the timestamp of burning.
1098             // - `burned` to `true`.
1099             // - `nextInitialized` to `true`.
1100             _packedOwnerships[tokenId] =
1101                 _addressToUint256(from) |
1102                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1103                 BITMASK_BURNED | 
1104                 BITMASK_NEXT_INITIALIZED;
1105 
1106             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1107             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1108                 uint256 nextTokenId = tokenId + 1;
1109                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1110                 if (_packedOwnerships[nextTokenId] == 0) {
1111                     // If the next slot is within bounds.
1112                     if (nextTokenId != _currentIndex) {
1113                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1114                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1115                     }
1116                 }
1117             }
1118         }
1119 
1120         emit Transfer(from, address(0), tokenId);
1121         _afterTokenTransfers(from, address(0), tokenId, 1);
1122 
1123         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1124         unchecked {
1125             _burnCounter++;
1126         }
1127     }
1128 
1129     /**
1130      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1131      *
1132      * @param from address representing the previous owner of the given token ID
1133      * @param to target address that will receive the tokens
1134      * @param tokenId uint256 ID of the token to be transferred
1135      * @param _data bytes optional data to send along with the call
1136      * @return bool whether the call correctly returned the expected magic value
1137      */
1138     function _checkContractOnERC721Received(
1139         address from,
1140         address to,
1141         uint256 tokenId,
1142         bytes memory _data
1143     ) private returns (bool) {
1144         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1145             bytes4 retval
1146         ) {
1147             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1148         } catch (bytes memory reason) {
1149             if (reason.length == 0) {
1150                 revert TransferToNonERC721ReceiverImplementer();
1151             } else {
1152                 assembly {
1153                     revert(add(32, reason), mload(reason))
1154                 }
1155             }
1156         }
1157     }
1158 
1159     /**
1160      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1161      * And also called before burning one token.
1162      *
1163      * startTokenId - the first token id to be transferred
1164      * quantity - the amount to be transferred
1165      *
1166      * Calling conditions:
1167      *
1168      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1169      * transferred to `to`.
1170      * - When `from` is zero, `tokenId` will be minted for `to`.
1171      * - When `to` is zero, `tokenId` will be burned by `from`.
1172      * - `from` and `to` are never both zero.
1173      */
1174     function _beforeTokenTransfers(
1175         address from,
1176         address to,
1177         uint256 startTokenId,
1178         uint256 quantity
1179     ) internal virtual {}
1180 
1181     /**
1182      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1183      * minting.
1184      * And also called after one token has been burned.
1185      *
1186      * startTokenId - the first token id to be transferred
1187      * quantity - the amount to be transferred
1188      *
1189      * Calling conditions:
1190      *
1191      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1192      * transferred to `to`.
1193      * - When `from` is zero, `tokenId` has been minted for `to`.
1194      * - When `to` is zero, `tokenId` has been burned by `from`.
1195      * - `from` and `to` are never both zero.
1196      */
1197     function _afterTokenTransfers(
1198         address from,
1199         address to,
1200         uint256 startTokenId,
1201         uint256 quantity
1202     ) internal virtual {}
1203 
1204     /**
1205      * @dev Returns the message sender (defaults to `msg.sender`).
1206      *
1207      * If you are writing GSN compatible contracts, you need to override this function.
1208      */
1209     function _msgSenderERC721A() internal view virtual returns (address) {
1210         return msg.sender;
1211     }
1212 
1213     /**
1214      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1215      */
1216     function _toString(uint256 value) internal pure returns (string memory ptr) {
1217         assembly {
1218             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1219             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1220             // We will need 1 32-byte word to store the length, 
1221             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1222             ptr := add(mload(0x40), 128)
1223             // Update the free memory pointer to allocate.
1224             mstore(0x40, ptr)
1225 
1226             // Cache the end of the memory to calculate the length later.
1227             let end := ptr
1228 
1229             // We write the string from the rightmost digit to the leftmost digit.
1230             // The following is essentially a do-while loop that also handles the zero case.
1231             // Costs a bit more than early returning for the zero case,
1232             // but cheaper in terms of deployment and overall runtime costs.
1233             for { 
1234                 // Initialize and perform the first pass without check.
1235                 let temp := value
1236                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1237                 ptr := sub(ptr, 1)
1238                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1239                 mstore8(ptr, add(48, mod(temp, 10)))
1240                 temp := div(temp, 10)
1241             } temp { 
1242                 // Keep dividing `temp` until zero.
1243                 temp := div(temp, 10)
1244             } { // Body of the for loop.
1245                 ptr := sub(ptr, 1)
1246                 mstore8(ptr, add(48, mod(temp, 10)))
1247             }
1248             
1249             let length := sub(end, ptr)
1250             // Move the pointer 32 bytes leftwards to make room for the length.
1251             ptr := sub(ptr, 32)
1252             // Store the length.
1253             mstore(ptr, length)
1254         }
1255     }
1256 }
1257 
1258 // File: contracts/TinyChimps.sol
1259 
1260 
1261 
1262 pragma solidity ^0.8.13;
1263 
1264 
1265 
1266 
1267 contract TinyChimps is ERC721A, Ownable {
1268 
1269   using Strings for uint256;
1270 
1271     /* ERRORS */
1272   error ExceedsMaxSupply();
1273   error ExceedsFreeSupply();
1274   error InvalidQuantity();
1275   error FreeMintOver();
1276   error ExceedsWalletLimit();
1277   error InvalidValue();
1278   error TokenNotFound();
1279   error ContractMint();
1280   error SaleInactive();
1281 
1282   uint256 public price = 5000000000000000;
1283   uint256 public maxSupply = 5000;
1284   uint256 public maxMintPerTx = 10;
1285   uint256 public maxFreeMintPerWallet = 5;
1286   uint256 public freeMintSupply = 1000;
1287 
1288   bool public isSaleActive = false;
1289 
1290   string internal baseURI_ = "ipfs://QmWhPirkfh7qBTejG6gTdo8wzc4fGScVFBqtF9Tsnqwxif/";
1291 
1292   mapping(address => uint256) public freeWalletBalance;
1293 
1294   constructor() ERC721A('Tiny Chimps', 'TinyChimps') payable {}
1295 
1296   modifier mintCompliance(uint256 quantity_) {
1297       if (!isSaleActive) revert SaleInactive();
1298       if (msg.sender != tx.origin) revert ContractMint();
1299       unchecked {
1300           if (totalSupply() + quantity_ > maxSupply) revert ExceedsMaxSupply();
1301           if (quantity_ > maxMintPerTx) revert InvalidQuantity();
1302         }
1303       _;
1304     }
1305 
1306   function freeMint(uint256 quantity_) external mintCompliance(quantity_) {
1307       unchecked {
1308           if (totalSupply() + quantity_ > freeMintSupply) revert ExceedsFreeSupply();
1309           if (freeWalletBalance[msg.sender] + quantity_ > maxFreeMintPerWallet) revert ExceedsWalletLimit();
1310           freeWalletBalance[msg.sender] += quantity_;
1311         }
1312         _mint(msg.sender, quantity_);
1313     } 
1314 
1315   function mint(uint256 quantity_) external payable mintCompliance(quantity_) {
1316       unchecked {
1317           if (totalSupply() + quantity_ > maxSupply) revert ExceedsMaxSupply();
1318           if (quantity_ > maxMintPerTx) revert InvalidQuantity();
1319           if (msg.value != (quantity_ * price)) revert InvalidValue();
1320         }
1321         _mint(msg.sender, quantity_);
1322     }
1323 
1324   function _startTokenId() internal pure override returns (uint256) {
1325       return 1;
1326     }
1327 
1328   function setPrice(uint256 price_) external onlyOwner {
1329       price = price_;
1330     }
1331 
1332   function toggleSales() external onlyOwner {
1333       isSaleActive = !isSaleActive;
1334     }
1335 
1336   function tokenURI(uint256 tokenId_) public view override returns (string memory) {
1337       if (!_exists(tokenId_)) revert TokenNotFound();
1338       return string(abi.encodePacked(baseURI_, tokenId_.toString(), '.json'));
1339     }
1340 
1341   function withdraw() external onlyOwner {
1342       payable(owner()).transfer(address(this).balance);
1343   }
1344 }