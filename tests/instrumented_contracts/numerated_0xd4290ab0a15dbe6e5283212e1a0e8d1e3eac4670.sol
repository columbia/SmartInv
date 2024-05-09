1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 //    ____ ____  _____ ____ ___ _____ ____         _   _   _ ____      _    ____ _     _____ ____    ____  _______     __  _____ _____    _    __  __ 
5 //  / ___|  _ \| ____|  _ \_ _|_   _/ ___|_      / \ | | | |  _ \    / \  / ___| |   | ____/ ___|  |  _ \| ____\ \   / / |_   _| ____|  / \  |  \/  |
6 // | |   | |_) |  _| | | | | |  | | \___ (_)    / _ \| | | | |_) |  / _ \| |   | |   |  _| \___ \  | | | |  _|  \ \ / /    | | |  _|   / _ \ | |\/| |
7 // | |___|  _ <| |___| |_| | |  | |  ___) |    / ___ \ |_| |  _ <  / ___ \ |___| |___| |___ ___) | | |_| | |___  \ V /     | | | |___ / ___ \| |  | |
8 //  \____|_| \_\_____|____/___| |_| |____(_)  /_/   \_\___/|_| \_\/_/   \_\____|_____|_____|____/  |____/|_____|  \_/      |_| |_____/_/   \_\_|  |_|
9 
10 // Spaceboy & Helios
11 
12 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev These functions deal with verification of Merkle Trees proofs.
18  *
19  * The proofs can be generated using the JavaScript library
20  * https://github.com/miguelmota/merkletreejs[merkletreejs].
21  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
22  *
23  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
24  *
25  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
26  * hashing, or use a hash function other than keccak256 for hashing leaves.
27  * This is because the concatenation of a sorted pair of internal nodes in
28  * the merkle tree could be reinterpreted as a leaf value.
29  */
30 library MerkleProof {
31     /**
32      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
33      * defined by `root`. For this, a `proof` must be provided, containing
34      * sibling hashes on the branch from the leaf to the root of the tree. Each
35      * pair of leaves and each pair of pre-images are assumed to be sorted.
36      */
37     function verify(
38         bytes32[] memory proof,
39         bytes32 root,
40         bytes32 leaf
41     ) internal pure returns (bool) {
42         return processProof(proof, leaf) == root;
43     }
44 
45     /**
46      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
47      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
48      * hash matches the root of the tree. When processing the proof, the pairs
49      * of leafs & pre-images are assumed to be sorted.
50      *
51      * _Available since v4.4._
52      */
53     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
54         bytes32 computedHash = leaf;
55         for (uint256 i = 0; i < proof.length; i++) {
56             bytes32 proofElement = proof[i];
57             if (computedHash <= proofElement) {
58                 // Hash(current computed hash + current element of the proof)
59                 computedHash = _efficientHash(computedHash, proofElement);
60             } else {
61                 // Hash(current element of the proof + current computed hash)
62                 computedHash = _efficientHash(proofElement, computedHash);
63             }
64         }
65         return computedHash;
66     }
67 
68     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
69         assembly {
70             mstore(0x00, a)
71             mstore(0x20, b)
72             value := keccak256(0x00, 0x40)
73         }
74     }
75 }
76 
77 // File: @openzeppelin/contracts/utils/Strings.sol
78 
79 
80 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
81 
82 pragma solidity ^0.8.0;
83 
84 /**
85  * @dev String operations.
86  */
87 library Strings {
88     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
89 
90     /**
91      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
92      */
93     function toString(uint256 value) internal pure returns (string memory) {
94         // Inspired by OraclizeAPI's implementation - MIT licence
95         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
96 
97         if (value == 0) {
98             return "0";
99         }
100         uint256 temp = value;
101         uint256 digits;
102         while (temp != 0) {
103             digits++;
104             temp /= 10;
105         }
106         bytes memory buffer = new bytes(digits);
107         while (value != 0) {
108             digits -= 1;
109             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
110             value /= 10;
111         }
112         return string(buffer);
113     }
114 
115     /**
116      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
117      */
118     function toHexString(uint256 value) internal pure returns (string memory) {
119         if (value == 0) {
120             return "0x00";
121         }
122         uint256 temp = value;
123         uint256 length = 0;
124         while (temp != 0) {
125             length++;
126             temp >>= 8;
127         }
128         return toHexString(value, length);
129     }
130 
131     /**
132      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
133      */
134     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
135         bytes memory buffer = new bytes(2 * length + 2);
136         buffer[0] = "0";
137         buffer[1] = "x";
138         for (uint256 i = 2 * length + 1; i > 1; --i) {
139             buffer[i] = _HEX_SYMBOLS[value & 0xf];
140             value >>= 4;
141         }
142         require(value == 0, "Strings: hex length insufficient");
143         return string(buffer);
144     }
145 }
146 
147 // File: @openzeppelin/contracts/utils/Context.sol
148 
149 
150 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
151 
152 pragma solidity ^0.8.0;
153 
154 /**
155  * @dev Provides information about the current execution context, including the
156  * sender of the transaction and its data. While these are generally available
157  * via msg.sender and msg.data, they should not be accessed in such a direct
158  * manner, since when dealing with meta-transactions the account sending and
159  * paying for execution may not be the actual sender (as far as an application
160  * is concerned).
161  *
162  * This contract is only required for intermediate, library-like contracts.
163  */
164 abstract contract Context {
165     function _msgSender() internal view virtual returns (address) {
166         return msg.sender;
167     }
168 
169     function _msgData() internal view virtual returns (bytes calldata) {
170         return msg.data;
171     }
172 }
173 
174 // File: @openzeppelin/contracts/access/Ownable.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 
182 /**
183  * @dev Contract module which provides a basic access control mechanism, where
184  * there is an account (an owner) that can be granted exclusive access to
185  * specific functions.
186  *
187  * By default, the owner account will be the one that deploys the contract. This
188  * can later be changed with {transferOwnership}.
189  *
190  * This module is used through inheritance. It will make available the modifier
191  * `onlyOwner`, which can be applied to your functions to restrict their use to
192  * the owner.
193  */
194 abstract contract Ownable is Context {
195     address private _owner;
196 
197     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
198 
199     /**
200      * @dev Initializes the contract setting the deployer as the initial owner.
201      */
202     constructor() {
203         _transferOwnership(_msgSender());
204     }
205 
206     /**
207      * @dev Returns the address of the current owner.
208      */
209     function owner() public view virtual returns (address) {
210         return _owner;
211     }
212 
213     /**
214      * @dev Throws if called by any account other than the owner.
215      */
216     modifier onlyOwner() {
217         require(owner() == _msgSender(), "Ownable: caller is not the owner");
218         _;
219     }
220 
221     /**
222      * @dev Leaves the contract without owner. It will not be possible to call
223      * `onlyOwner` functions anymore. Can only be called by the current owner.
224      *
225      * NOTE: Renouncing ownership will leave the contract without an owner,
226      * thereby removing any functionality that is only available to the owner.
227      */
228     function renounceOwnership() public virtual onlyOwner {
229         _transferOwnership(address(0));
230     }
231 
232     /**
233      * @dev Transfers ownership of the contract to a new account (`newOwner`).
234      * Can only be called by the current owner.
235      */
236     function transferOwnership(address newOwner) public virtual onlyOwner {
237         require(newOwner != address(0), "Ownable: new owner is the zero address");
238         _transferOwnership(newOwner);
239     }
240 
241     /**
242      * @dev Transfers ownership of the contract to a new account (`newOwner`).
243      * Internal function without access restriction.
244      */
245     function _transferOwnership(address newOwner) internal virtual {
246         address oldOwner = _owner;
247         _owner = newOwner;
248         emit OwnershipTransferred(oldOwner, newOwner);
249     }
250 }
251 
252 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
253 
254 
255 // ERC721A Contracts v4.1.0
256 // Creator: Chiru Labs
257 
258 pragma solidity ^0.8.4;
259 
260 /**
261  * @dev Interface of an ERC721A compliant contract.
262  */
263 interface IERC721A {
264     /**
265      * The caller must own the token or be an approved operator.
266      */
267     error ApprovalCallerNotOwnerNorApproved();
268 
269     /**
270      * The token does not exist.
271      */
272     error ApprovalQueryForNonexistentToken();
273 
274     /**
275      * The caller cannot approve to their own address.
276      */
277     error ApproveToCaller();
278 
279     /**
280      * Cannot query the balance for the zero address.
281      */
282     error BalanceQueryForZeroAddress();
283 
284     /**
285      * Cannot mint to the zero address.
286      */
287     error MintToZeroAddress();
288 
289     /**
290      * The quantity of tokens minted must be more than zero.
291      */
292     error MintZeroQuantity();
293 
294     /**
295      * The token does not exist.
296      */
297     error OwnerQueryForNonexistentToken();
298 
299     /**
300      * The caller must own the token or be an approved operator.
301      */
302     error TransferCallerNotOwnerNorApproved();
303 
304     /**
305      * The token must be owned by `from`.
306      */
307     error TransferFromIncorrectOwner();
308 
309     /**
310      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
311      */
312     error TransferToNonERC721ReceiverImplementer();
313 
314     /**
315      * Cannot transfer to the zero address.
316      */
317     error TransferToZeroAddress();
318 
319     /**
320      * The token does not exist.
321      */
322     error URIQueryForNonexistentToken();
323 
324     /**
325      * The `quantity` minted with ERC2309 exceeds the safety limit.
326      */
327     error MintERC2309QuantityExceedsLimit();
328 
329     /**
330      * The `extraData` cannot be set on an unintialized ownership slot.
331      */
332     error OwnershipNotInitializedForExtraData();
333 
334     struct TokenOwnership {
335         // The address of the owner.
336         address addr;
337         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
338         uint64 startTimestamp;
339         // Whether the token has been burned.
340         bool burned;
341         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
342         uint24 extraData;
343     }
344 
345     /**
346      * @dev Returns the total amount of tokens stored by the contract.
347      *
348      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
349      */
350     function totalSupply() external view returns (uint256);
351 
352     // ==============================
353     //            IERC165
354     // ==============================
355 
356     /**
357      * @dev Returns true if this contract implements the interface defined by
358      * `interfaceId`. See the corresponding
359      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
360      * to learn more about how these ids are created.
361      *
362      * This function call must use less than 30 000 gas.
363      */
364     function supportsInterface(bytes4 interfaceId) external view returns (bool);
365 
366     // ==============================
367     //            IERC721
368     // ==============================
369 
370     /**
371      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
372      */
373     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
374 
375     /**
376      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
377      */
378     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
379 
380     /**
381      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
382      */
383     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
384 
385     /**
386      * @dev Returns the number of tokens in ``owner``'s account.
387      */
388     function balanceOf(address owner) external view returns (uint256 balance);
389 
390     /**
391      * @dev Returns the owner of the `tokenId` token.
392      *
393      * Requirements:
394      *
395      * - `tokenId` must exist.
396      */
397     function ownerOf(uint256 tokenId) external view returns (address owner);
398 
399     /**
400      * @dev Safely transfers `tokenId` token from `from` to `to`.
401      *
402      * Requirements:
403      *
404      * - `from` cannot be the zero address.
405      * - `to` cannot be the zero address.
406      * - `tokenId` token must exist and be owned by `from`.
407      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
408      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
409      *
410      * Emits a {Transfer} event.
411      */
412     function safeTransferFrom(
413         address from,
414         address to,
415         uint256 tokenId,
416         bytes calldata data
417     ) external;
418 
419     /**
420      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
421      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
422      *
423      * Requirements:
424      *
425      * - `from` cannot be the zero address.
426      * - `to` cannot be the zero address.
427      * - `tokenId` token must exist and be owned by `from`.
428      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
429      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
430      *
431      * Emits a {Transfer} event.
432      */
433     function safeTransferFrom(
434         address from,
435         address to,
436         uint256 tokenId
437     ) external;
438 
439     /**
440      * @dev Transfers `tokenId` token from `from` to `to`.
441      *
442      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
443      *
444      * Requirements:
445      *
446      * - `from` cannot be the zero address.
447      * - `to` cannot be the zero address.
448      * - `tokenId` token must be owned by `from`.
449      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
450      *
451      * Emits a {Transfer} event.
452      */
453     function transferFrom(
454         address from,
455         address to,
456         uint256 tokenId
457     ) external;
458 
459     /**
460      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
461      * The approval is cleared when the token is transferred.
462      *
463      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
464      *
465      * Requirements:
466      *
467      * - The caller must own the token or be an approved operator.
468      * - `tokenId` must exist.
469      *
470      * Emits an {Approval} event.
471      */
472     function approve(address to, uint256 tokenId) external;
473 
474     /**
475      * @dev Approve or remove `operator` as an operator for the caller.
476      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
477      *
478      * Requirements:
479      *
480      * - The `operator` cannot be the caller.
481      *
482      * Emits an {ApprovalForAll} event.
483      */
484     function setApprovalForAll(address operator, bool _approved) external;
485 
486     /**
487      * @dev Returns the account approved for `tokenId` token.
488      *
489      * Requirements:
490      *
491      * - `tokenId` must exist.
492      */
493     function getApproved(uint256 tokenId) external view returns (address operator);
494 
495     /**
496      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
497      *
498      * See {setApprovalForAll}
499      */
500     function isApprovedForAll(address owner, address operator) external view returns (bool);
501 
502     // ==============================
503     //        IERC721Metadata
504     // ==============================
505 
506     /**
507      * @dev Returns the token collection name.
508      */
509     function name() external view returns (string memory);
510 
511     /**
512      * @dev Returns the token collection symbol.
513      */
514     function symbol() external view returns (string memory);
515 
516     /**
517      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
518      */
519     function tokenURI(uint256 tokenId) external view returns (string memory);
520 
521     // ==============================
522     //            IERC2309
523     // ==============================
524 
525     /**
526      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
527      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
528      */
529     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
530 }
531 
532 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
533 
534 
535 // ERC721A Contracts v4.1.0
536 // Creator: Chiru Labs
537 
538 pragma solidity ^0.8.4;
539 
540 
541 /**
542  * @dev ERC721 token receiver interface.
543  */
544 interface ERC721A__IERC721Receiver {
545     function onERC721Received(
546         address operator,
547         address from,
548         uint256 tokenId,
549         bytes calldata data
550     ) external returns (bytes4);
551 }
552 
553 /**
554  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
555  * including the Metadata extension. Built to optimize for lower gas during batch mints.
556  *
557  * Assumes serials are sequentially minted starting at `_startTokenId()`
558  * (defaults to 0, e.g. 0, 1, 2, 3..).
559  *
560  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
561  *
562  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
563  */
564 contract ERC721A is IERC721A {
565     // Mask of an entry in packed address data.
566     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
567 
568     // The bit position of `numberMinted` in packed address data.
569     uint256 private constant BITPOS_NUMBER_MINTED = 64;
570 
571     // The bit position of `numberBurned` in packed address data.
572     uint256 private constant BITPOS_NUMBER_BURNED = 128;
573 
574     // The bit position of `aux` in packed address data.
575     uint256 private constant BITPOS_AUX = 192;
576 
577     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
578     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
579 
580     // The bit position of `startTimestamp` in packed ownership.
581     uint256 private constant BITPOS_START_TIMESTAMP = 160;
582 
583     // The bit mask of the `burned` bit in packed ownership.
584     uint256 private constant BITMASK_BURNED = 1 << 224;
585 
586     // The bit position of the `nextInitialized` bit in packed ownership.
587     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
588 
589     // The bit mask of the `nextInitialized` bit in packed ownership.
590     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
591 
592     // The bit position of `extraData` in packed ownership.
593     uint256 private constant BITPOS_EXTRA_DATA = 232;
594 
595     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
596     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
597 
598     // The mask of the lower 160 bits for addresses.
599     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
600 
601     // The maximum `quantity` that can be minted with `_mintERC2309`.
602     // This limit is to prevent overflows on the address data entries.
603     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
604     // is required to cause an overflow, which is unrealistic.
605     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
606 
607     // The tokenId of the next token to be minted.
608     uint256 private _currentIndex;
609 
610     // The number of tokens burned.
611     uint256 private _burnCounter;
612 
613     // Token name
614     string private _name;
615 
616     // Token symbol
617     string private _symbol;
618 
619     // Mapping from token ID to ownership details
620     // An empty struct value does not necessarily mean the token is unowned.
621     // See `_packedOwnershipOf` implementation for details.
622     //
623     // Bits Layout:
624     // - [0..159]   `addr`
625     // - [160..223] `startTimestamp`
626     // - [224]      `burned`
627     // - [225]      `nextInitialized`
628     // - [232..255] `extraData`
629     mapping(uint256 => uint256) private _packedOwnerships;
630 
631     // Mapping owner address to address data.
632     //
633     // Bits Layout:
634     // - [0..63]    `balance`
635     // - [64..127]  `numberMinted`
636     // - [128..191] `numberBurned`
637     // - [192..255] `aux`
638     mapping(address => uint256) private _packedAddressData;
639 
640     // Mapping from token ID to approved address.
641     mapping(uint256 => address) private _tokenApprovals;
642 
643     // Mapping from owner to operator approvals
644     mapping(address => mapping(address => bool)) private _operatorApprovals;
645 
646     constructor(string memory name_, string memory symbol_) {
647         _name = name_;
648         _symbol = symbol_;
649         _currentIndex = _startTokenId();
650     }
651 
652     /**
653      * @dev Returns the starting token ID.
654      * To change the starting token ID, please override this function.
655      */
656     function _startTokenId() internal view virtual returns (uint256) {
657         return 0;
658     }
659 
660     /**
661      * @dev Returns the next token ID to be minted.
662      */
663     function _nextTokenId() internal view returns (uint256) {
664         return _currentIndex;
665     }
666 
667     /**
668      * @dev Returns the total number of tokens in existence.
669      * Burned tokens will reduce the count.
670      * To get the total number of tokens minted, please see `_totalMinted`.
671      */
672     function totalSupply() public view override returns (uint256) {
673         // Counter underflow is impossible as _burnCounter cannot be incremented
674         // more than `_currentIndex - _startTokenId()` times.
675         unchecked {
676             return _currentIndex - _burnCounter - _startTokenId();
677         }
678     }
679 
680     /**
681      * @dev Returns the total amount of tokens minted in the contract.
682      */
683     function _totalMinted() internal view returns (uint256) {
684         // Counter underflow is impossible as _currentIndex does not decrement,
685         // and it is initialized to `_startTokenId()`
686         unchecked {
687             return _currentIndex - _startTokenId();
688         }
689     }
690 
691     /**
692      * @dev Returns the total number of tokens burned.
693      */
694     function _totalBurned() internal view returns (uint256) {
695         return _burnCounter;
696     }
697 
698     /**
699      * @dev See {IERC165-supportsInterface}.
700      */
701     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
702         // The interface IDs are constants representing the first 4 bytes of the XOR of
703         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
704         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
705         return
706             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
707             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
708             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
709     }
710 
711     /**
712      * @dev See {IERC721-balanceOf}.
713      */
714     function balanceOf(address owner) public view override returns (uint256) {
715         if (owner == address(0)) revert BalanceQueryForZeroAddress();
716         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
717     }
718 
719     /**
720      * Returns the number of tokens minted by `owner`.
721      */
722     function _numberMinted(address owner) internal view returns (uint256) {
723         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
724     }
725 
726     /**
727      * Returns the number of tokens burned by or on behalf of `owner`.
728      */
729     function _numberBurned(address owner) internal view returns (uint256) {
730         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
731     }
732 
733     /**
734      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
735      */
736     function _getAux(address owner) internal view returns (uint64) {
737         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
738     }
739 
740     /**
741      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
742      * If there are multiple variables, please pack them into a uint64.
743      */
744     function _setAux(address owner, uint64 aux) internal {
745         uint256 packed = _packedAddressData[owner];
746         uint256 auxCasted;
747         // Cast `aux` with assembly to avoid redundant masking.
748         assembly {
749             auxCasted := aux
750         }
751         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
752         _packedAddressData[owner] = packed;
753     }
754 
755     /**
756      * Returns the packed ownership data of `tokenId`.
757      */
758     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
759         uint256 curr = tokenId;
760 
761         unchecked {
762             if (_startTokenId() <= curr)
763                 if (curr < _currentIndex) {
764                     uint256 packed = _packedOwnerships[curr];
765                     // If not burned.
766                     if (packed & BITMASK_BURNED == 0) {
767                         // Invariant:
768                         // There will always be an ownership that has an address and is not burned
769                         // before an ownership that does not have an address and is not burned.
770                         // Hence, curr will not underflow.
771                         //
772                         // We can directly compare the packed value.
773                         // If the address is zero, packed is zero.
774                         while (packed == 0) {
775                             packed = _packedOwnerships[--curr];
776                         }
777                         return packed;
778                     }
779                 }
780         }
781         revert OwnerQueryForNonexistentToken();
782     }
783 
784     /**
785      * Returns the unpacked `TokenOwnership` struct from `packed`.
786      */
787     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
788         ownership.addr = address(uint160(packed));
789         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
790         ownership.burned = packed & BITMASK_BURNED != 0;
791         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
792     }
793 
794     /**
795      * Returns the unpacked `TokenOwnership` struct at `index`.
796      */
797     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
798         return _unpackedOwnership(_packedOwnerships[index]);
799     }
800 
801     /**
802      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
803      */
804     function _initializeOwnershipAt(uint256 index) internal {
805         if (_packedOwnerships[index] == 0) {
806             _packedOwnerships[index] = _packedOwnershipOf(index);
807         }
808     }
809 
810     /**
811      * Gas spent here starts off proportional to the maximum mint batch size.
812      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
813      */
814     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
815         return _unpackedOwnership(_packedOwnershipOf(tokenId));
816     }
817 
818     /**
819      * @dev Packs ownership data into a single uint256.
820      */
821     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
822         assembly {
823             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
824             owner := and(owner, BITMASK_ADDRESS)
825             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
826             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
827         }
828     }
829 
830     /**
831      * @dev See {IERC721-ownerOf}.
832      */
833     function ownerOf(uint256 tokenId) public view override returns (address) {
834         return address(uint160(_packedOwnershipOf(tokenId)));
835     }
836 
837     /**
838      * @dev See {IERC721Metadata-name}.
839      */
840     function name() public view virtual override returns (string memory) {
841         return _name;
842     }
843 
844     /**
845      * @dev See {IERC721Metadata-symbol}.
846      */
847     function symbol() public view virtual override returns (string memory) {
848         return _symbol;
849     }
850 
851     /**
852      * @dev See {IERC721Metadata-tokenURI}.
853      */
854     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
855         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
856 
857         string memory baseURI = _baseURI();
858         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
859     }
860 
861     /**
862      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
863      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
864      * by default, it can be overridden in child contracts.
865      */
866     function _baseURI() internal view virtual returns (string memory) {
867         return '';
868     }
869 
870     /**
871      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
872      */
873     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
874         // For branchless setting of the `nextInitialized` flag.
875         assembly {
876             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
877             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
878         }
879     }
880 
881     /**
882      * @dev See {IERC721-approve}.
883      */
884     function approve(address to, uint256 tokenId) public override {
885         address owner = ownerOf(tokenId);
886 
887         if (_msgSenderERC721A() != owner)
888             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
889                 revert ApprovalCallerNotOwnerNorApproved();
890             }
891 
892         _tokenApprovals[tokenId] = to;
893         emit Approval(owner, to, tokenId);
894     }
895 
896     /**
897      * @dev See {IERC721-getApproved}.
898      */
899     function getApproved(uint256 tokenId) public view override returns (address) {
900         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
901 
902         return _tokenApprovals[tokenId];
903     }
904 
905     /**
906      * @dev See {IERC721-setApprovalForAll}.
907      */
908     function setApprovalForAll(address operator, bool approved) public virtual override {
909         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
910 
911         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
912         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
913     }
914 
915     /**
916      * @dev See {IERC721-isApprovedForAll}.
917      */
918     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
919         return _operatorApprovals[owner][operator];
920     }
921 
922     /**
923      * @dev See {IERC721-safeTransferFrom}.
924      */
925     function safeTransferFrom(
926         address from,
927         address to,
928         uint256 tokenId
929     ) public virtual override {
930         safeTransferFrom(from, to, tokenId, '');
931     }
932 
933     /**
934      * @dev See {IERC721-safeTransferFrom}.
935      */
936     function safeTransferFrom(
937         address from,
938         address to,
939         uint256 tokenId,
940         bytes memory _data
941     ) public virtual override {
942         transferFrom(from, to, tokenId);
943         if (to.code.length != 0)
944             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
945                 revert TransferToNonERC721ReceiverImplementer();
946             }
947     }
948 
949     /**
950      * @dev Returns whether `tokenId` exists.
951      *
952      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
953      *
954      * Tokens start existing when they are minted (`_mint`),
955      */
956     function _exists(uint256 tokenId) internal view returns (bool) {
957         return
958             _startTokenId() <= tokenId &&
959             tokenId < _currentIndex && // If within bounds,
960             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
961     }
962 
963     /**
964      * @dev Equivalent to `_safeMint(to, quantity, '')`.
965      */
966     function _safeMint(address to, uint256 quantity) internal {
967         _safeMint(to, quantity, '');
968     }
969 
970     /**
971      * @dev Safely mints `quantity` tokens and transfers them to `to`.
972      *
973      * Requirements:
974      *
975      * - If `to` refers to a smart contract, it must implement
976      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
977      * - `quantity` must be greater than 0.
978      *
979      * See {_mint}.
980      *
981      * Emits a {Transfer} event for each mint.
982      */
983     function _safeMint(
984         address to,
985         uint256 quantity,
986         bytes memory _data
987     ) internal {
988         _mint(to, quantity);
989 
990         unchecked {
991             if (to.code.length != 0) {
992                 uint256 end = _currentIndex;
993                 uint256 index = end - quantity;
994                 do {
995                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
996                         revert TransferToNonERC721ReceiverImplementer();
997                     }
998                 } while (index < end);
999                 // Reentrancy protection.
1000                 if (_currentIndex != end) revert();
1001             }
1002         }
1003     }
1004 
1005     /**
1006      * @dev Mints `quantity` tokens and transfers them to `to`.
1007      *
1008      * Requirements:
1009      *
1010      * - `to` cannot be the zero address.
1011      * - `quantity` must be greater than 0.
1012      *
1013      * Emits a {Transfer} event for each mint.
1014      */
1015     function _mint(address to, uint256 quantity) internal {
1016         uint256 startTokenId = _currentIndex;
1017         if (to == address(0)) revert MintToZeroAddress();
1018         if (quantity == 0) revert MintZeroQuantity();
1019 
1020         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1021 
1022         // Overflows are incredibly unrealistic.
1023         // `balance` and `numberMinted` have a maximum limit of 2**64.
1024         // `tokenId` has a maximum limit of 2**256.
1025         unchecked {
1026             // Updates:
1027             // - `balance += quantity`.
1028             // - `numberMinted += quantity`.
1029             //
1030             // We can directly add to the `balance` and `numberMinted`.
1031             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1032 
1033             // Updates:
1034             // - `address` to the owner.
1035             // - `startTimestamp` to the timestamp of minting.
1036             // - `burned` to `false`.
1037             // - `nextInitialized` to `quantity == 1`.
1038             _packedOwnerships[startTokenId] = _packOwnershipData(
1039                 to,
1040                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1041             );
1042 
1043             uint256 tokenId = startTokenId;
1044             uint256 end = startTokenId + quantity;
1045             do {
1046                 emit Transfer(address(0), to, tokenId++);
1047             } while (tokenId < end);
1048 
1049             _currentIndex = end;
1050         }
1051         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1052     }
1053 
1054     /**
1055      * @dev Mints `quantity` tokens and transfers them to `to`.
1056      *
1057      * This function is intended for efficient minting only during contract creation.
1058      *
1059      * It emits only one {ConsecutiveTransfer} as defined in
1060      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1061      * instead of a sequence of {Transfer} event(s).
1062      *
1063      * Calling this function outside of contract creation WILL make your contract
1064      * non-compliant with the ERC721 standard.
1065      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1066      * {ConsecutiveTransfer} event is only permissible during contract creation.
1067      *
1068      * Requirements:
1069      *
1070      * - `to` cannot be the zero address.
1071      * - `quantity` must be greater than 0.
1072      *
1073      * Emits a {ConsecutiveTransfer} event.
1074      */
1075     function _mintERC2309(address to, uint256 quantity) internal {
1076         uint256 startTokenId = _currentIndex;
1077         if (to == address(0)) revert MintToZeroAddress();
1078         if (quantity == 0) revert MintZeroQuantity();
1079         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1080 
1081         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1082 
1083         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1084         unchecked {
1085             // Updates:
1086             // - `balance += quantity`.
1087             // - `numberMinted += quantity`.
1088             //
1089             // We can directly add to the `balance` and `numberMinted`.
1090             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1091 
1092             // Updates:
1093             // - `address` to the owner.
1094             // - `startTimestamp` to the timestamp of minting.
1095             // - `burned` to `false`.
1096             // - `nextInitialized` to `quantity == 1`.
1097             _packedOwnerships[startTokenId] = _packOwnershipData(
1098                 to,
1099                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1100             );
1101 
1102             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1103 
1104             _currentIndex = startTokenId + quantity;
1105         }
1106         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1107     }
1108 
1109     /**
1110      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1111      */
1112     function _getApprovedAddress(uint256 tokenId)
1113         private
1114         view
1115         returns (uint256 approvedAddressSlot, address approvedAddress)
1116     {
1117         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1118         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1119         assembly {
1120             // Compute the slot.
1121             mstore(0x00, tokenId)
1122             mstore(0x20, tokenApprovalsPtr.slot)
1123             approvedAddressSlot := keccak256(0x00, 0x40)
1124             // Load the slot's value from storage.
1125             approvedAddress := sload(approvedAddressSlot)
1126         }
1127     }
1128 
1129     /**
1130      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1131      */
1132     function _isOwnerOrApproved(
1133         address approvedAddress,
1134         address from,
1135         address msgSender
1136     ) private pure returns (bool result) {
1137         assembly {
1138             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1139             from := and(from, BITMASK_ADDRESS)
1140             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1141             msgSender := and(msgSender, BITMASK_ADDRESS)
1142             // `msgSender == from || msgSender == approvedAddress`.
1143             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1144         }
1145     }
1146 
1147     /**
1148      * @dev Transfers `tokenId` from `from` to `to`.
1149      *
1150      * Requirements:
1151      *
1152      * - `to` cannot be the zero address.
1153      * - `tokenId` token must be owned by `from`.
1154      *
1155      * Emits a {Transfer} event.
1156      */
1157     function transferFrom(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) public virtual override {
1162         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1163 
1164         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1165 
1166         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1167 
1168         // The nested ifs save around 20+ gas over a compound boolean condition.
1169         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1170             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1171 
1172         if (to == address(0)) revert TransferToZeroAddress();
1173 
1174         _beforeTokenTransfers(from, to, tokenId, 1);
1175 
1176         // Clear approvals from the previous owner.
1177         assembly {
1178             if approvedAddress {
1179                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1180                 sstore(approvedAddressSlot, 0)
1181             }
1182         }
1183 
1184         // Underflow of the sender's balance is impossible because we check for
1185         // ownership above and the recipient's balance can't realistically overflow.
1186         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1187         unchecked {
1188             // We can directly increment and decrement the balances.
1189             --_packedAddressData[from]; // Updates: `balance -= 1`.
1190             ++_packedAddressData[to]; // Updates: `balance += 1`.
1191 
1192             // Updates:
1193             // - `address` to the next owner.
1194             // - `startTimestamp` to the timestamp of transfering.
1195             // - `burned` to `false`.
1196             // - `nextInitialized` to `true`.
1197             _packedOwnerships[tokenId] = _packOwnershipData(
1198                 to,
1199                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1200             );
1201 
1202             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1203             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1204                 uint256 nextTokenId = tokenId + 1;
1205                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1206                 if (_packedOwnerships[nextTokenId] == 0) {
1207                     // If the next slot is within bounds.
1208                     if (nextTokenId != _currentIndex) {
1209                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1210                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1211                     }
1212                 }
1213             }
1214         }
1215 
1216         emit Transfer(from, to, tokenId);
1217         _afterTokenTransfers(from, to, tokenId, 1);
1218     }
1219 
1220     /**
1221      * @dev Equivalent to `_burn(tokenId, false)`.
1222      */
1223     function _burn(uint256 tokenId) internal virtual {
1224         _burn(tokenId, false);
1225     }
1226 
1227     /**
1228      * @dev Destroys `tokenId`.
1229      * The approval is cleared when the token is burned.
1230      *
1231      * Requirements:
1232      *
1233      * - `tokenId` must exist.
1234      *
1235      * Emits a {Transfer} event.
1236      */
1237     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1238         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1239 
1240         address from = address(uint160(prevOwnershipPacked));
1241 
1242         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1243 
1244         if (approvalCheck) {
1245             // The nested ifs save around 20+ gas over a compound boolean condition.
1246             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1247                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1248         }
1249 
1250         _beforeTokenTransfers(from, address(0), tokenId, 1);
1251 
1252         // Clear approvals from the previous owner.
1253         assembly {
1254             if approvedAddress {
1255                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1256                 sstore(approvedAddressSlot, 0)
1257             }
1258         }
1259 
1260         // Underflow of the sender's balance is impossible because we check for
1261         // ownership above and the recipient's balance can't realistically overflow.
1262         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1263         unchecked {
1264             // Updates:
1265             // - `balance -= 1`.
1266             // - `numberBurned += 1`.
1267             //
1268             // We can directly decrement the balance, and increment the number burned.
1269             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1270             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1271 
1272             // Updates:
1273             // - `address` to the last owner.
1274             // - `startTimestamp` to the timestamp of burning.
1275             // - `burned` to `true`.
1276             // - `nextInitialized` to `true`.
1277             _packedOwnerships[tokenId] = _packOwnershipData(
1278                 from,
1279                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1280             );
1281 
1282             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1283             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1284                 uint256 nextTokenId = tokenId + 1;
1285                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1286                 if (_packedOwnerships[nextTokenId] == 0) {
1287                     // If the next slot is within bounds.
1288                     if (nextTokenId != _currentIndex) {
1289                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1290                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1291                     }
1292                 }
1293             }
1294         }
1295 
1296         emit Transfer(from, address(0), tokenId);
1297         _afterTokenTransfers(from, address(0), tokenId, 1);
1298 
1299         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1300         unchecked {
1301             _burnCounter++;
1302         }
1303     }
1304 
1305     /**
1306      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1307      *
1308      * @param from address representing the previous owner of the given token ID
1309      * @param to target address that will receive the tokens
1310      * @param tokenId uint256 ID of the token to be transferred
1311      * @param _data bytes optional data to send along with the call
1312      * @return bool whether the call correctly returned the expected magic value
1313      */
1314     function _checkContractOnERC721Received(
1315         address from,
1316         address to,
1317         uint256 tokenId,
1318         bytes memory _data
1319     ) private returns (bool) {
1320         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1321             bytes4 retval
1322         ) {
1323             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1324         } catch (bytes memory reason) {
1325             if (reason.length == 0) {
1326                 revert TransferToNonERC721ReceiverImplementer();
1327             } else {
1328                 assembly {
1329                     revert(add(32, reason), mload(reason))
1330                 }
1331             }
1332         }
1333     }
1334 
1335     /**
1336      * @dev Directly sets the extra data for the ownership data `index`.
1337      */
1338     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1339         uint256 packed = _packedOwnerships[index];
1340         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1341         uint256 extraDataCasted;
1342         // Cast `extraData` with assembly to avoid redundant masking.
1343         assembly {
1344             extraDataCasted := extraData
1345         }
1346         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1347         _packedOwnerships[index] = packed;
1348     }
1349 
1350     /**
1351      * @dev Returns the next extra data for the packed ownership data.
1352      * The returned result is shifted into position.
1353      */
1354     function _nextExtraData(
1355         address from,
1356         address to,
1357         uint256 prevOwnershipPacked
1358     ) private view returns (uint256) {
1359         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1360         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1361     }
1362 
1363     /**
1364      * @dev Called during each token transfer to set the 24bit `extraData` field.
1365      * Intended to be overridden by the cosumer contract.
1366      *
1367      * `previousExtraData` - the value of `extraData` before transfer.
1368      *
1369      * Calling conditions:
1370      *
1371      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1372      * transferred to `to`.
1373      * - When `from` is zero, `tokenId` will be minted for `to`.
1374      * - When `to` is zero, `tokenId` will be burned by `from`.
1375      * - `from` and `to` are never both zero.
1376      */
1377     function _extraData(
1378         address from,
1379         address to,
1380         uint24 previousExtraData
1381     ) internal view virtual returns (uint24) {}
1382 
1383     /**
1384      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1385      * This includes minting.
1386      * And also called before burning one token.
1387      *
1388      * startTokenId - the first token id to be transferred
1389      * quantity - the amount to be transferred
1390      *
1391      * Calling conditions:
1392      *
1393      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1394      * transferred to `to`.
1395      * - When `from` is zero, `tokenId` will be minted for `to`.
1396      * - When `to` is zero, `tokenId` will be burned by `from`.
1397      * - `from` and `to` are never both zero.
1398      */
1399     function _beforeTokenTransfers(
1400         address from,
1401         address to,
1402         uint256 startTokenId,
1403         uint256 quantity
1404     ) internal virtual {}
1405 
1406     /**
1407      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1408      * This includes minting.
1409      * And also called after one token has been burned.
1410      *
1411      * startTokenId - the first token id to be transferred
1412      * quantity - the amount to be transferred
1413      *
1414      * Calling conditions:
1415      *
1416      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1417      * transferred to `to`.
1418      * - When `from` is zero, `tokenId` has been minted for `to`.
1419      * - When `to` is zero, `tokenId` has been burned by `from`.
1420      * - `from` and `to` are never both zero.
1421      */
1422     function _afterTokenTransfers(
1423         address from,
1424         address to,
1425         uint256 startTokenId,
1426         uint256 quantity
1427     ) internal virtual {}
1428 
1429     /**
1430      * @dev Returns the message sender (defaults to `msg.sender`).
1431      *
1432      * If you are writing GSN compatible contracts, you need to override this function.
1433      */
1434     function _msgSenderERC721A() internal view virtual returns (address) {
1435         return msg.sender;
1436     }
1437 
1438     /**
1439      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1440      */
1441     function _toString(uint256 value) internal pure returns (string memory ptr) {
1442         assembly {
1443             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1444             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1445             // We will need 1 32-byte word to store the length,
1446             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1447             ptr := add(mload(0x40), 128)
1448             // Update the free memory pointer to allocate.
1449             mstore(0x40, ptr)
1450 
1451             // Cache the end of the memory to calculate the length later.
1452             let end := ptr
1453 
1454             // We write the string from the rightmost digit to the leftmost digit.
1455             // The following is essentially a do-while loop that also handles the zero case.
1456             // Costs a bit more than early returning for the zero case,
1457             // but cheaper in terms of deployment and overall runtime costs.
1458             for {
1459                 // Initialize and perform the first pass without check.
1460                 let temp := value
1461                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1462                 ptr := sub(ptr, 1)
1463                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1464                 mstore8(ptr, add(48, mod(temp, 10)))
1465                 temp := div(temp, 10)
1466             } temp {
1467                 // Keep dividing `temp` until zero.
1468                 temp := div(temp, 10)
1469             } {
1470                 // Body of the for loop.
1471                 ptr := sub(ptr, 1)
1472                 mstore8(ptr, add(48, mod(temp, 10)))
1473             }
1474 
1475             let length := sub(end, ptr)
1476             // Move the pointer 32 bytes leftwards to make room for the length.
1477             ptr := sub(ptr, 32)
1478             // Store the length.
1479             mstore(ptr, length)
1480         }
1481     }
1482 }
1483 
1484 // File: contracts/Renowned.sol
1485 
1486 
1487 
1488 pragma solidity ^0.8.0;
1489 
1490 
1491 
1492 
1493 
1494 contract AuraclesNFT is ERC721A, Ownable {
1495 
1496     using Strings for uint256;
1497     address public contractOwner;
1498 
1499     bool public paused = false;
1500 
1501     uint256 public mintPrice = 0.09 ether;
1502     uint256 public preMintPrice = 0.075 ether;
1503 
1504     uint256 public presaleMaxNFTPerWallet = 2;
1505     uint256 public publicSaleMaxNFTPerWallet = 5;
1506 
1507     uint256 constant public supply = 5555;
1508     uint256 constant public teamSupply = 222;
1509 
1510     bool teamMinted;
1511 
1512     bool public isRevealed;
1513     bool public isPublicSale;
1514 
1515     string private unRevealedURI = "ipfs://QmRJAL1HkkuZGFtoarvWo2CtjezNQ9LPJBpsfz7gpyyrdN/1.json";
1516 
1517     string private baseURI = "ipfs://QmShX3HGtHwX4LWfrZoogLFw4yofakfpecDr5e1bbMRNWd/";
1518 
1519     address public teamWallet = 0x402CcA4ed7d737d901A831849106d142C98FD68f;
1520 
1521     bytes32 public merkleRoot;
1522 
1523     constructor() ERC721A ("Auracles NFT", "AURC") {
1524 
1525         contractOwner = msg.sender;
1526         merkleRoot = 0x696250f4e2ce4e558cd6878a366ed4e12500ffaf404322ee10389baaa2cdf822;
1527     }
1528 
1529     function reveal() public onlyOwner { isRevealed = true; }
1530 
1531     function toggleReveal() external onlyOwner{
1532 
1533         isRevealed = !isRevealed;
1534     }
1535 
1536     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1537 
1538         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1539 
1540         if(!isRevealed) {
1541 
1542             return unRevealedURI;
1543         }
1544 
1545         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1546     }
1547 
1548     function teamMint() onlyOwner external {
1549 
1550         require(totalSupply() + teamSupply <= supply, "You can't mint more then the total supply");
1551         require(!teamMinted, "Team has already minted");
1552 
1553         teamMinted = true;
1554 
1555         _safeMint(teamWallet, teamSupply);
1556     }
1557 
1558     function preMint(uint256 quantity, bytes32[] memory proof) external payable {
1559 
1560         require(totalSupply() + quantity <= supply, "You can't mint more then the total supply");
1561         require(!isPublicSale, "You cannot mint after presale");
1562         require(tx.origin == msg.sender, "Caller should not be a contract");
1563 
1564         if(msg.sender != owner()) {
1565 
1566             require(!paused, "Contract paused");
1567 
1568             require(isValid(proof, keccak256(abi.encodePacked(msg.sender))), "You are not on the frenlist for this mint");
1569             require(quantity + balanceOf(msg.sender) <= presaleMaxNFTPerWallet, string(abi.encodePacked("You can only mint ", presaleMaxNFTPerWallet.toString(), " NFTs at Presale")));
1570 
1571             require(msg.value >= preMintPrice * quantity, "Insufficient funds");
1572         }
1573         
1574         _safeMint(msg.sender, quantity);
1575     }
1576 
1577     function mint(uint256 quantity) external payable {
1578 
1579         require(totalSupply() + quantity <= supply, "You can't mint more then the total supply");
1580         require(isPublicSale, "You cannot mint until public sale has started");
1581         require(tx.origin == msg.sender, "Caller should not be a contract");
1582 
1583         if(msg.sender != owner()) {
1584 
1585             require(!paused, "Contract paused");
1586 
1587             require(quantity + balanceOf(msg.sender) <= publicSaleMaxNFTPerWallet, string(abi.encodePacked("You can only mint ", publicSaleMaxNFTPerWallet.toString(), " NFTs at Public Sale")));
1588             require(msg.value >= mintPrice * quantity, "Insufficient funds");
1589         }
1590         
1591         _safeMint(msg.sender, quantity);
1592     }
1593 
1594     function getBaseURI() public onlyOwner view returns (string memory) { return baseURI; }
1595 
1596     function getMintPrice() public view returns (uint256) {
1597 
1598         if(!isPublicSale) {
1599 
1600             return preMintPrice;
1601         }
1602 
1603         return mintPrice;
1604     }
1605 
1606     function setNotRevealedUrl(string memory unRevealedURI_) external onlyOwner { unRevealedURI = unRevealedURI_; }
1607 
1608     function _baseURI() internal view override returns (string memory) { return baseURI; }
1609 
1610     function setBaseURI(string memory baseURI_) external onlyOwner { baseURI = baseURI_; }
1611 
1612     function setMintPrice (uint256 _newPrice) external onlyOwner { mintPrice = _newPrice; }
1613 
1614     function setPublicMint() external onlyOwner { isPublicSale = true; }
1615 
1616     function setPaused (bool _pausedState) external onlyOwner { paused = _pausedState; }
1617 
1618     function setPublicSaleMaxNFTPerWallet(uint256 max_) external onlyOwner { publicSaleMaxNFTPerWallet = max_; }
1619 
1620     function getNotRevealedURL() external onlyOwner view returns (string memory) { return unRevealedURI; }
1621 
1622     function changeTreasury(address payable _newWallet) external onlyOwner { contractOwner = _newWallet; }
1623 
1624     function setTeamWallet(address teamWallet_) external onlyOwner { teamWallet = teamWallet_; }
1625 
1626     function numberMinted(address owner) public view returns (uint256) { return _numberMinted(owner); }
1627 
1628     function totalMinted() public view returns (uint256) { return _totalMinted(); }
1629 
1630     function exists(uint256 tokenId) public view returns (bool) { return _exists(tokenId); }
1631 
1632     function setMerkleProof(bytes32 _merkleRoot) external onlyOwner { merkleRoot = _merkleRoot; }
1633 
1634     function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) { return MerkleProof.verify(proof, merkleRoot, leaf); }
1635 
1636     function withdraw() public payable onlyOwner {
1637         (bool os, ) = payable(contractOwner).call{value: address(this).balance}("");
1638         require(os);
1639     }
1640 }