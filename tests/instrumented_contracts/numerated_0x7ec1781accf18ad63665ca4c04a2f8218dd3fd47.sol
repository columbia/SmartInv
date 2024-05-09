1 // SPDX-License-Identifier: MIT
2 
3 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
4 
5 pragma solidity ^0.8.13;
6 
7 interface IOperatorFilterRegistry {
8     function isOperatorAllowed(address registrant, address operator)
9         external
10         view
11         returns (bool);
12 
13     function register(address registrant) external;
14 
15     function registerAndSubscribe(address registrant, address subscription)
16         external;
17 
18     function registerAndCopyEntries(
19         address registrant,
20         address registrantToCopy
21     ) external;
22 
23     function updateOperator(
24         address registrant,
25         address operator,
26         bool filtered
27     ) external;
28 
29     function updateOperators(
30         address registrant,
31         address[] calldata operators,
32         bool filtered
33     ) external;
34 
35     function updateCodeHash(
36         address registrant,
37         bytes32 codehash,
38         bool filtered
39     ) external;
40 
41     function updateCodeHashes(
42         address registrant,
43         bytes32[] calldata codeHashes,
44         bool filtered
45     ) external;
46 
47     function subscribe(address registrant, address registrantToSubscribe)
48         external;
49 
50     function unsubscribe(address registrant, bool copyExistingEntries) external;
51 
52     function subscriptionOf(address addr) external returns (address registrant);
53 
54     function subscribers(address registrant)
55         external
56         returns (address[] memory);
57 
58     function subscriberAt(address registrant, uint256 index)
59         external
60         returns (address);
61 
62     function copyEntriesOf(address registrant, address registrantToCopy)
63         external;
64 
65     function isOperatorFiltered(address registrant, address operator)
66         external
67         returns (bool);
68 
69     function isCodeHashOfFiltered(address registrant, address operatorWithCode)
70         external
71         returns (bool);
72 
73     function isCodeHashFiltered(address registrant, bytes32 codeHash)
74         external
75         returns (bool);
76 
77     function filteredOperators(address addr)
78         external
79         returns (address[] memory);
80 
81     function filteredCodeHashes(address addr)
82         external
83         returns (bytes32[] memory);
84 
85     function filteredOperatorAt(address registrant, uint256 index)
86         external
87         returns (address);
88 
89     function filteredCodeHashAt(address registrant, uint256 index)
90         external
91         returns (bytes32);
92 
93     function isRegistered(address addr) external returns (bool);
94 
95     function codeHashOf(address addr) external returns (bytes32);
96 }
97 
98 // File: operator-filter-registry/src/OperatorFilterer.sol
99 
100 pragma solidity ^0.8.13;
101 
102 abstract contract OperatorFilterer {
103     error OperatorNotAllowed(address operator);
104 
105     IOperatorFilterRegistry constant operatorFilterRegistry =
106         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
107 
108     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
109         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
110         // will not revert, but the contract will need to be registered with the registry once it is deployed in
111         // order for the modifier to filter addresses.
112         if (address(operatorFilterRegistry).code.length > 0) {
113             if (subscribe) {
114                 operatorFilterRegistry.registerAndSubscribe(
115                     address(this),
116                     subscriptionOrRegistrantToCopy
117                 );
118             } else {
119                 if (subscriptionOrRegistrantToCopy != address(0)) {
120                     operatorFilterRegistry.registerAndCopyEntries(
121                         address(this),
122                         subscriptionOrRegistrantToCopy
123                     );
124                 } else {
125                     operatorFilterRegistry.register(address(this));
126                 }
127             }
128         }
129     }
130 
131     modifier onlyAllowedOperator(address from) virtual {
132         // Check registry code length to facilitate testing in environments without a deployed registry.
133         if (address(operatorFilterRegistry).code.length > 0) {
134             // Allow spending tokens from addresses with balance
135             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
136             // from an EOA.
137             if (from == msg.sender) {
138                 _;
139                 return;
140             }
141             if (
142                 !(operatorFilterRegistry.isOperatorAllowed(
143                     address(this),
144                     msg.sender
145                 ) &&
146                     operatorFilterRegistry.isOperatorAllowed(
147                         address(this),
148                         from
149                     ))
150             ) {
151                 revert OperatorNotAllowed(msg.sender);
152             }
153         }
154         _;
155     }
156 }
157 
158 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
159 
160 pragma solidity ^0.8.13;
161 
162 abstract contract DefaultOperatorFilterer is OperatorFilterer {
163     address constant DEFAULT_SUBSCRIPTION =
164         address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
165 
166     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
167 }
168 
169 // File: contracts/hoshiko.sol
170 
171 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
172 
173 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
174 
175 //1b0014041a0a15
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @dev Contract module that helps prevent reentrant calls to a function.
181  *
182  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
183  * available, which can be applied to functions to make sure there are no nested
184  * (reentrant) calls to them.
185  *
186  * Note that because there is a single `nonReentrant` guard, functions marked as
187  * `nonReentrant` may not call one another. This can be worked around by making
188  * those functions `private`, and then adding `external` `nonReentrant` entry
189  * points to them.
190  *
191  * TIP: If you would like to learn more about reentrancy and alternative ways
192  * to protect against it, check out our blog post
193  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
194  */
195 abstract contract ReentrancyGuard {
196     // Booleans are more expensive than uint256 or any type that takes up a full
197     // word because each write operation emits an extra SLOAD to first read the
198     // slot's contents, replace the bits taken up by the boolean, and then write
199     // back. This is the compiler's defense against contract upgrades and
200     // pointer aliasing, and it cannot be disabled.
201 
202     // The values being non-zero value makes deployment a bit more expensive,
203     // but in exchange the refund on every call to nonReentrant will be lower in
204     // amount. Since refunds are capped to a percentage of the total
205     // transaction's gas, it is best to keep them low in cases like this one, to
206     // increase the likelihood of the full refund coming into effect.
207     uint256 private constant _NOT_ENTERED = 1;
208     uint256 private constant _ENTERED = 2;
209 
210     uint256 private _status;
211 
212     constructor() {
213         _status = _NOT_ENTERED;
214     }
215 
216     /**
217      * @dev Prevents a contract from calling itself, directly or indirectly.
218      * Calling a `nonReentrant` function from another `nonReentrant`
219      * function is not supported. It is possible to prevent this from happening
220      * by making the `nonReentrant` function external, and making it call a
221      * `private` function that does the actual work.
222      */
223     modifier nonReentrant() {
224         // On the first call to nonReentrant, _notEntered will be true
225         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
226 
227         // Any calls to nonReentrant after this point will fail
228         _status = _ENTERED;
229 
230         _;
231 
232         // By storing the original value once again, a refund is triggered (see
233         // https://eips.ethereum.org/EIPS/eip-2200)
234         _status = _NOT_ENTERED;
235     }
236 }
237 
238 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
239 
240 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 /**
245  * @dev These functions deal with verification of Merkle Tree proofs.
246  *
247  * The proofs can be generated using the JavaScript library
248  * https://github.com/miguelmota/merkletreejs[merkletreejs].
249  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
250  *
251  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
252  *
253  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
254  * hashing, or use a hash function other than keccak256 for hashing leaves.
255  * This is because the concatenation of a sorted pair of internal nodes in
256  * the merkle tree could be reinterpreted as a leaf value.
257  */
258 library MerkleProof {
259     /**
260      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
261      * defined by `root`. For this, a `proof` must be provided, containing
262      * sibling hashes on the branch from the leaf to the root of the tree. Each
263      * pair of leaves and each pair of pre-images are assumed to be sorted.
264      */
265     function verify(
266         bytes32[] memory proof,
267         bytes32 root,
268         bytes32 leaf
269     ) internal pure returns (bool) {
270         return processProof(proof, leaf) == root;
271     }
272 
273     /**
274      * @dev Calldata version of {verify}
275      *
276      * _Available since v4.7._
277      */
278     function verifyCalldata(
279         bytes32[] calldata proof,
280         bytes32 root,
281         bytes32 leaf
282     ) internal pure returns (bool) {
283         return processProofCalldata(proof, leaf) == root;
284     }
285 
286     /**
287      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
288      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
289      * hash matches the root of the tree. When processing the proof, the pairs
290      * of leafs & pre-images are assumed to be sorted.
291      *
292      * _Available since v4.4._
293      */
294     function processProof(bytes32[] memory proof, bytes32 leaf)
295         internal
296         pure
297         returns (bytes32)
298     {
299         bytes32 computedHash = leaf;
300         for (uint256 i = 0; i < proof.length; i++) {
301             computedHash = _hashPair(computedHash, proof[i]);
302         }
303         return computedHash;
304     }
305 
306     /**
307      * @dev Calldata version of {processProof}
308      *
309      * _Available since v4.7._
310      */
311     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf)
312         internal
313         pure
314         returns (bytes32)
315     {
316         bytes32 computedHash = leaf;
317         for (uint256 i = 0; i < proof.length; i++) {
318             computedHash = _hashPair(computedHash, proof[i]);
319         }
320         return computedHash;
321     }
322 
323     /**
324      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
325      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
326      *
327      * _Available since v4.7._
328      */
329     function multiProofVerify(
330         bytes32[] memory proof,
331         bool[] memory proofFlags,
332         bytes32 root,
333         bytes32[] memory leaves
334     ) internal pure returns (bool) {
335         return processMultiProof(proof, proofFlags, leaves) == root;
336     }
337 
338     /**
339      * @dev Calldata version of {multiProofVerify}
340      *
341      * _Available since v4.7._
342      */
343     function multiProofVerifyCalldata(
344         bytes32[] calldata proof,
345         bool[] calldata proofFlags,
346         bytes32 root,
347         bytes32[] memory leaves
348     ) internal pure returns (bool) {
349         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
350     }
351 
352     /**
353      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
354      * consuming from one or the other at each step according to the instructions given by
355      * `proofFlags`.
356      *
357      * _Available since v4.7._
358      */
359     function processMultiProof(
360         bytes32[] memory proof,
361         bool[] memory proofFlags,
362         bytes32[] memory leaves
363     ) internal pure returns (bytes32 merkleRoot) {
364         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
365         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
366         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
367         // the merkle tree.
368         uint256 leavesLen = leaves.length;
369         uint256 totalHashes = proofFlags.length;
370 
371         // Check proof validity.
372         require(
373             leavesLen + proof.length - 1 == totalHashes,
374             "MerkleProof: invalid multiproof"
375         );
376 
377         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
378         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
379         bytes32[] memory hashes = new bytes32[](totalHashes);
380         uint256 leafPos = 0;
381         uint256 hashPos = 0;
382         uint256 proofPos = 0;
383         // At each step, we compute the next hash using two values:
384         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
385         //   get the next hash.
386         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
387         //   `proof` array.
388         for (uint256 i = 0; i < totalHashes; i++) {
389             bytes32 a = leafPos < leavesLen
390                 ? leaves[leafPos++]
391                 : hashes[hashPos++];
392             bytes32 b = proofFlags[i]
393                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
394                 : proof[proofPos++];
395             hashes[i] = _hashPair(a, b);
396         }
397 
398         if (totalHashes > 0) {
399             return hashes[totalHashes - 1];
400         } else if (leavesLen > 0) {
401             return leaves[0];
402         } else {
403             return proof[0];
404         }
405     }
406 
407     /**
408      * @dev Calldata version of {processMultiProof}
409      *
410      * _Available since v4.7._
411      */
412     function processMultiProofCalldata(
413         bytes32[] calldata proof,
414         bool[] calldata proofFlags,
415         bytes32[] memory leaves
416     ) internal pure returns (bytes32 merkleRoot) {
417         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
418         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
419         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
420         // the merkle tree.
421         uint256 leavesLen = leaves.length;
422         uint256 totalHashes = proofFlags.length;
423 
424         // Check proof validity.
425         require(
426             leavesLen + proof.length - 1 == totalHashes,
427             "MerkleProof: invalid multiproof"
428         );
429 
430         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
431         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
432         bytes32[] memory hashes = new bytes32[](totalHashes);
433         uint256 leafPos = 0;
434         uint256 hashPos = 0;
435         uint256 proofPos = 0;
436         // At each step, we compute the next hash using two values:
437         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
438         //   get the next hash.
439         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
440         //   `proof` array.
441         for (uint256 i = 0; i < totalHashes; i++) {
442             bytes32 a = leafPos < leavesLen
443                 ? leaves[leafPos++]
444                 : hashes[hashPos++];
445             bytes32 b = proofFlags[i]
446                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
447                 : proof[proofPos++];
448             hashes[i] = _hashPair(a, b);
449         }
450 
451         if (totalHashes > 0) {
452             return hashes[totalHashes - 1];
453         } else if (leavesLen > 0) {
454             return leaves[0];
455         } else {
456             return proof[0];
457         }
458     }
459 
460     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
461         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
462     }
463 
464     function _efficientHash(bytes32 a, bytes32 b)
465         private
466         pure
467         returns (bytes32 value)
468     {
469         /// @solidity memory-safe-assembly
470         assembly {
471             mstore(0x00, a)
472             mstore(0x20, b)
473             value := keccak256(0x00, 0x40)
474         }
475     }
476 }
477 
478 pragma solidity ^0.8.4;
479 
480 /**
481  * @dev Interface of an ERC721A compliant contract.
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
500      * The caller cannot approve to the current owner.
501      */
502     error ApprovalToCurrentOwner();
503 
504     /**
505      * Cannot query the balance for the zero address.
506      */
507     error BalanceQueryForZeroAddress();
508 
509     /**
510      * Cannot mint to the zero address.
511      */
512     error MintToZeroAddress();
513 
514     /**
515      * The quantity of tokens minted must be more than zero.
516      */
517     error MintZeroQuantity();
518 
519     /**
520      * The token does not exist.
521      */
522     error OwnerQueryForNonexistentToken();
523 
524     /**
525      * The caller must own the token or be an approved operator.
526      */
527     error TransferCallerNotOwnerNorApproved();
528 
529     /**
530      * The token must be owned by `from`.
531      */
532     error TransferFromIncorrectOwner();
533 
534     /**
535      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
536      */
537     error TransferToNonERC721ReceiverImplementer();
538 
539     /**
540      * Cannot transfer to the zero address.
541      */
542     error TransferToZeroAddress();
543 
544     /**
545      * The token does not exist.
546      */
547     error URIQueryForNonexistentToken();
548 
549     struct TokenOwnership {
550         // The address of the owner.
551         address addr;
552         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
553         uint64 startTimestamp;
554         // Whether the token has been burned.
555         bool burned;
556     }
557 
558     /**
559      * @dev Returns the total amount of tokens stored by the contract.
560      *
561      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
562      */
563     function totalSupply() external view returns (uint256);
564 
565     // ==============================
566     //            IERC165
567     // ==============================
568 
569     /**
570      * @dev Returns true if this contract implements the interface defined by
571      * `interfaceId`. See the corresponding
572      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
573      * to learn more about how these ids are created.
574      *
575      * This function call must use less than 30 000 gas.
576      */
577     function supportsInterface(bytes4 interfaceId) external view returns (bool);
578 
579     // ==============================
580     //            IERC721
581     // ==============================
582 
583     /**
584      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
585      */
586     event Transfer(
587         address indexed from,
588         address indexed to,
589         uint256 indexed tokenId
590     );
591 
592     /**
593      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
594      */
595     event Approval(
596         address indexed owner,
597         address indexed approved,
598         uint256 indexed tokenId
599     );
600 
601     /**
602      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
603      */
604     event ApprovalForAll(
605         address indexed owner,
606         address indexed operator,
607         bool approved
608     );
609 
610     /**
611      * @dev Returns the number of tokens in ``owner``'s account.
612      */
613     function balanceOf(address owner) external view returns (uint256 balance);
614 
615     /**
616      * @dev Returns the owner of the `tokenId` token.
617      *
618      * Requirements:
619      *
620      * - `tokenId` must exist.
621      */
622     function ownerOf(uint256 tokenId) external view returns (address owner);
623 
624     /**
625      * @dev Safely transfers `tokenId` token from `from` to `to`.
626      *
627      * Requirements:
628      *
629      * - `from` cannot be the zero address.
630      * - `to` cannot be the zero address.
631      * - `tokenId` token must exist and be owned by `from`.
632      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
633      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
634      *
635      * Emits a {Transfer} event.
636      */
637     function safeTransferFrom(
638         address from,
639         address to,
640         uint256 tokenId,
641         bytes calldata data
642     ) external;
643 
644     /**
645      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
646      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
647      *
648      * Requirements:
649      *
650      * - `from` cannot be the zero address.
651      * - `to` cannot be the zero address.
652      * - `tokenId` token must exist and be owned by `from`.
653      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
654      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
655      *
656      * Emits a {Transfer} event.
657      */
658     function safeTransferFrom(
659         address from,
660         address to,
661         uint256 tokenId
662     ) external;
663 
664     /**
665      * @dev Transfers `tokenId` token from `from` to `to`.
666      *
667      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must be owned by `from`.
674      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
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
688      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
689      *
690      * Requirements:
691      *
692      * - The caller must own the token or be an approved operator.
693      * - `tokenId` must exist.
694      *
695      * Emits an {Approval} event.
696      */
697     function approve(address to, uint256 tokenId) external;
698 
699     /**
700      * @dev Approve or remove `operator` as an operator for the caller.
701      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
702      *
703      * Requirements:
704      *
705      * - The `operator` cannot be the caller.
706      *
707      * Emits an {ApprovalForAll} event.
708      */
709     function setApprovalForAll(address operator, bool _approved) external;
710 
711     /**
712      * @dev Returns the account approved for `tokenId` token.
713      *
714      * Requirements:
715      *
716      * - `tokenId` must exist.
717      */
718     function getApproved(uint256 tokenId)
719         external
720         view
721         returns (address operator);
722 
723     /**
724      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
725      *
726      * See {setApprovalForAll}
727      */
728     function isApprovedForAll(address owner, address operator)
729         external
730         view
731         returns (bool);
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
751 }
752 
753 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
754 
755 // ERC721A Contracts v3.3.0
756 // Creator: Chiru Labs
757 
758 pragma solidity ^0.8.4;
759 
760 /**
761  * @dev ERC721 token receiver interface.
762  */
763 interface ERC721A__IERC721Receiver {
764     function onERC721Received(
765         address operator,
766         address from,
767         uint256 tokenId,
768         bytes calldata data
769     ) external returns (bytes4);
770 }
771 
772 /**
773  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
774  * the Metadata extension. Built to optimize for lower gas during batch mints.
775  *
776  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
777  *
778  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
779  *
780  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
781  */
782 contract ERC721A is IERC721A {
783     // Mask of an entry in packed address data.
784     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
785 
786     // The bit position of `numberMinted` in packed address data.
787     uint256 private constant BITPOS_NUMBER_MINTED = 64;
788 
789     // The bit position of `numberBurned` in packed address data.
790     uint256 private constant BITPOS_NUMBER_BURNED = 128;
791 
792     // The bit position of `aux` in packed address data.
793     uint256 private constant BITPOS_AUX = 192;
794 
795     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
796     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
797 
798     // The bit position of `startTimestamp` in packed ownership.
799     uint256 private constant BITPOS_START_TIMESTAMP = 160;
800 
801     // The bit mask of the `burned` bit in packed ownership.
802     uint256 private constant BITMASK_BURNED = 1 << 224;
803 
804     // The bit position of the `nextInitialized` bit in packed ownership.
805     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
806 
807     // The bit mask of the `nextInitialized` bit in packed ownership.
808     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
809 
810     // The tokenId of the next token to be minted.
811     uint256 private _currentIndex;
812 
813     // The number of tokens burned.
814     uint256 private _burnCounter;
815 
816     // Token name
817     string private _name;
818 
819     // Token symbol
820     string private _symbol;
821 
822     // Mapping from token ID to ownership details
823     // An empty struct value does not necessarily mean the token is unowned.
824     // See `_packedOwnershipOf` implementation for details.
825     //
826     // Bits Layout:
827     // - [0..159]   `addr`
828     // - [160..223] `startTimestamp`
829     // - [224]      `burned`
830     // - [225]      `nextInitialized`
831     mapping(uint256 => uint256) private _packedOwnerships;
832 
833     // Mapping owner address to address data.
834     //
835     // Bits Layout:
836     // - [0..63]    `balance`
837     // - [64..127]  `numberMinted`
838     // - [128..191] `numberBurned`
839     // - [192..255] `aux`
840     mapping(address => uint256) private _packedAddressData;
841 
842     // Mapping from token ID to approved address.
843     mapping(uint256 => address) private _tokenApprovals;
844 
845     // Mapping from owner to operator approvals
846     mapping(address => mapping(address => bool)) private _operatorApprovals;
847 
848     constructor(string memory name_, string memory symbol_) {
849         _name = name_;
850         _symbol = symbol_;
851         _currentIndex = _startTokenId();
852     }
853 
854     /**
855      * @dev Returns the starting token ID.
856      * To change the starting token ID, please override this function.
857      */
858     function _startTokenId() internal view virtual returns (uint256) {
859         return 0;
860     }
861 
862     /**
863      * @dev Returns the next token ID to be minted.
864      */
865     function _nextTokenId() internal view returns (uint256) {
866         return _currentIndex;
867     }
868 
869     /**
870      * @dev Returns the total number of tokens in existence.
871      * Burned tokens will reduce the count.
872      * To get the total number of tokens minted, please see `_totalMinted`.
873      */
874     function totalSupply() public view override returns (uint256) {
875         // Counter underflow is impossible as _burnCounter cannot be incremented
876         // more than `_currentIndex - _startTokenId()` times.
877         unchecked {
878             return _currentIndex - _burnCounter - _startTokenId();
879         }
880     }
881 
882     /**
883      * @dev Returns the total amount of tokens minted in the contract.
884      */
885     function _totalMinted() internal view returns (uint256) {
886         // Counter underflow is impossible as _currentIndex does not decrement,
887         // and it is initialized to `_startTokenId()`
888         unchecked {
889             return _currentIndex - _startTokenId();
890         }
891     }
892 
893     /**
894      * @dev Returns the total number of tokens burned.
895      */
896     function _totalBurned() internal view returns (uint256) {
897         return _burnCounter;
898     }
899 
900     /**
901      * @dev See {IERC165-supportsInterface}.
902      */
903     function supportsInterface(bytes4 interfaceId)
904         public
905         view
906         virtual
907         override
908         returns (bool)
909     {
910         // The interface IDs are constants representing the first 4 bytes of the XOR of
911         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
912         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
913         return
914             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
915             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
916             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
917     }
918 
919     /**
920      * @dev See {IERC721-balanceOf}.
921      */
922     function balanceOf(address owner) public view override returns (uint256) {
923         if (owner == address(0)) revert BalanceQueryForZeroAddress();
924         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
925     }
926 
927     /**
928      * Returns the number of tokens minted by `owner`.
929      */
930     function _numberMinted(address owner) internal view returns (uint256) {
931         return
932             (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
933             BITMASK_ADDRESS_DATA_ENTRY;
934     }
935 
936     /**
937      * Returns the number of tokens burned by or on behalf of `owner`.
938      */
939     function _numberBurned(address owner) internal view returns (uint256) {
940         return
941             (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) &
942             BITMASK_ADDRESS_DATA_ENTRY;
943     }
944 
945     /**
946      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
947      */
948     function _getAux(address owner) internal view returns (uint64) {
949         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
950     }
951 
952     /**
953      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
954      * If there are multiple variables, please pack them into a uint64.
955      */
956     function _setAux(address owner, uint64 aux) internal {
957         uint256 packed = _packedAddressData[owner];
958         uint256 auxCasted;
959         assembly {
960             // Cast aux without masking.
961             auxCasted := aux
962         }
963         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
964         _packedAddressData[owner] = packed;
965     }
966 
967     /**
968      * Returns the packed ownership data of `tokenId`.
969      */
970     function _packedOwnershipOf(uint256 tokenId)
971         private
972         view
973         returns (uint256)
974     {
975         uint256 curr = tokenId;
976 
977         unchecked {
978             if (_startTokenId() <= curr)
979                 if (curr < _currentIndex) {
980                     uint256 packed = _packedOwnerships[curr];
981                     // If not burned.
982                     if (packed & BITMASK_BURNED == 0) {
983                         // Invariant:
984                         // There will always be an ownership that has an address and is not burned
985                         // before an ownership that does not have an address and is not burned.
986                         // Hence, curr will not underflow.
987                         //
988                         // We can directly compare the packed value.
989                         // If the address is zero, packed is zero.
990                         while (packed == 0) {
991                             packed = _packedOwnerships[--curr];
992                         }
993                         return packed;
994                     }
995                 }
996         }
997         revert OwnerQueryForNonexistentToken();
998     }
999 
1000     /**
1001      * Returns the unpacked `TokenOwnership` struct from `packed`.
1002      */
1003     function _unpackedOwnership(uint256 packed)
1004         private
1005         pure
1006         returns (TokenOwnership memory ownership)
1007     {
1008         ownership.addr = address(uint160(packed));
1009         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1010         ownership.burned = packed & BITMASK_BURNED != 0;
1011     }
1012 
1013     /**
1014      * Returns the unpacked `TokenOwnership` struct at `index`.
1015      */
1016     function _ownershipAt(uint256 index)
1017         internal
1018         view
1019         returns (TokenOwnership memory)
1020     {
1021         return _unpackedOwnership(_packedOwnerships[index]);
1022     }
1023 
1024     /**
1025      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1026      */
1027     function _initializeOwnershipAt(uint256 index) internal {
1028         if (_packedOwnerships[index] == 0) {
1029             _packedOwnerships[index] = _packedOwnershipOf(index);
1030         }
1031     }
1032 
1033     /**
1034      * Gas spent here starts off proportional to the maximum mint batch size.
1035      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1036      */
1037     function _ownershipOf(uint256 tokenId)
1038         internal
1039         view
1040         returns (TokenOwnership memory)
1041     {
1042         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-ownerOf}.
1047      */
1048     function ownerOf(uint256 tokenId) public view override returns (address) {
1049         return address(uint160(_packedOwnershipOf(tokenId)));
1050     }
1051 
1052     /**
1053      * @dev See {IERC721Metadata-name}.
1054      */
1055     function name() public view virtual override returns (string memory) {
1056         return _name;
1057     }
1058 
1059     /**
1060      * @dev See {IERC721Metadata-symbol}.
1061      */
1062     function symbol() public view virtual override returns (string memory) {
1063         return _symbol;
1064     }
1065 
1066     /**
1067      * @dev See {IERC721Metadata-tokenURI}.
1068      */
1069     function tokenURI(uint256 tokenId)
1070         public
1071         view
1072         virtual
1073         override
1074         returns (string memory)
1075     {
1076         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1077 
1078         string memory baseURI = _baseURI();
1079         return
1080             bytes(baseURI).length != 0
1081                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
1082                 : "";
1083     }
1084 
1085     /**
1086      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1087      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1088      * by default, can be overriden in child contracts.
1089      */
1090     function _baseURI() internal view virtual returns (string memory) {
1091         return "";
1092     }
1093 
1094     /**
1095      * @dev Casts the address to uint256 without masking.
1096      */
1097     function _addressToUint256(address value)
1098         private
1099         pure
1100         returns (uint256 result)
1101     {
1102         assembly {
1103             result := value
1104         }
1105     }
1106 
1107     /**
1108      * @dev Casts the boolean to uint256 without branching.
1109      */
1110     function _boolToUint256(bool value) private pure returns (uint256 result) {
1111         assembly {
1112             result := value
1113         }
1114     }
1115 
1116     /**
1117      * @dev See {IERC721-approve}.
1118      */
1119     function approve(address to, uint256 tokenId) public override {
1120         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1121         if (to == owner) revert ApprovalToCurrentOwner();
1122 
1123         if (_msgSenderERC721A() != owner)
1124             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1125                 revert ApprovalCallerNotOwnerNorApproved();
1126             }
1127 
1128         _tokenApprovals[tokenId] = to;
1129         emit Approval(owner, to, tokenId);
1130     }
1131 
1132     /**
1133      * @dev See {IERC721-getApproved}.
1134      */
1135     function getApproved(uint256 tokenId)
1136         public
1137         view
1138         override
1139         returns (address)
1140     {
1141         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1142 
1143         return _tokenApprovals[tokenId];
1144     }
1145 
1146     /**
1147      * @dev See {IERC721-setApprovalForAll}.
1148      */
1149     function setApprovalForAll(address operator, bool approved)
1150         public
1151         virtual
1152         override
1153     {
1154         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1155 
1156         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1157         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1158     }
1159 
1160     /**
1161      * @dev See {IERC721-isApprovedForAll}.
1162      */
1163     function isApprovedForAll(address owner, address operator)
1164         public
1165         view
1166         virtual
1167         override
1168         returns (bool)
1169     {
1170         return _operatorApprovals[owner][operator];
1171     }
1172 
1173     /**
1174      * @dev See {IERC721-transferFrom}.
1175      */
1176     function transferFrom(
1177         address from,
1178         address to,
1179         uint256 tokenId
1180     ) public virtual override {
1181         _transfer(from, to, tokenId);
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-safeTransferFrom}.
1186      */
1187     function safeTransferFrom(
1188         address from,
1189         address to,
1190         uint256 tokenId
1191     ) public virtual override {
1192         safeTransferFrom(from, to, tokenId, "");
1193     }
1194 
1195     /**
1196      * @dev See {IERC721-safeTransferFrom}.
1197      */
1198     function safeTransferFrom(
1199         address from,
1200         address to,
1201         uint256 tokenId,
1202         bytes memory _data
1203     ) public virtual override {
1204         _transfer(from, to, tokenId);
1205         if (to.code.length != 0)
1206             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1207                 revert TransferToNonERC721ReceiverImplementer();
1208             }
1209     }
1210 
1211     /**
1212      * @dev Returns whether `tokenId` exists.
1213      *
1214      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1215      *
1216      * Tokens start existing when they are minted (`_mint`),
1217      */
1218     function _exists(uint256 tokenId) internal view returns (bool) {
1219         return
1220             _startTokenId() <= tokenId &&
1221             tokenId < _currentIndex && // If within bounds,
1222             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1223     }
1224 
1225     /**
1226      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1227      */
1228     function _safeMint(address to, uint256 quantity) internal {
1229         _safeMint(to, quantity, "");
1230     }
1231 
1232     /**
1233      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1234      *
1235      * Requirements:
1236      *
1237      * - If `to` refers to a smart contract, it must implement
1238      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1239      * - `quantity` must be greater than 0.
1240      *
1241      * Emits a {Transfer} event.
1242      */
1243     function _safeMint(
1244         address to,
1245         uint256 quantity,
1246         bytes memory _data
1247     ) internal {
1248         uint256 startTokenId = _currentIndex;
1249         if (to == address(0)) revert MintToZeroAddress();
1250         if (quantity == 0) revert MintZeroQuantity();
1251 
1252         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1253 
1254         // Overflows are incredibly unrealistic.
1255         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1256         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1257         unchecked {
1258             // Updates:
1259             // - `balance += quantity`.
1260             // - `numberMinted += quantity`.
1261             //
1262             // We can directly add to the balance and number minted.
1263             _packedAddressData[to] +=
1264                 quantity *
1265                 ((1 << BITPOS_NUMBER_MINTED) | 1);
1266 
1267             // Updates:
1268             // - `address` to the owner.
1269             // - `startTimestamp` to the timestamp of minting.
1270             // - `burned` to `false`.
1271             // - `nextInitialized` to `quantity == 1`.
1272             _packedOwnerships[startTokenId] =
1273                 _addressToUint256(to) |
1274                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1275                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1276 
1277             uint256 updatedIndex = startTokenId;
1278             uint256 end = updatedIndex + quantity;
1279 
1280             if (to.code.length != 0) {
1281                 do {
1282                     emit Transfer(address(0), to, updatedIndex);
1283                     if (
1284                         !_checkContractOnERC721Received(
1285                             address(0),
1286                             to,
1287                             updatedIndex++,
1288                             _data
1289                         )
1290                     ) {
1291                         revert TransferToNonERC721ReceiverImplementer();
1292                     }
1293                 } while (updatedIndex < end);
1294                 // Reentrancy protection
1295                 if (_currentIndex != startTokenId) revert();
1296             } else {
1297                 do {
1298                     emit Transfer(address(0), to, updatedIndex++);
1299                 } while (updatedIndex < end);
1300             }
1301             _currentIndex = updatedIndex;
1302         }
1303         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1304     }
1305 
1306     /**
1307      * @dev Mints `quantity` tokens and transfers them to `to`.
1308      *
1309      * Requirements:
1310      *
1311      * - `to` cannot be the zero address.
1312      * - `quantity` must be greater than 0.
1313      *
1314      * Emits a {Transfer} event.
1315      */
1316     function _mint(address to, uint256 quantity) internal {
1317         uint256 startTokenId = _currentIndex;
1318         if (to == address(0)) revert MintToZeroAddress();
1319         if (quantity == 0) revert MintZeroQuantity();
1320 
1321         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1322 
1323         // Overflows are incredibly unrealistic.
1324         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1325         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1326         unchecked {
1327             // Updates:
1328             // - `balance += quantity`.
1329             // - `numberMinted += quantity`.
1330             //
1331             // We can directly add to the balance and number minted.
1332             _packedAddressData[to] +=
1333                 quantity *
1334                 ((1 << BITPOS_NUMBER_MINTED) | 1);
1335 
1336             // Updates:
1337             // - `address` to the owner.
1338             // - `startTimestamp` to the timestamp of minting.
1339             // - `burned` to `false`.
1340             // - `nextInitialized` to `quantity == 1`.
1341             _packedOwnerships[startTokenId] =
1342                 _addressToUint256(to) |
1343                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1344                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1345 
1346             uint256 updatedIndex = startTokenId;
1347             uint256 end = updatedIndex + quantity;
1348 
1349             do {
1350                 emit Transfer(address(0), to, updatedIndex++);
1351             } while (updatedIndex < end);
1352 
1353             _currentIndex = updatedIndex;
1354         }
1355         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1356     }
1357 
1358     /**
1359      * @dev Transfers `tokenId` from `from` to `to`.
1360      *
1361      * Requirements:
1362      *
1363      * - `to` cannot be the zero address.
1364      * - `tokenId` token must be owned by `from`.
1365      *
1366      * Emits a {Transfer} event.
1367      */
1368     function _transfer(
1369         address from,
1370         address to,
1371         uint256 tokenId
1372     ) private {
1373         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1374 
1375         if (address(uint160(prevOwnershipPacked)) != from)
1376             revert TransferFromIncorrectOwner();
1377 
1378         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1379             isApprovedForAll(from, _msgSenderERC721A()) ||
1380             getApproved(tokenId) == _msgSenderERC721A());
1381 
1382         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1383         if (to == address(0)) revert TransferToZeroAddress();
1384 
1385         _beforeTokenTransfers(from, to, tokenId, 1);
1386 
1387         // Clear approvals from the previous owner.
1388         delete _tokenApprovals[tokenId];
1389 
1390         // Underflow of the sender's balance is impossible because we check for
1391         // ownership above and the recipient's balance can't realistically overflow.
1392         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1393         unchecked {
1394             // We can directly increment and decrement the balances.
1395             --_packedAddressData[from]; // Updates: `balance -= 1`.
1396             ++_packedAddressData[to]; // Updates: `balance += 1`.
1397 
1398             // Updates:
1399             // - `address` to the next owner.
1400             // - `startTimestamp` to the timestamp of transfering.
1401             // - `burned` to `false`.
1402             // - `nextInitialized` to `true`.
1403             _packedOwnerships[tokenId] =
1404                 _addressToUint256(to) |
1405                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1406                 BITMASK_NEXT_INITIALIZED;
1407 
1408             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1409             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1410                 uint256 nextTokenId = tokenId + 1;
1411                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1412                 if (_packedOwnerships[nextTokenId] == 0) {
1413                     // If the next slot is within bounds.
1414                     if (nextTokenId != _currentIndex) {
1415                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1416                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1417                     }
1418                 }
1419             }
1420         }
1421 
1422         emit Transfer(from, to, tokenId);
1423         _afterTokenTransfers(from, to, tokenId, 1);
1424     }
1425 
1426     /**
1427      * @dev Equivalent to `_burn(tokenId, false)`.
1428      */
1429     function _burn(uint256 tokenId) internal virtual {
1430         _burn(tokenId, false);
1431     }
1432 
1433     /**
1434      * @dev Destroys `tokenId`.
1435      * The approval is cleared when the token is burned.
1436      *
1437      * Requirements:
1438      *
1439      * - `tokenId` must exist.
1440      *
1441      * Emits a {Transfer} event.
1442      */
1443     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1444         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1445 
1446         address from = address(uint160(prevOwnershipPacked));
1447 
1448         if (approvalCheck) {
1449             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1450                 isApprovedForAll(from, _msgSenderERC721A()) ||
1451                 getApproved(tokenId) == _msgSenderERC721A());
1452 
1453             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1454         }
1455 
1456         _beforeTokenTransfers(from, address(0), tokenId, 1);
1457 
1458         // Clear approvals from the previous owner.
1459         delete _tokenApprovals[tokenId];
1460 
1461         // Underflow of the sender's balance is impossible because we check for
1462         // ownership above and the recipient's balance can't realistically overflow.
1463         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1464         unchecked {
1465             // Updates:
1466             // - `balance -= 1`.
1467             // - `numberBurned += 1`.
1468             //
1469             // We can directly decrement the balance, and increment the number burned.
1470             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1471             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1472 
1473             // Updates:
1474             // - `address` to the last owner.
1475             // - `startTimestamp` to the timestamp of burning.
1476             // - `burned` to `true`.
1477             // - `nextInitialized` to `true`.
1478             _packedOwnerships[tokenId] =
1479                 _addressToUint256(from) |
1480                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1481                 BITMASK_BURNED |
1482                 BITMASK_NEXT_INITIALIZED;
1483 
1484             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1485             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1486                 uint256 nextTokenId = tokenId + 1;
1487                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1488                 if (_packedOwnerships[nextTokenId] == 0) {
1489                     // If the next slot is within bounds.
1490                     if (nextTokenId != _currentIndex) {
1491                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1492                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1493                     }
1494                 }
1495             }
1496         }
1497 
1498         emit Transfer(from, address(0), tokenId);
1499         _afterTokenTransfers(from, address(0), tokenId, 1);
1500 
1501         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1502         unchecked {
1503             _burnCounter++;
1504         }
1505     }
1506 
1507     /**
1508      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1509      *
1510      * @param from address representing the previous owner of the given token ID
1511      * @param to target address that will receive the tokens
1512      * @param tokenId uint256 ID of the token to be transferred
1513      * @param _data bytes optional data to send along with the call
1514      * @return bool whether the call correctly returned the expected magic value
1515      */
1516     function _checkContractOnERC721Received(
1517         address from,
1518         address to,
1519         uint256 tokenId,
1520         bytes memory _data
1521     ) private returns (bool) {
1522         try
1523             ERC721A__IERC721Receiver(to).onERC721Received(
1524                 _msgSenderERC721A(),
1525                 from,
1526                 tokenId,
1527                 _data
1528             )
1529         returns (bytes4 retval) {
1530             return
1531                 retval ==
1532                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
1533         } catch (bytes memory reason) {
1534             if (reason.length == 0) {
1535                 revert TransferToNonERC721ReceiverImplementer();
1536             } else {
1537                 assembly {
1538                     revert(add(32, reason), mload(reason))
1539                 }
1540             }
1541         }
1542     }
1543 
1544     /**
1545      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1546      * And also called before burning one token.
1547      *
1548      * startTokenId - the first token id to be transferred
1549      * quantity - the amount to be transferred
1550      *
1551      * Calling conditions:
1552      *
1553      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1554      * transferred to `to`.
1555      * - When `from` is zero, `tokenId` will be minted for `to`.
1556      * - When `to` is zero, `tokenId` will be burned by `from`.
1557      * - `from` and `to` are never both zero.
1558      */
1559     function _beforeTokenTransfers(
1560         address from,
1561         address to,
1562         uint256 startTokenId,
1563         uint256 quantity
1564     ) internal virtual {}
1565 
1566     /**
1567      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1568      * minting.
1569      * And also called after one token has been burned.
1570      *
1571      * startTokenId - the first token id to be transferred
1572      * quantity - the amount to be transferred
1573      *
1574      * Calling conditions:
1575      *
1576      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1577      * transferred to `to`.
1578      * - When `from` is zero, `tokenId` has been minted for `to`.
1579      * - When `to` is zero, `tokenId` has been burned by `from`.
1580      * - `from` and `to` are never both zero.
1581      */
1582     function _afterTokenTransfers(
1583         address from,
1584         address to,
1585         uint256 startTokenId,
1586         uint256 quantity
1587     ) internal virtual {}
1588 
1589     /**
1590      * @dev Returns the message sender (defaults to `msg.sender`).
1591      *
1592      * If you are writing GSN compatible contracts, you need to override this function.
1593      */
1594     function _msgSenderERC721A() internal view virtual returns (address) {
1595         return msg.sender;
1596     }
1597 
1598     /**
1599      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1600      */
1601     function _toString(uint256 value)
1602         internal
1603         pure
1604         returns (string memory ptr)
1605     {
1606         assembly {
1607             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1608             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1609             // We will need 1 32-byte word to store the length,
1610             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1611             ptr := add(mload(0x40), 128)
1612             // Update the free memory pointer to allocate.
1613             mstore(0x40, ptr)
1614 
1615             // Cache the end of the memory to calculate the length later.
1616             let end := ptr
1617 
1618             // We write the string from the rightmost digit to the leftmost digit.
1619             // The following is essentially a do-while loop that also handles the zero case.
1620             // Costs a bit more than early returning for the zero case,
1621             // but cheaper in terms of deployment and overall runtime costs.
1622             for {
1623                 // Initialize and perform the first pass without check.
1624                 let temp := value
1625                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1626                 ptr := sub(ptr, 1)
1627                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1628                 mstore8(ptr, add(48, mod(temp, 10)))
1629                 temp := div(temp, 10)
1630             } temp {
1631                 // Keep dividing `temp` until zero.
1632                 temp := div(temp, 10)
1633             } {
1634                 // Body of the for loop.
1635                 ptr := sub(ptr, 1)
1636                 mstore8(ptr, add(48, mod(temp, 10)))
1637             }
1638 
1639             let length := sub(end, ptr)
1640             // Move the pointer 32 bytes leftwards to make room for the length.
1641             ptr := sub(ptr, 32)
1642             // Store the length.
1643             mstore(ptr, length)
1644         }
1645     }
1646 }
1647 
1648 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1649 
1650 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1651 
1652 pragma solidity ^0.8.0;
1653 
1654 /**
1655  * @dev String operations.
1656  */
1657 library Strings {
1658     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1659     uint8 private constant _ADDRESS_LENGTH = 20;
1660 
1661     /**
1662      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1663      */
1664     function toString(uint256 value) internal pure returns (string memory) {
1665         // Inspired by OraclizeAPI's implementation - MIT licence
1666         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1667 
1668         if (value == 0) {
1669             return "0";
1670         }
1671         uint256 temp = value;
1672         uint256 digits;
1673         while (temp != 0) {
1674             digits++;
1675             temp /= 10;
1676         }
1677         bytes memory buffer = new bytes(digits);
1678         while (value != 0) {
1679             digits -= 1;
1680             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1681             value /= 10;
1682         }
1683         return string(buffer);
1684     }
1685 
1686     /**
1687      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1688      */
1689     function toHexString(uint256 value) internal pure returns (string memory) {
1690         if (value == 0) {
1691             return "0x00";
1692         }
1693         uint256 temp = value;
1694         uint256 length = 0;
1695         while (temp != 0) {
1696             length++;
1697             temp >>= 8;
1698         }
1699         return toHexString(value, length);
1700     }
1701 
1702     /**
1703      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1704      */
1705     function toHexString(uint256 value, uint256 length)
1706         internal
1707         pure
1708         returns (string memory)
1709     {
1710         bytes memory buffer = new bytes(2 * length + 2);
1711         buffer[0] = "0";
1712         buffer[1] = "x";
1713         for (uint256 i = 2 * length + 1; i > 1; --i) {
1714             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1715             value >>= 4;
1716         }
1717         require(value == 0, "Strings: hex length insufficient");
1718         return string(buffer);
1719     }
1720 
1721     /**
1722      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1723      */
1724     function toHexString(address addr) internal pure returns (string memory) {
1725         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1726     }
1727 }
1728 
1729 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1730 
1731 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1732 
1733 pragma solidity ^0.8.0;
1734 
1735 /**
1736  * @dev Provides information about the current execution context, including the
1737  * sender of the transaction and its data. While these are generally available
1738  * via msg.sender and msg.data, they should not be accessed in such a direct
1739  * manner, since when dealing with meta-transactions the account sending and
1740  * paying for execution may not be the actual sender (as far as an application
1741  * is concerned).
1742  *
1743  * This contract is only required for intermediate, library-like contracts.
1744  */
1745 abstract contract Context {
1746     function _msgSender() internal view virtual returns (address) {
1747         return msg.sender;
1748     }
1749 
1750     function _msgData() internal view virtual returns (bytes calldata) {
1751         return msg.data;
1752     }
1753 }
1754 
1755 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1756 
1757 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1758 
1759 pragma solidity ^0.8.0;
1760 
1761 /**
1762  * @dev Contract module which provides a basic access control mechanism, where
1763  * there is an account (an owner) that can be granted exclusive access to
1764  * specific functions.
1765  *
1766  * By default, the owner account will be the one that deploys the contract. This
1767  * can later be changed with {transferOwnership}.
1768  *
1769  * This module is used through inheritance. It will make available the modifier
1770  * `onlyOwner`, which can be applied to your functions to restrict their use to
1771  * the owner.
1772  */
1773 abstract contract Ownable is Context {
1774     address private _owner;
1775 
1776     event OwnershipTransferred(
1777         address indexed previousOwner,
1778         address indexed newOwner
1779     );
1780 
1781     /**
1782      * @dev Initializes the contract setting the deployer as the initial owner.
1783      */
1784     constructor() {
1785         _transferOwnership(_msgSender());
1786     }
1787 
1788     /**
1789      * @dev Returns the address of the current owner.
1790      */
1791     function owner() public view virtual returns (address) {
1792         return _owner;
1793     }
1794 
1795     /**
1796      * @dev Throws if called by any account other than the owner.
1797      */
1798     modifier onlyOwner() {
1799         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1800         _;
1801     }
1802 
1803     /**
1804      * @dev Leaves the contract without owner. It will not be possible to call
1805      * `onlyOwner` functions anymore. Can only be called by the current owner.
1806      *
1807      * NOTE: Renouncing ownership will leave the contract without an owner,
1808      * thereby removing any functionality that is only available to the owner.
1809      */
1810     function renounceOwnership() public virtual onlyOwner {
1811         _transferOwnership(address(0));
1812     }
1813 
1814     /**
1815      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1816      * Can only be called by the current owner.
1817      */
1818     function transferOwnership(address newOwner) public virtual onlyOwner {
1819         require(
1820             newOwner != address(0),
1821             "Ownable: new owner is the zero address"
1822         );
1823         _transferOwnership(newOwner);
1824     }
1825 
1826     /**
1827      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1828      * Internal function without access restriction.
1829      */
1830     function _transferOwnership(address newOwner) internal virtual {
1831         address oldOwner = _owner;
1832         _owner = newOwner;
1833         emit OwnershipTransferred(oldOwner, newOwner);
1834     }
1835 }
1836 
1837 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1838 
1839 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1840 
1841 pragma solidity ^0.8.1;
1842 
1843 /**
1844  * @dev Collection of functions related to the address type
1845  */
1846 library Address {
1847     /**
1848      * @dev Returns true if `account` is a contract.
1849      *
1850      * [IMPORTANT]
1851      * ====
1852      * It is unsafe to assume that an address for which this function returns
1853      * false is an externally-owned account (EOA) and not a contract.
1854      *
1855      * Among others, `isContract` will return false for the following
1856      * types of addresses:
1857      *
1858      *  - an externally-owned account
1859      *  - a contract in construction
1860      *  - an address where a contract will be created
1861      *  - an address where a contract lived, but was destroyed
1862      * ====
1863      *
1864      * [IMPORTANT]
1865      * ====
1866      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1867      *
1868      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1869      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1870      * constructor.
1871      * ====
1872      */
1873     function isContract(address account) internal view returns (bool) {
1874         // This method relies on extcodesize/address.code.length, which returns 0
1875         // for contracts in construction, since the code is only stored at the end
1876         // of the constructor execution.
1877 
1878         return account.code.length > 0;
1879     }
1880 
1881     /**
1882      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1883      * `recipient`, forwarding all available gas and reverting on errors.
1884      *
1885      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1886      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1887      * imposed by `transfer`, making them unable to receive funds via
1888      * `transfer`. {sendValue} removes this limitation.
1889      *
1890      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1891      *
1892      * IMPORTANT: because control is transferred to `recipient`, care must be
1893      * taken to not create reentrancy vulnerabilities. Consider using
1894      * {ReentrancyGuard} or the
1895      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1896      */
1897     function sendValue(address payable recipient, uint256 amount) internal {
1898         require(
1899             address(this).balance >= amount,
1900             "Address: insufficient balance"
1901         );
1902 
1903         (bool success, ) = recipient.call{value: amount}("");
1904         require(
1905             success,
1906             "Address: unable to send value, recipient may have reverted"
1907         );
1908     }
1909 
1910     /**
1911      * @dev Performs a Solidity function call using a low level `call`. A
1912      * plain `call` is an unsafe replacement for a function call: use this
1913      * function instead.
1914      *
1915      * If `target` reverts with a revert reason, it is bubbled up by this
1916      * function (like regular Solidity function calls).
1917      *
1918      * Returns the raw returned data. To convert to the expected return value,
1919      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1920      *
1921      * Requirements:
1922      *
1923      * - `target` must be a contract.
1924      * - calling `target` with `data` must not revert.
1925      *
1926      * _Available since v3.1._
1927      */
1928     function functionCall(address target, bytes memory data)
1929         internal
1930         returns (bytes memory)
1931     {
1932         return functionCall(target, data, "Address: low-level call failed");
1933     }
1934 
1935     /**
1936      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1937      * `errorMessage` as a fallback revert reason when `target` reverts.
1938      *
1939      * _Available since v3.1._
1940      */
1941     function functionCall(
1942         address target,
1943         bytes memory data,
1944         string memory errorMessage
1945     ) internal returns (bytes memory) {
1946         return functionCallWithValue(target, data, 0, errorMessage);
1947     }
1948 
1949     /**
1950      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1951      * but also transferring `value` wei to `target`.
1952      *
1953      * Requirements:
1954      *
1955      * - the calling contract must have an ETH balance of at least `value`.
1956      * - the called Solidity function must be `payable`.
1957      *
1958      * _Available since v3.1._
1959      */
1960     function functionCallWithValue(
1961         address target,
1962         bytes memory data,
1963         uint256 value
1964     ) internal returns (bytes memory) {
1965         return
1966             functionCallWithValue(
1967                 target,
1968                 data,
1969                 value,
1970                 "Address: low-level call with value failed"
1971             );
1972     }
1973 
1974     /**
1975      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1976      * with `errorMessage` as a fallback revert reason when `target` reverts.
1977      *
1978      * _Available since v3.1._
1979      */
1980     function functionCallWithValue(
1981         address target,
1982         bytes memory data,
1983         uint256 value,
1984         string memory errorMessage
1985     ) internal returns (bytes memory) {
1986         require(
1987             address(this).balance >= value,
1988             "Address: insufficient balance for call"
1989         );
1990         require(isContract(target), "Address: call to non-contract");
1991 
1992         (bool success, bytes memory returndata) = target.call{value: value}(
1993             data
1994         );
1995         return verifyCallResult(success, returndata, errorMessage);
1996     }
1997 
1998     /**
1999      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2000      * but performing a static call.
2001      *
2002      * _Available since v3.3._
2003      */
2004     function functionStaticCall(address target, bytes memory data)
2005         internal
2006         view
2007         returns (bytes memory)
2008     {
2009         return
2010             functionStaticCall(
2011                 target,
2012                 data,
2013                 "Address: low-level static call failed"
2014             );
2015     }
2016 
2017     /**
2018      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2019      * but performing a static call.
2020      *
2021      * _Available since v3.3._
2022      */
2023     function functionStaticCall(
2024         address target,
2025         bytes memory data,
2026         string memory errorMessage
2027     ) internal view returns (bytes memory) {
2028         require(isContract(target), "Address: static call to non-contract");
2029 
2030         (bool success, bytes memory returndata) = target.staticcall(data);
2031         return verifyCallResult(success, returndata, errorMessage);
2032     }
2033 
2034     /**
2035      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2036      * but performing a delegate call.
2037      *
2038      * _Available since v3.4._
2039      */
2040     function functionDelegateCall(address target, bytes memory data)
2041         internal
2042         returns (bytes memory)
2043     {
2044         return
2045             functionDelegateCall(
2046                 target,
2047                 data,
2048                 "Address: low-level delegate call failed"
2049             );
2050     }
2051 
2052     /**
2053      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2054      * but performing a delegate call.
2055      *
2056      * _Available since v3.4._
2057      */
2058     function functionDelegateCall(
2059         address target,
2060         bytes memory data,
2061         string memory errorMessage
2062     ) internal returns (bytes memory) {
2063         require(isContract(target), "Address: delegate call to non-contract");
2064 
2065         (bool success, bytes memory returndata) = target.delegatecall(data);
2066         return verifyCallResult(success, returndata, errorMessage);
2067     }
2068 
2069     /**
2070      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
2071      * revert reason using the provided one.
2072      *
2073      * _Available since v4.3._
2074      */
2075     function verifyCallResult(
2076         bool success,
2077         bytes memory returndata,
2078         string memory errorMessage
2079     ) internal pure returns (bytes memory) {
2080         if (success) {
2081             return returndata;
2082         } else {
2083             // Look for revert reason and bubble it up if present
2084             if (returndata.length > 0) {
2085                 // The easiest way to bubble the revert reason is using memory via assembly
2086 
2087                 assembly {
2088                     let returndata_size := mload(returndata)
2089                     revert(add(32, returndata), returndata_size)
2090                 }
2091             } else {
2092                 revert(errorMessage);
2093             }
2094         }
2095     }
2096 }
2097 
2098 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
2099 
2100 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
2101 
2102 pragma solidity ^0.8.0;
2103 
2104 /**
2105  * @title ERC721 token receiver interface
2106  * @dev Interface for any contract that wants to support safeTransfers
2107  * from ERC721 asset contracts.
2108  */
2109 interface IERC721Receiver {
2110     /**
2111      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2112      * by `operator` from `from`, this function is called.
2113      *
2114      * It must return its Solidity selector to confirm the token transfer.
2115      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2116      *
2117      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
2118      */
2119     function onERC721Received(
2120         address operator,
2121         address from,
2122         uint256 tokenId,
2123         bytes calldata data
2124     ) external returns (bytes4);
2125 }
2126 
2127 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
2128 
2129 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2130 
2131 pragma solidity ^0.8.0;
2132 
2133 /**
2134  * @dev Interface of the ERC165 standard, as defined in the
2135  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2136  *
2137  * Implementers can declare support of contract interfaces, which can then be
2138  * queried by others ({ERC165Checker}).
2139  *
2140  * For an implementation, see {ERC165}.
2141  */
2142 interface IERC165 {
2143     /**
2144      * @dev Returns true if this contract implements the interface defined by
2145      * `interfaceId`. See the corresponding
2146      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2147      * to learn more about how these ids are created.
2148      *
2149      * This function call must use less than 30 000 gas.
2150      */
2151     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2152 }
2153 
2154 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
2155 
2156 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2157 
2158 pragma solidity ^0.8.0;
2159 
2160 /**
2161  * @dev Implementation of the {IERC165} interface.
2162  *
2163  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2164  * for the additional interface id that will be supported. For example:
2165  *
2166  * ```solidity
2167  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2168  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2169  * }
2170  * ```
2171  *
2172  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2173  */
2174 abstract contract ERC165 is IERC165 {
2175     /**
2176      * @dev See {IERC165-supportsInterface}.
2177      */
2178     function supportsInterface(bytes4 interfaceId)
2179         public
2180         view
2181         virtual
2182         override
2183         returns (bool)
2184     {
2185         return interfaceId == type(IERC165).interfaceId;
2186     }
2187 }
2188 
2189 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
2190 
2191 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
2192 
2193 pragma solidity ^0.8.0;
2194 
2195 /**
2196  * @dev Required interface of an ERC721 compliant contract.
2197  */
2198 interface IERC721 is IERC165 {
2199     /**
2200      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2201      */
2202     event Transfer(
2203         address indexed from,
2204         address indexed to,
2205         uint256 indexed tokenId
2206     );
2207 
2208     /**
2209      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2210      */
2211     event Approval(
2212         address indexed owner,
2213         address indexed approved,
2214         uint256 indexed tokenId
2215     );
2216 
2217     /**
2218      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2219      */
2220     event ApprovalForAll(
2221         address indexed owner,
2222         address indexed operator,
2223         bool approved
2224     );
2225 
2226     /**
2227      * @dev Returns the number of tokens in ``owner``'s account.
2228      */
2229     function balanceOf(address owner) external view returns (uint256 balance);
2230 
2231     /**
2232      * @dev Returns the owner of the `tokenId` token.
2233      *
2234      * Requirements:
2235      *
2236      * - `tokenId` must exist.
2237      */
2238     function ownerOf(uint256 tokenId) external view returns (address owner);
2239 
2240     /**
2241      * @dev Safely transfers `tokenId` token from `from` to `to`.
2242      *
2243      * Requirements:
2244      *
2245      * - `from` cannot be the zero address.
2246      * - `to` cannot be the zero address.
2247      * - `tokenId` token must exist and be owned by `from`.
2248      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2249      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2250      *
2251      * Emits a {Transfer} event.
2252      */
2253     function safeTransferFrom(
2254         address from,
2255         address to,
2256         uint256 tokenId,
2257         bytes calldata data
2258     ) external;
2259 
2260     /**
2261      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2262      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2263      *
2264      * Requirements:
2265      *
2266      * - `from` cannot be the zero address.
2267      * - `to` cannot be the zero address.
2268      * - `tokenId` token must exist and be owned by `from`.
2269      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
2270      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2271      *
2272      * Emits a {Transfer} event.
2273      */
2274     function safeTransferFrom(
2275         address from,
2276         address to,
2277         uint256 tokenId
2278     ) external;
2279 
2280     /**
2281      * @dev Transfers `tokenId` token from `from` to `to`.
2282      *
2283      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
2284      *
2285      * Requirements:
2286      *
2287      * - `from` cannot be the zero address.
2288      * - `to` cannot be the zero address.
2289      * - `tokenId` token must be owned by `from`.
2290      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2291      *
2292      * Emits a {Transfer} event.
2293      */
2294     function transferFrom(
2295         address from,
2296         address to,
2297         uint256 tokenId
2298     ) external;
2299 
2300     /**
2301      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2302      * The approval is cleared when the token is transferred.
2303      *
2304      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2305      *
2306      * Requirements:
2307      *
2308      * - The caller must own the token or be an approved operator.
2309      * - `tokenId` must exist.
2310      *
2311      * Emits an {Approval} event.
2312      */
2313     function approve(address to, uint256 tokenId) external;
2314 
2315     /**
2316      * @dev Approve or remove `operator` as an operator for the caller.
2317      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2318      *
2319      * Requirements:
2320      *
2321      * - The `operator` cannot be the caller.
2322      *
2323      * Emits an {ApprovalForAll} event.
2324      */
2325     function setApprovalForAll(address operator, bool _approved) external;
2326 
2327     /**
2328      * @dev Returns the account approved for `tokenId` token.
2329      *
2330      * Requirements:
2331      *
2332      * - `tokenId` must exist.
2333      */
2334     function getApproved(uint256 tokenId)
2335         external
2336         view
2337         returns (address operator);
2338 
2339     /**
2340      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2341      *
2342      * See {setApprovalForAll}
2343      */
2344     function isApprovedForAll(address owner, address operator)
2345         external
2346         view
2347         returns (bool);
2348 }
2349 
2350 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
2351 
2352 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2353 
2354 pragma solidity ^0.8.0;
2355 
2356 /**
2357  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2358  * @dev See https://eips.ethereum.org/EIPS/eip-721
2359  */
2360 interface IERC721Metadata is IERC721 {
2361     /**
2362      * @dev Returns the token collection name.
2363      */
2364     function name() external view returns (string memory);
2365 
2366     /**
2367      * @dev Returns the token collection symbol.
2368      */
2369     function symbol() external view returns (string memory);
2370 
2371     /**
2372      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2373      */
2374     function tokenURI(uint256 tokenId) external view returns (string memory);
2375 }
2376 
2377 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
2378 
2379 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
2380 
2381 pragma solidity ^0.8.0;
2382 
2383 /**
2384  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2385  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2386  * {ERC721Enumerable}.
2387  */
2388 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2389     using Address for address;
2390     using Strings for uint256;
2391 
2392     // Token name
2393     string private _name;
2394 
2395     // Token symbol
2396     string private _symbol;
2397 
2398     // Mapping from token ID to owner address
2399     mapping(uint256 => address) private _owners;
2400 
2401     // Mapping owner address to token count
2402     mapping(address => uint256) private _balances;
2403 
2404     // Mapping from token ID to approved address
2405     mapping(uint256 => address) private _tokenApprovals;
2406 
2407     // Mapping from owner to operator approvals
2408     mapping(address => mapping(address => bool)) private _operatorApprovals;
2409 
2410     /**
2411      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2412      */
2413     constructor(string memory name_, string memory symbol_) {
2414         _name = name_;
2415         _symbol = symbol_;
2416     }
2417 
2418     /**
2419      * @dev See {IERC165-supportsInterface}.
2420      */
2421     function supportsInterface(bytes4 interfaceId)
2422         public
2423         view
2424         virtual
2425         override(ERC165, IERC165)
2426         returns (bool)
2427     {
2428         return
2429             interfaceId == type(IERC721).interfaceId ||
2430             interfaceId == type(IERC721Metadata).interfaceId ||
2431             super.supportsInterface(interfaceId);
2432     }
2433 
2434     /**
2435      * @dev See {IERC721-balanceOf}.
2436      */
2437     function balanceOf(address owner)
2438         public
2439         view
2440         virtual
2441         override
2442         returns (uint256)
2443     {
2444         require(
2445             owner != address(0),
2446             "ERC721: address zero is not a valid owner"
2447         );
2448         return _balances[owner];
2449     }
2450 
2451     /**
2452      * @dev See {IERC721-ownerOf}.
2453      */
2454     function ownerOf(uint256 tokenId)
2455         public
2456         view
2457         virtual
2458         override
2459         returns (address)
2460     {
2461         address owner = _owners[tokenId];
2462         require(
2463             owner != address(0),
2464             "ERC721: owner query for nonexistent token"
2465         );
2466         return owner;
2467     }
2468 
2469     /**
2470      * @dev See {IERC721Metadata-name}.
2471      */
2472     function name() public view virtual override returns (string memory) {
2473         return _name;
2474     }
2475 
2476     /**
2477      * @dev See {IERC721Metadata-symbol}.
2478      */
2479     function symbol() public view virtual override returns (string memory) {
2480         return _symbol;
2481     }
2482 
2483     /**
2484      * @dev See {IERC721Metadata-tokenURI}.
2485      */
2486     function tokenURI(uint256 tokenId)
2487         public
2488         view
2489         virtual
2490         override
2491         returns (string memory)
2492     {
2493         require(
2494             _exists(tokenId),
2495             "ERC721Metadata: URI query for nonexistent token"
2496         );
2497 
2498         string memory baseURI = _baseURI();
2499         return
2500             bytes(baseURI).length > 0
2501                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
2502                 : "";
2503     }
2504 
2505     /**
2506      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2507      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2508      * by default, can be overridden in child contracts.
2509      */
2510     function _baseURI() internal view virtual returns (string memory) {
2511         return "";
2512     }
2513 
2514     /**
2515      * @dev See {IERC721-approve}.
2516      */
2517     function approve(address to, uint256 tokenId) public virtual override {
2518         address owner = ERC721.ownerOf(tokenId);
2519         require(to != owner, "ERC721: approval to current owner");
2520 
2521         require(
2522             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2523             "ERC721: approve caller is not owner nor approved for all"
2524         );
2525 
2526         _approve(to, tokenId);
2527     }
2528 
2529     /**
2530      * @dev See {IERC721-getApproved}.
2531      */
2532     function getApproved(uint256 tokenId)
2533         public
2534         view
2535         virtual
2536         override
2537         returns (address)
2538     {
2539         require(
2540             _exists(tokenId),
2541             "ERC721: approved query for nonexistent token"
2542         );
2543 
2544         return _tokenApprovals[tokenId];
2545     }
2546 
2547     /**
2548      * @dev See {IERC721-setApprovalForAll}.
2549      */
2550     function setApprovalForAll(address operator, bool approved)
2551         public
2552         virtual
2553         override
2554     {
2555         _setApprovalForAll(_msgSender(), operator, approved);
2556     }
2557 
2558     /**
2559      * @dev See {IERC721-isApprovedForAll}.
2560      */
2561     function isApprovedForAll(address owner, address operator)
2562         public
2563         view
2564         virtual
2565         override
2566         returns (bool)
2567     {
2568         return _operatorApprovals[owner][operator];
2569     }
2570 
2571     /**
2572      * @dev See {IERC721-transferFrom}.
2573      */
2574     function transferFrom(
2575         address from,
2576         address to,
2577         uint256 tokenId
2578     ) public virtual override {
2579         //solhint-disable-next-line max-line-length
2580         require(
2581             _isApprovedOrOwner(_msgSender(), tokenId),
2582             "ERC721: transfer caller is not owner nor approved"
2583         );
2584 
2585         _transfer(from, to, tokenId);
2586     }
2587 
2588     /**
2589      * @dev See {IERC721-safeTransferFrom}.
2590      */
2591     function safeTransferFrom(
2592         address from,
2593         address to,
2594         uint256 tokenId
2595     ) public virtual override {
2596         safeTransferFrom(from, to, tokenId, "");
2597     }
2598 
2599     /**
2600      * @dev See {IERC721-safeTransferFrom}.
2601      */
2602     function safeTransferFrom(
2603         address from,
2604         address to,
2605         uint256 tokenId,
2606         bytes memory data
2607     ) public virtual override {
2608         require(
2609             _isApprovedOrOwner(_msgSender(), tokenId),
2610             "ERC721: transfer caller is not owner nor approved"
2611         );
2612         _safeTransfer(from, to, tokenId, data);
2613     }
2614 
2615     /**
2616      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2617      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2618      *
2619      * `data` is additional data, it has no specified format and it is sent in call to `to`.
2620      *
2621      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2622      * implement alternative mechanisms to perform token transfer, such as signature-based.
2623      *
2624      * Requirements:
2625      *
2626      * - `from` cannot be the zero address.
2627      * - `to` cannot be the zero address.
2628      * - `tokenId` token must exist and be owned by `from`.
2629      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2630      *
2631      * Emits a {Transfer} event.
2632      */
2633     function _safeTransfer(
2634         address from,
2635         address to,
2636         uint256 tokenId,
2637         bytes memory data
2638     ) internal virtual {
2639         _transfer(from, to, tokenId);
2640         require(
2641             _checkOnERC721Received(from, to, tokenId, data),
2642             "ERC721: transfer to non ERC721Receiver implementer"
2643         );
2644     }
2645 
2646     /**
2647      * @dev Returns whether `tokenId` exists.
2648      *
2649      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2650      *
2651      * Tokens start existing when they are minted (`_mint`),
2652      * and stop existing when they are burned (`_burn`).
2653      */
2654     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2655         return _owners[tokenId] != address(0);
2656     }
2657 
2658     /**
2659      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2660      *
2661      * Requirements:
2662      *
2663      * - `tokenId` must exist.
2664      */
2665     function _isApprovedOrOwner(address spender, uint256 tokenId)
2666         internal
2667         view
2668         virtual
2669         returns (bool)
2670     {
2671         require(
2672             _exists(tokenId),
2673             "ERC721: operator query for nonexistent token"
2674         );
2675         address owner = ERC721.ownerOf(tokenId);
2676         return (spender == owner ||
2677             isApprovedForAll(owner, spender) ||
2678             getApproved(tokenId) == spender);
2679     }
2680 
2681     /**
2682      * @dev Safely mints `tokenId` and transfers it to `to`.
2683      *
2684      * Requirements:
2685      *
2686      * - `tokenId` must not exist.
2687      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2688      *
2689      * Emits a {Transfer} event.
2690      */
2691     function _safeMint(address to, uint256 tokenId) internal virtual {
2692         _safeMint(to, tokenId, "");
2693     }
2694 
2695     /**
2696      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2697      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2698      */
2699     function _safeMint(
2700         address to,
2701         uint256 tokenId,
2702         bytes memory data
2703     ) internal virtual {
2704         _mint(to, tokenId);
2705         require(
2706             _checkOnERC721Received(address(0), to, tokenId, data),
2707             "ERC721: transfer to non ERC721Receiver implementer"
2708         );
2709     }
2710 
2711     /**
2712      * @dev Mints `tokenId` and transfers it to `to`.
2713      *
2714      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2715      *
2716      * Requirements:
2717      *
2718      * - `tokenId` must not exist.
2719      * - `to` cannot be the zero address.
2720      *
2721      * Emits a {Transfer} event.
2722      */
2723     function _mint(address to, uint256 tokenId) internal virtual {
2724         require(to != address(0), "ERC721: mint to the zero address");
2725         require(!_exists(tokenId), "ERC721: token already minted");
2726 
2727         _beforeTokenTransfer(address(0), to, tokenId);
2728 
2729         _balances[to] += 1;
2730         _owners[tokenId] = to;
2731 
2732         emit Transfer(address(0), to, tokenId);
2733 
2734         _afterTokenTransfer(address(0), to, tokenId);
2735     }
2736 
2737     /**
2738      * @dev Destroys `tokenId`.
2739      * The approval is cleared when the token is burned.
2740      *
2741      * Requirements:
2742      *
2743      * - `tokenId` must exist.
2744      *
2745      * Emits a {Transfer} event.
2746      */
2747     function _burn(uint256 tokenId) internal virtual {
2748         address owner = ERC721.ownerOf(tokenId);
2749 
2750         _beforeTokenTransfer(owner, address(0), tokenId);
2751 
2752         // Clear approvals
2753         _approve(address(0), tokenId);
2754 
2755         _balances[owner] -= 1;
2756         delete _owners[tokenId];
2757 
2758         emit Transfer(owner, address(0), tokenId);
2759 
2760         _afterTokenTransfer(owner, address(0), tokenId);
2761     }
2762 
2763     /**
2764      * @dev Transfers `tokenId` from `from` to `to`.
2765      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2766      *
2767      * Requirements:
2768      *
2769      * - `to` cannot be the zero address.
2770      * - `tokenId` token must be owned by `from`.
2771      *
2772      * Emits a {Transfer} event.
2773      */
2774     function _transfer(
2775         address from,
2776         address to,
2777         uint256 tokenId
2778     ) internal virtual {
2779         require(
2780             ERC721.ownerOf(tokenId) == from,
2781             "ERC721: transfer from incorrect owner"
2782         );
2783         require(to != address(0), "ERC721: transfer to the zero address");
2784 
2785         _beforeTokenTransfer(from, to, tokenId);
2786 
2787         // Clear approvals from the previous owner
2788         _approve(address(0), tokenId);
2789 
2790         _balances[from] -= 1;
2791         _balances[to] += 1;
2792         _owners[tokenId] = to;
2793 
2794         emit Transfer(from, to, tokenId);
2795 
2796         _afterTokenTransfer(from, to, tokenId);
2797     }
2798 
2799     /**
2800      * @dev Approve `to` to operate on `tokenId`
2801      *
2802      * Emits an {Approval} event.
2803      */
2804     function _approve(address to, uint256 tokenId) internal virtual {
2805         _tokenApprovals[tokenId] = to;
2806         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2807     }
2808 
2809     /**
2810      * @dev Approve `operator` to operate on all of `owner` tokens
2811      *
2812      * Emits an {ApprovalForAll} event.
2813      */
2814     function _setApprovalForAll(
2815         address owner,
2816         address operator,
2817         bool approved
2818     ) internal virtual {
2819         require(owner != operator, "ERC721: approve to caller");
2820         _operatorApprovals[owner][operator] = approved;
2821         emit ApprovalForAll(owner, operator, approved);
2822     }
2823 
2824     /**
2825      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2826      * The call is not executed if the target address is not a contract.
2827      *
2828      * @param from address representing the previous owner of the given token ID
2829      * @param to target address that will receive the tokens
2830      * @param tokenId uint256 ID of the token to be transferred
2831      * @param data bytes optional data to send along with the call
2832      * @return bool whether the call correctly returned the expected magic value
2833      */
2834     function _checkOnERC721Received(
2835         address from,
2836         address to,
2837         uint256 tokenId,
2838         bytes memory data
2839     ) private returns (bool) {
2840         if (to.isContract()) {
2841             try
2842                 IERC721Receiver(to).onERC721Received(
2843                     _msgSender(),
2844                     from,
2845                     tokenId,
2846                     data
2847                 )
2848             returns (bytes4 retval) {
2849                 return retval == IERC721Receiver.onERC721Received.selector;
2850             } catch (bytes memory reason) {
2851                 if (reason.length == 0) {
2852                     revert(
2853                         "ERC721: transfer to non ERC721Receiver implementer"
2854                     );
2855                 } else {
2856                     assembly {
2857                         revert(add(32, reason), mload(reason))
2858                     }
2859                 }
2860             }
2861         } else {
2862             return true;
2863         }
2864     }
2865 
2866     /**
2867      * @dev Hook that is called before any token transfer. This includes minting
2868      * and burning.
2869      *
2870      * Calling conditions:
2871      *
2872      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2873      * transferred to `to`.
2874      * - When `from` is zero, `tokenId` will be minted for `to`.
2875      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2876      * - `from` and `to` are never both zero.
2877      *
2878      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2879      */
2880     function _beforeTokenTransfer(
2881         address from,
2882         address to,
2883         uint256 tokenId
2884     ) internal virtual {}
2885 
2886     /**
2887      * @dev Hook that is called after any transfer of tokens. This includes
2888      * minting and burning.
2889      *
2890      * Calling conditions:
2891      *
2892      * - when `from` and `to` are both non-zero.
2893      * - `from` and `to` are never both zero.
2894      *
2895      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2896      */
2897     function _afterTokenTransfer(
2898         address from,
2899         address to,
2900         uint256 tokenId
2901     ) internal virtual {}
2902 }
2903 
2904 //7599910339349013
2905 
2906 pragma solidity ^0.8.0;
2907 
2908 contract Hoshiko is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
2909     using Strings for uint256;
2910 
2911     string private baseURI;
2912 
2913     uint256 public price = 0.0099 ether;
2914 
2915     uint256 public maxPerWallet = 3;
2916 
2917     uint256 public maxFreePerWallet = 1;
2918 
2919     uint256 public totalFree = 333;
2920 
2921     uint256 public maxSupply = 3333;
2922 
2923     uint256 public freeMinted = 0;
2924 
2925     address private founderWallet = 0x1677ab822C003f8Af715Ca16E84eA672C98Ca227;
2926     address private wallet2 = 0x3BdC8d36c45b2eD12B6038fDFEd63cA9F8D5C70e; //Dev Wallet
2927 
2928     bool public mintEnabled = true;
2929     bool public publicEnabled = false;
2930 
2931     bytes32 whitelistRoot;
2932 
2933     string public hiddenURI ="ipfs://bafybeibmzveqnja5kyppe42gqdlz2f23lc6f2kkzm4whz2uxzvn3fgiqvq/hidden.json";
2934 
2935     bool public revealed = false;
2936 
2937     mapping(address => bool) private _mintedFree;
2938 
2939     constructor() ERC721A("Hoshiko", "HC") {}
2940 
2941     modifier callerIsUser() {
2942         require(tx.origin == msg.sender, "The caller is another contract");
2943         _;
2944     }
2945 
2946     function whitelistMint(bytes32[] calldata _merkleProof, uint256 count)
2947         external
2948         payable
2949         callerIsUser
2950         nonReentrant
2951     {
2952         bool isFreeLeft = !(_mintedFree[msg.sender]) &&
2953             (freeMinted < totalFree);
2954         bool isEqual = count == maxFreePerWallet;
2955 
2956         uint256 cost = price;
2957 
2958         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2959 
2960         if (isFreeLeft && isEqual) {
2961             cost = 0;
2962         }
2963 
2964         if (isFreeLeft && !isEqual) {
2965             require(
2966                 msg.value >= (count - maxFreePerWallet) * cost,
2967                 "Please send the exact amount."
2968             );
2969         } else {
2970             require(msg.value >= count * cost, "Please send the exact amount.");
2971         }
2972         require(
2973             MerkleProof.verify(_merkleProof, whitelistRoot, leaf),
2974             "Incorrect Whitelist Proof"
2975         );
2976         require(totalSupply() + count <= maxSupply, "No more");
2977         require(count > 0, "Please enter a number");
2978         require(mintEnabled, "Minting is not live yet");
2979         require(
2980             _numberMinted(msg.sender) + count <= maxPerWallet,
2981             "Can not mint more than 3"
2982         );
2983 
2984         _mintedFree[msg.sender] = true;
2985 
2986         if (isFreeLeft) {
2987             freeMinted++;
2988         }
2989 
2990         _safeMint(msg.sender, count);
2991     }
2992 
2993     function publicMint(uint256 count) external payable nonReentrant {
2994         require(msg.value >= count * price, "Please send the exact amount.");
2995         require(totalSupply() + count <= maxSupply, "No more NFT left");
2996         require(
2997             _numberMinted(msg.sender) + count <= maxPerWallet,
2998             "Can not mint more than 3"
2999         );
3000         require(count > 0, "Please enter a number");
3001         require(publicEnabled, "Minting is not live yet");
3002 
3003         _safeMint(msg.sender, count);
3004     }
3005 
3006     function _baseURI() internal view virtual override returns (string memory) {
3007         return baseURI;
3008     }
3009 
3010     function _isMintedFree(address minter) external view returns (bool) {
3011         return _mintedFree[minter];
3012     }
3013 
3014     function _mintedAmount(address minter) external view returns (uint256) {
3015         return _numberMinted(minter);
3016     }
3017 
3018     function tokenURI(uint256 tokenId)
3019         public
3020         view
3021         virtual
3022         override
3023         returns (string memory)
3024     {
3025         require(
3026             _exists(tokenId),
3027             "ERC721AMetadata: URI query for nonexistent token"
3028         );
3029         if (revealed == false) {
3030             return hiddenURI;
3031         }
3032 
3033         string memory currentBaseURI = _baseURI();
3034         return
3035             bytes(currentBaseURI).length > 0
3036                 ? string(
3037                     abi.encodePacked(
3038                         currentBaseURI,
3039                         tokenId.toString(),
3040                         ".json"
3041                     )
3042                 )
3043                 : "";
3044     }
3045 
3046     function setBaseURI(string memory uri) public onlyOwner {
3047         baseURI = uri;
3048     }
3049 
3050     function setPreSaleRoot(bytes32 _presaleRoot) external onlyOwner {
3051         whitelistRoot = _presaleRoot;
3052     }
3053 
3054     function setFreeAmount(uint256 amount) external onlyOwner {
3055         totalFree = amount;
3056     }
3057 
3058     function setMaxPerWallet(uint256 amount) external onlyOwner {
3059         maxPerWallet = amount;
3060     }
3061 
3062     function setPrice(uint256 _newPrice) external onlyOwner {
3063         price = _newPrice;
3064     }
3065 
3066     function setMaxSupply(uint256 _newSupply) external onlyOwner {
3067         maxSupply = _newSupply;
3068     }
3069 
3070     function flipSale(bool status) external onlyOwner {
3071         mintEnabled = status;
3072     }
3073 
3074     function flipPublic(bool status) external onlyOwner {
3075         publicEnabled = status;
3076     }
3077 
3078     function reveal() external onlyOwner {
3079         revealed = !revealed;
3080     }
3081 
3082     function batchmint(uint256 _mintAmount, address destination)
3083         public
3084         onlyOwner
3085     {
3086         require(_mintAmount > 0, "need to mint at least 1 NFT");
3087         uint256 supply = totalSupply();
3088         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
3089 
3090         _safeMint(destination, _mintAmount);
3091     }
3092 
3093     function withdraw() external onlyOwner {
3094         uint256 balance = address(this).balance;
3095         uint256 balance2 = (balance * 80) / 100;
3096         uint256 balance3 = (balance * 20) / 100;
3097 
3098         payable(founderWallet).transfer(balance2);
3099         payable(wallet2).transfer(balance3);
3100     }
3101 
3102     // Opensea filtering things
3103     function transferFrom(
3104         address from,
3105         address to,
3106         uint256 tokenId
3107     ) public override onlyAllowedOperator(from) {
3108         super.transferFrom(from, to, tokenId);
3109     }
3110 
3111     function safeTransferFrom(
3112         address from,
3113         address to,
3114         uint256 tokenId
3115     ) public override onlyAllowedOperator(from) {
3116         super.safeTransferFrom(from, to, tokenId);
3117     }
3118 
3119     function safeTransferFrom(
3120         address from,
3121         address to,
3122         uint256 tokenId,
3123         bytes memory data
3124     ) public override onlyAllowedOperator(from) {
3125         super.safeTransferFrom(from, to, tokenId, data);
3126     }
3127 }