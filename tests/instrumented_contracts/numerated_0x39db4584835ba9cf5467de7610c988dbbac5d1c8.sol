1 // File: EIP2981Royalties/IERC2981Royalties.sol
2 
3 
4 pragma solidity 0.8.7;
5 
6 /// @title IERC2981Royalties
7 /// @dev Interface for the ERC2981 - Token Royalty standard
8 interface IERC2981Royalties {
9     /// @notice Called with the sale price to determine how much royalty
10     //          is owed and to whom.
11     /// @param _tokenId - the NFT asset queried for royalty information
12     /// @param _value - the sale price of the NFT asset specified by _tokenId
13     /// @return _receiver - address of who should be sent the royalty payment
14     /// @return _royaltyAmount - the royalty payment amount for value sale price
15     function royaltyInfo(uint256 _tokenId, uint256 _value)
16         external
17         view
18         returns (address _receiver, uint256 _royaltyAmount);
19 }
20 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
21 
22 
23 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev These functions deal with verification of Merkle Tree proofs.
29  *
30  * The proofs can be generated using the JavaScript library
31  * https://github.com/miguelmota/merkletreejs[merkletreejs].
32  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
33  *
34  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
35  *
36  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
37  * hashing, or use a hash function other than keccak256 for hashing leaves.
38  * This is because the concatenation of a sorted pair of internal nodes in
39  * the merkle tree could be reinterpreted as a leaf value.
40  */
41 library MerkleProof {
42     /**
43      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
44      * defined by `root`. For this, a `proof` must be provided, containing
45      * sibling hashes on the branch from the leaf to the root of the tree. Each
46      * pair of leaves and each pair of pre-images are assumed to be sorted.
47      */
48     function verify(
49         bytes32[] memory proof,
50         bytes32 root,
51         bytes32 leaf
52     ) internal pure returns (bool) {
53         return processProof(proof, leaf) == root;
54     }
55 
56     /**
57      * @dev Calldata version of {verify}
58      *
59      * _Available since v4.7._
60      */
61     function verifyCalldata(
62         bytes32[] calldata proof,
63         bytes32 root,
64         bytes32 leaf
65     ) internal pure returns (bool) {
66         return processProofCalldata(proof, leaf) == root;
67     }
68 
69     /**
70      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
71      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
72      * hash matches the root of the tree. When processing the proof, the pairs
73      * of leafs & pre-images are assumed to be sorted.
74      *
75      * _Available since v4.4._
76      */
77     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
78         bytes32 computedHash = leaf;
79         for (uint256 i = 0; i < proof.length; i++) {
80             computedHash = _hashPair(computedHash, proof[i]);
81         }
82         return computedHash;
83     }
84 
85     /**
86      * @dev Calldata version of {processProof}
87      *
88      * _Available since v4.7._
89      */
90     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
91         bytes32 computedHash = leaf;
92         for (uint256 i = 0; i < proof.length; i++) {
93             computedHash = _hashPair(computedHash, proof[i]);
94         }
95         return computedHash;
96     }
97 
98     /**
99      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
100      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
101      *
102      * _Available since v4.7._
103      */
104     function multiProofVerify(
105         bytes32[] memory proof,
106         bool[] memory proofFlags,
107         bytes32 root,
108         bytes32[] memory leaves
109     ) internal pure returns (bool) {
110         return processMultiProof(proof, proofFlags, leaves) == root;
111     }
112 
113     /**
114      * @dev Calldata version of {multiProofVerify}
115      *
116      * _Available since v4.7._
117      */
118     function multiProofVerifyCalldata(
119         bytes32[] calldata proof,
120         bool[] calldata proofFlags,
121         bytes32 root,
122         bytes32[] memory leaves
123     ) internal pure returns (bool) {
124         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
125     }
126 
127     /**
128      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
129      * consuming from one or the other at each step according to the instructions given by
130      * `proofFlags`.
131      *
132      * _Available since v4.7._
133      */
134     function processMultiProof(
135         bytes32[] memory proof,
136         bool[] memory proofFlags,
137         bytes32[] memory leaves
138     ) internal pure returns (bytes32 merkleRoot) {
139         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
140         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
141         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
142         // the merkle tree.
143         uint256 leavesLen = leaves.length;
144         uint256 totalHashes = proofFlags.length;
145 
146         // Check proof validity.
147         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
148 
149         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
150         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
151         bytes32[] memory hashes = new bytes32[](totalHashes);
152         uint256 leafPos = 0;
153         uint256 hashPos = 0;
154         uint256 proofPos = 0;
155         // At each step, we compute the next hash using two values:
156         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
157         //   get the next hash.
158         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
159         //   `proof` array.
160         for (uint256 i = 0; i < totalHashes; i++) {
161             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
162             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
163             hashes[i] = _hashPair(a, b);
164         }
165 
166         if (totalHashes > 0) {
167             return hashes[totalHashes - 1];
168         } else if (leavesLen > 0) {
169             return leaves[0];
170         } else {
171             return proof[0];
172         }
173     }
174 
175     /**
176      * @dev Calldata version of {processMultiProof}
177      *
178      * _Available since v4.7._
179      */
180     function processMultiProofCalldata(
181         bytes32[] calldata proof,
182         bool[] calldata proofFlags,
183         bytes32[] memory leaves
184     ) internal pure returns (bytes32 merkleRoot) {
185         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
186         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
187         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
188         // the merkle tree.
189         uint256 leavesLen = leaves.length;
190         uint256 totalHashes = proofFlags.length;
191 
192         // Check proof validity.
193         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
194 
195         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
196         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
197         bytes32[] memory hashes = new bytes32[](totalHashes);
198         uint256 leafPos = 0;
199         uint256 hashPos = 0;
200         uint256 proofPos = 0;
201         // At each step, we compute the next hash using two values:
202         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
203         //   get the next hash.
204         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
205         //   `proof` array.
206         for (uint256 i = 0; i < totalHashes; i++) {
207             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
208             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
209             hashes[i] = _hashPair(a, b);
210         }
211 
212         if (totalHashes > 0) {
213             return hashes[totalHashes - 1];
214         } else if (leavesLen > 0) {
215             return leaves[0];
216         } else {
217             return proof[0];
218         }
219     }
220 
221     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
222         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
223     }
224 
225     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
226         /// @solidity memory-safe-assembly
227         assembly {
228             mstore(0x00, a)
229             mstore(0x20, b)
230             value := keccak256(0x00, 0x40)
231         }
232     }
233 }
234 
235 // File: @openzeppelin/contracts/utils/Counters.sol
236 
237 
238 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 /**
243  * @title Counters
244  * @author Matt Condon (@shrugs)
245  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
246  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
247  *
248  * Include with `using Counters for Counters.Counter;`
249  */
250 library Counters {
251     struct Counter {
252         // This variable should never be directly accessed by users of the library: interactions must be restricted to
253         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
254         // this feature: see https://github.com/ethereum/solidity/issues/4637
255         uint256 _value; // default: 0
256     }
257 
258     function current(Counter storage counter) internal view returns (uint256) {
259         return counter._value;
260     }
261 
262     function increment(Counter storage counter) internal {
263         unchecked {
264             counter._value += 1;
265         }
266     }
267 
268     function decrement(Counter storage counter) internal {
269         uint256 value = counter._value;
270         require(value > 0, "Counter: decrement overflow");
271         unchecked {
272             counter._value = value - 1;
273         }
274     }
275 
276     function reset(Counter storage counter) internal {
277         counter._value = 0;
278     }
279 }
280 
281 // File: @openzeppelin/contracts/access/IAccessControl.sol
282 
283 
284 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
285 
286 pragma solidity ^0.8.0;
287 
288 /**
289  * @dev External interface of AccessControl declared to support ERC165 detection.
290  */
291 interface IAccessControl {
292     /**
293      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
294      *
295      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
296      * {RoleAdminChanged} not being emitted signaling this.
297      *
298      * _Available since v3.1._
299      */
300     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
301 
302     /**
303      * @dev Emitted when `account` is granted `role`.
304      *
305      * `sender` is the account that originated the contract call, an admin role
306      * bearer except when using {AccessControl-_setupRole}.
307      */
308     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
309 
310     /**
311      * @dev Emitted when `account` is revoked `role`.
312      *
313      * `sender` is the account that originated the contract call:
314      *   - if using `revokeRole`, it is the admin role bearer
315      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
316      */
317     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
318 
319     /**
320      * @dev Returns `true` if `account` has been granted `role`.
321      */
322     function hasRole(bytes32 role, address account) external view returns (bool);
323 
324     /**
325      * @dev Returns the admin role that controls `role`. See {grantRole} and
326      * {revokeRole}.
327      *
328      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
329      */
330     function getRoleAdmin(bytes32 role) external view returns (bytes32);
331 
332     /**
333      * @dev Grants `role` to `account`.
334      *
335      * If `account` had not been already granted `role`, emits a {RoleGranted}
336      * event.
337      *
338      * Requirements:
339      *
340      * - the caller must have ``role``'s admin role.
341      */
342     function grantRole(bytes32 role, address account) external;
343 
344     /**
345      * @dev Revokes `role` from `account`.
346      *
347      * If `account` had been granted `role`, emits a {RoleRevoked} event.
348      *
349      * Requirements:
350      *
351      * - the caller must have ``role``'s admin role.
352      */
353     function revokeRole(bytes32 role, address account) external;
354 
355     /**
356      * @dev Revokes `role` from the calling account.
357      *
358      * Roles are often managed via {grantRole} and {revokeRole}: this function's
359      * purpose is to provide a mechanism for accounts to lose their privileges
360      * if they are compromised (such as when a trusted device is misplaced).
361      *
362      * If the calling account had been granted `role`, emits a {RoleRevoked}
363      * event.
364      *
365      * Requirements:
366      *
367      * - the caller must be `account`.
368      */
369     function renounceRole(bytes32 role, address account) external;
370 }
371 
372 // File: @openzeppelin/contracts/utils/Strings.sol
373 
374 
375 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 /**
380  * @dev String operations.
381  */
382 library Strings {
383     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
384     uint8 private constant _ADDRESS_LENGTH = 20;
385 
386     /**
387      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
388      */
389     function toString(uint256 value) internal pure returns (string memory) {
390         // Inspired by OraclizeAPI's implementation - MIT licence
391         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
392 
393         if (value == 0) {
394             return "0";
395         }
396         uint256 temp = value;
397         uint256 digits;
398         while (temp != 0) {
399             digits++;
400             temp /= 10;
401         }
402         bytes memory buffer = new bytes(digits);
403         while (value != 0) {
404             digits -= 1;
405             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
406             value /= 10;
407         }
408         return string(buffer);
409     }
410 
411     /**
412      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
413      */
414     function toHexString(uint256 value) internal pure returns (string memory) {
415         if (value == 0) {
416             return "0x00";
417         }
418         uint256 temp = value;
419         uint256 length = 0;
420         while (temp != 0) {
421             length++;
422             temp >>= 8;
423         }
424         return toHexString(value, length);
425     }
426 
427     /**
428      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
429      */
430     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
431         bytes memory buffer = new bytes(2 * length + 2);
432         buffer[0] = "0";
433         buffer[1] = "x";
434         for (uint256 i = 2 * length + 1; i > 1; --i) {
435             buffer[i] = _HEX_SYMBOLS[value & 0xf];
436             value >>= 4;
437         }
438         require(value == 0, "Strings: hex length insufficient");
439         return string(buffer);
440     }
441 
442     /**
443      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
444      */
445     function toHexString(address addr) internal pure returns (string memory) {
446         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
447     }
448 }
449 
450 // File: @openzeppelin/contracts/utils/Context.sol
451 
452 
453 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
454 
455 pragma solidity ^0.8.0;
456 
457 /**
458  * @dev Provides information about the current execution context, including the
459  * sender of the transaction and its data. While these are generally available
460  * via msg.sender and msg.data, they should not be accessed in such a direct
461  * manner, since when dealing with meta-transactions the account sending and
462  * paying for execution may not be the actual sender (as far as an application
463  * is concerned).
464  *
465  * This contract is only required for intermediate, library-like contracts.
466  */
467 abstract contract Context {
468     function _msgSender() internal view virtual returns (address) {
469         return msg.sender;
470     }
471 
472     function _msgData() internal view virtual returns (bytes calldata) {
473         return msg.data;
474     }
475 }
476 
477 // File: @openzeppelin/contracts/utils/Address.sol
478 
479 
480 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
481 
482 pragma solidity ^0.8.1;
483 
484 /**
485  * @dev Collection of functions related to the address type
486  */
487 library Address {
488     /**
489      * @dev Returns true if `account` is a contract.
490      *
491      * [IMPORTANT]
492      * ====
493      * It is unsafe to assume that an address for which this function returns
494      * false is an externally-owned account (EOA) and not a contract.
495      *
496      * Among others, `isContract` will return false for the following
497      * types of addresses:
498      *
499      *  - an externally-owned account
500      *  - a contract in construction
501      *  - an address where a contract will be created
502      *  - an address where a contract lived, but was destroyed
503      * ====
504      *
505      * [IMPORTANT]
506      * ====
507      * You shouldn't rely on `isContract` to protect against flash loan attacks!
508      *
509      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
510      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
511      * constructor.
512      * ====
513      */
514     function isContract(address account) internal view returns (bool) {
515         // This method relies on extcodesize/address.code.length, which returns 0
516         // for contracts in construction, since the code is only stored at the end
517         // of the constructor execution.
518 
519         return account.code.length > 0;
520     }
521 
522     /**
523      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
524      * `recipient`, forwarding all available gas and reverting on errors.
525      *
526      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
527      * of certain opcodes, possibly making contracts go over the 2300 gas limit
528      * imposed by `transfer`, making them unable to receive funds via
529      * `transfer`. {sendValue} removes this limitation.
530      *
531      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
532      *
533      * IMPORTANT: because control is transferred to `recipient`, care must be
534      * taken to not create reentrancy vulnerabilities. Consider using
535      * {ReentrancyGuard} or the
536      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
537      */
538     function sendValue(address payable recipient, uint256 amount) internal {
539         require(address(this).balance >= amount, "Address: insufficient balance");
540 
541         (bool success, ) = recipient.call{value: amount}("");
542         require(success, "Address: unable to send value, recipient may have reverted");
543     }
544 
545     /**
546      * @dev Performs a Solidity function call using a low level `call`. A
547      * plain `call` is an unsafe replacement for a function call: use this
548      * function instead.
549      *
550      * If `target` reverts with a revert reason, it is bubbled up by this
551      * function (like regular Solidity function calls).
552      *
553      * Returns the raw returned data. To convert to the expected return value,
554      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
555      *
556      * Requirements:
557      *
558      * - `target` must be a contract.
559      * - calling `target` with `data` must not revert.
560      *
561      * _Available since v3.1._
562      */
563     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
564         return functionCall(target, data, "Address: low-level call failed");
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
569      * `errorMessage` as a fallback revert reason when `target` reverts.
570      *
571      * _Available since v3.1._
572      */
573     function functionCall(
574         address target,
575         bytes memory data,
576         string memory errorMessage
577     ) internal returns (bytes memory) {
578         return functionCallWithValue(target, data, 0, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but also transferring `value` wei to `target`.
584      *
585      * Requirements:
586      *
587      * - the calling contract must have an ETH balance of at least `value`.
588      * - the called Solidity function must be `payable`.
589      *
590      * _Available since v3.1._
591      */
592     function functionCallWithValue(
593         address target,
594         bytes memory data,
595         uint256 value
596     ) internal returns (bytes memory) {
597         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
602      * with `errorMessage` as a fallback revert reason when `target` reverts.
603      *
604      * _Available since v3.1._
605      */
606     function functionCallWithValue(
607         address target,
608         bytes memory data,
609         uint256 value,
610         string memory errorMessage
611     ) internal returns (bytes memory) {
612         require(address(this).balance >= value, "Address: insufficient balance for call");
613         require(isContract(target), "Address: call to non-contract");
614 
615         (bool success, bytes memory returndata) = target.call{value: value}(data);
616         return verifyCallResult(success, returndata, errorMessage);
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
621      * but performing a static call.
622      *
623      * _Available since v3.3._
624      */
625     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
626         return functionStaticCall(target, data, "Address: low-level static call failed");
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
631      * but performing a static call.
632      *
633      * _Available since v3.3._
634      */
635     function functionStaticCall(
636         address target,
637         bytes memory data,
638         string memory errorMessage
639     ) internal view returns (bytes memory) {
640         require(isContract(target), "Address: static call to non-contract");
641 
642         (bool success, bytes memory returndata) = target.staticcall(data);
643         return verifyCallResult(success, returndata, errorMessage);
644     }
645 
646     /**
647      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
648      * but performing a delegate call.
649      *
650      * _Available since v3.4._
651      */
652     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
653         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
654     }
655 
656     /**
657      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
658      * but performing a delegate call.
659      *
660      * _Available since v3.4._
661      */
662     function functionDelegateCall(
663         address target,
664         bytes memory data,
665         string memory errorMessage
666     ) internal returns (bytes memory) {
667         require(isContract(target), "Address: delegate call to non-contract");
668 
669         (bool success, bytes memory returndata) = target.delegatecall(data);
670         return verifyCallResult(success, returndata, errorMessage);
671     }
672 
673     /**
674      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
675      * revert reason using the provided one.
676      *
677      * _Available since v4.3._
678      */
679     function verifyCallResult(
680         bool success,
681         bytes memory returndata,
682         string memory errorMessage
683     ) internal pure returns (bytes memory) {
684         if (success) {
685             return returndata;
686         } else {
687             // Look for revert reason and bubble it up if present
688             if (returndata.length > 0) {
689                 // The easiest way to bubble the revert reason is using memory via assembly
690                 /// @solidity memory-safe-assembly
691                 assembly {
692                     let returndata_size := mload(returndata)
693                     revert(add(32, returndata), returndata_size)
694                 }
695             } else {
696                 revert(errorMessage);
697             }
698         }
699     }
700 }
701 
702 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
703 
704 
705 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
706 
707 pragma solidity ^0.8.0;
708 
709 /**
710  * @title ERC721 token receiver interface
711  * @dev Interface for any contract that wants to support safeTransfers
712  * from ERC721 asset contracts.
713  */
714 interface IERC721Receiver {
715     /**
716      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
717      * by `operator` from `from`, this function is called.
718      *
719      * It must return its Solidity selector to confirm the token transfer.
720      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
721      *
722      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
723      */
724     function onERC721Received(
725         address operator,
726         address from,
727         uint256 tokenId,
728         bytes calldata data
729     ) external returns (bytes4);
730 }
731 
732 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
733 
734 
735 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
736 
737 pragma solidity ^0.8.0;
738 
739 /**
740  * @dev Interface of the ERC165 standard, as defined in the
741  * https://eips.ethereum.org/EIPS/eip-165[EIP].
742  *
743  * Implementers can declare support of contract interfaces, which can then be
744  * queried by others ({ERC165Checker}).
745  *
746  * For an implementation, see {ERC165}.
747  */
748 interface IERC165 {
749     /**
750      * @dev Returns true if this contract implements the interface defined by
751      * `interfaceId`. See the corresponding
752      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
753      * to learn more about how these ids are created.
754      *
755      * This function call must use less than 30 000 gas.
756      */
757     function supportsInterface(bytes4 interfaceId) external view returns (bool);
758 }
759 
760 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
761 
762 
763 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
764 
765 pragma solidity ^0.8.0;
766 
767 
768 /**
769  * @dev Interface for the NFT Royalty Standard.
770  *
771  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
772  * support for royalty payments across all NFT marketplaces and ecosystem participants.
773  *
774  * _Available since v4.5._
775  */
776 interface IERC2981 is IERC165 {
777     /**
778      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
779      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
780      */
781     function royaltyInfo(uint256 tokenId, uint256 salePrice)
782         external
783         view
784         returns (address receiver, uint256 royaltyAmount);
785 }
786 
787 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
788 
789 
790 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
791 
792 pragma solidity ^0.8.0;
793 
794 
795 /**
796  * @dev Implementation of the {IERC165} interface.
797  *
798  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
799  * for the additional interface id that will be supported. For example:
800  *
801  * ```solidity
802  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
803  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
804  * }
805  * ```
806  *
807  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
808  */
809 abstract contract ERC165 is IERC165 {
810     /**
811      * @dev See {IERC165-supportsInterface}.
812      */
813     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
814         return interfaceId == type(IERC165).interfaceId;
815     }
816 }
817 
818 // File: EIP2981Royalties/ERC2981Base.sol
819 
820 
821 pragma solidity ^0.8.0;
822 
823 
824 
825 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
826 abstract contract ERC2981Base is ERC165, IERC2981Royalties {
827     struct RoyaltyInfo {
828         address recipient;
829         uint24 amount;
830     }
831 
832     /// @inheritdoc	ERC165
833     function supportsInterface(bytes4 interfaceId)
834         public
835         view
836         virtual
837         override
838         returns (bool)
839     {
840         return
841             interfaceId == type(IERC2981Royalties).interfaceId ||
842             super.supportsInterface(interfaceId);
843     }
844 }
845 // File: EIP2981Royalties/ERC2981ContractWideRoyalties.sol
846 
847 
848 pragma solidity ^0.8.0;
849 
850 
851 
852 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
853 /// @dev This implementation has the same royalties for each and every tokens
854 abstract contract ERC2981ContractWideRoyalties is ERC2981Base {
855     RoyaltyInfo private _royalties;
856 
857     /// @dev Sets token royalties
858     /// @param recipient recipient of the royalties
859     /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)
860     function _setRoyalties(address recipient, uint256 value) internal {
861         require(value <= 10000, 'ERC2981Royalties: Too high');
862         _royalties = RoyaltyInfo(recipient, uint24(value));
863     }
864 
865     /// @inheritdoc	IERC2981Royalties
866     function royaltyInfo(uint256, uint256 value)
867         external
868         view
869         override
870         returns (address receiver, uint256 royaltyAmount)
871     {
872         RoyaltyInfo memory royalties = _royalties;
873         receiver = royalties.recipient;
874         royaltyAmount = (value * royalties.amount) / 10000;
875     }
876 }
877 // File: @openzeppelin/contracts/access/AccessControl.sol
878 
879 
880 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
881 
882 pragma solidity ^0.8.0;
883 
884 
885 
886 
887 
888 /**
889  * @dev Contract module that allows children to implement role-based access
890  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
891  * members except through off-chain means by accessing the contract event logs. Some
892  * applications may benefit from on-chain enumerability, for those cases see
893  * {AccessControlEnumerable}.
894  *
895  * Roles are referred to by their `bytes32` identifier. These should be exposed
896  * in the external API and be unique. The best way to achieve this is by
897  * using `public constant` hash digests:
898  *
899  * ```
900  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
901  * ```
902  *
903  * Roles can be used to represent a set of permissions. To restrict access to a
904  * function call, use {hasRole}:
905  *
906  * ```
907  * function foo() public {
908  *     require(hasRole(MY_ROLE, msg.sender));
909  *     ...
910  * }
911  * ```
912  *
913  * Roles can be granted and revoked dynamically via the {grantRole} and
914  * {revokeRole} functions. Each role has an associated admin role, and only
915  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
916  *
917  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
918  * that only accounts with this role will be able to grant or revoke other
919  * roles. More complex role relationships can be created by using
920  * {_setRoleAdmin}.
921  *
922  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
923  * grant and revoke this role. Extra precautions should be taken to secure
924  * accounts that have been granted it.
925  */
926 abstract contract AccessControl is Context, IAccessControl, ERC165 {
927     struct RoleData {
928         mapping(address => bool) members;
929         bytes32 adminRole;
930     }
931 
932     mapping(bytes32 => RoleData) private _roles;
933 
934     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
935 
936     /**
937      * @dev Modifier that checks that an account has a specific role. Reverts
938      * with a standardized message including the required role.
939      *
940      * The format of the revert reason is given by the following regular expression:
941      *
942      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
943      *
944      * _Available since v4.1._
945      */
946     modifier onlyRole(bytes32 role) {
947         _checkRole(role);
948         _;
949     }
950 
951     /**
952      * @dev See {IERC165-supportsInterface}.
953      */
954     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
955         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
956     }
957 
958     /**
959      * @dev Returns `true` if `account` has been granted `role`.
960      */
961     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
962         return _roles[role].members[account];
963     }
964 
965     /**
966      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
967      * Overriding this function changes the behavior of the {onlyRole} modifier.
968      *
969      * Format of the revert message is described in {_checkRole}.
970      *
971      * _Available since v4.6._
972      */
973     function _checkRole(bytes32 role) internal view virtual {
974         _checkRole(role, _msgSender());
975     }
976 
977     /**
978      * @dev Revert with a standard message if `account` is missing `role`.
979      *
980      * The format of the revert reason is given by the following regular expression:
981      *
982      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
983      */
984     function _checkRole(bytes32 role, address account) internal view virtual {
985         if (!hasRole(role, account)) {
986             revert(
987                 string(
988                     abi.encodePacked(
989                         "AccessControl: account ",
990                         Strings.toHexString(uint160(account), 20),
991                         " is missing role ",
992                         Strings.toHexString(uint256(role), 32)
993                     )
994                 )
995             );
996         }
997     }
998 
999     /**
1000      * @dev Returns the admin role that controls `role`. See {grantRole} and
1001      * {revokeRole}.
1002      *
1003      * To change a role's admin, use {_setRoleAdmin}.
1004      */
1005     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1006         return _roles[role].adminRole;
1007     }
1008 
1009     /**
1010      * @dev Grants `role` to `account`.
1011      *
1012      * If `account` had not been already granted `role`, emits a {RoleGranted}
1013      * event.
1014      *
1015      * Requirements:
1016      *
1017      * - the caller must have ``role``'s admin role.
1018      *
1019      * May emit a {RoleGranted} event.
1020      */
1021     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1022         _grantRole(role, account);
1023     }
1024 
1025     /**
1026      * @dev Revokes `role` from `account`.
1027      *
1028      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1029      *
1030      * Requirements:
1031      *
1032      * - the caller must have ``role``'s admin role.
1033      *
1034      * May emit a {RoleRevoked} event.
1035      */
1036     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1037         _revokeRole(role, account);
1038     }
1039 
1040     /**
1041      * @dev Revokes `role` from the calling account.
1042      *
1043      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1044      * purpose is to provide a mechanism for accounts to lose their privileges
1045      * if they are compromised (such as when a trusted device is misplaced).
1046      *
1047      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1048      * event.
1049      *
1050      * Requirements:
1051      *
1052      * - the caller must be `account`.
1053      *
1054      * May emit a {RoleRevoked} event.
1055      */
1056     function renounceRole(bytes32 role, address account) public virtual override {
1057         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1058 
1059         _revokeRole(role, account);
1060     }
1061 
1062     /**
1063      * @dev Grants `role` to `account`.
1064      *
1065      * If `account` had not been already granted `role`, emits a {RoleGranted}
1066      * event. Note that unlike {grantRole}, this function doesn't perform any
1067      * checks on the calling account.
1068      *
1069      * May emit a {RoleGranted} event.
1070      *
1071      * [WARNING]
1072      * ====
1073      * This function should only be called from the constructor when setting
1074      * up the initial roles for the system.
1075      *
1076      * Using this function in any other way is effectively circumventing the admin
1077      * system imposed by {AccessControl}.
1078      * ====
1079      *
1080      * NOTE: This function is deprecated in favor of {_grantRole}.
1081      */
1082     function _setupRole(bytes32 role, address account) internal virtual {
1083         _grantRole(role, account);
1084     }
1085 
1086     /**
1087      * @dev Sets `adminRole` as ``role``'s admin role.
1088      *
1089      * Emits a {RoleAdminChanged} event.
1090      */
1091     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1092         bytes32 previousAdminRole = getRoleAdmin(role);
1093         _roles[role].adminRole = adminRole;
1094         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1095     }
1096 
1097     /**
1098      * @dev Grants `role` to `account`.
1099      *
1100      * Internal function without access restriction.
1101      *
1102      * May emit a {RoleGranted} event.
1103      */
1104     function _grantRole(bytes32 role, address account) internal virtual {
1105         if (!hasRole(role, account)) {
1106             _roles[role].members[account] = true;
1107             emit RoleGranted(role, account, _msgSender());
1108         }
1109     }
1110 
1111     /**
1112      * @dev Revokes `role` from `account`.
1113      *
1114      * Internal function without access restriction.
1115      *
1116      * May emit a {RoleRevoked} event.
1117      */
1118     function _revokeRole(bytes32 role, address account) internal virtual {
1119         if (hasRole(role, account)) {
1120             _roles[role].members[account] = false;
1121             emit RoleRevoked(role, account, _msgSender());
1122         }
1123     }
1124 }
1125 
1126 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1127 
1128 
1129 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1130 
1131 pragma solidity ^0.8.0;
1132 
1133 
1134 /**
1135  * @dev Required interface of an ERC721 compliant contract.
1136  */
1137 interface IERC721 is IERC165 {
1138     /**
1139      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1140      */
1141     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1142 
1143     /**
1144      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1145      */
1146     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1147 
1148     /**
1149      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1150      */
1151     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1152 
1153     /**
1154      * @dev Returns the number of tokens in ``owner``'s account.
1155      */
1156     function balanceOf(address owner) external view returns (uint256 balance);
1157 
1158     /**
1159      * @dev Returns the owner of the `tokenId` token.
1160      *
1161      * Requirements:
1162      *
1163      * - `tokenId` must exist.
1164      */
1165     function ownerOf(uint256 tokenId) external view returns (address owner);
1166 
1167     /**
1168      * @dev Safely transfers `tokenId` token from `from` to `to`.
1169      *
1170      * Requirements:
1171      *
1172      * - `from` cannot be the zero address.
1173      * - `to` cannot be the zero address.
1174      * - `tokenId` token must exist and be owned by `from`.
1175      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1176      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1177      *
1178      * Emits a {Transfer} event.
1179      */
1180     function safeTransferFrom(
1181         address from,
1182         address to,
1183         uint256 tokenId,
1184         bytes calldata data
1185     ) external;
1186 
1187     /**
1188      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1189      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1190      *
1191      * Requirements:
1192      *
1193      * - `from` cannot be the zero address.
1194      * - `to` cannot be the zero address.
1195      * - `tokenId` token must exist and be owned by `from`.
1196      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1197      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1198      *
1199      * Emits a {Transfer} event.
1200      */
1201     function safeTransferFrom(
1202         address from,
1203         address to,
1204         uint256 tokenId
1205     ) external;
1206 
1207     /**
1208      * @dev Transfers `tokenId` token from `from` to `to`.
1209      *
1210      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1211      *
1212      * Requirements:
1213      *
1214      * - `from` cannot be the zero address.
1215      * - `to` cannot be the zero address.
1216      * - `tokenId` token must be owned by `from`.
1217      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1218      *
1219      * Emits a {Transfer} event.
1220      */
1221     function transferFrom(
1222         address from,
1223         address to,
1224         uint256 tokenId
1225     ) external;
1226 
1227     /**
1228      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1229      * The approval is cleared when the token is transferred.
1230      *
1231      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1232      *
1233      * Requirements:
1234      *
1235      * - The caller must own the token or be an approved operator.
1236      * - `tokenId` must exist.
1237      *
1238      * Emits an {Approval} event.
1239      */
1240     function approve(address to, uint256 tokenId) external;
1241 
1242     /**
1243      * @dev Approve or remove `operator` as an operator for the caller.
1244      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1245      *
1246      * Requirements:
1247      *
1248      * - The `operator` cannot be the caller.
1249      *
1250      * Emits an {ApprovalForAll} event.
1251      */
1252     function setApprovalForAll(address operator, bool _approved) external;
1253 
1254     /**
1255      * @dev Returns the account approved for `tokenId` token.
1256      *
1257      * Requirements:
1258      *
1259      * - `tokenId` must exist.
1260      */
1261     function getApproved(uint256 tokenId) external view returns (address operator);
1262 
1263     /**
1264      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1265      *
1266      * See {setApprovalForAll}
1267      */
1268     function isApprovedForAll(address owner, address operator) external view returns (bool);
1269 }
1270 
1271 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1272 
1273 
1274 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1275 
1276 pragma solidity ^0.8.0;
1277 
1278 
1279 /**
1280  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1281  * @dev See https://eips.ethereum.org/EIPS/eip-721
1282  */
1283 interface IERC721Metadata is IERC721 {
1284     /**
1285      * @dev Returns the token collection name.
1286      */
1287     function name() external view returns (string memory);
1288 
1289     /**
1290      * @dev Returns the token collection symbol.
1291      */
1292     function symbol() external view returns (string memory);
1293 
1294     /**
1295      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1296      */
1297     function tokenURI(uint256 tokenId) external view returns (string memory);
1298 }
1299 
1300 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1301 
1302 
1303 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1304 
1305 pragma solidity ^0.8.0;
1306 
1307 
1308 
1309 
1310 
1311 
1312 
1313 
1314 /**
1315  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1316  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1317  * {ERC721Enumerable}.
1318  */
1319 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1320     using Address for address;
1321     using Strings for uint256;
1322 
1323     // Token name
1324     string private _name;
1325 
1326     // Token symbol
1327     string private _symbol;
1328 
1329     // Mapping from token ID to owner address
1330     mapping(uint256 => address) private _owners;
1331 
1332     // Mapping owner address to token count
1333     mapping(address => uint256) private _balances;
1334 
1335     // Mapping from token ID to approved address
1336     mapping(uint256 => address) private _tokenApprovals;
1337 
1338     // Mapping from owner to operator approvals
1339     mapping(address => mapping(address => bool)) private _operatorApprovals;
1340 
1341     /**
1342      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1343      */
1344     constructor(string memory name_, string memory symbol_) {
1345         _name = name_;
1346         _symbol = symbol_;
1347     }
1348 
1349     /**
1350      * @dev See {IERC165-supportsInterface}.
1351      */
1352     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1353         return
1354             interfaceId == type(IERC721).interfaceId ||
1355             interfaceId == type(IERC721Metadata).interfaceId ||
1356             super.supportsInterface(interfaceId);
1357     }
1358 
1359     /**
1360      * @dev See {IERC721-balanceOf}.
1361      */
1362     function balanceOf(address owner) public view virtual override returns (uint256) {
1363         require(owner != address(0), "ERC721: address zero is not a valid owner");
1364         return _balances[owner];
1365     }
1366 
1367     /**
1368      * @dev See {IERC721-ownerOf}.
1369      */
1370     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1371         address owner = _owners[tokenId];
1372         require(owner != address(0), "ERC721: invalid token ID");
1373         return owner;
1374     }
1375 
1376     /**
1377      * @dev See {IERC721Metadata-name}.
1378      */
1379     function name() public view virtual override returns (string memory) {
1380         return _name;
1381     }
1382 
1383     /**
1384      * @dev See {IERC721Metadata-symbol}.
1385      */
1386     function symbol() public view virtual override returns (string memory) {
1387         return _symbol;
1388     }
1389 
1390     /**
1391      * @dev See {IERC721Metadata-tokenURI}.
1392      */
1393     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1394         _requireMinted(tokenId);
1395 
1396         string memory baseURI = _baseURI();
1397         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1398     }
1399 
1400     /**
1401      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1402      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1403      * by default, can be overridden in child contracts.
1404      */
1405     function _baseURI() internal view virtual returns (string memory) {
1406         return "";
1407     }
1408 
1409     /**
1410      * @dev See {IERC721-approve}.
1411      */
1412     function approve(address to, uint256 tokenId) public virtual override {
1413         address owner = ERC721.ownerOf(tokenId);
1414         require(to != owner, "ERC721: approval to current owner");
1415 
1416         require(
1417             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1418             "ERC721: approve caller is not token owner nor approved for all"
1419         );
1420 
1421         _approve(to, tokenId);
1422     }
1423 
1424     /**
1425      * @dev See {IERC721-getApproved}.
1426      */
1427     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1428         _requireMinted(tokenId);
1429 
1430         return _tokenApprovals[tokenId];
1431     }
1432 
1433     /**
1434      * @dev See {IERC721-setApprovalForAll}.
1435      */
1436     function setApprovalForAll(address operator, bool approved) public virtual override {
1437         _setApprovalForAll(_msgSender(), operator, approved);
1438     }
1439 
1440     /**
1441      * @dev See {IERC721-isApprovedForAll}.
1442      */
1443     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1444         return _operatorApprovals[owner][operator];
1445     }
1446 
1447     /**
1448      * @dev See {IERC721-transferFrom}.
1449      */
1450     function transferFrom(
1451         address from,
1452         address to,
1453         uint256 tokenId
1454     ) public virtual override {
1455         //solhint-disable-next-line max-line-length
1456         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1457 
1458         _transfer(from, to, tokenId);
1459     }
1460 
1461     /**
1462      * @dev See {IERC721-safeTransferFrom}.
1463      */
1464     function safeTransferFrom(
1465         address from,
1466         address to,
1467         uint256 tokenId
1468     ) public virtual override {
1469         safeTransferFrom(from, to, tokenId, "");
1470     }
1471 
1472     /**
1473      * @dev See {IERC721-safeTransferFrom}.
1474      */
1475     function safeTransferFrom(
1476         address from,
1477         address to,
1478         uint256 tokenId,
1479         bytes memory data
1480     ) public virtual override {
1481         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1482         _safeTransfer(from, to, tokenId, data);
1483     }
1484 
1485     /**
1486      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1487      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1488      *
1489      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1490      *
1491      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1492      * implement alternative mechanisms to perform token transfer, such as signature-based.
1493      *
1494      * Requirements:
1495      *
1496      * - `from` cannot be the zero address.
1497      * - `to` cannot be the zero address.
1498      * - `tokenId` token must exist and be owned by `from`.
1499      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1500      *
1501      * Emits a {Transfer} event.
1502      */
1503     function _safeTransfer(
1504         address from,
1505         address to,
1506         uint256 tokenId,
1507         bytes memory data
1508     ) internal virtual {
1509         _transfer(from, to, tokenId);
1510         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1511     }
1512 
1513     /**
1514      * @dev Returns whether `tokenId` exists.
1515      *
1516      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1517      *
1518      * Tokens start existing when they are minted (`_mint`),
1519      * and stop existing when they are burned (`_burn`).
1520      */
1521     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1522         return _owners[tokenId] != address(0);
1523     }
1524 
1525     /**
1526      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1527      *
1528      * Requirements:
1529      *
1530      * - `tokenId` must exist.
1531      */
1532     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1533         address owner = ERC721.ownerOf(tokenId);
1534         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1535     }
1536 
1537     /**
1538      * @dev Safely mints `tokenId` and transfers it to `to`.
1539      *
1540      * Requirements:
1541      *
1542      * - `tokenId` must not exist.
1543      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1544      *
1545      * Emits a {Transfer} event.
1546      */
1547     function _safeMint(address to, uint256 tokenId) internal virtual {
1548         _safeMint(to, tokenId, "");
1549     }
1550 
1551     /**
1552      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1553      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1554      */
1555     function _safeMint(
1556         address to,
1557         uint256 tokenId,
1558         bytes memory data
1559     ) internal virtual {
1560         _mint(to, tokenId);
1561         require(
1562             _checkOnERC721Received(address(0), to, tokenId, data),
1563             "ERC721: transfer to non ERC721Receiver implementer"
1564         );
1565     }
1566 
1567     /**
1568      * @dev Mints `tokenId` and transfers it to `to`.
1569      *
1570      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1571      *
1572      * Requirements:
1573      *
1574      * - `tokenId` must not exist.
1575      * - `to` cannot be the zero address.
1576      *
1577      * Emits a {Transfer} event.
1578      */
1579     function _mint(address to, uint256 tokenId) internal virtual {
1580         require(to != address(0), "ERC721: mint to the zero address");
1581         require(!_exists(tokenId), "ERC721: token already minted");
1582 
1583         _beforeTokenTransfer(address(0), to, tokenId);
1584 
1585         _balances[to] += 1;
1586         _owners[tokenId] = to;
1587 
1588         emit Transfer(address(0), to, tokenId);
1589 
1590         _afterTokenTransfer(address(0), to, tokenId);
1591     }
1592 
1593     /**
1594      * @dev Destroys `tokenId`.
1595      * The approval is cleared when the token is burned.
1596      *
1597      * Requirements:
1598      *
1599      * - `tokenId` must exist.
1600      *
1601      * Emits a {Transfer} event.
1602      */
1603     function _burn(uint256 tokenId) internal virtual {
1604         address owner = ERC721.ownerOf(tokenId);
1605 
1606         _beforeTokenTransfer(owner, address(0), tokenId);
1607 
1608         // Clear approvals
1609         _approve(address(0), tokenId);
1610 
1611         _balances[owner] -= 1;
1612         delete _owners[tokenId];
1613 
1614         emit Transfer(owner, address(0), tokenId);
1615 
1616         _afterTokenTransfer(owner, address(0), tokenId);
1617     }
1618 
1619     /**
1620      * @dev Transfers `tokenId` from `from` to `to`.
1621      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1622      *
1623      * Requirements:
1624      *
1625      * - `to` cannot be the zero address.
1626      * - `tokenId` token must be owned by `from`.
1627      *
1628      * Emits a {Transfer} event.
1629      */
1630     function _transfer(
1631         address from,
1632         address to,
1633         uint256 tokenId
1634     ) internal virtual {
1635         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1636         require(to != address(0), "ERC721: transfer to the zero address");
1637 
1638         _beforeTokenTransfer(from, to, tokenId);
1639 
1640         // Clear approvals from the previous owner
1641         _approve(address(0), tokenId);
1642 
1643         _balances[from] -= 1;
1644         _balances[to] += 1;
1645         _owners[tokenId] = to;
1646 
1647         emit Transfer(from, to, tokenId);
1648 
1649         _afterTokenTransfer(from, to, tokenId);
1650     }
1651 
1652     /**
1653      * @dev Approve `to` to operate on `tokenId`
1654      *
1655      * Emits an {Approval} event.
1656      */
1657     function _approve(address to, uint256 tokenId) internal virtual {
1658         _tokenApprovals[tokenId] = to;
1659         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1660     }
1661 
1662     /**
1663      * @dev Approve `operator` to operate on all of `owner` tokens
1664      *
1665      * Emits an {ApprovalForAll} event.
1666      */
1667     function _setApprovalForAll(
1668         address owner,
1669         address operator,
1670         bool approved
1671     ) internal virtual {
1672         require(owner != operator, "ERC721: approve to caller");
1673         _operatorApprovals[owner][operator] = approved;
1674         emit ApprovalForAll(owner, operator, approved);
1675     }
1676 
1677     /**
1678      * @dev Reverts if the `tokenId` has not been minted yet.
1679      */
1680     function _requireMinted(uint256 tokenId) internal view virtual {
1681         require(_exists(tokenId), "ERC721: invalid token ID");
1682     }
1683 
1684     /**
1685      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1686      * The call is not executed if the target address is not a contract.
1687      *
1688      * @param from address representing the previous owner of the given token ID
1689      * @param to target address that will receive the tokens
1690      * @param tokenId uint256 ID of the token to be transferred
1691      * @param data bytes optional data to send along with the call
1692      * @return bool whether the call correctly returned the expected magic value
1693      */
1694     function _checkOnERC721Received(
1695         address from,
1696         address to,
1697         uint256 tokenId,
1698         bytes memory data
1699     ) private returns (bool) {
1700         if (to.isContract()) {
1701             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1702                 return retval == IERC721Receiver.onERC721Received.selector;
1703             } catch (bytes memory reason) {
1704                 if (reason.length == 0) {
1705                     revert("ERC721: transfer to non ERC721Receiver implementer");
1706                 } else {
1707                     /// @solidity memory-safe-assembly
1708                     assembly {
1709                         revert(add(32, reason), mload(reason))
1710                     }
1711                 }
1712             }
1713         } else {
1714             return true;
1715         }
1716     }
1717 
1718     /**
1719      * @dev Hook that is called before any token transfer. This includes minting
1720      * and burning.
1721      *
1722      * Calling conditions:
1723      *
1724      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1725      * transferred to `to`.
1726      * - When `from` is zero, `tokenId` will be minted for `to`.
1727      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1728      * - `from` and `to` are never both zero.
1729      *
1730      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1731      */
1732     function _beforeTokenTransfer(
1733         address from,
1734         address to,
1735         uint256 tokenId
1736     ) internal virtual {}
1737 
1738     /**
1739      * @dev Hook that is called after any transfer of tokens. This includes
1740      * minting and burning.
1741      *
1742      * Calling conditions:
1743      *
1744      * - when `from` and `to` are both non-zero.
1745      * - `from` and `to` are never both zero.
1746      *
1747      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1748      */
1749     function _afterTokenTransfer(
1750         address from,
1751         address to,
1752         uint256 tokenId
1753     ) internal virtual {}
1754 }
1755 
1756 // File: NFTImpact2022.sol
1757 
1758 
1759 pragma solidity =0.8.7;
1760 
1761 
1762 
1763 
1764 
1765 
1766 
1767 contract NFTImpact2022 is ERC721, ERC2981ContractWideRoyalties, AccessControl {
1768     /*       
1769     This smart contract has been handcrafted by OpenGem for NFT Factory.
1770     OpenGem provides security tools to ensure ownership and immutability of digital assets. We also advise leading organizations by performing audits on their NFT products.
1771     
1772     https://opengem.com
1773     */
1774     using Counters for Counters.Counter;
1775 
1776     mapping(address => bool) public whitelistClaimed;
1777 
1778     string public constant ARTIST_NAME = "Booyasan";
1779     string public constant ARTIST_WALLET_ENS = "BOOYASAN.eth";
1780     address public constant ARTIST_WALLET = 0x3f89AaCF9E1120C9a00F6266F841Ce094c11be4f;
1781     string public constant ARTIST_BIO = "Crypto-geek-artist, Art director, Photographer and TV Motion Designer. Advanced Technician Certificate of Arts Appliqu\xC3\xA9s School, Paris.";
1782     string public constant ARTWORK_NAME = "Natural Intelligence by Booyasan";
1783     string public constant COLLECTION_NAME = "NFT Impact - Natural Intelligence";
1784     string public constant COLLECTION_DESCRIPTION_FR = "\xE2\x80\x9CNatural Intelligence\xE2\x80\x9D en opposition \xC3\xA0 \xE2\x80\x9CArtificial Intelligence\xE2\x80\x9D repr\xC3\xA9sente l'optimisme \xC3\xA9co-technologique. Loin des supers calculateurs, la nature r\xC3\xA9sout \xC3\xA0 sa mani\xC3\xA8re, en temps r\xC3\xA9el, chaque probl\xC3\xA8me. Elle est l'avenir des technologies.";
1785     string public constant COLLECTION_DESCRIPTION_EN = "\xE2\x80\x9CNatural Intelligence\xE2\x80\x9D, in opposition to \xE2\x80\x9CArtificial Intelligence\xE2\x80\x9D, represents the optimism of eco-technologies. Far from super calculators, Nature solves each problem in a unique way, in real time. Somehow, it is the future of technology.";
1786 
1787     string public constant FOR_FETCHING_ONLY =
1788         "https://fetch.opengem.com/nftimpact2022/booyasan/metadata.json";
1789     string public constant PERSISTENT_IPFS_HASH =
1790         "QmVFkzLAPms71M7XkvxfrF9QWYUy1F2R7w6Vkx7pEY6WWH";
1791     string public constant PERSISTENT_ARWEAVE_HASH =
1792         "X_tz-yauSGMNCzxSWzjR0c1ZZZveYONz180o_dRUUa0";
1793     string public constant PERSISTENT_SHA256_HASH_PROVENANCE =
1794         "1f88fdbf1757e2cbb272093bb85f89750510bc9366e433fda4c46d7278016fb6";
1795 
1796     string public txHashImgData;
1797     bool public imgDataLocked = false;
1798 
1799     bool public sales = true;
1800     bool public salesLocked = false;
1801 
1802     bytes32 public merkleRoot;
1803     address public royaltyWallet;
1804     uint96 constant public ROYALTY_PERCENTAGE = 500;
1805 
1806     Counters.Counter private tokenIdCounter;
1807 
1808     event Mint(address minter, uint256 tokenId);
1809     event Data(string imagedata);
1810     event PermanentURI(string _value, uint256 indexed _id);
1811 
1812     bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
1813 
1814     constructor(address _royaltyWallet, bytes32 _merkleRoot) ERC721("NFT Impact - Natural Intelligence", "NFTINI") {
1815         merkleRoot = _merkleRoot;
1816         royaltyWallet = _royaltyWallet;
1817         tokenIdCounter.increment();
1818         _setRoyalties(_royaltyWallet, ROYALTY_PERCENTAGE);
1819         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1820     }
1821 
1822     function toggleSales() public {
1823         require(hasRole(MANAGER_ROLE, msg.sender), "Caller is not a manager");
1824         require(!salesLocked, "Sales locked.");
1825         sales = !sales;
1826     }
1827 
1828     function lockSales() public {
1829         require(hasRole(MANAGER_ROLE, msg.sender), "Caller is not a manager");
1830         require(!salesLocked, "Sales locked.");
1831         sales = false;
1832         salesLocked = true;
1833     }
1834 
1835     function updateMerkleRoot(bytes32 root) public {
1836         require(hasRole(MANAGER_ROLE, msg.sender), "Caller is not a manager");
1837         merkleRoot = root;
1838     }
1839 
1840     function tokenURI(uint256 tokenId)
1841         public
1842         view
1843         override
1844         returns (string memory) 
1845     {
1846         require(
1847             _exists(tokenId),
1848             "ERC721Metadata: URI query for nonexistent token"
1849         );
1850         return FOR_FETCHING_ONLY;
1851     }
1852 
1853     function quantityMinted() public view returns (uint256) {
1854         return tokenIdCounter.current() - 1;
1855     }
1856 
1857     function setImgData(string calldata imagedata) public {
1858         require(hasRole(MANAGER_ROLE, msg.sender), "Caller is not a manager");
1859         emit Data(imagedata);
1860     }
1861 
1862     function setTxHashImgData(string memory txHash) public {
1863         require(hasRole(MANAGER_ROLE, msg.sender), "Caller is not a manager");
1864         require(!imgDataLocked, "Image data locked");
1865         txHashImgData = txHash;
1866         imgDataLocked = true;
1867     }
1868 
1869     function mint(bytes32[] calldata merkle) public {
1870         require(tx.origin == msg.sender, "The caller is another contract"); 
1871         require(sales, "Sales are locked"); 
1872         require(!whitelistClaimed[msg.sender], "This wallet has already claimed.");
1873         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1874         require(MerkleProof.verify(merkle, merkleRoot, leaf), "Incorrect proof.");
1875         
1876         _safeMint(msg.sender, tokenIdCounter.current());
1877 
1878         whitelistClaimed[msg.sender] = true;
1879         emit Mint(msg.sender, tokenIdCounter.current());
1880         emit PermanentURI(FOR_FETCHING_ONLY, tokenIdCounter.current());
1881         tokenIdCounter.increment();
1882     }
1883 
1884     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981Base, AccessControl) returns (bool) {
1885         return super.supportsInterface(interfaceId);
1886     }
1887 }