1 /*
2 
3 ██████╗  █████╗ ██████╗  ██████╗     ██████╗ ███████╗███╗   ██╗███████╗███████╗██╗███████╗
4 ██╔══██╗██╔══██╗██╔══██╗██╔════╝    ██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔════╝██║██╔════╝
5 ██████╔╝███████║██████╔╝██║         ██║  ███╗█████╗  ██╔██╗ ██║█████╗  ███████╗██║███████╗
6 ██╔═══╝ ██╔══██║██╔═══╝ ██║         ██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ╚════██║██║╚════██║
7 ██║     ██║  ██║██║     ╚██████╗    ╚██████╔╝███████╗██║ ╚████║███████╗███████║██║███████║
8 ╚═╝     ╚═╝  ╚═╝╚═╝      ╚═════╝     ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝╚══════╝
9 
10 Website: https://papc.io/
11 Twitter: https://twitter.com/PUNKxAPE
12 Discord: https://discord.gg/punkapepixelclub
13 OpenSea: https://opensea.io/collection/papc-genesis
14 
15 Contract by: KryptoKeaton
16 
17 */
18 
19 // SPDX-License-Identifier: MIT
20 // File: @openzeppelin/contracts/utils/Strings.sol
21 
22 
23 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev String operations.
29  */
30 library Strings {
31     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
32 
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
35      */
36     function toString(uint256 value) internal pure returns (string memory) {
37         // Inspired by OraclizeAPI's implementation - MIT licence
38         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
39 
40         if (value == 0) {
41             return "0";
42         }
43         uint256 temp = value;
44         uint256 digits;
45         while (temp != 0) {
46             digits++;
47             temp /= 10;
48         }
49         bytes memory buffer = new bytes(digits);
50         while (value != 0) {
51             digits -= 1;
52             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
53             value /= 10;
54         }
55         return string(buffer);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
60      */
61     function toHexString(uint256 value) internal pure returns (string memory) {
62         if (value == 0) {
63             return "0x00";
64         }
65         uint256 temp = value;
66         uint256 length = 0;
67         while (temp != 0) {
68             length++;
69             temp >>= 8;
70         }
71         return toHexString(value, length);
72     }
73 
74     /**
75      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
76      */
77     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
78         bytes memory buffer = new bytes(2 * length + 2);
79         buffer[0] = "0";
80         buffer[1] = "x";
81         for (uint256 i = 2 * length + 1; i > 1; --i) {
82             buffer[i] = _HEX_SYMBOLS[value & 0xf];
83             value >>= 4;
84         }
85         require(value == 0, "Strings: hex length insufficient");
86         return string(buffer);
87     }
88 }
89 
90 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
91 
92 
93 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Contract module that helps prevent reentrant calls to a function.
99  *
100  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
101  * available, which can be applied to functions to make sure there are no nested
102  * (reentrant) calls to them.
103  *
104  * Note that because there is a single `nonReentrant` guard, functions marked as
105  * `nonReentrant` may not call one another. This can be worked around by making
106  * those functions `private`, and then adding `external` `nonReentrant` entry
107  * points to them.
108  *
109  * TIP: If you would like to learn more about reentrancy and alternative ways
110  * to protect against it, check out our blog post
111  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
112  */
113 abstract contract ReentrancyGuard {
114     // Booleans are more expensive than uint256 or any type that takes up a full
115     // word because each write operation emits an extra SLOAD to first read the
116     // slot's contents, replace the bits taken up by the boolean, and then write
117     // back. This is the compiler's defense against contract upgrades and
118     // pointer aliasing, and it cannot be disabled.
119 
120     // The values being non-zero value makes deployment a bit more expensive,
121     // but in exchange the refund on every call to nonReentrant will be lower in
122     // amount. Since refunds are capped to a percentage of the total
123     // transaction's gas, it is best to keep them low in cases like this one, to
124     // increase the likelihood of the full refund coming into effect.
125     uint256 private constant _NOT_ENTERED = 1;
126     uint256 private constant _ENTERED = 2;
127 
128     uint256 private _status;
129 
130     constructor() {
131         _status = _NOT_ENTERED;
132     }
133 
134     /**
135      * @dev Prevents a contract from calling itself, directly or indirectly.
136      * Calling a `nonReentrant` function from another `nonReentrant`
137      * function is not supported. It is possible to prevent this from happening
138      * by making the `nonReentrant` function external, and making it call a
139      * `private` function that does the actual work.
140      */
141     modifier nonReentrant() {
142         // On the first call to nonReentrant, _notEntered will be true
143         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
144 
145         // Any calls to nonReentrant after this point will fail
146         _status = _ENTERED;
147 
148         _;
149 
150         // By storing the original value once again, a refund is triggered (see
151         // https://eips.ethereum.org/EIPS/eip-2200)
152         _status = _NOT_ENTERED;
153     }
154 }
155 
156 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
157 
158 
159 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
160 
161 pragma solidity ^0.8.0;
162 
163 /**
164  * @dev These functions deal with verification of Merkle Trees proofs.
165  *
166  * The proofs can be generated using the JavaScript library
167  * https://github.com/miguelmota/merkletreejs[merkletreejs].
168  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
169  *
170  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
171  *
172  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
173  * hashing, or use a hash function other than keccak256 for hashing leaves.
174  * This is because the concatenation of a sorted pair of internal nodes in
175  * the merkle tree could be reinterpreted as a leaf value.
176  */
177 library MerkleProof {
178     /**
179      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
180      * defined by `root`. For this, a `proof` must be provided, containing
181      * sibling hashes on the branch from the leaf to the root of the tree. Each
182      * pair of leaves and each pair of pre-images are assumed to be sorted.
183      */
184     function verify(
185         bytes32[] memory proof,
186         bytes32 root,
187         bytes32 leaf
188     ) internal pure returns (bool) {
189         return processProof(proof, leaf) == root;
190     }
191 
192     /**
193      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
194      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
195      * hash matches the root of the tree. When processing the proof, the pairs
196      * of leafs & pre-images are assumed to be sorted.
197      *
198      * _Available since v4.4._
199      */
200     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
201         bytes32 computedHash = leaf;
202         for (uint256 i = 0; i < proof.length; i++) {
203             bytes32 proofElement = proof[i];
204             if (computedHash <= proofElement) {
205                 // Hash(current computed hash + current element of the proof)
206                 computedHash = _efficientHash(computedHash, proofElement);
207             } else {
208                 // Hash(current element of the proof + current computed hash)
209                 computedHash = _efficientHash(proofElement, computedHash);
210             }
211         }
212         return computedHash;
213     }
214 
215     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
216         assembly {
217             mstore(0x00, a)
218             mstore(0x20, b)
219             value := keccak256(0x00, 0x40)
220         }
221     }
222 }
223 
224 // File: @openzeppelin/contracts/utils/Context.sol
225 
226 
227 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @dev Provides information about the current execution context, including the
233  * sender of the transaction and its data. While these are generally available
234  * via msg.sender and msg.data, they should not be accessed in such a direct
235  * manner, since when dealing with meta-transactions the account sending and
236  * paying for execution may not be the actual sender (as far as an application
237  * is concerned).
238  *
239  * This contract is only required for intermediate, library-like contracts.
240  */
241 abstract contract Context {
242     function _msgSender() internal view virtual returns (address) {
243         return msg.sender;
244     }
245 
246     function _msgData() internal view virtual returns (bytes calldata) {
247         return msg.data;
248     }
249 }
250 
251 // File: @openzeppelin/contracts/access/Ownable.sol
252 
253 
254 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 
259 /**
260  * @dev Contract module which provides a basic access control mechanism, where
261  * there is an account (an owner) that can be granted exclusive access to
262  * specific functions.
263  *
264  * By default, the owner account will be the one that deploys the contract. This
265  * can later be changed with {transferOwnership}.
266  *
267  * This module is used through inheritance. It will make available the modifier
268  * `onlyOwner`, which can be applied to your functions to restrict their use to
269  * the owner.
270  */
271 abstract contract Ownable is Context {
272     address private _owner;
273 
274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
275 
276     /**
277      * @dev Initializes the contract setting the deployer as the initial owner.
278      */
279     constructor() {
280         _transferOwnership(_msgSender());
281     }
282 
283     /**
284      * @dev Returns the address of the current owner.
285      */
286     function owner() public view virtual returns (address) {
287         return _owner;
288     }
289 
290     /**
291      * @dev Throws if called by any account other than the owner.
292      */
293     modifier onlyOwner() {
294         require(owner() == _msgSender(), "Ownable: caller is not the owner");
295         _;
296     }
297 
298     /**
299      * @dev Leaves the contract without owner. It will not be possible to call
300      * `onlyOwner` functions anymore. Can only be called by the current owner.
301      *
302      * NOTE: Renouncing ownership will leave the contract without an owner,
303      * thereby removing any functionality that is only available to the owner.
304      */
305     function renounceOwnership() public virtual onlyOwner {
306         _transferOwnership(address(0));
307     }
308 
309     /**
310      * @dev Transfers ownership of the contract to a new account (`newOwner`).
311      * Can only be called by the current owner.
312      */
313     function transferOwnership(address newOwner) public virtual onlyOwner {
314         require(newOwner != address(0), "Ownable: new owner is the zero address");
315         _transferOwnership(newOwner);
316     }
317 
318     /**
319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
320      * Internal function without access restriction.
321      */
322     function _transferOwnership(address newOwner) internal virtual {
323         address oldOwner = _owner;
324         _owner = newOwner;
325         emit OwnershipTransferred(oldOwner, newOwner);
326     }
327 }
328 
329 // File: erc721a/contracts/IERC721A.sol
330 
331 
332 // ERC721A Contracts v4.0.0
333 // Creator: Chiru Labs
334 
335 pragma solidity ^0.8.4;
336 
337 /**
338  * @dev Interface of an ERC721A compliant contract.
339  */
340 interface IERC721A {
341     /**
342      * The caller must own the token or be an approved operator.
343      */
344     error ApprovalCallerNotOwnerNorApproved();
345 
346     /**
347      * The token does not exist.
348      */
349     error ApprovalQueryForNonexistentToken();
350 
351     /**
352      * The caller cannot approve to their own address.
353      */
354     error ApproveToCaller();
355 
356     /**
357      * The caller cannot approve to the current owner.
358      */
359     error ApprovalToCurrentOwner();
360 
361     /**
362      * Cannot query the balance for the zero address.
363      */
364     error BalanceQueryForZeroAddress();
365 
366     /**
367      * Cannot mint to the zero address.
368      */
369     error MintToZeroAddress();
370 
371     /**
372      * The quantity of tokens minted must be more than zero.
373      */
374     error MintZeroQuantity();
375 
376     /**
377      * The token does not exist.
378      */
379     error OwnerQueryForNonexistentToken();
380 
381     /**
382      * The caller must own the token or be an approved operator.
383      */
384     error TransferCallerNotOwnerNorApproved();
385 
386     /**
387      * The token must be owned by `from`.
388      */
389     error TransferFromIncorrectOwner();
390 
391     /**
392      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
393      */
394     error TransferToNonERC721ReceiverImplementer();
395 
396     /**
397      * Cannot transfer to the zero address.
398      */
399     error TransferToZeroAddress();
400 
401     /**
402      * The token does not exist.
403      */
404     error URIQueryForNonexistentToken();
405 
406     struct TokenOwnership {
407         // The address of the owner.
408         address addr;
409         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
410         uint64 startTimestamp;
411         // Whether the token has been burned.
412         bool burned;
413     }
414 
415     /**
416      * @dev Returns the total amount of tokens stored by the contract.
417      *
418      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
419      */
420     function totalSupply() external view returns (uint256);
421 
422     // ==============================
423     //            IERC165
424     // ==============================
425 
426     /**
427      * @dev Returns true if this contract implements the interface defined by
428      * `interfaceId`. See the corresponding
429      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
430      * to learn more about how these ids are created.
431      *
432      * This function call must use less than 30 000 gas.
433      */
434     function supportsInterface(bytes4 interfaceId) external view returns (bool);
435 
436     // ==============================
437     //            IERC721
438     // ==============================
439 
440     /**
441      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
442      */
443     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
444 
445     /**
446      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
447      */
448     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
449 
450     /**
451      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
452      */
453     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
454 
455     /**
456      * @dev Returns the number of tokens in ``owner``'s account.
457      */
458     function balanceOf(address owner) external view returns (uint256 balance);
459 
460     /**
461      * @dev Returns the owner of the `tokenId` token.
462      *
463      * Requirements:
464      *
465      * - `tokenId` must exist.
466      */
467     function ownerOf(uint256 tokenId) external view returns (address owner);
468 
469     /**
470      * @dev Safely transfers `tokenId` token from `from` to `to`.
471      *
472      * Requirements:
473      *
474      * - `from` cannot be the zero address.
475      * - `to` cannot be the zero address.
476      * - `tokenId` token must exist and be owned by `from`.
477      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
478      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
479      *
480      * Emits a {Transfer} event.
481      */
482     function safeTransferFrom(
483         address from,
484         address to,
485         uint256 tokenId,
486         bytes calldata data
487     ) external;
488 
489     /**
490      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
491      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `tokenId` token must exist and be owned by `from`.
498      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
499      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
500      *
501      * Emits a {Transfer} event.
502      */
503     function safeTransferFrom(
504         address from,
505         address to,
506         uint256 tokenId
507     ) external;
508 
509     /**
510      * @dev Transfers `tokenId` token from `from` to `to`.
511      *
512      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
513      *
514      * Requirements:
515      *
516      * - `from` cannot be the zero address.
517      * - `to` cannot be the zero address.
518      * - `tokenId` token must be owned by `from`.
519      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
520      *
521      * Emits a {Transfer} event.
522      */
523     function transferFrom(
524         address from,
525         address to,
526         uint256 tokenId
527     ) external;
528 
529     /**
530      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
531      * The approval is cleared when the token is transferred.
532      *
533      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
534      *
535      * Requirements:
536      *
537      * - The caller must own the token or be an approved operator.
538      * - `tokenId` must exist.
539      *
540      * Emits an {Approval} event.
541      */
542     function approve(address to, uint256 tokenId) external;
543 
544     /**
545      * @dev Approve or remove `operator` as an operator for the caller.
546      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
547      *
548      * Requirements:
549      *
550      * - The `operator` cannot be the caller.
551      *
552      * Emits an {ApprovalForAll} event.
553      */
554     function setApprovalForAll(address operator, bool _approved) external;
555 
556     /**
557      * @dev Returns the account approved for `tokenId` token.
558      *
559      * Requirements:
560      *
561      * - `tokenId` must exist.
562      */
563     function getApproved(uint256 tokenId) external view returns (address operator);
564 
565     /**
566      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
567      *
568      * See {setApprovalForAll}
569      */
570     function isApprovedForAll(address owner, address operator) external view returns (bool);
571 
572     // ==============================
573     //        IERC721Metadata
574     // ==============================
575 
576     /**
577      * @dev Returns the token collection name.
578      */
579     function name() external view returns (string memory);
580 
581     /**
582      * @dev Returns the token collection symbol.
583      */
584     function symbol() external view returns (string memory);
585 
586     /**
587      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
588      */
589     function tokenURI(uint256 tokenId) external view returns (string memory);
590 }
591 
592 // File: erc721a/contracts/ERC721A.sol
593 
594 
595 // ERC721A Contracts v4.0.0
596 // Creator: Chiru Labs
597 
598 pragma solidity ^0.8.4;
599 
600 
601 /**
602  * @dev ERC721 token receiver interface.
603  */
604 interface ERC721A__IERC721Receiver {
605     function onERC721Received(
606         address operator,
607         address from,
608         uint256 tokenId,
609         bytes calldata data
610     ) external returns (bytes4);
611 }
612 
613 /**
614  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
615  * the Metadata extension. Built to optimize for lower gas during batch mints.
616  *
617  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
618  *
619  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
620  *
621  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
622  */
623 contract ERC721A is IERC721A {
624     // Mask of an entry in packed address data.
625     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
626 
627     // The bit position of `numberMinted` in packed address data.
628     uint256 private constant BITPOS_NUMBER_MINTED = 64;
629 
630     // The bit position of `numberBurned` in packed address data.
631     uint256 private constant BITPOS_NUMBER_BURNED = 128;
632 
633     // The bit position of `aux` in packed address data.
634     uint256 private constant BITPOS_AUX = 192;
635 
636     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
637     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
638 
639     // The bit position of `startTimestamp` in packed ownership.
640     uint256 private constant BITPOS_START_TIMESTAMP = 160;
641 
642     // The bit mask of the `burned` bit in packed ownership.
643     uint256 private constant BITMASK_BURNED = 1 << 224;
644     
645     // The bit position of the `nextInitialized` bit in packed ownership.
646     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
647 
648     // The bit mask of the `nextInitialized` bit in packed ownership.
649     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
650 
651     // The tokenId of the next token to be minted.
652     uint256 private _currentIndex;
653 
654     // The number of tokens burned.
655     uint256 private _burnCounter;
656 
657     // Token name
658     string private _name;
659 
660     // Token symbol
661     string private _symbol;
662 
663     // Mapping from token ID to ownership details
664     // An empty struct value does not necessarily mean the token is unowned.
665     // See `_packedOwnershipOf` implementation for details.
666     //
667     // Bits Layout:
668     // - [0..159]   `addr`
669     // - [160..223] `startTimestamp`
670     // - [224]      `burned`
671     // - [225]      `nextInitialized`
672     mapping(uint256 => uint256) private _packedOwnerships;
673 
674     // Mapping owner address to address data.
675     //
676     // Bits Layout:
677     // - [0..63]    `balance`
678     // - [64..127]  `numberMinted`
679     // - [128..191] `numberBurned`
680     // - [192..255] `aux`
681     mapping(address => uint256) private _packedAddressData;
682 
683     // Mapping from token ID to approved address.
684     mapping(uint256 => address) private _tokenApprovals;
685 
686     // Mapping from owner to operator approvals
687     mapping(address => mapping(address => bool)) private _operatorApprovals;
688 
689     constructor(string memory name_, string memory symbol_) {
690         _name = name_;
691         _symbol = symbol_;
692         _currentIndex = _startTokenId();
693     }
694 
695     /**
696      * @dev Returns the starting token ID. 
697      * To change the starting token ID, please override this function.
698      */
699     function _startTokenId() internal view virtual returns (uint256) {
700         return 0;
701     }
702 
703     /**
704      * @dev Returns the next token ID to be minted.
705      */
706     function _nextTokenId() internal view returns (uint256) {
707         return _currentIndex;
708     }
709 
710     /**
711      * @dev Returns the total number of tokens in existence.
712      * Burned tokens will reduce the count. 
713      * To get the total number of tokens minted, please see `_totalMinted`.
714      */
715     function totalSupply() public view override returns (uint256) {
716         // Counter underflow is impossible as _burnCounter cannot be incremented
717         // more than `_currentIndex - _startTokenId()` times.
718         unchecked {
719             return _currentIndex - _burnCounter - _startTokenId();
720         }
721     }
722 
723     /**
724      * @dev Returns the total amount of tokens minted in the contract.
725      */
726     function _totalMinted() internal view returns (uint256) {
727         // Counter underflow is impossible as _currentIndex does not decrement,
728         // and it is initialized to `_startTokenId()`
729         unchecked {
730             return _currentIndex - _startTokenId();
731         }
732     }
733 
734     /**
735      * @dev Returns the total number of tokens burned.
736      */
737     function _totalBurned() internal view returns (uint256) {
738         return _burnCounter;
739     }
740 
741     /**
742      * @dev See {IERC165-supportsInterface}.
743      */
744     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
745         // The interface IDs are constants representing the first 4 bytes of the XOR of
746         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
747         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
748         return
749             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
750             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
751             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
752     }
753 
754     /**
755      * @dev See {IERC721-balanceOf}.
756      */
757     function balanceOf(address owner) public view override returns (uint256) {
758         if (owner == address(0)) revert BalanceQueryForZeroAddress();
759         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
760     }
761 
762     /**
763      * Returns the number of tokens minted by `owner`.
764      */
765     function _numberMinted(address owner) internal view returns (uint256) {
766         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
767     }
768 
769     /**
770      * Returns the number of tokens burned by or on behalf of `owner`.
771      */
772     function _numberBurned(address owner) internal view returns (uint256) {
773         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
774     }
775 
776     /**
777      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
778      */
779     function _getAux(address owner) internal view returns (uint64) {
780         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
781     }
782 
783     /**
784      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
785      * If there are multiple variables, please pack them into a uint64.
786      */
787     function _setAux(address owner, uint64 aux) internal {
788         uint256 packed = _packedAddressData[owner];
789         uint256 auxCasted;
790         assembly { // Cast aux without masking.
791             auxCasted := aux
792         }
793         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
794         _packedAddressData[owner] = packed;
795     }
796 
797     /**
798      * Returns the packed ownership data of `tokenId`.
799      */
800     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
801         uint256 curr = tokenId;
802 
803         unchecked {
804             if (_startTokenId() <= curr)
805                 if (curr < _currentIndex) {
806                     uint256 packed = _packedOwnerships[curr];
807                     // If not burned.
808                     if (packed & BITMASK_BURNED == 0) {
809                         // Invariant:
810                         // There will always be an ownership that has an address and is not burned
811                         // before an ownership that does not have an address and is not burned.
812                         // Hence, curr will not underflow.
813                         //
814                         // We can directly compare the packed value.
815                         // If the address is zero, packed is zero.
816                         while (packed == 0) {
817                             packed = _packedOwnerships[--curr];
818                         }
819                         return packed;
820                     }
821                 }
822         }
823         revert OwnerQueryForNonexistentToken();
824     }
825 
826     /**
827      * Returns the unpacked `TokenOwnership` struct from `packed`.
828      */
829     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
830         ownership.addr = address(uint160(packed));
831         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
832         ownership.burned = packed & BITMASK_BURNED != 0;
833     }
834 
835     /**
836      * Returns the unpacked `TokenOwnership` struct at `index`.
837      */
838     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
839         return _unpackedOwnership(_packedOwnerships[index]);
840     }
841 
842     /**
843      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
844      */
845     function _initializeOwnershipAt(uint256 index) internal {
846         if (_packedOwnerships[index] == 0) {
847             _packedOwnerships[index] = _packedOwnershipOf(index);
848         }
849     }
850 
851     /**
852      * Gas spent here starts off proportional to the maximum mint batch size.
853      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
854      */
855     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
856         return _unpackedOwnership(_packedOwnershipOf(tokenId));
857     }
858 
859     /**
860      * @dev See {IERC721-ownerOf}.
861      */
862     function ownerOf(uint256 tokenId) public view override returns (address) {
863         return address(uint160(_packedOwnershipOf(tokenId)));
864     }
865 
866     /**
867      * @dev See {IERC721Metadata-name}.
868      */
869     function name() public view virtual override returns (string memory) {
870         return _name;
871     }
872 
873     /**
874      * @dev See {IERC721Metadata-symbol}.
875      */
876     function symbol() public view virtual override returns (string memory) {
877         return _symbol;
878     }
879 
880     /**
881      * @dev See {IERC721Metadata-tokenURI}.
882      */
883     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
884         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
885 
886         string memory baseURI = _baseURI();
887         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
888     }
889 
890     /**
891      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
892      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
893      * by default, can be overriden in child contracts.
894      */
895     function _baseURI() internal view virtual returns (string memory) {
896         return '';
897     }
898 
899     /**
900      * @dev Casts the address to uint256 without masking.
901      */
902     function _addressToUint256(address value) private pure returns (uint256 result) {
903         assembly {
904             result := value
905         }
906     }
907 
908     /**
909      * @dev Casts the boolean to uint256 without branching.
910      */
911     function _boolToUint256(bool value) private pure returns (uint256 result) {
912         assembly {
913             result := value
914         }
915     }
916 
917     /**
918      * @dev See {IERC721-approve}.
919      */
920     function approve(address to, uint256 tokenId) public override {
921         address owner = address(uint160(_packedOwnershipOf(tokenId)));
922         if (to == owner) revert ApprovalToCurrentOwner();
923 
924         if (_msgSenderERC721A() != owner)
925             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
926                 revert ApprovalCallerNotOwnerNorApproved();
927             }
928 
929         _tokenApprovals[tokenId] = to;
930         emit Approval(owner, to, tokenId);
931     }
932 
933     /**
934      * @dev See {IERC721-getApproved}.
935      */
936     function getApproved(uint256 tokenId) public view override returns (address) {
937         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
938 
939         return _tokenApprovals[tokenId];
940     }
941 
942     /**
943      * @dev See {IERC721-setApprovalForAll}.
944      */
945     function setApprovalForAll(address operator, bool approved) public virtual override {
946         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
947 
948         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
949         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
950     }
951 
952     /**
953      * @dev See {IERC721-isApprovedForAll}.
954      */
955     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
956         return _operatorApprovals[owner][operator];
957     }
958 
959     /**
960      * @dev See {IERC721-transferFrom}.
961      */
962     function transferFrom(
963         address from,
964         address to,
965         uint256 tokenId
966     ) public virtual override {
967         _transfer(from, to, tokenId);
968     }
969 
970     /**
971      * @dev See {IERC721-safeTransferFrom}.
972      */
973     function safeTransferFrom(
974         address from,
975         address to,
976         uint256 tokenId
977     ) public virtual override {
978         safeTransferFrom(from, to, tokenId, '');
979     }
980 
981     /**
982      * @dev See {IERC721-safeTransferFrom}.
983      */
984     function safeTransferFrom(
985         address from,
986         address to,
987         uint256 tokenId,
988         bytes memory _data
989     ) public virtual override {
990         _transfer(from, to, tokenId);
991         if (to.code.length != 0)
992             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
993                 revert TransferToNonERC721ReceiverImplementer();
994             }
995     }
996 
997     /**
998      * @dev Returns whether `tokenId` exists.
999      *
1000      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1001      *
1002      * Tokens start existing when they are minted (`_mint`),
1003      */
1004     function _exists(uint256 tokenId) internal view returns (bool) {
1005         return
1006             _startTokenId() <= tokenId &&
1007             tokenId < _currentIndex && // If within bounds,
1008             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1009     }
1010 
1011     /**
1012      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1013      */
1014     function _safeMint(address to, uint256 quantity) internal {
1015         _safeMint(to, quantity, '');
1016     }
1017 
1018     /**
1019      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1020      *
1021      * Requirements:
1022      *
1023      * - If `to` refers to a smart contract, it must implement
1024      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1025      * - `quantity` must be greater than 0.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _safeMint(
1030         address to,
1031         uint256 quantity,
1032         bytes memory _data
1033     ) internal {
1034         uint256 startTokenId = _currentIndex;
1035         if (to == address(0)) revert MintToZeroAddress();
1036         if (quantity == 0) revert MintZeroQuantity();
1037 
1038         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1039 
1040         // Overflows are incredibly unrealistic.
1041         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1042         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1043         unchecked {
1044             // Updates:
1045             // - `balance += quantity`.
1046             // - `numberMinted += quantity`.
1047             //
1048             // We can directly add to the balance and number minted.
1049             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1050 
1051             // Updates:
1052             // - `address` to the owner.
1053             // - `startTimestamp` to the timestamp of minting.
1054             // - `burned` to `false`.
1055             // - `nextInitialized` to `quantity == 1`.
1056             _packedOwnerships[startTokenId] =
1057                 _addressToUint256(to) |
1058                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1059                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1060 
1061             uint256 updatedIndex = startTokenId;
1062             uint256 end = updatedIndex + quantity;
1063 
1064             if (to.code.length != 0) {
1065                 do {
1066                     emit Transfer(address(0), to, updatedIndex);
1067                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1068                         revert TransferToNonERC721ReceiverImplementer();
1069                     }
1070                 } while (updatedIndex < end);
1071                 // Reentrancy protection
1072                 if (_currentIndex != startTokenId) revert();
1073             } else {
1074                 do {
1075                     emit Transfer(address(0), to, updatedIndex++);
1076                 } while (updatedIndex < end);
1077             }
1078             _currentIndex = updatedIndex;
1079         }
1080         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1081     }
1082 
1083     /**
1084      * @dev Mints `quantity` tokens and transfers them to `to`.
1085      *
1086      * Requirements:
1087      *
1088      * - `to` cannot be the zero address.
1089      * - `quantity` must be greater than 0.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _mint(address to, uint256 quantity) internal {
1094         uint256 startTokenId = _currentIndex;
1095         if (to == address(0)) revert MintToZeroAddress();
1096         if (quantity == 0) revert MintZeroQuantity();
1097 
1098         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1099 
1100         // Overflows are incredibly unrealistic.
1101         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1102         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1103         unchecked {
1104             // Updates:
1105             // - `balance += quantity`.
1106             // - `numberMinted += quantity`.
1107             //
1108             // We can directly add to the balance and number minted.
1109             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1110 
1111             // Updates:
1112             // - `address` to the owner.
1113             // - `startTimestamp` to the timestamp of minting.
1114             // - `burned` to `false`.
1115             // - `nextInitialized` to `quantity == 1`.
1116             _packedOwnerships[startTokenId] =
1117                 _addressToUint256(to) |
1118                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1119                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1120 
1121             uint256 updatedIndex = startTokenId;
1122             uint256 end = updatedIndex + quantity;
1123 
1124             do {
1125                 emit Transfer(address(0), to, updatedIndex++);
1126             } while (updatedIndex < end);
1127 
1128             _currentIndex = updatedIndex;
1129         }
1130         _afterTokenTransfers(address(0), to, startTokenId, quantity);
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
1143     function _transfer(
1144         address from,
1145         address to,
1146         uint256 tokenId
1147     ) private {
1148         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1149 
1150         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1151 
1152         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1153             isApprovedForAll(from, _msgSenderERC721A()) ||
1154             getApproved(tokenId) == _msgSenderERC721A());
1155 
1156         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1157         if (to == address(0)) revert TransferToZeroAddress();
1158 
1159         _beforeTokenTransfers(from, to, tokenId, 1);
1160 
1161         // Clear approvals from the previous owner.
1162         delete _tokenApprovals[tokenId];
1163 
1164         // Underflow of the sender's balance is impossible because we check for
1165         // ownership above and the recipient's balance can't realistically overflow.
1166         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1167         unchecked {
1168             // We can directly increment and decrement the balances.
1169             --_packedAddressData[from]; // Updates: `balance -= 1`.
1170             ++_packedAddressData[to]; // Updates: `balance += 1`.
1171 
1172             // Updates:
1173             // - `address` to the next owner.
1174             // - `startTimestamp` to the timestamp of transfering.
1175             // - `burned` to `false`.
1176             // - `nextInitialized` to `true`.
1177             _packedOwnerships[tokenId] =
1178                 _addressToUint256(to) |
1179                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1180                 BITMASK_NEXT_INITIALIZED;
1181 
1182             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1183             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1184                 uint256 nextTokenId = tokenId + 1;
1185                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1186                 if (_packedOwnerships[nextTokenId] == 0) {
1187                     // If the next slot is within bounds.
1188                     if (nextTokenId != _currentIndex) {
1189                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1190                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1191                     }
1192                 }
1193             }
1194         }
1195 
1196         emit Transfer(from, to, tokenId);
1197         _afterTokenTransfers(from, to, tokenId, 1);
1198     }
1199 
1200     /**
1201      * @dev Equivalent to `_burn(tokenId, false)`.
1202      */
1203     function _burn(uint256 tokenId) internal virtual {
1204         _burn(tokenId, false);
1205     }
1206 
1207     /**
1208      * @dev Destroys `tokenId`.
1209      * The approval is cleared when the token is burned.
1210      *
1211      * Requirements:
1212      *
1213      * - `tokenId` must exist.
1214      *
1215      * Emits a {Transfer} event.
1216      */
1217     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1218         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1219 
1220         address from = address(uint160(prevOwnershipPacked));
1221 
1222         if (approvalCheck) {
1223             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1224                 isApprovedForAll(from, _msgSenderERC721A()) ||
1225                 getApproved(tokenId) == _msgSenderERC721A());
1226 
1227             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1228         }
1229 
1230         _beforeTokenTransfers(from, address(0), tokenId, 1);
1231 
1232         // Clear approvals from the previous owner.
1233         delete _tokenApprovals[tokenId];
1234 
1235         // Underflow of the sender's balance is impossible because we check for
1236         // ownership above and the recipient's balance can't realistically overflow.
1237         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1238         unchecked {
1239             // Updates:
1240             // - `balance -= 1`.
1241             // - `numberBurned += 1`.
1242             //
1243             // We can directly decrement the balance, and increment the number burned.
1244             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1245             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1246 
1247             // Updates:
1248             // - `address` to the last owner.
1249             // - `startTimestamp` to the timestamp of burning.
1250             // - `burned` to `true`.
1251             // - `nextInitialized` to `true`.
1252             _packedOwnerships[tokenId] =
1253                 _addressToUint256(from) |
1254                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1255                 BITMASK_BURNED | 
1256                 BITMASK_NEXT_INITIALIZED;
1257 
1258             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1259             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1260                 uint256 nextTokenId = tokenId + 1;
1261                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1262                 if (_packedOwnerships[nextTokenId] == 0) {
1263                     // If the next slot is within bounds.
1264                     if (nextTokenId != _currentIndex) {
1265                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1266                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1267                     }
1268                 }
1269             }
1270         }
1271 
1272         emit Transfer(from, address(0), tokenId);
1273         _afterTokenTransfers(from, address(0), tokenId, 1);
1274 
1275         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1276         unchecked {
1277             _burnCounter++;
1278         }
1279     }
1280 
1281     /**
1282      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1283      *
1284      * @param from address representing the previous owner of the given token ID
1285      * @param to target address that will receive the tokens
1286      * @param tokenId uint256 ID of the token to be transferred
1287      * @param _data bytes optional data to send along with the call
1288      * @return bool whether the call correctly returned the expected magic value
1289      */
1290     function _checkContractOnERC721Received(
1291         address from,
1292         address to,
1293         uint256 tokenId,
1294         bytes memory _data
1295     ) private returns (bool) {
1296         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1297             bytes4 retval
1298         ) {
1299             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1300         } catch (bytes memory reason) {
1301             if (reason.length == 0) {
1302                 revert TransferToNonERC721ReceiverImplementer();
1303             } else {
1304                 assembly {
1305                     revert(add(32, reason), mload(reason))
1306                 }
1307             }
1308         }
1309     }
1310 
1311     /**
1312      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1313      * And also called before burning one token.
1314      *
1315      * startTokenId - the first token id to be transferred
1316      * quantity - the amount to be transferred
1317      *
1318      * Calling conditions:
1319      *
1320      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1321      * transferred to `to`.
1322      * - When `from` is zero, `tokenId` will be minted for `to`.
1323      * - When `to` is zero, `tokenId` will be burned by `from`.
1324      * - `from` and `to` are never both zero.
1325      */
1326     function _beforeTokenTransfers(
1327         address from,
1328         address to,
1329         uint256 startTokenId,
1330         uint256 quantity
1331     ) internal virtual {}
1332 
1333     /**
1334      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1335      * minting.
1336      * And also called after one token has been burned.
1337      *
1338      * startTokenId - the first token id to be transferred
1339      * quantity - the amount to be transferred
1340      *
1341      * Calling conditions:
1342      *
1343      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1344      * transferred to `to`.
1345      * - When `from` is zero, `tokenId` has been minted for `to`.
1346      * - When `to` is zero, `tokenId` has been burned by `from`.
1347      * - `from` and `to` are never both zero.
1348      */
1349     function _afterTokenTransfers(
1350         address from,
1351         address to,
1352         uint256 startTokenId,
1353         uint256 quantity
1354     ) internal virtual {}
1355 
1356     /**
1357      * @dev Returns the message sender (defaults to `msg.sender`).
1358      *
1359      * If you are writing GSN compatible contracts, you need to override this function.
1360      */
1361     function _msgSenderERC721A() internal view virtual returns (address) {
1362         return msg.sender;
1363     }
1364 
1365     /**
1366      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1367      */
1368     function _toString(uint256 value) internal pure returns (string memory ptr) {
1369         assembly {
1370             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1371             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1372             // We will need 1 32-byte word to store the length, 
1373             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1374             ptr := add(mload(0x40), 128)
1375             // Update the free memory pointer to allocate.
1376             mstore(0x40, ptr)
1377 
1378             // Cache the end of the memory to calculate the length later.
1379             let end := ptr
1380 
1381             // We write the string from the rightmost digit to the leftmost digit.
1382             // The following is essentially a do-while loop that also handles the zero case.
1383             // Costs a bit more than early returning for the zero case,
1384             // but cheaper in terms of deployment and overall runtime costs.
1385             for { 
1386                 // Initialize and perform the first pass without check.
1387                 let temp := value
1388                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1389                 ptr := sub(ptr, 1)
1390                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1391                 mstore8(ptr, add(48, mod(temp, 10)))
1392                 temp := div(temp, 10)
1393             } temp { 
1394                 // Keep dividing `temp` until zero.
1395                 temp := div(temp, 10)
1396             } { // Body of the for loop.
1397                 ptr := sub(ptr, 1)
1398                 mstore8(ptr, add(48, mod(temp, 10)))
1399             }
1400             
1401             let length := sub(end, ptr)
1402             // Move the pointer 32 bytes leftwards to make room for the length.
1403             ptr := sub(ptr, 32)
1404             // Store the length.
1405             mstore(ptr, length)
1406         }
1407     }
1408 }
1409 
1410 // File: contracts/papc-genesisnft.sol
1411 
1412 pragma solidity >=0.8.9 <0.9.0;
1413 
1414 contract PAPCGenesis is ERC721A, Ownable, ReentrancyGuard {
1415 
1416   using Strings for uint256;
1417 
1418   bytes32 public merkleRoot;
1419   mapping(address => bool) public whitelistClaimed;
1420 
1421   string public uriPrefix = 'https://ipfs.io/ipfs/QmfDBEiQtvdMCjr7dcSRa4njfmbspqPp8vuLPWKjjTST5N/';
1422   string public uriSuffix = '';
1423   string public hiddenMetadataUri;
1424   
1425   uint256 public cost;
1426   uint256 public maxSupply;
1427   uint256 public maxMintAmountPerTx;
1428 
1429   address addA = 0x9E6e24F5F2D378be6CF2581dceB1Baf3804fE227;
1430   address addB = 0xC2603Edd7C3A8C833D539CC32B08f142B80640dd;
1431   address addC = 0x4B2050cA9eD3a8f95272E4705ecE98A0d1067b60;
1432   address addD = 0xeffd3ac8EA0e9EBF3FDF4371109FA5CaEE2D4aB1;
1433   uint256 addAN = 70; //PAPC Team
1434   uint256 addBN = 15; //Dev Pay
1435   uint256 addCN = 5; //Consultant Pay
1436   uint256 addDN = 10; //PAPC Treasury
1437 
1438   bool public paused = true;
1439   bool public whitelistMintEnabled = false;
1440   bool public revealed = true;
1441 
1442   constructor() ERC721A("PAPC-Genesis", "PAPC-Genesis") {
1443     
1444     cost = 0.01 ether;
1445     maxSupply = 5000;
1446     maxMintAmountPerTx = 10;
1447     setHiddenMetadataUri('ipfs://__CID__/hidden.json');
1448   }
1449 
1450   modifier mintCompliance(uint256 _mintAmount) {
1451     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1452     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1453     _;
1454   }
1455 
1456   modifier mintPriceCompliance(uint256 _mintAmount) {
1457     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1458     _;
1459   }
1460 
1461   function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1462     // Verify whitelist requirements
1463     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
1464     require(!whitelistClaimed[_msgSender()], 'Address already claimed!');
1465     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1466     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
1467 
1468     whitelistClaimed[_msgSender()] = true;
1469     _safeMint(_msgSender(), _mintAmount);
1470   }
1471 
1472   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1473     require(!paused, 'The contract is paused!');
1474 
1475     _safeMint(_msgSender(), _mintAmount);
1476   }
1477   
1478   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1479     _safeMint(_receiver, _mintAmount);
1480   }
1481 
1482   function walletOfOwner(address _owner)
1483     public
1484     view
1485     returns (uint256[] memory)
1486   {
1487     uint256 ownerTokenCount = balanceOf(_owner);
1488     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1489     uint256 currentTokenId = _startTokenId();
1490     uint256 ownedTokenIndex = 0;
1491 
1492     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1493       address currentTokenOwner = ownerOf(currentTokenId);
1494 
1495       if (currentTokenOwner == _owner) {
1496         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1497 
1498         ownedTokenIndex++;
1499       }
1500 
1501       currentTokenId++;
1502     }
1503 
1504     return ownedTokenIds;
1505   }
1506 
1507   function _startTokenId() internal view virtual override returns (uint256) {
1508     return 0;
1509   }
1510 
1511   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1512     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1513 
1514     if (revealed == false) {
1515       return hiddenMetadataUri;
1516     }
1517 
1518     string memory currentBaseURI = _baseURI();
1519     return bytes(currentBaseURI).length > 0
1520         ? string(abi.encodePacked(currentBaseURI, (_tokenId + 556).toString()))
1521         : '';
1522   }
1523 
1524   function setRevealed(bool _state) public onlyOwner {
1525     revealed = _state;
1526   }
1527 
1528   function setCost(uint256 _cost) public onlyOwner {
1529     cost = _cost;
1530   }
1531 
1532   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1533     maxMintAmountPerTx = _maxMintAmountPerTx;
1534   }
1535 
1536   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1537     hiddenMetadataUri = _hiddenMetadataUri;
1538   }
1539 
1540   function setPaused(bool _state) public onlyOwner {
1541     paused = _state;
1542   }
1543 
1544   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1545     merkleRoot = _merkleRoot;
1546   }
1547 
1548   function setWhitelistMintEnabled(bool _state) public onlyOwner {
1549     whitelistMintEnabled = _state;
1550   }
1551 
1552   function withdraw() public onlyOwner nonReentrant {        
1553       uint256 contractBalance = address(this).balance;
1554       uint256  addANp = (contractBalance * addAN) / 100;
1555       uint256  addBNp = (contractBalance * addBN) / 100;
1556       uint256  addCNp = (contractBalance * addCN) / 100;
1557       uint256  addDNp = (contractBalance * addDN) / 100;
1558 
1559       (bool hs, ) = payable(addA).call{value: addANp}("");
1560       (hs, ) = payable(addB).call{value: addBNp}("");
1561       (hs, ) = payable(addC).call{value: addCNp}("");
1562       (hs, ) = payable(addD).call{value: addDNp}("");
1563     require(hs);
1564   }
1565 
1566     function _baseURI() internal view virtual override returns (string memory) {
1567     return uriPrefix;
1568   }
1569 
1570 }