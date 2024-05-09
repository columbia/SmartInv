1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
39      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
40      * hash matches the root of the tree. When processing the proof, the pairs
41      * of leafs & pre-images are assumed to be sorted.
42      *
43      * _Available since v4.4._
44      */
45     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
46         bytes32 computedHash = leaf;
47         for (uint256 i = 0; i < proof.length; i++) {
48             bytes32 proofElement = proof[i];
49             if (computedHash <= proofElement) {
50                 // Hash(current computed hash + current element of the proof)
51                 computedHash = _efficientHash(computedHash, proofElement);
52             } else {
53                 // Hash(current element of the proof + current computed hash)
54                 computedHash = _efficientHash(proofElement, computedHash);
55             }
56         }
57         return computedHash;
58     }
59 
60     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
61         assembly {
62             mstore(0x00, a)
63             mstore(0x20, b)
64             value := keccak256(0x00, 0x40)
65         }
66     }
67 }
68 
69 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Contract module that helps prevent reentrant calls to a function.
78  *
79  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
80  * available, which can be applied to functions to make sure there are no nested
81  * (reentrant) calls to them.
82  *
83  * Note that because there is a single `nonReentrant` guard, functions marked as
84  * `nonReentrant` may not call one another. This can be worked around by making
85  * those functions `private`, and then adding `external` `nonReentrant` entry
86  * points to them.
87  *
88  * TIP: If you would like to learn more about reentrancy and alternative ways
89  * to protect against it, check out our blog post
90  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
91  */
92 abstract contract ReentrancyGuard {
93     // Booleans are more expensive than uint256 or any type that takes up a full
94     // word because each write operation emits an extra SLOAD to first read the
95     // slot's contents, replace the bits taken up by the boolean, and then write
96     // back. This is the compiler's defense against contract upgrades and
97     // pointer aliasing, and it cannot be disabled.
98 
99     // The values being non-zero value makes deployment a bit more expensive,
100     // but in exchange the refund on every call to nonReentrant will be lower in
101     // amount. Since refunds are capped to a percentage of the total
102     // transaction's gas, it is best to keep them low in cases like this one, to
103     // increase the likelihood of the full refund coming into effect.
104     uint256 private constant _NOT_ENTERED = 1;
105     uint256 private constant _ENTERED = 2;
106 
107     uint256 private _status;
108 
109     constructor() {
110         _status = _NOT_ENTERED;
111     }
112 
113     /**
114      * @dev Prevents a contract from calling itself, directly or indirectly.
115      * Calling a `nonReentrant` function from another `nonReentrant`
116      * function is not supported. It is possible to prevent this from happening
117      * by making the `nonReentrant` function external, and making it call a
118      * `private` function that does the actual work.
119      */
120     modifier nonReentrant() {
121         // On the first call to nonReentrant, _notEntered will be true
122         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
123 
124         // Any calls to nonReentrant after this point will fail
125         _status = _ENTERED;
126 
127         _;
128 
129         // By storing the original value once again, a refund is triggered (see
130         // https://eips.ethereum.org/EIPS/eip-2200)
131         _status = _NOT_ENTERED;
132     }
133 }
134 
135 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
136 
137 
138 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @title ERC721 token receiver interface
144  * @dev Interface for any contract that wants to support safeTransfers
145  * from ERC721 asset contracts.
146  */
147 interface IERC721Receiver {
148     /**
149      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
150      * by `operator` from `from`, this function is called.
151      *
152      * It must return its Solidity selector to confirm the token transfer.
153      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
154      *
155      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
156      */
157     function onERC721Received(
158         address operator,
159         address from,
160         uint256 tokenId,
161         bytes calldata data
162     ) external returns (bytes4);
163 }
164 
165 // File: @openzeppelin/contracts/utils/Context.sol
166 
167 
168 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 /**
173  * @dev Provides information about the current execution context, including the
174  * sender of the transaction and its data. While these are generally available
175  * via msg.sender and msg.data, they should not be accessed in such a direct
176  * manner, since when dealing with meta-transactions the account sending and
177  * paying for execution may not be the actual sender (as far as an application
178  * is concerned).
179  *
180  * This contract is only required for intermediate, library-like contracts.
181  */
182 abstract contract Context {
183     function _msgSender() internal view virtual returns (address) {
184         return msg.sender;
185     }
186 
187     function _msgData() internal view virtual returns (bytes calldata) {
188         return msg.data;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/access/Ownable.sol
193 
194 
195 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 
200 /**
201  * @dev Contract module which provides a basic access control mechanism, where
202  * there is an account (an owner) that can be granted exclusive access to
203  * specific functions.
204  *
205  * By default, the owner account will be the one that deploys the contract. This
206  * can later be changed with {transferOwnership}.
207  *
208  * This module is used through inheritance. It will make available the modifier
209  * `onlyOwner`, which can be applied to your functions to restrict their use to
210  * the owner.
211  */
212 abstract contract Ownable is Context {
213     address private _owner;
214 
215     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
216 
217     /**
218      * @dev Initializes the contract setting the deployer as the initial owner.
219      */
220     constructor() {
221         _transferOwnership(_msgSender());
222     }
223 
224     /**
225      * @dev Returns the address of the current owner.
226      */
227     function owner() public view virtual returns (address) {
228         return _owner;
229     }
230 
231     /**
232      * @dev Throws if called by any account other than the owner.
233      */
234     modifier onlyOwner() {
235         require(owner() == _msgSender(), "Ownable: caller is not the owner");
236         _;
237     }
238 
239     /**
240      * @dev Leaves the contract without owner. It will not be possible to call
241      * `onlyOwner` functions anymore. Can only be called by the current owner.
242      *
243      * NOTE: Renouncing ownership will leave the contract without an owner,
244      * thereby removing any functionality that is only available to the owner.
245      */
246     function renounceOwnership() public virtual onlyOwner {
247         _transferOwnership(address(0));
248     }
249 
250     /**
251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
252      * Can only be called by the current owner.
253      */
254     function transferOwnership(address newOwner) public virtual onlyOwner {
255         require(newOwner != address(0), "Ownable: new owner is the zero address");
256         _transferOwnership(newOwner);
257     }
258 
259     /**
260      * @dev Transfers ownership of the contract to a new account (`newOwner`).
261      * Internal function without access restriction.
262      */
263     function _transferOwnership(address newOwner) internal virtual {
264         address oldOwner = _owner;
265         _owner = newOwner;
266         emit OwnershipTransferred(oldOwner, newOwner);
267     }
268 }
269 
270 // File: @openzeppelin/contracts/utils/Strings.sol
271 
272 
273 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 /**
278  * @dev String operations.
279  */
280 library Strings {
281     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
282 
283     /**
284      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
285      */
286     function toString(uint256 value) internal pure returns (string memory) {
287         // Inspired by OraclizeAPI's implementation - MIT licence
288         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
289 
290         if (value == 0) {
291             return "0";
292         }
293         uint256 temp = value;
294         uint256 digits;
295         while (temp != 0) {
296             digits++;
297             temp /= 10;
298         }
299         bytes memory buffer = new bytes(digits);
300         while (value != 0) {
301             digits -= 1;
302             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
303             value /= 10;
304         }
305         return string(buffer);
306     }
307 
308     /**
309      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
310      */
311     function toHexString(uint256 value) internal pure returns (string memory) {
312         if (value == 0) {
313             return "0x00";
314         }
315         uint256 temp = value;
316         uint256 length = 0;
317         while (temp != 0) {
318             length++;
319             temp >>= 8;
320         }
321         return toHexString(value, length);
322     }
323 
324     /**
325      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
326      */
327     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
328         bytes memory buffer = new bytes(2 * length + 2);
329         buffer[0] = "0";
330         buffer[1] = "x";
331         for (uint256 i = 2 * length + 1; i > 1; --i) {
332             buffer[i] = _HEX_SYMBOLS[value & 0xf];
333             value >>= 4;
334         }
335         require(value == 0, "Strings: hex length insufficient");
336         return string(buffer);
337     }
338 }
339 
340 // File: erc721a/contracts/IERC721A.sol
341 
342 
343 // ERC721A Contracts v4.0.0
344 // Creator: Chiru Labs
345 
346 pragma solidity ^0.8.4;
347 
348 /**
349  * @dev Interface of an ERC721A compliant contract.
350  */
351 interface IERC721A {
352     /**
353      * The caller must own the token or be an approved operator.
354      */
355     error ApprovalCallerNotOwnerNorApproved();
356 
357     /**
358      * The token does not exist.
359      */
360     error ApprovalQueryForNonexistentToken();
361 
362     /**
363      * The caller cannot approve to their own address.
364      */
365     error ApproveToCaller();
366 
367     /**
368      * The caller cannot approve to the current owner.
369      */
370     error ApprovalToCurrentOwner();
371 
372     /**
373      * Cannot query the balance for the zero address.
374      */
375     error BalanceQueryForZeroAddress();
376 
377     /**
378      * Cannot mint to the zero address.
379      */
380     error MintToZeroAddress();
381 
382     /**
383      * The quantity of tokens minted must be more than zero.
384      */
385     error MintZeroQuantity();
386 
387     /**
388      * The token does not exist.
389      */
390     error OwnerQueryForNonexistentToken();
391 
392     /**
393      * The caller must own the token or be an approved operator.
394      */
395     error TransferCallerNotOwnerNorApproved();
396 
397     /**
398      * The token must be owned by `from`.
399      */
400     error TransferFromIncorrectOwner();
401 
402     /**
403      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
404      */
405     error TransferToNonERC721ReceiverImplementer();
406 
407     /**
408      * Cannot transfer to the zero address.
409      */
410     error TransferToZeroAddress();
411 
412     /**
413      * The token does not exist.
414      */
415     error URIQueryForNonexistentToken();
416 
417     struct TokenOwnership {
418         // The address of the owner.
419         address addr;
420         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
421         uint64 startTimestamp;
422         // Whether the token has been burned.
423         bool burned;
424     }
425 
426     /**
427      * @dev Returns the total amount of tokens stored by the contract.
428      *
429      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
430      */
431     function totalSupply() external view returns (uint256);
432 
433     // ==============================
434     //            IERC165
435     // ==============================
436 
437     /**
438      * @dev Returns true if this contract implements the interface defined by
439      * `interfaceId`. See the corresponding
440      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
441      * to learn more about how these ids are created.
442      *
443      * This function call must use less than 30 000 gas.
444      */
445     function supportsInterface(bytes4 interfaceId) external view returns (bool);
446 
447     // ==============================
448     //            IERC721
449     // ==============================
450 
451     /**
452      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
453      */
454     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
455 
456     /**
457      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
458      */
459     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
460 
461     /**
462      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
463      */
464     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
465 
466     /**
467      * @dev Returns the number of tokens in ``owner``'s account.
468      */
469     function balanceOf(address owner) external view returns (uint256 balance);
470 
471     /**
472      * @dev Returns the owner of the `tokenId` token.
473      *
474      * Requirements:
475      *
476      * - `tokenId` must exist.
477      */
478     function ownerOf(uint256 tokenId) external view returns (address owner);
479 
480     /**
481      * @dev Safely transfers `tokenId` token from `from` to `to`.
482      *
483      * Requirements:
484      *
485      * - `from` cannot be the zero address.
486      * - `to` cannot be the zero address.
487      * - `tokenId` token must exist and be owned by `from`.
488      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
489      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
490      *
491      * Emits a {Transfer} event.
492      */
493     function safeTransferFrom(
494         address from,
495         address to,
496         uint256 tokenId,
497         bytes calldata data
498     ) external;
499 
500     /**
501      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
502      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
503      *
504      * Requirements:
505      *
506      * - `from` cannot be the zero address.
507      * - `to` cannot be the zero address.
508      * - `tokenId` token must exist and be owned by `from`.
509      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
510      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
511      *
512      * Emits a {Transfer} event.
513      */
514     function safeTransferFrom(
515         address from,
516         address to,
517         uint256 tokenId
518     ) external;
519 
520     /**
521      * @dev Transfers `tokenId` token from `from` to `to`.
522      *
523      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
524      *
525      * Requirements:
526      *
527      * - `from` cannot be the zero address.
528      * - `to` cannot be the zero address.
529      * - `tokenId` token must be owned by `from`.
530      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
531      *
532      * Emits a {Transfer} event.
533      */
534     function transferFrom(
535         address from,
536         address to,
537         uint256 tokenId
538     ) external;
539 
540     /**
541      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
542      * The approval is cleared when the token is transferred.
543      *
544      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
545      *
546      * Requirements:
547      *
548      * - The caller must own the token or be an approved operator.
549      * - `tokenId` must exist.
550      *
551      * Emits an {Approval} event.
552      */
553     function approve(address to, uint256 tokenId) external;
554 
555     /**
556      * @dev Approve or remove `operator` as an operator for the caller.
557      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
558      *
559      * Requirements:
560      *
561      * - The `operator` cannot be the caller.
562      *
563      * Emits an {ApprovalForAll} event.
564      */
565     function setApprovalForAll(address operator, bool _approved) external;
566 
567     /**
568      * @dev Returns the account approved for `tokenId` token.
569      *
570      * Requirements:
571      *
572      * - `tokenId` must exist.
573      */
574     function getApproved(uint256 tokenId) external view returns (address operator);
575 
576     /**
577      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
578      *
579      * See {setApprovalForAll}
580      */
581     function isApprovedForAll(address owner, address operator) external view returns (bool);
582 
583     // ==============================
584     //        IERC721Metadata
585     // ==============================
586 
587     /**
588      * @dev Returns the token collection name.
589      */
590     function name() external view returns (string memory);
591 
592     /**
593      * @dev Returns the token collection symbol.
594      */
595     function symbol() external view returns (string memory);
596 
597     /**
598      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
599      */
600     function tokenURI(uint256 tokenId) external view returns (string memory);
601 }
602 
603 // File: erc721a/contracts/ERC721A.sol
604 
605 
606 // ERC721A Contracts v4.0.0
607 // Creator: Chiru Labs
608 
609 pragma solidity ^0.8.4;
610 
611 
612 /**
613  * @dev ERC721 token receiver interface.
614  */
615 interface ERC721A__IERC721Receiver {
616     function onERC721Received(
617         address operator,
618         address from,
619         uint256 tokenId,
620         bytes calldata data
621     ) external returns (bytes4);
622 }
623 
624 /**
625  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
626  * the Metadata extension. Built to optimize for lower gas during batch mints.
627  *
628  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
629  *
630  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
631  *
632  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
633  */
634 contract ERC721A is IERC721A {
635     // Mask of an entry in packed address data.
636     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
637 
638     // The bit position of `numberMinted` in packed address data.
639     uint256 private constant BITPOS_NUMBER_MINTED = 64;
640 
641     // The bit position of `numberBurned` in packed address data.
642     uint256 private constant BITPOS_NUMBER_BURNED = 128;
643 
644     // The bit position of `aux` in packed address data.
645     uint256 private constant BITPOS_AUX = 192;
646 
647     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
648     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
649 
650     // The bit position of `startTimestamp` in packed ownership.
651     uint256 private constant BITPOS_START_TIMESTAMP = 160;
652 
653     // The bit mask of the `burned` bit in packed ownership.
654     uint256 private constant BITMASK_BURNED = 1 << 224;
655     
656     // The bit position of the `nextInitialized` bit in packed ownership.
657     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
658 
659     // The bit mask of the `nextInitialized` bit in packed ownership.
660     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
661 
662     // The tokenId of the next token to be minted.
663     uint256 private _currentIndex;
664 
665     // The number of tokens burned.
666     uint256 private _burnCounter;
667 
668     // Token name
669     string private _name;
670 
671     // Token symbol
672     string private _symbol;
673 
674     // Mapping from token ID to ownership details
675     // An empty struct value does not necessarily mean the token is unowned.
676     // See `_packedOwnershipOf` implementation for details.
677     //
678     // Bits Layout:
679     // - [0..159]   `addr`
680     // - [160..223] `startTimestamp`
681     // - [224]      `burned`
682     // - [225]      `nextInitialized`
683     mapping(uint256 => uint256) private _packedOwnerships;
684 
685     // Mapping owner address to address data.
686     //
687     // Bits Layout:
688     // - [0..63]    `balance`
689     // - [64..127]  `numberMinted`
690     // - [128..191] `numberBurned`
691     // - [192..255] `aux`
692     mapping(address => uint256) private _packedAddressData;
693 
694     // Mapping from token ID to approved address.
695     mapping(uint256 => address) private _tokenApprovals;
696 
697     // Mapping from owner to operator approvals
698     mapping(address => mapping(address => bool)) private _operatorApprovals;
699 
700     constructor(string memory name_, string memory symbol_) {
701         _name = name_;
702         _symbol = symbol_;
703         _currentIndex = _startTokenId();
704     }
705 
706     /**
707      * @dev Returns the starting token ID. 
708      * To change the starting token ID, please override this function.
709      */
710     function _startTokenId() internal view virtual returns (uint256) {
711         return 0;
712     }
713 
714     /**
715      * @dev Returns the next token ID to be minted.
716      */
717     function _nextTokenId() internal view returns (uint256) {
718         return _currentIndex;
719     }
720 
721     /**
722      * @dev Returns the total number of tokens in existence.
723      * Burned tokens will reduce the count. 
724      * To get the total number of tokens minted, please see `_totalMinted`.
725      */
726     function totalSupply() public view override returns (uint256) {
727         // Counter underflow is impossible as _burnCounter cannot be incremented
728         // more than `_currentIndex - _startTokenId()` times.
729         unchecked {
730             return _currentIndex - _burnCounter - _startTokenId();
731         }
732     }
733 
734     /**
735      * @dev Returns the total amount of tokens minted in the contract.
736      */
737     function _totalMinted() internal view returns (uint256) {
738         // Counter underflow is impossible as _currentIndex does not decrement,
739         // and it is initialized to `_startTokenId()`
740         unchecked {
741             return _currentIndex - _startTokenId();
742         }
743     }
744 
745     /**
746      * @dev Returns the total number of tokens burned.
747      */
748     function _totalBurned() internal view returns (uint256) {
749         return _burnCounter;
750     }
751 
752     /**
753      * @dev See {IERC165-supportsInterface}.
754      */
755     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
756         // The interface IDs are constants representing the first 4 bytes of the XOR of
757         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
758         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
759         return
760             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
761             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
762             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
763     }
764 
765     /**
766      * @dev See {IERC721-balanceOf}.
767      */
768     function balanceOf(address owner) public view override returns (uint256) {
769         if (owner == address(0)) revert BalanceQueryForZeroAddress();
770         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
771     }
772 
773     /**
774      * Returns the number of tokens minted by `owner`.
775      */
776     function _numberMinted(address owner) internal view returns (uint256) {
777         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
778     }
779 
780     /**
781      * Returns the number of tokens burned by or on behalf of `owner`.
782      */
783     function _numberBurned(address owner) internal view returns (uint256) {
784         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
785     }
786 
787     /**
788      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
789      */
790     function _getAux(address owner) internal view returns (uint64) {
791         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
792     }
793 
794     /**
795      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
796      * If there are multiple variables, please pack them into a uint64.
797      */
798     function _setAux(address owner, uint64 aux) internal {
799         uint256 packed = _packedAddressData[owner];
800         uint256 auxCasted;
801         assembly { // Cast aux without masking.
802             auxCasted := aux
803         }
804         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
805         _packedAddressData[owner] = packed;
806     }
807 
808     /**
809      * Returns the packed ownership data of `tokenId`.
810      */
811     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
812         uint256 curr = tokenId;
813 
814         unchecked {
815             if (_startTokenId() <= curr)
816                 if (curr < _currentIndex) {
817                     uint256 packed = _packedOwnerships[curr];
818                     // If not burned.
819                     if (packed & BITMASK_BURNED == 0) {
820                         // Invariant:
821                         // There will always be an ownership that has an address and is not burned
822                         // before an ownership that does not have an address and is not burned.
823                         // Hence, curr will not underflow.
824                         //
825                         // We can directly compare the packed value.
826                         // If the address is zero, packed is zero.
827                         while (packed == 0) {
828                             packed = _packedOwnerships[--curr];
829                         }
830                         return packed;
831                     }
832                 }
833         }
834         revert OwnerQueryForNonexistentToken();
835     }
836 
837     /**
838      * Returns the unpacked `TokenOwnership` struct from `packed`.
839      */
840     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
841         ownership.addr = address(uint160(packed));
842         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
843         ownership.burned = packed & BITMASK_BURNED != 0;
844     }
845 
846     /**
847      * Returns the unpacked `TokenOwnership` struct at `index`.
848      */
849     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
850         return _unpackedOwnership(_packedOwnerships[index]);
851     }
852 
853     /**
854      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
855      */
856     function _initializeOwnershipAt(uint256 index) internal {
857         if (_packedOwnerships[index] == 0) {
858             _packedOwnerships[index] = _packedOwnershipOf(index);
859         }
860     }
861 
862     /**
863      * Gas spent here starts off proportional to the maximum mint batch size.
864      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
865      */
866     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
867         return _unpackedOwnership(_packedOwnershipOf(tokenId));
868     }
869 
870     /**
871      * @dev See {IERC721-ownerOf}.
872      */
873     function ownerOf(uint256 tokenId) public view override returns (address) {
874         return address(uint160(_packedOwnershipOf(tokenId)));
875     }
876 
877     /**
878      * @dev See {IERC721Metadata-name}.
879      */
880     function name() public view virtual override returns (string memory) {
881         return _name;
882     }
883 
884     /**
885      * @dev See {IERC721Metadata-symbol}.
886      */
887     function symbol() public view virtual override returns (string memory) {
888         return _symbol;
889     }
890 
891     /**
892      * @dev See {IERC721Metadata-tokenURI}.
893      */
894     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
895         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
896 
897         string memory baseURI = _baseURI();
898         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
899     }
900 
901     /**
902      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
903      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
904      * by default, can be overriden in child contracts.
905      */
906     function _baseURI() internal view virtual returns (string memory) {
907         return '';
908     }
909 
910     /**
911      * @dev Casts the address to uint256 without masking.
912      */
913     function _addressToUint256(address value) private pure returns (uint256 result) {
914         assembly {
915             result := value
916         }
917     }
918 
919     /**
920      * @dev Casts the boolean to uint256 without branching.
921      */
922     function _boolToUint256(bool value) private pure returns (uint256 result) {
923         assembly {
924             result := value
925         }
926     }
927 
928     /**
929      * @dev See {IERC721-approve}.
930      */
931     function approve(address to, uint256 tokenId) public override {
932         address owner = address(uint160(_packedOwnershipOf(tokenId)));
933         if (to == owner) revert ApprovalToCurrentOwner();
934 
935         if (_msgSenderERC721A() != owner)
936             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
937                 revert ApprovalCallerNotOwnerNorApproved();
938             }
939 
940         _tokenApprovals[tokenId] = to;
941         emit Approval(owner, to, tokenId);
942     }
943 
944     /**
945      * @dev See {IERC721-getApproved}.
946      */
947     function getApproved(uint256 tokenId) public view override returns (address) {
948         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
949 
950         return _tokenApprovals[tokenId];
951     }
952 
953     /**
954      * @dev See {IERC721-setApprovalForAll}.
955      */
956     function setApprovalForAll(address operator, bool approved) public virtual override {
957         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
958 
959         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
960         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
961     }
962 
963     /**
964      * @dev See {IERC721-isApprovedForAll}.
965      */
966     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
967         return _operatorApprovals[owner][operator];
968     }
969 
970     /**
971      * @dev See {IERC721-transferFrom}.
972      */
973     function transferFrom(
974         address from,
975         address to,
976         uint256 tokenId
977     ) public virtual override {
978         _transfer(from, to, tokenId);
979     }
980 
981     /**
982      * @dev See {IERC721-safeTransferFrom}.
983      */
984     function safeTransferFrom(
985         address from,
986         address to,
987         uint256 tokenId
988     ) public virtual override {
989         safeTransferFrom(from, to, tokenId, '');
990     }
991 
992     /**
993      * @dev See {IERC721-safeTransferFrom}.
994      */
995     function safeTransferFrom(
996         address from,
997         address to,
998         uint256 tokenId,
999         bytes memory _data
1000     ) public virtual override {
1001         _transfer(from, to, tokenId);
1002         if (to.code.length != 0)
1003             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1004                 revert TransferToNonERC721ReceiverImplementer();
1005             }
1006     }
1007 
1008     /**
1009      * @dev Returns whether `tokenId` exists.
1010      *
1011      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1012      *
1013      * Tokens start existing when they are minted (`_mint`),
1014      */
1015     function _exists(uint256 tokenId) internal view returns (bool) {
1016         return
1017             _startTokenId() <= tokenId &&
1018             tokenId < _currentIndex && // If within bounds,
1019             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1020     }
1021 
1022     /**
1023      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1024      */
1025     function _safeMint(address to, uint256 quantity) internal {
1026         _safeMint(to, quantity, '');
1027     }
1028 
1029     /**
1030      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1031      *
1032      * Requirements:
1033      *
1034      * - If `to` refers to a smart contract, it must implement
1035      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1036      * - `quantity` must be greater than 0.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function _safeMint(
1041         address to,
1042         uint256 quantity,
1043         bytes memory _data
1044     ) internal {
1045         uint256 startTokenId = _currentIndex;
1046         if (to == address(0)) revert MintToZeroAddress();
1047         if (quantity == 0) revert MintZeroQuantity();
1048 
1049         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1050 
1051         // Overflows are incredibly unrealistic.
1052         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1053         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1054         unchecked {
1055             // Updates:
1056             // - `balance += quantity`.
1057             // - `numberMinted += quantity`.
1058             //
1059             // We can directly add to the balance and number minted.
1060             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1061 
1062             // Updates:
1063             // - `address` to the owner.
1064             // - `startTimestamp` to the timestamp of minting.
1065             // - `burned` to `false`.
1066             // - `nextInitialized` to `quantity == 1`.
1067             _packedOwnerships[startTokenId] =
1068                 _addressToUint256(to) |
1069                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1070                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1071 
1072             uint256 updatedIndex = startTokenId;
1073             uint256 end = updatedIndex + quantity;
1074 
1075             if (to.code.length != 0) {
1076                 do {
1077                     emit Transfer(address(0), to, updatedIndex);
1078                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1079                         revert TransferToNonERC721ReceiverImplementer();
1080                     }
1081                 } while (updatedIndex < end);
1082                 // Reentrancy protection
1083                 if (_currentIndex != startTokenId) revert();
1084             } else {
1085                 do {
1086                     emit Transfer(address(0), to, updatedIndex++);
1087                 } while (updatedIndex < end);
1088             }
1089             _currentIndex = updatedIndex;
1090         }
1091         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1092     }
1093 
1094     /**
1095      * @dev Mints `quantity` tokens and transfers them to `to`.
1096      *
1097      * Requirements:
1098      *
1099      * - `to` cannot be the zero address.
1100      * - `quantity` must be greater than 0.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _mint(address to, uint256 quantity) internal {
1105         uint256 startTokenId = _currentIndex;
1106         if (to == address(0)) revert MintToZeroAddress();
1107         if (quantity == 0) revert MintZeroQuantity();
1108 
1109         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1110 
1111         // Overflows are incredibly unrealistic.
1112         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1113         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1114         unchecked {
1115             // Updates:
1116             // - `balance += quantity`.
1117             // - `numberMinted += quantity`.
1118             //
1119             // We can directly add to the balance and number minted.
1120             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1121 
1122             // Updates:
1123             // - `address` to the owner.
1124             // - `startTimestamp` to the timestamp of minting.
1125             // - `burned` to `false`.
1126             // - `nextInitialized` to `quantity == 1`.
1127             _packedOwnerships[startTokenId] =
1128                 _addressToUint256(to) |
1129                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1130                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1131 
1132             uint256 updatedIndex = startTokenId;
1133             uint256 end = updatedIndex + quantity;
1134 
1135             do {
1136                 emit Transfer(address(0), to, updatedIndex++);
1137             } while (updatedIndex < end);
1138 
1139             _currentIndex = updatedIndex;
1140         }
1141         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1142     }
1143 
1144     /**
1145      * @dev Transfers `tokenId` from `from` to `to`.
1146      *
1147      * Requirements:
1148      *
1149      * - `to` cannot be the zero address.
1150      * - `tokenId` token must be owned by `from`.
1151      *
1152      * Emits a {Transfer} event.
1153      */
1154     function _transfer(
1155         address from,
1156         address to,
1157         uint256 tokenId
1158     ) private {
1159         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1160 
1161         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1162 
1163         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1164             isApprovedForAll(from, _msgSenderERC721A()) ||
1165             getApproved(tokenId) == _msgSenderERC721A());
1166 
1167         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1168         if (to == address(0)) revert TransferToZeroAddress();
1169 
1170         _beforeTokenTransfers(from, to, tokenId, 1);
1171 
1172         // Clear approvals from the previous owner.
1173         delete _tokenApprovals[tokenId];
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
1188             _packedOwnerships[tokenId] =
1189                 _addressToUint256(to) |
1190                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1191                 BITMASK_NEXT_INITIALIZED;
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
1233         if (approvalCheck) {
1234             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1235                 isApprovedForAll(from, _msgSenderERC721A()) ||
1236                 getApproved(tokenId) == _msgSenderERC721A());
1237 
1238             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1239         }
1240 
1241         _beforeTokenTransfers(from, address(0), tokenId, 1);
1242 
1243         // Clear approvals from the previous owner.
1244         delete _tokenApprovals[tokenId];
1245 
1246         // Underflow of the sender's balance is impossible because we check for
1247         // ownership above and the recipient's balance can't realistically overflow.
1248         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
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
1263             _packedOwnerships[tokenId] =
1264                 _addressToUint256(from) |
1265                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1266                 BITMASK_BURNED | 
1267                 BITMASK_NEXT_INITIALIZED;
1268 
1269             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1270             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1271                 uint256 nextTokenId = tokenId + 1;
1272                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1273                 if (_packedOwnerships[nextTokenId] == 0) {
1274                     // If the next slot is within bounds.
1275                     if (nextTokenId != _currentIndex) {
1276                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1277                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1278                     }
1279                 }
1280             }
1281         }
1282 
1283         emit Transfer(from, address(0), tokenId);
1284         _afterTokenTransfers(from, address(0), tokenId, 1);
1285 
1286         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1287         unchecked {
1288             _burnCounter++;
1289         }
1290     }
1291 
1292     /**
1293      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1294      *
1295      * @param from address representing the previous owner of the given token ID
1296      * @param to target address that will receive the tokens
1297      * @param tokenId uint256 ID of the token to be transferred
1298      * @param _data bytes optional data to send along with the call
1299      * @return bool whether the call correctly returned the expected magic value
1300      */
1301     function _checkContractOnERC721Received(
1302         address from,
1303         address to,
1304         uint256 tokenId,
1305         bytes memory _data
1306     ) private returns (bool) {
1307         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1308             bytes4 retval
1309         ) {
1310             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1311         } catch (bytes memory reason) {
1312             if (reason.length == 0) {
1313                 revert TransferToNonERC721ReceiverImplementer();
1314             } else {
1315                 assembly {
1316                     revert(add(32, reason), mload(reason))
1317                 }
1318             }
1319         }
1320     }
1321 
1322     /**
1323      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1324      * And also called before burning one token.
1325      *
1326      * startTokenId - the first token id to be transferred
1327      * quantity - the amount to be transferred
1328      *
1329      * Calling conditions:
1330      *
1331      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1332      * transferred to `to`.
1333      * - When `from` is zero, `tokenId` will be minted for `to`.
1334      * - When `to` is zero, `tokenId` will be burned by `from`.
1335      * - `from` and `to` are never both zero.
1336      */
1337     function _beforeTokenTransfers(
1338         address from,
1339         address to,
1340         uint256 startTokenId,
1341         uint256 quantity
1342     ) internal virtual {}
1343 
1344     /**
1345      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1346      * minting.
1347      * And also called after one token has been burned.
1348      *
1349      * startTokenId - the first token id to be transferred
1350      * quantity - the amount to be transferred
1351      *
1352      * Calling conditions:
1353      *
1354      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1355      * transferred to `to`.
1356      * - When `from` is zero, `tokenId` has been minted for `to`.
1357      * - When `to` is zero, `tokenId` has been burned by `from`.
1358      * - `from` and `to` are never both zero.
1359      */
1360     function _afterTokenTransfers(
1361         address from,
1362         address to,
1363         uint256 startTokenId,
1364         uint256 quantity
1365     ) internal virtual {}
1366 
1367     /**
1368      * @dev Returns the message sender (defaults to `msg.sender`).
1369      *
1370      * If you are writing GSN compatible contracts, you need to override this function.
1371      */
1372     function _msgSenderERC721A() internal view virtual returns (address) {
1373         return msg.sender;
1374     }
1375 
1376     /**
1377      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1378      */
1379     function _toString(uint256 value) internal pure returns (string memory ptr) {
1380         assembly {
1381             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1382             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1383             // We will need 1 32-byte word to store the length, 
1384             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1385             ptr := add(mload(0x40), 128)
1386             // Update the free memory pointer to allocate.
1387             mstore(0x40, ptr)
1388 
1389             // Cache the end of the memory to calculate the length later.
1390             let end := ptr
1391 
1392             // We write the string from the rightmost digit to the leftmost digit.
1393             // The following is essentially a do-while loop that also handles the zero case.
1394             // Costs a bit more than early returning for the zero case,
1395             // but cheaper in terms of deployment and overall runtime costs.
1396             for { 
1397                 // Initialize and perform the first pass without check.
1398                 let temp := value
1399                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1400                 ptr := sub(ptr, 1)
1401                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1402                 mstore8(ptr, add(48, mod(temp, 10)))
1403                 temp := div(temp, 10)
1404             } temp { 
1405                 // Keep dividing `temp` until zero.
1406                 temp := div(temp, 10)
1407             } { // Body of the for loop.
1408                 ptr := sub(ptr, 1)
1409                 mstore8(ptr, add(48, mod(temp, 10)))
1410             }
1411             
1412             let length := sub(end, ptr)
1413             // Move the pointer 32 bytes leftwards to make room for the length.
1414             ptr := sub(ptr, 32)
1415             // Store the length.
1416             mstore(ptr, length)
1417         }
1418     }
1419 }
1420 
1421 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1422 
1423 
1424 // ERC721A Contracts v4.0.0
1425 // Creator: Chiru Labs
1426 
1427 pragma solidity ^0.8.4;
1428 
1429 
1430 /**
1431  * @dev Interface of an ERC721AQueryable compliant contract.
1432  */
1433 interface IERC721AQueryable is IERC721A {
1434     /**
1435      * Invalid query range (`start` >= `stop`).
1436      */
1437     error InvalidQueryRange();
1438 
1439     /**
1440      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1441      *
1442      * If the `tokenId` is out of bounds:
1443      *   - `addr` = `address(0)`
1444      *   - `startTimestamp` = `0`
1445      *   - `burned` = `false`
1446      *
1447      * If the `tokenId` is burned:
1448      *   - `addr` = `<Address of owner before token was burned>`
1449      *   - `startTimestamp` = `<Timestamp when token was burned>`
1450      *   - `burned = `true`
1451      *
1452      * Otherwise:
1453      *   - `addr` = `<Address of owner>`
1454      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1455      *   - `burned = `false`
1456      */
1457     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1458 
1459     /**
1460      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1461      * See {ERC721AQueryable-explicitOwnershipOf}
1462      */
1463     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1464 
1465     /**
1466      * @dev Returns an array of token IDs owned by `owner`,
1467      * in the range [`start`, `stop`)
1468      * (i.e. `start <= tokenId < stop`).
1469      *
1470      * This function allows for tokens to be queried if the collection
1471      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1472      *
1473      * Requirements:
1474      *
1475      * - `start` < `stop`
1476      */
1477     function tokensOfOwnerIn(
1478         address owner,
1479         uint256 start,
1480         uint256 stop
1481     ) external view returns (uint256[] memory);
1482 
1483     /**
1484      * @dev Returns an array of token IDs owned by `owner`.
1485      *
1486      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1487      * It is meant to be called off-chain.
1488      *
1489      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1490      * multiple smaller scans if the collection is large enough to cause
1491      * an out-of-gas error (10K pfp collections should be fine).
1492      */
1493     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1494 }
1495 
1496 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1497 
1498 
1499 // ERC721A Contracts v4.0.0
1500 // Creator: Chiru Labs
1501 
1502 pragma solidity ^0.8.4;
1503 
1504 
1505 
1506 /**
1507  * @title ERC721A Queryable
1508  * @dev ERC721A subclass with convenience query functions.
1509  */
1510 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1511     /**
1512      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1513      *
1514      * If the `tokenId` is out of bounds:
1515      *   - `addr` = `address(0)`
1516      *   - `startTimestamp` = `0`
1517      *   - `burned` = `false`
1518      *
1519      * If the `tokenId` is burned:
1520      *   - `addr` = `<Address of owner before token was burned>`
1521      *   - `startTimestamp` = `<Timestamp when token was burned>`
1522      *   - `burned = `true`
1523      *
1524      * Otherwise:
1525      *   - `addr` = `<Address of owner>`
1526      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1527      *   - `burned = `false`
1528      */
1529     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1530         TokenOwnership memory ownership;
1531         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1532             return ownership;
1533         }
1534         ownership = _ownershipAt(tokenId);
1535         if (ownership.burned) {
1536             return ownership;
1537         }
1538         return _ownershipOf(tokenId);
1539     }
1540 
1541     /**
1542      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1543      * See {ERC721AQueryable-explicitOwnershipOf}
1544      */
1545     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1546         unchecked {
1547             uint256 tokenIdsLength = tokenIds.length;
1548             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1549             for (uint256 i; i != tokenIdsLength; ++i) {
1550                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1551             }
1552             return ownerships;
1553         }
1554     }
1555 
1556     /**
1557      * @dev Returns an array of token IDs owned by `owner`,
1558      * in the range [`start`, `stop`)
1559      * (i.e. `start <= tokenId < stop`).
1560      *
1561      * This function allows for tokens to be queried if the collection
1562      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1563      *
1564      * Requirements:
1565      *
1566      * - `start` < `stop`
1567      */
1568     function tokensOfOwnerIn(
1569         address owner,
1570         uint256 start,
1571         uint256 stop
1572     ) external view override returns (uint256[] memory) {
1573         unchecked {
1574             if (start >= stop) revert InvalidQueryRange();
1575             uint256 tokenIdsIdx;
1576             uint256 stopLimit = _nextTokenId();
1577             // Set `start = max(start, _startTokenId())`.
1578             if (start < _startTokenId()) {
1579                 start = _startTokenId();
1580             }
1581             // Set `stop = min(stop, stopLimit)`.
1582             if (stop > stopLimit) {
1583                 stop = stopLimit;
1584             }
1585             uint256 tokenIdsMaxLength = balanceOf(owner);
1586             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1587             // to cater for cases where `balanceOf(owner)` is too big.
1588             if (start < stop) {
1589                 uint256 rangeLength = stop - start;
1590                 if (rangeLength < tokenIdsMaxLength) {
1591                     tokenIdsMaxLength = rangeLength;
1592                 }
1593             } else {
1594                 tokenIdsMaxLength = 0;
1595             }
1596             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1597             if (tokenIdsMaxLength == 0) {
1598                 return tokenIds;
1599             }
1600             // We need to call `explicitOwnershipOf(start)`,
1601             // because the slot at `start` may not be initialized.
1602             TokenOwnership memory ownership = explicitOwnershipOf(start);
1603             address currOwnershipAddr;
1604             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1605             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1606             if (!ownership.burned) {
1607                 currOwnershipAddr = ownership.addr;
1608             }
1609             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1610                 ownership = _ownershipAt(i);
1611                 if (ownership.burned) {
1612                     continue;
1613                 }
1614                 if (ownership.addr != address(0)) {
1615                     currOwnershipAddr = ownership.addr;
1616                 }
1617                 if (currOwnershipAddr == owner) {
1618                     tokenIds[tokenIdsIdx++] = i;
1619                 }
1620             }
1621             // Downsize the array to fit.
1622             assembly {
1623                 mstore(tokenIds, tokenIdsIdx)
1624             }
1625             return tokenIds;
1626         }
1627     }
1628 
1629     /**
1630      * @dev Returns an array of token IDs owned by `owner`.
1631      *
1632      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1633      * It is meant to be called off-chain.
1634      *
1635      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1636      * multiple smaller scans if the collection is large enough to cause
1637      * an out-of-gas error (10K pfp collections should be fine).
1638      */
1639     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1640         unchecked {
1641             uint256 tokenIdsIdx;
1642             address currOwnershipAddr;
1643             uint256 tokenIdsLength = balanceOf(owner);
1644             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1645             TokenOwnership memory ownership;
1646             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1647                 ownership = _ownershipAt(i);
1648                 if (ownership.burned) {
1649                     continue;
1650                 }
1651                 if (ownership.addr != address(0)) {
1652                     currOwnershipAddr = ownership.addr;
1653                 }
1654                 if (currOwnershipAddr == owner) {
1655                     tokenIds[tokenIdsIdx++] = i;
1656                 }
1657             }
1658             return tokenIds;
1659         }
1660     }
1661 }
1662 
1663 // File: contracts/FluffyFucksReborn.sol
1664 
1665 
1666 
1667 pragma solidity >=0.7.0 <0.9.0;
1668 
1669 
1670 
1671 
1672 contract FluffyFucksReborn is ERC721AQueryable, Ownable {
1673   using Strings for uint256;
1674 
1675   string public uriPrefix = ""; //http://www.site.com/data/
1676   string public uriSuffix = ".json";
1677 
1678   string public _contractURI = "";
1679 
1680   uint256 public maxSupply = 6061;
1681 
1682   bool public paused = false;
1683 
1684   constructor() ERC721A("Fluffy Fucks", "FFXv2") {
1685   }
1686 
1687   function _startTokenId()
1688         internal
1689         pure
1690         override
1691         returns(uint256)
1692     {
1693         return 1;
1694     }
1695 
1696   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1697     require(!paused, "The contract is paused!");
1698     require(totalSupply() + _mintAmount < maxSupply, "Max supply exceeded!");
1699     _safeMint(_receiver, _mintAmount);
1700   }
1701 
1702   function mintForAddressMultiple(address[] calldata addresses, uint256[] calldata amount) public onlyOwner
1703   {
1704     require(!paused, "The contract is paused!");
1705     require(addresses.length == amount.length, "Address and amount length mismatch");
1706 
1707     for (uint256 i; i < addresses.length; ++i)
1708     {
1709       _safeMint(addresses[i], amount[i]);
1710     }
1711 
1712     require(totalSupply() < maxSupply, "Max supply exceeded!");
1713   }
1714 
1715   function tokenURI(uint256 _tokenId)
1716     public
1717     view
1718     virtual
1719     override (ERC721A, IERC721A)
1720     returns (string memory)
1721   {
1722     require(
1723       _exists(_tokenId),
1724       "ERC721Metadata: URI query for nonexistent token"
1725     );
1726 
1727     string memory currentBaseURI = _baseURI();
1728     return bytes(currentBaseURI).length > 0
1729         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1730         : "";
1731   }
1732 
1733   function contractURI()
1734   public
1735   view
1736   returns (string memory)
1737   {
1738         return bytes(_contractURI).length > 0
1739           ? string(abi.encodePacked(_contractURI))
1740           : "";
1741   }
1742 
1743   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1744     uriPrefix = _uriPrefix;
1745   }
1746 
1747   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1748     uriSuffix = _uriSuffix;
1749   }
1750 
1751   function setContractURI(string memory newContractURI) public onlyOwner {
1752     _contractURI = newContractURI;
1753   }
1754 
1755   function setPaused(bool _state) public onlyOwner {
1756     paused = _state;
1757   }
1758 
1759   function withdraw() public onlyOwner {
1760     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1761     require(os);
1762   }
1763 
1764   function _baseURI() internal view virtual override returns (string memory) {
1765     return uriPrefix;
1766   }
1767 
1768 }
1769 
1770 // File: contracts/FluffyStaker.sol
1771 
1772 
1773 pragma solidity >=0.8.0 <0.9.0;
1774 
1775 
1776 
1777 
1778 contract FluffyStaker is IERC721Receiver, ReentrancyGuard {
1779     address public ownerAddress;
1780     bool public active = true;
1781 
1782     mapping(uint256 => address) staked;
1783 
1784     FluffyFucksReborn public ffxr;
1785 
1786     constructor()
1787     {
1788         ownerAddress = msg.sender;
1789     }
1790 
1791     fallback() external payable nonReentrant 
1792     {
1793         revert();
1794     }
1795     receive() external payable nonReentrant 
1796     {
1797         revert();
1798     }
1799 
1800     /**
1801      * on token received
1802      */
1803     function onERC721Received
1804     (
1805         address /*operator*/,
1806         address from, 
1807         uint256 tokenId, 
1808         bytes calldata /*data*/
1809     ) 
1810         public
1811         override
1812         onlyFromFluffyContract(msg.sender)
1813         returns(bytes4) 
1814     {
1815         staked[tokenId] = from;
1816         return IERC721Receiver.onERC721Received.selector;
1817     }
1818 
1819     /**
1820      * ADMIN ONLY
1821     */
1822 
1823     function setFluffyAddress(address contractAddress)
1824         public
1825         onlyOwner
1826     {
1827         ffxr = FluffyFucksReborn(contractAddress);
1828     }
1829 
1830     function restoreOddball(uint256 tokenId, address restoreTo)
1831         public
1832         onlyOwner
1833     {
1834         require(staked[tokenId] == address(0x0), "Token has a known owner.");
1835         ffxr.safeTransferFrom(address(this), restoreTo, tokenId);
1836     }
1837 
1838     function forceUnstake(uint256 tokenId)
1839         public
1840         onlyOwner
1841     {
1842         _forceUnstake(tokenId);
1843     }
1844 
1845     function forceUnstakeBatch(uint256[] calldata tokenIds)
1846         public
1847         onlyOwner
1848     {
1849         for(uint256 i = 0; i < tokenIds.length; ++i) {
1850             _forceUnstake(tokenIds[i]);
1851         }
1852     }
1853 
1854     function forceUnstakeAll()
1855         public
1856         onlyOwner
1857     {
1858         uint256[] memory tokens = ffxr.tokensOfOwner(address(this));
1859         for(uint256 i = 0; i < tokens.length; ++i) {
1860             _forceUnstake(tokens[i]);
1861         }
1862     }
1863 
1864     function _forceUnstake(uint256 tokenId)
1865         private
1866         onlyOwner
1867     {
1868         if(staked[tokenId] != address(0x0)) {
1869             ffxr.safeTransferFrom(address(this), staked[tokenId], tokenId);
1870             staked[tokenId] = address(0x0);
1871         }
1872     }
1873 
1874     function toggleActive(bool setTo) 
1875         public
1876         onlyOwner
1877     {
1878         active = setTo;
1879     }
1880 
1881     /**
1882      * LOOKUPS
1883      */
1884 
1885     function tokenStaker(uint256 tokenId) 
1886         public 
1887         view
1888         returns(address) 
1889     {
1890         return staked[tokenId];
1891     }
1892 
1893     function tokenStakers(uint256[] calldata tokenIds)
1894         public
1895         view
1896         returns(address[] memory)
1897     {
1898         address[] memory stakers = new address[](tokenIds.length);
1899         for(uint256 i = 0; i < tokenIds.length; ++i) {
1900             stakers[i] = staked[tokenIds[i]];
1901         }
1902         return stakers;
1903     }
1904 
1905     function allTokenStakers()
1906         isFluffyContractSet
1907         public 
1908         view
1909         returns (uint256[] memory, address[] memory)
1910     {
1911         uint256[] memory tokens = ffxr.tokensOfOwner(address(this));
1912 
1913         uint256[] memory stakedTokens;
1914         address[] memory stakers;
1915         
1916         uint256 count = 0;
1917         for(uint256 i = 0; i < tokens.length; ++i) {
1918             if (staked[tokens[i]] != address(0x0)) {
1919                 ++count;
1920             }
1921         }
1922 
1923         stakedTokens = new uint256[](count);
1924         stakers = new address[](count);
1925         count = 0;
1926 
1927         for(uint256 i = 0; i < tokens.length; ++i) {
1928             stakedTokens[count] = tokens[i];
1929             stakers[count] = staked[tokens[i]];
1930             count++;
1931         }
1932 
1933         return (stakedTokens, stakers);
1934     }
1935 
1936     function totalStaked()
1937         isFluffyContractSet
1938         public
1939         view
1940         returns (uint256 count)
1941     {
1942         uint256[] memory tokens = ffxr.tokensOfOwner(address(this));
1943         count = 0;
1944         for (uint256 i = 0; i < tokens.length; i++) {
1945             if (staked[tokens[i]] != address(0x0)) {
1946                 ++count;
1947             }
1948         }
1949     }
1950 
1951     function tokensStakedByAddress(address ogOwner)
1952         public
1953         view
1954         returns(uint256[] memory tokenIds)
1955     {
1956         uint256[] memory tokens = ffxr.tokensOfOwner(address(this));
1957         uint256 owned = 0;
1958         for (uint256 i = 0; i < tokens.length; ++i) {
1959             if (ogOwner == staked[tokens[i]]) {
1960                 ++owned;
1961             }
1962         }
1963 
1964         tokenIds = new uint256[](owned);
1965         owned = 0;
1966         for (uint256 i = 0; i < tokens.length; ++i) {
1967             if (ogOwner == staked[tokens[i]]) {
1968                 tokenIds[owned] = tokens[i];
1969                 ++owned;
1970             }
1971         }
1972     }
1973 
1974     function isStakingEnabled()
1975         public
1976         view
1977         returns (bool)
1978     {
1979         return this.isStakingEnabled(msg.sender);
1980     }
1981 
1982     function isStakingEnabled(address send)
1983         public
1984         view
1985         returns (bool)
1986     {
1987         return ffxr.isApprovedForAll(send, address(this));
1988     }
1989 
1990     function oddballTokensThatShouldNotBeHere()
1991         public
1992         view
1993         returns (uint256[] memory tokenIds)
1994     {
1995         uint256 count = 0;
1996         uint256[] memory tokens = ffxr.tokensOfOwner(address(this));
1997         for(uint256 i = 0; i < tokens.length; ++i) {
1998             if (staked[tokens[i]] == address(0x0)) {
1999                 ++count;
2000             }
2001         }
2002 
2003         tokenIds = new uint256[](count);
2004         count = 0;
2005         for(uint256 i = 0; i < tokens.length; ++i) {
2006             if (staked[tokens[i]] == address(0x0)) {
2007                 tokenIds[count] = tokens[i];
2008                 ++count;
2009             }
2010         }
2011     }
2012 
2013     /**
2014      * STAKING
2015      */
2016 
2017     function stakeBatch(uint256[] calldata tokenIds)
2018         isStakingActive
2019         isApproved(msg.sender)
2020         external
2021     {
2022         for (uint256 i = 0; i < tokenIds.length; ++i) {
2023             _stake(tokenIds[i]);
2024         }
2025     }
2026 
2027     function stake(uint256 tokenId)
2028         isStakingActive
2029         isApproved(msg.sender)
2030         external
2031     {
2032         _stake(tokenId);
2033     }
2034 
2035     function _stake(uint256 tokenId)
2036         isFluffyContractSet
2037         private
2038     {
2039         ffxr.safeTransferFrom(msg.sender, address(this), tokenId);
2040     }
2041 
2042     /**
2043      * UNSTAKING
2044      */
2045 
2046     function unstakeBatch(uint256[] calldata tokenIds)
2047         external
2048     {
2049         for (uint256 i = 0; i < tokenIds.length; ++i) {
2050             _unstake(tokenIds[i]);
2051         }
2052     }
2053 
2054     function unstake(uint256 tokenId)
2055         external
2056     {
2057         _unstake(tokenId);
2058     }
2059 
2060     function _unstake(uint256 tokenId)
2061         isFluffyContractSet
2062         onlyOriginalTokenOwner(tokenId)
2063         private
2064     {
2065         ffxr.safeTransferFrom(address(this), staked[tokenId], tokenId);
2066         staked[tokenId] = address(0x0);
2067     }
2068 
2069     /**
2070      * MODIFIERS
2071      */
2072     modifier onlyOriginalTokenOwner(uint256 tokenId)
2073     {
2074         require(msg.sender == staked[tokenId], "You are not tokens original owner");
2075         _;
2076     }
2077 
2078     modifier onlyOwner()
2079     {
2080         require(msg.sender == ownerAddress, "You are not owner.");
2081         _;
2082     }
2083 
2084     modifier onlyFromFluffyContract(address sentFromAddress)
2085     {
2086         require(sentFromAddress == address(ffxr), "Not sent from Fluffy contract.");
2087         _;
2088     }
2089 
2090     modifier isFluffyContractSet()
2091     {
2092         require(address(ffxr) != address(0x0), "Fluffy address is not set");
2093         _;
2094     }
2095 
2096     modifier isApproved(address send)
2097     {
2098         require(this.isStakingEnabled(send), "You have not approved FluffyStaker.");
2099         _;
2100     }
2101 
2102     modifier isStakingActive()
2103     {
2104         require(active, "Staking is not active.");
2105         _;
2106     }
2107 }
2108 // File: contracts/FluffyNextGen.sol
2109 
2110 /**
2111  * SPDX-License-Identifier: UNLICENSED
2112  */
2113 
2114 pragma solidity >=0.8.0 <0.9.0;
2115 
2116 
2117 
2118 
2119 
2120 
2121 
2122 
2123 contract FluffyNextGen is ERC721AQueryable, Ownable, ReentrancyGuard
2124 {
2125     FluffyFucksReborn public ffxr;
2126     bool public paused = true;
2127     bool public holderWlMintOpen = false;
2128     bool public publicMintOpen = false;
2129     uint256 public supply = 1212;
2130     uint256 public teamSupply = 30;
2131     uint256 public defaultMaxPerWallet = 5;
2132     uint256 public price = 0.0069 ether;
2133     bytes32 public merkleRoot;
2134     
2135     string private contractMetadataUrl;
2136     string private tokenMetadataUrlRoot;
2137     mapping(address => uint256) private addressHasMinted;
2138     mapping(address => uint256) private stakerHasMintedFree;
2139 
2140     mapping(address => uint256) private stakerSnapshot;
2141 
2142     /**
2143      * CONSTRUCTOR
2144      */
2145 
2146     constructor () ERC721A("FluffyFucks Koalas", "FFXg2.0")
2147     {
2148         deploySnapshot();
2149     }
2150 
2151     /**
2152      * MINTING
2153      */
2154 
2155     // team mint
2156     function teamMint(uint256 _quantity)
2157         public
2158         onlyOwner
2159         nonReentrant
2160         supplyExists(_quantity)
2161     {
2162         require(addressHasMinted[msg.sender] + _quantity <= teamSupply);
2163         _safeMint(msg.sender, _quantity);
2164         addressHasMinted[msg.sender] += _quantity;
2165     }
2166 
2167     // mint
2168     function mint(
2169         uint256 _quantity,
2170         uint256 _freeMints,
2171         bytes32[] calldata _proof
2172     )
2173         public
2174         payable
2175         isMintingOpen
2176         nonReentrant
2177         supplyExists(_quantity + _freeMints)
2178     {
2179         require(_quantity + _freeMints > 0, "No point minting nothing.");
2180 
2181         // checking if person is an active staker
2182         if(stakerSnapshot[msg.sender] > 0) {
2183             return stakerMint(stakerSnapshot[msg.sender], msg.sender, _quantity, _freeMints, msg.value);
2184         }
2185 
2186         require(_quantity > 0, "No point minting no fluffs.");
2187 
2188         // checking if person is an active holder
2189         uint256 balance = ffxr.balanceOf(msg.sender);
2190         if (balance > 0) {
2191             return holderMint(msg.sender, _quantity, msg.value);
2192         }
2193 
2194         // checking if person is whitelisted
2195         if (isAddressWhitelisted(msg.sender, _proof)) {
2196             return whitelistMint(msg.sender, _quantity, msg.value);
2197         }
2198 
2199         // defaulting to public mint
2200         return publicMint(msg.sender, _quantity, msg.value);
2201     }
2202 
2203     // staker mint
2204     function stakerMint(uint256 _numberStaked, address _minter, uint256 _quantity, uint256 _freeMints, uint256 _payment)
2205         private
2206         hasFunds(_quantity, _payment)
2207     {
2208         (uint256 maxFreeMints, uint256 maxMinted) = howManyCanStakerMint(_numberStaked);
2209         require(_freeMints + stakerHasMintedFree[_minter] <= maxFreeMints, "You cannot mint this many free mints.");
2210         require(_quantity + _freeMints + addressHasMinted[_minter] <= maxMinted, "You cannot mint this many fluffs.");
2211         _safeMint(_minter, _quantity + _freeMints);
2212         addressHasMinted[_minter] += _quantity + _freeMints;
2213         stakerHasMintedFree[_minter] += _freeMints;
2214     }
2215 
2216     // whitelist mint
2217     function whitelistMint(address _minter, uint256 _quantity, uint256 _payment)
2218         private
2219         isHolderWlMintOpen
2220         hasFunds(_quantity, _payment)
2221         canMintAmount(_minter, _quantity)
2222     {
2223         _safeMint(_minter, _quantity);
2224         addressHasMinted[_minter] += _quantity;
2225     }
2226 
2227     // holder mint
2228     function holderMint(address _minter, uint256 _quantity, uint256 _payment)
2229         private
2230         isHolderWlMintOpen
2231         hasFunds(_quantity, _payment)
2232         canMintAmount(_minter, _quantity)
2233     {
2234         _safeMint(_minter, _quantity);
2235         addressHasMinted[_minter] += _quantity;
2236     }
2237 
2238     // public mint
2239     function publicMint(address _minter, uint256 _quantity, uint256 _payment)
2240         private
2241         isPublicMintOpen
2242         hasFunds(_quantity, _payment)
2243         canMintAmount(_minter, _quantity)
2244     {
2245         _safeMint(_minter, _quantity);
2246         addressHasMinted[_minter] += _quantity;
2247     }
2248 
2249     /**
2250      * GETTERS AND SETTERS
2251      */
2252 
2253     function setPaused(bool _paused) 
2254         public
2255         onlyOwner
2256     {
2257         paused = _paused;
2258     }
2259 
2260     function setPublicMintOpen(bool _publicOpen)
2261         public
2262         onlyOwner
2263     {
2264         publicMintOpen = _publicOpen;
2265     }
2266 
2267     function setHolderWlMintOpen(bool _holdWlOpen)
2268         public
2269         onlyOwner
2270     {
2271         holderWlMintOpen = _holdWlOpen;
2272     }
2273 
2274     function setFluffyContract(address _contract)
2275         public
2276         onlyOwner
2277     {
2278         ffxr = FluffyFucksReborn(_contract);
2279     }
2280 
2281     function setMerkleRoot(bytes32 _merkle)
2282         public
2283         onlyOwner
2284     {
2285         merkleRoot = _merkle;
2286     }
2287 
2288     function setContractMetadataUrl(string calldata _metadataUrl)
2289         public
2290         onlyOwner
2291     {
2292         contractMetadataUrl = _metadataUrl;
2293     }
2294 
2295     function setTokenMetadataUrlRoot(string calldata _tokenMetadataRoot)
2296         public
2297         onlyOwner
2298     {
2299         tokenMetadataUrlRoot = _tokenMetadataRoot;
2300     }
2301 
2302     /**
2303      * VIEWS
2304      */
2305 
2306     function howManyCanSomeoneMint(address _minter)
2307         public
2308         view
2309         returns(uint256 freeMints, uint256 maxMints)
2310     {
2311         if(stakerSnapshot[_minter] > 1) {
2312             (freeMints, maxMints) = howManyCanStakerMint(stakerSnapshot[_minter]);
2313             return (
2314                 freeMints - stakerHasMintedFree[_minter],
2315                 maxMints - addressHasMinted[_minter]
2316             );
2317         } else {
2318             return (0, defaultMaxPerWallet - addressHasMinted[_minter]);
2319         }
2320     }
2321 
2322     function howManyCanStakerMint(uint256 _staked)
2323         public
2324         pure
2325         returns(uint256 freeMints, uint256 maxMints)
2326     {
2327         if (_staked == 0) {
2328             // 0 staked
2329             return (0, 0);
2330         } else if (_staked == 1) {
2331             // 1 staked
2332             return (0, 5);
2333         } else if (_staked < 10) {
2334             // less than 10
2335             return (_staked / 2, 5);
2336         } else if (_staked < 20) {
2337             // less than 20
2338             return (_staked / 2, 10);
2339         } else if (_staked < 40) {
2340             // less than 40
2341             return (10, 20);
2342         } else if (_staked < 69) {
2343             // less than 69
2344             return (20, 40);
2345         } else {
2346             // 69 or more
2347             return (35, 69);
2348         }
2349     }
2350 
2351     function isAddressWhitelisted(address _minter, bytes32[] calldata _proof)
2352         private
2353         view
2354         returns(bool)
2355     {
2356         return MerkleProof.verify(_proof, merkleRoot, keccak256(abi.encodePacked(_minter)));
2357     }
2358 
2359     /**
2360      * MODIFIERS
2361      */
2362 
2363     modifier isMintingOpen()
2364     {
2365         require(paused == false, "Minting is not active.");
2366         _;
2367     }
2368 
2369     modifier isPublicMintOpen()
2370     {
2371         require(publicMintOpen, "Public mint is not open.");
2372         _;
2373     }
2374 
2375     modifier isHolderWlMintOpen()
2376     {
2377         require(holderWlMintOpen, "Holder and Whitelist mint is not open.");
2378         _;
2379     }
2380 
2381     modifier supplyExists(uint256 _quantity)
2382     {
2383         require(_totalMinted() + _quantity <= supply, "This would exceed minting supply.");
2384         _;
2385     }
2386 
2387     modifier hasFunds(uint256 _quantity, uint256 _payment)
2388     {
2389         require(_quantity * price <= _payment, "You do not have enough money to mint.");
2390         _;
2391     }
2392 
2393     modifier canMintAmount(address _minter, uint256 _quantity)
2394     {
2395         require(addressHasMinted[_minter] + _quantity <= defaultMaxPerWallet, "You cannot mint this many");
2396         _;
2397     }
2398 
2399     /**
2400      * CONTRACT STUFF
2401      */
2402 
2403     function _startTokenId()
2404         internal
2405         pure
2406         override
2407         returns(uint256)
2408     {
2409         return 1;
2410     }
2411 
2412     function withdraw() 
2413         public 
2414         onlyOwner 
2415         nonReentrant
2416     {
2417         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2418         require(os);
2419     }
2420 
2421         function contractURI()
2422         public
2423         view
2424         returns(string memory)
2425     {
2426         return contractMetadataUrl;
2427     }
2428 
2429     /**
2430      * @dev See {IERC721Metadata-tokenURI}.
2431      */
2432     function tokenURI(uint256 tokenId)
2433         public
2434         view
2435         virtual
2436         override(ERC721A, IERC721A)
2437         returns (string memory)
2438     {
2439         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2440 
2441         string memory baseURI = _baseURI();
2442         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json")) : "";
2443     }
2444 
2445     function _baseURI()
2446         internal
2447         view
2448         override
2449         returns (string memory)
2450     {
2451         return tokenMetadataUrlRoot;
2452     }
2453 
2454     /**
2455      * SNAPSHOT
2456      */
2457     function deploySnapshot()
2458         private
2459     {
2460         stakerSnapshot[0x0066A1C2137Ee60fEc2ac1f51E26DCd78Ae0f42d] = 6;
2461         stakerSnapshot[0x0071e278144a040EE373331d1c3d9e6fD3BB7339] = 2;
2462         stakerSnapshot[0x01850e6686a222edc136f11C93D824cDa433e364] = 4;
2463         stakerSnapshot[0x0287E8dfC37544995fb75af20fdaB57c74f4860D] = 2;
2464         stakerSnapshot[0x045e6833Fa2B7BBd1a6cfc3CC2630A6e20Ff9E87] = 6;
2465         stakerSnapshot[0x06E5D82B5A8dF0435CE8046bc15290594bC0c710] = 2;
2466         stakerSnapshot[0x07035d0e0cFb5e89218be943507694526A4EBE54] = 4;
2467         stakerSnapshot[0x074DB7F6c8dbD545e53411795B182529f494779A] = 2;
2468         stakerSnapshot[0x08132a6899DdcfD77bAA15990D96f6645a9390da] = 2;
2469         stakerSnapshot[0x08834D1ac96cb6D533C5a742511C759EE83B0d61] = 8;
2470         stakerSnapshot[0x08e6c66Ce1fdEE6004a63B06cA0Ff324b8aa5826] = 2;
2471         stakerSnapshot[0x090459ae119b904A0808568E763A4f5556B49FE0] = 2;
2472         stakerSnapshot[0x0945BE11418b180Ec8DfE0447a9bE1c15FB1BeaD] = 2;
2473         stakerSnapshot[0x09Cb303EcAba558422d63B7392d095C7ffE37D36] = 2;
2474         stakerSnapshot[0x0aAB45d1B9C821EBfd03a77117c12355e8739c85] = 13;
2475         stakerSnapshot[0x0bC8801f28baf3F5cEbA2bC3f0Cdfcaf37C2846e] = 6;
2476         stakerSnapshot[0x0bE9F7f7a5d1e19311989bbE307c4796A534d6E8] = 4;
2477         stakerSnapshot[0x0c4DB5ECb43303d925EDa8F11Fe592D59d3C6cC3] = 7;
2478         stakerSnapshot[0x0C645D0c6Ec9ec7DDe5BB8f5E655e11775f44277] = 2;
2479         stakerSnapshot[0x0d47A223Fd09C174184131a9a539562b4a026E57] = 4;
2480         stakerSnapshot[0x0dd201E9243320cb0651AcdCb134e086f4582645] = 2;
2481         stakerSnapshot[0x0DfAb02678695f56E9373aA072A59fbDA5938a49] = 2;
2482         stakerSnapshot[0x0E96cC0F0001Ab39659d48050d5e5A4361330a4B] = 2;
2483         stakerSnapshot[0x1059650DC09681949F7686974F61D95c2135B091] = 2;
2484         stakerSnapshot[0x105c9EF0a0531a3B1B692508EFe7994880d942B7] = 4;
2485         stakerSnapshot[0x106aBAfcD4C1F615eBF14EFDD7e52EDFb33217aB] = 2;
2486         stakerSnapshot[0x134aed007F8935746749Ab25bD3CE88231BF555a] = 2;
2487         stakerSnapshot[0x139734BaAd745912286B55cE07a6D113C19A9AD9] = 2;
2488         stakerSnapshot[0x142875238256444be2243b01CBe613B0Fac3f64E] = 2;
2489         stakerSnapshot[0x14573a0484D8639e024264e0159905AC1eB9B453] = 2;
2490         stakerSnapshot[0x15384d0578CFcBA6C9E29777599871c8E0878513] = 4;
2491         stakerSnapshot[0x167f12fEFB578f29bEd2585e84ae6C5A72fF21Cd] = 2;
2492         stakerSnapshot[0x169eB0789887fedA30DcBD91b4002089A98Ab241] = 2;
2493         stakerSnapshot[0x190237dcED5114bD6c482772ce20faD0Be407b4A] = 6;
2494         stakerSnapshot[0x1a2f95a9dc750b581632C567a2d7B96650D6e019] = 6;
2495         stakerSnapshot[0x1Ba3a102D292e988E8eE55d30ad98e5B4BdA32dc] = 2;
2496         stakerSnapshot[0x1E50CA5bfc75d6B4af207503E3A6D4A4c5ec05cd] = 4;
2497         stakerSnapshot[0x205BBBE1b5EE65efFe19c5DD59b84AD1413BBB77] = 4;
2498         stakerSnapshot[0x2129bCA7cA8B37956ec24c5b7411fd5424370DBF] = 15;
2499         stakerSnapshot[0x2245Ec2b9773e5B6A457F883c3183374Fe4D0864] = 4;
2500         stakerSnapshot[0x23f3c4dD6297A36A2140d5478188D9e773D3Ac9E] = 2;
2501         stakerSnapshot[0x252723A88a9c2279E998D4eD363DB120553C715C] = 5;
2502         stakerSnapshot[0x252d74d7d69f5cC3Bb2Cd2fdbE3b37DC1F1edC2f] = 4;
2503         stakerSnapshot[0x2581F074fDA1454a2869862D61429Dd5871cE4DA] = 2;
2504         stakerSnapshot[0x25A1Cfac8c9eADAB7c12FB59d54144593Aa96436] = 4;
2505         stakerSnapshot[0x2735B84B6AfB1328EA7809ce212589C5175D71Fb] = 2;
2506         stakerSnapshot[0x2760F7d38377AcF2Fc26c08915B4669eBeE1420A] = 4;
2507         stakerSnapshot[0x27f0A1677a3185d360ac5985f3BbC766ca34b00E] = 14;
2508         stakerSnapshot[0x29adfe4efD359939322493eD8B386d45877E7749] = 8;
2509         stakerSnapshot[0x2A9a201B97305F52E3771ACDbFbaDc015fbD155F] = 2;
2510         stakerSnapshot[0x2b604baEe38Fd5d9eF2b236e4d8462C27A66aD5d] = 2;
2511         stakerSnapshot[0x2bEcCB8975aEee773b03a3CB29a81304D5AC6122] = 2;
2512         stakerSnapshot[0x2c82C2B69d7B56EE7f475d1320e362e87b51Ae4d] = 6;
2513         stakerSnapshot[0x2FE38f5092E76b27e278bf2417e2a56375bB6b8B] = 8;
2514         stakerSnapshot[0x3020136b9958642cf8E3972E06DB21F3884DF56A] = 2;
2515         stakerSnapshot[0x31aBDFd780A044b034270862F46853d1e34Dd6aE] = 2;
2516         stakerSnapshot[0x31B685C06590d72c67609C2d940C41C79966D2E3] = 6;
2517         stakerSnapshot[0x31e4662AAE7529E0A95BeD463c48d8B398cfAB73] = 12;
2518         stakerSnapshot[0x34A0c4799a177a95EA6611aEbf377639f551eaa3] = 33;
2519         stakerSnapshot[0x3578234C0FD2d531E84eEc84CAbf64FF5B246c30] = 2;
2520         stakerSnapshot[0x3609840fb53EBEa9F39c2c97e4A39438a825a89e] = 20;
2521         stakerSnapshot[0x36214d560aaa853d5c0853920FFe27779803419D] = 7;
2522         stakerSnapshot[0x362DC61A04cb099aB6b912DB07e0D6270342f16D] = 25;
2523         stakerSnapshot[0x3765A89463A19D5c2413544808Cb8b537Ac406eF] = 2;
2524         stakerSnapshot[0x37FFe79d00C8c33E3f9622ac940e46BFa56d70a7] = 5;
2525         stakerSnapshot[0x39E121297240Ac7F72E7487D799a0fC06422e216] = 2;
2526         stakerSnapshot[0x3A410941d1A1f9d6d09a2F479Be991C237DD2A68] = 2;
2527         stakerSnapshot[0x3a95e5407E32A1CC7f6923F3297aF09D2279bBDC] = 2;
2528         stakerSnapshot[0x3Aa17002F448bee09284dDe391A595E51DCd8c39] = 5;
2529         stakerSnapshot[0x3cbE9F5d49a2b92FA49cc01B4547C0860Bae4f99] = 2;
2530         stakerSnapshot[0x3ccc9E75E6C63fcb68E30B81A3bc3209dB09A9f9] = 8;
2531         stakerSnapshot[0x3d5A925EeD67A613778d7Ad9254aB75241348EBc] = 6;
2532         stakerSnapshot[0x3E311f18653300f9441aC0D886DFF51e1278aAEB] = 3;
2533         stakerSnapshot[0x3E6D9477BA6b136bAb6FA4BE2E40373de2eC704F] = 2;
2534         stakerSnapshot[0x3ec6d18f4A52dd8dBCb013eE920f935738C6223C] = 79;
2535         stakerSnapshot[0x3eC8A6f383Fdda0A21996b4233946717f9EacB26] = 2;
2536         stakerSnapshot[0x3eddd4CC257564889Ba377f5Fdb9e827e9503F96] = 2;
2537         stakerSnapshot[0x3Ff0df7EC6Ab47725272691a030c22a59bc87B1D] = 2;
2538         stakerSnapshot[0x419D36f006Ba8933fFb99B5BC8d189505c0836d3] = 2;
2539         stakerSnapshot[0x42B83becC570F4e2D9b40544d59984541Aa52168] = 2;
2540         stakerSnapshot[0x433eE230C45Fd079E60CF5d428b76Caa0055558c] = 22;
2541         stakerSnapshot[0x434eD1DecDE9dCB0ca6c9E5c29C95D22f085400F] = 1;
2542         stakerSnapshot[0x4526E96ceDb7A4F570944c37A544B0E44b946ea4] = 69;
2543         stakerSnapshot[0x46A8E8B740292775F036da3Bd279f1994864bf53] = 2;
2544         stakerSnapshot[0x46bE8E0a5e919E1A174978636B6be161b21E2f1A] = 6;
2545         stakerSnapshot[0x47e44738be0732119E0687EaA3BC18F5c8e58399] = 2;
2546         stakerSnapshot[0x47F740c1Ea213A267B483640c1C3aEC8B262f25e] = 26;
2547         stakerSnapshot[0x48ec7Fe34E0C7843133c0e7571c2f17AB8C7bf32] = 4;
2548         stakerSnapshot[0x49a15aD9eCa0d7aDc9dABe42869DFc304C26FD53] = 2;
2549         stakerSnapshot[0x4aC3728c8C2CCAAf89784ea9C9Ae886A9a30B56c] = 6;
2550         stakerSnapshot[0x4ae0e898A9E0deE985E7f35F5630e2eDe0cD6216] = 4;
2551         stakerSnapshot[0x4bf1fF6D70a2ECe1cBA5Bb18FDC2444f3D40Aa1d] = 2;
2552         stakerSnapshot[0x4C0aCA1031913e3C0cA7A1147F39A8588E04c55d] = 2;
2553         stakerSnapshot[0x4C981C345e9047524f793e8b5E15f2089320842b] = 2;
2554         stakerSnapshot[0x4Ce8BDc18e257dB9ea29D11E290DfbA99431dDd9] = 7;
2555         stakerSnapshot[0x4F4567044DE8f48A70e9e17Bd80fFA3F8e80C836] = 4;
2556         stakerSnapshot[0x4f56215bFB5E76fA6849Ae3FdEf417C19cD9AA23] = 4;
2557         stakerSnapshot[0x4F94eE0B6d2a31cb9BeFEEF2d95bF19F3a63E7Dd] = 4;
2558         stakerSnapshot[0x535FF5ACFeE41Fd02F01667dDd25772D8f8A231D] = 1;
2559         stakerSnapshot[0x53965cd7992BC61b4807Aa7aCe3Bec0062c90dE2] = 2;
2560         stakerSnapshot[0x542B659331442eAcFE2EF1a135F31aF1c107FE3A] = 4;
2561         stakerSnapshot[0x5615bCb489147674E6bceb3Cda97342B654aBA81] = 3;
2562         stakerSnapshot[0x5709D86f9946D93a2e1c6b2B6C15D6e25F37B19B] = 3;
2563         stakerSnapshot[0x57140a5EC315C7193DeFA29356B1cBd9a1393435] = 7;
2564         stakerSnapshot[0x575543b79Ab9913FA322295e322B08ef6C023a88] = 2;
2565         stakerSnapshot[0x5758bc7DcBcb32E6eBDa8Fe951E5a588e8a7A097] = 2;
2566         stakerSnapshot[0x578D7d391B4F34E35B4ca669F6a1dC18c04bB451] = 2;
2567         stakerSnapshot[0x581ddECBf2E27a06A069D67Fc7fb185eFB3c3d5f] = 3;
2568         stakerSnapshot[0x584a1d14920A49C8d19110636A2b435670CAf367] = 1;
2569         stakerSnapshot[0x5970F4d785A81b774D58330f47cD470fc3599848] = 3;
2570         stakerSnapshot[0x59b8130B9b1Aa6313776649B17326AA668f7b7a6] = 6;
2571         stakerSnapshot[0x5A512866D6E2a5d34BcdA0C4a28e207D2a310B60] = 2;
2572         stakerSnapshot[0x5C55F7eD0CDfE0928b19CA0B076C26F98080a136] = 2;
2573         stakerSnapshot[0x5Da07C2959C9815FEcEaC21FD7547C7E684c2431] = 2;
2574         stakerSnapshot[0x5DF596aa9315cd8B56e5C1213762F5b482Cb8aDA] = 1;
2575         stakerSnapshot[0x5f5B53E9e65CEbDc9085A73B017451f79B9d0158] = 2;
2576         stakerSnapshot[0x5fa19516d4A9AB74B89CeBc4E739f9AbdF69d7Bd] = 4;
2577         stakerSnapshot[0x5FDC2E1c58308289d8dD719Db2f952258e28ec96] = 1;
2578         stakerSnapshot[0x600cFB1736626C03dF54964ef481861eD092A7a0] = 2;
2579         stakerSnapshot[0x60cF1FCb21F08E538B16B0579009EF35107fDd53] = 1;
2580         stakerSnapshot[0x612E900a95Cd662D6c7434ECcCaA92C5CDf05F25] = 12;
2581         stakerSnapshot[0x61D7f4Dd8b5D8E9416fE8Fd81224171cAA32112b] = 2;
2582         stakerSnapshot[0x62e0C4336370184873224EC5ebeE4B6567d5602d] = 2;
2583         stakerSnapshot[0x62E725f096666Ef2f05fF3AAF4d0b042b3Eef5B8] = 7;
2584         stakerSnapshot[0x63E80354A787f7C876eb3C862BC93e36fCC1F310] = 4;
2585         stakerSnapshot[0x64Bc737b1A030aaC323c073f11939DB7b9e8F347] = 10;
2586         stakerSnapshot[0x6576082983708D32418d7abe400E2Df4360aa550] = 1;
2587         stakerSnapshot[0x657C61B33779B526BBbd6d5A24D82a569717dCeE] = 3;
2588         stakerSnapshot[0x668ca185c3cDfA625115b0A5b0d35BCDADfe0327] = 81;
2589         stakerSnapshot[0x6868B90BA68E48b3571928A7727201B9efE1D374] = 30;
2590         stakerSnapshot[0x68E9D76F37bE57387CF6b9E1835b04CC957aa2E7] = 20;
2591         stakerSnapshot[0x695f28D97aDF81DE4C8081aEf62d16d7B60fD35B] = 10;
2592         stakerSnapshot[0x697Dc0e8A3b3e3758f59f32BE847b2290823dBC1] = 42;
2593         stakerSnapshot[0x698f345481Fc1007C5094D8495b01DF375E4E4a7] = 2;
2594         stakerSnapshot[0x69B2803c04fec9505113038E1F91257A337DF63e] = 2;
2595         stakerSnapshot[0x69fD02C1Cf7659D3D095c4Ce73B5d5C23886B5f6] = 3;
2596         stakerSnapshot[0x6b140e5a9F6B6967Af30F789414840E2FFe1bdE9] = 2;
2597         stakerSnapshot[0x6B703CbB3cA5FE26cA9054F95c808facD7B57bCA] = 2;
2598         stakerSnapshot[0x6bA9BAb89e215DA976776788630Bce75E331B87d] = 1;
2599         stakerSnapshot[0x6C719836105879783760EAef03A8E004482eD33C] = 7;
2600         stakerSnapshot[0x6C87622a5de8cf0B5E7d4Dd2e6d9EBedBBF6289C] = 6;
2601         stakerSnapshot[0x6c9E0941eD2Fe399bfdd30Afb91A89db3f719f78] = 20;
2602         stakerSnapshot[0x6D28439B6c5A022B8C50C1AA0b8a8dA4B416FA6f] = 1;
2603         stakerSnapshot[0x6F8a67326832E81F0c13c69EcC9Bec618F707526] = 6;
2604         stakerSnapshot[0x6F9fc508dC77FD4ABEa9d72c91E7133703a2F38F] = 20;
2605         stakerSnapshot[0x7270B7aC52ee19a1c07EFE24574B0360f9bCaa76] = 2;
2606         stakerSnapshot[0x72b113664DEC5094Efb4431C39Ed4da003De59cd] = 74;
2607         stakerSnapshot[0x7357f081E79760e157E6C4215a35ad0233260f66] = 1;
2608         stakerSnapshot[0x74F499133eD684dA42B83afb1592aEc92F48228a] = 2;
2609         stakerSnapshot[0x75f9406bb829b6ad1313dB7FFf421E1E959D010b] = 8;
2610         stakerSnapshot[0x76239D6b1D37E0058D89C06c21BE4A14C492b301] = 2;
2611         stakerSnapshot[0x76E8D76759Acd20220F17f0dCdeb5768Be535152] = 2;
2612         stakerSnapshot[0x76F8a5c06857b44E1D459671b00708c7502c7999] = 2;
2613         stakerSnapshot[0x7836989949554501AC5D021b7BaeF6c992f1B854] = 3;
2614         stakerSnapshot[0x798A7D6F30DCaa0c060c8514E461c005A0400458] = 2;
2615         stakerSnapshot[0x79adc74978a81EB68D11Ab69558b11BECDD88DeC] = 6;
2616         stakerSnapshot[0x79c837F954CaEae493FaA298B0e0DcF0d5BAb20d] = 2;
2617         stakerSnapshot[0x7A0AB4A019f5B9626db6590F02d07f8Ee504Ae8A] = 2;
2618         stakerSnapshot[0x7a600C045eF72CE5483f7E76d4Fe5bEfFCdEE6aC] = 7;
2619         stakerSnapshot[0x7A60A3f8377a202E31d9Ff70A9Ebaee6c60D8db8] = 2;
2620         stakerSnapshot[0x7a6651c84D768c8c6cB380B229e65590c0BD4D78] = 13;
2621         stakerSnapshot[0x7b9D9cD877784D19A0977Aedb9f8697Bf7aaad9E] = 2;
2622         stakerSnapshot[0x7C68f66C70836c9745AC42a5Ab2A5C3f8F3D3294] = 2;
2623         stakerSnapshot[0x7CdA50Bed220eA0860d60095B27Ee4F744511bb9] = 1;
2624         stakerSnapshot[0x7D198D4643DB60Fd6E772470B03A079e920EcC19] = 31;
2625         stakerSnapshot[0x7E5F3d3C54B4185b3430005E2354817331F23550] = 3;
2626         stakerSnapshot[0x7Efbcb80C47514a78Cdf167f8D0eed3d8a1D7a00] = 6;
2627         stakerSnapshot[0x812005457367912B4FcCf527a13b4947d177E8c6] = 1;
2628         stakerSnapshot[0x816F81C3fA8368CDB1EaaD755ca50c62fdA9b60D] = 3;
2629         stakerSnapshot[0x82023a7bf582E1C772a1BcD749e10C0AFD7aB04E] = 2;
2630         stakerSnapshot[0x824189a4C3bc22089bC771b5c9D60131Fd1252a7] = 20;
2631         stakerSnapshot[0x82e928D20c021cAbBd150E7335f751F71A30cBcA] = 2;
2632         stakerSnapshot[0x83A9e7FCCb02a20E7ba0803a6dc74600803BB320] = 8;
2633         stakerSnapshot[0x849f03ACc35C6F4A861b76e1F271d217CD24b18C] = 2;
2634         stakerSnapshot[0x854C162aA246Ffe344262FC1175B6F064dB7250E] = 20;
2635         stakerSnapshot[0x870Bf9b18227aa0d28C0f21689A21931aA4FE3DE] = 2;
2636         stakerSnapshot[0x87cF0dd1272a6827df5659758859a96De9837EC5] = 8;
2637         stakerSnapshot[0x8902B48123201dBBadC20c40B1005C5Ad6250cc5] = 6;
2638         stakerSnapshot[0x89B91536A411D97837163987f3a33C15C5599479] = 2;
2639         stakerSnapshot[0x89d687021563f1A62DCD3AcaDDc64feF948F8fcb] = 40;
2640         stakerSnapshot[0x8a4892a38196d4A284e585eBC5D1545E5085583a] = 2;
2641         stakerSnapshot[0x8C2Bf3a4504888b0DE9688AEccf38a905DcEC940] = 4;
2642         stakerSnapshot[0x8c2Db300315DcB15e0A8869eA94F843E218a78B4] = 4;
2643         stakerSnapshot[0x8C409C76690F16a0C520EF4ECECBB8ad71017480] = 20;
2644         stakerSnapshot[0x8c7e78d32CB350D7B560372285610b5E46e67981] = 4;
2645         stakerSnapshot[0x8cCc7DA43DcbA6FEf07a318f88965e7aEEdB5eBc] = 12;
2646         stakerSnapshot[0x8D757F5675405271de9DDff392f7E7A717b5bddb] = 4;
2647         stakerSnapshot[0x8D98139512ac57459A468BC10ccf30Fd9dd6149A] = 12;
2648         stakerSnapshot[0x8f0CaCC1B3d0066A31Fc97c6CF1db1b0F56f073f] = 2;
2649         stakerSnapshot[0x8Fa3e7cb0c9C14FfBe750080A97ee678AD71a216] = 2;
2650         stakerSnapshot[0x8fd974089B612041C37eB643980C2A9C9BA85058] = 1;
2651         stakerSnapshot[0x9251af98d5649d1BC949f62E955095938897289d] = 2;
2652         stakerSnapshot[0x92aC315cb47B620F84238C57d3b3cc7F42078781] = 4;
2653         stakerSnapshot[0x92b398370dda6392cf5b239561aB1bD3ba393CB6] = 6;
2654         stakerSnapshot[0x92B99779Bc3471706A8f9Eb0F3975331e6664678] = 4;
2655         stakerSnapshot[0x93d751d48693AD3384C5021F821122bc4192B504] = 7;
2656         stakerSnapshot[0x945A81369C1bc7E73eb2D509AF1f7a067A253702] = 4;
2657         stakerSnapshot[0x95e3C7af64fFCDdA13630C7C10646775dc638275] = 27;
2658         stakerSnapshot[0x960A84baf0Ac4162a83D421CDB7a00Cc2777b22D] = 2;
2659         stakerSnapshot[0x964afBC4d4a80346861bB87dbC31a8610AE87fC4] = 4;
2660         stakerSnapshot[0x97111A057171E93aa7b2d63B4f6B5b7Bdc33EF8D] = 4;
2661         stakerSnapshot[0x995B7FABDae160217F378BbB05669Aa4bDcdc81f] = 1;
2662         stakerSnapshot[0x9B687413591Ad92cC1BC5cD5Fd442c04872D97DB] = 6;
2663         stakerSnapshot[0x9C9964733479a6E0758d97A7B89DcE81C20b19d7] = 1;
2664         stakerSnapshot[0x9e01852683b88D829551895C7BFd1799b121fdBC] = 4;
2665         stakerSnapshot[0x9f137fb2330e499607E1b1233dE2C1b90b1A7a85] = 4;
2666         stakerSnapshot[0x9FC7EdAC9dF5bCc75671EFF5A2c2898Fc4242636] = 22;
2667         stakerSnapshot[0x9Fe697f4d0D447409331681e0401a4f7E756fdD7] = 5;
2668         stakerSnapshot[0xA01D7E4e848467CBD2CA864150f27A9D286C86C8] = 9;
2669         stakerSnapshot[0xa07cb2c3861D34FA5686d52018dC401FF413F05D] = 7;
2670         stakerSnapshot[0xA0843Cf5DbEaf1EB3d7Cd31B372d6Cc06180b1Ab] = 2;
2671         stakerSnapshot[0xa0C737617b7E63e1CbF87C45c11cd766CF57Bd9D] = 2;
2672         stakerSnapshot[0xA1bE91b15E959294Cb6eFD7891c846cAf7ef7602] = 4;
2673         stakerSnapshot[0xa235Fbd83AD5B143bCd18719834C60BA7c925C52] = 2;
2674         stakerSnapshot[0xA2bff178071A266D14e360e3f3CE226B19D3F809] = 2;
2675         stakerSnapshot[0xa55F7eA2F6001DC6d046cFe799c3Ec4dC79cc5b8] = 3;
2676         stakerSnapshot[0xa62CBb35f5a51695F1cC550f3a8506Fc458D681D] = 2;
2677         stakerSnapshot[0xA6E3F06461A5d34fB3344FF6b45d6C92D207c35d] = 38;
2678         stakerSnapshot[0xa731325b4D01250Fe8852Fe76974F084d968e75D] = 20;
2679         stakerSnapshot[0xa784224c2F3c82c47abEda5D640e911633Cd24Da] = 4;
2680         stakerSnapshot[0xA8047DcE2A42968379E68870274ED2F534082Edd] = 3;
2681         stakerSnapshot[0xa8ad3C8D9039a0D10040d187C44336e57456fecE] = 2;
2682         stakerSnapshot[0xAa5B7f29C81B7409A021a2Bfe1E0FCec27EAD33E] = 2;
2683         stakerSnapshot[0xAaCDB53292F7703A608926799C9A02C9662923aa] = 4;
2684         stakerSnapshot[0xAb48De856930c018238c226D166Feaed3541Ec7d] = 1;
2685         stakerSnapshot[0xab516c4a5A0b705025a079814bDe84e846bCe019] = 20;
2686         stakerSnapshot[0xAb532bE7866818326D5A9cf86134eb0C2E95A8cE] = 2;
2687         stakerSnapshot[0xABa93498a69373b5E5f72254a513Bfaf77253d16] = 2;
2688         stakerSnapshot[0xACa79E56C92DeD769D2B773C8bab2aB552Ec5172] = 69;
2689         stakerSnapshot[0xAdc81042fEc23050b99EA6E08552a2bA439Df481] = 2;
2690         stakerSnapshot[0xaF9938ec47EbD29c93208f71f63d27b61E517522] = 20;
2691         stakerSnapshot[0xAfC9D3054f3047AA99347f4266a256BF2F6e12ca] = 2;
2692         stakerSnapshot[0xB0ea4466D71431E87B4c00fa2AECe86742e507b0] = 23;
2693         stakerSnapshot[0xb1ce4373890A21CC3Fd65480D72770496689a7Ba] = 20;
2694         stakerSnapshot[0xb1e2E3EA2A52Ee700403fc504429012FD733dD72] = 22;
2695         stakerSnapshot[0xB2A7CE5B1fAF0d1f4fF1a59fCa9D7ee24917FF81] = 4;
2696         stakerSnapshot[0xb37e6F4F7E3f74e447d860aAeB0E8783320c66bF] = 6;
2697         stakerSnapshot[0xb3C4fC3a65C2DF5d0f4e748BdC563bAB49d0399d] = 8;
2698         stakerSnapshot[0xB47832cA65E661b2b54dE39F24775C1d82C216f9] = 2;
2699         stakerSnapshot[0xb5048a3518C05F2dD51976e941047B54b0539ECD] = 2;
2700         stakerSnapshot[0xb5cA180081211730DD00d4fac6f4bEDF74e932Da] = 71;
2701         stakerSnapshot[0xB666A384e23da54C7DA222a2c3dE69a009Fae620] = 2;
2702         stakerSnapshot[0xB7Afe2297B5756B740193076e5CB2753aC582543] = 2;
2703         stakerSnapshot[0xB84404f79EbeF00233E1AEdB273c67c917B8840f] = 40;
2704         stakerSnapshot[0xB8545d529234eB2848C85c0CcC0a5Ce9B30a3C0b] = 6;
2705         stakerSnapshot[0xb87c4158b4A5766D67aA8591064bbe5126823514] = 2;
2706         stakerSnapshot[0xb908B613d695c350BF8b88007F3f2799b91f86c4] = 1;
2707         stakerSnapshot[0xBaB80520D514Df65B765A1f8990cc195559E6778] = 2;
2708         stakerSnapshot[0xBd50C7a6CF80A5221FCb798a7F3305A036303d2D] = 2;
2709         stakerSnapshot[0xBde69E440Bd3AbC059db71cE0bb75f31b92F37E1] = 2;
2710         stakerSnapshot[0xBE331A01056066311C9989437c58293AF56b59cA] = 4;
2711         stakerSnapshot[0xBe546e6a5CA1c2CfcB486Bb9de4baD98C88e7109] = 2;
2712         stakerSnapshot[0xBeaa9B4b26aEA31459dCA6E64e12A0b83e21A0dd] = 12;
2713         stakerSnapshot[0xBfEcB5bD1726Afa7095f924374f3cE5d6375F24A] = 2;
2714         stakerSnapshot[0xC25cea4227fA68348F025A8C09768378D338F8d6] = 2;
2715         stakerSnapshot[0xC261c472a5fea6f1002dA278d55D2D4463f000ef] = 4;
2716         stakerSnapshot[0xc3cf1A2962b750eb552C4A1A61259Fd35063e74e] = 2;
2717         stakerSnapshot[0xc42480b588Aff1B9f15Db3845fb74299195C8FCE] = 6;
2718         stakerSnapshot[0xC800391fDDcC6F899DCA185d5B16994B7D0CB13e] = 2;
2719         stakerSnapshot[0xcac8ca2C41b14304906c884DB9603A7B29D98Adb] = 5;
2720         stakerSnapshot[0xcB85e96ADE0D281eA3B5B8165cdC808b16Ac13b9] = 2;
2721         stakerSnapshot[0xcB91368B760f0d6F2160114b422A93aE50e44542] = 4;
2722         stakerSnapshot[0xcBa18510a6336F3975Cea1164B9C5d029E1A7C82] = 2;
2723         stakerSnapshot[0xCBc6C9CeF4f3C7cbBb8Eb82A2aD60c00e631A8C1] = 8;
2724         stakerSnapshot[0xcC507e6DDc3a6C992BC02019fbEeb8f81Be9FBb2] = 69;
2725         stakerSnapshot[0xcCE8A3fb91290071b377FE0EC3df0eb7ceA8AFFC] = 2;
2726         stakerSnapshot[0xcd1C78538E3Cc0D2ceadd87b8124357d86566365] = 3;
2727         stakerSnapshot[0xcE046B2a56fea1559dB99f7fB4e4570aaaFF9889] = 6;
2728         stakerSnapshot[0xce83bc7517B8435Eb08EB515Aa3f6c9386b1E2A0] = 6;
2729         stakerSnapshot[0xCF0268111e06d26e1B9ea813Fe49c40A4227778D] = 6;
2730         stakerSnapshot[0xCf7346Ba8d7D4D2A3A256b2FA00Daf5c7566351b] = 2;
2731         stakerSnapshot[0xd03a4E75A730eb5f700dfE71703CbaA99CB67532] = 6;
2732         stakerSnapshot[0xd054952345f497F7A9461a202E8f1284b885eE2F] = 6;
2733         stakerSnapshot[0xd2A41a1Aa5698f88f947b6ba9Ce4d3109623c223] = 2;
2734         stakerSnapshot[0xD4658C7c5b42cAd999b5b881305D60A72590f247] = 7;
2735         stakerSnapshot[0xd696d9f21f2bC4aE97d351E9C14Fa1928C886c61] = 2;
2736         stakerSnapshot[0xd69A21f89c463a96F9E916F84a7AA5ca8A9DD595] = 1;
2737         stakerSnapshot[0xd76A10B1916404eE78f48571c1a5Fa913aaAF72b] = 21;
2738         stakerSnapshot[0xD7d28e62b7221A82094292Ed59F1d9D86D32c39c] = 7;
2739         stakerSnapshot[0xD9AF96861dE6992b299e9aC004Aa4c68771d0815] = 2;
2740         stakerSnapshot[0xD9C925E7dB3c6F64c2b347107CAfDc75390A8744] = 4;
2741         stakerSnapshot[0xDafF72174cf270D194f79C4d5F1e1cDAb748fE14] = 6;
2742         stakerSnapshot[0xdb955C787Ea67964e1d47b752657C307283aE8c2] = 6;
2743         stakerSnapshot[0xDBbce16eDeE36909115d374a886aE0cD6be56EB6] = 2;
2744         stakerSnapshot[0xdc5B1B4A9730C4d980FE4e9d5E7355c501480d73] = 2;
2745         stakerSnapshot[0xDC6eB1077c9D84260b2c7a5b5F1926273Ae54578] = 2;
2746         stakerSnapshot[0xDD262F615BfAc068C640269E53A797C58410bAFc] = 42;
2747         stakerSnapshot[0xdDd1918AC0D873eb02feD2ac24251da75d983Fed] = 2;
2748         stakerSnapshot[0xE11D08e4EA85dc79d63020d99f02f659B17F36DB] = 3;
2749         stakerSnapshot[0xE18ff984BdDD7DbE2E1D83B6B4C5B8ab6BC7Daf6] = 2;
2750         stakerSnapshot[0xE2F7c36A7cFC5F54CfEA051900117695Cb3c6b2f] = 6;
2751         stakerSnapshot[0xe367B61Ab9bC05100fDA392fec1B6Ff2b226cF6E] = 23;
2752         stakerSnapshot[0xe54DEBc68b0676d8F800Aff820Dfe63E5C854091] = 2;
2753         stakerSnapshot[0xe5A923B2Db4b828Ab1592D10C53cfeA7080245B3] = 71;
2754         stakerSnapshot[0xE5b0e824DA704b77f5190895b17b990024a22A3E] = 2;
2755         stakerSnapshot[0xe66a52474370E0CbDa0F867da4D25471aA3C1615] = 9;
2756         stakerSnapshot[0xe717472C2683B6bca8688f030b9e0C65cFc52c99] = 2;
2757         stakerSnapshot[0xE7b770c6cf75325A6525E79A6Afae60888f3F498] = 2;
2758         stakerSnapshot[0xE8969399b899244291cE9AB2f175B3229Cd42ECd] = 6;
2759         stakerSnapshot[0xE9275ac6c2378c0Fb93C738fF55D54a80b3E2d8a] = 2;
2760         stakerSnapshot[0xe978aE285E6ca04Ef40Af882371A2E4A97cFC812] = 7;
2761         stakerSnapshot[0xEa02AB878834bA9551987CbA64B94C514DDe194F] = 2;
2762         stakerSnapshot[0xEA99a428D69aa84aD9a20D782Cde4a1e6c3E9017] = 6;
2763         stakerSnapshot[0xEa9f6ec11914703227A737A670c4Fc5A7b20CBFc] = 65;
2764         stakerSnapshot[0xECA576463eA8aFB5A21e0335f0c4F4e4a414156b] = 2;
2765         stakerSnapshot[0xeCBCeA720dAc9dCFaA7024B80DB92755b8836785] = 4;
2766         stakerSnapshot[0xeE2020eeD81905C8964A4B236B858A1A6eB5889e] = 2;
2767         stakerSnapshot[0xEf85AB7726Fb85CEf041F1e035AbD5e6844B660E] = 2;
2768         stakerSnapshot[0xeFeb821368e89336f7110390A12c98fF95794fa8] = 2;
2769         stakerSnapshot[0xF1595c576370A794d2Ef783624cd521d5C614b62] = 2;
2770         stakerSnapshot[0xF2557A90C56CbB18b1955237b212A0f86A834909] = 4;
2771         stakerSnapshot[0xf2cfA31187616a4669369CD64853D96739ef999C] = 7;
2772         stakerSnapshot[0xf39C00D5bCDF098bAB69385b56ee8140EeB105a1] = 2;
2773         stakerSnapshot[0xF3D47f776F035333Aaf3847eBB41EA8955a149F4] = 2;
2774         stakerSnapshot[0xf416526650C9596Ed5A5aAFEd2880A6b3f9daEfc] = 4;
2775         stakerSnapshot[0xF45bE2e48dFD057eB700653aDA23d95108928FEF] = 2;
2776         stakerSnapshot[0xF7f9eF971B6377493Da1CD7a7206F603f190CDa5] = 2;
2777         stakerSnapshot[0xF90A20105A8EE1C7cc00466ebcC72060887cc099] = 12;
2778         stakerSnapshot[0xf944f5715314af4D0c882A868599d7849AAC266F] = 6;
2779         stakerSnapshot[0xF98DA3CC07028722547Bb795ce57D96bEbA936bd] = 4;
2780         stakerSnapshot[0xfb5D7141feaCBBd6678fD37D58EE9D19e01Df8EE] = 2;
2781         stakerSnapshot[0xfBBAc3c308799E744C939eaB11449E3649C1e52D] = 20;
2782         stakerSnapshot[0xFCc36706699c5cB1C324681e826992969dbE0dBA] = 6;
2783         stakerSnapshot[0xfE3Cf487565A3Cd275cb2cbf96a395F023637D86] = 2;
2784         stakerSnapshot[0xFeb244CDc87A2f3Feb9B10908B89fEd816E67B5a] = 70;
2785         stakerSnapshot[0xFECE31D9eD6B02F774eB559C503f75fc9b0bcE4E] = 2;
2786     }
2787 }