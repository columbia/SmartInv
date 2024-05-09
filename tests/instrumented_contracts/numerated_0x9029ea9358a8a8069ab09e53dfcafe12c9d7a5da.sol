1 /*
2 
3             ───────────▄██████████████▄───────
4             ───────▄████░░░░░░░░█▀────█▄──────
5             ──────██░░░░░░░░░░░█▀──────█▄─────
6             ─────██░░░░░░░░░░░█▀────────█▄────
7             ────██░░░░░░░░░░░░█──────────██───
8             ───██░░░░░░░░░░░░░█──────██──██───
9             ──██░░░░░░░░░░░░░░█▄─────██──██───
10             ─████████████░░░░░░██────────██───
11             ██░░░░░░░░░░░██░░░░░█████████████─
12             ██░░░░░░░░░░░██░░░░█▓▓▓▓▓▓▓▓▓▓▓▓▓█
13             ██░░░░░░░░░░░██░░░█▓▓▓▓▓▓▓▓▓▓▓▓▓▓█
14             ─▀███████████▒▒▒▒█▓▓▓███████████▀─
15             ────██▒▒▒▒▒▒▒▒▒▒▒▒█▓▓▓▓▓▓▓▓▓▓▓▓█──
16             ─────██▒▒▒▒▒▒▒▒▒▒▒▒██▓▓▓▓▓▓▓▓▓▓█──
17             ──────█████▒▒▒▒▒▒▒▒▒▒██████████───
18             ─────────▀███████████▀────────────
19   ___ ___       __         _______ __         __       
20  |   Y   .-----|  |_.---.-|   _   |__.----.--|  .-----.
21  |.      |  -__|   _|  _  |.  1   |  |   _|  _  |__ --|
22  |. \_/  |_____|____|___._|.  _   |__|__| |_____|_____|
23  |:  |   |                |:  1    \                   
24  |::.|:. |                |::.. .  /                   
25  `--- ---'                `-------'                    
26                                                        
27 */
28 
29 // SPDX-License-Identifier: MIT
30 
31 // File: @openzeppelin/contracts/utils/Strings.sol
32 
33 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev String operations.
39  */
40 library Strings {
41     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
42     uint8 private constant _ADDRESS_LENGTH = 20;
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
46      */
47     function toString(uint256 value) internal pure returns (string memory) {
48         // Inspired by OraclizeAPI's implementation - MIT licence
49         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
50 
51         if (value == 0) {
52             return "0";
53         }
54         uint256 temp = value;
55         uint256 digits;
56         while (temp != 0) {
57             digits++;
58             temp /= 10;
59         }
60         bytes memory buffer = new bytes(digits);
61         while (value != 0) {
62             digits -= 1;
63             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
64             value /= 10;
65         }
66         return string(buffer);
67     }
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
71      */
72     function toHexString(uint256 value) internal pure returns (string memory) {
73         if (value == 0) {
74             return "0x00";
75         }
76         uint256 temp = value;
77         uint256 length = 0;
78         while (temp != 0) {
79             length++;
80             temp >>= 8;
81         }
82         return toHexString(value, length);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
87      */
88     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
89         bytes memory buffer = new bytes(2 * length + 2);
90         buffer[0] = "0";
91         buffer[1] = "x";
92         for (uint256 i = 2 * length + 1; i > 1; --i) {
93             buffer[i] = _HEX_SYMBOLS[value & 0xf];
94             value >>= 4;
95         }
96         require(value == 0, "Strings: hex length insufficient");
97         return string(buffer);
98     }
99 
100     /**
101      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
102      */
103     function toHexString(address addr) internal pure returns (string memory) {
104         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
105     }
106 }
107 
108 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
109 
110 
111 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev Contract module that helps prevent reentrant calls to a function.
117  *
118  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
119  * available, which can be applied to functions to make sure there are no nested
120  * (reentrant) calls to them.
121  *
122  * Note that because there is a single `nonReentrant` guard, functions marked as
123  * `nonReentrant` may not call one another. This can be worked around by making
124  * those functions `private`, and then adding `external` `nonReentrant` entry
125  * points to them.
126  *
127  * TIP: If you would like to learn more about reentrancy and alternative ways
128  * to protect against it, check out our blog post
129  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
130  */
131 abstract contract ReentrancyGuard {
132     // Booleans are more expensive than uint256 or any type that takes up a full
133     // word because each write operation emits an extra SLOAD to first read the
134     // slot's contents, replace the bits taken up by the boolean, and then write
135     // back. This is the compiler's defense against contract upgrades and
136     // pointer aliasing, and it cannot be disabled.
137 
138     // The values being non-zero value makes deployment a bit more expensive,
139     // but in exchange the refund on every call to nonReentrant will be lower in
140     // amount. Since refunds are capped to a percentage of the total
141     // transaction's gas, it is best to keep them low in cases like this one, to
142     // increase the likelihood of the full refund coming into effect.
143     uint256 private constant _NOT_ENTERED = 1;
144     uint256 private constant _ENTERED = 2;
145 
146     uint256 private _status;
147 
148     constructor() {
149         _status = _NOT_ENTERED;
150     }
151 
152     /**
153      * @dev Prevents a contract from calling itself, directly or indirectly.
154      * Calling a `nonReentrant` function from another `nonReentrant`
155      * function is not supported. It is possible to prevent this from happening
156      * by making the `nonReentrant` function external, and making it call a
157      * `private` function that does the actual work.
158      */
159     modifier nonReentrant() {
160         // On the first call to nonReentrant, _notEntered will be true
161         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
162 
163         // Any calls to nonReentrant after this point will fail
164         _status = _ENTERED;
165 
166         _;
167 
168         // By storing the original value once again, a refund is triggered (see
169         // https://eips.ethereum.org/EIPS/eip-2200)
170         _status = _NOT_ENTERED;
171     }
172 }
173 
174 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
175 
176 
177 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @dev These functions deal with verification of Merkle Tree proofs.
183  *
184  * The proofs can be generated using the JavaScript library
185  * https://github.com/miguelmota/merkletreejs[merkletreejs].
186  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
187  *
188  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
189  *
190  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
191  * hashing, or use a hash function other than keccak256 for hashing leaves.
192  * This is because the concatenation of a sorted pair of internal nodes in
193  * the merkle tree could be reinterpreted as a leaf value.
194  */
195 library MerkleProof {
196     /**
197      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
198      * defined by `root`. For this, a `proof` must be provided, containing
199      * sibling hashes on the branch from the leaf to the root of the tree. Each
200      * pair of leaves and each pair of pre-images are assumed to be sorted.
201      */
202     function verify(
203         bytes32[] memory proof,
204         bytes32 root,
205         bytes32 leaf
206     ) internal pure returns (bool) {
207         return processProof(proof, leaf) == root;
208     }
209 
210     /**
211      * @dev Calldata version of {verify}
212      *
213      * _Available since v4.7._
214      */
215     function verifyCalldata(
216         bytes32[] calldata proof,
217         bytes32 root,
218         bytes32 leaf
219     ) internal pure returns (bool) {
220         return processProofCalldata(proof, leaf) == root;
221     }
222 
223     /**
224      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
225      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
226      * hash matches the root of the tree. When processing the proof, the pairs
227      * of leafs & pre-images are assumed to be sorted.
228      *
229      * _Available since v4.4._
230      */
231     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
232         bytes32 computedHash = leaf;
233         for (uint256 i = 0; i < proof.length; i++) {
234             computedHash = _hashPair(computedHash, proof[i]);
235         }
236         return computedHash;
237     }
238 
239     /**
240      * @dev Calldata version of {processProof}
241      *
242      * _Available since v4.7._
243      */
244     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
245         bytes32 computedHash = leaf;
246         for (uint256 i = 0; i < proof.length; i++) {
247             computedHash = _hashPair(computedHash, proof[i]);
248         }
249         return computedHash;
250     }
251 
252     /**
253      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
254      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
255      *
256      * _Available since v4.7._
257      */
258     function multiProofVerify(
259         bytes32[] memory proof,
260         bool[] memory proofFlags,
261         bytes32 root,
262         bytes32[] memory leaves
263     ) internal pure returns (bool) {
264         return processMultiProof(proof, proofFlags, leaves) == root;
265     }
266 
267     /**
268      * @dev Calldata version of {multiProofVerify}
269      *
270      * _Available since v4.7._
271      */
272     function multiProofVerifyCalldata(
273         bytes32[] calldata proof,
274         bool[] calldata proofFlags,
275         bytes32 root,
276         bytes32[] memory leaves
277     ) internal pure returns (bool) {
278         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
279     }
280 
281     /**
282      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
283      * consuming from one or the other at each step according to the instructions given by
284      * `proofFlags`.
285      *
286      * _Available since v4.7._
287      */
288     function processMultiProof(
289         bytes32[] memory proof,
290         bool[] memory proofFlags,
291         bytes32[] memory leaves
292     ) internal pure returns (bytes32 merkleRoot) {
293         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
294         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
295         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
296         // the merkle tree.
297         uint256 leavesLen = leaves.length;
298         uint256 totalHashes = proofFlags.length;
299 
300         // Check proof validity.
301         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
302 
303         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
304         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
305         bytes32[] memory hashes = new bytes32[](totalHashes);
306         uint256 leafPos = 0;
307         uint256 hashPos = 0;
308         uint256 proofPos = 0;
309         // At each step, we compute the next hash using two values:
310         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
311         //   get the next hash.
312         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
313         //   `proof` array.
314         for (uint256 i = 0; i < totalHashes; i++) {
315             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
316             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
317             hashes[i] = _hashPair(a, b);
318         }
319 
320         if (totalHashes > 0) {
321             return hashes[totalHashes - 1];
322         } else if (leavesLen > 0) {
323             return leaves[0];
324         } else {
325             return proof[0];
326         }
327     }
328 
329     /**
330      * @dev Calldata version of {processMultiProof}
331      *
332      * _Available since v4.7._
333      */
334     function processMultiProofCalldata(
335         bytes32[] calldata proof,
336         bool[] calldata proofFlags,
337         bytes32[] memory leaves
338     ) internal pure returns (bytes32 merkleRoot) {
339         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
340         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
341         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
342         // the merkle tree.
343         uint256 leavesLen = leaves.length;
344         uint256 totalHashes = proofFlags.length;
345 
346         // Check proof validity.
347         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
348 
349         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
350         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
351         bytes32[] memory hashes = new bytes32[](totalHashes);
352         uint256 leafPos = 0;
353         uint256 hashPos = 0;
354         uint256 proofPos = 0;
355         // At each step, we compute the next hash using two values:
356         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
357         //   get the next hash.
358         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
359         //   `proof` array.
360         for (uint256 i = 0; i < totalHashes; i++) {
361             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
362             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
363             hashes[i] = _hashPair(a, b);
364         }
365 
366         if (totalHashes > 0) {
367             return hashes[totalHashes - 1];
368         } else if (leavesLen > 0) {
369             return leaves[0];
370         } else {
371             return proof[0];
372         }
373     }
374 
375     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
376         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
377     }
378 
379     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
380         /// @solidity memory-safe-assembly
381         assembly {
382             mstore(0x00, a)
383             mstore(0x20, b)
384             value := keccak256(0x00, 0x40)
385         }
386     }
387 }
388 
389 // File: @openzeppelin/contracts/utils/Context.sol
390 
391 
392 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @dev Provides information about the current execution context, including the
398  * sender of the transaction and its data. While these are generally available
399  * via msg.sender and msg.data, they should not be accessed in such a direct
400  * manner, since when dealing with meta-transactions the account sending and
401  * paying for execution may not be the actual sender (as far as an application
402  * is concerned).
403  *
404  * This contract is only required for intermediate, library-like contracts.
405  */
406 abstract contract Context {
407     function _msgSender() internal view virtual returns (address) {
408         return msg.sender;
409     }
410 
411     function _msgData() internal view virtual returns (bytes calldata) {
412         return msg.data;
413     }
414 }
415 
416 // File: @openzeppelin/contracts/access/Ownable.sol
417 
418 
419 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
420 
421 pragma solidity ^0.8.0;
422 
423 
424 /**
425  * @dev Contract module which provides a basic access control mechanism, where
426  * there is an account (an owner) that can be granted exclusive access to
427  * specific functions.
428  *
429  * By default, the owner account will be the one that deploys the contract. This
430  * can later be changed with {transferOwnership}.
431  *
432  * This module is used through inheritance. It will make available the modifier
433  * `onlyOwner`, which can be applied to your functions to restrict their use to
434  * the owner.
435  */
436 abstract contract Ownable is Context {
437     address private _owner;
438 
439     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
440 
441     /**
442      * @dev Initializes the contract setting the deployer as the initial owner.
443      */
444     constructor() {
445         _transferOwnership(_msgSender());
446     }
447 
448     /**
449      * @dev Throws if called by any account other than the owner.
450      */
451     modifier onlyOwner() {
452         _checkOwner();
453         _;
454     }
455 
456     /**
457      * @dev Returns the address of the current owner.
458      */
459     function owner() public view virtual returns (address) {
460         return _owner;
461     }
462 
463     /**
464      * @dev Throws if the sender is not the owner.
465      */
466     function _checkOwner() internal view virtual {
467         require(owner() == _msgSender(), "Ownable: caller is not the owner");
468     }
469 
470     /**
471      * @dev Leaves the contract without owner. It will not be possible to call
472      * `onlyOwner` functions anymore. Can only be called by the current owner.
473      *
474      * NOTE: Renouncing ownership will leave the contract without an owner,
475      * thereby removing any functionality that is only available to the owner.
476      */
477     function renounceOwnership() public virtual onlyOwner {
478         _transferOwnership(address(0));
479     }
480 
481     /**
482      * @dev Transfers ownership of the contract to a new account (`newOwner`).
483      * Can only be called by the current owner.
484      */
485     function transferOwnership(address newOwner) public virtual onlyOwner {
486         require(newOwner != address(0), "Ownable: new owner is the zero address");
487         _transferOwnership(newOwner);
488     }
489 
490     /**
491      * @dev Transfers ownership of the contract to a new account (`newOwner`).
492      * Internal function without access restriction.
493      */
494     function _transferOwnership(address newOwner) internal virtual {
495         address oldOwner = _owner;
496         _owner = newOwner;
497         emit OwnershipTransferred(oldOwner, newOwner);
498     }
499 }
500 
501 // File: erc721a/contracts/IERC721A.sol
502 
503 
504 // ERC721A Contracts v4.1.0
505 // Creator: Chiru Labs
506 
507 pragma solidity ^0.8.4;
508 
509 /**
510  * @dev Interface of an ERC721A compliant contract.
511  */
512 interface IERC721A {
513     /**
514      * The caller must own the token or be an approved operator.
515      */
516     error ApprovalCallerNotOwnerNorApproved();
517 
518     /**
519      * The token does not exist.
520      */
521     error ApprovalQueryForNonexistentToken();
522 
523     /**
524      * The caller cannot approve to their own address.
525      */
526     error ApproveToCaller();
527 
528     /**
529      * Cannot query the balance for the zero address.
530      */
531     error BalanceQueryForZeroAddress();
532 
533     /**
534      * Cannot mint to the zero address.
535      */
536     error MintToZeroAddress();
537 
538     /**
539      * The quantity of tokens minted must be more than zero.
540      */
541     error MintZeroQuantity();
542 
543     /**
544      * The token does not exist.
545      */
546     error OwnerQueryForNonexistentToken();
547 
548     /**
549      * The caller must own the token or be an approved operator.
550      */
551     error TransferCallerNotOwnerNorApproved();
552 
553     /**
554      * The token must be owned by `from`.
555      */
556     error TransferFromIncorrectOwner();
557 
558     /**
559      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
560      */
561     error TransferToNonERC721ReceiverImplementer();
562 
563     /**
564      * Cannot transfer to the zero address.
565      */
566     error TransferToZeroAddress();
567 
568     /**
569      * The token does not exist.
570      */
571     error URIQueryForNonexistentToken();
572 
573     /**
574      * The `quantity` minted with ERC2309 exceeds the safety limit.
575      */
576     error MintERC2309QuantityExceedsLimit();
577 
578     /**
579      * The `extraData` cannot be set on an unintialized ownership slot.
580      */
581     error OwnershipNotInitializedForExtraData();
582 
583     struct TokenOwnership {
584         // The address of the owner.
585         address addr;
586         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
587         uint64 startTimestamp;
588         // Whether the token has been burned.
589         bool burned;
590         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
591         uint24 extraData;
592     }
593 
594     /**
595      * @dev Returns the total amount of tokens stored by the contract.
596      *
597      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
598      */
599     function totalSupply() external view returns (uint256);
600 
601     // ==============================
602     //            IERC165
603     // ==============================
604 
605     /**
606      * @dev Returns true if this contract implements the interface defined by
607      * `interfaceId`. See the corresponding
608      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
609      * to learn more about how these ids are created.
610      *
611      * This function call must use less than 30 000 gas.
612      */
613     function supportsInterface(bytes4 interfaceId) external view returns (bool);
614 
615     // ==============================
616     //            IERC721
617     // ==============================
618 
619     /**
620      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
621      */
622     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
623 
624     /**
625      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
626      */
627     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
628 
629     /**
630      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
631      */
632     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
633 
634     /**
635      * @dev Returns the number of tokens in ``owner``'s account.
636      */
637     function balanceOf(address owner) external view returns (uint256 balance);
638 
639     /**
640      * @dev Returns the owner of the `tokenId` token.
641      *
642      * Requirements:
643      *
644      * - `tokenId` must exist.
645      */
646     function ownerOf(uint256 tokenId) external view returns (address owner);
647 
648     /**
649      * @dev Safely transfers `tokenId` token from `from` to `to`.
650      *
651      * Requirements:
652      *
653      * - `from` cannot be the zero address.
654      * - `to` cannot be the zero address.
655      * - `tokenId` token must exist and be owned by `from`.
656      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
657      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
658      *
659      * Emits a {Transfer} event.
660      */
661     function safeTransferFrom(
662         address from,
663         address to,
664         uint256 tokenId,
665         bytes calldata data
666     ) external;
667 
668     /**
669      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
670      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
671      *
672      * Requirements:
673      *
674      * - `from` cannot be the zero address.
675      * - `to` cannot be the zero address.
676      * - `tokenId` token must exist and be owned by `from`.
677      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
678      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
679      *
680      * Emits a {Transfer} event.
681      */
682     function safeTransferFrom(
683         address from,
684         address to,
685         uint256 tokenId
686     ) external;
687 
688     /**
689      * @dev Transfers `tokenId` token from `from` to `to`.
690      *
691      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
692      *
693      * Requirements:
694      *
695      * - `from` cannot be the zero address.
696      * - `to` cannot be the zero address.
697      * - `tokenId` token must be owned by `from`.
698      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
699      *
700      * Emits a {Transfer} event.
701      */
702     function transferFrom(
703         address from,
704         address to,
705         uint256 tokenId
706     ) external;
707 
708     /**
709      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
710      * The approval is cleared when the token is transferred.
711      *
712      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
713      *
714      * Requirements:
715      *
716      * - The caller must own the token or be an approved operator.
717      * - `tokenId` must exist.
718      *
719      * Emits an {Approval} event.
720      */
721     function approve(address to, uint256 tokenId) external;
722 
723     /**
724      * @dev Approve or remove `operator` as an operator for the caller.
725      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
726      *
727      * Requirements:
728      *
729      * - The `operator` cannot be the caller.
730      *
731      * Emits an {ApprovalForAll} event.
732      */
733     function setApprovalForAll(address operator, bool _approved) external;
734 
735     /**
736      * @dev Returns the account approved for `tokenId` token.
737      *
738      * Requirements:
739      *
740      * - `tokenId` must exist.
741      */
742     function getApproved(uint256 tokenId) external view returns (address operator);
743 
744     /**
745      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
746      *
747      * See {setApprovalForAll}
748      */
749     function isApprovedForAll(address owner, address operator) external view returns (bool);
750 
751     // ==============================
752     //        IERC721Metadata
753     // ==============================
754 
755     /**
756      * @dev Returns the token collection name.
757      */
758     function name() external view returns (string memory);
759 
760     /**
761      * @dev Returns the token collection symbol.
762      */
763     function symbol() external view returns (string memory);
764 
765     /**
766      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
767      */
768     function tokenURI(uint256 tokenId) external view returns (string memory);
769 
770     // ==============================
771     //            IERC2309
772     // ==============================
773 
774     /**
775      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
776      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
777      */
778     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
779 }
780 
781 // File: erc721a/contracts/ERC721A.sol
782 
783 
784 // ERC721A Contracts v4.1.0
785 // Creator: Chiru Labs
786 
787 pragma solidity ^0.8.4;
788 
789 
790 /**
791  * @dev ERC721 token receiver interface.
792  */
793 interface ERC721A__IERC721Receiver {
794     function onERC721Received(
795         address operator,
796         address from,
797         uint256 tokenId,
798         bytes calldata data
799     ) external returns (bytes4);
800 }
801 
802 /**
803  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
804  * including the Metadata extension. Built to optimize for lower gas during batch mints.
805  *
806  * Assumes serials are sequentially minted starting at `_startTokenId()`
807  * (defaults to 0, e.g. 0, 1, 2, 3..).
808  *
809  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
810  *
811  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
812  */
813 contract ERC721A is IERC721A {
814     // Mask of an entry in packed address data.
815     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
816 
817     // The bit position of `numberMinted` in packed address data.
818     uint256 private constant BITPOS_NUMBER_MINTED = 64;
819 
820     // The bit position of `numberBurned` in packed address data.
821     uint256 private constant BITPOS_NUMBER_BURNED = 128;
822 
823     // The bit position of `aux` in packed address data.
824     uint256 private constant BITPOS_AUX = 192;
825 
826     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
827     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
828 
829     // The bit position of `startTimestamp` in packed ownership.
830     uint256 private constant BITPOS_START_TIMESTAMP = 160;
831 
832     // The bit mask of the `burned` bit in packed ownership.
833     uint256 private constant BITMASK_BURNED = 1 << 224;
834 
835     // The bit position of the `nextInitialized` bit in packed ownership.
836     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
837 
838     // The bit mask of the `nextInitialized` bit in packed ownership.
839     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
840 
841     // The bit position of `extraData` in packed ownership.
842     uint256 private constant BITPOS_EXTRA_DATA = 232;
843 
844     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
845     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
846 
847     // The mask of the lower 160 bits for addresses.
848     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
849 
850     // The maximum `quantity` that can be minted with `_mintERC2309`.
851     // This limit is to prevent overflows on the address data entries.
852     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
853     // is required to cause an overflow, which is unrealistic.
854     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
855 
856     // The tokenId of the next token to be minted.
857     uint256 private _currentIndex;
858 
859     // The number of tokens burned.
860     uint256 private _burnCounter;
861 
862     // Token name
863     string private _name;
864 
865     // Token symbol
866     string private _symbol;
867 
868     // Mapping from token ID to ownership details
869     // An empty struct value does not necessarily mean the token is unowned.
870     // See `_packedOwnershipOf` implementation for details.
871     //
872     // Bits Layout:
873     // - [0..159]   `addr`
874     // - [160..223] `startTimestamp`
875     // - [224]      `burned`
876     // - [225]      `nextInitialized`
877     // - [232..255] `extraData`
878     mapping(uint256 => uint256) private _packedOwnerships;
879 
880     // Mapping owner address to address data.
881     //
882     // Bits Layout:
883     // - [0..63]    `balance`
884     // - [64..127]  `numberMinted`
885     // - [128..191] `numberBurned`
886     // - [192..255] `aux`
887     mapping(address => uint256) private _packedAddressData;
888 
889     // Mapping from token ID to approved address.
890     mapping(uint256 => address) private _tokenApprovals;
891 
892     // Mapping from owner to operator approvals
893     mapping(address => mapping(address => bool)) private _operatorApprovals;
894 
895     constructor(string memory name_, string memory symbol_) {
896         _name = name_;
897         _symbol = symbol_;
898         _currentIndex = _startTokenId();
899     }
900 
901     /**
902      * @dev Returns the starting token ID.
903      * To change the starting token ID, please override this function.
904      */
905     function _startTokenId() internal view virtual returns (uint256) {
906         return 0;
907     }
908 
909     /**
910      * @dev Returns the next token ID to be minted.
911      */
912     function _nextTokenId() internal view returns (uint256) {
913         return _currentIndex;
914     }
915 
916     /**
917      * @dev Returns the total number of tokens in existence.
918      * Burned tokens will reduce the count.
919      * To get the total number of tokens minted, please see `_totalMinted`.
920      */
921     function totalSupply() public view override returns (uint256) {
922         // Counter underflow is impossible as _burnCounter cannot be incremented
923         // more than `_currentIndex - _startTokenId()` times.
924         unchecked {
925             return _currentIndex - _burnCounter - _startTokenId();
926         }
927     }
928 
929     /**
930      * @dev Returns the total amount of tokens minted in the contract.
931      */
932     function _totalMinted() internal view returns (uint256) {
933         // Counter underflow is impossible as _currentIndex does not decrement,
934         // and it is initialized to `_startTokenId()`
935         unchecked {
936             return _currentIndex - _startTokenId();
937         }
938     }
939 
940     /**
941      * @dev Returns the total number of tokens burned.
942      */
943     function _totalBurned() internal view returns (uint256) {
944         return _burnCounter;
945     }
946 
947     /**
948      * @dev See {IERC165-supportsInterface}.
949      */
950     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
951         // The interface IDs are constants representing the first 4 bytes of the XOR of
952         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
953         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
954         return
955             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
956             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
957             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
958     }
959 
960     /**
961      * @dev See {IERC721-balanceOf}.
962      */
963     function balanceOf(address owner) public view override returns (uint256) {
964         if (owner == address(0)) revert BalanceQueryForZeroAddress();
965         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
966     }
967 
968     /**
969      * Returns the number of tokens minted by `owner`.
970      */
971     function _numberMinted(address owner) internal view returns (uint256) {
972         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
973     }
974 
975     /**
976      * Returns the number of tokens burned by or on behalf of `owner`.
977      */
978     function _numberBurned(address owner) internal view returns (uint256) {
979         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
980     }
981 
982     /**
983      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
984      */
985     function _getAux(address owner) internal view returns (uint64) {
986         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
987     }
988 
989     /**
990      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
991      * If there are multiple variables, please pack them into a uint64.
992      */
993     function _setAux(address owner, uint64 aux) internal {
994         uint256 packed = _packedAddressData[owner];
995         uint256 auxCasted;
996         // Cast `aux` with assembly to avoid redundant masking.
997         assembly {
998             auxCasted := aux
999         }
1000         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1001         _packedAddressData[owner] = packed;
1002     }
1003 
1004     /**
1005      * Returns the packed ownership data of `tokenId`.
1006      */
1007     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1008         uint256 curr = tokenId;
1009 
1010         unchecked {
1011             if (_startTokenId() <= curr)
1012                 if (curr < _currentIndex) {
1013                     uint256 packed = _packedOwnerships[curr];
1014                     // If not burned.
1015                     if (packed & BITMASK_BURNED == 0) {
1016                         // Invariant:
1017                         // There will always be an ownership that has an address and is not burned
1018                         // before an ownership that does not have an address and is not burned.
1019                         // Hence, curr will not underflow.
1020                         //
1021                         // We can directly compare the packed value.
1022                         // If the address is zero, packed is zero.
1023                         while (packed == 0) {
1024                             packed = _packedOwnerships[--curr];
1025                         }
1026                         return packed;
1027                     }
1028                 }
1029         }
1030         revert OwnerQueryForNonexistentToken();
1031     }
1032 
1033     /**
1034      * Returns the unpacked `TokenOwnership` struct from `packed`.
1035      */
1036     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1037         ownership.addr = address(uint160(packed));
1038         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1039         ownership.burned = packed & BITMASK_BURNED != 0;
1040         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1041     }
1042 
1043     /**
1044      * Returns the unpacked `TokenOwnership` struct at `index`.
1045      */
1046     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1047         return _unpackedOwnership(_packedOwnerships[index]);
1048     }
1049 
1050     /**
1051      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1052      */
1053     function _initializeOwnershipAt(uint256 index) internal {
1054         if (_packedOwnerships[index] == 0) {
1055             _packedOwnerships[index] = _packedOwnershipOf(index);
1056         }
1057     }
1058 
1059     /**
1060      * Gas spent here starts off proportional to the maximum mint batch size.
1061      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1062      */
1063     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1064         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1065     }
1066 
1067     /**
1068      * @dev Packs ownership data into a single uint256.
1069      */
1070     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1071         assembly {
1072             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1073             owner := and(owner, BITMASK_ADDRESS)
1074             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1075             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1076         }
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-ownerOf}.
1081      */
1082     function ownerOf(uint256 tokenId) public view override returns (address) {
1083         return address(uint160(_packedOwnershipOf(tokenId)));
1084     }
1085 
1086     /**
1087      * @dev See {IERC721Metadata-name}.
1088      */
1089     function name() public view virtual override returns (string memory) {
1090         return _name;
1091     }
1092 
1093     /**
1094      * @dev See {IERC721Metadata-symbol}.
1095      */
1096     function symbol() public view virtual override returns (string memory) {
1097         return _symbol;
1098     }
1099 
1100     /**
1101      * @dev See {IERC721Metadata-tokenURI}.
1102      */
1103     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1104         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1105 
1106         string memory baseURI = _baseURI();
1107         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1108     }
1109 
1110     /**
1111      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1112      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1113      * by default, it can be overridden in child contracts.
1114      */
1115     function _baseURI() internal view virtual returns (string memory) {
1116         return '';
1117     }
1118 
1119     /**
1120      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1121      */
1122     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1123         // For branchless setting of the `nextInitialized` flag.
1124         assembly {
1125             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1126             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1127         }
1128     }
1129 
1130     /**
1131      * @dev See {IERC721-approve}.
1132      */
1133     function approve(address to, uint256 tokenId) public override {
1134         address owner = ownerOf(tokenId);
1135 
1136         if (_msgSenderERC721A() != owner)
1137             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1138                 revert ApprovalCallerNotOwnerNorApproved();
1139             }
1140 
1141         _tokenApprovals[tokenId] = to;
1142         emit Approval(owner, to, tokenId);
1143     }
1144 
1145     /**
1146      * @dev See {IERC721-getApproved}.
1147      */
1148     function getApproved(uint256 tokenId) public view override returns (address) {
1149         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1150 
1151         return _tokenApprovals[tokenId];
1152     }
1153 
1154     /**
1155      * @dev See {IERC721-setApprovalForAll}.
1156      */
1157     function setApprovalForAll(address operator, bool approved) public virtual override {
1158         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1159 
1160         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1161         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1162     }
1163 
1164     /**
1165      * @dev See {IERC721-isApprovedForAll}.
1166      */
1167     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1168         return _operatorApprovals[owner][operator];
1169     }
1170 
1171     /**
1172      * @dev See {IERC721-safeTransferFrom}.
1173      */
1174     function safeTransferFrom(
1175         address from,
1176         address to,
1177         uint256 tokenId
1178     ) public virtual override {
1179         safeTransferFrom(from, to, tokenId, '');
1180     }
1181 
1182     /**
1183      * @dev See {IERC721-safeTransferFrom}.
1184      */
1185     function safeTransferFrom(
1186         address from,
1187         address to,
1188         uint256 tokenId,
1189         bytes memory _data
1190     ) public virtual override {
1191         transferFrom(from, to, tokenId);
1192         if (to.code.length != 0)
1193             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1194                 revert TransferToNonERC721ReceiverImplementer();
1195             }
1196     }
1197 
1198     /**
1199      * @dev Returns whether `tokenId` exists.
1200      *
1201      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1202      *
1203      * Tokens start existing when they are minted (`_mint`),
1204      */
1205     function _exists(uint256 tokenId) internal view returns (bool) {
1206         return
1207             _startTokenId() <= tokenId &&
1208             tokenId < _currentIndex && // If within bounds,
1209             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1210     }
1211 
1212     /**
1213      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1214      */
1215     function _safeMint(address to, uint256 quantity) internal {
1216         _safeMint(to, quantity, '');
1217     }
1218 
1219     /**
1220      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1221      *
1222      * Requirements:
1223      *
1224      * - If `to` refers to a smart contract, it must implement
1225      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1226      * - `quantity` must be greater than 0.
1227      *
1228      * See {_mint}.
1229      *
1230      * Emits a {Transfer} event for each mint.
1231      */
1232     function _safeMint(
1233         address to,
1234         uint256 quantity,
1235         bytes memory _data
1236     ) internal {
1237         _mint(to, quantity);
1238 
1239         unchecked {
1240             if (to.code.length != 0) {
1241                 uint256 end = _currentIndex;
1242                 uint256 index = end - quantity;
1243                 do {
1244                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1245                         revert TransferToNonERC721ReceiverImplementer();
1246                     }
1247                 } while (index < end);
1248                 // Reentrancy protection.
1249                 if (_currentIndex != end) revert();
1250             }
1251         }
1252     }
1253 
1254     /**
1255      * @dev Mints `quantity` tokens and transfers them to `to`.
1256      *
1257      * Requirements:
1258      *
1259      * - `to` cannot be the zero address.
1260      * - `quantity` must be greater than 0.
1261      *
1262      * Emits a {Transfer} event for each mint.
1263      */
1264     function _mint(address to, uint256 quantity) internal {
1265         uint256 startTokenId = _currentIndex;
1266         if (to == address(0)) revert MintToZeroAddress();
1267         if (quantity == 0) revert MintZeroQuantity();
1268 
1269         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1270 
1271         // Overflows are incredibly unrealistic.
1272         // `balance` and `numberMinted` have a maximum limit of 2**64.
1273         // `tokenId` has a maximum limit of 2**256.
1274         unchecked {
1275             // Updates:
1276             // - `balance += quantity`.
1277             // - `numberMinted += quantity`.
1278             //
1279             // We can directly add to the `balance` and `numberMinted`.
1280             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1281 
1282             // Updates:
1283             // - `address` to the owner.
1284             // - `startTimestamp` to the timestamp of minting.
1285             // - `burned` to `false`.
1286             // - `nextInitialized` to `quantity == 1`.
1287             _packedOwnerships[startTokenId] = _packOwnershipData(
1288                 to,
1289                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1290             );
1291 
1292             uint256 tokenId = startTokenId;
1293             uint256 end = startTokenId + quantity;
1294             do {
1295                 emit Transfer(address(0), to, tokenId++);
1296             } while (tokenId < end);
1297 
1298             _currentIndex = end;
1299         }
1300         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1301     }
1302 
1303     /**
1304      * @dev Mints `quantity` tokens and transfers them to `to`.
1305      *
1306      * This function is intended for efficient minting only during contract creation.
1307      *
1308      * It emits only one {ConsecutiveTransfer} as defined in
1309      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1310      * instead of a sequence of {Transfer} event(s).
1311      *
1312      * Calling this function outside of contract creation WILL make your contract
1313      * non-compliant with the ERC721 standard.
1314      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1315      * {ConsecutiveTransfer} event is only permissible during contract creation.
1316      *
1317      * Requirements:
1318      *
1319      * - `to` cannot be the zero address.
1320      * - `quantity` must be greater than 0.
1321      *
1322      * Emits a {ConsecutiveTransfer} event.
1323      */
1324     function _mintERC2309(address to, uint256 quantity) internal {
1325         uint256 startTokenId = _currentIndex;
1326         if (to == address(0)) revert MintToZeroAddress();
1327         if (quantity == 0) revert MintZeroQuantity();
1328         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1329 
1330         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1331 
1332         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1333         unchecked {
1334             // Updates:
1335             // - `balance += quantity`.
1336             // - `numberMinted += quantity`.
1337             //
1338             // We can directly add to the `balance` and `numberMinted`.
1339             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1340 
1341             // Updates:
1342             // - `address` to the owner.
1343             // - `startTimestamp` to the timestamp of minting.
1344             // - `burned` to `false`.
1345             // - `nextInitialized` to `quantity == 1`.
1346             _packedOwnerships[startTokenId] = _packOwnershipData(
1347                 to,
1348                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1349             );
1350 
1351             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1352 
1353             _currentIndex = startTokenId + quantity;
1354         }
1355         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1356     }
1357 
1358     /**
1359      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1360      */
1361     function _getApprovedAddress(uint256 tokenId)
1362         private
1363         view
1364         returns (uint256 approvedAddressSlot, address approvedAddress)
1365     {
1366         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1367         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1368         assembly {
1369             // Compute the slot.
1370             mstore(0x00, tokenId)
1371             mstore(0x20, tokenApprovalsPtr.slot)
1372             approvedAddressSlot := keccak256(0x00, 0x40)
1373             // Load the slot's value from storage.
1374             approvedAddress := sload(approvedAddressSlot)
1375         }
1376     }
1377 
1378     /**
1379      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1380      */
1381     function _isOwnerOrApproved(
1382         address approvedAddress,
1383         address from,
1384         address msgSender
1385     ) private pure returns (bool result) {
1386         assembly {
1387             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1388             from := and(from, BITMASK_ADDRESS)
1389             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1390             msgSender := and(msgSender, BITMASK_ADDRESS)
1391             // `msgSender == from || msgSender == approvedAddress`.
1392             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1393         }
1394     }
1395 
1396     /**
1397      * @dev Transfers `tokenId` from `from` to `to`.
1398      *
1399      * Requirements:
1400      *
1401      * - `to` cannot be the zero address.
1402      * - `tokenId` token must be owned by `from`.
1403      *
1404      * Emits a {Transfer} event.
1405      */
1406     function transferFrom(
1407         address from,
1408         address to,
1409         uint256 tokenId
1410     ) public virtual override {
1411         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1412 
1413         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1414 
1415         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1416 
1417         // The nested ifs save around 20+ gas over a compound boolean condition.
1418         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1419             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1420 
1421         if (to == address(0)) revert TransferToZeroAddress();
1422 
1423         _beforeTokenTransfers(from, to, tokenId, 1);
1424 
1425         // Clear approvals from the previous owner.
1426         assembly {
1427             if approvedAddress {
1428                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1429                 sstore(approvedAddressSlot, 0)
1430             }
1431         }
1432 
1433         // Underflow of the sender's balance is impossible because we check for
1434         // ownership above and the recipient's balance can't realistically overflow.
1435         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1436         unchecked {
1437             // We can directly increment and decrement the balances.
1438             --_packedAddressData[from]; // Updates: `balance -= 1`.
1439             ++_packedAddressData[to]; // Updates: `balance += 1`.
1440 
1441             // Updates:
1442             // - `address` to the next owner.
1443             // - `startTimestamp` to the timestamp of transfering.
1444             // - `burned` to `false`.
1445             // - `nextInitialized` to `true`.
1446             _packedOwnerships[tokenId] = _packOwnershipData(
1447                 to,
1448                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1449             );
1450 
1451             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1452             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1453                 uint256 nextTokenId = tokenId + 1;
1454                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1455                 if (_packedOwnerships[nextTokenId] == 0) {
1456                     // If the next slot is within bounds.
1457                     if (nextTokenId != _currentIndex) {
1458                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1459                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1460                     }
1461                 }
1462             }
1463         }
1464 
1465         emit Transfer(from, to, tokenId);
1466         _afterTokenTransfers(from, to, tokenId, 1);
1467     }
1468 
1469     /**
1470      * @dev Equivalent to `_burn(tokenId, false)`.
1471      */
1472     function _burn(uint256 tokenId) internal virtual {
1473         _burn(tokenId, false);
1474     }
1475 
1476     /**
1477      * @dev Destroys `tokenId`.
1478      * The approval is cleared when the token is burned.
1479      *
1480      * Requirements:
1481      *
1482      * - `tokenId` must exist.
1483      *
1484      * Emits a {Transfer} event.
1485      */
1486     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1487         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1488 
1489         address from = address(uint160(prevOwnershipPacked));
1490 
1491         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1492 
1493         if (approvalCheck) {
1494             // The nested ifs save around 20+ gas over a compound boolean condition.
1495             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1496                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1497         }
1498 
1499         _beforeTokenTransfers(from, address(0), tokenId, 1);
1500 
1501         // Clear approvals from the previous owner.
1502         assembly {
1503             if approvedAddress {
1504                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1505                 sstore(approvedAddressSlot, 0)
1506             }
1507         }
1508 
1509         // Underflow of the sender's balance is impossible because we check for
1510         // ownership above and the recipient's balance can't realistically overflow.
1511         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1512         unchecked {
1513             // Updates:
1514             // - `balance -= 1`.
1515             // - `numberBurned += 1`.
1516             //
1517             // We can directly decrement the balance, and increment the number burned.
1518             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1519             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1520 
1521             // Updates:
1522             // - `address` to the last owner.
1523             // - `startTimestamp` to the timestamp of burning.
1524             // - `burned` to `true`.
1525             // - `nextInitialized` to `true`.
1526             _packedOwnerships[tokenId] = _packOwnershipData(
1527                 from,
1528                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1529             );
1530 
1531             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1532             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1533                 uint256 nextTokenId = tokenId + 1;
1534                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1535                 if (_packedOwnerships[nextTokenId] == 0) {
1536                     // If the next slot is within bounds.
1537                     if (nextTokenId != _currentIndex) {
1538                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1539                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1540                     }
1541                 }
1542             }
1543         }
1544 
1545         emit Transfer(from, address(0), tokenId);
1546         _afterTokenTransfers(from, address(0), tokenId, 1);
1547 
1548         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1549         unchecked {
1550             _burnCounter++;
1551         }
1552     }
1553 
1554     /**
1555      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1556      *
1557      * @param from address representing the previous owner of the given token ID
1558      * @param to target address that will receive the tokens
1559      * @param tokenId uint256 ID of the token to be transferred
1560      * @param _data bytes optional data to send along with the call
1561      * @return bool whether the call correctly returned the expected magic value
1562      */
1563     function _checkContractOnERC721Received(
1564         address from,
1565         address to,
1566         uint256 tokenId,
1567         bytes memory _data
1568     ) private returns (bool) {
1569         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1570             bytes4 retval
1571         ) {
1572             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1573         } catch (bytes memory reason) {
1574             if (reason.length == 0) {
1575                 revert TransferToNonERC721ReceiverImplementer();
1576             } else {
1577                 assembly {
1578                     revert(add(32, reason), mload(reason))
1579                 }
1580             }
1581         }
1582     }
1583 
1584     /**
1585      * @dev Directly sets the extra data for the ownership data `index`.
1586      */
1587     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1588         uint256 packed = _packedOwnerships[index];
1589         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1590         uint256 extraDataCasted;
1591         // Cast `extraData` with assembly to avoid redundant masking.
1592         assembly {
1593             extraDataCasted := extraData
1594         }
1595         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1596         _packedOwnerships[index] = packed;
1597     }
1598 
1599     /**
1600      * @dev Returns the next extra data for the packed ownership data.
1601      * The returned result is shifted into position.
1602      */
1603     function _nextExtraData(
1604         address from,
1605         address to,
1606         uint256 prevOwnershipPacked
1607     ) private view returns (uint256) {
1608         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1609         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1610     }
1611 
1612     /**
1613      * @dev Called during each token transfer to set the 24bit `extraData` field.
1614      * Intended to be overridden by the cosumer contract.
1615      *
1616      * `previousExtraData` - the value of `extraData` before transfer.
1617      *
1618      * Calling conditions:
1619      *
1620      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1621      * transferred to `to`.
1622      * - When `from` is zero, `tokenId` will be minted for `to`.
1623      * - When `to` is zero, `tokenId` will be burned by `from`.
1624      * - `from` and `to` are never both zero.
1625      */
1626     function _extraData(
1627         address from,
1628         address to,
1629         uint24 previousExtraData
1630     ) internal view virtual returns (uint24) {}
1631 
1632     /**
1633      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1634      * This includes minting.
1635      * And also called before burning one token.
1636      *
1637      * startTokenId - the first token id to be transferred
1638      * quantity - the amount to be transferred
1639      *
1640      * Calling conditions:
1641      *
1642      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1643      * transferred to `to`.
1644      * - When `from` is zero, `tokenId` will be minted for `to`.
1645      * - When `to` is zero, `tokenId` will be burned by `from`.
1646      * - `from` and `to` are never both zero.
1647      */
1648     function _beforeTokenTransfers(
1649         address from,
1650         address to,
1651         uint256 startTokenId,
1652         uint256 quantity
1653     ) internal virtual {}
1654 
1655     /**
1656      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1657      * This includes minting.
1658      * And also called after one token has been burned.
1659      *
1660      * startTokenId - the first token id to be transferred
1661      * quantity - the amount to be transferred
1662      *
1663      * Calling conditions:
1664      *
1665      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1666      * transferred to `to`.
1667      * - When `from` is zero, `tokenId` has been minted for `to`.
1668      * - When `to` is zero, `tokenId` has been burned by `from`.
1669      * - `from` and `to` are never both zero.
1670      */
1671     function _afterTokenTransfers(
1672         address from,
1673         address to,
1674         uint256 startTokenId,
1675         uint256 quantity
1676     ) internal virtual {}
1677 
1678     /**
1679      * @dev Returns the message sender (defaults to `msg.sender`).
1680      *
1681      * If you are writing GSN compatible contracts, you need to override this function.
1682      */
1683     function _msgSenderERC721A() internal view virtual returns (address) {
1684         return msg.sender;
1685     }
1686 
1687     /**
1688      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1689      */
1690     function _toString(uint256 value) internal pure returns (string memory ptr) {
1691         assembly {
1692             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1693             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1694             // We will need 1 32-byte word to store the length,
1695             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1696             ptr := add(mload(0x40), 128)
1697             // Update the free memory pointer to allocate.
1698             mstore(0x40, ptr)
1699 
1700             // Cache the end of the memory to calculate the length later.
1701             let end := ptr
1702 
1703             // We write the string from the rightmost digit to the leftmost digit.
1704             // The following is essentially a do-while loop that also handles the zero case.
1705             // Costs a bit more than early returning for the zero case,
1706             // but cheaper in terms of deployment and overall runtime costs.
1707             for {
1708                 // Initialize and perform the first pass without check.
1709                 let temp := value
1710                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1711                 ptr := sub(ptr, 1)
1712                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1713                 mstore8(ptr, add(48, mod(temp, 10)))
1714                 temp := div(temp, 10)
1715             } temp {
1716                 // Keep dividing `temp` until zero.
1717                 temp := div(temp, 10)
1718             } {
1719                 // Body of the for loop.
1720                 ptr := sub(ptr, 1)
1721                 mstore8(ptr, add(48, mod(temp, 10)))
1722             }
1723 
1724             let length := sub(end, ptr)
1725             // Move the pointer 32 bytes leftwards to make room for the length.
1726             ptr := sub(ptr, 32)
1727             // Store the length.
1728             mstore(ptr, length)
1729         }
1730     }
1731 }
1732 
1733 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1734 
1735 
1736 // ERC721A Contracts v4.1.0
1737 // Creator: Chiru Labs
1738 
1739 pragma solidity ^0.8.4;
1740 
1741 
1742 /**
1743  * @dev Interface of an ERC721AQueryable compliant contract.
1744  */
1745 interface IERC721AQueryable is IERC721A {
1746     /**
1747      * Invalid query range (`start` >= `stop`).
1748      */
1749     error InvalidQueryRange();
1750 
1751     /**
1752      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1753      *
1754      * If the `tokenId` is out of bounds:
1755      *   - `addr` = `address(0)`
1756      *   - `startTimestamp` = `0`
1757      *   - `burned` = `false`
1758      *
1759      * If the `tokenId` is burned:
1760      *   - `addr` = `<Address of owner before token was burned>`
1761      *   - `startTimestamp` = `<Timestamp when token was burned>`
1762      *   - `burned = `true`
1763      *
1764      * Otherwise:
1765      *   - `addr` = `<Address of owner>`
1766      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1767      *   - `burned = `false`
1768      */
1769     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1770 
1771     /**
1772      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1773      * See {ERC721AQueryable-explicitOwnershipOf}
1774      */
1775     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1776 
1777     /**
1778      * @dev Returns an array of token IDs owned by `owner`,
1779      * in the range [`start`, `stop`)
1780      * (i.e. `start <= tokenId < stop`).
1781      *
1782      * This function allows for tokens to be queried if the collection
1783      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1784      *
1785      * Requirements:
1786      *
1787      * - `start` < `stop`
1788      */
1789     function tokensOfOwnerIn(
1790         address owner,
1791         uint256 start,
1792         uint256 stop
1793     ) external view returns (uint256[] memory);
1794 
1795     /**
1796      * @dev Returns an array of token IDs owned by `owner`.
1797      *
1798      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1799      * It is meant to be called off-chain.
1800      *
1801      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1802      * multiple smaller scans if the collection is large enough to cause
1803      * an out-of-gas error (10K pfp collections should be fine).
1804      */
1805     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1806 }
1807 
1808 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1809 
1810 
1811 // ERC721A Contracts v4.1.0
1812 // Creator: Chiru Labs
1813 
1814 pragma solidity ^0.8.4;
1815 
1816 
1817 
1818 /**
1819  * @title ERC721A Queryable
1820  * @dev ERC721A subclass with convenience query functions.
1821  */
1822 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1823     /**
1824      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1825      *
1826      * If the `tokenId` is out of bounds:
1827      *   - `addr` = `address(0)`
1828      *   - `startTimestamp` = `0`
1829      *   - `burned` = `false`
1830      *   - `extraData` = `0`
1831      *
1832      * If the `tokenId` is burned:
1833      *   - `addr` = `<Address of owner before token was burned>`
1834      *   - `startTimestamp` = `<Timestamp when token was burned>`
1835      *   - `burned = `true`
1836      *   - `extraData` = `<Extra data when token was burned>`
1837      *
1838      * Otherwise:
1839      *   - `addr` = `<Address of owner>`
1840      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1841      *   - `burned = `false`
1842      *   - `extraData` = `<Extra data at start of ownership>`
1843      */
1844     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1845         TokenOwnership memory ownership;
1846         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1847             return ownership;
1848         }
1849         ownership = _ownershipAt(tokenId);
1850         if (ownership.burned) {
1851             return ownership;
1852         }
1853         return _ownershipOf(tokenId);
1854     }
1855 
1856     /**
1857      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1858      * See {ERC721AQueryable-explicitOwnershipOf}
1859      */
1860     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1861         unchecked {
1862             uint256 tokenIdsLength = tokenIds.length;
1863             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1864             for (uint256 i; i != tokenIdsLength; ++i) {
1865                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1866             }
1867             return ownerships;
1868         }
1869     }
1870 
1871     /**
1872      * @dev Returns an array of token IDs owned by `owner`,
1873      * in the range [`start`, `stop`)
1874      * (i.e. `start <= tokenId < stop`).
1875      *
1876      * This function allows for tokens to be queried if the collection
1877      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1878      *
1879      * Requirements:
1880      *
1881      * - `start` < `stop`
1882      */
1883     function tokensOfOwnerIn(
1884         address owner,
1885         uint256 start,
1886         uint256 stop
1887     ) external view override returns (uint256[] memory) {
1888         unchecked {
1889             if (start >= stop) revert InvalidQueryRange();
1890             uint256 tokenIdsIdx;
1891             uint256 stopLimit = _nextTokenId();
1892             // Set `start = max(start, _startTokenId())`.
1893             if (start < _startTokenId()) {
1894                 start = _startTokenId();
1895             }
1896             // Set `stop = min(stop, stopLimit)`.
1897             if (stop > stopLimit) {
1898                 stop = stopLimit;
1899             }
1900             uint256 tokenIdsMaxLength = balanceOf(owner);
1901             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1902             // to cater for cases where `balanceOf(owner)` is too big.
1903             if (start < stop) {
1904                 uint256 rangeLength = stop - start;
1905                 if (rangeLength < tokenIdsMaxLength) {
1906                     tokenIdsMaxLength = rangeLength;
1907                 }
1908             } else {
1909                 tokenIdsMaxLength = 0;
1910             }
1911             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1912             if (tokenIdsMaxLength == 0) {
1913                 return tokenIds;
1914             }
1915             // We need to call `explicitOwnershipOf(start)`,
1916             // because the slot at `start` may not be initialized.
1917             TokenOwnership memory ownership = explicitOwnershipOf(start);
1918             address currOwnershipAddr;
1919             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1920             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1921             if (!ownership.burned) {
1922                 currOwnershipAddr = ownership.addr;
1923             }
1924             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1925                 ownership = _ownershipAt(i);
1926                 if (ownership.burned) {
1927                     continue;
1928                 }
1929                 if (ownership.addr != address(0)) {
1930                     currOwnershipAddr = ownership.addr;
1931                 }
1932                 if (currOwnershipAddr == owner) {
1933                     tokenIds[tokenIdsIdx++] = i;
1934                 }
1935             }
1936             // Downsize the array to fit.
1937             assembly {
1938                 mstore(tokenIds, tokenIdsIdx)
1939             }
1940             return tokenIds;
1941         }
1942     }
1943 
1944     /**
1945      * @dev Returns an array of token IDs owned by `owner`.
1946      *
1947      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1948      * It is meant to be called off-chain.
1949      *
1950      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1951      * multiple smaller scans if the collection is large enough to cause
1952      * an out-of-gas error (10K pfp collections should be fine).
1953      */
1954     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1955         unchecked {
1956             uint256 tokenIdsIdx;
1957             address currOwnershipAddr;
1958             uint256 tokenIdsLength = balanceOf(owner);
1959             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1960             TokenOwnership memory ownership;
1961             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1962                 ownership = _ownershipAt(i);
1963                 if (ownership.burned) {
1964                     continue;
1965                 }
1966                 if (ownership.addr != address(0)) {
1967                     currOwnershipAddr = ownership.addr;
1968                 }
1969                 if (currOwnershipAddr == owner) {
1970                     tokenIds[tokenIdsIdx++] = i;
1971                 }
1972             }
1973             return tokenIds;
1974         }
1975     }
1976 }
1977 
1978 // File: contracts/metabirds.sol
1979 
1980 pragma solidity >=0.8.9 <0.9.0;
1981 
1982 contract MetaBirdsOfficial is ERC721AQueryable, Ownable, ReentrancyGuard {
1983 
1984   using Strings for uint256;
1985 
1986   bytes32 public merkleRoot;
1987   mapping(address => bool) public whitelistClaimed;
1988 
1989   string public uriPrefix = '';
1990   string public uriSuffix = '.json';
1991   string public hiddenMetadataUri;
1992   
1993   uint256 public cost;
1994   uint256 public maxSupply;
1995   uint256 public maxMintAmountPerTx;
1996 
1997   bool public paused = true;
1998   bool public whitelistMintEnabled = false;
1999   bool public revealed = false;
2000 
2001   address public devWallet = 0x2aAC035fB193429e18EA5AF33DCa3DA266448afF;
2002   address public projectWallet = 0x2aAC035fB193429e18EA5AF33DCa3DA266448afF;
2003   uint256 public addAN = 3;
2004   uint256 public addBN = 96;
2005 
2006   constructor() ERC721A("MetaBirdsOfficial", "MB") {
2007     cost = 0.1 ether;
2008     maxSupply = 10000;
2009     maxMintAmountPerTx = 50;
2010     hiddenMetadataUri = "ipfs://QmNtzArJMkkYpkbRBw3aToZ3WpZjbYKCm9aHG8EhDVNpM6";
2011   }
2012 
2013   modifier mintCompliance(uint256 _mintAmount) {
2014     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
2015     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
2016     _;
2017   }
2018 
2019   modifier mintPriceCompliance(uint256 _mintAmount) {
2020     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
2021     _;
2022   }
2023 
2024   modifier airdropMintCompliance(uint256 _mintAmount) {
2025     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
2026     _;
2027   }
2028 
2029   function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
2030     // Verify whitelist requirements
2031     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
2032     require(!whitelistClaimed[_msgSender()], 'Address already claimed!');
2033     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2034     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
2035 
2036     whitelistClaimed[_msgSender()] = true;
2037     _safeMint(_msgSender(), _mintAmount);
2038   }
2039 
2040   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
2041     require(!paused, 'The contract is paused!');
2042 
2043     _safeMint(_msgSender(), _mintAmount);
2044   }
2045 
2046   function airdropMint(uint256 _mintAmount) public payable airdropMintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) onlyOwner {
2047       _safeMint(_msgSender(), _mintAmount);
2048   }
2049   
2050   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
2051     _safeMint(_receiver, _mintAmount);
2052   }
2053 
2054   function _startTokenId() internal view virtual override returns (uint256) {
2055     return 1;
2056   }
2057 
2058   function setDiscountedMintPrice() public onlyOwner{
2059       cost = .05 ether;
2060   }
2061 
2062   function setDefaultMintPrice() public onlyOwner{
2063       cost = .1 ether;
2064   }
2065 
2066   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2067     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2068 
2069     if (revealed == false) {
2070       return hiddenMetadataUri;
2071     }
2072 
2073     string memory currentBaseURI = _baseURI();
2074     return bytes(currentBaseURI).length > 0
2075         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2076         : '';
2077   }
2078 
2079   function setRevealed(bool _state) public onlyOwner {
2080     revealed = _state;
2081   }
2082 
2083   function setCost(uint256 _cost) public onlyOwner {
2084     cost = _cost;
2085   }
2086 
2087   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2088     maxMintAmountPerTx = _maxMintAmountPerTx;
2089   }
2090 
2091   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2092     hiddenMetadataUri = _hiddenMetadataUri;
2093   }
2094 
2095   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2096     uriPrefix = _uriPrefix;
2097   }
2098 
2099   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2100     uriSuffix = _uriSuffix;
2101   }
2102 
2103   function setPaused(bool _state) public onlyOwner {
2104     paused = _state;
2105   }
2106 
2107   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2108     merkleRoot = _merkleRoot;
2109   }
2110 
2111   function setWhitelistMintEnabled(bool _state) public onlyOwner {
2112     whitelistMintEnabled = _state;
2113   }
2114 
2115   function setProjectWallet(address _address) external onlyOwner {
2116      projectWallet = _address;
2117   }
2118 
2119   function setDevWallet(address _devAddress) external onlyOwner {
2120      devWallet = _devAddress;
2121   }
2122 
2123   function setDevAmount(uint256 _amtD) external onlyOwner{
2124       addAN = _amtD;
2125   }
2126   function setProjectAmount(uint256 _amtP) external onlyOwner{
2127       addBN = _amtP;
2128   }
2129 
2130 
2131   function withdraw() public onlyOwner nonReentrant {
2132     uint256 contractBalance = address(this).balance;
2133     uint256  addANp = (contractBalance * addAN) / 100;
2134     uint256  addBNp = (contractBalance * addBN) / 100;
2135 
2136     (bool hs, ) = payable(devWallet).call{value: addANp}("");
2137     (hs, ) = payable(projectWallet).call{value: addBNp}("");
2138     require(hs);
2139 
2140     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2141     require(os);
2142 
2143   }
2144 
2145   function _baseURI() internal view virtual override returns (string memory) {
2146     return uriPrefix;
2147   }
2148 }