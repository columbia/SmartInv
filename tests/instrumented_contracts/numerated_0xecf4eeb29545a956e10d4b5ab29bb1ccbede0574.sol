1 // SPDX-License-Identifier: MIT
2 
3 
4 
5 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
6 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Contract module that helps prevent reentrant calls to a function.
12  *
13  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
14  * available, which can be applied to functions to make sure there are no nested
15  * (reentrant) calls to them.
16  *
17  * Note that because there is a single `nonReentrant` guard, functions marked as
18  * `nonReentrant` may not call one another. This can be worked around by making
19  * those functions `private`, and then adding `external` `nonReentrant` entry
20  * points to them.
21  *
22  * TIP: If you would like to learn more about reentrancy and alternative ways
23  * to protect against it, check out our blog post
24  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
25  */
26 abstract contract ReentrancyGuard {
27     // Booleans are more expensive than uint256 or any type that takes up a full
28     // word because each write operation emits an extra SLOAD to first read the
29     // slot's contents, replace the bits taken up by the boolean, and then write
30     // back. This is the compiler's defense against contract upgrades and
31     // pointer aliasing, and it cannot be disabled.
32 
33     // The values being non-zero value makes deployment a bit more expensive,
34     // but in exchange the refund on every call to nonReentrant will be lower in
35     // amount. Since refunds are capped to a percentage of the total
36     // transaction's gas, it is best to keep them low in cases like this one, to
37     // increase the likelihood of the full refund coming into effect.
38     uint256 private constant _NOT_ENTERED = 1;
39     uint256 private constant _ENTERED = 2;
40 
41     uint256 private _status;
42 
43     constructor() {
44         _status = _NOT_ENTERED;
45     }
46 
47     /**
48      * @dev Prevents a contract from calling itself, directly or indirectly.
49      * Calling a `nonReentrant` function from another `nonReentrant`
50      * function is not supported. It is possible to prevent this from happening
51      * by making the `nonReentrant` function external, and making it call a
52      * `private` function that does the actual work.
53      */
54     modifier nonReentrant() {
55         // On the first call to nonReentrant, _notEntered will be true
56         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
57 
58         // Any calls to nonReentrant after this point will fail
59         _status = _ENTERED;
60 
61         _;
62 
63         // By storing the original value once again, a refund is triggered (see
64         // https://eips.ethereum.org/EIPS/eip-2200)
65         _status = _NOT_ENTERED;
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
70 
71 
72 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev These functions deal with verification of Merkle Tree proofs.
78  *
79  * The proofs can be generated using the JavaScript library
80  * https://github.com/miguelmota/merkletreejs[merkletreejs].
81  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
82  *
83  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
84  *
85  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
86  * hashing, or use a hash function other than keccak256 for hashing leaves.
87  * This is because the concatenation of a sorted pair of internal nodes in
88  * the merkle tree could be reinterpreted as a leaf value.
89  */
90 library MerkleProof {
91     /**
92      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
93      * defined by `root`. For this, a `proof` must be provided, containing
94      * sibling hashes on the branch from the leaf to the root of the tree. Each
95      * pair of leaves and each pair of pre-images are assumed to be sorted.
96      */
97     function verify(
98         bytes32[] memory proof,
99         bytes32 root,
100         bytes32 leaf
101     ) internal pure returns (bool) {
102         return processProof(proof, leaf) == root;
103     }
104 
105     /**
106      * @dev Calldata version of {verify}
107      *
108      * _Available since v4.7._
109      */
110     function verifyCalldata(
111         bytes32[] calldata proof,
112         bytes32 root,
113         bytes32 leaf
114     ) internal pure returns (bool) {
115         return processProofCalldata(proof, leaf) == root;
116     }
117 
118     /**
119      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
120      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
121      * hash matches the root of the tree. When processing the proof, the pairs
122      * of leafs & pre-images are assumed to be sorted.
123      *
124      * _Available since v4.4._
125      */
126     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
127         bytes32 computedHash = leaf;
128         for (uint256 i = 0; i < proof.length; i++) {
129             computedHash = _hashPair(computedHash, proof[i]);
130         }
131         return computedHash;
132     }
133 
134     /**
135      * @dev Calldata version of {processProof}
136      *
137      * _Available since v4.7._
138      */
139     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
140         bytes32 computedHash = leaf;
141         for (uint256 i = 0; i < proof.length; i++) {
142             computedHash = _hashPair(computedHash, proof[i]);
143         }
144         return computedHash;
145     }
146 
147     /**
148      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
149      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
150      *
151      * _Available since v4.7._
152      */
153     function multiProofVerify(
154         bytes32[] memory proof,
155         bool[] memory proofFlags,
156         bytes32 root,
157         bytes32[] memory leaves
158     ) internal pure returns (bool) {
159         return processMultiProof(proof, proofFlags, leaves) == root;
160     }
161 
162     /**
163      * @dev Calldata version of {multiProofVerify}
164      *
165      * _Available since v4.7._
166      */
167     function multiProofVerifyCalldata(
168         bytes32[] calldata proof,
169         bool[] calldata proofFlags,
170         bytes32 root,
171         bytes32[] memory leaves
172     ) internal pure returns (bool) {
173         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
174     }
175 
176     /**
177      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
178      * consuming from one or the other at each step according to the instructions given by
179      * `proofFlags`.
180      *
181      * _Available since v4.7._
182      */
183     function processMultiProof(
184         bytes32[] memory proof,
185         bool[] memory proofFlags,
186         bytes32[] memory leaves
187     ) internal pure returns (bytes32 merkleRoot) {
188         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
189         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
190         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
191         // the merkle tree.
192         uint256 leavesLen = leaves.length;
193         uint256 totalHashes = proofFlags.length;
194 
195         // Check proof validity.
196         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
197 
198         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
199         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
200         bytes32[] memory hashes = new bytes32[](totalHashes);
201         uint256 leafPos = 0;
202         uint256 hashPos = 0;
203         uint256 proofPos = 0;
204         // At each step, we compute the next hash using two values:
205         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
206         //   get the next hash.
207         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
208         //   `proof` array.
209         for (uint256 i = 0; i < totalHashes; i++) {
210             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
211             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
212             hashes[i] = _hashPair(a, b);
213         }
214 
215         if (totalHashes > 0) {
216             return hashes[totalHashes - 1];
217         } else if (leavesLen > 0) {
218             return leaves[0];
219         } else {
220             return proof[0];
221         }
222     }
223 
224     /**
225      * @dev Calldata version of {processMultiProof}
226      *
227      * _Available since v4.7._
228      */
229     function processMultiProofCalldata(
230         bytes32[] calldata proof,
231         bool[] calldata proofFlags,
232         bytes32[] memory leaves
233     ) internal pure returns (bytes32 merkleRoot) {
234         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
235         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
236         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
237         // the merkle tree.
238         uint256 leavesLen = leaves.length;
239         uint256 totalHashes = proofFlags.length;
240 
241         // Check proof validity.
242         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
243 
244         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
245         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
246         bytes32[] memory hashes = new bytes32[](totalHashes);
247         uint256 leafPos = 0;
248         uint256 hashPos = 0;
249         uint256 proofPos = 0;
250         // At each step, we compute the next hash using two values:
251         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
252         //   get the next hash.
253         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
254         //   `proof` array.
255         for (uint256 i = 0; i < totalHashes; i++) {
256             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
257             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
258             hashes[i] = _hashPair(a, b);
259         }
260 
261         if (totalHashes > 0) {
262             return hashes[totalHashes - 1];
263         } else if (leavesLen > 0) {
264             return leaves[0];
265         } else {
266             return proof[0];
267         }
268     }
269 
270     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
271         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
272     }
273 
274     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
275         /// @solidity memory-safe-assembly
276         assembly {
277             mstore(0x00, a)
278             mstore(0x20, b)
279             value := keccak256(0x00, 0x40)
280         }
281     }
282 }
283 
284 // File: @openzeppelin/contracts/utils/Strings.sol
285 
286 
287 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 /**
292  * @dev String operations.
293  */
294 library Strings {
295     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
296     uint8 private constant _ADDRESS_LENGTH = 20;
297 
298     /**
299      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
300      */
301     function toString(uint256 value) internal pure returns (string memory) {
302         // Inspired by OraclizeAPI's implementation - MIT licence
303         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
304 
305         if (value == 0) {
306             return "0";
307         }
308         uint256 temp = value;
309         uint256 digits;
310         while (temp != 0) {
311             digits++;
312             temp /= 10;
313         }
314         bytes memory buffer = new bytes(digits);
315         while (value != 0) {
316             digits -= 1;
317             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
318             value /= 10;
319         }
320         return string(buffer);
321     }
322 
323     /**
324      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
325      */
326     function toHexString(uint256 value) internal pure returns (string memory) {
327         if (value == 0) {
328             return "0x00";
329         }
330         uint256 temp = value;
331         uint256 length = 0;
332         while (temp != 0) {
333             length++;
334             temp >>= 8;
335         }
336         return toHexString(value, length);
337     }
338 
339     /**
340      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
341      */
342     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
343         bytes memory buffer = new bytes(2 * length + 2);
344         buffer[0] = "0";
345         buffer[1] = "x";
346         for (uint256 i = 2 * length + 1; i > 1; --i) {
347             buffer[i] = _HEX_SYMBOLS[value & 0xf];
348             value >>= 4;
349         }
350         require(value == 0, "Strings: hex length insufficient");
351         return string(buffer);
352     }
353 
354     /**
355      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
356      */
357     function toHexString(address addr) internal pure returns (string memory) {
358         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
359     }
360 }
361 
362 // File: @openzeppelin/contracts/utils/Context.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @dev Provides information about the current execution context, including the
371  * sender of the transaction and its data. While these are generally available
372  * via msg.sender and msg.data, they should not be accessed in such a direct
373  * manner, since when dealing with meta-transactions the account sending and
374  * paying for execution may not be the actual sender (as far as an application
375  * is concerned).
376  *
377  * This contract is only required for intermediate, library-like contracts.
378  */
379 abstract contract Context {
380     function _msgSender() internal view virtual returns (address) {
381         return msg.sender;
382     }
383 
384     function _msgData() internal view virtual returns (bytes calldata) {
385         return msg.data;
386     }
387 }
388 
389 // File: @openzeppelin/contracts/access/Ownable.sol
390 
391 
392 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 
397 /**
398  * @dev Contract module which provides a basic access control mechanism, where
399  * there is an account (an owner) that can be granted exclusive access to
400  * specific functions.
401  *
402  * By default, the owner account will be the one that deploys the contract. This
403  * can later be changed with {transferOwnership}.
404  *
405  * This module is used through inheritance. It will make available the modifier
406  * `onlyOwner`, which can be applied to your functions to restrict their use to
407  * the owner.
408  */
409 abstract contract Ownable is Context {
410     address private _owner;
411 
412     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
413 
414     /**
415      * @dev Initializes the contract setting the deployer as the initial owner.
416      */
417     constructor() {
418         _transferOwnership(_msgSender());
419     }
420 
421     /**
422      * @dev Throws if called by any account other than the owner.
423      */
424     modifier onlyOwner() {
425         _checkOwner();
426         _;
427     }
428 
429     /**
430      * @dev Returns the address of the current owner.
431      */
432     function owner() public view virtual returns (address) {
433         return _owner;
434     }
435 
436     /**
437      * @dev Throws if the sender is not the owner.
438      */
439     function _checkOwner() internal view virtual {
440         require(owner() == _msgSender(), "Ownable: caller is not the owner");
441     }
442 
443     /**
444      * @dev Leaves the contract without owner. It will not be possible to call
445      * `onlyOwner` functions anymore. Can only be called by the current owner.
446      *
447      * NOTE: Renouncing ownership will leave the contract without an owner,
448      * thereby removing any functionality that is only available to the owner.
449      */
450     function renounceOwnership() public virtual onlyOwner {
451         _transferOwnership(address(0));
452     }
453 
454     /**
455      * @dev Transfers ownership of the contract to a new account (`newOwner`).
456      * Can only be called by the current owner.
457      */
458     function transferOwnership(address newOwner) public virtual onlyOwner {
459         require(newOwner != address(0), "Ownable: new owner is the zero address");
460         _transferOwnership(newOwner);
461     }
462 
463     /**
464      * @dev Transfers ownership of the contract to a new account (`newOwner`).
465      * Internal function without access restriction.
466      */
467     function _transferOwnership(address newOwner) internal virtual {
468         address oldOwner = _owner;
469         _owner = newOwner;
470         emit OwnershipTransferred(oldOwner, newOwner);
471     }
472 }
473 
474 // File: @openzeppelin/contracts/utils/Address.sol
475 
476 
477 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
478 
479 pragma solidity ^0.8.1;
480 
481 /**
482  * @dev Collection of functions related to the address type
483  */
484 library Address {
485     /**
486      * @dev Returns true if `account` is a contract.
487      *
488      * [IMPORTANT]
489      * ====
490      * It is unsafe to assume that an address for which this function returns
491      * false is an externally-owned account (EOA) and not a contract.
492      *
493      * Among others, `isContract` will return false for the following
494      * types of addresses:
495      *
496      *  - an externally-owned account
497      *  - a contract in construction
498      *  - an address where a contract will be created
499      *  - an address where a contract lived, but was destroyed
500      * ====
501      *
502      * [IMPORTANT]
503      * ====
504      * You shouldn't rely on `isContract` to protect against flash loan attacks!
505      *
506      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
507      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
508      * constructor.
509      * ====
510      */
511     function isContract(address account) internal view returns (bool) {
512         // This method relies on extcodesize/address.code.length, which returns 0
513         // for contracts in construction, since the code is only stored at the end
514         // of the constructor execution.
515 
516         return account.code.length > 0;
517     }
518 
519     /**
520      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
521      * `recipient`, forwarding all available gas and reverting on errors.
522      *
523      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
524      * of certain opcodes, possibly making contracts go over the 2300 gas limit
525      * imposed by `transfer`, making them unable to receive funds via
526      * `transfer`. {sendValue} removes this limitation.
527      *
528      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
529      *
530      * IMPORTANT: because control is transferred to `recipient`, care must be
531      * taken to not create reentrancy vulnerabilities. Consider using
532      * {ReentrancyGuard} or the
533      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
534      */
535     function sendValue(address payable recipient, uint256 amount) internal {
536         require(address(this).balance >= amount, "Address: insufficient balance");
537 
538         (bool success, ) = recipient.call{value: amount}("");
539         require(success, "Address: unable to send value, recipient may have reverted");
540     }
541 
542     /**
543      * @dev Performs a Solidity function call using a low level `call`. A
544      * plain `call` is an unsafe replacement for a function call: use this
545      * function instead.
546      *
547      * If `target` reverts with a revert reason, it is bubbled up by this
548      * function (like regular Solidity function calls).
549      *
550      * Returns the raw returned data. To convert to the expected return value,
551      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
552      *
553      * Requirements:
554      *
555      * - `target` must be a contract.
556      * - calling `target` with `data` must not revert.
557      *
558      * _Available since v3.1._
559      */
560     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
561         return functionCall(target, data, "Address: low-level call failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
566      * `errorMessage` as a fallback revert reason when `target` reverts.
567      *
568      * _Available since v3.1._
569      */
570     function functionCall(
571         address target,
572         bytes memory data,
573         string memory errorMessage
574     ) internal returns (bytes memory) {
575         return functionCallWithValue(target, data, 0, errorMessage);
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
580      * but also transferring `value` wei to `target`.
581      *
582      * Requirements:
583      *
584      * - the calling contract must have an ETH balance of at least `value`.
585      * - the called Solidity function must be `payable`.
586      *
587      * _Available since v3.1._
588      */
589     function functionCallWithValue(
590         address target,
591         bytes memory data,
592         uint256 value
593     ) internal returns (bytes memory) {
594         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
599      * with `errorMessage` as a fallback revert reason when `target` reverts.
600      *
601      * _Available since v3.1._
602      */
603     function functionCallWithValue(
604         address target,
605         bytes memory data,
606         uint256 value,
607         string memory errorMessage
608     ) internal returns (bytes memory) {
609         require(address(this).balance >= value, "Address: insufficient balance for call");
610         require(isContract(target), "Address: call to non-contract");
611 
612         (bool success, bytes memory returndata) = target.call{value: value}(data);
613         return verifyCallResult(success, returndata, errorMessage);
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
618      * but performing a static call.
619      *
620      * _Available since v3.3._
621      */
622     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
623         return functionStaticCall(target, data, "Address: low-level static call failed");
624     }
625 
626     /**
627      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
628      * but performing a static call.
629      *
630      * _Available since v3.3._
631      */
632     function functionStaticCall(
633         address target,
634         bytes memory data,
635         string memory errorMessage
636     ) internal view returns (bytes memory) {
637         require(isContract(target), "Address: static call to non-contract");
638 
639         (bool success, bytes memory returndata) = target.staticcall(data);
640         return verifyCallResult(success, returndata, errorMessage);
641     }
642 
643     /**
644      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
645      * but performing a delegate call.
646      *
647      * _Available since v3.4._
648      */
649     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
650         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
651     }
652 
653     /**
654      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
655      * but performing a delegate call.
656      *
657      * _Available since v3.4._
658      */
659     function functionDelegateCall(
660         address target,
661         bytes memory data,
662         string memory errorMessage
663     ) internal returns (bytes memory) {
664         require(isContract(target), "Address: delegate call to non-contract");
665 
666         (bool success, bytes memory returndata) = target.delegatecall(data);
667         return verifyCallResult(success, returndata, errorMessage);
668     }
669 
670     /**
671      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
672      * revert reason using the provided one.
673      *
674      * _Available since v4.3._
675      */
676     function verifyCallResult(
677         bool success,
678         bytes memory returndata,
679         string memory errorMessage
680     ) internal pure returns (bytes memory) {
681         if (success) {
682             return returndata;
683         } else {
684             // Look for revert reason and bubble it up if present
685             if (returndata.length > 0) {
686                 // The easiest way to bubble the revert reason is using memory via assembly
687                 /// @solidity memory-safe-assembly
688                 assembly {
689                     let returndata_size := mload(returndata)
690                     revert(add(32, returndata), returndata_size)
691                 }
692             } else {
693                 revert(errorMessage);
694             }
695         }
696     }
697 }
698 
699 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
700 
701 
702 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 /**
707  * @title ERC721 token receiver interface
708  * @dev Interface for any contract that wants to support safeTransfers
709  * from ERC721 asset contracts.
710  */
711 interface IERC721Receiver {
712     /**
713      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
714      * by `operator` from `from`, this function is called.
715      *
716      * It must return its Solidity selector to confirm the token transfer.
717      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
718      *
719      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
720      */
721     function onERC721Received(
722         address operator,
723         address from,
724         uint256 tokenId,
725         bytes calldata data
726     ) external returns (bytes4);
727 }
728 
729 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
730 
731 
732 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 /**
737  * @dev Interface of the ERC165 standard, as defined in the
738  * https://eips.ethereum.org/EIPS/eip-165[EIP].
739  *
740  * Implementers can declare support of contract interfaces, which can then be
741  * queried by others ({ERC165Checker}).
742  *
743  * For an implementation, see {ERC165}.
744  */
745 interface IERC165 {
746     /**
747      * @dev Returns true if this contract implements the interface defined by
748      * `interfaceId`. See the corresponding
749      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
750      * to learn more about how these ids are created.
751      *
752      * This function call must use less than 30 000 gas.
753      */
754     function supportsInterface(bytes4 interfaceId) external view returns (bool);
755 }
756 
757 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
758 
759 
760 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 
765 /**
766  * @dev Interface for the NFT Royalty Standard.
767  *
768  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
769  * support for royalty payments across all NFT marketplaces and ecosystem participants.
770  *
771  * _Available since v4.5._
772  */
773 interface IERC2981 is IERC165 {
774     /**
775      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
776      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
777      */
778     function royaltyInfo(uint256 tokenId, uint256 salePrice)
779         external
780         view
781         returns (address receiver, uint256 royaltyAmount);
782 }
783 
784 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
785 
786 
787 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
788 
789 pragma solidity ^0.8.0;
790 
791 
792 /**
793  * @dev Implementation of the {IERC165} interface.
794  *
795  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
796  * for the additional interface id that will be supported. For example:
797  *
798  * ```solidity
799  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
800  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
801  * }
802  * ```
803  *
804  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
805  */
806 abstract contract ERC165 is IERC165 {
807     /**
808      * @dev See {IERC165-supportsInterface}.
809      */
810     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
811         return interfaceId == type(IERC165).interfaceId;
812     }
813 }
814 
815 // File: @openzeppelin/contracts/token/common/ERC2981.sol
816 
817 
818 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
819 
820 pragma solidity ^0.8.0;
821 
822 
823 
824 /**
825  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
826  *
827  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
828  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
829  *
830  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
831  * fee is specified in basis points by default.
832  *
833  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
834  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
835  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
836  *
837  * _Available since v4.5._
838  */
839 abstract contract ERC2981 is IERC2981, ERC165 {
840     struct RoyaltyInfo {
841         address receiver;
842         uint96 royaltyFraction;
843     }
844 
845     RoyaltyInfo private _defaultRoyaltyInfo;
846     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
847 
848     /**
849      * @dev See {IERC165-supportsInterface}.
850      */
851     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
852         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
853     }
854 
855     /**
856      * @inheritdoc IERC2981
857      */
858     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
859         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
860 
861         if (royalty.receiver == address(0)) {
862             royalty = _defaultRoyaltyInfo;
863         }
864 
865         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
866 
867         return (royalty.receiver, royaltyAmount);
868     }
869 
870     /**
871      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
872      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
873      * override.
874      */
875     function _feeDenominator() internal pure virtual returns (uint96) {
876         return 10000;
877     }
878 
879     /**
880      * @dev Sets the royalty information that all ids in this contract will default to.
881      *
882      * Requirements:
883      *
884      * - `receiver` cannot be the zero address.
885      * - `feeNumerator` cannot be greater than the fee denominator.
886      */
887     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
888         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
889         require(receiver != address(0), "ERC2981: invalid receiver");
890 
891         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
892     }
893 
894     /**
895      * @dev Removes default royalty information.
896      */
897     function _deleteDefaultRoyalty() internal virtual {
898         delete _defaultRoyaltyInfo;
899     }
900 
901     /**
902      * @dev Sets the royalty information for a specific token id, overriding the global default.
903      *
904      * Requirements:
905      *
906      * - `receiver` cannot be the zero address.
907      * - `feeNumerator` cannot be greater than the fee denominator.
908      */
909     function _setTokenRoyalty(
910         uint256 tokenId,
911         address receiver,
912         uint96 feeNumerator
913     ) internal virtual {
914         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
915         require(receiver != address(0), "ERC2981: Invalid parameters");
916 
917         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
918     }
919 
920     /**
921      * @dev Resets royalty information for the token id back to the global default.
922      */
923     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
924         delete _tokenRoyaltyInfo[tokenId];
925     }
926 }
927 
928 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
929 
930 
931 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
932 
933 pragma solidity ^0.8.0;
934 
935 
936 /**
937  * @dev Required interface of an ERC721 compliant contract.
938  */
939 interface IERC721 is IERC165 {
940     /**
941      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
942      */
943     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
944 
945     /**
946      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
947      */
948     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
949 
950     /**
951      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
952      */
953     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
954 
955     /**
956      * @dev Returns the number of tokens in ``owner``'s account.
957      */
958     function balanceOf(address owner) external view returns (uint256 balance);
959 
960     /**
961      * @dev Returns the owner of the `tokenId` token.
962      *
963      * Requirements:
964      *
965      * - `tokenId` must exist.
966      */
967     function ownerOf(uint256 tokenId) external view returns (address owner);
968 
969     /**
970      * @dev Safely transfers `tokenId` token from `from` to `to`.
971      *
972      * Requirements:
973      *
974      * - `from` cannot be the zero address.
975      * - `to` cannot be the zero address.
976      * - `tokenId` token must exist and be owned by `from`.
977      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
978      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
979      *
980      * Emits a {Transfer} event.
981      */
982     function safeTransferFrom(
983         address from,
984         address to,
985         uint256 tokenId,
986         bytes calldata data
987     ) external;
988 
989     /**
990      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
991      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
992      *
993      * Requirements:
994      *
995      * - `from` cannot be the zero address.
996      * - `to` cannot be the zero address.
997      * - `tokenId` token must exist and be owned by `from`.
998      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
999      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function safeTransferFrom(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) external;
1008 
1009     /**
1010      * @dev Transfers `tokenId` token from `from` to `to`.
1011      *
1012      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1013      *
1014      * Requirements:
1015      *
1016      * - `from` cannot be the zero address.
1017      * - `to` cannot be the zero address.
1018      * - `tokenId` token must be owned by `from`.
1019      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function transferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) external;
1028 
1029     /**
1030      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1031      * The approval is cleared when the token is transferred.
1032      *
1033      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1034      *
1035      * Requirements:
1036      *
1037      * - The caller must own the token or be an approved operator.
1038      * - `tokenId` must exist.
1039      *
1040      * Emits an {Approval} event.
1041      */
1042     function approve(address to, uint256 tokenId) external;
1043 
1044     /**
1045      * @dev Approve or remove `operator` as an operator for the caller.
1046      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1047      *
1048      * Requirements:
1049      *
1050      * - The `operator` cannot be the caller.
1051      *
1052      * Emits an {ApprovalForAll} event.
1053      */
1054     function setApprovalForAll(address operator, bool _approved) external;
1055 
1056     /**
1057      * @dev Returns the account approved for `tokenId` token.
1058      *
1059      * Requirements:
1060      *
1061      * - `tokenId` must exist.
1062      */
1063     function getApproved(uint256 tokenId) external view returns (address operator);
1064 
1065     /**
1066      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1067      *
1068      * See {setApprovalForAll}
1069      */
1070     function isApprovedForAll(address owner, address operator) external view returns (bool);
1071 }
1072 
1073 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1074 
1075 
1076 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1077 
1078 pragma solidity ^0.8.0;
1079 
1080 
1081 /**
1082  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1083  * @dev See https://eips.ethereum.org/EIPS/eip-721
1084  */
1085 interface IERC721Enumerable is IERC721 {
1086     /**
1087      * @dev Returns the total amount of tokens stored by the contract.
1088      */
1089     function totalSupply() external view returns (uint256);
1090 
1091     /**
1092      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1093      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1094      */
1095     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1096 
1097     /**
1098      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1099      * Use along with {totalSupply} to enumerate all tokens.
1100      */
1101     function tokenByIndex(uint256 index) external view returns (uint256);
1102 }
1103 
1104 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1105 
1106 
1107 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1108 
1109 pragma solidity ^0.8.0;
1110 
1111 
1112 /**
1113  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1114  * @dev See https://eips.ethereum.org/EIPS/eip-721
1115  */
1116 interface IERC721Metadata is IERC721 {
1117     /**
1118      * @dev Returns the token collection name.
1119      */
1120     function name() external view returns (string memory);
1121 
1122     /**
1123      * @dev Returns the token collection symbol.
1124      */
1125     function symbol() external view returns (string memory);
1126 
1127     /**
1128      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1129      */
1130     function tokenURI(uint256 tokenId) external view returns (string memory);
1131 }
1132 
1133 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1134 
1135 
1136 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1137 
1138 pragma solidity ^0.8.0;
1139 
1140 
1141 
1142 
1143 
1144 
1145 
1146 
1147 /**
1148  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1149  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1150  * {ERC721Enumerable}.
1151  */
1152 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1153     using Address for address;
1154     using Strings for uint256;
1155 
1156     // Token name
1157     string private _name;
1158 
1159     // Token symbol
1160     string private _symbol;
1161 
1162     // Mapping from token ID to owner address
1163     mapping(uint256 => address) private _owners;
1164 
1165     // Mapping owner address to token count
1166     mapping(address => uint256) private _balances;
1167 
1168     // Mapping from token ID to approved address
1169     mapping(uint256 => address) private _tokenApprovals;
1170 
1171     // Mapping from owner to operator approvals
1172     mapping(address => mapping(address => bool)) private _operatorApprovals;
1173 
1174     /**
1175      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1176      */
1177     constructor(string memory name_, string memory symbol_) {
1178         _name = name_;
1179         _symbol = symbol_;
1180     }
1181 
1182     /**
1183      * @dev See {IERC165-supportsInterface}.
1184      */
1185     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1186         return
1187             interfaceId == type(IERC721).interfaceId ||
1188             interfaceId == type(IERC721Metadata).interfaceId ||
1189             super.supportsInterface(interfaceId);
1190     }
1191 
1192     /**
1193      * @dev See {IERC721-balanceOf}.
1194      */
1195     function balanceOf(address owner) public view virtual override returns (uint256) {
1196         require(owner != address(0), "ERC721: address zero is not a valid owner");
1197         return _balances[owner];
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-ownerOf}.
1202      */
1203     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1204         address owner = _owners[tokenId];
1205         require(owner != address(0), "ERC721: invalid token ID");
1206         return owner;
1207     }
1208 
1209     /**
1210      * @dev See {IERC721Metadata-name}.
1211      */
1212     function name() public view virtual override returns (string memory) {
1213         return _name;
1214     }
1215 
1216     /**
1217      * @dev See {IERC721Metadata-symbol}.
1218      */
1219     function symbol() public view virtual override returns (string memory) {
1220         return _symbol;
1221     }
1222 
1223     /**
1224      * @dev See {IERC721Metadata-tokenURI}.
1225      */
1226     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1227         _requireMinted(tokenId);
1228 
1229         string memory baseURI = _baseURI();
1230         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1231     }
1232 
1233     /**
1234      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1235      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1236      * by default, can be overridden in child contracts.
1237      */
1238     function _baseURI() internal view virtual returns (string memory) {
1239         return "";
1240     }
1241 
1242     /**
1243      * @dev See {IERC721-approve}.
1244      */
1245     function approve(address to, uint256 tokenId) public virtual override {
1246         address owner = ERC721.ownerOf(tokenId);
1247         require(to != owner, "ERC721: approval to current owner");
1248 
1249         require(
1250             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1251             "ERC721: approve caller is not token owner nor approved for all"
1252         );
1253 
1254         _approve(to, tokenId);
1255     }
1256 
1257     /**
1258      * @dev See {IERC721-getApproved}.
1259      */
1260     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1261         _requireMinted(tokenId);
1262 
1263         return _tokenApprovals[tokenId];
1264     }
1265 
1266     /**
1267      * @dev See {IERC721-setApprovalForAll}.
1268      */
1269     function setApprovalForAll(address operator, bool approved) public virtual override {
1270         _setApprovalForAll(_msgSender(), operator, approved);
1271     }
1272 
1273     /**
1274      * @dev See {IERC721-isApprovedForAll}.
1275      */
1276     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1277         return _operatorApprovals[owner][operator];
1278     }
1279 
1280     /**
1281      * @dev See {IERC721-transferFrom}.
1282      */
1283     function transferFrom(
1284         address from,
1285         address to,
1286         uint256 tokenId
1287     ) public virtual override {
1288         //solhint-disable-next-line max-line-length
1289         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1290 
1291         _transfer(from, to, tokenId);
1292     }
1293 
1294     /**
1295      * @dev See {IERC721-safeTransferFrom}.
1296      */
1297     function safeTransferFrom(
1298         address from,
1299         address to,
1300         uint256 tokenId
1301     ) public virtual override {
1302         safeTransferFrom(from, to, tokenId, "");
1303     }
1304 
1305     /**
1306      * @dev See {IERC721-safeTransferFrom}.
1307      */
1308     function safeTransferFrom(
1309         address from,
1310         address to,
1311         uint256 tokenId,
1312         bytes memory data
1313     ) public virtual override {
1314         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1315         _safeTransfer(from, to, tokenId, data);
1316     }
1317 
1318     /**
1319      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1320      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1321      *
1322      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1323      *
1324      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1325      * implement alternative mechanisms to perform token transfer, such as signature-based.
1326      *
1327      * Requirements:
1328      *
1329      * - `from` cannot be the zero address.
1330      * - `to` cannot be the zero address.
1331      * - `tokenId` token must exist and be owned by `from`.
1332      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1333      *
1334      * Emits a {Transfer} event.
1335      */
1336     function _safeTransfer(
1337         address from,
1338         address to,
1339         uint256 tokenId,
1340         bytes memory data
1341     ) internal virtual {
1342         _transfer(from, to, tokenId);
1343         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1344     }
1345 
1346     /**
1347      * @dev Returns whether `tokenId` exists.
1348      *
1349      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1350      *
1351      * Tokens start existing when they are minted (`_mint`),
1352      * and stop existing when they are burned (`_burn`).
1353      */
1354     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1355         return _owners[tokenId] != address(0);
1356     }
1357 
1358     /**
1359      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1360      *
1361      * Requirements:
1362      *
1363      * - `tokenId` must exist.
1364      */
1365     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1366         address owner = ERC721.ownerOf(tokenId);
1367         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1368     }
1369 
1370     /**
1371      * @dev Safely mints `tokenId` and transfers it to `to`.
1372      *
1373      * Requirements:
1374      *
1375      * - `tokenId` must not exist.
1376      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1377      *
1378      * Emits a {Transfer} event.
1379      */
1380     function _safeMint(address to, uint256 tokenId) internal virtual {
1381         _safeMint(to, tokenId, "");
1382     }
1383 
1384     /**
1385      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1386      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1387      */
1388     function _safeMint(
1389         address to,
1390         uint256 tokenId,
1391         bytes memory data
1392     ) internal virtual {
1393         _mint(to, tokenId);
1394         require(
1395             _checkOnERC721Received(address(0), to, tokenId, data),
1396             "ERC721: transfer to non ERC721Receiver implementer"
1397         );
1398     }
1399 
1400     /**
1401      * @dev Mints `tokenId` and transfers it to `to`.
1402      *
1403      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1404      *
1405      * Requirements:
1406      *
1407      * - `tokenId` must not exist.
1408      * - `to` cannot be the zero address.
1409      *
1410      * Emits a {Transfer} event.
1411      */
1412     function _mint(address to, uint256 tokenId) internal virtual {
1413         require(to != address(0), "ERC721: mint to the zero address");
1414         require(!_exists(tokenId), "ERC721: token already minted");
1415 
1416         _beforeTokenTransfer(address(0), to, tokenId);
1417 
1418         _balances[to] += 1;
1419         _owners[tokenId] = to;
1420 
1421         emit Transfer(address(0), to, tokenId);
1422 
1423         _afterTokenTransfer(address(0), to, tokenId);
1424     }
1425 
1426     /**
1427      * @dev Destroys `tokenId`.
1428      * The approval is cleared when the token is burned.
1429      *
1430      * Requirements:
1431      *
1432      * - `tokenId` must exist.
1433      *
1434      * Emits a {Transfer} event.
1435      */
1436     function _burn(uint256 tokenId) internal virtual {
1437         address owner = ERC721.ownerOf(tokenId);
1438 
1439         _beforeTokenTransfer(owner, address(0), tokenId);
1440 
1441         // Clear approvals
1442         _approve(address(0), tokenId);
1443 
1444         _balances[owner] -= 1;
1445         delete _owners[tokenId];
1446 
1447         emit Transfer(owner, address(0), tokenId);
1448 
1449         _afterTokenTransfer(owner, address(0), tokenId);
1450     }
1451 
1452     /**
1453      * @dev Transfers `tokenId` from `from` to `to`.
1454      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1455      *
1456      * Requirements:
1457      *
1458      * - `to` cannot be the zero address.
1459      * - `tokenId` token must be owned by `from`.
1460      *
1461      * Emits a {Transfer} event.
1462      */
1463     function _transfer(
1464         address from,
1465         address to,
1466         uint256 tokenId
1467     ) internal virtual {
1468         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1469         require(to != address(0), "ERC721: transfer to the zero address");
1470 
1471         _beforeTokenTransfer(from, to, tokenId);
1472 
1473         // Clear approvals from the previous owner
1474         _approve(address(0), tokenId);
1475 
1476         _balances[from] -= 1;
1477         _balances[to] += 1;
1478         _owners[tokenId] = to;
1479 
1480         emit Transfer(from, to, tokenId);
1481 
1482         _afterTokenTransfer(from, to, tokenId);
1483     }
1484 
1485     /**
1486      * @dev Approve `to` to operate on `tokenId`
1487      *
1488      * Emits an {Approval} event.
1489      */
1490     function _approve(address to, uint256 tokenId) internal virtual {
1491         _tokenApprovals[tokenId] = to;
1492         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1493     }
1494 
1495     /**
1496      * @dev Approve `operator` to operate on all of `owner` tokens
1497      *
1498      * Emits an {ApprovalForAll} event.
1499      */
1500     function _setApprovalForAll(
1501         address owner,
1502         address operator,
1503         bool approved
1504     ) internal virtual {
1505         require(owner != operator, "ERC721: approve to caller");
1506         _operatorApprovals[owner][operator] = approved;
1507         emit ApprovalForAll(owner, operator, approved);
1508     }
1509 
1510     /**
1511      * @dev Reverts if the `tokenId` has not been minted yet.
1512      */
1513     function _requireMinted(uint256 tokenId) internal view virtual {
1514         require(_exists(tokenId), "ERC721: invalid token ID");
1515     }
1516 
1517     /**
1518      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1519      * The call is not executed if the target address is not a contract.
1520      *
1521      * @param from address representing the previous owner of the given token ID
1522      * @param to target address that will receive the tokens
1523      * @param tokenId uint256 ID of the token to be transferred
1524      * @param data bytes optional data to send along with the call
1525      * @return bool whether the call correctly returned the expected magic value
1526      */
1527     function _checkOnERC721Received(
1528         address from,
1529         address to,
1530         uint256 tokenId,
1531         bytes memory data
1532     ) private returns (bool) {
1533         if (to.isContract()) {
1534             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1535                 return retval == IERC721Receiver.onERC721Received.selector;
1536             } catch (bytes memory reason) {
1537                 if (reason.length == 0) {
1538                     revert("ERC721: transfer to non ERC721Receiver implementer");
1539                 } else {
1540                     /// @solidity memory-safe-assembly
1541                     assembly {
1542                         revert(add(32, reason), mload(reason))
1543                     }
1544                 }
1545             }
1546         } else {
1547             return true;
1548         }
1549     }
1550 
1551     /**
1552      * @dev Hook that is called before any token transfer. This includes minting
1553      * and burning.
1554      *
1555      * Calling conditions:
1556      *
1557      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1558      * transferred to `to`.
1559      * - When `from` is zero, `tokenId` will be minted for `to`.
1560      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1561      * - `from` and `to` are never both zero.
1562      *
1563      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1564      */
1565     function _beforeTokenTransfer(
1566         address from,
1567         address to,
1568         uint256 tokenId
1569     ) internal virtual {}
1570 
1571     /**
1572      * @dev Hook that is called after any transfer of tokens. This includes
1573      * minting and burning.
1574      *
1575      * Calling conditions:
1576      *
1577      * - when `from` and `to` are both non-zero.
1578      * - `from` and `to` are never both zero.
1579      *
1580      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1581      */
1582     function _afterTokenTransfer(
1583         address from,
1584         address to,
1585         uint256 tokenId
1586     ) internal virtual {}
1587 }
1588 
1589 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1590 
1591 
1592 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1593 
1594 pragma solidity ^0.8.0;
1595 
1596 
1597 
1598 /**
1599  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1600  * enumerability of all the token ids in the contract as well as all token ids owned by each
1601  * account.
1602  */
1603 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1604     // Mapping from owner to list of owned token IDs
1605     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1606 
1607     // Mapping from token ID to index of the owner tokens list
1608     mapping(uint256 => uint256) private _ownedTokensIndex;
1609 
1610     // Array with all token ids, used for enumeration
1611     uint256[] private _allTokens;
1612 
1613     // Mapping from token id to position in the allTokens array
1614     mapping(uint256 => uint256) private _allTokensIndex;
1615 
1616     /**
1617      * @dev See {IERC165-supportsInterface}.
1618      */
1619     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1620         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1621     }
1622 
1623     /**
1624      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1625      */
1626     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1627         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1628         return _ownedTokens[owner][index];
1629     }
1630 
1631     /**
1632      * @dev See {IERC721Enumerable-totalSupply}.
1633      */
1634     function totalSupply() public view virtual override returns (uint256) {
1635         return _allTokens.length;
1636     }
1637 
1638     /**
1639      * @dev See {IERC721Enumerable-tokenByIndex}.
1640      */
1641     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1642         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1643         return _allTokens[index];
1644     }
1645 
1646     /**
1647      * @dev Hook that is called before any token transfer. This includes minting
1648      * and burning.
1649      *
1650      * Calling conditions:
1651      *
1652      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1653      * transferred to `to`.
1654      * - When `from` is zero, `tokenId` will be minted for `to`.
1655      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1656      * - `from` cannot be the zero address.
1657      * - `to` cannot be the zero address.
1658      *
1659      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1660      */
1661     function _beforeTokenTransfer(
1662         address from,
1663         address to,
1664         uint256 tokenId
1665     ) internal virtual override {
1666         super._beforeTokenTransfer(from, to, tokenId);
1667 
1668         if (from == address(0)) {
1669             _addTokenToAllTokensEnumeration(tokenId);
1670         } else if (from != to) {
1671             _removeTokenFromOwnerEnumeration(from, tokenId);
1672         }
1673         if (to == address(0)) {
1674             _removeTokenFromAllTokensEnumeration(tokenId);
1675         } else if (to != from) {
1676             _addTokenToOwnerEnumeration(to, tokenId);
1677         }
1678     }
1679 
1680     /**
1681      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1682      * @param to address representing the new owner of the given token ID
1683      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1684      */
1685     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1686         uint256 length = ERC721.balanceOf(to);
1687         _ownedTokens[to][length] = tokenId;
1688         _ownedTokensIndex[tokenId] = length;
1689     }
1690 
1691     /**
1692      * @dev Private function to add a token to this extension's token tracking data structures.
1693      * @param tokenId uint256 ID of the token to be added to the tokens list
1694      */
1695     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1696         _allTokensIndex[tokenId] = _allTokens.length;
1697         _allTokens.push(tokenId);
1698     }
1699 
1700     /**
1701      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1702      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1703      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1704      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1705      * @param from address representing the previous owner of the given token ID
1706      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1707      */
1708     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1709         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1710         // then delete the last slot (swap and pop).
1711 
1712         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1713         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1714 
1715         // When the token to delete is the last token, the swap operation is unnecessary
1716         if (tokenIndex != lastTokenIndex) {
1717             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1718 
1719             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1720             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1721         }
1722 
1723         // This also deletes the contents at the last position of the array
1724         delete _ownedTokensIndex[tokenId];
1725         delete _ownedTokens[from][lastTokenIndex];
1726     }
1727 
1728     /**
1729      * @dev Private function to remove a token from this extension's token tracking data structures.
1730      * This has O(1) time complexity, but alters the order of the _allTokens array.
1731      * @param tokenId uint256 ID of the token to be removed from the tokens list
1732      */
1733     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1734         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1735         // then delete the last slot (swap and pop).
1736 
1737         uint256 lastTokenIndex = _allTokens.length - 1;
1738         uint256 tokenIndex = _allTokensIndex[tokenId];
1739 
1740         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1741         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1742         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1743         uint256 lastTokenId = _allTokens[lastTokenIndex];
1744 
1745         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1746         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1747 
1748         // This also deletes the contents at the last position of the array
1749         delete _allTokensIndex[tokenId];
1750         _allTokens.pop();
1751     }
1752 }
1753 
1754 // File: contracts/2_Owner.sol
1755 
1756 
1757 pragma solidity ^0.8.13;
1758 
1759 
1760 /// @title An ERC721 Collection for DREAM3 Genesis Pass
1761 /// @author Wipiway.eth 
1762 contract Dream3 is ERC721Enumerable,Ownable,ReentrancyGuard,ERC2981  {
1763     using Strings for uint256;
1764 
1765     uint256 public constant NFT_COLLECTION_MAX = 2222;
1766     uint256 public constant RESERVE_TOKEN = 30;
1767 
1768     uint256 public mintCount = 0;
1769     mapping(address => bool) private userMinted;
1770 
1771     string private _tokenBaseURI = "";
1772     string private _tokenRevealedBaseURI = "";
1773 
1774     // If isLive = true && isPublicFlag = false |==> whitelistPhase
1775     bool public isPublicFlag = false;
1776     bool public isLiveFlag = false;
1777 
1778     bytes32 public merkleroot;
1779     // string public PROVENANCE_HASH = "";
1780 
1781     address private teamWallet;
1782 
1783     /****************
1784         MODIFIERS
1785     ******************/
1786 
1787     modifier isLive() {
1788       require(
1789         isLiveFlag, "Mint is not live"
1790       );
1791       _;
1792     }
1793 
1794     modifier isPublic() {
1795       require(
1796         isPublicFlag, "Not in public stage"
1797       );
1798       _;
1799     }
1800 
1801     modifier canMint() {
1802       require(
1803         userMinted[msg.sender] == false, "Previously minted"
1804       );
1805       require(
1806             mintCount < NFT_COLLECTION_MAX,
1807             "Not enough NFTs remain"
1808       );
1809       _;
1810     }
1811 
1812     /**
1813     @notice constructor
1814     @dev Initializes the contract with the withdrawalWallet address and the provenance hash
1815     @param _teamWallet address of the wallet for royalties and ReserveTokens
1816      */    
1817     constructor(
1818         address _teamWallet
1819     ) ERC721("Dream3", "DRM3") {
1820         teamWallet = _teamWallet;
1821     }
1822 
1823     /**
1824     @notice setMerkelRoot
1825     @dev Sets the merkle root
1826     @param root bytes32 merkle root
1827      */
1828     function setMerkleRoot(bytes32 root) external onlyOwner {
1829         merkleroot = root;
1830     }
1831 
1832     /**
1833     @notice whitelistMint
1834     @dev Mints a token for a whitelisted user
1835     @param proof bytes32 proof of Merkle tree
1836      */
1837     function whitelistMint(bytes32[] calldata proof) 
1838         isLive 
1839         canMint
1840         external 
1841         nonReentrant {  // check if nonReentrant is needed. No external call being done.
1842         
1843         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1844         require(MerkleProof.verify(proof, merkleroot, leaf), "Invalid Merkle Proof");
1845         
1846         mintCount++;
1847         _mint(msg.sender, mintCount);
1848         userMinted[msg.sender] = true;
1849     }
1850 
1851     /**
1852     @notice publicMint
1853     @dev Mints a token for anyone who calls
1854      */
1855     function publicMint() 
1856         isLive 
1857         isPublic
1858         canMint
1859         external 
1860         nonReentrant {  // check if nonReentrant is needed. No external call being done.
1861 
1862         mintCount++;
1863         _mint(msg.sender, mintCount);
1864         userMinted[msg.sender] = true;
1865     }
1866 
1867     /**
1868     @notice reserveTokensForTeam
1869     @dev Reserves tokens for a team to withdrawlWallet
1870      */
1871     function reserveTokensForTeam() external onlyOwner{
1872         require(
1873             mintCount + RESERVE_TOKEN <= NFT_COLLECTION_MAX,
1874             "Not enough NFTs remain"
1875         );
1876 
1877         for (uint256 i = 0; i < RESERVE_TOKEN; i++) {
1878             mintCount++;
1879             _mint(teamWallet, mintCount);
1880         }
1881     }
1882 
1883     /**
1884     @notice toggleLive
1885     @dev toggle the sale stage b/w NOTLIVE <=> PUBLICSALE
1886     */
1887     function toggleLive() external onlyOwner {
1888         isLiveFlag = !isLiveFlag;
1889     }
1890 
1891     /**
1892     @notice togglePublic
1893     @dev toggle the sale stage b/w Public <> Not public
1894     */
1895     function togglePublic() external onlyOwner {
1896         isPublicFlag = !isPublicFlag;
1897     }
1898 
1899     /// @dev Sets token royalties
1900     /// @param recipient recipient of the royalties
1901     /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)
1902     function setRoyalties(address recipient, uint96 value) public onlyOwner {
1903         _setDefaultRoyalty(recipient, value);
1904     }
1905 
1906     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable, ERC2981) returns (bool) {
1907         return super.supportsInterface(interfaceId);
1908     }
1909 
1910     /** @dev Contract-level metadata for OpenSea. */
1911     // Update for collection-specific metadata.
1912     function contractURI() public view returns (string memory) {
1913         return "ipfs://QmZtGgwPwhub5oQ8VaGZVJyxmU2y5YGbh7u7HueYaY7y8N"; // Contract-level metadata for Chibi.
1914     }
1915 
1916     /**
1917     @notice withdraw
1918     @dev Withdraws the funds to the teamWallet
1919     */
1920     function withdraw() external {
1921         (bool _success, ) = (teamWallet).call{ value: address(this).balance }("");
1922         require (_success, "Could not withdraw");
1923     }
1924 
1925     /**
1926     @notice setTokenBaseURI
1927     @dev Sets the base URI for the token
1928     @param newBaseURI string base URI for the token
1929      */
1930     function setTokenBaseURI(string calldata newBaseURI) external onlyOwner {
1931         _tokenBaseURI = newBaseURI;
1932     }
1933 
1934     /**
1935     @notice setTokenRevealedBaseURI
1936     @dev Sets the base URI for the token
1937     @param _revealedBaseURI string base URI for the token
1938      */
1939     function setTokenRevealedBaseURI(string calldata _revealedBaseURI)
1940         external
1941         onlyOwner
1942     {
1943         _tokenRevealedBaseURI = _revealedBaseURI;
1944     }
1945 
1946     /**
1947     @notice tokenURI
1948     @dev Returns the token URI
1949     @param _tokenId uint256 token ID
1950     */
1951     function tokenURI(uint256 _tokenId)
1952         public
1953         view
1954         override(ERC721)
1955         returns (string memory)
1956     {
1957         require(_exists(_tokenId), "Token does not exist");
1958 
1959         /// @dev Convert string to bytes so we can check if it's empty or not.
1960         return
1961             bytes(_tokenRevealedBaseURI).length > 0
1962                 ? string(
1963                     abi.encodePacked(_tokenRevealedBaseURI, _tokenId.toString())
1964                 )
1965                 : _tokenBaseURI;
1966     }
1967 }