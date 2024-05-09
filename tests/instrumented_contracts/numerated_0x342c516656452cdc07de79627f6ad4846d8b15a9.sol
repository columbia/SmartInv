1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor() {
46         _transferOwnership(_msgSender());
47     }
48 
49     /**
50      * @dev Returns the address of the current owner.
51      */
52     function owner() public view virtual returns (address) {
53         return _owner;
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(owner() == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     /**
65      * @dev Leaves the contract without owner. It will not be possible to call
66      * `onlyOwner` functions anymore. Can only be called by the current owner.
67      *
68      * NOTE: Renouncing ownership will leave the contract without an owner,
69      * thereby removing any functionality that is only available to the owner.
70      */
71     function renounceOwnership() public virtual onlyOwner {
72         _transferOwnership(address(0));
73     }
74 
75     /**
76      * @dev Transfers ownership of the contract to a new account (`newOwner`).
77      * Can only be called by the current owner.
78      */
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         _transferOwnership(newOwner);
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Internal function without access restriction.
87      */
88     function _transferOwnership(address newOwner) internal virtual {
89         address oldOwner = _owner;
90         _owner = newOwner;
91         emit OwnershipTransferred(oldOwner, newOwner);
92     }
93 }
94 
95 /**
96  * @dev String operations.
97  */
98 library Strings {
99     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
103      */
104     function toString(uint256 value) internal pure returns (string memory) {
105         // Inspired by OraclizeAPI's implementation - MIT licence
106         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
107 
108         if (value == 0) {
109             return "0";
110         }
111         uint256 temp = value;
112         uint256 digits;
113         while (temp != 0) {
114             digits++;
115             temp /= 10;
116         }
117         bytes memory buffer = new bytes(digits);
118         while (value != 0) {
119             digits -= 1;
120             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
121             value /= 10;
122         }
123         return string(buffer);
124     }
125 
126     /**
127      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
128      */
129     function toHexString(uint256 value) internal pure returns (string memory) {
130         if (value == 0) {
131             return "0x00";
132         }
133         uint256 temp = value;
134         uint256 length = 0;
135         while (temp != 0) {
136             length++;
137             temp >>= 8;
138         }
139         return toHexString(value, length);
140     }
141 
142     /**
143      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
144      */
145     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
146         bytes memory buffer = new bytes(2 * length + 2);
147         buffer[0] = "0";
148         buffer[1] = "x";
149         for (uint256 i = 2 * length + 1; i > 1; --i) {
150             buffer[i] = _HEX_SYMBOLS[value & 0xf];
151             value >>= 4;
152         }
153         require(value == 0, "Strings: hex length insufficient");
154         return string(buffer);
155     }
156 }
157 
158 /**
159  * @dev Interface of an ERC721A compliant contract.
160  */
161 interface IERC721A {
162     /**
163      * The caller must own the token or be an approved operator.
164      */
165     error ApprovalCallerNotOwnerNorApproved();
166 
167     /**
168      * The token does not exist.
169      */
170     error ApprovalQueryForNonexistentToken();
171 
172     /**
173      * The caller cannot approve to their own address.
174      */
175     error ApproveToCaller();
176 
177     /**
178      * The caller cannot approve to the current owner.
179      */
180     error ApprovalToCurrentOwner();
181 
182     /**
183      * Cannot query the balance for the zero address.
184      */
185     error BalanceQueryForZeroAddress();
186 
187     /**
188      * Cannot mint to the zero address.
189      */
190     error MintToZeroAddress();
191 
192     /**
193      * The quantity of tokens minted must be more than zero.
194      */
195     error MintZeroQuantity();
196 
197     /**
198      * The token does not exist.
199      */
200     error OwnerQueryForNonexistentToken();
201 
202     /**
203      * The caller must own the token or be an approved operator.
204      */
205     error TransferCallerNotOwnerNorApproved();
206 
207     /**
208      * The token must be owned by `from`.
209      */
210     error TransferFromIncorrectOwner();
211 
212     /**
213      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
214      */
215     error TransferToNonERC721ReceiverImplementer();
216 
217     /**
218      * Cannot transfer to the zero address.
219      */
220     error TransferToZeroAddress();
221 
222     /**
223      * The token does not exist.
224      */
225     error URIQueryForNonexistentToken();
226 
227     struct TokenOwnership {
228         // The address of the owner.
229         address addr;
230         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
231         uint64 startTimestamp;
232         // Whether the token has been burned.
233         bool burned;
234     }
235 
236     /**
237      * @dev Returns the total amount of tokens stored by the contract.
238      *
239      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
240      */
241     function totalSupply() external view returns (uint256);
242 
243     // ==============================
244     //            IERC165
245     // ==============================
246 
247     /**
248      * @dev Returns true if this contract implements the interface defined by
249      * `interfaceId`. See the corresponding
250      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
251      * to learn more about how these ids are created.
252      *
253      * This function call must use less than 30 000 gas.
254      */
255     function supportsInterface(bytes4 interfaceId) external view returns (bool);
256 
257     // ==============================
258     //            IERC721
259     // ==============================
260 
261     /**
262      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
263      */
264     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
265 
266     /**
267      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
268      */
269     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
270 
271     /**
272      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
273      */
274     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
275 
276     /**
277      * @dev Returns the number of tokens in ``owner``'s account.
278      */
279     function balanceOf(address owner) external view returns (uint256 balance);
280 
281     /**
282      * @dev Returns the owner of the `tokenId` token.
283      *
284      * Requirements:
285      *
286      * - `tokenId` must exist.
287      */
288     function ownerOf(uint256 tokenId) external view returns (address owner);
289 
290     /**
291      * @dev Safely transfers `tokenId` token from `from` to `to`.
292      *
293      * Requirements:
294      *
295      * - `from` cannot be the zero address.
296      * - `to` cannot be the zero address.
297      * - `tokenId` token must exist and be owned by `from`.
298      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
299      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
300      *
301      * Emits a {Transfer} event.
302      */
303     function safeTransferFrom(
304         address from,
305         address to,
306         uint256 tokenId,
307         bytes calldata data
308     ) external;
309 
310     /**
311      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
312      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
313      *
314      * Requirements:
315      *
316      * - `from` cannot be the zero address.
317      * - `to` cannot be the zero address.
318      * - `tokenId` token must exist and be owned by `from`.
319      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
320      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
321      *
322      * Emits a {Transfer} event.
323      */
324     function safeTransferFrom(
325         address from,
326         address to,
327         uint256 tokenId
328     ) external;
329 
330     /**
331      * @dev Transfers `tokenId` token from `from` to `to`.
332      *
333      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
334      *
335      * Requirements:
336      *
337      * - `from` cannot be the zero address.
338      * - `to` cannot be the zero address.
339      * - `tokenId` token must be owned by `from`.
340      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
341      *
342      * Emits a {Transfer} event.
343      */
344     function transferFrom(
345         address from,
346         address to,
347         uint256 tokenId
348     ) external;
349 
350     /**
351      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
352      * The approval is cleared when the token is transferred.
353      *
354      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
355      *
356      * Requirements:
357      *
358      * - The caller must own the token or be an approved operator.
359      * - `tokenId` must exist.
360      *
361      * Emits an {Approval} event.
362      */
363     function approve(address to, uint256 tokenId) external;
364 
365     /**
366      * @dev Approve or remove `operator` as an operator for the caller.
367      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
368      *
369      * Requirements:
370      *
371      * - The `operator` cannot be the caller.
372      *
373      * Emits an {ApprovalForAll} event.
374      */
375     function setApprovalForAll(address operator, bool _approved) external;
376 
377     /**
378      * @dev Returns the account approved for `tokenId` token.
379      *
380      * Requirements:
381      *
382      * - `tokenId` must exist.
383      */
384     function getApproved(uint256 tokenId) external view returns (address operator);
385 
386     /**
387      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
388      *
389      * See {setApprovalForAll}
390      */
391     function isApprovedForAll(address owner, address operator) external view returns (bool);
392 
393     // ==============================
394     //        IERC721Metadata
395     // ==============================
396 
397     /**
398      * @dev Returns the token collection name.
399      */
400     function name() external view returns (string memory);
401 
402     /**
403      * @dev Returns the token collection symbol.
404      */
405     function symbol() external view returns (string memory);
406 
407     /**
408      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
409      */
410     function tokenURI(uint256 tokenId) external view returns (string memory);
411 }
412 
413 /**
414  * @dev ERC721 token receiver interface.
415  */
416 interface ERC721A__IERC721Receiver {
417     function onERC721Received(
418         address operator,
419         address from,
420         uint256 tokenId,
421         bytes calldata data
422     ) external returns (bytes4);
423 }
424 
425 /**
426  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
427  * the Metadata extension. Built to optimize for lower gas during batch mints.
428  *
429  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
430  *
431  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
432  *
433  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
434  */
435 contract ERC721A is IERC721A {
436     // Mask of an entry in packed address data.
437     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
438 
439     // The bit position of `numberMinted` in packed address data.
440     uint256 private constant BITPOS_NUMBER_MINTED = 64;
441 
442     // The bit position of `numberBurned` in packed address data.
443     uint256 private constant BITPOS_NUMBER_BURNED = 128;
444 
445     // The bit position of `aux` in packed address data.
446     uint256 private constant BITPOS_AUX = 192;
447 
448     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
449     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
450 
451     // The bit position of `startTimestamp` in packed ownership.
452     uint256 private constant BITPOS_START_TIMESTAMP = 160;
453 
454     // The bit mask of the `burned` bit in packed ownership.
455     uint256 private constant BITMASK_BURNED = 1 << 224;
456     
457     // The bit position of the `nextInitialized` bit in packed ownership.
458     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
459 
460     // The bit mask of the `nextInitialized` bit in packed ownership.
461     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
462 
463     // The tokenId of the next token to be minted.
464     uint256 private _currentIndex;
465 
466     // The number of tokens burned.
467     uint256 private _burnCounter;
468 
469     // Token name
470     string private _name;
471 
472     // Token symbol
473     string private _symbol;
474 
475     // Mapping from token ID to ownership details
476     // An empty struct value does not necessarily mean the token is unowned.
477     // See `_packedOwnershipOf` implementation for details.
478     //
479     // Bits Layout:
480     // - [0..159]   `addr`
481     // - [160..223] `startTimestamp`
482     // - [224]      `burned`
483     // - [225]      `nextInitialized`
484     mapping(uint256 => uint256) private _packedOwnerships;
485 
486     // Mapping owner address to address data.
487     //
488     // Bits Layout:
489     // - [0..63]    `balance`
490     // - [64..127]  `numberMinted`
491     // - [128..191] `numberBurned`
492     // - [192..255] `aux`
493     mapping(address => uint256) private _packedAddressData;
494 
495     // Mapping from token ID to approved address.
496     mapping(uint256 => address) private _tokenApprovals;
497 
498     // Mapping from owner to operator approvals
499     mapping(address => mapping(address => bool)) private _operatorApprovals;
500 
501     constructor(string memory name_, string memory symbol_) {
502         _name = name_;
503         _symbol = symbol_;
504         _currentIndex = _startTokenId();
505     }
506 
507     /**
508      * @dev Returns the starting token ID. 
509      * To change the starting token ID, please override this function.
510      */
511     function _startTokenId() internal view virtual returns (uint256) {
512         return 0;
513     }
514 
515     /**
516      * @dev Returns the next token ID to be minted.
517      */
518     function _nextTokenId() internal view returns (uint256) {
519         return _currentIndex;
520     }
521 
522     /**
523      * @dev Returns the total number of tokens in existence.
524      * Burned tokens will reduce the count. 
525      * To get the total number of tokens minted, please see `_totalMinted`.
526      */
527     function totalSupply() public view override returns (uint256) {
528         // Counter underflow is impossible as _burnCounter cannot be incremented
529         // more than `_currentIndex - _startTokenId()` times.
530         unchecked {
531             return _currentIndex - _burnCounter - _startTokenId();
532         }
533     }
534 
535     /**
536      * @dev Returns the total amount of tokens minted in the contract.
537      */
538     function _totalMinted() internal view returns (uint256) {
539         // Counter underflow is impossible as _currentIndex does not decrement,
540         // and it is initialized to `_startTokenId()`
541         unchecked {
542             return _currentIndex - _startTokenId();
543         }
544     }
545 
546     /**
547      * @dev Returns the total number of tokens burned.
548      */
549     function _totalBurned() internal view returns (uint256) {
550         return _burnCounter;
551     }
552 
553     /**
554      * @dev See {IERC165-supportsInterface}.
555      */
556     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
557         // The interface IDs are constants representing the first 4 bytes of the XOR of
558         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
559         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
560         return
561             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
562             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
563             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
564     }
565 
566     /**
567      * @dev See {IERC721-balanceOf}.
568      */
569     function balanceOf(address owner) public view override returns (uint256) {
570         if (owner == address(0)) revert BalanceQueryForZeroAddress();
571         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
572     }
573 
574     /**
575      * Returns the number of tokens minted by `owner`.
576      */
577     function _numberMinted(address owner) internal view returns (uint256) {
578         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
579     }
580 
581     /**
582      * Returns the number of tokens burned by or on behalf of `owner`.
583      */
584     function _numberBurned(address owner) internal view returns (uint256) {
585         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
586     }
587 
588     /**
589      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
590      */
591     function _getAux(address owner) internal view returns (uint64) {
592         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
593     }
594 
595     /**
596      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
597      * If there are multiple variables, please pack them into a uint64.
598      */
599     function _setAux(address owner, uint64 aux) internal {
600         uint256 packed = _packedAddressData[owner];
601         uint256 auxCasted;
602         assembly { // Cast aux without masking.
603             auxCasted := aux
604         }
605         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
606         _packedAddressData[owner] = packed;
607     }
608 
609     /**
610      * Returns the packed ownership data of `tokenId`.
611      */
612     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
613         uint256 curr = tokenId;
614 
615         unchecked {
616             if (_startTokenId() <= curr)
617                 if (curr < _currentIndex) {
618                     uint256 packed = _packedOwnerships[curr];
619                     // If not burned.
620                     if (packed & BITMASK_BURNED == 0) {
621                         // Invariant:
622                         // There will always be an ownership that has an address and is not burned
623                         // before an ownership that does not have an address and is not burned.
624                         // Hence, curr will not underflow.
625                         //
626                         // We can directly compare the packed value.
627                         // If the address is zero, packed is zero.
628                         while (packed == 0) {
629                             packed = _packedOwnerships[--curr];
630                         }
631                         return packed;
632                     }
633                 }
634         }
635         revert OwnerQueryForNonexistentToken();
636     }
637 
638     /**
639      * Returns the unpacked `TokenOwnership` struct from `packed`.
640      */
641     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
642         ownership.addr = address(uint160(packed));
643         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
644         ownership.burned = packed & BITMASK_BURNED != 0;
645     }
646 
647     /**
648      * Returns the unpacked `TokenOwnership` struct at `index`.
649      */
650     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
651         return _unpackedOwnership(_packedOwnerships[index]);
652     }
653 
654     /**
655      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
656      */
657     function _initializeOwnershipAt(uint256 index) internal {
658         if (_packedOwnerships[index] == 0) {
659             _packedOwnerships[index] = _packedOwnershipOf(index);
660         }
661     }
662 
663     /**
664      * Gas spent here starts off proportional to the maximum mint batch size.
665      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
666      */
667     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
668         return _unpackedOwnership(_packedOwnershipOf(tokenId));
669     }
670 
671     /**
672      * @dev See {IERC721-ownerOf}.
673      */
674     function ownerOf(uint256 tokenId) public view override returns (address) {
675         return address(uint160(_packedOwnershipOf(tokenId)));
676     }
677 
678     /**
679      * @dev See {IERC721Metadata-name}.
680      */
681     function name() public view virtual override returns (string memory) {
682         return _name;
683     }
684 
685     /**
686      * @dev See {IERC721Metadata-symbol}.
687      */
688     function symbol() public view virtual override returns (string memory) {
689         return _symbol;
690     }
691 
692     /**
693      * @dev See {IERC721Metadata-tokenURI}.
694      */
695     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
696         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
697 
698         string memory baseURI = _baseURI();
699         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
700     }
701 
702     /**
703      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
704      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
705      * by default, can be overriden in child contracts.
706      */
707     function _baseURI() internal view virtual returns (string memory) {
708         return '';
709     }
710 
711     /**
712      * @dev Casts the address to uint256 without masking.
713      */
714     function _addressToUint256(address value) private pure returns (uint256 result) {
715         assembly {
716             result := value
717         }
718     }
719 
720     /**
721      * @dev Casts the boolean to uint256 without branching.
722      */
723     function _boolToUint256(bool value) private pure returns (uint256 result) {
724         assembly {
725             result := value
726         }
727     }
728 
729     /**
730      * @dev See {IERC721-approve}.
731      */
732     function approve(address to, uint256 tokenId) public override {
733         address owner = address(uint160(_packedOwnershipOf(tokenId)));
734         if (to == owner) revert ApprovalToCurrentOwner();
735 
736         if (_msgSenderERC721A() != owner)
737             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
738                 revert ApprovalCallerNotOwnerNorApproved();
739             }
740 
741         _tokenApprovals[tokenId] = to;
742         emit Approval(owner, to, tokenId);
743     }
744 
745     /**
746      * @dev See {IERC721-getApproved}.
747      */
748     function getApproved(uint256 tokenId) public view override returns (address) {
749         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
750 
751         return _tokenApprovals[tokenId];
752     }
753 
754     /**
755      * @dev See {IERC721-setApprovalForAll}.
756      */
757     function setApprovalForAll(address operator, bool approved) public virtual override {
758         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
759 
760         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
761         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
762     }
763 
764     /**
765      * @dev See {IERC721-isApprovedForAll}.
766      */
767     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
768         return _operatorApprovals[owner][operator];
769     }
770 
771     /**
772      * @dev See {IERC721-transferFrom}.
773      */
774     function transferFrom(
775         address from,
776         address to,
777         uint256 tokenId
778     ) public virtual override {
779         _transfer(from, to, tokenId);
780     }
781 
782     /**
783      * @dev See {IERC721-safeTransferFrom}.
784      */
785     function safeTransferFrom(
786         address from,
787         address to,
788         uint256 tokenId
789     ) public virtual override {
790         safeTransferFrom(from, to, tokenId, '');
791     }
792 
793     /**
794      * @dev See {IERC721-safeTransferFrom}.
795      */
796     function safeTransferFrom(
797         address from,
798         address to,
799         uint256 tokenId,
800         bytes memory _data
801     ) public virtual override {
802         _transfer(from, to, tokenId);
803         if (to.code.length != 0)
804             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
805                 revert TransferToNonERC721ReceiverImplementer();
806             }
807     }
808 
809     /**
810      * @dev Returns whether `tokenId` exists.
811      *
812      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
813      *
814      * Tokens start existing when they are minted (`_mint`),
815      */
816     function _exists(uint256 tokenId) internal view returns (bool) {
817         return
818             _startTokenId() <= tokenId &&
819             tokenId < _currentIndex && // If within bounds,
820             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
821     }
822 
823     /**
824      * @dev Equivalent to `_safeMint(to, quantity, '')`.
825      */
826     function _safeMint(address to, uint256 quantity) internal {
827         _safeMint(to, quantity, '');
828     }
829 
830     /**
831      * @dev Safely mints `quantity` tokens and transfers them to `to`.
832      *
833      * Requirements:
834      *
835      * - If `to` refers to a smart contract, it must implement
836      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
837      * - `quantity` must be greater than 0.
838      *
839      * Emits a {Transfer} event.
840      */
841     function _safeMint(
842         address to,
843         uint256 quantity,
844         bytes memory _data
845     ) internal {
846         uint256 startTokenId = _currentIndex;
847         if (to == address(0)) revert MintToZeroAddress();
848         if (quantity == 0) revert MintZeroQuantity();
849 
850         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
851 
852         // Overflows are incredibly unrealistic.
853         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
854         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
855         unchecked {
856             // Updates:
857             // - `balance += quantity`.
858             // - `numberMinted += quantity`.
859             //
860             // We can directly add to the balance and number minted.
861             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
862 
863             // Updates:
864             // - `address` to the owner.
865             // - `startTimestamp` to the timestamp of minting.
866             // - `burned` to `false`.
867             // - `nextInitialized` to `quantity == 1`.
868             _packedOwnerships[startTokenId] =
869                 _addressToUint256(to) |
870                 (block.timestamp << BITPOS_START_TIMESTAMP) |
871                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
872 
873             uint256 updatedIndex = startTokenId;
874             uint256 end = updatedIndex + quantity;
875 
876             if (to.code.length != 0) {
877                 do {
878                     emit Transfer(address(0), to, updatedIndex);
879                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
880                         revert TransferToNonERC721ReceiverImplementer();
881                     }
882                 } while (updatedIndex < end);
883                 // Reentrancy protection
884                 if (_currentIndex != startTokenId) revert();
885             } else {
886                 do {
887                     emit Transfer(address(0), to, updatedIndex++);
888                 } while (updatedIndex < end);
889             }
890             _currentIndex = updatedIndex;
891         }
892         _afterTokenTransfers(address(0), to, startTokenId, quantity);
893     }
894 
895     /**
896      * @dev Mints `quantity` tokens and transfers them to `to`.
897      *
898      * Requirements:
899      *
900      * - `to` cannot be the zero address.
901      * - `quantity` must be greater than 0.
902      *
903      * Emits a {Transfer} event.
904      */
905     function _mint(address to, uint256 quantity) internal {
906         uint256 startTokenId = _currentIndex;
907         if (to == address(0)) revert MintToZeroAddress();
908         if (quantity == 0) revert MintZeroQuantity();
909 
910         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
911 
912         // Overflows are incredibly unrealistic.
913         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
914         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
915         unchecked {
916             // Updates:
917             // - `balance += quantity`.
918             // - `numberMinted += quantity`.
919             //
920             // We can directly add to the balance and number minted.
921             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
922 
923             // Updates:
924             // - `address` to the owner.
925             // - `startTimestamp` to the timestamp of minting.
926             // - `burned` to `false`.
927             // - `nextInitialized` to `quantity == 1`.
928             _packedOwnerships[startTokenId] =
929                 _addressToUint256(to) |
930                 (block.timestamp << BITPOS_START_TIMESTAMP) |
931                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
932 
933             uint256 updatedIndex = startTokenId;
934             uint256 end = updatedIndex + quantity;
935 
936             do {
937                 emit Transfer(address(0), to, updatedIndex++);
938             } while (updatedIndex < end);
939 
940             _currentIndex = updatedIndex;
941         }
942         _afterTokenTransfers(address(0), to, startTokenId, quantity);
943     }
944 
945     /**
946      * @dev Transfers `tokenId` from `from` to `to`.
947      *
948      * Requirements:
949      *
950      * - `to` cannot be the zero address.
951      * - `tokenId` token must be owned by `from`.
952      *
953      * Emits a {Transfer} event.
954      */
955     function _transfer(
956         address from,
957         address to,
958         uint256 tokenId
959     ) private {
960         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
961 
962         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
963 
964         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
965             isApprovedForAll(from, _msgSenderERC721A()) ||
966             getApproved(tokenId) == _msgSenderERC721A());
967 
968         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
969         if (to == address(0)) revert TransferToZeroAddress();
970 
971         _beforeTokenTransfers(from, to, tokenId, 1);
972 
973         // Clear approvals from the previous owner.
974         delete _tokenApprovals[tokenId];
975 
976         // Underflow of the sender's balance is impossible because we check for
977         // ownership above and the recipient's balance can't realistically overflow.
978         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
979         unchecked {
980             // We can directly increment and decrement the balances.
981             --_packedAddressData[from]; // Updates: `balance -= 1`.
982             ++_packedAddressData[to]; // Updates: `balance += 1`.
983 
984             // Updates:
985             // - `address` to the next owner.
986             // - `startTimestamp` to the timestamp of transfering.
987             // - `burned` to `false`.
988             // - `nextInitialized` to `true`.
989             _packedOwnerships[tokenId] =
990                 _addressToUint256(to) |
991                 (block.timestamp << BITPOS_START_TIMESTAMP) |
992                 BITMASK_NEXT_INITIALIZED;
993 
994             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
995             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
996                 uint256 nextTokenId = tokenId + 1;
997                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
998                 if (_packedOwnerships[nextTokenId] == 0) {
999                     // If the next slot is within bounds.
1000                     if (nextTokenId != _currentIndex) {
1001                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1002                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1003                     }
1004                 }
1005             }
1006         }
1007 
1008         emit Transfer(from, to, tokenId);
1009         _afterTokenTransfers(from, to, tokenId, 1);
1010     }
1011 
1012     /**
1013      * @dev Equivalent to `_burn(tokenId, false)`.
1014      */
1015     function _burn(uint256 tokenId) internal virtual {
1016         _burn(tokenId, false);
1017     }
1018 
1019     /**
1020      * @dev Destroys `tokenId`.
1021      * The approval is cleared when the token is burned.
1022      *
1023      * Requirements:
1024      *
1025      * - `tokenId` must exist.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1030         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1031 
1032         address from = address(uint160(prevOwnershipPacked));
1033 
1034         if (approvalCheck) {
1035             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1036                 isApprovedForAll(from, _msgSenderERC721A()) ||
1037                 getApproved(tokenId) == _msgSenderERC721A());
1038 
1039             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1040         }
1041 
1042         _beforeTokenTransfers(from, address(0), tokenId, 1);
1043 
1044         // Clear approvals from the previous owner.
1045         delete _tokenApprovals[tokenId];
1046 
1047         // Underflow of the sender's balance is impossible because we check for
1048         // ownership above and the recipient's balance can't realistically overflow.
1049         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1050         unchecked {
1051             // Updates:
1052             // - `balance -= 1`.
1053             // - `numberBurned += 1`.
1054             //
1055             // We can directly decrement the balance, and increment the number burned.
1056             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1057             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1058 
1059             // Updates:
1060             // - `address` to the last owner.
1061             // - `startTimestamp` to the timestamp of burning.
1062             // - `burned` to `true`.
1063             // - `nextInitialized` to `true`.
1064             _packedOwnerships[tokenId] =
1065                 _addressToUint256(from) |
1066                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1067                 BITMASK_BURNED | 
1068                 BITMASK_NEXT_INITIALIZED;
1069 
1070             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1071             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1072                 uint256 nextTokenId = tokenId + 1;
1073                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1074                 if (_packedOwnerships[nextTokenId] == 0) {
1075                     // If the next slot is within bounds.
1076                     if (nextTokenId != _currentIndex) {
1077                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1078                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1079                     }
1080                 }
1081             }
1082         }
1083 
1084         emit Transfer(from, address(0), tokenId);
1085         _afterTokenTransfers(from, address(0), tokenId, 1);
1086 
1087         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1088         unchecked {
1089             _burnCounter++;
1090         }
1091     }
1092 
1093     /**
1094      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1095      *
1096      * @param from address representing the previous owner of the given token ID
1097      * @param to target address that will receive the tokens
1098      * @param tokenId uint256 ID of the token to be transferred
1099      * @param _data bytes optional data to send along with the call
1100      * @return bool whether the call correctly returned the expected magic value
1101      */
1102     function _checkContractOnERC721Received(
1103         address from,
1104         address to,
1105         uint256 tokenId,
1106         bytes memory _data
1107     ) private returns (bool) {
1108         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1109             bytes4 retval
1110         ) {
1111             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1112         } catch (bytes memory reason) {
1113             if (reason.length == 0) {
1114                 revert TransferToNonERC721ReceiverImplementer();
1115             } else {
1116                 assembly {
1117                     revert(add(32, reason), mload(reason))
1118                 }
1119             }
1120         }
1121     }
1122 
1123     /**
1124      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1125      * And also called before burning one token.
1126      *
1127      * startTokenId - the first token id to be transferred
1128      * quantity - the amount to be transferred
1129      *
1130      * Calling conditions:
1131      *
1132      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1133      * transferred to `to`.
1134      * - When `from` is zero, `tokenId` will be minted for `to`.
1135      * - When `to` is zero, `tokenId` will be burned by `from`.
1136      * - `from` and `to` are never both zero.
1137      */
1138     function _beforeTokenTransfers(
1139         address from,
1140         address to,
1141         uint256 startTokenId,
1142         uint256 quantity
1143     ) internal virtual {}
1144 
1145     /**
1146      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1147      * minting.
1148      * And also called after one token has been burned.
1149      *
1150      * startTokenId - the first token id to be transferred
1151      * quantity - the amount to be transferred
1152      *
1153      * Calling conditions:
1154      *
1155      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1156      * transferred to `to`.
1157      * - When `from` is zero, `tokenId` has been minted for `to`.
1158      * - When `to` is zero, `tokenId` has been burned by `from`.
1159      * - `from` and `to` are never both zero.
1160      */
1161     function _afterTokenTransfers(
1162         address from,
1163         address to,
1164         uint256 startTokenId,
1165         uint256 quantity
1166     ) internal virtual {}
1167 
1168     /**
1169      * @dev Returns the message sender (defaults to `msg.sender`).
1170      *
1171      * If you are writing GSN compatible contracts, you need to override this function.
1172      */
1173     function _msgSenderERC721A() internal view virtual returns (address) {
1174         return msg.sender;
1175     }
1176 
1177     /**
1178      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1179      */
1180     function _toString(uint256 value) internal pure returns (string memory ptr) {
1181         assembly {
1182             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1183             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1184             // We will need 1 32-byte word to store the length, 
1185             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1186             ptr := add(mload(0x40), 128)
1187             // Update the free memory pointer to allocate.
1188             mstore(0x40, ptr)
1189 
1190             // Cache the end of the memory to calculate the length later.
1191             let end := ptr
1192 
1193             // We write the string from the rightmost digit to the leftmost digit.
1194             // The following is essentially a do-while loop that also handles the zero case.
1195             // Costs a bit more than early returning for the zero case,
1196             // but cheaper in terms of deployment and overall runtime costs.
1197             for { 
1198                 // Initialize and perform the first pass without check.
1199                 let temp := value
1200                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1201                 ptr := sub(ptr, 1)
1202                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1203                 mstore8(ptr, add(48, mod(temp, 10)))
1204                 temp := div(temp, 10)
1205             } temp { 
1206                 // Keep dividing `temp` until zero.
1207                 temp := div(temp, 10)
1208             } { // Body of the for loop.
1209                 ptr := sub(ptr, 1)
1210                 mstore8(ptr, add(48, mod(temp, 10)))
1211             }
1212             
1213             let length := sub(end, ptr)
1214             // Move the pointer 32 bytes leftwards to make room for the length.
1215             ptr := sub(ptr, 32)
1216             // Store the length.
1217             mstore(ptr, length)
1218         }
1219     }
1220 }
1221 
1222 contract FudPanda is ERC721A, Ownable {
1223 
1224     using Strings for uint256;
1225     string baseURI;
1226     uint256 maxSupply = 8964;
1227     uint8 public maxMintAmount = 20;
1228     bool public paused = true;
1229 
1230     constructor(
1231         string memory _name,
1232         string memory _symbol,
1233         string memory _initBaseURI
1234     ) ERC721A(_name, _symbol) {
1235         setBaseURI(_initBaseURI);
1236         _safeMint(msg.sender, 100);
1237     }
1238 
1239     function mint(uint256 _amount) external {
1240         require(!paused, "the contract is paused");
1241         require(_amount > 0, "need to mint at least 1 NFT");
1242         require(_amount <= maxMintAmount, "max mint amount per session exceeded");
1243         require(totalSupply() + _amount <= maxSupply, "max NFT limit exceeded");
1244         _safeMint(msg.sender, _amount);
1245     }
1246 
1247     function _baseURI() internal view virtual override returns (string memory) {
1248         return baseURI;
1249     }
1250 
1251     function tokenURI(uint256 tokenId) public view virtual override
1252     returns (string memory){
1253         require(_exists(tokenId),
1254             "ERC721Metadata: URI query for nonexistent token"
1255         );
1256 
1257         string memory currentBaseURI = _baseURI();
1258         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json")) : "";
1259     }
1260 
1261     function pause() public onlyOwner {
1262         paused = !paused;
1263     }
1264 
1265     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1266         baseURI = _newBaseURI;
1267     }
1268     
1269     function setmaxMintAmount(uint8 _newmaxMintAmount) public onlyOwner() {
1270         maxMintAmount = _newmaxMintAmount;
1271     }
1272 
1273     function withdraw() public payable onlyOwner {
1274         require(payable(msg.sender).send(address(this).balance));
1275     }
1276     
1277 }