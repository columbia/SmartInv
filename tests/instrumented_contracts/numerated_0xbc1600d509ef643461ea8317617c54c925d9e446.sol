1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-11
3 */
4 
5 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
6 // SPDX-License-Identifier: MIT
7 
8 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev These functions deal with verification of Merkle Tree proofs.
14  *
15  * The proofs can be generated using the JavaScript library
16  * https://github.com/miguelmota/merkletreejs[merkletreejs].
17  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
18  *
19  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
20  *
21  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
22  * hashing, or use a hash function other than keccak256 for hashing leaves.
23  * This is because the concatenation of a sorted pair of internal nodes in
24  * the merkle tree could be reinterpreted as a leaf value.
25  */
26 library MerkleProof {
27     /**
28      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
29      * defined by `root`. For this, a `proof` must be provided, containing
30      * sibling hashes on the branch from the leaf to the root of the tree. Each
31      * pair of leaves and each pair of pre-images are assumed to be sorted.
32      */
33     function verify(
34         bytes32[] memory proof,
35         bytes32 root,
36         bytes32 leaf
37     ) internal pure returns (bool) {
38         return processProof(proof, leaf) == root;
39     }
40 
41     /**
42      * @dev Calldata version of {verify}
43      *
44      * _Available since v4.7._
45      */
46     function verifyCalldata(
47         bytes32[] calldata proof,
48         bytes32 root,
49         bytes32 leaf
50     ) internal pure returns (bool) {
51         return processProofCalldata(proof, leaf) == root;
52     }
53 
54     /**
55      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
56      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
57      * hash matches the root of the tree. When processing the proof, the pairs
58      * of leafs & pre-images are assumed to be sorted.
59      *
60      * _Available since v4.4._
61      */
62     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
63         bytes32 computedHash = leaf;
64         for (uint256 i = 0; i < proof.length; i++) {
65             computedHash = _hashPair(computedHash, proof[i]);
66         }
67         return computedHash;
68     }
69 
70     /**
71      * @dev Calldata version of {processProof}
72      *
73      * _Available since v4.7._
74      */
75     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
76         bytes32 computedHash = leaf;
77         for (uint256 i = 0; i < proof.length; i++) {
78             computedHash = _hashPair(computedHash, proof[i]);
79         }
80         return computedHash;
81     }
82 
83     /**
84      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
85      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
86      *
87      * _Available since v4.7._
88      */
89     function multiProofVerify(
90         bytes32[] memory proof,
91         bool[] memory proofFlags,
92         bytes32 root,
93         bytes32[] memory leaves
94     ) internal pure returns (bool) {
95         return processMultiProof(proof, proofFlags, leaves) == root;
96     }
97 
98     /**
99      * @dev Calldata version of {multiProofVerify}
100      *
101      * _Available since v4.7._
102      */
103     function multiProofVerifyCalldata(
104         bytes32[] calldata proof,
105         bool[] calldata proofFlags,
106         bytes32 root,
107         bytes32[] memory leaves
108     ) internal pure returns (bool) {
109         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
110     }
111 
112     /**
113      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
114      * consuming from one or the other at each step according to the instructions given by
115      * `proofFlags`.
116      *
117      * _Available since v4.7._
118      */
119     function processMultiProof(
120         bytes32[] memory proof,
121         bool[] memory proofFlags,
122         bytes32[] memory leaves
123     ) internal pure returns (bytes32 merkleRoot) {
124         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
125         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
126         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
127         // the merkle tree.
128         uint256 leavesLen = leaves.length;
129         uint256 totalHashes = proofFlags.length;
130 
131         // Check proof validity.
132         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
133 
134         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
135         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
136         bytes32[] memory hashes = new bytes32[](totalHashes);
137         uint256 leafPos = 0;
138         uint256 hashPos = 0;
139         uint256 proofPos = 0;
140         // At each step, we compute the next hash using two values:
141         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
142         //   get the next hash.
143         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
144         //   `proof` array.
145         for (uint256 i = 0; i < totalHashes; i++) {
146             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
147             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
148             hashes[i] = _hashPair(a, b);
149         }
150 
151         if (totalHashes > 0) {
152             return hashes[totalHashes - 1];
153         } else if (leavesLen > 0) {
154             return leaves[0];
155         } else {
156             return proof[0];
157         }
158     }
159 
160     /**
161      * @dev Calldata version of {processMultiProof}
162      *
163      * _Available since v4.7._
164      */
165     function processMultiProofCalldata(
166         bytes32[] calldata proof,
167         bool[] calldata proofFlags,
168         bytes32[] memory leaves
169     ) internal pure returns (bytes32 merkleRoot) {
170         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
171         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
172         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
173         // the merkle tree.
174         uint256 leavesLen = leaves.length;
175         uint256 totalHashes = proofFlags.length;
176 
177         // Check proof validity.
178         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
179 
180         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
181         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
182         bytes32[] memory hashes = new bytes32[](totalHashes);
183         uint256 leafPos = 0;
184         uint256 hashPos = 0;
185         uint256 proofPos = 0;
186         // At each step, we compute the next hash using two values:
187         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
188         //   get the next hash.
189         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
190         //   `proof` array.
191         for (uint256 i = 0; i < totalHashes; i++) {
192             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
193             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
194             hashes[i] = _hashPair(a, b);
195         }
196 
197         if (totalHashes > 0) {
198             return hashes[totalHashes - 1];
199         } else if (leavesLen > 0) {
200             return leaves[0];
201         } else {
202             return proof[0];
203         }
204     }
205 
206     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
207         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
208     }
209 
210     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
211         /// @solidity memory-safe-assembly
212         assembly {
213             mstore(0x00, a)
214             mstore(0x20, b)
215             value := keccak256(0x00, 0x40)
216         }
217     }
218 }
219 
220 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
221 
222 
223 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @dev Contract module that helps prevent reentrant calls to a function.
229  *
230  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
231  * available, which can be applied to functions to make sure there are no nested
232  * (reentrant) calls to them.
233  *
234  * Note that because there is a single `nonReentrant` guard, functions marked as
235  * `nonReentrant` may not call one another. This can be worked around by making
236  * those functions `private`, and then adding `external` `nonReentrant` entry
237  * points to them.
238  *
239  * TIP: If you would like to learn more about reentrancy and alternative ways
240  * to protect against it, check out our blog post
241  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
242  */
243 abstract contract ReentrancyGuard {
244     // Booleans are more expensive than uint256 or any type that takes up a full
245     // word because each write operation emits an extra SLOAD to first read the
246     // slot's contents, replace the bits taken up by the boolean, and then write
247     // back. This is the compiler's defense against contract upgrades and
248     // pointer aliasing, and it cannot be disabled.
249 
250     // The values being non-zero value makes deployment a bit more expensive,
251     // but in exchange the refund on every call to nonReentrant will be lower in
252     // amount. Since refunds are capped to a percentage of the total
253     // transaction's gas, it is best to keep them low in cases like this one, to
254     // increase the likelihood of the full refund coming into effect.
255     uint256 private constant _NOT_ENTERED = 1;
256     uint256 private constant _ENTERED = 2;
257 
258     uint256 private _status;
259 
260     constructor() {
261         _status = _NOT_ENTERED;
262     }
263 
264     /**
265      * @dev Prevents a contract from calling itself, directly or indirectly.
266      * Calling a `nonReentrant` function from another `nonReentrant`
267      * function is not supported. It is possible to prevent this from happening
268      * by making the `nonReentrant` function external, and making it call a
269      * `private` function that does the actual work.
270      */
271     modifier nonReentrant() {
272         // On the first call to nonReentrant, _notEntered will be true
273         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
274 
275         // Any calls to nonReentrant after this point will fail
276         _status = _ENTERED;
277 
278         _;
279 
280         // By storing the original value once again, a refund is triggered (see
281         // https://eips.ethereum.org/EIPS/eip-2200)
282         _status = _NOT_ENTERED;
283     }
284 }
285 
286 // File: @openzeppelin/contracts/utils/Context.sol
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev Provides information about the current execution context, including the
295  * sender of the transaction and its data. While these are generally available
296  * via msg.sender and msg.data, they should not be accessed in such a direct
297  * manner, since when dealing with meta-transactions the account sending and
298  * paying for execution may not be the actual sender (as far as an application
299  * is concerned).
300  *
301  * This contract is only required for intermediate, library-like contracts.
302  */
303 abstract contract Context {
304     function _msgSender() internal view virtual returns (address) {
305         return msg.sender;
306     }
307 
308     function _msgData() internal view virtual returns (bytes calldata) {
309         return msg.data;
310     }
311 }
312 
313 // File: @openzeppelin/contracts/access/Ownable.sol
314 
315 
316 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
317 
318 pragma solidity ^0.8.0;
319 
320 
321 /**
322  * @dev Contract module which provides a basic access control mechanism, where
323  * there is an account (an owner) that can be granted exclusive access to
324  * specific functions.
325  *
326  * By default, the owner account will be the one that deploys the contract. This
327  * can later be changed with {transferOwnership}.
328  *
329  * This module is used through inheritance. It will make available the modifier
330  * `onlyOwner`, which can be applied to your functions to restrict their use to
331  * the owner.
332  */
333 abstract contract Ownable is Context {
334     address private _owner;
335 
336     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
337 
338     /**
339      * @dev Initializes the contract setting the deployer as the initial owner.
340      */
341     constructor() {
342         _transferOwnership(_msgSender());
343     }
344 
345     /**
346      * @dev Throws if called by any account other than the owner.
347      */
348     modifier onlyOwner() {
349         _checkOwner();
350         _;
351     }
352 
353     /**
354      * @dev Returns the address of the current owner.
355      */
356     function owner() public view virtual returns (address) {
357         return _owner;
358     }
359 
360     /**
361      * @dev Throws if the sender is not the owner.
362      */
363     function _checkOwner() internal view virtual {
364         require(owner() == _msgSender(), "Ownable: caller is not the owner");
365     }
366 
367     /**
368      * @dev Leaves the contract without owner. It will not be possible to call
369      * `onlyOwner` functions anymore. Can only be called by the current owner.
370      *
371      * NOTE: Renouncing ownership will leave the contract without an owner,
372      * thereby removing any functionality that is only available to the owner.
373      */
374     function renounceOwnership() public virtual onlyOwner {
375         _transferOwnership(address(0));
376     }
377 
378     /**
379      * @dev Transfers ownership of the contract to a new account (`newOwner`).
380      * Can only be called by the current owner.
381      */
382     function transferOwnership(address newOwner) public virtual onlyOwner {
383         require(newOwner != address(0), "Ownable: new owner is the zero address");
384         _transferOwnership(newOwner);
385     }
386 
387     /**
388      * @dev Transfers ownership of the contract to a new account (`newOwner`).
389      * Internal function without access restriction.
390      */
391     function _transferOwnership(address newOwner) internal virtual {
392         address oldOwner = _owner;
393         _owner = newOwner;
394         emit OwnershipTransferred(oldOwner, newOwner);
395     }
396 }
397 
398 // File: erc721a/contracts/IERC721A.sol
399 
400 
401 // ERC721A Contracts v4.1.0
402 // Creator: Chiru Labs
403 
404 pragma solidity ^0.8.4;
405 
406 /**
407  * @dev Interface of an ERC721A compliant contract.
408  */
409 interface IERC721A {
410     /**
411      * The caller must own the token or be an approved operator.
412      */
413     error ApprovalCallerNotOwnerNorApproved();
414 
415     /**
416      * The token does not exist.
417      */
418     error ApprovalQueryForNonexistentToken();
419 
420     /**
421      * The caller cannot approve to their own address.
422      */
423     error ApproveToCaller();
424 
425     /**
426      * Cannot query the balance for the zero address.
427      */
428     error BalanceQueryForZeroAddress();
429 
430     /**
431      * Cannot mint to the zero address.
432      */
433     error MintToZeroAddress();
434 
435     /**
436      * The quantity of tokens minted must be more than zero.
437      */
438     error MintZeroQuantity();
439 
440     /**
441      * The token does not exist.
442      */
443     error OwnerQueryForNonexistentToken();
444 
445     /**
446      * The caller must own the token or be an approved operator.
447      */
448     error TransferCallerNotOwnerNorApproved();
449 
450     /**
451      * The token must be owned by `from`.
452      */
453     error TransferFromIncorrectOwner();
454 
455     /**
456      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
457      */
458     error TransferToNonERC721ReceiverImplementer();
459 
460     /**
461      * Cannot transfer to the zero address.
462      */
463     error TransferToZeroAddress();
464 
465     /**
466      * The token does not exist.
467      */
468     error URIQueryForNonexistentToken();
469 
470     /**
471      * The `quantity` minted with ERC2309 exceeds the safety limit.
472      */
473     error MintERC2309QuantityExceedsLimit();
474 
475     /**
476      * The `extraData` cannot be set on an unintialized ownership slot.
477      */
478     error OwnershipNotInitializedForExtraData();
479 
480     struct TokenOwnership {
481         // The address of the owner.
482         address addr;
483         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
484         uint64 startTimestamp;
485         // Whether the token has been burned.
486         bool burned;
487         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
488         uint24 extraData;
489     }
490 
491     /**
492      * @dev Returns the total amount of tokens stored by the contract.
493      *
494      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
495      */
496     function totalSupply() external view returns (uint256);
497 
498     // ==============================
499     //            IERC165
500     // ==============================
501 
502     /**
503      * @dev Returns true if this contract implements the interface defined by
504      * `interfaceId`. See the corresponding
505      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
506      * to learn more about how these ids are created.
507      *
508      * This function call must use less than 30 000 gas.
509      */
510     function supportsInterface(bytes4 interfaceId) external view returns (bool);
511 
512     // ==============================
513     //            IERC721
514     // ==============================
515 
516     /**
517      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
518      */
519     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
520 
521     /**
522      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
523      */
524     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
525 
526     /**
527      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
528      */
529     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
530 
531     /**
532      * @dev Returns the number of tokens in ``owner``'s account.
533      */
534     function balanceOf(address owner) external view returns (uint256 balance);
535 
536     /**
537      * @dev Returns the owner of the `tokenId` token.
538      *
539      * Requirements:
540      *
541      * - `tokenId` must exist.
542      */
543     function ownerOf(uint256 tokenId) external view returns (address owner);
544 
545     /**
546      * @dev Safely transfers `tokenId` token from `from` to `to`.
547      *
548      * Requirements:
549      *
550      * - `from` cannot be the zero address.
551      * - `to` cannot be the zero address.
552      * - `tokenId` token must exist and be owned by `from`.
553      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
554      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
555      *
556      * Emits a {Transfer} event.
557      */
558     function safeTransferFrom(
559         address from,
560         address to,
561         uint256 tokenId,
562         bytes calldata data
563     ) external;
564 
565     /**
566      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
567      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
568      *
569      * Requirements:
570      *
571      * - `from` cannot be the zero address.
572      * - `to` cannot be the zero address.
573      * - `tokenId` token must exist and be owned by `from`.
574      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
575      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
576      *
577      * Emits a {Transfer} event.
578      */
579     function safeTransferFrom(
580         address from,
581         address to,
582         uint256 tokenId
583     ) external;
584 
585     /**
586      * @dev Transfers `tokenId` token from `from` to `to`.
587      *
588      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
589      *
590      * Requirements:
591      *
592      * - `from` cannot be the zero address.
593      * - `to` cannot be the zero address.
594      * - `tokenId` token must be owned by `from`.
595      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
596      *
597      * Emits a {Transfer} event.
598      */
599     function transferFrom(
600         address from,
601         address to,
602         uint256 tokenId
603     ) external;
604 
605     /**
606      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
607      * The approval is cleared when the token is transferred.
608      *
609      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
610      *
611      * Requirements:
612      *
613      * - The caller must own the token or be an approved operator.
614      * - `tokenId` must exist.
615      *
616      * Emits an {Approval} event.
617      */
618     function approve(address to, uint256 tokenId) external;
619 
620     /**
621      * @dev Approve or remove `operator` as an operator for the caller.
622      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
623      *
624      * Requirements:
625      *
626      * - The `operator` cannot be the caller.
627      *
628      * Emits an {ApprovalForAll} event.
629      */
630     function setApprovalForAll(address operator, bool _approved) external;
631 
632     /**
633      * @dev Returns the account approved for `tokenId` token.
634      *
635      * Requirements:
636      *
637      * - `tokenId` must exist.
638      */
639     function getApproved(uint256 tokenId) external view returns (address operator);
640 
641     /**
642      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
643      *
644      * See {setApprovalForAll}
645      */
646     function isApprovedForAll(address owner, address operator) external view returns (bool);
647 
648     // ==============================
649     //        IERC721Metadata
650     // ==============================
651 
652     /**
653      * @dev Returns the token collection name.
654      */
655     function name() external view returns (string memory);
656 
657     /**
658      * @dev Returns the token collection symbol.
659      */
660     function symbol() external view returns (string memory);
661 
662     /**
663      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
664      */
665     function tokenURI(uint256 tokenId) external view returns (string memory);
666 
667     // ==============================
668     //            IERC2309
669     // ==============================
670 
671     /**
672      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
673      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
674      */
675     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
676 }
677 
678 // File: erc721a/contracts/ERC721A.sol
679 
680 
681 // ERC721A Contracts v4.1.0
682 // Creator: Chiru Labs
683 
684 pragma solidity ^0.8.4;
685 
686 
687 /**
688  * @dev ERC721 token receiver interface.
689  */
690 interface ERC721A__IERC721Receiver {
691     function onERC721Received(
692         address operator,
693         address from,
694         uint256 tokenId,
695         bytes calldata data
696     ) external returns (bytes4);
697 }
698 
699 /**
700  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
701  * including the Metadata extension. Built to optimize for lower gas during batch mints.
702  *
703  * Assumes serials are sequentially minted starting at `_startTokenId()`
704  * (defaults to 0, e.g. 0, 1, 2, 3..).
705  *
706  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
707  *
708  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
709  */
710 contract ERC721A is IERC721A {
711     // Mask of an entry in packed address data.
712     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
713 
714     // The bit position of `numberMinted` in packed address data.
715     uint256 private constant BITPOS_NUMBER_MINTED = 64;
716 
717     // The bit position of `numberBurned` in packed address data.
718     uint256 private constant BITPOS_NUMBER_BURNED = 128;
719 
720     // The bit position of `aux` in packed address data.
721     uint256 private constant BITPOS_AUX = 192;
722 
723     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
724     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
725 
726     // The bit position of `startTimestamp` in packed ownership.
727     uint256 private constant BITPOS_START_TIMESTAMP = 160;
728 
729     // The bit mask of the `burned` bit in packed ownership.
730     uint256 private constant BITMASK_BURNED = 1 << 224;
731 
732     // The bit position of the `nextInitialized` bit in packed ownership.
733     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
734 
735     // The bit mask of the `nextInitialized` bit in packed ownership.
736     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
737 
738     // The bit position of `extraData` in packed ownership.
739     uint256 private constant BITPOS_EXTRA_DATA = 232;
740 
741     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
742     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
743 
744     // The mask of the lower 160 bits for addresses.
745     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
746 
747     // The maximum `quantity` that can be minted with `_mintERC2309`.
748     // This limit is to prevent overflows on the address data entries.
749     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
750     // is required to cause an overflow, which is unrealistic.
751     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
752 
753     // The tokenId of the next token to be minted.
754     uint256 private _currentIndex;
755 
756     // The number of tokens burned.
757     uint256 private _burnCounter;
758 
759     // Token name
760     string private _name;
761 
762     // Token symbol
763     string private _symbol;
764 
765     // Mapping from token ID to ownership details
766     // An empty struct value does not necessarily mean the token is unowned.
767     // See `_packedOwnershipOf` implementation for details.
768     //
769     // Bits Layout:
770     // - [0..159]   `addr`
771     // - [160..223] `startTimestamp`
772     // - [224]      `burned`
773     // - [225]      `nextInitialized`
774     // - [232..255] `extraData`
775     mapping(uint256 => uint256) private _packedOwnerships;
776 
777     // Mapping owner address to address data.
778     //
779     // Bits Layout:
780     // - [0..63]    `balance`
781     // - [64..127]  `numberMinted`
782     // - [128..191] `numberBurned`
783     // - [192..255] `aux`
784     mapping(address => uint256) private _packedAddressData;
785 
786     // Mapping from token ID to approved address.
787     mapping(uint256 => address) private _tokenApprovals;
788 
789     // Mapping from owner to operator approvals
790     mapping(address => mapping(address => bool)) private _operatorApprovals;
791 
792     constructor(string memory name_, string memory symbol_) {
793         _name = name_;
794         _symbol = symbol_;
795         _currentIndex = _startTokenId();
796     }
797 
798     /**
799      * @dev Returns the starting token ID.
800      * To change the starting token ID, please override this function.
801      */
802     function _startTokenId() internal view virtual returns (uint256) {
803         return 0;
804     }
805 
806     /**
807      * @dev Returns the next token ID to be minted.
808      */
809     function _nextTokenId() internal view returns (uint256) {
810         return _currentIndex;
811     }
812 
813     /**
814      * @dev Returns the total number of tokens in existence.
815      * Burned tokens will reduce the count.
816      * To get the total number of tokens minted, please see `_totalMinted`.
817      */
818     function totalSupply() public view override returns (uint256) {
819         // Counter underflow is impossible as _burnCounter cannot be incremented
820         // more than `_currentIndex - _startTokenId()` times.
821         unchecked {
822             return _currentIndex - _burnCounter - _startTokenId();
823         }
824     }
825 
826     /**
827      * @dev Returns the total amount of tokens minted in the contract.
828      */
829     function _totalMinted() internal view returns (uint256) {
830         // Counter underflow is impossible as _currentIndex does not decrement,
831         // and it is initialized to `_startTokenId()`
832         unchecked {
833             return _currentIndex - _startTokenId();
834         }
835     }
836 
837     /**
838      * @dev Returns the total number of tokens burned.
839      */
840     function _totalBurned() internal view returns (uint256) {
841         return _burnCounter;
842     }
843 
844     /**
845      * @dev See {IERC165-supportsInterface}.
846      */
847     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
848         // The interface IDs are constants representing the first 4 bytes of the XOR of
849         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
850         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
851         return
852             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
853             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
854             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
855     }
856 
857     /**
858      * @dev See {IERC721-balanceOf}.
859      */
860     function balanceOf(address owner) public view override returns (uint256) {
861         if (owner == address(0)) revert BalanceQueryForZeroAddress();
862         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
863     }
864 
865     /**
866      * Returns the number of tokens minted by `owner`.
867      */
868     function _numberMinted(address owner) internal view returns (uint256) {
869         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
870     }
871 
872     /**
873      * Returns the number of tokens burned by or on behalf of `owner`.
874      */
875     function _numberBurned(address owner) internal view returns (uint256) {
876         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
877     }
878 
879     /**
880      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
881      */
882     function _getAux(address owner) internal view returns (uint64) {
883         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
884     }
885 
886     /**
887      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
888      * If there are multiple variables, please pack them into a uint64.
889      */
890     function _setAux(address owner, uint64 aux) internal {
891         uint256 packed = _packedAddressData[owner];
892         uint256 auxCasted;
893         // Cast `aux` with assembly to avoid redundant masking.
894         assembly {
895             auxCasted := aux
896         }
897         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
898         _packedAddressData[owner] = packed;
899     }
900 
901     /**
902      * Returns the packed ownership data of `tokenId`.
903      */
904     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
905         uint256 curr = tokenId;
906 
907         unchecked {
908             if (_startTokenId() <= curr)
909                 if (curr < _currentIndex) {
910                     uint256 packed = _packedOwnerships[curr];
911                     // If not burned.
912                     if (packed & BITMASK_BURNED == 0) {
913                         // Invariant:
914                         // There will always be an ownership that has an address and is not burned
915                         // before an ownership that does not have an address and is not burned.
916                         // Hence, curr will not underflow.
917                         //
918                         // We can directly compare the packed value.
919                         // If the address is zero, packed is zero.
920                         while (packed == 0) {
921                             packed = _packedOwnerships[--curr];
922                         }
923                         return packed;
924                     }
925                 }
926         }
927         revert OwnerQueryForNonexistentToken();
928     }
929 
930     /**
931      * Returns the unpacked `TokenOwnership` struct from `packed`.
932      */
933     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
934         ownership.addr = address(uint160(packed));
935         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
936         ownership.burned = packed & BITMASK_BURNED != 0;
937         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
938     }
939 
940     /**
941      * Returns the unpacked `TokenOwnership` struct at `index`.
942      */
943     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
944         return _unpackedOwnership(_packedOwnerships[index]);
945     }
946 
947     /**
948      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
949      */
950     function _initializeOwnershipAt(uint256 index) internal {
951         if (_packedOwnerships[index] == 0) {
952             _packedOwnerships[index] = _packedOwnershipOf(index);
953         }
954     }
955 
956     /**
957      * Gas spent here starts off proportional to the maximum mint batch size.
958      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
959      */
960     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
961         return _unpackedOwnership(_packedOwnershipOf(tokenId));
962     }
963 
964     /**
965      * @dev Packs ownership data into a single uint256.
966      */
967     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
968         assembly {
969             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
970             owner := and(owner, BITMASK_ADDRESS)
971             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
972             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
973         }
974     }
975 
976     /**
977      * @dev See {IERC721-ownerOf}.
978      */
979     function ownerOf(uint256 tokenId) public view override returns (address) {
980         return address(uint160(_packedOwnershipOf(tokenId)));
981     }
982 
983     /**
984      * @dev See {IERC721Metadata-name}.
985      */
986     function name() public view virtual override returns (string memory) {
987         return _name;
988     }
989 
990     /**
991      * @dev See {IERC721Metadata-symbol}.
992      */
993     function symbol() public view virtual override returns (string memory) {
994         return _symbol;
995     }
996 
997     /**
998      * @dev See {IERC721Metadata-tokenURI}.
999      */
1000     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1001         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1002 
1003         string memory baseURI = _baseURI();
1004         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1005     }
1006 
1007     /**
1008      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1009      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1010      * by default, it can be overridden in child contracts.
1011      */
1012     function _baseURI() internal view virtual returns (string memory) {
1013         return '';
1014     }
1015 
1016     /**
1017      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1018      */
1019     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1020         // For branchless setting of the `nextInitialized` flag.
1021         assembly {
1022             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1023             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1024         }
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-approve}.
1029      */
1030     function approve(address to, uint256 tokenId) public override {
1031         address owner = ownerOf(tokenId);
1032 
1033         if (_msgSenderERC721A() != owner)
1034             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1035                 revert ApprovalCallerNotOwnerNorApproved();
1036             }
1037 
1038         _tokenApprovals[tokenId] = to;
1039         emit Approval(owner, to, tokenId);
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-getApproved}.
1044      */
1045     function getApproved(uint256 tokenId) public view override returns (address) {
1046         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1047 
1048         return _tokenApprovals[tokenId];
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-setApprovalForAll}.
1053      */
1054     function setApprovalForAll(address operator, bool approved) public virtual override {
1055         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1056 
1057         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1058         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1059     }
1060 
1061     /**
1062      * @dev See {IERC721-isApprovedForAll}.
1063      */
1064     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1065         return _operatorApprovals[owner][operator];
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-safeTransferFrom}.
1070      */
1071     function safeTransferFrom(
1072         address from,
1073         address to,
1074         uint256 tokenId
1075     ) public virtual override {
1076         safeTransferFrom(from, to, tokenId, '');
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-safeTransferFrom}.
1081      */
1082     function safeTransferFrom(
1083         address from,
1084         address to,
1085         uint256 tokenId,
1086         bytes memory _data
1087     ) public virtual override {
1088         transferFrom(from, to, tokenId);
1089         if (to.code.length != 0)
1090             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1091                 revert TransferToNonERC721ReceiverImplementer();
1092             }
1093     }
1094 
1095     /**
1096      * @dev Returns whether `tokenId` exists.
1097      *
1098      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1099      *
1100      * Tokens start existing when they are minted (`_mint`),
1101      */
1102     function _exists(uint256 tokenId) internal view returns (bool) {
1103         return
1104             _startTokenId() <= tokenId &&
1105             tokenId < _currentIndex && // If within bounds,
1106             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1107     }
1108 
1109     /**
1110      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1111      */
1112     function _safeMint(address to, uint256 quantity) internal {
1113         _safeMint(to, quantity, '');
1114     }
1115 
1116     /**
1117      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1118      *
1119      * Requirements:
1120      *
1121      * - If `to` refers to a smart contract, it must implement
1122      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1123      * - `quantity` must be greater than 0.
1124      *
1125      * See {_mint}.
1126      *
1127      * Emits a {Transfer} event for each mint.
1128      */
1129     function _safeMint(
1130         address to,
1131         uint256 quantity,
1132         bytes memory _data
1133     ) internal {
1134         _mint(to, quantity);
1135 
1136         unchecked {
1137             if (to.code.length != 0) {
1138                 uint256 end = _currentIndex;
1139                 uint256 index = end - quantity;
1140                 do {
1141                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1142                         revert TransferToNonERC721ReceiverImplementer();
1143                     }
1144                 } while (index < end);
1145                 // Reentrancy protection.
1146                 if (_currentIndex != end) revert();
1147             }
1148         }
1149     }
1150 
1151     /**
1152      * @dev Mints `quantity` tokens and transfers them to `to`.
1153      *
1154      * Requirements:
1155      *
1156      * - `to` cannot be the zero address.
1157      * - `quantity` must be greater than 0.
1158      *
1159      * Emits a {Transfer} event for each mint.
1160      */
1161     function _mint(address to, uint256 quantity) internal {
1162         uint256 startTokenId = _currentIndex;
1163         if (to == address(0)) revert MintToZeroAddress();
1164         if (quantity == 0) revert MintZeroQuantity();
1165 
1166         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1167 
1168         // Overflows are incredibly unrealistic.
1169         // `balance` and `numberMinted` have a maximum limit of 2**64.
1170         // `tokenId` has a maximum limit of 2**256.
1171         unchecked {
1172             // Updates:
1173             // - `balance += quantity`.
1174             // - `numberMinted += quantity`.
1175             //
1176             // We can directly add to the `balance` and `numberMinted`.
1177             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1178 
1179             // Updates:
1180             // - `address` to the owner.
1181             // - `startTimestamp` to the timestamp of minting.
1182             // - `burned` to `false`.
1183             // - `nextInitialized` to `quantity == 1`.
1184             _packedOwnerships[startTokenId] = _packOwnershipData(
1185                 to,
1186                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1187             );
1188 
1189             uint256 tokenId = startTokenId;
1190             uint256 end = startTokenId + quantity;
1191             do {
1192                 emit Transfer(address(0), to, tokenId++);
1193             } while (tokenId < end);
1194 
1195             _currentIndex = end;
1196         }
1197         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1198     }
1199 
1200     /**
1201      * @dev Mints `quantity` tokens and transfers them to `to`.
1202      *
1203      * This function is intended for efficient minting only during contract creation.
1204      *
1205      * It emits only one {ConsecutiveTransfer} as defined in
1206      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1207      * instead of a sequence of {Transfer} event(s).
1208      *
1209      * Calling this function outside of contract creation WILL make your contract
1210      * non-compliant with the ERC721 standard.
1211      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1212      * {ConsecutiveTransfer} event is only permissible during contract creation.
1213      *
1214      * Requirements:
1215      *
1216      * - `to` cannot be the zero address.
1217      * - `quantity` must be greater than 0.
1218      *
1219      * Emits a {ConsecutiveTransfer} event.
1220      */
1221     function _mintERC2309(address to, uint256 quantity) internal {
1222         uint256 startTokenId = _currentIndex;
1223         if (to == address(0)) revert MintToZeroAddress();
1224         if (quantity == 0) revert MintZeroQuantity();
1225         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1226 
1227         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1228 
1229         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1230         unchecked {
1231             // Updates:
1232             // - `balance += quantity`.
1233             // - `numberMinted += quantity`.
1234             //
1235             // We can directly add to the `balance` and `numberMinted`.
1236             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1237 
1238             // Updates:
1239             // - `address` to the owner.
1240             // - `startTimestamp` to the timestamp of minting.
1241             // - `burned` to `false`.
1242             // - `nextInitialized` to `quantity == 1`.
1243             _packedOwnerships[startTokenId] = _packOwnershipData(
1244                 to,
1245                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1246             );
1247 
1248             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1249 
1250             _currentIndex = startTokenId + quantity;
1251         }
1252         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1253     }
1254 
1255     /**
1256      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1257      */
1258     function _getApprovedAddress(uint256 tokenId)
1259         private
1260         view
1261         returns (uint256 approvedAddressSlot, address approvedAddress)
1262     {
1263         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1264         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1265         assembly {
1266             // Compute the slot.
1267             mstore(0x00, tokenId)
1268             mstore(0x20, tokenApprovalsPtr.slot)
1269             approvedAddressSlot := keccak256(0x00, 0x40)
1270             // Load the slot's value from storage.
1271             approvedAddress := sload(approvedAddressSlot)
1272         }
1273     }
1274 
1275     /**
1276      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1277      */
1278     function _isOwnerOrApproved(
1279         address approvedAddress,
1280         address from,
1281         address msgSender
1282     ) private pure returns (bool result) {
1283         assembly {
1284             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1285             from := and(from, BITMASK_ADDRESS)
1286             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1287             msgSender := and(msgSender, BITMASK_ADDRESS)
1288             // `msgSender == from || msgSender == approvedAddress`.
1289             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1290         }
1291     }
1292 
1293     /**
1294      * @dev Transfers `tokenId` from `from` to `to`.
1295      *
1296      * Requirements:
1297      *
1298      * - `to` cannot be the zero address.
1299      * - `tokenId` token must be owned by `from`.
1300      *
1301      * Emits a {Transfer} event.
1302      */
1303     function transferFrom(
1304         address from,
1305         address to,
1306         uint256 tokenId
1307     ) public virtual override {
1308         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1309 
1310         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1311 
1312         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1313 
1314         // The nested ifs save around 20+ gas over a compound boolean condition.
1315         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1316             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1317 
1318         if (to == address(0)) revert TransferToZeroAddress();
1319 
1320         _beforeTokenTransfers(from, to, tokenId, 1);
1321 
1322         // Clear approvals from the previous owner.
1323         assembly {
1324             if approvedAddress {
1325                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1326                 sstore(approvedAddressSlot, 0)
1327             }
1328         }
1329 
1330         // Underflow of the sender's balance is impossible because we check for
1331         // ownership above and the recipient's balance can't realistically overflow.
1332         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1333         unchecked {
1334             // We can directly increment and decrement the balances.
1335             --_packedAddressData[from]; // Updates: `balance -= 1`.
1336             ++_packedAddressData[to]; // Updates: `balance += 1`.
1337 
1338             // Updates:
1339             // - `address` to the next owner.
1340             // - `startTimestamp` to the timestamp of transfering.
1341             // - `burned` to `false`.
1342             // - `nextInitialized` to `true`.
1343             _packedOwnerships[tokenId] = _packOwnershipData(
1344                 to,
1345                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1346             );
1347 
1348             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1349             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1350                 uint256 nextTokenId = tokenId + 1;
1351                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1352                 if (_packedOwnerships[nextTokenId] == 0) {
1353                     // If the next slot is within bounds.
1354                     if (nextTokenId != _currentIndex) {
1355                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1356                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1357                     }
1358                 }
1359             }
1360         }
1361 
1362         emit Transfer(from, to, tokenId);
1363         _afterTokenTransfers(from, to, tokenId, 1);
1364     }
1365 
1366     /**
1367      * @dev Equivalent to `_burn(tokenId, false)`.
1368      */
1369     function _burn(uint256 tokenId) internal virtual {
1370         _burn(tokenId, false);
1371     }
1372 
1373     /**
1374      * @dev Destroys `tokenId`.
1375      * The approval is cleared when the token is burned.
1376      *
1377      * Requirements:
1378      *
1379      * - `tokenId` must exist.
1380      *
1381      * Emits a {Transfer} event.
1382      */
1383     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1384         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1385 
1386         address from = address(uint160(prevOwnershipPacked));
1387 
1388         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1389 
1390         if (approvalCheck) {
1391             // The nested ifs save around 20+ gas over a compound boolean condition.
1392             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1393                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1394         }
1395 
1396         _beforeTokenTransfers(from, address(0), tokenId, 1);
1397 
1398         // Clear approvals from the previous owner.
1399         assembly {
1400             if approvedAddress {
1401                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1402                 sstore(approvedAddressSlot, 0)
1403             }
1404         }
1405 
1406         // Underflow of the sender's balance is impossible because we check for
1407         // ownership above and the recipient's balance can't realistically overflow.
1408         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1409         unchecked {
1410             // Updates:
1411             // - `balance -= 1`.
1412             // - `numberBurned += 1`.
1413             //
1414             // We can directly decrement the balance, and increment the number burned.
1415             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1416             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1417 
1418             // Updates:
1419             // - `address` to the last owner.
1420             // - `startTimestamp` to the timestamp of burning.
1421             // - `burned` to `true`.
1422             // - `nextInitialized` to `true`.
1423             _packedOwnerships[tokenId] = _packOwnershipData(
1424                 from,
1425                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1426             );
1427 
1428             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1429             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1430                 uint256 nextTokenId = tokenId + 1;
1431                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1432                 if (_packedOwnerships[nextTokenId] == 0) {
1433                     // If the next slot is within bounds.
1434                     if (nextTokenId != _currentIndex) {
1435                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1436                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1437                     }
1438                 }
1439             }
1440         }
1441 
1442         emit Transfer(from, address(0), tokenId);
1443         _afterTokenTransfers(from, address(0), tokenId, 1);
1444 
1445         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1446         unchecked {
1447             _burnCounter++;
1448         }
1449     }
1450 
1451     /**
1452      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1453      *
1454      * @param from address representing the previous owner of the given token ID
1455      * @param to target address that will receive the tokens
1456      * @param tokenId uint256 ID of the token to be transferred
1457      * @param _data bytes optional data to send along with the call
1458      * @return bool whether the call correctly returned the expected magic value
1459      */
1460     function _checkContractOnERC721Received(
1461         address from,
1462         address to,
1463         uint256 tokenId,
1464         bytes memory _data
1465     ) private returns (bool) {
1466         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1467             bytes4 retval
1468         ) {
1469             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1470         } catch (bytes memory reason) {
1471             if (reason.length == 0) {
1472                 revert TransferToNonERC721ReceiverImplementer();
1473             } else {
1474                 assembly {
1475                     revert(add(32, reason), mload(reason))
1476                 }
1477             }
1478         }
1479     }
1480 
1481     /**
1482      * @dev Directly sets the extra data for the ownership data `index`.
1483      */
1484     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1485         uint256 packed = _packedOwnerships[index];
1486         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1487         uint256 extraDataCasted;
1488         // Cast `extraData` with assembly to avoid redundant masking.
1489         assembly {
1490             extraDataCasted := extraData
1491         }
1492         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1493         _packedOwnerships[index] = packed;
1494     }
1495 
1496     /**
1497      * @dev Returns the next extra data for the packed ownership data.
1498      * The returned result is shifted into position.
1499      */
1500     function _nextExtraData(
1501         address from,
1502         address to,
1503         uint256 prevOwnershipPacked
1504     ) private view returns (uint256) {
1505         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1506         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1507     }
1508 
1509     /**
1510      * @dev Called during each token transfer to set the 24bit `extraData` field.
1511      * Intended to be overridden by the cosumer contract.
1512      *
1513      * `previousExtraData` - the value of `extraData` before transfer.
1514      *
1515      * Calling conditions:
1516      *
1517      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1518      * transferred to `to`.
1519      * - When `from` is zero, `tokenId` will be minted for `to`.
1520      * - When `to` is zero, `tokenId` will be burned by `from`.
1521      * - `from` and `to` are never both zero.
1522      */
1523     function _extraData(
1524         address from,
1525         address to,
1526         uint24 previousExtraData
1527     ) internal view virtual returns (uint24) {}
1528 
1529     /**
1530      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1531      * This includes minting.
1532      * And also called before burning one token.
1533      *
1534      * startTokenId - the first token id to be transferred
1535      * quantity - the amount to be transferred
1536      *
1537      * Calling conditions:
1538      *
1539      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1540      * transferred to `to`.
1541      * - When `from` is zero, `tokenId` will be minted for `to`.
1542      * - When `to` is zero, `tokenId` will be burned by `from`.
1543      * - `from` and `to` are never both zero.
1544      */
1545     function _beforeTokenTransfers(
1546         address from,
1547         address to,
1548         uint256 startTokenId,
1549         uint256 quantity
1550     ) internal virtual {}
1551 
1552     /**
1553      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1554      * This includes minting.
1555      * And also called after one token has been burned.
1556      *
1557      * startTokenId - the first token id to be transferred
1558      * quantity - the amount to be transferred
1559      *
1560      * Calling conditions:
1561      *
1562      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1563      * transferred to `to`.
1564      * - When `from` is zero, `tokenId` has been minted for `to`.
1565      * - When `to` is zero, `tokenId` has been burned by `from`.
1566      * - `from` and `to` are never both zero.
1567      */
1568     function _afterTokenTransfers(
1569         address from,
1570         address to,
1571         uint256 startTokenId,
1572         uint256 quantity
1573     ) internal virtual {}
1574 
1575     /**
1576      * @dev Returns the message sender (defaults to `msg.sender`).
1577      *
1578      * If you are writing GSN compatible contracts, you need to override this function.
1579      */
1580     function _msgSenderERC721A() internal view virtual returns (address) {
1581         return msg.sender;
1582     }
1583 
1584     /**
1585      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1586      */
1587     function _toString(uint256 value) internal pure returns (string memory ptr) {
1588         assembly {
1589             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1590             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1591             // We will need 1 32-byte word to store the length,
1592             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1593             ptr := add(mload(0x40), 128)
1594             // Update the free memory pointer to allocate.
1595             mstore(0x40, ptr)
1596 
1597             // Cache the end of the memory to calculate the length later.
1598             let end := ptr
1599 
1600             // We write the string from the rightmost digit to the leftmost digit.
1601             // The following is essentially a do-while loop that also handles the zero case.
1602             // Costs a bit more than early returning for the zero case,
1603             // but cheaper in terms of deployment and overall runtime costs.
1604             for {
1605                 // Initialize and perform the first pass without check.
1606                 let temp := value
1607                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1608                 ptr := sub(ptr, 1)
1609                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1610                 mstore8(ptr, add(48, mod(temp, 10)))
1611                 temp := div(temp, 10)
1612             } temp {
1613                 // Keep dividing `temp` until zero.
1614                 temp := div(temp, 10)
1615             } {
1616                 // Body of the for loop.
1617                 ptr := sub(ptr, 1)
1618                 mstore8(ptr, add(48, mod(temp, 10)))
1619             }
1620 
1621             let length := sub(end, ptr)
1622             // Move the pointer 32 bytes leftwards to make room for the length.
1623             ptr := sub(ptr, 32)
1624             // Store the length.
1625             mstore(ptr, length)
1626         }
1627     }
1628 }
1629 
1630 // File: 5050.sol
1631 
1632 
1633 pragma solidity ^0.8.0;
1634 
1635 
1636 
1637 
1638 
1639 contract TinyLands is ERC721A, Ownable, ReentrancyGuard {
1640     // limits
1641     uint256 public maxPerTransaction = 10;
1642     uint256 public maxPerWallet = 50;
1643     uint256 public maxTotalSupply = 5555;
1644     uint256 public freeMintsAvailable = 3333;
1645     uint256 public freeMintsPerWallet = 2;
1646 
1647     // sale states
1648     bool public isPublicLive = false;
1649 
1650     // price
1651     uint256 public mintPrice = 0.005 ether;
1652 
1653     // whitelist config
1654     bytes32 private merkleTreeRoot;
1655 
1656     // metadata
1657     string public baseURI;
1658 
1659     // config
1660     mapping(address => uint256) public mintsPerWallet;
1661     address private withdrawAddress = address(0);
1662 
1663     constructor() ERC721A("Tiny Lands", "TL") {
1664         baseURI = "https://api.tinylands.xyz/api/tinyland?id=";
1665     }
1666 
1667     function mintPublic(uint256 _amount) external payable nonReentrant {
1668         require(isPublicLive, "Sale not live");
1669         require(_amount > 0, "You must mint at least one");
1670         require(totalSupply() + _amount <= maxTotalSupply, "Exceeds total supply");
1671         require(_amount <= maxPerTransaction, "Exceeds max per transaction");
1672 
1673         uint256 userMints = mintsPerWallet[_msgSender()];
1674         require(userMints + _amount <= maxPerWallet, "Exceeds max per wallet");
1675         uint256 pricedAmount = _amount;
1676 
1677         if(freeMintsAvailable > 0 && userMints < 2) {
1678             pricedAmount -= (2 - userMints);
1679             freeMintsAvailable -= (2 - userMints);
1680         }
1681 
1682         require(mintPrice * pricedAmount <= msg.value, "Not enough ETH sent for selected amount");
1683 
1684         mintsPerWallet[_msgSender()] = mintsPerWallet[_msgSender()] + _amount;
1685 
1686         payable(owner()).transfer(msg.value);
1687         _safeMint(_msgSender(), _amount);
1688     }
1689 
1690     function whitelistMint(uint256 _amount, address _to) external onlyOwner {
1691         require(isPublicLive, "Sale not live");
1692         require(_amount > 0, "You must mint at least one");
1693         require(totalSupply() + _amount <= maxTotalSupply, "Exceeds total supply");
1694         require(_amount <= maxPerTransaction, "Exceeds max per transaction");
1695 
1696         uint256 userMints = mintsPerWallet[_to];
1697         require(userMints + _amount <= maxPerWallet, "Exceeds max per wallet");
1698         mintsPerWallet[_to] = mintsPerWallet[_to] + _amount;
1699         freeMintsAvailable -= _amount;
1700 
1701         _safeMint(_to, _amount);
1702     }
1703 
1704 
1705     function flipPublicSaleState() external onlyOwner {
1706         isPublicLive = !isPublicLive;
1707     }
1708 
1709 
1710     function _baseURI() internal view virtual override returns (string memory) {
1711         return baseURI;
1712     }
1713 
1714     function withdraw() external onlyOwner {
1715         require(withdrawAddress != address(0), "No withdraw address");
1716         payable(withdrawAddress).transfer(address(this).balance);
1717     }
1718 
1719     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1720         baseURI = _newBaseURI;
1721     }
1722 
1723     function setWithdrawAddress(address _withdrawAddress) external onlyOwner {
1724         withdrawAddress = _withdrawAddress;
1725     }
1726 }