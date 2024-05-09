1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev String operations.
5  */
6 library Strings {
7     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
8     uint8 private constant _ADDRESS_LENGTH = 20;
9 
10     /**
11      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
12      */
13     function toString(uint256 value) internal pure returns (string memory) {
14         // Inspired by OraclizeAPI's implementation - MIT licence
15         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
16 
17         if (value == 0) {
18             return "0";
19         }
20         uint256 temp = value;
21         uint256 digits;
22         while (temp != 0) {
23             digits++;
24             temp /= 10;
25         }
26         bytes memory buffer = new bytes(digits);
27         while (value != 0) {
28             digits -= 1;
29             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
30             value /= 10;
31         }
32         return string(buffer);
33     }
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
37      */
38     function toHexString(uint256 value) internal pure returns (string memory) {
39         if (value == 0) {
40             return "0x00";
41         }
42         uint256 temp = value;
43         uint256 length = 0;
44         while (temp != 0) {
45             length++;
46             temp >>= 8;
47         }
48         return toHexString(value, length);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
53      */
54     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
55         bytes memory buffer = new bytes(2 * length + 2);
56         buffer[0] = "0";
57         buffer[1] = "x";
58         for (uint256 i = 2 * length + 1; i > 1; --i) {
59             buffer[i] = _HEX_SYMBOLS[value & 0xf];
60             value >>= 4;
61         }
62         require(value == 0, "Strings: hex length insufficient");
63         return string(buffer);
64     }
65 
66     /**
67      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
68      */
69     function toHexString(address addr) internal pure returns (string memory) {
70         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
75 
76 
77 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev These functions deal with verification of Merkle Tree proofs.
83  *
84  * The proofs can be generated using the JavaScript library
85  * https://github.com/miguelmota/merkletreejs[merkletreejs].
86  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
87  *
88  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
89  *
90  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
91  * hashing, or use a hash function other than keccak256 for hashing leaves.
92  * This is because the concatenation of a sorted pair of internal nodes in
93  * the merkle tree could be reinterpreted as a leaf value.
94  */
95 library MerkleProof {
96     /**
97      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
98      * defined by `root`. For this, a `proof` must be provided, containing
99      * sibling hashes on the branch from the leaf to the root of the tree. Each
100      * pair of leaves and each pair of pre-images are assumed to be sorted.
101      */
102     function verify(
103         bytes32[] memory proof,
104         bytes32 root,
105         bytes32 leaf
106     ) internal pure returns (bool) {
107         return processProof(proof, leaf) == root;
108     }
109 
110     /**
111      * @dev Calldata version of {verify}
112      *
113      * _Available since v4.7._
114      */
115     function verifyCalldata(
116         bytes32[] calldata proof,
117         bytes32 root,
118         bytes32 leaf
119     ) internal pure returns (bool) {
120         return processProofCalldata(proof, leaf) == root;
121     }
122 
123     /**
124      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
125      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
126      * hash matches the root of the tree. When processing the proof, the pairs
127      * of leafs & pre-images are assumed to be sorted.
128      *
129      * _Available since v4.4._
130      */
131     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
132         bytes32 computedHash = leaf;
133         for (uint256 i = 0; i < proof.length; i++) {
134             computedHash = _hashPair(computedHash, proof[i]);
135         }
136         return computedHash;
137     }
138 
139     /**
140      * @dev Calldata version of {processProof}
141      *
142      * _Available since v4.7._
143      */
144     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
145         bytes32 computedHash = leaf;
146         for (uint256 i = 0; i < proof.length; i++) {
147             computedHash = _hashPair(computedHash, proof[i]);
148         }
149         return computedHash;
150     }
151 
152     /**
153      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
154      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
155      *
156      * _Available since v4.7._
157      */
158     function multiProofVerify(
159         bytes32[] memory proof,
160         bool[] memory proofFlags,
161         bytes32 root,
162         bytes32[] memory leaves
163     ) internal pure returns (bool) {
164         return processMultiProof(proof, proofFlags, leaves) == root;
165     }
166 
167     /**
168      * @dev Calldata version of {multiProofVerify}
169      *
170      * _Available since v4.7._
171      */
172     function multiProofVerifyCalldata(
173         bytes32[] calldata proof,
174         bool[] calldata proofFlags,
175         bytes32 root,
176         bytes32[] memory leaves
177     ) internal pure returns (bool) {
178         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
179     }
180 
181     /**
182      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
183      * consuming from one or the other at each step according to the instructions given by
184      * `proofFlags`.
185      *
186      * _Available since v4.7._
187      */
188     function processMultiProof(
189         bytes32[] memory proof,
190         bool[] memory proofFlags,
191         bytes32[] memory leaves
192     ) internal pure returns (bytes32 merkleRoot) {
193         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
194         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
195         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
196         // the merkle tree.
197         uint256 leavesLen = leaves.length;
198         uint256 totalHashes = proofFlags.length;
199 
200         // Check proof validity.
201         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
202 
203         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
204         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
205         bytes32[] memory hashes = new bytes32[](totalHashes);
206         uint256 leafPos = 0;
207         uint256 hashPos = 0;
208         uint256 proofPos = 0;
209         // At each step, we compute the next hash using two values:
210         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
211         //   get the next hash.
212         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
213         //   `proof` array.
214         for (uint256 i = 0; i < totalHashes; i++) {
215             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
216             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
217             hashes[i] = _hashPair(a, b);
218         }
219 
220         if (totalHashes > 0) {
221             return hashes[totalHashes - 1];
222         } else if (leavesLen > 0) {
223             return leaves[0];
224         } else {
225             return proof[0];
226         }
227     }
228 
229     /**
230      * @dev Calldata version of {processMultiProof}
231      *
232      * _Available since v4.7._
233      */
234     function processMultiProofCalldata(
235         bytes32[] calldata proof,
236         bool[] calldata proofFlags,
237         bytes32[] memory leaves
238     ) internal pure returns (bytes32 merkleRoot) {
239         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
240         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
241         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
242         // the merkle tree.
243         uint256 leavesLen = leaves.length;
244         uint256 totalHashes = proofFlags.length;
245 
246         // Check proof validity.
247         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
248 
249         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
250         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
251         bytes32[] memory hashes = new bytes32[](totalHashes);
252         uint256 leafPos = 0;
253         uint256 hashPos = 0;
254         uint256 proofPos = 0;
255         // At each step, we compute the next hash using two values:
256         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
257         //   get the next hash.
258         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
259         //   `proof` array.
260         for (uint256 i = 0; i < totalHashes; i++) {
261             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
262             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
263             hashes[i] = _hashPair(a, b);
264         }
265 
266         if (totalHashes > 0) {
267             return hashes[totalHashes - 1];
268         } else if (leavesLen > 0) {
269             return leaves[0];
270         } else {
271             return proof[0];
272         }
273     }
274 
275     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
276         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
277     }
278 
279     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
280         /// @solidity memory-safe-assembly
281         assembly {
282             mstore(0x00, a)
283             mstore(0x20, b)
284             value := keccak256(0x00, 0x40)
285         }
286     }
287 }
288 
289 // File: @openzeppelin/contracts/utils/Context.sol
290 
291 
292 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
293 
294 pragma solidity ^0.8.0;
295 
296 /**
297  * @dev Provides information about the current execution context, including the
298  * sender of the transaction and its data. While these are generally available
299  * via msg.sender and msg.data, they should not be accessed in such a direct
300  * manner, since when dealing with meta-transactions the account sending and
301  * paying for execution may not be the actual sender (as far as an application
302  * is concerned).
303  *
304  * This contract is only required for intermediate, library-like contracts.
305  */
306 abstract contract Context {
307     function _msgSender() internal view virtual returns (address) {
308         return msg.sender;
309     }
310 
311     function _msgData() internal view virtual returns (bytes calldata) {
312         return msg.data;
313     }
314 }
315 
316 // File: @openzeppelin/contracts/access/Ownable.sol
317 
318 
319 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 
324 /**
325  * @dev Contract module which provides a basic access control mechanism, where
326  * there is an account (an owner) that can be granted exclusive access to
327  * specific functions.
328  *
329  * By default, the owner account will be the one that deploys the contract. This
330  * can later be changed with {transferOwnership}.
331  *
332  * This module is used through inheritance. It will make available the modifier
333  * `onlyOwner`, which can be applied to your functions to restrict their use to
334  * the owner.
335  */
336 abstract contract Ownable is Context {
337     address private _owner;
338 
339     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
340 
341     /**
342      * @dev Initializes the contract setting the deployer as the initial owner.
343      */
344     constructor() {
345         _transferOwnership(_msgSender());
346     }
347 
348     /**
349      * @dev Throws if called by any account other than the owner.
350      */
351     modifier onlyOwner() {
352         _checkOwner();
353         _;
354     }
355 
356     /**
357      * @dev Returns the address of the current owner.
358      */
359     function owner() public view virtual returns (address) {
360         return _owner;
361     }
362 
363     /**
364      * @dev Throws if the sender is not the owner.
365      */
366     function _checkOwner() internal view virtual {
367         require(owner() == _msgSender(), "Ownable: caller is not the owner");
368     }
369 
370     /**
371      * @dev Leaves the contract without owner. It will not be possible to call
372      * `onlyOwner` functions anymore. Can only be called by the current owner.
373      *
374      * NOTE: Renouncing ownership will leave the contract without an owner,
375      * thereby removing any functionality that is only available to the owner.
376      */
377     function renounceOwnership() public virtual onlyOwner {
378         _transferOwnership(address(0));
379     }
380 
381     /**
382      * @dev Transfers ownership of the contract to a new account (`newOwner`).
383      * Can only be called by the current owner.
384      */
385     function transferOwnership(address newOwner) public virtual onlyOwner {
386         require(newOwner != address(0), "Ownable: new owner is the zero address");
387         _transferOwnership(newOwner);
388     }
389 
390     /**
391      * @dev Transfers ownership of the contract to a new account (`newOwner`).
392      * Internal function without access restriction.
393      */
394     function _transferOwnership(address newOwner) internal virtual {
395         address oldOwner = _owner;
396         _owner = newOwner;
397         emit OwnershipTransferred(oldOwner, newOwner);
398     }
399 }
400 
401 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
402 
403 
404 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 /**
409  * @dev Interface of the ERC165 standard, as defined in the
410  * https://eips.ethereum.org/EIPS/eip-165[EIP].
411  *
412  * Implementers can declare support of contract interfaces, which can then be
413  * queried by others ({ERC165Checker}).
414  *
415  * For an implementation, see {ERC165}.
416  */
417 interface IERC165 {
418     /**
419      * @dev Returns true if this contract implements the interface defined by
420      * `interfaceId`. See the corresponding
421      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
422      * to learn more about how these ids are created.
423      *
424      * This function call must use less than 30 000 gas.
425      */
426     function supportsInterface(bytes4 interfaceId) external view returns (bool);
427 }
428 
429 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
430 
431 
432 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
433 
434 pragma solidity ^0.8.0;
435 
436 
437 /**
438  * @dev Interface for the NFT Royalty Standard.
439  *
440  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
441  * support for royalty payments across all NFT marketplaces and ecosystem participants.
442  *
443  * _Available since v4.5._
444  */
445 interface IERC2981 is IERC165 {
446     /**
447      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
448      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
449      */
450     function royaltyInfo(uint256 tokenId, uint256 salePrice)
451         external
452         view
453         returns (address receiver, uint256 royaltyAmount);
454 }
455 
456 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
457 
458 
459 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 /**
464  * @dev Interface of the ERC20 standard as defined in the EIP.
465  */
466 interface IERC20 {
467     /**
468      * @dev Emitted when `value` tokens are moved from one account (`from`) to
469      * another (`to`).
470      *
471      * Note that `value` may be zero.
472      */
473     event Transfer(address indexed from, address indexed to, uint256 value);
474 
475     /**
476      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
477      * a call to {approve}. `value` is the new allowance.
478      */
479     event Approval(address indexed owner, address indexed spender, uint256 value);
480 
481     /**
482      * @dev Returns the amount of tokens in existence.
483      */
484     function totalSupply() external view returns (uint256);
485 
486     /**
487      * @dev Returns the amount of tokens owned by `account`.
488      */
489     function balanceOf(address account) external view returns (uint256);
490 
491     /**
492      * @dev Moves `amount` tokens from the caller's account to `to`.
493      *
494      * Returns a boolean value indicating whether the operation succeeded.
495      *
496      * Emits a {Transfer} event.
497      */
498     function transfer(address to, uint256 amount) external returns (bool);
499 
500     /**
501      * @dev Returns the remaining number of tokens that `spender` will be
502      * allowed to spend on behalf of `owner` through {transferFrom}. This is
503      * zero by default.
504      *
505      * This value changes when {approve} or {transferFrom} are called.
506      */
507     function allowance(address owner, address spender) external view returns (uint256);
508 
509     /**
510      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
511      *
512      * Returns a boolean value indicating whether the operation succeeded.
513      *
514      * IMPORTANT: Beware that changing an allowance with this method brings the risk
515      * that someone may use both the old and the new allowance by unfortunate
516      * transaction ordering. One possible solution to mitigate this race
517      * condition is to first reduce the spender's allowance to 0 and set the
518      * desired value afterwards:
519      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
520      *
521      * Emits an {Approval} event.
522      */
523     function approve(address spender, uint256 amount) external returns (bool);
524 
525     /**
526      * @dev Moves `amount` tokens from `from` to `to` using the
527      * allowance mechanism. `amount` is then deducted from the caller's
528      * allowance.
529      *
530      * Returns a boolean value indicating whether the operation succeeded.
531      *
532      * Emits a {Transfer} event.
533      */
534     function transferFrom(
535         address from,
536         address to,
537         uint256 amount
538     ) external returns (bool);
539 }
540 
541 // File: @openzeppelin/contracts/interfaces/IERC20.sol
542 
543 
544 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 
549 // File: Noji/IERC721A.sol
550 
551 
552 // ERC721A Contracts v4.2.2
553 // Creator: Chiru Labs
554 
555 pragma solidity ^0.8.4;
556 
557 /**
558  * @dev Interface of ERC721A.
559  */
560 interface IERC721A {
561     /**
562      * The caller must own the token or be an approved operator.
563      */
564     error ApprovalCallerNotOwnerNorApproved();
565 
566     /**
567      * The token does not exist.
568      */
569     error ApprovalQueryForNonexistentToken();
570 
571     /**
572      * The caller cannot approve to their own address.
573      */
574     error ApproveToCaller();
575 
576     /**
577      * Cannot query the balance for the zero address.
578      */
579     error BalanceQueryForZeroAddress();
580 
581     /**
582      * Cannot mint to the zero address.
583      */
584     error MintToZeroAddress();
585 
586     /**
587      * The quantity of tokens minted must be more than zero.
588      */
589     error MintZeroQuantity();
590 
591     /**
592      * The token does not exist.
593      */
594     error OwnerQueryForNonexistentToken();
595 
596     /**
597      * The caller must own the token or be an approved operator.
598      */
599     error TransferCallerNotOwnerNorApproved();
600 
601     /**
602      * The token must be owned by `from`.
603      */
604     error TransferFromIncorrectOwner();
605 
606     /**
607      * Cannot safely transfer to a contract that does not implement the
608      * ERC721Receiver interface.
609      */
610     error TransferToNonERC721ReceiverImplementer();
611 
612     /**
613      * Cannot transfer to the zero address.
614      */
615     error TransferToZeroAddress();
616 
617     /**
618      * The token does not exist.
619      */
620     error URIQueryForNonexistentToken();
621 
622     /**
623      * The `quantity` minted with ERC2309 exceeds the safety limit.
624      */
625     error MintERC2309QuantityExceedsLimit();
626 
627     /**
628      * The `extraData` cannot be set on an unintialized ownership slot.
629      */
630     error OwnershipNotInitializedForExtraData();
631 
632     // =============================================================
633     //                            STRUCTS
634     // =============================================================
635 
636     struct TokenOwnership {
637         // The address of the owner.
638         address addr;
639         // Stores the start time of ownership with minimal overhead for tokenomics.
640         uint64 startTimestamp;
641         // Whether the token has been burned.
642         bool burned;
643         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
644         uint24 extraData;
645     }
646 
647     // =============================================================
648     //                         TOKEN COUNTERS
649     // =============================================================
650 
651     /**
652      * @dev Returns the total number of tokens in existence.
653      * Burned tokens will reduce the count.
654      * To get the total number of tokens minted, please see {_totalMinted}.
655      */
656     function totalSupply() external view returns (uint256);
657 
658     // =============================================================
659     //                            IERC165
660     // =============================================================
661 
662     /**
663      * @dev Returns true if this contract implements the interface defined by
664      * `interfaceId`. See the corresponding
665      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
666      * to learn more about how these ids are created.
667      *
668      * This function call must use less than 30000 gas.
669      */
670     function supportsInterface(bytes4 interfaceId) external view returns (bool);
671 
672     // =============================================================
673     //                            IERC721
674     // =============================================================
675 
676     /**
677      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
678      */
679     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
680 
681     /**
682      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
683      */
684     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
685 
686     /**
687      * @dev Emitted when `owner` enables or disables
688      * (`approved`) `operator` to manage all of its assets.
689      */
690     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
691 
692     /**
693      * @dev Returns the number of tokens in `owner`'s account.
694      */
695     function balanceOf(address owner) external view returns (uint256 balance);
696 
697     /**
698      * @dev Returns the owner of the `tokenId` token.
699      *
700      * Requirements:
701      *
702      * - `tokenId` must exist.
703      */
704     function ownerOf(uint256 tokenId) external view returns (address owner);
705 
706     /**
707      * @dev Safely transfers `tokenId` token from `from` to `to`,
708      * checking first that contract recipients are aware of the ERC721 protocol
709      * to prevent tokens from being forever locked.
710      *
711      * Requirements:
712      *
713      * - `from` cannot be the zero address.
714      * - `to` cannot be the zero address.
715      * - `tokenId` token must exist and be owned by `from`.
716      * - If the caller is not `from`, it must be have been allowed to move
717      * this token by either {approve} or {setApprovalForAll}.
718      * - If `to` refers to a smart contract, it must implement
719      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
720      *
721      * Emits a {Transfer} event.
722      */
723     function safeTransferFrom(
724         address from,
725         address to,
726         uint256 tokenId,
727         bytes calldata data
728     ) external;
729 
730     /**
731      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
732      */
733     function safeTransferFrom(
734         address from,
735         address to,
736         uint256 tokenId
737     ) external;
738 
739     /**
740      * @dev Transfers `tokenId` from `from` to `to`.
741      *
742      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
743      * whenever possible.
744      *
745      * Requirements:
746      *
747      * - `from` cannot be the zero address.
748      * - `to` cannot be the zero address.
749      * - `tokenId` token must be owned by `from`.
750      * - If the caller is not `from`, it must be approved to move this token
751      * by either {approve} or {setApprovalForAll}.
752      *
753      * Emits a {Transfer} event.
754      */
755     function transferFrom(
756         address from,
757         address to,
758         uint256 tokenId
759     ) external;
760 
761     /**
762      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
763      * The approval is cleared when the token is transferred.
764      *
765      * Only a single account can be approved at a time, so approving the
766      * zero address clears previous approvals.
767      *
768      * Requirements:
769      *
770      * - The caller must own the token or be an approved operator.
771      * - `tokenId` must exist.
772      *
773      * Emits an {Approval} event.
774      */
775     function approve(address to, uint256 tokenId) external;
776 
777     /**
778      * @dev Approve or remove `operator` as an operator for the caller.
779      * Operators can call {transferFrom} or {safeTransferFrom}
780      * for any token owned by the caller.
781      *
782      * Requirements:
783      *
784      * - The `operator` cannot be the caller.
785      *
786      * Emits an {ApprovalForAll} event.
787      */
788     function setApprovalForAll(address operator, bool _approved) external;
789 
790     /**
791      * @dev Returns the account approved for `tokenId` token.
792      *
793      * Requirements:
794      *
795      * - `tokenId` must exist.
796      */
797     function getApproved(uint256 tokenId) external view returns (address operator);
798 
799     /**
800      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
801      *
802      * See {setApprovalForAll}.
803      */
804     function isApprovedForAll(address owner, address operator) external view returns (bool);
805 
806     // =============================================================
807     //                        IERC721Metadata
808     // =============================================================
809 
810     /**
811      * @dev Returns the token collection name.
812      */
813     function name() external view returns (string memory);
814 
815     /**
816      * @dev Returns the token collection symbol.
817      */
818     function symbol() external view returns (string memory);
819 
820     /**
821      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
822      */
823     function tokenURI(uint256 tokenId) external view returns (string memory);
824 
825     // =============================================================
826     //                           IERC2309
827     // =============================================================
828 
829     /**
830      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
831      * (inclusive) is transferred from `from` to `to`, as defined in the
832      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
833      *
834      * See {_mintERC2309} for more details.
835      */
836     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
837 }
838 // File: Noji/ERC721A.sol
839 
840 
841 // ERC721A Contracts v4.2.2
842 // Creator: Chiru Labs
843 
844 pragma solidity ^0.8.4;
845 
846 
847 /**
848  * @dev Interface of ERC721 token receiver.
849  */
850 interface ERC721A__IERC721Receiver {
851     function onERC721Received(
852         address operator,
853         address from,
854         uint256 tokenId,
855         bytes calldata data
856     ) external returns (bytes4);
857 }
858 
859 /**
860  * @title ERC721A
861  *
862  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
863  * Non-Fungible Token Standard, including the Metadata extension.
864  * Optimized for lower gas during batch mints.
865  *
866  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
867  * starting from `_startTokenId()`.
868  *
869  * Assumptions:
870  *
871  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
872  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
873  */
874 contract ERC721A is IERC721A {
875     // Reference type for token approval.
876     struct TokenApprovalRef {
877         address value;
878     }
879 
880     // =============================================================
881     //                           CONSTANTS
882     // =============================================================
883 
884     // Mask of an entry in packed address data.
885     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
886 
887     // The bit position of `numberMinted` in packed address data.
888     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
889 
890     // The bit position of `numberBurned` in packed address data.
891     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
892 
893     // The bit position of `aux` in packed address data.
894     uint256 private constant _BITPOS_AUX = 192;
895 
896     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
897     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
898 
899     // The bit position of `startTimestamp` in packed ownership.
900     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
901 
902     // The bit mask of the `burned` bit in packed ownership.
903     uint256 private constant _BITMASK_BURNED = 1 << 224;
904 
905     // The bit position of the `nextInitialized` bit in packed ownership.
906     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
907 
908     // The bit mask of the `nextInitialized` bit in packed ownership.
909     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
910 
911     // The bit position of `extraData` in packed ownership.
912     uint256 private constant _BITPOS_EXTRA_DATA = 232;
913 
914     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
915     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
916 
917     // The mask of the lower 160 bits for addresses.
918     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
919 
920     // The maximum `quantity` that can be minted with {_mintERC2309}.
921     // This limit is to prevent overflows on the address data entries.
922     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
923     // is required to cause an overflow, which is unrealistic.
924     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
925 
926     // The `Transfer` event signature is given by:
927     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
928     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
929         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
930 
931     // =============================================================
932     //                            STORAGE
933     // =============================================================
934 
935     // The next token ID to be minted.
936     uint256 private _currentIndex;
937 
938     // The number of tokens burned.
939     uint256 private _burnCounter;
940 
941     // Token name
942     string private _name;
943 
944     // Token symbol
945     string private _symbol;
946 
947     // Mapping from token ID to ownership details
948     // An empty struct value does not necessarily mean the token is unowned.
949     // See {_packedOwnershipOf} implementation for details.
950     //
951     // Bits Layout:
952     // - [0..159]   `addr`
953     // - [160..223] `startTimestamp`
954     // - [224]      `burned`
955     // - [225]      `nextInitialized`
956     // - [232..255] `extraData`
957     mapping(uint256 => uint256) private _packedOwnerships;
958 
959     // Mapping owner address to address data.
960     //
961     // Bits Layout:
962     // - [0..63]    `balance`
963     // - [64..127]  `numberMinted`
964     // - [128..191] `numberBurned`
965     // - [192..255] `aux`
966     mapping(address => uint256) private _packedAddressData;
967 
968     // Mapping from token ID to approved address.
969     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
970 
971     // Mapping from owner to operator approvals
972     mapping(address => mapping(address => bool)) private _operatorApprovals;
973 
974     // =============================================================
975     //                          CONSTRUCTOR
976     // =============================================================
977 
978     constructor(string memory name_, string memory symbol_) {
979         _name = name_;
980         _symbol = symbol_;
981         _currentIndex = _startTokenId();
982     }
983 
984     // =============================================================
985     //                   TOKEN COUNTING OPERATIONS
986     // =============================================================
987 
988     /**
989      * @dev Returns the starting token ID.
990      * To change the starting token ID, please override this function.
991      */
992     function _startTokenId() internal view virtual returns (uint256) {
993         return 0;
994     }
995 
996     /**
997      * @dev Returns the next token ID to be minted.
998      */
999     function _nextTokenId() internal view virtual returns (uint256) {
1000         return _currentIndex;
1001     }
1002 
1003     /**
1004      * @dev Returns the total number of tokens in existence.
1005      * Burned tokens will reduce the count.
1006      * To get the total number of tokens minted, please see {_totalMinted}.
1007      */
1008     function totalSupply() public view virtual override returns (uint256) {
1009         // Counter underflow is impossible as _burnCounter cannot be incremented
1010         // more than `_currentIndex - _startTokenId()` times.
1011         unchecked {
1012             return _currentIndex - _burnCounter - _startTokenId();
1013         }
1014     }
1015 
1016     /**
1017      * @dev Returns the total amount of tokens minted in the contract.
1018      */
1019     function _totalMinted() internal view virtual returns (uint256) {
1020         // Counter underflow is impossible as `_currentIndex` does not decrement,
1021         // and it is initialized to `_startTokenId()`.
1022         unchecked {
1023             return _currentIndex - _startTokenId();
1024         }
1025     }
1026 
1027     /**
1028      * @dev Returns the total number of tokens burned.
1029      */
1030     function _totalBurned() internal view virtual returns (uint256) {
1031         return _burnCounter;
1032     }
1033 
1034     // =============================================================
1035     //                    ADDRESS DATA OPERATIONS
1036     // =============================================================
1037 
1038     /**
1039      * @dev Returns the number of tokens in `owner`'s account.
1040      */
1041     function balanceOf(address owner) public view virtual override returns (uint256) {
1042         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1043         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1044     }
1045 
1046     /**
1047      * Returns the number of tokens minted by `owner`.
1048      */
1049     function _numberMinted(address owner) internal view returns (uint256) {
1050         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1051     }
1052 
1053     /**
1054      * Returns the number of tokens burned by or on behalf of `owner`.
1055      */
1056     function _numberBurned(address owner) internal view returns (uint256) {
1057         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1058     }
1059 
1060     /**
1061      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1062      */
1063     function _getAux(address owner) internal view returns (uint64) {
1064         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1065     }
1066 
1067     /**
1068      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1069      * If there are multiple variables, please pack them into a uint64.
1070      */
1071     function _setAux(address owner, uint64 aux) internal virtual {
1072         uint256 packed = _packedAddressData[owner];
1073         uint256 auxCasted;
1074         // Cast `aux` with assembly to avoid redundant masking.
1075         assembly {
1076             auxCasted := aux
1077         }
1078         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1079         _packedAddressData[owner] = packed;
1080     }
1081 
1082     // =============================================================
1083     //                            IERC165
1084     // =============================================================
1085 
1086     /**
1087      * @dev Returns true if this contract implements the interface defined by
1088      * `interfaceId`. See the corresponding
1089      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1090      * to learn more about how these ids are created.
1091      *
1092      * This function call must use less than 30000 gas.
1093      */
1094     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1095         // The interface IDs are constants representing the first 4 bytes
1096         // of the XOR of all function selectors in the interface.
1097         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1098         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1099         return
1100             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1101             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1102             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1103     }
1104 
1105     // =============================================================
1106     //                        IERC721Metadata
1107     // =============================================================
1108 
1109     /**
1110      * @dev Returns the token collection name.
1111      */
1112     function name() public view virtual override returns (string memory) {
1113         return _name;
1114     }
1115 
1116     /**
1117      * @dev Returns the token collection symbol.
1118      */
1119     function symbol() public view virtual override returns (string memory) {
1120         return _symbol;
1121     }
1122 
1123     /**
1124      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1125      */
1126     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1127         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1128 
1129         string memory baseURI = _baseURI();
1130         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1131     }
1132 
1133     /**
1134      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1135      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1136      * by default, it can be overridden in child contracts.
1137      */
1138     function _baseURI() internal view virtual returns (string memory) {
1139         return '';
1140     }
1141 
1142     // =============================================================
1143     //                     OWNERSHIPS OPERATIONS
1144     // =============================================================
1145 
1146     /**
1147      * @dev Returns the owner of the `tokenId` token.
1148      *
1149      * Requirements:
1150      *
1151      * - `tokenId` must exist.
1152      */
1153     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1154         return address(uint160(_packedOwnershipOf(tokenId)));
1155     }
1156 
1157     /**
1158      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1159      * It gradually moves to O(1) as tokens get transferred around over time.
1160      */
1161     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1162         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1163     }
1164 
1165     /**
1166      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1167      */
1168     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1169         return _unpackedOwnership(_packedOwnerships[index]);
1170     }
1171 
1172     /**
1173      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1174      */
1175     function _initializeOwnershipAt(uint256 index) internal virtual {
1176         if (_packedOwnerships[index] == 0) {
1177             _packedOwnerships[index] = _packedOwnershipOf(index);
1178         }
1179     }
1180 
1181     /**
1182      * Returns the packed ownership data of `tokenId`.
1183      */
1184     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1185         uint256 curr = tokenId;
1186 
1187         unchecked {
1188             if (_startTokenId() <= curr)
1189                 if (curr < _currentIndex) {
1190                     uint256 packed = _packedOwnerships[curr];
1191                     // If not burned.
1192                     if (packed & _BITMASK_BURNED == 0) {
1193                         // Invariant:
1194                         // There will always be an initialized ownership slot
1195                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1196                         // before an unintialized ownership slot
1197                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1198                         // Hence, `curr` will not underflow.
1199                         //
1200                         // We can directly compare the packed value.
1201                         // If the address is zero, packed will be zero.
1202                         while (packed == 0) {
1203                             packed = _packedOwnerships[--curr];
1204                         }
1205                         return packed;
1206                     }
1207                 }
1208         }
1209         revert OwnerQueryForNonexistentToken();
1210     }
1211 
1212     /**
1213      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1214      */
1215     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1216         ownership.addr = address(uint160(packed));
1217         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1218         ownership.burned = packed & _BITMASK_BURNED != 0;
1219         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1220     }
1221 
1222     /**
1223      * @dev Packs ownership data into a single uint256.
1224      */
1225     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1226         assembly {
1227             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1228             owner := and(owner, _BITMASK_ADDRESS)
1229             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1230             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1231         }
1232     }
1233 
1234     /**
1235      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1236      */
1237     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1238         // For branchless setting of the `nextInitialized` flag.
1239         assembly {
1240             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1241             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1242         }
1243     }
1244 
1245     // =============================================================
1246     //                      APPROVAL OPERATIONS
1247     // =============================================================
1248 
1249     /**
1250      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1251      * The approval is cleared when the token is transferred.
1252      *
1253      * Only a single account can be approved at a time, so approving the
1254      * zero address clears previous approvals.
1255      *
1256      * Requirements:
1257      *
1258      * - The caller must own the token or be an approved operator.
1259      * - `tokenId` must exist.
1260      *
1261      * Emits an {Approval} event.
1262      */
1263     function approve(address to, uint256 tokenId) public virtual override {
1264         address owner = ownerOf(tokenId);
1265 
1266         if (_msgSenderERC721A() != owner)
1267             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1268                 revert ApprovalCallerNotOwnerNorApproved();
1269             }
1270 
1271         _tokenApprovals[tokenId].value = to;
1272         emit Approval(owner, to, tokenId);
1273     }
1274 
1275     /**
1276      * @dev Returns the account approved for `tokenId` token.
1277      *
1278      * Requirements:
1279      *
1280      * - `tokenId` must exist.
1281      */
1282     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1283         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1284 
1285         return _tokenApprovals[tokenId].value;
1286     }
1287 
1288     /**
1289      * @dev Approve or remove `operator` as an operator for the caller.
1290      * Operators can call {transferFrom} or {safeTransferFrom}
1291      * for any token owned by the caller.
1292      *
1293      * Requirements:
1294      *
1295      * - The `operator` cannot be the caller.
1296      *
1297      * Emits an {ApprovalForAll} event.
1298      */
1299     function setApprovalForAll(address operator, bool approved) public virtual override {
1300         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1301 
1302         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1303         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1304     }
1305 
1306     /**
1307      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1308      *
1309      * See {setApprovalForAll}.
1310      */
1311     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1312         return _operatorApprovals[owner][operator];
1313     }
1314 
1315     /**
1316      * @dev Returns whether `tokenId` exists.
1317      *
1318      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1319      *
1320      * Tokens start existing when they are minted. See {_mint}.
1321      */
1322     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1323         return
1324             _startTokenId() <= tokenId &&
1325             tokenId < _currentIndex && // If within bounds,
1326             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1327     }
1328 
1329     /**
1330      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1331      */
1332     function _isSenderApprovedOrOwner(
1333         address approvedAddress,
1334         address owner,
1335         address msgSender
1336     ) private pure returns (bool result) {
1337         assembly {
1338             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1339             owner := and(owner, _BITMASK_ADDRESS)
1340             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1341             msgSender := and(msgSender, _BITMASK_ADDRESS)
1342             // `msgSender == owner || msgSender == approvedAddress`.
1343             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1344         }
1345     }
1346 
1347     /**
1348      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1349      */
1350     function _getApprovedSlotAndAddress(uint256 tokenId)
1351         private
1352         view
1353         returns (uint256 approvedAddressSlot, address approvedAddress)
1354     {
1355         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1356         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1357         assembly {
1358             approvedAddressSlot := tokenApproval.slot
1359             approvedAddress := sload(approvedAddressSlot)
1360         }
1361     }
1362 
1363     // =============================================================
1364     //                      TRANSFER OPERATIONS
1365     // =============================================================
1366 
1367     /**
1368      * @dev Transfers `tokenId` from `from` to `to`.
1369      *
1370      * Requirements:
1371      *
1372      * - `from` cannot be the zero address.
1373      * - `to` cannot be the zero address.
1374      * - `tokenId` token must be owned by `from`.
1375      * - If the caller is not `from`, it must be approved to move this token
1376      * by either {approve} or {setApprovalForAll}.
1377      *
1378      * Emits a {Transfer} event.
1379      */
1380     function transferFrom(
1381         address from,
1382         address to,
1383         uint256 tokenId
1384     ) public virtual override {
1385         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1386 
1387         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1388 
1389         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1390 
1391         // The nested ifs save around 20+ gas over a compound boolean condition.
1392         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1393             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1394 
1395         if (to == address(0)) revert TransferToZeroAddress();
1396 
1397         _beforeTokenTransfers(from, to, tokenId, 1);
1398 
1399         // Clear approvals from the previous owner.
1400         assembly {
1401             if approvedAddress {
1402                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1403                 sstore(approvedAddressSlot, 0)
1404             }
1405         }
1406 
1407         // Underflow of the sender's balance is impossible because we check for
1408         // ownership above and the recipient's balance can't realistically overflow.
1409         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1410         unchecked {
1411             // We can directly increment and decrement the balances.
1412             --_packedAddressData[from]; // Updates: `balance -= 1`.
1413             ++_packedAddressData[to]; // Updates: `balance += 1`.
1414 
1415             // Updates:
1416             // - `address` to the next owner.
1417             // - `startTimestamp` to the timestamp of transfering.
1418             // - `burned` to `false`.
1419             // - `nextInitialized` to `true`.
1420             _packedOwnerships[tokenId] = _packOwnershipData(
1421                 to,
1422                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1423             );
1424 
1425             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1426             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1427                 uint256 nextTokenId = tokenId + 1;
1428                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1429                 if (_packedOwnerships[nextTokenId] == 0) {
1430                     // If the next slot is within bounds.
1431                     if (nextTokenId != _currentIndex) {
1432                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1433                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1434                     }
1435                 }
1436             }
1437         }
1438 
1439         emit Transfer(from, to, tokenId);
1440         _afterTokenTransfers(from, to, tokenId, 1);
1441     }
1442 
1443     /**
1444      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1445      */
1446     function safeTransferFrom(
1447         address from,
1448         address to,
1449         uint256 tokenId
1450     ) public virtual override {
1451         safeTransferFrom(from, to, tokenId, '');
1452     }
1453 
1454     /**
1455      * @dev Safely transfers `tokenId` token from `from` to `to`.
1456      *
1457      * Requirements:
1458      *
1459      * - `from` cannot be the zero address.
1460      * - `to` cannot be the zero address.
1461      * - `tokenId` token must exist and be owned by `from`.
1462      * - If the caller is not `from`, it must be approved to move this token
1463      * by either {approve} or {setApprovalForAll}.
1464      * - If `to` refers to a smart contract, it must implement
1465      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1466      *
1467      * Emits a {Transfer} event.
1468      */
1469     function safeTransferFrom(
1470         address from,
1471         address to,
1472         uint256 tokenId,
1473         bytes memory _data
1474     ) public virtual override {
1475         transferFrom(from, to, tokenId);
1476         if (to.code.length != 0)
1477             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1478                 revert TransferToNonERC721ReceiverImplementer();
1479             }
1480     }
1481 
1482     /**
1483      * @dev Hook that is called before a set of serially-ordered token IDs
1484      * are about to be transferred. This includes minting.
1485      * And also called before burning one token.
1486      *
1487      * `startTokenId` - the first token ID to be transferred.
1488      * `quantity` - the amount to be transferred.
1489      *
1490      * Calling conditions:
1491      *
1492      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1493      * transferred to `to`.
1494      * - When `from` is zero, `tokenId` will be minted for `to`.
1495      * - When `to` is zero, `tokenId` will be burned by `from`.
1496      * - `from` and `to` are never both zero.
1497      */
1498     function _beforeTokenTransfers(
1499         address from,
1500         address to,
1501         uint256 startTokenId,
1502         uint256 quantity
1503     ) internal virtual {}
1504 
1505     /**
1506      * @dev Hook that is called after a set of serially-ordered token IDs
1507      * have been transferred. This includes minting.
1508      * And also called after one token has been burned.
1509      *
1510      * `startTokenId` - the first token ID to be transferred.
1511      * `quantity` - the amount to be transferred.
1512      *
1513      * Calling conditions:
1514      *
1515      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1516      * transferred to `to`.
1517      * - When `from` is zero, `tokenId` has been minted for `to`.
1518      * - When `to` is zero, `tokenId` has been burned by `from`.
1519      * - `from` and `to` are never both zero.
1520      */
1521     function _afterTokenTransfers(
1522         address from,
1523         address to,
1524         uint256 startTokenId,
1525         uint256 quantity
1526     ) internal virtual {}
1527 
1528     /**
1529      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1530      *
1531      * `from` - Previous owner of the given token ID.
1532      * `to` - Target address that will receive the token.
1533      * `tokenId` - Token ID to be transferred.
1534      * `_data` - Optional data to send along with the call.
1535      *
1536      * Returns whether the call correctly returned the expected magic value.
1537      */
1538     function _checkContractOnERC721Received(
1539         address from,
1540         address to,
1541         uint256 tokenId,
1542         bytes memory _data
1543     ) private returns (bool) {
1544         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1545             bytes4 retval
1546         ) {
1547             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1548         } catch (bytes memory reason) {
1549             if (reason.length == 0) {
1550                 revert TransferToNonERC721ReceiverImplementer();
1551             } else {
1552                 assembly {
1553                     revert(add(32, reason), mload(reason))
1554                 }
1555             }
1556         }
1557     }
1558 
1559     // =============================================================
1560     //                        MINT OPERATIONS
1561     // =============================================================
1562 
1563     /**
1564      * @dev Mints `quantity` tokens and transfers them to `to`.
1565      *
1566      * Requirements:
1567      *
1568      * - `to` cannot be the zero address.
1569      * - `quantity` must be greater than 0.
1570      *
1571      * Emits a {Transfer} event for each mint.
1572      */
1573     function _mint(address to, uint256 quantity) internal virtual {
1574         uint256 startTokenId = _currentIndex;
1575         if (quantity == 0) revert MintZeroQuantity();
1576 
1577         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1578 
1579         // Overflows are incredibly unrealistic.
1580         // `balance` and `numberMinted` have a maximum limit of 2**64.
1581         // `tokenId` has a maximum limit of 2**256.
1582         unchecked {
1583             // Updates:
1584             // - `balance += quantity`.
1585             // - `numberMinted += quantity`.
1586             //
1587             // We can directly add to the `balance` and `numberMinted`.
1588             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1589 
1590             // Updates:
1591             // - `address` to the owner.
1592             // - `startTimestamp` to the timestamp of minting.
1593             // - `burned` to `false`.
1594             // - `nextInitialized` to `quantity == 1`.
1595             _packedOwnerships[startTokenId] = _packOwnershipData(
1596                 to,
1597                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1598             );
1599 
1600             uint256 toMasked;
1601             uint256 end = startTokenId + quantity;
1602 
1603             // Use assembly to loop and emit the `Transfer` event for gas savings.
1604             // The duplicated `log4` removes an extra check and reduces stack juggling.
1605             // The assembly, together with the surrounding Solidity code, have been
1606             // delicately arranged to nudge the compiler into producing optimized opcodes.
1607             assembly {
1608                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1609                 toMasked := and(to, _BITMASK_ADDRESS)
1610                 // Emit the `Transfer` event.
1611                 log4(
1612                     0, // Start of data (0, since no data).
1613                     0, // End of data (0, since no data).
1614                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1615                     0, // `address(0)`.
1616                     toMasked, // `to`.
1617                     startTokenId // `tokenId`.
1618                 )
1619 
1620                 for {
1621                     let tokenId := add(startTokenId, 1)
1622                 } iszero(eq(tokenId, end)) {
1623                     tokenId := add(tokenId, 1)
1624                 } {
1625                     // Emit the `Transfer` event. Similar to above.
1626                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1627                 }
1628             }
1629             if (toMasked == 0) revert MintToZeroAddress();
1630 
1631             _currentIndex = end;
1632         }
1633         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1634     }
1635 
1636     /**
1637      * @dev Mints `quantity` tokens and transfers them to `to`.
1638      *
1639      * This function is intended for efficient minting only during contract creation.
1640      *
1641      * It emits only one {ConsecutiveTransfer} as defined in
1642      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1643      * instead of a sequence of {Transfer} event(s).
1644      *
1645      * Calling this function outside of contract creation WILL make your contract
1646      * non-compliant with the ERC721 standard.
1647      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1648      * {ConsecutiveTransfer} event is only permissible during contract creation.
1649      *
1650      * Requirements:
1651      *
1652      * - `to` cannot be the zero address.
1653      * - `quantity` must be greater than 0.
1654      *
1655      * Emits a {ConsecutiveTransfer} event.
1656      */
1657     function _mintERC2309(address to, uint256 quantity) internal virtual {
1658         uint256 startTokenId = _currentIndex;
1659         if (to == address(0)) revert MintToZeroAddress();
1660         if (quantity == 0) revert MintZeroQuantity();
1661         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1662 
1663         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1664 
1665         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1666         unchecked {
1667             // Updates:
1668             // - `balance += quantity`.
1669             // - `numberMinted += quantity`.
1670             //
1671             // We can directly add to the `balance` and `numberMinted`.
1672             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1673 
1674             // Updates:
1675             // - `address` to the owner.
1676             // - `startTimestamp` to the timestamp of minting.
1677             // - `burned` to `false`.
1678             // - `nextInitialized` to `quantity == 1`.
1679             _packedOwnerships[startTokenId] = _packOwnershipData(
1680                 to,
1681                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1682             );
1683 
1684             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1685 
1686             _currentIndex = startTokenId + quantity;
1687         }
1688         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1689     }
1690 
1691     /**
1692      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1693      *
1694      * Requirements:
1695      *
1696      * - If `to` refers to a smart contract, it must implement
1697      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1698      * - `quantity` must be greater than 0.
1699      *
1700      * See {_mint}.
1701      *
1702      * Emits a {Transfer} event for each mint.
1703      */
1704     function _safeMint(
1705         address to,
1706         uint256 quantity,
1707         bytes memory _data
1708     ) internal virtual {
1709         _mint(to, quantity);
1710 
1711         unchecked {
1712             if (to.code.length != 0) {
1713                 uint256 end = _currentIndex;
1714                 uint256 index = end - quantity;
1715                 do {
1716                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1717                         revert TransferToNonERC721ReceiverImplementer();
1718                     }
1719                 } while (index < end);
1720                 // Reentrancy protection.
1721                 if (_currentIndex != end) revert();
1722             }
1723         }
1724     }
1725 
1726     /**
1727      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1728      */
1729     function _safeMint(address to, uint256 quantity) internal virtual {
1730         _safeMint(to, quantity, '');
1731     }
1732 
1733     // =============================================================
1734     //                        BURN OPERATIONS
1735     // =============================================================
1736 
1737     /**
1738      * @dev Equivalent to `_burn(tokenId, false)`.
1739      */
1740     function _burn(uint256 tokenId) internal virtual {
1741         _burn(tokenId, false);
1742     }
1743 
1744     /**
1745      * @dev Destroys `tokenId`.
1746      * The approval is cleared when the token is burned.
1747      *
1748      * Requirements:
1749      *
1750      * - `tokenId` must exist.
1751      *
1752      * Emits a {Transfer} event.
1753      */
1754     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1755         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1756 
1757         address from = address(uint160(prevOwnershipPacked));
1758 
1759         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1760 
1761         if (approvalCheck) {
1762             // The nested ifs save around 20+ gas over a compound boolean condition.
1763             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1764                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1765         }
1766 
1767         _beforeTokenTransfers(from, address(0), tokenId, 1);
1768 
1769         // Clear approvals from the previous owner.
1770         assembly {
1771             if approvedAddress {
1772                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1773                 sstore(approvedAddressSlot, 0)
1774             }
1775         }
1776 
1777         // Underflow of the sender's balance is impossible because we check for
1778         // ownership above and the recipient's balance can't realistically overflow.
1779         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1780         unchecked {
1781             // Updates:
1782             // - `balance -= 1`.
1783             // - `numberBurned += 1`.
1784             //
1785             // We can directly decrement the balance, and increment the number burned.
1786             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1787             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1788 
1789             // Updates:
1790             // - `address` to the last owner.
1791             // - `startTimestamp` to the timestamp of burning.
1792             // - `burned` to `true`.
1793             // - `nextInitialized` to `true`.
1794             _packedOwnerships[tokenId] = _packOwnershipData(
1795                 from,
1796                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1797             );
1798 
1799             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1800             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1801                 uint256 nextTokenId = tokenId + 1;
1802                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1803                 if (_packedOwnerships[nextTokenId] == 0) {
1804                     // If the next slot is within bounds.
1805                     if (nextTokenId != _currentIndex) {
1806                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1807                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1808                     }
1809                 }
1810             }
1811         }
1812 
1813         emit Transfer(from, address(0), tokenId);
1814         _afterTokenTransfers(from, address(0), tokenId, 1);
1815 
1816         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1817         unchecked {
1818             _burnCounter++;
1819         }
1820     }
1821 
1822     // =============================================================
1823     //                     EXTRA DATA OPERATIONS
1824     // =============================================================
1825 
1826     /**
1827      * @dev Directly sets the extra data for the ownership data `index`.
1828      */
1829     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1830         uint256 packed = _packedOwnerships[index];
1831         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1832         uint256 extraDataCasted;
1833         // Cast `extraData` with assembly to avoid redundant masking.
1834         assembly {
1835             extraDataCasted := extraData
1836         }
1837         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1838         _packedOwnerships[index] = packed;
1839     }
1840 
1841     /**
1842      * @dev Called during each token transfer to set the 24bit `extraData` field.
1843      * Intended to be overridden by the cosumer contract.
1844      *
1845      * `previousExtraData` - the value of `extraData` before transfer.
1846      *
1847      * Calling conditions:
1848      *
1849      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1850      * transferred to `to`.
1851      * - When `from` is zero, `tokenId` will be minted for `to`.
1852      * - When `to` is zero, `tokenId` will be burned by `from`.
1853      * - `from` and `to` are never both zero.
1854      */
1855     function _extraData(
1856         address from,
1857         address to,
1858         uint24 previousExtraData
1859     ) internal view virtual returns (uint24) {}
1860 
1861     /**
1862      * @dev Returns the next extra data for the packed ownership data.
1863      * The returned result is shifted into position.
1864      */
1865     function _nextExtraData(
1866         address from,
1867         address to,
1868         uint256 prevOwnershipPacked
1869     ) private view returns (uint256) {
1870         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1871         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1872     }
1873 
1874     // =============================================================
1875     //                       OTHER OPERATIONS
1876     // =============================================================
1877 
1878     /**
1879      * @dev Returns the message sender (defaults to `msg.sender`).
1880      *
1881      * If you are writing GSN compatible contracts, you need to override this function.
1882      */
1883     function _msgSenderERC721A() internal view virtual returns (address) {
1884         return msg.sender;
1885     }
1886 
1887     /**
1888      * @dev Converts a uint256 to its ASCII string decimal representation.
1889      */
1890     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1891         assembly {
1892             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1893             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aligned.
1894             // We will need 1 32-byte word to store the length,
1895             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1896             str := add(mload(0x40), 0x80)
1897             // Update the free memory pointer to allocate.
1898             mstore(0x40, str)
1899 
1900             // Cache the end of the memory to calculate the length later.
1901             let end := str
1902 
1903             // We write the string from rightmost digit to leftmost digit.
1904             // The following is essentially a do-while loop that also handles the zero case.
1905             // prettier-ignore
1906             for { let temp := value } 1 {} {
1907                 str := sub(str, 1)
1908                 // Write the character to the pointer.
1909                 // The ASCII index of the '0' character is 48.
1910                 mstore8(str, add(48, mod(temp, 10)))
1911                 // Keep dividing `temp` until zero.
1912                 temp := div(temp, 10)
1913                 // prettier-ignore
1914                 if iszero(temp) { break }
1915             }
1916 
1917             let length := sub(end, str)
1918             // Move the pointer 32 bytes leftwards to make room for the length.
1919             str := sub(str, 0x20)
1920             // Store the length.
1921             mstore(str, length)
1922         }
1923     }
1924 }
1925 // File: Noji/Noji.sol
1926 
1927 
1928 
1929 pragma solidity ^0.8.4;
1930 
1931 
1932 
1933 
1934 
1935 
1936 
1937 contract Noji is ERC721A, IERC2981, Ownable {
1938     using Strings for uint256;
1939 
1940     uint256 public MAX_SUPPLY = 1500;
1941     uint256 public MAX_SALE_SUPPLY = 1500;
1942     uint256 public MAX_NOJI_PER_WALLET = 1;
1943     uint256 public OGLIST_SALE_PRICE ;
1944     uint256 public WHITELIST_SALE_PRICE ;
1945     uint256 public PUBLIC_SALE_PRICE ;
1946     uint96 public royaltyFeesInBips = 1000;
1947 
1948     address public royaltyAddress;
1949 
1950     string baseURI;
1951     string public placeholderTokenUri;
1952 
1953     bool public isRevealed = false;
1954     bool public isPaused = true;
1955     bool public isOGListMintActive = false;
1956     bool public isWhiteListMintActive = false;
1957     bool public isPublicMintActive = false;
1958     bool public isTeamMintActive = false;
1959     bool public isAirdropClaimActive = false;
1960 
1961     bytes32 public ogListMerkleRoot;
1962     bytes32 public whiteListMerkleRoot;
1963     bytes32 public teamListMerkleRoot;
1964 
1965     struct airdropData {
1966         uint256 qty;
1967         bool hasClaimed;
1968     }
1969 
1970     mapping(address => bool) public teamListClaimed;
1971     mapping(address => uint256) nojiPerAddress;
1972     mapping(address => airdropData) airdropList;
1973 
1974     modifier callerIsUser() {
1975         require(tx.origin == msg.sender, "Caller is another contract");
1976         _;
1977     }
1978 
1979     modifier mintIsActive(bool category) {
1980         require(!isPaused, "Minting paused");
1981         require(category, "List minting not active");
1982         _;
1983     }
1984 
1985     modifier canAfford(uint256 categoryPrice, uint256 qty) {
1986         require(msg.value >= categoryPrice * qty, "Insufficient Funds");
1987         _;
1988     }
1989 
1990     modifier canMint(uint256 qty) {
1991         require(qty > 0, "Mint at least 1 Noji");
1992         require(
1993             totalSupply() + qty <= MAX_SALE_SUPPLY,
1994             "Cannot mint beyound Max Supply"
1995         );
1996         require(
1997             nojiPerAddress[msg.sender] + qty <= MAX_NOJI_PER_WALLET,
1998             "Max Noji per Wallet exceded"
1999         );
2000         _;
2001     }
2002 
2003     modifier isValidMerkleProof(
2004         bytes32[] calldata merkleProof,
2005         bytes32 merkleRoot
2006     ) {
2007         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2008         require(
2009             MerkleProof.verify(merkleProof, merkleRoot, leaf),
2010             "Address not listed"
2011         );
2012         _;
2013     }
2014 
2015     constructor(address _admin,address royaltyAddress_,string memory _placeholderTokenUri) ERC721A("Noji", "NOJI") {
2016         royaltyAddress = royaltyAddress_;
2017         placeholderTokenUri = _placeholderTokenUri;
2018         _safeMint(_admin, 150);
2019     }
2020 
2021     function publicMint(uint256 qty)
2022         public
2023         payable
2024         callerIsUser
2025         mintIsActive(isPublicMintActive)
2026         canAfford(PUBLIC_SALE_PRICE, qty)
2027         canMint(qty)
2028     {
2029         _safeMint(msg.sender, qty);
2030     }
2031 
2032     function oglistMint(uint256 qty, bytes32[] calldata merkleProof)
2033         public
2034         payable
2035        callerIsUser
2036        mintIsActive(isOGListMintActive)
2037        canAfford(OGLIST_SALE_PRICE, qty)
2038         canMint(qty)
2039        isValidMerkleProof(merkleProof, ogListMerkleRoot)
2040     {
2041           nojiPerAddress[msg.sender] += qty;
2042         _safeMint(msg.sender, qty);
2043     }
2044 
2045     function whitelistMint(uint256 qty, bytes32[] calldata merkleProof)
2046         public
2047         payable
2048         callerIsUser
2049         mintIsActive(isWhiteListMintActive)
2050         canAfford(WHITELIST_SALE_PRICE, qty)
2051         canMint(qty)
2052         isValidMerkleProof(merkleProof, whiteListMerkleRoot)
2053     {
2054         nojiPerAddress[msg.sender] += qty;
2055         _safeMint(msg.sender, qty);
2056     }
2057 
2058     function teamMint(bytes32[] calldata merkleProof)
2059         public
2060         callerIsUser
2061         mintIsActive(isTeamMintActive)
2062         canMint(1)
2063         isValidMerkleProof(merkleProof, teamListMerkleRoot)
2064     {
2065         require(!teamListClaimed[msg.sender], "Noji already claimed");
2066         teamListClaimed[msg.sender] = true;
2067         _safeMint(msg.sender, 1);
2068     }
2069 
2070     
2071 
2072     function togglePause() external onlyOwner {
2073         isPaused = !isPaused;
2074     }
2075 
2076     function toggleOGListMint() external onlyOwner {
2077         isOGListMintActive = !isOGListMintActive;
2078     }
2079 
2080     function toggleWhiteListMint() external onlyOwner {
2081         isWhiteListMintActive = !isWhiteListMintActive;
2082     }
2083 
2084     function togglePublicMint() external onlyOwner {
2085         isPublicMintActive = !isPublicMintActive;
2086     }
2087 
2088     function toggleTeamMint() external onlyOwner {
2089         isTeamMintActive = !isTeamMintActive;
2090     }
2091 
2092    
2093 
2094     function _baseURI() internal view override returns (string memory) {
2095         return baseURI;
2096     }
2097 
2098     function setBaseURI(string memory uri) public onlyOwner {
2099         baseURI = uri;
2100     }
2101   
2102 
2103     function tokenURI(uint256 tokenId)
2104         public
2105         view
2106         virtual
2107         override
2108         returns (string memory)
2109     {
2110         require(_exists(tokenId), "nonexistent token");
2111 
2112         if (!isRevealed) {
2113             return placeholderTokenUri;
2114         }
2115 
2116         return
2117             bytes(baseURI).length > 0
2118                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
2119                 : "";
2120     }
2121 
2122     function setPlaceHolderTokenUri(string memory uri) external onlyOwner {
2123         placeholderTokenUri = uri;
2124     }
2125 
2126     function toggleReveal() public onlyOwner {
2127         isRevealed = !isRevealed;
2128     }
2129 
2130     function setMaxSupply(uint256 supply) external onlyOwner {
2131         MAX_SUPPLY = supply;
2132     }
2133 
2134     function setMaxSaleSupply(uint256 supply) external onlyOwner {
2135         MAX_SALE_SUPPLY = supply;
2136     }
2137 
2138     function setOGListMerkleRoot(bytes32 merkleRoot) external onlyOwner {
2139         ogListMerkleRoot = merkleRoot;
2140     }
2141 
2142     function setWhiteListMerkleRoot(bytes32 merkleRoot) external onlyOwner {
2143         whiteListMerkleRoot = merkleRoot;
2144     }
2145 
2146     function setTeamListMerkleRoot(bytes32 merkleRoot) external onlyOwner {
2147         teamListMerkleRoot = merkleRoot;
2148     }
2149 
2150     function setMaxNojiPerWallet(uint256 num) public onlyOwner {
2151         MAX_NOJI_PER_WALLET = num;
2152     }
2153 
2154 
2155     function royaltyInfo(uint256 tokenId, uint256 salePrice)
2156         external
2157         view
2158         virtual
2159         override
2160         returns (address receiver, uint256 royaltyAmount)
2161     {
2162         return (royaltyAddress, (salePrice * royaltyFeesInBips) / 10000);
2163     }
2164 
2165     function setRoyaltyInfo(address receiver, uint8 _royaltyFeesInBips)
2166         public
2167         onlyOwner
2168     {
2169         require(_royaltyFeesInBips <= 10000, "Royalty fee high");
2170         royaltyAddress = receiver;
2171         royaltyFeesInBips = _royaltyFeesInBips;
2172     }
2173 
2174     function withdraw() external onlyOwner {
2175         uint256 balance = address(this).balance;
2176         require(balance > 0, "No payout to withdraw");
2177         (bool success, ) = payable(msg.sender).call{value: balance}("");
2178         require(success, "Withdrawal failed");
2179     }
2180 
2181     function withdrawTokens(IERC20 token) public onlyOwner {
2182         uint256 balance = token.balanceOf(address(this));
2183         token.transfer(msg.sender, balance);
2184     }
2185 
2186     function supportsInterface(bytes4 interfaceId)
2187         public
2188         view
2189         virtual
2190         override(ERC721A, IERC165)
2191         returns (bool)
2192     {
2193         return
2194             interfaceId == type(IERC2981).interfaceId ||
2195             super.supportsInterface(interfaceId);
2196     }
2197 
2198     receive() external payable {}
2199 }