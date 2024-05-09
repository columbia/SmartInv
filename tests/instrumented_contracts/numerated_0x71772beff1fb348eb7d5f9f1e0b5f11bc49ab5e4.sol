1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214                 /// @solidity memory-safe-assembly
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev Interface of the ERC165 standard, as defined in the
235  * https://eips.ethereum.org/EIPS/eip-165[EIP].
236  *
237  * Implementers can declare support of contract interfaces, which can then be
238  * queried by others ({ERC165Checker}).
239  *
240  * For an implementation, see {ERC165}.
241  */
242 interface IERC165 {
243     /**
244      * @dev Returns true if this contract implements the interface defined by
245      * `interfaceId`. See the corresponding
246      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
247      * to learn more about how these ids are created.
248      *
249      * This function call must use less than 30 000 gas.
250      */
251     function supportsInterface(bytes4 interfaceId) external view returns (bool);
252 }
253 
254 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
255 
256 
257 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 
262 /**
263  * @dev Implementation of the {IERC165} interface.
264  *
265  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
266  * for the additional interface id that will be supported. For example:
267  *
268  * ```solidity
269  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
270  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
271  * }
272  * ```
273  *
274  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
275  */
276 abstract contract ERC165 is IERC165 {
277     /**
278      * @dev See {IERC165-supportsInterface}.
279      */
280     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
281         return interfaceId == type(IERC165).interfaceId;
282     }
283 }
284 
285 // File: @openzeppelin/contracts/utils/Strings.sol
286 
287 
288 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
289 
290 pragma solidity ^0.8.0;
291 
292 /**
293  * @dev String operations.
294  */
295 library Strings {
296     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
297     uint8 private constant _ADDRESS_LENGTH = 20;
298 
299     /**
300      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
301      */
302     function toString(uint256 value) internal pure returns (string memory) {
303         // Inspired by OraclizeAPI's implementation - MIT licence
304         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
305 
306         if (value == 0) {
307             return "0";
308         }
309         uint256 temp = value;
310         uint256 digits;
311         while (temp != 0) {
312             digits++;
313             temp /= 10;
314         }
315         bytes memory buffer = new bytes(digits);
316         while (value != 0) {
317             digits -= 1;
318             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
319             value /= 10;
320         }
321         return string(buffer);
322     }
323 
324     /**
325      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
326      */
327     function toHexString(uint256 value) internal pure returns (string memory) {
328         if (value == 0) {
329             return "0x00";
330         }
331         uint256 temp = value;
332         uint256 length = 0;
333         while (temp != 0) {
334             length++;
335             temp >>= 8;
336         }
337         return toHexString(value, length);
338     }
339 
340     /**
341      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
342      */
343     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
344         bytes memory buffer = new bytes(2 * length + 2);
345         buffer[0] = "0";
346         buffer[1] = "x";
347         for (uint256 i = 2 * length + 1; i > 1; --i) {
348             buffer[i] = _HEX_SYMBOLS[value & 0xf];
349             value >>= 4;
350         }
351         require(value == 0, "Strings: hex length insufficient");
352         return string(buffer);
353     }
354 
355     /**
356      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
357      */
358     function toHexString(address addr) internal pure returns (string memory) {
359         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
360     }
361 }
362 
363 // File: @openzeppelin/contracts/access/IAccessControl.sol
364 
365 
366 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 /**
371  * @dev External interface of AccessControl declared to support ERC165 detection.
372  */
373 interface IAccessControl {
374     /**
375      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
376      *
377      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
378      * {RoleAdminChanged} not being emitted signaling this.
379      *
380      * _Available since v3.1._
381      */
382     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
383 
384     /**
385      * @dev Emitted when `account` is granted `role`.
386      *
387      * `sender` is the account that originated the contract call, an admin role
388      * bearer except when using {AccessControl-_setupRole}.
389      */
390     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
391 
392     /**
393      * @dev Emitted when `account` is revoked `role`.
394      *
395      * `sender` is the account that originated the contract call:
396      *   - if using `revokeRole`, it is the admin role bearer
397      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
398      */
399     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
400 
401     /**
402      * @dev Returns `true` if `account` has been granted `role`.
403      */
404     function hasRole(bytes32 role, address account) external view returns (bool);
405 
406     /**
407      * @dev Returns the admin role that controls `role`. See {grantRole} and
408      * {revokeRole}.
409      *
410      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
411      */
412     function getRoleAdmin(bytes32 role) external view returns (bytes32);
413 
414     /**
415      * @dev Grants `role` to `account`.
416      *
417      * If `account` had not been already granted `role`, emits a {RoleGranted}
418      * event.
419      *
420      * Requirements:
421      *
422      * - the caller must have ``role``'s admin role.
423      */
424     function grantRole(bytes32 role, address account) external;
425 
426     /**
427      * @dev Revokes `role` from `account`.
428      *
429      * If `account` had been granted `role`, emits a {RoleRevoked} event.
430      *
431      * Requirements:
432      *
433      * - the caller must have ``role``'s admin role.
434      */
435     function revokeRole(bytes32 role, address account) external;
436 
437     /**
438      * @dev Revokes `role` from the calling account.
439      *
440      * Roles are often managed via {grantRole} and {revokeRole}: this function's
441      * purpose is to provide a mechanism for accounts to lose their privileges
442      * if they are compromised (such as when a trusted device is misplaced).
443      *
444      * If the calling account had been granted `role`, emits a {RoleRevoked}
445      * event.
446      *
447      * Requirements:
448      *
449      * - the caller must be `account`.
450      */
451     function renounceRole(bytes32 role, address account) external;
452 }
453 
454 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
455 
456 
457 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 /**
462  * @dev These functions deal with verification of Merkle Tree proofs.
463  *
464  * The proofs can be generated using the JavaScript library
465  * https://github.com/miguelmota/merkletreejs[merkletreejs].
466  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
467  *
468  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
469  *
470  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
471  * hashing, or use a hash function other than keccak256 for hashing leaves.
472  * This is because the concatenation of a sorted pair of internal nodes in
473  * the merkle tree could be reinterpreted as a leaf value.
474  */
475 library MerkleProof {
476     /**
477      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
478      * defined by `root`. For this, a `proof` must be provided, containing
479      * sibling hashes on the branch from the leaf to the root of the tree. Each
480      * pair of leaves and each pair of pre-images are assumed to be sorted.
481      */
482     function verify(
483         bytes32[] memory proof,
484         bytes32 root,
485         bytes32 leaf
486     ) internal pure returns (bool) {
487         return processProof(proof, leaf) == root;
488     }
489 
490     /**
491      * @dev Calldata version of {verify}
492      *
493      * _Available since v4.7._
494      */
495     function verifyCalldata(
496         bytes32[] calldata proof,
497         bytes32 root,
498         bytes32 leaf
499     ) internal pure returns (bool) {
500         return processProofCalldata(proof, leaf) == root;
501     }
502 
503     /**
504      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
505      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
506      * hash matches the root of the tree. When processing the proof, the pairs
507      * of leafs & pre-images are assumed to be sorted.
508      *
509      * _Available since v4.4._
510      */
511     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
512         bytes32 computedHash = leaf;
513         for (uint256 i = 0; i < proof.length; i++) {
514             computedHash = _hashPair(computedHash, proof[i]);
515         }
516         return computedHash;
517     }
518 
519     /**
520      * @dev Calldata version of {processProof}
521      *
522      * _Available since v4.7._
523      */
524     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
525         bytes32 computedHash = leaf;
526         for (uint256 i = 0; i < proof.length; i++) {
527             computedHash = _hashPair(computedHash, proof[i]);
528         }
529         return computedHash;
530     }
531 
532     /**
533      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
534      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
535      *
536      * _Available since v4.7._
537      */
538     function multiProofVerify(
539         bytes32[] memory proof,
540         bool[] memory proofFlags,
541         bytes32 root,
542         bytes32[] memory leaves
543     ) internal pure returns (bool) {
544         return processMultiProof(proof, proofFlags, leaves) == root;
545     }
546 
547     /**
548      * @dev Calldata version of {multiProofVerify}
549      *
550      * _Available since v4.7._
551      */
552     function multiProofVerifyCalldata(
553         bytes32[] calldata proof,
554         bool[] calldata proofFlags,
555         bytes32 root,
556         bytes32[] memory leaves
557     ) internal pure returns (bool) {
558         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
559     }
560 
561     /**
562      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
563      * consuming from one or the other at each step according to the instructions given by
564      * `proofFlags`.
565      *
566      * _Available since v4.7._
567      */
568     function processMultiProof(
569         bytes32[] memory proof,
570         bool[] memory proofFlags,
571         bytes32[] memory leaves
572     ) internal pure returns (bytes32 merkleRoot) {
573         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
574         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
575         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
576         // the merkle tree.
577         uint256 leavesLen = leaves.length;
578         uint256 totalHashes = proofFlags.length;
579 
580         // Check proof validity.
581         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
582 
583         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
584         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
585         bytes32[] memory hashes = new bytes32[](totalHashes);
586         uint256 leafPos = 0;
587         uint256 hashPos = 0;
588         uint256 proofPos = 0;
589         // At each step, we compute the next hash using two values:
590         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
591         //   get the next hash.
592         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
593         //   `proof` array.
594         for (uint256 i = 0; i < totalHashes; i++) {
595             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
596             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
597             hashes[i] = _hashPair(a, b);
598         }
599 
600         if (totalHashes > 0) {
601             return hashes[totalHashes - 1];
602         } else if (leavesLen > 0) {
603             return leaves[0];
604         } else {
605             return proof[0];
606         }
607     }
608 
609     /**
610      * @dev Calldata version of {processMultiProof}
611      *
612      * _Available since v4.7._
613      */
614     function processMultiProofCalldata(
615         bytes32[] calldata proof,
616         bool[] calldata proofFlags,
617         bytes32[] memory leaves
618     ) internal pure returns (bytes32 merkleRoot) {
619         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
620         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
621         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
622         // the merkle tree.
623         uint256 leavesLen = leaves.length;
624         uint256 totalHashes = proofFlags.length;
625 
626         // Check proof validity.
627         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
628 
629         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
630         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
631         bytes32[] memory hashes = new bytes32[](totalHashes);
632         uint256 leafPos = 0;
633         uint256 hashPos = 0;
634         uint256 proofPos = 0;
635         // At each step, we compute the next hash using two values:
636         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
637         //   get the next hash.
638         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
639         //   `proof` array.
640         for (uint256 i = 0; i < totalHashes; i++) {
641             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
642             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
643             hashes[i] = _hashPair(a, b);
644         }
645 
646         if (totalHashes > 0) {
647             return hashes[totalHashes - 1];
648         } else if (leavesLen > 0) {
649             return leaves[0];
650         } else {
651             return proof[0];
652         }
653     }
654 
655     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
656         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
657     }
658 
659     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
660         /// @solidity memory-safe-assembly
661         assembly {
662             mstore(0x00, a)
663             mstore(0x20, b)
664             value := keccak256(0x00, 0x40)
665         }
666     }
667 }
668 
669 // File: contracts/lib/IERC721A.sol
670 
671 
672 // ERC721A Contracts v4.0.0
673 // Creator: Chiru Labs
674 
675 pragma solidity ^0.8.4;
676 
677 /**
678  * @dev Interface of an ERC721A compliant contract.
679  */
680 interface IERC721A {
681     /**
682      * The caller must own the token or be an approved operator.
683      */
684     error ApprovalCallerNotOwnerNorApproved();
685 
686     /**
687      * The token does not exist.
688      */
689     error ApprovalQueryForNonexistentToken();
690 
691     /**
692      * The caller cannot approve to their own address.
693      */
694     error ApproveToCaller();
695 
696     /**
697      * The caller cannot approve to the current owner.
698      */
699     error ApprovalToCurrentOwner();
700 
701     /**
702      * Cannot query the balance for the zero address.
703      */
704     error BalanceQueryForZeroAddress();
705 
706     /**
707      * Cannot mint to the zero address.
708      */
709     error MintToZeroAddress();
710 
711     /**
712      * The quantity of tokens minted must be more than zero.
713      */
714     error MintZeroQuantity();
715 
716     /**
717      * The token does not exist.
718      */
719     error OwnerQueryForNonexistentToken();
720 
721     /**
722      * The caller must own the token or be an approved operator.
723      */
724     error TransferCallerNotOwnerNorApproved();
725 
726     /**
727      * The token must be owned by `from`.
728      */
729     error TransferFromIncorrectOwner();
730 
731     /**
732      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
733      */
734     error TransferToNonERC721ReceiverImplementer();
735 
736     /**
737      * Cannot transfer to the zero address.
738      */
739     error TransferToZeroAddress();
740 
741     /**
742      * The token does not exist.
743      */
744     error URIQueryForNonexistentToken();
745 
746     struct TokenOwnership {
747         // The address of the owner.
748         address addr;
749         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
750         uint64 startTimestamp;
751         // Whether the token has been burned.
752         bool burned;
753     }
754 
755     /**
756      * @dev Returns the total amount of tokens stored by the contract.
757      *
758      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
759      */
760     function totalSupply() external view returns (uint256);
761 
762     // ==============================
763     //            IERC165
764     // ==============================
765 
766     /**
767      * @dev Returns true if this contract implements the interface defined by
768      * `interfaceId`. See the corresponding
769      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
770      * to learn more about how these ids are created.
771      *
772      * This function call must use less than 30 000 gas.
773      */
774     function supportsInterface(bytes4 interfaceId) external view returns (bool);
775 
776     // ==============================
777     //            IERC721
778     // ==============================
779 
780     /**
781      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
782      */
783     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
784 
785     /**
786      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
787      */
788     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
789 
790     /**
791      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
792      */
793     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
794 
795     /**
796      * @dev Returns the number of tokens in ``owner``'s account.
797      */
798     function balanceOf(address owner) external view returns (uint256 balance);
799 
800     /**
801      * @dev Returns the owner of the `tokenId` token.
802      *
803      * Requirements:
804      *
805      * - `tokenId` must exist.
806      */
807     function ownerOf(uint256 tokenId) external view returns (address owner);
808 
809     /**
810      * @dev Safely transfers `tokenId` token from `from` to `to`.
811      *
812      * Requirements:
813      *
814      * - `from` cannot be the zero address.
815      * - `to` cannot be the zero address.
816      * - `tokenId` token must exist and be owned by `from`.
817      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
818      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
819      *
820      * Emits a {Transfer} event.
821      */
822     function safeTransferFrom(
823         address from,
824         address to,
825         uint256 tokenId,
826         bytes calldata data
827     ) external;
828 
829     /**
830      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
831      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
832      *
833      * Requirements:
834      *
835      * - `from` cannot be the zero address.
836      * - `to` cannot be the zero address.
837      * - `tokenId` token must exist and be owned by `from`.
838      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
839      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
840      *
841      * Emits a {Transfer} event.
842      */
843     function safeTransferFrom(
844         address from,
845         address to,
846         uint256 tokenId
847     ) external;
848 
849     /**
850      * @dev Transfers `tokenId` token from `from` to `to`.
851      *
852      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
853      *
854      * Requirements:
855      *
856      * - `from` cannot be the zero address.
857      * - `to` cannot be the zero address.
858      * - `tokenId` token must be owned by `from`.
859      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
860      *
861      * Emits a {Transfer} event.
862      */
863     function transferFrom(
864         address from,
865         address to,
866         uint256 tokenId
867     ) external;
868 
869     /**
870      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
871      * The approval is cleared when the token is transferred.
872      *
873      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
874      *
875      * Requirements:
876      *
877      * - The caller must own the token or be an approved operator.
878      * - `tokenId` must exist.
879      *
880      * Emits an {Approval} event.
881      */
882     function approve(address to, uint256 tokenId) external;
883 
884     /**
885      * @dev Approve or remove `operator` as an operator for the caller.
886      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
887      *
888      * Requirements:
889      *
890      * - The `operator` cannot be the caller.
891      *
892      * Emits an {ApprovalForAll} event.
893      */
894     function setApprovalForAll(address operator, bool _approved) external;
895 
896     /**
897      * @dev Returns the account approved for `tokenId` token.
898      *
899      * Requirements:
900      *
901      * - `tokenId` must exist.
902      */
903     function getApproved(uint256 tokenId) external view returns (address operator);
904 
905     /**
906      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
907      *
908      * See {setApprovalForAll}
909      */
910     function isApprovedForAll(address owner, address operator) external view returns (bool);
911 
912     // ==============================
913     //        IERC721Metadata
914     // ==============================
915 
916     /**
917      * @dev Returns the token collection name.
918      */
919     function name() external view returns (string memory);
920 
921     /**
922      * @dev Returns the token collection symbol.
923      */
924     function symbol() external view returns (string memory);
925 
926     /**
927      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
928      */
929     function tokenURI(uint256 tokenId) external view returns (string memory);
930 }
931 // File: contracts/lib/ERC721A.sol
932 
933 
934 // ERC721A Contracts v4.0.0
935 // Creator: Chiru Labs
936 
937 pragma solidity ^0.8.4;
938 
939 
940 /**
941  * @dev ERC721 token receiver interface.
942  */
943 interface ERC721A__IERC721Receiver {
944     function onERC721Received(
945         address operator,
946         address from,
947         uint256 tokenId,
948         bytes calldata data
949     ) external returns (bytes4);
950 }
951 
952 /**
953  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
954  * the Metadata extension. Built to optimize for lower gas during batch mints.
955  *
956  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
957  *
958  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
959  *
960  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
961  */
962 contract ERC721A is IERC721A {
963     // Mask of an entry in packed address data.
964     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
965 
966     // The bit position of `numberMinted` in packed address data.
967     uint256 private constant BITPOS_NUMBER_MINTED = 64;
968 
969     // The bit position of `numberBurned` in packed address data.
970     uint256 private constant BITPOS_NUMBER_BURNED = 128;
971 
972     // The bit position of `aux` in packed address data.
973     uint256 private constant BITPOS_AUX = 192;
974 
975     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
976     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
977 
978     // The bit position of `startTimestamp` in packed ownership.
979     uint256 private constant BITPOS_START_TIMESTAMP = 160;
980 
981     // The bit mask of the `burned` bit in packed ownership.
982     uint256 private constant BITMASK_BURNED = 1 << 224;
983     
984     // The bit position of the `nextInitialized` bit in packed ownership.
985     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
986 
987     // The bit mask of the `nextInitialized` bit in packed ownership.
988     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
989 
990     // The tokenId of the next token to be minted.
991     uint256 private _currentIndex;
992 
993     // The number of tokens burned.
994     uint256 private _burnCounter;
995 
996     // Token name
997     string private _name;
998 
999     // Token symbol
1000     string private _symbol;
1001 
1002     // Mapping from token ID to ownership details
1003     // An empty struct value does not necessarily mean the token is unowned.
1004     // See `_packedOwnershipOf` implementation for details.
1005     //
1006     // Bits Layout:
1007     // - [0..159]   `addr`
1008     // - [160..223] `startTimestamp`
1009     // - [224]      `burned`
1010     // - [225]      `nextInitialized`
1011     mapping(uint256 => uint256) private _packedOwnerships;
1012 
1013     // Mapping owner address to address data.
1014     //
1015     // Bits Layout:
1016     // - [0..63]    `balance`
1017     // - [64..127]  `numberMinted`
1018     // - [128..191] `numberBurned`
1019     // - [192..255] `aux`
1020     mapping(address => uint256) private _packedAddressData;
1021 
1022     // Mapping from token ID to approved address.
1023     mapping(uint256 => address) private _tokenApprovals;
1024 
1025     // Mapping from owner to operator approvals
1026     mapping(address => mapping(address => bool)) private _operatorApprovals;
1027 
1028     constructor(string memory name_, string memory symbol_) {
1029         _name = name_;
1030         _symbol = symbol_;
1031         _currentIndex = _startTokenId();
1032     }
1033 
1034     /**
1035      * @dev Returns the starting token ID. 
1036      * To change the starting token ID, please override this function.
1037      */
1038     function _startTokenId() internal view virtual returns (uint256) {
1039         return 0;
1040     }
1041 
1042     /**
1043      * @dev Returns the next token ID to be minted.
1044      */
1045     function _nextTokenId() internal view returns (uint256) {
1046         return _currentIndex;
1047     }
1048 
1049     /**
1050      * @dev Returns the total number of tokens in existence.
1051      * Burned tokens will reduce the count. 
1052      * To get the total number of tokens minted, please see `_totalMinted`.
1053      */
1054     function totalSupply() public view override returns (uint256) {
1055         // Counter underflow is impossible as _burnCounter cannot be incremented
1056         // more than `_currentIndex - _startTokenId()` times.
1057         unchecked {
1058             return _currentIndex - _burnCounter - _startTokenId();
1059         }
1060     }
1061 
1062     /**
1063      * @dev Returns the total amount of tokens minted in the contract.
1064      */
1065     function _totalMinted() internal view returns (uint256) {
1066         // Counter underflow is impossible as _currentIndex does not decrement,
1067         // and it is initialized to `_startTokenId()`
1068         unchecked {
1069             return _currentIndex - _startTokenId();
1070         }
1071     }
1072 
1073     /**
1074      * @dev Returns the total number of tokens burned.
1075      */
1076     function _totalBurned() internal view returns (uint256) {
1077         return _burnCounter;
1078     }
1079 
1080     /**
1081      * @dev See {IERC165-supportsInterface}.
1082      */
1083     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1084         // The interface IDs are constants representing the first 4 bytes of the XOR of
1085         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1086         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1087         return
1088             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1089             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1090             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1091     }
1092 
1093     /**
1094      * @dev See {IERC721-balanceOf}.
1095      */
1096     function balanceOf(address owner) public view override returns (uint256) {
1097         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
1098         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
1099     }
1100 
1101     /**
1102      * Returns the number of tokens minted by `owner`.
1103      */
1104     function _numberMinted(address owner) internal view returns (uint256) {
1105         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
1106     }
1107 
1108     /**
1109      * Returns the number of tokens burned by or on behalf of `owner`.
1110      */
1111     function _numberBurned(address owner) internal view returns (uint256) {
1112         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
1113     }
1114 
1115     /**
1116      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1117      */
1118     function _getAux(address owner) internal view returns (uint64) {
1119         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1120     }
1121 
1122     /**
1123      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1124      * If there are multiple variables, please pack them into a uint64.
1125      */
1126     function _setAux(address owner, uint64 aux) internal {
1127         uint256 packed = _packedAddressData[owner];
1128         uint256 auxCasted;
1129         assembly { // Cast aux without masking.
1130             auxCasted := aux
1131         }
1132         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1133         _packedAddressData[owner] = packed;
1134     }
1135 
1136     /**
1137      * Returns the packed ownership data of `tokenId`.
1138      */
1139     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1140         uint256 curr = tokenId;
1141 
1142         unchecked {
1143             if (_startTokenId() <= curr)
1144                 if (curr < _currentIndex) {
1145                     uint256 packed = _packedOwnerships[curr];
1146                     // If not burned.
1147                     if (packed & BITMASK_BURNED == 0) {
1148                         // Invariant:
1149                         // There will always be an ownership that has an address and is not burned
1150                         // before an ownership that does not have an address and is not burned.
1151                         // Hence, curr will not underflow.
1152                         //
1153                         // We can directly compare the packed value.
1154                         // If the address is zero, packed is zero.
1155                         while (packed == 0) {
1156                             packed = _packedOwnerships[--curr];
1157                         }
1158                         return packed;
1159                     }
1160                 }
1161         }
1162         revert OwnerQueryForNonexistentToken();
1163     }
1164 
1165     /**
1166      * Returns the unpacked `TokenOwnership` struct from `packed`.
1167      */
1168     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1169         ownership.addr = address(uint160(packed));
1170         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1171         ownership.burned = packed & BITMASK_BURNED != 0;
1172     }
1173 
1174     /**
1175      * Returns the unpacked `TokenOwnership` struct at `index`.
1176      */
1177     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1178         return _unpackedOwnership(_packedOwnerships[index]);
1179     }
1180 
1181     /**
1182      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1183      */
1184     function _initializeOwnershipAt(uint256 index) internal {
1185         if (_packedOwnerships[index] == 0) {
1186             _packedOwnerships[index] = _packedOwnershipOf(index);
1187         }
1188     }
1189 
1190     /**
1191      * Gas spent here starts off proportional to the maximum mint batch size.
1192      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1193      */
1194     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1195         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1196     }
1197 
1198     /**
1199      * @dev See {IERC721-ownerOf}.
1200      */
1201     function ownerOf(uint256 tokenId) public view override returns (address) {
1202         return address(uint160(_packedOwnershipOf(tokenId)));
1203     }
1204 
1205     /**
1206      * @dev See {IERC721Metadata-name}.
1207      */
1208     function name() public view virtual override returns (string memory) {
1209         return _name;
1210     }
1211 
1212     /**
1213      * @dev See {IERC721Metadata-symbol}.
1214      */
1215     function symbol() public view virtual override returns (string memory) {
1216         return _symbol;
1217     }
1218 
1219     /**
1220      * @dev See {IERC721Metadata-tokenURI}.
1221      */
1222     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1223         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1224 
1225         string memory baseURI = _baseURI();
1226         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1227     }
1228 
1229     /**
1230      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1231      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1232      * by default, can be overriden in child contracts.
1233      */
1234     function _baseURI() internal view virtual returns (string memory) {
1235         return '';
1236     }
1237 
1238     /**
1239      * @dev Casts the address to uint256 without masking.
1240      */
1241     function _addressToUint256(address value) private pure returns (uint256 result) {
1242         assembly {
1243             result := value
1244         }
1245     }
1246 
1247     /**
1248      * @dev Casts the boolean to uint256 without branching.
1249      */
1250     function _boolToUint256(bool value) private pure returns (uint256 result) {
1251         assembly {
1252             result := value
1253         }
1254     }
1255 
1256     /**
1257      * @dev See {IERC721-approve}.
1258      */
1259     function approve(address to, uint256 tokenId) public override {
1260         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1261         if (to == owner) revert ApprovalToCurrentOwner();
1262 
1263         if (_msgSenderERC721A() != owner)
1264             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1265                 revert ApprovalCallerNotOwnerNorApproved();
1266             }
1267 
1268         _tokenApprovals[tokenId] = to;
1269         emit Approval(owner, to, tokenId);
1270     }
1271 
1272     /**
1273      * @dev See {IERC721-getApproved}.
1274      */
1275     function getApproved(uint256 tokenId) public view override returns (address) {
1276         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1277 
1278         return _tokenApprovals[tokenId];
1279     }
1280 
1281     /**
1282      * @dev See {IERC721-setApprovalForAll}.
1283      */
1284     function setApprovalForAll(address operator, bool approved) public virtual override {
1285         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1286 
1287         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1288         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1289     }
1290 
1291     /**
1292      * @dev See {IERC721-isApprovedForAll}.
1293      */
1294     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1295         return _operatorApprovals[owner][operator];
1296     }
1297 
1298     /**
1299      * @dev See {IERC721-transferFrom}.
1300      */
1301     function transferFrom(
1302         address from,
1303         address to,
1304         uint256 tokenId
1305     ) public virtual override {
1306         _transfer(from, to, tokenId);
1307     }
1308 
1309     /**
1310      * @dev See {IERC721-safeTransferFrom}.
1311      */
1312     function safeTransferFrom(
1313         address from,
1314         address to,
1315         uint256 tokenId
1316     ) public virtual override {
1317         safeTransferFrom(from, to, tokenId, '');
1318     }
1319 
1320     /**
1321      * @dev See {IERC721-safeTransferFrom}.
1322      */
1323     function safeTransferFrom(
1324         address from,
1325         address to,
1326         uint256 tokenId,
1327         bytes memory _data
1328     ) public virtual override {
1329         _transfer(from, to, tokenId);
1330         if (to.code.length != 0)
1331             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1332                 revert TransferToNonERC721ReceiverImplementer();
1333             }
1334     }
1335 
1336     /**
1337      * @dev Returns whether `tokenId` exists.
1338      *
1339      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1340      *
1341      * Tokens start existing when they are minted (`_mint`),
1342      */
1343     function _exists(uint256 tokenId) internal view returns (bool) {
1344         return
1345             _startTokenId() <= tokenId &&
1346             tokenId < _currentIndex && // If within bounds,
1347             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1348     }
1349 
1350     /**
1351      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1352      */
1353     function _safeMint(address to, uint256 quantity) internal {
1354         _safeMint(to, quantity, '');
1355     }
1356 
1357     /**
1358      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1359      *
1360      * Requirements:
1361      *
1362      * - If `to` refers to a smart contract, it must implement
1363      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1364      * - `quantity` must be greater than 0.
1365      *
1366      * Emits a {Transfer} event.
1367      */
1368     function _safeMint(
1369         address to,
1370         uint256 quantity,
1371         bytes memory _data
1372     ) internal {
1373         uint256 startTokenId = _currentIndex;
1374         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1375         if (quantity == 0) revert MintZeroQuantity();
1376 
1377         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1378 
1379         // Overflows are incredibly unrealistic.
1380         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1381         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1382         unchecked {
1383             // Updates:
1384             // - `balance += quantity`.
1385             // - `numberMinted += quantity`.
1386             //
1387             // We can directly add to the balance and number minted.
1388             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1389 
1390             // Updates:
1391             // - `address` to the owner.
1392             // - `startTimestamp` to the timestamp of minting.
1393             // - `burned` to `false`.
1394             // - `nextInitialized` to `quantity == 1`.
1395             _packedOwnerships[startTokenId] =
1396                 _addressToUint256(to) |
1397                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1398                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1399 
1400             uint256 updatedIndex = startTokenId;
1401             uint256 end = updatedIndex + quantity;
1402 
1403             if (to.code.length != 0) {
1404                 do {
1405                     emit Transfer(address(0), to, updatedIndex);
1406                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1407                         revert TransferToNonERC721ReceiverImplementer();
1408                     }
1409                 } while (updatedIndex < end);
1410                 // Reentrancy protection
1411                 if (_currentIndex != startTokenId) revert();
1412             } else {
1413                 do {
1414                     emit Transfer(address(0), to, updatedIndex++);
1415                 } while (updatedIndex < end);
1416             }
1417             _currentIndex = updatedIndex;
1418         }
1419         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1420     }
1421 
1422     /**
1423      * @dev Mints `quantity` tokens and transfers them to `to`.
1424      *
1425      * Requirements:
1426      *
1427      * - `to` cannot be the zero address.
1428      * - `quantity` must be greater than 0.
1429      *
1430      * Emits a {Transfer} event.
1431      */
1432     function _mint(address to, uint256 quantity) internal {
1433         uint256 startTokenId = _currentIndex;
1434         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1435         if (quantity == 0) revert MintZeroQuantity();
1436 
1437         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1438 
1439         // Overflows are incredibly unrealistic.
1440         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1441         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1442         unchecked {
1443             // Updates:
1444             // - `balance += quantity`.
1445             // - `numberMinted += quantity`.
1446             //
1447             // We can directly add to the balance and number minted.
1448             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1449 
1450             // Updates:
1451             // - `address` to the owner.
1452             // - `startTimestamp` to the timestamp of minting.
1453             // - `burned` to `false`.
1454             // - `nextInitialized` to `quantity == 1`.
1455             _packedOwnerships[startTokenId] =
1456                 _addressToUint256(to) |
1457                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1458                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1459 
1460             uint256 updatedIndex = startTokenId;
1461             uint256 end = updatedIndex + quantity;
1462 
1463             do {
1464                 emit Transfer(address(0), to, updatedIndex++);
1465             } while (updatedIndex < end);
1466 
1467             _currentIndex = updatedIndex;
1468         }
1469         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1470     }
1471 
1472     /**
1473      * @dev Transfers `tokenId` from `from` to `to`.
1474      *
1475      * Requirements:
1476      *
1477      * - `to` cannot be the zero address.
1478      * - `tokenId` token must be owned by `from`.
1479      *
1480      * Emits a {Transfer} event.
1481      */
1482     function _transfer(
1483         address from,
1484         address to,
1485         uint256 tokenId
1486     ) private {
1487         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1488 
1489         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1490 
1491         address approvedAddress = _tokenApprovals[tokenId];
1492 
1493         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1494             isApprovedForAll(from, _msgSenderERC721A()) ||
1495             approvedAddress == _msgSenderERC721A());
1496 
1497         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1498         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1499 
1500         _beforeTokenTransfers(from, to, tokenId, 1);
1501 
1502         // Clear approvals from the previous owner.
1503         if (_addressToUint256(approvedAddress) != 0) {
1504             delete _tokenApprovals[tokenId];
1505         }
1506 
1507         // Underflow of the sender's balance is impossible because we check for
1508         // ownership above and the recipient's balance can't realistically overflow.
1509         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1510         unchecked {
1511             // We can directly increment and decrement the balances.
1512             --_packedAddressData[from]; // Updates: `balance -= 1`.
1513             ++_packedAddressData[to]; // Updates: `balance += 1`.
1514 
1515             // Updates:
1516             // - `address` to the next owner.
1517             // - `startTimestamp` to the timestamp of transfering.
1518             // - `burned` to `false`.
1519             // - `nextInitialized` to `true`.
1520             _packedOwnerships[tokenId] =
1521                 _addressToUint256(to) |
1522                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1523                 BITMASK_NEXT_INITIALIZED;
1524 
1525             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1526             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1527                 uint256 nextTokenId = tokenId + 1;
1528                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1529                 if (_packedOwnerships[nextTokenId] == 0) {
1530                     // If the next slot is within bounds.
1531                     if (nextTokenId != _currentIndex) {
1532                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1533                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1534                     }
1535                 }
1536             }
1537         }
1538 
1539         emit Transfer(from, to, tokenId);
1540         _afterTokenTransfers(from, to, tokenId, 1);
1541     }
1542 
1543     /**
1544      * @dev Equivalent to `_burn(tokenId, false)`.
1545      */
1546     function _burn(uint256 tokenId) internal virtual {
1547         _burn(tokenId, false);
1548     }
1549 
1550     /**
1551      * @dev Destroys `tokenId`.
1552      * The approval is cleared when the token is burned.
1553      *
1554      * Requirements:
1555      *
1556      * - `tokenId` must exist.
1557      *
1558      * Emits a {Transfer} event.
1559      */
1560     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1561         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1562 
1563         address from = address(uint160(prevOwnershipPacked));
1564         address approvedAddress = _tokenApprovals[tokenId];
1565 
1566         if (approvalCheck) {
1567             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1568                 isApprovedForAll(from, _msgSenderERC721A()) ||
1569                 approvedAddress == _msgSenderERC721A());
1570 
1571             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1572         }
1573 
1574         _beforeTokenTransfers(from, address(0), tokenId, 1);
1575 
1576         // Clear approvals from the previous owner.
1577         if (_addressToUint256(approvedAddress) != 0) {
1578             delete _tokenApprovals[tokenId];
1579         }
1580 
1581         // Underflow of the sender's balance is impossible because we check for
1582         // ownership above and the recipient's balance can't realistically overflow.
1583         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1584         unchecked {
1585             // Updates:
1586             // - `balance -= 1`.
1587             // - `numberBurned += 1`.
1588             //
1589             // We can directly decrement the balance, and increment the number burned.
1590             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1591             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1592 
1593             // Updates:
1594             // - `address` to the last owner.
1595             // - `startTimestamp` to the timestamp of burning.
1596             // - `burned` to `true`.
1597             // - `nextInitialized` to `true`.
1598             _packedOwnerships[tokenId] =
1599                 _addressToUint256(from) |
1600                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1601                 BITMASK_BURNED | 
1602                 BITMASK_NEXT_INITIALIZED;
1603 
1604             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1605             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1606                 uint256 nextTokenId = tokenId + 1;
1607                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1608                 if (_packedOwnerships[nextTokenId] == 0) {
1609                     // If the next slot is within bounds.
1610                     if (nextTokenId != _currentIndex) {
1611                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1612                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1613                     }
1614                 }
1615             }
1616         }
1617 
1618         emit Transfer(from, address(0), tokenId);
1619         _afterTokenTransfers(from, address(0), tokenId, 1);
1620 
1621         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1622         unchecked {
1623             _burnCounter++;
1624         }
1625     }
1626 
1627     /**
1628      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1629      *
1630      * @param from address representing the previous owner of the given token ID
1631      * @param to target address that will receive the tokens
1632      * @param tokenId uint256 ID of the token to be transferred
1633      * @param _data bytes optional data to send along with the call
1634      * @return bool whether the call correctly returned the expected magic value
1635      */
1636     function _checkContractOnERC721Received(
1637         address from,
1638         address to,
1639         uint256 tokenId,
1640         bytes memory _data
1641     ) private returns (bool) {
1642         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1643             bytes4 retval
1644         ) {
1645             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1646         } catch (bytes memory reason) {
1647             if (reason.length == 0) {
1648                 revert TransferToNonERC721ReceiverImplementer();
1649             } else {
1650                 assembly {
1651                     revert(add(32, reason), mload(reason))
1652                 }
1653             }
1654         }
1655     }
1656 
1657     /**
1658      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1659      * And also called before burning one token.
1660      *
1661      * startTokenId - the first token id to be transferred
1662      * quantity - the amount to be transferred
1663      *
1664      * Calling conditions:
1665      *
1666      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1667      * transferred to `to`.
1668      * - When `from` is zero, `tokenId` will be minted for `to`.
1669      * - When `to` is zero, `tokenId` will be burned by `from`.
1670      * - `from` and `to` are never both zero.
1671      */
1672     function _beforeTokenTransfers(
1673         address from,
1674         address to,
1675         uint256 startTokenId,
1676         uint256 quantity
1677     ) internal virtual {}
1678 
1679     /**
1680      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1681      * minting.
1682      * And also called after one token has been burned.
1683      *
1684      * startTokenId - the first token id to be transferred
1685      * quantity - the amount to be transferred
1686      *
1687      * Calling conditions:
1688      *
1689      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1690      * transferred to `to`.
1691      * - When `from` is zero, `tokenId` has been minted for `to`.
1692      * - When `to` is zero, `tokenId` has been burned by `from`.
1693      * - `from` and `to` are never both zero.
1694      */
1695     function _afterTokenTransfers(
1696         address from,
1697         address to,
1698         uint256 startTokenId,
1699         uint256 quantity
1700     ) internal virtual {}
1701 
1702     /**
1703      * @dev Returns the message sender (defaults to `msg.sender`).
1704      *
1705      * If you are writing GSN compatible contracts, you need to override this function.
1706      */
1707     function _msgSenderERC721A() internal view virtual returns (address) {
1708         return msg.sender;
1709     }
1710 
1711     /**
1712      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1713      */
1714     function _toString(uint256 value) internal pure returns (string memory ptr) {
1715         assembly {
1716             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1717             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1718             // We will need 1 32-byte word to store the length, 
1719             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1720             ptr := add(mload(0x40), 128)
1721             // Update the free memory pointer to allocate.
1722             mstore(0x40, ptr)
1723 
1724             // Cache the end of the memory to calculate the length later.
1725             let end := ptr
1726 
1727             // We write the string from the rightmost digit to the leftmost digit.
1728             // The following is essentially a do-while loop that also handles the zero case.
1729             // Costs a bit more than early returning for the zero case,
1730             // but cheaper in terms of deployment and overall runtime costs.
1731             for { 
1732                 // Initialize and perform the first pass without check.
1733                 let temp := value
1734                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1735                 ptr := sub(ptr, 1)
1736                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1737                 mstore8(ptr, add(48, mod(temp, 10)))
1738                 temp := div(temp, 10)
1739             } temp { 
1740                 // Keep dividing `temp` until zero.
1741                 temp := div(temp, 10)
1742             } { // Body of the for loop.
1743                 ptr := sub(ptr, 1)
1744                 mstore8(ptr, add(48, mod(temp, 10)))
1745             }
1746             
1747             let length := sub(end, ptr)
1748             // Move the pointer 32 bytes leftwards to make room for the length.
1749             ptr := sub(ptr, 32)
1750             // Store the length.
1751             mstore(ptr, length)
1752         }
1753     }
1754 }
1755 // File: @openzeppelin/contracts/utils/Context.sol
1756 
1757 
1758 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1759 
1760 pragma solidity ^0.8.0;
1761 
1762 /**
1763  * @dev Provides information about the current execution context, including the
1764  * sender of the transaction and its data. While these are generally available
1765  * via msg.sender and msg.data, they should not be accessed in such a direct
1766  * manner, since when dealing with meta-transactions the account sending and
1767  * paying for execution may not be the actual sender (as far as an application
1768  * is concerned).
1769  *
1770  * This contract is only required for intermediate, library-like contracts.
1771  */
1772 abstract contract Context {
1773     function _msgSender() internal view virtual returns (address) {
1774         return msg.sender;
1775     }
1776 
1777     function _msgData() internal view virtual returns (bytes calldata) {
1778         return msg.data;
1779     }
1780 }
1781 
1782 // File: @openzeppelin/contracts/access/AccessControl.sol
1783 
1784 
1785 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
1786 
1787 pragma solidity ^0.8.0;
1788 
1789 
1790 
1791 
1792 
1793 /**
1794  * @dev Contract module that allows children to implement role-based access
1795  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1796  * members except through off-chain means by accessing the contract event logs. Some
1797  * applications may benefit from on-chain enumerability, for those cases see
1798  * {AccessControlEnumerable}.
1799  *
1800  * Roles are referred to by their `bytes32` identifier. These should be exposed
1801  * in the external API and be unique. The best way to achieve this is by
1802  * using `public constant` hash digests:
1803  *
1804  * ```
1805  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1806  * ```
1807  *
1808  * Roles can be used to represent a set of permissions. To restrict access to a
1809  * function call, use {hasRole}:
1810  *
1811  * ```
1812  * function foo() public {
1813  *     require(hasRole(MY_ROLE, msg.sender));
1814  *     ...
1815  * }
1816  * ```
1817  *
1818  * Roles can be granted and revoked dynamically via the {grantRole} and
1819  * {revokeRole} functions. Each role has an associated admin role, and only
1820  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1821  *
1822  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1823  * that only accounts with this role will be able to grant or revoke other
1824  * roles. More complex role relationships can be created by using
1825  * {_setRoleAdmin}.
1826  *
1827  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1828  * grant and revoke this role. Extra precautions should be taken to secure
1829  * accounts that have been granted it.
1830  */
1831 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1832     struct RoleData {
1833         mapping(address => bool) members;
1834         bytes32 adminRole;
1835     }
1836 
1837     mapping(bytes32 => RoleData) private _roles;
1838 
1839     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1840 
1841     /**
1842      * @dev Modifier that checks that an account has a specific role. Reverts
1843      * with a standardized message including the required role.
1844      *
1845      * The format of the revert reason is given by the following regular expression:
1846      *
1847      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1848      *
1849      * _Available since v4.1._
1850      */
1851     modifier onlyRole(bytes32 role) {
1852         _checkRole(role);
1853         _;
1854     }
1855 
1856     /**
1857      * @dev See {IERC165-supportsInterface}.
1858      */
1859     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1860         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1861     }
1862 
1863     /**
1864      * @dev Returns `true` if `account` has been granted `role`.
1865      */
1866     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1867         return _roles[role].members[account];
1868     }
1869 
1870     /**
1871      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1872      * Overriding this function changes the behavior of the {onlyRole} modifier.
1873      *
1874      * Format of the revert message is described in {_checkRole}.
1875      *
1876      * _Available since v4.6._
1877      */
1878     function _checkRole(bytes32 role) internal view virtual {
1879         _checkRole(role, _msgSender());
1880     }
1881 
1882     /**
1883      * @dev Revert with a standard message if `account` is missing `role`.
1884      *
1885      * The format of the revert reason is given by the following regular expression:
1886      *
1887      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1888      */
1889     function _checkRole(bytes32 role, address account) internal view virtual {
1890         if (!hasRole(role, account)) {
1891             revert(
1892                 string(
1893                     abi.encodePacked(
1894                         "AccessControl: account ",
1895                         Strings.toHexString(uint160(account), 20),
1896                         " is missing role ",
1897                         Strings.toHexString(uint256(role), 32)
1898                     )
1899                 )
1900             );
1901         }
1902     }
1903 
1904     /**
1905      * @dev Returns the admin role that controls `role`. See {grantRole} and
1906      * {revokeRole}.
1907      *
1908      * To change a role's admin, use {_setRoleAdmin}.
1909      */
1910     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1911         return _roles[role].adminRole;
1912     }
1913 
1914     /**
1915      * @dev Grants `role` to `account`.
1916      *
1917      * If `account` had not been already granted `role`, emits a {RoleGranted}
1918      * event.
1919      *
1920      * Requirements:
1921      *
1922      * - the caller must have ``role``'s admin role.
1923      *
1924      * May emit a {RoleGranted} event.
1925      */
1926     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1927         _grantRole(role, account);
1928     }
1929 
1930     /**
1931      * @dev Revokes `role` from `account`.
1932      *
1933      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1934      *
1935      * Requirements:
1936      *
1937      * - the caller must have ``role``'s admin role.
1938      *
1939      * May emit a {RoleRevoked} event.
1940      */
1941     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1942         _revokeRole(role, account);
1943     }
1944 
1945     /**
1946      * @dev Revokes `role` from the calling account.
1947      *
1948      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1949      * purpose is to provide a mechanism for accounts to lose their privileges
1950      * if they are compromised (such as when a trusted device is misplaced).
1951      *
1952      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1953      * event.
1954      *
1955      * Requirements:
1956      *
1957      * - the caller must be `account`.
1958      *
1959      * May emit a {RoleRevoked} event.
1960      */
1961     function renounceRole(bytes32 role, address account) public virtual override {
1962         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1963 
1964         _revokeRole(role, account);
1965     }
1966 
1967     /**
1968      * @dev Grants `role` to `account`.
1969      *
1970      * If `account` had not been already granted `role`, emits a {RoleGranted}
1971      * event. Note that unlike {grantRole}, this function doesn't perform any
1972      * checks on the calling account.
1973      *
1974      * May emit a {RoleGranted} event.
1975      *
1976      * [WARNING]
1977      * ====
1978      * This function should only be called from the constructor when setting
1979      * up the initial roles for the system.
1980      *
1981      * Using this function in any other way is effectively circumventing the admin
1982      * system imposed by {AccessControl}.
1983      * ====
1984      *
1985      * NOTE: This function is deprecated in favor of {_grantRole}.
1986      */
1987     function _setupRole(bytes32 role, address account) internal virtual {
1988         _grantRole(role, account);
1989     }
1990 
1991     /**
1992      * @dev Sets `adminRole` as ``role``'s admin role.
1993      *
1994      * Emits a {RoleAdminChanged} event.
1995      */
1996     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1997         bytes32 previousAdminRole = getRoleAdmin(role);
1998         _roles[role].adminRole = adminRole;
1999         emit RoleAdminChanged(role, previousAdminRole, adminRole);
2000     }
2001 
2002     /**
2003      * @dev Grants `role` to `account`.
2004      *
2005      * Internal function without access restriction.
2006      *
2007      * May emit a {RoleGranted} event.
2008      */
2009     function _grantRole(bytes32 role, address account) internal virtual {
2010         if (!hasRole(role, account)) {
2011             _roles[role].members[account] = true;
2012             emit RoleGranted(role, account, _msgSender());
2013         }
2014     }
2015 
2016     /**
2017      * @dev Revokes `role` from `account`.
2018      *
2019      * Internal function without access restriction.
2020      *
2021      * May emit a {RoleRevoked} event.
2022      */
2023     function _revokeRole(bytes32 role, address account) internal virtual {
2024         if (hasRole(role, account)) {
2025             _roles[role].members[account] = false;
2026             emit RoleRevoked(role, account, _msgSender());
2027         }
2028     }
2029 }
2030 
2031 // File: contracts/lib/PaymentSplitterConnector.sol
2032 
2033 
2034 pragma solidity ^0.8.4;
2035 
2036 
2037 
2038 contract PaymentSplitterConnector is AccessControl {
2039     address public PAYMENT_SPLITTER_ADDRESS;
2040     address public PAYMENT_DEFAULT_ADMIN;
2041     address public SPLITTER_ADMIN;
2042     bytes32 private constant SPLITTER_ADMIN_ROLE = keccak256("SPLITTER_ADMIN");
2043 
2044     constructor(address admin, address splitterAddress) {
2045         _setupRole(DEFAULT_ADMIN_ROLE, admin);
2046         _setupRole(SPLITTER_ADMIN_ROLE, admin);
2047 
2048         SPLITTER_ADMIN = admin;
2049         PAYMENT_DEFAULT_ADMIN = admin;
2050         PAYMENT_SPLITTER_ADDRESS = splitterAddress;
2051     }
2052 
2053     modifier onlySplitterAdmin() {
2054         require(
2055             hasRole(SPLITTER_ADMIN_ROLE, msg.sender),
2056             "Splitter: No Splitter Role"
2057         );
2058         _;
2059     }
2060 
2061     modifier onlyDefaultAdmin() {
2062         require(
2063             hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
2064             "Splitter: No Admin Permission"
2065         );
2066         _;
2067     }
2068 
2069     function setSplitterAddress(address _splitterAddress)
2070         public
2071         onlySplitterAdmin
2072     {
2073         PAYMENT_SPLITTER_ADDRESS = _splitterAddress;
2074     }
2075 
2076     function withdraw() public {
2077         address payable recipient = payable(PAYMENT_SPLITTER_ADDRESS);
2078         uint256 balance = address(this).balance;
2079 
2080         Address.sendValue(recipient, balance);
2081     }
2082 
2083     function transferSplitterAdminRole(address admin) public onlyDefaultAdmin {
2084         require(SPLITTER_ADMIN != admin, "Splitter: Should be different");
2085 
2086         grantRole(SPLITTER_ADMIN_ROLE, admin);
2087         revokeRole(SPLITTER_ADMIN_ROLE, SPLITTER_ADMIN);
2088         SPLITTER_ADMIN = admin;
2089     }
2090 
2091     function transferDefaultAdminRole(address admin) public onlyDefaultAdmin {
2092         require(
2093             PAYMENT_DEFAULT_ADMIN != admin,
2094             "Splitter: Should be different"
2095         );
2096 
2097         grantRole(DEFAULT_ADMIN_ROLE, admin);
2098         revokeRole(DEFAULT_ADMIN_ROLE, PAYMENT_DEFAULT_ADMIN);
2099         PAYMENT_DEFAULT_ADMIN = admin;
2100     }
2101 }
2102 
2103 // File: @openzeppelin/contracts/access/Ownable.sol
2104 
2105 
2106 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2107 
2108 pragma solidity ^0.8.0;
2109 
2110 
2111 /**
2112  * @dev Contract module which provides a basic access control mechanism, where
2113  * there is an account (an owner) that can be granted exclusive access to
2114  * specific functions.
2115  *
2116  * By default, the owner account will be the one that deploys the contract. This
2117  * can later be changed with {transferOwnership}.
2118  *
2119  * This module is used through inheritance. It will make available the modifier
2120  * `onlyOwner`, which can be applied to your functions to restrict their use to
2121  * the owner.
2122  */
2123 abstract contract Ownable is Context {
2124     address private _owner;
2125 
2126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2127 
2128     /**
2129      * @dev Initializes the contract setting the deployer as the initial owner.
2130      */
2131     constructor() {
2132         _transferOwnership(_msgSender());
2133     }
2134 
2135     /**
2136      * @dev Throws if called by any account other than the owner.
2137      */
2138     modifier onlyOwner() {
2139         _checkOwner();
2140         _;
2141     }
2142 
2143     /**
2144      * @dev Returns the address of the current owner.
2145      */
2146     function owner() public view virtual returns (address) {
2147         return _owner;
2148     }
2149 
2150     /**
2151      * @dev Throws if the sender is not the owner.
2152      */
2153     function _checkOwner() internal view virtual {
2154         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2155     }
2156 
2157     /**
2158      * @dev Leaves the contract without owner. It will not be possible to call
2159      * `onlyOwner` functions anymore. Can only be called by the current owner.
2160      *
2161      * NOTE: Renouncing ownership will leave the contract without an owner,
2162      * thereby removing any functionality that is only available to the owner.
2163      */
2164     function renounceOwnership() public virtual onlyOwner {
2165         _transferOwnership(address(0));
2166     }
2167 
2168     /**
2169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2170      * Can only be called by the current owner.
2171      */
2172     function transferOwnership(address newOwner) public virtual onlyOwner {
2173         require(newOwner != address(0), "Ownable: new owner is the zero address");
2174         _transferOwnership(newOwner);
2175     }
2176 
2177     /**
2178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2179      * Internal function without access restriction.
2180      */
2181     function _transferOwnership(address newOwner) internal virtual {
2182         address oldOwner = _owner;
2183         _owner = newOwner;
2184         emit OwnershipTransferred(oldOwner, newOwner);
2185     }
2186 }
2187 
2188 // File: contracts/lib/MintStageWithReset.sol
2189 
2190 
2191 pragma solidity ^0.8.4;
2192 
2193 
2194 
2195 error InvalidMintAmount();
2196 error InvalidDuration();
2197 error NotOpenMint();
2198 error ReachedMintStageLimit();
2199 error ReachedMintWalletLimit();
2200 error NotWhitelisted();
2201 error NotEnoughPayment();
2202 
2203 contract MintStageWithReset is Ownable {
2204     struct Stage {
2205         uint256 id;
2206         uint256 totalLimit;
2207         uint256 walletLimit;
2208         uint256 rate;
2209         uint256 walletLimitCounter;
2210         uint256 openingTime;
2211         uint256 closingTime;
2212         bytes32 whitelistRoot;
2213         bool isPublic;
2214     }
2215 
2216     Stage public currentStage;
2217 
2218     mapping(uint256 => mapping(address => uint256)) public walletMintCount;
2219 
2220     uint256 private constant BATCH_LIMIT = 10000;
2221 
2222     event MintStageUpdated(
2223         uint256 indexed _stage,
2224         uint256 _stageLimit,
2225         uint256 _stageLimitPerWallet,
2226         uint256 _rate,
2227         uint256 _openingTime,
2228         uint256 _closingTIme
2229     );
2230 
2231     function setMintStage(
2232         uint256 _stage,
2233         uint256 _stageLimit,
2234         uint256 _stageLimitPerWallet,
2235         uint256 _rate,
2236         uint256 _openingTime,
2237         uint256 _closingTime,
2238         bytes32 _whitelistMerkleRoot,
2239         bool _isPublic,
2240         bool _resetClaimCounter
2241     ) public onlyOwner {
2242         if (_openingTime > _closingTime) {
2243             revert InvalidDuration();
2244         }
2245 
2246         uint256 currentLimitWalletPerCounter = currentStage.walletLimitCounter;
2247 
2248         if (_resetClaimCounter) {
2249             currentLimitWalletPerCounter = currentLimitWalletPerCounter + 1;
2250         }
2251 
2252         currentStage = Stage(
2253             _stage,
2254             _stageLimit,
2255             _stageLimitPerWallet,
2256             _rate,
2257             currentLimitWalletPerCounter,
2258             _openingTime,
2259             _closingTime,
2260             _whitelistMerkleRoot,
2261             _isPublic
2262         );
2263 
2264         emit MintStageUpdated(
2265             _stage,
2266             _stageLimit,
2267             _stageLimitPerWallet,
2268             _rate,
2269             _openingTime,
2270             _closingTime
2271         );
2272     }
2273 
2274     function _verifyMint(
2275         bytes32[] calldata _merkleProof,
2276         uint256 _mintAmount,
2277         uint256 currentMintedCount,
2278         uint256 discount
2279     ) internal {
2280         address sender = msg.sender;
2281         uint256 sentAmount = msg.value;
2282 
2283         if (_mintAmount == 0 || _mintAmount > BATCH_LIMIT) {
2284             revert InvalidMintAmount();
2285         }
2286 
2287         if (!isStageOpen()) {
2288             revert NotOpenMint();
2289         }
2290 
2291         if (currentMintedCount + _mintAmount > currentStage.totalLimit) {
2292             revert ReachedMintStageLimit();
2293         }
2294 
2295         uint256 mintCount = walletMintCount[currentStage.walletLimitCounter][
2296             sender
2297         ];
2298         if (
2299             currentStage.walletLimit > 0 &&
2300             mintCount + _mintAmount > currentStage.walletLimit
2301         ) {
2302             revert ReachedMintWalletLimit();
2303         }
2304 
2305         if (!currentStage.isPublic) {
2306             bytes32 leaf = keccak256(abi.encodePacked(sender));
2307 
2308             if (
2309                 !MerkleProof.verify(
2310                     _merkleProof,
2311                     currentStage.whitelistRoot,
2312                     leaf
2313                 )
2314             ) {
2315                 revert NotWhitelisted();
2316             }
2317         }
2318 
2319         uint256 requiredPayment = _mintAmount * (currentStage.rate - discount);
2320         if (sentAmount < requiredPayment) {
2321             revert NotEnoughPayment();
2322         }
2323     }
2324 
2325     function isStageOpen() public view returns (bool) {
2326         return
2327             block.timestamp >= currentStage.openingTime &&
2328             block.timestamp <= currentStage.closingTime;
2329     }
2330 
2331     function _updateWalletMintCount(address sender, uint256 _mintAmount)
2332         internal
2333     {
2334         uint256 mintCount = walletMintCount[currentStage.walletLimitCounter][
2335             sender
2336         ];
2337         walletMintCount[currentStage.walletLimitCounter][sender] =
2338             mintCount +
2339             _mintAmount;
2340     }
2341 }
2342 
2343 // File: contracts/Appreciators.sol
2344 
2345 
2346 pragma solidity ^0.8.4;
2347 
2348 
2349 
2350 
2351 
2352 error TokenSupplyExceeded();
2353 error BatchLengthMismatch();
2354 
2355 contract Appreciators is
2356     PaymentSplitterConnector,
2357     ERC721A,
2358     Ownable,
2359     MintStageWithReset
2360 {
2361     uint256 public constant TOKEN_SUPPLY_LIMIT = 10000;
2362     string public baseExtension = ".json";
2363     string public baseURI = "";
2364 
2365     constructor(address splitterAdmin, address splitterAddress)
2366         ERC721A("Appreciators", "APR")
2367         PaymentSplitterConnector(splitterAdmin, splitterAddress)
2368     {}
2369 
2370     function batchAirdrop(
2371         address[] calldata recipients,
2372         uint256[] calldata quantity
2373     ) public onlyOwner {
2374         if (recipients.length != quantity.length) {
2375             revert BatchLengthMismatch();
2376         }
2377 
2378         for (uint256 i; i < recipients.length; ++i) {
2379             if ((_totalMinted() + quantity[i]) > TOKEN_SUPPLY_LIMIT) {
2380                 revert TokenSupplyExceeded();
2381             }
2382 
2383             _safeMint(recipients[i], quantity[i]);
2384         }
2385     }
2386 
2387     function mint(bytes32[] calldata merkleProof, uint256 quantity)
2388         public
2389         payable
2390     {
2391         _verifyMint(merkleProof, quantity, _totalMinted(), 0);
2392         _updateWalletMintCount(msg.sender, quantity);
2393         _safeMint(msg.sender, quantity);
2394     }
2395 
2396     function burn(uint256 tokenId) public {
2397         _burn(tokenId, true);
2398     }
2399 
2400     function supportsInterface(bytes4 interfaceId)
2401         public
2402         view
2403         override(ERC721A, AccessControl)
2404         returns (bool)
2405     {
2406         return super.supportsInterface(interfaceId);
2407     }
2408 
2409     function tokenURI(uint256 tokenId)
2410         public
2411         view
2412         override(ERC721A)
2413         returns (string memory)
2414     {
2415         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2416 
2417         return
2418             bytes(baseURI).length > 0
2419                 ? string(
2420                     abi.encodePacked(baseURI, _toString(tokenId), baseExtension)
2421                 )
2422                 : baseURI;
2423     }
2424 
2425     function setBaseURI(string memory _baseURI) public onlyOwner {
2426         baseURI = _baseURI;
2427     }
2428 
2429     function setBaseExtension(string memory extension) public onlyOwner {
2430         baseExtension = extension;
2431     }
2432 
2433     function _startTokenId() internal view virtual override returns (uint256) {
2434         return 1;
2435     }
2436 }