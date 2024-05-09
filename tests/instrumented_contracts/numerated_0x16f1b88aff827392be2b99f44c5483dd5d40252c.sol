1 // File: contracts/IMeta.sol
2 
3 
4 // ____  __  _  _  ____  ____   __   ____ 
5 //(  _ \(  )( \/ )/ ___)(  __) / _\ / ___)
6 // ) __/ )(  )  ( \___ \ ) _) /    \\___ \
7 //(__)  (__)(_/\_)(____/(____)\_/\_/(____/
8 //                             
9 //creator : @debugger - twitter.com/debuggerguy
10 //website : pixseas.xyz
11 
12 pragma solidity ^0.8.0;
13 
14 interface IMeta 
15 {
16     function getMetadata(uint256 tokenId) external view returns (string memory);
17 }
18 // File: contracts/MerkleProof.sol
19 
20 
21 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev These functions deal with verification of Merkle Trees proofs.
27  *
28  * The proofs can be generated using the JavaScript library
29  * https://github.com/miguelmota/merkletreejs[merkletreejs].
30  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
31  *
32  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
33  *
34  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
35  * hashing, or use a hash function other than keccak256 for hashing leaves.
36  * This is because the concatenation of a sorted pair of internal nodes in
37  * the merkle tree could be reinterpreted as a leaf value.
38  */
39 library MerkleProof {
40     /**
41      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
42      * defined by `root`. For this, a `proof` must be provided, containing
43      * sibling hashes on the branch from the leaf to the root of the tree. Each
44      * pair of leaves and each pair of pre-images are assumed to be sorted.
45      */
46     function verify(
47         bytes32[] memory proof,
48         bytes32 root,
49         bytes32 leaf
50     ) internal pure returns (bool) {
51         return processProof(proof, leaf) == root;
52     }
53 
54     /**
55      * @dev Calldata version of {verify}
56      *
57      * _Available since v4.7._
58      */
59     function verifyCalldata(
60         bytes32[] calldata proof,
61         bytes32 root,
62         bytes32 leaf
63     ) internal pure returns (bool) {
64         return processProofCalldata(proof, leaf) == root;
65     }
66 
67     /**
68      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
69      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
70      * hash matches the root of the tree. When processing the proof, the pairs
71      * of leafs & pre-images are assumed to be sorted.
72      *
73      * _Available since v4.4._
74      */
75     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
76         bytes32 computedHash = leaf;
77         for (uint256 i = 0; i < proof.length; i++) {
78             computedHash = _hashPair(computedHash, proof[i]);
79         }
80         return computedHash;
81     }
82 
83     /**
84      * @dev Calldata version of {processProof}
85      *
86      * _Available since v4.7._
87      */
88     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
89         bytes32 computedHash = leaf;
90         for (uint256 i = 0; i < proof.length; i++) {
91             computedHash = _hashPair(computedHash, proof[i]);
92         }
93         return computedHash;
94     }
95 
96     /**
97      * @dev Returns true if a `leafs` can be proved to be a part of a Merkle tree
98      * defined by `root`. For this, `proofs` for each leaf must be provided, containing
99      * sibling hashes on the branch from the leaf to the root of the tree. Then
100      * 'proofFlag' designates the nodes needed for the multi proof.
101      *
102      * _Available since v4.7._
103      */
104     function multiProofVerify(
105         bytes32 root,
106         bytes32[] calldata leaves,
107         bytes32[] calldata proofs,
108         bool[] calldata proofFlag
109     ) internal pure returns (bool) {
110         return processMultiProof(leaves, proofs, proofFlag) == root;
111     }
112 
113     /**
114      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
115      * from `leaf` using the multi proof as `proofFlag`. A multi proof is
116      * valid if the final hash matches the root of the tree.
117      *
118      * _Available since v4.7._
119      */
120     function processMultiProof(
121         bytes32[] calldata leaves,
122         bytes32[] calldata proofs,
123         bool[] calldata proofFlag
124     ) internal pure returns (bytes32 merkleRoot) {
125         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
126         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
127         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
128         // the merkle tree.
129         uint256 leavesLen = leaves.length;
130         uint256 totalHashes = proofFlag.length;
131 
132         // Check proof validity.
133         require(leavesLen + proofs.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
134 
135         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
136         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
137         bytes32[] memory hashes = new bytes32[](totalHashes);
138         uint256 leafPos = 0;
139         uint256 hashPos = 0;
140         uint256 proofPos = 0;
141         // At each step, we compute the next hash using two values:
142         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
143         //   get the next hash.
144         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
145         //   `proofs` array.
146         for (uint256 i = 0; i < totalHashes; i++) {
147             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
148             bytes32 b = proofFlag[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proofs[proofPos++];
149             hashes[i] = _hashPair(a, b);
150         }
151 
152         if (totalHashes > 0) {
153             return hashes[totalHashes - 1];
154         } else if (leavesLen > 0) {
155             return leaves[0];
156         } else {
157             return proofs[0];
158         }
159     }
160 
161     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
162         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
163     }
164 
165     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
166         /// @solidity memory-safe-assembly
167         assembly {
168             mstore(0x00, a)
169             mstore(0x20, b)
170             value := keccak256(0x00, 0x40)
171         }
172     }
173 }
174 // File: @openzeppelin/contracts/utils/Strings.sol
175 
176 
177 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @dev String operations.
183  */
184 library Strings {
185     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
186     uint8 private constant _ADDRESS_LENGTH = 20;
187 
188     /**
189      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
190      */
191     function toString(uint256 value) internal pure returns (string memory) {
192         // Inspired by OraclizeAPI's implementation - MIT licence
193         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
194 
195         if (value == 0) {
196             return "0";
197         }
198         uint256 temp = value;
199         uint256 digits;
200         while (temp != 0) {
201             digits++;
202             temp /= 10;
203         }
204         bytes memory buffer = new bytes(digits);
205         while (value != 0) {
206             digits -= 1;
207             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
208             value /= 10;
209         }
210         return string(buffer);
211     }
212 
213     /**
214      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
215      */
216     function toHexString(uint256 value) internal pure returns (string memory) {
217         if (value == 0) {
218             return "0x00";
219         }
220         uint256 temp = value;
221         uint256 length = 0;
222         while (temp != 0) {
223             length++;
224             temp >>= 8;
225         }
226         return toHexString(value, length);
227     }
228 
229     /**
230      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
231      */
232     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
233         bytes memory buffer = new bytes(2 * length + 2);
234         buffer[0] = "0";
235         buffer[1] = "x";
236         for (uint256 i = 2 * length + 1; i > 1; --i) {
237             buffer[i] = _HEX_SYMBOLS[value & 0xf];
238             value >>= 4;
239         }
240         require(value == 0, "Strings: hex length insufficient");
241         return string(buffer);
242     }
243 
244     /**
245      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
246      */
247     function toHexString(address addr) internal pure returns (string memory) {
248         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
249     }
250 }
251 
252 // File: @openzeppelin/contracts/utils/Context.sol
253 
254 
255 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
256 
257 pragma solidity ^0.8.0;
258 
259 /**
260  * @dev Provides information about the current execution context, including the
261  * sender of the transaction and its data. While these are generally available
262  * via msg.sender and msg.data, they should not be accessed in such a direct
263  * manner, since when dealing with meta-transactions the account sending and
264  * paying for execution may not be the actual sender (as far as an application
265  * is concerned).
266  *
267  * This contract is only required for intermediate, library-like contracts.
268  */
269 abstract contract Context {
270     function _msgSender() internal view virtual returns (address) {
271         return msg.sender;
272     }
273 
274     function _msgData() internal view virtual returns (bytes calldata) {
275         return msg.data;
276     }
277 }
278 
279 // File: @openzeppelin/contracts/security/Pausable.sol
280 
281 
282 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
283 
284 pragma solidity ^0.8.0;
285 
286 
287 /**
288  * @dev Contract module which allows children to implement an emergency stop
289  * mechanism that can be triggered by an authorized account.
290  *
291  * This module is used through inheritance. It will make available the
292  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
293  * the functions of your contract. Note that they will not be pausable by
294  * simply including this module, only once the modifiers are put in place.
295  */
296 abstract contract Pausable is Context {
297     /**
298      * @dev Emitted when the pause is triggered by `account`.
299      */
300     event Paused(address account);
301 
302     /**
303      * @dev Emitted when the pause is lifted by `account`.
304      */
305     event Unpaused(address account);
306 
307     bool private _paused;
308 
309     /**
310      * @dev Initializes the contract in unpaused state.
311      */
312     constructor() {
313         _paused = false;
314     }
315 
316     /**
317      * @dev Modifier to make a function callable only when the contract is not paused.
318      *
319      * Requirements:
320      *
321      * - The contract must not be paused.
322      */
323     modifier whenNotPaused() {
324         _requireNotPaused();
325         _;
326     }
327 
328     /**
329      * @dev Modifier to make a function callable only when the contract is paused.
330      *
331      * Requirements:
332      *
333      * - The contract must be paused.
334      */
335     modifier whenPaused() {
336         _requirePaused();
337         _;
338     }
339 
340     /**
341      * @dev Returns true if the contract is paused, and false otherwise.
342      */
343     function paused() public view virtual returns (bool) {
344         return _paused;
345     }
346 
347     /**
348      * @dev Throws if the contract is paused.
349      */
350     function _requireNotPaused() internal view virtual {
351         require(!paused(), "Pausable: paused");
352     }
353 
354     /**
355      * @dev Throws if the contract is not paused.
356      */
357     function _requirePaused() internal view virtual {
358         require(paused(), "Pausable: not paused");
359     }
360 
361     /**
362      * @dev Triggers stopped state.
363      *
364      * Requirements:
365      *
366      * - The contract must not be paused.
367      */
368     function _pause() internal virtual whenNotPaused {
369         _paused = true;
370         emit Paused(_msgSender());
371     }
372 
373     /**
374      * @dev Returns to normal state.
375      *
376      * Requirements:
377      *
378      * - The contract must be paused.
379      */
380     function _unpause() internal virtual whenPaused {
381         _paused = false;
382         emit Unpaused(_msgSender());
383     }
384 }
385 
386 // File: @openzeppelin/contracts/access/Ownable.sol
387 
388 
389 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 
394 /**
395  * @dev Contract module which provides a basic access control mechanism, where
396  * there is an account (an owner) that can be granted exclusive access to
397  * specific functions.
398  *
399  * By default, the owner account will be the one that deploys the contract. This
400  * can later be changed with {transferOwnership}.
401  *
402  * This module is used through inheritance. It will make available the modifier
403  * `onlyOwner`, which can be applied to your functions to restrict their use to
404  * the owner.
405  */
406 abstract contract Ownable is Context {
407     address private _owner;
408 
409     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
410 
411     /**
412      * @dev Initializes the contract setting the deployer as the initial owner.
413      */
414     constructor() {
415         _transferOwnership(_msgSender());
416     }
417 
418     /**
419      * @dev Throws if called by any account other than the owner.
420      */
421     modifier onlyOwner() {
422         _checkOwner();
423         _;
424     }
425 
426     /**
427      * @dev Returns the address of the current owner.
428      */
429     function owner() public view virtual returns (address) {
430         return _owner;
431     }
432 
433     /**
434      * @dev Throws if the sender is not the owner.
435      */
436     function _checkOwner() internal view virtual {
437         require(owner() == _msgSender(), "Ownable: caller is not the owner");
438     }
439 
440     /**
441      * @dev Leaves the contract without owner. It will not be possible to call
442      * `onlyOwner` functions anymore. Can only be called by the current owner.
443      *
444      * NOTE: Renouncing ownership will leave the contract without an owner,
445      * thereby removing any functionality that is only available to the owner.
446      */
447     function renounceOwnership() public virtual onlyOwner {
448         _transferOwnership(address(0));
449     }
450 
451     /**
452      * @dev Transfers ownership of the contract to a new account (`newOwner`).
453      * Can only be called by the current owner.
454      */
455     function transferOwnership(address newOwner) public virtual onlyOwner {
456         require(newOwner != address(0), "Ownable: new owner is the zero address");
457         _transferOwnership(newOwner);
458     }
459 
460     /**
461      * @dev Transfers ownership of the contract to a new account (`newOwner`).
462      * Internal function without access restriction.
463      */
464     function _transferOwnership(address newOwner) internal virtual {
465         address oldOwner = _owner;
466         _owner = newOwner;
467         emit OwnershipTransferred(oldOwner, newOwner);
468     }
469 }
470 
471 // File: erc721a/contracts/IERC721A.sol
472 
473 
474 // ERC721A Contracts v4.2.3
475 // Creator: Chiru Labs
476 
477 pragma solidity ^0.8.4;
478 
479 /**
480  * @dev Interface of ERC721A.
481  */
482 interface IERC721A {
483     /**
484      * The caller must own the token or be an approved operator.
485      */
486     error ApprovalCallerNotOwnerNorApproved();
487 
488     /**
489      * The token does not exist.
490      */
491     error ApprovalQueryForNonexistentToken();
492 
493     /**
494      * Cannot query the balance for the zero address.
495      */
496     error BalanceQueryForZeroAddress();
497 
498     /**
499      * Cannot mint to the zero address.
500      */
501     error MintToZeroAddress();
502 
503     /**
504      * The quantity of tokens minted must be more than zero.
505      */
506     error MintZeroQuantity();
507 
508     /**
509      * The token does not exist.
510      */
511     error OwnerQueryForNonexistentToken();
512 
513     /**
514      * The caller must own the token or be an approved operator.
515      */
516     error TransferCallerNotOwnerNorApproved();
517 
518     /**
519      * The token must be owned by `from`.
520      */
521     error TransferFromIncorrectOwner();
522 
523     /**
524      * Cannot safely transfer to a contract that does not implement the
525      * ERC721Receiver interface.
526      */
527     error TransferToNonERC721ReceiverImplementer();
528 
529     /**
530      * Cannot transfer to the zero address.
531      */
532     error TransferToZeroAddress();
533 
534     /**
535      * The token does not exist.
536      */
537     error URIQueryForNonexistentToken();
538 
539     /**
540      * The `quantity` minted with ERC2309 exceeds the safety limit.
541      */
542     error MintERC2309QuantityExceedsLimit();
543 
544     /**
545      * The `extraData` cannot be set on an unintialized ownership slot.
546      */
547     error OwnershipNotInitializedForExtraData();
548 
549     // =============================================================
550     //                            STRUCTS
551     // =============================================================
552 
553     struct TokenOwnership {
554         // The address of the owner.
555         address addr;
556         // Stores the start time of ownership with minimal overhead for tokenomics.
557         uint64 startTimestamp;
558         // Whether the token has been burned.
559         bool burned;
560         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
561         uint24 extraData;
562     }
563 
564     // =============================================================
565     //                         TOKEN COUNTERS
566     // =============================================================
567 
568     /**
569      * @dev Returns the total number of tokens in existence.
570      * Burned tokens will reduce the count.
571      * To get the total number of tokens minted, please see {_totalMinted}.
572      */
573     function totalSupply() external view returns (uint256);
574 
575     // =============================================================
576     //                            IERC165
577     // =============================================================
578 
579     /**
580      * @dev Returns true if this contract implements the interface defined by
581      * `interfaceId`. See the corresponding
582      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
583      * to learn more about how these ids are created.
584      *
585      * This function call must use less than 30000 gas.
586      */
587     function supportsInterface(bytes4 interfaceId) external view returns (bool);
588 
589     // =============================================================
590     //                            IERC721
591     // =============================================================
592 
593     /**
594      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
595      */
596     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
597 
598     /**
599      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
600      */
601     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
602 
603     /**
604      * @dev Emitted when `owner` enables or disables
605      * (`approved`) `operator` to manage all of its assets.
606      */
607     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
608 
609     /**
610      * @dev Returns the number of tokens in `owner`'s account.
611      */
612     function balanceOf(address owner) external view returns (uint256 balance);
613 
614     /**
615      * @dev Returns the owner of the `tokenId` token.
616      *
617      * Requirements:
618      *
619      * - `tokenId` must exist.
620      */
621     function ownerOf(uint256 tokenId) external view returns (address owner);
622 
623     /**
624      * @dev Safely transfers `tokenId` token from `from` to `to`,
625      * checking first that contract recipients are aware of the ERC721 protocol
626      * to prevent tokens from being forever locked.
627      *
628      * Requirements:
629      *
630      * - `from` cannot be the zero address.
631      * - `to` cannot be the zero address.
632      * - `tokenId` token must exist and be owned by `from`.
633      * - If the caller is not `from`, it must be have been allowed to move
634      * this token by either {approve} or {setApprovalForAll}.
635      * - If `to` refers to a smart contract, it must implement
636      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
637      *
638      * Emits a {Transfer} event.
639      */
640     function safeTransferFrom(
641         address from,
642         address to,
643         uint256 tokenId,
644         bytes calldata data
645     ) external payable;
646 
647     /**
648      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
649      */
650     function safeTransferFrom(
651         address from,
652         address to,
653         uint256 tokenId
654     ) external payable;
655 
656     /**
657      * @dev Transfers `tokenId` from `from` to `to`.
658      *
659      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
660      * whenever possible.
661      *
662      * Requirements:
663      *
664      * - `from` cannot be the zero address.
665      * - `to` cannot be the zero address.
666      * - `tokenId` token must be owned by `from`.
667      * - If the caller is not `from`, it must be approved to move this token
668      * by either {approve} or {setApprovalForAll}.
669      *
670      * Emits a {Transfer} event.
671      */
672     function transferFrom(
673         address from,
674         address to,
675         uint256 tokenId
676     ) external payable;
677 
678     /**
679      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
680      * The approval is cleared when the token is transferred.
681      *
682      * Only a single account can be approved at a time, so approving the
683      * zero address clears previous approvals.
684      *
685      * Requirements:
686      *
687      * - The caller must own the token or be an approved operator.
688      * - `tokenId` must exist.
689      *
690      * Emits an {Approval} event.
691      */
692     function approve(address to, uint256 tokenId) external payable;
693 
694     /**
695      * @dev Approve or remove `operator` as an operator for the caller.
696      * Operators can call {transferFrom} or {safeTransferFrom}
697      * for any token owned by the caller.
698      *
699      * Requirements:
700      *
701      * - The `operator` cannot be the caller.
702      *
703      * Emits an {ApprovalForAll} event.
704      */
705     function setApprovalForAll(address operator, bool _approved) external;
706 
707     /**
708      * @dev Returns the account approved for `tokenId` token.
709      *
710      * Requirements:
711      *
712      * - `tokenId` must exist.
713      */
714     function getApproved(uint256 tokenId) external view returns (address operator);
715 
716     /**
717      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
718      *
719      * See {setApprovalForAll}.
720      */
721     function isApprovedForAll(address owner, address operator) external view returns (bool);
722 
723     // =============================================================
724     //                        IERC721Metadata
725     // =============================================================
726 
727     /**
728      * @dev Returns the token collection name.
729      */
730     function name() external view returns (string memory);
731 
732     /**
733      * @dev Returns the token collection symbol.
734      */
735     function symbol() external view returns (string memory);
736 
737     /**
738      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
739      */
740     function tokenURI(uint256 tokenId) external view returns (string memory);
741 
742     // =============================================================
743     //                           IERC2309
744     // =============================================================
745 
746     /**
747      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
748      * (inclusive) is transferred from `from` to `to`, as defined in the
749      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
750      *
751      * See {_mintERC2309} for more details.
752      */
753     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
754 }
755 
756 // File: erc721a/contracts/ERC721A.sol
757 
758 
759 // ERC721A Contracts v4.2.3
760 // Creator: Chiru Labs
761 
762 pragma solidity ^0.8.4;
763 
764 
765 /**
766  * @dev Interface of ERC721 token receiver.
767  */
768 interface ERC721A__IERC721Receiver {
769     function onERC721Received(
770         address operator,
771         address from,
772         uint256 tokenId,
773         bytes calldata data
774     ) external returns (bytes4);
775 }
776 
777 /**
778  * @title ERC721A
779  *
780  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
781  * Non-Fungible Token Standard, including the Metadata extension.
782  * Optimized for lower gas during batch mints.
783  *
784  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
785  * starting from `_startTokenId()`.
786  *
787  * Assumptions:
788  *
789  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
790  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
791  */
792 contract ERC721A is IERC721A {
793     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
794     struct TokenApprovalRef {
795         address value;
796     }
797 
798     // =============================================================
799     //                           CONSTANTS
800     // =============================================================
801 
802     // Mask of an entry in packed address data.
803     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
804 
805     // The bit position of `numberMinted` in packed address data.
806     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
807 
808     // The bit position of `numberBurned` in packed address data.
809     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
810 
811     // The bit position of `aux` in packed address data.
812     uint256 private constant _BITPOS_AUX = 192;
813 
814     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
815     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
816 
817     // The bit position of `startTimestamp` in packed ownership.
818     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
819 
820     // The bit mask of the `burned` bit in packed ownership.
821     uint256 private constant _BITMASK_BURNED = 1 << 224;
822 
823     // The bit position of the `nextInitialized` bit in packed ownership.
824     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
825 
826     // The bit mask of the `nextInitialized` bit in packed ownership.
827     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
828 
829     // The bit position of `extraData` in packed ownership.
830     uint256 private constant _BITPOS_EXTRA_DATA = 232;
831 
832     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
833     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
834 
835     // The mask of the lower 160 bits for addresses.
836     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
837 
838     // The maximum `quantity` that can be minted with {_mintERC2309}.
839     // This limit is to prevent overflows on the address data entries.
840     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
841     // is required to cause an overflow, which is unrealistic.
842     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
843 
844     // The `Transfer` event signature is given by:
845     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
846     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
847         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
848 
849     // =============================================================
850     //                            STORAGE
851     // =============================================================
852 
853     // The next token ID to be minted.
854     uint256 private _currentIndex;
855 
856     // The number of tokens burned.
857     uint256 private _burnCounter;
858 
859     // Token name
860     string private _name;
861 
862     // Token symbol
863     string private _symbol;
864 
865     // Mapping from token ID to ownership details
866     // An empty struct value does not necessarily mean the token is unowned.
867     // See {_packedOwnershipOf} implementation for details.
868     //
869     // Bits Layout:
870     // - [0..159]   `addr`
871     // - [160..223] `startTimestamp`
872     // - [224]      `burned`
873     // - [225]      `nextInitialized`
874     // - [232..255] `extraData`
875     mapping(uint256 => uint256) private _packedOwnerships;
876 
877     // Mapping owner address to address data.
878     //
879     // Bits Layout:
880     // - [0..63]    `balance`
881     // - [64..127]  `numberMinted`
882     // - [128..191] `numberBurned`
883     // - [192..255] `aux`
884     mapping(address => uint256) private _packedAddressData;
885 
886     // Mapping from token ID to approved address.
887     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
888 
889     // Mapping from owner to operator approvals
890     mapping(address => mapping(address => bool)) private _operatorApprovals;
891 
892     // =============================================================
893     //                          CONSTRUCTOR
894     // =============================================================
895 
896     constructor(string memory name_, string memory symbol_) {
897         _name = name_;
898         _symbol = symbol_;
899         _currentIndex = _startTokenId();
900     }
901 
902     // =============================================================
903     //                   TOKEN COUNTING OPERATIONS
904     // =============================================================
905 
906     /**
907      * @dev Returns the starting token ID.
908      * To change the starting token ID, please override this function.
909      */
910     function _startTokenId() internal view virtual returns (uint256) {
911         return 0;
912     }
913 
914     /**
915      * @dev Returns the next token ID to be minted.
916      */
917     function _nextTokenId() internal view virtual returns (uint256) {
918         return _currentIndex;
919     }
920 
921     /**
922      * @dev Returns the total number of tokens in existence.
923      * Burned tokens will reduce the count.
924      * To get the total number of tokens minted, please see {_totalMinted}.
925      */
926     function totalSupply() public view virtual override returns (uint256) {
927         // Counter underflow is impossible as _burnCounter cannot be incremented
928         // more than `_currentIndex - _startTokenId()` times.
929         unchecked {
930             return _currentIndex - _burnCounter - _startTokenId();
931         }
932     }
933 
934     /**
935      * @dev Returns the total amount of tokens minted in the contract.
936      */
937     function _totalMinted() internal view virtual returns (uint256) {
938         // Counter underflow is impossible as `_currentIndex` does not decrement,
939         // and it is initialized to `_startTokenId()`.
940         unchecked {
941             return _currentIndex - _startTokenId();
942         }
943     }
944 
945     /**
946      * @dev Returns the total number of tokens burned.
947      */
948     function _totalBurned() internal view virtual returns (uint256) {
949         return _burnCounter;
950     }
951 
952     // =============================================================
953     //                    ADDRESS DATA OPERATIONS
954     // =============================================================
955 
956     /**
957      * @dev Returns the number of tokens in `owner`'s account.
958      */
959     function balanceOf(address owner) public view virtual override returns (uint256) {
960         if (owner == address(0)) revert BalanceQueryForZeroAddress();
961         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
962     }
963 
964     /**
965      * Returns the number of tokens minted by `owner`.
966      */
967     function _numberMinted(address owner) internal view returns (uint256) {
968         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
969     }
970 
971     /**
972      * Returns the number of tokens burned by or on behalf of `owner`.
973      */
974     function _numberBurned(address owner) internal view returns (uint256) {
975         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
976     }
977 
978     /**
979      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
980      */
981     function _getAux(address owner) internal view returns (uint64) {
982         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
983     }
984 
985     /**
986      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
987      * If there are multiple variables, please pack them into a uint64.
988      */
989     function _setAux(address owner, uint64 aux) internal virtual {
990         uint256 packed = _packedAddressData[owner];
991         uint256 auxCasted;
992         // Cast `aux` with assembly to avoid redundant masking.
993         assembly {
994             auxCasted := aux
995         }
996         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
997         _packedAddressData[owner] = packed;
998     }
999 
1000     // =============================================================
1001     //                            IERC165
1002     // =============================================================
1003 
1004     /**
1005      * @dev Returns true if this contract implements the interface defined by
1006      * `interfaceId`. See the corresponding
1007      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1008      * to learn more about how these ids are created.
1009      *
1010      * This function call must use less than 30000 gas.
1011      */
1012     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1013         // The interface IDs are constants representing the first 4 bytes
1014         // of the XOR of all function selectors in the interface.
1015         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1016         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1017         return
1018             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1019             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1020             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1021     }
1022 
1023     // =============================================================
1024     //                        IERC721Metadata
1025     // =============================================================
1026 
1027     /**
1028      * @dev Returns the token collection name.
1029      */
1030     function name() public view virtual override returns (string memory) {
1031         return _name;
1032     }
1033 
1034     /**
1035      * @dev Returns the token collection symbol.
1036      */
1037     function symbol() public view virtual override returns (string memory) {
1038         return _symbol;
1039     }
1040 
1041     /**
1042      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1043      */
1044     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1045         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1046 
1047         string memory baseURI = _baseURI();
1048         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1049     }
1050 
1051     /**
1052      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1053      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1054      * by default, it can be overridden in child contracts.
1055      */
1056     function _baseURI() internal view virtual returns (string memory) {
1057         return '';
1058     }
1059 
1060     // =============================================================
1061     //                     OWNERSHIPS OPERATIONS
1062     // =============================================================
1063 
1064     /**
1065      * @dev Returns the owner of the `tokenId` token.
1066      *
1067      * Requirements:
1068      *
1069      * - `tokenId` must exist.
1070      */
1071     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1072         return address(uint160(_packedOwnershipOf(tokenId)));
1073     }
1074 
1075     /**
1076      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1077      * It gradually moves to O(1) as tokens get transferred around over time.
1078      */
1079     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1080         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1081     }
1082 
1083     /**
1084      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1085      */
1086     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1087         return _unpackedOwnership(_packedOwnerships[index]);
1088     }
1089 
1090     /**
1091      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1092      */
1093     function _initializeOwnershipAt(uint256 index) internal virtual {
1094         if (_packedOwnerships[index] == 0) {
1095             _packedOwnerships[index] = _packedOwnershipOf(index);
1096         }
1097     }
1098 
1099     /**
1100      * Returns the packed ownership data of `tokenId`.
1101      */
1102     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1103         uint256 curr = tokenId;
1104 
1105         unchecked {
1106             if (_startTokenId() <= curr)
1107                 if (curr < _currentIndex) {
1108                     uint256 packed = _packedOwnerships[curr];
1109                     // If not burned.
1110                     if (packed & _BITMASK_BURNED == 0) {
1111                         // Invariant:
1112                         // There will always be an initialized ownership slot
1113                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1114                         // before an unintialized ownership slot
1115                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1116                         // Hence, `curr` will not underflow.
1117                         //
1118                         // We can directly compare the packed value.
1119                         // If the address is zero, packed will be zero.
1120                         while (packed == 0) {
1121                             packed = _packedOwnerships[--curr];
1122                         }
1123                         return packed;
1124                     }
1125                 }
1126         }
1127         revert OwnerQueryForNonexistentToken();
1128     }
1129 
1130     /**
1131      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1132      */
1133     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1134         ownership.addr = address(uint160(packed));
1135         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1136         ownership.burned = packed & _BITMASK_BURNED != 0;
1137         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1138     }
1139 
1140     /**
1141      * @dev Packs ownership data into a single uint256.
1142      */
1143     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1144         assembly {
1145             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1146             owner := and(owner, _BITMASK_ADDRESS)
1147             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1148             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1149         }
1150     }
1151 
1152     /**
1153      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1154      */
1155     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1156         // For branchless setting of the `nextInitialized` flag.
1157         assembly {
1158             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1159             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1160         }
1161     }
1162 
1163     // =============================================================
1164     //                      APPROVAL OPERATIONS
1165     // =============================================================
1166 
1167     /**
1168      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1169      * The approval is cleared when the token is transferred.
1170      *
1171      * Only a single account can be approved at a time, so approving the
1172      * zero address clears previous approvals.
1173      *
1174      * Requirements:
1175      *
1176      * - The caller must own the token or be an approved operator.
1177      * - `tokenId` must exist.
1178      *
1179      * Emits an {Approval} event.
1180      */
1181     function approve(address to, uint256 tokenId) public payable virtual override {
1182         address owner = ownerOf(tokenId);
1183 
1184         if (_msgSenderERC721A() != owner)
1185             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1186                 revert ApprovalCallerNotOwnerNorApproved();
1187             }
1188 
1189         _tokenApprovals[tokenId].value = to;
1190         emit Approval(owner, to, tokenId);
1191     }
1192 
1193     /**
1194      * @dev Returns the account approved for `tokenId` token.
1195      *
1196      * Requirements:
1197      *
1198      * - `tokenId` must exist.
1199      */
1200     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1201         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1202 
1203         return _tokenApprovals[tokenId].value;
1204     }
1205 
1206     /**
1207      * @dev Approve or remove `operator` as an operator for the caller.
1208      * Operators can call {transferFrom} or {safeTransferFrom}
1209      * for any token owned by the caller.
1210      *
1211      * Requirements:
1212      *
1213      * - The `operator` cannot be the caller.
1214      *
1215      * Emits an {ApprovalForAll} event.
1216      */
1217     function setApprovalForAll(address operator, bool approved) public virtual override {
1218         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1219         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1220     }
1221 
1222     /**
1223      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1224      *
1225      * See {setApprovalForAll}.
1226      */
1227     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1228         return _operatorApprovals[owner][operator];
1229     }
1230 
1231     /**
1232      * @dev Returns whether `tokenId` exists.
1233      *
1234      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1235      *
1236      * Tokens start existing when they are minted. See {_mint}.
1237      */
1238     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1239         return
1240             _startTokenId() <= tokenId &&
1241             tokenId < _currentIndex && // If within bounds,
1242             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1243     }
1244 
1245     /**
1246      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1247      */
1248     function _isSenderApprovedOrOwner(
1249         address approvedAddress,
1250         address owner,
1251         address msgSender
1252     ) private pure returns (bool result) {
1253         assembly {
1254             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1255             owner := and(owner, _BITMASK_ADDRESS)
1256             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1257             msgSender := and(msgSender, _BITMASK_ADDRESS)
1258             // `msgSender == owner || msgSender == approvedAddress`.
1259             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1260         }
1261     }
1262 
1263     /**
1264      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1265      */
1266     function _getApprovedSlotAndAddress(uint256 tokenId)
1267         private
1268         view
1269         returns (uint256 approvedAddressSlot, address approvedAddress)
1270     {
1271         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1272         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1273         assembly {
1274             approvedAddressSlot := tokenApproval.slot
1275             approvedAddress := sload(approvedAddressSlot)
1276         }
1277     }
1278 
1279     // =============================================================
1280     //                      TRANSFER OPERATIONS
1281     // =============================================================
1282 
1283     /**
1284      * @dev Transfers `tokenId` from `from` to `to`.
1285      *
1286      * Requirements:
1287      *
1288      * - `from` cannot be the zero address.
1289      * - `to` cannot be the zero address.
1290      * - `tokenId` token must be owned by `from`.
1291      * - If the caller is not `from`, it must be approved to move this token
1292      * by either {approve} or {setApprovalForAll}.
1293      *
1294      * Emits a {Transfer} event.
1295      */
1296     function transferFrom(
1297         address from,
1298         address to,
1299         uint256 tokenId
1300     ) public payable virtual override {
1301         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1302 
1303         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1304 
1305         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1306 
1307         // The nested ifs save around 20+ gas over a compound boolean condition.
1308         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1309             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1310 
1311         if (to == address(0)) revert TransferToZeroAddress();
1312 
1313         _beforeTokenTransfers(from, to, tokenId, 1);
1314 
1315         // Clear approvals from the previous owner.
1316         assembly {
1317             if approvedAddress {
1318                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1319                 sstore(approvedAddressSlot, 0)
1320             }
1321         }
1322 
1323         // Underflow of the sender's balance is impossible because we check for
1324         // ownership above and the recipient's balance can't realistically overflow.
1325         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1326         unchecked {
1327             // We can directly increment and decrement the balances.
1328             --_packedAddressData[from]; // Updates: `balance -= 1`.
1329             ++_packedAddressData[to]; // Updates: `balance += 1`.
1330 
1331             // Updates:
1332             // - `address` to the next owner.
1333             // - `startTimestamp` to the timestamp of transfering.
1334             // - `burned` to `false`.
1335             // - `nextInitialized` to `true`.
1336             _packedOwnerships[tokenId] = _packOwnershipData(
1337                 to,
1338                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1339             );
1340 
1341             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1342             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1343                 uint256 nextTokenId = tokenId + 1;
1344                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1345                 if (_packedOwnerships[nextTokenId] == 0) {
1346                     // If the next slot is within bounds.
1347                     if (nextTokenId != _currentIndex) {
1348                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1349                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1350                     }
1351                 }
1352             }
1353         }
1354 
1355         emit Transfer(from, to, tokenId);
1356         _afterTokenTransfers(from, to, tokenId, 1);
1357     }
1358 
1359     /**
1360      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1361      */
1362     function safeTransferFrom(
1363         address from,
1364         address to,
1365         uint256 tokenId
1366     ) public payable virtual override {
1367         safeTransferFrom(from, to, tokenId, '');
1368     }
1369 
1370     /**
1371      * @dev Safely transfers `tokenId` token from `from` to `to`.
1372      *
1373      * Requirements:
1374      *
1375      * - `from` cannot be the zero address.
1376      * - `to` cannot be the zero address.
1377      * - `tokenId` token must exist and be owned by `from`.
1378      * - If the caller is not `from`, it must be approved to move this token
1379      * by either {approve} or {setApprovalForAll}.
1380      * - If `to` refers to a smart contract, it must implement
1381      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1382      *
1383      * Emits a {Transfer} event.
1384      */
1385     function safeTransferFrom(
1386         address from,
1387         address to,
1388         uint256 tokenId,
1389         bytes memory _data
1390     ) public payable virtual override {
1391         transferFrom(from, to, tokenId);
1392         if (to.code.length != 0)
1393             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1394                 revert TransferToNonERC721ReceiverImplementer();
1395             }
1396     }
1397 
1398     /**
1399      * @dev Hook that is called before a set of serially-ordered token IDs
1400      * are about to be transferred. This includes minting.
1401      * And also called before burning one token.
1402      *
1403      * `startTokenId` - the first token ID to be transferred.
1404      * `quantity` - the amount to be transferred.
1405      *
1406      * Calling conditions:
1407      *
1408      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1409      * transferred to `to`.
1410      * - When `from` is zero, `tokenId` will be minted for `to`.
1411      * - When `to` is zero, `tokenId` will be burned by `from`.
1412      * - `from` and `to` are never both zero.
1413      */
1414     function _beforeTokenTransfers(
1415         address from,
1416         address to,
1417         uint256 startTokenId,
1418         uint256 quantity
1419     ) internal virtual {}
1420 
1421     /**
1422      * @dev Hook that is called after a set of serially-ordered token IDs
1423      * have been transferred. This includes minting.
1424      * And also called after one token has been burned.
1425      *
1426      * `startTokenId` - the first token ID to be transferred.
1427      * `quantity` - the amount to be transferred.
1428      *
1429      * Calling conditions:
1430      *
1431      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1432      * transferred to `to`.
1433      * - When `from` is zero, `tokenId` has been minted for `to`.
1434      * - When `to` is zero, `tokenId` has been burned by `from`.
1435      * - `from` and `to` are never both zero.
1436      */
1437     function _afterTokenTransfers(
1438         address from,
1439         address to,
1440         uint256 startTokenId,
1441         uint256 quantity
1442     ) internal virtual {}
1443 
1444     /**
1445      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1446      *
1447      * `from` - Previous owner of the given token ID.
1448      * `to` - Target address that will receive the token.
1449      * `tokenId` - Token ID to be transferred.
1450      * `_data` - Optional data to send along with the call.
1451      *
1452      * Returns whether the call correctly returned the expected magic value.
1453      */
1454     function _checkContractOnERC721Received(
1455         address from,
1456         address to,
1457         uint256 tokenId,
1458         bytes memory _data
1459     ) private returns (bool) {
1460         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1461             bytes4 retval
1462         ) {
1463             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1464         } catch (bytes memory reason) {
1465             if (reason.length == 0) {
1466                 revert TransferToNonERC721ReceiverImplementer();
1467             } else {
1468                 assembly {
1469                     revert(add(32, reason), mload(reason))
1470                 }
1471             }
1472         }
1473     }
1474 
1475     // =============================================================
1476     //                        MINT OPERATIONS
1477     // =============================================================
1478 
1479     /**
1480      * @dev Mints `quantity` tokens and transfers them to `to`.
1481      *
1482      * Requirements:
1483      *
1484      * - `to` cannot be the zero address.
1485      * - `quantity` must be greater than 0.
1486      *
1487      * Emits a {Transfer} event for each mint.
1488      */
1489     function _mint(address to, uint256 quantity) internal virtual {
1490         uint256 startTokenId = _currentIndex;
1491         if (quantity == 0) revert MintZeroQuantity();
1492 
1493         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1494 
1495         // Overflows are incredibly unrealistic.
1496         // `balance` and `numberMinted` have a maximum limit of 2**64.
1497         // `tokenId` has a maximum limit of 2**256.
1498         unchecked {
1499             // Updates:
1500             // - `balance += quantity`.
1501             // - `numberMinted += quantity`.
1502             //
1503             // We can directly add to the `balance` and `numberMinted`.
1504             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1505 
1506             // Updates:
1507             // - `address` to the owner.
1508             // - `startTimestamp` to the timestamp of minting.
1509             // - `burned` to `false`.
1510             // - `nextInitialized` to `quantity == 1`.
1511             _packedOwnerships[startTokenId] = _packOwnershipData(
1512                 to,
1513                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1514             );
1515 
1516             uint256 toMasked;
1517             uint256 end = startTokenId + quantity;
1518 
1519             // Use assembly to loop and emit the `Transfer` event for gas savings.
1520             // The duplicated `log4` removes an extra check and reduces stack juggling.
1521             // The assembly, together with the surrounding Solidity code, have been
1522             // delicately arranged to nudge the compiler into producing optimized opcodes.
1523             assembly {
1524                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1525                 toMasked := and(to, _BITMASK_ADDRESS)
1526                 // Emit the `Transfer` event.
1527                 log4(
1528                     0, // Start of data (0, since no data).
1529                     0, // End of data (0, since no data).
1530                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1531                     0, // `address(0)`.
1532                     toMasked, // `to`.
1533                     startTokenId // `tokenId`.
1534                 )
1535 
1536                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1537                 // that overflows uint256 will make the loop run out of gas.
1538                 // The compiler will optimize the `iszero` away for performance.
1539                 for {
1540                     let tokenId := add(startTokenId, 1)
1541                 } iszero(eq(tokenId, end)) {
1542                     tokenId := add(tokenId, 1)
1543                 } {
1544                     // Emit the `Transfer` event. Similar to above.
1545                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1546                 }
1547             }
1548             if (toMasked == 0) revert MintToZeroAddress();
1549 
1550             _currentIndex = end;
1551         }
1552         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1553     }
1554 
1555     /**
1556      * @dev Mints `quantity` tokens and transfers them to `to`.
1557      *
1558      * This function is intended for efficient minting only during contract creation.
1559      *
1560      * It emits only one {ConsecutiveTransfer} as defined in
1561      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1562      * instead of a sequence of {Transfer} event(s).
1563      *
1564      * Calling this function outside of contract creation WILL make your contract
1565      * non-compliant with the ERC721 standard.
1566      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1567      * {ConsecutiveTransfer} event is only permissible during contract creation.
1568      *
1569      * Requirements:
1570      *
1571      * - `to` cannot be the zero address.
1572      * - `quantity` must be greater than 0.
1573      *
1574      * Emits a {ConsecutiveTransfer} event.
1575      */
1576     function _mintERC2309(address to, uint256 quantity) internal virtual {
1577         uint256 startTokenId = _currentIndex;
1578         if (to == address(0)) revert MintToZeroAddress();
1579         if (quantity == 0) revert MintZeroQuantity();
1580         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1581 
1582         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1583 
1584         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1585         unchecked {
1586             // Updates:
1587             // - `balance += quantity`.
1588             // - `numberMinted += quantity`.
1589             //
1590             // We can directly add to the `balance` and `numberMinted`.
1591             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1592 
1593             // Updates:
1594             // - `address` to the owner.
1595             // - `startTimestamp` to the timestamp of minting.
1596             // - `burned` to `false`.
1597             // - `nextInitialized` to `quantity == 1`.
1598             _packedOwnerships[startTokenId] = _packOwnershipData(
1599                 to,
1600                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1601             );
1602 
1603             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1604 
1605             _currentIndex = startTokenId + quantity;
1606         }
1607         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1608     }
1609 
1610     /**
1611      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1612      *
1613      * Requirements:
1614      *
1615      * - If `to` refers to a smart contract, it must implement
1616      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1617      * - `quantity` must be greater than 0.
1618      *
1619      * See {_mint}.
1620      *
1621      * Emits a {Transfer} event for each mint.
1622      */
1623     function _safeMint(
1624         address to,
1625         uint256 quantity,
1626         bytes memory _data
1627     ) internal virtual {
1628         _mint(to, quantity);
1629 
1630         unchecked {
1631             if (to.code.length != 0) {
1632                 uint256 end = _currentIndex;
1633                 uint256 index = end - quantity;
1634                 do {
1635                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1636                         revert TransferToNonERC721ReceiverImplementer();
1637                     }
1638                 } while (index < end);
1639                 // Reentrancy protection.
1640                 if (_currentIndex != end) revert();
1641             }
1642         }
1643     }
1644 
1645     /**
1646      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1647      */
1648     function _safeMint(address to, uint256 quantity) internal virtual {
1649         _safeMint(to, quantity, '');
1650     }
1651 
1652     // =============================================================
1653     //                        BURN OPERATIONS
1654     // =============================================================
1655 
1656     /**
1657      * @dev Equivalent to `_burn(tokenId, false)`.
1658      */
1659     function _burn(uint256 tokenId) internal virtual {
1660         _burn(tokenId, false);
1661     }
1662 
1663     /**
1664      * @dev Destroys `tokenId`.
1665      * The approval is cleared when the token is burned.
1666      *
1667      * Requirements:
1668      *
1669      * - `tokenId` must exist.
1670      *
1671      * Emits a {Transfer} event.
1672      */
1673     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1674         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1675 
1676         address from = address(uint160(prevOwnershipPacked));
1677 
1678         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1679 
1680         if (approvalCheck) {
1681             // The nested ifs save around 20+ gas over a compound boolean condition.
1682             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1683                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1684         }
1685 
1686         _beforeTokenTransfers(from, address(0), tokenId, 1);
1687 
1688         // Clear approvals from the previous owner.
1689         assembly {
1690             if approvedAddress {
1691                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1692                 sstore(approvedAddressSlot, 0)
1693             }
1694         }
1695 
1696         // Underflow of the sender's balance is impossible because we check for
1697         // ownership above and the recipient's balance can't realistically overflow.
1698         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1699         unchecked {
1700             // Updates:
1701             // - `balance -= 1`.
1702             // - `numberBurned += 1`.
1703             //
1704             // We can directly decrement the balance, and increment the number burned.
1705             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1706             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1707 
1708             // Updates:
1709             // - `address` to the last owner.
1710             // - `startTimestamp` to the timestamp of burning.
1711             // - `burned` to `true`.
1712             // - `nextInitialized` to `true`.
1713             _packedOwnerships[tokenId] = _packOwnershipData(
1714                 from,
1715                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1716             );
1717 
1718             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1719             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1720                 uint256 nextTokenId = tokenId + 1;
1721                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1722                 if (_packedOwnerships[nextTokenId] == 0) {
1723                     // If the next slot is within bounds.
1724                     if (nextTokenId != _currentIndex) {
1725                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1726                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1727                     }
1728                 }
1729             }
1730         }
1731 
1732         emit Transfer(from, address(0), tokenId);
1733         _afterTokenTransfers(from, address(0), tokenId, 1);
1734 
1735         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1736         unchecked {
1737             _burnCounter++;
1738         }
1739     }
1740 
1741     // =============================================================
1742     //                     EXTRA DATA OPERATIONS
1743     // =============================================================
1744 
1745     /**
1746      * @dev Directly sets the extra data for the ownership data `index`.
1747      */
1748     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1749         uint256 packed = _packedOwnerships[index];
1750         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1751         uint256 extraDataCasted;
1752         // Cast `extraData` with assembly to avoid redundant masking.
1753         assembly {
1754             extraDataCasted := extraData
1755         }
1756         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1757         _packedOwnerships[index] = packed;
1758     }
1759 
1760     /**
1761      * @dev Called during each token transfer to set the 24bit `extraData` field.
1762      * Intended to be overridden by the cosumer contract.
1763      *
1764      * `previousExtraData` - the value of `extraData` before transfer.
1765      *
1766      * Calling conditions:
1767      *
1768      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1769      * transferred to `to`.
1770      * - When `from` is zero, `tokenId` will be minted for `to`.
1771      * - When `to` is zero, `tokenId` will be burned by `from`.
1772      * - `from` and `to` are never both zero.
1773      */
1774     function _extraData(
1775         address from,
1776         address to,
1777         uint24 previousExtraData
1778     ) internal view virtual returns (uint24) {}
1779 
1780     /**
1781      * @dev Returns the next extra data for the packed ownership data.
1782      * The returned result is shifted into position.
1783      */
1784     function _nextExtraData(
1785         address from,
1786         address to,
1787         uint256 prevOwnershipPacked
1788     ) private view returns (uint256) {
1789         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1790         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1791     }
1792 
1793     // =============================================================
1794     //                       OTHER OPERATIONS
1795     // =============================================================
1796 
1797     /**
1798      * @dev Returns the message sender (defaults to `msg.sender`).
1799      *
1800      * If you are writing GSN compatible contracts, you need to override this function.
1801      */
1802     function _msgSenderERC721A() internal view virtual returns (address) {
1803         return msg.sender;
1804     }
1805 
1806     /**
1807      * @dev Converts a uint256 to its ASCII string decimal representation.
1808      */
1809     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1810         assembly {
1811             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1812             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1813             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1814             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1815             let m := add(mload(0x40), 0xa0)
1816             // Update the free memory pointer to allocate.
1817             mstore(0x40, m)
1818             // Assign the `str` to the end.
1819             str := sub(m, 0x20)
1820             // Zeroize the slot after the string.
1821             mstore(str, 0)
1822 
1823             // Cache the end of the memory to calculate the length later.
1824             let end := str
1825 
1826             // We write the string from rightmost digit to leftmost digit.
1827             // The following is essentially a do-while loop that also handles the zero case.
1828             // prettier-ignore
1829             for { let temp := value } 1 {} {
1830                 str := sub(str, 1)
1831                 // Write the character to the pointer.
1832                 // The ASCII index of the '0' character is 48.
1833                 mstore8(str, add(48, mod(temp, 10)))
1834                 // Keep dividing `temp` until zero.
1835                 temp := div(temp, 10)
1836                 // prettier-ignore
1837                 if iszero(temp) { break }
1838             }
1839 
1840             let length := sub(end, str)
1841             // Move the pointer 32 bytes leftwards to make room for the length.
1842             str := sub(str, 0x20)
1843             // Store the length.
1844             mstore(str, length)
1845         }
1846     }
1847 }
1848 
1849 // File: contracts/Pixseas.sol
1850 
1851 //SPDX-License-Identifier: MIT
1852 // ____  __  _  _  ____  ____   __   ____ 
1853 //(  _ \(  )( \/ )/ ___)(  __) / _\ / ___)
1854 // ) __/ )(  )  ( \___ \ ) _) /    \\___ \
1855 //(__)  (__)(_/\_)(____/(____)\_/\_/(____/
1856 //    
1857 //creator : @debugger - twitter.com/debuggerguy
1858 //website : pixseas.xyz
1859 
1860 pragma solidity ^0.8.0; 
1861 
1862 
1863 
1864 
1865 
1866 
1867 
1868 contract Pixseas is ERC721A, Ownable, Pausable 
1869 {
1870     using Strings for uint256;
1871     
1872     uint256 public totalColSize = 5999;
1873     uint256 public pixListColSize = 1499;
1874     
1875     uint256 public pixListMintPrice = 0.0149 ether;
1876     uint256 public pixListWalletLimit = 2;
1877 
1878     uint256 public publicMintPrice = 0.0299 ether;
1879     uint256 public publicWalletLimit = 5;
1880 
1881     mapping(address => uint256) public mintPixList;
1882     mapping(address => uint256) public mintPublicList;
1883 
1884     bytes32 public pixListMerkleRoot = 0x7e338027177c5fc9284cd333cb533e0f15c2680b0125fff596ee7436798bf95d;
1885     address public mdProvider;
1886     string private baseTokenURI;
1887     bool public providerBasedURI;
1888     bool public pixListMintActive;
1889     bool public publicMintActive;
1890 
1891     constructor
1892     ( 
1893        string memory _name,
1894        string memory _symbol,
1895        string memory _baseTokenURI
1896     ) ERC721A(_name, _symbol) 
1897     {
1898         baseTokenURI = _baseTokenURI;
1899     }
1900 
1901     modifier callerIsUser() 
1902     {
1903         require(tx.origin == msg.sender, "Caller is contract");
1904         _;
1905     }
1906 
1907     modifier onlyPixListMintActive() {
1908         require(pixListMintActive, "WL Minting is not active");
1909         _;
1910     }
1911     modifier onlyPublicMintActive() 
1912     {
1913         require( publicMintActive ? publicMintActive : ( totalSupply() >= pixListColSize ), "Public Minting is not active");
1914         _;
1915     }
1916 
1917     function setMdProvider(address _mdProvider) external onlyOwner {
1918         mdProvider = _mdProvider;
1919     }
1920 
1921     function tokenURI(uint256 _tokenId)
1922         public
1923         view
1924         virtual
1925         override
1926         returns (string memory)
1927     {
1928         require(_exists(_tokenId), "Token not existed");
1929         require( providerBasedURI ? ( mdProvider != address(0) ) : ( keccak256(abi.encodePacked(baseTokenURI)) != keccak256(abi.encodePacked("")) ),
1930             "Invalid metadata provider address"
1931         );
1932 
1933         return providerBasedURI ? IMeta(mdProvider).getMetadata(_tokenId) : string(abi.encodePacked(baseTokenURI, _tokenId.toString(),".json"));
1934     }
1935     
1936     
1937     function setBaseURI(string calldata _baseTokenURI) external onlyOwner 
1938     {
1939         baseTokenURI = _baseTokenURI;
1940     }
1941     
1942     function toggleProviderBasedURI() 
1943         external 
1944         onlyOwner 
1945     {
1946         providerBasedURI = !providerBasedURI;
1947     }
1948 
1949 
1950     function _startTokenId() internal pure override returns (uint256) {
1951         return 1;
1952     }
1953 
1954     function setPixListMerkleRoot(bytes32 _pixListMerkleRoot)
1955         external
1956         onlyOwner
1957     {
1958         pixListMerkleRoot = _pixListMerkleRoot;
1959     }
1960 
1961 
1962     function pixListMint(bytes32[] calldata _merkleProof, uint256 quantity)
1963         external
1964         payable
1965         onlyPixListMintActive
1966         callerIsUser 
1967     {
1968         require(mintPixList[msg.sender] + quantity <= pixListWalletLimit, "Up to 2 mints allowed per wallet");
1969         require(msg.value >= pixListMintPrice * quantity, "Insufficient funds");
1970         require(totalSupply() + quantity <= pixListColSize, "EXCEED_COL_SIZE");   
1971         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1972         require(
1973              MerkleProof.verify(_merkleProof, pixListMerkleRoot, leaf),
1974              "You are not pixlisted"
1975          );
1976 
1977         mintPixList[msg.sender] += quantity;
1978         _safeMint(msg.sender, quantity);
1979     }
1980 
1981     function publicMint(uint256 quantity)
1982         external
1983         payable
1984         onlyPublicMintActive
1985         callerIsUser    
1986     {
1987         require(mintPublicList[msg.sender] + quantity <= publicWalletLimit, "Up to 5 mints allowed per wallet");
1988         require(msg.value >= publicMintPrice * quantity, "Insufficient funds");
1989         require(totalSupply() + quantity <= totalColSize, "EXCEED_COL_SIZE");
1990 
1991         mintPublicList[msg.sender] += quantity;
1992         _safeMint(msg.sender, quantity);
1993     }
1994     
1995     function teamMint(uint256 quantity)
1996         external
1997         payable
1998         onlyOwner
1999     {
2000         require(quantity > 0, "Invalid quantity");
2001         require(totalSupply() + quantity <= totalColSize, "EXCEED_COL_SIZE");
2002 
2003         _safeMint(msg.sender, quantity);
2004     }
2005 
2006     function toggleSoldOut() 
2007         external 
2008         onlyOwner 
2009     {
2010         publicMintActive = !publicMintActive;
2011     }
2012 
2013     function airdrop(address toAdd,uint256 quantity)
2014         external
2015         payable
2016         onlyOwner
2017     {
2018         require(quantity > 0, "Invalid quantity");
2019         require(totalSupply() + quantity <= totalColSize, "EXCEED_COL_SIZE");
2020 
2021         _safeMint(toAdd, quantity);
2022     }
2023 
2024 
2025     function togglePixListMint() 
2026         external 
2027         onlyOwner 
2028     {
2029         pixListMintActive = !pixListMintActive;
2030     }
2031 
2032     function togglePublicMint() 
2033         external 
2034         onlyOwner 
2035     {
2036         pixListMintActive = !pixListMintActive;
2037         publicMintActive = !publicMintActive;
2038     }
2039 
2040 
2041     function pause() external onlyOwner {
2042         _pause();
2043     }
2044 
2045     function unpause() external onlyOwner {
2046         _unpause();
2047     }
2048     
2049     function _beforeTokenTransfers(
2050         address from,
2051         address to,
2052         uint256 tokenId,
2053         uint256 quantity
2054     ) internal override(ERC721A) whenNotPaused 
2055     {
2056         super._beforeTokenTransfers(from, to, tokenId, quantity);
2057     }
2058 
2059     function changeSupply(uint256 _decreaseAmount) 
2060         external 
2061         onlyOwner 
2062     {
2063         require(_decreaseAmount > 0 ,"Amount must be greater than 0");
2064         require(totalSupply() < totalColSize ,"Just sold out" );
2065         require(totalColSize - _decreaseAmount >= totalSupply() ,"Insufficient amount" );
2066         totalColSize -= _decreaseAmount;
2067     }
2068 
2069     function changePixListWalletLimit(uint256 _newPixListWalletLimit) 
2070         external 
2071         onlyOwner 
2072     {
2073         require(_newPixListWalletLimit > 0 ,"Invalid value");
2074         pixListWalletLimit = _newPixListWalletLimit;
2075     }
2076     function changePublicWalletLimit(uint256 _newPublicWalletLimit) 
2077         external 
2078         onlyOwner 
2079     {
2080         require(_newPublicWalletLimit > 0 ,"Invalid value");
2081         publicWalletLimit = _newPublicWalletLimit;
2082     }
2083 
2084     
2085     function changePixListMintPrice(uint256 _pixListMintPrice) 
2086         external 
2087         onlyOwner 
2088     {
2089         require(_pixListMintPrice >= 0 ,"Invalid price");
2090         pixListMintPrice = _pixListMintPrice;
2091     }
2092     function changePublictMintPrice(uint256 _publicMintPrice) 
2093         external 
2094         onlyOwner 
2095     {
2096         require(_publicMintPrice >= 0 ,"Invalid price");
2097         publicMintPrice = _publicMintPrice;
2098     }
2099 
2100     function changePixListColSize(uint256 _pixListColSize) 
2101         external 
2102         onlyOwner 
2103     {
2104         require(_pixListColSize >= 0 ,"Invalid price");
2105         pixListColSize = _pixListColSize;
2106     }
2107     
2108 
2109     function withdraw() 
2110         external 
2111         onlyOwner 
2112     {
2113         uint256 totalBalance = address(this).balance;
2114 
2115         address COMMUNITY_WALLET = 0x667e47CF9037327fdAFf8EcD393639CB7b63936F;
2116         address TECH_LEAD = 0x211584043e8D2E1c7a94764A8813Ea84aFc3e7aa;
2117         address ARTIST = 0xD55779fA12Ed38445CE5111C527b450AFE4DF32D;
2118         address PROJECT_MANAGER = 0xda60A92eA9054d1864c659230008684C708e53da;
2119         
2120         payable(COMMUNITY_WALLET).transfer(
2121              ((totalBalance * 2500) / 10000)
2122         );
2123         payable(TECH_LEAD).transfer(
2124              ((totalBalance * 2500) / 10000)
2125         );
2126         payable(ARTIST).transfer(
2127              ((totalBalance * 2500) / 10000)
2128         );
2129         payable(PROJECT_MANAGER).transfer(
2130              ((totalBalance * 2500) / 10000)
2131         );
2132     }
2133 
2134 }