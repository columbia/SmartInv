1 // File: @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library StringsUpgradeable {
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
176 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
177 
178 
179 // ERC721A Contracts v4.0.0
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
204      * The caller cannot approve to the current owner.
205      */
206     error ApprovalToCurrentOwner();
207 
208     /**
209      * Cannot query the balance for the zero address.
210      */
211     error BalanceQueryForZeroAddress();
212 
213     /**
214      * Cannot mint to the zero address.
215      */
216     error MintToZeroAddress();
217 
218     /**
219      * The quantity of tokens minted must be more than zero.
220      */
221     error MintZeroQuantity();
222 
223     /**
224      * The token does not exist.
225      */
226     error OwnerQueryForNonexistentToken();
227 
228     /**
229      * The caller must own the token or be an approved operator.
230      */
231     error TransferCallerNotOwnerNorApproved();
232 
233     /**
234      * The token must be owned by `from`.
235      */
236     error TransferFromIncorrectOwner();
237 
238     /**
239      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
240      */
241     error TransferToNonERC721ReceiverImplementer();
242 
243     /**
244      * Cannot transfer to the zero address.
245      */
246     error TransferToZeroAddress();
247 
248     /**
249      * The token does not exist.
250      */
251     error URIQueryForNonexistentToken();
252 
253     struct TokenOwnership {
254         // The address of the owner.
255         address addr;
256         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
257         uint64 startTimestamp;
258         // Whether the token has been burned.
259         bool burned;
260     }
261 
262     /**
263      * @dev Returns the total amount of tokens stored by the contract.
264      *
265      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
266      */
267     function totalSupply() external view returns (uint256);
268 
269     // ==============================
270     //            IERC165
271     // ==============================
272 
273     /**
274      * @dev Returns true if this contract implements the interface defined by
275      * `interfaceId`. See the corresponding
276      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
277      * to learn more about how these ids are created.
278      *
279      * This function call must use less than 30 000 gas.
280      */
281     function supportsInterface(bytes4 interfaceId) external view returns (bool);
282 
283     // ==============================
284     //            IERC721
285     // ==============================
286 
287     /**
288      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
289      */
290     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
291 
292     /**
293      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
294      */
295     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
296 
297     /**
298      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
299      */
300     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
301 
302     /**
303      * @dev Returns the number of tokens in ``owner``'s account.
304      */
305     function balanceOf(address owner) external view returns (uint256 balance);
306 
307     /**
308      * @dev Returns the owner of the `tokenId` token.
309      *
310      * Requirements:
311      *
312      * - `tokenId` must exist.
313      */
314     function ownerOf(uint256 tokenId) external view returns (address owner);
315 
316     /**
317      * @dev Safely transfers `tokenId` token from `from` to `to`.
318      *
319      * Requirements:
320      *
321      * - `from` cannot be the zero address.
322      * - `to` cannot be the zero address.
323      * - `tokenId` token must exist and be owned by `from`.
324      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
325      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
326      *
327      * Emits a {Transfer} event.
328      */
329     function safeTransferFrom(
330         address from,
331         address to,
332         uint256 tokenId,
333         bytes calldata data
334     ) external;
335 
336     /**
337      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
338      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
339      *
340      * Requirements:
341      *
342      * - `from` cannot be the zero address.
343      * - `to` cannot be the zero address.
344      * - `tokenId` token must exist and be owned by `from`.
345      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
346      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
347      *
348      * Emits a {Transfer} event.
349      */
350     function safeTransferFrom(
351         address from,
352         address to,
353         uint256 tokenId
354     ) external;
355 
356     /**
357      * @dev Transfers `tokenId` token from `from` to `to`.
358      *
359      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
360      *
361      * Requirements:
362      *
363      * - `from` cannot be the zero address.
364      * - `to` cannot be the zero address.
365      * - `tokenId` token must be owned by `from`.
366      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
367      *
368      * Emits a {Transfer} event.
369      */
370     function transferFrom(
371         address from,
372         address to,
373         uint256 tokenId
374     ) external;
375 
376     /**
377      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
378      * The approval is cleared when the token is transferred.
379      *
380      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
381      *
382      * Requirements:
383      *
384      * - The caller must own the token or be an approved operator.
385      * - `tokenId` must exist.
386      *
387      * Emits an {Approval} event.
388      */
389     function approve(address to, uint256 tokenId) external;
390 
391     /**
392      * @dev Approve or remove `operator` as an operator for the caller.
393      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
394      *
395      * Requirements:
396      *
397      * - The `operator` cannot be the caller.
398      *
399      * Emits an {ApprovalForAll} event.
400      */
401     function setApprovalForAll(address operator, bool _approved) external;
402 
403     /**
404      * @dev Returns the account approved for `tokenId` token.
405      *
406      * Requirements:
407      *
408      * - `tokenId` must exist.
409      */
410     function getApproved(uint256 tokenId) external view returns (address operator);
411 
412     /**
413      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
414      *
415      * See {setApprovalForAll}
416      */
417     function isApprovedForAll(address owner, address operator) external view returns (bool);
418 
419     // ==============================
420     //        IERC721Metadata
421     // ==============================
422 
423     /**
424      * @dev Returns the token collection name.
425      */
426     function name() external view returns (string memory);
427 
428     /**
429      * @dev Returns the token collection symbol.
430      */
431     function symbol() external view returns (string memory);
432 
433     /**
434      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
435      */
436     function tokenURI(uint256 tokenId) external view returns (string memory);
437 }
438 
439 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
440 
441 
442 // ERC721A Contracts v4.0.0
443 // Creator: Chiru Labs
444 
445 pragma solidity ^0.8.4;
446 
447 
448 /**
449  * @dev ERC721 token receiver interface.
450  */
451 interface ERC721A__IERC721Receiver {
452     function onERC721Received(
453         address operator,
454         address from,
455         uint256 tokenId,
456         bytes calldata data
457     ) external returns (bytes4);
458 }
459 
460 /**
461  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
462  * the Metadata extension. Built to optimize for lower gas during batch mints.
463  *
464  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
465  *
466  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
467  *
468  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
469  */
470 contract ERC721A is IERC721A {
471     // Mask of an entry in packed address data.
472     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
473 
474     // The bit position of `numberMinted` in packed address data.
475     uint256 private constant BITPOS_NUMBER_MINTED = 64;
476 
477     // The bit position of `numberBurned` in packed address data.
478     uint256 private constant BITPOS_NUMBER_BURNED = 128;
479 
480     // The bit position of `aux` in packed address data.
481     uint256 private constant BITPOS_AUX = 192;
482 
483     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
484     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
485 
486     // The bit position of `startTimestamp` in packed ownership.
487     uint256 private constant BITPOS_START_TIMESTAMP = 160;
488 
489     // The bit mask of the `burned` bit in packed ownership.
490     uint256 private constant BITMASK_BURNED = 1 << 224;
491 
492     // The bit position of the `nextInitialized` bit in packed ownership.
493     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
494 
495     // The bit mask of the `nextInitialized` bit in packed ownership.
496     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
497 
498     // The tokenId of the next token to be minted.
499     uint256 private _currentIndex;
500 
501     // The number of tokens burned.
502     uint256 private _burnCounter;
503 
504     // Token name
505     string private _name;
506 
507     // Token symbol
508     string private _symbol;
509 
510     // Mapping from token ID to ownership details
511     // An empty struct value does not necessarily mean the token is unowned.
512     // See `_packedOwnershipOf` implementation for details.
513     //
514     // Bits Layout:
515     // - [0..159]   `addr`
516     // - [160..223] `startTimestamp`
517     // - [224]      `burned`
518     // - [225]      `nextInitialized`
519     mapping(uint256 => uint256) private _packedOwnerships;
520 
521     // Mapping owner address to address data.
522     //
523     // Bits Layout:
524     // - [0..63]    `balance`
525     // - [64..127]  `numberMinted`
526     // - [128..191] `numberBurned`
527     // - [192..255] `aux`
528     mapping(address => uint256) private _packedAddressData;
529 
530     // Mapping from token ID to approved address.
531     mapping(uint256 => address) private _tokenApprovals;
532 
533     // Mapping from owner to operator approvals
534     mapping(address => mapping(address => bool)) private _operatorApprovals;
535 
536     constructor(string memory name_, string memory symbol_) {
537         _name = name_;
538         _symbol = symbol_;
539         _currentIndex = _startTokenId();
540     }
541 
542     /**
543      * @dev Returns the starting token ID.
544      * To change the starting token ID, please override this function.
545      */
546     function _startTokenId() internal view virtual returns (uint256) {
547         return 0;
548     }
549 
550     /**
551      * @dev Returns the next token ID to be minted.
552      */
553     function _nextTokenId() internal view returns (uint256) {
554         return _currentIndex;
555     }
556 
557     /**
558      * @dev Returns the total number of tokens in existence.
559      * Burned tokens will reduce the count.
560      * To get the total number of tokens minted, please see `_totalMinted`.
561      */
562     function totalSupply() public view override returns (uint256) {
563         // Counter underflow is impossible as _burnCounter cannot be incremented
564         // more than `_currentIndex - _startTokenId()` times.
565         unchecked {
566             return _currentIndex - _burnCounter - _startTokenId();
567         }
568     }
569 
570     /**
571      * @dev Returns the total amount of tokens minted in the contract.
572      */
573     function _totalMinted() internal view returns (uint256) {
574         // Counter underflow is impossible as _currentIndex does not decrement,
575         // and it is initialized to `_startTokenId()`
576         unchecked {
577             return _currentIndex - _startTokenId();
578         }
579     }
580 
581     /**
582      * @dev Returns the total number of tokens burned.
583      */
584     function _totalBurned() internal view returns (uint256) {
585         return _burnCounter;
586     }
587 
588     /**
589      * @dev See {IERC165-supportsInterface}.
590      */
591     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
592         // The interface IDs are constants representing the first 4 bytes of the XOR of
593         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
594         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
595         return
596             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
597             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
598             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
599     }
600 
601     /**
602      * @dev See {IERC721-balanceOf}.
603      */
604     function balanceOf(address owner) public view override returns (uint256) {
605         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
606         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
607     }
608 
609     /**
610      * Returns the number of tokens minted by `owner`.
611      */
612     function _numberMinted(address owner) internal view returns (uint256) {
613         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
614     }
615 
616     /**
617      * Returns the number of tokens burned by or on behalf of `owner`.
618      */
619     function _numberBurned(address owner) internal view returns (uint256) {
620         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
621     }
622 
623     /**
624      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
625      */
626     function _getAux(address owner) internal view returns (uint64) {
627         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
628     }
629 
630     /**
631      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
632      * If there are multiple variables, please pack them into a uint64.
633      */
634     function _setAux(address owner, uint64 aux) internal {
635         uint256 packed = _packedAddressData[owner];
636         uint256 auxCasted;
637         assembly { // Cast aux without masking.
638             auxCasted := aux
639         }
640         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
641         _packedAddressData[owner] = packed;
642     }
643 
644     /**
645      * Returns the packed ownership data of `tokenId`.
646      */
647     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
648         uint256 curr = tokenId;
649 
650         unchecked {
651             if (_startTokenId() <= curr)
652                 if (curr < _currentIndex) {
653                     uint256 packed = _packedOwnerships[curr];
654                     // If not burned.
655                     if (packed & BITMASK_BURNED == 0) {
656                         // Invariant:
657                         // There will always be an ownership that has an address and is not burned
658                         // before an ownership that does not have an address and is not burned.
659                         // Hence, curr will not underflow.
660                         //
661                         // We can directly compare the packed value.
662                         // If the address is zero, packed is zero.
663                         while (packed == 0) {
664                             packed = _packedOwnerships[--curr];
665                         }
666                         return packed;
667                     }
668                 }
669         }
670         revert OwnerQueryForNonexistentToken();
671     }
672 
673     /**
674      * Returns the unpacked `TokenOwnership` struct from `packed`.
675      */
676     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
677         ownership.addr = address(uint160(packed));
678         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
679         ownership.burned = packed & BITMASK_BURNED != 0;
680     }
681 
682     /**
683      * Returns the unpacked `TokenOwnership` struct at `index`.
684      */
685     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
686         return _unpackedOwnership(_packedOwnerships[index]);
687     }
688 
689     /**
690      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
691      */
692     function _initializeOwnershipAt(uint256 index) internal {
693         if (_packedOwnerships[index] == 0) {
694             _packedOwnerships[index] = _packedOwnershipOf(index);
695         }
696     }
697 
698     /**
699      * Gas spent here starts off proportional to the maximum mint batch size.
700      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
701      */
702     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
703         return _unpackedOwnership(_packedOwnershipOf(tokenId));
704     }
705 
706     /**
707      * @dev See {IERC721-ownerOf}.
708      */
709     function ownerOf(uint256 tokenId) public view override returns (address) {
710         return address(uint160(_packedOwnershipOf(tokenId)));
711     }
712 
713     /**
714      * @dev See {IERC721Metadata-name}.
715      */
716     function name() public view virtual override returns (string memory) {
717         return _name;
718     }
719 
720     /**
721      * @dev See {IERC721Metadata-symbol}.
722      */
723     function symbol() public view virtual override returns (string memory) {
724         return _symbol;
725     }
726 
727     /**
728      * @dev See {IERC721Metadata-tokenURI}.
729      */
730     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
731         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
732 
733         string memory baseURI = _baseURI();
734         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
735     }
736 
737     /**
738      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
739      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
740      * by default, can be overriden in child contracts.
741      */
742     function _baseURI() internal view virtual returns (string memory) {
743         return '';
744     }
745 
746     /**
747      * @dev Casts the address to uint256 without masking.
748      */
749     function _addressToUint256(address value) private pure returns (uint256 result) {
750         assembly {
751             result := value
752         }
753     }
754 
755     /**
756      * @dev Casts the boolean to uint256 without branching.
757      */
758     function _boolToUint256(bool value) private pure returns (uint256 result) {
759         assembly {
760             result := value
761         }
762     }
763 
764     /**
765      * @dev See {IERC721-approve}.
766      */
767     function approve(address to, uint256 tokenId) public override {
768         address owner = address(uint160(_packedOwnershipOf(tokenId)));
769         if (to == owner) revert ApprovalToCurrentOwner();
770 
771         if (_msgSenderERC721A() != owner)
772             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
773                 revert ApprovalCallerNotOwnerNorApproved();
774             }
775 
776         _tokenApprovals[tokenId] = to;
777         emit Approval(owner, to, tokenId);
778     }
779 
780     /**
781      * @dev See {IERC721-getApproved}.
782      */
783     function getApproved(uint256 tokenId) public view override returns (address) {
784         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
785 
786         return _tokenApprovals[tokenId];
787     }
788 
789     /**
790      * @dev See {IERC721-setApprovalForAll}.
791      */
792     function setApprovalForAll(address operator, bool approved) public virtual override {
793         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
794 
795         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
796         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
797     }
798 
799     /**
800      * @dev See {IERC721-isApprovedForAll}.
801      */
802     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
803         return _operatorApprovals[owner][operator];
804     }
805 
806     /**
807      * @dev See {IERC721-transferFrom}.
808      */
809     function transferFrom(
810         address from,
811         address to,
812         uint256 tokenId
813     ) public virtual override {
814         _transfer(from, to, tokenId);
815     }
816 
817     /**
818      * @dev See {IERC721-safeTransferFrom}.
819      */
820     function safeTransferFrom(
821         address from,
822         address to,
823         uint256 tokenId
824     ) public virtual override {
825         safeTransferFrom(from, to, tokenId, '');
826     }
827 
828     /**
829      * @dev See {IERC721-safeTransferFrom}.
830      */
831     function safeTransferFrom(
832         address from,
833         address to,
834         uint256 tokenId,
835         bytes memory _data
836     ) public virtual override {
837         _transfer(from, to, tokenId);
838         if (to.code.length != 0)
839             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
840                 revert TransferToNonERC721ReceiverImplementer();
841             }
842     }
843 
844     /**
845      * @dev Returns whether `tokenId` exists.
846      *
847      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
848      *
849      * Tokens start existing when they are minted (`_mint`),
850      */
851     function _exists(uint256 tokenId) internal view returns (bool) {
852         return
853             _startTokenId() <= tokenId &&
854             tokenId < _currentIndex && // If within bounds,
855             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
856     }
857 
858     /**
859      * @dev Equivalent to `_safeMint(to, quantity, '')`.
860      */
861     function _safeMint(address to, uint256 quantity) internal {
862         _safeMint(to, quantity, '');
863     }
864 
865     /**
866      * @dev Safely mints `quantity` tokens and transfers them to `to`.
867      *
868      * Requirements:
869      *
870      * - If `to` refers to a smart contract, it must implement
871      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
872      * - `quantity` must be greater than 0.
873      *
874      * Emits a {Transfer} event.
875      */
876     function _safeMint(
877         address to,
878         uint256 quantity,
879         bytes memory _data
880     ) internal {
881         uint256 startTokenId = _currentIndex;
882         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
883         if (quantity == 0) revert MintZeroQuantity();
884 
885         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
886 
887         // Overflows are incredibly unrealistic.
888         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
889         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
890         unchecked {
891             // Updates:
892             // - `balance += quantity`.
893             // - `numberMinted += quantity`.
894             //
895             // We can directly add to the balance and number minted.
896             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
897 
898             // Updates:
899             // - `address` to the owner.
900             // - `startTimestamp` to the timestamp of minting.
901             // - `burned` to `false`.
902             // - `nextInitialized` to `quantity == 1`.
903             _packedOwnerships[startTokenId] =
904                 _addressToUint256(to) |
905                 (block.timestamp << BITPOS_START_TIMESTAMP) |
906                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
907 
908             uint256 updatedIndex = startTokenId;
909             uint256 end = updatedIndex + quantity;
910 
911             if (to.code.length != 0) {
912                 do {
913                     emit Transfer(address(0), to, updatedIndex);
914                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
915                         revert TransferToNonERC721ReceiverImplementer();
916                     }
917                 } while (updatedIndex < end);
918                 // Reentrancy protection
919                 if (_currentIndex != startTokenId) revert();
920             } else {
921                 do {
922                     emit Transfer(address(0), to, updatedIndex++);
923                 } while (updatedIndex < end);
924             }
925             _currentIndex = updatedIndex;
926         }
927         _afterTokenTransfers(address(0), to, startTokenId, quantity);
928     }
929 
930     /**
931      * @dev Mints `quantity` tokens and transfers them to `to`.
932      *
933      * Requirements:
934      *
935      * - `to` cannot be the zero address.
936      * - `quantity` must be greater than 0.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _mint(address to, uint256 quantity) internal {
941         uint256 startTokenId = _currentIndex;
942         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
943         if (quantity == 0) revert MintZeroQuantity();
944 
945         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
946 
947         // Overflows are incredibly unrealistic.
948         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
949         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
950         unchecked {
951             // Updates:
952             // - `balance += quantity`.
953             // - `numberMinted += quantity`.
954             //
955             // We can directly add to the balance and number minted.
956             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
957 
958             // Updates:
959             // - `address` to the owner.
960             // - `startTimestamp` to the timestamp of minting.
961             // - `burned` to `false`.
962             // - `nextInitialized` to `quantity == 1`.
963             _packedOwnerships[startTokenId] =
964                 _addressToUint256(to) |
965                 (block.timestamp << BITPOS_START_TIMESTAMP) |
966                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
967 
968             uint256 updatedIndex = startTokenId;
969             uint256 end = updatedIndex + quantity;
970 
971             do {
972                 emit Transfer(address(0), to, updatedIndex++);
973             } while (updatedIndex < end);
974 
975             _currentIndex = updatedIndex;
976         }
977         _afterTokenTransfers(address(0), to, startTokenId, quantity);
978     }
979 
980     /**
981      * @dev Transfers `tokenId` from `from` to `to`.
982      *
983      * Requirements:
984      *
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must be owned by `from`.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _transfer(
991         address from,
992         address to,
993         uint256 tokenId
994     ) private {
995         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
996 
997         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
998 
999         address approvedAddress = _tokenApprovals[tokenId];
1000 
1001         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1002             isApprovedForAll(from, _msgSenderERC721A()) ||
1003             approvedAddress == _msgSenderERC721A());
1004 
1005         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1006         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1007 
1008         _beforeTokenTransfers(from, to, tokenId, 1);
1009 
1010         // Clear approvals from the previous owner.
1011         if (_addressToUint256(approvedAddress) != 0) {
1012             delete _tokenApprovals[tokenId];
1013         }
1014 
1015         // Underflow of the sender's balance is impossible because we check for
1016         // ownership above and the recipient's balance can't realistically overflow.
1017         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1018         unchecked {
1019             // We can directly increment and decrement the balances.
1020             --_packedAddressData[from]; // Updates: `balance -= 1`.
1021             ++_packedAddressData[to]; // Updates: `balance += 1`.
1022 
1023             // Updates:
1024             // - `address` to the next owner.
1025             // - `startTimestamp` to the timestamp of transfering.
1026             // - `burned` to `false`.
1027             // - `nextInitialized` to `true`.
1028             _packedOwnerships[tokenId] =
1029                 _addressToUint256(to) |
1030                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1031                 BITMASK_NEXT_INITIALIZED;
1032 
1033             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1034             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1035                 uint256 nextTokenId = tokenId + 1;
1036                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1037                 if (_packedOwnerships[nextTokenId] == 0) {
1038                     // If the next slot is within bounds.
1039                     if (nextTokenId != _currentIndex) {
1040                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1041                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1042                     }
1043                 }
1044             }
1045         }
1046 
1047         emit Transfer(from, to, tokenId);
1048         _afterTokenTransfers(from, to, tokenId, 1);
1049     }
1050 
1051     /**
1052      * @dev Equivalent to `_burn(tokenId, false)`.
1053      */
1054     function _burn(uint256 tokenId) internal virtual {
1055         _burn(tokenId, false);
1056     }
1057 
1058     /**
1059      * @dev Destroys `tokenId`.
1060      * The approval is cleared when the token is burned.
1061      *
1062      * Requirements:
1063      *
1064      * - `tokenId` must exist.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1069         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1070 
1071         address from = address(uint160(prevOwnershipPacked));
1072         address approvedAddress = _tokenApprovals[tokenId];
1073 
1074         if (approvalCheck) {
1075             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1076                 isApprovedForAll(from, _msgSenderERC721A()) ||
1077                 approvedAddress == _msgSenderERC721A());
1078 
1079             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1080         }
1081 
1082         _beforeTokenTransfers(from, address(0), tokenId, 1);
1083 
1084         // Clear approvals from the previous owner.
1085         if (_addressToUint256(approvedAddress) != 0) {
1086             delete _tokenApprovals[tokenId];
1087         }
1088 
1089         // Underflow of the sender's balance is impossible because we check for
1090         // ownership above and the recipient's balance can't realistically overflow.
1091         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1092         unchecked {
1093             // Updates:
1094             // - `balance -= 1`.
1095             // - `numberBurned += 1`.
1096             //
1097             // We can directly decrement the balance, and increment the number burned.
1098             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1099             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1100 
1101             // Updates:
1102             // - `address` to the last owner.
1103             // - `startTimestamp` to the timestamp of burning.
1104             // - `burned` to `true`.
1105             // - `nextInitialized` to `true`.
1106             _packedOwnerships[tokenId] =
1107                 _addressToUint256(from) |
1108                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1109                 BITMASK_BURNED |
1110                 BITMASK_NEXT_INITIALIZED;
1111 
1112             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1113             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1114                 uint256 nextTokenId = tokenId + 1;
1115                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1116                 if (_packedOwnerships[nextTokenId] == 0) {
1117                     // If the next slot is within bounds.
1118                     if (nextTokenId != _currentIndex) {
1119                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1120                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1121                     }
1122                 }
1123             }
1124         }
1125 
1126         emit Transfer(from, address(0), tokenId);
1127         _afterTokenTransfers(from, address(0), tokenId, 1);
1128 
1129         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1130         unchecked {
1131             _burnCounter++;
1132         }
1133     }
1134 
1135     /**
1136      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1137      *
1138      * @param from address representing the previous owner of the given token ID
1139      * @param to target address that will receive the tokens
1140      * @param tokenId uint256 ID of the token to be transferred
1141      * @param _data bytes optional data to send along with the call
1142      * @return bool whether the call correctly returned the expected magic value
1143      */
1144     function _checkContractOnERC721Received(
1145         address from,
1146         address to,
1147         uint256 tokenId,
1148         bytes memory _data
1149     ) private returns (bool) {
1150         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1151             bytes4 retval
1152         ) {
1153             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1154         } catch (bytes memory reason) {
1155             if (reason.length == 0) {
1156                 revert TransferToNonERC721ReceiverImplementer();
1157             } else {
1158                 assembly {
1159                     revert(add(32, reason), mload(reason))
1160                 }
1161             }
1162         }
1163     }
1164 
1165     /**
1166      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1167      * And also called before burning one token.
1168      *
1169      * startTokenId - the first token id to be transferred
1170      * quantity - the amount to be transferred
1171      *
1172      * Calling conditions:
1173      *
1174      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1175      * transferred to `to`.
1176      * - When `from` is zero, `tokenId` will be minted for `to`.
1177      * - When `to` is zero, `tokenId` will be burned by `from`.
1178      * - `from` and `to` are never both zero.
1179      */
1180     function _beforeTokenTransfers(
1181         address from,
1182         address to,
1183         uint256 startTokenId,
1184         uint256 quantity
1185     ) internal virtual {}
1186 
1187     /**
1188      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1189      * minting.
1190      * And also called after one token has been burned.
1191      *
1192      * startTokenId - the first token id to be transferred
1193      * quantity - the amount to be transferred
1194      *
1195      * Calling conditions:
1196      *
1197      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1198      * transferred to `to`.
1199      * - When `from` is zero, `tokenId` has been minted for `to`.
1200      * - When `to` is zero, `tokenId` has been burned by `from`.
1201      * - `from` and `to` are never both zero.
1202      */
1203     function _afterTokenTransfers(
1204         address from,
1205         address to,
1206         uint256 startTokenId,
1207         uint256 quantity
1208     ) internal virtual {}
1209 
1210     /**
1211      * @dev Returns the message sender (defaults to `msg.sender`).
1212      *
1213      * If you are writing GSN compatible contracts, you need to override this function.
1214      */
1215     function _msgSenderERC721A() internal view virtual returns (address) {
1216         return msg.sender;
1217     }
1218 
1219     /**
1220      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1221      */
1222     function _toString(uint256 value) internal pure returns (string memory ptr) {
1223         assembly {
1224             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1225             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1226             // We will need 1 32-byte word to store the length,
1227             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1228             ptr := add(mload(0x40), 128)
1229             // Update the free memory pointer to allocate.
1230             mstore(0x40, ptr)
1231 
1232             // Cache the end of the memory to calculate the length later.
1233             let end := ptr
1234 
1235             // We write the string from the rightmost digit to the leftmost digit.
1236             // The following is essentially a do-while loop that also handles the zero case.
1237             // Costs a bit more than early returning for the zero case,
1238             // but cheaper in terms of deployment and overall runtime costs.
1239             for {
1240                 // Initialize and perform the first pass without check.
1241                 let temp := value
1242                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1243                 ptr := sub(ptr, 1)
1244                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1245                 mstore8(ptr, add(48, mod(temp, 10)))
1246                 temp := div(temp, 10)
1247             } temp {
1248                 // Keep dividing `temp` until zero.
1249                 temp := div(temp, 10)
1250             } { // Body of the for loop.
1251                 ptr := sub(ptr, 1)
1252                 mstore8(ptr, add(48, mod(temp, 10)))
1253             }
1254 
1255             let length := sub(end, ptr)
1256             // Move the pointer 32 bytes leftwards to make room for the length.
1257             ptr := sub(ptr, 32)
1258             // Store the length.
1259             mstore(ptr, length)
1260         }
1261     }
1262 }
1263 
1264 // File: contracts/wtf/WtfIsThis.sol
1265 
1266 
1267 pragma solidity ^0.8.7;
1268 
1269 
1270 
1271 
1272    
1273 
1274 contract WtfIsThat is ERC721A, Ownable {
1275     using StringsUpgradeable for uint256;
1276     address breedingContract;
1277 
1278     string public baseApiURI;
1279     
1280   
1281 
1282     //General Settings
1283     uint256 public maxMintAmountPerTransaction = 1;
1284     uint256 public maxMintPerWallet = 1;
1285     
1286 
1287     //Inventory
1288     uint256 public maxSupply = 6969;
1289 
1290     //Prices
1291     uint256 public cost = 0 ether;
1292 
1293     //Utility
1294     bool public paused = false;
1295     
1296 
1297     constructor(string memory _baseUrl) ERC721A("WtF iS tHaT", "WtFiStHaT") {
1298         baseApiURI = _baseUrl;
1299     }
1300 
1301    
1302 
1303 
1304     //This function will be used to extend the project with more capabilities 
1305     function setBreedingContractAddress(address _bAddress) public onlyOwner {
1306         breedingContract = _bAddress;
1307     }
1308 
1309 
1310     //this function can be called only from the extending contract
1311     function mintExternal(address _address, uint256 _mintAmount) external {
1312         require(
1313             msg.sender == breedingContract,
1314             "Sorry you dont have permission to mint"
1315         );
1316         _safeMint(_address, _mintAmount);
1317     }
1318 
1319     function numberMinted(address owner) public view returns (uint256) {
1320         return _numberMinted(owner);
1321     }
1322 
1323     // public
1324    function mint(uint256 _mintAmount) external payable {
1325         if (msg.sender != owner()) {
1326             require(!paused);
1327             require(_mintAmount > 0, "Mint amount should be greater than 0");
1328             uint256 ownerTokenCount = balanceOf(msg.sender);
1329             require(
1330                 _mintAmount <= maxMintAmountPerTransaction,
1331                 "Sorry you cant mint this amount at once"
1332             );
1333             require(
1334                 totalSupply() + _mintAmount <= maxSupply,
1335                 "Exceeds Max Supply"
1336             );
1337             require(
1338                 (ownerTokenCount + _mintAmount) <= maxMintPerWallet,
1339                 "Sorry you cant mint more"
1340             );
1341 
1342             require(msg.value >= cost * _mintAmount, "Insuffient funds");
1343         }
1344 
1345         _mintLoop(msg.sender, _mintAmount);
1346     }
1347 
1348 
1349     function setMaxMintPerWallet(uint256 val) public onlyOwner{
1350         maxMintPerWallet = val;
1351     }
1352 
1353     function gift(address _to, uint256 _mintAmount) public onlyOwner {
1354         _mintLoop(_to, _mintAmount);
1355     }
1356 
1357     function airdrop(address[] memory _airdropAddresses) public onlyOwner {
1358         for (uint256 i = 0; i < _airdropAddresses.length; i++) {
1359             address to = _airdropAddresses[i];
1360             _mintLoop(to, 1);
1361         }
1362     }
1363 
1364     function _baseURI() internal view virtual override returns (string memory) {
1365         return baseApiURI;
1366     }
1367 
1368     function tokenURI(uint256 tokenId)
1369         public
1370         view
1371         virtual
1372         override
1373         returns (string memory)
1374     {
1375         require(
1376             _exists(tokenId),
1377             "ERC721Metadata: URI query for nonexistent token"
1378         );
1379         string memory currentBaseURI = _baseURI();
1380         return
1381             bytes(currentBaseURI).length > 0
1382                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1383                 : "";
1384     }
1385 
1386     function setCost(uint256 _newCost) public onlyOwner {
1387         cost = _newCost;
1388     }
1389 
1390     function setmaxMintAmountPerTransaction(uint16 _amount) public onlyOwner {
1391         maxMintAmountPerTransaction = _amount;
1392     }
1393 
1394     
1395     function setMaxSupply(uint256 _supply) public onlyOwner {
1396         maxSupply = _supply;
1397     }
1398 
1399     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1400         baseApiURI = _newBaseURI;
1401     }
1402 
1403     function togglePause() public onlyOwner {
1404         paused = !paused;
1405     }
1406 
1407 
1408 
1409     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1410         _safeMint(_receiver, _mintAmount);
1411     }
1412 
1413   
1414 
1415     function withdraw() public payable onlyOwner {
1416         (bool os, ) = payable(0x4F33a1a7EB7B255cbC42FB77A3499C1DEd7204C5).call{value: address(this).balance}("");
1417         require(os);
1418     }
1419 }