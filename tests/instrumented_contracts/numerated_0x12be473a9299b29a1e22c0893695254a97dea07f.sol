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
135 // File: @openzeppelin/contracts/utils/Context.sol
136 
137 
138 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @dev Provides information about the current execution context, including the
144  * sender of the transaction and its data. While these are generally available
145  * via msg.sender and msg.data, they should not be accessed in such a direct
146  * manner, since when dealing with meta-transactions the account sending and
147  * paying for execution may not be the actual sender (as far as an application
148  * is concerned).
149  *
150  * This contract is only required for intermediate, library-like contracts.
151  */
152 abstract contract Context {
153     function _msgSender() internal view virtual returns (address) {
154         return msg.sender;
155     }
156 
157     function _msgData() internal view virtual returns (bytes calldata) {
158         return msg.data;
159     }
160 }
161 
162 // File: @openzeppelin/contracts/access/Ownable.sol
163 
164 
165 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 
170 /**
171  * @dev Contract module which provides a basic access control mechanism, where
172  * there is an account (an owner) that can be granted exclusive access to
173  * specific functions.
174  *
175  * By default, the owner account will be the one that deploys the contract. This
176  * can later be changed with {transferOwnership}.
177  *
178  * This module is used through inheritance. It will make available the modifier
179  * `onlyOwner`, which can be applied to your functions to restrict their use to
180  * the owner.
181  */
182 abstract contract Ownable is Context {
183     address private _owner;
184 
185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186 
187     /**
188      * @dev Initializes the contract setting the deployer as the initial owner.
189      */
190     constructor() {
191         _transferOwnership(_msgSender());
192     }
193 
194     /**
195      * @dev Returns the address of the current owner.
196      */
197     function owner() public view virtual returns (address) {
198         return _owner;
199     }
200 
201     /**
202      * @dev Throws if called by any account other than the owner.
203      */
204     modifier onlyOwner() {
205         require(owner() == _msgSender(), "Ownable: caller is not the owner");
206         _;
207     }
208 
209     /**
210      * @dev Leaves the contract without owner. It will not be possible to call
211      * `onlyOwner` functions anymore. Can only be called by the current owner.
212      *
213      * NOTE: Renouncing ownership will leave the contract without an owner,
214      * thereby removing any functionality that is only available to the owner.
215      */
216     function renounceOwnership() public virtual onlyOwner {
217         _transferOwnership(address(0));
218     }
219 
220     /**
221      * @dev Transfers ownership of the contract to a new account (`newOwner`).
222      * Can only be called by the current owner.
223      */
224     function transferOwnership(address newOwner) public virtual onlyOwner {
225         require(newOwner != address(0), "Ownable: new owner is the zero address");
226         _transferOwnership(newOwner);
227     }
228 
229     /**
230      * @dev Transfers ownership of the contract to a new account (`newOwner`).
231      * Internal function without access restriction.
232      */
233     function _transferOwnership(address newOwner) internal virtual {
234         address oldOwner = _owner;
235         _owner = newOwner;
236         emit OwnershipTransferred(oldOwner, newOwner);
237     }
238 }
239 
240 // File: @openzeppelin/contracts/utils/Strings.sol
241 
242 
243 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @dev String operations.
249  */
250 library Strings {
251     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
252 
253     /**
254      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
255      */
256     function toString(uint256 value) internal pure returns (string memory) {
257         // Inspired by OraclizeAPI's implementation - MIT licence
258         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
259 
260         if (value == 0) {
261             return "0";
262         }
263         uint256 temp = value;
264         uint256 digits;
265         while (temp != 0) {
266             digits++;
267             temp /= 10;
268         }
269         bytes memory buffer = new bytes(digits);
270         while (value != 0) {
271             digits -= 1;
272             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
273             value /= 10;
274         }
275         return string(buffer);
276     }
277 
278     /**
279      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
280      */
281     function toHexString(uint256 value) internal pure returns (string memory) {
282         if (value == 0) {
283             return "0x00";
284         }
285         uint256 temp = value;
286         uint256 length = 0;
287         while (temp != 0) {
288             length++;
289             temp >>= 8;
290         }
291         return toHexString(value, length);
292     }
293 
294     /**
295      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
296      */
297     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
298         bytes memory buffer = new bytes(2 * length + 2);
299         buffer[0] = "0";
300         buffer[1] = "x";
301         for (uint256 i = 2 * length + 1; i > 1; --i) {
302             buffer[i] = _HEX_SYMBOLS[value & 0xf];
303             value >>= 4;
304         }
305         require(value == 0, "Strings: hex length insufficient");
306         return string(buffer);
307     }
308 }
309 
310 // File: contracts/IERC721A.sol
311 
312 
313 // ERC721A Contracts v3.3.0
314 // Creator: Chiru Labs
315 
316 pragma solidity ^0.8.4;
317 
318 /**
319  * @dev Interface of an ERC721A compliant contract.
320  */
321 interface IERC721A {
322     /**
323      * The caller must own the token or be an approved operator.
324      */
325     error ApprovalCallerNotOwnerNorApproved();
326 
327     /**
328      * The token does not exist.
329      */
330     error ApprovalQueryForNonexistentToken();
331 
332     /**
333      * The caller cannot approve to their own address.
334      */
335     error ApproveToCaller();
336 
337     /**
338      * The caller cannot approve to the current owner.
339      */
340     error ApprovalToCurrentOwner();
341 
342     /**
343      * Cannot query the balance for the zero address.
344      */
345     error BalanceQueryForZeroAddress();
346 
347     /**
348      * Cannot mint to the zero address.
349      */
350     error MintToZeroAddress();
351 
352     /**
353      * The quantity of tokens minted must be more than zero.
354      */
355     error MintZeroQuantity();
356 
357     /**
358      * The token does not exist.
359      */
360     error OwnerQueryForNonexistentToken();
361 
362     /**
363      * The caller must own the token or be an approved operator.
364      */
365     error TransferCallerNotOwnerNorApproved();
366 
367     /**
368      * The token must be owned by `from`.
369      */
370     error TransferFromIncorrectOwner();
371 
372     /**
373      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
374      */
375     error TransferToNonERC721ReceiverImplementer();
376 
377     /**
378      * Cannot transfer to the zero address.
379      */
380     error TransferToZeroAddress();
381 
382     /**
383      * The token does not exist.
384      */
385     error URIQueryForNonexistentToken();
386 
387     struct TokenOwnership {
388         // The address of the owner.
389         address addr;
390         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
391         uint64 startTimestamp;
392         // Whether the token has been burned.
393         bool burned;
394     }
395 
396     /**
397      * @dev Returns the total amount of tokens stored by the contract.
398      *
399      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
400      */
401     function totalSupply() external view returns (uint256);
402 
403     // ==============================
404     //            IERC165
405     // ==============================
406 
407     /**
408      * @dev Returns true if this contract implements the interface defined by
409      * `interfaceId`. See the corresponding
410      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
411      * to learn more about how these ids are created.
412      *
413      * This function call must use less than 30 000 gas.
414      */
415     function supportsInterface(bytes4 interfaceId) external view returns (bool);
416 
417     // ==============================
418     //            IERC721
419     // ==============================
420 
421     /**
422      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
423      */
424     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
425 
426     /**
427      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
428      */
429     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
430 
431     /**
432      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
433      */
434     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
435 
436     /**
437      * @dev Returns the number of tokens in ``owner``'s account.
438      */
439     function balanceOf(address owner) external view returns (uint256 balance);
440 
441     /**
442      * @dev Returns the owner of the `tokenId` token.
443      *
444      * Requirements:
445      *
446      * - `tokenId` must exist.
447      */
448     function ownerOf(uint256 tokenId) external view returns (address owner);
449 
450     /**
451      * @dev Safely transfers `tokenId` token from `from` to `to`.
452      *
453      * Requirements:
454      *
455      * - `from` cannot be the zero address.
456      * - `to` cannot be the zero address.
457      * - `tokenId` token must exist and be owned by `from`.
458      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
459      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
460      *
461      * Emits a {Transfer} event.
462      */
463     function safeTransferFrom(
464         address from,
465         address to,
466         uint256 tokenId,
467         bytes calldata data
468     ) external;
469 
470     /**
471      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
472      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
473      *
474      * Requirements:
475      *
476      * - `from` cannot be the zero address.
477      * - `to` cannot be the zero address.
478      * - `tokenId` token must exist and be owned by `from`.
479      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
480      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
481      *
482      * Emits a {Transfer} event.
483      */
484     function safeTransferFrom(
485         address from,
486         address to,
487         uint256 tokenId
488     ) external;
489 
490     /**
491      * @dev Transfers `tokenId` token from `from` to `to`.
492      *
493      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
494      *
495      * Requirements:
496      *
497      * - `from` cannot be the zero address.
498      * - `to` cannot be the zero address.
499      * - `tokenId` token must be owned by `from`.
500      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
501      *
502      * Emits a {Transfer} event.
503      */
504     function transferFrom(
505         address from,
506         address to,
507         uint256 tokenId
508     ) external;
509 
510     /**
511      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
512      * The approval is cleared when the token is transferred.
513      *
514      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
515      *
516      * Requirements:
517      *
518      * - The caller must own the token or be an approved operator.
519      * - `tokenId` must exist.
520      *
521      * Emits an {Approval} event.
522      */
523     function approve(address to, uint256 tokenId) external;
524 
525     /**
526      * @dev Approve or remove `operator` as an operator for the caller.
527      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
528      *
529      * Requirements:
530      *
531      * - The `operator` cannot be the caller.
532      *
533      * Emits an {ApprovalForAll} event.
534      */
535     function setApprovalForAll(address operator, bool _approved) external;
536 
537     /**
538      * @dev Returns the account approved for `tokenId` token.
539      *
540      * Requirements:
541      *
542      * - `tokenId` must exist.
543      */
544     function getApproved(uint256 tokenId) external view returns (address operator);
545 
546     /**
547      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
548      *
549      * See {setApprovalForAll}
550      */
551     function isApprovedForAll(address owner, address operator) external view returns (bool);
552 
553     // ==============================
554     //        IERC721Metadata
555     // ==============================
556 
557     /**
558      * @dev Returns the token collection name.
559      */
560     function name() external view returns (string memory);
561 
562     /**
563      * @dev Returns the token collection symbol.
564      */
565     function symbol() external view returns (string memory);
566 
567     /**
568      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
569      */
570     function tokenURI(uint256 tokenId) external view returns (string memory);
571 }
572 // File: contracts/ERC721A.sol
573 
574 
575 // ERC721A Contracts v3.3.0
576 // Creator: Chiru Labs
577 
578 pragma solidity ^0.8.4;
579 
580 
581 /**
582  * @dev ERC721 token receiver interface.
583  */
584 interface ERC721A__IERC721Receiver {
585     function onERC721Received(
586         address operator,
587         address from,
588         uint256 tokenId,
589         bytes calldata data
590     ) external returns (bytes4);
591 }
592 
593 /**
594  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
595  * the Metadata extension. Built to optimize for lower gas during batch mints.
596  *
597  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
598  *
599  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
600  *
601  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
602  */
603 contract ERC721A is IERC721A {
604     using Strings for uint256;
605     // Mask of an entry in packed address data.
606     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
607 
608     // The bit position of `numberMinted` in packed address data.
609     uint256 private constant BITPOS_NUMBER_MINTED = 64;
610 
611     // The bit position of `numberBurned` in packed address data.
612     uint256 private constant BITPOS_NUMBER_BURNED = 128;
613 
614     // The bit position of `aux` in packed address data.
615     uint256 private constant BITPOS_AUX = 192;
616 
617     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
618     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
619 
620     // The bit position of `startTimestamp` in packed ownership.
621     uint256 private constant BITPOS_START_TIMESTAMP = 160;
622 
623     // The bit mask of the `burned` bit in packed ownership.
624     uint256 private constant BITMASK_BURNED = 1 << 224;
625     
626     // The bit position of the `nextInitialized` bit in packed ownership.
627     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
628 
629     // The bit mask of the `nextInitialized` bit in packed ownership.
630     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
631 
632     // The tokenId of the next token to be minted.
633     uint256 public _currentIndex;
634 
635     // The number of tokens burned.
636     uint256 private _burnCounter;
637 
638     // Token name
639     string private _name;
640 
641     // Token symbol
642     string private _symbol;
643 
644     string public metadataPath;
645     
646     // Mapping from token ID to ownership details
647     // An empty struct value does not necessarily mean the token is unowned.
648     // See `_packedOwnershipOf` implementation for details.
649     //
650     // Bits Layout:
651     // - [0..159]   `addr`
652     // - [160..223] `startTimestamp`
653     // - [224]      `burned`
654     // - [225]      `nextInitialized`
655     mapping(uint256 => uint256) private _packedOwnerships;
656 
657     // Mapping owner address to address data.
658     //
659     // Bits Layout:
660     // - [0..63]    `balance`
661     // - [64..127]  `numberMinted`
662     // - [128..191] `numberBurned`
663     // - [192..255] `aux`
664     mapping(address => uint256) private _packedAddressData;
665 
666     // Mapping from token ID to approved address.
667     mapping(uint256 => address) private _tokenApprovals;
668 
669     // Mapping from owner to operator approvals
670     mapping(address => mapping(address => bool)) private _operatorApprovals;
671 
672     constructor(string memory name_, string memory symbol_) {
673         _name = name_;
674         _symbol = symbol_;
675         _currentIndex = _startTokenId();
676     }
677 
678     /**
679      * @dev Returns the starting token ID. 
680      * To change the starting token ID, please override this function.
681      */
682     function _startTokenId() internal view virtual returns (uint256) {
683         return 0;
684     }
685 
686     /**
687      * @dev Returns the next token ID to be minted.
688      */
689     function _nextTokenId() internal view returns (uint256) {
690         return _currentIndex;
691     }
692 
693     /**
694      * @dev Returns the total number of tokens in existence.
695      * Burned tokens will reduce the count. 
696      * To get the total number of tokens minted, please see `_totalMinted`.
697      */
698     function totalSupply() public view override returns (uint256) {
699         // Counter underflow is impossible as _burnCounter cannot be incremented
700         // more than `_currentIndex - _startTokenId()` times.
701         unchecked {
702             return _currentIndex - _burnCounter - _startTokenId();
703         }
704     }
705 
706     /**
707      * @dev Returns the total amount of tokens minted in the contract.
708      */
709     function _totalMinted() internal view returns (uint256) {
710         // Counter underflow is impossible as _currentIndex does not decrement,
711         // and it is initialized to `_startTokenId()`
712         unchecked {
713             return _currentIndex - _startTokenId();
714         }
715     }
716 
717     /**
718      * @dev Returns the total number of tokens burned.
719      */
720     function _totalBurned() internal view returns (uint256) {
721         return _burnCounter;
722     }
723 
724     /**
725      * @dev See {IERC165-supportsInterface}.
726      */
727     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
728         // The interface IDs are constants representing the first 4 bytes of the XOR of
729         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
730         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
731         return
732             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
733             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
734             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
735     }
736 
737     /**
738      * @dev See {IERC721-balanceOf}.
739      */
740     function balanceOf(address owner) public view override returns (uint256) {
741         if (owner == address(0)) revert BalanceQueryForZeroAddress();
742         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
743     }
744 
745     /**
746      * Returns the number of tokens minted by `owner`.
747      */
748     function _numberMinted(address owner) internal view returns (uint256) {
749         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
750     }
751 
752     /**
753      * Returns the number of tokens burned by or on behalf of `owner`.
754      */
755     function _numberBurned(address owner) internal view returns (uint256) {
756         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
757     }
758 
759     /**
760      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
761      */
762     function _getAux(address owner) internal view returns (uint64) {
763         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
764     }
765 
766     /**
767      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
768      * If there are multiple variables, please pack them into a uint64.
769      */
770     function _setAux(address owner, uint64 aux) internal {
771         uint256 packed = _packedAddressData[owner];
772         uint256 auxCasted;
773         assembly { // Cast aux without masking.
774             auxCasted := aux
775         }
776         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
777         _packedAddressData[owner] = packed;
778     }
779 
780     /**
781      * Returns the packed ownership data of `tokenId`.
782      */
783     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
784         uint256 curr = tokenId;
785 
786         unchecked {
787             if (_startTokenId() <= curr)
788                 if (curr < _currentIndex) {
789                     uint256 packed = _packedOwnerships[curr];
790                     // If not burned.
791                     if (packed & BITMASK_BURNED == 0) {
792                         // Invariant:
793                         // There will always be an ownership that has an address and is not burned
794                         // before an ownership that does not have an address and is not burned.
795                         // Hence, curr will not underflow.
796                         //
797                         // We can directly compare the packed value.
798                         // If the address is zero, packed is zero.
799                         while (packed == 0) {
800                             packed = _packedOwnerships[--curr];
801                         }
802                         return packed;
803                     }
804                 }
805         }
806         revert OwnerQueryForNonexistentToken();
807     }
808 
809     /**
810      * Returns the unpacked `TokenOwnership` struct from `packed`.
811      */
812     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
813         ownership.addr = address(uint160(packed));
814         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
815         ownership.burned = packed & BITMASK_BURNED != 0;
816     }
817 
818     /**
819      * Returns the unpacked `TokenOwnership` struct at `index`.
820      */
821     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
822         return _unpackedOwnership(_packedOwnerships[index]);
823     }
824 
825     /**
826      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
827      */
828     function _initializeOwnershipAt(uint256 index) internal {
829         if (_packedOwnerships[index] == 0) {
830             _packedOwnerships[index] = _packedOwnershipOf(index);
831         }
832     }
833 
834     /**
835      * Gas spent here starts off proportional to the maximum mint batch size.
836      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
837      */
838     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
839         return _unpackedOwnership(_packedOwnershipOf(tokenId));
840     }
841 
842     /**
843      * @dev See {IERC721-ownerOf}.
844      */
845     function ownerOf(uint256 tokenId) public view override returns (address) {
846         return address(uint160(_packedOwnershipOf(tokenId)));
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-name}.
851      */
852     function name() public view virtual override returns (string memory) {
853         return _name;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-symbol}.
858      */
859     function symbol() public view virtual override returns (string memory) {
860         return _symbol;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-tokenURI}.
865      */
866     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
867         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
868 
869         string memory baseURI = _baseURI();
870         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),'.json')) : '';
871     }
872 
873     /**
874      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
875      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
876      * by default, can be overriden in child contracts.
877      */
878     function _baseURI() internal view virtual returns (string memory) {
879         return metadataPath;
880     }
881 
882     /**
883      * @dev Casts the address to uint256 without masking.
884      */
885     function _addressToUint256(address value) private pure returns (uint256 result) {
886         assembly {
887             result := value
888         }
889     }
890 
891     /**
892      * @dev Casts the boolean to uint256 without branching.
893      */
894     function _boolToUint256(bool value) private pure returns (uint256 result) {
895         assembly {
896             result := value
897         }
898     }
899 
900     /**
901      * @dev See {IERC721-approve}.
902      */
903     function approve(address to, uint256 tokenId) public override {
904         address owner = address(uint160(_packedOwnershipOf(tokenId)));
905         if (to == owner) revert ApprovalToCurrentOwner();
906 
907         if (_msgSenderERC721A() != owner)
908             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
909                 revert ApprovalCallerNotOwnerNorApproved();
910             }
911 
912         _tokenApprovals[tokenId] = to;
913         emit Approval(owner, to, tokenId);
914     }
915 
916     /**
917      * @dev See {IERC721-getApproved}.
918      */
919     function getApproved(uint256 tokenId) public view override returns (address) {
920         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
921 
922         return _tokenApprovals[tokenId];
923     }
924 
925     /**
926      * @dev See {IERC721-setApprovalForAll}.
927      */
928     function setApprovalForAll(address operator, bool approved) public virtual override {
929         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
930 
931         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
932         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
933     }
934 
935     /**
936      * @dev See {IERC721-isApprovedForAll}.
937      */
938     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
939         return _operatorApprovals[owner][operator];
940     }
941 
942     /**
943      * @dev See {IERC721-transferFrom}.
944      */
945     function transferFrom(
946         address from,
947         address to,
948         uint256 tokenId
949     ) public virtual override {
950         _transfer(from, to, tokenId);
951     }
952 
953     /**
954      * @dev See {IERC721-safeTransferFrom}.
955      */
956     function safeTransferFrom(
957         address from,
958         address to,
959         uint256 tokenId
960     ) public virtual override {
961         safeTransferFrom(from, to, tokenId, '');
962     }
963 
964     /**
965      * @dev See {IERC721-safeTransferFrom}.
966      */
967     function safeTransferFrom(
968         address from,
969         address to,
970         uint256 tokenId,
971         bytes memory _data
972     ) public virtual override {
973         _transfer(from, to, tokenId);
974         if (to.code.length != 0)
975             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
976                 revert TransferToNonERC721ReceiverImplementer();
977             }
978     }
979 
980     /**
981      * @dev Returns whether `tokenId` exists.
982      *
983      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
984      *
985      * Tokens start existing when they are minted (`_mint`),
986      */
987     function _exists(uint256 tokenId) internal view returns (bool) {
988         return
989             _startTokenId() <= tokenId &&
990             tokenId < _currentIndex && // If within bounds,
991             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
992     }
993 
994     /**
995      * @dev Equivalent to `_safeMint(to, quantity, '')`.
996      */
997     function _safeMint(address to, uint256 quantity) internal {
998         _safeMint(to, quantity, '');
999     }
1000 
1001     /**
1002      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1003      *
1004      * Requirements:
1005      *
1006      * - If `to` refers to a smart contract, it must implement
1007      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1008      * - `quantity` must be greater than 0.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _safeMint(
1013         address to,
1014         uint256 quantity,
1015         bytes memory _data
1016     ) internal {
1017         uint256 startTokenId = _currentIndex;
1018         if (to == address(0)) revert MintToZeroAddress();
1019         if (quantity == 0) revert MintZeroQuantity();
1020 
1021         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1022 
1023         // Overflows are incredibly unrealistic.
1024         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1025         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1026         unchecked {
1027             // Updates:
1028             // - `balance += quantity`.
1029             // - `numberMinted += quantity`.
1030             //
1031             // We can directly add to the balance and number minted.
1032             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1033 
1034             // Updates:
1035             // - `address` to the owner.
1036             // - `startTimestamp` to the timestamp of minting.
1037             // - `burned` to `false`.
1038             // - `nextInitialized` to `quantity == 1`.
1039             _packedOwnerships[startTokenId] =
1040                 _addressToUint256(to) |
1041                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1042                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1043 
1044             uint256 updatedIndex = startTokenId;
1045             uint256 end = updatedIndex + quantity;
1046 
1047             if (to.code.length != 0) {
1048                 do {
1049                     emit Transfer(address(0), to, updatedIndex);
1050                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1051                         revert TransferToNonERC721ReceiverImplementer();
1052                     }
1053                 } while (updatedIndex < end);
1054                 // Reentrancy protection
1055                 if (_currentIndex != startTokenId) revert();
1056             } else {
1057                 do {
1058                     emit Transfer(address(0), to, updatedIndex++);
1059                 } while (updatedIndex < end);
1060             }
1061             _currentIndex = updatedIndex;
1062         }
1063         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1064     }
1065 
1066     /**
1067      * @dev Mints `quantity` tokens and transfers them to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - `to` cannot be the zero address.
1072      * - `quantity` must be greater than 0.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _mint(address to, uint256 quantity) internal {
1077         uint256 startTokenId = _currentIndex;
1078         if (to == address(0)) revert MintToZeroAddress();
1079         if (quantity == 0) revert MintZeroQuantity();
1080 
1081         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1082 
1083         // Overflows are incredibly unrealistic.
1084         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1085         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1086         unchecked {
1087             // Updates:
1088             // - `balance += quantity`.
1089             // - `numberMinted += quantity`.
1090             //
1091             // We can directly add to the balance and number minted.
1092             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1093 
1094             // Updates:
1095             // - `address` to the owner.
1096             // - `startTimestamp` to the timestamp of minting.
1097             // - `burned` to `false`.
1098             // - `nextInitialized` to `quantity == 1`.
1099             _packedOwnerships[startTokenId] =
1100                 _addressToUint256(to) |
1101                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1102                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1103 
1104             uint256 updatedIndex = startTokenId;
1105             uint256 end = updatedIndex + quantity;
1106 
1107             do {
1108                 emit Transfer(address(0), to, updatedIndex++);
1109             } while (updatedIndex < end);
1110 
1111             _currentIndex = updatedIndex;
1112         }
1113         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1114     }
1115 
1116     /**
1117      * @dev Transfers `tokenId` from `from` to `to`.
1118      *
1119      * Requirements:
1120      *
1121      * - `to` cannot be the zero address.
1122      * - `tokenId` token must be owned by `from`.
1123      *
1124      * Emits a {Transfer} event.
1125      */
1126     function _transfer(
1127         address from,
1128         address to,
1129         uint256 tokenId
1130     ) private {
1131         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1132 
1133         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1134 
1135         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1136             isApprovedForAll(from, _msgSenderERC721A()) ||
1137             getApproved(tokenId) == _msgSenderERC721A());
1138 
1139         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1140         if (to == address(0)) revert TransferToZeroAddress();
1141 
1142         _beforeTokenTransfers(from, to, tokenId, 1);
1143 
1144         // Clear approvals from the previous owner.
1145         delete _tokenApprovals[tokenId];
1146 
1147         // Underflow of the sender's balance is impossible because we check for
1148         // ownership above and the recipient's balance can't realistically overflow.
1149         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1150         unchecked {
1151             // We can directly increment and decrement the balances.
1152             --_packedAddressData[from]; // Updates: `balance -= 1`.
1153             ++_packedAddressData[to]; // Updates: `balance += 1`.
1154 
1155             // Updates:
1156             // - `address` to the next owner.
1157             // - `startTimestamp` to the timestamp of transfering.
1158             // - `burned` to `false`.
1159             // - `nextInitialized` to `true`.
1160             _packedOwnerships[tokenId] =
1161                 _addressToUint256(to) |
1162                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1163                 BITMASK_NEXT_INITIALIZED;
1164 
1165             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1166             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1167                 uint256 nextTokenId = tokenId + 1;
1168                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1169                 if (_packedOwnerships[nextTokenId] == 0) {
1170                     // If the next slot is within bounds.
1171                     if (nextTokenId != _currentIndex) {
1172                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1173                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1174                     }
1175                 }
1176             }
1177         }
1178 
1179         emit Transfer(from, to, tokenId);
1180         _afterTokenTransfers(from, to, tokenId, 1);
1181     }
1182 
1183     /**
1184      * @dev Equivalent to `_burn(tokenId, false)`.
1185      */
1186     function _burn(uint256 tokenId) internal virtual {
1187         _burn(tokenId, false);
1188     }
1189 
1190     /**
1191      * @dev Destroys `tokenId`.
1192      * The approval is cleared when the token is burned.
1193      *
1194      * Requirements:
1195      *
1196      * - `tokenId` must exist.
1197      *
1198      * Emits a {Transfer} event.
1199      */
1200     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1201         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1202 
1203         address from = address(uint160(prevOwnershipPacked));
1204 
1205         if (approvalCheck) {
1206             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1207                 isApprovedForAll(from, _msgSenderERC721A()) ||
1208                 getApproved(tokenId) == _msgSenderERC721A());
1209 
1210             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1211         }
1212 
1213         _beforeTokenTransfers(from, address(0), tokenId, 1);
1214 
1215         // Clear approvals from the previous owner.
1216         delete _tokenApprovals[tokenId];
1217 
1218         // Underflow of the sender's balance is impossible because we check for
1219         // ownership above and the recipient's balance can't realistically overflow.
1220         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1221         unchecked {
1222             // Updates:
1223             // - `balance -= 1`.
1224             // - `numberBurned += 1`.
1225             //
1226             // We can directly decrement the balance, and increment the number burned.
1227             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1228             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1229 
1230             // Updates:
1231             // - `address` to the last owner.
1232             // - `startTimestamp` to the timestamp of burning.
1233             // - `burned` to `true`.
1234             // - `nextInitialized` to `true`.
1235             _packedOwnerships[tokenId] =
1236                 _addressToUint256(from) |
1237                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1238                 BITMASK_BURNED | 
1239                 BITMASK_NEXT_INITIALIZED;
1240 
1241             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1242             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1243                 uint256 nextTokenId = tokenId + 1;
1244                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1245                 if (_packedOwnerships[nextTokenId] == 0) {
1246                     // If the next slot is within bounds.
1247                     if (nextTokenId != _currentIndex) {
1248                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1249                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1250                     }
1251                 }
1252             }
1253         }
1254 
1255         emit Transfer(from, address(0), tokenId);
1256         _afterTokenTransfers(from, address(0), tokenId, 1);
1257 
1258         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1259         unchecked {
1260             _burnCounter++;
1261         }
1262     }
1263 
1264     /**
1265      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1266      *
1267      * @param from address representing the previous owner of the given token ID
1268      * @param to target address that will receive the tokens
1269      * @param tokenId uint256 ID of the token to be transferred
1270      * @param _data bytes optional data to send along with the call
1271      * @return bool whether the call correctly returned the expected magic value
1272      */
1273     function _checkContractOnERC721Received(
1274         address from,
1275         address to,
1276         uint256 tokenId,
1277         bytes memory _data
1278     ) private returns (bool) {
1279         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1280             bytes4 retval
1281         ) {
1282             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1283         } catch (bytes memory reason) {
1284             if (reason.length == 0) {
1285                 revert TransferToNonERC721ReceiverImplementer();
1286             } else {
1287                 assembly {
1288                     revert(add(32, reason), mload(reason))
1289                 }
1290             }
1291         }
1292     }
1293 
1294     /**
1295      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1296      * And also called before burning one token.
1297      *
1298      * startTokenId - the first token id to be transferred
1299      * quantity - the amount to be transferred
1300      *
1301      * Calling conditions:
1302      *
1303      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1304      * transferred to `to`.
1305      * - When `from` is zero, `tokenId` will be minted for `to`.
1306      * - When `to` is zero, `tokenId` will be burned by `from`.
1307      * - `from` and `to` are never both zero.
1308      */
1309     function _beforeTokenTransfers(
1310         address from,
1311         address to,
1312         uint256 startTokenId,
1313         uint256 quantity
1314     ) internal virtual {}
1315 
1316     /**
1317      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1318      * minting.
1319      * And also called after one token has been burned.
1320      *
1321      * startTokenId - the first token id to be transferred
1322      * quantity - the amount to be transferred
1323      *
1324      * Calling conditions:
1325      *
1326      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1327      * transferred to `to`.
1328      * - When `from` is zero, `tokenId` has been minted for `to`.
1329      * - When `to` is zero, `tokenId` has been burned by `from`.
1330      * - `from` and `to` are never both zero.
1331      */
1332     function _afterTokenTransfers(
1333         address from,
1334         address to,
1335         uint256 startTokenId,
1336         uint256 quantity
1337     ) internal virtual {}
1338 
1339     /**
1340      * @dev Returns the message sender (defaults to `msg.sender`).
1341      *
1342      * If you are writing GSN compatible contracts, you need to override this function.
1343      */
1344     function _msgSenderERC721A() internal view virtual returns (address) {
1345         return msg.sender;
1346     }
1347 
1348     /**
1349      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1350      */
1351     function _toString(uint256 value) internal pure returns (string memory ptr) {
1352         assembly {
1353             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1354             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1355             // We will need 1 32-byte word to store the length, 
1356             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1357             ptr := add(mload(0x40), 128)
1358             // Update the free memory pointer to allocate.
1359             mstore(0x40, ptr)
1360 
1361             // Cache the end of the memory to calculate the length later.
1362             let end := ptr
1363 
1364             // We write the string from the rightmost digit to the leftmost digit.
1365             // The following is essentially a do-while loop that also handles the zero case.
1366             // Costs a bit more than early returning for the zero case,
1367             // but cheaper in terms of deployment and overall runtime costs.
1368             for { 
1369                 // Initialize and perform the first pass without check.
1370                 let temp := value
1371                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1372                 ptr := sub(ptr, 1)
1373                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1374                 mstore8(ptr, add(48, mod(temp, 10)))
1375                 temp := div(temp, 10)
1376             } temp { 
1377                 // Keep dividing `temp` until zero.
1378                 temp := div(temp, 10)
1379             } { // Body of the for loop.
1380                 ptr := sub(ptr, 1)
1381                 mstore8(ptr, add(48, mod(temp, 10)))
1382             }
1383             
1384             let length := sub(end, ptr)
1385             // Move the pointer 32 bytes leftwards to make room for the length.
1386             ptr := sub(ptr, 32)
1387             // Store the length.
1388             mstore(ptr, length)
1389         }
1390     }
1391 }
1392 // File: contracts/BigBang.sol
1393 
1394 
1395 
1396 /*************************************************
1397 * The Blinkless: Big Bang uses minting mechanics
1398 * modeled after the Big Bang to mint planets in 
1399 * the Blinkless animated universe.
1400 *
1401 * code by @digitalkemical
1402 *************************************************/
1403 
1404 pragma solidity ^0.8.4;
1405 
1406 
1407 
1408 
1409 
1410 contract BlinklessBigBang is ERC721A,Ownable,ReentrancyGuard {
1411 
1412     uint256 public maxSupply = 20000; //total number of planets that can be minted
1413     uint256[] public airdropWaitlist; //list of token ids waiting for airdrops
1414     uint256 public nextAirdropIndex = 0; //the next index in airdropWaitlist to be airdropped
1415     uint256 public publicPrice = 0.05 ether; //price for the public to mint
1416     uint256 public blinklistPrice = 0.01 ether; //price for blinklisted wallets to mint
1417     uint256 public mintMode = 0; //mintMode - 0 for off, 1 for on
1418     bytes32 public root; //blinklist merkle tree root
1419 
1420     //constructor is run when contract is deployed
1421     constructor(bytes32 _root) ERC721A("The Blinkless: Big Bang!", "BLBB") {
1422         //mint token #0 (New Cornea) to the contract owner
1423         _mint(msg.sender, 1);
1424         //push first token to waitlist
1425         airdropWaitlist.push(0);
1426         //set merkle tree root
1427         root = _root;
1428     }
1429 
1430     /*
1431     * Ensures the caller is not a proxy contract or bot, but is an actual wallet.
1432     */
1433     modifier callerIsUser() {
1434         //we only want to mint to real people
1435         require(tx.origin == msg.sender, "The caller is another contract");
1436         _;
1437     }
1438 
1439     function teamMint() external onlyOwner(){
1440         //founder/mod mints - each mod/founder gets 5
1441         //digitalkemical
1442         _mint(address(0x1Fd910C9E85657adF824086671CF60ecDD48293B), 5);
1443         //elgallo
1444         _mint(address(0xadd0C6134f28A4E74C829540f35A3194AF4c076E), 5);
1445         //superbeetle
1446         _mint(address(0xD684728B0F8d77f4A43f01e24d7487b4dc3E195d), 5);
1447         //riley
1448         _mint(address(0x45Cb4AF10B1D8ae8bC01360BDd517C62C479B61f), 5);
1449         //zilvadragon
1450         _mint(address(0x8D95A4EC9b5703D1370799dD2C7ad444900b9299), 5);
1451         //gasprices2high
1452         _mint(address(0xfe831CF4046E8bBd5Fe462ce3b1f681C82D50d53), 5);
1453         //holeefook
1454         _mint(address(0x39053dB2570Be478594F5797224E45AC694445E7), 5);
1455 
1456         //add any minted tokens to the waitlist
1457         uint256 i = 1; 
1458         while(i < totalSupply()){
1459             //push minted token ids into airdrop waitlist
1460             airdropWaitlist.push(i);
1461             i++;
1462         }
1463     }
1464 
1465 
1466     /*
1467     * Verifies the sender is on the Blinklist using Merkle Tree Proof
1468     */
1469     function isBlinklisted(bytes32[] memory proof, bytes32 leaf) public view returns (bool){
1470         return MerkleProof.verify(proof,root,leaf);
1471     }
1472 
1473     /**
1474     * Mint a token
1475     */
1476     function mint(uint256 quantity, bytes32[] memory proof, bytes32 leaf) external payable callerIsUser{
1477         //make sure mint is on
1478         require(mintMode == 1,"Mint is not active.");
1479         //limit to 5 per wallet
1480         require(balanceOf(msg.sender) + quantity <= 5, "Only 5 planets allowed per wallet!"); 
1481         //make sure we're not minted out
1482         require(totalSupply() + quantity <= maxSupply,"Sold Out!");  
1483         //check if sender is blinklisted
1484         if(isBlinklisted(proof,leaf)){
1485             //check for proper funds
1486             require(msg.value >= quantity * blinklistPrice, "Not enough funds!");
1487         } else {
1488             //check for proper funds
1489             require(msg.value >= quantity * publicPrice, "Not enough funds!");
1490         }
1491         //add to airdrop if still within window
1492         if(totalSupply() < 10000){
1493             uint256 i = 0;
1494             while(i < quantity){
1495                 //push minted token ids into airdrop waitlist
1496                 //only minted tokens are eligible for FAM airdrops
1497                 airdropWaitlist.push(_currentIndex + i);
1498                 i++;
1499             }
1500         }
1501         
1502         //mint the tokens
1503         _mint(msg.sender, quantity);
1504 
1505        
1506 
1507         /***************************************************
1508         * FAM: Feedback Accelerated Minting
1509         ***************************************************/
1510         //calculate airdrops
1511         uint256 airdropQty = 0;
1512         uint256 tSupply = totalSupply();
1513       
1514         if(tSupply <= 1000){
1515             airdropQty = 5; //airdrop 5 tokens
1516         }
1517         if(tSupply > 1000 && tSupply <= 2000){
1518 		     airdropQty = 4; //airdrop 4 tokens
1519         } 
1520         if(tSupply > 2000 && tSupply <= 3000){
1521              airdropQty = 3; //airdrop 3 tokens
1522         }
1523         if(tSupply > 3000 && tSupply <= 5000){
1524              airdropQty = 2; //airdrop 2 tokens
1525         }
1526         if(tSupply > 5000 && tSupply <= 10000){
1527              airdropQty = 1; //airdrop 1 tokens
1528         }
1529 
1530         //only airdrop tokens if conditions are met
1531         if(airdropQty > 0){
1532             //airdrop tokens
1533             _mint(address(ownerOf(airdropWaitlist[nextAirdropIndex])), airdropQty); 
1534             //iterate to the next person in line
1535             nextAirdropIndex++;
1536         }
1537         /***************************************************
1538         * END - FAM: Feedback Accelerated Minting
1539         ***************************************************/
1540 
1541     }
1542 
1543     /*
1544     * Fetch the total balance held in the contract in wei
1545     */
1546     function getContractBalance() public view returns(uint256 balance){
1547         return address(this).balance;
1548     }
1549 
1550     /*
1551     * Fetch current waitlist
1552     */
1553     function getWaitlist() public view returns(uint256[] memory waitlist){
1554         return airdropWaitlist;
1555     }
1556 
1557     /*
1558     * Fetch next airdrop index
1559     */
1560     function getNextAirdropIndex() public view returns(uint256 nextIndex){
1561         return nextAirdropIndex;
1562     }
1563 
1564     /**
1565     * Update the base URI for metadata
1566     */
1567     function updateBaseURI(string memory baseURI) external onlyOwner{
1568         //set the path to the metadata
1569          metadataPath = baseURI;
1570     }
1571 
1572     /**
1573     * Update the root
1574     */
1575     function updateRoot(bytes32 _root) external onlyOwner{
1576         //set the root
1577          root = _root;
1578     }
1579 
1580      /**
1581     * Update the mintMode
1582     */
1583     function updateMintMode(uint256 _mintMode) external onlyOwner{
1584         //set the mintMode
1585          mintMode = _mintMode;
1586     }
1587  
1588     /*
1589     * Withdraw by owner
1590     */
1591     function withdraw() external onlyOwner nonReentrant {
1592         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1593         require(success, "Transfer failed.");
1594     }
1595 
1596 
1597     /*
1598     * These are here to receive ETH sent to the contract address
1599     */
1600     receive() external payable {}
1601 
1602     fallback() external payable {}
1603 
1604    
1605 }