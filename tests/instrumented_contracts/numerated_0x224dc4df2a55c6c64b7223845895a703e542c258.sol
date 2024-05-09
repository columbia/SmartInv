1 /** 
2  *  
3 */
4             
5 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 
32 
33 /** 
34  *  
35 */
36             
37 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
38 // ERC721A Contracts v4.2.3
39 // Creator: Chiru Labs
40 
41 pragma solidity ^0.8.4;
42 
43 /**
44  * @dev Interface of ERC721A.
45  */
46 interface IERC721A {
47     /**
48      * The caller must own the token or be an approved operator.
49      */
50     error ApprovalCallerNotOwnerNorApproved();
51 
52     /**
53      * The token does not exist.
54      */
55     error ApprovalQueryForNonexistentToken();
56 
57     /**
58      * Cannot query the balance for the zero address.
59      */
60     error BalanceQueryForZeroAddress();
61 
62     /**
63      * Cannot mint to the zero address.
64      */
65     error MintToZeroAddress();
66 
67     /**
68      * The quantity of tokens minted must be more than zero.
69      */
70     error MintZeroQuantity();
71 
72     /**
73      * The token does not exist.
74      */
75     error OwnerQueryForNonexistentToken();
76 
77     /**
78      * The caller must own the token or be an approved operator.
79      */
80     error TransferCallerNotOwnerNorApproved();
81 
82     /**
83      * The token must be owned by `from`.
84      */
85     error TransferFromIncorrectOwner();
86 
87     /**
88      * Cannot safely transfer to a contract that does not implement the
89      * ERC721Receiver interface.
90      */
91     error TransferToNonERC721ReceiverImplementer();
92 
93     /**
94      * Cannot transfer to the zero address.
95      */
96     error TransferToZeroAddress();
97 
98     /**
99      * The token does not exist.
100      */
101     error URIQueryForNonexistentToken();
102 
103     /**
104      * The `quantity` minted with ERC2309 exceeds the safety limit.
105      */
106     error MintERC2309QuantityExceedsLimit();
107 
108     /**
109      * The `extraData` cannot be set on an unintialized ownership slot.
110      */
111     error OwnershipNotInitializedForExtraData();
112 
113     // =============================================================
114     //                            STRUCTS
115     // =============================================================
116 
117     struct TokenOwnership {
118         // The address of the owner.
119         address addr;
120         // Stores the start time of ownership with minimal overhead for tokenomics.
121         uint64 startTimestamp;
122         // Whether the token has been burned.
123         bool burned;
124         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
125         uint24 extraData;
126     }
127 
128     // =============================================================
129     //                         TOKEN COUNTERS
130     // =============================================================
131 
132     /**
133      * @dev Returns the total number of tokens in existence.
134      * Burned tokens will reduce the count.
135      * To get the total number of tokens minted, please see {_totalMinted}.
136      */
137     function totalSupply() external view returns (uint256);
138 
139     // =============================================================
140     //                            IERC165
141     // =============================================================
142 
143     /**
144      * @dev Returns true if this contract implements the interface defined by
145      * `interfaceId`. See the corresponding
146      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
147      * to learn more about how these ids are created.
148      *
149      * This function call must use less than 30000 gas.
150      */
151     function supportsInterface(bytes4 interfaceId) external view returns (bool);
152 
153     // =============================================================
154     //                            IERC721
155     // =============================================================
156 
157     /**
158      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
159      */
160     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
161 
162     /**
163      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
164      */
165     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
166 
167     /**
168      * @dev Emitted when `owner` enables or disables
169      * (`approved`) `operator` to manage all of its assets.
170      */
171     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
172 
173     /**
174      * @dev Returns the number of tokens in `owner`'s account.
175      */
176     function balanceOf(address owner) external view returns (uint256 balance);
177 
178     /**
179      * @dev Returns the owner of the `tokenId` token.
180      *
181      * Requirements:
182      *
183      * - `tokenId` must exist.
184      */
185     function ownerOf(uint256 tokenId) external view returns (address owner);
186 
187     /**
188      * @dev Safely transfers `tokenId` token from `from` to `to`,
189      * checking first that contract recipients are aware of the ERC721 protocol
190      * to prevent tokens from being forever locked.
191      *
192      * Requirements:
193      *
194      * - `from` cannot be the zero address.
195      * - `to` cannot be the zero address.
196      * - `tokenId` token must exist and be owned by `from`.
197      * - If the caller is not `from`, it must be have been allowed to move
198      * this token by either {approve} or {setApprovalForAll}.
199      * - If `to` refers to a smart contract, it must implement
200      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
201      *
202      * Emits a {Transfer} event.
203      */
204     function safeTransferFrom(
205         address from,
206         address to,
207         uint256 tokenId,
208         bytes calldata data
209     ) external payable;
210 
211     /**
212      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
213      */
214     function safeTransferFrom(
215         address from,
216         address to,
217         uint256 tokenId
218     ) external payable;
219 
220     /**
221      * @dev Transfers `tokenId` from `from` to `to`.
222      *
223      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
224      * whenever possible.
225      *
226      * Requirements:
227      *
228      * - `from` cannot be the zero address.
229      * - `to` cannot be the zero address.
230      * - `tokenId` token must be owned by `from`.
231      * - If the caller is not `from`, it must be approved to move this token
232      * by either {approve} or {setApprovalForAll}.
233      *
234      * Emits a {Transfer} event.
235      */
236     function transferFrom(
237         address from,
238         address to,
239         uint256 tokenId
240     ) external payable;
241 
242     /**
243      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
244      * The approval is cleared when the token is transferred.
245      *
246      * Only a single account can be approved at a time, so approving the
247      * zero address clears previous approvals.
248      *
249      * Requirements:
250      *
251      * - The caller must own the token or be an approved operator.
252      * - `tokenId` must exist.
253      *
254      * Emits an {Approval} event.
255      */
256     function approve(address to, uint256 tokenId) external payable;
257 
258     /**
259      * @dev Approve or remove `operator` as an operator for the caller.
260      * Operators can call {transferFrom} or {safeTransferFrom}
261      * for any token owned by the caller.
262      *
263      * Requirements:
264      *
265      * - The `operator` cannot be the caller.
266      *
267      * Emits an {ApprovalForAll} event.
268      */
269     function setApprovalForAll(address operator, bool _approved) external;
270 
271     /**
272      * @dev Returns the account approved for `tokenId` token.
273      *
274      * Requirements:
275      *
276      * - `tokenId` must exist.
277      */
278     function getApproved(uint256 tokenId) external view returns (address operator);
279 
280     /**
281      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
282      *
283      * See {setApprovalForAll}.
284      */
285     function isApprovedForAll(address owner, address operator) external view returns (bool);
286 
287     // =============================================================
288     //                        IERC721Metadata
289     // =============================================================
290 
291     /**
292      * @dev Returns the token collection name.
293      */
294     function name() external view returns (string memory);
295 
296     /**
297      * @dev Returns the token collection symbol.
298      */
299     function symbol() external view returns (string memory);
300 
301     /**
302      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
303      */
304     function tokenURI(uint256 tokenId) external view returns (string memory);
305 
306     // =============================================================
307     //                           IERC2309
308     // =============================================================
309 
310     /**
311      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
312      * (inclusive) is transferred from `from` to `to`, as defined in the
313      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
314      *
315      * See {_mintERC2309} for more details.
316      */
317     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
318 }
319 
320 
321 
322 
323 /** 
324  *  
325 */
326             
327 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
328 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
329 
330 pragma solidity ^0.8.1;
331 
332 /**
333  * @dev Collection of functions related to the address type
334  */
335 library Address {
336     /**
337      * @dev Returns true if `account` is a contract.
338      *
339      * [////IMPORTANT]
340      * ====
341      * It is unsafe to assume that an address for which this function returns
342      * false is an externally-owned account (EOA) and not a contract.
343      *
344      * Among others, `isContract` will return false for the following
345      * types of addresses:
346      *
347      *  - an externally-owned account
348      *  - a contract in construction
349      *  - an address where a contract will be created
350      *  - an address where a contract lived, but was destroyed
351      * ====
352      *
353      * [IMPORTANT]
354      * ====
355      * You shouldn't rely on `isContract` to protect against flash loan attacks!
356      *
357      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
358      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
359      * constructor.
360      * ====
361      */
362     function isContract(address account) internal view returns (bool) {
363         // This method relies on extcodesize/address.code.length, which returns 0
364         // for contracts in construction, since the code is only stored at the end
365         // of the constructor execution.
366 
367         return account.code.length > 0;
368     }
369 
370     /**
371      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
372      * `recipient`, forwarding all available gas and reverting on errors.
373      *
374      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
375      * of certain opcodes, possibly making contracts go over the 2300 gas limit
376      * imposed by `transfer`, making them unable to receive funds via
377      * `transfer`. {sendValue} removes this limitation.
378      *
379      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
380      *
381      * ////IMPORTANT: because control is transferred to `recipient`, care must be
382      * taken to not create reentrancy vulnerabilities. Consider using
383      * {ReentrancyGuard} or the
384      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
385      */
386     function sendValue(address payable recipient, uint256 amount) internal {
387         require(address(this).balance >= amount, "Address: insufficient balance");
388 
389         (bool success, ) = recipient.call{value: amount}("");
390         require(success, "Address: unable to send value, recipient may have reverted");
391     }
392 
393     /**
394      * @dev Performs a Solidity function call using a low level `call`. A
395      * plain `call` is an unsafe replacement for a function call: use this
396      * function instead.
397      *
398      * If `target` reverts with a revert reason, it is bubbled up by this
399      * function (like regular Solidity function calls).
400      *
401      * Returns the raw returned data. To convert to the expected return value,
402      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
403      *
404      * Requirements:
405      *
406      * - `target` must be a contract.
407      * - calling `target` with `data` must not revert.
408      *
409      * _Available since v3.1._
410      */
411     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
412         return functionCall(target, data, "Address: low-level call failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
417      * `errorMessage` as a fallback revert reason when `target` reverts.
418      *
419      * _Available since v3.1._
420      */
421     function functionCall(
422         address target,
423         bytes memory data,
424         string memory errorMessage
425     ) internal returns (bytes memory) {
426         return functionCallWithValue(target, data, 0, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but also transferring `value` wei to `target`.
432      *
433      * Requirements:
434      *
435      * - the calling contract must have an ETH balance of at least `value`.
436      * - the called Solidity function must be `payable`.
437      *
438      * _Available since v3.1._
439      */
440     function functionCallWithValue(
441         address target,
442         bytes memory data,
443         uint256 value
444     ) internal returns (bytes memory) {
445         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
450      * with `errorMessage` as a fallback revert reason when `target` reverts.
451      *
452      * _Available since v3.1._
453      */
454     function functionCallWithValue(
455         address target,
456         bytes memory data,
457         uint256 value,
458         string memory errorMessage
459     ) internal returns (bytes memory) {
460         require(address(this).balance >= value, "Address: insufficient balance for call");
461         require(isContract(target), "Address: call to non-contract");
462 
463         (bool success, bytes memory returndata) = target.call{value: value}(data);
464         return verifyCallResult(success, returndata, errorMessage);
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
469      * but performing a static call.
470      *
471      * _Available since v3.3._
472      */
473     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
474         return functionStaticCall(target, data, "Address: low-level static call failed");
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
479      * but performing a static call.
480      *
481      * _Available since v3.3._
482      */
483     function functionStaticCall(
484         address target,
485         bytes memory data,
486         string memory errorMessage
487     ) internal view returns (bytes memory) {
488         require(isContract(target), "Address: static call to non-contract");
489 
490         (bool success, bytes memory returndata) = target.staticcall(data);
491         return verifyCallResult(success, returndata, errorMessage);
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
496      * but performing a delegate call.
497      *
498      * _Available since v3.4._
499      */
500     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
501         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
506      * but performing a delegate call.
507      *
508      * _Available since v3.4._
509      */
510     function functionDelegateCall(
511         address target,
512         bytes memory data,
513         string memory errorMessage
514     ) internal returns (bytes memory) {
515         require(isContract(target), "Address: delegate call to non-contract");
516 
517         (bool success, bytes memory returndata) = target.delegatecall(data);
518         return verifyCallResult(success, returndata, errorMessage);
519     }
520 
521     /**
522      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
523      * revert reason using the provided one.
524      *
525      * _Available since v4.3._
526      */
527     function verifyCallResult(
528         bool success,
529         bytes memory returndata,
530         string memory errorMessage
531     ) internal pure returns (bytes memory) {
532         if (success) {
533             return returndata;
534         } else {
535             // Look for revert reason and bubble it up if present
536             if (returndata.length > 0) {
537                 // The easiest way to bubble the revert reason is using memory via assembly
538                 /// @solidity memory-safe-assembly
539                 assembly {
540                     let returndata_size := mload(returndata)
541                     revert(add(32, returndata), returndata_size)
542                 }
543             } else {
544                 revert(errorMessage);
545             }
546         }
547     }
548 }
549 
550 
551 
552 
553 /** 
554  *  
555 */
556             
557 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
558 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @dev These functions deal with verification of Merkle Tree proofs.
564  *
565  * The proofs can be generated using the JavaScript library
566  * https://github.com/miguelmota/merkletreejs[merkletreejs].
567  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
568  *
569  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
570  *
571  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
572  * hashing, or use a hash function other than keccak256 for hashing leaves.
573  * This is because the concatenation of a sorted pair of internal nodes in
574  * the merkle tree could be reinterpreted as a leaf value.
575  */
576 library MerkleProof {
577     /**
578      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
579      * defined by `root`. For this, a `proof` must be provided, containing
580      * sibling hashes on the branch from the leaf to the root of the tree. Each
581      * pair of leaves and each pair of pre-images are assumed to be sorted.
582      */
583     function verify(
584         bytes32[] memory proof,
585         bytes32 root,
586         bytes32 leaf
587     ) internal pure returns (bool) {
588         return processProof(proof, leaf) == root;
589     }
590 
591     /**
592      * @dev Calldata version of {verify}
593      *
594      * _Available since v4.7._
595      */
596     function verifyCalldata(
597         bytes32[] calldata proof,
598         bytes32 root,
599         bytes32 leaf
600     ) internal pure returns (bool) {
601         return processProofCalldata(proof, leaf) == root;
602     }
603 
604     /**
605      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
606      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
607      * hash matches the root of the tree. When processing the proof, the pairs
608      * of leafs & pre-images are assumed to be sorted.
609      *
610      * _Available since v4.4._
611      */
612     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
613         bytes32 computedHash = leaf;
614         for (uint256 i = 0; i < proof.length; i++) {
615             computedHash = _hashPair(computedHash, proof[i]);
616         }
617         return computedHash;
618     }
619 
620     /**
621      * @dev Calldata version of {processProof}
622      *
623      * _Available since v4.7._
624      */
625     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
626         bytes32 computedHash = leaf;
627         for (uint256 i = 0; i < proof.length; i++) {
628             computedHash = _hashPair(computedHash, proof[i]);
629         }
630         return computedHash;
631     }
632 
633     /**
634      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
635      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
636      *
637      * _Available since v4.7._
638      */
639     function multiProofVerify(
640         bytes32[] memory proof,
641         bool[] memory proofFlags,
642         bytes32 root,
643         bytes32[] memory leaves
644     ) internal pure returns (bool) {
645         return processMultiProof(proof, proofFlags, leaves) == root;
646     }
647 
648     /**
649      * @dev Calldata version of {multiProofVerify}
650      *
651      * _Available since v4.7._
652      */
653     function multiProofVerifyCalldata(
654         bytes32[] calldata proof,
655         bool[] calldata proofFlags,
656         bytes32 root,
657         bytes32[] memory leaves
658     ) internal pure returns (bool) {
659         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
660     }
661 
662     /**
663      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
664      * consuming from one or the other at each step according to the instructions given by
665      * `proofFlags`.
666      *
667      * _Available since v4.7._
668      */
669     function processMultiProof(
670         bytes32[] memory proof,
671         bool[] memory proofFlags,
672         bytes32[] memory leaves
673     ) internal pure returns (bytes32 merkleRoot) {
674         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
675         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
676         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
677         // the merkle tree.
678         uint256 leavesLen = leaves.length;
679         uint256 totalHashes = proofFlags.length;
680 
681         // Check proof validity.
682         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
683 
684         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
685         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
686         bytes32[] memory hashes = new bytes32[](totalHashes);
687         uint256 leafPos = 0;
688         uint256 hashPos = 0;
689         uint256 proofPos = 0;
690         // At each step, we compute the next hash using two values:
691         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
692         //   get the next hash.
693         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
694         //   `proof` array.
695         for (uint256 i = 0; i < totalHashes; i++) {
696             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
697             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
698             hashes[i] = _hashPair(a, b);
699         }
700 
701         if (totalHashes > 0) {
702             return hashes[totalHashes - 1];
703         } else if (leavesLen > 0) {
704             return leaves[0];
705         } else {
706             return proof[0];
707         }
708     }
709 
710     /**
711      * @dev Calldata version of {processMultiProof}
712      *
713      * _Available since v4.7._
714      */
715     function processMultiProofCalldata(
716         bytes32[] calldata proof,
717         bool[] calldata proofFlags,
718         bytes32[] memory leaves
719     ) internal pure returns (bytes32 merkleRoot) {
720         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
721         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
722         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
723         // the merkle tree.
724         uint256 leavesLen = leaves.length;
725         uint256 totalHashes = proofFlags.length;
726 
727         // Check proof validity.
728         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
729 
730         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
731         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
732         bytes32[] memory hashes = new bytes32[](totalHashes);
733         uint256 leafPos = 0;
734         uint256 hashPos = 0;
735         uint256 proofPos = 0;
736         // At each step, we compute the next hash using two values:
737         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
738         //   get the next hash.
739         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
740         //   `proof` array.
741         for (uint256 i = 0; i < totalHashes; i++) {
742             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
743             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
744             hashes[i] = _hashPair(a, b);
745         }
746 
747         if (totalHashes > 0) {
748             return hashes[totalHashes - 1];
749         } else if (leavesLen > 0) {
750             return leaves[0];
751         } else {
752             return proof[0];
753         }
754     }
755 
756     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
757         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
758     }
759 
760     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
761         /// @solidity memory-safe-assembly
762         assembly {
763             mstore(0x00, a)
764             mstore(0x20, b)
765             value := keccak256(0x00, 0x40)
766         }
767     }
768 }
769 
770 
771 
772 
773 /** 
774  *  
775 */
776             
777 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
778 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
779 
780 pragma solidity ^0.8.0;
781 
782 ////import "../utils/Context.sol";
783 
784 /**
785  * @dev Contract module which provides a basic access control mechanism, where
786  * there is an account (an owner) that can be granted exclusive access to
787  * specific functions.
788  *
789  * By default, the owner account will be the one that deploys the contract. This
790  * can later be changed with {transferOwnership}.
791  *
792  * This module is used through inheritance. It will make available the modifier
793  * `onlyOwner`, which can be applied to your functions to restrict their use to
794  * the owner.
795  */
796 abstract contract Ownable is Context {
797     address private _owner;
798 
799     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
800 
801     /**
802      * @dev Initializes the contract setting the deployer as the initial owner.
803      */
804     constructor() {
805         _transferOwnership(_msgSender());
806     }
807 
808     /**
809      * @dev Throws if called by any account other than the owner.
810      */
811     modifier onlyOwner() {
812         _checkOwner();
813         _;
814     }
815 
816     /**
817      * @dev Returns the address of the current owner.
818      */
819     function owner() public view virtual returns (address) {
820         return _owner;
821     }
822 
823     /**
824      * @dev Throws if the sender is not the owner.
825      */
826     function _checkOwner() internal view virtual {
827         require(owner() == _msgSender(), "Ownable: caller is not the owner");
828     }
829 
830     /**
831      * @dev Leaves the contract without owner. It will not be possible to call
832      * `onlyOwner` functions anymore. Can only be called by the current owner.
833      *
834      * NOTE: Renouncing ownership will leave the contract without an owner,
835      * thereby removing any functionality that is only available to the owner.
836      */
837     function renounceOwnership() public virtual onlyOwner {
838         _transferOwnership(address(0));
839     }
840 
841     /**
842      * @dev Transfers ownership of the contract to a new account (`newOwner`).
843      * Can only be called by the current owner.
844      */
845     function transferOwnership(address newOwner) public virtual onlyOwner {
846         require(newOwner != address(0), "Ownable: new owner is the zero address");
847         _transferOwnership(newOwner);
848     }
849 
850     /**
851      * @dev Transfers ownership of the contract to a new account (`newOwner`).
852      * Internal function without access restriction.
853      */
854     function _transferOwnership(address newOwner) internal virtual {
855         address oldOwner = _owner;
856         _owner = newOwner;
857         emit OwnershipTransferred(oldOwner, newOwner);
858     }
859 }
860 
861 
862 
863 
864 /** 
865  *  
866 */
867             
868 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
869 // ERC721A Contracts v4.2.3
870 // Creator: Chiru Labs
871 
872 pragma solidity ^0.8.4;
873 
874 ////import './IERC721A.sol';
875 
876 /**
877  * @dev Interface of ERC721 token receiver.
878  */
879 interface ERC721A__IERC721Receiver {
880     function onERC721Received(
881         address operator,
882         address from,
883         uint256 tokenId,
884         bytes calldata data
885     ) external returns (bytes4);
886 }
887 
888 /**
889  * @title ERC721A
890  *
891  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
892  * Non-Fungible Token Standard, including the Metadata extension.
893  * Optimized for lower gas during batch mints.
894  *
895  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
896  * starting from `_startTokenId()`.
897  *
898  * Assumptions:
899  *
900  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
901  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
902  */
903 contract ERC721A is IERC721A {
904     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
905     struct TokenApprovalRef {
906         address value;
907     }
908 
909     // =============================================================
910     //                           CONSTANTS
911     // =============================================================
912 
913     // Mask of an entry in packed address data.
914     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
915 
916     // The bit position of `numberMinted` in packed address data.
917     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
918 
919     // The bit position of `numberBurned` in packed address data.
920     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
921 
922     // The bit position of `aux` in packed address data.
923     uint256 private constant _BITPOS_AUX = 192;
924 
925     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
926     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
927 
928     // The bit position of `startTimestamp` in packed ownership.
929     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
930 
931     // The bit mask of the `burned` bit in packed ownership.
932     uint256 private constant _BITMASK_BURNED = 1 << 224;
933 
934     // The bit position of the `nextInitialized` bit in packed ownership.
935     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
936 
937     // The bit mask of the `nextInitialized` bit in packed ownership.
938     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
939 
940     // The bit position of `extraData` in packed ownership.
941     uint256 private constant _BITPOS_EXTRA_DATA = 232;
942 
943     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
944     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
945 
946     // The mask of the lower 160 bits for addresses.
947     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
948 
949     // The maximum `quantity` that can be minted with {_mintERC2309}.
950     // This limit is to prevent overflows on the address data entries.
951     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
952     // is required to cause an overflow, which is unrealistic.
953     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
954 
955     // The `Transfer` event signature is given by:
956     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
957     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
958         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
959 
960     // =============================================================
961     //                            STORAGE
962     // =============================================================
963 
964     // The next token ID to be minted.
965     uint256 private _currentIndex;
966 
967     // The number of tokens burned.
968     uint256 private _burnCounter;
969 
970     // Token name
971     string private _name;
972 
973     // Token symbol
974     string private _symbol;
975 
976     // Mapping from token ID to ownership details
977     // An empty struct value does not necessarily mean the token is unowned.
978     // See {_packedOwnershipOf} implementation for details.
979     //
980     // Bits Layout:
981     // - [0..159]   `addr`
982     // - [160..223] `startTimestamp`
983     // - [224]      `burned`
984     // - [225]      `nextInitialized`
985     // - [232..255] `extraData`
986     mapping(uint256 => uint256) private _packedOwnerships;
987 
988     // Mapping owner address to address data.
989     //
990     // Bits Layout:
991     // - [0..63]    `balance`
992     // - [64..127]  `numberMinted`
993     // - [128..191] `numberBurned`
994     // - [192..255] `aux`
995     mapping(address => uint256) private _packedAddressData;
996 
997     // Mapping from token ID to approved address.
998     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
999 
1000     // Mapping from owner to operator approvals
1001     mapping(address => mapping(address => bool)) private _operatorApprovals;
1002 
1003     // =============================================================
1004     //                          CONSTRUCTOR
1005     // =============================================================
1006 
1007     constructor(string memory name_, string memory symbol_) {
1008         _name = name_;
1009         _symbol = symbol_;
1010         _currentIndex = _startTokenId();
1011     }
1012 
1013     // =============================================================
1014     //                   TOKEN COUNTING OPERATIONS
1015     // =============================================================
1016 
1017     /**
1018      * @dev Returns the starting token ID.
1019      * To change the starting token ID, please override this function.
1020      */
1021     function _startTokenId() internal view virtual returns (uint256) {
1022         return 0;
1023     }
1024 
1025     /**
1026      * @dev Returns the next token ID to be minted.
1027      */
1028     function _nextTokenId() internal view virtual returns (uint256) {
1029         return _currentIndex;
1030     }
1031 
1032     /**
1033      * @dev Returns the total number of tokens in existence.
1034      * Burned tokens will reduce the count.
1035      * To get the total number of tokens minted, please see {_totalMinted}.
1036      */
1037     function totalSupply() public view virtual override returns (uint256) {
1038         // Counter underflow is impossible as _burnCounter cannot be incremented
1039         // more than `_currentIndex - _startTokenId()` times.
1040         unchecked {
1041             return _currentIndex - _burnCounter - _startTokenId();
1042         }
1043     }
1044 
1045     /**
1046      * @dev Returns the total amount of tokens minted in the contract.
1047      */
1048     function _totalMinted() internal view virtual returns (uint256) {
1049         // Counter underflow is impossible as `_currentIndex` does not decrement,
1050         // and it is initialized to `_startTokenId()`.
1051         unchecked {
1052             return _currentIndex - _startTokenId();
1053         }
1054     }
1055 
1056     /**
1057      * @dev Returns the total number of tokens burned.
1058      */
1059     function _totalBurned() internal view virtual returns (uint256) {
1060         return _burnCounter;
1061     }
1062 
1063     // =============================================================
1064     //                    ADDRESS DATA OPERATIONS
1065     // =============================================================
1066 
1067     /**
1068      * @dev Returns the number of tokens in `owner`'s account.
1069      */
1070     function balanceOf(address owner) public view virtual override returns (uint256) {
1071         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1072         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1073     }
1074 
1075     /**
1076      * Returns the number of tokens minted by `owner`.
1077      */
1078     function _numberMinted(address owner) internal view returns (uint256) {
1079         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1080     }
1081 
1082     /**
1083      * Returns the number of tokens burned by or on behalf of `owner`.
1084      */
1085     function _numberBurned(address owner) internal view returns (uint256) {
1086         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1087     }
1088 
1089     /**
1090      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1091      */
1092     function _getAux(address owner) internal view returns (uint64) {
1093         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1094     }
1095 
1096     /**
1097      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1098      * If there are multiple variables, please pack them into a uint64.
1099      */
1100     function _setAux(address owner, uint64 aux) internal virtual {
1101         uint256 packed = _packedAddressData[owner];
1102         uint256 auxCasted;
1103         // Cast `aux` with assembly to avoid redundant masking.
1104         assembly {
1105             auxCasted := aux
1106         }
1107         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1108         _packedAddressData[owner] = packed;
1109     }
1110 
1111     // =============================================================
1112     //                            IERC165
1113     // =============================================================
1114 
1115     /**
1116      * @dev Returns true if this contract implements the interface defined by
1117      * `interfaceId`. See the corresponding
1118      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1119      * to learn more about how these ids are created.
1120      *
1121      * This function call must use less than 30000 gas.
1122      */
1123     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1124         // The interface IDs are constants representing the first 4 bytes
1125         // of the XOR of all function selectors in the interface.
1126         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1127         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1128         return
1129             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1130             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1131             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1132     }
1133 
1134     // =============================================================
1135     //                        IERC721Metadata
1136     // =============================================================
1137 
1138     /**
1139      * @dev Returns the token collection name.
1140      */
1141     function name() public view virtual override returns (string memory) {
1142         return _name;
1143     }
1144 
1145     /**
1146      * @dev Returns the token collection symbol.
1147      */
1148     function symbol() public view virtual override returns (string memory) {
1149         return _symbol;
1150     }
1151 
1152     /**
1153      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1154      */
1155     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1156         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1157 
1158         string memory baseURI = _baseURI();
1159         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1160     }
1161 
1162     /**
1163      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1164      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1165      * by default, it can be overridden in child contracts.
1166      */
1167     function _baseURI() internal view virtual returns (string memory) {
1168         return '';
1169     }
1170 
1171     // =============================================================
1172     //                     OWNERSHIPS OPERATIONS
1173     // =============================================================
1174 
1175     /**
1176      * @dev Returns the owner of the `tokenId` token.
1177      *
1178      * Requirements:
1179      *
1180      * - `tokenId` must exist.
1181      */
1182     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1183         return address(uint160(_packedOwnershipOf(tokenId)));
1184     }
1185 
1186     /**
1187      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1188      * It gradually moves to O(1) as tokens get transferred around over time.
1189      */
1190     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1191         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1192     }
1193 
1194     /**
1195      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1196      */
1197     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1198         return _unpackedOwnership(_packedOwnerships[index]);
1199     }
1200 
1201     /**
1202      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1203      */
1204     function _initializeOwnershipAt(uint256 index) internal virtual {
1205         if (_packedOwnerships[index] == 0) {
1206             _packedOwnerships[index] = _packedOwnershipOf(index);
1207         }
1208     }
1209 
1210     /**
1211      * Returns the packed ownership data of `tokenId`.
1212      */
1213     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1214         uint256 curr = tokenId;
1215 
1216         unchecked {
1217             if (_startTokenId() <= curr)
1218                 if (curr < _currentIndex) {
1219                     uint256 packed = _packedOwnerships[curr];
1220                     // If not burned.
1221                     if (packed & _BITMASK_BURNED == 0) {
1222                         // Invariant:
1223                         // There will always be an initialized ownership slot
1224                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1225                         // before an unintialized ownership slot
1226                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1227                         // Hence, `curr` will not underflow.
1228                         //
1229                         // We can directly compare the packed value.
1230                         // If the address is zero, packed will be zero.
1231                         while (packed == 0) {
1232                             packed = _packedOwnerships[--curr];
1233                         }
1234                         return packed;
1235                     }
1236                 }
1237         }
1238         revert OwnerQueryForNonexistentToken();
1239     }
1240 
1241     /**
1242      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1243      */
1244     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1245         ownership.addr = address(uint160(packed));
1246         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1247         ownership.burned = packed & _BITMASK_BURNED != 0;
1248         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1249     }
1250 
1251     /**
1252      * @dev Packs ownership data into a single uint256.
1253      */
1254     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1255         assembly {
1256             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1257             owner := and(owner, _BITMASK_ADDRESS)
1258             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1259             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1260         }
1261     }
1262 
1263     /**
1264      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1265      */
1266     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1267         // For branchless setting of the `nextInitialized` flag.
1268         assembly {
1269             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1270             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1271         }
1272     }
1273 
1274     // =============================================================
1275     //                      APPROVAL OPERATIONS
1276     // =============================================================
1277 
1278     /**
1279      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1280      * The approval is cleared when the token is transferred.
1281      *
1282      * Only a single account can be approved at a time, so approving the
1283      * zero address clears previous approvals.
1284      *
1285      * Requirements:
1286      *
1287      * - The caller must own the token or be an approved operator.
1288      * - `tokenId` must exist.
1289      *
1290      * Emits an {Approval} event.
1291      */
1292     function approve(address to, uint256 tokenId) public payable virtual override {
1293         address owner = ownerOf(tokenId);
1294 
1295         if (_msgSenderERC721A() != owner)
1296             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1297                 revert ApprovalCallerNotOwnerNorApproved();
1298             }
1299 
1300         _tokenApprovals[tokenId].value = to;
1301         emit Approval(owner, to, tokenId);
1302     }
1303 
1304     /**
1305      * @dev Returns the account approved for `tokenId` token.
1306      *
1307      * Requirements:
1308      *
1309      * - `tokenId` must exist.
1310      */
1311     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1312         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1313 
1314         return _tokenApprovals[tokenId].value;
1315     }
1316 
1317     /**
1318      * @dev Approve or remove `operator` as an operator for the caller.
1319      * Operators can call {transferFrom} or {safeTransferFrom}
1320      * for any token owned by the caller.
1321      *
1322      * Requirements:
1323      *
1324      * - The `operator` cannot be the caller.
1325      *
1326      * Emits an {ApprovalForAll} event.
1327      */
1328     function setApprovalForAll(address operator, bool approved) public virtual override {
1329         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1330         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1331     }
1332 
1333     /**
1334      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1335      *
1336      * See {setApprovalForAll}.
1337      */
1338     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1339         return _operatorApprovals[owner][operator];
1340     }
1341 
1342     /**
1343      * @dev Returns whether `tokenId` exists.
1344      *
1345      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1346      *
1347      * Tokens start existing when they are minted. See {_mint}.
1348      */
1349     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1350         return
1351             _startTokenId() <= tokenId &&
1352             tokenId < _currentIndex && // If within bounds,
1353             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1354     }
1355 
1356     /**
1357      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1358      */
1359     function _isSenderApprovedOrOwner(
1360         address approvedAddress,
1361         address owner,
1362         address msgSender
1363     ) private pure returns (bool result) {
1364         assembly {
1365             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1366             owner := and(owner, _BITMASK_ADDRESS)
1367             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1368             msgSender := and(msgSender, _BITMASK_ADDRESS)
1369             // `msgSender == owner || msgSender == approvedAddress`.
1370             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1371         }
1372     }
1373 
1374     /**
1375      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1376      */
1377     function _getApprovedSlotAndAddress(uint256 tokenId)
1378         private
1379         view
1380         returns (uint256 approvedAddressSlot, address approvedAddress)
1381     {
1382         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1383         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1384         assembly {
1385             approvedAddressSlot := tokenApproval.slot
1386             approvedAddress := sload(approvedAddressSlot)
1387         }
1388     }
1389 
1390     // =============================================================
1391     //                      TRANSFER OPERATIONS
1392     // =============================================================
1393 
1394     /**
1395      * @dev Transfers `tokenId` from `from` to `to`.
1396      *
1397      * Requirements:
1398      *
1399      * - `from` cannot be the zero address.
1400      * - `to` cannot be the zero address.
1401      * - `tokenId` token must be owned by `from`.
1402      * - If the caller is not `from`, it must be approved to move this token
1403      * by either {approve} or {setApprovalForAll}.
1404      *
1405      * Emits a {Transfer} event.
1406      */
1407     function transferFrom(
1408         address from,
1409         address to,
1410         uint256 tokenId
1411     ) public payable virtual override {
1412         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1413 
1414         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1415 
1416         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1417 
1418         // The nested ifs save around 20+ gas over a compound boolean condition.
1419         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1420             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1421 
1422         if (to == address(0)) revert TransferToZeroAddress();
1423 
1424         _beforeTokenTransfers(from, to, tokenId, 1);
1425 
1426         // Clear approvals from the previous owner.
1427         assembly {
1428             if approvedAddress {
1429                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1430                 sstore(approvedAddressSlot, 0)
1431             }
1432         }
1433 
1434         // Underflow of the sender's balance is impossible because we check for
1435         // ownership above and the recipient's balance can't realistically overflow.
1436         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1437         unchecked {
1438             // We can directly increment and decrement the balances.
1439             --_packedAddressData[from]; // Updates: `balance -= 1`.
1440             ++_packedAddressData[to]; // Updates: `balance += 1`.
1441 
1442             // Updates:
1443             // - `address` to the next owner.
1444             // - `startTimestamp` to the timestamp of transfering.
1445             // - `burned` to `false`.
1446             // - `nextInitialized` to `true`.
1447             _packedOwnerships[tokenId] = _packOwnershipData(
1448                 to,
1449                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1450             );
1451 
1452             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1453             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1454                 uint256 nextTokenId = tokenId + 1;
1455                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1456                 if (_packedOwnerships[nextTokenId] == 0) {
1457                     // If the next slot is within bounds.
1458                     if (nextTokenId != _currentIndex) {
1459                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1460                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1461                     }
1462                 }
1463             }
1464         }
1465 
1466         emit Transfer(from, to, tokenId);
1467         _afterTokenTransfers(from, to, tokenId, 1);
1468     }
1469 
1470     /**
1471      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1472      */
1473     function safeTransferFrom(
1474         address from,
1475         address to,
1476         uint256 tokenId
1477     ) public payable virtual override {
1478         safeTransferFrom(from, to, tokenId, '');
1479     }
1480 
1481     /**
1482      * @dev Safely transfers `tokenId` token from `from` to `to`.
1483      *
1484      * Requirements:
1485      *
1486      * - `from` cannot be the zero address.
1487      * - `to` cannot be the zero address.
1488      * - `tokenId` token must exist and be owned by `from`.
1489      * - If the caller is not `from`, it must be approved to move this token
1490      * by either {approve} or {setApprovalForAll}.
1491      * - If `to` refers to a smart contract, it must implement
1492      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1493      *
1494      * Emits a {Transfer} event.
1495      */
1496     function safeTransferFrom(
1497         address from,
1498         address to,
1499         uint256 tokenId,
1500         bytes memory _data
1501     ) public payable virtual override {
1502         transferFrom(from, to, tokenId);
1503         if (to.code.length != 0)
1504             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1505                 revert TransferToNonERC721ReceiverImplementer();
1506             }
1507     }
1508 
1509     /**
1510      * @dev Hook that is called before a set of serially-ordered token IDs
1511      * are about to be transferred. This includes minting.
1512      * And also called before burning one token.
1513      *
1514      * `startTokenId` - the first token ID to be transferred.
1515      * `quantity` - the amount to be transferred.
1516      *
1517      * Calling conditions:
1518      *
1519      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1520      * transferred to `to`.
1521      * - When `from` is zero, `tokenId` will be minted for `to`.
1522      * - When `to` is zero, `tokenId` will be burned by `from`.
1523      * - `from` and `to` are never both zero.
1524      */
1525     function _beforeTokenTransfers(
1526         address from,
1527         address to,
1528         uint256 startTokenId,
1529         uint256 quantity
1530     ) internal virtual {}
1531 
1532     /**
1533      * @dev Hook that is called after a set of serially-ordered token IDs
1534      * have been transferred. This includes minting.
1535      * And also called after one token has been burned.
1536      *
1537      * `startTokenId` - the first token ID to be transferred.
1538      * `quantity` - the amount to be transferred.
1539      *
1540      * Calling conditions:
1541      *
1542      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1543      * transferred to `to`.
1544      * - When `from` is zero, `tokenId` has been minted for `to`.
1545      * - When `to` is zero, `tokenId` has been burned by `from`.
1546      * - `from` and `to` are never both zero.
1547      */
1548     function _afterTokenTransfers(
1549         address from,
1550         address to,
1551         uint256 startTokenId,
1552         uint256 quantity
1553     ) internal virtual {}
1554 
1555     /**
1556      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1557      *
1558      * `from` - Previous owner of the given token ID.
1559      * `to` - Target address that will receive the token.
1560      * `tokenId` - Token ID to be transferred.
1561      * `_data` - Optional data to send along with the call.
1562      *
1563      * Returns whether the call correctly returned the expected magic value.
1564      */
1565     function _checkContractOnERC721Received(
1566         address from,
1567         address to,
1568         uint256 tokenId,
1569         bytes memory _data
1570     ) private returns (bool) {
1571         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1572             bytes4 retval
1573         ) {
1574             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1575         } catch (bytes memory reason) {
1576             if (reason.length == 0) {
1577                 revert TransferToNonERC721ReceiverImplementer();
1578             } else {
1579                 assembly {
1580                     revert(add(32, reason), mload(reason))
1581                 }
1582             }
1583         }
1584     }
1585 
1586     // =============================================================
1587     //                        MINT OPERATIONS
1588     // =============================================================
1589 
1590     /**
1591      * @dev Mints `quantity` tokens and transfers them to `to`.
1592      *
1593      * Requirements:
1594      *
1595      * - `to` cannot be the zero address.
1596      * - `quantity` must be greater than 0.
1597      *
1598      * Emits a {Transfer} event for each mint.
1599      */
1600     function _mint(address to, uint256 quantity) internal virtual {
1601         uint256 startTokenId = _currentIndex;
1602         if (quantity == 0) revert MintZeroQuantity();
1603 
1604         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1605 
1606         // Overflows are incredibly unrealistic.
1607         // `balance` and `numberMinted` have a maximum limit of 2**64.
1608         // `tokenId` has a maximum limit of 2**256.
1609         unchecked {
1610             // Updates:
1611             // - `balance += quantity`.
1612             // - `numberMinted += quantity`.
1613             //
1614             // We can directly add to the `balance` and `numberMinted`.
1615             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1616 
1617             // Updates:
1618             // - `address` to the owner.
1619             // - `startTimestamp` to the timestamp of minting.
1620             // - `burned` to `false`.
1621             // - `nextInitialized` to `quantity == 1`.
1622             _packedOwnerships[startTokenId] = _packOwnershipData(
1623                 to,
1624                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1625             );
1626 
1627             uint256 toMasked;
1628             uint256 end = startTokenId + quantity;
1629 
1630             // Use assembly to loop and emit the `Transfer` event for gas savings.
1631             // The duplicated `log4` removes an extra check and reduces stack juggling.
1632             // The assembly, together with the surrounding Solidity code, have been
1633             // delicately arranged to nudge the compiler into producing optimized opcodes.
1634             assembly {
1635                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1636                 toMasked := and(to, _BITMASK_ADDRESS)
1637                 // Emit the `Transfer` event.
1638                 log4(
1639                     0, // Start of data (0, since no data).
1640                     0, // End of data (0, since no data).
1641                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1642                     0, // `address(0)`.
1643                     toMasked, // `to`.
1644                     startTokenId // `tokenId`.
1645                 )
1646 
1647                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1648                 // that overflows uint256 will make the loop run out of gas.
1649                 // The compiler will optimize the `iszero` away for performance.
1650                 for {
1651                     let tokenId := add(startTokenId, 1)
1652                 } iszero(eq(tokenId, end)) {
1653                     tokenId := add(tokenId, 1)
1654                 } {
1655                     // Emit the `Transfer` event. Similar to above.
1656                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1657                 }
1658             }
1659             if (toMasked == 0) revert MintToZeroAddress();
1660 
1661             _currentIndex = end;
1662         }
1663         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1664     }
1665 
1666     /**
1667      * @dev Mints `quantity` tokens and transfers them to `to`.
1668      *
1669      * This function is intended for efficient minting only during contract creation.
1670      *
1671      * It emits only one {ConsecutiveTransfer} as defined in
1672      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1673      * instead of a sequence of {Transfer} event(s).
1674      *
1675      * Calling this function outside of contract creation WILL make your contract
1676      * non-compliant with the ERC721 standard.
1677      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1678      * {ConsecutiveTransfer} event is only permissible during contract creation.
1679      *
1680      * Requirements:
1681      *
1682      * - `to` cannot be the zero address.
1683      * - `quantity` must be greater than 0.
1684      *
1685      * Emits a {ConsecutiveTransfer} event.
1686      */
1687     function _mintERC2309(address to, uint256 quantity) internal virtual {
1688         uint256 startTokenId = _currentIndex;
1689         if (to == address(0)) revert MintToZeroAddress();
1690         if (quantity == 0) revert MintZeroQuantity();
1691         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1692 
1693         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1694 
1695         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1696         unchecked {
1697             // Updates:
1698             // - `balance += quantity`.
1699             // - `numberMinted += quantity`.
1700             //
1701             // We can directly add to the `balance` and `numberMinted`.
1702             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1703 
1704             // Updates:
1705             // - `address` to the owner.
1706             // - `startTimestamp` to the timestamp of minting.
1707             // - `burned` to `false`.
1708             // - `nextInitialized` to `quantity == 1`.
1709             _packedOwnerships[startTokenId] = _packOwnershipData(
1710                 to,
1711                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1712             );
1713 
1714             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1715 
1716             _currentIndex = startTokenId + quantity;
1717         }
1718         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1719     }
1720 
1721     /**
1722      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1723      *
1724      * Requirements:
1725      *
1726      * - If `to` refers to a smart contract, it must implement
1727      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1728      * - `quantity` must be greater than 0.
1729      *
1730      * See {_mint}.
1731      *
1732      * Emits a {Transfer} event for each mint.
1733      */
1734     function _safeMint(
1735         address to,
1736         uint256 quantity,
1737         bytes memory _data
1738     ) internal virtual {
1739         _mint(to, quantity);
1740 
1741         unchecked {
1742             if (to.code.length != 0) {
1743                 uint256 end = _currentIndex;
1744                 uint256 index = end - quantity;
1745                 do {
1746                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1747                         revert TransferToNonERC721ReceiverImplementer();
1748                     }
1749                 } while (index < end);
1750                 // Reentrancy protection.
1751                 if (_currentIndex != end) revert();
1752             }
1753         }
1754     }
1755 
1756     /**
1757      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1758      */
1759     function _safeMint(address to, uint256 quantity) internal virtual {
1760         _safeMint(to, quantity, '');
1761     }
1762 
1763     // =============================================================
1764     //                        BURN OPERATIONS
1765     // =============================================================
1766 
1767     /**
1768      * @dev Equivalent to `_burn(tokenId, false)`.
1769      */
1770     function _burn(uint256 tokenId) internal virtual {
1771         _burn(tokenId, false);
1772     }
1773 
1774     /**
1775      * @dev Destroys `tokenId`.
1776      * The approval is cleared when the token is burned.
1777      *
1778      * Requirements:
1779      *
1780      * - `tokenId` must exist.
1781      *
1782      * Emits a {Transfer} event.
1783      */
1784     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1785         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1786 
1787         address from = address(uint160(prevOwnershipPacked));
1788 
1789         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1790 
1791         if (approvalCheck) {
1792             // The nested ifs save around 20+ gas over a compound boolean condition.
1793             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1794                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1795         }
1796 
1797         _beforeTokenTransfers(from, address(0), tokenId, 1);
1798 
1799         // Clear approvals from the previous owner.
1800         assembly {
1801             if approvedAddress {
1802                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1803                 sstore(approvedAddressSlot, 0)
1804             }
1805         }
1806 
1807         // Underflow of the sender's balance is impossible because we check for
1808         // ownership above and the recipient's balance can't realistically overflow.
1809         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1810         unchecked {
1811             // Updates:
1812             // - `balance -= 1`.
1813             // - `numberBurned += 1`.
1814             //
1815             // We can directly decrement the balance, and increment the number burned.
1816             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1817             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1818 
1819             // Updates:
1820             // - `address` to the last owner.
1821             // - `startTimestamp` to the timestamp of burning.
1822             // - `burned` to `true`.
1823             // - `nextInitialized` to `true`.
1824             _packedOwnerships[tokenId] = _packOwnershipData(
1825                 from,
1826                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1827             );
1828 
1829             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1830             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1831                 uint256 nextTokenId = tokenId + 1;
1832                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1833                 if (_packedOwnerships[nextTokenId] == 0) {
1834                     // If the next slot is within bounds.
1835                     if (nextTokenId != _currentIndex) {
1836                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1837                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1838                     }
1839                 }
1840             }
1841         }
1842 
1843         emit Transfer(from, address(0), tokenId);
1844         _afterTokenTransfers(from, address(0), tokenId, 1);
1845 
1846         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1847         unchecked {
1848             _burnCounter++;
1849         }
1850     }
1851 
1852     // =============================================================
1853     //                     EXTRA DATA OPERATIONS
1854     // =============================================================
1855 
1856     /**
1857      * @dev Directly sets the extra data for the ownership data `index`.
1858      */
1859     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1860         uint256 packed = _packedOwnerships[index];
1861         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1862         uint256 extraDataCasted;
1863         // Cast `extraData` with assembly to avoid redundant masking.
1864         assembly {
1865             extraDataCasted := extraData
1866         }
1867         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1868         _packedOwnerships[index] = packed;
1869     }
1870 
1871     /**
1872      * @dev Called during each token transfer to set the 24bit `extraData` field.
1873      * Intended to be overridden by the cosumer contract.
1874      *
1875      * `previousExtraData` - the value of `extraData` before transfer.
1876      *
1877      * Calling conditions:
1878      *
1879      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1880      * transferred to `to`.
1881      * - When `from` is zero, `tokenId` will be minted for `to`.
1882      * - When `to` is zero, `tokenId` will be burned by `from`.
1883      * - `from` and `to` are never both zero.
1884      */
1885     function _extraData(
1886         address from,
1887         address to,
1888         uint24 previousExtraData
1889     ) internal view virtual returns (uint24) {}
1890 
1891     /**
1892      * @dev Returns the next extra data for the packed ownership data.
1893      * The returned result is shifted into position.
1894      */
1895     function _nextExtraData(
1896         address from,
1897         address to,
1898         uint256 prevOwnershipPacked
1899     ) private view returns (uint256) {
1900         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1901         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1902     }
1903 
1904     // =============================================================
1905     //                       OTHER OPERATIONS
1906     // =============================================================
1907 
1908     /**
1909      * @dev Returns the message sender (defaults to `msg.sender`).
1910      *
1911      * If you are writing GSN compatible contracts, you need to override this function.
1912      */
1913     function _msgSenderERC721A() internal view virtual returns (address) {
1914         return msg.sender;
1915     }
1916 
1917     /**
1918      * @dev Converts a uint256 to its ASCII string decimal representation.
1919      */
1920     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1921         assembly {
1922             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1923             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1924             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1925             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1926             let m := add(mload(0x40), 0xa0)
1927             // Update the free memory pointer to allocate.
1928             mstore(0x40, m)
1929             // Assign the `str` to the end.
1930             str := sub(m, 0x20)
1931             // Zeroize the slot after the string.
1932             mstore(str, 0)
1933 
1934             // Cache the end of the memory to calculate the length later.
1935             let end := str
1936 
1937             // We write the string from rightmost digit to leftmost digit.
1938             // The following is essentially a do-while loop that also handles the zero case.
1939             // prettier-ignore
1940             for { let temp := value } 1 {} {
1941                 str := sub(str, 1)
1942                 // Write the character to the pointer.
1943                 // The ASCII index of the '0' character is 48.
1944                 mstore8(str, add(48, mod(temp, 10)))
1945                 // Keep dividing `temp` until zero.
1946                 temp := div(temp, 10)
1947                 // prettier-ignore
1948                 if iszero(temp) { break }
1949             }
1950 
1951             let length := sub(end, str)
1952             // Move the pointer 32 bytes leftwards to make room for the length.
1953             str := sub(str, 0x20)
1954             // Store the length.
1955             mstore(str, length)
1956         }
1957     }
1958 }
1959 
1960 
1961 /** 
1962  *  
1963 */
1964 
1965 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1966 pragma solidity ^0.8.7;
1967 
1968 ////import "erc721a/contracts/ERC721A.sol";
1969 
1970 ////import "@openzeppelin/contracts/access/Ownable.sol";
1971 ////import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
1972 ////import "@openzeppelin/contracts/utils/Address.sol";
1973 
1974 contract MeltedFacesReshape is ERC721A, Ownable {
1975     constructor() ERC721A("MeLtEd FaCeS rEsHaPe", "mFrS") {}
1976 
1977 	mapping(address => uint256) public minted;
1978 
1979 	bytes32 public merkleRoot;
1980 
1981 	uint256 public price = 0.0055 ether;
1982 	uint256 public maxQuantity = 5;
1983 	uint256 public maxSupply = 4444;
1984 
1985 	bool public publicSale = false;
1986 	bool public whitelistSale = false;
1987 
1988 	string baseUri = "";
1989 	string tokenUriSuffix;
1990 
1991 	// Public payable functions
1992 	function whitelistMint(uint256 quantity, bytes32[] calldata proof) external payable {
1993 		require(whitelistSale, "whitelist not active");
1994 
1995 		require(totalSupply() + quantity <= maxSupply, "max supply exceeded");
1996 		require(quantity <= maxQuantity, "too many");
1997 		require(msg.value >= price * quantity, "insufficient value");
1998 		require(minted[msg.sender] + quantity <= maxQuantity, "already minted max");
1999 
2000 		bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2001 		require(MerkleProof.verify(proof, merkleRoot, leaf), 'not whitelisted');
2002 
2003 		minted[msg.sender] = quantity;
2004 
2005 		_safeMint(msg.sender, quantity);
2006 	}
2007 
2008     function mint(uint256 quantity) external payable {
2009 		// Special owner mint case
2010 		if (owner() == msg.sender) {
2011 			require(totalSupply() + quantity <= maxSupply, "max supply exceeded");
2012 
2013 			_safeMint(msg.sender, quantity);
2014 
2015 			return;
2016 		}
2017 
2018 		require(publicSale, "sale not active");
2019 
2020 		require(totalSupply() + quantity <= maxSupply, "max supply exceeded");
2021 		require(quantity <= maxQuantity, "too many");
2022 		require(msg.value >= price * quantity, "insufficient value");
2023 		require(minted[msg.sender] + quantity <= maxQuantity, "already minted max");
2024 
2025 		minted[msg.sender] = quantity;
2026 
2027         _safeMint(msg.sender, quantity);
2028     }
2029 
2030 	// View functions
2031 	function _baseURI() internal view virtual override returns (string memory) {
2032         return baseUri;
2033     }
2034 
2035     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2036         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2037 
2038         string memory baseURI = _baseURI();
2039         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), tokenUriSuffix)) : '';
2040     }
2041 
2042 	// Admin functions
2043 	function setPrice(uint256 new_price) external onlyOwner {
2044 		price = new_price;
2045 	}
2046 
2047 	function setMaxQuantity(uint256 new_max_quantity) external onlyOwner {
2048 		maxQuantity = new_max_quantity;
2049 	}
2050 
2051 	function setMerkleRoot(bytes32 merkle_root) external onlyOwner {
2052 		merkleRoot = merkle_root;
2053 	}
2054 
2055 	function setSaleActive(bool sale_active) external onlyOwner {
2056 		publicSale = sale_active;
2057 	}
2058 
2059 	function setWhitelistActive(bool wl_active) external onlyOwner {
2060 		whitelistSale = wl_active;
2061 	}
2062 
2063 	function setBaseUri(string calldata base_uri) external onlyOwner {
2064 		baseUri = base_uri;
2065 	}
2066 
2067 	function setUriSuffix(string calldata uri_suffix) external onlyOwner {
2068 		tokenUriSuffix = uri_suffix;
2069 	}
2070 	
2071 	function setMaxSupply(uint max_supply) external onlyOwner {
2072 		require(max_supply >= totalSupply(), "Specified supply is lower than current balance" );
2073 		maxSupply = max_supply;
2074 	}
2075 
2076 	// Admin actions
2077 	function gift(uint[] calldata quantity, address[] calldata recipient) external onlyOwner {
2078 		require(quantity.length == recipient.length, "Must provide equal quantities and recipients" );
2079 
2080 		uint totalQuantity = 0;
2081 		uint256 supply = totalSupply();
2082 		for(uint i = 0; i < quantity.length; ++i){
2083 			totalQuantity += quantity[i];
2084 		}
2085 		require( supply + totalQuantity <= maxSupply, "Mint/order exceeds supply" );
2086 		delete totalQuantity;
2087 
2088 		for(uint i = 0; i < recipient.length; ++i){
2089 			_safeMint(recipient[i], quantity[i]);
2090 		}
2091 	}
2092 
2093 	function withdraw() external onlyOwner {
2094 		Address.sendValue(payable(owner()), address(this).balance);
2095 	}
2096 }