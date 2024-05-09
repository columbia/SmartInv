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
216 // File: @openzeppelin/contracts/utils/Strings.sol
217 
218 
219 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev String operations.
225  */
226 library Strings {
227     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
228     uint8 private constant _ADDRESS_LENGTH = 20;
229 
230     /**
231      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
232      */
233     function toString(uint256 value) internal pure returns (string memory) {
234         // Inspired by OraclizeAPI's implementation - MIT licence
235         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
236 
237         if (value == 0) {
238             return "0";
239         }
240         uint256 temp = value;
241         uint256 digits;
242         while (temp != 0) {
243             digits++;
244             temp /= 10;
245         }
246         bytes memory buffer = new bytes(digits);
247         while (value != 0) {
248             digits -= 1;
249             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
250             value /= 10;
251         }
252         return string(buffer);
253     }
254 
255     /**
256      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
257      */
258     function toHexString(uint256 value) internal pure returns (string memory) {
259         if (value == 0) {
260             return "0x00";
261         }
262         uint256 temp = value;
263         uint256 length = 0;
264         while (temp != 0) {
265             length++;
266             temp >>= 8;
267         }
268         return toHexString(value, length);
269     }
270 
271     /**
272      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
273      */
274     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
275         bytes memory buffer = new bytes(2 * length + 2);
276         buffer[0] = "0";
277         buffer[1] = "x";
278         for (uint256 i = 2 * length + 1; i > 1; --i) {
279             buffer[i] = _HEX_SYMBOLS[value & 0xf];
280             value >>= 4;
281         }
282         require(value == 0, "Strings: hex length insufficient");
283         return string(buffer);
284     }
285 
286     /**
287      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
288      */
289     function toHexString(address addr) internal pure returns (string memory) {
290         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
291     }
292 }
293 
294 // File: @openzeppelin/contracts/utils/Context.sol
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @dev Provides information about the current execution context, including the
303  * sender of the transaction and its data. While these are generally available
304  * via msg.sender and msg.data, they should not be accessed in such a direct
305  * manner, since when dealing with meta-transactions the account sending and
306  * paying for execution may not be the actual sender (as far as an application
307  * is concerned).
308  *
309  * This contract is only required for intermediate, library-like contracts.
310  */
311 abstract contract Context {
312     function _msgSender() internal view virtual returns (address) {
313         return msg.sender;
314     }
315 
316     function _msgData() internal view virtual returns (bytes calldata) {
317         return msg.data;
318     }
319 }
320 
321 // File: @openzeppelin/contracts/access/Ownable.sol
322 
323 
324 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
325 
326 pragma solidity ^0.8.0;
327 
328 
329 /**
330  * @dev Contract module which provides a basic access control mechanism, where
331  * there is an account (an owner) that can be granted exclusive access to
332  * specific functions.
333  *
334  * By default, the owner account will be the one that deploys the contract. This
335  * can later be changed with {transferOwnership}.
336  *
337  * This module is used through inheritance. It will make available the modifier
338  * `onlyOwner`, which can be applied to your functions to restrict their use to
339  * the owner.
340  */
341 abstract contract Ownable is Context {
342     address private _owner;
343 
344     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
345 
346     /**
347      * @dev Initializes the contract setting the deployer as the initial owner.
348      */
349     constructor() {
350         _transferOwnership(_msgSender());
351     }
352 
353     /**
354      * @dev Throws if called by any account other than the owner.
355      */
356     modifier onlyOwner() {
357         _checkOwner();
358         _;
359     }
360 
361     /**
362      * @dev Returns the address of the current owner.
363      */
364     function owner() public view virtual returns (address) {
365         return _owner;
366     }
367 
368     /**
369      * @dev Throws if the sender is not the owner.
370      */
371     function _checkOwner() internal view virtual {
372         require(owner() == _msgSender(), "Ownable: caller is not the owner");
373     }
374 
375     /**
376      * @dev Leaves the contract without owner. It will not be possible to call
377      * `onlyOwner` functions anymore. Can only be called by the current owner.
378      *
379      * NOTE: Renouncing ownership will leave the contract without an owner,
380      * thereby removing any functionality that is only available to the owner.
381      */
382     function renounceOwnership() public virtual onlyOwner {
383         _transferOwnership(address(0));
384     }
385 
386     /**
387      * @dev Transfers ownership of the contract to a new account (`newOwner`).
388      * Can only be called by the current owner.
389      */
390     function transferOwnership(address newOwner) public virtual onlyOwner {
391         require(newOwner != address(0), "Ownable: new owner is the zero address");
392         _transferOwnership(newOwner);
393     }
394 
395     /**
396      * @dev Transfers ownership of the contract to a new account (`newOwner`).
397      * Internal function without access restriction.
398      */
399     function _transferOwnership(address newOwner) internal virtual {
400         address oldOwner = _owner;
401         _owner = newOwner;
402         emit OwnershipTransferred(oldOwner, newOwner);
403     }
404 }
405 
406 // File: erc721a/contracts/IERC721A.sol
407 
408 
409 // ERC721A Contracts v4.2.3
410 // Creator: Chiru Labs
411 
412 pragma solidity ^0.8.4;
413 
414 /**
415  * @dev Interface of ERC721A.
416  */
417 interface IERC721A {
418     /**
419      * The caller must own the token or be an approved operator.
420      */
421     error ApprovalCallerNotOwnerNorApproved();
422 
423     /**
424      * The token does not exist.
425      */
426     error ApprovalQueryForNonexistentToken();
427 
428     /**
429      * Cannot query the balance for the zero address.
430      */
431     error BalanceQueryForZeroAddress();
432 
433     /**
434      * Cannot mint to the zero address.
435      */
436     error MintToZeroAddress();
437 
438     /**
439      * The quantity of tokens minted must be more than zero.
440      */
441     error MintZeroQuantity();
442 
443     /**
444      * The token does not exist.
445      */
446     error OwnerQueryForNonexistentToken();
447 
448     /**
449      * The caller must own the token or be an approved operator.
450      */
451     error TransferCallerNotOwnerNorApproved();
452 
453     /**
454      * The token must be owned by `from`.
455      */
456     error TransferFromIncorrectOwner();
457 
458     /**
459      * Cannot safely transfer to a contract that does not implement the
460      * ERC721Receiver interface.
461      */
462     error TransferToNonERC721ReceiverImplementer();
463 
464     /**
465      * Cannot transfer to the zero address.
466      */
467     error TransferToZeroAddress();
468 
469     /**
470      * The token does not exist.
471      */
472     error URIQueryForNonexistentToken();
473 
474     /**
475      * The `quantity` minted with ERC2309 exceeds the safety limit.
476      */
477     error MintERC2309QuantityExceedsLimit();
478 
479     /**
480      * The `extraData` cannot be set on an unintialized ownership slot.
481      */
482     error OwnershipNotInitializedForExtraData();
483 
484     // =============================================================
485     //                            STRUCTS
486     // =============================================================
487 
488     struct TokenOwnership {
489         // The address of the owner.
490         address addr;
491         // Stores the start time of ownership with minimal overhead for tokenomics.
492         uint64 startTimestamp;
493         // Whether the token has been burned.
494         bool burned;
495         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
496         uint24 extraData;
497     }
498 
499     // =============================================================
500     //                         TOKEN COUNTERS
501     // =============================================================
502 
503     /**
504      * @dev Returns the total number of tokens in existence.
505      * Burned tokens will reduce the count.
506      * To get the total number of tokens minted, please see {_totalMinted}.
507      */
508     function totalSupply() external view returns (uint256);
509 
510     // =============================================================
511     //                            IERC165
512     // =============================================================
513 
514     /**
515      * @dev Returns true if this contract implements the interface defined by
516      * `interfaceId`. See the corresponding
517      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
518      * to learn more about how these ids are created.
519      *
520      * This function call must use less than 30000 gas.
521      */
522     function supportsInterface(bytes4 interfaceId) external view returns (bool);
523 
524     // =============================================================
525     //                            IERC721
526     // =============================================================
527 
528     /**
529      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
530      */
531     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
532 
533     /**
534      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
535      */
536     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
537 
538     /**
539      * @dev Emitted when `owner` enables or disables
540      * (`approved`) `operator` to manage all of its assets.
541      */
542     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
543 
544     /**
545      * @dev Returns the number of tokens in `owner`'s account.
546      */
547     function balanceOf(address owner) external view returns (uint256 balance);
548 
549     /**
550      * @dev Returns the owner of the `tokenId` token.
551      *
552      * Requirements:
553      *
554      * - `tokenId` must exist.
555      */
556     function ownerOf(uint256 tokenId) external view returns (address owner);
557 
558     /**
559      * @dev Safely transfers `tokenId` token from `from` to `to`,
560      * checking first that contract recipients are aware of the ERC721 protocol
561      * to prevent tokens from being forever locked.
562      *
563      * Requirements:
564      *
565      * - `from` cannot be the zero address.
566      * - `to` cannot be the zero address.
567      * - `tokenId` token must exist and be owned by `from`.
568      * - If the caller is not `from`, it must be have been allowed to move
569      * this token by either {approve} or {setApprovalForAll}.
570      * - If `to` refers to a smart contract, it must implement
571      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
572      *
573      * Emits a {Transfer} event.
574      */
575     function safeTransferFrom(
576         address from,
577         address to,
578         uint256 tokenId,
579         bytes calldata data
580     ) external payable;
581 
582     /**
583      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
584      */
585     function safeTransferFrom(
586         address from,
587         address to,
588         uint256 tokenId
589     ) external payable;
590 
591     /**
592      * @dev Transfers `tokenId` from `from` to `to`.
593      *
594      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
595      * whenever possible.
596      *
597      * Requirements:
598      *
599      * - `from` cannot be the zero address.
600      * - `to` cannot be the zero address.
601      * - `tokenId` token must be owned by `from`.
602      * - If the caller is not `from`, it must be approved to move this token
603      * by either {approve} or {setApprovalForAll}.
604      *
605      * Emits a {Transfer} event.
606      */
607     function transferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) external payable;
612 
613     /**
614      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
615      * The approval is cleared when the token is transferred.
616      *
617      * Only a single account can be approved at a time, so approving the
618      * zero address clears previous approvals.
619      *
620      * Requirements:
621      *
622      * - The caller must own the token or be an approved operator.
623      * - `tokenId` must exist.
624      *
625      * Emits an {Approval} event.
626      */
627     function approve(address to, uint256 tokenId) external payable;
628 
629     /**
630      * @dev Approve or remove `operator` as an operator for the caller.
631      * Operators can call {transferFrom} or {safeTransferFrom}
632      * for any token owned by the caller.
633      *
634      * Requirements:
635      *
636      * - The `operator` cannot be the caller.
637      *
638      * Emits an {ApprovalForAll} event.
639      */
640     function setApprovalForAll(address operator, bool _approved) external;
641 
642     /**
643      * @dev Returns the account approved for `tokenId` token.
644      *
645      * Requirements:
646      *
647      * - `tokenId` must exist.
648      */
649     function getApproved(uint256 tokenId) external view returns (address operator);
650 
651     /**
652      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
653      *
654      * See {setApprovalForAll}.
655      */
656     function isApprovedForAll(address owner, address operator) external view returns (bool);
657 
658     // =============================================================
659     //                        IERC721Metadata
660     // =============================================================
661 
662     /**
663      * @dev Returns the token collection name.
664      */
665     function name() external view returns (string memory);
666 
667     /**
668      * @dev Returns the token collection symbol.
669      */
670     function symbol() external view returns (string memory);
671 
672     /**
673      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
674      */
675     function tokenURI(uint256 tokenId) external view returns (string memory);
676 
677     // =============================================================
678     //                           IERC2309
679     // =============================================================
680 
681     /**
682      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
683      * (inclusive) is transferred from `from` to `to`, as defined in the
684      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
685      *
686      * See {_mintERC2309} for more details.
687      */
688     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
689 }
690 
691 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
692 
693 
694 // ERC721A Contracts v4.2.3
695 // Creator: Chiru Labs
696 
697 pragma solidity ^0.8.4;
698 
699 
700 /**
701  * @dev Interface of ERC721AQueryable.
702  */
703 interface IERC721AQueryable is IERC721A {
704     /**
705      * Invalid query range (`start` >= `stop`).
706      */
707     error InvalidQueryRange();
708 
709     /**
710      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
711      *
712      * If the `tokenId` is out of bounds:
713      *
714      * - `addr = address(0)`
715      * - `startTimestamp = 0`
716      * - `burned = false`
717      * - `extraData = 0`
718      *
719      * If the `tokenId` is burned:
720      *
721      * - `addr = <Address of owner before token was burned>`
722      * - `startTimestamp = <Timestamp when token was burned>`
723      * - `burned = true`
724      * - `extraData = <Extra data when token was burned>`
725      *
726      * Otherwise:
727      *
728      * - `addr = <Address of owner>`
729      * - `startTimestamp = <Timestamp of start of ownership>`
730      * - `burned = false`
731      * - `extraData = <Extra data at start of ownership>`
732      */
733     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
734 
735     /**
736      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
737      * See {ERC721AQueryable-explicitOwnershipOf}
738      */
739     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
740 
741     /**
742      * @dev Returns an array of token IDs owned by `owner`,
743      * in the range [`start`, `stop`)
744      * (i.e. `start <= tokenId < stop`).
745      *
746      * This function allows for tokens to be queried if the collection
747      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
748      *
749      * Requirements:
750      *
751      * - `start < stop`
752      */
753     function tokensOfOwnerIn(
754         address owner,
755         uint256 start,
756         uint256 stop
757     ) external view returns (uint256[] memory);
758 
759     /**
760      * @dev Returns an array of token IDs owned by `owner`.
761      *
762      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
763      * It is meant to be called off-chain.
764      *
765      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
766      * multiple smaller scans if the collection is large enough to cause
767      * an out-of-gas error (10K collections should be fine).
768      */
769     function tokensOfOwner(address owner) external view returns (uint256[] memory);
770 }
771 
772 // File: erc721a/contracts/extensions/IERC721ABurnable.sol
773 
774 
775 // ERC721A Contracts v4.2.3
776 // Creator: Chiru Labs
777 
778 pragma solidity ^0.8.4;
779 
780 
781 /**
782  * @dev Interface of ERC721ABurnable.
783  */
784 interface IERC721ABurnable is IERC721A {
785     /**
786      * @dev Burns `tokenId`. See {ERC721A-_burn}.
787      *
788      * Requirements:
789      *
790      * - The caller must own `tokenId` or be an approved operator.
791      */
792     function burn(uint256 tokenId) external;
793 }
794 
795 // File: erc721a/contracts/ERC721A.sol
796 
797 
798 // ERC721A Contracts v4.2.3
799 // Creator: Chiru Labs
800 
801 pragma solidity ^0.8.4;
802 
803 
804 /**
805  * @dev Interface of ERC721 token receiver.
806  */
807 interface ERC721A__IERC721Receiver {
808     function onERC721Received(
809         address operator,
810         address from,
811         uint256 tokenId,
812         bytes calldata data
813     ) external returns (bytes4);
814 }
815 
816 /**
817  * @title ERC721A
818  *
819  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
820  * Non-Fungible Token Standard, including the Metadata extension.
821  * Optimized for lower gas during batch mints.
822  *
823  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
824  * starting from `_startTokenId()`.
825  *
826  * Assumptions:
827  *
828  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
829  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
830  */
831 contract ERC721A is IERC721A {
832     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
833     struct TokenApprovalRef {
834         address value;
835     }
836 
837     // =============================================================
838     //                           CONSTANTS
839     // =============================================================
840 
841     // Mask of an entry in packed address data.
842     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
843 
844     // The bit position of `numberMinted` in packed address data.
845     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
846 
847     // The bit position of `numberBurned` in packed address data.
848     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
849 
850     // The bit position of `aux` in packed address data.
851     uint256 private constant _BITPOS_AUX = 192;
852 
853     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
854     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
855 
856     // The bit position of `startTimestamp` in packed ownership.
857     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
858 
859     // The bit mask of the `burned` bit in packed ownership.
860     uint256 private constant _BITMASK_BURNED = 1 << 224;
861 
862     // The bit position of the `nextInitialized` bit in packed ownership.
863     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
864 
865     // The bit mask of the `nextInitialized` bit in packed ownership.
866     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
867 
868     // The bit position of `extraData` in packed ownership.
869     uint256 private constant _BITPOS_EXTRA_DATA = 232;
870 
871     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
872     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
873 
874     // The mask of the lower 160 bits for addresses.
875     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
876 
877     // The maximum `quantity` that can be minted with {_mintERC2309}.
878     // This limit is to prevent overflows on the address data entries.
879     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
880     // is required to cause an overflow, which is unrealistic.
881     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
882 
883     // The `Transfer` event signature is given by:
884     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
885     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
886         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
887 
888     // =============================================================
889     //                            STORAGE
890     // =============================================================
891 
892     // The next token ID to be minted.
893     uint256 private _currentIndex;
894 
895     // The number of tokens burned.
896     uint256 private _burnCounter;
897 
898     // Token name
899     string private _name;
900 
901     // Token symbol
902     string private _symbol;
903 
904     // Mapping from token ID to ownership details
905     // An empty struct value does not necessarily mean the token is unowned.
906     // See {_packedOwnershipOf} implementation for details.
907     //
908     // Bits Layout:
909     // - [0..159]   `addr`
910     // - [160..223] `startTimestamp`
911     // - [224]      `burned`
912     // - [225]      `nextInitialized`
913     // - [232..255] `extraData`
914     mapping(uint256 => uint256) private _packedOwnerships;
915 
916     // Mapping owner address to address data.
917     //
918     // Bits Layout:
919     // - [0..63]    `balance`
920     // - [64..127]  `numberMinted`
921     // - [128..191] `numberBurned`
922     // - [192..255] `aux`
923     mapping(address => uint256) private _packedAddressData;
924 
925     // Mapping from token ID to approved address.
926     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
927 
928     // Mapping from owner to operator approvals
929     mapping(address => mapping(address => bool)) private _operatorApprovals;
930 
931     // =============================================================
932     //                          CONSTRUCTOR
933     // =============================================================
934 
935     constructor(string memory name_, string memory symbol_) {
936         _name = name_;
937         _symbol = symbol_;
938         _currentIndex = _startTokenId();
939     }
940 
941     // =============================================================
942     //                   TOKEN COUNTING OPERATIONS
943     // =============================================================
944 
945     /**
946      * @dev Returns the starting token ID.
947      * To change the starting token ID, please override this function.
948      */
949     function _startTokenId() internal view virtual returns (uint256) {
950         return 0;
951     }
952 
953     /**
954      * @dev Returns the next token ID to be minted.
955      */
956     function _nextTokenId() internal view virtual returns (uint256) {
957         return _currentIndex;
958     }
959 
960     /**
961      * @dev Returns the total number of tokens in existence.
962      * Burned tokens will reduce the count.
963      * To get the total number of tokens minted, please see {_totalMinted}.
964      */
965     function totalSupply() public view virtual override returns (uint256) {
966         // Counter underflow is impossible as _burnCounter cannot be incremented
967         // more than `_currentIndex - _startTokenId()` times.
968         unchecked {
969             return _currentIndex - _burnCounter - _startTokenId();
970         }
971     }
972 
973     /**
974      * @dev Returns the total amount of tokens minted in the contract.
975      */
976     function _totalMinted() internal view virtual returns (uint256) {
977         // Counter underflow is impossible as `_currentIndex` does not decrement,
978         // and it is initialized to `_startTokenId()`.
979         unchecked {
980             return _currentIndex - _startTokenId();
981         }
982     }
983 
984     /**
985      * @dev Returns the total number of tokens burned.
986      */
987     function _totalBurned() internal view virtual returns (uint256) {
988         return _burnCounter;
989     }
990 
991     // =============================================================
992     //                    ADDRESS DATA OPERATIONS
993     // =============================================================
994 
995     /**
996      * @dev Returns the number of tokens in `owner`'s account.
997      */
998     function balanceOf(address owner) public view virtual override returns (uint256) {
999         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1000         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1001     }
1002 
1003     /**
1004      * Returns the number of tokens minted by `owner`.
1005      */
1006     function _numberMinted(address owner) internal view returns (uint256) {
1007         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1008     }
1009 
1010     /**
1011      * Returns the number of tokens burned by or on behalf of `owner`.
1012      */
1013     function _numberBurned(address owner) internal view returns (uint256) {
1014         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1015     }
1016 
1017     /**
1018      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1019      */
1020     function _getAux(address owner) internal view returns (uint64) {
1021         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1022     }
1023 
1024     /**
1025      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1026      * If there are multiple variables, please pack them into a uint64.
1027      */
1028     function _setAux(address owner, uint64 aux) internal virtual {
1029         uint256 packed = _packedAddressData[owner];
1030         uint256 auxCasted;
1031         // Cast `aux` with assembly to avoid redundant masking.
1032         assembly {
1033             auxCasted := aux
1034         }
1035         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1036         _packedAddressData[owner] = packed;
1037     }
1038 
1039     // =============================================================
1040     //                            IERC165
1041     // =============================================================
1042 
1043     /**
1044      * @dev Returns true if this contract implements the interface defined by
1045      * `interfaceId`. See the corresponding
1046      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1047      * to learn more about how these ids are created.
1048      *
1049      * This function call must use less than 30000 gas.
1050      */
1051     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1052         // The interface IDs are constants representing the first 4 bytes
1053         // of the XOR of all function selectors in the interface.
1054         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1055         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1056         return
1057             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1058             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1059             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1060     }
1061 
1062     // =============================================================
1063     //                        IERC721Metadata
1064     // =============================================================
1065 
1066     /**
1067      * @dev Returns the token collection name.
1068      */
1069     function name() public view virtual override returns (string memory) {
1070         return _name;
1071     }
1072 
1073     /**
1074      * @dev Returns the token collection symbol.
1075      */
1076     function symbol() public view virtual override returns (string memory) {
1077         return _symbol;
1078     }
1079 
1080     /**
1081      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1082      */
1083     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1084         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1085 
1086         string memory baseURI = _baseURI();
1087         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1088     }
1089 
1090     /**
1091      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1092      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1093      * by default, it can be overridden in child contracts.
1094      */
1095     function _baseURI() internal view virtual returns (string memory) {
1096         return '';
1097     }
1098 
1099     // =============================================================
1100     //                     OWNERSHIPS OPERATIONS
1101     // =============================================================
1102 
1103     /**
1104      * @dev Returns the owner of the `tokenId` token.
1105      *
1106      * Requirements:
1107      *
1108      * - `tokenId` must exist.
1109      */
1110     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1111         return address(uint160(_packedOwnershipOf(tokenId)));
1112     }
1113 
1114     /**
1115      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1116      * It gradually moves to O(1) as tokens get transferred around over time.
1117      */
1118     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1119         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1120     }
1121 
1122     /**
1123      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1124      */
1125     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1126         return _unpackedOwnership(_packedOwnerships[index]);
1127     }
1128 
1129     /**
1130      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1131      */
1132     function _initializeOwnershipAt(uint256 index) internal virtual {
1133         if (_packedOwnerships[index] == 0) {
1134             _packedOwnerships[index] = _packedOwnershipOf(index);
1135         }
1136     }
1137 
1138     /**
1139      * Returns the packed ownership data of `tokenId`.
1140      */
1141     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1142         uint256 curr = tokenId;
1143 
1144         unchecked {
1145             if (_startTokenId() <= curr)
1146                 if (curr < _currentIndex) {
1147                     uint256 packed = _packedOwnerships[curr];
1148                     // If not burned.
1149                     if (packed & _BITMASK_BURNED == 0) {
1150                         // Invariant:
1151                         // There will always be an initialized ownership slot
1152                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1153                         // before an unintialized ownership slot
1154                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1155                         // Hence, `curr` will not underflow.
1156                         //
1157                         // We can directly compare the packed value.
1158                         // If the address is zero, packed will be zero.
1159                         while (packed == 0) {
1160                             packed = _packedOwnerships[--curr];
1161                         }
1162                         return packed;
1163                     }
1164                 }
1165         }
1166         revert OwnerQueryForNonexistentToken();
1167     }
1168 
1169     /**
1170      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1171      */
1172     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1173         ownership.addr = address(uint160(packed));
1174         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1175         ownership.burned = packed & _BITMASK_BURNED != 0;
1176         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1177     }
1178 
1179     /**
1180      * @dev Packs ownership data into a single uint256.
1181      */
1182     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1183         assembly {
1184             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1185             owner := and(owner, _BITMASK_ADDRESS)
1186             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1187             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1188         }
1189     }
1190 
1191     /**
1192      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1193      */
1194     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1195         // For branchless setting of the `nextInitialized` flag.
1196         assembly {
1197             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1198             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1199         }
1200     }
1201 
1202     // =============================================================
1203     //                      APPROVAL OPERATIONS
1204     // =============================================================
1205 
1206     /**
1207      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1208      * The approval is cleared when the token is transferred.
1209      *
1210      * Only a single account can be approved at a time, so approving the
1211      * zero address clears previous approvals.
1212      *
1213      * Requirements:
1214      *
1215      * - The caller must own the token or be an approved operator.
1216      * - `tokenId` must exist.
1217      *
1218      * Emits an {Approval} event.
1219      */
1220     function approve(address to, uint256 tokenId) public payable virtual override {
1221         address owner = ownerOf(tokenId);
1222 
1223         if (_msgSenderERC721A() != owner)
1224             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1225                 revert ApprovalCallerNotOwnerNorApproved();
1226             }
1227 
1228         _tokenApprovals[tokenId].value = to;
1229         emit Approval(owner, to, tokenId);
1230     }
1231 
1232     /**
1233      * @dev Returns the account approved for `tokenId` token.
1234      *
1235      * Requirements:
1236      *
1237      * - `tokenId` must exist.
1238      */
1239     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1240         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1241 
1242         return _tokenApprovals[tokenId].value;
1243     }
1244 
1245     /**
1246      * @dev Approve or remove `operator` as an operator for the caller.
1247      * Operators can call {transferFrom} or {safeTransferFrom}
1248      * for any token owned by the caller.
1249      *
1250      * Requirements:
1251      *
1252      * - The `operator` cannot be the caller.
1253      *
1254      * Emits an {ApprovalForAll} event.
1255      */
1256     function setApprovalForAll(address operator, bool approved) public virtual override {
1257         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1258         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1259     }
1260 
1261     /**
1262      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1263      *
1264      * See {setApprovalForAll}.
1265      */
1266     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1267         return _operatorApprovals[owner][operator];
1268     }
1269 
1270     /**
1271      * @dev Returns whether `tokenId` exists.
1272      *
1273      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1274      *
1275      * Tokens start existing when they are minted. See {_mint}.
1276      */
1277     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1278         return
1279             _startTokenId() <= tokenId &&
1280             tokenId < _currentIndex && // If within bounds,
1281             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1282     }
1283 
1284     /**
1285      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1286      */
1287     function _isSenderApprovedOrOwner(
1288         address approvedAddress,
1289         address owner,
1290         address msgSender
1291     ) private pure returns (bool result) {
1292         assembly {
1293             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1294             owner := and(owner, _BITMASK_ADDRESS)
1295             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1296             msgSender := and(msgSender, _BITMASK_ADDRESS)
1297             // `msgSender == owner || msgSender == approvedAddress`.
1298             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1299         }
1300     }
1301 
1302     /**
1303      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1304      */
1305     function _getApprovedSlotAndAddress(uint256 tokenId)
1306         private
1307         view
1308         returns (uint256 approvedAddressSlot, address approvedAddress)
1309     {
1310         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1311         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1312         assembly {
1313             approvedAddressSlot := tokenApproval.slot
1314             approvedAddress := sload(approvedAddressSlot)
1315         }
1316     }
1317 
1318     // =============================================================
1319     //                      TRANSFER OPERATIONS
1320     // =============================================================
1321 
1322     /**
1323      * @dev Transfers `tokenId` from `from` to `to`.
1324      *
1325      * Requirements:
1326      *
1327      * - `from` cannot be the zero address.
1328      * - `to` cannot be the zero address.
1329      * - `tokenId` token must be owned by `from`.
1330      * - If the caller is not `from`, it must be approved to move this token
1331      * by either {approve} or {setApprovalForAll}.
1332      *
1333      * Emits a {Transfer} event.
1334      */
1335     function transferFrom(
1336         address from,
1337         address to,
1338         uint256 tokenId
1339     ) public payable virtual override {
1340         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1341 
1342         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1343 
1344         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1345 
1346         // The nested ifs save around 20+ gas over a compound boolean condition.
1347         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1348             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1349 
1350         if (to == address(0)) revert TransferToZeroAddress();
1351 
1352         _beforeTokenTransfers(from, to, tokenId, 1);
1353 
1354         // Clear approvals from the previous owner.
1355         assembly {
1356             if approvedAddress {
1357                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1358                 sstore(approvedAddressSlot, 0)
1359             }
1360         }
1361 
1362         // Underflow of the sender's balance is impossible because we check for
1363         // ownership above and the recipient's balance can't realistically overflow.
1364         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1365         unchecked {
1366             // We can directly increment and decrement the balances.
1367             --_packedAddressData[from]; // Updates: `balance -= 1`.
1368             ++_packedAddressData[to]; // Updates: `balance += 1`.
1369 
1370             // Updates:
1371             // - `address` to the next owner.
1372             // - `startTimestamp` to the timestamp of transfering.
1373             // - `burned` to `false`.
1374             // - `nextInitialized` to `true`.
1375             _packedOwnerships[tokenId] = _packOwnershipData(
1376                 to,
1377                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1378             );
1379 
1380             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1381             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1382                 uint256 nextTokenId = tokenId + 1;
1383                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1384                 if (_packedOwnerships[nextTokenId] == 0) {
1385                     // If the next slot is within bounds.
1386                     if (nextTokenId != _currentIndex) {
1387                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1388                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1389                     }
1390                 }
1391             }
1392         }
1393 
1394         emit Transfer(from, to, tokenId);
1395         _afterTokenTransfers(from, to, tokenId, 1);
1396     }
1397 
1398     /**
1399      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1400      */
1401     function safeTransferFrom(
1402         address from,
1403         address to,
1404         uint256 tokenId
1405     ) public payable virtual override {
1406         safeTransferFrom(from, to, tokenId, '');
1407     }
1408 
1409     /**
1410      * @dev Safely transfers `tokenId` token from `from` to `to`.
1411      *
1412      * Requirements:
1413      *
1414      * - `from` cannot be the zero address.
1415      * - `to` cannot be the zero address.
1416      * - `tokenId` token must exist and be owned by `from`.
1417      * - If the caller is not `from`, it must be approved to move this token
1418      * by either {approve} or {setApprovalForAll}.
1419      * - If `to` refers to a smart contract, it must implement
1420      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1421      *
1422      * Emits a {Transfer} event.
1423      */
1424     function safeTransferFrom(
1425         address from,
1426         address to,
1427         uint256 tokenId,
1428         bytes memory _data
1429     ) public payable virtual override {
1430         transferFrom(from, to, tokenId);
1431         if (to.code.length != 0)
1432             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1433                 revert TransferToNonERC721ReceiverImplementer();
1434             }
1435     }
1436 
1437     /**
1438      * @dev Hook that is called before a set of serially-ordered token IDs
1439      * are about to be transferred. This includes minting.
1440      * And also called before burning one token.
1441      *
1442      * `startTokenId` - the first token ID to be transferred.
1443      * `quantity` - the amount to be transferred.
1444      *
1445      * Calling conditions:
1446      *
1447      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1448      * transferred to `to`.
1449      * - When `from` is zero, `tokenId` will be minted for `to`.
1450      * - When `to` is zero, `tokenId` will be burned by `from`.
1451      * - `from` and `to` are never both zero.
1452      */
1453     function _beforeTokenTransfers(
1454         address from,
1455         address to,
1456         uint256 startTokenId,
1457         uint256 quantity
1458     ) internal virtual {}
1459 
1460     /**
1461      * @dev Hook that is called after a set of serially-ordered token IDs
1462      * have been transferred. This includes minting.
1463      * And also called after one token has been burned.
1464      *
1465      * `startTokenId` - the first token ID to be transferred.
1466      * `quantity` - the amount to be transferred.
1467      *
1468      * Calling conditions:
1469      *
1470      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1471      * transferred to `to`.
1472      * - When `from` is zero, `tokenId` has been minted for `to`.
1473      * - When `to` is zero, `tokenId` has been burned by `from`.
1474      * - `from` and `to` are never both zero.
1475      */
1476     function _afterTokenTransfers(
1477         address from,
1478         address to,
1479         uint256 startTokenId,
1480         uint256 quantity
1481     ) internal virtual {}
1482 
1483     /**
1484      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1485      *
1486      * `from` - Previous owner of the given token ID.
1487      * `to` - Target address that will receive the token.
1488      * `tokenId` - Token ID to be transferred.
1489      * `_data` - Optional data to send along with the call.
1490      *
1491      * Returns whether the call correctly returned the expected magic value.
1492      */
1493     function _checkContractOnERC721Received(
1494         address from,
1495         address to,
1496         uint256 tokenId,
1497         bytes memory _data
1498     ) private returns (bool) {
1499         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1500             bytes4 retval
1501         ) {
1502             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1503         } catch (bytes memory reason) {
1504             if (reason.length == 0) {
1505                 revert TransferToNonERC721ReceiverImplementer();
1506             } else {
1507                 assembly {
1508                     revert(add(32, reason), mload(reason))
1509                 }
1510             }
1511         }
1512     }
1513 
1514     // =============================================================
1515     //                        MINT OPERATIONS
1516     // =============================================================
1517 
1518     /**
1519      * @dev Mints `quantity` tokens and transfers them to `to`.
1520      *
1521      * Requirements:
1522      *
1523      * - `to` cannot be the zero address.
1524      * - `quantity` must be greater than 0.
1525      *
1526      * Emits a {Transfer} event for each mint.
1527      */
1528     function _mint(address to, uint256 quantity) internal virtual {
1529         uint256 startTokenId = _currentIndex;
1530         if (quantity == 0) revert MintZeroQuantity();
1531 
1532         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1533 
1534         // Overflows are incredibly unrealistic.
1535         // `balance` and `numberMinted` have a maximum limit of 2**64.
1536         // `tokenId` has a maximum limit of 2**256.
1537         unchecked {
1538             // Updates:
1539             // - `balance += quantity`.
1540             // - `numberMinted += quantity`.
1541             //
1542             // We can directly add to the `balance` and `numberMinted`.
1543             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1544 
1545             // Updates:
1546             // - `address` to the owner.
1547             // - `startTimestamp` to the timestamp of minting.
1548             // - `burned` to `false`.
1549             // - `nextInitialized` to `quantity == 1`.
1550             _packedOwnerships[startTokenId] = _packOwnershipData(
1551                 to,
1552                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1553             );
1554 
1555             uint256 toMasked;
1556             uint256 end = startTokenId + quantity;
1557 
1558             // Use assembly to loop and emit the `Transfer` event for gas savings.
1559             // The duplicated `log4` removes an extra check and reduces stack juggling.
1560             // The assembly, together with the surrounding Solidity code, have been
1561             // delicately arranged to nudge the compiler into producing optimized opcodes.
1562             assembly {
1563                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1564                 toMasked := and(to, _BITMASK_ADDRESS)
1565                 // Emit the `Transfer` event.
1566                 log4(
1567                     0, // Start of data (0, since no data).
1568                     0, // End of data (0, since no data).
1569                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1570                     0, // `address(0)`.
1571                     toMasked, // `to`.
1572                     startTokenId // `tokenId`.
1573                 )
1574 
1575                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1576                 // that overflows uint256 will make the loop run out of gas.
1577                 // The compiler will optimize the `iszero` away for performance.
1578                 for {
1579                     let tokenId := add(startTokenId, 1)
1580                 } iszero(eq(tokenId, end)) {
1581                     tokenId := add(tokenId, 1)
1582                 } {
1583                     // Emit the `Transfer` event. Similar to above.
1584                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1585                 }
1586             }
1587             if (toMasked == 0) revert MintToZeroAddress();
1588 
1589             _currentIndex = end;
1590         }
1591         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1592     }
1593 
1594     /**
1595      * @dev Mints `quantity` tokens and transfers them to `to`.
1596      *
1597      * This function is intended for efficient minting only during contract creation.
1598      *
1599      * It emits only one {ConsecutiveTransfer} as defined in
1600      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1601      * instead of a sequence of {Transfer} event(s).
1602      *
1603      * Calling this function outside of contract creation WILL make your contract
1604      * non-compliant with the ERC721 standard.
1605      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1606      * {ConsecutiveTransfer} event is only permissible during contract creation.
1607      *
1608      * Requirements:
1609      *
1610      * - `to` cannot be the zero address.
1611      * - `quantity` must be greater than 0.
1612      *
1613      * Emits a {ConsecutiveTransfer} event.
1614      */
1615     function _mintERC2309(address to, uint256 quantity) internal virtual {
1616         uint256 startTokenId = _currentIndex;
1617         if (to == address(0)) revert MintToZeroAddress();
1618         if (quantity == 0) revert MintZeroQuantity();
1619         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1620 
1621         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1622 
1623         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1624         unchecked {
1625             // Updates:
1626             // - `balance += quantity`.
1627             // - `numberMinted += quantity`.
1628             //
1629             // We can directly add to the `balance` and `numberMinted`.
1630             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1631 
1632             // Updates:
1633             // - `address` to the owner.
1634             // - `startTimestamp` to the timestamp of minting.
1635             // - `burned` to `false`.
1636             // - `nextInitialized` to `quantity == 1`.
1637             _packedOwnerships[startTokenId] = _packOwnershipData(
1638                 to,
1639                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1640             );
1641 
1642             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1643 
1644             _currentIndex = startTokenId + quantity;
1645         }
1646         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1647     }
1648 
1649     /**
1650      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1651      *
1652      * Requirements:
1653      *
1654      * - If `to` refers to a smart contract, it must implement
1655      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1656      * - `quantity` must be greater than 0.
1657      *
1658      * See {_mint}.
1659      *
1660      * Emits a {Transfer} event for each mint.
1661      */
1662     function _safeMint(
1663         address to,
1664         uint256 quantity,
1665         bytes memory _data
1666     ) internal virtual {
1667         _mint(to, quantity);
1668 
1669         unchecked {
1670             if (to.code.length != 0) {
1671                 uint256 end = _currentIndex;
1672                 uint256 index = end - quantity;
1673                 do {
1674                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1675                         revert TransferToNonERC721ReceiverImplementer();
1676                     }
1677                 } while (index < end);
1678                 // Reentrancy protection.
1679                 if (_currentIndex != end) revert();
1680             }
1681         }
1682     }
1683 
1684     /**
1685      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1686      */
1687     function _safeMint(address to, uint256 quantity) internal virtual {
1688         _safeMint(to, quantity, '');
1689     }
1690 
1691     // =============================================================
1692     //                        BURN OPERATIONS
1693     // =============================================================
1694 
1695     /**
1696      * @dev Equivalent to `_burn(tokenId, false)`.
1697      */
1698     function _burn(uint256 tokenId) internal virtual {
1699         _burn(tokenId, false);
1700     }
1701 
1702     /**
1703      * @dev Destroys `tokenId`.
1704      * The approval is cleared when the token is burned.
1705      *
1706      * Requirements:
1707      *
1708      * - `tokenId` must exist.
1709      *
1710      * Emits a {Transfer} event.
1711      */
1712     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1713         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1714 
1715         address from = address(uint160(prevOwnershipPacked));
1716 
1717         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1718 
1719         if (approvalCheck) {
1720             // The nested ifs save around 20+ gas over a compound boolean condition.
1721             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1722                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1723         }
1724 
1725         _beforeTokenTransfers(from, address(0), tokenId, 1);
1726 
1727         // Clear approvals from the previous owner.
1728         assembly {
1729             if approvedAddress {
1730                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1731                 sstore(approvedAddressSlot, 0)
1732             }
1733         }
1734 
1735         // Underflow of the sender's balance is impossible because we check for
1736         // ownership above and the recipient's balance can't realistically overflow.
1737         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1738         unchecked {
1739             // Updates:
1740             // - `balance -= 1`.
1741             // - `numberBurned += 1`.
1742             //
1743             // We can directly decrement the balance, and increment the number burned.
1744             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1745             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1746 
1747             // Updates:
1748             // - `address` to the last owner.
1749             // - `startTimestamp` to the timestamp of burning.
1750             // - `burned` to `true`.
1751             // - `nextInitialized` to `true`.
1752             _packedOwnerships[tokenId] = _packOwnershipData(
1753                 from,
1754                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1755             );
1756 
1757             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1758             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1759                 uint256 nextTokenId = tokenId + 1;
1760                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1761                 if (_packedOwnerships[nextTokenId] == 0) {
1762                     // If the next slot is within bounds.
1763                     if (nextTokenId != _currentIndex) {
1764                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1765                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1766                     }
1767                 }
1768             }
1769         }
1770 
1771         emit Transfer(from, address(0), tokenId);
1772         _afterTokenTransfers(from, address(0), tokenId, 1);
1773 
1774         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1775         unchecked {
1776             _burnCounter++;
1777         }
1778     }
1779 
1780     // =============================================================
1781     //                     EXTRA DATA OPERATIONS
1782     // =============================================================
1783 
1784     /**
1785      * @dev Directly sets the extra data for the ownership data `index`.
1786      */
1787     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1788         uint256 packed = _packedOwnerships[index];
1789         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1790         uint256 extraDataCasted;
1791         // Cast `extraData` with assembly to avoid redundant masking.
1792         assembly {
1793             extraDataCasted := extraData
1794         }
1795         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1796         _packedOwnerships[index] = packed;
1797     }
1798 
1799     /**
1800      * @dev Called during each token transfer to set the 24bit `extraData` field.
1801      * Intended to be overridden by the cosumer contract.
1802      *
1803      * `previousExtraData` - the value of `extraData` before transfer.
1804      *
1805      * Calling conditions:
1806      *
1807      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1808      * transferred to `to`.
1809      * - When `from` is zero, `tokenId` will be minted for `to`.
1810      * - When `to` is zero, `tokenId` will be burned by `from`.
1811      * - `from` and `to` are never both zero.
1812      */
1813     function _extraData(
1814         address from,
1815         address to,
1816         uint24 previousExtraData
1817     ) internal view virtual returns (uint24) {}
1818 
1819     /**
1820      * @dev Returns the next extra data for the packed ownership data.
1821      * The returned result is shifted into position.
1822      */
1823     function _nextExtraData(
1824         address from,
1825         address to,
1826         uint256 prevOwnershipPacked
1827     ) private view returns (uint256) {
1828         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1829         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1830     }
1831 
1832     // =============================================================
1833     //                       OTHER OPERATIONS
1834     // =============================================================
1835 
1836     /**
1837      * @dev Returns the message sender (defaults to `msg.sender`).
1838      *
1839      * If you are writing GSN compatible contracts, you need to override this function.
1840      */
1841     function _msgSenderERC721A() internal view virtual returns (address) {
1842         return msg.sender;
1843     }
1844 
1845     /**
1846      * @dev Converts a uint256 to its ASCII string decimal representation.
1847      */
1848     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1849         assembly {
1850             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1851             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1852             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1853             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1854             let m := add(mload(0x40), 0xa0)
1855             // Update the free memory pointer to allocate.
1856             mstore(0x40, m)
1857             // Assign the `str` to the end.
1858             str := sub(m, 0x20)
1859             // Zeroize the slot after the string.
1860             mstore(str, 0)
1861 
1862             // Cache the end of the memory to calculate the length later.
1863             let end := str
1864 
1865             // We write the string from rightmost digit to leftmost digit.
1866             // The following is essentially a do-while loop that also handles the zero case.
1867             // prettier-ignore
1868             for { let temp := value } 1 {} {
1869                 str := sub(str, 1)
1870                 // Write the character to the pointer.
1871                 // The ASCII index of the '0' character is 48.
1872                 mstore8(str, add(48, mod(temp, 10)))
1873                 // Keep dividing `temp` until zero.
1874                 temp := div(temp, 10)
1875                 // prettier-ignore
1876                 if iszero(temp) { break }
1877             }
1878 
1879             let length := sub(end, str)
1880             // Move the pointer 32 bytes leftwards to make room for the length.
1881             str := sub(str, 0x20)
1882             // Store the length.
1883             mstore(str, length)
1884         }
1885     }
1886 }
1887 
1888 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1889 
1890 
1891 // ERC721A Contracts v4.2.3
1892 // Creator: Chiru Labs
1893 
1894 pragma solidity ^0.8.4;
1895 
1896 
1897 
1898 /**
1899  * @title ERC721AQueryable.
1900  *
1901  * @dev ERC721A subclass with convenience query functions.
1902  */
1903 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1904     /**
1905      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1906      *
1907      * If the `tokenId` is out of bounds:
1908      *
1909      * - `addr = address(0)`
1910      * - `startTimestamp = 0`
1911      * - `burned = false`
1912      * - `extraData = 0`
1913      *
1914      * If the `tokenId` is burned:
1915      *
1916      * - `addr = <Address of owner before token was burned>`
1917      * - `startTimestamp = <Timestamp when token was burned>`
1918      * - `burned = true`
1919      * - `extraData = <Extra data when token was burned>`
1920      *
1921      * Otherwise:
1922      *
1923      * - `addr = <Address of owner>`
1924      * - `startTimestamp = <Timestamp of start of ownership>`
1925      * - `burned = false`
1926      * - `extraData = <Extra data at start of ownership>`
1927      */
1928     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1929         TokenOwnership memory ownership;
1930         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1931             return ownership;
1932         }
1933         ownership = _ownershipAt(tokenId);
1934         if (ownership.burned) {
1935             return ownership;
1936         }
1937         return _ownershipOf(tokenId);
1938     }
1939 
1940     /**
1941      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1942      * See {ERC721AQueryable-explicitOwnershipOf}
1943      */
1944     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1945         external
1946         view
1947         virtual
1948         override
1949         returns (TokenOwnership[] memory)
1950     {
1951         unchecked {
1952             uint256 tokenIdsLength = tokenIds.length;
1953             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1954             for (uint256 i; i != tokenIdsLength; ++i) {
1955                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1956             }
1957             return ownerships;
1958         }
1959     }
1960 
1961     /**
1962      * @dev Returns an array of token IDs owned by `owner`,
1963      * in the range [`start`, `stop`)
1964      * (i.e. `start <= tokenId < stop`).
1965      *
1966      * This function allows for tokens to be queried if the collection
1967      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1968      *
1969      * Requirements:
1970      *
1971      * - `start < stop`
1972      */
1973     function tokensOfOwnerIn(
1974         address owner,
1975         uint256 start,
1976         uint256 stop
1977     ) external view virtual override returns (uint256[] memory) {
1978         unchecked {
1979             if (start >= stop) revert InvalidQueryRange();
1980             uint256 tokenIdsIdx;
1981             uint256 stopLimit = _nextTokenId();
1982             // Set `start = max(start, _startTokenId())`.
1983             if (start < _startTokenId()) {
1984                 start = _startTokenId();
1985             }
1986             // Set `stop = min(stop, stopLimit)`.
1987             if (stop > stopLimit) {
1988                 stop = stopLimit;
1989             }
1990             uint256 tokenIdsMaxLength = balanceOf(owner);
1991             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1992             // to cater for cases where `balanceOf(owner)` is too big.
1993             if (start < stop) {
1994                 uint256 rangeLength = stop - start;
1995                 if (rangeLength < tokenIdsMaxLength) {
1996                     tokenIdsMaxLength = rangeLength;
1997                 }
1998             } else {
1999                 tokenIdsMaxLength = 0;
2000             }
2001             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2002             if (tokenIdsMaxLength == 0) {
2003                 return tokenIds;
2004             }
2005             // We need to call `explicitOwnershipOf(start)`,
2006             // because the slot at `start` may not be initialized.
2007             TokenOwnership memory ownership = explicitOwnershipOf(start);
2008             address currOwnershipAddr;
2009             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2010             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2011             if (!ownership.burned) {
2012                 currOwnershipAddr = ownership.addr;
2013             }
2014             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2015                 ownership = _ownershipAt(i);
2016                 if (ownership.burned) {
2017                     continue;
2018                 }
2019                 if (ownership.addr != address(0)) {
2020                     currOwnershipAddr = ownership.addr;
2021                 }
2022                 if (currOwnershipAddr == owner) {
2023                     tokenIds[tokenIdsIdx++] = i;
2024                 }
2025             }
2026             // Downsize the array to fit.
2027             assembly {
2028                 mstore(tokenIds, tokenIdsIdx)
2029             }
2030             return tokenIds;
2031         }
2032     }
2033 
2034     /**
2035      * @dev Returns an array of token IDs owned by `owner`.
2036      *
2037      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2038      * It is meant to be called off-chain.
2039      *
2040      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2041      * multiple smaller scans if the collection is large enough to cause
2042      * an out-of-gas error (10K collections should be fine).
2043      */
2044     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2045         unchecked {
2046             uint256 tokenIdsIdx;
2047             address currOwnershipAddr;
2048             uint256 tokenIdsLength = balanceOf(owner);
2049             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2050             TokenOwnership memory ownership;
2051             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2052                 ownership = _ownershipAt(i);
2053                 if (ownership.burned) {
2054                     continue;
2055                 }
2056                 if (ownership.addr != address(0)) {
2057                     currOwnershipAddr = ownership.addr;
2058                 }
2059                 if (currOwnershipAddr == owner) {
2060                     tokenIds[tokenIdsIdx++] = i;
2061                 }
2062             }
2063             return tokenIds;
2064         }
2065     }
2066 }
2067 
2068 // File: erc721a/contracts/extensions/ERC721ABurnable.sol
2069 
2070 
2071 // ERC721A Contracts v4.2.3
2072 // Creator: Chiru Labs
2073 
2074 pragma solidity ^0.8.4;
2075 
2076 
2077 
2078 /**
2079  * @title ERC721ABurnable.
2080  *
2081  * @dev ERC721A token that can be irreversibly burned (destroyed).
2082  */
2083 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
2084     /**
2085      * @dev Burns `tokenId`. See {ERC721A-_burn}.
2086      *
2087      * Requirements:
2088      *
2089      * - The caller must own `tokenId` or be an approved operator.
2090      */
2091     function burn(uint256 tokenId) public virtual override {
2092         _burn(tokenId, true);
2093     }
2094 }
2095 
2096 // File: contracts/mintingGodly.sol
2097 
2098 
2099 
2100 pragma solidity ^0.8.10;
2101 
2102 
2103 
2104 
2105 
2106 
2107 
2108 contract TheGodlyNFT is ERC721A, ERC721ABurnable, ERC721AQueryable, Ownable {
2109 
2110       string private _baseTokenURI;
2111       using Strings for uint256;
2112 
2113       uint256 public maxSupply = 6969;
2114       uint256 public maxWLSupply = 5000;
2115       uint256 public freeSupply = 1000;
2116       uint256 public mintPerTrx = 3;
2117       uint256 public mintPerAcc = 3;
2118       uint256 public freePerAcc = 1;
2119       uint256 public pubPrice = 0.015 ether;
2120       uint256 public wlPrice = 0.0099 ether;
2121       bytes32 public merkleRoot;
2122       bool public pubStat;
2123       bool public wlStat;
2124 
2125     constructor() ERC721A("TheGodlyNFT", "TGN") {}
2126 
2127     function publicMint(uint256 _quantity) external payable {
2128         require(pubStat, "Public mint is not active");
2129         require(_quantity > 0, "Incorrect Quantity");
2130         require(_quantity <= mintPerTrx, "Over amount per trx");
2131         require(_numberMinted(msg.sender) + _quantity <= mintPerAcc,"No more tokens for you");
2132         require(_totalMinted() + _quantity <= maxSupply, "Reached max supply");
2133         require(msg.value >= pubPrice * _quantity, "Need more tokens");
2134 
2135       _safeMint(msg.sender, _quantity);
2136     }
2137 
2138     function whitelistMint(bytes32[] calldata _merkleProof, uint256 _quantity) external payable {
2139         uint nftPrice = wlPrice;
2140         require(wlStat, "Whitelist mint is not active");
2141         require(_quantity > 0, "Incorrect Quantity");
2142         require(_quantity <= mintPerTrx, "Over amount per trx");
2143         require(_numberMinted(msg.sender) + _quantity <= mintPerAcc,"No more tokens for you");
2144         require(_totalMinted() + _quantity <= maxWLSupply, "Reached max WL supply");
2145         require(checkProof(_merkleProof), "Invalid proof");
2146          if(_totalMinted() + _quantity <= freeSupply && _numberMinted(msg.sender) + _quantity <= freePerAcc){
2147           nftPrice = 0;
2148         }
2149         require(msg.value >= nftPrice * _quantity, "Need more tokens");
2150      
2151       _safeMint(msg.sender, _quantity);
2152     }
2153 
2154     function setMaxSupply(uint256 _maxSupply) public onlyOwner{
2155       maxSupply = _maxSupply;
2156     }
2157 
2158     function setMaxWLSupply(uint256 _maxWLSupply) public onlyOwner{
2159       maxWLSupply = _maxWLSupply;
2160     }
2161 
2162     function setFreeSupply(uint256 _freeSupply) public onlyOwner{
2163       freeSupply = _freeSupply;
2164     }
2165 
2166     function setMintPerTrx(uint256 _mintPerTrx) public onlyOwner{
2167       mintPerTrx = _mintPerTrx;
2168     }
2169 
2170     function setMintPerAcc(uint256 _mintPerAcc) public onlyOwner{
2171       mintPerAcc = _mintPerAcc;
2172     }
2173 
2174     function setFreePerAcc(uint256 _freePerAcc) public onlyOwner{
2175       freePerAcc = _freePerAcc;
2176     }
2177 
2178     function setPubPrice(uint256 _pubPrice) public onlyOwner{
2179       pubPrice = _pubPrice;
2180     }
2181 
2182     function setWlPrice(uint256 _wlPrice) public onlyOwner{
2183       wlPrice = _wlPrice;
2184     }
2185 
2186     function setPubStat() public onlyOwner {
2187       pubStat = !pubStat; 
2188     }
2189 
2190     function setWlStat() public onlyOwner {
2191       wlStat = !wlStat; 
2192     }
2193 
2194     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2195         merkleRoot = _merkleRoot;
2196     }
2197 
2198     function teamMint( uint256 quantity) public payable onlyOwner {
2199         require(_totalMinted() + quantity <= maxSupply);
2200         _safeMint(msg.sender, quantity);
2201     }
2202 
2203     function teamDrop( address to, uint256 airSupply) public payable onlyOwner {
2204       require(_totalMinted() + airSupply <= maxSupply);
2205         _safeMint(to, airSupply);
2206     }
2207 
2208     function _baseURI() internal view virtual override returns (string memory) {
2209       return _baseTokenURI;
2210     }
2211     
2212     function setBaseURI(string calldata baseURI) public onlyOwner {
2213       _baseTokenURI = baseURI;
2214     }
2215 
2216     function tokenURI(uint256 tokenId)
2217       public
2218       view
2219       virtual
2220       override
2221       returns (string memory)
2222     {
2223       require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
2224       string memory currentBaseURI = _baseURI();
2225       return bytes(currentBaseURI).length > 0
2226           ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
2227           : "";
2228     }
2229 
2230     function checkProof(bytes32[] calldata _merkleProof) public view returns (bool){
2231         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2232         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Incorrect proof");
2233         return true; 
2234     }
2235 
2236     function totalMinted() public view returns(uint256){
2237       return _totalMinted();
2238     }
2239 
2240     function withdraw() public onlyOwner {
2241       payable(msg.sender).transfer(payable(address(this)).balance);   
2242     }
2243 
2244     function withdrawAmount(uint256 _amount) public onlyOwner{
2245        (bool success, ) = payable(msg.sender).call{value: _amount}("");
2246         require(success);
2247     }
2248 
2249      function burnToCrisp(uint256 tokenId) public onlyOwner {
2250         require(_exists(tokenId), "Token does not exist");
2251         _burn(tokenId);
2252     }
2253 
2254     function checkBurn() public view returns(uint256){
2255       return _totalBurned();
2256     }
2257 }