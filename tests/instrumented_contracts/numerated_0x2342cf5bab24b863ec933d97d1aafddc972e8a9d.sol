1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 // SPDX-License-Identifier: MIT
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
394 // File: erc721a/contracts/IERC721A.sol
395 
396 
397 // ERC721A Contracts v4.1.0
398 // Creator: Chiru Labs
399 
400 pragma solidity ^0.8.4;
401 
402 /**
403  * @dev Interface of an ERC721A compliant contract.
404  */
405 interface IERC721A {
406     /**
407      * The caller must own the token or be an approved operator.
408      */
409     error ApprovalCallerNotOwnerNorApproved();
410 
411     /**
412      * The token does not exist.
413      */
414     error ApprovalQueryForNonexistentToken();
415 
416     /**
417      * The caller cannot approve to their own address.
418      */
419     error ApproveToCaller();
420 
421     /**
422      * Cannot query the balance for the zero address.
423      */
424     error BalanceQueryForZeroAddress();
425 
426     /**
427      * Cannot mint to the zero address.
428      */
429     error MintToZeroAddress();
430 
431     /**
432      * The quantity of tokens minted must be more than zero.
433      */
434     error MintZeroQuantity();
435 
436     /**
437      * The token does not exist.
438      */
439     error OwnerQueryForNonexistentToken();
440 
441     /**
442      * The caller must own the token or be an approved operator.
443      */
444     error TransferCallerNotOwnerNorApproved();
445 
446     /**
447      * The token must be owned by `from`.
448      */
449     error TransferFromIncorrectOwner();
450 
451     /**
452      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
453      */
454     error TransferToNonERC721ReceiverImplementer();
455 
456     /**
457      * Cannot transfer to the zero address.
458      */
459     error TransferToZeroAddress();
460 
461     /**
462      * The token does not exist.
463      */
464     error URIQueryForNonexistentToken();
465 
466     /**
467      * The `quantity` minted with ERC2309 exceeds the safety limit.
468      */
469     error MintERC2309QuantityExceedsLimit();
470 
471     /**
472      * The `extraData` cannot be set on an unintialized ownership slot.
473      */
474     error OwnershipNotInitializedForExtraData();
475 
476     struct TokenOwnership {
477         // The address of the owner.
478         address addr;
479         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
480         uint64 startTimestamp;
481         // Whether the token has been burned.
482         bool burned;
483         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
484         uint24 extraData;
485     }
486 
487     /**
488      * @dev Returns the total amount of tokens stored by the contract.
489      *
490      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
491      */
492     function totalSupply() external view returns (uint256);
493 
494     // ==============================
495     //            IERC165
496     // ==============================
497 
498     /**
499      * @dev Returns true if this contract implements the interface defined by
500      * `interfaceId`. See the corresponding
501      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
502      * to learn more about how these ids are created.
503      *
504      * This function call must use less than 30 000 gas.
505      */
506     function supportsInterface(bytes4 interfaceId) external view returns (bool);
507 
508     // ==============================
509     //            IERC721
510     // ==============================
511 
512     /**
513      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
514      */
515     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
516 
517     /**
518      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
519      */
520     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
521 
522     /**
523      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
524      */
525     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
526 
527     /**
528      * @dev Returns the number of tokens in ``owner``'s account.
529      */
530     function balanceOf(address owner) external view returns (uint256 balance);
531 
532     /**
533      * @dev Returns the owner of the `tokenId` token.
534      *
535      * Requirements:
536      *
537      * - `tokenId` must exist.
538      */
539     function ownerOf(uint256 tokenId) external view returns (address owner);
540 
541     /**
542      * @dev Safely transfers `tokenId` token from `from` to `to`.
543      *
544      * Requirements:
545      *
546      * - `from` cannot be the zero address.
547      * - `to` cannot be the zero address.
548      * - `tokenId` token must exist and be owned by `from`.
549      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
550      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
551      *
552      * Emits a {Transfer} event.
553      */
554     function safeTransferFrom(
555         address from,
556         address to,
557         uint256 tokenId,
558         bytes calldata data
559     ) external;
560 
561     /**
562      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
563      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
564      *
565      * Requirements:
566      *
567      * - `from` cannot be the zero address.
568      * - `to` cannot be the zero address.
569      * - `tokenId` token must exist and be owned by `from`.
570      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
571      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
572      *
573      * Emits a {Transfer} event.
574      */
575     function safeTransferFrom(
576         address from,
577         address to,
578         uint256 tokenId
579     ) external;
580 
581     /**
582      * @dev Transfers `tokenId` token from `from` to `to`.
583      *
584      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
585      *
586      * Requirements:
587      *
588      * - `from` cannot be the zero address.
589      * - `to` cannot be the zero address.
590      * - `tokenId` token must be owned by `from`.
591      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
592      *
593      * Emits a {Transfer} event.
594      */
595     function transferFrom(
596         address from,
597         address to,
598         uint256 tokenId
599     ) external;
600 
601     /**
602      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
603      * The approval is cleared when the token is transferred.
604      *
605      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
606      *
607      * Requirements:
608      *
609      * - The caller must own the token or be an approved operator.
610      * - `tokenId` must exist.
611      *
612      * Emits an {Approval} event.
613      */
614     function approve(address to, uint256 tokenId) external;
615 
616     /**
617      * @dev Approve or remove `operator` as an operator for the caller.
618      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
619      *
620      * Requirements:
621      *
622      * - The `operator` cannot be the caller.
623      *
624      * Emits an {ApprovalForAll} event.
625      */
626     function setApprovalForAll(address operator, bool _approved) external;
627 
628     /**
629      * @dev Returns the account approved for `tokenId` token.
630      *
631      * Requirements:
632      *
633      * - `tokenId` must exist.
634      */
635     function getApproved(uint256 tokenId) external view returns (address operator);
636 
637     /**
638      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
639      *
640      * See {setApprovalForAll}
641      */
642     function isApprovedForAll(address owner, address operator) external view returns (bool);
643 
644     // ==============================
645     //        IERC721Metadata
646     // ==============================
647 
648     /**
649      * @dev Returns the token collection name.
650      */
651     function name() external view returns (string memory);
652 
653     /**
654      * @dev Returns the token collection symbol.
655      */
656     function symbol() external view returns (string memory);
657 
658     /**
659      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
660      */
661     function tokenURI(uint256 tokenId) external view returns (string memory);
662 
663     // ==============================
664     //            IERC2309
665     // ==============================
666 
667     /**
668      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
669      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
670      */
671     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
672 }
673 
674 // File: erc721a/contracts/ERC721A.sol
675 
676 
677 // ERC721A Contracts v4.1.0
678 // Creator: Chiru Labs
679 
680 pragma solidity ^0.8.4;
681 
682 
683 /**
684  * @dev ERC721 token receiver interface.
685  */
686 interface ERC721A__IERC721Receiver {
687     function onERC721Received(
688         address operator,
689         address from,
690         uint256 tokenId,
691         bytes calldata data
692     ) external returns (bytes4);
693 }
694 
695 /**
696  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
697  * including the Metadata extension. Built to optimize for lower gas during batch mints.
698  *
699  * Assumes serials are sequentially minted starting at `_startTokenId()`
700  * (defaults to 0, e.g. 0, 1, 2, 3..).
701  *
702  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
703  *
704  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
705  */
706 contract ERC721A is IERC721A {
707     // Mask of an entry in packed address data.
708     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
709 
710     // The bit position of `numberMinted` in packed address data.
711     uint256 private constant BITPOS_NUMBER_MINTED = 64;
712 
713     // The bit position of `numberBurned` in packed address data.
714     uint256 private constant BITPOS_NUMBER_BURNED = 128;
715 
716     // The bit position of `aux` in packed address data.
717     uint256 private constant BITPOS_AUX = 192;
718 
719     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
720     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
721 
722     // The bit position of `startTimestamp` in packed ownership.
723     uint256 private constant BITPOS_START_TIMESTAMP = 160;
724 
725     // The bit mask of the `burned` bit in packed ownership.
726     uint256 private constant BITMASK_BURNED = 1 << 224;
727 
728     // The bit position of the `nextInitialized` bit in packed ownership.
729     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
730 
731     // The bit mask of the `nextInitialized` bit in packed ownership.
732     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
733 
734     // The bit position of `extraData` in packed ownership.
735     uint256 private constant BITPOS_EXTRA_DATA = 232;
736 
737     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
738     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
739 
740     // The mask of the lower 160 bits for addresses.
741     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
742 
743     // The maximum `quantity` that can be minted with `_mintERC2309`.
744     // This limit is to prevent overflows on the address data entries.
745     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
746     // is required to cause an overflow, which is unrealistic.
747     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
748 
749     // The tokenId of the next token to be minted.
750     uint256 private _currentIndex;
751 
752     // The number of tokens burned.
753     uint256 private _burnCounter;
754 
755     // Token name
756     string private _name;
757 
758     // Token symbol
759     string private _symbol;
760 
761     // Mapping from token ID to ownership details
762     // An empty struct value does not necessarily mean the token is unowned.
763     // See `_packedOwnershipOf` implementation for details.
764     //
765     // Bits Layout:
766     // - [0..159]   `addr`
767     // - [160..223] `startTimestamp`
768     // - [224]      `burned`
769     // - [225]      `nextInitialized`
770     // - [232..255] `extraData`
771     mapping(uint256 => uint256) private _packedOwnerships;
772 
773     // Mapping owner address to address data.
774     //
775     // Bits Layout:
776     // - [0..63]    `balance`
777     // - [64..127]  `numberMinted`
778     // - [128..191] `numberBurned`
779     // - [192..255] `aux`
780     mapping(address => uint256) private _packedAddressData;
781 
782     // Mapping from token ID to approved address.
783     mapping(uint256 => address) private _tokenApprovals;
784 
785     // Mapping from owner to operator approvals
786     mapping(address => mapping(address => bool)) private _operatorApprovals;
787 
788     constructor(string memory name_, string memory symbol_) {
789         _name = name_;
790         _symbol = symbol_;
791         _currentIndex = _startTokenId();
792     }
793 
794     /**
795      * @dev Returns the starting token ID.
796      * To change the starting token ID, please override this function.
797      */
798     function _startTokenId() internal view virtual returns (uint256) {
799         return 0;
800     }
801 
802     /**
803      * @dev Returns the next token ID to be minted.
804      */
805     function _nextTokenId() internal view returns (uint256) {
806         return _currentIndex;
807     }
808 
809     /**
810      * @dev Returns the total number of tokens in existence.
811      * Burned tokens will reduce the count.
812      * To get the total number of tokens minted, please see `_totalMinted`.
813      */
814     function totalSupply() public view override returns (uint256) {
815         // Counter underflow is impossible as _burnCounter cannot be incremented
816         // more than `_currentIndex - _startTokenId()` times.
817         unchecked {
818             return _currentIndex - _burnCounter - _startTokenId();
819         }
820     }
821 
822     /**
823      * @dev Returns the total amount of tokens minted in the contract.
824      */
825     function _totalMinted() internal view returns (uint256) {
826         // Counter underflow is impossible as _currentIndex does not decrement,
827         // and it is initialized to `_startTokenId()`
828         unchecked {
829             return _currentIndex - _startTokenId();
830         }
831     }
832 
833     /**
834      * @dev Returns the total number of tokens burned.
835      */
836     function _totalBurned() internal view returns (uint256) {
837         return _burnCounter;
838     }
839 
840     /**
841      * @dev See {IERC165-supportsInterface}.
842      */
843     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
844         // The interface IDs are constants representing the first 4 bytes of the XOR of
845         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
846         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
847         return
848             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
849             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
850             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
851     }
852 
853     /**
854      * @dev See {IERC721-balanceOf}.
855      */
856     function balanceOf(address owner) public view override returns (uint256) {
857         if (owner == address(0)) revert BalanceQueryForZeroAddress();
858         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
859     }
860 
861     /**
862      * Returns the number of tokens minted by `owner`.
863      */
864     function _numberMinted(address owner) internal view returns (uint256) {
865         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
866     }
867 
868     /**
869      * Returns the number of tokens burned by or on behalf of `owner`.
870      */
871     function _numberBurned(address owner) internal view returns (uint256) {
872         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
873     }
874 
875     /**
876      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
877      */
878     function _getAux(address owner) internal view returns (uint64) {
879         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
880     }
881 
882     /**
883      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
884      * If there are multiple variables, please pack them into a uint64.
885      */
886     function _setAux(address owner, uint64 aux) internal {
887         uint256 packed = _packedAddressData[owner];
888         uint256 auxCasted;
889         // Cast `aux` with assembly to avoid redundant masking.
890         assembly {
891             auxCasted := aux
892         }
893         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
894         _packedAddressData[owner] = packed;
895     }
896 
897     /**
898      * Returns the packed ownership data of `tokenId`.
899      */
900     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
901         uint256 curr = tokenId;
902 
903         unchecked {
904             if (_startTokenId() <= curr)
905                 if (curr < _currentIndex) {
906                     uint256 packed = _packedOwnerships[curr];
907                     // If not burned.
908                     if (packed & BITMASK_BURNED == 0) {
909                         // Invariant:
910                         // There will always be an ownership that has an address and is not burned
911                         // before an ownership that does not have an address and is not burned.
912                         // Hence, curr will not underflow.
913                         //
914                         // We can directly compare the packed value.
915                         // If the address is zero, packed is zero.
916                         while (packed == 0) {
917                             packed = _packedOwnerships[--curr];
918                         }
919                         return packed;
920                     }
921                 }
922         }
923         revert OwnerQueryForNonexistentToken();
924     }
925 
926     /**
927      * Returns the unpacked `TokenOwnership` struct from `packed`.
928      */
929     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
930         ownership.addr = address(uint160(packed));
931         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
932         ownership.burned = packed & BITMASK_BURNED != 0;
933         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
934     }
935 
936     /**
937      * Returns the unpacked `TokenOwnership` struct at `index`.
938      */
939     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
940         return _unpackedOwnership(_packedOwnerships[index]);
941     }
942 
943     /**
944      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
945      */
946     function _initializeOwnershipAt(uint256 index) internal {
947         if (_packedOwnerships[index] == 0) {
948             _packedOwnerships[index] = _packedOwnershipOf(index);
949         }
950     }
951 
952     /**
953      * Gas spent here starts off proportional to the maximum mint batch size.
954      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
955      */
956     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
957         return _unpackedOwnership(_packedOwnershipOf(tokenId));
958     }
959 
960     /**
961      * @dev Packs ownership data into a single uint256.
962      */
963     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
964         assembly {
965             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
966             owner := and(owner, BITMASK_ADDRESS)
967             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
968             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
969         }
970     }
971 
972     /**
973      * @dev See {IERC721-ownerOf}.
974      */
975     function ownerOf(uint256 tokenId) public view override returns (address) {
976         return address(uint160(_packedOwnershipOf(tokenId)));
977     }
978 
979     /**
980      * @dev See {IERC721Metadata-name}.
981      */
982     function name() public view virtual override returns (string memory) {
983         return _name;
984     }
985 
986     /**
987      * @dev See {IERC721Metadata-symbol}.
988      */
989     function symbol() public view virtual override returns (string memory) {
990         return _symbol;
991     }
992 
993     /**
994      * @dev See {IERC721Metadata-tokenURI}.
995      */
996     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
997         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
998 
999         string memory baseURI = _baseURI();
1000         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), '.json')) : '';
1001     }
1002 
1003     /**
1004      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1005      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1006      * by default, it can be overridden in child contracts.
1007      */
1008     function _baseURI() internal view virtual returns (string memory) {
1009         return '';
1010     }
1011 
1012     /**
1013      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1014      */
1015     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1016         // For branchless setting of the `nextInitialized` flag.
1017         assembly {
1018             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1019             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1020         }
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-approve}.
1025      */
1026     function approve(address to, uint256 tokenId) public override {
1027         address owner = ownerOf(tokenId);
1028 
1029         if (_msgSenderERC721A() != owner)
1030             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1031                 revert ApprovalCallerNotOwnerNorApproved();
1032             }
1033 
1034         _tokenApprovals[tokenId] = to;
1035         emit Approval(owner, to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-getApproved}.
1040      */
1041     function getApproved(uint256 tokenId) public view override returns (address) {
1042         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1043 
1044         return _tokenApprovals[tokenId];
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-setApprovalForAll}.
1049      */
1050     function setApprovalForAll(address operator, bool approved) public virtual override {
1051         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1052 
1053         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1054         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-isApprovedForAll}.
1059      */
1060     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1061         return _operatorApprovals[owner][operator];
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-safeTransferFrom}.
1066      */
1067     function safeTransferFrom(
1068         address from,
1069         address to,
1070         uint256 tokenId
1071     ) public virtual override {
1072         safeTransferFrom(from, to, tokenId, '');
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-safeTransferFrom}.
1077      */
1078     function safeTransferFrom(
1079         address from,
1080         address to,
1081         uint256 tokenId,
1082         bytes memory _data
1083     ) public virtual override {
1084         transferFrom(from, to, tokenId);
1085         if (to.code.length != 0)
1086             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1087                 revert TransferToNonERC721ReceiverImplementer();
1088             }
1089     }
1090 
1091     /**
1092      * @dev Returns whether `tokenId` exists.
1093      *
1094      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1095      *
1096      * Tokens start existing when they are minted (`_mint`),
1097      */
1098     function _exists(uint256 tokenId) internal view returns (bool) {
1099         return
1100             _startTokenId() <= tokenId &&
1101             tokenId < _currentIndex && // If within bounds,
1102             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1103     }
1104 
1105     /**
1106      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1107      */
1108     function _safeMint(address to, uint256 quantity) internal {
1109         _safeMint(to, quantity, '');
1110     }
1111 
1112     /**
1113      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1114      *
1115      * Requirements:
1116      *
1117      * - If `to` refers to a smart contract, it must implement
1118      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1119      * - `quantity` must be greater than 0.
1120      *
1121      * See {_mint}.
1122      *
1123      * Emits a {Transfer} event for each mint.
1124      */
1125     function _safeMint(
1126         address to,
1127         uint256 quantity,
1128         bytes memory _data
1129     ) internal {
1130         _mint(to, quantity);
1131 
1132         unchecked {
1133             if (to.code.length != 0) {
1134                 uint256 end = _currentIndex;
1135                 uint256 index = end - quantity;
1136                 do {
1137                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1138                         revert TransferToNonERC721ReceiverImplementer();
1139                     }
1140                 } while (index < end);
1141                 // Reentrancy protection.
1142                 if (_currentIndex != end) revert();
1143             }
1144         }
1145     }
1146 
1147     /**
1148      * @dev Mints `quantity` tokens and transfers them to `to`.
1149      *
1150      * Requirements:
1151      *
1152      * - `to` cannot be the zero address.
1153      * - `quantity` must be greater than 0.
1154      *
1155      * Emits a {Transfer} event for each mint.
1156      */
1157     function _mint(address to, uint256 quantity) internal {
1158         uint256 startTokenId = _currentIndex;
1159         if (to == address(0)) revert MintToZeroAddress();
1160         if (quantity == 0) revert MintZeroQuantity();
1161 
1162         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1163 
1164         // Overflows are incredibly unrealistic.
1165         // `balance` and `numberMinted` have a maximum limit of 2**64.
1166         // `tokenId` has a maximum limit of 2**256.
1167         unchecked {
1168             // Updates:
1169             // - `balance += quantity`.
1170             // - `numberMinted += quantity`.
1171             //
1172             // We can directly add to the `balance` and `numberMinted`.
1173             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1174 
1175             // Updates:
1176             // - `address` to the owner.
1177             // - `startTimestamp` to the timestamp of minting.
1178             // - `burned` to `false`.
1179             // - `nextInitialized` to `quantity == 1`.
1180             _packedOwnerships[startTokenId] = _packOwnershipData(
1181                 to,
1182                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1183             );
1184 
1185             uint256 tokenId = startTokenId;
1186             uint256 end = startTokenId + quantity;
1187             do {
1188                 emit Transfer(address(0), to, tokenId++);
1189             } while (tokenId < end);
1190 
1191             _currentIndex = end;
1192         }
1193         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1194     }
1195 
1196     /**
1197      * @dev Mints `quantity` tokens and transfers them to `to`.
1198      *
1199      * This function is intended for efficient minting only during contract creation.
1200      *
1201      * It emits only one {ConsecutiveTransfer} as defined in
1202      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1203      * instead of a sequence of {Transfer} event(s).
1204      *
1205      * Calling this function outside of contract creation WILL make your contract
1206      * non-compliant with the ERC721 standard.
1207      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1208      * {ConsecutiveTransfer} event is only permissible during contract creation.
1209      *
1210      * Requirements:
1211      *
1212      * - `to` cannot be the zero address.
1213      * - `quantity` must be greater than 0.
1214      *
1215      * Emits a {ConsecutiveTransfer} event.
1216      */
1217     function _mintERC2309(address to, uint256 quantity) internal {
1218         uint256 startTokenId = _currentIndex;
1219         if (to == address(0)) revert MintToZeroAddress();
1220         if (quantity == 0) revert MintZeroQuantity();
1221         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1222 
1223         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1224 
1225         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1226         unchecked {
1227             // Updates:
1228             // - `balance += quantity`.
1229             // - `numberMinted += quantity`.
1230             //
1231             // We can directly add to the `balance` and `numberMinted`.
1232             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1233 
1234             // Updates:
1235             // - `address` to the owner.
1236             // - `startTimestamp` to the timestamp of minting.
1237             // - `burned` to `false`.
1238             // - `nextInitialized` to `quantity == 1`.
1239             _packedOwnerships[startTokenId] = _packOwnershipData(
1240                 to,
1241                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1242             );
1243 
1244             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1245 
1246             _currentIndex = startTokenId + quantity;
1247         }
1248         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1249     }
1250 
1251     /**
1252      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1253      */
1254     function _getApprovedAddress(uint256 tokenId)
1255         private
1256         view
1257         returns (uint256 approvedAddressSlot, address approvedAddress)
1258     {
1259         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1260         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1261         assembly {
1262             // Compute the slot.
1263             mstore(0x00, tokenId)
1264             mstore(0x20, tokenApprovalsPtr.slot)
1265             approvedAddressSlot := keccak256(0x00, 0x40)
1266             // Load the slot's value from storage.
1267             approvedAddress := sload(approvedAddressSlot)
1268         }
1269     }
1270 
1271     /**
1272      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1273      */
1274     function _isOwnerOrApproved(
1275         address approvedAddress,
1276         address from,
1277         address msgSender
1278     ) private pure returns (bool result) {
1279         assembly {
1280             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1281             from := and(from, BITMASK_ADDRESS)
1282             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1283             msgSender := and(msgSender, BITMASK_ADDRESS)
1284             // `msgSender == from || msgSender == approvedAddress`.
1285             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1286         }
1287     }
1288 
1289     /**
1290      * @dev Transfers `tokenId` from `from` to `to`.
1291      *
1292      * Requirements:
1293      *
1294      * - `to` cannot be the zero address.
1295      * - `tokenId` token must be owned by `from`.
1296      *
1297      * Emits a {Transfer} event.
1298      */
1299     function transferFrom(
1300         address from,
1301         address to,
1302         uint256 tokenId
1303     ) public virtual override {
1304         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1305 
1306         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1307 
1308         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1309 
1310         // The nested ifs save around 20+ gas over a compound boolean condition.
1311         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1312             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1313 
1314         if (to == address(0)) revert TransferToZeroAddress();
1315 
1316         _beforeTokenTransfers(from, to, tokenId, 1);
1317 
1318         // Clear approvals from the previous owner.
1319         assembly {
1320             if approvedAddress {
1321                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1322                 sstore(approvedAddressSlot, 0)
1323             }
1324         }
1325 
1326         // Underflow of the sender's balance is impossible because we check for
1327         // ownership above and the recipient's balance can't realistically overflow.
1328         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1329         unchecked {
1330             // We can directly increment and decrement the balances.
1331             --_packedAddressData[from]; // Updates: `balance -= 1`.
1332             ++_packedAddressData[to]; // Updates: `balance += 1`.
1333 
1334             // Updates:
1335             // - `address` to the next owner.
1336             // - `startTimestamp` to the timestamp of transfering.
1337             // - `burned` to `false`.
1338             // - `nextInitialized` to `true`.
1339             _packedOwnerships[tokenId] = _packOwnershipData(
1340                 to,
1341                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1342             );
1343 
1344             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1345             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1346                 uint256 nextTokenId = tokenId + 1;
1347                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1348                 if (_packedOwnerships[nextTokenId] == 0) {
1349                     // If the next slot is within bounds.
1350                     if (nextTokenId != _currentIndex) {
1351                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1352                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1353                     }
1354                 }
1355             }
1356         }
1357 
1358         emit Transfer(from, to, tokenId);
1359         _afterTokenTransfers(from, to, tokenId, 1);
1360     }
1361 
1362     /**
1363      * @dev Equivalent to `_burn(tokenId, false)`.
1364      */
1365     function _burn(uint256 tokenId) internal virtual {
1366         _burn(tokenId, false);
1367     }
1368 
1369     /**
1370      * @dev Destroys `tokenId`.
1371      * The approval is cleared when the token is burned.
1372      *
1373      * Requirements:
1374      *
1375      * - `tokenId` must exist.
1376      *
1377      * Emits a {Transfer} event.
1378      */
1379     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1380         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1381 
1382         address from = address(uint160(prevOwnershipPacked));
1383 
1384         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1385 
1386         if (approvalCheck) {
1387             // The nested ifs save around 20+ gas over a compound boolean condition.
1388             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1389                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1390         }
1391 
1392         _beforeTokenTransfers(from, address(0), tokenId, 1);
1393 
1394         // Clear approvals from the previous owner.
1395         assembly {
1396             if approvedAddress {
1397                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1398                 sstore(approvedAddressSlot, 0)
1399             }
1400         }
1401 
1402         // Underflow of the sender's balance is impossible because we check for
1403         // ownership above and the recipient's balance can't realistically overflow.
1404         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1405         unchecked {
1406             // Updates:
1407             // - `balance -= 1`.
1408             // - `numberBurned += 1`.
1409             //
1410             // We can directly decrement the balance, and increment the number burned.
1411             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1412             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1413 
1414             // Updates:
1415             // - `address` to the last owner.
1416             // - `startTimestamp` to the timestamp of burning.
1417             // - `burned` to `true`.
1418             // - `nextInitialized` to `true`.
1419             _packedOwnerships[tokenId] = _packOwnershipData(
1420                 from,
1421                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1422             );
1423 
1424             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1425             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1426                 uint256 nextTokenId = tokenId + 1;
1427                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1428                 if (_packedOwnerships[nextTokenId] == 0) {
1429                     // If the next slot is within bounds.
1430                     if (nextTokenId != _currentIndex) {
1431                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1432                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1433                     }
1434                 }
1435             }
1436         }
1437 
1438         emit Transfer(from, address(0), tokenId);
1439         _afterTokenTransfers(from, address(0), tokenId, 1);
1440 
1441         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1442         unchecked {
1443             _burnCounter++;
1444         }
1445     }
1446 
1447     /**
1448      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1449      *
1450      * @param from address representing the previous owner of the given token ID
1451      * @param to target address that will receive the tokens
1452      * @param tokenId uint256 ID of the token to be transferred
1453      * @param _data bytes optional data to send along with the call
1454      * @return bool whether the call correctly returned the expected magic value
1455      */
1456     function _checkContractOnERC721Received(
1457         address from,
1458         address to,
1459         uint256 tokenId,
1460         bytes memory _data
1461     ) private returns (bool) {
1462         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1463             bytes4 retval
1464         ) {
1465             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1466         } catch (bytes memory reason) {
1467             if (reason.length == 0) {
1468                 revert TransferToNonERC721ReceiverImplementer();
1469             } else {
1470                 assembly {
1471                     revert(add(32, reason), mload(reason))
1472                 }
1473             }
1474         }
1475     }
1476 
1477     /**
1478      * @dev Directly sets the extra data for the ownership data `index`.
1479      */
1480     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1481         uint256 packed = _packedOwnerships[index];
1482         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1483         uint256 extraDataCasted;
1484         // Cast `extraData` with assembly to avoid redundant masking.
1485         assembly {
1486             extraDataCasted := extraData
1487         }
1488         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1489         _packedOwnerships[index] = packed;
1490     }
1491 
1492     /**
1493      * @dev Returns the next extra data for the packed ownership data.
1494      * The returned result is shifted into position.
1495      */
1496     function _nextExtraData(
1497         address from,
1498         address to,
1499         uint256 prevOwnershipPacked
1500     ) private view returns (uint256) {
1501         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1502         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1503     }
1504 
1505     /**
1506      * @dev Called during each token transfer to set the 24bit `extraData` field.
1507      * Intended to be overridden by the cosumer contract.
1508      *
1509      * `previousExtraData` - the value of `extraData` before transfer.
1510      *
1511      * Calling conditions:
1512      *
1513      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1514      * transferred to `to`.
1515      * - When `from` is zero, `tokenId` will be minted for `to`.
1516      * - When `to` is zero, `tokenId` will be burned by `from`.
1517      * - `from` and `to` are never both zero.
1518      */
1519     function _extraData(
1520         address from,
1521         address to,
1522         uint24 previousExtraData
1523     ) internal view virtual returns (uint24) {}
1524 
1525     /**
1526      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1527      * This includes minting.
1528      * And also called before burning one token.
1529      *
1530      * startTokenId - the first token id to be transferred
1531      * quantity - the amount to be transferred
1532      *
1533      * Calling conditions:
1534      *
1535      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1536      * transferred to `to`.
1537      * - When `from` is zero, `tokenId` will be minted for `to`.
1538      * - When `to` is zero, `tokenId` will be burned by `from`.
1539      * - `from` and `to` are never both zero.
1540      */
1541     function _beforeTokenTransfers(
1542         address from,
1543         address to,
1544         uint256 startTokenId,
1545         uint256 quantity
1546     ) internal virtual {}
1547 
1548     /**
1549      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1550      * This includes minting.
1551      * And also called after one token has been burned.
1552      *
1553      * startTokenId - the first token id to be transferred
1554      * quantity - the amount to be transferred
1555      *
1556      * Calling conditions:
1557      *
1558      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1559      * transferred to `to`.
1560      * - When `from` is zero, `tokenId` has been minted for `to`.
1561      * - When `to` is zero, `tokenId` has been burned by `from`.
1562      * - `from` and `to` are never both zero.
1563      */
1564     function _afterTokenTransfers(
1565         address from,
1566         address to,
1567         uint256 startTokenId,
1568         uint256 quantity
1569     ) internal virtual {}
1570 
1571     /**
1572      * @dev Returns the message sender (defaults to `msg.sender`).
1573      *
1574      * If you are writing GSN compatible contracts, you need to override this function.
1575      */
1576     function _msgSenderERC721A() internal view virtual returns (address) {
1577         return msg.sender;
1578     }
1579 
1580     /**
1581      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1582      */
1583     function _toString(uint256 value) internal pure returns (string memory ptr) {
1584         assembly {
1585             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1586             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1587             // We will need 1 32-byte word to store the length,
1588             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1589             ptr := add(mload(0x40), 128)
1590             // Update the free memory pointer to allocate.
1591             mstore(0x40, ptr)
1592 
1593             // Cache the end of the memory to calculate the length later.
1594             let end := ptr
1595 
1596             // We write the string from the rightmost digit to the leftmost digit.
1597             // The following is essentially a do-while loop that also handles the zero case.
1598             // Costs a bit more than early returning for the zero case,
1599             // but cheaper in terms of deployment and overall runtime costs.
1600             for {
1601                 // Initialize and perform the first pass without check.
1602                 let temp := value
1603                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1604                 ptr := sub(ptr, 1)
1605                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1606                 mstore8(ptr, add(48, mod(temp, 10)))
1607                 temp := div(temp, 10)
1608             } temp {
1609                 // Keep dividing `temp` until zero.
1610                 temp := div(temp, 10)
1611             } {
1612                 // Body of the for loop.
1613                 ptr := sub(ptr, 1)
1614                 mstore8(ptr, add(48, mod(temp, 10)))
1615             }
1616 
1617             let length := sub(end, ptr)
1618             // Move the pointer 32 bytes leftwards to make room for the length.
1619             ptr := sub(ptr, 32)
1620             // Store the length.
1621             mstore(ptr, length)
1622         }
1623     }
1624 }
1625 
1626 // File: 5050.sol
1627 
1628 
1629 pragma solidity ^0.8.0;
1630 
1631 
1632 
1633 
1634 
1635 contract COPEAPE5050 is ERC721A, Ownable, ReentrancyGuard {
1636     // limits
1637     uint256 public maxPerTransaction = 20;
1638     uint256 public maxPerWallet = 1000;
1639     uint256 public maxTotalSupply = 6000;
1640     uint256 public chanceFreeMintsAvailable = 3000;
1641     uint256 public freeMintsAvailable = 1000;
1642 
1643     // sale states
1644     bool public isPublicLive = false;
1645 
1646     // price
1647     uint256 public mintPrice = 0.0069 ether;
1648 
1649     // whitelist config
1650     bytes32 private merkleTreeRoot;
1651 
1652     // metadata
1653     string public baseURI;
1654 
1655     // config
1656     mapping(address => uint256) public mintsPerWallet;
1657     address private withdrawAddress = address(0);
1658 
1659     constructor() ERC721A("Cope Ape", "CA") {}
1660 
1661     function mintPublic(uint256 _amount) external payable nonReentrant {
1662         require(isPublicLive, "Sale not live");
1663         require(_amount > 0, "You must mint at least one");
1664         require(totalSupply() + _amount <= maxTotalSupply, "Exceeds total supply");
1665         require(_amount <= maxPerTransaction, "Exceeds max per transaction");
1666         require(mintsPerWallet[_msgSender()] + _amount <= maxPerWallet, "Exceeds max per wallet");
1667 
1668         // 1 guaranteed free per wallet
1669         uint256 pricedAmount = freeMintsAvailable > 0 && mintsPerWallet[_msgSender()] == 0
1670             ? _amount - 1
1671             : _amount;
1672 
1673         if (pricedAmount < _amount) {
1674             freeMintsAvailable = freeMintsAvailable - 1;
1675         }
1676 
1677         require(mintPrice * pricedAmount <= msg.value, "Not enough ETH sent for selected amount");
1678 
1679         uint256 refund = chanceFreeMintsAvailable > 0 && pricedAmount > 0 && isFreeMint()
1680             ? pricedAmount * mintPrice
1681             : 0;
1682 
1683         if (refund > 0) {
1684             chanceFreeMintsAvailable = chanceFreeMintsAvailable - pricedAmount;
1685         }
1686 
1687         // sends needed ETH back to minter
1688         payable(_msgSender()).transfer(refund);
1689 
1690         mintsPerWallet[_msgSender()] = mintsPerWallet[_msgSender()] + _amount;
1691 
1692         payable(owner()).transfer(msg.value - refund);
1693         _safeMint(_msgSender(), _amount);
1694     }
1695 
1696 
1697     function flipPublicSaleState() external onlyOwner {
1698         isPublicLive = !isPublicLive;
1699     }
1700 
1701 
1702     function _baseURI() internal view virtual override returns (string memory) {
1703         return baseURI;
1704     }
1705 
1706     function isFreeMint() internal view returns (bool) {
1707         return (uint256(keccak256(abi.encodePacked(
1708             tx.origin,
1709             blockhash(block.number - 1),
1710             block.timestamp,
1711             _msgSender()
1712         ))) & 0xFFFF) % 2 == 0;
1713     }
1714 
1715     function withdraw() external onlyOwner {
1716         require(withdrawAddress != address(0), "No withdraw address");
1717         payable(withdrawAddress).transfer(address(this).balance);
1718     }
1719 
1720     function setMintPrice(uint256 _mintPrice) external onlyOwner {
1721         mintPrice = _mintPrice;
1722     }
1723 
1724     function setFreeMintsAvailable(uint256 _freeMintsAvailable) external onlyOwner {
1725         freeMintsAvailable = _freeMintsAvailable;
1726     }
1727 
1728     function setChanceFreeMintsAvailable(uint256 _chanceFreeMintsAvailable) external onlyOwner {
1729         chanceFreeMintsAvailable = _chanceFreeMintsAvailable;
1730     }
1731 
1732     function setMaxTotalSupply(uint256 _maxTotalSupply) external onlyOwner {
1733         maxTotalSupply = _maxTotalSupply;
1734     }
1735 
1736     function setMaxPerTransaction(uint256 _maxPerTransaction) external onlyOwner {
1737         maxPerTransaction = _maxPerTransaction;
1738     }
1739 
1740     function setMaxPerWallet(uint256 _maxPerWallet) external onlyOwner {
1741         maxPerWallet = _maxPerWallet;
1742     }
1743 
1744     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1745         baseURI = _newBaseURI;
1746     }
1747 
1748     function reserveBulk(address[] memory to) external onlyOwner {
1749         for (uint i = 0; i < to.length;i++) {
1750             _safeMint(to[i], 1);
1751         }
1752     }
1753 
1754     function setWithdrawAddress(address _withdrawAddress) external onlyOwner {
1755         withdrawAddress = _withdrawAddress;
1756     }
1757 
1758     function setMerkleTreeRoot(bytes32 _merkleTreeRoot) external onlyOwner {
1759         merkleTreeRoot = _merkleTreeRoot;
1760     }
1761 }