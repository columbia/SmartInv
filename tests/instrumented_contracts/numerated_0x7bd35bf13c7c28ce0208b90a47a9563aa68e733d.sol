1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-13
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Tree proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Calldata version of {verify}
39      *
40      * _Available since v4.7._
41      */
42     function verifyCalldata(
43         bytes32[] calldata proof,
44         bytes32 root,
45         bytes32 leaf
46     ) internal pure returns (bool) {
47         return processProofCalldata(proof, leaf) == root;
48     }
49 
50     /**
51      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
52      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
53      * hash matches the root of the tree. When processing the proof, the pairs
54      * of leafs & pre-images are assumed to be sorted.
55      *
56      * _Available since v4.4._
57      */
58     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
59         bytes32 computedHash = leaf;
60         for (uint256 i = 0; i < proof.length; i++) {
61             computedHash = _hashPair(computedHash, proof[i]);
62         }
63         return computedHash;
64     }
65 
66     /**
67      * @dev Calldata version of {processProof}
68      *
69      * _Available since v4.7._
70      */
71     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
72         bytes32 computedHash = leaf;
73         for (uint256 i = 0; i < proof.length; i++) {
74             computedHash = _hashPair(computedHash, proof[i]);
75         }
76         return computedHash;
77     }
78 
79     /**
80      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
81      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
82      *
83      * _Available since v4.7._
84      */
85     function multiProofVerify(
86         bytes32[] memory proof,
87         bool[] memory proofFlags,
88         bytes32 root,
89         bytes32[] memory leaves
90     ) internal pure returns (bool) {
91         return processMultiProof(proof, proofFlags, leaves) == root;
92     }
93 
94     /**
95      * @dev Calldata version of {multiProofVerify}
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
109      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
110      * consuming from one or the other at each step according to the instructions given by
111      * `proofFlags`.
112      *
113      * _Available since v4.7._
114      */
115     function processMultiProof(
116         bytes32[] memory proof,
117         bool[] memory proofFlags,
118         bytes32[] memory leaves
119     ) internal pure returns (bytes32 merkleRoot) {
120         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
121         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
122         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
123         // the merkle tree.
124         uint256 leavesLen = leaves.length;
125         uint256 totalHashes = proofFlags.length;
126 
127         // Check proof validity.
128         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
129 
130         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
131         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
132         bytes32[] memory hashes = new bytes32[](totalHashes);
133         uint256 leafPos = 0;
134         uint256 hashPos = 0;
135         uint256 proofPos = 0;
136         // At each step, we compute the next hash using two values:
137         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
138         //   get the next hash.
139         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
140         //   `proof` array.
141         for (uint256 i = 0; i < totalHashes; i++) {
142             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
143             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
144             hashes[i] = _hashPair(a, b);
145         }
146 
147         if (totalHashes > 0) {
148             return hashes[totalHashes - 1];
149         } else if (leavesLen > 0) {
150             return leaves[0];
151         } else {
152             return proof[0];
153         }
154     }
155 
156     /**
157      * @dev Calldata version of {processMultiProof}
158      *
159      * _Available since v4.7._
160      */
161     function processMultiProofCalldata(
162         bytes32[] calldata proof,
163         bool[] calldata proofFlags,
164         bytes32[] memory leaves
165     ) internal pure returns (bytes32 merkleRoot) {
166         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
167         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
168         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
169         // the merkle tree.
170         uint256 leavesLen = leaves.length;
171         uint256 totalHashes = proofFlags.length;
172 
173         // Check proof validity.
174         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
175 
176         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
177         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
178         bytes32[] memory hashes = new bytes32[](totalHashes);
179         uint256 leafPos = 0;
180         uint256 hashPos = 0;
181         uint256 proofPos = 0;
182         // At each step, we compute the next hash using two values:
183         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
184         //   get the next hash.
185         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
186         //   `proof` array.
187         for (uint256 i = 0; i < totalHashes; i++) {
188             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
189             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
190             hashes[i] = _hashPair(a, b);
191         }
192 
193         if (totalHashes > 0) {
194             return hashes[totalHashes - 1];
195         } else if (leavesLen > 0) {
196             return leaves[0];
197         } else {
198             return proof[0];
199         }
200     }
201 
202     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
203         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
204     }
205 
206     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
207         /// @solidity memory-safe-assembly
208         assembly {
209             mstore(0x00, a)
210             mstore(0x20, b)
211             value := keccak256(0x00, 0x40)
212         }
213     }
214 }
215 pragma solidity ^0.8.0;
216 
217 // Sources flattened with hardhat v2.3.0 https://hardhat.org
218 
219 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.1.0
220 
221 /**
222  * @dev Interface of the ERC165 standard, as defined in the
223  * https://eips.ethereum.org/EIPS/eip-165[EIP].
224  *
225  * Implementers can declare support of contract interfaces, which can then be
226  * queried by others ({ERC165Checker}).
227  *
228  * For an implementation, see {ERC165}.
229  */
230 interface IERC165 {
231     /**
232      * @dev Returns true if this contract implements the interface defined by
233      * `interfaceId`. See the corresponding
234      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
235      * to learn more about how these ids are created.
236      *
237      * This function call must use less than 30 000 gas.
238      */
239     function supportsInterface(bytes4 interfaceId) external view returns (bool);
240 }
241 
242 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.1.0
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @dev Required interface of an ERC721 compliant contract.
248  */
249 interface IERC721 is IERC165 {
250     /**
251      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
252      */
253     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
254 
255     /**
256      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
257      */
258     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
259 
260     /**
261      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
262      */
263     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
264 
265     /**
266      * @dev Returns the number of tokens in ``owner``'s account.
267      */
268     function balanceOf(address owner) external view returns (uint256 balance);
269 
270     /**
271      * @dev Returns the owner of the `tokenId` token.
272      *
273      * Requirements:
274      *
275      * - `tokenId` must exist.
276      */
277     function ownerOf(uint256 tokenId) external view returns (address owner);
278 
279     /**
280      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
281      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
282      *
283      * Requirements:
284      *
285      * - `from` cannot be the zero address.
286      * - `to` cannot be the zero address.
287      * - `tokenId` token must exist and be owned by `from`.
288      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
289      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
290      *
291      * Emits a {Transfer} event.
292      */
293     function safeTransferFrom(
294         address from,
295         address to,
296         uint256 tokenId
297     ) external;
298 
299     /**
300      * @dev Transfers `tokenId` token from `from` to `to`.
301      *
302      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
303      *
304      * Requirements:
305      *
306      * - `from` cannot be the zero address.
307      * - `to` cannot be the zero address.
308      * - `tokenId` token must be owned by `from`.
309      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
310      *
311      * Emits a {Transfer} event.
312      */
313     function transferFrom(
314         address from,
315         address to,
316         uint256 tokenId
317     ) external;
318 
319     /**
320      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
321      * The approval is cleared when the token is transferred.
322      *
323      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
324      *
325      * Requirements:
326      *
327      * - The caller must own the token or be an approved operator.
328      * - `tokenId` must exist.
329      *
330      * Emits an {Approval} event.
331      */
332     function approve(address to, uint256 tokenId) external;
333 
334     /**
335      * @dev Returns the account approved for `tokenId` token.
336      *
337      * Requirements:
338      *
339      * - `tokenId` must exist.
340      */
341     function getApproved(uint256 tokenId) external view returns (address operator);
342 
343     /**
344      * @dev Approve or remove `operator` as an operator for the caller.
345      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
346      *
347      * Requirements:
348      *
349      * - The `operator` cannot be the caller.
350      *
351      * Emits an {ApprovalForAll} event.
352      */
353     function setApprovalForAll(address operator, bool _approved) external;
354 
355     /**
356      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
357      *
358      * See {setApprovalForAll}
359      */
360     function isApprovedForAll(address owner, address operator) external view returns (bool);
361 
362     /**
363      * @dev Safely transfers `tokenId` token from `from` to `to`.
364      *
365      * Requirements:
366      *
367      * - `from` cannot be the zero address.
368      * - `to` cannot be the zero address.
369      * - `tokenId` token must exist and be owned by `from`.
370      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
371      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
372      *
373      * Emits a {Transfer} event.
374      */
375     function safeTransferFrom(
376         address from,
377         address to,
378         uint256 tokenId,
379         bytes calldata data
380     ) external;
381 }
382 
383 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.1.0
384 
385 pragma solidity ^0.8.0;
386 
387 /**
388  * @title ERC721 token receiver interface
389  * @dev Interface for any contract that wants to support safeTransfers
390  * from ERC721 asset contracts.
391  */
392 interface IERC721Receiver {
393     /**
394      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
395      * by `operator` from `from`, this function is called.
396      *
397      * It must return its Solidity selector to confirm the token transfer.
398      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
399      *
400      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
401      */
402     function onERC721Received(
403         address operator,
404         address from,
405         uint256 tokenId,
406         bytes calldata data
407     ) external returns (bytes4);
408 }
409 
410 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.1.0
411 
412 pragma solidity ^0.8.0;
413 
414 /**
415  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
416  * @dev See https://eips.ethereum.org/EIPS/eip-721
417  */
418 interface IERC721Metadata is IERC721 {
419     /**
420      * @dev Returns the token collection name.
421      */
422     function name() external view returns (string memory);
423 
424     /**
425      * @dev Returns the token collection symbol.
426      */
427     function symbol() external view returns (string memory);
428 
429     /**
430      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
431      */
432     function tokenURI(uint256 tokenId) external view returns (string memory);
433 }
434 
435 // File @openzeppelin/contracts/utils/Address.sol@v4.1.0
436 
437 pragma solidity ^0.8.0;
438 
439 /**
440  * @dev Collection of functions related to the address type
441  */
442 library Address {
443     /**
444      * @dev Returns true if `account` is a contract.
445      *
446      * [IMPORTANT]
447      * ====
448      * It is unsafe to assume that an address for which this function returns
449      * false is an externally-owned account (EOA) and not a contract.
450      *
451      * Among others, `isContract` will return false for the following
452      * types of addresses:
453      *
454      *  - an externally-owned account
455      *  - a contract in construction
456      *  - an address where a contract will be created
457      *  - an address where a contract lived, but was destroyed
458      * ====
459      */
460     function isContract(address account) internal view returns (bool) {
461         // This method relies on extcodesize, which returns 0 for contracts in
462         // construction, since the code is only stored at the end of the
463         // constructor execution.
464 
465         uint256 size;
466         // solhint-disable-next-line no-inline-assembly
467         assembly {
468             size := extcodesize(account)
469         }
470         return size > 0;
471     }
472 
473     /**
474      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
475      * `recipient`, forwarding all available gas and reverting on errors.
476      *
477      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
478      * of certain opcodes, possibly making contracts go over the 2300 gas limit
479      * imposed by `transfer`, making them unable to receive funds via
480      * `transfer`. {sendValue} removes this limitation.
481      *
482      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
483      *
484      * IMPORTANT: because control is transferred to `recipient`, care must be
485      * taken to not create reentrancy vulnerabilities. Consider using
486      * {ReentrancyGuard} or the
487      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
488      */
489     function sendValue(address payable recipient, uint256 amount) internal {
490         require(address(this).balance >= amount, 'Address: insufficient balance');
491 
492         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
493         (bool success, ) = recipient.call{value: amount}('');
494         require(success, 'Address: unable to send value, recipient may have reverted');
495     }
496 
497     /**
498      * @dev Performs a Solidity function call using a low level `call`. A
499      * plain`call` is an unsafe replacement for a function call: use this
500      * function instead.
501      *
502      * If `target` reverts with a revert reason, it is bubbled up by this
503      * function (like regular Solidity function calls).
504      *
505      * Returns the raw returned data. To convert to the expected return value,
506      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
507      *
508      * Requirements:
509      *
510      * - `target` must be a contract.
511      * - calling `target` with `data` must not revert.
512      *
513      * _Available since v3.1._
514      */
515     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
516         return functionCall(target, data, 'Address: low-level call failed');
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
521      * `errorMessage` as a fallback revert reason when `target` reverts.
522      *
523      * _Available since v3.1._
524      */
525     function functionCall(
526         address target,
527         bytes memory data,
528         string memory errorMessage
529     ) internal returns (bytes memory) {
530         return functionCallWithValue(target, data, 0, errorMessage);
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
535      * but also transferring `value` wei to `target`.
536      *
537      * Requirements:
538      *
539      * - the calling contract must have an ETH balance of at least `value`.
540      * - the called Solidity function must be `payable`.
541      *
542      * _Available since v3.1._
543      */
544     function functionCallWithValue(
545         address target,
546         bytes memory data,
547         uint256 value
548     ) internal returns (bytes memory) {
549         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
554      * with `errorMessage` as a fallback revert reason when `target` reverts.
555      *
556      * _Available since v3.1._
557      */
558     function functionCallWithValue(
559         address target,
560         bytes memory data,
561         uint256 value,
562         string memory errorMessage
563     ) internal returns (bytes memory) {
564         require(address(this).balance >= value, 'Address: insufficient balance for call');
565         require(isContract(target), 'Address: call to non-contract');
566 
567         // solhint-disable-next-line avoid-low-level-calls
568         (bool success, bytes memory returndata) = target.call{value: value}(data);
569         return _verifyCallResult(success, returndata, errorMessage);
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
574      * but performing a static call.
575      *
576      * _Available since v3.3._
577      */
578     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
579         return functionStaticCall(target, data, 'Address: low-level static call failed');
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
584      * but performing a static call.
585      *
586      * _Available since v3.3._
587      */
588     function functionStaticCall(
589         address target,
590         bytes memory data,
591         string memory errorMessage
592     ) internal view returns (bytes memory) {
593         require(isContract(target), 'Address: static call to non-contract');
594 
595         // solhint-disable-next-line avoid-low-level-calls
596         (bool success, bytes memory returndata) = target.staticcall(data);
597         return _verifyCallResult(success, returndata, errorMessage);
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
602      * but performing a delegate call.
603      *
604      * _Available since v3.4._
605      */
606     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
607         return functionDelegateCall(target, data, 'Address: low-level delegate call failed');
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
612      * but performing a delegate call.
613      *
614      * _Available since v3.4._
615      */
616     function functionDelegateCall(
617         address target,
618         bytes memory data,
619         string memory errorMessage
620     ) internal returns (bytes memory) {
621         require(isContract(target), 'Address: delegate call to non-contract');
622 
623         // solhint-disable-next-line avoid-low-level-calls
624         (bool success, bytes memory returndata) = target.delegatecall(data);
625         return _verifyCallResult(success, returndata, errorMessage);
626     }
627 
628     function _verifyCallResult(
629         bool success,
630         bytes memory returndata,
631         string memory errorMessage
632     ) private pure returns (bytes memory) {
633         if (success) {
634             return returndata;
635         } else {
636             // Look for revert reason and bubble it up if present
637             if (returndata.length > 0) {
638                 // The easiest way to bubble the revert reason is using memory via assembly
639 
640                 // solhint-disable-next-line no-inline-assembly
641                 assembly {
642                     let returndata_size := mload(returndata)
643                     revert(add(32, returndata), returndata_size)
644                 }
645             } else {
646                 revert(errorMessage);
647             }
648         }
649     }
650 }
651 
652 // File @openzeppelin/contracts/utils/Context.sol@v4.1.0
653 
654 pragma solidity ^0.8.0;
655 
656 /*
657  * @dev Provides information about the current execution context, including the
658  * sender of the transaction and its data. While these are generally available
659  * via msg.sender and msg.data, they should not be accessed in such a direct
660  * manner, since when dealing with meta-transactions the account sending and
661  * paying for execution may not be the actual sender (as far as an application
662  * is concerned).
663  *
664  * This contract is only required for intermediate, library-like contracts.
665  */
666 abstract contract Context {
667     function _msgSender() internal view virtual returns (address) {
668         return msg.sender;
669     }
670 
671     function _msgData() internal view virtual returns (bytes calldata) {
672         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
673         return msg.data;
674     }
675 }
676 
677 // File @openzeppelin/contracts/utils/Strings.sol@v4.1.0
678 
679 pragma solidity ^0.8.0;
680 
681 /**
682  * @dev String operations.
683  */
684 library Strings {
685     bytes16 private constant alphabet = '0123456789abcdef';
686 
687     /**
688      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
689      */
690     function toString(uint256 value) internal pure returns (string memory) {
691         // Inspired by OraclizeAPI's implementation - MIT licence
692         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
693 
694         if (value == 0) {
695             return '0';
696         }
697         uint256 temp = value;
698         uint256 digits;
699         while (temp != 0) {
700             digits++;
701             temp /= 10;
702         }
703         bytes memory buffer = new bytes(digits);
704         while (value != 0) {
705             digits -= 1;
706             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
707             value /= 10;
708         }
709         return string(buffer);
710     }
711 
712     /**
713      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
714      */
715     function toHexString(uint256 value) internal pure returns (string memory) {
716         if (value == 0) {
717             return '0x00';
718         }
719         uint256 temp = value;
720         uint256 length = 0;
721         while (temp != 0) {
722             length++;
723             temp >>= 8;
724         }
725         return toHexString(value, length);
726     }
727 
728     /**
729      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
730      */
731     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
732         bytes memory buffer = new bytes(2 * length + 2);
733         buffer[0] = '0';
734         buffer[1] = 'x';
735         for (uint256 i = 2 * length + 1; i > 1; --i) {
736             buffer[i] = alphabet[value & 0xf];
737             value >>= 4;
738         }
739         require(value == 0, 'Strings: hex length insufficient');
740         return string(buffer);
741     }
742 
743 
744     /**
745      * @dev format given uint to memory string
746      *
747      * @param _i uint to convert
748      * @return string is uint converted to string
749      */
750     function _uint2str(uint _i) internal pure returns (string memory) {
751       if (_i == 0) {
752         return "0";
753       }
754       uint j = _i;
755       uint len;
756       while (j != 0) {
757         len++;
758         j /= 10;
759       }
760       bytes memory bstr = new bytes(len);
761       uint k = len;
762       while (_i != 0) {
763         k = k-1;
764         uint8 temp = (48 + uint8(_i - _i / 10 * 10));
765         bytes1 b1 = bytes1(temp);
766         bstr[k] = b1;
767         _i /= 10;
768       }
769       return string(bstr);
770     }
771 
772 
773 }
774 
775 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.1.0
776 
777 pragma solidity ^0.8.0;
778 
779 /**
780  * @dev Implementation of the {IERC165} interface.
781  *
782  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
783  * for the additional interface id that will be supported. For example:
784  *
785  * ```solidity
786  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
787  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
788  * }
789  * ```
790  *
791  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
792  */
793 abstract contract ERC165 is IERC165 {
794     /**
795      * @dev See {IERC165-supportsInterface}.
796      */
797     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
798         return interfaceId == type(IERC165).interfaceId;
799     }
800 }
801 
802 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.1.0
803 
804 pragma solidity ^0.8.0;
805 
806 /**
807  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
808  * the Metadata extension, but not including the Enumerable extension, which is available separately as
809  * {ERC721Enumerable}.
810  */
811 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
812     using Address for address;
813     using Strings for uint256;
814 
815     // Token name
816     string private _name;
817 
818     // Token symbol
819     string private _symbol;
820 
821     // Mapping from token ID to owner address
822     mapping(uint256 => address) private _owners;
823 
824     // Mapping owner address to token count
825     mapping(address => uint256) private _balances;
826 
827     // Mapping from token ID to approved address
828     mapping(uint256 => address) private _tokenApprovals;
829 
830     // Mapping from owner to operator approvals
831     mapping(address => mapping(address => bool)) private _operatorApprovals;
832 
833     /**
834      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
835      */
836     constructor(string memory name_, string memory symbol_) {
837         _name = name_;
838         _symbol = symbol_;
839     }
840 
841     /**
842      * @dev See {IERC165-supportsInterface}.
843      */
844     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
845         return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || super.supportsInterface(interfaceId);
846     }
847 
848     /**
849      * @dev See {IERC721-balanceOf}.
850      */
851     function balanceOf(address owner) public view virtual override returns (uint256) {
852         require(owner != address(0), 'ERC721: balance query for the zero address');
853         return _balances[owner];
854     }
855 
856     /**
857      * @dev See {IERC721-ownerOf}.
858      */
859     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
860         address owner = _owners[tokenId];
861         require(owner != address(0), 'ERC721: owner query for nonexistent token');
862         return owner;
863     }
864 
865     /**
866      * @dev See {IERC721Metadata-name}.
867      */
868     function name() public view virtual override returns (string memory) {
869         return _name;
870     }
871 
872     /**
873      * @dev See {IERC721Metadata-symbol}.
874      */
875     function symbol() public view virtual override returns (string memory) {
876         return _symbol;
877     }
878 
879     
880 
881     /**
882      * @dev See {IERC721Metadata-tokenURI}.
883      */
884     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
885         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
886 
887         string memory baseURI = _baseURI();
888         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, abi.encodePacked(tokenId.toString(), ".json"))) : '';
889     }
890 
891     /**
892      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
893      * in child contracts.
894      */
895     function _baseURI() internal view virtual returns (string memory) {
896         return '';
897     }
898 
899     /**
900      * @dev See {IERC721-approve}.
901      */
902     function approve(address to, uint256 tokenId) public virtual override {
903         address owner = ERC721.ownerOf(tokenId);
904         require(to != owner, 'ERC721: approval to current owner');
905 
906         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), 'ERC721: approve caller is not owner nor approved for all');
907 
908         _approve(to, tokenId);
909     }
910 
911     /**
912      * @dev See {IERC721-getApproved}.
913      */
914     function getApproved(uint256 tokenId) public view virtual override returns (address) {
915         require(_exists(tokenId), 'ERC721: approved query for nonexistent token');
916 
917         return _tokenApprovals[tokenId];
918     }
919 
920     /**
921      * @dev See {IERC721-setApprovalForAll}.
922      */
923     function setApprovalForAll(address operator, bool approved) public virtual override {
924         require(operator != _msgSender(), 'ERC721: approve to caller');
925 
926         _operatorApprovals[_msgSender()][operator] = approved;
927         emit ApprovalForAll(_msgSender(), operator, approved);
928     }
929 
930     /**
931      * @dev See {IERC721-isApprovedForAll}.
932      */
933     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
934         return _operatorApprovals[owner][operator];
935     }
936 
937     /**
938      * @dev See {IERC721-transferFrom}.
939      */
940     function transferFrom(
941         address from,
942         address to,
943         uint256 tokenId
944     ) public virtual override {
945         //solhint-disable-next-line max-line-length
946         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
947 
948         _transfer(from, to, tokenId);
949     }
950 
951     /**
952      * @dev See {IERC721-safeTransferFrom}.
953      */
954     function safeTransferFrom(
955         address from,
956         address to,
957         uint256 tokenId
958     ) public virtual override {
959         safeTransferFrom(from, to, tokenId, '');
960     }
961 
962     /**
963      * @dev See {IERC721-safeTransferFrom}.
964      */
965     function safeTransferFrom(
966         address from,
967         address to,
968         uint256 tokenId,
969         bytes memory _data
970     ) public virtual override {
971         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
972         _safeTransfer(from, to, tokenId, _data);
973     }
974 
975     /**
976      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
977      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
978      *
979      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
980      *
981      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
982      * implement alternative mechanisms to perform token transfer, such as signature-based.
983      *
984      * Requirements:
985      *
986      * - `from` cannot be the zero address.
987      * - `to` cannot be the zero address.
988      * - `tokenId` token must exist and be owned by `from`.
989      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _safeTransfer(
994         address from,
995         address to,
996         uint256 tokenId,
997         bytes memory _data
998     ) internal virtual {
999         _transfer(from, to, tokenId);
1000         require(_checkOnERC721Received(from, to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
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
1012         return _owners[tokenId] != address(0);
1013     }
1014 
1015     /**
1016      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1017      *
1018      * Requirements:
1019      *
1020      * - `tokenId` must exist.
1021      */
1022     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1023         require(_exists(tokenId), 'ERC721: operator query for nonexistent token');
1024         address owner = ERC721.ownerOf(tokenId);
1025         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1026     }
1027 
1028     /**
1029      * @dev Safely
1030      s `tokenId` and transfers it to `to`.
1031      *
1032      * Requirements:
1033      *
1034      * - `tokenId` must not exist.
1035      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1036      *
1037      * Emits a {Transfer} event.
1038      */
1039     function _safeMint(address to, uint256 tokenId) internal virtual {
1040         _safeMint(to, tokenId, '');
1041     }
1042 
1043     /**
1044      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1045      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1046      */
1047     function _safeMint(
1048         address to,
1049         uint256 tokenId,
1050         bytes memory _data
1051     ) internal virtual {
1052         _mint(to, tokenId);
1053         require(_checkOnERC721Received(address(0), to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
1054     }
1055 
1056     /**
1057      * @dev Mints `tokenId` and transfers it to `to`.
1058      *
1059      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1060      *
1061      * Requirements:
1062      *
1063      * - `tokenId` must not exist.
1064      * - `to` cannot be the zero address.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _mint(address to, uint256 tokenId) internal virtual {
1069         require(to != address(0), 'ERC721: mint to the zero address');
1070         require(!_exists(tokenId), 'ERC721: token already minted');
1071 
1072         _beforeTokenTransfer(address(0), to, tokenId);
1073 
1074         _balances[to] += 1;
1075         _owners[tokenId] = to;
1076 
1077         emit Transfer(address(0), to, tokenId);
1078     }
1079 
1080     /**
1081      * @dev Destroys `tokenId`.
1082      * The approval is cleared when the token is burned.
1083      *
1084      * Requirements:
1085      *
1086      * - `tokenId` must exist.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function _burn(uint256 tokenId) internal virtual {
1091         address owner = ERC721.ownerOf(tokenId);
1092 
1093         _beforeTokenTransfer(owner, address(0), tokenId);
1094 
1095         // Clear approvals
1096         _approve(address(0), tokenId);
1097 
1098         _balances[owner] -= 1;
1099         delete _owners[tokenId];
1100 
1101         emit Transfer(owner, address(0), tokenId);
1102     }
1103 
1104     /**
1105      * @dev Transfers `tokenId` from `from` to `to`.
1106      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1107      *
1108      * Requirements:
1109      *
1110      * - `to` cannot be the zero address.
1111      * - `tokenId` token must be owned by `from`.
1112      *
1113      * Emits a {Transfer} event.
1114      */
1115     function _transfer(
1116         address from,
1117         address to,
1118         uint256 tokenId
1119     ) internal virtual {
1120         require(ERC721.ownerOf(tokenId) == from, 'ERC721: transfer of token that is not own');
1121         require(to != address(0), 'ERC721: transfer to the zero address');
1122 
1123         _beforeTokenTransfer(from, to, tokenId);
1124 
1125         // Clear approvals from the previous owner
1126         _approve(address(0), tokenId);
1127 
1128         _balances[from] -= 1;
1129         _balances[to] += 1;
1130         _owners[tokenId] = to;
1131 
1132         emit Transfer(from, to, tokenId);
1133     }
1134 
1135     /**
1136      * @dev Approve `to` to operate on `tokenId`
1137      *
1138      * Emits a {Approval} event.
1139      */
1140     function _approve(address to, uint256 tokenId) internal virtual {
1141         _tokenApprovals[tokenId] = to;
1142         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1143     }
1144 
1145     /**
1146      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1147      * The call is not executed if the target address is not a contract.
1148      *
1149      * @param from address representing the previous owner of the given token ID
1150      * @param to target address that will receive the tokens
1151      * @param tokenId uint256 ID of the token to be transferred
1152      * @param _data bytes optional data to send along with the call
1153      * @return bool whether the call correctly returned the expected magic value
1154      */
1155     function _checkOnERC721Received(
1156         address from,
1157         address to,
1158         uint256 tokenId,
1159         bytes memory _data
1160     ) private returns (bool) {
1161         if (to.isContract()) {
1162             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1163                 return retval == IERC721Receiver(to).onERC721Received.selector;
1164             } catch (bytes memory reason) {
1165                 if (reason.length == 0) {
1166                     revert('ERC721: transfer to non ERC721Receiver implementer');
1167                 } else {
1168                     // solhint-disable-next-line no-inline-assembly
1169                     assembly {
1170                         revert(add(32, reason), mload(reason))
1171                     }
1172                 }
1173             }
1174         } else {
1175             return true;
1176         }
1177     }
1178 
1179     /**
1180      * @dev Hook that is called before any token transfer. This includes minting
1181      * and burning.
1182      *
1183      * Calling conditions:
1184      *
1185      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1186      * transferred to `to`.
1187      * - When `from` is zero, `tokenId` will be minted for `to`.
1188      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1189      * - `from` cannot be the zero address.
1190      * - `to` cannot be the zero address.
1191      *
1192      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1193      */
1194     function _beforeTokenTransfer(
1195         address from,
1196         address to,
1197         uint256 tokenId
1198     ) internal virtual {}
1199 }
1200 
1201 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.1.0
1202 
1203 pragma solidity ^0.8.0;
1204 
1205 /**
1206  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1207  * @dev See https://eips.ethereum.org/EIPS/eip-721
1208  */
1209 interface IERC721Enumerable is IERC721 {
1210     /**
1211      * @dev Returns the total amount of tokens stored by the contract.
1212      */
1213     function totalSupply() external view returns (uint256);
1214 
1215     /**
1216      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1217      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1218      */
1219     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1220 
1221     /**
1222      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1223      * Use along with {totalSupply} to enumerate all tokens.
1224      */
1225     function tokenByIndex(uint256 index) external view returns (uint256);
1226 }
1227 
1228 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.1.0
1229 
1230 pragma solidity ^0.8.0;
1231 
1232 /**
1233  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1234  * enumerability of all the token ids in the contract as well as all token ids owned by each
1235  * account.
1236  */
1237 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1238     // Mapping from owner to list of owned token IDs
1239     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1240 
1241     // Mapping from token ID to index of the owner tokens list
1242     mapping(uint256 => uint256) private _ownedTokensIndex;
1243 
1244     // Array with all token ids, used for enumeration
1245     uint256[] private _allTokens;
1246 
1247     // Mapping from token id to position in the allTokens array
1248     mapping(uint256 => uint256) private _allTokensIndex;
1249 
1250     /**
1251      * @dev See {IERC165-supportsInterface}.
1252      */
1253     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1254         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1255     }
1256 
1257     /**
1258      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1259      */
1260     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1261         require(index < ERC721.balanceOf(owner), 'ERC721Enumerable: owner index out of bounds');
1262         return _ownedTokens[owner][index];
1263     }
1264 
1265     /**
1266      * @dev See {IERC721Enumerable-totalSupply}.
1267      */
1268     function totalSupply() public view virtual override returns (uint256) {
1269         return _allTokens.length;
1270     }
1271 
1272     /**
1273      * @dev See {IERC721Enumerable-tokenByIndex}.
1274      */
1275     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1276         require(index < ERC721Enumerable.totalSupply(), 'ERC721Enumerable: global index out of bounds');
1277         return _allTokens[index];
1278     }
1279 
1280     /**
1281      * @dev Hook that is called before any token transfer. This includes minting
1282      * and burning.
1283      *
1284      * Calling conditions:
1285      *
1286      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1287      * transferred to `to`.
1288      * - When `from` is zero, `tokenId` will be minted for `to`.
1289      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1290      * - `from` cannot be the zero address.
1291      * - `to` cannot be the zero address.
1292      *
1293      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1294      */
1295     function _beforeTokenTransfer(
1296         address from,
1297         address to,
1298         uint256 tokenId
1299     ) internal virtual override {
1300         super._beforeTokenTransfer(from, to, tokenId);
1301 
1302         if (from == address(0)) {
1303             _addTokenToAllTokensEnumeration(tokenId);
1304         } else if (from != to) {
1305             _removeTokenFromOwnerEnumeration(from, tokenId);
1306         }
1307         if (to == address(0)) {
1308             _removeTokenFromAllTokensEnumeration(tokenId);
1309         } else if (to != from) {
1310             _addTokenToOwnerEnumeration(to, tokenId);
1311         }
1312     }
1313 
1314     /**
1315      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1316      * @param to address representing the new owner of the given token ID
1317      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1318      */
1319     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1320         uint256 length = ERC721.balanceOf(to);
1321         _ownedTokens[to][length] = tokenId;
1322         _ownedTokensIndex[tokenId] = length;
1323     }
1324 
1325     /**
1326      * @dev Private function to add a token to this extension's token tracking data structures.
1327      * @param tokenId uint256 ID of the token to be added to the tokens list
1328      */
1329     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1330         _allTokensIndex[tokenId] = _allTokens.length;
1331         _allTokens.push(tokenId);
1332     }
1333 
1334     /**
1335      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1336      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1337      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1338      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1339      * @param from address representing the previous owner of the given token ID
1340      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1341      */
1342     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1343         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1344         // then delete the last slot (swap and pop).
1345 
1346         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1347         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1348 
1349         // When the token to delete is the last token, the swap operation is unnecessary
1350         if (tokenIndex != lastTokenIndex) {
1351             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1352 
1353             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1354             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1355         }
1356 
1357         // This also deletes the contents at the last position of the array
1358         delete _ownedTokensIndex[tokenId];
1359         delete _ownedTokens[from][lastTokenIndex];
1360     }
1361 
1362     /**
1363      * @dev Private function to remove a token from this extension's token tracking data structures.
1364      * This has O(1) time complexity, but alters the order of the _allTokens array.
1365      * @param tokenId uint256 ID of the token to be removed from the tokens list
1366      */
1367     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1368         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1369         // then delete the last slot (swap and pop).
1370 
1371         uint256 lastTokenIndex = _allTokens.length - 1;
1372         uint256 tokenIndex = _allTokensIndex[tokenId];
1373 
1374         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1375         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1376         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1377         uint256 lastTokenId = _allTokens[lastTokenIndex];
1378 
1379         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1380         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1381 
1382         // This also deletes the contents at the last position of the array
1383         delete _allTokensIndex[tokenId];
1384         _allTokens.pop();
1385     }
1386 }
1387 
1388 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol@v4.1.0
1389 
1390 pragma solidity ^0.8.0;
1391 
1392 /**
1393  * @dev ERC721 token with storage based token URI management.
1394  */
1395 abstract contract ERC721URIStorage is ERC721 {
1396     using Strings for uint256;
1397 
1398     // Optional mapping for token URIs
1399     mapping(uint256 => string) private _tokenURIs;
1400 
1401     /**
1402      * @dev See {IERC721Metadata-tokenURI}.
1403      */
1404     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1405         require(_exists(tokenId), 'ERC721URIStorage: URI query for nonexistent token');
1406 
1407         string memory _tokenURI = _tokenURIs[tokenId];
1408         string memory base = _baseURI();
1409 
1410         // If there is no base URI, return the token URI.
1411         if (bytes(base).length == 0) {
1412             return _tokenURI;
1413         }
1414         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1415         if (bytes(_tokenURI).length > 0) {
1416             return string(abi.encodePacked(base, _tokenURI));
1417         }
1418         return super.tokenURI(tokenId);
1419     }
1420 
1421     /**
1422      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1423      *
1424      * Requirements:
1425      *
1426      * - `tokenId` must exist.
1427      */
1428     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1429         require(_exists(tokenId), 'ERC721URIStorage: URI set of nonexistent token');
1430         _tokenURIs[tokenId] = _tokenURI;
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
1443     function _burn(uint256 tokenId) internal virtual override {
1444         super._burn(tokenId);
1445 
1446         if (bytes(_tokenURIs[tokenId]).length != 0) {
1447             delete _tokenURIs[tokenId];
1448         }
1449     }
1450 }
1451 
1452 // File @openzeppelin/contracts/security/Pausable.sol@v4.1.0
1453 
1454 pragma solidity ^0.8.0;
1455 
1456 /**
1457  * @dev Contract module which allows children to implement an emergency stop
1458  * mechanism that can be triggered by an authorized account.
1459  *
1460  * This module is used through inheritance. It will make available the
1461  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1462  * the functions of your contract. Note that they will not be pausable by
1463  * simply including this module, only once the modifiers are put in place.
1464  */
1465 abstract contract Pausable is Context {
1466     /**
1467      * @dev Emitted when the pause is triggered by `account`.
1468      */
1469     event Paused(address account);
1470 
1471     /**
1472      * @dev Emitted when the pause is lifted by `account`.
1473      */
1474     event Unpaused(address account);
1475 
1476     bool private _paused;
1477 
1478     /**
1479      * @dev Initializes the contract in unpaused state.
1480      */
1481     constructor() {
1482         _paused = false;
1483     }
1484 
1485     /**
1486      * @dev Returns true if the contract is paused, and false otherwise.
1487      */
1488     function paused() public view virtual returns (bool) {
1489         return _paused;
1490     }
1491 
1492     /**
1493      * @dev Modifier to make a function callable only when the contract is not paused.
1494      *
1495      * Requirements:
1496      *
1497      * - The contract must not be paused.
1498      */
1499     modifier whenNotPaused() {
1500         require(!paused(), 'Pausable: paused');
1501         _;
1502     }
1503 
1504     /**
1505      * @dev Modifier to make a function callable only when the contract is paused.
1506      *
1507      * Requirements:
1508      *
1509      * - The contract must be paused.
1510      */
1511     modifier whenPaused() {
1512         require(paused(), 'Pausable: not paused');
1513         _;
1514     }
1515 
1516     /**
1517      * @dev Triggers stopped state.
1518      *
1519      * Requirements:
1520      *
1521      * - The contract must not be paused.
1522      */
1523     function _pause() internal virtual whenNotPaused {
1524         _paused = true;
1525         emit Paused(_msgSender());
1526     }
1527 
1528     /**
1529      * @dev Returns to normal state.
1530      *
1531      * Requirements:
1532      *
1533      * - The contract must be paused.
1534      */
1535     function _unpause() internal virtual whenPaused {
1536         _paused = false;
1537         emit Unpaused(_msgSender());
1538     }
1539 }
1540 
1541 // File @openzeppelin/contracts/access/Ownable.sol@v4.1.0
1542 
1543 pragma solidity ^0.8.0;
1544 
1545 /**
1546  * @dev Contract module which provides a basic access control mechanism, where
1547  * there is an account (an owner) that can be granted exclusive access to
1548  * specific functions.
1549  *
1550  * By default, the owner account will be the one that deploys the contract. This
1551  * can later be changed with {transferOwnership}.
1552  *
1553  * This module is used through inheritance. It will make available the modifier
1554  * `onlyOwner`, which can be applied to your functions to restrict their use to
1555  * the owner.
1556  */
1557 abstract contract Ownable is Context {
1558     address private _owner;
1559 
1560     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1561 
1562     /**
1563      * @dev Initializes the contract setting the deployer as the initial owner.
1564      */
1565     constructor() {
1566         address msgSender = _msgSender();
1567         _owner = msgSender;
1568         emit OwnershipTransferred(address(0), msgSender);
1569     }
1570 
1571     /**
1572      * @dev Returns the address of the current owner.
1573      */
1574     function owner() public view virtual returns (address) {
1575         return _owner;
1576     }
1577 
1578     /**
1579      * @dev Throws if called by any account other than the owner.
1580      */
1581     modifier onlyOwner() {
1582         require(owner() == _msgSender(), 'Ownable: caller is not the owner');
1583         _;
1584     }
1585 
1586     /**
1587      * @dev Leaves the contract without owner. It will not be possible to call
1588      * `onlyOwner` functions anymore. Can only be called by the current owner.
1589      *
1590      * NOTE: Renouncing ownership will leave the contract without an owner,
1591      * thereby removing any functionality that is only available to the owner.
1592      */
1593     function renounceOwnership() public virtual onlyOwner {
1594         emit OwnershipTransferred(_owner, address(0));
1595         _owner = address(0);
1596     }
1597 
1598     /**
1599      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1600      * Can only be called by the current owner.
1601      */
1602     function transferOwnership(address newOwner) public virtual onlyOwner {
1603         require(newOwner != address(0), 'Ownable: new owner is the zero address');
1604         emit OwnershipTransferred(_owner, newOwner);
1605         _owner = newOwner;
1606     }
1607 }
1608 
1609 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.1.0
1610 
1611 pragma solidity ^0.8.0;
1612 
1613 /**
1614  * @title ERC721 Burnable Token
1615  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1616  */
1617 abstract contract ERC721Burnable is Context, ERC721 {
1618     /**
1619      * @dev Burns `tokenId`. See {ERC721-_burn}.
1620      *
1621      * Requirements:
1622      *
1623      * - The caller must own `tokenId` or be an approved operator.
1624      */
1625     function burn(uint256 tokenId) public virtual {
1626         //solhint-disable-next-line max-line-length
1627         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721Burnable: caller is not owner nor approved');
1628         _burn(tokenId);
1629     }
1630 }
1631 
1632 // File @openzeppelin/contracts/utils/Counters.sol@v4.1.0
1633 
1634 pragma solidity ^0.8.0;
1635 
1636 /**
1637  * @title Counters
1638  * @author Matt Condon (@shrugs)
1639  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1640  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1641  *
1642  * Include with `using Counters for Counters.Counter;`
1643  */
1644 library Counters {
1645     struct Counter {
1646         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1647         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1648         // this feature: see https://github.com/ethereum/solidity/issues/4637
1649         uint256 _value; // default: 0
1650     }
1651 
1652     function current(Counter storage counter) internal view returns (uint256) {
1653         return counter._value;
1654     }
1655 
1656     function increment(Counter storage counter) internal {
1657         unchecked {
1658             counter._value += 1;
1659         }
1660     }
1661 
1662     function decrement(Counter storage counter) internal {
1663         uint256 value = counter._value;
1664         require(value > 0, 'Counter: decrement overflow');
1665         unchecked {
1666             counter._value = value - 1;
1667         }
1668     }
1669 }
1670 
1671 pragma solidity ^0.8.0;
1672 
1673 contract BabyGirl is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable, ERC721Burnable {
1674     using Counters for Counters.Counter;
1675 
1676     Counters.Counter private _tokenIdCounter;
1677     uint256 public maxSupply = 10000;
1678     uint256 public maxLevel1 = 150;
1679     uint256 public maxLevel2 = 350;
1680     uint256 public maxLevel3 = 1000;
1681     uint256 public maxLevel4 = 3500;
1682     uint256 public maxLevel5 = 5000;
1683     uint [5] T = [5, 4, 3, 2,1];
1684     uint [5] S = [94, 75, 23, 8,4];
1685     uint256 public price = 48000000000000000; //50000000000000000  0.05
1686     bool public saleOpen = true;
1687     bool public presaleOpen = false;
1688     string public baseURI='https://ipfs.io/ipfs/QmUYJpMKBhwfirDM4wSD4cYKzFxRaB4WYJpPX8pJEGUWke/';
1689     address princeWallet = 0xf30F5Abf229fB9E002Df04e63aDaDBA0776d4109;
1690     mapping(uint => uint) public level;
1691     uint256 public level1;
1692     uint256 public level2;
1693     uint256 public level3;
1694     uint256 public level4;
1695     uint256 public level5;
1696 
1697     mapping(address => bool) public claimed;
1698 
1699     bytes32 public saleMerkleRoot =0xad05fa613dbc0c67d072571de21d1e33efc5690ef0c0d0a66380fbbe07d0347e;
1700 
1701 
1702     receive() external payable {}
1703 
1704     constructor() ERC721('Hwtape', 'Hwape_NFT') {}
1705 
1706     function rand(uint sid) public view returns(uint) {  //随机生成等级
1707     uint _length = 1234567890123456789012+sid;
1708     uint random = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
1709     uint sum = 0;
1710     uint factor =0;
1711     uint randoms = random%_length;
1712     for(uint i=0; i<S.length; i++) {
1713            sum+=S[i];
1714         }
1715     randoms *= sum;
1716     for(uint b= 0 ; b<S.length; b++) {
1717          factor += S[b];
1718          if(randoms/1000000000000000000000<=factor)
1719          {
1720              if (T[b]==5){
1721                  if(level5<maxLevel5){
1722                         return 5;
1723                  }
1724 
1725              } else  if (T[b]==4){
1726                  if(level4<maxLevel4){
1727                    //  level2 == level2+1;
1728                         return 4;
1729                  }
1730 
1731              } else if (T[b]==3){
1732                  if(level3<maxLevel3){
1733                         return 3;
1734                  }
1735              } else if (T[b]==2){
1736                  if(level2<maxLevel2){
1737                         return 2;
1738                  }
1739              } else if (T[b]==1){
1740                         if(level1<maxLevel1){
1741                         return 1;
1742                  }
1743              }
1744          }
1745         }
1746     if(level5<maxLevel5){
1747                         return 5;
1748                  }else if (level4<maxLevel4){
1749                          return 4;
1750                  }else if (level3<maxLevel3){
1751                          return 3;
1752                  }else if (level2<maxLevel2){
1753                          return 2;
1754                  }else if (level1<maxLevel1){
1755                          return 1;
1756                  }else{
1757                      return 5;
1758                  }
1759 }
1760 
1761    
1762     function reserveMints(address to) public onlyOwner {
1763         for (uint256 i = 0; i < 50; i++) internalMint(to);
1764     }
1765 
1766 
1767     function withdraw() public onlyOwner {
1768         uint256 balance = address(this).balance;
1769         payable(princeWallet).transfer(balance);
1770 
1771     }
1772 
1773     function pause() public onlyOwner {
1774         _pause();
1775     }
1776 
1777     function unpause() public onlyOwner {
1778         _unpause();
1779     }
1780 
1781     function toggleSale() public onlyOwner {
1782         saleOpen = !saleOpen;
1783     }
1784 
1785     function togglePresale() public onlyOwner {
1786         presaleOpen = !presaleOpen;
1787     }
1788 
1789     function setBaseURI(string memory newBaseURI) public onlyOwner {
1790         baseURI = newBaseURI;
1791     }
1792 
1793     function setPrice(uint256 newPrice) public onlyOwner {
1794         price = newPrice;
1795     }
1796    function setSaleMerkleRoot(bytes32 merkleRoot) external onlyOwner {
1797         saleMerkleRoot = merkleRoot;
1798     }
1799     function _baseURI() internal view override returns (string memory) {
1800         return baseURI;
1801     }
1802 
1803   
1804     //把树叶的proof生成传入做校验
1805 
1806     function internalMint(address to) internal {
1807         require(totalSupply() < maxSupply, 'supply depleted');
1808         _tokenIdCounter.increment();
1809         uint _level = rand(_tokenIdCounter.current());
1810         level[_tokenIdCounter.current()] = _level;
1811         if(_level ==1 ) {
1812             level1 += 1;
1813         } else if(_level ==2 ) {
1814             level2 += 1;
1815         } else if(_level ==3 ) {
1816             level3 += 1;
1817         } else if(_level ==4 ) {
1818             level4 += 1;
1819         } else if(_level ==5 ) {
1820             level5 += 1;
1821         }
1822           _safeMint(to, _tokenIdCounter.current());
1823     }
1824 
1825     function safeMint(address to,uint256 amount) public onlyOwner {
1826 
1827       require(amount <= 1000, 'only 3 per transaction allowed');
1828       for (uint256 i = 0; i < amount; i++) internalMint(to);
1829     }
1830 
1831 
1832 
1833     function mints(bytes32[] calldata merkleProof,uint256 amount) public payable {
1834         require(MerkleProof.verify(merkleProof,saleMerkleRoot,keccak256(abi.encodePacked(msg.sender))), 'Invalid proof');
1835         require(!claimed[msg.sender], "Address already claimed");
1836         require(amount <= 1, 'only 1 per transaction allowed');
1837         claimed[msg.sender] = true;
1838         for (uint256 i = 0; i < amount; i++) internalMint(msg.sender);
1839     }
1840 
1841     function mint(uint256 amount) public payable {
1842         require(msg.value >= price * amount, 'not enough was paid'); // 付钱的
1843         require(amount <= 1000, 'only 3 per transaction allowed');
1844         for (uint256 i = 0; i < amount; i++) internalMint(msg.sender);
1845     }
1846     function walletOfOwner(address _owner)
1847     public
1848     view
1849     returns (uint256[] memory)
1850   {
1851     uint256 ownerTokenCount = balanceOf(_owner);
1852     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1853     for (uint256 i; i < ownerTokenCount; i++) {
1854       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1855     }
1856     return tokenIds;
1857   }
1858     function _beforeTokenTransfer(
1859         address from,
1860         address to,
1861         uint256 tokenId
1862     ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
1863         super._beforeTokenTransfer(from, to, tokenId);
1864     }
1865 
1866     // The following functions are overrides required by Solidity.
1867 
1868     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1869         super._burn(tokenId);
1870     }
1871 
1872     function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
1873         return super.tokenURI(level[tokenId]);
1874     }
1875 
1876     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1877         return super.supportsInterface(interfaceId);
1878     }
1879 }