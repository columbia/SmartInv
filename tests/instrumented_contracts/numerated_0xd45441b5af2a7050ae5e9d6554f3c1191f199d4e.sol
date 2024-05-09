1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14     uint8 private constant _ADDRESS_LENGTH = 20;
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
74      */
75     function toHexString(address addr) internal pure returns (string memory) {
76         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
77     }
78 }
79 
80 // File: @openzeppelin/contracts/utils/Context.sol
81 
82 
83 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes calldata) {
103         return msg.data;
104     }
105 }
106 
107 // File: @openzeppelin/contracts/access/Ownable.sol
108 
109 
110 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 
115 /**
116  * @dev Contract module which provides a basic access control mechanism, where
117  * there is an account (an owner) that can be granted exclusive access to
118  * specific functions.
119  *
120  * By default, the owner account will be the one that deploys the contract. This
121  * can later be changed with {transferOwnership}.
122  *
123  * This module is used through inheritance. It will make available the modifier
124  * `onlyOwner`, which can be applied to your functions to restrict their use to
125  * the owner.
126  */
127 abstract contract Ownable is Context {
128     address private _owner;
129 
130     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
131 
132     /**
133      * @dev Initializes the contract setting the deployer as the initial owner.
134      */
135     constructor() {
136         _transferOwnership(_msgSender());
137     }
138 
139     /**
140      * @dev Throws if called by any account other than the owner.
141      */
142     modifier onlyOwner() {
143         _checkOwner();
144         _;
145     }
146 
147     /**
148      * @dev Returns the address of the current owner.
149      */
150     function owner() public view virtual returns (address) {
151         return _owner;
152     }
153 
154     /**
155      * @dev Throws if the sender is not the owner.
156      */
157     function _checkOwner() internal view virtual {
158         require(owner() == _msgSender(), "Ownable: caller is not the owner");
159     }
160 
161     /**
162      * @dev Leaves the contract without owner. It will not be possible to call
163      * `onlyOwner` functions anymore. Can only be called by the current owner.
164      *
165      * NOTE: Renouncing ownership will leave the contract without an owner,
166      * thereby removing any functionality that is only available to the owner.
167      */
168     function renounceOwnership() public virtual onlyOwner {
169         _transferOwnership(address(0));
170     }
171 
172     /**
173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
174      * Can only be called by the current owner.
175      */
176     function transferOwnership(address newOwner) public virtual onlyOwner {
177         require(newOwner != address(0), "Ownable: new owner is the zero address");
178         _transferOwnership(newOwner);
179     }
180 
181     /**
182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
183      * Internal function without access restriction.
184      */
185     function _transferOwnership(address newOwner) internal virtual {
186         address oldOwner = _owner;
187         _owner = newOwner;
188         emit OwnershipTransferred(oldOwner, newOwner);
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/Counters.sol
193 
194 
195 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @title Counters
201  * @author Matt Condon (@shrugs)
202  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
203  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
204  *
205  * Include with `using Counters for Counters.Counter;`
206  */
207 library Counters {
208     struct Counter {
209         // This variable should never be directly accessed by users of the library: interactions must be restricted to
210         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
211         // this feature: see https://github.com/ethereum/solidity/issues/4637
212         uint256 _value; // default: 0
213     }
214 
215     function current(Counter storage counter) internal view returns (uint256) {
216         return counter._value;
217     }
218 
219     function increment(Counter storage counter) internal {
220         unchecked {
221             counter._value += 1;
222         }
223     }
224 
225     function decrement(Counter storage counter) internal {
226         uint256 value = counter._value;
227         require(value > 0, "Counter: decrement overflow");
228         unchecked {
229             counter._value = value - 1;
230         }
231     }
232 
233     function reset(Counter storage counter) internal {
234         counter._value = 0;
235     }
236 }
237 
238 // File: contracts/IERC721A.sol
239 
240 
241 // ERC721A Contracts v4.1.0
242 // Creator: Chiru Labs
243 
244 pragma solidity ^0.8.4;
245 
246 /**
247  * @dev Interface of an ERC721A compliant contract.
248  */
249 interface IERC721A {
250     /**
251      * The caller must own the token or be an approved operator.
252      */
253     error ApprovalCallerNotOwnerNorApproved();
254 
255     /**
256      * The token does not exist.
257      */
258     error ApprovalQueryForNonexistentToken();
259 
260     /**
261      * The caller cannot approve to their own address.
262      */
263     error ApproveToCaller();
264 
265     /**
266      * Cannot query the balance for the zero address.
267      */
268     error BalanceQueryForZeroAddress();
269 
270     /**
271      * Cannot mint to the zero address.
272      */
273     error MintToZeroAddress();
274 
275     /**
276      * The quantity of tokens minted must be more than zero.
277      */
278     error MintZeroQuantity();
279 
280     /**
281      * The token does not exist.
282      */
283     error OwnerQueryForNonexistentToken();
284 
285     /**
286      * The caller must own the token or be an approved operator.
287      */
288     error TransferCallerNotOwnerNorApproved();
289 
290     /**
291      * The token must be owned by `from`.
292      */
293     error TransferFromIncorrectOwner();
294 
295     /**
296      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
297      */
298     error TransferToNonERC721ReceiverImplementer();
299 
300     /**
301      * Cannot transfer to the zero address.
302      */
303     error TransferToZeroAddress();
304 
305     /**
306      * The token does not exist.
307      */
308     error URIQueryForNonexistentToken();
309 
310     /**
311      * The `quantity` minted with ERC2309 exceeds the safety limit.
312      */
313     error MintERC2309QuantityExceedsLimit();
314 
315     /**
316      * The `extraData` cannot be set on an unintialized ownership slot.
317      */
318     error OwnershipNotInitializedForExtraData();
319 
320     struct TokenOwnership {
321         // The address of the owner.
322         address addr;
323         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
324         uint64 startTimestamp;
325         // Whether the token has been burned.
326         bool burned;
327         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
328         uint24 extraData;
329     }
330 
331     /**
332      * @dev Returns the total amount of tokens stored by the contract.
333      *
334      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
335      */
336     function totalSupply() external view returns (uint256);
337 
338     // ==============================
339     //            IERC165
340     // ==============================
341 
342     /**
343      * @dev Returns true if this contract implements the interface defined by
344      * `interfaceId`. See the corresponding
345      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
346      * to learn more about how these ids are created.
347      *
348      * This function call must use less than 30 000 gas.
349      */
350     function supportsInterface(bytes4 interfaceId) external view returns (bool);
351 
352     // ==============================
353     //            IERC721
354     // ==============================
355 
356     /**
357      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
358      */
359     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
360 
361     /**
362      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
363      */
364     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
365 
366     /**
367      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
368      */
369     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
370 
371     /**
372      * @dev Returns the number of tokens in ``owner``'s account.
373      */
374     function balanceOf(address owner) external view returns (uint256 balance);
375 
376     /**
377      * @dev Returns the owner of the `tokenId` token.
378      *
379      * Requirements:
380      *
381      * - `tokenId` must exist.
382      */
383     function ownerOf(uint256 tokenId) external view returns (address owner);
384 
385     /**
386      * @dev Safely transfers `tokenId` token from `from` to `to`.
387      *
388      * Requirements:
389      *
390      * - `from` cannot be the zero address.
391      * - `to` cannot be the zero address.
392      * - `tokenId` token must exist and be owned by `from`.
393      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
394      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
395      *
396      * Emits a {Transfer} event.
397      */
398     function safeTransferFrom(
399         address from,
400         address to,
401         uint256 tokenId,
402         bytes calldata data
403     ) external;
404 
405     /**
406      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
407      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
408      *
409      * Requirements:
410      *
411      * - `from` cannot be the zero address.
412      * - `to` cannot be the zero address.
413      * - `tokenId` token must exist and be owned by `from`.
414      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
415      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
416      *
417      * Emits a {Transfer} event.
418      */
419     function safeTransferFrom(
420         address from,
421         address to,
422         uint256 tokenId
423     ) external;
424 
425     /**
426      * @dev Transfers `tokenId` token from `from` to `to`.
427      *
428      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must be owned by `from`.
435      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
436      *
437      * Emits a {Transfer} event.
438      */
439     function transferFrom(
440         address from,
441         address to,
442         uint256 tokenId
443     ) external;
444 
445     /**
446      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
447      * The approval is cleared when the token is transferred.
448      *
449      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
450      *
451      * Requirements:
452      *
453      * - The caller must own the token or be an approved operator.
454      * - `tokenId` must exist.
455      *
456      * Emits an {Approval} event.
457      */
458     function approve(address to, uint256 tokenId) external;
459 
460     /**
461      * @dev Approve or remove `operator` as an operator for the caller.
462      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
463      *
464      * Requirements:
465      *
466      * - The `operator` cannot be the caller.
467      *
468      * Emits an {ApprovalForAll} event.
469      */
470     function setApprovalForAll(address operator, bool _approved) external;
471 
472     /**
473      * @dev Returns the account approved for `tokenId` token.
474      *
475      * Requirements:
476      *
477      * - `tokenId` must exist.
478      */
479     function getApproved(uint256 tokenId) external view returns (address operator);
480 
481     /**
482      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
483      *
484      * See {setApprovalForAll}
485      */
486     function isApprovedForAll(address owner, address operator) external view returns (bool);
487 
488     // ==============================
489     //        IERC721Metadata
490     // ==============================
491 
492     /**
493      * @dev Returns the token collection name.
494      */
495     function name() external view returns (string memory);
496 
497     /**
498      * @dev Returns the token collection symbol.
499      */
500     function symbol() external view returns (string memory);
501 
502     /**
503      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
504      */
505     function tokenURI(uint256 tokenId) external view returns (string memory);
506 
507     // ==============================
508     //            IERC2309
509     // ==============================
510 
511     /**
512      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
513      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
514      */
515     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
516 }
517 
518 // File: contracts/ERC721A.sol
519 
520 
521 // ERC721A Contracts v4.1.0
522 // Creator: Chiru Labs
523 
524 pragma solidity ^0.8.4;
525 
526 
527 /**
528  * @dev ERC721 token receiver interface.
529  */
530 interface ERC721A__IERC721Receiver {
531     function onERC721Received(
532         address operator,
533         address from,
534         uint256 tokenId,
535         bytes calldata data
536     ) external returns (bytes4);
537 }
538 
539 /**
540  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
541  * including the Metadata extension. Built to optimize for lower gas during batch mints.
542  *
543  * Assumes serials are sequentially minted starting at `_startTokenId()`
544  * (defaults to 0, e.g. 0, 1, 2, 3..).
545  *
546  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
547  *
548  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
549  */
550 contract ERC721A is IERC721A {
551     // Mask of an entry in packed address data.
552     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
553 
554     // The bit position of `numberMinted` in packed address data.
555     uint256 private constant BITPOS_NUMBER_MINTED = 64;
556 
557     // The bit position of `numberBurned` in packed address data.
558     uint256 private constant BITPOS_NUMBER_BURNED = 128;
559 
560     // The bit position of `aux` in packed address data.
561     uint256 private constant BITPOS_AUX = 192;
562 
563     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
564     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
565 
566     // The bit position of `startTimestamp` in packed ownership.
567     uint256 private constant BITPOS_START_TIMESTAMP = 160;
568 
569     // The bit mask of the `burned` bit in packed ownership.
570     uint256 private constant BITMASK_BURNED = 1 << 224;
571 
572     // The bit position of the `nextInitialized` bit in packed ownership.
573     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
574 
575     // The bit mask of the `nextInitialized` bit in packed ownership.
576     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
577 
578     // The bit position of `extraData` in packed ownership.
579     uint256 private constant BITPOS_EXTRA_DATA = 232;
580 
581     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
582     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
583 
584     // The mask of the lower 160 bits for addresses.
585     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
586 
587     // The maximum `quantity` that can be minted with `_mintERC2309`.
588     // This limit is to prevent overflows on the address data entries.
589     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
590     // is required to cause an overflow, which is unrealistic.
591     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
592 
593     // The tokenId of the next token to be minted.
594     uint256 private _currentIndex;
595 
596     // The number of tokens burned.
597     uint256 private _burnCounter;
598 
599     // Token name
600     string private _name;
601 
602     // Token symbol
603     string private _symbol;
604 
605     // Mapping from token ID to ownership details
606     // An empty struct value does not necessarily mean the token is unowned.
607     // See `_packedOwnershipOf` implementation for details.
608     //
609     // Bits Layout:
610     // - [0..159]   `addr`
611     // - [160..223] `startTimestamp`
612     // - [224]      `burned`
613     // - [225]      `nextInitialized`
614     // - [232..255] `extraData`
615     mapping(uint256 => uint256) private _packedOwnerships;
616 
617     // Mapping owner address to address data.
618     //
619     // Bits Layout:
620     // - [0..63]    `balance`
621     // - [64..127]  `numberMinted`
622     // - [128..191] `numberBurned`
623     // - [192..255] `aux`
624     mapping(address => uint256) private _packedAddressData;
625 
626     // Mapping from token ID to approved address.
627     mapping(uint256 => address) private _tokenApprovals;
628 
629     // Mapping from owner to operator approvals
630     mapping(address => mapping(address => bool)) private _operatorApprovals;
631 
632     constructor(string memory name_, string memory symbol_) {
633         _name = name_;
634         _symbol = symbol_;
635         _currentIndex = _startTokenId();
636     }
637 
638     /**
639      * @dev Returns the starting token ID.
640      * To change the starting token ID, please override this function.
641      */
642     function _startTokenId() internal view virtual returns (uint256) {
643         return 0;
644     }
645 
646     /**
647      * @dev Returns the next token ID to be minted.
648      */
649     function _nextTokenId() internal view returns (uint256) {
650         return _currentIndex;
651     }
652 
653     /**
654      * @dev Returns the total number of tokens in existence.
655      * Burned tokens will reduce the count.
656      * To get the total number of tokens minted, please see `_totalMinted`.
657      */
658     function totalSupply() public view override returns (uint256) {
659         // Counter underflow is impossible as _burnCounter cannot be incremented
660         // more than `_currentIndex - _startTokenId()` times.
661         unchecked {
662             return _currentIndex - _burnCounter - _startTokenId();
663         }
664     }
665 
666     /**
667      * @dev Returns the total amount of tokens minted in the contract.
668      */
669     function _totalMinted() internal view returns (uint256) {
670         // Counter underflow is impossible as _currentIndex does not decrement,
671         // and it is initialized to `_startTokenId()`
672         unchecked {
673             return _currentIndex - _startTokenId();
674         }
675     }
676 
677     /**
678      * @dev Returns the total number of tokens burned.
679      */
680     function _totalBurned() internal view returns (uint256) {
681         return _burnCounter;
682     }
683 
684     /**
685      * @dev See {IERC165-supportsInterface}.
686      */
687     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
688         // The interface IDs are constants representing the first 4 bytes of the XOR of
689         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
690         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
691         return
692             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
693             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
694             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
695     }
696 
697     /**
698      * @dev See {IERC721-balanceOf}.
699      */
700     function balanceOf(address owner) public view override returns (uint256) {
701         if (owner == address(0)) revert BalanceQueryForZeroAddress();
702         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
703     }
704 
705     /**
706      * Returns the number of tokens minted by `owner`.
707      */
708     function _numberMinted(address owner) internal view returns (uint256) {
709         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
710     }
711 
712     /**
713      * Returns the number of tokens burned by or on behalf of `owner`.
714      */
715     function _numberBurned(address owner) internal view returns (uint256) {
716         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
717     }
718 
719     /**
720      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
721      */
722     function _getAux(address owner) internal view returns (uint64) {
723         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
724     }
725 
726     /**
727      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
728      * If there are multiple variables, please pack them into a uint64.
729      */
730     function _setAux(address owner, uint64 aux) internal {
731         uint256 packed = _packedAddressData[owner];
732         uint256 auxCasted;
733         // Cast `aux` with assembly to avoid redundant masking.
734         assembly {
735             auxCasted := aux
736         }
737         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
738         _packedAddressData[owner] = packed;
739     }
740 
741     /**
742      * Returns the packed ownership data of `tokenId`.
743      */
744     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
745         uint256 curr = tokenId;
746 
747         unchecked {
748             if (_startTokenId() <= curr)
749                 if (curr < _currentIndex) {
750                     uint256 packed = _packedOwnerships[curr];
751                     // If not burned.
752                     if (packed & BITMASK_BURNED == 0) {
753                         // Invariant:
754                         // There will always be an ownership that has an address and is not burned
755                         // before an ownership that does not have an address and is not burned.
756                         // Hence, curr will not underflow.
757                         //
758                         // We can directly compare the packed value.
759                         // If the address is zero, packed is zero.
760                         while (packed == 0) {
761                             packed = _packedOwnerships[--curr];
762                         }
763                         return packed;
764                     }
765                 }
766         }
767         revert OwnerQueryForNonexistentToken();
768     }
769 
770     /**
771      * Returns the unpacked `TokenOwnership` struct from `packed`.
772      */
773     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
774         ownership.addr = address(uint160(packed));
775         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
776         ownership.burned = packed & BITMASK_BURNED != 0;
777         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
778     }
779 
780     /**
781      * Returns the unpacked `TokenOwnership` struct at `index`.
782      */
783     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
784         return _unpackedOwnership(_packedOwnerships[index]);
785     }
786 
787     /**
788      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
789      */
790     function _initializeOwnershipAt(uint256 index) internal {
791         if (_packedOwnerships[index] == 0) {
792             _packedOwnerships[index] = _packedOwnershipOf(index);
793         }
794     }
795 
796     /**
797      * Gas spent here starts off proportional to the maximum mint batch size.
798      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
799      */
800     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
801         return _unpackedOwnership(_packedOwnershipOf(tokenId));
802     }
803 
804     /**
805      * @dev Packs ownership data into a single uint256.
806      */
807     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
808         assembly {
809             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
810             owner := and(owner, BITMASK_ADDRESS)
811             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
812             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
813         }
814     }
815 
816     /**
817      * @dev See {IERC721-ownerOf}.
818      */
819     function ownerOf(uint256 tokenId) public view override returns (address) {
820         return address(uint160(_packedOwnershipOf(tokenId)));
821     }
822 
823     /**
824      * @dev See {IERC721Metadata-name}.
825      */
826     function name() public view virtual override returns (string memory) {
827         return _name;
828     }
829 
830     /**
831      * @dev See {IERC721Metadata-symbol}.
832      */
833     function symbol() public view virtual override returns (string memory) {
834         return _symbol;
835     }
836 
837     /**
838      * @dev See {IERC721Metadata-tokenURI}.
839      */
840     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
841         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
842 
843         string memory baseURI = _baseURI();
844         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
845     }
846 
847     /**
848      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
849      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
850      * by default, it can be overridden in child contracts.
851      */
852     function _baseURI() internal view virtual returns (string memory) {
853         return '';
854     }
855 
856     /**
857      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
858      */
859     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
860         // For branchless setting of the `nextInitialized` flag.
861         assembly {
862             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
863             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
864         }
865     }
866 
867     /**
868      * @dev See {IERC721-approve}.
869      */
870     function approve(address to, uint256 tokenId) public override {
871         address owner = ownerOf(tokenId);
872 
873         if (_msgSenderERC721A() != owner)
874             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
875                 revert ApprovalCallerNotOwnerNorApproved();
876             }
877 
878         _tokenApprovals[tokenId] = to;
879         emit Approval(owner, to, tokenId);
880     }
881 
882     /**
883      * @dev See {IERC721-getApproved}.
884      */
885     function getApproved(uint256 tokenId) public view override returns (address) {
886         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
887 
888         return _tokenApprovals[tokenId];
889     }
890 
891     /**
892      * @dev See {IERC721-setApprovalForAll}.
893      */
894     function setApprovalForAll(address operator, bool approved) public virtual override {
895         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
896 
897         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
898         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
899     }
900 
901     /**
902      * @dev See {IERC721-isApprovedForAll}.
903      */
904     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
905         return _operatorApprovals[owner][operator];
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
928         transferFrom(from, to, tokenId);
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
965      * See {_mint}.
966      *
967      * Emits a {Transfer} event for each mint.
968      */
969     function _safeMint(
970         address to,
971         uint256 quantity,
972         bytes memory _data
973     ) internal {
974         _mint(to, quantity);
975 
976         unchecked {
977             if (to.code.length != 0) {
978                 uint256 end = _currentIndex;
979                 uint256 index = end - quantity;
980                 do {
981                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
982                         revert TransferToNonERC721ReceiverImplementer();
983                     }
984                 } while (index < end);
985                 // Reentrancy protection.
986                 if (_currentIndex != end) revert();
987             }
988         }
989     }
990 
991     /**
992      * @dev Mints `quantity` tokens and transfers them to `to`.
993      *
994      * Requirements:
995      *
996      * - `to` cannot be the zero address.
997      * - `quantity` must be greater than 0.
998      *
999      * Emits a {Transfer} event for each mint.
1000      */
1001     function _mint(address to, uint256 quantity) internal {
1002         uint256 startTokenId = _currentIndex;
1003         if (to == address(0)) revert MintToZeroAddress();
1004         if (quantity == 0) revert MintZeroQuantity();
1005 
1006         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1007 
1008         // Overflows are incredibly unrealistic.
1009         // `balance` and `numberMinted` have a maximum limit of 2**64.
1010         // `tokenId` has a maximum limit of 2**256.
1011         unchecked {
1012             // Updates:
1013             // - `balance += quantity`.
1014             // - `numberMinted += quantity`.
1015             //
1016             // We can directly add to the `balance` and `numberMinted`.
1017             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1018 
1019             // Updates:
1020             // - `address` to the owner.
1021             // - `startTimestamp` to the timestamp of minting.
1022             // - `burned` to `false`.
1023             // - `nextInitialized` to `quantity == 1`.
1024             _packedOwnerships[startTokenId] = _packOwnershipData(
1025                 to,
1026                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1027             );
1028 
1029             uint256 tokenId = startTokenId;
1030             uint256 end = startTokenId + quantity;
1031             do {
1032                 emit Transfer(address(0), to, tokenId++);
1033             } while (tokenId < end);
1034 
1035             _currentIndex = end;
1036         }
1037         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1038     }
1039 
1040     /**
1041      * @dev Mints `quantity` tokens and transfers them to `to`.
1042      *
1043      * This function is intended for efficient minting only during contract creation.
1044      *
1045      * It emits only one {ConsecutiveTransfer} as defined in
1046      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1047      * instead of a sequence of {Transfer} event(s).
1048      *
1049      * Calling this function outside of contract creation WILL make your contract
1050      * non-compliant with the ERC721 standard.
1051      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1052      * {ConsecutiveTransfer} event is only permissible during contract creation.
1053      *
1054      * Requirements:
1055      *
1056      * - `to` cannot be the zero address.
1057      * - `quantity` must be greater than 0.
1058      *
1059      * Emits a {ConsecutiveTransfer} event.
1060      */
1061     function _mintERC2309(address to, uint256 quantity) internal {
1062         uint256 startTokenId = _currentIndex;
1063         if (to == address(0)) revert MintToZeroAddress();
1064         if (quantity == 0) revert MintZeroQuantity();
1065         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1066 
1067         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1068 
1069         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1070         unchecked {
1071             // Updates:
1072             // - `balance += quantity`.
1073             // - `numberMinted += quantity`.
1074             //
1075             // We can directly add to the `balance` and `numberMinted`.
1076             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1077 
1078             // Updates:
1079             // - `address` to the owner.
1080             // - `startTimestamp` to the timestamp of minting.
1081             // - `burned` to `false`.
1082             // - `nextInitialized` to `quantity == 1`.
1083             _packedOwnerships[startTokenId] = _packOwnershipData(
1084                 to,
1085                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1086             );
1087 
1088             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1089 
1090             _currentIndex = startTokenId + quantity;
1091         }
1092         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1093     }
1094 
1095     /**
1096      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1097      */
1098     function _getApprovedAddress(uint256 tokenId)
1099         private
1100         view
1101         returns (uint256 approvedAddressSlot, address approvedAddress)
1102     {
1103         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1104         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1105         assembly {
1106             // Compute the slot.
1107             mstore(0x00, tokenId)
1108             mstore(0x20, tokenApprovalsPtr.slot)
1109             approvedAddressSlot := keccak256(0x00, 0x40)
1110             // Load the slot's value from storage.
1111             approvedAddress := sload(approvedAddressSlot)
1112         }
1113     }
1114 
1115     /**
1116      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1117      */
1118     function _isOwnerOrApproved(
1119         address approvedAddress,
1120         address from,
1121         address msgSender
1122     ) private pure returns (bool result) {
1123         assembly {
1124             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1125             from := and(from, BITMASK_ADDRESS)
1126             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1127             msgSender := and(msgSender, BITMASK_ADDRESS)
1128             // `msgSender == from || msgSender == approvedAddress`.
1129             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1130         }
1131     }
1132 
1133     /**
1134      * @dev Transfers `tokenId` from `from` to `to`.
1135      *
1136      * Requirements:
1137      *
1138      * - `to` cannot be the zero address.
1139      * - `tokenId` token must be owned by `from`.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function transferFrom(
1144         address from,
1145         address to,
1146         uint256 tokenId
1147     ) public virtual override {
1148         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1149 
1150         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1151 
1152         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1153 
1154         // The nested ifs save around 20+ gas over a compound boolean condition.
1155         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1156             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1157 
1158         if (to == address(0)) revert TransferToZeroAddress();
1159 
1160         _beforeTokenTransfers(from, to, tokenId, 1);
1161 
1162         // Clear approvals from the previous owner.
1163         assembly {
1164             if approvedAddress {
1165                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1166                 sstore(approvedAddressSlot, 0)
1167             }
1168         }
1169 
1170         // Underflow of the sender's balance is impossible because we check for
1171         // ownership above and the recipient's balance can't realistically overflow.
1172         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1173         unchecked {
1174             // We can directly increment and decrement the balances.
1175             --_packedAddressData[from]; // Updates: `balance -= 1`.
1176             ++_packedAddressData[to]; // Updates: `balance += 1`.
1177 
1178             // Updates:
1179             // - `address` to the next owner.
1180             // - `startTimestamp` to the timestamp of transfering.
1181             // - `burned` to `false`.
1182             // - `nextInitialized` to `true`.
1183             _packedOwnerships[tokenId] = _packOwnershipData(
1184                 to,
1185                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1186             );
1187 
1188             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1189             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1190                 uint256 nextTokenId = tokenId + 1;
1191                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1192                 if (_packedOwnerships[nextTokenId] == 0) {
1193                     // If the next slot is within bounds.
1194                     if (nextTokenId != _currentIndex) {
1195                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1196                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1197                     }
1198                 }
1199             }
1200         }
1201 
1202         emit Transfer(from, to, tokenId);
1203         _afterTokenTransfers(from, to, tokenId, 1);
1204     }
1205 
1206     /**
1207      * @dev Equivalent to `_burn(tokenId, false)`.
1208      */
1209     function _burn(uint256 tokenId) internal virtual {
1210         _burn(tokenId, false);
1211     }
1212 
1213     /**
1214      * @dev Destroys `tokenId`.
1215      * The approval is cleared when the token is burned.
1216      *
1217      * Requirements:
1218      *
1219      * - `tokenId` must exist.
1220      *
1221      * Emits a {Transfer} event.
1222      */
1223     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1224         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1225 
1226         address from = address(uint160(prevOwnershipPacked));
1227 
1228         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1229 
1230         if (approvalCheck) {
1231             // The nested ifs save around 20+ gas over a compound boolean condition.
1232             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1233                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1234         }
1235 
1236         _beforeTokenTransfers(from, address(0), tokenId, 1);
1237 
1238         // Clear approvals from the previous owner.
1239         assembly {
1240             if approvedAddress {
1241                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1242                 sstore(approvedAddressSlot, 0)
1243             }
1244         }
1245 
1246         // Underflow of the sender's balance is impossible because we check for
1247         // ownership above and the recipient's balance can't realistically overflow.
1248         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1249         unchecked {
1250             // Updates:
1251             // - `balance -= 1`.
1252             // - `numberBurned += 1`.
1253             //
1254             // We can directly decrement the balance, and increment the number burned.
1255             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1256             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1257 
1258             // Updates:
1259             // - `address` to the last owner.
1260             // - `startTimestamp` to the timestamp of burning.
1261             // - `burned` to `true`.
1262             // - `nextInitialized` to `true`.
1263             _packedOwnerships[tokenId] = _packOwnershipData(
1264                 from,
1265                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1266             );
1267 
1268             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1269             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1270                 uint256 nextTokenId = tokenId + 1;
1271                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1272                 if (_packedOwnerships[nextTokenId] == 0) {
1273                     // If the next slot is within bounds.
1274                     if (nextTokenId != _currentIndex) {
1275                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1276                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1277                     }
1278                 }
1279             }
1280         }
1281 
1282         emit Transfer(from, address(0), tokenId);
1283         _afterTokenTransfers(from, address(0), tokenId, 1);
1284 
1285         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1286         unchecked {
1287             _burnCounter++;
1288         }
1289     }
1290 
1291     /**
1292      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1293      *
1294      * @param from address representing the previous owner of the given token ID
1295      * @param to target address that will receive the tokens
1296      * @param tokenId uint256 ID of the token to be transferred
1297      * @param _data bytes optional data to send along with the call
1298      * @return bool whether the call correctly returned the expected magic value
1299      */
1300     function _checkContractOnERC721Received(
1301         address from,
1302         address to,
1303         uint256 tokenId,
1304         bytes memory _data
1305     ) private returns (bool) {
1306         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1307             bytes4 retval
1308         ) {
1309             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1310         } catch (bytes memory reason) {
1311             if (reason.length == 0) {
1312                 revert TransferToNonERC721ReceiverImplementer();
1313             } else {
1314                 assembly {
1315                     revert(add(32, reason), mload(reason))
1316                 }
1317             }
1318         }
1319     }
1320 
1321     /**
1322      * @dev Directly sets the extra data for the ownership data `index`.
1323      */
1324     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1325         uint256 packed = _packedOwnerships[index];
1326         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1327         uint256 extraDataCasted;
1328         // Cast `extraData` with assembly to avoid redundant masking.
1329         assembly {
1330             extraDataCasted := extraData
1331         }
1332         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1333         _packedOwnerships[index] = packed;
1334     }
1335 
1336     /**
1337      * @dev Returns the next extra data for the packed ownership data.
1338      * The returned result is shifted into position.
1339      */
1340     function _nextExtraData(
1341         address from,
1342         address to,
1343         uint256 prevOwnershipPacked
1344     ) private view returns (uint256) {
1345         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1346         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1347     }
1348 
1349     /**
1350      * @dev Called during each token transfer to set the 24bit `extraData` field.
1351      * Intended to be overridden by the cosumer contract.
1352      *
1353      * `previousExtraData` - the value of `extraData` before transfer.
1354      *
1355      * Calling conditions:
1356      *
1357      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1358      * transferred to `to`.
1359      * - When `from` is zero, `tokenId` will be minted for `to`.
1360      * - When `to` is zero, `tokenId` will be burned by `from`.
1361      * - `from` and `to` are never both zero.
1362      */
1363     function _extraData(
1364         address from,
1365         address to,
1366         uint24 previousExtraData
1367     ) internal view virtual returns (uint24) {}
1368 
1369     /**
1370      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1371      * This includes minting.
1372      * And also called before burning one token.
1373      *
1374      * startTokenId - the first token id to be transferred
1375      * quantity - the amount to be transferred
1376      *
1377      * Calling conditions:
1378      *
1379      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1380      * transferred to `to`.
1381      * - When `from` is zero, `tokenId` will be minted for `to`.
1382      * - When `to` is zero, `tokenId` will be burned by `from`.
1383      * - `from` and `to` are never both zero.
1384      */
1385     function _beforeTokenTransfers(
1386         address from,
1387         address to,
1388         uint256 startTokenId,
1389         uint256 quantity
1390     ) internal virtual {}
1391 
1392     /**
1393      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1394      * This includes minting.
1395      * And also called after one token has been burned.
1396      *
1397      * startTokenId - the first token id to be transferred
1398      * quantity - the amount to be transferred
1399      *
1400      * Calling conditions:
1401      *
1402      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1403      * transferred to `to`.
1404      * - When `from` is zero, `tokenId` has been minted for `to`.
1405      * - When `to` is zero, `tokenId` has been burned by `from`.
1406      * - `from` and `to` are never both zero.
1407      */
1408     function _afterTokenTransfers(
1409         address from,
1410         address to,
1411         uint256 startTokenId,
1412         uint256 quantity
1413     ) internal virtual {}
1414 
1415     /**
1416      * @dev Returns the message sender (defaults to `msg.sender`).
1417      *
1418      * If you are writing GSN compatible contracts, you need to override this function.
1419      */
1420     function _msgSenderERC721A() internal view virtual returns (address) {
1421         return msg.sender;
1422     }
1423 
1424     /**
1425      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1426      */
1427     function _toString(uint256 value) internal pure returns (string memory ptr) {
1428         assembly {
1429             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1430             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1431             // We will need 1 32-byte word to store the length,
1432             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1433             ptr := add(mload(0x40), 128)
1434             // Update the free memory pointer to allocate.
1435             mstore(0x40, ptr)
1436 
1437             // Cache the end of the memory to calculate the length later.
1438             let end := ptr
1439 
1440             // We write the string from the rightmost digit to the leftmost digit.
1441             // The following is essentially a do-while loop that also handles the zero case.
1442             // Costs a bit more than early returning for the zero case,
1443             // but cheaper in terms of deployment and overall runtime costs.
1444             for {
1445                 // Initialize and perform the first pass without check.
1446                 let temp := value
1447                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1448                 ptr := sub(ptr, 1)
1449                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1450                 mstore8(ptr, add(48, mod(temp, 10)))
1451                 temp := div(temp, 10)
1452             } temp {
1453                 // Keep dividing `temp` until zero.
1454                 temp := div(temp, 10)
1455             } {
1456                 // Body of the for loop.
1457                 ptr := sub(ptr, 1)
1458                 mstore8(ptr, add(48, mod(temp, 10)))
1459             }
1460 
1461             let length := sub(end, ptr)
1462             // Move the pointer 32 bytes leftwards to make room for the length.
1463             ptr := sub(ptr, 32)
1464             // Store the length.
1465             mstore(ptr, length)
1466         }
1467     }
1468 }
1469 
1470 // File: contracts/Gen2Gorillas.sol
1471 
1472 
1473 
1474 // Edited by Cindy Horn - Extended ERC721A
1475 // 4/15/22 - Created a Presale
1476 
1477 // Amended by HashLips
1478 
1479 pragma solidity >=0.7.0 <0.9.0;
1480 
1481 
1482 
1483 
1484 
1485 contract Gen2Corillas is Ownable, ERC721A {
1486   using Strings for uint256;
1487   using Counters for Counters.Counter;
1488 
1489   Counters.Counter private supply;
1490 
1491   string private uriPrefix = "";
1492   string public uriSuffix = ".json";
1493   string public hiddenMetadataUri;
1494   
1495   uint256 public cost = 0.032 ether;
1496   uint256 public maxSupply = 8888;
1497   uint256 public maxMintAmountPerTx = 10000;
1498 
1499   bool public paused = true;
1500   bool public revealed = true;
1501 
1502   constructor(
1503     string memory _name,
1504     string memory _symbol,
1505     string memory _initBaseURI,
1506     string memory _initNotRevealedUri) ERC721A(_name, _symbol) {
1507     uriPrefix = _initBaseURI;
1508     setHiddenMetadataUri(_initNotRevealedUri);
1509   }
1510 
1511   modifier mintCompliance(uint256 _mintAmount) {
1512     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1513     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1514     _;
1515   }
1516 
1517   modifier callerIsUser() {
1518      require(tx.origin == msg.sender, 'The caller is another contract.');
1519      _;
1520   }
1521   
1522   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) callerIsUser {
1523     require(!paused, "The contract is paused!");
1524     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1525 
1526     _safeMint(msg.sender, _mintAmount);
1527   }
1528   
1529   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1530     _safeMint(_receiver, _mintAmount);
1531   }
1532 
1533   function mintPresale(uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1534     _safeMint(msg.sender, _mintAmount);
1535   }
1536 
1537   function walletOfOwner(address _owner)
1538     public
1539     view
1540     returns (uint256[] memory)
1541   {
1542     uint256 ownerTokenCount = balanceOf(_owner);
1543     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1544     uint256 currentTokenId = 1;
1545     uint256 ownedTokenIndex = 0;
1546 
1547     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1548       if ( _exists( currentTokenId ) ) {
1549         address currentTokenOwner = ownerOf(currentTokenId);
1550 
1551         if (currentTokenOwner == _owner) {
1552           ownedTokenIds[ownedTokenIndex] = currentTokenId;
1553 
1554           ownedTokenIndex++;
1555         }
1556       }
1557       currentTokenId++;
1558     }
1559 
1560     return ownedTokenIds;
1561   }
1562     
1563   function tokenURI(uint256 _tokenId)
1564     public
1565     view
1566     virtual
1567     override
1568     returns (string memory)
1569   {
1570     require(
1571       _exists(_tokenId),
1572       "ERC721Metadata: URI query for nonexistent token"
1573     );
1574 
1575     if (revealed == false) {
1576       return hiddenMetadataUri;
1577     }
1578 
1579     string memory currentBaseURI = _baseURI();
1580     return bytes(currentBaseURI).length > 0
1581         ? string(abi.encodePacked(currentBaseURI, Strings.toString(_tokenId), uriSuffix))
1582         : "";
1583   }
1584 
1585   function setRevealed(bool _state) public onlyOwner {
1586     revealed = _state;
1587   }
1588 
1589   function setCost(uint256 _cost) public onlyOwner {
1590     cost = _cost;
1591   }
1592 
1593   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1594     maxSupply = _maxSupply;
1595   }
1596 
1597   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1598     maxMintAmountPerTx = _maxMintAmountPerTx;
1599   }
1600 
1601   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1602     hiddenMetadataUri = _hiddenMetadataUri;
1603   }
1604 
1605   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1606     uriPrefix = _uriPrefix;
1607   }
1608 
1609   function getUriPrefix() public view onlyOwner returns (string memory) {
1610     return uriPrefix;
1611   }
1612 
1613   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1614     uriSuffix = _uriSuffix;
1615   }
1616 
1617   function setPaused(bool _state) public onlyOwner {
1618     paused = _state;
1619   }
1620 
1621   function withdraw() public onlyOwner {
1622     // This will transfer the remaining contract balance to the owner.
1623     // Do not remove this otherwise you will not be able to withdraw the funds.
1624     // =============================================================================
1625     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1626     require(os);
1627     // =============================================================================
1628   }
1629 
1630   function _baseURI() internal view override virtual returns (string memory) {
1631     return uriPrefix;
1632   }
1633 
1634   function _startTokenId() internal view virtual override returns (uint256) {
1635     return 1;
1636   }
1637 
1638 }