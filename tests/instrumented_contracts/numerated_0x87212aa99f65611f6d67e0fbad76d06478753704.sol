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
216 // File: @openzeppelin/contracts/utils/Context.sol
217 
218 
219 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev Provides information about the current execution context, including the
225  * sender of the transaction and its data. While these are generally available
226  * via msg.sender and msg.data, they should not be accessed in such a direct
227  * manner, since when dealing with meta-transactions the account sending and
228  * paying for execution may not be the actual sender (as far as an application
229  * is concerned).
230  *
231  * This contract is only required for intermediate, library-like contracts.
232  */
233 abstract contract Context {
234     function _msgSender() internal view virtual returns (address) {
235         return msg.sender;
236     }
237 
238     function _msgData() internal view virtual returns (bytes calldata) {
239         return msg.data;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/security/Pausable.sol
244 
245 
246 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
247 
248 pragma solidity ^0.8.0;
249 
250 
251 /**
252  * @dev Contract module which allows children to implement an emergency stop
253  * mechanism that can be triggered by an authorized account.
254  *
255  * This module is used through inheritance. It will make available the
256  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
257  * the functions of your contract. Note that they will not be pausable by
258  * simply including this module, only once the modifiers are put in place.
259  */
260 abstract contract Pausable is Context {
261     /**
262      * @dev Emitted when the pause is triggered by `account`.
263      */
264     event Paused(address account);
265 
266     /**
267      * @dev Emitted when the pause is lifted by `account`.
268      */
269     event Unpaused(address account);
270 
271     bool private _paused;
272 
273     /**
274      * @dev Initializes the contract in unpaused state.
275      */
276     constructor() {
277         _paused = false;
278     }
279 
280     /**
281      * @dev Modifier to make a function callable only when the contract is not paused.
282      *
283      * Requirements:
284      *
285      * - The contract must not be paused.
286      */
287     modifier whenNotPaused() {
288         _requireNotPaused();
289         _;
290     }
291 
292     /**
293      * @dev Modifier to make a function callable only when the contract is paused.
294      *
295      * Requirements:
296      *
297      * - The contract must be paused.
298      */
299     modifier whenPaused() {
300         _requirePaused();
301         _;
302     }
303 
304     /**
305      * @dev Returns true if the contract is paused, and false otherwise.
306      */
307     function paused() public view virtual returns (bool) {
308         return _paused;
309     }
310 
311     /**
312      * @dev Throws if the contract is paused.
313      */
314     function _requireNotPaused() internal view virtual {
315         require(!paused(), "Pausable: paused");
316     }
317 
318     /**
319      * @dev Throws if the contract is not paused.
320      */
321     function _requirePaused() internal view virtual {
322         require(paused(), "Pausable: not paused");
323     }
324 
325     /**
326      * @dev Triggers stopped state.
327      *
328      * Requirements:
329      *
330      * - The contract must not be paused.
331      */
332     function _pause() internal virtual whenNotPaused {
333         _paused = true;
334         emit Paused(_msgSender());
335     }
336 
337     /**
338      * @dev Returns to normal state.
339      *
340      * Requirements:
341      *
342      * - The contract must be paused.
343      */
344     function _unpause() internal virtual whenPaused {
345         _paused = false;
346         emit Unpaused(_msgSender());
347     }
348 }
349 
350 // File: @openzeppelin/contracts/access/Ownable.sol
351 
352 
353 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 
358 /**
359  * @dev Contract module which provides a basic access control mechanism, where
360  * there is an account (an owner) that can be granted exclusive access to
361  * specific functions.
362  *
363  * By default, the owner account will be the one that deploys the contract. This
364  * can later be changed with {transferOwnership}.
365  *
366  * This module is used through inheritance. It will make available the modifier
367  * `onlyOwner`, which can be applied to your functions to restrict their use to
368  * the owner.
369  */
370 abstract contract Ownable is Context {
371     address private _owner;
372 
373     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
374 
375     /**
376      * @dev Initializes the contract setting the deployer as the initial owner.
377      */
378     constructor() {
379         _transferOwnership(_msgSender());
380     }
381 
382     /**
383      * @dev Throws if called by any account other than the owner.
384      */
385     modifier onlyOwner() {
386         _checkOwner();
387         _;
388     }
389 
390     /**
391      * @dev Returns the address of the current owner.
392      */
393     function owner() public view virtual returns (address) {
394         return _owner;
395     }
396 
397     /**
398      * @dev Throws if the sender is not the owner.
399      */
400     function _checkOwner() internal view virtual {
401         require(owner() == _msgSender(), "Ownable: caller is not the owner");
402     }
403 
404     /**
405      * @dev Leaves the contract without owner. It will not be possible to call
406      * `onlyOwner` functions anymore. Can only be called by the current owner.
407      *
408      * NOTE: Renouncing ownership will leave the contract without an owner,
409      * thereby removing any functionality that is only available to the owner.
410      */
411     function renounceOwnership() public virtual onlyOwner {
412         _transferOwnership(address(0));
413     }
414 
415     /**
416      * @dev Transfers ownership of the contract to a new account (`newOwner`).
417      * Can only be called by the current owner.
418      */
419     function transferOwnership(address newOwner) public virtual onlyOwner {
420         require(newOwner != address(0), "Ownable: new owner is the zero address");
421         _transferOwnership(newOwner);
422     }
423 
424     /**
425      * @dev Transfers ownership of the contract to a new account (`newOwner`).
426      * Internal function without access restriction.
427      */
428     function _transferOwnership(address newOwner) internal virtual {
429         address oldOwner = _owner;
430         _owner = newOwner;
431         emit OwnershipTransferred(oldOwner, newOwner);
432     }
433 }
434 
435 // File: erc721a/contracts/IERC721A.sol
436 
437 
438 // ERC721A Contracts v4.2.3
439 // Creator: Chiru Labs
440 
441 pragma solidity ^0.8.4;
442 
443 /**
444  * @dev Interface of ERC721A.
445  */
446 interface IERC721A {
447     /**
448      * The caller must own the token or be an approved operator.
449      */
450     error ApprovalCallerNotOwnerNorApproved();
451 
452     /**
453      * The token does not exist.
454      */
455     error ApprovalQueryForNonexistentToken();
456 
457     /**
458      * Cannot query the balance for the zero address.
459      */
460     error BalanceQueryForZeroAddress();
461 
462     /**
463      * Cannot mint to the zero address.
464      */
465     error MintToZeroAddress();
466 
467     /**
468      * The quantity of tokens minted must be more than zero.
469      */
470     error MintZeroQuantity();
471 
472     /**
473      * The token does not exist.
474      */
475     error OwnerQueryForNonexistentToken();
476 
477     /**
478      * The caller must own the token or be an approved operator.
479      */
480     error TransferCallerNotOwnerNorApproved();
481 
482     /**
483      * The token must be owned by `from`.
484      */
485     error TransferFromIncorrectOwner();
486 
487     /**
488      * Cannot safely transfer to a contract that does not implement the
489      * ERC721Receiver interface.
490      */
491     error TransferToNonERC721ReceiverImplementer();
492 
493     /**
494      * Cannot transfer to the zero address.
495      */
496     error TransferToZeroAddress();
497 
498     /**
499      * The token does not exist.
500      */
501     error URIQueryForNonexistentToken();
502 
503     /**
504      * The `quantity` minted with ERC2309 exceeds the safety limit.
505      */
506     error MintERC2309QuantityExceedsLimit();
507 
508     /**
509      * The `extraData` cannot be set on an unintialized ownership slot.
510      */
511     error OwnershipNotInitializedForExtraData();
512 
513     // =============================================================
514     //                            STRUCTS
515     // =============================================================
516 
517     struct TokenOwnership {
518         // The address of the owner.
519         address addr;
520         // Stores the start time of ownership with minimal overhead for tokenomics.
521         uint64 startTimestamp;
522         // Whether the token has been burned.
523         bool burned;
524         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
525         uint24 extraData;
526     }
527 
528     // =============================================================
529     //                         TOKEN COUNTERS
530     // =============================================================
531 
532     /**
533      * @dev Returns the total number of tokens in existence.
534      * Burned tokens will reduce the count.
535      * To get the total number of tokens minted, please see {_totalMinted}.
536      */
537     function totalSupply() external view returns (uint256);
538 
539     // =============================================================
540     //                            IERC165
541     // =============================================================
542 
543     /**
544      * @dev Returns true if this contract implements the interface defined by
545      * `interfaceId`. See the corresponding
546      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
547      * to learn more about how these ids are created.
548      *
549      * This function call must use less than 30000 gas.
550      */
551     function supportsInterface(bytes4 interfaceId) external view returns (bool);
552 
553     // =============================================================
554     //                            IERC721
555     // =============================================================
556 
557     /**
558      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
559      */
560     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
561 
562     /**
563      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
564      */
565     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
566 
567     /**
568      * @dev Emitted when `owner` enables or disables
569      * (`approved`) `operator` to manage all of its assets.
570      */
571     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
572 
573     /**
574      * @dev Returns the number of tokens in `owner`'s account.
575      */
576     function balanceOf(address owner) external view returns (uint256 balance);
577 
578     /**
579      * @dev Returns the owner of the `tokenId` token.
580      *
581      * Requirements:
582      *
583      * - `tokenId` must exist.
584      */
585     function ownerOf(uint256 tokenId) external view returns (address owner);
586 
587     /**
588      * @dev Safely transfers `tokenId` token from `from` to `to`,
589      * checking first that contract recipients are aware of the ERC721 protocol
590      * to prevent tokens from being forever locked.
591      *
592      * Requirements:
593      *
594      * - `from` cannot be the zero address.
595      * - `to` cannot be the zero address.
596      * - `tokenId` token must exist and be owned by `from`.
597      * - If the caller is not `from`, it must be have been allowed to move
598      * this token by either {approve} or {setApprovalForAll}.
599      * - If `to` refers to a smart contract, it must implement
600      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
601      *
602      * Emits a {Transfer} event.
603      */
604     function safeTransferFrom(
605         address from,
606         address to,
607         uint256 tokenId,
608         bytes calldata data
609     ) external payable;
610 
611     /**
612      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
613      */
614     function safeTransferFrom(
615         address from,
616         address to,
617         uint256 tokenId
618     ) external payable;
619 
620     /**
621      * @dev Transfers `tokenId` from `from` to `to`.
622      *
623      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
624      * whenever possible.
625      *
626      * Requirements:
627      *
628      * - `from` cannot be the zero address.
629      * - `to` cannot be the zero address.
630      * - `tokenId` token must be owned by `from`.
631      * - If the caller is not `from`, it must be approved to move this token
632      * by either {approve} or {setApprovalForAll}.
633      *
634      * Emits a {Transfer} event.
635      */
636     function transferFrom(
637         address from,
638         address to,
639         uint256 tokenId
640     ) external payable;
641 
642     /**
643      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
644      * The approval is cleared when the token is transferred.
645      *
646      * Only a single account can be approved at a time, so approving the
647      * zero address clears previous approvals.
648      *
649      * Requirements:
650      *
651      * - The caller must own the token or be an approved operator.
652      * - `tokenId` must exist.
653      *
654      * Emits an {Approval} event.
655      */
656     function approve(address to, uint256 tokenId) external payable;
657 
658     /**
659      * @dev Approve or remove `operator` as an operator for the caller.
660      * Operators can call {transferFrom} or {safeTransferFrom}
661      * for any token owned by the caller.
662      *
663      * Requirements:
664      *
665      * - The `operator` cannot be the caller.
666      *
667      * Emits an {ApprovalForAll} event.
668      */
669     function setApprovalForAll(address operator, bool _approved) external;
670 
671     /**
672      * @dev Returns the account approved for `tokenId` token.
673      *
674      * Requirements:
675      *
676      * - `tokenId` must exist.
677      */
678     function getApproved(uint256 tokenId) external view returns (address operator);
679 
680     /**
681      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
682      *
683      * See {setApprovalForAll}.
684      */
685     function isApprovedForAll(address owner, address operator) external view returns (bool);
686 
687     // =============================================================
688     //                        IERC721Metadata
689     // =============================================================
690 
691     /**
692      * @dev Returns the token collection name.
693      */
694     function name() external view returns (string memory);
695 
696     /**
697      * @dev Returns the token collection symbol.
698      */
699     function symbol() external view returns (string memory);
700 
701     /**
702      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
703      */
704     function tokenURI(uint256 tokenId) external view returns (string memory);
705 
706     // =============================================================
707     //                           IERC2309
708     // =============================================================
709 
710     /**
711      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
712      * (inclusive) is transferred from `from` to `to`, as defined in the
713      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
714      *
715      * See {_mintERC2309} for more details.
716      */
717     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
718 }
719 
720 // File: erc721a/contracts/ERC721A.sol
721 
722 
723 // ERC721A Contracts v4.2.3
724 // Creator: Chiru Labs
725 
726 pragma solidity ^0.8.4;
727 
728 
729 /**
730  * @dev Interface of ERC721 token receiver.
731  */
732 interface ERC721A__IERC721Receiver {
733     function onERC721Received(
734         address operator,
735         address from,
736         uint256 tokenId,
737         bytes calldata data
738     ) external returns (bytes4);
739 }
740 
741 /**
742  * @title ERC721A
743  *
744  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
745  * Non-Fungible Token Standard, including the Metadata extension.
746  * Optimized for lower gas during batch mints.
747  *
748  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
749  * starting from `_startTokenId()`.
750  *
751  * Assumptions:
752  *
753  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
754  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
755  */
756 contract ERC721A is IERC721A {
757     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
758     struct TokenApprovalRef {
759         address value;
760     }
761 
762     // =============================================================
763     //                           CONSTANTS
764     // =============================================================
765 
766     // Mask of an entry in packed address data.
767     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
768 
769     // The bit position of `numberMinted` in packed address data.
770     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
771 
772     // The bit position of `numberBurned` in packed address data.
773     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
774 
775     // The bit position of `aux` in packed address data.
776     uint256 private constant _BITPOS_AUX = 192;
777 
778     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
779     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
780 
781     // The bit position of `startTimestamp` in packed ownership.
782     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
783 
784     // The bit mask of the `burned` bit in packed ownership.
785     uint256 private constant _BITMASK_BURNED = 1 << 224;
786 
787     // The bit position of the `nextInitialized` bit in packed ownership.
788     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
789 
790     // The bit mask of the `nextInitialized` bit in packed ownership.
791     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
792 
793     // The bit position of `extraData` in packed ownership.
794     uint256 private constant _BITPOS_EXTRA_DATA = 232;
795 
796     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
797     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
798 
799     // The mask of the lower 160 bits for addresses.
800     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
801 
802     // The maximum `quantity` that can be minted with {_mintERC2309}.
803     // This limit is to prevent overflows on the address data entries.
804     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
805     // is required to cause an overflow, which is unrealistic.
806     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
807 
808     // The `Transfer` event signature is given by:
809     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
810     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
811         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
812 
813     // =============================================================
814     //                            STORAGE
815     // =============================================================
816 
817     // The next token ID to be minted.
818     uint256 private _currentIndex;
819 
820     // The number of tokens burned.
821     uint256 private _burnCounter;
822 
823     // Token name
824     string private _name;
825 
826     // Token symbol
827     string private _symbol;
828 
829     // Mapping from token ID to ownership details
830     // An empty struct value does not necessarily mean the token is unowned.
831     // See {_packedOwnershipOf} implementation for details.
832     //
833     // Bits Layout:
834     // - [0..159]   `addr`
835     // - [160..223] `startTimestamp`
836     // - [224]      `burned`
837     // - [225]      `nextInitialized`
838     // - [232..255] `extraData`
839     mapping(uint256 => uint256) private _packedOwnerships;
840 
841     // Mapping owner address to address data.
842     //
843     // Bits Layout:
844     // - [0..63]    `balance`
845     // - [64..127]  `numberMinted`
846     // - [128..191] `numberBurned`
847     // - [192..255] `aux`
848     mapping(address => uint256) private _packedAddressData;
849 
850     // Mapping from token ID to approved address.
851     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
852 
853     // Mapping from owner to operator approvals
854     mapping(address => mapping(address => bool)) private _operatorApprovals;
855 
856     // =============================================================
857     //                          CONSTRUCTOR
858     // =============================================================
859 
860     constructor(string memory name_, string memory symbol_) {
861         _name = name_;
862         _symbol = symbol_;
863         _currentIndex = _startTokenId();
864     }
865 
866     // =============================================================
867     //                   TOKEN COUNTING OPERATIONS
868     // =============================================================
869 
870     /**
871      * @dev Returns the starting token ID.
872      * To change the starting token ID, please override this function.
873      */
874     function _startTokenId() internal view virtual returns (uint256) {
875         return 0;
876     }
877 
878     /**
879      * @dev Returns the next token ID to be minted.
880      */
881     function _nextTokenId() internal view virtual returns (uint256) {
882         return _currentIndex;
883     }
884 
885     /**
886      * @dev Returns the total number of tokens in existence.
887      * Burned tokens will reduce the count.
888      * To get the total number of tokens minted, please see {_totalMinted}.
889      */
890     function totalSupply() public view virtual override returns (uint256) {
891         // Counter underflow is impossible as _burnCounter cannot be incremented
892         // more than `_currentIndex - _startTokenId()` times.
893         unchecked {
894             return _currentIndex - _burnCounter - _startTokenId();
895         }
896     }
897 
898     /**
899      * @dev Returns the total amount of tokens minted in the contract.
900      */
901     function _totalMinted() internal view virtual returns (uint256) {
902         // Counter underflow is impossible as `_currentIndex` does not decrement,
903         // and it is initialized to `_startTokenId()`.
904         unchecked {
905             return _currentIndex - _startTokenId();
906         }
907     }
908 
909     /**
910      * @dev Returns the total number of tokens burned.
911      */
912     function _totalBurned() internal view virtual returns (uint256) {
913         return _burnCounter;
914     }
915 
916     // =============================================================
917     //                    ADDRESS DATA OPERATIONS
918     // =============================================================
919 
920     /**
921      * @dev Returns the number of tokens in `owner`'s account.
922      */
923     function balanceOf(address owner) public view virtual override returns (uint256) {
924         if (owner == address(0)) revert BalanceQueryForZeroAddress();
925         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
926     }
927 
928     /**
929      * Returns the number of tokens minted by `owner`.
930      */
931     function _numberMinted(address owner) internal view returns (uint256) {
932         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
933     }
934 
935     /**
936      * Returns the number of tokens burned by or on behalf of `owner`.
937      */
938     function _numberBurned(address owner) internal view returns (uint256) {
939         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
940     }
941 
942     /**
943      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
944      */
945     function _getAux(address owner) internal view returns (uint64) {
946         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
947     }
948 
949     /**
950      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
951      * If there are multiple variables, please pack them into a uint64.
952      */
953     function _setAux(address owner, uint64 aux) internal virtual {
954         uint256 packed = _packedAddressData[owner];
955         uint256 auxCasted;
956         // Cast `aux` with assembly to avoid redundant masking.
957         assembly {
958             auxCasted := aux
959         }
960         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
961         _packedAddressData[owner] = packed;
962     }
963 
964     // =============================================================
965     //                            IERC165
966     // =============================================================
967 
968     /**
969      * @dev Returns true if this contract implements the interface defined by
970      * `interfaceId`. See the corresponding
971      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
972      * to learn more about how these ids are created.
973      *
974      * This function call must use less than 30000 gas.
975      */
976     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
977         // The interface IDs are constants representing the first 4 bytes
978         // of the XOR of all function selectors in the interface.
979         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
980         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
981         return
982             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
983             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
984             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
985     }
986 
987     // =============================================================
988     //                        IERC721Metadata
989     // =============================================================
990 
991     /**
992      * @dev Returns the token collection name.
993      */
994     function name() public view virtual override returns (string memory) {
995         return _name;
996     }
997 
998     /**
999      * @dev Returns the token collection symbol.
1000      */
1001     function symbol() public view virtual override returns (string memory) {
1002         return _symbol;
1003     }
1004 
1005     /**
1006      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1007      */
1008     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1009         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1010 
1011         string memory baseURI = _baseURI();
1012         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1013     }
1014 
1015     /**
1016      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1017      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1018      * by default, it can be overridden in child contracts.
1019      */
1020     function _baseURI() internal view virtual returns (string memory) {
1021         return '';
1022     }
1023 
1024     // =============================================================
1025     //                     OWNERSHIPS OPERATIONS
1026     // =============================================================
1027 
1028     /**
1029      * @dev Returns the owner of the `tokenId` token.
1030      *
1031      * Requirements:
1032      *
1033      * - `tokenId` must exist.
1034      */
1035     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1036         return address(uint160(_packedOwnershipOf(tokenId)));
1037     }
1038 
1039     /**
1040      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1041      * It gradually moves to O(1) as tokens get transferred around over time.
1042      */
1043     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1044         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1045     }
1046 
1047     /**
1048      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1049      */
1050     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1051         return _unpackedOwnership(_packedOwnerships[index]);
1052     }
1053 
1054     /**
1055      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1056      */
1057     function _initializeOwnershipAt(uint256 index) internal virtual {
1058         if (_packedOwnerships[index] == 0) {
1059             _packedOwnerships[index] = _packedOwnershipOf(index);
1060         }
1061     }
1062 
1063     /**
1064      * Returns the packed ownership data of `tokenId`.
1065      */
1066     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1067         uint256 curr = tokenId;
1068 
1069         unchecked {
1070             if (_startTokenId() <= curr)
1071                 if (curr < _currentIndex) {
1072                     uint256 packed = _packedOwnerships[curr];
1073                     // If not burned.
1074                     if (packed & _BITMASK_BURNED == 0) {
1075                         // Invariant:
1076                         // There will always be an initialized ownership slot
1077                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1078                         // before an unintialized ownership slot
1079                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1080                         // Hence, `curr` will not underflow.
1081                         //
1082                         // We can directly compare the packed value.
1083                         // If the address is zero, packed will be zero.
1084                         while (packed == 0) {
1085                             packed = _packedOwnerships[--curr];
1086                         }
1087                         return packed;
1088                     }
1089                 }
1090         }
1091         revert OwnerQueryForNonexistentToken();
1092     }
1093 
1094     /**
1095      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1096      */
1097     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1098         ownership.addr = address(uint160(packed));
1099         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1100         ownership.burned = packed & _BITMASK_BURNED != 0;
1101         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1102     }
1103 
1104     /**
1105      * @dev Packs ownership data into a single uint256.
1106      */
1107     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1108         assembly {
1109             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1110             owner := and(owner, _BITMASK_ADDRESS)
1111             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1112             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1113         }
1114     }
1115 
1116     /**
1117      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1118      */
1119     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1120         // For branchless setting of the `nextInitialized` flag.
1121         assembly {
1122             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1123             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1124         }
1125     }
1126 
1127     // =============================================================
1128     //                      APPROVAL OPERATIONS
1129     // =============================================================
1130 
1131     /**
1132      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1133      * The approval is cleared when the token is transferred.
1134      *
1135      * Only a single account can be approved at a time, so approving the
1136      * zero address clears previous approvals.
1137      *
1138      * Requirements:
1139      *
1140      * - The caller must own the token or be an approved operator.
1141      * - `tokenId` must exist.
1142      *
1143      * Emits an {Approval} event.
1144      */
1145     function approve(address to, uint256 tokenId) public payable virtual override {
1146         address owner = ownerOf(tokenId);
1147 
1148         if (_msgSenderERC721A() != owner)
1149             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1150                 revert ApprovalCallerNotOwnerNorApproved();
1151             }
1152 
1153         _tokenApprovals[tokenId].value = to;
1154         emit Approval(owner, to, tokenId);
1155     }
1156 
1157     /**
1158      * @dev Returns the account approved for `tokenId` token.
1159      *
1160      * Requirements:
1161      *
1162      * - `tokenId` must exist.
1163      */
1164     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1165         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1166 
1167         return _tokenApprovals[tokenId].value;
1168     }
1169 
1170     /**
1171      * @dev Approve or remove `operator` as an operator for the caller.
1172      * Operators can call {transferFrom} or {safeTransferFrom}
1173      * for any token owned by the caller.
1174      *
1175      * Requirements:
1176      *
1177      * - The `operator` cannot be the caller.
1178      *
1179      * Emits an {ApprovalForAll} event.
1180      */
1181     function setApprovalForAll(address operator, bool approved) public virtual override {
1182         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1183         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1184     }
1185 
1186     /**
1187      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1188      *
1189      * See {setApprovalForAll}.
1190      */
1191     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1192         return _operatorApprovals[owner][operator];
1193     }
1194 
1195     /**
1196      * @dev Returns whether `tokenId` exists.
1197      *
1198      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1199      *
1200      * Tokens start existing when they are minted. See {_mint}.
1201      */
1202     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1203         return
1204             _startTokenId() <= tokenId &&
1205             tokenId < _currentIndex && // If within bounds,
1206             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1207     }
1208 
1209     /**
1210      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1211      */
1212     function _isSenderApprovedOrOwner(
1213         address approvedAddress,
1214         address owner,
1215         address msgSender
1216     ) private pure returns (bool result) {
1217         assembly {
1218             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1219             owner := and(owner, _BITMASK_ADDRESS)
1220             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1221             msgSender := and(msgSender, _BITMASK_ADDRESS)
1222             // `msgSender == owner || msgSender == approvedAddress`.
1223             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1224         }
1225     }
1226 
1227     /**
1228      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1229      */
1230     function _getApprovedSlotAndAddress(uint256 tokenId)
1231         private
1232         view
1233         returns (uint256 approvedAddressSlot, address approvedAddress)
1234     {
1235         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1236         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1237         assembly {
1238             approvedAddressSlot := tokenApproval.slot
1239             approvedAddress := sload(approvedAddressSlot)
1240         }
1241     }
1242 
1243     // =============================================================
1244     //                      TRANSFER OPERATIONS
1245     // =============================================================
1246 
1247     /**
1248      * @dev Transfers `tokenId` from `from` to `to`.
1249      *
1250      * Requirements:
1251      *
1252      * - `from` cannot be the zero address.
1253      * - `to` cannot be the zero address.
1254      * - `tokenId` token must be owned by `from`.
1255      * - If the caller is not `from`, it must be approved to move this token
1256      * by either {approve} or {setApprovalForAll}.
1257      *
1258      * Emits a {Transfer} event.
1259      */
1260     function transferFrom(
1261         address from,
1262         address to,
1263         uint256 tokenId
1264     ) public payable virtual override {
1265         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1266 
1267         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1268 
1269         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1270 
1271         // The nested ifs save around 20+ gas over a compound boolean condition.
1272         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1273             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1274 
1275         if (to == address(0)) revert TransferToZeroAddress();
1276 
1277         _beforeTokenTransfers(from, to, tokenId, 1);
1278 
1279         // Clear approvals from the previous owner.
1280         assembly {
1281             if approvedAddress {
1282                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1283                 sstore(approvedAddressSlot, 0)
1284             }
1285         }
1286 
1287         // Underflow of the sender's balance is impossible because we check for
1288         // ownership above and the recipient's balance can't realistically overflow.
1289         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1290         unchecked {
1291             // We can directly increment and decrement the balances.
1292             --_packedAddressData[from]; // Updates: `balance -= 1`.
1293             ++_packedAddressData[to]; // Updates: `balance += 1`.
1294 
1295             // Updates:
1296             // - `address` to the next owner.
1297             // - `startTimestamp` to the timestamp of transfering.
1298             // - `burned` to `false`.
1299             // - `nextInitialized` to `true`.
1300             _packedOwnerships[tokenId] = _packOwnershipData(
1301                 to,
1302                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1303             );
1304 
1305             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1306             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1307                 uint256 nextTokenId = tokenId + 1;
1308                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1309                 if (_packedOwnerships[nextTokenId] == 0) {
1310                     // If the next slot is within bounds.
1311                     if (nextTokenId != _currentIndex) {
1312                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1313                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1314                     }
1315                 }
1316             }
1317         }
1318 
1319         emit Transfer(from, to, tokenId);
1320         _afterTokenTransfers(from, to, tokenId, 1);
1321     }
1322 
1323     /**
1324      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1325      */
1326     function safeTransferFrom(
1327         address from,
1328         address to,
1329         uint256 tokenId
1330     ) public payable virtual override {
1331         safeTransferFrom(from, to, tokenId, '');
1332     }
1333 
1334     /**
1335      * @dev Safely transfers `tokenId` token from `from` to `to`.
1336      *
1337      * Requirements:
1338      *
1339      * - `from` cannot be the zero address.
1340      * - `to` cannot be the zero address.
1341      * - `tokenId` token must exist and be owned by `from`.
1342      * - If the caller is not `from`, it must be approved to move this token
1343      * by either {approve} or {setApprovalForAll}.
1344      * - If `to` refers to a smart contract, it must implement
1345      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1346      *
1347      * Emits a {Transfer} event.
1348      */
1349     function safeTransferFrom(
1350         address from,
1351         address to,
1352         uint256 tokenId,
1353         bytes memory _data
1354     ) public payable virtual override {
1355         transferFrom(from, to, tokenId);
1356         if (to.code.length != 0)
1357             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1358                 revert TransferToNonERC721ReceiverImplementer();
1359             }
1360     }
1361 
1362     /**
1363      * @dev Hook that is called before a set of serially-ordered token IDs
1364      * are about to be transferred. This includes minting.
1365      * And also called before burning one token.
1366      *
1367      * `startTokenId` - the first token ID to be transferred.
1368      * `quantity` - the amount to be transferred.
1369      *
1370      * Calling conditions:
1371      *
1372      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1373      * transferred to `to`.
1374      * - When `from` is zero, `tokenId` will be minted for `to`.
1375      * - When `to` is zero, `tokenId` will be burned by `from`.
1376      * - `from` and `to` are never both zero.
1377      */
1378     function _beforeTokenTransfers(
1379         address from,
1380         address to,
1381         uint256 startTokenId,
1382         uint256 quantity
1383     ) internal virtual {}
1384 
1385     /**
1386      * @dev Hook that is called after a set of serially-ordered token IDs
1387      * have been transferred. This includes minting.
1388      * And also called after one token has been burned.
1389      *
1390      * `startTokenId` - the first token ID to be transferred.
1391      * `quantity` - the amount to be transferred.
1392      *
1393      * Calling conditions:
1394      *
1395      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1396      * transferred to `to`.
1397      * - When `from` is zero, `tokenId` has been minted for `to`.
1398      * - When `to` is zero, `tokenId` has been burned by `from`.
1399      * - `from` and `to` are never both zero.
1400      */
1401     function _afterTokenTransfers(
1402         address from,
1403         address to,
1404         uint256 startTokenId,
1405         uint256 quantity
1406     ) internal virtual {}
1407 
1408     /**
1409      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1410      *
1411      * `from` - Previous owner of the given token ID.
1412      * `to` - Target address that will receive the token.
1413      * `tokenId` - Token ID to be transferred.
1414      * `_data` - Optional data to send along with the call.
1415      *
1416      * Returns whether the call correctly returned the expected magic value.
1417      */
1418     function _checkContractOnERC721Received(
1419         address from,
1420         address to,
1421         uint256 tokenId,
1422         bytes memory _data
1423     ) private returns (bool) {
1424         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1425             bytes4 retval
1426         ) {
1427             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1428         } catch (bytes memory reason) {
1429             if (reason.length == 0) {
1430                 revert TransferToNonERC721ReceiverImplementer();
1431             } else {
1432                 assembly {
1433                     revert(add(32, reason), mload(reason))
1434                 }
1435             }
1436         }
1437     }
1438 
1439     // =============================================================
1440     //                        MINT OPERATIONS
1441     // =============================================================
1442 
1443     /**
1444      * @dev Mints `quantity` tokens and transfers them to `to`.
1445      *
1446      * Requirements:
1447      *
1448      * - `to` cannot be the zero address.
1449      * - `quantity` must be greater than 0.
1450      *
1451      * Emits a {Transfer} event for each mint.
1452      */
1453     function _mint(address to, uint256 quantity) internal virtual {
1454         uint256 startTokenId = _currentIndex;
1455         if (quantity == 0) revert MintZeroQuantity();
1456 
1457         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1458 
1459         // Overflows are incredibly unrealistic.
1460         // `balance` and `numberMinted` have a maximum limit of 2**64.
1461         // `tokenId` has a maximum limit of 2**256.
1462         unchecked {
1463             // Updates:
1464             // - `balance += quantity`.
1465             // - `numberMinted += quantity`.
1466             //
1467             // We can directly add to the `balance` and `numberMinted`.
1468             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1469 
1470             // Updates:
1471             // - `address` to the owner.
1472             // - `startTimestamp` to the timestamp of minting.
1473             // - `burned` to `false`.
1474             // - `nextInitialized` to `quantity == 1`.
1475             _packedOwnerships[startTokenId] = _packOwnershipData(
1476                 to,
1477                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1478             );
1479 
1480             uint256 toMasked;
1481             uint256 end = startTokenId + quantity;
1482 
1483             // Use assembly to loop and emit the `Transfer` event for gas savings.
1484             // The duplicated `log4` removes an extra check and reduces stack juggling.
1485             // The assembly, together with the surrounding Solidity code, have been
1486             // delicately arranged to nudge the compiler into producing optimized opcodes.
1487             assembly {
1488                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1489                 toMasked := and(to, _BITMASK_ADDRESS)
1490                 // Emit the `Transfer` event.
1491                 log4(
1492                     0, // Start of data (0, since no data).
1493                     0, // End of data (0, since no data).
1494                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1495                     0, // `address(0)`.
1496                     toMasked, // `to`.
1497                     startTokenId // `tokenId`.
1498                 )
1499 
1500                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1501                 // that overflows uint256 will make the loop run out of gas.
1502                 // The compiler will optimize the `iszero` away for performance.
1503                 for {
1504                     let tokenId := add(startTokenId, 1)
1505                 } iszero(eq(tokenId, end)) {
1506                     tokenId := add(tokenId, 1)
1507                 } {
1508                     // Emit the `Transfer` event. Similar to above.
1509                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1510                 }
1511             }
1512             if (toMasked == 0) revert MintToZeroAddress();
1513 
1514             _currentIndex = end;
1515         }
1516         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1517     }
1518 
1519     /**
1520      * @dev Mints `quantity` tokens and transfers them to `to`.
1521      *
1522      * This function is intended for efficient minting only during contract creation.
1523      *
1524      * It emits only one {ConsecutiveTransfer} as defined in
1525      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1526      * instead of a sequence of {Transfer} event(s).
1527      *
1528      * Calling this function outside of contract creation WILL make your contract
1529      * non-compliant with the ERC721 standard.
1530      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1531      * {ConsecutiveTransfer} event is only permissible during contract creation.
1532      *
1533      * Requirements:
1534      *
1535      * - `to` cannot be the zero address.
1536      * - `quantity` must be greater than 0.
1537      *
1538      * Emits a {ConsecutiveTransfer} event.
1539      */
1540     function _mintERC2309(address to, uint256 quantity) internal virtual {
1541         uint256 startTokenId = _currentIndex;
1542         if (to == address(0)) revert MintToZeroAddress();
1543         if (quantity == 0) revert MintZeroQuantity();
1544         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1545 
1546         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1547 
1548         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1549         unchecked {
1550             // Updates:
1551             // - `balance += quantity`.
1552             // - `numberMinted += quantity`.
1553             //
1554             // We can directly add to the `balance` and `numberMinted`.
1555             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1556 
1557             // Updates:
1558             // - `address` to the owner.
1559             // - `startTimestamp` to the timestamp of minting.
1560             // - `burned` to `false`.
1561             // - `nextInitialized` to `quantity == 1`.
1562             _packedOwnerships[startTokenId] = _packOwnershipData(
1563                 to,
1564                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1565             );
1566 
1567             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1568 
1569             _currentIndex = startTokenId + quantity;
1570         }
1571         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1572     }
1573 
1574     /**
1575      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1576      *
1577      * Requirements:
1578      *
1579      * - If `to` refers to a smart contract, it must implement
1580      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1581      * - `quantity` must be greater than 0.
1582      *
1583      * See {_mint}.
1584      *
1585      * Emits a {Transfer} event for each mint.
1586      */
1587     function _safeMint(
1588         address to,
1589         uint256 quantity,
1590         bytes memory _data
1591     ) internal virtual {
1592         _mint(to, quantity);
1593 
1594         unchecked {
1595             if (to.code.length != 0) {
1596                 uint256 end = _currentIndex;
1597                 uint256 index = end - quantity;
1598                 do {
1599                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1600                         revert TransferToNonERC721ReceiverImplementer();
1601                     }
1602                 } while (index < end);
1603                 // Reentrancy protection.
1604                 if (_currentIndex != end) revert();
1605             }
1606         }
1607     }
1608 
1609     /**
1610      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1611      */
1612     function _safeMint(address to, uint256 quantity) internal virtual {
1613         _safeMint(to, quantity, '');
1614     }
1615 
1616     // =============================================================
1617     //                        BURN OPERATIONS
1618     // =============================================================
1619 
1620     /**
1621      * @dev Equivalent to `_burn(tokenId, false)`.
1622      */
1623     function _burn(uint256 tokenId) internal virtual {
1624         _burn(tokenId, false);
1625     }
1626 
1627     /**
1628      * @dev Destroys `tokenId`.
1629      * The approval is cleared when the token is burned.
1630      *
1631      * Requirements:
1632      *
1633      * - `tokenId` must exist.
1634      *
1635      * Emits a {Transfer} event.
1636      */
1637     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1638         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1639 
1640         address from = address(uint160(prevOwnershipPacked));
1641 
1642         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1643 
1644         if (approvalCheck) {
1645             // The nested ifs save around 20+ gas over a compound boolean condition.
1646             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1647                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1648         }
1649 
1650         _beforeTokenTransfers(from, address(0), tokenId, 1);
1651 
1652         // Clear approvals from the previous owner.
1653         assembly {
1654             if approvedAddress {
1655                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1656                 sstore(approvedAddressSlot, 0)
1657             }
1658         }
1659 
1660         // Underflow of the sender's balance is impossible because we check for
1661         // ownership above and the recipient's balance can't realistically overflow.
1662         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1663         unchecked {
1664             // Updates:
1665             // - `balance -= 1`.
1666             // - `numberBurned += 1`.
1667             //
1668             // We can directly decrement the balance, and increment the number burned.
1669             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1670             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1671 
1672             // Updates:
1673             // - `address` to the last owner.
1674             // - `startTimestamp` to the timestamp of burning.
1675             // - `burned` to `true`.
1676             // - `nextInitialized` to `true`.
1677             _packedOwnerships[tokenId] = _packOwnershipData(
1678                 from,
1679                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1680             );
1681 
1682             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1683             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1684                 uint256 nextTokenId = tokenId + 1;
1685                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1686                 if (_packedOwnerships[nextTokenId] == 0) {
1687                     // If the next slot is within bounds.
1688                     if (nextTokenId != _currentIndex) {
1689                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1690                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1691                     }
1692                 }
1693             }
1694         }
1695 
1696         emit Transfer(from, address(0), tokenId);
1697         _afterTokenTransfers(from, address(0), tokenId, 1);
1698 
1699         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1700         unchecked {
1701             _burnCounter++;
1702         }
1703     }
1704 
1705     // =============================================================
1706     //                     EXTRA DATA OPERATIONS
1707     // =============================================================
1708 
1709     /**
1710      * @dev Directly sets the extra data for the ownership data `index`.
1711      */
1712     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1713         uint256 packed = _packedOwnerships[index];
1714         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1715         uint256 extraDataCasted;
1716         // Cast `extraData` with assembly to avoid redundant masking.
1717         assembly {
1718             extraDataCasted := extraData
1719         }
1720         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1721         _packedOwnerships[index] = packed;
1722     }
1723 
1724     /**
1725      * @dev Called during each token transfer to set the 24bit `extraData` field.
1726      * Intended to be overridden by the cosumer contract.
1727      *
1728      * `previousExtraData` - the value of `extraData` before transfer.
1729      *
1730      * Calling conditions:
1731      *
1732      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1733      * transferred to `to`.
1734      * - When `from` is zero, `tokenId` will be minted for `to`.
1735      * - When `to` is zero, `tokenId` will be burned by `from`.
1736      * - `from` and `to` are never both zero.
1737      */
1738     function _extraData(
1739         address from,
1740         address to,
1741         uint24 previousExtraData
1742     ) internal view virtual returns (uint24) {}
1743 
1744     /**
1745      * @dev Returns the next extra data for the packed ownership data.
1746      * The returned result is shifted into position.
1747      */
1748     function _nextExtraData(
1749         address from,
1750         address to,
1751         uint256 prevOwnershipPacked
1752     ) private view returns (uint256) {
1753         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1754         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1755     }
1756 
1757     // =============================================================
1758     //                       OTHER OPERATIONS
1759     // =============================================================
1760 
1761     /**
1762      * @dev Returns the message sender (defaults to `msg.sender`).
1763      *
1764      * If you are writing GSN compatible contracts, you need to override this function.
1765      */
1766     function _msgSenderERC721A() internal view virtual returns (address) {
1767         return msg.sender;
1768     }
1769 
1770     /**
1771      * @dev Converts a uint256 to its ASCII string decimal representation.
1772      */
1773     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1774         assembly {
1775             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1776             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1777             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1778             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1779             let m := add(mload(0x40), 0xa0)
1780             // Update the free memory pointer to allocate.
1781             mstore(0x40, m)
1782             // Assign the `str` to the end.
1783             str := sub(m, 0x20)
1784             // Zeroize the slot after the string.
1785             mstore(str, 0)
1786 
1787             // Cache the end of the memory to calculate the length later.
1788             let end := str
1789 
1790             // We write the string from rightmost digit to leftmost digit.
1791             // The following is essentially a do-while loop that also handles the zero case.
1792             // prettier-ignore
1793             for { let temp := value } 1 {} {
1794                 str := sub(str, 1)
1795                 // Write the character to the pointer.
1796                 // The ASCII index of the '0' character is 48.
1797                 mstore8(str, add(48, mod(temp, 10)))
1798                 // Keep dividing `temp` until zero.
1799                 temp := div(temp, 10)
1800                 // prettier-ignore
1801                 if iszero(temp) { break }
1802             }
1803 
1804             let length := sub(end, str)
1805             // Move the pointer 32 bytes leftwards to make room for the length.
1806             str := sub(str, 0x20)
1807             // Store the length.
1808             mstore(str, length)
1809         }
1810     }
1811 }
1812 
1813 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1814 
1815 
1816 // ERC721A Contracts v4.2.3
1817 // Creator: Chiru Labs
1818 
1819 pragma solidity ^0.8.4;
1820 
1821 
1822 /**
1823  * @dev Interface of ERC721AQueryable.
1824  */
1825 interface IERC721AQueryable is IERC721A {
1826     /**
1827      * Invalid query range (`start` >= `stop`).
1828      */
1829     error InvalidQueryRange();
1830 
1831     /**
1832      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1833      *
1834      * If the `tokenId` is out of bounds:
1835      *
1836      * - `addr = address(0)`
1837      * - `startTimestamp = 0`
1838      * - `burned = false`
1839      * - `extraData = 0`
1840      *
1841      * If the `tokenId` is burned:
1842      *
1843      * - `addr = <Address of owner before token was burned>`
1844      * - `startTimestamp = <Timestamp when token was burned>`
1845      * - `burned = true`
1846      * - `extraData = <Extra data when token was burned>`
1847      *
1848      * Otherwise:
1849      *
1850      * - `addr = <Address of owner>`
1851      * - `startTimestamp = <Timestamp of start of ownership>`
1852      * - `burned = false`
1853      * - `extraData = <Extra data at start of ownership>`
1854      */
1855     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1856 
1857     /**
1858      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1859      * See {ERC721AQueryable-explicitOwnershipOf}
1860      */
1861     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1862 
1863     /**
1864      * @dev Returns an array of token IDs owned by `owner`,
1865      * in the range [`start`, `stop`)
1866      * (i.e. `start <= tokenId < stop`).
1867      *
1868      * This function allows for tokens to be queried if the collection
1869      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1870      *
1871      * Requirements:
1872      *
1873      * - `start < stop`
1874      */
1875     function tokensOfOwnerIn(
1876         address owner,
1877         uint256 start,
1878         uint256 stop
1879     ) external view returns (uint256[] memory);
1880 
1881     /**
1882      * @dev Returns an array of token IDs owned by `owner`.
1883      *
1884      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1885      * It is meant to be called off-chain.
1886      *
1887      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1888      * multiple smaller scans if the collection is large enough to cause
1889      * an out-of-gas error (10K collections should be fine).
1890      */
1891     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1892 }
1893 
1894 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1895 
1896 
1897 // ERC721A Contracts v4.2.3
1898 // Creator: Chiru Labs
1899 
1900 pragma solidity ^0.8.4;
1901 
1902 
1903 
1904 /**
1905  * @title ERC721AQueryable.
1906  *
1907  * @dev ERC721A subclass with convenience query functions.
1908  */
1909 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1910     /**
1911      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1912      *
1913      * If the `tokenId` is out of bounds:
1914      *
1915      * - `addr = address(0)`
1916      * - `startTimestamp = 0`
1917      * - `burned = false`
1918      * - `extraData = 0`
1919      *
1920      * If the `tokenId` is burned:
1921      *
1922      * - `addr = <Address of owner before token was burned>`
1923      * - `startTimestamp = <Timestamp when token was burned>`
1924      * - `burned = true`
1925      * - `extraData = <Extra data when token was burned>`
1926      *
1927      * Otherwise:
1928      *
1929      * - `addr = <Address of owner>`
1930      * - `startTimestamp = <Timestamp of start of ownership>`
1931      * - `burned = false`
1932      * - `extraData = <Extra data at start of ownership>`
1933      */
1934     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1935         TokenOwnership memory ownership;
1936         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1937             return ownership;
1938         }
1939         ownership = _ownershipAt(tokenId);
1940         if (ownership.burned) {
1941             return ownership;
1942         }
1943         return _ownershipOf(tokenId);
1944     }
1945 
1946     /**
1947      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1948      * See {ERC721AQueryable-explicitOwnershipOf}
1949      */
1950     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1951         external
1952         view
1953         virtual
1954         override
1955         returns (TokenOwnership[] memory)
1956     {
1957         unchecked {
1958             uint256 tokenIdsLength = tokenIds.length;
1959             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1960             for (uint256 i; i != tokenIdsLength; ++i) {
1961                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1962             }
1963             return ownerships;
1964         }
1965     }
1966 
1967     /**
1968      * @dev Returns an array of token IDs owned by `owner`,
1969      * in the range [`start`, `stop`)
1970      * (i.e. `start <= tokenId < stop`).
1971      *
1972      * This function allows for tokens to be queried if the collection
1973      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1974      *
1975      * Requirements:
1976      *
1977      * - `start < stop`
1978      */
1979     function tokensOfOwnerIn(
1980         address owner,
1981         uint256 start,
1982         uint256 stop
1983     ) external view virtual override returns (uint256[] memory) {
1984         unchecked {
1985             if (start >= stop) revert InvalidQueryRange();
1986             uint256 tokenIdsIdx;
1987             uint256 stopLimit = _nextTokenId();
1988             // Set `start = max(start, _startTokenId())`.
1989             if (start < _startTokenId()) {
1990                 start = _startTokenId();
1991             }
1992             // Set `stop = min(stop, stopLimit)`.
1993             if (stop > stopLimit) {
1994                 stop = stopLimit;
1995             }
1996             uint256 tokenIdsMaxLength = balanceOf(owner);
1997             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1998             // to cater for cases where `balanceOf(owner)` is too big.
1999             if (start < stop) {
2000                 uint256 rangeLength = stop - start;
2001                 if (rangeLength < tokenIdsMaxLength) {
2002                     tokenIdsMaxLength = rangeLength;
2003                 }
2004             } else {
2005                 tokenIdsMaxLength = 0;
2006             }
2007             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2008             if (tokenIdsMaxLength == 0) {
2009                 return tokenIds;
2010             }
2011             // We need to call `explicitOwnershipOf(start)`,
2012             // because the slot at `start` may not be initialized.
2013             TokenOwnership memory ownership = explicitOwnershipOf(start);
2014             address currOwnershipAddr;
2015             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2016             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2017             if (!ownership.burned) {
2018                 currOwnershipAddr = ownership.addr;
2019             }
2020             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2021                 ownership = _ownershipAt(i);
2022                 if (ownership.burned) {
2023                     continue;
2024                 }
2025                 if (ownership.addr != address(0)) {
2026                     currOwnershipAddr = ownership.addr;
2027                 }
2028                 if (currOwnershipAddr == owner) {
2029                     tokenIds[tokenIdsIdx++] = i;
2030                 }
2031             }
2032             // Downsize the array to fit.
2033             assembly {
2034                 mstore(tokenIds, tokenIdsIdx)
2035             }
2036             return tokenIds;
2037         }
2038     }
2039 
2040     /**
2041      * @dev Returns an array of token IDs owned by `owner`.
2042      *
2043      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2044      * It is meant to be called off-chain.
2045      *
2046      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2047      * multiple smaller scans if the collection is large enough to cause
2048      * an out-of-gas error (10K collections should be fine).
2049      */
2050     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2051         unchecked {
2052             uint256 tokenIdsIdx;
2053             address currOwnershipAddr;
2054             uint256 tokenIdsLength = balanceOf(owner);
2055             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2056             TokenOwnership memory ownership;
2057             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
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
2069             return tokenIds;
2070         }
2071     }
2072 }
2073 
2074 // File: contracts/BADDIES.sol
2075 
2076 
2077 // Dev: https://twitter.com/MatthewPaquette
2078 pragma solidity ^0.8.4;
2079 
2080 
2081 
2082 
2083 
2084 contract BADDIES is ERC721AQueryable, Ownable, Pausable {
2085     uint256 public MAX_MINTS = 2000;
2086     uint256 public MAX_SUPPLY = 10000;
2087     uint256 public price = 0.08 ether;
2088     uint256 public wlPrice = 0.05 ether;
2089     uint256 public vipPrice = 0.05 ether;
2090 
2091     bool public wlActive = false;
2092     bool public vipActive = false;
2093 
2094     bytes32 public vipRoot;
2095     bytes32 public wlRoot;
2096     
2097     string public baseURI;
2098 
2099     uint256 public mintCounter = 0;
2100     uint256 public wlMintCounter = 0;
2101     uint256 public vipMintCounter = 0;
2102     uint256 public airDropCounter = 0;
2103 
2104     constructor(bytes32 _vipRoot, bytes32 _wlRoot) ERC721A("BADDIES", "BAD") {
2105         vipRoot = _vipRoot;
2106         wlRoot = _wlRoot;
2107         toggleAllMintPause();
2108     }
2109 
2110     function checkVIP(bytes32[] calldata _proof) public view returns (bool) {
2111         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2112         return MerkleProof.verify(_proof, vipRoot, leaf);
2113     }
2114 
2115     function checkWL(bytes32[] calldata _proof) public view returns (bool) {
2116         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2117         return MerkleProof.verify(_proof, wlRoot, leaf);
2118     }
2119 
2120     function mint(uint256 quantity) external payable whenNotPaused {
2121         require(quantity + _numberMinted(msg.sender) <= MAX_MINTS, "mint: Exceeded the limit per wallet");
2122         require(totalSupply() + quantity <= MAX_SUPPLY, "mint: Not enough tokens left");
2123         require(msg.value >= (price * quantity), "mint: Not enough ether sent");
2124 
2125         mintCounter += quantity;
2126         _safeMint(msg.sender, quantity);
2127     }
2128 
2129     function mintVIP(uint256 quantity, bytes32[] calldata _proof) external payable {
2130         require(vipActive == true, "mintVIP: VIP mint is not active");
2131         require(quantity + _numberMinted(msg.sender) <= MAX_MINTS, "mintVIP: Exceeded the limit per wallet");
2132         require(totalSupply() + quantity <= MAX_SUPPLY, "mintVIP: Not enough tokens left");
2133         require(msg.value >= (vipPrice * quantity), "mintVIP: Not enough ether sent");
2134 
2135         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2136         require(MerkleProof.verify(_proof, vipRoot, leaf), "mintVIP: address is not on whitelist");
2137 
2138         vipMintCounter += quantity;
2139         _safeMint(msg.sender, quantity);
2140     }
2141 
2142     function mintWhitelist(uint256 quantity, bytes32[] calldata _proof) external payable {
2143         require(wlActive == true, "mintWL: WL mint is not active");
2144         require(quantity + _numberMinted(msg.sender) <= MAX_MINTS, "mintWhitelist: Exceeded the limit per wallet");
2145         require(totalSupply() + quantity <= MAX_SUPPLY, "mintWhitelist: Not enough tokens left");
2146         require(msg.value >= (wlPrice * quantity), "mintWhitelist: Not enough ether sent");
2147 
2148         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2149         require(MerkleProof.verify(_proof, wlRoot, leaf), "mintWhitelist: address is not on whitelist");
2150 
2151         wlMintCounter += quantity;
2152         _safeMint(msg.sender, quantity);
2153     }
2154 
2155     function airDrop(address[] calldata addrs, uint256 quantity) external onlyOwner {
2156         uint256 len = addrs.length;
2157         require(totalSupply() + (quantity * len) <= MAX_SUPPLY, "airDrop: Not enough tokens to airdrop");
2158         airDropCounter += quantity * len;
2159         for (uint256 i = 0; i < len; i++) {
2160             _safeMint(addrs[i], quantity);
2161         }
2162     }
2163 
2164     function updateWLRoot(bytes32 _wlRoot) external onlyOwner {
2165         wlRoot = _wlRoot;
2166     }
2167 
2168     function updateVIPRoot(bytes32 _vipRoot) external onlyOwner {
2169         vipRoot = _vipRoot;
2170     }
2171 
2172     function _baseURI() internal view override returns (string memory) {
2173         return baseURI;
2174     }
2175 
2176     function _startTokenId() internal pure override returns (uint256) {
2177         return 1;
2178     }
2179 
2180     //ADMIN
2181 
2182     function enableVIPMint(bool state) external onlyOwner {
2183         vipActive = state;
2184     }
2185 
2186     function enableWLMint(bool state) external onlyOwner {
2187         wlActive = state;
2188     }
2189 
2190     function setPrice(uint256 _price) external onlyOwner {
2191         price = _price;
2192     }
2193 
2194     function setWLPrice(uint256 _price) external onlyOwner {
2195         wlPrice = _price;
2196     }
2197     
2198     function setVIPPrice(uint256 _price) external onlyOwner {
2199         vipPrice = _price;
2200     }
2201 
2202     function setMaxMint(uint256 _max) external onlyOwner {
2203         MAX_MINTS = _max;
2204     }
2205 
2206     function toggleAllMintPause() public onlyOwner {
2207         paused() ? _unpause() : _pause();
2208     }
2209 
2210     function setBaseURI(string memory _uri) external onlyOwner {
2211         baseURI = _uri;
2212     }
2213 
2214     function updateMaxSupply(uint256 _max) external onlyOwner {
2215         MAX_SUPPLY = _max;
2216     }
2217 
2218     function withdraw() external onlyOwner {
2219         require(address(this).balance > 0, "withdraw: contract balance must be greater than 0"); 
2220         uint256 balance = address(this).balance; 
2221         payable(msg.sender).transfer(balance);
2222     }
2223 
2224 }