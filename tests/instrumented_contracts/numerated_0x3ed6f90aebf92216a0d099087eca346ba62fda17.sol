1 // File: contracts/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 
33 // File: contracts/OperatorFilterer.sol
34 
35 
36 pragma solidity ^0.8.13;
37 
38 
39 abstract contract OperatorFilterer {
40     error OperatorNotAllowed(address operator);
41 
42     IOperatorFilterRegistry constant operatorFilterRegistry =
43         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
44 
45     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
46         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
47         // will not revert, but the contract will need to be registered with the registry once it is deployed in
48         // order for the modifier to filter addresses.
49         if (address(operatorFilterRegistry).code.length > 0) {
50             if (subscribe) {
51                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
52             } else {
53                 if (subscriptionOrRegistrantToCopy != address(0)) {
54                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
55                 } else {
56                     operatorFilterRegistry.register(address(this));
57                 }
58             }
59         }
60     }
61 
62     modifier onlyAllowedOperator(address from) virtual {
63         // Check registry code length to facilitate testing in environments without a deployed registry.
64         if (address(operatorFilterRegistry).code.length > 0) {
65             // Allow spending tokens from addresses with balance
66             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
67             // from an EOA.
68             if (from == msg.sender) {
69                 _;
70                 return;
71             }
72             if (
73                 !(
74                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
75                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
76                 )
77             ) {
78                 revert OperatorNotAllowed(msg.sender);
79             }
80         }
81         _;
82     }
83 }
84 
85 // File: contracts/DefaultOperatorFilterer.sol
86 
87 
88 pragma solidity ^0.8.13;
89 
90 
91 abstract contract DefaultOperatorFilterer is OperatorFilterer {
92     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
93 
94     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
95 }
96 
97 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
98 
99 
100 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev These functions deal with verification of Merkle Tree proofs.
106  *
107  * The proofs can be generated using the JavaScript library
108  * https://github.com/miguelmota/merkletreejs[merkletreejs].
109  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
110  *
111  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
112  *
113  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
114  * hashing, or use a hash function other than keccak256 for hashing leaves.
115  * This is because the concatenation of a sorted pair of internal nodes in
116  * the merkle tree could be reinterpreted as a leaf value.
117  */
118 library MerkleProof {
119     /**
120      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
121      * defined by `root`. For this, a `proof` must be provided, containing
122      * sibling hashes on the branch from the leaf to the root of the tree. Each
123      * pair of leaves and each pair of pre-images are assumed to be sorted.
124      */
125     function verify(
126         bytes32[] memory proof,
127         bytes32 root,
128         bytes32 leaf
129     ) internal pure returns (bool) {
130         return processProof(proof, leaf) == root;
131     }
132 
133     /**
134      * @dev Calldata version of {verify}
135      *
136      * _Available since v4.7._
137      */
138     function verifyCalldata(
139         bytes32[] calldata proof,
140         bytes32 root,
141         bytes32 leaf
142     ) internal pure returns (bool) {
143         return processProofCalldata(proof, leaf) == root;
144     }
145 
146     /**
147      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
148      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
149      * hash matches the root of the tree. When processing the proof, the pairs
150      * of leafs & pre-images are assumed to be sorted.
151      *
152      * _Available since v4.4._
153      */
154     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
155         bytes32 computedHash = leaf;
156         for (uint256 i = 0; i < proof.length; i++) {
157             computedHash = _hashPair(computedHash, proof[i]);
158         }
159         return computedHash;
160     }
161 
162     /**
163      * @dev Calldata version of {processProof}
164      *
165      * _Available since v4.7._
166      */
167     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
168         bytes32 computedHash = leaf;
169         for (uint256 i = 0; i < proof.length; i++) {
170             computedHash = _hashPair(computedHash, proof[i]);
171         }
172         return computedHash;
173     }
174 
175     /**
176      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
177      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
178      *
179      * _Available since v4.7._
180      */
181     function multiProofVerify(
182         bytes32[] memory proof,
183         bool[] memory proofFlags,
184         bytes32 root,
185         bytes32[] memory leaves
186     ) internal pure returns (bool) {
187         return processMultiProof(proof, proofFlags, leaves) == root;
188     }
189 
190     /**
191      * @dev Calldata version of {multiProofVerify}
192      *
193      * _Available since v4.7._
194      */
195     function multiProofVerifyCalldata(
196         bytes32[] calldata proof,
197         bool[] calldata proofFlags,
198         bytes32 root,
199         bytes32[] memory leaves
200     ) internal pure returns (bool) {
201         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
202     }
203 
204     /**
205      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
206      * consuming from one or the other at each step according to the instructions given by
207      * `proofFlags`.
208      *
209      * _Available since v4.7._
210      */
211     function processMultiProof(
212         bytes32[] memory proof,
213         bool[] memory proofFlags,
214         bytes32[] memory leaves
215     ) internal pure returns (bytes32 merkleRoot) {
216         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
217         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
218         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
219         // the merkle tree.
220         uint256 leavesLen = leaves.length;
221         uint256 totalHashes = proofFlags.length;
222 
223         // Check proof validity.
224         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
225 
226         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
227         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
228         bytes32[] memory hashes = new bytes32[](totalHashes);
229         uint256 leafPos = 0;
230         uint256 hashPos = 0;
231         uint256 proofPos = 0;
232         // At each step, we compute the next hash using two values:
233         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
234         //   get the next hash.
235         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
236         //   `proof` array.
237         for (uint256 i = 0; i < totalHashes; i++) {
238             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
239             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
240             hashes[i] = _hashPair(a, b);
241         }
242 
243         if (totalHashes > 0) {
244             return hashes[totalHashes - 1];
245         } else if (leavesLen > 0) {
246             return leaves[0];
247         } else {
248             return proof[0];
249         }
250     }
251 
252     /**
253      * @dev Calldata version of {processMultiProof}
254      *
255      * _Available since v4.7._
256      */
257     function processMultiProofCalldata(
258         bytes32[] calldata proof,
259         bool[] calldata proofFlags,
260         bytes32[] memory leaves
261     ) internal pure returns (bytes32 merkleRoot) {
262         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
263         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
264         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
265         // the merkle tree.
266         uint256 leavesLen = leaves.length;
267         uint256 totalHashes = proofFlags.length;
268 
269         // Check proof validity.
270         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
271 
272         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
273         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
274         bytes32[] memory hashes = new bytes32[](totalHashes);
275         uint256 leafPos = 0;
276         uint256 hashPos = 0;
277         uint256 proofPos = 0;
278         // At each step, we compute the next hash using two values:
279         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
280         //   get the next hash.
281         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
282         //   `proof` array.
283         for (uint256 i = 0; i < totalHashes; i++) {
284             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
285             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
286             hashes[i] = _hashPair(a, b);
287         }
288 
289         if (totalHashes > 0) {
290             return hashes[totalHashes - 1];
291         } else if (leavesLen > 0) {
292             return leaves[0];
293         } else {
294             return proof[0];
295         }
296     }
297 
298     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
299         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
300     }
301 
302     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
303         /// @solidity memory-safe-assembly
304         assembly {
305             mstore(0x00, a)
306             mstore(0x20, b)
307             value := keccak256(0x00, 0x40)
308         }
309     }
310 }
311 
312 // File: @openzeppelin/contracts/utils/Context.sol
313 
314 
315 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 /**
320  * @dev Provides information about the current execution context, including the
321  * sender of the transaction and its data. While these are generally available
322  * via msg.sender and msg.data, they should not be accessed in such a direct
323  * manner, since when dealing with meta-transactions the account sending and
324  * paying for execution may not be the actual sender (as far as an application
325  * is concerned).
326  *
327  * This contract is only required for intermediate, library-like contracts.
328  */
329 abstract contract Context {
330     function _msgSender() internal view virtual returns (address) {
331         return msg.sender;
332     }
333 
334     function _msgData() internal view virtual returns (bytes calldata) {
335         return msg.data;
336     }
337 }
338 
339 // File: @openzeppelin/contracts/security/Pausable.sol
340 
341 
342 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 
347 /**
348  * @dev Contract module which allows children to implement an emergency stop
349  * mechanism that can be triggered by an authorized account.
350  *
351  * This module is used through inheritance. It will make available the
352  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
353  * the functions of your contract. Note that they will not be pausable by
354  * simply including this module, only once the modifiers are put in place.
355  */
356 abstract contract Pausable is Context {
357     /**
358      * @dev Emitted when the pause is triggered by `account`.
359      */
360     event Paused(address account);
361 
362     /**
363      * @dev Emitted when the pause is lifted by `account`.
364      */
365     event Unpaused(address account);
366 
367     bool private _paused;
368 
369     /**
370      * @dev Initializes the contract in unpaused state.
371      */
372     constructor() {
373         _paused = false;
374     }
375 
376     /**
377      * @dev Modifier to make a function callable only when the contract is not paused.
378      *
379      * Requirements:
380      *
381      * - The contract must not be paused.
382      */
383     modifier whenNotPaused() {
384         _requireNotPaused();
385         _;
386     }
387 
388     /**
389      * @dev Modifier to make a function callable only when the contract is paused.
390      *
391      * Requirements:
392      *
393      * - The contract must be paused.
394      */
395     modifier whenPaused() {
396         _requirePaused();
397         _;
398     }
399 
400     /**
401      * @dev Returns true if the contract is paused, and false otherwise.
402      */
403     function paused() public view virtual returns (bool) {
404         return _paused;
405     }
406 
407     /**
408      * @dev Throws if the contract is paused.
409      */
410     function _requireNotPaused() internal view virtual {
411         require(!paused(), "Pausable: paused");
412     }
413 
414     /**
415      * @dev Throws if the contract is not paused.
416      */
417     function _requirePaused() internal view virtual {
418         require(paused(), "Pausable: not paused");
419     }
420 
421     /**
422      * @dev Triggers stopped state.
423      *
424      * Requirements:
425      *
426      * - The contract must not be paused.
427      */
428     function _pause() internal virtual whenNotPaused {
429         _paused = true;
430         emit Paused(_msgSender());
431     }
432 
433     /**
434      * @dev Returns to normal state.
435      *
436      * Requirements:
437      *
438      * - The contract must be paused.
439      */
440     function _unpause() internal virtual whenPaused {
441         _paused = false;
442         emit Unpaused(_msgSender());
443     }
444 }
445 
446 // File: @openzeppelin/contracts/access/Ownable.sol
447 
448 
449 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 
454 /**
455  * @dev Contract module which provides a basic access control mechanism, where
456  * there is an account (an owner) that can be granted exclusive access to
457  * specific functions.
458  *
459  * By default, the owner account will be the one that deploys the contract. This
460  * can later be changed with {transferOwnership}.
461  *
462  * This module is used through inheritance. It will make available the modifier
463  * `onlyOwner`, which can be applied to your functions to restrict their use to
464  * the owner.
465  */
466 abstract contract Ownable is Context {
467     address private _owner;
468 
469     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
470 
471     /**
472      * @dev Initializes the contract setting the deployer as the initial owner.
473      */
474     constructor() {
475         _transferOwnership(_msgSender());
476     }
477 
478     /**
479      * @dev Throws if called by any account other than the owner.
480      */
481     modifier onlyOwner() {
482         _checkOwner();
483         _;
484     }
485 
486     /**
487      * @dev Returns the address of the current owner.
488      */
489     function owner() public view virtual returns (address) {
490         return _owner;
491     }
492 
493     /**
494      * @dev Throws if the sender is not the owner.
495      */
496     function _checkOwner() internal view virtual {
497         require(owner() == _msgSender(), "Ownable: caller is not the owner");
498     }
499 
500     /**
501      * @dev Leaves the contract without owner. It will not be possible to call
502      * `onlyOwner` functions anymore. Can only be called by the current owner.
503      *
504      * NOTE: Renouncing ownership will leave the contract without an owner,
505      * thereby removing any functionality that is only available to the owner.
506      */
507     function renounceOwnership() public virtual onlyOwner {
508         _transferOwnership(address(0));
509     }
510 
511     /**
512      * @dev Transfers ownership of the contract to a new account (`newOwner`).
513      * Can only be called by the current owner.
514      */
515     function transferOwnership(address newOwner) public virtual onlyOwner {
516         require(newOwner != address(0), "Ownable: new owner is the zero address");
517         _transferOwnership(newOwner);
518     }
519 
520     /**
521      * @dev Transfers ownership of the contract to a new account (`newOwner`).
522      * Internal function without access restriction.
523      */
524     function _transferOwnership(address newOwner) internal virtual {
525         address oldOwner = _owner;
526         _owner = newOwner;
527         emit OwnershipTransferred(oldOwner, newOwner);
528     }
529 }
530 
531 // File: erc721a/contracts/IERC721A.sol
532 
533 
534 // ERC721A Contracts v4.2.3
535 // Creator: Chiru Labs
536 
537 pragma solidity ^0.8.4;
538 
539 /**
540  * @dev Interface of ERC721A.
541  */
542 interface IERC721A {
543     /**
544      * The caller must own the token or be an approved operator.
545      */
546     error ApprovalCallerNotOwnerNorApproved();
547 
548     /**
549      * The token does not exist.
550      */
551     error ApprovalQueryForNonexistentToken();
552 
553     /**
554      * Cannot query the balance for the zero address.
555      */
556     error BalanceQueryForZeroAddress();
557 
558     /**
559      * Cannot mint to the zero address.
560      */
561     error MintToZeroAddress();
562 
563     /**
564      * The quantity of tokens minted must be more than zero.
565      */
566     error MintZeroQuantity();
567 
568     /**
569      * The token does not exist.
570      */
571     error OwnerQueryForNonexistentToken();
572 
573     /**
574      * The caller must own the token or be an approved operator.
575      */
576     error TransferCallerNotOwnerNorApproved();
577 
578     /**
579      * The token must be owned by `from`.
580      */
581     error TransferFromIncorrectOwner();
582 
583     /**
584      * Cannot safely transfer to a contract that does not implement the
585      * ERC721Receiver interface.
586      */
587     error TransferToNonERC721ReceiverImplementer();
588 
589     /**
590      * Cannot transfer to the zero address.
591      */
592     error TransferToZeroAddress();
593 
594     /**
595      * The token does not exist.
596      */
597     error URIQueryForNonexistentToken();
598 
599     /**
600      * The `quantity` minted with ERC2309 exceeds the safety limit.
601      */
602     error MintERC2309QuantityExceedsLimit();
603 
604     /**
605      * The `extraData` cannot be set on an unintialized ownership slot.
606      */
607     error OwnershipNotInitializedForExtraData();
608 
609     // =============================================================
610     //                            STRUCTS
611     // =============================================================
612 
613     struct TokenOwnership {
614         // The address of the owner.
615         address addr;
616         // Stores the start time of ownership with minimal overhead for tokenomics.
617         uint64 startTimestamp;
618         // Whether the token has been burned.
619         bool burned;
620         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
621         uint24 extraData;
622     }
623 
624     // =============================================================
625     //                         TOKEN COUNTERS
626     // =============================================================
627 
628     /**
629      * @dev Returns the total number of tokens in existence.
630      * Burned tokens will reduce the count.
631      * To get the total number of tokens minted, please see {_totalMinted}.
632      */
633     function totalSupply() external view returns (uint256);
634 
635     // =============================================================
636     //                            IERC165
637     // =============================================================
638 
639     /**
640      * @dev Returns true if this contract implements the interface defined by
641      * `interfaceId`. See the corresponding
642      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
643      * to learn more about how these ids are created.
644      *
645      * This function call must use less than 30000 gas.
646      */
647     function supportsInterface(bytes4 interfaceId) external view returns (bool);
648 
649     // =============================================================
650     //                            IERC721
651     // =============================================================
652 
653     /**
654      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
655      */
656     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
657 
658     /**
659      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
660      */
661     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
662 
663     /**
664      * @dev Emitted when `owner` enables or disables
665      * (`approved`) `operator` to manage all of its assets.
666      */
667     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
668 
669     /**
670      * @dev Returns the number of tokens in `owner`'s account.
671      */
672     function balanceOf(address owner) external view returns (uint256 balance);
673 
674     /**
675      * @dev Returns the owner of the `tokenId` token.
676      *
677      * Requirements:
678      *
679      * - `tokenId` must exist.
680      */
681     function ownerOf(uint256 tokenId) external view returns (address owner);
682 
683     /**
684      * @dev Safely transfers `tokenId` token from `from` to `to`,
685      * checking first that contract recipients are aware of the ERC721 protocol
686      * to prevent tokens from being forever locked.
687      *
688      * Requirements:
689      *
690      * - `from` cannot be the zero address.
691      * - `to` cannot be the zero address.
692      * - `tokenId` token must exist and be owned by `from`.
693      * - If the caller is not `from`, it must be have been allowed to move
694      * this token by either {approve} or {setApprovalForAll}.
695      * - If `to` refers to a smart contract, it must implement
696      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
697      *
698      * Emits a {Transfer} event.
699      */
700     function safeTransferFrom(
701         address from,
702         address to,
703         uint256 tokenId,
704         bytes calldata data
705     ) external payable;
706 
707     /**
708      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
709      */
710     function safeTransferFrom(
711         address from,
712         address to,
713         uint256 tokenId
714     ) external payable;
715 
716     /**
717      * @dev Transfers `tokenId` from `from` to `to`.
718      *
719      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
720      * whenever possible.
721      *
722      * Requirements:
723      *
724      * - `from` cannot be the zero address.
725      * - `to` cannot be the zero address.
726      * - `tokenId` token must be owned by `from`.
727      * - If the caller is not `from`, it must be approved to move this token
728      * by either {approve} or {setApprovalForAll}.
729      *
730      * Emits a {Transfer} event.
731      */
732     function transferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) external payable;
737 
738     /**
739      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
740      * The approval is cleared when the token is transferred.
741      *
742      * Only a single account can be approved at a time, so approving the
743      * zero address clears previous approvals.
744      *
745      * Requirements:
746      *
747      * - The caller must own the token or be an approved operator.
748      * - `tokenId` must exist.
749      *
750      * Emits an {Approval} event.
751      */
752     function approve(address to, uint256 tokenId) external payable;
753 
754     /**
755      * @dev Approve or remove `operator` as an operator for the caller.
756      * Operators can call {transferFrom} or {safeTransferFrom}
757      * for any token owned by the caller.
758      *
759      * Requirements:
760      *
761      * - The `operator` cannot be the caller.
762      *
763      * Emits an {ApprovalForAll} event.
764      */
765     function setApprovalForAll(address operator, bool _approved) external;
766 
767     /**
768      * @dev Returns the account approved for `tokenId` token.
769      *
770      * Requirements:
771      *
772      * - `tokenId` must exist.
773      */
774     function getApproved(uint256 tokenId) external view returns (address operator);
775 
776     /**
777      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
778      *
779      * See {setApprovalForAll}.
780      */
781     function isApprovedForAll(address owner, address operator) external view returns (bool);
782 
783     // =============================================================
784     //                        IERC721Metadata
785     // =============================================================
786 
787     /**
788      * @dev Returns the token collection name.
789      */
790     function name() external view returns (string memory);
791 
792     /**
793      * @dev Returns the token collection symbol.
794      */
795     function symbol() external view returns (string memory);
796 
797     /**
798      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
799      */
800     function tokenURI(uint256 tokenId) external view returns (string memory);
801 
802     // =============================================================
803     //                           IERC2309
804     // =============================================================
805 
806     /**
807      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
808      * (inclusive) is transferred from `from` to `to`, as defined in the
809      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
810      *
811      * See {_mintERC2309} for more details.
812      */
813     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
814 }
815 
816 // File: erc721a/contracts/ERC721A.sol
817 
818 
819 // ERC721A Contracts v4.2.3
820 // Creator: Chiru Labs
821 
822 pragma solidity ^0.8.4;
823 
824 
825 /**
826  * @dev Interface of ERC721 token receiver.
827  */
828 interface ERC721A__IERC721Receiver {
829     function onERC721Received(
830         address operator,
831         address from,
832         uint256 tokenId,
833         bytes calldata data
834     ) external returns (bytes4);
835 }
836 
837 /**
838  * @title ERC721A
839  *
840  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
841  * Non-Fungible Token Standard, including the Metadata extension.
842  * Optimized for lower gas during batch mints.
843  *
844  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
845  * starting from `_startTokenId()`.
846  *
847  * Assumptions:
848  *
849  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
850  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
851  */
852 contract ERC721A is IERC721A {
853     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
854     struct TokenApprovalRef {
855         address value;
856     }
857 
858     // =============================================================
859     //                           CONSTANTS
860     // =============================================================
861 
862     // Mask of an entry in packed address data.
863     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
864 
865     // The bit position of `numberMinted` in packed address data.
866     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
867 
868     // The bit position of `numberBurned` in packed address data.
869     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
870 
871     // The bit position of `aux` in packed address data.
872     uint256 private constant _BITPOS_AUX = 192;
873 
874     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
875     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
876 
877     // The bit position of `startTimestamp` in packed ownership.
878     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
879 
880     // The bit mask of the `burned` bit in packed ownership.
881     uint256 private constant _BITMASK_BURNED = 1 << 224;
882 
883     // The bit position of the `nextInitialized` bit in packed ownership.
884     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
885 
886     // The bit mask of the `nextInitialized` bit in packed ownership.
887     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
888 
889     // The bit position of `extraData` in packed ownership.
890     uint256 private constant _BITPOS_EXTRA_DATA = 232;
891 
892     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
893     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
894 
895     // The mask of the lower 160 bits for addresses.
896     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
897 
898     // The maximum `quantity` that can be minted with {_mintERC2309}.
899     // This limit is to prevent overflows on the address data entries.
900     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
901     // is required to cause an overflow, which is unrealistic.
902     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
903 
904     // The `Transfer` event signature is given by:
905     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
906     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
907         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
908 
909     // =============================================================
910     //                            STORAGE
911     // =============================================================
912 
913     // The next token ID to be minted.
914     uint256 private _currentIndex;
915 
916     // The number of tokens burned.
917     uint256 private _burnCounter;
918 
919     // Token name
920     string private _name;
921 
922     // Token symbol
923     string private _symbol;
924 
925     // Mapping from token ID to ownership details
926     // An empty struct value does not necessarily mean the token is unowned.
927     // See {_packedOwnershipOf} implementation for details.
928     //
929     // Bits Layout:
930     // - [0..159]   `addr`
931     // - [160..223] `startTimestamp`
932     // - [224]      `burned`
933     // - [225]      `nextInitialized`
934     // - [232..255] `extraData`
935     mapping(uint256 => uint256) private _packedOwnerships;
936 
937     // Mapping owner address to address data.
938     //
939     // Bits Layout:
940     // - [0..63]    `balance`
941     // - [64..127]  `numberMinted`
942     // - [128..191] `numberBurned`
943     // - [192..255] `aux`
944     mapping(address => uint256) private _packedAddressData;
945 
946     // Mapping from token ID to approved address.
947     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
948 
949     // Mapping from owner to operator approvals
950     mapping(address => mapping(address => bool)) private _operatorApprovals;
951 
952     // =============================================================
953     //                          CONSTRUCTOR
954     // =============================================================
955 
956     constructor(string memory name_, string memory symbol_) {
957         _name = name_;
958         _symbol = symbol_;
959         _currentIndex = _startTokenId();
960     }
961 
962     // =============================================================
963     //                   TOKEN COUNTING OPERATIONS
964     // =============================================================
965 
966     /**
967      * @dev Returns the starting token ID.
968      * To change the starting token ID, please override this function.
969      */
970     function _startTokenId() internal view virtual returns (uint256) {
971         return 0;
972     }
973 
974     /**
975      * @dev Returns the next token ID to be minted.
976      */
977     function _nextTokenId() internal view virtual returns (uint256) {
978         return _currentIndex;
979     }
980 
981     /**
982      * @dev Returns the total number of tokens in existence.
983      * Burned tokens will reduce the count.
984      * To get the total number of tokens minted, please see {_totalMinted}.
985      */
986     function totalSupply() public view virtual override returns (uint256) {
987         // Counter underflow is impossible as _burnCounter cannot be incremented
988         // more than `_currentIndex - _startTokenId()` times.
989         unchecked {
990             return _currentIndex - _burnCounter - _startTokenId();
991         }
992     }
993 
994     /**
995      * @dev Returns the total amount of tokens minted in the contract.
996      */
997     function _totalMinted() internal view virtual returns (uint256) {
998         // Counter underflow is impossible as `_currentIndex` does not decrement,
999         // and it is initialized to `_startTokenId()`.
1000         unchecked {
1001             return _currentIndex - _startTokenId();
1002         }
1003     }
1004 
1005     /**
1006      * @dev Returns the total number of tokens burned.
1007      */
1008     function _totalBurned() internal view virtual returns (uint256) {
1009         return _burnCounter;
1010     }
1011 
1012     // =============================================================
1013     //                    ADDRESS DATA OPERATIONS
1014     // =============================================================
1015 
1016     /**
1017      * @dev Returns the number of tokens in `owner`'s account.
1018      */
1019     function balanceOf(address owner) public view virtual override returns (uint256) {
1020         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1021         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1022     }
1023 
1024     /**
1025      * Returns the number of tokens minted by `owner`.
1026      */
1027     function _numberMinted(address owner) internal view returns (uint256) {
1028         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1029     }
1030 
1031     /**
1032      * Returns the number of tokens burned by or on behalf of `owner`.
1033      */
1034     function _numberBurned(address owner) internal view returns (uint256) {
1035         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1036     }
1037 
1038     /**
1039      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1040      */
1041     function _getAux(address owner) internal view returns (uint64) {
1042         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1043     }
1044 
1045     /**
1046      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1047      * If there are multiple variables, please pack them into a uint64.
1048      */
1049     function _setAux(address owner, uint64 aux) internal virtual {
1050         uint256 packed = _packedAddressData[owner];
1051         uint256 auxCasted;
1052         // Cast `aux` with assembly to avoid redundant masking.
1053         assembly {
1054             auxCasted := aux
1055         }
1056         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1057         _packedAddressData[owner] = packed;
1058     }
1059 
1060     // =============================================================
1061     //                            IERC165
1062     // =============================================================
1063 
1064     /**
1065      * @dev Returns true if this contract implements the interface defined by
1066      * `interfaceId`. See the corresponding
1067      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1068      * to learn more about how these ids are created.
1069      *
1070      * This function call must use less than 30000 gas.
1071      */
1072     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1073         // The interface IDs are constants representing the first 4 bytes
1074         // of the XOR of all function selectors in the interface.
1075         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1076         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1077         return
1078             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1079             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1080             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1081     }
1082 
1083     // =============================================================
1084     //                        IERC721Metadata
1085     // =============================================================
1086 
1087     /**
1088      * @dev Returns the token collection name.
1089      */
1090     function name() public view virtual override returns (string memory) {
1091         return _name;
1092     }
1093 
1094     /**
1095      * @dev Returns the token collection symbol.
1096      */
1097     function symbol() public view virtual override returns (string memory) {
1098         return _symbol;
1099     }
1100 
1101     /**
1102      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1103      */
1104     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1105         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1106 
1107         string memory baseURI = _baseURI();
1108         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1109     }
1110 
1111     /**
1112      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1113      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1114      * by default, it can be overridden in child contracts.
1115      */
1116     function _baseURI() internal view virtual returns (string memory) {
1117         return '';
1118     }
1119 
1120     // =============================================================
1121     //                     OWNERSHIPS OPERATIONS
1122     // =============================================================
1123 
1124     /**
1125      * @dev Returns the owner of the `tokenId` token.
1126      *
1127      * Requirements:
1128      *
1129      * - `tokenId` must exist.
1130      */
1131     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1132         return address(uint160(_packedOwnershipOf(tokenId)));
1133     }
1134 
1135     /**
1136      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1137      * It gradually moves to O(1) as tokens get transferred around over time.
1138      */
1139     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1140         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1141     }
1142 
1143     /**
1144      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1145      */
1146     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1147         return _unpackedOwnership(_packedOwnerships[index]);
1148     }
1149 
1150     /**
1151      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1152      */
1153     function _initializeOwnershipAt(uint256 index) internal virtual {
1154         if (_packedOwnerships[index] == 0) {
1155             _packedOwnerships[index] = _packedOwnershipOf(index);
1156         }
1157     }
1158 
1159     /**
1160      * Returns the packed ownership data of `tokenId`.
1161      */
1162     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1163         uint256 curr = tokenId;
1164 
1165         unchecked {
1166             if (_startTokenId() <= curr)
1167                 if (curr < _currentIndex) {
1168                     uint256 packed = _packedOwnerships[curr];
1169                     // If not burned.
1170                     if (packed & _BITMASK_BURNED == 0) {
1171                         // Invariant:
1172                         // There will always be an initialized ownership slot
1173                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1174                         // before an unintialized ownership slot
1175                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1176                         // Hence, `curr` will not underflow.
1177                         //
1178                         // We can directly compare the packed value.
1179                         // If the address is zero, packed will be zero.
1180                         while (packed == 0) {
1181                             packed = _packedOwnerships[--curr];
1182                         }
1183                         return packed;
1184                     }
1185                 }
1186         }
1187         revert OwnerQueryForNonexistentToken();
1188     }
1189 
1190     /**
1191      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1192      */
1193     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1194         ownership.addr = address(uint160(packed));
1195         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1196         ownership.burned = packed & _BITMASK_BURNED != 0;
1197         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1198     }
1199 
1200     /**
1201      * @dev Packs ownership data into a single uint256.
1202      */
1203     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1204         assembly {
1205             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1206             owner := and(owner, _BITMASK_ADDRESS)
1207             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1208             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1209         }
1210     }
1211 
1212     /**
1213      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1214      */
1215     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1216         // For branchless setting of the `nextInitialized` flag.
1217         assembly {
1218             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1219             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1220         }
1221     }
1222 
1223     // =============================================================
1224     //                      APPROVAL OPERATIONS
1225     // =============================================================
1226 
1227     /**
1228      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1229      * The approval is cleared when the token is transferred.
1230      *
1231      * Only a single account can be approved at a time, so approving the
1232      * zero address clears previous approvals.
1233      *
1234      * Requirements:
1235      *
1236      * - The caller must own the token or be an approved operator.
1237      * - `tokenId` must exist.
1238      *
1239      * Emits an {Approval} event.
1240      */
1241     function approve(address to, uint256 tokenId) public payable virtual override {
1242         address owner = ownerOf(tokenId);
1243 
1244         if (_msgSenderERC721A() != owner)
1245             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1246                 revert ApprovalCallerNotOwnerNorApproved();
1247             }
1248 
1249         _tokenApprovals[tokenId].value = to;
1250         emit Approval(owner, to, tokenId);
1251     }
1252 
1253     /**
1254      * @dev Returns the account approved for `tokenId` token.
1255      *
1256      * Requirements:
1257      *
1258      * - `tokenId` must exist.
1259      */
1260     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1261         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1262 
1263         return _tokenApprovals[tokenId].value;
1264     }
1265 
1266     /**
1267      * @dev Approve or remove `operator` as an operator for the caller.
1268      * Operators can call {transferFrom} or {safeTransferFrom}
1269      * for any token owned by the caller.
1270      *
1271      * Requirements:
1272      *
1273      * - The `operator` cannot be the caller.
1274      *
1275      * Emits an {ApprovalForAll} event.
1276      */
1277     function setApprovalForAll(address operator, bool approved) public virtual override {
1278         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1279         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1280     }
1281 
1282     /**
1283      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1284      *
1285      * See {setApprovalForAll}.
1286      */
1287     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1288         return _operatorApprovals[owner][operator];
1289     }
1290 
1291     /**
1292      * @dev Returns whether `tokenId` exists.
1293      *
1294      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1295      *
1296      * Tokens start existing when they are minted. See {_mint}.
1297      */
1298     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1299         return
1300             _startTokenId() <= tokenId &&
1301             tokenId < _currentIndex && // If within bounds,
1302             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1303     }
1304 
1305     /**
1306      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1307      */
1308     function _isSenderApprovedOrOwner(
1309         address approvedAddress,
1310         address owner,
1311         address msgSender
1312     ) private pure returns (bool result) {
1313         assembly {
1314             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1315             owner := and(owner, _BITMASK_ADDRESS)
1316             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1317             msgSender := and(msgSender, _BITMASK_ADDRESS)
1318             // `msgSender == owner || msgSender == approvedAddress`.
1319             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1320         }
1321     }
1322 
1323     /**
1324      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1325      */
1326     function _getApprovedSlotAndAddress(uint256 tokenId)
1327         private
1328         view
1329         returns (uint256 approvedAddressSlot, address approvedAddress)
1330     {
1331         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1332         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1333         assembly {
1334             approvedAddressSlot := tokenApproval.slot
1335             approvedAddress := sload(approvedAddressSlot)
1336         }
1337     }
1338 
1339     // =============================================================
1340     //                      TRANSFER OPERATIONS
1341     // =============================================================
1342 
1343     /**
1344      * @dev Transfers `tokenId` from `from` to `to`.
1345      *
1346      * Requirements:
1347      *
1348      * - `from` cannot be the zero address.
1349      * - `to` cannot be the zero address.
1350      * - `tokenId` token must be owned by `from`.
1351      * - If the caller is not `from`, it must be approved to move this token
1352      * by either {approve} or {setApprovalForAll}.
1353      *
1354      * Emits a {Transfer} event.
1355      */
1356     function transferFrom(
1357         address from,
1358         address to,
1359         uint256 tokenId
1360     ) public payable virtual override {
1361         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1362 
1363         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1364 
1365         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1366 
1367         // The nested ifs save around 20+ gas over a compound boolean condition.
1368         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1369             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1370 
1371         if (to == address(0)) revert TransferToZeroAddress();
1372 
1373         _beforeTokenTransfers(from, to, tokenId, 1);
1374 
1375         // Clear approvals from the previous owner.
1376         assembly {
1377             if approvedAddress {
1378                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1379                 sstore(approvedAddressSlot, 0)
1380             }
1381         }
1382 
1383         // Underflow of the sender's balance is impossible because we check for
1384         // ownership above and the recipient's balance can't realistically overflow.
1385         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1386         unchecked {
1387             // We can directly increment and decrement the balances.
1388             --_packedAddressData[from]; // Updates: `balance -= 1`.
1389             ++_packedAddressData[to]; // Updates: `balance += 1`.
1390 
1391             // Updates:
1392             // - `address` to the next owner.
1393             // - `startTimestamp` to the timestamp of transfering.
1394             // - `burned` to `false`.
1395             // - `nextInitialized` to `true`.
1396             _packedOwnerships[tokenId] = _packOwnershipData(
1397                 to,
1398                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1399             );
1400 
1401             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1402             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1403                 uint256 nextTokenId = tokenId + 1;
1404                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1405                 if (_packedOwnerships[nextTokenId] == 0) {
1406                     // If the next slot is within bounds.
1407                     if (nextTokenId != _currentIndex) {
1408                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1409                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1410                     }
1411                 }
1412             }
1413         }
1414 
1415         emit Transfer(from, to, tokenId);
1416         _afterTokenTransfers(from, to, tokenId, 1);
1417     }
1418 
1419     /**
1420      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1421      */
1422     function safeTransferFrom(
1423         address from,
1424         address to,
1425         uint256 tokenId
1426     ) public payable virtual override {
1427         safeTransferFrom(from, to, tokenId, '');
1428     }
1429 
1430     /**
1431      * @dev Safely transfers `tokenId` token from `from` to `to`.
1432      *
1433      * Requirements:
1434      *
1435      * - `from` cannot be the zero address.
1436      * - `to` cannot be the zero address.
1437      * - `tokenId` token must exist and be owned by `from`.
1438      * - If the caller is not `from`, it must be approved to move this token
1439      * by either {approve} or {setApprovalForAll}.
1440      * - If `to` refers to a smart contract, it must implement
1441      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1442      *
1443      * Emits a {Transfer} event.
1444      */
1445     function safeTransferFrom(
1446         address from,
1447         address to,
1448         uint256 tokenId,
1449         bytes memory _data
1450     ) public payable virtual override {
1451         transferFrom(from, to, tokenId);
1452         if (to.code.length != 0)
1453             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1454                 revert TransferToNonERC721ReceiverImplementer();
1455             }
1456     }
1457 
1458     /**
1459      * @dev Hook that is called before a set of serially-ordered token IDs
1460      * are about to be transferred. This includes minting.
1461      * And also called before burning one token.
1462      *
1463      * `startTokenId` - the first token ID to be transferred.
1464      * `quantity` - the amount to be transferred.
1465      *
1466      * Calling conditions:
1467      *
1468      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1469      * transferred to `to`.
1470      * - When `from` is zero, `tokenId` will be minted for `to`.
1471      * - When `to` is zero, `tokenId` will be burned by `from`.
1472      * - `from` and `to` are never both zero.
1473      */
1474     function _beforeTokenTransfers(
1475         address from,
1476         address to,
1477         uint256 startTokenId,
1478         uint256 quantity
1479     ) internal virtual {}
1480 
1481     /**
1482      * @dev Hook that is called after a set of serially-ordered token IDs
1483      * have been transferred. This includes minting.
1484      * And also called after one token has been burned.
1485      *
1486      * `startTokenId` - the first token ID to be transferred.
1487      * `quantity` - the amount to be transferred.
1488      *
1489      * Calling conditions:
1490      *
1491      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1492      * transferred to `to`.
1493      * - When `from` is zero, `tokenId` has been minted for `to`.
1494      * - When `to` is zero, `tokenId` has been burned by `from`.
1495      * - `from` and `to` are never both zero.
1496      */
1497     function _afterTokenTransfers(
1498         address from,
1499         address to,
1500         uint256 startTokenId,
1501         uint256 quantity
1502     ) internal virtual {}
1503 
1504     /**
1505      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1506      *
1507      * `from` - Previous owner of the given token ID.
1508      * `to` - Target address that will receive the token.
1509      * `tokenId` - Token ID to be transferred.
1510      * `_data` - Optional data to send along with the call.
1511      *
1512      * Returns whether the call correctly returned the expected magic value.
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
1535     // =============================================================
1536     //                        MINT OPERATIONS
1537     // =============================================================
1538 
1539     /**
1540      * @dev Mints `quantity` tokens and transfers them to `to`.
1541      *
1542      * Requirements:
1543      *
1544      * - `to` cannot be the zero address.
1545      * - `quantity` must be greater than 0.
1546      *
1547      * Emits a {Transfer} event for each mint.
1548      */
1549     function _mint(address to, uint256 quantity) internal virtual {
1550         uint256 startTokenId = _currentIndex;
1551         if (quantity == 0) revert MintZeroQuantity();
1552 
1553         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1554 
1555         // Overflows are incredibly unrealistic.
1556         // `balance` and `numberMinted` have a maximum limit of 2**64.
1557         // `tokenId` has a maximum limit of 2**256.
1558         unchecked {
1559             // Updates:
1560             // - `balance += quantity`.
1561             // - `numberMinted += quantity`.
1562             //
1563             // We can directly add to the `balance` and `numberMinted`.
1564             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1565 
1566             // Updates:
1567             // - `address` to the owner.
1568             // - `startTimestamp` to the timestamp of minting.
1569             // - `burned` to `false`.
1570             // - `nextInitialized` to `quantity == 1`.
1571             _packedOwnerships[startTokenId] = _packOwnershipData(
1572                 to,
1573                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1574             );
1575 
1576             uint256 toMasked;
1577             uint256 end = startTokenId + quantity;
1578 
1579             // Use assembly to loop and emit the `Transfer` event for gas savings.
1580             // The duplicated `log4` removes an extra check and reduces stack juggling.
1581             // The assembly, together with the surrounding Solidity code, have been
1582             // delicately arranged to nudge the compiler into producing optimized opcodes.
1583             assembly {
1584                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1585                 toMasked := and(to, _BITMASK_ADDRESS)
1586                 // Emit the `Transfer` event.
1587                 log4(
1588                     0, // Start of data (0, since no data).
1589                     0, // End of data (0, since no data).
1590                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1591                     0, // `address(0)`.
1592                     toMasked, // `to`.
1593                     startTokenId // `tokenId`.
1594                 )
1595 
1596                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1597                 // that overflows uint256 will make the loop run out of gas.
1598                 // The compiler will optimize the `iszero` away for performance.
1599                 for {
1600                     let tokenId := add(startTokenId, 1)
1601                 } iszero(eq(tokenId, end)) {
1602                     tokenId := add(tokenId, 1)
1603                 } {
1604                     // Emit the `Transfer` event. Similar to above.
1605                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1606                 }
1607             }
1608             if (toMasked == 0) revert MintToZeroAddress();
1609 
1610             _currentIndex = end;
1611         }
1612         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1613     }
1614 
1615     /**
1616      * @dev Mints `quantity` tokens and transfers them to `to`.
1617      *
1618      * This function is intended for efficient minting only during contract creation.
1619      *
1620      * It emits only one {ConsecutiveTransfer} as defined in
1621      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1622      * instead of a sequence of {Transfer} event(s).
1623      *
1624      * Calling this function outside of contract creation WILL make your contract
1625      * non-compliant with the ERC721 standard.
1626      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1627      * {ConsecutiveTransfer} event is only permissible during contract creation.
1628      *
1629      * Requirements:
1630      *
1631      * - `to` cannot be the zero address.
1632      * - `quantity` must be greater than 0.
1633      *
1634      * Emits a {ConsecutiveTransfer} event.
1635      */
1636     function _mintERC2309(address to, uint256 quantity) internal virtual {
1637         uint256 startTokenId = _currentIndex;
1638         if (to == address(0)) revert MintToZeroAddress();
1639         if (quantity == 0) revert MintZeroQuantity();
1640         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1641 
1642         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1643 
1644         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1645         unchecked {
1646             // Updates:
1647             // - `balance += quantity`.
1648             // - `numberMinted += quantity`.
1649             //
1650             // We can directly add to the `balance` and `numberMinted`.
1651             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1652 
1653             // Updates:
1654             // - `address` to the owner.
1655             // - `startTimestamp` to the timestamp of minting.
1656             // - `burned` to `false`.
1657             // - `nextInitialized` to `quantity == 1`.
1658             _packedOwnerships[startTokenId] = _packOwnershipData(
1659                 to,
1660                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1661             );
1662 
1663             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1664 
1665             _currentIndex = startTokenId + quantity;
1666         }
1667         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1668     }
1669 
1670     /**
1671      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1672      *
1673      * Requirements:
1674      *
1675      * - If `to` refers to a smart contract, it must implement
1676      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1677      * - `quantity` must be greater than 0.
1678      *
1679      * See {_mint}.
1680      *
1681      * Emits a {Transfer} event for each mint.
1682      */
1683     function _safeMint(
1684         address to,
1685         uint256 quantity,
1686         bytes memory _data
1687     ) internal virtual {
1688         _mint(to, quantity);
1689 
1690         unchecked {
1691             if (to.code.length != 0) {
1692                 uint256 end = _currentIndex;
1693                 uint256 index = end - quantity;
1694                 do {
1695                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1696                         revert TransferToNonERC721ReceiverImplementer();
1697                     }
1698                 } while (index < end);
1699                 // Reentrancy protection.
1700                 if (_currentIndex != end) revert();
1701             }
1702         }
1703     }
1704 
1705     /**
1706      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1707      */
1708     function _safeMint(address to, uint256 quantity) internal virtual {
1709         _safeMint(to, quantity, '');
1710     }
1711 
1712     // =============================================================
1713     //                        BURN OPERATIONS
1714     // =============================================================
1715 
1716     /**
1717      * @dev Equivalent to `_burn(tokenId, false)`.
1718      */
1719     function _burn(uint256 tokenId) internal virtual {
1720         _burn(tokenId, false);
1721     }
1722 
1723     /**
1724      * @dev Destroys `tokenId`.
1725      * The approval is cleared when the token is burned.
1726      *
1727      * Requirements:
1728      *
1729      * - `tokenId` must exist.
1730      *
1731      * Emits a {Transfer} event.
1732      */
1733     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1734         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1735 
1736         address from = address(uint160(prevOwnershipPacked));
1737 
1738         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1739 
1740         if (approvalCheck) {
1741             // The nested ifs save around 20+ gas over a compound boolean condition.
1742             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1743                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1744         }
1745 
1746         _beforeTokenTransfers(from, address(0), tokenId, 1);
1747 
1748         // Clear approvals from the previous owner.
1749         assembly {
1750             if approvedAddress {
1751                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1752                 sstore(approvedAddressSlot, 0)
1753             }
1754         }
1755 
1756         // Underflow of the sender's balance is impossible because we check for
1757         // ownership above and the recipient's balance can't realistically overflow.
1758         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1759         unchecked {
1760             // Updates:
1761             // - `balance -= 1`.
1762             // - `numberBurned += 1`.
1763             //
1764             // We can directly decrement the balance, and increment the number burned.
1765             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1766             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1767 
1768             // Updates:
1769             // - `address` to the last owner.
1770             // - `startTimestamp` to the timestamp of burning.
1771             // - `burned` to `true`.
1772             // - `nextInitialized` to `true`.
1773             _packedOwnerships[tokenId] = _packOwnershipData(
1774                 from,
1775                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1776             );
1777 
1778             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1779             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1780                 uint256 nextTokenId = tokenId + 1;
1781                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1782                 if (_packedOwnerships[nextTokenId] == 0) {
1783                     // If the next slot is within bounds.
1784                     if (nextTokenId != _currentIndex) {
1785                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1786                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1787                     }
1788                 }
1789             }
1790         }
1791 
1792         emit Transfer(from, address(0), tokenId);
1793         _afterTokenTransfers(from, address(0), tokenId, 1);
1794 
1795         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1796         unchecked {
1797             _burnCounter++;
1798         }
1799     }
1800 
1801     // =============================================================
1802     //                     EXTRA DATA OPERATIONS
1803     // =============================================================
1804 
1805     /**
1806      * @dev Directly sets the extra data for the ownership data `index`.
1807      */
1808     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1809         uint256 packed = _packedOwnerships[index];
1810         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1811         uint256 extraDataCasted;
1812         // Cast `extraData` with assembly to avoid redundant masking.
1813         assembly {
1814             extraDataCasted := extraData
1815         }
1816         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1817         _packedOwnerships[index] = packed;
1818     }
1819 
1820     /**
1821      * @dev Called during each token transfer to set the 24bit `extraData` field.
1822      * Intended to be overridden by the cosumer contract.
1823      *
1824      * `previousExtraData` - the value of `extraData` before transfer.
1825      *
1826      * Calling conditions:
1827      *
1828      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1829      * transferred to `to`.
1830      * - When `from` is zero, `tokenId` will be minted for `to`.
1831      * - When `to` is zero, `tokenId` will be burned by `from`.
1832      * - `from` and `to` are never both zero.
1833      */
1834     function _extraData(
1835         address from,
1836         address to,
1837         uint24 previousExtraData
1838     ) internal view virtual returns (uint24) {}
1839 
1840     /**
1841      * @dev Returns the next extra data for the packed ownership data.
1842      * The returned result is shifted into position.
1843      */
1844     function _nextExtraData(
1845         address from,
1846         address to,
1847         uint256 prevOwnershipPacked
1848     ) private view returns (uint256) {
1849         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1850         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1851     }
1852 
1853     // =============================================================
1854     //                       OTHER OPERATIONS
1855     // =============================================================
1856 
1857     /**
1858      * @dev Returns the message sender (defaults to `msg.sender`).
1859      *
1860      * If you are writing GSN compatible contracts, you need to override this function.
1861      */
1862     function _msgSenderERC721A() internal view virtual returns (address) {
1863         return msg.sender;
1864     }
1865 
1866     /**
1867      * @dev Converts a uint256 to its ASCII string decimal representation.
1868      */
1869     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1870         assembly {
1871             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1872             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1873             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1874             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1875             let m := add(mload(0x40), 0xa0)
1876             // Update the free memory pointer to allocate.
1877             mstore(0x40, m)
1878             // Assign the `str` to the end.
1879             str := sub(m, 0x20)
1880             // Zeroize the slot after the string.
1881             mstore(str, 0)
1882 
1883             // Cache the end of the memory to calculate the length later.
1884             let end := str
1885 
1886             // We write the string from rightmost digit to leftmost digit.
1887             // The following is essentially a do-while loop that also handles the zero case.
1888             // prettier-ignore
1889             for { let temp := value } 1 {} {
1890                 str := sub(str, 1)
1891                 // Write the character to the pointer.
1892                 // The ASCII index of the '0' character is 48.
1893                 mstore8(str, add(48, mod(temp, 10)))
1894                 // Keep dividing `temp` until zero.
1895                 temp := div(temp, 10)
1896                 // prettier-ignore
1897                 if iszero(temp) { break }
1898             }
1899 
1900             let length := sub(end, str)
1901             // Move the pointer 32 bytes leftwards to make room for the length.
1902             str := sub(str, 0x20)
1903             // Store the length.
1904             mstore(str, length)
1905         }
1906     }
1907 }
1908 
1909 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1910 
1911 
1912 // ERC721A Contracts v4.2.3
1913 // Creator: Chiru Labs
1914 
1915 pragma solidity ^0.8.4;
1916 
1917 
1918 /**
1919  * @dev Interface of ERC721AQueryable.
1920  */
1921 interface IERC721AQueryable is IERC721A {
1922     /**
1923      * Invalid query range (`start` >= `stop`).
1924      */
1925     error InvalidQueryRange();
1926 
1927     /**
1928      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1929      *
1930      * If the `tokenId` is out of bounds:
1931      *
1932      * - `addr = address(0)`
1933      * - `startTimestamp = 0`
1934      * - `burned = false`
1935      * - `extraData = 0`
1936      *
1937      * If the `tokenId` is burned:
1938      *
1939      * - `addr = <Address of owner before token was burned>`
1940      * - `startTimestamp = <Timestamp when token was burned>`
1941      * - `burned = true`
1942      * - `extraData = <Extra data when token was burned>`
1943      *
1944      * Otherwise:
1945      *
1946      * - `addr = <Address of owner>`
1947      * - `startTimestamp = <Timestamp of start of ownership>`
1948      * - `burned = false`
1949      * - `extraData = <Extra data at start of ownership>`
1950      */
1951     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1952 
1953     /**
1954      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1955      * See {ERC721AQueryable-explicitOwnershipOf}
1956      */
1957     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1958 
1959     /**
1960      * @dev Returns an array of token IDs owned by `owner`,
1961      * in the range [`start`, `stop`)
1962      * (i.e. `start <= tokenId < stop`).
1963      *
1964      * This function allows for tokens to be queried if the collection
1965      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1966      *
1967      * Requirements:
1968      *
1969      * - `start < stop`
1970      */
1971     function tokensOfOwnerIn(
1972         address owner,
1973         uint256 start,
1974         uint256 stop
1975     ) external view returns (uint256[] memory);
1976 
1977     /**
1978      * @dev Returns an array of token IDs owned by `owner`.
1979      *
1980      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1981      * It is meant to be called off-chain.
1982      *
1983      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1984      * multiple smaller scans if the collection is large enough to cause
1985      * an out-of-gas error (10K collections should be fine).
1986      */
1987     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1988 }
1989 
1990 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1991 
1992 
1993 // ERC721A Contracts v4.2.3
1994 // Creator: Chiru Labs
1995 
1996 pragma solidity ^0.8.4;
1997 
1998 
1999 
2000 /**
2001  * @title ERC721AQueryable.
2002  *
2003  * @dev ERC721A subclass with convenience query functions.
2004  */
2005 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2006     /**
2007      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2008      *
2009      * If the `tokenId` is out of bounds:
2010      *
2011      * - `addr = address(0)`
2012      * - `startTimestamp = 0`
2013      * - `burned = false`
2014      * - `extraData = 0`
2015      *
2016      * If the `tokenId` is burned:
2017      *
2018      * - `addr = <Address of owner before token was burned>`
2019      * - `startTimestamp = <Timestamp when token was burned>`
2020      * - `burned = true`
2021      * - `extraData = <Extra data when token was burned>`
2022      *
2023      * Otherwise:
2024      *
2025      * - `addr = <Address of owner>`
2026      * - `startTimestamp = <Timestamp of start of ownership>`
2027      * - `burned = false`
2028      * - `extraData = <Extra data at start of ownership>`
2029      */
2030     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2031         TokenOwnership memory ownership;
2032         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2033             return ownership;
2034         }
2035         ownership = _ownershipAt(tokenId);
2036         if (ownership.burned) {
2037             return ownership;
2038         }
2039         return _ownershipOf(tokenId);
2040     }
2041 
2042     /**
2043      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2044      * See {ERC721AQueryable-explicitOwnershipOf}
2045      */
2046     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2047         external
2048         view
2049         virtual
2050         override
2051         returns (TokenOwnership[] memory)
2052     {
2053         unchecked {
2054             uint256 tokenIdsLength = tokenIds.length;
2055             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2056             for (uint256 i; i != tokenIdsLength; ++i) {
2057                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2058             }
2059             return ownerships;
2060         }
2061     }
2062 
2063     /**
2064      * @dev Returns an array of token IDs owned by `owner`,
2065      * in the range [`start`, `stop`)
2066      * (i.e. `start <= tokenId < stop`).
2067      *
2068      * This function allows for tokens to be queried if the collection
2069      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2070      *
2071      * Requirements:
2072      *
2073      * - `start < stop`
2074      */
2075     function tokensOfOwnerIn(
2076         address owner,
2077         uint256 start,
2078         uint256 stop
2079     ) external view virtual override returns (uint256[] memory) {
2080         unchecked {
2081             if (start >= stop) revert InvalidQueryRange();
2082             uint256 tokenIdsIdx;
2083             uint256 stopLimit = _nextTokenId();
2084             // Set `start = max(start, _startTokenId())`.
2085             if (start < _startTokenId()) {
2086                 start = _startTokenId();
2087             }
2088             // Set `stop = min(stop, stopLimit)`.
2089             if (stop > stopLimit) {
2090                 stop = stopLimit;
2091             }
2092             uint256 tokenIdsMaxLength = balanceOf(owner);
2093             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2094             // to cater for cases where `balanceOf(owner)` is too big.
2095             if (start < stop) {
2096                 uint256 rangeLength = stop - start;
2097                 if (rangeLength < tokenIdsMaxLength) {
2098                     tokenIdsMaxLength = rangeLength;
2099                 }
2100             } else {
2101                 tokenIdsMaxLength = 0;
2102             }
2103             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2104             if (tokenIdsMaxLength == 0) {
2105                 return tokenIds;
2106             }
2107             // We need to call `explicitOwnershipOf(start)`,
2108             // because the slot at `start` may not be initialized.
2109             TokenOwnership memory ownership = explicitOwnershipOf(start);
2110             address currOwnershipAddr;
2111             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2112             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2113             if (!ownership.burned) {
2114                 currOwnershipAddr = ownership.addr;
2115             }
2116             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2117                 ownership = _ownershipAt(i);
2118                 if (ownership.burned) {
2119                     continue;
2120                 }
2121                 if (ownership.addr != address(0)) {
2122                     currOwnershipAddr = ownership.addr;
2123                 }
2124                 if (currOwnershipAddr == owner) {
2125                     tokenIds[tokenIdsIdx++] = i;
2126                 }
2127             }
2128             // Downsize the array to fit.
2129             assembly {
2130                 mstore(tokenIds, tokenIdsIdx)
2131             }
2132             return tokenIds;
2133         }
2134     }
2135 
2136     /**
2137      * @dev Returns an array of token IDs owned by `owner`.
2138      *
2139      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2140      * It is meant to be called off-chain.
2141      *
2142      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2143      * multiple smaller scans if the collection is large enough to cause
2144      * an out-of-gas error (10K collections should be fine).
2145      */
2146     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2147         unchecked {
2148             uint256 tokenIdsIdx;
2149             address currOwnershipAddr;
2150             uint256 tokenIdsLength = balanceOf(owner);
2151             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2152             TokenOwnership memory ownership;
2153             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2154                 ownership = _ownershipAt(i);
2155                 if (ownership.burned) {
2156                     continue;
2157                 }
2158                 if (ownership.addr != address(0)) {
2159                     currOwnershipAddr = ownership.addr;
2160                 }
2161                 if (currOwnershipAddr == owner) {
2162                     tokenIds[tokenIdsIdx++] = i;
2163                 }
2164             }
2165             return tokenIds;
2166         }
2167     }
2168 }
2169 
2170 // File: contracts/xmas.sol
2171 
2172 
2173 // Dev: https://twitter.com/MatthewPaquette
2174 pragma solidity ^0.8.4;
2175 
2176 
2177 
2178 
2179 
2180 
2181 
2182 contract XMASBADDIES is ERC721AQueryable, DefaultOperatorFilterer, Ownable, Pausable {
2183     uint256 public MAX_MINTS = 2000;
2184     uint256 public MAX_SUPPLY = 10000;
2185 
2186     IERC721AQueryable public baddies;
2187 
2188     string public baseURI;
2189 
2190     mapping(uint256 => bool) public tokenClaimTracker;
2191     mapping(address => bool) public VIPClaimTracker;
2192 
2193     mapping(uint256 => mapping(address => bool)) public winnersClaimTracker;
2194     uint256 currentRound = 0;
2195 
2196     bytes32 public vipRoot;
2197     bytes32 public winnerRoot;
2198 
2199     constructor(address _baddies) ERC721A("X-MAS BADDIES", "BAD") {
2200         baddies = IERC721AQueryable(_baddies);
2201     }
2202 
2203     function claimAll() external whenNotPaused {
2204         uint256[] memory ids = baddies.tokensOfOwner(msg.sender);
2205         uint256 bal = ids.length;
2206 
2207         require(totalSupply() + bal <= MAX_SUPPLY, "mintVIP: Not enough tokens left");
2208         require(bal > 0, "claimAll: No Baddies to claim");
2209 
2210         uint256 claimable = 0;
2211         for (uint256 i = 0; i < bal; i++) {
2212             if (tokenClaimTracker[ids[i]] == false) {
2213                 claimable++;
2214                 tokenClaimTracker[ids[i]] = true;
2215             }
2216         }
2217 
2218         require(claimable > 0, "claimAll: all ids have already been claimed");
2219         _safeMint(msg.sender, claimable);
2220 
2221     }
2222 
2223     function claimSingle(uint256 id) external whenNotPaused {
2224         require(tokenClaimTracker[id] == false, "claimSingle: token id has already been claimed");
2225         require(baddies.ownerOf(id) == msg.sender, "claimSingle: wallet is not owner");
2226         require(totalSupply() + 1 <= MAX_SUPPLY, "claimSingle: Not enough tokens left");
2227 
2228         tokenClaimTracker[id] = true;
2229 
2230         _safeMint(msg.sender, 1);
2231     }
2232 
2233     function claimVIP(uint256 quantity, bytes32[] calldata _proof) external whenNotPaused {
2234         require(VIPClaimTracker[msg.sender] == false, "claimVIP: address already claimed");
2235         require(totalSupply() + quantity <= MAX_SUPPLY, "claimVIP: Not enough tokens left");
2236 
2237         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2238         require(MerkleProof.verify(_proof, vipRoot, leaf), "claimVIP: address can not claim");
2239 
2240         VIPClaimTracker[msg.sender] = true;
2241 
2242         _safeMint(msg.sender, quantity);
2243     }
2244 
2245     function claimWinner(bytes32[] calldata _proof) external whenNotPaused {
2246 
2247         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2248         require(MerkleProof.verify(_proof, winnerRoot, leaf), "claimWinner: address is not winner");
2249 
2250         require(winnersClaimTracker[currentRound][msg.sender] == false, "claimWinner: address already claimed");
2251         require(totalSupply() + 1 <= MAX_SUPPLY, "claimWinner: Not enough tokens left");
2252 
2253         winnersClaimTracker[currentRound][msg.sender] = true;
2254 
2255         _safeMint(msg.sender, 1);
2256     }
2257 
2258     function airDrop(address[] calldata addrs, uint256 quantity) external onlyOwner {
2259         uint256 len = addrs.length;
2260         require(totalSupply() + (quantity * len) <= MAX_SUPPLY, "airDrop: Not enough tokens to airdrop");
2261         for (uint256 i = 0; i < len; i++) {
2262             _safeMint(addrs[i], quantity);
2263         }
2264     }
2265 
2266     function _baseURI() internal view override returns (string memory) {
2267         return baseURI;
2268     }
2269 
2270     function _startTokenId() internal pure override returns (uint256) {
2271         return 1;
2272     }
2273 
2274         function transferFrom(address from, address to, uint256 tokenId)
2275         public
2276         payable
2277         override(ERC721A, IERC721A)
2278         onlyAllowedOperator(from)
2279     {
2280         super.transferFrom(from, to, tokenId);
2281     }
2282 
2283     function safeTransferFrom(address from, address to, uint256 tokenId)
2284         public
2285         payable
2286         override(ERC721A, IERC721A)
2287         onlyAllowedOperator(from)
2288     {
2289         super.safeTransferFrom(from, to, tokenId);
2290     }
2291 
2292     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2293         public
2294         payable
2295         override(ERC721A, IERC721A)
2296         onlyAllowedOperator(from)
2297     {
2298         super.safeTransferFrom(from, to, tokenId, data);
2299     }
2300 
2301     //ADMIN
2302 
2303     function updateVIPTracker(address wallet, bool state) external onlyOwner {
2304         VIPClaimTracker[wallet] = state;
2305     }
2306 
2307     function updateTokenTracker(uint256 id, bool state) external onlyOwner {
2308         tokenClaimTracker[id] = state;
2309     }
2310 
2311     function updateVIPRoot(bytes32 _vipRoot) external onlyOwner {
2312         vipRoot = _vipRoot;
2313     }
2314 
2315     function updateRound(bytes32 _winnerRoot) external onlyOwner {
2316         currentRound++;
2317         winnerRoot = _winnerRoot;
2318     }
2319 
2320     function updateWinnerRoot(bytes32 _winnerRoot) external onlyOwner {
2321         winnerRoot = _winnerRoot;
2322     }
2323 
2324     function setMaxMint(uint256 _max) external onlyOwner {
2325         MAX_MINTS = _max;
2326     }
2327 
2328     function toggleAllMintPause() public onlyOwner {
2329         paused() ? _unpause() : _pause();
2330     }
2331 
2332     function setBaseURI(string memory _uri) external onlyOwner {
2333         baseURI = _uri;
2334     }
2335 
2336     function updateMaxSupply(uint256 _max) external onlyOwner {
2337         MAX_SUPPLY = _max;
2338     }
2339 
2340     // ya never know!
2341     function withdraw() external onlyOwner {
2342         require(address(this).balance > 0, "withdraw: contract balance must be greater than 0"); 
2343         uint256 balance = address(this).balance; 
2344         payable(msg.sender).transfer(balance);
2345     }
2346 
2347 }