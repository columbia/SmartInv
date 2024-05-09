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
79 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
80 
81 
82 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev Contract module that helps prevent reentrant calls to a function.
88  *
89  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
90  * available, which can be applied to functions to make sure there are no nested
91  * (reentrant) calls to them.
92  *
93  * Note that because there is a single `nonReentrant` guard, functions marked as
94  * `nonReentrant` may not call one another. This can be worked around by making
95  * those functions `private`, and then adding `external` `nonReentrant` entry
96  * points to them.
97  *
98  * TIP: If you would like to learn more about reentrancy and alternative ways
99  * to protect against it, check out our blog post
100  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
101  */
102 abstract contract ReentrancyGuard {
103     // Booleans are more expensive than uint256 or any type that takes up a full
104     // word because each write operation emits an extra SLOAD to first read the
105     // slot's contents, replace the bits taken up by the boolean, and then write
106     // back. This is the compiler's defense against contract upgrades and
107     // pointer aliasing, and it cannot be disabled.
108 
109     // The values being non-zero value makes deployment a bit more expensive,
110     // but in exchange the refund on every call to nonReentrant will be lower in
111     // amount. Since refunds are capped to a percentage of the total
112     // transaction's gas, it is best to keep them low in cases like this one, to
113     // increase the likelihood of the full refund coming into effect.
114     uint256 private constant _NOT_ENTERED = 1;
115     uint256 private constant _ENTERED = 2;
116 
117     uint256 private _status;
118 
119     constructor() {
120         _status = _NOT_ENTERED;
121     }
122 
123     /**
124      * @dev Prevents a contract from calling itself, directly or indirectly.
125      * Calling a `nonReentrant` function from another `nonReentrant`
126      * function is not supported. It is possible to prevent this from happening
127      * by making the `nonReentrant` function external, and making it call a
128      * `private` function that does the actual work.
129      */
130     modifier nonReentrant() {
131         // On the first call to nonReentrant, _notEntered will be true
132         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
133 
134         // Any calls to nonReentrant after this point will fail
135         _status = _ENTERED;
136 
137         _;
138 
139         // By storing the original value once again, a refund is triggered (see
140         // https://eips.ethereum.org/EIPS/eip-2200)
141         _status = _NOT_ENTERED;
142     }
143 }
144 
145 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
146 
147 
148 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev These functions deal with verification of Merkle Tree proofs.
154  *
155  * The proofs can be generated using the JavaScript library
156  * https://github.com/miguelmota/merkletreejs[merkletreejs].
157  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
158  *
159  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
160  *
161  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
162  * hashing, or use a hash function other than keccak256 for hashing leaves.
163  * This is because the concatenation of a sorted pair of internal nodes in
164  * the merkle tree could be reinterpreted as a leaf value.
165  */
166 library MerkleProof {
167     /**
168      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
169      * defined by `root`. For this, a `proof` must be provided, containing
170      * sibling hashes on the branch from the leaf to the root of the tree. Each
171      * pair of leaves and each pair of pre-images are assumed to be sorted.
172      */
173     function verify(
174         bytes32[] memory proof,
175         bytes32 root,
176         bytes32 leaf
177     ) internal pure returns (bool) {
178         return processProof(proof, leaf) == root;
179     }
180 
181     /**
182      * @dev Calldata version of {verify}
183      *
184      * _Available since v4.7._
185      */
186     function verifyCalldata(
187         bytes32[] calldata proof,
188         bytes32 root,
189         bytes32 leaf
190     ) internal pure returns (bool) {
191         return processProofCalldata(proof, leaf) == root;
192     }
193 
194     /**
195      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
196      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
197      * hash matches the root of the tree. When processing the proof, the pairs
198      * of leafs & pre-images are assumed to be sorted.
199      *
200      * _Available since v4.4._
201      */
202     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
203         bytes32 computedHash = leaf;
204         for (uint256 i = 0; i < proof.length; i++) {
205             computedHash = _hashPair(computedHash, proof[i]);
206         }
207         return computedHash;
208     }
209 
210     /**
211      * @dev Calldata version of {processProof}
212      *
213      * _Available since v4.7._
214      */
215     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
216         bytes32 computedHash = leaf;
217         for (uint256 i = 0; i < proof.length; i++) {
218             computedHash = _hashPair(computedHash, proof[i]);
219         }
220         return computedHash;
221     }
222 
223     /**
224      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
225      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
226      *
227      * _Available since v4.7._
228      */
229     function multiProofVerify(
230         bytes32[] memory proof,
231         bool[] memory proofFlags,
232         bytes32 root,
233         bytes32[] memory leaves
234     ) internal pure returns (bool) {
235         return processMultiProof(proof, proofFlags, leaves) == root;
236     }
237 
238     /**
239      * @dev Calldata version of {multiProofVerify}
240      *
241      * _Available since v4.7._
242      */
243     function multiProofVerifyCalldata(
244         bytes32[] calldata proof,
245         bool[] calldata proofFlags,
246         bytes32 root,
247         bytes32[] memory leaves
248     ) internal pure returns (bool) {
249         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
250     }
251 
252     /**
253      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
254      * consuming from one or the other at each step according to the instructions given by
255      * `proofFlags`.
256      *
257      * _Available since v4.7._
258      */
259     function processMultiProof(
260         bytes32[] memory proof,
261         bool[] memory proofFlags,
262         bytes32[] memory leaves
263     ) internal pure returns (bytes32 merkleRoot) {
264         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
265         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
266         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
267         // the merkle tree.
268         uint256 leavesLen = leaves.length;
269         uint256 totalHashes = proofFlags.length;
270 
271         // Check proof validity.
272         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
273 
274         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
275         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
276         bytes32[] memory hashes = new bytes32[](totalHashes);
277         uint256 leafPos = 0;
278         uint256 hashPos = 0;
279         uint256 proofPos = 0;
280         // At each step, we compute the next hash using two values:
281         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
282         //   get the next hash.
283         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
284         //   `proof` array.
285         for (uint256 i = 0; i < totalHashes; i++) {
286             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
287             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
288             hashes[i] = _hashPair(a, b);
289         }
290 
291         if (totalHashes > 0) {
292             return hashes[totalHashes - 1];
293         } else if (leavesLen > 0) {
294             return leaves[0];
295         } else {
296             return proof[0];
297         }
298     }
299 
300     /**
301      * @dev Calldata version of {processMultiProof}
302      *
303      * _Available since v4.7._
304      */
305     function processMultiProofCalldata(
306         bytes32[] calldata proof,
307         bool[] calldata proofFlags,
308         bytes32[] memory leaves
309     ) internal pure returns (bytes32 merkleRoot) {
310         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
311         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
312         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
313         // the merkle tree.
314         uint256 leavesLen = leaves.length;
315         uint256 totalHashes = proofFlags.length;
316 
317         // Check proof validity.
318         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
319 
320         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
321         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
322         bytes32[] memory hashes = new bytes32[](totalHashes);
323         uint256 leafPos = 0;
324         uint256 hashPos = 0;
325         uint256 proofPos = 0;
326         // At each step, we compute the next hash using two values:
327         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
328         //   get the next hash.
329         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
330         //   `proof` array.
331         for (uint256 i = 0; i < totalHashes; i++) {
332             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
333             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
334             hashes[i] = _hashPair(a, b);
335         }
336 
337         if (totalHashes > 0) {
338             return hashes[totalHashes - 1];
339         } else if (leavesLen > 0) {
340             return leaves[0];
341         } else {
342             return proof[0];
343         }
344     }
345 
346     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
347         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
348     }
349 
350     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
351         /// @solidity memory-safe-assembly
352         assembly {
353             mstore(0x00, a)
354             mstore(0x20, b)
355             value := keccak256(0x00, 0x40)
356         }
357     }
358 }
359 
360 // File: @openzeppelin/contracts/utils/Context.sol
361 
362 
363 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 /**
368  * @dev Provides information about the current execution context, including the
369  * sender of the transaction and its data. While these are generally available
370  * via msg.sender and msg.data, they should not be accessed in such a direct
371  * manner, since when dealing with meta-transactions the account sending and
372  * paying for execution may not be the actual sender (as far as an application
373  * is concerned).
374  *
375  * This contract is only required for intermediate, library-like contracts.
376  */
377 abstract contract Context {
378     function _msgSender() internal view virtual returns (address) {
379         return msg.sender;
380     }
381 
382     function _msgData() internal view virtual returns (bytes calldata) {
383         return msg.data;
384     }
385 }
386 
387 // File: @openzeppelin/contracts/access/Ownable.sol
388 
389 
390 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 
395 /**
396  * @dev Contract module which provides a basic access control mechanism, where
397  * there is an account (an owner) that can be granted exclusive access to
398  * specific functions.
399  *
400  * By default, the owner account will be the one that deploys the contract. This
401  * can later be changed with {transferOwnership}.
402  *
403  * This module is used through inheritance. It will make available the modifier
404  * `onlyOwner`, which can be applied to your functions to restrict their use to
405  * the owner.
406  */
407 abstract contract Ownable is Context {
408     address private _owner;
409 
410     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
411 
412     /**
413      * @dev Initializes the contract setting the deployer as the initial owner.
414      */
415     constructor() {
416         _transferOwnership(_msgSender());
417     }
418 
419     /**
420      * @dev Throws if called by any account other than the owner.
421      */
422     modifier onlyOwner() {
423         _checkOwner();
424         _;
425     }
426 
427     /**
428      * @dev Returns the address of the current owner.
429      */
430     function owner() public view virtual returns (address) {
431         return _owner;
432     }
433 
434     /**
435      * @dev Throws if the sender is not the owner.
436      */
437     function _checkOwner() internal view virtual {
438         require(owner() == _msgSender(), "Ownable: caller is not the owner");
439     }
440 
441     /**
442      * @dev Leaves the contract without owner. It will not be possible to call
443      * `onlyOwner` functions anymore. Can only be called by the current owner.
444      *
445      * NOTE: Renouncing ownership will leave the contract without an owner,
446      * thereby removing any functionality that is only available to the owner.
447      */
448     function renounceOwnership() public virtual onlyOwner {
449         _transferOwnership(address(0));
450     }
451 
452     /**
453      * @dev Transfers ownership of the contract to a new account (`newOwner`).
454      * Can only be called by the current owner.
455      */
456     function transferOwnership(address newOwner) public virtual onlyOwner {
457         require(newOwner != address(0), "Ownable: new owner is the zero address");
458         _transferOwnership(newOwner);
459     }
460 
461     /**
462      * @dev Transfers ownership of the contract to a new account (`newOwner`).
463      * Internal function without access restriction.
464      */
465     function _transferOwnership(address newOwner) internal virtual {
466         address oldOwner = _owner;
467         _owner = newOwner;
468         emit OwnershipTransferred(oldOwner, newOwner);
469     }
470 }
471 
472 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
473 
474 
475 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 /**
480  * @dev Interface of the ERC20 standard as defined in the EIP.
481  */
482 interface IERC20 {
483     /**
484      * @dev Emitted when `value` tokens are moved from one account (`from`) to
485      * another (`to`).
486      *
487      * Note that `value` may be zero.
488      */
489     event Transfer(address indexed from, address indexed to, uint256 value);
490 
491     /**
492      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
493      * a call to {approve}. `value` is the new allowance.
494      */
495     event Approval(address indexed owner, address indexed spender, uint256 value);
496 
497     /**
498      * @dev Returns the amount of tokens in existence.
499      */
500     function totalSupply() external view returns (uint256);
501 
502     /**
503      * @dev Returns the amount of tokens owned by `account`.
504      */
505     function balanceOf(address account) external view returns (uint256);
506 
507     /**
508      * @dev Moves `amount` tokens from the caller's account to `to`.
509      *
510      * Returns a boolean value indicating whether the operation succeeded.
511      *
512      * Emits a {Transfer} event.
513      */
514     function transfer(address to, uint256 amount) external returns (bool);
515 
516     /**
517      * @dev Returns the remaining number of tokens that `spender` will be
518      * allowed to spend on behalf of `owner` through {transferFrom}. This is
519      * zero by default.
520      *
521      * This value changes when {approve} or {transferFrom} are called.
522      */
523     function allowance(address owner, address spender) external view returns (uint256);
524 
525     /**
526      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
527      *
528      * Returns a boolean value indicating whether the operation succeeded.
529      *
530      * IMPORTANT: Beware that changing an allowance with this method brings the risk
531      * that someone may use both the old and the new allowance by unfortunate
532      * transaction ordering. One possible solution to mitigate this race
533      * condition is to first reduce the spender's allowance to 0 and set the
534      * desired value afterwards:
535      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
536      *
537      * Emits an {Approval} event.
538      */
539     function approve(address spender, uint256 amount) external returns (bool);
540 
541     /**
542      * @dev Moves `amount` tokens from `from` to `to` using the
543      * allowance mechanism. `amount` is then deducted from the caller's
544      * allowance.
545      *
546      * Returns a boolean value indicating whether the operation succeeded.
547      *
548      * Emits a {Transfer} event.
549      */
550     function transferFrom(
551         address from,
552         address to,
553         uint256 amount
554     ) external returns (bool);
555 }
556 
557 // File: erc721a/contracts/IERC721A.sol
558 
559 
560 // ERC721A Contracts v4.1.0
561 // Creator: Chiru Labs
562 
563 pragma solidity ^0.8.4;
564 
565 /**
566  * @dev Interface of an ERC721A compliant contract.
567  */
568 interface IERC721A {
569     /**
570      * The caller must own the token or be an approved operator.
571      */
572     error ApprovalCallerNotOwnerNorApproved();
573 
574     /**
575      * The token does not exist.
576      */
577     error ApprovalQueryForNonexistentToken();
578 
579     /**
580      * The caller cannot approve to their own address.
581      */
582     error ApproveToCaller();
583 
584     /**
585      * Cannot query the balance for the zero address.
586      */
587     error BalanceQueryForZeroAddress();
588 
589     /**
590      * Cannot mint to the zero address.
591      */
592     error MintToZeroAddress();
593 
594     /**
595      * The quantity of tokens minted must be more than zero.
596      */
597     error MintZeroQuantity();
598 
599     /**
600      * The token does not exist.
601      */
602     error OwnerQueryForNonexistentToken();
603 
604     /**
605      * The caller must own the token or be an approved operator.
606      */
607     error TransferCallerNotOwnerNorApproved();
608 
609     /**
610      * The token must be owned by `from`.
611      */
612     error TransferFromIncorrectOwner();
613 
614     /**
615      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
616      */
617     error TransferToNonERC721ReceiverImplementer();
618 
619     /**
620      * Cannot transfer to the zero address.
621      */
622     error TransferToZeroAddress();
623 
624     /**
625      * The token does not exist.
626      */
627     error URIQueryForNonexistentToken();
628 
629     /**
630      * The `quantity` minted with ERC2309 exceeds the safety limit.
631      */
632     error MintERC2309QuantityExceedsLimit();
633 
634     /**
635      * The `extraData` cannot be set on an unintialized ownership slot.
636      */
637     error OwnershipNotInitializedForExtraData();
638 
639     struct TokenOwnership {
640         // The address of the owner.
641         address addr;
642         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
643         uint64 startTimestamp;
644         // Whether the token has been burned.
645         bool burned;
646         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
647         uint24 extraData;
648     }
649 
650     /**
651      * @dev Returns the total amount of tokens stored by the contract.
652      *
653      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
654      */
655     function totalSupply() external view returns (uint256);
656 
657     // ==============================
658     //            IERC165
659     // ==============================
660 
661     /**
662      * @dev Returns true if this contract implements the interface defined by
663      * `interfaceId`. See the corresponding
664      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
665      * to learn more about how these ids are created.
666      *
667      * This function call must use less than 30 000 gas.
668      */
669     function supportsInterface(bytes4 interfaceId) external view returns (bool);
670 
671     // ==============================
672     //            IERC721
673     // ==============================
674 
675     /**
676      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
677      */
678     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
679 
680     /**
681      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
682      */
683     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
684 
685     /**
686      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
687      */
688     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
689 
690     /**
691      * @dev Returns the number of tokens in ``owner``'s account.
692      */
693     function balanceOf(address owner) external view returns (uint256 balance);
694 
695     /**
696      * @dev Returns the owner of the `tokenId` token.
697      *
698      * Requirements:
699      *
700      * - `tokenId` must exist.
701      */
702     function ownerOf(uint256 tokenId) external view returns (address owner);
703 
704     /**
705      * @dev Safely transfers `tokenId` token from `from` to `to`.
706      *
707      * Requirements:
708      *
709      * - `from` cannot be the zero address.
710      * - `to` cannot be the zero address.
711      * - `tokenId` token must exist and be owned by `from`.
712      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
713      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
714      *
715      * Emits a {Transfer} event.
716      */
717     function safeTransferFrom(
718         address from,
719         address to,
720         uint256 tokenId,
721         bytes calldata data
722     ) external;
723 
724     /**
725      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
726      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
727      *
728      * Requirements:
729      *
730      * - `from` cannot be the zero address.
731      * - `to` cannot be the zero address.
732      * - `tokenId` token must exist and be owned by `from`.
733      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
734      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
735      *
736      * Emits a {Transfer} event.
737      */
738     function safeTransferFrom(
739         address from,
740         address to,
741         uint256 tokenId
742     ) external;
743 
744     /**
745      * @dev Transfers `tokenId` token from `from` to `to`.
746      *
747      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
748      *
749      * Requirements:
750      *
751      * - `from` cannot be the zero address.
752      * - `to` cannot be the zero address.
753      * - `tokenId` token must be owned by `from`.
754      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
755      *
756      * Emits a {Transfer} event.
757      */
758     function transferFrom(
759         address from,
760         address to,
761         uint256 tokenId
762     ) external;
763 
764     /**
765      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
766      * The approval is cleared when the token is transferred.
767      *
768      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
769      *
770      * Requirements:
771      *
772      * - The caller must own the token or be an approved operator.
773      * - `tokenId` must exist.
774      *
775      * Emits an {Approval} event.
776      */
777     function approve(address to, uint256 tokenId) external;
778 
779     /**
780      * @dev Approve or remove `operator` as an operator for the caller.
781      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
782      *
783      * Requirements:
784      *
785      * - The `operator` cannot be the caller.
786      *
787      * Emits an {ApprovalForAll} event.
788      */
789     function setApprovalForAll(address operator, bool _approved) external;
790 
791     /**
792      * @dev Returns the account approved for `tokenId` token.
793      *
794      * Requirements:
795      *
796      * - `tokenId` must exist.
797      */
798     function getApproved(uint256 tokenId) external view returns (address operator);
799 
800     /**
801      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
802      *
803      * See {setApprovalForAll}
804      */
805     function isApprovedForAll(address owner, address operator) external view returns (bool);
806 
807     // ==============================
808     //        IERC721Metadata
809     // ==============================
810 
811     /**
812      * @dev Returns the token collection name.
813      */
814     function name() external view returns (string memory);
815 
816     /**
817      * @dev Returns the token collection symbol.
818      */
819     function symbol() external view returns (string memory);
820 
821     /**
822      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
823      */
824     function tokenURI(uint256 tokenId) external view returns (string memory);
825 
826     // ==============================
827     //            IERC2309
828     // ==============================
829 
830     /**
831      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
832      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
833      */
834     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
835 }
836 
837 // File: erc721a/contracts/ERC721A.sol
838 
839 
840 // ERC721A Contracts v4.1.0
841 // Creator: Chiru Labs
842 
843 pragma solidity ^0.8.4;
844 
845 
846 /**
847  * @dev ERC721 token receiver interface.
848  */
849 interface ERC721A__IERC721Receiver {
850     function onERC721Received(
851         address operator,
852         address from,
853         uint256 tokenId,
854         bytes calldata data
855     ) external returns (bytes4);
856 }
857 
858 /**
859  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
860  * including the Metadata extension. Built to optimize for lower gas during batch mints.
861  *
862  * Assumes serials are sequentially minted starting at `_startTokenId()`
863  * (defaults to 0, e.g. 0, 1, 2, 3..).
864  *
865  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
866  *
867  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
868  */
869 contract ERC721A is IERC721A {
870     // Mask of an entry in packed address data.
871     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
872 
873     // The bit position of `numberMinted` in packed address data.
874     uint256 private constant BITPOS_NUMBER_MINTED = 64;
875 
876     // The bit position of `numberBurned` in packed address data.
877     uint256 private constant BITPOS_NUMBER_BURNED = 128;
878 
879     // The bit position of `aux` in packed address data.
880     uint256 private constant BITPOS_AUX = 192;
881 
882     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
883     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
884 
885     // The bit position of `startTimestamp` in packed ownership.
886     uint256 private constant BITPOS_START_TIMESTAMP = 160;
887 
888     // The bit mask of the `burned` bit in packed ownership.
889     uint256 private constant BITMASK_BURNED = 1 << 224;
890 
891     // The bit position of the `nextInitialized` bit in packed ownership.
892     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
893 
894     // The bit mask of the `nextInitialized` bit in packed ownership.
895     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
896 
897     // The bit position of `extraData` in packed ownership.
898     uint256 private constant BITPOS_EXTRA_DATA = 232;
899 
900     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
901     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
902 
903     // The mask of the lower 160 bits for addresses.
904     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
905 
906     // The maximum `quantity` that can be minted with `_mintERC2309`.
907     // This limit is to prevent overflows on the address data entries.
908     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
909     // is required to cause an overflow, which is unrealistic.
910     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
911 
912     // The tokenId of the next token to be minted.
913     uint256 private _currentIndex;
914 
915     // The number of tokens burned.
916     uint256 private _burnCounter;
917 
918     // Token name
919     string private _name;
920 
921     // Token symbol
922     string private _symbol;
923 
924     // Mapping from token ID to ownership details
925     // An empty struct value does not necessarily mean the token is unowned.
926     // See `_packedOwnershipOf` implementation for details.
927     //
928     // Bits Layout:
929     // - [0..159]   `addr`
930     // - [160..223] `startTimestamp`
931     // - [224]      `burned`
932     // - [225]      `nextInitialized`
933     // - [232..255] `extraData`
934     mapping(uint256 => uint256) private _packedOwnerships;
935 
936     // Mapping owner address to address data.
937     //
938     // Bits Layout:
939     // - [0..63]    `balance`
940     // - [64..127]  `numberMinted`
941     // - [128..191] `numberBurned`
942     // - [192..255] `aux`
943     mapping(address => uint256) private _packedAddressData;
944 
945     // Mapping from token ID to approved address.
946     mapping(uint256 => address) private _tokenApprovals;
947 
948     // Mapping from owner to operator approvals
949     mapping(address => mapping(address => bool)) private _operatorApprovals;
950 
951     constructor(string memory name_, string memory symbol_) {
952         _name = name_;
953         _symbol = symbol_;
954         _currentIndex = _startTokenId();
955     }
956 
957     /**
958      * @dev Returns the starting token ID.
959      * To change the starting token ID, please override this function.
960      */
961     function _startTokenId() internal view virtual returns (uint256) {
962         return 0;
963     }
964 
965     /**
966      * @dev Returns the next token ID to be minted.
967      */
968     function _nextTokenId() internal view returns (uint256) {
969         return _currentIndex;
970     }
971 
972     /**
973      * @dev Returns the total number of tokens in existence.
974      * Burned tokens will reduce the count.
975      * To get the total number of tokens minted, please see `_totalMinted`.
976      */
977     function totalSupply() public view override returns (uint256) {
978         // Counter underflow is impossible as _burnCounter cannot be incremented
979         // more than `_currentIndex - _startTokenId()` times.
980         unchecked {
981             return _currentIndex - _burnCounter - _startTokenId();
982         }
983     }
984 
985     /**
986      * @dev Returns the total amount of tokens minted in the contract.
987      */
988     function _totalMinted() internal view returns (uint256) {
989         // Counter underflow is impossible as _currentIndex does not decrement,
990         // and it is initialized to `_startTokenId()`
991         unchecked {
992             return _currentIndex - _startTokenId();
993         }
994     }
995 
996     /**
997      * @dev Returns the total number of tokens burned.
998      */
999     function _totalBurned() internal view returns (uint256) {
1000         return _burnCounter;
1001     }
1002 
1003     /**
1004      * @dev See {IERC165-supportsInterface}.
1005      */
1006     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1007         // The interface IDs are constants representing the first 4 bytes of the XOR of
1008         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1009         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1010         return
1011             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1012             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1013             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-balanceOf}.
1018      */
1019     function balanceOf(address owner) public view override returns (uint256) {
1020         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1021         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
1022     }
1023 
1024     /**
1025      * Returns the number of tokens minted by `owner`.
1026      */
1027     function _numberMinted(address owner) internal view returns (uint256) {
1028         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
1029     }
1030 
1031     /**
1032      * Returns the number of tokens burned by or on behalf of `owner`.
1033      */
1034     function _numberBurned(address owner) internal view returns (uint256) {
1035         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
1036     }
1037 
1038     /**
1039      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1040      */
1041     function _getAux(address owner) internal view returns (uint64) {
1042         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1043     }
1044 
1045     /**
1046      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1047      * If there are multiple variables, please pack them into a uint64.
1048      */
1049     function _setAux(address owner, uint64 aux) internal {
1050         uint256 packed = _packedAddressData[owner];
1051         uint256 auxCasted;
1052         // Cast `aux` with assembly to avoid redundant masking.
1053         assembly {
1054             auxCasted := aux
1055         }
1056         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1057         _packedAddressData[owner] = packed;
1058     }
1059 
1060     /**
1061      * Returns the packed ownership data of `tokenId`.
1062      */
1063     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1064         uint256 curr = tokenId;
1065 
1066         unchecked {
1067             if (_startTokenId() <= curr)
1068                 if (curr < _currentIndex) {
1069                     uint256 packed = _packedOwnerships[curr];
1070                     // If not burned.
1071                     if (packed & BITMASK_BURNED == 0) {
1072                         // Invariant:
1073                         // There will always be an ownership that has an address and is not burned
1074                         // before an ownership that does not have an address and is not burned.
1075                         // Hence, curr will not underflow.
1076                         //
1077                         // We can directly compare the packed value.
1078                         // If the address is zero, packed is zero.
1079                         while (packed == 0) {
1080                             packed = _packedOwnerships[--curr];
1081                         }
1082                         return packed;
1083                     }
1084                 }
1085         }
1086         revert OwnerQueryForNonexistentToken();
1087     }
1088 
1089     /**
1090      * Returns the unpacked `TokenOwnership` struct from `packed`.
1091      */
1092     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1093         ownership.addr = address(uint160(packed));
1094         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1095         ownership.burned = packed & BITMASK_BURNED != 0;
1096         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1097     }
1098 
1099     /**
1100      * Returns the unpacked `TokenOwnership` struct at `index`.
1101      */
1102     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1103         return _unpackedOwnership(_packedOwnerships[index]);
1104     }
1105 
1106     /**
1107      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1108      */
1109     function _initializeOwnershipAt(uint256 index) internal {
1110         if (_packedOwnerships[index] == 0) {
1111             _packedOwnerships[index] = _packedOwnershipOf(index);
1112         }
1113     }
1114 
1115     /**
1116      * Gas spent here starts off proportional to the maximum mint batch size.
1117      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1118      */
1119     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1120         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1121     }
1122 
1123     /**
1124      * @dev Packs ownership data into a single uint256.
1125      */
1126     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1127         assembly {
1128             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1129             owner := and(owner, BITMASK_ADDRESS)
1130             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1131             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1132         }
1133     }
1134 
1135     /**
1136      * @dev See {IERC721-ownerOf}.
1137      */
1138     function ownerOf(uint256 tokenId) public view override returns (address) {
1139         return address(uint160(_packedOwnershipOf(tokenId)));
1140     }
1141 
1142     /**
1143      * @dev See {IERC721Metadata-name}.
1144      */
1145     function name() public view virtual override returns (string memory) {
1146         return _name;
1147     }
1148 
1149     /**
1150      * @dev See {IERC721Metadata-symbol}.
1151      */
1152     function symbol() public view virtual override returns (string memory) {
1153         return _symbol;
1154     }
1155 
1156     /**
1157      * @dev See {IERC721Metadata-tokenURI}.
1158      */
1159     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1160         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1161 
1162         string memory baseURI = _baseURI();
1163         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1164     }
1165 
1166     /**
1167      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1168      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1169      * by default, it can be overridden in child contracts.
1170      */
1171     function _baseURI() internal view virtual returns (string memory) {
1172         return '';
1173     }
1174 
1175     /**
1176      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1177      */
1178     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1179         // For branchless setting of the `nextInitialized` flag.
1180         assembly {
1181             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1182             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1183         }
1184     }
1185 
1186     /**
1187      * @dev See {IERC721-approve}.
1188      */
1189     function approve(address to, uint256 tokenId) public override {
1190         address owner = ownerOf(tokenId);
1191 
1192         if (_msgSenderERC721A() != owner)
1193             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1194                 revert ApprovalCallerNotOwnerNorApproved();
1195             }
1196 
1197         _tokenApprovals[tokenId] = to;
1198         emit Approval(owner, to, tokenId);
1199     }
1200 
1201     /**
1202      * @dev See {IERC721-getApproved}.
1203      */
1204     function getApproved(uint256 tokenId) public view override returns (address) {
1205         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1206 
1207         return _tokenApprovals[tokenId];
1208     }
1209 
1210     /**
1211      * @dev See {IERC721-setApprovalForAll}.
1212      */
1213     function setApprovalForAll(address operator, bool approved) public virtual override {
1214         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1215 
1216         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1217         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1218     }
1219 
1220     /**
1221      * @dev See {IERC721-isApprovedForAll}.
1222      */
1223     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1224         return _operatorApprovals[owner][operator];
1225     }
1226 
1227     /**
1228      * @dev See {IERC721-safeTransferFrom}.
1229      */
1230     function safeTransferFrom(
1231         address from,
1232         address to,
1233         uint256 tokenId
1234     ) public virtual override {
1235         safeTransferFrom(from, to, tokenId, '');
1236     }
1237 
1238     /**
1239      * @dev See {IERC721-safeTransferFrom}.
1240      */
1241     function safeTransferFrom(
1242         address from,
1243         address to,
1244         uint256 tokenId,
1245         bytes memory _data
1246     ) public virtual override {
1247         transferFrom(from, to, tokenId);
1248         if (to.code.length != 0)
1249             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1250                 revert TransferToNonERC721ReceiverImplementer();
1251             }
1252     }
1253 
1254     /**
1255      * @dev Returns whether `tokenId` exists.
1256      *
1257      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1258      *
1259      * Tokens start existing when they are minted (`_mint`),
1260      */
1261     function _exists(uint256 tokenId) internal view returns (bool) {
1262         return
1263             _startTokenId() <= tokenId &&
1264             tokenId < _currentIndex && // If within bounds,
1265             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1266     }
1267 
1268     /**
1269      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1270      */
1271     function _safeMint(address to, uint256 quantity) internal {
1272         _safeMint(to, quantity, '');
1273     }
1274 
1275     /**
1276      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1277      *
1278      * Requirements:
1279      *
1280      * - If `to` refers to a smart contract, it must implement
1281      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1282      * - `quantity` must be greater than 0.
1283      *
1284      * See {_mint}.
1285      *
1286      * Emits a {Transfer} event for each mint.
1287      */
1288     function _safeMint(
1289         address to,
1290         uint256 quantity,
1291         bytes memory _data
1292     ) internal {
1293         _mint(to, quantity);
1294 
1295         unchecked {
1296             if (to.code.length != 0) {
1297                 uint256 end = _currentIndex;
1298                 uint256 index = end - quantity;
1299                 do {
1300                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1301                         revert TransferToNonERC721ReceiverImplementer();
1302                     }
1303                 } while (index < end);
1304                 // Reentrancy protection.
1305                 if (_currentIndex != end) revert();
1306             }
1307         }
1308     }
1309 
1310     /**
1311      * @dev Mints `quantity` tokens and transfers them to `to`.
1312      *
1313      * Requirements:
1314      *
1315      * - `to` cannot be the zero address.
1316      * - `quantity` must be greater than 0.
1317      *
1318      * Emits a {Transfer} event for each mint.
1319      */
1320     function _mint(address to, uint256 quantity) internal {
1321         uint256 startTokenId = _currentIndex;
1322         if (to == address(0)) revert MintToZeroAddress();
1323         if (quantity == 0) revert MintZeroQuantity();
1324 
1325         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1326 
1327         // Overflows are incredibly unrealistic.
1328         // `balance` and `numberMinted` have a maximum limit of 2**64.
1329         // `tokenId` has a maximum limit of 2**256.
1330         unchecked {
1331             // Updates:
1332             // - `balance += quantity`.
1333             // - `numberMinted += quantity`.
1334             //
1335             // We can directly add to the `balance` and `numberMinted`.
1336             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1337 
1338             // Updates:
1339             // - `address` to the owner.
1340             // - `startTimestamp` to the timestamp of minting.
1341             // - `burned` to `false`.
1342             // - `nextInitialized` to `quantity == 1`.
1343             _packedOwnerships[startTokenId] = _packOwnershipData(
1344                 to,
1345                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1346             );
1347 
1348             uint256 tokenId = startTokenId;
1349             uint256 end = startTokenId + quantity;
1350             do {
1351                 emit Transfer(address(0), to, tokenId++);
1352             } while (tokenId < end);
1353 
1354             _currentIndex = end;
1355         }
1356         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1357     }
1358 
1359     /**
1360      * @dev Mints `quantity` tokens and transfers them to `to`.
1361      *
1362      * This function is intended for efficient minting only during contract creation.
1363      *
1364      * It emits only one {ConsecutiveTransfer} as defined in
1365      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1366      * instead of a sequence of {Transfer} event(s).
1367      *
1368      * Calling this function outside of contract creation WILL make your contract
1369      * non-compliant with the ERC721 standard.
1370      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1371      * {ConsecutiveTransfer} event is only permissible during contract creation.
1372      *
1373      * Requirements:
1374      *
1375      * - `to` cannot be the zero address.
1376      * - `quantity` must be greater than 0.
1377      *
1378      * Emits a {ConsecutiveTransfer} event.
1379      */
1380     function _mintERC2309(address to, uint256 quantity) internal {
1381         uint256 startTokenId = _currentIndex;
1382         if (to == address(0)) revert MintToZeroAddress();
1383         if (quantity == 0) revert MintZeroQuantity();
1384         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1385 
1386         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1387 
1388         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1389         unchecked {
1390             // Updates:
1391             // - `balance += quantity`.
1392             // - `numberMinted += quantity`.
1393             //
1394             // We can directly add to the `balance` and `numberMinted`.
1395             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1396 
1397             // Updates:
1398             // - `address` to the owner.
1399             // - `startTimestamp` to the timestamp of minting.
1400             // - `burned` to `false`.
1401             // - `nextInitialized` to `quantity == 1`.
1402             _packedOwnerships[startTokenId] = _packOwnershipData(
1403                 to,
1404                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1405             );
1406 
1407             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1408 
1409             _currentIndex = startTokenId + quantity;
1410         }
1411         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1412     }
1413 
1414     /**
1415      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1416      */
1417     function _getApprovedAddress(uint256 tokenId)
1418         private
1419         view
1420         returns (uint256 approvedAddressSlot, address approvedAddress)
1421     {
1422         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1423         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1424         assembly {
1425             // Compute the slot.
1426             mstore(0x00, tokenId)
1427             mstore(0x20, tokenApprovalsPtr.slot)
1428             approvedAddressSlot := keccak256(0x00, 0x40)
1429             // Load the slot's value from storage.
1430             approvedAddress := sload(approvedAddressSlot)
1431         }
1432     }
1433 
1434     /**
1435      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1436      */
1437     function _isOwnerOrApproved(
1438         address approvedAddress,
1439         address from,
1440         address msgSender
1441     ) private pure returns (bool result) {
1442         assembly {
1443             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1444             from := and(from, BITMASK_ADDRESS)
1445             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1446             msgSender := and(msgSender, BITMASK_ADDRESS)
1447             // `msgSender == from || msgSender == approvedAddress`.
1448             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1449         }
1450     }
1451 
1452     /**
1453      * @dev Transfers `tokenId` from `from` to `to`.
1454      *
1455      * Requirements:
1456      *
1457      * - `to` cannot be the zero address.
1458      * - `tokenId` token must be owned by `from`.
1459      *
1460      * Emits a {Transfer} event.
1461      */
1462     function transferFrom(
1463         address from,
1464         address to,
1465         uint256 tokenId
1466     ) public virtual override {
1467         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1468 
1469         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1470 
1471         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1472 
1473         // The nested ifs save around 20+ gas over a compound boolean condition.
1474         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1475             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1476 
1477         if (to == address(0)) revert TransferToZeroAddress();
1478 
1479         _beforeTokenTransfers(from, to, tokenId, 1);
1480 
1481         // Clear approvals from the previous owner.
1482         assembly {
1483             if approvedAddress {
1484                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1485                 sstore(approvedAddressSlot, 0)
1486             }
1487         }
1488 
1489         // Underflow of the sender's balance is impossible because we check for
1490         // ownership above and the recipient's balance can't realistically overflow.
1491         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1492         unchecked {
1493             // We can directly increment and decrement the balances.
1494             --_packedAddressData[from]; // Updates: `balance -= 1`.
1495             ++_packedAddressData[to]; // Updates: `balance += 1`.
1496 
1497             // Updates:
1498             // - `address` to the next owner.
1499             // - `startTimestamp` to the timestamp of transfering.
1500             // - `burned` to `false`.
1501             // - `nextInitialized` to `true`.
1502             _packedOwnerships[tokenId] = _packOwnershipData(
1503                 to,
1504                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1505             );
1506 
1507             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1508             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1509                 uint256 nextTokenId = tokenId + 1;
1510                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1511                 if (_packedOwnerships[nextTokenId] == 0) {
1512                     // If the next slot is within bounds.
1513                     if (nextTokenId != _currentIndex) {
1514                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1515                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1516                     }
1517                 }
1518             }
1519         }
1520 
1521         emit Transfer(from, to, tokenId);
1522         _afterTokenTransfers(from, to, tokenId, 1);
1523     }
1524 
1525     /**
1526      * @dev Equivalent to `_burn(tokenId, false)`.
1527      */
1528     function _burn(uint256 tokenId) internal virtual {
1529         _burn(tokenId, false);
1530     }
1531 
1532     /**
1533      * @dev Destroys `tokenId`.
1534      * The approval is cleared when the token is burned.
1535      *
1536      * Requirements:
1537      *
1538      * - `tokenId` must exist.
1539      *
1540      * Emits a {Transfer} event.
1541      */
1542     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1543         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1544 
1545         address from = address(uint160(prevOwnershipPacked));
1546 
1547         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1548 
1549         if (approvalCheck) {
1550             // The nested ifs save around 20+ gas over a compound boolean condition.
1551             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1552                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1553         }
1554 
1555         _beforeTokenTransfers(from, address(0), tokenId, 1);
1556 
1557         // Clear approvals from the previous owner.
1558         assembly {
1559             if approvedAddress {
1560                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1561                 sstore(approvedAddressSlot, 0)
1562             }
1563         }
1564 
1565         // Underflow of the sender's balance is impossible because we check for
1566         // ownership above and the recipient's balance can't realistically overflow.
1567         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1568         unchecked {
1569             // Updates:
1570             // - `balance -= 1`.
1571             // - `numberBurned += 1`.
1572             //
1573             // We can directly decrement the balance, and increment the number burned.
1574             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1575             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1576 
1577             // Updates:
1578             // - `address` to the last owner.
1579             // - `startTimestamp` to the timestamp of burning.
1580             // - `burned` to `true`.
1581             // - `nextInitialized` to `true`.
1582             _packedOwnerships[tokenId] = _packOwnershipData(
1583                 from,
1584                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1585             );
1586 
1587             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1588             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1589                 uint256 nextTokenId = tokenId + 1;
1590                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1591                 if (_packedOwnerships[nextTokenId] == 0) {
1592                     // If the next slot is within bounds.
1593                     if (nextTokenId != _currentIndex) {
1594                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1595                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1596                     }
1597                 }
1598             }
1599         }
1600 
1601         emit Transfer(from, address(0), tokenId);
1602         _afterTokenTransfers(from, address(0), tokenId, 1);
1603 
1604         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1605         unchecked {
1606             _burnCounter++;
1607         }
1608     }
1609 
1610     /**
1611      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1612      *
1613      * @param from address representing the previous owner of the given token ID
1614      * @param to target address that will receive the tokens
1615      * @param tokenId uint256 ID of the token to be transferred
1616      * @param _data bytes optional data to send along with the call
1617      * @return bool whether the call correctly returned the expected magic value
1618      */
1619     function _checkContractOnERC721Received(
1620         address from,
1621         address to,
1622         uint256 tokenId,
1623         bytes memory _data
1624     ) private returns (bool) {
1625         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1626             bytes4 retval
1627         ) {
1628             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1629         } catch (bytes memory reason) {
1630             if (reason.length == 0) {
1631                 revert TransferToNonERC721ReceiverImplementer();
1632             } else {
1633                 assembly {
1634                     revert(add(32, reason), mload(reason))
1635                 }
1636             }
1637         }
1638     }
1639 
1640     /**
1641      * @dev Directly sets the extra data for the ownership data `index`.
1642      */
1643     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1644         uint256 packed = _packedOwnerships[index];
1645         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1646         uint256 extraDataCasted;
1647         // Cast `extraData` with assembly to avoid redundant masking.
1648         assembly {
1649             extraDataCasted := extraData
1650         }
1651         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1652         _packedOwnerships[index] = packed;
1653     }
1654 
1655     /**
1656      * @dev Returns the next extra data for the packed ownership data.
1657      * The returned result is shifted into position.
1658      */
1659     function _nextExtraData(
1660         address from,
1661         address to,
1662         uint256 prevOwnershipPacked
1663     ) private view returns (uint256) {
1664         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1665         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1666     }
1667 
1668     /**
1669      * @dev Called during each token transfer to set the 24bit `extraData` field.
1670      * Intended to be overridden by the cosumer contract.
1671      *
1672      * `previousExtraData` - the value of `extraData` before transfer.
1673      *
1674      * Calling conditions:
1675      *
1676      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1677      * transferred to `to`.
1678      * - When `from` is zero, `tokenId` will be minted for `to`.
1679      * - When `to` is zero, `tokenId` will be burned by `from`.
1680      * - `from` and `to` are never both zero.
1681      */
1682     function _extraData(
1683         address from,
1684         address to,
1685         uint24 previousExtraData
1686     ) internal view virtual returns (uint24) {}
1687 
1688     /**
1689      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1690      * This includes minting.
1691      * And also called before burning one token.
1692      *
1693      * startTokenId - the first token id to be transferred
1694      * quantity - the amount to be transferred
1695      *
1696      * Calling conditions:
1697      *
1698      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1699      * transferred to `to`.
1700      * - When `from` is zero, `tokenId` will be minted for `to`.
1701      * - When `to` is zero, `tokenId` will be burned by `from`.
1702      * - `from` and `to` are never both zero.
1703      */
1704     function _beforeTokenTransfers(
1705         address from,
1706         address to,
1707         uint256 startTokenId,
1708         uint256 quantity
1709     ) internal virtual {}
1710 
1711     /**
1712      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1713      * This includes minting.
1714      * And also called after one token has been burned.
1715      *
1716      * startTokenId - the first token id to be transferred
1717      * quantity - the amount to be transferred
1718      *
1719      * Calling conditions:
1720      *
1721      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1722      * transferred to `to`.
1723      * - When `from` is zero, `tokenId` has been minted for `to`.
1724      * - When `to` is zero, `tokenId` has been burned by `from`.
1725      * - `from` and `to` are never both zero.
1726      */
1727     function _afterTokenTransfers(
1728         address from,
1729         address to,
1730         uint256 startTokenId,
1731         uint256 quantity
1732     ) internal virtual {}
1733 
1734     /**
1735      * @dev Returns the message sender (defaults to `msg.sender`).
1736      *
1737      * If you are writing GSN compatible contracts, you need to override this function.
1738      */
1739     function _msgSenderERC721A() internal view virtual returns (address) {
1740         return msg.sender;
1741     }
1742 
1743     /**
1744      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1745      */
1746     function _toString(uint256 value) internal pure returns (string memory ptr) {
1747         assembly {
1748             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1749             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1750             // We will need 1 32-byte word to store the length,
1751             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1752             ptr := add(mload(0x40), 128)
1753             // Update the free memory pointer to allocate.
1754             mstore(0x40, ptr)
1755 
1756             // Cache the end of the memory to calculate the length later.
1757             let end := ptr
1758 
1759             // We write the string from the rightmost digit to the leftmost digit.
1760             // The following is essentially a do-while loop that also handles the zero case.
1761             // Costs a bit more than early returning for the zero case,
1762             // but cheaper in terms of deployment and overall runtime costs.
1763             for {
1764                 // Initialize and perform the first pass without check.
1765                 let temp := value
1766                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1767                 ptr := sub(ptr, 1)
1768                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1769                 mstore8(ptr, add(48, mod(temp, 10)))
1770                 temp := div(temp, 10)
1771             } temp {
1772                 // Keep dividing `temp` until zero.
1773                 temp := div(temp, 10)
1774             } {
1775                 // Body of the for loop.
1776                 ptr := sub(ptr, 1)
1777                 mstore8(ptr, add(48, mod(temp, 10)))
1778             }
1779 
1780             let length := sub(end, ptr)
1781             // Move the pointer 32 bytes leftwards to make room for the length.
1782             ptr := sub(ptr, 32)
1783             // Store the length.
1784             mstore(ptr, length)
1785         }
1786     }
1787 }
1788 
1789 // File: cyber.sol
1790 
1791 
1792 
1793 pragma solidity >=0.8.9 <0.9.0;
1794 
1795 
1796 
1797 
1798 
1799 
1800 
1801 contract CyberSaudis is ERC721A, Ownable, ReentrancyGuard {
1802 
1803   using Strings for uint256;
1804 
1805   bytes32 public merkleRoot;
1806   mapping(address => bool) public claimed;
1807   mapping(uint256 => TokenOwnership) internal _ownerships;
1808 
1809   string public uriPrefix = '';
1810   string public uriSuffix = '.json';
1811   string public hiddenMetadataUri;
1812   
1813   uint256 public cost;
1814   uint256 public finalMaxSupply = 5555;
1815   uint256 public currentMaxSupply;
1816   uint256 public maxMintAmountPerTx;
1817   uint256 public currentFreeSupply = 0;
1818 
1819   bool public paused = false;
1820   bool public whitelistMintEnabled = false;
1821   bool public revealed = false;
1822 
1823   constructor(
1824     string memory _tokenName,
1825     string memory _tokenSymbol,
1826     uint256 _cost,
1827     uint256 _maxSupply,
1828     uint256 _maxMintAmountPerTx,
1829     string memory _hiddenMetadataUri
1830   ) ERC721A(_tokenName, _tokenSymbol) {
1831     setCost(_cost);
1832     currentMaxSupply = _maxSupply;
1833     setMaxMintAmountPerTx(_maxMintAmountPerTx);
1834     setHiddenMetadataUri(_hiddenMetadataUri);
1835   }
1836 
1837   function mint(uint256 _mintAmount) external payable {
1838     require(!paused, 'The contract is paused!');
1839     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1840     require(totalSupply() + _mintAmount <= currentMaxSupply, 'Max supply exceeded!');
1841     uint free = (claimed[_msgSender()] || currentFreeSupply > 500) ? 0 : 1;
1842     require(msg.value >= cost * (_mintAmount - free), "PAYMENT: invalid value");
1843 
1844     currentFreeSupply++;
1845     claimed[_msgSender()] = true;
1846 
1847     _safeMint(_msgSender(), _mintAmount);
1848   }
1849   
1850   function mintForAddress(uint256 _mintAmount, address _receiver) external onlyOwner {
1851     require(totalSupply() + _mintAmount <= currentMaxSupply, 'Max supply exceeded!');
1852     _safeMint(_receiver, _mintAmount);
1853   }
1854 
1855   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1856     uint256 ownerTokenCount = balanceOf(_owner);
1857     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1858     uint256 currentTokenId = _startTokenId();
1859     uint256 ownedTokenIndex = 0;
1860     address latestOwnerAddress;
1861     
1862     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= currentMaxSupply) {
1863 
1864       TokenOwnership memory ownership = _ownerships[currentTokenId];
1865 
1866       if (!ownership.burned && ownership.addr != address(0)) {
1867         latestOwnerAddress = ownership.addr;
1868       }
1869 
1870       if (latestOwnerAddress == _owner) {
1871         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1872 
1873         ownedTokenIndex++;
1874       }
1875 
1876       currentTokenId++;
1877     }
1878 
1879     return ownedTokenIds;
1880   }
1881 
1882   function _startTokenId() internal view virtual override returns (uint256) {
1883     return 1;
1884   }
1885 
1886   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1887     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1888 
1889     if (revealed == false) {
1890       return hiddenMetadataUri;
1891     }
1892 
1893     string memory currentBaseURI = _baseURI();
1894     return bytes(currentBaseURI).length > 0
1895         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1896         : '';
1897   }
1898 
1899   function setRevealed(bool _state) public onlyOwner {
1900     revealed = _state;
1901   }
1902 
1903   function resetFinalMaxSupply() public onlyOwner {
1904     finalMaxSupply = currentMaxSupply;
1905   }
1906 
1907   function getCurrentFreeSupply() external view onlyOwner returns (uint256) {
1908     return currentFreeSupply;
1909   }
1910 
1911   function setCurrentMaxSupply(uint256 _supply) public onlyOwner {
1912     require(_supply <= finalMaxSupply && _supply >= totalSupply());
1913     currentMaxSupply = _supply;
1914   }
1915 
1916   function setCost(uint256 _cost) public onlyOwner {
1917     cost = _cost;
1918   }
1919 
1920   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1921     maxMintAmountPerTx = _maxMintAmountPerTx;
1922   }
1923 
1924   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1925     hiddenMetadataUri = _hiddenMetadataUri;
1926   }
1927 
1928   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1929     uriPrefix = _uriPrefix;
1930   }
1931 
1932   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1933     uriSuffix = _uriSuffix;
1934   }
1935 
1936   function setPaused(bool _state) public onlyOwner {
1937     paused = _state;
1938   }
1939 
1940   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1941     merkleRoot = _merkleRoot;
1942   }
1943 
1944   function setWhitelistMintEnabled(bool _state) public onlyOwner {
1945     whitelistMintEnabled = _state;
1946   }
1947 
1948   function withdraw() external onlyOwner nonReentrant {
1949     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1950     require(os);
1951   }
1952 
1953   function _baseURI() internal view virtual override returns (string memory) {
1954     return uriPrefix;
1955   }
1956 }