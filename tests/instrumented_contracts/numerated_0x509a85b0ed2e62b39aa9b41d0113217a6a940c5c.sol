1 //  ____        _     _ _     _____                   
2 // | __ )  ___ | |__ | (_)_ _|_   _|____      ___ __  
3 // |  _ \ / _ \| '_ \| | | '_ \| |/ _ \ \ /\ / / '_ \ 
4 // | |_) | (_) | |_) | | | | | | | (_) \ V  V /| | | |
5 // |____/ \___/|_.__/|_|_|_| |_|_|\___/ \_/\_/ |_| |_|  
6 
7 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev String operations.
16  */
17 library Strings {
18     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
19     uint8 private constant _ADDRESS_LENGTH = 20;
20 
21     /**
22      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
23      */
24     function toString(uint256 value) internal pure returns (string memory) {
25         // Inspired by OraclizeAPI's implementation - MIT licence
26         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
27 
28         if (value == 0) {
29             return "0";
30         }
31         uint256 temp = value;
32         uint256 digits;
33         while (temp != 0) {
34             digits++;
35             temp /= 10;
36         }
37         bytes memory buffer = new bytes(digits);
38         while (value != 0) {
39             digits -= 1;
40             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
41             value /= 10;
42         }
43         return string(buffer);
44     }
45 
46     /**
47      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
48      */
49     function toHexString(uint256 value) internal pure returns (string memory) {
50         if (value == 0) {
51             return "0x00";
52         }
53         uint256 temp = value;
54         uint256 length = 0;
55         while (temp != 0) {
56             length++;
57             temp >>= 8;
58         }
59         return toHexString(value, length);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
64      */
65     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
66         bytes memory buffer = new bytes(2 * length + 2);
67         buffer[0] = "0";
68         buffer[1] = "x";
69         for (uint256 i = 2 * length + 1; i > 1; --i) {
70             buffer[i] = _HEX_SYMBOLS[value & 0xf];
71             value >>= 4;
72         }
73         require(value == 0, "Strings: hex length insufficient");
74         return string(buffer);
75     }
76 
77     /**
78      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
79      */
80     function toHexString(address addr) internal pure returns (string memory) {
81         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
82     }
83 }
84 
85 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
86 
87 
88 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Provides information about the current execution context, including the
94  * sender of the transaction and its data. While these are generally available
95  * via msg.sender and msg.data, they should not be accessed in such a direct
96  * manner, since when dealing with meta-transactions the account sending and
97  * paying for execution may not be the actual sender (as far as an application
98  * is concerned).
99  *
100  * This contract is only required for intermediate, library-like contracts.
101  */
102 abstract contract Context {
103     function _msgSender() internal view virtual returns (address) {
104         return msg.sender;
105     }
106 
107     function _msgData() internal view virtual returns (bytes calldata) {
108         return msg.data;
109     }
110 }
111 
112 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
113 
114 
115 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 
120 /**
121  * @dev Contract module which provides a basic access control mechanism, where
122  * there is an account (an owner) that can be granted exclusive access to
123  * specific functions.
124  *
125  * By default, the owner account will be the one that deploys the contract. This
126  * can later be changed with {transferOwnership}.
127  *
128  * This module is used through inheritance. It will make available the modifier
129  * `onlyOwner`, which can be applied to your functions to restrict their use to
130  * the owner.
131  */
132 abstract contract Ownable is Context {
133     address private _owner;
134 
135     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
136 
137     /**
138      * @dev Initializes the contract setting the deployer as the initial owner.
139      */
140     constructor() {
141         _transferOwnership(_msgSender());
142     }
143 
144     /**
145      * @dev Returns the address of the current owner.
146      */
147     function owner() public view virtual returns (address) {
148         return _owner;
149     }
150 
151     /**
152      * @dev Throws if called by any account other than the owner.
153      */
154     modifier onlyOwner() {
155         require(owner() == _msgSender(), "Ownable: caller is not the owner");
156         _;
157     }
158 
159     /**
160      * @dev Leaves the contract without owner. It will not be possible to call
161      * `onlyOwner` functions anymore. Can only be called by the current owner.
162      *
163      * NOTE: Renouncing ownership will leave the contract without an owner,
164      * thereby removing any functionality that is only available to the owner.
165      */
166     function renounceOwnership() public virtual onlyOwner {
167         _transferOwnership(address(0));
168     }
169 
170     /**
171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
172      * Can only be called by the current owner.
173      */
174     function transferOwnership(address newOwner) public virtual onlyOwner {
175         require(newOwner != address(0), "Ownable: new owner is the zero address");
176         _transferOwnership(newOwner);
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      * Internal function without access restriction.
182      */
183     function _transferOwnership(address newOwner) internal virtual {
184         address oldOwner = _owner;
185         _owner = newOwner;
186         emit OwnershipTransferred(oldOwner, newOwner);
187     }
188 }
189 
190 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
191 
192 
193 // ERC721A Contracts v4.0.0
194 // Creator: Chiru Labs
195 
196 pragma solidity ^0.8.4;
197 
198 /**
199  * @dev Interface of an ERC721A compliant contract.
200  */
201 interface IERC721A {
202     /**
203      * The caller must own the token or be an approved operator.
204      */
205     error ApprovalCallerNotOwnerNorApproved();
206 
207     /**
208      * The token does not exist.
209      */
210     error ApprovalQueryForNonexistentToken();
211 
212     /**
213      * The caller cannot approve to their own address.
214      */
215     error ApproveToCaller();
216 
217     /**
218      * The caller cannot approve to the current owner.
219      */
220     error ApprovalToCurrentOwner();
221 
222     /**
223      * Cannot query the balance for the zero address.
224      */
225     error BalanceQueryForZeroAddress();
226 
227     /**
228      * Cannot mint to the zero address.
229      */
230     error MintToZeroAddress();
231 
232     /**
233      * The quantity of tokens minted must be more than zero.
234      */
235     error MintZeroQuantity();
236 
237     /**
238      * The token does not exist.
239      */
240     error OwnerQueryForNonexistentToken();
241 
242     /**
243      * The caller must own the token or be an approved operator.
244      */
245     error TransferCallerNotOwnerNorApproved();
246 
247     /**
248      * The token must be owned by `from`.
249      */
250     error TransferFromIncorrectOwner();
251 
252     /**
253      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
254      */
255     error TransferToNonERC721ReceiverImplementer();
256 
257     /**
258      * Cannot transfer to the zero address.
259      */
260     error TransferToZeroAddress();
261 
262     /**
263      * The token does not exist.
264      */
265     error URIQueryForNonexistentToken();
266 
267     struct TokenOwnership {
268         // The address of the owner.
269         address addr;
270         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
271         uint64 startTimestamp;
272         // Whether the token has been burned.
273         bool burned;
274     }
275 
276     /**
277      * @dev Returns the total amount of tokens stored by the contract.
278      *
279      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
280      */
281     function totalSupply() external view returns (uint256);
282 
283     // ==============================
284     //            IERC165
285     // ==============================
286 
287     /**
288      * @dev Returns true if this contract implements the interface defined by
289      * `interfaceId`. See the corresponding
290      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
291      * to learn more about how these ids are created.
292      *
293      * This function call must use less than 30 000 gas.
294      */
295     function supportsInterface(bytes4 interfaceId) external view returns (bool);
296 
297     // ==============================
298     //            IERC721
299     // ==============================
300 
301     /**
302      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
303      */
304     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
305 
306     /**
307      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
308      */
309     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
310 
311     /**
312      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
313      */
314     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
315 
316     /**
317      * @dev Returns the number of tokens in ``owner``'s account.
318      */
319     function balanceOf(address owner) external view returns (uint256 balance);
320 
321     /**
322      * @dev Returns the owner of the `tokenId` token.
323      *
324      * Requirements:
325      *
326      * - `tokenId` must exist.
327      */
328     function ownerOf(uint256 tokenId) external view returns (address owner);
329 
330     /**
331      * @dev Safely transfers `tokenId` token from `from` to `to`.
332      *
333      * Requirements:
334      *
335      * - `from` cannot be the zero address.
336      * - `to` cannot be the zero address.
337      * - `tokenId` token must exist and be owned by `from`.
338      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
339      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
340      *
341      * Emits a {Transfer} event.
342      */
343     function safeTransferFrom(
344         address from,
345         address to,
346         uint256 tokenId,
347         bytes calldata data
348     ) external;
349 
350     /**
351      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
352      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
353      *
354      * Requirements:
355      *
356      * - `from` cannot be the zero address.
357      * - `to` cannot be the zero address.
358      * - `tokenId` token must exist and be owned by `from`.
359      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
360      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
361      *
362      * Emits a {Transfer} event.
363      */
364     function safeTransferFrom(
365         address from,
366         address to,
367         uint256 tokenId
368     ) external;
369 
370     /**
371      * @dev Transfers `tokenId` token from `from` to `to`.
372      *
373      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
374      *
375      * Requirements:
376      *
377      * - `from` cannot be the zero address.
378      * - `to` cannot be the zero address.
379      * - `tokenId` token must be owned by `from`.
380      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
381      *
382      * Emits a {Transfer} event.
383      */
384     function transferFrom(
385         address from,
386         address to,
387         uint256 tokenId
388     ) external;
389 
390     /**
391      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
392      * The approval is cleared when the token is transferred.
393      *
394      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
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
407      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
408      *
409      * Requirements:
410      *
411      * - The `operator` cannot be the caller.
412      *
413      * Emits an {ApprovalForAll} event.
414      */
415     function setApprovalForAll(address operator, bool _approved) external;
416 
417     /**
418      * @dev Returns the account approved for `tokenId` token.
419      *
420      * Requirements:
421      *
422      * - `tokenId` must exist.
423      */
424     function getApproved(uint256 tokenId) external view returns (address operator);
425 
426     /**
427      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
428      *
429      * See {setApprovalForAll}
430      */
431     function isApprovedForAll(address owner, address operator) external view returns (bool);
432 
433     // ==============================
434     //        IERC721Metadata
435     // ==============================
436 
437     /**
438      * @dev Returns the token collection name.
439      */
440     function name() external view returns (string memory);
441 
442     /**
443      * @dev Returns the token collection symbol.
444      */
445     function symbol() external view returns (string memory);
446 
447     /**
448      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
449      */
450     function tokenURI(uint256 tokenId) external view returns (string memory);
451 }
452 
453 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
454 
455 
456 // ERC721A Contracts v4.0.0
457 // Creator: Chiru Labs
458 
459 pragma solidity ^0.8.4;
460 
461 
462 /**
463  * @dev ERC721 token receiver interface.
464  */
465 interface ERC721A__IERC721Receiver {
466     function onERC721Received(
467         address operator,
468         address from,
469         uint256 tokenId,
470         bytes calldata data
471     ) external returns (bytes4);
472 }
473 
474 /**
475  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
476  * the Metadata extension. Built to optimize for lower gas during batch mints.
477  *
478  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
479  *
480  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
481  *
482  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
483  */
484 contract ERC721A is IERC721A {
485     // Mask of an entry in packed address data.
486     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
487 
488     // The bit position of `numberMinted` in packed address data.
489     uint256 private constant BITPOS_NUMBER_MINTED = 64;
490 
491     // The bit position of `numberBurned` in packed address data.
492     uint256 private constant BITPOS_NUMBER_BURNED = 128;
493 
494     // The bit position of `aux` in packed address data.
495     uint256 private constant BITPOS_AUX = 192;
496 
497     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
498     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
499 
500     // The bit position of `startTimestamp` in packed ownership.
501     uint256 private constant BITPOS_START_TIMESTAMP = 160;
502 
503     // The bit mask of the `burned` bit in packed ownership.
504     uint256 private constant BITMASK_BURNED = 1 << 224;
505 
506     // The bit position of the `nextInitialized` bit in packed ownership.
507     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
508 
509     // The bit mask of the `nextInitialized` bit in packed ownership.
510     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
511 
512     // The tokenId of the next token to be minted.
513     uint256 private _currentIndex;
514 
515     // The number of tokens burned.
516     uint256 private _burnCounter;
517 
518     // Token name
519     string private _name;
520 
521     // Token symbol
522     string private _symbol;
523 
524     // Mapping from token ID to ownership details
525     // An empty struct value does not necessarily mean the token is unowned.
526     // See `_packedOwnershipOf` implementation for details.
527     //
528     // Bits Layout:
529     // - [0..159]   `addr`
530     // - [160..223] `startTimestamp`
531     // - [224]      `burned`
532     // - [225]      `nextInitialized`
533     mapping(uint256 => uint256) private _packedOwnerships;
534 
535     // Mapping owner address to address data.
536     //
537     // Bits Layout:
538     // - [0..63]    `balance`
539     // - [64..127]  `numberMinted`
540     // - [128..191] `numberBurned`
541     // - [192..255] `aux`
542     mapping(address => uint256) private _packedAddressData;
543 
544     // Mapping from token ID to approved address.
545     mapping(uint256 => address) private _tokenApprovals;
546 
547     // Mapping from owner to operator approvals
548     mapping(address => mapping(address => bool)) private _operatorApprovals;
549 
550     constructor(string memory name_, string memory symbol_) {
551         _name = name_;
552         _symbol = symbol_;
553         _currentIndex = _startTokenId();
554     }
555 
556     /**
557      * @dev Returns the starting token ID.
558      * To change the starting token ID, please override this function.
559      */
560     function _startTokenId() internal view virtual returns (uint256) {
561         return 0;
562     }
563 
564     /**
565      * @dev Returns the next token ID to be minted.
566      */
567     function _nextTokenId() internal view returns (uint256) {
568         return _currentIndex;
569     }
570 
571     /**
572      * @dev Returns the total number of tokens in existence.
573      * Burned tokens will reduce the count.
574      * To get the total number of tokens minted, please see `_totalMinted`.
575      */
576     function totalSupply() public view override returns (uint256) {
577         // Counter underflow is impossible as _burnCounter cannot be incremented
578         // more than `_currentIndex - _startTokenId()` times.
579         unchecked {
580             return _currentIndex - _burnCounter - _startTokenId();
581         }
582     }
583 
584     /**
585      * @dev Returns the total amount of tokens minted in the contract.
586      */
587     function _totalMinted() internal view returns (uint256) {
588         // Counter underflow is impossible as _currentIndex does not decrement,
589         // and it is initialized to `_startTokenId()`
590         unchecked {
591             return _currentIndex - _startTokenId();
592         }
593     }
594 
595     /**
596      * @dev Returns the total number of tokens burned.
597      */
598     function _totalBurned() internal view returns (uint256) {
599         return _burnCounter;
600     }
601 
602     /**
603      * @dev See {IERC165-supportsInterface}.
604      */
605     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
606         // The interface IDs are constants representing the first 4 bytes of the XOR of
607         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
608         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
609         return
610             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
611             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
612             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
613     }
614 
615     /**
616      * @dev See {IERC721-balanceOf}.
617      */
618     function balanceOf(address owner) public view override returns (uint256) {
619         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
620         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
621     }
622 
623     /**
624      * Returns the number of tokens minted by `owner`.
625      */
626     function _numberMinted(address owner) internal view returns (uint256) {
627         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
628     }
629 
630     /**
631      * Returns the number of tokens burned by or on behalf of `owner`.
632      */
633     function _numberBurned(address owner) internal view returns (uint256) {
634         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
635     }
636 
637     /**
638      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
639      */
640     function _getAux(address owner) internal view returns (uint64) {
641         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
642     }
643 
644     /**
645      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
646      * If there are multiple variables, please pack them into a uint64.
647      */
648     function _setAux(address owner, uint64 aux) internal {
649         uint256 packed = _packedAddressData[owner];
650         uint256 auxCasted;
651         assembly { // Cast aux without masking.
652             auxCasted := aux
653         }
654         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
655         _packedAddressData[owner] = packed;
656     }
657 
658     /**
659      * Returns the packed ownership data of `tokenId`.
660      */
661     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
662         uint256 curr = tokenId;
663 
664         unchecked {
665             if (_startTokenId() <= curr)
666                 if (curr < _currentIndex) {
667                     uint256 packed = _packedOwnerships[curr];
668                     // If not burned.
669                     if (packed & BITMASK_BURNED == 0) {
670                         // Invariant:
671                         // There will always be an ownership that has an address and is not burned
672                         // before an ownership that does not have an address and is not burned.
673                         // Hence, curr will not underflow.
674                         //
675                         // We can directly compare the packed value.
676                         // If the address is zero, packed is zero.
677                         while (packed == 0) {
678                             packed = _packedOwnerships[--curr];
679                         }
680                         return packed;
681                     }
682                 }
683         }
684         revert OwnerQueryForNonexistentToken();
685     }
686 
687     /**
688      * Returns the unpacked `TokenOwnership` struct from `packed`.
689      */
690     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
691         ownership.addr = address(uint160(packed));
692         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
693         ownership.burned = packed & BITMASK_BURNED != 0;
694     }
695 
696     /**
697      * Returns the unpacked `TokenOwnership` struct at `index`.
698      */
699     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
700         return _unpackedOwnership(_packedOwnerships[index]);
701     }
702 
703     /**
704      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
705      */
706     function _initializeOwnershipAt(uint256 index) internal {
707         if (_packedOwnerships[index] == 0) {
708             _packedOwnerships[index] = _packedOwnershipOf(index);
709         }
710     }
711 
712     /**
713      * Gas spent here starts off proportional to the maximum mint batch size.
714      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
715      */
716     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
717         return _unpackedOwnership(_packedOwnershipOf(tokenId));
718     }
719 
720     /**
721      * @dev See {IERC721-ownerOf}.
722      */
723     function ownerOf(uint256 tokenId) public view override returns (address) {
724         return address(uint160(_packedOwnershipOf(tokenId)));
725     }
726 
727     /**
728      * @dev See {IERC721Metadata-name}.
729      */
730     function name() public view virtual override returns (string memory) {
731         return _name;
732     }
733 
734     /**
735      * @dev See {IERC721Metadata-symbol}.
736      */
737     function symbol() public view virtual override returns (string memory) {
738         return _symbol;
739     }
740 
741     /**
742      * @dev See {IERC721Metadata-tokenURI}.
743      */
744     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
745         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
746 
747         string memory baseURI = _baseURI();
748         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
749     }
750 
751     /**
752      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
753      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
754      * by default, can be overriden in child contracts.
755      */
756     function _baseURI() internal view virtual returns (string memory) {
757         return '';
758     }
759 
760     /**
761      * @dev Casts the address to uint256 without masking.
762      */
763     function _addressToUint256(address value) private pure returns (uint256 result) {
764         assembly {
765             result := value
766         }
767     }
768 
769     /**
770      * @dev Casts the boolean to uint256 without branching.
771      */
772     function _boolToUint256(bool value) private pure returns (uint256 result) {
773         assembly {
774             result := value
775         }
776     }
777 
778     /**
779      * @dev See {IERC721-approve}.
780      */
781     function approve(address to, uint256 tokenId) public override {
782         address owner = address(uint160(_packedOwnershipOf(tokenId)));
783         if (to == owner) revert ApprovalToCurrentOwner();
784 
785         if (_msgSenderERC721A() != owner)
786             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
787                 revert ApprovalCallerNotOwnerNorApproved();
788             }
789 
790         _tokenApprovals[tokenId] = to;
791         emit Approval(owner, to, tokenId);
792     }
793 
794     /**
795      * @dev See {IERC721-getApproved}.
796      */
797     function getApproved(uint256 tokenId) public view override returns (address) {
798         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
799 
800         return _tokenApprovals[tokenId];
801     }
802 
803     /**
804      * @dev See {IERC721-setApprovalForAll}.
805      */
806     function setApprovalForAll(address operator, bool approved) public virtual override {
807         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
808 
809         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
810         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
811     }
812 
813     /**
814      * @dev See {IERC721-isApprovedForAll}.
815      */
816     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
817         return _operatorApprovals[owner][operator];
818     }
819 
820     /**
821      * @dev See {IERC721-transferFrom}.
822      */
823     function transferFrom(
824         address from,
825         address to,
826         uint256 tokenId
827     ) public virtual override {
828         _transfer(from, to, tokenId);
829     }
830 
831     /**
832      * @dev See {IERC721-safeTransferFrom}.
833      */
834     function safeTransferFrom(
835         address from,
836         address to,
837         uint256 tokenId
838     ) public virtual override {
839         safeTransferFrom(from, to, tokenId, '');
840     }
841 
842     /**
843      * @dev See {IERC721-safeTransferFrom}.
844      */
845     function safeTransferFrom(
846         address from,
847         address to,
848         uint256 tokenId,
849         bytes memory _data
850     ) public virtual override {
851         _transfer(from, to, tokenId);
852         if (to.code.length != 0)
853             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
854                 revert TransferToNonERC721ReceiverImplementer();
855             }
856     }
857 
858     /**
859      * @dev Returns whether `tokenId` exists.
860      *
861      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
862      *
863      * Tokens start existing when they are minted (`_mint`),
864      */
865     function _exists(uint256 tokenId) internal view returns (bool) {
866         return
867             _startTokenId() <= tokenId &&
868             tokenId < _currentIndex && // If within bounds,
869             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
870     }
871 
872     /**
873      * @dev Equivalent to `_safeMint(to, quantity, '')`.
874      */
875     function _safeMint(address to, uint256 quantity) internal {
876         _safeMint(to, quantity, '');
877     }
878 
879     /**
880      * @dev Safely mints `quantity` tokens and transfers them to `to`.
881      *
882      * Requirements:
883      *
884      * - If `to` refers to a smart contract, it must implement
885      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
886      * - `quantity` must be greater than 0.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _safeMint(
891         address to,
892         uint256 quantity,
893         bytes memory _data
894     ) internal {
895         uint256 startTokenId = _currentIndex;
896         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
897         if (quantity == 0) revert MintZeroQuantity();
898 
899         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
900 
901         // Overflows are incredibly unrealistic.
902         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
903         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
904         unchecked {
905             // Updates:
906             // - `balance += quantity`.
907             // - `numberMinted += quantity`.
908             //
909             // We can directly add to the balance and number minted.
910             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
911 
912             // Updates:
913             // - `address` to the owner.
914             // - `startTimestamp` to the timestamp of minting.
915             // - `burned` to `false`.
916             // - `nextInitialized` to `quantity == 1`.
917             _packedOwnerships[startTokenId] =
918                 _addressToUint256(to) |
919                 (block.timestamp << BITPOS_START_TIMESTAMP) |
920                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
921 
922             uint256 updatedIndex = startTokenId;
923             uint256 end = updatedIndex + quantity;
924 
925             if (to.code.length != 0) {
926                 do {
927                     emit Transfer(address(0), to, updatedIndex);
928                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
929                         revert TransferToNonERC721ReceiverImplementer();
930                     }
931                 } while (updatedIndex < end);
932                 // Reentrancy protection
933                 if (_currentIndex != startTokenId) revert();
934             } else {
935                 do {
936                     emit Transfer(address(0), to, updatedIndex++);
937                 } while (updatedIndex < end);
938             }
939             _currentIndex = updatedIndex;
940         }
941         _afterTokenTransfers(address(0), to, startTokenId, quantity);
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
952      * Emits a {Transfer} event.
953      */
954     function _mint(address to, uint256 quantity) internal {
955         uint256 startTokenId = _currentIndex;
956         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
957         if (quantity == 0) revert MintZeroQuantity();
958 
959         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
960 
961         // Overflows are incredibly unrealistic.
962         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
963         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
964         unchecked {
965             // Updates:
966             // - `balance += quantity`.
967             // - `numberMinted += quantity`.
968             //
969             // We can directly add to the balance and number minted.
970             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
971 
972             // Updates:
973             // - `address` to the owner.
974             // - `startTimestamp` to the timestamp of minting.
975             // - `burned` to `false`.
976             // - `nextInitialized` to `quantity == 1`.
977             _packedOwnerships[startTokenId] =
978                 _addressToUint256(to) |
979                 (block.timestamp << BITPOS_START_TIMESTAMP) |
980                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
981 
982             uint256 updatedIndex = startTokenId;
983             uint256 end = updatedIndex + quantity;
984 
985             do {
986                 emit Transfer(address(0), to, updatedIndex++);
987             } while (updatedIndex < end);
988 
989             _currentIndex = updatedIndex;
990         }
991         _afterTokenTransfers(address(0), to, startTokenId, quantity);
992     }
993 
994     /**
995      * @dev Transfers `tokenId` from `from` to `to`.
996      *
997      * Requirements:
998      *
999      * - `to` cannot be the zero address.
1000      * - `tokenId` token must be owned by `from`.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _transfer(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) private {
1009         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1010 
1011         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1012 
1013         address approvedAddress = _tokenApprovals[tokenId];
1014 
1015         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1016             isApprovedForAll(from, _msgSenderERC721A()) ||
1017             approvedAddress == _msgSenderERC721A());
1018 
1019         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1020         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1021 
1022         _beforeTokenTransfers(from, to, tokenId, 1);
1023 
1024         // Clear approvals from the previous owner.
1025         if (_addressToUint256(approvedAddress) != 0) {
1026             delete _tokenApprovals[tokenId];
1027         }
1028 
1029         // Underflow of the sender's balance is impossible because we check for
1030         // ownership above and the recipient's balance can't realistically overflow.
1031         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1032         unchecked {
1033             // We can directly increment and decrement the balances.
1034             --_packedAddressData[from]; // Updates: `balance -= 1`.
1035             ++_packedAddressData[to]; // Updates: `balance += 1`.
1036 
1037             // Updates:
1038             // - `address` to the next owner.
1039             // - `startTimestamp` to the timestamp of transfering.
1040             // - `burned` to `false`.
1041             // - `nextInitialized` to `true`.
1042             _packedOwnerships[tokenId] =
1043                 _addressToUint256(to) |
1044                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1045                 BITMASK_NEXT_INITIALIZED;
1046 
1047             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1048             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1049                 uint256 nextTokenId = tokenId + 1;
1050                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1051                 if (_packedOwnerships[nextTokenId] == 0) {
1052                     // If the next slot is within bounds.
1053                     if (nextTokenId != _currentIndex) {
1054                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1055                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1056                     }
1057                 }
1058             }
1059         }
1060 
1061         emit Transfer(from, to, tokenId);
1062         _afterTokenTransfers(from, to, tokenId, 1);
1063     }
1064 
1065     /**
1066      * @dev Equivalent to `_burn(tokenId, false)`.
1067      */
1068     function _burn(uint256 tokenId) internal virtual {
1069         _burn(tokenId, false);
1070     }
1071 
1072     /**
1073      * @dev Destroys `tokenId`.
1074      * The approval is cleared when the token is burned.
1075      *
1076      * Requirements:
1077      *
1078      * - `tokenId` must exist.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1083         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1084 
1085         address from = address(uint160(prevOwnershipPacked));
1086         address approvedAddress = _tokenApprovals[tokenId];
1087 
1088         if (approvalCheck) {
1089             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1090                 isApprovedForAll(from, _msgSenderERC721A()) ||
1091                 approvedAddress == _msgSenderERC721A());
1092 
1093             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1094         }
1095 
1096         _beforeTokenTransfers(from, address(0), tokenId, 1);
1097 
1098         // Clear approvals from the previous owner.
1099         if (_addressToUint256(approvedAddress) != 0) {
1100             delete _tokenApprovals[tokenId];
1101         }
1102 
1103         // Underflow of the sender's balance is impossible because we check for
1104         // ownership above and the recipient's balance can't realistically overflow.
1105         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1106         unchecked {
1107             // Updates:
1108             // - `balance -= 1`.
1109             // - `numberBurned += 1`.
1110             //
1111             // We can directly decrement the balance, and increment the number burned.
1112             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1113             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1114 
1115             // Updates:
1116             // - `address` to the last owner.
1117             // - `startTimestamp` to the timestamp of burning.
1118             // - `burned` to `true`.
1119             // - `nextInitialized` to `true`.
1120             _packedOwnerships[tokenId] =
1121                 _addressToUint256(from) |
1122                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1123                 BITMASK_BURNED |
1124                 BITMASK_NEXT_INITIALIZED;
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
1140         emit Transfer(from, address(0), tokenId);
1141         _afterTokenTransfers(from, address(0), tokenId, 1);
1142 
1143         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1144         unchecked {
1145             _burnCounter++;
1146         }
1147     }
1148 
1149     /**
1150      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1151      *
1152      * @param from address representing the previous owner of the given token ID
1153      * @param to target address that will receive the tokens
1154      * @param tokenId uint256 ID of the token to be transferred
1155      * @param _data bytes optional data to send along with the call
1156      * @return bool whether the call correctly returned the expected magic value
1157      */
1158     function _checkContractOnERC721Received(
1159         address from,
1160         address to,
1161         uint256 tokenId,
1162         bytes memory _data
1163     ) private returns (bool) {
1164         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1165             bytes4 retval
1166         ) {
1167             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1168         } catch (bytes memory reason) {
1169             if (reason.length == 0) {
1170                 revert TransferToNonERC721ReceiverImplementer();
1171             } else {
1172                 assembly {
1173                     revert(add(32, reason), mload(reason))
1174                 }
1175             }
1176         }
1177     }
1178 
1179     /**
1180      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1181      * And also called before burning one token.
1182      *
1183      * startTokenId - the first token id to be transferred
1184      * quantity - the amount to be transferred
1185      *
1186      * Calling conditions:
1187      *
1188      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1189      * transferred to `to`.
1190      * - When `from` is zero, `tokenId` will be minted for `to`.
1191      * - When `to` is zero, `tokenId` will be burned by `from`.
1192      * - `from` and `to` are never both zero.
1193      */
1194     function _beforeTokenTransfers(
1195         address from,
1196         address to,
1197         uint256 startTokenId,
1198         uint256 quantity
1199     ) internal virtual {}
1200 
1201     /**
1202      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1203      * minting.
1204      * And also called after one token has been burned.
1205      *
1206      * startTokenId - the first token id to be transferred
1207      * quantity - the amount to be transferred
1208      *
1209      * Calling conditions:
1210      *
1211      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1212      * transferred to `to`.
1213      * - When `from` is zero, `tokenId` has been minted for `to`.
1214      * - When `to` is zero, `tokenId` has been burned by `from`.
1215      * - `from` and `to` are never both zero.
1216      */
1217     function _afterTokenTransfers(
1218         address from,
1219         address to,
1220         uint256 startTokenId,
1221         uint256 quantity
1222     ) internal virtual {}
1223 
1224     /**
1225      * @dev Returns the message sender (defaults to `msg.sender`).
1226      *
1227      * If you are writing GSN compatible contracts, you need to override this function.
1228      */
1229     function _msgSenderERC721A() internal view virtual returns (address) {
1230         return msg.sender;
1231     }
1232 
1233     /**
1234      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1235      */
1236     function _toString(uint256 value) internal pure returns (string memory ptr) {
1237         assembly {
1238             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1239             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1240             // We will need 1 32-byte word to store the length,
1241             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1242             ptr := add(mload(0x40), 128)
1243             // Update the free memory pointer to allocate.
1244             mstore(0x40, ptr)
1245 
1246             // Cache the end of the memory to calculate the length later.
1247             let end := ptr
1248 
1249             // We write the string from the rightmost digit to the leftmost digit.
1250             // The following is essentially a do-while loop that also handles the zero case.
1251             // Costs a bit more than early returning for the zero case,
1252             // but cheaper in terms of deployment and overall runtime costs.
1253             for {
1254                 // Initialize and perform the first pass without check.
1255                 let temp := value
1256                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1257                 ptr := sub(ptr, 1)
1258                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1259                 mstore8(ptr, add(48, mod(temp, 10)))
1260                 temp := div(temp, 10)
1261             } temp {
1262                 // Keep dividing `temp` until zero.
1263                 temp := div(temp, 10)
1264             } { // Body of the for loop.
1265                 ptr := sub(ptr, 1)
1266                 mstore8(ptr, add(48, mod(temp, 10)))
1267             }
1268 
1269             let length := sub(end, ptr)
1270             // Move the pointer 32 bytes leftwards to make room for the length.
1271             ptr := sub(ptr, 32)
1272             // Store the length.
1273             mstore(ptr, length)
1274         }
1275     }
1276 }
1277 
1278 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/IERC721AQueryable.sol
1279 
1280 
1281 // ERC721A Contracts v4.0.0
1282 // Creator: Chiru Labs
1283 
1284 pragma solidity ^0.8.4;
1285 
1286 
1287 /**
1288  * @dev Interface of an ERC721AQueryable compliant contract.
1289  */
1290 interface IERC721AQueryable is IERC721A {
1291     /**
1292      * Invalid query range (`start` >= `stop`).
1293      */
1294     error InvalidQueryRange();
1295 
1296     /**
1297      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1298      *
1299      * If the `tokenId` is out of bounds:
1300      *   - `addr` = `address(0)`
1301      *   - `startTimestamp` = `0`
1302      *   - `burned` = `false`
1303      *
1304      * If the `tokenId` is burned:
1305      *   - `addr` = `<Address of owner before token was burned>`
1306      *   - `startTimestamp` = `<Timestamp when token was burned>`
1307      *   - `burned = `true`
1308      *
1309      * Otherwise:
1310      *   - `addr` = `<Address of owner>`
1311      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1312      *   - `burned = `false`
1313      */
1314     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1315 
1316     /**
1317      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1318      * See {ERC721AQueryable-explicitOwnershipOf}
1319      */
1320     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1321 
1322     /**
1323      * @dev Returns an array of token IDs owned by `owner`,
1324      * in the range [`start`, `stop`)
1325      * (i.e. `start <= tokenId < stop`).
1326      *
1327      * This function allows for tokens to be queried if the collection
1328      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1329      *
1330      * Requirements:
1331      *
1332      * - `start` < `stop`
1333      */
1334     function tokensOfOwnerIn(
1335         address owner,
1336         uint256 start,
1337         uint256 stop
1338     ) external view returns (uint256[] memory);
1339 
1340     /**
1341      * @dev Returns an array of token IDs owned by `owner`.
1342      *
1343      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1344      * It is meant to be called off-chain.
1345      *
1346      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1347      * multiple smaller scans if the collection is large enough to cause
1348      * an out-of-gas error (10K pfp collections should be fine).
1349      */
1350     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1351 }
1352 
1353 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/ERC721AQueryable.sol
1354 
1355 
1356 // ERC721A Contracts v4.0.0
1357 // Creator: Chiru Labs
1358 
1359 pragma solidity ^0.8.4;
1360 
1361 
1362 
1363 /**
1364  * @title ERC721A Queryable
1365  * @dev ERC721A subclass with convenience query functions.
1366  */
1367 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1368     /**
1369      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1370      *
1371      * If the `tokenId` is out of bounds:
1372      *   - `addr` = `address(0)`
1373      *   - `startTimestamp` = `0`
1374      *   - `burned` = `false`
1375      *
1376      * If the `tokenId` is burned:
1377      *   - `addr` = `<Address of owner before token was burned>`
1378      *   - `startTimestamp` = `<Timestamp when token was burned>`
1379      *   - `burned = `true`
1380      *
1381      * Otherwise:
1382      *   - `addr` = `<Address of owner>`
1383      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1384      *   - `burned = `false`
1385      */
1386     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1387         TokenOwnership memory ownership;
1388         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1389             return ownership;
1390         }
1391         ownership = _ownershipAt(tokenId);
1392         if (ownership.burned) {
1393             return ownership;
1394         }
1395         return _ownershipOf(tokenId);
1396     }
1397 
1398     /**
1399      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1400      * See {ERC721AQueryable-explicitOwnershipOf}
1401      */
1402     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1403         unchecked {
1404             uint256 tokenIdsLength = tokenIds.length;
1405             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1406             for (uint256 i; i != tokenIdsLength; ++i) {
1407                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1408             }
1409             return ownerships;
1410         }
1411     }
1412 
1413     /**
1414      * @dev Returns an array of token IDs owned by `owner`,
1415      * in the range [`start`, `stop`)
1416      * (i.e. `start <= tokenId < stop`).
1417      *
1418      * This function allows for tokens to be queried if the collection
1419      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1420      *
1421      * Requirements:
1422      *
1423      * - `start` < `stop`
1424      */
1425     function tokensOfOwnerIn(
1426         address owner,
1427         uint256 start,
1428         uint256 stop
1429     ) external view override returns (uint256[] memory) {
1430         unchecked {
1431             if (start >= stop) revert InvalidQueryRange();
1432             uint256 tokenIdsIdx;
1433             uint256 stopLimit = _nextTokenId();
1434             // Set `start = max(start, _startTokenId())`.
1435             if (start < _startTokenId()) {
1436                 start = _startTokenId();
1437             }
1438             // Set `stop = min(stop, stopLimit)`.
1439             if (stop > stopLimit) {
1440                 stop = stopLimit;
1441             }
1442             uint256 tokenIdsMaxLength = balanceOf(owner);
1443             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1444             // to cater for cases where `balanceOf(owner)` is too big.
1445             if (start < stop) {
1446                 uint256 rangeLength = stop - start;
1447                 if (rangeLength < tokenIdsMaxLength) {
1448                     tokenIdsMaxLength = rangeLength;
1449                 }
1450             } else {
1451                 tokenIdsMaxLength = 0;
1452             }
1453             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1454             if (tokenIdsMaxLength == 0) {
1455                 return tokenIds;
1456             }
1457             // We need to call `explicitOwnershipOf(start)`,
1458             // because the slot at `start` may not be initialized.
1459             TokenOwnership memory ownership = explicitOwnershipOf(start);
1460             address currOwnershipAddr;
1461             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1462             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1463             if (!ownership.burned) {
1464                 currOwnershipAddr = ownership.addr;
1465             }
1466             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1467                 ownership = _ownershipAt(i);
1468                 if (ownership.burned) {
1469                     continue;
1470                 }
1471                 if (ownership.addr != address(0)) {
1472                     currOwnershipAddr = ownership.addr;
1473                 }
1474                 if (currOwnershipAddr == owner) {
1475                     tokenIds[tokenIdsIdx++] = i;
1476                 }
1477             }
1478             // Downsize the array to fit.
1479             assembly {
1480                 mstore(tokenIds, tokenIdsIdx)
1481             }
1482             return tokenIds;
1483         }
1484     }
1485 
1486     /**
1487      * @dev Returns an array of token IDs owned by `owner`.
1488      *
1489      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1490      * It is meant to be called off-chain.
1491      *
1492      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1493      * multiple smaller scans if the collection is large enough to cause
1494      * an out-of-gas error (10K pfp collections should be fine).
1495      */
1496     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1497         unchecked {
1498             uint256 tokenIdsIdx;
1499             address currOwnershipAddr;
1500             uint256 tokenIdsLength = balanceOf(owner);
1501             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1502             TokenOwnership memory ownership;
1503             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1504                 ownership = _ownershipAt(i);
1505                 if (ownership.burned) {
1506                     continue;
1507                 }
1508                 if (ownership.addr != address(0)) {
1509                     currOwnershipAddr = ownership.addr;
1510                 }
1511                 if (currOwnershipAddr == owner) {
1512                     tokenIds[tokenIdsIdx++] = i;
1513                 }
1514             }
1515             return tokenIds;
1516         }
1517     }
1518 }
1519 
1520 // File: contracts/client.sol
1521 
1522 //SPDX-License-Identifier: MIT
1523 pragma solidity ^0.8.4;
1524 
1525 
1526 
1527 
1528 /*
1529 boblintown.sol
1530 
1531 Contract by @NftDoyler
1532 */
1533 
1534 contract boblintown is Ownable, ERC721A {
1535     uint256 constant public MAX_SUPPLY = 10000;
1536     uint256 public TEAM_MINT_MAX = 300;
1537 
1538     uint256 public publicPrice = 0.01 ether;
1539 
1540     uint256 constant public PUBLIC_MINT_LIMIT_TXN = 20;
1541     uint256 constant public PUBLIC_MINT_LIMIT = 100;
1542 
1543     uint256 public TOTAL_SUPPLY_TEAM;
1544 
1545     string public revealedURI;
1546     
1547     string public hiddenURI = "ipfs://QmNRmeU866cuR9cLXBM1xPTqWNMsMwpVhWBdLzp5AfyUKS";
1548 
1549     // OpenSea CONTRACT_URI - https://docs.opensea.io/docs/contract-level-metadata
1550     string public CONTRACT_URI = "ipfs://QmNRmeU866cuR9cLXBM1xPTqWNMsMwpVhWBdLzp5AfyUKS";
1551 
1552     bool public paused = true;
1553     bool public revealed = true;
1554 
1555     bool public freeSale = true;
1556     bool public publicSale = false;
1557 
1558     address constant internal DEV_ADDRESS = 0x9cfb858Cb2E4eEB746147CeD2269fF8f1a289ac7;
1559     address constant internal WEB_ADDRESS = 0x1816067dc325c0662FD59d512251b73AA6253e37;
1560     address public teamWallet = 0x574E531Ea800d6143de7619Df37bC61BD6593a62;
1561 
1562     mapping(address => bool) public userMintedFree;
1563     mapping(address => uint256) public numUserMints;
1564 
1565     constructor() ERC721A("boblintown", "BOBLIN") { }
1566 
1567     function _startTokenId() internal view virtual override returns (uint256) {
1568         return 1;
1569     }
1570 
1571     function refundOverpay(uint256 price) private {
1572         if (msg.value > price) {
1573             (bool succ, ) = payable(msg.sender).call{
1574                 value: (msg.value - price)
1575             }("");
1576             require(succ, "Transfer failed");
1577         }
1578         else if (msg.value < price) {
1579             revert("Not enough ETH sent");
1580         }
1581     }
1582 
1583     function teamMint(uint256 quantity) public payable mintCompliance(quantity) {
1584         require(msg.sender == teamWallet, "Team minting only");
1585         require(TOTAL_SUPPLY_TEAM + quantity <= TEAM_MINT_MAX, "No team mints left");
1586         require(totalSupply() >= 1000, "Team mints after free");
1587 
1588         TOTAL_SUPPLY_TEAM += quantity;
1589 
1590         _safeMint(msg.sender, quantity);
1591     }
1592     
1593     function freeMint(uint256 quantity) external payable mintCompliance(quantity) {
1594         require(freeSale, "Free sale inactive");
1595         require(msg.value == 0, "This phase is free");
1596         require(quantity <= 3, "Only 3 free");
1597 
1598         uint256 newSupply = totalSupply() + quantity;
1599         
1600         require(newSupply <= 1000, "Not enough free supply");
1601 
1602         require(!userMintedFree[msg.sender], "User max free limit");
1603         
1604         userMintedFree[msg.sender] = true;
1605 
1606         if(newSupply == 1000) {
1607             freeSale = false;
1608             publicSale = true;
1609         }
1610 
1611         _safeMint(msg.sender, quantity);
1612     }
1613 
1614     function publicMint(uint256 quantity) external payable mintCompliance(quantity) {
1615         require(publicSale, "Public sale inactive");
1616         require(quantity <= PUBLIC_MINT_LIMIT_TXN, "Quantity too high");
1617 
1618         uint256 price = publicPrice;
1619         uint256 currMints = numUserMints[msg.sender];
1620                 
1621         require(currMints + quantity <= PUBLIC_MINT_LIMIT, "User max mint limit");
1622         
1623         refundOverpay(price * quantity);
1624 
1625         numUserMints[msg.sender] = (currMints + quantity);
1626 
1627         _safeMint(msg.sender, quantity);
1628     }
1629 
1630     function walletOfOwner(address _owner) public view returns (uint256[] memory)
1631     {
1632         uint256 ownerTokenCount = balanceOf(_owner);
1633         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1634         uint256 currentTokenId = 1;
1635         uint256 ownedTokenIndex = 0;
1636 
1637         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= MAX_SUPPLY) {
1638             address currentTokenOwner = ownerOf(currentTokenId);
1639 
1640             if (currentTokenOwner == _owner) {
1641                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1642 
1643                 ownedTokenIndex++;
1644             }
1645 
1646         currentTokenId++;
1647         }
1648 
1649         return ownedTokenIds;
1650     }
1651 
1652     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1653     
1654         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1655         
1656         if (revealed) {
1657             return string(abi.encodePacked(revealedURI, Strings.toString(_tokenId), ".json"));
1658         }
1659         else {
1660             return hiddenURI;
1661         }
1662     }
1663 
1664     // https://docs.opensea.io/docs/contract-level-metadata
1665     // https://ethereum.stackexchange.com/questions/110924/how-to-properly-implement-a-contracturi-for-on-chain-nfts
1666     function contractURI() public view returns (string memory) {
1667         return CONTRACT_URI;
1668     }
1669 
1670     function setTeamMintMax(uint256 _teamMintMax) public onlyOwner {
1671         TEAM_MINT_MAX = _teamMintMax;
1672     }
1673 
1674     function setPublicPrice(uint256 _publicPrice) public onlyOwner {
1675         publicPrice = _publicPrice;
1676     }
1677 
1678     function setBaseURI(string memory _baseUri) public onlyOwner {
1679         revealedURI = _baseUri;
1680     }
1681 
1682     // Note: This method can be hidden/removed if this is a constant.
1683     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1684         hiddenURI = _hiddenMetadataUri;
1685     }
1686 
1687     function revealCollection(bool _revealed, string memory _baseUri) public onlyOwner {
1688         revealed = _revealed;
1689         revealedURI = _baseUri;
1690     }
1691 
1692     // https://docs.opensea.io/docs/contract-level-metadata
1693     function setContractURI(string memory _contractURI) public onlyOwner {
1694         CONTRACT_URI = _contractURI;
1695     }
1696 
1697     // Note: Another option is to inherit Pausable without implementing the logic yourself.
1698         // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/Pausable.sol
1699     function setPaused(bool _state) public onlyOwner {
1700         paused = _state;
1701     }
1702 
1703     function setRevealed(bool _state) public onlyOwner {
1704         revealed = _state;
1705     }
1706 
1707     function setPublicEnabled(bool _state) public onlyOwner {
1708         publicSale = _state;
1709         freeSale = !_state;
1710     }
1711     function setFreeEnabled(bool _state) public onlyOwner {
1712         freeSale = _state;
1713         publicSale = !_state;
1714     }
1715 
1716     function setTeamWalletAddress(address _teamWallet) public onlyOwner {
1717         teamWallet = _teamWallet;
1718     }
1719 
1720     function withdraw() external payable onlyOwner {
1721         // Get the current funds to calculate initial percentages
1722         uint256 currBalance = address(this).balance;
1723 
1724         (bool succ, ) = payable(DEV_ADDRESS).call{
1725             value: (currBalance * 2833) / 10000
1726         }("");
1727         require(succ, "Dev transfer failed");
1728 
1729         (succ, ) = payable(WEB_ADDRESS).call{
1730             value: (currBalance * 2833) / 10000
1731         }("");
1732         require(succ, "Web transfer failed");
1733 
1734         // Withdraw the ENTIRE remaining balance to the team wallet
1735         (succ, ) = payable(teamWallet).call{
1736             value: address(this).balance
1737         }("");
1738         require(succ, "Team (remaining) transfer failed");
1739     }
1740 
1741     // Owner-only mint functionality to "Airdrop" mints to specific users
1742         // Note: These will likely end up hidden on OpenSea
1743     function mintToUser(uint256 quantity, address receiver) public onlyOwner mintCompliance(quantity) {
1744         _safeMint(receiver, quantity);
1745     }
1746 
1747     modifier mintCompliance(uint256 quantity) {
1748         require(!paused, "Contract is paused");
1749         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough mints left");
1750         require(tx.origin == msg.sender, "No contract minting");
1751         _;
1752     }
1753 }