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
176 // File: contracts/IERC721A.sol
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
438 // File: contracts/erc721a.sol
439 
440 
441 // ERC721A Contracts v4.0.0
442 // Creator: Chiru Labs
443 
444 pragma solidity ^0.8.4;
445 
446 
447 /**
448  * @dev ERC721 token receiver interface.
449  */
450 interface ERC721A__IERC721Receiver {
451     function onERC721Received(
452         address operator,
453         address from,
454         uint256 tokenId,
455         bytes calldata data
456     ) external returns (bytes4);
457 }
458 
459 /**
460  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
461  * the Metadata extension. Built to optimize for lower gas during batch mints.
462  *
463  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
464  *
465  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
466  *
467  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
468  */
469 contract ERC721A is IERC721A {
470     // Mask of an entry in packed address data.
471     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
472 
473     // The bit position of `numberMinted` in packed address data.
474     uint256 private constant BITPOS_NUMBER_MINTED = 64;
475 
476     // The bit position of `numberBurned` in packed address data.
477     uint256 private constant BITPOS_NUMBER_BURNED = 128;
478 
479     // The bit position of `aux` in packed address data.
480     uint256 private constant BITPOS_AUX = 192;
481 
482     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
483     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
484 
485     // The bit position of `startTimestamp` in packed ownership.
486     uint256 private constant BITPOS_START_TIMESTAMP = 160;
487 
488     // The bit mask of the `burned` bit in packed ownership.
489     uint256 private constant BITMASK_BURNED = 1 << 224;
490     
491     // The bit position of the `nextInitialized` bit in packed ownership.
492     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
493 
494     // The bit mask of the `nextInitialized` bit in packed ownership.
495     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
496 
497     // The tokenId of the next token to be minted.
498     uint256 private _currentIndex;
499 
500     // The number of tokens burned.
501     uint256 private _burnCounter;
502 
503     // Token name
504     string private _name;
505 
506     // Token symbol
507     string private _symbol;
508 
509     // Mapping from token ID to ownership details
510     // An empty struct value does not necessarily mean the token is unowned.
511     // See `_packedOwnershipOf` implementation for details.
512     //
513     // Bits Layout:
514     // - [0..159]   `addr`
515     // - [160..223] `startTimestamp`
516     // - [224]      `burned`
517     // - [225]      `nextInitialized`
518     mapping(uint256 => uint256) private _packedOwnerships;
519 
520     // Mapping owner address to address data.
521     //
522     // Bits Layout:
523     // - [0..63]    `balance`
524     // - [64..127]  `numberMinted`
525     // - [128..191] `numberBurned`
526     // - [192..255] `aux`
527     mapping(address => uint256) private _packedAddressData;
528 
529     // Mapping from token ID to approved address.
530     mapping(uint256 => address) private _tokenApprovals;
531 
532     // Mapping from owner to operator approvals
533     mapping(address => mapping(address => bool)) private _operatorApprovals;
534 
535     constructor(string memory name_, string memory symbol_) {
536         _name = name_;
537         _symbol = symbol_;
538         _currentIndex = _startTokenId();
539     }
540 
541     /**
542      * @dev Returns the starting token ID. 
543      * To change the starting token ID, please override this function.
544      */
545     function _startTokenId() internal view virtual returns (uint256) {
546         return 0;
547     }
548 
549     /**
550      * @dev Returns the next token ID to be minted.
551      */
552     function _nextTokenId() internal view returns (uint256) {
553         return _currentIndex;
554     }
555 
556     /**
557      * @dev Returns the total number of tokens in existence.
558      * Burned tokens will reduce the count. 
559      * To get the total number of tokens minted, please see `_totalMinted`.
560      */
561     function totalSupply() public view override returns (uint256) {
562         // Counter underflow is impossible as _burnCounter cannot be incremented
563         // more than `_currentIndex - _startTokenId()` times.
564         unchecked {
565             return _currentIndex - _burnCounter - _startTokenId();
566         }
567     }
568 
569     /**
570      * @dev Returns the total amount of tokens minted in the contract.
571      */
572     function _totalMinted() internal view returns (uint256) {
573         // Counter underflow is impossible as _currentIndex does not decrement,
574         // and it is initialized to `_startTokenId()`
575         unchecked {
576             return _currentIndex - _startTokenId();
577         }
578     }
579 
580     /**
581      * @dev Returns the total number of tokens burned.
582      */
583     function _totalBurned() internal view returns (uint256) {
584         return _burnCounter;
585     }
586 
587     /**
588      * @dev See {IERC165-supportsInterface}.
589      */
590     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
591         // The interface IDs are constants representing the first 4 bytes of the XOR of
592         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
593         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
594         return
595             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
596             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
597             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
598     }
599 
600     /**
601      * @dev See {IERC721-balanceOf}.
602      */
603     function balanceOf(address owner) public view override returns (uint256) {
604         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
605         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
606     }
607 
608     /**
609      * Returns the number of tokens minted by `owner`.
610      */
611     function _numberMinted(address owner) internal view returns (uint256) {
612         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
613     }
614 
615     /**
616      * Returns the number of tokens burned by or on behalf of `owner`.
617      */
618     function _numberBurned(address owner) internal view returns (uint256) {
619         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
620     }
621 
622     /**
623      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
624      */
625     function _getAux(address owner) internal view returns (uint64) {
626         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
627     }
628 
629     /**
630      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
631      * If there are multiple variables, please pack them into a uint64.
632      */
633     function _setAux(address owner, uint64 aux) internal {
634         uint256 packed = _packedAddressData[owner];
635         uint256 auxCasted;
636         assembly { // Cast aux without masking.
637             auxCasted := aux
638         }
639         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
640         _packedAddressData[owner] = packed;
641     }
642 
643     /**
644      * Returns the packed ownership data of `tokenId`.
645      */
646     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
647         uint256 curr = tokenId;
648 
649         unchecked {
650             if (_startTokenId() <= curr)
651                 if (curr < _currentIndex) {
652                     uint256 packed = _packedOwnerships[curr];
653                     // If not burned.
654                     if (packed & BITMASK_BURNED == 0) {
655                         // Invariant:
656                         // There will always be an ownership that has an address and is not burned
657                         // before an ownership that does not have an address and is not burned.
658                         // Hence, curr will not underflow.
659                         //
660                         // We can directly compare the packed value.
661                         // If the address is zero, packed is zero.
662                         while (packed == 0) {
663                             packed = _packedOwnerships[--curr];
664                         }
665                         return packed;
666                     }
667                 }
668         }
669         revert OwnerQueryForNonexistentToken();
670     }
671 
672     /**
673      * Returns the unpacked `TokenOwnership` struct from `packed`.
674      */
675     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
676         ownership.addr = address(uint160(packed));
677         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
678         ownership.burned = packed & BITMASK_BURNED != 0;
679     }
680 
681     /**
682      * Returns the unpacked `TokenOwnership` struct at `index`.
683      */
684     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
685         return _unpackedOwnership(_packedOwnerships[index]);
686     }
687 
688     /**
689      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
690      */
691     function _initializeOwnershipAt(uint256 index) internal {
692         if (_packedOwnerships[index] == 0) {
693             _packedOwnerships[index] = _packedOwnershipOf(index);
694         }
695     }
696 
697     /**
698      * Gas spent here starts off proportional to the maximum mint batch size.
699      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
700      */
701     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
702         return _unpackedOwnership(_packedOwnershipOf(tokenId));
703     }
704 
705     /**
706      * @dev See {IERC721-ownerOf}.
707      */
708     function ownerOf(uint256 tokenId) public view override returns (address) {
709         return address(uint160(_packedOwnershipOf(tokenId)));
710     }
711 
712     /**
713      * @dev See {IERC721Metadata-name}.
714      */
715     function name() public view virtual override returns (string memory) {
716         return _name;
717     }
718 
719     /**
720      * @dev See {IERC721Metadata-symbol}.
721      */
722     function symbol() public view virtual override returns (string memory) {
723         return _symbol;
724     }
725 
726     /**
727      * @dev See {IERC721Metadata-tokenURI}.
728      */
729     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
730         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
731 
732         string memory baseURI = _baseURI();
733         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
734     }
735 
736     /**
737      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
738      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
739      * by default, can be overriden in child contracts.
740      */
741     function _baseURI() internal view virtual returns (string memory) {
742         return '';
743     }
744 
745     /**
746      * @dev Casts the address to uint256 without masking.
747      */
748     function _addressToUint256(address value) private pure returns (uint256 result) {
749         assembly {
750             result := value
751         }
752     }
753 
754     /**
755      * @dev Casts the boolean to uint256 without branching.
756      */
757     function _boolToUint256(bool value) private pure returns (uint256 result) {
758         assembly {
759             result := value
760         }
761     }
762 
763     /**
764      * @dev See {IERC721-approve}.
765      */
766     function approve(address to, uint256 tokenId) public override {
767         address owner = address(uint160(_packedOwnershipOf(tokenId)));
768         if (to == owner) revert ApprovalToCurrentOwner();
769 
770         if (_msgSenderERC721A() != owner)
771             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
772                 revert ApprovalCallerNotOwnerNorApproved();
773             }
774 
775         _tokenApprovals[tokenId] = to;
776         emit Approval(owner, to, tokenId);
777     }
778 
779     /**
780      * @dev See {IERC721-getApproved}.
781      */
782     function getApproved(uint256 tokenId) public view override returns (address) {
783         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
784 
785         return _tokenApprovals[tokenId];
786     }
787 
788     /**
789      * @dev See {IERC721-setApprovalForAll}.
790      */
791     function setApprovalForAll(address operator, bool approved) public virtual override {
792         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
793 
794         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
795         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
796     }
797 
798     /**
799      * @dev See {IERC721-isApprovedForAll}.
800      */
801     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
802         return _operatorApprovals[owner][operator];
803     }
804 
805     /**
806      * @dev See {IERC721-transferFrom}.
807      */
808     function transferFrom(
809         address from,
810         address to,
811         uint256 tokenId
812     ) public virtual override {
813         _transfer(from, to, tokenId);
814     }
815 
816     /**
817      * @dev See {IERC721-safeTransferFrom}.
818      */
819     function safeTransferFrom(
820         address from,
821         address to,
822         uint256 tokenId
823     ) public virtual override {
824         safeTransferFrom(from, to, tokenId, '');
825     }
826 
827     /**
828      * @dev See {IERC721-safeTransferFrom}.
829      */
830     function safeTransferFrom(
831         address from,
832         address to,
833         uint256 tokenId,
834         bytes memory _data
835     ) public virtual override {
836         _transfer(from, to, tokenId);
837         if (to.code.length != 0)
838             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
839                 revert TransferToNonERC721ReceiverImplementer();
840             }
841     }
842 
843     /**
844      * @dev Returns whether `tokenId` exists.
845      *
846      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
847      *
848      * Tokens start existing when they are minted (`_mint`),
849      */
850     function _exists(uint256 tokenId) internal view returns (bool) {
851         return
852             _startTokenId() <= tokenId &&
853             tokenId < _currentIndex && // If within bounds,
854             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
855     }
856 
857     /**
858      * @dev Equivalent to `_safeMint(to, quantity, '')`.
859      */
860     function _safeMint(address to, uint256 quantity) internal {
861         _safeMint(to, quantity, '');
862     }
863 
864     /**
865      * @dev Safely mints `quantity` tokens and transfers them to `to`.
866      *
867      * Requirements:
868      *
869      * - If `to` refers to a smart contract, it must implement
870      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
871      * - `quantity` must be greater than 0.
872      *
873      * Emits a {Transfer} event.
874      */
875     function _safeMint(
876         address to,
877         uint256 quantity,
878         bytes memory _data
879     ) internal {
880         uint256 startTokenId = _currentIndex;
881         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
882         if (quantity == 0) revert MintZeroQuantity();
883 
884         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
885 
886         // Overflows are incredibly unrealistic.
887         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
888         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
889         unchecked {
890             // Updates:
891             // - `balance += quantity`.
892             // - `numberMinted += quantity`.
893             //
894             // We can directly add to the balance and number minted.
895             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
896 
897             // Updates:
898             // - `address` to the owner.
899             // - `startTimestamp` to the timestamp of minting.
900             // - `burned` to `false`.
901             // - `nextInitialized` to `quantity == 1`.
902             _packedOwnerships[startTokenId] =
903                 _addressToUint256(to) |
904                 (block.timestamp << BITPOS_START_TIMESTAMP) |
905                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
906 
907             uint256 updatedIndex = startTokenId;
908             uint256 end = updatedIndex + quantity;
909 
910             if (to.code.length != 0) {
911                 do {
912                     emit Transfer(address(0), to, updatedIndex);
913                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
914                         revert TransferToNonERC721ReceiverImplementer();
915                     }
916                 } while (updatedIndex < end);
917                 // Reentrancy protection
918                 if (_currentIndex != startTokenId) revert();
919             } else {
920                 do {
921                     emit Transfer(address(0), to, updatedIndex++);
922                 } while (updatedIndex < end);
923             }
924             _currentIndex = updatedIndex;
925         }
926         _afterTokenTransfers(address(0), to, startTokenId, quantity);
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
937      * Emits a {Transfer} event.
938      */
939     function _mint(address to, uint256 quantity) internal {
940         uint256 startTokenId = _currentIndex;
941         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
942         if (quantity == 0) revert MintZeroQuantity();
943 
944         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
945 
946         // Overflows are incredibly unrealistic.
947         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
948         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
949         unchecked {
950             // Updates:
951             // - `balance += quantity`.
952             // - `numberMinted += quantity`.
953             //
954             // We can directly add to the balance and number minted.
955             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
956 
957             // Updates:
958             // - `address` to the owner.
959             // - `startTimestamp` to the timestamp of minting.
960             // - `burned` to `false`.
961             // - `nextInitialized` to `quantity == 1`.
962             _packedOwnerships[startTokenId] =
963                 _addressToUint256(to) |
964                 (block.timestamp << BITPOS_START_TIMESTAMP) |
965                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
966 
967             uint256 updatedIndex = startTokenId;
968             uint256 end = updatedIndex + quantity;
969 
970             do {
971                 emit Transfer(address(0), to, updatedIndex++);
972             } while (updatedIndex < end);
973 
974             _currentIndex = updatedIndex;
975         }
976         _afterTokenTransfers(address(0), to, startTokenId, quantity);
977     }
978 
979     /**
980      * @dev Transfers `tokenId` from `from` to `to`.
981      *
982      * Requirements:
983      *
984      * - `to` cannot be the zero address.
985      * - `tokenId` token must be owned by `from`.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _transfer(
990         address from,
991         address to,
992         uint256 tokenId
993     ) private {
994         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
995 
996         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
997 
998         address approvedAddress = _tokenApprovals[tokenId];
999 
1000         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1001             isApprovedForAll(from, _msgSenderERC721A()) ||
1002             approvedAddress == _msgSenderERC721A());
1003 
1004         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1005         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1006 
1007         _beforeTokenTransfers(from, to, tokenId, 1);
1008 
1009         // Clear approvals from the previous owner.
1010         if (_addressToUint256(approvedAddress) != 0) {
1011             delete _tokenApprovals[tokenId];
1012         }
1013 
1014         // Underflow of the sender's balance is impossible because we check for
1015         // ownership above and the recipient's balance can't realistically overflow.
1016         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1017         unchecked {
1018             // We can directly increment and decrement the balances.
1019             --_packedAddressData[from]; // Updates: `balance -= 1`.
1020             ++_packedAddressData[to]; // Updates: `balance += 1`.
1021 
1022             // Updates:
1023             // - `address` to the next owner.
1024             // - `startTimestamp` to the timestamp of transfering.
1025             // - `burned` to `false`.
1026             // - `nextInitialized` to `true`.
1027             _packedOwnerships[tokenId] =
1028                 _addressToUint256(to) |
1029                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1030                 BITMASK_NEXT_INITIALIZED;
1031 
1032             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1033             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1034                 uint256 nextTokenId = tokenId + 1;
1035                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1036                 if (_packedOwnerships[nextTokenId] == 0) {
1037                     // If the next slot is within bounds.
1038                     if (nextTokenId != _currentIndex) {
1039                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1040                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1041                     }
1042                 }
1043             }
1044         }
1045 
1046         emit Transfer(from, to, tokenId);
1047         _afterTokenTransfers(from, to, tokenId, 1);
1048     }
1049 
1050     /**
1051      * @dev Equivalent to `_burn(tokenId, false)`.
1052      */
1053     function _burn(uint256 tokenId) internal virtual {
1054         _burn(tokenId, false);
1055     }
1056 
1057     /**
1058      * @dev Destroys `tokenId`.
1059      * The approval is cleared when the token is burned.
1060      *
1061      * Requirements:
1062      *
1063      * - `tokenId` must exist.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1068         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1069 
1070         address from = address(uint160(prevOwnershipPacked));
1071         address approvedAddress = _tokenApprovals[tokenId];
1072 
1073         if (approvalCheck) {
1074             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1075                 isApprovedForAll(from, _msgSenderERC721A()) ||
1076                 approvedAddress == _msgSenderERC721A());
1077 
1078             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1079         }
1080 
1081         _beforeTokenTransfers(from, address(0), tokenId, 1);
1082 
1083         // Clear approvals from the previous owner.
1084         if (_addressToUint256(approvedAddress) != 0) {
1085             delete _tokenApprovals[tokenId];
1086         }
1087 
1088         // Underflow of the sender's balance is impossible because we check for
1089         // ownership above and the recipient's balance can't realistically overflow.
1090         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1091         unchecked {
1092             // Updates:
1093             // - `balance -= 1`.
1094             // - `numberBurned += 1`.
1095             //
1096             // We can directly decrement the balance, and increment the number burned.
1097             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1098             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1099 
1100             // Updates:
1101             // - `address` to the last owner.
1102             // - `startTimestamp` to the timestamp of burning.
1103             // - `burned` to `true`.
1104             // - `nextInitialized` to `true`.
1105             _packedOwnerships[tokenId] =
1106                 _addressToUint256(from) |
1107                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1108                 BITMASK_BURNED | 
1109                 BITMASK_NEXT_INITIALIZED;
1110 
1111             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1112             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1113                 uint256 nextTokenId = tokenId + 1;
1114                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1115                 if (_packedOwnerships[nextTokenId] == 0) {
1116                     // If the next slot is within bounds.
1117                     if (nextTokenId != _currentIndex) {
1118                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1119                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1120                     }
1121                 }
1122             }
1123         }
1124 
1125         emit Transfer(from, address(0), tokenId);
1126         _afterTokenTransfers(from, address(0), tokenId, 1);
1127 
1128         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1129         unchecked {
1130             _burnCounter++;
1131         }
1132     }
1133 
1134     /**
1135      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1136      *
1137      * @param from address representing the previous owner of the given token ID
1138      * @param to target address that will receive the tokens
1139      * @param tokenId uint256 ID of the token to be transferred
1140      * @param _data bytes optional data to send along with the call
1141      * @return bool whether the call correctly returned the expected magic value
1142      */
1143     function _checkContractOnERC721Received(
1144         address from,
1145         address to,
1146         uint256 tokenId,
1147         bytes memory _data
1148     ) private returns (bool) {
1149         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1150             bytes4 retval
1151         ) {
1152             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1153         } catch (bytes memory reason) {
1154             if (reason.length == 0) {
1155                 revert TransferToNonERC721ReceiverImplementer();
1156             } else {
1157                 assembly {
1158                     revert(add(32, reason), mload(reason))
1159                 }
1160             }
1161         }
1162     }
1163 
1164     /**
1165      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1166      * And also called before burning one token.
1167      *
1168      * startTokenId - the first token id to be transferred
1169      * quantity - the amount to be transferred
1170      *
1171      * Calling conditions:
1172      *
1173      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1174      * transferred to `to`.
1175      * - When `from` is zero, `tokenId` will be minted for `to`.
1176      * - When `to` is zero, `tokenId` will be burned by `from`.
1177      * - `from` and `to` are never both zero.
1178      */
1179     function _beforeTokenTransfers(
1180         address from,
1181         address to,
1182         uint256 startTokenId,
1183         uint256 quantity
1184     ) internal virtual {}
1185 
1186     /**
1187      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1188      * minting.
1189      * And also called after one token has been burned.
1190      *
1191      * startTokenId - the first token id to be transferred
1192      * quantity - the amount to be transferred
1193      *
1194      * Calling conditions:
1195      *
1196      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1197      * transferred to `to`.
1198      * - When `from` is zero, `tokenId` has been minted for `to`.
1199      * - When `to` is zero, `tokenId` has been burned by `from`.
1200      * - `from` and `to` are never both zero.
1201      */
1202     function _afterTokenTransfers(
1203         address from,
1204         address to,
1205         uint256 startTokenId,
1206         uint256 quantity
1207     ) internal virtual {}
1208 
1209     /**
1210      * @dev Returns the message sender (defaults to `msg.sender`).
1211      *
1212      * If you are writing GSN compatible contracts, you need to override this function.
1213      */
1214     function _msgSenderERC721A() internal view virtual returns (address) {
1215         return msg.sender;
1216     }
1217 
1218     /**
1219      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1220      */
1221     function _toString(uint256 value) internal pure returns (string memory ptr) {
1222         assembly {
1223             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1224             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1225             // We will need 1 32-byte word to store the length, 
1226             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1227             ptr := add(mload(0x40), 128)
1228             // Update the free memory pointer to allocate.
1229             mstore(0x40, ptr)
1230 
1231             // Cache the end of the memory to calculate the length later.
1232             let end := ptr
1233 
1234             // We write the string from the rightmost digit to the leftmost digit.
1235             // The following is essentially a do-while loop that also handles the zero case.
1236             // Costs a bit more than early returning for the zero case,
1237             // but cheaper in terms of deployment and overall runtime costs.
1238             for { 
1239                 // Initialize and perform the first pass without check.
1240                 let temp := value
1241                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1242                 ptr := sub(ptr, 1)
1243                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1244                 mstore8(ptr, add(48, mod(temp, 10)))
1245                 temp := div(temp, 10)
1246             } temp { 
1247                 // Keep dividing `temp` until zero.
1248                 temp := div(temp, 10)
1249             } { // Body of the for loop.
1250                 ptr := sub(ptr, 1)
1251                 mstore8(ptr, add(48, mod(temp, 10)))
1252             }
1253             
1254             let length := sub(end, ptr)
1255             // Move the pointer 32 bytes leftwards to make room for the length.
1256             ptr := sub(ptr, 32)
1257             // Store the length.
1258             mstore(ptr, length)
1259         }
1260     }
1261 }
1262 // File: contracts/hunny_bunny.sol
1263 
1264 //SPDX-License-Identifier: MIT
1265 // pragma solidity ^0.8.9;
1266 pragma solidity >=0.7.0 <0.9.0;
1267 
1268 
1269 
1270 
1271 contract HunnyBunny is ERC721A, Ownable {
1272     using Strings for uint256;
1273     uint256 public constant FREE_SUPPLY = 2000;
1274     uint256 public constant SALE_SUPPLY = 8000;
1275     uint256 public constant MAX_PER_MINT = 1;
1276     uint256 public constant MAX_PRE_SALE = 3;
1277     uint256 public salePrice = 0.002 ether;
1278     uint256 public freeMintCount;
1279 
1280     bool public isStartFreeMint;
1281     bool public isStartSaleMint;
1282 
1283     string public baseURI;
1284 
1285     mapping(address => uint256) public allowFreeMintPerWallet;
1286 
1287     constructor() ERC721A("Hunny Bunny", "HB") {}
1288 
1289     /**
1290      * @notice token start from id 1
1291      */
1292     function _startTokenId() internal view virtual override returns (uint256) {
1293         return 1;
1294     }
1295     
1296     /**
1297      * @notice mint hunny bunny
1298      */
1299     function mintHB(uint256 _quantity) external payable {
1300         require(isStartSaleMint, "Event have not start");
1301         require(totalSupply() + _quantity < SALE_SUPPLY + FREE_SUPPLY, "Exceeds max supply");
1302         require(_quantity <= MAX_PRE_SALE, "3 mint per transaction");
1303         require(msg.value >= salePrice * _quantity, "Not enough ETH to mint");
1304 
1305         _safeMint(msg.sender, _quantity);
1306     }
1307 
1308     /**
1309      * @notice free mint hunny bunny
1310      */
1311     function freeMintHB(uint256 _quantity) external payable {
1312         require(isStartFreeMint, "Event have not start");
1313         require(freeMintCount + _quantity <= FREE_SUPPLY, "Free mint supply finish");
1314         require(_quantity + allowFreeMintPerWallet[msg.sender] <= MAX_PER_MINT, "Only 1 free mints per wallet");
1315 
1316         freeMintCount += _quantity;
1317         allowFreeMintPerWallet[msg.sender] += _quantity;
1318         _safeMint(msg.sender, _quantity);
1319     }
1320     
1321     /**
1322      * @notice set sale price
1323      */
1324     function setSalePrice(uint256 _salePrice) public onlyOwner {
1325         salePrice = _salePrice;
1326     }
1327 
1328     /**
1329      * @notice set base uri
1330      */
1331     function setBaseURI(string memory uri) public onlyOwner {
1332         baseURI = uri;
1333     }
1334 
1335     /**
1336      * @notice switch sales status
1337      */
1338     function switchSalesStatus() public onlyOwner {
1339         isStartSaleMint = !isStartSaleMint;
1340     }
1341 
1342     /**
1343      * @notice switch free mint status
1344      */
1345     function switchFreeStatus() public onlyOwner {
1346         isStartFreeMint = !isStartFreeMint;
1347     }
1348 
1349     /**
1350      * @notice token URI
1351      */
1352     function tokenURI(uint256 _tokenId)
1353         public
1354         view
1355         virtual
1356         override
1357         returns (string memory)
1358     {
1359         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1360         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _tokenId.toString())) : '';
1361     }
1362 
1363     /**
1364      * @notice transfer funds
1365      */
1366     function withdrawal() external onlyOwner {
1367         uint256 balance = address(this).balance;
1368         payable(msg.sender).transfer(balance);
1369     }
1370 }