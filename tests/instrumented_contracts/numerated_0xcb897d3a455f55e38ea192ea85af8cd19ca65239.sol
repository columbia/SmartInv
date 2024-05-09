1 // SPDX-License-Identifier: MIT
2 
3 /*
4 ██████╗░██████╗░  ██████╗░██╗██████╗░██████╗░░██████╗
5 ╚════██╗██╔══██╗  ██╔══██╗██║██╔══██╗██╔══██╗██╔════╝
6 ░█████╔╝██║░░██║  ██████╦╝██║██████╔╝██║░░██║╚█████╗░
7 ░╚═══██╗██║░░██║  ██╔══██╗██║██╔══██╗██║░░██║░╚═══██╗
8 ██████╔╝██████╔╝  ██████╦╝██║██║░░██║██████╔╝██████╔╝
9 ╚═════╝░╚═════╝░  ╚═════╝░╚═╝╚═╝░░╚═╝╚═════╝░╚═════╝░
10 */
11 
12 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
13 
14 
15 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Contract module that helps prevent reentrant calls to a function.
21  *
22  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
23  * available, which can be applied to functions to make sure there are no nested
24  * (reentrant) calls to them.
25  *
26  * Note that because there is a single `nonReentrant` guard, functions marked as
27  * `nonReentrant` may not call one another. This can be worked around by making
28  * those functions `private`, and then adding `external` `nonReentrant` entry
29  * points to them.
30  *
31  * TIP: If you would like to learn more about reentrancy and alternative ways
32  * to protect against it, check out our blog post
33  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
34  */
35 abstract contract ReentrancyGuard {
36     // Booleans are more expensive than uint256 or any type that takes up a full
37     // word because each write operation emits an extra SLOAD to first read the
38     // slot's contents, replace the bits taken up by the boolean, and then write
39     // back. This is the compiler's defense against contract upgrades and
40     // pointer aliasing, and it cannot be disabled.
41 
42     // The values being non-zero value makes deployment a bit more expensive,
43     // but in exchange the refund on every call to nonReentrant will be lower in
44     // amount. Since refunds are capped to a percentage of the total
45     // transaction's gas, it is best to keep them low in cases like this one, to
46     // increase the likelihood of the full refund coming into effect.
47     uint256 private constant _NOT_ENTERED = 1;
48     uint256 private constant _ENTERED = 2;
49 
50     uint256 private _status;
51 
52     constructor() {
53         _status = _NOT_ENTERED;
54     }
55 
56     /**
57      * @dev Prevents a contract from calling itself, directly or indirectly.
58      * Calling a `nonReentrant` function from another `nonReentrant`
59      * function is not supported. It is possible to prevent this from happening
60      * by making the `nonReentrant` function external, and making it call a
61      * `private` function that does the actual work.
62      */
63     modifier nonReentrant() {
64         // On the first call to nonReentrant, _notEntered will be true
65         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
66 
67         // Any calls to nonReentrant after this point will fail
68         _status = _ENTERED;
69 
70         _;
71 
72         // By storing the original value once again, a refund is triggered (see
73         // https://eips.ethereum.org/EIPS/eip-2200)
74         _status = _NOT_ENTERED;
75     }
76 }
77 
78 // File: @openzeppelin/contracts/utils/Strings.sol
79 
80 
81 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
82 
83 pragma solidity ^0.8.0;
84 
85 /**
86  * @dev String operations.
87  */
88 library Strings {
89     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
90     uint8 private constant _ADDRESS_LENGTH = 20;
91 
92     /**
93      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
94      */
95     function toString(uint256 value) internal pure returns (string memory) {
96         // Inspired by OraclizeAPI's implementation - MIT licence
97         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
98 
99         if (value == 0) {
100             return "0";
101         }
102         uint256 temp = value;
103         uint256 digits;
104         while (temp != 0) {
105             digits++;
106             temp /= 10;
107         }
108         bytes memory buffer = new bytes(digits);
109         while (value != 0) {
110             digits -= 1;
111             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
112             value /= 10;
113         }
114         return string(buffer);
115     }
116 
117     /**
118      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
119      */
120     function toHexString(uint256 value) internal pure returns (string memory) {
121         if (value == 0) {
122             return "0x00";
123         }
124         uint256 temp = value;
125         uint256 length = 0;
126         while (temp != 0) {
127             length++;
128             temp >>= 8;
129         }
130         return toHexString(value, length);
131     }
132 
133     /**
134      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
135      */
136     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
137         bytes memory buffer = new bytes(2 * length + 2);
138         buffer[0] = "0";
139         buffer[1] = "x";
140         for (uint256 i = 2 * length + 1; i > 1; --i) {
141             buffer[i] = _HEX_SYMBOLS[value & 0xf];
142             value >>= 4;
143         }
144         require(value == 0, "Strings: hex length insufficient");
145         return string(buffer);
146     }
147 
148     /**
149      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
150      */
151     function toHexString(address addr) internal pure returns (string memory) {
152         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
153     }
154 }
155 
156 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
157 
158 
159 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
160 
161 pragma solidity ^0.8.0;
162 
163 /**
164  * @dev These functions deal with verification of Merkle Tree proofs.
165  *
166  * The proofs can be generated using the JavaScript library
167  * https://github.com/miguelmota/merkletreejs[merkletreejs].
168  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
169  *
170  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
171  *
172  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
173  * hashing, or use a hash function other than keccak256 for hashing leaves.
174  * This is because the concatenation of a sorted pair of internal nodes in
175  * the merkle tree could be reinterpreted as a leaf value.
176  */
177 library MerkleProof {
178     /**
179      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
180      * defined by `root`. For this, a `proof` must be provided, containing
181      * sibling hashes on the branch from the leaf to the root of the tree. Each
182      * pair of leaves and each pair of pre-images are assumed to be sorted.
183      */
184     function verify(
185         bytes32[] memory proof,
186         bytes32 root,
187         bytes32 leaf
188     ) internal pure returns (bool) {
189         return processProof(proof, leaf) == root;
190     }
191 
192     /**
193      * @dev Calldata version of {verify}
194      *
195      * _Available since v4.7._
196      */
197     function verifyCalldata(
198         bytes32[] calldata proof,
199         bytes32 root,
200         bytes32 leaf
201     ) internal pure returns (bool) {
202         return processProofCalldata(proof, leaf) == root;
203     }
204 
205     /**
206      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
207      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
208      * hash matches the root of the tree. When processing the proof, the pairs
209      * of leafs & pre-images are assumed to be sorted.
210      *
211      * _Available since v4.4._
212      */
213     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
214         bytes32 computedHash = leaf;
215         for (uint256 i = 0; i < proof.length; i++) {
216             computedHash = _hashPair(computedHash, proof[i]);
217         }
218         return computedHash;
219     }
220 
221     /**
222      * @dev Calldata version of {processProof}
223      *
224      * _Available since v4.7._
225      */
226     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
227         bytes32 computedHash = leaf;
228         for (uint256 i = 0; i < proof.length; i++) {
229             computedHash = _hashPair(computedHash, proof[i]);
230         }
231         return computedHash;
232     }
233 
234     /**
235      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
236      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
237      *
238      * _Available since v4.7._
239      */
240     function multiProofVerify(
241         bytes32[] memory proof,
242         bool[] memory proofFlags,
243         bytes32 root,
244         bytes32[] memory leaves
245     ) internal pure returns (bool) {
246         return processMultiProof(proof, proofFlags, leaves) == root;
247     }
248 
249     /**
250      * @dev Calldata version of {multiProofVerify}
251      *
252      * _Available since v4.7._
253      */
254     function multiProofVerifyCalldata(
255         bytes32[] calldata proof,
256         bool[] calldata proofFlags,
257         bytes32 root,
258         bytes32[] memory leaves
259     ) internal pure returns (bool) {
260         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
261     }
262 
263     /**
264      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
265      * consuming from one or the other at each step according to the instructions given by
266      * `proofFlags`.
267      *
268      * _Available since v4.7._
269      */
270     function processMultiProof(
271         bytes32[] memory proof,
272         bool[] memory proofFlags,
273         bytes32[] memory leaves
274     ) internal pure returns (bytes32 merkleRoot) {
275         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
276         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
277         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
278         // the merkle tree.
279         uint256 leavesLen = leaves.length;
280         uint256 totalHashes = proofFlags.length;
281 
282         // Check proof validity.
283         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
284 
285         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
286         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
287         bytes32[] memory hashes = new bytes32[](totalHashes);
288         uint256 leafPos = 0;
289         uint256 hashPos = 0;
290         uint256 proofPos = 0;
291         // At each step, we compute the next hash using two values:
292         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
293         //   get the next hash.
294         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
295         //   `proof` array.
296         for (uint256 i = 0; i < totalHashes; i++) {
297             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
298             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
299             hashes[i] = _hashPair(a, b);
300         }
301 
302         if (totalHashes > 0) {
303             return hashes[totalHashes - 1];
304         } else if (leavesLen > 0) {
305             return leaves[0];
306         } else {
307             return proof[0];
308         }
309     }
310 
311     /**
312      * @dev Calldata version of {processMultiProof}
313      *
314      * _Available since v4.7._
315      */
316     function processMultiProofCalldata(
317         bytes32[] calldata proof,
318         bool[] calldata proofFlags,
319         bytes32[] memory leaves
320     ) internal pure returns (bytes32 merkleRoot) {
321         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
322         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
323         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
324         // the merkle tree.
325         uint256 leavesLen = leaves.length;
326         uint256 totalHashes = proofFlags.length;
327 
328         // Check proof validity.
329         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
330 
331         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
332         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
333         bytes32[] memory hashes = new bytes32[](totalHashes);
334         uint256 leafPos = 0;
335         uint256 hashPos = 0;
336         uint256 proofPos = 0;
337         // At each step, we compute the next hash using two values:
338         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
339         //   get the next hash.
340         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
341         //   `proof` array.
342         for (uint256 i = 0; i < totalHashes; i++) {
343             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
344             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
345             hashes[i] = _hashPair(a, b);
346         }
347 
348         if (totalHashes > 0) {
349             return hashes[totalHashes - 1];
350         } else if (leavesLen > 0) {
351             return leaves[0];
352         } else {
353             return proof[0];
354         }
355     }
356 
357     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
358         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
359     }
360 
361     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
362         /// @solidity memory-safe-assembly
363         assembly {
364             mstore(0x00, a)
365             mstore(0x20, b)
366             value := keccak256(0x00, 0x40)
367         }
368     }
369 }
370 
371 // File: @openzeppelin/contracts/utils/Context.sol
372 
373 
374 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 /**
379  * @dev Provides information about the current execution context, including the
380  * sender of the transaction and its data. While these are generally available
381  * via msg.sender and msg.data, they should not be accessed in such a direct
382  * manner, since when dealing with meta-transactions the account sending and
383  * paying for execution may not be the actual sender (as far as an application
384  * is concerned).
385  *
386  * This contract is only required for intermediate, library-like contracts.
387  */
388 abstract contract Context {
389     function _msgSender() internal view virtual returns (address) {
390         return msg.sender;
391     }
392 
393     function _msgData() internal view virtual returns (bytes calldata) {
394         return msg.data;
395     }
396 }
397 
398 // File: @openzeppelin/contracts/access/Ownable.sol
399 
400 
401 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
402 
403 pragma solidity ^0.8.0;
404 
405 
406 /**
407  * @dev Contract module which provides a basic access control mechanism, where
408  * there is an account (an owner) that can be granted exclusive access to
409  * specific functions.
410  *
411  * By default, the owner account will be the one that deploys the contract. This
412  * can later be changed with {transferOwnership}.
413  *
414  * This module is used through inheritance. It will make available the modifier
415  * `onlyOwner`, which can be applied to your functions to restrict their use to
416  * the owner.
417  */
418 abstract contract Ownable is Context {
419     address private _owner;
420 
421     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
422 
423     /**
424      * @dev Initializes the contract setting the deployer as the initial owner.
425      */
426     constructor() {
427         _transferOwnership(_msgSender());
428     }
429 
430     /**
431      * @dev Throws if called by any account other than the owner.
432      */
433     modifier onlyOwner() {
434         _checkOwner();
435         _;
436     }
437 
438     /**
439      * @dev Returns the address of the current owner.
440      */
441     function owner() public view virtual returns (address) {
442         return _owner;
443     }
444 
445     /**
446      * @dev Throws if the sender is not the owner.
447      */
448     function _checkOwner() internal view virtual {
449         require(owner() == _msgSender(), "Ownable: caller is not the owner");
450     }
451 
452     /**
453      * @dev Leaves the contract without owner. It will not be possible to call
454      * `onlyOwner` functions anymore. Can only be called by the current owner.
455      *
456      * NOTE: Renouncing ownership will leave the contract without an owner,
457      * thereby removing any functionality that is only available to the owner.
458      */
459     function renounceOwnership() public virtual onlyOwner {
460         _transferOwnership(address(0));
461     }
462 
463     /**
464      * @dev Transfers ownership of the contract to a new account (`newOwner`).
465      * Can only be called by the current owner.
466      */
467     function transferOwnership(address newOwner) public virtual onlyOwner {
468         require(newOwner != address(0), "Ownable: new owner is the zero address");
469         _transferOwnership(newOwner);
470     }
471 
472     /**
473      * @dev Transfers ownership of the contract to a new account (`newOwner`).
474      * Internal function without access restriction.
475      */
476     function _transferOwnership(address newOwner) internal virtual {
477         address oldOwner = _owner;
478         _owner = newOwner;
479         emit OwnershipTransferred(oldOwner, newOwner);
480     }
481 }
482 
483 // File: erc721a/contracts/IERC721A.sol
484 
485 
486 // ERC721A Contracts v4.1.0
487 // Creator: Chiru Labs
488 
489 pragma solidity ^0.8.4;
490 
491 /**
492  * @dev Interface of an ERC721A compliant contract.
493  */
494 interface IERC721A {
495     /**
496      * The caller must own the token or be an approved operator.
497      */
498     error ApprovalCallerNotOwnerNorApproved();
499 
500     /**
501      * The token does not exist.
502      */
503     error ApprovalQueryForNonexistentToken();
504 
505     /**
506      * The caller cannot approve to their own address.
507      */
508     error ApproveToCaller();
509 
510     /**
511      * Cannot query the balance for the zero address.
512      */
513     error BalanceQueryForZeroAddress();
514 
515     /**
516      * Cannot mint to the zero address.
517      */
518     error MintToZeroAddress();
519 
520     /**
521      * The quantity of tokens minted must be more than zero.
522      */
523     error MintZeroQuantity();
524 
525     /**
526      * The token does not exist.
527      */
528     error OwnerQueryForNonexistentToken();
529 
530     /**
531      * The caller must own the token or be an approved operator.
532      */
533     error TransferCallerNotOwnerNorApproved();
534 
535     /**
536      * The token must be owned by `from`.
537      */
538     error TransferFromIncorrectOwner();
539 
540     /**
541      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
542      */
543     error TransferToNonERC721ReceiverImplementer();
544 
545     /**
546      * Cannot transfer to the zero address.
547      */
548     error TransferToZeroAddress();
549 
550     /**
551      * The token does not exist.
552      */
553     error URIQueryForNonexistentToken();
554 
555     /**
556      * The `quantity` minted with ERC2309 exceeds the safety limit.
557      */
558     error MintERC2309QuantityExceedsLimit();
559 
560     /**
561      * The `extraData` cannot be set on an unintialized ownership slot.
562      */
563     error OwnershipNotInitializedForExtraData();
564 
565     struct TokenOwnership {
566         // The address of the owner.
567         address addr;
568         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
569         uint64 startTimestamp;
570         // Whether the token has been burned.
571         bool burned;
572         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
573         uint24 extraData;
574     }
575 
576     /**
577      * @dev Returns the total amount of tokens stored by the contract.
578      *
579      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
580      */
581     function totalSupply() external view returns (uint256);
582 
583     // ==============================
584     //            IERC165
585     // ==============================
586 
587     /**
588      * @dev Returns true if this contract implements the interface defined by
589      * `interfaceId`. See the corresponding
590      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
591      * to learn more about how these ids are created.
592      *
593      * This function call must use less than 30 000 gas.
594      */
595     function supportsInterface(bytes4 interfaceId) external view returns (bool);
596 
597     // ==============================
598     //            IERC721
599     // ==============================
600 
601     /**
602      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
603      */
604     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
605 
606     /**
607      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
608      */
609     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
610 
611     /**
612      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
613      */
614     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
615 
616     /**
617      * @dev Returns the number of tokens in ``owner``'s account.
618      */
619     function balanceOf(address owner) external view returns (uint256 balance);
620 
621     /**
622      * @dev Returns the owner of the `tokenId` token.
623      *
624      * Requirements:
625      *
626      * - `tokenId` must exist.
627      */
628     function ownerOf(uint256 tokenId) external view returns (address owner);
629 
630     /**
631      * @dev Safely transfers `tokenId` token from `from` to `to`.
632      *
633      * Requirements:
634      *
635      * - `from` cannot be the zero address.
636      * - `to` cannot be the zero address.
637      * - `tokenId` token must exist and be owned by `from`.
638      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
639      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
640      *
641      * Emits a {Transfer} event.
642      */
643     function safeTransferFrom(
644         address from,
645         address to,
646         uint256 tokenId,
647         bytes calldata data
648     ) external;
649 
650     /**
651      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
652      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
653      *
654      * Requirements:
655      *
656      * - `from` cannot be the zero address.
657      * - `to` cannot be the zero address.
658      * - `tokenId` token must exist and be owned by `from`.
659      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
660      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
661      *
662      * Emits a {Transfer} event.
663      */
664     function safeTransferFrom(
665         address from,
666         address to,
667         uint256 tokenId
668     ) external;
669 
670     /**
671      * @dev Transfers `tokenId` token from `from` to `to`.
672      *
673      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
674      *
675      * Requirements:
676      *
677      * - `from` cannot be the zero address.
678      * - `to` cannot be the zero address.
679      * - `tokenId` token must be owned by `from`.
680      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
681      *
682      * Emits a {Transfer} event.
683      */
684     function transferFrom(
685         address from,
686         address to,
687         uint256 tokenId
688     ) external;
689 
690     /**
691      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
692      * The approval is cleared when the token is transferred.
693      *
694      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
695      *
696      * Requirements:
697      *
698      * - The caller must own the token or be an approved operator.
699      * - `tokenId` must exist.
700      *
701      * Emits an {Approval} event.
702      */
703     function approve(address to, uint256 tokenId) external;
704 
705     /**
706      * @dev Approve or remove `operator` as an operator for the caller.
707      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
708      *
709      * Requirements:
710      *
711      * - The `operator` cannot be the caller.
712      *
713      * Emits an {ApprovalForAll} event.
714      */
715     function setApprovalForAll(address operator, bool _approved) external;
716 
717     /**
718      * @dev Returns the account approved for `tokenId` token.
719      *
720      * Requirements:
721      *
722      * - `tokenId` must exist.
723      */
724     function getApproved(uint256 tokenId) external view returns (address operator);
725 
726     /**
727      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
728      *
729      * See {setApprovalForAll}
730      */
731     function isApprovedForAll(address owner, address operator) external view returns (bool);
732 
733     // ==============================
734     //        IERC721Metadata
735     // ==============================
736 
737     /**
738      * @dev Returns the token collection name.
739      */
740     function name() external view returns (string memory);
741 
742     /**
743      * @dev Returns the token collection symbol.
744      */
745     function symbol() external view returns (string memory);
746 
747     /**
748      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
749      */
750     function tokenURI(uint256 tokenId) external view returns (string memory);
751 
752     // ==============================
753     //            IERC2309
754     // ==============================
755 
756     /**
757      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
758      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
759      */
760     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
761 }
762 
763 // File: erc721a/contracts/ERC721A.sol
764 
765 
766 // ERC721A Contracts v4.1.0
767 // Creator: Chiru Labs
768 
769 pragma solidity ^0.8.4;
770 
771 
772 /**
773  * @dev ERC721 token receiver interface.
774  */
775 interface ERC721A__IERC721Receiver {
776     function onERC721Received(
777         address operator,
778         address from,
779         uint256 tokenId,
780         bytes calldata data
781     ) external returns (bytes4);
782 }
783 
784 /**
785  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
786  * including the Metadata extension. Built to optimize for lower gas during batch mints.
787  *
788  * Assumes serials are sequentially minted starting at `_startTokenId()`
789  * (defaults to 0, e.g. 0, 1, 2, 3..).
790  *
791  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
792  *
793  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
794  */
795 contract ERC721A is IERC721A {
796     // Mask of an entry in packed address data.
797     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
798 
799     // The bit position of `numberMinted` in packed address data.
800     uint256 private constant BITPOS_NUMBER_MINTED = 64;
801 
802     // The bit position of `numberBurned` in packed address data.
803     uint256 private constant BITPOS_NUMBER_BURNED = 128;
804 
805     // The bit position of `aux` in packed address data.
806     uint256 private constant BITPOS_AUX = 192;
807 
808     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
809     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
810 
811     // The bit position of `startTimestamp` in packed ownership.
812     uint256 private constant BITPOS_START_TIMESTAMP = 160;
813 
814     // The bit mask of the `burned` bit in packed ownership.
815     uint256 private constant BITMASK_BURNED = 1 << 224;
816 
817     // The bit position of the `nextInitialized` bit in packed ownership.
818     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
819 
820     // The bit mask of the `nextInitialized` bit in packed ownership.
821     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
822 
823     // The bit position of `extraData` in packed ownership.
824     uint256 private constant BITPOS_EXTRA_DATA = 232;
825 
826     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
827     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
828 
829     // The mask of the lower 160 bits for addresses.
830     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
831 
832     // The maximum `quantity` that can be minted with `_mintERC2309`.
833     // This limit is to prevent overflows on the address data entries.
834     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
835     // is required to cause an overflow, which is unrealistic.
836     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
837 
838     // The tokenId of the next token to be minted.
839     uint256 private _currentIndex;
840 
841     // The number of tokens burned.
842     uint256 private _burnCounter;
843 
844     // Token name
845     string private _name;
846 
847     // Token symbol
848     string private _symbol;
849 
850     // Mapping from token ID to ownership details
851     // An empty struct value does not necessarily mean the token is unowned.
852     // See `_packedOwnershipOf` implementation for details.
853     //
854     // Bits Layout:
855     // - [0..159]   `addr`
856     // - [160..223] `startTimestamp`
857     // - [224]      `burned`
858     // - [225]      `nextInitialized`
859     // - [232..255] `extraData`
860     mapping(uint256 => uint256) private _packedOwnerships;
861 
862     // Mapping owner address to address data.
863     //
864     // Bits Layout:
865     // - [0..63]    `balance`
866     // - [64..127]  `numberMinted`
867     // - [128..191] `numberBurned`
868     // - [192..255] `aux`
869     mapping(address => uint256) private _packedAddressData;
870 
871     // Mapping from token ID to approved address.
872     mapping(uint256 => address) private _tokenApprovals;
873 
874     // Mapping from owner to operator approvals
875     mapping(address => mapping(address => bool)) private _operatorApprovals;
876 
877     constructor(string memory name_, string memory symbol_) {
878         _name = name_;
879         _symbol = symbol_;
880         _currentIndex = _startTokenId();
881     }
882 
883     /**
884      * @dev Returns the starting token ID.
885      * To change the starting token ID, please override this function.
886      */
887     function _startTokenId() internal view virtual returns (uint256) {
888         return 0;
889     }
890 
891     /**
892      * @dev Returns the next token ID to be minted.
893      */
894     function _nextTokenId() internal view returns (uint256) {
895         return _currentIndex;
896     }
897 
898     /**
899      * @dev Returns the total number of tokens in existence.
900      * Burned tokens will reduce the count.
901      * To get the total number of tokens minted, please see `_totalMinted`.
902      */
903     function totalSupply() public view override returns (uint256) {
904         // Counter underflow is impossible as _burnCounter cannot be incremented
905         // more than `_currentIndex - _startTokenId()` times.
906         unchecked {
907             return _currentIndex - _burnCounter - _startTokenId();
908         }
909     }
910 
911     /**
912      * @dev Returns the total amount of tokens minted in the contract.
913      */
914     function _totalMinted() internal view returns (uint256) {
915         // Counter underflow is impossible as _currentIndex does not decrement,
916         // and it is initialized to `_startTokenId()`
917         unchecked {
918             return _currentIndex - _startTokenId();
919         }
920     }
921 
922     /**
923      * @dev Returns the total number of tokens burned.
924      */
925     function _totalBurned() internal view returns (uint256) {
926         return _burnCounter;
927     }
928 
929     /**
930      * @dev See {IERC165-supportsInterface}.
931      */
932     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
933         // The interface IDs are constants representing the first 4 bytes of the XOR of
934         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
935         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
936         return
937             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
938             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
939             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
940     }
941 
942     /**
943      * @dev See {IERC721-balanceOf}.
944      */
945     function balanceOf(address owner) public view override returns (uint256) {
946         if (owner == address(0)) revert BalanceQueryForZeroAddress();
947         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
948     }
949 
950     /**
951      * Returns the number of tokens minted by `owner`.
952      */
953     function _numberMinted(address owner) internal view returns (uint256) {
954         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
955     }
956 
957     /**
958      * Returns the number of tokens burned by or on behalf of `owner`.
959      */
960     function _numberBurned(address owner) internal view returns (uint256) {
961         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
962     }
963 
964     /**
965      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
966      */
967     function _getAux(address owner) internal view returns (uint64) {
968         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
969     }
970 
971     /**
972      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
973      * If there are multiple variables, please pack them into a uint64.
974      */
975     function _setAux(address owner, uint64 aux) internal {
976         uint256 packed = _packedAddressData[owner];
977         uint256 auxCasted;
978         // Cast `aux` with assembly to avoid redundant masking.
979         assembly {
980             auxCasted := aux
981         }
982         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
983         _packedAddressData[owner] = packed;
984     }
985 
986     /**
987      * Returns the packed ownership data of `tokenId`.
988      */
989     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
990         uint256 curr = tokenId;
991 
992         unchecked {
993             if (_startTokenId() <= curr)
994                 if (curr < _currentIndex) {
995                     uint256 packed = _packedOwnerships[curr];
996                     // If not burned.
997                     if (packed & BITMASK_BURNED == 0) {
998                         // Invariant:
999                         // There will always be an ownership that has an address and is not burned
1000                         // before an ownership that does not have an address and is not burned.
1001                         // Hence, curr will not underflow.
1002                         //
1003                         // We can directly compare the packed value.
1004                         // If the address is zero, packed is zero.
1005                         while (packed == 0) {
1006                             packed = _packedOwnerships[--curr];
1007                         }
1008                         return packed;
1009                     }
1010                 }
1011         }
1012         revert OwnerQueryForNonexistentToken();
1013     }
1014 
1015     /**
1016      * Returns the unpacked `TokenOwnership` struct from `packed`.
1017      */
1018     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1019         ownership.addr = address(uint160(packed));
1020         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1021         ownership.burned = packed & BITMASK_BURNED != 0;
1022         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1023     }
1024 
1025     /**
1026      * Returns the unpacked `TokenOwnership` struct at `index`.
1027      */
1028     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1029         return _unpackedOwnership(_packedOwnerships[index]);
1030     }
1031 
1032     /**
1033      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1034      */
1035     function _initializeOwnershipAt(uint256 index) internal {
1036         if (_packedOwnerships[index] == 0) {
1037             _packedOwnerships[index] = _packedOwnershipOf(index);
1038         }
1039     }
1040 
1041     /**
1042      * Gas spent here starts off proportional to the maximum mint batch size.
1043      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1044      */
1045     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1046         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1047     }
1048 
1049     /**
1050      * @dev Packs ownership data into a single uint256.
1051      */
1052     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1053         assembly {
1054             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1055             owner := and(owner, BITMASK_ADDRESS)
1056             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1057             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1058         }
1059     }
1060 
1061     /**
1062      * @dev See {IERC721-ownerOf}.
1063      */
1064     function ownerOf(uint256 tokenId) public view override returns (address) {
1065         return address(uint160(_packedOwnershipOf(tokenId)));
1066     }
1067 
1068     /**
1069      * @dev See {IERC721Metadata-name}.
1070      */
1071     function name() public view virtual override returns (string memory) {
1072         return _name;
1073     }
1074 
1075     /**
1076      * @dev See {IERC721Metadata-symbol}.
1077      */
1078     function symbol() public view virtual override returns (string memory) {
1079         return _symbol;
1080     }
1081 
1082     /**
1083      * @dev See {IERC721Metadata-tokenURI}.
1084      */
1085     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1086         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1087 
1088         string memory baseURI = _baseURI();
1089         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1090     }
1091 
1092     /**
1093      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1094      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1095      * by default, it can be overridden in child contracts.
1096      */
1097     function _baseURI() internal view virtual returns (string memory) {
1098         return '';
1099     }
1100 
1101     /**
1102      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1103      */
1104     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1105         // For branchless setting of the `nextInitialized` flag.
1106         assembly {
1107             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1108             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1109         }
1110     }
1111 
1112     /**
1113      * @dev See {IERC721-approve}.
1114      */
1115     function approve(address to, uint256 tokenId) public override {
1116         address owner = ownerOf(tokenId);
1117 
1118         if (_msgSenderERC721A() != owner)
1119             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1120                 revert ApprovalCallerNotOwnerNorApproved();
1121             }
1122 
1123         _tokenApprovals[tokenId] = to;
1124         emit Approval(owner, to, tokenId);
1125     }
1126 
1127     /**
1128      * @dev See {IERC721-getApproved}.
1129      */
1130     function getApproved(uint256 tokenId) public view override returns (address) {
1131         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1132 
1133         return _tokenApprovals[tokenId];
1134     }
1135 
1136     /**
1137      * @dev See {IERC721-setApprovalForAll}.
1138      */
1139     function setApprovalForAll(address operator, bool approved) public virtual override {
1140         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1141 
1142         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1143         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1144     }
1145 
1146     /**
1147      * @dev See {IERC721-isApprovedForAll}.
1148      */
1149     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1150         return _operatorApprovals[owner][operator];
1151     }
1152 
1153     /**
1154      * @dev See {IERC721-safeTransferFrom}.
1155      */
1156     function safeTransferFrom(
1157         address from,
1158         address to,
1159         uint256 tokenId
1160     ) public virtual override {
1161         safeTransferFrom(from, to, tokenId, '');
1162     }
1163 
1164     /**
1165      * @dev See {IERC721-safeTransferFrom}.
1166      */
1167     function safeTransferFrom(
1168         address from,
1169         address to,
1170         uint256 tokenId,
1171         bytes memory _data
1172     ) public virtual override {
1173         transferFrom(from, to, tokenId);
1174         if (to.code.length != 0)
1175             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1176                 revert TransferToNonERC721ReceiverImplementer();
1177             }
1178     }
1179 
1180     /**
1181      * @dev Returns whether `tokenId` exists.
1182      *
1183      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1184      *
1185      * Tokens start existing when they are minted (`_mint`),
1186      */
1187     function _exists(uint256 tokenId) internal view returns (bool) {
1188         return
1189             _startTokenId() <= tokenId &&
1190             tokenId < _currentIndex && // If within bounds,
1191             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1192     }
1193 
1194     /**
1195      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1196      */
1197     function _safeMint(address to, uint256 quantity) internal {
1198         _safeMint(to, quantity, '');
1199     }
1200 
1201     /**
1202      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1203      *
1204      * Requirements:
1205      *
1206      * - If `to` refers to a smart contract, it must implement
1207      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1208      * - `quantity` must be greater than 0.
1209      *
1210      * See {_mint}.
1211      *
1212      * Emits a {Transfer} event for each mint.
1213      */
1214     function _safeMint(
1215         address to,
1216         uint256 quantity,
1217         bytes memory _data
1218     ) internal {
1219         _mint(to, quantity);
1220 
1221         unchecked {
1222             if (to.code.length != 0) {
1223                 uint256 end = _currentIndex;
1224                 uint256 index = end - quantity;
1225                 do {
1226                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1227                         revert TransferToNonERC721ReceiverImplementer();
1228                     }
1229                 } while (index < end);
1230                 // Reentrancy protection.
1231                 if (_currentIndex != end) revert();
1232             }
1233         }
1234     }
1235 
1236     /**
1237      * @dev Mints `quantity` tokens and transfers them to `to`.
1238      *
1239      * Requirements:
1240      *
1241      * - `to` cannot be the zero address.
1242      * - `quantity` must be greater than 0.
1243      *
1244      * Emits a {Transfer} event for each mint.
1245      */
1246     function _mint(address to, uint256 quantity) internal {
1247         uint256 startTokenId = _currentIndex;
1248         if (to == address(0)) revert MintToZeroAddress();
1249         if (quantity == 0) revert MintZeroQuantity();
1250 
1251         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1252 
1253         // Overflows are incredibly unrealistic.
1254         // `balance` and `numberMinted` have a maximum limit of 2**64.
1255         // `tokenId` has a maximum limit of 2**256.
1256         unchecked {
1257             // Updates:
1258             // - `balance += quantity`.
1259             // - `numberMinted += quantity`.
1260             //
1261             // We can directly add to the `balance` and `numberMinted`.
1262             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1263 
1264             // Updates:
1265             // - `address` to the owner.
1266             // - `startTimestamp` to the timestamp of minting.
1267             // - `burned` to `false`.
1268             // - `nextInitialized` to `quantity == 1`.
1269             _packedOwnerships[startTokenId] = _packOwnershipData(
1270                 to,
1271                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1272             );
1273 
1274             uint256 tokenId = startTokenId;
1275             uint256 end = startTokenId + quantity;
1276             do {
1277                 emit Transfer(address(0), to, tokenId++);
1278             } while (tokenId < end);
1279 
1280             _currentIndex = end;
1281         }
1282         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1283     }
1284 
1285     /**
1286      * @dev Mints `quantity` tokens and transfers them to `to`.
1287      *
1288      * This function is intended for efficient minting only during contract creation.
1289      *
1290      * It emits only one {ConsecutiveTransfer} as defined in
1291      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1292      * instead of a sequence of {Transfer} event(s).
1293      *
1294      * Calling this function outside of contract creation WILL make your contract
1295      * non-compliant with the ERC721 standard.
1296      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1297      * {ConsecutiveTransfer} event is only permissible during contract creation.
1298      *
1299      * Requirements:
1300      *
1301      * - `to` cannot be the zero address.
1302      * - `quantity` must be greater than 0.
1303      *
1304      * Emits a {ConsecutiveTransfer} event.
1305      */
1306     function _mintERC2309(address to, uint256 quantity) internal {
1307         uint256 startTokenId = _currentIndex;
1308         if (to == address(0)) revert MintToZeroAddress();
1309         if (quantity == 0) revert MintZeroQuantity();
1310         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1311 
1312         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1313 
1314         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1315         unchecked {
1316             // Updates:
1317             // - `balance += quantity`.
1318             // - `numberMinted += quantity`.
1319             //
1320             // We can directly add to the `balance` and `numberMinted`.
1321             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1322 
1323             // Updates:
1324             // - `address` to the owner.
1325             // - `startTimestamp` to the timestamp of minting.
1326             // - `burned` to `false`.
1327             // - `nextInitialized` to `quantity == 1`.
1328             _packedOwnerships[startTokenId] = _packOwnershipData(
1329                 to,
1330                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1331             );
1332 
1333             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1334 
1335             _currentIndex = startTokenId + quantity;
1336         }
1337         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1338     }
1339 
1340     /**
1341      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1342      */
1343     function _getApprovedAddress(uint256 tokenId)
1344         private
1345         view
1346         returns (uint256 approvedAddressSlot, address approvedAddress)
1347     {
1348         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1349         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1350         assembly {
1351             // Compute the slot.
1352             mstore(0x00, tokenId)
1353             mstore(0x20, tokenApprovalsPtr.slot)
1354             approvedAddressSlot := keccak256(0x00, 0x40)
1355             // Load the slot's value from storage.
1356             approvedAddress := sload(approvedAddressSlot)
1357         }
1358     }
1359 
1360     /**
1361      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1362      */
1363     function _isOwnerOrApproved(
1364         address approvedAddress,
1365         address from,
1366         address msgSender
1367     ) private pure returns (bool result) {
1368         assembly {
1369             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1370             from := and(from, BITMASK_ADDRESS)
1371             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1372             msgSender := and(msgSender, BITMASK_ADDRESS)
1373             // `msgSender == from || msgSender == approvedAddress`.
1374             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1375         }
1376     }
1377 
1378     /**
1379      * @dev Transfers `tokenId` from `from` to `to`.
1380      *
1381      * Requirements:
1382      *
1383      * - `to` cannot be the zero address.
1384      * - `tokenId` token must be owned by `from`.
1385      *
1386      * Emits a {Transfer} event.
1387      */
1388     function transferFrom(
1389         address from,
1390         address to,
1391         uint256 tokenId
1392     ) public virtual override {
1393         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1394 
1395         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1396 
1397         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1398 
1399         // The nested ifs save around 20+ gas over a compound boolean condition.
1400         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1401             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1402 
1403         if (to == address(0)) revert TransferToZeroAddress();
1404 
1405         _beforeTokenTransfers(from, to, tokenId, 1);
1406 
1407         // Clear approvals from the previous owner.
1408         assembly {
1409             if approvedAddress {
1410                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1411                 sstore(approvedAddressSlot, 0)
1412             }
1413         }
1414 
1415         // Underflow of the sender's balance is impossible because we check for
1416         // ownership above and the recipient's balance can't realistically overflow.
1417         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1418         unchecked {
1419             // We can directly increment and decrement the balances.
1420             --_packedAddressData[from]; // Updates: `balance -= 1`.
1421             ++_packedAddressData[to]; // Updates: `balance += 1`.
1422 
1423             // Updates:
1424             // - `address` to the next owner.
1425             // - `startTimestamp` to the timestamp of transfering.
1426             // - `burned` to `false`.
1427             // - `nextInitialized` to `true`.
1428             _packedOwnerships[tokenId] = _packOwnershipData(
1429                 to,
1430                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1431             );
1432 
1433             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1434             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1435                 uint256 nextTokenId = tokenId + 1;
1436                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1437                 if (_packedOwnerships[nextTokenId] == 0) {
1438                     // If the next slot is within bounds.
1439                     if (nextTokenId != _currentIndex) {
1440                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1441                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1442                     }
1443                 }
1444             }
1445         }
1446 
1447         emit Transfer(from, to, tokenId);
1448         _afterTokenTransfers(from, to, tokenId, 1);
1449     }
1450 
1451     /**
1452      * @dev Equivalent to `_burn(tokenId, false)`.
1453      */
1454     function _burn(uint256 tokenId) internal virtual {
1455         _burn(tokenId, false);
1456     }
1457 
1458     /**
1459      * @dev Destroys `tokenId`.
1460      * The approval is cleared when the token is burned.
1461      *
1462      * Requirements:
1463      *
1464      * - `tokenId` must exist.
1465      *
1466      * Emits a {Transfer} event.
1467      */
1468     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1469         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1470 
1471         address from = address(uint160(prevOwnershipPacked));
1472 
1473         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1474 
1475         if (approvalCheck) {
1476             // The nested ifs save around 20+ gas over a compound boolean condition.
1477             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1478                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1479         }
1480 
1481         _beforeTokenTransfers(from, address(0), tokenId, 1);
1482 
1483         // Clear approvals from the previous owner.
1484         assembly {
1485             if approvedAddress {
1486                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1487                 sstore(approvedAddressSlot, 0)
1488             }
1489         }
1490 
1491         // Underflow of the sender's balance is impossible because we check for
1492         // ownership above and the recipient's balance can't realistically overflow.
1493         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1494         unchecked {
1495             // Updates:
1496             // - `balance -= 1`.
1497             // - `numberBurned += 1`.
1498             //
1499             // We can directly decrement the balance, and increment the number burned.
1500             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1501             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1502 
1503             // Updates:
1504             // - `address` to the last owner.
1505             // - `startTimestamp` to the timestamp of burning.
1506             // - `burned` to `true`.
1507             // - `nextInitialized` to `true`.
1508             _packedOwnerships[tokenId] = _packOwnershipData(
1509                 from,
1510                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1511             );
1512 
1513             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1514             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1515                 uint256 nextTokenId = tokenId + 1;
1516                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1517                 if (_packedOwnerships[nextTokenId] == 0) {
1518                     // If the next slot is within bounds.
1519                     if (nextTokenId != _currentIndex) {
1520                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1521                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1522                     }
1523                 }
1524             }
1525         }
1526 
1527         emit Transfer(from, address(0), tokenId);
1528         _afterTokenTransfers(from, address(0), tokenId, 1);
1529 
1530         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1531         unchecked {
1532             _burnCounter++;
1533         }
1534     }
1535 
1536     /**
1537      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1538      *
1539      * @param from address representing the previous owner of the given token ID
1540      * @param to target address that will receive the tokens
1541      * @param tokenId uint256 ID of the token to be transferred
1542      * @param _data bytes optional data to send along with the call
1543      * @return bool whether the call correctly returned the expected magic value
1544      */
1545     function _checkContractOnERC721Received(
1546         address from,
1547         address to,
1548         uint256 tokenId,
1549         bytes memory _data
1550     ) private returns (bool) {
1551         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1552             bytes4 retval
1553         ) {
1554             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1555         } catch (bytes memory reason) {
1556             if (reason.length == 0) {
1557                 revert TransferToNonERC721ReceiverImplementer();
1558             } else {
1559                 assembly {
1560                     revert(add(32, reason), mload(reason))
1561                 }
1562             }
1563         }
1564     }
1565 
1566     /**
1567      * @dev Directly sets the extra data for the ownership data `index`.
1568      */
1569     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1570         uint256 packed = _packedOwnerships[index];
1571         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1572         uint256 extraDataCasted;
1573         // Cast `extraData` with assembly to avoid redundant masking.
1574         assembly {
1575             extraDataCasted := extraData
1576         }
1577         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1578         _packedOwnerships[index] = packed;
1579     }
1580 
1581     /**
1582      * @dev Returns the next extra data for the packed ownership data.
1583      * The returned result is shifted into position.
1584      */
1585     function _nextExtraData(
1586         address from,
1587         address to,
1588         uint256 prevOwnershipPacked
1589     ) private view returns (uint256) {
1590         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1591         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1592     }
1593 
1594     /**
1595      * @dev Called during each token transfer to set the 24bit `extraData` field.
1596      * Intended to be overridden by the cosumer contract.
1597      *
1598      * `previousExtraData` - the value of `extraData` before transfer.
1599      *
1600      * Calling conditions:
1601      *
1602      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1603      * transferred to `to`.
1604      * - When `from` is zero, `tokenId` will be minted for `to`.
1605      * - When `to` is zero, `tokenId` will be burned by `from`.
1606      * - `from` and `to` are never both zero.
1607      */
1608     function _extraData(
1609         address from,
1610         address to,
1611         uint24 previousExtraData
1612     ) internal view virtual returns (uint24) {}
1613 
1614     /**
1615      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1616      * This includes minting.
1617      * And also called before burning one token.
1618      *
1619      * startTokenId - the first token id to be transferred
1620      * quantity - the amount to be transferred
1621      *
1622      * Calling conditions:
1623      *
1624      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1625      * transferred to `to`.
1626      * - When `from` is zero, `tokenId` will be minted for `to`.
1627      * - When `to` is zero, `tokenId` will be burned by `from`.
1628      * - `from` and `to` are never both zero.
1629      */
1630     function _beforeTokenTransfers(
1631         address from,
1632         address to,
1633         uint256 startTokenId,
1634         uint256 quantity
1635     ) internal virtual {}
1636 
1637     /**
1638      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1639      * This includes minting.
1640      * And also called after one token has been burned.
1641      *
1642      * startTokenId - the first token id to be transferred
1643      * quantity - the amount to be transferred
1644      *
1645      * Calling conditions:
1646      *
1647      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1648      * transferred to `to`.
1649      * - When `from` is zero, `tokenId` has been minted for `to`.
1650      * - When `to` is zero, `tokenId` has been burned by `from`.
1651      * - `from` and `to` are never both zero.
1652      */
1653     function _afterTokenTransfers(
1654         address from,
1655         address to,
1656         uint256 startTokenId,
1657         uint256 quantity
1658     ) internal virtual {}
1659 
1660     /**
1661      * @dev Returns the message sender (defaults to `msg.sender`).
1662      *
1663      * If you are writing GSN compatible contracts, you need to override this function.
1664      */
1665     function _msgSenderERC721A() internal view virtual returns (address) {
1666         return msg.sender;
1667     }
1668 
1669     /**
1670      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1671      */
1672     function _toString(uint256 value) internal pure returns (string memory ptr) {
1673         assembly {
1674             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1675             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1676             // We will need 1 32-byte word to store the length,
1677             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1678             ptr := add(mload(0x40), 128)
1679             // Update the free memory pointer to allocate.
1680             mstore(0x40, ptr)
1681 
1682             // Cache the end of the memory to calculate the length later.
1683             let end := ptr
1684 
1685             // We write the string from the rightmost digit to the leftmost digit.
1686             // The following is essentially a do-while loop that also handles the zero case.
1687             // Costs a bit more than early returning for the zero case,
1688             // but cheaper in terms of deployment and overall runtime costs.
1689             for {
1690                 // Initialize and perform the first pass without check.
1691                 let temp := value
1692                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1693                 ptr := sub(ptr, 1)
1694                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1695                 mstore8(ptr, add(48, mod(temp, 10)))
1696                 temp := div(temp, 10)
1697             } temp {
1698                 // Keep dividing `temp` until zero.
1699                 temp := div(temp, 10)
1700             } {
1701                 // Body of the for loop.
1702                 ptr := sub(ptr, 1)
1703                 mstore8(ptr, add(48, mod(temp, 10)))
1704             }
1705 
1706             let length := sub(end, ptr)
1707             // Move the pointer 32 bytes leftwards to make room for the length.
1708             ptr := sub(ptr, 32)
1709             // Store the length.
1710             mstore(ptr, length)
1711         }
1712     }
1713 }
1714 
1715 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1716 
1717 
1718 // ERC721A Contracts v4.1.0
1719 // Creator: Chiru Labs
1720 
1721 pragma solidity ^0.8.4;
1722 
1723 
1724 /**
1725  * @dev Interface of an ERC721AQueryable compliant contract.
1726  */
1727 interface IERC721AQueryable is IERC721A {
1728     /**
1729      * Invalid query range (`start` >= `stop`).
1730      */
1731     error InvalidQueryRange();
1732 
1733     /**
1734      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1735      *
1736      * If the `tokenId` is out of bounds:
1737      *   - `addr` = `address(0)`
1738      *   - `startTimestamp` = `0`
1739      *   - `burned` = `false`
1740      *
1741      * If the `tokenId` is burned:
1742      *   - `addr` = `<Address of owner before token was burned>`
1743      *   - `startTimestamp` = `<Timestamp when token was burned>`
1744      *   - `burned = `true`
1745      *
1746      * Otherwise:
1747      *   - `addr` = `<Address of owner>`
1748      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1749      *   - `burned = `false`
1750      */
1751     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1752 
1753     /**
1754      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1755      * See {ERC721AQueryable-explicitOwnershipOf}
1756      */
1757     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1758 
1759     /**
1760      * @dev Returns an array of token IDs owned by `owner`,
1761      * in the range [`start`, `stop`)
1762      * (i.e. `start <= tokenId < stop`).
1763      *
1764      * This function allows for tokens to be queried if the collection
1765      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1766      *
1767      * Requirements:
1768      *
1769      * - `start` < `stop`
1770      */
1771     function tokensOfOwnerIn(
1772         address owner,
1773         uint256 start,
1774         uint256 stop
1775     ) external view returns (uint256[] memory);
1776 
1777     /**
1778      * @dev Returns an array of token IDs owned by `owner`.
1779      *
1780      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1781      * It is meant to be called off-chain.
1782      *
1783      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1784      * multiple smaller scans if the collection is large enough to cause
1785      * an out-of-gas error (10K pfp collections should be fine).
1786      */
1787     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1788 }
1789 
1790 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1791 
1792 
1793 // ERC721A Contracts v4.1.0
1794 // Creator: Chiru Labs
1795 
1796 pragma solidity ^0.8.4;
1797 
1798 
1799 
1800 /**
1801  * @title ERC721A Queryable
1802  * @dev ERC721A subclass with convenience query functions.
1803  */
1804 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1805     /**
1806      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1807      *
1808      * If the `tokenId` is out of bounds:
1809      *   - `addr` = `address(0)`
1810      *   - `startTimestamp` = `0`
1811      *   - `burned` = `false`
1812      *   - `extraData` = `0`
1813      *
1814      * If the `tokenId` is burned:
1815      *   - `addr` = `<Address of owner before token was burned>`
1816      *   - `startTimestamp` = `<Timestamp when token was burned>`
1817      *   - `burned = `true`
1818      *   - `extraData` = `<Extra data when token was burned>`
1819      *
1820      * Otherwise:
1821      *   - `addr` = `<Address of owner>`
1822      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1823      *   - `burned = `false`
1824      *   - `extraData` = `<Extra data at start of ownership>`
1825      */
1826     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1827         TokenOwnership memory ownership;
1828         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1829             return ownership;
1830         }
1831         ownership = _ownershipAt(tokenId);
1832         if (ownership.burned) {
1833             return ownership;
1834         }
1835         return _ownershipOf(tokenId);
1836     }
1837 
1838     /**
1839      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1840      * See {ERC721AQueryable-explicitOwnershipOf}
1841      */
1842     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1843         unchecked {
1844             uint256 tokenIdsLength = tokenIds.length;
1845             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1846             for (uint256 i; i != tokenIdsLength; ++i) {
1847                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1848             }
1849             return ownerships;
1850         }
1851     }
1852 
1853     /**
1854      * @dev Returns an array of token IDs owned by `owner`,
1855      * in the range [`start`, `stop`)
1856      * (i.e. `start <= tokenId < stop`).
1857      *
1858      * This function allows for tokens to be queried if the collection
1859      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1860      *
1861      * Requirements:
1862      *
1863      * - `start` < `stop`
1864      */
1865     function tokensOfOwnerIn(
1866         address owner,
1867         uint256 start,
1868         uint256 stop
1869     ) external view override returns (uint256[] memory) {
1870         unchecked {
1871             if (start >= stop) revert InvalidQueryRange();
1872             uint256 tokenIdsIdx;
1873             uint256 stopLimit = _nextTokenId();
1874             // Set `start = max(start, _startTokenId())`.
1875             if (start < _startTokenId()) {
1876                 start = _startTokenId();
1877             }
1878             // Set `stop = min(stop, stopLimit)`.
1879             if (stop > stopLimit) {
1880                 stop = stopLimit;
1881             }
1882             uint256 tokenIdsMaxLength = balanceOf(owner);
1883             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1884             // to cater for cases where `balanceOf(owner)` is too big.
1885             if (start < stop) {
1886                 uint256 rangeLength = stop - start;
1887                 if (rangeLength < tokenIdsMaxLength) {
1888                     tokenIdsMaxLength = rangeLength;
1889                 }
1890             } else {
1891                 tokenIdsMaxLength = 0;
1892             }
1893             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1894             if (tokenIdsMaxLength == 0) {
1895                 return tokenIds;
1896             }
1897             // We need to call `explicitOwnershipOf(start)`,
1898             // because the slot at `start` may not be initialized.
1899             TokenOwnership memory ownership = explicitOwnershipOf(start);
1900             address currOwnershipAddr;
1901             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1902             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1903             if (!ownership.burned) {
1904                 currOwnershipAddr = ownership.addr;
1905             }
1906             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1907                 ownership = _ownershipAt(i);
1908                 if (ownership.burned) {
1909                     continue;
1910                 }
1911                 if (ownership.addr != address(0)) {
1912                     currOwnershipAddr = ownership.addr;
1913                 }
1914                 if (currOwnershipAddr == owner) {
1915                     tokenIds[tokenIdsIdx++] = i;
1916                 }
1917             }
1918             // Downsize the array to fit.
1919             assembly {
1920                 mstore(tokenIds, tokenIdsIdx)
1921             }
1922             return tokenIds;
1923         }
1924     }
1925 
1926     /**
1927      * @dev Returns an array of token IDs owned by `owner`.
1928      *
1929      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1930      * It is meant to be called off-chain.
1931      *
1932      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1933      * multiple smaller scans if the collection is large enough to cause
1934      * an out-of-gas error (10K pfp collections should be fine).
1935      */
1936     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1937         unchecked {
1938             uint256 tokenIdsIdx;
1939             address currOwnershipAddr;
1940             uint256 tokenIdsLength = balanceOf(owner);
1941             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1942             TokenOwnership memory ownership;
1943             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1944                 ownership = _ownershipAt(i);
1945                 if (ownership.burned) {
1946                     continue;
1947                 }
1948                 if (ownership.addr != address(0)) {
1949                     currOwnershipAddr = ownership.addr;
1950                 }
1951                 if (currOwnershipAddr == owner) {
1952                     tokenIds[tokenIdsIdx++] = i;
1953                 }
1954             }
1955             return tokenIds;
1956         }
1957     }
1958 }
1959 
1960 // File: contracts/3DBirds.sol
1961 
1962 
1963 
1964 
1965 
1966 pragma solidity >=0.8.9 <0.9.0;
1967 
1968 
1969 
1970 
1971 
1972 
1973 
1974 contract Birds3D is ERC721AQueryable, Ownable, ReentrancyGuard {
1975     using Strings for uint256;
1976 
1977     //Initial Settings ->
1978     string public tokenName = "3D Birds";
1979     string public tokenSymbol = "3DB";
1980     uint256 public maxSupply = 10000;
1981     uint256 public maxReservedSupply = 200;
1982     uint256 public reservedSupplyMinted = 0;
1983     
1984     uint256 public firstWaveSupply = 2700;
1985     
1986     uint256 public firstWavePrice = 0;
1987     uint256 public secondWavePrice = 0.03 ether;
1988 
1989     uint256 public wlMintAmount = 1;
1990     uint256 public firstWaveMaxMint = 1;
1991     uint256 public secondWaveMaxMint = 5;
1992 
1993     bytes32 public merkleRoot;
1994     mapping(address => uint256) public usersMinted;
1995 
1996     bool public paused = true;
1997     bool public whitelistMintEnabled = true;
1998     bool public revealed = false;
1999 
2000     string public uriPrefix = '';
2001     string public uriSuffix = '.json';
2002     string public hiddenMetadataUri = "";
2003 
2004     constructor(string memory _hiddenMetadataUri) ERC721A(tokenName, tokenSymbol) {
2005         setHiddenMetadataUri(_hiddenMetadataUri);
2006     }
2007 
2008     modifier mintCompliance(uint256 _mintAmount) {
2009         uint256 currentSupply = totalSupply();
2010         if (currentSupply < firstWaveSupply) {
2011             require(
2012                 _mintAmount > 0 &&
2013                 usersMinted[_msgSender()] + _mintAmount <= firstWaveMaxMint,
2014                 'Too much mint in first wave'
2015             );
2016         }
2017         else {
2018             require(
2019                 _mintAmount > 0 &&
2020                 usersMinted[msg.sender] + _mintAmount <= secondWaveMaxMint,
2021                 'Too much mint in second wave'
2022             );
2023             require(msg.value >= _mintAmount * secondWavePrice, 'Insufficient funds!');
2024         }
2025         _;
2026     }
2027 
2028     modifier whenWLActive() {
2029         require(whitelistMintEnabled == true, 'Whitelist disabled');
2030         _;
2031     }
2032 
2033     modifier whenPublicActive() {
2034         require(whitelistMintEnabled == false, 'Public disabled');
2035         _;
2036     }
2037 
2038     modifier noContract() {
2039         // i <3 @terncrypto
2040         require(tx.origin == msg.sender, 'Contract mint not allowed');
2041         // user221 write to me...
2042         _;
2043     }
2044 
2045     function mintPublic(uint256 _mintAmount) public payable mintCompliance(_mintAmount) whenPublicActive noContract {
2046         require(!paused, 'The contract is paused!');
2047         require(totalSupply() + _mintAmount <= (maxSupply - maxReservedSupply + reservedSupplyMinted), 'Max supply exceeded!');
2048 
2049         usersMinted[_msgSender()] += _mintAmount;
2050 
2051         _safeMint(_msgSender(), _mintAmount);
2052     }
2053 
2054     function mintWhitelist(bytes32[] calldata _merkleProof) public whenWLActive {
2055         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2056         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
2057 
2058         require(!paused, 'The contract is paused!');
2059         require(usersMinted[_msgSender()] < wlMintAmount, 'You already minted WL');
2060         require(totalSupply() + 1 <= (maxSupply - maxReservedSupply + reservedSupplyMinted), 'Max supply exceeded!');
2061 
2062         usersMinted[_msgSender()] += wlMintAmount;
2063 
2064         _safeMint(_msgSender(), wlMintAmount);
2065     }
2066 
2067     function mintOwner(uint256 _mintAmount, address _receiver) public onlyOwner {
2068         require(reservedSupplyMinted + _mintAmount <= maxReservedSupply, 'Max reserved supply reached');
2069         require((totalSupply() + _mintAmount) <= maxSupply, 'Max supply exceeded!');
2070         
2071         reservedSupplyMinted += _mintAmount;
2072 
2073         _safeMint(_receiver, _mintAmount);
2074     }
2075 
2076     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2077         require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2078 
2079         if (revealed == false) {
2080             return hiddenMetadataUri;
2081         }
2082 
2083         string memory currentBaseURI = _baseURI();
2084         return bytes(currentBaseURI).length > 0
2085         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2086         : '';
2087     }
2088 
2089     function setPaused(bool _state) public onlyOwner {
2090         paused = _state;
2091     }
2092 
2093     function setFirstWaveSupply(uint256 _value) public onlyOwner {
2094         require(_value + maxReservedSupply <= maxSupply, 'Max supply exceeded!');
2095         firstWaveSupply = _value;
2096     }
2097 
2098     function setFirstWaveMaxMint(uint256 _value) public onlyOwner {
2099         firstWaveMaxMint = _value;
2100     }
2101 
2102     function setFirstWavePrice(uint256 _value) public onlyOwner {
2103         firstWavePrice = _value;
2104     }
2105 
2106     function setSecondWaveMaxMint(uint256 _value) public onlyOwner {
2107         secondWaveMaxMint = _value;
2108     }
2109 
2110     function setSecondWavePrice(uint256 _value) public onlyOwner {
2111         secondWavePrice = _value;
2112     }
2113 
2114     function setRevealed(bool _state) public onlyOwner {
2115         revealed = _state;
2116     }
2117 
2118     function setMaxReservedSupply(uint256 _newMaxReservedSupply) public onlyOwner {
2119         require(_newMaxReservedSupply <= (maxSupply - totalSupply()), 'Max supply exceeded!');
2120         maxReservedSupply = _newMaxReservedSupply;
2121     }
2122 
2123     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2124         hiddenMetadataUri = _hiddenMetadataUri;
2125     }
2126 
2127     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2128         uriPrefix = _uriPrefix;
2129     }
2130 
2131     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2132         uriSuffix = _uriSuffix;
2133     }
2134 
2135     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2136         merkleRoot = _merkleRoot;
2137     }
2138 
2139     function setWhitelistMintEnabled(bool _state) public onlyOwner {
2140         whitelistMintEnabled = _state;
2141     }
2142 
2143     function withdraw() public onlyOwner nonReentrant {
2144         (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2145         require(os);
2146     }
2147 
2148     // Internal ->
2149     function _startTokenId() internal view virtual override returns (uint256) {
2150         return 1;
2151     }
2152 
2153     function _baseURI() internal view virtual override returns (string memory) {
2154         return uriPrefix;
2155     }
2156 }