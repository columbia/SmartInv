1 // SPDX-License-Identifier: MIT
2 // File: CodeArtBear_flat.sol
3 
4 
5 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
6 
7 
8 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev These functions deal with verification of Merkle Tree proofs.
14  *
15  * The proofs can be generated using the JavaScript library
16  * https://github.com/miguelmota/merkletreejs[merkletreejs].
17  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
18  *
19  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
20  *
21  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
22  * hashing, or use a hash function other than keccak256 for hashing leaves.
23  * This is because the concatenation of a sorted pair of internal nodes in
24  * the merkle tree could be reinterpreted as a leaf value.
25  */
26 library MerkleProof {
27     /**
28      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
29      * defined by `root`. For this, a `proof` must be provided, containing
30      * sibling hashes on the branch from the leaf to the root of the tree. Each
31      * pair of leaves and each pair of pre-images are assumed to be sorted.
32      */
33     function verify(
34         bytes32[] memory proof,
35         bytes32 root,
36         bytes32 leaf
37     ) internal pure returns (bool) {
38         return processProof(proof, leaf) == root;
39     }
40 
41     /**
42      * @dev Calldata version of {verify}
43      *
44      * _Available since v4.7._
45      */
46     function verifyCalldata(
47         bytes32[] calldata proof,
48         bytes32 root,
49         bytes32 leaf
50     ) internal pure returns (bool) {
51         return processProofCalldata(proof, leaf) == root;
52     }
53 
54     /**
55      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
56      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
57      * hash matches the root of the tree. When processing the proof, the pairs
58      * of leafs & pre-images are assumed to be sorted.
59      *
60      * _Available since v4.4._
61      */
62     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
63         bytes32 computedHash = leaf;
64         for (uint256 i = 0; i < proof.length; i++) {
65             computedHash = _hashPair(computedHash, proof[i]);
66         }
67         return computedHash;
68     }
69 
70     /**
71      * @dev Calldata version of {processProof}
72      *
73      * _Available since v4.7._
74      */
75     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
76         bytes32 computedHash = leaf;
77         for (uint256 i = 0; i < proof.length; i++) {
78             computedHash = _hashPair(computedHash, proof[i]);
79         }
80         return computedHash;
81     }
82 
83     /**
84      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
85      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
86      *
87      * _Available since v4.7._
88      */
89     function multiProofVerify(
90         bytes32[] memory proof,
91         bool[] memory proofFlags,
92         bytes32 root,
93         bytes32[] memory leaves
94     ) internal pure returns (bool) {
95         return processMultiProof(proof, proofFlags, leaves) == root;
96     }
97 
98     /**
99      * @dev Calldata version of {multiProofVerify}
100      *
101      * _Available since v4.7._
102      */
103     function multiProofVerifyCalldata(
104         bytes32[] calldata proof,
105         bool[] calldata proofFlags,
106         bytes32 root,
107         bytes32[] memory leaves
108     ) internal pure returns (bool) {
109         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
110     }
111 
112     /**
113      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
114      * consuming from one or the other at each step according to the instructions given by
115      * `proofFlags`.
116      *
117      * _Available since v4.7._
118      */
119     function processMultiProof(
120         bytes32[] memory proof,
121         bool[] memory proofFlags,
122         bytes32[] memory leaves
123     ) internal pure returns (bytes32 merkleRoot) {
124         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
125         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
126         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
127         // the merkle tree.
128         uint256 leavesLen = leaves.length;
129         uint256 totalHashes = proofFlags.length;
130 
131         // Check proof validity.
132         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
133 
134         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
135         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
136         bytes32[] memory hashes = new bytes32[](totalHashes);
137         uint256 leafPos = 0;
138         uint256 hashPos = 0;
139         uint256 proofPos = 0;
140         // At each step, we compute the next hash using two values:
141         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
142         //   get the next hash.
143         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
144         //   `proof` array.
145         for (uint256 i = 0; i < totalHashes; i++) {
146             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
147             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
148             hashes[i] = _hashPair(a, b);
149         }
150 
151         if (totalHashes > 0) {
152             return hashes[totalHashes - 1];
153         } else if (leavesLen > 0) {
154             return leaves[0];
155         } else {
156             return proof[0];
157         }
158     }
159 
160     /**
161      * @dev Calldata version of {processMultiProof}
162      *
163      * _Available since v4.7._
164      */
165     function processMultiProofCalldata(
166         bytes32[] calldata proof,
167         bool[] calldata proofFlags,
168         bytes32[] memory leaves
169     ) internal pure returns (bytes32 merkleRoot) {
170         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
171         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
172         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
173         // the merkle tree.
174         uint256 leavesLen = leaves.length;
175         uint256 totalHashes = proofFlags.length;
176 
177         // Check proof validity.
178         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
179 
180         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
181         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
182         bytes32[] memory hashes = new bytes32[](totalHashes);
183         uint256 leafPos = 0;
184         uint256 hashPos = 0;
185         uint256 proofPos = 0;
186         // At each step, we compute the next hash using two values:
187         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
188         //   get the next hash.
189         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
190         //   `proof` array.
191         for (uint256 i = 0; i < totalHashes; i++) {
192             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
193             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
194             hashes[i] = _hashPair(a, b);
195         }
196 
197         if (totalHashes > 0) {
198             return hashes[totalHashes - 1];
199         } else if (leavesLen > 0) {
200             return leaves[0];
201         } else {
202             return proof[0];
203         }
204     }
205 
206     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
207         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
208     }
209 
210     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
211         /// @solidity memory-safe-assembly
212         assembly {
213             mstore(0x00, a)
214             mstore(0x20, b)
215             value := keccak256(0x00, 0x40)
216         }
217     }
218 }
219 
220 // File: @openzeppelin/contracts/utils/Strings.sol
221 
222 
223 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @dev String operations.
229  */
230 library Strings {
231     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
232     uint8 private constant _ADDRESS_LENGTH = 20;
233 
234     /**
235      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
236      */
237     function toString(uint256 value) internal pure returns (string memory) {
238         // Inspired by OraclizeAPI's implementation - MIT licence
239         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
240 
241         if (value == 0) {
242             return "0";
243         }
244         uint256 temp = value;
245         uint256 digits;
246         while (temp != 0) {
247             digits++;
248             temp /= 10;
249         }
250         bytes memory buffer = new bytes(digits);
251         while (value != 0) {
252             digits -= 1;
253             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
254             value /= 10;
255         }
256         return string(buffer);
257     }
258 
259     /**
260      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
261      */
262     function toHexString(uint256 value) internal pure returns (string memory) {
263         if (value == 0) {
264             return "0x00";
265         }
266         uint256 temp = value;
267         uint256 length = 0;
268         while (temp != 0) {
269             length++;
270             temp >>= 8;
271         }
272         return toHexString(value, length);
273     }
274 
275     /**
276      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
277      */
278     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
279         bytes memory buffer = new bytes(2 * length + 2);
280         buffer[0] = "0";
281         buffer[1] = "x";
282         for (uint256 i = 2 * length + 1; i > 1; --i) {
283             buffer[i] = _HEX_SYMBOLS[value & 0xf];
284             value >>= 4;
285         }
286         require(value == 0, "Strings: hex length insufficient");
287         return string(buffer);
288     }
289 
290     /**
291      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
292      */
293     function toHexString(address addr) internal pure returns (string memory) {
294         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
295     }
296 }
297 
298 // File: @openzeppelin/contracts/utils/Address.sol
299 
300 
301 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
302 
303 pragma solidity ^0.8.1;
304 
305 /**
306  * @dev Collection of functions related to the address type
307  */
308 library Address {
309     /**
310      * @dev Returns true if `account` is a contract.
311      *
312      * [IMPORTANT]
313      * ====
314      * It is unsafe to assume that an address for which this function returns
315      * false is an externally-owned account (EOA) and not a contract.
316      *
317      * Among others, `isContract` will return false for the following
318      * types of addresses:
319      *
320      *  - an externally-owned account
321      *  - a contract in construction
322      *  - an address where a contract will be created
323      *  - an address where a contract lived, but was destroyed
324      * ====
325      *
326      * [IMPORTANT]
327      * ====
328      * You shouldn't rely on `isContract` to protect against flash loan attacks!
329      *
330      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
331      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
332      * constructor.
333      * ====
334      */
335     function isContract(address account) internal view returns (bool) {
336         // This method relies on extcodesize/address.code.length, which returns 0
337         // for contracts in construction, since the code is only stored at the end
338         // of the constructor execution.
339 
340         return account.code.length > 0;
341     }
342 
343     /**
344      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
345      * `recipient`, forwarding all available gas and reverting on errors.
346      *
347      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
348      * of certain opcodes, possibly making contracts go over the 2300 gas limit
349      * imposed by `transfer`, making them unable to receive funds via
350      * `transfer`. {sendValue} removes this limitation.
351      *
352      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
353      *
354      * IMPORTANT: because control is transferred to `recipient`, care must be
355      * taken to not create reentrancy vulnerabilities. Consider using
356      * {ReentrancyGuard} or the
357      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
358      */
359     function sendValue(address payable recipient, uint256 amount) internal {
360         require(address(this).balance >= amount, "Address: insufficient balance");
361 
362         (bool success, ) = recipient.call{value: amount}("");
363         require(success, "Address: unable to send value, recipient may have reverted");
364     }
365 
366     /**
367      * @dev Performs a Solidity function call using a low level `call`. A
368      * plain `call` is an unsafe replacement for a function call: use this
369      * function instead.
370      *
371      * If `target` reverts with a revert reason, it is bubbled up by this
372      * function (like regular Solidity function calls).
373      *
374      * Returns the raw returned data. To convert to the expected return value,
375      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
376      *
377      * Requirements:
378      *
379      * - `target` must be a contract.
380      * - calling `target` with `data` must not revert.
381      *
382      * _Available since v3.1._
383      */
384     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
385         return functionCall(target, data, "Address: low-level call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
390      * `errorMessage` as a fallback revert reason when `target` reverts.
391      *
392      * _Available since v3.1._
393      */
394     function functionCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         return functionCallWithValue(target, data, 0, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404      * but also transferring `value` wei to `target`.
405      *
406      * Requirements:
407      *
408      * - the calling contract must have an ETH balance of at least `value`.
409      * - the called Solidity function must be `payable`.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(
414         address target,
415         bytes memory data,
416         uint256 value
417     ) internal returns (bytes memory) {
418         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
423      * with `errorMessage` as a fallback revert reason when `target` reverts.
424      *
425      * _Available since v3.1._
426      */
427     function functionCallWithValue(
428         address target,
429         bytes memory data,
430         uint256 value,
431         string memory errorMessage
432     ) internal returns (bytes memory) {
433         require(address(this).balance >= value, "Address: insufficient balance for call");
434         require(isContract(target), "Address: call to non-contract");
435 
436         (bool success, bytes memory returndata) = target.call{value: value}(data);
437         return verifyCallResult(success, returndata, errorMessage);
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
442      * but performing a static call.
443      *
444      * _Available since v3.3._
445      */
446     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
447         return functionStaticCall(target, data, "Address: low-level static call failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
452      * but performing a static call.
453      *
454      * _Available since v3.3._
455      */
456     function functionStaticCall(
457         address target,
458         bytes memory data,
459         string memory errorMessage
460     ) internal view returns (bytes memory) {
461         require(isContract(target), "Address: static call to non-contract");
462 
463         (bool success, bytes memory returndata) = target.staticcall(data);
464         return verifyCallResult(success, returndata, errorMessage);
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
469      * but performing a delegate call.
470      *
471      * _Available since v3.4._
472      */
473     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
474         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
479      * but performing a delegate call.
480      *
481      * _Available since v3.4._
482      */
483     function functionDelegateCall(
484         address target,
485         bytes memory data,
486         string memory errorMessage
487     ) internal returns (bytes memory) {
488         require(isContract(target), "Address: delegate call to non-contract");
489 
490         (bool success, bytes memory returndata) = target.delegatecall(data);
491         return verifyCallResult(success, returndata, errorMessage);
492     }
493 
494     /**
495      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
496      * revert reason using the provided one.
497      *
498      * _Available since v4.3._
499      */
500     function verifyCallResult(
501         bool success,
502         bytes memory returndata,
503         string memory errorMessage
504     ) internal pure returns (bytes memory) {
505         if (success) {
506             return returndata;
507         } else {
508             // Look for revert reason and bubble it up if present
509             if (returndata.length > 0) {
510                 // The easiest way to bubble the revert reason is using memory via assembly
511                 /// @solidity memory-safe-assembly
512                 assembly {
513                     let returndata_size := mload(returndata)
514                     revert(add(32, returndata), returndata_size)
515                 }
516             } else {
517                 revert(errorMessage);
518             }
519         }
520     }
521 }
522 
523 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
524 
525 
526 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @title ERC721 token receiver interface
532  * @dev Interface for any contract that wants to support safeTransfers
533  * from ERC721 asset contracts.
534  */
535 interface IERC721Receiver {
536     /**
537      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
538      * by `operator` from `from`, this function is called.
539      *
540      * It must return its Solidity selector to confirm the token transfer.
541      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
542      *
543      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
544      */
545     function onERC721Received(
546         address operator,
547         address from,
548         uint256 tokenId,
549         bytes calldata data
550     ) external returns (bytes4);
551 }
552 
553 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
554 
555 
556 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @dev Interface of the ERC165 standard, as defined in the
562  * https://eips.ethereum.org/EIPS/eip-165[EIP].
563  *
564  * Implementers can declare support of contract interfaces, which can then be
565  * queried by others ({ERC165Checker}).
566  *
567  * For an implementation, see {ERC165}.
568  */
569 interface IERC165 {
570     /**
571      * @dev Returns true if this contract implements the interface defined by
572      * `interfaceId`. See the corresponding
573      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
574      * to learn more about how these ids are created.
575      *
576      * This function call must use less than 30 000 gas.
577      */
578     function supportsInterface(bytes4 interfaceId) external view returns (bool);
579 }
580 
581 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
582 
583 
584 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 
589 /**
590  * @dev Required interface of an ERC721 compliant contract.
591  */
592 interface IERC721 is IERC165 {
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
604      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
605      */
606     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
607 
608     /**
609      * @dev Returns the number of tokens in ``owner``'s account.
610      */
611     function balanceOf(address owner) external view returns (uint256 balance);
612 
613     /**
614      * @dev Returns the owner of the `tokenId` token.
615      *
616      * Requirements:
617      *
618      * - `tokenId` must exist.
619      */
620     function ownerOf(uint256 tokenId) external view returns (address owner);
621 
622     /**
623      * @dev Safely transfers `tokenId` token from `from` to `to`.
624      *
625      * Requirements:
626      *
627      * - `from` cannot be the zero address.
628      * - `to` cannot be the zero address.
629      * - `tokenId` token must exist and be owned by `from`.
630      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
631      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
632      *
633      * Emits a {Transfer} event.
634      */
635     function safeTransferFrom(
636         address from,
637         address to,
638         uint256 tokenId,
639         bytes calldata data
640     ) external;
641 
642     /**
643      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
644      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
645      *
646      * Requirements:
647      *
648      * - `from` cannot be the zero address.
649      * - `to` cannot be the zero address.
650      * - `tokenId` token must exist and be owned by `from`.
651      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
652      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
653      *
654      * Emits a {Transfer} event.
655      */
656     function safeTransferFrom(
657         address from,
658         address to,
659         uint256 tokenId
660     ) external;
661 
662     /**
663      * @dev Transfers `tokenId` token from `from` to `to`.
664      *
665      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
666      *
667      * Requirements:
668      *
669      * - `from` cannot be the zero address.
670      * - `to` cannot be the zero address.
671      * - `tokenId` token must be owned by `from`.
672      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
673      *
674      * Emits a {Transfer} event.
675      */
676     function transferFrom(
677         address from,
678         address to,
679         uint256 tokenId
680     ) external;
681 
682     /**
683      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
684      * The approval is cleared when the token is transferred.
685      *
686      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
687      *
688      * Requirements:
689      *
690      * - The caller must own the token or be an approved operator.
691      * - `tokenId` must exist.
692      *
693      * Emits an {Approval} event.
694      */
695     function approve(address to, uint256 tokenId) external;
696 
697     /**
698      * @dev Approve or remove `operator` as an operator for the caller.
699      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
700      *
701      * Requirements:
702      *
703      * - The `operator` cannot be the caller.
704      *
705      * Emits an {ApprovalForAll} event.
706      */
707     function setApprovalForAll(address operator, bool _approved) external;
708 
709     /**
710      * @dev Returns the account approved for `tokenId` token.
711      *
712      * Requirements:
713      *
714      * - `tokenId` must exist.
715      */
716     function getApproved(uint256 tokenId) external view returns (address operator);
717 
718     /**
719      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
720      *
721      * See {setApprovalForAll}
722      */
723     function isApprovedForAll(address owner, address operator) external view returns (bool);
724 }
725 
726 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
727 
728 
729 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
730 
731 pragma solidity ^0.8.0;
732 
733 
734 /**
735  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
736  * @dev See https://eips.ethereum.org/EIPS/eip-721
737  */
738 interface IERC721Enumerable is IERC721 {
739     /**
740      * @dev Returns the total amount of tokens stored by the contract.
741      */
742     function totalSupply() external view returns (uint256);
743 
744     /**
745      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
746      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
747      */
748     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
749 
750     /**
751      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
752      * Use along with {totalSupply} to enumerate all tokens.
753      */
754     function tokenByIndex(uint256 index) external view returns (uint256);
755 }
756 
757 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
758 
759 
760 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 
765 /**
766  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
767  * @dev See https://eips.ethereum.org/EIPS/eip-721
768  */
769 interface IERC721Metadata is IERC721 {
770     /**
771      * @dev Returns the token collection name.
772      */
773     function name() external view returns (string memory);
774 
775     /**
776      * @dev Returns the token collection symbol.
777      */
778     function symbol() external view returns (string memory);
779 
780     /**
781      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
782      */
783     function tokenURI(uint256 tokenId) external view returns (string memory);
784 }
785 
786 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
787 
788 
789 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
790 
791 pragma solidity ^0.8.0;
792 
793 
794 /**
795  * @dev Implementation of the {IERC165} interface.
796  *
797  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
798  * for the additional interface id that will be supported. For example:
799  *
800  * ```solidity
801  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
802  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
803  * }
804  * ```
805  *
806  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
807  */
808 abstract contract ERC165 is IERC165 {
809     /**
810      * @dev See {IERC165-supportsInterface}.
811      */
812     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
813         return interfaceId == type(IERC165).interfaceId;
814     }
815 }
816 
817 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
818 
819 
820 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
821 
822 pragma solidity ^0.8.0;
823 
824 
825 /**
826  * @dev Interface for the NFT Royalty Standard.
827  *
828  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
829  * support for royalty payments across all NFT marketplaces and ecosystem participants.
830  *
831  * _Available since v4.5._
832  */
833 interface IERC2981 is IERC165 {
834     /**
835      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
836      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
837      */
838     function royaltyInfo(uint256 tokenId, uint256 salePrice)
839         external
840         view
841         returns (address receiver, uint256 royaltyAmount);
842 }
843 
844 // File: @openzeppelin/contracts/token/common/ERC2981.sol
845 
846 
847 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
848 
849 pragma solidity ^0.8.0;
850 
851 
852 
853 /**
854  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
855  *
856  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
857  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
858  *
859  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
860  * fee is specified in basis points by default.
861  *
862  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
863  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
864  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
865  *
866  * _Available since v4.5._
867  */
868 abstract contract ERC2981 is IERC2981, ERC165 {
869     struct RoyaltyInfo {
870         address receiver;
871         uint96 royaltyFraction;
872     }
873 
874     RoyaltyInfo private _defaultRoyaltyInfo;
875     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
876 
877     /**
878      * @dev See {IERC165-supportsInterface}.
879      */
880     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
881         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
882     }
883 
884     /**
885      * @inheritdoc IERC2981
886      */
887     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
888         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
889 
890         if (royalty.receiver == address(0)) {
891             royalty = _defaultRoyaltyInfo;
892         }
893 
894         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
895 
896         return (royalty.receiver, royaltyAmount);
897     }
898 
899     /**
900      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
901      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
902      * override.
903      */
904     function _feeDenominator() internal pure virtual returns (uint96) {
905         return 10000;
906     }
907 
908     /**
909      * @dev Sets the royalty information that all ids in this contract will default to.
910      *
911      * Requirements:
912      *
913      * - `receiver` cannot be the zero address.
914      * - `feeNumerator` cannot be greater than the fee denominator.
915      */
916     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
917         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
918         require(receiver != address(0), "ERC2981: invalid receiver");
919 
920         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
921     }
922 
923     /**
924      * @dev Removes default royalty information.
925      */
926     function _deleteDefaultRoyalty() internal virtual {
927         delete _defaultRoyaltyInfo;
928     }
929 
930     /**
931      * @dev Sets the royalty information for a specific token id, overriding the global default.
932      *
933      * Requirements:
934      *
935      * - `receiver` cannot be the zero address.
936      * - `feeNumerator` cannot be greater than the fee denominator.
937      */
938     function _setTokenRoyalty(
939         uint256 tokenId,
940         address receiver,
941         uint96 feeNumerator
942     ) internal virtual {
943         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
944         require(receiver != address(0), "ERC2981: Invalid parameters");
945 
946         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
947     }
948 
949     /**
950      * @dev Resets royalty information for the token id back to the global default.
951      */
952     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
953         delete _tokenRoyaltyInfo[tokenId];
954     }
955 }
956 
957 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
958 
959 
960 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
961 
962 pragma solidity ^0.8.0;
963 
964 /**
965  * @dev Contract module that helps prevent reentrant calls to a function.
966  *
967  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
968  * available, which can be applied to functions to make sure there are no nested
969  * (reentrant) calls to them.
970  *
971  * Note that because there is a single `nonReentrant` guard, functions marked as
972  * `nonReentrant` may not call one another. This can be worked around by making
973  * those functions `private`, and then adding `external` `nonReentrant` entry
974  * points to them.
975  *
976  * TIP: If you would like to learn more about reentrancy and alternative ways
977  * to protect against it, check out our blog post
978  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
979  */
980 abstract contract ReentrancyGuard {
981     // Booleans are more expensive than uint256 or any type that takes up a full
982     // word because each write operation emits an extra SLOAD to first read the
983     // slot's contents, replace the bits taken up by the boolean, and then write
984     // back. This is the compiler's defense against contract upgrades and
985     // pointer aliasing, and it cannot be disabled.
986 
987     // The values being non-zero value makes deployment a bit more expensive,
988     // but in exchange the refund on every call to nonReentrant will be lower in
989     // amount. Since refunds are capped to a percentage of the total
990     // transaction's gas, it is best to keep them low in cases like this one, to
991     // increase the likelihood of the full refund coming into effect.
992     uint256 private constant _NOT_ENTERED = 1;
993     uint256 private constant _ENTERED = 2;
994 
995     uint256 private _status;
996 
997     constructor() {
998         _status = _NOT_ENTERED;
999     }
1000 
1001     /**
1002      * @dev Prevents a contract from calling itself, directly or indirectly.
1003      * Calling a `nonReentrant` function from another `nonReentrant`
1004      * function is not supported. It is possible to prevent this from happening
1005      * by making the `nonReentrant` function external, and making it call a
1006      * `private` function that does the actual work.
1007      */
1008     modifier nonReentrant() {
1009         // On the first call to nonReentrant, _notEntered will be true
1010         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1011 
1012         // Any calls to nonReentrant after this point will fail
1013         _status = _ENTERED;
1014 
1015         _;
1016 
1017         // By storing the original value once again, a refund is triggered (see
1018         // https://eips.ethereum.org/EIPS/eip-2200)
1019         _status = _NOT_ENTERED;
1020     }
1021 }
1022 
1023 // File: @openzeppelin/contracts/utils/Context.sol
1024 
1025 
1026 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1027 
1028 pragma solidity ^0.8.0;
1029 
1030 /**
1031  * @dev Provides information about the current execution context, including the
1032  * sender of the transaction and its data. While these are generally available
1033  * via msg.sender and msg.data, they should not be accessed in such a direct
1034  * manner, since when dealing with meta-transactions the account sending and
1035  * paying for execution may not be the actual sender (as far as an application
1036  * is concerned).
1037  *
1038  * This contract is only required for intermediate, library-like contracts.
1039  */
1040 abstract contract Context {
1041     function _msgSender() internal view virtual returns (address) {
1042         return msg.sender;
1043     }
1044 
1045     function _msgData() internal view virtual returns (bytes calldata) {
1046         return msg.data;
1047     }
1048 }
1049 
1050 // File: contracts/ERC721A.sol
1051 
1052 
1053 
1054 pragma solidity ^0.8.0;
1055 
1056 
1057 
1058 
1059 
1060 
1061 
1062 
1063 
1064 /**
1065  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1066  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1067  *
1068  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1069  *
1070  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1071  *
1072  * Does not support burning tokens to address(0).
1073  */
1074 contract ERC721A is
1075   Context,
1076   ERC165,
1077   IERC721,
1078   IERC721Metadata,
1079   IERC721Enumerable
1080 {
1081   using Address for address;
1082   using Strings for uint256;
1083 
1084   struct TokenOwnership {
1085     address addr;
1086     uint64 startTimestamp;
1087   }
1088 
1089   struct AddressData {
1090     uint128 balance;
1091     uint128 numberMinted;
1092   }
1093 
1094   uint256 private currentIndex = 1;
1095 
1096   uint256 internal immutable collectionSize;
1097   uint256 internal immutable maxBatchSize;
1098 
1099   // Token name
1100   string private _name;
1101 
1102   // Token symbol
1103   string private _symbol;
1104 
1105   // Mapping from token ID to ownership details
1106   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1107   mapping(uint256 => TokenOwnership) private _ownerships;
1108 
1109   // Mapping owner address to address data
1110   mapping(address => AddressData) private _addressData;
1111 
1112   // Mapping from token ID to approved address
1113   mapping(uint256 => address) private _tokenApprovals;
1114 
1115   // Mapping from owner to operator approvals
1116   mapping(address => mapping(address => bool)) private _operatorApprovals;
1117 
1118   /**
1119    * @dev
1120    * `maxBatchSize` refers to how much a minter can mint at a time.
1121    * `collectionSize_` refers to how many tokens are in the collection.
1122    */
1123   constructor(
1124     string memory name_,
1125     string memory symbol_,
1126     uint256 maxBatchSize_,
1127     uint256 collectionSize_
1128   ) {
1129     require(
1130       collectionSize_ > 0,
1131       "ERC721A: collection must have a nonzero supply"
1132     );
1133     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1134     _name = name_;
1135     _symbol = symbol_;
1136     maxBatchSize = maxBatchSize_;
1137     collectionSize = collectionSize_;
1138   }
1139 
1140   /**
1141    * @dev See {IERC721Enumerable-totalSupply}.
1142    */
1143   function totalSupply() public view override returns (uint256) {
1144     return currentIndex;
1145   }
1146 
1147   /**
1148    * @dev See {IERC721Enumerable-tokenByIndex}.
1149    */
1150   function tokenByIndex(uint256 index) public view override returns (uint256) {
1151     require(index < totalSupply(), "ERC721A: global index out of bounds");
1152     return index;
1153   }
1154 
1155   /**
1156    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1157    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1158    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1159    */
1160   function tokenOfOwnerByIndex(address owner, uint256 index)
1161     public
1162     view
1163     override
1164     returns (uint256)
1165   {
1166     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1167     uint256 numMintedSoFar = totalSupply();
1168     uint256 tokenIdsIdx = 0;
1169     address currOwnershipAddr = address(0);
1170     for (uint256 i = 0; i < numMintedSoFar; i++) {
1171       TokenOwnership memory ownership = _ownerships[i];
1172       if (ownership.addr != address(0)) {
1173         currOwnershipAddr = ownership.addr;
1174       }
1175       if (currOwnershipAddr == owner) {
1176         if (tokenIdsIdx == index) {
1177           return i;
1178         }
1179         tokenIdsIdx++;
1180       }
1181     }
1182     revert("ERC721A: unable to get token of owner by index");
1183   }
1184 
1185   /**
1186    * @dev See {IERC165-supportsInterface}.
1187    */
1188   function supportsInterface(bytes4 interfaceId)
1189     public
1190     view
1191     virtual
1192     override(ERC165, IERC165)
1193     returns (bool)
1194   {
1195     return
1196       interfaceId == type(IERC721).interfaceId ||
1197       interfaceId == type(IERC721Metadata).interfaceId ||
1198       interfaceId == type(IERC721Enumerable).interfaceId ||
1199       super.supportsInterface(interfaceId);
1200   }
1201 
1202   /**
1203    * @dev See {IERC721-balanceOf}.
1204    */
1205   function balanceOf(address owner) public view override returns (uint256) {
1206     require(owner != address(0), "ERC721A: balance query for the zero address");
1207     return uint256(_addressData[owner].balance);
1208   }
1209 
1210   function _numberMinted(address owner) internal view returns (uint256) {
1211     require(
1212       owner != address(0),
1213       "ERC721A: number minted query for the zero address"
1214     );
1215     return uint256(_addressData[owner].numberMinted);
1216   }
1217 
1218   function ownershipOf(uint256 tokenId)
1219     internal
1220     view
1221     returns (TokenOwnership memory)
1222   {
1223     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1224 
1225     uint256 lowestTokenToCheck;
1226     if (tokenId >= maxBatchSize) {
1227       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1228     }
1229 
1230     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1231       TokenOwnership memory ownership = _ownerships[curr];
1232       if (ownership.addr != address(0)) {
1233         return ownership;
1234       }
1235     }
1236 
1237     revert("ERC721A: unable to determine the owner of token");
1238   }
1239 
1240   /**
1241    * @dev See {IERC721-ownerOf}.
1242    */
1243   function ownerOf(uint256 tokenId) public view override returns (address) {
1244     return ownershipOf(tokenId).addr;
1245   }
1246 
1247   /**
1248    * @dev See {IERC721Metadata-name}.
1249    */
1250   function name() public view virtual override returns (string memory) {
1251     return _name;
1252   }
1253 
1254   /**
1255    * @dev See {IERC721Metadata-symbol}.
1256    */
1257   function symbol() public view virtual override returns (string memory) {
1258     return _symbol;
1259   }
1260 
1261   /**
1262    * @dev See {IERC721Metadata-tokenURI}.
1263    */
1264   function tokenURI(uint256 tokenId)
1265     public
1266     view
1267     virtual
1268     override
1269     returns (string memory)
1270   {
1271     require(
1272       _exists(tokenId),
1273       "ERC721Metadata: URI query for nonexistent token"
1274     );
1275 
1276     string memory baseURI = _baseURI();
1277     return
1278       bytes(baseURI).length > 0
1279         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1280         : "";
1281   }
1282 
1283   /**
1284    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1285    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1286    * by default, can be overriden in child contracts.
1287    */
1288   function _baseURI() internal view virtual returns (string memory) {
1289     return "";
1290   }
1291 
1292   /**
1293    * @dev See {IERC721-approve}.
1294    */
1295   function approve(address to, uint256 tokenId) public override {
1296     address owner = ERC721A.ownerOf(tokenId);
1297     require(to != owner, "ERC721A: approval to current owner");
1298 
1299     require(
1300       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1301       "ERC721A: approve caller is not owner nor approved for all"
1302     );
1303 
1304     _approve(to, tokenId, owner);
1305   }
1306 
1307   /**
1308    * @dev See {IERC721-getApproved}.
1309    */
1310   function getApproved(uint256 tokenId) public view override returns (address) {
1311     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1312 
1313     return _tokenApprovals[tokenId];
1314   }
1315 
1316   /**
1317    * @dev See {IERC721-setApprovalForAll}.
1318    */
1319   function setApprovalForAll(address operator, bool approved) public override {
1320     require(operator != _msgSender(), "ERC721A: approve to caller");
1321 
1322     _operatorApprovals[_msgSender()][operator] = approved;
1323     emit ApprovalForAll(_msgSender(), operator, approved);
1324   }
1325 
1326   /**
1327    * @dev See {IERC721-isApprovedForAll}.
1328    */
1329   function isApprovedForAll(address owner, address operator)
1330     public
1331     view
1332     virtual
1333     override
1334     returns (bool)
1335   {
1336     return _operatorApprovals[owner][operator];
1337   }
1338 
1339   /**
1340    * @dev See {IERC721-transferFrom}.
1341    */
1342   function transferFrom(
1343     address from,
1344     address to,
1345     uint256 tokenId
1346   ) public override {
1347     _transfer(from, to, tokenId);
1348   }
1349 
1350   /**
1351    * @dev See {IERC721-safeTransferFrom}.
1352    */
1353   function safeTransferFrom(
1354     address from,
1355     address to,
1356     uint256 tokenId
1357   ) public override {
1358     safeTransferFrom(from, to, tokenId, "");
1359   }
1360 
1361   /**
1362    * @dev See {IERC721-safeTransferFrom}.
1363    */
1364   function safeTransferFrom(
1365     address from,
1366     address to,
1367     uint256 tokenId,
1368     bytes memory _data
1369   ) public override {
1370     _transfer(from, to, tokenId);
1371     require(
1372       _checkOnERC721Received(from, to, tokenId, _data),
1373       "ERC721A: transfer to non ERC721Receiver implementer"
1374     );
1375   }
1376 
1377   /**
1378    * @dev Returns whether `tokenId` exists.
1379    *
1380    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1381    *
1382    * Tokens start existing when they are minted (`_mint`),
1383    */
1384   function _exists(uint256 tokenId) internal view returns (bool) {
1385     return tokenId < currentIndex;
1386   }
1387 
1388   function _safeMint(address to, uint256 quantity) internal {
1389     _safeMint(to, quantity, "");
1390   }
1391 
1392   /**
1393    * @dev Mints `quantity` tokens and transfers them to `to`.
1394    *
1395    * Requirements:
1396    *
1397    * - there must be `quantity` tokens remaining unminted in the total collection.
1398    * - `to` cannot be the zero address.
1399    * - `quantity` cannot be larger than the max batch size.
1400    *
1401    * Emits a {Transfer} event.
1402    */
1403   function _safeMint(
1404     address to,
1405     uint256 quantity,
1406     bytes memory _data
1407   ) internal {
1408     uint256 startTokenId = currentIndex;
1409     require(to != address(0), "ERC721A: mint to the zero address");
1410     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1411     require(!_exists(startTokenId), "ERC721A: token already minted");
1412     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1413 
1414     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1415 
1416     AddressData memory addressData = _addressData[to];
1417     _addressData[to] = AddressData(
1418       addressData.balance + uint128(quantity),
1419       addressData.numberMinted + uint128(quantity)
1420     );
1421     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1422 
1423     uint256 updatedIndex = startTokenId;
1424 
1425     for (uint256 i = 0; i < quantity; i++) {
1426       emit Transfer(address(0), to, updatedIndex);
1427       require(
1428         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1429         "ERC721A: transfer to non ERC721Receiver implementer"
1430       );
1431       updatedIndex++;
1432     }
1433 
1434     currentIndex = updatedIndex;
1435     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1436   }
1437 
1438   /**
1439    * @dev Transfers `tokenId` from `from` to `to`.
1440    *
1441    * Requirements:
1442    *
1443    * - `to` cannot be the zero address.
1444    * - `tokenId` token must be owned by `from`.
1445    *
1446    * Emits a {Transfer} event.
1447    */
1448   function _transfer(
1449     address from,
1450     address to,
1451     uint256 tokenId
1452   ) private {
1453     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1454 
1455     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1456       getApproved(tokenId) == _msgSender() ||
1457       isApprovedForAll(prevOwnership.addr, _msgSender()));
1458 
1459     require(
1460       isApprovedOrOwner,
1461       "ERC721A: transfer caller is not owner nor approved"
1462     );
1463 
1464     require(
1465       prevOwnership.addr == from,
1466       "ERC721A: transfer from incorrect owner"
1467     );
1468     require(to != address(0), "ERC721A: transfer to the zero address");
1469 
1470     _beforeTokenTransfers(from, to, tokenId, 1);
1471 
1472     // Clear approvals from the previous owner
1473     _approve(address(0), tokenId, prevOwnership.addr);
1474 
1475     _addressData[from].balance -= 1;
1476     _addressData[to].balance += 1;
1477     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1478 
1479     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1480     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1481     uint256 nextTokenId = tokenId + 1;
1482     if (_ownerships[nextTokenId].addr == address(0)) {
1483       if (_exists(nextTokenId)) {
1484         _ownerships[nextTokenId] = TokenOwnership(
1485           prevOwnership.addr,
1486           prevOwnership.startTimestamp
1487         );
1488       }
1489     }
1490 
1491     emit Transfer(from, to, tokenId);
1492     _afterTokenTransfers(from, to, tokenId, 1);
1493   }
1494 
1495   /**
1496    * @dev Approve `to` to operate on `tokenId`
1497    *
1498    * Emits a {Approval} event.
1499    */
1500   function _approve(
1501     address to,
1502     uint256 tokenId,
1503     address owner
1504   ) private {
1505     _tokenApprovals[tokenId] = to;
1506     emit Approval(owner, to, tokenId);
1507   }
1508 
1509   uint256 public nextOwnerToExplicitlySet = 0;
1510 
1511   /**
1512    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1513    */
1514   function _setOwnersExplicit(uint256 quantity) internal {
1515     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1516     require(quantity > 0, "quantity must be nonzero");
1517     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1518     if (endIndex > collectionSize - 1) {
1519       endIndex = collectionSize - 1;
1520     }
1521     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1522     require(_exists(endIndex), "not enough minted yet for this cleanup");
1523     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1524       if (_ownerships[i].addr == address(0)) {
1525         TokenOwnership memory ownership = ownershipOf(i);
1526         _ownerships[i] = TokenOwnership(
1527           ownership.addr,
1528           ownership.startTimestamp
1529         );
1530       }
1531     }
1532     nextOwnerToExplicitlySet = endIndex + 1;
1533   }
1534 
1535   /**
1536    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1537    * The call is not executed if the target address is not a contract.
1538    *
1539    * @param from address representing the previous owner of the given token ID
1540    * @param to target address that will receive the tokens
1541    * @param tokenId uint256 ID of the token to be transferred
1542    * @param _data bytes optional data to send along with the call
1543    * @return bool whether the call correctly returned the expected magic value
1544    */
1545   function _checkOnERC721Received(
1546     address from,
1547     address to,
1548     uint256 tokenId,
1549     bytes memory _data
1550   ) private returns (bool) {
1551     if (to.isContract()) {
1552       try
1553         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1554       returns (bytes4 retval) {
1555         return retval == IERC721Receiver(to).onERC721Received.selector;
1556       } catch (bytes memory reason) {
1557         if (reason.length == 0) {
1558           revert("ERC721A: transfer to non ERC721Receiver implementer");
1559         } else {
1560           assembly {
1561             revert(add(32, reason), mload(reason))
1562           }
1563         }
1564       }
1565     } else {
1566       return true;
1567     }
1568   }
1569 
1570   /**
1571    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1572    *
1573    * startTokenId - the first token id to be transferred
1574    * quantity - the amount to be transferred
1575    *
1576    * Calling conditions:
1577    *
1578    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1579    * transferred to `to`.
1580    * - When `from` is zero, `tokenId` will be minted for `to`.
1581    */
1582   function _beforeTokenTransfers(
1583     address from,
1584     address to,
1585     uint256 startTokenId,
1586     uint256 quantity
1587   ) internal virtual {}
1588 
1589   /**
1590    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1591    * minting.
1592    *
1593    * startTokenId - the first token id to be transferred
1594    * quantity - the amount to be transferred
1595    *
1596    * Calling conditions:
1597    *
1598    * - when `from` and `to` are both non-zero.
1599    * - `from` and `to` are never both zero.
1600    */
1601   function _afterTokenTransfers(
1602     address from,
1603     address to,
1604     uint256 startTokenId,
1605     uint256 quantity
1606   ) internal virtual {}
1607 }
1608 // File: @openzeppelin/contracts/access/Ownable.sol
1609 
1610 
1611 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1612 
1613 pragma solidity ^0.8.0;
1614 
1615 
1616 /**
1617  * @dev Contract module which provides a basic access control mechanism, where
1618  * there is an account (an owner) that can be granted exclusive access to
1619  * specific functions.
1620  *
1621  * By default, the owner account will be the one that deploys the contract. This
1622  * can later be changed with {transferOwnership}.
1623  *
1624  * This module is used through inheritance. It will make available the modifier
1625  * `onlyOwner`, which can be applied to your functions to restrict their use to
1626  * the owner.
1627  */
1628 abstract contract Ownable is Context {
1629     address private _owner;
1630 
1631     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1632 
1633     /**
1634      * @dev Initializes the contract setting the deployer as the initial owner.
1635      */
1636     constructor() {
1637         _transferOwnership(_msgSender());
1638     }
1639 
1640     /**
1641      * @dev Throws if called by any account other than the owner.
1642      */
1643     modifier onlyOwner() {
1644         _checkOwner();
1645         _;
1646     }
1647 
1648     /**
1649      * @dev Returns the address of the current owner.
1650      */
1651     function owner() public view virtual returns (address) {
1652         return _owner;
1653     }
1654 
1655     /**
1656      * @dev Throws if the sender is not the owner.
1657      */
1658     function _checkOwner() internal view virtual {
1659         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1660     }
1661 
1662     /**
1663      * @dev Leaves the contract without owner. It will not be possible to call
1664      * `onlyOwner` functions anymore. Can only be called by the current owner.
1665      *
1666      * NOTE: Renouncing ownership will leave the contract without an owner,
1667      * thereby removing any functionality that is only available to the owner.
1668      */
1669     function renounceOwnership() public virtual onlyOwner {
1670         _transferOwnership(address(0));
1671     }
1672 
1673     /**
1674      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1675      * Can only be called by the current owner.
1676      */
1677     function transferOwnership(address newOwner) public virtual onlyOwner {
1678         require(newOwner != address(0), "Ownable: new owner is the zero address");
1679         _transferOwnership(newOwner);
1680     }
1681 
1682     /**
1683      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1684      * Internal function without access restriction.
1685      */
1686     function _transferOwnership(address newOwner) internal virtual {
1687         address oldOwner = _owner;
1688         _owner = newOwner;
1689         emit OwnershipTransferred(oldOwner, newOwner);
1690     }
1691 }
1692 
1693 // File: contracts/CodeArtBear.sol
1694 
1695 
1696 /*
1697 -CODE-------------  -ART--------------  -OFFLINE----------
1698 @@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@
1699 @@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@
1700 @@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@
1701 @@@@@@              @@@@@@@    @@@@@@@  @@@@@@@    @@@@@@@
1702 @@@@@@              @@@@@@@    @@@@@@@  @@@@@@@    @@@@@@@
1703 @@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@
1704 @@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@
1705 @@@@@@@@@@@@@@@@@@  @@@@@@      @@@@@@  @@@@@@@@@@@@@@@@@@ 
1706 ------------------  ------------------  ------------------
1707  */
1708 
1709 pragma solidity ^0.8.0;
1710 
1711 
1712 
1713 
1714 
1715 
1716 
1717 
1718 contract CodeArtBear is ERC721A, Ownable, ReentrancyGuard, ERC2981{
1719     uint256 public tokenCount;
1720     uint256 public prePrice = 0.01 ether;
1721     uint256 public pubPrice = 0.02 ether;
1722     uint256 public batchSize = 100;
1723     uint256 public mintLimit = 3;
1724     uint256 public _totalSupply = 1500;
1725     bool public preSaleStart = false;
1726     bool public pubSaleStart = false;
1727     mapping(address => uint256) public minted; 
1728     bytes32 public merkleRoot;
1729 
1730     address public royaltyAddress;
1731     uint96 public royaltyFee = 1000;
1732     
1733     bool public revealed;
1734     string public baseURI;
1735     string public notRevealedURI;
1736 
1737     constructor() ERC721A("CodeArtBear", "CAB",batchSize, _totalSupply) {
1738         tokenCount = 0;
1739         royaltyAddress = msg.sender;
1740         _setDefaultRoyalty(msg.sender, royaltyFee);
1741     }
1742 
1743     function ownerMint(uint256 _mintAmount, address to) external onlyOwner {
1744         require((_mintAmount + tokenCount) <= (_totalSupply), "too many already minted before patner mint");
1745         _safeMint(to, _mintAmount);
1746         tokenCount += _mintAmount;
1747     }
1748 
1749     function preMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable nonReentrant {
1750         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1751         
1752         require(mintLimit >= _mintAmount, "limit over");
1753         require(mintLimit >= minted[msg.sender] + _mintAmount, "You have no Mint left");
1754         require(msg.value >= prePrice * _mintAmount, "Value sent is not correct");
1755         require((_mintAmount + tokenCount) <= (_totalSupply), "Sorry. No more NFTs");
1756         require(preSaleStart, "Sale Paused");
1757         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf),"Invalid Merkle Proof");
1758         
1759         minted[msg.sender] += _mintAmount;
1760         _safeMint(msg.sender, _mintAmount);
1761         tokenCount += _mintAmount;
1762     }
1763     
1764     function pubMint(uint256 _mintAmount) public payable nonReentrant {
1765         require(mintLimit >= _mintAmount, "limit over");
1766         require(mintLimit >= minted[msg.sender] + _mintAmount, "You have no Mint left");
1767         require(msg.value >= pubPrice * _mintAmount, "Value sent is not correct");
1768         require((_mintAmount + tokenCount) <= (_totalSupply), "Sorry. No more NFTs");
1769         require(pubSaleStart, "Sale Paused");
1770 
1771         minted[msg.sender] += _mintAmount;
1772         _safeMint(msg.sender, _mintAmount);
1773         tokenCount += _mintAmount;
1774     }
1775     function _baseURI() internal view override returns (string memory) {
1776         return baseURI;
1777     }
1778     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1779         baseURI = _newBaseURI;
1780     }
1781     function setHiddenURI(string memory _newHiddenURI) public onlyOwner {
1782         notRevealedURI = _newHiddenURI;
1783     }
1784     function switchReveal() public onlyOwner {
1785         revealed = !revealed;
1786     }
1787     function tokenURI(uint256 _tokenId) public view virtual override(ERC721A) returns (string memory) {
1788         require(_exists(_tokenId), "URI query for nonexistent token");
1789         if(revealed == false) {
1790             return notRevealedURI;
1791         }
1792         return string(abi.encodePacked(_baseURI(), Strings.toString(_tokenId), ".json"));
1793     }
1794 
1795     function withdrawRevenueShare() external onlyOwner {
1796         uint256 sendAmount = address(this).balance;
1797         address artist = payable(0x2E84aA395A462a9313fA4a3AF627de0Ae4f0EeA8);
1798         address engineer1 = payable(0xE7159308F1D50Beb0Fe76735ADD6e4a936Dc8597);
1799         address engineer2 = payable(0x2064f95A4537a7e9ce364384F55A2F4bBA3F0346);
1800         bool success;
1801         
1802         (success, ) = artist.call{value: (sendAmount * 800/1000)}("");
1803         require(success, "Failed to withdraw Ether");
1804         (success, ) = engineer1.call{value: (sendAmount * 100/1000)}("");
1805         require(success, "Failed to withdraw Ether");
1806         (success, ) = engineer2.call{value: (sendAmount * 100/1000)}("");
1807         require(success, "Failed to withdraw Ether");
1808     }
1809 
1810     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1811         merkleRoot = _merkleRoot;
1812     }
1813     function switchPreSale(bool _state) external onlyOwner {
1814         preSaleStart = _state;
1815     }
1816     function switchPubSale(bool _state) external onlyOwner {
1817         pubSaleStart = _state;
1818     }
1819     function setLimit(uint256 newLimit) external onlyOwner {
1820         mintLimit = newLimit;
1821     }
1822     function walletOfOwner(address _address) public view returns (uint256[] memory) {
1823         uint256 ownerTokenCount = balanceOf(_address);
1824         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1825         for (uint256 i; i < ownerTokenCount; i++) {
1826             tokenIds[i] = tokenOfOwnerByIndex(_address, i);
1827         }
1828         return tokenIds;
1829     }
1830     //set Default Royalty._feeNumerator 500 = 5% Royalty
1831     function setRoyaltyFee(uint96 _feeNumerator) external onlyOwner {
1832         royaltyFee = _feeNumerator;
1833         _setDefaultRoyalty(royaltyAddress, royaltyFee);
1834     }
1835     //Change the royalty address where royalty payouts are sent
1836     function setRoyaltyAddress(address _royaltyAddress) external onlyOwner {
1837         royaltyAddress = _royaltyAddress;
1838         _setDefaultRoyalty(royaltyAddress, royaltyFee);
1839     }
1840   
1841     function supportsInterface(
1842         bytes4 interfaceId
1843     ) public view virtual override(ERC721A, ERC2981) returns (bool) {
1844         // Supports the following `interfaceId`s:
1845         // - IERC165: 0x01ffc9a7
1846         // - IERC721: 0x80ac58cd
1847         // - IERC721Metadata: 0x5b5e139f
1848         // - IERC2981: 0x2a55205a
1849         return
1850             ERC721A.supportsInterface(interfaceId) ||
1851             ERC2981.supportsInterface(interfaceId);
1852     }
1853 
1854 }