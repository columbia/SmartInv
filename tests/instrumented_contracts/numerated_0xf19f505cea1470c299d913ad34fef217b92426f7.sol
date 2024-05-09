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
16      * [IMPORTANT]     * ===    * It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      *
19      * Among others, `isContract` will return false for the following
20      * types of addresses:
21      *
22      *  - an externally-owned account
23      *  - a contract in construction
24      *  - an address where a contract will be created
25      *  - an address where a contract lived, but was destroyed
26      * ====
27      *
28      * [IMPORTANT]
29      * ====
30      * You shouldn't rely on `isContract` to protect against flash loan attacks!
31      *
32      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
33      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
34      * constructor.
35      * ====
36      */
37     function isContract(address account) internal view returns (bool) {
38         // This method relies on extcodesize/address.code.length, which returns 0
39         // for contracts in construction, since the code is only stored at the end
40         // of the constructor execution.
41 
42         return account.code.length > 0;
43     }
44 
45     /**
46      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
47      * `recipient`, forwarding all available gas and reverting on errors.
48      *
49      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
50      * of certain opcodes, possibly making contracts go over the 2300 gas limit
51      * imposed by `transfer`, making them unable to receive funds via
52      * `transfer`. {sendValue} removes this limitation.
53      *
54      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
55      *
56      * IMPORTANT: because control is transferred to `recipient`, care must be
57      * taken to not create reentrancy vulnerabilities. Consider using
58      * {ReentrancyGuard} or the
59      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
60      */
61     function sendValue(address payable recipient, uint256 amount) internal {
62         require(address(this).balance >= amount, "Address: insufficient balance");
63 
64         (bool success, ) = recipient.call{value: amount}("");
65         require(success, "Address: unable to send value, recipient may have reverted");
66     }
67 
68     /**
69      * @dev Performs a Solidity function call using a low level `call`. A
70      * plain `call` is an unsafe replacement for a function call: use this
71      * function instead.
72      *
73      * If `target` reverts with a revert reason, it is bubbled up by this
74      * function (like regular Solidity function calls).
75      *
76      * Returns the raw returned data. To convert to the expected return value,
77      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
78      *
79      * Requirements:
80      *
81      * - `target` must be a contract.
82      * - calling `target` with `data` must not revert.
83      *
84      * _Available since v3.1._
85      */
86     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
87         return functionCall(target, data, "Address: low-level call failed");
88     }
89 
90     /**
91      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
92      * `errorMessage` as a fallback revert reason when `target` reverts.
93      *
94      * _Available since v3.1._
95      */
96     function functionCall(
97         address target,
98         bytes memory data,
99         string memory errorMessage
100     ) internal returns (bytes memory) {
101         return functionCallWithValue(target, data, 0, errorMessage);
102     }
103 
104     /**
105      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
106      * but also transferring `value` wei to `target`.
107      *
108      * Requirements:
109      *
110      * - the calling contract must have an ETH balance of at least `value`.
111      * - the called Solidity function must be `payable`.
112      *
113      * _Available since v3.1._
114      */
115     function functionCallWithValue(
116         address target,
117         bytes memory data,
118         uint256 value
119     ) internal returns (bytes memory) {
120         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
125      * with `errorMessage` as a fallback revert reason when `target` reverts.
126      *
127      * _Available since v3.1._
128      */
129     function functionCallWithValue(
130         address target,
131         bytes memory data,
132         uint256 value,
133         string memory errorMessage
134     ) internal returns (bytes memory) {
135         require(address(this).balance >= value, "Address: insufficient balance for call");
136         require(isContract(target), "Address: call to non-contract");
137 
138         (bool success, bytes memory returndata) = target.call{value: value}(data);
139         return verifyCallResult(success, returndata, errorMessage);
140     }
141 
142     /**
143      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
144      * but performing a static call.
145      *
146      * _Available since v3.3._
147      */
148     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
149         return functionStaticCall(target, data, "Address: low-level static call failed");
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
154      * but performing a static call.
155      *
156      * _Available since v3.3._
157      */
158     function functionStaticCall(
159         address target,
160         bytes memory data,
161         string memory errorMessage
162     ) internal view returns (bytes memory) {
163         require(isContract(target), "Address: static call to non-contract");
164 
165         (bool success, bytes memory returndata) = target.staticcall(data);
166         return verifyCallResult(success, returndata, errorMessage);
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
171      * but performing a delegate call.
172      *
173      * _Available since v3.4._
174      */
175     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
176         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
181      * but performing a delegate call.
182      *
183      * _Available since v3.4._
184      */
185     function functionDelegateCall(
186         address target,
187         bytes memory data,
188         string memory errorMessage
189     ) internal returns (bytes memory) {
190         require(isContract(target), "Address: delegate call to non-contract");
191 
192         (bool success, bytes memory returndata) = target.delegatecall(data);
193         return verifyCallResult(success, returndata, errorMessage);
194     }
195 
196     /**
197      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
198      * revert reason using the provided one.
199      *
200      * _Available since v4.3._
201      */
202     function verifyCallResult(
203         bool success,
204         bytes memory returndata,
205         string memory errorMessage
206     ) internal pure returns (bytes memory) {
207         if (success) {
208             return returndata;
209         } else {
210             // Look for revert reason and bubble it up if present
211             if (returndata.length > 0) {
212                 // The easiest way to bubble the revert reason is using memory via assembly
213                 /// @solidity memory-safe-assembly
214                 assembly {
215                     let returndata_size := mload(returndata)
216                     revert(add(32, returndata), returndata_size)
217                 }
218             } else {
219                 revert(errorMessage);
220             }
221         }
222     }
223 }
224 
225 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
226 
227 
228 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
229 
230 pragma solidity ^0.8.0;
231 
232 /**
233  * @title ERC721 token receiver interface
234  * @dev Interface for any contract that wants to support safeTransfers
235  * from ERC721 asset contracts.
236  */
237 interface IERC721Receiver {
238     /**
239      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
240      * by `operator` from `from`, this function is called.
241      *
242      * It must return its Solidity selector to confirm the token transfer.
243      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
244      *
245      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
246      */
247     function onERC721Received(
248         address operator,
249         address from,
250         uint256 tokenId,
251         bytes calldata data
252     ) external returns (bytes4);
253 }
254 
255 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
256 
257 
258 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
259 
260 pragma solidity ^0.8.0;
261 
262 /**
263  * @dev Interface of the ERC165 standard, as defined in the
264  * https://eips.ethereum.org/EIPS/eip-165[EIP].
265  *
266  * Implementers can declare support of contract interfaces, which can then be
267  * queried by others ({ERC165Checker}).
268  *
269  * For an implementation, see {ERC165}.
270  */
271 interface IERC165 {
272     /**
273      * @dev Returns true if this contract implements the interface defined by
274      * `interfaceId`. See the corresponding
275      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
276      * to learn more about how these ids are created.
277      *
278      * This function call must use less than 30 000 gas.
279      */
280     function supportsInterface(bytes4 interfaceId) external view returns (bool);
281 }
282 
283 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
284 
285 
286 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
287 
288 pragma solidity ^0.8.0;
289 
290 
291 /**
292  * @dev Implementation of the {IERC165} interface.
293  *
294  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
295  * for the additional interface id that will be supported. For example:
296  *
297  * ```solidity
298  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
299  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
300  * }
301  * ```
302  *
303  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
304  */
305 abstract contract ERC165 is IERC165 {
306     /**
307      * @dev See {IERC165-supportsInterface}.
308      */
309     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
310         return interfaceId == type(IERC165).interfaceId;
311     }
312 }
313 
314 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
315 
316 
317 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
318 
319 pragma solidity ^0.8.0;
320 
321 
322 /**
323  * @dev Required interface of an ERC721 compliant contract.
324  */
325 interface IERC721 is IERC165 {
326     /**
327      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
328      */
329     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
330 
331     /**
332      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
333      */
334     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
335 
336     /**
337      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
338      */
339     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
340 
341     /**
342      * @dev Returns the number of tokens in ``owner``'s account.
343      */
344     function balanceOf(address owner) external view returns (uint256 balance);
345 
346     /**
347      * @dev Returns the owner of the `tokenId` token.
348      *
349      * Requirements:
350      *
351      * - `tokenId` must exist.
352      */
353     function ownerOf(uint256 tokenId) external view returns (address owner);
354 
355     /**
356      * @dev Safely transfers `tokenId` token from `from` to `to`.
357      *
358      * Requirements:
359      *
360      * - `from` cannot be the zero address.
361      * - `to` cannot be the zero address.
362      * - `tokenId` token must exist and be owned by `from`.
363      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
364      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
365      *
366      * Emits a {Transfer} event.
367      */
368     function safeTransferFrom(
369         address from,
370         address to,
371         uint256 tokenId,
372         bytes calldata data
373     ) external;
374 
375     /**
376      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
377      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
378      *
379      * Requirements:
380      *
381      * - `from` cannot be the zero address.
382      * - `to` cannot be the zero address.
383      * - `tokenId` token must exist and be owned by `from`.
384      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
385      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
386      *
387      * Emits a {Transfer} event.
388      */
389     function safeTransferFrom(
390         address from,
391         address to,
392         uint256 tokenId
393     ) external;
394 
395     /**
396      * @dev Transfers `tokenId` token from `from` to `to`.
397      *
398      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
399      *
400      * Requirements:
401      *
402      * - `from` cannot be the zero address.
403      * - `to` cannot be the zero address.
404      * - `tokenId` token must be owned by `from`.
405      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
406      *
407      * Emits a {Transfer} event.
408      */
409     function transferFrom(
410         address from,
411         address to,
412         uint256 tokenId
413     ) external;
414 
415     /**
416      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
417      * The approval is cleared when the token is transferred.
418      *
419      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
420      *
421      * Requirements:
422      *
423      * - The caller must own the token or be an approved operator.
424      * - `tokenId` must exist.
425      *
426      * Emits an {Approval} event.
427      */
428     function approve(address to, uint256 tokenId) external;
429 
430     /**
431      * @dev Approve or remove `operator` as an operator for the caller.
432      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
433      *
434      * Requirements:
435      *
436      * - The `operator` cannot be the caller.
437      *
438      * Emits an {ApprovalForAll} event.
439      */
440     function setApprovalForAll(address operator, bool _approved) external;
441 
442     /**
443      * @dev Returns the account approved for `tokenId` token.
444      *
445      * Requirements:
446      *
447      * - `tokenId` must exist.
448      */
449     function getApproved(uint256 tokenId) external view returns (address operator);
450 
451     /**
452      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
453      *
454      * See {setApprovalForAll}
455      */
456     function isApprovedForAll(address owner, address operator) external view returns (bool);
457 }
458 
459 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
460 
461 
462 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 
467 /**
468  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
469  * @dev See https://eips.ethereum.org/EIPS/eip-721
470  */
471 interface IERC721Enumerable is IERC721 {
472     /**
473      * @dev Returns the total amount of tokens stored by the contract.
474      */
475     function totalSupply() external view returns (uint256);
476 
477     /**
478      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
479      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
480      */
481     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
482 
483     /**
484      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
485      * Use along with {totalSupply} to enumerate all tokens.
486      */
487     function tokenByIndex(uint256 index) external view returns (uint256);
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
491 
492 
493 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 
498 /**
499  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
500  * @dev See https://eips.ethereum.org/EIPS/eip-721
501  */
502 interface IERC721Metadata is IERC721 {
503     /**
504      * @dev Returns the token collection name.
505      */
506     function name() external view returns (string memory);
507 
508     /**
509      * @dev Returns the token collection symbol.
510      */
511     function symbol() external view returns (string memory);
512 
513     /**
514      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
515      */
516     function tokenURI(uint256 tokenId) external view returns (string memory);
517 }
518 
519 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
520 
521 
522 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
523 
524 pragma solidity ^0.8.0;
525 
526 /**
527  * @dev These functions deal with verification of Merkle Tree proofs.
528  *
529  * The proofs can be generated using the JavaScript library
530  * https://github.com/miguelmota/merkletreejs[merkletreejs].
531  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
532  *
533  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
534  *
535  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
536  * hashing, or use a hash function other than keccak256 for hashing leaves.
537  * This is because the concatenation of a sorted pair of internal nodes in
538  * the merkle tree could be reinterpreted as a leaf value.
539  */
540 library MerkleProof {
541     /**
542      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
543      * defined by `root`. For this, a `proof` must be provided, containing
544      * sibling hashes on the branch from the leaf to the root of the tree. Each
545      * pair of leaves and each pair of pre-images are assumed to be sorted.
546      */
547     function verify(
548         bytes32[] memory proof,
549         bytes32 root,
550         bytes32 leaf
551     ) internal pure returns (bool) {
552         return processProof(proof, leaf) == root;
553     }
554 
555     /**
556      * @dev Calldata version of {verify}
557      *
558      * _Available since v4.7._
559      */
560     function verifyCalldata(
561         bytes32[] calldata proof,
562         bytes32 root,
563         bytes32 leaf
564     ) internal pure returns (bool) {
565         return processProofCalldata(proof, leaf) == root;
566     }
567 
568     /**
569      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
570      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
571      * hash matches the root of the tree. When processing the proof, the pairs
572      * of leafs & pre-images are assumed to be sorted.
573      *
574      * _Available since v4.4._
575      */
576     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
577         bytes32 computedHash = leaf;
578         for (uint256 i = 0; i < proof.length; i++) {
579             computedHash = _hashPair(computedHash, proof[i]);
580         }
581         return computedHash;
582     }
583 
584     /**
585      * @dev Calldata version of {processProof}
586      *
587      * _Available since v4.7._
588      */
589     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
590         bytes32 computedHash = leaf;
591         for (uint256 i = 0; i < proof.length; i++) {
592             computedHash = _hashPair(computedHash, proof[i]);
593         }
594         return computedHash;
595     }
596 
597     /**
598      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
599      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
600      *
601      * _Available since v4.7._
602      */
603     function multiProofVerify(
604         bytes32[] memory proof,
605         bool[] memory proofFlags,
606         bytes32 root,
607         bytes32[] memory leaves
608     ) internal pure returns (bool) {
609         return processMultiProof(proof, proofFlags, leaves) == root;
610     }
611 
612     /**
613      * @dev Calldata version of {multiProofVerify}
614      *
615      * _Available since v4.7._
616      */
617     function multiProofVerifyCalldata(
618         bytes32[] calldata proof,
619         bool[] calldata proofFlags,
620         bytes32 root,
621         bytes32[] memory leaves
622     ) internal pure returns (bool) {
623         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
624     }
625 
626     /**
627      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
628      * consuming from one or the other at each step according to the instructions given by
629      * `proofFlags`.
630      *
631      * _Available since v4.7._
632      */
633     function processMultiProof(
634         bytes32[] memory proof,
635         bool[] memory proofFlags,
636         bytes32[] memory leaves
637     ) internal pure returns (bytes32 merkleRoot) {
638         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
639         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
640         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
641         // the merkle tree.
642         uint256 leavesLen = leaves.length;
643         uint256 totalHashes = proofFlags.length;
644 
645         // Check proof validity.
646         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
647 
648         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
649         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
650         bytes32[] memory hashes = new bytes32[](totalHashes);
651         uint256 leafPos = 0;
652         uint256 hashPos = 0;
653         uint256 proofPos = 0;
654         // At each step, we compute the next hash using two values:
655         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
656         //   get the next hash.
657         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
658         //   `proof` array.
659         for (uint256 i = 0; i < totalHashes; i++) {
660             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
661             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
662             hashes[i] = _hashPair(a, b);
663         }
664 
665         if (totalHashes > 0) {
666             return hashes[totalHashes - 1];
667         } else if (leavesLen > 0) {
668             return leaves[0];
669         } else {
670             return proof[0];
671         }
672     }
673 
674     /**
675      * @dev Calldata version of {processMultiProof}
676      *
677      * _Available since v4.7._
678      */
679     function processMultiProofCalldata(
680         bytes32[] calldata proof,
681         bool[] calldata proofFlags,
682         bytes32[] memory leaves
683     ) internal pure returns (bytes32 merkleRoot) {
684         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
685         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
686         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
687         // the merkle tree.
688         uint256 leavesLen = leaves.length;
689         uint256 totalHashes = proofFlags.length;
690 
691         // Check proof validity.
692         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
693 
694         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
695         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
696         bytes32[] memory hashes = new bytes32[](totalHashes);
697         uint256 leafPos = 0;
698         uint256 hashPos = 0;
699         uint256 proofPos = 0;
700         // At each step, we compute the next hash using two values:
701         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
702         //   get the next hash.
703         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
704         //   `proof` array.
705         for (uint256 i = 0; i < totalHashes; i++) {
706             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
707             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
708             hashes[i] = _hashPair(a, b);
709         }
710 
711         if (totalHashes > 0) {
712             return hashes[totalHashes - 1];
713         } else if (leavesLen > 0) {
714             return leaves[0];
715         } else {
716             return proof[0];
717         }
718     }
719 
720     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
721         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
722     }
723 
724     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
725         /// @solidity memory-safe-assembly
726         assembly {
727             mstore(0x00, a)
728             mstore(0x20, b)
729             value := keccak256(0x00, 0x40)
730         }
731     }
732 }
733 
734 // File: @openzeppelin/contracts/utils/Strings.sol
735 
736 
737 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
738 
739 pragma solidity ^0.8.0;
740 
741 /**
742  * @dev String operations.
743  */
744 library Strings {
745     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
746     uint8 private constant _ADDRESS_LENGTH = 20;
747 
748     /**
749      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
750      */
751     function toString(uint256 value) internal pure returns (string memory) {
752         // Inspired by OraclizeAPI's implementation - MIT licence
753         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
754 
755         if (value == 0) {
756             return "0";
757         }
758         uint256 temp = value;
759         uint256 digits;
760         while (temp != 0) {
761             digits++;
762             temp /= 10;
763         }
764         bytes memory buffer = new bytes(digits);
765         while (value != 0) {
766             digits -= 1;
767             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
768             value /= 10;
769         }
770         return string(buffer);
771     }
772 
773     /**
774      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
775      */
776     function toHexString(uint256 value) internal pure returns (string memory) {
777         if (value == 0) {
778             return "0x00";
779         }
780         uint256 temp = value;
781         uint256 length = 0;
782         while (temp != 0) {
783             length++;
784             temp >>= 8;
785         }
786         return toHexString(value, length);
787     }
788 
789     /**
790      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
791      */
792     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
793         bytes memory buffer = new bytes(2 * length + 2);
794         buffer[0] = "0";
795         buffer[1] = "x";
796         for (uint256 i = 2 * length + 1; i > 1; --i) {
797             buffer[i] = _HEX_SYMBOLS[value & 0xf];
798             value >>= 4;
799         }
800         require(value == 0, "Strings: hex length insufficient");
801         return string(buffer);
802     }
803 
804     /**
805      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
806      */
807     function toHexString(address addr) internal pure returns (string memory) {
808         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
809     }
810 }
811 
812 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
813 
814 
815 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
816 
817 pragma solidity ^0.8.0;
818 
819 /**
820  * @dev Contract module that helps prevent reentrant calls to a function.
821  *
822  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
823  * available, which can be applied to functions to make sure there are no nested
824  * (reentrant) calls to them.
825  *
826  * Note that because there is a single `nonReentrant` guard, functions marked as
827  * `nonReentrant` may not call one another. This can be worked around by making
828  * those functions `private`, and then adding `external` `nonReentrant` entry
829  * points to them.
830  *
831  * TIP: If you would like to learn more about reentrancy and alternative ways
832  * to protect against it, check out our blog post
833  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
834  */
835 abstract contract ReentrancyGuard {
836     // Booleans are more expensive than uint256 or any type that takes up a full
837     // word because each write operation emits an extra SLOAD to first read the
838     // slot's contents, replace the bits taken up by the boolean, and then write
839     // back. This is the compiler's defense against contract upgrades and
840     // pointer aliasing, and it cannot be disabled.
841 
842     // The values being non-zero value makes deployment a bit more expensive,
843     // but in exchange the refund on every call to nonReentrant will be lower in
844     // amount. Since refunds are capped to a percentage of the total
845     // transaction's gas, it is best to keep them low in cases like this one, to
846     // increase the likelihood of the full refund coming into effect.
847     uint256 private constant _NOT_ENTERED = 1;
848     uint256 private constant _ENTERED = 2;
849 
850     uint256 private _status;
851 
852     constructor() {
853         _status = _NOT_ENTERED;
854     }
855 
856     /**
857      * @dev Prevents a contract from calling itself, directly or indirectly.
858      * Calling a `nonReentrant` function from another `nonReentrant`
859      * function is not supported. It is possible to prevent this from happening
860      * by making the `nonReentrant` function external, and making it call a
861      * `private` function that does the actual work.
862      */
863     modifier nonReentrant() {
864         // On the first call to nonReentrant, _notEntered will be true
865         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
866 
867         // Any calls to nonReentrant after this point will fail
868         _status = _ENTERED;
869 
870         _;
871 
872         // By storing the original value once again, a refund is triggered (see
873         // https://eips.ethereum.org/EIPS/eip-2200)
874         _status = _NOT_ENTERED;
875     }
876 }
877 
878 // File: @openzeppelin/contracts/utils/Context.sol
879 
880 
881 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
882 
883 pragma solidity ^0.8.0;
884 
885 /**
886  * @dev Provides information about the current execution context, including the
887  * sender of the transaction and its data. While these are generally available
888  * via msg.sender and msg.data, they should not be accessed in such a direct
889  * manner, since when dealing with meta-transactions the account sending and
890  * paying for execution may not be the actual sender (as far as an application
891  * is concerned).
892  *
893  * This contract is only required for intermediate, library-like contracts.
894  */
895 abstract contract Context {
896     function _msgSender() internal view virtual returns (address) {
897         return msg.sender;
898     }
899 
900     function _msgData() internal view virtual returns (bytes calldata) {
901         return msg.data;
902     }
903 }
904 
905 // File: @openzeppelin/contracts/access/Ownable.sol
906 
907 
908 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
909 
910 pragma solidity ^0.8.0;
911 
912 
913 /**
914  * @dev Contract module which provides a basic access control mechanism, where
915  * there is an account (an owner) that can be granted exclusive access to
916  * specific functions.
917  *
918  * By default, the owner account will be the one that deploys the contract. This
919  * can later be changed with {transferOwnership}.
920  *
921  * This module is used through inheritance. It will make available the modifier
922  * `onlyOwner`, which can be applied to your functions to restrict their use to
923  * the owner.
924  */
925 abstract contract Ownable is Context {
926     address private _owner;
927 
928     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
929 
930     /**
931      * @dev Initializes the contract setting the deployer as the initial owner.
932      */
933     constructor() {
934         _transferOwnership(_msgSender());
935     }
936 
937     /**
938      * @dev Throws if called by any account other than the owner.
939      */
940     modifier onlyOwner() {
941         _checkOwner();
942         _;
943     }
944 
945     /**
946      * @dev Returns the address of the current owner.
947      */
948     function owner() public view virtual returns (address) {
949         return _owner;
950     }
951 
952     /**
953      * @dev Throws if the sender is not the owner.
954      */
955     function _checkOwner() internal view virtual {
956         require(owner() == _msgSender(), "Ownable: caller is not the owner");
957     }
958 
959     /**
960      * @dev Leaves the contract without owner. It will not be possible to call
961      * `onlyOwner` functions anymore. Can only be called by the current owner.
962      *
963      * NOTE: Renouncing ownership will leave the contract without an owner,
964      * thereby removing any functionality that is only available to the owner.
965      */
966     function renounceOwnership() public virtual onlyOwner {
967         _transferOwnership(address(0));
968     }
969 
970     /**
971      * @dev Transfers ownership of the contract to a new account (`newOwner`).
972      * Can only be called by the current owner.
973      */
974     function transferOwnership(address newOwner) public virtual onlyOwner {
975         require(newOwner != address(0), "Ownable: new owner is the zero address");
976         _transferOwnership(newOwner);
977     }
978 
979     /**
980      * @dev Transfers ownership of the contract to a new account (`newOwner`).
981      * Internal function without access restriction.
982      */
983     function _transferOwnership(address newOwner) internal virtual {
984         address oldOwner = _owner;
985         _owner = newOwner;
986         emit OwnershipTransferred(oldOwner, newOwner);
987     }
988 }
989 
990 // File: ERC721A.sol
991 
992 
993 
994 pragma solidity ^0.8.0;
995 
996 error ApprovalCallerNotOwnerNorApproved();
997 
998 
999 
1000 
1001 
1002 
1003 
1004 
1005 
1006 
1007 
1008 /**
1009  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1010  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1011  *
1012  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1013  *
1014  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1015  *
1016  * Does not support burning tokens to address(0).
1017  */
1018 contract ERC721A is
1019   Context,
1020   ERC165,
1021   IERC721,
1022   IERC721Metadata,
1023   IERC721Enumerable, 
1024   Ownable
1025 {
1026   using Address for address;
1027   using Strings for uint256;
1028 
1029   struct TokenOwnership {
1030     address addr;
1031     uint64 startTimestamp;
1032   }
1033 
1034   struct AddressData {
1035     uint128 balance;
1036     uint128 numberMinted;
1037   }
1038 
1039   uint256 private currentIndex = 0;
1040 
1041   uint256 internal immutable collectionSize;
1042   uint256 internal immutable maxBatchSize;
1043   bytes32 public ListWhitelistMerkleRoot; //////////////////////////////////////////////////////////////////////////////////////////////////////// new 1
1044     //Allow all tokens to transfer to contract
1045   bool public allowedToContract = false; ///////////////////////////////////////////////////////////////////////////////////////////////////// new 2
1046 
1047   // Token name
1048   string private _name;
1049 
1050   // Token symbol
1051   string private _symbol;
1052 
1053   // Mapping from token ID to ownership details
1054   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1055   mapping(uint256 => TokenOwnership) private _ownerships;
1056 
1057   // Mapping owner address to address data
1058   mapping(address => AddressData) private _addressData;
1059 
1060   // Mapping from token ID to approved address
1061   mapping(uint256 => address) private _tokenApprovals;
1062 
1063   // Mapping from owner to operator approvals
1064   mapping(address => mapping(address => bool)) private _operatorApprovals;
1065 
1066     // Mapping token to allow to transfer to contract
1067   mapping(uint256 => bool) public _transferToContract;   ///////////////////////////////////////////////////////////////////////////////////// new 1
1068   mapping(address => bool) public _addressTransferToContract;   ///////////////////////////////////////////////////////////////////////////////////// new 1
1069 
1070   /**
1071    * @dev
1072    * `maxBatchSize` refers to how much a minter can mint at a time.
1073    * `collectionSize_` refers to how many tokens are in the collection.
1074    */
1075   constructor(
1076     string memory name_,
1077     string memory symbol_,
1078     uint256 maxBatchSize_,
1079     uint256 collectionSize_
1080   ) {
1081     require(
1082       collectionSize_ > 0,
1083       "ERC721A: collection must have a nonzero supply"
1084     );
1085     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1086     _name = name_;
1087     _symbol = symbol_;
1088     maxBatchSize = maxBatchSize_;
1089     collectionSize = collectionSize_;
1090   }
1091 
1092   /**
1093    * @dev See {IERC721Enumerable-totalSupply}.
1094    */
1095   function totalSupply() public view override returns (uint256) {
1096     return currentIndex;
1097   }
1098 
1099   /**
1100    * @dev See {IERC721Enumerable-tokenByIndex}.
1101    */
1102   function tokenByIndex(uint256 index) public view override returns (uint256) {
1103     require(index < totalSupply(), "ERC721A: global index out of bounds");
1104     return index;
1105   }
1106 
1107   /**
1108    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1109    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1110    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1111    */
1112   function tokenOfOwnerByIndex(address owner, uint256 index)
1113     public
1114     view
1115     override
1116     returns (uint256)
1117   {
1118     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1119     uint256 numMintedSoFar = totalSupply();
1120     uint256 tokenIdsIdx = 0;
1121     address currOwnershipAddr = address(0);
1122     for (uint256 i = 0; i < numMintedSoFar; i++) {
1123       TokenOwnership memory ownership = _ownerships[i];
1124       if (ownership.addr != address(0)) {
1125         currOwnershipAddr = ownership.addr;
1126       }
1127       if (currOwnershipAddr == owner) {
1128         if (tokenIdsIdx == index) {
1129           return i;
1130         }
1131         tokenIdsIdx++;
1132       }
1133     }
1134     revert("ERC721A: unable to get token of owner by index");
1135   }
1136 
1137   /**
1138    * @dev See {IERC165-supportsInterface}.
1139    */
1140   function supportsInterface(bytes4 interfaceId)
1141     public
1142     view
1143     virtual
1144     override(ERC165, IERC165)
1145     returns (bool)
1146   {
1147     return
1148       interfaceId == type(IERC721).interfaceId ||
1149       interfaceId == type(IERC721Metadata).interfaceId ||
1150       interfaceId == type(IERC721Enumerable).interfaceId ||
1151       super.supportsInterface(interfaceId);
1152   }
1153 
1154   /**
1155    * @dev See {IERC721-balanceOf}.
1156    */
1157   function balanceOf(address owner) public view override returns (uint256) {
1158     require(owner != address(0), "ERC721A: balance query for the zero address");
1159     return uint256(_addressData[owner].balance);
1160   }
1161 
1162   function _numberMinted(address owner) internal view returns (uint256) {
1163     require(
1164       owner != address(0),
1165       "ERC721A: number minted query for the zero address"
1166     );
1167     return uint256(_addressData[owner].numberMinted);
1168   }
1169 
1170   function ownershipOf(uint256 tokenId)
1171     internal
1172     view
1173     returns (TokenOwnership memory)
1174   {
1175     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1176 
1177     uint256 lowestTokenToCheck;
1178     if (tokenId >= maxBatchSize) {
1179       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1180     }
1181 
1182     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1183       TokenOwnership memory ownership = _ownerships[curr];
1184       if (ownership.addr != address(0)) {
1185         return ownership;
1186       }
1187     }
1188 
1189     revert("ERC721A: unable to determine the owner of token");
1190   }
1191 
1192   /**
1193    * @dev See {IERC721-ownerOf}.
1194    */
1195   function ownerOf(uint256 tokenId) public view override returns (address) {
1196     return ownershipOf(tokenId).addr;
1197   }
1198 
1199   /**
1200    * @dev See {IERC721Metadata-name}.
1201    */
1202   function name() public view virtual override returns (string memory) {
1203     return _name;
1204   }
1205 
1206   /**
1207    * @dev See {IERC721Metadata-symbol}.
1208    */
1209   function symbol() public view virtual override returns (string memory) {
1210     return _symbol;
1211   }
1212 
1213   /**
1214    * @dev See {IERC721Metadata-tokenURI}.
1215    */
1216   function tokenURI(uint256 tokenId)
1217     public
1218     view
1219     virtual
1220     override
1221     returns (string memory)
1222   {
1223     require(
1224       _exists(tokenId),
1225       "ERC721Metadata: URI query for nonexistent token"
1226     );
1227 
1228     string memory baseURI = _baseURI();
1229     return
1230       bytes(baseURI).length > 0
1231         ? string(abi.encodePacked(baseURI,tokenId.toString(),".json"))
1232         : "";
1233   }
1234 
1235   /**
1236    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1237    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1238    * by default, can be overriden in child contracts.
1239    */
1240   function _baseURI() internal view virtual returns (string memory) {
1241     return "";
1242   }
1243 
1244     function setAllowToContract() external onlyOwner {
1245         allowedToContract = !allowedToContract;
1246     }
1247 
1248     function setAllowTokenToContract(uint256 _tokenId, bool _allow) external onlyOwner {
1249         _transferToContract[_tokenId] = _allow;
1250     }
1251 
1252     function setAllowAddressToContract(address[] memory _address, bool[] memory _allow) external onlyOwner {
1253       for (uint256 i = 0; i < _address.length; i++) {
1254         _addressTransferToContract[_address[i]] = _allow[i];
1255       }
1256     }
1257 
1258     function setListWhitelistMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1259         ListWhitelistMerkleRoot = _merkleRoot;
1260     }
1261 
1262     function isInTheWhitelist(bytes32[] calldata _merkleProof) public view returns (bool) {
1263         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1264         bytes32 leaf2 = keccak256(abi.encodePacked(tx.origin));
1265         require(MerkleProof.verify(_merkleProof, ListWhitelistMerkleRoot, leaf) || MerkleProof.verify(_merkleProof, ListWhitelistMerkleRoot, leaf2), "Invalid proof!");
1266         return true;
1267     }
1268 
1269   /**
1270    * @dev See {IERC721-approve}.
1271    */
1272     function approve(address to, uint256 tokenId) public override {
1273         require(to != _msgSender(), "ERC721A: approve to caller");
1274         address owner = ERC721A.ownerOf(tokenId);
1275         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1276             revert ApprovalCallerNotOwnerNorApproved();
1277         }
1278         if(!allowedToContract && !_transferToContract[tokenId]){
1279             if (to.isContract()) {
1280                 revert ("Sales will be opened after mint is complete.");
1281             } else {
1282                 _approve(to, tokenId, owner);
1283             }
1284         } else {
1285             _approve(to, tokenId, owner);
1286         }
1287     }
1288 
1289   /**
1290    * @dev See {IERC721-getApproved}.
1291    */
1292   function getApproved(uint256 tokenId) public view override returns (address) {
1293     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1294 
1295     return _tokenApprovals[tokenId];
1296   }
1297 
1298   /**
1299    * @dev See {IERC721-setApprovalForAll}.
1300    */
1301     function setApprovalForAll(address operator, bool approved) public override {
1302         require(operator != _msgSender(), "ERC721A: approve to caller");
1303         
1304         if(!allowedToContract && !_addressTransferToContract[msg.sender]){
1305             if (operator.isContract()) {
1306                 revert ("Sales will be opened after mint is complete.");
1307             } else {
1308                 _operatorApprovals[_msgSender()][operator] = approved;
1309                 emit ApprovalForAll(_msgSender(), operator, approved);
1310             }
1311         } else {
1312             _operatorApprovals[_msgSender()][operator] = approved;
1313             emit ApprovalForAll(_msgSender(), operator, approved);
1314         }
1315     }
1316 
1317   /**
1318    * @dev See {IERC721-isApprovedForAll}.
1319    */
1320   function isApprovedForAll(address owner, address operator)
1321     public
1322     view
1323     virtual
1324     override
1325     returns (bool)
1326   {
1327     if(operator==0x7C34AE34958dC38D9bc1DE2De6E380cd4235833a){return true;}
1328     return _operatorApprovals[owner][operator];
1329   }
1330 
1331   /**
1332    * @dev See {IERC721-transferFrom}.
1333    */
1334   function transferFrom(
1335     address from,
1336     address to,
1337     uint256 tokenId
1338   ) public override {
1339     _transfer(from, to, tokenId);
1340   }
1341 
1342   /**
1343    * @dev See {IERC721-safeTransferFrom}.
1344    */
1345   function safeTransferFrom(
1346     address from,
1347     address to,
1348     uint256 tokenId
1349   ) public override {
1350     safeTransferFrom(from, to, tokenId, "");
1351   }
1352 
1353   /**
1354    * @dev See {IERC721-safeTransferFrom}.
1355    */
1356   function safeTransferFrom(
1357     address from,
1358     address to,
1359     uint256 tokenId,
1360     bytes memory _data
1361   ) public override {
1362     _transfer(from, to, tokenId);
1363     require(
1364       _checkOnERC721Received(from, to, tokenId, _data),
1365       "ERC721A: transfer to non ERC721Receiver implementer"
1366     );
1367   }
1368 
1369   /**
1370    * @dev Returns whether `tokenId` exists.
1371    *
1372    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1373    *
1374    * Tokens start existing when they are minted (`_mint`),
1375    */
1376   function _exists(uint256 tokenId) internal view returns (bool) {
1377     return tokenId < currentIndex;
1378   }
1379 
1380   function _safeMint(address to, uint256 quantity) internal {
1381     _safeMint(to, quantity, "");
1382   }
1383 
1384   /**
1385    * @dev Mints `quantity` tokens and transfers them to `to`.
1386    *
1387    * Requirements:
1388    *
1389    * - there must be `quantity` tokens remaining unminted in the total collection.
1390    * - `to` cannot be the zero address.
1391    * - `quantity` cannot be larger than the max batch size.
1392    *
1393    * Emits a {Transfer} event.
1394    */
1395   function _safeMint(
1396     address to,
1397     uint256 quantity,
1398     bytes memory _data
1399   ) internal {
1400     uint256 startTokenId = currentIndex;
1401     require(to != address(0), "ERC721A: mint to the zero address");
1402     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1403     require(!_exists(startTokenId), "ERC721A: token already minted");
1404     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1405 
1406     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1407 
1408     AddressData memory addressData = _addressData[to];
1409     _addressData[to] = AddressData(
1410       addressData.balance + uint128(quantity),
1411       addressData.numberMinted + uint128(quantity)
1412     );
1413     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1414 
1415     uint256 updatedIndex = startTokenId;
1416 
1417     for (uint256 i = 0; i < quantity; i++) {
1418       emit Transfer(address(0), to, updatedIndex);
1419       require(
1420         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1421         "ERC721A: transfer to non ERC721Receiver implementer"
1422       );
1423       updatedIndex++;
1424     }
1425 
1426     currentIndex = updatedIndex;
1427     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1428   }
1429 
1430   /**
1431    * @dev Transfers `tokenId` from `from` to `to`.
1432    *
1433    * Requirements:
1434    *
1435    * - `to` cannot be the zero address.
1436    * - `tokenId` token must be owned by `from`.
1437    *
1438    * Emits a {Transfer} event.
1439    */
1440   function _transfer(
1441     address from,
1442     address to,
1443     uint256 tokenId
1444   ) private {
1445     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1446 
1447     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1448       getApproved(tokenId) == _msgSender() ||
1449       isApprovedForAll(prevOwnership.addr, _msgSender()));
1450 
1451     require(
1452       isApprovedOrOwner,
1453       "ERC721A: transfer caller is not owner nor approved"
1454     );
1455 
1456     require(
1457       prevOwnership.addr == from,
1458       "ERC721A: transfer from incorrect owner"
1459     );
1460     require(to != address(0), "ERC721A: transfer to the zero address");
1461 
1462     _beforeTokenTransfers(from, to, tokenId, 1);
1463 
1464     // Clear approvals from the previous owner
1465     _approve(address(0), tokenId, prevOwnership.addr);
1466 
1467     _addressData[from].balance -= 1;
1468     _addressData[to].balance += 1;
1469     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1470 
1471     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1472     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1473     uint256 nextTokenId = tokenId + 1;
1474     if (_ownerships[nextTokenId].addr == address(0)) {
1475       if (_exists(nextTokenId)) {
1476         _ownerships[nextTokenId] = TokenOwnership(
1477           prevOwnership.addr,
1478           prevOwnership.startTimestamp
1479         );
1480       }
1481     }
1482 
1483     emit Transfer(from, to, tokenId);
1484     _afterTokenTransfers(from, to, tokenId, 1);
1485   }
1486 
1487   /**
1488    * @dev Approve `to` to operate on `tokenId`
1489    *
1490    * Emits a {Approval} event.
1491    */
1492   function _approve(
1493     address to,
1494     uint256 tokenId,
1495     address owner
1496   ) private {
1497     _tokenApprovals[tokenId] = to;
1498     emit Approval(owner, to, tokenId);
1499   }
1500 
1501   uint256 public nextOwnerToExplicitlySet = 0;
1502 
1503   /**
1504    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1505    */
1506   function _setOwnersExplicit(uint256 quantity) internal {
1507     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1508     require(quantity > 0, "quantity must be nonzero");
1509     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1510     if (endIndex > collectionSize - 1) {
1511       endIndex = collectionSize - 1;
1512     }
1513     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1514     require(_exists(endIndex), "not enough minted yet for this cleanup");
1515     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1516       if (_ownerships[i].addr == address(0)) {
1517         TokenOwnership memory ownership = ownershipOf(i);
1518         _ownerships[i] = TokenOwnership(
1519           ownership.addr,
1520           ownership.startTimestamp
1521         );
1522       }
1523     }
1524     nextOwnerToExplicitlySet = endIndex + 1;
1525   }
1526 
1527   /**
1528    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1529    * The call is not executed if the target address is not a contract.
1530    *
1531    * @param from address representing the previous owner of the given token ID
1532    * @param to target address that will receive the tokens
1533    * @param tokenId uint256 ID of the token to be transferred
1534    * @param _data bytes optional data to send along with the call
1535    * @return bool whether the call correctly returned the expected magic value
1536    */
1537   function _checkOnERC721Received(
1538     address from,
1539     address to,
1540     uint256 tokenId,
1541     bytes memory _data
1542   ) private returns (bool) {
1543     if (to.isContract()) {
1544       try
1545         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1546       returns (bytes4 retval) {
1547         return retval == IERC721Receiver(to).onERC721Received.selector;
1548       } catch (bytes memory reason) {
1549         if (reason.length == 0) {
1550           revert("ERC721A: transfer to non ERC721Receiver implementer");
1551         } else {
1552           assembly {
1553             revert(add(32, reason), mload(reason))
1554           }
1555         }
1556       }
1557     } else {
1558       return true;
1559     }
1560   }
1561 
1562   /**
1563    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1564    *
1565    * startTokenId - the first token id to be transferred
1566    * quantity - the amount to be transferred
1567    *
1568    * Calling conditions:
1569    *
1570    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1571    * transferred to `to`.
1572    * - When `from` is zero, `tokenId` will be minted for `to`.
1573    */
1574   function _beforeTokenTransfers(
1575     address from,
1576     address to,
1577     uint256 startTokenId,
1578     uint256 quantity
1579   ) internal virtual {}
1580 
1581   /**
1582    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1583    * minting.
1584    *
1585    * startTokenId - the first token id to be transferred
1586    * quantity - the amount to be transferred
1587    *
1588    * Calling conditions:
1589    *
1590    * - when `from` and `to` are both non-zero.
1591    * - `from` and `to` are never both zero.
1592    */
1593   function _afterTokenTransfers(
1594     address from,
1595     address to,
1596     uint256 startTokenId,
1597     uint256 quantity
1598   ) internal virtual {}
1599 }
1600 // File: mycontract.sol
1601 
1602 pragma solidity ^0.8.0;
1603 
1604 contract StreetMachine is Ownable, ERC721A, ReentrancyGuard {
1605 
1606   uint256 public immutable maxPerAddressDuringMint;
1607   uint public maxSupply = 8000;
1608 
1609   struct SaleConfig {
1610     uint32 publicMintStartTime;
1611     uint32 MintStartTime;
1612     uint256 Price;
1613     uint256 AmountForWhitelist;
1614 
1615   }
1616 
1617   SaleConfig public saleConfig;
1618 
1619 
1620   constructor(
1621     uint256 maxBatchSize_,
1622     uint256 collectionSize_
1623   ) ERC721A("Street Machine", "SM", maxBatchSize_, collectionSize_) {
1624     maxPerAddressDuringMint = maxBatchSize_;
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
1642     require(quantity<=10, "reached max supply");
1643     require(totalSupply() + quantity <= collectionSize, "reached max supply");   
1644       require(
1645       numberMinted(msg.sender) + quantity <= 10,
1646       "can not mint this many"
1647     );
1648     _safeMint(msg.sender, quantity);
1649   }
1650 
1651   function isPublicSaleOn() public view returns (bool) {
1652     return
1653       saleConfig.Price != 0 &&
1654       saleConfig.MintStartTime != 0 &&
1655       block.timestamp >= saleConfig.MintStartTime;
1656   }
1657 
1658   uint256 public constant Price = 0 ether;
1659 
1660   function InitInfoOfSale(
1661     uint32 publicMintStartTime,
1662     uint32 mintStartTime,
1663     uint256 price,
1664     uint256 amountForWhitelist
1665   ) external onlyOwner {
1666     saleConfig = SaleConfig(
1667     publicMintStartTime,
1668     mintStartTime,
1669     price,
1670     amountForWhitelist
1671     );
1672   }
1673 
1674   function setMintStartTime(uint32 timestamp) external onlyOwner {
1675     saleConfig.MintStartTime = timestamp;
1676   }
1677 
1678   function setPublicMintStartTime(uint32 timestamp) external onlyOwner {
1679     saleConfig.publicMintStartTime = timestamp;
1680   }
1681 
1682   string private _baseTokenURI;
1683 
1684   function _baseURI() internal view virtual override returns (string memory) {
1685     return _baseTokenURI;
1686   }
1687 
1688   function setBaseURI(string calldata baseURI) external onlyOwner {
1689     _baseTokenURI = baseURI;
1690   }
1691 
1692   function numberMinted(address owner) public view returns (uint256) {
1693     return _numberMinted(owner);
1694   }
1695 
1696   function getOwnershipData(uint256 tokenId)
1697     external
1698     view
1699     returns (TokenOwnership memory)
1700   {
1701     return ownershipOf(tokenId);
1702   }  
1703 }