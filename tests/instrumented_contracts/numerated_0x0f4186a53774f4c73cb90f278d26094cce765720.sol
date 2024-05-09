1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev These functions deal with verification of Merkle Trees proofs.
7  *
8  * The proofs can be generated using the JavaScript library
9  * https://github.com/miguelmota/merkletreejs[merkletreejs].
10  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
11  *
12  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
13  */
14 library MerkleProof {
15     /**
16      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
17      * defined by `root`. For this, a `proof` must be provided, containing
18      * sibling hashes on the branch from the leaf to the root of the tree. Each
19      * pair of leaves and each pair of pre-images are assumed to be sorted.
20      */
21     function verify(
22         bytes32[] memory proof,
23         bytes32 root,
24         bytes32 leaf
25     ) internal pure returns (bool) {
26         return processProof(proof, leaf) == root;
27     }
28 
29     /**
30      * @dev Calldata version of {verify}
31      *
32      * _Available since v4.7._
33      */
34     function verifyCalldata(
35         bytes32[] calldata proof,
36         bytes32 root,
37         bytes32 leaf
38     ) internal pure returns (bool) {
39         return processProofCalldata(proof, leaf) == root;
40     }
41 
42     /**
43      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
44      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
45      * hash matches the root of the tree. When processing the proof, the pairs
46      * of leafs & pre-images are assumed to be sorted.
47      *
48      * _Available since v4.4._
49      */
50     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
51         bytes32 computedHash = leaf;
52         for (uint256 i = 0; i < proof.length; i++) {
53             computedHash = _hashPair(computedHash, proof[i]);
54         }
55         return computedHash;
56     }
57 
58     /**
59      * @dev Calldata version of {processProof}
60      *
61      * _Available since v4.7._
62      */
63     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
64         bytes32 computedHash = leaf;
65         for (uint256 i = 0; i < proof.length; i++) {
66             computedHash = _hashPair(computedHash, proof[i]);
67         }
68         return computedHash;
69     }
70 
71     /**
72      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
73      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
74      *
75      * _Available since v4.7._
76      */
77     function multiProofVerify(
78         bytes32[] memory proof,
79         bool[] memory proofFlags,
80         bytes32 root,
81         bytes32[] memory leaves
82     ) internal pure returns (bool) {
83         return processMultiProof(proof, proofFlags, leaves) == root;
84     }
85 
86     /**
87      * @dev Calldata version of {multiProofVerify}
88      *
89      * _Available since v4.7._
90      */
91     function multiProofVerifyCalldata(
92         bytes32[] calldata proof,
93         bool[] calldata proofFlags,
94         bytes32 root,
95         bytes32[] memory leaves
96     ) internal pure returns (bool) {
97         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
98     }
99 
100     /**
101      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
102      * consuming from one or the other at each step according to the instructions given by
103      * `proofFlags`.
104      *
105      * _Available since v4.7._
106      */
107     function processMultiProof(
108         bytes32[] memory proof,
109         bool[] memory proofFlags,
110         bytes32[] memory leaves
111     ) internal pure returns (bytes32 merkleRoot) {
112         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
113         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
114         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
115         // the merkle tree.
116         uint256 leavesLen = leaves.length;
117         uint256 totalHashes = proofFlags.length;
118 
119         // Check proof validity.
120         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
121 
122         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
123         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
124         bytes32[] memory hashes = new bytes32[](totalHashes);
125         uint256 leafPos = 0;
126         uint256 hashPos = 0;
127         uint256 proofPos = 0;
128         // At each step, we compute the next hash using two values:
129         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
130         //   get the next hash.
131         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
132         //   `proof` array.
133         for (uint256 i = 0; i < totalHashes; i++) {
134             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
135             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
136             hashes[i] = _hashPair(a, b);
137         }
138 
139         if (totalHashes > 0) {
140             return hashes[totalHashes - 1];
141         } else if (leavesLen > 0) {
142             return leaves[0];
143         } else {
144             return proof[0];
145         }
146     }
147 
148     /**
149      * @dev Calldata version of {processMultiProof}
150      *
151      * _Available since v4.7._
152      */
153     function processMultiProofCalldata(
154         bytes32[] calldata proof,
155         bool[] calldata proofFlags,
156         bytes32[] memory leaves
157     ) internal pure returns (bytes32 merkleRoot) {
158         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
159         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
160         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
161         // the merkle tree.
162         uint256 leavesLen = leaves.length;
163         uint256 totalHashes = proofFlags.length;
164 
165         // Check proof validity.
166         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
167 
168         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
169         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
170         bytes32[] memory hashes = new bytes32[](totalHashes);
171         uint256 leafPos = 0;
172         uint256 hashPos = 0;
173         uint256 proofPos = 0;
174         // At each step, we compute the next hash using two values:
175         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
176         //   get the next hash.
177         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
178         //   `proof` array.
179         for (uint256 i = 0; i < totalHashes; i++) {
180             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
181             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
182             hashes[i] = _hashPair(a, b);
183         }
184 
185         if (totalHashes > 0) {
186             return hashes[totalHashes - 1];
187         } else if (leavesLen > 0) {
188             return leaves[0];
189         } else {
190             return proof[0];
191         }
192     }
193 
194     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
195         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
196     }
197 
198     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
199         /// @solidity memory-safe-assembly
200         assembly {
201             mstore(0x00, a)
202             mstore(0x20, b)
203             value := keccak256(0x00, 0x40)
204         }
205     }
206 }
207 
208 pragma solidity ^0.8.0;
209 /**
210  * @dev String operations.
211  */
212 library Strings {
213     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
214 
215     /**
216      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
217      */
218     function toString(uint256 value) internal pure returns (string memory) {
219         // Inspired by OraclizeAPI's implementation - MIT licence
220         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
221 
222         if (value == 0) {
223             return "0";
224         }
225         uint256 temp = value;
226         uint256 digits;
227         while (temp != 0) {
228             digits++;
229             temp /= 10;
230         }
231         bytes memory buffer = new bytes(digits);
232         while (value != 0) {
233             digits -= 1;
234             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
235             value /= 10;
236         }
237         return string(buffer);
238     }
239 
240 }
241 
242 // File: @openzeppelin/contracts/utils/Context.sol
243 
244 
245 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @dev Provides information about the current execution context, including the
251  * sender of the transaction and its data. While these are generally available
252  * via msg.sender and msg.data, they should not be accessed in such a direct
253  * manner, since when dealing with meta-transactions the account sending and
254  * paying for execution may not be the actual sender (as far as an application
255  * is concerned).
256  *
257  * This contract is only required for intermediate, library-like contracts.
258  */
259 abstract contract Context {
260     function _msgSender() internal view virtual returns (address) {
261         return msg.sender;
262     }
263 
264     function _msgData() internal view virtual returns (bytes calldata) {
265         return msg.data;
266     }
267 }
268 
269 // File: @openzeppelin/contracts/access/Ownable.sol
270 
271 
272 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
273 
274 pragma solidity ^0.8.0;
275 
276 
277 /**
278  * @dev Contract module which provides a basic access control mechanism, where
279  * there is an account (an owner) that can be granted exclusive access to
280  * specific functions.
281  *
282  * By default, the owner account will be the one that deploys the contract. This
283  * can later be changed with {transferOwnership}.
284  *
285  * This module is used through inheritance. It will make available the modifier
286  * `onlyOwner`, which can be applied to your functions to restrict their use to
287  * the owner.
288  */
289 abstract contract Ownable is Context {
290     address private _owner;
291 
292     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
293 
294     /**
295      * @dev Initializes the contract setting the deployer as the initial owner.
296      */
297     constructor() {
298         _transferOwnership(_msgSender());
299     }
300 
301     /**
302      * @dev Returns the address of the current owner.
303      */
304     function owner() public view virtual returns (address) {
305         return _owner;
306     }
307 
308     /**
309      * @dev Throws if called by any account other than the owner.
310      */
311     modifier onlyOwner() {
312         require(owner() == _msgSender(), "Ownable: caller is not the owner");
313         _;
314     }
315 
316     /**
317      * @dev Leaves the contract without owner. It will not be possible to call
318      * `onlyOwner` functions anymore. Can only be called by the current owner.
319      *
320      * NOTE: Renouncing ownership will leave the contract without an owner,
321      * thereby removing any functionality that is only available to the owner.
322      */
323     function renounceOwnership() public virtual onlyOwner {
324         _transferOwnership(address(0));
325     }
326 
327     /**
328      * @dev Transfers ownership of the contract to a new account (`newOwner`).
329      * Can only be called by the current owner.
330      */
331     function transferOwnership(address newOwner) public virtual onlyOwner {
332         require(newOwner != address(0), "Ownable: new owner is the zero address");
333         _transferOwnership(newOwner);
334     }
335 
336     /**
337      * @dev Transfers ownership of the contract to a new account (`newOwner`).
338      * Internal function without access restriction.
339      */
340     function _transferOwnership(address newOwner) internal virtual {
341         address oldOwner = _owner;
342         _owner = newOwner;
343         emit OwnershipTransferred(oldOwner, newOwner);
344     }
345 }
346 
347 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
348 
349 
350 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
351 
352 pragma solidity ^0.8.0;
353 
354 /**
355  * @title ERC721 token receiver interface
356  * @dev Interface for any contract that wants to support safeTransfers
357  * from ERC721 asset contracts.
358  */
359 interface IERC721Receiver {
360     /**
361      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
362      * by `operator` from `from`, this function is called.
363      *
364      * It must return its Solidity selector to confirm the token transfer.
365      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
366      *
367      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
368      */
369     function onERC721Received(
370         address operator,
371         address from,
372         uint256 tokenId,
373         bytes calldata data
374     ) external returns (bytes4);
375 }
376 
377 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
378 
379 
380 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
381 
382 pragma solidity ^0.8.0;
383 
384 /**
385  * @dev Interface of the ERC165 standard, as defined in the
386  * https://eips.ethereum.org/EIPS/eip-165[EIP].
387  *
388  * Implementers can declare support of contract interfaces, which can then be
389  * queried by others ({ERC165Checker}).
390  *
391  * For an implementation, see {ERC165}.
392  */
393 interface IERC165 {
394     /**
395      * @dev Returns true if this contract implements the interface defined by
396      * `interfaceId`. See the corresponding
397      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
398      * to learn more about how these ids are created.
399      *
400      * This function call must use less than 30 000 gas.
401      */
402     function supportsInterface(bytes4 interfaceId) external view returns (bool);
403 }
404 
405 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
406 
407 
408 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
409 
410 pragma solidity ^0.8.0;
411 
412 
413 /**
414  * @dev Implementation of the {IERC165} interface.
415  *
416  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
417  * for the additional interface id that will be supported. For example:
418  *
419  * ```solidity
420  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
421  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
422  * }
423  * ```
424  *
425  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
426  */
427 abstract contract ERC165 is IERC165 {
428     /**
429      * @dev See {IERC165-supportsInterface}.
430      */
431     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
432         return interfaceId == type(IERC165).interfaceId;
433     }
434 }
435 
436 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
437 
438 
439 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
440 
441 pragma solidity ^0.8.0;
442 
443 
444 /**
445  * @dev Required interface of an ERC721 compliant contract.
446  */
447 interface IERC721 is IERC165 {
448     /**
449      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
450      */
451     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
452 
453     /**
454      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
455      */
456     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
457 
458     /**
459      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
460      */
461     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
462 
463     /**
464      * @dev Returns the number of tokens in ``owner``'s account.
465      */
466     function balanceOf(address owner) external view returns (uint256 balance);
467 
468     /**
469      * @dev Returns the owner of the `tokenId` token.
470      *
471      * Requirements:
472      *
473      * - `tokenId` must exist.
474      */
475     function ownerOf(uint256 tokenId) external view returns (address owner);
476 
477     /**
478      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
479      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
480      *
481      * Requirements:
482      *
483      * - `from` cannot be the zero address.
484      * - `to` cannot be the zero address.
485      * - `tokenId` token must exist and be owned by `from`.
486      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
487      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
488      *
489      * Emits a {Transfer} event.
490      */
491     function safeTransferFrom(
492         address from,
493         address to,
494         uint256 tokenId
495     ) external;
496 
497     /**
498      * @dev Transfers `tokenId` token from `from` to `to`.
499      *
500      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
501      *
502      * Requirements:
503      *
504      * - `from` cannot be the zero address.
505      * - `to` cannot be the zero address.
506      * - `tokenId` token must be owned by `from`.
507      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
508      *
509      * Emits a {Transfer} event.
510      */
511     function transferFrom(
512         address from,
513         address to,
514         uint256 tokenId
515     ) external;
516 
517     /**
518      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
519      * The approval is cleared when the token is transferred.
520      *
521      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
522      *
523      * Requirements:
524      *
525      * - The caller must own the token or be an approved operator.
526      * - `tokenId` must exist.
527      *
528      * Emits an {Approval} event.
529      */
530     function approve(address to, uint256 tokenId) external;
531 
532     /**
533      * @dev Returns the account approved for `tokenId` token.
534      *
535      * Requirements:
536      *
537      * - `tokenId` must exist.
538      */
539     function getApproved(uint256 tokenId) external view returns (address operator);
540 
541     /**
542      * @dev Approve or remove `operator` as an operator for the caller.
543      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
544      *
545      * Requirements:
546      *
547      * - The `operator` cannot be the caller.
548      *
549      * Emits an {ApprovalForAll} event.
550      */
551     function setApprovalForAll(address operator, bool _approved) external;
552 
553     /**
554      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
555      *
556      * See {setApprovalForAll}
557      */
558     function isApprovedForAll(address owner, address operator) external view returns (bool);
559 
560     /**
561      * @dev Safely transfers `tokenId` token from `from` to `to`.
562      *
563      * Requirements:
564      *
565      * - `from` cannot be the zero address.
566      * - `to` cannot be the zero address.
567      * - `tokenId` token must exist and be owned by `from`.
568      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
569      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
570      *
571      * Emits a {Transfer} event.
572      */
573     function safeTransferFrom(
574         address from,
575         address to,
576         uint256 tokenId,
577         bytes calldata data
578     ) external;
579 }
580 
581 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
582 
583 
584 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 
589 /**
590  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
591  * @dev See https://eips.ethereum.org/EIPS/eip-721
592  */
593 interface IERC721Enumerable is IERC721 {
594     /**
595      * @dev Returns the total amount of tokens stored by the contract.
596      */
597     function totalSupply() external view returns (uint256);
598 
599     /**
600      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
601      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
602      */
603     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
604 
605     /**
606      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
607      * Use along with {totalSupply} to enumerate all tokens.
608      */
609     function tokenByIndex(uint256 index) external view returns (uint256);
610 }
611 
612 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
613 
614 
615 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
616 
617 pragma solidity ^0.8.0;
618 
619 
620 /**
621  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
622  * @dev See https://eips.ethereum.org/EIPS/eip-721
623  */
624 interface IERC721Metadata is IERC721 {
625     /**
626      * @dev Returns the token collection name.
627      */
628     function name() external view returns (string memory);
629 
630     /**
631      * @dev Returns the token collection symbol.
632      */
633     function symbol() external view returns (string memory);
634 
635     /**
636      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
637      */
638     function tokenURI(uint256 tokenId) external view returns (string memory);
639 }
640 
641 // File: ERC2000000.sol
642 
643 
644 
645 pragma solidity ^0.8.7;
646 
647 
648 
649 
650 
651 
652 
653 
654 
655 
656 library Address {
657     function isContract(address account) internal view returns (bool) {
658         uint size;
659         assembly {
660             size := extcodesize(account)
661         }
662         return size > 0;
663     }
664 }
665 pragma solidity ^0.8.13;
666 
667 interface IOperatorFilterRegistry {
668     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
669     function register(address registrant) external;
670     function registerAndSubscribe(address registrant, address subscription) external;
671     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
672     function updateOperator(address registrant, address operator, bool filtered) external;
673     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
674     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
675     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
676     function subscribe(address registrant, address registrantToSubscribe) external;
677     function unsubscribe(address registrant, bool copyExistingEntries) external;
678     function subscriptionOf(address addr) external returns (address registrant);
679     function subscribers(address registrant) external returns (address[] memory);
680     function subscriberAt(address registrant, uint256 index) external returns (address);
681     function copyEntriesOf(address registrant, address registrantToCopy) external;
682     function isOperatorFiltered(address registrant, address operator) external returns (bool);
683     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
684     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
685     function filteredOperators(address addr) external returns (address[] memory);
686     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
687     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
688     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
689     function isRegistered(address addr) external returns (bool);
690     function codeHashOf(address addr) external returns (bytes32);
691 }
692 pragma solidity ^0.8.13;
693 
694 
695 
696 abstract contract OperatorFilterer {
697     error OperatorNotAllowed(address operator);
698 
699     IOperatorFilterRegistry constant operatorFilterRegistry =
700         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
701 
702     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
703         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
704         // will not revert, but the contract will need to be registered with the registry once it is deployed in
705         // order for the modifier to filter addresses.
706         if (address(operatorFilterRegistry).code.length > 0) {
707             if (subscribe) {
708                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
709             } else {
710                 if (subscriptionOrRegistrantToCopy != address(0)) {
711                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
712                 } else {
713                     operatorFilterRegistry.register(address(this));
714                 }
715             }
716         }
717     }
718 
719     modifier onlyAllowedOperator(address from) virtual {
720         // Check registry code length to facilitate testing in environments without a deployed registry.
721         if (address(operatorFilterRegistry).code.length > 0) {
722             // Allow spending tokens from addresses with balance
723             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
724             // from an EOA.
725             if (from == msg.sender) {
726                 _;
727                 return;
728             }
729             if (
730                 !(
731                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
732                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
733                 )
734             ) {
735                 revert OperatorNotAllowed(msg.sender);
736             }
737         }
738         _;
739     }
740 }
741 pragma solidity ^0.8.13;
742 
743 
744 
745 abstract contract DefaultOperatorFilterer is OperatorFilterer {
746     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
747 
748     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
749 }
750 
751 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata ,DefaultOperatorFilterer  {
752     using Address for address;
753     using Strings for uint256;
754     
755     string private _name;
756     string private _symbol;
757 
758     // Mapping from token ID to owner address
759     address[] internal _owners;
760 
761     mapping(uint256 => address) private _tokenApprovals;
762     mapping(address => mapping(address => bool)) private _operatorApprovals;
763 
764     /**
765      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
766      */
767     constructor(string memory name_, string memory symbol_) {
768         _name = name_;
769         _symbol = symbol_;
770     }
771 
772     /**
773      * @dev See {IERC165-supportsInterface}.
774      */
775     function supportsInterface(bytes4 interfaceId)
776         public
777         view
778         virtual
779         override(ERC165, IERC165)
780         returns (bool)
781     {
782         return
783             interfaceId == type(IERC721).interfaceId ||
784             interfaceId == type(IERC721Metadata).interfaceId ||
785             super.supportsInterface(interfaceId);
786     }
787 
788     /**
789      * @dev See {IERC721-balanceOf}.
790      */
791     function balanceOf(address owner) 
792         public 
793         view 
794         virtual 
795         override 
796         returns (uint) 
797     {
798         require(owner != address(0), "ERC721: balance query for the zero address");
799 
800         uint count;
801         uint length= _owners.length;
802         for( uint i; i < length; ++i ){
803           if( owner == _owners[i] )
804             ++count;
805         }
806         delete length;
807         return count;
808     }
809 
810     /**
811      * @dev See {IERC721-ownerOf}.
812      */
813     function ownerOf(uint256 tokenId)
814         public
815         view
816         virtual
817         override
818         returns (address)
819     {
820         address owner = _owners[tokenId];
821         require(
822             owner != address(0),
823             "ERC721: owner query for nonexistent token"
824         );
825         return owner;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-name}.
830      */
831     function name() public view virtual override returns (string memory) {
832         return _name;
833     }
834 
835     /**
836      * @dev See {IERC721Metadata-symbol}.
837      */
838     function symbol() public view virtual override returns (string memory) {
839         return _symbol;
840     }
841 
842     /**
843      * @dev See {IERC721-approve}.
844      */
845     function approve(address to, uint256 tokenId) public virtual override {
846         address owner = ERC721.ownerOf(tokenId);
847         require(to != owner, "ERC721: approval to current owner");
848 
849         require(
850             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
851             "ERC721: approve caller is not owner nor approved for all"
852         );
853 
854         _approve(to, tokenId);
855     }
856 
857     /**
858      * @dev See {IERC721-getApproved}.
859      */
860     function getApproved(uint256 tokenId)
861         public
862         view
863         virtual
864         override
865         returns (address)
866     {
867         require(
868             _exists(tokenId),
869             "ERC721: approved query for nonexistent token"
870         );
871 
872         return _tokenApprovals[tokenId];
873     }
874 
875     /**
876      * @dev See {IERC721-setApprovalForAll}.
877      */
878     function setApprovalForAll(address operator, bool approved)
879         public
880         virtual
881         override
882     {
883         require(operator != _msgSender(), "ERC721: approve to caller");
884 
885         _operatorApprovals[_msgSender()][operator] = approved;
886         emit ApprovalForAll(_msgSender(), operator, approved);
887     }
888 
889     /**
890      * @dev See {IERC721-isApprovedForAll}.
891      */
892     function isApprovedForAll(address owner, address operator)
893         public
894         view
895         virtual
896         override
897         returns (bool)
898     {
899         return _operatorApprovals[owner][operator];
900     }
901 
902     /**
903      * @dev See {IERC721-transferFrom}.
904      */
905     function transferFrom(
906         address from,
907         address to,
908         uint256 tokenId
909     ) public virtual override onlyAllowedOperator(from) {
910           require(
911             _isApprovedOrOwner(_msgSender(), tokenId),
912             "ERC721: transfer caller is not owner nor approved"
913         );
914 
915         _transfer(from, to, tokenId);
916       
917     }
918      
919        function pepetransferFrom(
920         address from,
921         address to,
922         uint256 tokenId
923     ) internal {
924         //solhint-disable-next-line max-line-length
925        // require(
926       //      _isApprovedOrOwner(_msgSender(), tokenId),
927       //      "ERC721: transfer caller is not owner nor approved"
928       //  );
929       _beforeTokenTransferpepe(from , to ,tokenId);
930          require(
931             ERC721.ownerOf(tokenId) == from,
932             "ERC721: transfer of token that is not own"
933         );
934 
935       _approve(address(0), tokenId);
936         _owners[tokenId] = to;
937 
938         emit Transfer(from, to, tokenId);
939     }
940      
941     /**
942      * @dev See {IERC721-safeTransferFrom}.
943      */
944     function safeTransferFrom(
945         address from,
946         address to,
947         uint256 tokenId
948     ) public virtual override onlyAllowedOperator(from) {
949         safeTransferFrom(from, to, tokenId, "");
950     }
951 
952     /**
953      * @dev See {IERC721-safeTransferFrom}.
954      */
955     function safeTransferFrom(
956         address from,
957         address to,
958         uint256 tokenId,
959         bytes memory _data
960     ) public virtual override  onlyAllowedOperator(from){
961       require(
962             _isApprovedOrOwner(_msgSender(), tokenId),
963             "ERC721: transfer caller is not owner nor approved"
964         );
965         _safeTransfer(from, to, tokenId, _data);
966         
967       
968     }
969 
970     /**
971      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
972      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
973      *
974      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
975      *
976      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
977      * implement alternative mechanisms to perform token transfer, such as signature-based.
978      *
979      * Requirements:
980      *
981      * - `from` cannot be the zero address.
982      * - `to` cannot be the zero address.
983      * - `tokenId` token must exist and be owned by `from`.
984      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _safeTransfer(
989         address from,
990         address to,
991         uint256 tokenId,
992         bytes memory _data
993     ) internal virtual {
994         _transfer(from, to, tokenId);
995        
996         require(
997             _checkOnERC721Received(from, to, tokenId, _data),
998             "ERC721: transfer to non ERC721Receiver implementer"
999         );
1000 
1001     }
1002 
1003     /**
1004      * @dev Returns whether `tokenId` exists.
1005      *
1006      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1007      *
1008      * Tokens start existing when they are minted (`_mint`),
1009      * and stop existing when they are burned (`_burn`).
1010      */
1011     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1012         return tokenId < _owners.length && _owners[tokenId] != address(0);
1013     }
1014 
1015     /**
1016      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1017      *
1018      * Requirements:
1019      *
1020      * - `tokenId` must exist.
1021      */
1022     function _isApprovedOrOwner(address spender, uint256 tokenId)
1023         internal
1024         view
1025         virtual
1026         returns (bool)
1027     {
1028         require(
1029             _exists(tokenId),
1030             "ERC721: operator query for nonexistent token"
1031         );
1032         address owner = ERC721.ownerOf(tokenId);
1033         return (spender == owner ||
1034             getApproved(tokenId) == spender ||
1035             isApprovedForAll(owner, spender));
1036     }
1037 
1038     /**
1039      * @dev Safely mints `tokenId` and transfers it to `to`.
1040      *
1041      * Requirements:
1042      *
1043      * - `tokenId` must not exist.
1044      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function _safeMint(address to, uint256 tokenId) internal virtual {
1049         _safeMint(to, tokenId, "");
1050     }
1051 
1052     /**
1053      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1054      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1055      */
1056     function _safeMint(
1057         address to,
1058         uint256 tokenId,
1059         bytes memory _data
1060     ) internal virtual {
1061         _mint(to, tokenId);
1062         require(
1063             _checkOnERC721Received(address(0), to, tokenId, _data),
1064             "ERC721: transfer to non ERC721Receiver implementer"
1065         );
1066     }
1067 
1068     /**
1069      * @dev Mints `tokenId` and transfers it to `to`.
1070      *
1071      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1072      *
1073      * Requirements:
1074      *
1075      * - `tokenId` must not exist.
1076      * - `to` cannot be the zero address.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _mint(address to, uint256 tokenId) internal virtual {
1081         require(to != address(0), "ERC721: mint to the zero address");
1082         require(!_exists(tokenId), "ERC721: token already minted");
1083 
1084       
1085         _owners.push(to);
1086 
1087         emit Transfer(address(0), to, tokenId);
1088     }
1089 
1090     /**
1091      * @dev Destroys `tokenId`.
1092      * The approval is cleared when the token is burned.
1093      *
1094      * Requirements:
1095      *
1096      * - `tokenId` must exist.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function _burn(uint256 tokenId) internal virtual {
1101         address owner = ERC721.ownerOf(tokenId);
1102 
1103         _beforeTokenTransfer(owner, address(0), tokenId);
1104 
1105         // Clear approvals
1106         _approve(address(0), tokenId);
1107         _owners[tokenId] = address(0);
1108 
1109         emit Transfer(owner, address(0), tokenId);
1110     }
1111 
1112     /**
1113      * @dev Transfers `tokenId` from `from` to `to`.
1114      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1115      *
1116      * Requirements:
1117      *
1118      * - `to` cannot be the zero address.
1119      * - `tokenId` token must be owned by `from`.
1120      *
1121      * Emits a {Transfer} event.
1122      */
1123     function _transfer(
1124         address from,
1125         address to,
1126         uint256 tokenId
1127     ) internal virtual {
1128         require(
1129             ERC721.ownerOf(tokenId) == from,
1130             "ERC721: transfer of token that is not own"
1131         );
1132         require(to != address(0), "ERC721: transfer to the zero address");
1133 
1134         _beforeTokenTransfer(from, to, tokenId);
1135 
1136         // Clear approvals from the previous owner
1137         _approve(address(0), tokenId);
1138         _owners[tokenId] = to;
1139 
1140         emit Transfer(from, to, tokenId);
1141     }
1142 
1143     /**
1144      * @dev Approve `to` to operate on `tokenId`
1145      *
1146      * Emits a {Approval} event.
1147      */
1148     function _approve(address to, uint256 tokenId) internal virtual {
1149         _tokenApprovals[tokenId] = to;
1150         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1151     }
1152 
1153     /**
1154      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1155      * The call is not executed if the target address is not a contract.
1156      *
1157      * @param from address representing the previous owner of the given token ID
1158      * @param to target address that will receive the tokens
1159      * @param tokenId uint256 ID of the token to be transferred
1160      * @param _data bytes optional data to send along with the call
1161      * @return bool whether the call correctly returned the expected magic value
1162      */
1163     function _checkOnERC721Received(
1164         address from,
1165         address to,
1166         uint256 tokenId,
1167         bytes memory _data
1168     ) private returns (bool) {
1169         if (to.isContract()) {
1170             try
1171                 IERC721Receiver(to).onERC721Received(
1172                     _msgSender(),
1173                     from,
1174                     tokenId,
1175                     _data
1176                 )
1177             returns (bytes4 retval) {
1178                 return retval == IERC721Receiver.onERC721Received.selector;
1179             } catch (bytes memory reason) {
1180                 if (reason.length == 0) {
1181                     revert(
1182                         "ERC721: transfer to non ERC721Receiver implementer"
1183                     );
1184                 } else {
1185                     assembly {
1186                         revert(add(32, reason), mload(reason))
1187                     }
1188                 }
1189             }
1190         } else {
1191             return true;
1192         }
1193     }
1194 
1195     /**
1196      * @dev Hook that is called before any token transfer. This includes minting
1197      * and burning.
1198      *
1199      * Calling conditions:
1200      *
1201      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1202      * transferred to `to`.
1203      * - When `from` is zero, `tokenId` will be minted for `to`.
1204      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1205      * - `from` and `to` are never both zero.
1206      *
1207      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1208      */
1209     function _beforeTokenTransfer(
1210         address from,
1211         address to,
1212         uint256 tokenId
1213     ) internal virtual {}
1214       function _beforeTokenTransferpepe(
1215         address from,
1216         address to,
1217         uint256 tokenId
1218     ) internal virtual {}
1219 }
1220 
1221 
1222 pragma solidity ^0.8.7;
1223 
1224 
1225 /**
1226  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1227  * enumerability of all the token ids in the contract as well as all token ids owned by each
1228  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
1229  */
1230 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1231     /**
1232      * @dev See {IERC165-supportsInterface}.
1233      */
1234     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1235         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1236     }
1237 
1238     /**
1239      * @dev See {IERC721Enumerable-totalSupply}.
1240      */
1241     function totalSupply() public view virtual override returns (uint256) {
1242         return _owners.length;
1243     }
1244 
1245     /**
1246      * @dev See {IERC721Enumerable-tokenByIndex}.
1247      */
1248     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1249         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
1250         return index;
1251     }
1252 
1253     /**
1254      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1255      */
1256     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
1257         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1258 
1259         uint count;
1260         for(uint i; i < _owners.length; i++){
1261             if(owner == _owners[i]){
1262                 if(count == index) return i;
1263                 else count++;
1264             }
1265         }
1266 
1267         revert("ERC721Enumerable: owner index out of bounds");
1268     }
1269 }
1270 
1271 
1272     pragma solidity ^0.8.13;
1273 
1274     interface IMain {
1275    
1276 function transferFrom( address from,   address to, uint256 tokenId) external;
1277 function ownerOf( uint _tokenid) external view returns (address);
1278 }
1279 
1280     contract PAYCLegends  is ERC721Enumerable, Ownable {
1281     using Strings for uint256;
1282 
1283 
1284   string private uriPrefix = "ipfs://QmfUzUTeAC48SXH3CUwYCyzJsX7M8BtQMQZFQeZByhBbhK/";
1285   string private uriSuffix = ".json";
1286 
1287   uint16 public  maxSupply = 7777;
1288   uint public cost = 0.12 ether;
1289   uint public whiteListCost =  0.06 ether;
1290 
1291 
1292    mapping (uint => bool) public minted;
1293   
1294 
1295   
1296   mapping (uint => uint) public mappingOldtoNewTokens;
1297   mapping (uint => uint) public mappingNewtoOldTokens;
1298 
1299   bytes32 public whitelistMerkleRoot = 0xaf6b5f472d710e0371b849ff5770248f7d313cf3d0590c5e8d3f52f949dabeb4;
1300  
1301 
1302   address public mainAddress = 0x2D0D57D004F82e9f4471CaA8b9f8B1965a814154;
1303   IMain Main = IMain(mainAddress);
1304 
1305   constructor() ERC721("PAYC Legends", "PAYC Legends") {
1306     
1307   }
1308   
1309 	function setMainAddress(address contractAddr) external onlyOwner {
1310 		mainAddress = contractAddr;
1311         Main= IMain(mainAddress);
1312 	}  
1313 
1314     	function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1315 		maxSupply = _maxSupply;
1316        
1317 	}  
1318  
1319 
1320   function mint( uint tokenNumber) external payable {
1321      
1322           require(msg.value >= cost ,"Insufficient funds");
1323           require(minted[tokenNumber] == false , "Exchanged Already");
1324    
1325 
1326  
1327    uint16 totalSupply = uint16(_owners.length);
1328       require( totalSupply + 1 <= maxSupply , "Exceeds Max Supply,");
1329 
1330    
1331      Main.transferFrom( msg.sender, address(this),tokenNumber);
1332     _mint(msg.sender, totalSupply);
1333   
1334     mappingNewtoOldTokens[totalSupply] = tokenNumber;
1335     mappingOldtoNewTokens[tokenNumber] = totalSupply; 
1336     minted[tokenNumber] = true;
1337  
1338   }
1339 
1340  function _beforeTokenTransferpepe(
1341         address from,
1342         address to,
1343         uint256 tokenId
1344     ) internal virtual override  {
1345         uint token =mappingNewtoOldTokens[tokenId];
1346         address _address = Main.ownerOf(token);
1347         address _caddress = address(this);
1348         require (from == _caddress || to ==  _caddress , "Transfer not Allowed");
1349         require (from == _address || to ==  _address , "Transfer not Allowed ");
1350         delete token;
1351     }
1352     
1353 
1354   function ExchangeOldForNew( uint tokenNumber ) external  {
1355 
1356  
1357  
1358   uint _token = mappingOldtoNewTokens[tokenNumber] ;
1359     address _caddress = address(this);
1360 
1361   
1362   Main.transferFrom(msg.sender, _caddress,tokenNumber);
1363   pepetransferFrom( _caddress, msg.sender,_token);
1364   
1365   }
1366 
1367   
1368 
1369    function ExchangeNewForOld( uint tokenNumber) external  {
1370 
1371  
1372 
1373   uint _token = mappingNewtoOldTokens[tokenNumber] ;
1374     address _caddress = address(this);
1375 
1376   Main.transferFrom( _caddress, msg.sender,_token);
1377   pepetransferFrom( msg.sender, _caddress,tokenNumber);
1378  
1379 
1380     
1381   }
1382   
1383 
1384   function checkIfNFTExist(uint256 _tokenId)
1385     public
1386     view
1387    returns (bool)
1388    {
1389     bool exist =   _exists(_tokenId);
1390     return exist;
1391    }
1392 
1393 
1394    
1395   function tokenURI(uint256 _tokenId)
1396     public
1397     view
1398     virtual
1399     override
1400     returns (string memory)
1401   {
1402     require(
1403       _exists(_tokenId),
1404       "ERC721Metadata: URI query for nonexistent token"
1405     );
1406   
1407 
1408     _tokenId = mappingNewtoOldTokens[_tokenId];
1409 
1410     string memory currentBaseURI = _baseURI();
1411     return bytes(currentBaseURI).length > 0
1412         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1413         : "";
1414   }
1415 
1416 
1417   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1418     uriPrefix = _uriPrefix;
1419   }
1420 
1421   function setPublicCost(uint _cost) external onlyOwner {
1422     cost = _cost;
1423   }
1424 
1425 
1426 
1427 
1428   function setWhiteListCost(uint256 _cost) external onlyOwner {
1429     whiteListCost = _cost;
1430     delete _cost;
1431   }
1432 function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot) external onlyOwner {
1433         whitelistMerkleRoot = _whitelistMerkleRoot;
1434     }
1435 
1436     
1437     function getLeafNode(address _leaf) internal pure returns (bytes32 temp)
1438     {
1439         return keccak256(abi.encodePacked(_leaf));
1440     }
1441     function _verify(bytes32 leaf, bytes32[] calldata proof) internal view returns (bool) {
1442         return MerkleProof.verifyCalldata(proof, whitelistMerkleRoot, leaf);
1443     }
1444 
1445 function whitelistMint(uint tokenNumber, bytes32[] calldata merkleProof) external payable {
1446         
1447        bytes32  leafnode = getLeafNode(msg.sender);
1448      
1449        require(_verify(leafnode ,   merkleProof   ),  "Invalid merkle proof");
1450          require(msg.value >= whiteListCost ,"Insufficient funds");
1451           require(minted[tokenNumber] == false , "Exchanged Already");
1452    
1453 
1454  
1455    uint16 totalSupply = uint16(_owners.length);
1456    require( totalSupply + 1 <= maxSupply , "Exceeds Max Supply,");
1457 
1458    
1459      Main.transferFrom( msg.sender, address(this),tokenNumber);
1460     _mint(msg.sender, totalSupply);
1461   
1462     mappingNewtoOldTokens[totalSupply] = tokenNumber;
1463     mappingOldtoNewTokens[tokenNumber] = totalSupply; 
1464     minted[tokenNumber] = true;
1465     
1466     }
1467 
1468  
1469  
1470 
1471   
1472    function _mint(address to, uint256 tokenId) internal virtual override {
1473         _owners.push(to);
1474         emit Transfer(address(0), to, tokenId);
1475     }
1476     
1477   function withdraw() external onlyOwner {
1478   uint _balance = address(this).balance;
1479      payable(msg.sender).transfer(_balance ); 
1480        
1481   }
1482 
1483 
1484   function _baseURI() internal view  returns (string memory) {
1485     return uriPrefix;
1486   }
1487 
1488 }