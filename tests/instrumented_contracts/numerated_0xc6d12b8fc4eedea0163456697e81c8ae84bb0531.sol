1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Address.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
6 
7 pragma solidity ^0.8.1;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      *
30      * [IMPORTANT]
31      * ====
32      * You shouldn't rely on `isContract` to protect against flash loan attacks!
33      *
34      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
35      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
36      * constructor.
37      * ====
38      */
39     function isContract(address account) internal view returns (bool) {
40         // This method relies on extcodesize/address.code.length, which returns 0
41         // for contracts in construction, since the code is only stored at the end
42         // of the constructor execution.
43 
44         return account.code.length > 0;
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      */
63     function sendValue(address payable recipient, uint256 amount) internal {
64         require(address(this).balance >= amount, "Address: insufficient balance");
65 
66         (bool success, ) = recipient.call{value: amount}("");
67         require(success, "Address: unable to send value, recipient may have reverted");
68     }
69 
70     /**
71      * @dev Performs a Solidity function call using a low level `call`. A
72      * plain `call` is an unsafe replacement for a function call: use this
73      * function instead.
74      *
75      * If `target` reverts with a revert reason, it is bubbled up by this
76      * function (like regular Solidity function calls).
77      *
78      * Returns the raw returned data. To convert to the expected return value,
79      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
80      *
81      * Requirements:
82      *
83      * - `target` must be a contract.
84      * - calling `target` with `data` must not revert.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
89         return functionCall(target, data, "Address: low-level call failed");
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
94      * `errorMessage` as a fallback revert reason when `target` reverts.
95      *
96      * _Available since v3.1._
97      */
98     function functionCall(
99         address target,
100         bytes memory data,
101         string memory errorMessage
102     ) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, 0, errorMessage);
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
108      * but also transferring `value` wei to `target`.
109      *
110      * Requirements:
111      *
112      * - the calling contract must have an ETH balance of at least `value`.
113      * - the called Solidity function must be `payable`.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(
118         address target,
119         bytes memory data,
120         uint256 value
121     ) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
127      * with `errorMessage` as a fallback revert reason when `target` reverts.
128      *
129      * _Available since v3.1._
130      */
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value,
135         string memory errorMessage
136     ) internal returns (bytes memory) {
137         require(address(this).balance >= value, "Address: insufficient balance for call");
138         require(isContract(target), "Address: call to non-contract");
139 
140         (bool success, bytes memory returndata) = target.call{value: value}(data);
141         return verifyCallResult(success, returndata, errorMessage);
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
146      * but performing a static call.
147      *
148      * _Available since v3.3._
149      */
150     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
151         return functionStaticCall(target, data, "Address: low-level static call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
156      * but performing a static call.
157      *
158      * _Available since v3.3._
159      */
160     function functionStaticCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal view returns (bytes memory) {
165         require(isContract(target), "Address: static call to non-contract");
166 
167         (bool success, bytes memory returndata) = target.staticcall(data);
168         return verifyCallResult(success, returndata, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but performing a delegate call.
174      *
175      * _Available since v3.4._
176      */
177     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
178         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
183      * but performing a delegate call.
184      *
185      * _Available since v3.4._
186      */
187     function functionDelegateCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal returns (bytes memory) {
192         require(isContract(target), "Address: delegate call to non-contract");
193 
194         (bool success, bytes memory returndata) = target.delegatecall(data);
195         return verifyCallResult(success, returndata, errorMessage);
196     }
197 
198     /**
199      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
200      * revert reason using the provided one.
201      *
202      * _Available since v4.3._
203      */
204     function verifyCallResult(
205         bool success,
206         bytes memory returndata,
207         string memory errorMessage
208     ) internal pure returns (bytes memory) {
209         if (success) {
210             return returndata;
211         } else {
212             // Look for revert reason and bubble it up if present
213             if (returndata.length > 0) {
214                 // The easiest way to bubble the revert reason is using memory via assembly
215                 /// @solidity memory-safe-assembly
216                 assembly {
217                     let returndata_size := mload(returndata)
218                     revert(add(32, returndata), returndata_size)
219                 }
220             } else {
221                 revert(errorMessage);
222             }
223         }
224     }
225 }
226 
227 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
228 
229 
230 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @title ERC721 token receiver interface
236  * @dev Interface for any contract that wants to support safeTransfers
237  * from ERC721 asset contracts.
238  */
239 interface IERC721Receiver {
240     /**
241      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
242      * by `operator` from `from`, this function is called.
243      *
244      * It must return its Solidity selector to confirm the token transfer.
245      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
246      *
247      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
248      */
249     function onERC721Received(
250         address operator,
251         address from,
252         uint256 tokenId,
253         bytes calldata data
254     ) external returns (bytes4);
255 }
256 
257 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
258 
259 
260 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 /**
265  * @dev Interface of the ERC165 standard, as defined in the
266  * https://eips.ethereum.org/EIPS/eip-165[EIP].
267  *
268  * Implementers can declare support of contract interfaces, which can then be
269  * queried by others ({ERC165Checker}).
270  *
271  * For an implementation, see {ERC165}.
272  */
273 interface IERC165 {
274     /**
275      * @dev Returns true if this contract implements the interface defined by
276      * `interfaceId`. See the corresponding
277      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
278      * to learn more about how these ids are created.
279      *
280      * This function call must use less than 30 000 gas.
281      */
282     function supportsInterface(bytes4 interfaceId) external view returns (bool);
283 }
284 
285 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
286 
287 
288 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
289 
290 pragma solidity ^0.8.0;
291 
292 
293 /**
294  * @dev Implementation of the {IERC165} interface.
295  *
296  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
297  * for the additional interface id that will be supported. For example:
298  *
299  * ```solidity
300  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
301  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
302  * }
303  * ```
304  *
305  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
306  */
307 abstract contract ERC165 is IERC165 {
308     /**
309      * @dev See {IERC165-supportsInterface}.
310      */
311     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
312         return interfaceId == type(IERC165).interfaceId;
313     }
314 }
315 
316 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
317 
318 
319 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 
324 /**
325  * @dev Required interface of an ERC721 compliant contract.
326  */
327 interface IERC721 is IERC165 {
328     /**
329      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
330      */
331     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
332 
333     /**
334      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
335      */
336     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
337 
338     /**
339      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
340      */
341     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
342 
343     /**
344      * @dev Returns the number of tokens in ``owner``'s account.
345      */
346     function balanceOf(address owner) external view returns (uint256 balance);
347 
348     /**
349      * @dev Returns the owner of the `tokenId` token.
350      *
351      * Requirements:
352      *
353      * - `tokenId` must exist.
354      */
355     function ownerOf(uint256 tokenId) external view returns (address owner);
356 
357     /**
358      * @dev Safely transfers `tokenId` token from `from` to `to`.
359      *
360      * Requirements:
361      *
362      * - `from` cannot be the zero address.
363      * - `to` cannot be the zero address.
364      * - `tokenId` token must exist and be owned by `from`.
365      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
366      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
367      *
368      * Emits a {Transfer} event.
369      */
370     function safeTransferFrom(
371         address from,
372         address to,
373         uint256 tokenId,
374         bytes calldata data
375     ) external;
376 
377     /**
378      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
379      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
380      *
381      * Requirements:
382      *
383      * - `from` cannot be the zero address.
384      * - `to` cannot be the zero address.
385      * - `tokenId` token must exist and be owned by `from`.
386      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
387      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
388      *
389      * Emits a {Transfer} event.
390      */
391     function safeTransferFrom(
392         address from,
393         address to,
394         uint256 tokenId
395     ) external;
396 
397     /**
398      * @dev Transfers `tokenId` token from `from` to `to`.
399      *
400      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
401      *
402      * Requirements:
403      *
404      * - `from` cannot be the zero address.
405      * - `to` cannot be the zero address.
406      * - `tokenId` token must be owned by `from`.
407      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
408      *
409      * Emits a {Transfer} event.
410      */
411     function transferFrom(
412         address from,
413         address to,
414         uint256 tokenId
415     ) external;
416 
417     /**
418      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
419      * The approval is cleared when the token is transferred.
420      *
421      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
422      *
423      * Requirements:
424      *
425      * - The caller must own the token or be an approved operator.
426      * - `tokenId` must exist.
427      *
428      * Emits an {Approval} event.
429      */
430     function approve(address to, uint256 tokenId) external;
431 
432     /**
433      * @dev Approve or remove `operator` as an operator for the caller.
434      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
435      *
436      * Requirements:
437      *
438      * - The `operator` cannot be the caller.
439      *
440      * Emits an {ApprovalForAll} event.
441      */
442     function setApprovalForAll(address operator, bool _approved) external;
443 
444     /**
445      * @dev Returns the account approved for `tokenId` token.
446      *
447      * Requirements:
448      *
449      * - `tokenId` must exist.
450      */
451     function getApproved(uint256 tokenId) external view returns (address operator);
452 
453     /**
454      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
455      *
456      * See {setApprovalForAll}
457      */
458     function isApprovedForAll(address owner, address operator) external view returns (bool);
459 }
460 
461 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
462 
463 
464 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 
469 /**
470  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
471  * @dev See https://eips.ethereum.org/EIPS/eip-721
472  */
473 interface IERC721Enumerable is IERC721 {
474     /**
475      * @dev Returns the total amount of tokens stored by the contract.
476      */
477     function totalSupply() external view returns (uint256);
478 
479     /**
480      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
481      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
482      */
483     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
484 
485     /**
486      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
487      * Use along with {totalSupply} to enumerate all tokens.
488      */
489     function tokenByIndex(uint256 index) external view returns (uint256);
490 }
491 
492 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
493 
494 
495 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 
500 /**
501  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
502  * @dev See https://eips.ethereum.org/EIPS/eip-721
503  */
504 interface IERC721Metadata is IERC721 {
505     /**
506      * @dev Returns the token collection name.
507      */
508     function name() external view returns (string memory);
509 
510     /**
511      * @dev Returns the token collection symbol.
512      */
513     function symbol() external view returns (string memory);
514 
515     /**
516      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
517      */
518     function tokenURI(uint256 tokenId) external view returns (string memory);
519 }
520 
521 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
522 
523 
524 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 /**
529  * @dev These functions deal with verification of Merkle Tree proofs.
530  *
531  * The proofs can be generated using the JavaScript library
532  * https://github.com/miguelmota/merkletreejs[merkletreejs].
533  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
534  *
535  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
536  *
537  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
538  * hashing, or use a hash function other than keccak256 for hashing leaves.
539  * This is because the concatenation of a sorted pair of internal nodes in
540  * the merkle tree could be reinterpreted as a leaf value.
541  */
542 library MerkleProof {
543     /**
544      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
545      * defined by `root`. For this, a `proof` must be provided, containing
546      * sibling hashes on the branch from the leaf to the root of the tree. Each
547      * pair of leaves and each pair of pre-images are assumed to be sorted.
548      */
549     function verify(
550         bytes32[] memory proof,
551         bytes32 root,
552         bytes32 leaf
553     ) internal pure returns (bool) {
554         return processProof(proof, leaf) == root;
555     }
556 
557     /**
558      * @dev Calldata version of {verify}
559      *
560      * _Available since v4.7._
561      */
562     function verifyCalldata(
563         bytes32[] calldata proof,
564         bytes32 root,
565         bytes32 leaf
566     ) internal pure returns (bool) {
567         return processProofCalldata(proof, leaf) == root;
568     }
569 
570     /**
571      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
572      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
573      * hash matches the root of the tree. When processing the proof, the pairs
574      * of leafs & pre-images are assumed to be sorted.
575      *
576      * _Available since v4.4._
577      */
578     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
579         bytes32 computedHash = leaf;
580         for (uint256 i = 0; i < proof.length; i++) {
581             computedHash = _hashPair(computedHash, proof[i]);
582         }
583         return computedHash;
584     }
585 
586     /**
587      * @dev Calldata version of {processProof}
588      *
589      * _Available since v4.7._
590      */
591     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
592         bytes32 computedHash = leaf;
593         for (uint256 i = 0; i < proof.length; i++) {
594             computedHash = _hashPair(computedHash, proof[i]);
595         }
596         return computedHash;
597     }
598 
599     /**
600      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
601      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
602      *
603      * _Available since v4.7._
604      */
605     function multiProofVerify(
606         bytes32[] memory proof,
607         bool[] memory proofFlags,
608         bytes32 root,
609         bytes32[] memory leaves
610     ) internal pure returns (bool) {
611         return processMultiProof(proof, proofFlags, leaves) == root;
612     }
613 
614     /**
615      * @dev Calldata version of {multiProofVerify}
616      *
617      * _Available since v4.7._
618      */
619     function multiProofVerifyCalldata(
620         bytes32[] calldata proof,
621         bool[] calldata proofFlags,
622         bytes32 root,
623         bytes32[] memory leaves
624     ) internal pure returns (bool) {
625         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
626     }
627 
628     /**
629      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
630      * consuming from one or the other at each step according to the instructions given by
631      * `proofFlags`.
632      *
633      * _Available since v4.7._
634      */
635     function processMultiProof(
636         bytes32[] memory proof,
637         bool[] memory proofFlags,
638         bytes32[] memory leaves
639     ) internal pure returns (bytes32 merkleRoot) {
640         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
641         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
642         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
643         // the merkle tree.
644         uint256 leavesLen = leaves.length;
645         uint256 totalHashes = proofFlags.length;
646 
647         // Check proof validity.
648         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
649 
650         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
651         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
652         bytes32[] memory hashes = new bytes32[](totalHashes);
653         uint256 leafPos = 0;
654         uint256 hashPos = 0;
655         uint256 proofPos = 0;
656         // At each step, we compute the next hash using two values:
657         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
658         //   get the next hash.
659         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
660         //   `proof` array.
661         for (uint256 i = 0; i < totalHashes; i++) {
662             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
663             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
664             hashes[i] = _hashPair(a, b);
665         }
666 
667         if (totalHashes > 0) {
668             return hashes[totalHashes - 1];
669         } else if (leavesLen > 0) {
670             return leaves[0];
671         } else {
672             return proof[0];
673         }
674     }
675 
676     /**
677      * @dev Calldata version of {processMultiProof}
678      *
679      * _Available since v4.7._
680      */
681     function processMultiProofCalldata(
682         bytes32[] calldata proof,
683         bool[] calldata proofFlags,
684         bytes32[] memory leaves
685     ) internal pure returns (bytes32 merkleRoot) {
686         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
687         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
688         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
689         // the merkle tree.
690         uint256 leavesLen = leaves.length;
691         uint256 totalHashes = proofFlags.length;
692 
693         // Check proof validity.
694         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
695 
696         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
697         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
698         bytes32[] memory hashes = new bytes32[](totalHashes);
699         uint256 leafPos = 0;
700         uint256 hashPos = 0;
701         uint256 proofPos = 0;
702         // At each step, we compute the next hash using two values:
703         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
704         //   get the next hash.
705         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
706         //   `proof` array.
707         for (uint256 i = 0; i < totalHashes; i++) {
708             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
709             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
710             hashes[i] = _hashPair(a, b);
711         }
712 
713         if (totalHashes > 0) {
714             return hashes[totalHashes - 1];
715         } else if (leavesLen > 0) {
716             return leaves[0];
717         } else {
718             return proof[0];
719         }
720     }
721 
722     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
723         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
724     }
725 
726     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
727         /// @solidity memory-safe-assembly
728         assembly {
729             mstore(0x00, a)
730             mstore(0x20, b)
731             value := keccak256(0x00, 0x40)
732         }
733     }
734 }
735 
736 // File: @openzeppelin/contracts/utils/Strings.sol
737 
738 
739 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
740 
741 pragma solidity ^0.8.0;
742 
743 /**
744  * @dev String operations.
745  */
746 library Strings {
747     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
748     uint8 private constant _ADDRESS_LENGTH = 20;
749 
750     /**
751      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
752      */
753     function toString(uint256 value) internal pure returns (string memory) {
754         // Inspired by OraclizeAPI's implementation - MIT licence
755         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
756 
757         if (value == 0) {
758             return "0";
759         }
760         uint256 temp = value;
761         uint256 digits;
762         while (temp != 0) {
763             digits++;
764             temp /= 10;
765         }
766         bytes memory buffer = new bytes(digits);
767         while (value != 0) {
768             digits -= 1;
769             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
770             value /= 10;
771         }
772         return string(buffer);
773     }
774 
775     /**
776      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
777      */
778     function toHexString(uint256 value) internal pure returns (string memory) {
779         if (value == 0) {
780             return "0x00";
781         }
782         uint256 temp = value;
783         uint256 length = 0;
784         while (temp != 0) {
785             length++;
786             temp >>= 8;
787         }
788         return toHexString(value, length);
789     }
790 
791     /**
792      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
793      */
794     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
795         bytes memory buffer = new bytes(2 * length + 2);
796         buffer[0] = "0";
797         buffer[1] = "x";
798         for (uint256 i = 2 * length + 1; i > 1; --i) {
799             buffer[i] = _HEX_SYMBOLS[value & 0xf];
800             value >>= 4;
801         }
802         require(value == 0, "Strings: hex length insufficient");
803         return string(buffer);
804     }
805 
806     /**
807      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
808      */
809     function toHexString(address addr) internal pure returns (string memory) {
810         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
811     }
812 }
813 
814 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
815 
816 
817 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
818 
819 pragma solidity ^0.8.0;
820 
821 /**
822  * @dev Contract module that helps prevent reentrant calls to a function.
823  *
824  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
825  * available, which can be applied to functions to make sure there are no nested
826  * (reentrant) calls to them.
827  *
828  * Note that because there is a single `nonReentrant` guard, functions marked as
829  * `nonReentrant` may not call one another. This can be worked around by making
830  * those functions `private`, and then adding `external` `nonReentrant` entry
831  * points to them.
832  *
833  * TIP: If you would like to learn more about reentrancy and alternative ways
834  * to protect against it, check out our blog post
835  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
836  */
837 abstract contract ReentrancyGuard {
838     // Booleans are more expensive than uint256 or any type that takes up a full
839     // word because each write operation emits an extra SLOAD to first read the
840     // slot's contents, replace the bits taken up by the boolean, and then write
841     // back. This is the compiler's defense against contract upgrades and
842     // pointer aliasing, and it cannot be disabled.
843 
844     // The values being non-zero value makes deployment a bit more expensive,
845     // but in exchange the refund on every call to nonReentrant will be lower in
846     // amount. Since refunds are capped to a percentage of the total
847     // transaction's gas, it is best to keep them low in cases like this one, to
848     // increase the likelihood of the full refund coming into effect.
849     uint256 private constant _NOT_ENTERED = 1;
850     uint256 private constant _ENTERED = 2;
851 
852     uint256 private _status;
853 
854     constructor() {
855         _status = _NOT_ENTERED;
856     }
857 
858     /**
859      * @dev Prevents a contract from calling itself, directly or indirectly.
860      * Calling a `nonReentrant` function from another `nonReentrant`
861      * function is not supported. It is possible to prevent this from happening
862      * by making the `nonReentrant` function external, and making it call a
863      * `private` function that does the actual work.
864      */
865     modifier nonReentrant() {
866         // On the first call to nonReentrant, _notEntered will be true
867         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
868 
869         // Any calls to nonReentrant after this point will fail
870         _status = _ENTERED;
871 
872         _;
873 
874         // By storing the original value once again, a refund is triggered (see
875         // https://eips.ethereum.org/EIPS/eip-2200)
876         _status = _NOT_ENTERED;
877     }
878 }
879 
880 // File: @openzeppelin/contracts/utils/Context.sol
881 
882 
883 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
884 
885 pragma solidity ^0.8.0;
886 
887 /**
888  * @dev Provides information about the current execution context, including the
889  * sender of the transaction and its data. While these are generally available
890  * via msg.sender and msg.data, they should not be accessed in such a direct
891  * manner, since when dealing with meta-transactions the account sending and
892  * paying for execution may not be the actual sender (as far as an application
893  * is concerned).
894  *
895  * This contract is only required for intermediate, library-like contracts.
896  */
897 abstract contract Context {
898     function _msgSender() internal view virtual returns (address) {
899         return msg.sender;
900     }
901 
902     function _msgData() internal view virtual returns (bytes calldata) {
903         return msg.data;
904     }
905 }
906 
907 // File: contracts/ERC721A.sol
908 
909 
910 
911 pragma solidity ^0.8.0;
912 
913 
914 
915 
916 
917 
918 
919 
920 
921 /**
922  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
923  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
924  *
925  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
926  *
927  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
928  *
929  * Does not support burning tokens to address(0).
930  */
931 contract ERC721A is
932   Context,
933   ERC165,
934   IERC721,
935   IERC721Metadata,
936   IERC721Enumerable
937 {
938   using Address for address;
939   using Strings for uint256;
940 
941   struct TokenOwnership {
942     address addr;
943     uint64 startTimestamp;
944   }
945 
946   struct AddressData {
947     uint128 balance;
948     uint128 numberMinted;
949   }
950 
951   uint256 private currentIndex = 0;
952 
953   uint256 internal immutable collectionSize;
954   uint256 internal immutable maxBatchSize;
955 
956   // Token name
957   string private _name;
958 
959   // Token symbol
960   string private _symbol;
961 
962   // Mapping from token ID to ownership details
963   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
964   mapping(uint256 => TokenOwnership) private _ownerships;
965 
966   // Mapping owner address to address data
967   mapping(address => AddressData) private _addressData;
968 
969   // Mapping from token ID to approved address
970   mapping(uint256 => address) private _tokenApprovals;
971 
972   // Mapping from owner to operator approvals
973   mapping(address => mapping(address => bool)) private _operatorApprovals;
974 
975   /**
976    * @dev
977    * `maxBatchSize` refers to how much a minter can mint at a time.
978    * `collectionSize_` refers to how many tokens are in the collection.
979    */
980   constructor(
981     string memory name_,
982     string memory symbol_,
983     uint256 maxBatchSize_,
984     uint256 collectionSize_
985   ) {
986     require(
987       collectionSize_ > 0,
988       "ERC721A: collection must have a nonzero supply"
989     );
990     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
991     _name = name_;
992     _symbol = symbol_;
993     maxBatchSize = maxBatchSize_;
994     collectionSize = collectionSize_;
995   }
996 
997   /**
998    * @dev See {IERC721Enumerable-totalSupply}.
999    */
1000   function totalSupply() public view override returns (uint256) {
1001     return currentIndex;
1002   }
1003 
1004   /**
1005    * @dev See {IERC721Enumerable-tokenByIndex}.
1006    */
1007   function tokenByIndex(uint256 index) public view override returns (uint256) {
1008     require(index < totalSupply(), "ERC721A: global index out of bounds");
1009     return index;
1010   }
1011 
1012   /**
1013    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1014    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1015    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1016    */
1017   function tokenOfOwnerByIndex(address owner, uint256 index)
1018     public
1019     view
1020     override
1021     returns (uint256)
1022   {
1023     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1024     uint256 numMintedSoFar = totalSupply();
1025     uint256 tokenIdsIdx = 0;
1026     address currOwnershipAddr = address(0);
1027     for (uint256 i = 0; i < numMintedSoFar; i++) {
1028       TokenOwnership memory ownership = _ownerships[i];
1029       if (ownership.addr != address(0)) {
1030         currOwnershipAddr = ownership.addr;
1031       }
1032       if (currOwnershipAddr == owner) {
1033         if (tokenIdsIdx == index) {
1034           return i;
1035         }
1036         tokenIdsIdx++;
1037       }
1038     }
1039     revert("ERC721A: unable to get token of owner by index");
1040   }
1041 
1042   /**
1043    * @dev See {IERC165-supportsInterface}.
1044    */
1045   function supportsInterface(bytes4 interfaceId)
1046     public
1047     view
1048     virtual
1049     override(ERC165, IERC165)
1050     returns (bool)
1051   {
1052     return
1053       interfaceId == type(IERC721).interfaceId ||
1054       interfaceId == type(IERC721Metadata).interfaceId ||
1055       interfaceId == type(IERC721Enumerable).interfaceId ||
1056       super.supportsInterface(interfaceId);
1057   }
1058 
1059   /**
1060    * @dev See {IERC721-balanceOf}.
1061    */
1062   function balanceOf(address owner) public view override returns (uint256) {
1063     require(owner != address(0), "ERC721A: balance query for the zero address");
1064     return uint256(_addressData[owner].balance);
1065   }
1066 
1067   function _numberMinted(address owner) internal view returns (uint256) {
1068     require(
1069       owner != address(0),
1070       "ERC721A: number minted query for the zero address"
1071     );
1072     return uint256(_addressData[owner].numberMinted);
1073   }
1074 
1075   function ownershipOf(uint256 tokenId)
1076     internal
1077     view
1078     returns (TokenOwnership memory)
1079   {
1080     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1081 
1082     uint256 lowestTokenToCheck;
1083     if (tokenId >= maxBatchSize) {
1084       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1085     }
1086 
1087     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1088       TokenOwnership memory ownership = _ownerships[curr];
1089       if (ownership.addr != address(0)) {
1090         return ownership;
1091       }
1092     }
1093 
1094     revert("ERC721A: unable to determine the owner of token");
1095   }
1096 
1097   /**
1098    * @dev See {IERC721-ownerOf}.
1099    */
1100   function ownerOf(uint256 tokenId) public view override returns (address) {
1101     return ownershipOf(tokenId).addr;
1102   }
1103 
1104   /**
1105    * @dev See {IERC721Metadata-name}.
1106    */
1107   function name() public view virtual override returns (string memory) {
1108     return _name;
1109   }
1110 
1111   /**
1112    * @dev See {IERC721Metadata-symbol}.
1113    */
1114   function symbol() public view virtual override returns (string memory) {
1115     return _symbol;
1116   }
1117 
1118   /**
1119    * @dev See {IERC721Metadata-tokenURI}.
1120    */
1121   function tokenURI(uint256 tokenId)
1122     public
1123     view
1124     virtual
1125     override
1126     returns (string memory)
1127   {
1128     require(
1129       _exists(tokenId),
1130       "ERC721Metadata: URI query for nonexistent token"
1131     );
1132 
1133     string memory baseURI = _baseURI();
1134     return
1135       bytes(baseURI).length > 0
1136         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1137         : "";
1138   }
1139 
1140   /**
1141    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1142    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1143    * by default, can be overriden in child contracts.
1144    */
1145   function _baseURI() internal view virtual returns (string memory) {
1146     return "";
1147   }
1148 
1149   /**
1150    * @dev See {IERC721-approve}.
1151    */
1152   function approve(address to, uint256 tokenId) public override {
1153     address owner = ERC721A.ownerOf(tokenId);
1154     require(to != owner, "ERC721A: approval to current owner");
1155 
1156     require(
1157       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1158       "ERC721A: approve caller is not owner nor approved for all"
1159     );
1160 
1161     _approve(to, tokenId, owner);
1162   }
1163 
1164   /**
1165    * @dev See {IERC721-getApproved}.
1166    */
1167   function getApproved(uint256 tokenId) public view override returns (address) {
1168     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1169 
1170     return _tokenApprovals[tokenId];
1171   }
1172 
1173   /**
1174    * @dev See {IERC721-setApprovalForAll}.
1175    */
1176   function setApprovalForAll(address operator, bool approved) public override {
1177     require(operator != _msgSender(), "ERC721A: approve to caller");
1178 
1179     _operatorApprovals[_msgSender()][operator] = approved;
1180     emit ApprovalForAll(_msgSender(), operator, approved);
1181   }
1182 
1183   /**
1184    * @dev See {IERC721-isApprovedForAll}.
1185    */
1186   function isApprovedForAll(address owner, address operator)
1187     public
1188     view
1189     virtual
1190     override
1191     returns (bool)
1192   {
1193     return _operatorApprovals[owner][operator];
1194   }
1195 
1196   /**
1197    * @dev See {IERC721-transferFrom}.
1198    */
1199   function transferFrom(
1200     address from,
1201     address to,
1202     uint256 tokenId
1203   ) public override {
1204     _transfer(from, to, tokenId);
1205   }
1206 
1207   /**
1208    * @dev See {IERC721-safeTransferFrom}.
1209    */
1210   function safeTransferFrom(
1211     address from,
1212     address to,
1213     uint256 tokenId
1214   ) public override {
1215     safeTransferFrom(from, to, tokenId, "");
1216   }
1217 
1218   /**
1219    * @dev See {IERC721-safeTransferFrom}.
1220    */
1221   function safeTransferFrom(
1222     address from,
1223     address to,
1224     uint256 tokenId,
1225     bytes memory _data
1226   ) public override {
1227     _transfer(from, to, tokenId);
1228     require(
1229       _checkOnERC721Received(from, to, tokenId, _data),
1230       "ERC721A: transfer to non ERC721Receiver implementer"
1231     );
1232   }
1233 
1234   /**
1235    * @dev Returns whether `tokenId` exists.
1236    *
1237    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1238    *
1239    * Tokens start existing when they are minted (`_mint`),
1240    */
1241   function _exists(uint256 tokenId) internal view returns (bool) {
1242     return tokenId < currentIndex;
1243   }
1244 
1245   function _safeMint(address to, uint256 quantity) internal {
1246     _safeMint(to, quantity, "");
1247   }
1248 
1249   /**
1250    * @dev Mints `quantity` tokens and transfers them to `to`.
1251    *
1252    * Requirements:
1253    *
1254    * - there must be `quantity` tokens remaining unminted in the total collection.
1255    * - `to` cannot be the zero address.
1256    * - `quantity` cannot be larger than the max batch size.
1257    *
1258    * Emits a {Transfer} event.
1259    */
1260   function _safeMint(
1261     address to,
1262     uint256 quantity,
1263     bytes memory _data
1264   ) internal {
1265     uint256 startTokenId = currentIndex;
1266     require(to != address(0), "ERC721A: mint to the zero address");
1267     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1268     require(!_exists(startTokenId), "ERC721A: token already minted");
1269     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1270 
1271     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1272 
1273     AddressData memory addressData = _addressData[to];
1274     _addressData[to] = AddressData(
1275       addressData.balance + uint128(quantity),
1276       addressData.numberMinted + uint128(quantity)
1277     );
1278     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1279 
1280     uint256 updatedIndex = startTokenId;
1281 
1282     for (uint256 i = 0; i < quantity; i++) {
1283       emit Transfer(address(0), to, updatedIndex);
1284       require(
1285         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1286         "ERC721A: transfer to non ERC721Receiver implementer"
1287       );
1288       updatedIndex++;
1289     }
1290 
1291     currentIndex = updatedIndex;
1292     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1293   }
1294 
1295   /**
1296    * @dev Transfers `tokenId` from `from` to `to`.
1297    *
1298    * Requirements:
1299    *
1300    * - `to` cannot be the zero address.
1301    * - `tokenId` token must be owned by `from`.
1302    *
1303    * Emits a {Transfer} event.
1304    */
1305   function _transfer(
1306     address from,
1307     address to,
1308     uint256 tokenId
1309   ) private {
1310     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1311 
1312     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1313       getApproved(tokenId) == _msgSender() ||
1314       isApprovedForAll(prevOwnership.addr, _msgSender()));
1315 
1316     require(
1317       isApprovedOrOwner,
1318       "ERC721A: transfer caller is not owner nor approved"
1319     );
1320 
1321     require(
1322       prevOwnership.addr == from,
1323       "ERC721A: transfer from incorrect owner"
1324     );
1325     require(to != address(0), "ERC721A: transfer to the zero address");
1326 
1327     _beforeTokenTransfers(from, to, tokenId, 1);
1328 
1329     // Clear approvals from the previous owner
1330     _approve(address(0), tokenId, prevOwnership.addr);
1331 
1332     _addressData[from].balance -= 1;
1333     _addressData[to].balance += 1;
1334     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1335 
1336     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1337     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1338     uint256 nextTokenId = tokenId + 1;
1339     if (_ownerships[nextTokenId].addr == address(0)) {
1340       if (_exists(nextTokenId)) {
1341         _ownerships[nextTokenId] = TokenOwnership(
1342           prevOwnership.addr,
1343           prevOwnership.startTimestamp
1344         );
1345       }
1346     }
1347 
1348     emit Transfer(from, to, tokenId);
1349     _afterTokenTransfers(from, to, tokenId, 1);
1350   }
1351 
1352   /**
1353    * @dev Approve `to` to operate on `tokenId`
1354    *
1355    * Emits a {Approval} event.
1356    */
1357   function _approve(
1358     address to,
1359     uint256 tokenId,
1360     address owner
1361   ) private {
1362     _tokenApprovals[tokenId] = to;
1363     emit Approval(owner, to, tokenId);
1364   }
1365 
1366   uint256 public nextOwnerToExplicitlySet = 0;
1367 
1368   /**
1369    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1370    */
1371   function _setOwnersExplicit(uint256 quantity) internal {
1372     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1373     require(quantity > 0, "quantity must be nonzero");
1374     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1375     if (endIndex > collectionSize - 1) {
1376       endIndex = collectionSize - 1;
1377     }
1378     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1379     require(_exists(endIndex), "not enough minted yet for this cleanup");
1380     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1381       if (_ownerships[i].addr == address(0)) {
1382         TokenOwnership memory ownership = ownershipOf(i);
1383         _ownerships[i] = TokenOwnership(
1384           ownership.addr,
1385           ownership.startTimestamp
1386         );
1387       }
1388     }
1389     nextOwnerToExplicitlySet = endIndex + 1;
1390   }
1391 
1392   /**
1393    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1394    * The call is not executed if the target address is not a contract.
1395    *
1396    * @param from address representing the previous owner of the given token ID
1397    * @param to target address that will receive the tokens
1398    * @param tokenId uint256 ID of the token to be transferred
1399    * @param _data bytes optional data to send along with the call
1400    * @return bool whether the call correctly returned the expected magic value
1401    */
1402   function _checkOnERC721Received(
1403     address from,
1404     address to,
1405     uint256 tokenId,
1406     bytes memory _data
1407   ) private returns (bool) {
1408     if (to.isContract()) {
1409       try
1410         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1411       returns (bytes4 retval) {
1412         return retval == IERC721Receiver(to).onERC721Received.selector;
1413       } catch (bytes memory reason) {
1414         if (reason.length == 0) {
1415           revert("ERC721A: transfer to non ERC721Receiver implementer");
1416         } else {
1417           assembly {
1418             revert(add(32, reason), mload(reason))
1419           }
1420         }
1421       }
1422     } else {
1423       return true;
1424     }
1425   }
1426 
1427   /**
1428    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1429    *
1430    * startTokenId - the first token id to be transferred
1431    * quantity - the amount to be transferred
1432    *
1433    * Calling conditions:
1434    *
1435    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1436    * transferred to `to`.
1437    * - When `from` is zero, `tokenId` will be minted for `to`.
1438    */
1439   function _beforeTokenTransfers(
1440     address from,
1441     address to,
1442     uint256 startTokenId,
1443     uint256 quantity
1444   ) internal virtual {}
1445 
1446   /**
1447    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1448    * minting.
1449    *
1450    * startTokenId - the first token id to be transferred
1451    * quantity - the amount to be transferred
1452    *
1453    * Calling conditions:
1454    *
1455    * - when `from` and `to` are both non-zero.
1456    * - `from` and `to` are never both zero.
1457    */
1458   function _afterTokenTransfers(
1459     address from,
1460     address to,
1461     uint256 startTokenId,
1462     uint256 quantity
1463   ) internal virtual {}
1464 }
1465 // File: @openzeppelin/contracts/access/Ownable.sol
1466 
1467 
1468 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1469 
1470 pragma solidity ^0.8.0;
1471 
1472 
1473 /**
1474  * @dev Contract module which provides a basic access control mechanism, where
1475  * there is an account (an owner) that can be granted exclusive access to
1476  * specific functions.
1477  *
1478  * By default, the owner account will be the one that deploys the contract. This
1479  * can later be changed with {transferOwnership}.
1480  *
1481  * This module is used through inheritance. It will make available the modifier
1482  * `onlyOwner`, which can be applied to your functions to restrict their use to
1483  * the owner.
1484  */
1485 abstract contract Ownable is Context {
1486     address private _owner;
1487 
1488     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1489 
1490     /**
1491      * @dev Initializes the contract setting the deployer as the initial owner.
1492      */
1493     constructor() {
1494         _transferOwnership(_msgSender());
1495     }
1496 
1497     /**
1498      * @dev Throws if called by any account other than the owner.
1499      */
1500     modifier onlyOwner() {
1501         _checkOwner();
1502         _;
1503     }
1504 
1505     /**
1506      * @dev Returns the address of the current owner.
1507      */
1508     function owner() public view virtual returns (address) {
1509         return _owner;
1510     }
1511 
1512     /**
1513      * @dev Throws if the sender is not the owner.
1514      */
1515     function _checkOwner() internal view virtual {
1516         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1517     }
1518 
1519     /**
1520      * @dev Leaves the contract without owner. It will not be possible to call
1521      * `onlyOwner` functions anymore. Can only be called by the current owner.
1522      *
1523      * NOTE: Renouncing ownership will leave the contract without an owner,
1524      * thereby removing any functionality that is only available to the owner.
1525      */
1526     function renounceOwnership() public virtual onlyOwner {
1527         _transferOwnership(address(0));
1528     }
1529 
1530     /**
1531      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1532      * Can only be called by the current owner.
1533      */
1534     function transferOwnership(address newOwner) public virtual onlyOwner {
1535         require(newOwner != address(0), "Ownable: new owner is the zero address");
1536         _transferOwnership(newOwner);
1537     }
1538 
1539     /**
1540      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1541      * Internal function without access restriction.
1542      */
1543     function _transferOwnership(address newOwner) internal virtual {
1544         address oldOwner = _owner;
1545         _owner = newOwner;
1546         emit OwnershipTransferred(oldOwner, newOwner);
1547     }
1548 }
1549 
1550 // File: contracts/BullMoon.sol
1551 
1552 
1553 
1554 pragma solidity ^0.8.0;
1555 
1556 
1557 
1558 
1559 
1560 
1561 contract BullMoonClub is Ownable, ERC721A, ReentrancyGuard {
1562   bool public moonlistStatus;
1563   bool public publicSaleStatus;
1564   uint256 public maxPerTxMint;
1565   uint256 public moonlistPrice = 0.10 ether;
1566   uint256 public publicPrice = 0.12 ether;
1567   bytes32 root;
1568 
1569   constructor(
1570     bool _moonlistStatus,
1571     bool _publicSaleStatus,
1572     uint256 _maxBatchSize,
1573     uint256 _collectionSize
1574     ) ERC721A("BullMoonCLUB NFT", "BULLMOON", _maxBatchSize, _collectionSize) {
1575       moonlistStatus = _moonlistStatus;
1576       publicSaleStatus = _publicSaleStatus;
1577       maxPerTxMint = _maxBatchSize;
1578   }
1579 
1580   modifier checkCallerUser() {
1581     require(tx.origin == msg.sender, "Called by another contract");
1582     _;
1583   }
1584 
1585   //set merkle tree root
1586   function setRoot(bytes32 _root) public onlyOwner {
1587     root = _root;
1588   }
1589 
1590   function moonlistMint(uint256 _amount, bytes32[] calldata _merkleProof) external payable checkCallerUser {
1591     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1592     require(MerkleProof.verify(_merkleProof, root, leaf), "Incorrect proof");
1593     require(isMoonListMintOn(), "moonlist is not available now");
1594     require(totalSupply() + _amount <= collectionSize, "max supply reached");
1595     require(_amount <= 5, "exceed batch limit");
1596     require(numberMinted(msg.sender) + _amount <= 5,"cannot mint over 5 NFTs for MoonList"); 
1597 
1598     refundIfOver(moonlistPrice * _amount);
1599     _safeMint(msg.sender, _amount);
1600   }
1601 
1602   function publicSaleMint(uint256 _amount) external payable checkCallerUser {
1603     require(isPublicSaleOn(),"public sale has not begun yet");
1604     require(totalSupply() + _amount <= collectionSize, "reached max supply");
1605     require(_amount <= maxPerTxMint,"can not mint this many");
1606 
1607     refundIfOver(publicPrice * _amount);
1608     _safeMint(msg.sender, _amount);
1609   }
1610 
1611   function refundIfOver(uint256 price) private {
1612     require(msg.value >= price, "Need more ETH");
1613     if (msg.value > price) {
1614       payable(msg.sender).transfer(msg.value - price);
1615     }
1616   }
1617 
1618   function isMoonListMintOn() public view returns (bool) {
1619     return moonlistStatus;
1620   }
1621 
1622   function isPublicSaleOn() public view returns (bool) {
1623     return publicSaleStatus;
1624   }
1625 
1626   function setMoonlistStatus(bool _status) external onlyOwner {moonlistStatus = _status;}
1627   function setPublicSaleStatus(bool _status) external onlyOwner {publicSaleStatus = _status;}
1628 
1629   function bullListTransfer(address to, uint256 amount) external onlyOwner {
1630     require(amount > 0,"bullList mint amount must be greater than zero");
1631     uint256 numChunks = uint256(amount / maxPerTxMint);
1632     uint256 remainChunks = amount % maxPerTxMint;
1633     for (uint256 i = 0; i < numChunks; i++) {
1634       _safeMint(to, maxPerTxMint);
1635     }
1636     _safeMint(to, remainChunks);
1637   }
1638 
1639   function setMoonlistPrice(uint256 _price) external onlyOwner { moonlistPrice = _price;}
1640   function setPublicPrice(uint256 _price) external onlyOwner { publicPrice = _price;}
1641 
1642   // // metadata URI
1643   string private _baseTokenURI;
1644 
1645   function _baseURI() internal view virtual override returns (string memory) {
1646     return _baseTokenURI;
1647   }
1648 
1649   function setBaseURI(string calldata baseURI) external onlyOwner {
1650     _baseTokenURI = baseURI;
1651   }
1652 
1653   function withdrawAllToOwner() external onlyOwner nonReentrant {
1654     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1655     require(success, "Transfer failed");
1656   }
1657 
1658   function withdrawAllToAddress(address _address) external onlyOwner nonReentrant {
1659     (bool success, ) = _address.call{value: address(this).balance}("");
1660     require(success, "Transfer failed");
1661   }
1662 
1663   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1664     _setOwnersExplicit(quantity);
1665   }
1666 
1667   function numberMinted(address owner) public view returns (uint256) {
1668     return _numberMinted(owner);
1669   }
1670 
1671   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1672     return ownershipOf(tokenId);
1673   }
1674 }