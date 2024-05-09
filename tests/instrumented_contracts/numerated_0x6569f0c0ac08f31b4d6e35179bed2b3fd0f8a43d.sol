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
243 // File: @openzeppelin/contracts/access/Ownable.sol
244 
245 
246 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
247 
248 pragma solidity ^0.8.0;
249 
250 
251 /**
252  * @dev Contract module which provides a basic access control mechanism, where
253  * there is an account (an owner) that can be granted exclusive access to
254  * specific functions.
255  *
256  * By default, the owner account will be the one that deploys the contract. This
257  * can later be changed with {transferOwnership}.
258  *
259  * This module is used through inheritance. It will make available the modifier
260  * `onlyOwner`, which can be applied to your functions to restrict their use to
261  * the owner.
262  */
263 abstract contract Ownable is Context {
264     address private _owner;
265 
266     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
267 
268     /**
269      * @dev Initializes the contract setting the deployer as the initial owner.
270      */
271     constructor() {
272         _transferOwnership(_msgSender());
273     }
274 
275     /**
276      * @dev Throws if called by any account other than the owner.
277      */
278     modifier onlyOwner() {
279         _checkOwner();
280         _;
281     }
282 
283     /**
284      * @dev Returns the address of the current owner.
285      */
286     function owner() public view virtual returns (address) {
287         return _owner;
288     }
289 
290     /**
291      * @dev Throws if the sender is not the owner.
292      */
293     function _checkOwner() internal view virtual {
294         require(owner() == _msgSender(), "Ownable: caller is not the owner");
295     }
296 
297     /**
298      * @dev Leaves the contract without owner. It will not be possible to call
299      * `onlyOwner` functions anymore. Can only be called by the current owner.
300      *
301      * NOTE: Renouncing ownership will leave the contract without an owner,
302      * thereby removing any functionality that is only available to the owner.
303      */
304     function renounceOwnership() public virtual onlyOwner {
305         _transferOwnership(address(0));
306     }
307 
308     /**
309      * @dev Transfers ownership of the contract to a new account (`newOwner`).
310      * Can only be called by the current owner.
311      */
312     function transferOwnership(address newOwner) public virtual onlyOwner {
313         require(newOwner != address(0), "Ownable: new owner is the zero address");
314         _transferOwnership(newOwner);
315     }
316 
317     /**
318      * @dev Transfers ownership of the contract to a new account (`newOwner`).
319      * Internal function without access restriction.
320      */
321     function _transferOwnership(address newOwner) internal virtual {
322         address oldOwner = _owner;
323         _owner = newOwner;
324         emit OwnershipTransferred(oldOwner, newOwner);
325     }
326 }
327 
328 // File: @openzeppelin/contracts/utils/Counters.sol
329 
330 
331 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 /**
336  * @title Counters
337  * @author Matt Condon (@shrugs)
338  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
339  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
340  *
341  * Include with `using Counters for Counters.Counter;`
342  */
343 library Counters {
344     struct Counter {
345         // This variable should never be directly accessed by users of the library: interactions must be restricted to
346         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
347         // this feature: see https://github.com/ethereum/solidity/issues/4637
348         uint256 _value; // default: 0
349     }
350 
351     function current(Counter storage counter) internal view returns (uint256) {
352         return counter._value;
353     }
354 
355     function increment(Counter storage counter) internal {
356         unchecked {
357             counter._value += 1;
358         }
359     }
360 
361     function decrement(Counter storage counter) internal {
362         uint256 value = counter._value;
363         require(value > 0, "Counter: decrement overflow");
364         unchecked {
365             counter._value = value - 1;
366         }
367     }
368 
369     function reset(Counter storage counter) internal {
370         counter._value = 0;
371     }
372 }
373 
374 // File: @openzeppelin/contracts/utils/Strings.sol
375 
376 
377 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
378 
379 pragma solidity ^0.8.0;
380 
381 /**
382  * @dev String operations.
383  */
384 library Strings {
385     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
386     uint8 private constant _ADDRESS_LENGTH = 20;
387 
388     /**
389      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
390      */
391     function toString(uint256 value) internal pure returns (string memory) {
392         // Inspired by OraclizeAPI's implementation - MIT licence
393         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
394 
395         if (value == 0) {
396             return "0";
397         }
398         uint256 temp = value;
399         uint256 digits;
400         while (temp != 0) {
401             digits++;
402             temp /= 10;
403         }
404         bytes memory buffer = new bytes(digits);
405         while (value != 0) {
406             digits -= 1;
407             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
408             value /= 10;
409         }
410         return string(buffer);
411     }
412 
413     /**
414      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
415      */
416     function toHexString(uint256 value) internal pure returns (string memory) {
417         if (value == 0) {
418             return "0x00";
419         }
420         uint256 temp = value;
421         uint256 length = 0;
422         while (temp != 0) {
423             length++;
424             temp >>= 8;
425         }
426         return toHexString(value, length);
427     }
428 
429     /**
430      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
431      */
432     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
433         bytes memory buffer = new bytes(2 * length + 2);
434         buffer[0] = "0";
435         buffer[1] = "x";
436         for (uint256 i = 2 * length + 1; i > 1; --i) {
437             buffer[i] = _HEX_SYMBOLS[value & 0xf];
438             value >>= 4;
439         }
440         require(value == 0, "Strings: hex length insufficient");
441         return string(buffer);
442     }
443 
444     /**
445      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
446      */
447     function toHexString(address addr) internal pure returns (string memory) {
448         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
449     }
450 }
451 
452 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
453 
454 
455 // ERC721A Contracts v4.1.0
456 // Creator: Chiru Labs
457 
458 pragma solidity ^0.8.4;
459 
460 /**
461  * @dev Interface of an ERC721A compliant contract.
462  */
463 interface IERC721A {
464     /**
465      * The caller must own the token or be an approved operator.
466      */
467     error ApprovalCallerNotOwnerNorApproved();
468 
469     /**
470      * The token does not exist.
471      */
472     error ApprovalQueryForNonexistentToken();
473 
474     /**
475      * The caller cannot approve to their own address.
476      */
477     error ApproveToCaller();
478 
479     /**
480      * Cannot query the balance for the zero address.
481      */
482     error BalanceQueryForZeroAddress();
483 
484     /**
485      * Cannot mint to the zero address.
486      */
487     error MintToZeroAddress();
488 
489     /**
490      * The quantity of tokens minted must be more than zero.
491      */
492     error MintZeroQuantity();
493 
494     /**
495      * The token does not exist.
496      */
497     error OwnerQueryForNonexistentToken();
498 
499     /**
500      * The caller must own the token or be an approved operator.
501      */
502     error TransferCallerNotOwnerNorApproved();
503 
504     /**
505      * The token must be owned by `from`.
506      */
507     error TransferFromIncorrectOwner();
508 
509     /**
510      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
511      */
512     error TransferToNonERC721ReceiverImplementer();
513 
514     /**
515      * Cannot transfer to the zero address.
516      */
517     error TransferToZeroAddress();
518 
519     /**
520      * The token does not exist.
521      */
522     error URIQueryForNonexistentToken();
523 
524     /**
525      * The `quantity` minted with ERC2309 exceeds the safety limit.
526      */
527     error MintERC2309QuantityExceedsLimit();
528 
529     /**
530      * The `extraData` cannot be set on an unintialized ownership slot.
531      */
532     error OwnershipNotInitializedForExtraData();
533 
534     struct TokenOwnership {
535         // The address of the owner.
536         address addr;
537         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
538         uint64 startTimestamp;
539         // Whether the token has been burned.
540         bool burned;
541         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
542         uint24 extraData;
543     }
544 
545     /**
546      * @dev Returns the total amount of tokens stored by the contract.
547      *
548      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
549      */
550     function totalSupply() external view returns (uint256);
551 
552     // ==============================
553     //            IERC165
554     // ==============================
555 
556     /**
557      * @dev Returns true if this contract implements the interface defined by
558      * `interfaceId`. See the corresponding
559      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
560      * to learn more about how these ids are created.
561      *
562      * This function call must use less than 30 000 gas.
563      */
564     function supportsInterface(bytes4 interfaceId) external view returns (bool);
565 
566     // ==============================
567     //            IERC721
568     // ==============================
569 
570     /**
571      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
572      */
573     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
574 
575     /**
576      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
577      */
578     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
579 
580     /**
581      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
582      */
583     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
584 
585     /**
586      * @dev Returns the number of tokens in ``owner``'s account.
587      */
588     function balanceOf(address owner) external view returns (uint256 balance);
589 
590     /**
591      * @dev Returns the owner of the `tokenId` token.
592      *
593      * Requirements:
594      *
595      * - `tokenId` must exist.
596      */
597     function ownerOf(uint256 tokenId) external view returns (address owner);
598 
599     /**
600      * @dev Safely transfers `tokenId` token from `from` to `to`.
601      *
602      * Requirements:
603      *
604      * - `from` cannot be the zero address.
605      * - `to` cannot be the zero address.
606      * - `tokenId` token must exist and be owned by `from`.
607      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
608      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
609      *
610      * Emits a {Transfer} event.
611      */
612     function safeTransferFrom(
613         address from,
614         address to,
615         uint256 tokenId,
616         bytes calldata data
617     ) external;
618 
619     /**
620      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
621      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
622      *
623      * Requirements:
624      *
625      * - `from` cannot be the zero address.
626      * - `to` cannot be the zero address.
627      * - `tokenId` token must exist and be owned by `from`.
628      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
629      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
630      *
631      * Emits a {Transfer} event.
632      */
633     function safeTransferFrom(
634         address from,
635         address to,
636         uint256 tokenId
637     ) external;
638 
639     /**
640      * @dev Transfers `tokenId` token from `from` to `to`.
641      *
642      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
643      *
644      * Requirements:
645      *
646      * - `from` cannot be the zero address.
647      * - `to` cannot be the zero address.
648      * - `tokenId` token must be owned by `from`.
649      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
650      *
651      * Emits a {Transfer} event.
652      */
653     function transferFrom(
654         address from,
655         address to,
656         uint256 tokenId
657     ) external;
658 
659     /**
660      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
661      * The approval is cleared when the token is transferred.
662      *
663      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
664      *
665      * Requirements:
666      *
667      * - The caller must own the token or be an approved operator.
668      * - `tokenId` must exist.
669      *
670      * Emits an {Approval} event.
671      */
672     function approve(address to, uint256 tokenId) external;
673 
674     /**
675      * @dev Approve or remove `operator` as an operator for the caller.
676      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
677      *
678      * Requirements:
679      *
680      * - The `operator` cannot be the caller.
681      *
682      * Emits an {ApprovalForAll} event.
683      */
684     function setApprovalForAll(address operator, bool _approved) external;
685 
686     /**
687      * @dev Returns the account approved for `tokenId` token.
688      *
689      * Requirements:
690      *
691      * - `tokenId` must exist.
692      */
693     function getApproved(uint256 tokenId) external view returns (address operator);
694 
695     /**
696      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
697      *
698      * See {setApprovalForAll}
699      */
700     function isApprovedForAll(address owner, address operator) external view returns (bool);
701 
702     // ==============================
703     //        IERC721Metadata
704     // ==============================
705 
706     /**
707      * @dev Returns the token collection name.
708      */
709     function name() external view returns (string memory);
710 
711     /**
712      * @dev Returns the token collection symbol.
713      */
714     function symbol() external view returns (string memory);
715 
716     /**
717      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
718      */
719     function tokenURI(uint256 tokenId) external view returns (string memory);
720 
721     // ==============================
722     //            IERC2309
723     // ==============================
724 
725     /**
726      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
727      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
728      */
729     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
730 }
731 
732 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
733 
734 
735 // ERC721A Contracts v4.1.0
736 // Creator: Chiru Labs
737 
738 pragma solidity ^0.8.4;
739 
740 
741 /**
742  * @dev ERC721 token receiver interface.
743  */
744 interface ERC721A__IERC721Receiver {
745     function onERC721Received(
746         address operator,
747         address from,
748         uint256 tokenId,
749         bytes calldata data
750     ) external returns (bytes4);
751 }
752 
753 /**
754  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
755  * including the Metadata extension. Built to optimize for lower gas during batch mints.
756  *
757  * Assumes serials are sequentially minted starting at `_startTokenId()`
758  * (defaults to 0, e.g. 0, 1, 2, 3..).
759  *
760  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
761  *
762  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
763  */
764 contract ERC721A is IERC721A {
765     // Mask of an entry in packed address data.
766     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
767 
768     // The bit position of `numberMinted` in packed address data.
769     uint256 private constant BITPOS_NUMBER_MINTED = 64;
770 
771     // The bit position of `numberBurned` in packed address data.
772     uint256 private constant BITPOS_NUMBER_BURNED = 128;
773 
774     // The bit position of `aux` in packed address data.
775     uint256 private constant BITPOS_AUX = 192;
776 
777     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
778     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
779 
780     // The bit position of `startTimestamp` in packed ownership.
781     uint256 private constant BITPOS_START_TIMESTAMP = 160;
782 
783     // The bit mask of the `burned` bit in packed ownership.
784     uint256 private constant BITMASK_BURNED = 1 << 224;
785 
786     // The bit position of the `nextInitialized` bit in packed ownership.
787     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
788 
789     // The bit mask of the `nextInitialized` bit in packed ownership.
790     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
791 
792     // The bit position of `extraData` in packed ownership.
793     uint256 private constant BITPOS_EXTRA_DATA = 232;
794 
795     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
796     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
797 
798     // The mask of the lower 160 bits for addresses.
799     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
800 
801     // The maximum `quantity` that can be minted with `_mintERC2309`.
802     // This limit is to prevent overflows on the address data entries.
803     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
804     // is required to cause an overflow, which is unrealistic.
805     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
806 
807     // The tokenId of the next token to be minted.
808     uint256 private _currentIndex;
809 
810     // The number of tokens burned.
811     uint256 private _burnCounter;
812 
813     // Token name
814     string private _name;
815 
816     // Token symbol
817     string private _symbol;
818 
819     // Mapping from token ID to ownership details
820     // An empty struct value does not necessarily mean the token is unowned.
821     // See `_packedOwnershipOf` implementation for details.
822     //
823     // Bits Layout:
824     // - [0..159]   `addr`
825     // - [160..223] `startTimestamp`
826     // - [224]      `burned`
827     // - [225]      `nextInitialized`
828     // - [232..255] `extraData`
829     mapping(uint256 => uint256) private _packedOwnerships;
830 
831     // Mapping owner address to address data.
832     //
833     // Bits Layout:
834     // - [0..63]    `balance`
835     // - [64..127]  `numberMinted`
836     // - [128..191] `numberBurned`
837     // - [192..255] `aux`
838     mapping(address => uint256) private _packedAddressData;
839 
840     // Mapping from token ID to approved address.
841     mapping(uint256 => address) private _tokenApprovals;
842 
843     // Mapping from owner to operator approvals
844     mapping(address => mapping(address => bool)) private _operatorApprovals;
845 
846     constructor(string memory name_, string memory symbol_) {
847         _name = name_;
848         _symbol = symbol_;
849         _currentIndex = _startTokenId();
850     }
851 
852     /**
853      * @dev Returns the starting token ID.
854      * To change the starting token ID, please override this function.
855      */
856     function _startTokenId() internal view virtual returns (uint256) {
857         return 0;
858     }
859 
860     /**
861      * @dev Returns the next token ID to be minted.
862      */
863     function _nextTokenId() internal view returns (uint256) {
864         return _currentIndex;
865     }
866 
867     /**
868      * @dev Returns the total number of tokens in existence.
869      * Burned tokens will reduce the count.
870      * To get the total number of tokens minted, please see `_totalMinted`.
871      */
872     function totalSupply() public view override returns (uint256) {
873         // Counter underflow is impossible as _burnCounter cannot be incremented
874         // more than `_currentIndex - _startTokenId()` times.
875         unchecked {
876             return _currentIndex - _burnCounter - _startTokenId();
877         }
878     }
879 
880     /**
881      * @dev Returns the total amount of tokens minted in the contract.
882      */
883     function _totalMinted() internal view returns (uint256) {
884         // Counter underflow is impossible as _currentIndex does not decrement,
885         // and it is initialized to `_startTokenId()`
886         unchecked {
887             return _currentIndex - _startTokenId();
888         }
889     }
890 
891     /**
892      * @dev Returns the total number of tokens burned.
893      */
894     function _totalBurned() internal view returns (uint256) {
895         return _burnCounter;
896     }
897 
898     /**
899      * @dev See {IERC165-supportsInterface}.
900      */
901     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
902         // The interface IDs are constants representing the first 4 bytes of the XOR of
903         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
904         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
905         return
906             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
907             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
908             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
909     }
910 
911     /**
912      * @dev See {IERC721-balanceOf}.
913      */
914     function balanceOf(address owner) public view override returns (uint256) {
915         if (owner == address(0)) revert BalanceQueryForZeroAddress();
916         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
917     }
918 
919     /**
920      * Returns the number of tokens minted by `owner`.
921      */
922     function _numberMinted(address owner) internal view returns (uint256) {
923         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
924     }
925 
926     /**
927      * Returns the number of tokens burned by or on behalf of `owner`.
928      */
929     function _numberBurned(address owner) internal view returns (uint256) {
930         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
931     }
932 
933     /**
934      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
935      */
936     function _getAux(address owner) internal view returns (uint64) {
937         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
938     }
939 
940     /**
941      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
942      * If there are multiple variables, please pack them into a uint64.
943      */
944     function _setAux(address owner, uint64 aux) internal {
945         uint256 packed = _packedAddressData[owner];
946         uint256 auxCasted;
947         // Cast `aux` with assembly to avoid redundant masking.
948         assembly {
949             auxCasted := aux
950         }
951         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
952         _packedAddressData[owner] = packed;
953     }
954 
955     /**
956      * Returns the packed ownership data of `tokenId`.
957      */
958     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
959         uint256 curr = tokenId;
960 
961         unchecked {
962             if (_startTokenId() <= curr)
963                 if (curr < _currentIndex) {
964                     uint256 packed = _packedOwnerships[curr];
965                     // If not burned.
966                     if (packed & BITMASK_BURNED == 0) {
967                         // Invariant:
968                         // There will always be an ownership that has an address and is not burned
969                         // before an ownership that does not have an address and is not burned.
970                         // Hence, curr will not underflow.
971                         //
972                         // We can directly compare the packed value.
973                         // If the address is zero, packed is zero.
974                         while (packed == 0) {
975                             packed = _packedOwnerships[--curr];
976                         }
977                         return packed;
978                     }
979                 }
980         }
981         revert OwnerQueryForNonexistentToken();
982     }
983 
984     /**
985      * Returns the unpacked `TokenOwnership` struct from `packed`.
986      */
987     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
988         ownership.addr = address(uint160(packed));
989         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
990         ownership.burned = packed & BITMASK_BURNED != 0;
991         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
992     }
993 
994     /**
995      * Returns the unpacked `TokenOwnership` struct at `index`.
996      */
997     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
998         return _unpackedOwnership(_packedOwnerships[index]);
999     }
1000 
1001     /**
1002      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1003      */
1004     function _initializeOwnershipAt(uint256 index) internal {
1005         if (_packedOwnerships[index] == 0) {
1006             _packedOwnerships[index] = _packedOwnershipOf(index);
1007         }
1008     }
1009 
1010     /**
1011      * Gas spent here starts off proportional to the maximum mint batch size.
1012      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1013      */
1014     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1015         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1016     }
1017 
1018     /**
1019      * @dev Packs ownership data into a single uint256.
1020      */
1021     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1022         assembly {
1023             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1024             owner := and(owner, BITMASK_ADDRESS)
1025             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1026             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1027         }
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-ownerOf}.
1032      */
1033     function ownerOf(uint256 tokenId) public view override returns (address) {
1034         return address(uint160(_packedOwnershipOf(tokenId)));
1035     }
1036 
1037     /**
1038      * @dev See {IERC721Metadata-name}.
1039      */
1040     function name() public view virtual override returns (string memory) {
1041         return _name;
1042     }
1043 
1044     /**
1045      * @dev See {IERC721Metadata-symbol}.
1046      */
1047     function symbol() public view virtual override returns (string memory) {
1048         return _symbol;
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Metadata-tokenURI}.
1053      */
1054     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1055         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1056 
1057         string memory baseURI = _baseURI();
1058         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1059     }
1060 
1061     /**
1062      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1063      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1064      * by default, it can be overridden in child contracts.
1065      */
1066     function _baseURI() internal view virtual returns (string memory) {
1067         return '';
1068     }
1069 
1070     /**
1071      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1072      */
1073     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1074         // For branchless setting of the `nextInitialized` flag.
1075         assembly {
1076             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1077             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1078         }
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-approve}.
1083      */
1084     function approve(address to, uint256 tokenId) public override {
1085         address owner = ownerOf(tokenId);
1086 
1087         if (_msgSenderERC721A() != owner)
1088             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1089                 revert ApprovalCallerNotOwnerNorApproved();
1090             }
1091 
1092         _tokenApprovals[tokenId] = to;
1093         emit Approval(owner, to, tokenId);
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-getApproved}.
1098      */
1099     function getApproved(uint256 tokenId) public view override returns (address) {
1100         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1101 
1102         return _tokenApprovals[tokenId];
1103     }
1104 
1105     /**
1106      * @dev See {IERC721-setApprovalForAll}.
1107      */
1108     function setApprovalForAll(address operator, bool approved) public virtual override {
1109         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1110 
1111         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1112         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-isApprovedForAll}.
1117      */
1118     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1119         return _operatorApprovals[owner][operator];
1120     }
1121 
1122     /**
1123      * @dev See {IERC721-safeTransferFrom}.
1124      */
1125     function safeTransferFrom(
1126         address from,
1127         address to,
1128         uint256 tokenId
1129     ) public virtual override {
1130         safeTransferFrom(from, to, tokenId, '');
1131     }
1132 
1133     /**
1134      * @dev See {IERC721-safeTransferFrom}.
1135      */
1136     function safeTransferFrom(
1137         address from,
1138         address to,
1139         uint256 tokenId,
1140         bytes memory _data
1141     ) public virtual override {
1142         transferFrom(from, to, tokenId);
1143         if (to.code.length != 0)
1144             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1145                 revert TransferToNonERC721ReceiverImplementer();
1146             }
1147     }
1148 
1149     /**
1150      * @dev Returns whether `tokenId` exists.
1151      *
1152      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1153      *
1154      * Tokens start existing when they are minted (`_mint`),
1155      */
1156     function _exists(uint256 tokenId) internal view returns (bool) {
1157         return
1158             _startTokenId() <= tokenId &&
1159             tokenId < _currentIndex && // If within bounds,
1160             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1161     }
1162 
1163     /**
1164      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1165      */
1166     function _safeMint(address to, uint256 quantity) internal {
1167         _safeMint(to, quantity, '');
1168     }
1169 
1170     /**
1171      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1172      *
1173      * Requirements:
1174      *
1175      * - If `to` refers to a smart contract, it must implement
1176      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1177      * - `quantity` must be greater than 0.
1178      *
1179      * See {_mint}.
1180      *
1181      * Emits a {Transfer} event for each mint.
1182      */
1183     function _safeMint(
1184         address to,
1185         uint256 quantity,
1186         bytes memory _data
1187     ) internal {
1188         _mint(to, quantity);
1189 
1190         unchecked {
1191             if (to.code.length != 0) {
1192                 uint256 end = _currentIndex;
1193                 uint256 index = end - quantity;
1194                 do {
1195                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1196                         revert TransferToNonERC721ReceiverImplementer();
1197                     }
1198                 } while (index < end);
1199                 // Reentrancy protection.
1200                 if (_currentIndex != end) revert();
1201             }
1202         }
1203     }
1204 
1205     /**
1206      * @dev Mints `quantity` tokens and transfers them to `to`.
1207      *
1208      * Requirements:
1209      *
1210      * - `to` cannot be the zero address.
1211      * - `quantity` must be greater than 0.
1212      *
1213      * Emits a {Transfer} event for each mint.
1214      */
1215     function _mint(address to, uint256 quantity) internal {
1216         uint256 startTokenId = _currentIndex;
1217         if (to == address(0)) revert MintToZeroAddress();
1218         if (quantity == 0) revert MintZeroQuantity();
1219 
1220         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1221 
1222         // Overflows are incredibly unrealistic.
1223         // `balance` and `numberMinted` have a maximum limit of 2**64.
1224         // `tokenId` has a maximum limit of 2**256.
1225         unchecked {
1226             // Updates:
1227             // - `balance += quantity`.
1228             // - `numberMinted += quantity`.
1229             //
1230             // We can directly add to the `balance` and `numberMinted`.
1231             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1232 
1233             // Updates:
1234             // - `address` to the owner.
1235             // - `startTimestamp` to the timestamp of minting.
1236             // - `burned` to `false`.
1237             // - `nextInitialized` to `quantity == 1`.
1238             _packedOwnerships[startTokenId] = _packOwnershipData(
1239                 to,
1240                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1241             );
1242 
1243             uint256 tokenId = startTokenId;
1244             uint256 end = startTokenId + quantity;
1245             do {
1246                 emit Transfer(address(0), to, tokenId++);
1247             } while (tokenId < end);
1248 
1249             _currentIndex = end;
1250         }
1251         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1252     }
1253 
1254     /**
1255      * @dev Mints `quantity` tokens and transfers them to `to`.
1256      *
1257      * This function is intended for efficient minting only during contract creation.
1258      *
1259      * It emits only one {ConsecutiveTransfer} as defined in
1260      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1261      * instead of a sequence of {Transfer} event(s).
1262      *
1263      * Calling this function outside of contract creation WILL make your contract
1264      * non-compliant with the ERC721 standard.
1265      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1266      * {ConsecutiveTransfer} event is only permissible during contract creation.
1267      *
1268      * Requirements:
1269      *
1270      * - `to` cannot be the zero address.
1271      * - `quantity` must be greater than 0.
1272      *
1273      * Emits a {ConsecutiveTransfer} event.
1274      */
1275     function _mintERC2309(address to, uint256 quantity) internal {
1276         uint256 startTokenId = _currentIndex;
1277         if (to == address(0)) revert MintToZeroAddress();
1278         if (quantity == 0) revert MintZeroQuantity();
1279         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1280 
1281         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1282 
1283         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1284         unchecked {
1285             // Updates:
1286             // - `balance += quantity`.
1287             // - `numberMinted += quantity`.
1288             //
1289             // We can directly add to the `balance` and `numberMinted`.
1290             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1291 
1292             // Updates:
1293             // - `address` to the owner.
1294             // - `startTimestamp` to the timestamp of minting.
1295             // - `burned` to `false`.
1296             // - `nextInitialized` to `quantity == 1`.
1297             _packedOwnerships[startTokenId] = _packOwnershipData(
1298                 to,
1299                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1300             );
1301 
1302             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1303 
1304             _currentIndex = startTokenId + quantity;
1305         }
1306         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1307     }
1308 
1309     /**
1310      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1311      */
1312     function _getApprovedAddress(uint256 tokenId)
1313         private
1314         view
1315         returns (uint256 approvedAddressSlot, address approvedAddress)
1316     {
1317         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1318         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1319         assembly {
1320             // Compute the slot.
1321             mstore(0x00, tokenId)
1322             mstore(0x20, tokenApprovalsPtr.slot)
1323             approvedAddressSlot := keccak256(0x00, 0x40)
1324             // Load the slot's value from storage.
1325             approvedAddress := sload(approvedAddressSlot)
1326         }
1327     }
1328 
1329     /**
1330      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1331      */
1332     function _isOwnerOrApproved(
1333         address approvedAddress,
1334         address from,
1335         address msgSender
1336     ) private pure returns (bool result) {
1337         assembly {
1338             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1339             from := and(from, BITMASK_ADDRESS)
1340             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1341             msgSender := and(msgSender, BITMASK_ADDRESS)
1342             // `msgSender == from || msgSender == approvedAddress`.
1343             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1344         }
1345     }
1346 
1347     /**
1348      * @dev Transfers `tokenId` from `from` to `to`.
1349      *
1350      * Requirements:
1351      *
1352      * - `to` cannot be the zero address.
1353      * - `tokenId` token must be owned by `from`.
1354      *
1355      * Emits a {Transfer} event.
1356      */
1357     function transferFrom(
1358         address from,
1359         address to,
1360         uint256 tokenId
1361     ) public virtual override {
1362         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1363 
1364         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1365 
1366         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1367 
1368         // The nested ifs save around 20+ gas over a compound boolean condition.
1369         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1370             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1371 
1372         if (to == address(0)) revert TransferToZeroAddress();
1373 
1374         _beforeTokenTransfers(from, to, tokenId, 1);
1375 
1376         // Clear approvals from the previous owner.
1377         assembly {
1378             if approvedAddress {
1379                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1380                 sstore(approvedAddressSlot, 0)
1381             }
1382         }
1383 
1384         // Underflow of the sender's balance is impossible because we check for
1385         // ownership above and the recipient's balance can't realistically overflow.
1386         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1387         unchecked {
1388             // We can directly increment and decrement the balances.
1389             --_packedAddressData[from]; // Updates: `balance -= 1`.
1390             ++_packedAddressData[to]; // Updates: `balance += 1`.
1391 
1392             // Updates:
1393             // - `address` to the next owner.
1394             // - `startTimestamp` to the timestamp of transfering.
1395             // - `burned` to `false`.
1396             // - `nextInitialized` to `true`.
1397             _packedOwnerships[tokenId] = _packOwnershipData(
1398                 to,
1399                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1400             );
1401 
1402             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1403             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1404                 uint256 nextTokenId = tokenId + 1;
1405                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1406                 if (_packedOwnerships[nextTokenId] == 0) {
1407                     // If the next slot is within bounds.
1408                     if (nextTokenId != _currentIndex) {
1409                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1410                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1411                     }
1412                 }
1413             }
1414         }
1415 
1416         emit Transfer(from, to, tokenId);
1417         _afterTokenTransfers(from, to, tokenId, 1);
1418     }
1419 
1420     /**
1421      * @dev Equivalent to `_burn(tokenId, false)`.
1422      */
1423     function _burn(uint256 tokenId) internal virtual {
1424         _burn(tokenId, false);
1425     }
1426 
1427     /**
1428      * @dev Destroys `tokenId`.
1429      * The approval is cleared when the token is burned.
1430      *
1431      * Requirements:
1432      *
1433      * - `tokenId` must exist.
1434      *
1435      * Emits a {Transfer} event.
1436      */
1437     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1438         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1439 
1440         address from = address(uint160(prevOwnershipPacked));
1441 
1442         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1443 
1444         if (approvalCheck) {
1445             // The nested ifs save around 20+ gas over a compound boolean condition.
1446             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1447                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1448         }
1449 
1450         _beforeTokenTransfers(from, address(0), tokenId, 1);
1451 
1452         // Clear approvals from the previous owner.
1453         assembly {
1454             if approvedAddress {
1455                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1456                 sstore(approvedAddressSlot, 0)
1457             }
1458         }
1459 
1460         // Underflow of the sender's balance is impossible because we check for
1461         // ownership above and the recipient's balance can't realistically overflow.
1462         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1463         unchecked {
1464             // Updates:
1465             // - `balance -= 1`.
1466             // - `numberBurned += 1`.
1467             //
1468             // We can directly decrement the balance, and increment the number burned.
1469             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1470             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1471 
1472             // Updates:
1473             // - `address` to the last owner.
1474             // - `startTimestamp` to the timestamp of burning.
1475             // - `burned` to `true`.
1476             // - `nextInitialized` to `true`.
1477             _packedOwnerships[tokenId] = _packOwnershipData(
1478                 from,
1479                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1480             );
1481 
1482             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1483             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1484                 uint256 nextTokenId = tokenId + 1;
1485                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1486                 if (_packedOwnerships[nextTokenId] == 0) {
1487                     // If the next slot is within bounds.
1488                     if (nextTokenId != _currentIndex) {
1489                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1490                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1491                     }
1492                 }
1493             }
1494         }
1495 
1496         emit Transfer(from, address(0), tokenId);
1497         _afterTokenTransfers(from, address(0), tokenId, 1);
1498 
1499         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1500         unchecked {
1501             _burnCounter++;
1502         }
1503     }
1504 
1505     /**
1506      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1507      *
1508      * @param from address representing the previous owner of the given token ID
1509      * @param to target address that will receive the tokens
1510      * @param tokenId uint256 ID of the token to be transferred
1511      * @param _data bytes optional data to send along with the call
1512      * @return bool whether the call correctly returned the expected magic value
1513      */
1514     function _checkContractOnERC721Received(
1515         address from,
1516         address to,
1517         uint256 tokenId,
1518         bytes memory _data
1519     ) private returns (bool) {
1520         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1521             bytes4 retval
1522         ) {
1523             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1524         } catch (bytes memory reason) {
1525             if (reason.length == 0) {
1526                 revert TransferToNonERC721ReceiverImplementer();
1527             } else {
1528                 assembly {
1529                     revert(add(32, reason), mload(reason))
1530                 }
1531             }
1532         }
1533     }
1534 
1535     /**
1536      * @dev Directly sets the extra data for the ownership data `index`.
1537      */
1538     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1539         uint256 packed = _packedOwnerships[index];
1540         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1541         uint256 extraDataCasted;
1542         // Cast `extraData` with assembly to avoid redundant masking.
1543         assembly {
1544             extraDataCasted := extraData
1545         }
1546         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1547         _packedOwnerships[index] = packed;
1548     }
1549 
1550     /**
1551      * @dev Returns the next extra data for the packed ownership data.
1552      * The returned result is shifted into position.
1553      */
1554     function _nextExtraData(
1555         address from,
1556         address to,
1557         uint256 prevOwnershipPacked
1558     ) private view returns (uint256) {
1559         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1560         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1561     }
1562 
1563     /**
1564      * @dev Called during each token transfer to set the 24bit `extraData` field.
1565      * Intended to be overridden by the cosumer contract.
1566      *
1567      * `previousExtraData` - the value of `extraData` before transfer.
1568      *
1569      * Calling conditions:
1570      *
1571      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1572      * transferred to `to`.
1573      * - When `from` is zero, `tokenId` will be minted for `to`.
1574      * - When `to` is zero, `tokenId` will be burned by `from`.
1575      * - `from` and `to` are never both zero.
1576      */
1577     function _extraData(
1578         address from,
1579         address to,
1580         uint24 previousExtraData
1581     ) internal view virtual returns (uint24) {}
1582 
1583     /**
1584      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1585      * This includes minting.
1586      * And also called before burning one token.
1587      *
1588      * startTokenId - the first token id to be transferred
1589      * quantity - the amount to be transferred
1590      *
1591      * Calling conditions:
1592      *
1593      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1594      * transferred to `to`.
1595      * - When `from` is zero, `tokenId` will be minted for `to`.
1596      * - When `to` is zero, `tokenId` will be burned by `from`.
1597      * - `from` and `to` are never both zero.
1598      */
1599     function _beforeTokenTransfers(
1600         address from,
1601         address to,
1602         uint256 startTokenId,
1603         uint256 quantity
1604     ) internal virtual {}
1605 
1606     /**
1607      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1608      * This includes minting.
1609      * And also called after one token has been burned.
1610      *
1611      * startTokenId - the first token id to be transferred
1612      * quantity - the amount to be transferred
1613      *
1614      * Calling conditions:
1615      *
1616      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1617      * transferred to `to`.
1618      * - When `from` is zero, `tokenId` has been minted for `to`.
1619      * - When `to` is zero, `tokenId` has been burned by `from`.
1620      * - `from` and `to` are never both zero.
1621      */
1622     function _afterTokenTransfers(
1623         address from,
1624         address to,
1625         uint256 startTokenId,
1626         uint256 quantity
1627     ) internal virtual {}
1628 
1629     /**
1630      * @dev Returns the message sender (defaults to `msg.sender`).
1631      *
1632      * If you are writing GSN compatible contracts, you need to override this function.
1633      */
1634     function _msgSenderERC721A() internal view virtual returns (address) {
1635         return msg.sender;
1636     }
1637 
1638     /**
1639      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1640      */
1641     function _toString(uint256 value) internal pure returns (string memory ptr) {
1642         assembly {
1643             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1644             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1645             // We will need 1 32-byte word to store the length,
1646             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1647             ptr := add(mload(0x40), 128)
1648             // Update the free memory pointer to allocate.
1649             mstore(0x40, ptr)
1650 
1651             // Cache the end of the memory to calculate the length later.
1652             let end := ptr
1653 
1654             // We write the string from the rightmost digit to the leftmost digit.
1655             // The following is essentially a do-while loop that also handles the zero case.
1656             // Costs a bit more than early returning for the zero case,
1657             // but cheaper in terms of deployment and overall runtime costs.
1658             for {
1659                 // Initialize and perform the first pass without check.
1660                 let temp := value
1661                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1662                 ptr := sub(ptr, 1)
1663                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1664                 mstore8(ptr, add(48, mod(temp, 10)))
1665                 temp := div(temp, 10)
1666             } temp {
1667                 // Keep dividing `temp` until zero.
1668                 temp := div(temp, 10)
1669             } {
1670                 // Body of the for loop.
1671                 ptr := sub(ptr, 1)
1672                 mstore8(ptr, add(48, mod(temp, 10)))
1673             }
1674 
1675             let length := sub(end, ptr)
1676             // Move the pointer 32 bytes leftwards to make room for the length.
1677             ptr := sub(ptr, 32)
1678             // Store the length.
1679             mstore(ptr, length)
1680         }
1681     }
1682 }
1683 
1684 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/IERC721AQueryable.sol
1685 
1686 
1687 // ERC721A Contracts v4.1.0
1688 // Creator: Chiru Labs
1689 
1690 pragma solidity ^0.8.4;
1691 
1692 
1693 /**
1694  * @dev Interface of an ERC721AQueryable compliant contract.
1695  */
1696 interface IERC721AQueryable is IERC721A {
1697     /**
1698      * Invalid query range (`start` >= `stop`).
1699      */
1700     error InvalidQueryRange();
1701 
1702     /**
1703      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1704      *
1705      * If the `tokenId` is out of bounds:
1706      *   - `addr` = `address(0)`
1707      *   - `startTimestamp` = `0`
1708      *   - `burned` = `false`
1709      *
1710      * If the `tokenId` is burned:
1711      *   - `addr` = `<Address of owner before token was burned>`
1712      *   - `startTimestamp` = `<Timestamp when token was burned>`
1713      *   - `burned = `true`
1714      *
1715      * Otherwise:
1716      *   - `addr` = `<Address of owner>`
1717      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1718      *   - `burned = `false`
1719      */
1720     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1721 
1722     /**
1723      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1724      * See {ERC721AQueryable-explicitOwnershipOf}
1725      */
1726     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1727 
1728     /**
1729      * @dev Returns an array of token IDs owned by `owner`,
1730      * in the range [`start`, `stop`)
1731      * (i.e. `start <= tokenId < stop`).
1732      *
1733      * This function allows for tokens to be queried if the collection
1734      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1735      *
1736      * Requirements:
1737      *
1738      * - `start` < `stop`
1739      */
1740     function tokensOfOwnerIn(
1741         address owner,
1742         uint256 start,
1743         uint256 stop
1744     ) external view returns (uint256[] memory);
1745 
1746     /**
1747      * @dev Returns an array of token IDs owned by `owner`.
1748      *
1749      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1750      * It is meant to be called off-chain.
1751      *
1752      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1753      * multiple smaller scans if the collection is large enough to cause
1754      * an out-of-gas error (10K pfp collections should be fine).
1755      */
1756     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1757 }
1758 
1759 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/ERC721AQueryable.sol
1760 
1761 
1762 // ERC721A Contracts v4.1.0
1763 // Creator: Chiru Labs
1764 
1765 pragma solidity ^0.8.4;
1766 
1767 
1768 
1769 /**
1770  * @title ERC721A Queryable
1771  * @dev ERC721A subclass with convenience query functions.
1772  */
1773 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1774     /**
1775      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1776      *
1777      * If the `tokenId` is out of bounds:
1778      *   - `addr` = `address(0)`
1779      *   - `startTimestamp` = `0`
1780      *   - `burned` = `false`
1781      *   - `extraData` = `0`
1782      *
1783      * If the `tokenId` is burned:
1784      *   - `addr` = `<Address of owner before token was burned>`
1785      *   - `startTimestamp` = `<Timestamp when token was burned>`
1786      *   - `burned = `true`
1787      *   - `extraData` = `<Extra data when token was burned>`
1788      *
1789      * Otherwise:
1790      *   - `addr` = `<Address of owner>`
1791      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1792      *   - `burned = `false`
1793      *   - `extraData` = `<Extra data at start of ownership>`
1794      */
1795     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1796         TokenOwnership memory ownership;
1797         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1798             return ownership;
1799         }
1800         ownership = _ownershipAt(tokenId);
1801         if (ownership.burned) {
1802             return ownership;
1803         }
1804         return _ownershipOf(tokenId);
1805     }
1806 
1807     /**
1808      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1809      * See {ERC721AQueryable-explicitOwnershipOf}
1810      */
1811     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1812         unchecked {
1813             uint256 tokenIdsLength = tokenIds.length;
1814             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1815             for (uint256 i; i != tokenIdsLength; ++i) {
1816                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1817             }
1818             return ownerships;
1819         }
1820     }
1821 
1822     /**
1823      * @dev Returns an array of token IDs owned by `owner`,
1824      * in the range [`start`, `stop`)
1825      * (i.e. `start <= tokenId < stop`).
1826      *
1827      * This function allows for tokens to be queried if the collection
1828      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1829      *
1830      * Requirements:
1831      *
1832      * - `start` < `stop`
1833      */
1834     function tokensOfOwnerIn(
1835         address owner,
1836         uint256 start,
1837         uint256 stop
1838     ) external view override returns (uint256[] memory) {
1839         unchecked {
1840             if (start >= stop) revert InvalidQueryRange();
1841             uint256 tokenIdsIdx;
1842             uint256 stopLimit = _nextTokenId();
1843             // Set `start = max(start, _startTokenId())`.
1844             if (start < _startTokenId()) {
1845                 start = _startTokenId();
1846             }
1847             // Set `stop = min(stop, stopLimit)`.
1848             if (stop > stopLimit) {
1849                 stop = stopLimit;
1850             }
1851             uint256 tokenIdsMaxLength = balanceOf(owner);
1852             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1853             // to cater for cases where `balanceOf(owner)` is too big.
1854             if (start < stop) {
1855                 uint256 rangeLength = stop - start;
1856                 if (rangeLength < tokenIdsMaxLength) {
1857                     tokenIdsMaxLength = rangeLength;
1858                 }
1859             } else {
1860                 tokenIdsMaxLength = 0;
1861             }
1862             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1863             if (tokenIdsMaxLength == 0) {
1864                 return tokenIds;
1865             }
1866             // We need to call `explicitOwnershipOf(start)`,
1867             // because the slot at `start` may not be initialized.
1868             TokenOwnership memory ownership = explicitOwnershipOf(start);
1869             address currOwnershipAddr;
1870             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1871             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1872             if (!ownership.burned) {
1873                 currOwnershipAddr = ownership.addr;
1874             }
1875             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1876                 ownership = _ownershipAt(i);
1877                 if (ownership.burned) {
1878                     continue;
1879                 }
1880                 if (ownership.addr != address(0)) {
1881                     currOwnershipAddr = ownership.addr;
1882                 }
1883                 if (currOwnershipAddr == owner) {
1884                     tokenIds[tokenIdsIdx++] = i;
1885                 }
1886             }
1887             // Downsize the array to fit.
1888             assembly {
1889                 mstore(tokenIds, tokenIdsIdx)
1890             }
1891             return tokenIds;
1892         }
1893     }
1894 
1895     /**
1896      * @dev Returns an array of token IDs owned by `owner`.
1897      *
1898      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1899      * It is meant to be called off-chain.
1900      *
1901      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1902      * multiple smaller scans if the collection is large enough to cause
1903      * an out-of-gas error (10K pfp collections should be fine).
1904      */
1905     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1906         unchecked {
1907             uint256 tokenIdsIdx;
1908             address currOwnershipAddr;
1909             uint256 tokenIdsLength = balanceOf(owner);
1910             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1911             TokenOwnership memory ownership;
1912             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1913                 ownership = _ownershipAt(i);
1914                 if (ownership.burned) {
1915                     continue;
1916                 }
1917                 if (ownership.addr != address(0)) {
1918                     currOwnershipAddr = ownership.addr;
1919                 }
1920                 if (currOwnershipAddr == owner) {
1921                     tokenIds[tokenIdsIdx++] = i;
1922                 }
1923             }
1924             return tokenIds;
1925         }
1926     }
1927 }
1928 
1929 // File: contracts/CSS.sol
1930 
1931 
1932 pragma solidity 0.8.14;
1933 
1934 
1935 
1936 
1937 
1938 
1939 contract CrazySquirrelSociety is ERC721AQueryable, Ownable {
1940   using Strings for uint256;
1941   using Counters for Counters.Counter;
1942 
1943   Counters.Counter private supply;
1944 
1945   string public uriPrefix = "METADATA";
1946   string public uriSuffix = ".json";
1947   string public _contractURI = "https://www.crazysquirrelsociety.com/SquirrelContract.json";
1948   string public hiddenMetadataUri;
1949 
1950   uint256 public baseCost = 30000000000000000;
1951   uint256 public cost = baseCost;
1952 
1953   uint256 public maxSupply = 3334;
1954   uint256 public maxMintAmountPerTx = 51; //50
1955 
1956   bool public paused = false;
1957   bool public revealed = false;
1958   bool public whitelistPhase = false;
1959   
1960   uint256 public walletLimit = 0;
1961 
1962   uint256 public maxWalletLimitWL = 3334; //5
1963   uint256 public maxWalletLimitPL = 3334; //unlimited
1964 
1965   uint256 public freeMintLimit = 0; // When do we switch from Free to Paid
1966 
1967   address public maxSupplyController = 0xbc47494ebB5F13f1a153e7b55A8Ed75e52583928;
1968 
1969   mapping (address => uint256) public alreadyMinted;
1970   mapping (address => uint256) public alreadyClaimed;
1971 
1972 // MERKEL TREE STUFF
1973   bytes32 public merkleRoot = 0xd4cc55fe690d8da4b2c1935e5dee444de78395ebcfdf42504ba93147d4afc9a4;
1974   
1975   constructor() ERC721A("Crazy Squirrel Society", "CSS") {
1976     _startTokenId();
1977     setHiddenMetadataUri("https://www.crazysquirrelsociety.com/SquirrelHidden.json");
1978     setContractURI("https://www.crazysquirrelsociety.com/SquirrelContract.json");
1979   }
1980 
1981   function _startTokenId()
1982         internal
1983         pure
1984         override
1985         returns(uint256)
1986     {
1987         return 1;
1988     }
1989 
1990   modifier mintCompliance (uint256 _mintAmount) {
1991 
1992     require(!paused, "Minting is PAUSED!");
1993     require(_mintAmount > 0 && _mintAmount < maxMintAmountPerTx, "Invalid mint amount!");
1994     require(msg.sender == tx.origin, "No Bots!");
1995     require(totalSupply() + _mintAmount < maxSupply, "Max supply exceeded!");
1996     
1997     if (whitelistPhase)
1998     {
1999       walletLimit = maxWalletLimitWL;
2000       cost = 0;
2001     }
2002     else if (!whitelistPhase)
2003     {
2004       walletLimit = maxWalletLimitPL;
2005       cost = baseCost;
2006     }
2007 
2008     if (totalSupply() < freeMintLimit && totalSupply() + _mintAmount > freeMintLimit)
2009     {
2010       uint256 overflow = totalSupply() + _mintAmount - freeMintLimit;
2011       cost = baseCost * overflow;
2012     }
2013 
2014     if (totalSupply() > freeMintLimit)
2015     {
2016       cost = baseCost;
2017     }
2018 
2019     require(msg.value >= cost, "Insufficient funds!");
2020     require(alreadyMinted[msg.sender] + _mintAmount < walletLimit, "Max Mints Per Wallet Reached!");
2021 
2022     _;
2023   }
2024 
2025   function setMerkleRoot(bytes32 newMerkleRoot) external onlyOwner
2026   {
2027     merkleRoot = newMerkleRoot;
2028   }
2029 
2030   function getAlreadyMinted(address a) public view returns (uint256)
2031   {
2032     return alreadyMinted[a];
2033   }
2034 
2035   function getWhitelistState() public view returns (bool)
2036   {
2037     return whitelistPhase;
2038   }
2039 
2040   function getFreeMint() public view returns (uint256)
2041   {
2042     return freeMintLimit;
2043   }
2044 
2045   function getMaxWalletLimitWL() public view returns (uint256)
2046   {
2047     return maxWalletLimitWL;
2048   }
2049 
2050   function getMaxWalletLimitPL() public view returns (uint256)
2051   {
2052     return maxWalletLimitPL;
2053   }
2054 
2055   function getPausedState() public view returns (bool)
2056   {
2057     return paused;
2058   }
2059 
2060   function getTotalSupply() public view returns (uint256)
2061   {
2062     return totalSupply();
2063   }
2064 
2065   function publicMint(uint256 _mintAmount) external mintCompliance(_mintAmount) payable
2066   {
2067     require(!whitelistPhase, "Still in Whitelist Sale!");
2068 
2069     alreadyMinted[msg.sender] += _mintAmount;
2070     _safeMint(msg.sender, _mintAmount);
2071   }
2072 
2073   function mintForAddress(uint256 _mintAmount, address _receiver) public payable onlyOwner {
2074     require(totalSupply() + _mintAmount < maxSupply, "Max supply exceeded!");
2075     _safeMint(_receiver, _mintAmount);
2076   }
2077 
2078   function mintForAddressMultiple(address[] calldata addresses, uint256[] calldata amount) public onlyOwner
2079   {
2080     for (uint256 i; i < addresses.length; i++)
2081     {
2082       require(totalSupply() + amount[i] < maxSupply, "Max supply exceeded!");
2083       _safeMint(addresses[i], amount[i]);
2084     }
2085   }
2086 
2087   function walletOfOwner(address _owner)
2088     public
2089     view
2090     returns (uint256[] memory)
2091   {
2092     uint256 ownerTokenCount = balanceOf(_owner);
2093     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2094     uint256 currentTokenId = 1;
2095     uint256 ownedTokenIndex = 0;
2096 
2097     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
2098       address currentTokenOwner = ownerOf(currentTokenId);
2099 
2100       if (currentTokenOwner == _owner) {
2101         ownedTokenIds[ownedTokenIndex] = currentTokenId;
2102 
2103         ownedTokenIndex++;
2104       }
2105 
2106       currentTokenId++;
2107     }
2108 
2109     return ownedTokenIds;
2110   }
2111 
2112   function tokenURI(uint256 _tokenId)
2113     public
2114     view
2115     virtual
2116     override (ERC721A, IERC721A)
2117     returns (string memory)
2118   {
2119     require(
2120       _exists(_tokenId),
2121       "ERC721Metadata: URI query for nonexistent token"
2122     );
2123 
2124     if (revealed == false) {
2125       return hiddenMetadataUri;
2126     }
2127 
2128     string memory currentBaseURI = _baseURI();
2129     return bytes(currentBaseURI).length > 0
2130         ? string(abi.encodePacked(currentBaseURI, _toString(_tokenId), uriSuffix))
2131         : "";
2132   }
2133 
2134   function contractURI() 
2135   public 
2136   view 
2137   returns (string memory) 
2138   {
2139         return bytes(_contractURI).length > 0
2140           ? string(abi.encodePacked(_contractURI))
2141           : "";
2142   }
2143 
2144   function setRevealed(bool _state) public onlyOwner {
2145     revealed = _state;
2146   }
2147 
2148   function setBaseCost(uint256 _baseCost) public onlyOwner {
2149     baseCost = _baseCost;
2150   }
2151 
2152   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2153     maxMintAmountPerTx = _maxMintAmountPerTx;
2154   }
2155 
2156   function setFreeMintLimit(uint256 _freeMintLimit) public onlyOwner {
2157     freeMintLimit = _freeMintLimit;
2158   }
2159 
2160   function setMaxWalletLimitWL(uint256 _maxWalletLimitWL) public onlyOwner {
2161     maxWalletLimitWL = _maxWalletLimitWL;
2162   }
2163 
2164   function setMaxWalletLimitPL(uint256 _maxWalletLimitPL) public onlyOwner {
2165     maxWalletLimitPL = _maxWalletLimitPL;
2166   }
2167 
2168   function setMaxSupplyController(address _address) public onlyOwner
2169   {
2170     require(msg.sender == maxSupplyController, "Not Authorised");
2171     maxSupplyController = _address;
2172   }
2173 
2174   function setMaxSupply(uint256 _maxSupply) public onlyOwner
2175   {
2176     require(msg.sender == maxSupplyController, "Not Authorised");
2177     maxSupply = _maxSupply;
2178   }
2179 
2180   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2181     hiddenMetadataUri = _hiddenMetadataUri;
2182   }
2183 
2184   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2185     uriPrefix = _uriPrefix;
2186   }
2187 
2188   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2189     uriSuffix = _uriSuffix;
2190   }
2191 
2192   function setContractURI(string memory newContractURI) public onlyOwner {
2193     _contractURI = newContractURI;
2194   }
2195 
2196   function setPaused(bool _state) public onlyOwner {
2197     paused = _state;
2198   }
2199 
2200   function setWhitelistPhase(bool _state) public onlyOwner {
2201     whitelistPhase = _state;
2202   }
2203 
2204   function withdraw() public onlyOwner {
2205     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2206     require(os);
2207   }
2208 
2209   function _baseURI() internal view virtual override returns (string memory) {
2210     return uriPrefix;
2211   }
2212 
2213 }