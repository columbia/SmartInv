1 // SPDX-License-Identifier: MIT
2 
3 /**
4      __  __    __   _  _   __      __  __    __    ___  _  _  ___ 
5     (  \/  )  /__\ ( \/ ) /__\    (  \/  )  /__\  / __)( )/ )/ __)
6      )    (  /(__)\ \  / /(__)\    )    (  /(__)\ \__ \ )  ( \__ \
7     (_/\/\_)(__)(__)(__)(__)(__)  (_/\/\_)(__)(__)(___/(_)\_)(___/
8 
9 **/
10 // File: @openzeppelin/contracts/utils/Strings.sol
11 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev String operations.
17  */
18 library Strings {
19     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
20 
21     /**
22      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
23      */
24     function toString(uint256 value) internal pure returns (string memory) {
25         // Inspired by OraclizeAPI's implementation - MIT licence
26         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
27 
28         if (value == 0) {
29             return "0";
30         }
31         uint256 temp = value;
32         uint256 digits;
33         while (temp != 0) {
34             digits++;
35             temp /= 10;
36         }
37         bytes memory buffer = new bytes(digits);
38         while (value != 0) {
39             digits -= 1;
40             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
41             value /= 10;
42         }
43         return string(buffer);
44     }
45 
46     /**
47      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
48      */
49     function toHexString(uint256 value) internal pure returns (string memory) {
50         if (value == 0) {
51             return "0x00";
52         }
53         uint256 temp = value;
54         uint256 length = 0;
55         while (temp != 0) {
56             length++;
57             temp >>= 8;
58         }
59         return toHexString(value, length);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
64      */
65     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
66         bytes memory buffer = new bytes(2 * length + 2);
67         buffer[0] = "0";
68         buffer[1] = "x";
69         for (uint256 i = 2 * length + 1; i > 1; --i) {
70             buffer[i] = _HEX_SYMBOLS[value & 0xf];
71             value >>= 4;
72         }
73         require(value == 0, "Strings: hex length insufficient");
74         return string(buffer);
75     }
76 }
77 
78 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
79 
80 
81 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
82 
83 pragma solidity ^0.8.0;
84 
85 /**
86  * @dev Contract module that helps prevent reentrant calls to a function.
87  *
88  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
89  * available, which can be applied to functions to make sure there are no nested
90  * (reentrant) calls to them.
91  *
92  * Note that because there is a single `nonReentrant` guard, functions marked as
93  * `nonReentrant` may not call one another. This can be worked around by making
94  * those functions `private`, and then adding `external` `nonReentrant` entry
95  * points to them.
96  *
97  * TIP: If you would like to learn more about reentrancy and alternative ways
98  * to protect against it, check out our blog post
99  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
100  */
101 abstract contract ReentrancyGuard {
102     // Booleans are more expensive than uint256 or any type that takes up a full
103     // word because each write operation emits an extra SLOAD to first read the
104     // slot's contents, replace the bits taken up by the boolean, and then write
105     // back. This is the compiler's defense against contract upgrades and
106     // pointer aliasing, and it cannot be disabled.
107 
108     // The values being non-zero value makes deployment a bit more expensive,
109     // but in exchange the refund on every call to nonReentrant will be lower in
110     // amount. Since refunds are capped to a percentage of the total
111     // transaction's gas, it is best to keep them low in cases like this one, to
112     // increase the likelihood of the full refund coming into effect.
113     uint256 private constant _NOT_ENTERED = 1;
114     uint256 private constant _ENTERED = 2;
115 
116     uint256 private _status;
117 
118     constructor() {
119         _status = _NOT_ENTERED;
120     }
121 
122     /**
123      * @dev Prevents a contract from calling itself, directly or indirectly.
124      * Calling a `nonReentrant` function from another `nonReentrant`
125      * function is not supported. It is possible to prevent this from happening
126      * by making the `nonReentrant` function external, and making it call a
127      * `private` function that does the actual work.
128      */
129     modifier nonReentrant() {
130         // On the first call to nonReentrant, _notEntered will be true
131         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
132 
133         // Any calls to nonReentrant after this point will fail
134         _status = _ENTERED;
135 
136         _;
137 
138         // By storing the original value once again, a refund is triggered (see
139         // https://eips.ethereum.org/EIPS/eip-2200)
140         _status = _NOT_ENTERED;
141     }
142 }
143 
144 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
145 
146 
147 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 /**
152  * @dev These functions deal with verification of Merkle Trees proofs.
153  *
154  * The proofs can be generated using the JavaScript library
155  * https://github.com/miguelmota/merkletreejs[merkletreejs].
156  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
157  *
158  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
159  *
160  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
161  * hashing, or use a hash function other than keccak256 for hashing leaves.
162  * This is because the concatenation of a sorted pair of internal nodes in
163  * the merkle tree could be reinterpreted as a leaf value.
164  */
165 library MerkleProof {
166     /**
167      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
168      * defined by `root`. For this, a `proof` must be provided, containing
169      * sibling hashes on the branch from the leaf to the root of the tree. Each
170      * pair of leaves and each pair of pre-images are assumed to be sorted.
171      */
172     function verify(
173         bytes32[] memory proof,
174         bytes32 root,
175         bytes32 leaf
176     ) internal pure returns (bool) {
177         return processProof(proof, leaf) == root;
178     }
179 
180     /**
181      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
182      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
183      * hash matches the root of the tree. When processing the proof, the pairs
184      * of leafs & pre-images are assumed to be sorted.
185      *
186      * _Available since v4.4._
187      */
188     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
189         bytes32 computedHash = leaf;
190         for (uint256 i = 0; i < proof.length; i++) {
191             bytes32 proofElement = proof[i];
192             if (computedHash <= proofElement) {
193                 // Hash(current computed hash + current element of the proof)
194                 computedHash = _efficientHash(computedHash, proofElement);
195             } else {
196                 // Hash(current element of the proof + current computed hash)
197                 computedHash = _efficientHash(proofElement, computedHash);
198             }
199         }
200         return computedHash;
201     }
202 
203     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
204         assembly {
205             mstore(0x00, a)
206             mstore(0x20, b)
207             value := keccak256(0x00, 0x40)
208         }
209     }
210 }
211 
212 // File: @openzeppelin/contracts/utils/Context.sol
213 
214 
215 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
216 
217 pragma solidity ^0.8.0;
218 
219 /**
220  * @dev Provides information about the current execution context, including the
221  * sender of the transaction and its data. While these are generally available
222  * via msg.sender and msg.data, they should not be accessed in such a direct
223  * manner, since when dealing with meta-transactions the account sending and
224  * paying for execution may not be the actual sender (as far as an application
225  * is concerned).
226  *
227  * This contract is only required for intermediate, library-like contracts.
228  */
229 abstract contract Context {
230     function _msgSender() internal view virtual returns (address) {
231         return msg.sender;
232     }
233 
234     function _msgData() internal view virtual returns (bytes calldata) {
235         return msg.data;
236     }
237 }
238 
239 // File: @openzeppelin/contracts/access/Ownable.sol
240 
241 
242 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 
247 /**
248  * @dev Contract module which provides a basic access control mechanism, where
249  * there is an account (an owner) that can be granted exclusive access to
250  * specific functions.
251  *
252  * By default, the owner account will be the one that deploys the contract. This
253  * can later be changed with {transferOwnership}.
254  *
255  * This module is used through inheritance. It will make available the modifier
256  * `onlyOwner`, which can be applied to your functions to restrict their use to
257  * the owner.
258  */
259 abstract contract Ownable is Context {
260     address private _owner;
261 
262     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
263 
264     /**
265      * @dev Initializes the contract setting the deployer as the initial owner.
266      */
267     constructor() {
268         _transferOwnership(_msgSender());
269     }
270 
271     /**
272      * @dev Returns the address of the current owner.
273      */
274     function owner() public view virtual returns (address) {
275         return _owner;
276     }
277 
278     /**
279      * @dev Throws if called by any account other than the owner.
280      */
281     modifier onlyOwner() {
282         require(owner() == _msgSender(), "Ownable: caller is not the owner");
283         _;
284     }
285 
286     /**
287      * @dev Leaves the contract without owner. It will not be possible to call
288      * `onlyOwner` functions anymore. Can only be called by the current owner.
289      *
290      * NOTE: Renouncing ownership will leave the contract without an owner,
291      * thereby removing any functionality that is only available to the owner.
292      */
293     function renounceOwnership() public virtual onlyOwner {
294         _transferOwnership(address(0));
295     }
296 
297     /**
298      * @dev Transfers ownership of the contract to a new account (`newOwner`).
299      * Can only be called by the current owner.
300      */
301     function transferOwnership(address newOwner) public virtual onlyOwner {
302         require(newOwner != address(0), "Ownable: new owner is the zero address");
303         _transferOwnership(newOwner);
304     }
305 
306     /**
307      * @dev Transfers ownership of the contract to a new account (`newOwner`).
308      * Internal function without access restriction.
309      */
310     function _transferOwnership(address newOwner) internal virtual {
311         address oldOwner = _owner;
312         _owner = newOwner;
313         emit OwnershipTransferred(oldOwner, newOwner);
314     }
315 }
316 
317 // File: erc721a/contracts/IERC721A.sol
318 
319 
320 // ERC721A Contracts v4.0.0
321 // Creator: Chiru Labs
322 
323 pragma solidity ^0.8.4;
324 
325 /**
326  * @dev Interface of an ERC721A compliant contract.
327  */
328 interface IERC721A {
329     /**
330      * The caller must own the token or be an approved operator.
331      */
332     error ApprovalCallerNotOwnerNorApproved();
333 
334     /**
335      * The token does not exist.
336      */
337     error ApprovalQueryForNonexistentToken();
338 
339     /**
340      * The caller cannot approve to their own address.
341      */
342     error ApproveToCaller();
343 
344     /**
345      * The caller cannot approve to the current owner.
346      */
347     error ApprovalToCurrentOwner();
348 
349     /**
350      * Cannot query the balance for the zero address.
351      */
352     error BalanceQueryForZeroAddress();
353 
354     /**
355      * Cannot mint to the zero address.
356      */
357     error MintToZeroAddress();
358 
359     /**
360      * The quantity of tokens minted must be more than zero.
361      */
362     error MintZeroQuantity();
363 
364     /**
365      * The token does not exist.
366      */
367     error OwnerQueryForNonexistentToken();
368 
369     /**
370      * The caller must own the token or be an approved operator.
371      */
372     error TransferCallerNotOwnerNorApproved();
373 
374     /**
375      * The token must be owned by `from`.
376      */
377     error TransferFromIncorrectOwner();
378 
379     /**
380      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
381      */
382     error TransferToNonERC721ReceiverImplementer();
383 
384     /**
385      * Cannot transfer to the zero address.
386      */
387     error TransferToZeroAddress();
388 
389     /**
390      * The token does not exist.
391      */
392     error URIQueryForNonexistentToken();
393 
394     struct TokenOwnership {
395         // The address of the owner.
396         address addr;
397         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
398         uint64 startTimestamp;
399         // Whether the token has been burned.
400         bool burned;
401     }
402 
403     /**
404      * @dev Returns the total amount of tokens stored by the contract.
405      *
406      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
407      */
408     function totalSupply() external view returns (uint256);
409 
410     // ==============================
411     //            IERC165
412     // ==============================
413 
414     /**
415      * @dev Returns true if this contract implements the interface defined by
416      * `interfaceId`. See the corresponding
417      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
418      * to learn more about how these ids are created.
419      *
420      * This function call must use less than 30 000 gas.
421      */
422     function supportsInterface(bytes4 interfaceId) external view returns (bool);
423 
424     // ==============================
425     //            IERC721
426     // ==============================
427 
428     /**
429      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
430      */
431     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
432 
433     /**
434      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
435      */
436     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
437 
438     /**
439      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
440      */
441     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
442 
443     /**
444      * @dev Returns the number of tokens in ``owner``'s account.
445      */
446     function balanceOf(address owner) external view returns (uint256 balance);
447 
448     /**
449      * @dev Returns the owner of the `tokenId` token.
450      *
451      * Requirements:
452      *
453      * - `tokenId` must exist.
454      */
455     function ownerOf(uint256 tokenId) external view returns (address owner);
456 
457     /**
458      * @dev Safely transfers `tokenId` token from `from` to `to`.
459      *
460      * Requirements:
461      *
462      * - `from` cannot be the zero address.
463      * - `to` cannot be the zero address.
464      * - `tokenId` token must exist and be owned by `from`.
465      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
466      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
467      *
468      * Emits a {Transfer} event.
469      */
470     function safeTransferFrom(
471         address from,
472         address to,
473         uint256 tokenId,
474         bytes calldata data
475     ) external;
476 
477     /**
478      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
479      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
480      *
481      * Requirements:
482      *
483      * - `from` cannot be the zero address.
484      * - `to` cannot be the zero address.
485      * - `tokenId` token must exist and be owned by `from`.
486      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
487      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
488      *
489      * Emits a {Transfer} event.
490      */
491     function safeTransferFrom(
492         address from,
493         address to,
494         uint256 tokenId
495     ) external;
496 
497     /**
498      * @dev Transfers `tokenId` token from `from` to `to`.
499      *
500      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
501      *
502      * Requirements:
503      *
504      * - `from` cannot be the zero address.
505      * - `to` cannot be the zero address.
506      * - `tokenId` token must be owned by `from`.
507      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
508      *
509      * Emits a {Transfer} event.
510      */
511     function transferFrom(
512         address from,
513         address to,
514         uint256 tokenId
515     ) external;
516 
517     /**
518      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
519      * The approval is cleared when the token is transferred.
520      *
521      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
522      *
523      * Requirements:
524      *
525      * - The caller must own the token or be an approved operator.
526      * - `tokenId` must exist.
527      *
528      * Emits an {Approval} event.
529      */
530     function approve(address to, uint256 tokenId) external;
531 
532     /**
533      * @dev Approve or remove `operator` as an operator for the caller.
534      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
535      *
536      * Requirements:
537      *
538      * - The `operator` cannot be the caller.
539      *
540      * Emits an {ApprovalForAll} event.
541      */
542     function setApprovalForAll(address operator, bool _approved) external;
543 
544     /**
545      * @dev Returns the account approved for `tokenId` token.
546      *
547      * Requirements:
548      *
549      * - `tokenId` must exist.
550      */
551     function getApproved(uint256 tokenId) external view returns (address operator);
552 
553     /**
554      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
555      *
556      * See {setApprovalForAll}
557      */
558     function isApprovedForAll(address owner, address operator) external view returns (bool);
559 
560     // ==============================
561     //        IERC721Metadata
562     // ==============================
563 
564     /**
565      * @dev Returns the token collection name.
566      */
567     function name() external view returns (string memory);
568 
569     /**
570      * @dev Returns the token collection symbol.
571      */
572     function symbol() external view returns (string memory);
573 
574     /**
575      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
576      */
577     function tokenURI(uint256 tokenId) external view returns (string memory);
578 }
579 
580 // File: erc721a/contracts/ERC721A.sol
581 
582 
583 // ERC721A Contracts v4.0.0
584 // Creator: Chiru Labs
585 
586 pragma solidity ^0.8.4;
587 
588 
589 /**
590  * @dev ERC721 token receiver interface.
591  */
592 interface ERC721A__IERC721Receiver {
593     function onERC721Received(
594         address operator,
595         address from,
596         uint256 tokenId,
597         bytes calldata data
598     ) external returns (bytes4);
599 }
600 
601 /**
602  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
603  * the Metadata extension. Built to optimize for lower gas during batch mints.
604  *
605  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
606  *
607  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
608  *
609  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
610  */
611 contract ERC721A is IERC721A {
612     // Mask of an entry in packed address data.
613     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
614 
615     // The bit position of `numberMinted` in packed address data.
616     uint256 private constant BITPOS_NUMBER_MINTED = 64;
617 
618     // The bit position of `numberBurned` in packed address data.
619     uint256 private constant BITPOS_NUMBER_BURNED = 128;
620 
621     // The bit position of `aux` in packed address data.
622     uint256 private constant BITPOS_AUX = 192;
623 
624     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
625     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
626 
627     // The bit position of `startTimestamp` in packed ownership.
628     uint256 private constant BITPOS_START_TIMESTAMP = 160;
629 
630     // The bit mask of the `burned` bit in packed ownership.
631     uint256 private constant BITMASK_BURNED = 1 << 224;
632     
633     // The bit position of the `nextInitialized` bit in packed ownership.
634     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
635 
636     // The bit mask of the `nextInitialized` bit in packed ownership.
637     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
638 
639     // The tokenId of the next token to be minted.
640     uint256 private _currentIndex;
641 
642     // The number of tokens burned.
643     uint256 private _burnCounter;
644 
645     // Token name
646     string private _name;
647 
648     // Token symbol
649     string private _symbol;
650 
651     // Mapping from token ID to ownership details
652     // An empty struct value does not necessarily mean the token is unowned.
653     // See `_packedOwnershipOf` implementation for details.
654     //
655     // Bits Layout:
656     // - [0..159]   `addr`
657     // - [160..223] `startTimestamp`
658     // - [224]      `burned`
659     // - [225]      `nextInitialized`
660     mapping(uint256 => uint256) private _packedOwnerships;
661 
662     // Mapping owner address to address data.
663     //
664     // Bits Layout:
665     // - [0..63]    `balance`
666     // - [64..127]  `numberMinted`
667     // - [128..191] `numberBurned`
668     // - [192..255] `aux`
669     mapping(address => uint256) private _packedAddressData;
670 
671     // Mapping from token ID to approved address.
672     mapping(uint256 => address) private _tokenApprovals;
673 
674     // Mapping from owner to operator approvals
675     mapping(address => mapping(address => bool)) private _operatorApprovals;
676 
677     constructor(string memory name_, string memory symbol_) {
678         _name = name_;
679         _symbol = symbol_;
680         _currentIndex = _startTokenId();
681     }
682 
683     /**
684      * @dev Returns the starting token ID. 
685      * To change the starting token ID, please override this function.
686      */
687     function _startTokenId() internal view virtual returns (uint256) {
688         return 0;
689     }
690 
691     /**
692      * @dev Returns the next token ID to be minted.
693      */
694     function _nextTokenId() internal view returns (uint256) {
695         return _currentIndex;
696     }
697 
698     /**
699      * @dev Returns the total number of tokens in existence.
700      * Burned tokens will reduce the count. 
701      * To get the total number of tokens minted, please see `_totalMinted`.
702      */
703     function totalSupply() public view override returns (uint256) {
704         // Counter underflow is impossible as _burnCounter cannot be incremented
705         // more than `_currentIndex - _startTokenId()` times.
706         unchecked {
707             return _currentIndex - _burnCounter - _startTokenId();
708         }
709     }
710 
711     /**
712      * @dev Returns the total amount of tokens minted in the contract.
713      */
714     function _totalMinted() internal view returns (uint256) {
715         // Counter underflow is impossible as _currentIndex does not decrement,
716         // and it is initialized to `_startTokenId()`
717         unchecked {
718             return _currentIndex - _startTokenId();
719         }
720     }
721 
722     /**
723      * @dev Returns the total number of tokens burned.
724      */
725     function _totalBurned() internal view returns (uint256) {
726         return _burnCounter;
727     }
728 
729     /**
730      * @dev See {IERC165-supportsInterface}.
731      */
732     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
733         // The interface IDs are constants representing the first 4 bytes of the XOR of
734         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
735         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
736         return
737             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
738             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
739             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
740     }
741 
742     /**
743      * @dev See {IERC721-balanceOf}.
744      */
745     function balanceOf(address owner) public view override returns (uint256) {
746         if (owner == address(0)) revert BalanceQueryForZeroAddress();
747         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
748     }
749 
750     /**
751      * Returns the number of tokens minted by `owner`.
752      */
753     function _numberMinted(address owner) internal view returns (uint256) {
754         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
755     }
756 
757     /**
758      * Returns the number of tokens burned by or on behalf of `owner`.
759      */
760     function _numberBurned(address owner) internal view returns (uint256) {
761         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
762     }
763 
764     /**
765      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
766      */
767     function _getAux(address owner) internal view returns (uint64) {
768         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
769     }
770 
771     /**
772      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
773      * If there are multiple variables, please pack them into a uint64.
774      */
775     function _setAux(address owner, uint64 aux) internal {
776         uint256 packed = _packedAddressData[owner];
777         uint256 auxCasted;
778         assembly { // Cast aux without masking.
779             auxCasted := aux
780         }
781         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
782         _packedAddressData[owner] = packed;
783     }
784 
785     /**
786      * Returns the packed ownership data of `tokenId`.
787      */
788     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
789         uint256 curr = tokenId;
790 
791         unchecked {
792             if (_startTokenId() <= curr)
793                 if (curr < _currentIndex) {
794                     uint256 packed = _packedOwnerships[curr];
795                     // If not burned.
796                     if (packed & BITMASK_BURNED == 0) {
797                         // Invariant:
798                         // There will always be an ownership that has an address and is not burned
799                         // before an ownership that does not have an address and is not burned.
800                         // Hence, curr will not underflow.
801                         //
802                         // We can directly compare the packed value.
803                         // If the address is zero, packed is zero.
804                         while (packed == 0) {
805                             packed = _packedOwnerships[--curr];
806                         }
807                         return packed;
808                     }
809                 }
810         }
811         revert OwnerQueryForNonexistentToken();
812     }
813 
814     /**
815      * Returns the unpacked `TokenOwnership` struct from `packed`.
816      */
817     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
818         ownership.addr = address(uint160(packed));
819         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
820         ownership.burned = packed & BITMASK_BURNED != 0;
821     }
822 
823     /**
824      * Returns the unpacked `TokenOwnership` struct at `index`.
825      */
826     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
827         return _unpackedOwnership(_packedOwnerships[index]);
828     }
829 
830     /**
831      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
832      */
833     function _initializeOwnershipAt(uint256 index) internal {
834         if (_packedOwnerships[index] == 0) {
835             _packedOwnerships[index] = _packedOwnershipOf(index);
836         }
837     }
838 
839     /**
840      * Gas spent here starts off proportional to the maximum mint batch size.
841      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
842      */
843     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
844         return _unpackedOwnership(_packedOwnershipOf(tokenId));
845     }
846 
847     /**
848      * @dev See {IERC721-ownerOf}.
849      */
850     function ownerOf(uint256 tokenId) public view override returns (address) {
851         return address(uint160(_packedOwnershipOf(tokenId)));
852     }
853 
854     /**
855      * @dev See {IERC721Metadata-name}.
856      */
857     function name() public view virtual override returns (string memory) {
858         return _name;
859     }
860 
861     /**
862      * @dev See {IERC721Metadata-symbol}.
863      */
864     function symbol() public view virtual override returns (string memory) {
865         return _symbol;
866     }
867 
868     /**
869      * @dev See {IERC721Metadata-tokenURI}.
870      */
871     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
872         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
873 
874         string memory baseURI = _baseURI();
875         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
876     }
877 
878     /**
879      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
880      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
881      * by default, can be overriden in child contracts.
882      */
883     function _baseURI() internal view virtual returns (string memory) {
884         return '';
885     }
886 
887     /**
888      * @dev Casts the address to uint256 without masking.
889      */
890     function _addressToUint256(address value) private pure returns (uint256 result) {
891         assembly {
892             result := value
893         }
894     }
895 
896     /**
897      * @dev Casts the boolean to uint256 without branching.
898      */
899     function _boolToUint256(bool value) private pure returns (uint256 result) {
900         assembly {
901             result := value
902         }
903     }
904 
905     /**
906      * @dev See {IERC721-approve}.
907      */
908     function approve(address to, uint256 tokenId) public override {
909         address owner = address(uint160(_packedOwnershipOf(tokenId)));
910         if (to == owner) revert ApprovalToCurrentOwner();
911 
912         if (_msgSenderERC721A() != owner)
913             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
914                 revert ApprovalCallerNotOwnerNorApproved();
915             }
916 
917         _tokenApprovals[tokenId] = to;
918         emit Approval(owner, to, tokenId);
919     }
920 
921     /**
922      * @dev See {IERC721-getApproved}.
923      */
924     function getApproved(uint256 tokenId) public view override returns (address) {
925         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
926 
927         return _tokenApprovals[tokenId];
928     }
929 
930     /**
931      * @dev See {IERC721-setApprovalForAll}.
932      */
933     function setApprovalForAll(address operator, bool approved) public virtual override {
934         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
935 
936         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
937         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
938     }
939 
940     /**
941      * @dev See {IERC721-isApprovedForAll}.
942      */
943     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
944         return _operatorApprovals[owner][operator];
945     }
946 
947     /**
948      * @dev See {IERC721-transferFrom}.
949      */
950     function transferFrom(
951         address from,
952         address to,
953         uint256 tokenId
954     ) public virtual override {
955         _transfer(from, to, tokenId);
956     }
957 
958     /**
959      * @dev See {IERC721-safeTransferFrom}.
960      */
961     function safeTransferFrom(
962         address from,
963         address to,
964         uint256 tokenId
965     ) public virtual override {
966         safeTransferFrom(from, to, tokenId, '');
967     }
968 
969     /**
970      * @dev See {IERC721-safeTransferFrom}.
971      */
972     function safeTransferFrom(
973         address from,
974         address to,
975         uint256 tokenId,
976         bytes memory _data
977     ) public virtual override {
978         _transfer(from, to, tokenId);
979         if (to.code.length != 0)
980             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
981                 revert TransferToNonERC721ReceiverImplementer();
982             }
983     }
984 
985     /**
986      * @dev Returns whether `tokenId` exists.
987      *
988      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
989      *
990      * Tokens start existing when they are minted (`_mint`),
991      */
992     function _exists(uint256 tokenId) internal view returns (bool) {
993         return
994             _startTokenId() <= tokenId &&
995             tokenId < _currentIndex && // If within bounds,
996             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
997     }
998 
999     /**
1000      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1001      */
1002     function _safeMint(address to, uint256 quantity) internal {
1003         _safeMint(to, quantity, '');
1004     }
1005 
1006     /**
1007      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1008      *
1009      * Requirements:
1010      *
1011      * - If `to` refers to a smart contract, it must implement
1012      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1013      * - `quantity` must be greater than 0.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _safeMint(
1018         address to,
1019         uint256 quantity,
1020         bytes memory _data
1021     ) internal {
1022         uint256 startTokenId = _currentIndex;
1023         if (to == address(0)) revert MintToZeroAddress();
1024         if (quantity == 0) revert MintZeroQuantity();
1025 
1026         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1027 
1028         // Overflows are incredibly unrealistic.
1029         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1030         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1031         unchecked {
1032             // Updates:
1033             // - `balance += quantity`.
1034             // - `numberMinted += quantity`.
1035             //
1036             // We can directly add to the balance and number minted.
1037             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1038 
1039             // Updates:
1040             // - `address` to the owner.
1041             // - `startTimestamp` to the timestamp of minting.
1042             // - `burned` to `false`.
1043             // - `nextInitialized` to `quantity == 1`.
1044             _packedOwnerships[startTokenId] =
1045                 _addressToUint256(to) |
1046                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1047                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1048 
1049             uint256 updatedIndex = startTokenId;
1050             uint256 end = updatedIndex + quantity;
1051 
1052             if (to.code.length != 0) {
1053                 do {
1054                     emit Transfer(address(0), to, updatedIndex);
1055                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1056                         revert TransferToNonERC721ReceiverImplementer();
1057                     }
1058                 } while (updatedIndex < end);
1059                 // Reentrancy protection
1060                 if (_currentIndex != startTokenId) revert();
1061             } else {
1062                 do {
1063                     emit Transfer(address(0), to, updatedIndex++);
1064                 } while (updatedIndex < end);
1065             }
1066             _currentIndex = updatedIndex;
1067         }
1068         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1069     }
1070 
1071     /**
1072      * @dev Mints `quantity` tokens and transfers them to `to`.
1073      *
1074      * Requirements:
1075      *
1076      * - `to` cannot be the zero address.
1077      * - `quantity` must be greater than 0.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _mint(address to, uint256 quantity) internal {
1082         uint256 startTokenId = _currentIndex;
1083         if (to == address(0)) revert MintToZeroAddress();
1084         if (quantity == 0) revert MintZeroQuantity();
1085 
1086         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1087 
1088         // Overflows are incredibly unrealistic.
1089         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1090         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1091         unchecked {
1092             // Updates:
1093             // - `balance += quantity`.
1094             // - `numberMinted += quantity`.
1095             //
1096             // We can directly add to the balance and number minted.
1097             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1098 
1099             // Updates:
1100             // - `address` to the owner.
1101             // - `startTimestamp` to the timestamp of minting.
1102             // - `burned` to `false`.
1103             // - `nextInitialized` to `quantity == 1`.
1104             _packedOwnerships[startTokenId] =
1105                 _addressToUint256(to) |
1106                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1107                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1108 
1109             uint256 updatedIndex = startTokenId;
1110             uint256 end = updatedIndex + quantity;
1111 
1112             do {
1113                 emit Transfer(address(0), to, updatedIndex++);
1114             } while (updatedIndex < end);
1115 
1116             _currentIndex = updatedIndex;
1117         }
1118         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1119     }
1120 
1121     /**
1122      * @dev Transfers `tokenId` from `from` to `to`.
1123      *
1124      * Requirements:
1125      *
1126      * - `to` cannot be the zero address.
1127      * - `tokenId` token must be owned by `from`.
1128      *
1129      * Emits a {Transfer} event.
1130      */
1131     function _transfer(
1132         address from,
1133         address to,
1134         uint256 tokenId
1135     ) private {
1136         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1137 
1138         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1139 
1140         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1141             isApprovedForAll(from, _msgSenderERC721A()) ||
1142             getApproved(tokenId) == _msgSenderERC721A());
1143 
1144         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1145         if (to == address(0)) revert TransferToZeroAddress();
1146 
1147         _beforeTokenTransfers(from, to, tokenId, 1);
1148 
1149         // Clear approvals from the previous owner.
1150         delete _tokenApprovals[tokenId];
1151 
1152         // Underflow of the sender's balance is impossible because we check for
1153         // ownership above and the recipient's balance can't realistically overflow.
1154         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1155         unchecked {
1156             // We can directly increment and decrement the balances.
1157             --_packedAddressData[from]; // Updates: `balance -= 1`.
1158             ++_packedAddressData[to]; // Updates: `balance += 1`.
1159 
1160             // Updates:
1161             // - `address` to the next owner.
1162             // - `startTimestamp` to the timestamp of transfering.
1163             // - `burned` to `false`.
1164             // - `nextInitialized` to `true`.
1165             _packedOwnerships[tokenId] =
1166                 _addressToUint256(to) |
1167                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1168                 BITMASK_NEXT_INITIALIZED;
1169 
1170             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1171             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1172                 uint256 nextTokenId = tokenId + 1;
1173                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1174                 if (_packedOwnerships[nextTokenId] == 0) {
1175                     // If the next slot is within bounds.
1176                     if (nextTokenId != _currentIndex) {
1177                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1178                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1179                     }
1180                 }
1181             }
1182         }
1183 
1184         emit Transfer(from, to, tokenId);
1185         _afterTokenTransfers(from, to, tokenId, 1);
1186     }
1187 
1188     /**
1189      * @dev Equivalent to `_burn(tokenId, false)`.
1190      */
1191     function _burn(uint256 tokenId) internal virtual {
1192         _burn(tokenId, false);
1193     }
1194 
1195     /**
1196      * @dev Destroys `tokenId`.
1197      * The approval is cleared when the token is burned.
1198      *
1199      * Requirements:
1200      *
1201      * - `tokenId` must exist.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1206         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1207 
1208         address from = address(uint160(prevOwnershipPacked));
1209 
1210         if (approvalCheck) {
1211             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1212                 isApprovedForAll(from, _msgSenderERC721A()) ||
1213                 getApproved(tokenId) == _msgSenderERC721A());
1214 
1215             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1216         }
1217 
1218         _beforeTokenTransfers(from, address(0), tokenId, 1);
1219 
1220         // Clear approvals from the previous owner.
1221         delete _tokenApprovals[tokenId];
1222 
1223         // Underflow of the sender's balance is impossible because we check for
1224         // ownership above and the recipient's balance can't realistically overflow.
1225         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1226         unchecked {
1227             // Updates:
1228             // - `balance -= 1`.
1229             // - `numberBurned += 1`.
1230             //
1231             // We can directly decrement the balance, and increment the number burned.
1232             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1233             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1234 
1235             // Updates:
1236             // - `address` to the last owner.
1237             // - `startTimestamp` to the timestamp of burning.
1238             // - `burned` to `true`.
1239             // - `nextInitialized` to `true`.
1240             _packedOwnerships[tokenId] =
1241                 _addressToUint256(from) |
1242                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1243                 BITMASK_BURNED | 
1244                 BITMASK_NEXT_INITIALIZED;
1245 
1246             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1247             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1248                 uint256 nextTokenId = tokenId + 1;
1249                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1250                 if (_packedOwnerships[nextTokenId] == 0) {
1251                     // If the next slot is within bounds.
1252                     if (nextTokenId != _currentIndex) {
1253                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1254                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1255                     }
1256                 }
1257             }
1258         }
1259 
1260         emit Transfer(from, address(0), tokenId);
1261         _afterTokenTransfers(from, address(0), tokenId, 1);
1262 
1263         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1264         unchecked {
1265             _burnCounter++;
1266         }
1267     }
1268 
1269     /**
1270      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1271      *
1272      * @param from address representing the previous owner of the given token ID
1273      * @param to target address that will receive the tokens
1274      * @param tokenId uint256 ID of the token to be transferred
1275      * @param _data bytes optional data to send along with the call
1276      * @return bool whether the call correctly returned the expected magic value
1277      */
1278     function _checkContractOnERC721Received(
1279         address from,
1280         address to,
1281         uint256 tokenId,
1282         bytes memory _data
1283     ) private returns (bool) {
1284         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1285             bytes4 retval
1286         ) {
1287             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1288         } catch (bytes memory reason) {
1289             if (reason.length == 0) {
1290                 revert TransferToNonERC721ReceiverImplementer();
1291             } else {
1292                 assembly {
1293                     revert(add(32, reason), mload(reason))
1294                 }
1295             }
1296         }
1297     }
1298 
1299     /**
1300      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1301      * And also called before burning one token.
1302      *
1303      * startTokenId - the first token id to be transferred
1304      * quantity - the amount to be transferred
1305      *
1306      * Calling conditions:
1307      *
1308      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1309      * transferred to `to`.
1310      * - When `from` is zero, `tokenId` will be minted for `to`.
1311      * - When `to` is zero, `tokenId` will be burned by `from`.
1312      * - `from` and `to` are never both zero.
1313      */
1314     function _beforeTokenTransfers(
1315         address from,
1316         address to,
1317         uint256 startTokenId,
1318         uint256 quantity
1319     ) internal virtual {}
1320 
1321     /**
1322      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1323      * minting.
1324      * And also called after one token has been burned.
1325      *
1326      * startTokenId - the first token id to be transferred
1327      * quantity - the amount to be transferred
1328      *
1329      * Calling conditions:
1330      *
1331      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1332      * transferred to `to`.
1333      * - When `from` is zero, `tokenId` has been minted for `to`.
1334      * - When `to` is zero, `tokenId` has been burned by `from`.
1335      * - `from` and `to` are never both zero.
1336      */
1337     function _afterTokenTransfers(
1338         address from,
1339         address to,
1340         uint256 startTokenId,
1341         uint256 quantity
1342     ) internal virtual {}
1343 
1344     /**
1345      * @dev Returns the message sender (defaults to `msg.sender`).
1346      *
1347      * If you are writing GSN compatible contracts, you need to override this function.
1348      */
1349     function _msgSenderERC721A() internal view virtual returns (address) {
1350         return msg.sender;
1351     }
1352 
1353     /**
1354      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1355      */
1356     function _toString(uint256 value) internal pure returns (string memory ptr) {
1357         assembly {
1358             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1359             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1360             // We will need 1 32-byte word to store the length, 
1361             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1362             ptr := add(mload(0x40), 128)
1363             // Update the free memory pointer to allocate.
1364             mstore(0x40, ptr)
1365 
1366             // Cache the end of the memory to calculate the length later.
1367             let end := ptr
1368 
1369             // We write the string from the rightmost digit to the leftmost digit.
1370             // The following is essentially a do-while loop that also handles the zero case.
1371             // Costs a bit more than early returning for the zero case,
1372             // but cheaper in terms of deployment and overall runtime costs.
1373             for { 
1374                 // Initialize and perform the first pass without check.
1375                 let temp := value
1376                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1377                 ptr := sub(ptr, 1)
1378                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1379                 mstore8(ptr, add(48, mod(temp, 10)))
1380                 temp := div(temp, 10)
1381             } temp { 
1382                 // Keep dividing `temp` until zero.
1383                 temp := div(temp, 10)
1384             } { // Body of the for loop.
1385                 ptr := sub(ptr, 1)
1386                 mstore8(ptr, add(48, mod(temp, 10)))
1387             }
1388             
1389             let length := sub(end, ptr)
1390             // Move the pointer 32 bytes leftwards to make room for the length.
1391             ptr := sub(ptr, 32)
1392             // Store the length.
1393             mstore(ptr, length)
1394         }
1395     }
1396 }
1397 
1398 // File: contracts/mayaProtocol.sol
1399 
1400 pragma solidity >=0.8.9 <0.9.0;
1401 
1402 contract MayaMasks is ERC721A, Ownable, ReentrancyGuard {
1403   using Strings for uint256;
1404 
1405   string public baseURI = "ipfs://bafybeidxn2p5ef2wvqen4blezzi7se5inl7l6ovmroyaffeygewz6ufwfq/";
1406   string public hiddenMetadataUri;
1407   uint256 public maxMayaMasks = 6060; 
1408   uint256 public Max_MayaMasks_MayaList = 5;
1409   uint256 public Max_MayaMasks_TGMayaList = 10;
1410   uint256 public Max_MayaMasks_BigTGMayaList = 30;
1411   uint256 public MayaListCost = 0.075 ether;
1412   uint256 public TGMayaListCost = 0.05 ether;
1413   uint256 public BigTGMayaListCost = 0.05 ether;
1414   uint256 public publicSaleCost = 0.1 ether;
1415   uint256 public Max_MayaMasks_Per_Transaction = 20;
1416   bool public paused = false;
1417   bool public revealed = true;
1418   bool public isPublicSaleActive = false;
1419   bool public isMayaListSaleActive = false;
1420   bool public isTGMayaListSaleActive = false;
1421   bool public isBigTGMayaListSaleActive = true;
1422   bytes32 public MayaListRootHash = 0xf846af13778cf1acb2d623f3052f2e97be7f602048f2f4a86394ab060fc3763b;
1423   bytes32 public TGMayaListRootHash = 0x4c58c4bf0e2b511a28eae71079505887c0ab264c55be69f369ccb1cf4a5b7be9;
1424   bytes32 public BigTGMayaListRootHash = 0x5e63551190109026b038f4b25f15f21c5c253618de5c4ae9d62de72e6e8231f9;
1425   mapping(address => uint256) public mintedByWalletMayaList;
1426   mapping(address => uint256) public mintedByWalletTGMayaList;
1427   mapping(address => uint256) public mintedByWalletBTGMayaList;
1428 
1429   modifier publicSaleActive() {
1430     require(isPublicSaleActive, "Public sale is not open");
1431     _;
1432   }
1433 
1434   modifier mayaListSaleActive() {
1435     require(isMayaListSaleActive, "Maya List sale is not open");
1436     _;
1437   }
1438 
1439   modifier TGmayaListSaleActive() {
1440     require(isTGMayaListSaleActive, "TG Maya List sale is not open");
1441     _;
1442   }
1443 
1444   modifier BTGmayaListSaleActive() {
1445     require(isBigTGMayaListSaleActive, "Big TG Maya List sale is not open");
1446     _;
1447   }
1448 
1449   modifier salePaused() {
1450     require(!paused, "Sale is paused");
1451     _;
1452   }
1453 
1454   modifier maxMayaMasksMayaList(uint256 numberOfTokens) {
1455     require(
1456         numberOfTokens + mintedByWalletMayaList[msg.sender] <= Max_MayaMasks_MayaList,
1457         "Address already claimed their NFTs"
1458     );
1459     _;
1460   }
1461 
1462   modifier maxMayaMasksTGMayaList(uint256 numberOfTokens) {
1463     
1464     require(
1465         numberOfTokens + mintedByWalletTGMayaList[msg.sender] <= Max_MayaMasks_TGMayaList,
1466         "Address already claimed their NFTs"
1467     );
1468     _;
1469   }
1470 
1471   modifier maxMayaMasksBigTGMayaList(uint256 numberOfTokens) {
1472     
1473     require(
1474         numberOfTokens + mintedByWalletBTGMayaList[msg.sender] <= Max_MayaMasks_BigTGMayaList,
1475         "Address already claimed their NFTs"
1476     );
1477     _;
1478   }
1479 
1480   modifier canMintMayaMasks(uint256 numberOfTokens) {
1481     require(
1482       totalSupply() + numberOfTokens <= maxMayaMasks,
1483       "Not enough MayaMasks remaining to mint"
1484     );
1485     require(
1486       numberOfTokens > 0 && numberOfTokens <= Max_MayaMasks_Per_Transaction, "Invalid mint amount!"
1487     );
1488     _;
1489   }
1490 
1491   modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1492     require(
1493       msg.value >= price * numberOfTokens,
1494       "Insufficient Funds!!!"
1495     );
1496     _;
1497   }
1498 
1499   modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
1500     require(
1501       MerkleProof.verify(
1502         merkleProof,
1503         root,
1504         keccak256(abi.encodePacked(msg.sender))
1505       ), "Your address is not whitelisted"
1506     );
1507     _;
1508   }
1509 
1510   constructor() ERC721A("Maya Masks", "MM") {
1511     setHiddenMetadataUri("ipfs://");
1512   }
1513 
1514   function publicMint(uint256 numberOfTokens)
1515     external
1516     payable
1517     nonReentrant
1518     salePaused
1519     publicSaleActive
1520     canMintMayaMasks(numberOfTokens)
1521     isCorrectPayment(publicSaleCost, numberOfTokens)
1522     {
1523       _safeMint(msg.sender, numberOfTokens); 
1524     }
1525 
1526   function mayaListMint(uint numberOfTokens, bytes32[] calldata merkleProof) 
1527     external
1528     payable
1529     nonReentrant
1530     salePaused
1531     mayaListSaleActive
1532     canMintMayaMasks(numberOfTokens)
1533     maxMayaMasksMayaList(numberOfTokens)
1534     isValidMerkleProof(merkleProof, MayaListRootHash)
1535     isCorrectPayment(MayaListCost, numberOfTokens)
1536     {
1537       mintedByWalletMayaList[msg.sender] += numberOfTokens;
1538       _safeMint(msg.sender, numberOfTokens);
1539     }
1540 
1541   function TGmayaListMint(uint numberOfTokens, bytes32[] calldata merkleProof) 
1542     external
1543     payable
1544     nonReentrant
1545     salePaused
1546     TGmayaListSaleActive
1547     canMintMayaMasks(numberOfTokens)
1548     maxMayaMasksTGMayaList(numberOfTokens)
1549     isValidMerkleProof(merkleProof, TGMayaListRootHash)
1550     isCorrectPayment(TGMayaListCost, numberOfTokens)
1551     {
1552       mintedByWalletTGMayaList[msg.sender] += numberOfTokens;
1553       _safeMint(msg.sender, numberOfTokens);
1554     }
1555 
1556   function BTGmayaListMint(uint numberOfTokens, bytes32[] calldata merkleProof) 
1557     external
1558     payable
1559     nonReentrant
1560     salePaused
1561     BTGmayaListSaleActive
1562     canMintMayaMasks(numberOfTokens)
1563     maxMayaMasksBigTGMayaList(numberOfTokens)
1564     isValidMerkleProof(merkleProof, BigTGMayaListRootHash)
1565     isCorrectPayment(BigTGMayaListCost, numberOfTokens)
1566     {
1567       mintedByWalletBTGMayaList[msg.sender] += numberOfTokens;
1568       _safeMint(msg.sender, numberOfTokens);
1569     }
1570 
1571   // Owner quota for the team and giveaways
1572   function ownerMint(uint256 numberOfTokens, address _receiver)
1573     public
1574     nonReentrant
1575     onlyOwner
1576     canMintMayaMasks(numberOfTokens)
1577     {
1578       _safeMint(_receiver, numberOfTokens);
1579     }
1580   // function getBaseURI() external view returns (string memory) {
1581   //   return baseURI;
1582   // }
1583 
1584   function setBaseURI(string memory _baseURI) external onlyOwner {
1585     baseURI = _baseURI;
1586   }
1587 
1588 
1589   function setRevealed(bool _state) external onlyOwner {
1590     revealed = _state;
1591   }
1592 
1593   function setMayaListRootHash(bytes32 _Root) external onlyOwner {
1594     MayaListRootHash = _Root;
1595   }
1596 
1597   function setTGMayaListRootHash(bytes32 _Root) external onlyOwner {
1598     TGMayaListRootHash = _Root;
1599   }
1600 
1601   function setBTGMayaListRootHash(bytes32 _Root) external onlyOwner {
1602     BigTGMayaListRootHash = _Root;
1603   }
1604 
1605   function setPaused(bool _state) external onlyOwner {
1606     paused = _state;
1607   }
1608 
1609   function openMayaListSale() external onlyOwner {
1610     isMayaListSaleActive = true;
1611     isTGMayaListSaleActive = false;
1612     isBigTGMayaListSaleActive = false;
1613     isPublicSaleActive = false;
1614   }
1615 
1616   function openTGMayaListSale() external onlyOwner {
1617     isMayaListSaleActive = false;
1618     isTGMayaListSaleActive = true;
1619     isBigTGMayaListSaleActive = false;
1620     isPublicSaleActive = false;
1621   }
1622 
1623   function openBigTGMayaListSale() external onlyOwner {
1624     isMayaListSaleActive = false;
1625     isTGMayaListSaleActive = false;
1626     isBigTGMayaListSaleActive = true;
1627     isPublicSaleActive = false;
1628   }
1629 
1630   function openPublicSale() external onlyOwner {
1631     isMayaListSaleActive = false;
1632     isTGMayaListSaleActive = false;
1633     isBigTGMayaListSaleActive = false;
1634     isPublicSaleActive = true;
1635   }
1636 
1637   function walletOfOwner(address _owner)
1638     public
1639     view
1640     returns (uint256[] memory)
1641   {
1642     uint256 ownerTokenCount = balanceOf(_owner);
1643     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1644     uint256 currentTokenId = 1;
1645     uint256 ownedTokenIndex = 0;
1646 
1647     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxMayaMasks) {
1648       address currentTokenOwner = ownerOf(currentTokenId);
1649 
1650       if (currentTokenOwner == _owner) {
1651         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1652 
1653         ownedTokenIndex++;
1654       }
1655 
1656       currentTokenId++;
1657     }
1658 
1659     return ownedTokenIds;
1660   } 
1661 
1662   function _startTokenId() internal view virtual override returns (uint256) {
1663     return 1;
1664   }
1665 
1666   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory){
1667     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1668 
1669     if (revealed == false) {
1670       return hiddenMetadataUri;
1671     }
1672     
1673     // string memory currentBaseURI = _baseURI();
1674     
1675     return bytes(baseURI).length > 0
1676         ? string(abi.encodePacked(baseURI, _tokenId.toString(), ".json"))
1677         : '';
1678   }
1679 
1680   function setMayaListCost(uint256 _cost) external onlyOwner {
1681     MayaListCost = _cost;
1682   }
1683 
1684   function setTGMayaListCost(uint256 _cost) external onlyOwner {
1685     TGMayaListCost = _cost;
1686   }
1687 
1688   function setBigTGMayaListCost(uint256 _cost) external onlyOwner {
1689     BigTGMayaListCost = _cost;
1690   }
1691 
1692   function setPublicSaleCost(uint256 _cost) external onlyOwner {
1693     publicSaleCost = _cost;
1694   }
1695 
1696   function setMaxMayaMasksPerTx(uint256 _maxMayaMasksPerTx) external onlyOwner {
1697     Max_MayaMasks_Per_Transaction = _maxMayaMasksPerTx;
1698   }
1699 
1700   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1701     hiddenMetadataUri = _hiddenMetadataUri;
1702   }
1703 
1704   function setMaxMayaMasks(uint256 _MaxMayaMasks) external onlyOwner {
1705       maxMayaMasks = _MaxMayaMasks;
1706   }
1707 
1708   function withdraw() public onlyOwner {    
1709     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1710     require(os);    
1711   }
1712 
1713 }