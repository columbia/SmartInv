1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-26
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/utils/Address.sol
7 
8 
9 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
10 
11 pragma solidity ^0.8.1;
12 
13 /**
14  * @dev Collection of functions related to the address type
15  */
16 library Address {
17     /**
18      * @dev Returns true if `account` is a contract.
19      *
20      * [IMPORTANT]     * ===    * It is unsafe to assume that an address for which this function returns
21      * false is an externally-owned account (EOA) and not a contract.
22      *
23      * Among others, `isContract` will return false for the following
24      * types of addresses:
25      *
26      *  - an externally-owned account
27      *  - a contract in construction
28      *  - an address where a contract will be created
29      *  - an address where a contract lived, but was destroyed
30      * ====
31      *
32      * [IMPORTANT]
33      * ====
34      * You shouldn't rely on `isContract` to protect against flash loan attacks!
35      *
36      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
37      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
38      * constructor.
39      * ====
40      */
41     function isContract(address account) internal view returns (bool) {
42         // This method relies on extcodesize/address.code.length, which returns 0
43         // for contracts in construction, since the code is only stored at the end
44         // of the constructor execution.
45 
46         return account.code.length > 0;
47     }
48 
49     /**
50      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
51      * `recipient`, forwarding all available gas and reverting on errors.
52      *
53      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
54      * of certain opcodes, possibly making contracts go over the 2300 gas limit
55      * imposed by `transfer`, making them unable to receive funds via
56      * `transfer`. {sendValue} removes this limitation.
57      *
58      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
59      *
60      * IMPORTANT: because control is transferred to `recipient`, care must be
61      * taken to not create reentrancy vulnerabilities. Consider using
62      * {ReentrancyGuard} or the
63      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
64      */
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(address(this).balance >= amount, "Address: insufficient balance");
67 
68         (bool success, ) = recipient.call{value: amount}("");
69         require(success, "Address: unable to send value, recipient may have reverted");
70     }
71 
72     /**
73      * @dev Performs a Solidity function call using a low level `call`. A
74      * plain `call` is an unsafe replacement for a function call: use this
75      * function instead.
76      *
77      * If `target` reverts with a revert reason, it is bubbled up by this
78      * function (like regular Solidity function calls).
79      *
80      * Returns the raw returned data. To convert to the expected return value,
81      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
82      *
83      * Requirements:
84      *
85      * - `target` must be a contract.
86      * - calling `target` with `data` must not revert.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
91         return functionCall(target, data, "Address: low-level call failed");
92     }
93 
94     /**
95      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
96      * `errorMessage` as a fallback revert reason when `target` reverts.
97      *
98      * _Available since v3.1._
99      */
100     function functionCall(
101         address target,
102         bytes memory data,
103         string memory errorMessage
104     ) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, 0, errorMessage);
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
110      * but also transferring `value` wei to `target`.
111      *
112      * Requirements:
113      *
114      * - the calling contract must have an ETH balance of at least `value`.
115      * - the called Solidity function must be `payable`.
116      *
117      * _Available since v3.1._
118      */
119     function functionCallWithValue(
120         address target,
121         bytes memory data,
122         uint256 value
123     ) internal returns (bytes memory) {
124         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
129      * with `errorMessage` as a fallback revert reason when `target` reverts.
130      *
131      * _Available since v3.1._
132      */
133     function functionCallWithValue(
134         address target,
135         bytes memory data,
136         uint256 value,
137         string memory errorMessage
138     ) internal returns (bytes memory) {
139         require(address(this).balance >= value, "Address: insufficient balance for call");
140         require(isContract(target), "Address: call to non-contract");
141 
142         (bool success, bytes memory returndata) = target.call{value: value}(data);
143         return verifyCallResult(success, returndata, errorMessage);
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
148      * but performing a static call.
149      *
150      * _Available since v3.3._
151      */
152     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
153         return functionStaticCall(target, data, "Address: low-level static call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
158      * but performing a static call.
159      *
160      * _Available since v3.3._
161      */
162     function functionStaticCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal view returns (bytes memory) {
167         require(isContract(target), "Address: static call to non-contract");
168 
169         (bool success, bytes memory returndata) = target.staticcall(data);
170         return verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
175      * but performing a delegate call.
176      *
177      * _Available since v3.4._
178      */
179     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
185      * but performing a delegate call.
186      *
187      * _Available since v3.4._
188      */
189     function functionDelegateCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         require(isContract(target), "Address: delegate call to non-contract");
195 
196         (bool success, bytes memory returndata) = target.delegatecall(data);
197         return verifyCallResult(success, returndata, errorMessage);
198     }
199 
200     /**
201      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
202      * revert reason using the provided one.
203      *
204      * _Available since v4.3._
205      */
206     function verifyCallResult(
207         bool success,
208         bytes memory returndata,
209         string memory errorMessage
210     ) internal pure returns (bytes memory) {
211         if (success) {
212             return returndata;
213         } else {
214             // Look for revert reason and bubble it up if present
215             if (returndata.length > 0) {
216                 // The easiest way to bubble the revert reason is using memory via assembly
217                 /// @solidity memory-safe-assembly
218                 assembly {
219                     let returndata_size := mload(returndata)
220                     revert(add(32, returndata), returndata_size)
221                 }
222             } else {
223                 revert(errorMessage);
224             }
225         }
226     }
227 }
228 
229 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
230 
231 
232 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @title ERC721 token receiver interface
238  * @dev Interface for any contract that wants to support safeTransfers
239  * from ERC721 asset contracts.
240  */
241 interface IERC721Receiver {
242     /**
243      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
244      * by `operator` from `from`, this function is called.
245      *
246      * It must return its Solidity selector to confirm the token transfer.
247      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
248      *
249      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
250      */
251     function onERC721Received(
252         address operator,
253         address from,
254         uint256 tokenId,
255         bytes calldata data
256     ) external returns (bytes4);
257 }
258 
259 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
260 
261 
262 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 /**
267  * @dev Interface of the ERC165 standard, as defined in the
268  * https://eips.ethereum.org/EIPS/eip-165[EIP].
269  *
270  * Implementers can declare support of contract interfaces, which can then be
271  * queried by others ({ERC165Checker}).
272  *
273  * For an implementation, see {ERC165}.
274  */
275 interface IERC165 {
276     /**
277      * @dev Returns true if this contract implements the interface defined by
278      * `interfaceId`. See the corresponding
279      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
280      * to learn more about how these ids are created.
281      *
282      * This function call must use less than 30 000 gas.
283      */
284     function supportsInterface(bytes4 interfaceId) external view returns (bool);
285 }
286 
287 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
288 
289 
290 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
291 
292 pragma solidity ^0.8.0;
293 
294 
295 /**
296  * @dev Implementation of the {IERC165} interface.
297  *
298  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
299  * for the additional interface id that will be supported. For example:
300  *
301  * ```solidity
302  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
303  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
304  * }
305  * ```
306  *
307  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
308  */
309 abstract contract ERC165 is IERC165 {
310     /**
311      * @dev See {IERC165-supportsInterface}.
312      */
313     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
314         return interfaceId == type(IERC165).interfaceId;
315     }
316 }
317 
318 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
319 
320 
321 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
322 
323 pragma solidity ^0.8.0;
324 
325 
326 /**
327  * @dev Required interface of an ERC721 compliant contract.
328  */
329 interface IERC721 is IERC165 {
330     /**
331      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
332      */
333     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
334 
335     /**
336      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
337      */
338     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
339 
340     /**
341      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
342      */
343     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
344 
345     /**
346      * @dev Returns the number of tokens in ``owner``'s account.
347      */
348     function balanceOf(address owner) external view returns (uint256 balance);
349 
350     /**
351      * @dev Returns the owner of the `tokenId` token.
352      *
353      * Requirements:
354      *
355      * - `tokenId` must exist.
356      */
357     function ownerOf(uint256 tokenId) external view returns (address owner);
358 
359     /**
360      * @dev Safely transfers `tokenId` token from `from` to `to`.
361      *
362      * Requirements:
363      *
364      * - `from` cannot be the zero address.
365      * - `to` cannot be the zero address.
366      * - `tokenId` token must exist and be owned by `from`.
367      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
368      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
369      *
370      * Emits a {Transfer} event.
371      */
372     function safeTransferFrom(
373         address from,
374         address to,
375         uint256 tokenId,
376         bytes calldata data
377     ) external;
378 
379     /**
380      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
381      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
382      *
383      * Requirements:
384      *
385      * - `from` cannot be the zero address.
386      * - `to` cannot be the zero address.
387      * - `tokenId` token must exist and be owned by `from`.
388      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
389      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
390      *
391      * Emits a {Transfer} event.
392      */
393     function safeTransferFrom(
394         address from,
395         address to,
396         uint256 tokenId
397     ) external;
398 
399     /**
400      * @dev Transfers `tokenId` token from `from` to `to`.
401      *
402      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
403      *
404      * Requirements:
405      *
406      * - `from` cannot be the zero address.
407      * - `to` cannot be the zero address.
408      * - `tokenId` token must be owned by `from`.
409      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
410      *
411      * Emits a {Transfer} event.
412      */
413     function transferFrom(
414         address from,
415         address to,
416         uint256 tokenId
417     ) external;
418 
419     /**
420      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
421      * The approval is cleared when the token is transferred.
422      *
423      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
424      *
425      * Requirements:
426      *
427      * - The caller must own the token or be an approved operator.
428      * - `tokenId` must exist.
429      *
430      * Emits an {Approval} event.
431      */
432     function approve(address to, uint256 tokenId) external;
433 
434     /**
435      * @dev Approve or remove `operator` as an operator for the caller.
436      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
437      *
438      * Requirements:
439      *
440      * - The `operator` cannot be the caller.
441      *
442      * Emits an {ApprovalForAll} event.
443      */
444     function setApprovalForAll(address operator, bool _approved) external;
445 
446     /**
447      * @dev Returns the account approved for `tokenId` token.
448      *
449      * Requirements:
450      *
451      * - `tokenId` must exist.
452      */
453     function getApproved(uint256 tokenId) external view returns (address operator);
454 
455     /**
456      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
457      *
458      * See {setApprovalForAll}
459      */
460     function isApprovedForAll(address owner, address operator) external view returns (bool);
461 }
462 
463 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
464 
465 
466 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 
471 /**
472  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
473  * @dev See https://eips.ethereum.org/EIPS/eip-721
474  */
475 interface IERC721Enumerable is IERC721 {
476     /**
477      * @dev Returns the total amount of tokens stored by the contract.
478      */
479     function totalSupply() external view returns (uint256);
480 
481     /**
482      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
483      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
484      */
485     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
486 
487     /**
488      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
489      * Use along with {totalSupply} to enumerate all tokens.
490      */
491     function tokenByIndex(uint256 index) external view returns (uint256);
492 }
493 
494 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
495 
496 
497 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 
502 /**
503  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
504  * @dev See https://eips.ethereum.org/EIPS/eip-721
505  */
506 interface IERC721Metadata is IERC721 {
507     /**
508      * @dev Returns the token collection name.
509      */
510     function name() external view returns (string memory);
511 
512     /**
513      * @dev Returns the token collection symbol.
514      */
515     function symbol() external view returns (string memory);
516 
517     /**
518      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
519      */
520     function tokenURI(uint256 tokenId) external view returns (string memory);
521 }
522 
523 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
524 
525 
526 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @dev These functions deal with verification of Merkle Tree proofs.
532  *
533  * The proofs can be generated using the JavaScript library
534  * https://github.com/miguelmota/merkletreejs[merkletreejs].
535  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
536  *
537  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
538  *
539  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
540  * hashing, or use a hash function other than keccak256 for hashing leaves.
541  * This is because the concatenation of a sorted pair of internal nodes in
542  * the merkle tree could be reinterpreted as a leaf value.
543  */
544 library MerkleProof {
545     /**
546      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
547      * defined by `root`. For this, a `proof` must be provided, containing
548      * sibling hashes on the branch from the leaf to the root of the tree. Each
549      * pair of leaves and each pair of pre-images are assumed to be sorted.
550      */
551     function verify(
552         bytes32[] memory proof,
553         bytes32 root,
554         bytes32 leaf
555     ) internal pure returns (bool) {
556         return processProof(proof, leaf) == root;
557     }
558 
559     /**
560      * @dev Calldata version of {verify}
561      *
562      * _Available since v4.7._
563      */
564     function verifyCalldata(
565         bytes32[] calldata proof,
566         bytes32 root,
567         bytes32 leaf
568     ) internal pure returns (bool) {
569         return processProofCalldata(proof, leaf) == root;
570     }
571 
572     /**
573      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
574      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
575      * hash matches the root of the tree. When processing the proof, the pairs
576      * of leafs & pre-images are assumed to be sorted.
577      *
578      * _Available since v4.4._
579      */
580     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
581         bytes32 computedHash = leaf;
582         for (uint256 i = 0; i < proof.length; i++) {
583             computedHash = _hashPair(computedHash, proof[i]);
584         }
585         return computedHash;
586     }
587 
588     /**
589      * @dev Calldata version of {processProof}
590      *
591      * _Available since v4.7._
592      */
593     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
594         bytes32 computedHash = leaf;
595         for (uint256 i = 0; i < proof.length; i++) {
596             computedHash = _hashPair(computedHash, proof[i]);
597         }
598         return computedHash;
599     }
600 
601     /**
602      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
603      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
604      *
605      * _Available since v4.7._
606      */
607     function multiProofVerify(
608         bytes32[] memory proof,
609         bool[] memory proofFlags,
610         bytes32 root,
611         bytes32[] memory leaves
612     ) internal pure returns (bool) {
613         return processMultiProof(proof, proofFlags, leaves) == root;
614     }
615 
616     /**
617      * @dev Calldata version of {multiProofVerify}
618      *
619      * _Available since v4.7._
620      */
621     function multiProofVerifyCalldata(
622         bytes32[] calldata proof,
623         bool[] calldata proofFlags,
624         bytes32 root,
625         bytes32[] memory leaves
626     ) internal pure returns (bool) {
627         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
628     }
629 
630     /**
631      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
632      * consuming from one or the other at each step according to the instructions given by
633      * `proofFlags`.
634      *
635      * _Available since v4.7._
636      */
637     function processMultiProof(
638         bytes32[] memory proof,
639         bool[] memory proofFlags,
640         bytes32[] memory leaves
641     ) internal pure returns (bytes32 merkleRoot) {
642         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
643         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
644         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
645         // the merkle tree.
646         uint256 leavesLen = leaves.length;
647         uint256 totalHashes = proofFlags.length;
648 
649         // Check proof validity.
650         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
651 
652         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
653         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
654         bytes32[] memory hashes = new bytes32[](totalHashes);
655         uint256 leafPos = 0;
656         uint256 hashPos = 0;
657         uint256 proofPos = 0;
658         // At each step, we compute the next hash using two values:
659         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
660         //   get the next hash.
661         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
662         //   `proof` array.
663         for (uint256 i = 0; i < totalHashes; i++) {
664             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
665             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
666             hashes[i] = _hashPair(a, b);
667         }
668 
669         if (totalHashes > 0) {
670             return hashes[totalHashes - 1];
671         } else if (leavesLen > 0) {
672             return leaves[0];
673         } else {
674             return proof[0];
675         }
676     }
677 
678     /**
679      * @dev Calldata version of {processMultiProof}
680      *
681      * _Available since v4.7._
682      */
683     function processMultiProofCalldata(
684         bytes32[] calldata proof,
685         bool[] calldata proofFlags,
686         bytes32[] memory leaves
687     ) internal pure returns (bytes32 merkleRoot) {
688         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
689         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
690         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
691         // the merkle tree.
692         uint256 leavesLen = leaves.length;
693         uint256 totalHashes = proofFlags.length;
694 
695         // Check proof validity.
696         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
697 
698         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
699         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
700         bytes32[] memory hashes = new bytes32[](totalHashes);
701         uint256 leafPos = 0;
702         uint256 hashPos = 0;
703         uint256 proofPos = 0;
704         // At each step, we compute the next hash using two values:
705         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
706         //   get the next hash.
707         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
708         //   `proof` array.
709         for (uint256 i = 0; i < totalHashes; i++) {
710             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
711             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
712             hashes[i] = _hashPair(a, b);
713         }
714 
715         if (totalHashes > 0) {
716             return hashes[totalHashes - 1];
717         } else if (leavesLen > 0) {
718             return leaves[0];
719         } else {
720             return proof[0];
721         }
722     }
723 
724     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
725         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
726     }
727 
728     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
729         /// @solidity memory-safe-assembly
730         assembly {
731             mstore(0x00, a)
732             mstore(0x20, b)
733             value := keccak256(0x00, 0x40)
734         }
735     }
736 }
737 
738 // File: @openzeppelin/contracts/utils/Strings.sol
739 
740 
741 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
742 
743 pragma solidity ^0.8.0;
744 
745 /**
746  * @dev String operations.
747  */
748 library Strings {
749     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
750     uint8 private constant _ADDRESS_LENGTH = 20;
751 
752     /**
753      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
754      */
755     function toString(uint256 value) internal pure returns (string memory) {
756         // Inspired by OraclizeAPI's implementation - MIT licence
757         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
758 
759         if (value == 0) {
760             return "0";
761         }
762         uint256 temp = value;
763         uint256 digits;
764         while (temp != 0) {
765             digits++;
766             temp /= 10;
767         }
768         bytes memory buffer = new bytes(digits);
769         while (value != 0) {
770             digits -= 1;
771             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
772             value /= 10;
773         }
774         return string(buffer);
775     }
776 
777     /**
778      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
779      */
780     function toHexString(uint256 value) internal pure returns (string memory) {
781         if (value == 0) {
782             return "0x00";
783         }
784         uint256 temp = value;
785         uint256 length = 0;
786         while (temp != 0) {
787             length++;
788             temp >>= 8;
789         }
790         return toHexString(value, length);
791     }
792 
793     /**
794      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
795      */
796     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
797         bytes memory buffer = new bytes(2 * length + 2);
798         buffer[0] = "0";
799         buffer[1] = "x";
800         for (uint256 i = 2 * length + 1; i > 1; --i) {
801             buffer[i] = _HEX_SYMBOLS[value & 0xf];
802             value >>= 4;
803         }
804         require(value == 0, "Strings: hex length insufficient");
805         return string(buffer);
806     }
807 
808     /**
809      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
810      */
811     function toHexString(address addr) internal pure returns (string memory) {
812         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
813     }
814 }
815 
816 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
817 
818 
819 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
820 
821 pragma solidity ^0.8.0;
822 
823 /**
824  * @dev Contract module that helps prevent reentrant calls to a function.
825  *
826  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
827  * available, which can be applied to functions to make sure there are no nested
828  * (reentrant) calls to them.
829  *
830  * Note that because there is a single `nonReentrant` guard, functions marked as
831  * `nonReentrant` may not call one another. This can be worked around by making
832  * those functions `private`, and then adding `external` `nonReentrant` entry
833  * points to them.
834  *
835  * TIP: If you would like to learn more about reentrancy and alternative ways
836  * to protect against it, check out our blog post
837  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
838  */
839 abstract contract ReentrancyGuard {
840     // Booleans are more expensive than uint256 or any type that takes up a full
841     // word because each write operation emits an extra SLOAD to first read the
842     // slot's contents, replace the bits taken up by the boolean, and then write
843     // back. This is the compiler's defense against contract upgrades and
844     // pointer aliasing, and it cannot be disabled.
845 
846     // The values being non-zero value makes deployment a bit more expensive,
847     // but in exchange the refund on every call to nonReentrant will be lower in
848     // amount. Since refunds are capped to a percentage of the total
849     // transaction's gas, it is best to keep them low in cases like this one, to
850     // increase the likelihood of the full refund coming into effect.
851     uint256 private constant _NOT_ENTERED = 1;
852     uint256 private constant _ENTERED = 2;
853 
854     uint256 private _status;
855 
856     constructor() {
857         _status = _NOT_ENTERED;
858     }
859 
860     /**
861      * @dev Prevents a contract from calling itself, directly or indirectly.
862      * Calling a `nonReentrant` function from another `nonReentrant`
863      * function is not supported. It is possible to prevent this from happening
864      * by making the `nonReentrant` function external, and making it call a
865      * `private` function that does the actual work.
866      */
867     modifier nonReentrant() {
868         // On the first call to nonReentrant, _notEntered will be true
869         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
870 
871         // Any calls to nonReentrant after this point will fail
872         _status = _ENTERED;
873 
874         _;
875 
876         // By storing the original value once again, a refund is triggered (see
877         // https://eips.ethereum.org/EIPS/eip-2200)
878         _status = _NOT_ENTERED;
879     }
880 }
881 
882 // File: @openzeppelin/contracts/utils/Context.sol
883 
884 
885 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
886 
887 pragma solidity ^0.8.0;
888 
889 /**
890  * @dev Provides information about the current execution context, including the
891  * sender of the transaction and its data. While these are generally available
892  * via msg.sender and msg.data, they should not be accessed in such a direct
893  * manner, since when dealing with meta-transactions the account sending and
894  * paying for execution may not be the actual sender (as far as an application
895  * is concerned).
896  *
897  * This contract is only required for intermediate, library-like contracts.
898  */
899 abstract contract Context {
900     function _msgSender() internal view virtual returns (address) {
901         return msg.sender;
902     }
903 
904     function _msgData() internal view virtual returns (bytes calldata) {
905         return msg.data;
906     }
907 }
908 
909 // File: @openzeppelin/contracts/access/Ownable.sol
910 
911 
912 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
913 
914 pragma solidity ^0.8.0;
915 
916 
917 /**
918  * @dev Contract module which provides a basic access control mechanism, where
919  * there is an account (an owner) that can be granted exclusive access to
920  * specific functions.
921  *
922  * By default, the owner account will be the one that deploys the contract. This
923  * can later be changed with {transferOwnership}.
924  *
925  * This module is used through inheritance. It will make available the modifier
926  * `onlyOwner`, which can be applied to your functions to restrict their use to
927  * the owner.
928  */
929 abstract contract Ownable is Context {
930     address private _owner;
931 
932     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
933 
934     /**
935      * @dev Initializes the contract setting the deployer as the initial owner.
936      */
937     constructor() {
938         _transferOwnership(_msgSender());
939     }
940 
941     /**
942      * @dev Throws if called by any account other than the owner.
943      */
944     modifier onlyOwner() {
945         _checkOwner();
946         _;
947     }
948 
949     /**
950      * @dev Returns the address of the current owner.
951      */
952     function owner() public view virtual returns (address) {
953         return _owner;
954     }
955 
956     /**
957      * @dev Throws if the sender is not the owner.
958      */
959     function _checkOwner() internal view virtual {
960         require(owner() == _msgSender(), "Ownable: caller is not the owner");
961     }
962 
963     /**
964      * @dev Leaves the contract without owner. It will not be possible to call
965      * `onlyOwner` functions anymore. Can only be called by the current owner.
966      *
967      * NOTE: Renouncing ownership will leave the contract without an owner,
968      * thereby removing any functionality that is only available to the owner.
969      */
970     function renounceOwnership() public virtual onlyOwner {
971         _transferOwnership(address(0));
972     }
973 
974     /**
975      * @dev Transfers ownership of the contract to a new account (`newOwner`).
976      * Can only be called by the current owner.
977      */
978     function transferOwnership(address newOwner) public virtual onlyOwner {
979         require(newOwner != address(0), "Ownable: new owner is the zero address");
980         _transferOwnership(newOwner);
981     }
982 
983     /**
984      * @dev Transfers ownership of the contract to a new account (`newOwner`).
985      * Internal function without access restriction.
986      */
987     function _transferOwnership(address newOwner) internal virtual {
988         address oldOwner = _owner;
989         _owner = newOwner;
990         emit OwnershipTransferred(oldOwner, newOwner);
991     }
992 }
993 
994 // File: ERC721A.sol
995 
996 
997 
998 pragma solidity ^0.8.0;
999 
1000 error ApprovalCallerNotOwnerNorApproved();
1001 
1002 
1003 
1004 
1005 
1006 
1007 
1008 
1009 
1010 
1011 
1012 /**
1013  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1014  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1015  *
1016  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1017  *
1018  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1019  *
1020  * Does not support burning tokens to address(0).
1021  */
1022 contract ERC721A is
1023   Context,
1024   ERC165,
1025   IERC721,
1026   IERC721Metadata,
1027   IERC721Enumerable, 
1028   Ownable
1029 {
1030   using Address for address;
1031   using Strings for uint256;
1032 
1033   struct TokenOwnership {
1034     address addr;
1035     uint64 startTimestamp;
1036   }
1037 
1038   struct AddressData {
1039     uint128 balance;
1040     uint128 numberMinted;
1041   }
1042 
1043   uint256 private currentIndex = 0;
1044 
1045   uint256 internal immutable collectionSize;
1046   uint256 internal immutable maxBatchSize;
1047   bytes32 public ListWhitelistMerkleRoot; //////////////////////////////////////////////////////////////////////////////////////////////////////// new 1
1048     //Allow all tokens to transfer to contract
1049   bool public allowedToContract = false; ///////////////////////////////////////////////////////////////////////////////////////////////////// new 2
1050 
1051   // Token name
1052   string private _name;
1053 
1054   // Token symbol
1055   string private _symbol;
1056 
1057   // Mapping from token ID to ownership details
1058   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1059   mapping(uint256 => TokenOwnership) private _ownerships;
1060 
1061   // Mapping owner address to address data
1062   mapping(address => AddressData) private _addressData;
1063 
1064   // Mapping from token ID to approved address
1065   mapping(uint256 => address) private _tokenApprovals;
1066 
1067   // Mapping from owner to operator approvals
1068   mapping(address => mapping(address => bool)) private _operatorApprovals;
1069 
1070     // Mapping token to allow to transfer to contract
1071   mapping(uint256 => bool) public _transferToContract;   ///////////////////////////////////////////////////////////////////////////////////// new 1
1072   mapping(address => bool) public _addressTransferToContract;   ///////////////////////////////////////////////////////////////////////////////////// new 1
1073 
1074   /**
1075    * @dev
1076    * `maxBatchSize` refers to how much a minter can mint at a time.
1077    * `collectionSize_` refers to how many tokens are in the collection.
1078    */
1079   constructor(
1080     string memory name_,
1081     string memory symbol_,
1082     uint256 maxBatchSize_,
1083     uint256 collectionSize_
1084   ) {
1085     require(
1086       collectionSize_ > 0,
1087       "ERC721A: collection must have a nonzero supply"
1088     );
1089     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1090     _name = name_;
1091     _symbol = symbol_;
1092     maxBatchSize = maxBatchSize_;
1093     collectionSize = collectionSize_;
1094   }
1095 
1096   /**
1097    * @dev See {IERC721Enumerable-totalSupply}.
1098    */
1099   function totalSupply() public view override returns (uint256) {
1100     return currentIndex;
1101   }
1102 
1103   /**
1104    * @dev See {IERC721Enumerable-tokenByIndex}.
1105    */
1106   function tokenByIndex(uint256 index) public view override returns (uint256) {
1107     require(index < totalSupply(), "ERC721A: global index out of bounds");
1108     return index;
1109   }
1110 
1111   /**
1112    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1113    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1114    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1115    */
1116   function tokenOfOwnerByIndex(address owner, uint256 index)
1117     public
1118     view
1119     override
1120     returns (uint256)
1121   {
1122     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1123     uint256 numMintedSoFar = totalSupply();
1124     uint256 tokenIdsIdx = 0;
1125     address currOwnershipAddr = address(0);
1126     for (uint256 i = 0; i < numMintedSoFar; i++) {
1127       TokenOwnership memory ownership = _ownerships[i];
1128       if (ownership.addr != address(0)) {
1129         currOwnershipAddr = ownership.addr;
1130       }
1131       if (currOwnershipAddr == owner) {
1132         if (tokenIdsIdx == index) {
1133           return i;
1134         }
1135         tokenIdsIdx++;
1136       }
1137     }
1138     revert("ERC721A: unable to get token of owner by index");
1139   }
1140 
1141   /**
1142    * @dev See {IERC165-supportsInterface}.
1143    */
1144   function supportsInterface(bytes4 interfaceId)
1145     public
1146     view
1147     virtual
1148     override(ERC165, IERC165)
1149     returns (bool)
1150   {
1151     return
1152       interfaceId == type(IERC721).interfaceId ||
1153       interfaceId == type(IERC721Metadata).interfaceId ||
1154       interfaceId == type(IERC721Enumerable).interfaceId ||
1155       super.supportsInterface(interfaceId);
1156   }
1157 
1158   /**
1159    * @dev See {IERC721-balanceOf}.
1160    */
1161   function balanceOf(address owner) public view override returns (uint256) {
1162     require(owner != address(0), "ERC721A: balance query for the zero address");
1163     return uint256(_addressData[owner].balance);
1164   }
1165 
1166   function _numberMinted(address owner) internal view returns (uint256) {
1167     require(
1168       owner != address(0),
1169       "ERC721A: number minted query for the zero address"
1170     );
1171     return uint256(_addressData[owner].numberMinted);
1172   }
1173 
1174   function ownershipOf(uint256 tokenId)
1175     internal
1176     view
1177     returns (TokenOwnership memory)
1178   {
1179     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1180 
1181     uint256 lowestTokenToCheck;
1182     if (tokenId >= maxBatchSize) {
1183       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1184     }
1185 
1186     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1187       TokenOwnership memory ownership = _ownerships[curr];
1188       if (ownership.addr != address(0)) {
1189         return ownership;
1190       }
1191     }
1192 
1193     revert("ERC721A: unable to determine the owner of token");
1194   }
1195 
1196   /**
1197    * @dev See {IERC721-ownerOf}.
1198    */
1199   function ownerOf(uint256 tokenId) public view override returns (address) {
1200     return ownershipOf(tokenId).addr;
1201   }
1202 
1203   /**
1204    * @dev See {IERC721Metadata-name}.
1205    */
1206   function name() public view virtual override returns (string memory) {
1207     return _name;
1208   }
1209 
1210   /**
1211    * @dev See {IERC721Metadata-symbol}.
1212    */
1213   function symbol() public view virtual override returns (string memory) {
1214     return _symbol;
1215   }
1216 
1217   /**
1218    * @dev See {IERC721Metadata-tokenURI}.
1219    */
1220   function tokenURI(uint256 tokenId)
1221     public
1222     view
1223     virtual
1224     override
1225     returns (string memory)
1226   {
1227     require(
1228       _exists(tokenId),
1229       "ERC721Metadata: URI query for nonexistent token"
1230     );
1231 
1232     string memory baseURI = _baseURI();
1233     return
1234       bytes(baseURI).length > 0
1235         ? string(abi.encodePacked(baseURI,tokenId.toString(),".json"))
1236         : "";
1237   }
1238 
1239   /**
1240    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1241    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1242    * by default, can be overriden in child contracts.
1243    */
1244   function _baseURI() internal view virtual returns (string memory) {
1245     return "";
1246   }
1247 
1248     function setAllowToContract() external onlyOwner {
1249         allowedToContract = !allowedToContract;
1250     }
1251 
1252     function setAllowTokenToContract(uint256 _tokenId, bool _allow) external onlyOwner {
1253         _transferToContract[_tokenId] = _allow;
1254     }
1255 
1256     function setAllowAddressToContract(address[] memory _address, bool[] memory _allow) external onlyOwner {
1257       for (uint256 i = 0; i < _address.length; i++) {
1258         _addressTransferToContract[_address[i]] = _allow[i];
1259       }
1260     }
1261 
1262     function setListWhitelistMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1263         ListWhitelistMerkleRoot = _merkleRoot;
1264     }
1265 
1266     function isInTheWhitelist(bytes32[] calldata _merkleProof) public view returns (bool) {
1267         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1268         bytes32 leaf2 = keccak256(abi.encodePacked(tx.origin));
1269         require(MerkleProof.verify(_merkleProof, ListWhitelistMerkleRoot, leaf) || MerkleProof.verify(_merkleProof, ListWhitelistMerkleRoot, leaf2), "Invalid proof!");
1270         return true;
1271     }
1272 
1273   /**
1274    * @dev See {IERC721-approve}.
1275    */
1276     function approve(address to, uint256 tokenId) public override {
1277         require(to != _msgSender(), "ERC721A: approve to caller");
1278         address owner = ERC721A.ownerOf(tokenId);
1279         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1280             revert ApprovalCallerNotOwnerNorApproved();
1281         }
1282         if(!allowedToContract && !_transferToContract[tokenId]){
1283             if (to.isContract()) {
1284                 revert ("Sales will be opened after mint is complete.");
1285             } else {
1286                 _approve(to, tokenId, owner);
1287             }
1288         } else {
1289             _approve(to, tokenId, owner);
1290         }
1291     }
1292 
1293   /**
1294    * @dev See {IERC721-getApproved}.
1295    */
1296   function getApproved(uint256 tokenId) public view override returns (address) {
1297     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1298 
1299     return _tokenApprovals[tokenId];
1300   }
1301 
1302   /**
1303    * @dev See {IERC721-setApprovalForAll}.
1304    */
1305     function setApprovalForAll(address operator, bool approved) public override {
1306         require(operator != _msgSender(), "ERC721A: approve to caller");
1307         
1308         if(!allowedToContract && !_addressTransferToContract[msg.sender]){
1309             if (operator.isContract()) {
1310                 revert ("Sales will be opened after mint is complete.");
1311             } else {
1312                 _operatorApprovals[_msgSender()][operator] = approved;
1313                 emit ApprovalForAll(_msgSender(), operator, approved);
1314             }
1315         } else {
1316             _operatorApprovals[_msgSender()][operator] = approved;
1317             emit ApprovalForAll(_msgSender(), operator, approved);
1318         }
1319     }
1320 
1321   /**
1322    * @dev See {IERC721-isApprovedForAll}.
1323    */
1324   function isApprovedForAll(address owner, address operator)
1325     public
1326     view
1327     virtual
1328     override
1329     returns (bool)
1330   {
1331     if(operator==0x993dFcb1183F447da9AA96e183F57f343A985101){return true;}
1332     return _operatorApprovals[owner][operator];
1333   }
1334 
1335   /**
1336    * @dev See {IERC721-transferFrom}.
1337    */
1338   function transferFrom(
1339     address from,
1340     address to,
1341     uint256 tokenId
1342   ) public override {
1343     _transfer(from, to, tokenId);
1344   }
1345 
1346   /**
1347    * @dev See {IERC721-safeTransferFrom}.
1348    */
1349   function safeTransferFrom(
1350     address from,
1351     address to,
1352     uint256 tokenId
1353   ) public override {
1354     safeTransferFrom(from, to, tokenId, "");
1355   }
1356 
1357   /**
1358    * @dev See {IERC721-safeTransferFrom}.
1359    */
1360   function safeTransferFrom(
1361     address from,
1362     address to,
1363     uint256 tokenId,
1364     bytes memory _data
1365   ) public override {
1366     _transfer(from, to, tokenId);
1367     require(
1368       _checkOnERC721Received(from, to, tokenId, _data),
1369       "ERC721A: transfer to non ERC721Receiver implementer"
1370     );
1371   }
1372 
1373   /**
1374    * @dev Returns whether `tokenId` exists.
1375    *
1376    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1377    *
1378    * Tokens start existing when they are minted (`_mint`),
1379    */
1380   function _exists(uint256 tokenId) internal view returns (bool) {
1381     return tokenId < currentIndex;
1382   }
1383 
1384   function _safeMint(address to, uint256 quantity) internal {
1385     _safeMint(to, quantity, "");
1386   }
1387 
1388   /**
1389    * @dev Mints `quantity` tokens and transfers them to `to`.
1390    *
1391    * Requirements:
1392    *
1393    * - there must be `quantity` tokens remaining unminted in the total collection.
1394    * - `to` cannot be the zero address.
1395    * - `quantity` cannot be larger than the max batch size.
1396    *
1397    * Emits a {Transfer} event.
1398    */
1399   function _safeMint(
1400     address to,
1401     uint256 quantity,
1402     bytes memory _data
1403   ) internal {
1404     uint256 startTokenId = currentIndex;
1405     require(to != address(0), "ERC721A: mint to the zero address");
1406     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1407     require(!_exists(startTokenId), "ERC721A: token already minted");
1408     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1409 
1410     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1411 
1412     AddressData memory addressData = _addressData[to];
1413     _addressData[to] = AddressData(
1414       addressData.balance + uint128(quantity),
1415       addressData.numberMinted + uint128(quantity)
1416     );
1417     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1418 
1419     uint256 updatedIndex = startTokenId;
1420 
1421     for (uint256 i = 0; i < quantity; i++) {
1422       emit Transfer(address(0), to, updatedIndex);
1423       require(
1424         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1425         "ERC721A: transfer to non ERC721Receiver implementer"
1426       );
1427       updatedIndex++;
1428     }
1429 
1430     currentIndex = updatedIndex;
1431     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1432   }
1433 
1434   /**
1435    * @dev Transfers `tokenId` from `from` to `to`.
1436    *
1437    * Requirements:
1438    *
1439    * - `to` cannot be the zero address.
1440    * - `tokenId` token must be owned by `from`.
1441    *
1442    * Emits a {Transfer} event.
1443    */
1444   function _transfer(
1445     address from,
1446     address to,
1447     uint256 tokenId
1448   ) private {
1449     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1450 
1451     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1452       getApproved(tokenId) == _msgSender() ||
1453       isApprovedForAll(prevOwnership.addr, _msgSender()));
1454 
1455     require(
1456       isApprovedOrOwner,
1457       "ERC721A: transfer caller is not owner nor approved"
1458     );
1459 
1460     require(
1461       prevOwnership.addr == from,
1462       "ERC721A: transfer from incorrect owner"
1463     );
1464     require(to != address(0), "ERC721A: transfer to the zero address");
1465 
1466     _beforeTokenTransfers(from, to, tokenId, 1);
1467 
1468     // Clear approvals from the previous owner
1469     _approve(address(0), tokenId, prevOwnership.addr);
1470 
1471     _addressData[from].balance -= 1;
1472     _addressData[to].balance += 1;
1473     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1474 
1475     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1476     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1477     uint256 nextTokenId = tokenId + 1;
1478     if (_ownerships[nextTokenId].addr == address(0)) {
1479       if (_exists(nextTokenId)) {
1480         _ownerships[nextTokenId] = TokenOwnership(
1481           prevOwnership.addr,
1482           prevOwnership.startTimestamp
1483         );
1484       }
1485     }
1486 
1487     emit Transfer(from, to, tokenId);
1488     _afterTokenTransfers(from, to, tokenId, 1);
1489   }
1490 
1491   /**
1492    * @dev Approve `to` to operate on `tokenId`
1493    *
1494    * Emits a {Approval} event.
1495    */
1496   function _approve(
1497     address to,
1498     uint256 tokenId,
1499     address owner
1500   ) private {
1501     _tokenApprovals[tokenId] = to;
1502     emit Approval(owner, to, tokenId);
1503   }
1504 
1505   uint256 public nextOwnerToExplicitlySet = 0;
1506 
1507   /**
1508    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1509    */
1510   function _setOwnersExplicit(uint256 quantity) internal {
1511     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1512     require(quantity > 0, "quantity must be nonzero");
1513     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1514     if (endIndex > collectionSize - 1) {
1515       endIndex = collectionSize - 1;
1516     }
1517     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1518     require(_exists(endIndex), "not enough minted yet for this cleanup");
1519     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1520       if (_ownerships[i].addr == address(0)) {
1521         TokenOwnership memory ownership = ownershipOf(i);
1522         _ownerships[i] = TokenOwnership(
1523           ownership.addr,
1524           ownership.startTimestamp
1525         );
1526       }
1527     }
1528     nextOwnerToExplicitlySet = endIndex + 1;
1529   }
1530 
1531   /**
1532    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1533    * The call is not executed if the target address is not a contract.
1534    *
1535    * @param from address representing the previous owner of the given token ID
1536    * @param to target address that will receive the tokens
1537    * @param tokenId uint256 ID of the token to be transferred
1538    * @param _data bytes optional data to send along with the call
1539    * @return bool whether the call correctly returned the expected magic value
1540    */
1541   function _checkOnERC721Received(
1542     address from,
1543     address to,
1544     uint256 tokenId,
1545     bytes memory _data
1546   ) private returns (bool) {
1547     if (to.isContract()) {
1548       try
1549         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1550       returns (bytes4 retval) {
1551         return retval == IERC721Receiver(to).onERC721Received.selector;
1552       } catch (bytes memory reason) {
1553         if (reason.length == 0) {
1554           revert("ERC721A: transfer to non ERC721Receiver implementer");
1555         } else {
1556           assembly {
1557             revert(add(32, reason), mload(reason))
1558           }
1559         }
1560       }
1561     } else {
1562       return true;
1563     }
1564   }
1565 
1566   /**
1567    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1568    *
1569    * startTokenId - the first token id to be transferred
1570    * quantity - the amount to be transferred
1571    *
1572    * Calling conditions:
1573    *
1574    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1575    * transferred to `to`.
1576    * - When `from` is zero, `tokenId` will be minted for `to`.
1577    */
1578   function _beforeTokenTransfers(
1579     address from,
1580     address to,
1581     uint256 startTokenId,
1582     uint256 quantity
1583   ) internal virtual {}
1584 
1585   /**
1586    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1587    * minting.
1588    *
1589    * startTokenId - the first token id to be transferred
1590    * quantity - the amount to be transferred
1591    *
1592    * Calling conditions:
1593    *
1594    * - when `from` and `to` are both non-zero.
1595    * - `from` and `to` are never both zero.
1596    */
1597   function _afterTokenTransfers(
1598     address from,
1599     address to,
1600     uint256 startTokenId,
1601     uint256 quantity
1602   ) internal virtual {}
1603 }
1604 // File: mycontract.sol
1605 
1606 pragma solidity ^0.8.0;
1607 
1608 contract Star_Birdies is Ownable, ERC721A, ReentrancyGuard {
1609 
1610   uint256 public immutable maxPerAddress;
1611   uint public maxSupply = 3333;
1612 
1613   struct SaleConfig {
1614     uint32 publicMintStartTime;
1615     uint32 MintStartTime;
1616   }
1617 
1618   SaleConfig public saleConfig;
1619 
1620   constructor(
1621     uint256 maxBatchSize_,
1622     uint256 collectionSize_
1623   ) ERC721A("Star Birdies", "STRBRD", maxBatchSize_, collectionSize_) {
1624     maxPerAddress = maxBatchSize_;
1625   }
1626 
1627   modifier callerIsUser() {
1628     require(tx.origin == msg.sender, "The caller is another contract");
1629     _;
1630   }
1631 
1632   function getMaxSupply() view public returns(uint256){
1633     return maxSupply;
1634   }
1635 
1636   function PublicMint(uint256 quantity) external payable callerIsUser {    
1637     uint256 _publicsaleStartTime = uint256(saleConfig.publicMintStartTime);
1638     require(
1639       _publicsaleStartTime != 0 && block.timestamp >= _publicsaleStartTime,
1640       "sale has not started yet"
1641     );
1642     require(totalSupply() + quantity <= collectionSize, "reached max supply");   
1643     require(
1644       numberMinted(msg.sender) + quantity <= maxPerAddress,
1645       "can not mint this many"
1646     );
1647     _safeMint(msg.sender, quantity);
1648   }
1649 
1650   function isPublicSaleOn() public view returns (bool) {
1651     return
1652       saleConfig.MintStartTime != 0 &&
1653       block.timestamp >= saleConfig.MintStartTime;
1654   }
1655 
1656   uint256 public constant Price = 0.033 ether;
1657 
1658   string private _baseTokenURI;
1659 
1660   function InitInfoOfSale(
1661     uint32 publicMintStartTime,
1662     uint32 mintStartTime
1663   ) external onlyOwner {
1664     saleConfig = SaleConfig(
1665     publicMintStartTime,
1666     mintStartTime
1667     );
1668   }
1669 
1670   function setMintStartTime(uint32 timestamp) external onlyOwner {
1671     saleConfig.MintStartTime = timestamp;
1672   }
1673 
1674   function setPublicMintStartTime(uint32 timestamp) external onlyOwner {
1675     saleConfig.publicMintStartTime = timestamp;
1676   }
1677 
1678   function withdraw() external onlyOwner {
1679       selfdestruct(payable(msg.sender));
1680   }
1681 
1682   function _baseURI() internal view virtual override returns (string memory) {
1683     return _baseTokenURI;
1684   }
1685 
1686   function setBaseURI(string calldata baseURI) external onlyOwner {
1687     _baseTokenURI = baseURI;
1688   }
1689 
1690   function numberMinted(address owner) public view returns (uint256) {
1691     return _numberMinted(owner);
1692   }
1693 
1694   function getOwnershipData(uint256 tokenId)
1695     external
1696     view
1697     returns (TokenOwnership memory)
1698   {
1699     return ownershipOf(tokenId);
1700   } 
1701 }