1 //SPDX-License-Identifier: MIT
2 
3 // File: contracts/utils/Strings.sol
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
59     function toHexString(uint256 value, uint256 length)
60         internal
61         pure
62         returns (string memory)
63     {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = _HEX_SYMBOLS[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 }
75 
76 // File: contracts/utils/Context.sol
77 
78 
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Provides information about the current execution context, including the
84  * sender of the transaction and its data. While these are generally available
85  * via msg.sender and msg.data, they should not be accessed in such a direct
86  * manner, since when dealing with meta-transactions the account sending and
87  * paying for execution may not be the actual sender (as far as an application
88  * is concerned).
89  *
90  * This contract is only required for intermediate, library-like contracts.
91  */
92 abstract contract Context {
93     function _msgSender() internal view virtual returns (address) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal view virtual returns (bytes calldata) {
98         return msg.data;
99     }
100 }
101 
102 // File: contracts/access/Ownable.sol
103 
104 
105 
106 pragma solidity ^0.8.0;
107 
108 
109 /**
110  * @dev Contract module which provides a basic access control mechanism, where
111  * there is an account (an owner) that can be granted exclusive access to
112  * specific functions.
113  *
114  * By default, the owner account will be the one that deploys the contract. This
115  * can later be changed with {transferOwnership}.
116  *
117  * This module is used through inheritance. It will make available the modifier
118  * `onlyOwner`, which can be applied to your functions to restrict their use to
119  * the owner.
120  */
121 abstract contract Ownable is Context {
122     address private _owner;
123 
124     event OwnershipTransferred(
125         address indexed previousOwner,
126         address indexed newOwner
127     );
128 
129     /**
130      * @dev Initializes the contract setting the deployer as the initial owner.
131      */
132     constructor() {
133         _setOwner(_msgSender());
134     }
135 
136     /**
137      * @dev Returns the address of the current owner.
138      */
139     function owner() public view virtual returns (address) {
140         return _owner;
141     }
142 
143     /**
144      * @dev Throws if called by any account other than the owner.
145      */
146     modifier onlyOwner() {
147         require(owner() == _msgSender(), "Ownable: caller is not the owner");
148         _;
149     }
150 
151     /**
152      * @dev Leaves the contract without owner. It will not be possible to call
153      * `onlyOwner` functions anymore. Can only be called by the current owner.
154      *
155      * NOTE: Renouncing ownership will leave the contract without an owner,
156      * thereby removing any functionality that is only available to the owner.
157      */
158     function renounceOwnership() public virtual onlyOwner {
159         _setOwner(address(0));
160     }
161 
162     /**
163      * @dev Transfers ownership of the contract to a new account (`newOwner`).
164      * Can only be called by the current owner.
165      */
166     function transferOwnership(address newOwner) public virtual onlyOwner {
167         require(
168             newOwner != address(0),
169             "Ownable: new owner is the zero address"
170         );
171         _setOwner(newOwner);
172     }
173 
174     function _setOwner(address newOwner) private {
175         address oldOwner = _owner;
176         _owner = newOwner;
177         emit OwnershipTransferred(oldOwner, newOwner);
178     }
179 }
180 
181 // ERC721A Contracts v4.0.0
182 // Creator: Chiru Labs
183 
184 pragma solidity ^0.8.4;
185 
186 /**
187  * @dev Interface of an ERC721A compliant contract.
188  */
189 interface IERC721A {
190     /**
191      * The caller must own the token or be an approved operator.
192      */
193     error ApprovalCallerNotOwnerNorApproved();
194 
195     /**
196      * The token does not exist.
197      */
198     error ApprovalQueryForNonexistentToken();
199 
200     /**
201      * The caller cannot approve to their own address.
202      */
203     error ApproveToCaller();
204 
205     /**
206      * Cannot query the balance for the zero address.
207      */
208     error BalanceQueryForZeroAddress();
209 
210     /**
211      * Cannot mint to the zero address.
212      */
213     error MintToZeroAddress();
214 
215     /**
216      * The quantity of tokens minted must be more than zero.
217      */
218     error MintZeroQuantity();
219 
220     /**
221      * The token does not exist.
222      */
223     error OwnerQueryForNonexistentToken();
224 
225     /**
226      * The caller must own the token or be an approved operator.
227      */
228     error TransferCallerNotOwnerNorApproved();
229 
230     /**
231      * The token must be owned by `from`.
232      */
233     error TransferFromIncorrectOwner();
234 
235     /**
236      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
237      */
238     error TransferToNonERC721ReceiverImplementer();
239 
240     /**
241      * Cannot transfer to the zero address.
242      */
243     error TransferToZeroAddress();
244 
245     /**
246      * The token does not exist.
247      */
248     error URIQueryForNonexistentToken();
249 
250     /**
251      * The `quantity` minted with ERC2309 exceeds the safety limit.
252      */
253     error MintERC2309QuantityExceedsLimit();
254 
255     /**
256      * The `extraData` cannot be set on an unintialized ownership slot.
257      */
258     error OwnershipNotInitializedForExtraData();
259 
260     struct TokenOwnership {
261         // The address of the owner.
262         address addr;
263         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
264         uint64 startTimestamp;
265         // Whether the token has been burned.
266         bool burned;
267         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
268         uint24 extraData;
269     }
270 
271     /**
272      * @dev Returns the total amount of tokens stored by the contract.
273      *
274      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
275      */
276     function totalSupply() external view returns (uint256);
277 
278     // ==============================
279     //            IERC165
280     // ==============================
281 
282     /**
283      * @dev Returns true if this contract implements the interface defined by
284      * `interfaceId`. See the corresponding
285      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
286      * to learn more about how these ids are created.
287      *
288      * This function call must use less than 30 000 gas.
289      */
290     function supportsInterface(bytes4 interfaceId) external view returns (bool);
291 
292     // ==============================
293     //            IERC721
294     // ==============================
295 
296     /**
297      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
298      */
299     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
300 
301     /**
302      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
303      */
304     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
305 
306     /**
307      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
308      */
309     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
310 
311     /**
312      * @dev Returns the number of tokens in ``owner``'s account.
313      */
314     function balanceOf(address owner) external view returns (uint256 balance);
315 
316     /**
317      * @dev Returns the owner of the `tokenId` token.
318      *
319      * Requirements:
320      *
321      * - `tokenId` must exist.
322      */
323     function ownerOf(uint256 tokenId) external view returns (address owner);
324 
325     /**
326      * @dev Safely transfers `tokenId` token from `from` to `to`.
327      *
328      * Requirements:
329      *
330      * - `from` cannot be the zero address.
331      * - `to` cannot be the zero address.
332      * - `tokenId` token must exist and be owned by `from`.
333      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
334      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
335      *
336      * Emits a {Transfer} event.
337      */
338     function safeTransferFrom(
339         address from,
340         address to,
341         uint256 tokenId,
342         bytes calldata data
343     ) external;
344 
345     /**
346      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
347      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
348      *
349      * Requirements:
350      *
351      * - `from` cannot be the zero address.
352      * - `to` cannot be the zero address.
353      * - `tokenId` token must exist and be owned by `from`.
354      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
355      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
356      *
357      * Emits a {Transfer} event.
358      */
359     function safeTransferFrom(
360         address from,
361         address to,
362         uint256 tokenId
363     ) external;
364 
365     /**
366      * @dev Transfers `tokenId` token from `from` to `to`.
367      *
368      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
369      *
370      * Requirements:
371      *
372      * - `from` cannot be the zero address.
373      * - `to` cannot be the zero address.
374      * - `tokenId` token must be owned by `from`.
375      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
376      *
377      * Emits a {Transfer} event.
378      */
379     function transferFrom(
380         address from,
381         address to,
382         uint256 tokenId
383     ) external;
384 
385     /**
386      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
387      * The approval is cleared when the token is transferred.
388      *
389      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
390      *
391      * Requirements:
392      *
393      * - The caller must own the token or be an approved operator.
394      * - `tokenId` must exist.
395      *
396      * Emits an {Approval} event.
397      */
398     function approve(address to, uint256 tokenId) external;
399 
400     /**
401      * @dev Approve or remove `operator` as an operator for the caller.
402      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
403      *
404      * Requirements:
405      *
406      * - The `operator` cannot be the caller.
407      *
408      * Emits an {ApprovalForAll} event.
409      */
410     function setApprovalForAll(address operator, bool _approved) external;
411 
412     /**
413      * @dev Returns the account approved for `tokenId` token.
414      *
415      * Requirements:
416      *
417      * - `tokenId` must exist.
418      */
419     function getApproved(uint256 tokenId) external view returns (address operator);
420 
421     /**
422      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
423      *
424      * See {setApprovalForAll}
425      */
426     function isApprovedForAll(address owner, address operator) external view returns (bool);
427 
428     // ==============================
429     //        IERC721Metadata
430     // ==============================
431 
432     /**
433      * @dev Returns the token collection name.
434      */
435     function name() external view returns (string memory);
436 
437     /**
438      * @dev Returns the token collection symbol.
439      */
440     function symbol() external view returns (string memory);
441 
442     /**
443      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
444      */
445     function tokenURI(uint256 tokenId) external view returns (string memory);
446 
447     // ==============================
448     //            IERC2309
449     // ==============================
450 
451     /**
452      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
453      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
454      */
455     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
456 }
457 
458 pragma solidity ^0.8.4;
459 
460 /**
461  * @dev ERC721 token receiver interface.
462  */
463 interface ERC721A__IERC721Receiver {
464     function onERC721Received(
465         address operator,
466         address from,
467         uint256 tokenId,
468         bytes calldata data
469     ) external returns (bytes4);
470 }
471 
472 /**
473  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
474  * including the Metadata extension. Built to optimize for lower gas during batch mints.
475  *
476  * Assumes serials are sequentially minted starting at `_startTokenId()`
477  * (defaults to 0, e.g. 0, 1, 2, 3..).
478  *
479  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
480  *
481  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
482  */
483 contract ERC721A is IERC721A {
484     // Mask of an entry in packed address data.
485     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
486 
487     // The bit position of `numberMinted` in packed address data.
488     uint256 private constant BITPOS_NUMBER_MINTED = 64;
489 
490     // The bit position of `numberBurned` in packed address data.
491     uint256 private constant BITPOS_NUMBER_BURNED = 128;
492 
493     // The bit position of `aux` in packed address data.
494     uint256 private constant BITPOS_AUX = 192;
495 
496     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
497     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
498 
499     // The bit position of `startTimestamp` in packed ownership.
500     uint256 private constant BITPOS_START_TIMESTAMP = 160;
501 
502     // The bit mask of the `burned` bit in packed ownership.
503     uint256 private constant BITMASK_BURNED = 1 << 224;
504 
505     // The bit position of the `nextInitialized` bit in packed ownership.
506     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
507 
508     // The bit mask of the `nextInitialized` bit in packed ownership.
509     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
510 
511     // The bit position of `extraData` in packed ownership.
512     uint256 private constant BITPOS_EXTRA_DATA = 232;
513 
514     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
515     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
516 
517     // The mask of the lower 160 bits for addresses.
518     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
519 
520     // The maximum `quantity` that can be minted with `_mintERC2309`.
521     // This limit is to prevent overflows on the address data entries.
522     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
523     // is required to cause an overflow, which is unrealistic.
524     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
525 
526     // The tokenId of the next token to be minted.
527     uint256 private _currentIndex;
528 
529     // The number of tokens burned.
530     uint256 private _burnCounter;
531 
532     // Token name
533     string private _name;
534 
535     // Token symbol
536     string private _symbol;
537 
538     // Mapping from token ID to ownership details
539     // An empty struct value does not necessarily mean the token is unowned.
540     // See `_packedOwnershipOf` implementation for details.
541     //
542     // Bits Layout:
543     // - [0..159]   `addr`
544     // - [160..223] `startTimestamp`
545     // - [224]      `burned`
546     // - [225]      `nextInitialized`
547     // - [232..255] `extraData`
548     mapping(uint256 => uint256) private _packedOwnerships;
549 
550     // Mapping owner address to address data.
551     //
552     // Bits Layout:
553     // - [0..63]    `balance`
554     // - [64..127]  `numberMinted`
555     // - [128..191] `numberBurned`
556     // - [192..255] `aux`
557     mapping(address => uint256) private _packedAddressData;
558 
559     // Mapping from token ID to approved address.
560     mapping(uint256 => address) private _tokenApprovals;
561 
562     // Mapping from owner to operator approvals
563     mapping(address => mapping(address => bool)) private _operatorApprovals;
564 
565     constructor(string memory name_, string memory symbol_) {
566         _name = name_;
567         _symbol = symbol_;
568         _currentIndex = _startTokenId();
569     }
570 
571     /**
572      * @dev Returns the starting token ID.
573      * To change the starting token ID, please override this function.
574      */
575     function _startTokenId() internal view virtual returns (uint256) {
576         return 1;
577     }
578 
579     /**
580      * @dev Returns the next token ID to be minted.
581      */
582     function _nextTokenId() internal view returns (uint256) {
583         return _currentIndex;
584     }
585 
586     /**
587      * @dev Returns the total number of tokens in existence.
588      * Burned tokens will reduce the count.
589      * To get the total number of tokens minted, please see `_totalMinted`.
590      */
591     function totalSupply() public view override returns (uint256) {
592         // Counter underflow is impossible as _burnCounter cannot be incremented
593         // more than `_currentIndex - _startTokenId()` times.
594         unchecked {
595             return _currentIndex - _burnCounter - _startTokenId();
596         }
597     }
598 
599     /**
600      * @dev Returns the total amount of tokens minted in the contract.
601      */
602     function _totalMinted() internal view returns (uint256) {
603         // Counter underflow is impossible as _currentIndex does not decrement,
604         // and it is initialized to `_startTokenId()`
605         unchecked {
606             return _currentIndex - _startTokenId();
607         }
608     }
609 
610     /**
611      * @dev Returns the total number of tokens burned.
612      */
613     function _totalBurned() internal view returns (uint256) {
614         return _burnCounter;
615     }
616 
617     /**
618      * @dev See {IERC165-supportsInterface}.
619      */
620     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
621         // The interface IDs are constants representing the first 4 bytes of the XOR of
622         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
623         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
624         return
625             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
626             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
627             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
628     }
629 
630     /**
631      * @dev See {IERC721-balanceOf}.
632      */
633     function balanceOf(address owner) public view override returns (uint256) {
634         if (owner == address(0)) revert BalanceQueryForZeroAddress();
635         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
636     }
637 
638     /**
639      * Returns the number of tokens minted by `owner`.
640      */
641     function _numberMinted(address owner) internal view returns (uint256) {
642         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
643     }
644 
645     /**
646      * Returns the number of tokens burned by or on behalf of `owner`.
647      */
648     function _numberBurned(address owner) internal view returns (uint256) {
649         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
650     }
651 
652     /**
653      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
654      */
655     function _getAux(address owner) internal view returns (uint64) {
656         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
657     }
658 
659     /**
660      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
661      * If there are multiple variables, please pack them into a uint64.
662      */
663     function _setAux(address owner, uint64 aux) internal {
664         uint256 packed = _packedAddressData[owner];
665         uint256 auxCasted;
666         // Cast `aux` with assembly to avoid redundant masking.
667         assembly {
668             auxCasted := aux
669         }
670         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
671         _packedAddressData[owner] = packed;
672     }
673 
674     /**
675      * Returns the packed ownership data of `tokenId`.
676      */
677     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
678         uint256 curr = tokenId;
679 
680         unchecked {
681             if (_startTokenId() <= curr)
682                 if (curr < _currentIndex) {
683                     uint256 packed = _packedOwnerships[curr];
684                     // If not burned.
685                     if (packed & BITMASK_BURNED == 0) {
686                         // Invariant:
687                         // There will always be an ownership that has an address and is not burned
688                         // before an ownership that does not have an address and is not burned.
689                         // Hence, curr will not underflow.
690                         //
691                         // We can directly compare the packed value.
692                         // If the address is zero, packed is zero.
693                         while (packed == 0) {
694                             packed = _packedOwnerships[--curr];
695                         }
696                         return packed;
697                     }
698                 }
699         }
700         revert OwnerQueryForNonexistentToken();
701     }
702 
703     /**
704      * Returns the unpacked `TokenOwnership` struct from `packed`.
705      */
706     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
707         ownership.addr = address(uint160(packed));
708         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
709         ownership.burned = packed & BITMASK_BURNED != 0;
710         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
711     }
712 
713     /**
714      * Returns the unpacked `TokenOwnership` struct at `index`.
715      */
716     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
717         return _unpackedOwnership(_packedOwnerships[index]);
718     }
719 
720     /**
721      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
722      */
723     function _initializeOwnershipAt(uint256 index) internal {
724         if (_packedOwnerships[index] == 0) {
725             _packedOwnerships[index] = _packedOwnershipOf(index);
726         }
727     }
728 
729     /**
730      * Gas spent here starts off proportional to the maximum mint batch size.
731      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
732      */
733     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
734         return _unpackedOwnership(_packedOwnershipOf(tokenId));
735     }
736 
737     /**
738      * @dev Packs ownership data into a single uint256.
739      */
740     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
741         assembly {
742             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
743             owner := and(owner, BITMASK_ADDRESS)
744             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
745             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
746         }
747     }
748 
749     /**
750      * @dev See {IERC721-ownerOf}.
751      */
752     function ownerOf(uint256 tokenId) public view override returns (address) {
753         return address(uint160(_packedOwnershipOf(tokenId)));
754     }
755 
756     /**
757      * @dev See {IERC721Metadata-name}.
758      */
759     function name() public view virtual override returns (string memory) {
760         return _name;
761     }
762 
763     /**
764      * @dev See {IERC721Metadata-symbol}.
765      */
766     function symbol() public view virtual override returns (string memory) {
767         return _symbol;
768     }
769 
770     /**
771      * @dev See {IERC721Metadata-tokenURI}.
772      */
773     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
774         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
775 
776         string memory baseURI = _baseURI();
777         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
778     }
779 
780     /**
781      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
782      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
783      * by default, it can be overridden in child contracts.
784      */
785     function _baseURI() internal view virtual returns (string memory) {
786         return '';
787     }
788 
789     /**
790      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
791      */
792     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
793         // For branchless setting of the `nextInitialized` flag.
794         assembly {
795             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
796             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
797         }
798     }
799 
800     /**
801      * @dev See {IERC721-approve}.
802      */
803     function approve(address to, uint256 tokenId) public override {
804         address owner = ownerOf(tokenId);
805 
806         if (_msgSenderERC721A() != owner)
807             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
808                 revert ApprovalCallerNotOwnerNorApproved();
809             }
810 
811         _tokenApprovals[tokenId] = to;
812         emit Approval(owner, to, tokenId);
813     }
814 
815     /**
816      * @dev See {IERC721-getApproved}.
817      */
818     function getApproved(uint256 tokenId) public view override returns (address) {
819         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
820 
821         return _tokenApprovals[tokenId];
822     }
823 
824     /**
825      * @dev See {IERC721-setApprovalForAll}.
826      */
827     function setApprovalForAll(address operator, bool approved) public virtual override {
828         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
829 
830         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
831         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
832     }
833 
834     /**
835      * @dev See {IERC721-isApprovedForAll}.
836      */
837     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
838         return _operatorApprovals[owner][operator];
839     }
840 
841     /**
842      * @dev See {IERC721-safeTransferFrom}.
843      */
844     function safeTransferFrom(
845         address from,
846         address to,
847         uint256 tokenId
848     ) public virtual override {
849         safeTransferFrom(from, to, tokenId, '');
850     }
851 
852     /**
853      * @dev See {IERC721-safeTransferFrom}.
854      */
855     function safeTransferFrom(
856         address from,
857         address to,
858         uint256 tokenId,
859         bytes memory _data
860     ) public virtual override {
861         transferFrom(from, to, tokenId);
862         if (to.code.length != 0)
863             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
864                 revert TransferToNonERC721ReceiverImplementer();
865             }
866     }
867 
868     /**
869      * @dev Returns whether `tokenId` exists.
870      *
871      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
872      *
873      * Tokens start existing when they are minted (`_mint`),
874      */
875     function _exists(uint256 tokenId) internal view returns (bool) {
876         return
877             _startTokenId() <= tokenId &&
878             tokenId < _currentIndex && // If within bounds,
879             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
880     }
881 
882     /**
883      * @dev Equivalent to `_safeMint(to, quantity, '')`.
884      */
885     function _safeMint(address to, uint256 quantity) internal {
886         _safeMint(to, quantity, '');
887     }
888 
889     /**
890      * @dev Safely mints `quantity` tokens and transfers them to `to`.
891      *
892      * Requirements:
893      *
894      * - If `to` refers to a smart contract, it must implement
895      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
896      * - `quantity` must be greater than 0.
897      *
898      * See {_mint}.
899      *
900      * Emits a {Transfer} event for each mint.
901      */
902     function _safeMint(
903         address to,
904         uint256 quantity,
905         bytes memory _data
906     ) internal {
907         _mint(to, quantity);
908 
909         unchecked {
910             if (to.code.length != 0) {
911                 uint256 end = _currentIndex;
912                 uint256 index = end - quantity;
913                 do {
914                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
915                         revert TransferToNonERC721ReceiverImplementer();
916                     }
917                 } while (index < end);
918                 // Reentrancy protection.
919                 if (_currentIndex != end) revert();
920             }
921         }
922     }
923 
924     /**
925      * @dev Mints `quantity` tokens and transfers them to `to`.
926      *
927      * Requirements:
928      *
929      * - `to` cannot be the zero address.
930      * - `quantity` must be greater than 0.
931      *
932      * Emits a {Transfer} event for each mint.
933      */
934     function _mint(address to, uint256 quantity) internal {
935         uint256 startTokenId = _currentIndex;
936         if (to == address(0)) revert MintToZeroAddress();
937         if (quantity == 0) revert MintZeroQuantity();
938 
939         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
940 
941         // Overflows are incredibly unrealistic.
942         // `balance` and `numberMinted` have a maximum limit of 2**64.
943         // `tokenId` has a maximum limit of 2**256.
944         unchecked {
945             // Updates:
946             // - `balance += quantity`.
947             // - `numberMinted += quantity`.
948             //
949             // We can directly add to the `balance` and `numberMinted`.
950             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
951 
952             // Updates:
953             // - `address` to the owner.
954             // - `startTimestamp` to the timestamp of minting.
955             // - `burned` to `false`.
956             // - `nextInitialized` to `quantity == 1`.
957             _packedOwnerships[startTokenId] = _packOwnershipData(
958                 to,
959                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
960             );
961 
962             uint256 tokenId = startTokenId;
963             uint256 end = startTokenId + quantity;
964             do {
965                 emit Transfer(address(0), to, tokenId++);
966             } while (tokenId < end);
967 
968             _currentIndex = end;
969         }
970         _afterTokenTransfers(address(0), to, startTokenId, quantity);
971     }
972 
973     /**
974      * @dev Mints `quantity` tokens and transfers them to `to`.
975      *
976      * This function is intended for efficient minting only during contract creation.
977      *
978      * It emits only one {ConsecutiveTransfer} as defined in
979      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
980      * instead of a sequence of {Transfer} event(s).
981      *
982      * Calling this function outside of contract creation WILL make your contract
983      * non-compliant with the ERC721 standard.
984      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
985      * {ConsecutiveTransfer} event is only permissible during contract creation.
986      *
987      * Requirements:
988      *
989      * - `to` cannot be the zero address.
990      * - `quantity` must be greater than 0.
991      *
992      * Emits a {ConsecutiveTransfer} event.
993      */
994     function _mintERC2309(address to, uint256 quantity) internal {
995         uint256 startTokenId = _currentIndex;
996         if (to == address(0)) revert MintToZeroAddress();
997         if (quantity == 0) revert MintZeroQuantity();
998         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
999 
1000         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1001 
1002         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1003         unchecked {
1004             // Updates:
1005             // - `balance += quantity`.
1006             // - `numberMinted += quantity`.
1007             //
1008             // We can directly add to the `balance` and `numberMinted`.
1009             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1010 
1011             // Updates:
1012             // - `address` to the owner.
1013             // - `startTimestamp` to the timestamp of minting.
1014             // - `burned` to `false`.
1015             // - `nextInitialized` to `quantity == 1`.
1016             _packedOwnerships[startTokenId] = _packOwnershipData(
1017                 to,
1018                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1019             );
1020 
1021             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1022 
1023             _currentIndex = startTokenId + quantity;
1024         }
1025         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1026     }
1027 
1028     /**
1029      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1030      */
1031     function _getApprovedAddress(uint256 tokenId)
1032         private
1033         view
1034         returns (uint256 approvedAddressSlot, address approvedAddress)
1035     {
1036         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1037         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1038         assembly {
1039             // Compute the slot.
1040             mstore(0x00, tokenId)
1041             mstore(0x20, tokenApprovalsPtr.slot)
1042             approvedAddressSlot := keccak256(0x00, 0x40)
1043             // Load the slot's value from storage.
1044             approvedAddress := sload(approvedAddressSlot)
1045         }
1046     }
1047 
1048     /**
1049      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1050      */
1051     function _isOwnerOrApproved(
1052         address approvedAddress,
1053         address from,
1054         address msgSender
1055     ) private pure returns (bool result) {
1056         assembly {
1057             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1058             from := and(from, BITMASK_ADDRESS)
1059             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1060             msgSender := and(msgSender, BITMASK_ADDRESS)
1061             // `msgSender == from || msgSender == approvedAddress`.
1062             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1063         }
1064     }
1065 
1066     /**
1067      * @dev Transfers `tokenId` from `from` to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - `to` cannot be the zero address.
1072      * - `tokenId` token must be owned by `from`.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function transferFrom(
1077         address from,
1078         address to,
1079         uint256 tokenId
1080     ) public virtual override {
1081         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1082 
1083         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1084 
1085         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1086 
1087         // The nested ifs save around 20+ gas over a compound boolean condition.
1088         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1089             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1090 
1091         if (to == address(0)) revert TransferToZeroAddress();
1092 
1093         _beforeTokenTransfers(from, to, tokenId, 1);
1094 
1095         // Clear approvals from the previous owner.
1096         assembly {
1097             if approvedAddress {
1098                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1099                 sstore(approvedAddressSlot, 0)
1100             }
1101         }
1102 
1103         // Underflow of the sender's balance is impossible because we check for
1104         // ownership above and the recipient's balance can't realistically overflow.
1105         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1106         unchecked {
1107             // We can directly increment and decrement the balances.
1108             --_packedAddressData[from]; // Updates: `balance -= 1`.
1109             ++_packedAddressData[to]; // Updates: `balance += 1`.
1110 
1111             // Updates:
1112             // - `address` to the next owner.
1113             // - `startTimestamp` to the timestamp of transfering.
1114             // - `burned` to `false`.
1115             // - `nextInitialized` to `true`.
1116             _packedOwnerships[tokenId] = _packOwnershipData(
1117                 to,
1118                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1119             );
1120 
1121             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1122             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1123                 uint256 nextTokenId = tokenId + 1;
1124                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1125                 if (_packedOwnerships[nextTokenId] == 0) {
1126                     // If the next slot is within bounds.
1127                     if (nextTokenId != _currentIndex) {
1128                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1129                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1130                     }
1131                 }
1132             }
1133         }
1134 
1135         emit Transfer(from, to, tokenId);
1136         _afterTokenTransfers(from, to, tokenId, 1);
1137     }
1138 
1139     /**
1140      * @dev Equivalent to `_burn(tokenId, false)`.
1141      */
1142     function _burn(uint256 tokenId) internal virtual {
1143         _burn(tokenId, false);
1144     }
1145 
1146     /**
1147      * @dev Destroys `tokenId`.
1148      * The approval is cleared when the token is burned.
1149      *
1150      * Requirements:
1151      *
1152      * - `tokenId` must exist.
1153      *
1154      * Emits a {Transfer} event.
1155      */
1156     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1157         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1158 
1159         address from = address(uint160(prevOwnershipPacked));
1160 
1161         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1162 
1163         if (approvalCheck) {
1164             // The nested ifs save around 20+ gas over a compound boolean condition.
1165             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1166                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1167         }
1168 
1169         _beforeTokenTransfers(from, address(0), tokenId, 1);
1170 
1171         // Clear approvals from the previous owner.
1172         assembly {
1173             if approvedAddress {
1174                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1175                 sstore(approvedAddressSlot, 0)
1176             }
1177         }
1178 
1179         // Underflow of the sender's balance is impossible because we check for
1180         // ownership above and the recipient's balance can't realistically overflow.
1181         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1182         unchecked {
1183             // Updates:
1184             // - `balance -= 1`.
1185             // - `numberBurned += 1`.
1186             //
1187             // We can directly decrement the balance, and increment the number burned.
1188             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1189             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1190 
1191             // Updates:
1192             // - `address` to the last owner.
1193             // - `startTimestamp` to the timestamp of burning.
1194             // - `burned` to `true`.
1195             // - `nextInitialized` to `true`.
1196             _packedOwnerships[tokenId] = _packOwnershipData(
1197                 from,
1198                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1199             );
1200 
1201             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1202             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1203                 uint256 nextTokenId = tokenId + 1;
1204                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1205                 if (_packedOwnerships[nextTokenId] == 0) {
1206                     // If the next slot is within bounds.
1207                     if (nextTokenId != _currentIndex) {
1208                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1209                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1210                     }
1211                 }
1212             }
1213         }
1214 
1215         emit Transfer(from, address(0), tokenId);
1216         _afterTokenTransfers(from, address(0), tokenId, 1);
1217 
1218         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1219         unchecked {
1220             _burnCounter++;
1221         }
1222     }
1223 
1224     /**
1225      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1226      *
1227      * @param from address representing the previous owner of the given token ID
1228      * @param to target address that will receive the tokens
1229      * @param tokenId uint256 ID of the token to be transferred
1230      * @param _data bytes optional data to send along with the call
1231      * @return bool whether the call correctly returned the expected magic value
1232      */
1233     function _checkContractOnERC721Received(
1234         address from,
1235         address to,
1236         uint256 tokenId,
1237         bytes memory _data
1238     ) private returns (bool) {
1239         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1240             bytes4 retval
1241         ) {
1242             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1243         } catch (bytes memory reason) {
1244             if (reason.length == 0) {
1245                 revert TransferToNonERC721ReceiverImplementer();
1246             } else {
1247                 assembly {
1248                     revert(add(32, reason), mload(reason))
1249                 }
1250             }
1251         }
1252     }
1253 
1254     /**
1255      * @dev Directly sets the extra data for the ownership data `index`.
1256      */
1257     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1258         uint256 packed = _packedOwnerships[index];
1259         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1260         uint256 extraDataCasted;
1261         // Cast `extraData` with assembly to avoid redundant masking.
1262         assembly {
1263             extraDataCasted := extraData
1264         }
1265         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1266         _packedOwnerships[index] = packed;
1267     }
1268 
1269     /**
1270      * @dev Returns the next extra data for the packed ownership data.
1271      * The returned result is shifted into position.
1272      */
1273     function _nextExtraData(
1274         address from,
1275         address to,
1276         uint256 prevOwnershipPacked
1277     ) private view returns (uint256) {
1278         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1279         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1280     }
1281 
1282     /**
1283      * @dev Called during each token transfer to set the 24bit `extraData` field.
1284      * Intended to be overridden by the cosumer contract.
1285      *
1286      * `previousExtraData` - the value of `extraData` before transfer.
1287      *
1288      * Calling conditions:
1289      *
1290      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1291      * transferred to `to`.
1292      * - When `from` is zero, `tokenId` will be minted for `to`.
1293      * - When `to` is zero, `tokenId` will be burned by `from`.
1294      * - `from` and `to` are never both zero.
1295      */
1296     function _extraData(
1297         address from,
1298         address to,
1299         uint24 previousExtraData
1300     ) internal view virtual returns (uint24) {}
1301 
1302     /**
1303      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1304      * This includes minting.
1305      * And also called before burning one token.
1306      *
1307      * startTokenId - the first token id to be transferred
1308      * quantity - the amount to be transferred
1309      *
1310      * Calling conditions:
1311      *
1312      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1313      * transferred to `to`.
1314      * - When `from` is zero, `tokenId` will be minted for `to`.
1315      * - When `to` is zero, `tokenId` will be burned by `from`.
1316      * - `from` and `to` are never both zero.
1317      */
1318     function _beforeTokenTransfers(
1319         address from,
1320         address to,
1321         uint256 startTokenId,
1322         uint256 quantity
1323     ) internal virtual {}
1324 
1325     /**
1326      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1327      * This includes minting.
1328      * And also called after one token has been burned.
1329      *
1330      * startTokenId - the first token id to be transferred
1331      * quantity - the amount to be transferred
1332      *
1333      * Calling conditions:
1334      *
1335      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1336      * transferred to `to`.
1337      * - When `from` is zero, `tokenId` has been minted for `to`.
1338      * - When `to` is zero, `tokenId` has been burned by `from`.
1339      * - `from` and `to` are never both zero.
1340      */
1341     function _afterTokenTransfers(
1342         address from,
1343         address to,
1344         uint256 startTokenId,
1345         uint256 quantity
1346     ) internal virtual {}
1347 
1348     /**
1349      * @dev Returns the message sender (defaults to `msg.sender`).
1350      *
1351      * If you are writing GSN compatible contracts, you need to override this function.
1352      */
1353     function _msgSenderERC721A() internal view virtual returns (address) {
1354         return msg.sender;
1355     }
1356 
1357     /**
1358      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1359      */
1360     function _toString(uint256 value) internal pure returns (string memory ptr) {
1361         assembly {
1362             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1363             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1364             // We will need 1 32-byte word to store the length,
1365             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1366             ptr := add(mload(0x40), 128)
1367             // Update the free memory pointer to allocate.
1368             mstore(0x40, ptr)
1369 
1370             // Cache the end of the memory to calculate the length later.
1371             let end := ptr
1372 
1373             // We write the string from the rightmost digit to the leftmost digit.
1374             // The following is essentially a do-while loop that also handles the zero case.
1375             // Costs a bit more than early returning for the zero case,
1376             // but cheaper in terms of deployment and overall runtime costs.
1377             for {
1378                 // Initialize and perform the first pass without check.
1379                 let temp := value
1380                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1381                 ptr := sub(ptr, 1)
1382                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1383                 mstore8(ptr, add(48, mod(temp, 10)))
1384                 temp := div(temp, 10)
1385             } temp {
1386                 // Keep dividing `temp` until zero.
1387                 temp := div(temp, 10)
1388             } {
1389                 // Body of the for loop.
1390                 ptr := sub(ptr, 1)
1391                 mstore8(ptr, add(48, mod(temp, 10)))
1392             }
1393 
1394             let length := sub(end, ptr)
1395             // Move the pointer 32 bytes leftwards to make room for the length.
1396             ptr := sub(ptr, 32)
1397             // Store the length.
1398             mstore(ptr, length)
1399         }
1400     }
1401 }
1402 
1403 pragma solidity ^0.8.7;
1404 contract AlienArmyApes_NFT is ERC721A, Ownable {
1405     using Strings for uint256;
1406 
1407     string private baseURI;
1408     string public unrevURI;
1409     string public baseExtension = ".json";
1410     uint256 public cost = 100000000000000000;
1411     uint256 public presaleCost = 50000000000000000;
1412     uint256 public maxSupply = 2500;
1413     bool public public_paused = false;
1414     bool public pre_paused = false;
1415     bool public revealed = false;
1416 
1417     constructor(string memory _initBaseURI, string memory _initUnrevURI)
1418         ERC721A("Alien Army Apes", "AAA")
1419         {
1420             setBaseURI(_initBaseURI);
1421             setUnrevURI(_initUnrevURI);
1422         }
1423 
1424     // internal
1425     function _baseURI() internal view virtual override returns (string memory) {
1426         return baseURI;
1427     }
1428 
1429     // public
1430 
1431     function mint(uint _amount) public payable {
1432         uint256 supply = totalSupply();
1433         require(!public_paused, "Sale has not started yet");
1434         require(supply + _amount <= maxSupply);
1435         require(msg.value >= cost * _amount);       
1436 
1437         _mint(msg.sender, _amount);
1438     }
1439 
1440     function preMint(uint _amount) public payable {
1441         uint256 supply = totalSupply();
1442         require(!pre_paused, "Sale has not started yet");
1443         require(supply + _amount <= 200);
1444         require(msg.value >= presaleCost * _amount);       
1445 
1446         _mint(msg.sender, _amount);
1447     }
1448 
1449     function ownerMint(address _to, uint _amount) public onlyOwner {
1450         uint256 supply = totalSupply();
1451         require(supply + _amount <= maxSupply);
1452         _mint(_to, _amount);
1453     }
1454 
1455    
1456     function tokenURI(uint256 tokenId)
1457         public
1458         view
1459         virtual
1460         override
1461         returns (string memory)
1462     {
1463         require(
1464             _exists(tokenId),
1465             "ERC721Metadata: URI query for nonexistent token"
1466         );
1467 
1468         if(!revealed) {
1469             return unrevURI;
1470         }
1471 
1472         string memory currentBaseURI = _baseURI();
1473         return
1474             bytes(currentBaseURI).length > 0
1475                 ? string(
1476                     abi.encodePacked(
1477                         currentBaseURI,
1478                         tokenId.toString(),
1479                         baseExtension
1480                     )
1481                 )
1482                 : "";
1483     }
1484 
1485     //only owner
1486 
1487 
1488     function setCost(uint256 _newCost) public onlyOwner {
1489         cost = _newCost;
1490     }
1491 
1492       function setPresaleCost(uint256 _newCost) public onlyOwner {
1493         presaleCost = _newCost;
1494     }
1495     
1496     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1497         baseURI = _newBaseURI;
1498     }
1499 
1500     function setUnrevURI(string memory _newUnrevURI) public onlyOwner {
1501         unrevURI = _newUnrevURI;
1502     }
1503 
1504     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1505         baseExtension = _newBaseExtension;
1506     }
1507 
1508     function startPublicSale() public onlyOwner {
1509         public_paused = false;
1510     }
1511     
1512     function stopPublicSale() public onlyOwner {
1513         public_paused = true;
1514     }
1515 
1516     function startPreSale() public onlyOwner {
1517         pre_paused = false;
1518     }
1519 
1520     function stopPreSale() public onlyOwner {
1521         pre_paused = true;
1522     }
1523 
1524     function revealNFT() public onlyOwner {
1525         revealed = true;
1526     }
1527 
1528     function withdraw() public payable onlyOwner {
1529         payable(msg.sender).transfer(address(this).balance);
1530     }
1531 }