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
216 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
217 
218 
219 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev Interface of the ERC20 standard as defined in the EIP.
225  */
226 interface IERC20 {
227     /**
228      * @dev Emitted when `value` tokens are moved from one account (`from`) to
229      * another (`to`).
230      *
231      * Note that `value` may be zero.
232      */
233     event Transfer(address indexed from, address indexed to, uint256 value);
234 
235     /**
236      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
237      * a call to {approve}. `value` is the new allowance.
238      */
239     event Approval(address indexed owner, address indexed spender, uint256 value);
240 
241     /**
242      * @dev Returns the amount of tokens in existence.
243      */
244     function totalSupply() external view returns (uint256);
245 
246     /**
247      * @dev Returns the amount of tokens owned by `account`.
248      */
249     function balanceOf(address account) external view returns (uint256);
250 
251     /**
252      * @dev Moves `amount` tokens from the caller's account to `to`.
253      *
254      * Returns a boolean value indicating whether the operation succeeded.
255      *
256      * Emits a {Transfer} event.
257      */
258     function transfer(address to, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Returns the remaining number of tokens that `spender` will be
262      * allowed to spend on behalf of `owner` through {transferFrom}. This is
263      * zero by default.
264      *
265      * This value changes when {approve} or {transferFrom} are called.
266      */
267     function allowance(address owner, address spender) external view returns (uint256);
268 
269     /**
270      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
271      *
272      * Returns a boolean value indicating whether the operation succeeded.
273      *
274      * IMPORTANT: Beware that changing an allowance with this method brings the risk
275      * that someone may use both the old and the new allowance by unfortunate
276      * transaction ordering. One possible solution to mitigate this race
277      * condition is to first reduce the spender's allowance to 0 and set the
278      * desired value afterwards:
279      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
280      *
281      * Emits an {Approval} event.
282      */
283     function approve(address spender, uint256 amount) external returns (bool);
284 
285     /**
286      * @dev Moves `amount` tokens from `from` to `to` using the
287      * allowance mechanism. `amount` is then deducted from the caller's
288      * allowance.
289      *
290      * Returns a boolean value indicating whether the operation succeeded.
291      *
292      * Emits a {Transfer} event.
293      */
294     function transferFrom(
295         address from,
296         address to,
297         uint256 amount
298     ) external returns (bool);
299 }
300 
301 // File: contracts/IERC721A.sol
302 
303 
304 // ERC721A Contracts v4.2.3
305 // Creator: Chiru Labs
306 
307 pragma solidity ^0.8.4;
308 
309 /**
310  * @dev Interface of ERC721A.
311  */
312 interface IERC721A {
313     /**
314      * The caller must own the token or be an approved operator.
315      */
316     error ApprovalCallerNotOwnerNorApproved();
317 
318     /**
319      * The token does not exist.
320      */
321     error ApprovalQueryForNonexistentToken();
322 
323     /**
324      * Cannot query the balance for the zero address.
325      */
326     error BalanceQueryForZeroAddress();
327 
328     /**
329      * Cannot mint to the zero address.
330      */
331     error MintToZeroAddress();
332 
333     /**
334      * The quantity of tokens minted must be more than zero.
335      */
336     error MintZeroQuantity();
337 
338     /**
339      * The token does not exist.
340      */
341     error OwnerQueryForNonexistentToken();
342 
343     /**
344      * The caller must own the token or be an approved operator.
345      */
346     error TransferCallerNotOwnerNorApproved();
347 
348     /**
349      * The token must be owned by `from`.
350      */
351     error TransferFromIncorrectOwner();
352 
353     /**
354      * Cannot safely transfer to a contract that does not implement the
355      * ERC721Receiver interface.
356      */
357     error TransferToNonERC721ReceiverImplementer();
358 
359     /**
360      * Cannot transfer to the zero address.
361      */
362     error TransferToZeroAddress();
363 
364     /**
365      * The token does not exist.
366      */
367     error URIQueryForNonexistentToken();
368 
369     /**
370      * The `quantity` minted with ERC2309 exceeds the safety limit.
371      */
372     error MintERC2309QuantityExceedsLimit();
373 
374     /**
375      * The `extraData` cannot be set on an unintialized ownership slot.
376      */
377     error OwnershipNotInitializedForExtraData();
378 
379     // =============================================================
380     //                            STRUCTS
381     // =============================================================
382 
383     struct TokenOwnership {
384         // The address of the owner.
385         address addr;
386         // Stores the start time of ownership with minimal overhead for tokenomics.
387         uint64 startTimestamp;
388         // Whether the token has been burned.
389         bool burned;
390         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
391         uint24 extraData;
392     }
393 
394     // =============================================================
395     //                         TOKEN COUNTERS
396     // =============================================================
397 
398     /**
399      * @dev Returns the total number of tokens in existence.
400      * Burned tokens will reduce the count.
401      * To get the total number of tokens minted, please see {_totalMinted}.
402      */
403     function totalSupply() external view returns (uint256);
404 
405     // =============================================================
406     //                            IERC165
407     // =============================================================
408 
409     /**
410      * @dev Returns true if this contract implements the interface defined by
411      * `interfaceId`. See the corresponding
412      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
413      * to learn more about how these ids are created.
414      *
415      * This function call must use less than 30000 gas.
416      */
417     function supportsInterface(bytes4 interfaceId) external view returns (bool);
418 
419     // =============================================================
420     //                            IERC721
421     // =============================================================
422 
423     /**
424      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
425      */
426     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
427 
428     /**
429      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
430      */
431     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
432 
433     /**
434      * @dev Emitted when `owner` enables or disables
435      * (`approved`) `operator` to manage all of its assets.
436      */
437     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
438 
439     /**
440      * @dev Returns the number of tokens in `owner`'s account.
441      */
442     function balanceOf(address owner) external view returns (uint256 balance);
443 
444     /**
445      * @dev Returns the owner of the `tokenId` token.
446      *
447      * Requirements:
448      *
449      * - `tokenId` must exist.
450      */
451     function ownerOf(uint256 tokenId) external view returns (address owner);
452 
453     /**
454      * @dev Safely transfers `tokenId` token from `from` to `to`,
455      * checking first that contract recipients are aware of the ERC721 protocol
456      * to prevent tokens from being forever locked.
457      *
458      * Requirements:
459      *
460      * - `from` cannot be the zero address.
461      * - `to` cannot be the zero address.
462      * - `tokenId` token must exist and be owned by `from`.
463      * - If the caller is not `from`, it must be have been allowed to move
464      * this token by either {approve} or {setApprovalForAll}.
465      * - If `to` refers to a smart contract, it must implement
466      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
467      *
468      * Emits a {Transfer} event.
469      */
470     function safeTransferFrom(
471         address from,
472         address to,
473         uint256 tokenId,
474         bytes calldata data
475     ) external payable;
476 
477     /**
478      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
479      */
480     function safeTransferFrom(
481         address from,
482         address to,
483         uint256 tokenId
484     ) external payable;
485 
486     /**
487      * @dev Transfers `tokenId` from `from` to `to`.
488      *
489      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
490      * whenever possible.
491      *
492      * Requirements:
493      *
494      * - `from` cannot be the zero address.
495      * - `to` cannot be the zero address.
496      * - `tokenId` token must be owned by `from`.
497      * - If the caller is not `from`, it must be approved to move this token
498      * by either {approve} or {setApprovalForAll}.
499      *
500      * Emits a {Transfer} event.
501      */
502     function transferFrom(
503         address from,
504         address to,
505         uint256 tokenId
506     ) external payable;
507 
508     /**
509      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
510      * The approval is cleared when the token is transferred.
511      *
512      * Only a single account can be approved at a time, so approving the
513      * zero address clears previous approvals.
514      *
515      * Requirements:
516      *
517      * - The caller must own the token or be an approved operator.
518      * - `tokenId` must exist.
519      *
520      * Emits an {Approval} event.
521      */
522     function approve(address to, uint256 tokenId) external payable;
523 
524     /**
525      * @dev Approve or remove `operator` as an operator for the caller.
526      * Operators can call {transferFrom} or {safeTransferFrom}
527      * for any token owned by the caller.
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
549      * See {setApprovalForAll}.
550      */
551     function isApprovedForAll(address owner, address operator) external view returns (bool);
552 
553     // =============================================================
554     //                        IERC721Metadata
555     // =============================================================
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
571 
572     // =============================================================
573     //                           IERC2309
574     // =============================================================
575 
576     /**
577      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
578      * (inclusive) is transferred from `from` to `to`, as defined in the
579      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
580      *
581      * See {_mintERC2309} for more details.
582      */
583     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
584 }
585 // File: contracts/IERC721AQueryable.sol
586 
587 
588 // ERC721A Contracts v4.2.3
589 // Creator: Chiru Labs
590 
591 pragma solidity ^0.8.4;
592 
593 
594 /**
595  * @dev Interface of ERC721AQueryable.
596  */
597 interface IERC721AQueryable is IERC721A {
598     /**
599      * Invalid query range (`start` >= `stop`).
600      */
601     error InvalidQueryRange();
602 
603     /**
604      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
605      *
606      * If the `tokenId` is out of bounds:
607      *
608      * - `addr = address(0)`
609      * - `startTimestamp = 0`
610      * - `burned = false`
611      * - `extraData = 0`
612      *
613      * If the `tokenId` is burned:
614      *
615      * - `addr = <Address of owner before token was burned>`
616      * - `startTimestamp = <Timestamp when token was burned>`
617      * - `burned = true`
618      * - `extraData = <Extra data when token was burned>`
619      *
620      * Otherwise:
621      *
622      * - `addr = <Address of owner>`
623      * - `startTimestamp = <Timestamp of start of ownership>`
624      * - `burned = false`
625      * - `extraData = <Extra data at start of ownership>`
626      */
627     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
628 
629     /**
630      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
631      * See {ERC721AQueryable-explicitOwnershipOf}
632      */
633     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
634 
635     /**
636      * @dev Returns an array of token IDs owned by `owner`,
637      * in the range [`start`, `stop`)
638      * (i.e. `start <= tokenId < stop`).
639      *
640      * This function allows for tokens to be queried if the collection
641      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
642      *
643      * Requirements:
644      *
645      * - `start < stop`
646      */
647     function tokensOfOwnerIn(
648         address owner,
649         uint256 start,
650         uint256 stop
651     ) external view returns (uint256[] memory);
652 
653     /**
654      * @dev Returns an array of token IDs owned by `owner`.
655      *
656      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
657      * It is meant to be called off-chain.
658      *
659      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
660      * multiple smaller scans if the collection is large enough to cause
661      * an out-of-gas error (10K collections should be fine).
662      */
663     function tokensOfOwner(address owner) external view returns (uint256[] memory);
664 }
665 // File: contracts/ERC721A.sol
666 
667 
668 // ERC721A Contracts v4.2.3
669 // Creator: Chiru Labs
670 
671 pragma solidity ^0.8.4;
672 
673 
674 /**
675  * @dev Interface of ERC721 token receiver.
676  */
677 interface ERC721A__IERC721Receiver {
678     function onERC721Received(
679         address operator,
680         address from,
681         uint256 tokenId,
682         bytes calldata data
683     ) external returns (bytes4);
684 }
685 
686 /**
687  * @title ERC721A
688  *
689  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
690  * Non-Fungible Token Standard, including the Metadata extension.
691  * Optimized for lower gas during batch mints.
692  *
693  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
694  * starting from `_startTokenId()`.
695  *
696  * Assumptions:
697  *
698  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
699  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
700  */
701 contract ERC721A is IERC721A {
702     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
703     struct TokenApprovalRef {
704         address value;
705     }
706 
707     // =============================================================
708     //                           CONSTANTS
709     // =============================================================
710 
711     // Mask of an entry in packed address data.
712     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
713 
714     // The bit position of `numberMinted` in packed address data.
715     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
716 
717     // The bit position of `numberBurned` in packed address data.
718     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
719 
720     // The bit position of `aux` in packed address data.
721     uint256 private constant _BITPOS_AUX = 192;
722 
723     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
724     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
725 
726     // The bit position of `startTimestamp` in packed ownership.
727     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
728 
729     // The bit mask of the `burned` bit in packed ownership.
730     uint256 private constant _BITMASK_BURNED = 1 << 224;
731 
732     // The bit position of the `nextInitialized` bit in packed ownership.
733     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
734 
735     // The bit mask of the `nextInitialized` bit in packed ownership.
736     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
737 
738     // The bit position of `extraData` in packed ownership.
739     uint256 private constant _BITPOS_EXTRA_DATA = 232;
740 
741     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
742     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
743 
744     // The mask of the lower 160 bits for addresses.
745     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
746 
747     // The maximum `quantity` that can be minted with {_mintERC2309}.
748     // This limit is to prevent overflows on the address data entries.
749     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
750     // is required to cause an overflow, which is unrealistic.
751     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
752 
753     // The `Transfer` event signature is given by:
754     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
755     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
756         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
757 
758     // =============================================================
759     //                            STORAGE
760     // =============================================================
761 
762     // The next token ID to be minted.
763     uint256 private _currentIndex;
764 
765     // The number of tokens burned.
766     uint256 private _burnCounter;
767 
768     // Token name
769     string private _name;
770 
771     // Token symbol
772     string private _symbol;
773 
774     // Mapping from token ID to ownership details
775     // An empty struct value does not necessarily mean the token is unowned.
776     // See {_packedOwnershipOf} implementation for details.
777     //
778     // Bits Layout:
779     // - [0..159]   `addr`
780     // - [160..223] `startTimestamp`
781     // - [224]      `burned`
782     // - [225]      `nextInitialized`
783     // - [232..255] `extraData`
784     mapping(uint256 => uint256) private _packedOwnerships;
785 
786     // Mapping owner address to address data.
787     //
788     // Bits Layout:
789     // - [0..63]    `balance`
790     // - [64..127]  `numberMinted`
791     // - [128..191] `numberBurned`
792     // - [192..255] `aux`
793     mapping(address => uint256) private _packedAddressData;
794 
795     // Mapping from token ID to approved address.
796     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
797 
798     // Mapping from owner to operator approvals
799     mapping(address => mapping(address => bool)) private _operatorApprovals;
800 
801     // =============================================================
802     //                          CONSTRUCTOR
803     // =============================================================
804 
805     constructor(string memory name_, string memory symbol_) {
806         _name = name_;
807         _symbol = symbol_;
808         _currentIndex = _startTokenId();
809     }
810 
811     // =============================================================
812     //                   TOKEN COUNTING OPERATIONS
813     // =============================================================
814 
815     /**
816      * @dev Returns the starting token ID.
817      * To change the starting token ID, please override this function.
818      */
819     function _startTokenId() internal view virtual returns (uint256) {
820         return 0;
821     }
822 
823     /**
824      * @dev Returns the next token ID to be minted.
825      */
826     function _nextTokenId() internal view virtual returns (uint256) {
827         return _currentIndex;
828     }
829 
830     /**
831      * @dev Returns the total number of tokens in existence.
832      * Burned tokens will reduce the count.
833      * To get the total number of tokens minted, please see {_totalMinted}.
834      */
835     function totalSupply() public view virtual override returns (uint256) {
836         // Counter underflow is impossible as _burnCounter cannot be incremented
837         // more than `_currentIndex - _startTokenId()` times.
838         unchecked {
839             return _currentIndex - _burnCounter - _startTokenId();
840         }
841     }
842 
843     /**
844      * @dev Returns the total amount of tokens minted in the contract.
845      */
846     function _totalMinted() internal view virtual returns (uint256) {
847         // Counter underflow is impossible as `_currentIndex` does not decrement,
848         // and it is initialized to `_startTokenId()`.
849         unchecked {
850             return _currentIndex - _startTokenId();
851         }
852     }
853 
854     /**
855      * @dev Returns the total number of tokens burned.
856      */
857     function _totalBurned() internal view virtual returns (uint256) {
858         return _burnCounter;
859     }
860 
861     // =============================================================
862     //                    ADDRESS DATA OPERATIONS
863     // =============================================================
864 
865     /**
866      * @dev Returns the number of tokens in `owner`'s account.
867      */
868     function balanceOf(address owner) public view virtual override returns (uint256) {
869         if (owner == address(0)) revert BalanceQueryForZeroAddress();
870         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
871     }
872 
873     /**
874      * Returns the number of tokens minted by `owner`.
875      */
876     function _numberMinted(address owner) internal view returns (uint256) {
877         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
878     }
879 
880     /**
881      * Returns the number of tokens burned by or on behalf of `owner`.
882      */
883     function _numberBurned(address owner) internal view returns (uint256) {
884         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
885     }
886 
887     /**
888      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
889      */
890     function _getAux(address owner) internal view returns (uint64) {
891         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
892     }
893 
894     /**
895      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
896      * If there are multiple variables, please pack them into a uint64.
897      */
898     function _setAux(address owner, uint64 aux) internal virtual {
899         uint256 packed = _packedAddressData[owner];
900         uint256 auxCasted;
901         // Cast `aux` with assembly to avoid redundant masking.
902         assembly {
903             auxCasted := aux
904         }
905         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
906         _packedAddressData[owner] = packed;
907     }
908 
909     // =============================================================
910     //                            IERC165
911     // =============================================================
912 
913     /**
914      * @dev Returns true if this contract implements the interface defined by
915      * `interfaceId`. See the corresponding
916      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
917      * to learn more about how these ids are created.
918      *
919      * This function call must use less than 30000 gas.
920      */
921     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
922         // The interface IDs are constants representing the first 4 bytes
923         // of the XOR of all function selectors in the interface.
924         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
925         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
926         return
927             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
928             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
929             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
930     }
931 
932     // =============================================================
933     //                        IERC721Metadata
934     // =============================================================
935 
936     /**
937      * @dev Returns the token collection name.
938      */
939     function name() public view virtual override returns (string memory) {
940         return _name;
941     }
942 
943     /**
944      * @dev Returns the token collection symbol.
945      */
946     function symbol() public view virtual override returns (string memory) {
947         return _symbol;
948     }
949 
950     /**
951      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
952      */
953     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
954         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
955 
956         string memory baseURI = _baseURI();
957         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
958     }
959 
960     /**
961      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
962      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
963      * by default, it can be overridden in child contracts.
964      */
965     function _baseURI() internal view virtual returns (string memory) {
966         return '';
967     }
968 
969     // =============================================================
970     //                     OWNERSHIPS OPERATIONS
971     // =============================================================
972 
973     /**
974      * @dev Returns the owner of the `tokenId` token.
975      *
976      * Requirements:
977      *
978      * - `tokenId` must exist.
979      */
980     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
981         return address(uint160(_packedOwnershipOf(tokenId)));
982     }
983 
984     /**
985      * @dev Gas spent here starts off proportional to the maximum mint batch size.
986      * It gradually moves to O(1) as tokens get transferred around over time.
987      */
988     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
989         return _unpackedOwnership(_packedOwnershipOf(tokenId));
990     }
991 
992     /**
993      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
994      */
995     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
996         return _unpackedOwnership(_packedOwnerships[index]);
997     }
998 
999     /**
1000      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1001      */
1002     function _initializeOwnershipAt(uint256 index) internal virtual {
1003         if (_packedOwnerships[index] == 0) {
1004             _packedOwnerships[index] = _packedOwnershipOf(index);
1005         }
1006     }
1007 
1008     /**
1009      * Returns the packed ownership data of `tokenId`.
1010      */
1011     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1012         uint256 curr = tokenId;
1013 
1014         unchecked {
1015             if (_startTokenId() <= curr)
1016                 if (curr < _currentIndex) {
1017                     uint256 packed = _packedOwnerships[curr];
1018                     // If not burned.
1019                     if (packed & _BITMASK_BURNED == 0) {
1020                         // Invariant:
1021                         // There will always be an initialized ownership slot
1022                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1023                         // before an unintialized ownership slot
1024                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1025                         // Hence, `curr` will not underflow.
1026                         //
1027                         // We can directly compare the packed value.
1028                         // If the address is zero, packed will be zero.
1029                         while (packed == 0) {
1030                             packed = _packedOwnerships[--curr];
1031                         }
1032                         return packed;
1033                     }
1034                 }
1035         }
1036         revert OwnerQueryForNonexistentToken();
1037     }
1038 
1039     /**
1040      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1041      */
1042     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1043         ownership.addr = address(uint160(packed));
1044         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1045         ownership.burned = packed & _BITMASK_BURNED != 0;
1046         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1047     }
1048 
1049     /**
1050      * @dev Packs ownership data into a single uint256.
1051      */
1052     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1053         assembly {
1054             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1055             owner := and(owner, _BITMASK_ADDRESS)
1056             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1057             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1058         }
1059     }
1060 
1061     /**
1062      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1063      */
1064     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1065         // For branchless setting of the `nextInitialized` flag.
1066         assembly {
1067             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1068             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1069         }
1070     }
1071 
1072     // =============================================================
1073     //                      APPROVAL OPERATIONS
1074     // =============================================================
1075 
1076     /**
1077      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1078      * The approval is cleared when the token is transferred.
1079      *
1080      * Only a single account can be approved at a time, so approving the
1081      * zero address clears previous approvals.
1082      *
1083      * Requirements:
1084      *
1085      * - The caller must own the token or be an approved operator.
1086      * - `tokenId` must exist.
1087      *
1088      * Emits an {Approval} event.
1089      */
1090     function approve(address to, uint256 tokenId) public payable virtual override {
1091         address owner = ownerOf(tokenId);
1092 
1093         if (_msgSenderERC721A() != owner)
1094             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1095                 revert ApprovalCallerNotOwnerNorApproved();
1096             }
1097 
1098         _tokenApprovals[tokenId].value = to;
1099         emit Approval(owner, to, tokenId);
1100     }
1101 
1102     /**
1103      * @dev Returns the account approved for `tokenId` token.
1104      *
1105      * Requirements:
1106      *
1107      * - `tokenId` must exist.
1108      */
1109     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1110         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1111 
1112         return _tokenApprovals[tokenId].value;
1113     }
1114 
1115     /**
1116      * @dev Approve or remove `operator` as an operator for the caller.
1117      * Operators can call {transferFrom} or {safeTransferFrom}
1118      * for any token owned by the caller.
1119      *
1120      * Requirements:
1121      *
1122      * - The `operator` cannot be the caller.
1123      *
1124      * Emits an {ApprovalForAll} event.
1125      */
1126     function setApprovalForAll(address operator, bool approved) public virtual override {
1127         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1128         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1129     }
1130 
1131     /**
1132      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1133      *
1134      * See {setApprovalForAll}.
1135      */
1136     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1137         return _operatorApprovals[owner][operator];
1138     }
1139 
1140     /**
1141      * @dev Returns whether `tokenId` exists.
1142      *
1143      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1144      *
1145      * Tokens start existing when they are minted. See {_mint}.
1146      */
1147     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1148         return
1149             _startTokenId() <= tokenId &&
1150             tokenId < _currentIndex && // If within bounds,
1151             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1152     }
1153 
1154     /**
1155      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1156      */
1157     function _isSenderApprovedOrOwner(
1158         address approvedAddress,
1159         address owner,
1160         address msgSender
1161     ) private pure returns (bool result) {
1162         assembly {
1163             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1164             owner := and(owner, _BITMASK_ADDRESS)
1165             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1166             msgSender := and(msgSender, _BITMASK_ADDRESS)
1167             // `msgSender == owner || msgSender == approvedAddress`.
1168             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1169         }
1170     }
1171 
1172     /**
1173      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1174      */
1175     function _getApprovedSlotAndAddress(uint256 tokenId)
1176         private
1177         view
1178         returns (uint256 approvedAddressSlot, address approvedAddress)
1179     {
1180         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1181         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1182         assembly {
1183             approvedAddressSlot := tokenApproval.slot
1184             approvedAddress := sload(approvedAddressSlot)
1185         }
1186     }
1187 
1188     // =============================================================
1189     //                      TRANSFER OPERATIONS
1190     // =============================================================
1191 
1192     /**
1193      * @dev Transfers `tokenId` from `from` to `to`.
1194      *
1195      * Requirements:
1196      *
1197      * - `from` cannot be the zero address.
1198      * - `to` cannot be the zero address.
1199      * - `tokenId` token must be owned by `from`.
1200      * - If the caller is not `from`, it must be approved to move this token
1201      * by either {approve} or {setApprovalForAll}.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function transferFrom(
1206         address from,
1207         address to,
1208         uint256 tokenId
1209     ) public payable virtual override {
1210         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1211 
1212         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1213 
1214         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1215 
1216         // The nested ifs save around 20+ gas over a compound boolean condition.
1217         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1218             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1219 
1220         if (to == address(0)) revert TransferToZeroAddress();
1221 
1222         _beforeTokenTransfers(from, to, tokenId, 1);
1223 
1224         // Clear approvals from the previous owner.
1225         assembly {
1226             if approvedAddress {
1227                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1228                 sstore(approvedAddressSlot, 0)
1229             }
1230         }
1231 
1232         // Underflow of the sender's balance is impossible because we check for
1233         // ownership above and the recipient's balance can't realistically overflow.
1234         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1235         unchecked {
1236             // We can directly increment and decrement the balances.
1237             --_packedAddressData[from]; // Updates: `balance -= 1`.
1238             ++_packedAddressData[to]; // Updates: `balance += 1`.
1239 
1240             // Updates:
1241             // - `address` to the next owner.
1242             // - `startTimestamp` to the timestamp of transfering.
1243             // - `burned` to `false`.
1244             // - `nextInitialized` to `true`.
1245             _packedOwnerships[tokenId] = _packOwnershipData(
1246                 to,
1247                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1248             );
1249 
1250             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1251             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1252                 uint256 nextTokenId = tokenId + 1;
1253                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1254                 if (_packedOwnerships[nextTokenId] == 0) {
1255                     // If the next slot is within bounds.
1256                     if (nextTokenId != _currentIndex) {
1257                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1258                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1259                     }
1260                 }
1261             }
1262         }
1263 
1264         emit Transfer(from, to, tokenId);
1265         _afterTokenTransfers(from, to, tokenId, 1);
1266     }
1267 
1268     /**
1269      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1270      */
1271     function safeTransferFrom(
1272         address from,
1273         address to,
1274         uint256 tokenId
1275     ) public payable virtual override {
1276         safeTransferFrom(from, to, tokenId, '');
1277     }
1278 
1279     /**
1280      * @dev Safely transfers `tokenId` token from `from` to `to`.
1281      *
1282      * Requirements:
1283      *
1284      * - `from` cannot be the zero address.
1285      * - `to` cannot be the zero address.
1286      * - `tokenId` token must exist and be owned by `from`.
1287      * - If the caller is not `from`, it must be approved to move this token
1288      * by either {approve} or {setApprovalForAll}.
1289      * - If `to` refers to a smart contract, it must implement
1290      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1291      *
1292      * Emits a {Transfer} event.
1293      */
1294     function safeTransferFrom(
1295         address from,
1296         address to,
1297         uint256 tokenId,
1298         bytes memory _data
1299     ) public payable virtual override {
1300         transferFrom(from, to, tokenId);
1301         if (to.code.length != 0)
1302             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1303                 revert TransferToNonERC721ReceiverImplementer();
1304             }
1305     }
1306 
1307     /**
1308      * @dev Hook that is called before a set of serially-ordered token IDs
1309      * are about to be transferred. This includes minting.
1310      * And also called before burning one token.
1311      *
1312      * `startTokenId` - the first token ID to be transferred.
1313      * `quantity` - the amount to be transferred.
1314      *
1315      * Calling conditions:
1316      *
1317      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1318      * transferred to `to`.
1319      * - When `from` is zero, `tokenId` will be minted for `to`.
1320      * - When `to` is zero, `tokenId` will be burned by `from`.
1321      * - `from` and `to` are never both zero.
1322      */
1323     function _beforeTokenTransfers(
1324         address from,
1325         address to,
1326         uint256 startTokenId,
1327         uint256 quantity
1328     ) internal virtual {}
1329 
1330     /**
1331      * @dev Hook that is called after a set of serially-ordered token IDs
1332      * have been transferred. This includes minting.
1333      * And also called after one token has been burned.
1334      *
1335      * `startTokenId` - the first token ID to be transferred.
1336      * `quantity` - the amount to be transferred.
1337      *
1338      * Calling conditions:
1339      *
1340      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1341      * transferred to `to`.
1342      * - When `from` is zero, `tokenId` has been minted for `to`.
1343      * - When `to` is zero, `tokenId` has been burned by `from`.
1344      * - `from` and `to` are never both zero.
1345      */
1346     function _afterTokenTransfers(
1347         address from,
1348         address to,
1349         uint256 startTokenId,
1350         uint256 quantity
1351     ) internal virtual {}
1352 
1353     /**
1354      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1355      *
1356      * `from` - Previous owner of the given token ID.
1357      * `to` - Target address that will receive the token.
1358      * `tokenId` - Token ID to be transferred.
1359      * `_data` - Optional data to send along with the call.
1360      *
1361      * Returns whether the call correctly returned the expected magic value.
1362      */
1363     function _checkContractOnERC721Received(
1364         address from,
1365         address to,
1366         uint256 tokenId,
1367         bytes memory _data
1368     ) private returns (bool) {
1369         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1370             bytes4 retval
1371         ) {
1372             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1373         } catch (bytes memory reason) {
1374             if (reason.length == 0) {
1375                 revert TransferToNonERC721ReceiverImplementer();
1376             } else {
1377                 assembly {
1378                     revert(add(32, reason), mload(reason))
1379                 }
1380             }
1381         }
1382     }
1383 
1384     // =============================================================
1385     //                        MINT OPERATIONS
1386     // =============================================================
1387 
1388     /**
1389      * @dev Mints `quantity` tokens and transfers them to `to`.
1390      *
1391      * Requirements:
1392      *
1393      * - `to` cannot be the zero address.
1394      * - `quantity` must be greater than 0.
1395      *
1396      * Emits a {Transfer} event for each mint.
1397      */
1398     function _mint(address to, uint256 quantity) internal virtual {
1399         uint256 startTokenId = _currentIndex;
1400         if (quantity == 0) revert MintZeroQuantity();
1401 
1402         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1403 
1404         // Overflows are incredibly unrealistic.
1405         // `balance` and `numberMinted` have a maximum limit of 2**64.
1406         // `tokenId` has a maximum limit of 2**256.
1407         unchecked {
1408             // Updates:
1409             // - `balance += quantity`.
1410             // - `numberMinted += quantity`.
1411             //
1412             // We can directly add to the `balance` and `numberMinted`.
1413             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1414 
1415             // Updates:
1416             // - `address` to the owner.
1417             // - `startTimestamp` to the timestamp of minting.
1418             // - `burned` to `false`.
1419             // - `nextInitialized` to `quantity == 1`.
1420             _packedOwnerships[startTokenId] = _packOwnershipData(
1421                 to,
1422                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1423             );
1424 
1425             uint256 toMasked;
1426             uint256 end = startTokenId + quantity;
1427 
1428             // Use assembly to loop and emit the `Transfer` event for gas savings.
1429             // The duplicated `log4` removes an extra check and reduces stack juggling.
1430             // The assembly, together with the surrounding Solidity code, have been
1431             // delicately arranged to nudge the compiler into producing optimized opcodes.
1432             assembly {
1433                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1434                 toMasked := and(to, _BITMASK_ADDRESS)
1435                 // Emit the `Transfer` event.
1436                 log4(
1437                     0, // Start of data (0, since no data).
1438                     0, // End of data (0, since no data).
1439                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1440                     0, // `address(0)`.
1441                     toMasked, // `to`.
1442                     startTokenId // `tokenId`.
1443                 )
1444 
1445                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1446                 // that overflows uint256 will make the loop run out of gas.
1447                 // The compiler will optimize the `iszero` away for performance.
1448                 for {
1449                     let tokenId := add(startTokenId, 1)
1450                 } iszero(eq(tokenId, end)) {
1451                     tokenId := add(tokenId, 1)
1452                 } {
1453                     // Emit the `Transfer` event. Similar to above.
1454                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1455                 }
1456             }
1457             if (toMasked == 0) revert MintToZeroAddress();
1458 
1459             _currentIndex = end;
1460         }
1461         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1462     }
1463 
1464     /**
1465      * @dev Mints `quantity` tokens and transfers them to `to`.
1466      *
1467      * This function is intended for efficient minting only during contract creation.
1468      *
1469      * It emits only one {ConsecutiveTransfer} as defined in
1470      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1471      * instead of a sequence of {Transfer} event(s).
1472      *
1473      * Calling this function outside of contract creation WILL make your contract
1474      * non-compliant with the ERC721 standard.
1475      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1476      * {ConsecutiveTransfer} event is only permissible during contract creation.
1477      *
1478      * Requirements:
1479      *
1480      * - `to` cannot be the zero address.
1481      * - `quantity` must be greater than 0.
1482      *
1483      * Emits a {ConsecutiveTransfer} event.
1484      */
1485     function _mintERC2309(address to, uint256 quantity) internal virtual {
1486         uint256 startTokenId = _currentIndex;
1487         if (to == address(0)) revert MintToZeroAddress();
1488         if (quantity == 0) revert MintZeroQuantity();
1489         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1490 
1491         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1492 
1493         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1494         unchecked {
1495             // Updates:
1496             // - `balance += quantity`.
1497             // - `numberMinted += quantity`.
1498             //
1499             // We can directly add to the `balance` and `numberMinted`.
1500             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1501 
1502             // Updates:
1503             // - `address` to the owner.
1504             // - `startTimestamp` to the timestamp of minting.
1505             // - `burned` to `false`.
1506             // - `nextInitialized` to `quantity == 1`.
1507             _packedOwnerships[startTokenId] = _packOwnershipData(
1508                 to,
1509                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1510             );
1511 
1512             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1513 
1514             _currentIndex = startTokenId + quantity;
1515         }
1516         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1517     }
1518 
1519     /**
1520      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1521      *
1522      * Requirements:
1523      *
1524      * - If `to` refers to a smart contract, it must implement
1525      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1526      * - `quantity` must be greater than 0.
1527      *
1528      * See {_mint}.
1529      *
1530      * Emits a {Transfer} event for each mint.
1531      */
1532     function _safeMint(
1533         address to,
1534         uint256 quantity,
1535         bytes memory _data
1536     ) internal virtual {
1537         _mint(to, quantity);
1538 
1539         unchecked {
1540             if (to.code.length != 0) {
1541                 uint256 end = _currentIndex;
1542                 uint256 index = end - quantity;
1543                 do {
1544                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1545                         revert TransferToNonERC721ReceiverImplementer();
1546                     }
1547                 } while (index < end);
1548                 // Reentrancy protection.
1549                 if (_currentIndex != end) revert();
1550             }
1551         }
1552     }
1553 
1554     /**
1555      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1556      */
1557     function _safeMint(address to, uint256 quantity) internal virtual {
1558         _safeMint(to, quantity, '');
1559     }
1560 
1561     // =============================================================
1562     //                        BURN OPERATIONS
1563     // =============================================================
1564 
1565     /**
1566      * @dev Equivalent to `_burn(tokenId, false)`.
1567      */
1568     function _burn(uint256 tokenId) internal virtual {
1569         _burn(tokenId, false);
1570     }
1571 
1572     /**
1573      * @dev Destroys `tokenId`.
1574      * The approval is cleared when the token is burned.
1575      *
1576      * Requirements:
1577      *
1578      * - `tokenId` must exist.
1579      *
1580      * Emits a {Transfer} event.
1581      */
1582     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1583         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1584 
1585         address from = address(uint160(prevOwnershipPacked));
1586 
1587         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1588 
1589         if (approvalCheck) {
1590             // The nested ifs save around 20+ gas over a compound boolean condition.
1591             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1592                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1593         }
1594 
1595         _beforeTokenTransfers(from, address(0), tokenId, 1);
1596 
1597         // Clear approvals from the previous owner.
1598         assembly {
1599             if approvedAddress {
1600                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1601                 sstore(approvedAddressSlot, 0)
1602             }
1603         }
1604 
1605         // Underflow of the sender's balance is impossible because we check for
1606         // ownership above and the recipient's balance can't realistically overflow.
1607         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1608         unchecked {
1609             // Updates:
1610             // - `balance -= 1`.
1611             // - `numberBurned += 1`.
1612             //
1613             // We can directly decrement the balance, and increment the number burned.
1614             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1615             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1616 
1617             // Updates:
1618             // - `address` to the last owner.
1619             // - `startTimestamp` to the timestamp of burning.
1620             // - `burned` to `true`.
1621             // - `nextInitialized` to `true`.
1622             _packedOwnerships[tokenId] = _packOwnershipData(
1623                 from,
1624                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1625             );
1626 
1627             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1628             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1629                 uint256 nextTokenId = tokenId + 1;
1630                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1631                 if (_packedOwnerships[nextTokenId] == 0) {
1632                     // If the next slot is within bounds.
1633                     if (nextTokenId != _currentIndex) {
1634                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1635                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1636                     }
1637                 }
1638             }
1639         }
1640 
1641         emit Transfer(from, address(0), tokenId);
1642         _afterTokenTransfers(from, address(0), tokenId, 1);
1643 
1644         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1645         unchecked {
1646             _burnCounter++;
1647         }
1648     }
1649 
1650     // =============================================================
1651     //                     EXTRA DATA OPERATIONS
1652     // =============================================================
1653 
1654     /**
1655      * @dev Directly sets the extra data for the ownership data `index`.
1656      */
1657     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1658         uint256 packed = _packedOwnerships[index];
1659         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1660         uint256 extraDataCasted;
1661         // Cast `extraData` with assembly to avoid redundant masking.
1662         assembly {
1663             extraDataCasted := extraData
1664         }
1665         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1666         _packedOwnerships[index] = packed;
1667     }
1668 
1669     /**
1670      * @dev Called during each token transfer to set the 24bit `extraData` field.
1671      * Intended to be overridden by the cosumer contract.
1672      *
1673      * `previousExtraData` - the value of `extraData` before transfer.
1674      *
1675      * Calling conditions:
1676      *
1677      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1678      * transferred to `to`.
1679      * - When `from` is zero, `tokenId` will be minted for `to`.
1680      * - When `to` is zero, `tokenId` will be burned by `from`.
1681      * - `from` and `to` are never both zero.
1682      */
1683     function _extraData(
1684         address from,
1685         address to,
1686         uint24 previousExtraData
1687     ) internal view virtual returns (uint24) {}
1688 
1689     /**
1690      * @dev Returns the next extra data for the packed ownership data.
1691      * The returned result is shifted into position.
1692      */
1693     function _nextExtraData(
1694         address from,
1695         address to,
1696         uint256 prevOwnershipPacked
1697     ) private view returns (uint256) {
1698         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1699         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1700     }
1701 
1702     // =============================================================
1703     //                       OTHER OPERATIONS
1704     // =============================================================
1705 
1706     /**
1707      * @dev Returns the message sender (defaults to `msg.sender`).
1708      *
1709      * If you are writing GSN compatible contracts, you need to override this function.
1710      */
1711     function _msgSenderERC721A() internal view virtual returns (address) {
1712         return msg.sender;
1713     }
1714 
1715     /**
1716      * @dev Converts a uint256 to its ASCII string decimal representation.
1717      */
1718     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1719         assembly {
1720             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1721             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1722             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1723             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1724             let m := add(mload(0x40), 0xa0)
1725             // Update the free memory pointer to allocate.
1726             mstore(0x40, m)
1727             // Assign the `str` to the end.
1728             str := sub(m, 0x20)
1729             // Zeroize the slot after the string.
1730             mstore(str, 0)
1731 
1732             // Cache the end of the memory to calculate the length later.
1733             let end := str
1734 
1735             // We write the string from rightmost digit to leftmost digit.
1736             // The following is essentially a do-while loop that also handles the zero case.
1737             // prettier-ignore
1738             for { let temp := value } 1 {} {
1739                 str := sub(str, 1)
1740                 // Write the character to the pointer.
1741                 // The ASCII index of the '0' character is 48.
1742                 mstore8(str, add(48, mod(temp, 10)))
1743                 // Keep dividing `temp` until zero.
1744                 temp := div(temp, 10)
1745                 // prettier-ignore
1746                 if iszero(temp) { break }
1747             }
1748 
1749             let length := sub(end, str)
1750             // Move the pointer 32 bytes leftwards to make room for the length.
1751             str := sub(str, 0x20)
1752             // Store the length.
1753             mstore(str, length)
1754         }
1755     }
1756 }
1757 // File: contracts/ERC721AQueryable.sol
1758 
1759 
1760 // ERC721A Contracts v4.2.3
1761 // Creator: Chiru Labs
1762 
1763 pragma solidity ^0.8.4;
1764 
1765 
1766 
1767 /**
1768  * @title ERC721AQueryable.
1769  *
1770  * @dev ERC721A subclass with convenience query functions.
1771  */
1772 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1773     /**
1774      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1775      *
1776      * If the `tokenId` is out of bounds:
1777      *
1778      * - `addr = address(0)`
1779      * - `startTimestamp = 0`
1780      * - `burned = false`
1781      * - `extraData = 0`
1782      *
1783      * If the `tokenId` is burned:
1784      *
1785      * - `addr = <Address of owner before token was burned>`
1786      * - `startTimestamp = <Timestamp when token was burned>`
1787      * - `burned = true`
1788      * - `extraData = <Extra data when token was burned>`
1789      *
1790      * Otherwise:
1791      *
1792      * - `addr = <Address of owner>`
1793      * - `startTimestamp = <Timestamp of start of ownership>`
1794      * - `burned = false`
1795      * - `extraData = <Extra data at start of ownership>`
1796      */
1797     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1798         TokenOwnership memory ownership;
1799         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1800             return ownership;
1801         }
1802         ownership = _ownershipAt(tokenId);
1803         if (ownership.burned) {
1804             return ownership;
1805         }
1806         return _ownershipOf(tokenId);
1807     }
1808 
1809     /**
1810      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1811      * See {ERC721AQueryable-explicitOwnershipOf}
1812      */
1813     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1814         external
1815         view
1816         virtual
1817         override
1818         returns (TokenOwnership[] memory)
1819     {
1820         unchecked {
1821             uint256 tokenIdsLength = tokenIds.length;
1822             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1823             for (uint256 i; i != tokenIdsLength; ++i) {
1824                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1825             }
1826             return ownerships;
1827         }
1828     }
1829 
1830     /**
1831      * @dev Returns an array of token IDs owned by `owner`,
1832      * in the range [`start`, `stop`)
1833      * (i.e. `start <= tokenId < stop`).
1834      *
1835      * This function allows for tokens to be queried if the collection
1836      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1837      *
1838      * Requirements:
1839      *
1840      * - `start < stop`
1841      */
1842     function tokensOfOwnerIn(
1843         address owner,
1844         uint256 start,
1845         uint256 stop
1846     ) external view virtual override returns (uint256[] memory) {
1847         unchecked {
1848             if (start >= stop) revert InvalidQueryRange();
1849             uint256 tokenIdsIdx;
1850             uint256 stopLimit = _nextTokenId();
1851             // Set `start = max(start, _startTokenId())`.
1852             if (start < _startTokenId()) {
1853                 start = _startTokenId();
1854             }
1855             // Set `stop = min(stop, stopLimit)`.
1856             if (stop > stopLimit) {
1857                 stop = stopLimit;
1858             }
1859             uint256 tokenIdsMaxLength = balanceOf(owner);
1860             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1861             // to cater for cases where `balanceOf(owner)` is too big.
1862             if (start < stop) {
1863                 uint256 rangeLength = stop - start;
1864                 if (rangeLength < tokenIdsMaxLength) {
1865                     tokenIdsMaxLength = rangeLength;
1866                 }
1867             } else {
1868                 tokenIdsMaxLength = 0;
1869             }
1870             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1871             if (tokenIdsMaxLength == 0) {
1872                 return tokenIds;
1873             }
1874             // We need to call `explicitOwnershipOf(start)`,
1875             // because the slot at `start` may not be initialized.
1876             TokenOwnership memory ownership = explicitOwnershipOf(start);
1877             address currOwnershipAddr;
1878             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1879             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1880             if (!ownership.burned) {
1881                 currOwnershipAddr = ownership.addr;
1882             }
1883             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1884                 ownership = _ownershipAt(i);
1885                 if (ownership.burned) {
1886                     continue;
1887                 }
1888                 if (ownership.addr != address(0)) {
1889                     currOwnershipAddr = ownership.addr;
1890                 }
1891                 if (currOwnershipAddr == owner) {
1892                     tokenIds[tokenIdsIdx++] = i;
1893                 }
1894             }
1895             // Downsize the array to fit.
1896             assembly {
1897                 mstore(tokenIds, tokenIdsIdx)
1898             }
1899             return tokenIds;
1900         }
1901     }
1902 
1903     /**
1904      * @dev Returns an array of token IDs owned by `owner`.
1905      *
1906      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1907      * It is meant to be called off-chain.
1908      *
1909      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1910      * multiple smaller scans if the collection is large enough to cause
1911      * an out-of-gas error (10K collections should be fine).
1912      */
1913     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1914         unchecked {
1915             uint256 tokenIdsIdx;
1916             address currOwnershipAddr;
1917             uint256 tokenIdsLength = balanceOf(owner);
1918             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1919             TokenOwnership memory ownership;
1920             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1921                 ownership = _ownershipAt(i);
1922                 if (ownership.burned) {
1923                     continue;
1924                 }
1925                 if (ownership.addr != address(0)) {
1926                     currOwnershipAddr = ownership.addr;
1927                 }
1928                 if (currOwnershipAddr == owner) {
1929                     tokenIds[tokenIdsIdx++] = i;
1930                 }
1931             }
1932             return tokenIds;
1933         }
1934     }
1935 }
1936 // File: @openzeppelin/contracts/utils/Strings.sol
1937 
1938 
1939 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1940 
1941 pragma solidity ^0.8.0;
1942 
1943 /**
1944  * @dev String operations.
1945  */
1946 library Strings {
1947     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1948     uint8 private constant _ADDRESS_LENGTH = 20;
1949 
1950     /**
1951      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1952      */
1953     function toString(uint256 value) internal pure returns (string memory) {
1954         // Inspired by OraclizeAPI's implementation - MIT licence
1955         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1956 
1957         if (value == 0) {
1958             return "0";
1959         }
1960         uint256 temp = value;
1961         uint256 digits;
1962         while (temp != 0) {
1963             digits++;
1964             temp /= 10;
1965         }
1966         bytes memory buffer = new bytes(digits);
1967         while (value != 0) {
1968             digits -= 1;
1969             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1970             value /= 10;
1971         }
1972         return string(buffer);
1973     }
1974 
1975     /**
1976      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1977      */
1978     function toHexString(uint256 value) internal pure returns (string memory) {
1979         if (value == 0) {
1980             return "0x00";
1981         }
1982         uint256 temp = value;
1983         uint256 length = 0;
1984         while (temp != 0) {
1985             length++;
1986             temp >>= 8;
1987         }
1988         return toHexString(value, length);
1989     }
1990 
1991     /**
1992      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1993      */
1994     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1995         bytes memory buffer = new bytes(2 * length + 2);
1996         buffer[0] = "0";
1997         buffer[1] = "x";
1998         for (uint256 i = 2 * length + 1; i > 1; --i) {
1999             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2000             value >>= 4;
2001         }
2002         require(value == 0, "Strings: hex length insufficient");
2003         return string(buffer);
2004     }
2005 
2006     /**
2007      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2008      */
2009     function toHexString(address addr) internal pure returns (string memory) {
2010         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2011     }
2012 }
2013 
2014 // File: @openzeppelin/contracts/utils/Context.sol
2015 
2016 
2017 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2018 
2019 pragma solidity ^0.8.0;
2020 
2021 /**
2022  * @dev Provides information about the current execution context, including the
2023  * sender of the transaction and its data. While these are generally available
2024  * via msg.sender and msg.data, they should not be accessed in such a direct
2025  * manner, since when dealing with meta-transactions the account sending and
2026  * paying for execution may not be the actual sender (as far as an application
2027  * is concerned).
2028  *
2029  * This contract is only required for intermediate, library-like contracts.
2030  */
2031 abstract contract Context {
2032     function _msgSender() internal view virtual returns (address) {
2033         return msg.sender;
2034     }
2035 
2036     function _msgData() internal view virtual returns (bytes calldata) {
2037         return msg.data;
2038     }
2039 }
2040 
2041 // File: @openzeppelin/contracts/access/Ownable.sol
2042 
2043 
2044 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2045 
2046 pragma solidity ^0.8.0;
2047 
2048 
2049 /**
2050  * @dev Contract module which provides a basic access control mechanism, where
2051  * there is an account (an owner) that can be granted exclusive access to
2052  * specific functions.
2053  *
2054  * By default, the owner account will be the one that deploys the contract. This
2055  * can later be changed with {transferOwnership}.
2056  *
2057  * This module is used through inheritance. It will make available the modifier
2058  * `onlyOwner`, which can be applied to your functions to restrict their use to
2059  * the owner.
2060  */
2061 abstract contract Ownable is Context {
2062     address private _owner;
2063 
2064     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2065 
2066     /**
2067      * @dev Initializes the contract setting the deployer as the initial owner.
2068      */
2069     constructor() {
2070         _transferOwnership(_msgSender());
2071     }
2072 
2073     /**
2074      * @dev Throws if called by any account other than the owner.
2075      */
2076     modifier onlyOwner() {
2077         _checkOwner();
2078         _;
2079     }
2080 
2081     /**
2082      * @dev Returns the address of the current owner.
2083      */
2084     function owner() public view virtual returns (address) {
2085         return _owner;
2086     }
2087 
2088     /**
2089      * @dev Throws if the sender is not the owner.
2090      */
2091     function _checkOwner() internal view virtual {
2092         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2093     }
2094 
2095     /**
2096      * @dev Leaves the contract without owner. It will not be possible to call
2097      * `onlyOwner` functions anymore. Can only be called by the current owner.
2098      *
2099      * NOTE: Renouncing ownership will leave the contract without an owner,
2100      * thereby removing any functionality that is only available to the owner.
2101      */
2102     function renounceOwnership() public virtual onlyOwner {
2103         _transferOwnership(address(0));
2104     }
2105 
2106     /**
2107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2108      * Can only be called by the current owner.
2109      */
2110     function transferOwnership(address newOwner) public virtual onlyOwner {
2111         require(newOwner != address(0), "Ownable: new owner is the zero address");
2112         _transferOwnership(newOwner);
2113     }
2114 
2115     /**
2116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2117      * Internal function without access restriction.
2118      */
2119     function _transferOwnership(address newOwner) internal virtual {
2120         address oldOwner = _owner;
2121         _owner = newOwner;
2122         emit OwnershipTransferred(oldOwner, newOwner);
2123     }
2124 }
2125 
2126 // File: contracts/Frontiers.sol
2127 
2128 
2129 pragma solidity ^0.8.4;
2130 
2131 
2132 
2133 
2134 
2135 
2136 
2137 contract Frontiers is ERC721AQueryable, Ownable {
2138 
2139     string metadataPath = "https://universe.theblinkless.com/frontiersjson/";
2140     mapping(uint256 => string) public tokenList; // tokenid => "[planetid]-[parcelid]";
2141     mapping(uint256 => uint256) public planetParcelCounts; // planetid => # of parcels
2142     address payoutWallet = 0xeD2faa60373eC70E57B39152aeE5Ce4ed7C333c7; //wallet for payouts
2143     address optixReceiver = 0xB818B1BbF47fC499B621f6807d61a61046C6478f; // wallet to receive optix
2144     address bigBangContract = 0x12bE473a9299B29a1E22c0893695254a97dEa07f; //big bang contract address
2145     address optixContract = 0xa93fce39D926527Af68B8520FB55e2f74D9201b5; // optix contract address
2146     uint256 optixMintPrice = 5000 ether;
2147     uint256 currentlyMinting = 0;
2148     bytes32 root = 0x14a5ea8f1752b06b4aa9292e0c381cb9fbf293d53f033935235cae2ef6e7ae2d;
2149 
2150     constructor() ERC721A("The Blinkless: Frontiers", "BLNKFR") {}
2151 
2152     /*
2153     * Verifies the parcel count supplied from metadata is accurate
2154     */
2155     function verifyParcelCount(bytes32[] memory proof, bytes32 leaf) public view returns (bool){
2156         return MerkleProof.verify(proof,root,leaf);
2157     }
2158 
2159     function mint(uint256 quantity, uint256 pt, uint256 pl, bytes32[] memory proof, bytes32 leaf) external payable {
2160         //ensure minting is enabled
2161         require(currentlyMinting == 1, "Mint disabled.");
2162 
2163         //check planet ownership
2164         require(IERC721A(bigBangContract).ownerOf(pt) == msg.sender, "You can only split a planet you own.");
2165         
2166         //check pl
2167         require(verifyParcelCount(proof,leaf), "Parcel count does not match!");
2168 
2169         //check parcels
2170         require(quantity + planetParcelCounts[pt] <= pl, "Not enough parcels to fill split order.");
2171         
2172         //transfer optix for mint (must have approval already!)
2173         IERC20(optixContract).transferFrom(msg.sender,address(optixReceiver),optixMintPrice * quantity);
2174 
2175         //connect parcel info to token ids
2176         //loop is bounded by max parcel count in big bang
2177         uint currentParcel = planetParcelCounts[pt];
2178         uint i = 0;
2179         while(i < quantity){
2180             uint256 thisTokenId = _nextTokenId() + i;
2181             tokenList[thisTokenId] = string.concat(Strings.toString(pt), "/",Strings.toString(currentParcel+1));
2182             currentParcel++;
2183             i++;
2184         }
2185         //track parcel count for this planet
2186         planetParcelCounts[pt] += quantity;
2187 
2188         // mint the tokens
2189         _mint(msg.sender, quantity);
2190 
2191         
2192     }
2193 
2194      /**
2195     * Return metadata path
2196     */
2197     function tokenURI(uint tokenId) override(ERC721A,IERC721A) public view returns(string memory _uri){
2198         return string.concat(metadataPath,tokenList[tokenId],".json");
2199     } 
2200 
2201      /**
2202     * Update the optix mint price per parcel
2203     */
2204     function updateOptixMintPrice(uint256 _price) public onlyOwner{
2205         optixMintPrice = _price;
2206     }
2207 
2208 
2209      /**
2210     * Update the metadata path
2211     */
2212     function updateMetadataPath(string memory _path) public onlyOwner{
2213         metadataPath = _path;
2214     }
2215 
2216 
2217      /**
2218     * Update the big bang address
2219     */
2220      function updateBigBangContract(address _contract) public onlyOwner{
2221         bigBangContract = _contract;
2222     }
2223 
2224      /**
2225     * Update the optix address
2226     */
2227      function updateOptixContract(address _contract) public onlyOwner{
2228         optixContract = _contract;
2229     }
2230 
2231      /**
2232     * Update the optix receiver address
2233     */
2234      function updateOptixReceiver(address _address) public onlyOwner{
2235         optixReceiver = _address;
2236     }
2237 
2238      /**
2239     * Update the mint status
2240     */
2241      function updateCurrentlyMinting(uint256 _status) public onlyOwner{
2242         currentlyMinting = _status;
2243     }
2244 
2245      /**
2246     * Update the merkle root
2247     */
2248     function updateRoot(bytes32 _root) public onlyOwner{
2249         root = _root;
2250     }
2251 
2252 
2253      /**
2254     * Update the payout wallet address
2255     */
2256     function updatePayoutWallet(address _payoutWallet) public onlyOwner{
2257         payoutWallet = _payoutWallet;
2258     }
2259 
2260      /*
2261     * Withdraw by owner
2262     */
2263     function withdraw() external onlyOwner {
2264         (bool success, ) = payable(payoutWallet).call{value: address(this).balance}("");
2265         require(success, "Transfer failed.");
2266     }
2267 
2268 
2269 
2270     /*
2271     * These are here to receive ETH sent to the contract address
2272     */
2273     receive() external payable {}
2274 
2275     fallback() external payable {}
2276 }