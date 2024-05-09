1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Tree proofs.
11  *
12  * The proofs can be generated using the JavaScript library
13  * https://github.com/miguelmota/merkletreejs[merkletreejs].
14  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
15  *
16  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
17  *
18  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
19  * hashing, or use a hash function other than keccak256 for hashing leaves.
20  * This is because the concatenation of a sorted pair of internal nodes in
21  * the merkle tree could be reinterpreted as a leaf value.
22  */
23 library MerkleProof {
24     /**
25      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
26      * defined by `root`. For this, a `proof` must be provided, containing
27      * sibling hashes on the branch from the leaf to the root of the tree. Each
28      * pair of leaves and each pair of pre-images are assumed to be sorted.
29      */
30     function verify(
31         bytes32[] memory proof,
32         bytes32 root,
33         bytes32 leaf
34     ) internal pure returns (bool) {
35         return processProof(proof, leaf) == root;
36     }
37 
38     /**
39      * @dev Calldata version of {verify}
40      *
41      * _Available since v4.7._
42      */
43     function verifyCalldata(
44         bytes32[] calldata proof,
45         bytes32 root,
46         bytes32 leaf
47     ) internal pure returns (bool) {
48         return processProofCalldata(proof, leaf) == root;
49     }
50 
51     /**
52      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
53      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
54      * hash matches the root of the tree. When processing the proof, the pairs
55      * of leafs & pre-images are assumed to be sorted.
56      *
57      * _Available since v4.4._
58      */
59     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
60         bytes32 computedHash = leaf;
61         for (uint256 i = 0; i < proof.length; i++) {
62             computedHash = _hashPair(computedHash, proof[i]);
63         }
64         return computedHash;
65     }
66 
67     /**
68      * @dev Calldata version of {processProof}
69      *
70      * _Available since v4.7._
71      */
72     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
73         bytes32 computedHash = leaf;
74         for (uint256 i = 0; i < proof.length; i++) {
75             computedHash = _hashPair(computedHash, proof[i]);
76         }
77         return computedHash;
78     }
79 
80     /**
81      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
82      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
83      *
84      * _Available since v4.7._
85      */
86     function multiProofVerify(
87         bytes32[] memory proof,
88         bool[] memory proofFlags,
89         bytes32 root,
90         bytes32[] memory leaves
91     ) internal pure returns (bool) {
92         return processMultiProof(proof, proofFlags, leaves) == root;
93     }
94 
95     /**
96      * @dev Calldata version of {multiProofVerify}
97      *
98      * _Available since v4.7._
99      */
100     function multiProofVerifyCalldata(
101         bytes32[] calldata proof,
102         bool[] calldata proofFlags,
103         bytes32 root,
104         bytes32[] memory leaves
105     ) internal pure returns (bool) {
106         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
107     }
108 
109     /**
110      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
111      * consuming from one or the other at each step according to the instructions given by
112      * `proofFlags`.
113      *
114      * _Available since v4.7._
115      */
116     function processMultiProof(
117         bytes32[] memory proof,
118         bool[] memory proofFlags,
119         bytes32[] memory leaves
120     ) internal pure returns (bytes32 merkleRoot) {
121         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
122         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
123         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
124         // the merkle tree.
125         uint256 leavesLen = leaves.length;
126         uint256 totalHashes = proofFlags.length;
127 
128         // Check proof validity.
129         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
130 
131         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
132         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
133         bytes32[] memory hashes = new bytes32[](totalHashes);
134         uint256 leafPos = 0;
135         uint256 hashPos = 0;
136         uint256 proofPos = 0;
137         // At each step, we compute the next hash using two values:
138         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
139         //   get the next hash.
140         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
141         //   `proof` array.
142         for (uint256 i = 0; i < totalHashes; i++) {
143             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
144             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
145             hashes[i] = _hashPair(a, b);
146         }
147 
148         if (totalHashes > 0) {
149             return hashes[totalHashes - 1];
150         } else if (leavesLen > 0) {
151             return leaves[0];
152         } else {
153             return proof[0];
154         }
155     }
156 
157     /**
158      * @dev Calldata version of {processMultiProof}
159      *
160      * _Available since v4.7._
161      */
162     function processMultiProofCalldata(
163         bytes32[] calldata proof,
164         bool[] calldata proofFlags,
165         bytes32[] memory leaves
166     ) internal pure returns (bytes32 merkleRoot) {
167         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
168         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
169         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
170         // the merkle tree.
171         uint256 leavesLen = leaves.length;
172         uint256 totalHashes = proofFlags.length;
173 
174         // Check proof validity.
175         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
176 
177         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
178         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
179         bytes32[] memory hashes = new bytes32[](totalHashes);
180         uint256 leafPos = 0;
181         uint256 hashPos = 0;
182         uint256 proofPos = 0;
183         // At each step, we compute the next hash using two values:
184         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
185         //   get the next hash.
186         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
187         //   `proof` array.
188         for (uint256 i = 0; i < totalHashes; i++) {
189             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
190             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
191             hashes[i] = _hashPair(a, b);
192         }
193 
194         if (totalHashes > 0) {
195             return hashes[totalHashes - 1];
196         } else if (leavesLen > 0) {
197             return leaves[0];
198         } else {
199             return proof[0];
200         }
201     }
202 
203     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
204         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
205     }
206 
207     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
208         /// @solidity memory-safe-assembly
209         assembly {
210             mstore(0x00, a)
211             mstore(0x20, b)
212             value := keccak256(0x00, 0x40)
213         }
214     }
215 }
216 
217 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
218 
219 
220 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @dev Interface of the ERC20 standard as defined in the EIP.
226  */
227 interface IERC20 {
228     /**
229      * @dev Emitted when `value` tokens are moved from one account (`from`) to
230      * another (`to`).
231      *
232      * Note that `value` may be zero.
233      */
234     event Transfer(address indexed from, address indexed to, uint256 value);
235 
236     /**
237      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
238      * a call to {approve}. `value` is the new allowance.
239      */
240     event Approval(address indexed owner, address indexed spender, uint256 value);
241 
242     /**
243      * @dev Returns the amount of tokens in existence.
244      */
245     function totalSupply() external view returns (uint256);
246 
247     /**
248      * @dev Returns the amount of tokens owned by `account`.
249      */
250     function balanceOf(address account) external view returns (uint256);
251 
252     /**
253      * @dev Moves `amount` tokens from the caller's account to `to`.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * Emits a {Transfer} event.
258      */
259     function transfer(address to, uint256 amount) external returns (bool);
260 
261     /**
262      * @dev Returns the remaining number of tokens that `spender` will be
263      * allowed to spend on behalf of `owner` through {transferFrom}. This is
264      * zero by default.
265      *
266      * This value changes when {approve} or {transferFrom} are called.
267      */
268     function allowance(address owner, address spender) external view returns (uint256);
269 
270     /**
271      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
272      *
273      * Returns a boolean value indicating whether the operation succeeded.
274      *
275      * IMPORTANT: Beware that changing an allowance with this method brings the risk
276      * that someone may use both the old and the new allowance by unfortunate
277      * transaction ordering. One possible solution to mitigate this race
278      * condition is to first reduce the spender's allowance to 0 and set the
279      * desired value afterwards:
280      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
281      *
282      * Emits an {Approval} event.
283      */
284     function approve(address spender, uint256 amount) external returns (bool);
285 
286     /**
287      * @dev Moves `amount` tokens from `from` to `to` using the
288      * allowance mechanism. `amount` is then deducted from the caller's
289      * allowance.
290      *
291      * Returns a boolean value indicating whether the operation succeeded.
292      *
293      * Emits a {Transfer} event.
294      */
295     function transferFrom(
296         address from,
297         address to,
298         uint256 amount
299     ) external returns (bool);
300 }
301 
302 // File: contracts/IERC721A.sol
303 
304 
305 // ERC721A Contracts v4.2.3
306 // Creator: Chiru Labs
307 
308 pragma solidity ^0.8.4;
309 
310 /**
311  * @dev Interface of ERC721A.
312  */
313 interface IERC721A {
314     /**
315      * The caller must own the token or be an approved operator.
316      */
317     error ApprovalCallerNotOwnerNorApproved();
318 
319     /**
320      * The token does not exist.
321      */
322     error ApprovalQueryForNonexistentToken();
323 
324     /**
325      * Cannot query the balance for the zero address.
326      */
327     error BalanceQueryForZeroAddress();
328 
329     /**
330      * Cannot mint to the zero address.
331      */
332     error MintToZeroAddress();
333 
334     /**
335      * The quantity of tokens minted must be more than zero.
336      */
337     error MintZeroQuantity();
338 
339     /**
340      * The token does not exist.
341      */
342     error OwnerQueryForNonexistentToken();
343 
344     /**
345      * The caller must own the token or be an approved operator.
346      */
347     error TransferCallerNotOwnerNorApproved();
348 
349     /**
350      * The token must be owned by `from`.
351      */
352     error TransferFromIncorrectOwner();
353 
354     /**
355      * Cannot safely transfer to a contract that does not implement the
356      * ERC721Receiver interface.
357      */
358     error TransferToNonERC721ReceiverImplementer();
359 
360     /**
361      * Cannot transfer to the zero address.
362      */
363     error TransferToZeroAddress();
364 
365     /**
366      * The token does not exist.
367      */
368     error URIQueryForNonexistentToken();
369 
370     /**
371      * The `quantity` minted with ERC2309 exceeds the safety limit.
372      */
373     error MintERC2309QuantityExceedsLimit();
374 
375     /**
376      * The `extraData` cannot be set on an unintialized ownership slot.
377      */
378     error OwnershipNotInitializedForExtraData();
379 
380     // =============================================================
381     //                            STRUCTS
382     // =============================================================
383 
384     struct TokenOwnership {
385         // The address of the owner.
386         address addr;
387         // Stores the start time of ownership with minimal overhead for tokenomics.
388         uint64 startTimestamp;
389         // Whether the token has been burned.
390         bool burned;
391         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
392         uint24 extraData;
393     }
394 
395     // =============================================================
396     //                         TOKEN COUNTERS
397     // =============================================================
398 
399     /**
400      * @dev Returns the total number of tokens in existence.
401      * Burned tokens will reduce the count.
402      * To get the total number of tokens minted, please see {_totalMinted}.
403      */
404     function totalSupply() external view returns (uint256);
405 
406     // =============================================================
407     //                            IERC165
408     // =============================================================
409 
410     /**
411      * @dev Returns true if this contract implements the interface defined by
412      * `interfaceId`. See the corresponding
413      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
414      * to learn more about how these ids are created.
415      *
416      * This function call must use less than 30000 gas.
417      */
418     function supportsInterface(bytes4 interfaceId) external view returns (bool);
419 
420     // =============================================================
421     //                            IERC721
422     // =============================================================
423 
424     /**
425      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
426      */
427     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
428 
429     /**
430      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
431      */
432     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
433 
434     /**
435      * @dev Emitted when `owner` enables or disables
436      * (`approved`) `operator` to manage all of its assets.
437      */
438     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
439 
440     /**
441      * @dev Returns the number of tokens in `owner`'s account.
442      */
443     function balanceOf(address owner) external view returns (uint256 balance);
444 
445     /**
446      * @dev Returns the owner of the `tokenId` token.
447      *
448      * Requirements:
449      *
450      * - `tokenId` must exist.
451      */
452     function ownerOf(uint256 tokenId) external view returns (address owner);
453 
454     /**
455      * @dev Safely transfers `tokenId` token from `from` to `to`,
456      * checking first that contract recipients are aware of the ERC721 protocol
457      * to prevent tokens from being forever locked.
458      *
459      * Requirements:
460      *
461      * - `from` cannot be the zero address.
462      * - `to` cannot be the zero address.
463      * - `tokenId` token must exist and be owned by `from`.
464      * - If the caller is not `from`, it must be have been allowed to move
465      * this token by either {approve} or {setApprovalForAll}.
466      * - If `to` refers to a smart contract, it must implement
467      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
468      *
469      * Emits a {Transfer} event.
470      */
471     function safeTransferFrom(
472         address from,
473         address to,
474         uint256 tokenId,
475         bytes calldata data
476     ) external payable;
477 
478     /**
479      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
480      */
481     function safeTransferFrom(
482         address from,
483         address to,
484         uint256 tokenId
485     ) external payable;
486 
487     /**
488      * @dev Transfers `tokenId` from `from` to `to`.
489      *
490      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
491      * whenever possible.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `tokenId` token must be owned by `from`.
498      * - If the caller is not `from`, it must be approved to move this token
499      * by either {approve} or {setApprovalForAll}.
500      *
501      * Emits a {Transfer} event.
502      */
503     function transferFrom(
504         address from,
505         address to,
506         uint256 tokenId
507     ) external payable;
508 
509     /**
510      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
511      * The approval is cleared when the token is transferred.
512      *
513      * Only a single account can be approved at a time, so approving the
514      * zero address clears previous approvals.
515      *
516      * Requirements:
517      *
518      * - The caller must own the token or be an approved operator.
519      * - `tokenId` must exist.
520      *
521      * Emits an {Approval} event.
522      */
523     function approve(address to, uint256 tokenId) external payable;
524 
525     /**
526      * @dev Approve or remove `operator` as an operator for the caller.
527      * Operators can call {transferFrom} or {safeTransferFrom}
528      * for any token owned by the caller.
529      *
530      * Requirements:
531      *
532      * - The `operator` cannot be the caller.
533      *
534      * Emits an {ApprovalForAll} event.
535      */
536     function setApprovalForAll(address operator, bool _approved) external;
537 
538     /**
539      * @dev Returns the account approved for `tokenId` token.
540      *
541      * Requirements:
542      *
543      * - `tokenId` must exist.
544      */
545     function getApproved(uint256 tokenId) external view returns (address operator);
546 
547     /**
548      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
549      *
550      * See {setApprovalForAll}.
551      */
552     function isApprovedForAll(address owner, address operator) external view returns (bool);
553 
554     // =============================================================
555     //                        IERC721Metadata
556     // =============================================================
557 
558     /**
559      * @dev Returns the token collection name.
560      */
561     function name() external view returns (string memory);
562 
563     /**
564      * @dev Returns the token collection symbol.
565      */
566     function symbol() external view returns (string memory);
567 
568     /**
569      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
570      */
571     function tokenURI(uint256 tokenId) external view returns (string memory);
572 
573     // =============================================================
574     //                           IERC2309
575     // =============================================================
576 
577     /**
578      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
579      * (inclusive) is transferred from `from` to `to`, as defined in the
580      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
581      *
582      * See {_mintERC2309} for more details.
583      */
584     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
585 }
586 // File: contracts/IERC721AQueryable.sol
587 
588 
589 // ERC721A Contracts v4.2.3
590 // Creator: Chiru Labs
591 
592 pragma solidity ^0.8.4;
593 
594 
595 /**
596  * @dev Interface of ERC721AQueryable.
597  */
598 interface IERC721AQueryable is IERC721A {
599     /**
600      * Invalid query range (`start` >= `stop`).
601      */
602     error InvalidQueryRange();
603 
604     /**
605      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
606      *
607      * If the `tokenId` is out of bounds:
608      *
609      * - `addr = address(0)`
610      * - `startTimestamp = 0`
611      * - `burned = false`
612      * - `extraData = 0`
613      *
614      * If the `tokenId` is burned:
615      *
616      * - `addr = <Address of owner before token was burned>`
617      * - `startTimestamp = <Timestamp when token was burned>`
618      * - `burned = true`
619      * - `extraData = <Extra data when token was burned>`
620      *
621      * Otherwise:
622      *
623      * - `addr = <Address of owner>`
624      * - `startTimestamp = <Timestamp of start of ownership>`
625      * - `burned = false`
626      * - `extraData = <Extra data at start of ownership>`
627      */
628     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
629 
630     /**
631      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
632      * See {ERC721AQueryable-explicitOwnershipOf}
633      */
634     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
635 
636     /**
637      * @dev Returns an array of token IDs owned by `owner`,
638      * in the range [`start`, `stop`)
639      * (i.e. `start <= tokenId < stop`).
640      *
641      * This function allows for tokens to be queried if the collection
642      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
643      *
644      * Requirements:
645      *
646      * - `start < stop`
647      */
648     function tokensOfOwnerIn(
649         address owner,
650         uint256 start,
651         uint256 stop
652     ) external view returns (uint256[] memory);
653 
654     /**
655      * @dev Returns an array of token IDs owned by `owner`.
656      *
657      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
658      * It is meant to be called off-chain.
659      *
660      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
661      * multiple smaller scans if the collection is large enough to cause
662      * an out-of-gas error (10K collections should be fine).
663      */
664     function tokensOfOwner(address owner) external view returns (uint256[] memory);
665 }
666 // File: contracts/ERC721A.sol
667 
668 
669 // ERC721A Contracts v4.2.3
670 // Creator: Chiru Labs
671 
672 pragma solidity ^0.8.4;
673 
674 
675 /**
676  * @dev Interface of ERC721 token receiver.
677  */
678 interface ERC721A__IERC721Receiver {
679     function onERC721Received(
680         address operator,
681         address from,
682         uint256 tokenId,
683         bytes calldata data
684     ) external returns (bytes4);
685 }
686 
687 /**
688  * @title ERC721A
689  *
690  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
691  * Non-Fungible Token Standard, including the Metadata extension.
692  * Optimized for lower gas during batch mints.
693  *
694  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
695  * starting from `_startTokenId()`.
696  *
697  * Assumptions:
698  *
699  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
700  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
701  */
702 contract ERC721A is IERC721A {
703     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
704     struct TokenApprovalRef {
705         address value;
706     }
707 
708     // =============================================================
709     //                           CONSTANTS
710     // =============================================================
711 
712     // Mask of an entry in packed address data.
713     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
714 
715     // The bit position of `numberMinted` in packed address data.
716     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
717 
718     // The bit position of `numberBurned` in packed address data.
719     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
720 
721     // The bit position of `aux` in packed address data.
722     uint256 private constant _BITPOS_AUX = 192;
723 
724     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
725     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
726 
727     // The bit position of `startTimestamp` in packed ownership.
728     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
729 
730     // The bit mask of the `burned` bit in packed ownership.
731     uint256 private constant _BITMASK_BURNED = 1 << 224;
732 
733     // The bit position of the `nextInitialized` bit in packed ownership.
734     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
735 
736     // The bit mask of the `nextInitialized` bit in packed ownership.
737     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
738 
739     // The bit position of `extraData` in packed ownership.
740     uint256 private constant _BITPOS_EXTRA_DATA = 232;
741 
742     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
743     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
744 
745     // The mask of the lower 160 bits for addresses.
746     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
747 
748     // The maximum `quantity` that can be minted with {_mintERC2309}.
749     // This limit is to prevent overflows on the address data entries.
750     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
751     // is required to cause an overflow, which is unrealistic.
752     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
753 
754     // The `Transfer` event signature is given by:
755     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
756     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
757         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
758 
759     // =============================================================
760     //                            STORAGE
761     // =============================================================
762 
763     // The next token ID to be minted.
764     uint256 private _currentIndex;
765 
766     // The number of tokens burned.
767     uint256 private _burnCounter;
768 
769     // Token name
770     string private _name;
771 
772     // Token symbol
773     string private _symbol;
774 
775     // Mapping from token ID to ownership details
776     // An empty struct value does not necessarily mean the token is unowned.
777     // See {_packedOwnershipOf} implementation for details.
778     //
779     // Bits Layout:
780     // - [0..159]   `addr`
781     // - [160..223] `startTimestamp`
782     // - [224]      `burned`
783     // - [225]      `nextInitialized`
784     // - [232..255] `extraData`
785     mapping(uint256 => uint256) private _packedOwnerships;
786 
787     // Mapping owner address to address data.
788     //
789     // Bits Layout:
790     // - [0..63]    `balance`
791     // - [64..127]  `numberMinted`
792     // - [128..191] `numberBurned`
793     // - [192..255] `aux`
794     mapping(address => uint256) private _packedAddressData;
795 
796     // Mapping from token ID to approved address.
797     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
798 
799     // Mapping from owner to operator approvals
800     mapping(address => mapping(address => bool)) private _operatorApprovals;
801 
802     // =============================================================
803     //                          CONSTRUCTOR
804     // =============================================================
805 
806     constructor(string memory name_, string memory symbol_) {
807         _name = name_;
808         _symbol = symbol_;
809         _currentIndex = _startTokenId();
810     }
811 
812     // =============================================================
813     //                   TOKEN COUNTING OPERATIONS
814     // =============================================================
815 
816     /**
817      * @dev Returns the starting token ID.
818      * To change the starting token ID, please override this function.
819      */
820     function _startTokenId() internal view virtual returns (uint256) {
821         return 0;
822     }
823 
824     /**
825      * @dev Returns the next token ID to be minted.
826      */
827     function _nextTokenId() internal view virtual returns (uint256) {
828         return _currentIndex;
829     }
830 
831     /**
832      * @dev Returns the total number of tokens in existence.
833      * Burned tokens will reduce the count.
834      * To get the total number of tokens minted, please see {_totalMinted}.
835      */
836     function totalSupply() public view virtual override returns (uint256) {
837         // Counter underflow is impossible as _burnCounter cannot be incremented
838         // more than `_currentIndex - _startTokenId()` times.
839         unchecked {
840             return _currentIndex - _burnCounter - _startTokenId();
841         }
842     }
843 
844     /**
845      * @dev Returns the total amount of tokens minted in the contract.
846      */
847     function _totalMinted() internal view virtual returns (uint256) {
848         // Counter underflow is impossible as `_currentIndex` does not decrement,
849         // and it is initialized to `_startTokenId()`.
850         unchecked {
851             return _currentIndex - _startTokenId();
852         }
853     }
854 
855     /**
856      * @dev Returns the total number of tokens burned.
857      */
858     function _totalBurned() internal view virtual returns (uint256) {
859         return _burnCounter;
860     }
861 
862     // =============================================================
863     //                    ADDRESS DATA OPERATIONS
864     // =============================================================
865 
866     /**
867      * @dev Returns the number of tokens in `owner`'s account.
868      */
869     function balanceOf(address owner) public view virtual override returns (uint256) {
870         if (owner == address(0)) revert BalanceQueryForZeroAddress();
871         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
872     }
873 
874     /**
875      * Returns the number of tokens minted by `owner`.
876      */
877     function _numberMinted(address owner) internal view returns (uint256) {
878         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
879     }
880 
881     /**
882      * Returns the number of tokens burned by or on behalf of `owner`.
883      */
884     function _numberBurned(address owner) internal view returns (uint256) {
885         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
886     }
887 
888     /**
889      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
890      */
891     function _getAux(address owner) internal view returns (uint64) {
892         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
893     }
894 
895     /**
896      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
897      * If there are multiple variables, please pack them into a uint64.
898      */
899     function _setAux(address owner, uint64 aux) internal virtual {
900         uint256 packed = _packedAddressData[owner];
901         uint256 auxCasted;
902         // Cast `aux` with assembly to avoid redundant masking.
903         assembly {
904             auxCasted := aux
905         }
906         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
907         _packedAddressData[owner] = packed;
908     }
909 
910     // =============================================================
911     //                            IERC165
912     // =============================================================
913 
914     /**
915      * @dev Returns true if this contract implements the interface defined by
916      * `interfaceId`. See the corresponding
917      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
918      * to learn more about how these ids are created.
919      *
920      * This function call must use less than 30000 gas.
921      */
922     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
923         // The interface IDs are constants representing the first 4 bytes
924         // of the XOR of all function selectors in the interface.
925         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
926         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
927         return
928             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
929             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
930             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
931     }
932 
933     // =============================================================
934     //                        IERC721Metadata
935     // =============================================================
936 
937     /**
938      * @dev Returns the token collection name.
939      */
940     function name() public view virtual override returns (string memory) {
941         return _name;
942     }
943 
944     /**
945      * @dev Returns the token collection symbol.
946      */
947     function symbol() public view virtual override returns (string memory) {
948         return _symbol;
949     }
950 
951     /**
952      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
953      */
954     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
955         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
956 
957         string memory baseURI = _baseURI();
958         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
959     }
960 
961     /**
962      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
963      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
964      * by default, it can be overridden in child contracts.
965      */
966     function _baseURI() internal view virtual returns (string memory) {
967         return '';
968     }
969 
970     // =============================================================
971     //                     OWNERSHIPS OPERATIONS
972     // =============================================================
973 
974     /**
975      * @dev Returns the owner of the `tokenId` token.
976      *
977      * Requirements:
978      *
979      * - `tokenId` must exist.
980      */
981     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
982         return address(uint160(_packedOwnershipOf(tokenId)));
983     }
984 
985     /**
986      * @dev Gas spent here starts off proportional to the maximum mint batch size.
987      * It gradually moves to O(1) as tokens get transferred around over time.
988      */
989     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
990         return _unpackedOwnership(_packedOwnershipOf(tokenId));
991     }
992 
993     /**
994      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
995      */
996     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
997         return _unpackedOwnership(_packedOwnerships[index]);
998     }
999 
1000     /**
1001      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1002      */
1003     function _initializeOwnershipAt(uint256 index) internal virtual {
1004         if (_packedOwnerships[index] == 0) {
1005             _packedOwnerships[index] = _packedOwnershipOf(index);
1006         }
1007     }
1008 
1009     /**
1010      * Returns the packed ownership data of `tokenId`.
1011      */
1012     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1013         uint256 curr = tokenId;
1014 
1015         unchecked {
1016             if (_startTokenId() <= curr)
1017                 if (curr < _currentIndex) {
1018                     uint256 packed = _packedOwnerships[curr];
1019                     // If not burned.
1020                     if (packed & _BITMASK_BURNED == 0) {
1021                         // Invariant:
1022                         // There will always be an initialized ownership slot
1023                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1024                         // before an unintialized ownership slot
1025                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1026                         // Hence, `curr` will not underflow.
1027                         //
1028                         // We can directly compare the packed value.
1029                         // If the address is zero, packed will be zero.
1030                         while (packed == 0) {
1031                             packed = _packedOwnerships[--curr];
1032                         }
1033                         return packed;
1034                     }
1035                 }
1036         }
1037         revert OwnerQueryForNonexistentToken();
1038     }
1039 
1040     /**
1041      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1042      */
1043     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1044         ownership.addr = address(uint160(packed));
1045         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1046         ownership.burned = packed & _BITMASK_BURNED != 0;
1047         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1048     }
1049 
1050     /**
1051      * @dev Packs ownership data into a single uint256.
1052      */
1053     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1054         assembly {
1055             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1056             owner := and(owner, _BITMASK_ADDRESS)
1057             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1058             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1059         }
1060     }
1061 
1062     /**
1063      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1064      */
1065     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1066         // For branchless setting of the `nextInitialized` flag.
1067         assembly {
1068             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1069             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1070         }
1071     }
1072 
1073     // =============================================================
1074     //                      APPROVAL OPERATIONS
1075     // =============================================================
1076 
1077     /**
1078      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1079      * The approval is cleared when the token is transferred.
1080      *
1081      * Only a single account can be approved at a time, so approving the
1082      * zero address clears previous approvals.
1083      *
1084      * Requirements:
1085      *
1086      * - The caller must own the token or be an approved operator.
1087      * - `tokenId` must exist.
1088      *
1089      * Emits an {Approval} event.
1090      */
1091     function approve(address to, uint256 tokenId) public payable virtual override {
1092         address owner = ownerOf(tokenId);
1093 
1094         if (_msgSenderERC721A() != owner)
1095             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1096                 revert ApprovalCallerNotOwnerNorApproved();
1097             }
1098 
1099         _tokenApprovals[tokenId].value = to;
1100         emit Approval(owner, to, tokenId);
1101     }
1102 
1103     /**
1104      * @dev Returns the account approved for `tokenId` token.
1105      *
1106      * Requirements:
1107      *
1108      * - `tokenId` must exist.
1109      */
1110     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1111         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1112 
1113         return _tokenApprovals[tokenId].value;
1114     }
1115 
1116     /**
1117      * @dev Approve or remove `operator` as an operator for the caller.
1118      * Operators can call {transferFrom} or {safeTransferFrom}
1119      * for any token owned by the caller.
1120      *
1121      * Requirements:
1122      *
1123      * - The `operator` cannot be the caller.
1124      *
1125      * Emits an {ApprovalForAll} event.
1126      */
1127     function setApprovalForAll(address operator, bool approved) public virtual override {
1128         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1129         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1130     }
1131 
1132     /**
1133      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1134      *
1135      * See {setApprovalForAll}.
1136      */
1137     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1138         return _operatorApprovals[owner][operator];
1139     }
1140 
1141     /**
1142      * @dev Returns whether `tokenId` exists.
1143      *
1144      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1145      *
1146      * Tokens start existing when they are minted. See {_mint}.
1147      */
1148     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1149         return
1150             _startTokenId() <= tokenId &&
1151             tokenId < _currentIndex && // If within bounds,
1152             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1153     }
1154 
1155     /**
1156      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1157      */
1158     function _isSenderApprovedOrOwner(
1159         address approvedAddress,
1160         address owner,
1161         address msgSender
1162     ) private pure returns (bool result) {
1163         assembly {
1164             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1165             owner := and(owner, _BITMASK_ADDRESS)
1166             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1167             msgSender := and(msgSender, _BITMASK_ADDRESS)
1168             // `msgSender == owner || msgSender == approvedAddress`.
1169             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1170         }
1171     }
1172 
1173     /**
1174      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1175      */
1176     function _getApprovedSlotAndAddress(uint256 tokenId)
1177         private
1178         view
1179         returns (uint256 approvedAddressSlot, address approvedAddress)
1180     {
1181         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1182         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1183         assembly {
1184             approvedAddressSlot := tokenApproval.slot
1185             approvedAddress := sload(approvedAddressSlot)
1186         }
1187     }
1188 
1189     // =============================================================
1190     //                      TRANSFER OPERATIONS
1191     // =============================================================
1192 
1193     /**
1194      * @dev Transfers `tokenId` from `from` to `to`.
1195      *
1196      * Requirements:
1197      *
1198      * - `from` cannot be the zero address.
1199      * - `to` cannot be the zero address.
1200      * - `tokenId` token must be owned by `from`.
1201      * - If the caller is not `from`, it must be approved to move this token
1202      * by either {approve} or {setApprovalForAll}.
1203      *
1204      * Emits a {Transfer} event.
1205      */
1206     function transferFrom(
1207         address from,
1208         address to,
1209         uint256 tokenId
1210     ) public payable virtual override {
1211         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1212 
1213         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1214 
1215         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1216 
1217         // The nested ifs save around 20+ gas over a compound boolean condition.
1218         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1219             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1220 
1221         if (to == address(0)) revert TransferToZeroAddress();
1222 
1223         _beforeTokenTransfers(from, to, tokenId, 1);
1224 
1225         // Clear approvals from the previous owner.
1226         assembly {
1227             if approvedAddress {
1228                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1229                 sstore(approvedAddressSlot, 0)
1230             }
1231         }
1232 
1233         // Underflow of the sender's balance is impossible because we check for
1234         // ownership above and the recipient's balance can't realistically overflow.
1235         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1236         unchecked {
1237             // We can directly increment and decrement the balances.
1238             --_packedAddressData[from]; // Updates: `balance -= 1`.
1239             ++_packedAddressData[to]; // Updates: `balance += 1`.
1240 
1241             // Updates:
1242             // - `address` to the next owner.
1243             // - `startTimestamp` to the timestamp of transfering.
1244             // - `burned` to `false`.
1245             // - `nextInitialized` to `true`.
1246             _packedOwnerships[tokenId] = _packOwnershipData(
1247                 to,
1248                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1249             );
1250 
1251             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1252             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1253                 uint256 nextTokenId = tokenId + 1;
1254                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1255                 if (_packedOwnerships[nextTokenId] == 0) {
1256                     // If the next slot is within bounds.
1257                     if (nextTokenId != _currentIndex) {
1258                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1259                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1260                     }
1261                 }
1262             }
1263         }
1264 
1265         emit Transfer(from, to, tokenId);
1266         _afterTokenTransfers(from, to, tokenId, 1);
1267     }
1268 
1269     /**
1270      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1271      */
1272     function safeTransferFrom(
1273         address from,
1274         address to,
1275         uint256 tokenId
1276     ) public payable virtual override {
1277         safeTransferFrom(from, to, tokenId, '');
1278     }
1279 
1280     /**
1281      * @dev Safely transfers `tokenId` token from `from` to `to`.
1282      *
1283      * Requirements:
1284      *
1285      * - `from` cannot be the zero address.
1286      * - `to` cannot be the zero address.
1287      * - `tokenId` token must exist and be owned by `from`.
1288      * - If the caller is not `from`, it must be approved to move this token
1289      * by either {approve} or {setApprovalForAll}.
1290      * - If `to` refers to a smart contract, it must implement
1291      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1292      *
1293      * Emits a {Transfer} event.
1294      */
1295     function safeTransferFrom(
1296         address from,
1297         address to,
1298         uint256 tokenId,
1299         bytes memory _data
1300     ) public payable virtual override {
1301         transferFrom(from, to, tokenId);
1302         if (to.code.length != 0)
1303             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1304                 revert TransferToNonERC721ReceiverImplementer();
1305             }
1306     }
1307 
1308     /**
1309      * @dev Hook that is called before a set of serially-ordered token IDs
1310      * are about to be transferred. This includes minting.
1311      * And also called before burning one token.
1312      *
1313      * `startTokenId` - the first token ID to be transferred.
1314      * `quantity` - the amount to be transferred.
1315      *
1316      * Calling conditions:
1317      *
1318      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1319      * transferred to `to`.
1320      * - When `from` is zero, `tokenId` will be minted for `to`.
1321      * - When `to` is zero, `tokenId` will be burned by `from`.
1322      * - `from` and `to` are never both zero.
1323      */
1324     function _beforeTokenTransfers(
1325         address from,
1326         address to,
1327         uint256 startTokenId,
1328         uint256 quantity
1329     ) internal virtual {}
1330 
1331     /**
1332      * @dev Hook that is called after a set of serially-ordered token IDs
1333      * have been transferred. This includes minting.
1334      * And also called after one token has been burned.
1335      *
1336      * `startTokenId` - the first token ID to be transferred.
1337      * `quantity` - the amount to be transferred.
1338      *
1339      * Calling conditions:
1340      *
1341      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1342      * transferred to `to`.
1343      * - When `from` is zero, `tokenId` has been minted for `to`.
1344      * - When `to` is zero, `tokenId` has been burned by `from`.
1345      * - `from` and `to` are never both zero.
1346      */
1347     function _afterTokenTransfers(
1348         address from,
1349         address to,
1350         uint256 startTokenId,
1351         uint256 quantity
1352     ) internal virtual {}
1353 
1354     /**
1355      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1356      *
1357      * `from` - Previous owner of the given token ID.
1358      * `to` - Target address that will receive the token.
1359      * `tokenId` - Token ID to be transferred.
1360      * `_data` - Optional data to send along with the call.
1361      *
1362      * Returns whether the call correctly returned the expected magic value.
1363      */
1364     function _checkContractOnERC721Received(
1365         address from,
1366         address to,
1367         uint256 tokenId,
1368         bytes memory _data
1369     ) private returns (bool) {
1370         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1371             bytes4 retval
1372         ) {
1373             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1374         } catch (bytes memory reason) {
1375             if (reason.length == 0) {
1376                 revert TransferToNonERC721ReceiverImplementer();
1377             } else {
1378                 assembly {
1379                     revert(add(32, reason), mload(reason))
1380                 }
1381             }
1382         }
1383     }
1384 
1385     // =============================================================
1386     //                        MINT OPERATIONS
1387     // =============================================================
1388 
1389     /**
1390      * @dev Mints `quantity` tokens and transfers them to `to`.
1391      *
1392      * Requirements:
1393      *
1394      * - `to` cannot be the zero address.
1395      * - `quantity` must be greater than 0.
1396      *
1397      * Emits a {Transfer} event for each mint.
1398      */
1399     function _mint(address to, uint256 quantity) internal virtual {
1400         uint256 startTokenId = _currentIndex;
1401         if (quantity == 0) revert MintZeroQuantity();
1402 
1403         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1404 
1405         // Overflows are incredibly unrealistic.
1406         // `balance` and `numberMinted` have a maximum limit of 2**64.
1407         // `tokenId` has a maximum limit of 2**256.
1408         unchecked {
1409             // Updates:
1410             // - `balance += quantity`.
1411             // - `numberMinted += quantity`.
1412             //
1413             // We can directly add to the `balance` and `numberMinted`.
1414             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1415 
1416             // Updates:
1417             // - `address` to the owner.
1418             // - `startTimestamp` to the timestamp of minting.
1419             // - `burned` to `false`.
1420             // - `nextInitialized` to `quantity == 1`.
1421             _packedOwnerships[startTokenId] = _packOwnershipData(
1422                 to,
1423                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1424             );
1425 
1426             uint256 toMasked;
1427             uint256 end = startTokenId + quantity;
1428 
1429             // Use assembly to loop and emit the `Transfer` event for gas savings.
1430             // The duplicated `log4` removes an extra check and reduces stack juggling.
1431             // The assembly, together with the surrounding Solidity code, have been
1432             // delicately arranged to nudge the compiler into producing optimized opcodes.
1433             assembly {
1434                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1435                 toMasked := and(to, _BITMASK_ADDRESS)
1436                 // Emit the `Transfer` event.
1437                 log4(
1438                     0, // Start of data (0, since no data).
1439                     0, // End of data (0, since no data).
1440                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1441                     0, // `address(0)`.
1442                     toMasked, // `to`.
1443                     startTokenId // `tokenId`.
1444                 )
1445 
1446                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1447                 // that overflows uint256 will make the loop run out of gas.
1448                 // The compiler will optimize the `iszero` away for performance.
1449                 for {
1450                     let tokenId := add(startTokenId, 1)
1451                 } iszero(eq(tokenId, end)) {
1452                     tokenId := add(tokenId, 1)
1453                 } {
1454                     // Emit the `Transfer` event. Similar to above.
1455                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1456                 }
1457             }
1458             if (toMasked == 0) revert MintToZeroAddress();
1459 
1460             _currentIndex = end;
1461         }
1462         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1463     }
1464 
1465     /**
1466      * @dev Mints `quantity` tokens and transfers them to `to`.
1467      *
1468      * This function is intended for efficient minting only during contract creation.
1469      *
1470      * It emits only one {ConsecutiveTransfer} as defined in
1471      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1472      * instead of a sequence of {Transfer} event(s).
1473      *
1474      * Calling this function outside of contract creation WILL make your contract
1475      * non-compliant with the ERC721 standard.
1476      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1477      * {ConsecutiveTransfer} event is only permissible during contract creation.
1478      *
1479      * Requirements:
1480      *
1481      * - `to` cannot be the zero address.
1482      * - `quantity` must be greater than 0.
1483      *
1484      * Emits a {ConsecutiveTransfer} event.
1485      */
1486     function _mintERC2309(address to, uint256 quantity) internal virtual {
1487         uint256 startTokenId = _currentIndex;
1488         if (to == address(0)) revert MintToZeroAddress();
1489         if (quantity == 0) revert MintZeroQuantity();
1490         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1491 
1492         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1493 
1494         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1495         unchecked {
1496             // Updates:
1497             // - `balance += quantity`.
1498             // - `numberMinted += quantity`.
1499             //
1500             // We can directly add to the `balance` and `numberMinted`.
1501             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1502 
1503             // Updates:
1504             // - `address` to the owner.
1505             // - `startTimestamp` to the timestamp of minting.
1506             // - `burned` to `false`.
1507             // - `nextInitialized` to `quantity == 1`.
1508             _packedOwnerships[startTokenId] = _packOwnershipData(
1509                 to,
1510                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1511             );
1512 
1513             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1514 
1515             _currentIndex = startTokenId + quantity;
1516         }
1517         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1518     }
1519 
1520     /**
1521      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1522      *
1523      * Requirements:
1524      *
1525      * - If `to` refers to a smart contract, it must implement
1526      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1527      * - `quantity` must be greater than 0.
1528      *
1529      * See {_mint}.
1530      *
1531      * Emits a {Transfer} event for each mint.
1532      */
1533     function _safeMint(
1534         address to,
1535         uint256 quantity,
1536         bytes memory _data
1537     ) internal virtual {
1538         _mint(to, quantity);
1539 
1540         unchecked {
1541             if (to.code.length != 0) {
1542                 uint256 end = _currentIndex;
1543                 uint256 index = end - quantity;
1544                 do {
1545                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1546                         revert TransferToNonERC721ReceiverImplementer();
1547                     }
1548                 } while (index < end);
1549                 // Reentrancy protection.
1550                 if (_currentIndex != end) revert();
1551             }
1552         }
1553     }
1554 
1555     /**
1556      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1557      */
1558     function _safeMint(address to, uint256 quantity) internal virtual {
1559         _safeMint(to, quantity, '');
1560     }
1561 
1562     // =============================================================
1563     //                        BURN OPERATIONS
1564     // =============================================================
1565 
1566     /**
1567      * @dev Equivalent to `_burn(tokenId, false)`.
1568      */
1569     function _burn(uint256 tokenId) internal virtual {
1570         _burn(tokenId, false);
1571     }
1572 
1573     /**
1574      * @dev Destroys `tokenId`.
1575      * The approval is cleared when the token is burned.
1576      *
1577      * Requirements:
1578      *
1579      * - `tokenId` must exist.
1580      *
1581      * Emits a {Transfer} event.
1582      */
1583     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1584         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1585 
1586         address from = address(uint160(prevOwnershipPacked));
1587 
1588         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1589 
1590         if (approvalCheck) {
1591             // The nested ifs save around 20+ gas over a compound boolean condition.
1592             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1593                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1594         }
1595 
1596         _beforeTokenTransfers(from, address(0), tokenId, 1);
1597 
1598         // Clear approvals from the previous owner.
1599         assembly {
1600             if approvedAddress {
1601                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1602                 sstore(approvedAddressSlot, 0)
1603             }
1604         }
1605 
1606         // Underflow of the sender's balance is impossible because we check for
1607         // ownership above and the recipient's balance can't realistically overflow.
1608         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1609         unchecked {
1610             // Updates:
1611             // - `balance -= 1`.
1612             // - `numberBurned += 1`.
1613             //
1614             // We can directly decrement the balance, and increment the number burned.
1615             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1616             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1617 
1618             // Updates:
1619             // - `address` to the last owner.
1620             // - `startTimestamp` to the timestamp of burning.
1621             // - `burned` to `true`.
1622             // - `nextInitialized` to `true`.
1623             _packedOwnerships[tokenId] = _packOwnershipData(
1624                 from,
1625                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1626             );
1627 
1628             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1629             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1630                 uint256 nextTokenId = tokenId + 1;
1631                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1632                 if (_packedOwnerships[nextTokenId] == 0) {
1633                     // If the next slot is within bounds.
1634                     if (nextTokenId != _currentIndex) {
1635                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1636                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1637                     }
1638                 }
1639             }
1640         }
1641 
1642         emit Transfer(from, address(0), tokenId);
1643         _afterTokenTransfers(from, address(0), tokenId, 1);
1644 
1645         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1646         unchecked {
1647             _burnCounter++;
1648         }
1649     }
1650 
1651     // =============================================================
1652     //                     EXTRA DATA OPERATIONS
1653     // =============================================================
1654 
1655     /**
1656      * @dev Directly sets the extra data for the ownership data `index`.
1657      */
1658     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1659         uint256 packed = _packedOwnerships[index];
1660         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1661         uint256 extraDataCasted;
1662         // Cast `extraData` with assembly to avoid redundant masking.
1663         assembly {
1664             extraDataCasted := extraData
1665         }
1666         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1667         _packedOwnerships[index] = packed;
1668     }
1669 
1670     /**
1671      * @dev Called during each token transfer to set the 24bit `extraData` field.
1672      * Intended to be overridden by the cosumer contract.
1673      *
1674      * `previousExtraData` - the value of `extraData` before transfer.
1675      *
1676      * Calling conditions:
1677      *
1678      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1679      * transferred to `to`.
1680      * - When `from` is zero, `tokenId` will be minted for `to`.
1681      * - When `to` is zero, `tokenId` will be burned by `from`.
1682      * - `from` and `to` are never both zero.
1683      */
1684     function _extraData(
1685         address from,
1686         address to,
1687         uint24 previousExtraData
1688     ) internal view virtual returns (uint24) {}
1689 
1690     /**
1691      * @dev Returns the next extra data for the packed ownership data.
1692      * The returned result is shifted into position.
1693      */
1694     function _nextExtraData(
1695         address from,
1696         address to,
1697         uint256 prevOwnershipPacked
1698     ) private view returns (uint256) {
1699         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1700         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1701     }
1702 
1703     // =============================================================
1704     //                       OTHER OPERATIONS
1705     // =============================================================
1706 
1707     /**
1708      * @dev Returns the message sender (defaults to `msg.sender`).
1709      *
1710      * If you are writing GSN compatible contracts, you need to override this function.
1711      */
1712     function _msgSenderERC721A() internal view virtual returns (address) {
1713         return msg.sender;
1714     }
1715 
1716     /**
1717      * @dev Converts a uint256 to its ASCII string decimal representation.
1718      */
1719     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1720         assembly {
1721             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1722             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1723             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1724             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1725             let m := add(mload(0x40), 0xa0)
1726             // Update the free memory pointer to allocate.
1727             mstore(0x40, m)
1728             // Assign the `str` to the end.
1729             str := sub(m, 0x20)
1730             // Zeroize the slot after the string.
1731             mstore(str, 0)
1732 
1733             // Cache the end of the memory to calculate the length later.
1734             let end := str
1735 
1736             // We write the string from rightmost digit to leftmost digit.
1737             // The following is essentially a do-while loop that also handles the zero case.
1738             // prettier-ignore
1739             for { let temp := value } 1 {} {
1740                 str := sub(str, 1)
1741                 // Write the character to the pointer.
1742                 // The ASCII index of the '0' character is 48.
1743                 mstore8(str, add(48, mod(temp, 10)))
1744                 // Keep dividing `temp` until zero.
1745                 temp := div(temp, 10)
1746                 // prettier-ignore
1747                 if iszero(temp) { break }
1748             }
1749 
1750             let length := sub(end, str)
1751             // Move the pointer 32 bytes leftwards to make room for the length.
1752             str := sub(str, 0x20)
1753             // Store the length.
1754             mstore(str, length)
1755         }
1756     }
1757 }
1758 // File: contracts/ERC721AQueryable.sol
1759 
1760 
1761 // ERC721A Contracts v4.2.3
1762 // Creator: Chiru Labs
1763 
1764 pragma solidity ^0.8.4;
1765 
1766 
1767 
1768 /**
1769  * @title ERC721AQueryable.
1770  *
1771  * @dev ERC721A subclass with convenience query functions.
1772  */
1773 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1774     /**
1775      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1776      *
1777      * If the `tokenId` is out of bounds:
1778      *
1779      * - `addr = address(0)`
1780      * - `startTimestamp = 0`
1781      * - `burned = false`
1782      * - `extraData = 0`
1783      *
1784      * If the `tokenId` is burned:
1785      *
1786      * - `addr = <Address of owner before token was burned>`
1787      * - `startTimestamp = <Timestamp when token was burned>`
1788      * - `burned = true`
1789      * - `extraData = <Extra data when token was burned>`
1790      *
1791      * Otherwise:
1792      *
1793      * - `addr = <Address of owner>`
1794      * - `startTimestamp = <Timestamp of start of ownership>`
1795      * - `burned = false`
1796      * - `extraData = <Extra data at start of ownership>`
1797      */
1798     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1799         TokenOwnership memory ownership;
1800         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1801             return ownership;
1802         }
1803         ownership = _ownershipAt(tokenId);
1804         if (ownership.burned) {
1805             return ownership;
1806         }
1807         return _ownershipOf(tokenId);
1808     }
1809 
1810     /**
1811      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1812      * See {ERC721AQueryable-explicitOwnershipOf}
1813      */
1814     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1815         external
1816         view
1817         virtual
1818         override
1819         returns (TokenOwnership[] memory)
1820     {
1821         unchecked {
1822             uint256 tokenIdsLength = tokenIds.length;
1823             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1824             for (uint256 i; i != tokenIdsLength; ++i) {
1825                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1826             }
1827             return ownerships;
1828         }
1829     }
1830 
1831     /**
1832      * @dev Returns an array of token IDs owned by `owner`,
1833      * in the range [`start`, `stop`)
1834      * (i.e. `start <= tokenId < stop`).
1835      *
1836      * This function allows for tokens to be queried if the collection
1837      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1838      *
1839      * Requirements:
1840      *
1841      * - `start < stop`
1842      */
1843     function tokensOfOwnerIn(
1844         address owner,
1845         uint256 start,
1846         uint256 stop
1847     ) external view virtual override returns (uint256[] memory) {
1848         unchecked {
1849             if (start >= stop) revert InvalidQueryRange();
1850             uint256 tokenIdsIdx;
1851             uint256 stopLimit = _nextTokenId();
1852             // Set `start = max(start, _startTokenId())`.
1853             if (start < _startTokenId()) {
1854                 start = _startTokenId();
1855             }
1856             // Set `stop = min(stop, stopLimit)`.
1857             if (stop > stopLimit) {
1858                 stop = stopLimit;
1859             }
1860             uint256 tokenIdsMaxLength = balanceOf(owner);
1861             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1862             // to cater for cases where `balanceOf(owner)` is too big.
1863             if (start < stop) {
1864                 uint256 rangeLength = stop - start;
1865                 if (rangeLength < tokenIdsMaxLength) {
1866                     tokenIdsMaxLength = rangeLength;
1867                 }
1868             } else {
1869                 tokenIdsMaxLength = 0;
1870             }
1871             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1872             if (tokenIdsMaxLength == 0) {
1873                 return tokenIds;
1874             }
1875             // We need to call `explicitOwnershipOf(start)`,
1876             // because the slot at `start` may not be initialized.
1877             TokenOwnership memory ownership = explicitOwnershipOf(start);
1878             address currOwnershipAddr;
1879             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1880             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1881             if (!ownership.burned) {
1882                 currOwnershipAddr = ownership.addr;
1883             }
1884             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1885                 ownership = _ownershipAt(i);
1886                 if (ownership.burned) {
1887                     continue;
1888                 }
1889                 if (ownership.addr != address(0)) {
1890                     currOwnershipAddr = ownership.addr;
1891                 }
1892                 if (currOwnershipAddr == owner) {
1893                     tokenIds[tokenIdsIdx++] = i;
1894                 }
1895             }
1896             // Downsize the array to fit.
1897             assembly {
1898                 mstore(tokenIds, tokenIdsIdx)
1899             }
1900             return tokenIds;
1901         }
1902     }
1903 
1904     /**
1905      * @dev Returns an array of token IDs owned by `owner`.
1906      *
1907      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1908      * It is meant to be called off-chain.
1909      *
1910      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1911      * multiple smaller scans if the collection is large enough to cause
1912      * an out-of-gas error (10K collections should be fine).
1913      */
1914     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1915         unchecked {
1916             uint256 tokenIdsIdx;
1917             address currOwnershipAddr;
1918             uint256 tokenIdsLength = balanceOf(owner);
1919             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1920             TokenOwnership memory ownership;
1921             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1922                 ownership = _ownershipAt(i);
1923                 if (ownership.burned) {
1924                     continue;
1925                 }
1926                 if (ownership.addr != address(0)) {
1927                     currOwnershipAddr = ownership.addr;
1928                 }
1929                 if (currOwnershipAddr == owner) {
1930                     tokenIds[tokenIdsIdx++] = i;
1931                 }
1932             }
1933             return tokenIds;
1934         }
1935     }
1936 }
1937 // File: @openzeppelin/contracts/utils/Strings.sol
1938 
1939 
1940 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1941 
1942 pragma solidity ^0.8.0;
1943 
1944 /**
1945  * @dev String operations.
1946  */
1947 library Strings {
1948     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1949     uint8 private constant _ADDRESS_LENGTH = 20;
1950 
1951     /**
1952      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1953      */
1954     function toString(uint256 value) internal pure returns (string memory) {
1955         // Inspired by OraclizeAPI's implementation - MIT licence
1956         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1957 
1958         if (value == 0) {
1959             return "0";
1960         }
1961         uint256 temp = value;
1962         uint256 digits;
1963         while (temp != 0) {
1964             digits++;
1965             temp /= 10;
1966         }
1967         bytes memory buffer = new bytes(digits);
1968         while (value != 0) {
1969             digits -= 1;
1970             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1971             value /= 10;
1972         }
1973         return string(buffer);
1974     }
1975 
1976     /**
1977      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1978      */
1979     function toHexString(uint256 value) internal pure returns (string memory) {
1980         if (value == 0) {
1981             return "0x00";
1982         }
1983         uint256 temp = value;
1984         uint256 length = 0;
1985         while (temp != 0) {
1986             length++;
1987             temp >>= 8;
1988         }
1989         return toHexString(value, length);
1990     }
1991 
1992     /**
1993      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1994      */
1995     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1996         bytes memory buffer = new bytes(2 * length + 2);
1997         buffer[0] = "0";
1998         buffer[1] = "x";
1999         for (uint256 i = 2 * length + 1; i > 1; --i) {
2000             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2001             value >>= 4;
2002         }
2003         require(value == 0, "Strings: hex length insufficient");
2004         return string(buffer);
2005     }
2006 
2007     /**
2008      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2009      */
2010     function toHexString(address addr) internal pure returns (string memory) {
2011         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2012     }
2013 }
2014 
2015 // File: @openzeppelin/contracts/utils/Context.sol
2016 
2017 
2018 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2019 
2020 pragma solidity ^0.8.0;
2021 
2022 /**
2023  * @dev Provides information about the current execution context, including the
2024  * sender of the transaction and its data. While these are generally available
2025  * via msg.sender and msg.data, they should not be accessed in such a direct
2026  * manner, since when dealing with meta-transactions the account sending and
2027  * paying for execution may not be the actual sender (as far as an application
2028  * is concerned).
2029  *
2030  * This contract is only required for intermediate, library-like contracts.
2031  */
2032 abstract contract Context {
2033     function _msgSender() internal view virtual returns (address) {
2034         return msg.sender;
2035     }
2036 
2037     function _msgData() internal view virtual returns (bytes calldata) {
2038         return msg.data;
2039     }
2040 }
2041 
2042 // File: @openzeppelin/contracts/access/Ownable.sol
2043 
2044 
2045 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2046 
2047 pragma solidity ^0.8.0;
2048 
2049 
2050 /**
2051  * @dev Contract module which provides a basic access control mechanism, where
2052  * there is an account (an owner) that can be granted exclusive access to
2053  * specific functions.
2054  *
2055  * By default, the owner account will be the one that deploys the contract. This
2056  * can later be changed with {transferOwnership}.
2057  *
2058  * This module is used through inheritance. It will make available the modifier
2059  * `onlyOwner`, which can be applied to your functions to restrict their use to
2060  * the owner.
2061  */
2062 abstract contract Ownable is Context {
2063     address private _owner;
2064 
2065     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2066 
2067     /**
2068      * @dev Initializes the contract setting the deployer as the initial owner.
2069      */
2070     constructor() {
2071         _transferOwnership(_msgSender());
2072     }
2073 
2074     /**
2075      * @dev Throws if called by any account other than the owner.
2076      */
2077     modifier onlyOwner() {
2078         _checkOwner();
2079         _;
2080     }
2081 
2082     /**
2083      * @dev Returns the address of the current owner.
2084      */
2085     function owner() public view virtual returns (address) {
2086         return _owner;
2087     }
2088 
2089     /**
2090      * @dev Throws if the sender is not the owner.
2091      */
2092     function _checkOwner() internal view virtual {
2093         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2094     }
2095 
2096     /**
2097      * @dev Leaves the contract without owner. It will not be possible to call
2098      * `onlyOwner` functions anymore. Can only be called by the current owner.
2099      *
2100      * NOTE: Renouncing ownership will leave the contract without an owner,
2101      * thereby removing any functionality that is only available to the owner.
2102      */
2103     function renounceOwnership() public virtual onlyOwner {
2104         _transferOwnership(address(0));
2105     }
2106 
2107     /**
2108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2109      * Can only be called by the current owner.
2110      */
2111     function transferOwnership(address newOwner) public virtual onlyOwner {
2112         require(newOwner != address(0), "Ownable: new owner is the zero address");
2113         _transferOwnership(newOwner);
2114     }
2115 
2116     /**
2117      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2118      * Internal function without access restriction.
2119      */
2120     function _transferOwnership(address newOwner) internal virtual {
2121         address oldOwner = _owner;
2122         _owner = newOwner;
2123         emit OwnershipTransferred(oldOwner, newOwner);
2124     }
2125 }
2126 
2127 // File: contracts/Frontiers.sol
2128 
2129 
2130 pragma solidity ^0.8.4;
2131 
2132 
2133 
2134 
2135 
2136 
2137 
2138 contract Frontiers is ERC721AQueryable, Ownable {
2139 
2140     string metadataPath = "https://universe.theblinkless.com/frontiersjson/";
2141     mapping(uint256 => string) public tokenList; // tokenid => "[planetid]-[parcelid]";
2142     mapping(uint256 => uint256) public planetParcelCounts; // planetid => # of parcels
2143     address payoutWallet = 0xeD2faa60373eC70E57B39152aeE5Ce4ed7C333c7; //wallet for payouts
2144     address optixReceiver = 0xB818B1BbF47fC499B621f6807d61a61046C6478f; // wallet to receive optix
2145     address bigBangContract = 0x12bE473a9299B29a1E22c0893695254a97dEa07f; //big bang contract address
2146     address optixContract = 0xa93fce39D926527Af68B8520FB55e2f74D9201b5; // optix contract address
2147     uint256 optixMintPrice = 5000 ether;
2148     uint256 currentlyMinting = 0;
2149     bytes32 root = 0x14a5ea8f1752b06b4aa9292e0c381cb9fbf293d53f033935235cae2ef6e7ae2d;
2150 
2151     constructor() ERC721A("The Blinkless: Frontiers", "BLNKFR") {}
2152 
2153     /*
2154     * Verifies the parcel count supplied from metadata is accurate
2155     */
2156     function verifyParcelCount(bytes32[] memory proof, bytes32 leaf) public view returns (bool){
2157         return MerkleProof.verify(proof,root,leaf);
2158     }
2159 
2160     
2161  
2162 
2163      /**
2164     * Update the optix mint price per parcel
2165     */
2166     function updateOptixMintPrice(uint256 _price) public onlyOwner{
2167         optixMintPrice = _price;
2168     }
2169 
2170 
2171      /**
2172     * Update the metadata path
2173     */
2174     function updateMetadataPath(string memory _path) public onlyOwner{
2175         metadataPath = _path;
2176     }
2177 
2178 
2179      /**
2180     * Update the big bang address
2181     */
2182      function updateBigBangContract(address _contract) public onlyOwner{
2183         bigBangContract = _contract;
2184     }
2185 
2186      /**
2187     * Update the optix address
2188     */
2189      function updateOptixContract(address _contract) public onlyOwner{
2190         optixContract = _contract;
2191     }
2192 
2193      /**
2194     * Update the optix receiver address
2195     */
2196      function updateOptixReceiver(address _address) public onlyOwner{
2197         optixReceiver = _address;
2198     }
2199 
2200      /**
2201     * Update the mint status
2202     */
2203      function updateCurrentlyMinting(uint256 _status) public onlyOwner{
2204         currentlyMinting = _status;
2205     }
2206 
2207      /**
2208     * Update the merkle root
2209     */
2210     function updateRoot(bytes32 _root) public onlyOwner{
2211         root = _root;
2212     }
2213 
2214 
2215      /**
2216     * Update the payout wallet address
2217     */
2218     function updatePayoutWallet(address _payoutWallet) public onlyOwner{
2219         payoutWallet = _payoutWallet;
2220     }
2221 
2222      /*
2223     * Withdraw by owner
2224     */
2225     function withdraw() external onlyOwner {
2226         (bool success, ) = payable(payoutWallet).call{value: address(this).balance}("");
2227         require(success, "Transfer failed.");
2228     }
2229 
2230 
2231 
2232     /*
2233     * These are here to receive ETH sent to the contract address
2234     */
2235     receive() external payable {}
2236 
2237     fallback() external payable {}
2238 }
2239 // File: contracts/Grimlets.sol
2240 
2241 
2242 pragma solidity ^0.8.4;
2243 
2244 
2245 
2246 
2247 
2248 
2249 
2250 
2251 contract Grimlets is ERC721AQueryable, Ownable {
2252 
2253     string public metadataPath = "https://theblinkless.s3.amazonaws.com/grimletsjson/";
2254     address public payoutWallet = 0xeD2faa60373eC70E57B39152aeE5Ce4ed7C333c7; //wallet for payouts
2255     address public projectWallet = 0xB818B1BbF47fC499B621f6807d61a61046C6478f; //project wallet
2256     address public optixReceiver = 0xB818B1BbF47fC499B621f6807d61a61046C6478f; // wallet to receive optix
2257     address public optixContract = 0xa93fce39D926527Af68B8520FB55e2f74D9201b5; // optix contract address
2258     address public frontiersContract = 0xC772fB742a39dFC935Ea51f217ef58282c634521; // frontiers contract address
2259     uint256 public optixMintPrice = 250000 ether;
2260     uint256 maxSupply = 3500;
2261     mapping(uint256 => bool) public claimedParcels; // tokenid => bool;
2262     uint256[] public claimedParcelList;
2263     bool public isMinting = false;
2264     bytes32 root = 0x693320d25c96ad8361f549355d64b8d50cb5fe25fee5f890c9267e6750fc7d90;
2265 
2266 
2267     constructor() ERC721A("The Blinkless: Grimlets", "BLNKGR") {}
2268 
2269      /*
2270     * Ensures the caller is not a proxy contract or bot, but is an actual wallet.
2271     */
2272     modifier callerIsUser() {
2273         //we only want to mint to real people
2274         require(tx.origin == msg.sender, "The caller is another contract");
2275         _;
2276     }
2277 
2278 
2279     /*
2280     * Verifies the parcel count supplied from metadata is accurate
2281     */
2282     function verifyParcelCount(bytes32[] memory proof, bytes32 leaf) public view returns (bool){
2283         return MerkleProof.verify(proof,root,leaf);
2284     }
2285 
2286      /**
2287     * Return metadata path
2288     */
2289     function tokenURI(uint tokenId) override(ERC721A) public view returns(string memory _uri){
2290         return string(abi.encodePacked(metadataPath,Strings.toString(tokenId),".json"));
2291     } 
2292     
2293     /**
2294     * Check merkle proof
2295     */
2296     function checkClaimedParcels() public view returns(uint[] memory claimedTokenIds){
2297         return claimedParcelList;
2298     }
2299 
2300     /**
2301     * Claim eggs from frontier parcel
2302     */
2303     function mint(uint frontierTokenId, bytes32[] memory proof) public payable callerIsUser{
2304         //check mint status
2305         require(isMinting, "Mint disabled.");
2306 
2307         //limit supply
2308         require(totalSupply() < maxSupply,"Too many");
2309 
2310         //check frontier not already claimed against
2311         require(claimedParcels[frontierTokenId] != true, "Frontier already claimed against!");
2312 
2313         //verify frontier has egg
2314         require(verifyParcelCount(proof,keccak256(abi.encodePacked(Frontiers(payable(frontiersContract)).tokenList(frontierTokenId)))), "Parcel does not have egg!");
2315 
2316         //check frontier ownership
2317         require(IERC721A(frontiersContract).ownerOf(frontierTokenId) == msg.sender, "You can only claim from an egg you own.");
2318 
2319 
2320         //mark parcel as claimed
2321         claimedParcels[frontierTokenId] = true;
2322         claimedParcelList.push(frontierTokenId);
2323 
2324         //transfer optix for mint (must have approval already!)
2325         IERC20(optixContract).transferFrom(msg.sender,address(optixReceiver),optixMintPrice);
2326 
2327         //mint those eggs!
2328         if(totalSupply() < 1738){ //first 420 eggs get 3
2329             _mint(address(msg.sender),3);
2330         } else {
2331             _mint(address(msg.sender),2);
2332         }
2333     }
2334 
2335     /*
2336     * Contract owner can mint
2337     */
2338     function ownerMint(uint256 _amount) public onlyOwner{
2339         require(totalSupply() + _amount <= maxSupply,"Too many");
2340         _mint(address(projectWallet),_amount);
2341     }
2342 
2343      /*
2344     * Contract owner can mint
2345     */
2346     function teamMint() public onlyOwner{
2347         require(totalSupply() + 478 <= maxSupply,"Too many");
2348         _mint(address(projectWallet), 300); //prizes
2349         _mint(address(0x93661f17f56314A62025d788088f71Ff8c0756b5), 89); //digi
2350         _mint(address(0xc114F6181f0c90c07BfA3DEB1F19b4B50f3FA884), 89); //elgallo
2351     }
2352 
2353     /*
2354     * Update mint status
2355     */
2356     function updateIsMinting(bool _isMinting) external onlyOwner{
2357         isMinting = _isMinting;
2358     }
2359 
2360 
2361 
2362      /**
2363     * Update the optix mint price per egg
2364     */
2365     function updateOptixMintPrice(uint256 _price) public onlyOwner{
2366         optixMintPrice = _price;
2367     }
2368 
2369      /**
2370     * Update the optix contract
2371     */
2372     function updateOptixContract(address _contract) public onlyOwner{
2373         optixContract = _contract;
2374     }
2375 
2376      /**
2377     * Update the optix contract
2378     */
2379     function updateFrontiersContract(address _contract) public onlyOwner{
2380         frontiersContract = _contract;
2381     }
2382 
2383      /**
2384     * Update the metadata path
2385     */
2386     function updateMetadataPath(string memory _path) public onlyOwner{
2387         metadataPath = _path;
2388     }
2389 
2390      /**
2391     * Update the merkle root
2392     */
2393     function updateRoot(bytes32 _root) public onlyOwner{
2394         root = _root;
2395     }
2396 
2397     /**
2398     * Update the project wallet address
2399     */
2400     function updateProjectWallet(address _projectWallet) public onlyOwner{
2401         projectWallet = _projectWallet;
2402     }
2403 
2404      /**
2405     * Update the optix receiver address
2406     */
2407      function updateOptixReceiver(address _address) public onlyOwner{
2408         optixReceiver = _address;
2409     }
2410 
2411     /**
2412     * Update the payout wallet address
2413     */
2414     function updatePayoutWallet(address _payoutWallet) public onlyOwner{
2415         payoutWallet = _payoutWallet;
2416     }
2417 
2418      /*
2419     * Withdraw by owner
2420     */
2421     function withdraw() external onlyOwner {
2422         (bool success, ) = payable(payoutWallet).call{value: address(this).balance}("");
2423         require(success, "Transfer failed.");
2424     }
2425 
2426 
2427     /*
2428     * These are here to receive ETH sent to the contract address
2429     */
2430     receive() external payable {}
2431 
2432     fallback() external payable {}
2433 
2434 
2435 }