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
406 // File: contracts/IERC721A.sol
407 
408 
409 // ERC721A Contracts v4.0.0
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
434      * The caller cannot approve to the current owner.
435      */
436     error ApprovalToCurrentOwner();
437 
438     /**
439      * Cannot query the balance for the zero address.
440      */
441     error BalanceQueryForZeroAddress();
442 
443     /**
444      * Cannot mint to the zero address.
445      */
446     error MintToZeroAddress();
447 
448     /**
449      * The quantity of tokens minted must be more than zero.
450      */
451     error MintZeroQuantity();
452 
453     /**
454      * The token does not exist.
455      */
456     error OwnerQueryForNonexistentToken();
457 
458     /**
459      * The caller must own the token or be an approved operator.
460      */
461     error TransferCallerNotOwnerNorApproved();
462 
463     /**
464      * The token must be owned by `from`.
465      */
466     error TransferFromIncorrectOwner();
467 
468     /**
469      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
470      */
471     error TransferToNonERC721ReceiverImplementer();
472 
473     /**
474      * Cannot transfer to the zero address.
475      */
476     error TransferToZeroAddress();
477 
478     /**
479      * The token does not exist.
480      */
481     error URIQueryForNonexistentToken();
482 
483     struct TokenOwnership {
484         // The address of the owner.
485         address addr;
486         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
487         uint64 startTimestamp;
488         // Whether the token has been burned.
489         bool burned;
490     }
491 
492     /**
493      * @dev Returns the total amount of tokens stored by the contract.
494      *
495      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
496      */
497     function totalSupply() external view returns (uint256);
498 
499     // ==============================
500     //            IERC165
501     // ==============================
502 
503     /**
504      * @dev Returns true if this contract implements the interface defined by
505      * `interfaceId`. See the corresponding
506      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
507      * to learn more about how these ids are created.
508      *
509      * This function call must use less than 30 000 gas.
510      */
511     function supportsInterface(bytes4 interfaceId) external view returns (bool);
512 
513     // ==============================
514     //            IERC721
515     // ==============================
516 
517     /**
518      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
519      */
520     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
521 
522     /**
523      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
524      */
525     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
526 
527     /**
528      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
529      */
530     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
531 
532     /**
533      * @dev Returns the number of tokens in ``owner``'s account.
534      */
535     function balanceOf(address owner) external view returns (uint256 balance);
536 
537     /**
538      * @dev Returns the owner of the `tokenId` token.
539      *
540      * Requirements:
541      *
542      * - `tokenId` must exist.
543      */
544     function ownerOf(uint256 tokenId) external view returns (address owner);
545 
546     /**
547      * @dev Safely transfers `tokenId` token from `from` to `to`.
548      *
549      * Requirements:
550      *
551      * - `from` cannot be the zero address.
552      * - `to` cannot be the zero address.
553      * - `tokenId` token must exist and be owned by `from`.
554      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
555      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
556      *
557      * Emits a {Transfer} event.
558      */
559     function safeTransferFrom(
560         address from,
561         address to,
562         uint256 tokenId,
563         bytes calldata data
564     ) external;
565 
566     /**
567      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
568      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
569      *
570      * Requirements:
571      *
572      * - `from` cannot be the zero address.
573      * - `to` cannot be the zero address.
574      * - `tokenId` token must exist and be owned by `from`.
575      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
576      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
577      *
578      * Emits a {Transfer} event.
579      */
580     function safeTransferFrom(
581         address from,
582         address to,
583         uint256 tokenId
584     ) external;
585 
586     /**
587      * @dev Transfers `tokenId` token from `from` to `to`.
588      *
589      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
590      *
591      * Requirements:
592      *
593      * - `from` cannot be the zero address.
594      * - `to` cannot be the zero address.
595      * - `tokenId` token must be owned by `from`.
596      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
597      *
598      * Emits a {Transfer} event.
599      */
600     function transferFrom(
601         address from,
602         address to,
603         uint256 tokenId
604     ) external;
605 
606     /**
607      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
608      * The approval is cleared when the token is transferred.
609      *
610      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
611      *
612      * Requirements:
613      *
614      * - The caller must own the token or be an approved operator.
615      * - `tokenId` must exist.
616      *
617      * Emits an {Approval} event.
618      */
619     function approve(address to, uint256 tokenId) external;
620 
621     /**
622      * @dev Approve or remove `operator` as an operator for the caller.
623      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
624      *
625      * Requirements:
626      *
627      * - The `operator` cannot be the caller.
628      *
629      * Emits an {ApprovalForAll} event.
630      */
631     function setApprovalForAll(address operator, bool _approved) external;
632 
633     /**
634      * @dev Returns the account approved for `tokenId` token.
635      *
636      * Requirements:
637      *
638      * - `tokenId` must exist.
639      */
640     function getApproved(uint256 tokenId) external view returns (address operator);
641 
642     /**
643      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
644      *
645      * See {setApprovalForAll}
646      */
647     function isApprovedForAll(address owner, address operator) external view returns (bool);
648 
649     // ==============================
650     //        IERC721Metadata
651     // ==============================
652 
653     /**
654      * @dev Returns the token collection name.
655      */
656     function name() external view returns (string memory);
657 
658     /**
659      * @dev Returns the token collection symbol.
660      */
661     function symbol() external view returns (string memory);
662 
663     /**
664      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
665      */
666     function tokenURI(uint256 tokenId) external view returns (string memory);
667 }
668 // File: contracts/ERC721A.sol
669 
670 
671 // ERC721A Contracts v4.0.0
672 // Creator: Chiru Labs
673 
674 pragma solidity ^0.8.4;
675 
676 
677 /**
678  * @dev ERC721 token receiver interface.
679  */
680 interface ERC721A__IERC721Receiver {
681     function onERC721Received(
682         address operator,
683         address from,
684         uint256 tokenId,
685         bytes calldata data
686     ) external returns (bytes4);
687 }
688 
689 /**
690  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
691  * the Metadata extension. Built to optimize for lower gas during batch mints.
692  *
693  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
694  *
695  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
696  *
697  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
698  */
699 contract ERC721A is IERC721A {
700     // Mask of an entry in packed address data.
701     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
702 
703     // The bit position of `numberMinted` in packed address data.
704     uint256 private constant BITPOS_NUMBER_MINTED = 64;
705 
706     // The bit position of `numberBurned` in packed address data.
707     uint256 private constant BITPOS_NUMBER_BURNED = 128;
708 
709     // The bit position of `aux` in packed address data.
710     uint256 private constant BITPOS_AUX = 192;
711 
712     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
713     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
714 
715     // The bit position of `startTimestamp` in packed ownership.
716     uint256 private constant BITPOS_START_TIMESTAMP = 160;
717 
718     // The bit mask of the `burned` bit in packed ownership.
719     uint256 private constant BITMASK_BURNED = 1 << 224;
720     
721     // The bit position of the `nextInitialized` bit in packed ownership.
722     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
723 
724     // The bit mask of the `nextInitialized` bit in packed ownership.
725     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
726 
727     // The tokenId of the next token to be minted.
728     uint256 private _currentIndex;
729 
730     // The number of tokens burned.
731     uint256 private _burnCounter;
732 
733     // Token name
734     string private _name;
735 
736     // Token symbol
737     string private _symbol;
738 
739     // Mapping from token ID to ownership details
740     // An empty struct value does not necessarily mean the token is unowned.
741     // See `_packedOwnershipOf` implementation for details.
742     //
743     // Bits Layout:
744     // - [0..159]   `addr`
745     // - [160..223] `startTimestamp`
746     // - [224]      `burned`
747     // - [225]      `nextInitialized`
748     mapping(uint256 => uint256) private _packedOwnerships;
749 
750     // Mapping owner address to address data.
751     //
752     // Bits Layout:
753     // - [0..63]    `balance`
754     // - [64..127]  `numberMinted`
755     // - [128..191] `numberBurned`
756     // - [192..255] `aux`
757     mapping(address => uint256) private _packedAddressData;
758 
759     // Mapping from token ID to approved address.
760     mapping(uint256 => address) private _tokenApprovals;
761 
762     // Mapping from owner to operator approvals
763     mapping(address => mapping(address => bool)) private _operatorApprovals;
764 
765     constructor(string memory name_, string memory symbol_) {
766         _name = name_;
767         _symbol = symbol_;
768         _currentIndex = _startTokenId();
769     }
770 
771     /**
772      * @dev Returns the starting token ID. 
773      * To change the starting token ID, please override this function.
774      */
775     function _startTokenId() internal view virtual returns (uint256) {
776         return 0;
777     }
778 
779     /**
780      * @dev Returns the next token ID to be minted.
781      */
782     function _nextTokenId() internal view returns (uint256) {
783         return _currentIndex;
784     }
785 
786     /**
787      * @dev Returns the total number of tokens in existence.
788      * Burned tokens will reduce the count. 
789      * To get the total number of tokens minted, please see `_totalMinted`.
790      */
791     function totalSupply() public view override returns (uint256) {
792         // Counter underflow is impossible as _burnCounter cannot be incremented
793         // more than `_currentIndex - _startTokenId()` times.
794         unchecked {
795             return _currentIndex - _burnCounter - _startTokenId();
796         }
797     }
798 
799     /**
800      * @dev Returns the total amount of tokens minted in the contract.
801      */
802     function _totalMinted() internal view returns (uint256) {
803         // Counter underflow is impossible as _currentIndex does not decrement,
804         // and it is initialized to `_startTokenId()`
805         unchecked {
806             return _currentIndex - _startTokenId();
807         }
808     }
809 
810     /**
811      * @dev Returns the total number of tokens burned.
812      */
813     function _totalBurned() internal view returns (uint256) {
814         return _burnCounter;
815     }
816 
817     /**
818      * @dev See {IERC165-supportsInterface}.
819      */
820     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
821         // The interface IDs are constants representing the first 4 bytes of the XOR of
822         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
823         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
824         return
825             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
826             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
827             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
828     }
829 
830     /**
831      * @dev See {IERC721-balanceOf}.
832      */
833     function balanceOf(address owner) public view override returns (uint256) {
834         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
835         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
836     }
837 
838     /**
839      * Returns the number of tokens minted by `owner`.
840      */
841     function _numberMinted(address owner) internal view returns (uint256) {
842         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
843     }
844 
845     /**
846      * Returns the number of tokens burned by or on behalf of `owner`.
847      */
848     function _numberBurned(address owner) internal view returns (uint256) {
849         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
850     }
851 
852     /**
853      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
854      */
855     function _getAux(address owner) internal view returns (uint64) {
856         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
857     }
858 
859     /**
860      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
861      * If there are multiple variables, please pack them into a uint64.
862      */
863     function _setAux(address owner, uint64 aux) internal {
864         uint256 packed = _packedAddressData[owner];
865         uint256 auxCasted;
866         assembly { // Cast aux without masking.
867             auxCasted := aux
868         }
869         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
870         _packedAddressData[owner] = packed;
871     }
872 
873     /**
874      * Returns the packed ownership data of `tokenId`.
875      */
876     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
877         uint256 curr = tokenId;
878 
879         unchecked {
880             if (_startTokenId() <= curr)
881                 if (curr < _currentIndex) {
882                     uint256 packed = _packedOwnerships[curr];
883                     // If not burned.
884                     if (packed & BITMASK_BURNED == 0) {
885                         // Invariant:
886                         // There will always be an ownership that has an address and is not burned
887                         // before an ownership that does not have an address and is not burned.
888                         // Hence, curr will not underflow.
889                         //
890                         // We can directly compare the packed value.
891                         // If the address is zero, packed is zero.
892                         while (packed == 0) {
893                             packed = _packedOwnerships[--curr];
894                         }
895                         return packed;
896                     }
897                 }
898         }
899         revert OwnerQueryForNonexistentToken();
900     }
901 
902     /**
903      * Returns the unpacked `TokenOwnership` struct from `packed`.
904      */
905     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
906         ownership.addr = address(uint160(packed));
907         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
908         ownership.burned = packed & BITMASK_BURNED != 0;
909     }
910 
911     /**
912      * Returns the unpacked `TokenOwnership` struct at `index`.
913      */
914     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
915         return _unpackedOwnership(_packedOwnerships[index]);
916     }
917 
918     /**
919      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
920      */
921     function _initializeOwnershipAt(uint256 index) internal {
922         if (_packedOwnerships[index] == 0) {
923             _packedOwnerships[index] = _packedOwnershipOf(index);
924         }
925     }
926 
927     /**
928      * Gas spent here starts off proportional to the maximum mint batch size.
929      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
930      */
931     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
932         return _unpackedOwnership(_packedOwnershipOf(tokenId));
933     }
934 
935     /**
936      * @dev See {IERC721-ownerOf}.
937      */
938     function ownerOf(uint256 tokenId) public view override returns (address) {
939         return address(uint160(_packedOwnershipOf(tokenId)));
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-name}.
944      */
945     function name() public view virtual override returns (string memory) {
946         return _name;
947     }
948 
949     /**
950      * @dev See {IERC721Metadata-symbol}.
951      */
952     function symbol() public view virtual override returns (string memory) {
953         return _symbol;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-tokenURI}.
958      */
959     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
960         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
961 
962         string memory baseURI = _baseURI();
963         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
964     }
965 
966     /**
967      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
968      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
969      * by default, can be overriden in child contracts.
970      */
971     function _baseURI() internal view virtual returns (string memory) {
972         return '';
973     }
974 
975     /**
976      * @dev Casts the address to uint256 without masking.
977      */
978     function _addressToUint256(address value) private pure returns (uint256 result) {
979         assembly {
980             result := value
981         }
982     }
983 
984     /**
985      * @dev Casts the boolean to uint256 without branching.
986      */
987     function _boolToUint256(bool value) private pure returns (uint256 result) {
988         assembly {
989             result := value
990         }
991     }
992 
993     /**
994      * @dev See {IERC721-approve}.
995      */
996     function approve(address to, uint256 tokenId) public override {
997         address owner = address(uint160(_packedOwnershipOf(tokenId)));
998         if (to == owner) revert ApprovalToCurrentOwner();
999 
1000         if (_msgSenderERC721A() != owner)
1001             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1002                 revert ApprovalCallerNotOwnerNorApproved();
1003             }
1004 
1005         _tokenApprovals[tokenId] = to;
1006         emit Approval(owner, to, tokenId);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-getApproved}.
1011      */
1012     function getApproved(uint256 tokenId) public view override returns (address) {
1013         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1014 
1015         return _tokenApprovals[tokenId];
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-setApprovalForAll}.
1020      */
1021     function setApprovalForAll(address operator, bool approved) public virtual override {
1022         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1023 
1024         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1025         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-isApprovedForAll}.
1030      */
1031     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1032         return _operatorApprovals[owner][operator];
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-transferFrom}.
1037      */
1038     function transferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) public virtual override {
1043         _transfer(from, to, tokenId);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-safeTransferFrom}.
1048      */
1049     function safeTransferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) public virtual override {
1054         safeTransferFrom(from, to, tokenId, '');
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-safeTransferFrom}.
1059      */
1060     function safeTransferFrom(
1061         address from,
1062         address to,
1063         uint256 tokenId,
1064         bytes memory _data
1065     ) public virtual override {
1066         _transfer(from, to, tokenId);
1067         if (to.code.length != 0)
1068             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1069                 revert TransferToNonERC721ReceiverImplementer();
1070             }
1071     }
1072 
1073     /**
1074      * @dev Returns whether `tokenId` exists.
1075      *
1076      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1077      *
1078      * Tokens start existing when they are minted (`_mint`),
1079      */
1080     function _exists(uint256 tokenId) internal view returns (bool) {
1081         return
1082             _startTokenId() <= tokenId &&
1083             tokenId < _currentIndex && // If within bounds,
1084             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1085     }
1086 
1087     /**
1088      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1089      */
1090     function _safeMint(address to, uint256 quantity) internal {
1091         _safeMint(to, quantity, '');
1092     }
1093 
1094     /**
1095      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1096      *
1097      * Requirements:
1098      *
1099      * - If `to` refers to a smart contract, it must implement
1100      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1101      * - `quantity` must be greater than 0.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function _safeMint(
1106         address to,
1107         uint256 quantity,
1108         bytes memory _data
1109     ) internal {
1110         uint256 startTokenId = _currentIndex;
1111         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1112         if (quantity == 0) revert MintZeroQuantity();
1113 
1114         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1115 
1116         // Overflows are incredibly unrealistic.
1117         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1118         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1119         unchecked {
1120             // Updates:
1121             // - `balance += quantity`.
1122             // - `numberMinted += quantity`.
1123             //
1124             // We can directly add to the balance and number minted.
1125             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1126 
1127             // Updates:
1128             // - `address` to the owner.
1129             // - `startTimestamp` to the timestamp of minting.
1130             // - `burned` to `false`.
1131             // - `nextInitialized` to `quantity == 1`.
1132             _packedOwnerships[startTokenId] =
1133                 _addressToUint256(to) |
1134                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1135                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1136 
1137             uint256 updatedIndex = startTokenId;
1138             uint256 end = updatedIndex + quantity;
1139 
1140             if (to.code.length != 0) {
1141                 do {
1142                     emit Transfer(address(0), to, updatedIndex);
1143                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1144                         revert TransferToNonERC721ReceiverImplementer();
1145                     }
1146                 } while (updatedIndex < end);
1147                 // Reentrancy protection
1148                 if (_currentIndex != startTokenId) revert();
1149             } else {
1150                 do {
1151                     emit Transfer(address(0), to, updatedIndex++);
1152                 } while (updatedIndex < end);
1153             }
1154             _currentIndex = updatedIndex;
1155         }
1156         _afterTokenTransfers(address(0), to, startTokenId, quantity);
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
1167      * Emits a {Transfer} event.
1168      */
1169     function _mint(address to, uint256 quantity) internal {
1170         uint256 startTokenId = _currentIndex;
1171         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1172         if (quantity == 0) revert MintZeroQuantity();
1173 
1174         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1175 
1176         // Overflows are incredibly unrealistic.
1177         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1178         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1179         unchecked {
1180             // Updates:
1181             // - `balance += quantity`.
1182             // - `numberMinted += quantity`.
1183             //
1184             // We can directly add to the balance and number minted.
1185             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1186 
1187             // Updates:
1188             // - `address` to the owner.
1189             // - `startTimestamp` to the timestamp of minting.
1190             // - `burned` to `false`.
1191             // - `nextInitialized` to `quantity == 1`.
1192             _packedOwnerships[startTokenId] =
1193                 _addressToUint256(to) |
1194                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1195                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1196 
1197             uint256 updatedIndex = startTokenId;
1198             uint256 end = updatedIndex + quantity;
1199 
1200             do {
1201                 emit Transfer(address(0), to, updatedIndex++);
1202             } while (updatedIndex < end);
1203 
1204             _currentIndex = updatedIndex;
1205         }
1206         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1207     }
1208 
1209     /**
1210      * @dev Transfers `tokenId` from `from` to `to`.
1211      *
1212      * Requirements:
1213      *
1214      * - `to` cannot be the zero address.
1215      * - `tokenId` token must be owned by `from`.
1216      *
1217      * Emits a {Transfer} event.
1218      */
1219     function _transfer(
1220         address from,
1221         address to,
1222         uint256 tokenId
1223     ) private {
1224         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1225 
1226         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1227 
1228         address approvedAddress = _tokenApprovals[tokenId];
1229 
1230         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1231             isApprovedForAll(from, _msgSenderERC721A()) ||
1232             approvedAddress == _msgSenderERC721A());
1233 
1234         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1235         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1236 
1237         _beforeTokenTransfers(from, to, tokenId, 1);
1238 
1239         // Clear approvals from the previous owner.
1240         if (_addressToUint256(approvedAddress) != 0) {
1241             delete _tokenApprovals[tokenId];
1242         }
1243 
1244         // Underflow of the sender's balance is impossible because we check for
1245         // ownership above and the recipient's balance can't realistically overflow.
1246         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1247         unchecked {
1248             // We can directly increment and decrement the balances.
1249             --_packedAddressData[from]; // Updates: `balance -= 1`.
1250             ++_packedAddressData[to]; // Updates: `balance += 1`.
1251 
1252             // Updates:
1253             // - `address` to the next owner.
1254             // - `startTimestamp` to the timestamp of transfering.
1255             // - `burned` to `false`.
1256             // - `nextInitialized` to `true`.
1257             _packedOwnerships[tokenId] =
1258                 _addressToUint256(to) |
1259                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1260                 BITMASK_NEXT_INITIALIZED;
1261 
1262             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1263             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1264                 uint256 nextTokenId = tokenId + 1;
1265                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1266                 if (_packedOwnerships[nextTokenId] == 0) {
1267                     // If the next slot is within bounds.
1268                     if (nextTokenId != _currentIndex) {
1269                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1270                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1271                     }
1272                 }
1273             }
1274         }
1275 
1276         emit Transfer(from, to, tokenId);
1277         _afterTokenTransfers(from, to, tokenId, 1);
1278     }
1279 
1280     /**
1281      * @dev Equivalent to `_burn(tokenId, false)`.
1282      */
1283     function _burn(uint256 tokenId) internal virtual {
1284         _burn(tokenId, false);
1285     }
1286 
1287     /**
1288      * @dev Destroys `tokenId`.
1289      * The approval is cleared when the token is burned.
1290      *
1291      * Requirements:
1292      *
1293      * - `tokenId` must exist.
1294      *
1295      * Emits a {Transfer} event.
1296      */
1297     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1298         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1299 
1300         address from = address(uint160(prevOwnershipPacked));
1301         address approvedAddress = _tokenApprovals[tokenId];
1302 
1303         if (approvalCheck) {
1304             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1305                 isApprovedForAll(from, _msgSenderERC721A()) ||
1306                 approvedAddress == _msgSenderERC721A());
1307 
1308             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1309         }
1310 
1311         _beforeTokenTransfers(from, address(0), tokenId, 1);
1312 
1313         // Clear approvals from the previous owner.
1314         if (_addressToUint256(approvedAddress) != 0) {
1315             delete _tokenApprovals[tokenId];
1316         }
1317 
1318         // Underflow of the sender's balance is impossible because we check for
1319         // ownership above and the recipient's balance can't realistically overflow.
1320         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1321         unchecked {
1322             // Updates:
1323             // - `balance -= 1`.
1324             // - `numberBurned += 1`.
1325             //
1326             // We can directly decrement the balance, and increment the number burned.
1327             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1328             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1329 
1330             // Updates:
1331             // - `address` to the last owner.
1332             // - `startTimestamp` to the timestamp of burning.
1333             // - `burned` to `true`.
1334             // - `nextInitialized` to `true`.
1335             _packedOwnerships[tokenId] =
1336                 _addressToUint256(from) |
1337                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1338                 BITMASK_BURNED | 
1339                 BITMASK_NEXT_INITIALIZED;
1340 
1341             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1342             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1343                 uint256 nextTokenId = tokenId + 1;
1344                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1345                 if (_packedOwnerships[nextTokenId] == 0) {
1346                     // If the next slot is within bounds.
1347                     if (nextTokenId != _currentIndex) {
1348                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1349                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1350                     }
1351                 }
1352             }
1353         }
1354 
1355         emit Transfer(from, address(0), tokenId);
1356         _afterTokenTransfers(from, address(0), tokenId, 1);
1357 
1358         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1359         unchecked {
1360             _burnCounter++;
1361         }
1362     }
1363 
1364     /**
1365      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1366      *
1367      * @param from address representing the previous owner of the given token ID
1368      * @param to target address that will receive the tokens
1369      * @param tokenId uint256 ID of the token to be transferred
1370      * @param _data bytes optional data to send along with the call
1371      * @return bool whether the call correctly returned the expected magic value
1372      */
1373     function _checkContractOnERC721Received(
1374         address from,
1375         address to,
1376         uint256 tokenId,
1377         bytes memory _data
1378     ) private returns (bool) {
1379         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1380             bytes4 retval
1381         ) {
1382             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1383         } catch (bytes memory reason) {
1384             if (reason.length == 0) {
1385                 revert TransferToNonERC721ReceiverImplementer();
1386             } else {
1387                 assembly {
1388                     revert(add(32, reason), mload(reason))
1389                 }
1390             }
1391         }
1392     }
1393 
1394     /**
1395      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1396      * And also called before burning one token.
1397      *
1398      * startTokenId - the first token id to be transferred
1399      * quantity - the amount to be transferred
1400      *
1401      * Calling conditions:
1402      *
1403      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1404      * transferred to `to`.
1405      * - When `from` is zero, `tokenId` will be minted for `to`.
1406      * - When `to` is zero, `tokenId` will be burned by `from`.
1407      * - `from` and `to` are never both zero.
1408      */
1409     function _beforeTokenTransfers(
1410         address from,
1411         address to,
1412         uint256 startTokenId,
1413         uint256 quantity
1414     ) internal virtual {}
1415 
1416     /**
1417      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1418      * minting.
1419      * And also called after one token has been burned.
1420      *
1421      * startTokenId - the first token id to be transferred
1422      * quantity - the amount to be transferred
1423      *
1424      * Calling conditions:
1425      *
1426      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1427      * transferred to `to`.
1428      * - When `from` is zero, `tokenId` has been minted for `to`.
1429      * - When `to` is zero, `tokenId` has been burned by `from`.
1430      * - `from` and `to` are never both zero.
1431      */
1432     function _afterTokenTransfers(
1433         address from,
1434         address to,
1435         uint256 startTokenId,
1436         uint256 quantity
1437     ) internal virtual {}
1438 
1439     /**
1440      * @dev Returns the message sender (defaults to `msg.sender`).
1441      *
1442      * If you are writing GSN compatible contracts, you need to override this function.
1443      */
1444     function _msgSenderERC721A() internal view virtual returns (address) {
1445         return msg.sender;
1446     }
1447 
1448     /**
1449      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1450      */
1451     function _toString(uint256 value) internal pure returns (string memory ptr) {
1452         assembly {
1453             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1454             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1455             // We will need 1 32-byte word to store the length, 
1456             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1457             ptr := add(mload(0x40), 128)
1458             // Update the free memory pointer to allocate.
1459             mstore(0x40, ptr)
1460 
1461             // Cache the end of the memory to calculate the length later.
1462             let end := ptr
1463 
1464             // We write the string from the rightmost digit to the leftmost digit.
1465             // The following is essentially a do-while loop that also handles the zero case.
1466             // Costs a bit more than early returning for the zero case,
1467             // but cheaper in terms of deployment and overall runtime costs.
1468             for { 
1469                 // Initialize and perform the first pass without check.
1470                 let temp := value
1471                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1472                 ptr := sub(ptr, 1)
1473                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1474                 mstore8(ptr, add(48, mod(temp, 10)))
1475                 temp := div(temp, 10)
1476             } temp { 
1477                 // Keep dividing `temp` until zero.
1478                 temp := div(temp, 10)
1479             } { // Body of the for loop.
1480                 ptr := sub(ptr, 1)
1481                 mstore8(ptr, add(48, mod(temp, 10)))
1482             }
1483             
1484             let length := sub(end, ptr)
1485             // Move the pointer 32 bytes leftwards to make room for the length.
1486             ptr := sub(ptr, 32)
1487             // Store the length.
1488             mstore(ptr, length)
1489         }
1490     }
1491 }
1492 // File: contracts/potatoByKingGeorge.sol
1493 
1494 //SPDX-License-Identifier: MIT
1495 // pragma solidity ^0.8.9;
1496 pragma solidity >=0.7.0 <0.9.0;
1497 
1498 
1499 
1500 
1501 
1502 contract PotatoByKingGeorge is ERC721A, Ownable {
1503     using Strings for uint256;
1504     
1505     uint256 public constant MAX_SUPPLY = 6666;
1506     bytes32 public merkleRoot;
1507 
1508     uint256 public salePrice = 0.015 ether;
1509     uint256 public maxPerTx = 5;
1510 
1511     bool private publicSale = false;
1512     bool private whitelistSale = false;
1513 
1514     string public baseURI;
1515 
1516     constructor() ERC721A("Potato By King George", "PBKG") {}
1517 
1518     /**
1519      * @notice token start from id 1
1520      */
1521     function _startTokenId() internal view virtual override returns (uint256) {
1522         return 1;
1523     }
1524 
1525     /**
1526      * @notice team mint
1527      */
1528     function teamMint(address[] memory to, uint quantity) external onlyOwner {
1529         require((to.length * quantity) + totalSupply() <= MAX_SUPPLY, "Sold out");
1530 
1531         for(uint i=0; i<to.length; i++){
1532             _mint(to[i], quantity);
1533         }
1534     }
1535     
1536     /**
1537      * @notice whitelist mint
1538      */
1539     function whitelistMint(uint quantity, bytes32[] memory proof) external payable {
1540         require(whitelistSale, "Whitelist sale is not Active.");
1541         require(MerkleProof.verify(proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Not whitelisted.");       
1542         _mint(quantity);
1543     }
1544 
1545     /**
1546      * @notice public mint
1547      */
1548     function publicMint(uint quantity) external payable {
1549         require(publicSale, "Public sale is not active.");
1550         _mint(quantity);
1551     }
1552 
1553     /**
1554      * @notice mint
1555      */
1556     function _mint(uint quantity) internal {
1557         require(quantity <= maxPerTx && quantity > 0, "Invalid quantity or Max Per Tx.");
1558         require(quantity + totalSupply() <= MAX_SUPPLY, "Sold out");
1559         if(balanceOf(_msgSender()) == 0) {
1560             require(msg.value >= salePrice * (quantity - 1), "Not enough ETH to mint");
1561         } else {
1562             require(msg.value >= salePrice * quantity, "Not enough ETH to mint");
1563         }
1564         _mint(_msgSender(), quantity);
1565     }
1566 
1567     /**
1568      * @notice set whitelist merkle root
1569      */
1570     function setMerkleRoot(bytes32 _rootHash) external onlyOwner {
1571         merkleRoot = _rootHash;
1572     }
1573 
1574     /**
1575      * @notice set max per transaction
1576      */
1577     function setMaxTx(uint256 _setMaxTx) external onlyOwner {
1578         maxPerTx = _setMaxTx;
1579     }
1580     
1581     /**
1582      * @notice set sale price
1583      */
1584     function setSalePrice(uint256 _salePrice) external onlyOwner {
1585         salePrice = _salePrice;
1586     }
1587 
1588     /**
1589      * @notice set base uri
1590      */
1591     function setBaseURI(string memory uri) external onlyOwner {
1592         baseURI = uri;
1593     }
1594 
1595     /**
1596      * @notice switch public sales status
1597      */
1598     function switchPublicSales() external onlyOwner {
1599         publicSale = !publicSale;
1600     }
1601 
1602     /**
1603      * @notice switch whitelist mint status
1604      */
1605     function switchWhitelistStatus() external onlyOwner {
1606         whitelistSale = !whitelistSale;
1607     }
1608 
1609     /**
1610      * @notice token URI
1611      */
1612     function tokenURI(uint256 _tokenId)
1613         public
1614         view
1615         virtual
1616         override
1617         returns (string memory)
1618     {
1619         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1620         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _tokenId.toString())) : '';
1621     }
1622 
1623     /**
1624      * @notice transfer funds
1625      */
1626     function withdrawal() external onlyOwner {
1627         uint256 balance = address(this).balance;
1628         payable(msg.sender).transfer(balance);
1629     }
1630 }