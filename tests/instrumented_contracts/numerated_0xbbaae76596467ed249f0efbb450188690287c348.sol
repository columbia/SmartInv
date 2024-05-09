1 /** 
2 
3   /$$$$$$                  /$$                                      /$$$$$$        /$$$$$$$$         /$$ /$$
4  /$$__  $$                | $$                                     /$$__  $$      | $$_____/        |__/| $$
5 | $$  \__/  /$$$$$$   /$$$$$$$  /$$$$$$  /$$   /$$        /$$$$$$ | $$  \__/      | $$    /$$    /$$ /$$| $$
6 | $$       /$$__  $$ /$$__  $$ /$$__  $$|  $$ /$$/       /$$__  $$| $$$$          | $$$$$|  $$  /$$/| $$| $$
7 | $$      | $$  \ $$| $$  | $$| $$$$$$$$ \  $$$$/       | $$  \ $$| $$_/          | $$__/ \  $$/$$/ | $$| $$
8 | $$    $$| $$  | $$| $$  | $$| $$_____/  >$$  $$       | $$  | $$| $$            | $$     \  $$$/  | $$| $$
9 |  $$$$$$/|  $$$$$$/|  $$$$$$$|  $$$$$$$ /$$/\  $$      |  $$$$$$/| $$            | $$$$$$$$\  $/   | $$| $$
10  \______/  \______/  \_______/ \_______/|__/  \__/       \______/ |__/            |________/ \_/    |__/|__/
11                                                                                                             
12                                                                                                             
13                                                                                                             
14 
15                                                                                                                           
16 */
17 
18 /**
19  *Submitted for verification at Etherscan.io on
20 */
21 // SPDX-License-Identifier: MIT
22 // File: @openzeppelin/contracts/utils/Context.sol
23 
24 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev Provides information about the current execution context, including the
30  * sender of the transaction and its data. While these are generally available
31  * via msg.sender and msg.data, they should not be accessed in such a direct
32  * manner, since when dealing with meta-transactions the account sending and
33  * paying for execution may not be the actual sender (as far as an application
34  * is concerned).
35  *
36  * This contract is only required for intermediate, library-like contracts.
37  */
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address) {
40         return msg.sender;
41     }
42 
43     function _msgData() internal view virtual returns (bytes calldata) {
44         return msg.data;
45     }
46 }
47 
48 // File: @openzeppelin/contracts/access/Ownable.sol
49 
50 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Contract module which provides a basic access control mechanism, where
56  * there is an account (an owner) that can be granted exclusive access to
57  * specific functions.
58  *
59  * By default, the owner account will be the one that deploys the contract. This
60  * can later be changed with {transferOwnership}.
61  *
62  * This module is used through inheritance. It will make available the modifier
63  * `onlyOwner`, which can be applied to your functions to restrict their use to
64  * the owner.
65  */
66 abstract contract Ownable is Context {
67     address private _owner;
68 
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     /**
72      * @dev Initializes the contract setting the deployer as the initial owner.
73      */
74     constructor() {
75         _transferOwnership(_msgSender());
76     }
77 
78     /**
79      * @dev Returns the address of the current owner.
80      */
81     function owner() public view virtual returns (address) {
82         return _owner;
83     }
84 
85     /**
86      * @dev Throws if called by any account other than the owner.
87      */
88     modifier onlyOwner() {
89         require(owner() == _msgSender(), "Ownable: caller is not the owner");
90         _;
91     }
92 
93     /**
94      * @dev Leaves the contract without owner. It will not be possible to call
95      * `onlyOwner` functions anymore. Can only be called by the current owner.
96      *
97      * NOTE: Renouncing ownership will leave the contract without an owner,
98      * thereby removing any functionality that is only available to the owner.
99      */
100     function renounceOwnership() public virtual onlyOwner {
101         _transferOwnership(address(0));
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Can only be called by the current owner.
107      */
108     function transferOwnership(address newOwner) public virtual onlyOwner {
109         require(newOwner != address(0), "Ownable: new owner is the zero address");
110         _transferOwnership(newOwner);
111     }
112 
113     /**
114      * @dev Transfers ownership of the contract to a new account (`newOwner`).
115      * Internal function without access restriction.
116      */
117     function _transferOwnership(address newOwner) internal virtual {
118         address oldOwner = _owner;
119         _owner = newOwner;
120         emit OwnershipTransferred(oldOwner, newOwner);
121     }
122 }
123 
124 // File: erc721a/contracts/IERC721A.sol
125 
126 // ERC721A Contracts v4.0.0
127 // Creator: Chiru Labs
128 
129 pragma solidity ^0.8.4;
130 
131 /**
132  * @dev Interface of an ERC721A compliant contract.
133  */
134 interface IERC721A {
135     /**
136      * The caller must own the token or be an approved operator.
137      */
138     error ApprovalCallerNotOwnerNorApproved();
139 
140     /**
141      * The token does not exist.
142      */
143     error ApprovalQueryForNonexistentToken();
144 
145     /**
146      * The caller cannot approve to their own address.
147      */
148     error ApproveToCaller();
149 
150     /**
151      * The caller cannot approve to the current owner.
152      */
153     error ApprovalToCurrentOwner();
154 
155     /**
156      * Cannot query the balance for the zero address.
157      */
158     error BalanceQueryForZeroAddress();
159 
160     /**
161      * Cannot mint to the zero address.
162      */
163     error MintToZeroAddress();
164 
165     /**
166      * The quantity of tokens minted must be more than zero.
167      */
168     error MintZeroQuantity();
169 
170     /**
171      * The token does not exist.
172      */
173     error OwnerQueryForNonexistentToken();
174 
175     /**
176      * The caller must own the token or be an approved operator.
177      */
178     error TransferCallerNotOwnerNorApproved();
179 
180     /**
181      * The token must be owned by `from`.
182      */
183     error TransferFromIncorrectOwner();
184 
185     /**
186      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
187      */
188     error TransferToNonERC721ReceiverImplementer();
189 
190     /**
191      * Cannot transfer to the zero address.
192      */
193     error TransferToZeroAddress();
194 
195     /**
196      * The token does not exist.
197      */
198     error URIQueryForNonexistentToken();
199 
200     struct TokenOwnership {
201         // The address of the owner.
202         address addr;
203         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
204         uint64 startTimestamp;
205         // Whether the token has been burned.
206         bool burned;
207     }
208 
209     /**
210      * @dev Returns the total amount of tokens stored by the contract.
211      *
212      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
213      */
214     function totalSupply() external view returns (uint256);
215 
216     // ==============================
217     //            IERC165
218     // ==============================
219 
220     /**
221      * @dev Returns true if this contract implements the interface defined by
222      * `interfaceId`. See the corresponding
223      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
224      * to learn more about how these ids are created.
225      *
226      * This function call must use less than 30 000 gas.
227      */
228     function supportsInterface(bytes4 interfaceId) external view returns (bool);
229 
230     // ==============================
231     //            IERC721
232     // ==============================
233 
234     /**
235      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
236      */
237     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
238 
239     /**
240      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
241      */
242     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
243 
244     /**
245      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
246      */
247     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
248 
249     /**
250      * @dev Returns the number of tokens in ``owner``'s account.
251      */
252     function balanceOf(address owner) external view returns (uint256 balance);
253 
254     /**
255      * @dev Returns the owner of the `tokenId` token.
256      *
257      * Requirements:
258      *
259      * - `tokenId` must exist.
260      */
261     function ownerOf(uint256 tokenId) external view returns (address owner);
262 
263     /**
264      * @dev Safely transfers `tokenId` token from `from` to `to`.
265      *
266      * Requirements:
267      *
268      * - `from` cannot be the zero address.
269      * - `to` cannot be the zero address.
270      * - `tokenId` token must exist and be owned by `from`.
271      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
272      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
273      *
274      * Emits a {Transfer} event.
275      */
276     function safeTransferFrom(
277         address from,
278         address to,
279         uint256 tokenId,
280         bytes calldata data
281     ) external;
282 
283     /**
284      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
285      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
286      *
287      * Requirements:
288      *
289      * - `from` cannot be the zero address.
290      * - `to` cannot be the zero address.
291      * - `tokenId` token must exist and be owned by `from`.
292      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
293      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
294      *
295      * Emits a {Transfer} event.
296      */
297     function safeTransferFrom(
298         address from,
299         address to,
300         uint256 tokenId
301     ) external;
302 
303     /**
304      * @dev Transfers `tokenId` token from `from` to `to`.
305      *
306      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
307      *
308      * Requirements:
309      *
310      * - `from` cannot be the zero address.
311      * - `to` cannot be the zero address.
312      * - `tokenId` token must be owned by `from`.
313      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
314      *
315      * Emits a {Transfer} event.
316      */
317     function transferFrom(
318         address from,
319         address to,
320         uint256 tokenId
321     ) external;
322 
323     /**
324      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
325      * The approval is cleared when the token is transferred.
326      *
327      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
328      *
329      * Requirements:
330      *
331      * - The caller must own the token or be an approved operator.
332      * - `tokenId` must exist.
333      *
334      * Emits an {Approval} event.
335      */
336     function approve(address to, uint256 tokenId) external;
337 
338     /**
339      * @dev Approve or remove `operator` as an operator for the caller.
340      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
341      *
342      * Requirements:
343      *
344      * - The `operator` cannot be the caller.
345      *
346      * Emits an {ApprovalForAll} event.
347      */
348     function setApprovalForAll(address operator, bool _approved) external;
349 
350     /**
351      * @dev Returns the account approved for `tokenId` token.
352      *
353      * Requirements:
354      *
355      * - `tokenId` must exist.
356      */
357     function getApproved(uint256 tokenId) external view returns (address operator);
358 
359     /**
360      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
361      *
362      * See {setApprovalForAll}
363      */
364     function isApprovedForAll(address owner, address operator) external view returns (bool);
365 
366     // ==============================
367     //        IERC721Metadata
368     // ==============================
369 
370     /**
371      * @dev Returns the token collection name.
372      */
373     function name() external view returns (string memory);
374 
375     /**
376      * @dev Returns the token collection symbol.
377      */
378     function symbol() external view returns (string memory);
379 
380     /**
381      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
382      */
383     function tokenURI(uint256 tokenId) external view returns (string memory);
384 }
385 
386 // File: erc721a/contracts/ERC721A.sol
387 
388 // ERC721A Contracts v4.0.0
389 // Creator: Chiru Labs
390 
391 pragma solidity ^0.8.4;
392 
393 /**
394  * @dev ERC721 token receiver interface.
395  */
396 interface ERC721A__IERC721Receiver {
397     function onERC721Received(
398         address operator,
399         address from,
400         uint256 tokenId,
401         bytes calldata data
402     ) external returns (bytes4);
403 }
404 
405 /**
406  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
407  * the Metadata extension. Built to optimize for lower gas during batch mints.
408  *
409  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
410  *
411  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
412  *
413  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
414  */
415 contract ERC721A is IERC721A {
416     // Mask of an entry in packed address data.
417     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
418 
419     // The bit position of `numberMinted` in packed address data.
420     uint256 private constant BITPOS_NUMBER_MINTED = 64;
421 
422     // The bit position of `numberBurned` in packed address data.
423     uint256 private constant BITPOS_NUMBER_BURNED = 128;
424 
425     // The bit position of `aux` in packed address data.
426     uint256 private constant BITPOS_AUX = 192;
427 
428     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
429     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
430 
431     // The bit position of `startTimestamp` in packed ownership.
432     uint256 private constant BITPOS_START_TIMESTAMP = 160;
433 
434     // The bit mask of the `burned` bit in packed ownership.
435     uint256 private constant BITMASK_BURNED = 1 << 224;
436     
437     // The bit position of the `nextInitialized` bit in packed ownership.
438     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
439 
440     // The bit mask of the `nextInitialized` bit in packed ownership.
441     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
442 
443     // The tokenId of the next token to be minted.
444     uint256 private _currentIndex;
445 
446     // The number of tokens burned.
447     uint256 private _burnCounter;
448 
449     // Token name
450     string private _name;
451 
452     // Token symbol
453     string private _symbol;
454 
455     // Mapping from token ID to ownership details
456     // An empty struct value does not necessarily mean the token is unowned.
457     // See `_packedOwnershipOf` implementation for details.
458     //
459     // Bits Layout:
460     // - [0..159]   `addr`
461     // - [160..223] `startTimestamp`
462     // - [224]      `burned`
463     // - [225]      `nextInitialized`
464     mapping(uint256 => uint256) private _packedOwnerships;
465 
466     // Mapping owner address to address data.
467     //
468     // Bits Layout:
469     // - [0..63]    `balance`
470     // - [64..127]  `numberMinted`
471     // - [128..191] `numberBurned`
472     // - [192..255] `aux`
473     mapping(address => uint256) private _packedAddressData;
474 
475     // Mapping from token ID to approved address.
476     mapping(uint256 => address) private _tokenApprovals;
477 
478     // Mapping from owner to operator approvals
479     mapping(address => mapping(address => bool)) private _operatorApprovals;
480 
481     constructor(string memory name_, string memory symbol_) {
482         _name = name_;
483         _symbol = symbol_;
484         _currentIndex = _startTokenId();
485     }
486 
487     /**
488      * @dev Returns the starting token ID. 
489      * To change the starting token ID, please override this function.
490      */
491     function _startTokenId() internal view virtual returns (uint256) {
492         return 0;
493     }
494 
495     /**
496      * @dev Returns the next token ID to be minted.
497      */
498     function _nextTokenId() internal view returns (uint256) {
499         return _currentIndex;
500     }
501 
502     /**
503      * @dev Returns the total number of tokens in existence.
504      * Burned tokens will reduce the count. 
505      * To get the total number of tokens minted, please see `_totalMinted`.
506      */
507     function totalSupply() public view override returns (uint256) {
508         // Counter underflow is impossible as _burnCounter cannot be incremented
509         // more than `_currentIndex - _startTokenId()` times.
510         unchecked {
511             return _currentIndex - _burnCounter - _startTokenId();
512         }
513     }
514 
515     /**
516      * @dev Returns the total amount of tokens minted in the contract.
517      */
518     function _totalMinted() internal view returns (uint256) {
519         // Counter underflow is impossible as _currentIndex does not decrement,
520         // and it is initialized to `_startTokenId()`
521         unchecked {
522             return _currentIndex - _startTokenId();
523         }
524     }
525 
526     /**
527      * @dev Returns the total number of tokens burned.
528      */
529     function _totalBurned() internal view returns (uint256) {
530         return _burnCounter;
531     }
532 
533     /**
534      * @dev See {IERC165-supportsInterface}.
535      */
536     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
537         // The interface IDs are constants representing the first 4 bytes of the XOR of
538         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
539         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
540         return
541             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
542             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
543             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
544     }
545 
546     /**
547      * @dev See {IERC721-balanceOf}.
548      */
549     function balanceOf(address owner) public view override returns (uint256) {
550         if (owner == address(0)) revert BalanceQueryForZeroAddress();
551         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
552     }
553 
554     /**
555      * Returns the number of tokens minted by `owner`.
556      */
557     function _numberMinted(address owner) internal view returns (uint256) {
558         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
559     }
560 
561     /**
562      * Returns the number of tokens burned by or on behalf of `owner`.
563      */
564     function _numberBurned(address owner) internal view returns (uint256) {
565         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
566     }
567 
568     /**
569      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
570      */
571     function _getAux(address owner) internal view returns (uint64) {
572         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
573     }
574 
575     /**
576      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
577      * If there are multiple variables, please pack them into a uint64.
578      */
579     function _setAux(address owner, uint64 aux) internal {
580         uint256 packed = _packedAddressData[owner];
581         uint256 auxCasted;
582         assembly { // Cast aux without masking.
583             auxCasted := aux
584         }
585         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
586         _packedAddressData[owner] = packed;
587     }
588 
589     /**
590      * Returns the packed ownership data of `tokenId`.
591      */
592     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
593         uint256 curr = tokenId;
594 
595         unchecked {
596             if (_startTokenId() <= curr)
597                 if (curr < _currentIndex) {
598                     uint256 packed = _packedOwnerships[curr];
599                     // If not burned.
600                     if (packed & BITMASK_BURNED == 0) {
601                         // Invariant:
602                         // There will always be an ownership that has an address and is not burned
603                         // before an ownership that does not have an address and is not burned.
604                         // Hence, curr will not underflow.
605                         //
606                         // We can directly compare the packed value.
607                         // If the address is zero, packed is zero.
608                         while (packed == 0) {
609                             packed = _packedOwnerships[--curr];
610                         }
611                         return packed;
612                     }
613                 }
614         }
615         revert OwnerQueryForNonexistentToken();
616     }
617 
618     /**
619      * Returns the unpacked `TokenOwnership` struct from `packed`.
620      */
621     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
622         ownership.addr = address(uint160(packed));
623         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
624         ownership.burned = packed & BITMASK_BURNED != 0;
625     }
626 
627     /**
628      * Returns the unpacked `TokenOwnership` struct at `index`.
629      */
630     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
631         return _unpackedOwnership(_packedOwnerships[index]);
632     }
633 
634     /**
635      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
636      */
637     function _initializeOwnershipAt(uint256 index) internal {
638         if (_packedOwnerships[index] == 0) {
639             _packedOwnerships[index] = _packedOwnershipOf(index);
640         }
641     }
642 
643     /**
644      * Gas spent here starts off proportional to the maximum mint batch size.
645      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
646      */
647     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
648         return _unpackedOwnership(_packedOwnershipOf(tokenId));
649     }
650 
651     /**
652      * @dev See {IERC721-ownerOf}.
653      */
654     function ownerOf(uint256 tokenId) public view override returns (address) {
655         return address(uint160(_packedOwnershipOf(tokenId)));
656     }
657 
658     /**
659      * @dev See {IERC721Metadata-name}.
660      */
661     function name() public view virtual override returns (string memory) {
662         return _name;
663     }
664 
665     /**
666      * @dev See {IERC721Metadata-symbol}.
667      */
668     function symbol() public view virtual override returns (string memory) {
669         return _symbol;
670     }
671 
672     /**
673      * @dev See {IERC721Metadata-tokenURI}.
674      */
675     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
676         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
677 
678         string memory baseURI = _baseURI();
679         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
680     }
681 
682     /**
683      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
684      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
685      * by default, can be overriden in child contracts.
686      */
687     function _baseURI() internal view virtual returns (string memory) {
688         return '';
689     }
690 
691     /**
692      * @dev Casts the address to uint256 without masking.
693      */
694     function _addressToUint256(address value) private pure returns (uint256 result) {
695         assembly {
696             result := value
697         }
698     }
699 
700     /**
701      * @dev Casts the boolean to uint256 without branching.
702      */
703     function _boolToUint256(bool value) private pure returns (uint256 result) {
704         assembly {
705             result := value
706         }
707     }
708 
709     /**
710      * @dev See {IERC721-approve}.
711      */
712     function approve(address to, uint256 tokenId) public override {
713         address owner = address(uint160(_packedOwnershipOf(tokenId)));
714         if (to == owner) revert ApprovalToCurrentOwner();
715 
716         if (_msgSenderERC721A() != owner)
717             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
718                 revert ApprovalCallerNotOwnerNorApproved();
719             }
720 
721         _tokenApprovals[tokenId] = to;
722         emit Approval(owner, to, tokenId);
723     }
724 
725     /**
726      * @dev See {IERC721-getApproved}.
727      */
728     function getApproved(uint256 tokenId) public view override returns (address) {
729         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
730 
731         return _tokenApprovals[tokenId];
732     }
733 
734     /**
735      * @dev See {IERC721-setApprovalForAll}.
736      */
737     function setApprovalForAll(address operator, bool approved) public virtual override {
738         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
739 
740         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
741         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
742     }
743 
744     /**
745      * @dev See {IERC721-isApprovedForAll}.
746      */
747     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
748         return _operatorApprovals[owner][operator];
749     }
750 
751     /**
752      * @dev See {IERC721-transferFrom}.
753      */
754     function transferFrom(
755         address from,
756         address to,
757         uint256 tokenId
758     ) public virtual override {
759         _transfer(from, to, tokenId);
760     }
761 
762     /**
763      * @dev See {IERC721-safeTransferFrom}.
764      */
765     function safeTransferFrom(
766         address from,
767         address to,
768         uint256 tokenId
769     ) public virtual override {
770         safeTransferFrom(from, to, tokenId, '');
771     }
772 
773     /**
774      * @dev See {IERC721-safeTransferFrom}.
775      */
776     function safeTransferFrom(
777         address from,
778         address to,
779         uint256 tokenId,
780         bytes memory _data
781     ) public virtual override {
782         _transfer(from, to, tokenId);
783         if (to.code.length != 0)
784             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
785                 revert TransferToNonERC721ReceiverImplementer();
786             }
787     }
788 
789     /**
790      * @dev Returns whether `tokenId` exists.
791      *
792      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
793      *
794      * Tokens start existing when they are minted (`_mint`),
795      */
796     function _exists(uint256 tokenId) internal view returns (bool) {
797         return
798             _startTokenId() <= tokenId &&
799             tokenId < _currentIndex && // If within bounds,
800             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
801     }
802 
803     /**
804      * @dev Equivalent to `_safeMint(to, quantity, '')`.
805      */
806     function _safeMint(address to, uint256 quantity) internal {
807         _safeMint(to, quantity, '');
808     }
809 
810     /**
811      * @dev Safely mints `quantity` tokens and transfers them to `to`.
812      *
813      * Requirements:
814      *
815      * - If `to` refers to a smart contract, it must implement
816      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
817      * - `quantity` must be greater than 0.
818      *
819      * Emits a {Transfer} event.
820      */
821     function _safeMint(
822         address to,
823         uint256 quantity,
824         bytes memory _data
825     ) internal {
826         uint256 startTokenId = _currentIndex;
827         if (to == address(0)) revert MintToZeroAddress();
828         if (quantity == 0) revert MintZeroQuantity();
829 
830         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
831 
832         // Overflows are incredibly unrealistic.
833         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
834         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
835         unchecked {
836             // Updates:
837             // - `balance += quantity`.
838             // - `numberMinted += quantity`.
839             //
840             // We can directly add to the balance and number minted.
841             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
842 
843             // Updates:
844             // - `address` to the owner.
845             // - `startTimestamp` to the timestamp of minting.
846             // - `burned` to `false`.
847             // - `nextInitialized` to `quantity == 1`.
848             _packedOwnerships[startTokenId] =
849                 _addressToUint256(to) |
850                 (block.timestamp << BITPOS_START_TIMESTAMP) |
851                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
852 
853             uint256 updatedIndex = startTokenId;
854             uint256 end = updatedIndex + quantity;
855 
856             if (to.code.length != 0) {
857                 do {
858                     emit Transfer(address(0), to, updatedIndex);
859                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
860                         revert TransferToNonERC721ReceiverImplementer();
861                     }
862                 } while (updatedIndex < end);
863                 // Reentrancy protection
864                 if (_currentIndex != startTokenId) revert();
865             } else {
866                 do {
867                     emit Transfer(address(0), to, updatedIndex++);
868                 } while (updatedIndex < end);
869             }
870             _currentIndex = updatedIndex;
871         }
872         _afterTokenTransfers(address(0), to, startTokenId, quantity);
873     }
874 
875     /**
876      * @dev Mints `quantity` tokens and transfers them to `to`.
877      *
878      * Requirements:
879      *
880      * - `to` cannot be the zero address.
881      * - `quantity` must be greater than 0.
882      *
883      * Emits a {Transfer} event.
884      */
885     function _mint(address to, uint256 quantity) internal {
886         uint256 startTokenId = _currentIndex;
887         if (to == address(0)) revert MintToZeroAddress();
888         if (quantity == 0) revert MintZeroQuantity();
889 
890         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
891 
892         // Overflows are incredibly unrealistic.
893         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
894         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
895         unchecked {
896             // Updates:
897             // - `balance += quantity`.
898             // - `numberMinted += quantity`.
899             //
900             // We can directly add to the balance and number minted.
901             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
902 
903             // Updates:
904             // - `address` to the owner.
905             // - `startTimestamp` to the timestamp of minting.
906             // - `burned` to `false`.
907             // - `nextInitialized` to `quantity == 1`.
908             _packedOwnerships[startTokenId] =
909                 _addressToUint256(to) |
910                 (block.timestamp << BITPOS_START_TIMESTAMP) |
911                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
912 
913             uint256 updatedIndex = startTokenId;
914             uint256 end = updatedIndex + quantity;
915 
916             do {
917                 emit Transfer(address(0), to, updatedIndex++);
918             } while (updatedIndex < end);
919 
920             _currentIndex = updatedIndex;
921         }
922         _afterTokenTransfers(address(0), to, startTokenId, quantity);
923     }
924 
925     /**
926      * @dev Transfers `tokenId` from `from` to `to`.
927      *
928      * Requirements:
929      *
930      * - `to` cannot be the zero address.
931      * - `tokenId` token must be owned by `from`.
932      *
933      * Emits a {Transfer} event.
934      */
935     function _transfer(
936         address from,
937         address to,
938         uint256 tokenId
939     ) private {
940         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
941 
942         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
943 
944         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
945             isApprovedForAll(from, _msgSenderERC721A()) ||
946             getApproved(tokenId) == _msgSenderERC721A());
947 
948         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
949         if (to == address(0)) revert TransferToZeroAddress();
950 
951         _beforeTokenTransfers(from, to, tokenId, 1);
952 
953         // Clear approvals from the previous owner.
954         delete _tokenApprovals[tokenId];
955 
956         // Underflow of the sender's balance is impossible because we check for
957         // ownership above and the recipient's balance can't realistically overflow.
958         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
959         unchecked {
960             // We can directly increment and decrement the balances.
961             --_packedAddressData[from]; // Updates: `balance -= 1`.
962             ++_packedAddressData[to]; // Updates: `balance += 1`.
963 
964             // Updates:
965             // - `address` to the next owner.
966             // - `startTimestamp` to the timestamp of transfering.
967             // - `burned` to `false`.
968             // - `nextInitialized` to `true`.
969             _packedOwnerships[tokenId] =
970                 _addressToUint256(to) |
971                 (block.timestamp << BITPOS_START_TIMESTAMP) |
972                 BITMASK_NEXT_INITIALIZED;
973 
974             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
975             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
976                 uint256 nextTokenId = tokenId + 1;
977                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
978                 if (_packedOwnerships[nextTokenId] == 0) {
979                     // If the next slot is within bounds.
980                     if (nextTokenId != _currentIndex) {
981                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
982                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
983                     }
984                 }
985             }
986         }
987 
988         emit Transfer(from, to, tokenId);
989         _afterTokenTransfers(from, to, tokenId, 1);
990     }
991 
992     /**
993      * @dev Equivalent to `_burn(tokenId, false)`.
994      */
995     function _burn(uint256 tokenId) internal virtual {
996         _burn(tokenId, false);
997     }
998 
999     /**
1000      * @dev Destroys `tokenId`.
1001      * The approval is cleared when the token is burned.
1002      *
1003      * Requirements:
1004      *
1005      * - `tokenId` must exist.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1010         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1011 
1012         address from = address(uint160(prevOwnershipPacked));
1013 
1014         if (approvalCheck) {
1015             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1016                 isApprovedForAll(from, _msgSenderERC721A()) ||
1017                 getApproved(tokenId) == _msgSenderERC721A());
1018 
1019             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1020         }
1021 
1022         _beforeTokenTransfers(from, address(0), tokenId, 1);
1023 
1024         // Clear approvals from the previous owner.
1025         delete _tokenApprovals[tokenId];
1026 
1027         // Underflow of the sender's balance is impossible because we check for
1028         // ownership above and the recipient's balance can't realistically overflow.
1029         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1030         unchecked {
1031             // Updates:
1032             // - `balance -= 1`.
1033             // - `numberBurned += 1`.
1034             //
1035             // We can directly decrement the balance, and increment the number burned.
1036             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1037             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1038 
1039             // Updates:
1040             // - `address` to the last owner.
1041             // - `startTimestamp` to the timestamp of burning.
1042             // - `burned` to `true`.
1043             // - `nextInitialized` to `true`.
1044             _packedOwnerships[tokenId] =
1045                 _addressToUint256(from) |
1046                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1047                 BITMASK_BURNED | 
1048                 BITMASK_NEXT_INITIALIZED;
1049 
1050             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1051             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1052                 uint256 nextTokenId = tokenId + 1;
1053                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1054                 if (_packedOwnerships[nextTokenId] == 0) {
1055                     // If the next slot is within bounds.
1056                     if (nextTokenId != _currentIndex) {
1057                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1058                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1059                     }
1060                 }
1061             }
1062         }
1063 
1064         emit Transfer(from, address(0), tokenId);
1065         _afterTokenTransfers(from, address(0), tokenId, 1);
1066 
1067         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1068         unchecked {
1069             _burnCounter++;
1070         }
1071     }
1072 
1073     /**
1074      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1075      *
1076      * @param from address representing the previous owner of the given token ID
1077      * @param to target address that will receive the tokens
1078      * @param tokenId uint256 ID of the token to be transferred
1079      * @param _data bytes optional data to send along with the call
1080      * @return bool whether the call correctly returned the expected magic value
1081      */
1082     function _checkContractOnERC721Received(
1083         address from,
1084         address to,
1085         uint256 tokenId,
1086         bytes memory _data
1087     ) private returns (bool) {
1088         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1089             bytes4 retval
1090         ) {
1091             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1092         } catch (bytes memory reason) {
1093             if (reason.length == 0) {
1094                 revert TransferToNonERC721ReceiverImplementer();
1095             } else {
1096                 assembly {
1097                     revert(add(32, reason), mload(reason))
1098                 }
1099             }
1100         }
1101     }
1102 
1103     /**
1104      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1105      * And also called before burning one token.
1106      *
1107      * startTokenId - the first token id to be transferred
1108      * quantity - the amount to be transferred
1109      *
1110      * Calling conditions:
1111      *
1112      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1113      * transferred to `to`.
1114      * - When `from` is zero, `tokenId` will be minted for `to`.
1115      * - When `to` is zero, `tokenId` will be burned by `from`.
1116      * - `from` and `to` are never both zero.
1117      */
1118     function _beforeTokenTransfers(
1119         address from,
1120         address to,
1121         uint256 startTokenId,
1122         uint256 quantity
1123     ) internal virtual {}
1124 
1125     /**
1126      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1127      * minting.
1128      * And also called after one token has been burned.
1129      *
1130      * startTokenId - the first token id to be transferred
1131      * quantity - the amount to be transferred
1132      *
1133      * Calling conditions:
1134      *
1135      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1136      * transferred to `to`.
1137      * - When `from` is zero, `tokenId` has been minted for `to`.
1138      * - When `to` is zero, `tokenId` has been burned by `from`.
1139      * - `from` and `to` are never both zero.
1140      */
1141     function _afterTokenTransfers(
1142         address from,
1143         address to,
1144         uint256 startTokenId,
1145         uint256 quantity
1146     ) internal virtual {}
1147 
1148     /**
1149      * @dev Returns the message sender (defaults to `msg.sender`).
1150      *
1151      * If you are writing GSN compatible contracts, you need to override this function.
1152      */
1153     function _msgSenderERC721A() internal view virtual returns (address) {
1154         return msg.sender;
1155     }
1156 
1157     /**
1158      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1159      */
1160     function _toString(uint256 value) internal pure returns (string memory ptr) {
1161         assembly {
1162             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1163             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1164             // We will need 1 32-byte word to store the length, 
1165             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1166             ptr := add(mload(0x40), 128)
1167             // Update the free memory pointer to allocate.
1168             mstore(0x40, ptr)
1169 
1170             // Cache the end of the memory to calculate the length later.
1171             let end := ptr
1172 
1173             // We write the string from the rightmost digit to the leftmost digit.
1174             // The following is essentially a do-while loop that also handles the zero case.
1175             // Costs a bit more than early returning for the zero case,
1176             // but cheaper in terms of deployment and overall runtime costs.
1177             for { 
1178                 // Initialize and perform the first pass without check.
1179                 let temp := value
1180                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1181                 ptr := sub(ptr, 1)
1182                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1183                 mstore8(ptr, add(48, mod(temp, 10)))
1184                 temp := div(temp, 10)
1185             } temp { 
1186                 // Keep dividing `temp` until zero.
1187                 temp := div(temp, 10)
1188             } { // Body of the for loop.
1189                 ptr := sub(ptr, 1)
1190                 mstore8(ptr, add(48, mod(temp, 10)))
1191             }
1192             
1193             let length := sub(end, ptr)
1194             // Move the pointer 32 bytes leftwards to make room for the length.
1195             ptr := sub(ptr, 32)
1196             // Store the length.
1197             mstore(ptr, length)
1198         }
1199     }
1200 }
1201 
1202 // File: nft.sol
1203 
1204 
1205 pragma solidity ^0.8.7;
1206 
1207 
1208 contract CodexofEvil is Ownable, ERC721A {
1209     uint256 public maxSupply                    = 3256;
1210     uint256 public maxFreeSupply                = 1000;
1211     
1212     uint256 public maxPerTxDuringMint           = 10;
1213     uint256 public maxPerAddressDuringMint      = 50;
1214     uint256 public maxPerAddressDuringFreeMint  = 5;
1215     
1216     uint256 public price                        = 0.003 ether;
1217     bool    public saleIsActive                 = true;
1218 
1219     address constant internal TEAM_ADDRESS = 0xd9a109539AC32dFcA1ef834A5682706C5b059487;
1220 
1221     string private _baseTokenURI="ipfs://QmeEZuCTiaP514ucjX5D21e8tDv67e4Yt5jyGffcMsAfJ3/";
1222 
1223     mapping(address => uint256) public freeMintedAmount;
1224     mapping(address => uint256) public mintedAmount;
1225 
1226     constructor() ERC721A("Codex of Evil", "Codex of Evil") {
1227         _safeMint(msg.sender, 50);
1228     }
1229 
1230     modifier mintCompliance() {
1231         require(saleIsActive, "Sale is not active yet.");
1232         require(tx.origin == msg.sender, "Caller cannot be a contract.");
1233         _;
1234     }
1235 
1236     function mint(uint256 _quantity) external payable mintCompliance() {
1237         require(
1238             msg.value >= price * _quantity,
1239             "GDZ: Insufficient Fund."
1240         );
1241         require(
1242             maxSupply >= totalSupply() + _quantity,
1243             "GDZ: Exceeds max supply."
1244         );
1245         uint256 _mintedAmount = mintedAmount[msg.sender];
1246         require(
1247             _mintedAmount + _quantity <= maxPerAddressDuringMint,
1248             "GDZ: Exceeds max mints per address!"
1249         );
1250         require(
1251             _quantity > 0 && _quantity <= maxPerTxDuringMint,
1252             "Invalid mint amount."
1253         );
1254         mintedAmount[msg.sender] = _mintedAmount + _quantity;
1255         _safeMint(msg.sender, _quantity);
1256     }
1257 
1258     function freeMint(uint256 _quantity) external mintCompliance() {
1259         require(
1260             maxFreeSupply >= totalSupply() + _quantity,
1261             "GDZ: Exceeds max free supply."
1262         );
1263         uint256 _freeMintedAmount = freeMintedAmount[msg.sender];
1264         require(
1265             _freeMintedAmount + _quantity <= maxPerAddressDuringFreeMint,
1266             "GDZ: Exceeds max free mints per address!"
1267         );
1268         freeMintedAmount[msg.sender] = _freeMintedAmount + _quantity;
1269         _safeMint(msg.sender, _quantity);
1270     }
1271 
1272     function setPrice(uint256 _price) external onlyOwner {
1273         price = _price;
1274     }
1275 
1276     function setMaxPerTx(uint256 _amount) external onlyOwner {
1277         maxPerTxDuringMint = _amount;
1278     }
1279 
1280     function setMaxPerAddress(uint256 _amount) external onlyOwner {
1281         maxPerAddressDuringMint = _amount;
1282     }
1283 
1284     function setMaxFreePerAddress(uint256 _amount) external onlyOwner {
1285         maxPerAddressDuringFreeMint = _amount;
1286     }
1287 
1288     function flipSale() public onlyOwner {
1289         saleIsActive = !saleIsActive;
1290     }
1291 
1292     function cutMaxSupply(uint256 _amount) public onlyOwner {
1293         require(
1294             maxSupply - _amount >= totalSupply(), 
1295             "Supply cannot fall below minted tokens."
1296         );
1297         maxSupply -= _amount;
1298     }
1299 
1300     function setBaseURI(string calldata baseURI) external onlyOwner {
1301         _baseTokenURI = baseURI;
1302     }
1303 
1304     function _baseURI() internal view virtual override returns (string memory) {
1305         return _baseTokenURI;
1306     }
1307 
1308     function withdrawBalance() external payable onlyOwner {
1309 
1310         (bool success, ) = payable(TEAM_ADDRESS).call{
1311             value: address(this).balance
1312         }("");
1313         require(success, "transfer failed.");
1314     }
1315 }