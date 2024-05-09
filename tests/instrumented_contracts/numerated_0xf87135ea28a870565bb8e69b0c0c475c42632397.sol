1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
68 
69 
70 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev These functions deal with verification of Merkle Tree proofs.
76  *
77  * The proofs can be generated using the JavaScript library
78  * https://github.com/miguelmota/merkletreejs[merkletreejs].
79  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
80  *
81  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
82  *
83  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
84  * hashing, or use a hash function other than keccak256 for hashing leaves.
85  * This is because the concatenation of a sorted pair of internal nodes in
86  * the merkle tree could be reinterpreted as a leaf value.
87  */
88 library MerkleProof {
89     /**
90      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
91      * defined by `root`. For this, a `proof` must be provided, containing
92      * sibling hashes on the branch from the leaf to the root of the tree. Each
93      * pair of leaves and each pair of pre-images are assumed to be sorted.
94      */
95     function verify(
96         bytes32[] memory proof,
97         bytes32 root,
98         bytes32 leaf
99     ) internal pure returns (bool) {
100         return processProof(proof, leaf) == root;
101     }
102 
103     /**
104      * @dev Calldata version of {verify}
105      *
106      * _Available since v4.7._
107      */
108     function verifyCalldata(
109         bytes32[] calldata proof,
110         bytes32 root,
111         bytes32 leaf
112     ) internal pure returns (bool) {
113         return processProofCalldata(proof, leaf) == root;
114     }
115 
116     /**
117      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
118      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
119      * hash matches the root of the tree. When processing the proof, the pairs
120      * of leafs & pre-images are assumed to be sorted.
121      *
122      * _Available since v4.4._
123      */
124     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
125         bytes32 computedHash = leaf;
126         for (uint256 i = 0; i < proof.length; i++) {
127             computedHash = _hashPair(computedHash, proof[i]);
128         }
129         return computedHash;
130     }
131 
132     /**
133      * @dev Calldata version of {processProof}
134      *
135      * _Available since v4.7._
136      */
137     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
138         bytes32 computedHash = leaf;
139         for (uint256 i = 0; i < proof.length; i++) {
140             computedHash = _hashPair(computedHash, proof[i]);
141         }
142         return computedHash;
143     }
144 
145     /**
146      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
147      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
148      *
149      * _Available since v4.7._
150      */
151     function multiProofVerify(
152         bytes32[] memory proof,
153         bool[] memory proofFlags,
154         bytes32 root,
155         bytes32[] memory leaves
156     ) internal pure returns (bool) {
157         return processMultiProof(proof, proofFlags, leaves) == root;
158     }
159 
160     /**
161      * @dev Calldata version of {multiProofVerify}
162      *
163      * _Available since v4.7._
164      */
165     function multiProofVerifyCalldata(
166         bytes32[] calldata proof,
167         bool[] calldata proofFlags,
168         bytes32 root,
169         bytes32[] memory leaves
170     ) internal pure returns (bool) {
171         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
172     }
173 
174     /**
175      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
176      * consuming from one or the other at each step according to the instructions given by
177      * `proofFlags`.
178      *
179      * _Available since v4.7._
180      */
181     function processMultiProof(
182         bytes32[] memory proof,
183         bool[] memory proofFlags,
184         bytes32[] memory leaves
185     ) internal pure returns (bytes32 merkleRoot) {
186         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
187         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
188         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
189         // the merkle tree.
190         uint256 leavesLen = leaves.length;
191         uint256 totalHashes = proofFlags.length;
192 
193         // Check proof validity.
194         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
195 
196         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
197         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
198         bytes32[] memory hashes = new bytes32[](totalHashes);
199         uint256 leafPos = 0;
200         uint256 hashPos = 0;
201         uint256 proofPos = 0;
202         // At each step, we compute the next hash using two values:
203         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
204         //   get the next hash.
205         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
206         //   `proof` array.
207         for (uint256 i = 0; i < totalHashes; i++) {
208             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
209             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
210             hashes[i] = _hashPair(a, b);
211         }
212 
213         if (totalHashes > 0) {
214             return hashes[totalHashes - 1];
215         } else if (leavesLen > 0) {
216             return leaves[0];
217         } else {
218             return proof[0];
219         }
220     }
221 
222     /**
223      * @dev Calldata version of {processMultiProof}
224      *
225      * _Available since v4.7._
226      */
227     function processMultiProofCalldata(
228         bytes32[] calldata proof,
229         bool[] calldata proofFlags,
230         bytes32[] memory leaves
231     ) internal pure returns (bytes32 merkleRoot) {
232         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
233         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
234         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
235         // the merkle tree.
236         uint256 leavesLen = leaves.length;
237         uint256 totalHashes = proofFlags.length;
238 
239         // Check proof validity.
240         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
241 
242         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
243         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
244         bytes32[] memory hashes = new bytes32[](totalHashes);
245         uint256 leafPos = 0;
246         uint256 hashPos = 0;
247         uint256 proofPos = 0;
248         // At each step, we compute the next hash using two values:
249         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
250         //   get the next hash.
251         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
252         //   `proof` array.
253         for (uint256 i = 0; i < totalHashes; i++) {
254             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
255             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
256             hashes[i] = _hashPair(a, b);
257         }
258 
259         if (totalHashes > 0) {
260             return hashes[totalHashes - 1];
261         } else if (leavesLen > 0) {
262             return leaves[0];
263         } else {
264             return proof[0];
265         }
266     }
267 
268     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
269         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
270     }
271 
272     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
273         /// @solidity memory-safe-assembly
274         assembly {
275             mstore(0x00, a)
276             mstore(0x20, b)
277             value := keccak256(0x00, 0x40)
278         }
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
394 // File: @openzeppelin/contracts/utils/Strings.sol
395 
396 
397 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 /**
402  * @dev String operations.
403  */
404 library Strings {
405     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
406     uint8 private constant _ADDRESS_LENGTH = 20;
407 
408     /**
409      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
410      */
411     function toString(uint256 value) internal pure returns (string memory) {
412         // Inspired by OraclizeAPI's implementation - MIT licence
413         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
414 
415         if (value == 0) {
416             return "0";
417         }
418         uint256 temp = value;
419         uint256 digits;
420         while (temp != 0) {
421             digits++;
422             temp /= 10;
423         }
424         bytes memory buffer = new bytes(digits);
425         while (value != 0) {
426             digits -= 1;
427             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
428             value /= 10;
429         }
430         return string(buffer);
431     }
432 
433     /**
434      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
435      */
436     function toHexString(uint256 value) internal pure returns (string memory) {
437         if (value == 0) {
438             return "0x00";
439         }
440         uint256 temp = value;
441         uint256 length = 0;
442         while (temp != 0) {
443             length++;
444             temp >>= 8;
445         }
446         return toHexString(value, length);
447     }
448 
449     /**
450      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
451      */
452     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
453         bytes memory buffer = new bytes(2 * length + 2);
454         buffer[0] = "0";
455         buffer[1] = "x";
456         for (uint256 i = 2 * length + 1; i > 1; --i) {
457             buffer[i] = _HEX_SYMBOLS[value & 0xf];
458             value >>= 4;
459         }
460         require(value == 0, "Strings: hex length insufficient");
461         return string(buffer);
462     }
463 
464     /**
465      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
466      */
467     function toHexString(address addr) internal pure returns (string memory) {
468         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
469     }
470 }
471 
472 // File: erc721a/contracts/IERC721A.sol
473 
474 
475 // ERC721A Contracts v4.2.0
476 // Creator: Chiru Labs
477 
478 pragma solidity ^0.8.4;
479 
480 /**
481  * @dev Interface of ERC721A.
482  */
483 interface IERC721A {
484     /**
485      * The caller must own the token or be an approved operator.
486      */
487     error ApprovalCallerNotOwnerNorApproved();
488 
489     /**
490      * The token does not exist.
491      */
492     error ApprovalQueryForNonexistentToken();
493 
494     /**
495      * The caller cannot approve to their own address.
496      */
497     error ApproveToCaller();
498 
499     /**
500      * Cannot query the balance for the zero address.
501      */
502     error BalanceQueryForZeroAddress();
503 
504     /**
505      * Cannot mint to the zero address.
506      */
507     error MintToZeroAddress();
508 
509     /**
510      * The quantity of tokens minted must be more than zero.
511      */
512     error MintZeroQuantity();
513 
514     /**
515      * The token does not exist.
516      */
517     error OwnerQueryForNonexistentToken();
518 
519     /**
520      * The caller must own the token or be an approved operator.
521      */
522     error TransferCallerNotOwnerNorApproved();
523 
524     /**
525      * The token must be owned by `from`.
526      */
527     error TransferFromIncorrectOwner();
528 
529     /**
530      * Cannot safely transfer to a contract that does not implement the
531      * ERC721Receiver interface.
532      */
533     error TransferToNonERC721ReceiverImplementer();
534 
535     /**
536      * Cannot transfer to the zero address.
537      */
538     error TransferToZeroAddress();
539 
540     /**
541      * The token does not exist.
542      */
543     error URIQueryForNonexistentToken();
544 
545     /**
546      * The `quantity` minted with ERC2309 exceeds the safety limit.
547      */
548     error MintERC2309QuantityExceedsLimit();
549 
550     /**
551      * The `extraData` cannot be set on an unintialized ownership slot.
552      */
553     error OwnershipNotInitializedForExtraData();
554 
555     // =============================================================
556     //                            STRUCTS
557     // =============================================================
558 
559     struct TokenOwnership {
560         // The address of the owner.
561         address addr;
562         // Stores the start time of ownership with minimal overhead for tokenomics.
563         uint64 startTimestamp;
564         // Whether the token has been burned.
565         bool burned;
566         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
567         uint24 extraData;
568     }
569 
570     // =============================================================
571     //                         TOKEN COUNTERS
572     // =============================================================
573 
574     /**
575      * @dev Returns the total number of tokens in existence.
576      * Burned tokens will reduce the count.
577      * To get the total number of tokens minted, please see {_totalMinted}.
578      */
579     function totalSupply() external view returns (uint256);
580 
581     // =============================================================
582     //                            IERC165
583     // =============================================================
584 
585     /**
586      * @dev Returns true if this contract implements the interface defined by
587      * `interfaceId`. See the corresponding
588      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
589      * to learn more about how these ids are created.
590      *
591      * This function call must use less than 30000 gas.
592      */
593     function supportsInterface(bytes4 interfaceId) external view returns (bool);
594 
595     // =============================================================
596     //                            IERC721
597     // =============================================================
598 
599     /**
600      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
601      */
602     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
603 
604     /**
605      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
606      */
607     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
608 
609     /**
610      * @dev Emitted when `owner` enables or disables
611      * (`approved`) `operator` to manage all of its assets.
612      */
613     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
614 
615     /**
616      * @dev Returns the number of tokens in `owner`'s account.
617      */
618     function balanceOf(address owner) external view returns (uint256 balance);
619 
620     /**
621      * @dev Returns the owner of the `tokenId` token.
622      *
623      * Requirements:
624      *
625      * - `tokenId` must exist.
626      */
627     function ownerOf(uint256 tokenId) external view returns (address owner);
628 
629     /**
630      * @dev Safely transfers `tokenId` token from `from` to `to`,
631      * checking first that contract recipients are aware of the ERC721 protocol
632      * to prevent tokens from being forever locked.
633      *
634      * Requirements:
635      *
636      * - `from` cannot be the zero address.
637      * - `to` cannot be the zero address.
638      * - `tokenId` token must exist and be owned by `from`.
639      * - If the caller is not `from`, it must be have been allowed to move
640      * this token by either {approve} or {setApprovalForAll}.
641      * - If `to` refers to a smart contract, it must implement
642      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
643      *
644      * Emits a {Transfer} event.
645      */
646     function safeTransferFrom(
647         address from,
648         address to,
649         uint256 tokenId,
650         bytes calldata data
651     ) external;
652 
653     /**
654      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
655      */
656     function safeTransferFrom(
657         address from,
658         address to,
659         uint256 tokenId
660     ) external;
661 
662     /**
663      * @dev Transfers `tokenId` from `from` to `to`.
664      *
665      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
666      * whenever possible.
667      *
668      * Requirements:
669      *
670      * - `from` cannot be the zero address.
671      * - `to` cannot be the zero address.
672      * - `tokenId` token must be owned by `from`.
673      * - If the caller is not `from`, it must be approved to move this token
674      * by either {approve} or {setApprovalForAll}.
675      *
676      * Emits a {Transfer} event.
677      */
678     function transferFrom(
679         address from,
680         address to,
681         uint256 tokenId
682     ) external;
683 
684     /**
685      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
686      * The approval is cleared when the token is transferred.
687      *
688      * Only a single account can be approved at a time, so approving the
689      * zero address clears previous approvals.
690      *
691      * Requirements:
692      *
693      * - The caller must own the token or be an approved operator.
694      * - `tokenId` must exist.
695      *
696      * Emits an {Approval} event.
697      */
698     function approve(address to, uint256 tokenId) external;
699 
700     /**
701      * @dev Approve or remove `operator` as an operator for the caller.
702      * Operators can call {transferFrom} or {safeTransferFrom}
703      * for any token owned by the caller.
704      *
705      * Requirements:
706      *
707      * - The `operator` cannot be the caller.
708      *
709      * Emits an {ApprovalForAll} event.
710      */
711     function setApprovalForAll(address operator, bool _approved) external;
712 
713     /**
714      * @dev Returns the account approved for `tokenId` token.
715      *
716      * Requirements:
717      *
718      * - `tokenId` must exist.
719      */
720     function getApproved(uint256 tokenId) external view returns (address operator);
721 
722     /**
723      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
724      *
725      * See {setApprovalForAll}.
726      */
727     function isApprovedForAll(address owner, address operator) external view returns (bool);
728 
729     // =============================================================
730     //                        IERC721Metadata
731     // =============================================================
732 
733     /**
734      * @dev Returns the token collection name.
735      */
736     function name() external view returns (string memory);
737 
738     /**
739      * @dev Returns the token collection symbol.
740      */
741     function symbol() external view returns (string memory);
742 
743     /**
744      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
745      */
746     function tokenURI(uint256 tokenId) external view returns (string memory);
747 
748     // =============================================================
749     //                           IERC2309
750     // =============================================================
751 
752     /**
753      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
754      * (inclusive) is transferred from `from` to `to`, as defined in the
755      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
756      *
757      * See {_mintERC2309} for more details.
758      */
759     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
760 }
761 
762 // File: erc721a/contracts/ERC721A.sol
763 
764 
765 // ERC721A Contracts v4.2.0
766 // Creator: Chiru Labs
767 
768 pragma solidity ^0.8.4;
769 
770 
771 /**
772  * @dev Interface of ERC721 token receiver.
773  */
774 interface ERC721A__IERC721Receiver {
775     function onERC721Received(
776         address operator,
777         address from,
778         uint256 tokenId,
779         bytes calldata data
780     ) external returns (bytes4);
781 }
782 
783 /**
784  * @title ERC721A
785  *
786  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
787  * Non-Fungible Token Standard, including the Metadata extension.
788  * Optimized for lower gas during batch mints.
789  *
790  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
791  * starting from `_startTokenId()`.
792  *
793  * Assumptions:
794  *
795  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
796  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
797  */
798 contract ERC721A is IERC721A {
799     // Reference type for token approval.
800     struct TokenApprovalRef {
801         address value;
802     }
803 
804     // =============================================================
805     //                           CONSTANTS
806     // =============================================================
807 
808     // Mask of an entry in packed address data.
809     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
810 
811     // The bit position of `numberMinted` in packed address data.
812     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
813 
814     // The bit position of `numberBurned` in packed address data.
815     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
816 
817     // The bit position of `aux` in packed address data.
818     uint256 private constant _BITPOS_AUX = 192;
819 
820     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
821     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
822 
823     // The bit position of `startTimestamp` in packed ownership.
824     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
825 
826     // The bit mask of the `burned` bit in packed ownership.
827     uint256 private constant _BITMASK_BURNED = 1 << 224;
828 
829     // The bit position of the `nextInitialized` bit in packed ownership.
830     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
831 
832     // The bit mask of the `nextInitialized` bit in packed ownership.
833     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
834 
835     // The bit position of `extraData` in packed ownership.
836     uint256 private constant _BITPOS_EXTRA_DATA = 232;
837 
838     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
839     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
840 
841     // The mask of the lower 160 bits for addresses.
842     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
843 
844     // The maximum `quantity` that can be minted with {_mintERC2309}.
845     // This limit is to prevent overflows on the address data entries.
846     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
847     // is required to cause an overflow, which is unrealistic.
848     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
849 
850     // The `Transfer` event signature is given by:
851     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
852     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
853         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
854 
855     // =============================================================
856     //                            STORAGE
857     // =============================================================
858 
859     // The next token ID to be minted.
860     uint256 private _currentIndex;
861 
862     // The number of tokens burned.
863     uint256 private _burnCounter;
864 
865     // Token name
866     string private _name;
867 
868     // Token symbol
869     string private _symbol;
870 
871     // Mapping from token ID to ownership details
872     // An empty struct value does not necessarily mean the token is unowned.
873     // See {_packedOwnershipOf} implementation for details.
874     //
875     // Bits Layout:
876     // - [0..159]   `addr`
877     // - [160..223] `startTimestamp`
878     // - [224]      `burned`
879     // - [225]      `nextInitialized`
880     // - [232..255] `extraData`
881     mapping(uint256 => uint256) private _packedOwnerships;
882 
883     // Mapping owner address to address data.
884     //
885     // Bits Layout:
886     // - [0..63]    `balance`
887     // - [64..127]  `numberMinted`
888     // - [128..191] `numberBurned`
889     // - [192..255] `aux`
890     mapping(address => uint256) private _packedAddressData;
891 
892     // Mapping from token ID to approved address.
893     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
894 
895     // Mapping from owner to operator approvals
896     mapping(address => mapping(address => bool)) private _operatorApprovals;
897 
898     // =============================================================
899     //                          CONSTRUCTOR
900     // =============================================================
901 
902     constructor(string memory name_, string memory symbol_) {
903         _name = name_;
904         _symbol = symbol_;
905         _currentIndex = _startTokenId();
906     }
907 
908     // =============================================================
909     //                   TOKEN COUNTING OPERATIONS
910     // =============================================================
911 
912     /**
913      * @dev Returns the starting token ID.
914      * To change the starting token ID, please override this function.
915      */
916     function _startTokenId() internal view virtual returns (uint256) {
917         return 0;
918     }
919 
920     /**
921      * @dev Returns the next token ID to be minted.
922      */
923     function _nextTokenId() internal view virtual returns (uint256) {
924         return _currentIndex;
925     }
926 
927     /**
928      * @dev Returns the total number of tokens in existence.
929      * Burned tokens will reduce the count.
930      * To get the total number of tokens minted, please see {_totalMinted}.
931      */
932     function totalSupply() public view virtual override returns (uint256) {
933         // Counter underflow is impossible as _burnCounter cannot be incremented
934         // more than `_currentIndex - _startTokenId()` times.
935         unchecked {
936             return _currentIndex - _burnCounter - _startTokenId();
937         }
938     }
939 
940     /**
941      * @dev Returns the total amount of tokens minted in the contract.
942      */
943     function _totalMinted() internal view virtual returns (uint256) {
944         // Counter underflow is impossible as `_currentIndex` does not decrement,
945         // and it is initialized to `_startTokenId()`.
946         unchecked {
947             return _currentIndex - _startTokenId();
948         }
949     }
950 
951     /**
952      * @dev Returns the total number of tokens burned.
953      */
954     function _totalBurned() internal view virtual returns (uint256) {
955         return _burnCounter;
956     }
957 
958     // =============================================================
959     //                    ADDRESS DATA OPERATIONS
960     // =============================================================
961 
962     /**
963      * @dev Returns the number of tokens in `owner`'s account.
964      */
965     function balanceOf(address owner) public view virtual override returns (uint256) {
966         if (owner == address(0)) revert BalanceQueryForZeroAddress();
967         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
968     }
969 
970     /**
971      * Returns the number of tokens minted by `owner`.
972      */
973     function _numberMinted(address owner) internal view returns (uint256) {
974         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
975     }
976 
977     /**
978      * Returns the number of tokens burned by or on behalf of `owner`.
979      */
980     function _numberBurned(address owner) internal view returns (uint256) {
981         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
982     }
983 
984     /**
985      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
986      */
987     function _getAux(address owner) internal view returns (uint64) {
988         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
989     }
990 
991     /**
992      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
993      * If there are multiple variables, please pack them into a uint64.
994      */
995     function _setAux(address owner, uint64 aux) internal virtual {
996         uint256 packed = _packedAddressData[owner];
997         uint256 auxCasted;
998         // Cast `aux` with assembly to avoid redundant masking.
999         assembly {
1000             auxCasted := aux
1001         }
1002         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1003         _packedAddressData[owner] = packed;
1004     }
1005 
1006     // =============================================================
1007     //                            IERC165
1008     // =============================================================
1009 
1010     /**
1011      * @dev Returns true if this contract implements the interface defined by
1012      * `interfaceId`. See the corresponding
1013      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1014      * to learn more about how these ids are created.
1015      *
1016      * This function call must use less than 30000 gas.
1017      */
1018     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1019         // The interface IDs are constants representing the first 4 bytes
1020         // of the XOR of all function selectors in the interface.
1021         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1022         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1023         return
1024             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1025             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1026             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1027     }
1028 
1029     // =============================================================
1030     //                        IERC721Metadata
1031     // =============================================================
1032 
1033     /**
1034      * @dev Returns the token collection name.
1035      */
1036     function name() public view virtual override returns (string memory) {
1037         return _name;
1038     }
1039 
1040     /**
1041      * @dev Returns the token collection symbol.
1042      */
1043     function symbol() public view virtual override returns (string memory) {
1044         return _symbol;
1045     }
1046 
1047     /**
1048      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1049      */
1050     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1051         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1052 
1053         string memory baseURI = _baseURI();
1054         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1055     }
1056 
1057     /**
1058      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1059      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1060      * by default, it can be overridden in child contracts.
1061      */
1062     function _baseURI() internal view virtual returns (string memory) {
1063         return '';
1064     }
1065 
1066     // =============================================================
1067     //                     OWNERSHIPS OPERATIONS
1068     // =============================================================
1069 
1070     /**
1071      * @dev Returns the owner of the `tokenId` token.
1072      *
1073      * Requirements:
1074      *
1075      * - `tokenId` must exist.
1076      */
1077     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1078         return address(uint160(_packedOwnershipOf(tokenId)));
1079     }
1080 
1081     /**
1082      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1083      * It gradually moves to O(1) as tokens get transferred around over time.
1084      */
1085     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1086         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1087     }
1088 
1089     /**
1090      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1091      */
1092     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1093         return _unpackedOwnership(_packedOwnerships[index]);
1094     }
1095 
1096     /**
1097      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1098      */
1099     function _initializeOwnershipAt(uint256 index) internal virtual {
1100         if (_packedOwnerships[index] == 0) {
1101             _packedOwnerships[index] = _packedOwnershipOf(index);
1102         }
1103     }
1104 
1105     /**
1106      * Returns the packed ownership data of `tokenId`.
1107      */
1108     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1109         uint256 curr = tokenId;
1110 
1111         unchecked {
1112             if (_startTokenId() <= curr)
1113                 if (curr < _currentIndex) {
1114                     uint256 packed = _packedOwnerships[curr];
1115                     // If not burned.
1116                     if (packed & _BITMASK_BURNED == 0) {
1117                         // Invariant:
1118                         // There will always be an initialized ownership slot
1119                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1120                         // before an unintialized ownership slot
1121                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1122                         // Hence, `curr` will not underflow.
1123                         //
1124                         // We can directly compare the packed value.
1125                         // If the address is zero, packed will be zero.
1126                         while (packed == 0) {
1127                             packed = _packedOwnerships[--curr];
1128                         }
1129                         return packed;
1130                     }
1131                 }
1132         }
1133         revert OwnerQueryForNonexistentToken();
1134     }
1135 
1136     /**
1137      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1138      */
1139     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1140         ownership.addr = address(uint160(packed));
1141         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1142         ownership.burned = packed & _BITMASK_BURNED != 0;
1143         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1144     }
1145 
1146     /**
1147      * @dev Packs ownership data into a single uint256.
1148      */
1149     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1150         assembly {
1151             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1152             owner := and(owner, _BITMASK_ADDRESS)
1153             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1154             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1155         }
1156     }
1157 
1158     /**
1159      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1160      */
1161     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1162         // For branchless setting of the `nextInitialized` flag.
1163         assembly {
1164             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1165             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1166         }
1167     }
1168 
1169     // =============================================================
1170     //                      APPROVAL OPERATIONS
1171     // =============================================================
1172 
1173     /**
1174      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1175      * The approval is cleared when the token is transferred.
1176      *
1177      * Only a single account can be approved at a time, so approving the
1178      * zero address clears previous approvals.
1179      *
1180      * Requirements:
1181      *
1182      * - The caller must own the token or be an approved operator.
1183      * - `tokenId` must exist.
1184      *
1185      * Emits an {Approval} event.
1186      */
1187     function approve(address to, uint256 tokenId) public virtual override {
1188         address owner = ownerOf(tokenId);
1189 
1190         if (_msgSenderERC721A() != owner)
1191             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1192                 revert ApprovalCallerNotOwnerNorApproved();
1193             }
1194 
1195         _tokenApprovals[tokenId].value = to;
1196         emit Approval(owner, to, tokenId);
1197     }
1198 
1199     /**
1200      * @dev Returns the account approved for `tokenId` token.
1201      *
1202      * Requirements:
1203      *
1204      * - `tokenId` must exist.
1205      */
1206     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1207         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1208 
1209         return _tokenApprovals[tokenId].value;
1210     }
1211 
1212     /**
1213      * @dev Approve or remove `operator` as an operator for the caller.
1214      * Operators can call {transferFrom} or {safeTransferFrom}
1215      * for any token owned by the caller.
1216      *
1217      * Requirements:
1218      *
1219      * - The `operator` cannot be the caller.
1220      *
1221      * Emits an {ApprovalForAll} event.
1222      */
1223     function setApprovalForAll(address operator, bool approved) public virtual override {
1224         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1225 
1226         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1227         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1228     }
1229 
1230     /**
1231      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1232      *
1233      * See {setApprovalForAll}.
1234      */
1235     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1236         return _operatorApprovals[owner][operator];
1237     }
1238 
1239     /**
1240      * @dev Returns whether `tokenId` exists.
1241      *
1242      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1243      *
1244      * Tokens start existing when they are minted. See {_mint}.
1245      */
1246     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1247         return
1248             _startTokenId() <= tokenId &&
1249             tokenId < _currentIndex && // If within bounds,
1250             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1251     }
1252 
1253     /**
1254      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1255      */
1256     function _isSenderApprovedOrOwner(
1257         address approvedAddress,
1258         address owner,
1259         address msgSender
1260     ) private pure returns (bool result) {
1261         assembly {
1262             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1263             owner := and(owner, _BITMASK_ADDRESS)
1264             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1265             msgSender := and(msgSender, _BITMASK_ADDRESS)
1266             // `msgSender == owner || msgSender == approvedAddress`.
1267             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1268         }
1269     }
1270 
1271     /**
1272      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1273      */
1274     function _getApprovedSlotAndAddress(uint256 tokenId)
1275         private
1276         view
1277         returns (uint256 approvedAddressSlot, address approvedAddress)
1278     {
1279         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1280         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1281         assembly {
1282             approvedAddressSlot := tokenApproval.slot
1283             approvedAddress := sload(approvedAddressSlot)
1284         }
1285     }
1286 
1287     // =============================================================
1288     //                      TRANSFER OPERATIONS
1289     // =============================================================
1290 
1291     /**
1292      * @dev Transfers `tokenId` from `from` to `to`.
1293      *
1294      * Requirements:
1295      *
1296      * - `from` cannot be the zero address.
1297      * - `to` cannot be the zero address.
1298      * - `tokenId` token must be owned by `from`.
1299      * - If the caller is not `from`, it must be approved to move this token
1300      * by either {approve} or {setApprovalForAll}.
1301      *
1302      * Emits a {Transfer} event.
1303      */
1304     function transferFrom(
1305         address from,
1306         address to,
1307         uint256 tokenId
1308     ) public virtual override {
1309         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1310 
1311         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1312 
1313         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1314 
1315         // The nested ifs save around 20+ gas over a compound boolean condition.
1316         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1317             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1318 
1319         if (to == address(0)) revert TransferToZeroAddress();
1320 
1321         _beforeTokenTransfers(from, to, tokenId, 1);
1322 
1323         // Clear approvals from the previous owner.
1324         assembly {
1325             if approvedAddress {
1326                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1327                 sstore(approvedAddressSlot, 0)
1328             }
1329         }
1330 
1331         // Underflow of the sender's balance is impossible because we check for
1332         // ownership above and the recipient's balance can't realistically overflow.
1333         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1334         unchecked {
1335             // We can directly increment and decrement the balances.
1336             --_packedAddressData[from]; // Updates: `balance -= 1`.
1337             ++_packedAddressData[to]; // Updates: `balance += 1`.
1338 
1339             // Updates:
1340             // - `address` to the next owner.
1341             // - `startTimestamp` to the timestamp of transfering.
1342             // - `burned` to `false`.
1343             // - `nextInitialized` to `true`.
1344             _packedOwnerships[tokenId] = _packOwnershipData(
1345                 to,
1346                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1347             );
1348 
1349             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1350             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1351                 uint256 nextTokenId = tokenId + 1;
1352                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1353                 if (_packedOwnerships[nextTokenId] == 0) {
1354                     // If the next slot is within bounds.
1355                     if (nextTokenId != _currentIndex) {
1356                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1357                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1358                     }
1359                 }
1360             }
1361         }
1362 
1363         emit Transfer(from, to, tokenId);
1364         _afterTokenTransfers(from, to, tokenId, 1);
1365     }
1366 
1367     /**
1368      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1369      */
1370     function safeTransferFrom(
1371         address from,
1372         address to,
1373         uint256 tokenId
1374     ) public virtual override {
1375         safeTransferFrom(from, to, tokenId, '');
1376     }
1377 
1378     /**
1379      * @dev Safely transfers `tokenId` token from `from` to `to`.
1380      *
1381      * Requirements:
1382      *
1383      * - `from` cannot be the zero address.
1384      * - `to` cannot be the zero address.
1385      * - `tokenId` token must exist and be owned by `from`.
1386      * - If the caller is not `from`, it must be approved to move this token
1387      * by either {approve} or {setApprovalForAll}.
1388      * - If `to` refers to a smart contract, it must implement
1389      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1390      *
1391      * Emits a {Transfer} event.
1392      */
1393     function safeTransferFrom(
1394         address from,
1395         address to,
1396         uint256 tokenId,
1397         bytes memory _data
1398     ) public virtual override {
1399         transferFrom(from, to, tokenId);
1400         if (to.code.length != 0)
1401             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1402                 revert TransferToNonERC721ReceiverImplementer();
1403             }
1404     }
1405 
1406     /**
1407      * @dev Hook that is called before a set of serially-ordered token IDs
1408      * are about to be transferred. This includes minting.
1409      * And also called before burning one token.
1410      *
1411      * `startTokenId` - the first token ID to be transferred.
1412      * `quantity` - the amount to be transferred.
1413      *
1414      * Calling conditions:
1415      *
1416      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1417      * transferred to `to`.
1418      * - When `from` is zero, `tokenId` will be minted for `to`.
1419      * - When `to` is zero, `tokenId` will be burned by `from`.
1420      * - `from` and `to` are never both zero.
1421      */
1422     function _beforeTokenTransfers(
1423         address from,
1424         address to,
1425         uint256 startTokenId,
1426         uint256 quantity
1427     ) internal virtual {}
1428 
1429     /**
1430      * @dev Hook that is called after a set of serially-ordered token IDs
1431      * have been transferred. This includes minting.
1432      * And also called after one token has been burned.
1433      *
1434      * `startTokenId` - the first token ID to be transferred.
1435      * `quantity` - the amount to be transferred.
1436      *
1437      * Calling conditions:
1438      *
1439      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1440      * transferred to `to`.
1441      * - When `from` is zero, `tokenId` has been minted for `to`.
1442      * - When `to` is zero, `tokenId` has been burned by `from`.
1443      * - `from` and `to` are never both zero.
1444      */
1445     function _afterTokenTransfers(
1446         address from,
1447         address to,
1448         uint256 startTokenId,
1449         uint256 quantity
1450     ) internal virtual {}
1451 
1452     /**
1453      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1454      *
1455      * `from` - Previous owner of the given token ID.
1456      * `to` - Target address that will receive the token.
1457      * `tokenId` - Token ID to be transferred.
1458      * `_data` - Optional data to send along with the call.
1459      *
1460      * Returns whether the call correctly returned the expected magic value.
1461      */
1462     function _checkContractOnERC721Received(
1463         address from,
1464         address to,
1465         uint256 tokenId,
1466         bytes memory _data
1467     ) private returns (bool) {
1468         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1469             bytes4 retval
1470         ) {
1471             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1472         } catch (bytes memory reason) {
1473             if (reason.length == 0) {
1474                 revert TransferToNonERC721ReceiverImplementer();
1475             } else {
1476                 assembly {
1477                     revert(add(32, reason), mload(reason))
1478                 }
1479             }
1480         }
1481     }
1482 
1483     // =============================================================
1484     //                        MINT OPERATIONS
1485     // =============================================================
1486 
1487     /**
1488      * @dev Mints `quantity` tokens and transfers them to `to`.
1489      *
1490      * Requirements:
1491      *
1492      * - `to` cannot be the zero address.
1493      * - `quantity` must be greater than 0.
1494      *
1495      * Emits a {Transfer} event for each mint.
1496      */
1497     function _mint(address to, uint256 quantity) internal virtual {
1498         uint256 startTokenId = _currentIndex;
1499         if (quantity == 0) revert MintZeroQuantity();
1500 
1501         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1502 
1503         // Overflows are incredibly unrealistic.
1504         // `balance` and `numberMinted` have a maximum limit of 2**64.
1505         // `tokenId` has a maximum limit of 2**256.
1506         unchecked {
1507             // Updates:
1508             // - `balance += quantity`.
1509             // - `numberMinted += quantity`.
1510             //
1511             // We can directly add to the `balance` and `numberMinted`.
1512             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1513 
1514             // Updates:
1515             // - `address` to the owner.
1516             // - `startTimestamp` to the timestamp of minting.
1517             // - `burned` to `false`.
1518             // - `nextInitialized` to `quantity == 1`.
1519             _packedOwnerships[startTokenId] = _packOwnershipData(
1520                 to,
1521                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1522             );
1523 
1524             uint256 toMasked;
1525             uint256 end = startTokenId + quantity;
1526 
1527             // Use assembly to loop and emit the `Transfer` event for gas savings.
1528             assembly {
1529                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1530                 toMasked := and(to, _BITMASK_ADDRESS)
1531                 // Emit the `Transfer` event.
1532                 log4(
1533                     0, // Start of data (0, since no data).
1534                     0, // End of data (0, since no data).
1535                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1536                     0, // `address(0)`.
1537                     toMasked, // `to`.
1538                     startTokenId // `tokenId`.
1539                 )
1540 
1541                 for {
1542                     let tokenId := add(startTokenId, 1)
1543                 } iszero(eq(tokenId, end)) {
1544                     tokenId := add(tokenId, 1)
1545                 } {
1546                     // Emit the `Transfer` event. Similar to above.
1547                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1548                 }
1549             }
1550             if (toMasked == 0) revert MintToZeroAddress();
1551 
1552             _currentIndex = end;
1553         }
1554         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1555     }
1556 
1557     /**
1558      * @dev Mints `quantity` tokens and transfers them to `to`.
1559      *
1560      * This function is intended for efficient minting only during contract creation.
1561      *
1562      * It emits only one {ConsecutiveTransfer} as defined in
1563      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1564      * instead of a sequence of {Transfer} event(s).
1565      *
1566      * Calling this function outside of contract creation WILL make your contract
1567      * non-compliant with the ERC721 standard.
1568      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1569      * {ConsecutiveTransfer} event is only permissible during contract creation.
1570      *
1571      * Requirements:
1572      *
1573      * - `to` cannot be the zero address.
1574      * - `quantity` must be greater than 0.
1575      *
1576      * Emits a {ConsecutiveTransfer} event.
1577      */
1578     function _mintERC2309(address to, uint256 quantity) internal virtual {
1579         uint256 startTokenId = _currentIndex;
1580         if (to == address(0)) revert MintToZeroAddress();
1581         if (quantity == 0) revert MintZeroQuantity();
1582         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1583 
1584         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1585 
1586         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1587         unchecked {
1588             // Updates:
1589             // - `balance += quantity`.
1590             // - `numberMinted += quantity`.
1591             //
1592             // We can directly add to the `balance` and `numberMinted`.
1593             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1594 
1595             // Updates:
1596             // - `address` to the owner.
1597             // - `startTimestamp` to the timestamp of minting.
1598             // - `burned` to `false`.
1599             // - `nextInitialized` to `quantity == 1`.
1600             _packedOwnerships[startTokenId] = _packOwnershipData(
1601                 to,
1602                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1603             );
1604 
1605             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1606 
1607             _currentIndex = startTokenId + quantity;
1608         }
1609         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1610     }
1611 
1612     /**
1613      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1614      *
1615      * Requirements:
1616      *
1617      * - If `to` refers to a smart contract, it must implement
1618      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1619      * - `quantity` must be greater than 0.
1620      *
1621      * See {_mint}.
1622      *
1623      * Emits a {Transfer} event for each mint.
1624      */
1625     function _safeMint(
1626         address to,
1627         uint256 quantity,
1628         bytes memory _data
1629     ) internal virtual {
1630         _mint(to, quantity);
1631 
1632         unchecked {
1633             if (to.code.length != 0) {
1634                 uint256 end = _currentIndex;
1635                 uint256 index = end - quantity;
1636                 do {
1637                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1638                         revert TransferToNonERC721ReceiverImplementer();
1639                     }
1640                 } while (index < end);
1641                 // Reentrancy protection.
1642                 if (_currentIndex != end) revert();
1643             }
1644         }
1645     }
1646 
1647     /**
1648      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1649      */
1650     function _safeMint(address to, uint256 quantity) internal virtual {
1651         _safeMint(to, quantity, '');
1652     }
1653 
1654     // =============================================================
1655     //                        BURN OPERATIONS
1656     // =============================================================
1657 
1658     /**
1659      * @dev Equivalent to `_burn(tokenId, false)`.
1660      */
1661     function _burn(uint256 tokenId) internal virtual {
1662         _burn(tokenId, false);
1663     }
1664 
1665     /**
1666      * @dev Destroys `tokenId`.
1667      * The approval is cleared when the token is burned.
1668      *
1669      * Requirements:
1670      *
1671      * - `tokenId` must exist.
1672      *
1673      * Emits a {Transfer} event.
1674      */
1675     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1676         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1677 
1678         address from = address(uint160(prevOwnershipPacked));
1679 
1680         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1681 
1682         if (approvalCheck) {
1683             // The nested ifs save around 20+ gas over a compound boolean condition.
1684             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1685                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1686         }
1687 
1688         _beforeTokenTransfers(from, address(0), tokenId, 1);
1689 
1690         // Clear approvals from the previous owner.
1691         assembly {
1692             if approvedAddress {
1693                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1694                 sstore(approvedAddressSlot, 0)
1695             }
1696         }
1697 
1698         // Underflow of the sender's balance is impossible because we check for
1699         // ownership above and the recipient's balance can't realistically overflow.
1700         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1701         unchecked {
1702             // Updates:
1703             // - `balance -= 1`.
1704             // - `numberBurned += 1`.
1705             //
1706             // We can directly decrement the balance, and increment the number burned.
1707             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1708             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1709 
1710             // Updates:
1711             // - `address` to the last owner.
1712             // - `startTimestamp` to the timestamp of burning.
1713             // - `burned` to `true`.
1714             // - `nextInitialized` to `true`.
1715             _packedOwnerships[tokenId] = _packOwnershipData(
1716                 from,
1717                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1718             );
1719 
1720             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1721             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1722                 uint256 nextTokenId = tokenId + 1;
1723                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1724                 if (_packedOwnerships[nextTokenId] == 0) {
1725                     // If the next slot is within bounds.
1726                     if (nextTokenId != _currentIndex) {
1727                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1728                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1729                     }
1730                 }
1731             }
1732         }
1733 
1734         emit Transfer(from, address(0), tokenId);
1735         _afterTokenTransfers(from, address(0), tokenId, 1);
1736 
1737         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1738         unchecked {
1739             _burnCounter++;
1740         }
1741     }
1742 
1743     // =============================================================
1744     //                     EXTRA DATA OPERATIONS
1745     // =============================================================
1746 
1747     /**
1748      * @dev Directly sets the extra data for the ownership data `index`.
1749      */
1750     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1751         uint256 packed = _packedOwnerships[index];
1752         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1753         uint256 extraDataCasted;
1754         // Cast `extraData` with assembly to avoid redundant masking.
1755         assembly {
1756             extraDataCasted := extraData
1757         }
1758         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1759         _packedOwnerships[index] = packed;
1760     }
1761 
1762     /**
1763      * @dev Called during each token transfer to set the 24bit `extraData` field.
1764      * Intended to be overridden by the cosumer contract.
1765      *
1766      * `previousExtraData` - the value of `extraData` before transfer.
1767      *
1768      * Calling conditions:
1769      *
1770      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1771      * transferred to `to`.
1772      * - When `from` is zero, `tokenId` will be minted for `to`.
1773      * - When `to` is zero, `tokenId` will be burned by `from`.
1774      * - `from` and `to` are never both zero.
1775      */
1776     function _extraData(
1777         address from,
1778         address to,
1779         uint24 previousExtraData
1780     ) internal view virtual returns (uint24) {}
1781 
1782     /**
1783      * @dev Returns the next extra data for the packed ownership data.
1784      * The returned result is shifted into position.
1785      */
1786     function _nextExtraData(
1787         address from,
1788         address to,
1789         uint256 prevOwnershipPacked
1790     ) private view returns (uint256) {
1791         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1792         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1793     }
1794 
1795     // =============================================================
1796     //                       OTHER OPERATIONS
1797     // =============================================================
1798 
1799     /**
1800      * @dev Returns the message sender (defaults to `msg.sender`).
1801      *
1802      * If you are writing GSN compatible contracts, you need to override this function.
1803      */
1804     function _msgSenderERC721A() internal view virtual returns (address) {
1805         return msg.sender;
1806     }
1807 
1808     /**
1809      * @dev Converts a uint256 to its ASCII string decimal representation.
1810      */
1811     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1812         assembly {
1813             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1814             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1815             // We will need 1 32-byte word to store the length,
1816             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1817             ptr := add(mload(0x40), 128)
1818             // Update the free memory pointer to allocate.
1819             mstore(0x40, ptr)
1820 
1821             // Cache the end of the memory to calculate the length later.
1822             let end := ptr
1823 
1824             // We write the string from the rightmost digit to the leftmost digit.
1825             // The following is essentially a do-while loop that also handles the zero case.
1826             // Costs a bit more than early returning for the zero case,
1827             // but cheaper in terms of deployment and overall runtime costs.
1828             for {
1829                 // Initialize and perform the first pass without check.
1830                 let temp := value
1831                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1832                 ptr := sub(ptr, 1)
1833                 // Write the character to the pointer.
1834                 // The ASCII index of the '0' character is 48.
1835                 mstore8(ptr, add(48, mod(temp, 10)))
1836                 temp := div(temp, 10)
1837             } temp {
1838                 // Keep dividing `temp` until zero.
1839                 temp := div(temp, 10)
1840             } {
1841                 // Body of the for loop.
1842                 ptr := sub(ptr, 1)
1843                 mstore8(ptr, add(48, mod(temp, 10)))
1844             }
1845 
1846             let length := sub(end, ptr)
1847             // Move the pointer 32 bytes leftwards to make room for the length.
1848             ptr := sub(ptr, 32)
1849             // Store the length.
1850             mstore(ptr, length)
1851         }
1852     }
1853 }
1854 
1855 // File: rookiez.sol
1856 
1857 
1858 
1859 pragma solidity >=0.8.9 <0.9.0;
1860 
1861 
1862 
1863 
1864 
1865 
1866 
1867 contract Rookiez is Ownable, ERC721A {
1868 
1869   using Strings for uint256;
1870 
1871   string public uriPrefix = "";
1872   string public uriSuffix = ".json";
1873   string public hiddenMetadataUri;
1874   
1875   uint256 public cost = 0.025 ether;
1876   uint256 public maxSupply = 7777;
1877   uint256 public wlSupply = 1200;
1878   uint256 public maxMintAmountPerTx = 15;
1879   uint256 public maxMintAmount = 3;
1880 
1881   bool public paused = true;
1882   bool public revealed = false;
1883   bool public onlyWhitelisted = true;
1884 
1885   bytes32 public merkleRoot;
1886 
1887   mapping(address => uint256) public allowlist;
1888 
1889   constructor() ERC721A("Rookiez", "RKZ")  {
1890     setHiddenMetadataUri("ipfs://QmboDCzQTXRR42sN4of1VKkFSSJDuRhVXUMejBe3JNYBLv/");
1891   }
1892 
1893   modifier mintCompliance(uint256 _mintAmount) {
1894     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1895     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1896     require(!paused, "The contract is paused!");
1897     _;
1898   }
1899 
1900   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1901     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1902     require(!onlyWhitelisted, "The presale ended!");
1903 
1904     _safeMint(msg.sender, _mintAmount);
1905   }
1906 
1907   function mintWhiteList(uint256 _mintAmount, bytes32[] memory _merkleProof) public payable mintCompliance(_mintAmount) {
1908     require(onlyWhitelisted, "The presale ended!");
1909     require(totalSupply() + _mintAmount <= wlSupply, "The presale ended!");
1910     require(maxMintAmount >= allowlist[msg.sender] + _mintAmount, "not eligible for allowlist mint");
1911     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1912     require(
1913         MerkleProof.verify(_merkleProof, merkleRoot, leaf),
1914         "Invalid Merkle Proof."
1915     );
1916     allowlist[msg.sender] = allowlist[msg.sender] + _mintAmount;
1917     _safeMint(msg.sender, _mintAmount);
1918   }
1919   
1920   function mintForAddress(uint256 _mintAmount, address[] memory _receiver) public mintCompliance(_mintAmount) onlyOwner {
1921     for (uint256 i = 0; i < _receiver.length; i++) {
1922       _safeMint(_receiver[i], _mintAmount);
1923     }
1924   }
1925 
1926   function isAllowed(address _address) public view returns (uint256)  {
1927       return allowlist[_address];
1928   }
1929 
1930   function walletOfOwner(address _owner)
1931     public
1932     view
1933     returns (uint256[] memory)
1934   {
1935     uint256 ownerTokenCount = balanceOf(_owner);
1936     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1937     uint256 currentTokenId = 1;
1938     uint256 ownedTokenIndex = 0;
1939 
1940     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1941       address currentTokenOwner = ownerOf(currentTokenId);
1942 
1943       if (currentTokenOwner == _owner) {
1944         ownedTokenIds[ownedTokenIndex] = currentTokenId+1;
1945 
1946         ownedTokenIndex++;
1947       }
1948 
1949       currentTokenId++;
1950     }
1951 
1952     return ownedTokenIds;
1953   }
1954 
1955   function tokenURI(uint256 _tokenId)
1956     public
1957     view
1958     virtual
1959     override
1960     returns (string memory)
1961   {
1962     require(
1963       _exists(_tokenId),
1964       "ERC721Metadata: URI query for nonexistent token"
1965     );
1966 
1967     if (revealed == false) {
1968       return hiddenMetadataUri;
1969     }
1970 
1971     string memory currentBaseURI = _baseURI();
1972     _tokenId = _tokenId+1;
1973     return bytes(currentBaseURI).length > 0
1974         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1975         : "";
1976   }
1977 
1978   function _startTokenId() internal view virtual override returns (uint256) {
1979     return 1;
1980   }
1981 
1982   function setOnlyWhitelisted(bool _state) public onlyOwner {
1983     onlyWhitelisted = _state;
1984   }
1985 
1986   function setRevealed(bool _state) public onlyOwner {
1987     revealed = _state;
1988   }
1989 
1990   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1991     merkleRoot = _merkleRoot;
1992   }
1993 
1994   function setCost(uint256 _cost) public onlyOwner {
1995     cost = _cost;
1996   }
1997 
1998   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1999     maxMintAmountPerTx = _maxMintAmountPerTx;
2000   }
2001 
2002   function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
2003     maxMintAmount = _maxMintAmount;
2004   }
2005 
2006   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2007     hiddenMetadataUri = _hiddenMetadataUri;
2008   }
2009 
2010   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2011     uriPrefix = _uriPrefix;
2012   }
2013 
2014   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2015     uriSuffix = _uriSuffix;
2016   }
2017 
2018   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
2019     maxSupply = _maxSupply;
2020   }
2021 
2022   function setWlSupply(uint256 _wlSupply) public onlyOwner {
2023     wlSupply = _wlSupply;
2024   }
2025 
2026   function setPaused(bool _state) public onlyOwner {
2027     paused = _state;
2028   }
2029 
2030   function withdraw() public onlyOwner {
2031     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2032     require(os);
2033   }
2034 
2035   function _baseURI() internal view virtual override returns (string memory) {
2036     return uriPrefix;
2037   }
2038 }