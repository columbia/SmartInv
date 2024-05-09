1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-30
3 */
4 
5 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Contract module that helps prevent reentrant calls to a function.
14  *
15  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
16  * available, which can be applied to functions to make sure there are no nested
17  * (reentrant) calls to them.
18  *
19  * Note that because there is a single `nonReentrant` guard, functions marked as
20  * `nonReentrant` may not call one another. This can be worked around by making
21  * those functions `private`, and then adding `external` `nonReentrant` entry
22  * points to them.
23  *
24  * TIP: If you would like to learn more about reentrancy and alternative ways
25  * to protect against it, check out our blog post
26  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
27  */
28 abstract contract ReentrancyGuard {
29     // Booleans are more expensive than uint256 or any type that takes up a full
30     // word because each write operation emits an extra SLOAD to first read the
31     // slot's contents, replace the bits taken up by the boolean, and then write
32     // back. This is the compiler's defense against contract upgrades and
33     // pointer aliasing, and it cannot be disabled.
34 
35     // The values being non-zero value makes deployment a bit more expensive,
36     // but in exchange the refund on every call to nonReentrant will be lower in
37     // amount. Since refunds are capped to a percentage of the total
38     // transaction's gas, it is best to keep them low in cases like this one, to
39     // increase the likelihood of the full refund coming into effect.
40     uint256 private constant _NOT_ENTERED = 1;
41     uint256 private constant _ENTERED = 2;
42 
43     uint256 private _status;
44 
45     constructor() {
46         _status = _NOT_ENTERED;
47     }
48 
49     /**
50      * @dev Prevents a contract from calling itself, directly or indirectly.
51      * Calling a `nonReentrant` function from another `nonReentrant`
52      * function is not supported. It is possible to prevent this from happening
53      * by making the `nonReentrant` function external, and making it call a
54      * `private` function that does the actual work.
55      */
56     modifier nonReentrant() {
57         // On the first call to nonReentrant, _notEntered will be true
58         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
59 
60         // Any calls to nonReentrant after this point will fail
61         _status = _ENTERED;
62 
63         _;
64 
65         // By storing the original value once again, a refund is triggered (see
66         // https://eips.ethereum.org/EIPS/eip-2200)
67         _status = _NOT_ENTERED;
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev These functions deal with verification of Merkle Tree proofs.
80  *
81  * The proofs can be generated using the JavaScript library
82  * https://github.com/miguelmota/merkletreejs[merkletreejs].
83  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
84  *
85  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
86  *
87  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
88  * hashing, or use a hash function other than keccak256 for hashing leaves.
89  * This is because the concatenation of a sorted pair of internal nodes in
90  * the merkle tree could be reinterpreted as a leaf value.
91  */
92 library MerkleProof {
93     /**
94      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
95      * defined by `root`. For this, a `proof` must be provided, containing
96      * sibling hashes on the branch from the leaf to the root of the tree. Each
97      * pair of leaves and each pair of pre-images are assumed to be sorted.
98      */
99     function verify(
100         bytes32[] memory proof,
101         bytes32 root,
102         bytes32 leaf
103     ) internal pure returns (bool) {
104         return processProof(proof, leaf) == root;
105     }
106 
107     /**
108      * @dev Calldata version of {verify}
109      *
110      * _Available since v4.7._
111      */
112     function verifyCalldata(
113         bytes32[] calldata proof,
114         bytes32 root,
115         bytes32 leaf
116     ) internal pure returns (bool) {
117         return processProofCalldata(proof, leaf) == root;
118     }
119 
120     /**
121      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
122      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
123      * hash matches the root of the tree. When processing the proof, the pairs
124      * of leafs & pre-images are assumed to be sorted.
125      *
126      * _Available since v4.4._
127      */
128     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
129         bytes32 computedHash = leaf;
130         for (uint256 i = 0; i < proof.length; i++) {
131             computedHash = _hashPair(computedHash, proof[i]);
132         }
133         return computedHash;
134     }
135 
136     /**
137      * @dev Calldata version of {processProof}
138      *
139      * _Available since v4.7._
140      */
141     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
142         bytes32 computedHash = leaf;
143         for (uint256 i = 0; i < proof.length; i++) {
144             computedHash = _hashPair(computedHash, proof[i]);
145         }
146         return computedHash;
147     }
148 
149     /**
150      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
151      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
152      *
153      * _Available since v4.7._
154      */
155     function multiProofVerify(
156         bytes32[] memory proof,
157         bool[] memory proofFlags,
158         bytes32 root,
159         bytes32[] memory leaves
160     ) internal pure returns (bool) {
161         return processMultiProof(proof, proofFlags, leaves) == root;
162     }
163 
164     /**
165      * @dev Calldata version of {multiProofVerify}
166      *
167      * _Available since v4.7._
168      */
169     function multiProofVerifyCalldata(
170         bytes32[] calldata proof,
171         bool[] calldata proofFlags,
172         bytes32 root,
173         bytes32[] memory leaves
174     ) internal pure returns (bool) {
175         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
176     }
177 
178     /**
179      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
180      * consuming from one or the other at each step according to the instructions given by
181      * `proofFlags`.
182      *
183      * _Available since v4.7._
184      */
185     function processMultiProof(
186         bytes32[] memory proof,
187         bool[] memory proofFlags,
188         bytes32[] memory leaves
189     ) internal pure returns (bytes32 merkleRoot) {
190         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
191         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
192         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
193         // the merkle tree.
194         uint256 leavesLen = leaves.length;
195         uint256 totalHashes = proofFlags.length;
196 
197         // Check proof validity.
198         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
199 
200         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
201         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
202         bytes32[] memory hashes = new bytes32[](totalHashes);
203         uint256 leafPos = 0;
204         uint256 hashPos = 0;
205         uint256 proofPos = 0;
206         // At each step, we compute the next hash using two values:
207         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
208         //   get the next hash.
209         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
210         //   `proof` array.
211         for (uint256 i = 0; i < totalHashes; i++) {
212             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
213             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
214             hashes[i] = _hashPair(a, b);
215         }
216 
217         if (totalHashes > 0) {
218             return hashes[totalHashes - 1];
219         } else if (leavesLen > 0) {
220             return leaves[0];
221         } else {
222             return proof[0];
223         }
224     }
225 
226     /**
227      * @dev Calldata version of {processMultiProof}
228      *
229      * _Available since v4.7._
230      */
231     function processMultiProofCalldata(
232         bytes32[] calldata proof,
233         bool[] calldata proofFlags,
234         bytes32[] memory leaves
235     ) internal pure returns (bytes32 merkleRoot) {
236         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
237         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
238         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
239         // the merkle tree.
240         uint256 leavesLen = leaves.length;
241         uint256 totalHashes = proofFlags.length;
242 
243         // Check proof validity.
244         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
245 
246         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
247         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
248         bytes32[] memory hashes = new bytes32[](totalHashes);
249         uint256 leafPos = 0;
250         uint256 hashPos = 0;
251         uint256 proofPos = 0;
252         // At each step, we compute the next hash using two values:
253         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
254         //   get the next hash.
255         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
256         //   `proof` array.
257         for (uint256 i = 0; i < totalHashes; i++) {
258             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
259             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
260             hashes[i] = _hashPair(a, b);
261         }
262 
263         if (totalHashes > 0) {
264             return hashes[totalHashes - 1];
265         } else if (leavesLen > 0) {
266             return leaves[0];
267         } else {
268             return proof[0];
269         }
270     }
271 
272     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
273         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
274     }
275 
276     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
277         /// @solidity memory-safe-assembly
278         assembly {
279             mstore(0x00, a)
280             mstore(0x20, b)
281             value := keccak256(0x00, 0x40)
282         }
283     }
284 }
285 
286 // File: @openzeppelin/contracts/utils/Strings.sol
287 
288 
289 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev String operations.
295  */
296 library Strings {
297     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
298     uint8 private constant _ADDRESS_LENGTH = 20;
299 
300     /**
301      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
302      */
303     function toString(uint256 value) internal pure returns (string memory) {
304         // Inspired by OraclizeAPI's implementation - MIT licence
305         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
306 
307         if (value == 0) {
308             return "0";
309         }
310         uint256 temp = value;
311         uint256 digits;
312         while (temp != 0) {
313             digits++;
314             temp /= 10;
315         }
316         bytes memory buffer = new bytes(digits);
317         while (value != 0) {
318             digits -= 1;
319             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
320             value /= 10;
321         }
322         return string(buffer);
323     }
324 
325     /**
326      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
327      */
328     function toHexString(uint256 value) internal pure returns (string memory) {
329         if (value == 0) {
330             return "0x00";
331         }
332         uint256 temp = value;
333         uint256 length = 0;
334         while (temp != 0) {
335             length++;
336             temp >>= 8;
337         }
338         return toHexString(value, length);
339     }
340 
341     /**
342      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
343      */
344     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
345         bytes memory buffer = new bytes(2 * length + 2);
346         buffer[0] = "0";
347         buffer[1] = "x";
348         for (uint256 i = 2 * length + 1; i > 1; --i) {
349             buffer[i] = _HEX_SYMBOLS[value & 0xf];
350             value >>= 4;
351         }
352         require(value == 0, "Strings: hex length insufficient");
353         return string(buffer);
354     }
355 
356     /**
357      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
358      */
359     function toHexString(address addr) internal pure returns (string memory) {
360         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
361     }
362 }
363 
364 // File: @openzeppelin/contracts/utils/Context.sol
365 
366 
367 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
368 
369 pragma solidity ^0.8.0;
370 
371 /**
372  * @dev Provides information about the current execution context, including the
373  * sender of the transaction and its data. While these are generally available
374  * via msg.sender and msg.data, they should not be accessed in such a direct
375  * manner, since when dealing with meta-transactions the account sending and
376  * paying for execution may not be the actual sender (as far as an application
377  * is concerned).
378  *
379  * This contract is only required for intermediate, library-like contracts.
380  */
381 abstract contract Context {
382     function _msgSender() internal view virtual returns (address) {
383         return msg.sender;
384     }
385 
386     function _msgData() internal view virtual returns (bytes calldata) {
387         return msg.data;
388     }
389 }
390 
391 // File: @openzeppelin/contracts/access/Ownable.sol
392 
393 
394 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
395 
396 pragma solidity ^0.8.0;
397 
398 
399 /**
400  * @dev Contract module which provides a basic access control mechanism, where
401  * there is an account (an owner) that can be granted exclusive access to
402  * specific functions.
403  *
404  * By default, the owner account will be the one that deploys the contract. This
405  * can later be changed with {transferOwnership}.
406  *
407  * This module is used through inheritance. It will make available the modifier
408  * `onlyOwner`, which can be applied to your functions to restrict their use to
409  * the owner.
410  */
411 abstract contract Ownable is Context {
412     address private _owner;
413 
414     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
415 
416     /**
417      * @dev Initializes the contract setting the deployer as the initial owner.
418      */
419     constructor() {
420         _transferOwnership(_msgSender());
421     }
422 
423     /**
424      * @dev Throws if called by any account other than the owner.
425      */
426     modifier onlyOwner() {
427         _checkOwner();
428         _;
429     }
430 
431     /**
432      * @dev Returns the address of the current owner.
433      */
434     function owner() public view virtual returns (address) {
435         return _owner;
436     }
437 
438     /**
439      * @dev Throws if the sender is not the owner.
440      */
441     function _checkOwner() internal view virtual {
442         require(owner() == _msgSender(), "Ownable: caller is not the owner");
443     }
444 
445     /**
446      * @dev Leaves the contract without owner. It will not be possible to call
447      * `onlyOwner` functions anymore. Can only be called by the current owner.
448      *
449      * NOTE: Renouncing ownership will leave the contract without an owner,
450      * thereby removing any functionality that is only available to the owner.
451      */
452     function renounceOwnership() public virtual onlyOwner {
453         _transferOwnership(address(0));
454     }
455 
456     /**
457      * @dev Transfers ownership of the contract to a new account (`newOwner`).
458      * Can only be called by the current owner.
459      */
460     function transferOwnership(address newOwner) public virtual onlyOwner {
461         require(newOwner != address(0), "Ownable: new owner is the zero address");
462         _transferOwnership(newOwner);
463     }
464 
465     /**
466      * @dev Transfers ownership of the contract to a new account (`newOwner`).
467      * Internal function without access restriction.
468      */
469     function _transferOwnership(address newOwner) internal virtual {
470         address oldOwner = _owner;
471         _owner = newOwner;
472         emit OwnershipTransferred(oldOwner, newOwner);
473     }
474 }
475 
476 // File: @openzeppelin/contracts/utils/Address.sol
477 
478 
479 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
480 
481 pragma solidity ^0.8.1;
482 
483 /**
484  * @dev Collection of functions related to the address type
485  */
486 library Address {
487     /**
488      * @dev Returns true if `account` is a contract.
489      *
490      * [IMPORTANT]
491      * ====
492      * It is unsafe to assume that an address for which this function returns
493      * false is an externally-owned account (EOA) and not a contract.
494      *
495      * Among others, `isContract` will return false for the following
496      * types of addresses:
497      *
498      *  - an externally-owned account
499      *  - a contract in construction
500      *  - an address where a contract will be created
501      *  - an address where a contract lived, but was destroyed
502      * ====
503      *
504      * [IMPORTANT]
505      * ====
506      * You shouldn't rely on `isContract` to protect against flash loan attacks!
507      *
508      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
509      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
510      * constructor.
511      * ====
512      */
513     function isContract(address account) internal view returns (bool) {
514         // This method relies on extcodesize/address.code.length, which returns 0
515         // for contracts in construction, since the code is only stored at the end
516         // of the constructor execution.
517 
518         return account.code.length > 0;
519     }
520 
521     /**
522      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
523      * `recipient`, forwarding all available gas and reverting on errors.
524      *
525      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
526      * of certain opcodes, possibly making contracts go over the 2300 gas limit
527      * imposed by `transfer`, making them unable to receive funds via
528      * `transfer`. {sendValue} removes this limitation.
529      *
530      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
531      *
532      * IMPORTANT: because control is transferred to `recipient`, care must be
533      * taken to not create reentrancy vulnerabilities. Consider using
534      * {ReentrancyGuard} or the
535      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
536      */
537     function sendValue(address payable recipient, uint256 amount) internal {
538         require(address(this).balance >= amount, "Address: insufficient balance");
539 
540         (bool success, ) = recipient.call{value: amount}("");
541         require(success, "Address: unable to send value, recipient may have reverted");
542     }
543 
544     /**
545      * @dev Performs a Solidity function call using a low level `call`. A
546      * plain `call` is an unsafe replacement for a function call: use this
547      * function instead.
548      *
549      * If `target` reverts with a revert reason, it is bubbled up by this
550      * function (like regular Solidity function calls).
551      *
552      * Returns the raw returned data. To convert to the expected return value,
553      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
554      *
555      * Requirements:
556      *
557      * - `target` must be a contract.
558      * - calling `target` with `data` must not revert.
559      *
560      * _Available since v3.1._
561      */
562     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
563         return functionCall(target, data, "Address: low-level call failed");
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
568      * `errorMessage` as a fallback revert reason when `target` reverts.
569      *
570      * _Available since v3.1._
571      */
572     function functionCall(
573         address target,
574         bytes memory data,
575         string memory errorMessage
576     ) internal returns (bytes memory) {
577         return functionCallWithValue(target, data, 0, errorMessage);
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
582      * but also transferring `value` wei to `target`.
583      *
584      * Requirements:
585      *
586      * - the calling contract must have an ETH balance of at least `value`.
587      * - the called Solidity function must be `payable`.
588      *
589      * _Available since v3.1._
590      */
591     function functionCallWithValue(
592         address target,
593         bytes memory data,
594         uint256 value
595     ) internal returns (bytes memory) {
596         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
601      * with `errorMessage` as a fallback revert reason when `target` reverts.
602      *
603      * _Available since v3.1._
604      */
605     function functionCallWithValue(
606         address target,
607         bytes memory data,
608         uint256 value,
609         string memory errorMessage
610     ) internal returns (bytes memory) {
611         require(address(this).balance >= value, "Address: insufficient balance for call");
612         require(isContract(target), "Address: call to non-contract");
613 
614         (bool success, bytes memory returndata) = target.call{value: value}(data);
615         return verifyCallResult(success, returndata, errorMessage);
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
620      * but performing a static call.
621      *
622      * _Available since v3.3._
623      */
624     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
625         return functionStaticCall(target, data, "Address: low-level static call failed");
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
630      * but performing a static call.
631      *
632      * _Available since v3.3._
633      */
634     function functionStaticCall(
635         address target,
636         bytes memory data,
637         string memory errorMessage
638     ) internal view returns (bytes memory) {
639         require(isContract(target), "Address: static call to non-contract");
640 
641         (bool success, bytes memory returndata) = target.staticcall(data);
642         return verifyCallResult(success, returndata, errorMessage);
643     }
644 
645     /**
646      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
647      * but performing a delegate call.
648      *
649      * _Available since v3.4._
650      */
651     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
652         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
657      * but performing a delegate call.
658      *
659      * _Available since v3.4._
660      */
661     function functionDelegateCall(
662         address target,
663         bytes memory data,
664         string memory errorMessage
665     ) internal returns (bytes memory) {
666         require(isContract(target), "Address: delegate call to non-contract");
667 
668         (bool success, bytes memory returndata) = target.delegatecall(data);
669         return verifyCallResult(success, returndata, errorMessage);
670     }
671 
672     /**
673      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
674      * revert reason using the provided one.
675      *
676      * _Available since v4.3._
677      */
678     function verifyCallResult(
679         bool success,
680         bytes memory returndata,
681         string memory errorMessage
682     ) internal pure returns (bytes memory) {
683         if (success) {
684             return returndata;
685         } else {
686             // Look for revert reason and bubble it up if present
687             if (returndata.length > 0) {
688                 // The easiest way to bubble the revert reason is using memory via assembly
689                 /// @solidity memory-safe-assembly
690                 assembly {
691                     let returndata_size := mload(returndata)
692                     revert(add(32, returndata), returndata_size)
693                 }
694             } else {
695                 revert(errorMessage);
696             }
697         }
698     }
699 }
700 
701 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
702 
703 
704 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 /**
709  * @title ERC721 token receiver interface
710  * @dev Interface for any contract that wants to support safeTransfers
711  * from ERC721 asset contracts.
712  */
713 interface IERC721Receiver {
714     /**
715      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
716      * by `operator` from `from`, this function is called.
717      *
718      * It must return its Solidity selector to confirm the token transfer.
719      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
720      *
721      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
722      */
723     function onERC721Received(
724         address operator,
725         address from,
726         uint256 tokenId,
727         bytes calldata data
728     ) external returns (bytes4);
729 }
730 
731 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
732 
733 
734 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
735 
736 pragma solidity ^0.8.0;
737 
738 /**
739  * @dev Interface of the ERC165 standard, as defined in the
740  * https://eips.ethereum.org/EIPS/eip-165[EIP].
741  *
742  * Implementers can declare support of contract interfaces, which can then be
743  * queried by others ({ERC165Checker}).
744  *
745  * For an implementation, see {ERC165}.
746  */
747 interface IERC165 {
748     /**
749      * @dev Returns true if this contract implements the interface defined by
750      * `interfaceId`. See the corresponding
751      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
752      * to learn more about how these ids are created.
753      *
754      * This function call must use less than 30 000 gas.
755      */
756     function supportsInterface(bytes4 interfaceId) external view returns (bool);
757 }
758 
759 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
760 
761 
762 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
763 
764 pragma solidity ^0.8.0;
765 
766 
767 /**
768  * @dev Implementation of the {IERC165} interface.
769  *
770  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
771  * for the additional interface id that will be supported. For example:
772  *
773  * ```solidity
774  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
775  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
776  * }
777  * ```
778  *
779  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
780  */
781 abstract contract ERC165 is IERC165 {
782     /**
783      * @dev See {IERC165-supportsInterface}.
784      */
785     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
786         return interfaceId == type(IERC165).interfaceId;
787     }
788 }
789 
790 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
791 
792 
793 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
794 
795 pragma solidity ^0.8.0;
796 
797 
798 /**
799  * @dev Required interface of an ERC721 compliant contract.
800  */
801 interface IERC721 is IERC165 {
802     /**
803      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
804      */
805     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
806 
807     /**
808      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
809      */
810     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
811 
812     /**
813      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
814      */
815     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
816 
817     /**
818      * @dev Returns the number of tokens in ``owner``'s account.
819      */
820     function balanceOf(address owner) external view returns (uint256 balance);
821 
822     /**
823      * @dev Returns the owner of the `tokenId` token.
824      *
825      * Requirements:
826      *
827      * - `tokenId` must exist.
828      */
829     function ownerOf(uint256 tokenId) external view returns (address owner);
830 
831     /**
832      * @dev Safely transfers `tokenId` token from `from` to `to`.
833      *
834      * Requirements:
835      *
836      * - `from` cannot be the zero address.
837      * - `to` cannot be the zero address.
838      * - `tokenId` token must exist and be owned by `from`.
839      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
840      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
841      *
842      * Emits a {Transfer} event.
843      */
844     function safeTransferFrom(
845         address from,
846         address to,
847         uint256 tokenId,
848         bytes calldata data
849     ) external;
850 
851     /**
852      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
853      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
854      *
855      * Requirements:
856      *
857      * - `from` cannot be the zero address.
858      * - `to` cannot be the zero address.
859      * - `tokenId` token must exist and be owned by `from`.
860      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
861      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
862      *
863      * Emits a {Transfer} event.
864      */
865     function safeTransferFrom(
866         address from,
867         address to,
868         uint256 tokenId
869     ) external;
870 
871     /**
872      * @dev Transfers `tokenId` token from `from` to `to`.
873      *
874      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
875      *
876      * Requirements:
877      *
878      * - `from` cannot be the zero address.
879      * - `to` cannot be the zero address.
880      * - `tokenId` token must be owned by `from`.
881      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
882      *
883      * Emits a {Transfer} event.
884      */
885     function transferFrom(
886         address from,
887         address to,
888         uint256 tokenId
889     ) external;
890 
891     /**
892      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
893      * The approval is cleared when the token is transferred.
894      *
895      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
896      *
897      * Requirements:
898      *
899      * - The caller must own the token or be an approved operator.
900      * - `tokenId` must exist.
901      *
902      * Emits an {Approval} event.
903      */
904     function approve(address to, uint256 tokenId) external;
905 
906     /**
907      * @dev Approve or remove `operator` as an operator for the caller.
908      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
909      *
910      * Requirements:
911      *
912      * - The `operator` cannot be the caller.
913      *
914      * Emits an {ApprovalForAll} event.
915      */
916     function setApprovalForAll(address operator, bool _approved) external;
917 
918     /**
919      * @dev Returns the account approved for `tokenId` token.
920      *
921      * Requirements:
922      *
923      * - `tokenId` must exist.
924      */
925     function getApproved(uint256 tokenId) external view returns (address operator);
926 
927     /**
928      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
929      *
930      * See {setApprovalForAll}
931      */
932     function isApprovedForAll(address owner, address operator) external view returns (bool);
933 }
934 
935 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
936 
937 
938 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
939 
940 pragma solidity ^0.8.0;
941 
942 
943 /**
944  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
945  * @dev See https://eips.ethereum.org/EIPS/eip-721
946  */
947 interface IERC721Metadata is IERC721 {
948     /**
949      * @dev Returns the token collection name.
950      */
951     function name() external view returns (string memory);
952 
953     /**
954      * @dev Returns the token collection symbol.
955      */
956     function symbol() external view returns (string memory);
957 
958     /**
959      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
960      */
961     function tokenURI(uint256 tokenId) external view returns (string memory);
962 }
963 
964 // File: ERC721A.sol
965 
966 
967 // Creator: Chiru Labs
968 
969 pragma solidity ^0.8.4;
970 
971 
972 
973 
974 
975 
976 
977 
978 error ApprovalCallerNotOwnerNorApproved();
979 error ApprovalQueryForNonexistentToken();
980 error ApproveToCaller();
981 error ApprovalToCurrentOwner();
982 error BalanceQueryForZeroAddress();
983 error MintToZeroAddress();
984 error MintZeroQuantity();
985 error OwnerQueryForNonexistentToken();
986 error TransferCallerNotOwnerNorApproved();
987 error TransferFromIncorrectOwner();
988 error TransferToNonERC721ReceiverImplementer();
989 error TransferToZeroAddress();
990 error URIQueryForNonexistentToken();
991 
992 /**
993  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
994  * the Metadata extension. Built to optimize for lower gas during batch mints.
995  *
996  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
997  *
998  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
999  *
1000  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1001  */
1002 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1003     using Address for address;
1004     using Strings for uint256;
1005 
1006     // Compiler will pack this into a single 256bit word.
1007     struct TokenOwnership {
1008         // The address of the owner.
1009         address addr;
1010         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1011         uint64 startTimestamp;
1012         // Whether the token has been burned.
1013         bool burned;
1014     }
1015 
1016     // Compiler will pack this into a single 256bit word.
1017     struct AddressData {
1018         // Realistically, 2**64-1 is more than enough.
1019         uint64 balance;
1020         // Keeps track of mint count with minimal overhead for tokenomics.
1021         uint64 numberMinted;
1022         // Keeps track of burn count with minimal overhead for tokenomics.
1023         uint64 numberBurned;
1024         // For miscellaneous variable(s) pertaining to the address
1025         // (e.g. number of whitelist mint slots used).
1026         // If there are multiple variables, please pack them into a uint64.
1027         uint64 aux;
1028     }
1029 
1030     // The tokenId of the next token to be minted.
1031     uint256 internal _currentIndex;
1032 
1033     // The number of tokens burned.
1034     uint256 internal _burnCounter;
1035 
1036     // Token name
1037     string private _name;
1038 
1039     // Token symbol
1040     string private _symbol;
1041 
1042     // Mapping from token ID to ownership details
1043     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1044     mapping(uint256 => TokenOwnership) internal _ownerships;
1045 
1046     // Mapping owner address to address data
1047     mapping(address => AddressData) private _addressData;
1048 
1049     // Mapping from token ID to approved address
1050     mapping(uint256 => address) private _tokenApprovals;
1051 
1052     // Mapping from owner to operator approvals
1053     mapping(address => mapping(address => bool)) private _operatorApprovals;
1054 
1055     constructor(string memory name_, string memory symbol_) {
1056         _name = name_;
1057         _symbol = symbol_;
1058         _currentIndex = _startTokenId();
1059     }
1060 
1061     /**
1062      * To change the starting tokenId, please override this function.
1063      */
1064     function _startTokenId() internal view virtual returns (uint256) {
1065         return 1;
1066     }
1067 
1068     /**
1069      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1070      */
1071     function totalSupply() public view returns (uint256) {
1072         // Counter underflow is impossible as _burnCounter cannot be incremented
1073         // more than _currentIndex - _startTokenId() times
1074         unchecked {
1075             return _currentIndex - _burnCounter - _startTokenId();
1076         }
1077     }
1078 
1079     /**
1080      * Returns the total amount of tokens minted in the contract.
1081      */
1082     function _totalMinted() internal view returns (uint256) {
1083         // Counter underflow is impossible as _currentIndex does not decrement,
1084         // and it is initialized to _startTokenId()
1085         unchecked {
1086             return _currentIndex - _startTokenId();
1087         }
1088     }
1089 
1090     /**
1091      * @dev See {IERC165-supportsInterface}.
1092      */
1093     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1094         return
1095             interfaceId == type(IERC721).interfaceId ||
1096             interfaceId == type(IERC721Metadata).interfaceId ||
1097             super.supportsInterface(interfaceId);
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-balanceOf}.
1102      */
1103     function balanceOf(address owner) public view override returns (uint256) {
1104         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1105         return uint256(_addressData[owner].balance);
1106     }
1107 
1108     /**
1109      * Returns the number of tokens minted by `owner`.
1110      */
1111     function _numberMinted(address owner) internal view returns (uint256) {
1112         return uint256(_addressData[owner].numberMinted);
1113     }
1114 
1115     /**
1116      * Returns the number of tokens burned by or on behalf of `owner`.
1117      */
1118     function _numberBurned(address owner) internal view returns (uint256) {
1119         return uint256(_addressData[owner].numberBurned);
1120     }
1121 
1122     /**
1123      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1124      */
1125     function _getAux(address owner) internal view returns (uint64) {
1126         return _addressData[owner].aux;
1127     }
1128 
1129     /**
1130      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1131      * If there are multiple variables, please pack them into a uint64.
1132      */
1133     function _setAux(address owner, uint64 aux) internal {
1134         _addressData[owner].aux = aux;
1135     }
1136 
1137     /**
1138      * Gas spent here starts off proportional to the maximum mint batch size.
1139      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1140      */
1141     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1142         uint256 curr = tokenId;
1143 
1144         unchecked {
1145             if (_startTokenId() <= curr && curr < _currentIndex) {
1146                 TokenOwnership memory ownership = _ownerships[curr];
1147                 if (!ownership.burned) {
1148                     if (ownership.addr != address(0)) {
1149                         return ownership;
1150                     }
1151                     // Invariant:
1152                     // There will always be an ownership that has an address and is not burned
1153                     // before an ownership that does not have an address and is not burned.
1154                     // Hence, curr will not underflow.
1155                     while (true) {
1156                         curr--;
1157                         ownership = _ownerships[curr];
1158                         if (ownership.addr != address(0)) {
1159                             return ownership;
1160                         }
1161                     }
1162                 }
1163             }
1164         }
1165         revert OwnerQueryForNonexistentToken();
1166     }
1167 
1168     /**
1169      * @dev See {IERC721-ownerOf}.
1170      */
1171     function ownerOf(uint256 tokenId) public view override returns (address) {
1172         return _ownershipOf(tokenId).addr;
1173     }
1174 
1175     /**
1176      * @dev See {IERC721Metadata-name}.
1177      */
1178     function name() public view virtual override returns (string memory) {
1179         return _name;
1180     }
1181 
1182     /**
1183      * @dev See {IERC721Metadata-symbol}.
1184      */
1185     function symbol() public view virtual override returns (string memory) {
1186         return _symbol;
1187     }
1188 
1189     /**
1190      * @dev See {IERC721Metadata-tokenURI}.
1191      */
1192     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1193         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1194 
1195         string memory baseURI = _baseURI();
1196         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1197     }
1198 
1199     /**
1200      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1201      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1202      * by default, can be overriden in child contracts.
1203      */
1204     function _baseURI() internal view virtual returns (string memory) {
1205         return '';
1206     }
1207 
1208     /**
1209      * @dev See {IERC721-approve}.
1210      */
1211     function approve(address to, uint256 tokenId) public override {
1212         address owner = ERC721A.ownerOf(tokenId);
1213         if (to == owner) revert ApprovalToCurrentOwner();
1214 
1215         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1216             revert ApprovalCallerNotOwnerNorApproved();
1217         }
1218 
1219         _approve(to, tokenId, owner);
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-getApproved}.
1224      */
1225     function getApproved(uint256 tokenId) public view override returns (address) {
1226         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1227 
1228         return _tokenApprovals[tokenId];
1229     }
1230 
1231     /**
1232      * @dev See {IERC721-setApprovalForAll}.
1233      */
1234     function setApprovalForAll(address operator, bool approved) public virtual override {
1235         if (operator == _msgSender()) revert ApproveToCaller();
1236 
1237         _operatorApprovals[_msgSender()][operator] = approved;
1238         emit ApprovalForAll(_msgSender(), operator, approved);
1239     }
1240 
1241     /**
1242      * @dev See {IERC721-isApprovedForAll}.
1243      */
1244     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1245         return _operatorApprovals[owner][operator];
1246     }
1247 
1248     /**
1249      * @dev See {IERC721-transferFrom}.
1250      */
1251     function transferFrom(
1252         address from,
1253         address to,
1254         uint256 tokenId
1255     ) public virtual override {
1256         _transfer(from, to, tokenId);
1257     }
1258 
1259     /**
1260      * @dev See {IERC721-safeTransferFrom}.
1261      */
1262     function safeTransferFrom(
1263         address from,
1264         address to,
1265         uint256 tokenId
1266     ) public virtual override {
1267         safeTransferFrom(from, to, tokenId, '');
1268     }
1269 
1270     /**
1271      * @dev See {IERC721-safeTransferFrom}.
1272      */
1273     function safeTransferFrom(
1274         address from,
1275         address to,
1276         uint256 tokenId,
1277         bytes memory _data
1278     ) public virtual override {
1279         _transfer(from, to, tokenId);
1280         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1281             revert TransferToNonERC721ReceiverImplementer();
1282         }
1283     }
1284 
1285     /**
1286      * @dev Returns whether `tokenId` exists.
1287      *
1288      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1289      *
1290      * Tokens start existing when they are minted (`_mint`),
1291      */
1292     function _exists(uint256 tokenId) internal view returns (bool) {
1293         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1294     }
1295 
1296     function _safeMint(address to, uint256 quantity) internal {
1297         _safeMint(to, quantity, '');
1298     }
1299 
1300     /**
1301      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1302      *
1303      * Requirements:
1304      *
1305      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1306      * - `quantity` must be greater than 0.
1307      *
1308      * Emits a {Transfer} event.
1309      */
1310     function _safeMint(
1311         address to,
1312         uint256 quantity,
1313         bytes memory _data
1314     ) internal {
1315         _mint(to, quantity, _data, true);
1316     }
1317 
1318     /**
1319      * @dev Mints `quantity` tokens and transfers them to `to`.
1320      *
1321      * Requirements:
1322      *
1323      * - `to` cannot be the zero address.
1324      * - `quantity` must be greater than 0.
1325      *
1326      * Emits a {Transfer} event.
1327      */
1328     function _mint(
1329         address to,
1330         uint256 quantity,
1331         bytes memory _data,
1332         bool safe
1333     ) internal {
1334         uint256 startTokenId = _currentIndex;
1335         if (to == address(0)) revert MintToZeroAddress();
1336         if (quantity == 0) revert MintZeroQuantity();
1337 
1338         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1339 
1340         // Overflows are incredibly unrealistic.
1341         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1342         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1343         unchecked {
1344             _addressData[to].balance += uint64(quantity);
1345             _addressData[to].numberMinted += uint64(quantity);
1346 
1347             _ownerships[startTokenId].addr = to;
1348             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1349 
1350             uint256 updatedIndex = startTokenId;
1351             uint256 end = updatedIndex + quantity;
1352 
1353             if (safe && to.isContract()) {
1354                 do {
1355                     emit Transfer(address(0), to, updatedIndex);
1356                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1357                         revert TransferToNonERC721ReceiverImplementer();
1358                     }
1359                 } while (updatedIndex != end);
1360                 // Reentrancy protection
1361                 if (_currentIndex != startTokenId) revert();
1362             } else {
1363                 do {
1364                     emit Transfer(address(0), to, updatedIndex++);
1365                 } while (updatedIndex != end);
1366             }
1367             _currentIndex = updatedIndex;
1368         }
1369         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1370     }
1371 
1372     /**
1373      * @dev Transfers `tokenId` from `from` to `to`.
1374      *
1375      * Requirements:
1376      *
1377      * - `to` cannot be the zero address.
1378      * - `tokenId` token must be owned by `from`.
1379      *
1380      * Emits a {Transfer} event.
1381      */
1382     function _transfer(
1383         address from,
1384         address to,
1385         uint256 tokenId
1386     ) private {
1387         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1388 
1389         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1390 
1391         bool isApprovedOrOwner = (_msgSender() == from ||
1392             isApprovedForAll(from, _msgSender()) ||
1393             getApproved(tokenId) == _msgSender());
1394 
1395         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1396         if (to == address(0)) revert TransferToZeroAddress();
1397 
1398         _beforeTokenTransfers(from, to, tokenId, 1);
1399 
1400         // Clear approvals from the previous owner
1401         _approve(address(0), tokenId, from);
1402 
1403         // Underflow of the sender's balance is impossible because we check for
1404         // ownership above and the recipient's balance can't realistically overflow.
1405         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1406         unchecked {
1407             _addressData[from].balance -= 1;
1408             _addressData[to].balance += 1;
1409 
1410             TokenOwnership storage currSlot = _ownerships[tokenId];
1411             currSlot.addr = to;
1412             currSlot.startTimestamp = uint64(block.timestamp);
1413 
1414             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1415             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1416             uint256 nextTokenId = tokenId + 1;
1417             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1418             if (nextSlot.addr == address(0)) {
1419                 // This will suffice for checking _exists(nextTokenId),
1420                 // as a burned slot cannot contain the zero address.
1421                 if (nextTokenId != _currentIndex) {
1422                     nextSlot.addr = from;
1423                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1424                 }
1425             }
1426         }
1427 
1428         emit Transfer(from, to, tokenId);
1429         _afterTokenTransfers(from, to, tokenId, 1);
1430     }
1431 
1432     /**
1433      * @dev This is equivalent to _burn(tokenId, false)
1434      */
1435     function _burn(uint256 tokenId) internal virtual {
1436         _burn(tokenId, false);
1437     }
1438 
1439     /**
1440      * @dev Destroys `tokenId`.
1441      * The approval is cleared when the token is burned.
1442      *
1443      * Requirements:
1444      *
1445      * - `tokenId` must exist.
1446      *
1447      * Emits a {Transfer} event.
1448      */
1449     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1450         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1451 
1452         address from = prevOwnership.addr;
1453 
1454         if (approvalCheck) {
1455             bool isApprovedOrOwner = (_msgSender() == from ||
1456                 isApprovedForAll(from, _msgSender()) ||
1457                 getApproved(tokenId) == _msgSender());
1458 
1459             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1460         }
1461 
1462         _beforeTokenTransfers(from, address(0), tokenId, 1);
1463 
1464         // Clear approvals from the previous owner
1465         _approve(address(0), tokenId, from);
1466 
1467         // Underflow of the sender's balance is impossible because we check for
1468         // ownership above and the recipient's balance can't realistically overflow.
1469         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1470         unchecked {
1471             AddressData storage addressData = _addressData[from];
1472             addressData.balance -= 1;
1473             addressData.numberBurned += 1;
1474 
1475             // Keep track of who burned the token, and the timestamp of burning.
1476             TokenOwnership storage currSlot = _ownerships[tokenId];
1477             currSlot.addr = from;
1478             currSlot.startTimestamp = uint64(block.timestamp);
1479             currSlot.burned = true;
1480 
1481             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1482             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1483             uint256 nextTokenId = tokenId + 1;
1484             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1485             if (nextSlot.addr == address(0)) {
1486                 // This will suffice for checking _exists(nextTokenId),
1487                 // as a burned slot cannot contain the zero address.
1488                 if (nextTokenId != _currentIndex) {
1489                     nextSlot.addr = from;
1490                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1491                 }
1492             }
1493         }
1494 
1495         emit Transfer(from, address(0), tokenId);
1496         _afterTokenTransfers(from, address(0), tokenId, 1);
1497 
1498         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1499         unchecked {
1500             _burnCounter++;
1501         }
1502     }
1503 
1504     /**
1505      * @dev Approve `to` to operate on `tokenId`
1506      *
1507      * Emits a {Approval} event.
1508      */
1509     function _approve(
1510         address to,
1511         uint256 tokenId,
1512         address owner
1513     ) private {
1514         _tokenApprovals[tokenId] = to;
1515         emit Approval(owner, to, tokenId);
1516     }
1517 
1518     /**
1519      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1520      *
1521      * @param from address representing the previous owner of the given token ID
1522      * @param to target address that will receive the tokens
1523      * @param tokenId uint256 ID of the token to be transferred
1524      * @param _data bytes optional data to send along with the call
1525      * @return bool whether the call correctly returned the expected magic value
1526      */
1527     function _checkContractOnERC721Received(
1528         address from,
1529         address to,
1530         uint256 tokenId,
1531         bytes memory _data
1532     ) private returns (bool) {
1533         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1534             return retval == IERC721Receiver(to).onERC721Received.selector;
1535         } catch (bytes memory reason) {
1536             if (reason.length == 0) {
1537                 revert TransferToNonERC721ReceiverImplementer();
1538             } else {
1539                 assembly {
1540                     revert(add(32, reason), mload(reason))
1541                 }
1542             }
1543         }
1544     }
1545 
1546     /**
1547      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1548      * And also called before burning one token.
1549      *
1550      * startTokenId - the first token id to be transferred
1551      * quantity - the amount to be transferred
1552      *
1553      * Calling conditions:
1554      *
1555      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1556      * transferred to `to`.
1557      * - When `from` is zero, `tokenId` will be minted for `to`.
1558      * - When `to` is zero, `tokenId` will be burned by `from`.
1559      * - `from` and `to` are never both zero.
1560      */
1561     function _beforeTokenTransfers(
1562         address from,
1563         address to,
1564         uint256 startTokenId,
1565         uint256 quantity
1566     ) internal virtual {}
1567 
1568     /**
1569      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1570      * minting.
1571      * And also called after one token has been burned.
1572      *
1573      * startTokenId - the first token id to be transferred
1574      * quantity - the amount to be transferred
1575      *
1576      * Calling conditions:
1577      *
1578      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1579      * transferred to `to`.
1580      * - When `from` is zero, `tokenId` has been minted for `to`.
1581      * - When `to` is zero, `tokenId` has been burned by `from`.
1582      * - `from` and `to` are never both zero.
1583      */
1584     function _afterTokenTransfers(
1585         address from,
1586         address to,
1587         uint256 startTokenId,
1588         uint256 quantity
1589     ) internal virtual {}
1590 }
1591 // File: Y00tfulls.sol
1592 
1593 
1594 pragma solidity ^0.8.0;
1595 
1596 
1597 
1598 
1599 
1600 
1601 interface ContractA {
1602     function balanceOf(address account) external view returns (uint256);
1603     function totalSupply() external view returns (uint256);
1604     function ownerOf(uint256 tokenId) external view returns (address);
1605 }
1606 
1607 interface ContractB {
1608     function balanceOf(address account) external view returns (uint256);
1609     function totalSupply() external view returns (uint256);
1610     function ownerOf(uint256 tokenId) external view returns (address);
1611 }
1612 
1613 contract Y00tfulls is ERC721A, Ownable, ReentrancyGuard {
1614     using Strings for uint256;
1615 
1616     ContractA TokenA;
1617     ContractB TokenB;
1618 
1619     string public baseURI;
1620     string public baseExtension = ".json";
1621     bool public presale;
1622     bool public publicSale;
1623     bytes32 public merkleRoot;
1624     uint256 public maxSupply = 10000;
1625     uint256 public maxWhitelist = 3;
1626     uint256 public maxPublic = 100;
1627     uint256 public maxPerTx = 10;
1628     uint256 public presaleCost = 0 ether;
1629     uint256 public publicCost = .003 ether;
1630     mapping(address => uint256) public addressMintedBalance;
1631 
1632 
1633     constructor(string memory _initBaseURI, ContractA _tokenAddressA, ContractB _tokenAddressB) ERC721A("Y00tfulls", "YF") {
1634         setBaseURI(_initBaseURI);
1635         require(address(_tokenAddressA) != address(0) && address(_tokenAddressB) != address(0), "Token Address cannot be address 0");
1636         TokenA = _tokenAddressA;
1637         TokenB = _tokenAddressB;
1638     }
1639 
1640     // Whitelist mint
1641     function whitelistMint(uint256 quantity, bytes32[] calldata _merkleProof)
1642         public
1643         payable
1644         nonReentrant
1645     {
1646         require(presale, "The whitelist sale is not enabled!"); 
1647         uint256 supply = totalSupply();
1648         require(quantity > 0, "Quantity Must Be Higher Than Zero");
1649         require(quantity <= maxPerTx, "Quantity Exceeds The Limit");
1650         require(supply + quantity <= maxSupply, "Max Supply Reached");
1651         require(
1652             addressMintedBalance[msg.sender] + quantity <= maxWhitelist,
1653             "You're not allowed to mint this Much!"
1654         );
1655         require(msg.value >= presaleCost * quantity, "Not enough ether!");
1656 
1657         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1658         require(
1659             MerkleProof.verify(_merkleProof, merkleRoot, leaf),
1660             "Invalid proof!"
1661         );
1662 
1663         _safeMint(msg.sender, quantity);
1664         addressMintedBalance[msg.sender] += quantity;
1665     }
1666 
1667     // Public mint
1668     function mint(uint256 quantity) external payable nonReentrant {
1669         require(publicSale, "The public sale is not enabled!");
1670         uint256 supply = totalSupply();
1671         uint256 totalHolding = TokenA.balanceOf(msg.sender) + TokenB.balanceOf(msg.sender);
1672         uint256 totalCost;
1673         require(quantity > 0, "Quantity must be higher than zero!");
1674         require(quantity <= maxPerTx, "Quantity Exceeds The Limit");
1675         require(supply + quantity <= maxSupply, "Max supply reached!");
1676         require(
1677             addressMintedBalance[msg.sender] + quantity <= maxPublic,
1678             "You're not allowed to mint this Much!"
1679         );
1680         
1681         if(addressMintedBalance[msg.sender] >= totalHolding) {
1682             totalCost = quantity * publicCost;
1683         } else if (addressMintedBalance[msg.sender] + quantity > totalHolding) {
1684             totalCost = (addressMintedBalance[msg.sender] + quantity - totalHolding) * publicCost;
1685         } else {
1686             totalCost = 0;
1687         }
1688         
1689         require(msg.value >= totalCost, "Not enough ether!");
1690         _safeMint(msg.sender, quantity);
1691         addressMintedBalance[msg.sender] += quantity;
1692     }
1693 
1694     // Owner mint
1695     function devMint(uint256 quantity) external onlyOwner {
1696         uint256 supply = totalSupply();
1697         require(quantity > 0, "Quantity must be higher than zero!");
1698         require(supply + quantity <= maxSupply, "Max supply reached!");
1699         _safeMint(msg.sender, quantity);
1700     }
1701 
1702     // internal
1703     function _baseURI() internal view virtual override returns (string memory) {
1704         return baseURI;
1705     }
1706 
1707     function tokenURI(uint256 tokenId)
1708         public
1709         view
1710         virtual
1711         override
1712         returns (string memory)
1713     {
1714         require(
1715             _exists(tokenId),
1716             "ERC721Metadata: URI query for nonexistent token"
1717         );
1718 
1719         string memory currentBaseURI = _baseURI();
1720 
1721         return
1722             bytes(currentBaseURI).length > 0
1723                 ? string(
1724                     abi.encodePacked(
1725                         currentBaseURI,
1726                         tokenId.toString(),
1727                         baseExtension
1728                     )
1729                 )
1730                 : "";
1731     }
1732 
1733     // 
1734 
1735     // Set supply of nfts
1736     function setMaxSupply(uint256 _amount) public onlyOwner {
1737         maxSupply = _amount;
1738     }
1739 
1740     // Set merkleRoot for whitelist
1741     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1742         merkleRoot = _merkleRoot;
1743     }
1744 
1745     // Control sale state
1746     function setSale(bool _presale, bool _publicSale) public onlyOwner {
1747         presale = _presale;
1748         publicSale = _publicSale;
1749     }
1750 
1751     // Set max per wallet both presale and public sale
1752     function setMax(uint256 _presale, uint256 _public) public onlyOwner {
1753         maxWhitelist = _presale;
1754         maxPublic = _public;
1755     }
1756 
1757     // Set max per transaction
1758     function setTx(uint256 _amount) public onlyOwner {
1759         maxPerTx = _amount;
1760     }
1761 
1762     // Set mint price for both presale and public sale
1763     function setPrice(uint256 _whitelistCost, uint256 _publicCost) public onlyOwner {
1764         presaleCost = _whitelistCost;
1765         publicCost = _publicCost;
1766     }
1767 
1768     // Set baseURI
1769     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1770         baseURI = _newBaseURI;
1771     }
1772 
1773     // Set contract addresses for both collection
1774     function setContractAddress(ContractA _tokenAddressA, ContractB _tokenAddressB) public onlyOwner {
1775         require(address(_tokenAddressA) != address(0) && address(_tokenAddressB) != address(0), "Token Address cannot be address 0");
1776         TokenA = _tokenAddressA;
1777         TokenB = _tokenAddressB;
1778     }
1779 
1780     // Airdrop NFT to anyone
1781     function airdrop(address _address ,uint256 quantity) public onlyOwner {
1782         uint256 supply = totalSupply();
1783         require(quantity > 0, "Quantity must be higher than zero!");
1784         require(supply + quantity <= maxSupply, "Max supply reached!");
1785         _safeMint(_address, quantity);
1786     }
1787 
1788     // Get total nft count in both collection
1789     function getHoldings(address _address) public view returns (uint256) {
1790         uint256 total = TokenA.balanceOf(_address) + TokenB.balanceOf(_address);
1791         return total;
1792     }
1793 
1794     // Get calculated cost
1795     function getCost(uint256 quantity) public view returns (uint256) {
1796         uint256 totalHolding = TokenA.balanceOf(msg.sender) + TokenB.balanceOf(msg.sender);
1797         uint256 totalCost;
1798 
1799         if(addressMintedBalance[msg.sender] >= totalHolding) {
1800             totalCost = quantity * publicCost;
1801         } else if (addressMintedBalance[msg.sender] + quantity > totalHolding) {
1802             totalCost = (addressMintedBalance[msg.sender] + quantity - totalHolding) * publicCost;
1803         } else {
1804             totalCost = 0;
1805         }
1806 
1807         return totalCost;
1808     }
1809 
1810     function setBaseExtension(string memory _newBaseExtension)
1811         public
1812         onlyOwner
1813     {
1814         baseExtension = _newBaseExtension;
1815     }
1816 
1817     // Withdraw the funds from the contract
1818     function withdraw() public onlyOwner {
1819         uint256 balance = address(this).balance;
1820         payable(msg.sender).transfer(balance);
1821     }
1822 }