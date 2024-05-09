1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-15
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.4;
7 
8 /**
9  * @dev Interface of an ERC721A compliant contract.
10  */
11 interface IERC721A {
12     /**
13      * The caller must own the token or be an approved operator.
14      */
15     error ApprovalCallerNotOwnerNorApproved();
16 
17     /**
18      * The token does not exist.
19      */
20     error ApprovalQueryForNonexistentToken();
21 
22     /**
23      * The caller cannot approve to their own address.
24      */
25     error ApproveToCaller();
26 
27     /**
28      * The caller cannot approve to the current owner.
29      */
30     error ApprovalToCurrentOwner();
31 
32     /**
33      * Cannot query the balance for the zero address.
34      */
35     error BalanceQueryForZeroAddress();
36 
37     /**
38      * Cannot mint to the zero address.
39      */
40     error MintToZeroAddress();
41 
42     /**
43      * The quantity of tokens minted must be more than zero.
44      */
45     error MintZeroQuantity();
46 
47     /**
48      * The token does not exist.
49      */
50     error OwnerQueryForNonexistentToken();
51 
52     /**
53      * The caller must own the token or be an approved operator.
54      */
55     error TransferCallerNotOwnerNorApproved();
56 
57     /**
58      * The token must be owned by `from`.
59      */
60     error TransferFromIncorrectOwner();
61 
62     /**
63      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
64      */
65     error TransferToNonERC721ReceiverImplementer();
66 
67     /**
68      * Cannot transfer to the zero address.
69      */
70     error TransferToZeroAddress();
71 
72     /**
73      * The token does not exist.
74      */
75     error URIQueryForNonexistentToken();
76 
77     struct TokenOwnership {
78         // The address of the owner.
79         address addr;
80         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
81         uint64 startTimestamp;
82         // Whether the token has been burned.
83         bool burned;
84     }
85 
86     /**
87      * @dev Returns the total amount of tokens stored by the contract.
88      *
89      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
90      */
91     function totalSupply() external view returns (uint256);
92 
93     // ==============================
94     //            IERC165
95     // ==============================
96 
97     /**
98      * @dev Returns true if this contract implements the interface defined by
99      * `interfaceId`. See the corresponding
100      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
101      * to learn more about how these ids are created.
102      *
103      * This function call must use less than 30 000 gas.
104      */
105     function supportsInterface(bytes4 interfaceId) external view returns (bool);
106 
107     // ==============================
108     //            IERC721
109     // ==============================
110 
111     /**
112      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
113      */
114     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
115 
116     /**
117      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
118      */
119     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
120 
121     /**
122      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
123      */
124     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
125 
126     /**
127      * @dev Returns the number of tokens in ``owner``'s account.
128      */
129     function balanceOf(address owner) external view returns (uint256 balance);
130 
131     /**
132      * @dev Returns the owner of the `tokenId` token.
133      *
134      * Requirements:
135      *
136      * - `tokenId` must exist.
137      */
138     function ownerOf(uint256 tokenId) external view returns (address owner);
139 
140     /**
141      * @dev Safely transfers `tokenId` token from `from` to `to`.
142      *
143      * Requirements:
144      *
145      * - `from` cannot be the zero address.
146      * - `to` cannot be the zero address.
147      * - `tokenId` token must exist and be owned by `from`.
148      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
149      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
150      *
151      * Emits a {Transfer} event.
152      */
153     function safeTransferFrom(
154         address from,
155         address to,
156         uint256 tokenId,
157         bytes calldata data
158     ) external;
159 
160     /**
161      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
162      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
163      *
164      * Requirements:
165      *
166      * - `from` cannot be the zero address.
167      * - `to` cannot be the zero address.
168      * - `tokenId` token must exist and be owned by `from`.
169      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171      *
172      * Emits a {Transfer} event.
173      */
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId
178     ) external;
179 
180     /**
181      * @dev Transfers `tokenId` token from `from` to `to`.
182      *
183      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
184      *
185      * Requirements:
186      *
187      * - `from` cannot be the zero address.
188      * - `to` cannot be the zero address.
189      * - `tokenId` token must be owned by `from`.
190      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
191      *
192      * Emits a {Transfer} event.
193      */
194     function transferFrom(
195         address from,
196         address to,
197         uint256 tokenId
198     ) external;
199 
200     /**
201      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
202      * The approval is cleared when the token is transferred.
203      *
204      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
205      *
206      * Requirements:
207      *
208      * - The caller must own the token or be an approved operator.
209      * - `tokenId` must exist.
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address to, uint256 tokenId) external;
214 
215     /**
216      * @dev Approve or remove `operator` as an operator for the caller.
217      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
218      *
219      * Requirements:
220      *
221      * - The `operator` cannot be the caller.
222      *
223      * Emits an {ApprovalForAll} event.
224      */
225     function setApprovalForAll(address operator, bool _approved) external;
226 
227     /**
228      * @dev Returns the account approved for `tokenId` token.
229      *
230      * Requirements:
231      *
232      * - `tokenId` must exist.
233      */
234     function getApproved(uint256 tokenId) external view returns (address operator);
235 
236     /**
237      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
238      *
239      * See {setApprovalForAll}
240      */
241     function isApprovedForAll(address owner, address operator) external view returns (bool);
242 
243     // ==============================
244     //        IERC721Metadata
245     // ==============================
246 
247     /**
248      * @dev Returns the token collection name.
249      */
250     function name() external view returns (string memory);
251 
252     /**
253      * @dev Returns the token collection symbol.
254      */
255     function symbol() external view returns (string memory);
256 
257     /**
258      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
259      */
260     function tokenURI(uint256 tokenId) external view returns (string memory);
261 }
262 
263 pragma solidity ^0.8.4;
264 
265 /**
266  * @dev Interface of an ERC721AQueryable compliant contract.
267  */
268 interface IERC721AQueryable is IERC721A {
269     /**
270      * Invalid query range (`start` >= `stop`).
271      */
272     error InvalidQueryRange();
273 
274     /**
275      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
276      *
277      * If the `tokenId` is out of bounds:
278      *   - `addr` = `address(0)`
279      *   - `startTimestamp` = `0`
280      *   - `burned` = `false`
281      *
282      * If the `tokenId` is burned:
283      *   - `addr` = `<Address of owner before token was burned>`
284      *   - `startTimestamp` = `<Timestamp when token was burned>`
285      *   - `burned = `true`
286      *
287      * Otherwise:
288      *   - `addr` = `<Address of owner>`
289      *   - `startTimestamp` = `<Timestamp of start of ownership>`
290      *   - `burned = `false`
291      */
292     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
293 
294     /**
295      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
296      * See {ERC721AQueryable-explicitOwnershipOf}
297      */
298     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
299 
300     /**
301      * @dev Returns an array of token IDs owned by `owner`,
302      * in the range [`start`, `stop`)
303      * (i.e. `start <= tokenId < stop`).
304      *
305      * This function allows for tokens to be queried if the collection
306      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
307      *
308      * Requirements:
309      *
310      * - `start` < `stop`
311      */
312     function tokensOfOwnerIn(
313         address owner,
314         uint256 start,
315         uint256 stop
316     ) external view returns (uint256[] memory);
317 
318     /**
319      * @dev Returns an array of token IDs owned by `owner`.
320      *
321      * This function scans the ownership mapping and is O(totalSupply) in complexity.
322      * It is meant to be called off-chain.
323      *
324      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
325      * multiple smaller scans if the collection is large enough to cause
326      * an out-of-gas error (10K pfp collections should be fine).
327      */
328     function tokensOfOwner(address owner) external view returns (uint256[] memory);
329 }
330 
331 pragma solidity ^0.8.4;
332 
333 /**
334  * @dev Interface of an ERC721ABurnable compliant contract.
335  */
336 interface IERC721ABurnable is IERC721A {
337     /**
338      * @dev Burns `tokenId`. See {ERC721A-_burn}.
339      *
340      * Requirements:
341      *
342      * - The caller must own `tokenId` or be an approved operator.
343      */
344     function burn(uint256 tokenId) external;
345 }
346 
347 pragma solidity ^0.8.4;
348 
349 /**
350  * @dev Provides information about the current execution context, including the
351  * sender of the transaction and its data. While these are generally available
352  * via msg.sender and msg.data, they should not be accessed in such a direct
353  * manner, since when dealing with meta-transactions the account sending and
354  * paying for execution may not be the actual sender (as far as an application
355  * is concerned).
356  *
357  * This contract is only required for intermediate, library-like contracts.
358  */
359 abstract contract Context {
360     function _msgSender() internal view virtual returns (address) {
361         return msg.sender;
362     }
363 
364     function _msgData() internal view virtual returns (bytes calldata) {
365         return msg.data;
366     }
367 }
368 
369 pragma solidity ^0.8.4;
370 
371 /**
372  * @dev Contract module which provides a basic access control mechanism, where
373  * there is an account (an owner) that can be granted exclusive access to
374  * specific functions.
375  *
376  * By default, the owner account will be the one that deploys the contract. This
377  * can later be changed with {transferOwnership}.
378  *
379  * This module is used through inheritance. It will make available the modifier
380  * `onlyOwner`, which can be applied to your functions to restrict their use to
381  * the owner.
382  */
383 abstract contract Ownable is Context {
384     address private _owner;
385 
386     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
387 
388     /**
389      * @dev Initializes the contract setting the deployer as the initial owner.
390      */
391     constructor() {
392         _transferOwnership(_msgSender());
393     }
394 
395     /**
396      * @dev Returns the address of the current owner.
397      */
398     function owner() public view virtual returns (address) {
399         return _owner;
400     }
401 
402     /**
403      * @dev Throws if called by any account other than the owner.
404      */
405     modifier onlyOwner() {
406         require(owner() == _msgSender(), "Ownable: caller is not the owner");
407         _;
408     }
409 
410     /**
411      * @dev Leaves the contract without owner. It will not be possible to call
412      * `onlyOwner` functions anymore. Can only be called by the current owner.
413      *
414      * NOTE: Renouncing ownership will leave the contract without an owner,
415      * thereby removing any functionality that is only available to the owner.
416      */
417     function renounceOwnership() public virtual onlyOwner {
418         _transferOwnership(address(0));
419     }
420 
421     /**
422      * @dev Transfers ownership of the contract to a new account (`newOwner`).
423      * Can only be called by the current owner.
424      */
425     function transferOwnership(address newOwner) public virtual onlyOwner {
426         require(newOwner != address(0), "Ownable: new owner is the zero address");
427         _transferOwnership(newOwner);
428     }
429 
430     /**
431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
432      * Internal function without access restriction.
433      */
434     function _transferOwnership(address newOwner) internal virtual {
435         address oldOwner = _owner;
436         _owner = newOwner;
437         emit OwnershipTransferred(oldOwner, newOwner);
438     }
439 }
440 
441 pragma solidity ^0.8.4;
442 
443 /**
444  * @dev ERC721 token receiver interface.
445  */
446 interface ERC721A__IERC721Receiver {
447     function onERC721Received(
448         address operator,
449         address from,
450         uint256 tokenId,
451         bytes calldata data
452     ) external returns (bytes4);
453 }
454 
455 pragma solidity ^0.8.4;
456 
457 /**
458  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
459  * the Metadata extension. Built to optimize for lower gas during batch mints.
460  *
461  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
462  *
463  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
464  *
465  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
466  */
467 contract ERC721A is IERC721A {
468     // Mask of an entry in packed address data.
469     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
470 
471     // The bit position of `numberMinted` in packed address data.
472     uint256 private constant BITPOS_NUMBER_MINTED = 64;
473 
474     // The bit position of `numberBurned` in packed address data.
475     uint256 private constant BITPOS_NUMBER_BURNED = 128;
476 
477     // The bit position of `aux` in packed address data.
478     uint256 private constant BITPOS_AUX = 192;
479 
480     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
481     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
482 
483     // The bit position of `startTimestamp` in packed ownership.
484     uint256 private constant BITPOS_START_TIMESTAMP = 160;
485 
486     // The bit mask of the `burned` bit in packed ownership.
487     uint256 private constant BITMASK_BURNED = 1 << 224;
488 
489     // The bit position of the `nextInitialized` bit in packed ownership.
490     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
491 
492     // The bit mask of the `nextInitialized` bit in packed ownership.
493     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
494 
495     // The tokenId of the next token to be minted.
496     uint256 private _currentIndex;
497 
498     // The number of tokens burned.
499     uint256 private _burnCounter;
500 
501     // Token name
502     string private _name;
503 
504     // Token symbol
505     string private _symbol;
506 
507     // Mapping from token ID to ownership details
508     // An empty struct value does not necessarily mean the token is unowned.
509     // See `_packedOwnershipOf` implementation for details.
510     //
511     // Bits Layout:
512     // - [0..159]   `addr`
513     // - [160..223] `startTimestamp`
514     // - [224]      `burned`
515     // - [225]      `nextInitialized`
516     mapping(uint256 => uint256) private _packedOwnerships;
517 
518     // Mapping owner address to address data.
519     //
520     // Bits Layout:
521     // - [0..63]    `balance`
522     // - [64..127]  `numberMinted`
523     // - [128..191] `numberBurned`
524     // - [192..255] `aux`
525     mapping(address => uint256) private _packedAddressData;
526 
527     // Mapping from token ID to approved address.
528     mapping(uint256 => address) private _tokenApprovals;
529 
530     // Mapping from owner to operator approvals
531     mapping(address => mapping(address => bool)) private _operatorApprovals;
532 
533     constructor(string memory name_, string memory symbol_) {
534         _name = name_;
535         _symbol = symbol_;
536         _currentIndex = _startTokenId();
537     }
538 
539     /**
540      * @dev Returns the starting token ID.
541      * To change the starting token ID, please override this function.
542      */
543     function _startTokenId() internal view virtual returns (uint256) {
544         return 0;
545     }
546 
547     /**
548      * @dev Returns the next token ID to be minted.
549      */
550     function _nextTokenId() internal view returns (uint256) {
551         return _currentIndex;
552     }
553 
554     /**
555      * @dev Returns the total number of tokens in existence.
556      * Burned tokens will reduce the count.
557      * To get the total number of tokens minted, please see `_totalMinted`.
558      */
559     function totalSupply() public view override returns (uint256) {
560         // Counter underflow is impossible as _burnCounter cannot be incremented
561         // more than `_currentIndex - _startTokenId()` times.
562     unchecked {
563         return _currentIndex - _burnCounter - _startTokenId();
564     }
565     }
566 
567     /**
568      * @dev Returns the total amount of tokens minted in the contract.
569      */
570     function _totalMinted() internal view returns (uint256) {
571         // Counter underflow is impossible as _currentIndex does not decrement,
572         // and it is initialized to `_startTokenId()`
573     unchecked {
574         return _currentIndex - _startTokenId();
575     }
576     }
577 
578     /**
579      * @dev Returns the total number of tokens burned.
580      */
581     function _totalBurned() internal view returns (uint256) {
582         return _burnCounter;
583     }
584 
585     /**
586      * @dev See {IERC165-supportsInterface}.
587      */
588     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
589         // The interface IDs are constants representing the first 4 bytes of the XOR of
590         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
591         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
592         return
593         interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
594         interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
595         interfaceId == 0x5b5e139f;
596         // ERC165 interface ID for ERC721Metadata.
597     }
598 
599     /**
600      * @dev See {IERC721-balanceOf}.
601      */
602     function balanceOf(address owner) public view override returns (uint256) {
603         if (owner == address(0)) revert BalanceQueryForZeroAddress();
604         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
605     }
606 
607     /**
608      * Returns the number of tokens minted by `owner`.
609      */
610     function _numberMinted(address owner) internal view returns (uint256) {
611         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
612     }
613 
614     /**
615      * Returns the number of tokens burned by or on behalf of `owner`.
616      */
617     function _numberBurned(address owner) internal view returns (uint256) {
618         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
619     }
620 
621     /**
622      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
623      */
624     function _getAux(address owner) internal view returns (uint64) {
625         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
626     }
627 
628     /**
629      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
630      * If there are multiple variables, please pack them into a uint64.
631      */
632     function _setAux(address owner, uint64 aux) internal {
633         uint256 packed = _packedAddressData[owner];
634         uint256 auxCasted;
635         assembly {// Cast aux without masking.
636             auxCasted := aux
637         }
638         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
639         _packedAddressData[owner] = packed;
640     }
641 
642     /**
643      * Returns the packed ownership data of `tokenId`.
644      */
645     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
646         uint256 curr = tokenId;
647 
648     unchecked {
649         if (_startTokenId() <= curr)
650             if (curr < _currentIndex) {
651                 uint256 packed = _packedOwnerships[curr];
652                 // If not burned.
653                 if (packed & BITMASK_BURNED == 0) {
654                     // Invariant:
655                     // There will always be an ownership that has an address and is not burned
656                     // before an ownership that does not have an address and is not burned.
657                     // Hence, curr will not underflow.
658                     //
659                     // We can directly compare the packed value.
660                     // If the address is zero, packed is zero.
661                     while (packed == 0) {
662                         packed = _packedOwnerships[--curr];
663                     }
664                     return packed;
665                 }
666             }
667     }
668         revert OwnerQueryForNonexistentToken();
669     }
670 
671     /**
672      * Returns the unpacked `TokenOwnership` struct from `packed`.
673      */
674     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
675         ownership.addr = address(uint160(packed));
676         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
677         ownership.burned = packed & BITMASK_BURNED != 0;
678         return ownership;
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
852         _startTokenId() <= tokenId &&
853         tokenId < _currentIndex && // If within bounds,
854         _packedOwnerships[tokenId] & BITMASK_BURNED == 0;
855         // and not burned.
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
890     unchecked {
891         // Updates:
892         // - `balance += quantity`.
893         // - `numberMinted += quantity`.
894         //
895         // We can directly add to the balance and number minted.
896         _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
897 
898         // Updates:
899         // - `address` to the owner.
900         // - `startTimestamp` to the timestamp of minting.
901         // - `burned` to `false`.
902         // - `nextInitialized` to `quantity == 1`.
903         _packedOwnerships[startTokenId] =
904         _addressToUint256(to) |
905         (block.timestamp << BITPOS_START_TIMESTAMP) |
906         (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
907 
908         uint256 updatedIndex = startTokenId;
909         uint256 end = updatedIndex + quantity;
910 
911         if (to.code.length != 0) {
912             do {
913                 emit Transfer(address(0), to, updatedIndex);
914                 if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
915                     revert TransferToNonERC721ReceiverImplementer();
916                 }
917             }
918             while (updatedIndex < end);
919             // Reentrancy protection
920             if (_currentIndex != startTokenId) revert();
921         } else {
922             do {
923                 emit Transfer(address(0), to, updatedIndex++);
924             }
925             while (updatedIndex < end);
926         }
927         _currentIndex = updatedIndex;
928     }
929         _afterTokenTransfers(address(0), to, startTokenId, quantity);
930     }
931 
932     /**
933      * @dev Mints `quantity` tokens and transfers them to `to`.
934      *
935      * Requirements:
936      *
937      * - `to` cannot be the zero address.
938      * - `quantity` must be greater than 0.
939      *
940      * Emits a {Transfer} event.
941      */
942     function _mint(address to, uint256 quantity) internal {
943         uint256 startTokenId = _currentIndex;
944         if (to == address(0)) revert MintToZeroAddress();
945         if (quantity == 0) revert MintZeroQuantity();
946 
947         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
948 
949         // Overflows are incredibly unrealistic.
950         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
951         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
952     unchecked {
953         // Updates:
954         // - `balance += quantity`.
955         // - `numberMinted += quantity`.
956         //
957         // We can directly add to the balance and number minted.
958         _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
959 
960         // Updates:
961         // - `address` to the owner.
962         // - `startTimestamp` to the timestamp of minting.
963         // - `burned` to `false`.
964         // - `nextInitialized` to `quantity == 1`.
965         _packedOwnerships[startTokenId] =
966         _addressToUint256(to) |
967         (block.timestamp << BITPOS_START_TIMESTAMP) |
968         (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
969 
970         uint256 updatedIndex = startTokenId;
971         uint256 end = updatedIndex + quantity;
972 
973         do {
974             emit Transfer(address(0), to, updatedIndex++);
975         }
976         while (updatedIndex < end);
977 
978         _currentIndex = updatedIndex;
979     }
980         _afterTokenTransfers(address(0), to, startTokenId, quantity);
981     }
982 
983     /**
984      * @dev Transfers `tokenId` from `from` to `to`.
985      *
986      * Requirements:
987      *
988      * - `to` cannot be the zero address.
989      * - `tokenId` token must be owned by `from`.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _transfer(
994         address from,
995         address to,
996         uint256 tokenId
997     ) private {
998         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
999 
1000         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1001 
1002         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1003         isApprovedForAll(from, _msgSenderERC721A()) ||
1004         getApproved(tokenId) == _msgSenderERC721A());
1005 
1006         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1007         if (to == address(0)) revert TransferToZeroAddress();
1008 
1009         _beforeTokenTransfers(from, to, tokenId, 1);
1010 
1011         // Clear approvals from the previous owner.
1012         delete _tokenApprovals[tokenId];
1013 
1014         // Underflow of the sender's balance is impossible because we check for
1015         // ownership above and the recipient's balance can't realistically overflow.
1016         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1017     unchecked {
1018         // We can directly increment and decrement the balances.
1019         --_packedAddressData[from];
1020         // Updates: `balance -= 1`.
1021         ++_packedAddressData[to];
1022         // Updates: `balance += 1`.
1023 
1024         // Updates:
1025         // - `address` to the next owner.
1026         // - `startTimestamp` to the timestamp of transfering.
1027         // - `burned` to `false`.
1028         // - `nextInitialized` to `true`.
1029         _packedOwnerships[tokenId] =
1030         _addressToUint256(to) |
1031         (block.timestamp << BITPOS_START_TIMESTAMP) |
1032         BITMASK_NEXT_INITIALIZED;
1033 
1034         // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1035         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1036             uint256 nextTokenId = tokenId + 1;
1037             // If the next slot's address is zero and not burned (i.e. packed value is zero).
1038             if (_packedOwnerships[nextTokenId] == 0) {
1039                 // If the next slot is within bounds.
1040                 if (nextTokenId != _currentIndex) {
1041                     // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1042                     _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1043                 }
1044             }
1045         }
1046     }
1047 
1048         emit Transfer(from, to, tokenId);
1049         _afterTokenTransfers(from, to, tokenId, 1);
1050     }
1051 
1052     /**
1053      * @dev Equivalent to `_burn(tokenId, false)`.
1054      */
1055     function _burn(uint256 tokenId) internal virtual {
1056         _burn(tokenId, false);
1057     }
1058 
1059     /**
1060      * @dev Destroys `tokenId`.
1061      * The approval is cleared when the token is burned.
1062      *
1063      * Requirements:
1064      *
1065      * - `tokenId` must exist.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1070         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1071 
1072         address from = address(uint160(prevOwnershipPacked));
1073 
1074         if (approvalCheck) {
1075             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1076             isApprovedForAll(from, _msgSenderERC721A()) ||
1077             getApproved(tokenId) == _msgSenderERC721A());
1078 
1079             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1080         }
1081 
1082         _beforeTokenTransfers(from, address(0), tokenId, 1);
1083 
1084         // Clear approvals from the previous owner.
1085         delete _tokenApprovals[tokenId];
1086 
1087         // Underflow of the sender's balance is impossible because we check for
1088         // ownership above and the recipient's balance can't realistically overflow.
1089         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1090     unchecked {
1091         // Updates:
1092         // - `balance -= 1`.
1093         // - `numberBurned += 1`.
1094         //
1095         // We can directly decrement the balance, and increment the number burned.
1096         // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1097         _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1098 
1099         // Updates:
1100         // - `address` to the last owner.
1101         // - `startTimestamp` to the timestamp of burning.
1102         // - `burned` to `true`.
1103         // - `nextInitialized` to `true`.
1104         _packedOwnerships[tokenId] =
1105         _addressToUint256(from) |
1106         (block.timestamp << BITPOS_START_TIMESTAMP) |
1107         BITMASK_BURNED |
1108         BITMASK_NEXT_INITIALIZED;
1109 
1110         // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1111         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1112             uint256 nextTokenId = tokenId + 1;
1113             // If the next slot's address is zero and not burned (i.e. packed value is zero).
1114             if (_packedOwnerships[nextTokenId] == 0) {
1115                 // If the next slot is within bounds.
1116                 if (nextTokenId != _currentIndex) {
1117                     // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1118                     _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1119                 }
1120             }
1121         }
1122     }
1123 
1124         emit Transfer(from, address(0), tokenId);
1125         _afterTokenTransfers(from, address(0), tokenId, 1);
1126 
1127         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1128     unchecked {
1129         _burnCounter++;
1130     }
1131     }
1132 
1133     /**
1134      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1135      *
1136      * @param from address representing the previous owner of the given token ID
1137      * @param to target address that will receive the tokens
1138      * @param tokenId uint256 ID of the token to be transferred
1139      * @param _data bytes optional data to send along with the call
1140      * @return bool whether the call correctly returned the expected magic value
1141      */
1142     function _checkContractOnERC721Received(
1143         address from,
1144         address to,
1145         uint256 tokenId,
1146         bytes memory _data
1147     ) private returns (bool) {
1148         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1149             bytes4 retval
1150         ) {
1151             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1152         } catch (bytes memory reason) {
1153             if (reason.length == 0) {
1154                 revert TransferToNonERC721ReceiverImplementer();
1155             } else {
1156                 assembly {
1157                     revert(add(32, reason), mload(reason))
1158                 }
1159             }
1160         }
1161     }
1162 
1163     /**
1164      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1165      * And also called before burning one token.
1166      *
1167      * startTokenId - the first token id to be transferred
1168      * quantity - the amount to be transferred
1169      *
1170      * Calling conditions:
1171      *
1172      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1173      * transferred to `to`.
1174      * - When `from` is zero, `tokenId` will be minted for `to`.
1175      * - When `to` is zero, `tokenId` will be burned by `from`.
1176      * - `from` and `to` are never both zero.
1177      */
1178     function _beforeTokenTransfers(
1179         address from,
1180         address to,
1181         uint256 startTokenId,
1182         uint256 quantity
1183     ) internal virtual {}
1184 
1185     /**
1186      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1187      * minting.
1188      * And also called after one token has been burned.
1189      *
1190      * startTokenId - the first token id to be transferred
1191      * quantity - the amount to be transferred
1192      *
1193      * Calling conditions:
1194      *
1195      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1196      * transferred to `to`.
1197      * - When `from` is zero, `tokenId` has been minted for `to`.
1198      * - When `to` is zero, `tokenId` has been burned by `from`.
1199      * - `from` and `to` are never both zero.
1200      */
1201     function _afterTokenTransfers(
1202         address from,
1203         address to,
1204         uint256 startTokenId,
1205         uint256 quantity
1206     ) internal virtual {}
1207 
1208     /**
1209      * @dev Returns the message sender (defaults to `msg.sender`).
1210      *
1211      * If you are writing GSN compatible contracts, you need to override this function.
1212      */
1213     function _msgSenderERC721A() internal view virtual returns (address) {
1214         return msg.sender;
1215     }
1216 
1217     /**
1218      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1219      */
1220     function _toString(uint256 value) internal pure returns (string memory ptr) {
1221         assembly {
1222         // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1223         // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1224         // We will need 1 32-byte word to store the length,
1225         // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1226             ptr := add(mload(0x40), 128)
1227         // Update the free memory pointer to allocate.
1228             mstore(0x40, ptr)
1229 
1230         // Cache the end of the memory to calculate the length later.
1231             let end := ptr
1232 
1233         // We write the string from the rightmost digit to the leftmost digit.
1234         // The following is essentially a do-while loop that also handles the zero case.
1235         // Costs a bit more than early returning for the zero case,
1236         // but cheaper in terms of deployment and overall runtime costs.
1237             for {
1238             // Initialize and perform the first pass without check.
1239                 let temp := value
1240             // Move the pointer 1 byte leftwards to point to an empty character slot.
1241                 ptr := sub(ptr, 1)
1242             // Write the character to the pointer. 48 is the ASCII index of '0'.
1243                 mstore8(ptr, add(48, mod(temp, 10)))
1244                 temp := div(temp, 10)
1245             } temp {
1246             // Keep dividing `temp` until zero.
1247                 temp := div(temp, 10)
1248             } {// Body of the for loop.
1249                 ptr := sub(ptr, 1)
1250                 mstore8(ptr, add(48, mod(temp, 10)))
1251             }
1252 
1253             let length := sub(end, ptr)
1254         // Move the pointer 32 bytes leftwards to make room for the length.
1255             ptr := sub(ptr, 32)
1256         // Store the length.
1257             mstore(ptr, length)
1258         }
1259     }
1260 }
1261 
1262 pragma solidity ^0.8.4;
1263 
1264 /**
1265  * @title ERC721A Burnable Token
1266  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1267  */
1268 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1269     /**
1270      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1271      *
1272      * Requirements:
1273      *
1274      * - The caller must own `tokenId` or be an approved operator.
1275      */
1276     function burn(uint256 tokenId) public virtual override {
1277         _burn(tokenId, true);
1278     }
1279 }
1280 
1281 pragma solidity ^0.8.4;
1282 
1283 /**
1284  * @title ERC721A Queryable
1285  * @dev ERC721A subclass with convenience query functions.
1286  */
1287 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1288     /**
1289      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1290      *
1291      * If the `tokenId` is out of bounds:
1292      *   - `addr` = `address(0)`
1293      *   - `startTimestamp` = `0`
1294      *   - `burned` = `false`
1295      *
1296      * If the `tokenId` is burned:
1297      *   - `addr` = `<Address of owner before token was burned>`
1298      *   - `startTimestamp` = `<Timestamp when token was burned>`
1299      *   - `burned = `true`
1300      *
1301      * Otherwise:
1302      *   - `addr` = `<Address of owner>`
1303      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1304      *   - `burned = `false`
1305      */
1306     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1307         TokenOwnership memory ownership;
1308         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1309             return ownership;
1310         }
1311         ownership = _ownershipAt(tokenId);
1312         if (ownership.burned) {
1313             return ownership;
1314         }
1315         return _ownershipOf(tokenId);
1316     }
1317 
1318     /**
1319      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1320      * See {ERC721AQueryable-explicitOwnershipOf}
1321      */
1322     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1323     unchecked {
1324         uint256 tokenIdsLength = tokenIds.length;
1325         TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1326         for (uint256 i; i != tokenIdsLength; ++i) {
1327             ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1328         }
1329         return ownerships;
1330     }
1331     }
1332 
1333     /**
1334      * @dev Returns an array of token IDs owned by `owner`,
1335      * in the range [`start`, `stop`)
1336      * (i.e. `start <= tokenId < stop`).
1337      *
1338      * This function allows for tokens to be queried if the collection
1339      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1340      *
1341      * Requirements:
1342      *
1343      * - `start` < `stop`
1344      */
1345     function tokensOfOwnerIn(
1346         address owner,
1347         uint256 start,
1348         uint256 stop
1349     ) external view override returns (uint256[] memory) {
1350     unchecked {
1351         if (start >= stop) revert InvalidQueryRange();
1352         uint256 tokenIdsIdx;
1353         uint256 stopLimit = _nextTokenId();
1354         // Set `start = max(start, _startTokenId())`.
1355         if (start < _startTokenId()) {
1356             start = _startTokenId();
1357         }
1358         // Set `stop = min(stop, stopLimit)`.
1359         if (stop > stopLimit) {
1360             stop = stopLimit;
1361         }
1362         uint256 tokenIdsMaxLength = balanceOf(owner);
1363         // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1364         // to cater for cases where `balanceOf(owner)` is too big.
1365         if (start < stop) {
1366             uint256 rangeLength = stop - start;
1367             if (rangeLength < tokenIdsMaxLength) {
1368                 tokenIdsMaxLength = rangeLength;
1369             }
1370         } else {
1371             tokenIdsMaxLength = 0;
1372         }
1373         uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1374         if (tokenIdsMaxLength == 0) {
1375             return tokenIds;
1376         }
1377         // We need to call `explicitOwnershipOf(start)`,
1378         // because the slot at `start` may not be initialized.
1379         TokenOwnership memory ownership = explicitOwnershipOf(start);
1380         address currOwnershipAddr;
1381         // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1382         // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1383         if (!ownership.burned) {
1384             currOwnershipAddr = ownership.addr;
1385         }
1386         for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1387             ownership = _ownershipAt(i);
1388             if (ownership.burned) {
1389                 continue;
1390             }
1391             if (ownership.addr != address(0)) {
1392                 currOwnershipAddr = ownership.addr;
1393             }
1394             if (currOwnershipAddr == owner) {
1395                 tokenIds[tokenIdsIdx++] = i;
1396             }
1397         }
1398         // Downsize the array to fit.
1399         assembly {
1400             mstore(tokenIds, tokenIdsIdx)
1401         }
1402         return tokenIds;
1403     }
1404     }
1405 
1406     /**
1407      * @dev Returns an array of token IDs owned by `owner`.
1408      *
1409      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1410      * It is meant to be called off-chain.
1411      *
1412      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1413      * multiple smaller scans if the collection is large enough to cause
1414      * an out-of-gas error (10K pfp collections should be fine).
1415      */
1416     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1417     unchecked {
1418         uint256 tokenIdsIdx;
1419         address currOwnershipAddr;
1420         uint256 tokenIdsLength = balanceOf(owner);
1421         uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1422         TokenOwnership memory ownership;
1423         for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1424             ownership = _ownershipAt(i);
1425             if (ownership.burned) {
1426                 continue;
1427             }
1428             if (ownership.addr != address(0)) {
1429                 currOwnershipAddr = ownership.addr;
1430             }
1431             if (currOwnershipAddr == owner) {
1432                 tokenIds[tokenIdsIdx++] = i;
1433             }
1434         }
1435         return tokenIds;
1436     }
1437     }
1438 }
1439 
1440 
1441 pragma solidity ^0.8.4;
1442 
1443 /**
1444  * @dev Library for managing
1445  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1446  * types.
1447  *
1448  * Sets have the following properties:
1449  *
1450  * - Elements are added, removed, and checked for existence in constant time
1451  * (O(1)).
1452  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1453  *
1454  * ```
1455  * contract Example {
1456  *     // Add the library methods
1457  *     using EnumerableSet for EnumerableSet.AddressSet;
1458  *
1459  *     // Declare a set state variable
1460  *     EnumerableSet.AddressSet private mySet;
1461  * }
1462  * ```
1463  *
1464  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1465  * and `uint256` (`UintSet`) are supported.
1466  */
1467 library EnumerableSet {
1468     // To implement this library for multiple types with as little code
1469     // repetition as possible, we write it in terms of a generic Set type with
1470     // bytes32 values.
1471     // The Set implementation uses private functions, and user-facing
1472     // implementations (such as AddressSet) are just wrappers around the
1473     // underlying Set.
1474     // This means that we can only create new EnumerableSets for types that fit
1475     // in bytes32.
1476 
1477     struct Set {
1478         // Storage of set values
1479         bytes32[] _values;
1480         // Position of the value in the `values` array, plus 1 because index 0
1481         // means a value is not in the set.
1482         mapping(bytes32 => uint256) _indexes;
1483     }
1484 
1485     /**
1486      * @dev Add a value to a set. O(1).
1487      *
1488      * Returns true if the value was added to the set, that is if it was not
1489      * already present.
1490      */
1491     function _add(Set storage set, bytes32 value) private returns (bool) {
1492         if (!_contains(set, value)) {
1493             set._values.push(value);
1494             // The value is stored at length-1, but we add 1 to all indexes
1495             // and use 0 as a sentinel value
1496             set._indexes[value] = set._values.length;
1497             return true;
1498         } else {
1499             return false;
1500         }
1501     }
1502 
1503     /**
1504      * @dev Removes a value from a set. O(1).
1505      *
1506      * Returns true if the value was removed from the set, that is if it was
1507      * present.
1508      */
1509     function _remove(Set storage set, bytes32 value) private returns (bool) {
1510         // We read and store the value's index to prevent multiple reads from the same storage slot
1511         uint256 valueIndex = set._indexes[value];
1512 
1513         if (valueIndex != 0) {
1514             // Equivalent to contains(set, value)
1515             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1516             // the array, and then remove the last element (sometimes called as 'swap and pop').
1517             // This modifies the order of the array, as noted in {at}.
1518 
1519             uint256 toDeleteIndex = valueIndex - 1;
1520             uint256 lastIndex = set._values.length - 1;
1521 
1522             if (lastIndex != toDeleteIndex) {
1523                 bytes32 lastValue = set._values[lastIndex];
1524 
1525                 // Move the last value to the index where the value to delete is
1526                 set._values[toDeleteIndex] = lastValue;
1527                 // Update the index for the moved value
1528                 set._indexes[lastValue] = valueIndex;
1529                 // Replace lastValue's index to valueIndex
1530             }
1531 
1532             // Delete the slot where the moved value was stored
1533             set._values.pop();
1534 
1535             // Delete the index for the deleted slot
1536             delete set._indexes[value];
1537 
1538             return true;
1539         } else {
1540             return false;
1541         }
1542     }
1543 
1544     /**
1545      * @dev Returns true if the value is in the set. O(1).
1546      */
1547     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1548         return set._indexes[value] != 0;
1549     }
1550 
1551     /**
1552      * @dev Returns the number of values on the set. O(1).
1553      */
1554     function _length(Set storage set) private view returns (uint256) {
1555         return set._values.length;
1556     }
1557 
1558     /**
1559      * @dev Returns the value stored at position `index` in the set. O(1).
1560      *
1561      * Note that there are no guarantees on the ordering of values inside the
1562      * array, and it may change when more values are added or removed.
1563      *
1564      * Requirements:
1565      *
1566      * - `index` must be strictly less than {length}.
1567      */
1568     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1569         return set._values[index];
1570     }
1571 
1572     /**
1573      * @dev Return the entire set in an array
1574      *
1575      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1576      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1577      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1578      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1579      */
1580     function _values(Set storage set) private view returns (bytes32[] memory) {
1581         return set._values;
1582     }
1583 
1584     // Bytes32Set
1585 
1586     struct Bytes32Set {
1587         Set _inner;
1588     }
1589 
1590     /**
1591      * @dev Add a value to a set. O(1).
1592      *
1593      * Returns true if the value was added to the set, that is if it was not
1594      * already present.
1595      */
1596     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1597         return _add(set._inner, value);
1598     }
1599 
1600     /**
1601      * @dev Removes a value from a set. O(1).
1602      *
1603      * Returns true if the value was removed from the set, that is if it was
1604      * present.
1605      */
1606     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1607         return _remove(set._inner, value);
1608     }
1609 
1610     /**
1611      * @dev Returns true if the value is in the set. O(1).
1612      */
1613     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1614         return _contains(set._inner, value);
1615     }
1616 
1617     /**
1618      * @dev Returns the number of values in the set. O(1).
1619      */
1620     function length(Bytes32Set storage set) internal view returns (uint256) {
1621         return _length(set._inner);
1622     }
1623 
1624     /**
1625      * @dev Returns the value stored at position `index` in the set. O(1).
1626      *
1627      * Note that there are no guarantees on the ordering of values inside the
1628      * array, and it may change when more values are added or removed.
1629      *
1630      * Requirements:
1631      *
1632      * - `index` must be strictly less than {length}.
1633      */
1634     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1635         return _at(set._inner, index);
1636     }
1637 
1638     /**
1639      * @dev Return the entire set in an array
1640      *
1641      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1642      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1643      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1644      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1645      */
1646     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1647         return _values(set._inner);
1648     }
1649 
1650     // AddressSet
1651 
1652     struct AddressSet {
1653         Set _inner;
1654     }
1655 
1656     /**
1657      * @dev Add a value to a set. O(1).
1658      *
1659      * Returns true if the value was added to the set, that is if it was not
1660      * already present.
1661      */
1662     function add(AddressSet storage set, address value) internal returns (bool) {
1663         return _add(set._inner, bytes32(uint256(uint160(value))));
1664     }
1665 
1666     /**
1667      * @dev Removes a value from a set. O(1).
1668      *
1669      * Returns true if the value was removed from the set, that is if it was
1670      * present.
1671      */
1672     function remove(AddressSet storage set, address value) internal returns (bool) {
1673         return _remove(set._inner, bytes32(uint256(uint160(value))));
1674     }
1675 
1676     /**
1677      * @dev Returns true if the value is in the set. O(1).
1678      */
1679     function contains(AddressSet storage set, address value) internal view returns (bool) {
1680         return _contains(set._inner, bytes32(uint256(uint160(value))));
1681     }
1682 
1683     /**
1684      * @dev Returns the number of values in the set. O(1).
1685      */
1686     function length(AddressSet storage set) internal view returns (uint256) {
1687         return _length(set._inner);
1688     }
1689 
1690     /**
1691      * @dev Returns the value stored at position `index` in the set. O(1).
1692      *
1693      * Note that there are no guarantees on the ordering of values inside the
1694      * array, and it may change when more values are added or removed.
1695      *
1696      * Requirements:
1697      *
1698      * - `index` must be strictly less than {length}.
1699      */
1700     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1701         return address(uint160(uint256(_at(set._inner, index))));
1702     }
1703 
1704     /**
1705      * @dev Return the entire set in an array
1706      *
1707      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1708      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1709      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1710      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1711      */
1712     function values(AddressSet storage set) internal view returns (address[] memory) {
1713         bytes32[] memory store = _values(set._inner);
1714         address[] memory result;
1715 
1716         assembly {
1717             result := store
1718         }
1719 
1720         return result;
1721     }
1722 
1723     // UintSet
1724 
1725     struct UintSet {
1726         Set _inner;
1727     }
1728 
1729     /**
1730      * @dev Add a value to a set. O(1).
1731      *
1732      * Returns true if the value was added to the set, that is if it was not
1733      * already present.
1734      */
1735     function add(UintSet storage set, uint256 value) internal returns (bool) {
1736         return _add(set._inner, bytes32(value));
1737     }
1738 
1739     /**
1740      * @dev Removes a value from a set. O(1).
1741      *
1742      * Returns true if the value was removed from the set, that is if it was
1743      * present.
1744      */
1745     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1746         return _remove(set._inner, bytes32(value));
1747     }
1748 
1749     /**
1750      * @dev Returns true if the value is in the set. O(1).
1751      */
1752     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1753         return _contains(set._inner, bytes32(value));
1754     }
1755 
1756     /**
1757      * @dev Returns the number of values on the set. O(1).
1758      */
1759     function length(UintSet storage set) internal view returns (uint256) {
1760         return _length(set._inner);
1761     }
1762 
1763     /**
1764      * @dev Returns the value stored at position `index` in the set. O(1).
1765      *
1766      * Note that there are no guarantees on the ordering of values inside the
1767      * array, and it may change when more values are added or removed.
1768      *
1769      * Requirements:
1770      *
1771      * - `index` must be strictly less than {length}.
1772      */
1773     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1774         return uint256(_at(set._inner, index));
1775     }
1776 
1777     /**
1778      * @dev Return the entire set in an array
1779      *
1780      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1781      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1782      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1783      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1784      */
1785     function values(UintSet storage set) internal view returns (uint256[] memory) {
1786         bytes32[] memory store = _values(set._inner);
1787         uint256[] memory result;
1788 
1789         assembly {
1790             result := store
1791         }
1792 
1793         return result;
1794     }
1795 }
1796 
1797 pragma solidity ^0.8.4;
1798 
1799 contract RealAliens is ERC721AQueryable, ERC721ABurnable, Ownable {
1800     using EnumerableSet for EnumerableSet.UintSet;
1801 
1802     uint256 public constant MAX_SUPPLY = 999;
1803 
1804     uint256 public maxByWallet = 1;
1805     mapping(address => uint256) public mintedByWallet;
1806 
1807     // 0:close | 1:open
1808     bool public saleState;
1809 
1810     bool public collectMarketing = true;
1811 
1812     //baseURI
1813     string public baseURI;
1814 
1815     //uriSuffix
1816     string public uriSuffix;
1817 
1818     constructor(
1819         string memory name,
1820         string memory symbol,
1821         string memory baseURI_,
1822         string memory uriSuffix_
1823     ) ERC721A(name, symbol) {
1824         baseURI = baseURI_;
1825         uriSuffix = uriSuffix_;
1826     }
1827 
1828     uint256 public MINT_PRICE = .00 ether;
1829 
1830     /******************** PUBLIC ********************/
1831 
1832     function mint(uint256 amount) external payable {
1833         require(msg.sender == tx.origin, "not allowed");
1834         require(saleState, "Sale is closed!");
1835         require(_totalMinted() + amount <= MAX_SUPPLY, "Exceed MAX_SUPPLY");
1836         require(amount > 0, "Amount can't be 0");
1837         require(amount + mintedByWallet[msg.sender] <= maxByWallet, "Exceed maxByWallet");
1838 
1839         if (collectMarketing) {
1840             require(amount * MINT_PRICE <= msg.value, "Invalid payment amount");
1841         }
1842 
1843         mintedByWallet[msg.sender] += amount;
1844 
1845         _safeMint(msg.sender, amount);
1846     }
1847 
1848     /******************** OVERRIDES ********************/
1849 
1850     function _startTokenId() internal view virtual override returns (uint256) {
1851         return 1;
1852     }
1853 
1854     function _baseURI() internal view virtual override returns (string memory) {
1855         return baseURI;
1856     }
1857 
1858     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1859         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1860 
1861         if (bytes(baseURI).length == 0) {
1862             return _toString(tokenId);
1863         }
1864 
1865         return string(abi.encodePacked(baseURI, _toString(tokenId), uriSuffix));
1866     }
1867 
1868     /******************** OWNER ********************/
1869 
1870     /// @notice Set baseURI.
1871     /// @param newBaseURI New baseURI.
1872     /// @param newUriSuffix New uriSuffix.
1873     function setBaseURI(string memory newBaseURI, string memory newUriSuffix) external onlyOwner {
1874         baseURI = newBaseURI;
1875         uriSuffix = newUriSuffix;
1876     }
1877 
1878     /// @notice Set saleState.
1879     /// @param newSaleState New sale state.
1880     function setSaleState(bool newSaleState) external onlyOwner {
1881         saleState = newSaleState;
1882     }
1883 
1884     /// @notice Set collectMarketing.
1885     /// @param newCollectMarketing New collect marketing flag.
1886     function setCollectMarketing(bool newCollectMarketing) external onlyOwner {
1887         collectMarketing = newCollectMarketing;
1888     }
1889 
1890     /// @notice Set maxByWallet.
1891     /// @param newMaxByWallet New max by wallet
1892     function setMaxByWallet(uint256 newMaxByWallet) external onlyOwner {
1893         maxByWallet = newMaxByWallet;
1894     }
1895 
1896     /******************** ALPHA MINT ********************/
1897 
1898     function alphaMint(address[] calldata addresses, uint256[] calldata count) external onlyOwner {
1899         require(!saleState, "sale is open!");
1900         require(addresses.length == count.length, "mismatching lengths!");
1901 
1902         for (uint256 i; i < addresses.length; i++) {
1903             _safeMint(addresses[i], count[i]);
1904         }
1905 
1906         require(_totalMinted() <= MAX_SUPPLY, "Exceed MAX_SUPPLY");
1907     }
1908 
1909     function withdraw() external onlyOwner {
1910         payable(owner()).transfer(address(this).balance);
1911     }
1912 }