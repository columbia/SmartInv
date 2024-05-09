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
409 // ERC721A Contracts v4.1.0
410 // Creator: Chiru Labs
411 
412 pragma solidity ^0.8.4;
413 
414 /**
415  * @dev Interface of an ERC721A compliant contract.
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
429      * The caller cannot approve to their own address.
430      */
431     error ApproveToCaller();
432 
433     /**
434      * Cannot query the balance for the zero address.
435      */
436     error BalanceQueryForZeroAddress();
437 
438     /**
439      * Cannot mint to the zero address.
440      */
441     error MintToZeroAddress();
442 
443     /**
444      * The quantity of tokens minted must be more than zero.
445      */
446     error MintZeroQuantity();
447 
448     /**
449      * The token does not exist.
450      */
451     error OwnerQueryForNonexistentToken();
452 
453     /**
454      * The caller must own the token or be an approved operator.
455      */
456     error TransferCallerNotOwnerNorApproved();
457 
458     /**
459      * The token must be owned by `from`.
460      */
461     error TransferFromIncorrectOwner();
462 
463     /**
464      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
465      */
466     error TransferToNonERC721ReceiverImplementer();
467 
468     /**
469      * Cannot transfer to the zero address.
470      */
471     error TransferToZeroAddress();
472 
473     /**
474      * The token does not exist.
475      */
476     error URIQueryForNonexistentToken();
477 
478     /**
479      * The `quantity` minted with ERC2309 exceeds the safety limit.
480      */
481     error MintERC2309QuantityExceedsLimit();
482 
483     /**
484      * The `extraData` cannot be set on an unintialized ownership slot.
485      */
486     error OwnershipNotInitializedForExtraData();
487 
488     struct TokenOwnership {
489         // The address of the owner.
490         address addr;
491         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
492         uint64 startTimestamp;
493         // Whether the token has been burned.
494         bool burned;
495         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
496         uint24 extraData;
497     }
498 
499     /**
500      * @dev Returns the total amount of tokens stored by the contract.
501      *
502      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
503      */
504     function totalSupply() external view returns (uint256);
505 
506     // ==============================
507     //            IERC165
508     // ==============================
509 
510     /**
511      * @dev Returns true if this contract implements the interface defined by
512      * `interfaceId`. See the corresponding
513      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
514      * to learn more about how these ids are created.
515      *
516      * This function call must use less than 30 000 gas.
517      */
518     function supportsInterface(bytes4 interfaceId) external view returns (bool);
519 
520     // ==============================
521     //            IERC721
522     // ==============================
523 
524     /**
525      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
526      */
527     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
528 
529     /**
530      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
531      */
532     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
533 
534     /**
535      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
536      */
537     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
538 
539     /**
540      * @dev Returns the number of tokens in ``owner``'s account.
541      */
542     function balanceOf(address owner) external view returns (uint256 balance);
543 
544     /**
545      * @dev Returns the owner of the `tokenId` token.
546      *
547      * Requirements:
548      *
549      * - `tokenId` must exist.
550      */
551     function ownerOf(uint256 tokenId) external view returns (address owner);
552 
553     /**
554      * @dev Safely transfers `tokenId` token from `from` to `to`.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must exist and be owned by `from`.
561      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
562      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
563      *
564      * Emits a {Transfer} event.
565      */
566     function safeTransferFrom(
567         address from,
568         address to,
569         uint256 tokenId,
570         bytes calldata data
571     ) external;
572 
573     /**
574      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
575      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
576      *
577      * Requirements:
578      *
579      * - `from` cannot be the zero address.
580      * - `to` cannot be the zero address.
581      * - `tokenId` token must exist and be owned by `from`.
582      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
583      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
584      *
585      * Emits a {Transfer} event.
586      */
587     function safeTransferFrom(
588         address from,
589         address to,
590         uint256 tokenId
591     ) external;
592 
593     /**
594      * @dev Transfers `tokenId` token from `from` to `to`.
595      *
596      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
597      *
598      * Requirements:
599      *
600      * - `from` cannot be the zero address.
601      * - `to` cannot be the zero address.
602      * - `tokenId` token must be owned by `from`.
603      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
604      *
605      * Emits a {Transfer} event.
606      */
607     function transferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) external;
612 
613     /**
614      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
615      * The approval is cleared when the token is transferred.
616      *
617      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
618      *
619      * Requirements:
620      *
621      * - The caller must own the token or be an approved operator.
622      * - `tokenId` must exist.
623      *
624      * Emits an {Approval} event.
625      */
626     function approve(address to, uint256 tokenId) external;
627 
628     /**
629      * @dev Approve or remove `operator` as an operator for the caller.
630      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
631      *
632      * Requirements:
633      *
634      * - The `operator` cannot be the caller.
635      *
636      * Emits an {ApprovalForAll} event.
637      */
638     function setApprovalForAll(address operator, bool _approved) external;
639 
640     /**
641      * @dev Returns the account approved for `tokenId` token.
642      *
643      * Requirements:
644      *
645      * - `tokenId` must exist.
646      */
647     function getApproved(uint256 tokenId) external view returns (address operator);
648 
649     /**
650      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
651      *
652      * See {setApprovalForAll}
653      */
654     function isApprovedForAll(address owner, address operator) external view returns (bool);
655 
656     // ==============================
657     //        IERC721Metadata
658     // ==============================
659 
660     /**
661      * @dev Returns the token collection name.
662      */
663     function name() external view returns (string memory);
664 
665     /**
666      * @dev Returns the token collection symbol.
667      */
668     function symbol() external view returns (string memory);
669 
670     /**
671      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
672      */
673     function tokenURI(uint256 tokenId) external view returns (string memory);
674 
675     // ==============================
676     //            IERC2309
677     // ==============================
678 
679     /**
680      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
681      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
682      */
683     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
684 }
685 
686 // File: erc721a/contracts/ERC721A.sol
687 
688 
689 // ERC721A Contracts v4.1.0
690 // Creator: Chiru Labs
691 
692 pragma solidity ^0.8.4;
693 
694 
695 /**
696  * @dev ERC721 token receiver interface.
697  */
698 interface ERC721A__IERC721Receiver {
699     function onERC721Received(
700         address operator,
701         address from,
702         uint256 tokenId,
703         bytes calldata data
704     ) external returns (bytes4);
705 }
706 
707 /**
708  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
709  * including the Metadata extension. Built to optimize for lower gas during batch mints.
710  *
711  * Assumes serials are sequentially minted starting at `_startTokenId()`
712  * (defaults to 0, e.g. 0, 1, 2, 3..).
713  *
714  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
715  *
716  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
717  */
718 contract ERC721A is IERC721A {
719     // Mask of an entry in packed address data.
720     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
721 
722     // The bit position of `numberMinted` in packed address data.
723     uint256 private constant BITPOS_NUMBER_MINTED = 64;
724 
725     // The bit position of `numberBurned` in packed address data.
726     uint256 private constant BITPOS_NUMBER_BURNED = 128;
727 
728     // The bit position of `aux` in packed address data.
729     uint256 private constant BITPOS_AUX = 192;
730 
731     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
732     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
733 
734     // The bit position of `startTimestamp` in packed ownership.
735     uint256 private constant BITPOS_START_TIMESTAMP = 160;
736 
737     // The bit mask of the `burned` bit in packed ownership.
738     uint256 private constant BITMASK_BURNED = 1 << 224;
739 
740     // The bit position of the `nextInitialized` bit in packed ownership.
741     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
742 
743     // The bit mask of the `nextInitialized` bit in packed ownership.
744     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
745 
746     // The bit position of `extraData` in packed ownership.
747     uint256 private constant BITPOS_EXTRA_DATA = 232;
748 
749     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
750     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
751 
752     // The mask of the lower 160 bits for addresses.
753     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
754 
755     // The maximum `quantity` that can be minted with `_mintERC2309`.
756     // This limit is to prevent overflows on the address data entries.
757     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
758     // is required to cause an overflow, which is unrealistic.
759     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
760 
761     // The tokenId of the next token to be minted.
762     uint256 private _currentIndex;
763 
764     // The number of tokens burned.
765     uint256 private _burnCounter;
766 
767     // Token name
768     string private _name;
769 
770     // Token symbol
771     string private _symbol;
772 
773     // Mapping from token ID to ownership details
774     // An empty struct value does not necessarily mean the token is unowned.
775     // See `_packedOwnershipOf` implementation for details.
776     //
777     // Bits Layout:
778     // - [0..159]   `addr`
779     // - [160..223] `startTimestamp`
780     // - [224]      `burned`
781     // - [225]      `nextInitialized`
782     // - [232..255] `extraData`
783     mapping(uint256 => uint256) private _packedOwnerships;
784 
785     // Mapping owner address to address data.
786     //
787     // Bits Layout:
788     // - [0..63]    `balance`
789     // - [64..127]  `numberMinted`
790     // - [128..191] `numberBurned`
791     // - [192..255] `aux`
792     mapping(address => uint256) private _packedAddressData;
793 
794     // Mapping from token ID to approved address.
795     mapping(uint256 => address) private _tokenApprovals;
796 
797     // Mapping from owner to operator approvals
798     mapping(address => mapping(address => bool)) private _operatorApprovals;
799 
800     constructor(string memory name_, string memory symbol_) {
801         _name = name_;
802         _symbol = symbol_;
803         _currentIndex = _startTokenId();
804     }
805 
806     /**
807      * @dev Returns the starting token ID.
808      * To change the starting token ID, please override this function.
809      */
810     function _startTokenId() internal view virtual returns (uint256) {
811         return 0;
812     }
813 
814     /**
815      * @dev Returns the next token ID to be minted.
816      */
817     function _nextTokenId() internal view returns (uint256) {
818         return _currentIndex;
819     }
820 
821     /**
822      * @dev Returns the total number of tokens in existence.
823      * Burned tokens will reduce the count.
824      * To get the total number of tokens minted, please see `_totalMinted`.
825      */
826     function totalSupply() public view override returns (uint256) {
827         // Counter underflow is impossible as _burnCounter cannot be incremented
828         // more than `_currentIndex - _startTokenId()` times.
829         unchecked {
830             return _currentIndex - _burnCounter - _startTokenId();
831         }
832     }
833 
834     /**
835      * @dev Returns the total amount of tokens minted in the contract.
836      */
837     function _totalMinted() internal view returns (uint256) {
838         // Counter underflow is impossible as _currentIndex does not decrement,
839         // and it is initialized to `_startTokenId()`
840         unchecked {
841             return _currentIndex - _startTokenId();
842         }
843     }
844 
845     /**
846      * @dev Returns the total number of tokens burned.
847      */
848     function _totalBurned() internal view returns (uint256) {
849         return _burnCounter;
850     }
851 
852     /**
853      * @dev See {IERC165-supportsInterface}.
854      */
855     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
856         // The interface IDs are constants representing the first 4 bytes of the XOR of
857         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
858         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
859         return
860             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
861             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
862             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
863     }
864 
865     /**
866      * @dev See {IERC721-balanceOf}.
867      */
868     function balanceOf(address owner) public view override returns (uint256) {
869         if (owner == address(0)) revert BalanceQueryForZeroAddress();
870         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
871     }
872 
873     /**
874      * Returns the number of tokens minted by `owner`.
875      */
876     function _numberMinted(address owner) internal view returns (uint256) {
877         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
878     }
879 
880     /**
881      * Returns the number of tokens burned by or on behalf of `owner`.
882      */
883     function _numberBurned(address owner) internal view returns (uint256) {
884         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
885     }
886 
887     /**
888      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
889      */
890     function _getAux(address owner) internal view returns (uint64) {
891         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
892     }
893 
894     /**
895      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
896      * If there are multiple variables, please pack them into a uint64.
897      */
898     function _setAux(address owner, uint64 aux) internal {
899         uint256 packed = _packedAddressData[owner];
900         uint256 auxCasted;
901         // Cast `aux` with assembly to avoid redundant masking.
902         assembly {
903             auxCasted := aux
904         }
905         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
906         _packedAddressData[owner] = packed;
907     }
908 
909     /**
910      * Returns the packed ownership data of `tokenId`.
911      */
912     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
913         uint256 curr = tokenId;
914 
915         unchecked {
916             if (_startTokenId() <= curr)
917                 if (curr < _currentIndex) {
918                     uint256 packed = _packedOwnerships[curr];
919                     // If not burned.
920                     if (packed & BITMASK_BURNED == 0) {
921                         // Invariant:
922                         // There will always be an ownership that has an address and is not burned
923                         // before an ownership that does not have an address and is not burned.
924                         // Hence, curr will not underflow.
925                         //
926                         // We can directly compare the packed value.
927                         // If the address is zero, packed is zero.
928                         while (packed == 0) {
929                             packed = _packedOwnerships[--curr];
930                         }
931                         return packed;
932                     }
933                 }
934         }
935         revert OwnerQueryForNonexistentToken();
936     }
937 
938     /**
939      * Returns the unpacked `TokenOwnership` struct from `packed`.
940      */
941     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
942         ownership.addr = address(uint160(packed));
943         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
944         ownership.burned = packed & BITMASK_BURNED != 0;
945         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
946     }
947 
948     /**
949      * Returns the unpacked `TokenOwnership` struct at `index`.
950      */
951     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
952         return _unpackedOwnership(_packedOwnerships[index]);
953     }
954 
955     /**
956      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
957      */
958     function _initializeOwnershipAt(uint256 index) internal {
959         if (_packedOwnerships[index] == 0) {
960             _packedOwnerships[index] = _packedOwnershipOf(index);
961         }
962     }
963 
964     /**
965      * Gas spent here starts off proportional to the maximum mint batch size.
966      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
967      */
968     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
969         return _unpackedOwnership(_packedOwnershipOf(tokenId));
970     }
971 
972     /**
973      * @dev Packs ownership data into a single uint256.
974      */
975     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
976         assembly {
977             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
978             owner := and(owner, BITMASK_ADDRESS)
979             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
980             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
981         }
982     }
983 
984     /**
985      * @dev See {IERC721-ownerOf}.
986      */
987     function ownerOf(uint256 tokenId) public view override returns (address) {
988         return address(uint160(_packedOwnershipOf(tokenId)));
989     }
990 
991     /**
992      * @dev See {IERC721Metadata-name}.
993      */
994     function name() public view virtual override returns (string memory) {
995         return _name;
996     }
997 
998     /**
999      * @dev See {IERC721Metadata-symbol}.
1000      */
1001     function symbol() public view virtual override returns (string memory) {
1002         return _symbol;
1003     }
1004 
1005     /**
1006      * @dev See {IERC721Metadata-tokenURI}.
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
1024     /**
1025      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1026      */
1027     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1028         // For branchless setting of the `nextInitialized` flag.
1029         assembly {
1030             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1031             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1032         }
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-approve}.
1037      */
1038     function approve(address to, uint256 tokenId) public override {
1039         address owner = ownerOf(tokenId);
1040 
1041         if (_msgSenderERC721A() != owner)
1042             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1043                 revert ApprovalCallerNotOwnerNorApproved();
1044             }
1045 
1046         _tokenApprovals[tokenId] = to;
1047         emit Approval(owner, to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-getApproved}.
1052      */
1053     function getApproved(uint256 tokenId) public view override returns (address) {
1054         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1055 
1056         return _tokenApprovals[tokenId];
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-setApprovalForAll}.
1061      */
1062     function setApprovalForAll(address operator, bool approved) public virtual override {
1063         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1064 
1065         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1066         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-isApprovedForAll}.
1071      */
1072     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1073         return _operatorApprovals[owner][operator];
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-safeTransferFrom}.
1078      */
1079     function safeTransferFrom(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) public virtual override {
1084         safeTransferFrom(from, to, tokenId, '');
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-safeTransferFrom}.
1089      */
1090     function safeTransferFrom(
1091         address from,
1092         address to,
1093         uint256 tokenId,
1094         bytes memory _data
1095     ) public virtual override {
1096         transferFrom(from, to, tokenId);
1097         if (to.code.length != 0)
1098             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1099                 revert TransferToNonERC721ReceiverImplementer();
1100             }
1101     }
1102 
1103     /**
1104      * @dev Returns whether `tokenId` exists.
1105      *
1106      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1107      *
1108      * Tokens start existing when they are minted (`_mint`),
1109      */
1110     function _exists(uint256 tokenId) internal view returns (bool) {
1111         return
1112             _startTokenId() <= tokenId &&
1113             tokenId < _currentIndex && // If within bounds,
1114             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1115     }
1116 
1117     /**
1118      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1119      */
1120     function _safeMint(address to, uint256 quantity) internal {
1121         _safeMint(to, quantity, '');
1122     }
1123 
1124     /**
1125      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1126      *
1127      * Requirements:
1128      *
1129      * - If `to` refers to a smart contract, it must implement
1130      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1131      * - `quantity` must be greater than 0.
1132      *
1133      * See {_mint}.
1134      *
1135      * Emits a {Transfer} event for each mint.
1136      */
1137     function _safeMint(
1138         address to,
1139         uint256 quantity,
1140         bytes memory _data
1141     ) internal {
1142         _mint(to, quantity);
1143 
1144         unchecked {
1145             if (to.code.length != 0) {
1146                 uint256 end = _currentIndex;
1147                 uint256 index = end - quantity;
1148                 do {
1149                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1150                         revert TransferToNonERC721ReceiverImplementer();
1151                     }
1152                 } while (index < end);
1153                 // Reentrancy protection.
1154                 if (_currentIndex != end) revert();
1155             }
1156         }
1157     }
1158 
1159     /**
1160      * @dev Mints `quantity` tokens and transfers them to `to`.
1161      *
1162      * Requirements:
1163      *
1164      * - `to` cannot be the zero address.
1165      * - `quantity` must be greater than 0.
1166      *
1167      * Emits a {Transfer} event for each mint.
1168      */
1169     function _mint(address to, uint256 quantity) internal {
1170         uint256 startTokenId = _currentIndex;
1171         if (to == address(0)) revert MintToZeroAddress();
1172         if (quantity == 0) revert MintZeroQuantity();
1173 
1174         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1175 
1176         // Overflows are incredibly unrealistic.
1177         // `balance` and `numberMinted` have a maximum limit of 2**64.
1178         // `tokenId` has a maximum limit of 2**256.
1179         unchecked {
1180             // Updates:
1181             // - `balance += quantity`.
1182             // - `numberMinted += quantity`.
1183             //
1184             // We can directly add to the `balance` and `numberMinted`.
1185             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1186 
1187             // Updates:
1188             // - `address` to the owner.
1189             // - `startTimestamp` to the timestamp of minting.
1190             // - `burned` to `false`.
1191             // - `nextInitialized` to `quantity == 1`.
1192             _packedOwnerships[startTokenId] = _packOwnershipData(
1193                 to,
1194                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1195             );
1196 
1197             uint256 tokenId = startTokenId;
1198             uint256 end = startTokenId + quantity;
1199             do {
1200                 emit Transfer(address(0), to, tokenId++);
1201             } while (tokenId < end);
1202 
1203             _currentIndex = end;
1204         }
1205         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1206     }
1207 
1208     /**
1209      * @dev Mints `quantity` tokens and transfers them to `to`.
1210      *
1211      * This function is intended for efficient minting only during contract creation.
1212      *
1213      * It emits only one {ConsecutiveTransfer} as defined in
1214      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1215      * instead of a sequence of {Transfer} event(s).
1216      *
1217      * Calling this function outside of contract creation WILL make your contract
1218      * non-compliant with the ERC721 standard.
1219      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1220      * {ConsecutiveTransfer} event is only permissible during contract creation.
1221      *
1222      * Requirements:
1223      *
1224      * - `to` cannot be the zero address.
1225      * - `quantity` must be greater than 0.
1226      *
1227      * Emits a {ConsecutiveTransfer} event.
1228      */
1229     function _mintERC2309(address to, uint256 quantity) internal {
1230         uint256 startTokenId = _currentIndex;
1231         if (to == address(0)) revert MintToZeroAddress();
1232         if (quantity == 0) revert MintZeroQuantity();
1233         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1234 
1235         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1236 
1237         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1238         unchecked {
1239             // Updates:
1240             // - `balance += quantity`.
1241             // - `numberMinted += quantity`.
1242             //
1243             // We can directly add to the `balance` and `numberMinted`.
1244             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1245 
1246             // Updates:
1247             // - `address` to the owner.
1248             // - `startTimestamp` to the timestamp of minting.
1249             // - `burned` to `false`.
1250             // - `nextInitialized` to `quantity == 1`.
1251             _packedOwnerships[startTokenId] = _packOwnershipData(
1252                 to,
1253                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1254             );
1255 
1256             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1257 
1258             _currentIndex = startTokenId + quantity;
1259         }
1260         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1261     }
1262 
1263     /**
1264      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1265      */
1266     function _getApprovedAddress(uint256 tokenId)
1267         private
1268         view
1269         returns (uint256 approvedAddressSlot, address approvedAddress)
1270     {
1271         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1272         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1273         assembly {
1274             // Compute the slot.
1275             mstore(0x00, tokenId)
1276             mstore(0x20, tokenApprovalsPtr.slot)
1277             approvedAddressSlot := keccak256(0x00, 0x40)
1278             // Load the slot's value from storage.
1279             approvedAddress := sload(approvedAddressSlot)
1280         }
1281     }
1282 
1283     /**
1284      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1285      */
1286     function _isOwnerOrApproved(
1287         address approvedAddress,
1288         address from,
1289         address msgSender
1290     ) private pure returns (bool result) {
1291         assembly {
1292             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1293             from := and(from, BITMASK_ADDRESS)
1294             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1295             msgSender := and(msgSender, BITMASK_ADDRESS)
1296             // `msgSender == from || msgSender == approvedAddress`.
1297             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1298         }
1299     }
1300 
1301     /**
1302      * @dev Transfers `tokenId` from `from` to `to`.
1303      *
1304      * Requirements:
1305      *
1306      * - `to` cannot be the zero address.
1307      * - `tokenId` token must be owned by `from`.
1308      *
1309      * Emits a {Transfer} event.
1310      */
1311     function transferFrom(
1312         address from,
1313         address to,
1314         uint256 tokenId
1315     ) public virtual override {
1316         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1317 
1318         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1319 
1320         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1321 
1322         // The nested ifs save around 20+ gas over a compound boolean condition.
1323         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1324             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1325 
1326         if (to == address(0)) revert TransferToZeroAddress();
1327 
1328         _beforeTokenTransfers(from, to, tokenId, 1);
1329 
1330         // Clear approvals from the previous owner.
1331         assembly {
1332             if approvedAddress {
1333                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1334                 sstore(approvedAddressSlot, 0)
1335             }
1336         }
1337 
1338         // Underflow of the sender's balance is impossible because we check for
1339         // ownership above and the recipient's balance can't realistically overflow.
1340         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1341         unchecked {
1342             // We can directly increment and decrement the balances.
1343             --_packedAddressData[from]; // Updates: `balance -= 1`.
1344             ++_packedAddressData[to]; // Updates: `balance += 1`.
1345 
1346             // Updates:
1347             // - `address` to the next owner.
1348             // - `startTimestamp` to the timestamp of transfering.
1349             // - `burned` to `false`.
1350             // - `nextInitialized` to `true`.
1351             _packedOwnerships[tokenId] = _packOwnershipData(
1352                 to,
1353                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1354             );
1355 
1356             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1357             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1358                 uint256 nextTokenId = tokenId + 1;
1359                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1360                 if (_packedOwnerships[nextTokenId] == 0) {
1361                     // If the next slot is within bounds.
1362                     if (nextTokenId != _currentIndex) {
1363                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1364                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1365                     }
1366                 }
1367             }
1368         }
1369 
1370         emit Transfer(from, to, tokenId);
1371         _afterTokenTransfers(from, to, tokenId, 1);
1372     }
1373 
1374     /**
1375      * @dev Equivalent to `_burn(tokenId, false)`.
1376      */
1377     function _burn(uint256 tokenId) internal virtual {
1378         _burn(tokenId, false);
1379     }
1380 
1381     /**
1382      * @dev Destroys `tokenId`.
1383      * The approval is cleared when the token is burned.
1384      *
1385      * Requirements:
1386      *
1387      * - `tokenId` must exist.
1388      *
1389      * Emits a {Transfer} event.
1390      */
1391     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1392         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1393 
1394         address from = address(uint160(prevOwnershipPacked));
1395 
1396         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1397 
1398         if (approvalCheck) {
1399             // The nested ifs save around 20+ gas over a compound boolean condition.
1400             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1401                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1402         }
1403 
1404         _beforeTokenTransfers(from, address(0), tokenId, 1);
1405 
1406         // Clear approvals from the previous owner.
1407         assembly {
1408             if approvedAddress {
1409                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1410                 sstore(approvedAddressSlot, 0)
1411             }
1412         }
1413 
1414         // Underflow of the sender's balance is impossible because we check for
1415         // ownership above and the recipient's balance can't realistically overflow.
1416         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1417         unchecked {
1418             // Updates:
1419             // - `balance -= 1`.
1420             // - `numberBurned += 1`.
1421             //
1422             // We can directly decrement the balance, and increment the number burned.
1423             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1424             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1425 
1426             // Updates:
1427             // - `address` to the last owner.
1428             // - `startTimestamp` to the timestamp of burning.
1429             // - `burned` to `true`.
1430             // - `nextInitialized` to `true`.
1431             _packedOwnerships[tokenId] = _packOwnershipData(
1432                 from,
1433                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1434             );
1435 
1436             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1437             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1438                 uint256 nextTokenId = tokenId + 1;
1439                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1440                 if (_packedOwnerships[nextTokenId] == 0) {
1441                     // If the next slot is within bounds.
1442                     if (nextTokenId != _currentIndex) {
1443                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1444                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1445                     }
1446                 }
1447             }
1448         }
1449 
1450         emit Transfer(from, address(0), tokenId);
1451         _afterTokenTransfers(from, address(0), tokenId, 1);
1452 
1453         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1454         unchecked {
1455             _burnCounter++;
1456         }
1457     }
1458 
1459     /**
1460      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1461      *
1462      * @param from address representing the previous owner of the given token ID
1463      * @param to target address that will receive the tokens
1464      * @param tokenId uint256 ID of the token to be transferred
1465      * @param _data bytes optional data to send along with the call
1466      * @return bool whether the call correctly returned the expected magic value
1467      */
1468     function _checkContractOnERC721Received(
1469         address from,
1470         address to,
1471         uint256 tokenId,
1472         bytes memory _data
1473     ) private returns (bool) {
1474         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1475             bytes4 retval
1476         ) {
1477             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1478         } catch (bytes memory reason) {
1479             if (reason.length == 0) {
1480                 revert TransferToNonERC721ReceiverImplementer();
1481             } else {
1482                 assembly {
1483                     revert(add(32, reason), mload(reason))
1484                 }
1485             }
1486         }
1487     }
1488 
1489     /**
1490      * @dev Directly sets the extra data for the ownership data `index`.
1491      */
1492     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1493         uint256 packed = _packedOwnerships[index];
1494         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1495         uint256 extraDataCasted;
1496         // Cast `extraData` with assembly to avoid redundant masking.
1497         assembly {
1498             extraDataCasted := extraData
1499         }
1500         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1501         _packedOwnerships[index] = packed;
1502     }
1503 
1504     /**
1505      * @dev Returns the next extra data for the packed ownership data.
1506      * The returned result is shifted into position.
1507      */
1508     function _nextExtraData(
1509         address from,
1510         address to,
1511         uint256 prevOwnershipPacked
1512     ) private view returns (uint256) {
1513         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1514         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1515     }
1516 
1517     /**
1518      * @dev Called during each token transfer to set the 24bit `extraData` field.
1519      * Intended to be overridden by the cosumer contract.
1520      *
1521      * `previousExtraData` - the value of `extraData` before transfer.
1522      *
1523      * Calling conditions:
1524      *
1525      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1526      * transferred to `to`.
1527      * - When `from` is zero, `tokenId` will be minted for `to`.
1528      * - When `to` is zero, `tokenId` will be burned by `from`.
1529      * - `from` and `to` are never both zero.
1530      */
1531     function _extraData(
1532         address from,
1533         address to,
1534         uint24 previousExtraData
1535     ) internal view virtual returns (uint24) {}
1536 
1537     /**
1538      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1539      * This includes minting.
1540      * And also called before burning one token.
1541      *
1542      * startTokenId - the first token id to be transferred
1543      * quantity - the amount to be transferred
1544      *
1545      * Calling conditions:
1546      *
1547      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1548      * transferred to `to`.
1549      * - When `from` is zero, `tokenId` will be minted for `to`.
1550      * - When `to` is zero, `tokenId` will be burned by `from`.
1551      * - `from` and `to` are never both zero.
1552      */
1553     function _beforeTokenTransfers(
1554         address from,
1555         address to,
1556         uint256 startTokenId,
1557         uint256 quantity
1558     ) internal virtual {}
1559 
1560     /**
1561      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1562      * This includes minting.
1563      * And also called after one token has been burned.
1564      *
1565      * startTokenId - the first token id to be transferred
1566      * quantity - the amount to be transferred
1567      *
1568      * Calling conditions:
1569      *
1570      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1571      * transferred to `to`.
1572      * - When `from` is zero, `tokenId` has been minted for `to`.
1573      * - When `to` is zero, `tokenId` has been burned by `from`.
1574      * - `from` and `to` are never both zero.
1575      */
1576     function _afterTokenTransfers(
1577         address from,
1578         address to,
1579         uint256 startTokenId,
1580         uint256 quantity
1581     ) internal virtual {}
1582 
1583     /**
1584      * @dev Returns the message sender (defaults to `msg.sender`).
1585      *
1586      * If you are writing GSN compatible contracts, you need to override this function.
1587      */
1588     function _msgSenderERC721A() internal view virtual returns (address) {
1589         return msg.sender;
1590     }
1591 
1592     /**
1593      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1594      */
1595     function _toString(uint256 value) internal pure returns (string memory ptr) {
1596         assembly {
1597             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1598             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1599             // We will need 1 32-byte word to store the length,
1600             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1601             ptr := add(mload(0x40), 128)
1602             // Update the free memory pointer to allocate.
1603             mstore(0x40, ptr)
1604 
1605             // Cache the end of the memory to calculate the length later.
1606             let end := ptr
1607 
1608             // We write the string from the rightmost digit to the leftmost digit.
1609             // The following is essentially a do-while loop that also handles the zero case.
1610             // Costs a bit more than early returning for the zero case,
1611             // but cheaper in terms of deployment and overall runtime costs.
1612             for {
1613                 // Initialize and perform the first pass without check.
1614                 let temp := value
1615                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1616                 ptr := sub(ptr, 1)
1617                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1618                 mstore8(ptr, add(48, mod(temp, 10)))
1619                 temp := div(temp, 10)
1620             } temp {
1621                 // Keep dividing `temp` until zero.
1622                 temp := div(temp, 10)
1623             } {
1624                 // Body of the for loop.
1625                 ptr := sub(ptr, 1)
1626                 mstore8(ptr, add(48, mod(temp, 10)))
1627             }
1628 
1629             let length := sub(end, ptr)
1630             // Move the pointer 32 bytes leftwards to make room for the length.
1631             ptr := sub(ptr, 32)
1632             // Store the length.
1633             mstore(ptr, length)
1634         }
1635     }
1636 }
1637 
1638 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1639 
1640 
1641 // ERC721A Contracts v4.1.0
1642 // Creator: Chiru Labs
1643 
1644 pragma solidity ^0.8.4;
1645 
1646 
1647 /**
1648  * @dev Interface of an ERC721AQueryable compliant contract.
1649  */
1650 interface IERC721AQueryable is IERC721A {
1651     /**
1652      * Invalid query range (`start` >= `stop`).
1653      */
1654     error InvalidQueryRange();
1655 
1656     /**
1657      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1658      *
1659      * If the `tokenId` is out of bounds:
1660      *   - `addr` = `address(0)`
1661      *   - `startTimestamp` = `0`
1662      *   - `burned` = `false`
1663      *
1664      * If the `tokenId` is burned:
1665      *   - `addr` = `<Address of owner before token was burned>`
1666      *   - `startTimestamp` = `<Timestamp when token was burned>`
1667      *   - `burned = `true`
1668      *
1669      * Otherwise:
1670      *   - `addr` = `<Address of owner>`
1671      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1672      *   - `burned = `false`
1673      */
1674     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1675 
1676     /**
1677      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1678      * See {ERC721AQueryable-explicitOwnershipOf}
1679      */
1680     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1681 
1682     /**
1683      * @dev Returns an array of token IDs owned by `owner`,
1684      * in the range [`start`, `stop`)
1685      * (i.e. `start <= tokenId < stop`).
1686      *
1687      * This function allows for tokens to be queried if the collection
1688      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1689      *
1690      * Requirements:
1691      *
1692      * - `start` < `stop`
1693      */
1694     function tokensOfOwnerIn(
1695         address owner,
1696         uint256 start,
1697         uint256 stop
1698     ) external view returns (uint256[] memory);
1699 
1700     /**
1701      * @dev Returns an array of token IDs owned by `owner`.
1702      *
1703      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1704      * It is meant to be called off-chain.
1705      *
1706      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1707      * multiple smaller scans if the collection is large enough to cause
1708      * an out-of-gas error (10K pfp collections should be fine).
1709      */
1710     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1711 }
1712 
1713 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1714 
1715 
1716 // ERC721A Contracts v4.1.0
1717 // Creator: Chiru Labs
1718 
1719 pragma solidity ^0.8.4;
1720 
1721 
1722 
1723 /**
1724  * @title ERC721A Queryable
1725  * @dev ERC721A subclass with convenience query functions.
1726  */
1727 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1728     /**
1729      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1730      *
1731      * If the `tokenId` is out of bounds:
1732      *   - `addr` = `address(0)`
1733      *   - `startTimestamp` = `0`
1734      *   - `burned` = `false`
1735      *   - `extraData` = `0`
1736      *
1737      * If the `tokenId` is burned:
1738      *   - `addr` = `<Address of owner before token was burned>`
1739      *   - `startTimestamp` = `<Timestamp when token was burned>`
1740      *   - `burned = `true`
1741      *   - `extraData` = `<Extra data when token was burned>`
1742      *
1743      * Otherwise:
1744      *   - `addr` = `<Address of owner>`
1745      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1746      *   - `burned = `false`
1747      *   - `extraData` = `<Extra data at start of ownership>`
1748      */
1749     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1750         TokenOwnership memory ownership;
1751         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1752             return ownership;
1753         }
1754         ownership = _ownershipAt(tokenId);
1755         if (ownership.burned) {
1756             return ownership;
1757         }
1758         return _ownershipOf(tokenId);
1759     }
1760 
1761     /**
1762      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1763      * See {ERC721AQueryable-explicitOwnershipOf}
1764      */
1765     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1766         unchecked {
1767             uint256 tokenIdsLength = tokenIds.length;
1768             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1769             for (uint256 i; i != tokenIdsLength; ++i) {
1770                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1771             }
1772             return ownerships;
1773         }
1774     }
1775 
1776     /**
1777      * @dev Returns an array of token IDs owned by `owner`,
1778      * in the range [`start`, `stop`)
1779      * (i.e. `start <= tokenId < stop`).
1780      *
1781      * This function allows for tokens to be queried if the collection
1782      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1783      *
1784      * Requirements:
1785      *
1786      * - `start` < `stop`
1787      */
1788     function tokensOfOwnerIn(
1789         address owner,
1790         uint256 start,
1791         uint256 stop
1792     ) external view override returns (uint256[] memory) {
1793         unchecked {
1794             if (start >= stop) revert InvalidQueryRange();
1795             uint256 tokenIdsIdx;
1796             uint256 stopLimit = _nextTokenId();
1797             // Set `start = max(start, _startTokenId())`.
1798             if (start < _startTokenId()) {
1799                 start = _startTokenId();
1800             }
1801             // Set `stop = min(stop, stopLimit)`.
1802             if (stop > stopLimit) {
1803                 stop = stopLimit;
1804             }
1805             uint256 tokenIdsMaxLength = balanceOf(owner);
1806             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1807             // to cater for cases where `balanceOf(owner)` is too big.
1808             if (start < stop) {
1809                 uint256 rangeLength = stop - start;
1810                 if (rangeLength < tokenIdsMaxLength) {
1811                     tokenIdsMaxLength = rangeLength;
1812                 }
1813             } else {
1814                 tokenIdsMaxLength = 0;
1815             }
1816             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1817             if (tokenIdsMaxLength == 0) {
1818                 return tokenIds;
1819             }
1820             // We need to call `explicitOwnershipOf(start)`,
1821             // because the slot at `start` may not be initialized.
1822             TokenOwnership memory ownership = explicitOwnershipOf(start);
1823             address currOwnershipAddr;
1824             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1825             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1826             if (!ownership.burned) {
1827                 currOwnershipAddr = ownership.addr;
1828             }
1829             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1830                 ownership = _ownershipAt(i);
1831                 if (ownership.burned) {
1832                     continue;
1833                 }
1834                 if (ownership.addr != address(0)) {
1835                     currOwnershipAddr = ownership.addr;
1836                 }
1837                 if (currOwnershipAddr == owner) {
1838                     tokenIds[tokenIdsIdx++] = i;
1839                 }
1840             }
1841             // Downsize the array to fit.
1842             assembly {
1843                 mstore(tokenIds, tokenIdsIdx)
1844             }
1845             return tokenIds;
1846         }
1847     }
1848 
1849     /**
1850      * @dev Returns an array of token IDs owned by `owner`.
1851      *
1852      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1853      * It is meant to be called off-chain.
1854      *
1855      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1856      * multiple smaller scans if the collection is large enough to cause
1857      * an out-of-gas error (10K pfp collections should be fine).
1858      */
1859     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1860         unchecked {
1861             uint256 tokenIdsIdx;
1862             address currOwnershipAddr;
1863             uint256 tokenIdsLength = balanceOf(owner);
1864             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1865             TokenOwnership memory ownership;
1866             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1867                 ownership = _ownershipAt(i);
1868                 if (ownership.burned) {
1869                     continue;
1870                 }
1871                 if (ownership.addr != address(0)) {
1872                     currOwnershipAddr = ownership.addr;
1873                 }
1874                 if (currOwnershipAddr == owner) {
1875                     tokenIds[tokenIdsIdx++] = i;
1876                 }
1877             }
1878             return tokenIds;
1879         }
1880     }
1881 }
1882 
1883 // File: test.sol
1884 
1885 
1886 
1887 pragma solidity >=0.8.9 <0.9.0;
1888 
1889 
1890 
1891 
1892 
1893 contract ScroogeDuckCity is ERC721AQueryable, Ownable {
1894     using Strings for uint256;
1895 
1896     // Three phased mint process : whitelist claim first, then free mint until a given supply is reached, then paid mint
1897     bool public whitelistMintEnabled;
1898     bool public freeMintEnabled;
1899     bool public mintEnabled;
1900 
1901     // Merkle root for whitelist check
1902     bytes32 public merkleRoot;
1903 
1904     // Whitelist and free mint wallet claim checks, mint counter per wallet
1905     mapping(address => bool) public whitelistClaimed;
1906     mapping(address => bool) public freeMintClaimed;
1907     mapping(address => uint256) public mintedAmount;
1908 
1909     // Supply and counters for mint phases
1910     uint256 public whitelistSupply;
1911     uint256 public whitelistCounter;
1912     uint256 public freeMintSupply;
1913     uint256 public freeMintCounter;
1914     uint256 public mintSupply;
1915     uint256 public mintCounter;
1916     uint256 public maxSupply;
1917     bool public supplyLocked;
1918 
1919     // Cost of the paid mint
1920     uint256 public cost;
1921 
1922     // URI to use for displaying NFT metadata and image
1923     string public hiddenMetadataUri;
1924     string public uriPrefix;
1925     string public uriSuffix;
1926 
1927     // Determines whether the collection is revealed or not, triggering a different tokenURI() process
1928     bool public revealed = false;
1929 
1930     constructor(
1931         string memory _tokenName,
1932         string memory _tokenSymbol,
1933         uint256 _whitelistSupply,
1934         uint256 _freeMintSupply,
1935         uint256 _mintSupply,
1936         uint256 _maxSupply,
1937         uint256 _cost
1938     ) ERC721A(_tokenName, _tokenSymbol) {
1939         setSupply(_whitelistSupply, _freeMintSupply, _mintSupply, _maxSupply);
1940         setCost(_cost);
1941     }
1942 
1943     function whitelistMint(bytes32[] calldata _merkleProof) public {
1944         // Verify whitelist requirements
1945         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1946         require(
1947             MerkleProof.verify(_merkleProof, merkleRoot, leaf),
1948             "Address is not on the whitelist!"
1949         );
1950         
1951         require(whitelistMintEnabled, "The whitelist sale is not live!");
1952         require(
1953             whitelistCounter + 2 <= whitelistSupply,
1954             "Whitelist supply exceeded!"
1955         );
1956         require(
1957             totalSupply() + 2 <= maxSupply,
1958             "Max supply exceeded!"
1959         );
1960         require(
1961             !whitelistClaimed[_msgSender()],
1962             "Address already claimed whitelist allocation!"
1963         );
1964 
1965         whitelistClaimed[_msgSender()] = true;
1966         mintedAmount[_msgSender()] += 2;
1967         whitelistCounter += 2;
1968         _safeMint(_msgSender(), 2);
1969     }
1970 
1971     function freeMint() public {
1972         // Verify free mint requirements
1973         require(freeMintEnabled, "The free mint is not live!");
1974         require(
1975             freeMintCounter + 1 <= freeMintSupply,
1976             "Free mint supply exceeded!"
1977         );
1978         require(
1979             totalSupply() + 1 <= maxSupply,
1980             "Max supply exceeded!"
1981         );
1982         require(
1983             !freeMintClaimed[_msgSender()],
1984             "Address already claimed a free mint!"
1985         );
1986 
1987         freeMintClaimed[_msgSender()] = true;
1988         mintedAmount[_msgSender()] += 1;
1989         freeMintCounter += 1;
1990         _safeMint(_msgSender(), 1);
1991     }
1992 
1993     function mint(uint256 _mintAmount) public payable {
1994         require(mintEnabled, "The public sale is not live!");
1995 
1996         require(_mintAmount > 0 && _mintAmount <= 5, "Invalid mint amount!");
1997         require(
1998             mintCounter + _mintAmount <= mintSupply,
1999             "Paid mint supply exceeded!"
2000         );
2001         require(
2002             totalSupply() + _mintAmount <= maxSupply,
2003             "Max supply exceeded!"
2004         );
2005         require(
2006             mintedAmount[_msgSender()] + _mintAmount <= 10,
2007             "Request exceeds maximum mint amount allowed per account (10)"
2008         );
2009         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
2010 
2011         mintedAmount[_msgSender()] += _mintAmount;
2012         mintCounter += _mintAmount;
2013         _safeMint(_msgSender(), _mintAmount);
2014     }
2015 
2016     function mintForAddress(uint256 _mintAmount, address _receiver)
2017         external
2018         onlyOwner
2019     {
2020         require(
2021             totalSupply() + _mintAmount <= maxSupply,
2022             "Max supply exceeded!"
2023         );
2024         _safeMint(_receiver, _mintAmount);
2025     }
2026 
2027     function _startTokenId() internal view virtual override returns (uint256) {
2028         return 1;
2029     }
2030 
2031     function _baseURI() internal view virtual override returns (string memory) {
2032         return uriPrefix;
2033     }
2034 
2035     function tokenURI(uint256 _tokenId)
2036         public
2037         view
2038         virtual
2039         override(ERC721A, IERC721A)
2040         returns (string memory)
2041     {
2042         require(
2043             _exists(_tokenId),
2044             "ERC721Metadata: URI query for nonexistent token"
2045         );
2046 
2047         if (revealed == false) {
2048             return hiddenMetadataUri;
2049         }
2050 
2051         string memory currentBaseURI = _baseURI();
2052         return
2053             bytes(currentBaseURI).length > 0
2054                 ? string(
2055                     abi.encodePacked(
2056                         currentBaseURI,
2057                         _tokenId.toString(),
2058                         uriSuffix
2059                     )
2060                 )
2061                 : "";
2062     }
2063 
2064     function setMintState(
2065         bool _whitelistMintEnabled,
2066         bool _freeMintEnabled,
2067         bool _mintEnabled
2068     ) external onlyOwner {
2069         whitelistMintEnabled = _whitelistMintEnabled;
2070         freeMintEnabled = _freeMintEnabled;
2071         mintEnabled = _mintEnabled;
2072     }
2073 
2074     function lockSupply() public onlyOwner {
2075         require(!supplyLocked, "Supply is already locked");
2076         supplyLocked = true;
2077     }
2078 
2079     function setSupply(
2080         uint256 _whitelistSupply,
2081         uint256 _freeMintSupply,
2082         uint256 _mintSupply,
2083         uint256 _maxSupply
2084     ) public onlyOwner {
2085         require(!supplyLocked, "Supply is locked");
2086         whitelistSupply = _whitelistSupply;
2087         freeMintSupply = _freeMintSupply;
2088         mintSupply = _mintSupply;
2089         maxSupply = _maxSupply;
2090     }
2091 
2092     function setCost(uint256 _cost) public onlyOwner {
2093         cost = _cost;
2094     }
2095 
2096     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2097         merkleRoot = _merkleRoot;
2098     }
2099 
2100     function setHiddenMetadataUri(string memory _hiddenMetadataUri)
2101         external
2102         onlyOwner
2103     {
2104         hiddenMetadataUri = _hiddenMetadataUri;
2105     }
2106 
2107     function setUriPrefix(string memory _uriPrefix) external onlyOwner {
2108         uriPrefix = _uriPrefix;
2109     }
2110 
2111     function setUriSuffix(string memory _uriSuffix) external onlyOwner {
2112         uriSuffix = _uriSuffix;
2113     }
2114 
2115     function setRevealed(bool _state) external onlyOwner {
2116         revealed = _state;
2117     }
2118 
2119     function withdraw() public onlyOwner {
2120         payable(owner()).transfer(address(this).balance);
2121     }
2122 }