1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Tree proofs.
11  *
12  * The proofs can be generated using the JavaScript library
13  * https://github.com/miguelmota/merkletreejs[merkletreejs].
14  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
15  *
16  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
17  *
18  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
19  * hashing, or use a hash function other than keccak256 for hashing leaves.
20  * This is because the concatenation of a sorted pair of internal nodes in
21  * the merkle tree could be reinterpreted as a leaf value.
22  */
23 library MerkleProof {
24     /**
25      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
26      * defined by `root`. For this, a `proof` must be provided, containing
27      * sibling hashes on the branch from the leaf to the root of the tree. Each
28      * pair of leaves and each pair of pre-images are assumed to be sorted.
29      */
30     function verify(
31         bytes32[] memory proof,
32         bytes32 root,
33         bytes32 leaf
34     ) internal pure returns (bool) {
35         return processProof(proof, leaf) == root;
36     }
37 
38     /**
39      * @dev Calldata version of {verify}
40      *
41      * _Available since v4.7._
42      */
43     function verifyCalldata(
44         bytes32[] calldata proof,
45         bytes32 root,
46         bytes32 leaf
47     ) internal pure returns (bool) {
48         return processProofCalldata(proof, leaf) == root;
49     }
50 
51     /**
52      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
53      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
54      * hash matches the root of the tree. When processing the proof, the pairs
55      * of leafs & pre-images are assumed to be sorted.
56      *
57      * _Available since v4.4._
58      */
59     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
60         bytes32 computedHash = leaf;
61         for (uint256 i = 0; i < proof.length; i++) {
62             computedHash = _hashPair(computedHash, proof[i]);
63         }
64         return computedHash;
65     }
66 
67     /**
68      * @dev Calldata version of {processProof}
69      *
70      * _Available since v4.7._
71      */
72     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
73         bytes32 computedHash = leaf;
74         for (uint256 i = 0; i < proof.length; i++) {
75             computedHash = _hashPair(computedHash, proof[i]);
76         }
77         return computedHash;
78     }
79 
80     /**
81      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
82      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
83      *
84      * _Available since v4.7._
85      */
86     function multiProofVerify(
87         bytes32[] memory proof,
88         bool[] memory proofFlags,
89         bytes32 root,
90         bytes32[] memory leaves
91     ) internal pure returns (bool) {
92         return processMultiProof(proof, proofFlags, leaves) == root;
93     }
94 
95     /**
96      * @dev Calldata version of {multiProofVerify}
97      *
98      * _Available since v4.7._
99      */
100     function multiProofVerifyCalldata(
101         bytes32[] calldata proof,
102         bool[] calldata proofFlags,
103         bytes32 root,
104         bytes32[] memory leaves
105     ) internal pure returns (bool) {
106         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
107     }
108 
109     /**
110      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
111      * consuming from one or the other at each step according to the instructions given by
112      * `proofFlags`.
113      *
114      * _Available since v4.7._
115      */
116     function processMultiProof(
117         bytes32[] memory proof,
118         bool[] memory proofFlags,
119         bytes32[] memory leaves
120     ) internal pure returns (bytes32 merkleRoot) {
121         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
122         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
123         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
124         // the merkle tree.
125         uint256 leavesLen = leaves.length;
126         uint256 totalHashes = proofFlags.length;
127 
128         // Check proof validity.
129         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
130 
131         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
132         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
133         bytes32[] memory hashes = new bytes32[](totalHashes);
134         uint256 leafPos = 0;
135         uint256 hashPos = 0;
136         uint256 proofPos = 0;
137         // At each step, we compute the next hash using two values:
138         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
139         //   get the next hash.
140         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
141         //   `proof` array.
142         for (uint256 i = 0; i < totalHashes; i++) {
143             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
144             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
145             hashes[i] = _hashPair(a, b);
146         }
147 
148         if (totalHashes > 0) {
149             return hashes[totalHashes - 1];
150         } else if (leavesLen > 0) {
151             return leaves[0];
152         } else {
153             return proof[0];
154         }
155     }
156 
157     /**
158      * @dev Calldata version of {processMultiProof}
159      *
160      * _Available since v4.7._
161      */
162     function processMultiProofCalldata(
163         bytes32[] calldata proof,
164         bool[] calldata proofFlags,
165         bytes32[] memory leaves
166     ) internal pure returns (bytes32 merkleRoot) {
167         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
168         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
169         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
170         // the merkle tree.
171         uint256 leavesLen = leaves.length;
172         uint256 totalHashes = proofFlags.length;
173 
174         // Check proof validity.
175         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
176 
177         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
178         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
179         bytes32[] memory hashes = new bytes32[](totalHashes);
180         uint256 leafPos = 0;
181         uint256 hashPos = 0;
182         uint256 proofPos = 0;
183         // At each step, we compute the next hash using two values:
184         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
185         //   get the next hash.
186         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
187         //   `proof` array.
188         for (uint256 i = 0; i < totalHashes; i++) {
189             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
190             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
191             hashes[i] = _hashPair(a, b);
192         }
193 
194         if (totalHashes > 0) {
195             return hashes[totalHashes - 1];
196         } else if (leavesLen > 0) {
197             return leaves[0];
198         } else {
199             return proof[0];
200         }
201     }
202 
203     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
204         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
205     }
206 
207     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
208         /// @solidity memory-safe-assembly
209         assembly {
210             mstore(0x00, a)
211             mstore(0x20, b)
212             value := keccak256(0x00, 0x40)
213         }
214     }
215 }
216 
217 // File: @openzeppelin/contracts/utils/Strings.sol
218 
219 
220 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @dev String operations.
226  */
227 library Strings {
228     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
229     uint8 private constant _ADDRESS_LENGTH = 20;
230 
231     /**
232      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
233      */
234     function toString(uint256 value) internal pure returns (string memory) {
235         // Inspired by OraclizeAPI's implementation - MIT licence
236         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
237 
238         if (value == 0) {
239             return "0";
240         }
241         uint256 temp = value;
242         uint256 digits;
243         while (temp != 0) {
244             digits++;
245             temp /= 10;
246         }
247         bytes memory buffer = new bytes(digits);
248         while (value != 0) {
249             digits -= 1;
250             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
251             value /= 10;
252         }
253         return string(buffer);
254     }
255 
256     /**
257      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
258      */
259     function toHexString(uint256 value) internal pure returns (string memory) {
260         if (value == 0) {
261             return "0x00";
262         }
263         uint256 temp = value;
264         uint256 length = 0;
265         while (temp != 0) {
266             length++;
267             temp >>= 8;
268         }
269         return toHexString(value, length);
270     }
271 
272     /**
273      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
274      */
275     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
276         bytes memory buffer = new bytes(2 * length + 2);
277         buffer[0] = "0";
278         buffer[1] = "x";
279         for (uint256 i = 2 * length + 1; i > 1; --i) {
280             buffer[i] = _HEX_SYMBOLS[value & 0xf];
281             value >>= 4;
282         }
283         require(value == 0, "Strings: hex length insufficient");
284         return string(buffer);
285     }
286 
287     /**
288      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
289      */
290     function toHexString(address addr) internal pure returns (string memory) {
291         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
292     }
293 }
294 
295 // File: @openzeppelin/contracts/utils/Context.sol
296 
297 
298 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
299 
300 pragma solidity ^0.8.0;
301 
302 /**
303  * @dev Provides information about the current execution context, including the
304  * sender of the transaction and its data. While these are generally available
305  * via msg.sender and msg.data, they should not be accessed in such a direct
306  * manner, since when dealing with meta-transactions the account sending and
307  * paying for execution may not be the actual sender (as far as an application
308  * is concerned).
309  *
310  * This contract is only required for intermediate, library-like contracts.
311  */
312 abstract contract Context {
313     function _msgSender() internal view virtual returns (address) {
314         return msg.sender;
315     }
316 
317     function _msgData() internal view virtual returns (bytes calldata) {
318         return msg.data;
319     }
320 }
321 
322 // File: @openzeppelin/contracts/access/Ownable.sol
323 
324 
325 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 
330 /**
331  * @dev Contract module which provides a basic access control mechanism, where
332  * there is an account (an owner) that can be granted exclusive access to
333  * specific functions.
334  *
335  * By default, the owner account will be the one that deploys the contract. This
336  * can later be changed with {transferOwnership}.
337  *
338  * This module is used through inheritance. It will make available the modifier
339  * `onlyOwner`, which can be applied to your functions to restrict their use to
340  * the owner.
341  */
342 abstract contract Ownable is Context {
343     address private _owner;
344 
345     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
346 
347     /**
348      * @dev Initializes the contract setting the deployer as the initial owner.
349      */
350     constructor() {
351         _transferOwnership(_msgSender());
352     }
353 
354     /**
355      * @dev Throws if called by any account other than the owner.
356      */
357     modifier onlyOwner() {
358         _checkOwner();
359         _;
360     }
361 
362     /**
363      * @dev Returns the address of the current owner.
364      */
365     function owner() public view virtual returns (address) {
366         return _owner;
367     }
368 
369     /**
370      * @dev Throws if the sender is not the owner.
371      */
372     function _checkOwner() internal view virtual {
373         require(owner() == _msgSender(), "Ownable: caller is not the owner");
374     }
375 
376     /**
377      * @dev Leaves the contract without owner. It will not be possible to call
378      * `onlyOwner` functions anymore. Can only be called by the current owner.
379      *
380      * NOTE: Renouncing ownership will leave the contract without an owner,
381      * thereby removing any functionality that is only available to the owner.
382      */
383     function renounceOwnership() public virtual onlyOwner {
384         _transferOwnership(address(0));
385     }
386 
387     /**
388      * @dev Transfers ownership of the contract to a new account (`newOwner`).
389      * Can only be called by the current owner.
390      */
391     function transferOwnership(address newOwner) public virtual onlyOwner {
392         require(newOwner != address(0), "Ownable: new owner is the zero address");
393         _transferOwnership(newOwner);
394     }
395 
396     /**
397      * @dev Transfers ownership of the contract to a new account (`newOwner`).
398      * Internal function without access restriction.
399      */
400     function _transferOwnership(address newOwner) internal virtual {
401         address oldOwner = _owner;
402         _owner = newOwner;
403         emit OwnershipTransferred(oldOwner, newOwner);
404     }
405 }
406 
407 // File: @openzeppelin/contracts/utils/Address.sol
408 
409 
410 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
411 
412 pragma solidity ^0.8.1;
413 
414 /**
415  * @dev Collection of functions related to the address type
416  */
417 library Address {
418     /**
419      * @dev Returns true if `account` is a contract.
420      *
421      * [IMPORTANT]
422      * ====
423      * It is unsafe to assume that an address for which this function returns
424      * false is an externally-owned account (EOA) and not a contract.
425      *
426      * Among others, `isContract` will return false for the following
427      * types of addresses:
428      *
429      *  - an externally-owned account
430      *  - a contract in construction
431      *  - an address where a contract will be created
432      *  - an address where a contract lived, but was destroyed
433      * ====
434      *
435      * [IMPORTANT]
436      * ====
437      * You shouldn't rely on `isContract` to protect against flash loan attacks!
438      *
439      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
440      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
441      * constructor.
442      * ====
443      */
444     function isContract(address account) internal view returns (bool) {
445         // This method relies on extcodesize/address.code.length, which returns 0
446         // for contracts in construction, since the code is only stored at the end
447         // of the constructor execution.
448 
449         return account.code.length > 0;
450     }
451 
452     /**
453      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
454      * `recipient`, forwarding all available gas and reverting on errors.
455      *
456      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
457      * of certain opcodes, possibly making contracts go over the 2300 gas limit
458      * imposed by `transfer`, making them unable to receive funds via
459      * `transfer`. {sendValue} removes this limitation.
460      *
461      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
462      *
463      * IMPORTANT: because control is transferred to `recipient`, care must be
464      * taken to not create reentrancy vulnerabilities. Consider using
465      * {ReentrancyGuard} or the
466      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
467      */
468     function sendValue(address payable recipient, uint256 amount) internal {
469         require(address(this).balance >= amount, "Address: insufficient balance");
470 
471         (bool success, ) = recipient.call{value: amount}("");
472         require(success, "Address: unable to send value, recipient may have reverted");
473     }
474 
475     /**
476      * @dev Performs a Solidity function call using a low level `call`. A
477      * plain `call` is an unsafe replacement for a function call: use this
478      * function instead.
479      *
480      * If `target` reverts with a revert reason, it is bubbled up by this
481      * function (like regular Solidity function calls).
482      *
483      * Returns the raw returned data. To convert to the expected return value,
484      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
485      *
486      * Requirements:
487      *
488      * - `target` must be a contract.
489      * - calling `target` with `data` must not revert.
490      *
491      * _Available since v3.1._
492      */
493     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
494         return functionCall(target, data, "Address: low-level call failed");
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
499      * `errorMessage` as a fallback revert reason when `target` reverts.
500      *
501      * _Available since v3.1._
502      */
503     function functionCall(
504         address target,
505         bytes memory data,
506         string memory errorMessage
507     ) internal returns (bytes memory) {
508         return functionCallWithValue(target, data, 0, errorMessage);
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
513      * but also transferring `value` wei to `target`.
514      *
515      * Requirements:
516      *
517      * - the calling contract must have an ETH balance of at least `value`.
518      * - the called Solidity function must be `payable`.
519      *
520      * _Available since v3.1._
521      */
522     function functionCallWithValue(
523         address target,
524         bytes memory data,
525         uint256 value
526     ) internal returns (bytes memory) {
527         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
532      * with `errorMessage` as a fallback revert reason when `target` reverts.
533      *
534      * _Available since v3.1._
535      */
536     function functionCallWithValue(
537         address target,
538         bytes memory data,
539         uint256 value,
540         string memory errorMessage
541     ) internal returns (bytes memory) {
542         require(address(this).balance >= value, "Address: insufficient balance for call");
543         require(isContract(target), "Address: call to non-contract");
544 
545         (bool success, bytes memory returndata) = target.call{value: value}(data);
546         return verifyCallResult(success, returndata, errorMessage);
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
551      * but performing a static call.
552      *
553      * _Available since v3.3._
554      */
555     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
556         return functionStaticCall(target, data, "Address: low-level static call failed");
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
561      * but performing a static call.
562      *
563      * _Available since v3.3._
564      */
565     function functionStaticCall(
566         address target,
567         bytes memory data,
568         string memory errorMessage
569     ) internal view returns (bytes memory) {
570         require(isContract(target), "Address: static call to non-contract");
571 
572         (bool success, bytes memory returndata) = target.staticcall(data);
573         return verifyCallResult(success, returndata, errorMessage);
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
578      * but performing a delegate call.
579      *
580      * _Available since v3.4._
581      */
582     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
583         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
588      * but performing a delegate call.
589      *
590      * _Available since v3.4._
591      */
592     function functionDelegateCall(
593         address target,
594         bytes memory data,
595         string memory errorMessage
596     ) internal returns (bytes memory) {
597         require(isContract(target), "Address: delegate call to non-contract");
598 
599         (bool success, bytes memory returndata) = target.delegatecall(data);
600         return verifyCallResult(success, returndata, errorMessage);
601     }
602 
603     /**
604      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
605      * revert reason using the provided one.
606      *
607      * _Available since v4.3._
608      */
609     function verifyCallResult(
610         bool success,
611         bytes memory returndata,
612         string memory errorMessage
613     ) internal pure returns (bytes memory) {
614         if (success) {
615             return returndata;
616         } else {
617             // Look for revert reason and bubble it up if present
618             if (returndata.length > 0) {
619                 // The easiest way to bubble the revert reason is using memory via assembly
620                 /// @solidity memory-safe-assembly
621                 assembly {
622                     let returndata_size := mload(returndata)
623                     revert(add(32, returndata), returndata_size)
624                 }
625             } else {
626                 revert(errorMessage);
627             }
628         }
629     }
630 }
631 
632 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
633 
634 
635 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
636 
637 pragma solidity ^0.8.0;
638 
639 /**
640  * @title ERC721 token receiver interface
641  * @dev Interface for any contract that wants to support safeTransfers
642  * from ERC721 asset contracts.
643  */
644 interface IERC721Receiver {
645     /**
646      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
647      * by `operator` from `from`, this function is called.
648      *
649      * It must return its Solidity selector to confirm the token transfer.
650      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
651      *
652      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
653      */
654     function onERC721Received(
655         address operator,
656         address from,
657         uint256 tokenId,
658         bytes calldata data
659     ) external returns (bytes4);
660 }
661 
662 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
663 
664 
665 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 /**
670  * @dev Interface of the ERC165 standard, as defined in the
671  * https://eips.ethereum.org/EIPS/eip-165[EIP].
672  *
673  * Implementers can declare support of contract interfaces, which can then be
674  * queried by others ({ERC165Checker}).
675  *
676  * For an implementation, see {ERC165}.
677  */
678 interface IERC165 {
679     /**
680      * @dev Returns true if this contract implements the interface defined by
681      * `interfaceId`. See the corresponding
682      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
683      * to learn more about how these ids are created.
684      *
685      * This function call must use less than 30 000 gas.
686      */
687     function supportsInterface(bytes4 interfaceId) external view returns (bool);
688 }
689 
690 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
691 
692 
693 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
694 
695 pragma solidity ^0.8.0;
696 
697 
698 /**
699  * @dev Implementation of the {IERC165} interface.
700  *
701  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
702  * for the additional interface id that will be supported. For example:
703  *
704  * ```solidity
705  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
706  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
707  * }
708  * ```
709  *
710  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
711  */
712 abstract contract ERC165 is IERC165 {
713     /**
714      * @dev See {IERC165-supportsInterface}.
715      */
716     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
717         return interfaceId == type(IERC165).interfaceId;
718     }
719 }
720 
721 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
722 
723 
724 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 
729 /**
730  * @dev Required interface of an ERC721 compliant contract.
731  */
732 interface IERC721 is IERC165 {
733     /**
734      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
735      */
736     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
737 
738     /**
739      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
740      */
741     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
742 
743     /**
744      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
745      */
746     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
747 
748     /**
749      * @dev Returns the number of tokens in ``owner``'s account.
750      */
751     function balanceOf(address owner) external view returns (uint256 balance);
752 
753     /**
754      * @dev Returns the owner of the `tokenId` token.
755      *
756      * Requirements:
757      *
758      * - `tokenId` must exist.
759      */
760     function ownerOf(uint256 tokenId) external view returns (address owner);
761 
762     /**
763      * @dev Safely transfers `tokenId` token from `from` to `to`.
764      *
765      * Requirements:
766      *
767      * - `from` cannot be the zero address.
768      * - `to` cannot be the zero address.
769      * - `tokenId` token must exist and be owned by `from`.
770      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
771      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
772      *
773      * Emits a {Transfer} event.
774      */
775     function safeTransferFrom(
776         address from,
777         address to,
778         uint256 tokenId,
779         bytes calldata data
780     ) external;
781 
782     /**
783      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
784      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
785      *
786      * Requirements:
787      *
788      * - `from` cannot be the zero address.
789      * - `to` cannot be the zero address.
790      * - `tokenId` token must exist and be owned by `from`.
791      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
792      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
793      *
794      * Emits a {Transfer} event.
795      */
796     function safeTransferFrom(
797         address from,
798         address to,
799         uint256 tokenId
800     ) external;
801 
802     /**
803      * @dev Transfers `tokenId` token from `from` to `to`.
804      *
805      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
806      *
807      * Requirements:
808      *
809      * - `from` cannot be the zero address.
810      * - `to` cannot be the zero address.
811      * - `tokenId` token must be owned by `from`.
812      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
813      *
814      * Emits a {Transfer} event.
815      */
816     function transferFrom(
817         address from,
818         address to,
819         uint256 tokenId
820     ) external;
821 
822     /**
823      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
824      * The approval is cleared when the token is transferred.
825      *
826      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
827      *
828      * Requirements:
829      *
830      * - The caller must own the token or be an approved operator.
831      * - `tokenId` must exist.
832      *
833      * Emits an {Approval} event.
834      */
835     function approve(address to, uint256 tokenId) external;
836 
837     /**
838      * @dev Approve or remove `operator` as an operator for the caller.
839      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
840      *
841      * Requirements:
842      *
843      * - The `operator` cannot be the caller.
844      *
845      * Emits an {ApprovalForAll} event.
846      */
847     function setApprovalForAll(address operator, bool _approved) external;
848 
849     /**
850      * @dev Returns the account approved for `tokenId` token.
851      *
852      * Requirements:
853      *
854      * - `tokenId` must exist.
855      */
856     function getApproved(uint256 tokenId) external view returns (address operator);
857 
858     /**
859      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
860      *
861      * See {setApprovalForAll}
862      */
863     function isApprovedForAll(address owner, address operator) external view returns (bool);
864 }
865 
866 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
867 
868 
869 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
870 
871 pragma solidity ^0.8.0;
872 
873 
874 /**
875  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
876  * @dev See https://eips.ethereum.org/EIPS/eip-721
877  */
878 interface IERC721Enumerable is IERC721 {
879     /**
880      * @dev Returns the total amount of tokens stored by the contract.
881      */
882     function totalSupply() external view returns (uint256);
883 
884     /**
885      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
886      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
887      */
888     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
889 
890     /**
891      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
892      * Use along with {totalSupply} to enumerate all tokens.
893      */
894     function tokenByIndex(uint256 index) external view returns (uint256);
895 }
896 
897 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
898 
899 
900 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
901 
902 pragma solidity ^0.8.0;
903 
904 
905 /**
906  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
907  * @dev See https://eips.ethereum.org/EIPS/eip-721
908  */
909 interface IERC721Metadata is IERC721 {
910     /**
911      * @dev Returns the token collection name.
912      */
913     function name() external view returns (string memory);
914 
915     /**
916      * @dev Returns the token collection symbol.
917      */
918     function symbol() external view returns (string memory);
919 
920     /**
921      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
922      */
923     function tokenURI(uint256 tokenId) external view returns (string memory);
924 }
925 
926 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
927 
928 
929 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
930 
931 pragma solidity ^0.8.0;
932 
933 
934 
935 
936 
937 
938 
939 
940 /**
941  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
942  * the Metadata extension, but not including the Enumerable extension, which is available separately as
943  * {ERC721Enumerable}.
944  */
945 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
946     using Address for address;
947     using Strings for uint256;
948 
949     // Token name
950     string private _name;
951 
952     // Token symbol
953     string private _symbol;
954 
955     // Mapping from token ID to owner address
956     mapping(uint256 => address) private _owners;
957 
958     // Mapping owner address to token count
959     mapping(address => uint256) private _balances;
960 
961     // Mapping from token ID to approved address
962     mapping(uint256 => address) private _tokenApprovals;
963 
964     // Mapping from owner to operator approvals
965     mapping(address => mapping(address => bool)) private _operatorApprovals;
966 
967     /**
968      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
969      */
970     constructor(string memory name_, string memory symbol_) {
971         _name = name_;
972         _symbol = symbol_;
973     }
974 
975     /**
976      * @dev See {IERC165-supportsInterface}.
977      */
978     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
979         return
980             interfaceId == type(IERC721).interfaceId ||
981             interfaceId == type(IERC721Metadata).interfaceId ||
982             super.supportsInterface(interfaceId);
983     }
984 
985     /**
986      * @dev See {IERC721-balanceOf}.
987      */
988     function balanceOf(address owner) public view virtual override returns (uint256) {
989         require(owner != address(0), "ERC721: address zero is not a valid owner");
990         return _balances[owner];
991     }
992 
993     /**
994      * @dev See {IERC721-ownerOf}.
995      */
996     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
997         address owner = _owners[tokenId];
998         require(owner != address(0), "ERC721: invalid token ID");
999         return owner;
1000     }
1001 
1002     /**
1003      * @dev See {IERC721Metadata-name}.
1004      */
1005     function name() public view virtual override returns (string memory) {
1006         return _name;
1007     }
1008 
1009     /**
1010      * @dev See {IERC721Metadata-symbol}.
1011      */
1012     function symbol() public view virtual override returns (string memory) {
1013         return _symbol;
1014     }
1015 
1016     /**
1017      * @dev See {IERC721Metadata-tokenURI}.
1018      */
1019     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1020         _requireMinted(tokenId);
1021 
1022         string memory baseURI = _baseURI();
1023         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1024     }
1025 
1026     /**
1027      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1028      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1029      * by default, can be overridden in child contracts.
1030      */
1031     function _baseURI() internal view virtual returns (string memory) {
1032         return "";
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-approve}.
1037      */
1038     function approve(address to, uint256 tokenId) public virtual override {
1039         address owner = ERC721.ownerOf(tokenId);
1040         require(to != owner, "ERC721: approval to current owner");
1041 
1042         require(
1043             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1044             "ERC721: approve caller is not token owner nor approved for all"
1045         );
1046 
1047         _approve(to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-getApproved}.
1052      */
1053     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1054         _requireMinted(tokenId);
1055 
1056         return _tokenApprovals[tokenId];
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-setApprovalForAll}.
1061      */
1062     function setApprovalForAll(address operator, bool approved) public virtual override {
1063         _setApprovalForAll(_msgSender(), operator, approved);
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-isApprovedForAll}.
1068      */
1069     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1070         return _operatorApprovals[owner][operator];
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-transferFrom}.
1075      */
1076     function transferFrom(
1077         address from,
1078         address to,
1079         uint256 tokenId
1080     ) public virtual override {
1081         //solhint-disable-next-line max-line-length
1082         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1083 
1084         _transfer(from, to, tokenId);
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-safeTransferFrom}.
1089      */
1090     function safeTransferFrom(
1091         address from,
1092         address to,
1093         uint256 tokenId
1094     ) public virtual override {
1095         safeTransferFrom(from, to, tokenId, "");
1096     }
1097 
1098     /**
1099      * @dev See {IERC721-safeTransferFrom}.
1100      */
1101     function safeTransferFrom(
1102         address from,
1103         address to,
1104         uint256 tokenId,
1105         bytes memory data
1106     ) public virtual override {
1107         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1108         _safeTransfer(from, to, tokenId, data);
1109     }
1110 
1111     /**
1112      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1113      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1114      *
1115      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1116      *
1117      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1118      * implement alternative mechanisms to perform token transfer, such as signature-based.
1119      *
1120      * Requirements:
1121      *
1122      * - `from` cannot be the zero address.
1123      * - `to` cannot be the zero address.
1124      * - `tokenId` token must exist and be owned by `from`.
1125      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function _safeTransfer(
1130         address from,
1131         address to,
1132         uint256 tokenId,
1133         bytes memory data
1134     ) internal virtual {
1135         _transfer(from, to, tokenId);
1136         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1137     }
1138 
1139     /**
1140      * @dev Returns whether `tokenId` exists.
1141      *
1142      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1143      *
1144      * Tokens start existing when they are minted (`_mint`),
1145      * and stop existing when they are burned (`_burn`).
1146      */
1147     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1148         return _owners[tokenId] != address(0);
1149     }
1150 
1151     /**
1152      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1153      *
1154      * Requirements:
1155      *
1156      * - `tokenId` must exist.
1157      */
1158     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1159         address owner = ERC721.ownerOf(tokenId);
1160         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1161     }
1162 
1163     /**
1164      * @dev Safely mints `tokenId` and transfers it to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - `tokenId` must not exist.
1169      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _safeMint(address to, uint256 tokenId) internal virtual {
1174         _safeMint(to, tokenId, "");
1175     }
1176 
1177     /**
1178      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1179      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1180      */
1181     function _safeMint(
1182         address to,
1183         uint256 tokenId,
1184         bytes memory data
1185     ) internal virtual {
1186         _mint(to, tokenId);
1187         require(
1188             _checkOnERC721Received(address(0), to, tokenId, data),
1189             "ERC721: transfer to non ERC721Receiver implementer"
1190         );
1191     }
1192 
1193     /**
1194      * @dev Mints `tokenId` and transfers it to `to`.
1195      *
1196      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1197      *
1198      * Requirements:
1199      *
1200      * - `tokenId` must not exist.
1201      * - `to` cannot be the zero address.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _mint(address to, uint256 tokenId) internal virtual {
1206         require(to != address(0), "ERC721: mint to the zero address");
1207         require(!_exists(tokenId), "ERC721: token already minted");
1208 
1209         _beforeTokenTransfer(address(0), to, tokenId);
1210 
1211         _balances[to] += 1;
1212         _owners[tokenId] = to;
1213 
1214         emit Transfer(address(0), to, tokenId);
1215 
1216         _afterTokenTransfer(address(0), to, tokenId);
1217     }
1218 
1219     /**
1220      * @dev Destroys `tokenId`.
1221      * The approval is cleared when the token is burned.
1222      *
1223      * Requirements:
1224      *
1225      * - `tokenId` must exist.
1226      *
1227      * Emits a {Transfer} event.
1228      */
1229     function _burn(uint256 tokenId) internal virtual {
1230         address owner = ERC721.ownerOf(tokenId);
1231 
1232         _beforeTokenTransfer(owner, address(0), tokenId);
1233 
1234         // Clear approvals
1235         _approve(address(0), tokenId);
1236 
1237         _balances[owner] -= 1;
1238         delete _owners[tokenId];
1239 
1240         emit Transfer(owner, address(0), tokenId);
1241 
1242         _afterTokenTransfer(owner, address(0), tokenId);
1243     }
1244 
1245     /**
1246      * @dev Transfers `tokenId` from `from` to `to`.
1247      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1248      *
1249      * Requirements:
1250      *
1251      * - `to` cannot be the zero address.
1252      * - `tokenId` token must be owned by `from`.
1253      *
1254      * Emits a {Transfer} event.
1255      */
1256     function _transfer(
1257         address from,
1258         address to,
1259         uint256 tokenId
1260     ) internal virtual {
1261         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1262         require(to != address(0), "ERC721: transfer to the zero address");
1263 
1264         _beforeTokenTransfer(from, to, tokenId);
1265 
1266         // Clear approvals from the previous owner
1267         _approve(address(0), tokenId);
1268 
1269         _balances[from] -= 1;
1270         _balances[to] += 1;
1271         _owners[tokenId] = to;
1272 
1273         emit Transfer(from, to, tokenId);
1274 
1275         _afterTokenTransfer(from, to, tokenId);
1276     }
1277 
1278     /**
1279      * @dev Approve `to` to operate on `tokenId`
1280      *
1281      * Emits an {Approval} event.
1282      */
1283     function _approve(address to, uint256 tokenId) internal virtual {
1284         _tokenApprovals[tokenId] = to;
1285         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1286     }
1287 
1288     /**
1289      * @dev Approve `operator` to operate on all of `owner` tokens
1290      *
1291      * Emits an {ApprovalForAll} event.
1292      */
1293     function _setApprovalForAll(
1294         address owner,
1295         address operator,
1296         bool approved
1297     ) internal virtual {
1298         require(owner != operator, "ERC721: approve to caller");
1299         _operatorApprovals[owner][operator] = approved;
1300         emit ApprovalForAll(owner, operator, approved);
1301     }
1302 
1303     /**
1304      * @dev Reverts if the `tokenId` has not been minted yet.
1305      */
1306     function _requireMinted(uint256 tokenId) internal view virtual {
1307         require(_exists(tokenId), "ERC721: invalid token ID");
1308     }
1309 
1310     /**
1311      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1312      * The call is not executed if the target address is not a contract.
1313      *
1314      * @param from address representing the previous owner of the given token ID
1315      * @param to target address that will receive the tokens
1316      * @param tokenId uint256 ID of the token to be transferred
1317      * @param data bytes optional data to send along with the call
1318      * @return bool whether the call correctly returned the expected magic value
1319      */
1320     function _checkOnERC721Received(
1321         address from,
1322         address to,
1323         uint256 tokenId,
1324         bytes memory data
1325     ) private returns (bool) {
1326         if (to.isContract()) {
1327             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1328                 return retval == IERC721Receiver.onERC721Received.selector;
1329             } catch (bytes memory reason) {
1330                 if (reason.length == 0) {
1331                     revert("ERC721: transfer to non ERC721Receiver implementer");
1332                 } else {
1333                     /// @solidity memory-safe-assembly
1334                     assembly {
1335                         revert(add(32, reason), mload(reason))
1336                     }
1337                 }
1338             }
1339         } else {
1340             return true;
1341         }
1342     }
1343 
1344     /**
1345      * @dev Hook that is called before any token transfer. This includes minting
1346      * and burning.
1347      *
1348      * Calling conditions:
1349      *
1350      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1351      * transferred to `to`.
1352      * - When `from` is zero, `tokenId` will be minted for `to`.
1353      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1354      * - `from` and `to` are never both zero.
1355      *
1356      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1357      */
1358     function _beforeTokenTransfer(
1359         address from,
1360         address to,
1361         uint256 tokenId
1362     ) internal virtual {}
1363 
1364     /**
1365      * @dev Hook that is called after any transfer of tokens. This includes
1366      * minting and burning.
1367      *
1368      * Calling conditions:
1369      *
1370      * - when `from` and `to` are both non-zero.
1371      * - `from` and `to` are never both zero.
1372      *
1373      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1374      */
1375     function _afterTokenTransfer(
1376         address from,
1377         address to,
1378         uint256 tokenId
1379     ) internal virtual {}
1380 }
1381 
1382 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1383 
1384 
1385 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1386 
1387 pragma solidity ^0.8.0;
1388 
1389 
1390 
1391 /**
1392  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1393  * enumerability of all the token ids in the contract as well as all token ids owned by each
1394  * account.
1395  */
1396 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1397     // Mapping from owner to list of owned token IDs
1398     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1399 
1400     // Mapping from token ID to index of the owner tokens list
1401     mapping(uint256 => uint256) private _ownedTokensIndex;
1402 
1403     // Array with all token ids, used for enumeration
1404     uint256[] private _allTokens;
1405 
1406     // Mapping from token id to position in the allTokens array
1407     mapping(uint256 => uint256) private _allTokensIndex;
1408 
1409     /**
1410      * @dev See {IERC165-supportsInterface}.
1411      */
1412     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1413         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1414     }
1415 
1416     /**
1417      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1418      */
1419     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1420         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1421         return _ownedTokens[owner][index];
1422     }
1423 
1424     /**
1425      * @dev See {IERC721Enumerable-totalSupply}.
1426      */
1427     function totalSupply() public view virtual override returns (uint256) {
1428         return _allTokens.length;
1429     }
1430 
1431     /**
1432      * @dev See {IERC721Enumerable-tokenByIndex}.
1433      */
1434     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1435         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1436         return _allTokens[index];
1437     }
1438 
1439     /**
1440      * @dev Hook that is called before any token transfer. This includes minting
1441      * and burning.
1442      *
1443      * Calling conditions:
1444      *
1445      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1446      * transferred to `to`.
1447      * - When `from` is zero, `tokenId` will be minted for `to`.
1448      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1449      * - `from` cannot be the zero address.
1450      * - `to` cannot be the zero address.
1451      *
1452      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1453      */
1454     function _beforeTokenTransfer(
1455         address from,
1456         address to,
1457         uint256 tokenId
1458     ) internal virtual override {
1459         super._beforeTokenTransfer(from, to, tokenId);
1460 
1461         if (from == address(0)) {
1462             _addTokenToAllTokensEnumeration(tokenId);
1463         } else if (from != to) {
1464             _removeTokenFromOwnerEnumeration(from, tokenId);
1465         }
1466         if (to == address(0)) {
1467             _removeTokenFromAllTokensEnumeration(tokenId);
1468         } else if (to != from) {
1469             _addTokenToOwnerEnumeration(to, tokenId);
1470         }
1471     }
1472 
1473     /**
1474      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1475      * @param to address representing the new owner of the given token ID
1476      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1477      */
1478     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1479         uint256 length = ERC721.balanceOf(to);
1480         _ownedTokens[to][length] = tokenId;
1481         _ownedTokensIndex[tokenId] = length;
1482     }
1483 
1484     /**
1485      * @dev Private function to add a token to this extension's token tracking data structures.
1486      * @param tokenId uint256 ID of the token to be added to the tokens list
1487      */
1488     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1489         _allTokensIndex[tokenId] = _allTokens.length;
1490         _allTokens.push(tokenId);
1491     }
1492 
1493     /**
1494      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1495      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1496      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1497      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1498      * @param from address representing the previous owner of the given token ID
1499      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1500      */
1501     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1502         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1503         // then delete the last slot (swap and pop).
1504 
1505         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1506         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1507 
1508         // When the token to delete is the last token, the swap operation is unnecessary
1509         if (tokenIndex != lastTokenIndex) {
1510             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1511 
1512             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1513             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1514         }
1515 
1516         // This also deletes the contents at the last position of the array
1517         delete _ownedTokensIndex[tokenId];
1518         delete _ownedTokens[from][lastTokenIndex];
1519     }
1520 
1521     /**
1522      * @dev Private function to remove a token from this extension's token tracking data structures.
1523      * This has O(1) time complexity, but alters the order of the _allTokens array.
1524      * @param tokenId uint256 ID of the token to be removed from the tokens list
1525      */
1526     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1527         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1528         // then delete the last slot (swap and pop).
1529 
1530         uint256 lastTokenIndex = _allTokens.length - 1;
1531         uint256 tokenIndex = _allTokensIndex[tokenId];
1532 
1533         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1534         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1535         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1536         uint256 lastTokenId = _allTokens[lastTokenIndex];
1537 
1538         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1539         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1540 
1541         // This also deletes the contents at the last position of the array
1542         delete _allTokensIndex[tokenId];
1543         _allTokens.pop();
1544     }
1545 }
1546 
1547 // File: contracts/PJPP_Babies.sol
1548 
1549 
1550 
1551 pragma solidity >=0.7.0 <0.9.0;
1552 
1553 
1554 
1555 
1556 
1557 contract PJPP {
1558     function walletOfOwner(address)public view returns (uint256[] memory){}
1559 }
1560 
1561 contract PJPP_Babies is ERC721Enumerable, Ownable {
1562     using Strings for uint256;
1563     string public baseURI;
1564     string public baseExtension = ".json";
1565     string public notRevealedUri;
1566     uint256 public cost = 0.19 ether;
1567     uint256 public maxSupply = 6666;
1568     uint256 public maxSupplyFree = 3333;
1569     uint256 public maxSupplyPaid = 3333;
1570     uint256 public maxLimitPublic = 10;
1571     uint256 public maxWhitelistLimit = 5;
1572     uint256 public totalSupplyFree;
1573     uint256 public totalSupplyPaid;
1574     bool public paused = false;
1575     bool public revealed = false;
1576 
1577     mapping(address => uint256) public whiteListMinted;
1578     mapping(address => uint256) public publicMinted;
1579     mapping(address => uint256) public mintedBalance;
1580     mapping(uint256 => bool) public usedFemaleNfts;
1581     mapping(uint256 => bool) public usedMaleNfts;
1582 
1583     bytes32 public merkleRoot;
1584     bool public publicSale = false;
1585 
1586     PJPP maleOwlsContract = PJPP(0x3598Fff0f78Dd8b497e12a3aD91FeBcFC8F49d9E);
1587     PJPP femaleOwlsContract = PJPP(0xdA74Aeb14546b4272036121AeD3A97515c84F317);
1588 
1589     constructor(
1590         string memory _name,
1591         string memory _symbol
1592     ) ERC721(_name, _symbol) {
1593     }
1594 
1595     function _baseURI() internal view virtual override returns (string memory) {
1596         return baseURI;
1597     }
1598 
1599     function setPublicSale(bool _publicSale) external onlyOwner {
1600         publicSale = _publicSale;
1601     }
1602 
1603     function isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root)
1604         internal
1605         view
1606         returns (bool)
1607     {
1608         return
1609             MerkleProof.verify(
1610                 merkleProof,
1611                 root,
1612                 keccak256(abi.encodePacked(msg.sender))
1613             );
1614     }
1615 
1616     function mint(bytes32[] calldata merkleProof, uint256 _amount)
1617         public
1618         payable
1619     {
1620         require(!paused, "minting is paused");
1621         uint256 supply = totalSupply();
1622         require(supply + _amount <= maxSupply, "max NFT limit exceeded");
1623         if (isValidMerkleProof(merkleProof, merkleRoot)&&!publicSale) {
1624             uint256 freeMints = getFreeMints(msg.sender);
1625             uint256 whitelistMints = maxWhitelistLimit-whiteListMinted[msg.sender];
1626             if(freeMints+totalSupplyFree>maxSupplyFree){
1627                 freeMints = maxSupplyFree - totalSupplyFree;
1628             }
1629             require(_amount<=freeMints+whitelistMints,"cannot mint more than limit");
1630             if(freeMints>0){
1631                 if(_amount<=freeMints){
1632                     require(msg.value == 0, "price value should be 0 for free mint");
1633                     require(totalSupplyFree + _amount <= maxSupplyFree, "free NFT limit exceeded");
1634                     freeMints = _amount;
1635                 }else{
1636                     require(totalSupplyFree + freeMints <= maxSupplyFree, "free NFT limit exceeded");
1637                     require(totalSupplyPaid + _amount-freeMints <= maxSupplyPaid, "NFT max limit exceeded");
1638                     require(_amount-freeMints <= maxWhitelistLimit, "whitelist NFT limit exceeded");
1639                     require(msg.value == cost * (_amount-freeMints), "pay price of nft");
1640                 }
1641                 mintTokens(msg.sender,_amount);
1642                 claimTokens(msg.sender, freeMints);
1643                 totalSupplyFree += freeMints;
1644                 totalSupplyPaid += _amount-freeMints;
1645                 mintedBalance[msg.sender] += _amount;
1646                 whiteListMinted[msg.sender]+= _amount-freeMints;
1647             }else{
1648                 require(msg.value == cost * _amount, "pay price of nft");
1649                 mintTokens(msg.sender, _amount);
1650                 totalSupplyPaid += _amount;
1651                 whiteListMinted[msg.sender]+= _amount;
1652                 mintedBalance[msg.sender] += _amount;
1653             }
1654         }
1655         else {
1656             require(totalSupplyPaid + _amount <= maxSupplyPaid, "NFT max limit exceeded");
1657             require(_amount+ publicMinted[msg.sender]<=maxLimitPublic, "cannot mint more than limit");
1658             require(publicSale == true, "Public sale is not open");
1659             require(
1660                 publicMinted[msg.sender] + _amount <= maxLimitPublic,
1661                 "cannot mint more than limit"
1662             );
1663             require(msg.value == cost * _amount, "pay price of nft");
1664             totalSupplyPaid += _amount;
1665             mintTokens(msg.sender, _amount);
1666             mintedBalance[msg.sender] += _amount;
1667             publicMinted[msg.sender] += _amount;
1668         }
1669     }
1670 
1671     function claimTokens(address _minter, uint256 _amount) internal {
1672         uint256[] memory maleOwls = getUnusedMaleNfts(_minter);
1673         uint256[] memory femaleOwls = getUnusedFemaleNfts(_minter);
1674         for(uint256 i=0; i<_amount; i++){
1675             usedMaleNfts[maleOwls[i]]=true;
1676             usedFemaleNfts[femaleOwls[i]]=true;
1677         }
1678     }
1679 
1680     function mintTokens(address _minter, uint256 _amount) internal {
1681         uint256 supply = totalSupply();
1682         for (uint256 i = 1; i <= _amount; i++) {
1683             _safeMint(_minter, supply + i);
1684         }
1685     }
1686 
1687     function getFreeMints(address _minter) public view returns(uint256){
1688         uint256[] memory maleOwls = getUnusedMaleNfts(_minter);
1689         uint256[] memory femaleOwls = getUnusedFemaleNfts(_minter);
1690         uint256 freeMints = 0;
1691         if(maleOwls.length>0&&femaleOwls.length>0){
1692         if(maleOwls.length<=femaleOwls.length){
1693             freeMints = maleOwls.length;
1694         }else{
1695             freeMints = femaleOwls.length;
1696         }
1697         }
1698         return freeMints;
1699     }
1700 
1701     function getWhitelistMints (address _minter)public view returns(uint256){
1702         return maxWhitelistLimit - whiteListMinted[_minter];
1703     }
1704 
1705     function getUnusedMaleNfts(address _minter) public view returns(uint256[] memory){
1706         uint256[] memory maleOwls = maleOwlsContract.walletOfOwner(_minter);
1707         uint256 index = 0;
1708         for(uint256 i=0; i<maleOwls.length; i++){
1709             uint256 id = maleOwls[i];
1710             if(!usedMaleNfts[id]){
1711                 index++;
1712             }
1713         }
1714 
1715         uint256[] memory male= new uint256[](index);
1716         index = 0;
1717         for(uint256 i=0; i<maleOwls.length; i++){
1718             uint256 id = maleOwls[i];
1719             if(!usedMaleNfts[id]){
1720                 male[index] = id;
1721                 index++;
1722             }
1723         }
1724         return male;
1725     }
1726 
1727     function getUnusedFemaleNfts(address _minter) public view returns(uint256[] memory){
1728         uint256[] memory femaleOwls = femaleOwlsContract.walletOfOwner(_minter);
1729         uint256 index = 0;
1730         for(uint256 i=0; i<femaleOwls.length; i++){
1731             uint256 id = femaleOwls[i];
1732             if(!usedFemaleNfts[id]){
1733                 index++;
1734             }
1735         }
1736         uint256[] memory female= new uint256[](index);
1737         index = 0;
1738         for(uint256 i=0; i<femaleOwls.length; i++){
1739             uint256 id = femaleOwls[i];
1740             if(!usedFemaleNfts[id]){
1741                 female[index] = id;
1742                 index++;
1743             }
1744         }
1745         return female;
1746     }
1747 
1748     function ownerMint(address _to, uint256 _mintAmount) public onlyOwner {
1749         uint256 supply = totalSupply();
1750         require(_mintAmount > 0);
1751         require(_mintAmount+totalSupplyFree<=maxSupplyFree,"Free mint limit exceeded");
1752         require(supply + _mintAmount <= maxSupply);
1753         totalSupplyFree += _mintAmount;
1754         mintedBalance[_to]+=_mintAmount;
1755         for (uint256 i = 1; i <= _mintAmount; i++) {
1756             _safeMint(_to, supply + i);
1757         }
1758     }
1759 
1760     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1761         merkleRoot = _merkleRoot;
1762     }
1763 
1764     function walletOfOwner(address _owner)
1765         public
1766         view
1767         returns (uint256[] memory)
1768     {
1769         uint256 ownerTokenCount = balanceOf(_owner);
1770         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1771         for (uint256 i; i < ownerTokenCount; i++) {
1772             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1773         }
1774         return tokenIds;
1775     }
1776 
1777     function tokenURI(uint256 tokenId)
1778         public
1779         view
1780         virtual
1781         override
1782         returns (string memory)
1783     {
1784         require(
1785             _exists(tokenId),
1786             "ERC721Metadata: URI query for nonexistent token"
1787         );
1788 
1789         if (revealed == false) {
1790             return notRevealedUri;
1791         }
1792 
1793         string memory currentBaseURI = _baseURI();
1794         return
1795             bytes(currentBaseURI).length > 0
1796                 ? string(
1797                     abi.encodePacked(
1798                         currentBaseURI,
1799                         tokenId.toString(),
1800                         baseExtension
1801                     )
1802                 )
1803                 : "";
1804     }
1805 
1806     function reveal() public onlyOwner {
1807         revealed = true;
1808     }
1809 
1810     function setCost(uint256 _newCost) public onlyOwner {
1811         cost = _newCost;
1812     }
1813 
1814     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1815         baseURI = _newBaseURI;
1816     }
1817 
1818     function setBaseExtension(string memory _newBaseExtension)
1819         public
1820         onlyOwner
1821     {
1822         baseExtension = _newBaseExtension;
1823     }
1824 
1825     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1826         notRevealedUri = _notRevealedURI;
1827     }
1828 
1829     function pause(bool _state) public onlyOwner {
1830         paused = _state;
1831     }
1832 
1833     function setmaxLimitPublic(uint256 _limit) public onlyOwner {
1834         maxLimitPublic = _limit;
1835     }
1836 
1837     function setmaxLimitWhitelist(uint256 _limit) public onlyOwner {
1838         maxWhitelistLimit = _limit;
1839     }
1840 
1841 
1842     function setMaxSupply(uint256 _supply) public onlyOwner {
1843         maxSupply = _supply;
1844     }
1845 
1846     function setMaxSupplyFree(uint256 _supply) public onlyOwner {
1847         maxSupplyFree = _supply;
1848     }
1849 
1850 
1851     function setMaxSupplyPaid(uint256 _supply) public onlyOwner {
1852         maxSupplyPaid = _supply;
1853     }
1854 
1855     function getInfo(address _minter) public view returns(uint,uint, uint,uint,uint){
1856         return (getFreeMints(_minter),getWhitelistMints(_minter),mintedBalance[_minter],totalSupply(),maxSupplyPaid-totalSupplyPaid);
1857     }
1858 
1859     function withdraw() public payable onlyOwner {
1860         uint256 amount = address(this).balance;
1861         require(amount > 0, "Ether balance is 0 in contract");
1862         payable(address(owner())).transfer(amount);
1863     }
1864 }