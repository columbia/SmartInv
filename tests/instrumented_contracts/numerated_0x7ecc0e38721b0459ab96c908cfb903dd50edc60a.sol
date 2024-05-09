1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev These functions deal with verification of Merkle Tree proofs.
8  *
9  * The proofs can be generated using the JavaScript library
10  * https://github.com/miguelmota/merkletreejs[merkletreejs].
11  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
12  *
13  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
14  *
15  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
16  * hashing, or use a hash function other than keccak256 for hashing leaves.
17  * This is because the concatenation of a sorted pair of internal nodes in
18  * the merkle tree could be reinterpreted as a leaf value.
19  */
20 library MerkleProof {
21     /**
22      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
23      * defined by `root`. For this, a `proof` must be provided, containing
24      * sibling hashes on the branch from the leaf to the root of the tree. Each
25      * pair of leaves and each pair of pre-images are assumed to be sorted.
26      */
27     function verify(
28         bytes32[] memory proof,
29         bytes32 root,
30         bytes32 leaf
31     ) internal pure returns (bool) {
32         return processProof(proof, leaf) == root;
33     }
34 
35     /**
36      * @dev Calldata version of {verify}
37      *
38      * _Available since v4.7._
39      */
40     function verifyCalldata(
41         bytes32[] calldata proof,
42         bytes32 root,
43         bytes32 leaf
44     ) internal pure returns (bool) {
45         return processProofCalldata(proof, leaf) == root;
46     }
47 
48     /**
49      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
50      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
51      * hash matches the root of the tree. When processing the proof, the pairs
52      * of leafs & pre-images are assumed to be sorted.
53      *
54      * _Available since v4.4._
55      */
56     function processProof(bytes32[] memory proof, bytes32 leaf)
57         internal
58         pure
59         returns (bytes32)
60     {
61         bytes32 computedHash = leaf;
62         for (uint256 i = 0; i < proof.length; i++) {
63             computedHash = _hashPair(computedHash, proof[i]);
64         }
65         return computedHash;
66     }
67 
68     /**
69      * @dev Calldata version of {processProof}
70      *
71      * _Available since v4.7._
72      */
73     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf)
74         internal
75         pure
76         returns (bytes32)
77     {
78         bytes32 computedHash = leaf;
79         for (uint256 i = 0; i < proof.length; i++) {
80             computedHash = _hashPair(computedHash, proof[i]);
81         }
82         return computedHash;
83     }
84 
85     /**
86      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
87      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
88      *
89      * _Available since v4.7._
90      */
91     function multiProofVerify(
92         bytes32[] memory proof,
93         bool[] memory proofFlags,
94         bytes32 root,
95         bytes32[] memory leaves
96     ) internal pure returns (bool) {
97         return processMultiProof(proof, proofFlags, leaves) == root;
98     }
99 
100     /**
101      * @dev Calldata version of {multiProofVerify}
102      *
103      * _Available since v4.7._
104      */
105     function multiProofVerifyCalldata(
106         bytes32[] calldata proof,
107         bool[] calldata proofFlags,
108         bytes32 root,
109         bytes32[] memory leaves
110     ) internal pure returns (bool) {
111         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
112     }
113 
114     /**
115      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
116      * consuming from one or the other at each step according to the instructions given by
117      * `proofFlags`.
118      *
119      * _Available since v4.7._
120      */
121     function processMultiProof(
122         bytes32[] memory proof,
123         bool[] memory proofFlags,
124         bytes32[] memory leaves
125     ) internal pure returns (bytes32 merkleRoot) {
126         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
127         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
128         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
129         // the merkle tree.
130         uint256 leavesLen = leaves.length;
131         uint256 totalHashes = proofFlags.length;
132 
133         // Check proof validity.
134         require(
135             leavesLen + proof.length - 1 == totalHashes,
136             "MerkleProof: invalid multiproof"
137         );
138 
139         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
140         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
141         bytes32[] memory hashes = new bytes32[](totalHashes);
142         uint256 leafPos = 0;
143         uint256 hashPos = 0;
144         uint256 proofPos = 0;
145         // At each step, we compute the next hash using two values:
146         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
147         //   get the next hash.
148         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
149         //   `proof` array.
150         for (uint256 i = 0; i < totalHashes; i++) {
151             bytes32 a = leafPos < leavesLen
152                 ? leaves[leafPos++]
153                 : hashes[hashPos++];
154             bytes32 b = proofFlags[i]
155                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
156                 : proof[proofPos++];
157             hashes[i] = _hashPair(a, b);
158         }
159 
160         if (totalHashes > 0) {
161             return hashes[totalHashes - 1];
162         } else if (leavesLen > 0) {
163             return leaves[0];
164         } else {
165             return proof[0];
166         }
167     }
168 
169     /**
170      * @dev Calldata version of {processMultiProof}
171      *
172      * _Available since v4.7._
173      */
174     function processMultiProofCalldata(
175         bytes32[] calldata proof,
176         bool[] calldata proofFlags,
177         bytes32[] memory leaves
178     ) internal pure returns (bytes32 merkleRoot) {
179         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
180         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
181         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
182         // the merkle tree.
183         uint256 leavesLen = leaves.length;
184         uint256 totalHashes = proofFlags.length;
185 
186         // Check proof validity.
187         require(
188             leavesLen + proof.length - 1 == totalHashes,
189             "MerkleProof: invalid multiproof"
190         );
191 
192         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
193         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
194         bytes32[] memory hashes = new bytes32[](totalHashes);
195         uint256 leafPos = 0;
196         uint256 hashPos = 0;
197         uint256 proofPos = 0;
198         // At each step, we compute the next hash using two values:
199         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
200         //   get the next hash.
201         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
202         //   `proof` array.
203         for (uint256 i = 0; i < totalHashes; i++) {
204             bytes32 a = leafPos < leavesLen
205                 ? leaves[leafPos++]
206                 : hashes[hashPos++];
207             bytes32 b = proofFlags[i]
208                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
209                 : proof[proofPos++];
210             hashes[i] = _hashPair(a, b);
211         }
212 
213         if (totalHashes > 0) {
214             return hashes[totalHashes - 1];
215         } else if (leavesLen > 0) {
216             return leaves[0];
217         } else {
218             return proof[0];
219         }
220     }
221 
222     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
223         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
224     }
225 
226     function _efficientHash(bytes32 a, bytes32 b)
227         private
228         pure
229         returns (bytes32 value)
230     {
231         /// @solidity memory-safe-assembly
232         assembly {
233             mstore(0x00, a)
234             mstore(0x20, b)
235             value := keccak256(0x00, 0x40)
236         }
237     }
238 }
239 
240 /**
241  * @dev Interface of the ERC165 standard, as defined in the
242  * https://eips.ethereum.org/EIPS/eip-165[EIP].
243  *
244  * Implementers can declare support of contract interfaces, which can then be
245  * queried by others ({ERC165Checker}).
246  *
247  * For an implementation, see {ERC165}.
248  */
249 interface IERC165 {
250     /**
251      * @dev Returns true if this contract implements the interface defined by
252      * `interfaceId`. See the corresponding
253      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
254      * to learn more about how these ids are created.
255      *
256      * This function call must use less than 30 000 gas.
257      */
258     function supportsInterface(bytes4 interfaceId) external view returns (bool);
259 }
260 
261 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
262 
263 /**
264  * @dev Required interface of an ERC721 compliant contract.
265  */
266 interface IERC721 is IERC165 {
267     /**
268      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
269      */
270     event Transfer(
271         address indexed from,
272         address indexed to,
273         uint256 indexed tokenId
274     );
275 
276     /**
277      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
278      */
279     event Approval(
280         address indexed owner,
281         address indexed approved,
282         uint256 indexed tokenId
283     );
284 
285     /**
286      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
287      */
288     event ApprovalForAll(
289         address indexed owner,
290         address indexed operator,
291         bool approved
292     );
293 
294     /**
295      * @dev Returns the number of tokens in ``owner``'s account.
296      */
297     function balanceOf(address owner) external view returns (uint256 balance);
298 
299     /**
300      * @dev Returns the owner of the `tokenId` token.
301      *
302      * Requirements:
303      *
304      * - `tokenId` must exist.
305      */
306     function ownerOf(uint256 tokenId) external view returns (address owner);
307 
308     /**
309      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
310      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
311      *
312      * Requirements:
313      *
314      * - `from` cannot be the zero address.
315      * - `to` cannot be the zero address.
316      * - `tokenId` token must exist and be owned by `from`.
317      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
318      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
319      *
320      * Emits a {Transfer} event.
321      */
322     function safeTransferFrom(
323         address from,
324         address to,
325         uint256 tokenId
326     ) external;
327 
328     /**
329      * @dev Transfers `tokenId` token from `from` to `to`.
330      *
331      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
332      *
333      * Requirements:
334      *
335      * - `from` cannot be the zero address.
336      * - `to` cannot be the zero address.
337      * - `tokenId` token must be owned by `from`.
338      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
339      *
340      * Emits a {Transfer} event.
341      */
342     function transferFrom(
343         address from,
344         address to,
345         uint256 tokenId
346     ) external;
347 
348     /**
349      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
350      * The approval is cleared when the token is transferred.
351      *
352      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
353      *
354      * Requirements:
355      *
356      * - The caller must own the token or be an approved operator.
357      * - `tokenId` must exist.
358      *
359      * Emits an {Approval} event.
360      */
361     function approve(address to, uint256 tokenId) external;
362 
363     /**
364      * @dev Returns the account approved for `tokenId` token.
365      *
366      * Requirements:
367      *
368      * - `tokenId` must exist.
369      */
370     function getApproved(uint256 tokenId)
371         external
372         view
373         returns (address operator);
374 
375     /**
376      * @dev Approve or remove `operator` as an operator for the caller.
377      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
378      *
379      * Requirements:
380      *
381      * - The `operator` cannot be the caller.
382      *
383      * Emits an {ApprovalForAll} event.
384      */
385     function setApprovalForAll(address operator, bool _approved) external;
386 
387     /**
388      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
389      *
390      * See {setApprovalForAll}
391      */
392     function isApprovedForAll(address owner, address operator)
393         external
394         view
395         returns (bool);
396 
397     /**
398      * @dev Safely transfers `tokenId` token from `from` to `to`.
399      *
400      * Requirements:
401      *
402      * - `from` cannot be the zero address.
403      * - `to` cannot be the zero address.
404      * - `tokenId` token must exist and be owned by `from`.
405      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
406      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
407      *
408      * Emits a {Transfer} event.
409      */
410     function safeTransferFrom(
411         address from,
412         address to,
413         uint256 tokenId,
414         bytes calldata data
415     ) external;
416 }
417 
418 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
419 
420 /**
421  * @title ERC721 token receiver interface
422  * @dev Interface for any contract that wants to support safeTransfers
423  * from ERC721 asset contracts.
424  */
425 interface IERC721Receiver {
426     /**
427      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
428      * by `operator` from `from`, this function is called.
429      *
430      * It must return its Solidity selector to confirm the token transfer.
431      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
432      *
433      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
434      */
435     function onERC721Received(
436         address operator,
437         address from,
438         uint256 tokenId,
439         bytes calldata data
440     ) external returns (bytes4);
441 }
442 
443 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
444 
445 /**
446  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
447  * @dev See https://eips.ethereum.org/EIPS/eip-721
448  */
449 interface IERC721Metadata is IERC721 {
450     /**
451      * @dev Returns the token collection name.
452      */
453     function name() external view returns (string memory);
454 
455     /**
456      * @dev Returns the token collection symbol.
457      */
458     function symbol() external view returns (string memory);
459 
460     /**
461      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
462      */
463     function tokenURI(uint256 tokenId) external view returns (string memory);
464 }
465 
466 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
467 
468 /**
469  * @dev Implementation of the {IERC165} interface.
470  *
471  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
472  * for the additional interface id that will be supported. For example:
473  *
474  * ```solidity
475  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
476  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
477  * }
478  * ```
479  *
480  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
481  */
482 abstract contract ERC165 is IERC165 {
483     /**
484      * @dev See {IERC165-supportsInterface}.
485      */
486     function supportsInterface(bytes4 interfaceId)
487         public
488         view
489         virtual
490         override
491         returns (bool)
492     {
493         return interfaceId == type(IERC165).interfaceId;
494     }
495 }
496 
497 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
498 
499 /**
500  * @dev Collection of functions related to the address type
501  */
502 library Address {
503     /**
504      * @dev Returns true if `account` is a contract.
505      *
506      * [IMPORTANT]
507      * ====
508      * It is unsafe to assume that an address for which this function returns
509      * false is an externally-owned account (EOA) and not a contract.
510      *
511      * Among others, `isContract` will return false for the following
512      * types of addresses:
513      *
514      *  - an externally-owned account
515      *  - a contract in construction
516      *  - an address where a contract will be created
517      *  - an address where a contract lived, but was destroyed
518      * ====
519      */
520     function isContract(address account) internal view returns (bool) {
521         // This method relies on extcodesize, which returns 0 for contracts in
522         // construction, since the code is only stored at the end of the
523         // constructor execution.
524 
525         uint256 size;
526         assembly {
527             size := extcodesize(account)
528         }
529         return size > 0;
530     }
531 
532     /**
533      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
534      * `recipient`, forwarding all available gas and reverting on errors.
535      *
536      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
537      * of certain opcodes, possibly making contracts go over the 2300 gas limit
538      * imposed by `transfer`, making them unable to receive funds via
539      * `transfer`. {sendValue} removes this limitation.
540      *
541      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
542      *
543      * IMPORTANT: because control is transferred to `recipient`, care must be
544      * taken to not create reentrancy vulnerabilities. Consider using
545      * {ReentrancyGuard} or the
546      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
547      */
548     function sendValue(address payable recipient, uint256 amount) internal {
549         require(
550             address(this).balance >= amount,
551             "Address: insufficient balance"
552         );
553 
554         (bool success, ) = recipient.call{value: amount}("");
555         require(
556             success,
557             "Address: unable to send value, recipient may have reverted"
558         );
559     }
560 
561     /**
562      * @dev Performs a Solidity function call using a low level `call`. A
563      * plain `call` is an unsafe replacement for a function call: use this
564      * function instead.
565      *
566      * If `target` reverts with a revert reason, it is bubbled up by this
567      * function (like regular Solidity function calls).
568      *
569      * Returns the raw returned data. To convert to the expected return value,
570      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
571      *
572      * Requirements:
573      *
574      * - `target` must be a contract.
575      * - calling `target` with `data` must not revert.
576      *
577      * _Available since v3.1._
578      */
579     function functionCall(address target, bytes memory data)
580         internal
581         returns (bytes memory)
582     {
583         return functionCall(target, data, "Address: low-level call failed");
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
588      * `errorMessage` as a fallback revert reason when `target` reverts.
589      *
590      * _Available since v3.1._
591      */
592     function functionCall(
593         address target,
594         bytes memory data,
595         string memory errorMessage
596     ) internal returns (bytes memory) {
597         return functionCallWithValue(target, data, 0, errorMessage);
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
602      * but also transferring `value` wei to `target`.
603      *
604      * Requirements:
605      *
606      * - the calling contract must have an ETH balance of at least `value`.
607      * - the called Solidity function must be `payable`.
608      *
609      * _Available since v3.1._
610      */
611     function functionCallWithValue(
612         address target,
613         bytes memory data,
614         uint256 value
615     ) internal returns (bytes memory) {
616         return
617             functionCallWithValue(
618                 target,
619                 data,
620                 value,
621                 "Address: low-level call with value failed"
622             );
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
627      * with `errorMessage` as a fallback revert reason when `target` reverts.
628      *
629      * _Available since v3.1._
630      */
631     function functionCallWithValue(
632         address target,
633         bytes memory data,
634         uint256 value,
635         string memory errorMessage
636     ) internal returns (bytes memory) {
637         require(
638             address(this).balance >= value,
639             "Address: insufficient balance for call"
640         );
641         require(isContract(target), "Address: call to non-contract");
642 
643         (bool success, bytes memory returndata) = target.call{value: value}(
644             data
645         );
646         return verifyCallResult(success, returndata, errorMessage);
647     }
648 
649     /**
650      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
651      * but performing a static call.
652      *
653      * _Available since v3.3._
654      */
655     function functionStaticCall(address target, bytes memory data)
656         internal
657         view
658         returns (bytes memory)
659     {
660         return
661             functionStaticCall(
662                 target,
663                 data,
664                 "Address: low-level static call failed"
665             );
666     }
667 
668     /**
669      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
670      * but performing a static call.
671      *
672      * _Available since v3.3._
673      */
674     function functionStaticCall(
675         address target,
676         bytes memory data,
677         string memory errorMessage
678     ) internal view returns (bytes memory) {
679         require(isContract(target), "Address: static call to non-contract");
680 
681         (bool success, bytes memory returndata) = target.staticcall(data);
682         return verifyCallResult(success, returndata, errorMessage);
683     }
684 
685     /**
686      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
687      * but performing a delegate call.
688      *
689      * _Available since v3.4._
690      */
691     function functionDelegateCall(address target, bytes memory data)
692         internal
693         returns (bytes memory)
694     {
695         return
696             functionDelegateCall(
697                 target,
698                 data,
699                 "Address: low-level delegate call failed"
700             );
701     }
702 
703     /**
704      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
705      * but performing a delegate call.
706      *
707      * _Available since v3.4._
708      */
709     function functionDelegateCall(
710         address target,
711         bytes memory data,
712         string memory errorMessage
713     ) internal returns (bytes memory) {
714         require(isContract(target), "Address: delegate call to non-contract");
715 
716         (bool success, bytes memory returndata) = target.delegatecall(data);
717         return verifyCallResult(success, returndata, errorMessage);
718     }
719 
720     /**
721      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
722      * revert reason using the provided one.
723      *
724      * _Available since v4.3._
725      */
726     function verifyCallResult(
727         bool success,
728         bytes memory returndata,
729         string memory errorMessage
730     ) internal pure returns (bytes memory) {
731         if (success) {
732             return returndata;
733         } else {
734             // Look for revert reason and bubble it up if present
735             if (returndata.length > 0) {
736                 // The easiest way to bubble the revert reason is using memory via assembly
737 
738                 assembly {
739                     let returndata_size := mload(returndata)
740                     revert(add(32, returndata), returndata_size)
741                 }
742             } else {
743                 revert(errorMessage);
744             }
745         }
746     }
747 }
748 
749 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
750 
751 /**
752  * @dev Provides information about the current execution context, including the
753  * sender of the transaction and its data. While these are generally available
754  * via msg.sender and msg.data, they should not be accessed in such a direct
755  * manner, since when dealing with meta-transactions the account sending and
756  * paying for execution may not be the actual sender (as far as an application
757  * is concerned).
758  *
759  * This contract is only required for intermediate, library-like contracts.
760  */
761 abstract contract Context {
762     function _msgSender() internal view virtual returns (address) {
763         return msg.sender;
764     }
765 
766     function _msgData() internal view virtual returns (bytes calldata) {
767         return msg.data;
768     }
769 }
770 
771 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
772 
773 /**
774  * @dev String operations.
775  */
776 library Strings {
777     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
778 
779     /**
780      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
781      */
782     function toString(uint256 value) internal pure returns (string memory) {
783         // Inspired by OraclizeAPI's implementation - MIT licence
784         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
785 
786         if (value == 0) {
787             return "0";
788         }
789         uint256 temp = value;
790         uint256 digits;
791         while (temp != 0) {
792             digits++;
793             temp /= 10;
794         }
795         bytes memory buffer = new bytes(digits);
796         while (value != 0) {
797             digits -= 1;
798             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
799             value /= 10;
800         }
801         return string(buffer);
802     }
803 
804     /**
805      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
806      */
807     function toHexString(uint256 value) internal pure returns (string memory) {
808         if (value == 0) {
809             return "0x00";
810         }
811         uint256 temp = value;
812         uint256 length = 0;
813         while (temp != 0) {
814             length++;
815             temp >>= 8;
816         }
817         return toHexString(value, length);
818     }
819 
820     /**
821      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
822      */
823     function toHexString(uint256 value, uint256 length)
824         internal
825         pure
826         returns (string memory)
827     {
828         bytes memory buffer = new bytes(2 * length + 2);
829         buffer[0] = "0";
830         buffer[1] = "x";
831         for (uint256 i = 2 * length + 1; i > 1; --i) {
832             buffer[i] = _HEX_SYMBOLS[value & 0xf];
833             value >>= 4;
834         }
835         require(value == 0, "Strings: hex length insufficient");
836         return string(buffer);
837     }
838 }
839 
840 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
841 
842 /**
843  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
844  * @dev See https://eips.ethereum.org/EIPS/eip-721
845  */
846 interface IERC721Enumerable is IERC721 {
847     /**
848      * @dev Returns the total amount of tokens stored by the contract.
849      */
850     function totalSupply() external view returns (uint256);
851 
852     /**
853      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
854      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
855      */
856     function tokenOfOwnerByIndex(address owner, uint256 index)
857         external
858         view
859         returns (uint256 tokenId);
860 
861     /**
862      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
863      * Use along with {totalSupply} to enumerate all tokens.
864      */
865     function tokenByIndex(uint256 index) external view returns (uint256);
866 }
867 
868 /**
869  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
870  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
871  *
872  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
873  *
874  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
875  *
876  * Does not support burning tokens to address(0).
877  */
878 contract ERC721A is
879     Context,
880     ERC165,
881     IERC721,
882     IERC721Metadata,
883     IERC721Enumerable
884 {
885     using Address for address;
886     using Strings for uint256;
887 
888     struct TokenOwnership {
889         address addr;
890         uint64 startTimestamp;
891     }
892 
893     struct AddressData {
894         uint128 balance;
895         uint128 numberMinted;
896     }
897 
898     uint256 private currentIndex = 0;
899 
900     uint256 internal immutable collectionSize;
901     uint256 internal immutable maxBatchSize;
902 
903     // Token name
904     string private _name;
905 
906     // Token symbol
907     string private _symbol;
908 
909     // Mapping from token ID to ownership details
910     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
911     mapping(uint256 => TokenOwnership) private _ownerships;
912 
913     // Mapping owner address to address data
914     mapping(address => AddressData) private _addressData;
915 
916     // Mapping from token ID to approved address
917     mapping(uint256 => address) private _tokenApprovals;
918 
919     // Mapping from owner to operator approvals
920     mapping(address => mapping(address => bool)) private _operatorApprovals;
921 
922     /**
923      * @dev
924      * `maxBatchSize` refers to how much a minter can mint at a time.
925      * `collectionSize_` refers to how many tokens are in the collection.
926      */
927     constructor(
928         string memory name_,
929         string memory symbol_,
930         uint256 maxBatchSize_,
931         uint256 collectionSize_
932     ) {
933         require(
934             collectionSize_ > 0,
935             "ERC721A: collection must have a nonzero supply"
936         );
937         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
938         _name = name_;
939         _symbol = symbol_;
940         maxBatchSize = maxBatchSize_;
941         collectionSize = collectionSize_;
942     }
943 
944     /**
945      * @dev See {IERC721Enumerable-totalSupply}.
946      */
947     function totalSupply() public view override returns (uint256) {
948         return currentIndex;
949     }
950 
951     /**
952      * @dev See {IERC721Enumerable-tokenByIndex}.
953      */
954     function tokenByIndex(uint256 index)
955         public
956         view
957         override
958         returns (uint256)
959     {
960         require(index < totalSupply(), "ERC721A: global index out of bounds");
961         return index;
962     }
963 
964     /**
965      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
966      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
967      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
968      */
969     function tokenOfOwnerByIndex(address owner, uint256 index)
970         public
971         view
972         override
973         returns (uint256)
974     {
975         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
976         uint256 numMintedSoFar = totalSupply();
977         uint256 tokenIdsIdx = 0;
978         address currOwnershipAddr = address(0);
979         for (uint256 i = 0; i < numMintedSoFar; i++) {
980             TokenOwnership memory ownership = _ownerships[i];
981             if (ownership.addr != address(0)) {
982                 currOwnershipAddr = ownership.addr;
983             }
984             if (currOwnershipAddr == owner) {
985                 if (tokenIdsIdx == index) {
986                     return i;
987                 }
988                 tokenIdsIdx++;
989             }
990         }
991         revert("ERC721A: unable to get token of owner by index");
992     }
993 
994     /**
995      * @dev See {IERC165-supportsInterface}.
996      */
997     function supportsInterface(bytes4 interfaceId)
998         public
999         view
1000         virtual
1001         override(ERC165, IERC165)
1002         returns (bool)
1003     {
1004         return
1005             interfaceId == type(IERC721).interfaceId ||
1006             interfaceId == type(IERC721Metadata).interfaceId ||
1007             interfaceId == type(IERC721Enumerable).interfaceId ||
1008             super.supportsInterface(interfaceId);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-balanceOf}.
1013      */
1014     function balanceOf(address owner) public view override returns (uint256) {
1015         require(
1016             owner != address(0),
1017             "ERC721A: balance query for the zero address"
1018         );
1019         return uint256(_addressData[owner].balance);
1020     }
1021 
1022     function _numberMinted(address owner) internal view returns (uint256) {
1023         require(
1024             owner != address(0),
1025             "ERC721A: number minted query for the zero address"
1026         );
1027         return uint256(_addressData[owner].numberMinted);
1028     }
1029 
1030     function ownershipOf(uint256 tokenId)
1031         internal
1032         view
1033         returns (TokenOwnership memory)
1034     {
1035         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1036 
1037         uint256 lowestTokenToCheck;
1038         if (tokenId >= maxBatchSize) {
1039             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1040         }
1041 
1042         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1043             TokenOwnership memory ownership = _ownerships[curr];
1044             if (ownership.addr != address(0)) {
1045                 return ownership;
1046             }
1047         }
1048 
1049         revert("ERC721A: unable to determine the owner of token");
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-ownerOf}.
1054      */
1055     function ownerOf(uint256 tokenId) public view override returns (address) {
1056         return ownershipOf(tokenId).addr;
1057     }
1058 
1059     /**
1060      * @dev See {IERC721Metadata-name}.
1061      */
1062     function name() public view virtual override returns (string memory) {
1063         return _name;
1064     }
1065 
1066     /**
1067      * @dev See {IERC721Metadata-symbol}.
1068      */
1069     function symbol() public view virtual override returns (string memory) {
1070         return _symbol;
1071     }
1072 
1073     /**
1074      * @dev See {IERC721Metadata-tokenURI}.
1075      */
1076     function tokenURI(uint256 tokenId)
1077         public
1078         view
1079         virtual
1080         override
1081         returns (string memory)
1082     {
1083         require(
1084             _exists(tokenId),
1085             "ERC721Metadata: URI query for nonexistent token"
1086         );
1087 
1088         string memory baseURI = _baseURI();
1089         return
1090             bytes(baseURI).length > 0
1091                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
1092                 : "";
1093     }
1094 
1095     /**
1096      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1097      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1098      * by default, can be overriden in child contracts.
1099      */
1100     function _baseURI() internal view virtual returns (string memory) {
1101         return "";
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-approve}.
1106      */
1107     function approve(address to, uint256 tokenId) public override {
1108         address owner = ERC721A.ownerOf(tokenId);
1109         require(to != owner, "ERC721A: approval to current owner");
1110 
1111         require(
1112             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1113             "ERC721A: approve caller is not owner nor approved for all"
1114         );
1115 
1116         _approve(to, tokenId, owner);
1117     }
1118 
1119     /**
1120      * @dev See {IERC721-getApproved}.
1121      */
1122     function getApproved(uint256 tokenId)
1123         public
1124         view
1125         override
1126         returns (address)
1127     {
1128         require(
1129             _exists(tokenId),
1130             "ERC721A: approved query for nonexistent token"
1131         );
1132 
1133         return _tokenApprovals[tokenId];
1134     }
1135 
1136     /**
1137      * @dev See {IERC721-setApprovalForAll}.
1138      */
1139     function setApprovalForAll(address operator, bool approved)
1140         public
1141         override
1142     {
1143         require(operator != _msgSender(), "ERC721A: approve to caller");
1144 
1145         _operatorApprovals[_msgSender()][operator] = approved;
1146         emit ApprovalForAll(_msgSender(), operator, approved);
1147     }
1148 
1149     /**
1150      * @dev See {IERC721-isApprovedForAll}.
1151      */
1152     function isApprovedForAll(address owner, address operator)
1153         public
1154         view
1155         virtual
1156         override
1157         returns (bool)
1158     {
1159         return _operatorApprovals[owner][operator];
1160     }
1161 
1162     /**
1163      * @dev See {IERC721-transferFrom}.
1164      */
1165     function transferFrom(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) public override {
1170         _transfer(from, to, tokenId);
1171     }
1172 
1173     /**
1174      * @dev See {IERC721-safeTransferFrom}.
1175      */
1176     function safeTransferFrom(
1177         address from,
1178         address to,
1179         uint256 tokenId
1180     ) public override {
1181         safeTransferFrom(from, to, tokenId, "");
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-safeTransferFrom}.
1186      */
1187     function safeTransferFrom(
1188         address from,
1189         address to,
1190         uint256 tokenId,
1191         bytes memory _data
1192     ) public override {
1193         _transfer(from, to, tokenId);
1194         require(
1195             _checkOnERC721Received(from, to, tokenId, _data),
1196             "ERC721A: transfer to non ERC721Receiver implementer"
1197         );
1198     }
1199 
1200     /**
1201      * @dev Returns whether `tokenId` exists.
1202      *
1203      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1204      *
1205      * Tokens start existing when they are minted (`_mint`),
1206      */
1207     function _exists(uint256 tokenId) internal view returns (bool) {
1208         return tokenId < currentIndex;
1209     }
1210 
1211     function _safeMint(address to, uint256 quantity) internal {
1212         _safeMint(to, quantity, "");
1213     }
1214 
1215     /**
1216      * @dev Mints `quantity` tokens and transfers them to `to`.
1217      *
1218      * Requirements:
1219      *
1220      * - there must be `quantity` tokens remaining unminted in the total collection.
1221      * - `to` cannot be the zero address.
1222      * - `quantity` cannot be larger than the max batch size.
1223      *
1224      * Emits a {Transfer} event.
1225      */
1226     function _safeMint(
1227         address to,
1228         uint256 quantity,
1229         bytes memory _data
1230     ) internal {
1231         uint256 startTokenId = currentIndex;
1232         require(to != address(0), "ERC721A: mint to the zero address");
1233         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1234         require(!_exists(startTokenId), "ERC721A: token already minted");
1235         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1236 
1237         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1238 
1239         AddressData memory addressData = _addressData[to];
1240         _addressData[to] = AddressData(
1241             addressData.balance + uint128(quantity),
1242             addressData.numberMinted + uint128(quantity)
1243         );
1244         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1245 
1246         uint256 updatedIndex = startTokenId;
1247 
1248         for (uint256 i = 0; i < quantity; i++) {
1249             emit Transfer(address(0), to, updatedIndex);
1250             require(
1251                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1252                 "ERC721A: transfer to non ERC721Receiver implementer"
1253             );
1254             updatedIndex++;
1255         }
1256 
1257         currentIndex = updatedIndex;
1258         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1259     }
1260 
1261     /**
1262      * @dev Transfers `tokenId` from `from` to `to`.
1263      *
1264      * Requirements:
1265      *
1266      * - `to` cannot be the zero address.
1267      * - `tokenId` token must be owned by `from`.
1268      *
1269      * Emits a {Transfer} event.
1270      */
1271     function _transfer(
1272         address from,
1273         address to,
1274         uint256 tokenId
1275     ) private {
1276         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1277 
1278         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1279             getApproved(tokenId) == _msgSender() ||
1280             isApprovedForAll(prevOwnership.addr, _msgSender()));
1281 
1282         require(
1283             isApprovedOrOwner,
1284             "ERC721A: transfer caller is not owner nor approved"
1285         );
1286 
1287         require(
1288             prevOwnership.addr == from,
1289             "ERC721A: transfer from incorrect owner"
1290         );
1291         require(to != address(0), "ERC721A: transfer to the zero address");
1292 
1293         _beforeTokenTransfers(from, to, tokenId, 1);
1294 
1295         // Clear approvals from the previous owner
1296         _approve(address(0), tokenId, prevOwnership.addr);
1297 
1298         _addressData[from].balance -= 1;
1299         _addressData[to].balance += 1;
1300         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1301 
1302         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1303         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1304         uint256 nextTokenId = tokenId + 1;
1305         if (_ownerships[nextTokenId].addr == address(0)) {
1306             if (_exists(nextTokenId)) {
1307                 _ownerships[nextTokenId] = TokenOwnership(
1308                     prevOwnership.addr,
1309                     prevOwnership.startTimestamp
1310                 );
1311             }
1312         }
1313 
1314         emit Transfer(from, to, tokenId);
1315         _afterTokenTransfers(from, to, tokenId, 1);
1316     }
1317 
1318     /**
1319      * @dev Approve `to` to operate on `tokenId`
1320      *
1321      * Emits a {Approval} event.
1322      */
1323     function _approve(
1324         address to,
1325         uint256 tokenId,
1326         address owner
1327     ) private {
1328         _tokenApprovals[tokenId] = to;
1329         emit Approval(owner, to, tokenId);
1330     }
1331 
1332     uint256 public nextOwnerToExplicitlySet = 0;
1333 
1334     /**
1335      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1336      */
1337     function _setOwnersExplicit(uint256 quantity) internal {
1338         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1339         require(quantity > 0, "quantity must be nonzero");
1340         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1341         if (endIndex > collectionSize - 1) {
1342             endIndex = collectionSize - 1;
1343         }
1344         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1345         require(_exists(endIndex), "not enough minted yet for this cleanup");
1346         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1347             if (_ownerships[i].addr == address(0)) {
1348                 TokenOwnership memory ownership = ownershipOf(i);
1349                 _ownerships[i] = TokenOwnership(
1350                     ownership.addr,
1351                     ownership.startTimestamp
1352                 );
1353             }
1354         }
1355         nextOwnerToExplicitlySet = endIndex + 1;
1356     }
1357 
1358     /**
1359      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1360      * The call is not executed if the target address is not a contract.
1361      *
1362      * @param from address representing the previous owner of the given token ID
1363      * @param to target address that will receive the tokens
1364      * @param tokenId uint256 ID of the token to be transferred
1365      * @param _data bytes optional data to send along with the call
1366      * @return bool whether the call correctly returned the expected magic value
1367      */
1368     function _checkOnERC721Received(
1369         address from,
1370         address to,
1371         uint256 tokenId,
1372         bytes memory _data
1373     ) private returns (bool) {
1374         if (to.isContract()) {
1375             try
1376                 IERC721Receiver(to).onERC721Received(
1377                     _msgSender(),
1378                     from,
1379                     tokenId,
1380                     _data
1381                 )
1382             returns (bytes4 retval) {
1383                 return retval == IERC721Receiver(to).onERC721Received.selector;
1384             } catch (bytes memory reason) {
1385                 if (reason.length == 0) {
1386                     revert(
1387                         "ERC721A: transfer to non ERC721Receiver implementer"
1388                     );
1389                 } else {
1390                     assembly {
1391                         revert(add(32, reason), mload(reason))
1392                     }
1393                 }
1394             }
1395         } else {
1396             return true;
1397         }
1398     }
1399 
1400     /**
1401      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1402      *
1403      * startTokenId - the first token id to be transferred
1404      * quantity - the amount to be transferred
1405      *
1406      * Calling conditions:
1407      *
1408      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1409      * transferred to `to`.
1410      * - When `from` is zero, `tokenId` will be minted for `to`.
1411      */
1412     function _beforeTokenTransfers(
1413         address from,
1414         address to,
1415         uint256 startTokenId,
1416         uint256 quantity
1417     ) internal virtual {}
1418 
1419     /**
1420      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1421      * minting.
1422      *
1423      * startTokenId - the first token id to be transferred
1424      * quantity - the amount to be transferred
1425      *
1426      * Calling conditions:
1427      *
1428      * - when `from` and `to` are both non-zero.
1429      * - `from` and `to` are never both zero.
1430      */
1431     function _afterTokenTransfers(
1432         address from,
1433         address to,
1434         uint256 startTokenId,
1435         uint256 quantity
1436     ) internal virtual {}
1437 }
1438 
1439 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1440 
1441 /**
1442  * @dev Contract module which provides a basic access control mechanism, where
1443  * there is an account (an owner) that can be granted exclusive access to
1444  * specific functions.
1445  *
1446  * By default, the owner account will be the one that deploys the contract. This
1447  * can later be changed with {transferOwnership}.
1448  *
1449  * This module is used through inheritance. It will make available the modifier
1450  * `onlyOwner`, which can be applied to your functions to restrict their use to
1451  * the owner.
1452  */
1453 abstract contract Ownable is Context {
1454     address private _owner;
1455 
1456     event OwnershipTransferred(
1457         address indexed previousOwner,
1458         address indexed newOwner
1459     );
1460 
1461     /**
1462      * @dev Initializes the contract setting the deployer as the initial owner.
1463      */
1464     constructor() {
1465         _transferOwnership(_msgSender());
1466     }
1467 
1468     /**
1469      * @dev Returns the address of the current owner.
1470      */
1471     function owner() public view virtual returns (address) {
1472         return _owner;
1473     }
1474 
1475     /**
1476      * @dev Throws if called by any account other than the owner.
1477      */
1478     modifier onlyOwner() {
1479         require(owner() == _msgSender(), "You are not the owner");
1480         _;
1481     }
1482 
1483     /**
1484      * @dev Leaves the contract without owner. It will not be possible to call
1485      * `onlyOwner` functions anymore. Can only be called by the current owner.
1486      *
1487      * NOTE: Renouncing ownership will leave the contract without an owner,
1488      * thereby removing any functionality that is only available to the owner.
1489      */
1490     function renounceOwnership() public virtual onlyOwner {
1491         _transferOwnership(address(0));
1492     }
1493 
1494     /**
1495      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1496      * Can only be called by the current owner.
1497      */
1498     function transferOwnership(address newOwner) public virtual onlyOwner {
1499         require(
1500             newOwner != address(0),
1501             "Ownable: new owner is the zero address"
1502         );
1503         _transferOwnership(newOwner);
1504     }
1505 
1506     /**
1507      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1508      * Internal function without access restriction.
1509      */
1510     function _transferOwnership(address newOwner) internal virtual {
1511         address oldOwner = _owner;
1512         _owner = newOwner;
1513         emit OwnershipTransferred(oldOwner, newOwner);
1514     }
1515 }
1516 
1517 /**
1518  * @dev Interface for the NFT Royalty Standard.
1519  *
1520  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1521  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1522  *
1523  * _Available since v4.5._
1524  */
1525 interface IERC2981 is IERC165 {
1526     /**
1527      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1528      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1529      */
1530     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1531         external
1532         view
1533         returns (address receiver, uint256 royaltyAmount);
1534 }
1535 
1536 contract Insidebysin is ERC721A, IERC2981, Ownable {
1537     string public baseURI = "https://ipfs-storage.s3.amazonaws.com/insidebysin/";
1538 
1539     uint256 public tokenPrice = 50000000000000000; //0.005 ETH
1540 
1541     uint256 public whitelistTokenPrice = 0; //0.005 ETH
1542 
1543     uint256 public maxTokensPerTx = 20;
1544 
1545     uint256 public defaultTokensPerTx = 3;
1546 
1547     uint256 public MAX_TOKENS = 555;
1548 
1549     bool public saleIsActive = true;
1550 
1551     // total token for whitelistmint
1552     uint256 public whitelistMintRemains = 0;
1553 
1554     uint256 public royalty = 250; //2.5%
1555 
1556     // = 0 if there are no free tokens
1557     // = maxTokensPerTx if free all
1558     uint256 public maxTokensFreePerTx = 0;
1559 
1560     // = true, if only admin can mint (whitelist)
1561     bool public isPrivateWhitelistMint = false;
1562 
1563     bytes32 public merkleRoot;
1564 
1565     enum TokenURIMode {
1566         MODE_ONE,
1567         MODE_TWO,
1568         MODE_THREE
1569     }
1570 
1571     TokenURIMode private tokenUriMode = TokenURIMode.MODE_ONE;
1572 
1573     constructor() ERC721A("Inside by Sin Nombre", "IBSN", 100, MAX_TOKENS) {}
1574 
1575     struct HelperState {
1576         uint256 tokenPrice;
1577         uint256 maxTokensPerTx;
1578         uint256 MAX_TOKENS;
1579         bool saleIsActive;
1580         uint256 totalSupply;
1581         uint256 maxTokensFreePerTx;
1582         uint256 userMinted;
1583         uint256 defaultTokensPerTx;
1584         uint256 whitelistTokenPrice;
1585     }
1586 
1587     function _state(address minter) external view returns (HelperState memory) {
1588         return
1589             HelperState({
1590                 tokenPrice: tokenPrice,
1591                 maxTokensPerTx: maxTokensPerTx,
1592                 MAX_TOKENS: MAX_TOKENS,
1593                 saleIsActive: saleIsActive,
1594                 totalSupply: uint256(totalSupply()),
1595                 maxTokensFreePerTx: maxTokensFreePerTx,
1596                 userMinted: minter == address(0)
1597                     ? 0
1598                     : uint256(_numberMinted(minter)),
1599                 defaultTokensPerTx: defaultTokensPerTx,
1600                 whitelistTokenPrice: whitelistTokenPrice
1601             });
1602     }
1603 
1604     function withdraw() public onlyOwner {
1605         uint256 balance = address(this).balance;
1606         payable(msg.sender).transfer(balance);
1607     }
1608 
1609     function withdrawTo(address to, uint256 amount) public onlyOwner {
1610         require(
1611             amount <= address(this).balance,
1612             "Exceed balance of this contract"
1613         );
1614         payable(to).transfer(amount);
1615     }
1616 
1617     function reserveTokens(address to, uint256 numberOfTokens)
1618         public
1619         onlyOwner
1620     {
1621         require(
1622             totalSupply() + numberOfTokens <= MAX_TOKENS,
1623             "Exceed max supply of tokens"
1624         );
1625         _safeMint(to, numberOfTokens);
1626     }
1627 
1628     function setBaseURI(string memory newURI) public onlyOwner {
1629         baseURI = newURI;
1630     }
1631 
1632     function flipSaleState() public onlyOwner {
1633         saleIsActive = !saleIsActive;
1634     }
1635 
1636     function openWhitelistMint(
1637         uint256 _whitelistMintRemains,
1638         bool _isPrivateWhitelistMint,
1639         bytes32 _merkleRoot,
1640         uint256 _whitelistTokenPrice
1641     ) public onlyOwner {
1642         whitelistMintRemains = _whitelistMintRemains;
1643         isPrivateWhitelistMint = _isPrivateWhitelistMint;
1644         merkleRoot = _merkleRoot;
1645         saleIsActive = true;
1646         whitelistTokenPrice = _whitelistTokenPrice;
1647     }
1648 
1649     function getPrice(
1650         uint256 numberOfTokens,
1651         address minter,
1652         bytes32[] calldata merkleProof
1653     ) public view returns (uint256) {
1654         if (numberMinted(minter) > 0) {
1655             return numberOfTokens * tokenPrice;
1656         } else if (numberOfTokens > maxTokensFreePerTx) {
1657             if (
1658                 (!isPrivateWhitelistMint ||
1659                     MerkleProof.verify(
1660                         merkleProof,
1661                         merkleRoot,
1662                         keccak256(abi.encodePacked(msg.sender))
1663                     )) && whitelistMintRemains > 0
1664             ) {
1665                 return
1666                     (numberOfTokens - maxTokensFreePerTx) * whitelistTokenPrice;
1667             } else {
1668                 return (numberOfTokens - maxTokensFreePerTx) * tokenPrice;
1669             }
1670         }
1671         return 0;
1672     }
1673 
1674     // if numberMinted(msg.sender) > 0 -> no whitelist, no free.
1675     function mintToken(uint256 numberOfTokens, bytes32[] calldata merkleProof)
1676         public
1677         payable
1678     {
1679         require(saleIsActive, "Sale must be active");
1680         require(numberOfTokens <= maxTokensPerTx, "Exceed max tokens per tx");
1681         require(numberOfTokens > 0, "Must mint at least one");
1682         require(
1683             totalSupply() + numberOfTokens <= MAX_TOKENS,
1684             "Exceed max supply"
1685         );
1686 
1687         if (
1688             whitelistMintRemains > 0 &&
1689             (!isPrivateWhitelistMint ||
1690                 MerkleProof.verify(
1691                     merkleProof,
1692                     merkleRoot,
1693                     keccak256(abi.encodePacked(msg.sender))
1694                 )) &&
1695             numberMinted(msg.sender) <= 0
1696         ) {
1697             if (_numberMinted(msg.sender) > 0) {
1698                 require(
1699                     msg.value >= numberOfTokens * whitelistTokenPrice,
1700                     "Not enough ether"
1701                 );
1702             } else {
1703                 require(
1704                     msg.value >=
1705                         (numberOfTokens - maxTokensFreePerTx) *
1706                             whitelistTokenPrice,
1707                     "Not enough ether"
1708                 );
1709             }
1710             if (numberOfTokens >= whitelistMintRemains) {
1711                 numberOfTokens = whitelistMintRemains;
1712             }
1713             _safeMint(msg.sender, numberOfTokens);
1714             whitelistMintRemains = whitelistMintRemains - numberOfTokens;
1715         } else {
1716             if (_numberMinted(msg.sender) > 0) {
1717                 require(
1718                     msg.value >= numberOfTokens * tokenPrice,
1719                     "Not enough ether"
1720                 );
1721             } else if (numberOfTokens > maxTokensFreePerTx) {
1722                 require(
1723                     msg.value >=
1724                         (numberOfTokens - maxTokensFreePerTx) * tokenPrice,
1725                     "Not enough ether"
1726                 );
1727             }
1728             _safeMint(msg.sender, numberOfTokens);
1729         }
1730     }
1731 
1732     function setTokenPrice(uint256 newTokenPrice) public onlyOwner {
1733         tokenPrice = newTokenPrice;
1734     }
1735 
1736     function setWhitelistTokenPrice(uint256 _whitelistTokenPrice)
1737         public
1738         onlyOwner
1739     {
1740         whitelistTokenPrice = _whitelistTokenPrice;
1741     }
1742 
1743     function tokenURI(uint256 _tokenId)
1744         public
1745         view
1746         override
1747         returns (string memory)
1748     {
1749         require(_exists(_tokenId), "Token does not exist.");
1750         if (tokenUriMode == TokenURIMode.MODE_TWO) {
1751             return
1752                 bytes(baseURI).length > 0
1753                     ? string(
1754                         abi.encodePacked(baseURI, Strings.toString(_tokenId))
1755                     )
1756                     : "";
1757         } else if (tokenUriMode == TokenURIMode.MODE_ONE) {
1758             return
1759                 bytes(baseURI).length > 0
1760                     ? string(
1761                         abi.encodePacked(
1762                             baseURI,
1763                             Strings.toString(_tokenId),
1764                             ".json"
1765                         )
1766                     )
1767                     : "";
1768         } else if (tokenUriMode == TokenURIMode.MODE_THREE) {
1769             return baseURI;
1770         }
1771         return "";
1772     }
1773 
1774     function setTokenURIMode(uint256 mode) external onlyOwner {
1775         if (mode == 2) {
1776             tokenUriMode = TokenURIMode.MODE_TWO;
1777         } else if (mode == 1) {
1778             tokenUriMode = TokenURIMode.MODE_ONE;
1779         } else {
1780             tokenUriMode = TokenURIMode.MODE_THREE;
1781         }
1782     }
1783 
1784     function _baseURI() internal view virtual override returns (string memory) {
1785         return baseURI;
1786     }
1787 
1788     function numberMinted(address owner) public view returns (uint256) {
1789         return _numberMinted(owner);
1790     }
1791 
1792     function setMaxTokensPerTx(uint256 _maxTokensPerTx) public onlyOwner {
1793         require(_maxTokensPerTx < 250, "Exceed max batch size");
1794         maxTokensPerTx = _maxTokensPerTx;
1795     }
1796 
1797     function setMaxTokensFreePerTx(uint256 _maxTokensFreePerTx)
1798         public
1799         onlyOwner
1800     {
1801         maxTokensFreePerTx = _maxTokensFreePerTx;
1802     }
1803 
1804     function setDefaultTokensPerTx(uint256 _defaultTokensPerTx)
1805         public
1806         onlyOwner
1807     {
1808         defaultTokensPerTx = _defaultTokensPerTx;
1809     }
1810 
1811     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1812         merkleRoot = _merkleRoot;
1813     }
1814 
1815     function supportsInterface(bytes4 interfaceId)
1816         public
1817         view
1818         virtual
1819         override(ERC721A, IERC165)
1820         returns (bool)
1821     {
1822         return
1823             interfaceId == type(IERC2981).interfaceId ||
1824             super.supportsInterface(interfaceId);
1825     }
1826 
1827     /**
1828      * @dev See {IERC165-royaltyInfo}.
1829      */
1830     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1831         external
1832         view
1833         override
1834         returns (address receiver, uint256 royaltyAmount)
1835     {
1836         require(_exists(tokenId), "Nonexistent token");
1837         return (owner(), (salePrice * royalty) / 10000);
1838     }
1839 }