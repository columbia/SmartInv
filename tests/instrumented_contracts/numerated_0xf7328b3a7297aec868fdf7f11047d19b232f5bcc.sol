1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: @openzeppelin/contracts/utils/Strings.sol
107 
108 
109 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev String operations.
115  */
116 library Strings {
117     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
121      */
122     function toString(uint256 value) internal pure returns (string memory) {
123         // Inspired by OraclizeAPI's implementation - MIT licence
124         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
125 
126         if (value == 0) {
127             return "0";
128         }
129         uint256 temp = value;
130         uint256 digits;
131         while (temp != 0) {
132             digits++;
133             temp /= 10;
134         }
135         bytes memory buffer = new bytes(digits);
136         while (value != 0) {
137             digits -= 1;
138             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
139             value /= 10;
140         }
141         return string(buffer);
142     }
143 
144     /**
145      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
146      */
147     function toHexString(uint256 value) internal pure returns (string memory) {
148         if (value == 0) {
149             return "0x00";
150         }
151         uint256 temp = value;
152         uint256 length = 0;
153         while (temp != 0) {
154             length++;
155             temp >>= 8;
156         }
157         return toHexString(value, length);
158     }
159 
160     /**
161      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
162      */
163     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
164         bytes memory buffer = new bytes(2 * length + 2);
165         buffer[0] = "0";
166         buffer[1] = "x";
167         for (uint256 i = 2 * length + 1; i > 1; --i) {
168             buffer[i] = _HEX_SYMBOLS[value & 0xf];
169             value >>= 4;
170         }
171         require(value == 0, "Strings: hex length insufficient");
172         return string(buffer);
173     }
174 }
175 
176 // File: erc721a/contracts/IERC721A.sol
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
439 // File: erc721a/contracts/ERC721A.sol
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
605         if (owner == address(0)) revert BalanceQueryForZeroAddress();
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
882         if (to == address(0)) revert MintToZeroAddress();
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
942         if (to == address(0)) revert MintToZeroAddress();
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
999         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1000             isApprovedForAll(from, _msgSenderERC721A()) ||
1001             getApproved(tokenId) == _msgSenderERC721A());
1002 
1003         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1004         if (to == address(0)) revert TransferToZeroAddress();
1005 
1006         _beforeTokenTransfers(from, to, tokenId, 1);
1007 
1008         // Clear approvals from the previous owner.
1009         delete _tokenApprovals[tokenId];
1010 
1011         // Underflow of the sender's balance is impossible because we check for
1012         // ownership above and the recipient's balance can't realistically overflow.
1013         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1014         unchecked {
1015             // We can directly increment and decrement the balances.
1016             --_packedAddressData[from]; // Updates: `balance -= 1`.
1017             ++_packedAddressData[to]; // Updates: `balance += 1`.
1018 
1019             // Updates:
1020             // - `address` to the next owner.
1021             // - `startTimestamp` to the timestamp of transfering.
1022             // - `burned` to `false`.
1023             // - `nextInitialized` to `true`.
1024             _packedOwnerships[tokenId] =
1025                 _addressToUint256(to) |
1026                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1027                 BITMASK_NEXT_INITIALIZED;
1028 
1029             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1030             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1031                 uint256 nextTokenId = tokenId + 1;
1032                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1033                 if (_packedOwnerships[nextTokenId] == 0) {
1034                     // If the next slot is within bounds.
1035                     if (nextTokenId != _currentIndex) {
1036                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1037                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1038                     }
1039                 }
1040             }
1041         }
1042 
1043         emit Transfer(from, to, tokenId);
1044         _afterTokenTransfers(from, to, tokenId, 1);
1045     }
1046 
1047     /**
1048      * @dev Equivalent to `_burn(tokenId, false)`.
1049      */
1050     function _burn(uint256 tokenId) internal virtual {
1051         _burn(tokenId, false);
1052     }
1053 
1054     /**
1055      * @dev Destroys `tokenId`.
1056      * The approval is cleared when the token is burned.
1057      *
1058      * Requirements:
1059      *
1060      * - `tokenId` must exist.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1065         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1066 
1067         address from = address(uint160(prevOwnershipPacked));
1068 
1069         if (approvalCheck) {
1070             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1071                 isApprovedForAll(from, _msgSenderERC721A()) ||
1072                 getApproved(tokenId) == _msgSenderERC721A());
1073 
1074             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1075         }
1076 
1077         _beforeTokenTransfers(from, address(0), tokenId, 1);
1078 
1079         // Clear approvals from the previous owner.
1080         delete _tokenApprovals[tokenId];
1081 
1082         // Underflow of the sender's balance is impossible because we check for
1083         // ownership above and the recipient's balance can't realistically overflow.
1084         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1085         unchecked {
1086             // Updates:
1087             // - `balance -= 1`.
1088             // - `numberBurned += 1`.
1089             //
1090             // We can directly decrement the balance, and increment the number burned.
1091             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1092             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1093 
1094             // Updates:
1095             // - `address` to the last owner.
1096             // - `startTimestamp` to the timestamp of burning.
1097             // - `burned` to `true`.
1098             // - `nextInitialized` to `true`.
1099             _packedOwnerships[tokenId] =
1100                 _addressToUint256(from) |
1101                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1102                 BITMASK_BURNED | 
1103                 BITMASK_NEXT_INITIALIZED;
1104 
1105             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1106             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1107                 uint256 nextTokenId = tokenId + 1;
1108                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1109                 if (_packedOwnerships[nextTokenId] == 0) {
1110                     // If the next slot is within bounds.
1111                     if (nextTokenId != _currentIndex) {
1112                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1113                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1114                     }
1115                 }
1116             }
1117         }
1118 
1119         emit Transfer(from, address(0), tokenId);
1120         _afterTokenTransfers(from, address(0), tokenId, 1);
1121 
1122         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1123         unchecked {
1124             _burnCounter++;
1125         }
1126     }
1127 
1128     /**
1129      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1130      *
1131      * @param from address representing the previous owner of the given token ID
1132      * @param to target address that will receive the tokens
1133      * @param tokenId uint256 ID of the token to be transferred
1134      * @param _data bytes optional data to send along with the call
1135      * @return bool whether the call correctly returned the expected magic value
1136      */
1137     function _checkContractOnERC721Received(
1138         address from,
1139         address to,
1140         uint256 tokenId,
1141         bytes memory _data
1142     ) private returns (bool) {
1143         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1144             bytes4 retval
1145         ) {
1146             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1147         } catch (bytes memory reason) {
1148             if (reason.length == 0) {
1149                 revert TransferToNonERC721ReceiverImplementer();
1150             } else {
1151                 assembly {
1152                     revert(add(32, reason), mload(reason))
1153                 }
1154             }
1155         }
1156     }
1157 
1158     /**
1159      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1160      * And also called before burning one token.
1161      *
1162      * startTokenId - the first token id to be transferred
1163      * quantity - the amount to be transferred
1164      *
1165      * Calling conditions:
1166      *
1167      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1168      * transferred to `to`.
1169      * - When `from` is zero, `tokenId` will be minted for `to`.
1170      * - When `to` is zero, `tokenId` will be burned by `from`.
1171      * - `from` and `to` are never both zero.
1172      */
1173     function _beforeTokenTransfers(
1174         address from,
1175         address to,
1176         uint256 startTokenId,
1177         uint256 quantity
1178     ) internal virtual {}
1179 
1180     /**
1181      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1182      * minting.
1183      * And also called after one token has been burned.
1184      *
1185      * startTokenId - the first token id to be transferred
1186      * quantity - the amount to be transferred
1187      *
1188      * Calling conditions:
1189      *
1190      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1191      * transferred to `to`.
1192      * - When `from` is zero, `tokenId` has been minted for `to`.
1193      * - When `to` is zero, `tokenId` has been burned by `from`.
1194      * - `from` and `to` are never both zero.
1195      */
1196     function _afterTokenTransfers(
1197         address from,
1198         address to,
1199         uint256 startTokenId,
1200         uint256 quantity
1201     ) internal virtual {}
1202 
1203     /**
1204      * @dev Returns the message sender (defaults to `msg.sender`).
1205      *
1206      * If you are writing GSN compatible contracts, you need to override this function.
1207      */
1208     function _msgSenderERC721A() internal view virtual returns (address) {
1209         return msg.sender;
1210     }
1211 
1212     /**
1213      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1214      */
1215     function _toString(uint256 value) internal pure returns (string memory ptr) {
1216         assembly {
1217             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1218             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1219             // We will need 1 32-byte word to store the length, 
1220             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1221             ptr := add(mload(0x40), 128)
1222             // Update the free memory pointer to allocate.
1223             mstore(0x40, ptr)
1224 
1225             // Cache the end of the memory to calculate the length later.
1226             let end := ptr
1227 
1228             // We write the string from the rightmost digit to the leftmost digit.
1229             // The following is essentially a do-while loop that also handles the zero case.
1230             // Costs a bit more than early returning for the zero case,
1231             // but cheaper in terms of deployment and overall runtime costs.
1232             for { 
1233                 // Initialize and perform the first pass without check.
1234                 let temp := value
1235                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1236                 ptr := sub(ptr, 1)
1237                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1238                 mstore8(ptr, add(48, mod(temp, 10)))
1239                 temp := div(temp, 10)
1240             } temp { 
1241                 // Keep dividing `temp` until zero.
1242                 temp := div(temp, 10)
1243             } { // Body of the for loop.
1244                 ptr := sub(ptr, 1)
1245                 mstore8(ptr, add(48, mod(temp, 10)))
1246             }
1247             
1248             let length := sub(end, ptr)
1249             // Move the pointer 32 bytes leftwards to make room for the length.
1250             ptr := sub(ptr, 32)
1251             // Store the length.
1252             mstore(ptr, length)
1253         }
1254     }
1255 }
1256 
1257 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1258 
1259 
1260 // ERC721A Contracts v4.0.0
1261 // Creator: Chiru Labs
1262 
1263 pragma solidity ^0.8.4;
1264 
1265 
1266 /**
1267  * @dev Interface of an ERC721AQueryable compliant contract.
1268  */
1269 interface IERC721AQueryable is IERC721A {
1270     /**
1271      * Invalid query range (`start` >= `stop`).
1272      */
1273     error InvalidQueryRange();
1274 
1275     /**
1276      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1277      *
1278      * If the `tokenId` is out of bounds:
1279      *   - `addr` = `address(0)`
1280      *   - `startTimestamp` = `0`
1281      *   - `burned` = `false`
1282      *
1283      * If the `tokenId` is burned:
1284      *   - `addr` = `<Address of owner before token was burned>`
1285      *   - `startTimestamp` = `<Timestamp when token was burned>`
1286      *   - `burned = `true`
1287      *
1288      * Otherwise:
1289      *   - `addr` = `<Address of owner>`
1290      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1291      *   - `burned = `false`
1292      */
1293     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1294 
1295     /**
1296      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1297      * See {ERC721AQueryable-explicitOwnershipOf}
1298      */
1299     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1300 
1301     /**
1302      * @dev Returns an array of token IDs owned by `owner`,
1303      * in the range [`start`, `stop`)
1304      * (i.e. `start <= tokenId < stop`).
1305      *
1306      * This function allows for tokens to be queried if the collection
1307      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1308      *
1309      * Requirements:
1310      *
1311      * - `start` < `stop`
1312      */
1313     function tokensOfOwnerIn(
1314         address owner,
1315         uint256 start,
1316         uint256 stop
1317     ) external view returns (uint256[] memory);
1318 
1319     /**
1320      * @dev Returns an array of token IDs owned by `owner`.
1321      *
1322      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1323      * It is meant to be called off-chain.
1324      *
1325      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1326      * multiple smaller scans if the collection is large enough to cause
1327      * an out-of-gas error (10K pfp collections should be fine).
1328      */
1329     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1330 }
1331 
1332 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1333 
1334 
1335 // ERC721A Contracts v4.0.0
1336 // Creator: Chiru Labs
1337 
1338 pragma solidity ^0.8.4;
1339 
1340 
1341 
1342 /**
1343  * @title ERC721A Queryable
1344  * @dev ERC721A subclass with convenience query functions.
1345  */
1346 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1347     /**
1348      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1349      *
1350      * If the `tokenId` is out of bounds:
1351      *   - `addr` = `address(0)`
1352      *   - `startTimestamp` = `0`
1353      *   - `burned` = `false`
1354      *
1355      * If the `tokenId` is burned:
1356      *   - `addr` = `<Address of owner before token was burned>`
1357      *   - `startTimestamp` = `<Timestamp when token was burned>`
1358      *   - `burned = `true`
1359      *
1360      * Otherwise:
1361      *   - `addr` = `<Address of owner>`
1362      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1363      *   - `burned = `false`
1364      */
1365     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1366         TokenOwnership memory ownership;
1367         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1368             return ownership;
1369         }
1370         ownership = _ownershipAt(tokenId);
1371         if (ownership.burned) {
1372             return ownership;
1373         }
1374         return _ownershipOf(tokenId);
1375     }
1376 
1377     /**
1378      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1379      * See {ERC721AQueryable-explicitOwnershipOf}
1380      */
1381     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1382         unchecked {
1383             uint256 tokenIdsLength = tokenIds.length;
1384             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1385             for (uint256 i; i != tokenIdsLength; ++i) {
1386                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1387             }
1388             return ownerships;
1389         }
1390     }
1391 
1392     /**
1393      * @dev Returns an array of token IDs owned by `owner`,
1394      * in the range [`start`, `stop`)
1395      * (i.e. `start <= tokenId < stop`).
1396      *
1397      * This function allows for tokens to be queried if the collection
1398      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1399      *
1400      * Requirements:
1401      *
1402      * - `start` < `stop`
1403      */
1404     function tokensOfOwnerIn(
1405         address owner,
1406         uint256 start,
1407         uint256 stop
1408     ) external view override returns (uint256[] memory) {
1409         unchecked {
1410             if (start >= stop) revert InvalidQueryRange();
1411             uint256 tokenIdsIdx;
1412             uint256 stopLimit = _nextTokenId();
1413             // Set `start = max(start, _startTokenId())`.
1414             if (start < _startTokenId()) {
1415                 start = _startTokenId();
1416             }
1417             // Set `stop = min(stop, stopLimit)`.
1418             if (stop > stopLimit) {
1419                 stop = stopLimit;
1420             }
1421             uint256 tokenIdsMaxLength = balanceOf(owner);
1422             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1423             // to cater for cases where `balanceOf(owner)` is too big.
1424             if (start < stop) {
1425                 uint256 rangeLength = stop - start;
1426                 if (rangeLength < tokenIdsMaxLength) {
1427                     tokenIdsMaxLength = rangeLength;
1428                 }
1429             } else {
1430                 tokenIdsMaxLength = 0;
1431             }
1432             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1433             if (tokenIdsMaxLength == 0) {
1434                 return tokenIds;
1435             }
1436             // We need to call `explicitOwnershipOf(start)`,
1437             // because the slot at `start` may not be initialized.
1438             TokenOwnership memory ownership = explicitOwnershipOf(start);
1439             address currOwnershipAddr;
1440             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1441             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1442             if (!ownership.burned) {
1443                 currOwnershipAddr = ownership.addr;
1444             }
1445             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1446                 ownership = _ownershipAt(i);
1447                 if (ownership.burned) {
1448                     continue;
1449                 }
1450                 if (ownership.addr != address(0)) {
1451                     currOwnershipAddr = ownership.addr;
1452                 }
1453                 if (currOwnershipAddr == owner) {
1454                     tokenIds[tokenIdsIdx++] = i;
1455                 }
1456             }
1457             // Downsize the array to fit.
1458             assembly {
1459                 mstore(tokenIds, tokenIdsIdx)
1460             }
1461             return tokenIds;
1462         }
1463     }
1464 
1465     /**
1466      * @dev Returns an array of token IDs owned by `owner`.
1467      *
1468      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1469      * It is meant to be called off-chain.
1470      *
1471      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1472      * multiple smaller scans if the collection is large enough to cause
1473      * an out-of-gas error (10K pfp collections should be fine).
1474      */
1475     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1476         unchecked {
1477             uint256 tokenIdsIdx;
1478             address currOwnershipAddr;
1479             uint256 tokenIdsLength = balanceOf(owner);
1480             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1481             TokenOwnership memory ownership;
1482             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1483                 ownership = _ownershipAt(i);
1484                 if (ownership.burned) {
1485                     continue;
1486                 }
1487                 if (ownership.addr != address(0)) {
1488                     currOwnershipAddr = ownership.addr;
1489                 }
1490                 if (currOwnershipAddr == owner) {
1491                     tokenIds[tokenIdsIdx++] = i;
1492                 }
1493             }
1494             return tokenIds;
1495         }
1496     }
1497 }
1498 
1499 // File: contracts/FluffyFucksReborn.sol
1500 
1501 
1502 
1503 pragma solidity >=0.7.0 <0.9.0;
1504 
1505 
1506 
1507 
1508 contract FluffyFucksReborn is ERC721AQueryable, Ownable {
1509   using Strings for uint256;
1510 
1511   string public uriPrefix = ""; //http://www.site.com/data/
1512   string public uriSuffix = ".json";
1513 
1514   string public _contractURI = "";
1515 
1516   uint256 public maxSupply = 6061;
1517 
1518   bool public paused = false;
1519 
1520   constructor() ERC721A("Fluffy Fucks", "FFXv2") {
1521   }
1522 
1523   function _startTokenId()
1524         internal
1525         pure
1526         override
1527         returns(uint256)
1528     {
1529         return 1;
1530     }
1531 
1532   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1533     require(!paused, "The contract is paused!");
1534     require(totalSupply() + _mintAmount < maxSupply, "Max supply exceeded!");
1535     _safeMint(_receiver, _mintAmount);
1536   }
1537 
1538   function mintForAddressMultiple(address[] calldata addresses, uint256[] calldata amount) public onlyOwner
1539   {
1540     require(!paused, "The contract is paused!");
1541     require(addresses.length == amount.length, "Address and amount length mismatch");
1542 
1543     for (uint256 i; i < addresses.length; ++i)
1544     {
1545       _safeMint(addresses[i], amount[i]);
1546     }
1547 
1548     require(totalSupply() < maxSupply, "Max supply exceeded!");
1549   }
1550 
1551   function tokenURI(uint256 _tokenId)
1552     public
1553     view
1554     virtual
1555     override (ERC721A, IERC721A)
1556     returns (string memory)
1557   {
1558     require(
1559       _exists(_tokenId),
1560       "ERC721Metadata: URI query for nonexistent token"
1561     );
1562 
1563     string memory currentBaseURI = _baseURI();
1564     return bytes(currentBaseURI).length > 0
1565         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1566         : "";
1567   }
1568 
1569   function contractURI()
1570   public
1571   view
1572   returns (string memory)
1573   {
1574         return bytes(_contractURI).length > 0
1575           ? string(abi.encodePacked(_contractURI))
1576           : "";
1577   }
1578 
1579   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1580     uriPrefix = _uriPrefix;
1581   }
1582 
1583   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1584     uriSuffix = _uriSuffix;
1585   }
1586 
1587   function setContractURI(string memory newContractURI) public onlyOwner {
1588     _contractURI = newContractURI;
1589   }
1590 
1591   function setPaused(bool _state) public onlyOwner {
1592     paused = _state;
1593   }
1594 
1595   function withdraw() public onlyOwner {
1596     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1597     require(os);
1598   }
1599 
1600   function _baseURI() internal view virtual override returns (string memory) {
1601     return uriPrefix;
1602   }
1603 
1604 }
1605 
1606 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1607 
1608 
1609 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1610 
1611 pragma solidity ^0.8.0;
1612 
1613 /**
1614  * @dev Contract module that helps prevent reentrant calls to a function.
1615  *
1616  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1617  * available, which can be applied to functions to make sure there are no nested
1618  * (reentrant) calls to them.
1619  *
1620  * Note that because there is a single `nonReentrant` guard, functions marked as
1621  * `nonReentrant` may not call one another. This can be worked around by making
1622  * those functions `private`, and then adding `external` `nonReentrant` entry
1623  * points to them.
1624  *
1625  * TIP: If you would like to learn more about reentrancy and alternative ways
1626  * to protect against it, check out our blog post
1627  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1628  */
1629 abstract contract ReentrancyGuard {
1630     // Booleans are more expensive than uint256 or any type that takes up a full
1631     // word because each write operation emits an extra SLOAD to first read the
1632     // slot's contents, replace the bits taken up by the boolean, and then write
1633     // back. This is the compiler's defense against contract upgrades and
1634     // pointer aliasing, and it cannot be disabled.
1635 
1636     // The values being non-zero value makes deployment a bit more expensive,
1637     // but in exchange the refund on every call to nonReentrant will be lower in
1638     // amount. Since refunds are capped to a percentage of the total
1639     // transaction's gas, it is best to keep them low in cases like this one, to
1640     // increase the likelihood of the full refund coming into effect.
1641     uint256 private constant _NOT_ENTERED = 1;
1642     uint256 private constant _ENTERED = 2;
1643 
1644     uint256 private _status;
1645 
1646     constructor() {
1647         _status = _NOT_ENTERED;
1648     }
1649 
1650     /**
1651      * @dev Prevents a contract from calling itself, directly or indirectly.
1652      * Calling a `nonReentrant` function from another `nonReentrant`
1653      * function is not supported. It is possible to prevent this from happening
1654      * by making the `nonReentrant` function external, and making it call a
1655      * `private` function that does the actual work.
1656      */
1657     modifier nonReentrant() {
1658         // On the first call to nonReentrant, _notEntered will be true
1659         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1660 
1661         // Any calls to nonReentrant after this point will fail
1662         _status = _ENTERED;
1663 
1664         _;
1665 
1666         // By storing the original value once again, a refund is triggered (see
1667         // https://eips.ethereum.org/EIPS/eip-2200)
1668         _status = _NOT_ENTERED;
1669     }
1670 }
1671 
1672 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1673 
1674 
1675 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1676 
1677 pragma solidity ^0.8.0;
1678 
1679 /**
1680  * @title ERC721 token receiver interface
1681  * @dev Interface for any contract that wants to support safeTransfers
1682  * from ERC721 asset contracts.
1683  */
1684 interface IERC721Receiver {
1685     /**
1686      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1687      * by `operator` from `from`, this function is called.
1688      *
1689      * It must return its Solidity selector to confirm the token transfer.
1690      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1691      *
1692      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1693      */
1694     function onERC721Received(
1695         address operator,
1696         address from,
1697         uint256 tokenId,
1698         bytes calldata data
1699     ) external returns (bytes4);
1700 }
1701 
1702 // File: contracts/FluffyStaker.sol
1703 
1704 /**
1705  * SPDX-License-Identifier: UNLICENSED
1706  */
1707 
1708 pragma solidity >=0.8.0 <0.9.0;
1709 
1710 
1711 
1712 
1713 contract FluffyStaker is IERC721Receiver, ReentrancyGuard {
1714     address public ownerAddress;
1715     bool public active = true;
1716 
1717     mapping(uint256 => address) staked;
1718 
1719     FluffyFucksReborn public ffxr;
1720 
1721     constructor()
1722     {
1723         ownerAddress = msg.sender;
1724     }
1725 
1726     fallback() external payable nonReentrant 
1727     {
1728         revert();
1729     }
1730     receive() external payable nonReentrant 
1731     {
1732         revert();
1733     }
1734 
1735     /**
1736      * on token received
1737      */
1738     function onERC721Received
1739     (
1740         address /*operator*/,
1741         address from, 
1742         uint256 tokenId, 
1743         bytes calldata /*data*/
1744     ) 
1745         public
1746         override
1747         onlyFromFluffyContract(msg.sender)
1748         returns(bytes4) 
1749     {
1750         staked[tokenId] = from;
1751         return IERC721Receiver.onERC721Received.selector;
1752     }
1753 
1754     /**
1755      * ADMIN ONLY
1756     */
1757 
1758     function setFluffyAddress(address contractAddress)
1759         public
1760         onlyOwner
1761     {
1762         ffxr = FluffyFucksReborn(contractAddress);
1763     }
1764 
1765     function restoreOddball(uint256 tokenId, address restoreTo)
1766         public
1767         onlyOwner
1768     {
1769         require(staked[tokenId] == address(0x0), "Token has a known owner.");
1770         ffxr.safeTransferFrom(address(this), restoreTo, tokenId);
1771     }
1772 
1773     function forceUnstake(uint256 tokenId)
1774         public
1775         onlyOwner
1776     {
1777         _forceUnstake(tokenId);
1778     }
1779 
1780     function forceUnstakeBatch(uint256[] calldata tokenIds)
1781         public
1782         onlyOwner
1783     {
1784         for(uint256 i = 0; i < tokenIds.length; ++i) {
1785             _forceUnstake(tokenIds[i]);
1786         }
1787     }
1788 
1789     function forceUnstakeAll()
1790         public
1791         onlyOwner
1792     {
1793         uint256[] memory tokens = ffxr.tokensOfOwner(address(this));
1794         for(uint256 i = 0; i < tokens.length; ++i) {
1795             _forceUnstake(tokens[i]);
1796         }
1797     }
1798 
1799     function _forceUnstake(uint256 tokenId)
1800         private
1801         onlyOwner
1802     {
1803         if(staked[tokenId] != address(0x0)) {
1804             ffxr.safeTransferFrom(address(this), staked[tokenId], tokenId);
1805             staked[tokenId] = address(0x0);
1806         }
1807     }
1808 
1809     function toggleActive(bool setTo) 
1810         public
1811         onlyOwner
1812     {
1813         active = setTo;
1814     }
1815 
1816     /**
1817      * LOOKUPS
1818      */
1819 
1820     function tokenStaker(uint256 tokenId) 
1821         public 
1822         view
1823         returns(address) 
1824     {
1825         return staked[tokenId];
1826     }
1827 
1828     function tokenStakers(uint256[] calldata tokenIds)
1829         public
1830         view
1831         returns(address[] memory)
1832     {
1833         address[] memory stakers = new address[](tokenIds.length);
1834         for(uint256 i = 0; i < tokenIds.length; ++i) {
1835             stakers[i] = staked[tokenIds[i]];
1836         }
1837         return stakers;
1838     }
1839 
1840     function allTokenStakers()
1841         isFluffyContractSet
1842         public 
1843         view
1844         returns (uint256[] memory, address[] memory)
1845     {
1846         uint256[] memory tokens = ffxr.tokensOfOwner(address(this));
1847 
1848         uint256[] memory stakedTokens;
1849         address[] memory stakers;
1850         
1851         uint256 count = 0;
1852         for(uint256 i = 0; i < tokens.length; ++i) {
1853             if (staked[tokens[i]] != address(0x0)) {
1854                 ++count;
1855             }
1856         }
1857 
1858         stakedTokens = new uint256[](count);
1859         stakers = new address[](count);
1860         count = 0;
1861 
1862         for(uint256 i = 0; i < tokens.length; ++i) {
1863             stakedTokens[count] = tokens[i];
1864             stakers[count] = staked[tokens[i]];
1865             count++;
1866         }
1867 
1868         return (stakedTokens, stakers);
1869     }
1870 
1871     function totalStaked()
1872         isFluffyContractSet
1873         public
1874         view
1875         returns (uint256 count)
1876     {
1877         uint256[] memory tokens = ffxr.tokensOfOwner(address(this));
1878         count = 0;
1879         for (uint256 i = 0; i < tokens.length; i++) {
1880             if (staked[tokens[i]] != address(0x0)) {
1881                 ++count;
1882             }
1883         }
1884     }
1885 
1886     function tokensStakedByAddress(address ogOwner)
1887         public
1888         view
1889         returns(uint256[] memory tokenIds)
1890     {
1891         uint256[] memory tokens = ffxr.tokensOfOwner(address(this));
1892         uint256 owned = 0;
1893         for (uint256 i = 0; i < tokens.length; ++i) {
1894             if (ogOwner == staked[tokens[i]]) {
1895                 ++owned;
1896             }
1897         }
1898 
1899         tokenIds = new uint256[](owned);
1900         owned = 0;
1901         for (uint256 i = 0; i < tokens.length; ++i) {
1902             if (ogOwner == staked[tokens[i]]) {
1903                 tokenIds[owned] = tokens[i];
1904                 ++owned;
1905             }
1906         }
1907     }
1908 
1909     function isStakingEnabled()
1910         public
1911         view
1912         returns (bool)
1913     {
1914         return this.isStakingEnabled(msg.sender);
1915     }
1916 
1917     function isStakingEnabled(address send)
1918         public
1919         view
1920         returns (bool)
1921     {
1922         return ffxr.isApprovedForAll(send, address(this));
1923     }
1924 
1925     function oddballTokensThatShouldNotBeHere()
1926         public
1927         view
1928         returns (uint256[] memory tokenIds)
1929     {
1930         uint256 count = 0;
1931         uint256[] memory tokens = ffxr.tokensOfOwner(address(this));
1932         for(uint256 i = 0; i < tokens.length; ++i) {
1933             if (staked[tokens[i]] == address(0x0)) {
1934                 ++count;
1935             }
1936         }
1937 
1938         tokenIds = new uint256[](count);
1939         count = 0;
1940         for(uint256 i = 0; i < tokens.length; ++i) {
1941             if (staked[tokens[i]] == address(0x0)) {
1942                 tokenIds[count] = tokens[i];
1943                 ++count;
1944             }
1945         }
1946     }
1947 
1948     /**
1949      * STAKING
1950      */
1951 
1952     function stakeBatch(uint256[] calldata tokenIds)
1953         isStakingActive
1954         isApproved(msg.sender)
1955         external
1956     {
1957         for (uint256 i = 0; i < tokenIds.length; ++i) {
1958             _stake(tokenIds[i]);
1959         }
1960     }
1961 
1962     function stake(uint256 tokenId)
1963         isStakingActive
1964         isApproved(msg.sender)
1965         external
1966     {
1967         _stake(tokenId);
1968     }
1969 
1970     function _stake(uint256 tokenId)
1971         isFluffyContractSet
1972         private
1973     {
1974         ffxr.safeTransferFrom(msg.sender, address(this), tokenId);
1975     }
1976 
1977     /**
1978      * UNSTAKING
1979      */
1980 
1981     function unstakeBatch(uint256[] calldata tokenIds)
1982         external
1983     {
1984         for (uint256 i = 0; i < tokenIds.length; ++i) {
1985             _unstake(tokenIds[i]);
1986         }
1987     }
1988 
1989     function unstake(uint256 tokenId)
1990         external
1991     {
1992         _unstake(tokenId);
1993     }
1994 
1995     function _unstake(uint256 tokenId)
1996         isFluffyContractSet
1997         onlyOriginalTokenOwner(tokenId)
1998         private
1999     {
2000         ffxr.safeTransferFrom(address(this), staked[tokenId], tokenId);
2001         staked[tokenId] = address(0x0);
2002     }
2003 
2004     /**
2005      * MODIFIERS
2006      */
2007     modifier onlyOriginalTokenOwner(uint256 tokenId)
2008     {
2009         require(msg.sender == staked[tokenId], "You are not tokens original owner");
2010         _;
2011     }
2012 
2013     modifier onlyOwner()
2014     {
2015         require(msg.sender == ownerAddress, "You are not owner.");
2016         _;
2017     }
2018 
2019     modifier onlyFromFluffyContract(address sentFromAddress)
2020     {
2021         require(sentFromAddress == address(ffxr), "Not sent from Fluffy contract.");
2022         _;
2023     }
2024 
2025     modifier isFluffyContractSet()
2026     {
2027         require(address(ffxr) != address(0x0), "Fluffy address is not set");
2028         _;
2029     }
2030 
2031     modifier isApproved(address send)
2032     {
2033         require(this.isStakingEnabled(send), "You have not approved FluffyStaker.");
2034         _;
2035     }
2036 
2037     modifier isStakingActive()
2038     {
2039         require(active, "Staking is not active.");
2040         _;
2041     }
2042 }