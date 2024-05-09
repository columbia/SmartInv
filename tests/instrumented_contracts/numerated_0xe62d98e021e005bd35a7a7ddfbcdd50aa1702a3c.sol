1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev These functions deal with verification of Merkle Tree proofs.
6  *
7  * The proofs can be generated using the JavaScript library
8  * https://github.com/miguelmota/merkletreejs[merkletreejs].
9  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
10  *
11  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
12  *
13  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
14  * hashing, or use a hash function other than keccak256 for hashing leaves.
15  * This is because the concatenation of a sorted pair of internal nodes in
16  * the merkle tree could be reinterpreted as a leaf value.
17  */
18 library MerkleProof {
19     /**
20      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
21      * defined by `root`. For this, a `proof` must be provided, containing
22      * sibling hashes on the branch from the leaf to the root of the tree. Each
23      * pair of leaves and each pair of pre-images are assumed to be sorted.
24      */
25     function verify(
26         bytes32[] memory proof,
27         bytes32 root,
28         bytes32 leaf
29     ) internal pure returns (bool) {
30         return processProof(proof, leaf) == root;
31     }
32 
33     /**
34      * @dev Calldata version of {verify}
35      *
36      * _Available since v4.7._
37      */
38     function verifyCalldata(
39         bytes32[] calldata proof,
40         bytes32 root,
41         bytes32 leaf
42     ) internal pure returns (bool) {
43         return processProofCalldata(proof, leaf) == root;
44     }
45 
46     /**
47      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
48      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
49      * hash matches the root of the tree. When processing the proof, the pairs
50      * of leafs & pre-images are assumed to be sorted.
51      *
52      * _Available since v4.4._
53      */
54     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
55         bytes32 computedHash = leaf;
56         for (uint256 i = 0; i < proof.length; i++) {
57             computedHash = _hashPair(computedHash, proof[i]);
58         }
59         return computedHash;
60     }
61 
62     /**
63      * @dev Calldata version of {processProof}
64      *
65      * _Available since v4.7._
66      */
67     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
68         bytes32 computedHash = leaf;
69         for (uint256 i = 0; i < proof.length; i++) {
70             computedHash = _hashPair(computedHash, proof[i]);
71         }
72         return computedHash;
73     }
74 
75     /**
76      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
77      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
78      *
79      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
80      *
81      * _Available since v4.7._
82      */
83     function multiProofVerify(
84         bytes32[] memory proof,
85         bool[] memory proofFlags,
86         bytes32 root,
87         bytes32[] memory leaves
88     ) internal pure returns (bool) {
89         return processMultiProof(proof, proofFlags, leaves) == root;
90     }
91 
92     /**
93      * @dev Calldata version of {multiProofVerify}
94      *
95      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
96      *
97      * _Available since v4.7._
98      */
99     function multiProofVerifyCalldata(
100         bytes32[] calldata proof,
101         bool[] calldata proofFlags,
102         bytes32 root,
103         bytes32[] memory leaves
104     ) internal pure returns (bool) {
105         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
106     }
107 
108     /**
109      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
110      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
111      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
112      * respectively.
113      *
114      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
115      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
116      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
117      *
118      * _Available since v4.7._
119      */
120     function processMultiProof(
121         bytes32[] memory proof,
122         bool[] memory proofFlags,
123         bytes32[] memory leaves
124     ) internal pure returns (bytes32 merkleRoot) {
125         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
126         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
127         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
128         // the merkle tree.
129         uint256 leavesLen = leaves.length;
130         uint256 totalHashes = proofFlags.length;
131 
132         // Check proof validity.
133         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
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
145         //   `proof` array.
146         for (uint256 i = 0; i < totalHashes; i++) {
147             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
148             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
149             hashes[i] = _hashPair(a, b);
150         }
151 
152         if (totalHashes > 0) {
153             return hashes[totalHashes - 1];
154         } else if (leavesLen > 0) {
155             return leaves[0];
156         } else {
157             return proof[0];
158         }
159     }
160 
161     /**
162      * @dev Calldata version of {processMultiProof}.
163      *
164      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
165      *
166      * _Available since v4.7._
167      */
168     function processMultiProofCalldata(
169         bytes32[] calldata proof,
170         bool[] calldata proofFlags,
171         bytes32[] memory leaves
172     ) internal pure returns (bytes32 merkleRoot) {
173         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
174         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
175         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
176         // the merkle tree.
177         uint256 leavesLen = leaves.length;
178         uint256 totalHashes = proofFlags.length;
179 
180         // Check proof validity.
181         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
182 
183         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
184         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
185         bytes32[] memory hashes = new bytes32[](totalHashes);
186         uint256 leafPos = 0;
187         uint256 hashPos = 0;
188         uint256 proofPos = 0;
189         // At each step, we compute the next hash using two values:
190         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
191         //   get the next hash.
192         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
193         //   `proof` array.
194         for (uint256 i = 0; i < totalHashes; i++) {
195             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
196             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
197             hashes[i] = _hashPair(a, b);
198         }
199 
200         if (totalHashes > 0) {
201             return hashes[totalHashes - 1];
202         } else if (leavesLen > 0) {
203             return leaves[0];
204         } else {
205             return proof[0];
206         }
207     }
208 
209     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
210         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
211     }
212 
213     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
214         /// @solidity memory-safe-assembly
215         assembly {
216             mstore(0x00, a)
217             mstore(0x20, b)
218             value := keccak256(0x00, 0x40)
219         }
220     }
221 }
222 
223 /*
224  * @dev Provides information about the current execution context, including the
225  * sender of the transaction and its data. While these are generally available
226  * via msg.sender and msg.data, they should not be accessed in such a direct
227  * manner, since when dealing with meta-transactions the account sending and
228  * paying for execution may not be the actual sender (as far as an application
229  * is concerned).
230  *
231  * This contract is only required for intermediate, library-like contracts.
232  */
233 abstract contract Context {
234     function _msgSender() internal view virtual returns (address) {
235         return msg.sender;
236     }
237 
238     function _msgData() internal view virtual returns (bytes calldata) {
239         return msg.data;
240     }
241 }
242 
243 /**
244  * @dev Interface of the ERC165 standard, as defined in the
245  * https://eips.ethereum.org/EIPS/eip-165[EIP].
246  *
247  * Implementers can declare support of contract interfaces, which can then be
248  * queried by others ({ERC165Checker}).
249  *
250  * For an implementation, see {ERC165}.
251  */
252 interface IERC165 {
253     /**
254      * @dev Returns true if this contract implements the interface defined by
255      * `interfaceId`. See the corresponding
256      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
257      * to learn more about how these ids are created.
258      *
259      * This function call must use less than 30 000 gas.
260      */
261     function supportsInterface(bytes4 interfaceId) external view returns (bool);
262 }
263 /**
264  * @dev Required interface of an ERC721 compliant contract.
265  */
266 interface IERC721 is IERC165 {
267     /**
268      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
269      */
270     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
271 
272     /**
273      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
274      */
275     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
276 
277     /**
278      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
279      */
280     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
281 
282     /**
283      * @dev Returns the number of tokens in ``owner``'s account.
284      */
285     function balanceOf(address owner) external view returns (uint256 balance);
286 
287     /**
288      * @dev Returns the owner of the `tokenId` token.
289      *
290      * Requirements:
291      *
292      * - `tokenId` must exist.
293      */
294     function ownerOf(uint256 tokenId) external view returns (address owner);
295 
296     /**
297      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
298      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
299      *
300      * Requirements:
301      *
302      * - `from` cannot be the zero address.
303      * - `to` cannot be the zero address.
304      * - `tokenId` token must exist and be owned by `from`.
305      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
306      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
307      *
308      * Emits a {Transfer} event.
309      */
310     function safeTransferFrom(
311         address from,
312         address to,
313         uint256 tokenId
314     ) external;
315 
316     /**
317      * @dev Transfers `tokenId` token from `from` to `to`.
318      *
319      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
320      *
321      * Requirements:
322      *
323      * - `from` cannot be the zero address.
324      * - `to` cannot be the zero address.
325      * - `tokenId` token must be owned by `from`.
326      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
327      *
328      * Emits a {Transfer} event.
329      */
330     function transferFrom(
331         address from,
332         address to,
333         uint256 tokenId
334     ) external;
335 
336     /**
337      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
338      * The approval is cleared when the token is transferred.
339      *
340      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
341      *
342      * Requirements:
343      *
344      * - The caller must own the token or be an approved operator.
345      * - `tokenId` must exist.
346      *
347      * Emits an {Approval} event.
348      */
349     function approve(address to, uint256 tokenId) external;
350 
351     /**
352      * @dev Returns the account approved for `tokenId` token.
353      *
354      * Requirements:
355      *
356      * - `tokenId` must exist.
357      */
358     function getApproved(uint256 tokenId) external view returns (address operator);
359 
360     /**
361      * @dev Approve or remove `operator` as an operator for the caller.
362      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
363      *
364      * Requirements:
365      *
366      * - The `operator` cannot be the caller.
367      *
368      * Emits an {ApprovalForAll} event.
369      */
370     function setApprovalForAll(address operator, bool _approved) external;
371 
372     /**
373      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
374      *
375      * See {setApprovalForAll}
376      */
377     function isApprovedForAll(address owner, address operator) external view returns (bool);
378 
379     /**
380      * @dev Safely transfers `tokenId` token from `from` to `to`.
381      *
382      * Requirements:
383      *
384      * - `from` cannot be the zero address.
385      * - `to` cannot be the zero address.
386      * - `tokenId` token must exist and be owned by `from`.
387      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
388      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
389      *
390      * Emits a {Transfer} event.
391      */
392     function safeTransferFrom(
393         address from,
394         address to,
395         uint256 tokenId,
396         bytes calldata data
397     ) external;
398 }
399 
400 
401 /**
402  * @title ERC721 token receiver interface
403  * @dev Interface for any contract that wants to support safeTransfers
404  * from ERC721 asset contracts.
405  */
406 interface IERC721Receiver {
407     /**
408      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
409      * by `operator` from `from`, this function is called.
410      *
411      * It must return its Solidity selector to confirm the token transfer.
412      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
413      *
414      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
415      */
416     function onERC721Received(
417         address operator,
418         address from,
419         uint256 tokenId,
420         bytes calldata data
421     ) external returns (bytes4);
422 }
423 
424 
425 pragma solidity ^0.8.0;
426 
427 
428 /**
429  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
430  * @dev See https://eips.ethereum.org/EIPS/eip-721
431  */
432 interface IERC721Metadata is IERC721 {
433     /**
434      * @dev Returns the token collection name.
435      */
436     function name() external view returns (string memory);
437 
438     /**
439      * @dev Returns the token collection symbol.
440      */
441     function symbol() external view returns (string memory);
442 
443     /**
444      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
445      */
446     function tokenURI(uint256 tokenId) external view returns (string memory);
447 }
448 
449 
450 pragma solidity ^0.8.0;
451 
452 /**
453  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
454  * @dev See https://eips.ethereum.org/EIPS/eip-721
455  */
456 interface IERC721Enumerable is IERC721 {
457     /**
458      * @dev Returns the total amount of tokens stored by the contract.
459      */
460     function totalSupply() external view returns (uint256);
461 
462     /**
463      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
464      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
465      */
466     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
467 
468     /**
469      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
470      * Use along with {totalSupply} to enumerate all tokens.
471      */
472     function tokenByIndex(uint256 index) external view returns (uint256);
473 }
474 
475 pragma solidity ^0.8.0;
476 
477 /**
478  * @dev Collection of functions related to the address type
479  */
480 library Address {
481     /**
482      * @dev Returns true if `account` is a contract.
483      *
484      * [IMPORTANT]
485      * ====
486      * It is unsafe to assume that an address for which this function returns
487      * false is an externally-owned account (EOA) and not a contract.
488      *
489      * Among others, `isContract` will return false for the following
490      * types of addresses:
491      *
492      *  - an externally-owned account
493      *  - a contract in construction
494      *  - an address where a contract will be created
495      *  - an address where a contract lived, but was destroyed
496      * ====
497      */
498     function isContract(address account) internal view returns (bool) {
499         // This method relies on extcodesize, which returns 0 for contracts in
500         // construction, since the code is only stored at the end of the
501         // constructor execution.
502 
503         uint256 size;
504         assembly {
505             size := extcodesize(account)
506         }
507         return size > 0;
508     }
509 
510     /**
511      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
512      * `recipient`, forwarding all available gas and reverting on errors.
513      *
514      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
515      * of certain opcodes, possibly making contracts go over the 2300 gas limit
516      * imposed by `transfer`, making them unable to receive funds via
517      * `transfer`. {sendValue} removes this limitation.
518      *
519      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
520      *
521      * IMPORTANT: because control is transferred to `recipient`, care must be
522      * taken to not create reentrancy vulnerabilities. Consider using
523      * {ReentrancyGuard} or the
524      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
525      */
526     function sendValue(address payable recipient, uint256 amount) internal {
527         require(address(this).balance >= amount, "Address: insufficient balance");
528 
529         (bool success, ) = recipient.call{value: amount}("");
530         require(success, "Address: unable to send value, recipient may have reverted");
531     }
532 
533     /**
534      * @dev Performs a Solidity function call using a low level `call`. A
535      * plain `call` is an unsafe replacement for a function call: use this
536      * function instead.
537      *
538      * If `target` reverts with a revert reason, it is bubbled up by this
539      * function (like regular Solidity function calls).
540      *
541      * Returns the raw returned data. To convert to the expected return value,
542      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
543      *
544      * Requirements:
545      *
546      * - `target` must be a contract.
547      * - calling `target` with `data` must not revert.
548      *
549      * _Available since v3.1._
550      */
551     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
552         return functionCall(target, data, "Address: low-level call failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
557      * `errorMessage` as a fallback revert reason when `target` reverts.
558      *
559      * _Available since v3.1._
560      */
561     function functionCall(
562         address target,
563         bytes memory data,
564         string memory errorMessage
565     ) internal returns (bytes memory) {
566         return functionCallWithValue(target, data, 0, errorMessage);
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
571      * but also transferring `value` wei to `target`.
572      *
573      * Requirements:
574      *
575      * - the calling contract must have an ETH balance of at least `value`.
576      * - the called Solidity function must be `payable`.
577      *
578      * _Available since v3.1._
579      */
580     function functionCallWithValue(
581         address target,
582         bytes memory data,
583         uint256 value
584     ) internal returns (bytes memory) {
585         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
590      * with `errorMessage` as a fallback revert reason when `target` reverts.
591      *
592      * _Available since v3.1._
593      */
594     function functionCallWithValue(
595         address target,
596         bytes memory data,
597         uint256 value,
598         string memory errorMessage
599     ) internal returns (bytes memory) {
600         require(address(this).balance >= value, "Address: insufficient balance for call");
601         require(isContract(target), "Address: call to non-contract");
602 
603         (bool success, bytes memory returndata) = target.call{value: value}(data);
604         return _verifyCallResult(success, returndata, errorMessage);
605     }
606 
607     /**
608      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
609      * but performing a static call.
610      *
611      * _Available since v3.3._
612      */
613     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
614         return functionStaticCall(target, data, "Address: low-level static call failed");
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
619      * but performing a static call.
620      *
621      * _Available since v3.3._
622      */
623     function functionStaticCall(
624         address target,
625         bytes memory data,
626         string memory errorMessage
627     ) internal view returns (bytes memory) {
628         require(isContract(target), "Address: static call to non-contract");
629 
630         (bool success, bytes memory returndata) = target.staticcall(data);
631         return _verifyCallResult(success, returndata, errorMessage);
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
636      * but performing a delegate call.
637      *
638      * _Available since v3.4._
639      */
640     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
641         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
642     }
643 
644     /**
645      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
646      * but performing a delegate call.
647      *
648      * _Available since v3.4._
649      */
650     function functionDelegateCall(
651         address target,
652         bytes memory data,
653         string memory errorMessage
654     ) internal returns (bytes memory) {
655         require(isContract(target), "Address: delegate call to non-contract");
656 
657         (bool success, bytes memory returndata) = target.delegatecall(data);
658         return _verifyCallResult(success, returndata, errorMessage);
659     }
660 
661     function _verifyCallResult(
662         bool success,
663         bytes memory returndata,
664         string memory errorMessage
665     ) private pure returns (bytes memory) {
666         if (success) {
667             return returndata;
668         } else {
669             // Look for revert reason and bubble it up if present
670             if (returndata.length > 0) {
671                 // The easiest way to bubble the revert reason is using memory via assembly
672 
673                 assembly {
674                     let returndata_size := mload(returndata)
675                     revert(add(32, returndata), returndata_size)
676                 }
677             } else {
678                 revert(errorMessage);
679             }
680         }
681     }
682 }
683 
684 pragma solidity ^0.8.0;
685 
686 /**
687  * @dev Implementation of the {IERC165} interface.
688  *
689  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
690  * for the additional interface id that will be supported. For example:
691  *
692  * ```solidity
693  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
694  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
695  * }
696  * ```
697  *
698  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
699  */
700 abstract contract ERC165 is IERC165 {
701     /**
702      * @dev See {IERC165-supportsInterface}.
703      */
704     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
705         return interfaceId == type(IERC165).interfaceId;
706     }
707 }
708 
709 pragma solidity ^0.8.0;
710 
711 /**
712  * @dev Contract module which provides a basic access control mechanism, where
713  * there is an account (an owner) that can be granted exclusive access to
714  * specific functions.
715  *
716  * By default, the owner account will be the one that deploys the contract. This
717  * can later be changed with {transferOwnership}.
718  *
719  * This module is used through inheritance. It will make available the modifier
720  * `onlyOwner`, which can be applied to your functions to restrict their use to
721  * the owner.
722  */
723 abstract contract Ownable is Context {
724     address private _owner;
725 
726     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
727 
728     /**
729      * @dev Initializes the contract setting the deployer as the initial owner.
730      */
731     constructor() {
732         _setOwner(_msgSender());
733     }
734 
735     /**
736      * @dev Returns the address of the current owner.
737      */
738     function owner() public view virtual returns (address) {
739         return _owner;
740     }
741 
742     /**
743      * @dev Throws if called by any account other than the owner.
744      */
745     modifier onlyOwner() {
746         require(owner() == _msgSender(), "Ownable: caller is not the owner");
747         _;
748     }
749 
750     /**
751      * @dev Leaves the contract without owner. It will not be possible to call
752      * `onlyOwner` functions anymore. Can only be called by the current owner.
753      *
754      * NOTE: Renouncing ownership will leave the contract without an owner,
755      * thereby removing any functionality that is only available to the owner.
756      */
757     function renounceOwnership() public virtual onlyOwner {
758         _setOwner(address(0));
759     }
760 
761     /**
762      * @dev Transfers ownership of the contract to a new account (`newOwner`).
763      * Can only be called by the current owner.
764      */
765     function transferOwnership(address newOwner) public virtual onlyOwner {
766         require(newOwner != address(0), "Ownable: new owner is the zero address");
767         _setOwner(newOwner);
768     }
769 
770     function _setOwner(address newOwner) private {
771         address oldOwner = _owner;
772         _owner = newOwner;
773         emit OwnershipTransferred(oldOwner, newOwner);
774     }
775 }
776 
777 pragma solidity ^0.8.0;
778 
779 /**
780  * @dev Contract module that helps prevent reentrant calls to a function.
781  *
782  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
783  * available, which can be applied to functions to make sure there are no nested
784  * (reentrant) calls to them.
785  *
786  * Note that because there is a single `nonReentrant` guard, functions marked as
787  * `nonReentrant` may not call one another. This can be worked around by making
788  * those functions `private`, and then adding `external` `nonReentrant` entry
789  * points to them.
790  *
791  * TIP: If you would like to learn more about reentrancy and alternative ways
792  * to protect against it, check out our blog post
793  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
794  */
795 abstract contract ReentrancyGuard {
796     // Booleans are more expensive than uint256 or any type that takes up a full
797     // word because each write operation emits an extra SLOAD to first read the
798     // slot's contents, replace the bits taken up by the boolean, and then write
799     // back. This is the compiler's defense against contract upgrades and
800     // pointer aliasing, and it cannot be disabled.
801 
802     // The values being non-zero value makes deployment a bit more expensive,
803     // but in exchange the refund on every call to nonReentrant will be lower in
804     // amount. Since refunds are capped to a percentage of the total
805     // transaction's gas, it is best to keep them low in cases like this one, to
806     // increase the likelihood of the full refund coming into effect.
807     uint256 private constant _NOT_ENTERED = 1;
808     uint256 private constant _ENTERED = 2;
809 
810     uint256 private _status;
811 
812     constructor() {
813         _status = _NOT_ENTERED;
814     }
815 
816     /**
817      * @dev Prevents a contract from calling itself, directly or indirectly.
818      * Calling a `nonReentrant` function from another `nonReentrant`
819      * function is not supported. It is possible to prevent this from happening
820      * by making the `nonReentrant` function external, and make it call a
821      * `private` function that does the actual work.
822      */
823     modifier nonReentrant() {
824         // On the first call to nonReentrant, _notEntered will be true
825         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
826 
827         // Any calls to nonReentrant after this point will fail
828         _status = _ENTERED;
829 
830         _;
831 
832         // By storing the original value once again, a refund is triggered (see
833         // https://eips.ethereum.org/EIPS/eip-2200)
834         _status = _NOT_ENTERED;
835     }
836 }
837 
838 pragma solidity ^0.8.0;
839 
840 /**
841  * @dev String operations.
842  */
843 library Strings {
844     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
845 
846     /**
847      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
848      */
849     function toString(uint256 value) internal pure returns (string memory) {
850         // Inspired by OraclizeAPI's implementation - MIT licence
851         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
852 
853         if (value == 0) {
854             return "0";
855         }
856         uint256 temp = value;
857         uint256 digits;
858         while (temp != 0) {
859             digits++;
860             temp /= 10;
861         }
862         bytes memory buffer = new bytes(digits);
863         while (value != 0) {
864             digits -= 1;
865             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
866             value /= 10;
867         }
868         return string(buffer);
869     }
870 
871     /**
872      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
873      */
874     function toHexString(uint256 value) internal pure returns (string memory) {
875         if (value == 0) {
876             return "0x00";
877         }
878         uint256 temp = value;
879         uint256 length = 0;
880         while (temp != 0) {
881             length++;
882             temp >>= 8;
883         }
884         return toHexString(value, length);
885     }
886 
887     /**
888      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
889      */
890     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
891         bytes memory buffer = new bytes(2 * length + 2);
892         buffer[0] = "0";
893         buffer[1] = "x";
894         for (uint256 i = 2 * length + 1; i > 1; --i) {
895             buffer[i] = _HEX_SYMBOLS[value & 0xf];
896             value >>= 4;
897         }
898         require(value == 0, "Strings: hex length insufficient");
899         return string(buffer);
900     }
901 }
902 
903 /**
904  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
905  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
906  *
907  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
908  *
909  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
910  *
911  * Does not support burning tokens to address(0).
912  */
913 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
914     using Address for address;
915     using Strings for uint256;
916 
917     struct TokenOwnership {
918         address addr;
919         uint64 startTimestamp;
920     }
921 
922     struct AddressData {
923         uint128 balance;
924         uint128 numberMinted;
925     }
926 
927     uint256 internal currentIndex;
928 
929     // Token name
930     string private _name;
931 
932     // Token symbol
933     string private _symbol;
934 
935     // Mapping from token ID to ownership details
936     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
937     mapping(uint256 => TokenOwnership) internal _ownerships;
938 
939     // Mapping owner address to address data
940     mapping(address => AddressData) private _addressData;
941 
942     // Mapping from token ID to approved address
943     mapping(uint256 => address) private _tokenApprovals;
944 
945     // Mapping from owner to operator approvals
946     mapping(address => mapping(address => bool)) private _operatorApprovals;
947 
948     constructor(string memory name_, string memory symbol_) {
949         _name = name_;
950         _symbol = symbol_;
951     }
952 
953     /**
954      * @dev See {IERC721Enumerable-totalSupply}.
955      */
956     function totalSupply() public view override returns (uint256) {
957         return currentIndex;
958     }
959 
960     /**
961      * @dev See {IERC721Enumerable-tokenByIndex}.
962      */
963     function tokenByIndex(uint256 index) public view override returns (uint256) {
964         require(index < totalSupply(), 'ERC721A: global index out of bounds');
965         return index;
966     }
967 
968     /**
969      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
970      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
971      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
972      */
973     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
974         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
975         uint256 numMintedSoFar = totalSupply();
976         uint256 tokenIdsIdx;
977         address currOwnershipAddr;
978 
979         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
980         unchecked {
981             for (uint256 i; i < numMintedSoFar; i++) {
982                 TokenOwnership memory ownership = _ownerships[i];
983                 if (ownership.addr != address(0)) {
984                     currOwnershipAddr = ownership.addr;
985                 }
986                 if (currOwnershipAddr == owner) {
987                     if (tokenIdsIdx == index) {
988                         return i;
989                     }
990                     tokenIdsIdx++;
991                 }
992             }
993         }
994 
995         revert('ERC721A: unable to get token of owner by index');
996     }
997 
998     /**
999      * @dev See {IERC165-supportsInterface}.
1000      */
1001     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1002         return
1003             interfaceId == type(IERC721).interfaceId ||
1004             interfaceId == type(IERC721Metadata).interfaceId ||
1005             interfaceId == type(IERC721Enumerable).interfaceId ||
1006             super.supportsInterface(interfaceId);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-balanceOf}.
1011      */
1012     function balanceOf(address owner) public view override returns (uint256) {
1013         require(owner != address(0), 'ERC721A: balance query for the zero address');
1014         return uint256(_addressData[owner].balance);
1015     }
1016 
1017     function _numberMinted(address owner) internal view returns (uint256) {
1018         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1019         return uint256(_addressData[owner].numberMinted);
1020     }
1021 
1022     /**
1023      * Gas spent here starts off proportional to the maximum mint batch size.
1024      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1025      */
1026     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1027         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1028 
1029         unchecked {
1030             for (uint256 curr = tokenId; curr >= 0; curr--) {
1031                 TokenOwnership memory ownership = _ownerships[curr];
1032                 if (ownership.addr != address(0)) {
1033                     return ownership;
1034                 }
1035             }
1036         }
1037 
1038         revert('ERC721A: unable to determine the owner of token');
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-ownerOf}.
1043      */
1044     function ownerOf(uint256 tokenId) public view override returns (address) {
1045         return ownershipOf(tokenId).addr;
1046     }
1047 
1048     /**
1049      * @dev See {IERC721Metadata-name}.
1050      */
1051     function name() public view virtual override returns (string memory) {
1052         return _name;
1053     }
1054 
1055     /**
1056      * @dev See {IERC721Metadata-symbol}.
1057      */
1058     function symbol() public view virtual override returns (string memory) {
1059         return _symbol;
1060     }
1061 
1062     /**
1063      * @dev See {IERC721Metadata-tokenURI}.
1064      */
1065     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1066         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1067 
1068         string memory baseURI = _baseURI();
1069         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1070     }
1071 
1072     /**
1073      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1074      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1075      * by default, can be overriden in child contracts.
1076      */
1077     function _baseURI() internal view virtual returns (string memory) {
1078         return '';
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-approve}.
1083      */
1084     function approve(address to, uint256 tokenId) public override {
1085         address owner = ERC721A.ownerOf(tokenId);
1086         require(to != owner, 'ERC721A: approval to current owner');
1087 
1088         require(
1089             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1090             'ERC721A: approve caller is not owner nor approved for all'
1091         );
1092 
1093         _approve(to, tokenId, owner);
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-getApproved}.
1098      */
1099     function getApproved(uint256 tokenId) public view override returns (address) {
1100         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1101 
1102         return _tokenApprovals[tokenId];
1103     }
1104 
1105     /**
1106      * @dev See {IERC721-setApprovalForAll}.
1107      */
1108     function setApprovalForAll(address operator, bool approved) public override {
1109         require(operator != _msgSender(), 'ERC721A: approve to caller');
1110 
1111         _operatorApprovals[_msgSender()][operator] = approved;
1112         emit ApprovalForAll(_msgSender(), operator, approved);
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-isApprovedForAll}.
1117      */
1118     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1119         return _operatorApprovals[owner][operator];
1120     }
1121 
1122     /**
1123      * @dev See {IERC721-transferFrom}.
1124      */
1125     function transferFrom(
1126         address from,
1127         address to,
1128         uint256 tokenId
1129     ) public override {
1130         _transfer(from, to, tokenId);
1131     }
1132 
1133     /**
1134      * @dev See {IERC721-safeTransferFrom}.
1135      */
1136     function safeTransferFrom(
1137         address from,
1138         address to,
1139         uint256 tokenId
1140     ) public override {
1141         safeTransferFrom(from, to, tokenId, '');
1142     }
1143 
1144     /**
1145      * @dev See {IERC721-safeTransferFrom}.
1146      */
1147     function safeTransferFrom(
1148         address from,
1149         address to,
1150         uint256 tokenId,
1151         bytes memory _data
1152     ) public override {
1153         _transfer(from, to, tokenId);
1154         require(
1155             _checkOnERC721Received(from, to, tokenId, _data),
1156             'ERC721A: transfer to non ERC721Receiver implementer'
1157         );
1158     }
1159 
1160     /**
1161      * @dev Returns whether `tokenId` exists.
1162      *
1163      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1164      *
1165      * Tokens start existing when they are minted (`_mint`),
1166      */
1167     function _exists(uint256 tokenId) internal view returns (bool) {
1168         return tokenId < currentIndex;
1169     }
1170 
1171     function _safeMint(address to, uint256 quantity) internal {
1172         _safeMint(to, quantity, '');
1173     }
1174 
1175     /**
1176      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1177      *
1178      * Requirements:
1179      *
1180      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1181      * - `quantity` must be greater than 0.
1182      *
1183      * Emits a {Transfer} event.
1184      */
1185     function _safeMint(
1186         address to,
1187         uint256 quantity,
1188         bytes memory _data
1189     ) internal {
1190         _mint(to, quantity, _data, true);
1191     }
1192 
1193     /**
1194      * @dev Mints `quantity` tokens and transfers them to `to`.
1195      *
1196      * Requirements:
1197      *
1198      * - `to` cannot be the zero address.
1199      * - `quantity` must be greater than 0.
1200      *
1201      * Emits a {Transfer} event.
1202      */
1203     function _mint(
1204         address to,
1205         uint256 quantity,
1206         bytes memory _data,
1207         bool safe
1208     ) internal {
1209         uint256 startTokenId = currentIndex;
1210         require(to != address(0), 'ERC721A: mint to the zero address');
1211         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1212 
1213         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1214 
1215         // Overflows are incredibly unrealistic.
1216         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1217         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1218         unchecked {
1219             _addressData[to].balance += uint128(quantity);
1220             _addressData[to].numberMinted += uint128(quantity);
1221 
1222             _ownerships[startTokenId].addr = to;
1223             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1224 
1225             uint256 updatedIndex = startTokenId;
1226 
1227             for (uint256 i; i < quantity; i++) {
1228                 emit Transfer(address(0), to, updatedIndex);
1229                 if (safe) {
1230                     require(
1231                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1232                         'ERC721A: transfer to non ERC721Receiver implementer'
1233                     );
1234                 }
1235 
1236                 updatedIndex++;
1237             }
1238 
1239             currentIndex = updatedIndex;
1240         }
1241 
1242         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1243     }
1244 
1245     /**
1246      * @dev Transfers `tokenId` from `from` to `to`.
1247      *
1248      * Requirements:
1249      *
1250      * - `to` cannot be the zero address.
1251      * - `tokenId` token must be owned by `from`.
1252      *
1253      * Emits a {Transfer} event.
1254      */
1255     function _transfer(
1256         address from,
1257         address to,
1258         uint256 tokenId
1259     ) private {
1260         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1261 
1262         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1263             getApproved(tokenId) == _msgSender() ||
1264             isApprovedForAll(prevOwnership.addr, _msgSender()));
1265 
1266         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1267 
1268         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1269         require(to != address(0), 'ERC721A: transfer to the zero address');
1270 
1271         _beforeTokenTransfers(from, to, tokenId, 1);
1272 
1273         // Clear approvals from the previous owner
1274         _approve(address(0), tokenId, prevOwnership.addr);
1275 
1276         // Underflow of the sender's balance is impossible because we check for
1277         // ownership above and the recipient's balance can't realistically overflow.
1278         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1279         unchecked {
1280             _addressData[from].balance -= 1;
1281             _addressData[to].balance += 1;
1282 
1283             _ownerships[tokenId].addr = to;
1284             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1285 
1286             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1287             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1288             uint256 nextTokenId = tokenId + 1;
1289             if (_ownerships[nextTokenId].addr == address(0)) {
1290                 if (_exists(nextTokenId)) {
1291                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1292                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1293                 }
1294             }
1295         }
1296 
1297         emit Transfer(from, to, tokenId);
1298         _afterTokenTransfers(from, to, tokenId, 1);
1299     }
1300 
1301     /**
1302      * @dev Approve `to` to operate on `tokenId`
1303      *
1304      * Emits a {Approval} event.
1305      */
1306     function _approve(
1307         address to,
1308         uint256 tokenId,
1309         address owner
1310     ) private {
1311         _tokenApprovals[tokenId] = to;
1312         emit Approval(owner, to, tokenId);
1313     }
1314 
1315     /**
1316      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1317      * The call is not executed if the target address is not a contract.
1318      *
1319      * @param from address representing the previous owner of the given token ID
1320      * @param to target address that will receive the tokens
1321      * @param tokenId uint256 ID of the token to be transferred
1322      * @param _data bytes optional data to send along with the call
1323      * @return bool whether the call correctly returned the expected magic value
1324      */
1325     function _checkOnERC721Received(
1326         address from,
1327         address to,
1328         uint256 tokenId,
1329         bytes memory _data
1330     ) private returns (bool) {
1331         if (to.isContract()) {
1332             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1333                 return retval == IERC721Receiver(to).onERC721Received.selector;
1334             } catch (bytes memory reason) {
1335                 if (reason.length == 0) {
1336                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1337                 } else {
1338                     assembly {
1339                         revert(add(32, reason), mload(reason))
1340                     }
1341                 }
1342             }
1343         } else {
1344             return true;
1345         }
1346     }
1347 
1348     /**
1349      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1350      *
1351      * startTokenId - the first token id to be transferred
1352      * quantity - the amount to be transferred
1353      *
1354      * Calling conditions:
1355      *
1356      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1357      * transferred to `to`.
1358      * - When `from` is zero, `tokenId` will be minted for `to`.
1359      */
1360      
1361     function _beforeTokenTransfers(
1362         address from,
1363         address to,
1364         uint256 startTokenId,
1365         uint256 quantity
1366     ) internal virtual {}
1367 
1368     /**
1369      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1370      * minting.
1371      *
1372      * startTokenId - the first token id to be transferred
1373      * quantity - the amount to be transferred
1374      *
1375      * Calling conditions:
1376      *
1377      * - when `from` and `to` are both non-zero.
1378      * - `from` and `to` are never both zero.
1379      */
1380     function _afterTokenTransfers(
1381         address from,
1382         address to,
1383         uint256 startTokenId,
1384         uint256 quantity
1385     ) internal virtual {}
1386 }
1387 
1388 library SafeMath {
1389 
1390     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1391         unchecked {
1392             uint256 c = a + b;
1393             if (c < a) return (false, 0);
1394             return (true, c);
1395         }
1396     }
1397 
1398     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1399         unchecked {
1400             if (b > a) return (false, 0);
1401             return (true, a - b);
1402         }
1403     }
1404 
1405     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1406         unchecked {
1407 
1408             if (a == 0) return (true, 0);
1409             uint256 c = a * b;
1410             if (c / a != b) return (false, 0);
1411             return (true, c);
1412         }
1413     }
1414 
1415     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1416         unchecked {
1417             if (b == 0) return (false, 0);
1418             return (true, a / b);
1419         }
1420     }
1421 
1422     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1423         unchecked {
1424             if (b == 0) return (false, 0);
1425             return (true, a % b);
1426         }
1427     }
1428 
1429     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1430         return a + b;
1431     }
1432 
1433     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1434         return a - b;
1435     }
1436 
1437     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1438         return a * b;
1439     }
1440 
1441     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1442         return a / b;
1443     }
1444 
1445     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1446         return a % b;
1447     }
1448 
1449     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1450         unchecked {
1451             require(b <= a, errorMessage);
1452             return a - b;
1453         }
1454     }
1455 
1456     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1457         unchecked {
1458             require(b > 0, errorMessage);
1459             return a / b;
1460         }
1461     }
1462 
1463 
1464     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1465         unchecked {
1466             require(b > 0, errorMessage);
1467             return a % b;
1468         }
1469     }
1470 }
1471 
1472 library Counters {
1473     struct Counter {
1474 
1475         uint256 _value; 
1476     }
1477 
1478     function current(Counter storage counter) internal view returns (uint256) {
1479         return counter._value;
1480     }
1481 
1482     function increment(Counter storage counter) internal {
1483         unchecked {
1484             counter._value += 1;
1485         }
1486     }
1487 
1488     function decrement(Counter storage counter) internal {
1489         uint256 value = counter._value;
1490         require(value > 0, "Counter: decrement overflow");
1491         unchecked {
1492             counter._value = value - 1;
1493         }
1494     }
1495 }
1496 
1497 pragma solidity ^0.8.0;
1498 
1499 contract KenkyoGetaways is Ownable, ERC721A, ReentrancyGuard {  
1500     using Strings for uint256;
1501     bytes32 public merkleRoot = 0x2e0636acdcdbabe53705266c06b4af9f6a1c7441c4033327341b9902a0bb9291;
1502 
1503     string private _baseURIextended = "";
1504 
1505     bool public pauseMint = true;
1506 
1507     uint256 public constant MAX_NFT_SUPPLY = 777;
1508     address public kenkyoContract = 0x58091d4c4f8F37A103789Dc0341616717a6F31cf;
1509     uint256 public nftKenkyoGetawaysHoldAmount = 0;
1510     
1511     constructor() ERC721A("KenkyoGetaways", "$KKG") {
1512     }
1513 
1514     function mintNFTForOwner(uint256 amount) public onlyOwner {
1515         require(!pauseMint, "Paused!");
1516         require(totalSupply() < MAX_NFT_SUPPLY, "Sale has already ended");
1517 
1518         _safeMint(msg.sender, amount);
1519     }
1520 
1521     function walletHoldsNFT (address _wallet) public view returns (uint256) {
1522         return IERC721(kenkyoContract).balanceOf(_wallet);
1523     }
1524 
1525     function walletGetawaysHolds (address _wallet) public view returns (uint256) {
1526         return IERC721(address(this)).balanceOf(_wallet);
1527     }
1528 
1529     function setMerkleRoot (bytes32 _merkleRoot) public onlyOwner {
1530         merkleRoot = _merkleRoot;
1531     }
1532 
1533     function mintNFT(uint256 _quantity, bytes32[] calldata merkleProof) public payable {
1534         bytes32 node = keccak256(abi.encodePacked(msg.sender));
1535         require(MerkleProof.verify(merkleProof, merkleRoot, node), "invalid proof");
1536         uint256 nftHoldAmount = walletHoldsNFT(msg.sender);
1537         nftKenkyoGetawaysHoldAmount = walletGetawaysHolds(msg.sender);
1538 
1539         // require(nftHoldAmount > 0, "Not NFT holder!");
1540         require(_quantity > 0 && _quantity + nftKenkyoGetawaysHoldAmount <= nftHoldAmount, "You can not mint anymore");
1541         require(!pauseMint, "Paused!");
1542         require(totalSupply() + _quantity < MAX_NFT_SUPPLY, "Sale has already ended");
1543 
1544         _safeMint(msg.sender, _quantity);
1545     }
1546 
1547     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1548         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1549         return bytes(_baseURIextended).length > 0 ? string(abi.encodePacked(_baseURIextended, tokenId.toString(), ".json")) : "";
1550     }
1551 
1552     function _baseURI() internal view virtual override returns (string memory) {
1553         return _baseURIextended;
1554     }
1555 
1556     function setBaseURI(string memory baseURI_) external onlyOwner() {
1557         _baseURIextended = baseURI_;
1558     }
1559 
1560     function tokenMinted() public view returns (uint256) {
1561         return totalSupply();
1562     }
1563 
1564     function pause() public onlyOwner {
1565         pauseMint = true;
1566     }
1567 
1568     function unPause() public onlyOwner {
1569         pauseMint = false;
1570     }
1571 
1572     function getOwnershipData(uint256 tokenId)
1573         external
1574         view
1575         returns (TokenOwnership memory)
1576     {
1577         return ownershipOf(tokenId);
1578     }
1579 
1580     function setKenkyoContract (address _contract) external onlyOwner() {
1581         kenkyoContract = _contract;
1582     }
1583 }