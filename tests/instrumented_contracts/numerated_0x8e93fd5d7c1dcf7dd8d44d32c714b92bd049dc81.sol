1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
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
79 // File: contracts/utils/MerkleProof.sol
80 
81 
82 
83 pragma solidity >=0.8.7;
84 
85 /**
86  * @dev These functions deal with verification of Merkle Trees proofs.
87  *
88  * The proofs can be generated using the JavaScript library
89  * https://github.com/miguelmota/merkletreejs[merkletreejs].
90  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
91  *
92  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
93  */
94 library MerkleProof {
95     /**
96      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
97      * defined by `root`. For this, a `proof` must be provided, containing
98      * sibling hashes on the branch from the leaf to the root of the tree. Each
99      * pair of leaves and each pair of pre-images are assumed to be sorted.
100      */
101     function verify(
102         bytes32[] memory proof,
103         bytes32 root,
104         bytes32 leaf
105     ) internal pure returns (bool) {
106         return processProof(proof, leaf) == root;
107     }
108     
109     /**
110      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
111      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
112      * hash matches the root of the tree. When processing the proof, the pairs
113      * of leafs & pre-images are assumed to be sorted.
114      *
115      * _Available since v4.4._
116      */
117     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
118         bytes32 computedHash = leaf;
119         for (uint256 i = 0; i < proof.length; i++) {
120             bytes32 proofElement = proof[i];
121             if (computedHash <= proofElement) {
122                 // Hash(current computed hash + current element of the proof)
123                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
124             } else {
125                 // Hash(current element of the proof + current computed hash)
126                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
127             }
128         }
129         return computedHash;
130     }
131 }
132 // File: @openzeppelin/contracts/utils/Context.sol
133 
134 
135 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev Provides information about the current execution context, including the
141  * sender of the transaction and its data. While these are generally available
142  * via msg.sender and msg.data, they should not be accessed in such a direct
143  * manner, since when dealing with meta-transactions the account sending and
144  * paying for execution may not be the actual sender (as far as an application
145  * is concerned).
146  *
147  * This contract is only required for intermediate, library-like contracts.
148  */
149 abstract contract Context {
150     function _msgSender() internal view virtual returns (address) {
151         return msg.sender;
152     }
153 
154     function _msgData() internal view virtual returns (bytes calldata) {
155         return msg.data;
156     }
157 }
158 
159 // File: @openzeppelin/contracts/access/Ownable.sol
160 
161 
162 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
163 
164 pragma solidity ^0.8.0;
165 
166 
167 /**
168  * @dev Contract module which provides a basic access control mechanism, where
169  * there is an account (an owner) that can be granted exclusive access to
170  * specific functions.
171  *
172  * By default, the owner account will be the one that deploys the contract. This
173  * can later be changed with {transferOwnership}.
174  *
175  * This module is used through inheritance. It will make available the modifier
176  * `onlyOwner`, which can be applied to your functions to restrict their use to
177  * the owner.
178  */
179 abstract contract Ownable is Context {
180     address private _owner;
181 
182     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183 
184     /**
185      * @dev Initializes the contract setting the deployer as the initial owner.
186      */
187     constructor() {
188         _transferOwnership(_msgSender());
189     }
190 
191     /**
192      * @dev Returns the address of the current owner.
193      */
194     function owner() public view virtual returns (address) {
195         return _owner;
196     }
197 
198     /**
199      * @dev Throws if called by any account other than the owner.
200      */
201     modifier onlyOwner() {
202         require(owner() == _msgSender(), "Ownable: caller is not the owner");
203         _;
204     }
205 
206     /**
207      * @dev Leaves the contract without owner. It will not be possible to call
208      * `onlyOwner` functions anymore. Can only be called by the current owner.
209      *
210      * NOTE: Renouncing ownership will leave the contract without an owner,
211      * thereby removing any functionality that is only available to the owner.
212      */
213     function renounceOwnership() public virtual onlyOwner {
214         _transferOwnership(address(0));
215     }
216 
217     /**
218      * @dev Transfers ownership of the contract to a new account (`newOwner`).
219      * Can only be called by the current owner.
220      */
221     function transferOwnership(address newOwner) public virtual onlyOwner {
222         require(newOwner != address(0), "Ownable: new owner is the zero address");
223         _transferOwnership(newOwner);
224     }
225 
226     /**
227      * @dev Transfers ownership of the contract to a new account (`newOwner`).
228      * Internal function without access restriction.
229      */
230     function _transferOwnership(address newOwner) internal virtual {
231         address oldOwner = _owner;
232         _owner = newOwner;
233         emit OwnershipTransferred(oldOwner, newOwner);
234     }
235 }
236 
237 // File: erc721a/contracts/IERC721A.sol
238 
239 
240 // ERC721A Contracts v4.1.0
241 // Creator: Chiru Labs
242 
243 pragma solidity ^0.8.4;
244 
245 /**
246  * @dev Interface of an ERC721A compliant contract.
247  */
248 interface IERC721A {
249     /**
250      * The caller must own the token or be an approved operator.
251      */
252     error ApprovalCallerNotOwnerNorApproved();
253 
254     /**
255      * The token does not exist.
256      */
257     error ApprovalQueryForNonexistentToken();
258 
259     /**
260      * The caller cannot approve to their own address.
261      */
262     error ApproveToCaller();
263 
264     /**
265      * Cannot query the balance for the zero address.
266      */
267     error BalanceQueryForZeroAddress();
268 
269     /**
270      * Cannot mint to the zero address.
271      */
272     error MintToZeroAddress();
273 
274     /**
275      * The quantity of tokens minted must be more than zero.
276      */
277     error MintZeroQuantity();
278 
279     /**
280      * The token does not exist.
281      */
282     error OwnerQueryForNonexistentToken();
283 
284     /**
285      * The caller must own the token or be an approved operator.
286      */
287     error TransferCallerNotOwnerNorApproved();
288 
289     /**
290      * The token must be owned by `from`.
291      */
292     error TransferFromIncorrectOwner();
293 
294     /**
295      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
296      */
297     error TransferToNonERC721ReceiverImplementer();
298 
299     /**
300      * Cannot transfer to the zero address.
301      */
302     error TransferToZeroAddress();
303 
304     /**
305      * The token does not exist.
306      */
307     error URIQueryForNonexistentToken();
308 
309     /**
310      * The `quantity` minted with ERC2309 exceeds the safety limit.
311      */
312     error MintERC2309QuantityExceedsLimit();
313 
314     /**
315      * The `extraData` cannot be set on an unintialized ownership slot.
316      */
317     error OwnershipNotInitializedForExtraData();
318 
319     struct TokenOwnership {
320         // The address of the owner.
321         address addr;
322         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
323         uint64 startTimestamp;
324         // Whether the token has been burned.
325         bool burned;
326         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
327         uint24 extraData;
328     }
329 
330     /**
331      * @dev Returns the total amount of tokens stored by the contract.
332      *
333      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
334      */
335     function totalSupply() external view returns (uint256);
336 
337     // ==============================
338     //            IERC165
339     // ==============================
340 
341     /**
342      * @dev Returns true if this contract implements the interface defined by
343      * `interfaceId`. See the corresponding
344      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
345      * to learn more about how these ids are created.
346      *
347      * This function call must use less than 30 000 gas.
348      */
349     function supportsInterface(bytes4 interfaceId) external view returns (bool);
350 
351     // ==============================
352     //            IERC721
353     // ==============================
354 
355     /**
356      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
357      */
358     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
359 
360     /**
361      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
362      */
363     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
364 
365     /**
366      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
367      */
368     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
369 
370     /**
371      * @dev Returns the number of tokens in ``owner``'s account.
372      */
373     function balanceOf(address owner) external view returns (uint256 balance);
374 
375     /**
376      * @dev Returns the owner of the `tokenId` token.
377      *
378      * Requirements:
379      *
380      * - `tokenId` must exist.
381      */
382     function ownerOf(uint256 tokenId) external view returns (address owner);
383 
384     /**
385      * @dev Safely transfers `tokenId` token from `from` to `to`.
386      *
387      * Requirements:
388      *
389      * - `from` cannot be the zero address.
390      * - `to` cannot be the zero address.
391      * - `tokenId` token must exist and be owned by `from`.
392      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
393      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
394      *
395      * Emits a {Transfer} event.
396      */
397     function safeTransferFrom(
398         address from,
399         address to,
400         uint256 tokenId,
401         bytes calldata data
402     ) external;
403 
404     /**
405      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
406      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
407      *
408      * Requirements:
409      *
410      * - `from` cannot be the zero address.
411      * - `to` cannot be the zero address.
412      * - `tokenId` token must exist and be owned by `from`.
413      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
414      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
415      *
416      * Emits a {Transfer} event.
417      */
418     function safeTransferFrom(
419         address from,
420         address to,
421         uint256 tokenId
422     ) external;
423 
424     /**
425      * @dev Transfers `tokenId` token from `from` to `to`.
426      *
427      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must be owned by `from`.
434      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
435      *
436      * Emits a {Transfer} event.
437      */
438     function transferFrom(
439         address from,
440         address to,
441         uint256 tokenId
442     ) external;
443 
444     /**
445      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
446      * The approval is cleared when the token is transferred.
447      *
448      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
449      *
450      * Requirements:
451      *
452      * - The caller must own the token or be an approved operator.
453      * - `tokenId` must exist.
454      *
455      * Emits an {Approval} event.
456      */
457     function approve(address to, uint256 tokenId) external;
458 
459     /**
460      * @dev Approve or remove `operator` as an operator for the caller.
461      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
462      *
463      * Requirements:
464      *
465      * - The `operator` cannot be the caller.
466      *
467      * Emits an {ApprovalForAll} event.
468      */
469     function setApprovalForAll(address operator, bool _approved) external;
470 
471     /**
472      * @dev Returns the account approved for `tokenId` token.
473      *
474      * Requirements:
475      *
476      * - `tokenId` must exist.
477      */
478     function getApproved(uint256 tokenId) external view returns (address operator);
479 
480     /**
481      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
482      *
483      * See {setApprovalForAll}
484      */
485     function isApprovedForAll(address owner, address operator) external view returns (bool);
486 
487     // ==============================
488     //        IERC721Metadata
489     // ==============================
490 
491     /**
492      * @dev Returns the token collection name.
493      */
494     function name() external view returns (string memory);
495 
496     /**
497      * @dev Returns the token collection symbol.
498      */
499     function symbol() external view returns (string memory);
500 
501     /**
502      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
503      */
504     function tokenURI(uint256 tokenId) external view returns (string memory);
505 
506     // ==============================
507     //            IERC2309
508     // ==============================
509 
510     /**
511      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
512      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
513      */
514     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
515 }
516 
517 // File: erc721a/contracts/ERC721A.sol
518 
519 
520 // ERC721A Contracts v4.1.0
521 // Creator: Chiru Labs
522 
523 pragma solidity ^0.8.4;
524 
525 
526 /**
527  * @dev ERC721 token receiver interface.
528  */
529 interface ERC721A__IERC721Receiver {
530     function onERC721Received(
531         address operator,
532         address from,
533         uint256 tokenId,
534         bytes calldata data
535     ) external returns (bytes4);
536 }
537 
538 /**
539  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
540  * including the Metadata extension. Built to optimize for lower gas during batch mints.
541  *
542  * Assumes serials are sequentially minted starting at `_startTokenId()`
543  * (defaults to 0, e.g. 0, 1, 2, 3..).
544  *
545  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
546  *
547  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
548  */
549 contract ERC721A is IERC721A {
550     // Mask of an entry in packed address data.
551     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
552 
553     // The bit position of `numberMinted` in packed address data.
554     uint256 private constant BITPOS_NUMBER_MINTED = 64;
555 
556     // The bit position of `numberBurned` in packed address data.
557     uint256 private constant BITPOS_NUMBER_BURNED = 128;
558 
559     // The bit position of `aux` in packed address data.
560     uint256 private constant BITPOS_AUX = 192;
561 
562     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
563     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
564 
565     // The bit position of `startTimestamp` in packed ownership.
566     uint256 private constant BITPOS_START_TIMESTAMP = 160;
567 
568     // The bit mask of the `burned` bit in packed ownership.
569     uint256 private constant BITMASK_BURNED = 1 << 224;
570 
571     // The bit position of the `nextInitialized` bit in packed ownership.
572     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
573 
574     // The bit mask of the `nextInitialized` bit in packed ownership.
575     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
576 
577     // The bit position of `extraData` in packed ownership.
578     uint256 private constant BITPOS_EXTRA_DATA = 232;
579 
580     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
581     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
582 
583     // The mask of the lower 160 bits for addresses.
584     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
585 
586     // The maximum `quantity` that can be minted with `_mintERC2309`.
587     // This limit is to prevent overflows on the address data entries.
588     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
589     // is required to cause an overflow, which is unrealistic.
590     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
591 
592     // The tokenId of the next token to be minted.
593     uint256 private _currentIndex;
594 
595     // The number of tokens burned.
596     uint256 private _burnCounter;
597 
598     // Token name
599     string private _name;
600 
601     // Token symbol
602     string private _symbol;
603 
604     // Mapping from token ID to ownership details
605     // An empty struct value does not necessarily mean the token is unowned.
606     // See `_packedOwnershipOf` implementation for details.
607     //
608     // Bits Layout:
609     // - [0..159]   `addr`
610     // - [160..223] `startTimestamp`
611     // - [224]      `burned`
612     // - [225]      `nextInitialized`
613     // - [232..255] `extraData`
614     mapping(uint256 => uint256) private _packedOwnerships;
615 
616     // Mapping owner address to address data.
617     //
618     // Bits Layout:
619     // - [0..63]    `balance`
620     // - [64..127]  `numberMinted`
621     // - [128..191] `numberBurned`
622     // - [192..255] `aux`
623     mapping(address => uint256) private _packedAddressData;
624 
625     // Mapping from token ID to approved address.
626     mapping(uint256 => address) private _tokenApprovals;
627 
628     // Mapping from owner to operator approvals
629     mapping(address => mapping(address => bool)) private _operatorApprovals;
630 
631     constructor(string memory name_, string memory symbol_) {
632         _name = name_;
633         _symbol = symbol_;
634         _currentIndex = _startTokenId();
635     }
636 
637     /**
638      * @dev Returns the starting token ID.
639      * To change the starting token ID, please override this function.
640      */
641     function _startTokenId() internal view virtual returns (uint256) {
642         return 0;
643     }
644 
645     /**
646      * @dev Returns the next token ID to be minted.
647      */
648     function _nextTokenId() internal view returns (uint256) {
649         return _currentIndex;
650     }
651 
652     /**
653      * @dev Returns the total number of tokens in existence.
654      * Burned tokens will reduce the count.
655      * To get the total number of tokens minted, please see `_totalMinted`.
656      */
657     function totalSupply() public view override returns (uint256) {
658         // Counter underflow is impossible as _burnCounter cannot be incremented
659         // more than `_currentIndex - _startTokenId()` times.
660         unchecked {
661             return _currentIndex - _burnCounter - _startTokenId();
662         }
663     }
664 
665     /**
666      * @dev Returns the total amount of tokens minted in the contract.
667      */
668     function _totalMinted() internal view returns (uint256) {
669         // Counter underflow is impossible as _currentIndex does not decrement,
670         // and it is initialized to `_startTokenId()`
671         unchecked {
672             return _currentIndex - _startTokenId();
673         }
674     }
675 
676     /**
677      * @dev Returns the total number of tokens burned.
678      */
679     function _totalBurned() internal view returns (uint256) {
680         return _burnCounter;
681     }
682 
683     /**
684      * @dev See {IERC165-supportsInterface}.
685      */
686     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
687         // The interface IDs are constants representing the first 4 bytes of the XOR of
688         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
689         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
690         return
691             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
692             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
693             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
694     }
695 
696     /**
697      * @dev See {IERC721-balanceOf}.
698      */
699     function balanceOf(address owner) public view override returns (uint256) {
700         if (owner == address(0)) revert BalanceQueryForZeroAddress();
701         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
702     }
703 
704     /**
705      * Returns the number of tokens minted by `owner`.
706      */
707     function _numberMinted(address owner) internal view returns (uint256) {
708         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
709     }
710 
711     /**
712      * Returns the number of tokens burned by or on behalf of `owner`.
713      */
714     function _numberBurned(address owner) internal view returns (uint256) {
715         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
716     }
717 
718     /**
719      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
720      */
721     function _getAux(address owner) internal view returns (uint64) {
722         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
723     }
724 
725     /**
726      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
727      * If there are multiple variables, please pack them into a uint64.
728      */
729     function _setAux(address owner, uint64 aux) internal {
730         uint256 packed = _packedAddressData[owner];
731         uint256 auxCasted;
732         // Cast `aux` with assembly to avoid redundant masking.
733         assembly {
734             auxCasted := aux
735         }
736         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
737         _packedAddressData[owner] = packed;
738     }
739 
740     /**
741      * Returns the packed ownership data of `tokenId`.
742      */
743     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
744         uint256 curr = tokenId;
745 
746         unchecked {
747             if (_startTokenId() <= curr)
748                 if (curr < _currentIndex) {
749                     uint256 packed = _packedOwnerships[curr];
750                     // If not burned.
751                     if (packed & BITMASK_BURNED == 0) {
752                         // Invariant:
753                         // There will always be an ownership that has an address and is not burned
754                         // before an ownership that does not have an address and is not burned.
755                         // Hence, curr will not underflow.
756                         //
757                         // We can directly compare the packed value.
758                         // If the address is zero, packed is zero.
759                         while (packed == 0) {
760                             packed = _packedOwnerships[--curr];
761                         }
762                         return packed;
763                     }
764                 }
765         }
766         revert OwnerQueryForNonexistentToken();
767     }
768 
769     /**
770      * Returns the unpacked `TokenOwnership` struct from `packed`.
771      */
772     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
773         ownership.addr = address(uint160(packed));
774         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
775         ownership.burned = packed & BITMASK_BURNED != 0;
776         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
777     }
778 
779     /**
780      * Returns the unpacked `TokenOwnership` struct at `index`.
781      */
782     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
783         return _unpackedOwnership(_packedOwnerships[index]);
784     }
785 
786     /**
787      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
788      */
789     function _initializeOwnershipAt(uint256 index) internal {
790         if (_packedOwnerships[index] == 0) {
791             _packedOwnerships[index] = _packedOwnershipOf(index);
792         }
793     }
794 
795     /**
796      * Gas spent here starts off proportional to the maximum mint batch size.
797      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
798      */
799     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
800         return _unpackedOwnership(_packedOwnershipOf(tokenId));
801     }
802 
803     /**
804      * @dev Packs ownership data into a single uint256.
805      */
806     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
807         assembly {
808             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
809             owner := and(owner, BITMASK_ADDRESS)
810             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
811             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
812         }
813     }
814 
815     /**
816      * @dev See {IERC721-ownerOf}.
817      */
818     function ownerOf(uint256 tokenId) public view override returns (address) {
819         return address(uint160(_packedOwnershipOf(tokenId)));
820     }
821 
822     /**
823      * @dev See {IERC721Metadata-name}.
824      */
825     function name() public view virtual override returns (string memory) {
826         return _name;
827     }
828 
829     /**
830      * @dev See {IERC721Metadata-symbol}.
831      */
832     function symbol() public view virtual override returns (string memory) {
833         return _symbol;
834     }
835 
836     /**
837      * @dev See {IERC721Metadata-tokenURI}.
838      */
839     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
840         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
841 
842         string memory baseURI = _baseURI();
843         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
844     }
845 
846     /**
847      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
848      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
849      * by default, it can be overridden in child contracts.
850      */
851     function _baseURI() internal view virtual returns (string memory) {
852         return '';
853     }
854 
855     /**
856      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
857      */
858     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
859         // For branchless setting of the `nextInitialized` flag.
860         assembly {
861             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
862             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
863         }
864     }
865 
866     /**
867      * @dev See {IERC721-approve}.
868      */
869     function approve(address to, uint256 tokenId) public override {
870         address owner = ownerOf(tokenId);
871 
872         if (_msgSenderERC721A() != owner)
873             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
874                 revert ApprovalCallerNotOwnerNorApproved();
875             }
876 
877         _tokenApprovals[tokenId] = to;
878         emit Approval(owner, to, tokenId);
879     }
880 
881     /**
882      * @dev See {IERC721-getApproved}.
883      */
884     function getApproved(uint256 tokenId) public view override returns (address) {
885         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
886 
887         return _tokenApprovals[tokenId];
888     }
889 
890     /**
891      * @dev See {IERC721-setApprovalForAll}.
892      */
893     function setApprovalForAll(address operator, bool approved) public virtual override {
894         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
895 
896         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
897         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
898     }
899 
900     /**
901      * @dev See {IERC721-isApprovedForAll}.
902      */
903     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
904         return _operatorApprovals[owner][operator];
905     }
906 
907     /**
908      * @dev See {IERC721-safeTransferFrom}.
909      */
910     function safeTransferFrom(
911         address from,
912         address to,
913         uint256 tokenId
914     ) public virtual override {
915         safeTransferFrom(from, to, tokenId, '');
916     }
917 
918     /**
919      * @dev See {IERC721-safeTransferFrom}.
920      */
921     function safeTransferFrom(
922         address from,
923         address to,
924         uint256 tokenId,
925         bytes memory _data
926     ) public virtual override {
927         transferFrom(from, to, tokenId);
928         if (to.code.length != 0)
929             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
930                 revert TransferToNonERC721ReceiverImplementer();
931             }
932     }
933 
934     /**
935      * @dev Returns whether `tokenId` exists.
936      *
937      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
938      *
939      * Tokens start existing when they are minted (`_mint`),
940      */
941     function _exists(uint256 tokenId) internal view returns (bool) {
942         return
943             _startTokenId() <= tokenId &&
944             tokenId < _currentIndex && // If within bounds,
945             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
946     }
947 
948     /**
949      * @dev Equivalent to `_safeMint(to, quantity, '')`.
950      */
951     function _safeMint(address to, uint256 quantity) internal {
952         _safeMint(to, quantity, '');
953     }
954 
955     /**
956      * @dev Safely mints `quantity` tokens and transfers them to `to`.
957      *
958      * Requirements:
959      *
960      * - If `to` refers to a smart contract, it must implement
961      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
962      * - `quantity` must be greater than 0.
963      *
964      * See {_mint}.
965      *
966      * Emits a {Transfer} event for each mint.
967      */
968     function _safeMint(
969         address to,
970         uint256 quantity,
971         bytes memory _data
972     ) internal {
973         _mint(to, quantity);
974 
975         unchecked {
976             if (to.code.length != 0) {
977                 uint256 end = _currentIndex;
978                 uint256 index = end - quantity;
979                 do {
980                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
981                         revert TransferToNonERC721ReceiverImplementer();
982                     }
983                 } while (index < end);
984                 // Reentrancy protection.
985                 if (_currentIndex != end) revert();
986             }
987         }
988     }
989 
990     /**
991      * @dev Mints `quantity` tokens and transfers them to `to`.
992      *
993      * Requirements:
994      *
995      * - `to` cannot be the zero address.
996      * - `quantity` must be greater than 0.
997      *
998      * Emits a {Transfer} event for each mint.
999      */
1000     function _mint(address to, uint256 quantity) internal {
1001         uint256 startTokenId = _currentIndex;
1002         if (to == address(0)) revert MintToZeroAddress();
1003         if (quantity == 0) revert MintZeroQuantity();
1004 
1005         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1006 
1007         // Overflows are incredibly unrealistic.
1008         // `balance` and `numberMinted` have a maximum limit of 2**64.
1009         // `tokenId` has a maximum limit of 2**256.
1010         unchecked {
1011             // Updates:
1012             // - `balance += quantity`.
1013             // - `numberMinted += quantity`.
1014             //
1015             // We can directly add to the `balance` and `numberMinted`.
1016             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1017 
1018             // Updates:
1019             // - `address` to the owner.
1020             // - `startTimestamp` to the timestamp of minting.
1021             // - `burned` to `false`.
1022             // - `nextInitialized` to `quantity == 1`.
1023             _packedOwnerships[startTokenId] = _packOwnershipData(
1024                 to,
1025                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1026             );
1027 
1028             uint256 tokenId = startTokenId;
1029             uint256 end = startTokenId + quantity;
1030             do {
1031                 emit Transfer(address(0), to, tokenId++);
1032             } while (tokenId < end);
1033 
1034             _currentIndex = end;
1035         }
1036         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1037     }
1038 
1039     /**
1040      * @dev Mints `quantity` tokens and transfers them to `to`.
1041      *
1042      * This function is intended for efficient minting only during contract creation.
1043      *
1044      * It emits only one {ConsecutiveTransfer} as defined in
1045      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1046      * instead of a sequence of {Transfer} event(s).
1047      *
1048      * Calling this function outside of contract creation WILL make your contract
1049      * non-compliant with the ERC721 standard.
1050      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1051      * {ConsecutiveTransfer} event is only permissible during contract creation.
1052      *
1053      * Requirements:
1054      *
1055      * - `to` cannot be the zero address.
1056      * - `quantity` must be greater than 0.
1057      *
1058      * Emits a {ConsecutiveTransfer} event.
1059      */
1060     function _mintERC2309(address to, uint256 quantity) internal {
1061         uint256 startTokenId = _currentIndex;
1062         if (to == address(0)) revert MintToZeroAddress();
1063         if (quantity == 0) revert MintZeroQuantity();
1064         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1065 
1066         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1067 
1068         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1069         unchecked {
1070             // Updates:
1071             // - `balance += quantity`.
1072             // - `numberMinted += quantity`.
1073             //
1074             // We can directly add to the `balance` and `numberMinted`.
1075             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1076 
1077             // Updates:
1078             // - `address` to the owner.
1079             // - `startTimestamp` to the timestamp of minting.
1080             // - `burned` to `false`.
1081             // - `nextInitialized` to `quantity == 1`.
1082             _packedOwnerships[startTokenId] = _packOwnershipData(
1083                 to,
1084                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1085             );
1086 
1087             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1088 
1089             _currentIndex = startTokenId + quantity;
1090         }
1091         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1092     }
1093 
1094     /**
1095      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1096      */
1097     function _getApprovedAddress(uint256 tokenId)
1098         private
1099         view
1100         returns (uint256 approvedAddressSlot, address approvedAddress)
1101     {
1102         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1103         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1104         assembly {
1105             // Compute the slot.
1106             mstore(0x00, tokenId)
1107             mstore(0x20, tokenApprovalsPtr.slot)
1108             approvedAddressSlot := keccak256(0x00, 0x40)
1109             // Load the slot's value from storage.
1110             approvedAddress := sload(approvedAddressSlot)
1111         }
1112     }
1113 
1114     /**
1115      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1116      */
1117     function _isOwnerOrApproved(
1118         address approvedAddress,
1119         address from,
1120         address msgSender
1121     ) private pure returns (bool result) {
1122         assembly {
1123             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1124             from := and(from, BITMASK_ADDRESS)
1125             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1126             msgSender := and(msgSender, BITMASK_ADDRESS)
1127             // `msgSender == from || msgSender == approvedAddress`.
1128             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1129         }
1130     }
1131 
1132     /**
1133      * @dev Transfers `tokenId` from `from` to `to`.
1134      *
1135      * Requirements:
1136      *
1137      * - `to` cannot be the zero address.
1138      * - `tokenId` token must be owned by `from`.
1139      *
1140      * Emits a {Transfer} event.
1141      */
1142     function transferFrom(
1143         address from,
1144         address to,
1145         uint256 tokenId
1146     ) public virtual override {
1147         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1148 
1149         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1150 
1151         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1152 
1153         // The nested ifs save around 20+ gas over a compound boolean condition.
1154         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1155             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1156 
1157         if (to == address(0)) revert TransferToZeroAddress();
1158 
1159         _beforeTokenTransfers(from, to, tokenId, 1);
1160 
1161         // Clear approvals from the previous owner.
1162         assembly {
1163             if approvedAddress {
1164                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1165                 sstore(approvedAddressSlot, 0)
1166             }
1167         }
1168 
1169         // Underflow of the sender's balance is impossible because we check for
1170         // ownership above and the recipient's balance can't realistically overflow.
1171         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1172         unchecked {
1173             // We can directly increment and decrement the balances.
1174             --_packedAddressData[from]; // Updates: `balance -= 1`.
1175             ++_packedAddressData[to]; // Updates: `balance += 1`.
1176 
1177             // Updates:
1178             // - `address` to the next owner.
1179             // - `startTimestamp` to the timestamp of transfering.
1180             // - `burned` to `false`.
1181             // - `nextInitialized` to `true`.
1182             _packedOwnerships[tokenId] = _packOwnershipData(
1183                 to,
1184                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1185             );
1186 
1187             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1188             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1189                 uint256 nextTokenId = tokenId + 1;
1190                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1191                 if (_packedOwnerships[nextTokenId] == 0) {
1192                     // If the next slot is within bounds.
1193                     if (nextTokenId != _currentIndex) {
1194                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1195                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1196                     }
1197                 }
1198             }
1199         }
1200 
1201         emit Transfer(from, to, tokenId);
1202         _afterTokenTransfers(from, to, tokenId, 1);
1203     }
1204 
1205     /**
1206      * @dev Equivalent to `_burn(tokenId, false)`.
1207      */
1208     function _burn(uint256 tokenId) internal virtual {
1209         _burn(tokenId, false);
1210     }
1211 
1212     /**
1213      * @dev Destroys `tokenId`.
1214      * The approval is cleared when the token is burned.
1215      *
1216      * Requirements:
1217      *
1218      * - `tokenId` must exist.
1219      *
1220      * Emits a {Transfer} event.
1221      */
1222     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1223         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1224 
1225         address from = address(uint160(prevOwnershipPacked));
1226 
1227         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1228 
1229         if (approvalCheck) {
1230             // The nested ifs save around 20+ gas over a compound boolean condition.
1231             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1232                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1233         }
1234 
1235         _beforeTokenTransfers(from, address(0), tokenId, 1);
1236 
1237         // Clear approvals from the previous owner.
1238         assembly {
1239             if approvedAddress {
1240                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1241                 sstore(approvedAddressSlot, 0)
1242             }
1243         }
1244 
1245         // Underflow of the sender's balance is impossible because we check for
1246         // ownership above and the recipient's balance can't realistically overflow.
1247         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1248         unchecked {
1249             // Updates:
1250             // - `balance -= 1`.
1251             // - `numberBurned += 1`.
1252             //
1253             // We can directly decrement the balance, and increment the number burned.
1254             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1255             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1256 
1257             // Updates:
1258             // - `address` to the last owner.
1259             // - `startTimestamp` to the timestamp of burning.
1260             // - `burned` to `true`.
1261             // - `nextInitialized` to `true`.
1262             _packedOwnerships[tokenId] = _packOwnershipData(
1263                 from,
1264                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1265             );
1266 
1267             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1268             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1269                 uint256 nextTokenId = tokenId + 1;
1270                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1271                 if (_packedOwnerships[nextTokenId] == 0) {
1272                     // If the next slot is within bounds.
1273                     if (nextTokenId != _currentIndex) {
1274                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1275                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1276                     }
1277                 }
1278             }
1279         }
1280 
1281         emit Transfer(from, address(0), tokenId);
1282         _afterTokenTransfers(from, address(0), tokenId, 1);
1283 
1284         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1285         unchecked {
1286             _burnCounter++;
1287         }
1288     }
1289 
1290     /**
1291      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1292      *
1293      * @param from address representing the previous owner of the given token ID
1294      * @param to target address that will receive the tokens
1295      * @param tokenId uint256 ID of the token to be transferred
1296      * @param _data bytes optional data to send along with the call
1297      * @return bool whether the call correctly returned the expected magic value
1298      */
1299     function _checkContractOnERC721Received(
1300         address from,
1301         address to,
1302         uint256 tokenId,
1303         bytes memory _data
1304     ) private returns (bool) {
1305         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1306             bytes4 retval
1307         ) {
1308             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1309         } catch (bytes memory reason) {
1310             if (reason.length == 0) {
1311                 revert TransferToNonERC721ReceiverImplementer();
1312             } else {
1313                 assembly {
1314                     revert(add(32, reason), mload(reason))
1315                 }
1316             }
1317         }
1318     }
1319 
1320     /**
1321      * @dev Directly sets the extra data for the ownership data `index`.
1322      */
1323     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1324         uint256 packed = _packedOwnerships[index];
1325         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1326         uint256 extraDataCasted;
1327         // Cast `extraData` with assembly to avoid redundant masking.
1328         assembly {
1329             extraDataCasted := extraData
1330         }
1331         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1332         _packedOwnerships[index] = packed;
1333     }
1334 
1335     /**
1336      * @dev Returns the next extra data for the packed ownership data.
1337      * The returned result is shifted into position.
1338      */
1339     function _nextExtraData(
1340         address from,
1341         address to,
1342         uint256 prevOwnershipPacked
1343     ) private view returns (uint256) {
1344         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1345         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1346     }
1347 
1348     /**
1349      * @dev Called during each token transfer to set the 24bit `extraData` field.
1350      * Intended to be overridden by the cosumer contract.
1351      *
1352      * `previousExtraData` - the value of `extraData` before transfer.
1353      *
1354      * Calling conditions:
1355      *
1356      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1357      * transferred to `to`.
1358      * - When `from` is zero, `tokenId` will be minted for `to`.
1359      * - When `to` is zero, `tokenId` will be burned by `from`.
1360      * - `from` and `to` are never both zero.
1361      */
1362     function _extraData(
1363         address from,
1364         address to,
1365         uint24 previousExtraData
1366     ) internal view virtual returns (uint24) {}
1367 
1368     /**
1369      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1370      * This includes minting.
1371      * And also called before burning one token.
1372      *
1373      * startTokenId - the first token id to be transferred
1374      * quantity - the amount to be transferred
1375      *
1376      * Calling conditions:
1377      *
1378      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1379      * transferred to `to`.
1380      * - When `from` is zero, `tokenId` will be minted for `to`.
1381      * - When `to` is zero, `tokenId` will be burned by `from`.
1382      * - `from` and `to` are never both zero.
1383      */
1384     function _beforeTokenTransfers(
1385         address from,
1386         address to,
1387         uint256 startTokenId,
1388         uint256 quantity
1389     ) internal virtual {}
1390 
1391     /**
1392      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1393      * This includes minting.
1394      * And also called after one token has been burned.
1395      *
1396      * startTokenId - the first token id to be transferred
1397      * quantity - the amount to be transferred
1398      *
1399      * Calling conditions:
1400      *
1401      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1402      * transferred to `to`.
1403      * - When `from` is zero, `tokenId` has been minted for `to`.
1404      * - When `to` is zero, `tokenId` has been burned by `from`.
1405      * - `from` and `to` are never both zero.
1406      */
1407     function _afterTokenTransfers(
1408         address from,
1409         address to,
1410         uint256 startTokenId,
1411         uint256 quantity
1412     ) internal virtual {}
1413 
1414     /**
1415      * @dev Returns the message sender (defaults to `msg.sender`).
1416      *
1417      * If you are writing GSN compatible contracts, you need to override this function.
1418      */
1419     function _msgSenderERC721A() internal view virtual returns (address) {
1420         return msg.sender;
1421     }
1422 
1423     /**
1424      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1425      */
1426     function _toString(uint256 value) internal pure returns (string memory ptr) {
1427         assembly {
1428             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1429             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1430             // We will need 1 32-byte word to store the length,
1431             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1432             ptr := add(mload(0x40), 128)
1433             // Update the free memory pointer to allocate.
1434             mstore(0x40, ptr)
1435 
1436             // Cache the end of the memory to calculate the length later.
1437             let end := ptr
1438 
1439             // We write the string from the rightmost digit to the leftmost digit.
1440             // The following is essentially a do-while loop that also handles the zero case.
1441             // Costs a bit more than early returning for the zero case,
1442             // but cheaper in terms of deployment and overall runtime costs.
1443             for {
1444                 // Initialize and perform the first pass without check.
1445                 let temp := value
1446                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1447                 ptr := sub(ptr, 1)
1448                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1449                 mstore8(ptr, add(48, mod(temp, 10)))
1450                 temp := div(temp, 10)
1451             } temp {
1452                 // Keep dividing `temp` until zero.
1453                 temp := div(temp, 10)
1454             } {
1455                 // Body of the for loop.
1456                 ptr := sub(ptr, 1)
1457                 mstore8(ptr, add(48, mod(temp, 10)))
1458             }
1459 
1460             let length := sub(end, ptr)
1461             // Move the pointer 32 bytes leftwards to make room for the length.
1462             ptr := sub(ptr, 32)
1463             // Store the length.
1464             mstore(ptr, length)
1465         }
1466     }
1467 }
1468 
1469 // File: contracts/Bozo.sol
1470 
1471 
1472 
1473 pragma solidity >=0.8.7;
1474 
1475 
1476 
1477 
1478 
1479 
1480 contract Bozo is ERC721A, Ownable {
1481     //@dev Attributes for NFT configuration
1482     string internal baseURI;
1483     uint256 public cost = 0.0035 ether;
1484     uint256 public maxSupply = 6666;
1485     uint public MAX_FREE_SUPPLY = 3333;
1486 
1487     uint256 public MAX_FREE_PER_TX = 2;
1488     uint256 public MAX_MINT_PER_TX = 5;
1489     uint256 public freeMints = 0;
1490     mapping(uint256 => string) private _tokenURIs;
1491     bool public paused;
1492     
1493     // @dev inner attributes of the contract
1494     constructor(string memory _uri) ERC721A("Bozo", "Bozo") {
1495         baseURI = _uri;
1496     }
1497 
1498     function mintDevSupply(uint _amount) external onlyOwner {
1499         _safeMint(msg.sender, _amount);
1500     }
1501     
1502     modifier priceCheck(uint _amount) {
1503         uint eligibleFreemint = 0;
1504         if(freeMints < MAX_FREE_SUPPLY)
1505             eligibleFreemint = MAX_FREE_SUPPLY - freeMints;
1506 
1507         if (eligibleFreemint > 1) eligibleFreemint = 2;
1508 
1509         require(msg.value == cost * ( _amount - eligibleFreemint ), "Invalid ETH amount");
1510         _;
1511     }
1512 
1513     function _startTokenId() internal view virtual override returns (uint256) {
1514         return 1;
1515     }    
1516     function pause(bool _state) external onlyOwner {
1517         paused = _state;
1518     }
1519     /**
1520      * @dev get base URI for NFT metadata
1521      */
1522     function _baseURI() internal view virtual override returns (string memory) {
1523         return baseURI;
1524     }
1525 
1526     function mint(uint256 amount) external payable {
1527         uint costFull = getCost(amount);
1528         require(msg.value == costFull, "Invalid ETH amount");
1529         require(!paused, "Contract is paused.");
1530         require(amount <= MAX_MINT_PER_TX, "Exceed max mintable amount");
1531         require(totalSupply() + amount <= maxSupply, "Exceeds max supply.");
1532 
1533         if(amount > 1)
1534             freeMints += 2;
1535         else 
1536             freeMints++;
1537         _safeMint(msg.sender, amount);
1538     }
1539 
1540     /**
1541      * @dev change cost of NFT
1542      * @param _newCost new cost of each edition
1543      */
1544     function setCost(uint256 _newCost) external onlyOwner {
1545         cost = _newCost;
1546     }
1547 
1548 
1549     /**
1550      * @dev change metadata uri
1551      * @param _newBaseURI new URI for metadata
1552      */
1553     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1554         baseURI = _newBaseURI;
1555     }
1556 
1557     /**
1558      * @dev Get token URI
1559      * @param tokenId ID of the token to retrieve
1560      */
1561     function tokenURI(uint256 tokenId)
1562         public
1563         view
1564         virtual
1565         override
1566         returns (string memory)
1567     {
1568         require(
1569             _exists(tokenId),
1570             "URI query for nonexistent token"
1571         );
1572 
1573         if (bytes(_tokenURIs[tokenId]).length == 0) {
1574             string memory currentBaseURI = _baseURI();
1575             return
1576                 bytes(currentBaseURI).length > 0
1577                     ? string(
1578                         abi.encodePacked(
1579                             currentBaseURI,
1580                             Strings.toString(tokenId),
1581                             ".json"
1582                         )
1583                     )
1584                     : "";
1585         } else return _tokenURIs[tokenId];
1586     }
1587 
1588     function getCost(uint amount) public view returns(uint) {
1589         uint eligibleFreemint = 0;
1590         if(freeMints < MAX_FREE_SUPPLY)
1591             eligibleFreemint = MAX_FREE_SUPPLY - freeMints;
1592 
1593         if (eligibleFreemint > 1) eligibleFreemint = 2;
1594         return cost * ( amount - eligibleFreemint );
1595     }
1596 
1597     function withdraw() external payable onlyOwner {
1598         // This will payout the owner 100% of the contract balance.
1599         // =============================================================================
1600         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1601         require(os);
1602     }
1603 }