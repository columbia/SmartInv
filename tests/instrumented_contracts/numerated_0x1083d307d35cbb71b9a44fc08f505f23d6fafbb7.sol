1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Tree proofs.
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
38      * @dev Calldata version of {verify}
39      *
40      * _Available since v4.7._
41      */
42     function verifyCalldata(
43         bytes32[] calldata proof,
44         bytes32 root,
45         bytes32 leaf
46     ) internal pure returns (bool) {
47         return processProofCalldata(proof, leaf) == root;
48     }
49 
50     /**
51      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
52      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
53      * hash matches the root of the tree. When processing the proof, the pairs
54      * of leafs & pre-images are assumed to be sorted.
55      *
56      * _Available since v4.4._
57      */
58     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
59         bytes32 computedHash = leaf;
60         for (uint256 i = 0; i < proof.length; i++) {
61             computedHash = _hashPair(computedHash, proof[i]);
62         }
63         return computedHash;
64     }
65 
66     /**
67      * @dev Calldata version of {processProof}
68      *
69      * _Available since v4.7._
70      */
71     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
72         bytes32 computedHash = leaf;
73         for (uint256 i = 0; i < proof.length; i++) {
74             computedHash = _hashPair(computedHash, proof[i]);
75         }
76         return computedHash;
77     }
78 
79     /**
80      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
81      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
82      *
83      * _Available since v4.7._
84      */
85     function multiProofVerify(
86         bytes32[] memory proof,
87         bool[] memory proofFlags,
88         bytes32 root,
89         bytes32[] memory leaves
90     ) internal pure returns (bool) {
91         return processMultiProof(proof, proofFlags, leaves) == root;
92     }
93 
94     /**
95      * @dev Calldata version of {multiProofVerify}
96      *
97      * _Available since v4.7._
98      */
99     function multiProofVerifyCalldata(
100         bytes32[] calldata proof,
101         bool[] calldata proofFlags,
102         bytes32 root,
103         bytes32[] memory leaves
104     ) internal pure returns (bool) {
105         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
106     }
107 
108     /**
109      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
110      * consuming from one or the other at each step according to the instructions given by
111      * `proofFlags`.
112      *
113      * _Available since v4.7._
114      */
115     function processMultiProof(
116         bytes32[] memory proof,
117         bool[] memory proofFlags,
118         bytes32[] memory leaves
119     ) internal pure returns (bytes32 merkleRoot) {
120         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
121         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
122         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
123         // the merkle tree.
124         uint256 leavesLen = leaves.length;
125         uint256 totalHashes = proofFlags.length;
126 
127         // Check proof validity.
128         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
129 
130         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
131         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
132         bytes32[] memory hashes = new bytes32[](totalHashes);
133         uint256 leafPos = 0;
134         uint256 hashPos = 0;
135         uint256 proofPos = 0;
136         // At each step, we compute the next hash using two values:
137         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
138         //   get the next hash.
139         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
140         //   `proof` array.
141         for (uint256 i = 0; i < totalHashes; i++) {
142             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
143             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
144             hashes[i] = _hashPair(a, b);
145         }
146 
147         if (totalHashes > 0) {
148             return hashes[totalHashes - 1];
149         } else if (leavesLen > 0) {
150             return leaves[0];
151         } else {
152             return proof[0];
153         }
154     }
155 
156     /**
157      * @dev Calldata version of {processMultiProof}
158      *
159      * _Available since v4.7._
160      */
161     function processMultiProofCalldata(
162         bytes32[] calldata proof,
163         bool[] calldata proofFlags,
164         bytes32[] memory leaves
165     ) internal pure returns (bytes32 merkleRoot) {
166         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
167         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
168         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
169         // the merkle tree.
170         uint256 leavesLen = leaves.length;
171         uint256 totalHashes = proofFlags.length;
172 
173         // Check proof validity.
174         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
175 
176         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
177         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
178         bytes32[] memory hashes = new bytes32[](totalHashes);
179         uint256 leafPos = 0;
180         uint256 hashPos = 0;
181         uint256 proofPos = 0;
182         // At each step, we compute the next hash using two values:
183         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
184         //   get the next hash.
185         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
186         //   `proof` array.
187         for (uint256 i = 0; i < totalHashes; i++) {
188             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
189             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
190             hashes[i] = _hashPair(a, b);
191         }
192 
193         if (totalHashes > 0) {
194             return hashes[totalHashes - 1];
195         } else if (leavesLen > 0) {
196             return leaves[0];
197         } else {
198             return proof[0];
199         }
200     }
201 
202     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
203         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
204     }
205 
206     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
207         /// @solidity memory-safe-assembly
208         assembly {
209             mstore(0x00, a)
210             mstore(0x20, b)
211             value := keccak256(0x00, 0x40)
212         }
213     }
214 }
215 
216 // File: themillenialswtf.sol
217 
218 
219 pragma solidity >=0.8.0 <0.9.0;
220 
221 
222 
223 /**
224  *Submitted for verification at Etherscan.io on 2022-06-06
225 */
226 
227 
228 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev Contract module that helps prevent reentrant calls to a function.
237  *
238  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
239  * available, which can be applied to functions to make sure there are no nested
240  * (reentrant) calls to them.
241  *
242  * Note that because there is a single `nonReentrant` guard, functions marked as
243  * `nonReentrant` may not call one another. This can be worked around by making
244  * those functions `private`, and then adding `external` `nonReentrant` entry
245  * points to them.
246  *
247  * TIP: If you would like to learn more about reentrancy and alternative ways
248  * to protect against it, check out our blog post
249  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
250  */
251 abstract contract ReentrancyGuard {
252     // Booleans are more expensive than uint256 or any type that takes up a full
253     // word because each write operation emits an extra SLOAD to first read the
254     // slot's contents, replace the bits taken up by the boolean, and then write
255     // back. This is the compiler's defense against contract upgrades and
256     // pointer aliasing, and it cannot be disabled.
257 
258     // The values being non-zero value makes deployment a bit more expensive,
259     // but in exchange the refund on every call to nonReentrant will be lower in
260     // amount. Since refunds are capped to a percentage of the total
261     // transaction's gas, it is best to keep them low in cases like this one, to
262     // increase the likelihood of the full refund coming into effect.
263     uint256 private constant _NOT_ENTERED = 1;
264     uint256 private constant _ENTERED = 2;
265 
266     uint256 private _status;
267 
268     constructor() {
269         _status = _NOT_ENTERED;
270     }
271 
272     /**
273      * @dev Prevents a contract from calling itself, directly or indirectly.
274      * Calling a `nonReentrant` function from another `nonReentrant`
275      * function is not supported. It is possible to prevent this from happening
276      * by making the `nonReentrant` function external, and making it call a
277      * `private` function that does the actual work.
278      */
279     modifier nonReentrant() {
280         // On the first call to nonReentrant, _notEntered will be true
281         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
282 
283         // Any calls to nonReentrant after this point will fail
284         _status = _ENTERED;
285 
286         _;
287 
288         // By storing the original value once again, a refund is triggered (see
289         // https://eips.ethereum.org/EIPS/eip-2200)
290         _status = _NOT_ENTERED;
291     }
292 }
293 
294 // File: @openzeppelin/contracts/utils/Strings.sol
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @dev String operations.
303  */
304 library Strings {
305     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
306 
307     /**
308      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
309      */
310     function toString(uint256 value) internal pure returns (string memory) {
311         // Inspired by OraclizeAPI's implementation - MIT licence
312         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
313 
314         if (value == 0) {
315             return "0";
316         }
317         uint256 temp = value;
318         uint256 digits;
319         while (temp != 0) {
320             digits++;
321             temp /= 10;
322         }
323         bytes memory buffer = new bytes(digits);
324         while (value != 0) {
325             digits -= 1;
326             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
327             value /= 10;
328         }
329         return string(buffer);
330     }
331 
332     /**
333      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
334      */
335     function toHexString(uint256 value) internal pure returns (string memory) {
336         if (value == 0) {
337             return "0x00";
338         }
339         uint256 temp = value;
340         uint256 length = 0;
341         while (temp != 0) {
342             length++;
343             temp >>= 8;
344         }
345         return toHexString(value, length);
346     }
347 
348     /**
349      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
350      */
351     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
352         bytes memory buffer = new bytes(2 * length + 2);
353         buffer[0] = "0";
354         buffer[1] = "x";
355         for (uint256 i = 2 * length + 1; i > 1; --i) {
356             buffer[i] = _HEX_SYMBOLS[value & 0xf];
357             value >>= 4;
358         }
359         require(value == 0, "Strings: hex length insufficient");
360         return string(buffer);
361     }
362 }
363 
364 // File: erc721a/contracts/IERC721A.sol
365 
366 
367 // ERC721A Contracts v4.0.0
368 // Creator: Chiru Labs
369 
370 pragma solidity ^0.8.4;
371 
372 /**
373  * @dev Interface of an ERC721A compliant contract.
374  */
375 interface IERC721A {
376     /**
377      * The caller must own the token or be an approved operator.
378      */
379     error ApprovalCallerNotOwnerNorApproved();
380 
381     /**
382      * The token does not exist.
383      */
384     error ApprovalQueryForNonexistentToken();
385 
386     /**
387      * The caller cannot approve to their own address.
388      */
389     error ApproveToCaller();
390 
391     /**
392      * The caller cannot approve to the current owner.
393      */
394     error ApprovalToCurrentOwner();
395 
396     /**
397      * Cannot query the balance for the zero address.
398      */
399     error BalanceQueryForZeroAddress();
400 
401     /**
402      * Cannot mint to the zero address.
403      */
404     error MintToZeroAddress();
405 
406     /**
407      * The quantity of tokens minted must be more than zero.
408      */
409     error MintZeroQuantity();
410 
411     /**
412      * The token does not exist.
413      */
414     error OwnerQueryForNonexistentToken();
415 
416     /**
417      * The caller must own the token or be an approved operator.
418      */
419     error TransferCallerNotOwnerNorApproved();
420 
421     /**
422      * The token must be owned by `from`.
423      */
424     error TransferFromIncorrectOwner();
425 
426     /**
427      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
428      */
429     error TransferToNonERC721ReceiverImplementer();
430 
431     /**
432      * Cannot transfer to the zero address.
433      */
434     error TransferToZeroAddress();
435 
436     /**
437      * The token does not exist.
438      */
439     error URIQueryForNonexistentToken();
440 
441     struct TokenOwnership {
442         // The address of the owner.
443         address addr;
444         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
445         uint64 startTimestamp;
446         // Whether the token has been burned.
447         bool burned;
448     }
449 
450     /**
451      * @dev Returns the total amount of tokens stored by the contract.
452      *
453      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
454      */
455     function totalSupply() external view returns (uint256);
456 
457     // ==============================
458     //            IERC165
459     // ==============================
460 
461     /**
462      * @dev Returns true if this contract implements the interface defined by
463      * `interfaceId`. See the corresponding
464      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
465      * to learn more about how these ids are created.
466      *
467      * This function call must use less than 30 000 gas.
468      */
469     function supportsInterface(bytes4 interfaceId) external view returns (bool);
470 
471     // ==============================
472     //            IERC721
473     // ==============================
474 
475     /**
476      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
477      */
478     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
479 
480     /**
481      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
482      */
483     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
484 
485     /**
486      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
487      */
488     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
489 
490     /**
491      * @dev Returns the number of tokens in ``owner``'s account.
492      */
493     function balanceOf(address owner) external view returns (uint256 balance);
494 
495     /**
496      * @dev Returns the owner of the `tokenId` token.
497      *
498      * Requirements:
499      *
500      * - `tokenId` must exist.
501      */
502     function ownerOf(uint256 tokenId) external view returns (address owner);
503 
504     /**
505      * @dev Safely transfers `tokenId` token from `from` to `to`.
506      *
507      * Requirements:
508      *
509      * - `from` cannot be the zero address.
510      * - `to` cannot be the zero address.
511      * - `tokenId` token must exist and be owned by `from`.
512      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
513      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
514      *
515      * Emits a {Transfer} event.
516      */
517     function safeTransferFrom(
518         address from,
519         address to,
520         uint256 tokenId,
521         bytes calldata data
522     ) external;
523 
524     /**
525      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
526      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
527      *
528      * Requirements:
529      *
530      * - `from` cannot be the zero address.
531      * - `to` cannot be the zero address.
532      * - `tokenId` token must exist and be owned by `from`.
533      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
534      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
535      *
536      * Emits a {Transfer} event.
537      */
538     function safeTransferFrom(
539         address from,
540         address to,
541         uint256 tokenId
542     ) external;
543 
544     /**
545      * @dev Transfers `tokenId` token from `from` to `to`.
546      *
547      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
548      *
549      * Requirements:
550      *
551      * - `from` cannot be the zero address.
552      * - `to` cannot be the zero address.
553      * - `tokenId` token must be owned by `from`.
554      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
555      *
556      * Emits a {Transfer} event.
557      */
558     function transferFrom(
559         address from,
560         address to,
561         uint256 tokenId
562     ) external;
563 
564     /**
565      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
566      * The approval is cleared when the token is transferred.
567      *
568      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
569      *
570      * Requirements:
571      *
572      * - The caller must own the token or be an approved operator.
573      * - `tokenId` must exist.
574      *
575      * Emits an {Approval} event.
576      */
577     function approve(address to, uint256 tokenId) external;
578 
579     /**
580      * @dev Approve or remove `operator` as an operator for the caller.
581      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
582      *
583      * Requirements:
584      *
585      * - The `operator` cannot be the caller.
586      *
587      * Emits an {ApprovalForAll} event.
588      */
589     function setApprovalForAll(address operator, bool _approved) external;
590 
591     /**
592      * @dev Returns the account approved for `tokenId` token.
593      *
594      * Requirements:
595      *
596      * - `tokenId` must exist.
597      */
598     function getApproved(uint256 tokenId) external view returns (address operator);
599 
600     /**
601      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
602      *
603      * See {setApprovalForAll}
604      */
605     function isApprovedForAll(address owner, address operator) external view returns (bool);
606 
607     // ==============================
608     //        IERC721Metadata
609     // ==============================
610 
611     /**
612      * @dev Returns the token collection name.
613      */
614     function name() external view returns (string memory);
615 
616     /**
617      * @dev Returns the token collection symbol.
618      */
619     function symbol() external view returns (string memory);
620 
621     /**
622      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
623      */
624     function tokenURI(uint256 tokenId) external view returns (string memory);
625 }
626 
627 // File: erc721a/contracts/ERC721A.sol
628 
629 
630 // ERC721A Contracts v4.0.0
631 // Creator: Chiru Labs
632 
633 pragma solidity ^0.8.4;
634 
635 
636 /**
637  * @dev ERC721 token receiver interface.
638  */
639 interface ERC721A__IERC721Receiver {
640     function onERC721Received(
641         address operator,
642         address from,
643         uint256 tokenId,
644         bytes calldata data
645     ) external returns (bytes4);
646 }
647 
648 /**
649  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
650  * the Metadata extension. Built to optimize for lower gas during batch mints.
651  *
652  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
653  *
654  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
655  *
656  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
657  */
658 contract ERC721A is IERC721A {
659     // Mask of an entry in packed address data.
660     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
661 
662     // The bit position of `numberMinted` in packed address data.
663     uint256 private constant BITPOS_NUMBER_MINTED = 64;
664 
665     // The bit position of `numberBurned` in packed address data.
666     uint256 private constant BITPOS_NUMBER_BURNED = 128;
667 
668     // The bit position of `aux` in packed address data.
669     uint256 private constant BITPOS_AUX = 192;
670 
671     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
672     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
673 
674     // The bit position of `startTimestamp` in packed ownership.
675     uint256 private constant BITPOS_START_TIMESTAMP = 160;
676 
677     // The bit mask of the `burned` bit in packed ownership.
678     uint256 private constant BITMASK_BURNED = 1 << 224;
679     
680     // The bit position of the `nextInitialized` bit in packed ownership.
681     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
682 
683     // The bit mask of the `nextInitialized` bit in packed ownership.
684     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
685 
686     // The tokenId of the next token to be minted.
687     uint256 private _currentIndex;
688 
689     // The number of tokens burned.
690     uint256 private _burnCounter;
691 
692     // Token name
693     string private _name;
694 
695     // Token symbol
696     string private _symbol;
697 
698     // Mapping from token ID to ownership details
699     // An empty struct value does not necessarily mean the token is unowned.
700     // See `_packedOwnershipOf` implementation for details.
701     //
702     // Bits Layout:
703     // - [0..159]   `addr`
704     // - [160..223] `startTimestamp`
705     // - [224]      `burned`
706     // - [225]      `nextInitialized`
707     mapping(uint256 => uint256) private _packedOwnerships;
708 
709     // Mapping owner address to address data.
710     //
711     // Bits Layout:
712     // - [0..63]    `balance`
713     // - [64..127]  `numberMinted`
714     // - [128..191] `numberBurned`
715     // - [192..255] `aux`
716     mapping(address => uint256) private _packedAddressData;
717 
718     // Mapping from token ID to approved address.
719     mapping(uint256 => address) private _tokenApprovals;
720 
721     // Mapping from owner to operator approvals
722     mapping(address => mapping(address => bool)) private _operatorApprovals;
723 
724     constructor(string memory name_, string memory symbol_) {
725         _name = name_;
726         _symbol = symbol_;
727         _currentIndex = _startTokenId();
728     }
729 
730     /**
731      * @dev Returns the starting token ID. 
732      * To change the starting token ID, please override this function.
733      */
734     function _startTokenId() internal view virtual returns (uint256) {
735         return 0;
736     }
737 
738     /**
739      * @dev Returns the next token ID to be minted.
740      */
741     function _nextTokenId() internal view returns (uint256) {
742         return _currentIndex;
743     }
744 
745     /**
746      * @dev Returns the total number of tokens in existence.
747      * Burned tokens will reduce the count. 
748      * To get the total number of tokens minted, please see `_totalMinted`.
749      */
750     function totalSupply() public view override returns (uint256) {
751         // Counter underflow is impossible as _burnCounter cannot be incremented
752         // more than `_currentIndex - _startTokenId()` times.
753         unchecked {
754             return _currentIndex - _burnCounter - _startTokenId();
755         }
756     }
757 
758     /**
759      * @dev Returns the total amount of tokens minted in the contract.
760      */
761     function _totalMinted() internal view returns (uint256) {
762         // Counter underflow is impossible as _currentIndex does not decrement,
763         // and it is initialized to `_startTokenId()`
764         unchecked {
765             return _currentIndex - _startTokenId();
766         }
767     }
768 
769     /**
770      * @dev Returns the total number of tokens burned.
771      */
772     function _totalBurned() internal view returns (uint256) {
773         return _burnCounter;
774     }
775 
776     /**
777      * @dev See {IERC165-supportsInterface}.
778      */
779     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
780         // The interface IDs are constants representing the first 4 bytes of the XOR of
781         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
782         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
783         return
784             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
785             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
786             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
787     }
788 
789     /**
790      * @dev See {IERC721-balanceOf}.
791      */
792     function balanceOf(address owner) public view override returns (uint256) {
793         if (owner == address(0)) revert BalanceQueryForZeroAddress();
794         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
795     }
796 
797     /**
798      * Returns the number of tokens minted by `owner`.
799      */
800     function _numberMinted(address owner) internal view returns (uint256) {
801         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
802     }
803 
804     /**
805      * Returns the number of tokens burned by or on behalf of `owner`.
806      */
807     function _numberBurned(address owner) internal view returns (uint256) {
808         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
809     }
810 
811     /**
812      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
813      */
814     function _getAux(address owner) internal view returns (uint64) {
815         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
816     }
817 
818     /**
819      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
820      * If there are multiple variables, please pack them into a uint64.
821      */
822     function _setAux(address owner, uint64 aux) internal {
823         uint256 packed = _packedAddressData[owner];
824         uint256 auxCasted;
825         assembly { // Cast aux without masking.
826             auxCasted := aux
827         }
828         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
829         _packedAddressData[owner] = packed;
830     }
831 
832     /**
833      * Returns the packed ownership data of `tokenId`.
834      */
835     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
836         uint256 curr = tokenId;
837 
838         unchecked {
839             if (_startTokenId() <= curr)
840                 if (curr < _currentIndex) {
841                     uint256 packed = _packedOwnerships[curr];
842                     // If not burned.
843                     if (packed & BITMASK_BURNED == 0) {
844                         // Invariant:
845                         // There will always be an ownership that has an address and is not burned
846                         // before an ownership that does not have an address and is not burned.
847                         // Hence, curr will not underflow.
848                         //
849                         // We can directly compare the packed value.
850                         // If the address is zero, packed is zero.
851                         while (packed == 0) {
852                             packed = _packedOwnerships[--curr];
853                         }
854                         return packed;
855                     }
856                 }
857         }
858         revert OwnerQueryForNonexistentToken();
859     }
860 
861     /**
862      * Returns the unpacked `TokenOwnership` struct from `packed`.
863      */
864     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
865         ownership.addr = address(uint160(packed));
866         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
867         ownership.burned = packed & BITMASK_BURNED != 0;
868     }
869 
870     /**
871      * Returns the unpacked `TokenOwnership` struct at `index`.
872      */
873     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
874         return _unpackedOwnership(_packedOwnerships[index]);
875     }
876 
877     /**
878      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
879      */
880     function _initializeOwnershipAt(uint256 index) internal {
881         if (_packedOwnerships[index] == 0) {
882             _packedOwnerships[index] = _packedOwnershipOf(index);
883         }
884     }
885 
886     /**
887      * Gas spent here starts off proportional to the maximum mint batch size.
888      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
889      */
890     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
891         return _unpackedOwnership(_packedOwnershipOf(tokenId));
892     }
893 
894     /**
895      * @dev See {IERC721-ownerOf}.
896      */
897     function ownerOf(uint256 tokenId) public view override returns (address) {
898         return address(uint160(_packedOwnershipOf(tokenId)));
899     }
900 
901     /**
902      * @dev See {IERC721Metadata-name}.
903      */
904     function name() public view virtual override returns (string memory) {
905         return _name;
906     }
907 
908     /**
909      * @dev See {IERC721Metadata-symbol}.
910      */
911     function symbol() public view virtual override returns (string memory) {
912         return _symbol;
913     }
914 
915     /**
916      * @dev See {IERC721Metadata-tokenURI}.
917      */
918     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
919         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
920 
921         string memory baseURI = _baseURI();
922         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
923     }
924 
925     /**
926      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
927      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
928      * by default, can be overriden in child contracts.
929      */
930     function _baseURI() internal view virtual returns (string memory) {
931         return '';
932     }
933 
934     /**
935      * @dev Casts the address to uint256 without masking.
936      */
937     function _addressToUint256(address value) private pure returns (uint256 result) {
938         assembly {
939             result := value
940         }
941     }
942 
943     /**
944      * @dev Casts the boolean to uint256 without branching.
945      */
946     function _boolToUint256(bool value) private pure returns (uint256 result) {
947         assembly {
948             result := value
949         }
950     }
951 
952     /**
953      * @dev See {IERC721-approve}.
954      */
955     function approve(address to, uint256 tokenId) public override {
956         address owner = address(uint160(_packedOwnershipOf(tokenId)));
957         if (to == owner) revert ApprovalToCurrentOwner();
958 
959         if (_msgSenderERC721A() != owner)
960             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
961                 revert ApprovalCallerNotOwnerNorApproved();
962             }
963 
964         _tokenApprovals[tokenId] = to;
965         emit Approval(owner, to, tokenId);
966     }
967 
968     /**
969      * @dev See {IERC721-getApproved}.
970      */
971     function getApproved(uint256 tokenId) public view override returns (address) {
972         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
973 
974         return _tokenApprovals[tokenId];
975     }
976 
977     /**
978      * @dev See {IERC721-setApprovalForAll}.
979      */
980     function setApprovalForAll(address operator, bool approved) public virtual override {
981         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
982 
983         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
984         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
985     }
986 
987     /**
988      * @dev See {IERC721-isApprovedForAll}.
989      */
990     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
991         return _operatorApprovals[owner][operator];
992     }
993 
994     /**
995      * @dev See {IERC721-transferFrom}.
996      */
997     function transferFrom(
998         address from,
999         address to,
1000         uint256 tokenId
1001     ) public virtual override {
1002         _transfer(from, to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-safeTransferFrom}.
1007      */
1008     function safeTransferFrom(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) public virtual override {
1013         safeTransferFrom(from, to, tokenId, '');
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-safeTransferFrom}.
1018      */
1019     function safeTransferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes memory _data
1024     ) public virtual override {
1025         _transfer(from, to, tokenId);
1026         if (to.code.length != 0)
1027             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1028                 revert TransferToNonERC721ReceiverImplementer();
1029             }
1030     }
1031 
1032     /**
1033      * @dev Returns whether `tokenId` exists.
1034      *
1035      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1036      *
1037      * Tokens start existing when they are minted (`_mint`),
1038      */
1039     function _exists(uint256 tokenId) internal view returns (bool) {
1040         return
1041             _startTokenId() <= tokenId &&
1042             tokenId < _currentIndex && // If within bounds,
1043             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1044     }
1045 
1046     /**
1047      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1048      */
1049     function _safeMint(address to, uint256 quantity) internal {
1050         _safeMint(to, quantity, '');
1051     }
1052 
1053     /**
1054      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1055      *
1056      * Requirements:
1057      *
1058      * - If `to` refers to a smart contract, it must implement
1059      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1060      * - `quantity` must be greater than 0.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function _safeMint(
1065         address to,
1066         uint256 quantity,
1067         bytes memory _data
1068     ) internal {
1069         uint256 startTokenId = _currentIndex;
1070         if (to == address(0)) revert MintToZeroAddress();
1071         if (quantity == 0) revert MintZeroQuantity();
1072 
1073         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1074 
1075         // Overflows are incredibly unrealistic.
1076         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1077         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1078         unchecked {
1079             // Updates:
1080             // - `balance += quantity`.
1081             // - `numberMinted += quantity`.
1082             //
1083             // We can directly add to the balance and number minted.
1084             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1085 
1086             // Updates:
1087             // - `address` to the owner.
1088             // - `startTimestamp` to the timestamp of minting.
1089             // - `burned` to `false`.
1090             // - `nextInitialized` to `quantity == 1`.
1091             _packedOwnerships[startTokenId] =
1092                 _addressToUint256(to) |
1093                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1094                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1095 
1096             uint256 updatedIndex = startTokenId;
1097             uint256 end = updatedIndex + quantity;
1098 
1099             if (to.code.length != 0) {
1100                 do {
1101                     emit Transfer(address(0), to, updatedIndex);
1102                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1103                         revert TransferToNonERC721ReceiverImplementer();
1104                     }
1105                 } while (updatedIndex < end);
1106                 // Reentrancy protection
1107                 if (_currentIndex != startTokenId) revert();
1108             } else {
1109                 do {
1110                     emit Transfer(address(0), to, updatedIndex++);
1111                 } while (updatedIndex < end);
1112             }
1113             _currentIndex = updatedIndex;
1114         }
1115         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1116     }
1117 
1118     /**
1119      * @dev Mints `quantity` tokens and transfers them to `to`.
1120      *
1121      * Requirements:
1122      *
1123      * - `to` cannot be the zero address.
1124      * - `quantity` must be greater than 0.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _mint(address to, uint256 quantity) internal {
1129         uint256 startTokenId = _currentIndex;
1130         if (to == address(0)) revert MintToZeroAddress();
1131         if (quantity == 0) revert MintZeroQuantity();
1132 
1133         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1134 
1135         // Overflows are incredibly unrealistic.
1136         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1137         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1138         unchecked {
1139             // Updates:
1140             // - `balance += quantity`.
1141             // - `numberMinted += quantity`.
1142             //
1143             // We can directly add to the balance and number minted.
1144             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1145 
1146             // Updates:
1147             // - `address` to the owner.
1148             // - `startTimestamp` to the timestamp of minting.
1149             // - `burned` to `false`.
1150             // - `nextInitialized` to `quantity == 1`.
1151             _packedOwnerships[startTokenId] =
1152                 _addressToUint256(to) |
1153                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1154                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1155 
1156             uint256 updatedIndex = startTokenId;
1157             uint256 end = updatedIndex + quantity;
1158 
1159             do {
1160                 emit Transfer(address(0), to, updatedIndex++);
1161             } while (updatedIndex < end);
1162 
1163             _currentIndex = updatedIndex;
1164         }
1165         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1166     }
1167 
1168     /**
1169      * @dev Transfers `tokenId` from `from` to `to`.
1170      *
1171      * Requirements:
1172      *
1173      * - `to` cannot be the zero address.
1174      * - `tokenId` token must be owned by `from`.
1175      *
1176      * Emits a {Transfer} event.
1177      */
1178     function _transfer(
1179         address from,
1180         address to,
1181         uint256 tokenId
1182     ) private {
1183         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1184 
1185         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1186 
1187         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1188             isApprovedForAll(from, _msgSenderERC721A()) ||
1189             getApproved(tokenId) == _msgSenderERC721A());
1190 
1191         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1192         if (to == address(0)) revert TransferToZeroAddress();
1193 
1194         _beforeTokenTransfers(from, to, tokenId, 1);
1195 
1196         // Clear approvals from the previous owner.
1197         delete _tokenApprovals[tokenId];
1198 
1199         // Underflow of the sender's balance is impossible because we check for
1200         // ownership above and the recipient's balance can't realistically overflow.
1201         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1202         unchecked {
1203             // We can directly increment and decrement the balances.
1204             --_packedAddressData[from]; // Updates: `balance -= 1`.
1205             ++_packedAddressData[to]; // Updates: `balance += 1`.
1206 
1207             // Updates:
1208             // - `address` to the next owner.
1209             // - `startTimestamp` to the timestamp of transfering.
1210             // - `burned` to `false`.
1211             // - `nextInitialized` to `true`.
1212             _packedOwnerships[tokenId] =
1213                 _addressToUint256(to) |
1214                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1215                 BITMASK_NEXT_INITIALIZED;
1216 
1217             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1218             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1219                 uint256 nextTokenId = tokenId + 1;
1220                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1221                 if (_packedOwnerships[nextTokenId] == 0) {
1222                     // If the next slot is within bounds.
1223                     if (nextTokenId != _currentIndex) {
1224                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1225                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1226                     }
1227                 }
1228             }
1229         }
1230 
1231         emit Transfer(from, to, tokenId);
1232         _afterTokenTransfers(from, to, tokenId, 1);
1233     }
1234 
1235     /**
1236      * @dev Equivalent to `_burn(tokenId, false)`.
1237      */
1238     function _burn(uint256 tokenId) internal virtual {
1239         _burn(tokenId, false);
1240     }
1241 
1242     /**
1243      * @dev Destroys `tokenId`.
1244      * The approval is cleared when the token is burned.
1245      *
1246      * Requirements:
1247      *
1248      * - `tokenId` must exist.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1253         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1254 
1255         address from = address(uint160(prevOwnershipPacked));
1256 
1257         if (approvalCheck) {
1258             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1259                 isApprovedForAll(from, _msgSenderERC721A()) ||
1260                 getApproved(tokenId) == _msgSenderERC721A());
1261 
1262             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1263         }
1264 
1265         _beforeTokenTransfers(from, address(0), tokenId, 1);
1266 
1267         // Clear approvals from the previous owner.
1268         delete _tokenApprovals[tokenId];
1269 
1270         // Underflow of the sender's balance is impossible because we check for
1271         // ownership above and the recipient's balance can't realistically overflow.
1272         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1273         unchecked {
1274             // Updates:
1275             // - `balance -= 1`.
1276             // - `numberBurned += 1`.
1277             //
1278             // We can directly decrement the balance, and increment the number burned.
1279             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1280             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1281 
1282             // Updates:
1283             // - `address` to the last owner.
1284             // - `startTimestamp` to the timestamp of burning.
1285             // - `burned` to `true`.
1286             // - `nextInitialized` to `true`.
1287             _packedOwnerships[tokenId] =
1288                 _addressToUint256(from) |
1289                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1290                 BITMASK_BURNED | 
1291                 BITMASK_NEXT_INITIALIZED;
1292 
1293             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1294             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1295                 uint256 nextTokenId = tokenId + 1;
1296                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1297                 if (_packedOwnerships[nextTokenId] == 0) {
1298                     // If the next slot is within bounds.
1299                     if (nextTokenId != _currentIndex) {
1300                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1301                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1302                     }
1303                 }
1304             }
1305         }
1306 
1307         emit Transfer(from, address(0), tokenId);
1308         _afterTokenTransfers(from, address(0), tokenId, 1);
1309 
1310         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1311         unchecked {
1312             _burnCounter++;
1313         }
1314     }
1315 
1316     /**
1317      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1318      *
1319      * @param from address representing the previous owner of the given token ID
1320      * @param to target address that will receive the tokens
1321      * @param tokenId uint256 ID of the token to be transferred
1322      * @param _data bytes optional data to send along with the call
1323      * @return bool whether the call correctly returned the expected magic value
1324      */
1325     function _checkContractOnERC721Received(
1326         address from,
1327         address to,
1328         uint256 tokenId,
1329         bytes memory _data
1330     ) private returns (bool) {
1331         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1332             bytes4 retval
1333         ) {
1334             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1335         } catch (bytes memory reason) {
1336             if (reason.length == 0) {
1337                 revert TransferToNonERC721ReceiverImplementer();
1338             } else {
1339                 assembly {
1340                     revert(add(32, reason), mload(reason))
1341                 }
1342             }
1343         }
1344     }
1345 
1346     /**
1347      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1348      * And also called before burning one token.
1349      *
1350      * startTokenId - the first token id to be transferred
1351      * quantity - the amount to be transferred
1352      *
1353      * Calling conditions:
1354      *
1355      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1356      * transferred to `to`.
1357      * - When `from` is zero, `tokenId` will be minted for `to`.
1358      * - When `to` is zero, `tokenId` will be burned by `from`.
1359      * - `from` and `to` are never both zero.
1360      */
1361     function _beforeTokenTransfers(
1362         address from,
1363         address to,
1364         uint256 startTokenId,
1365         uint256 quantity
1366     ) internal virtual {}
1367 
1368     /**
1369      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1370      * minting.
1371      * And also called after one token has been burned.
1372      *
1373      * startTokenId - the first token id to be transferred
1374      * quantity - the amount to be transferred
1375      *
1376      * Calling conditions:
1377      *
1378      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1379      * transferred to `to`.
1380      * - When `from` is zero, `tokenId` has been minted for `to`.
1381      * - When `to` is zero, `tokenId` has been burned by `from`.
1382      * - `from` and `to` are never both zero.
1383      */
1384     function _afterTokenTransfers(
1385         address from,
1386         address to,
1387         uint256 startTokenId,
1388         uint256 quantity
1389     ) internal virtual {}
1390 
1391     /**
1392      * @dev Returns the message sender (defaults to `msg.sender`).
1393      *
1394      * If you are writing GSN compatible contracts, you need to override this function.
1395      */
1396     function _msgSenderERC721A() internal view virtual returns (address) {
1397         return msg.sender;
1398     }
1399 
1400     /**
1401      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1402      */
1403     function _toString(uint256 value) internal pure returns (string memory ptr) {
1404         assembly {
1405             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1406             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1407             // We will need 1 32-byte word to store the length, 
1408             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1409             ptr := add(mload(0x40), 128)
1410             // Update the free memory pointer to allocate.
1411             mstore(0x40, ptr)
1412 
1413             // Cache the end of the memory to calculate the length later.
1414             let end := ptr
1415 
1416             // We write the string from the rightmost digit to the leftmost digit.
1417             // The following is essentially a do-while loop that also handles the zero case.
1418             // Costs a bit more than early returning for the zero case,
1419             // but cheaper in terms of deployment and overall runtime costs.
1420             for { 
1421                 // Initialize and perform the first pass without check.
1422                 let temp := value
1423                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1424                 ptr := sub(ptr, 1)
1425                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1426                 mstore8(ptr, add(48, mod(temp, 10)))
1427                 temp := div(temp, 10)
1428             } temp { 
1429                 // Keep dividing `temp` until zero.
1430                 temp := div(temp, 10)
1431             } { // Body of the for loop.
1432                 ptr := sub(ptr, 1)
1433                 mstore8(ptr, add(48, mod(temp, 10)))
1434             }
1435             
1436             let length := sub(end, ptr)
1437             // Move the pointer 32 bytes leftwards to make room for the length.
1438             ptr := sub(ptr, 32)
1439             // Store the length.
1440             mstore(ptr, length)
1441         }
1442     }
1443 }
1444 
1445 // File: @openzeppelin/contracts/utils/Context.sol
1446 
1447 
1448 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1449 
1450 pragma solidity ^0.8.0;
1451 
1452 /**
1453  * @dev Provides information about the current execution context, including the
1454  * sender of the transaction and its data. While these are generally available
1455  * via msg.sender and msg.data, they should not be accessed in such a direct
1456  * manner, since when dealing with meta-transactions the account sending and
1457  * paying for execution may not be the actual sender (as far as an application
1458  * is concerned).
1459  *
1460  * This contract is only required for intermediate, library-like contracts.
1461  */
1462 abstract contract Context {
1463     function _msgSender() internal view virtual returns (address) {
1464         return msg.sender;
1465     }
1466 
1467     function _msgData() internal view virtual returns (bytes calldata) {
1468         return msg.data;
1469     }
1470 }
1471 
1472 // File: @openzeppelin/contracts/access/Ownable.sol
1473 
1474 
1475 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1476 
1477 pragma solidity ^0.8.0;
1478 
1479 
1480 /**
1481  * @dev Contract module which provides a basic access control mechanism, where
1482  * there is an account (an owner) that can be granted exclusive access to
1483  * specific functions.
1484  *
1485  * By default, the owner account will be the one that deploys the contract. This
1486  * can later be changed with {transferOwnership}.
1487  *
1488  * This module is used through inheritance. It will make available the modifier
1489  * `onlyOwner`, which can be applied to your functions to restrict their use to
1490  * the owner.
1491  */
1492 abstract contract Ownable is Context {
1493     address private _owner;
1494 
1495     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1496 
1497     /**
1498      * @dev Initializes the contract setting the deployer as the initial owner.
1499      */
1500     constructor() {
1501         _transferOwnership(_msgSender());
1502     }
1503 
1504     /**
1505      * @dev Returns the address of the current owner.
1506      */
1507     function owner() public view virtual returns (address) {
1508         return _owner;
1509     }
1510 
1511     /**
1512      * @dev Throws if called by any account other than the owner.
1513      */
1514     modifier onlyOwner() {
1515         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1516         _;
1517     }
1518 
1519     /**
1520      * @dev Leaves the contract without owner. It will not be possible to call
1521      * `onlyOwner` functions anymore. Can only be called by the current owner.
1522      *
1523      * NOTE: Renouncing ownership will leave the contract without an owner,
1524      * thereby removing any functionality that is only available to the owner.
1525      */
1526     function renounceOwnership() public virtual onlyOwner {
1527         _transferOwnership(address(0));
1528     }
1529 
1530     /**
1531      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1532      * Can only be called by the current owner.
1533      */
1534     function transferOwnership(address newOwner) public virtual onlyOwner {
1535         require(newOwner != address(0), "Ownable: new owner is the zero address");
1536         _transferOwnership(newOwner);
1537     }
1538 
1539     /**
1540      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1541      * Internal function without access restriction.
1542      */
1543     function _transferOwnership(address newOwner) internal virtual {
1544         address oldOwner = _owner;
1545         _owner = newOwner;
1546         emit OwnershipTransferred(oldOwner, newOwner);
1547     }
1548 }
1549 
1550 // File: contract.sol
1551 
1552 pragma solidity >=0.8.13 <0.9.0;
1553 
1554 
1555 contract TheMillenials is ERC721A, Ownable, ReentrancyGuard {
1556 
1557   using Strings for uint256;
1558 
1559 // ================== Variables Start =======================
1560     
1561   string public uri;
1562   uint256 public cost = 0.02 ether;
1563   uint256 public cost2 = 0.0369 ether;
1564   uint256 public supplyLimit = 9999;
1565   uint256 public maxLimitPerWallet = 10;
1566   bool public publicsale = true;
1567   string public names= "The Millenials";
1568   string public symbols= "TM";
1569   
1570   address team= 0xc10940C54e7125B0a1396B9C3de9adEc2f86dD92;
1571   address team_2= 0x5ed6f37ef694CC98B2289825818472eeCAe4a11E;
1572   uint256 public maxLimitPerWallet2 = 10;
1573   uint256 public maxMintAmountPerTx2 = 10;
1574   uint256 public whitelistsupply=3333;
1575   bool public whitelist = true;
1576   uint256 public whitelistsupplyminted;
1577   mapping (address => uint256) public addressminted;
1578   mapping(address=> bool) public freemintclaimed;
1579   bytes32 public root = 0xf6c2800c8c4378091cc0d33940e75252a864e7cc31f2e06ba6d4db0e73a00bec; 
1580 
1581     function checkValidity(bytes32[] calldata _merkleProof, address _addr) public view returns (bool){
1582         bytes32 leaf = keccak256(abi.encodePacked(_addr));
1583         require(MerkleProof.verify(_merkleProof, root, leaf), "You are not whitelisted");
1584         return true; // Or you can mint tokens here
1585     }
1586 
1587 function changeMerkleRoot(bytes32 _root) public onlyOwner{
1588     root=_root;
1589 }
1590 
1591 
1592 function mint(uint256 qty, bytes32[] calldata _merkleProof)public payable {
1593     require(totalSupply()+qty<=supplyLimit, "Max Supply Reached");
1594     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1595     bool a= MerkleProof.verify(_merkleProof, root, leaf);
1596     bool q=(whitelistsupplyminted+qty>whitelistsupply ? false : a);
1597         if(q==true){
1598     require(publicsale==true,"Sale hasn't began yet");        
1599     require(Cost(qty, msg.sender,_merkleProof)<= msg.value, "Not Enough Ether Sent");
1600     require(addressminted[msg.sender]+qty<=maxLimitPerWallet, "Max limit Reached");
1601     freemintclaimed[msg.sender]=true;
1602     whitelistsupplyminted= whitelistsupplyminted+qty;
1603     addressminted[msg.sender]= addressminted[msg.sender]+qty;
1604     _safeMint(msg.sender, qty);          
1605         }
1606        if(q==false) {
1607     uint256 newsupply=(whitelist ? 6667 : 9999);
1608     require(Cost(qty, msg.sender,_merkleProof)<= msg.value, "Not Enough Ether Sent");
1609     require(totalSupply()+qty<=newsupply, "Max Supply Reached");
1610     require(addressminted[msg.sender]+qty<=maxLimitPerWallet);
1611     addressminted[msg.sender]= addressminted[msg.sender]+qty;
1612     _safeMint(msg.sender, qty);                  
1613     }
1614     
1615     
1616 }
1617 
1618 
1619 function alreadymintedbyaddr(address _addr) public view returns (uint256){
1620             return addressminted[_addr];
1621 
1622 }
1623 
1624 function Cost(uint256 qty, address _addr,bytes32[] calldata _merkleProof)public view returns (uint256 costt){
1625        
1626        bytes32 leaf = keccak256(abi.encodePacked(_addr));
1627        bool a= MerkleProof.verify(_merkleProof, root, leaf);
1628            bool q=(whitelistsupplyminted+qty>whitelistsupply ? false : a);
1629  
1630             if(q==true){
1631 
1632             uint256 z=(freemintclaimed[_addr] ? qty : qty-1);
1633              return cost*z;   
1634                  }
1635     
1636           if (q==false) {
1637     return cost2*qty;
1638     }
1639 }
1640 
1641 // ================== Variables End =======================  
1642 
1643 // ================== Constructor Start =======================
1644 
1645   constructor(
1646   ) ERC721A(names, symbols)  {
1647     seturi("https://www.themillenials.wtf/unreveal/");
1648     _safeMint(msg.sender,10);
1649   }
1650 
1651 // ================== Constructor End =======================
1652 
1653 // ================== Mint Functions Start =======================
1654 
1655 
1656 
1657     function namechange(string memory namme) public  onlyOwner {
1658             names=namme;
1659   }
1660 
1661     function symbolchange(string memory symbolss) public  onlyOwner {
1662             symbols=symbolss;
1663   }
1664 
1665 function OwnerMint(address addresses, uint256 _amount ) public onlyOwner {
1666         require(_amount + totalSupply() <= supplyLimit, "Quantity Exceeds Tokens Available");
1667             _safeMint(addresses, _amount);
1668         }
1669  
1670 
1671 
1672 
1673   function changeowner(address ownerr) public onlyOwner {
1674 team=ownerr;
1675 
1676   }
1677 
1678    
1679 
1680   
1681   function changeteam_2(address _dev) public onlyOwner {
1682 team_2=_dev;
1683 
1684   }
1685     
1686 
1687 // ================== Mint Functions End =======================  
1688 
1689 // ================== Set Functions Start =======================
1690 
1691 // reveal
1692 
1693 
1694 // uri
1695   function seturi(string memory _uri) public onlyOwner {
1696     uri = _uri;
1697   }
1698 
1699 
1700 
1701 
1702 // sales toggle
1703   function setSaleStatus() public onlyOwner {
1704     publicsale = !publicsale;
1705   }
1706 
1707 
1708 // max per tx
1709 
1710 
1711 // pax per wallet
1712   function setmaxLimitPerWallet(uint256 _maxLimitPerWallet) public onlyOwner {
1713     maxLimitPerWallet = _maxLimitPerWallet;
1714   }
1715 
1716 
1717 function whitelistrequired() public onlyOwner{
1718 
1719  whitelist=!whitelist;
1720 
1721 }
1722 
1723 // price
1724 
1725  function setcost2(uint256 _cost2) public onlyOwner {
1726     cost2 = _cost2;
1727   }  
1728   function setcost(uint256 _cost) public onlyOwner {
1729     cost = _cost;
1730   }  
1731 
1732 // supply limit
1733   function setsupplyLimit(uint256 _supplyLimit) public onlyOwner {
1734     supplyLimit = _supplyLimit;
1735   }
1736 
1737 // ================== Set Functions End =======================
1738 
1739 // ================== Withdraw Function Start =======================
1740   
1741   function withdraw() public onlyOwner nonReentrant {
1742     //owner withdraw
1743                 uint256 _80percent = address(this).balance*80/100;
1744                 uint256 _20percent = address(this).balance*20/100;
1745                 require(payable(team_2).send(_20percent));    
1746                 require(payable(team).send(_80percent));
1747                
1748   }
1749 
1750 // ================== Withdraw Function End=======================  
1751 
1752 // ================== Read Functions Start =======================
1753  
1754 
1755 
1756 function tokensOfOwner(address owner) external view returns (uint256[] memory) {
1757     unchecked {
1758         uint256[] memory a = new uint256[](balanceOf(owner)); 
1759         uint256 end = _nextTokenId();
1760         uint256 tokenIdsIdx;
1761         address currOwnershipAddr;
1762         for (uint256 i; i < end; i++) {
1763             TokenOwnership memory ownership = _ownershipAt(i);
1764             if (ownership.burned) {
1765                 continue;
1766             }
1767             if (ownership.addr != address(0)) {
1768                 currOwnershipAddr = ownership.addr;
1769             }
1770             if (currOwnershipAddr == owner) {
1771                 a[tokenIdsIdx++] = i;
1772             }
1773         }
1774         return a;    
1775     }
1776 }
1777 
1778   function _startTokenId() internal view virtual override returns (uint256) {
1779     return 1;
1780   }
1781 
1782  
1783     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1784         
1785         return string(abi.encodePacked(_baseURI(), "", uint256(tokenId).toString()));
1786 
1787     }
1788 
1789   function _baseURI() internal view virtual override returns (string memory) {
1790     return uri;
1791   }
1792 
1793 // ================== Read Functions End =======================  
1794 
1795 }