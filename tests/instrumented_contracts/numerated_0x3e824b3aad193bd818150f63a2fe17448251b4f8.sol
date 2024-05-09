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
79 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev These functions deal with verification of Merkle Tree proofs.
88  *
89  * The proofs can be generated using the JavaScript library
90  * https://github.com/miguelmota/merkletreejs[merkletreejs].
91  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
92  *
93  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
94  *
95  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
96  * hashing, or use a hash function other than keccak256 for hashing leaves.
97  * This is because the concatenation of a sorted pair of internal nodes in
98  * the merkle tree could be reinterpreted as a leaf value.
99  */
100 library MerkleProof {
101     /**
102      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
103      * defined by `root`. For this, a `proof` must be provided, containing
104      * sibling hashes on the branch from the leaf to the root of the tree. Each
105      * pair of leaves and each pair of pre-images are assumed to be sorted.
106      */
107     function verify(
108         bytes32[] memory proof,
109         bytes32 root,
110         bytes32 leaf
111     ) internal pure returns (bool) {
112         return processProof(proof, leaf) == root;
113     }
114 
115     /**
116      * @dev Calldata version of {verify}
117      *
118      * _Available since v4.7._
119      */
120     function verifyCalldata(
121         bytes32[] calldata proof,
122         bytes32 root,
123         bytes32 leaf
124     ) internal pure returns (bool) {
125         return processProofCalldata(proof, leaf) == root;
126     }
127 
128     /**
129      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
130      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
131      * hash matches the root of the tree. When processing the proof, the pairs
132      * of leafs & pre-images are assumed to be sorted.
133      *
134      * _Available since v4.4._
135      */
136     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
137         bytes32 computedHash = leaf;
138         for (uint256 i = 0; i < proof.length; i++) {
139             computedHash = _hashPair(computedHash, proof[i]);
140         }
141         return computedHash;
142     }
143 
144     /**
145      * @dev Calldata version of {processProof}
146      *
147      * _Available since v4.7._
148      */
149     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
150         bytes32 computedHash = leaf;
151         for (uint256 i = 0; i < proof.length; i++) {
152             computedHash = _hashPair(computedHash, proof[i]);
153         }
154         return computedHash;
155     }
156 
157     /**
158      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
159      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
160      *
161      * _Available since v4.7._
162      */
163     function multiProofVerify(
164         bytes32[] memory proof,
165         bool[] memory proofFlags,
166         bytes32 root,
167         bytes32[] memory leaves
168     ) internal pure returns (bool) {
169         return processMultiProof(proof, proofFlags, leaves) == root;
170     }
171 
172     /**
173      * @dev Calldata version of {multiProofVerify}
174      *
175      * _Available since v4.7._
176      */
177     function multiProofVerifyCalldata(
178         bytes32[] calldata proof,
179         bool[] calldata proofFlags,
180         bytes32 root,
181         bytes32[] memory leaves
182     ) internal pure returns (bool) {
183         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
184     }
185 
186     /**
187      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
188      * consuming from one or the other at each step according to the instructions given by
189      * `proofFlags`.
190      *
191      * _Available since v4.7._
192      */
193     function processMultiProof(
194         bytes32[] memory proof,
195         bool[] memory proofFlags,
196         bytes32[] memory leaves
197     ) internal pure returns (bytes32 merkleRoot) {
198         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
199         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
200         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
201         // the merkle tree.
202         uint256 leavesLen = leaves.length;
203         uint256 totalHashes = proofFlags.length;
204 
205         // Check proof validity.
206         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
207 
208         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
209         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
210         bytes32[] memory hashes = new bytes32[](totalHashes);
211         uint256 leafPos = 0;
212         uint256 hashPos = 0;
213         uint256 proofPos = 0;
214         // At each step, we compute the next hash using two values:
215         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
216         //   get the next hash.
217         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
218         //   `proof` array.
219         for (uint256 i = 0; i < totalHashes; i++) {
220             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
221             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
222             hashes[i] = _hashPair(a, b);
223         }
224 
225         if (totalHashes > 0) {
226             return hashes[totalHashes - 1];
227         } else if (leavesLen > 0) {
228             return leaves[0];
229         } else {
230             return proof[0];
231         }
232     }
233 
234     /**
235      * @dev Calldata version of {processMultiProof}
236      *
237      * _Available since v4.7._
238      */
239     function processMultiProofCalldata(
240         bytes32[] calldata proof,
241         bool[] calldata proofFlags,
242         bytes32[] memory leaves
243     ) internal pure returns (bytes32 merkleRoot) {
244         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
245         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
246         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
247         // the merkle tree.
248         uint256 leavesLen = leaves.length;
249         uint256 totalHashes = proofFlags.length;
250 
251         // Check proof validity.
252         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
253 
254         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
255         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
256         bytes32[] memory hashes = new bytes32[](totalHashes);
257         uint256 leafPos = 0;
258         uint256 hashPos = 0;
259         uint256 proofPos = 0;
260         // At each step, we compute the next hash using two values:
261         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
262         //   get the next hash.
263         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
264         //   `proof` array.
265         for (uint256 i = 0; i < totalHashes; i++) {
266             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
267             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
268             hashes[i] = _hashPair(a, b);
269         }
270 
271         if (totalHashes > 0) {
272             return hashes[totalHashes - 1];
273         } else if (leavesLen > 0) {
274             return leaves[0];
275         } else {
276             return proof[0];
277         }
278     }
279 
280     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
281         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
282     }
283 
284     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
285         /// @solidity memory-safe-assembly
286         assembly {
287             mstore(0x00, a)
288             mstore(0x20, b)
289             value := keccak256(0x00, 0x40)
290         }
291     }
292 }
293 
294 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @dev Contract module that helps prevent reentrant calls to a function.
303  *
304  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
305  * available, which can be applied to functions to make sure there are no nested
306  * (reentrant) calls to them.
307  *
308  * Note that because there is a single `nonReentrant` guard, functions marked as
309  * `nonReentrant` may not call one another. This can be worked around by making
310  * those functions `private`, and then adding `external` `nonReentrant` entry
311  * points to them.
312  *
313  * TIP: If you would like to learn more about reentrancy and alternative ways
314  * to protect against it, check out our blog post
315  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
316  */
317 abstract contract ReentrancyGuard {
318     // Booleans are more expensive than uint256 or any type that takes up a full
319     // word because each write operation emits an extra SLOAD to first read the
320     // slot's contents, replace the bits taken up by the boolean, and then write
321     // back. This is the compiler's defense against contract upgrades and
322     // pointer aliasing, and it cannot be disabled.
323 
324     // The values being non-zero value makes deployment a bit more expensive,
325     // but in exchange the refund on every call to nonReentrant will be lower in
326     // amount. Since refunds are capped to a percentage of the total
327     // transaction's gas, it is best to keep them low in cases like this one, to
328     // increase the likelihood of the full refund coming into effect.
329     uint256 private constant _NOT_ENTERED = 1;
330     uint256 private constant _ENTERED = 2;
331 
332     uint256 private _status;
333 
334     constructor() {
335         _status = _NOT_ENTERED;
336     }
337 
338     /**
339      * @dev Prevents a contract from calling itself, directly or indirectly.
340      * Calling a `nonReentrant` function from another `nonReentrant`
341      * function is not supported. It is possible to prevent this from happening
342      * by making the `nonReentrant` function external, and making it call a
343      * `private` function that does the actual work.
344      */
345     modifier nonReentrant() {
346         // On the first call to nonReentrant, _notEntered will be true
347         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
348 
349         // Any calls to nonReentrant after this point will fail
350         _status = _ENTERED;
351 
352         _;
353 
354         // By storing the original value once again, a refund is triggered (see
355         // https://eips.ethereum.org/EIPS/eip-2200)
356         _status = _NOT_ENTERED;
357     }
358 }
359 
360 // File: @openzeppelin/contracts/utils/Context.sol
361 
362 
363 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 /**
368  * @dev Provides information about the current execution context, including the
369  * sender of the transaction and its data. While these are generally available
370  * via msg.sender and msg.data, they should not be accessed in such a direct
371  * manner, since when dealing with meta-transactions the account sending and
372  * paying for execution may not be the actual sender (as far as an application
373  * is concerned).
374  *
375  * This contract is only required for intermediate, library-like contracts.
376  */
377 abstract contract Context {
378     function _msgSender() internal view virtual returns (address) {
379         return msg.sender;
380     }
381 
382     function _msgData() internal view virtual returns (bytes calldata) {
383         return msg.data;
384     }
385 }
386 
387 // File: @openzeppelin/contracts/access/Ownable.sol
388 
389 
390 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 
395 /**
396  * @dev Contract module which provides a basic access control mechanism, where
397  * there is an account (an owner) that can be granted exclusive access to
398  * specific functions.
399  *
400  * By default, the owner account will be the one that deploys the contract. This
401  * can later be changed with {transferOwnership}.
402  *
403  * This module is used through inheritance. It will make available the modifier
404  * `onlyOwner`, which can be applied to your functions to restrict their use to
405  * the owner.
406  */
407 abstract contract Ownable is Context {
408     address private _owner;
409 
410     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
411 
412     /**
413      * @dev Initializes the contract setting the deployer as the initial owner.
414      */
415     constructor() {
416         _transferOwnership(_msgSender());
417     }
418 
419     /**
420      * @dev Throws if called by any account other than the owner.
421      */
422     modifier onlyOwner() {
423         _checkOwner();
424         _;
425     }
426 
427     /**
428      * @dev Returns the address of the current owner.
429      */
430     function owner() public view virtual returns (address) {
431         return _owner;
432     }
433 
434     /**
435      * @dev Throws if the sender is not the owner.
436      */
437     function _checkOwner() internal view virtual {
438         require(owner() == _msgSender(), "Ownable: caller is not the owner");
439     }
440 
441     /**
442      * @dev Leaves the contract without owner. It will not be possible to call
443      * `onlyOwner` functions anymore. Can only be called by the current owner.
444      *
445      * NOTE: Renouncing ownership will leave the contract without an owner,
446      * thereby removing any functionality that is only available to the owner.
447      */
448     function renounceOwnership() public virtual onlyOwner {
449         _transferOwnership(address(0));
450     }
451 
452     /**
453      * @dev Transfers ownership of the contract to a new account (`newOwner`).
454      * Can only be called by the current owner.
455      */
456     function transferOwnership(address newOwner) public virtual onlyOwner {
457         require(newOwner != address(0), "Ownable: new owner is the zero address");
458         _transferOwnership(newOwner);
459     }
460 
461     /**
462      * @dev Transfers ownership of the contract to a new account (`newOwner`).
463      * Internal function without access restriction.
464      */
465     function _transferOwnership(address newOwner) internal virtual {
466         address oldOwner = _owner;
467         _owner = newOwner;
468         emit OwnershipTransferred(oldOwner, newOwner);
469     }
470 }
471 
472 // File: erc721a/contracts/IERC721A.sol
473 
474 
475 // ERC721A Contracts v4.2.3
476 // Creator: Chiru Labs
477 
478 pragma solidity ^0.8.4;
479 
480 /**
481  * @dev Interface of ERC721A.
482  */
483 interface IERC721A {
484     /**
485      * The caller must own the token or be an approved operator.
486      */
487     error ApprovalCallerNotOwnerNorApproved();
488 
489     /**
490      * The token does not exist.
491      */
492     error ApprovalQueryForNonexistentToken();
493 
494     /**
495      * Cannot query the balance for the zero address.
496      */
497     error BalanceQueryForZeroAddress();
498 
499     /**
500      * Cannot mint to the zero address.
501      */
502     error MintToZeroAddress();
503 
504     /**
505      * The quantity of tokens minted must be more than zero.
506      */
507     error MintZeroQuantity();
508 
509     /**
510      * The token does not exist.
511      */
512     error OwnerQueryForNonexistentToken();
513 
514     /**
515      * The caller must own the token or be an approved operator.
516      */
517     error TransferCallerNotOwnerNorApproved();
518 
519     /**
520      * The token must be owned by `from`.
521      */
522     error TransferFromIncorrectOwner();
523 
524     /**
525      * Cannot safely transfer to a contract that does not implement the
526      * ERC721Receiver interface.
527      */
528     error TransferToNonERC721ReceiverImplementer();
529 
530     /**
531      * Cannot transfer to the zero address.
532      */
533     error TransferToZeroAddress();
534 
535     /**
536      * The token does not exist.
537      */
538     error URIQueryForNonexistentToken();
539 
540     /**
541      * The `quantity` minted with ERC2309 exceeds the safety limit.
542      */
543     error MintERC2309QuantityExceedsLimit();
544 
545     /**
546      * The `extraData` cannot be set on an unintialized ownership slot.
547      */
548     error OwnershipNotInitializedForExtraData();
549 
550     // =============================================================
551     //                            STRUCTS
552     // =============================================================
553 
554     struct TokenOwnership {
555         // The address of the owner.
556         address addr;
557         // Stores the start time of ownership with minimal overhead for tokenomics.
558         uint64 startTimestamp;
559         // Whether the token has been burned.
560         bool burned;
561         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
562         uint24 extraData;
563     }
564 
565     // =============================================================
566     //                         TOKEN COUNTERS
567     // =============================================================
568 
569     /**
570      * @dev Returns the total number of tokens in existence.
571      * Burned tokens will reduce the count.
572      * To get the total number of tokens minted, please see {_totalMinted}.
573      */
574     function totalSupply() external view returns (uint256);
575 
576     // =============================================================
577     //                            IERC165
578     // =============================================================
579 
580     /**
581      * @dev Returns true if this contract implements the interface defined by
582      * `interfaceId`. See the corresponding
583      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
584      * to learn more about how these ids are created.
585      *
586      * This function call must use less than 30000 gas.
587      */
588     function supportsInterface(bytes4 interfaceId) external view returns (bool);
589 
590     // =============================================================
591     //                            IERC721
592     // =============================================================
593 
594     /**
595      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
596      */
597     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
598 
599     /**
600      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
601      */
602     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
603 
604     /**
605      * @dev Emitted when `owner` enables or disables
606      * (`approved`) `operator` to manage all of its assets.
607      */
608     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
609 
610     /**
611      * @dev Returns the number of tokens in `owner`'s account.
612      */
613     function balanceOf(address owner) external view returns (uint256 balance);
614 
615     /**
616      * @dev Returns the owner of the `tokenId` token.
617      *
618      * Requirements:
619      *
620      * - `tokenId` must exist.
621      */
622     function ownerOf(uint256 tokenId) external view returns (address owner);
623 
624     /**
625      * @dev Safely transfers `tokenId` token from `from` to `to`,
626      * checking first that contract recipients are aware of the ERC721 protocol
627      * to prevent tokens from being forever locked.
628      *
629      * Requirements:
630      *
631      * - `from` cannot be the zero address.
632      * - `to` cannot be the zero address.
633      * - `tokenId` token must exist and be owned by `from`.
634      * - If the caller is not `from`, it must be have been allowed to move
635      * this token by either {approve} or {setApprovalForAll}.
636      * - If `to` refers to a smart contract, it must implement
637      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
638      *
639      * Emits a {Transfer} event.
640      */
641     function safeTransferFrom(
642         address from,
643         address to,
644         uint256 tokenId,
645         bytes calldata data
646     ) external payable;
647 
648     /**
649      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
650      */
651     function safeTransferFrom(
652         address from,
653         address to,
654         uint256 tokenId
655     ) external payable;
656 
657     /**
658      * @dev Transfers `tokenId` from `from` to `to`.
659      *
660      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
661      * whenever possible.
662      *
663      * Requirements:
664      *
665      * - `from` cannot be the zero address.
666      * - `to` cannot be the zero address.
667      * - `tokenId` token must be owned by `from`.
668      * - If the caller is not `from`, it must be approved to move this token
669      * by either {approve} or {setApprovalForAll}.
670      *
671      * Emits a {Transfer} event.
672      */
673     function transferFrom(
674         address from,
675         address to,
676         uint256 tokenId
677     ) external payable;
678 
679     /**
680      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
681      * The approval is cleared when the token is transferred.
682      *
683      * Only a single account can be approved at a time, so approving the
684      * zero address clears previous approvals.
685      *
686      * Requirements:
687      *
688      * - The caller must own the token or be an approved operator.
689      * - `tokenId` must exist.
690      *
691      * Emits an {Approval} event.
692      */
693     function approve(address to, uint256 tokenId) external payable;
694 
695     /**
696      * @dev Approve or remove `operator` as an operator for the caller.
697      * Operators can call {transferFrom} or {safeTransferFrom}
698      * for any token owned by the caller.
699      *
700      * Requirements:
701      *
702      * - The `operator` cannot be the caller.
703      *
704      * Emits an {ApprovalForAll} event.
705      */
706     function setApprovalForAll(address operator, bool _approved) external;
707 
708     /**
709      * @dev Returns the account approved for `tokenId` token.
710      *
711      * Requirements:
712      *
713      * - `tokenId` must exist.
714      */
715     function getApproved(uint256 tokenId) external view returns (address operator);
716 
717     /**
718      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
719      *
720      * See {setApprovalForAll}.
721      */
722     function isApprovedForAll(address owner, address operator) external view returns (bool);
723 
724     // =============================================================
725     //                        IERC721Metadata
726     // =============================================================
727 
728     /**
729      * @dev Returns the token collection name.
730      */
731     function name() external view returns (string memory);
732 
733     /**
734      * @dev Returns the token collection symbol.
735      */
736     function symbol() external view returns (string memory);
737 
738     /**
739      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
740      */
741     function tokenURI(uint256 tokenId) external view returns (string memory);
742 
743     // =============================================================
744     //                           IERC2309
745     // =============================================================
746 
747     /**
748      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
749      * (inclusive) is transferred from `from` to `to`, as defined in the
750      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
751      *
752      * See {_mintERC2309} for more details.
753      */
754     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
755 }
756 
757 // File: erc721a/contracts/ERC721A.sol
758 
759 
760 // ERC721A Contracts v4.2.3
761 // Creator: Chiru Labs
762 
763 pragma solidity ^0.8.4;
764 
765 
766 /**
767  * @dev Interface of ERC721 token receiver.
768  */
769 interface ERC721A__IERC721Receiver {
770     function onERC721Received(
771         address operator,
772         address from,
773         uint256 tokenId,
774         bytes calldata data
775     ) external returns (bytes4);
776 }
777 
778 /**
779  * @title ERC721A
780  *
781  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
782  * Non-Fungible Token Standard, including the Metadata extension.
783  * Optimized for lower gas during batch mints.
784  *
785  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
786  * starting from `_startTokenId()`.
787  *
788  * Assumptions:
789  *
790  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
791  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
792  */
793 contract ERC721A is IERC721A {
794     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
795     struct TokenApprovalRef {
796         address value;
797     }
798 
799     // =============================================================
800     //                           CONSTANTS
801     // =============================================================
802 
803     // Mask of an entry in packed address data.
804     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
805 
806     // The bit position of `numberMinted` in packed address data.
807     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
808 
809     // The bit position of `numberBurned` in packed address data.
810     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
811 
812     // The bit position of `aux` in packed address data.
813     uint256 private constant _BITPOS_AUX = 192;
814 
815     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
816     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
817 
818     // The bit position of `startTimestamp` in packed ownership.
819     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
820 
821     // The bit mask of the `burned` bit in packed ownership.
822     uint256 private constant _BITMASK_BURNED = 1 << 224;
823 
824     // The bit position of the `nextInitialized` bit in packed ownership.
825     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
826 
827     // The bit mask of the `nextInitialized` bit in packed ownership.
828     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
829 
830     // The bit position of `extraData` in packed ownership.
831     uint256 private constant _BITPOS_EXTRA_DATA = 232;
832 
833     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
834     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
835 
836     // The mask of the lower 160 bits for addresses.
837     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
838 
839     // The maximum `quantity` that can be minted with {_mintERC2309}.
840     // This limit is to prevent overflows on the address data entries.
841     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
842     // is required to cause an overflow, which is unrealistic.
843     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
844 
845     // The `Transfer` event signature is given by:
846     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
847     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
848         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
849 
850     // =============================================================
851     //                            STORAGE
852     // =============================================================
853 
854     // The next token ID to be minted.
855     uint256 private _currentIndex;
856 
857     // The number of tokens burned.
858     uint256 private _burnCounter;
859 
860     // Token name
861     string private _name;
862 
863     // Token symbol
864     string private _symbol;
865 
866     // Mapping from token ID to ownership details
867     // An empty struct value does not necessarily mean the token is unowned.
868     // See {_packedOwnershipOf} implementation for details.
869     //
870     // Bits Layout:
871     // - [0..159]   `addr`
872     // - [160..223] `startTimestamp`
873     // - [224]      `burned`
874     // - [225]      `nextInitialized`
875     // - [232..255] `extraData`
876     mapping(uint256 => uint256) private _packedOwnerships;
877 
878     // Mapping owner address to address data.
879     //
880     // Bits Layout:
881     // - [0..63]    `balance`
882     // - [64..127]  `numberMinted`
883     // - [128..191] `numberBurned`
884     // - [192..255] `aux`
885     mapping(address => uint256) private _packedAddressData;
886 
887     // Mapping from token ID to approved address.
888     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
889 
890     // Mapping from owner to operator approvals
891     mapping(address => mapping(address => bool)) private _operatorApprovals;
892 
893     // =============================================================
894     //                          CONSTRUCTOR
895     // =============================================================
896 
897     constructor(string memory name_, string memory symbol_) {
898         _name = name_;
899         _symbol = symbol_;
900         _currentIndex = _startTokenId();
901     }
902 
903     // =============================================================
904     //                   TOKEN COUNTING OPERATIONS
905     // =============================================================
906 
907     /**
908      * @dev Returns the starting token ID.
909      * To change the starting token ID, please override this function.
910      */
911     function _startTokenId() internal view virtual returns (uint256) {
912         return 0;
913     }
914 
915     /**
916      * @dev Returns the next token ID to be minted.
917      */
918     function _nextTokenId() internal view virtual returns (uint256) {
919         return _currentIndex;
920     }
921 
922     /**
923      * @dev Returns the total number of tokens in existence.
924      * Burned tokens will reduce the count.
925      * To get the total number of tokens minted, please see {_totalMinted}.
926      */
927     function totalSupply() public view virtual override returns (uint256) {
928         // Counter underflow is impossible as _burnCounter cannot be incremented
929         // more than `_currentIndex - _startTokenId()` times.
930         unchecked {
931             return _currentIndex - _burnCounter - _startTokenId();
932         }
933     }
934 
935     /**
936      * @dev Returns the total amount of tokens minted in the contract.
937      */
938     function _totalMinted() internal view virtual returns (uint256) {
939         // Counter underflow is impossible as `_currentIndex` does not decrement,
940         // and it is initialized to `_startTokenId()`.
941         unchecked {
942             return _currentIndex - _startTokenId();
943         }
944     }
945 
946     /**
947      * @dev Returns the total number of tokens burned.
948      */
949     function _totalBurned() internal view virtual returns (uint256) {
950         return _burnCounter;
951     }
952 
953     // =============================================================
954     //                    ADDRESS DATA OPERATIONS
955     // =============================================================
956 
957     /**
958      * @dev Returns the number of tokens in `owner`'s account.
959      */
960     function balanceOf(address owner) public view virtual override returns (uint256) {
961         if (owner == address(0)) revert BalanceQueryForZeroAddress();
962         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
963     }
964 
965     /**
966      * Returns the number of tokens minted by `owner`.
967      */
968     function _numberMinted(address owner) internal view returns (uint256) {
969         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
970     }
971 
972     /**
973      * Returns the number of tokens burned by or on behalf of `owner`.
974      */
975     function _numberBurned(address owner) internal view returns (uint256) {
976         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
977     }
978 
979     /**
980      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
981      */
982     function _getAux(address owner) internal view returns (uint64) {
983         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
984     }
985 
986     /**
987      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
988      * If there are multiple variables, please pack them into a uint64.
989      */
990     function _setAux(address owner, uint64 aux) internal virtual {
991         uint256 packed = _packedAddressData[owner];
992         uint256 auxCasted;
993         // Cast `aux` with assembly to avoid redundant masking.
994         assembly {
995             auxCasted := aux
996         }
997         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
998         _packedAddressData[owner] = packed;
999     }
1000 
1001     // =============================================================
1002     //                            IERC165
1003     // =============================================================
1004 
1005     /**
1006      * @dev Returns true if this contract implements the interface defined by
1007      * `interfaceId`. See the corresponding
1008      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1009      * to learn more about how these ids are created.
1010      *
1011      * This function call must use less than 30000 gas.
1012      */
1013     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1014         // The interface IDs are constants representing the first 4 bytes
1015         // of the XOR of all function selectors in the interface.
1016         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1017         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1018         return
1019             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1020             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1021             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1022     }
1023 
1024     // =============================================================
1025     //                        IERC721Metadata
1026     // =============================================================
1027 
1028     /**
1029      * @dev Returns the token collection name.
1030      */
1031     function name() public view virtual override returns (string memory) {
1032         return _name;
1033     }
1034 
1035     /**
1036      * @dev Returns the token collection symbol.
1037      */
1038     function symbol() public view virtual override returns (string memory) {
1039         return _symbol;
1040     }
1041 
1042     /**
1043      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1044      */
1045     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1046         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1047 
1048         string memory baseURI = _baseURI();
1049         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1050     }
1051 
1052     /**
1053      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1054      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1055      * by default, it can be overridden in child contracts.
1056      */
1057     function _baseURI() internal view virtual returns (string memory) {
1058         return '';
1059     }
1060 
1061     // =============================================================
1062     //                     OWNERSHIPS OPERATIONS
1063     // =============================================================
1064 
1065     /**
1066      * @dev Returns the owner of the `tokenId` token.
1067      *
1068      * Requirements:
1069      *
1070      * - `tokenId` must exist.
1071      */
1072     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1073         return address(uint160(_packedOwnershipOf(tokenId)));
1074     }
1075 
1076     /**
1077      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1078      * It gradually moves to O(1) as tokens get transferred around over time.
1079      */
1080     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1081         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1082     }
1083 
1084     /**
1085      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1086      */
1087     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1088         return _unpackedOwnership(_packedOwnerships[index]);
1089     }
1090 
1091     /**
1092      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1093      */
1094     function _initializeOwnershipAt(uint256 index) internal virtual {
1095         if (_packedOwnerships[index] == 0) {
1096             _packedOwnerships[index] = _packedOwnershipOf(index);
1097         }
1098     }
1099 
1100     /**
1101      * Returns the packed ownership data of `tokenId`.
1102      */
1103     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1104         uint256 curr = tokenId;
1105 
1106         unchecked {
1107             if (_startTokenId() <= curr)
1108                 if (curr < _currentIndex) {
1109                     uint256 packed = _packedOwnerships[curr];
1110                     // If not burned.
1111                     if (packed & _BITMASK_BURNED == 0) {
1112                         // Invariant:
1113                         // There will always be an initialized ownership slot
1114                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1115                         // before an unintialized ownership slot
1116                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1117                         // Hence, `curr` will not underflow.
1118                         //
1119                         // We can directly compare the packed value.
1120                         // If the address is zero, packed will be zero.
1121                         while (packed == 0) {
1122                             packed = _packedOwnerships[--curr];
1123                         }
1124                         return packed;
1125                     }
1126                 }
1127         }
1128         revert OwnerQueryForNonexistentToken();
1129     }
1130 
1131     /**
1132      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1133      */
1134     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1135         ownership.addr = address(uint160(packed));
1136         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1137         ownership.burned = packed & _BITMASK_BURNED != 0;
1138         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1139     }
1140 
1141     /**
1142      * @dev Packs ownership data into a single uint256.
1143      */
1144     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1145         assembly {
1146             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1147             owner := and(owner, _BITMASK_ADDRESS)
1148             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1149             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1150         }
1151     }
1152 
1153     /**
1154      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1155      */
1156     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1157         // For branchless setting of the `nextInitialized` flag.
1158         assembly {
1159             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1160             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1161         }
1162     }
1163 
1164     // =============================================================
1165     //                      APPROVAL OPERATIONS
1166     // =============================================================
1167 
1168     /**
1169      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1170      * The approval is cleared when the token is transferred.
1171      *
1172      * Only a single account can be approved at a time, so approving the
1173      * zero address clears previous approvals.
1174      *
1175      * Requirements:
1176      *
1177      * - The caller must own the token or be an approved operator.
1178      * - `tokenId` must exist.
1179      *
1180      * Emits an {Approval} event.
1181      */
1182     function approve(address to, uint256 tokenId) public payable virtual override {
1183         address owner = ownerOf(tokenId);
1184 
1185         if (_msgSenderERC721A() != owner)
1186             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1187                 revert ApprovalCallerNotOwnerNorApproved();
1188             }
1189 
1190         _tokenApprovals[tokenId].value = to;
1191         emit Approval(owner, to, tokenId);
1192     }
1193 
1194     /**
1195      * @dev Returns the account approved for `tokenId` token.
1196      *
1197      * Requirements:
1198      *
1199      * - `tokenId` must exist.
1200      */
1201     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1202         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1203 
1204         return _tokenApprovals[tokenId].value;
1205     }
1206 
1207     /**
1208      * @dev Approve or remove `operator` as an operator for the caller.
1209      * Operators can call {transferFrom} or {safeTransferFrom}
1210      * for any token owned by the caller.
1211      *
1212      * Requirements:
1213      *
1214      * - The `operator` cannot be the caller.
1215      *
1216      * Emits an {ApprovalForAll} event.
1217      */
1218     function setApprovalForAll(address operator, bool approved) public virtual override {
1219         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1220         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1221     }
1222 
1223     /**
1224      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1225      *
1226      * See {setApprovalForAll}.
1227      */
1228     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1229         return _operatorApprovals[owner][operator];
1230     }
1231 
1232     /**
1233      * @dev Returns whether `tokenId` exists.
1234      *
1235      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1236      *
1237      * Tokens start existing when they are minted. See {_mint}.
1238      */
1239     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1240         return
1241             _startTokenId() <= tokenId &&
1242             tokenId < _currentIndex && // If within bounds,
1243             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1244     }
1245 
1246     /**
1247      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1248      */
1249     function _isSenderApprovedOrOwner(
1250         address approvedAddress,
1251         address owner,
1252         address msgSender
1253     ) private pure returns (bool result) {
1254         assembly {
1255             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1256             owner := and(owner, _BITMASK_ADDRESS)
1257             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1258             msgSender := and(msgSender, _BITMASK_ADDRESS)
1259             // `msgSender == owner || msgSender == approvedAddress`.
1260             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1261         }
1262     }
1263 
1264     /**
1265      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1266      */
1267     function _getApprovedSlotAndAddress(uint256 tokenId)
1268         private
1269         view
1270         returns (uint256 approvedAddressSlot, address approvedAddress)
1271     {
1272         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1273         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1274         assembly {
1275             approvedAddressSlot := tokenApproval.slot
1276             approvedAddress := sload(approvedAddressSlot)
1277         }
1278     }
1279 
1280     // =============================================================
1281     //                      TRANSFER OPERATIONS
1282     // =============================================================
1283 
1284     /**
1285      * @dev Transfers `tokenId` from `from` to `to`.
1286      *
1287      * Requirements:
1288      *
1289      * - `from` cannot be the zero address.
1290      * - `to` cannot be the zero address.
1291      * - `tokenId` token must be owned by `from`.
1292      * - If the caller is not `from`, it must be approved to move this token
1293      * by either {approve} or {setApprovalForAll}.
1294      *
1295      * Emits a {Transfer} event.
1296      */
1297     function transferFrom(
1298         address from,
1299         address to,
1300         uint256 tokenId
1301     ) public payable virtual override {
1302         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1303 
1304         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1305 
1306         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1307 
1308         // The nested ifs save around 20+ gas over a compound boolean condition.
1309         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1310             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1311 
1312         if (to == address(0)) revert TransferToZeroAddress();
1313 
1314         _beforeTokenTransfers(from, to, tokenId, 1);
1315 
1316         // Clear approvals from the previous owner.
1317         assembly {
1318             if approvedAddress {
1319                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1320                 sstore(approvedAddressSlot, 0)
1321             }
1322         }
1323 
1324         // Underflow of the sender's balance is impossible because we check for
1325         // ownership above and the recipient's balance can't realistically overflow.
1326         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1327         unchecked {
1328             // We can directly increment and decrement the balances.
1329             --_packedAddressData[from]; // Updates: `balance -= 1`.
1330             ++_packedAddressData[to]; // Updates: `balance += 1`.
1331 
1332             // Updates:
1333             // - `address` to the next owner.
1334             // - `startTimestamp` to the timestamp of transfering.
1335             // - `burned` to `false`.
1336             // - `nextInitialized` to `true`.
1337             _packedOwnerships[tokenId] = _packOwnershipData(
1338                 to,
1339                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1340             );
1341 
1342             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1343             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1344                 uint256 nextTokenId = tokenId + 1;
1345                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1346                 if (_packedOwnerships[nextTokenId] == 0) {
1347                     // If the next slot is within bounds.
1348                     if (nextTokenId != _currentIndex) {
1349                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1350                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1351                     }
1352                 }
1353             }
1354         }
1355 
1356         emit Transfer(from, to, tokenId);
1357         _afterTokenTransfers(from, to, tokenId, 1);
1358     }
1359 
1360     /**
1361      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1362      */
1363     function safeTransferFrom(
1364         address from,
1365         address to,
1366         uint256 tokenId
1367     ) public payable virtual override {
1368         safeTransferFrom(from, to, tokenId, '');
1369     }
1370 
1371     /**
1372      * @dev Safely transfers `tokenId` token from `from` to `to`.
1373      *
1374      * Requirements:
1375      *
1376      * - `from` cannot be the zero address.
1377      * - `to` cannot be the zero address.
1378      * - `tokenId` token must exist and be owned by `from`.
1379      * - If the caller is not `from`, it must be approved to move this token
1380      * by either {approve} or {setApprovalForAll}.
1381      * - If `to` refers to a smart contract, it must implement
1382      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1383      *
1384      * Emits a {Transfer} event.
1385      */
1386     function safeTransferFrom(
1387         address from,
1388         address to,
1389         uint256 tokenId,
1390         bytes memory _data
1391     ) public payable virtual override {
1392         transferFrom(from, to, tokenId);
1393         if (to.code.length != 0)
1394             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1395                 revert TransferToNonERC721ReceiverImplementer();
1396             }
1397     }
1398 
1399     /**
1400      * @dev Hook that is called before a set of serially-ordered token IDs
1401      * are about to be transferred. This includes minting.
1402      * And also called before burning one token.
1403      *
1404      * `startTokenId` - the first token ID to be transferred.
1405      * `quantity` - the amount to be transferred.
1406      *
1407      * Calling conditions:
1408      *
1409      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1410      * transferred to `to`.
1411      * - When `from` is zero, `tokenId` will be minted for `to`.
1412      * - When `to` is zero, `tokenId` will be burned by `from`.
1413      * - `from` and `to` are never both zero.
1414      */
1415     function _beforeTokenTransfers(
1416         address from,
1417         address to,
1418         uint256 startTokenId,
1419         uint256 quantity
1420     ) internal virtual {}
1421 
1422     /**
1423      * @dev Hook that is called after a set of serially-ordered token IDs
1424      * have been transferred. This includes minting.
1425      * And also called after one token has been burned.
1426      *
1427      * `startTokenId` - the first token ID to be transferred.
1428      * `quantity` - the amount to be transferred.
1429      *
1430      * Calling conditions:
1431      *
1432      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1433      * transferred to `to`.
1434      * - When `from` is zero, `tokenId` has been minted for `to`.
1435      * - When `to` is zero, `tokenId` has been burned by `from`.
1436      * - `from` and `to` are never both zero.
1437      */
1438     function _afterTokenTransfers(
1439         address from,
1440         address to,
1441         uint256 startTokenId,
1442         uint256 quantity
1443     ) internal virtual {}
1444 
1445     /**
1446      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1447      *
1448      * `from` - Previous owner of the given token ID.
1449      * `to` - Target address that will receive the token.
1450      * `tokenId` - Token ID to be transferred.
1451      * `_data` - Optional data to send along with the call.
1452      *
1453      * Returns whether the call correctly returned the expected magic value.
1454      */
1455     function _checkContractOnERC721Received(
1456         address from,
1457         address to,
1458         uint256 tokenId,
1459         bytes memory _data
1460     ) private returns (bool) {
1461         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1462             bytes4 retval
1463         ) {
1464             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1465         } catch (bytes memory reason) {
1466             if (reason.length == 0) {
1467                 revert TransferToNonERC721ReceiverImplementer();
1468             } else {
1469                 assembly {
1470                     revert(add(32, reason), mload(reason))
1471                 }
1472             }
1473         }
1474     }
1475 
1476     // =============================================================
1477     //                        MINT OPERATIONS
1478     // =============================================================
1479 
1480     /**
1481      * @dev Mints `quantity` tokens and transfers them to `to`.
1482      *
1483      * Requirements:
1484      *
1485      * - `to` cannot be the zero address.
1486      * - `quantity` must be greater than 0.
1487      *
1488      * Emits a {Transfer} event for each mint.
1489      */
1490     function _mint(address to, uint256 quantity) internal virtual {
1491         uint256 startTokenId = _currentIndex;
1492         if (quantity == 0) revert MintZeroQuantity();
1493 
1494         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1495 
1496         // Overflows are incredibly unrealistic.
1497         // `balance` and `numberMinted` have a maximum limit of 2**64.
1498         // `tokenId` has a maximum limit of 2**256.
1499         unchecked {
1500             // Updates:
1501             // - `balance += quantity`.
1502             // - `numberMinted += quantity`.
1503             //
1504             // We can directly add to the `balance` and `numberMinted`.
1505             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1506 
1507             // Updates:
1508             // - `address` to the owner.
1509             // - `startTimestamp` to the timestamp of minting.
1510             // - `burned` to `false`.
1511             // - `nextInitialized` to `quantity == 1`.
1512             _packedOwnerships[startTokenId] = _packOwnershipData(
1513                 to,
1514                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1515             );
1516 
1517             uint256 toMasked;
1518             uint256 end = startTokenId + quantity;
1519 
1520             // Use assembly to loop and emit the `Transfer` event for gas savings.
1521             // The duplicated `log4` removes an extra check and reduces stack juggling.
1522             // The assembly, together with the surrounding Solidity code, have been
1523             // delicately arranged to nudge the compiler into producing optimized opcodes.
1524             assembly {
1525                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1526                 toMasked := and(to, _BITMASK_ADDRESS)
1527                 // Emit the `Transfer` event.
1528                 log4(
1529                     0, // Start of data (0, since no data).
1530                     0, // End of data (0, since no data).
1531                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1532                     0, // `address(0)`.
1533                     toMasked, // `to`.
1534                     startTokenId // `tokenId`.
1535                 )
1536 
1537                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1538                 // that overflows uint256 will make the loop run out of gas.
1539                 // The compiler will optimize the `iszero` away for performance.
1540                 for {
1541                     let tokenId := add(startTokenId, 1)
1542                 } iszero(eq(tokenId, end)) {
1543                     tokenId := add(tokenId, 1)
1544                 } {
1545                     // Emit the `Transfer` event. Similar to above.
1546                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1547                 }
1548             }
1549             if (toMasked == 0) revert MintToZeroAddress();
1550 
1551             _currentIndex = end;
1552         }
1553         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1554     }
1555 
1556     /**
1557      * @dev Mints `quantity` tokens and transfers them to `to`.
1558      *
1559      * This function is intended for efficient minting only during contract creation.
1560      *
1561      * It emits only one {ConsecutiveTransfer} as defined in
1562      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1563      * instead of a sequence of {Transfer} event(s).
1564      *
1565      * Calling this function outside of contract creation WILL make your contract
1566      * non-compliant with the ERC721 standard.
1567      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1568      * {ConsecutiveTransfer} event is only permissible during contract creation.
1569      *
1570      * Requirements:
1571      *
1572      * - `to` cannot be the zero address.
1573      * - `quantity` must be greater than 0.
1574      *
1575      * Emits a {ConsecutiveTransfer} event.
1576      */
1577     function _mintERC2309(address to, uint256 quantity) internal virtual {
1578         uint256 startTokenId = _currentIndex;
1579         if (to == address(0)) revert MintToZeroAddress();
1580         if (quantity == 0) revert MintZeroQuantity();
1581         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1582 
1583         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1584 
1585         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1586         unchecked {
1587             // Updates:
1588             // - `balance += quantity`.
1589             // - `numberMinted += quantity`.
1590             //
1591             // We can directly add to the `balance` and `numberMinted`.
1592             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1593 
1594             // Updates:
1595             // - `address` to the owner.
1596             // - `startTimestamp` to the timestamp of minting.
1597             // - `burned` to `false`.
1598             // - `nextInitialized` to `quantity == 1`.
1599             _packedOwnerships[startTokenId] = _packOwnershipData(
1600                 to,
1601                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1602             );
1603 
1604             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1605 
1606             _currentIndex = startTokenId + quantity;
1607         }
1608         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1609     }
1610 
1611     /**
1612      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1613      *
1614      * Requirements:
1615      *
1616      * - If `to` refers to a smart contract, it must implement
1617      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1618      * - `quantity` must be greater than 0.
1619      *
1620      * See {_mint}.
1621      *
1622      * Emits a {Transfer} event for each mint.
1623      */
1624     function _safeMint(
1625         address to,
1626         uint256 quantity,
1627         bytes memory _data
1628     ) internal virtual {
1629         _mint(to, quantity);
1630 
1631         unchecked {
1632             if (to.code.length != 0) {
1633                 uint256 end = _currentIndex;
1634                 uint256 index = end - quantity;
1635                 do {
1636                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1637                         revert TransferToNonERC721ReceiverImplementer();
1638                     }
1639                 } while (index < end);
1640                 // Reentrancy protection.
1641                 if (_currentIndex != end) revert();
1642             }
1643         }
1644     }
1645 
1646     /**
1647      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1648      */
1649     function _safeMint(address to, uint256 quantity) internal virtual {
1650         _safeMint(to, quantity, '');
1651     }
1652 
1653     // =============================================================
1654     //                        BURN OPERATIONS
1655     // =============================================================
1656 
1657     /**
1658      * @dev Equivalent to `_burn(tokenId, false)`.
1659      */
1660     function _burn(uint256 tokenId) internal virtual {
1661         _burn(tokenId, false);
1662     }
1663 
1664     /**
1665      * @dev Destroys `tokenId`.
1666      * The approval is cleared when the token is burned.
1667      *
1668      * Requirements:
1669      *
1670      * - `tokenId` must exist.
1671      *
1672      * Emits a {Transfer} event.
1673      */
1674     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1675         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1676 
1677         address from = address(uint160(prevOwnershipPacked));
1678 
1679         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1680 
1681         if (approvalCheck) {
1682             // The nested ifs save around 20+ gas over a compound boolean condition.
1683             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1684                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1685         }
1686 
1687         _beforeTokenTransfers(from, address(0), tokenId, 1);
1688 
1689         // Clear approvals from the previous owner.
1690         assembly {
1691             if approvedAddress {
1692                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1693                 sstore(approvedAddressSlot, 0)
1694             }
1695         }
1696 
1697         // Underflow of the sender's balance is impossible because we check for
1698         // ownership above and the recipient's balance can't realistically overflow.
1699         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1700         unchecked {
1701             // Updates:
1702             // - `balance -= 1`.
1703             // - `numberBurned += 1`.
1704             //
1705             // We can directly decrement the balance, and increment the number burned.
1706             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1707             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1708 
1709             // Updates:
1710             // - `address` to the last owner.
1711             // - `startTimestamp` to the timestamp of burning.
1712             // - `burned` to `true`.
1713             // - `nextInitialized` to `true`.
1714             _packedOwnerships[tokenId] = _packOwnershipData(
1715                 from,
1716                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1717             );
1718 
1719             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1720             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1721                 uint256 nextTokenId = tokenId + 1;
1722                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1723                 if (_packedOwnerships[nextTokenId] == 0) {
1724                     // If the next slot is within bounds.
1725                     if (nextTokenId != _currentIndex) {
1726                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1727                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1728                     }
1729                 }
1730             }
1731         }
1732 
1733         emit Transfer(from, address(0), tokenId);
1734         _afterTokenTransfers(from, address(0), tokenId, 1);
1735 
1736         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1737         unchecked {
1738             _burnCounter++;
1739         }
1740     }
1741 
1742     // =============================================================
1743     //                     EXTRA DATA OPERATIONS
1744     // =============================================================
1745 
1746     /**
1747      * @dev Directly sets the extra data for the ownership data `index`.
1748      */
1749     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1750         uint256 packed = _packedOwnerships[index];
1751         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1752         uint256 extraDataCasted;
1753         // Cast `extraData` with assembly to avoid redundant masking.
1754         assembly {
1755             extraDataCasted := extraData
1756         }
1757         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1758         _packedOwnerships[index] = packed;
1759     }
1760 
1761     /**
1762      * @dev Called during each token transfer to set the 24bit `extraData` field.
1763      * Intended to be overridden by the cosumer contract.
1764      *
1765      * `previousExtraData` - the value of `extraData` before transfer.
1766      *
1767      * Calling conditions:
1768      *
1769      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1770      * transferred to `to`.
1771      * - When `from` is zero, `tokenId` will be minted for `to`.
1772      * - When `to` is zero, `tokenId` will be burned by `from`.
1773      * - `from` and `to` are never both zero.
1774      */
1775     function _extraData(
1776         address from,
1777         address to,
1778         uint24 previousExtraData
1779     ) internal view virtual returns (uint24) {}
1780 
1781     /**
1782      * @dev Returns the next extra data for the packed ownership data.
1783      * The returned result is shifted into position.
1784      */
1785     function _nextExtraData(
1786         address from,
1787         address to,
1788         uint256 prevOwnershipPacked
1789     ) private view returns (uint256) {
1790         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1791         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1792     }
1793 
1794     // =============================================================
1795     //                       OTHER OPERATIONS
1796     // =============================================================
1797 
1798     /**
1799      * @dev Returns the message sender (defaults to `msg.sender`).
1800      *
1801      * If you are writing GSN compatible contracts, you need to override this function.
1802      */
1803     function _msgSenderERC721A() internal view virtual returns (address) {
1804         return msg.sender;
1805     }
1806 
1807     /**
1808      * @dev Converts a uint256 to its ASCII string decimal representation.
1809      */
1810     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1811         assembly {
1812             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1813             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1814             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1815             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1816             let m := add(mload(0x40), 0xa0)
1817             // Update the free memory pointer to allocate.
1818             mstore(0x40, m)
1819             // Assign the `str` to the end.
1820             str := sub(m, 0x20)
1821             // Zeroize the slot after the string.
1822             mstore(str, 0)
1823 
1824             // Cache the end of the memory to calculate the length later.
1825             let end := str
1826 
1827             // We write the string from rightmost digit to leftmost digit.
1828             // The following is essentially a do-while loop that also handles the zero case.
1829             // prettier-ignore
1830             for { let temp := value } 1 {} {
1831                 str := sub(str, 1)
1832                 // Write the character to the pointer.
1833                 // The ASCII index of the '0' character is 48.
1834                 mstore8(str, add(48, mod(temp, 10)))
1835                 // Keep dividing `temp` until zero.
1836                 temp := div(temp, 10)
1837                 // prettier-ignore
1838                 if iszero(temp) { break }
1839             }
1840 
1841             let length := sub(end, str)
1842             // Move the pointer 32 bytes leftwards to make room for the length.
1843             str := sub(str, 0x20)
1844             // Store the length.
1845             mstore(str, length)
1846         }
1847     }
1848 }
1849 
1850 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1851 
1852 
1853 // ERC721A Contracts v4.2.3
1854 // Creator: Chiru Labs
1855 
1856 pragma solidity ^0.8.4;
1857 
1858 
1859 /**
1860  * @dev Interface of ERC721AQueryable.
1861  */
1862 interface IERC721AQueryable is IERC721A {
1863     /**
1864      * Invalid query range (`start` >= `stop`).
1865      */
1866     error InvalidQueryRange();
1867 
1868     /**
1869      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1870      *
1871      * If the `tokenId` is out of bounds:
1872      *
1873      * - `addr = address(0)`
1874      * - `startTimestamp = 0`
1875      * - `burned = false`
1876      * - `extraData = 0`
1877      *
1878      * If the `tokenId` is burned:
1879      *
1880      * - `addr = <Address of owner before token was burned>`
1881      * - `startTimestamp = <Timestamp when token was burned>`
1882      * - `burned = true`
1883      * - `extraData = <Extra data when token was burned>`
1884      *
1885      * Otherwise:
1886      *
1887      * - `addr = <Address of owner>`
1888      * - `startTimestamp = <Timestamp of start of ownership>`
1889      * - `burned = false`
1890      * - `extraData = <Extra data at start of ownership>`
1891      */
1892     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1893 
1894     /**
1895      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1896      * See {ERC721AQueryable-explicitOwnershipOf}
1897      */
1898     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1899 
1900     /**
1901      * @dev Returns an array of token IDs owned by `owner`,
1902      * in the range [`start`, `stop`)
1903      * (i.e. `start <= tokenId < stop`).
1904      *
1905      * This function allows for tokens to be queried if the collection
1906      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1907      *
1908      * Requirements:
1909      *
1910      * - `start < stop`
1911      */
1912     function tokensOfOwnerIn(
1913         address owner,
1914         uint256 start,
1915         uint256 stop
1916     ) external view returns (uint256[] memory);
1917 
1918     /**
1919      * @dev Returns an array of token IDs owned by `owner`.
1920      *
1921      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1922      * It is meant to be called off-chain.
1923      *
1924      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1925      * multiple smaller scans if the collection is large enough to cause
1926      * an out-of-gas error (10K collections should be fine).
1927      */
1928     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1929 }
1930 
1931 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1932 
1933 
1934 // ERC721A Contracts v4.2.3
1935 // Creator: Chiru Labs
1936 
1937 pragma solidity ^0.8.4;
1938 
1939 
1940 
1941 /**
1942  * @title ERC721AQueryable.
1943  *
1944  * @dev ERC721A subclass with convenience query functions.
1945  */
1946 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1947     /**
1948      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1949      *
1950      * If the `tokenId` is out of bounds:
1951      *
1952      * - `addr = address(0)`
1953      * - `startTimestamp = 0`
1954      * - `burned = false`
1955      * - `extraData = 0`
1956      *
1957      * If the `tokenId` is burned:
1958      *
1959      * - `addr = <Address of owner before token was burned>`
1960      * - `startTimestamp = <Timestamp when token was burned>`
1961      * - `burned = true`
1962      * - `extraData = <Extra data when token was burned>`
1963      *
1964      * Otherwise:
1965      *
1966      * - `addr = <Address of owner>`
1967      * - `startTimestamp = <Timestamp of start of ownership>`
1968      * - `burned = false`
1969      * - `extraData = <Extra data at start of ownership>`
1970      */
1971     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1972         TokenOwnership memory ownership;
1973         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1974             return ownership;
1975         }
1976         ownership = _ownershipAt(tokenId);
1977         if (ownership.burned) {
1978             return ownership;
1979         }
1980         return _ownershipOf(tokenId);
1981     }
1982 
1983     /**
1984      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1985      * See {ERC721AQueryable-explicitOwnershipOf}
1986      */
1987     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1988         external
1989         view
1990         virtual
1991         override
1992         returns (TokenOwnership[] memory)
1993     {
1994         unchecked {
1995             uint256 tokenIdsLength = tokenIds.length;
1996             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1997             for (uint256 i; i != tokenIdsLength; ++i) {
1998                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1999             }
2000             return ownerships;
2001         }
2002     }
2003 
2004     /**
2005      * @dev Returns an array of token IDs owned by `owner`,
2006      * in the range [`start`, `stop`)
2007      * (i.e. `start <= tokenId < stop`).
2008      *
2009      * This function allows for tokens to be queried if the collection
2010      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2011      *
2012      * Requirements:
2013      *
2014      * - `start < stop`
2015      */
2016     function tokensOfOwnerIn(
2017         address owner,
2018         uint256 start,
2019         uint256 stop
2020     ) external view virtual override returns (uint256[] memory) {
2021         unchecked {
2022             if (start >= stop) revert InvalidQueryRange();
2023             uint256 tokenIdsIdx;
2024             uint256 stopLimit = _nextTokenId();
2025             // Set `start = max(start, _startTokenId())`.
2026             if (start < _startTokenId()) {
2027                 start = _startTokenId();
2028             }
2029             // Set `stop = min(stop, stopLimit)`.
2030             if (stop > stopLimit) {
2031                 stop = stopLimit;
2032             }
2033             uint256 tokenIdsMaxLength = balanceOf(owner);
2034             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2035             // to cater for cases where `balanceOf(owner)` is too big.
2036             if (start < stop) {
2037                 uint256 rangeLength = stop - start;
2038                 if (rangeLength < tokenIdsMaxLength) {
2039                     tokenIdsMaxLength = rangeLength;
2040                 }
2041             } else {
2042                 tokenIdsMaxLength = 0;
2043             }
2044             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2045             if (tokenIdsMaxLength == 0) {
2046                 return tokenIds;
2047             }
2048             // We need to call `explicitOwnershipOf(start)`,
2049             // because the slot at `start` may not be initialized.
2050             TokenOwnership memory ownership = explicitOwnershipOf(start);
2051             address currOwnershipAddr;
2052             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2053             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2054             if (!ownership.burned) {
2055                 currOwnershipAddr = ownership.addr;
2056             }
2057             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2058                 ownership = _ownershipAt(i);
2059                 if (ownership.burned) {
2060                     continue;
2061                 }
2062                 if (ownership.addr != address(0)) {
2063                     currOwnershipAddr = ownership.addr;
2064                 }
2065                 if (currOwnershipAddr == owner) {
2066                     tokenIds[tokenIdsIdx++] = i;
2067                 }
2068             }
2069             // Downsize the array to fit.
2070             assembly {
2071                 mstore(tokenIds, tokenIdsIdx)
2072             }
2073             return tokenIds;
2074         }
2075     }
2076 
2077     /**
2078      * @dev Returns an array of token IDs owned by `owner`.
2079      *
2080      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2081      * It is meant to be called off-chain.
2082      *
2083      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2084      * multiple smaller scans if the collection is large enough to cause
2085      * an out-of-gas error (10K collections should be fine).
2086      */
2087     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2088         unchecked {
2089             uint256 tokenIdsIdx;
2090             address currOwnershipAddr;
2091             uint256 tokenIdsLength = balanceOf(owner);
2092             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2093             TokenOwnership memory ownership;
2094             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2095                 ownership = _ownershipAt(i);
2096                 if (ownership.burned) {
2097                     continue;
2098                 }
2099                 if (ownership.addr != address(0)) {
2100                     currOwnershipAddr = ownership.addr;
2101                 }
2102                 if (currOwnershipAddr == owner) {
2103                     tokenIds[tokenIdsIdx++] = i;
2104                 }
2105             }
2106             return tokenIds;
2107         }
2108     }
2109 }
2110 
2111 // File: nft.sol
2112 
2113 
2114 pragma solidity ^0.8.9;
2115 
2116 
2117 
2118 
2119 
2120 
2121 error MyNftCollection__InvalidMintAmount();
2122 error MyNftCollection__MaxSupplyExceeded();
2123 error MyNftCollection__InsufficientFunds();
2124 error MyNftCollection__AllowlistSaleClosed();
2125 error MyNftCollection__AddressAlreadyClaimed();
2126 error MyNftCollection__InvalidProof();
2127 error MyNftCollection__PublicSaleClosed();
2128 error MyNftCollection__TransferFailed();
2129 error MyNftCollection__NonexistentToken();
2130 
2131 contract SpaceRoadies is ERC721AQueryable, Ownable, ReentrancyGuard {
2132     using Strings for uint256;
2133 
2134     /// Type declarations
2135     enum SaleState {
2136         Closed,
2137         AllowlistOnly,
2138         PublicOpen
2139     }
2140 
2141     /// State variables
2142     SaleState private sSaleState;
2143 
2144     uint256 private constant START_TOKEN_ID = 1;
2145     uint256 private immutable iMaxSupply;
2146     uint256 private sMintPrice;
2147     uint256 private sMaxMintAmountPerTx;
2148     string private sHiddenMetadataUri;
2149     string private sBaseUri;
2150     bytes32 private sMerkleRoot;
2151     bool private sRevealed;
2152 
2153     mapping(address => bool) private sAllowlistClaimed;
2154 
2155     /// Events
2156     event Mint(address indexed minter, uint256 amount);
2157 
2158     constructor(
2159         string memory nftName,
2160         string memory nftSymbol,
2161         string memory hiddenMetadataUri,
2162         uint256 maxSupply,
2163         uint256 mintPrice,
2164         uint256 maxMintAmountPerTx
2165     ) ERC721A(nftName, nftSymbol) {
2166         iMaxSupply = maxSupply;
2167         sMintPrice = mintPrice;
2168         sMaxMintAmountPerTx = maxMintAmountPerTx;
2169         sHiddenMetadataUri = hiddenMetadataUri;
2170         sSaleState = SaleState.PublicOpen;
2171     }
2172 
2173     /// Modifiers
2174     modifier mintCompliance(uint256 _mintAmount, uint256 _maxMintAmount) {
2175         if (_mintAmount < 1 || _mintAmount > _maxMintAmount)
2176             revert MyNftCollection__InvalidMintAmount();
2177 
2178         if (totalSupply() + _mintAmount > iMaxSupply)
2179             revert MyNftCollection__MaxSupplyExceeded();
2180 
2181         _;
2182     }
2183 
2184     modifier mintPriceCompliance(uint256 _mintAmount) {
2185         if (msg.value < sMintPrice * _mintAmount)
2186             revert MyNftCollection__InsufficientFunds();
2187 
2188         _;
2189     }
2190 
2191     /// Functions
2192     function allowlistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof)
2193         public
2194         payable
2195         mintCompliance(_mintAmount, sMaxMintAmountPerTx)
2196         mintPriceCompliance(_mintAmount)
2197     {
2198         if (sSaleState != SaleState.AllowlistOnly)
2199             revert MyNftCollection__AllowlistSaleClosed();
2200 
2201         if (sAllowlistClaimed[_msgSender()])
2202             revert MyNftCollection__AddressAlreadyClaimed();
2203 
2204         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2205 
2206         if (!MerkleProof.verify(_merkleProof, sMerkleRoot, leaf))
2207             revert MyNftCollection__InvalidProof();
2208 
2209         sAllowlistClaimed[_msgSender()] = true;
2210 
2211         _safeMint(_msgSender(), _mintAmount);
2212 
2213         emit Mint(_msgSender(), _mintAmount);
2214     }
2215 
2216     function publicMint(uint256 _mintAmount)
2217         public
2218         payable
2219         mintCompliance(_mintAmount, sMaxMintAmountPerTx)
2220         mintPriceCompliance(_mintAmount)
2221     {
2222         if (sSaleState != SaleState.PublicOpen)
2223             revert MyNftCollection__PublicSaleClosed();
2224 
2225         _safeMint(_msgSender(), _mintAmount);
2226 
2227         emit Mint(_msgSender(), _mintAmount);
2228     }
2229 
2230     function mintForAddress(uint256 _mintAmount, address _receiver)
2231         public
2232         mintCompliance(_mintAmount, sMaxMintAmountPerTx)
2233         onlyOwner
2234     {
2235         _safeMint(_receiver, _mintAmount);
2236     }
2237 
2238     function withdraw() public onlyOwner nonReentrant {
2239         (bool success, ) = payable(owner()).call{value: address(this).balance}(
2240             ''
2241         );
2242         if (!success) revert MyNftCollection__TransferFailed();
2243     }
2244 
2245     function tokenURI(uint256 _tokenId)
2246         public
2247         view
2248         virtual
2249         override
2250         returns (string memory)
2251     {
2252         if (!_exists(_tokenId)) revert MyNftCollection__NonexistentToken();
2253 
2254         if (sRevealed == false) return sHiddenMetadataUri;
2255 
2256         return
2257             bytes(_baseURI()).length > 0
2258                 ? string(
2259                     abi.encodePacked(_baseURI(), _tokenId.toString(), '.json')
2260                 )
2261                 : '';
2262     }
2263 
2264     function _baseURI() internal view virtual override returns (string memory) {
2265         return sBaseUri;
2266     }
2267 
2268     function _startTokenId() internal view virtual override returns (uint256) {
2269         return START_TOKEN_ID;
2270     }
2271 
2272     /// Getter Functions
2273     function getSaleState() public view returns (SaleState) {
2274         return sSaleState;
2275     }
2276 
2277     function getMaxSupply() public view returns (uint256) {
2278         return iMaxSupply;
2279     }
2280 
2281     function getMintPrice() public view returns (uint256) {
2282         return sMintPrice;
2283     }
2284 
2285     function getMaxMintAmountPerTx() public view returns (uint256) {
2286         return sMaxMintAmountPerTx;
2287     }
2288 
2289     function getHiddenMetadataUri() public view returns (string memory) {
2290         return sHiddenMetadataUri;
2291     }
2292 
2293     function getBaseUri() public view returns (string memory) {
2294         return sBaseUri;
2295     }
2296 
2297     function getMerkleRoot() public view returns (bytes32) {
2298         return sMerkleRoot;
2299     }
2300 
2301     function getRevealed() public view returns (bool) {
2302         return sRevealed;
2303     }
2304 
2305     /// Setter Functions
2306     function setAllowlistOnly() public onlyOwner {
2307         sSaleState = SaleState.AllowlistOnly;
2308     }
2309 
2310     function setPublicOpen() public onlyOwner {
2311         sSaleState = SaleState.PublicOpen;
2312     }
2313 
2314     function setClosed() public onlyOwner {
2315         sSaleState = SaleState.Closed;
2316     }
2317 
2318     function setMintPrice(uint256 _mintPrice) public onlyOwner {
2319         sMintPrice = _mintPrice;
2320     }
2321 
2322     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)
2323         public
2324         onlyOwner
2325     {
2326         sMaxMintAmountPerTx = _maxMintAmountPerTx;
2327     }
2328 
2329     function setHiddenMetadataUri(string memory _hiddenMetadataUri)
2330         public
2331         onlyOwner
2332     {
2333         sHiddenMetadataUri = _hiddenMetadataUri;
2334     }
2335 
2336     function setBaseUri(string memory _baseUri) public onlyOwner {
2337         sBaseUri = _baseUri;
2338     }
2339 
2340     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2341         sMerkleRoot = _merkleRoot;
2342     }
2343 
2344     function setRevealed(bool _state) public onlyOwner {
2345         sRevealed = _state;
2346     }
2347 }