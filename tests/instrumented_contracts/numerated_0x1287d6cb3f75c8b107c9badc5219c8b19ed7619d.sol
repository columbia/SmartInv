1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 }
67 
68 
69 // File: @openzeppelin/contracts/utils/Context.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Provides information about the current execution context, including the
78  * sender of the transaction and its data. While these are generally available
79  * via msg.sender and msg.data, they should not be accessed in such a direct
80  * manner, since when dealing with meta-transactions the account sending and
81  * paying for execution may not be the actual sender (as far as an application
82  * is concerned).
83  *
84  * This contract is only required for intermediate, library-like contracts.
85  */
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view virtual returns (bytes calldata) {
92         return msg.data;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/security/Pausable.sol
97 
98 
99 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 
104 /**
105  * @dev Contract module which allows children to implement an emergency stop
106  * mechanism that can be triggered by an authorized account.
107  *
108  * This module is used through inheritance. It will make available the
109  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
110  * the functions of your contract. Note that they will not be pausable by
111  * simply including this module, only once the modifiers are put in place.
112  */
113 abstract contract Pausable is Context {
114     /**
115      * @dev Emitted when the pause is triggered by `account`.
116      */
117     event Paused(address account);
118 
119     /**
120      * @dev Emitted when the pause is lifted by `account`.
121      */
122     event Unpaused(address account);
123 
124     bool private _paused;
125 
126     /**
127      * @dev Initializes the contract in unpaused state.
128      */
129     constructor() {
130         _paused = false;
131     }
132 
133     /**
134      * @dev Returns true if the contract is paused, and false otherwise.
135      */
136     function paused() public view virtual returns (bool) {
137         return _paused;
138     }
139 
140     /**
141      * @dev Modifier to make a function callable only when the contract is not paused.
142      *
143      * Requirements:
144      *
145      * - The contract must not be paused.
146      */
147     modifier whenNotPaused() {
148         require(!paused(), "Pausable: paused");
149         _;
150     }
151 
152     /**
153      * @dev Modifier to make a function callable only when the contract is paused.
154      *
155      * Requirements:
156      *
157      * - The contract must be paused.
158      */
159     modifier whenPaused() {
160         require(paused(), "Pausable: not paused");
161         _;
162     }
163 
164     /**
165      * @dev Triggers stopped state.
166      *
167      * Requirements:
168      *
169      * - The contract must not be paused.
170      */
171     function _pause() internal virtual whenNotPaused {
172         _paused = true;
173         emit Paused(_msgSender());
174     }
175 
176     /**
177      * @dev Returns to normal state.
178      *
179      * Requirements:
180      *
181      * - The contract must be paused.
182      */
183     function _unpause() internal virtual whenPaused {
184         _paused = false;
185         emit Unpaused(_msgSender());
186     }
187 }
188 
189 // File: @openzeppelin/contracts/access/Ownable.sol
190 
191 
192 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
193 
194 pragma solidity ^0.8.0;
195 
196 
197 /**
198  * @dev Contract module which provides a basic access control mechanism, where
199  * there is an account (an owner) that can be granted exclusive access to
200  * specific functions.
201  *
202  * By default, the owner account will be the one that deploys the contract. This
203  * can later be changed with {transferOwnership}.
204  *
205  * This module is used through inheritance. It will make available the modifier
206  * `onlyOwner`, which can be applied to your functions to restrict their use to
207  * the owner.
208  */
209 abstract contract Ownable is Context {
210     address private _owner;
211 
212     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
213 
214     /**
215      * @dev Initializes the contract setting the deployer as the initial owner.
216      */
217     constructor() {
218         _transferOwnership(_msgSender());
219     }
220 
221     /**
222      * @dev Returns the address of the current owner.
223      */
224     function owner() public view virtual returns (address) {
225         return _owner;
226     }
227 
228     /**
229      * @dev Throws if called by any account other than the owner.
230      */
231     modifier onlyOwner() {
232         require(owner() == _msgSender(), "Ownable: caller is not the owner");
233         _;
234     }
235 
236     /**
237      * @dev Leaves the contract without owner. It will not be possible to call
238      * `onlyOwner` functions anymore. Can only be called by the current owner.
239      *
240      * NOTE: Renouncing ownership will leave the contract without an owner,
241      * thereby removing any functionality that is only available to the owner.
242      */
243     function renounceOwnership() public virtual onlyOwner {
244         _transferOwnership(address(0));
245     }
246 
247     /**
248      * @dev Transfers ownership of the contract to a new account (`newOwner`).
249      * Can only be called by the current owner.
250      */
251     function transferOwnership(address newOwner) public virtual onlyOwner {
252         require(newOwner != address(0), "Ownable: new owner is the zero address");
253         _transferOwnership(newOwner);
254     }
255 
256     /**
257      * @dev Transfers ownership of the contract to a new account (`newOwner`).
258      * Internal function without access restriction.
259      */
260     function _transferOwnership(address newOwner) internal virtual {
261         address oldOwner = _owner;
262         _owner = newOwner;
263         emit OwnershipTransferred(oldOwner, newOwner);
264     }
265 }
266 
267 // File: erc721a/contracts/IERC721A.sol
268 
269 
270 // ERC721A Contracts v4.0.0
271 // Creator: Chiru Labs
272 
273 pragma solidity ^0.8.4;
274 
275 /**
276  * @dev Interface of an ERC721A compliant contract.
277  */
278 interface IERC721A {
279     /**
280      * The caller must own the token or be an approved operator.
281      */
282     error ApprovalCallerNotOwnerNorApproved();
283 
284     /**
285      * The token does not exist.
286      */
287     error ApprovalQueryForNonexistentToken();
288 
289     /**
290      * The caller cannot approve to their own address.
291      */
292     error ApproveToCaller();
293 
294     /**
295      * The caller cannot approve to the current owner.
296      */
297     error ApprovalToCurrentOwner();
298 
299     /**
300      * Cannot query the balance for the zero address.
301      */
302     error BalanceQueryForZeroAddress();
303 
304     /**
305      * Cannot mint to the zero address.
306      */
307     error MintToZeroAddress();
308 
309     /**
310      * The quantity of tokens minted must be more than zero.
311      */
312     error MintZeroQuantity();
313 
314     /**
315      * The token does not exist.
316      */
317     error OwnerQueryForNonexistentToken();
318 
319     /**
320      * The caller must own the token or be an approved operator.
321      */
322     error TransferCallerNotOwnerNorApproved();
323 
324     /**
325      * The token must be owned by `from`.
326      */
327     error TransferFromIncorrectOwner();
328 
329     /**
330      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
331      */
332     error TransferToNonERC721ReceiverImplementer();
333 
334     /**
335      * Cannot transfer to the zero address.
336      */
337     error TransferToZeroAddress();
338 
339     /**
340      * The token does not exist.
341      */
342     error URIQueryForNonexistentToken();
343 
344     struct TokenOwnership {
345         // The address of the owner.
346         address addr;
347         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
348         uint64 startTimestamp;
349         // Whether the token has been burned.
350         bool burned;
351     }
352 
353     /**
354      * @dev Returns the total amount of tokens stored by the contract.
355      *
356      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
357      */
358     function totalSupply() external view returns (uint256);
359 
360     // ==============================
361     //            IERC165
362     // ==============================
363 
364     /**
365      * @dev Returns true if this contract implements the interface defined by
366      * `interfaceId`. See the corresponding
367      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
368      * to learn more about how these ids are created.
369      *
370      * This function call must use less than 30 000 gas.
371      */
372     function supportsInterface(bytes4 interfaceId) external view returns (bool);
373 
374     // ==============================
375     //            IERC721
376     // ==============================
377 
378     /**
379      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
380      */
381     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
382 
383     /**
384      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
385      */
386     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
387 
388     /**
389      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
390      */
391     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
392 
393     /**
394      * @dev Returns the number of tokens in ``owner``'s account.
395      */
396     function balanceOf(address owner) external view returns (uint256 balance);
397 
398     /**
399      * @dev Returns the owner of the `tokenId` token.
400      *
401      * Requirements:
402      *
403      * - `tokenId` must exist.
404      */
405     function ownerOf(uint256 tokenId) external view returns (address owner);
406 
407     /**
408      * @dev Safely transfers `tokenId` token from `from` to `to`.
409      *
410      * Requirements:
411      *
412      * - `from` cannot be the zero address.
413      * - `to` cannot be the zero address.
414      * - `tokenId` token must exist and be owned by `from`.
415      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
416      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
417      *
418      * Emits a {Transfer} event.
419      */
420     function safeTransferFrom(
421         address from,
422         address to,
423         uint256 tokenId,
424         bytes calldata data
425     ) external;
426 
427     /**
428      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
429      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
430      *
431      * Requirements:
432      *
433      * - `from` cannot be the zero address.
434      * - `to` cannot be the zero address.
435      * - `tokenId` token must exist and be owned by `from`.
436      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
437      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
438      *
439      * Emits a {Transfer} event.
440      */
441     function safeTransferFrom(
442         address from,
443         address to,
444         uint256 tokenId
445     ) external;
446 
447     /**
448      * @dev Transfers `tokenId` token from `from` to `to`.
449      *
450      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
451      *
452      * Requirements:
453      *
454      * - `from` cannot be the zero address.
455      * - `to` cannot be the zero address.
456      * - `tokenId` token must be owned by `from`.
457      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
458      *
459      * Emits a {Transfer} event.
460      */
461     function transferFrom(
462         address from,
463         address to,
464         uint256 tokenId
465     ) external;
466 
467     /**
468      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
469      * The approval is cleared when the token is transferred.
470      *
471      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
472      *
473      * Requirements:
474      *
475      * - The caller must own the token or be an approved operator.
476      * - `tokenId` must exist.
477      *
478      * Emits an {Approval} event.
479      */
480     function approve(address to, uint256 tokenId) external;
481 
482     /**
483      * @dev Approve or remove `operator` as an operator for the caller.
484      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
485      *
486      * Requirements:
487      *
488      * - The `operator` cannot be the caller.
489      *
490      * Emits an {ApprovalForAll} event.
491      */
492     function setApprovalForAll(address operator, bool _approved) external;
493 
494     /**
495      * @dev Returns the account approved for `tokenId` token.
496      *
497      * Requirements:
498      *
499      * - `tokenId` must exist.
500      */
501     function getApproved(uint256 tokenId) external view returns (address operator);
502 
503     /**
504      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
505      *
506      * See {setApprovalForAll}
507      */
508     function isApprovedForAll(address owner, address operator) external view returns (bool);
509 
510     // ==============================
511     //        IERC721Metadata
512     // ==============================
513 
514     /**
515      * @dev Returns the token collection name.
516      */
517     function name() external view returns (string memory);
518 
519     /**
520      * @dev Returns the token collection symbol.
521      */
522     function symbol() external view returns (string memory);
523 
524     /**
525      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
526      */
527     function tokenURI(uint256 tokenId) external view returns (string memory);
528 }
529 
530 // File: erc721a/contracts/ERC721A.sol
531 
532 
533 // ERC721A Contracts v4.0.0
534 // Creator: Chiru Labs
535 
536 pragma solidity ^0.8.4;
537 
538 
539 /**
540  * @dev ERC721 token receiver interface.
541  */
542 interface ERC721A__IERC721Receiver {
543     function onERC721Received(
544         address operator,
545         address from,
546         uint256 tokenId,
547         bytes calldata data
548     ) external returns (bytes4);
549 }
550 
551 /**
552  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
553  * the Metadata extension. Built to optimize for lower gas during batch mints.
554  *
555  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
556  *
557  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
558  *
559  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
560  */
561 contract ERC721A is IERC721A {
562     // Mask of an entry in packed address data.
563     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
564 
565     // The bit position of `numberMinted` in packed address data.
566     uint256 private constant BITPOS_NUMBER_MINTED = 64;
567 
568     // The bit position of `numberBurned` in packed address data.
569     uint256 private constant BITPOS_NUMBER_BURNED = 128;
570 
571     // The bit position of `aux` in packed address data.
572     uint256 private constant BITPOS_AUX = 192;
573 
574     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
575     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
576 
577     // The bit position of `startTimestamp` in packed ownership.
578     uint256 private constant BITPOS_START_TIMESTAMP = 160;
579 
580     // The bit mask of the `burned` bit in packed ownership.
581     uint256 private constant BITMASK_BURNED = 1 << 224;
582     
583     // The bit position of the `nextInitialized` bit in packed ownership.
584     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
585 
586     // The bit mask of the `nextInitialized` bit in packed ownership.
587     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
588 
589     // The tokenId of the next token to be minted.
590     uint256 private _currentIndex;
591 
592     // The number of tokens burned.
593     uint256 private _burnCounter;
594 
595     // Token name
596     string private _name;
597 
598     // Token symbol
599     string private _symbol;
600 
601     // Mapping from token ID to ownership details
602     // An empty struct value does not necessarily mean the token is unowned.
603     // See `_packedOwnershipOf` implementation for details.
604     //
605     // Bits Layout:
606     // - [0..159]   `addr`
607     // - [160..223] `startTimestamp`
608     // - [224]      `burned`
609     // - [225]      `nextInitialized`
610     mapping(uint256 => uint256) private _packedOwnerships;
611 
612     // Mapping owner address to address data.
613     //
614     // Bits Layout:
615     // - [0..63]    `balance`
616     // - [64..127]  `numberMinted`
617     // - [128..191] `numberBurned`
618     // - [192..255] `aux`
619     mapping(address => uint256) private _packedAddressData;
620 
621     // Mapping from token ID to approved address.
622     mapping(uint256 => address) private _tokenApprovals;
623 
624     // Mapping from owner to operator approvals
625     mapping(address => mapping(address => bool)) private _operatorApprovals;
626 
627     constructor(string memory name_, string memory symbol_) {
628         _name = name_;
629         _symbol = symbol_;
630         _currentIndex = _startTokenId();
631     }
632 
633     /**
634      * @dev Returns the starting token ID. 
635      * To change the starting token ID, please override this function.
636      */
637     function _startTokenId() internal view virtual returns (uint256) {
638         return 0;
639     }
640 
641     /**
642      * @dev Returns the next token ID to be minted.
643      */
644     function _nextTokenId() internal view returns (uint256) {
645         return _currentIndex;
646     }
647 
648     /**
649      * @dev Returns the total number of tokens in existence.
650      * Burned tokens will reduce the count. 
651      * To get the total number of tokens minted, please see `_totalMinted`.
652      */
653     function totalSupply() public view override returns (uint256) {
654         // Counter underflow is impossible as _burnCounter cannot be incremented
655         // more than `_currentIndex - _startTokenId()` times.
656         unchecked {
657             return _currentIndex - _burnCounter - _startTokenId();
658         }
659     }
660 
661     /**
662      * @dev Returns the total amount of tokens minted in the contract.
663      */
664     function _totalMinted() internal view returns (uint256) {
665         // Counter underflow is impossible as _currentIndex does not decrement,
666         // and it is initialized to `_startTokenId()`
667         unchecked {
668             return _currentIndex - _startTokenId();
669         }
670     }
671 
672     /**
673      * @dev Returns the total number of tokens burned.
674      */
675     function _totalBurned() internal view returns (uint256) {
676         return _burnCounter;
677     }
678 
679     /**
680      * @dev See {IERC165-supportsInterface}.
681      */
682     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
683         // The interface IDs are constants representing the first 4 bytes of the XOR of
684         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
685         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
686         return
687             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
688             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
689             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
690     }
691 
692     /**
693      * @dev See {IERC721-balanceOf}.
694      */
695     function balanceOf(address owner) public view override returns (uint256) {
696         if (owner == address(0)) revert BalanceQueryForZeroAddress();
697         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
698     }
699 
700     /**
701      * Returns the number of tokens minted by `owner`.
702      */
703     function _numberMinted(address owner) internal view returns (uint256) {
704         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
705     }
706 
707     /**
708      * Returns the number of tokens burned by or on behalf of `owner`.
709      */
710     function _numberBurned(address owner) internal view returns (uint256) {
711         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
712     }
713 
714     /**
715      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
716      */
717     function _getAux(address owner) internal view returns (uint64) {
718         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
719     }
720 
721     /**
722      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
723      * If there are multiple variables, please pack them into a uint64.
724      */
725     function _setAux(address owner, uint64 aux) internal {
726         uint256 packed = _packedAddressData[owner];
727         uint256 auxCasted;
728         assembly { // Cast aux without masking.
729             auxCasted := aux
730         }
731         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
732         _packedAddressData[owner] = packed;
733     }
734 
735     /**
736      * Returns the packed ownership data of `tokenId`.
737      */
738     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
739         uint256 curr = tokenId;
740 
741         unchecked {
742             if (_startTokenId() <= curr)
743                 if (curr < _currentIndex) {
744                     uint256 packed = _packedOwnerships[curr];
745                     // If not burned.
746                     if (packed & BITMASK_BURNED == 0) {
747                         // Invariant:
748                         // There will always be an ownership that has an address and is not burned
749                         // before an ownership that does not have an address and is not burned.
750                         // Hence, curr will not underflow.
751                         //
752                         // We can directly compare the packed value.
753                         // If the address is zero, packed is zero.
754                         while (packed == 0) {
755                             packed = _packedOwnerships[--curr];
756                         }
757                         return packed;
758                     }
759                 }
760         }
761         revert OwnerQueryForNonexistentToken();
762     }
763 
764     /**
765      * Returns the unpacked `TokenOwnership` struct from `packed`.
766      */
767     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
768         ownership.addr = address(uint160(packed));
769         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
770         ownership.burned = packed & BITMASK_BURNED != 0;
771     }
772 
773     /**
774      * Returns the unpacked `TokenOwnership` struct at `index`.
775      */
776     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
777         return _unpackedOwnership(_packedOwnerships[index]);
778     }
779 
780     /**
781      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
782      */
783     function _initializeOwnershipAt(uint256 index) internal {
784         if (_packedOwnerships[index] == 0) {
785             _packedOwnerships[index] = _packedOwnershipOf(index);
786         }
787     }
788 
789     /**
790      * Gas spent here starts off proportional to the maximum mint batch size.
791      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
792      */
793     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
794         return _unpackedOwnership(_packedOwnershipOf(tokenId));
795     }
796 
797     /**
798      * @dev See {IERC721-ownerOf}.
799      */
800     function ownerOf(uint256 tokenId) public view override returns (address) {
801         return address(uint160(_packedOwnershipOf(tokenId)));
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-name}.
806      */
807     function name() public view virtual override returns (string memory) {
808         return _name;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-symbol}.
813      */
814     function symbol() public view virtual override returns (string memory) {
815         return _symbol;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-tokenURI}.
820      */
821     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
822         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
823 
824         string memory baseURI = _baseURI();
825         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
826     }
827 
828     /**
829      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
830      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
831      * by default, can be overriden in child contracts.
832      */
833     function _baseURI() internal view virtual returns (string memory) {
834         return '';
835     }
836 
837     /**
838      * @dev Casts the address to uint256 without masking.
839      */
840     function _addressToUint256(address value) private pure returns (uint256 result) {
841         assembly {
842             result := value
843         }
844     }
845 
846     /**
847      * @dev Casts the boolean to uint256 without branching.
848      */
849     function _boolToUint256(bool value) private pure returns (uint256 result) {
850         assembly {
851             result := value
852         }
853     }
854 
855     /**
856      * @dev See {IERC721-approve}.
857      */
858     function approve(address to, uint256 tokenId) public override {
859         address owner = address(uint160(_packedOwnershipOf(tokenId)));
860         if (to == owner) revert ApprovalToCurrentOwner();
861 
862         if (_msgSenderERC721A() != owner)
863             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
864                 revert ApprovalCallerNotOwnerNorApproved();
865             }
866 
867         _tokenApprovals[tokenId] = to;
868         emit Approval(owner, to, tokenId);
869     }
870 
871     /**
872      * @dev See {IERC721-getApproved}.
873      */
874     function getApproved(uint256 tokenId) public view override returns (address) {
875         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
876 
877         return _tokenApprovals[tokenId];
878     }
879 
880     /**
881      * @dev See {IERC721-setApprovalForAll}.
882      */
883     function setApprovalForAll(address operator, bool approved) public virtual override {
884         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
885 
886         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
887         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
888     }
889 
890     /**
891      * @dev See {IERC721-isApprovedForAll}.
892      */
893     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
894         return _operatorApprovals[owner][operator];
895     }
896 
897     /**
898      * @dev See {IERC721-transferFrom}.
899      */
900     function transferFrom(
901         address from,
902         address to,
903         uint256 tokenId
904     ) public virtual override {
905         _transfer(from, to, tokenId);
906     }
907 
908     /**
909      * @dev See {IERC721-safeTransferFrom}.
910      */
911     function safeTransferFrom(
912         address from,
913         address to,
914         uint256 tokenId
915     ) public virtual override {
916         safeTransferFrom(from, to, tokenId, '');
917     }
918 
919     /**
920      * @dev See {IERC721-safeTransferFrom}.
921      */
922     function safeTransferFrom(
923         address from,
924         address to,
925         uint256 tokenId,
926         bytes memory _data
927     ) public virtual override {
928         _transfer(from, to, tokenId);
929         if (to.code.length != 0)
930             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
931                 revert TransferToNonERC721ReceiverImplementer();
932             }
933     }
934 
935     /**
936      * @dev Returns whether `tokenId` exists.
937      *
938      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
939      *
940      * Tokens start existing when they are minted (`_mint`),
941      */
942     function _exists(uint256 tokenId) internal view returns (bool) {
943         return
944             _startTokenId() <= tokenId &&
945             tokenId < _currentIndex && // If within bounds,
946             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
947     }
948 
949     /**
950      * @dev Equivalent to `_safeMint(to, quantity, '')`.
951      */
952     function _safeMint(address to, uint256 quantity) internal {
953         _safeMint(to, quantity, '');
954     }
955 
956     /**
957      * @dev Safely mints `quantity` tokens and transfers them to `to`.
958      *
959      * Requirements:
960      *
961      * - If `to` refers to a smart contract, it must implement
962      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
963      * - `quantity` must be greater than 0.
964      *
965      * Emits a {Transfer} event.
966      */
967     function _safeMint(
968         address to,
969         uint256 quantity,
970         bytes memory _data
971     ) internal {
972         uint256 startTokenId = _currentIndex;
973         if (to == address(0)) revert MintToZeroAddress();
974         if (quantity == 0) revert MintZeroQuantity();
975 
976         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
977 
978         // Overflows are incredibly unrealistic.
979         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
980         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
981         unchecked {
982             // Updates:
983             // - `balance += quantity`.
984             // - `numberMinted += quantity`.
985             //
986             // We can directly add to the balance and number minted.
987             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
988 
989             // Updates:
990             // - `address` to the owner.
991             // - `startTimestamp` to the timestamp of minting.
992             // - `burned` to `false`.
993             // - `nextInitialized` to `quantity == 1`.
994             _packedOwnerships[startTokenId] =
995                 _addressToUint256(to) |
996                 (block.timestamp << BITPOS_START_TIMESTAMP) |
997                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
998 
999             uint256 updatedIndex = startTokenId;
1000             uint256 end = updatedIndex + quantity;
1001 
1002             if (to.code.length != 0) {
1003                 do {
1004                     emit Transfer(address(0), to, updatedIndex);
1005                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1006                         revert TransferToNonERC721ReceiverImplementer();
1007                     }
1008                 } while (updatedIndex < end);
1009                 // Reentrancy protection
1010                 if (_currentIndex != startTokenId) revert();
1011             } else {
1012                 do {
1013                     emit Transfer(address(0), to, updatedIndex++);
1014                 } while (updatedIndex < end);
1015             }
1016             _currentIndex = updatedIndex;
1017         }
1018         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1019     }
1020 
1021     /**
1022      * @dev Mints `quantity` tokens and transfers them to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `quantity` must be greater than 0.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _mint(address to, uint256 quantity) internal {
1032         uint256 startTokenId = _currentIndex;
1033         if (to == address(0)) revert MintToZeroAddress();
1034         if (quantity == 0) revert MintZeroQuantity();
1035 
1036         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1037 
1038         // Overflows are incredibly unrealistic.
1039         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1040         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1041         unchecked {
1042             // Updates:
1043             // - `balance += quantity`.
1044             // - `numberMinted += quantity`.
1045             //
1046             // We can directly add to the balance and number minted.
1047             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1048 
1049             // Updates:
1050             // - `address` to the owner.
1051             // - `startTimestamp` to the timestamp of minting.
1052             // - `burned` to `false`.
1053             // - `nextInitialized` to `quantity == 1`.
1054             _packedOwnerships[startTokenId] =
1055                 _addressToUint256(to) |
1056                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1057                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1058 
1059             uint256 updatedIndex = startTokenId;
1060             uint256 end = updatedIndex + quantity;
1061 
1062             do {
1063                 emit Transfer(address(0), to, updatedIndex++);
1064             } while (updatedIndex < end);
1065 
1066             _currentIndex = updatedIndex;
1067         }
1068         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1069     }
1070 
1071     /**
1072      * @dev Transfers `tokenId` from `from` to `to`.
1073      *
1074      * Requirements:
1075      *
1076      * - `to` cannot be the zero address.
1077      * - `tokenId` token must be owned by `from`.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _transfer(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) private {
1086         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1087 
1088         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1089 
1090         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1091             isApprovedForAll(from, _msgSenderERC721A()) ||
1092             getApproved(tokenId) == _msgSenderERC721A());
1093 
1094         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1095         if (to == address(0)) revert TransferToZeroAddress();
1096 
1097         _beforeTokenTransfers(from, to, tokenId, 1);
1098 
1099         // Clear approvals from the previous owner.
1100         delete _tokenApprovals[tokenId];
1101 
1102         // Underflow of the sender's balance is impossible because we check for
1103         // ownership above and the recipient's balance can't realistically overflow.
1104         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1105         unchecked {
1106             // We can directly increment and decrement the balances.
1107             --_packedAddressData[from]; // Updates: `balance -= 1`.
1108             ++_packedAddressData[to]; // Updates: `balance += 1`.
1109 
1110             // Updates:
1111             // - `address` to the next owner.
1112             // - `startTimestamp` to the timestamp of transfering.
1113             // - `burned` to `false`.
1114             // - `nextInitialized` to `true`.
1115             _packedOwnerships[tokenId] =
1116                 _addressToUint256(to) |
1117                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1118                 BITMASK_NEXT_INITIALIZED;
1119 
1120             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1121             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1122                 uint256 nextTokenId = tokenId + 1;
1123                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1124                 if (_packedOwnerships[nextTokenId] == 0) {
1125                     // If the next slot is within bounds.
1126                     if (nextTokenId != _currentIndex) {
1127                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1128                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1129                     }
1130                 }
1131             }
1132         }
1133 
1134         emit Transfer(from, to, tokenId);
1135         _afterTokenTransfers(from, to, tokenId, 1);
1136     }
1137 
1138     /**
1139      * @dev Equivalent to `_burn(tokenId, false)`.
1140      */
1141     function _burn(uint256 tokenId) internal virtual {
1142         _burn(tokenId, false);
1143     }
1144 
1145     /**
1146      * @dev Destroys `tokenId`.
1147      * The approval is cleared when the token is burned.
1148      *
1149      * Requirements:
1150      *
1151      * - `tokenId` must exist.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1156         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1157 
1158         address from = address(uint160(prevOwnershipPacked));
1159 
1160         if (approvalCheck) {
1161             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1162                 isApprovedForAll(from, _msgSenderERC721A()) ||
1163                 getApproved(tokenId) == _msgSenderERC721A());
1164 
1165             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1166         }
1167 
1168         _beforeTokenTransfers(from, address(0), tokenId, 1);
1169 
1170         // Clear approvals from the previous owner.
1171         delete _tokenApprovals[tokenId];
1172 
1173         // Underflow of the sender's balance is impossible because we check for
1174         // ownership above and the recipient's balance can't realistically overflow.
1175         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1176         unchecked {
1177             // Updates:
1178             // - `balance -= 1`.
1179             // - `numberBurned += 1`.
1180             //
1181             // We can directly decrement the balance, and increment the number burned.
1182             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1183             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1184 
1185             // Updates:
1186             // - `address` to the last owner.
1187             // - `startTimestamp` to the timestamp of burning.
1188             // - `burned` to `true`.
1189             // - `nextInitialized` to `true`.
1190             _packedOwnerships[tokenId] =
1191                 _addressToUint256(from) |
1192                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1193                 BITMASK_BURNED | 
1194                 BITMASK_NEXT_INITIALIZED;
1195 
1196             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1197             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1198                 uint256 nextTokenId = tokenId + 1;
1199                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1200                 if (_packedOwnerships[nextTokenId] == 0) {
1201                     // If the next slot is within bounds.
1202                     if (nextTokenId != _currentIndex) {
1203                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1204                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1205                     }
1206                 }
1207             }
1208         }
1209 
1210         emit Transfer(from, address(0), tokenId);
1211         _afterTokenTransfers(from, address(0), tokenId, 1);
1212 
1213         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1214         unchecked {
1215             _burnCounter++;
1216         }
1217     }
1218 
1219     /**
1220      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1221      *
1222      * @param from address representing the previous owner of the given token ID
1223      * @param to target address that will receive the tokens
1224      * @param tokenId uint256 ID of the token to be transferred
1225      * @param _data bytes optional data to send along with the call
1226      * @return bool whether the call correctly returned the expected magic value
1227      */
1228     function _checkContractOnERC721Received(
1229         address from,
1230         address to,
1231         uint256 tokenId,
1232         bytes memory _data
1233     ) private returns (bool) {
1234         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1235             bytes4 retval
1236         ) {
1237             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1238         } catch (bytes memory reason) {
1239             if (reason.length == 0) {
1240                 revert TransferToNonERC721ReceiverImplementer();
1241             } else {
1242                 assembly {
1243                     revert(add(32, reason), mload(reason))
1244                 }
1245             }
1246         }
1247     }
1248 
1249     /**
1250      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1251      * And also called before burning one token.
1252      *
1253      * startTokenId - the first token id to be transferred
1254      * quantity - the amount to be transferred
1255      *
1256      * Calling conditions:
1257      *
1258      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1259      * transferred to `to`.
1260      * - When `from` is zero, `tokenId` will be minted for `to`.
1261      * - When `to` is zero, `tokenId` will be burned by `from`.
1262      * - `from` and `to` are never both zero.
1263      */
1264     function _beforeTokenTransfers(
1265         address from,
1266         address to,
1267         uint256 startTokenId,
1268         uint256 quantity
1269     ) internal virtual {}
1270 
1271     /**
1272      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1273      * minting.
1274      * And also called after one token has been burned.
1275      *
1276      * startTokenId - the first token id to be transferred
1277      * quantity - the amount to be transferred
1278      *
1279      * Calling conditions:
1280      *
1281      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1282      * transferred to `to`.
1283      * - When `from` is zero, `tokenId` has been minted for `to`.
1284      * - When `to` is zero, `tokenId` has been burned by `from`.
1285      * - `from` and `to` are never both zero.
1286      */
1287     function _afterTokenTransfers(
1288         address from,
1289         address to,
1290         uint256 startTokenId,
1291         uint256 quantity
1292     ) internal virtual {}
1293 
1294     /**
1295      * @dev Returns the message sender (defaults to `msg.sender`).
1296      *
1297      * If you are writing GSN compatible contracts, you need to override this function.
1298      */
1299     function _msgSenderERC721A() internal view virtual returns (address) {
1300         return msg.sender;
1301     }
1302 
1303     /**
1304      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1305      */
1306     function _toString(uint256 value) internal pure returns (string memory ptr) {
1307         assembly {
1308             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1309             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1310             // We will need 1 32-byte word to store the length, 
1311             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1312             ptr := add(mload(0x40), 128)
1313             // Update the free memory pointer to allocate.
1314             mstore(0x40, ptr)
1315 
1316             // Cache the end of the memory to calculate the length later.
1317             let end := ptr
1318 
1319             // We write the string from the rightmost digit to the leftmost digit.
1320             // The following is essentially a do-while loop that also handles the zero case.
1321             // Costs a bit more than early returning for the zero case,
1322             // but cheaper in terms of deployment and overall runtime costs.
1323             for { 
1324                 // Initialize and perform the first pass without check.
1325                 let temp := value
1326                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1327                 ptr := sub(ptr, 1)
1328                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1329                 mstore8(ptr, add(48, mod(temp, 10)))
1330                 temp := div(temp, 10)
1331             } temp { 
1332                 // Keep dividing `temp` until zero.
1333                 temp := div(temp, 10)
1334             } { // Body of the for loop.
1335                 ptr := sub(ptr, 1)
1336                 mstore8(ptr, add(48, mod(temp, 10)))
1337             }
1338             
1339             let length := sub(end, ptr)
1340             // Move the pointer 32 bytes leftwards to make room for the length.
1341             ptr := sub(ptr, 32)
1342             // Store the length.
1343             mstore(ptr, length)
1344         }
1345     }
1346 }
1347 
1348 // File: contracts/WoFERC721A.sol
1349 
1350 pragma solidity ^0.8.4;
1351 
1352 contract ShadowDescendants2 is ERC721A, Ownable, Pausable {
1353     using Strings for uint256; 
1354 
1355     string public baseURI =
1356         "https://crimson-managing-cow-793.mypinata.cloud/ipfs/QmfKdAK6Jnz9crZGuUYQmU2gbCQ36YcWPCS8Fb4yJ6LbJH/";
1357     string public revealURI = "https://crimson-managing-cow-793.mypinata.cloud/ipfs/QmNuHx8TagzvtAnED1qHRjEwD4JcC5Wnvqie1VmnSSFAon";
1358     string public baseExtension = ".json";
1359     uint256 public cost = 0.07 ether;
1360     uint256 public presale_price = 0.05 ether;
1361     uint256 public maxSupply = 8888;
1362     uint8 public maxMintPerTransaction = 15;
1363 
1364     bool public reveal = false;
1365     bool public presale = true;
1366 
1367     address[] public whitelistedUsers = [0xE4f3aae8eb3Ebe3AAEF5149923f39A73806846BA, 0xcb1de9459670F9F0e59D21ef03c2b1074c81Bb21, 0x0ea1e75581A77B3A340aC9974bEfda27cfFFD919, 0xD0103F400BCD2A479121EaEb727EB4aCD868f9E2, 0x0359A4e95E8dC2E4b339A01d5cFd069cd20C6d6A, 0x04071eB17E0Fe8ccB0A983D0512D1136EFD4c283, 0x2Fe3a5Ba42c3dAd794c5dCc8C0c1B040948a83B7, 0x7b719f9518F4DDCd341D28838a06A78395A7d5fC, 0x539118962Fc4dF077D41c1817A34cbebfB9d5c1f, 0x5412BDf6320743D8b7947f29b7D345EF49f7895D, 0xd8C57a571964792130d8F6D49b5858CD9608c65c, 0x25074DF7e8350e19550106b5eb9D6baCC15f4231, 0x80e1980DeA1955Ad6cF7be35a757C9906C6Fe8fd, 0xf3498469C50bB31f0009e79106F0Cce08F98438a, 0x56886698844feE080A1564043982a7e7e4e79636, 0xa75fF87Cdd93172c84eC20A7e2c4d7568821De7e, 0x234FC221ca597621faCC18dcc730E2903ed4Ae32, 0x8190fA7c68321b2cb1d4539FeF61Fd92CCFcE1E3, 0xE588E86442fb06E3234810fCE0E1e385307d06e1, 0x34979D41e36d55dDfbBCe66efCc4F0f6dc4B9Ac9, 0xc5bA28f05c52563dC8293bA6CD7f7f1520ca0DeD, 0xC7300878a4b0459b686AA8e91155BDD93C3998d3, 0x6004442B3807b07b7901A2e25AcBc08710284886, 0xdEf82f6F50ca2334542ffa4028db809F9bC7A17f, 0xbC409FAf353AB0549Ea0F842dEA111A7C6c1043B];
1368 
1369     constructor() ERC721A("Shadow Descendants 2.0", "SHD2") {
1370         _safeMint(msg.sender, 300);
1371     }
1372 
1373     function _startTokenId() internal override view virtual returns (uint256) {
1374         return 1;
1375     }
1376 
1377     fallback() external payable {}
1378 
1379     receive() external payable {}
1380 
1381     function _baseURI() internal view virtual override returns (string memory) {
1382         return baseURI;
1383     }
1384 
1385     function setBaseURI(string memory _baseuri) external onlyOwner {
1386         baseURI = _baseuri;
1387     }
1388 
1389     function setRevealURI(string memory _uri) external onlyOwner {
1390         revealURI = _uri;
1391     }
1392 
1393     function tokenURI(uint256 tokenId)
1394         public
1395         view
1396         virtual
1397         override
1398         returns (string memory)
1399     {
1400         require(
1401             _exists(tokenId),
1402             "ERC721Metadata: URI query for nonexistent token"
1403         );
1404 
1405         if(!reveal) {
1406             return revealURI;
1407         }
1408 
1409         string memory currentBaseURI = _baseURI();
1410         return
1411             bytes(currentBaseURI).length > 0
1412                 ? string(
1413                     abi.encodePacked(
1414                         currentBaseURI,
1415                         tokenId.toString(),
1416                         baseExtension
1417                     )
1418                 )
1419                 : "";
1420     }
1421 
1422     function setNFTPrice(uint256 _newCost) public onlyOwner {
1423         cost = _newCost;
1424     }
1425 
1426     function setPresalePrice(uint256 _newPresalePrice) external onlyOwner {
1427         presale_price = _newPresalePrice;
1428     }
1429 
1430     function setMaxMintPerTransaction(uint8 _newMaxMint) external onlyOwner {
1431         maxMintPerTransaction = _newMaxMint;
1432     }
1433 
1434     function setReveal(bool _reveal) external onlyOwner {
1435         reveal = _reveal;
1436     }
1437 
1438     function presaleOn() external onlyOwner {
1439         presale = true;
1440     }
1441 
1442     function presaleOff() external onlyOwner {
1443         presale = false;
1444     }
1445 
1446     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1447         baseExtension = _newBaseExtension;
1448     }
1449 
1450     function addWhitelistUsers(address[] memory _addresses) external onlyOwner {
1451         whitelistedUsers = _addresses;
1452     }
1453 
1454     function removeWhitelistUser(address _address) external onlyOwner {
1455         (bool _isWhitelistedUser, uint256 s) = isWhitelistedUser(_address);
1456         if(_isWhitelistedUser){
1457             whitelistedUsers[s] = whitelistedUsers[whitelistedUsers.length - 1];
1458             whitelistedUsers.pop();
1459         } 
1460     }
1461 
1462     function isWhitelistedUser(address _address) public view returns(bool, uint256) {
1463         for(uint256 i=0; i < whitelistedUsers.length; i++) {
1464             if(_address == whitelistedUsers[i]) {
1465                 return (true, i);
1466             }
1467         }
1468         return (false, 0);
1469     }
1470 
1471     function pause() public onlyOwner {
1472         _pause();
1473     }
1474 
1475     function unpause() public onlyOwner {
1476         _unpause();
1477     }
1478 
1479     function withdraw() external onlyOwner whenNotPaused {
1480         uint balance = address(this).balance;
1481         require(balance > 0, "NFT: No ether left to withdraw");
1482 
1483         (bool success, ) = payable(owner()).call{ value: balance } ("");
1484         require(success, "NFT: Transfer failed.");
1485     }
1486 
1487     function lastTokenID() external view returns(uint256) {
1488         return totalSupply();
1489     }
1490 
1491     function mint(uint256 _mintAmount) public payable whenNotPaused {
1492         uint256 supply = totalSupply();
1493         require(_mintAmount > 0);
1494         require(supply + _mintAmount <= maxSupply);
1495         (bool isWhiteList, ) = isWhitelistedUser(msg.sender);
1496         if(presale) {
1497             require(isWhiteList, "Shadow Descendants 2.0: Caller is not whitelisted");
1498             require(msg.value >= presale_price * _mintAmount, "Shadow Descendants 2.0: insufficient funds");
1499         } else {
1500             require(msg.value >= cost * _mintAmount, "insufficient funds");
1501         }
1502 
1503         _safeMint(msg.sender, _mintAmount);
1504     }
1505 
1506     function _maxSupply() external view returns(uint256) {
1507         return maxSupply;
1508     }
1509 
1510 }