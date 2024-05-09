1 //SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
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
193 // File: contracts/IERC721A.sol
194 
195 
196 // ERC721A Contracts v4.0.0
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
221      * The caller cannot approve to the current owner.
222      */
223     error ApprovalToCurrentOwner();
224 
225     /**
226      * Cannot query the balance for the zero address.
227      */
228     error BalanceQueryForZeroAddress();
229 
230     /**
231      * Cannot mint to the zero address.
232      */
233     error MintToZeroAddress();
234 
235     /**
236      * The quantity of tokens minted must be more than zero.
237      */
238     error MintZeroQuantity();
239 
240     /**
241      * The token does not exist.
242      */
243     error OwnerQueryForNonexistentToken();
244 
245     /**
246      * The caller must own the token or be an approved operator.
247      */
248     error TransferCallerNotOwnerNorApproved();
249 
250     /**
251      * The token must be owned by `from`.
252      */
253     error TransferFromIncorrectOwner();
254 
255     /**
256      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
257      */
258     error TransferToNonERC721ReceiverImplementer();
259 
260     /**
261      * Cannot transfer to the zero address.
262      */
263     error TransferToZeroAddress();
264 
265     /**
266      * The token does not exist.
267      */
268     error URIQueryForNonexistentToken();
269 
270     struct TokenOwnership {
271         // The address of the owner.
272         address addr;
273         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
274         uint64 startTimestamp;
275         // Whether the token has been burned.
276         bool burned;
277     }
278 
279     /**
280      * @dev Returns the total amount of tokens stored by the contract.
281      *
282      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
283      */
284     function totalSupply() external view returns (uint256);
285 
286     // ==============================
287     //            IERC165
288     // ==============================
289 
290     /**
291      * @dev Returns true if this contract implements the interface defined by
292      * `interfaceId`. See the corresponding
293      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
294      * to learn more about how these ids are created.
295      *
296      * This function call must use less than 30 000 gas.
297      */
298     function supportsInterface(bytes4 interfaceId) external view returns (bool);
299 
300     // ==============================
301     //            IERC721
302     // ==============================
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
315      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
316      */
317     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
318 
319     /**
320      * @dev Returns the number of tokens in ``owner``'s account.
321      */
322     function balanceOf(address owner) external view returns (uint256 balance);
323 
324     /**
325      * @dev Returns the owner of the `tokenId` token.
326      *
327      * Requirements:
328      *
329      * - `tokenId` must exist.
330      */
331     function ownerOf(uint256 tokenId) external view returns (address owner);
332 
333     /**
334      * @dev Safely transfers `tokenId` token from `from` to `to`.
335      *
336      * Requirements:
337      *
338      * - `from` cannot be the zero address.
339      * - `to` cannot be the zero address.
340      * - `tokenId` token must exist and be owned by `from`.
341      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
342      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
343      *
344      * Emits a {Transfer} event.
345      */
346     function safeTransferFrom(
347         address from,
348         address to,
349         uint256 tokenId,
350         bytes calldata data
351     ) external;
352 
353     /**
354      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
355      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
356      *
357      * Requirements:
358      *
359      * - `from` cannot be the zero address.
360      * - `to` cannot be the zero address.
361      * - `tokenId` token must exist and be owned by `from`.
362      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
363      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
364      *
365      * Emits a {Transfer} event.
366      */
367     function safeTransferFrom(
368         address from,
369         address to,
370         uint256 tokenId
371     ) external;
372 
373     /**
374      * @dev Transfers `tokenId` token from `from` to `to`.
375      *
376      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
377      *
378      * Requirements:
379      *
380      * - `from` cannot be the zero address.
381      * - `to` cannot be the zero address.
382      * - `tokenId` token must be owned by `from`.
383      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
384      *
385      * Emits a {Transfer} event.
386      */
387     function transferFrom(
388         address from,
389         address to,
390         uint256 tokenId
391     ) external;
392 
393     /**
394      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
395      * The approval is cleared when the token is transferred.
396      *
397      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
398      *
399      * Requirements:
400      *
401      * - The caller must own the token or be an approved operator.
402      * - `tokenId` must exist.
403      *
404      * Emits an {Approval} event.
405      */
406     function approve(address to, uint256 tokenId) external;
407 
408     /**
409      * @dev Approve or remove `operator` as an operator for the caller.
410      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
411      *
412      * Requirements:
413      *
414      * - The `operator` cannot be the caller.
415      *
416      * Emits an {ApprovalForAll} event.
417      */
418     function setApprovalForAll(address operator, bool _approved) external;
419 
420     /**
421      * @dev Returns the account approved for `tokenId` token.
422      *
423      * Requirements:
424      *
425      * - `tokenId` must exist.
426      */
427     function getApproved(uint256 tokenId) external view returns (address operator);
428 
429     /**
430      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
431      *
432      * See {setApprovalForAll}
433      */
434     function isApprovedForAll(address owner, address operator) external view returns (bool);
435 
436     // ==============================
437     //        IERC721Metadata
438     // ==============================
439 
440     /**
441      * @dev Returns the token collection name.
442      */
443     function name() external view returns (string memory);
444 
445     /**
446      * @dev Returns the token collection symbol.
447      */
448     function symbol() external view returns (string memory);
449 
450     /**
451      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
452      */
453     function tokenURI(uint256 tokenId) external view returns (string memory);
454 }
455 // File: contracts/ERC721A.sol
456 
457 
458 // ERC721A Contracts v4.0.0
459 // Creator: Chiru Labs
460 
461 pragma solidity ^0.8.4;
462 
463 
464 /**
465  * @dev ERC721 token receiver interface.
466  */
467 interface ERC721A__IERC721Receiver {
468     function onERC721Received(
469         address operator,
470         address from,
471         uint256 tokenId,
472         bytes calldata data
473     ) external returns (bytes4);
474 }
475 
476 /**
477  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
478  * the Metadata extension. Built to optimize for lower gas during batch mints.
479  *
480  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
481  *
482  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
483  *
484  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
485  */
486 contract ERC721A is IERC721A {
487     // Mask of an entry in packed address data.
488     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
489 
490     // The bit position of `numberMinted` in packed address data.
491     uint256 private constant BITPOS_NUMBER_MINTED = 64;
492 
493     // The bit position of `numberBurned` in packed address data.
494     uint256 private constant BITPOS_NUMBER_BURNED = 128;
495 
496     // The bit position of `aux` in packed address data.
497     uint256 private constant BITPOS_AUX = 192;
498 
499     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
500     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
501 
502     // The bit position of `startTimestamp` in packed ownership.
503     uint256 private constant BITPOS_START_TIMESTAMP = 160;
504 
505     // The bit mask of the `burned` bit in packed ownership.
506     uint256 private constant BITMASK_BURNED = 1 << 224;
507 
508     // The bit position of the `nextInitialized` bit in packed ownership.
509     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
510 
511     // The bit mask of the `nextInitialized` bit in packed ownership.
512     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
513 
514     // The tokenId of the next token to be minted.
515     uint256 private _currentIndex;
516 
517     // The number of tokens burned.
518     uint256 private _burnCounter;
519 
520     // Token name
521     string private _name;
522 
523     // Token symbol
524     string private _symbol;
525 
526     // Mapping from token ID to ownership details
527     // An empty struct value does not necessarily mean the token is unowned.
528     // See `_packedOwnershipOf` implementation for details.
529     //
530     // Bits Layout:
531     // - [0..159]   `addr`
532     // - [160..223] `startTimestamp`
533     // - [224]      `burned`
534     // - [225]      `nextInitialized`
535     mapping(uint256 => uint256) private _packedOwnerships;
536 
537     // Mapping owner address to address data.
538     //
539     // Bits Layout:
540     // - [0..63]    `balance`
541     // - [64..127]  `numberMinted`
542     // - [128..191] `numberBurned`
543     // - [192..255] `aux`
544     mapping(address => uint256) private _packedAddressData;
545 
546     // Mapping from token ID to approved address.
547     mapping(uint256 => address) private _tokenApprovals;
548 
549     // Mapping from owner to operator approvals
550     mapping(address => mapping(address => bool)) private _operatorApprovals;
551 
552     constructor(string memory name_, string memory symbol_) {
553         _name = name_;
554         _symbol = symbol_;
555         _currentIndex = _startTokenId();
556     }
557 
558     /**
559      * @dev Returns the starting token ID.
560      * To change the starting token ID, please override this function.
561      */
562     function _startTokenId() internal view virtual returns (uint256) {
563         return 0;
564     }
565 
566     /**
567      * @dev Returns the next token ID to be minted.
568      */
569     function _nextTokenId() internal view returns (uint256) {
570         return _currentIndex;
571     }
572 
573     /**
574      * @dev Returns the total number of tokens in existence.
575      * Burned tokens will reduce the count.
576      * To get the total number of tokens minted, please see `_totalMinted`.
577      */
578     function totalSupply() public view override returns (uint256) {
579         // Counter underflow is impossible as _burnCounter cannot be incremented
580         // more than `_currentIndex - _startTokenId()` times.
581         unchecked {
582             return _currentIndex - _burnCounter - _startTokenId();
583         }
584     }
585 
586     /**
587      * @dev Returns the total amount of tokens minted in the contract.
588      */
589     function _totalMinted() internal view returns (uint256) {
590         // Counter underflow is impossible as _currentIndex does not decrement,
591         // and it is initialized to `_startTokenId()`
592         unchecked {
593             return _currentIndex - _startTokenId();
594         }
595     }
596 
597     /**
598      * @dev Returns the total number of tokens burned.
599      */
600     function _totalBurned() internal view returns (uint256) {
601         return _burnCounter;
602     }
603 
604     /**
605      * @dev See {IERC165-supportsInterface}.
606      */
607     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
608         // The interface IDs are constants representing the first 4 bytes of the XOR of
609         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
610         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
611         return
612             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
613             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
614             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
615     }
616 
617     /**
618      * @dev See {IERC721-balanceOf}.
619      */
620     function balanceOf(address owner) public view override returns (uint256) {
621         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
622         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
623     }
624 
625     /**
626      * Returns the number of tokens minted by `owner`.
627      */
628     function _numberMinted(address owner) internal view returns (uint256) {
629         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
630     }
631 
632     /**
633      * Returns the number of tokens burned by or on behalf of `owner`.
634      */
635     function _numberBurned(address owner) internal view returns (uint256) {
636         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
637     }
638 
639     /**
640      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
641      */
642     function _getAux(address owner) internal view returns (uint64) {
643         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
644     }
645 
646     /**
647      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
648      * If there are multiple variables, please pack them into a uint64.
649      */
650     function _setAux(address owner, uint64 aux) internal {
651         uint256 packed = _packedAddressData[owner];
652         uint256 auxCasted;
653         assembly { // Cast aux without masking.
654             auxCasted := aux
655         }
656         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
657         _packedAddressData[owner] = packed;
658     }
659 
660     /**
661      * Returns the packed ownership data of `tokenId`.
662      */
663     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
664         uint256 curr = tokenId;
665 
666         unchecked {
667             if (_startTokenId() <= curr)
668                 if (curr < _currentIndex) {
669                     uint256 packed = _packedOwnerships[curr];
670                     // If not burned.
671                     if (packed & BITMASK_BURNED == 0) {
672                         // Invariant:
673                         // There will always be an ownership that has an address and is not burned
674                         // before an ownership that does not have an address and is not burned.
675                         // Hence, curr will not underflow.
676                         //
677                         // We can directly compare the packed value.
678                         // If the address is zero, packed is zero.
679                         while (packed == 0) {
680                             packed = _packedOwnerships[--curr];
681                         }
682                         return packed;
683                     }
684                 }
685         }
686         revert OwnerQueryForNonexistentToken();
687     }
688 
689     /**
690      * Returns the unpacked `TokenOwnership` struct from `packed`.
691      */
692     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
693         ownership.addr = address(uint160(packed));
694         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
695         ownership.burned = packed & BITMASK_BURNED != 0;
696     }
697 
698     /**
699      * Returns the unpacked `TokenOwnership` struct at `index`.
700      */
701     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
702         return _unpackedOwnership(_packedOwnerships[index]);
703     }
704 
705     /**
706      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
707      */
708     function _initializeOwnershipAt(uint256 index) internal {
709         if (_packedOwnerships[index] == 0) {
710             _packedOwnerships[index] = _packedOwnershipOf(index);
711         }
712     }
713 
714     /**
715      * Gas spent here starts off proportional to the maximum mint batch size.
716      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
717      */
718     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
719         return _unpackedOwnership(_packedOwnershipOf(tokenId));
720     }
721 
722     /**
723      * @dev See {IERC721-ownerOf}.
724      */
725     function ownerOf(uint256 tokenId) public view override returns (address) {
726         return address(uint160(_packedOwnershipOf(tokenId)));
727     }
728 
729     /**
730      * @dev See {IERC721Metadata-name}.
731      */
732     function name() public view virtual override returns (string memory) {
733         return _name;
734     }
735 
736     /**
737      * @dev See {IERC721Metadata-symbol}.
738      */
739     function symbol() public view virtual override returns (string memory) {
740         return _symbol;
741     }
742 
743     /**
744      * @dev See {IERC721Metadata-tokenURI}.
745      */
746     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
747         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
748 
749         string memory baseURI = _baseURI();
750         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
751     }
752 
753     /**
754      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
755      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
756      * by default, can be overriden in child contracts.
757      */
758     function _baseURI() internal view virtual returns (string memory) {
759         return '';
760     }
761 
762     /**
763      * @dev Casts the address to uint256 without masking.
764      */
765     function _addressToUint256(address value) private pure returns (uint256 result) {
766         assembly {
767             result := value
768         }
769     }
770 
771     /**
772      * @dev Casts the boolean to uint256 without branching.
773      */
774     function _boolToUint256(bool value) private pure returns (uint256 result) {
775         assembly {
776             result := value
777         }
778     }
779 
780     /**
781      * @dev See {IERC721-approve}.
782      */
783     function approve(address to, uint256 tokenId) public override {
784         address owner = address(uint160(_packedOwnershipOf(tokenId)));
785         if (to == owner) revert ApprovalToCurrentOwner();
786 
787         if (_msgSenderERC721A() != owner)
788             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
789                 revert ApprovalCallerNotOwnerNorApproved();
790             }
791 
792         _tokenApprovals[tokenId] = to;
793         emit Approval(owner, to, tokenId);
794     }
795 
796     /**
797      * @dev See {IERC721-getApproved}.
798      */
799     function getApproved(uint256 tokenId) public view override returns (address) {
800         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
801 
802         return _tokenApprovals[tokenId];
803     }
804 
805     /**
806      * @dev See {IERC721-setApprovalForAll}.
807      */
808     function setApprovalForAll(address operator, bool approved) public virtual override {
809         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
810 
811         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
812         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
813     }
814 
815     /**
816      * @dev See {IERC721-isApprovedForAll}.
817      */
818     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
819         return _operatorApprovals[owner][operator];
820     }
821 
822     /**
823      * @dev See {IERC721-transferFrom}.
824      */
825     function transferFrom(
826         address from,
827         address to,
828         uint256 tokenId
829     ) public virtual override {
830         _transfer(from, to, tokenId);
831     }
832 
833     /**
834      * @dev See {IERC721-safeTransferFrom}.
835      */
836     function safeTransferFrom(
837         address from,
838         address to,
839         uint256 tokenId
840     ) public virtual override {
841         safeTransferFrom(from, to, tokenId, '');
842     }
843 
844     /**
845      * @dev See {IERC721-safeTransferFrom}.
846      */
847     function safeTransferFrom(
848         address from,
849         address to,
850         uint256 tokenId,
851         bytes memory _data
852     ) public virtual override {
853         _transfer(from, to, tokenId);
854         if (to.code.length != 0)
855             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
856                 revert TransferToNonERC721ReceiverImplementer();
857             }
858     }
859 
860     /**
861      * @dev Returns whether `tokenId` exists.
862      *
863      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
864      *
865      * Tokens start existing when they are minted (`_mint`),
866      */
867     function _exists(uint256 tokenId) internal view returns (bool) {
868         return
869             _startTokenId() <= tokenId &&
870             tokenId < _currentIndex && // If within bounds,
871             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
872     }
873 
874     /**
875      * @dev Equivalent to `_safeMint(to, quantity, '')`.
876      */
877     function _safeMint(address to, uint256 quantity) internal {
878         _safeMint(to, quantity, '');
879     }
880 
881     /**
882      * @dev Safely mints `quantity` tokens and transfers them to `to`.
883      *
884      * Requirements:
885      *
886      * - If `to` refers to a smart contract, it must implement
887      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
888      * - `quantity` must be greater than 0.
889      *
890      * Emits a {Transfer} event.
891      */
892     function _safeMint(
893         address to,
894         uint256 quantity,
895         bytes memory _data
896     ) internal {
897         uint256 startTokenId = _currentIndex;
898         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
899         if (quantity == 0) revert MintZeroQuantity();
900 
901         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
902 
903         // Overflows are incredibly unrealistic.
904         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
905         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
906         unchecked {
907             // Updates:
908             // - `balance += quantity`.
909             // - `numberMinted += quantity`.
910             //
911             // We can directly add to the balance and number minted.
912             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
913 
914             // Updates:
915             // - `address` to the owner.
916             // - `startTimestamp` to the timestamp of minting.
917             // - `burned` to `false`.
918             // - `nextInitialized` to `quantity == 1`.
919             _packedOwnerships[startTokenId] =
920                 _addressToUint256(to) |
921                 (block.timestamp << BITPOS_START_TIMESTAMP) |
922                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
923 
924             uint256 updatedIndex = startTokenId;
925             uint256 end = updatedIndex + quantity;
926 
927             if (to.code.length != 0) {
928                 do {
929                     emit Transfer(address(0), to, updatedIndex);
930                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
931                         revert TransferToNonERC721ReceiverImplementer();
932                     }
933                 } while (updatedIndex < end);
934                 // Reentrancy protection
935                 if (_currentIndex != startTokenId) revert();
936             } else {
937                 do {
938                     emit Transfer(address(0), to, updatedIndex++);
939                 } while (updatedIndex < end);
940             }
941             _currentIndex = updatedIndex;
942         }
943         _afterTokenTransfers(address(0), to, startTokenId, quantity);
944     }
945 
946     /**
947      * @dev Mints `quantity` tokens and transfers them to `to`.
948      *
949      * Requirements:
950      *
951      * - `to` cannot be the zero address.
952      * - `quantity` must be greater than 0.
953      *
954      * Emits a {Transfer} event.
955      */
956     function _mint(address to, uint256 quantity) internal {
957         uint256 startTokenId = _currentIndex;
958         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
959         if (quantity == 0) revert MintZeroQuantity();
960 
961         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
962 
963         // Overflows are incredibly unrealistic.
964         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
965         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
966         unchecked {
967             // Updates:
968             // - `balance += quantity`.
969             // - `numberMinted += quantity`.
970             //
971             // We can directly add to the balance and number minted.
972             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
973 
974             // Updates:
975             // - `address` to the owner.
976             // - `startTimestamp` to the timestamp of minting.
977             // - `burned` to `false`.
978             // - `nextInitialized` to `quantity == 1`.
979             _packedOwnerships[startTokenId] =
980                 _addressToUint256(to) |
981                 (block.timestamp << BITPOS_START_TIMESTAMP) |
982                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
983 
984             uint256 updatedIndex = startTokenId;
985             uint256 end = updatedIndex + quantity;
986 
987             do {
988                 emit Transfer(address(0), to, updatedIndex++);
989             } while (updatedIndex < end);
990 
991             _currentIndex = updatedIndex;
992         }
993         _afterTokenTransfers(address(0), to, startTokenId, quantity);
994     }
995 
996     /**
997      * @dev Transfers `tokenId` from `from` to `to`.
998      *
999      * Requirements:
1000      *
1001      * - `to` cannot be the zero address.
1002      * - `tokenId` token must be owned by `from`.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _transfer(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) private {
1011         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1012 
1013         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1014 
1015         address approvedAddress = _tokenApprovals[tokenId];
1016 
1017         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1018             isApprovedForAll(from, _msgSenderERC721A()) ||
1019             approvedAddress == _msgSenderERC721A());
1020 
1021         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1022         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1023 
1024         _beforeTokenTransfers(from, to, tokenId, 1);
1025 
1026         // Clear approvals from the previous owner.
1027         if (_addressToUint256(approvedAddress) != 0) {
1028             delete _tokenApprovals[tokenId];
1029         }
1030 
1031         // Underflow of the sender's balance is impossible because we check for
1032         // ownership above and the recipient's balance can't realistically overflow.
1033         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1034         unchecked {
1035             // We can directly increment and decrement the balances.
1036             --_packedAddressData[from]; // Updates: `balance -= 1`.
1037             ++_packedAddressData[to]; // Updates: `balance += 1`.
1038 
1039             // Updates:
1040             // - `address` to the next owner.
1041             // - `startTimestamp` to the timestamp of transfering.
1042             // - `burned` to `false`.
1043             // - `nextInitialized` to `true`.
1044             _packedOwnerships[tokenId] =
1045                 _addressToUint256(to) |
1046                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1047                 BITMASK_NEXT_INITIALIZED;
1048 
1049             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1050             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1051                 uint256 nextTokenId = tokenId + 1;
1052                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1053                 if (_packedOwnerships[nextTokenId] == 0) {
1054                     // If the next slot is within bounds.
1055                     if (nextTokenId != _currentIndex) {
1056                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1057                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1058                     }
1059                 }
1060             }
1061         }
1062 
1063         emit Transfer(from, to, tokenId);
1064         _afterTokenTransfers(from, to, tokenId, 1);
1065     }
1066 
1067     /**
1068      * @dev Equivalent to `_burn(tokenId, false)`.
1069      */
1070     function _burn(uint256 tokenId) internal virtual {
1071         _burn(tokenId, false);
1072     }
1073 
1074     /**
1075      * @dev Destroys `tokenId`.
1076      * The approval is cleared when the token is burned.
1077      *
1078      * Requirements:
1079      *
1080      * - `tokenId` must exist.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1085         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1086 
1087         address from = address(uint160(prevOwnershipPacked));
1088         address approvedAddress = _tokenApprovals[tokenId];
1089 
1090         if (approvalCheck) {
1091             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1092                 isApprovedForAll(from, _msgSenderERC721A()) ||
1093                 approvedAddress == _msgSenderERC721A());
1094 
1095             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1096         }
1097 
1098         _beforeTokenTransfers(from, address(0), tokenId, 1);
1099 
1100         // Clear approvals from the previous owner.
1101         if (_addressToUint256(approvedAddress) != 0) {
1102             delete _tokenApprovals[tokenId];
1103         }
1104 
1105         // Underflow of the sender's balance is impossible because we check for
1106         // ownership above and the recipient's balance can't realistically overflow.
1107         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1108         unchecked {
1109             // Updates:
1110             // - `balance -= 1`.
1111             // - `numberBurned += 1`.
1112             //
1113             // We can directly decrement the balance, and increment the number burned.
1114             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1115             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1116 
1117             // Updates:
1118             // - `address` to the last owner.
1119             // - `startTimestamp` to the timestamp of burning.
1120             // - `burned` to `true`.
1121             // - `nextInitialized` to `true`.
1122             _packedOwnerships[tokenId] =
1123                 _addressToUint256(from) |
1124                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1125                 BITMASK_BURNED |
1126                 BITMASK_NEXT_INITIALIZED;
1127 
1128             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1129             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1130                 uint256 nextTokenId = tokenId + 1;
1131                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1132                 if (_packedOwnerships[nextTokenId] == 0) {
1133                     // If the next slot is within bounds.
1134                     if (nextTokenId != _currentIndex) {
1135                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1136                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1137                     }
1138                 }
1139             }
1140         }
1141 
1142         emit Transfer(from, address(0), tokenId);
1143         _afterTokenTransfers(from, address(0), tokenId, 1);
1144 
1145         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1146         unchecked {
1147             _burnCounter++;
1148         }
1149     }
1150 
1151     /**
1152      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1153      *
1154      * @param from address representing the previous owner of the given token ID
1155      * @param to target address that will receive the tokens
1156      * @param tokenId uint256 ID of the token to be transferred
1157      * @param _data bytes optional data to send along with the call
1158      * @return bool whether the call correctly returned the expected magic value
1159      */
1160     function _checkContractOnERC721Received(
1161         address from,
1162         address to,
1163         uint256 tokenId,
1164         bytes memory _data
1165     ) private returns (bool) {
1166         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1167             bytes4 retval
1168         ) {
1169             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1170         } catch (bytes memory reason) {
1171             if (reason.length == 0) {
1172                 revert TransferToNonERC721ReceiverImplementer();
1173             } else {
1174                 assembly {
1175                     revert(add(32, reason), mload(reason))
1176                 }
1177             }
1178         }
1179     }
1180 
1181     /**
1182      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1183      * And also called before burning one token.
1184      *
1185      * startTokenId - the first token id to be transferred
1186      * quantity - the amount to be transferred
1187      *
1188      * Calling conditions:
1189      *
1190      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1191      * transferred to `to`.
1192      * - When `from` is zero, `tokenId` will be minted for `to`.
1193      * - When `to` is zero, `tokenId` will be burned by `from`.
1194      * - `from` and `to` are never both zero.
1195      */
1196     function _beforeTokenTransfers(
1197         address from,
1198         address to,
1199         uint256 startTokenId,
1200         uint256 quantity
1201     ) internal virtual {}
1202 
1203     /**
1204      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1205      * minting.
1206      * And also called after one token has been burned.
1207      *
1208      * startTokenId - the first token id to be transferred
1209      * quantity - the amount to be transferred
1210      *
1211      * Calling conditions:
1212      *
1213      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1214      * transferred to `to`.
1215      * - When `from` is zero, `tokenId` has been minted for `to`.
1216      * - When `to` is zero, `tokenId` has been burned by `from`.
1217      * - `from` and `to` are never both zero.
1218      */
1219     function _afterTokenTransfers(
1220         address from,
1221         address to,
1222         uint256 startTokenId,
1223         uint256 quantity
1224     ) internal virtual {}
1225 
1226     /**
1227      * @dev Returns the message sender (defaults to `msg.sender`).
1228      *
1229      * If you are writing GSN compatible contracts, you need to override this function.
1230      */
1231     function _msgSenderERC721A() internal view virtual returns (address) {
1232         return msg.sender;
1233     }
1234 
1235     /**
1236      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1237      */
1238     function _toString(uint256 value) internal pure returns (string memory ptr) {
1239         assembly {
1240             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1241             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1242             // We will need 1 32-byte word to store the length,
1243             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1244             ptr := add(mload(0x40), 128)
1245             // Update the free memory pointer to allocate.
1246             mstore(0x40, ptr)
1247 
1248             // Cache the end of the memory to calculate the length later.
1249             let end := ptr
1250 
1251             // We write the string from the rightmost digit to the leftmost digit.
1252             // The following is essentially a do-while loop that also handles the zero case.
1253             // Costs a bit more than early returning for the zero case,
1254             // but cheaper in terms of deployment and overall runtime costs.
1255             for {
1256                 // Initialize and perform the first pass without check.
1257                 let temp := value
1258                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1259                 ptr := sub(ptr, 1)
1260                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1261                 mstore8(ptr, add(48, mod(temp, 10)))
1262                 temp := div(temp, 10)
1263             } temp {
1264                 // Keep dividing `temp` until zero.
1265                 temp := div(temp, 10)
1266             } { // Body of the for loop.
1267                 ptr := sub(ptr, 1)
1268                 mstore8(ptr, add(48, mod(temp, 10)))
1269             }
1270 
1271             let length := sub(end, ptr)
1272             // Move the pointer 32 bytes leftwards to make room for the length.
1273             ptr := sub(ptr, 32)
1274             // Store the length.
1275             mstore(ptr, length)
1276         }
1277     }
1278 }
1279 // File: contracts/schemurs.sol
1280 
1281 
1282 pragma solidity ^0.8.15;
1283 
1284 
1285 
1286 
1287 contract Schemurs is ERC721A, Ownable {
1288 
1289   using Strings for uint256;
1290   string public           baseURI;
1291   uint256 public constant maxSupply         = 4444;
1292   uint256 public          maxPerWallet      = 5;
1293   bool public             mintEnabled       = false;
1294 
1295   mapping(address => uint256) private _walletMints;
1296 
1297   constructor() ERC721A("Schemurs", "SCHEMURS"){
1298   }
1299 
1300   function mint(uint256 amt) external payable {
1301     require(mintEnabled, "Minting is not live yet.");
1302     require(_walletMints[_msgSender()] + amt < maxPerWallet + 5, "That's enough Schemurs for you!");
1303     require(msg.sender == tx.origin,"No bots, only true Schemurs!");
1304     require(totalSupply() + amt < maxSupply + 1, "Not enough Memurs left.");
1305 
1306     _walletMints[_msgSender()] += amt;
1307     _safeMint(msg.sender, amt);
1308   }
1309 
1310   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1311       require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1312 
1313 	  string memory currentBaseURI = _baseURI();
1314 	  return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json")) : "";
1315   }
1316 
1317   function toggleMinting() external onlyOwner {
1318       mintEnabled = !mintEnabled;
1319   }
1320 
1321   function numberMinted(address owner) public view returns (uint256) {
1322       return _numberMinted(owner);
1323   }
1324 
1325   function setBaseURI(string calldata baseURI_) external onlyOwner {
1326       baseURI = baseURI_;
1327   }
1328 
1329   function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1330       maxPerWallet = maxPerWallet_;
1331   }
1332 
1333   function _baseURI() internal view virtual override returns (string memory) {
1334       return baseURI;
1335   }
1336 
1337 }