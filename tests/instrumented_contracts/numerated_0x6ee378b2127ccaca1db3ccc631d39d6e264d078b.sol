1 // SPDX-License-Identifier: MIXED
2 
3 // Sources flattened with hardhat v2.9.3 https://hardhat.org
4 
5 // File @openzeppelin/contracts/utils/Context.sol@v4.7.0
6 
7 // License-Identifier: MIT
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 
33 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.0
34 
35 // License-Identifier: MIT
36 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _transferOwnership(_msgSender());
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         _checkOwner();
69         _;
70     }
71 
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view virtual returns (address) {
76         return _owner;
77     }
78 
79     /**
80      * @dev Throws if the sender is not the owner.
81      */
82     function _checkOwner() internal view virtual {
83         require(owner() == _msgSender(), "Ownable: caller is not the owner");
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions anymore. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby removing any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public virtual onlyOwner {
94         _transferOwnership(address(0));
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         _transferOwnership(newOwner);
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Internal function without access restriction.
109      */
110     function _transferOwnership(address newOwner) internal virtual {
111         address oldOwner = _owner;
112         _owner = newOwner;
113         emit OwnershipTransferred(oldOwner, newOwner);
114     }
115 }
116 
117 
118 // File @openzeppelin/contracts/security/Pausable.sol@v4.7.0
119 
120 // License-Identifier: MIT
121 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev Contract module which allows children to implement an emergency stop
127  * mechanism that can be triggered by an authorized account.
128  *
129  * This module is used through inheritance. It will make available the
130  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
131  * the functions of your contract. Note that they will not be pausable by
132  * simply including this module, only once the modifiers are put in place.
133  */
134 abstract contract Pausable is Context {
135     /**
136      * @dev Emitted when the pause is triggered by `account`.
137      */
138     event Paused(address account);
139 
140     /**
141      * @dev Emitted when the pause is lifted by `account`.
142      */
143     event Unpaused(address account);
144 
145     bool private _paused;
146 
147     /**
148      * @dev Initializes the contract in unpaused state.
149      */
150     constructor() {
151         _paused = false;
152     }
153 
154     /**
155      * @dev Modifier to make a function callable only when the contract is not paused.
156      *
157      * Requirements:
158      *
159      * - The contract must not be paused.
160      */
161     modifier whenNotPaused() {
162         _requireNotPaused();
163         _;
164     }
165 
166     /**
167      * @dev Modifier to make a function callable only when the contract is paused.
168      *
169      * Requirements:
170      *
171      * - The contract must be paused.
172      */
173     modifier whenPaused() {
174         _requirePaused();
175         _;
176     }
177 
178     /**
179      * @dev Returns true if the contract is paused, and false otherwise.
180      */
181     function paused() public view virtual returns (bool) {
182         return _paused;
183     }
184 
185     /**
186      * @dev Throws if the contract is paused.
187      */
188     function _requireNotPaused() internal view virtual {
189         require(!paused(), "Pausable: paused");
190     }
191 
192     /**
193      * @dev Throws if the contract is not paused.
194      */
195     function _requirePaused() internal view virtual {
196         require(paused(), "Pausable: not paused");
197     }
198 
199     /**
200      * @dev Triggers stopped state.
201      *
202      * Requirements:
203      *
204      * - The contract must not be paused.
205      */
206     function _pause() internal virtual whenNotPaused {
207         _paused = true;
208         emit Paused(_msgSender());
209     }
210 
211     /**
212      * @dev Returns to normal state.
213      *
214      * Requirements:
215      *
216      * - The contract must be paused.
217      */
218     function _unpause() internal virtual whenPaused {
219         _paused = false;
220         emit Unpaused(_msgSender());
221     }
222 }
223 
224 
225 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.7.0
226 
227 // License-Identifier: MIT
228 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
229 
230 pragma solidity ^0.8.0;
231 
232 /**
233  * @dev These functions deal with verification of Merkle Tree proofs.
234  *
235  * The proofs can be generated using the JavaScript library
236  * https://github.com/miguelmota/merkletreejs[merkletreejs].
237  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
238  *
239  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
240  *
241  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
242  * hashing, or use a hash function other than keccak256 for hashing leaves.
243  * This is because the concatenation of a sorted pair of internal nodes in
244  * the merkle tree could be reinterpreted as a leaf value.
245  */
246 library MerkleProof {
247     /**
248      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
249      * defined by `root`. For this, a `proof` must be provided, containing
250      * sibling hashes on the branch from the leaf to the root of the tree. Each
251      * pair of leaves and each pair of pre-images are assumed to be sorted.
252      */
253     function verify(
254         bytes32[] memory proof,
255         bytes32 root,
256         bytes32 leaf
257     ) internal pure returns (bool) {
258         return processProof(proof, leaf) == root;
259     }
260 
261     /**
262      * @dev Calldata version of {verify}
263      *
264      * _Available since v4.7._
265      */
266     function verifyCalldata(
267         bytes32[] calldata proof,
268         bytes32 root,
269         bytes32 leaf
270     ) internal pure returns (bool) {
271         return processProofCalldata(proof, leaf) == root;
272     }
273 
274     /**
275      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
276      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
277      * hash matches the root of the tree. When processing the proof, the pairs
278      * of leafs & pre-images are assumed to be sorted.
279      *
280      * _Available since v4.4._
281      */
282     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
283         bytes32 computedHash = leaf;
284         for (uint256 i = 0; i < proof.length; i++) {
285             computedHash = _hashPair(computedHash, proof[i]);
286         }
287         return computedHash;
288     }
289 
290     /**
291      * @dev Calldata version of {processProof}
292      *
293      * _Available since v4.7._
294      */
295     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
296         bytes32 computedHash = leaf;
297         for (uint256 i = 0; i < proof.length; i++) {
298             computedHash = _hashPair(computedHash, proof[i]);
299         }
300         return computedHash;
301     }
302 
303     /**
304      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
305      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
306      *
307      * _Available since v4.7._
308      */
309     function multiProofVerify(
310         bytes32[] memory proof,
311         bool[] memory proofFlags,
312         bytes32 root,
313         bytes32[] memory leaves
314     ) internal pure returns (bool) {
315         return processMultiProof(proof, proofFlags, leaves) == root;
316     }
317 
318     /**
319      * @dev Calldata version of {multiProofVerify}
320      *
321      * _Available since v4.7._
322      */
323     function multiProofVerifyCalldata(
324         bytes32[] calldata proof,
325         bool[] calldata proofFlags,
326         bytes32 root,
327         bytes32[] memory leaves
328     ) internal pure returns (bool) {
329         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
330     }
331 
332     /**
333      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
334      * consuming from one or the other at each step according to the instructions given by
335      * `proofFlags`.
336      *
337      * _Available since v4.7._
338      */
339     function processMultiProof(
340         bytes32[] memory proof,
341         bool[] memory proofFlags,
342         bytes32[] memory leaves
343     ) internal pure returns (bytes32 merkleRoot) {
344         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
345         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
346         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
347         // the merkle tree.
348         uint256 leavesLen = leaves.length;
349         uint256 totalHashes = proofFlags.length;
350 
351         // Check proof validity.
352         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
353 
354         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
355         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
356         bytes32[] memory hashes = new bytes32[](totalHashes);
357         uint256 leafPos = 0;
358         uint256 hashPos = 0;
359         uint256 proofPos = 0;
360         // At each step, we compute the next hash using two values:
361         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
362         //   get the next hash.
363         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
364         //   `proof` array.
365         for (uint256 i = 0; i < totalHashes; i++) {
366             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
367             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
368             hashes[i] = _hashPair(a, b);
369         }
370 
371         if (totalHashes > 0) {
372             return hashes[totalHashes - 1];
373         } else if (leavesLen > 0) {
374             return leaves[0];
375         } else {
376             return proof[0];
377         }
378     }
379 
380     /**
381      * @dev Calldata version of {processMultiProof}
382      *
383      * _Available since v4.7._
384      */
385     function processMultiProofCalldata(
386         bytes32[] calldata proof,
387         bool[] calldata proofFlags,
388         bytes32[] memory leaves
389     ) internal pure returns (bytes32 merkleRoot) {
390         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
391         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
392         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
393         // the merkle tree.
394         uint256 leavesLen = leaves.length;
395         uint256 totalHashes = proofFlags.length;
396 
397         // Check proof validity.
398         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
399 
400         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
401         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
402         bytes32[] memory hashes = new bytes32[](totalHashes);
403         uint256 leafPos = 0;
404         uint256 hashPos = 0;
405         uint256 proofPos = 0;
406         // At each step, we compute the next hash using two values:
407         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
408         //   get the next hash.
409         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
410         //   `proof` array.
411         for (uint256 i = 0; i < totalHashes; i++) {
412             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
413             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
414             hashes[i] = _hashPair(a, b);
415         }
416 
417         if (totalHashes > 0) {
418             return hashes[totalHashes - 1];
419         } else if (leavesLen > 0) {
420             return leaves[0];
421         } else {
422             return proof[0];
423         }
424     }
425 
426     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
427         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
428     }
429 
430     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
431         /// @solidity memory-safe-assembly
432         assembly {
433             mstore(0x00, a)
434             mstore(0x20, b)
435             value := keccak256(0x00, 0x40)
436         }
437     }
438 }
439 
440 
441 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.0
442 
443 // License-Identifier: MIT
444 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
445 
446 pragma solidity ^0.8.0;
447 
448 /**
449  * @dev Interface of the ERC165 standard, as defined in the
450  * https://eips.ethereum.org/EIPS/eip-165[EIP].
451  *
452  * Implementers can declare support of contract interfaces, which can then be
453  * queried by others ({ERC165Checker}).
454  *
455  * For an implementation, see {ERC165}.
456  */
457 interface IERC165 {
458     /**
459      * @dev Returns true if this contract implements the interface defined by
460      * `interfaceId`. See the corresponding
461      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
462      * to learn more about how these ids are created.
463      *
464      * This function call must use less than 30 000 gas.
465      */
466     function supportsInterface(bytes4 interfaceId) external view returns (bool);
467 }
468 
469 
470 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.0
471 
472 // License-Identifier: MIT
473 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 /**
478  * @dev Implementation of the {IERC165} interface.
479  *
480  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
481  * for the additional interface id that will be supported. For example:
482  *
483  * ```solidity
484  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
485  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
486  * }
487  * ```
488  *
489  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
490  */
491 abstract contract ERC165 is IERC165 {
492     /**
493      * @dev See {IERC165-supportsInterface}.
494      */
495     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
496         return interfaceId == type(IERC165).interfaceId;
497     }
498 }
499 
500 
501 // File contracts/interfaces/INFTExtension.sol
502 
503 // License-Identifier: MIT
504 pragma solidity ^0.8.9;
505 
506 interface INFTExtension is IERC165 {}
507 
508 interface INFTURIExtension is INFTExtension {
509     function tokenURI(uint256 tokenId) external view returns (string memory);
510 }
511 
512 
513 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.0
514 
515 // License-Identifier: MIT
516 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 /**
521  * @dev Required interface of an ERC721 compliant contract.
522  */
523 interface IERC721 is IERC165 {
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
582      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
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
655 }
656 
657 
658 // File contracts/interfaces/IERC721Community.sol
659 
660 // License-Identifier: MIT
661 pragma solidity ^0.8.9;
662 
663 /** @dev config includes values have setters and can be changed later */
664 struct MintConfig {
665     uint256 publicPrice;
666     uint256 maxTokensPerMint;
667     uint256 maxTokensPerWallet;
668     uint256 royaltyFee;
669     address payoutReceiver;
670     bool shouldLockPayoutReceiver;
671     bool shouldStartSale;
672     bool shouldUseJsonExtension;
673 }
674 
675 interface IERC721Community {
676     function DEVELOPER() external pure returns (string memory _url);
677 
678     function DEVELOPER_ADDRESS() external pure returns (address payable _dev);
679 
680     // ------ View functions ------
681     function saleStarted() external view returns (bool);
682 
683     function isExtensionAdded(address extension) external view returns (bool);
684 
685     /**
686         Extra information stored for each tokenId. Optional, provided on mint
687      */
688     function data(uint256 tokenId) external view returns (bytes32);
689 
690     // ------ Mint functions ------
691     /**
692         Mint from NFTExtension contract. Optionally provide data parameter.
693      */
694     function mintExternal(
695         uint256 tokenId,
696         address to,
697         bytes32 data
698     ) external payable;
699 
700     // ------ Admin functions ------
701     function addExtension(address extension) external;
702 
703     function revokeExtension(address extension) external;
704 
705     function withdraw() external;
706 
707     // ------ View functions ------
708     /**
709         Recommended royalty for tokenId sale.
710      */
711     function royaltyInfo(uint256 tokenId, uint256 salePrice)
712         external
713         view
714         returns (address receiver, uint256 royaltyAmount);
715 
716     // ------ Admin functions ------
717     function setRoyaltyReceiver(address receiver) external;
718 
719     function setRoyaltyFee(uint256 fee) external;
720 }
721 
722 interface IERC721CommunityImplementation {
723     function initialize(
724         string memory _name,
725         string memory _symbol,
726         uint256 _maxSupply,
727         uint256 _nReserved,
728         bool _startAtOne,
729         string memory uri,
730         MintConfig memory config
731     ) external;
732 }
733 
734 
735 // File contracts/extensions/base/NFTExtension.sol
736 
737 // License-Identifier: MIT
738 pragma solidity ^0.8.9;
739 
740 
741 contract NFTExtension is INFTExtension, ERC165 {
742     IERC721Community public immutable nft;
743 
744     constructor(address _nft) {
745         nft = IERC721Community(_nft);
746     }
747 
748     function beforeMint() internal view {
749         require(
750             nft.isExtensionAdded(address(this)),
751             "NFTExtension: this contract is not allowed to be used as an extension"
752         );
753     }
754 
755     function supportsInterface(bytes4 interfaceId)
756         public
757         view
758         virtual
759         override(IERC165, ERC165)
760         returns (bool)
761     {
762         return
763             interfaceId == type(INFTExtension).interfaceId ||
764             super.supportsInterface(interfaceId);
765     }
766 }
767 
768 
769 // File contracts/extensions/base/SaleControl.sol
770 
771 // License-Identifier: MIT
772 pragma solidity ^0.8.9;
773 
774 abstract contract SaleControl is Ownable {
775     uint256 public constant __SALE_NEVER_STARTS = 2**256 - 1;
776 
777     uint256 public startTimestamp = __SALE_NEVER_STARTS;
778 
779     modifier whenSaleStarted() {
780         require(saleStarted(), "Sale not started yet");
781         _;
782     }
783 
784     function updateStartTimestamp(uint256 _startTimestamp) public onlyOwner {
785         startTimestamp = _startTimestamp;
786     }
787 
788     function startSale() public onlyOwner {
789         startTimestamp = block.timestamp;
790     }
791 
792     function stopSale() public onlyOwner {
793         startTimestamp = __SALE_NEVER_STARTS;
794     }
795 
796     function saleStarted() public view returns (bool) {
797         return block.timestamp >= startTimestamp;
798     }
799 }
800 
801 
802 // File contracts/extensions/base/LimitedSupply.sol
803 
804 // License-Identifier: MIT
805 pragma solidity ^0.8.9;
806 
807 
808 abstract contract LimitedSupply is INFTExtension {
809 
810     uint256 private totalMinted;
811     uint256 public immutable extensionSupply;
812 
813     constructor(uint256 _extensionSupply) {
814         extensionSupply = _extensionSupply;
815     }
816 
817     modifier whenLimitedSupplyNotReached(uint256 amount) {
818         require(
819             amount + totalMinted <= extensionSupply,
820             "max extensionSupply reached"
821         );
822 
823         totalMinted += amount;
824 
825         _;
826     }
827 
828 }
829 
830 
831 // File contracts/extensions/DynamicPricePresaleListExtension.sol
832 
833 // License-Identifier: MIT
834 pragma solidity ^0.8.9;
835 
836 
837 
838 
839 
840 contract DynamicPricePresaleListExtension is
841     NFTExtension,
842     Ownable,
843     SaleControl,
844     LimitedSupply
845 {
846     uint256 public pricePerOne;
847     uint256 public maxPerAddress;
848 
849     bytes32 public whitelistRoot;
850 
851     mapping(address => uint256) public claimedByAddress;
852 
853     constructor(
854         address _nft,
855         bytes32 _whitelistRoot,
856         uint256 _pricePerOne,
857         uint256 _maxPerAddress,
858         uint256 _extensionSupply
859     ) NFTExtension(_nft) SaleControl() LimitedSupply(_extensionSupply) {
860         stopSale();
861 
862         pricePerOne = _pricePerOne;
863         maxPerAddress = _maxPerAddress;
864         whitelistRoot = _whitelistRoot;
865     }
866 
867     function price(uint256 nTokens) public view returns (uint256) {
868         if (nTokens == 0) {
869             return 0;
870         }
871 
872         // one for free, 2+ for price
873         return pricePerOne * (nTokens - 1);
874     }
875 
876     function updatePrice(uint256 _price) public onlyOwner {
877         pricePerOne = _price;
878     }
879 
880     function updateMaxPerAddress(uint256 _maxPerAddress) public onlyOwner {
881         maxPerAddress = _maxPerAddress;
882     }
883 
884     function updateWhitelistRoot(bytes32 _whitelistRoot) public onlyOwner {
885         whitelistRoot = _whitelistRoot;
886     }
887 
888     function mint(uint256 nTokens, bytes32[] memory proof)
889         external
890         payable
891         whenSaleStarted
892         whenLimitedSupplyNotReached(nTokens)
893     {
894         require(
895             isWhitelisted(whitelistRoot, msg.sender, proof),
896             "Not whitelisted"
897         );
898 
899         require(
900             claimedByAddress[msg.sender] + nTokens <= maxPerAddress,
901             "Cannot claim more per address"
902         );
903 
904         uint claimed = claimedByAddress[msg.sender];
905 
906         require(
907             msg.value >= price(nTokens + claimed) - price(claimed),
908             "Not enough ETH to mint"
909         );
910 
911         claimedByAddress[msg.sender] += nTokens;
912 
913         nft.mintExternal{value: msg.value}(nTokens, msg.sender, bytes32(0x0));
914     }
915 
916     function isWhitelisted(
917         bytes32 root,
918         address receiver,
919         bytes32[] memory proof
920     ) public pure returns (bool) {
921         bytes32 leaf = keccak256(abi.encodePacked(receiver));
922 
923         return MerkleProof.verify(proof, root, leaf);
924     }
925 }