1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
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
70 }
71 
72 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Contract module that helps prevent reentrant calls to a function.
81  *
82  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
83  * available, which can be applied to functions to make sure there are no nested
84  * (reentrant) calls to them.
85  *
86  * Note that because there is a single `nonReentrant` guard, functions marked as
87  * `nonReentrant` may not call one another. This can be worked around by making
88  * those functions `private`, and then adding `external` `nonReentrant` entry
89  * points to them.
90  *
91  * TIP: If you would like to learn more about reentrancy and alternative ways
92  * to protect against it, check out our blog post
93  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
94  */
95 abstract contract ReentrancyGuard {
96     // Booleans are more expensive than uint256 or any type that takes up a full
97     // word because each write operation emits an extra SLOAD to first read the
98     // slot's contents, replace the bits taken up by the boolean, and then write
99     // back. This is the compiler's defense against contract upgrades and
100     // pointer aliasing, and it cannot be disabled.
101 
102     // The values being non-zero value makes deployment a bit more expensive,
103     // but in exchange the refund on every call to nonReentrant will be lower in
104     // amount. Since refunds are capped to a percentage of the total
105     // transaction's gas, it is best to keep them low in cases like this one, to
106     // increase the likelihood of the full refund coming into effect.
107     uint256 private constant _NOT_ENTERED = 1;
108     uint256 private constant _ENTERED = 2;
109 
110     uint256 private _status;
111 
112     constructor() {
113         _status = _NOT_ENTERED;
114     }
115 
116     /**
117      * @dev Prevents a contract from calling itself, directly or indirectly.
118      * Calling a `nonReentrant` function from another `nonReentrant`
119      * function is not supported. It is possible to prevent this from happening
120      * by making the `nonReentrant` function external, and making it call a
121      * `private` function that does the actual work.
122      */
123     modifier nonReentrant() {
124         // On the first call to nonReentrant, _notEntered will be true
125         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
126 
127         // Any calls to nonReentrant after this point will fail
128         _status = _ENTERED;
129 
130         _;
131 
132         // By storing the original value once again, a refund is triggered (see
133         // https://eips.ethereum.org/EIPS/eip-2200)
134         _status = _NOT_ENTERED;
135     }
136 }
137 
138 // File: @openzeppelin/contracts/utils/Context.sol
139 
140 
141 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
142 
143 pragma solidity ^0.8.0;
144 
145 /**
146  * @dev Provides information about the current execution context, including the
147  * sender of the transaction and its data. While these are generally available
148  * via msg.sender and msg.data, they should not be accessed in such a direct
149  * manner, since when dealing with meta-transactions the account sending and
150  * paying for execution may not be the actual sender (as far as an application
151  * is concerned).
152  *
153  * This contract is only required for intermediate, library-like contracts.
154  */
155 abstract contract Context {
156     function _msgSender() internal view virtual returns (address) {
157         return msg.sender;
158     }
159 
160     function _msgData() internal view virtual returns (bytes calldata) {
161         return msg.data;
162     }
163 }
164 
165 // File: @openzeppelin/contracts/access/Ownable.sol
166 
167 
168 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 
173 /**
174  * @dev Contract module which provides a basic access control mechanism, where
175  * there is an account (an owner) that can be granted exclusive access to
176  * specific functions.
177  *
178  * By default, the owner account will be the one that deploys the contract. This
179  * can later be changed with {transferOwnership}.
180  *
181  * This module is used through inheritance. It will make available the modifier
182  * `onlyOwner`, which can be applied to your functions to restrict their use to
183  * the owner.
184  */
185 abstract contract Ownable is Context {
186     address private _owner;
187 
188     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190     /**
191      * @dev Initializes the contract setting the deployer as the initial owner.
192      */
193     constructor() {
194         _transferOwnership(_msgSender());
195     }
196 
197     /**
198      * @dev Returns the address of the current owner.
199      */
200     function owner() public view virtual returns (address) {
201         return _owner;
202     }
203 
204     /**
205      * @dev Throws if called by any account other than the owner.
206      */
207     modifier onlyOwner() {
208         require(owner() == _msgSender(), "Ownable: caller is not the owner");
209         _;
210     }
211 
212     /**
213      * @dev Leaves the contract without owner. It will not be possible to call
214      * `onlyOwner` functions anymore. Can only be called by the current owner.
215      *
216      * NOTE: Renouncing ownership will leave the contract without an owner,
217      * thereby removing any functionality that is only available to the owner.
218      */
219     function renounceOwnership() public virtual onlyOwner {
220         _transferOwnership(address(0));
221     }
222 
223     /**
224      * @dev Transfers ownership of the contract to a new account (`newOwner`).
225      * Can only be called by the current owner.
226      */
227     function transferOwnership(address newOwner) public virtual onlyOwner {
228         require(newOwner != address(0), "Ownable: new owner is the zero address");
229         _transferOwnership(newOwner);
230     }
231 
232     /**
233      * @dev Transfers ownership of the contract to a new account (`newOwner`).
234      * Internal function without access restriction.
235      */
236     function _transferOwnership(address newOwner) internal virtual {
237         address oldOwner = _owner;
238         _owner = newOwner;
239         emit OwnershipTransferred(oldOwner, newOwner);
240     }
241 }
242 
243 // File: erc721a/contracts/IERC721A.sol
244 
245 
246 // ERC721A Contracts v4.1.0
247 // Creator: Chiru Labs
248 
249 pragma solidity ^0.8.4;
250 
251 /**
252  * @dev Interface of an ERC721A compliant contract.
253  */
254 interface IERC721A {
255     /**
256      * The caller must own the token or be an approved operator.
257      */
258     error ApprovalCallerNotOwnerNorApproved();
259 
260     /**
261      * The token does not exist.
262      */
263     error ApprovalQueryForNonexistentToken();
264 
265     /**
266      * The caller cannot approve to their own address.
267      */
268     error ApproveToCaller();
269 
270     /**
271      * Cannot query the balance for the zero address.
272      */
273     error BalanceQueryForZeroAddress();
274 
275     /**
276      * Cannot mint to the zero address.
277      */
278     error MintToZeroAddress();
279 
280     /**
281      * The quantity of tokens minted must be more than zero.
282      */
283     error MintZeroQuantity();
284 
285     /**
286      * The token does not exist.
287      */
288     error OwnerQueryForNonexistentToken();
289 
290     /**
291      * The caller must own the token or be an approved operator.
292      */
293     error TransferCallerNotOwnerNorApproved();
294 
295     /**
296      * The token must be owned by `from`.
297      */
298     error TransferFromIncorrectOwner();
299 
300     /**
301      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
302      */
303     error TransferToNonERC721ReceiverImplementer();
304 
305     /**
306      * Cannot transfer to the zero address.
307      */
308     error TransferToZeroAddress();
309 
310     /**
311      * The token does not exist.
312      */
313     error URIQueryForNonexistentToken();
314 
315     /**
316      * The `quantity` minted with ERC2309 exceeds the safety limit.
317      */
318     error MintERC2309QuantityExceedsLimit();
319 
320     /**
321      * The `extraData` cannot be set on an unintialized ownership slot.
322      */
323     error OwnershipNotInitializedForExtraData();
324 
325     struct TokenOwnership {
326         // The address of the owner.
327         address addr;
328         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
329         uint64 startTimestamp;
330         // Whether the token has been burned.
331         bool burned;
332         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
333         uint24 extraData;
334     }
335 
336     /**
337      * @dev Returns the total amount of tokens stored by the contract.
338      *
339      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
340      */
341     function totalSupply() external view returns (uint256);
342 
343     // ==============================
344     //            IERC165
345     // ==============================
346 
347     /**
348      * @dev Returns true if this contract implements the interface defined by
349      * `interfaceId`. See the corresponding
350      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
351      * to learn more about how these ids are created.
352      *
353      * This function call must use less than 30 000 gas.
354      */
355     function supportsInterface(bytes4 interfaceId) external view returns (bool);
356 
357     // ==============================
358     //            IERC721
359     // ==============================
360 
361     /**
362      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
363      */
364     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
365 
366     /**
367      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
368      */
369     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
370 
371     /**
372      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
373      */
374     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
375 
376     /**
377      * @dev Returns the number of tokens in ``owner``'s account.
378      */
379     function balanceOf(address owner) external view returns (uint256 balance);
380 
381     /**
382      * @dev Returns the owner of the `tokenId` token.
383      *
384      * Requirements:
385      *
386      * - `tokenId` must exist.
387      */
388     function ownerOf(uint256 tokenId) external view returns (address owner);
389 
390     /**
391      * @dev Safely transfers `tokenId` token from `from` to `to`.
392      *
393      * Requirements:
394      *
395      * - `from` cannot be the zero address.
396      * - `to` cannot be the zero address.
397      * - `tokenId` token must exist and be owned by `from`.
398      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
399      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
400      *
401      * Emits a {Transfer} event.
402      */
403     function safeTransferFrom(
404         address from,
405         address to,
406         uint256 tokenId,
407         bytes calldata data
408     ) external;
409 
410     /**
411      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
412      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
413      *
414      * Requirements:
415      *
416      * - `from` cannot be the zero address.
417      * - `to` cannot be the zero address.
418      * - `tokenId` token must exist and be owned by `from`.
419      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
420      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
421      *
422      * Emits a {Transfer} event.
423      */
424     function safeTransferFrom(
425         address from,
426         address to,
427         uint256 tokenId
428     ) external;
429 
430     /**
431      * @dev Transfers `tokenId` token from `from` to `to`.
432      *
433      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
434      *
435      * Requirements:
436      *
437      * - `from` cannot be the zero address.
438      * - `to` cannot be the zero address.
439      * - `tokenId` token must be owned by `from`.
440      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
441      *
442      * Emits a {Transfer} event.
443      */
444     function transferFrom(
445         address from,
446         address to,
447         uint256 tokenId
448     ) external;
449 
450     /**
451      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
452      * The approval is cleared when the token is transferred.
453      *
454      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
455      *
456      * Requirements:
457      *
458      * - The caller must own the token or be an approved operator.
459      * - `tokenId` must exist.
460      *
461      * Emits an {Approval} event.
462      */
463     function approve(address to, uint256 tokenId) external;
464 
465     /**
466      * @dev Approve or remove `operator` as an operator for the caller.
467      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
468      *
469      * Requirements:
470      *
471      * - The `operator` cannot be the caller.
472      *
473      * Emits an {ApprovalForAll} event.
474      */
475     function setApprovalForAll(address operator, bool _approved) external;
476 
477     /**
478      * @dev Returns the account approved for `tokenId` token.
479      *
480      * Requirements:
481      *
482      * - `tokenId` must exist.
483      */
484     function getApproved(uint256 tokenId) external view returns (address operator);
485 
486     /**
487      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
488      *
489      * See {setApprovalForAll}
490      */
491     function isApprovedForAll(address owner, address operator) external view returns (bool);
492 
493     // ==============================
494     //        IERC721Metadata
495     // ==============================
496 
497     /**
498      * @dev Returns the token collection name.
499      */
500     function name() external view returns (string memory);
501 
502     /**
503      * @dev Returns the token collection symbol.
504      */
505     function symbol() external view returns (string memory);
506 
507     /**
508      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
509      */
510     function tokenURI(uint256 tokenId) external view returns (string memory);
511 
512     // ==============================
513     //            IERC2309
514     // ==============================
515 
516     /**
517      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
518      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
519      */
520     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
521 }
522 
523 // File: erc721a/contracts/ERC721A.sol
524 
525 
526 // ERC721A Contracts v4.1.0
527 // Creator: Chiru Labs
528 
529 pragma solidity ^0.8.4;
530 
531 
532 /**
533  * @dev ERC721 token receiver interface.
534  */
535 interface ERC721A__IERC721Receiver {
536     function onERC721Received(
537         address operator,
538         address from,
539         uint256 tokenId,
540         bytes calldata data
541     ) external returns (bytes4);
542 }
543 
544 /**
545  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
546  * including the Metadata extension. Built to optimize for lower gas during batch mints.
547  *
548  * Assumes serials are sequentially minted starting at `_startTokenId()`
549  * (defaults to 0, e.g. 0, 1, 2, 3..).
550  *
551  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
552  *
553  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
554  */
555 contract ERC721A is IERC721A {
556     // Mask of an entry in packed address data.
557     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
558 
559     // The bit position of `numberMinted` in packed address data.
560     uint256 private constant BITPOS_NUMBER_MINTED = 64;
561 
562     // The bit position of `numberBurned` in packed address data.
563     uint256 private constant BITPOS_NUMBER_BURNED = 128;
564 
565     // The bit position of `aux` in packed address data.
566     uint256 private constant BITPOS_AUX = 192;
567 
568     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
569     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
570 
571     // The bit position of `startTimestamp` in packed ownership.
572     uint256 private constant BITPOS_START_TIMESTAMP = 160;
573 
574     // The bit mask of the `burned` bit in packed ownership.
575     uint256 private constant BITMASK_BURNED = 1 << 224;
576 
577     // The bit position of the `nextInitialized` bit in packed ownership.
578     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
579 
580     // The bit mask of the `nextInitialized` bit in packed ownership.
581     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
582 
583     // The bit position of `extraData` in packed ownership.
584     uint256 private constant BITPOS_EXTRA_DATA = 232;
585 
586     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
587     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
588 
589     // The mask of the lower 160 bits for addresses.
590     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
591 
592     // The maximum `quantity` that can be minted with `_mintERC2309`.
593     // This limit is to prevent overflows on the address data entries.
594     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
595     // is required to cause an overflow, which is unrealistic.
596     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
597 
598     // The tokenId of the next token to be minted.
599     uint256 private _currentIndex;
600 
601     // The number of tokens burned.
602     uint256 private _burnCounter;
603 
604     // Token name
605     string private _name;
606 
607     // Token symbol
608     string private _symbol;
609 
610     // Mapping from token ID to ownership details
611     // An empty struct value does not necessarily mean the token is unowned.
612     // See `_packedOwnershipOf` implementation for details.
613     //
614     // Bits Layout:
615     // - [0..159]   `addr`
616     // - [160..223] `startTimestamp`
617     // - [224]      `burned`
618     // - [225]      `nextInitialized`
619     // - [232..255] `extraData`
620     mapping(uint256 => uint256) private _packedOwnerships;
621 
622     // Mapping owner address to address data.
623     //
624     // Bits Layout:
625     // - [0..63]    `balance`
626     // - [64..127]  `numberMinted`
627     // - [128..191] `numberBurned`
628     // - [192..255] `aux`
629     mapping(address => uint256) private _packedAddressData;
630 
631     // Mapping from token ID to approved address.
632     mapping(uint256 => address) private _tokenApprovals;
633 
634     // Mapping from owner to operator approvals
635     mapping(address => mapping(address => bool)) private _operatorApprovals;
636 
637     constructor(string memory name_, string memory symbol_) {
638         _name = name_;
639         _symbol = symbol_;
640         _currentIndex = _startTokenId();
641     }
642 
643     /**
644      * @dev Returns the starting token ID.
645      * To change the starting token ID, please override this function.
646      */
647     function _startTokenId() internal view virtual returns (uint256) {
648         return 0;
649     }
650 
651     /**
652      * @dev Returns the next token ID to be minted.
653      */
654     function _nextTokenId() internal view returns (uint256) {
655         return _currentIndex;
656     }
657 
658     /**
659      * @dev Returns the total number of tokens in existence.
660      * Burned tokens will reduce the count.
661      * To get the total number of tokens minted, please see `_totalMinted`.
662      */
663     function totalSupply() public view override returns (uint256) {
664         // Counter underflow is impossible as _burnCounter cannot be incremented
665         // more than `_currentIndex - _startTokenId()` times.
666         unchecked {
667             return _currentIndex - _burnCounter - _startTokenId();
668         }
669     }
670 
671     /**
672      * @dev Returns the total amount of tokens minted in the contract.
673      */
674     function _totalMinted() internal view returns (uint256) {
675         // Counter underflow is impossible as _currentIndex does not decrement,
676         // and it is initialized to `_startTokenId()`
677         unchecked {
678             return _currentIndex - _startTokenId();
679         }
680     }
681 
682     /**
683      * @dev Returns the total number of tokens burned.
684      */
685     function _totalBurned() internal view returns (uint256) {
686         return _burnCounter;
687     }
688 
689     /**
690      * @dev See {IERC165-supportsInterface}.
691      */
692     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
693         // The interface IDs are constants representing the first 4 bytes of the XOR of
694         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
695         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
696         return
697             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
698             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
699             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
700     }
701 
702     /**
703      * @dev See {IERC721-balanceOf}.
704      */
705     function balanceOf(address owner) public view override returns (uint256) {
706         if (owner == address(0)) revert BalanceQueryForZeroAddress();
707         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
708     }
709 
710     /**
711      * Returns the number of tokens minted by `owner`.
712      */
713     function _numberMinted(address owner) internal view returns (uint256) {
714         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
715     }
716 
717     /**
718      * Returns the number of tokens burned by or on behalf of `owner`.
719      */
720     function _numberBurned(address owner) internal view returns (uint256) {
721         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
722     }
723 
724     /**
725      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
726      */
727     function _getAux(address owner) internal view returns (uint64) {
728         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
729     }
730 
731     /**
732      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
733      * If there are multiple variables, please pack them into a uint64.
734      */
735     function _setAux(address owner, uint64 aux) internal {
736         uint256 packed = _packedAddressData[owner];
737         uint256 auxCasted;
738         // Cast `aux` with assembly to avoid redundant masking.
739         assembly {
740             auxCasted := aux
741         }
742         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
743         _packedAddressData[owner] = packed;
744     }
745 
746     /**
747      * Returns the packed ownership data of `tokenId`.
748      */
749     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
750         uint256 curr = tokenId;
751 
752         unchecked {
753             if (_startTokenId() <= curr)
754                 if (curr < _currentIndex) {
755                     uint256 packed = _packedOwnerships[curr];
756                     // If not burned.
757                     if (packed & BITMASK_BURNED == 0) {
758                         // Invariant:
759                         // There will always be an ownership that has an address and is not burned
760                         // before an ownership that does not have an address and is not burned.
761                         // Hence, curr will not underflow.
762                         //
763                         // We can directly compare the packed value.
764                         // If the address is zero, packed is zero.
765                         while (packed == 0) {
766                             packed = _packedOwnerships[--curr];
767                         }
768                         return packed;
769                     }
770                 }
771         }
772         revert OwnerQueryForNonexistentToken();
773     }
774 
775     /**
776      * Returns the unpacked `TokenOwnership` struct from `packed`.
777      */
778     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
779         ownership.addr = address(uint160(packed));
780         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
781         ownership.burned = packed & BITMASK_BURNED != 0;
782         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
783     }
784 
785     /**
786      * Returns the unpacked `TokenOwnership` struct at `index`.
787      */
788     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
789         return _unpackedOwnership(_packedOwnerships[index]);
790     }
791 
792     /**
793      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
794      */
795     function _initializeOwnershipAt(uint256 index) internal {
796         if (_packedOwnerships[index] == 0) {
797             _packedOwnerships[index] = _packedOwnershipOf(index);
798         }
799     }
800 
801     /**
802      * Gas spent here starts off proportional to the maximum mint batch size.
803      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
804      */
805     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
806         return _unpackedOwnership(_packedOwnershipOf(tokenId));
807     }
808 
809     /**
810      * @dev Packs ownership data into a single uint256.
811      */
812     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
813         assembly {
814             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
815             owner := and(owner, BITMASK_ADDRESS)
816             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
817             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
818         }
819     }
820 
821     /**
822      * @dev See {IERC721-ownerOf}.
823      */
824     function ownerOf(uint256 tokenId) public view override returns (address) {
825         return address(uint160(_packedOwnershipOf(tokenId)));
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-name}.
830      */
831     function name() public view virtual override returns (string memory) {
832         return _name;
833     }
834 
835     /**
836      * @dev See {IERC721Metadata-symbol}.
837      */
838     function symbol() public view virtual override returns (string memory) {
839         return _symbol;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-tokenURI}.
844      */
845     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
846         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
847 
848         string memory baseURI = _baseURI();
849         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
850     }
851 
852     /**
853      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
854      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
855      * by default, it can be overridden in child contracts.
856      */
857     function _baseURI() internal view virtual returns (string memory) {
858         return '';
859     }
860 
861     /**
862      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
863      */
864     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
865         // For branchless setting of the `nextInitialized` flag.
866         assembly {
867             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
868             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
869         }
870     }
871 
872     /**
873      * @dev See {IERC721-approve}.
874      */
875     function approve(address to, uint256 tokenId) public override {
876         address owner = ownerOf(tokenId);
877 
878         if (_msgSenderERC721A() != owner)
879             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
880                 revert ApprovalCallerNotOwnerNorApproved();
881             }
882 
883         _tokenApprovals[tokenId] = to;
884         emit Approval(owner, to, tokenId);
885     }
886 
887     /**
888      * @dev See {IERC721-getApproved}.
889      */
890     function getApproved(uint256 tokenId) public view override returns (address) {
891         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
892 
893         return _tokenApprovals[tokenId];
894     }
895 
896     /**
897      * @dev See {IERC721-setApprovalForAll}.
898      */
899     function setApprovalForAll(address operator, bool approved) public virtual override {
900         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
901 
902         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
903         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
904     }
905 
906     /**
907      * @dev See {IERC721-isApprovedForAll}.
908      */
909     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
910         return _operatorApprovals[owner][operator];
911     }
912 
913     /**
914      * @dev See {IERC721-safeTransferFrom}.
915      */
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId
920     ) public virtual override {
921         safeTransferFrom(from, to, tokenId, '');
922     }
923 
924     /**
925      * @dev See {IERC721-safeTransferFrom}.
926      */
927     function safeTransferFrom(
928         address from,
929         address to,
930         uint256 tokenId,
931         bytes memory _data
932     ) public virtual override {
933         transferFrom(from, to, tokenId);
934         if (to.code.length != 0)
935             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
936                 revert TransferToNonERC721ReceiverImplementer();
937             }
938     }
939 
940     /**
941      * @dev Returns whether `tokenId` exists.
942      *
943      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
944      *
945      * Tokens start existing when they are minted (`_mint`),
946      */
947     function _exists(uint256 tokenId) internal view returns (bool) {
948         return
949             _startTokenId() <= tokenId &&
950             tokenId < _currentIndex && // If within bounds,
951             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
952     }
953 
954     /**
955      * @dev Equivalent to `_safeMint(to, quantity, '')`.
956      */
957     function _safeMint(address to, uint256 quantity) internal {
958         _safeMint(to, quantity, '');
959     }
960 
961     /**
962      * @dev Safely mints `quantity` tokens and transfers them to `to`.
963      *
964      * Requirements:
965      *
966      * - If `to` refers to a smart contract, it must implement
967      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
968      * - `quantity` must be greater than 0.
969      *
970      * See {_mint}.
971      *
972      * Emits a {Transfer} event for each mint.
973      */
974     function _safeMint(
975         address to,
976         uint256 quantity,
977         bytes memory _data
978     ) internal {
979         _mint(to, quantity);
980 
981         unchecked {
982             if (to.code.length != 0) {
983                 uint256 end = _currentIndex;
984                 uint256 index = end - quantity;
985                 do {
986                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
987                         revert TransferToNonERC721ReceiverImplementer();
988                     }
989                 } while (index < end);
990                 // Reentrancy protection.
991                 if (_currentIndex != end) revert();
992             }
993         }
994     }
995 
996     /**
997      * @dev Mints `quantity` tokens and transfers them to `to`.
998      *
999      * Requirements:
1000      *
1001      * - `to` cannot be the zero address.
1002      * - `quantity` must be greater than 0.
1003      *
1004      * Emits a {Transfer} event for each mint.
1005      */
1006     function _mint(address to, uint256 quantity) internal {
1007         uint256 startTokenId = _currentIndex;
1008         if (to == address(0)) revert MintToZeroAddress();
1009         if (quantity == 0) revert MintZeroQuantity();
1010 
1011         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1012 
1013         // Overflows are incredibly unrealistic.
1014         // `balance` and `numberMinted` have a maximum limit of 2**64.
1015         // `tokenId` has a maximum limit of 2**256.
1016         unchecked {
1017             // Updates:
1018             // - `balance += quantity`.
1019             // - `numberMinted += quantity`.
1020             //
1021             // We can directly add to the `balance` and `numberMinted`.
1022             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1023 
1024             // Updates:
1025             // - `address` to the owner.
1026             // - `startTimestamp` to the timestamp of minting.
1027             // - `burned` to `false`.
1028             // - `nextInitialized` to `quantity == 1`.
1029             _packedOwnerships[startTokenId] = _packOwnershipData(
1030                 to,
1031                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1032             );
1033 
1034             uint256 tokenId = startTokenId;
1035             uint256 end = startTokenId + quantity;
1036             do {
1037                 emit Transfer(address(0), to, tokenId++);
1038             } while (tokenId < end);
1039 
1040             _currentIndex = end;
1041         }
1042         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1043     }
1044 
1045     /**
1046      * @dev Mints `quantity` tokens and transfers them to `to`.
1047      *
1048      * This function is intended for efficient minting only during contract creation.
1049      *
1050      * It emits only one {ConsecutiveTransfer} as defined in
1051      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1052      * instead of a sequence of {Transfer} event(s).
1053      *
1054      * Calling this function outside of contract creation WILL make your contract
1055      * non-compliant with the ERC721 standard.
1056      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1057      * {ConsecutiveTransfer} event is only permissible during contract creation.
1058      *
1059      * Requirements:
1060      *
1061      * - `to` cannot be the zero address.
1062      * - `quantity` must be greater than 0.
1063      *
1064      * Emits a {ConsecutiveTransfer} event.
1065      */
1066     function _mintERC2309(address to, uint256 quantity) internal {
1067         uint256 startTokenId = _currentIndex;
1068         if (to == address(0)) revert MintToZeroAddress();
1069         if (quantity == 0) revert MintZeroQuantity();
1070         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1071 
1072         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1073 
1074         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1075         unchecked {
1076             // Updates:
1077             // - `balance += quantity`.
1078             // - `numberMinted += quantity`.
1079             //
1080             // We can directly add to the `balance` and `numberMinted`.
1081             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1082 
1083             // Updates:
1084             // - `address` to the owner.
1085             // - `startTimestamp` to the timestamp of minting.
1086             // - `burned` to `false`.
1087             // - `nextInitialized` to `quantity == 1`.
1088             _packedOwnerships[startTokenId] = _packOwnershipData(
1089                 to,
1090                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1091             );
1092 
1093             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1094 
1095             _currentIndex = startTokenId + quantity;
1096         }
1097         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1098     }
1099 
1100     /**
1101      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1102      */
1103     function _getApprovedAddress(uint256 tokenId)
1104         private
1105         view
1106         returns (uint256 approvedAddressSlot, address approvedAddress)
1107     {
1108         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1109         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1110         assembly {
1111             // Compute the slot.
1112             mstore(0x00, tokenId)
1113             mstore(0x20, tokenApprovalsPtr.slot)
1114             approvedAddressSlot := keccak256(0x00, 0x40)
1115             // Load the slot's value from storage.
1116             approvedAddress := sload(approvedAddressSlot)
1117         }
1118     }
1119 
1120     /**
1121      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1122      */
1123     function _isOwnerOrApproved(
1124         address approvedAddress,
1125         address from,
1126         address msgSender
1127     ) private pure returns (bool result) {
1128         assembly {
1129             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1130             from := and(from, BITMASK_ADDRESS)
1131             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1132             msgSender := and(msgSender, BITMASK_ADDRESS)
1133             // `msgSender == from || msgSender == approvedAddress`.
1134             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1135         }
1136     }
1137 
1138     /**
1139      * @dev Transfers `tokenId` from `from` to `to`.
1140      *
1141      * Requirements:
1142      *
1143      * - `to` cannot be the zero address.
1144      * - `tokenId` token must be owned by `from`.
1145      *
1146      * Emits a {Transfer} event.
1147      */
1148     function transferFrom(
1149         address from,
1150         address to,
1151         uint256 tokenId
1152     ) public virtual override {
1153         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1154 
1155         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1156 
1157         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1158 
1159         // The nested ifs save around 20+ gas over a compound boolean condition.
1160         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1161             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1162 
1163         if (to == address(0)) revert TransferToZeroAddress();
1164 
1165         _beforeTokenTransfers(from, to, tokenId, 1);
1166 
1167         // Clear approvals from the previous owner.
1168         assembly {
1169             if approvedAddress {
1170                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1171                 sstore(approvedAddressSlot, 0)
1172             }
1173         }
1174 
1175         // Underflow of the sender's balance is impossible because we check for
1176         // ownership above and the recipient's balance can't realistically overflow.
1177         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1178         unchecked {
1179             // We can directly increment and decrement the balances.
1180             --_packedAddressData[from]; // Updates: `balance -= 1`.
1181             ++_packedAddressData[to]; // Updates: `balance += 1`.
1182 
1183             // Updates:
1184             // - `address` to the next owner.
1185             // - `startTimestamp` to the timestamp of transfering.
1186             // - `burned` to `false`.
1187             // - `nextInitialized` to `true`.
1188             _packedOwnerships[tokenId] = _packOwnershipData(
1189                 to,
1190                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1191             );
1192 
1193             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1194             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1195                 uint256 nextTokenId = tokenId + 1;
1196                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1197                 if (_packedOwnerships[nextTokenId] == 0) {
1198                     // If the next slot is within bounds.
1199                     if (nextTokenId != _currentIndex) {
1200                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1201                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1202                     }
1203                 }
1204             }
1205         }
1206 
1207         emit Transfer(from, to, tokenId);
1208         _afterTokenTransfers(from, to, tokenId, 1);
1209     }
1210 
1211     /**
1212      * @dev Equivalent to `_burn(tokenId, false)`.
1213      */
1214     function _burn(uint256 tokenId) internal virtual {
1215         _burn(tokenId, false);
1216     }
1217 
1218     /**
1219      * @dev Destroys `tokenId`.
1220      * The approval is cleared when the token is burned.
1221      *
1222      * Requirements:
1223      *
1224      * - `tokenId` must exist.
1225      *
1226      * Emits a {Transfer} event.
1227      */
1228     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1229         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1230 
1231         address from = address(uint160(prevOwnershipPacked));
1232 
1233         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1234 
1235         if (approvalCheck) {
1236             // The nested ifs save around 20+ gas over a compound boolean condition.
1237             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1238                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1239         }
1240 
1241         _beforeTokenTransfers(from, address(0), tokenId, 1);
1242 
1243         // Clear approvals from the previous owner.
1244         assembly {
1245             if approvedAddress {
1246                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1247                 sstore(approvedAddressSlot, 0)
1248             }
1249         }
1250 
1251         // Underflow of the sender's balance is impossible because we check for
1252         // ownership above and the recipient's balance can't realistically overflow.
1253         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1254         unchecked {
1255             // Updates:
1256             // - `balance -= 1`.
1257             // - `numberBurned += 1`.
1258             //
1259             // We can directly decrement the balance, and increment the number burned.
1260             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1261             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1262 
1263             // Updates:
1264             // - `address` to the last owner.
1265             // - `startTimestamp` to the timestamp of burning.
1266             // - `burned` to `true`.
1267             // - `nextInitialized` to `true`.
1268             _packedOwnerships[tokenId] = _packOwnershipData(
1269                 from,
1270                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1271             );
1272 
1273             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1274             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1275                 uint256 nextTokenId = tokenId + 1;
1276                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1277                 if (_packedOwnerships[nextTokenId] == 0) {
1278                     // If the next slot is within bounds.
1279                     if (nextTokenId != _currentIndex) {
1280                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1281                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1282                     }
1283                 }
1284             }
1285         }
1286 
1287         emit Transfer(from, address(0), tokenId);
1288         _afterTokenTransfers(from, address(0), tokenId, 1);
1289 
1290         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1291         unchecked {
1292             _burnCounter++;
1293         }
1294     }
1295 
1296     /**
1297      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1298      *
1299      * @param from address representing the previous owner of the given token ID
1300      * @param to target address that will receive the tokens
1301      * @param tokenId uint256 ID of the token to be transferred
1302      * @param _data bytes optional data to send along with the call
1303      * @return bool whether the call correctly returned the expected magic value
1304      */
1305     function _checkContractOnERC721Received(
1306         address from,
1307         address to,
1308         uint256 tokenId,
1309         bytes memory _data
1310     ) private returns (bool) {
1311         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1312             bytes4 retval
1313         ) {
1314             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1315         } catch (bytes memory reason) {
1316             if (reason.length == 0) {
1317                 revert TransferToNonERC721ReceiverImplementer();
1318             } else {
1319                 assembly {
1320                     revert(add(32, reason), mload(reason))
1321                 }
1322             }
1323         }
1324     }
1325 
1326     /**
1327      * @dev Directly sets the extra data for the ownership data `index`.
1328      */
1329     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1330         uint256 packed = _packedOwnerships[index];
1331         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1332         uint256 extraDataCasted;
1333         // Cast `extraData` with assembly to avoid redundant masking.
1334         assembly {
1335             extraDataCasted := extraData
1336         }
1337         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1338         _packedOwnerships[index] = packed;
1339     }
1340 
1341     /**
1342      * @dev Returns the next extra data for the packed ownership data.
1343      * The returned result is shifted into position.
1344      */
1345     function _nextExtraData(
1346         address from,
1347         address to,
1348         uint256 prevOwnershipPacked
1349     ) private view returns (uint256) {
1350         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1351         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1352     }
1353 
1354     /**
1355      * @dev Called during each token transfer to set the 24bit `extraData` field.
1356      * Intended to be overridden by the cosumer contract.
1357      *
1358      * `previousExtraData` - the value of `extraData` before transfer.
1359      *
1360      * Calling conditions:
1361      *
1362      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1363      * transferred to `to`.
1364      * - When `from` is zero, `tokenId` will be minted for `to`.
1365      * - When `to` is zero, `tokenId` will be burned by `from`.
1366      * - `from` and `to` are never both zero.
1367      */
1368     function _extraData(
1369         address from,
1370         address to,
1371         uint24 previousExtraData
1372     ) internal view virtual returns (uint24) {}
1373 
1374     /**
1375      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1376      * This includes minting.
1377      * And also called before burning one token.
1378      *
1379      * startTokenId - the first token id to be transferred
1380      * quantity - the amount to be transferred
1381      *
1382      * Calling conditions:
1383      *
1384      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1385      * transferred to `to`.
1386      * - When `from` is zero, `tokenId` will be minted for `to`.
1387      * - When `to` is zero, `tokenId` will be burned by `from`.
1388      * - `from` and `to` are never both zero.
1389      */
1390     function _beforeTokenTransfers(
1391         address from,
1392         address to,
1393         uint256 startTokenId,
1394         uint256 quantity
1395     ) internal virtual {}
1396 
1397     /**
1398      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1399      * This includes minting.
1400      * And also called after one token has been burned.
1401      *
1402      * startTokenId - the first token id to be transferred
1403      * quantity - the amount to be transferred
1404      *
1405      * Calling conditions:
1406      *
1407      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1408      * transferred to `to`.
1409      * - When `from` is zero, `tokenId` has been minted for `to`.
1410      * - When `to` is zero, `tokenId` has been burned by `from`.
1411      * - `from` and `to` are never both zero.
1412      */
1413     function _afterTokenTransfers(
1414         address from,
1415         address to,
1416         uint256 startTokenId,
1417         uint256 quantity
1418     ) internal virtual {}
1419 
1420     /**
1421      * @dev Returns the message sender (defaults to `msg.sender`).
1422      *
1423      * If you are writing GSN compatible contracts, you need to override this function.
1424      */
1425     function _msgSenderERC721A() internal view virtual returns (address) {
1426         return msg.sender;
1427     }
1428 
1429     /**
1430      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1431      */
1432     function _toString(uint256 value) internal pure returns (string memory ptr) {
1433         assembly {
1434             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1435             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1436             // We will need 1 32-byte word to store the length,
1437             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1438             ptr := add(mload(0x40), 128)
1439             // Update the free memory pointer to allocate.
1440             mstore(0x40, ptr)
1441 
1442             // Cache the end of the memory to calculate the length later.
1443             let end := ptr
1444 
1445             // We write the string from the rightmost digit to the leftmost digit.
1446             // The following is essentially a do-while loop that also handles the zero case.
1447             // Costs a bit more than early returning for the zero case,
1448             // but cheaper in terms of deployment and overall runtime costs.
1449             for {
1450                 // Initialize and perform the first pass without check.
1451                 let temp := value
1452                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1453                 ptr := sub(ptr, 1)
1454                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1455                 mstore8(ptr, add(48, mod(temp, 10)))
1456                 temp := div(temp, 10)
1457             } temp {
1458                 // Keep dividing `temp` until zero.
1459                 temp := div(temp, 10)
1460             } {
1461                 // Body of the for loop.
1462                 ptr := sub(ptr, 1)
1463                 mstore8(ptr, add(48, mod(temp, 10)))
1464             }
1465 
1466             let length := sub(end, ptr)
1467             // Move the pointer 32 bytes leftwards to make room for the length.
1468             ptr := sub(ptr, 32)
1469             // Store the length.
1470             mstore(ptr, length)
1471         }
1472     }
1473 }
1474 
1475 // File: contracts/supdudes.sol
1476 
1477 
1478 
1479 pragma solidity >=0.8.9 <0.9.0;
1480 
1481 
1482 
1483 
1484 
1485 contract SupDudes is ERC721A, Ownable, ReentrancyGuard {
1486     
1487     using Strings for uint256;
1488     
1489     //2222 because we all have to take dookie
1490     uint256 private maxTotalTokens;
1491     
1492     //boring stuff
1493     string private _currentBaseURI;
1494     
1495    
1496     uint private _reservedMints;
1497     
1498     
1499     uint private maxReservedMints = 1200;
1500 
1501  
1502     mapping(address => uint256) public mintsPerAddress;
1503     
1504     
1505     enum State {dude, suhdude}
1506 
1507     State private saleState_;
1508     
1509     //declaring initial values for variables
1510     constructor() ERC721A('SupDudes', 'SupDudes') {
1511         maxTotalTokens = 10022;
1512 
1513         _currentBaseURI = "ipfs://QmQFKdaFzoGxpj62MiUzHPhRrrGp9kD5oGV89SJnkUcrNA/";
1514     }
1515     
1516     //in case somebody accidentaly sends funds or transaction to contract
1517     receive() payable external {}
1518     fallback() payable external {
1519         revert();
1520     }
1521     
1522     //visualize baseURI
1523     function _baseURI() internal view virtual override returns (string memory) {
1524         return _currentBaseURI;
1525     }
1526     
1527     //if we mess up, let's us fix it
1528     function changeBaseURI(string memory baseURI_) public onlyOwner {
1529         _currentBaseURI = baseURI_;
1530     }
1531 
1532     function setSaleState(uint newSaleState) public onlyOwner {
1533         require(newSaleState < 2, "Invalid Sale State!");
1534         if (newSaleState == 0) {
1535             saleState_ = State.dude;
1536         }
1537         else {
1538             saleState_ = State.suhdude;
1539         }
1540     }
1541 
1542     //mint a @param number of NFTs in public sale
1543     function mint() public nonReentrant {
1544         require(msg.sender == tx.origin, "Sender is not the same as origin!");
1545         require(saleState_ == State.suhdude, "Public Sale in not open yet!");
1546         require(totalSupply() < maxTotalTokens - (maxReservedMints - _reservedMints), "Not enough NFTs left to mint..");
1547         require(mintsPerAddress[msg.sender] == 0, "Wallet has already  minted an NFT!");
1548 
1549         _safeMint(msg.sender, 10);
1550         mintsPerAddress[msg.sender] += 20;
1551     }
1552     
1553     function tokenURI(uint256 tokenId_) public view virtual override returns (string memory) {
1554         require(_exists(tokenId_), "ERC721Metadata: URI query for nonexistent token");
1555 
1556         tokenId_ += 1;
1557         string memory baseURI = _baseURI();
1558         return string(abi.encodePacked(baseURI, tokenId_.toString(), ".json")); 
1559     }
1560     
1561     //reserved NFTs for creator
1562     function reservedMint(uint number, address recipient) public onlyOwner {
1563         require(_reservedMints + number <= maxReservedMints, "Not enough Reserved NFTs left to mint..");
1564 
1565         _safeMint(recipient, number);
1566         mintsPerAddress[recipient] += number;
1567         _reservedMints += number; 
1568         
1569     }
1570     
1571     //burn 
1572     function burnTokens() public onlyOwner {
1573         maxTotalTokens = totalSupply();
1574     }
1575     
1576     //
1577     function accountBalance() public onlyOwner view returns(uint) {
1578         return address(this).balance;
1579     }
1580     
1581     //retrieve all funds recieved from minting
1582     function withdraw() public onlyOwner {
1583         uint256 balance = accountBalance();
1584         require(balance > 0, 'No Funds to withdraw, Balance is 0');
1585 
1586         _withdraw(payable(msg.sender), balance); 
1587     }
1588     
1589     //
1590     function _withdraw(address payable account, uint256 amount) internal {
1591         (bool sent, ) = account.call{value: amount}("");
1592         require(sent, "Failed to send Ether");
1593     }
1594     
1595     //to see the total amount of reserved mints left 
1596     function reservedMintsLeft() public onlyOwner view returns(uint) {
1597         return maxReservedMints - _reservedMints;
1598     }
1599     
1600     //see current state of sale
1601     //see the current state of the sale
1602     function saleState() public view returns(State){
1603         return saleState_;
1604     }
1605     
1606    
1607 }