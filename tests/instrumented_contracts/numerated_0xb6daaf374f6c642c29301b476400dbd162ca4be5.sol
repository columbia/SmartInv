1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
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
79 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
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
106 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
107 
108 
109 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
139      * @dev Returns the address of the current owner.
140      */
141     function owner() public view virtual returns (address) {
142         return _owner;
143     }
144 
145     /**
146      * @dev Throws if called by any account other than the owner.
147      */
148     modifier onlyOwner() {
149         require(owner() == _msgSender(), "Ownable: caller is not the owner");
150         _;
151     }
152 
153     /**
154      * @dev Leaves the contract without owner. It will not be possible to call
155      * `onlyOwner` functions anymore. Can only be called by the current owner.
156      *
157      * NOTE: Renouncing ownership will leave the contract without an owner,
158      * thereby removing any functionality that is only available to the owner.
159      */
160     function renounceOwnership() public virtual onlyOwner {
161         _transferOwnership(address(0));
162     }
163 
164     /**
165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
166      * Can only be called by the current owner.
167      */
168     function transferOwnership(address newOwner) public virtual onlyOwner {
169         require(newOwner != address(0), "Ownable: new owner is the zero address");
170         _transferOwnership(newOwner);
171     }
172 
173     /**
174      * @dev Transfers ownership of the contract to a new account (`newOwner`).
175      * Internal function without access restriction.
176      */
177     function _transferOwnership(address newOwner) internal virtual {
178         address oldOwner = _owner;
179         _owner = newOwner;
180         emit OwnershipTransferred(oldOwner, newOwner);
181     }
182 }
183 
184 // File: erc721a/contracts/IERC721A.sol
185 
186 
187 // ERC721A Contracts v4.0.0
188 // Creator: Chiru Labs
189 
190 pragma solidity ^0.8.4;
191 
192 /**
193  * @dev Interface of an ERC721A compliant contract.
194  */
195 interface IERC721A {
196     /**
197      * The caller must own the token or be an approved operator.
198      */
199     error ApprovalCallerNotOwnerNorApproved();
200 
201     /**
202      * The token does not exist.
203      */
204     error ApprovalQueryForNonexistentToken();
205 
206     /**
207      * The caller cannot approve to their own address.
208      */
209     error ApproveToCaller();
210 
211     /**
212      * The caller cannot approve to the current owner.
213      */
214     error ApprovalToCurrentOwner();
215 
216     /**
217      * Cannot query the balance for the zero address.
218      */
219     error BalanceQueryForZeroAddress();
220 
221     /**
222      * Cannot mint to the zero address.
223      */
224     error MintToZeroAddress();
225 
226     /**
227      * The quantity of tokens minted must be more than zero.
228      */
229     error MintZeroQuantity();
230 
231     /**
232      * The token does not exist.
233      */
234     error OwnerQueryForNonexistentToken();
235 
236     /**
237      * The caller must own the token or be an approved operator.
238      */
239     error TransferCallerNotOwnerNorApproved();
240 
241     /**
242      * The token must be owned by `from`.
243      */
244     error TransferFromIncorrectOwner();
245 
246     /**
247      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
248      */
249     error TransferToNonERC721ReceiverImplementer();
250 
251     /**
252      * Cannot transfer to the zero address.
253      */
254     error TransferToZeroAddress();
255 
256     /**
257      * The token does not exist.
258      */
259     error URIQueryForNonexistentToken();
260 
261     struct TokenOwnership {
262         // The address of the owner.
263         address addr;
264         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
265         uint64 startTimestamp;
266         // Whether the token has been burned.
267         bool burned;
268     }
269 
270     /**
271      * @dev Returns the total amount of tokens stored by the contract.
272      *
273      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
274      */
275     function totalSupply() external view returns (uint256);
276 
277     // ==============================
278     //            IERC165
279     // ==============================
280 
281     /**
282      * @dev Returns true if this contract implements the interface defined by
283      * `interfaceId`. See the corresponding
284      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
285      * to learn more about how these ids are created.
286      *
287      * This function call must use less than 30 000 gas.
288      */
289     function supportsInterface(bytes4 interfaceId) external view returns (bool);
290 
291     // ==============================
292     //            IERC721
293     // ==============================
294 
295     /**
296      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
297      */
298     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
299 
300     /**
301      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
302      */
303     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
304 
305     /**
306      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
307      */
308     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
309 
310     /**
311      * @dev Returns the number of tokens in ``owner``'s account.
312      */
313     function balanceOf(address owner) external view returns (uint256 balance);
314 
315     /**
316      * @dev Returns the owner of the `tokenId` token.
317      *
318      * Requirements:
319      *
320      * - `tokenId` must exist.
321      */
322     function ownerOf(uint256 tokenId) external view returns (address owner);
323 
324     /**
325      * @dev Safely transfers `tokenId` token from `from` to `to`.
326      *
327      * Requirements:
328      *
329      * - `from` cannot be the zero address.
330      * - `to` cannot be the zero address.
331      * - `tokenId` token must exist and be owned by `from`.
332      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
333      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
334      *
335      * Emits a {Transfer} event.
336      */
337     function safeTransferFrom(
338         address from,
339         address to,
340         uint256 tokenId,
341         bytes calldata data
342     ) external;
343 
344     /**
345      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
346      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
347      *
348      * Requirements:
349      *
350      * - `from` cannot be the zero address.
351      * - `to` cannot be the zero address.
352      * - `tokenId` token must exist and be owned by `from`.
353      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
354      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
355      *
356      * Emits a {Transfer} event.
357      */
358     function safeTransferFrom(
359         address from,
360         address to,
361         uint256 tokenId
362     ) external;
363 
364     /**
365      * @dev Transfers `tokenId` token from `from` to `to`.
366      *
367      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
368      *
369      * Requirements:
370      *
371      * - `from` cannot be the zero address.
372      * - `to` cannot be the zero address.
373      * - `tokenId` token must be owned by `from`.
374      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
375      *
376      * Emits a {Transfer} event.
377      */
378     function transferFrom(
379         address from,
380         address to,
381         uint256 tokenId
382     ) external;
383 
384     /**
385      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
386      * The approval is cleared when the token is transferred.
387      *
388      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
389      *
390      * Requirements:
391      *
392      * - The caller must own the token or be an approved operator.
393      * - `tokenId` must exist.
394      *
395      * Emits an {Approval} event.
396      */
397     function approve(address to, uint256 tokenId) external;
398 
399     /**
400      * @dev Approve or remove `operator` as an operator for the caller.
401      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
402      *
403      * Requirements:
404      *
405      * - The `operator` cannot be the caller.
406      *
407      * Emits an {ApprovalForAll} event.
408      */
409     function setApprovalForAll(address operator, bool _approved) external;
410 
411     /**
412      * @dev Returns the account approved for `tokenId` token.
413      *
414      * Requirements:
415      *
416      * - `tokenId` must exist.
417      */
418     function getApproved(uint256 tokenId) external view returns (address operator);
419 
420     /**
421      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
422      *
423      * See {setApprovalForAll}
424      */
425     function isApprovedForAll(address owner, address operator) external view returns (bool);
426 
427     // ==============================
428     //        IERC721Metadata
429     // ==============================
430 
431     /**
432      * @dev Returns the token collection name.
433      */
434     function name() external view returns (string memory);
435 
436     /**
437      * @dev Returns the token collection symbol.
438      */
439     function symbol() external view returns (string memory);
440 
441     /**
442      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
443      */
444     function tokenURI(uint256 tokenId) external view returns (string memory);
445 }
446 
447 // File: erc721a/contracts/ERC721A.sol
448 
449 
450 // ERC721A Contracts v4.0.0
451 // Creator: Chiru Labs
452 
453 pragma solidity ^0.8.4;
454 
455 
456 /**
457  * @dev ERC721 token receiver interface.
458  */
459 interface ERC721A__IERC721Receiver {
460     function onERC721Received(
461         address operator,
462         address from,
463         uint256 tokenId,
464         bytes calldata data
465     ) external returns (bytes4);
466 }
467 
468 /**
469  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
470  * the Metadata extension. Built to optimize for lower gas during batch mints.
471  *
472  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
473  *
474  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
475  *
476  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
477  */
478 contract ERC721A is IERC721A {
479     // Mask of an entry in packed address data.
480     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
481 
482     // The bit position of `numberMinted` in packed address data.
483     uint256 private constant BITPOS_NUMBER_MINTED = 64;
484 
485     // The bit position of `numberBurned` in packed address data.
486     uint256 private constant BITPOS_NUMBER_BURNED = 128;
487 
488     // The bit position of `aux` in packed address data.
489     uint256 private constant BITPOS_AUX = 192;
490 
491     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
492     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
493 
494     // The bit position of `startTimestamp` in packed ownership.
495     uint256 private constant BITPOS_START_TIMESTAMP = 160;
496 
497     // The bit mask of the `burned` bit in packed ownership.
498     uint256 private constant BITMASK_BURNED = 1 << 224;
499     
500     // The bit position of the `nextInitialized` bit in packed ownership.
501     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
502 
503     // The bit mask of the `nextInitialized` bit in packed ownership.
504     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
505 
506     // The tokenId of the next token to be minted.
507     uint256 private _currentIndex;
508 
509     // The number of tokens burned.
510     uint256 private _burnCounter;
511 
512     // Token name
513     string private _name;
514 
515     // Token symbol
516     string private _symbol;
517 
518     // Mapping from token ID to ownership details
519     // An empty struct value does not necessarily mean the token is unowned.
520     // See `_packedOwnershipOf` implementation for details.
521     //
522     // Bits Layout:
523     // - [0..159]   `addr`
524     // - [160..223] `startTimestamp`
525     // - [224]      `burned`
526     // - [225]      `nextInitialized`
527     mapping(uint256 => uint256) private _packedOwnerships;
528 
529     // Mapping owner address to address data.
530     //
531     // Bits Layout:
532     // - [0..63]    `balance`
533     // - [64..127]  `numberMinted`
534     // - [128..191] `numberBurned`
535     // - [192..255] `aux`
536     mapping(address => uint256) private _packedAddressData;
537 
538     // Mapping from token ID to approved address.
539     mapping(uint256 => address) private _tokenApprovals;
540 
541     // Mapping from owner to operator approvals
542     mapping(address => mapping(address => bool)) private _operatorApprovals;
543 
544     constructor(string memory name_, string memory symbol_) {
545         _name = name_;
546         _symbol = symbol_;
547         _currentIndex = _startTokenId();
548     }
549 
550     /**
551      * @dev Returns the starting token ID. 
552      * To change the starting token ID, please override this function.
553      */
554     function _startTokenId() internal view virtual returns (uint256) {
555         return 0;
556     }
557 
558     /**
559      * @dev Returns the next token ID to be minted.
560      */
561     function _nextTokenId() internal view returns (uint256) {
562         return _currentIndex;
563     }
564 
565     /**
566      * @dev Returns the total number of tokens in existence.
567      * Burned tokens will reduce the count. 
568      * To get the total number of tokens minted, please see `_totalMinted`.
569      */
570     function totalSupply() public view override returns (uint256) {
571         // Counter underflow is impossible as _burnCounter cannot be incremented
572         // more than `_currentIndex - _startTokenId()` times.
573         unchecked {
574             return _currentIndex - _burnCounter - _startTokenId();
575         }
576     }
577 
578     /**
579      * @dev Returns the total amount of tokens minted in the contract.
580      */
581     function _totalMinted() internal view returns (uint256) {
582         // Counter underflow is impossible as _currentIndex does not decrement,
583         // and it is initialized to `_startTokenId()`
584         unchecked {
585             return _currentIndex - _startTokenId();
586         }
587     }
588 
589     /**
590      * @dev Returns the total number of tokens burned.
591      */
592     function _totalBurned() internal view returns (uint256) {
593         return _burnCounter;
594     }
595 
596     /**
597      * @dev See {IERC165-supportsInterface}.
598      */
599     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
600         // The interface IDs are constants representing the first 4 bytes of the XOR of
601         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
602         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
603         return
604             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
605             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
606             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
607     }
608 
609     /**
610      * @dev See {IERC721-balanceOf}.
611      */
612     function balanceOf(address owner) public view override returns (uint256) {
613         if (owner == address(0)) revert BalanceQueryForZeroAddress();
614         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
615     }
616 
617     /**
618      * Returns the number of tokens minted by `owner`.
619      */
620     function _numberMinted(address owner) internal view returns (uint256) {
621         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
622     }
623 
624     /**
625      * Returns the number of tokens burned by or on behalf of `owner`.
626      */
627     function _numberBurned(address owner) internal view returns (uint256) {
628         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
629     }
630 
631     /**
632      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
633      */
634     function _getAux(address owner) internal view returns (uint64) {
635         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
636     }
637 
638     /**
639      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
640      * If there are multiple variables, please pack them into a uint64.
641      */
642     function _setAux(address owner, uint64 aux) internal {
643         uint256 packed = _packedAddressData[owner];
644         uint256 auxCasted;
645         assembly { // Cast aux without masking.
646             auxCasted := aux
647         }
648         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
649         _packedAddressData[owner] = packed;
650     }
651 
652     /**
653      * Returns the packed ownership data of `tokenId`.
654      */
655     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
656         uint256 curr = tokenId;
657 
658         unchecked {
659             if (_startTokenId() <= curr)
660                 if (curr < _currentIndex) {
661                     uint256 packed = _packedOwnerships[curr];
662                     // If not burned.
663                     if (packed & BITMASK_BURNED == 0) {
664                         // Invariant:
665                         // There will always be an ownership that has an address and is not burned
666                         // before an ownership that does not have an address and is not burned.
667                         // Hence, curr will not underflow.
668                         //
669                         // We can directly compare the packed value.
670                         // If the address is zero, packed is zero.
671                         while (packed == 0) {
672                             packed = _packedOwnerships[--curr];
673                         }
674                         return packed;
675                     }
676                 }
677         }
678         revert OwnerQueryForNonexistentToken();
679     }
680 
681     /**
682      * Returns the unpacked `TokenOwnership` struct from `packed`.
683      */
684     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
685         ownership.addr = address(uint160(packed));
686         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
687         ownership.burned = packed & BITMASK_BURNED != 0;
688     }
689 
690     /**
691      * Returns the unpacked `TokenOwnership` struct at `index`.
692      */
693     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
694         return _unpackedOwnership(_packedOwnerships[index]);
695     }
696 
697     /**
698      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
699      */
700     function _initializeOwnershipAt(uint256 index) internal {
701         if (_packedOwnerships[index] == 0) {
702             _packedOwnerships[index] = _packedOwnershipOf(index);
703         }
704     }
705 
706     /**
707      * Gas spent here starts off proportional to the maximum mint batch size.
708      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
709      */
710     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
711         return _unpackedOwnership(_packedOwnershipOf(tokenId));
712     }
713 
714     /**
715      * @dev See {IERC721-ownerOf}.
716      */
717     function ownerOf(uint256 tokenId) public view override returns (address) {
718         return address(uint160(_packedOwnershipOf(tokenId)));
719     }
720 
721     /**
722      * @dev See {IERC721Metadata-name}.
723      */
724     function name() public view virtual override returns (string memory) {
725         return _name;
726     }
727 
728     /**
729      * @dev See {IERC721Metadata-symbol}.
730      */
731     function symbol() public view virtual override returns (string memory) {
732         return _symbol;
733     }
734 
735     /**
736      * @dev See {IERC721Metadata-tokenURI}.
737      */
738     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
739         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
740 
741         string memory baseURI = _baseURI();
742         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
743     }
744 
745     /**
746      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
747      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
748      * by default, can be overriden in child contracts.
749      */
750     function _baseURI() internal view virtual returns (string memory) {
751         return '';
752     }
753 
754     /**
755      * @dev Casts the address to uint256 without masking.
756      */
757     function _addressToUint256(address value) private pure returns (uint256 result) {
758         assembly {
759             result := value
760         }
761     }
762 
763     /**
764      * @dev Casts the boolean to uint256 without branching.
765      */
766     function _boolToUint256(bool value) private pure returns (uint256 result) {
767         assembly {
768             result := value
769         }
770     }
771 
772     /**
773      * @dev See {IERC721-approve}.
774      */
775     function approve(address to, uint256 tokenId) public override {
776         address owner = address(uint160(_packedOwnershipOf(tokenId)));
777         if (to == owner) revert ApprovalToCurrentOwner();
778 
779         if (_msgSenderERC721A() != owner)
780             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
781                 revert ApprovalCallerNotOwnerNorApproved();
782             }
783 
784         _tokenApprovals[tokenId] = to;
785         emit Approval(owner, to, tokenId);
786     }
787 
788     /**
789      * @dev See {IERC721-getApproved}.
790      */
791     function getApproved(uint256 tokenId) public view override returns (address) {
792         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
793 
794         return _tokenApprovals[tokenId];
795     }
796 
797     /**
798      * @dev See {IERC721-setApprovalForAll}.
799      */
800     function setApprovalForAll(address operator, bool approved) public virtual override {
801         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
802 
803         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
804         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
805     }
806 
807     /**
808      * @dev See {IERC721-isApprovedForAll}.
809      */
810     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
811         return _operatorApprovals[owner][operator];
812     }
813 
814     /**
815      * @dev See {IERC721-transferFrom}.
816      */
817     function transferFrom(
818         address from,
819         address to,
820         uint256 tokenId
821     ) public virtual override {
822         _transfer(from, to, tokenId);
823     }
824 
825     /**
826      * @dev See {IERC721-safeTransferFrom}.
827      */
828     function safeTransferFrom(
829         address from,
830         address to,
831         uint256 tokenId
832     ) public virtual override {
833         safeTransferFrom(from, to, tokenId, '');
834     }
835 
836     /**
837      * @dev See {IERC721-safeTransferFrom}.
838      */
839     function safeTransferFrom(
840         address from,
841         address to,
842         uint256 tokenId,
843         bytes memory _data
844     ) public virtual override {
845         _transfer(from, to, tokenId);
846         if (to.code.length != 0)
847             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
848                 revert TransferToNonERC721ReceiverImplementer();
849             }
850     }
851 
852     /**
853      * @dev Returns whether `tokenId` exists.
854      *
855      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
856      *
857      * Tokens start existing when they are minted (`_mint`),
858      */
859     function _exists(uint256 tokenId) internal view returns (bool) {
860         return
861             _startTokenId() <= tokenId &&
862             tokenId < _currentIndex && // If within bounds,
863             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
864     }
865 
866     /**
867      * @dev Equivalent to `_safeMint(to, quantity, '')`.
868      */
869     function _safeMint(address to, uint256 quantity) internal {
870         _safeMint(to, quantity, '');
871     }
872 
873     /**
874      * @dev Safely mints `quantity` tokens and transfers them to `to`.
875      *
876      * Requirements:
877      *
878      * - If `to` refers to a smart contract, it must implement
879      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
880      * - `quantity` must be greater than 0.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _safeMint(
885         address to,
886         uint256 quantity,
887         bytes memory _data
888     ) internal {
889         uint256 startTokenId = _currentIndex;
890         if (to == address(0)) revert MintToZeroAddress();
891         if (quantity == 0) revert MintZeroQuantity();
892 
893         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
894 
895         // Overflows are incredibly unrealistic.
896         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
897         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
898         unchecked {
899             // Updates:
900             // - `balance += quantity`.
901             // - `numberMinted += quantity`.
902             //
903             // We can directly add to the balance and number minted.
904             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
905 
906             // Updates:
907             // - `address` to the owner.
908             // - `startTimestamp` to the timestamp of minting.
909             // - `burned` to `false`.
910             // - `nextInitialized` to `quantity == 1`.
911             _packedOwnerships[startTokenId] =
912                 _addressToUint256(to) |
913                 (block.timestamp << BITPOS_START_TIMESTAMP) |
914                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
915 
916             uint256 updatedIndex = startTokenId;
917             uint256 end = updatedIndex + quantity;
918 
919             if (to.code.length != 0) {
920                 do {
921                     emit Transfer(address(0), to, updatedIndex);
922                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
923                         revert TransferToNonERC721ReceiverImplementer();
924                     }
925                 } while (updatedIndex < end);
926                 // Reentrancy protection
927                 if (_currentIndex != startTokenId) revert();
928             } else {
929                 do {
930                     emit Transfer(address(0), to, updatedIndex++);
931                 } while (updatedIndex < end);
932             }
933             _currentIndex = updatedIndex;
934         }
935         _afterTokenTransfers(address(0), to, startTokenId, quantity);
936     }
937 
938     /**
939      * @dev Mints `quantity` tokens and transfers them to `to`.
940      *
941      * Requirements:
942      *
943      * - `to` cannot be the zero address.
944      * - `quantity` must be greater than 0.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _mint(address to, uint256 quantity) internal {
949         uint256 startTokenId = _currentIndex;
950         if (to == address(0)) revert MintToZeroAddress();
951         if (quantity == 0) revert MintZeroQuantity();
952 
953         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
954 
955         // Overflows are incredibly unrealistic.
956         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
957         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
958         unchecked {
959             // Updates:
960             // - `balance += quantity`.
961             // - `numberMinted += quantity`.
962             //
963             // We can directly add to the balance and number minted.
964             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
965 
966             // Updates:
967             // - `address` to the owner.
968             // - `startTimestamp` to the timestamp of minting.
969             // - `burned` to `false`.
970             // - `nextInitialized` to `quantity == 1`.
971             _packedOwnerships[startTokenId] =
972                 _addressToUint256(to) |
973                 (block.timestamp << BITPOS_START_TIMESTAMP) |
974                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
975 
976             uint256 updatedIndex = startTokenId;
977             uint256 end = updatedIndex + quantity;
978 
979             do {
980                 emit Transfer(address(0), to, updatedIndex++);
981             } while (updatedIndex < end);
982 
983             _currentIndex = updatedIndex;
984         }
985         _afterTokenTransfers(address(0), to, startTokenId, quantity);
986     }
987 
988     /**
989      * @dev Transfers `tokenId` from `from` to `to`.
990      *
991      * Requirements:
992      *
993      * - `to` cannot be the zero address.
994      * - `tokenId` token must be owned by `from`.
995      *
996      * Emits a {Transfer} event.
997      */
998     function _transfer(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) private {
1003         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1004 
1005         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1006 
1007         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1008             isApprovedForAll(from, _msgSenderERC721A()) ||
1009             getApproved(tokenId) == _msgSenderERC721A());
1010 
1011         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1012         if (to == address(0)) revert TransferToZeroAddress();
1013 
1014         _beforeTokenTransfers(from, to, tokenId, 1);
1015 
1016         // Clear approvals from the previous owner.
1017         delete _tokenApprovals[tokenId];
1018 
1019         // Underflow of the sender's balance is impossible because we check for
1020         // ownership above and the recipient's balance can't realistically overflow.
1021         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1022         unchecked {
1023             // We can directly increment and decrement the balances.
1024             --_packedAddressData[from]; // Updates: `balance -= 1`.
1025             ++_packedAddressData[to]; // Updates: `balance += 1`.
1026 
1027             // Updates:
1028             // - `address` to the next owner.
1029             // - `startTimestamp` to the timestamp of transfering.
1030             // - `burned` to `false`.
1031             // - `nextInitialized` to `true`.
1032             _packedOwnerships[tokenId] =
1033                 _addressToUint256(to) |
1034                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1035                 BITMASK_NEXT_INITIALIZED;
1036 
1037             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1038             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1039                 uint256 nextTokenId = tokenId + 1;
1040                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1041                 if (_packedOwnerships[nextTokenId] == 0) {
1042                     // If the next slot is within bounds.
1043                     if (nextTokenId != _currentIndex) {
1044                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1045                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1046                     }
1047                 }
1048             }
1049         }
1050 
1051         emit Transfer(from, to, tokenId);
1052         _afterTokenTransfers(from, to, tokenId, 1);
1053     }
1054 
1055     /**
1056      * @dev Equivalent to `_burn(tokenId, false)`.
1057      */
1058     function _burn(uint256 tokenId) internal virtual {
1059         _burn(tokenId, false);
1060     }
1061 
1062     /**
1063      * @dev Destroys `tokenId`.
1064      * The approval is cleared when the token is burned.
1065      *
1066      * Requirements:
1067      *
1068      * - `tokenId` must exist.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1073         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1074 
1075         address from = address(uint160(prevOwnershipPacked));
1076 
1077         if (approvalCheck) {
1078             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1079                 isApprovedForAll(from, _msgSenderERC721A()) ||
1080                 getApproved(tokenId) == _msgSenderERC721A());
1081 
1082             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1083         }
1084 
1085         _beforeTokenTransfers(from, address(0), tokenId, 1);
1086 
1087         // Clear approvals from the previous owner.
1088         delete _tokenApprovals[tokenId];
1089 
1090         // Underflow of the sender's balance is impossible because we check for
1091         // ownership above and the recipient's balance can't realistically overflow.
1092         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1093         unchecked {
1094             // Updates:
1095             // - `balance -= 1`.
1096             // - `numberBurned += 1`.
1097             //
1098             // We can directly decrement the balance, and increment the number burned.
1099             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1100             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1101 
1102             // Updates:
1103             // - `address` to the last owner.
1104             // - `startTimestamp` to the timestamp of burning.
1105             // - `burned` to `true`.
1106             // - `nextInitialized` to `true`.
1107             _packedOwnerships[tokenId] =
1108                 _addressToUint256(from) |
1109                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1110                 BITMASK_BURNED | 
1111                 BITMASK_NEXT_INITIALIZED;
1112 
1113             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1114             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1115                 uint256 nextTokenId = tokenId + 1;
1116                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1117                 if (_packedOwnerships[nextTokenId] == 0) {
1118                     // If the next slot is within bounds.
1119                     if (nextTokenId != _currentIndex) {
1120                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1121                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1122                     }
1123                 }
1124             }
1125         }
1126 
1127         emit Transfer(from, address(0), tokenId);
1128         _afterTokenTransfers(from, address(0), tokenId, 1);
1129 
1130         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1131         unchecked {
1132             _burnCounter++;
1133         }
1134     }
1135 
1136     /**
1137      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1138      *
1139      * @param from address representing the previous owner of the given token ID
1140      * @param to target address that will receive the tokens
1141      * @param tokenId uint256 ID of the token to be transferred
1142      * @param _data bytes optional data to send along with the call
1143      * @return bool whether the call correctly returned the expected magic value
1144      */
1145     function _checkContractOnERC721Received(
1146         address from,
1147         address to,
1148         uint256 tokenId,
1149         bytes memory _data
1150     ) private returns (bool) {
1151         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1152             bytes4 retval
1153         ) {
1154             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1155         } catch (bytes memory reason) {
1156             if (reason.length == 0) {
1157                 revert TransferToNonERC721ReceiverImplementer();
1158             } else {
1159                 assembly {
1160                     revert(add(32, reason), mload(reason))
1161                 }
1162             }
1163         }
1164     }
1165 
1166     /**
1167      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1168      * And also called before burning one token.
1169      *
1170      * startTokenId - the first token id to be transferred
1171      * quantity - the amount to be transferred
1172      *
1173      * Calling conditions:
1174      *
1175      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1176      * transferred to `to`.
1177      * - When `from` is zero, `tokenId` will be minted for `to`.
1178      * - When `to` is zero, `tokenId` will be burned by `from`.
1179      * - `from` and `to` are never both zero.
1180      */
1181     function _beforeTokenTransfers(
1182         address from,
1183         address to,
1184         uint256 startTokenId,
1185         uint256 quantity
1186     ) internal virtual {}
1187 
1188     /**
1189      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1190      * minting.
1191      * And also called after one token has been burned.
1192      *
1193      * startTokenId - the first token id to be transferred
1194      * quantity - the amount to be transferred
1195      *
1196      * Calling conditions:
1197      *
1198      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1199      * transferred to `to`.
1200      * - When `from` is zero, `tokenId` has been minted for `to`.
1201      * - When `to` is zero, `tokenId` has been burned by `from`.
1202      * - `from` and `to` are never both zero.
1203      */
1204     function _afterTokenTransfers(
1205         address from,
1206         address to,
1207         uint256 startTokenId,
1208         uint256 quantity
1209     ) internal virtual {}
1210 
1211     /**
1212      * @dev Returns the message sender (defaults to `msg.sender`).
1213      *
1214      * If you are writing GSN compatible contracts, you need to override this function.
1215      */
1216     function _msgSenderERC721A() internal view virtual returns (address) {
1217         return msg.sender;
1218     }
1219 
1220     /**
1221      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1222      */
1223     function _toString(uint256 value) internal pure returns (string memory ptr) {
1224         assembly {
1225             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1226             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1227             // We will need 1 32-byte word to store the length, 
1228             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1229             ptr := add(mload(0x40), 128)
1230             // Update the free memory pointer to allocate.
1231             mstore(0x40, ptr)
1232 
1233             // Cache the end of the memory to calculate the length later.
1234             let end := ptr
1235 
1236             // We write the string from the rightmost digit to the leftmost digit.
1237             // The following is essentially a do-while loop that also handles the zero case.
1238             // Costs a bit more than early returning for the zero case,
1239             // but cheaper in terms of deployment and overall runtime costs.
1240             for { 
1241                 // Initialize and perform the first pass without check.
1242                 let temp := value
1243                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1244                 ptr := sub(ptr, 1)
1245                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1246                 mstore8(ptr, add(48, mod(temp, 10)))
1247                 temp := div(temp, 10)
1248             } temp { 
1249                 // Keep dividing `temp` until zero.
1250                 temp := div(temp, 10)
1251             } { // Body of the for loop.
1252                 ptr := sub(ptr, 1)
1253                 mstore8(ptr, add(48, mod(temp, 10)))
1254             }
1255             
1256             let length := sub(end, ptr)
1257             // Move the pointer 32 bytes leftwards to make room for the length.
1258             ptr := sub(ptr, 32)
1259             // Store the length.
1260             mstore(ptr, length)
1261         }
1262     }
1263 }
1264 
1265 // File: contract.sol
1266 
1267 
1268 pragma solidity ^0.8.0;
1269 
1270 
1271 
1272 
1273 contract MISTERGRAY is ERC721A, Ownable {
1274     
1275     using Strings for uint256;
1276 
1277 
1278     uint256 FREE_MINT_LIMIT_PER_WALLET = 1;
1279     uint256 MAX_MINTS = 10;
1280     uint256 MAX_SUPPLY = 5000;
1281     bool private paused = true;
1282     uint256 MAX_FREE = 4999;
1283     uint256 public mintRate = 0.005 ether;
1284 
1285     string public baseURI = "https://mrgraynft.xyz/api/";
1286 
1287     mapping(address => uint256) private freeMintCountMap;
1288     
1289 
1290     constructor() ERC721A("MISTER GRAY", "MB") {}
1291 
1292     modifier callerIsuser(){
1293         require(tx.origin ==msg.sender, "Can't be called from contract");
1294         _;
1295     }
1296 
1297     function updateFreeMintCount(address minter, uint256 count) private {
1298         freeMintCountMap[minter] += count;
1299     } 
1300 
1301     function getFMC( address minter) public view returns(uint256){
1302         return freeMintCountMap[minter];
1303     }
1304 
1305 
1306     function mint(uint256 quantity) external payable callerIsuser {
1307         require(quantity + _numberMinted(msg.sender) <= MAX_MINTS, "Exceeded the limit");
1308         require(!paused);
1309         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left");
1310 
1311         uint256 price = mintRate * quantity;
1312 
1313         if(totalSupply()+ quantity <=  MAX_FREE){
1314             uint256 remainingFreeMint = FREE_MINT_LIMIT_PER_WALLET -
1315                 freeMintCountMap[msg.sender];
1316             if(remainingFreeMint > 0){
1317                 if(quantity >= remainingFreeMint){
1318                     price -= remainingFreeMint * mintRate;
1319                     updateFreeMintCount(msg.sender,remainingFreeMint);
1320                 }
1321                 else{
1322                     price-= quantity * mintRate;
1323                     updateFreeMintCount(msg.sender,quantity);
1324                 }
1325             }
1326         }
1327         require(msg.value >= price,"Not enough ether sent.");
1328 
1329         _safeMint(msg.sender, quantity);
1330     }
1331 
1332 
1333 
1334     function withdraw() external payable onlyOwner {
1335         payable(owner()).transfer(address(this).balance);
1336     }
1337 
1338     function _baseURI() internal view override returns (string memory) {
1339         return baseURI;
1340     }
1341 
1342     function setMintRate(uint256 _mintRate) public onlyOwner {
1343         mintRate = _mintRate;
1344     }
1345 
1346     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1347         baseURI = _newBaseURI;
1348     }
1349 
1350     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1351       require( _exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1352       string memory currentBaseURI = _baseURI();
1353       uint256 trueid = tokenId + 1;
1354       return bytes(currentBaseURI).length > 0
1355           ? string(abi.encodePacked(currentBaseURI, trueid.toString() , ".json"))
1356           : "";
1357   }
1358 
1359   function unpause(bool _state) public onlyOwner {
1360     paused = _state;
1361   }
1362 
1363   function setMaxPerWallet(uint256 newmaxperwallet) public onlyOwner {
1364       MAX_MINTS = newmaxperwallet;
1365   }
1366 
1367   function changesupply(uint256 newsupply_) public onlyOwner{
1368       MAX_SUPPLY = newsupply_;
1369   }
1370 
1371     
1372 }