1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 //  ____ _______  __ 
5 // |  _ \__  /  \/  |
6 // | | | |/ /| |\/| |
7 // | |_| / /_| |  | |
8 // |____/____|_|  |_|
9 //                
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         return msg.data;
18     }
19 }
20 
21 abstract contract Ownable is Context {
22     address private _owner;
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26     /**
27      * @dev Initializes the contract setting the deployer as the initial owner.
28      */
29     constructor() {
30         _transferOwnership(_msgSender());
31     }
32 
33     /**
34      * @dev Returns the address of the current owner.
35      */
36     function owner() public view virtual returns (address) {
37         return _owner;
38     }
39 
40     /**
41      * @dev Throws if called by any account other than the owner.
42      */
43     modifier onlyOwner() {
44         require(owner() == _msgSender(), "Ownable: caller is not the owner");
45         _;
46     }
47 
48     /**
49      * @dev Leaves the contract without owner. It will not be possible to call
50      * `onlyOwner` functions anymore. Can only be called by the current owner.
51      *
52      * NOTE: Renouncing ownership will leave the contract without an owner,
53      * thereby removing any functionality that is only available to the owner.
54      */
55     function renounceOwnership() public virtual onlyOwner {
56         _transferOwnership(address(0));
57     }
58 
59     /**
60      * @dev Transfers ownership of the contract to a new account (`newOwner`).
61      * Can only be called by the current owner.
62      */
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         _transferOwnership(newOwner);
66     }
67 
68     /**
69      * @dev Transfers ownership of the contract to a new account (`newOwner`).
70      * Internal function without access restriction.
71      */
72     function _transferOwnership(address newOwner) internal virtual {
73         address oldOwner = _owner;
74         _owner = newOwner;
75         emit OwnershipTransferred(oldOwner, newOwner);
76     }
77 }    
78 
79 library Strings {
80     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
84      */
85     function toString(uint256 value) internal pure returns (string memory) {
86         // Inspired by OraclizeAPI's implementation - MIT licence
87         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
88 
89         if (value == 0) {
90             return "0";
91         }
92         uint256 temp = value;
93         uint256 digits;
94         while (temp != 0) {
95             digits++;
96             temp /= 10;
97         }
98         bytes memory buffer = new bytes(digits);
99         while (value != 0) {
100             digits -= 1;
101             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
102             value /= 10;
103         }
104         return string(buffer);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
109      */
110     function toHexString(uint256 value) internal pure returns (string memory) {
111         if (value == 0) {
112             return "0x00";
113         }
114         uint256 temp = value;
115         uint256 length = 0;
116         while (temp != 0) {
117             length++;
118             temp >>= 8;
119         }
120         return toHexString(value, length);
121     }
122 
123     /**
124      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
125      */
126     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
127         bytes memory buffer = new bytes(2 * length + 2);
128         buffer[0] = "0";
129         buffer[1] = "x";
130         for (uint256 i = 2 * length + 1; i > 1; --i) {
131             buffer[i] = _HEX_SYMBOLS[value & 0xf];
132             value >>= 4;
133         }
134         require(value == 0, "Strings: hex length insufficient");
135         return string(buffer);
136     }
137 }
138 
139 
140 /**
141  * @dev Interface of an ERC721A compliant contract.
142  */
143 interface IERC721A {
144     /**
145      * The caller must own the token or be an approved operator.
146      */
147     error ApprovalCallerNotOwnerNorApproved();
148 
149     /**
150      * The token does not exist.
151      */
152     error ApprovalQueryForNonexistentToken();
153 
154     /**
155      * The caller cannot approve to their own address.
156      */
157     error ApproveToCaller();
158 
159     /**
160      * Cannot query the balance for the zero address.
161      */
162     error BalanceQueryForZeroAddress();
163 
164     /**
165      * Cannot mint to the zero address.
166      */
167     error MintToZeroAddress();
168 
169     /**
170      * The quantity of tokens minted must be more than zero.
171      */
172     error MintZeroQuantity();
173 
174     /**
175      * The token does not exist.
176      */
177     error OwnerQueryForNonexistentToken();
178 
179     /**
180      * The caller must own the token or be an approved operator.
181      */
182     error TransferCallerNotOwnerNorApproved();
183 
184     /**
185      * The token must be owned by `from`.
186      */
187     error TransferFromIncorrectOwner();
188 
189     /**
190      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
191      */
192     error TransferToNonERC721ReceiverImplementer();
193 
194     /**
195      * Cannot transfer to the zero address.
196      */
197     error TransferToZeroAddress();
198 
199     /**
200      * The token does not exist.
201      */
202     error URIQueryForNonexistentToken();
203 
204     struct TokenOwnership {
205         // The address of the owner.
206         address addr;
207         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
208         uint64 startTimestamp;
209         // Whether the token has been burned.
210         bool burned;
211     }
212 
213     /**
214      * @dev Returns the total amount of tokens stored by the contract.
215      *
216      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
217      */
218     function totalSupply() external view returns (uint256);
219 
220     // ==============================
221     //            IERC165
222     // ==============================
223 
224     /**
225      * @dev Returns true if this contract implements the interface defined by
226      * `interfaceId`. See the corresponding
227      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
228      * to learn more about how these ids are created.
229      *
230      * This function call must use less than 30 000 gas.
231      */
232     function supportsInterface(bytes4 interfaceId) external view returns (bool);
233 
234     // ==============================
235     //            IERC721
236     // ==============================
237 
238     /**
239      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
240      */
241     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
242 
243     /**
244      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
245      */
246     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
247 
248     /**
249      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
250      */
251     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
252 
253     /**
254      * @dev Returns the number of tokens in ``owner``'s account.
255      */
256     function balanceOf(address owner) external view returns (uint256 balance);
257 
258     /**
259      * @dev Returns the owner of the `tokenId` token.
260      *
261      * Requirements:
262      *
263      * - `tokenId` must exist.
264      */
265     function ownerOf(uint256 tokenId) external view returns (address owner);
266 
267     /**
268      * @dev Safely transfers `tokenId` token from `from` to `to`.
269      *
270      * Requirements:
271      *
272      * - `from` cannot be the zero address.
273      * - `to` cannot be the zero address.
274      * - `tokenId` token must exist and be owned by `from`.
275      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
276      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
277      *
278      * Emits a {Transfer} event.
279      */
280     function safeTransferFrom(
281         address from,
282         address to,
283         uint256 tokenId,
284         bytes calldata data
285     ) external;
286 
287     /**
288      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
289      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
290      *
291      * Requirements:
292      *
293      * - `from` cannot be the zero address.
294      * - `to` cannot be the zero address.
295      * - `tokenId` token must exist and be owned by `from`.
296      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
297      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
298      *
299      * Emits a {Transfer} event.
300      */
301     function safeTransferFrom(
302         address from,
303         address to,
304         uint256 tokenId
305     ) external;
306 
307     /**
308      * @dev Transfers `tokenId` token from `from` to `to`.
309      *
310      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
311      *
312      * Requirements:
313      *
314      * - `from` cannot be the zero address.
315      * - `to` cannot be the zero address.
316      * - `tokenId` token must be owned by `from`.
317      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
318      *
319      * Emits a {Transfer} event.
320      */
321     function transferFrom(
322         address from,
323         address to,
324         uint256 tokenId
325     ) external;
326 
327     /**
328      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
329      * The approval is cleared when the token is transferred.
330      *
331      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
332      *
333      * Requirements:
334      *
335      * - The caller must own the token or be an approved operator.
336      * - `tokenId` must exist.
337      *
338      * Emits an {Approval} event.
339      */
340     function approve(address to, uint256 tokenId) external;
341 
342     /**
343      * @dev Approve or remove `operator` as an operator for the caller.
344      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
345      *
346      * Requirements:
347      *
348      * - The `operator` cannot be the caller.
349      *
350      * Emits an {ApprovalForAll} event.
351      */
352     function setApprovalForAll(address operator, bool _approved) external;
353 
354     /**
355      * @dev Returns the account approved for `tokenId` token.
356      *
357      * Requirements:
358      *
359      * - `tokenId` must exist.
360      */
361     function getApproved(uint256 tokenId) external view returns (address operator);
362 
363     /**
364      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
365      *
366      * See {setApprovalForAll}
367      */
368     function isApprovedForAll(address owner, address operator) external view returns (bool);
369 
370     // ==============================
371     //        IERC721Metadata
372     // ==============================
373 
374     /**
375      * @dev Returns the token collection name.
376      */
377     function name() external view returns (string memory);
378 
379     /**
380      * @dev Returns the token collection symbol.
381      */
382     function symbol() external view returns (string memory);
383 
384     /**
385      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
386      */
387     function tokenURI(uint256 tokenId) external view returns (string memory);
388 }
389 
390 /**
391  * @dev ERC721 token receiver interface.
392  */
393 interface ERC721A__IERC721Receiver {
394     function onERC721Received(
395         address operator,
396         address from,
397         uint256 tokenId,
398         bytes calldata data
399     ) external returns (bytes4);
400 }
401 
402 /**
403  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
404  * the Metadata extension. Built to optimize for lower gas during batch mints.
405  *
406  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
407  *
408  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
409  *
410  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
411  */
412 contract ERC721A is IERC721A {
413     // Mask of an entry in packed address data.
414     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
415 
416     // The bit position of `numberMinted` in packed address data.
417     uint256 private constant BITPOS_NUMBER_MINTED = 64;
418 
419     // The bit position of `numberBurned` in packed address data.
420     uint256 private constant BITPOS_NUMBER_BURNED = 128;
421 
422     // The bit position of `aux` in packed address data.
423     uint256 private constant BITPOS_AUX = 192;
424 
425     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
426     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
427 
428     // The bit position of `startTimestamp` in packed ownership.
429     uint256 private constant BITPOS_START_TIMESTAMP = 160;
430 
431     // The bit mask of the `burned` bit in packed ownership.
432     uint256 private constant BITMASK_BURNED = 1 << 224;
433 
434     // The bit position of the `nextInitialized` bit in packed ownership.
435     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
436 
437     // The bit mask of the `nextInitialized` bit in packed ownership.
438     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
439 
440     // The tokenId of the next token to be minted.
441     uint256 private _currentIndex;
442 
443     // The number of tokens burned.
444     uint256 private _burnCounter;
445 
446     // Token name
447     string private _name;
448 
449     // Token symbol
450     string private _symbol;
451 
452     // Mapping from token ID to ownership details
453     // An empty struct value does not necessarily mean the token is unowned.
454     // See `_packedOwnershipOf` implementation for details.
455     //
456     // Bits Layout:
457     // - [0..159]   `addr`
458     // - [160..223] `startTimestamp`
459     // - [224]      `burned`
460     // - [225]      `nextInitialized`
461     mapping(uint256 => uint256) private _packedOwnerships;
462 
463     // Mapping owner address to address data.
464     //
465     // Bits Layout:
466     // - [0..63]    `balance`
467     // - [64..127]  `numberMinted`
468     // - [128..191] `numberBurned`
469     // - [192..255] `aux`
470     mapping(address => uint256) private _packedAddressData;
471 
472     // Mapping from token ID to approved address.
473     mapping(uint256 => address) private _tokenApprovals;
474 
475     // Mapping from owner to operator approvals
476     mapping(address => mapping(address => bool)) private _operatorApprovals;
477 
478     constructor(string memory name_, string memory symbol_) {
479         _name = name_;
480         _symbol = symbol_;
481         _currentIndex = _startTokenId();
482     }
483 
484     /**
485      * @dev Returns the starting token ID.
486      * To change the starting token ID, please override this function.
487      */
488     function _startTokenId() internal view virtual returns (uint256) {
489         return 1;
490     }
491 
492     /**
493      * @dev Returns the next token ID to be minted.
494      */
495     function _nextTokenId() internal view returns (uint256) {
496         return _currentIndex;
497     }
498 
499     /**
500      * @dev Returns the total number of tokens in existence.
501      * Burned tokens will reduce the count.
502      * To get the total number of tokens minted, please see `_totalMinted`.
503      */
504     function totalSupply() public view override returns (uint256) {
505         // Counter underflow is impossible as _burnCounter cannot be incremented
506         // more than `_currentIndex - _startTokenId()` times.
507         unchecked {
508             return _currentIndex - _burnCounter - _startTokenId();
509         }
510     }
511 
512     /**
513      * @dev Returns the total amount of tokens minted in the contract.
514      */
515     function _totalMinted() internal view returns (uint256) {
516         // Counter underflow is impossible as _currentIndex does not decrement,
517         // and it is initialized to `_startTokenId()`
518         unchecked {
519             return _currentIndex - _startTokenId();
520         }
521     }
522 
523     /**
524      * @dev Returns the total number of tokens burned.
525      */
526     function _totalBurned() internal view returns (uint256) {
527         return _burnCounter;
528     }
529 
530     /**
531      * @dev See {IERC165-supportsInterface}.
532      */
533     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
534         // The interface IDs are constants representing the first 4 bytes of the XOR of
535         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
536         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
537         return
538             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
539             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
540             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
541     }
542 
543     /**
544      * @dev See {IERC721-balanceOf}.
545      */
546     function balanceOf(address owner) public view override returns (uint256) {
547         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
548         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
549     }
550 
551     /**
552      * Returns the number of tokens minted by `owner`.
553      */
554     function _numberMinted(address owner) internal view returns (uint256) {
555         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
556     }
557 
558     /**
559      * Returns the number of tokens burned by or on behalf of `owner`.
560      */
561     function _numberBurned(address owner) internal view returns (uint256) {
562         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
563     }
564 
565     /**
566      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
567      */
568     function _getAux(address owner) internal view returns (uint64) {
569         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
570     }
571 
572     /**
573      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
574      * If there are multiple variables, please pack them into a uint64.
575      */
576     function _setAux(address owner, uint64 aux) internal {
577         uint256 packed = _packedAddressData[owner];
578         uint256 auxCasted;
579         assembly {
580             // Cast aux without masking.
581             auxCasted := aux
582         }
583         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
584         _packedAddressData[owner] = packed;
585     }
586 
587     /**
588      * Returns the packed ownership data of `tokenId`.
589      */
590     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
591         uint256 curr = tokenId;
592 
593         unchecked {
594             if (_startTokenId() <= curr)
595                 if (curr < _currentIndex) {
596                     uint256 packed = _packedOwnerships[curr];
597                     // If not burned.
598                     if (packed & BITMASK_BURNED == 0) {
599                         // Invariant:
600                         // There will always be an ownership that has an address and is not burned
601                         // before an ownership that does not have an address and is not burned.
602                         // Hence, curr will not underflow.
603                         //
604                         // We can directly compare the packed value.
605                         // If the address is zero, packed is zero.
606                         while (packed == 0) {
607                             packed = _packedOwnerships[--curr];
608                         }
609                         return packed;
610                     }
611                 }
612         }
613         revert OwnerQueryForNonexistentToken();
614     }
615 
616     /**
617      * Returns the unpacked `TokenOwnership` struct from `packed`.
618      */
619     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
620         ownership.addr = address(uint160(packed));
621         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
622         ownership.burned = packed & BITMASK_BURNED != 0;
623     }
624 
625     /**
626      * Returns the unpacked `TokenOwnership` struct at `index`.
627      */
628     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
629         return _unpackedOwnership(_packedOwnerships[index]);
630     }
631 
632     /**
633      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
634      */
635     function _initializeOwnershipAt(uint256 index) internal {
636         if (_packedOwnerships[index] == 0) {
637             _packedOwnerships[index] = _packedOwnershipOf(index);
638         }
639     }
640 
641     /**
642      * Gas spent here starts off proportional to the maximum mint batch size.
643      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
644      */
645     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
646         return _unpackedOwnership(_packedOwnershipOf(tokenId));
647     }
648 
649     /**
650      * @dev See {IERC721-ownerOf}.
651      */
652     function ownerOf(uint256 tokenId) public view override returns (address) {
653         return address(uint160(_packedOwnershipOf(tokenId)));
654     }
655 
656     /**
657      * @dev See {IERC721Metadata-name}.
658      */
659     function name() public view virtual override returns (string memory) {
660         return _name;
661     }
662 
663     /**
664      * @dev See {IERC721Metadata-symbol}.
665      */
666     function symbol() public view virtual override returns (string memory) {
667         return _symbol;
668     }
669 
670     /**
671      * @dev See {IERC721Metadata-tokenURI}.
672      */
673     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
674         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
675 
676         string memory baseURI = _baseURI();
677         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
678     }
679 
680     /**
681      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
682      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
683      * by default, can be overriden in child contracts.
684      */
685     function _baseURI() internal view virtual returns (string memory) {
686         return '';
687     }
688 
689     /**
690      * @dev Casts the address to uint256 without masking.
691      */
692     function _addressToUint256(address value) private pure returns (uint256 result) {
693         assembly {
694             result := value
695         }
696     }
697 
698     /**
699      * @dev Casts the boolean to uint256 without branching.
700      */
701     function _boolToUint256(bool value) private pure returns (uint256 result) {
702         assembly {
703             result := value
704         }
705     }
706 
707     /**
708      * @dev See {IERC721-approve}.
709      */
710     function approve(address to, uint256 tokenId) public override {
711         address owner = address(uint160(_packedOwnershipOf(tokenId)));
712 
713         if (_msgSenderERC721A() != owner)
714             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
715                 revert ApprovalCallerNotOwnerNorApproved();
716             }
717 
718         _tokenApprovals[tokenId] = to;
719         emit Approval(owner, to, tokenId);
720     }
721 
722     /**
723      * @dev See {IERC721-getApproved}.
724      */
725     function getApproved(uint256 tokenId) public view override returns (address) {
726         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
727 
728         return _tokenApprovals[tokenId];
729     }
730 
731     /**
732      * @dev See {IERC721-setApprovalForAll}.
733      */
734     function setApprovalForAll(address operator, bool approved) public virtual override {
735         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
736 
737         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
738         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
739     }
740 
741     /**
742      * @dev See {IERC721-isApprovedForAll}.
743      */
744     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
745         return _operatorApprovals[owner][operator];
746     }
747 
748     /**
749      * @dev See {IERC721-transferFrom}.
750      */
751     function transferFrom(
752         address from,
753         address to,
754         uint256 tokenId
755     ) public virtual override {
756         _transfer(from, to, tokenId);
757     }
758 
759     /**
760      * @dev See {IERC721-safeTransferFrom}.
761      */
762     function safeTransferFrom(
763         address from,
764         address to,
765         uint256 tokenId
766     ) public virtual override {
767         safeTransferFrom(from, to, tokenId, '');
768     }
769 
770     /**
771      * @dev See {IERC721-safeTransferFrom}.
772      */
773     function safeTransferFrom(
774         address from,
775         address to,
776         uint256 tokenId,
777         bytes memory _data
778     ) public virtual override {
779         _transfer(from, to, tokenId);
780         if (to.code.length != 0)
781             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
782                 revert TransferToNonERC721ReceiverImplementer();
783             }
784     }
785 
786     /**
787      * @dev Returns whether `tokenId` exists.
788      *
789      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
790      *
791      * Tokens start existing when they are minted (`_mint`),
792      */
793     function _exists(uint256 tokenId) internal view returns (bool) {
794         return
795             _startTokenId() <= tokenId &&
796             tokenId < _currentIndex && // If within bounds,
797             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
798     }
799 
800     /**
801      * @dev Equivalent to `_safeMint(to, quantity, '')`.
802      */
803     function _safeMint(address to, uint256 quantity) internal {
804         _safeMint(to, quantity, '');
805     }
806 
807     /**
808      * @dev Safely mints `quantity` tokens and transfers them to `to`.
809      *
810      * Requirements:
811      *
812      * - If `to` refers to a smart contract, it must implement
813      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
814      * - `quantity` must be greater than 0.
815      *
816      * Emits a {Transfer} event for each mint.
817      */
818     function _safeMint(
819         address to,
820         uint256 quantity,
821         bytes memory _data
822     ) internal {
823         _mint(to, quantity);
824 
825         unchecked {
826             if (to.code.length != 0) {
827                 uint256 end = _currentIndex;
828                 uint256 index = end - quantity;
829                 do {
830                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
831                         revert TransferToNonERC721ReceiverImplementer();
832                     }
833                 } while (index < end);
834                 // Reentrancy protection.
835                 if (_currentIndex != end) revert();
836             }
837         }
838     }
839 
840     /**
841      * @dev Mints `quantity` tokens and transfers them to `to`.
842      *
843      * Requirements:
844      *
845      * - `to` cannot be the zero address.
846      * - `quantity` must be greater than 0.
847      *
848      * Emits a {Transfer} event for each mint.
849      */
850     function _mint(address to, uint256 quantity) internal {
851         uint256 startTokenId = _currentIndex;
852         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
853         if (quantity == 0) revert MintZeroQuantity();
854 
855         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
856 
857         // Overflows are incredibly unrealistic.
858         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
859         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
860         unchecked {
861             // Updates:
862             // - `balance += quantity`.
863             // - `numberMinted += quantity`.
864             //
865             // We can directly add to the balance and number minted.
866             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
867 
868             // Updates:
869             // - `address` to the owner.
870             // - `startTimestamp` to the timestamp of minting.
871             // - `burned` to `false`.
872             // - `nextInitialized` to `quantity == 1`.
873             _packedOwnerships[startTokenId] =
874                 _addressToUint256(to) |
875                 (block.timestamp << BITPOS_START_TIMESTAMP) |
876                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
877 
878             uint256 offset;
879             do {
880                 emit Transfer(address(0), to, startTokenId + offset++);
881             } while (offset < quantity);
882 
883             _currentIndex = startTokenId + quantity;
884         }
885         _afterTokenTransfers(address(0), to, startTokenId, quantity);
886     }
887 
888     /**
889      * @dev Transfers `tokenId` from `from` to `to`.
890      *
891      * Requirements:
892      *
893      * - `to` cannot be the zero address.
894      * - `tokenId` token must be owned by `from`.
895      *
896      * Emits a {Transfer} event.
897      */
898     function _transfer(
899         address from,
900         address to,
901         uint256 tokenId
902     ) private {
903         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
904 
905         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
906 
907         address approvedAddress = _tokenApprovals[tokenId];
908 
909         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
910             isApprovedForAll(from, _msgSenderERC721A()) ||
911             approvedAddress == _msgSenderERC721A());
912 
913         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
914         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
915 
916         _beforeTokenTransfers(from, to, tokenId, 1);
917 
918         // Clear approvals from the previous owner.
919         if (_addressToUint256(approvedAddress) != 0) {
920             delete _tokenApprovals[tokenId];
921         }
922 
923         // Underflow of the sender's balance is impossible because we check for
924         // ownership above and the recipient's balance can't realistically overflow.
925         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
926         unchecked {
927             // We can directly increment and decrement the balances.
928             --_packedAddressData[from]; // Updates: `balance -= 1`.
929             ++_packedAddressData[to]; // Updates: `balance += 1`.
930 
931             // Updates:
932             // - `address` to the next owner.
933             // - `startTimestamp` to the timestamp of transfering.
934             // - `burned` to `false`.
935             // - `nextInitialized` to `true`.
936             _packedOwnerships[tokenId] =
937                 _addressToUint256(to) |
938                 (block.timestamp << BITPOS_START_TIMESTAMP) |
939                 BITMASK_NEXT_INITIALIZED;
940 
941             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
942             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
943                 uint256 nextTokenId = tokenId + 1;
944                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
945                 if (_packedOwnerships[nextTokenId] == 0) {
946                     // If the next slot is within bounds.
947                     if (nextTokenId != _currentIndex) {
948                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
949                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
950                     }
951                 }
952             }
953         }
954 
955         emit Transfer(from, to, tokenId);
956         _afterTokenTransfers(from, to, tokenId, 1);
957     }
958 
959     /**
960      * @dev Equivalent to `_burn(tokenId, false)`.
961      */
962     function _burn(uint256 tokenId) internal virtual {
963         _burn(tokenId, false);
964     }
965 
966     /**
967      * @dev Destroys `tokenId`.
968      * The approval is cleared when the token is burned.
969      *
970      * Requirements:
971      *
972      * - `tokenId` must exist.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
977         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
978 
979         address from = address(uint160(prevOwnershipPacked));
980         address approvedAddress = _tokenApprovals[tokenId];
981 
982         if (approvalCheck) {
983             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
984                 isApprovedForAll(from, _msgSenderERC721A()) ||
985                 approvedAddress == _msgSenderERC721A());
986 
987             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
988         }
989 
990         _beforeTokenTransfers(from, address(0), tokenId, 1);
991 
992         // Clear approvals from the previous owner.
993         if (_addressToUint256(approvedAddress) != 0) {
994             delete _tokenApprovals[tokenId];
995         }
996 
997         // Underflow of the sender's balance is impossible because we check for
998         // ownership above and the recipient's balance can't realistically overflow.
999         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1000         unchecked {
1001             // Updates:
1002             // - `balance -= 1`.
1003             // - `numberBurned += 1`.
1004             //
1005             // We can directly decrement the balance, and increment the number burned.
1006             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1007             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1008 
1009             // Updates:
1010             // - `address` to the last owner.
1011             // - `startTimestamp` to the timestamp of burning.
1012             // - `burned` to `true`.
1013             // - `nextInitialized` to `true`.
1014             _packedOwnerships[tokenId] =
1015                 _addressToUint256(from) |
1016                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1017                 BITMASK_BURNED |
1018                 BITMASK_NEXT_INITIALIZED;
1019 
1020             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1021             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1022                 uint256 nextTokenId = tokenId + 1;
1023                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1024                 if (_packedOwnerships[nextTokenId] == 0) {
1025                     // If the next slot is within bounds.
1026                     if (nextTokenId != _currentIndex) {
1027                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1028                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1029                     }
1030                 }
1031             }
1032         }
1033 
1034         emit Transfer(from, address(0), tokenId);
1035         _afterTokenTransfers(from, address(0), tokenId, 1);
1036 
1037         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1038         unchecked {
1039             _burnCounter++;
1040         }
1041     }
1042 
1043     /**
1044      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1045      *
1046      * @param from address representing the previous owner of the given token ID
1047      * @param to target address that will receive the tokens
1048      * @param tokenId uint256 ID of the token to be transferred
1049      * @param _data bytes optional data to send along with the call
1050      * @return bool whether the call correctly returned the expected magic value
1051      */
1052     function _checkContractOnERC721Received(
1053         address from,
1054         address to,
1055         uint256 tokenId,
1056         bytes memory _data
1057     ) private returns (bool) {
1058         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1059             bytes4 retval
1060         ) {
1061             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1062         } catch (bytes memory reason) {
1063             if (reason.length == 0) {
1064                 revert TransferToNonERC721ReceiverImplementer();
1065             } else {
1066                 assembly {
1067                     revert(add(32, reason), mload(reason))
1068                 }
1069             }
1070         }
1071     }
1072 
1073     /**
1074      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1075      * And also called before burning one token.
1076      *
1077      * startTokenId - the first token id to be transferred
1078      * quantity - the amount to be transferred
1079      *
1080      * Calling conditions:
1081      *
1082      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1083      * transferred to `to`.
1084      * - When `from` is zero, `tokenId` will be minted for `to`.
1085      * - When `to` is zero, `tokenId` will be burned by `from`.
1086      * - `from` and `to` are never both zero.
1087      */
1088     function _beforeTokenTransfers(
1089         address from,
1090         address to,
1091         uint256 startTokenId,
1092         uint256 quantity
1093     ) internal virtual {}
1094 
1095     /**
1096      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1097      * minting.
1098      * And also called after one token has been burned.
1099      *
1100      * startTokenId - the first token id to be transferred
1101      * quantity - the amount to be transferred
1102      *
1103      * Calling conditions:
1104      *
1105      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1106      * transferred to `to`.
1107      * - When `from` is zero, `tokenId` has been minted for `to`.
1108      * - When `to` is zero, `tokenId` has been burned by `from`.
1109      * - `from` and `to` are never both zero.
1110      */
1111     function _afterTokenTransfers(
1112         address from,
1113         address to,
1114         uint256 startTokenId,
1115         uint256 quantity
1116     ) internal virtual {}
1117 
1118     /**
1119      * @dev Returns the message sender (defaults to `msg.sender`).
1120      *
1121      * If you are writing GSN compatible contracts, you need to override this function.
1122      */
1123     function _msgSenderERC721A() internal view virtual returns (address) {
1124         return msg.sender;
1125     }
1126 
1127     /**
1128      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1129      */
1130     function _toString(uint256 value) internal pure returns (string memory ptr) {
1131         assembly {
1132             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1133             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1134             // We will need 1 32-byte word to store the length,
1135             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1136             ptr := add(mload(0x40), 128)
1137             // Update the free memory pointer to allocate.
1138             mstore(0x40, ptr)
1139 
1140             // Cache the end of the memory to calculate the length later.
1141             let end := ptr
1142 
1143             // We write the string from the rightmost digit to the leftmost digit.
1144             // The following is essentially a do-while loop that also handles the zero case.
1145             // Costs a bit more than early returning for the zero case,
1146             // but cheaper in terms of deployment and overall runtime costs.
1147             for {
1148                 // Initialize and perform the first pass without check.
1149                 let temp := value
1150                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1151                 ptr := sub(ptr, 1)
1152                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1153                 mstore8(ptr, add(48, mod(temp, 10)))
1154                 temp := div(temp, 10)
1155             } temp {
1156                 // Keep dividing `temp` until zero.
1157                 temp := div(temp, 10)
1158             } {
1159                 // Body of the for loop.
1160                 ptr := sub(ptr, 1)
1161                 mstore8(ptr, add(48, mod(temp, 10)))
1162             }
1163 
1164             let length := sub(end, ptr)
1165             // Move the pointer 32 bytes leftwards to make room for the length.
1166             ptr := sub(ptr, 32)
1167             // Store the length.
1168             mstore(ptr, length)
1169         }
1170     }
1171 }
1172 
1173 contract StartTokenIdHelper {
1174     uint256 public startTokenId;
1175 
1176     constructor(uint256 startTokenId_) {
1177         startTokenId = startTokenId_;
1178     }
1179 }
1180 
1181 contract DZmilitary is ERC721A, Ownable {
1182   using Strings for uint256;
1183 
1184   string baseURI;
1185   string public baseExtension = ".json";
1186   uint256 public cost = 0.00 ether;
1187   uint256 public maxSupply = 333;
1188   uint256 public maxMintAmount = 1;
1189   bool public paused = false;
1190   bool public revealed = false;
1191   string public notRevealedUri;
1192   uint public maxAmountPerWallet = 1;
1193   uint public maxWalletHold = 1;
1194 
1195   constructor(
1196     string memory _name,
1197     string memory _symbol,
1198     string memory _initBaseURI,
1199     string memory _initNotRevealedUri
1200   ) 
1201     ERC721A(_name, _symbol) {
1202     setBaseURI(_initBaseURI);
1203     setNotRevealedURI(_initNotRevealedUri);
1204   }
1205 
1206   // internal
1207   function _baseURI() internal view virtual override returns (string memory) {
1208     return baseURI;
1209   }
1210 
1211   function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal override {
1212     require(balanceOf(msg.sender) < maxWalletHold, "Wallet max amount overflow");
1213     super._beforeTokenTransfers(from, to, startTokenId, quantity);
1214   } 
1215 
1216   // public
1217   function mint(uint256 _mintAmount) public payable {
1218     uint256 supply = totalSupply();
1219     require(!paused);
1220     require(_mintAmount > 0);
1221     require(_mintAmount <= maxMintAmount);
1222     require(supply + _mintAmount <= maxSupply);
1223     require(balanceOf(msg.sender) < maxAmountPerWallet, "Wallet max amount overflow");
1224 
1225     if (msg.sender != owner()) {
1226       require(msg.value >= cost * _mintAmount);
1227     }
1228 
1229     _safeMint(msg.sender, _mintAmount);
1230   }
1231 
1232   function tokenURI(uint256 tokenId)
1233     public
1234     view
1235     virtual
1236     override
1237     returns (string memory)
1238   {
1239     require(
1240       _exists(tokenId),
1241       "ERC721AMetadata: URI query for nonexistent token"
1242     );
1243     
1244     if(revealed == false) {
1245         return bytes(notRevealedUri).length > 0
1246             ? string(abi.encodePacked(notRevealedUri, tokenId.toString(), baseExtension))
1247             : "";
1248     }
1249 
1250     string memory currentBaseURI = _baseURI();
1251     return bytes(currentBaseURI).length > 0
1252         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1253         : "";
1254   }
1255 
1256   //only owner
1257   function reveal() public onlyOwner {
1258       revealed = true;
1259   }
1260   
1261   function setCost(uint256 _newCost) public onlyOwner {
1262     cost = _newCost;
1263   }
1264 
1265   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1266     maxMintAmount = _newmaxMintAmount;
1267   }
1268   
1269   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1270     notRevealedUri = _notRevealedURI;
1271   }
1272 
1273   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1274     baseURI = _newBaseURI;
1275   }
1276 
1277   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1278     baseExtension = _newBaseExtension;
1279   }
1280 
1281   function pause(bool _state) public onlyOwner {
1282     paused = _state;
1283   }
1284 
1285   function setMaxAmountPerWallet(uint256 _maxAmountPerWallet) public onlyOwner {
1286     maxAmountPerWallet = _maxAmountPerWallet;
1287   }
1288 
1289   function setMaxWalletHolding(uint256 _maxHoldingPerWallet) public onlyOwner {
1290     maxWalletHold = _maxHoldingPerWallet;
1291   }
1292  
1293   function withdraw() public payable onlyOwner {
1294     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1295     require(os);
1296   }
1297 }