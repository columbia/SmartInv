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
216 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
217 
218 
219 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev Contract module that helps prevent reentrant calls to a function.
225  *
226  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
227  * available, which can be applied to functions to make sure there are no nested
228  * (reentrant) calls to them.
229  *
230  * Note that because there is a single `nonReentrant` guard, functions marked as
231  * `nonReentrant` may not call one another. This can be worked around by making
232  * those functions `private`, and then adding `external` `nonReentrant` entry
233  * points to them.
234  *
235  * TIP: If you would like to learn more about reentrancy and alternative ways
236  * to protect against it, check out our blog post
237  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
238  */
239 abstract contract ReentrancyGuard {
240     // Booleans are more expensive than uint256 or any type that takes up a full
241     // word because each write operation emits an extra SLOAD to first read the
242     // slot's contents, replace the bits taken up by the boolean, and then write
243     // back. This is the compiler's defense against contract upgrades and
244     // pointer aliasing, and it cannot be disabled.
245 
246     // The values being non-zero value makes deployment a bit more expensive,
247     // but in exchange the refund on every call to nonReentrant will be lower in
248     // amount. Since refunds are capped to a percentage of the total
249     // transaction's gas, it is best to keep them low in cases like this one, to
250     // increase the likelihood of the full refund coming into effect.
251     uint256 private constant _NOT_ENTERED = 1;
252     uint256 private constant _ENTERED = 2;
253 
254     uint256 private _status;
255 
256     constructor() {
257         _status = _NOT_ENTERED;
258     }
259 
260     /**
261      * @dev Prevents a contract from calling itself, directly or indirectly.
262      * Calling a `nonReentrant` function from another `nonReentrant`
263      * function is not supported. It is possible to prevent this from happening
264      * by making the `nonReentrant` function external, and making it call a
265      * `private` function that does the actual work.
266      */
267     modifier nonReentrant() {
268         // On the first call to nonReentrant, _notEntered will be true
269         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
270 
271         // Any calls to nonReentrant after this point will fail
272         _status = _ENTERED;
273 
274         _;
275 
276         // By storing the original value once again, a refund is triggered (see
277         // https://eips.ethereum.org/EIPS/eip-2200)
278         _status = _NOT_ENTERED;
279     }
280 }
281 
282 // File: @openzeppelin/contracts/utils/Context.sol
283 
284 
285 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
286 
287 pragma solidity ^0.8.0;
288 
289 /**
290  * @dev Provides information about the current execution context, including the
291  * sender of the transaction and its data. While these are generally available
292  * via msg.sender and msg.data, they should not be accessed in such a direct
293  * manner, since when dealing with meta-transactions the account sending and
294  * paying for execution may not be the actual sender (as far as an application
295  * is concerned).
296  *
297  * This contract is only required for intermediate, library-like contracts.
298  */
299 abstract contract Context {
300     function _msgSender() internal view virtual returns (address) {
301         return msg.sender;
302     }
303 
304     function _msgData() internal view virtual returns (bytes calldata) {
305         return msg.data;
306     }
307 }
308 
309 // File: @openzeppelin/contracts/access/Ownable.sol
310 
311 
312 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
313 
314 pragma solidity ^0.8.0;
315 
316 
317 /**
318  * @dev Contract module which provides a basic access control mechanism, where
319  * there is an account (an owner) that can be granted exclusive access to
320  * specific functions.
321  *
322  * By default, the owner account will be the one that deploys the contract. This
323  * can later be changed with {transferOwnership}.
324  *
325  * This module is used through inheritance. It will make available the modifier
326  * `onlyOwner`, which can be applied to your functions to restrict their use to
327  * the owner.
328  */
329 abstract contract Ownable is Context {
330     address private _owner;
331 
332     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
333 
334     /**
335      * @dev Initializes the contract setting the deployer as the initial owner.
336      */
337     constructor() {
338         _transferOwnership(_msgSender());
339     }
340 
341     /**
342      * @dev Throws if called by any account other than the owner.
343      */
344     modifier onlyOwner() {
345         _checkOwner();
346         _;
347     }
348 
349     /**
350      * @dev Returns the address of the current owner.
351      */
352     function owner() public view virtual returns (address) {
353         return _owner;
354     }
355 
356     /**
357      * @dev Throws if the sender is not the owner.
358      */
359     function _checkOwner() internal view virtual {
360         require(owner() == _msgSender(), "Ownable: caller is not the owner");
361     }
362 
363     /**
364      * @dev Leaves the contract without owner. It will not be possible to call
365      * `onlyOwner` functions anymore. Can only be called by the current owner.
366      *
367      * NOTE: Renouncing ownership will leave the contract without an owner,
368      * thereby removing any functionality that is only available to the owner.
369      */
370     function renounceOwnership() public virtual onlyOwner {
371         _transferOwnership(address(0));
372     }
373 
374     /**
375      * @dev Transfers ownership of the contract to a new account (`newOwner`).
376      * Can only be called by the current owner.
377      */
378     function transferOwnership(address newOwner) public virtual onlyOwner {
379         require(newOwner != address(0), "Ownable: new owner is the zero address");
380         _transferOwnership(newOwner);
381     }
382 
383     /**
384      * @dev Transfers ownership of the contract to a new account (`newOwner`).
385      * Internal function without access restriction.
386      */
387     function _transferOwnership(address newOwner) internal virtual {
388         address oldOwner = _owner;
389         _owner = newOwner;
390         emit OwnershipTransferred(oldOwner, newOwner);
391     }
392 }
393 
394 // File: @openzeppelin/contracts/security/Pausable.sol
395 
396 
397 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 
402 /**
403  * @dev Contract module which allows children to implement an emergency stop
404  * mechanism that can be triggered by an authorized account.
405  *
406  * This module is used through inheritance. It will make available the
407  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
408  * the functions of your contract. Note that they will not be pausable by
409  * simply including this module, only once the modifiers are put in place.
410  */
411 abstract contract Pausable is Context {
412     /**
413      * @dev Emitted when the pause is triggered by `account`.
414      */
415     event Paused(address account);
416 
417     /**
418      * @dev Emitted when the pause is lifted by `account`.
419      */
420     event Unpaused(address account);
421 
422     bool private _paused;
423 
424     /**
425      * @dev Initializes the contract in unpaused state.
426      */
427     constructor() {
428         _paused = false;
429     }
430 
431     /**
432      * @dev Modifier to make a function callable only when the contract is not paused.
433      *
434      * Requirements:
435      *
436      * - The contract must not be paused.
437      */
438     modifier whenNotPaused() {
439         _requireNotPaused();
440         _;
441     }
442 
443     /**
444      * @dev Modifier to make a function callable only when the contract is paused.
445      *
446      * Requirements:
447      *
448      * - The contract must be paused.
449      */
450     modifier whenPaused() {
451         _requirePaused();
452         _;
453     }
454 
455     /**
456      * @dev Returns true if the contract is paused, and false otherwise.
457      */
458     function paused() public view virtual returns (bool) {
459         return _paused;
460     }
461 
462     /**
463      * @dev Throws if the contract is paused.
464      */
465     function _requireNotPaused() internal view virtual {
466         require(!paused(), "Pausable: paused");
467     }
468 
469     /**
470      * @dev Throws if the contract is not paused.
471      */
472     function _requirePaused() internal view virtual {
473         require(paused(), "Pausable: not paused");
474     }
475 
476     /**
477      * @dev Triggers stopped state.
478      *
479      * Requirements:
480      *
481      * - The contract must not be paused.
482      */
483     function _pause() internal virtual whenNotPaused {
484         _paused = true;
485         emit Paused(_msgSender());
486     }
487 
488     /**
489      * @dev Returns to normal state.
490      *
491      * Requirements:
492      *
493      * - The contract must be paused.
494      */
495     function _unpause() internal virtual whenPaused {
496         _paused = false;
497         emit Unpaused(_msgSender());
498     }
499 }
500 
501 // File: erc721a/contracts/IERC721A.sol
502 
503 
504 // ERC721A Contracts v4.2.3
505 // Creator: Chiru Labs
506 
507 pragma solidity ^0.8.4;
508 
509 /**
510  * @dev Interface of ERC721A.
511  */
512 interface IERC721A {
513     /**
514      * The caller must own the token or be an approved operator.
515      */
516     error ApprovalCallerNotOwnerNorApproved();
517 
518     /**
519      * The token does not exist.
520      */
521     error ApprovalQueryForNonexistentToken();
522 
523     /**
524      * Cannot query the balance for the zero address.
525      */
526     error BalanceQueryForZeroAddress();
527 
528     /**
529      * Cannot mint to the zero address.
530      */
531     error MintToZeroAddress();
532 
533     /**
534      * The quantity of tokens minted must be more than zero.
535      */
536     error MintZeroQuantity();
537 
538     /**
539      * The token does not exist.
540      */
541     error OwnerQueryForNonexistentToken();
542 
543     /**
544      * The caller must own the token or be an approved operator.
545      */
546     error TransferCallerNotOwnerNorApproved();
547 
548     /**
549      * The token must be owned by `from`.
550      */
551     error TransferFromIncorrectOwner();
552 
553     /**
554      * Cannot safely transfer to a contract that does not implement the
555      * ERC721Receiver interface.
556      */
557     error TransferToNonERC721ReceiverImplementer();
558 
559     /**
560      * Cannot transfer to the zero address.
561      */
562     error TransferToZeroAddress();
563 
564     /**
565      * The token does not exist.
566      */
567     error URIQueryForNonexistentToken();
568 
569     /**
570      * The `quantity` minted with ERC2309 exceeds the safety limit.
571      */
572     error MintERC2309QuantityExceedsLimit();
573 
574     /**
575      * The `extraData` cannot be set on an unintialized ownership slot.
576      */
577     error OwnershipNotInitializedForExtraData();
578 
579     // =============================================================
580     //                            STRUCTS
581     // =============================================================
582 
583     struct TokenOwnership {
584         // The address of the owner.
585         address addr;
586         // Stores the start time of ownership with minimal overhead for tokenomics.
587         uint64 startTimestamp;
588         // Whether the token has been burned.
589         bool burned;
590         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
591         uint24 extraData;
592     }
593 
594     // =============================================================
595     //                         TOKEN COUNTERS
596     // =============================================================
597 
598     /**
599      * @dev Returns the total number of tokens in existence.
600      * Burned tokens will reduce the count.
601      * To get the total number of tokens minted, please see {_totalMinted}.
602      */
603     function totalSupply() external view returns (uint256);
604 
605     // =============================================================
606     //                            IERC165
607     // =============================================================
608 
609     /**
610      * @dev Returns true if this contract implements the interface defined by
611      * `interfaceId`. See the corresponding
612      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
613      * to learn more about how these ids are created.
614      *
615      * This function call must use less than 30000 gas.
616      */
617     function supportsInterface(bytes4 interfaceId) external view returns (bool);
618 
619     // =============================================================
620     //                            IERC721
621     // =============================================================
622 
623     /**
624      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
625      */
626     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
627 
628     /**
629      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
630      */
631     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
632 
633     /**
634      * @dev Emitted when `owner` enables or disables
635      * (`approved`) `operator` to manage all of its assets.
636      */
637     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
638 
639     /**
640      * @dev Returns the number of tokens in `owner`'s account.
641      */
642     function balanceOf(address owner) external view returns (uint256 balance);
643 
644     /**
645      * @dev Returns the owner of the `tokenId` token.
646      *
647      * Requirements:
648      *
649      * - `tokenId` must exist.
650      */
651     function ownerOf(uint256 tokenId) external view returns (address owner);
652 
653     /**
654      * @dev Safely transfers `tokenId` token from `from` to `to`,
655      * checking first that contract recipients are aware of the ERC721 protocol
656      * to prevent tokens from being forever locked.
657      *
658      * Requirements:
659      *
660      * - `from` cannot be the zero address.
661      * - `to` cannot be the zero address.
662      * - `tokenId` token must exist and be owned by `from`.
663      * - If the caller is not `from`, it must be have been allowed to move
664      * this token by either {approve} or {setApprovalForAll}.
665      * - If `to` refers to a smart contract, it must implement
666      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
667      *
668      * Emits a {Transfer} event.
669      */
670     function safeTransferFrom(
671         address from,
672         address to,
673         uint256 tokenId,
674         bytes calldata data
675     ) external payable;
676 
677     /**
678      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
679      */
680     function safeTransferFrom(
681         address from,
682         address to,
683         uint256 tokenId
684     ) external payable;
685 
686     /**
687      * @dev Transfers `tokenId` from `from` to `to`.
688      *
689      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
690      * whenever possible.
691      *
692      * Requirements:
693      *
694      * - `from` cannot be the zero address.
695      * - `to` cannot be the zero address.
696      * - `tokenId` token must be owned by `from`.
697      * - If the caller is not `from`, it must be approved to move this token
698      * by either {approve} or {setApprovalForAll}.
699      *
700      * Emits a {Transfer} event.
701      */
702     function transferFrom(
703         address from,
704         address to,
705         uint256 tokenId
706     ) external payable;
707 
708     /**
709      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
710      * The approval is cleared when the token is transferred.
711      *
712      * Only a single account can be approved at a time, so approving the
713      * zero address clears previous approvals.
714      *
715      * Requirements:
716      *
717      * - The caller must own the token or be an approved operator.
718      * - `tokenId` must exist.
719      *
720      * Emits an {Approval} event.
721      */
722     function approve(address to, uint256 tokenId) external payable;
723 
724     /**
725      * @dev Approve or remove `operator` as an operator for the caller.
726      * Operators can call {transferFrom} or {safeTransferFrom}
727      * for any token owned by the caller.
728      *
729      * Requirements:
730      *
731      * - The `operator` cannot be the caller.
732      *
733      * Emits an {ApprovalForAll} event.
734      */
735     function setApprovalForAll(address operator, bool _approved) external;
736 
737     /**
738      * @dev Returns the account approved for `tokenId` token.
739      *
740      * Requirements:
741      *
742      * - `tokenId` must exist.
743      */
744     function getApproved(uint256 tokenId) external view returns (address operator);
745 
746     /**
747      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
748      *
749      * See {setApprovalForAll}.
750      */
751     function isApprovedForAll(address owner, address operator) external view returns (bool);
752 
753     // =============================================================
754     //                        IERC721Metadata
755     // =============================================================
756 
757     /**
758      * @dev Returns the token collection name.
759      */
760     function name() external view returns (string memory);
761 
762     /**
763      * @dev Returns the token collection symbol.
764      */
765     function symbol() external view returns (string memory);
766 
767     /**
768      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
769      */
770     function tokenURI(uint256 tokenId) external view returns (string memory);
771 
772     // =============================================================
773     //                           IERC2309
774     // =============================================================
775 
776     /**
777      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
778      * (inclusive) is transferred from `from` to `to`, as defined in the
779      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
780      *
781      * See {_mintERC2309} for more details.
782      */
783     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
784 }
785 
786 // File: erc721a/contracts/ERC721A.sol
787 
788 
789 // ERC721A Contracts v4.2.3
790 // Creator: Chiru Labs
791 
792 pragma solidity ^0.8.4;
793 
794 
795 /**
796  * @dev Interface of ERC721 token receiver.
797  */
798 interface ERC721A__IERC721Receiver {
799     function onERC721Received(
800         address operator,
801         address from,
802         uint256 tokenId,
803         bytes calldata data
804     ) external returns (bytes4);
805 }
806 
807 /**
808  * @title ERC721A
809  *
810  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
811  * Non-Fungible Token Standard, including the Metadata extension.
812  * Optimized for lower gas during batch mints.
813  *
814  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
815  * starting from `_startTokenId()`.
816  *
817  * Assumptions:
818  *
819  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
820  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
821  */
822 contract ERC721A is IERC721A {
823     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
824     struct TokenApprovalRef {
825         address value;
826     }
827 
828     // =============================================================
829     //                           CONSTANTS
830     // =============================================================
831 
832     // Mask of an entry in packed address data.
833     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
834 
835     // The bit position of `numberMinted` in packed address data.
836     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
837 
838     // The bit position of `numberBurned` in packed address data.
839     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
840 
841     // The bit position of `aux` in packed address data.
842     uint256 private constant _BITPOS_AUX = 192;
843 
844     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
845     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
846 
847     // The bit position of `startTimestamp` in packed ownership.
848     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
849 
850     // The bit mask of the `burned` bit in packed ownership.
851     uint256 private constant _BITMASK_BURNED = 1 << 224;
852 
853     // The bit position of the `nextInitialized` bit in packed ownership.
854     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
855 
856     // The bit mask of the `nextInitialized` bit in packed ownership.
857     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
858 
859     // The bit position of `extraData` in packed ownership.
860     uint256 private constant _BITPOS_EXTRA_DATA = 232;
861 
862     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
863     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
864 
865     // The mask of the lower 160 bits for addresses.
866     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
867 
868     // The maximum `quantity` that can be minted with {_mintERC2309}.
869     // This limit is to prevent overflows on the address data entries.
870     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
871     // is required to cause an overflow, which is unrealistic.
872     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
873 
874     // The `Transfer` event signature is given by:
875     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
876     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
877         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
878 
879     // =============================================================
880     //                            STORAGE
881     // =============================================================
882 
883     // The next token ID to be minted.
884     uint256 private _currentIndex;
885 
886     // The number of tokens burned.
887     uint256 private _burnCounter;
888 
889     // Token name
890     string private _name;
891 
892     // Token symbol
893     string private _symbol;
894 
895     // Mapping from token ID to ownership details
896     // An empty struct value does not necessarily mean the token is unowned.
897     // See {_packedOwnershipOf} implementation for details.
898     //
899     // Bits Layout:
900     // - [0..159]   `addr`
901     // - [160..223] `startTimestamp`
902     // - [224]      `burned`
903     // - [225]      `nextInitialized`
904     // - [232..255] `extraData`
905     mapping(uint256 => uint256) private _packedOwnerships;
906 
907     // Mapping owner address to address data.
908     //
909     // Bits Layout:
910     // - [0..63]    `balance`
911     // - [64..127]  `numberMinted`
912     // - [128..191] `numberBurned`
913     // - [192..255] `aux`
914     mapping(address => uint256) private _packedAddressData;
915 
916     // Mapping from token ID to approved address.
917     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
918 
919     // Mapping from owner to operator approvals
920     mapping(address => mapping(address => bool)) private _operatorApprovals;
921 
922     // =============================================================
923     //                          CONSTRUCTOR
924     // =============================================================
925 
926     constructor(string memory name_, string memory symbol_) {
927         _name = name_;
928         _symbol = symbol_;
929         _currentIndex = _startTokenId();
930     }
931 
932     // =============================================================
933     //                   TOKEN COUNTING OPERATIONS
934     // =============================================================
935 
936     /**
937      * @dev Returns the starting token ID.
938      * To change the starting token ID, please override this function.
939      */
940     function _startTokenId() internal view virtual returns (uint256) {
941         return 0;
942     }
943 
944     /**
945      * @dev Returns the next token ID to be minted.
946      */
947     function _nextTokenId() internal view virtual returns (uint256) {
948         return _currentIndex;
949     }
950 
951     /**
952      * @dev Returns the total number of tokens in existence.
953      * Burned tokens will reduce the count.
954      * To get the total number of tokens minted, please see {_totalMinted}.
955      */
956     function totalSupply() public view virtual override returns (uint256) {
957         // Counter underflow is impossible as _burnCounter cannot be incremented
958         // more than `_currentIndex - _startTokenId()` times.
959         unchecked {
960             return _currentIndex - _burnCounter - _startTokenId();
961         }
962     }
963 
964     /**
965      * @dev Returns the total amount of tokens minted in the contract.
966      */
967     function _totalMinted() internal view virtual returns (uint256) {
968         // Counter underflow is impossible as `_currentIndex` does not decrement,
969         // and it is initialized to `_startTokenId()`.
970         unchecked {
971             return _currentIndex - _startTokenId();
972         }
973     }
974 
975     /**
976      * @dev Returns the total number of tokens burned.
977      */
978     function _totalBurned() internal view virtual returns (uint256) {
979         return _burnCounter;
980     }
981 
982     // =============================================================
983     //                    ADDRESS DATA OPERATIONS
984     // =============================================================
985 
986     /**
987      * @dev Returns the number of tokens in `owner`'s account.
988      */
989     function balanceOf(address owner) public view virtual override returns (uint256) {
990         if (owner == address(0)) revert BalanceQueryForZeroAddress();
991         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
992     }
993 
994     /**
995      * Returns the number of tokens minted by `owner`.
996      */
997     function _numberMinted(address owner) internal view returns (uint256) {
998         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
999     }
1000 
1001     /**
1002      * Returns the number of tokens burned by or on behalf of `owner`.
1003      */
1004     function _numberBurned(address owner) internal view returns (uint256) {
1005         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1006     }
1007 
1008     /**
1009      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1010      */
1011     function _getAux(address owner) internal view returns (uint64) {
1012         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1013     }
1014 
1015     /**
1016      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1017      * If there are multiple variables, please pack them into a uint64.
1018      */
1019     function _setAux(address owner, uint64 aux) internal virtual {
1020         uint256 packed = _packedAddressData[owner];
1021         uint256 auxCasted;
1022         // Cast `aux` with assembly to avoid redundant masking.
1023         assembly {
1024             auxCasted := aux
1025         }
1026         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1027         _packedAddressData[owner] = packed;
1028     }
1029 
1030     // =============================================================
1031     //                            IERC165
1032     // =============================================================
1033 
1034     /**
1035      * @dev Returns true if this contract implements the interface defined by
1036      * `interfaceId`. See the corresponding
1037      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1038      * to learn more about how these ids are created.
1039      *
1040      * This function call must use less than 30000 gas.
1041      */
1042     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1043         // The interface IDs are constants representing the first 4 bytes
1044         // of the XOR of all function selectors in the interface.
1045         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1046         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1047         return
1048             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1049             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1050             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1051     }
1052 
1053     // =============================================================
1054     //                        IERC721Metadata
1055     // =============================================================
1056 
1057     /**
1058      * @dev Returns the token collection name.
1059      */
1060     function name() public view virtual override returns (string memory) {
1061         return _name;
1062     }
1063 
1064     /**
1065      * @dev Returns the token collection symbol.
1066      */
1067     function symbol() public view virtual override returns (string memory) {
1068         return _symbol;
1069     }
1070 
1071     /**
1072      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1073      */
1074     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1075         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1076 
1077         string memory baseURI = _baseURI();
1078         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1079     }
1080 
1081     /**
1082      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1083      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1084      * by default, it can be overridden in child contracts.
1085      */
1086     function _baseURI() internal view virtual returns (string memory) {
1087         return '';
1088     }
1089 
1090     // =============================================================
1091     //                     OWNERSHIPS OPERATIONS
1092     // =============================================================
1093 
1094     /**
1095      * @dev Returns the owner of the `tokenId` token.
1096      *
1097      * Requirements:
1098      *
1099      * - `tokenId` must exist.
1100      */
1101     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1102         return address(uint160(_packedOwnershipOf(tokenId)));
1103     }
1104 
1105     /**
1106      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1107      * It gradually moves to O(1) as tokens get transferred around over time.
1108      */
1109     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1110         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1111     }
1112 
1113     /**
1114      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1115      */
1116     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1117         return _unpackedOwnership(_packedOwnerships[index]);
1118     }
1119 
1120     /**
1121      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1122      */
1123     function _initializeOwnershipAt(uint256 index) internal virtual {
1124         if (_packedOwnerships[index] == 0) {
1125             _packedOwnerships[index] = _packedOwnershipOf(index);
1126         }
1127     }
1128 
1129     /**
1130      * Returns the packed ownership data of `tokenId`.
1131      */
1132     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1133         uint256 curr = tokenId;
1134 
1135         unchecked {
1136             if (_startTokenId() <= curr)
1137                 if (curr < _currentIndex) {
1138                     uint256 packed = _packedOwnerships[curr];
1139                     // If not burned.
1140                     if (packed & _BITMASK_BURNED == 0) {
1141                         // Invariant:
1142                         // There will always be an initialized ownership slot
1143                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1144                         // before an unintialized ownership slot
1145                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1146                         // Hence, `curr` will not underflow.
1147                         //
1148                         // We can directly compare the packed value.
1149                         // If the address is zero, packed will be zero.
1150                         while (packed == 0) {
1151                             packed = _packedOwnerships[--curr];
1152                         }
1153                         return packed;
1154                     }
1155                 }
1156         }
1157         revert OwnerQueryForNonexistentToken();
1158     }
1159 
1160     /**
1161      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1162      */
1163     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1164         ownership.addr = address(uint160(packed));
1165         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1166         ownership.burned = packed & _BITMASK_BURNED != 0;
1167         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1168     }
1169 
1170     /**
1171      * @dev Packs ownership data into a single uint256.
1172      */
1173     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1174         assembly {
1175             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1176             owner := and(owner, _BITMASK_ADDRESS)
1177             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1178             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1179         }
1180     }
1181 
1182     /**
1183      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1184      */
1185     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1186         // For branchless setting of the `nextInitialized` flag.
1187         assembly {
1188             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1189             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1190         }
1191     }
1192 
1193     // =============================================================
1194     //                      APPROVAL OPERATIONS
1195     // =============================================================
1196 
1197     /**
1198      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1199      * The approval is cleared when the token is transferred.
1200      *
1201      * Only a single account can be approved at a time, so approving the
1202      * zero address clears previous approvals.
1203      *
1204      * Requirements:
1205      *
1206      * - The caller must own the token or be an approved operator.
1207      * - `tokenId` must exist.
1208      *
1209      * Emits an {Approval} event.
1210      */
1211     function approve(address to, uint256 tokenId) public payable virtual override {
1212         address owner = ownerOf(tokenId);
1213 
1214         if (_msgSenderERC721A() != owner)
1215             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1216                 revert ApprovalCallerNotOwnerNorApproved();
1217             }
1218 
1219         _tokenApprovals[tokenId].value = to;
1220         emit Approval(owner, to, tokenId);
1221     }
1222 
1223     /**
1224      * @dev Returns the account approved for `tokenId` token.
1225      *
1226      * Requirements:
1227      *
1228      * - `tokenId` must exist.
1229      */
1230     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1231         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1232 
1233         return _tokenApprovals[tokenId].value;
1234     }
1235 
1236     /**
1237      * @dev Approve or remove `operator` as an operator for the caller.
1238      * Operators can call {transferFrom} or {safeTransferFrom}
1239      * for any token owned by the caller.
1240      *
1241      * Requirements:
1242      *
1243      * - The `operator` cannot be the caller.
1244      *
1245      * Emits an {ApprovalForAll} event.
1246      */
1247     function setApprovalForAll(address operator, bool approved) public virtual override {
1248         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1249         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1250     }
1251 
1252     /**
1253      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1254      *
1255      * See {setApprovalForAll}.
1256      */
1257     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1258         return _operatorApprovals[owner][operator];
1259     }
1260 
1261     /**
1262      * @dev Returns whether `tokenId` exists.
1263      *
1264      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1265      *
1266      * Tokens start existing when they are minted. See {_mint}.
1267      */
1268     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1269         return
1270             _startTokenId() <= tokenId &&
1271             tokenId < _currentIndex && // If within bounds,
1272             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1273     }
1274 
1275     /**
1276      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1277      */
1278     function _isSenderApprovedOrOwner(
1279         address approvedAddress,
1280         address owner,
1281         address msgSender
1282     ) private pure returns (bool result) {
1283         assembly {
1284             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1285             owner := and(owner, _BITMASK_ADDRESS)
1286             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1287             msgSender := and(msgSender, _BITMASK_ADDRESS)
1288             // `msgSender == owner || msgSender == approvedAddress`.
1289             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1290         }
1291     }
1292 
1293     /**
1294      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1295      */
1296     function _getApprovedSlotAndAddress(uint256 tokenId)
1297         private
1298         view
1299         returns (uint256 approvedAddressSlot, address approvedAddress)
1300     {
1301         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1302         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1303         assembly {
1304             approvedAddressSlot := tokenApproval.slot
1305             approvedAddress := sload(approvedAddressSlot)
1306         }
1307     }
1308 
1309     // =============================================================
1310     //                      TRANSFER OPERATIONS
1311     // =============================================================
1312 
1313     /**
1314      * @dev Transfers `tokenId` from `from` to `to`.
1315      *
1316      * Requirements:
1317      *
1318      * - `from` cannot be the zero address.
1319      * - `to` cannot be the zero address.
1320      * - `tokenId` token must be owned by `from`.
1321      * - If the caller is not `from`, it must be approved to move this token
1322      * by either {approve} or {setApprovalForAll}.
1323      *
1324      * Emits a {Transfer} event.
1325      */
1326     function transferFrom(
1327         address from,
1328         address to,
1329         uint256 tokenId
1330     ) public payable virtual override {
1331         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1332 
1333         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1334 
1335         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1336 
1337         // The nested ifs save around 20+ gas over a compound boolean condition.
1338         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1339             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1340 
1341         if (to == address(0)) revert TransferToZeroAddress();
1342 
1343         _beforeTokenTransfers(from, to, tokenId, 1);
1344 
1345         // Clear approvals from the previous owner.
1346         assembly {
1347             if approvedAddress {
1348                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1349                 sstore(approvedAddressSlot, 0)
1350             }
1351         }
1352 
1353         // Underflow of the sender's balance is impossible because we check for
1354         // ownership above and the recipient's balance can't realistically overflow.
1355         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1356         unchecked {
1357             // We can directly increment and decrement the balances.
1358             --_packedAddressData[from]; // Updates: `balance -= 1`.
1359             ++_packedAddressData[to]; // Updates: `balance += 1`.
1360 
1361             // Updates:
1362             // - `address` to the next owner.
1363             // - `startTimestamp` to the timestamp of transfering.
1364             // - `burned` to `false`.
1365             // - `nextInitialized` to `true`.
1366             _packedOwnerships[tokenId] = _packOwnershipData(
1367                 to,
1368                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1369             );
1370 
1371             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1372             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1373                 uint256 nextTokenId = tokenId + 1;
1374                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1375                 if (_packedOwnerships[nextTokenId] == 0) {
1376                     // If the next slot is within bounds.
1377                     if (nextTokenId != _currentIndex) {
1378                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1379                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1380                     }
1381                 }
1382             }
1383         }
1384 
1385         emit Transfer(from, to, tokenId);
1386         _afterTokenTransfers(from, to, tokenId, 1);
1387     }
1388 
1389     /**
1390      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1391      */
1392     function safeTransferFrom(
1393         address from,
1394         address to,
1395         uint256 tokenId
1396     ) public payable virtual override {
1397         safeTransferFrom(from, to, tokenId, '');
1398     }
1399 
1400     /**
1401      * @dev Safely transfers `tokenId` token from `from` to `to`.
1402      *
1403      * Requirements:
1404      *
1405      * - `from` cannot be the zero address.
1406      * - `to` cannot be the zero address.
1407      * - `tokenId` token must exist and be owned by `from`.
1408      * - If the caller is not `from`, it must be approved to move this token
1409      * by either {approve} or {setApprovalForAll}.
1410      * - If `to` refers to a smart contract, it must implement
1411      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1412      *
1413      * Emits a {Transfer} event.
1414      */
1415     function safeTransferFrom(
1416         address from,
1417         address to,
1418         uint256 tokenId,
1419         bytes memory _data
1420     ) public payable virtual override {
1421         transferFrom(from, to, tokenId);
1422         if (to.code.length != 0)
1423             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1424                 revert TransferToNonERC721ReceiverImplementer();
1425             }
1426     }
1427 
1428     /**
1429      * @dev Hook that is called before a set of serially-ordered token IDs
1430      * are about to be transferred. This includes minting.
1431      * And also called before burning one token.
1432      *
1433      * `startTokenId` - the first token ID to be transferred.
1434      * `quantity` - the amount to be transferred.
1435      *
1436      * Calling conditions:
1437      *
1438      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1439      * transferred to `to`.
1440      * - When `from` is zero, `tokenId` will be minted for `to`.
1441      * - When `to` is zero, `tokenId` will be burned by `from`.
1442      * - `from` and `to` are never both zero.
1443      */
1444     function _beforeTokenTransfers(
1445         address from,
1446         address to,
1447         uint256 startTokenId,
1448         uint256 quantity
1449     ) internal virtual {}
1450 
1451     /**
1452      * @dev Hook that is called after a set of serially-ordered token IDs
1453      * have been transferred. This includes minting.
1454      * And also called after one token has been burned.
1455      *
1456      * `startTokenId` - the first token ID to be transferred.
1457      * `quantity` - the amount to be transferred.
1458      *
1459      * Calling conditions:
1460      *
1461      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1462      * transferred to `to`.
1463      * - When `from` is zero, `tokenId` has been minted for `to`.
1464      * - When `to` is zero, `tokenId` has been burned by `from`.
1465      * - `from` and `to` are never both zero.
1466      */
1467     function _afterTokenTransfers(
1468         address from,
1469         address to,
1470         uint256 startTokenId,
1471         uint256 quantity
1472     ) internal virtual {}
1473 
1474     /**
1475      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1476      *
1477      * `from` - Previous owner of the given token ID.
1478      * `to` - Target address that will receive the token.
1479      * `tokenId` - Token ID to be transferred.
1480      * `_data` - Optional data to send along with the call.
1481      *
1482      * Returns whether the call correctly returned the expected magic value.
1483      */
1484     function _checkContractOnERC721Received(
1485         address from,
1486         address to,
1487         uint256 tokenId,
1488         bytes memory _data
1489     ) private returns (bool) {
1490         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1491             bytes4 retval
1492         ) {
1493             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1494         } catch (bytes memory reason) {
1495             if (reason.length == 0) {
1496                 revert TransferToNonERC721ReceiverImplementer();
1497             } else {
1498                 assembly {
1499                     revert(add(32, reason), mload(reason))
1500                 }
1501             }
1502         }
1503     }
1504 
1505     // =============================================================
1506     //                        MINT OPERATIONS
1507     // =============================================================
1508 
1509     /**
1510      * @dev Mints `quantity` tokens and transfers them to `to`.
1511      *
1512      * Requirements:
1513      *
1514      * - `to` cannot be the zero address.
1515      * - `quantity` must be greater than 0.
1516      *
1517      * Emits a {Transfer} event for each mint.
1518      */
1519     function _mint(address to, uint256 quantity) internal virtual {
1520         uint256 startTokenId = _currentIndex;
1521         if (quantity == 0) revert MintZeroQuantity();
1522 
1523         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1524 
1525         // Overflows are incredibly unrealistic.
1526         // `balance` and `numberMinted` have a maximum limit of 2**64.
1527         // `tokenId` has a maximum limit of 2**256.
1528         unchecked {
1529             // Updates:
1530             // - `balance += quantity`.
1531             // - `numberMinted += quantity`.
1532             //
1533             // We can directly add to the `balance` and `numberMinted`.
1534             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1535 
1536             // Updates:
1537             // - `address` to the owner.
1538             // - `startTimestamp` to the timestamp of minting.
1539             // - `burned` to `false`.
1540             // - `nextInitialized` to `quantity == 1`.
1541             _packedOwnerships[startTokenId] = _packOwnershipData(
1542                 to,
1543                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1544             );
1545 
1546             uint256 toMasked;
1547             uint256 end = startTokenId + quantity;
1548 
1549             // Use assembly to loop and emit the `Transfer` event for gas savings.
1550             // The duplicated `log4` removes an extra check and reduces stack juggling.
1551             // The assembly, together with the surrounding Solidity code, have been
1552             // delicately arranged to nudge the compiler into producing optimized opcodes.
1553             assembly {
1554                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1555                 toMasked := and(to, _BITMASK_ADDRESS)
1556                 // Emit the `Transfer` event.
1557                 log4(
1558                     0, // Start of data (0, since no data).
1559                     0, // End of data (0, since no data).
1560                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1561                     0, // `address(0)`.
1562                     toMasked, // `to`.
1563                     startTokenId // `tokenId`.
1564                 )
1565 
1566                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1567                 // that overflows uint256 will make the loop run out of gas.
1568                 // The compiler will optimize the `iszero` away for performance.
1569                 for {
1570                     let tokenId := add(startTokenId, 1)
1571                 } iszero(eq(tokenId, end)) {
1572                     tokenId := add(tokenId, 1)
1573                 } {
1574                     // Emit the `Transfer` event. Similar to above.
1575                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1576                 }
1577             }
1578             if (toMasked == 0) revert MintToZeroAddress();
1579 
1580             _currentIndex = end;
1581         }
1582         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1583     }
1584 
1585     /**
1586      * @dev Mints `quantity` tokens and transfers them to `to`.
1587      *
1588      * This function is intended for efficient minting only during contract creation.
1589      *
1590      * It emits only one {ConsecutiveTransfer} as defined in
1591      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1592      * instead of a sequence of {Transfer} event(s).
1593      *
1594      * Calling this function outside of contract creation WILL make your contract
1595      * non-compliant with the ERC721 standard.
1596      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1597      * {ConsecutiveTransfer} event is only permissible during contract creation.
1598      *
1599      * Requirements:
1600      *
1601      * - `to` cannot be the zero address.
1602      * - `quantity` must be greater than 0.
1603      *
1604      * Emits a {ConsecutiveTransfer} event.
1605      */
1606     function _mintERC2309(address to, uint256 quantity) internal virtual {
1607         uint256 startTokenId = _currentIndex;
1608         if (to == address(0)) revert MintToZeroAddress();
1609         if (quantity == 0) revert MintZeroQuantity();
1610         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1611 
1612         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1613 
1614         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1615         unchecked {
1616             // Updates:
1617             // - `balance += quantity`.
1618             // - `numberMinted += quantity`.
1619             //
1620             // We can directly add to the `balance` and `numberMinted`.
1621             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1622 
1623             // Updates:
1624             // - `address` to the owner.
1625             // - `startTimestamp` to the timestamp of minting.
1626             // - `burned` to `false`.
1627             // - `nextInitialized` to `quantity == 1`.
1628             _packedOwnerships[startTokenId] = _packOwnershipData(
1629                 to,
1630                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1631             );
1632 
1633             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1634 
1635             _currentIndex = startTokenId + quantity;
1636         }
1637         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1638     }
1639 
1640     /**
1641      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1642      *
1643      * Requirements:
1644      *
1645      * - If `to` refers to a smart contract, it must implement
1646      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1647      * - `quantity` must be greater than 0.
1648      *
1649      * See {_mint}.
1650      *
1651      * Emits a {Transfer} event for each mint.
1652      */
1653     function _safeMint(
1654         address to,
1655         uint256 quantity,
1656         bytes memory _data
1657     ) internal virtual {
1658         _mint(to, quantity);
1659 
1660         unchecked {
1661             if (to.code.length != 0) {
1662                 uint256 end = _currentIndex;
1663                 uint256 index = end - quantity;
1664                 do {
1665                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1666                         revert TransferToNonERC721ReceiverImplementer();
1667                     }
1668                 } while (index < end);
1669                 // Reentrancy protection.
1670                 if (_currentIndex != end) revert();
1671             }
1672         }
1673     }
1674 
1675     /**
1676      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1677      */
1678     function _safeMint(address to, uint256 quantity) internal virtual {
1679         _safeMint(to, quantity, '');
1680     }
1681 
1682     // =============================================================
1683     //                        BURN OPERATIONS
1684     // =============================================================
1685 
1686     /**
1687      * @dev Equivalent to `_burn(tokenId, false)`.
1688      */
1689     function _burn(uint256 tokenId) internal virtual {
1690         _burn(tokenId, false);
1691     }
1692 
1693     /**
1694      * @dev Destroys `tokenId`.
1695      * The approval is cleared when the token is burned.
1696      *
1697      * Requirements:
1698      *
1699      * - `tokenId` must exist.
1700      *
1701      * Emits a {Transfer} event.
1702      */
1703     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1704         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1705 
1706         address from = address(uint160(prevOwnershipPacked));
1707 
1708         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1709 
1710         if (approvalCheck) {
1711             // The nested ifs save around 20+ gas over a compound boolean condition.
1712             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1713                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1714         }
1715 
1716         _beforeTokenTransfers(from, address(0), tokenId, 1);
1717 
1718         // Clear approvals from the previous owner.
1719         assembly {
1720             if approvedAddress {
1721                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1722                 sstore(approvedAddressSlot, 0)
1723             }
1724         }
1725 
1726         // Underflow of the sender's balance is impossible because we check for
1727         // ownership above and the recipient's balance can't realistically overflow.
1728         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1729         unchecked {
1730             // Updates:
1731             // - `balance -= 1`.
1732             // - `numberBurned += 1`.
1733             //
1734             // We can directly decrement the balance, and increment the number burned.
1735             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1736             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1737 
1738             // Updates:
1739             // - `address` to the last owner.
1740             // - `startTimestamp` to the timestamp of burning.
1741             // - `burned` to `true`.
1742             // - `nextInitialized` to `true`.
1743             _packedOwnerships[tokenId] = _packOwnershipData(
1744                 from,
1745                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1746             );
1747 
1748             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1749             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1750                 uint256 nextTokenId = tokenId + 1;
1751                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1752                 if (_packedOwnerships[nextTokenId] == 0) {
1753                     // If the next slot is within bounds.
1754                     if (nextTokenId != _currentIndex) {
1755                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1756                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1757                     }
1758                 }
1759             }
1760         }
1761 
1762         emit Transfer(from, address(0), tokenId);
1763         _afterTokenTransfers(from, address(0), tokenId, 1);
1764 
1765         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1766         unchecked {
1767             _burnCounter++;
1768         }
1769     }
1770 
1771     // =============================================================
1772     //                     EXTRA DATA OPERATIONS
1773     // =============================================================
1774 
1775     /**
1776      * @dev Directly sets the extra data for the ownership data `index`.
1777      */
1778     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1779         uint256 packed = _packedOwnerships[index];
1780         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1781         uint256 extraDataCasted;
1782         // Cast `extraData` with assembly to avoid redundant masking.
1783         assembly {
1784             extraDataCasted := extraData
1785         }
1786         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1787         _packedOwnerships[index] = packed;
1788     }
1789 
1790     /**
1791      * @dev Called during each token transfer to set the 24bit `extraData` field.
1792      * Intended to be overridden by the cosumer contract.
1793      *
1794      * `previousExtraData` - the value of `extraData` before transfer.
1795      *
1796      * Calling conditions:
1797      *
1798      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1799      * transferred to `to`.
1800      * - When `from` is zero, `tokenId` will be minted for `to`.
1801      * - When `to` is zero, `tokenId` will be burned by `from`.
1802      * - `from` and `to` are never both zero.
1803      */
1804     function _extraData(
1805         address from,
1806         address to,
1807         uint24 previousExtraData
1808     ) internal view virtual returns (uint24) {}
1809 
1810     /**
1811      * @dev Returns the next extra data for the packed ownership data.
1812      * The returned result is shifted into position.
1813      */
1814     function _nextExtraData(
1815         address from,
1816         address to,
1817         uint256 prevOwnershipPacked
1818     ) private view returns (uint256) {
1819         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1820         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1821     }
1822 
1823     // =============================================================
1824     //                       OTHER OPERATIONS
1825     // =============================================================
1826 
1827     /**
1828      * @dev Returns the message sender (defaults to `msg.sender`).
1829      *
1830      * If you are writing GSN compatible contracts, you need to override this function.
1831      */
1832     function _msgSenderERC721A() internal view virtual returns (address) {
1833         return msg.sender;
1834     }
1835 
1836     /**
1837      * @dev Converts a uint256 to its ASCII string decimal representation.
1838      */
1839     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1840         assembly {
1841             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1842             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1843             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1844             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1845             let m := add(mload(0x40), 0xa0)
1846             // Update the free memory pointer to allocate.
1847             mstore(0x40, m)
1848             // Assign the `str` to the end.
1849             str := sub(m, 0x20)
1850             // Zeroize the slot after the string.
1851             mstore(str, 0)
1852 
1853             // Cache the end of the memory to calculate the length later.
1854             let end := str
1855 
1856             // We write the string from rightmost digit to leftmost digit.
1857             // The following is essentially a do-while loop that also handles the zero case.
1858             // prettier-ignore
1859             for { let temp := value } 1 {} {
1860                 str := sub(str, 1)
1861                 // Write the character to the pointer.
1862                 // The ASCII index of the '0' character is 48.
1863                 mstore8(str, add(48, mod(temp, 10)))
1864                 // Keep dividing `temp` until zero.
1865                 temp := div(temp, 10)
1866                 // prettier-ignore
1867                 if iszero(temp) { break }
1868             }
1869 
1870             let length := sub(end, str)
1871             // Move the pointer 32 bytes leftwards to make room for the length.
1872             str := sub(str, 0x20)
1873             // Store the length.
1874             mstore(str, length)
1875         }
1876     }
1877 }
1878 
1879 // File: contracts/BoredTrialApeClub.sol
1880 
1881 
1882 
1883 pragma solidity ^0.8.7;
1884 
1885 ///@dev
1886 // Dependencies:
1887 // npm i --save-dev erc721a
1888 // npm i @openzeppelin/contracts
1889 // import "erc721a/contracts/ERC721A.sol";
1890 // created by: Xaikyō
1891 
1892 
1893 
1894 
1895 
1896 
1897 
1898 contract BoredTrialApeClub is ERC721A, Ownable, ReentrancyGuard, Pausable{
1899 
1900     // uint256 mint variables
1901     uint256 public maxSupply = 6969;
1902     uint256 public mintPrice = 0.005 ether; // @dev 10 finney = 0.01 ether
1903     uint256 public wlMaxMint = 10;
1904     uint256 public wlMintPrice = 0.003 ether;
1905     uint256 public freeMax = 1;
1906 
1907     //base uri, base extension
1908     string public baseExtension = ".json";
1909     string public baseURI;
1910 
1911     // booleans for if mint is enabled
1912     bool public publicMintEnabled = false;
1913     bool public wlMintEnabled = false;
1914     bool public revealed = false;
1915 
1916     // mappings to keep track of # of minted tokens per user
1917     mapping(address => uint256) public totalWlMint;
1918     mapping(address => uint256) public totalFreeMints;
1919 
1920     // merkle root
1921     bytes32 public root;
1922 
1923     constructor (
1924         string memory _initBaseURI,
1925         bytes32 _root
1926         ) ERC721A("Bored Trial Ape Club", "BTAC") {
1927             setBaseURI(_initBaseURI);
1928             setRoot(_root); 
1929     }
1930 
1931     function teamMint(address[] calldata _address, uint256 _amount) external onlyOwner nonReentrant {
1932 
1933         require(totalSupply() + _amount <= maxSupply, "Error: max supply reached");
1934 
1935         for (uint i = 0; i < _address.length; i++) {
1936             _safeMint(_address[i], _amount);
1937         }
1938     }
1939 
1940     // Whitelist mint that requires merkle proof; user receives 1 free 
1941     function whitelistMint(uint256 _quantity, bytes32[] memory proof) external payable whenNotPaused nonReentrant {
1942         
1943         if (totalFreeMints[msg.sender] == 0 && freeMax <= 1000) {
1944             require(freeMax <= 1000, "No more free apes left!");
1945             require(isValid(proof, keccak256(abi.encodePacked(msg.sender))), "Not a part of whitelist");
1946             require(wlMintEnabled, "Whitelist mint is currently paused");
1947             require(totalSupply() + _quantity <= maxSupply, "Error: max supply reached");
1948             require((totalWlMint[msg.sender] + _quantity) <= wlMaxMint, "Error: Cannot mint more than 10");
1949             require(msg.value >= ((_quantity * wlMintPrice) - wlMintPrice), "Not enough ether sent");
1950 
1951             totalFreeMints[msg.sender] += 1;
1952             freeMax += 1;
1953             totalWlMint[msg.sender] += _quantity;
1954             _safeMint(msg.sender, _quantity);
1955 
1956         } else {
1957             require(isValid(proof, keccak256(abi.encodePacked(msg.sender))), "Not a part of whitelist");
1958             require(wlMintEnabled, "Whitelist mint is currently paused");
1959             require(totalSupply() + _quantity <= maxSupply, "Error: max supply reached");
1960             require((totalWlMint[msg.sender] + _quantity) <= wlMaxMint, "Error: Cannot mint more than 10");
1961             require(msg.value >= (_quantity * wlMintPrice), "Not enough ether sent");
1962 
1963             totalWlMint[msg.sender] += _quantity;
1964             _safeMint(msg.sender, _quantity);
1965 
1966         }
1967     }
1968 
1969     // verify merkle proof with a buf2hex(keccak256(address)) or keccak256(abi.encodePacked(address))
1970     function isValid(bytes32[] memory proof, bytes32 leaf) public view returns(bool) {
1971         return MerkleProof.verify(proof, root, leaf);
1972     }
1973 
1974     // Public mint with 20 per tx limit
1975 
1976     function publicMint(uint256 _quantity) external payable whenNotPaused nonReentrant {
1977         require(_quantity <= 20, "Cannot mint more than 20 per tx");
1978         require(publicMintEnabled, "Public mint is currently paused");
1979         require(msg.value >= (_quantity * mintPrice), "Not enough ether sent");
1980         require(totalSupply() + _quantity <= maxSupply, "Error: max supply reached");
1981 
1982         _safeMint(msg.sender, _quantity);
1983     }
1984 
1985     
1986 
1987     // returns the baseuri of collection, private
1988     function _baseURI() internal view virtual override returns (string memory) {
1989         return baseURI;
1990     }
1991 
1992     // override _statTokenId() from erc721a to start tokenId at 1
1993     function _startTokenId() internal view virtual override returns (uint256) {
1994         return 1;
1995     }
1996 
1997     // return tokenUri given the tokenId
1998 
1999     function tokenURI(uint256 tokenId)
2000     public
2001     view
2002     virtual
2003     override
2004     returns (string memory)
2005     {
2006     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
2007     
2008     if (revealed == false) {
2009         return baseURI;
2010     } else {
2011         string memory currentBaseURI = _baseURI();
2012         return bytes(currentBaseURI).length > 0
2013         ? string(abi.encodePacked(currentBaseURI, _toString(tokenId), baseExtension))
2014         : "";
2015     }
2016         
2017     }
2018 
2019     // owner updates and functions
2020 
2021     function togglePublicMint() external onlyOwner nonReentrant{
2022         publicMintEnabled = !publicMintEnabled;
2023     }
2024 
2025     function toggleWlMint() external onlyOwner nonReentrant{
2026         wlMintEnabled = !wlMintEnabled;
2027     }
2028 
2029     function enableBothMints() external onlyOwner nonReentrant{
2030         wlMintEnabled = true;
2031         publicMintEnabled = true;
2032     }
2033 
2034     function setPrice(uint256 _mintPrice) external onlyOwner nonReentrant{
2035     mintPrice = _mintPrice;
2036     }
2037 
2038     function setWlPrice(uint256 _wlMintPrice) external onlyOwner nonReentrant{
2039     wlMintPrice = _wlMintPrice;
2040     }
2041 
2042     function setmaxWl(uint256 _wlMaxMint) external onlyOwner nonReentrant{
2043     wlMaxMint = _wlMaxMint;
2044     }
2045   
2046     function pause() public onlyOwner nonReentrant{ 
2047         _pause();
2048     }
2049 
2050     function unpause() public onlyOwner nonReentrant{
2051         _unpause();
2052     }
2053 
2054     function setBaseURI(string memory _newURI) public onlyOwner nonReentrant{
2055         baseURI = _newURI;
2056     }
2057 
2058     function toggleReveal() public onlyOwner nonReentrant {
2059         revealed = !revealed;
2060     }
2061 
2062     function setRoot(bytes32 _root) public onlyOwner nonReentrant {
2063         root = _root;
2064     }
2065 
2066     // withdraw to owner(), i.e only if msg.sender is owner
2067     function withdraw() external onlyOwner nonReentrant {
2068 
2069         payable(0x3e242C5CFfbF57cB3575Bc0e0327eaE8bD7f0252).transfer(address(this).balance * 15 / 100);
2070 
2071         payable(owner()).transfer(address(this).balance);
2072     }
2073 
2074 
2075 }